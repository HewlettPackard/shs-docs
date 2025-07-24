# Bandwidth check of all interfaces (sequential)

The following procedure uses `cxi_read_bw` to test all the interfaces on compute with all the interfaces on a gateway node.
The test executes sequentially testing each interface on the compute with an interface on the gateway node.

1. Run the test script [`cxi_server.sh`](./scripts.md#scripts) on the gateway node. The gateway node acts as server in this test. This script initiates a server as a background process to listen on an individual TCP port for each device (`cxi0` and `cxi1`).

    The following is the output from launching the server script.
    It also illustrates a server listening on eight unique ports for both `cxi0` and `cxi1` to match the client connections from eight different interfaces.

    ```screen
    # ./cxi_server.sh
    Intiating server for device cxi0 on port 49194
    Intiating server for device cxi0 on port 49195
    Intiating server for device cxi0 on port 49196
    Intiating server for device cxi0 on port 49197
    Intiating server for device cxi0 on port 49198
    Intiating server for device cxi0 on port 49199
    Intiating server for device cxi0 on port 49200
    Intiating server for device cxi0 on port 49201
    Intiating server for device cxi1 on port 49202
    Intiating server for device cxi1 on port 49203
    Intiating server for device cxi1 on port 49204
    Intiating server for device cxi1 on port 49205
    Intiating server for device cxi1 on port 49206
    Intiating server for device cxi1 on port 49207
    Intiating server for device cxi1 on port 49208
    Intiating server for device cxi1 on port 49209
    
    # ps -ef | grep cxi_read_bw
    root      71732      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49194 -D 10
    root      71733      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49195 -D 10
    root      71734      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49196 -D 10
    root      71735      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49197 -D 10
    root      71736      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49198 -D 10
    root      71737      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49199 -D 10
    root      71738      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49200 -D 10
    root      71739      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49201 -D 10
    root      71740      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49202 -D 10
    root      71741      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49203 -D 10
    root      71742      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49204 -D 10
    root      71743      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49205 -D 10
    root      71744      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49206 -D 10
    root      71745      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49207 -D 10
    root      71746      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49208 -D 10
    root      71747      1  0 13:20 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49209 -D 10
    root      71749  62170  0 13:20 pts/0    00:00:00 grep --color=auto cxi_read_bw
    ```

2. Launch the `client-side` script on the compute. Each interface in compute node is tested with `cxi0` and `cxi1` on the gateway node. The script iterates sequentially on the all interfaces on compute node to test with `cxi0` and then with `cxi1` interface on the gateway node. Each test runs for 10 seconds and reports a bandwidth of approximately 20GB/s as expected.

    ```screen
    x4714c2s2b0n0:/tmp # ./cxi_client.sh elbert-gateway-0097
    Testing cxi0 with Gateway node elbert-gateway-0097 interface cxi0
    ---------------------------------------------------
        CXI RDMA Read Bandwidth Test
    Device           : cxi0
    Service ID       : 1
    Client TX Mem    : System
    Server RX Mem    : System
    Test Type        : Duration
    Duration         : 10 seconds
    Read Size        : 65536
    List Size        : 256
    Restricted       : Enabled
    Bidirectional    : Disabled
    Max RDMA Buf     : 4294967296 (16777216 used)
    RDMA Buf Align   : 64
    Hugepages        : Disabled
    Local (client)   : NIC 0x542b1 PID 0 VNI 1
    Remote (server)  : NIC 0x7ea PID 1
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
        65536     3144192  20604.61        10.060846
    ---------------------------------------------------
    Testing cxi1 with Gateway node elbert-gateway-0097 interface cxi0
    ---------------------------------------------------
        CXI RDMA Read Bandwidth Test
    Device           : cxi1
    Service ID       : 1
    Client TX Mem    : System
    Server RX Mem    : System
    Test Type        : Duration
    Duration         : 10 seconds
    Read Size        : 65536
    List Size        : 256
    Restricted       : Enabled
    Bidirectional    : Disabled
    Max RDMA Buf     : 4294967296 (16777216 used)
    RDMA Buf Align   : 64
    Hugepages        : Disabled
    Local (client)   : NIC 0x542b0 PID 0 VNI 1
    Remote (server)  : NIC 0x7ea PID 7
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
        65536     3095808  20287.19         9.905854
    ---------------------------------------------------

    ... [output omitted] ...

    ---------------------------------------------------
    Testing cxi7 with Gateway node elbert-gateway-0097 interface cxi1
    ---------------------------------------------------
        CXI RDMA Read Bandwidth Test
    Device           : cxi7
    Service ID       : 1
    Client TX Mem    : System
    Server RX Mem    : System
    Test Type        : Duration
    Duration         : 10 seconds
    Read Size        : 65536
    List Size        : 256
    Restricted       : Enabled
    Bidirectional    : Disabled
    Max RDMA Buf     : 4294967296 (16777216 used)
    RDMA Buf Align   : 64
    Hugepages        : Disabled
    Local (client)   : NIC 0x54231 PID 0 VNI 1
    Remote (server)  : NIC 0x7ab PID 6
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
        65536     3140352  20580.00        10.048826
    ---------------------------------------------------
    ```
