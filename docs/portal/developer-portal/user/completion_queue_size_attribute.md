# Completion queue size attribute (`FI_CXI_DEFAULT_CQ_SIZE`)

This variable specifies the maximum number of entries in the CXI provider completion queue. This is used for various software and hardware event queues to generate Libfabric completion events.
While the size of the software queues may grow dynamically, hardware event queue sizes are static. If the hardware event queue is undersized, it will fill quicker than expected, and the next operation targeting a full event queue will result in the message operation being dropped and flow control triggered. Flow control results in expensive, side-band, CXI provider internal messaging to recover from which can appear as lockup to the user.

The provider default is 1024. Users are encouraged to set the completion queue size attribute based on the expected number of inflight RDMA operations to and from a single endpoint. The default provider default value can be set in the application, like MPI, to override the provider default value.
The default CXI provider value is sized to handle the sum of the TX and RX default values, and it must not be below the sum of the TX and RX values if they have been changed from the default. Cray MPI sets this value to a default size of 131072.
This size is partially an artifact of wanting to prevent a condition in earlier versions of cxi provider when overflowing the buffer could cause lock-ups.
This is no longer the case – instead overflowing the buffer will cause slower performance because it triggers flow control.

The impact of sizing this too high is reserving extra host memory that may ultimately be unnecessary.
