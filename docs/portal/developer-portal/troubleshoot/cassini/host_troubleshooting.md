
# 200Gbps NICs appear down

The global QoS policy must be configured in `topology-policies/template-policy`. For more information, see "Fabric Configuration for 200Gbps NIC" section in the *HPE Slingshot Administration Guide*.

# Retry Handler

Each 200Gbps NIC must have a Retry Handler daemon running and they are indexed by device number, such as `cxi0`, `cxi1`, and so on.
Note: These instructions refer to `cxi0` in the example.

If the retry handler crashes for some reason, the node must be rebooted. Due to the crash, an unpredictable state (missing traffic that requires retry) may be reached, which can result in putting the fabric into a bad state.
In addition, restarting the retry handler with any amount of traffic flowing, regardless if it would generate a PCT event, is not a safe operation. This must be avoided. If you want to deploy a new retry handler configuration, reload `cxi-core` or reboot the node.

`systemd` and `udev` must automatically handle starting the retry handler, but in case of
issues, verify handlers:

```screen
# systemctl status -q cxi_rh@cxi0
  cxi_rh@cxi0.service - Cassini Retry Handler on cxi0
   Loaded: loaded (/usr/lib/systemd/system/cxi_rh@.service; static; vendor preset: disabled)
   Active: active (running) since Tue 2021-02-09 10:44:08 CST; 1min 17s ago
```

If the retry handler failed to start, verify that the corresponding `/dev/cxi<n>` device is present,
and check for errors in dmesg.

```screen
# ls /dev/ | grep cxi
```

```screen
# journalctl | grep cxi_core
or
# dmesg -T |grep cxi
```

If you do not find any issues, manually start the retry handler again:

```screen
# systemctl start cxi_rh@cxi0.service
```

If there are persistent issues or if the retry handler has crashed, it is useful to gather logs:

```screen
# journalctl --output=short-precise -u cxi_rh@cxi0 >> $LOG_PATH
```

There are retry handler counters that are also useful to gather for debugging.
These files can be found in `/run/cxi/cxi<n>`.

```screen
# ls /run/cxi/cxi0/
accel_close_complete   nack_no_matching_conn  nacks		    sct_in_use	  spt_timeouts_o  trs_in_use
cancel_tct_closed      nack_no_target_conn    nack_sequence_error   sct_timeouts  spt_timeouts_u
connections_cancelled  nack_no_target_mst     pkts_cancelled_o	    smt_in_use	  srb_in_use
ignored_sct_timeouts   nack_no_target_trs     pkts_cancelled_u	    spt_in_use	  tct_in_use
mst_in_use	       nack_resource_busy     rh_sct_status_change  spt_timeouts  tct_timeouts
```

Inside the "config" subdirectory there are counters related to retry handler configuration.
For example, to get the current config file path you can use the following command:

```screen
# cat /run/cxi/cxi0/config/config_file_path
/scratch/shared/libcxi/install/etc/cxi_rh.conf
```

## Log Levels

The CXI Retry Handler supports multiple log levels, following the "SD-DAEMON" conventions. See the following man page for more details.

```screen
man sd-daemon
```

One of the following log levels should be used: *SD_NOTICE*(5), *SD_INFO*(6), *SD_DEBUG*(7), where *SD_DEBUG* is the most verbose option.
Since `cxi_rh` is a systemd service normal systemd mechanisms can be used to adjust the log level. Each systemd service has a service file which specifies certain configuration info. The service file for the RH is distributed as part of its RPM.
We can either edit the service file directly, or create an override file.

**Method 1: Override File**

1. Open a built in file editor and creates an empty override file.

    ```screen
    systemctl edit cxi_rh@cxi0
    ```

2. Add the following two lines, then save and quit.

    ```screen
    [Service]
    LogLevelMax=5
    ```

    The resulting file is saved to:

    ```screen
    /etc/systemd/system/cxi_rh@cxi0.service.d/override.conf
    ```

