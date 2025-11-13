# HPE Slingshot configuration with Mellanox NICs

Install and configure Mellanox NICs and related software to enable optimal performance of HPE Slingshot networks.

## Prerequisites for Mellanox-based system installation

1. Identify the target OS distribution and version for all compute targets in the cluster. Use this information to select the appropriate Mellanox OFED (MOFED) tar file for installation from the URL listed in the "Mellanox External Vendor Software" section of the _HPE Slingshot Host Software Release Notes (S-9010)_. The filename typically follows this pattern: `MLNX_OFED_LINUX-<version>-<OS distro>-<arch>.tgz`.

   **Note:** We provide MOFED RPMs for all COS-based operating systems. For other distributions, download the OFED RPMs directly from Mellanox. The versions we support and download links can be found in the "NIC Support" section of the _HPE Slingshot Host Software Release Notes (S-9010)_.

   For example, the `MLNX_OFED_LINUX-5.6-2.0.9.0-sles15sp4-x86_64.tgz` tar file would be used to install MOFED v5.6-2.0.9.0 stack on a SLES 15 SP4 x86_64 host or host OS image.

2. Download and unzip the MOFED tarball.

3. Install the Mellanox OFED distribution using the recommended version provided by the "Mellanox External Vendor Software" section of the _HPE Slingshot Host Software Release Notes (S-9010)_.

   - For installs: create a `/mellanox` directory in the `/opt/clmgr/repos/other/mellanox` directory and move the MOFED items there.

     ```screen
     root@host: ~# mkdir /opt/slingshot/firmware/mellanox
     root@host: ~# mv MOFED-<version> /opt/slingshot/firmware/mellanox
     ```

   - For upgrades: move the MOFED items directly to the existing `/opt/clmgr/repos/other/mellanox` directory.

     **Note:** If the customer requires UCX on the system, then install the HPC-X solution using the recommended version provided by the "Mellanox External Vendor Software" section of the _HPE Slingshot Host Software Release Notes (S-9010)_. Ensure that the HPC-X tarball matches the installed version of Mellanox OFED. In the HPC-x package, installation instructions are provided by Mellanox.

## Mellanox software configuration

HPE Slingshot provides libfabric to accelerate HPC applications over an HPE Slingshot network.
The `libfabric` RPM provides the run-time libraries while the `libfabric-devel` RPM provides the compile-time headers and libraries for compiling user applications.

The libfabric `verbs` provider used on HPE Slingshot with Mellanox NICs requires that users can 'lock' as much memory as necessary. This can be controlled through a workload manager, and also through local host configuration. The `slingshot-network-config` RPM provides an example limits configuration file:

`/opt/slingshot/slingshot-network-config/default/share/limits/99-slingshot-network.conf`

It is recommended to set the limit according to site-policy through the workload manager, or through the host's limit configuration file. It is recommended to set the value of the memory that can be locked to 'unlimited' to prevent application run-time errors when the soft or hard limit on locked pages is exceeded.

Other settings relating to performance or functionality are provided in the example `sysctl` configuration file:

`/opt/slingshot/slingshot-network-config/default/share/sysctl/99-slingshot-network.conf`

See the Examples section, 'Host `sysctl` configuration', for details about the suggested `sysctl` values and the rationale behind the settings.

The following is an example of how to integrate these settings into the host OS, or host OS image.

1. Create a link from the example `sysctl` configuration to the local host's `/usr/lib/sysctl.d` site customizations directory:

    ```screen
    root@host ~# ln -s \
      /opt/slingshot/slingshot-network-config/default/share/sysctl/99-slingshot-network.conf \
      /usr/lib/sysctl.d/99-slingshot-network.conf
    ```

2. Create a link from the example security configuration to the local host's security configuration directory:

    ```screen
    root@host ~# ln -s \
      /opt/slingshot/slingshot-network-config/default/share/limits/99-slingshot-network.conf \
      /etc/security/limits.d/99-slingshot-network.conf
    ```

## Tunable `libfabric` parameters for Mellanox

Specific tunable parameters should be changed when operating HPC applications at scale with `libfabric`.

To avoid connection establishment stalls on Mellanox hardware when running applications at large scale, it is recommended to increase the `recv_queue_size` parameter for the `ib_core` to `8192`.
The recommended setting is provided in the example file:

`/opt/slingshot/slingshot-network-config/default/share/modprobe/99-slingshot-network.conf`

If the network adapter must be initialized early during dracut for NFS mounts, it is required to integrate this change to the initrd in dracut for the module parameter change.

The following is an example of how to integrate these settings into the host OS, or host OS image.

1. Create a link in the modprobe directory to the example module configuration file.

    ```screen
    root@host ~# ln -s \
      /opt/slingshot/slingshot-network-config/default/share/modprobe/99-slingshot-network.conf \
      /etc/modprobe.d/99-slingshot-network.conf
    ```

2. Create a link in dracut to the example modprobe module file.

    ```screen
    root@host ~# ln -s \
      /opt/slingshot/slingshot-network-config/default/share/dracut/99-slingshot-network-modprobe \
      /usr/lib/dracut/modules.d/99slingshot-network-modprobe
    ```

3. Rebuild the initrd with the udev module to support use cases requiring NFS mounts on boot.

    ```screen
    root@host ~# dracut --add slingshot-network-modprobe --verbose --rebuild /boot/initrd
    ```

If the resulting initrd is used for booting the host over the network, such as with a pxeboot, then the resultant initrd from the final step in the example should be used to boot the new image with.
