
# Examples

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

## Example Bad Run

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
