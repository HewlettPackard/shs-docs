
# Cannot reach server

The following error indicates that the client could not reach the remote host.
Check that the hostname or address supplied to the client is valid. Verify that
the client and server hosts can ping each other.

```screen
getaddrinfo() failed: Name or service not known
Failed to init control messaging: Input/output error
```

# No server running at remote host

The following error indicates that the client could reach the remote host but
found no server listening on the given TCP port (49194 by default). Verify that the
hostname or address is correct. Verify that the server is running and the server
and client are using the same value for the `--port` option.

**Note:** When launching a server and client from an automated process, it can be
helpful to add a short wait after launching the server before launching the
client.

```screen
Failed to connect to cxi-nid1: Connection refused
Failed to init control messaging: Connection refused
```

# TCP port already in use

The following error indicates that the server's given TCP port is already being
used. Often this means that another server is already running. If not, or if multiple
simultaneous servers are wanted, the `--port` option allows selecting a
different port.

```screen
bind() failed: Address already in use
Failed to init control messaging: Address already in use
```

# Incorrect program or version number

The following error indicates that different CXI diagnostics were used for
client and server.

```screen
Client and server program names do not match!
Failed to exchange client/server config: Invalid argument
```

This error indicates that the client and server program versions are
incompatible. Major and minor versions must match, while the revision number can be different.

```screen
Client and server program versions do not match!
cxi_write_bw: 1.3.0
Failed to exchange client/server config: Invalid argument
```

# Insufficient huge pages

The following error indicates that the `--use-hp` option was selected, but there
are not enough free huge pages available to allocate the transmit and target
buffers. Either increase the number of free huge pages, or reduce the buffer
space required by decreasing one or more of the values for the `--size`, `--list-size`, and `--buf-sz` options.

```screen
cxi_write_bw: Insufficient 2M huge pages. Need 8 to run
```

# Unexpected event type

The following errors occur when the client sends a packet and does not receive a
response.

*Server*

```screen
recv() failed: Connection reset by peer
Post-run handshake failed: Connection reset by peer
```

*Client*

```screen
Unexpected event type: ACK (9) Expected TRIGGERED_OP
event RC != RC_OK: CANCELED
Failed to get initiator ACK TRIGGERED_OP event: No message of desired type
```

When High rate puts (HRP) are used, the RC might instead be HRP_RSP_DISCARD.
This means that the packet made it as far as the switch.

```screen
Unexpected event type: ACK (9) Expected TRIGGERED_OP
event RC != RC_OK: HRP_RSP_DISCARD
Failed to get initiator ACK TRIGGERED_OP event: No message of desired type
```

If the RC is PKTBUF_ERROR, the node logs must be checked for pfc_fifo_oflw
errors. This means the switch QoS configuration has not been applied correctly.

```screen
Unexpected event type: ACK (9) Expected TRIGGERED_OP
event RC != RC_OK: PKTBUF_ERROR
Failed to get initiator ACK TRIGGERED_OP event: No message of desired type
```

```screen
[ 1451.997298] cxi_core 0000:21:00.0: HNI error: pfc_fifo_oflw (40)
[ 1452.002035] cxi_core 0000:21:00.0:   pfc_fifo_oflw_cntr: 218
[ 1452.005821] cxi_core 0000:21:00.0: IXE error: pbuf_rd_err (48)
[ 1452.009456] cxi_core 0000:21:00.0:   pbuf_rd_errors: 105
```

These errors indicate that the link is not up or something is incorrectly configured.

- Verify the link state on both the NIC and the switch.
- Verify that the NIC's AMA has been applied and is correct.
- Verify that the switch routing configuration and QoS configuration have been applied and are correct.

# High rate puts and internal-loopack

A Slingshot switch acknowledges the high rate puts, not the target NIC, so
they do not work when the NIC is configured in internal-loopback mode. The
`--no-hrp` option can be used to disable high rate puts.

# GPU libraries

When using GPU buffers, the diagnostics attempt to dynamically link the
appropriate runtime library, HIP for AMD or CUDA for NVIDIA or Level-zero for INTEL.
If the library has not been installed, the following error occurs:

```screen
Get device count request failed
Failed to init GPU lib: Operation not permitted
```

