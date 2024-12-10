# RDMA messaging and relationship to environment settings

Libfabric programmers use either tagged or untagged two-sided messaging interfaces. Tagged messaging is used for complex data exchanges and multi-step protocols that require strict message ordering.
Untagged messaging has less overhead and is suitable for simpler RDMA communication patterns, such as bulk data transfers and basic request-response. The HPE Slingshot NIC provides extensive hardware offloads for tagged messaging.

Received data goes into a "receive buffer," a memory area from which the target application reads the data once the transmission is complete, without OS memory copies.
Data to be sent comes from a "transmit buffer," an area of application memory from which the NIC reads directly to send data, without involving the host CPU in copying the data.

The CXI provider selects how to send data from among several message protocols based on payload length.
Short messages are transferred using an eager protocol where the entire message payload is sent along with the message header. Long messages are transferred using a rendezvous protocol.
In the rendezvous protocol, a portion of the message payload is sent along with the message header. Once the header is matched to a receive buffer, the remainder of the payload is pulled from the source and matched and ordered by the receiver.

In both methods, if data has been sent before the receive buffer is set up, as might happen if an asynchronous communications pattern is permitted to maximize performance, the message is “unexpected”.
It will sit in a special section of host memory allocated for unexpected messages until its proper destination is learned, at which point it will be copied into the correct receive buffer location.
The HPE Slingshot NIC will offload tag matching for the unexpected message to the NIC, but unexpected messages require host CPU intervention, so performance is optimized by limiting their frequency.

The environment variables relate to configuring the various resources and behavior to offload as many of the above operations onto the NIC to optimize performance as is possible.
The less the host CPU needs to be involved, the more predictably the sending, receiving, and matching can happen using hardware offloads, and the more software-based communications can be targeted instead of triggered unintentionally by hardware exhaustion, the greater the performance will be. For example, when hardware message matching resources become exhausted, messages may be dropped and need to be retransmitted and this impacts performance significantly.
Sometimes hardware resource exhaustion can cause lock-ups, such as when the sender is waiting for receive responses but the receive resources have been exhausted.

The environment variables help ensure that the resources are sized appropriately so the communication performance is optimized, and resources are in line with the application’s communications patterns.
Allocating too many resources can use up too much host memory or sometimes hinder performance, while allocating too few risks performance and resource exhaustion lock up.
