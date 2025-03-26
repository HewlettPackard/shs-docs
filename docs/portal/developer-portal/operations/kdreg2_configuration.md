# `kdreg2` configuration

After installing `kdreg2`, you may want to further optimize its performance.
The following steps can help you fine-tune `kdreg2` for your system:

1. Set the default memory monitor to `kdreg2` using the `FI_MR_CACHE_MONITOR` Libfabric environment variable.

   ```screen
   export FI_MR_CACHE_MONITOR=kdreg2
   ```

2. Increase the Libfabric environment variables for memory registration cache size if indicated, especially for applications that are not using Cray MPI.

    Consider modifying the following Libfabric parameters for the memory registration cache:

    - `FI_MR_CACHE_MAX_SIZE`: This environment variable defines the maximum size (in bytes) for the memory registration (MR) cache. Setting it to `-1` means there is no maximum. By default, Libfabric sets this to the system memory size divided by the number of processors (`cpu_cnt`) divided by 2. The HPE Cray Programming Environment (CPE) sets this to unlimited.
    - `FI_MR_CACHE_MAX_COUNT`: This environment variable specifies the maximum number of cached memory registrations that the MR Cache Monitor can maintain. The default value in Libfabric is 1024, which is often insufficient for many applications. It is recommended to increase this limit, with HPE CPE setting it to 524288. Increasing this limit helps ensure better reuse of memory locations for Remote Direct Memory Access (RDMA) operations when the MR Cache is active, preventing performance degradation caused by exceeding the MR Cache limits.
