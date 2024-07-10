# Analyzing Congestion and HSN Fabric with STT (Slingshot Topology Tool)

These STT commands can be used to get a top-down view of the fabric and to understand the performance issues due to underlying Fabric issues.

`show switches` 

: This provides a high level view from the switches and any drops and discards that are happening at the switch level (aggregated from the ports of the switches)

`show switch error_flags`

: This command provides any errors that are encountered by the switch

`show links health`

: This command analyses the downed links and suggests a diagnostic action code based on information fetched from switches and edge nodes.

`show FabricTelemetry`

: Provides Cray Fabric Telemetry counters which can be used to look at edge port status and issues due to edge connectivity.

`show hsn_traffic ping-all-to-all`

: Performs all-to-all ping test between all the configured HSN interfaces of all HSN nodes as per p2p file or user provided comma separated HSN nodes. By default, only non-reachable nodes are listed. To get list of both reachable and non-reachable nodes, use 'detailed' option at end of command.

`show hsn_traffic roce_perf_check_loopback`

: Performs RoCE (RDMA over Converged Ethernet) bandwidth and latency benchmark tests using `perftest` package on Mellanox5 devices at compute nodes port level. The bandwidth and latency tests operate on a single port and not cross-fabric routes. The test validates underlying software and hardware components between compute node port and Slingshot switch. This has been integrated to  'ib_read_bw', 'ib_read_lat', 'ib_write_bw' and 'ib_write_lat' benchmarks.

`show switch perfcounters`

: This will list all the performance counters at the switch and port level. The counters *DISCARD* can be used to look for high discards that can be indicative of the congestion in the network.

`show switch counters`

: This command provides the different counters at the switch level which can be correlated with the performance benchmarking tests.

```screen
(STT) show switches

Working with 'default' topology and 'default' filter profile.
Collecting data using 'check-switches' script.
Collecting data using 'dgrerrstat' script.


check-switches  :  Start time: 04/29/2021, 04:22:27 , End time: 04/29/2021, 04:22:32
dgrperfcheck  :  Start time: 04/29/2021, 04:22:27 , End time: 04/29/2021, 04:22:32
dgrerrstat  :  Start time: 04/29/2021, 04:22:27 , End time: 04/29/2021, 04:22:33
+------------+----------+------+------+-------+---------+--------+----------+------+-----------+--------+--------+-------+--------+
|   xname    |   type   | snum | gnum | edge_ | fabric_ | uptime | up_ports | flap | checkidle | pktIn  | pktOut | drops | dscrds |
|            |          |      |      | count | count   |        |          |      |           |        |        |       |        |
+------------+----------+------+------+-------+---------+--------+----------+------+-----------+--------+--------+-------+--------+
| x3000c0r41 | Columbia |  0   |  0   |  32   |   12    | 1 day  |  35/64   |  0   |    idle   | 103244 | 105776 |   0   |  109   |
| x3000c0r42 | Columbia |  1   |  0   |  32   |   12    | 1 day  |  37/64   |  3   |    idle   | 108564 | 111253 |   0   |  109   |
| x3001c0r41 | Columbia |  0   |  1   |  32   |   12    | 1 day  |  42/64   |  0   |    idle   | 132428 | 135698 |   0   |  109   |
| x3001c0r42 | Columbia |  1   |  1   |  32   |   12    | 1 day  |  42/64   |  1   |    idle   | 136694 | 139855 |   0   |  113   |
+------------+----------+------+------+-------+---------+--------+----------+------+-----------+--------+--------+-------+--------+


```

## Summary of counters that are part of the "dscrds"

**Ethernet Ingress Queues**

`EIQ_SOP_FULL`

: This counter indicates the total number of IBUF Full indicators received. The headers for these will be discarded by the EIQ

**Input Buffer (IBUF)**

`IBUF_SM_PORTALS_FCS_ERR`

: This counter indicates the total number of Fabric Format single flit (Small Portals or High Rate Puts) received and discarded due to an FCS-16 Error

`IBUF_IBUF_FULL`

: This counter indicates the total number of packets discarded at input due to the IBUF being full (full response to EIQ)

`IBUF_FAB_HCRC`

: This counter indicates the total number of Fabric Format multi-flit packets received and discarded due to an HCRC-16 error

`IBUF_EIQ_FULL`

: This counter indicates the total number of packets discarded at input due to the EIQ being full

`IBUF_REMLB_FULL`

: This counter indicates the total number of remote loop back packets discarded at input (when configured as lossy) - due to the IBUF being full

**Input Flow Channel Table (IFCT)**

`IFCT_EMPTY_ROUTE`

