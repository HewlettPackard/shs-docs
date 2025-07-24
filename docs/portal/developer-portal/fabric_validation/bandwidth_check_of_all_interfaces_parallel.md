# Bandwidth check of all interfaces (parallel)

This example illustrates how to use the [`cxi_client`](./scripts.md#scripts) and [`cxi_server`](./scripts.md#scripts) to test all the interfaces on the compute node simultaneously with all the interfaces on the gateway node.
The server-side script is the same as the previous example (sequential).
However, the client-side script initiates all the tests in a background process to run all the tests in parallel.

1. Run the test script [`cxi_server.sh`](./scripts.md#scripts) on the gateway node. The gateway node acts as server in this test. This script initiates a server as a background process to listen on an individual TCP port for each device (`cxi0` and `cxi7`).

    The following is the output from launching the server script and it also illustrates a server listening on eight unique ports for both `cxi0` and `cxi1` to match the client connections from eight different interfaces.

    ```screen
    # ./cxi_server.sh
    Initiating server for device cxi0 on port 49194
    Initiating server for device cxi0 on port 49195
    Initiating server for device cxi0 on port 49196
    Initiating server for device cxi0 on port 49197
    Initiating server for device cxi0 on port 49198
    Initiating server for device cxi0 on port 49199
    Initiating server for device cxi0 on port 49200
    Initiating server for device cxi0 on port 49201
    Initiating server for device cxi1 on port 49202
    Initiating server for device cxi1 on port 49203
    Initiating server for device cxi1 on port 49204
    Initiating server for device cxi1 on port 49205
    Initiating server for device cxi1 on port 49206
    Initiating server for device cxi1 on port 49207
    Initiating server for device cxi1 on port 49208
    Initiating server for device cxi1 on port 49209
    # ps -ef | grep cxi_read_bw
    root      82305      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49194 -D 10
    root      82306      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49195 -D 10
    root      82307      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49196 -D 10
    root      82308      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49197 -D 10
    root      82309      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49198 -D 10
    root      82310      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49199 -D 10
    root      82311      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49200 -D 10
    root      82312      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi0 -p 49201 -D 10
    root      82313      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49202 -D 10
    root      82314      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49203 -D 10
    root      82315      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49204 -D 10
    root      82316      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49205 -D 10
    root      82317      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49206 -D 10
    root      82318      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49207 -D 10
    root      82319      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49208 -D 10
    root      82320      1  0 13:49 pts/0    00:00:00 cxi_read_bw -d cxi1 -p 49209 -D 10
    root      82322  62170  0 13:49 pts/0    00:00:00 grep --color=auto cxi_read_bw
    ```

2. Launch the `client-side` script on the compute node. Each interface in the compute node is tested with `cxi0` and `cxi1` on the gateway node.
   The script runs tests in parallel on all interfaces on the compute node to test with `cxi0` and then with `cxi1` interface on the gateway node. Each test runs for 10 seconds and reports bandwidth of approximately 2600MB/s per test.
   For all the eight interfaces with a single interface on the gateway node, this is approximately 20GB/s as expected.

    If the test fails or reports less than the approximately 20GB/s aggregated performance, it requires further diagnosis on the issue to identify the set of links falling below the threshold.
    For further troubleshooting on fabric events that could impact performance, see the _HPE Slingshot Host Software Troubleshooting Guide_.

    ```screen
    nidXXXXX# ./cxi_client_parallel.sh elbert-gateway-0097
    Testing cxi0 with Gateway node elbert-gateway-0097 interface cxi0
    Testing cxi1 with Gateway node elbert-gateway-0097 interface cxi0
    Testing cxi2 with Gateway node elbert-gateway-0097 interface cxi0
    Testing cxi3 with Gateway node elbert-gateway-0097 interface cxi0
    Testing cxi4 with Gateway node elbert-gateway-0097 interface cxi0
    Testing cxi5 with Gateway node elbert-gateway-0097 interface cxi0
    Testing cxi6 with Gateway node elbert-gateway-0097 interface cxi0
    Testing cxi7 with Gateway node elbert-gateway-0097 interface cxi0
    Testing cxi0 with Gateway node elbert-gateway-0097 interface cxi1
    Testing cxi1 with Gateway node elbert-gateway-0097 interface cxi1
    Testing cxi2 with Gateway node elbert-gateway-0097 interface cxi1
    Testing cxi3 with Gateway node elbert-gateway-0097 interface cxi1
    Testing cxi4 with Gateway node elbert-gateway-0097 interface cxi1
    Testing cxi5 with Gateway node elbert-gateway-0097 interface cxi1
    Testing cxi6 with Gateway node elbert-gateway-0097 interface cxi1
    Testing cxi7 with Gateway node elbert-gateway-0097 interface cxi1
    nidXXXXX# ---------------------------------------------------
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
    Remote (server)  : NIC 0x7ea PID 3

    ... [output omitted] ...

    ---------------------------------------------------
        CXI RDMA Read Bandwidth Test
    Device           : cxi6
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
    Local (client)   : NIC 0x54230 PID 1 VNI 1
    Remote (server)  : NIC 0x7ab PID 6
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
    ---------------------------------------------------
    RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
        65536      405504   2656.55         1.297142
    ---------------------------------------------------
        65536      404224   2648.74         1.293328
    ---------------------------------------------------
        65536      404480   2649.95         1.293922
    ---------------------------------------------------
        65536      404224   2648.76         1.293342
    ---------------------------------------------------
        65536      404224   2648.75         1.293335
    ---------------------------------------------------
        65536      404224   2648.68         1.293300
    ---------------------------------------------------
        65536      404224   2648.48         1.293204
    ---------------------------------------------------
        65536      404224   2648.94         1.293426
    ---------------------------------------------------
        65536      404224   2648.07         1.293002
    ---------------------------------------------------
        65536      404224   2647.42         1.292685
    ---------------------------------------------------
        65536      403968   2647.22         1.292588
    ---------------------------------------------------
        65536      404224   2648.69         1.293307
    ---------------------------------------------------
        65536      404224   2648.74         1.293328
    ---------------------------------------------------
        65536      404224   2648.51         1.293219
    ---------------------------------------------------
        65536      404224   2648.57         1.293248
    ---------------------------------------------------
        65536      404224   2648.44         1.293184
    ---------------------------------------------------
    ```
