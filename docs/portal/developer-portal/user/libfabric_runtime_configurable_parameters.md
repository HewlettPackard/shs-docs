# Libfabric runtime configurable parameters

The CXI provider checks for the following environment variables.

## `FI_CXI_ODP`

Enables on-demand paging.
If disabled, all DMA buffers are pinned.
If enabled and `mr_mode` bits in the hints exclude `FI_MR_ALLOCATED`, then ODP mode will be used.

## `FI_CXI_FORCE_ODP`

Experimental value that can be used to force the use of ODP mode even if `FI_MR_ALLOCATED` is set in the `mr_mode` hint bits.
This is intended to be used primarily for testing.

## `FI_CXI_ATS`

Enables PCIe ATS. If disabled, the NTA mechanism is used.

## `FI_CXI_ATS_MLOCK_MODE`

Sets ATS `mlock` mode. The `mlock()` system call may be used in conjunction with ATS to help avoid network page faults. Valid values are "off" and "all". When `mlock` mode is "off", the provider does not use `mlock()`.
An application using ATS without `mlock()` may experience network page faults, reducing network performance. When `ats_mlock_mode` is set to "all", the provider uses `mlockall()` during initialization with ATS. `mlockall()` causes all mapped addresses to be locked in RAM at all times. This helps to avoid most network page faults.
Using `mlockall()` may increase pressure on physical memory. Ignored when ODP is disabled.

## `FI_CXI_RDZV_THRESHOLD`

Message size threshold for rendezvous protocol.

**Default:** 2048

## `FI_CXI_RDZV_GET_MIN`

Minimum rendezvous. Get payload size. A Send with length less than or equal to `FI_CXI_RDZV_THRESHOLD` plus `FI_CXI_RDZV_GET_MIN` will be performed using the eager protocol.
Larger Sends will be performed using the rendezvous protocol with `FI_CXI_RDZV_EAGER_SIZE` bytes of payload sent eagerly and the remainder of the payload read from the source using a Get. `FI_CXI_RDZV_THRESHOLD` plus `FI_CXI_RDZV_GET_MIN` must be less than or equal to `FI_CXI_OFLOW_BUF_SIZE`.

**Default:** 2049

## `FI_CXI_RDZV_EAGER_SIZE`

Eager data size for rendezvous protocol.

**Default:** 2048

## `FI_CXI_RDZV_PROTO`

Direct the provider to use a preferred protocol to transfer non-eager rendezvous data. Note that all rendezvous protocols use RDMA to transfer eager and non-eager rendezvous data. Adjusting the protocol can help improve performance for collective operations.

## `FI_CXI_RDZV_PROTO= default | alt_read`

To use the `alt_read` alternate rendezvous protocol, the CXI driver property `rdzv_get_en` should be set to "0". The `alt_read` rendezvous protocol may help improve collective operation performance. Note that all rendezvous protocols use RDMA to transfer eager and non-eager rendezvous data.

## `FI_CXI_DISABLE_NON_INJECT_MSG_IDC`

Experimental option to disable favoring Immediate Data Command (IDC) for transmit of small messages when `FI_INJECT` is not specified. This can be useful with GPU source buffers to avoid the host copy in cases a performant copy cannot be used.

**Default:** Use IDC for all messages less than IDC size

## `FI_CXI_DISABLE_HOST_REGISTER`

Disable registration of host buffers (overflow and request) with GPU.
There are scenarios where using many processes per GPU results in page locking excessive amounts of memory degrading performance and/or restricting process counts.

**Default:** Register buffers with the GPU

## `FI_CXI_OFLOW_BUF_SIZE`

Size of overflow buffers. Increasing the overflow buffer size allows for more unexpected message eager data to be held in a single overflow buffer. Applications with a large number of unexpected messages and/or using a large rendezvous threshold may perform better increasing this size.

**Default:** 2MB

## `FI_CXI_OFLOW_BUF_MIN_POSTED/FI_CXI_OFLOW_BUF_COUNT`

