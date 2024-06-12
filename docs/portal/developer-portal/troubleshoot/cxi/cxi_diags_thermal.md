
# Thermal diagnostic

The cxi\_heatsink\_check utility is a thermal diagnostic intended to validate that
heat is being dissipated properly. It stresses the ASIC by generating a large
amount of small RDMA writes.

## Node configuration

When testing a single-NIC device, only one instance of cxi\_heatsink\_check is
needed. However, when testing a dual-NIC device, two instances of the diagnostic
must run simultaneously, each targeting one of the two NICs. Dual-NIC pairs can
be determined by using cxi\_stat to obtain NIC serial numbers. NICs of the same
device will have identical serial numbers.

**Note:** In some compute blades, each NIC of a dual-NIC device belongs to a
separate node.

To generate the most heat, the HSN link should be configured in mission-mode.
Internal-loopback does not fully exercise the SerDes.

## Running the diagnostic

Running cxi\_heatsink\_check requires root privileges.

**Usage**

```bash
Monitor 200Gbps NIC temperature and power consumption while stressing
the chip with RDMA writes.
Requirements:
  1. The NIC must be able to initiate writes to itself, either by being
  configured in internal loopback mode, or by having a link partner that is
  configured to allow routing packets back to their source.
  2. When configured in internal loopback mode, the --no-hrp option must be
  used.
  3. When testing a dual-NIC card, the diagnostic should be run for each NIC
  concurrently or the power target will not be reached.

Options:
  -d, --device=DEV       Device name (default: "cxi0")
  -v, --svc-id=SVC_ID    Service ID (default: 1)
  -t, --tx-gpu=GPU       GPU index for allocating TX buf (default: no GPU)
  -r, --rx-gpu=GPU       GPU index for allocating RX buf (default: no GPU)
  -g, --gpu-type=TYPE    GPU type (AMD or NVIDIA or INTEL) (default type determined
                         by discovered GPU files on system)
  -P, --procs=PROCS      Number of write-generating processes
                         (default: 1/4 of available processors)
  -c, --cpu-list=LIST    Processors to use when assigning affinities to
                         write-generating processes (default assigned based
                         on device number and socket count)
  -D, --duration=SEC     Run for the specified number of seconds (default: 600)
  -i, --interval=INT     Interval in seconds to check and print sensor
                         readings (default: 10)
  -s, --size=SIZE        RDMA Write size to use (default: 512)
                         The maximum size is 262144
  -l, --list-size=LSIZE  Number of writes per iteration, all pushed to
                         the Tx CQ prior to initiating xfer (default: 256)
      --no-hrp           Do not use High Rate Puts for sizes <= 2048 bytes
      --no-idc           Do not use Immediate Data Cmds for high rate put
                         sizes <= 224 bytes and matching put sizes <= 192 bytes
      --no-ple           Append a single use-once list entry for every write
                         Note: Combining this option with large LSIZE and PROCS
                         values may results in NO_SPACE errors
  -h, --help             Print this help text and exit
  -V, --version          Print the version and exit
```

**Example of a successful run:**

In this example, the cxi\_heatsink\_check diagnostic utility successfully executed
and all tests passed as expected.

```bash
# cxi_heatsink_check -D 60
------------------------------------------------------------
    CXI Heatsink Test
Device          : cxi0
TX Mem          : System
RX Mem          : System
Duration        : 60 seconds
Sensor Interval : 10 seconds
TX/RX Processes : 32
Processor List  : 1-31,0
RDMA Write Size : 512
List Size       : 250
HRP             : On
IDC             : On
Persistent LEs  : On
Local Address   : NIC 0x13
Board Type      : Dual-NIC
------------------------------------------------------------
Time[s]  Rate[GB/s]  VDD[W]  AVDD[W]  ASIC_0[°C]  ASIC_1[°C]
     10       21.64      18        6          56          56
     20       22.01      18        6          57          57
     30       22.01      18        6          57          57
     40       22.01      18        6          57          57
     50       22.01      18        7          58          58
------------------------------------------------------------
Cassini 0 Temperature (ASIC_0) under 85 °C:  58 °C       PASS
Cassini 1 Temperature (ASIC_1) under 85 °C:  58 °C       PASS
0.85V S0 Power (VDD):                        18 W        ----
0.9V S0 Power (AVDD):                        7 W         ----
Average BW over 19 GB/s:                     21.94 GB/s  PASS
```

**Example bandwidth target failures:**

This example shows a single failure (**Average BW over 19 GB/s**) that indicates
that the target bandwidth was not reached.

