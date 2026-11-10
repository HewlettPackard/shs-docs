# Counters for analyzing hardware offloads and performance

***This section is primarily for very advanced developers.***

The HPE Slingshot NIC accelerates many communication functions in
hardware, such as message matching, rendezvous data movement, address
translation, DMA, and reliability handling, to reduce CPU involvement
and maximize overlap between computation and communication. The counters
in this section provide visibility into how effectively these hardware
offloads are being used, and where execution may be falling back to
software paths or encountering resource pressure. Unlike high-level
performance metrics, these counters expose activity inside specific NIC
engines and pipelines, making them especially useful for understanding
performance variability, diagnosing scaling limits, and distinguishing
between network-induced effects and host- or application-induced
bottlenecks.

For users who do not need to tune hardware offloads directly in the
code, these counters offer valuable insight into whether applications
are benefiting from HPE Slingshot's offload capabilities as intended,
and whether behavior such as software matching, translation cache
misses, or DMA backpressure affects performance. In some areas
Libfabric environment variable settings may improve performance.

## Translation unit counters

The HPE Slingshot NIC includes a dedicated Address Translation Unit
(ATU) with on-NIC translation caches. These caches store recently used
address translations so that repeated access to the same memory regions
can proceed without invoking expensive page walks or on-demand paging
operations. Because RDMA allows the NIC to read and write application
memory directly, bypassing the CPU, address translation is on the
critical path for both performance and scalability.

Translation counters expose the behavior of this subsystem, including
cache hit and miss rates, eviction activity, and translation latency. By
examining these together, advanced users can identify memory-related
bottlenecks that would otherwise appear as unexplained performance loss
or variability.

Translation behavior becomes especially important for applications that:

- Touch a large fraction of system memory
- Perform fine-grained RDMA accesses (for example, 64-byte operations)
- Frequently allocate and free memory
- Use GPU memory or non-default page sizes

A healthy application typically shows:

- High translation cache hit counts relative to misses
- Low eviction rates
- Stable behavior across nodes in a job

High values of cache misses or evictions indicate that the NIC's
translation cache is under pressure. This can occur when an application
accesses a very large or fragmented memory footprint, or when memory
regions are short-lived and frequently replaced. Each miss must be
serviced through the host translation machinery: the NIC performs a
page-table walk by reading page-table data from host memory over PCIe,
so host dynamic random access memory (DRAM) bandwidth and PCIe read latency can introduce latency and
backpressure. A persistent high miss rate is a strong indicator that
performance loss is being driven by translation overhead, manifested as
reduced RDMA throughput or increased variability between runs.

A practical way to summarize behavior is to focus on the ATU miss rate,
for instance, the fraction of translation lookups that miss the NIC cache
(misses divided by total of hits plus misses).

Comparing cache hit counters by page size can be revealing: if most hits
occur on the base page size while miss rates remain high, the workload
may benefit from larger page sizes which improve translation cache
efficiency by covering more memory per entry.

The HPE Slingshot NIC can use non-standard huge page sizes to improve
application performance if the operating system allows (like legacy Cray
OS). Most current systems, including newer Cray OS releases, utilize
standard Linux page sizes with stock kernels, which is what is
documented in the following table.

**Translation cache counters:**

|**Counter Name**|**Description**|
|---|---|
|`ATU_CACHE_HIT_BASE_PAGE_SIZE_<n>`|Number of translation cache hits using the base 4 KB pages. `<n>` refers to the counter group, today 0.|
|`ATU_CACHE_HIT_DERIVATIVE1_PAGE_SIZE_<n>`|Number of translation cache hits using the derivative-1 page size, typically 2 MB. The derivative page sizes are set per addressing context from the mapping's huge-page configuration.|
|`ATU_CACHE_HIT_DERIVATIVE2_PAGE_SIZE_<n>`|Number of translation cache hits using the derivative-2 page size, typically 1 GB.|
|`ATU_CACHE_MISS_0`|Number of translation cache misses in pool 0, indicating that a required translation was not present in the NIC cache.|
|`ATU_CACHE_EVICTIONS`|Number of times a translation entry was evicted from the NIC cache to make room for a new entry.|

## Client-specific translation pressure

Use the client-specific ATU counters to understand *which direction of
traffic* is driving misses. OXE-related translation correlates with
read-side behavior (pulling from source memory), IXE-related activity
correlates with write-side behavior (writing into destination memory),
while EE-related misses may point to event-queue or completion-related
translation activity (for example, bursts of completion/event processing
that require translations).

