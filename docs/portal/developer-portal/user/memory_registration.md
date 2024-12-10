# Memory registration

High-performance applications use Remote Direct Memory Access (RDMA), allowing the networking stack to read and write data directly into application memory, bypassing normal operating system protection mechanisms.
To facilitate data transfer from application space to the NIC, memory ranges are "registered" through an operation that translates virtual addresses into physical addresses and pins the relevant pages.

HPE Slingshot leverages Libfabric for its communication libraries, which manage the registration of RDMA memory regions.
Libfabric supports the registration of both CPU and GPU memory.

In addition to RDMA transfer capabilities, Libfabric implements a "memory registration cache."
This feature enhances performance by allowing RDMA hardware to reuse previous registrations, thereby reducing computational overhead. This is particularly effective for transfers that repeatedly use the same memory regions and for applications with a limited number of transfer locations.
However, different applications may require different caching optimizations that can impact performance. Libfabric environment variables can be used to tune caching behavior for specific applications.

The memory registration cache requires a mechanism to maintain accurate data.
The Memory Registration Cache Monitor tracks changes in the memory map and invalidates the appropriate cached memory registration entries as needed. Libfabric supports various memory registration cache monitors (`userfaultfd`, `memhooks`, and `kdreg2`), which use different techniques to detect changes in the memory map, accommodating application-specific memory allocation strategies.
These monitors and their associated environment variables are described in more detail in later sections of this document.