3. Restart the retry handler for these settings to take effect.

    ```screen
    systemctl restart cxi_rh@cxi0
    ```

These steps must be repeated for each `cxi_rh` instance (e.g. cxi1, cxi2, etc.).

**Method 2: Modify Service File Directly**

This method only requires changing one file as all the `cxi_rh` instances should refer to the same service file.
The typical path to the service file is:

```screen
/usr/lib/systemd/system/cxi_rh@.service
```

1. In the service file, edit the "LogLevelMax" line to the desired level. For example to use the log level *SD_NOTICE*(5):

    ```screen
    LogLevelMax=5
    ```

2. Since the service file of a running unit was modified, the following command must be executed.

    ```screen
    systemctl daemon-reload
    ```

3. Restart the retry handler(s):

    ```screen
    systemctl restart cxi_rh@cxi1
    ```

# 200Gbps NIC loopback mode

The 200Gbps NIC has an internal-loopback feature that causes transmitted data to be looped back into the NIC, bypassing any attached cable and switch.

The following command will put a 200Gbps NIC with the ethernet interface name `hsn0` into loopback mode:

```screen
ethtool --set-priv-flags hsn0 internal-loopback on
```

Once in loopback mode, tests such as Libfabric's `fi_pingpong` can be run with both processes on the same node.

To exit loopback mode, either restart the node, or reload the 200Gbps NIC drivers as follows:

```screen
systemctl stop 'cxi_rh@cxi*.service'
modprobe -r -a cxi-eth cxi-user cxi-core sbl
modprobe -a sbl cxi-core cxi-user cxi-eth
```

# Ethernet driver configuration

To optimize performance, the Ethernet driver (`cxi-eth`) offers
several parameters that can be changed when loading the driver.

## Receive Side Scaling support

With Receive Side Scaling (RSS), each received packet is hashed, and given to the
corresponding queue.

The module parameter `max_rss_queues` defines the maximum number of
queues that can be used. The default value is 16 and it can be set as a power
of 2, up to 64.

The current number of RX queues can be dynamically changed, and must
be a power of 2, up to the value defined by `max_rss_queues`.

By default, each interface is configured with only one receive queue.

To change the number of RX queues:

