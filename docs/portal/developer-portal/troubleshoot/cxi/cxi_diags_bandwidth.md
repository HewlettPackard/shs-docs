# Bandwidth

Bandwidth is calculated using the frame payload. The client/server
diagnostics can measure uni-directionally or bidirectionally. Uni-directional
bandwidth is measured by the client, shared with the server, and reported by
both. Bidirectional bandwidth is measured by both the client and server; they share their results and report the combined value.

- The diagnostics can be run for a number of iterations or for a duration of time.
- They can be configured to use a single size or a range of sizes, with the
exception of `cxi_gpu_bw_loopback` which does not support ranges.
- They can be configured to use either system memory or GPU memory for the initiator and
target write buffers, with the exception of `cxi_atomic_bw`. 

A summary of the run options is printed during initialization. The summary is followed by several
columns of data, including the transaction size, number of transactions, measured bandwidth, and measured transaction rate.

## `cxi_write_bw`

The `cxi_write_bw` utility measures one-sided RDMA write bandwidth. When using
system memory, it can be configured to use huge pages.

**Usage**

```screen
Usage:
  cxi_write_bw [-d DEV] [-p PORT]
                         Start a server and wait for connection
  cxi_write_bw ADDR [OPTIONS]
                         Connect to server with address ADDR

Options:
  -d, --device=DEV       Device name (default: "cxi0")
  -v, --svc-id=SVC_ID    Service ID (default: 1)
  -p, --port=PORT        The port to listen on/connect to (default: 49194)
  -t, --tx-gpu=GPU       GPU index for allocating TX buf (default: no GPU)
  -r, --rx-gpu=GPU       GPU index for allocating RX buf (default: no GPU)
  -g, --gpu-type=TYPE    GPU type (AMD or NVIDIA or INTEL) (default type determined
                         by discovered GPU files on system)
  -n, --iters=ITERS      Number of iterations to run (default: 1000)
  -D, --duration=SEC     Run for the specified number of seconds
  -s, --size=MIN[:MAX]   Write size or range to use (default: 65536)
                         Ranges must be powers of 2 (e.g. "1:8192")
                         The maximum size is 4294967295
  -l, --list-size=SIZE   Number of writes per iteration, all pushed to
                         the Tx CQ prior to initiating xfer (default: 256)
  -b, --bidirectional    Measure bidirectional bandwidth
      --unrestricted     Use unrestricted writes
      --no-hrp           Do not use High Rate Puts for sizes <= 2048 bytes
      --no-idc           Do not use Immediate Data Cmds
      --buf-sz=SIZE      The max TX/RDMA buffer size, specified in bytes
                         If (size * list_size) > buf_sz, writes will overlap
                         (default: 4294967296)
      --buf-align=ALIGN  Byte-alignment of writes in the buffer (default: 64)
      --use-hp=SIZE      Attempt to use huge pages when allocating
                         Size may be "2M" or "1G"
  -h, --help             Print this help text and exit
  -V, --version          Print the version and exit
```

**Example**

This example shows a bidirectional run over a range of sizes for five seconds
each.

*Server*

```screen
$ cxi_write_bw
Listening on port 49194 for client to connect...
---------------------------------------------------
    CXI RDMA Write Bandwidth Test
Device           : cxi0
Service ID       : 1
Client TX Mem    : System
Server RX Mem    : System
Test Type        : Duration
Duration         : 5 seconds
Min Write Size   : 1024
Max Write Size   : 65536
List Size        : 256
HRP              : Enabled
IDC              : Enabled
Bidirectional    : Enabled
Max RDMA Buf     : 4294967296 (16777216 used)
RDMA Buf Align   : 64
Hugepages        : Disabled
Local (server)   : NIC 0x12 PID 0 VNI 10
Remote (client)  : NIC 0x13 PID 0
---------------------------------------------------
RDMA Size[B]      Writes  BW[MB/s]  PktRate[Mpkt/s]
        1024    71568640  29314.66        28.627597
        2048    44694528  36613.15        17.877517
        4096    21218560  34763.74        16.974481
        8192    11737856  38461.53        18.780044
       16384     6154752  40333.92        19.694297
       32768     3153664  41334.64        20.182929
       65536     1522688  40550.70        19.800147
---------------------------------------------------
```

*Client*