```bash
# cxi_heatsink_check -D 60 -P 1
------------------------------------------------------------
    CXI Heatsink Test
Device          : cxi0
TX Mem          : System
RX Mem          : System
Duration        : 60 seconds
Sensor Interval : 10 seconds
TX/RX Processes : 1
Processor List  : 1-31,0
RDMA Write Size : 512
List Size       : 250
HRP             : On
IDC             : On
Persistent LEs  : On
Local Address   : NIC 0x12
Board Type      : Dual-NIC
------------------------------------------------------------
Time[s]  Rate[GB/s]  VDD[W]  AVDD[W]  ASIC_0[°C]  ASIC_1[°C]
     10       10.30      15        6          55          56
     20       10.30      15        6          55          56
     30       10.31      16        6          56          56
     40       10.32      16        6          56          56
     50       10.33      16        6          56          56
------------------------------------------------------------
Cassini 0 Temperature (ASIC_0) under 85 °C:  56 °C       PASS
Cassini 1 Temperature (ASIC_1) under 85 °C:  56 °C       PASS
0.85V S0 Power (VDD):                        16 W        ----
0.9V S0 Power (AVDD):                        6 W         ----
Average BW over 19 GB/s:                     10.31 GB/s  FAIL
```

**Example high temperature failure:**

This example shows a single failure (**200Gbps NIC 0 Temperature (ASIC\_0) under
85°C**). The 200Gbps NIC temperature rose higher than expected, which indicates that
heat is not being dissipated properly. In this case the 200Gbps NIC card should
be inspected to ensure that the heatsink is properly installed and that the
cabinet has adequate cooling. If the problem persists and is local to only one
card within the cabinet, then the 200Gbps NIC card should be replaced.

```bash
# cxi_heatsink_check -D 12 -i 2
------------------------------------------------------------
    CXI Heatsink Test
Device          : cxi0
TX Mem          : System
RX Mem          : System
Duration        : 12 seconds
Sensor Interval : 2 seconds
TX/RX Processes : 32
Processor List  : 1-31,0
RDMA Write Size : 512
List Size       : 250
HRP             : On
IDC             : On
Persistent LEs  : On
Local Address   : NIC 0x12
Board Type      : Dual-NIC
------------------------------------------------------------
Time[s]  Rate[GB/s]  VDD[W]  AVDD[W]  ASIC_0[°C]  ASIC_1[°C]
      2       21.13      18        6          81          79
      4       21.38      18        6          82          80
      6       21.55      18        6          83          81
      8       21.75      18        6          84          82
     10       21.93      18        6          85          83
------------------------------------------------------------
Cassini 0 Temperature (ASIC_0) under 85 °C:  85 °C       FAIL
Cassini 1 Temperature (ASIC_1) under 85 °C:  83 °C       PASS
0.85V S0 Power (VDD):                        18 W        ----
0.9V S0 Power (AVDD):                        6 W         ----
Average BW over 19 GB/s:                     21.55 GB/s  PASS
```

**Example early stop:**

This example illustrates an early exit due to the 200Gbps NIC 0 temperature
continuing to climb into an unsafe range. In this case the test is stopped
immediately. If the temperature was allowed to continue to climb, the 200Gbps NIC card would execute an Emergency Power Off (EPO). The 200Gbps NIC card should
be inspected to ensure that the heatsink is properly installed and that the
cabinet has adequate cooling. If the problem persists and is local to only one
card within the cabinet, then the 200Gbps NIC card should be replaced.

```bash
# cxi_heatsink_check -D 12 -i 1
------------------------------------------------------------
    CXI Heatsink Test
Device          : cxi0
TX Mem          : System
RX Mem          : System
Duration        : 12 seconds
Sensor Interval : 1 seconds
TX/RX Processes : 32
Processor List  : 1-31,0
RDMA Write Size : 512
List Size       : 250
HRP             : On
IDC             : On
Persistent LEs  : On
Local Address   : NIC 0x12
Board Type      : Dual-NIC
------------------------------------------------------------
Time[s]  Rate[GB/s]  VDD[W]  AVDD[W]  ASIC_0[°C]  ASIC_1[°C]
      1       20.96      18        6          81          79
      2       21.11      18        6          82          80
      3       21.30      18        6          83          81
      4       21.52      18        6          84          82
      5       21.67      18        6          85          83
      6       21.75      18        6          86          84
      7       21.84      18        6          87          85
      8       21.92      18        6          88          86
      9       21.93      18        6          89          87
     10       21.98      18        6          90          88

Error! Cassini 0 Temperature has exceeded safe range. Exiting early.
------------------------------------------------------------
Cassini 0 Temperature (ASIC_0) under 85 °C:  90 °C       FAIL
Cassini 1 Temperature (ASIC_1) under 85 °C:  88 °C       FAIL
0.85V S0 Power (VDD):                        18 W        ----
0.9V S0 Power (AVDD):                        6 W         ----
Average BW over 19 GB/s:                     21.60 GB/s  PASS
```
