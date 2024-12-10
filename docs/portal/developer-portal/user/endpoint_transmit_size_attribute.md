# Endpoint transmit size attribute (`FI_CXI_DEFAULT_TX_SIZE`)

The endpoint transmit size attribute sizes the internal command and hardware event queues. This controls how many messages are in flight, so at a minimum, users are encouraged to set the endpoint transmit size attribute based on the expected number of inflight, initiator RDMA operations.

If users are going to be issuing more messages than the CXI provider rendezvous limit (`FI_CXI_RDZV_THRESHOLD`), the transmit size attribute must also include the number of outstanding, unexpected rendezvous operations.
For instance, inflight, initiator RDMA operations and outstanding, unexpected rendezvous operations.
See the section on [Rendezvous protocol configuration](rendezvous_protocol_configuration.md#rendezvous-protocol-configuration) for more information.

The current default is 512. Cray MPI sets this to 1024.  

If the setting is too high, it can consume more memory than necessary and allow too many messages to be in flight, potentially overwhelming an endpoint. Conversely, if the setting is too low, it can impact performance due to the instantiation of flow control.
In some cases, a low setting may cause a deadlock because an application might post too many transmissions before it can post a receive. These issues are often caused by poorly written applications. This situation typically occurs with the Rendezvous protocol, where too many unexpected messages are received.
