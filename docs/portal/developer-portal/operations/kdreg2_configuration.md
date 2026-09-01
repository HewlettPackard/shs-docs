# `kdreg2` configuration

After installing `kdreg2`, you may want to further optimize its performance.

Increase the Libfabric environment variables for memory registration cache size if indicated, especially for applications that are not using Cray MPI.

Consider modifying the following Libfabric parameters for the memory registration cache:

- `FI_MR_CACHE_MAX_SIZE`: Defines the maximum size (in bytes) for the memory registration (MR) cache. Setting it to `-1` means there is no maximum. By default, Libfabric sets this to `system_memory / cpu_cnt / 2`. The HPE Cray Supercomputing Programming Environment (CPE) sets this to unlimited.
- `FI_MR_CACHE_MAX_COUNT`: Specifies the maximum number of cached memory registrations maintained by the MR Cache Monitor. Libfabric defaults this value to 1024, which is often too low for many applications. It is recommended to increase this limit. HPE CPE currently sets `FI_MR_CACHE_MAX_COUNT` to roughly 500 times larger than the libfabric default. Increasing this limit can improve MR reuse and help avoid performance degradation caused by cache evictions.
