# Latency test on all interfaces (sequential)

This example illustrates how to check latency between the compute node (interface hsn0) and the gateway node (interface hsn0).

1. Launch the test script [`cxi_server_latency.sh`](./scripts.md#scripts) on the gateway node. This script initiates a server as a background process to listen on an individual TCP port for each device (cxi0 and cxi7).

   The following is the output from launching the server script and it also illustrates a server listening on eight unique ports for both cxi 0 and cxi1 to match the client connections from eight different interfaces.

    ```screen
    # ./cxi_server_latency.sh 
    # ps -ef | grep cxi
    root       3902      2  0  2023 ?        00:00:00 [cxi_cntrs_timer]
    root       3946      2  0  2023 ?        00:00:00 [cxi_cntrs_refre]
    root       4744      2  0  2023 ?        00:00:00 [cxi_cntrs_refre]
    root       5129      2  0  2023 ?        00:00:00 [kcxi_wq]
    root       5134      1  0  2023 ?        00:00:10 /usr/bin/cxi_rh --device=cxi0
    root       5135      1  0  2023 ?        00:00:09 /usr/bin/cxi_rh --device=cxi1
    root      59770      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi0 -p 49194 -D 10
    root      59771      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi0 -p 49195 -D 10
    root      59772      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi0 -p 49196 -D 10
    root      59773      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi0 -p 49197 -D 10
    root      59774      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi0 -p 49198 -D 10
    root      59775      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi0 -p 49199 -D 10
    root      59776      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi0 -p 49200 -D 10
    root      59777      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi1 -p 49201 -D 10
    root      59778      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi1 -p 49202 -D 10
    root      59779      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi1 -p 49203 -D 10
    root      59780      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi1 -p 49204 -D 10
    root      59781      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi1 -p 49205 -D 10
    root      59782      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi1 -p 49206 -D 10
    root      59783      1  0 17:40 pts/1    00:00:00 cxi_read_lat -d cxi1 -p 49207 -D 10
    root      59785  53804  0 17:40 pts/1    00:00:00 grep --color=auto cxi
    ```

2. Launch the [`cxi_client_latency_sequential.sh`](./scripts.md#scripts) client-side script on the compute. Each interface in compute node is tested with cxi0 and cxi1 on the gateway node. The script iterates sequentially on all interfaces on compute node to test with cxi0 and then with cxi1 interface on the gateway node.

    Each test runs for ten seconds and reports latency of approximately seven microseconds as expected.

    ```screen
    nidXXXXX# ./cxi_client_latency_sequential.sh elbert-gateway-0097
    Testing cxi0 with Gateway node elbert-gateway-0097 interface cxi0
    ------------------------------------------------------------------------
        CXI RDMA Read Latency Test
    Device           : cxi0
    Service ID       : 1
    Client TX Mem    : System
    Server RX Mem    : System
    Test Type        : Duration
    Duration         : 10 seconds
    Warmup Iters     : 10
    Inter-Iter Gap   : 1000 microseconds
    Read Size        : 8
    Restricted       : Enabled
    LL Cmd Launch    : Enabled
    Results Reported : Summary
    Hugepages        : Disabled
    Local (client)   : NIC 0x542b1 PID 0 VNI 1
    Remote (server)  : NIC 0x7ea PID 0
    ------------------------------------------------------------------------
    RDMA Size[B]       Reads     Min[us]     Max[us]    Mean[us]  StdDev[us]
            8      784556        5.65       23.93        6.99        0.50
    ------------------------------------------------------------------------
    
    ... [output omitted] ...

    ------------------------------------------------------------------------
    Testing cxi7 with Gateway node elbert-gateway-0097 interface cxi1
    ------------------------------------------------------------------------
        CXI RDMA Read Latency Test
    Device           : cxi7
    Service ID       : 1
    Client TX Mem    : System
    Server RX Mem    : System
    Test Type        : Duration
    Duration         : 10 seconds
    Warmup Iters     : 10
    Inter-Iter Gap   : 1000 microseconds
    Read Size        : 8
    Restricted       : Enabled
    LL Cmd Launch    : Enabled
    Results Reported : Summary
    Hugepages        : Disabled
    Local (client)   : NIC 0x54231 PID 0 VNI 1
    Remote (server)  : NIC 0x7ab PID 7
    ------------------------------------------------------------------------
    RDMA Size[B]       Reads     Min[us]     Max[us]    Mean[us]  StdDev[us]
            8      803513        5.33       18.25        6.71        0.25
    ------------------------------------------------------------------------
    ```

