# Bandwidth check of single interface

This example illustrates how to check performance between compute node (interface hsn0) and gateway node (interface hsn0).

Use `cxi_read_bw` or `cxi_write_bw` to test the fabric connectivity and performance between compute node and gateway node.

1. Initiate `cxi_read_bw` in the gateway node on the interface that is tested.

    ```screen
    # cxi_read_bw -d cxi0 &
    [1] 56989
    ```

2. Initiate `cxi_read_bw` from the compute node as a client and server as the gateway node.

    ```screen
    nidXXXXX# cxi_read_bw -d cxi0 elbert-gateway-0097
    ---------------------------------------------------
        CXI RDMA Read Bandwidth Test
    Device           : cxi0
    Service ID       : 1
    Client TX Mem    : System
    Server RX Mem    : System
    Test Type        : Iteration
    Iterations       : 1000
    Read Size        : 65536
    List Size        : 256
    Restricted       : Enabled
    Bidirectional    : Disabled
    Max RDMA Buf     : 4294967296 (16777216 used)
    RDMA Buf Align   : 64
    Hugepages        : Disabled
    Local (client)   : NIC 0x542b1 PID 0 VNI 1
    Remote (server)  : NIC 0x7ea PID 0
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
        65536      256000  20561.27        10.039683
    ---------------------------------------------------
    ```

    The test has passed successfully with 20561 MB/s.