: Count of frames that were discarded because the FRF returned an empty route

`IFCT_FC_DQ_DISCARD`

: Count of frames that were discarded when the discard flag was set in the header. This could be an instruction from the Ethernet lookup (ACL function or unrecognized header), a broken frame (bad size, broken FCS, uncorrectable ECC, Etc), EIQ was full, the IBUF was full, or receiving a frame with an FTag that is currently being reconfigured in its distribution of APPG queues

`IFCT_NO_FLOW_MCAST_ERROR`

: Count of multicast frames that were discarded because they had not been allocated a flow channel. Frames using multicast addressing but only selecting a single output port (E.g. reduction frames) will not be discarded or increment this count.

`IFCT_ALWAYS_DISCARD`

: Count of frames that were discarded because the ALWAYS_DISCARD flag has been set in the FTag configuration CSR.

**Fabric Routing Function (FRF)**

`FRF_EMPTY_ROUTE_UF_CNTR`

: This is an error counter that counts the number of unicast and sw_port frames that were dropped because they were unexpected.

`FRF_EMPTY_ROUTE_EDGE_CNTR`

: This is an error counter that counts the number of unicast frames that were dropped because they were being routed to an edge port that was non-operational

`FRF_MCAST_DROP_NON_OP_CNTR`

: This is an error counter that counts the number of multicast frames that were not routed to all of the non-edge ports that they were configured to be routed to because one or more non-edge ports were non-operational.

`FRF_MCAST_DROP_EDGE_CNTR`

: This is an error counter that counts the number of multicast frames that were not routed to all of the edge ports that they were configured to be routed to because one or more edge ports were non-operational.

`FRF_MCAST_EMPTY_ROUTE_CNTR`

: This is an error counter that counts the number of multicast frames that were dropped because there were no ports that the frame was able to be routed to. This counter is not incremented for frames that cause any of the other MCAST_EMPTY_ROUTE_ counters to increment

`FRF_MCAST_DROP_VCE_CNTR`

: This is an error counter that counts the number of multicast frames that were not routed to all of the ports that they were configured to be routed to because the frame’s VC would have exceed the maximum allowed VC value one or more ports

`FRF_MCAST_EMPTY_ROUTE_UMID_CNTR`

: This is an error counter that counts the number of multicast frames that were dropped because the multicast_id in their DFA was an unexpected value.

`FRF_MCAST_EMPTY_ROUTE_VCE_CNTR`

: This is an error counter that counts the number of multicast frames that were dropped because the frame’s VC would have exceeded the maximum allowed VC value on all ports the frame was configured to be routed to.

`FRF_MCAST_EMPTY_ROUTE_EDGE_CNTR`

: This is an error counter that counts the number of multicast frames that were dropped because all of the ports that the frame was configured to be routed to were non-operational edge ports

`FRF_MCAST_EMPTY_ROUTE_CNTR`

: This is an error counter that counts the number of multicast frames that were dropped because there were no ports that the frame was able to be routed to. This counter is not incremented for frames that cause any of the other MCAST_EMPTY_ROUTE_ counters to increment.

`FRF_MCAST_FRAMES_FILTERED_CNTR`

: This is a count of the number of multicast frames dropped due to the multicast filter function

**Age Queue (AGEQ)**

`AGEQ_TO_DISCARD_ERR`

: This counter indicates the number of times a TO_DISCARD_ERR has occurred

`AGEQ_HWM_DISCARD_ERR`

: This counter indicates the number of times a HWM_DISCARD_ERR has occurred

`AGEQ_SIZE_DISCARD_ERR`

: This counter indicates the number of times a SIZE_DISCARD_ERR has occurred

**Output Buffer**

`TF_OBUF_DROP_FRM`

: The counter indicates the number of frames dropped from the Elastic FIFO due to a bad header.

**REDUCTION ENGINE**

`TF_RED_ARM_SEQ_ACTIVE`

: This counter indicates the number or reduction arm frames dropped because of the sequence number was already active

`TF_RED_ARM_NO_DESC`

: This counter indicates the number of reduction arm frames dropped because no descriptors were available

`TF_RED_DATA_DROP`

