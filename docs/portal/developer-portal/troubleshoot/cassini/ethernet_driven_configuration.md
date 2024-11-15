# Ethernet driver configuration

To optimize performance, the Ethernet driver (`cxi-eth`) offers several parameters that can be changed when loading the driver.

## Receive Side Scaling support

With Receive Side Scaling (RSS), each received packet is hashed, and given to the corresponding queue.

The module parameter `max_rss_queues` defines the maximum number of queues that can be used. The default value is 16 and it can be set as a power of 2, up to 64.

The current number of RX queues can be dynamically changed, and must be a power of 2, up to the value defined by `max_rss_queues`.

By default, each interface is configured with only one receive queue.

To change the number of RX queues:

```screen
ethtool -L hsn0 rx 4
```

To see the RSS queues:

```screen
$ ethtool -l hsn0

Channel parameters for hsn0:
Pre-set maximums:
RX:             4
TX:             1
Other:          0
Combined:       1
Current hardware settings:
RX:             1
TX:             1
Other:          1
Combined:       1
```

When a new number of RSS entries is programmed, the indirection table is reset. The indirection table has 64 entries by default, and that
can be changed by the `rss_indir_size` module parameter. The value must be a power of 2, up to 2048.

To show the indirection table:

```screen
$ ethtool -x hsn0

RX flow hash indirection table for hsn0 with 4 RX ring(s):
    0:      0     1     2     3     0     1     2     3
    8:      0     1     2     3     0     1     2     3
   16:      0     1     2     3     0     1     2     3
   24:      0     1     2     3     0     1     2     3
   32:      0     1     2     3     0     1     2     3
   40:      0     1     2     3     0     1     2     3
   48:      0     1     2     3     0     1     2     3
   56:      0     1     2     3     0     1     2     3
```

In this example, a packet with a hash of 58 will go to RSS queue number 2.

The driver is currently configured with default hashes:

```screen
C_RSS_HASH_IPV4_TCP
C_RSS_HASH_IPV4_UDP
C_RSS_HASH_IPV6_TCP
C_RSS_HASH_IPV6_UDP
```

You cannot change these values during operation, as ethtool does not support the 200Gbps NIC hash mechanism.

Program the indirection table to equally split the traffic between queues 0 and 1 only:

```screen
ethtool -X hsn0 equal 2
```

## Buffer sizing

Small received packets are sharing a set of large buffers, while bigger packets are received in individual smaller buffers. In other
words, a large buffer will receive many small packets, while a small buffer (still enough to receive an MTU packet) will receive only one large packet before being re-used.

Internally, each large packet buffer is used and freed after receiving one single packet, while the small packet buffers will receive many small packets before being freed.

The driver provides the following tuning parameters for these buffers:

- `small_pkts_buf_size`: size of one large buffer receiving small packets. It defaults to 1MB.
- `small_pkts_buf_count`: number of large buffers to make available. It defaults to 4.
- `large_pkts_buf_count`: number of small buffers intended to receive larger packets. Their size is always 4KB. Defaults to 64.
- `buffer_threshold`: Ethernet packets with length greater than or equal to this threshold are put in one large packet buffer, otherwise they land in a shared small packet buffer. Defaults to 256.

Depending on the type of traffic, it might be more efficient to have more buffer of one type or the other, and/or have a different
threshold.

A jumbo packet (e.g. 9000 bytes) is split into 2 large packets buffers of 4KB, and the remainder will be stored in the current small packets buffer. The Linux stack can process these packets without re-assembling the data.

## Jumbo frames

By default, each Ethernet interface has an MTU of 1500. 200Gbps NIC supports jumbo frames up to 9000, which improves performances for
large transfers.

To change the MTU:

```screen
ip link set dev hsn0 mtu 9000
```

## Other Ethernet module parameters

Small Ethernet packets, up to 224 bytes, can be inlined in a 200Gbps NIC command instead of using a more costly DMA operation. The `idc_dma_threshold` command sets the threshold for these packets and defaults to the maximum possible of 224 bytes, including MAC headers. You can safely change these values while the device is active.

The driver also support multiple transmit (TX) queues. Linux employs round-robin protocol to these queues when sending packets. The module parameter `max_tx_queues` defines the number of queues to create and defaults to 16. The `max_tx_queues` can be set from 1 to 64.

`lpe_cdt_thresh_id` controls the 200Gbps NIC LPE append credit id to use. Its value can be 0 to 3. Do not change this value.
