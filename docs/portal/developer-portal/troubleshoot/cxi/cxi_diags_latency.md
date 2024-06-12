
# Latency

Latency is measured by obtaining the start and end times for individual
transactions. The start time is the point when the software initiates the
transaction. The end time is the point when software receives an event from the
device indicating that the transaction's final data write to either host has
occurred. For cxi\_write\_lat, this is the write to the target. For cxi\_read\_lat,
this is the write to the initiator. For cxi\_atomic\_lat, this is the write to the
target, or for fetching atomics, the initiator. For cxi\_send\_lat, a message is
sent first from client to server and then from server to client. The end time is
the point when the second message has been written, and the latency is estimated
by halving the round-trip time.

The client measures and reports the latency. The diagnostics can be run for a
number of iterations or for a duration of time. They can be configured to use a
single size or a range of sizes. They can be configured to use either system
memory or GPU memory for the initiator and target write buffers, with the
exception of cxi\_atomic_\lat. A summary of the run options is printed during
initialization. If the `--report-all` option is used, each individually measured
latency is printed. Finally several columns of data are printed, including the
transaction size, number of transactions, the measured minimum, maximum, and
average latencies, as well as the standard deviation.

## cxi\_write\_lat

The cxi\_write\_lat utility measures one-sided RDMA write latency. When using
system memory, it can be configured to use huge pages.

**Usage**

```screen
Usage:
  cxi_write_lat [-d DEV] [-p PORT]
                          Start a server and wait for connection
  cxi_write_lat ADDR [OPTIONS]
                          Connect to server with address ADDR

Options:
  -d, --device=DEV        Device name (default: "cxi0")
  -v, --svc-id=SVC_ID     Service ID (default: 1)
  -p, --port=PORT         The port to listen on/connect to (default: 49194)
  -t, --tx-gpu=GPU        GPU index for allocating TX buf (default: no GPU)
  -r, --rx-gpu=GPU        GPU index for allocating RX buf (default: no GPU)
  -g, --gpu-type=TYPE     GPU type (AMD or NVIDIA or INTEL) (default type determined
                          by discovered GPU files on system)
  -n, --iters=ITERS       Number of iterations to run (default: 100)
  -D, --duration=SEC      Run for the specified number of seconds
      --warmup=WARMUP     Number of warmup iterations to run (default: 10)
      --latency-gap=USEC  Number of microseconds to wait between each
                          iteration (default: 1000)
  -s, --size=MIN[:MAX]    Write size or range to use (default: 8)
                          Ranges must be powers of 2 (e.g. "1:8192")
                          The maximum size is 4294967295
      --unrestricted      Use unrestricted writes
      --no-idc            Do not use Immediate Data Cmds
      --no-ll             Do not use Low-Latency command issuing
      --report-all        Report all latency measurements individually
                          This option is ignored when using --duration
      --use-hp=SIZE       Attempt to use huge pages when allocating
                          Size may be "2M" or "1G"
  -h, --help              Print this help text and exit
  -V, --version           Print the version and exit
```

**Example**

This example shows a run with individual latencies printed.

*Server*
```screen
$ cxi_write_lat
Listening on port 49194 for client to connect...
------------------------------------------------------------------------
    CXI RDMA Write Latency Test
Device           : cxi0
Service ID       : 1
Client TX Mem    : System
Server RX Mem    : System
Test Type        : Iteration
Iterations       : 5
Warmup Iters     : 10
Inter-Iter Gap   : 1000 microseconds
Write Size       : 8
IDC              : Enabled
LL Cmd Launch    : Enabled
Results Reported : All
Hugepages        : Disabled
Local (server)   : NIC 0x12 PID 0 VNI 10
Remote (client)  : NIC 0x13 PID 0
------------------------------------------------------------------------
See client for results.
------------------------------------------------------------------------
```

