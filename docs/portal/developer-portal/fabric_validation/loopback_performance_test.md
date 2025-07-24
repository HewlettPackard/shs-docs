# Loopback performance test

The HPE Slingshot `cxi_gpu_loopback_bw` tool is used for testing loopback performance test on a node.
A successful loopback test ensures that the NIC is able to interface with the switch port with the expected performance level.
It also implies a healthy PCIe interface.

**Note:** The default `cxi_service` must be enabled for the loopback test to work.
The following is an example of how to enable on the cxi0 device:

```screen
cxi_service enable -s1 -d cxi0
```

A failure in a loopback test indicates any one or multiple of the following reasons:

- PCIe speed issue
- Switch port issue
- NIC issue
- Node hardware issues (processor, DIMM, and so on)

**Note:** This test does not require root privileges.
See the [Appendix](./appendix.md#appendix) for the list of packages to be installed for these utilities.

1. Execute `cxi_gpu_loopback_bw` tests on all interfaces of the gateway node. All interfaces should report greater than 180Gb/s.

   If performance is below the expected level, then the node should be diagnosed for the reasons mentioned earlier.

    ```screen
    # for i in {0..1};do echo cxi$i;cxi_gpu_loopback_bw --device cxi$i;done
    cxi0
    ---------------------------------------------------
        CXI Loopback Bandwidth Test
    Device           : cxi0
    Service ID       : 1
    TX Mem           : System
    RX Mem           : System
    Test Type        : Iteration
    Iterations       : 25
    Write Size (B)   : 524288
    Cmds per iter    : 8192
    Hugepages        : Disabled
    ---------------------------------------------------
    RDMA Size[B]      Writes  BW[Gb/s]  PktRate[Mpkt/s]
        524288      204800    186.37        11.375035
    ---------------------------------------------------
    cxi1
    ---------------------------------------------------
        CXI Loopback Bandwidth Test
    Device           : cxi1
    Service ID       : 1
    TX Mem           : System
    RX Mem           : System
    Test Type        : Iteration
    Iterations       : 25
    Write Size (B)   : 524288
    Cmds per iter    : 8192
    Hugepages        : Disabled
    ---------------------------------------------------
    RDMA Size[B]      Writes  BW[Gb/s]  PktRate[Mpkt/s]
        524288      204800    186.36        11.374379
    ---------------------------------------------------
    ```

2. Execute `cxi_gpu_loopback_bw` tests on all interfaces of the compute node. All interfaces should report greater than 180Gb/s.

    ```screen
    nidXXXXX# for i in {0..7};do echo cxi$i;cxi_gpu_loopback_bw --device cxi$i;done
    cxi0
    ---------------------------------------------------
        CXI Loopback Bandwidth Test
    Device           : cxi0
    Service ID       : 1
    TX Mem           : System
    RX Mem           : System
    Test Type        : Iteration
    Iterations       : 25
    Write Size (B)   : 524288
    Cmds per iter    : 8192
    Hugepages        : Disabled
    ---------------------------------------------------
    RDMA Size[B]      Writes  BW[Gb/s]  PktRate[Mpkt/s]
        524288      204800    184.63        11.268732
    ---------------------------------------------------
    cxi1
    ---------------------------------------------------
        CXI Loopback Bandwidth Test
    Device           : cxi1
    Service ID       : 1
    TX Mem           : System
    RX Mem           : System
    Test Type        : Iteration
    Iterations       : 25
    Write Size (B)   : 524288
    Cmds per iter    : 8192
    Hugepages        : Disabled
    ---------------------------------------------------
    RDMA Size[B]      Writes  BW[Gb/s]  PktRate[Mpkt/s]
        524288      204800    182.44        10.890877
    ---------------------------------------------------
    cxi2
    ---------------------------------------------------
        CXI Loopback Bandwidth Test
    Device           : cxi2
    Service ID       : 1
    TX Mem           : System
    RX Mem           : System
    Test Type        : Iteration
    Iterations       : 25
    Write Size (B)   : 524288
    Cmds per iter    : 8192
    Hugepages        : Disabled
    ---------------------------------------------------
    RDMA Size[B]      Writes  BW[Gb/s]  PktRate[Mpkt/s]
        524288      204800    185.33        11.311563
    ---------------------------------------------------
   
    ... [output omitted] ...

    ---------------------------------------------------
    cxi7
    ---------------------------------------------------
        CXI Loopback Bandwidth Test
    Device           : cxi7
    Service ID       : 1
    TX Mem           : System
    RX Mem           : System
    Test Type        : Iteration
    Iterations       : 25
    Write Size (B)   : 524288
    Cmds per iter    : 8192
    Hugepages        : Disabled
    ---------------------------------------------------
    RDMA Size[B]      Writes  BW[Gb/s]  PktRate[Mpkt/s]
        524288      204800    186.61        11.389751
    ---------------------------------------------------
    ```
