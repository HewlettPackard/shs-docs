# Slingshot Host Software (SHS)

Slingshot Host Software (SHS) includes drivers and diagnostics for the HPE Slingshot NIC (CXI device driver), OFI Libfabric libraries for both the HPE Slingshot NIC and for supported industry NICs (NVIDIA Mellanox CX-5), and Linux configuration utilities and sample code for configuring the host images.

For systems using the Cray Operating System, the host software packages also supply drivers for the supported industry
standard NICs. For supported industry standard NICs, Libfabric is supplied is because it is required by Cray MPI.
These components are installed on each node connected to the Slingshot network, and should be integrated into the boot images.