```screen
$ cxi_write_bw 10.1.1.8 -D 5 -s 1024:65536 -b
---------------------------------------------------
    CXI RDMA Write Bandwidth Test
Device           : cxi0
Service ID       : 1
Client TX Mem    : System
Server RX Mem    : System
Test Type        : Duration
Duration         : 5 seconds
Min Write Size   : 1024
Max Write Size   : 65536
List Size        : 256
HRP              : Enabled
IDC              : Enabled
Bidirectional    : Enabled
Max RDMA Buf     : 4294967296 (16777216 used)
RDMA Buf Align   : 64
Hugepages        : Disabled
Local (client)   : NIC 0x13 PID 0 VNI 10
Remote (server)  : NIC 0x12 PID 0
---------------------------------------------------
RDMA Size[B]      Writes  BW[MB/s]  PktRate[Mpkt/s]
        1024    71572224  29314.66        28.627597
        2048    44694272  36613.15        17.877517
        4096    21218304  34763.74        16.974481
        8192    11737856  38461.53        18.780044
       16384     6154752  40333.92        19.694297
       32768     3153664  41334.64        20.182929
       65536     1571328  40550.70        19.800147
---------------------------------------------------
```

## `cxi_read_bw`

The `cxi_read_bw` utility measures one-sided RDMA read bandwidth. When using
system memory, it can be configured to use huge pages.

**Usage**

```screen
Usage:
  cxi_read_bw [-d DEV] [-p PORT]
                         Start a server and wait for connection
  cxi_read_bw ADDR [OPTIONS]
                         Connect to server with address ADDR

Options:
  -d, --device=DEV       Device name (default: "cxi0")
  -v, --svc-id=SVC_ID    Service ID (default: 1)
  -p, --port=PORT        The port to listen on/connect to (default: 49194)
  -t, --tx-gpu=GPU       GPU index for allocating TX buf (default: no GPU)
  -r, --rx-gpu=GPU       GPU index for allocating RX buf (default: no GPU)
  -g, --gpu-type=TYPE    GPU type (AMD or NVIDIA or INTEL) (default type determined
                         by discovered GPU files on system)
  -n, --iters=ITERS      Number of iterations to run (default: 1000)
  -D, --duration=SEC     Run for the specified number of seconds
  -s, --size=MIN[:MAX]   Read size or range to use (default: 65536)
                         Ranges must be powers of 2 (e.g. "1:8192")
                         The maximum size is 4294967295
  -l, --list-size=SIZE   Number of reads per iteration, all pushed to
                         the Tx CQ prior to initiating xfer (default: 256)
  -b, --bidirectional    Measure bidirectional bandwidth
      --unrestricted     Use unrestricted reads
      --buf-sz=SIZE      The max TX/RDMA buffer size, specified in bytes
                         If (size * list_size) > buf_sz, reads will overlap
                         (default: 4294967296)
      --buf_align=ALIGN  Byte-alignment of reads in the buffer (default: 64)
      --use-hp=SIZE      Attempt to use huge pages when allocating
                         Size may be "2M" or "1G"
  -h, --help             Print this help text and exit
  -V, --version          Print the version and exit
```

**Example**

This example shows a quick run using the default options.

*Server*

```screen
$ cxi_read_bw
Listening on port 49194 for client to connect...
---------------------------------------------------
    CXI RDMA Read Bandwidth Test
Device           : cxi0
Service ID       : 1
Client TX Mem    : System
Server RX Mem    : System
Test Type        : Iteration
Iterations       : 1000
Read Size        : 65536
List Size        : 256
Bidirectional    : Disabled
Max RDMA Buf     : 4294967296 (16777216 used)
RDMA Buf Align   : 64
Hugepages        : Disabled
Local (server)   : NIC 0x12 PID 0 VNI 10
Remote (client)  : NIC 0x13 PID 0
---------------------------------------------------
RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
       65536           -  21479.54        10.488056
---------------------------------------------------
```

*Client*

```screen
$ cxi_read_bw nid000018
---------------------------------------------------
    CXI RDMA Read Bandwidth Test
Device           : cxi0
Service ID       : 1
Client TX Mem    : System
Server RX Mem    : System
Test Type        : Iteration
Iterations       : 1000
Read Size        : 65536
List Size        : 256
Bidirectional    : Disabled
Max RDMA Buf     : 4294967296 (16777216 used)
RDMA Buf Align   : 64
Hugepages        : Disabled
Local (client)   : NIC 0x13 PID 0 VNI 10
Remote (server)  : NIC 0x12 PID 0
---------------------------------------------------
RDMA Size[B]       Reads  BW[MB/s]  PktRate[Mpkt/s]
       65536      256000  21479.54        10.488056
---------------------------------------------------
```

## `cxi_send_bw`

The `cxi_send_bw` utility measures two-sided message bandwidth. It can be
configured to use eager or rendezvous transactions. When using system memory, it
can be configured to use huge pages.

**Usage**

