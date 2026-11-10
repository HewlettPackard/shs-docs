# Endpoint receive size attribute (`FI_CXI_DEFAULT_RX_SIZE`)

The receive size attribute tells the provider the maximum expected number of in-flight receive operations, including tagged and untagged operations.
At job startup, the provider uses this value to size receive-side resources, such as command and hardware event queues. Currently, the attribute defaults to 1024.
Users running in hybrid match mode may occasionally need to increase this value.