This client breakdown is most useful as a directional clue rather than a
standalone conclusion. If one client dominates misses (or requests)
during a slow phase, it can help you connect translation overhead to the
dominant access pattern in that phase (read-heavy vs write-heavy vs
event/completion heavy), and then decide whether to focus on source
buffers, destination buffers, or progress/completion behavior. A strong
imbalance across clients may indicate that a specific communication
phase or access pattern is responsible for the observed overhead.

**Client-specific translation counters:**

|**Counter Name**|**Description**|
|---|---|
|`ATU_CLIENT_REQ_EE`|Number of translation requests issued by the Event Engine (EE).|
|`ATU_CLIENT_REQ_IXE`|Number of translation requests issued by the Input Transfer Engine (IXE), typically associated with DMA writes into destination memory.|
|`ATU_CLIENT_REQ_OXE`|Number of translation requests issued by the Output Transfer Engine (OXE), typically associated with DMA reads from source memory.|
|`ATU_CACHE_MISS_EE`|Translation cache misses attributable to EE clients.|
|`ATU_CACHE_MISS_IXE`|Translation cache misses attributable to IXE clients.|
|`ATU_CACHE_MISS_OXE`|Translation cache misses attributable to OXE clients.|

## ATU latency

These counters report a 4-bin histogram of the latency for address
translations. Use this as a tail-latency detector for translation. If
most translations land in the fastest bin, they are staying on the fast
path. If a meaningful fraction shifts into slower bins, translation is
increasingly taking a slower path, commonly associated with translation
cache misses, page-table walk activity, or ATU pipeline stalls and
contended servicing, and can show up as jitter or reduced throughput for
fine-grained RDMA.

Interpret this histogram together with `ATU_CACHE_MISS_0` and
`ATU_CACHE_EVICTIONS` (and, if needed, client counters such as
`ATU_CLIENT_REQ_OXE`, `ATU_CLIENT_REQ_IXE`, and `ATU_CLIENT_REQ_EE`) to
determine whether slow translations correlate with cache pressure and
which direction of DMA traffic is driving translation demand.

**ATU latency counter definitions:**

In the following table, the NIC Translation Agent (NTA) is the NIC's on-chip page-table walker.

| **Counter name** | **Description** |
|---|---|
| `ATU_NTA_TRANS_LATENCY_0` | Latency values in bin 0. See the bin mapping in this section. |
| `ATU_NTA_TRANS_LATENCY_1` | Latency values in bin 1. See the bin mapping in this section. |
| `ATU_NTA_TRANS_LATENCY_2` | Latency values in bin 2. See the bin mapping in this section. |
| `ATU_NTA_TRANS_LATENCY_3` | Latency values in bin 3. See the bin mapping in this section. |

These counters cover NTA translations only. In ATS mode, use the
`ATU_ATS_TRANS_LATENCY_<n>` counters, which have the same 4-bin layout.

The histogram increments in 128 ns ticks on both HPE Slingshot 200 and 400
NICs (`CNTR_INC` defaults to 7, so one tick is `2^7` ns).

**ATU latency-bin mapping:**

| **Bin** | **Tick range** | **Latency on both NIC generations** |
|---:|---:|---:|
| 0 | `< 16` | `< 2,048 ns` (`< 2.048 us`) |
| 1 | `16–31` | `2,048–4,095 ns` (`2.048–4.095 us`) |
| 2 | `32–47` | `4,096–6,143 ns` (`4.096–6.143 us`) |
| 3 | `≥ 48` | `≥ 6,144 ns` (`≥ 6.144 us`) |

## Message matching handling counters

The HPE Slingshot NIC implements hardware message matching (described
earlier) through a List Processing Engine (LPE) in the chip. LPE
counters exist to answer a straightforward performance question: *is my
MPI communication taking the NIC's fast, hardware-matched path, and am I
using that hardware resource efficiently?* The HPE Slingshot NIC can
offload a large part of MPI receive-side message matching into the NIC,
which reduces CPU overhead and can improve overlap if the application is
written to optimize overlap. However, the matching machinery is not
infinite: it relies on finite on-NIC resources (match list entries,
buffer space for unexpected traffic, and list-processing bandwidth).
When applications stress those resources, performance can drop even
though the network link itself is healthy.

At a high level, problems show up in two ways.

- First, messages can arrive before their receives are posted, forcing
  the NIC/runtime to treat them as unexpected and stage payload into an
  overflow buffer (later requiring extra bookkeeping and often a copy).
