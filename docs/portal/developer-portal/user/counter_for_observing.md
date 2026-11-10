# Counters for observing the network

These are the most important counters for most because they are the key
mechanism to understand if and why an application failed or ran
unexpectedly slow. They help to determine if the issue is in the host,
the network (a switch or a link), or the destination host.

## Timeouts and retry activity

Refer to the earlier explanation of the HPE Slingshot NIC RDMA and the
role of the retry handler for background. The HPE Slingshot
NIC RDMA is a "reliable" protocol, meaning that the transaction
completion success is known with certainty and reported to the software
as either completed, got no response, or got a response but was not
processed. No response is a "timeout" and results in replaying the
transaction. After too many timeouts, the operation is "cancelled".
Timeouts and retries serve as the initial indicators when evaluating
network health and reliability.

In a healthy run, timeout-related counters typically remain at or near
zero, indicating that link-level reliability and congestion management
are functioning as intended. Elevated timeout or retry values may signal
hardware issues, such as link flaps, or problems on destination
compute or storage endpoints. When performance varies between runs,
these counters help determine if network events contributed to the
variation.

Retries can also be caused by other underlying issues (beyond physical
network issues). Some causes of negative acknowledgments (NACKs) point
toward resource exhaustion at the target endpoint (for example, an
application sending too many messages to one endpoint). Recognizing this
distinction is crucial to decide whether to prioritize application-level
troubleshooting or to investigate hardware and network configuration
issues, and the retry handler counters provide insight into different
categories of negative acknowledgments.

In summary:

- Cancelled connections indicate that the transaction could not be completed.
  The higher-level application is notified in Libfabric and decides what
  to do. MPI terminates the job, while Lustre may try its own retry
  procedure.
- Timeouts indicate an operation needed to be replayed (via the retry
  handler) because there was no response from the destination.
- NACKs also cause transaction replay, such as when the destination is
  responding but is unable to accept the data because a resource was
  full or busy, or when packets requiring in-order processing could not be processed because previous packets did not yet arrive (for example, because they are still being replayed).

**Retry handler counters:**

|**Retry handler counter**|**Hardware counter equivalent**|**Description**|
|---|---|---|
|`RH:SPT_TIMEOUTS`|`PCT_SPT_TIMEOUTS`|Count of requests for which no response was received within the set timeout period.|
|`RH:NACKS`|&nbsp;|Count of total NACKs. There are individual counters for each NACK type.|
|`RH:CONNECTIONS_CANCELLED`|&nbsp;|Retry handler cancelled a connection because the retry policy was exhausted. This can happen when the NIC-to-switch link repeatedly flaps. For timeouts, the default policy is to retry four times with an exponential backoff between retries; NACKs follow a separate retry policy.|
|`RH:NACK_SEQUENCE_ERROR`|`PCT_BAD_SEQ_NACKS`|NACK caused by an ordered request arriving in the wrong sequence. This is typical when multiple ordered requests are in flight and an earlier packet is dropped or NACK'd.|
|`RH:NACK_NO_TARGET_TRS`|`PCT_NO_TRS_NACKS`|NACK caused by no space in the target result store, meaning there are too many ordered operations pending. Caused by a wide incast increasing time to free space in this table (a scarce hardware resource).|
|`RH:NACK_NO_TARGET_CONN`|`PCT_NO_TCT_NACKS`|Target connection table is full. Only happens if there is a wide incast.|
|`RH:NACK_NO_MATCHING_CONN`|`PCT_NO_MATCHING_TCT`|The expected connection at the target does not exist. This may occur if the initial packet that established the connection was lost and subsequent packets were not, or if a target connection timed out due to some delay in packets arriving at the target.|
|`RH:NACK_RESOURCE_BUSY`|`PCT_RESOURCE_BUSY`|A required target PCT resource was being freed at the time that it was required. A single retry of the packet typically resolves this type of NACK.|

*The counter names reference ASIC block functions: Source Connection
Tracking (SCT), Source Packet Tracking (SPT), Source Retry Buffer
(SRB), Target Result Store (TRS), and Target Connection Table (TCT).*

**Additional related hardware counters:**

