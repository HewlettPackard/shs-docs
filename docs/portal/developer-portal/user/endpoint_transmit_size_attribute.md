# Endpoint transmit size attribute (`FI_CXI_DEFAULT_TX_SIZE`)

The endpoint transmit size attribute sizes the internal transmit command and hardware event queues.
It represents the expected number of in-flight initiator RDMA operations plus the number of outstanding unexpected rendezvous operations when the application issues more messages than the CXI provider rendezvous limit.
See the section on Rendezvous protocol configuration for more information. The attribute currently defaults to 1024.

If you set the value too high, it can consume more memory than necessary and allow too many messages to remain in flight, potentially overwhelming an endpoint.
Conversely, a value that is too low can reduce performance because Libfabric must instantiate flow control. In some cases, a low value may cause a deadlock when an application posts too many transmissions before it posts a receive.
Poorly written applications that use the rendezvous protocol with too many unexpected messages usually cause this condition.
