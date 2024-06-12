
# `dgnettest` overview

The network diagnostic `dgnettest` is comprised of four individual tests. It
interfaces with Slurm to run multiple tests in parallel, setting up MPI
communicators for each blade, group, or other set of nodes. It can run on
systems of any size. It uses enough processes per node to get optimal performance
while ensuring that memory use remains low.

**Loopback Bandwidth Test:** The loopback test measures MPI bandwidth with each
NIC set to communicate through the connected Slingshot switch back to itself with
local memory sharing turned off. It reports bandwidth for each node and
highlights nodes that measured outside of a set threshold. This test runs for
each NIC on a node in serial, but for each node in parallel.

**Latency Test:** The latency test measures MPI point-to-point latency from one
node to itself and to every other node. The test measures round-trip latency and
halves this to estimate one-way latency. It reports a summary of latency
statistics along with a histogram to illustrate the measured distribution.

**Fabric Bisection Bandwidth Test:** The bisection bandwidth test divides the
nodes in two and measures bandwidth between the halves. In general you can
select the worst-case cut, but in a dragonfly network (or fat-tree) of
reasonable size it is similar. The bisection bandwidth is
usually limited by the bandwidth of the global links.

**Fabric All-to-All Test:** The all-to-all diagnostic measures performance of
all-to-all communication for sets of nodes corresponding to the physical
structure of a system: blades, chassis, groups, and the whole system. The test
is designed to run on as many nodes as are available, reporting variation in
performance over sets of nodes of a given size. For example, to run 512
instances of a blade level test on 2048 nodes and report variation between them
the set size would be 4.
The diagnostic generates a high network load. In particular it stresses the PCIe
interfaces that connect each node to its NICs. Poor performance on this test
correlates well to high rates of PCIe errors. It is intended that the test is
run on all nodes for a period of ten minutes. This is sufficient to detect
nodes with rates of PCIe errors that impact application performance.
The diagnostic uses MPI\_Alltoall with the DMAPP optimizations enabled. The tests are
representative of a real application. The diagnostic does not require
dedicated access to the whole system. It can be run on a subset of nodes
allocated by the batch system. The impact on performance of other applications
is low if all nodes in an electrical group are allocated to a test.

# `dgnettest_run.sh`

While `dgnettest` can be run as a standalone test for troubleshooting specific
issues, it must run multiple times to get a full picture of the
state of a system. The script `dgnettest\_run.sh` makes this easier by running the
`dgnettest` in a number of configurations. There are four test configurations that
`dgnettest\_run.sh` runs.

**Loopback:** This configuration runs the loopback bandwidth test.

**Latency:** This configuration runs the latency test. By default, it is
excluded from the test list. It can be included by providing `dgnettest\_run.sh`
with test list arguments that include `latency`. Note that specifying the test
list requires supplying a set size value with `-s` as well.

**Switch:** This configuration runs the bisect bandwidth and all2all tests
using the `dgnettest` option `-S` to display statistics. The set size is the
number of edge ports on a switch, which is chosen based on the network class
of the system, optionally specified with the `dgnettest\_run.sh` option `-c`.

**Group:** This configuration runs the bisect bandwidth and all2all tests
using the `dgnettest` option `-S` to display statistics. The set size is 512,
which is the number of nodes in a high-density cabinet.

# Examples

**Typical run on dual-NIC system:**

