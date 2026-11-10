# Hardware offloads

The HPE Slingshot NIC features advanced hardware offload capabilities that accelerate high performance computing (HPC) and AI workloads.
The hardware moves RDMA data directly to and from host or GPU memory using DMA, without involving the host CPU or intermediate host-memory copies, delivering the low latency that tightly synchronized workloads require.
It also handles protocol processing tasks such as message progression, message matching, large-message transfer, one-sided operations, dependency handling, and address translation. These capabilities further reduce latency and maximize overlap between computation and communication.

## Asynchronous message progression

After software posts commands to the NIC, the NIC can advance send and receive operations without continuous host CPU involvement. Applications and middleware can therefore issue many nonblocking operations while the NIC advances communication independently. For small messages, the NIC can place the payload directly into its command structures, further reducing host-side overhead.

## Tag-matching offload

The NIC includes hardware list-processing support for tagged message matching so it can match incoming messages with posted receives without requiring the CPU to walk software queues. This hardware supports both expected and unexpected message handling. When an application has already posted a matching receive, the NIC places data directly into the destination memory. When a message arrives before the application posts its receive, the NIC holds the unexpected message in hardware-assisted overflow storage until software posts the corresponding receive. This offload especially benefits Message Passing Interface (MPI)-style messaging because it reduces the CPU and memory-bandwidth overhead of host-based queue traversal.

## Rendezvous protocol offload for large messages

For larger messages, the NIC offloads rendezvous protocol handling. In this model, the initial control exchange establishes the payload destination, and the destination then uses RDMA Get operations to transfer the bulk data. This separation lets the fabric adaptively route large payload packets on a packet-by-packet basis while the NIC preserves the ordering and placement rules required by higher-level programming models such as MPI. The result is better scalability and bandwidth under congestion than sending the entire message along a single ordered path.

## Partitioned global address space (PGAS) and one-sided operation acceleration

For one-sided communication models, such as SHMEM puts, gets, and synchronization operations, the NIC provides a lighter-weight processing path than full two-sided message matching.
These operations use target-side lookup and hardware support for ordering, completion tracking, and atomic operations such as increment and compare-and-swap.
This approach reduces latency and host overhead for PGAS-style programming models.

## Address Translation Unit (ATU)

The NIC's ATU offloads address translation for RDMA access to CPU and graphics processing unit (GPU) memory. It translates virtual addresses to physical addresses and caches translations on the NIC so repeated accesses can proceed with low overhead. This capability is especially important for fine-grained RDMA operations and applications that frequently reuse registered memory because it reduces latency and avoids repeated use of host-side translation mechanisms.

## Additional hardware offload considerations

Hardware offload capabilities are fundamental to HPE Slingshot NIC performance, but hardware resources are finite. In some scenarios, users and administrators must manage or fine-tune how the system allocates and uses these resources. Proper resource management helps applications fully use the NICs offload features without running into bottlenecks or contention, enabling workload-specific performance optimization. This document explains these considerations for users and administrators.

This guide does not cover it extensively, but some deployments can use another capability that moves collective operations from host CPUs and NICs to switch-resident logic. This capability reduces latency and synchronizes certain small-message collectives. The system administrator must enable this offload because it requires coordination among the switch and NIC software, job scheduler software, and MPI configuration.