If both HIP and CUDA libraries are installed and NVIDIA GPUs are being used, HIP is used
by default. This error indicates that the HIP library has not been compiled for NVIDIA. Add `-g` NVIDIA to the command to change to the CUDA library.

## Low bandwidth

In general, the bandwidth utilities and `cxi_heatsink_check` are expected to reach full
bandwidth using their default options. However, there are cases where this may
not be true. The following may result in improved performance:

- Pin processes to specific cores. This can be done to avoid core 0 and to
assign the server and client to separate cores. When using a multisocket node,
it is important to use the socket nearest to the NIC under test. `cxi_heatsink_check`
attempts to intelligently set core affinities, but this can be overridden with
the `--cpu-list` option.
- Use larger values for `--size`.
- Use larger or smaller values for `--list-size` (called `--num-xfers` in
`cxi_gpu_bw_loopback`). This option specifies the number of transactions that are
queued up before telling the NIC to proceed.
- Use larger or smaller values for `--procs` with `cxi_heatsink_check`. This
option specifies the number of write-generating processes that are created.
- Use GPU memory for one or both of the TX and RX buffers.

## List entry exhaustion

The 200Gbps NIC has four processing engines, each of which has access to 16,384
list entries. When `cxi_heatsink_check` is run with the `--no-ple` option, every
write is preceded by appending a single, use-once list entry to receive the
write. If both the number of processes and the list size are set to large
values, this can result in exceeding the available number of list entries.

```screen
event RC != RC_OK: NO_SPACE
Failed to get target LINK event: No message of desired type
```

If this error is seen, try reducing the list size with `--list-size` and the
number of processes with `--procs`, or try running without the `--no-ple`
option.

## Sync timeout

`cxi_heatsink_check` spawns multiple processes to generate stress traffic. It
synchronizes these processes when they begin generating traffic and again
when they stop.

```screen
proc0 wait failed: Connection timed out
```

This error message is accompanied by "sync failed" errors from each process. In
the absence of other errors, a sync timeout likely indicates that the values of
`--procs`, `--size`, and `--list-size` may be too large. The diagnostic
generally is not meant to be run with high values for all three of these
arguments. Each of them increases the amount of time needed to initialize the
write data buffers to random values, as well as the time needed for the traffic
generating processes to quiesce. Try lowering one or more of them.

## Semaphore file already exists

`cxi_heatsink_check` uses two semaphore files to synchronize processes. The semaphore files are
named based on the CXI device ID. For example, with cxi0 the files are
`/dev/shm/sem.cxi_heatsink_p_cxi0` and `/dev/shm/sem.cxi_heatsink_c_cxi0`.
If either of these exists, `cxi_heatsink_check` cannot run.

```screen
sem_open(/cxi_heatsink_p_cxi0): File exists
```

Before deleting the semaphore files, check to see if `cxi_heatsink_check` is
already running. Wait for any running processes to finish, or try to terminate
them:

```screen
pkill cxi_heatsink_check
```

A single SIGINT or SIGTERM signal is often enough to break the processes out of
their loops and cause them to clean up all 200Gbps NIC resources that were allocated
through the driver. If they do not finish running within several seconds, they
can be killed with a second SIGTERM.

**Note**: Killing the processes with SIGKILL or a second SIGTERM may result in degraded 200Gbps NIC performance until the
next node reboot.

## Failed to allocate LNI: Key has been revoked

```screen
cxi_gpu_loopback_bw
---------------------------------------------------
    CXI Loopback Bandwidth Test
Device           : cxi0
Service ID       : 1
TX Mem           : System
RX Mem           : System
Test Type        : Iteration
Iterations       : 25
Write Size (B)   : 524288
Cmds per iter    : 8192
Hugepages        : Disabled
Failed to allocate LNI: Key has been revoked
```

The preceded output is an example of a diagnostic utility being unable to launch due to the default CXI service being disabled, and no other CXI service being passed in through the `-s` flag.

CXI Diagnostic tools need an enabled CXI Service to function properly. If the default CXI Service is (re)enabled, it will be utilized by diagnostic utilities automatically. If it is disabled, a separate CXI Service must be set up for each Node (and each NIC on the node).
See "HPE Slingshot 200G NIC security" in the *HPE Slingshot Administration Guide* for more information on CXI Services.
