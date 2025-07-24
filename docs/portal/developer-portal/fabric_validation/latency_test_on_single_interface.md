# Latency test on single interface

This example illustrates how to check performance between a compute node (interface hsn0) and a gateway node (interface hsn0).

Use `cxi_read_lat` or `cxi_write_lat` to test the fabric connectivity and latency between a compute node and a gateway node.

1. Initiate `cxi_read_bw` in the gateway node on the interface that is tested.

    ```screen
    # cxi_read_lat -d cxi0 &
    [1] 56989
    ```

2. Initiate `cxi_read_lat` from the compute node as a client and server as the gateway node.

    ```screen
    # cxi_read_lat -d cxi0 elbert-gateway-0097
    ------------------------------------------------------------------------
        CXI RDMA Read Latency Test
    Device           : cxi0
    Service ID       : 1
    Client TX Mem    : System
    Server RX Mem    : System
    Test Type        : Iteration
    Iterations       : 100
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
            8         100        6.05        7.66        6.95        0.30
    ------------------------------------------------------------------------
    ```

    This test produces latency ~7μs as expected. Latency in this case is a function of host to NIC handoff latency, switch latency (client side switch), global link latency (connecting a client group with Gateway group), switch latency (gateway node), and gateway node hand off latency.
    In the case of non-minimal path when a packet has to traverse additional groups before it reaches destination that would include the latency incurred due to the hop in the intermediary group.
    Failure of test or more than expected latency. See the _HPE Slingshot Host Software Troubleshooting Guide_ and _HPE Cray Cassini Performance Counters User Guide_ for further diagnosis.