```screen
Usage:
  cxi_send_bw [-d DEV] [-p PORT]
                         Start a server and wait for connection
  cxi_send_bw ADDR [OPTIONS]
                         Connect to server with address ADDR

Options:
  -d, --device=DEV       Device name (default: "cxi0")
  -v, --svc-id=SVC_ID    Service ID (default: 1)
  -p, --port=PORT        The port to listen on/connect to (default: 49194)
  -t, --tx-gpu=GPU       GPU index for allocating TX buf (default: no GPU)
  -r, --rx-gpu=GPU       GPU index for allocating RX buf (default: no GPU)
  -g, --gpu-type=TYPE    GPU type (AMD or NVIDIA or INTEL) (default type determined
                         by discovered GPU files on system)
  -n, --iters=ITERS      Number of iterations to run (default: 1000)
  -D, --duration=SEC     Run for the specified number of seconds
  -s, --size=MIN[:MAX]   Send size or range to use (default: 65536)
                         Ranges must be powers of 2 (e.g. "1:8192")
                         The maximum size is 4294967295
  -l, --list-size=SIZE   Number of sends per iteration, all pushed to
                         the Tx CQ prior to initiating xfer (default: 256)
  -b, --bidirectional    Measure bidirectional bandwidth
  -R, --rdzv             Use rendezvous PUTs
      --no-idc           Do not use Immediate Data Cmds for sizes <= 192 bytes
      --buf-sz=SIZE      The max TX/RDMA buffer size, specified in bytes
                         If (size * list_size) > buf_sz, sends will overlap
                         (default: 4294967296)
      --buf-align=ALIGN  Byte-alignment of sends in the buffer (default: 64)
      --use-hp=SIZE      Attempt to use huge pages when allocating
                         Size may be "2M" or "1G"
  -h, --help             Print this help text and exit
  -V, --version          Print the version and exit
```

**Example**

This example shows a quick run using the default options.

*Server*

```screen
$ cxi_send_bw
Listening on port 49194 for client to connect...
---------------------------------------------------
    CXI RDMA Send Bandwidth Test
Device           : cxi0
Service ID       : 1
Client TX Mem    : System
Server RX Mem    : System
Test Type        : Iteration
Iterations       : 1000
Send Size        : 65536
List Size        : 256
IDC              : Enabled
Bidirectional    : Disabled
Max RDMA Buf     : 4294967296 (16777216 used)
RDMA Buf Align   : 64
Hugepages        : Disabled
Local (server)   : NIC 0x12 PID 0 VNI 10
Remote (client)  : NIC 0x13 PID 0
---------------------------------------------------
Send Size[B]       Sends  BW[MB/s]  PktRate[Mpkt/s]
       65536           -  23772.52        11.607674
---------------------------------------------------
```

*Client*

```screen
$ cxi_send_bw 192.168.1.1
---------------------------------------------------
    CXI RDMA Send Bandwidth Test
Device           : cxi0
Service ID       : 1
Client TX Mem    : System
Server RX Mem    : System
Test Type        : Iteration
Iterations       : 1000
Send Size        : 65536
List Size        : 256
IDC              : Enabled
Bidirectional    : Disabled
Max RDMA Buf     : 4294967296 (16777216 used)
RDMA Buf Align   : 64
Hugepages        : Disabled
Local (client)   : NIC 0x13 PID 0 VNI 10
Remote (server)  : NIC 0x12 PID 0
---------------------------------------------------
Send Size[B]       Sends  BW[MB/s]  PktRate[Mpkt/s]
       65536      256000  23772.52        11.607674
---------------------------------------------------
```

## `cxi_atomic_bw`

The `cxi_atomic_bw` utility measures one-sided AMO bandwidth. It can be configured
to use a specific atomic operation and data type. Where possible, target buffer
writes are ensured to occur with every AMO. The utility works with or without
CPU offload, but enabling that feature in the NIC is left to the user.

**Usage**

```screen
Usage:
  cxi_atomic_bw [-d DEV] [-p PORT]
                         Start a server and wait for connection
  cxi_atomic_bw ADDR [OPTIONS]
                         Connect to server with address ADDR

Options:
  -d, --device=DEV       Device name (default: "cxi0")
  -v, --svc-id=SVC_ID    Service ID (default: 1)
  -p, --port=PORT        The port to listen on/connect to (default: 49194)
  -n, --iters=ITERS      Number of iterations to run (default: 10000)
  -D, --duration=SEC     Run for the specified number of seconds
                         Ranges must be powers of 2 (e.g. "1:8192")
                         The maximum size is 4294967295
  -l, --list-size=SIZE   Number of writes per iteration, all pushed to the
                         initiator CQ prior to initiating xfer (default: 4096)
  -A, --atomic-op        The atomic operation to use (default: SUM)
  -C, --cswap-op         The CSWAP operation to use (default: EQ)
  -T, --atomic-type      The atomic type to use (default: UINT64)
  -b, --bidirectional    Measure bidirectional bandwidth
      --fetching         Use fetching AMOs
      --matching         Use matching list entries at the target
      --unrestricted     Use unrestricted AMOs
      --no-hrp           Do not use High Rate Puts
      --no-idc           Do not use Immediate Data Cmds
  -h, --help             Print this help text and exit
  -V, --version          Print the version and exit

Atomic Ops:
  MIN, MAX, SUM, LOR, LAND, BOR, BAND, LXOR, BXOR, SWAP, CSWAP, AXOR
CSWAP Ops:
  EQ, NE, LE, LT, GE, GT
Atomic Types:
  INT8, UINT8, INT16, UINT16, INT32, UINT32, INT64, UINT64, FLOAT, DOUBLE,
  FLOAT_COMPLEX, DOUBLE_COMPLEX, UINT128
```

