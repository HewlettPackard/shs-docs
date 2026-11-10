# Memory cache monitor selection

NICs that offload RDMA operations, such as the HPE Slingshot NIC, can read and write directly from host memory without host-CPU involvement or memory copies. Extensive software interaction among Linux, Libfabric, and the `cxi` provider is required to make this work properly and efficiently.

To succeed, the NIC must be able to read and write the current memory location with fresh data that is not changed by other code.
To use RDMA, Libfabric provides mechanisms for the application to register memory and set up a specific memory location for RDMA operations.

Registration creates a contiguous block of memory to use for communications with the protections and mapping needed for NIC hardware access. The `cxi` provider requires registered memory for RDMA.

To achieve good RDMA performance, caching memory registrations is important because registration is costly in terms of overhead.
The memory registration cache reduces the overhead of repeatedly registering and deregistering memory when the cached copy is still current.

Libfabric also provides extensive support for memory registration caching because it is common for software to register the same memory sections during an application run.
Ensuring the data in the MR cache remains fresh is the role of the memory registration cache monitor. Libfabric supports several monitor methods, each selected using the `FI_MR_CACHE_MONITOR` environment variable.

## `FI_MR_CACHE_MONITOR`

Use the `FI_MR_CACHE_MONITOR` environment variable to select the memory registration cache monitor: `userfaultfd`, `memhooks`, or `kdreg2`.

Starting with SHS 15.0.0, `kdreg2` is the default and preferred setting for the CXI provider.
Older SHS releases default to `memhooks` because of its wide availability. Applications running NCCL or RCCL should use `userfaultfd` or `kdreg2`; avoid `memhooks`, which can deadlock with GPU memory allocation patterns.

- `userfaultfd` (or `uffd`)
  
  Delivered as part of Linux operating system distributions, `userfaultfd` is a kernel service for tracking memory mapping changes. It uses a file descriptor for communication, which introduces a delay between the detection of changes to the memory layout and acknowledgment within Libfabric.
  This delay can lead to memory corruption because scenarios such as allocation-free-reallocation of the same address in user space are not resolvable. `userfaultfd` is also constrained to operating on page-aligned full-page regions, making it unsuitable for many data layouts used by SHMEM applications.

- `memhooks`
  
  Distributed as part of Libfabric. Unlike `uffd`, `memhooks` is a user-space function which traps library functions for memory allocation or deallocation.
  
  `memhooks` is set up primarily to monitor dynamic memory allocations, such as applications using `mmap` and `brk` memory functions. It cannot monitor stack or static allocations, and hook instantiation depends on load order, linker directives, and related runtime behavior. It can deadlock if code frees memory in patterns commonly seen with GPU-style programming models.

- `kdreg2`
  
  This is the default memory cache monitor for the CXI provider.

  The purpose of `kdreg2` is to handle cases where `memhooks` and `userfaultfd` do not work reliably so that the application can still benefit from memory registration caching. `kdreg2` can monitor static, dynamic, and stack memory, supports arbitrary alignment, provides synchronous notification, and can use additional metadata to detect allocate, free, and reallocation scenarios.
  
  It must be installed into the host OS kernel at image creation time.

## Libfabric parameters for the memory registration cache

There are two Libfabric parameters for the memory registration cache that are commonly relevant:

- `FI_MR_CACHE_MAX_SIZE`: This environment variable specifies the maximum size, in bytes, of the cache maintained by the MR cache monitor. A setting of `-1` means that there is no maximum. The default in Libfabric is set to the system memory size divided by `cpu_cnt` and then divided by 2. HPE Cray Supercomputing Programming Environment (CPE) sets this to unlimited.
- `FI_MR_CACHE_MAX_COUNT`: This environment variable controls the maximum number of cached memory registrations that the MR cache monitor can maintain. The upstream Libfabric default is 1024. The summary table lists 4096 as the SHS 13.0 and later default, while HPE Cray CPE sets the value to 524288. MPI libraries and site modules may also override it, so check the configuration used by the application when tuning this limit.

One failure mode when the memory registration cache monitor is not working properly is deadlock.
If an application has problems, reduce `FI_MR_CACHE_MAX_COUNT` to `0`, which disables caching.
This causes the application to run more slowly, but if it avoids the problem (most often a deadlock), it may be a useful debug step. If performance is worse with caching enabled, increase the size of the memory registration cache.