*Client*
```screen
$ cxi_write_lat 10.1.1.8 -n 5 --report-all
------------------------------------------------------------------------
    CXI RDMA Write Latency Test
Device           : cxi0
Service ID       : 1
Client TX Mem    : System
Server RX Mem    : System
Test Type        : Iteration
Iterations       : 5
Warmup Iters     : 10
Inter-Iter Gap   : 1000 microseconds
Write Size       : 8
IDC              : Enabled
LL Cmd Launch    : Enabled
Results Reported : All
Hugepages        : Disabled
Local (client)   : NIC 0x13 PID 0 VNI 10
Remote (server)  : NIC 0x12 PID 0
------------------------------------------------------------------------
  WriteNum  Latency[us]
         0        2.008
         1        2.012
         2        2.008
         3        2.007
         4        2.008
------------------------------------------------------------------------
RDMA Size[B]      Writes     Min[us]     Max[us]    Mean[us]  StdDev[us]
           8           5        2.07        2.12        2.09        0.01
------------------------------------------------------------------------
```

## cxi\_read\_lat

The cxi\_read\_lat utility measures one-sided RDMA read latency. When using
system memory, it can be configured to use huge pages.

**Usage**

```screen
Usage:
  cxi_read_lat [-d DEV] [-p PORT]
                          Start a server and wait for connection
  cxi_read_lat ADDR [OPTIONS]
                          Connect to server with address ADDR

Options:
  -d, --device=DEV        Device name (default: "cxi0")
  -v, --svc-id=SVC_ID     Service ID (default: 1)
  -p, --port=PORT         The port to listen on/connect to (default: 49194)
  -t, --tx-gpu=GPU        GPU index for allocating TX buf (default: no GPU)
  -r, --rx-gpu=GPU        GPU index for allocating RX buf (default: no GPU)
  -g, --gpu-type=TYPE     GPU type (AMD or NVIDIA or INTEL) (default type determined
                          by discovered GPU files on system)
  -n, --iters=ITERS       Number of iterations to run (default: 100)
  -D, --duration=SEC      Run for the specified number of seconds
      --warmup=WARMUP     Number of warmup iterations to run (default: 10)
      --latency-gap=USEC  Number of microseconds to wait between each
                          iteration (default: 1000)
  -s, --size=MIN[:MAX]    Read size or range to use (default: 8)
                          Ranges must be powers of 2 (e.g. "1:8192")
                          The maximum size is 4294967295
      --unrestricted      Use unrestricted reads
      --no-ll             Do not use Low-Latency command issuing
      --report-all        Report all latency measurements individually
                          This option is ignored when using --duration
      --use-hp=SIZE       Attempt to use huge pages when allocating
                          Size may be "2M" or "1G"
  -h, --help              Print this help text and exit
  -V, --version           Print the version and exit
```

**Example**

This example shows a run over a range of sizes for 1 second each.

*Server*
```screen
$ cxi_read_lat
Listening on port 49194 for client to connect...
------------------------------------------------------------------------
    CXI RDMA Read Latency Test
Device           : cxi0
Service ID       : 1
Client TX Mem    : System
Server RX Mem    : System
Test Type        : Duration
Duration         : 1 seconds
Warmup Iters     : 10
Inter-Iter Gap   : 1000 microseconds
Min Read Size    : 64
Max Read Size    : 1024
LL Cmd Launch    : Enabled
Results Reported : Summary
Hugepages        : Disabled
Local (server)   : NIC 0x12 PID 0 VNI 10
Remote (client)  : NIC 0x12 PID 1
------------------------------------------------------------------------
See client for results.
------------------------------------------------------------------------
```

