# Build container images for HPE Slingshot

Build a container image whose `libfabric` and CXI provider run on HPE Slingshot hosts without installing HPE Slingshot Host Software (SHS) packages or using HPE Slingshot hardware in the build.

The procedure applies to libraries built from the SHS 15.0 sources.
For building `libfabric` directly on a host that has the SHS packages installed, see [Download and build `libfabric`](download_and_build_libfabric.md).

## How the libraries fit together in a container

A container that uses the HPE Slingshot network contains `libfabric` with its CXI provider inside the image, built against the application, MPI, and collective libraries that use it.
The CXI provider calls the HPE Slingshot user-space library, `libcxi.so.1`, which issues the commands to the host's CXI kernel driver.

With SHS 15.0 the image does not have to match the SHS release installed on the host.
Both image models described in this topic are designed to run on hosts from SHS 12.0 through SHS 15.0; see [Which combinations work](#build-container-images-for-hpe-slingshot/which-combinations-work) for the conditions.
The `libfabric` CXI provider in the SHS 15.0 sources, and in the upstream `libfabric` `main` and `v2.7.x` branches after the 2.7.0 release, resolves the newer `libcxi` functions at run time and uses the earlier method on kernel drivers that predate a command.
The SHS 15.0 kernel driver accepts the commands and structure layouts of the earlier releases. Compatibility expectations are summarized in [Which combinations work](#build-container-images-for-hpe-slingshot/which-combinations-work).

**Note:** The upstream `libfabric` 2.7.0 release does not contain these provider changes; a `libfabric` built from the 2.7.0 release or an earlier release keeps the behavior it was built with.
Build from the SHS 15.0 `libfabric` sources, or from upstream `main` or `v2.7.x` at a revision that contains the changes.

## Choose where `libcxi.so.1` comes from

The image obtains `libcxi.so.1` in one of two ways.
Compatibility expectations for both are summarized in [Which combinations work](#build-container-images-for-hpe-slingshot/which-combinations-work).

- **Host library mounted at run time.**
  
  The image is built against a link-only `libcxi.so.1` stub from the `libcxi` sources (`./configure --enable-stub-only`), which provides `libcxi.h`, `libcxi.pc`, and a `libcxi.so.1` that exports the API but implements nothing.
  When the container starts, the container runtime bind-mounts the host's `libcxi.so.1` over the stub, much as a CUDA container receives `libcuda.so` from the host. The library in use always matches the host's kernel driver because both come from the host.
  
  If the host library is not mounted, the stub prints a diagnostic naming the function that was called and aborts, so the misconfiguration is obvious.
  This model requires a container runtime that bind-mounts the host library (see the *HPE Slingshot Host Software Administration Guide*) and an image that satisfies the mounted library's own dependencies (see [Requirements for a mounted host library](#build-container-images-for-hpe-slingshot/requirements-for-a-mounted-host-library)).

- **Library built into the image.**
  
  The image builds `libcxi.so.1` from the SHS 15.0 `libcxi` sources against its own C library. A `libcxi` built from the SHS 15.0 sources works with the kernel drivers of SHS 12.0 through 15.0.
  Nothing from the host's user space is mounted; the image shares only the kernel's interfaces with the host: the device nodes, the `sysfs` paths, and the driver commands.
  Choose this model when the runtime cannot bind-mount a host file, when site policy does not allow host binaries in a container, or when the image's C library is older than the host library requires.
  
  Do not copy the host's `libcxi.so.1` into the image instead of building it; a copied host binary keeps the host's dependencies.

In both models the image needs `libnl-3` (the `libnl-3-200` package on Debian-based distributions, `libnl3` on RHEL and SLES), which `libcxi.so.1` is linked against.

## Build the libraries from public sources

The SHS libraries are mirrored in public repositories under <https://github.com/HewlettPackard>.
The following steps build them in an image build (for example, a `Dockerfile` `RUN` step); no SHS package, kernel module, or HPE Slingshot NIC is needed.
Use the `release/shs-15.0` branch of all four repositories; earlier branches do not have the stub build or the provider changes this procedure relies on.
Replace `/opt/slingshot` with the installation prefix for the image.

1. Install the build dependencies with the distribution's package manager:

    - **All builds:** a C compiler, `autoconf`, `automake`, `libtool`, `pkg-config`, and `python3`. The stub build of `libcxi` needs nothing else.
    - **Full `libcxi` build only:** development packages for `libnl-3`, `libconfig`, `libuv`, `libyaml`, `numactl`, `fuse`, and `lm_sensors` (on Ubuntu: `libnl-3-dev libconfig-dev libuv1-dev libyaml-dev libnuma-dev libfuse-dev libsensors-dev`).
    - **`libfabric`:** development packages for `json-c` and `libcurl` (on Ubuntu: `libjson-c-dev libcurl4-openssl-dev`).

2. Clone the sources.

    ```screen
    git clone --depth 1 --branch release/shs-15.0 https://github.com/HewlettPackard/shs-cassini-headers.git
    git clone --depth 1 --branch release/shs-15.0 https://github.com/HewlettPackard/shs-cxi-driver.git
    git clone --depth 1 --branch release/shs-15.0 https://github.com/HewlettPackard/shs-libcxi.git
    git clone --depth 1 --branch release/shs-15.0 https://github.com/HewlettPackard/shs-libfabric.git
    ```

    The `shs-cxi-driver` repository supplies only header files here; the kernel module is not built.

3. Install the headers that `libcxi` and the CXI provider compile against. The full `libcxi` build also reads the register definitions from `/usr/share/cassini-headers`.

    ```screen
    mkdir -p /opt/slingshot
    cp -r shs-cassini-headers/include /opt/slingshot
    cp -r shs-cxi-driver/include /opt/slingshot
    cp -r shs-cassini-headers/share/cassini-headers /usr/share
    ```

4. Build `libcxi`.

   Both of the following builds install `include/libcxi/libcxi.h`, `lib/pkgconfig/libcxi.pc`, and `lib/libcxi.so.1` under the prefix.

   - For the **host-library model**, build only the stub:

        ```screen
        cd shs-libcxi
        ./autogen.sh
        ./configure --enable-stub-only --prefix=/opt/slingshot CPPFLAGS="-I/opt/slingshot/include"
        make
        make install
        cd ..
        ```

   - For the **library-built-into-the-image model**, omit `--enable-stub-only` to build the full library.

5. Build `libfabric` with the CXI provider against the installed `libcxi`.

    ```screen
    cd shs-libfabric
    ./autogen.sh
    ./configure --prefix=/opt/slingshot --enable-cxi=/opt/slingshot --with-cassini-headers=/opt/slingshot --with-cxi-uapi-headers=/opt/slingshot
    make -j"$(nproc)"
    make install
    cd ..
    ```

    Add the GPU options that the image needs, for example `--with-cuda=/usr/local/cuda --enable-cuda-dlopen --enable-gdrcopy-dlopen` or `--with-rocr=/opt/rocm --enable-rocr-dlopen`, and enable the other providers the applications use. See `./configure --help` for the full list.

6. Build the MPI library, the network plugin of the collective communication library, and the applications against `/opt/slingshot/lib/libfabric.so`, and make sure `/opt/slingshot/lib` is on the image's library search path at run time.

    A `libfabric` built this way requires only `libcxi` symbol versions that every host library from SHS 12.0 on provides, so it loads against the mounted library of any of those hosts.
    To confirm, list the `LIBCXI_` version nodes the built library requires:

    ```screen
    readelf -W -V /opt/slingshot/lib/libfabric.so.1 | grep -o 'LIBCXI_[0-9.]*' | sort -uV
    ```

    The highest node listed should be `LIBCXI_1.5` or lower.

## Requirements for a mounted host library

The host's `libcxi.so.1` is a binary built for the host's distribution.
When it is mounted into a container, the image must satisfy its run-time dependencies:

- `libnl-3`, as in both models.
- A C library that provides every `GLIBC_` symbol version the host library requires. Host libraries built on SLES 15 SP6 and SP7 for SHS 14.0.1 and earlier require `GLIBC_2.38`; an image based on Ubuntu 22.04 (`glibc` 2.35) cannot load them, while an image based on Ubuntu 24.04 (`glibc` 2.39) can. From SHS 15.0.0 the host library requires nothing newer than `GLIBC_2.27` on every supported distribution. To list what a particular host library requires (`/usr/lib64/libcxi.so.1` on RHEL and SLES hosts, `/usr/lib/libcxi.so.1` on Ubuntu hosts):

    ```screen
    readelf -W -V /usr/lib64/libcxi.so.1 | grep -o 'GLIBC_[0-9.]*' | sort -uV | tail -1
    ```

An image whose C library is too old for the host library should build `libcxi.so.1` into the image instead.

## Which combinations work

Each column is the SHS release installed on the host: its kernel driver, and its `libcxi.so.1` when that is mounted into the container.
In this table, a compatible combination is one in which the image libraries load and the host kernel driver accepts the commands they issue for CXI communication setup and operation. This assumes that the container runtime exposes `/dev/cxi*` and the required `sysfs` paths, and that the image supplies the dependencies of the `libcxi.so.1` it uses.
Where the host driver predates a command, the provider uses the earlier method.
Limits from the host's CXI service configuration, including which VNIs and resources a service grants, apply as they do for native jobs.

| Container image contents | SHS 12.0 | SHS 13.0 | SHS 13.1 | SHS 14.0 | SHS 15.0 |
|---|---|---|---|---|---|
| `libfabric` with the SHS 15.0 provider changes, built against the stub; **host `libcxi.so.1` mounted at run time** | Works | Works | Works | Works | Works |
| `libfabric` as above with **`libcxi.so.1` built into the image from the SHS 15.0 sources**; nothing mounted from the host | Works | Works | Works | Works | Works |
| Existing image from an earlier SHS release that already worked on its host | As before | As before | As before | As before | Works: the 15.0 driver accepts the earlier commands |

The table states the compatibility that the SHS 15.0 libraries and kernel driver are designed to provide. The SHS 15.0 kernel driver accepts the commands and structure layouts of the earlier releases, and the SHS 15.0 libraries use the earlier method on kernel drivers that predate a command.

An image whose `libfabric` predates the SHS 15.0 provider changes keeps the behavior it was built with; upgrading the host does not change logic built into an image.
The third row assumes the job's CXI service uses the default of one LNI per resource group.
On SHS 13.1 and later drivers, a service with more than one LNI per resource group, which the Slurm plugin configures when a job step has more CPUs than the node's NICs have free resource group IDs, requires a `libcxi` function introduced in SHS 13.1; an image whose `libcxi.so.1` predates SHS 13.1, or whose `libfabric` lacks the SHS 15.0 provider changes, cannot open its transmit queues on such a service and fails. Images built as described in this topic have both.

## Related information

- A container or virtual machine can also use an SR-IOV Virtual Function of the NIC instead of the Physical Function; the libraries in the image are the same. See "Configure SR-IOV for HPE Slingshot CXI NICs" in the *HPE Slingshot Host Software Administration Guide*.
- For what the container runtime must expose to the container, see "Provide the host CXI library and devices to containers" in the *HPE Slingshot Host Software Administration Guide*.
