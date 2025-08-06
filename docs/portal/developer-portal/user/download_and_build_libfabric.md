
# Download and build `libfabric`

Download, configure, and build the `libfabric` library from the open source repository.

This procedure provides guidance rather than a one-size-fits-all solution.
Users may need to experiment and adapt the steps based on their specific system and requirements.

## Prerequisites

Ensure that required dependencies are installed on the system, which include the following:

- `cray-libcxi` and `cray-libcxi-devel` packages.
- Any GPU-related packages needed, depending on the hardware in use.
- Other development packages (`-devel`) required for building `libfabric`.

## Install `libfabric`

1. Clone the `libfabric` repository from GitHub.

    ```screen
    git clone https://github.com/ofiwg/libfabric.git
    ```

2. Change into the top-level directory of the cloned `libfabric` repository.

    ```screen
    cd libfabric
    ```

3. Run the `autogen.sh` script.

   ```screen
   bash autogen.sh
   ```

4. Use the `configure` script to set up the build environment with appropriate options.
   The options you use may vary depending on the hardware and requirements. See `./configure --help` for more information.

   **Notes:**
   - Customers may choose to omit options that are not applicable to their environment, such as `--with-cuda`, `--with-rocr`, and related options.
   - Replace `--prefix=/some/network/file/system/location` with a valid directory path where the library will be installed for shared use across compute nodes.

    ```screen
    ./configure LDFLAGS=-Wl,--build-id --enable-only --enable-restricted-dl --enable-tcp --enable-udp --enable-rxm --enable-rxd --enable-hook_debug --enable-hook_hmem --enable-dmabuf_peer_mem --enable-shm --enable-cxi --with-cuda=/usr/local/cuda --enable-cuda-dlopen --enable-gdrcopy-dlopen --with-rocr=/opt/rocm --enable-rocr-dlopen --prefix=/some/network/file/system/location
    ```

5. Compile and install the library.

   Select the appropriate command for the environment in use:

   - For RHEL and SLES systems:

      ```screen
      make -j8 rpm
      ```

      Once the RPM packages are created, install them with the `rpm -ivh` command.

      ```screen
      rpm -ivh /path/to/generated/rpms/*.rpm
      ```

   - For other environments:

      ```screen
      make -j8
      ```

      Install the built library.

      ```screen
      make install
      ```
