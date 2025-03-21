# Troubleshoot `dgnettest`

## Test failures

Test failures indicate NIC or network issues. A failure can often be isolated by running multiple tests using different node configurations. Once isolated, error flags and counters should be checked for the NICs and switches affected.
Cabling and link stability should be verified. Algorithmic MAC addresses, switch routing, and switch and NIC QoS settings should be verified.

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
Running switch tests over : nid[000005-000009]
dgnettest: failed to parse MAC addr for Shasta node nid000006 02:00:00:00:00:3e
dgnettest: failed to parse MAC addr for Shasta node nid000009 02:00:00:00:00:2c
dgnettest: failed to parse MAC addr for Shasta node nid000005 02:00:00:00:00:3f
```

If the correct class type is used and MAC parsing errors are still printed, something may be cabled wrong or the MAC addresses may have been assigned incorrectly. The `-i` option can be used to force `dgnettest` to run despite these warnings.

## Too many nodes for network class

The following error indicates that too many nodes were selected for the given network class type.

```screen
$ dgnettest_run.sh -n nid[001000-001009,001083-001146,001188-001219,001278-001279,001284-001347,001432-001499,001501-001506,001510-001511] -c 0
Running switch tests on NIC 0 over : nid[001000-001009,001083-001146,001188-001219,001278-001279,001284-001347,001432-001499,001501-001506,001510-001511]
Too many nodes selected for network class type 0, check the configuration
Too many nodes selected for network class type 0, check the configuration
...
```

## Slurm cannot find remote `dgnettest` binaries

Running `dgnettest` requires that a copy of the test is present on each node. For some systems, `dgnettest` is only installed on the user access node (UAN). In this case, the `-b` option can be provided to use Slurm's broadcast feature to create temporary copies of `dgnettest` on each node for the duration of the run.

```screen
$ dgnettest_run.sh -n nid[000002-000028]
Running switch tests on NIC 0 over : nid[000002-000028]
slurmstepd: error: execve(): /tmp/./dgnettest: No such file or directory
slurmstepd: error: execve(): /tmp/./dgnettest: No such file or directory
slurmstepd: error: execve(): /tmp/./dgnettest: No such file or directory
slurmstepd: error: execve(): /tmp/./dgnettest: No such file or directory
...
```
