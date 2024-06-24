
# GPCNeT Benchmark

GPCNeT benchmark provides the following capabilities:

* Natural Ring Communication Pattern - all processors communicate with their neighbors simultaneously based on adjacent MPI ranks.
* Random Ring Communication Pattern - processors are paired with random nodes that do not live on a physical neighbor in the machine.
* Exercising the corners of spacial-temporal locality where spacial locality refers to the likelihood that adjacent memory addresses are referenced in a short period of time and temporal locality refers to the likelihood of a single memory address being referenced several times in a short period of time.

# OSU Benchmark

OSU Benchmark is a collection of MPI test suites that enable to collect key performance metrics (Bandwidth, Latency) for HPC Fabrics. They can operate on any of the standard MPI implementations.
OSU Micro-Benchmarks provide several different type of benchmarks that can be used to test and measure HPC network performance:

* Point-to-Point MPI Benchmarks: Latency, multi-threaded latency, multi-pair latency, multiple bandwidth / message rate test bandwidth, bidirectional bandwidth
* One-sided MPI Benchmarks: one-sided put latency, one-sided put bandwidth, one-sided put bidirectional bandwidth, one-sided get latency, one-sided get bandwidth, one-sided accumulate latency

# OpenMPI

The Open MPI Project is an open source Message Passing Interface implementation that is developed and maintained by a consortium of academic, research, and industry partners. Some of the features include compliance to Full MPI-3.1 standards conformance ,Thread safety and concurrency ,Dynamic process spawning

# Libfabrics

