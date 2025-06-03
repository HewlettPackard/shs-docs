# `dgnettest_run.sh`

While `dgnettest` can be run as a standalone test for troubleshooting specific issues, it must run multiple times to get a full picture of the state of a system.
The script `dgnettest_run.sh` makes this easier by running the `dgnettest` in a number of configurations.
There are two test configurations that `dgnettest_run.sh` runs.

- **Switch:** This configuration runs the bisect bandwidth and all2all tests using the `dgnettest` option `-S` to display statistics. The set size is the number of edge ports on a switch, which is chosen based on the network class of the system, optionally specified with the `dgnettest_run.sh` option `-c`.
- **Group:** This configuration runs the bisect bandwidth and all2all tests using the `dgnettest` option `-S` to display statistics. The set size is 512, which is the number of nodes in a high-density cabinet.

## Prerequisite

The `dgnettest` utility requires an MPI ABI compatible version of MPICH.
Make sure that the `cray-mpich-api` module is loaded prior to running `dgnettest_run.sh`:

```screen
$ module unload cray-mpich
$ module load cray-mpich-abi
```

## Examples

- Typical run on dual-NIC system:

  ```screen
  $ dgnettest_run.sh -n nid[000013-000028]
  
  Running switch tests on NIC 0 over : nid[000013-000028]
  Using NIC 0
  nprocs=128 sets=2 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
  Test      Iter    Bytes      Min     Mean      Max      Dev       CV
  all2all      1   131072     8718     9805    10892     1537     15.7%
  all2all      2   131072    10987    11747    12507     1075      9.2%
  all2all      3   131072    10652    11217    11782      799      7.1%
  Test      Iter    Bytes      Min     Mean      Max      Dev       CV
  bisect       1   131072    18117    18144    18170       38      0.2%
  bisect       2   131072    18146    18177    18207       42      0.2%
  bisect       3   131072    18152    18182    18212       42      0.2%
  dgnettest has PASSED

  Running switch tests on NIC 1 over : nid[000013-000028]
  Using NIC 1
  nprocs=128 sets=2 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
  Test      Iter    Bytes      Min     Mean      Max      Dev       CV
  all2all      1   131072     5514     5762     6010      351      6.1%
  all2all      2   131072     4857     5128     5398      382      7.5%
  all2all      3   131072     6189     6437     6685      351      5.4%
  Test      Iter    Bytes      Min     Mean      Max      Dev       CV
  bisect       1   131072     6184     6188     6192        6      0.1%
  bisect       2   131072     5981     6030     6080       70      1.2%
  bisect       3   131072     5769     5843     5917      104      1.8%
  bisect       4   131072     5949     6026     6103      109      1.8%
  bisect       5   131072     6033     6111     6190      111      1.8%
  dgnettest has PASSED

  Running group tests on NIC 0 over : nid[000013-000028]
  Using NIC 0
  nprocs=128 sets=1 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
  Test      Iter    Bytes      Min     Mean      Max      Dev       CV
  all2all      1   131072    14073    14073    14073        0      0.0%
  all2all      2   131072    12926    12926    12926        0      0.0%
  all2all      3   131072    12558    12558    12558        0      0.0%
  Test      Iter    Bytes      Min     Mean      Max      Dev       CV
  bisect       1   131072    18087    18087    18087        0      0.0%
  bisect       2   131072    18197    18197    18197        0      0.0%
  bisect       3   131072    18202    18202    18202        0      0.0%
  dgnettest has PASSED

  Running group tests on NIC 1 over : nid[000013-000028]
  Using NIC 1
  nprocs=128 sets=1 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
  Test      Iter    Bytes      Min     Mean      Max      Dev       CV
  all2all      1   131072    11920    11920    11920        0      0.0%
  all2all      2   131072    10832    10832    10832        0      0.0%
  all2all      3   131072     9820     9820     9820        0      0.0%
  Test      Iter    Bytes      Min     Mean      Max      Dev       CV
  bisect       1   131072    12284    12284    12284        0      0.0%
  bisect       2   131072     6005     6005     6005        0      0.0%
  bisect       3   131072     5979     5979     5979        0      0.0%
  bisect       4   131072     5640     5640     5640        0      0.0%
  dgnettest has PASSED
  ```

