# RDMA interface troubleshooting

This section describes how to monitor the health of the 200Gbps or 400Gbps NIC RDMA interface.

## Libcxi utilities

The libcxi utility package contains a set of diagnostic tools that has been developed for troubleshooting NIC RMDA issues without using libfabric.
These include a tool to display device information and status, a number of bandwidth and latency benchmarks, and a thermal diagnostic. For more information, see the CXI Diagnostics and Utilities Guide.

## Libfabric utilities

The following subsections address the utilities provided with libfabric package to troubleshoot libfabric over NIC RDMA issues.

- `fi_info`
- `fi_pingpong`

**fi_info:**

The `fi_info` utility is provided in the libfabric package. This tool queries available libfabric interfaces.

The following example output shows a node with one 200Gbps NIC (CXI) interface available:

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

The availability of a CXI interface indicates several key signs of health. An interface is not made available unless it meets the following criteria:

- The interface retry handler is running
- A matching L2 interface is available
- The L1 interface has a temporary, locally administered, unicast address assigned to it. This is presumed to be an AMA applied by the fabric manager.
- The L1 link state is reported if verbosity is enabled. L1 link state reported by `fi_info` will match the state reported by the L2 device through the `ip` tool.

All these checks together make `fi_info` an excellent first tool to use to check the general health of the NIC RDMA interfaces.

**fi_pingpong:**

The `fi_pingpong` utility is also provided with libfabric. This is a basic client-server RDMA test. This is a quick and easy tool to use to validate end-to-end RDMA functionality.

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

This tool can use any IP interface for bootstrapping the RDMA communication. The ping-pong communication pattern does not achieve the best bandwidth results, however, the 1M transfer size should achieve high enough bandwidth to make the link operate at the expected speed.

This tool can be used between any two endpoints on a fabric or looped back to the same device.
