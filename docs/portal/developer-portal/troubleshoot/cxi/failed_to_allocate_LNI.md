# Failed to allocate LNI: Key has been revoked

The following output is an example of a diagnostic utility being unable to launch due to the default CXI service being disabled, and no other CXI service being passed in through the `-s` flag.

```screen
cxi_gpu_loopback_bw
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
Failed to allocate LNI: Key has been revoked
```

CXI Diagnostic tools need an enabled CXI Service to function properly. If the default CXI Service is (re)enabled, it will be utilized by diagnostic utilities automatically. If it is disabled, a separate CXI Service must be set up for each Node (and each NIC on the node). See "HPE Slingshot 200G NIC security" in the _HPE Slingshot Administration Guide_ for more information on CXI Services.
