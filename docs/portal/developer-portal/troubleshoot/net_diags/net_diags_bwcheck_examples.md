
# Example

This example shows running the script with Slurm and using srun's broadcast
option to distribute the script to the nodes.

```screen
# srun -N6 --bcast=/tmp/bwcheck.sh /tmp/bwcheck.sh
bwcheck.sh: checking nodelist
bwcheck.sh: firmware version: 16.26.1040
bwcheck.sh: starting test
nid003707: mlx5_0: 12288.58
nid003710: mlx5_0: 12311.46
nid003705: mlx5_0: 12300.33
nid003711: mlx5_0: 12326.43
nid003708: mlx5_0: 12288.89
nid003709: mlx5_0: 12263.94
nid003707: mlx5_1: 12272.08
nid003710: mlx5_1: 12273.13
nid003705: mlx5_1: 12256.29
nid003711: mlx5_1: 12249.00
nid003708: mlx5_1: 12235.52
nid003709: mlx5_1: 12273.98
Hosts = 6 Count = 12 Skipped = 0 Failed = 0 Missing = 0
Min = 12236 Mean = 12278 Max = 12326
Test passed
```
