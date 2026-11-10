# The HPE Slingshot RDMA transport

The HPE Slingshot NIC supports two networking paths:

- The Linux OS sends traffic from standard socket applications through the NIC's Ethernet interface
- RDMA applications use the optimized HPE Slingshot Transport (ST) stack

HPE’s Libfabric CXI provider exposes the ST RDMA protocol to applications.

The HPE Slingshot RDMA transport delivers RDMA at extreme scale without relying on connection-oriented constructs such as RoCE/InfiniBand (IB) queue pairs, which bind ordering, reliability, and connection state together.
Instead, ST uses a connectionless model that creates only minimal, ephemeral connection state. This model eliminates the persistent per-peer state that causes an explosion of per-peer-process state and associated memory consumption in conventional RDMA transports.
As a result, ST scales to large systems with millions of communicating endpoints. This connectionless design also forms the basis of the forthcoming Ultra-Ethernet Transport (UET), which largely mirrors the HPE Slingshot transport design.

One key aspect of this architecture is the protocols separation of reliability from ordering.
A dedicated reliability layer detects loss, triggers retries, and ensures forward progress independently of RDMA messaging semantics.
The protocol applies ordering, message boundaries, and idempotency only when the operation requires them. This decoupling lets the transport provide strong MPI-style semantics when needed while still supporting lightweight, unordered data movement for high-throughput or PGAS-style workloads.
Reliability mechanisms such as retries and backoff can operate transparently without forcing all traffic into an ordered, connection-bound model.

Within this framework, the ST transport utilizes the following RDMA transport semantics:

**Unrestricted transport** provides ordered, message-aware semantics suitable for MPI messaging, one-sided remote memory access (RMA), and atomic operations. It uses lightweight, ephemeral micro-connections to sequence packets belonging to a message and preserve ordering, creating a state only between actively communicating peers and tearing it down when idle.
Applications use this transport, for example, to ensure that MPI messages arrive in the correct order.

**Restricted transport** is a stateless, connectionless RDMA mode in which requests are unordered and do not consume target-side connection state. Put and Get operations are idempotent and can be replayed by the source retry handler after a response timeout, up to the retry limit. Restricted atomic memory operations are not replayed after a timeout because they are not idempotent, and instead report an error. Restricted requests normally do not generate target-side completion events, although locally managed buffers or a target-side error can generate one.
This model minimizes NIC state and hardware resource usage, making restricted transport well suited for scalable, unordered one-sided operations such as PGAS-style Put/Get, where higher-level software rather than the transport enforces ordering and message semantics.

Both transports provide reliable delivery through a request/response mechanism that tracks successful completion.
When a request fails because of a transient packet drop or an unhealthy target, lower-level hardware and software handle the exception through the retry handler service described later in this document. The NIC implements the mechanisms that support this service. The protocols also use fabric- and link-level enhancements to standard Ethernet, such as link-level retry, to reduce packet drops in the first place.
RDMA requests and responses run in independent traffic lanes, allowing the fabric to handle control messages and return data separately for better congestion management and more predictable performance.

When the protocol can tolerate out-of-order delivery, HPE Slingshots fine-grained adaptive routing lets each packet select the best path through the network. The network responds to congestion, maximizes bandwidth, and isolates application flows to prevent interference between jobs.
The RDMA protocol therefore supports adaptive routing by design. The unrestricted transport ensures ordered requests but allows unordered responses, while restricted transport operates entirely unordered. This co-optimization is especially clear during large data transfers that use the rendezvous protocol: GET operations retrieve the bulk data, travel adaptively, and may arrive out of order. Because the control headers remain ordered, the transfer improves throughput without sacrificing correctness.
Unlike traditional fabrics, HPE Slingshot does not enable adaptive routing through a network setting; protocol selection determines how the transport uses it. Although the dragonfly topology can connect any two endpoints with no more than three switch-to-switch hops, adaptive routing may send packets along non-minimal routes. These routes can increase the hop count, but they avoid mid-fabric congestion hotspots and maintain high bandwidth and network utilization.