```bash
$ dgnettest_run.sh -n nid[000013-000028]
Running loopback tests on NIC 0 over : nid[000013-000028]
Using NIC 0
nprocs=128 sets=1 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
loopback     1   131072    10307    10503    10664       94      0.9%
loopback     2   131072    10497    10654    10777       83      0.8%
loopback     3   131072    10497    10655    10778       83      0.8%
Final loopback bandwidth stats
loopback     3   131072    10497    10655    10778       82      0.8%
Per node bandwidth stats
nid000013    3   131072    10733    10733    10734        1      0.0%
nid000014    3   131072    10671    10671    10672        1      0.0%
nid000015    3   131072    10688    10688    10689        1      0.0%
nid000016    3   131072    10777    10777    10778        0      0.0%
nid000017    3   131072    10757    10757    10758        0      0.0%
nid000018    3   131072    10592    10593    10593        1      0.0%
nid000019    3   131072    10633    10634    10634        1      0.0%
nid000020    3   131072    10643    10644    10644        0      0.0%
nid000021    3   131072    10638    10638    10638        0      0.0%
nid000022    3   131072    10703    10706    10709        4      0.0%
nid000023    3   131072    10756    10757    10757        0      0.0%
nid000024    3   131072    10613    10614    10615        1      0.0%
nid000025    3   131072    10612    10613    10613        0      0.0%
nid000026    3   131072    10498    10498    10498        0      0.0%
nid000027    3   131072    10654    10654    10655        0      0.0%
nid000028    3   131072    10497    10497    10497        1      0.0%
dgnettest has PASSED

Running loopback tests on NIC 1 over : nid[000013-000028]
Using NIC 1
nprocs=128 sets=1 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
loopback     1   131072     6065     6196     6883      189      3.0%
loopback     2   131072     6141     6235     7013      211      3.4%
loopback     3   131072     6134     6232     6842      169      2.7%
loopback     4   131072     6144     6265     7158      248      4.0%
loopback     5   131072     6144     6258     7322      285      4.6%
Final loopback bandwidth stats
loopback     5   131072     6134     6248     7322      227      3.6%
Per node bandwidth stats
nid000013    5   131072     6147     6167     6192       21      0.3%
nid000014    5   131072     6164     6178     6195       15      0.2%
nid000015    5   131072     6143     6154     6173       14      0.2%
nid000016    5   131072     6161     6185     6204       21      0.3%
nid000017    5   131072     6134     6161     6202       31      0.5%
nid000018    5   131072     6185     6190     6193        4      0.1%
nid000019    5   131072     6144     6150     6155        4      0.1%
nid000020    5   131072     6165     6173     6180        7      0.1%
nid000021    5   131072     6174     6178     6182        4      0.1%
nid000022    5   131072     6166     6186     6237       34      0.6%
nid000023    5   131072     6220     6286     6396       77      1.2%
nid000024    5   131072     6842     6984     7022       76      1.2%
nid000025    5   131072     6167     6215     6315       69      1.1%
nid000026    5   131072     6192     6193     6197        2      0.0%
nid000027    5   131072     6165     6179     6202       17      0.3%
nid000028    5   131072     6242     6281     6313       30      0.5%
dgnettest has PASSED

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

**Running with a subset of tests:**

A list of tests to run can be passed to `dgnettest\_run.sh`. When a test list is
provided, the set-size must be specified with `-s` or the test list is ignored.

```bash
$ dgnettest_run.sh -n nid[000022-000028] -s 16 latency bisect
Running tests over : nid[000022-000028]
nprocs=56 sets=2 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test       Count    Min   Mean    Max    Dev     CV
latency       25   1.86   1.88   1.90   0.01    0.7%
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

**Running concurrently on node NICs:**

The loopback test is always executed separately for each NIC number.

```bash
$ dgnettest_run.sh -n nid[001128-001163] -C
Running loopback tests on NIC 0 over : nid[001128-001163]
nprocs=288 sets=1 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
loopback     1   131072    11112    11184    11258       35      0.3%
loopback     2   131072    11181    11239    11286       27      0.2%
loopback     3   131072    11181    11240    11286       27      0.2%
Final loopback bandwidth stats
loopback     3   131072    11181    11240    11286       27      0.2%
Per node bandwidth stats
nid001128    3   131072    11232    11233    11234        1      0.0%
nid001129    3   131072    11259    11259    11260        1      0.0%
<lines omitted for brevity>
nid001162    3   131072    11226    11227    11227        1      0.0%
nid001163    3   131072    11230    11230    11230        0      0.0%
dgnettest has PASSED

Running loopback tests on NIC 1 over : nid[001128-001163]
nprocs=288 sets=1 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
loopback     1   131072     6157     6695     8457      649      9.7%
loopback     2   131072     6018     6266     8037      434      6.9%
loopback     3   131072     6026     6264     8051      444      7.1%
loopback     4   131072     6006     6266     8011      441      7.0%
Final loopback bandwidth stats
loopback     4   131072     6006     6265     8051      436      7.0%
Per node bandwidth stats
nid001128    4   131072     6265     6294     6341       42      0.7%
nid001129    4   131072     6152     6175     6209       30      0.5%
<lines omitted for brevity>
nid001162    4   131072     6013     6035     6066       28      0.5%
nid001163    4   131072     6019     6041     6058       20      0.3%
dgnettest has PASSED

Running group tests over : nid[001128-001163]
nprocs=288 sets=1 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
all2all      1   131072     9594     9594     9594        0      0.0%
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
bisect       1   131072    37902    37902    37902        0      0.0%
bisect       2   131072    40094    40094    40094        0      0.0%
bisect       3   131072    40099    40099    40099        0      0.0%
dgnettest has PASSED

Running switch tests over : nid[001128-001163]
nprocs=288 sets=4 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
all2all      1   131072    36344    36443    36542      140      0.4%
all2all      2   131072    19979    20779    21580     1132      5.4%
all2all      3   131072    21386    21925    22464      762      3.5%
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
bisect       1   131072    33610    35609    37498     1900      5.3%
bisect       2   131072    33786    38274    42493     4812     12.6%
bisect       3   131072    33789    38269    42517     4831     12.6%
dgnettest has PASSED
```

