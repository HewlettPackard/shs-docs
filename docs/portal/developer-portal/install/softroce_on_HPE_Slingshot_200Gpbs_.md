# Soft-RoCE on HPE Slingshot 200Gbps NICs

## Prerequisites

1. `cray-cxi-driver` RPM package must be installed.
2. `cray-rxe-driver` RPM package must be installed.
3. HPE Slingshot 200Gbps NIC Ethernet must be configured and active.

## Configuration

The following configuration is on the node image, and modifying the node image varies depending on the system management solution being used (HPE Cray EX or HPCM).

Follow the relevant procedures to achieve the needed configuration. Contact a system administrator to set up these parameters.

1. Modify the following kernel module parameters to enable Soft-RoCE to run optimally with good performance.

   ```bash
   cxi-eth.large_pkts_buf_count=10000
   rdma_rxe.xmit_hard=y
   ```

2. If Lustre is being used, modify the client and server parameters.

   Skip this step if Lustre is not being used.
   See the [Lustre configuration](lustre_network_driver_lnd_ko2iblnd_configuration.md) procedure for more details.

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

