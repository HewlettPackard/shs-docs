# Troubleshoot HSN MAC addresses after a global AMA prefix change

Use this information to understand the expected HSN interface behavior after the Fabric Manager initiates a run‑time update of the global MAC prefix.

## Problem

When the Fabric Manager initiates a run‑time update of the global MAC prefix, the following sequence occurs:

- The underlying switches update the assigned MAC address (AMA) of the `ros0pX` interfaces.
- LLDP propagates the updated MAC address to the corresponding HSN interfaces on the nodes.
- On nodes where the HPE Slingshot AMA service detects a new AMA prefix, the service does not overwrite the existing AMA MAC if the interface already has one with a different prefix. This behavior is intentional. Components such as Kfabric depend on the HSN MAC address and propagate it to upper‑layer applications. Changing the MAC at run time would require updates across those layers and is not recommended

## Workaround

After a global MAC prefix change, reboot the nodes with the `reboot` command.