**Custom NIC mapping:**

By default, NICs are divided and mapped evenly across the NUMA nodes. You can
override it with custom mapping of threads to NICs.

If `dgnettest` is run directly, several MPICH environment variables
must be set. The `dgnettest\_run.sh` script does this automatically when a custom
mapping is provided. For example, two NICs can be split so NIC 0 is mapped to
the even ranks and NIC 1 is mapped to the odd ranks.

```bash
$ export MPICH_OFI_NUM_NICS=2
$ export MPICH_OFI_NIC_POLICY="USER"
$ export MPICH_OFI_NIC_MAPPING="0:0,2,4,6;1:1,3,5,7"
```

The mapping should be provided to `dgnettest` and `dgnettest\_run.sh` with the `-N` option.

**Note:** Results are not guaranteed to be valid when using a custom mapping. You must ensure to validate any errors with a re-run of `dgnettest` with the default settings.

```bash
$ dgnettest_run.sh -n nid[000022-000028] -C -N "0:0,2,4,6;1:1,3,5,7"
Running loopback tests on NIC 0 over : nid[000022-000028]
Using NIC 0
nprocs=56 sets=1 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
loopback     1   131072     3616     3636     3655       12      0.3%
loopback     2   131072     3644     3650     3655        4      0.1%
loopback     3   131072     3644     3650     3656        5      0.1%
Final loopback bandwidth stats
loopback     3   131072     3644     3650     3656        4      0.1%
Per node bandwidth stats
nid000022    3   131072     3645     3646     3646        0      0.0%
nid000023    3   131072     3651     3652     3652        1      0.0%
nid000024    3   131072     3650     3650     3650        0      0.0%
nid000025    3   131072     3655     3656     3656        0      0.0%
nid000026    3   131072     3644     3644     3644        0      0.0%
nid000027    3   131072     3655     3655     3655        0      0.0%
nid000028    3   131072     3647     3647     3647        0      0.0%
dgnettest has PASSED

Running loopback tests on NIC 1 over : nid[000022-000028]
Using NIC 1
nprocs=56 sets=1 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
loopback     1   131072     4082     5471     8073     1735     31.7%
loopback     2   131072     4181     6877     8943     2037     29.6%
loopback     3   131072     4180     7597     8934     1659     21.8%
Final loopback bandwidth stats
loopback     3   131072     4180     7237     8943     1824     25.2%
Per node bandwidth stats
nid000022    3   131072     8282     8358     8433      107      1.3%   result is high
nid000023    3   131072     4186     6132     8077     2751     44.9%    result is low
nid000024    3   131072     4180     4181     4181        0      0.0%    result is low
nid000025    3   131072     6814     7147     7479      470      6.6%
nid000026    3   131072     6308     7571     8835     1787     23.6%
nid000027    3   131072     8934     8939     8943        6      0.1%   result is high
nid000028    3   131072     8058     8335     8611      391      4.7%   result is high
dgnettest has FAILED
srun: error: nid000022: task 0: Exited with exit code 1

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

# Troubleshoot `dgnettest`

## Test failures

Test failures indicate NIC or network issues. A failure can often be isolated by
running multiple tests using different node configurations. Once isolated, error
flags and counters should be checked for the NICs and switches affected. Cabling
and link stability should be verified. Algorithmic MAC addresses, switch
routing, and switch and NIC QoS settings should be verified.

## Loopback test

If a node falls outside of a set threshold compared to the mean, a warning is
displayed. There can be warnings for both too high and too low results, but only
low results cause the test to fail. The inclusion of a too high warning is due
to the possibility of extreme outliers skewing the results for other
nodes. Begin by looking at outliers and retest once they have been
fixed or without them included in the test. The threshold value is set to 90% by
default (acceptable values fall within 10% above or below the mean). This can be
adjusted with the `-T` option.

```bash
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