**Example**

This example shows a two-second bidirectional run using the CSWAP EQ operation
with uint128 data.

*Server*

```screen
$ cxi_atomic_bw -p 42000
Listening on port 42000 for client to connect...
------------------------------------------------
    CXI Atomic Memory Operation Bandwidth Test
Device           : cxi0
Service ID       : 1
Test Type        : Duration
Duration         : 2 seconds
Atomic Op        : NON-FETCHING CSWAP EQ
Atomic Type      : UINT128
List Size        : 4096
HRP              : Enabled
IDC              : Enabled
Matching LEs     : Disabled
Restricted       : Enabled
Bidirectional    : Enabled
Local (server)   : NIC 0x12 PID 0 VNI 10
Remote (client)  : NIC 0x13 PID 0
------------------------------------------------
AMO Size[B]         Ops  BW[MB/s]    OpRate[M/s]
         16    67584000   1081.16      67.572741
------------------------------------------------
```

*Client*

```screen
$ cxi_atomic_bw cxi-nid0 -p 42000 -A cswap -C eq -T uint128 -D 2 -b
------------------------------------------------
    CXI Atomic Memory Operation Bandwidth Test
Device           : cxi0
Service ID       : 1
Test Type        : Duration
Duration         : 2 seconds
Atomic Op        : NON-FETCHING CSWAP EQ
Atomic Type      : UINT128
List Size        : 4096
HRP              : Enabled
IDC              : Enabled
Matching LEs     : Disabled
Restricted       : Enabled
Bidirectional    : Enabled
Local (client)   : NIC 0x13 PID 0 VNI 10
Remote (server)  : NIC 0x12 PID 0
------------------------------------------------
AMO Size[B]         Ops  BW[MB/s]    OpRate[M/s]
         16    67575808   1081.16      67.572741
------------------------------------------------
```

## `cxi_gpu_bw_loopback`

The `cxi_gpu_bw_loopback` utility measures one-sided RDMA write bandwidth. When
using system memory, it can be configured to use huge pages.

**Usage**

```screen
Usage:
  cxi_loopback_bw [OPTIONS]

Options:
  -d, --device=DEV       200Gbps NIC device (default: "cxi0")
  -v, --svc-id=SVC_ID    Service ID (default: 1)
  -t, --tx-gpu=GPU       GPU index for allocating TX buf (default: no GPU)
  -r, --rx-gpu=GPU       GPU index for allocating RX buf (default: no GPU)
  -g, --gpu-type=TYPE    GPU type (AMD or NVIDIA or INTEL). Default type determined by
                         discovered GPU files on system.
  -D, --duration=SEC     Run for the specified number of seconds
  -i, --iters=ITERS      Number of iterations to run if duration not
                         specified (default: 25)
  -n, --num-xfers=XFERS  Number of transfers per iteration, all pushed to
                         the Tx CQ prior to initiating xfer (default: 8192)
  -s, --size=SIZE        Transfer Size in Bytes (default: 524288)
                         The maximum size is 4294967295 bytes
  --use-hp=SIZE          Attempt to use huge pages when allocating
                         Size may be "2M" or "1G"
                         system memory
  -h, --help             Print this help text and exit
  -V, --version          Print the version and exit
```

**Example**

This example shows a run using GPU memory for both the initiator and target
buffers.

```screen
$ cxi_gpu_loopback_bw -D 10 -s 131072 --tx-gpu 0 --rx-gpu 2
---------------------------------------------------
    CXI Loopback Bandwidth Test
Device           : cxi0
Service ID       : 1
TX Mem           : GPU 0
RX Mem           : GPU 2
GPU Type         : AMD
Test Type        : Duration
Duration         : 10 seconds
Write Size (B)   : 131072
Cmds per iter    : 8192
Hugepages        : Disabled
Found 4 GPU(s)
---------------------------------------------------
RDMA Size[B]      Writes  BW[Gb/s]  PktRate[Mpkt/s]
      131072     1810432    189.49        11.565970
---------------------------------------------------
```