- Running with a subset of tests:

  A list of tests to run can be passed to `dgnettest_run.sh`. When a test list is provided, the set-size must be specified with `-s` or the test list is ignored.

  ```screen
  $ dgnettest_run.sh -n nid[000022-000028] -s 16 bisect
  Running tests over : nid[000022-000028]
  nprocs=56 sets=2 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
  Test      Iter    Bytes  Set      Base  Ranks   Reps     Secs  BW/proc  BW/node
  bisect       1   131072    1 000.01.00     32   2791  0.00287  1391.85 11134.77
  bisect       1   131072    3 000.03.00     24   2791  0.00155  1936.26 15490.05
  bisect       2   131072    1 000.01.00     32   3682  0.00289  1383.68 11069.44
  bisect       2   131072    3 000.03.00     24   3682  0.00155  1929.98 15439.84
  bisect       3   131072    1 000.01.00     32   2064  0.00418   958.00  7664.01
  bisect       3   131072    3 000.03.00     24   2064  0.00155  1933.02 15464.16
  bisect       4   131072    1 000.01.00     32   2066  0.00337  1185.33  9482.63
  bisect       4   131072    3 000.03.00     24   2066  0.00155  1933.75 15470.04
  dgnettest has PASSED
  ```

- Custom NIC mapping:

  By default, NICs are divided and mapped evenly across the NUMA nodes. You can override it with custom mapping of threads to NICs.

  If `dgnettest` is run directly, several MPICH environment variables must be set.
  The `dgnettest_run.sh` script does this automatically when a custom mapping is provided.
  For example, two NICs can be split so NIC 0 is mapped to the even ranks and NIC 1 is mapped to the odd ranks.

  ```screen
  export MPICH_OFI_NUM_NICS=2
  export MPICH_OFI_NIC_POLICY="USER"
  export MPICH_OFI_NIC_MAPPING="0:0,2,4,6;1:1,3,5,7"
  ```

  The mapping should be provided to `dgnettest` and `dgnettest_run.sh` with the `-N` option.

  **Note:** Results are not guaranteed to be valid when using a custom mapping.
  You must ensure to validate any errors with a re-run of `dgnettest` with the default settings.

  ```screen
  $ dgnettest_run.sh -n nid[000022-000028] -C -N "0:0,2,4,6;1:1,3,5,7"

  Running group tests over : nid[000022-000028]
  Using all NICs
  nprocs=56 sets=1 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
  Test      Iter    Bytes      Min     Mean      Max      Dev       CV
  all2all      1   131072    13432    13432    13432        0      0.0%
  all2all      2   131072    16304    16304    16304        0      0.0%
  all2all      3   131072    16969    16969    16969        0      0.0%
  Test      Iter    Bytes      Min     Mean      Max      Dev       CV
  bisect       1   131072    14623    14623    14623        0      0.0%
  bisect       2   131072     8683     8683     8683        0      0.0%
  bisect       3   131072    14009    14009    14009        0      0.0%
  dgnettest has PASSED

  Running switch tests over : nid[000022-000028]
  Using all NICs
  nprocs=56 sets=2 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
  Test      Iter    Bytes      Min     Mean      Max      Dev       CV
  all2all      1   131072    14024    14024    14024        0      0.0%
  all2all      2   131072    25106    25106    25106        0      0.0%
  all2all      3   131072    18942    18942    18942        0      0.0%
  all2all      4   131072    19366    19366    19366        0      0.0%
  all2all   test bandwidth low  11055 MB/s for set 0 location 000.03.00 3 nodes: nid[000022,000025-000026]
  Test      Iter    Bytes      Min     Mean      Max      Dev       CV
  bisect       1   131072     8127    10795    13462     3772     34.9%
  bisect       2   131072     8114     8263     8411      210      2.5%
  bisect       3   131072     8084     9114    10144     1456     16.0%
  bisect    test bandwidth low   8084 MB/s for set 0 location 000.03.00 3 nodes: nid[000022,000025-000026]
  dgnettest has FAILED
  srun: error: nid000022: task 0: Exited with exit code 1
  ```
