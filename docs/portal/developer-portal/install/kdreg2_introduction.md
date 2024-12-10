# Introduction

High performance applications use “Remote Direct Memory Access” (RDMA) in which the networking stack reads and writes data directly into application memory bypassing normal operating system protection mechanisms.
To orchestrate the transfer of data from the application space to the NIC, the memory ranges are “registered” with an operation that translates the virtual addresses into physical addresses and orchestrates the pinning of the relevant pages.
HPE Slingshot uses Libfabric as its basis for its communication libraries, and Libfabric manages the registration of RDMA memory regions.

On top of RDMA transfer capabilities, Libfabric implements a “memory registration cache.” This functionality provides an additional layer of performance by allowing the RDMA hardware to re-use previous registrations and avoid the associated computational cost.
This is especially effective for transfers which repeatedly use to the same pieces of memory and for applications which have a bounded number of transfer locations.

Caching of memory registrations (and the concomitant lazy de-registration) is not a panacea: applications which do not re-use memory locations for data transfer can needlessly incur cache management overhead and experience degraded performance.
Similarly, applications which attempt to register and use large numbers of memory regions may exceed the (finite) capacity of the cache and inadvertently encounter cache thrashing.
In these cases, the appropriate remedy may be to either disable the cache or increase the maximum size to match the I/O patterns.
Each of these remedies is available via Libfabric environment variables.

The Memory Registration Cache requires an associated entity to maintain accurate data in the cache.
The Memory Registration Cache Monitor watches for memory map changes that require it to then invalidate the appropriate cached memory registration entries. There are several different techniques which can be used to detect changes to the memory map.
This technique may or may not be effective for a specific application and its memory allocation strategies.
Libfabric supports the use of various memory registration cache monitors.

Effective monitoring of memory map changes is crucial for proper memory registration cache functionality.
Failure to detect changes can result in data transfer to physical memory which is now mapped elsewhere in the process, or even mapped to another process. The result is corruption.
The corruption can result in various execution failures such as, hangs due to smashed state, slow or stopped execution from excessive retries because some values being watched are not getting updated, or outright failure of the data transfer.

The traditional memory monitors provided with Libfabric are userfaultfd and memhooks.

- **userfaultfd**: This is a Linux Kernel service which gives user-space applications notifications about memory mapping changes via a well-known file descriptor. Userfaultfd operates on the page level and allows applications to monitor changes to all writable pages within the process’s virtual address space. The descriptor is queried and address ranges which match the userfaultfd events are purged from the memory registration cache.
- **memhooks**: This is a user-space subsystem distributed as part of Libfabric which traps library functions for memory allocation/deallocation call within an application. When an application allocates memory, memhooks tracks that memory and when deallocation occurs, it informs the memory registration cache to purge any corresponding entries. Memhooks monitors memory which has been dynamically allocated during the execution of the application.

Each of the traditional monitors has advantages and disadvantages. Memhooks are synchronous with the application but cannot monitor stack or static allocations, and the ability to monitor effectively can depend on load order, linker directives, and other application-specific attributes which affect the trapping mechanisms. Userfaultfd can monitor any page-aligned writable memory but cannot provide synchronous notification of memory changes; this means that allocating, freeing, and then reallocating the same address range is unresolvable and error prone. It also cannot monitor non-page aligned memory as is common in some HPC applications (specifically SHMEM).

By default, HPE Slingshot uses the memhooks monitor unless set otherwise with the appropriate Libfabric environment variable. Also, HPE guides to select userfaultfd for applications that use NCCL or RCCL collectives libraries as they can hang at scale under memhooks.

To overcome many of the previously described limitations as well as avoiding the need to configure this per-application, HPE introduced kdreg2 as a third memory cache monitor. kdreg2 is provided as a Linux kernel module and uses an open-source licensing model.
As of the date of this note, it ships in the HPE Slingshot Host Software distribution and is optionally installed.
Future releases may install this by default, and eventually HPE expects HPE Slingshot NIC Libfabric provider to select kdreg2 by default instead of memhooks.

kdreg2 uses kernel mechanisms to monitor mapping changes and provides synchronous notification to the memory registration cache. It can report changes at the byte level to any memory within the application’s virtual address space.
Unlike memhooks it can monitor stack and heap memory, and unlike userfaultfd it provides synchronous notification of changes and can monitor partial pages.

HPE knows of no cases where memory mapping changes are not detected by kdreg2 and which subsequently result in misdirected RDMA transfers.
On the contrary, one of the primary goals of kdreg2 is to enable the performance advantages of memory registration caching for those applications that fail with both memhooks and userfaultfd.
kdreg2 has been successfully deployed with enhanced performance for some weather forecasting codes which would otherwise fail using the traditional monitors.

There can be performance differences between the memory registration cache monitors as described above. In general, HPE has not characterized the range of applications to evaluate performance enhancement observed using kdreg2 versus memhooks and userfaultfd.
But in all cases the performance of successful execution with memory registration cache is substantial over execution without caching. kdreg2 is HPE’s solution to allow more applications to enjoy the benefits of memory registration cache.

The size of the memory registration cache is one of the most important parameters affecting performance when caching is employed. Since the primary users of Libfabric are communication collective libraries such as SHMEM and MPI, the user may not be aware of the presence of Libfabric nor of its configuration via environment variables. Users should be aware that the default values are set relatively low to accommodate development systems and non-supercomputer environments. It should be noted, however, that HPE communication collectives such as Cray MPI increase the size of the cache by default.

In summary, kdreg2 is available as an additional memory cache monitor that can enable applications that otherwise use memory registration caching to achieve a performance advantage.  
For sites that run a mix of HPC applications under the default memhooks while setting NCCL and RCCL applications to userfaultfd, setting the default configuration to kdreg2 may simplify operations by eliminating this per-application setting.
