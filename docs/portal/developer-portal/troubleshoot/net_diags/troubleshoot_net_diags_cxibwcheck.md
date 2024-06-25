
# Troubleshoot `cxibwcheck.sh`

When failures occur, often the details are contained in error logs that are created on the failing node(s). The log file location is printed for each failing node.

```screen
nid000002: cxi0: test failed (logfile is nid000002:/tmp/cxibwcheck.sh.errlog.144874)
nid000002: cxi1: test failed (logfile is nid000002:/tmp/cxibwcheck.sh.errlog.144874)
```

## No remote copies of `cxibwcheck.sh`

Running `cxibwcheck.sh` requires that a copy of the script is present on each
node. For some systems, `cxibwcheck.sh` is only installed on the UAN. In this
case, the `-b` option can be provided to use pdcp to create temporary copies of
`cxibwcheck.sh` on each node.

```screen
nid000008: bash: ./cxibwcheck.sh: No such file or directory
pdsh@uan: nid000008: ssh exited with exit code 127
```

## No remote copies of `cxi_write_bw`

`cxibwcheck.sh` uses the CXI diagnostic `cxi_write_bw` to measure bandwidth. This
is provided by the cray-libcxi-utils package, which should be installed on every
node. See the CXI Diagnostics and Utilities documentation for more details.

```screen
taskset: failed to execute /usr/bin/cxi_write_bw: No such file or directory
```

## Errors in nodelist

Before running the test, the node list is verified. If a node cannot be reached,
or if SSH key verification fails, an error is printed.

```screen
cxi-nid0: Host key verification failed.
pdsh@uan: cxi-nid0: ssh exited with exit code 255
cxibwcheck.sh: errors in nodelist (see /tmp/cxibwcheck.sh.log.19071) 0 remain
cxibwcheck.sh: nodelist is empty
```

## IP check errors

The following errors indicate types of problems with the HSN link.

```screen
test failed for hsn0 link is down
```

```screen
test failed IP address is not configured for hsn0
```

```screen
IP lookup for nid000008-hsn0 failed, trying nid000008
IP lookup for nid000008 failed
Please validate the configured IP addresses. The test will continue but errors may be due to address configuration issues.
```

```screen
IP address check failed for hsn0: Configured: 10.150.0.189 Lookup: 10.168.0.49
Please validate the configured IP addresses. The test will continue but errors may be due to address configuration issues.
```

## Bad AMA found

This error indicates that the NIC has not been configured with an algorithmic
MAC address.

```screen
Bad hsn0 AMA found:      link/ether 11:22:33:44:55:66 brd ff:ff:ff:ff:ff:ff
```

## PCIe check errors

These errors indicate that a NIC PCIe link did not come up completely. The node
should be rebooted, and if the problem persists, the card should be replaced.

```screen
found PCI width at x4
```

```screen
found PCIe Speed at 8GT/s
```

## Low bandwidth

If any NIC bandwidths fall far enough below the mean, or are below 35000 MB/s,
they are listed at the end of the test, and the test fails. Low bandwidths
indicate NIC or network issues. Cabling and link stability should be verified.
Switch routing and switch and NIC QoS settings should be verified. NIC and
switch error flags and counters should be checked.

```screen
# ./cxibwcheck.sh -b -t 1 cxi-nid[0-1]
cxibwcheck.sh: firmware version: 1.6.0.320
Hosts = 2 Count = 2 Skipped = 0 Failed = 0 Missing = 0
Min = 21215 Mean = 31822 Max = 42430
cxi-nid1: cxi0: bandwidth is low 21215 MB/s (66%)
Test failed (logfile is /tmp/cxibwcheck.sh.log.20078)
```
