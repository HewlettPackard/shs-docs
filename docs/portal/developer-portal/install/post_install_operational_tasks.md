
# Post-install operational tasks

The firmware must be updated with each new install. The firmware can be updated using `slingshot-firmware` as provided by the `slingshot-firmware-management` package.

1. Run `slingshot-firmware query` to query the current version of the software.

   ```screen
   ncn-w001# slingshot-firmware query
   p2p1:
    version: 1.4.1
   p1p1:
    version: 1.4.1
   ```

2. Run `slingshot-firmware update` to update the firmware of managed network devices to the version recommended by the installed software distribution.

   ```screen
   ncn-w001# slingshot-firmware update
   ncn-w001# slingshot-firmware query
   p2p1:
    version: 1.5.15
   p1p1:
    version: 1.5.15
   ```

3. Firmware updates do not take effect immediately. Firmware updates will only go into operation after the device has been power-cycled. Before putting the server back into operation, it must be rebooted or power-cycled according to the administration guide for the target server. Reference the COS documentation for Compute node maintenance procedures, and the CSM documentation for NCN and UAN maintenance procedures.

