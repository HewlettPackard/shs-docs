# Completion queue size attribute (`FI_CXI_DEFAULT_CQ_SIZE`)

The completion queue size attribute specifies the maximum number of entries in the CXI provider completion queue for various software and hardware event queues to generate Libfabric completion events
Older SHS releases used this variable differently and often required users to increase it from the default. With SHS release 13.0 and later, users rarely need to increase it beyond the default of 131072.

The completion queue size represents the expected number of in-flight RDMA operations to and from a single endpoint.
The default CXI provider value accommodates the sum of the TX and RX default values. Keep the value at or above the sum of the TX and RX values if you change either value from its default. Setting the completion queue size too high reserves unnecessary host memory.

Software queues may grow dynamically, but hardware event queue sizes remain static. If the hardware event queue is undersized, it fills faster than expected. When an operation targets a full event queue, the CXI provider drops the message operation and triggers flow control.
Flow control then generates expensive sideband CXI provider internal messaging to recover from a condition that may appear to the user as a lockup.
