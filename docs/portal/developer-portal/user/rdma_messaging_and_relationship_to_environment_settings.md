# Libfabric, NIC hardware, and RDMA transports

For Libfabric applications, the CXI provider exposes a single endpoint type, `FI_EP_RDM`, which implements the NIC's reliable, connectionless messaging model described previously. That endpoint supports Libfabric's two-sided communication interfaces, including `FI_MSG` and `FI_TAGGED`, and one-sided interfaces, including `FI_RMA` and `FI_ATOMIC`.
The restricted and unrestricted RDMA transports described in previous sections are building blocks that the provider uses to instantiate the Libfabric communications interface. Most Libfabric programmers use tagged messaging for complex data exchanges and multi-step protocols that require strict message ordering. They use untagged messaging, which has less overhead, for simpler RDMA communication patterns such as bulk data transfers and basic request-response.

Transmit and receive buffers are used by Libfabric two-sided messaging operations, where incoming messages are matched to a known (posted) receive buffer by using a tag.
The receive buffer is the memory area from which the target application reads the data once the transmission is complete.
Data to be sent comes from a "transmit buffer," an area of application memory from which the NIC reads directly to send data.
Provider-configured behavior selects whether this tag handling uses the NIC hardware-offload mechanism (hardware endpoint) or a host-based mechanism (software endpoint).
Hardware endpoints deliver the best performance as long as sufficient NIC resources are available to track all outstanding tags and buffers. Software endpoints remove hardware resource constraints but increase reliance on host-side processing and memory.

The CXI provider efficiently handles asynchronous communication patterns.
With both rendezvous and eager methods, if data has been sent before the receive buffer is set up, the message can be received as unexpected and placed by the NIC hardware in a specially allocated overflow buffer in host CPU memory until its proper destination is learned, at which point it will be copied into the correct receive buffer location.
While the hardware offload capability handles unexpected messages to enable compute and communications overlap, software should limit the frequency of unexpected messages to maximize performance.

Underneath the application interfaces, the CXI provider selects the specific protocol to send the message based on payload size guided by environment variable configured behavior. Short messages are transferred using an eager protocol where the entire message payload is sent along with the message header.
Long messages are transferred using a rendezvous protocol. In the rendezvous protocol a portion of the message payload can be sent along with the message header, and once the header is matched to a receive buffer, the remainder of the payload is pulled from the source and matched and ordered by the receiver.  

The rest of this section describes the most common environment variables.
