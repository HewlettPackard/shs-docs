# Generic HPE Slingshot configuration

The `slingshot-network-config` RPM provides example configuration files, binaries, and scripts that are used to configure the network adapters for use on an HPE Slingshot fabric.

The example scripts are provided with assumptions made regarding the names of the network adapters used in the system.
HPE Cray Supercomputing Programming Environment (CPE) modules have been designed to look for a specific network adapter prefix.
The recommendation of this document is that network adapters that are connected to the HPE Slingshot high-speed network fabric should have `hsn` as the prefix for the device name.
For example, if two network adapters on a host are connected to the HPE Slingshot fabric, then `hsn0` and `hsn1` should be the names of the network adapters. The schema is zero-base indexed.

Several aspects of the host's system and kernel configuration should be modified for optimal performance. There are some modifications which are required if certain criteria are met.