: This counter indicates the number of reduction data frames dropped because of an error (mismatch, frame format error, or descriptor just allocated

`PF_MAC_RX_ILLEGAL_SIZE`

: This counter indicates that a frame with an illegal size has been received and filtered

`PF_LLR_TX_DISCARD`

: This counter indicates the number of frames that have been discarded by the TX LLR

`PF_RX_OK_FILTER_INGRESS`

: This counter indicates the number of frames received that were filtered by the VLAN state rules and with a good FCS

`PF_RX_OK_FILTERED`

: This counter indicates the number of frames received that were filtered and with a good FCS

## Procedure for troubleshooting issues during performance benchmarking

STT can be used to perform analysis by capturing key metrics before and after performance benchmarking tests and by analyzing the data at switch level and port level admin can get more insights to any possible congestion or discards that can impact the performance

**Increasing SSH timeout value in STT**

On bigger systems, in order to avoid SSH connection timeouts while connecting to the switches/CNs through STT, timeout value can be increased
using the option `--ssh_conn_timeout` while launching the tool.

```screen
# slingshot-topology-tool --ssh_conn_timeout 60
Using Fabric Manager URL http://localhost:8000
STT diags log directory -  /root/abhilash/stt_diags_logs
STT diags log directory -  /root/abhilash/stt_diags_logs/default
Loading  point2point file /opt/cray/etc/sct/Shasta_system_hsn_pt_pt.csv to default topology
Loading fabric template file /opt/cray/fabric_template.json to default topology
Welcome to the Slingshot Topology Tool v1.2.1-5.
     General Usage is <command> <arguments>
     Type help or ? to list commands.

(STT)
```

**Example of Analysis switch discards during tests**

Steps:

1. Capture show switches output before tests (show-switches.t0)
2. Run the tests
3. Capture show switches output after tests  (show-switches.t1)

    ```screen
    fm-1# cat show-switches-stats.t0

    Using Fabric Manager URL http://localhost:8000
    STT diags log directory -  /root/stt_diags_logs
    STT diags log directory -  /root/stt_diags_logs/default
    Loading  point2point file /opt/cray/etc/sct/Shasta_system_hsn_pt_pt.csv to default topology
    Loading fabric template file /opt/cray/fabric_template.json to default topology

    Working with 'default' topology and 'default' filter profile.
    Collecting data using 'check-switches' script.
    Warning: login credentials for compute nodes is not set in STT.
    Use 'compute_nodes_creds' command to input compute node login credentials.

    Trying to access compute nodes without password using SSH.

    Collecting data using 'dgrerrstat' script.
    Collecting data using 'dgrperfcheck' script.
    dgrerrstat  :  Start time: 04/28/2021, 21:43:35 , End time: 04/28/2021, 21:45:46
    dgrperfcheck  :  Start time: 04/28/2021, 21:43:35 , End time: 04/28/2021, 21:45:49
    check-switches  :  Start time: 04/28/2021, 21:43:35 , End time: 04/28/2021, 21:47:38

    check-switches  :  Start time: 04/28/2021, 21:43:35 , End time: 04/28/2021, 21:47:38
    +------------+----------+------+------+------------+--------------+--------+----------+------+-----------+------+-----------+
    |   xname    |   type   | snum | gnum | edge_count | fabric_count | uptime | up_ports | flap | checkidle | drops|   dscrds  |
    +------------+----------+------+------+------------+--------------+--------+----------+------+-----------+------+-----------+
    | x1001c6r3  | Colorado |  9   |  5   |     16     |      40      | 3 days |  56/64   |  0   |     15    |  0   |     690   |
    | x1001c6r7  | Colorado |  6   |  5   |     16     |      40      | 3 days |  56/64   |  0   |    idle   |  0   |      54   |
    | x1001c7r3  | Colorado |  7   |  5   |     16     |      40      | 3 days |  56/64   |  3   |    idle   |  0   | 499553073 |
    | x1001c7r7  | Colorado |  8   |  5   |     16     |      40      | 3 days |  56/64   |  0   |    idle   |  0   |     578   |
    | x1002c0r3  | Colorado |  0   |  6   |     16     |      42      | 3 days |  57/64   |  13  |    idle   |  0   |15803474151|
    | x1004c7r7  | Colorado |  15  |  8   |     16     |      40      | 3 days |  54/64   |  7   |    idle   |  0   |  100556   |
    | x1005c0r3  | Colorado |  0   |  9   |     16     |      42      | 3 days |  58/64   |  6   |    idle   |  0   |2753519569 |
    | x1106c1r7  | Colorado |  1   |  12  |     16     |      42      | 3 days |  58/64   |  2   |    idle   |  0   |827622573  |

    * The output has been truncated for readability.

    fm-1# cat show-switches-stats.t1
    Using Fabric Manager URL http://localhost:8000
    STT diags log directory -  /root/stt_diags_logs
    STT diags log directory -  /root/stt_diags_logs/default
    Loading  point2point file /opt/cray/etc/sct/Shasta_system_hsn_pt_pt.csv to default topology
    Loading fabric template file /opt/cray/fabric_template.json to default topology

    Working with 'default' topology and 'default' filter profile.
    Collecting data using 'check-switches' script.
    Collecting data using 'dgrerrstat' script.
    Warning: login credentials for compute nodes is not set in STT.
    Use 'compute_nodes_creds' command to input compute node login credentials.
    Trying to access compute nodes without password using SSH.

    Collecting data using 'dgrperfcheck' script.
    dgrerrstat  :  Start time: 04/28/2021, 22:08:01 , End time: 04/28/2021, 22:10:07
    dgrperfcheck  :  Start time: 04/28/2021, 22:08:01 , End time: 04/28/2021, 22:10:13
    check-switches  :  Start time: 04/28/2021, 22:08:01 , End time: 04/28/2021, 22:11:55
    +------------+----------+------+------+------------+--------------+--------+----------+------+-----------+-------+------------+
    |   xname    |   type   | snum | gnum | edge_count | fabric_count | uptime | up_ports | flap | checkidle | drops |    dscrds  |
    +------------+----------+------+------+------------+--------------+--------+----------+------+-----------+-------+------------+
    | x1001c6r3  | Colorado |  9   |  5   |     16     |      40      | 3 days |  56/64   |  0   |    idle   |    0  |     690    |
    | x1001c6r7  | Colorado |  6   |  5   |     16     |      40      | 3 days |  56/64   |  0   |    idle   |    0  |      54    |
    | x1001c7r3  | Colorado |  7   |  5   |     16     |      40      | 3 days |  56/64   |  3   |    idle   |    0  |  499553073 |
    | x1001c7r7  | Colorado |  8   |  5   |     16     |      40      | 3 days |  56/64   |  0   |    idle   |    0  |     578    |
    | x1002c0r3  | Colorado |  0   |  6   |     16     |      42      | 3 days |  57/64   |  13  |    idle   |    0  | 15803484812|
    | x1004c7r7  | Colorado |  15  |  8   |     16     |      40      | 3 days |  54/64   |  7   |    idle   |    0  |    111103  |
    | x1005c0r3  | Colorado |  0   |  9   |     16     |      42      | 3 days |  58/64   |  6   |    idle   |    0  |  2753519569|
    | x1106c1r7  | Colorado |  1   |  12  |     16     |      42      | 3 days |  58/64   |  2   |    idle   |    0  |  827622573 |

    * The output has been truncated for readability.
    ```

    Extracting the discards statistics during the test

    ```screen
    cat extract_delta.sh
    #!/bin/bash
    cut -c 2-12,107-121,123-137,147-159 show-switches.t1 | sed -e '1,/xname/d' -e '/----/d' -e '/^$/d' > show-switches-stats.t1
    cut -c 2-12,107-121,123-137,147-159 show-switches.t0 | sed -e '1,/xname/d' -e '/----/d' -e '/^$/d' > show-switches-stats.t0
    paste -d " " show-switches-keystats.t0  show-switches-keystats.t1 | awk '{printf("switch: %s \t pktIn-delta: %15d \t pktOut-delta
    :%15d \t discard-delta: %10d\n", $1,$6-$2,$7-$3,$8-$4);}' > show-switches-delta.out


    cat show-switches-delta.out

    switch: x1001c6r3        pktIn-delta:      4735674258    pktOut-delta :     5840396114   discard-delta:          0
    switch: x1001c6r7        pktIn-delta:      4323519024    pktOut-delta :     5401150852   discard-delta:          0
    switch: x1001c7r3        pktIn-delta:      4099825822    pktOut-delta :     5175589015   discard-delta:          0
    switch: x1001c7r7        pktIn-delta:      5108939403    pktOut-delta :     6094940095   discard-delta:          0
    switch: x1002c0r3        pktIn-delta:      4747875064    pktOut-delta :     6128040326   discard-delta:      10661
    switch: x1004c7r7        pktIn-delta:      3440660222    pktOut-delta :     4488635246   discard-delta:      10547
    switch: x1005c0r3        pktIn-delta:      3497074059    pktOut-delta :     4495759639   discard-delta:          0
    switch: x1106c1r7        pktIn-delta:      4319988979    pktOut-delta :     4792555067   discard-delta:          0

    ```

In the above example switch x1002c0r3, x1004c7r7 have discarded packets during the tests. This requires further analysis on the switches and to look for the port level counters and look for congestion and discards at individual port level.

`**Steps to Analyze Congestion at port level**`

1. Collect Counters before test
2. Perform test
3. Collect Counters after test

```screen
STT> show switch perfcounters >> switch_perf_counters_before_test

fm-1#  grep DISCARD switch_perf_counters_before_test

fm-1#  grep DROP switch_perf_counters_before_test
```
