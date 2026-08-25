# Algorithmic MAC Address (AMA)

To support efficient low latency forwarding of frames within the network, HPE Slingshot assigns algorithmically generated Layer 2 addresses to physical ports based on the network topology.
This enables low latency and interval routing within the High Speed Fabric.

AMA enables HPE Slingshot to treat the entire topology as a flat network by providing:

- Faster switch lookups
- Controlled address space
- Fabric Manager-initiated address assignment
- REST API support for programming agent services
- LLDP-based configuration

Use the [AMA verification procedure](./ama_verification_procedure.md#verify-ama-configuration) to diagnose HSN connectivity or performance issues and confirm that an HSN interface is connected to the expected HPE Slingshot switch with the corresponding AMA configured.
