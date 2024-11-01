# Troubleshoot NICs not properly reporting their MAC addresses via LLDP

Use this procedure to troubleshoot issues with LLDP neighbor information not being up-to-date and to ensure it reflects the correct MAC addresses assigned to the high-speed network (HSN) interfaces.

## Problem

The issue is with the host software where the new MAC address is correctly being assigned to an HSN interface, but it is not being notified to the LLDP service.
This results in LLDP neighbor information containing an outdated (stale) MAC address `02:XX:XX:XX:XX:XX:XX:XX`.

## Workaround

1. After the AMA assignment on the node is complete, perform an interface `hsn<index>` link up and down.

   ```screen
   ip link set hsn0 down
   ip link set hsn0 up
   ```

2. Restart the LLDP service on the node.

   ```screen
   systemctl restart lldpad
   ```
