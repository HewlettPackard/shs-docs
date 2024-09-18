# HPE Slingshot 200Gbps NIC firmware factory reset

If the firmware on a 200Gbps NIC adapter is corrupted, you can start the firmware factory reset procedure to recover. The factory reset can be initiated by configuring the DIP switches on the card to have the values in the following table and then power cycling the card. The power cycle must cycle auxiliary power to the 200Gbps NIC adapter.

1. Power down 200Gbps NIC adapter card.

2. Configure the DIP switches (reference designator SW1000) on the adapter card with the values in the following table.

   | Switch number | SA220M Label | SA210S Label | Value      |
   |---------------|--------------|--------------|------------|
   | 1             | DIS_HOST     | DIS_HOST     | OFF        |
   | 2             | DIS_ETH      | DIS_ETH      | OFF        |
   | 3             | DIS_SMB      | DIS_SMB      | OFF        |
   | 4             | DIS_USB      | DIS_USB      | OFF        |
   | 5             | WP_NIC0      | WP_NIC0      | ON         |
   | 6             | WP_NIC1      | -            | N/A        |

3. Power up 200Gbps NIC adapter card.

4. Wait one minute.

5. Power down 200Gbps NIC adapter card.

6. Configure the DIP switches to the desired value. The default configuration is shown in the following table.

   | Switch number | SA220M Label | SA210S Label | Value |
   |---------------|--------------|--------------|-------|
   | 1             | DIS_HOST     | DIS_HOST     | ON    |
   | 2             | DIS_ETH      | DIS_ETH      | ON    |
   | 3             | DIS_SMB      | DIS_SMB      | ON    |
   | 4             | DIS_USB      | DIS_USB      | ON    |
   | 5             | WP_NIC0      | WP_NIC0      | ON    |
   | 6             | WP_NIC1      | -            | ON    |

7. Power up 200Gbps NIC adapter card.

8. Perform a firmware update using the firmware that is included in the HPE Slingshot software release.