- Second, even when receives are posted "in time," some receive patterns
  are harder to match than others: heavy use of
  `MPI_ANY_SOURCE`/`MPI_ANY_TAG`, many outstanding receives, or many message
  classes sharing the same tag can cause extra list processing (more
  comparisons per message) and reduce effective message rate. The LPE
  counters are therefore most useful when you read them in two passes.

**Hardware matching efficiency versus effectiveness:**

- Hardware matching effectiveness: confirm you are mostly using hardware
  matching rather than falling back to software endpoints.
- Hardware matching efficiency: for the hardware-matched traffic, check
  whether you are using the hardware efficiently, meaning avoiding
  unexpected/overflow staging and requiring excessive search work due to
  wildcards or deep and ambiguous receive queues.

## Rendezvous and bulk data offload counters

For large messages, the HPE Slingshot NIC uses rendezvous protocols that
separate control exchange from bulk data movement. Once placement is
established, payload packets are transferred using RDMA and may be
delivered out of order, allowing the fabric to exploit fine-grained
adaptive routing and maximize bandwidth under congestion.

These counters describe how effectively large-message transfers are
being offloaded to hardware and whether resource limitations are causing
fallback to less efficient paths. A high fraction of rendezvous
operations being offloaded indicates efficient large-message handling. A
growing gap between total rendezvous puts and offloaded puts (when
running in hardware matching mode) suggests resource pressure,
suboptimal rendezvous thresholds, or excessive concurrency in large
transfers. When large-message bandwidth is lower than expected despite
minimal network congestion, these counters often reveal whether
rendezvous handling is falling back to higher-overhead mechanisms.

**Rendezvous and bulk data offload counters:**

|**Counter name**|**Description**|
|---|---|
|`LPE_RNDZV_PUTS_0`|Number of rendezvous Put operations received. The Put is the header or control part of the rendezvous transfer.|
|`LPE_RNDZV_PUTS_OFFLOADED_0`|Number of rendezvous Put operations successfully offloaded to hardware. With hardware matching, typically nearly all rendezvous Puts are offloaded. With software matching, none are offloaded; hybrid matching may show both.|
|`CQ_DMA_CMD_COUNTS_<n>`|Counts successfully parsed DMA-path commands as the first flit is sent to OXE; it does not count commands issued through the IDC path. `<n>` identifies the operation type; see the mapping in this section.|
|`OXE_PTL_TX_PUT_PKTS_TSC_<n>`|Counts all Portals packets injected into the fabric by traffic shaping class, despite `PUT` in the counter name. The TSC is an internal chip class used to isolate traffic through NIC buffers.|

The `CQ_DMA_CMD_COUNTS_<n>` operation mapping is:

**CQ DMA command operation mapping:**

|**`<n>`**|**Operation**|
|---:|---|
|`0`, `10`, `11`, `12`|Internal use|
|`1`|Put (RDMA write)|
|`2`|Get (RDMA read)|
|`3`|Rendezvous Put (header/control operation)|
|`4`|Non-fetching atomic|
|`5`|Fetching atomic|
|`6`|Send an Ethernet packet|
|`7`|Send a small message|
|`8`|Non-matching DMA Put|
|`9`|Non-matching DMA Get|
|`13`|Put in a reduction (collectives offload) operation|

For the vast majority of systems using the default traffic-class profiles,
the `OXE_PTL_TX_PUT_PKTS_TSC_<n>` traffic-class mapping is:

- Best Effort: PCP 0 / 1 maps to TSC 4 / 5
- Bulk Data: PCP 2 / 3 maps to TSC 2 / 3
- Low Latency: PCP 4 / 5 maps to TSC 0 / 1
- Ethernet/IP: PCP 6 maps to TSC 6

## Command queues and event processing counters

The HPE Slingshot NIC processes RDMA work asynchronously by parsing
host-posted commands in the NIC's Command Queue and generating completion
notifications through the Event Engine and event queues. This avoids
frequent CPU polling or interrupts and sustains high operation rates.
These counters help determine whether the command-dispatch and
event/completion pipeline is keeping up, is not being fed by software,
or is encountering internal contention or event-queue pressure. Deferred
or dropped events and blocked command progress can appear as stalls even
when the network is healthy.

Here, `CQ` means Command Queue, not the Libfabric Completion Queue.
Blocked command-queue cycles can indicate internal contention at high
operation rates. A high number of overhead commands relative to DMA
commands can indicate substantial bookkeeping per unit of data movement,
such as many fences, synchronization points, or small command batches.
A high DMA count with a modest command count suggests that data movement
dominates. Dropped or deferred events can indicate that software is not
progressing completion queues frequently enough.