```screen
$ ethtool -L hsn0 rx 4
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

When a new number of RSS entries is programmed, the indirection table
is reset. The indirection table has 64 entries by default, and that
can be changed by the `rss_indir_size` module parameter. The value must
be a power of 2, up to 2048.

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

In this example, a packet with a hash of 58 will go to RSS queue
number 2.

The driver is currently configured with default hashes:

```screen
C_RSS_HASH_IPV4_TCP
C_RSS_HASH_IPV4_UDP
C_RSS_HASH_IPV6_TCP
C_RSS_HASH_IPV6_UDP
```

You cannot change these values during operation, as ethtool
does not support the 200Gbps NIC hash mechanism.

Program the indirection table to equally split the traffic between
queues 0 and 1 only:

```screen
$ ethtool -X hsn0 equal 2
```

## Buffer sizing

Small received packets are sharing a set of large buffers, while
bigger packets are received in individual smaller buffers. In other
words, a large buffer will receive many small packets, while a small
buffer (still enough to receive an MTU packet) will receive only one
large packet before being re-used.

Internally, each large packet buffer is used and freed after receiving
one single packet, while the small packet buffers will receive many
small packets before being freed.

The driver provides the following tuning parameters for these buffers:

* `small_pkts_buf_size`: size of one large buffer receiving small packets. It defaults to 1MB.

* `small_pkts_buf_count`: number of large buffers to make available. It defaults to 4.

* `large_pkts_buf_count`: number of small buffers intended to receive larger packets. Their size is always 4KB. Defaults to 64.

* `buffer_threshold`: Ethernet packets with length greater than or equal to this threshold are put in one large packet buffer, otherwise they land in a shared small packet buffer. Defaults to 256.

Depending on the type of traffic, it might be more efficient to have
more buffer of one type or the other, and/or have a different
threshold.

A jumbo packets, for example 9000 bytes, is split into 2 large packets
buffers of 4KB, and the remainder will be stored in the current small
packets buffer. The linux stack can process these packets without
re-assembling the data.

## Jumbo frames

By default, each ethernet interface has an MTU of 1500. 200Gbps NIC
supports jumbo frames up to 9000, which improves performances for
large transfers.

To change the MTU:

```screen
ip link set dev hsn0 mtu 9000
```

## Other Ethernet module parameters

Small Ethernet packets, up to 224 bytes, can be inlined in a 200Gbps NIC
command instead of using a more costly DMA
operation. The `idc_dma_threshold` command sets the threshold for these packets
and defaults to the maximum possible of 224 bytes, including MAC
headers. You can safely change these values while the device is active.

The driver also support multiple transmit (TX) queues. Linux employes
round-robin protocol to these queues when sending packets. The module parameter
`max_tx_queues` defines the number of queues to create and defaults
to 16. The `max_tx_queues` can be set from 1 to 64.

`lpe_cdt_thresh_id` controls the 200Gbps NIC LPE append credit id to
use. Its value can be 0 to 3. Do not change this value.

# 200Gbps NIC Errors

Each block in the The 200Gbps NIC ASIC contains a set of error flags. Error flags are defined in section 13 of the 200Gbps Slingshot NIC Software Developer's Guide. Errors vary in severity. Certain types of errors, like an "invalid VNI" error, are expected after an application terminates abnormally. Others, like a multi-bit error, may signal the need for a NIC reset.

An interrupt is generated when an error is raised. The 200Gbps NIC driver handles these interrupts. For each interrupt, the 200Gbps NIC driver reports error events and resets all flags.

Error events are sent to multiple locations:

* The kernel console
* Kernel trace events (as used by rasdaemon)
* Netlink sockets
* Error events are rate-limited to avoid overwhelming the
  console. The driver will mask an error interrupt bit if its rate
  becomes too high.

An example of an error reported to the kernel console is shown below.

```screen
# dmesg -T |grep cxi
...
[Fri Feb 19 16:04:20 2021] cxi_core 0000:21:00.0: EE error: eq_rsrvn_uflw (38)
[Fri Feb 19 16:04:20 2021] cxi_core 0000:21:00.0:   C_EE_ERR_INFO_RSRVN_UFLW 1000000001430100
[Fri Feb 19 16:04:20 2021] cxi_core 0000:21:00.0:   eq_rsrvn_uflw_err_cntr: 12
...
```

# PCIe interface troubleshooting

200Gbps NIC supports a PCIe Gen4 x16 interface. The standard Linux lspci command
can be used to validate that the device has tuned to its full speed:

```screen
# lspci -vvvs `ethtool -i hsn0 | grep bus-info | cut -f2 -d' '` | grep LnkSta:
        LnkSta: Speed 16GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