OpenFabrics Interfaces (OFI) is a framework focused on exporting fabric communication services to applications.
OFI is best described as a collection of libraries and applications used to export fabric services.
The key components of OFI are: application interfaces, provider libraries, kernel services, daemons, and test applications (https://ofiwg.github.io/libfabric/).
OFI is specifically designed to meet the performance and scalability requirements of high-performance computing (HPC) applications, such as MPI.
The key components of OFI are:

* application interfaces
*  provider libraries
*  kernel services
*  daemons and test applications

The rest of the section outlines different techniques that are adopted to troubleshoot performance mismatch between the expected and actual results.
It is important to understand the expected results of performance test based on the HSN configuration:

* Topology
* Number of Endpoints
* Switches
* Groups, and Switches per group,
* Local Links
* Single or dual NICs

# Perftest

perftest package is a collection of tests written over uverbs intended for use as a performance micro-benchmark.
The tests may be used for tuning as well as for functional testing (https://community.mellanox.com/s/article/perftest-package)

perftest package contains a set of bandwidth and latency benchmark for RoCE

ib\_send\_bw
ib\_send\_lat
ib\_write\_bw
ib\_write\_lat
ib\_read\_bw
ib\_read\_lat
ib\_atomic\_bw
ib\_atomic\_lat

## Enable Perftest Package

```screen
# yum install libmlx5 libmlx4 libibverbs libibumad librdmacm \
librdmacm-utils libibverbs-utils perftest infiniband-diags

lsmod | grep mlx
mlx5_ib               352256  0
ib_uverbs             143360  2 rdma_ucm,mlx5_ib
ib_core               393216  13 rdma_cm,ib_ipoib,rpcrdma,ib_srpt,ib_srp,iw_cm,ib_iser,
                                 ib_umad,ib_isert,rdma_ucm,ib_uverbs,mlx5_ib,ib_cm
mlx5_core            1150976  1 mlx5_ib
mlxfw                  28672  1 mlx5_core
pci_hyperv_intf        16384  1 mlx5_core
tls                   102400  1 mlx5_core

```

## Running Perftest Package

**Example 1:** Bandwidth tests between client and server with Ethernet as Data exchange method

```screen
On Server
# ib_send_bw -d mlx5_0 -i 1  -D 5 --report_gbits

This will initiate a server on port `1` (-i) on device mlx5_0 and for a duration of `5` (-D) seconds

On Client
# ib_send_bw -d mlx5_0 -i 1  -D 5 --report_gbits <hsn-ip-server>

This will initiate client connection to server

# ib_write_bw -i 1 -d mlx5_0 -F -D 5 --report_gbits

************************************
* Waiting for client to connect... *
************************************
---------------------------------------------------------------------------------------
                    RDMA_Write BW Test
 Dual-port       : OFF          Device         : mlx5_0
 Number of qps   : 1            Transport type : IB
 Connection type : RC           Using SRQ      : OFF
 CQ Moderation   : 1
 Mtu             : 4096[B]
 Link type       : Ethernet
 GID index       : 3
 Max inline data : 0[B]
 rdma_cm QPs     : OFF
 Data ex. method : Ethernet
---------------------------------------------------------------------------------------
 local address: LID 0000 QPN 0x0e1d PSN 0xd0b406 RKey 0x0d0238 VAddr 0x007fb11ab70000
 GID: 00:00:00:00:00:00:00:00:00:00:255:255:192:168:01:02
 remote address: LID 0000 QPN 0x0ddd PSN 0xec1a24 RKey 0x04c4bd VAddr 0x007f1e2f010000
 GID: 00:00:00:00:00:00:00:00:00:00:255:255:192:168:01:04
---------------------------------------------------------------------------------------
 #bytes     #iterations    BW peak[Gb/sec]    BW average[Gb/sec]   MsgRate[Mpps]
 65536      560960           0.00               98.03              0.186974
---------------------------------------------------------------------------------------


# ib_write_bw -i 1 -d mlx5_0 -F -D 5 --report_gbits <system_name>n002-hsn
---------------------------------------------------------------------------------------
                    RDMA_Write BW Test
 Dual-port       : OFF          Device         : mlx5_0
 Number of qps   : 1            Transport type : IB
 Connection type : RC           Using SRQ      : OFF
 TX depth        : 128
 CQ Moderation   : 1
 Mtu             : 4096[B]
 Link type       : Ethernet
 GID index       : 3
 Max inline data : 0[B]
 rdma_cm QPs     : OFF
 Data ex. method : Ethernet
---------------------------------------------------------------------------------------
 local address: LID 0000 QPN 0x0ddd PSN 0xec1a24 RKey 0x04c4bd VAddr 0x007f1e2f010000
 GID: 00:00:00:00:00:00:00:00:00:00:255:255:192:168:01:04
 remote address: LID 0000 QPN 0x0e1d PSN 0xd0b406 RKey 0x0d0238 VAddr 0x007fb11ab70000
 GID: 00:00:00:00:00:00:00:00:00:00:255:255:192:168:01:02
---------------------------------------------------------------------------------------
 #bytes     #iterations    BW peak[Gb/sec]    BW average[Gb/sec]   MsgRate[Mpps]
 65536      560960           0.00               98.03              0.186974
---------------------------------------------------------------------------------------
```

**Example 2**: Connect QPs with rdma\_cm and run test on those QPs

Option `R` can be used to validate rdma\_cm

```screen
# ib_write_bw -i 1 -d mlx5_0 -R -D 5 --report_gbits

************************************
* Waiting for client to connect... *
************************************
---------------------------------------------------------------------------------------
                    RDMA_Write BW Test
 Dual-port       : OFF          Device         : mlx5_0
 Number of qps   : 1            Transport type : IB
 Connection type : RC           Using SRQ      : OFF
 CQ Moderation   : 1
 Mtu             : 4096[B]
 Link type       : Ethernet
 GID index       : 3
 Max inline data : 0[B]
 rdma_cm QPs     : ON
 Data ex. method : rdma_cm
---------------------------------------------------------------------------------------
 Waiting for client rdma_cm QP to connect
 Run the same command with the IB/RoCE interface IP
---------------------------------------------------------------------------------------
 local address: LID 0000 QPN 0x0e1f PSN 0xe0cb8a
 GID: 00:00:00:00:00:00:00:00:00:00:255:255:192:168:01:02
 remote address: LID 0000 QPN 0x0de1 PSN 0xa84f9b
 GID: 00:00:00:00:00:00:00:00:00:00:255:255:192:168:01:04
---------------------------------------------------------------------------------------
 #bytes     #iterations    BW peak[Gb/sec]    BW average[Gb/sec]   MsgRate[Mpps]
 65536      560960           0.00               98.03              0.186977
---------------------------------------------------------------------------------------

# ib_write_bw -i 1 -d mlx5_0 -D 5 -R  --report_gbits <system_name>n002-hsn
---------------------------------------------------------------------------------------
                    RDMA_Write BW Test
 Dual-port       : OFF          Device         : mlx5_0
 Number of qps   : 1            Transport type : IB
 Connection type : RC           Using SRQ      : OFF
 TX depth        : 128
 CQ Moderation   : 1
 Mtu             : 4096[B]
 Link type       : Ethernet
 GID index       : 3
 Max inline data : 0[B]
 rdma_cm QPs     : ON
 Data ex. method : rdma_cm
---------------------------------------------------------------------------------------
 local address: LID 0000 QPN 0x0de1 PSN 0xa84f9b
 GID: 00:00:00:00:00:00:00:00:00:00:255:255:192:168:01:04
 remote address: LID 0000 QPN 0x0e1f PSN 0xe0cb8a
 GID: 00:00:00:00:00:00:00:00:00:00:255:255:192:168:01:02
---------------------------------------------------------------------------------------
 #bytes     #iterations    BW peak[Gb/sec]    BW average[Gb/sec]   MsgRate[Mpps]
 65536      560960           0.00               98.03              0.186977
---------------------------------------------------------------------------------------
```

## Perftest Results

Successful execution of the tests with a bandwidth `~98 Gb/sec` implies that the HSN link
between the client and server is functional.

Failure would imply one of the following

* Ports are not configured properly
* Edge ports are down
* AMA is not configured on the HSN NICs or slingshot switches
* HSN links between the nodes are down


These tests can be used to validate connection between Client and Storage nodes connected to Slingshot switch.
These tests are initial low level tests which can be run before running other high level tests like
OSU, MPI, DgNetTest.

## Scaling perftest

Perftest can be executed from UAN with access to compute nodes and with `pdsh` servers can be initiated
on compute nodes.
From one of the compute nodes , client connection can be initiated to the servers.

**Example**: Scaling perftest for a set of compute nodes

```bash

# Initiate servers
[UAN ~] pdsh -w <system_name>n[001-009]  ib_write_bw -i 1 -d mlx5_0 -D 5 -R  --report_gbit

# Initiate Client connection

<system_name>n010 ~]# for i in {1..9} ; do ib_write_bw -i 1 -d mlx5_0 -D 5 -R  --report_gbits <system_name>n00${i}-hsn ; done
```
