# CXI Diagnostics and Utilities

## Overview

The 200Gbps NIC software stack includes the libcxi library, which provides a direct interface to the CXI driver. A set of diagnostics has been developed using this library. These can be used to measure performance and troubleshoot 200Gbps NIC issues without using `libfabric`.

The bandwidth and latency utilities can measure either loopback or point-to-point performance. They can be used to get a quick system-wide snapshot of NIC and link health, as well as highlight switch edge port configuration issues. When used point-to-point they can be helpful in isolating localized problems. Point-to-point runs may also discover switch fabric port configuration issues, though other tools like `dgnettest` are better suited for this purpose.

The `cray-libcxi-utils` RPM is included in the `slingshot-compute-cassini` tarball in the HPE Slingshot release package.

The `cray-libcxi-utils` package can be installed on both compute and non-compute nodes. Each program has a corresponding manpage, and there is a `cxi_diags(7)` page with a summary of the diagnostics and their features. Binaries are placed in `/usr/bin`, and manpages are placed in `/usr/share/man/man1` and `/usr/share/man/man7`.

## Minimum setup required

- The CXI drivers must be installed.
- The retry handler service must be running for each NIC (`cxi_rh@cxi0`, `cxi_rh@cxi1`, and so on).
- The links must have a valid Algorithmic MAC Address (AMA) configured.
- The client and server hosts must each have a network device with an IPv4 address, and they must be able to reach each other through these devices.

Nonprivileged users:

- When running as a nonprivileged user, it is expected that the system administrator has setup a CXI service for the user running the CXI diagnostics. CXI services can be listed using the `cxi_service` utility. The assigned service ID must be passed to the CXI diagnostic with the `--svc-id` option.
- For CXI diagnostics utilizing a GPU resource, the user must belong to the video group. The GPU devices in `/dev` must also belong to the video group.
- `cxi_heatsink_check` cannot be run as a nonprivileged user.

When using the internal loopback command-line option:

- The link must be configured in internal-loopback mode.

When running point-to-point (this includes using the same NIC for client and server, unless internal-loopback is used):

- The fabric switches must have routing and QoS configuration applied.
- The links must be up.

When using GPU buffers with `cxi_gpu_loopback_bw` or `cxi_heatsink_check`:

- The appropriate runtime library must be installed (HIP for AMD or NVIDIA, or CUDA for NVIDIA, or Level-zero for INTEL).

When using huge pages:

- Huge pages must be made available on the nodes.

## Running the diagnostics

A subset of the diagnostics are client/server tests that measure point-to-point or loopback bandwidth and latency. These can use any IP interface to bootstrap the high-speed network connection between the client and server. They share many common command-line arguments and print results in a similar format. The server accepts optional arguments to specify which CXI device to use and which TCP port to listen on for the client connection. The client must be supplied with the hostname or IPv4 address of the server, along with the port to connect to if the default value was not used with the server. The client must also be supplied with all desired run options, which it shares with the server after establishing a connection.

Only a single client/server pair is needed for most of the diagnostics. However, when measuring Atomic Memory Operation (AMO) bandwidth the RDMA write sizes are small enough that a single client/server pair cannot reach full bandwidth. It is possible to run multiple pairs simultaneously by providing a unique TCP port to each pair. If the run duration is sufficiently long, the measured bandwidths can be combined with minimal error due to offsets in the start and end times of each client/server pair.

There are several diagnostics that run as single programs. One, `cxi_stat`, provides CXI device information. The others, `cxi_gpu_bw_loopback`, and `cxi_heatsink_check`, generate network traffic but can only be configured to use the same NIC for both initiator and target.
