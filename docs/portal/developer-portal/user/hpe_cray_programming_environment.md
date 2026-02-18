# HPE Cray Supercomputing Programming Environment

HPE Cray Supercomputing Programming Environment pre-programs many of the environment variables for the HPE Slingshot NIC libfabric.
These settings have been found to be useful generally for HPE supercomputing customers when using the distributed middleware such as Cray MPI.
The settings are a useful starting point for users of other MPI middleware though each MPI software may have unique attributes that could be better optimized though experimentation.

## MPI settings

- `FI_CXI_RDZV_THRESHOLD = 16384`
- `FI_CXI_RDZV_EAGER_SIZE = 2048`
- `FI_CXI_DEFAULT_CQ_SIZE = 131072`
- `FI_CXI_DEFAULT_TX_SIZE = 1024`
- `FI_CXI_OFLOW_BUF_SIZE = 12582912`
- `FI_CXI_OFLOW_BUF_COUNT = 3`
- `FI_CXI_RX_MATCH_MODE = hardware`
- `FI_CXI_REQ_BUF_MIN_POSTED = 6`
- `FI_CXI_REQ_BUF_SIZE  = 12582912`
- `FI_CXI_REQ_BUF_MAX_CACHED = 0`
- `FI_MR_CACHE_MAX_SIZE = -1`
- `FI_MR_CACHE_MAX_COUNT= 524288`
