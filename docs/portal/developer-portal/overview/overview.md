# Overview

SHS includes drivers and diagnostics for the HPE Slingshot NIC (CXI device driver), OFI Libfabric libraries for the HPE Slingshot NIC, as well as Linux configuration utilities and sample code for configuring the host images.

For supported industry standard NICs, Libfabric is supplied as it is required by Cray MPI. These components are installed on each node connected to the HPE Slingshot network and should be integrated into the boot images.

**Note:** For upgrade instructions for SHS, see the installation sections. Upgrading SHS involves installing a newer image, so specific upgrade instructions are not provided separately.

## Important changes in SHS release 13.0.0

Starting in SHS release 13.0.0, the following changes have been implemented:

- Mellanox NICs are not supported in this release, but will regain support in a future release
- Removal of Cray Operating System (COS) images
- Cray System Management (CSM) is now included as part of the SUSE Linux Enterprise (SLE) installation
