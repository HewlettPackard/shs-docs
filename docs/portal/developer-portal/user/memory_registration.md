# Memory registration and address translation

In RDMA, the NIC performs direct memory access (DMA) to and from application buffers only after the system makes those buffers safe for device access.
Libfabric memory registration tells the NIC that an application will use a specific virtual address range in CPU or GPU memory for RDMA.
The registration translates virtual addresses into physical addresses and, by default, pins the relevant pages so the operating system cannot move them during the transfer. (With on-demand paging (ODP) enabled, CPU-memory pages can remain unpinned; device memory is always pinned.)
With HPE Slingshot, the Libfabric provider performs this work automatically. The provider registers local buffers through the Libfabric memory registration cache.
The registration establishes device-accessible mappings and access permissions, allowing the NIC to DMA directly to and from the buffer without copying. The provider may copy small inject payloads through a bounce buffer, but large transfers are zero-copy.
In the default NTA mode, the NIC performs address translation on the device by using a page table that the driver provides. In ATS mode, translation is performed through the CPU's IOMMU instead.

Libfabric does not require providers to register memory automatically, so other Libfabric-enabled NICs may use a different approach.
Applications or middleware can also register memory explicitly.
Libfabric supports registration for both CPU and GPU memory.

Because registration and deregistration can be expensive, Libfabric uses a memory registration (MR) cache to reuse registrations when an application repeatedly uses the same buffers or overlapping ranges.
The cache can reuse a registration safely only while it matches the process's current memory map. For example, the process might free an address range and later reuse it for a different allocation.
Libfabric pairs the MR cache with a memory registration cache monitor to handle these changes.
The monitor detects changes to the memory map and invalidates cached registrations that the NIC can no longer safely reuse. For CPU memory, Libfabric provides several monitor choices, including `memhooks`, `userfaultfd`, and `kdreg2`, as discussed in the Libfabric sections of this guide.
