# Troubleshoot `dgnettest`

## Test failures

Test failures indicate NIC or network issues. A failure can often be isolated by running multiple tests using different node configurations. Once isolated, error flags and counters should be checked for the NICs and switches affected. Cabling and link stability should be verified. Algorithmic MAC addresses, switch routing, and switch and NIC QoS settings should be verified.

## Loopback test

If a node falls outside of a set threshold compared to the mean, a warning is displayed. There can be warnings for both too high and too low results, but only low results cause the test to fail. The inclusion of a too high warning is due to the possibility of extreme outliers skewing the results for other nodes. Begin by looking at outliers and retest once they have been fixed or without them included in the test. The threshold value is set to 90% by default (acceptable values fall within 10% above or below the mean). This can be adjusted with the `-T` option.

```screen
Running loopback tests on NIC 1 over : nid[000022-000028]
Using NIC 1
nprocs=56 sets=1 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
loopback  autoreps time 0.003501 reps 4284
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
loopback     1   131072     4044     6518     8156     1782     27.3%
loopback     2   131072     4235     7033     8771     1641     23.3%
loopback     3   131072     6653     7910     9145      998     12.6%
loopback     4   131072     4850     6785     9087     1796     26.5%
Final loopback bandwidth stats
loopback     4   131072     4235     7243     9145     1523     21.0%
Per node bandwidth stats
nid000022    4   131072     7900     8570     9039      596      7.0%   result is high
nid000023    4   131072     6223     6494     6823      304      4.7%    result is low
nid000024    4   131072     4235     6201     9145     2597     41.9%    result is low
nid000025    4   131072     6617     7914     8854     1161     14.7%
nid000026    4   131072     5356     6984     8206     1468     21.0%
nid000027    4   131072     6653     8150     9087     1309     16.1%   result is high
nid000028    4   131072     4850     6385     8045     1601     25.1%    result is low
dgnettest has FAILED
```

## Latency test

In the latency test the coefficient of variance (CV) is checked to see if it is below a threshold, which is set to 5% by default. If the CV is above this threshold, a warning is printed. In this case the latency histogram likely shows a wide range of latency values. The CV threshold can be adjusted with the `-l` option. Increasing the threshold is necessary when measuring latency for nodes that span multiple switches.

```screen
$ dgnettest_run.sh -n nid[001000-001009,001011-001081,001211-001219,001221-001279,001412-001499,001501-001511] -s 16 latency
Running tests over : nid[001000-001009,001011-001081,001211-001219,001221-001279,001412-001499,001501-001511]
nprocs=1984 sets=20 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test       Count    Min   Mean    Max    Dev     CV
latency     1596   1.81   2.37   2.93   0.33   13.9%     CV is high
latency histogram
latency   1.75 - 1.80     0
latency   1.80 - 1.85     66
latency   1.85 - 1.90     110
latency   1.90 - 1.95     27
latency   1.95 - 2.00     63
latency   2.00 - 2.05     123
latency   2.05 - 2.10     24
latency   2.10 - 2.15     70
latency   2.15 - 2.20     53
latency   2.20 - 2.25     59
latency   2.25 - 2.30     116
latency   2.30 - 2.35     93
latency   2.35 - 2.40     6
latency   2.40 - 2.45     116
latency   2.45 - 2.50     33
latency   > 2.50          637
dgnettest has PASSED
```

## Bisectional and all-to-all tests

If the bandwidth for a set of nodes falls below a set threshold compared to the mean, a warning is printed, and the test fails. The threshold value is set to 90% by default. This can be adjusted with the `-T` option.

```screen
Running group tests on NIC 1 over : nid[000004-000028,000033-000064]
Using NIC 1
nprocs=456 sets=2 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
all2all      1   131072     6357     6637     6918      397      6.0%
all2all      2   131072     6291     7326     8360     1463     20.0%
all2all   test bandwidth low   6291 MB/s for set 1 location 001.00.00 32 nodes: nid[000033-000064]
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
bisect       1   131072     6199     7922     9646     2438     30.8%
bisect       2   131072     5655     7360     9065     2411     32.8%
bisect       3   131072     5580     7356     9132     2511     34.1%
bisect    test bandwidth low   5580 MB/s for set 1 location 001.00.00 32 nodes: nid[000033-000064]
dgnettest has FAILED
```

