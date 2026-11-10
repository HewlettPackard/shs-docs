# Expected number of ranks and peers (`FI_UNIVERSE_SIZE`)

The Libfabric `FI_UNIVERSE_SIZE` environment variable defines the number of ranks or peers that the application expects.
While this value is not specific to the HPE Slingshot NIC, the CXI provider uses it to scale flow-control resources for sideband communication as the job grows. Libfabric defaults this value to 1024.
Set it to at least the total number of ranks in the job. Cray MPICH 9.2.0 and later sets this value automatically.

A value that is too small constrains the number of sideband messages that can remain outstanding during Portals flow-control recovery and can reduce performance. A value that is too large consumes more memory than necessary.
