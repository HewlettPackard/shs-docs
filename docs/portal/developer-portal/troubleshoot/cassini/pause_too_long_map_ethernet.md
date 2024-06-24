
# Map Ethernet TX/RX queues to CPUs

The following sub-sections outline how to map Ethernet TX and RX queues to
CPUs.

## Generate Ethernet TX/RX queue EQ list

Each Ethernet TX and RX queue are assigned to a unique event queue (EQ). The
EQs are then optionally assigned to an IRQ.

The EQ ID is assigned to which TX/RX queue can be retrieved through debugfs.
The following provides an example of this for an Ethernet interface using CXI
device cxi0.

```screen
# cat /sys/kernel/debug/cxi_eth/cxi0
rss_indir_size=64
idc_dma_threshold=224
small_pkts_buf_size=1048576
small_pkts_buf_count=4
large_pkts_buf_count=1024
num_prio_buffers_desired=1024
num_prio_buffers=9216
num_req_buffers_desired=4
num_req_buffers=36
shared TGT REQ CQ=0
RX queue 0
  EQ=3, PtlTE=1 TGT PRIO CQ=1
  Preferred NUMA Node: 2
  Preferred CPU: 32
  list rx_unallocated=empty
  list rx_ready=empty
  list rx_in_use=not empty
  rx_bufs_count=1028
  append_prio=117566
  append_req=8
  append_failed=0
  unlinked_prio=116542
  unlinked_req=4
  Last bad RC for dropped fragment: 1
  bucket for napi_schedule
    min_ts=20
    max_ts=121
      < 1 ns       0
      < 2 ns       0
      < 4 ns       0
      < 8 ns       0
      < 16 ns       0
      < 32 ns       21914
      < 64 ns       43821
      < 128 ns       46
      < 256 ns       0
      < 512 ns       0
      < 1024 ns       0
      < 2048 ns       0
      < 4096 ns       0
      < 8192 ns       0
      < 16384 ns       0
      < 32768 ns       0
      < 65536 ns       0
      < 131072 ns       0
      < 262144 ns       0
      < 524288 ns       0
      < 1048576 ns       0
      < 2097152 ns       0
      higher          0

PTP RX queue 16
  EQ=4, PtlTE=2 TGT PRIO CQ=2
  Preferred NUMA Node: 2
  Preferred CPU: 34
  list rx_unallocated=empty
  list rx_ready=empty
  list rx_in_use=not empty
  rx_bufs_count=1028
  append_prio=1024
  append_req=4
  append_failed=0
  unlinked_prio=0
  unlinked_req=0
  Last bad RC for dropped fragment: 1
  bucket for napi_schedule
    min_ts=0
    max_ts=0
      < 1 ns       0
      < 2 ns       0
      < 4 ns       0
      < 8 ns       0
      < 16 ns       0
      < 32 ns       0
      < 64 ns       0
      < 128 ns       0
      < 256 ns       0
      < 512 ns       0
      < 1024 ns       0
      < 2048 ns       0
      < 4096 ns       0
      < 8192 ns       0
      < 16384 ns       0
      < 32768 ns       0
      < 65536 ns       0
      < 131072 ns       0
      < 262144 ns       0
      < 524288 ns       0
      < 1048576 ns       0
      < 2097152 ns       0
      higher          0

TX queue 0
  EQ=5, default TX CQ=0
  EQ=5, tagged TX CQ=1
  Preferred NUMA Node: 2
  Preferred CPU: 32
  polling: 6899
  TX Q stopped count: 0
  idc: 21966
  idc_bytes: 1357092
  dma: 8432
  dma_bytes: 7970343
  dma_forced: 5
  force_dma: 116
  force_dma_interval: 125
  free default TX CQ slots: 462
  free tagged TX CQ slots: 4084
  netdev queue state: 0x0

ALL buckets for RX napi_schedule
    min_ts=20
    max_ts=121
      < 1 ns       0
      < 2 ns       0
      < 4 ns       0
      < 8 ns       0
      < 16 ns       0
      < 32 ns       21914
      < 64 ns       43821
      < 128 ns       46
      < 256 ns       0
      < 512 ns       0
      < 1024 ns       0
      < 2048 ns       0
      < 4096 ns       0
      < 8192 ns       0
      < 16384 ns       0
      < 32768 ns       0
      < 65536 ns       0
      < 131072 ns       0
      < 262144 ns       0
      < 524288 ns       0
      < 1048576 ns       0
      < 2097152 ns       0
      higher          0
```

From the above, we get the following TX/RX queue to EQ ID mapping.

* RX Queue 0: EQ 3
* PTP RX Queue 16: EQ 4
* TX Queue 0: EQ 5

NOTE: The above example has an Ethernet interface configured with only one
TX and RX queue.

## Map CXI EQs to IRQ name

For each currently configured EQ, a per device EQ entry will be created in
debugfs. The following is for CXI device cxi0 EQ 3 (i.e. `cxi-eth` cxi0 RX queue
0).

```screen
# cat /sys/kernel/debug/cxi/cxi0/eq/3
EQ id: 3
event MSI vector: cxi0_comp0
status MSI vector: none
slots: 33344
flags: 2
```

Looking at the `event MSI vector` field, EQ 3 is using the Linux IRQ with the
name `cxi0_comp0`.

Repeating this process for the other EQs, we get the following map.

* RX Queue 0: cxi0_comp0
* PTP RX Queue 16: cxi0_comp2
* TX Queue 0: cxi0_comp128

## Map IRQ name to IRQ number

The IRQ name collected in the previous step will be reported as a directory in
`/proc/irq/<num>/<name>`. A walk of `/proc/irq/` is required to map IRQ name to
IRQ number. For example:

```screen
# find /proc/irq/ -name cxi0_comp0
/proc/irq/112/cxi0_comp0
```

`cxi0_comp0` maps to IRQ 112.

Repeating this process for the other IRQ names, we get the following map.

* RX Queue 0: IRQ 112
* PTP RX Queue 16: IRQ 114
* TX Queue 0: IRQ 240

## Map IRQ number to effective affinity CPU

Once the IRQ number has been found, the effective affinity can be found in
`/proc/irq/<num>/effective_affinity_list`. The following is an example of this.

```screen
# cat /proc/irq/112/effective_affinity_list
32
```

IRQ 112 interrupts will be occurring on CPU 32.

Repeating this process for the other IRQ numbers, we get the following map.

* RX Queue 0: CPU 32
* PTP RX Queue 16: CPU 34
* TX Queue 0: IRQ CPU 32

At a minimum, kernel services should avoid CPUs used by RX queues. In this
example, it is only CPU 32.
