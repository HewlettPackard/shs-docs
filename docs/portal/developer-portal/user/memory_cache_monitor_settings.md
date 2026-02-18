# Memory cache monitor settings

NICs that offload RDMA operations (like the HPE Slingshot NIC) enable writing and reading directly from the host memory without the host CPU involved and without memory copies. Extensive software interaction in Linux, Libfabric, and the cxi provider is needed to make this operation work properly and optimally.
To succeed, the NIC must be able to read and write to the current memory location with fresh data that is not changed by other code. To use RDMA, Libfabric provides mechanisms for the application to “register” memory to set up a specific memory location for RDMA operations.
Registration creates a contiguous block of memory to use for communications with the needed protections and mapping to the NIC hardware. The `cxi` provider requires registering memory to use RDMA.

To achieve good RDMA performance, caching memory registrations is important because the act of registering memory is costly in terms of overhead. The memory registration cache reduces the overhead of repeatedly registering and deregistering memory when the cached copy is current.
Libfabric also has extensive support for memory registration caching because it is common for software to register the same memory sections in the course of the application.
Ensuring the data in the MR cache is “fresh” is the role of the memory registration cache monitor. Libfabric supports several methods for monitoring the memory registration cache. These are selectable using the `FI_MR_CACHE_MONITOR` environment variable.

## `FI_MR_CACHE_MONITOR`

Use the `FI_MR_CACHE_MONITOR` environment variable to select the memory registration cache monitor: `userfaultfd`, `memhooks`, `kdreg2`.

`memhooks` is currently the default setting because of its wide availability, but it is not the best option for the CXI provider. Choose `kdreg2` whenever possible.
Applications running NCCL or RCCL require `userfaultfd`.

- `userfaultfd` (or `uffd`)
  
  Delivered as part of Linux operating system distributions. It is a kernel service for tracking memory mapping changes.`userfaultfd` uses a file descriptor for communication which introduces a delay between detection of changes to the memory layout and acknowledgment within Libfabric.
  This delay can provide for memory corrupting errors since scenarios such as allocation-free-reallocation of the same address in user space are unresolvable. `userfaultfd` is also constrained to operating on page-aligned, full page regions, making it unsuitable for data layout commonly found in applications which utilize SHMEM.

- `memhooks`
  
  Distributed as part of Libfabric. Unlike `uffd`, `memhooks` is a user-space function which traps library functions for memory allocation or deallocation.
  
  `memhooks` is set up primarily to monitor dynamic memory allocations, such as applications using `mmap` and `brk` memory functions. Downsides are that it cannot monitor stack allocations or static allocations. The hook instantiation is dependent on load order, linker directives, and so on It deadlocks if the code frees memory such is observed with GPU-style programming locks.

- `kdreg2`
  
  This is not installed by default, and HPE encourages system administrators to ensure that it is installed so that users can try it and see where it provides benefits and whether it can be a single cache monitor for all applications. Future releases of SHS will change the installation to be done by default, and will likely make this the default memory cache monitor in the future.

  The purpose of `kdreg2` is to overcome situations where `memhooks` and `uffd` both fail so that the application can achieve performance by utilizing caching. `kdreg2` is able to monitor static, dynamic, and stack memory. It can support arbitrary alignment. It provides synchronous notification mechanisms. And it can employ extra data to detect allocate/free/reallocate scenarios.
  
  It must be installed into the host OS kernel at image creation time.

## Libfabric parameters for the memory registration cache

There are two Libfabric parameters for the memory registration cache that are of note:

- `FI_MR_CACHE_MAX_SIZE`: This environment variable specifies the maximum size (in bytes) for the cache maintained by the MR Cache Monitor. A setting of `-1` means that there is no maximum. The default in Libfabric is set to the system memory size divided by `cpu_cnt` (the number of processors) divided by 2. HPE Cray Supercomputing Programming Environment (CPE) sets this to unlimited.
- `FI_MR_CACHE_MAX_COUNT`: This environment variable controls the maximum number of cached MRs that the MR Cache Monitor can maintain. The Libfabric default is 1024. In general, 1024 is too small and the recommendation is to increase this for most applications (For example, HPE Cray MPI). CPE sets this to 524288. The increases by the CPE software are to ensure better reuse of locations for RDMA operations when there is an active MR Cache, and avoids the performance hit of having a rotating list of locations which exceed the MR Cache limits.

One failure mode when the memory registration cache monitor is not working properly is deadlocks. If an application has problems, one can reduce the `FI_MR_CACHE_MAX_COUNT` to 0, which disables the caching.
This will cause the application to run slower, but if it avoids a problem – most frequently a deadlock – one can try a different monitor.
If performance is worse with cache enabled, then increase the size of the memory registration cache.