|**Hardware Counter Name**|**Description**|
|---|---|
|`PCT_REQ_ORDERED`|Number of ordered requests.|
|`PCT_REQ_UNORDERED`|Number of unordered requests.|
|`PCT_RESPONSES_RECEIVED`|Number of responses received (all unordered).|
|`PCT_CONN_SCT_OPEN`|Number of connections opened.|
|`PCT_RETRY_SRB_REQUESTS`|Number of retry requests generated from the SRB.|

## Physical network counters: host-to-switch

Hardware in NICs and switches automatically correct marginal signal
integrity issues to avoid packet drops that would trigger timeouts and
retries. Link-level retry (LLR) and other physical error counters
indicate how prevalent these error correction mechanisms are needed.
These counters can help determine if retry activity stems from
physical-layer reliability problems: increased activity may signal
excessive errors that could not all be corrected in time, leading to
higher-latency retry events. (These are of more interest to
administrators than to users.) Additionally, the job scheduler\'s health
check diagnostic preamble may examine these same metrics before
assigning a job to the NIC.

**Host-to-switch physical network counters:**

|**Counter**|**Description**|
|---|---|
|`HNI_LLR_TX_REPLAY_EVENT`|Number of LLR replays on transmit. High rates indicate that the LLR mechanism is protecting a poor-quality link.|
|`HNI_LLR_RX_REPLAY_EVENT`|Number of LLR replays on receive. High rates indicate that the LLR mechanism is protecting a poor-quality link.|
|`HNI_PCS_GOOD_CW`|Receive (RX) side good codewords. Baseline measure of healthy physical layer receive activity. Use together with uncorrected counts; the ratio helps quantify link health.|
|`HNI_PCS_UNCORRECTED_CW`|Receive (RX) side uncorrected codewords. Hard physical-layer errors that could not be corrected. Any sustained increase is a strong indicator of a serious link issue and is correlated with replay/retry/timeout counters; it may warrant node/cable/port investigation.|

## Host-to-NIC counters

These counters describe the behavior across the PCIe interface between
the host system and the HPE Slingshot NIC capturing how efficiently data
is transferred between host memory and the NIC via DMA operations. These
report activity such as the volume of DMA reads and writes, as well as
stall conditions that occur when the NIC is unable to make forward
progress due to exhausted PCIe credits or backpressure from the host.

High packet or DMA counts indicate heavy interface utilization, while
elevated stall or blocked-cycle counters signal contention for host
memory bandwidth or delays in host consumption of data. By examining the
relationship between throughput and stall behavior, users can determine
whether application performance is being limited by the host I/O path
rather than by the network.

In these counters, “posted” refers to the NIC writing data to CPU or
GPU memory, while “non-posted” refers to the NIC reading data from CPU or GPU memory.
In almost every case, the posted counters are the ones of
interest because it is far more common for the host memory (CPU or GPU)
to be "busy" and preventing the NIC from writing data than it is for the
NIC to be prevented from reading data. There can be many causes for a
busy host path, from hardware-driven faults in the CPUs, GPUs, and
memory, to suboptimal software configuration such as NUMA configuration,
the OS, or the BIOS host configuration.

**Host-to-NIC counters:**

|**Counter Name**|**Description**|
|---|---|
|`PARBS_TARB_PI_POSTED_PKTS`|Count of the number of PCIe packets transferred using the posted path (for example, writes).|
|`PARBS_TARB_PI_POSTED_BLOCKED_CNT`|Number of cycles where PCIe packets transferred on the posted channel (for example, writes) were blocked. Values of more than a few cycles per packet indicate back pressure from the host; this endpoint is likely the cause of congestion.|
|`PARBS_TARB_PI_NON_POSTED_PKTS`|Number of PCIe packets transferred using the non-posted path (for example, reads).|
|`PARBS_TARB_PI_NON_POSTED_BLOCKED_CNT`|Number of cycles the non-posted path (for example, PCIe reads) was blocked. Values of more than a few cycles per packet indicate poor host performance (high read latencies), meaning the endpoint is likely injecting at a low rate.|

*PCIe arbitration (PARB) and transmit arbitration (TARB) are the ASIC
block functions referenced by these counters.*

These counters explain data transfer *within the system*. For example,
in the counter reports these statistics are reported as both raw values,
but also as rates (counts per second) that can be compared to available
host bandwidth capacity. Some useful data points in doing those
calculations:

HPE Slingshot 200Gbps NIC:

- Operates at a 1.0 GHz clock, with a 256-bit internal data path. This
  equates to \~32 bytes per cycle, designed to be roughly equivalent to
  16 lanes of PCIe Gen 4 injection bandwidth.
- The HPE Slingshot NIC uses 512-byte packets (on the PCIe bus)
- At 512 bytes per PCIe packet, and 32 bytes per cycle, a normal
  transfer will  take 16 cycles.

HPE Slingshot 400Gbps NIC:

- Operates at a 1.1 GHz clock, with a 512-bit data path. This equates to
  \~64 bytes per cycle, designed to be roughly equivalent to what 16
  lanes of PCIe Gen 5 injection bandwidth.
- The HPE Slingshot NIC uses 512-byte packets (on the PCIe bus)
- At 512 bytes per PCIe packet, and 64 bytes per cycle, a normal
  transfer will take 8 cycles.

Consider this HPE Slingshot 200 example:

`PARBS_TARB_PI_POSTED_PKTS` = 849,043,697 (or 8.4 x 10^8^)

`PARBS_TARB_PI_POSTED_BLOCKED_CNT` = 3,091,900,764 (or 3.1 x 10^9^)

The job run is 23 seconds.

This means:

- The rate packets are written to memory - posted packets over run time = 8.4 x 10^8^/23 = 3.7 x 10^7^ PCIe packets / sec
- The blocked cycle count rate - blocked PCIe cycles over the time = 3.1 x 10^9^/23 = 1.3 x 10^8^ blocked cycles / sec

Analysis:

- The average number of blocked cycles per packet = 3.1 x 10^9^ / 8.4 x
  10^8^ = 3.7 cycles (round to 4 cycles). Since each Slingshot 200
  packet should take 16 PCIe cycles, and here they are actually taking
  16 + 4 = 20 cycles, this means an impact of 4/20 = about a 20% hit on
  bandwidth due to congestion.
- The 200Gbps NIC operates at 1 GHz = 1 x 10^9^ cycles per second.
  An average of 1.3 x 10^8^ blocked cycles out of 1 x 10^9^ capacity
  means that the NIC is blocked for 13% (1.3 x 10^8^ divided by 1 x 10^9^ )
  of its cycles. This ideally should be \<1%, so it indicates PCIe
  congestion.
- The packet rate is (8.4 x 10^8^) / 23 seconds = 3.7 x 10^7^ packets
  per second. Each packet is 512 bytes, so multiply by packets per
  second to get 19 GB/second bandwidth. (The difference between the
  theoretical maximum of 32 GBps is a function both of congestion, as
  well as additional overheard cycles that the NIC incurs as part of
  normal operation.)

The result that being blocked for 13% of the cycles means a 20% hit on
bandwidth may not be intuitive. Imagine a highway lane is closed 13% of
the time. Every closure causes traffic to slow down before and after,
and as a result average throughput drops by 20% even though the lane
was not closed 20% of the day. That is similar to the situation of
congestion, while the NIC may be fully blocked for a fraction of
cycles, the impact on measured bandwidth can be larger because
backpressure events not only prevent forward progress during the blocked
cycles, they also disrupt DMA pipelines and require recovery time before
full throughput is restored. As a result, each transfer may take more
cycles to complete than in the ideal case.

This is a great illustration of how the unique congestion control
capabilities of HPE Slingshot can substantially improve effective
bandwidth utilization.

## Network statistics: bandwidth and congestion

Backpressure from the network tells the NIC to slow down or pause
activity when the network cannot accept traffic at the injected rate,
while backpressure from the NIC can tell the network to slow down
sending data. Pause counters give visibility to both. Low pause values
indicate healthy operation. High pause values indicate that application
execution is materially slowed when pause rates exceed approximately
10% of cycles.

Note that counters on the switch provide the same information to
administrators (with tx on the switch equating to rx pause on the NIC,
and vice versa).

In addition to Pause counters, there are counters to count packets sent
and received, and to understand the size of packets as classified into
12 packet size bins.

**Network statistics counters:**

