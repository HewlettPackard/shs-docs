
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
