# Update firmware for CSM

The HPE Slingshot firmware must be updated with each new SHS install. The firmware can be updated using `slingshot-firmware` as provided by the `slingshot-firmware-management` package.

The following steps must be run on each worker node in the system.

1. Run `slingshot-firmware query` to query the current firmware version.

   ```screen
   ncn-w001# slingshot-firmware query
   p2p1:
    version: 1.4.1
   p1p1:
    version: 1.4.1
   ```

2. Run `slingshot-firmware update` to update the firmware of managed network devices to the version recommended by the installed software distribution, then run `slingshot-firmware query` again to confirm the update.

   ```screen
   ncn-w001# slingshot-firmware update
   ncn-w001# slingshot-firmware query
   p2p1:
    version: 1.5.15
   p1p1:
    version: 1.5.15
   ```

   **Note:** To run across all worker nodes in parallel and collate the output, tools such as `pdsh` and `dshbak` can be used if available on the system.
   For example (replace `ncn-w00[1-N]` with the actual worker node range):

   ```screen
   ncn-m002# pdsh -w ncn-w00[1-N] slingshot-firmware update | dshbak -c
   ncn-m002# pdsh -w ncn-w00[1-N] slingshot-firmware query | dshbak -c
   ```

3. Firmware updates do not take effect immediately. Firmware updates will only go into operation after the device has been power-cycled. Before putting the server back into operation, it must be rebooted or power-cycled according to the administration guide for the target server. Reference the COS documentation for Compute node maintenance procedures, and the CSM documentation for NCN and UAN maintenance procedures.