In the latency test the coefficient of variance (CV) is checked to see if it is
below a threshold, which is set to 5% by default. If the CV is above this
threshold, a warning is printed. In this case the latency histogram likely shows
a wide range of latency values. The CV threshold can be adjusted with the `-l`
option. Increasing the threshold is necessary when measuring latency for nodes
that span multiple switches.

```bash
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

If the bandwidth for a set of nodes falls below a set threshold compared to the
mean, a warning is printed, and the test fails. The threshold value is set to
90% by default. This can be adjusted with the `-T` option.

```bash
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

Due to the nature of the tests, the all2all test must have at least 4 nodes
present per set, and the bisect test must have at least 2 nodes present. If a
smaller configuration is used, a warning is displayed.

```bash
Running switch tests over : nid[000001-000004]
Using NIC 0
nprocs=32 sets=2 maxbytes=131072 ppn=8 (Warning: no PMI set manually)
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
all2all      1   131072 						 Not enough nodes
all2all      2   131072 						 Not enough nodes
all2all      3   131072 						 Not enough nodes
Test      Iter    Bytes      Min     Mean      Max      Dev       CV
bisect       1   131072    19374    19621    19868      349      1.8%
bisect       2   131072    19409    19639    19869      326      1.7%
bisect       3   131072    19409    19651    19894      343      1.7%
dgnettest has PASSED
```

## PMPI\_Init error

By default, `dgnettest` uses the MPI selection set in Slurm on the system. If this
fails with the following error, try using the `--mpi` option to select a
different version of MPI. A system's supported versions can be queried with
`srun --mpi=list`.

```bash
aborting job:
Fatal error in PMPI_Init: Other MPI error, error stack:
MPIR_Init_thread(632):
MPID_Init(286).......:  PMI2 init failed: 1
MPICH ERROR [Rank 0] [job id unknown] [Wed Aug 26 14:01:10 2020] [unknown] [nid000009] - Abort(590863) (rank 0 in comm 0): Fatal error in PMPI_Init: Other MPI error, error stack:
MPIR_Init_thread(632):
MPID_Init(286).......:  PMI2 init failed: 1
```

## Failed to parse MAC

By default, `dgnettest` runs with an assumption that the network class of the
system is class 2. The supported network classes range from 0 to 4. The
following error is seen when an incorrect class type is used. The program may
also hang.

```bash
dgnettest_run.sh -n nid[000005-000009]
Running loopback tests over : nid[000005-000009]
dgnettest: failed to parse MAC addr for Shasta node nid000006 02:00:00:00:00:3e
dgnettest: failed to parse MAC addr for Shasta node nid000009 02:00:00:00:00:2c
dgnettest: failed to parse MAC addr for Shasta node nid000005 02:00:00:00:00:3f
```

If the correct class type is used and MAC parsing errors are still printed,
something may be cabled wrong or the MAC addresses may have been assigned
incorrectly. The `-i` option can be used to force `dgnettest` to run despite these
warnings.

## Too many nodes for network class

The following error indicates that too many nodes were selected for the given
network class type.

```bash
$ dgnettest_run.sh -n nid[001000-001009,001083-001146,001188-001219,001278-001279,001284-001347,001432-001499,001501-001506,001510-001511] -c 0
Running loopback tests on NIC 0 over : nid[001000-001009,001083-001146,001188-001219,001278-001279,001284-001347,001432-001499,001501-001506,001510-001511]
Too many nodes selected for network class type 0, check the configuration
Too many nodes selected for network class type 0, check the configuration
...
```

## Slurm cannot find remote `dgnettest` binaries

Running `dgnettest` requires that a copy of the test is present on each node. For
some systems, `dgnettest` is only installed on the user access node (UAN). In this
case, the `-b` option can be provided to use Slurm's broadcast feature to create
temporary copies of `dgnettest` on each node for the duration of the run.

```bash
$ dgnettest_run.sh -n nid[000002-000028]
Running loopback tests on NIC 0 over : nid[000002-000028]
slurmstepd: error: execve(): /tmp/./dgnettest: No such file or directory
slurmstepd: error: execve(): /tmp/./dgnettest: No such file or directory
slurmstepd: error: execve(): /tmp/./dgnettest: No such file or directory
slurmstepd: error: execve(): /tmp/./dgnettest: No such file or directory
...
```
