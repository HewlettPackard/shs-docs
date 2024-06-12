
# `cxiberstat.sh` overview

The network diagnostic `cxiberstat.sh` measures NIC link corrected and
uncorrected bit error rates (BERs). By default the script uses Slurm to remotely
run cxi\_stat on each node. There is an option to use `pdsh` instead. Using
`pdsh` allows for testing both compute nodes and non-compute nodes, but
scalability is limited by the performance of the machine on which the script is
running. The script does not need to be installed on each node, as it uses
Slurm's broadcast feature to create a temporary copy of itself on each
node. When using `pdsh` instead of Slurm, remote execution is a series of
bash commands. The diagnostic does not require dedicated access to the nodes,
but does require root permissions to run. It should have no impact on node
performance.

Corrected and Uncorrected BERs are measured using the CXI diagnostic
cxi\_stat. For more information about this diagnostic, refer the CXI
Diagnostics and Utilities documentation. The BERs reflect errors on the NIC side
of the links only.

# Example

This example shows a run using Slurm and the default measurement duration of four seconds.

```screen
# cxiberstat.sh
Note: Using a duration of 4 means the minimum measurable rate is 1.176e-12
      Node  Device    CCW_BER    UCW_BER
nid000006:    cxi0  9.412e-12       <min
nid000006:    cxi1  3.765e-11       <min
nid000009:    cxi0  1.412e-11       <min
nid000009:    cxi1  3.294e-11       <min
nid000013:    cxi0       <min       <min
nid000013:    cxi1       <min       <min
nid000035:    cxi0  2.353e-11       <min
nid000035:    cxi1       <min       <min
nid000036:    cxi0  6.118e-11       <min
nid000036:    cxi1  8.000e-11       <min
nid000037:    cxi0  6.118e-11       <min
nid000037:    cxi1  4.706e-11       <min
nid000047:    cxi0  1.976e-10       <min
nid000047:    cxi1  2.353e-11       <min
nid000048:    cxi0  9.412e-12       <min
nid000048:    cxi1  1.412e-11       <min
nid000049:    cxi0  1.412e-11       <min
nid000049:    cxi1  2.353e-11       <min
nid000050:    cxi0       <min       <min
nid000050:    cxi1  4.565e-10       <min
nid000051:    cxi0  1.412e-11       <min
nid000051:    cxi1  5.176e-11       <min
nid000052:    cxi0       <min       <min
nid000052:    cxi1       <min       <min
nid000060:    cxi0       <min       <min
nid000060:    cxi1  1.882e-11       <min

CCW BER Summary
  Bin   # Histogram
1e-05:  0
1e-06:  0
1e-07:  0
1e-08:  0
1e-09:  0
1e-10:  2 ======
1e-11: 15 ========================================
1e-12:  2 ======
 <min:  7

UCW BER Summary
No UCW BERs above min measurable value
```

# Example Bad Run

This example shows a local node run where one device reports a high corrected
BER and a non-zero uncorrected BER. If this occurs with a cabled NIC, the cable
should be reseated or replaced. If that does not resolve the problem, or if this
occurs with a NIC that has a backplane connection, further investigation is
needed. The NIC card may need to be reseated or replaced. It may be helpful to
check error rates at the connected switch port.

```screen
# cxiberstat.sh x2510c7s6b0n0
x2510c7s6b0n0: Note: Using a duration of 4 means the minimum measurable rate is 1.176e-12
x2510c7s6b0n0:           Node  Device    CCW_BER    UCW_BER
x2510c7s6b0n0: x2510c7s6b0n0:    cxi0       <min       <min
x2510c7s6b0n0: x2510c7s6b0n0:    cxi1  1.412e-11       <min
x2510c7s6b0n0: x2510c7s6b0n0:    cxi2  2.519e-06  4.706e-12
x2510c7s6b0n0: x2510c7s6b0n0:    cxi3  9.412e-12       <min
```

# Troubleshoot `cxiberstat.sh`

## Unexpected link mode

The following error indicates that cxi_stat could not determine the link
speed. This likely means that the link went down while the measurement was being
performed, perhaps due to a high error rate.

```screen
x2510c7s6b0n0: Warning: encountered unexpected Link Mode NA for non-zero error rate 595424
```

## No remote copies of `cxi_stat`

The `cxiberstat.sh` uses the CXI diagnostic cxi\_stat to measure BERs. This is
provided by the `cray-libcxi-utils` package, which should be installed on every
node. For more information, see CXI Diagnostics and Utilities documentation.

```screen
# ./cxiberstat.sh
Errors occurred:
/tmp/cxiberstat.sh: line 64: cxi_stat: command not found
/tmp/cxiberstat.sh: line 64: cxi_stat: command not found

# ./cxiberstat.sh -p x0c0s0b0n[0-1]
Errors occurred:
x0c0s0b0n0: bash: cxi_stat: command not found
x0c0s0b0n1: bash: cxi_stat: command not found
```

## No output

If `cxiberstat.sh` runs without error but prints no output, this likely means that
`cxi_stat` ran on each node and found no NICs. Verify that the NIC drivers have
been installed.

## Missing option in `cxi_stat`

Older versions of `cxi_stat` do not support specifying the BER measurement
duration. If the following error is seen, try running `cxiberstat.sh` without the
`-u` option.

```screen
Errors occurred:
cxi_stat: invalid option -- 'p'
```