The minimum number of overflow buffers that should be posted.
Buffers will grow unbounded to support outstanding unexpected messages. Care should be taken to size appropriately based on job scale, size of eager data, and the amount of unexpected message traffic to reduce the need for flow control.

**Default:** 3

## `FI_CXI_OFLOW_BUF_MAX_CACHED`

The maximum number of overflow buffers that will be cached.
A value of zero indicates that once an overflow buffer is allocated it will be cached and used as needed. A non-zero value can be used with bursty traffic to shrink the number of allocated buffers to the maximum count when they are no longer needed.

**Default:** `3 * FI_CXI_OFLOW_BUF_MIN_POSTED`

## `FI_CXI_SAFE_DEVMEM_COPY_THRESHOLD`

Defines the maximum CPU `memcpy` size for HMEM device memory that is accessible by the CPU with load/store operations.

**Default:** 4096

## `FI_CXI_OPTIMIZED_MRS`

Enables optimized memory regions. See section CXI Domain Control Extensions on how to enable/disable optimized MRs at the domain level instead of for the global process/job.

**Default:** 1

## `FI_CXI_MR_MATCH_EVENTS`

Enabling MR match events in a client/server environment can be used to ensure that memory backing a memory region cannot be remotely accessed after the MR has been closed, even if it that memory remains mapped in the Libfabric MR cache. Manual progress must be made at the target to process the MR match event accounting and avoid event queue overflow. There is a slight additional cost in the creation and tear-down of MR.

See section CXI Domain Control Extensions on how to enable MR match events at the domain level instead of for the global process/job.

**Default:** Disabled

## `FI_CXI_PROV_KEY_CACHE`

Enabled by default, the caching of remote MR provider keys can be disable by setting to 0.

See section CXI Domain Control Extensions on how to disable the remote provider key cache at the domain level instead of for the global process/job.

**Default:** Enabled

## `FI_CXI_LLRING_MODE`

Set the policy for use of the low-latency command queue ring mechanism. This mechanism improves the latency of command processing on an idle command queue. Valid values are idle, always, and never.

**Default:** Idle

## `FI_CXI_CQ_POLICY`

Experimental. Set a Command Queue write-back policy. Valid values are always, high_empty, low_empty, and low. "always", "high", and "low" refer to the frequency of write-backs. "empty" refers to whether a write-back is performed when the queue becomes empty.

**Default:** Empty

## `FI_CXI_DEFAULT_VNI`

The default VNI value used only for service IDs where the VNI is not restricted.

**Default:** 10

## `FI_CXI_RNR_MAX_TIMEOUT_US`

When using the endpoint `FI_PROTO_CXI_RNR` protocol, this setting is used to control the maximum time from the original posting of the message that the message should be retried. A value of 0 will return an error completion on the first RNR ack status.

**Default:** 500000 microseconds

## `FI_CXI_EQ_ACK_BATCH_SIZE`

Number of EQ events to process before writing an acknowledgment to HW. Batching ACKs amortizes the cost of event acknowledgment over multiple network operations.

**Default:** 32

## `FI_CXI_RX_MATCH_MODE`

Specify the receive message matching mode to be utilized. `FI_CXI_RX_MATCH_MODE=hardware | software | hybrid`.

- `hardware` - Message matching is fully offloaded, if resources become exhausted flow control will be performed and existing unexpected message headers will be onloaded to free resources. If resources cannot be freed, either `hybrid` or `software` mode will be required.
- `software` - Message matching is fully onloaded.
- `hybrid` - Message matching begins fully offloaded, if resources become exhausted hardware will transition message matching to a hybrid of hardware and software matching.

For both "hybrid" and "software" modes and care should be taken to minimize the threshold for rendezvous processing (For instance, `FI_CXI_RDZV_THRESHOLD` and `FI_CXI_RDZV_GET_MIN`). When running in software endpoint mode the environment variables `FI_CXI_REQ_BUF_SIZE` and `FI_CXI_REQ_BUF_MIN_POSTED` are used to control the size and number of the eager request buffers posted to handle incoming unmatched messages.