```

PCIe AER driver must be enabled in the host OS. If this driver is enabled, the PCIe errors will be
reported to the kernel console. You can aggregate these errors using syslog or
rasdaemon.

# Ethernet interface troubleshooting

This section describes how to monitor the health of the 200Gbps NIC Ethernet
Interface. Standard tools are used to monitor the Ethernet interface health.

## ip

The 'ip' is a standard Linux tool to monitor the state of a Linux network device.
Use this tool to view the state of the 200Gbps NIC Ethernet interface as
follows:

```screen
# ip l show hsn0
3: hsn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 02:00:00:00:00:f3 brd ff:ff:ff:ff:ff:ff
```

This command shows several pieces of important information:

* `LOWER_UP` - This flag shows the state of the L1 link. Note that
    this is relevant to the RDMA interface as well.
* `UP` - This flag shows the administrative state of the Ethernet L2 interface.
* `state UNKNOWN` - The operational state of the interface. UNKNOWN
    and UP are valid running states for the L2 Ethernet interface.
* `02:00:00:00:00:f3` - Algorithmic MAC address. The prefix '0x02'
    indicates a locally administered unicast address. This is one
    signature of a managed AMA.

## ping

Use the standard Linux `ping` command to test basic Ethernet L2 function between a pair of 200Gbps NICs.

# RDMA interface troubleshooting

This section describes how to monitor the health of the 200Gbps NIC RDMA interface.

## Libcxi utilities

The libcxi utility package contains a set of diagnostic tools that has been developed
for troubleshooting 200Gbps NIC RMDA issues without using libfabric. These include a
tool to display device information and status, a number of bandwidth and latency
benchmarks, and a thermal diagnostic. For more information, refer the CXI Diagnostics and Utilities Guide.

## Libfabric utilities

The following subsections address the utilities provided with libfabric package to
troubleshoot libfabric over 200Gbps NIC RDMA issues.

* `fi_info`
* `fi_pingpong`

**fi_info:**

The `fi_info` utility is provided in the libfabric package. This tool queries
available libfabric interfaces. The following output shows a node with one
200Gbps NIC (CXI) interface available:

```screen
# fi_info -p cxi
provider: cxi
    fabric: cxi
    domain: cxi0
    version: 0.0
    type: FI_EP_RDM
    protocol: FI_PROTO_CXI
# fi_info -p cxi -d cxi0 -v |grep state
            state: FI_LINK_UP
```

The availability of a CXI interface indicates several key signs of health. An
interface is not made available unless it meets the following criteria:

* The interface retry handler is running
* A matching L2 interface is available
* The L1 interface has a temporary, locally administered, unicast address
    assigned to it. This is presumed to be an AMA applied by the fabric manager.
* The L1 link state is reported if verbosity is enabled. L1 link state reported 
    by `fi_info` will match the state reported by the L2 device via the ip tool.

All these checks together make `fi_inf0` an excellent first tool to use to check
the general health of 200Gbps NIC RDMA interfaces.

**fi_pingpong:**

The `fi_pingpong` utility is also provided with libfabric. This is a
basic client-server RDMA test. This is a quick and easy tool to use to validate
end-to-end RDMA functionality.

```screen
// start server:
# fi_pingpong -I 10000 -e rdm -m tagged -p cxi -d cxi1
bytes   #sent   #ack     total       time     MB/sec    usec/xfer   Mxfers/sec
64      10k     =10k     1.2m        0.10s     12.89       4.97       0.20
256     10k     =10k     4.8m        0.08s     60.71       4.22       0.24
1k      10k     =10k     19m         0.09s    233.95       4.38       0.23
4k      10k     =10k     78m         0.09s    881.85       4.64       0.22
64k     10k     =10k     1.2g        0.19s   7067.63       9.27       0.11
1m      10k     =10k     19g         0.99s  21234.98      49.38       0.02
// start client:
#  fi_pingpong -I 10000 -e rdm -m tagged -p cxi -d cxi0 172.29.68.180
bytes   #sent   #ack     total       time     MB/sec    usec/xfer   Mxfers/sec
64      10k     =10k     1.2m        0.10s     12.90       4.96       0.20
256     10k     =10k     4.8m        0.08s     60.83       4.21       0.24
1k      10k     =10k     19m         0.09s    234.34       4.37       0.23
4k      10k     =10k     78m         0.09s    883.30       4.64       0.22
64k     10k     =10k     1.2g        0.19s   7074.11       9.26       0.11
1m      10k     =10k     19g         0.99s  21236.47      49.38       0.02
```

This tool can use any IP interface for bootstrapping the RDMA communication.
The ping-pong communication pattern does not achieve the best bandwidth
results, however, the 1M transfer size should achieve high enough bandwidth to
make the link operate at the expected 200Gbps speed.

This tool can be used between any two endpoints on a fabric or looped back to
the same device.
