# Hardware overview

The HPE Slingshot NIC is optimized for high performance RDMA communications on HPC and AI applications.
It enables applications to achieve high performance by offloading CPU-intensive activities to the NIC hardware to maximize the overlap of compute and communication.
The NIC simultaneously handles standard Ethernet, and the optimized, non-Ethernet HPE Slingshot Transport (ST) protocol used for offloading RDMA operations.

Sometimes, the NIC works with HPE Slingshot switches to maximize the unique and powerful performance capabilities of the fabric.
For example, large messages can be offloaded to use a rendezvous protocol that allows for out-of-order packet delivery that can be adaptively routed on a packet-by-packet basis to overcome link congestion and achieve high utilization of available bandwidth while retaining application ordering constraints.
Another example is the “fine grained” flow control between the NIC and the fabric allow the NIC to reduce bandwidth for a specific application instead of completely pausing all flows or an entire traffic class as would happen with standard Ethernet.

The ST protocol is accessed through a connectionless software interface to deliver large scalability with lower memory footprint overhead as compared to connection-oriented protocols. The ST protocol is supported by reliable packet delivery features in the NIC and the fabric.
Link-level reliability capabilities such as link-level retry reduce packet drops that otherwise add latency.
The hardware mechanisms work with a software-based end-to-end retry mechanism, typically referred to as the retry handler service, that acts as a “last resort” mechanism to retry packets to the destination before packet drops, for example when there is congestion that has not been fully mitigated.