## Not enough nodes

Due to the nature of the tests, the all2all test must have at least four nodes present per set, and the bisect test must have at least two nodes present. If a smaller configuration is used, a warning is displayed.

```screen
Running switch tests over : nid[000001-000004]
Using NIC 0
nprocs=32 sets=2 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
all2all      1   131072                          Not enough nodes
all2all      2   131072                          Not enough nodes
all2all      3   131072                          Not enough nodes
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
bisect       1   131072    19374    19621    19868      349      1.8%
bisect       2   131072    19409    19639    19869      326      1.7%
bisect       3   131072    19409    19651    19894      343      1.7%
dgnettest has PASSED
```

## `PMPI_Init` error

By default, `dgnettest` uses the MPI selection set in Slurm on the system. If this fails with the following error, try using the `--mpi` option to select a different version of MPI. A system's supported versions can be queried with `srun --mpi=list`.

```screen
aborting job:
Fatal error in PMPI_Init: Other MPI error, error stack:
MPIR_Init_thread(632):
MPID_Init(286).......:  PMI2 init failed: 1
MPICH ERROR [Rank 0] [job id unknown] [Wed Aug 26 14:01:10 2020] [unknown] [nid000009] - Abort(590863) (rank 0 in comm 0): Fatal error in PMPI_Init: Other MPI error, error stack:
MPIR_Init_thread(632):
MPID_Init(286).......:  PMI2 init failed: 1
```

## Failed to parse MAC

By default, `dgnettest` runs with an assumption that the network class of the system is class 2. The supported network classes range from 0 to 4. The following error is seen when an incorrect class type is used. The program may also hang.

```screen
dgnettest_run.sh -n nid[000005-000009]
Running loopback tests over : nid[000005-000009]
dgnettest: failed to parse MAC addr for Shasta node nid000006 02:00:00:00:00:3e
dgnettest: failed to parse MAC addr for Shasta node nid000009 02:00:00:00:00:2c
dgnettest: failed to parse MAC addr for Shasta node nid000005 02:00:00:00:00:3f
```

If the correct class type is used and MAC parsing errors are still printed, something may be cabled wrong or the MAC addresses may have been assigned incorrectly. The `-i` option can be used to force `dgnettest` to run despite these warnings.

## Too many nodes for network class

The following error indicates that too many nodes were selected for the given network class type.

```screen
$ dgnettest_run.sh -n nid[001000-001009,001083-001146,001188-001219,001278-001279,001284-001347,001432-001499,001501-001506,001510-001511] -c 0
Running loopback tests on NIC 0 over : nid[001000-001009,001083-001146,001188-001219,001278-001279,001284-001347,001432-001499,001501-001506,001510-001511]
Too many nodes selected for network class type 0, check the configuration
Too many nodes selected for network class type 0, check the configuration
...
```

## Slurm cannot find remote `dgnettest` binaries

Running `dgnettest` requires that a copy of the test is present on each node. For some systems, `dgnettest` is only installed on the user access node (UAN). In this case, the `-b` option can be provided to use Slurm's broadcast feature to create temporary copies of `dgnettest` on each node for the duration of the run.

```screen
$ dgnettest_run.sh -n nid[000002-000028]
Running loopback tests on NIC 0 over : nid[000002-000028]
slurmstepd: error: execve(): /tmp/./dgnettest: No such file or directory
slurmstepd: error: execve(): /tmp/./dgnettest: No such file or directory
slurmstepd: error: execve(): /tmp/./dgnettest: No such file or directory
slurmstepd: error: execve(): /tmp/./dgnettest: No such file or directory
...
```
