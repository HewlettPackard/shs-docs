
## Configure Soft-RoCE

Remote direct memory access (RDMA) over Converged Ethernet (RoCE) is a network protocol that enables RDMA over an Ethernet network.
RoCE can be implemented both in the hardware and in the software.
Soft-RoCE is the software implementation of the RDMA transport. RoCE v2 is used for HPE Slingshot 200Gbps NICs.

### Soft-RoCE on HPE Slingshot 200Gbps NICs

#### Prerequisites

1. `cray-cxi-driver` RPM package must be installed.
2. `cray-rxe-driver` RPM package must be installed.
3. HPE Slingshot 200Gbps NIC Ethernet must be configured and active.

#### Configuration

The following configuration is on the node image, and modifying the node image varies depending on the system management solution being used (HPE Cray EX or HPCM).

Follow the relevant procedures to achieve the needed configuration. Contact a system administrator to set up these parameters.

1. Modify the following kernel module parameters to enable Soft-RoCE to run optimally with good performance.

   ```bash
   cxi-eth.large_pkts_buf_count=10000
   rdma_rxe.xmit_hard=y
   ```

2. If Lustre is being used, modify the client and server parameters.

   Skip this step if Lustre is not being used.
   See the [Lustre configuration](#lustre-network-driver-lnd-ko2iblnd-configuration) procedure for more details.

   The client and server parameters can be modified using one of the following methods:

   - Update the parameters on the client.

     These parameters may be provided as kernel boot extra command line parameters.
     The list is as follows:

     ```bash
     ko2iblnd.conns_per_peer=4
     ko2iblnd.concurrent_sends=84
     ko2iblnd.ntx=2048
     ko2iblnd.credits=1024
     ko2iblnd.peer_credits=42
     ```

   - Create a `/etc/modprobe.d/rxe.conf` file.

     Add the following contents to the file:

     ```bash
     options cxi-eth large_pkts_buf_count=10000
     options rdma_rxe xmit_hard=Y
     options ko2iblnd conns_per_peer=4 peer_credits=42 concurrent_sends=84 ntx=2048 credits=1024
     ```

     The file must be added to the compute node image for any nodes running Soft-RoCE.

3. Check if links are initialized and AMAs assigned.

4. Create an RXE (Soft-RoCE) device by running `rxe_init.sh [devices list]` as root.

   NOTE: At this time, HPE Slingshot 200Gbps NICs do not automatically create RXE devices, so it must be done manually.

   `[devices list]` is a list of interfaces to create RXE devices for.
   For example, running `rxe_init.sh hsn0 hsn1` will create rxe0 and rxe1.

   This script will create the `rxe0` device, and apply for the appropriate settings Soft-RoCE.
   If no devices list is provided, `rxe_init.sh` will use `hsn0` as the devices list.

5. Check if `xmit_hard` is `Y` in the RXE parameters on all nodes.

   The following example shows the check on one node, but this must be verified for all nodes.

   ```console
   node1# cat /sys/module/rdma_rxe/parameters/xmit_hard
   Y
   ```

   If `xmit_hard` is set to `N`, then see step 1 to fix the issue or contact a system administrator.

NOTE: Soft-RoCE device creation is not persistent across reboots.
The `rxe_init.sh` script must be run on every boot after the HPE Slingshot 200Gbps NIC Ethernet device is fully programmed with links up and AMAs assigned.

### Lustre Network Driver (LND) ko2iblnd configuration

The ko2iblnd.ko changes are needed for better Soft-RoCE performance on LNDs.

#### Compute Node tuning for Soft-RoCE

Tuning on compute node can be achieved in two ways. Follow the steps that work best for the system in use.

1. Change the kernel module parameters.

   Follow the [Soft-RoCE Configuration](#configuration) section to use kernel module parameter change.

2. Use `modprobe.d` to tune compute nodes for Soft-RoCE.

   1. On the admin node, create a file with the following command with the following line.

      ```bash
      vim ~/ko2iblnd.conf
      options ko2iblnd conns_per_peer=4 peer_credits=42 concurrent_sends=84 ntx=2048 credits=1024
      ```

   2. Copy this file from admin node to all compute nodes as root.

      ```bash
      pdcp -w <compute_nodes_list> ~/ko2iblnd.conf /etc/modprobe.d/ko2iblnd.conf
      ```

   3. Unload Lustre modules on all compute nodes.

      ```bash
      pdsh -w <compute_nodes_list> lustre_rmmod
      ```

   4. Reload Lustre modules on all compute nodes.

      ```bash
      pdsh -w <compute_nodes_list> modprobe lustre
      ```

   5. Check the ko2iblnd tunings are in place on all compute nodes.

      ```bash
      pdsh -w <compute_nodes_list> 'egrep "" /sys/module/ko2iblnd/parameters/*' | dshbak -c
      ```

      The output should be the same as the following:

      ```console
      /sys/module/ko2iblnd/parameters/cksum:0
      /sys/module/ko2iblnd/parameters/concurrent_sends:84
      /sys/module/ko2iblnd/parameters/conns_per_peer:4
      /sys/module/ko2iblnd/parameters/credits:84
      /sys/module/ko2iblnd/parameters/dev_failover:1
      /sys/module/ko2iblnd/parameters/fmr_cache:1
      /sys/module/ko2iblnd/parameters/fmr_flush_trigger:384
      /sys/module/ko2iblnd/parameters/fmr_pool_size:512
      /sys/module/ko2iblnd/parameters/ib_mtu:0
      /sys/module/ko2iblnd/parameters/ipif_name:ib0
      /sys/module/ko2iblnd/parameters/keepalive:100
      /sys/module/ko2iblnd/parameters/map_on_demand:1
      /sys/module/ko2iblnd/parameters/nscheds:0
      /sys/module/ko2iblnd/parameters/ntx:2048
      /sys/module/ko2iblnd/parameters/peer_buffer_credits:0
      /sys/module/ko2iblnd/parameters/peer_credits:42
      /sys/module/ko2iblnd/parameters/peer_credits_hiw:64
      /sys/module/ko2iblnd/parameters/peer_timeout:180
      /sys/module/ko2iblnd/parameters/require_privileged_port:0
      /sys/module/ko2iblnd/parameters/retry_count:5
      /sys/module/ko2iblnd/parameters/rnr_retry_count:6
      /sys/module/ko2iblnd/parameters/service:987
      /sys/module/ko2iblnd/parameters/timeout:10
      /sys/module/ko2iblnd/parameters/use_fastreg_gaps:0
      /sys/module/ko2iblnd/parameters/use_privileged_port:1
      /sys/module/ko2iblnd/parameters/wrq_sge:1
      ```

#### E1000 ko2iblnd tuning for Soft-RoCE

Configure clients to use Soft-RoCE and configure storage with MLX HCAs running HW RoCE.

NOTE: These changes will not persist on file system upgrade and should be reapplied.

1. Log in to the primary management server as admin user.

2. `sudo` as root on the primary management server.

   ```bash
   [admin@hpelus1n00 ~]$ sudo su -
   ```

3. Unmount the Lustre server targets.

   ```console
   root@hpelus1n00 ~]# cscli unmount
   ```

4. `ssh` into the nfsserv node (which is typically the n01 node).

   ```console
   [root@hpelus1n00 ~]# ssh nfsserv
   ```

5. Make a backup copy of the current running image.

   ```console
   [root@hpelus1n01 ~]# cp -a /mnt/nfsdata/images/$(nodeattr -UV ver) /mnt/nfsdata/images/$(nodeattr -UV ver).orig
   ```

6. Edit the `ko2iblnd.conf` file in the diskless image,
   commenting out every line that exists and ensuring the only uncommented line is the following:

   ```console
   [root@hpelus1n01 ~]# vim /mnt/nfsdata/images/$(nodeattr -UV ver)/appliance.x86_64/etc/modprobe.d/ko2iblnd.conf

   options ko2iblnd conns_per_peer=4 ntx=2048 peer_credits=42 peer_credits_hiw=64 concurrent_sends=256 credits=1024 map_on_demand=1
   ```

7. Recreate the SquashFS image after updating the `ko2iblnd.conf` file in the image.

   ```console
   [root@hpelus1n01 ~]# /opt/xyratex/bin/tools/create_squashfs.sh \
     /mnt/nfsdata/images/$(nodeattr -UV ver)/appliance.x86_64 \
     /mnt/nfsdata/images/$(nodeattr -UV ver)/appliance.x86_64.squashfs
   ```

8. Logout of the nfsserv node (which will typically goes back to the n00 node).

   ```console
   [root@hpelus1n01 ~]# exit
   ```

9. Reboot all diskless server nodes.

   ```console
   [root@hpelus1n00 ~]# pm -g -0 diskless ; sleep 30; pm -g -1 diskless
   ```

   It typically takes 8–10 minutes for all diskless nodes to become available again.

10. After 8–10 minutes, verify that all diskless nodes are accessible.

    Expected output is null.

    ```console
    [root@hpelus1n00 ~]# pdsh -g diskless true
    [root@hpelus1n00 ~]#
    ```

    NOTE: If the output is not null, consult support for further assistance.

11. Verify the ko2iblnd parameters are the following on the E1000 system.

    ```console
    pdsh -g lustre 'egrep "" /sys/module/ko2iblnd/parameters/*' | dshbak -c
    ```

    Example output:

    ```console
    ----------------
    hpelus1n[02-07]
    ----------------
    /sys/module/ko2iblnd/parameters/cksum:0
    /sys/module/ko2iblnd/parameters/concurrent_sends:84
    /sys/module/ko2iblnd/parameters/conns_per_peer:4
    /sys/module/ko2iblnd/parameters/credits:84
    /sys/module/ko2iblnd/parameters/dev_failover:1
    /sys/module/ko2iblnd/parameters/fmr_cache:1
    /sys/module/ko2iblnd/parameters/fmr_flush_trigger:384
    /sys/module/ko2iblnd/parameters/fmr_pool_size:512
    /sys/module/ko2iblnd/parameters/ib_mtu:0
    /sys/module/ko2iblnd/parameters/ipif_name:ib0
    /sys/module/ko2iblnd/parameters/keepalive:100
    /sys/module/ko2iblnd/parameters/map_on_demand:1
    /sys/module/ko2iblnd/parameters/nscheds:0
    /sys/module/ko2iblnd/parameters/ntx:2048
    /sys/module/ko2iblnd/parameters/peer_buffer_credits:0
    /sys/module/ko2iblnd/parameters/peer_credits:42
    /sys/module/ko2iblnd/parameters/peer_credits_hiw:64
    /sys/module/ko2iblnd/parameters/peer_timeout:180
    /sys/module/ko2iblnd/parameters/require_privileged_port:0
    /sys/module/ko2iblnd/parameters/retry_count:5
    /sys/module/ko2iblnd/parameters/rnr_retry_count:6
    /sys/module/ko2iblnd/parameters/service:987
    /sys/module/ko2iblnd/parameters/timeout:10
    /sys/module/ko2iblnd/parameters/use_fastreg_gaps:0
    /sys/module/ko2iblnd/parameters/use_privileged_port:1
    /sys/module/ko2iblnd/parameters/wrq_sge:1
    ```

12. Remount the Lustre server targets.

    ```console
    [root@hpelus1n00 ~]# cscli mount
    ```
