# Install standalone nodes

Perform this procedure to install Slingshot Host Software (SHS) on standalone nodes running RHEL or SLES.
The examples in this procedure are for systems with HPE Slingshot CXI NICs.

Use the section that matches the host OS:

- [RHEL installation](#rhel-installation)
- [SLES installation](#sles-installation)

Continue with the [common post-boot HSN and AMA configuration](#common-post-boot-hsn-and-ama-configuration) steps after the initial installation.

## RHEL installation

1. Download the SHS tar file.
   The file name typically follows this pattern: `slingshot-host-software-<shs_version>-rhel-<rhel_version>_<OS Architecture>.tar.gz`.

    For example, use the `slingshot-host-software-13.0.0-1022-rhel-9.5_x86_64.tar.gz` tar file to install the SHS 13.0.0-1022 stack on a RHEL 9.5 host.

2. Extract the package.

    Replace the `<shs_version>`, `<rhel_version>`, and `<OS_architecture>` placeholders with the appropriate RHEL values.

   ```screen
   # Set a local repository path. /opt/shs-repos is suitable for standalone hosts.
   REPO_PATH=/opt/shs-repos
   # Specify the tarball's location
   TARBALL_PATH=./slingshot-host-software-<shs_version>-rhel-<rhel_version>_<OS_architecture>.tar.gz
   # Set the RHEL version (for example, rhel-9.5)
   RHEL_VERSION=rhel-<rhel_version>
   
   # Extract the tarball
   TARBALL_NAME=$(basename "$TARBALL_PATH")
   REPO_NAME=${TARBALL_NAME%.tar.gz}
   REPO_DIR=$REPO_PATH/$REPO_NAME
   mkdir -p "$REPO_DIR"
   tar -xzf "$TARBALL_PATH" -C "$REPO_DIR" --strip-components=5 \
       "$REPO_NAME/rpms/cassini/$RHEL_VERSION/ncn"
   ```

   This extracts the RPM repository and its `repodata` directory directly into
   `$REPO_DIR`. Do not use a directory name ending in `.tar.gz`; that suffix
   identifies the archive, not the extracted repository.

3. Change directory to the repository directory.

    ```screen
    cd "$REPO_DIR"
    ```

4. Create an installation file with the required SHS RPMs for the host.

    Use the package list documented in the [Use individual RPMs](install_hpe_slingshot_cxi_nic_host_software.md#use-individual-rpms) section, and save it as `install_list.txt` before continuing.

5. Create a repo file in `/etc/yum.repos.d`.

    ```screen
    cat > /etc/yum.repos.d/slingshot.repo <<EOF
    [slingshot]
    name=Slingshot Host Software
    baseurl=file://${REPO_DIR}
    enabled=1
    gpgcheck=0
    EOF
    ```

    The `baseurl` must resolve to the directory that directly contains the
    RPMs and `repodata`; do not use the location of the original tarball.

6. Drain the node in Slurm.

7. Install the SHS RPMs.

    ```screen
    yum install $(cat install_list.txt)
    ```

8. Reboot the nodes.

9. After the node boots, continue with the [common post-boot HSN and AMA configuration](#common-post-boot-hsn-and-ama-configuration) steps.

## SLES installation

1. Download the SHS tar file.
   The file name typically follows this pattern: `slingshot-host-software-<shs_version>-sle15-sp<version>_<OS Architecture>.tar.gz`.

2. Extract the package.

    Replace the `<shs_version>`, `<version>`, and `<OS_architecture>` placeholders with the appropriate SLES values.

   ```screen
   REPO_PATH=/opt/shs-repos
   TARBALL_PATH=./slingshot-host-software-<shs_version>-sle15-sp<version>_<OS_architecture>.tar.gz
   TARBALL_NAME=$(basename "$TARBALL_PATH")
   REPO_NAME=${TARBALL_NAME%.tar.gz}
   REPO_DIR=$REPO_PATH/$REPO_NAME
   mkdir -p "$REPO_DIR"
   tar -xzf "$TARBALL_PATH" -C "$REPO_DIR" --strip-components=5 \
       "$REPO_NAME/rpms/cassini/sle15-sp<version>/ncn"
   ```

   This extracts the RPM repository and its `repodata` directory directly into
   `$REPO_DIR`. Do not use a directory name ending in `.tar.gz`; that suffix
   identifies the archive, not the extracted repository.

3. Change directory to the repository directory.

    ```screen
    cd "$REPO_DIR"
    ```

4. Create an installation file with the required SHS RPMs for the host.

    Use the package list documented in the [Use individual RPMs](install_hpe_slingshot_cxi_nic_host_software.md#use-individual-rpms) section, and save it as `install_list.txt` before continuing.

5. Create a repository file in `/etc/zypp/repos.d`.

    ```screen
    cat > /etc/zypp/repos.d/slingshot-local.repo <<EOF
    [slingshot-local]
    name=Slingshot Host Software
    baseurl=file://${REPO_DIR}
    enabled=1
    gpgcheck=0
    EOF
    ```

   The `baseurl` must resolve to the directory that directly contains the
   RPMs and `repodata`; do not use the location of the original tarball.

6. Drain the node in Slurm.

7. Install the SHS RPMs.

    ```screen
    sudo zypper refresh
    sudo zypper install -y $(cat install_list.txt)
    ```

8. Reboot the nodes.

9. After the node boots, continue with the [common post-boot HSN and AMA configuration](#common-post-boot-hsn-and-ama-configuration) steps.

## Common post-boot HSN and AMA configuration

1. After the node boots, check that the HSN or CXI Ethernet interfaces are available.

   ```screen
   ip a
   ```

   **SLES ONLY:** The CXI device may initially appear as a generic Ethernet interface such as `ethX` before the system configures the final HSN interface.
   Use the actual interface that the system reports for the LLDP and NetworkManager commands until the HSN interface is active.

2. Verify that `lldpad` is installed and running.

    The `slingshot-network-cfg-lldp` utility uses `lldpad` to obtain the
    configuration advertised by the fabric.

    ```screen
    rpm -q lldpad
    systemctl status lldpad
    ```

    If `rpm -q` does not find `lldpad` or `systemctl` shows that `lldpad` is inactive, install or start it before proceeding.

    ```screen
    sudo systemctl start lldpad
    sudo systemctl enable lldpad
    ```

3. Bring the CXI interface up and enable LLDP receive and transmit on the active device.

    ```screen
    sudo ip link set <iface> up
    sudo lldptool -i <iface> -L adminStatus=rxtx
    ```

    Replace `<iface>` with the interface that `ip a` or `ethtool -i <iface>` reports, such as `eth4` on SLES before the system assigns the final HSN interface name.

4. Identify the interfaces to configure.

   - On RHEL:

    ```screen
    HSN_INTERFACES=$(ip -br link | awk '$1 ~ /^hsn[0-9]+$/ {print $1}')
    ```

   - On SLES:

    **CAUTION:** Do not select every `ethX` interface because that may include management interfaces.
    Identify the CXI interface with `ip -br link`, then set the variable explicitly.
    Add additional CXI interfaces separated by spaces when needed.

    Replace `<ethX>` with the actual CXI interface name.

    ```screen
    ip -br link
    HSN_INTERFACES="<ethX>"
    ```

5. Configure LLDP for each selected interface.

   The first command enables LLDP transmit and receive on the interface. The second command writes the interface configuration generated from the HPE Slingshot LLDP TLV. The remaining commands reload and activate the generated configuration with NetworkManager.

    ```screen
    for interface in $HSN_INTERFACES; do
        lldptool set-lldp adminStatus=rxtx -i "$interface"
        /opt/slingshot/slingshot-network-config/default/bin/slingshot-network-cfg-lldp -cn "$interface"
        nmcli connection reload
        nmcli device connect "$interface"
    done
    ```

    If `slingshot-network-cfg-lldp` reports that the device is inactive or the
    Cray TLV is absent, confirm that the HSN interface exists, has carrier, and
    has LLDP enabled before continuing.

6. Verify AMA on the final HSN interfaces.

    ```screen
    ip a
    ip -br link
    for interface in $HSN_INTERFACES; do
        lldptool -t -i "$interface" -n
    done
    ```

7. Configure the HSN interface using NetworkManager (`nmcli`).

    If the host uses NetworkManager, create or update the connection profile for the final HSN interface after LLDP discovers the interface parameters.

    ```screen
    sudo nmcli connection add type ethernet ifname <iface> con-name hsn<index> ipv4.method manual ipv4.addresses <ip>/<prefix> 802-3-ethernet.mtu 9000
    sudo nmcli connection modify hsn<index> 802-3-ethernet.cloned-mac <lladdr>
    sudo nmcli connection up hsn<index>
    ```

    **SLES ONLY:** SLES hosts commonly require this sequence when they discover the physical interface before assigning the final HSN interface name. Use the values that `slingshot-network-cfg-lldp` reports for the IP address, MAC address, and MTU.

8. Enable the default CXI service on every CXI device present on the node.

    Do not assume a fixed number of CXI devices.
    List the devices first, then enable service 1 on each device the system returns.

    ```screen
    ls /dev/cxi*
    for device in /dev/cxi*; do
        cxi_service enable -s 1 -d "$(basename "$device")"
    done
    ```

9. Verify that the retry handler (RH) runs on every CXI device present on the node.

    Verify the service status before running CXI loopback.

    ```screen
    for device in /dev/cxi*; do
        systemctl status -q "cxi_rh@$(basename "$device").service"
    done
    ```

10. Run CXI loopback on every CXI device present on the node.

    ```screen
    for device in /dev/cxi*; do
        cxi_gpu_loopback_bw -d "$(basename "$device")"
    done
    ```

11. Repeat the relevant installation and configuration steps for other nodes or build an image and replicate.

12. After you update all the nodes, execute CXI tests and DgNettest to validate HPE Slingshot NICs.
