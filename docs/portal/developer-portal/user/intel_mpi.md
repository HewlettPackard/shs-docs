# Intel MPI and applications compiled with Intel MPI

Intel MPI documentation states it supports Libfabric version 1.5.0 or later, and it recommends the latest version off of the main branch of Libfabric.
Therefore, HPE Slingshot Libfabric works with Intel MPI.

As of HPE Slingshot release 2.1.2, the HPE Slingshot NIC provider is not yet packaged in the upstream OFI release, and therefore is not in the Intel MPI included version of Libfabric.
The environment variables provided will direct the Intel MPI middleware to use the HPE Slingshot NIC Host Software that is installed as part of the host software packages.

HPE expects the HPE Slingshot NIC Libfabric provider to be part of the Open Source Libfabric distribution as of Libfabric version 1.21, expected in July of 2024.
When Intel MPI incorporates Libfabric 1.21 or beyond, the following instructions may not be necessary.

To point the Intel MPI to the HPE Slingshot NIC installed Libfabric, the following variables must be set:

- Define the Intel MPI 2021.10 path, source `${PATH_TO_IMPI}/setvars.sh`
- `export I_MPI_OFI_LIBRARY=/opt/cray/libfabric/1.15.2.0/lib64/libfabric.so.1`
- `export I_MPI_OFI_PROVIDER=cxi`
- `export I_MPI_OFI_LIBRARY_INTERNAL=0`

The `/opt/cray/libfabric/1.15.2.0/lib64/libfabric.so.1` reference in the previous commands may vary by HPE Slingshot release.
As of release 2.1.2, the above is correct, but there may be newer versions in HPE Slingshot release 2.2 and later.

Intel MPI will not set environment variables by default the way Cray MPI does, so users may also need to set the environment variables for particular applications or particular sizes.
