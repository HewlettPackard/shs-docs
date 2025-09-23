# Basic application overview

1. The user application must be started on multiple compute nodes by an appropriate Workload Manager, such as SLURM or PBS/PALS, which is adapted to support accelerated collective requirements. The WLM must:

   - Gain secure access to the Fabric Manager (HTTPS) prior to job start
   - Generate environment variables needed by the `libfabric` library
   - Gain secure access to the Fabric Manager (HTTPS) upon job completion

1. User applications must enable collectives for all CXI endpoints (NICs) to be used in a collective using the `FI_COLLECTIVE` flag when the endpoint is enabled.

1. User applications must create one or more collective groups using `fi_join_collective()`, which will return an `mc_obj` pointer to each endpoint that identifies the collective group.

1. User applications can now use `fi_barrier()`, `fi_broadcast()`, `fi_reduce()`, and `fi_allreduce()` on these joined collective groups.

1. Upon completion of use, the application will call `fi_close()` on the `mc_obj` for each collective group. Note that simply exiting the application (cleanly or with an abort) will perform preemptive cleanup of all `mc_obj` objects.