**Default:** hardware

## `FI_CXI_HYBRID_PREEMPTIVE`

When in hybrid mode, this variable can be used to enable preemptive transitions to software matching. This is useful at scale for poorly written applications with many unexpected messages where reserved resources may be insufficient to prevent starvation of software request list match entries.

**Default:** 0, disabled

## `FI_CXI_HYBRID_RECV_PREEMPTIVE`

When in hybrid mode, this variable can be used to enable preemptive transitions to software matching. This is useful at scale for poorly written applications with many unmatched posted receives where reserved resources may be insufficient to prevent starvation of software request list match entries.

**Default:** 0, disabled

## `FI_CXI_HYBRID_POSTED_RECV_PREEMPTIVE`

When in hybrid mode, this variable can be used to enable preemptive transitions to software matching when the number of posted receives exceeds the user requested RX size attribute. This is useful for applications where they may not know the exact number of posted receives and they are experiencing application termination due to event queue overflow.

**Default:** 0, disabled

## `FI_CXI_HYBRID_UNEXPECTED_MSG_PREEMPTIVE`

When in hybrid mode, this variable can be used to enable preemptive transitions to software matching when the number of hardware unexpected messages exceeds the user requested RX size attribute. This is useful for applications where they may not know the exact number of posted receives and they are experiencing application termination due to event queue overflow.

**Default:** 0, disabled

## `FI_CXI_REQ_BUF_SIZE`

Size of request buffers. Increasing the request buffer size allows for more unmatched messages to be sent into a single request buffer.

**Default:** 2MB

## `FI_CXI_REQ_BUF_MIN_POSTED`

The minimum number of request buffers that must be posted. The number of buffers will grow unbounded to support outstanding unexpected messages. Care must be taken to size appropriately based on job scale and the size of eager data to reduce the need for flow control.

**Default:** 4

## `FI_CXI_REQ_BUF_MAX_CACHED/FI_CXI_REQ_BUF_MAX_COUNT`

The maximum number of request buffers that will be cached. A value of zero indicates that once a request buffer is allocated it will be cached and used as needed. A non-zero value can be used with bursty traffic to shrink the number of allocated buffers to a maximum count when they are no longer needed.

**Default:** 0

## `FI_CXI_MSG_LOSSLESS`

Enable or disable lossless receive matching. If hardware resources are exhausted, hardware will pause the associated traffic class until an overflow buffer (hardware match mode) or request buffer (software match mode or hybrid match mode) is posted. This is considered experimental and not intended for application use.

**Default:** disabled.

## `FI_CXI_FC_RETRY_USEC_DELAY`

Number of microseconds to sleep before retrying a dropped side-band, flow control message. Setting to zero will disable any sleep.

**Default:** 1000 microseconds

## `FI_UNIVERSE_SIZE`

Defines the maximum number of processes that will be used by distribute OFI application. This value is used in setting the default control EQ size, see `FI_CXI_CTRL_RX_EQ_MAX_SIZE`.

**Default:** 256

## `FI_CXI_CTRL_RX_EQ_MAX_SIZE`

Max size of the receive event queue used for side-band/control messages. Default receive event queue size is based on `FI_UNIVERSE_SIZE`. Increasing the receive event queue size can help prevent side-band/control messages from being dropped and retried but at the cost of additional memory usage. Size is always aligned up to a 4KiB boundary.

## `FI_CXI_DEFAULT_CQ_SIZE`

Change the provider default completion queue size expressed in entries. This may be useful for applications which rely on middleware, and middleware defaults the completion queue size to the provider default.

**Default:** 1024

## `FI_CXI_DISABLE_EQ_HUGETLB/FI_CXI_DISABLE_CQ_HUGETLB`

By default, the provider will attempt to allocate 2 MiB `hugetlb` pages for provider event queues. Disabling `hugetlb` support will cause the provider to fall back to memory allocators using host page sizes. `FI_CXI_DISABLE_EQ_HUGETLB` replaces `FI_CXI_DISABLE_CQ_HUGETLB`, however use of either is still supported.

