# Troubleshoot `cxiberstat.sh`

## Unexpected link mode

The following error indicates that cxi_stat could not determine the link speed. This likely means that the link went down while the measurement was being performed, perhaps due to a high error rate.

```screen
x2510c7s6b0n0: Warning: encountered unexpected Link Mode NA for non-zero error rate 595424
```

## No remote copies of `cxi_stat`

The `cxiberstat.sh` uses the CXI diagnostic `cxi_stat` to measure BERs. This is provided by the `cray-libcxi-utils` package, which should be installed on every node. For more information, see CXI Diagnostics and Utilities documentation.

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

If `cxiberstat.sh` runs without error but prints no output, this likely means that `cxi_stat` ran on each node and found no NICs. Verify that the NIC drivers have been installed.

## Missing option in `cxi_stat`

Older versions of `cxi_stat` do not support specifying the BER measurement duration. If the following error is seen, try running `cxiberstat.sh` without the `-u` option.

```screen
Errors occurred:
cxi_stat: invalid option -- 'p'
```
