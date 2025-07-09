# Install standalone nodes (RHEL only)

Perform this procedure to install Slingshot Host Software (SHS) on standalone nodes running RHEL.
The examples in this procedure are for systems with HPE Slingshot CXI NICs.

1. Download the SHS tar file.
   The file name typically follows this pattern: `slingshot-host-software-<shs_version>-rhel-<rhel_version>_<OS Architecture>.tar.gz`.

   For example, the `slingshot-host-software-13.0.0-1022-rhel-9.5_x86_64.tar.gz` tar file is used to install the SHS 13.0.0-1022 stack on a RHEL 9.5 host.

2. Extract the package.

   Replace the `<shs_version>`, `<rhel_version>`, and `<OS_architecture>` placeholders with the appropriate values.

   ```screen
   # Set the path for the repository
   REPO_PATH=/opt/clmgr/repos/other
   # Specify the tarball's location
   TARBALL_PATH=./slingshot-host-software-<shs_version>-rhel-<rhel_version>_<OS_architecture>.tar.gz
   # Set the RHEL version (for example, rhel-9.5)
   RHEL_VERSION=rhel-<rhel_version>
   
   # Extract the tarball
   TARBALL_NAME=$(basename $TARBALL_PATH)
   mkdir -p $REPO_PATH/$TARBALL_NAME
   tar -xzf ${TARBALL_PATH} -C $REPO_PATH/$TARBALL_NAME --strip-components=5 ${TARBALL_NAME%.tar.gz}/rpms/cassini/${RHEL_VERSION}/ncn/
   ```

3. Change directory to the `rpms` directory.

    ```screen
    cd $REPO_PATH/$REPO_NAME
    ```

4. Create an installation file with the list of components to be installed.

    ```screen
    cat install_list.txt
    cray-hms-firmware
    kmod-cray-slingshot-base-link
    kmod-cray-cxi-driver
    cray-cxi-driver-udev
    cray-libcxi
    cray-libcxi-retry-handler
    cray-libcxi-utils
    libfabric
    libfabric-devel
    slingshot-network-config
    slingshot-firmware-management
    slingshot-firmware-cassini
    slingshot-firmware-cassini2
    ```

5. Create a repo file in `/etc/yum.repos.d`.

    ```screen
    cat slingshot.repo
    [slingshot-3.0.0-1022]
    name=slingshot-3.0.0-1022
    baseurl=file:///root/slingshot-host-software-13.0.0-1022-rhel-9.5/rpms/cassini/rhel-9.5/ncn
    enabled=1
    gpgcheck=0
    ```

6. Drain the node in Slurm.

7. Initiate the installation.

    ```screen
    yum install $(cat install_list.txt)
    ```

8. Reboot the nodes.

9. After node boots up, check that all high-speed network (HSN) interfaces have come up.

   ```screen
   ip a
   ```

10. Check if the `lldpad` agent service is running.

    ```screen
    systemctl status lldpad
    ```

    Example output:

    ```screen
    â— lldpad.service - Link Layer Discovery Protocol Agent Daemon.
    Loaded: loaded (/usr/lib/systemd/system/lldpad.service; disabled; vendor preset: disabled)
    Active: active (running) since Wed 2023-05-24 19:18:20 CEST; 21h ago
    Main PID: 47133 (lldpad)
        Tasks: 1 (limit: 3355442)
    Memory: 1004.0K
    CGroup: /system.slice/lldpad.service
            â””â”€47133 /usr/sbin/lldpad -t

    May 24 19:18:20 o186i237 systemd[1]: Started Link Layer Discovery Protocol Agent Daemon.
    ```

    Restart the `lldpad` agent service if it is not running.

    ```screen
    systemctl restart lldpad
    ```

11. Wait for a couple of minutes, then run the following service to configure the Algorithmic Mac Address (AMA) of the nodes.

    ```screen
    /opt/slingshot/slingshot-network-config/default/bin/slingshot-network-cfg-lldp
    ```

12. Ensure that AMA is set on all devices.

    ```screen
    ip a
    lldptool -t -i <hsn0> -n
    ```

13. Enable the Default CXI Service on all nodes.

    ```screen
    for i in {0..3}; do sudo cxi_service enable -s 1 -d cxi$i; done
    ```

14. Run CXI loopback on all devices.

    ```screen
    for i in {0..3}; do cxi_gpu_loopback_bw -d cxi$i; done
    ```

15. Repeat steps 1 through 14 for other nodes or build an image and replicate.

16. Once all the nodes are updated, execute CXI tests and DgNettest to validate HPE Slingshot NICs.
