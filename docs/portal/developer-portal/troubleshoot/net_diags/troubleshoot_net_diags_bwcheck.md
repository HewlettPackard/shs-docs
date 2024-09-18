# Troubleshoot the `bwcheck.sh` script

## No remote copies of `bwcheck.sh`

Running the `bwcheck.sh` script requires that a copy of the script is present on each node. The following error indicates that the script has not been installed. You can resolve this issue by installing the cray-diags-fabric package on each node.

```screen
nid000008: bash: ./bwcheck.sh: No such file or directory
pdsh@uan: nid000008: ssh exited with exit code 127
```

## No remote copies of `ib_write_bw`

`bwcheck.sh` uses the Perftest diagnostic `ib_write_bw` to measure bandwidth. This is provided by the infiniband-diags package.

```screen
nid000008: taskset: failed to execute /usr/bin/ib_write_bw: No such file or directory
nid000008: taskset: failed to execute /usr/bin/ib_write_bw: No such file or directory
nid000008: mlx5_0: test failed (logfile is nid000008:/tmp/bwcheck.sh.errlog.213234)
nid000008: taskset: failed to execute /usr/bin/ib_write_bw: No such file or directory
nid000008: taskset: failed to execute /usr/bin/ib_write_bw: No such file or directory
nid000008: mlx5_1: test failed (logfile is nid000008:/tmp/bwcheck.sh.errlog.213234)
```

## Errors in nodelist

Before running the test, the node list is verified. If a node cannot be reached, or if SSH key verification fails, an error is printed.

```screen
nid000008: Host key verification failed.
pdsh@uan: nid000008: ssh exited with exit code 255
bwcheck.sh: checking nodelist
bwcheck.sh: errors in nodelist (see /tmp/bwcheck.sh.log.19071) 0 remain
bwcheck.sh: nodelist is empty
```

## IP check errors

The following errors indicate types of problems with the HSN link.

```screen
nid000008: test failed for eth4 link is down
```

```screen
nid000008: test failed IP address is not configured for eth4
```

```screen
nid000008: IP lookup for nid000008 failed
```

```screen
nid000008: IP address check failed for eth4: Configured: 10.150.0.189 Lookup: 10.168.0.49
```

## Low bandwidth

If any NIC bandwidth falls far below the mean, they are listed at the end of the test and the test fails. Low bandwidths indicate NIC or network issues. To rectify this issue, do one or more of the following actions:

- Verify the cabling and link stability
- Verify the switch routing and QoS settings
- Check the NIC and switch error flags and counters

```screen
# srun -N2 --bcast=/tmp/bwcheck.sh /tmp/bwcheck.sh
bwcheck.sh: checking nodelist
bwcheck.sh: firmware version: 16.26.1040
bwcheck.sh: starting test
nid003707: mlx5_0: 12288.58
nid003710: mlx5_0: 12311.46
nid003707: mlx5_1: 6121.34
nid003710: mlx5_1: 12273.13
Hosts = 2 Count = 4 Skipped = 0 Failed = 1 Missing = 0
Min = 6121 Mean = 10749 Max = 12311
nid003707: mlx5_1: bandwidth is low 6121 MB/s (57%)
Test failed (logfile is /tmp/bwcheck.sh.log.20078)
```
