# CXI request buffers for software endpoints

The following variables control request buffers for software endpoints:

- `FI_CXI_REQ_BUF_SIZE`
- `FI_CXI_REQ_BUF_MIN_POSTED`

With software endpoints, incoming eager message data (including the eager portion of rendezvous sends) is placed in request buffers until the software can match it to receive operations.
Rendezvous bulk data does not pass through request buffers; it is fetched by a Get operation directly into the user receive buffer.
This also applies to hybrid matching mode after it transitions to a software endpoint.

The provider manages request buffers as a pool. Each request buffer is a region that can hold data from multiple incoming transactions.
As one buffer is consumed, another available buffer can accept new traffic.

When the application calls into Libfabric, the provider:

1. Processes consumed buffers.
2. Returns replacement buffers to the pool.

Using multiple pools allows reception to continue while individual buffers are processed and recycled.

Two variables control the properties of this pool:

- `FI_CXI_REQ_BUF_SIZE` controls the size of each individual buffer and, therefore, the amount of data it can hold before it must be recycled.
- `FI_CXI_REQ_BUF_MIN_POSTED` controls the minimum number of buffers kept available. This value is a floor, not a cap: the pool grows beyond it as needed to absorb outstanding unexpected messages.

Together, these settings determine the request-buffer capacity initially available while the application is outside Libfabric.

## `FI_CXI_REQ_BUF_SIZE`

`FI_CXI_REQ_BUF_SIZE` specifies the size, in bytes, of each request buffer used for software matching.

The default is:

```text
12,582,912 bytes (12 MiB)
```

Increasing this value allows each buffer to hold more data before it is consumed, processed, and recycled.
However, it also increases memory usage for every request buffer in the pool.

## `FI_CXI_REQ_BUF_MIN_POSTED`

`FI_CXI_REQ_BUF_MIN_POSTED` specifies the minimum number of request buffers that the CXI provider attempts to keep available for software matching.

The default value is:

```text
6
```

Increasing this value gives the provider more buffers to use while the application is computing or otherwise not calling into Libfabric.
However, it also increases the total memory reserved for the pool.

## Request-Buffer Exhaustion

If the posted request buffers fill while the provider is operating in software matching mode, the provider enters a flow-control recovery cycle: receive processing pauses while buffers are processed and replenished, which carries a performance cost.
When logging is enabled (`FI_LOG_LEVEL=warn`), the provider reports this condition with a warning that suggests increasing the `FI_CXI_REQ_BUF_SIZE` value.

A fatal error occurs only if the provider cannot post any request buffer at all, for example, because buffer allocation or registration fails and no buffers remain linked.
In that case, the affected rank may exit, typically causing the application job to fail.

If flow control from request-buffer pressure is suspected, increasing one or both of the following may be appropriate:

- The request-buffer size.
- The number of posted request buffers.

The exact warning and error text may vary.