|**Counter**|**Description**|
|---|---|
|`HNI_TX_PAUSED_<n>`, `HNI_TX_PAUSED_0`, and `HNI_TX_PAUSED_1`|Count of cycles when the transmit path is paused for traffic class `<n>`. Default RDMA best-effort traffic classes are 0 and 1. A nonzero rate indicates that the connected switch is backpressuring NIC transmission. Divide the per-second pause rate by the NIC clock rate (1E9 Hz for Slingshot 200 or 1.1E9 Hz for Slingshot 400) to calculate the fraction of time paused; multiply by 100 for a percentage. For a raw count, divide by elapsed seconds and the clock rate.|
|`HNI_RX_PAUSED_<n>`, `HNI_RX_PAUSED_0`, and `HNI_RX_PAUSED_1`|Count of cycles when the receive path is paused for traffic class `<n>`. Default RDMA best-effort traffic classes are 0 and 1. Divide the per-second pause rate by the NIC clock rate to calculate the fraction of time paused; multiply by 100 for a percentage. For a raw count, divide by elapsed seconds and the clock rate. Pause rates of 10% or more indicate backpressure from the node. Host-to-NIC counters can help diagnose the cause.|
|`HNI_PKTS_RECV_BY_TC_<n>`|Number of packets received by traffic class `<n>`. There are 8 counters. The default classes are 0 for request traffic and 1 for response traffic.|
|`HNI_PKTS_SENT_BY_TC_<n>`|Number of packets sent by traffic class `<n>`. There are 8 counters. The default classes are 0 for request traffic and 1 for response traffic.|
|`HNI_TX_OK_<min>_to_<max>`|Number of packets sent by size bin.|
|`HNI_TX_OK_27`|Number of 27-byte packets sent.|
|`HNI_TX_OK_35`|Number of 35-byte packets sent.|
|`HNI_TX_OK_64`|Number of 64-byte packets sent.|
|`HNI_TX_OK_36_TO_63`|Number of packets sent with sizes from 36 bytes to 63 bytes.|
|`HNI_TX_OK_65_TO_127`|Number of packets sent with sizes from 65 bytes to 127 bytes.|
|`HNI_TX_OK_128_TO_255`|Number of packets sent with sizes from 128 bytes to 255 bytes.|
|`HNI_TX_OK_256_TO_511`|Number of packets sent with sizes from 256 bytes to 511 bytes.|
|`HNI_TX_OK_512_TO_1023`|Number of packets sent with sizes from 512 bytes to 1,023 bytes.|
|`HNI_TX_OK_1024_TO_2047`|Number of packets sent with sizes from 1,024 bytes to 2,047 bytes.|
|`HNI_TX_OK_2048_TO_4095`|Number of packets sent with sizes from 2,048 bytes to 4,095 bytes.|
|`HNI_TX_OK_4096_TO_8191`|Number of packets sent with sizes from 4,096 bytes to 8,191 bytes.|
|`HNI_TX_OK_8192_TO_MAX`|Number of packets sent with sizes from 8,192 bytes to the maximum packet size.|
|`HNI_RX_OK_<min>_to_<max>`|Number of packets received by size bin. There are 12 counters. See the corresponding TX counters for size-bin details.|
|`HNI_RX_OK_27`|Number of 27-byte packets received.|
|`HNI_RX_OK_35`|Number of 35-byte packets received.|
|`HNI_RX_OK_64`|Number of 64-byte packets received.|
|`HNI_RX_OK_36_TO_63`|Number of packets received with sizes from 36 bytes to 63 bytes.|
|`HNI_RX_OK_65_TO_127`|Number of packets received with sizes from 65 bytes to 127 bytes.|
|`HNI_RX_OK_128_TO_255`|Number of packets received with sizes from 128 bytes to 255 bytes.|
|`HNI_RX_OK_256_TO_511`|Number of packets received with sizes from 256 bytes to 511 bytes.|
|`HNI_RX_OK_512_TO_1023`|Number of packets received with sizes from 512 bytes to 1,023 bytes.|
|`HNI_RX_OK_1024_TO_2047`|Number of packets received with sizes from 1,024 bytes to 2,047 bytes.|
|`HNI_RX_OK_2048_TO_4095`|Number of packets received with sizes from 2,048 bytes to 4,095 bytes.|
|`HNI_RX_OK_4096_TO_8191`|Number of packets received with sizes from 4,096 bytes to 8,191 bytes.|
|`HNI_RX_OK_8192_TO_MAX`|Number of packets received with sizes from 8,192 bytes to the maximum packet size.|
