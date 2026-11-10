# Intel MPI

Intel MPI uses Libfabric, and many commercial high-performance computing (HPC) independent software vendor (ISV) applications build against Intel MPI.
Most ISV applications bundle Intel MPI with a Libfabric version that does not include HPE Slingshot provider support.
You can run these applications by setting a few Intel MPI environment variables so that Intel MPI uses the Libfabric installed with the HPE Slingshot host software instead of the Libfabric bundled with that Intel MPI release.

## Example settings

Set the Intel MPI 2021.10 path:

- `source ${PATH_TO_IMPI}/setvars.sh`
- `export I_MPI_OFI_LIBRARY=/opt/cray/libfabric/<PATH_TO_LIBFABRIC_VERSION>/lib64/libfabric.so.1`
- `export I_MPI_OFI_PROVIDER=cxi`
- `export I_MPI_OFI_LIBRARY_INTERNAL=0`

To illustrate `<PATH_TO_LIBFABRIC_VERSION>`, in SHS version 2.1.2, the command would be:

```screen
export I_MPI_OFI_LIBRARY=/opt/cray/libfabric/1.15.2.0/lib64/libfabric.so.1
```

Intel MPI may also require the Libfabric Shared Memory Provider in addition to the HPE Slingshot NIC CXI provider.
The HPE Slingshot host software distribution includes this provider.
