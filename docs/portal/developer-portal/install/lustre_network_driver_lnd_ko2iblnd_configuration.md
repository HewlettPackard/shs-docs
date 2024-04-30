# Lustre Network Driver (LND) ko2iblnd configuration

The ko2iblnd.ko changes are needed for better Soft-RoCE performance on LNDs.

## Compute Node tuning for Soft-RoCE

Tuning on compute node can be achieved in two ways. Follow the steps that work best for the system in use.

1. Change the kernel module parameters.

   Follow the [Soft-RoCE Configuration](softroce_on_HPE_Slingshot_200Gpbs_.md#configuration) section to use kernel module parameter change.

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

## E1000 ko2iblnd tuning for Soft-RoCE

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