**Command queue and event processing counters:**

|**Counter name**|**Description**|
|---|---|
|`CQ_NUM_CQ_CMDS_0`|Number of overhead or control traffic commands processed.|
|`CQ_NUM_DMA_CMDS_0`|Number of DMA commands processed.|
|`CQ_CYCLES_BLOCKED_0`|Number of cycles during which Command Queue processing in pool 0 was blocked by internal contention.|
|`EE_EVENTS_ENQUEUED_CNTR_0`|Number of completion events successfully enqueued.|
|`EE_EVENTS_DROPPED_ORDINARY_CNTR_0`|Number of events dropped because the event queue was full.|
|`EE_DEFERRED_EQ_SWITCH_CNTR_0`|Number of deferred event-queue buffer switches due to insufficient space.|

## Immediate-send and triggered-operation offloads

Normally, the host writes RDMA commands, which the NIC parses, arbitrates,
and dispatches to execution engines. Hardware modes accelerate some
operations to reduce latency:

- For small messages, the low-latency path can transfer payload
  immediately without the usual parsing and arbitration process. These
  operations are identified by `LL` (low latency) counters. If the
  immediate-send path is unavailable, the NIC uses the normal path.
- Triggered operations let middleware such as MPI and SHMEM configure
  RDMA operations, including operations with GPU memory, to progress
  without continuous host polling. The NIC tracks progress with hardware
  counters and starts dependent operations when the trigger condition is
  met.

Higher-level software enables these modes through Libfabric. Most users
access them through optimized MPI, such as HPE Cray MPICH, or SHMEM, such
as HPE Slingshot SHMEM. These counters are most useful to developers
writing middleware that uses these CXI provider features.

**Immediate-send and triggered-operation counters:**

|**Counter name**|**Description**|
|---|---|
|`TOU_NUM_TRIG_CMDS_0`|Number of triggered commands issued.|
|`CQ_NUM_LL_OPS_SUCCESSFUL_0`|Number of low-latency operations successfully processed.|
|`CQ_NUM_LL_OPS_REJECTED_0`|Number of low-latency operations that could not use the immediate-send path and were handled through normal processing because of resource contention.|
|`CQ_NUM_LL_OPS_SPLIT_0`|Number of low-latency operations not accepted because the host CPU's write of the operation data was split into multiple writes, some smaller than 64 bytes (for example, a partially flushed write-combining buffer), losing the immediate-send latency benefit.|

## Latency

Latency histograms show typical and tail latency that can drive
application-visible stalls. Read them as distributions, not single
average values. One histogram measures request/response latency to a
remote endpoint over the network; the other measures source-side
host-access latency before packet transmission. Network round-trip
latency on a quiet, healthy system is typically a few microseconds.
Host-access latency is affected by the host processor, PCIe path, NUMA
placement, and source memory.

The `PCT_REQ_RSP_LATENCY_<n>` counters form a 32-bin histogram of network
round-trip latency. Under load, the distribution can widen and shift to
higher bins; growth in the highest bins indicates tail latency that can
cause application-visible stalls.

The `PCT_HOST_ACCESS_LATENCY_<n>` counters form a 16-bin histogram of
source-side host access latency: the time between allocating a Source
Packet Table (SPT) entry and sending the packet. It includes address
translation and PCIe read latency for DMA commands. Comparing the
distribution and its tail across runs is more useful than comparing
averages.

Both histograms use nanosecond timer values, not NIC clock cycles, and
their time base does not vary between NIC generations. The base and
increment settings are controlled by chipset registers and are typically
left at their defaults. A timer rollover can place a measured latency in
an incorrect bin.

**Latency histogram parameters:**

|**Histogram**|**Number of bins**|**Default base**|**Default increment**|**Resulting tail bucket**|
|---|---:|---:|---:|---:|
|`PCT_REQ_RSP_LATENCY`|32|2,048 ns|512 ns|`>= 17,408 ns`|
|`PCT_HOST_ACCESS_LATENCY`|16|256 ns|128 ns|`>= 2,048 ns`|

**Latency histogram counters:**

|**Counter name**|**Description**|
|---|---|
|`PCT_REQ_RSP_LATENCY_<n>` (`n` = 0-31)|Latency distribution for request/response transactions over the network.|
|`PCT_HOST_ACCESS_LATENCY_<n>` (`n` = 0-15)|Source-side latency from SPT entry allocation to packet transmission, including address translation and PCIe DMA reads.|

The suffix identifies the zero-based histogram bin.