*Client*
```screen
$ cxi_read_lat 192.168.1.1 -D 1 -s 1:1024
------------------------------------------------------------------------
    CXI RDMA Read Latency Test
Device           : cxi0
Service ID       : 1
Client TX Mem    : System
Server RX Mem    : System
Test Type        : Duration
Duration         : 1 seconds
Warmup Iters     : 10
Inter-Iter Gap   : 1000 microseconds
Min Read Size    : 64
Max Read Size    : 1024
LL Cmd Launch    : Enabled
Results Reported : Summary
Hugepages        : Disabled
Local (client)   : NIC 0x12 PID 1 VNI 10
Remote (server)  : NIC 0x12 PID 0
------------------------------------------------------------------------
RDMA Size[B]       Reads     Min[us]     Max[us]    Mean[us]  StdDev[us]
          64       97181        2.61       13.91        2.70        0.07
         128       97080        2.63        5.55        2.71        0.07
         256       96887        2.66        6.17        2.74        0.07
         512       96548        2.71        5.44        2.77        0.05
        1024       95613        2.78       11.57        2.87        0.07
------------------------------------------------------------------------
```

## cxi\_send\_lat

The cxi\_send\_bw utility measures two-sided message latency. It can be
configured to use eager or rendezvous transactions. When using system memory, it
can be configured to use huge pages.

**Usage**

```screen
Usage:
  cxi_send_lat [-d DEV] [-p PORT]
                          Start a server and wait for connection
  cxi_send_lat ADDR [OPTIONS]
                          Connect to server with address ADDR

Options:
  -d, --device=DEV        Device name (default: "cxi0")
  -v, --svc-id=SVC_ID     Service ID (default: 1)
  -p, --port=PORT         The port to listen on/connect to (default: 49194)
  -t, --tx-gpu=GPU        GPU index for allocating TX buf (default: no GPU)
  -r, --rx-gpu=GPU        GPU index for allocating RX buf (default: no GPU)
  -g, --gpu-type=TYPE     GPU type (AMD or NVIDIA or INTEL) (default type determined
                          by discovered GPU files on system)
  -n, --iters=ITERS       Number of iterations to run (default: 100)
  -D, --duration=SEC      Run for the specified number of seconds
      --warmup=WARMUP     Number of warmup iterations to run (default: 10)
      --latency-gap=USEC  Number of microseconds to wait between each
                          iteration (default: 1000)
  -s, --size=MIN[:MAX]    Send size or range to use (default: 8)
                          Ranges must be powers of 2 (e.g. "1:8192")
                          The maximum size is 4294967295
      --no-idc            Do not use Immediate Data Cmds for sizes <= 224 bytes
      --no-ll             Do not use Low-Latency command issuing
  -R, --rdzv              Use rendezvous PUTs
      --report-all        Report all latency measurements individually
                          This option is ignored when using --duration
      --use-hp=SIZE       Attempt to use huge pages when allocating
                          Size may be "2M" or "1G"
  -h, --help              Print this help text and exit
  -V, --version           Print the version and exit
```

**Example**

This example shows a quick run using the default options.

*Server*

```screen
$ cxi_send_lat
Listening on port 49194 for client to connect...
----------------------------------------------------------------------
    CXI RDMA Send Latency Test
Device           : cxi0
Service ID       : 1
Client TX Mem    : System
Server RX Mem    : System
Test Type        : Iteration
Iterations       : 100
Warmup Iters     : 10
Inter-Iter Gap   : 1000 microseconds
Send Size        : 8
IDC              : Enabled
LL Cmd Launch    : Enabled
Results Reported : Summary
Hugepages        : Disabled
Local (server)   : NIC 0x12 PID 0 VNI 10
Remote (client)  : NIC 0x13 PID 0
----------------------------------------------------------------------
See client for results.
----------------------------------------------------------------------
```

*Client*

```screen
$ cxi_send_lat 192.168.1.1 -s 1:1024
----------------------------------------------------------------------
    CXI RDMA Send Latency Test
Device           : cxi0
Service ID       : 1
Client TX Mem    : System
Server RX Mem    : System
Test Type        : Iteration
Iterations       : 100
Warmup Iters     : 10
Inter-Iter Gap   : 1000 microseconds
Send Size        : 8
IDC              : Enabled
LL Cmd Launch    : Enabled
Results Reported : Summary
Hugepages        : Disabled
Local (client)   : NIC 0x13 PID 0 VNI 10
Remote (server)  : NIC 0x12 PID 0
----------------------------------------------------------------------
     Bytes       Sends     Min[us]     Max[us]    Mean[us]  StdDev[us]
         8         100        1.60        2.65        1.64        0.13
----------------------------------------------------------------------
```

