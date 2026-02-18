# User configurable Libfabric environment variables when using the HPE Slingshot NIC

The `cxi` provider uses various environment parameters to size hardware resources according to the needs of the system, potentially application and message pattern and system processing type and size. If those patterns are constant, the configuration would be globally set, but for systems that have heterogenous applications and processing, sometimes these need to be set on a per-application basis.
Often tuning of environment variables is more relevant for larger clusters and larger jobs.

Some are specific to the `cxi` provider, while others are general Libfabric object attribute size and environment variables important when using the `cxi` provider.

The use of these settings can be relevant in several ways:

- Optimizing host memory use: over sizing some parameters can waste host memory.
- Optimize performance: sizing the resources properly can help performance by maximizing use of the hardware offload capability, minimizing “on-loading” to the host, avoiding the impact of stopping and starting to flow control messages, and maximizing the opportunities re-use host memory caches.
- Overcoming hangs that may be caused by the complex interaction of any specific application’s memory access and communications patterns with the memory caching and other functions in the communications stack.

Environment variable defaults are usually set by the administrator but can be overridden on an application basis – either the middleware like the MPI library, or on an application-by-application basis. Sometimes the optimal default settings are site-specific, a function of the type of processors being employed (GPU vs CPU), the main type of applications being run (For example, GPU-based AI, MPI, or SHMEM), and the scale of the system.
Sometimes, a specific application will need unique settings. These settings can include both general Libfabric parameters as well HPE Slingshot specific ones.

Note that HPE Cray MPI provides default settings for environment variables that are not yet set by other Libfabric stacks (like open-source MPI or GPU communications collectives library) and therefore might need to be explicitly set, particularly for larger cluster sizes.
While it is difficult to provide general guidance across the breadth of different system sizes and types using the HPE Slingshot NIC, sites should consider whether the trade-off of setting a parameter too high at the cost of wasted host memory is more impactful than being too constrained, in which case the HPE Cray MPI settings is a good template thought they are sized for the customer base of large systems.

The most detailed reference for the HPE Slingshot provider is the [manpage for the `cxi` provider](https://github.com/ofiwg/libfabric/blob/main/man/fi_cxi.7.md).
Libfabric software developers (For example, those developing MPI middleware) should see the manpages for the most complete and information.
The intent of the information here is to document the most common settings administrators and specific application users will need to use, partially based on current customer experience.
The [HPE Slingshot NIC RDMA protocol and traffic classes](./hpe_slingshot_nic_rdma_protocol_and_traffic_classes.md#hpe-slingshot-nic-rdma-protocol-and-traffic-classes) table in the appendix of HPE Slingshot NIC specific settable parameters is copied from the `cxi` Libfabric provider man page.
The syntax for these variables starts with `FI_CXI_xxx`.

General Libfabric variables will use the syntax `FI_xxx` and would be explained in the general Libfabric man page available on `ofiwg.github.io`.
Software capabilities have evolved from prior versions of the HPE Slingshot Host Software, and guidance might have been different in the past.

Default settings are also current as of the SHS 2.1.2 release but can change in the future.

Users of the HPE Cray Supercomputing Programming Environment (CPE) will find additional information in the CPE documentation.
