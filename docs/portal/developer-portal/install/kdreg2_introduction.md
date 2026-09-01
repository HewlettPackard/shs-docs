# `kdreg2`

Starting with SHS 15.0.0, HPE Slingshot uses `kdreg2` as the default memory registration cache monitor.
For older SHS releases, the default monitor is `memhooks` unless set otherwise with the appropriate Libfabric environment variable.
Also, HPE recommends using `userfaultfd` for applications that use NCCL or RCCL collectives libraries as they can hang at scale under `memhooks`.

## Background

High performance applications use Remote Direct Memory Access (RDMA), where the networking stack reads and writes data directly in application memory.
RDMA requires memory registration to translate virtual addresses, pin memory, and map memory regions to NIC hardware.

Libfabric provides a memory registration (MR) cache that reduces registration overhead by reusing previously registered memory regions.
It is most effective when applications repeatedly access the same regions.

MR caching is not always beneficial. Applications that register many unique regions or rarely reuse memory can incur cache overhead and cache thrashing. In these cases, tuning cache limits or disabling caching through libfabric environment variables may improve performance.

## Why the monitor matters

The MR cache depends on a monitor that detects memory map changes and invalidates stale cache entries.
If memory changes are not detected, RDMA operations can access the wrong physical memory, causing corruption, hangs, retries, or data transfer failures.

## Traditional monitor options

The traditional monitors in Libfabric are `userfaultfd` and `memhooks`.

- `userfaultfd`: A Linux kernel service that reports memory map changes through a file descriptor. It can monitor writable pages across a process address space, but notification is asynchronous and limited to page-granular behavior.
- `memhooks`: A user-space Libfabric mechanism that intercepts memory allocation and deallocation calls. It is synchronous, but coverage and reliability can depend on application load order, linker behavior, and allocation patterns.

Each traditional monitor has trade-offs. `memhooks` cannot fully cover stack or static allocations.
`userfaultfd` cannot resolve certain allocation/free/reallocation race scenarios and is constrained to page-aligned behavior, which can be problematic for some SHMEM layouts.

## Why use `kdreg2`

`kdreg2` was introduced to address these limitations without requiring per-application monitor selection. It is provided as a Linux kernel module and ships in the HPE Slingshot Host Software distribution.

`kdreg2` uses kernel mechanisms to synchronously detect and report memory map changes at byte granularity. Unlike `memhooks`, it can monitor both stack and heap memory. Unlike `userfaultfd`, it is not restricted to page-granular behavior.

One of `kdreg2`'s primary goals is to enable MR caching for applications that fail under `memhooks` and `userfaultfd`. HPE is unaware of any cases where `kdreg2` failed to detect a mapping change that resulted in a misdirected RDMA transfer. `kdreg2` has improved outcomes in deployed workloads, including weather forecasting codes.

## Cache sizing notes

Cache size remains a major performance factor when MR caching is enabled.
Libfabric defaults are conservative for broad environments; the CXI provider and higher-level communication stacks (for example, Cray MPI) may raise limits for large-scale systems.

If an application exhibits poor performance or deadlocks, review the memory monitor and cache-size settings together.
