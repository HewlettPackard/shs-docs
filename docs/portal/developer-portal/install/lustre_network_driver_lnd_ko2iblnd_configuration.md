# Configure ko2iblnd Lustre Network Driver (LND) for Soft-RoCE performance

The ko2iblnd.ko module requires modifications to optimize Soft-RoCE performance.
If your setup does not involve Soft-RoCE connections, this section does not apply.

## Prerequisites

Ensure that Lustre is installed with the ko2iblnd module built for the Soft-RoCE driver (RXE) by specifying `--with-o2ib=yes` for `/.configure` or `rpmbuild`.
If this option is not specified, the build process will attempt to automatically detect external OFED installations or internal o2ib support.
If neither is detected, the ko2iblnd module will not be built.

For detailed instructions, see the _Cray ClusterStor Lustre Client Build Configuration Guide S-9100_.

## Compute Node tuning for Soft-RoCE

Tuning on compute node can be achieved in two ways. Follow the steps that work best for the system in use.

1. Change the kernel module parameters.

   Follow the [Soft-RoCE Configuration](./softroce_on_HPE_Slingshot_200Gbps.md#configuration) section to use kernel module parameter change.

2. Use `modprobe.d` to tune compute nodes for Soft-RoCE.

   a. On the admin node, create a file with the following command with the following line.

      ```screen
      vim ~/ko2iblnd.conf
      options ko2iblnd conns_per_peer=4 peer_credits=42 concurrent_sends=84 ntx=2048 credits=1024
      ```

   b. Copy this file from admin node to all compute nodes as root.

      ```screen
      pdcp -w <compute_nodes_list> ~/ko2iblnd.conf /etc/modprobe.d/ko2iblnd.conf
      ```

   c. Unload Lustre modules on all compute nodes.

      ```screen
      pdsh -w <compute_nodes_list> lustre_rmmod
      ```

   d. Reload Lustre modules on all compute nodes.

      ```screen
      pdsh -w <compute_nodes_list> modprobe lustre
      ```

   e. Check the ko2iblnd tunings are in place on all compute nodes.

      ```screen
      pdsh -w <compute_nodes_list> 'egrep "" /sys/module/ko2iblnd/parameters/*' | dshbak -c
      ```

      The output should be the same as the following:

      ```console
      /sys/module/ko2iblnd/parameters/cksum:0
      /sys/module/ko2iblnd/parameters/concurrent_sends:84
      /sys/module/ko2iblnd/parameters/conns_per_peer:4
      /sys/module/ko2iblnd/parameters/credits:1024
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

## E1000 ko2iblnd tuning for Soft-RoCE

Configure clients to use Soft-RoCE and configure storage with MLX HCAs running HW RoCE.

NOTE: These changes will not persist on file system upgrade and should be reapplied.

1. Log in to the primary management server as admin user.

2. `sudo` as root on the primary management server.

   ```screen
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

   options ko2iblnd conns_per_peer=4 ntx=2048 peer_credits=42 peer_credits_hiw=64 concurrent_sends=84 credits=1024 map_on_demand=1
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
    /sys/module/ko2iblnd/parameters/credits:1024
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
