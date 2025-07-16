# Configure Soft-RoCE on HPE Slingshot CXI NICs

## Prerequisites

1. `cray-cxi-driver` RPM package must be installed.
2. `cray-rxe-driver` RPM package must be installed.
3. HPE Slingshot CXI NIC Ethernet must be configured and active.
4. Lustre is being used.

   **Note:** This procedure contains configuration settings specific to Lustre.
   If you are using a different filesystem, you will need to determine and apply the appropriate configuration settings for that filesystem. Proceed with caution

## Configuration

The following configuration is on the node image, and modifying the node image varies depending on the system management solution being used (HPE Cray EX or HPCM).

Follow the relevant procedures to achieve the needed configuration. Contact a system administrator to set up these parameters.

1. Modify the following kernel boot extra command line parameter to enable Soft-RoCE to run optimally with good performance.

   ```screen
   cxi-eth.large_pkts_buf_count=10000
   ```

2. Modify the client and server parameters.

   See the [Lustre configuration](lustre_network_driver_lnd_ko2iblnd_configuration.md#configure-ko2iblnd-lustre-network-driver-lnd-for-soft-roce-performance) procedure for more details.

   Update the parameters on the client.

   These parameters may be provided as kernel boot extra command line parameters.
   The list is as follows:

   ```screen
   ko2iblnd.conns_per_peer=4
   ko2iblnd.concurrent_sends=84
   ko2iblnd.ntx=2048
   ko2iblnd.credits=1024
   ko2iblnd.peer_credits=42
   ```

3. Check if links are initialized and AMAs assigned.

4. Create an RXE (Soft-RoCE) device by running `rxe_init.sh [devices list]` as root.

   The `/usr/bin/rxe_init.sh` script is provided in the `cray-rxe-drivers` package

   **Note:** At this time, HPE Slingshot CXI NICs do not automatically create RXE devices, so it must be done manually.

   `[devices list]` is a list of interfaces to create RXE devices for.
   For example, running `rxe_init.sh hsn0 hsn1` will create rxe0 and rxe1.

   This script will create the `rxe0` device, and apply for the appropriate settings Soft-RoCE.
   If no devices list is provided, `rxe_init.sh` will use `hsn0` as the devices list.

**Note:** Soft-RoCE device creation is not persistent across reboots.
The `rxe_init.sh` script must be run on every boot after the HPE Slingshot CXI NIC Ethernet device is fully programmed with links up and AMAs assigned.
