# Configuring matching (`FI_CXI_RX_MATCH_MODE`)

The CXI provider can operate in either of the following modes:

- A **hardware endpoint** that offloads capabilities to the NIC hardware.
- A **software endpoint** that uses the host CPU and memory instead.

The `FI_CXI_RX_MATCH_MODE` variable sets the operational mode for tag matching:

- `hardware`
- `hybrid`
- `software`

Hybrid mode transitions from a hardware endpoint to a software endpoint if hardware resources are exhausted.

The current default is `hardware`. If resources are exhausted and the provider cannot recover them, the application may fail. This section describes how to configure the endpoint types.

Running in software mode, or in hybrid mode after it transitions to a software endpoint, also means that the rendezvous protocol uses the software endpoint. Additional configuration options are described in the corresponding section.

## Hardware matching

```text
FI_CXI_RX_MATCH_MODE=hardware
```

Hardware matching provides performance benefits because host-based matching can be expensive in terms of CPU and memory-bandwidth utilization.

Hardware matching is appropriate for users who can ensure that the sum of unexpected messages and posted receives does not exceed the configured hardware receive-resource limit for the application.

Hardware matching is the default setting.

## Software matching

```text
FI_CXI_RX_MATCH_MODE=software
```

Software matching is appropriate for users who know that the sum of unexpected messages and posted receives will exceed the configured hardware receive-resource limit for the application.

In software matching mode, the CXI provider maintains:

- An unexpected-message software list.
- A posted-receive software list.

Rather than offloading matching to hardware, this uses a pool of request buffers whose initial size is `FI_CXI_REQ_BUF_SIZE` x `FI_CXI_REQ_BUF_MIN_POSTED` (72 MiB per receive context by default).
Because this pool replaces the hardware-mode overflow-buffer pool (36 MiB by default), the net additional host memory is approximately **36 MiB per receive context** with default settings.

The software endpoint avoids allocating hardware receive resources for each unexpected message and posted receive.

## Hybrid matching

```text
FI_CXI_RX_MATCH_MODE=hybrid
```

Hybrid matching is appropriate for users who are unsure whether the sum of unexpected messages and posted receives might exceed the configured hardware receive-resource limit and want to ensure that the application can still complete.

When hardware receive resources are consumed, hybrid mode transitions to software matching.

The primary trade-off compared with hardware matching is that hybrid mode requires buffers to back both the hardware and software endpoints.
This results in approximately **72 MiB per receive context** of additional host memory consumption with default settings (`FI_CXI_REQ_BUF_SIZE` x `FI_CXI_REQ_BUF_MIN_POSTED`), even if the rank never transitions to software matching.

If this additional memory consumption is acceptable, sites may prefer to use hybrid mode as the global default.
Hardware matching has been the default since the provider's introduction because hybrid matching was not performing optimally at that time.

## Hardware resource exhaustion and flow control

When hardware receive resources are consumed (including list/match entries or overflow buffers), receive operations become disabled.
This ensures that message-match ordering is maintained while the provider attempts to recover hardware resources.

Even if recovery succeeds, the recovery process requires sideband communication to synchronize re-enablement of the receive function.
An improperly sized sideband communication event queue can lengthen recovery time at scale.

To determine whether this flow-control transition is occurring, review the Libfabric logs:

```text
FI_LOG_LEVEL=warn
FI_LOG_PROV=cxi
```

Even when running in software or hybrid mode, other scenarios can cause flow control.
For example, if the application does not drain the Libfabric completion queue at a reasonable rate, the corresponding hardware events may fill up and trigger flow control.

In practice, dependent processes (such as parallel jobs) will most likely share a common receive hardware-resource pool.