**Default:** 2 MiB `hugetlb` pages

## `FI_CXI_DEFAULT_TX_SIZE`

Set the default `tx_attr.size` field to be used by the provider if the size is not specified in the user provided `fi_info` hints.

**Default:** 512

## `FI_CXI_DEFAULT_RX_SIZE`

Set the default `rx_attr.size` field to be used by the provider if the size is not specified in the user provided `fi_info` hints.

**Default:** 512

## `FI_CXI_SW_RX_TX_INIT_MAX`

Debug control to override the number of TX operations that can be outstanding that are initiated by software RX processing. It has no impact on hardware initiated RX rendezvous gets.

**Default:** 1024

## `FI_CXI_DEVICE_NAME`

Restrict CXI provider to specific CXI devices. Format is a comma-separated list of CXI devices (For example, `cxi0`,`cxi1`). The default that all present CXI NICs are used.

## `FI_CXI_TELEMETRY`

Perform a telemetry delta between `fi_domain` open and close. Format is a comma-separated list of telemetry files as defined in `/sys/class/cxi/cxi*/device/telemetry/`. The ALL-in-binary file in this directory is invalid. These are per CXI interface counters and not per CXI process per interface counters. No counters will be specified by default.

## `FI_CXI_TELEMETRY_RGID`

Resource group ID (RGID) to restrict the telemetry collection to. Value less than 0 is no restrictions.

**Default:** `-1` – no restrictions

## `FI_CXI_CQ_FILL_PERCENT`

Fill percent of the underlying hardware event queue used to determine when the completion queue is saturated. A saturated completion queue results in the provider returning `-FI_EAGAIN` for data transfer and other related Libfabric operations.

**Default:** 50

## `FI_CXI_COLL_FABRIC_MGR_URL`

Accelerated collectives: Specify the HTTPS address of the fabric manager REST API used to create specialized multicast trees for accelerated collectives. This parameter is REQUIRED for accelerated collectives, and is a fixed, system-dependent value.

## `FI_CXI_COLL_TIMEOUT_USEC`

Accelerated collectives: Specify the reduction engine timeout. This should be larger than the maximum expected compute cycle in repeated reductions, or acceleration can create incast congestion in the switches. The relative performance benefit of acceleration declines with increasing compute cycle time, dropping below one percent at 32 microseconds (32000). Using acceleration with compute cycles larger than 32 microseconds is not recommended except for experimental purposes.

**Default:** 32 microseconds (32000), maximum is 20 sec (20000000)

## `FI_CXI_COLL_USE_DMA_PUT`

Accelerated collectives: Use DMA for collective packet put. This uses DMA to inject reduction packets rather than IDC, and is considered experimental.

**Default:** False

## `FI_CXI_DISABLE_HMEM_DEV_REGISTER`

Disable registering HMEM device buffer for load/store access. Some HMEM devices (For example, AMD, Nvidia, and Intel GPUs) support backing the device memory by the PCIe BAR.
This enables software to perform load/stores to the device memory via the BAR instead of using device DMA engines. Direct load/store access may improve performance.

**Default:** 0 – not disabled

## `FI_CXI_FORCE_ZE_HMEM_SUPPORT`

Force the enablement of ZE HMEM support. By default, the CXI provider will only support ZE memory registration if implicit scaling is disabled (For example, the environment variables `EnableImplicitScaling=0` and `NEOReadDebugKeys=1` are set). Set `FI_CXI_FORCE_ZE_HMEM_SUPPORT` to 1 will cause the CXI provider to skip the implicit scaling checks. GPU direct RDMA may or may not work in this case.

## `FI_CXI_ENABLE_TRIG_OP_LIMIT`

Enable enforcement of triggered operation limit. Doing this can prevent `fi_control(FI_QUEUE_WORK)` deadlocking at the cost of performance.

**Note:** Use the `fi_info` utility to query provider environment variables: `fi_info -p cxi -e`

**Default:** 0 – disabled
