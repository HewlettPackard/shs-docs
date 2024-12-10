# HPE Slingshot NIC RDMA protocol and traffic classes

The following tables delineate how various operations/traffic types are adaptively routed.

**Table:** Adaptive routing for various operations and traffic types

| Operation / Traffic Type    | Ordered – Per Flow Adaptive Routing | Unordered – Per Packet Adaptive Routing |
|-----------------------------|-------------------------------------|-----------------------------------------|
| MPI message headers         | Yes                                 |                                         |
| MPI bulk data transfers     |                                     | Yes                                     |
| Shmem Put/Get and MPI-3 RMA |                                     | Yes                                     |
| Lustre bulk data transfers  |                                     | Yes                                     |
| TCP/UDP                     | Yes                                 |                                         |

**Table:** Description of adaptive routing for various operations and traffic types

| Operation / Traffic Type   | Ordered – Per Flow Adaptive Routing                                                                                                                                                                                                                                       | Unordered – Per Packet Adaptive Routing                                                                                                                             |
|----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| MPI message headers        | MPI semantics require message ordering between two points. Message headers (and a small amount of data) are sent in order. Many MPI messages will be new flows. For example, whenever there is a gap of more than a few microseconds in messages to the same destination. |                                                                                                                                                                     |
| MPI bulk data transfers    |                                                                                                                                                                                                                                                                           | Once an MPI message has been matched, the bulk data transfer can be unordered. The threshold for this is typically 8K - it can be tuned on a per-application basis. |
| Shmem and MPI-3 RMA        | Some special cases such as put-with-signal and reliable AMOs use the “unrestricted” reliability protocol that uses ordered delivery.                                                                                                                                      | Put/Get use a sequence of unordered single packet operations. Address ordering is implemented using fence.                                                          |
| Lustre bulk data transfers |                                                                                                                                                                                                                                                                           | Kfabric uses the same bulk-data primitives as MPI. They provide message ordering with unordered deliver of bulk-data.                                               |
| TCP/UDP                    | Each new flow selects a new path. Long lived flows are rerouted if they encounter congestion.                                                                                                                                                                             |                                                                                                                                                                     |

In the absence of contention, all ordered delivery traffic will be routed minimally, for example in a Dragonfly configuration, taking at most one switch-to-switch one hop in the source group, one global hop, and one hop in the destination group.
In the presence of congestion, the adaptive routing mechanism can cause packets to route non-minimally to avoid the congestion.
In the non-minimal case, the hop count can double, with the packets effectively routing to a randomly chosen intermediate switch and then to the destination.

The HPE Slingshot adaptive routing uses both congestion information and traffic class and Quality of Service (QoS) capabilities to prevent traffic from different applications from interfering with each other.
