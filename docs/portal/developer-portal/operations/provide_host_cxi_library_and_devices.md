# Provide the host CXI library and devices to containers

Expose the HPE Slingshot NIC to containers, and supply the host's `libcxi.so.1` to container images that are built to use it.

For how the images themselves are built, see "Build container images for HPE Slingshot" in the *HPE Slingshot Host Software User Guide*.

## What every container needs

A container that uses the HPE Slingshot network contains its own `libfabric` with the CXI provider. Whichever way the image obtains `libcxi.so.1` (see [Mount the host library](#provide-the-host-cxi-library-and-devices-to-containers/mount-the-host-library)), the container runtime must expose the following from the host:

- The CXI device nodes, `/dev/cxi*`.

- The `sysfs` paths the libraries read:

  - `/sys/class/cxi_user/` for device discovery and properties.
  - `/sys/class/net/` to find the NIC's network interface and read its address and link state.
  - `/sys/class/cxi/` for telemetry counters when an application requests them.
  
  The device entries under these class directories are symlinks into `/sys/devices/`, and the device properties are read through them, so a runtime that exposes selected paths must also expose the symlink targets.
  Whether the runtime exposes all of `/sys` or only these paths and their targets is a runtime and site-policy choice.

- The CXI service and VNIs the job may use. These come from the workload manager's launcher exactly as for a native job; the container does not change which services exist or what they grant. The limits of the host's service configuration, including which VNIs and how many resources a service allows, apply inside the container as they do outside it.

A container that uses an SR-IOV Virtual Function instead of the Physical Function needs the same items for the VF's device; see [Configure SR-IOV for HPE Slingshot CXI NICs](sriov.md).

## Mount the host library

An image built against the `libcxi` link-only stub contains a `libcxi.so.1` that implements nothing.
At container start, bind-mount the host's `libcxi.so.1` (`/usr/lib64/libcxi.so.1` on RHEL and SLES hosts, `/usr/lib/libcxi.so.1` on Ubuntu hosts) over the stub's location in the image, so that the image's `libfabric` loads the host library.
The library in use then always matches the host's kernel driver, because both come from the host.

Mount only `libcxi.so.1`:

- Do not mount the host's `libfabric`. The image's MPI library, the network plugin of its collective communication library, and applications are built against the image's `libfabric` and record the symbol versions they need; an older host `libfabric` does not provide them, and the image's CXI provider is the one that contains the compatibility behavior for the host's driver.
- Do not mount `/usr` or other whole host directories to reach the library. Doing so places the host's other libraries ahead of the image's and can break an image whose C library is older than the host's.

If the stub is reached at run time because nothing was mounted over it, the process prints a diagnostic naming the `libcxi` function that was called and aborts.

The mounted library is a host binary and brings its own dependencies into the container: the image must contain `libnl-3` and a C library that provides every `GLIBC_` symbol version the host library requires.
Host libraries built for SLES 15 SP6 and SP7 for SHS 14.0.1 and earlier require `GLIBC_2.38`; from SHS 15.0.0 the host library requires nothing newer than `GLIBC_2.27`. Satisfying these is the image builder's responsibility; the requirement is described in the *HPE Slingshot Host Software User Guide*.
An image that cannot satisfy them builds `libcxi.so.1` into the image instead and needs no host library mounted.

## Upgrade the host

A container image that worked on a host is expected to keep working after the host is upgraded to SHS 15.0: the SHS 15.0 kernel driver accepts the commands and structure layouts of the earlier releases, and a mounted host library is upgraded with the host.

One case needs attention: on SHS 13.1 and later drivers, a CXI service with more than one LNI per resource group (the Slurm plugin configures this when a job step has more CPUs than the node's NICs have free resource group IDs) requires a `libcxi` function introduced in SHS 13.1.

An image that contains its own `libcxi.so.1` from before SHS 13.1, or whose `libfabric` predates the SHS 15.0 provider changes, fails to open its transmit queues on such a service.
Rebuilding the image's `libfabric` and `libcxi` from the SHS 15.0 sources, as described in the *HPE Slingshot Host Software User Guide*, resolves both.

## Related information

- "Build container images for HPE Slingshot" in the *HPE Slingshot Host Software User Guide*: the two image models, the build procedure, and which image and host combinations work.
- [Configure SR-IOV for HPE Slingshot CXI NICs](sriov.md): partitioning a NIC into Virtual Functions for containers and virtual machines.
- [CXI services](cxi_services.md) and [VNI overview](vni_overview.md): what a service grants and how VNIs are assigned.
