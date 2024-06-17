
# `cxibwcheck.sh` overview

The network diagnostic `cxibwcheck.sh` measures bi-directional loopback bandwidth
for each Slingshot NIC on each node in a given set of nodes. It targets each
node in parallel, measuring bandwidth for all of a node's NICs in series. Install the
script on each node and optionally on the User Access Node (UAN) as well. The node copies can be run using Slurm, or the script can be
run from the UAN, where it uses `pdsh` to run the node copies. When using
`pdsh`, scalability is limited by the performance of the UAN. Using `pdsh` allows
for testing both compute nodes and non-compute nodes. The diagnostic does not
require dedicated access to the whole system, but does require root permissions
to run. It can be run on a subset of nodes allocated by the batch system. The
impact on performance of other applications is low.

Bi-directional RMDA write bandwidth is measured using the CXI diagnostic
`cxi_write_bw`. For more information about this diagnostic, see CXI
Diagnostics and Utilities documentation. Bandwidth is measured from each NIC to
its connected switch and then back to itself.

Several network checks are performed prior to running the test.

1. Check the nodelist to verify that all nodes are reachable and that SSH can be used.
2. Check the nodes if they are properly configured for IPv4 addresses and algorithmic MAC
addresses (AMAs).
3. Perform a nameserver lookup for each NIC and compare the resulting IPv4 addresses to what is configured.
4. Check the NIC links to ensure that they are up.
5. Verify the NIC PCIe links.
6. Check the PCIe links again after the test completes to verify that they have not degraded during the test.

The test measures, and can print, bi-directional bandwidth in stages. First the test
is performed for NIC 0 on all nodes, then NIC 1, and so on. After all NICs have
been measured, a summary is printed that includes the number of hosts targeted,
the overall NIC count, the number of failing NICs, and the number of NICs
excluded from the test by the network checks. This is followed by the min, max,
and mean bandwidths, along with a list of NICs whose performance falls below a
threshold compared to the mean.

# Example

This example shows a run using four dual-injection nodes.

```screen
# cxibwcheck.sh nid[000008-000011]
cxibwcheck.sh: firmware version: 1.6.0.320
Hosts = 4 Count = 8 Skipped = 0 Failed = 0 Missing = 0
Min = 39819 Mean = 40111 Max = 40987
Test passed
```

This example shows the same run with verbosity set to show the bi-directional bandwidth results for each NIC.

```screen
# cxibwcheck.sh -v nid[000008-000011]
cxibwcheck.sh: firmware version: 1.6.0.320
nid000009: cxi0: 39819
nid000008: cxi0: 39908
nid000011: cxi0: 39923
nid000010: cxi0: 40052
nid000009: cxi1: 40035
nid000008: cxi1: 39956
nid000011: cxi1: 40214
nid000010: cxi1: 40987
Hosts = 4 Count = 8 Skipped = 0 Failed = 0 Missing = 0
Min = 39819 Mean = 40111 Max = 40987
Test passed
```

This example shows a run using Slurm to execute the script on the nodes. Verbosity is set to 1, otherwise there is no output displayed for a passing test.

```screen
# salloc --nodelist=nid[000008-000011] --ntasks-per-node=1 --exclusive -Q sh -c "srun ./cxibwcheck.sh -v nid[000008-000011]"
nid000010: cxi0: 40835
nid000008: cxi0: 40607
nid000011: cxi0: 40406
nid000009: cxi0: 40529
nid000010: cxi1: 40683
nid000008: cxi1: 40751
nid000009: cxi1: 40604
nid000011: cxi1: 40669
```

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

## No remote copies of `cxi\_write\_bw`

`cxibwcheck.sh` uses the CXI diagnostic cxi\_write\_bw to measure bandwidth. This
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