The following table illustrates practical examples:

**RDMA traffic ordering and adaptive routing examples:**

|**Operation / Traffic Type**|**Ordered - Per-Flow Adaptive Routing**|**Unordered - Per-Packet Adaptive Routing**|
|---|---|---|
|MPI message headers|MPI semantics require message ordering between two points. Message headers (and a small amount of data) are sent in order. Many MPI messages will be in new flows, for example, whenever there is a gap of more than a few microseconds in messages to the same destination.|&nbsp;|
|MPI bulk data transfers|&nbsp;|Once an MPI message has been matched, the bulk data transfer can be unordered because it is delivered using the GET mechanism of the rendezvous protocol, which uses the response channel.|
|SHMEM and MPI-3 RMA|Some special cases, such as put-with-signal and reliable AMOs, use the unrestricted protocol that uses ordered delivery.|Put/Get use a sequence of unordered single-packet operations. Address ordering is implemented using a fence.|
|Lustre bulk data transfers|&nbsp;|Kfabric uses the same bulk-data primitives as MPI. They provide message ordering with unordered delivery of bulk data.|
|Transmission Control Protocol (TCP)/User Datagram Protocol (UDP)|Each new flow selects a new path. Long-lived flows are rerouted if they encounter congestion.|&nbsp;|

## RDMA transport is exposed to software using Libfabric

Libfabric libraries expose the RDMA protocols to application middleware.
Libfabric is an open-source, industry-standard library that provides a high-level application programming interface (API) for communication between applications and network hardware.
It minimizes the gap between application needs and fabric capabilities by abstracting the underlying networking protocols and devices, allowing application developers to write code that works across different networking hardware with few modifications. Hardware manufacturers deliver device-specific capabilities through providers, giving NIC vendors a flexible way to expose advanced hardware offload capabilities.
The CXI provider exposes HPE Slingshot NIC RDMA through Libfabric. HPE distributes Libfabric software with its NIC software, the OpenFabrics Interfaces (OFI) upstream Libfabric source, and HPE GitHub repositories.

For most users, the primary consideration when running RDMA applications on HPE Slingshot is to use the Libfabric communication libraries rather than legacy alternatives such as Unified Communication X (UCX) or native Verbs, which are prevalent with InfiniBand and RoCE.
Vendors widely support Libfabric and increasingly adopt it as the preferred interface for newer high-performance networking designs, including Amazon Web Services Elastic Fabric Adapter. This document covers Libfabric-specific considerations for the HPE Slingshot NIC.
HPE also delivers a kernel implementation of Libfabric called kfabric for the Lustre Networking (LNET) protocol.
Through Libfabric, the HPE Slingshot NIC transfers data directly between the network and CPU or GPU memory without bounce buffers or host-memory copies. The industry often calls this GPU capability GPU-Direct, but that term is a trademarked name for a specific implementation, so this guide does not use it to describe HPE Slingshot.

## Packet labels for traffic isolation of the HPE Slingshot transport

The HPE Slingshot NIC transport uses a packet label called a Virtual Network Identifier (VNI) to create a hardware-enforced RDMA communication domain so that only endpoints participating in the same job or service can communicate. A scheduler such as the Simple Linux Utility for Resource Management (Slurm) or Portable Batch System (PBS) Pro allocates a VNI, while the driver controls access to the associated CXI service through standard Linux authorization mechanisms such as a user identifier (UID), group identifier (GID), or network namespace.
This arrangement provides a job-level, fabric-wide private RDMA domain that helps protect against unintended interaction from rogue or misconfigured applications. The NIC always enforces VNIs, and switches can also enforce them in multi-tenant environments.

Although an administrator configures this capability, users should understand that RDMA communication fails when the system does not provision the required VNI. Libfabric or higher-level middleware such as MPI then reports the resulting errors.
When users run an application with new middleware for the first time, they may need corresponding job-launch changes to configure the VNI packet label. As described later in this document, software that initializes Libfabric only for on-node communication may still require the job scheduler to provision a VNI.