## cxi\_atomic\_lat

The cxi\_atomic\_bw utility measures one-sided AMO latency. It can be configured
to use a specific atomic operation and data type. The utility works with or
without CPU offload, but enabling that feature in the NIC is left to the user.

**Usage**

```screen
Usage:
  cxi_atomic_lat [-d DEV] [-p PORT]
                          Start a server and wait for connection
  cxi_atomic_lat ADDR [OPTIONS]
                          Connect to server with address ADDR

Options:
  -d, --device=DEV        Device name (default: "cxi0")
  -v, --svc-id=SVC_ID     Service ID (default: 1)
  -p, --port=PORT         The port to listen on/connect to (default: 49194)
  -n, --iters=ITERS       Number of iterations to run (default: 100)
  -D, --duration=SEC      Run for the specified number of seconds
      --warmup=WARMUP     Number of warmup iterations to run (default: 10)
      --latency-gap=USEC  Number of microseconds to wait between each
                          iteration (default: 1000)
  -A, --atomic-op         The atomic operation to use (default: SUM)
  -C, --cswap-op          The CSWAP operation to use (default: EQ)
  -T, --atomic-type       The atomic type to use (default: UINT64)
      --fetching          Use fetching AMOs
      --matching          Use matching list entries at the target
      --unrestricted      Use unrestricted AMOs
      --no-idc            Do not use Immediate Data Cmds
      --no-ll             Do not use Low-Latency command issuing
      --report-all        Report all latency measurements individually
  -h, --help              Print this help text and exit
  -V, --version           Print the version and exit

Atomic Ops:
  MIN, MAX, SUM, LOR, LAND, BOR, BAND, LXOR, BXOR, SWAP, CSWAP, AXOR
CSWAP Ops:
  EQ, NE, LE, LT, GE, GT
Atomic Types:
  INT8, UINT8, INT16, UINT16, INT32, UINT32, INT64, UINT64, FLOAT, DOUBLE,
  FLOAT_COMPLEX, DOUBLE_COMPLEX, UINT128
```

**Example**

This example shows a quick run using the default options.

*Server*

```screen
$ cxi_atomic_lat
Listening on port 49194 for client to connect...
-----------------------------------------------------------------------
    CXI Atomic Memory Operation Latency Test
Device           : cxi0
Service ID       : 1
Test Type        : Iteration
Iterations       : 100
Warmup Iters     : 10
Inter-Iter Gap   : 1000 microseconds
Atomic Op        : NON-FETCHING SUM
Atomic Type      : UINT64
IDC              : Enabled
Matching LEs     : Disabled
Restricted       : Enabled
LL Cmd Launch    : Enabled
Results Reported : Summary
Local (server)   : NIC 0x12 PID 0 VNI 10
Remote (client)  : NIC 0x13 PID 0
-----------------------------------------------------------------------
See client for results.
-----------------------------------------------------------------------
```

*Client*

```screen
$ cxi_atomic_lat cxi-nid0
-----------------------------------------------------------------------
    CXI Atomic Memory Operation Latency Test
Device           : cxi0
Service ID       : 1
Test Type        : Iteration
Iterations       : 100
Warmup Iters     : 10
Inter-Iter Gap   : 1000 microseconds
Atomic Op        : NON-FETCHING SUM
Atomic Type      : UINT64
IDC              : Enabled
Matching LEs     : Disabled
Restricted       : Enabled
LL Cmd Launch    : Enabled
Results Reported : Summary
Local (client)   : NIC 0x13 PID 0 VNI 10
Remote (server)  : NIC 0x12 PID 0
-----------------------------------------------------------------------
AMO Size[B]         Ops     Min[us]     Max[us]    Mean[us]  StdDev[us]
          8         100        2.48        2.63        2.50        0.06
-----------------------------------------------------------------------
```
