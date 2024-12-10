# DAOS

Intel DAOS sets this list of environment variables for compatibility with the HPE Slingshot Host Software (SHS) stack.

- `setenv("CRT_MRC_ENABLE","1")`
- `setenv("FI_CXI_OPTIMIZED_MRS","0")`
- `setenv("FI_CXI_RX_MATCH_MODE","hybrid")`
- `setenv("FI_MR_CACHE_MONITOR","memhooks")`
- `setenv("FI_CXI_REQ_BUF_MIN_POSTED","8")`
- `setenv("FI_CXI_REQ_BUF_SIZE","8388608")`
- `setenv("FI_CXI_DEFAULT_CQ_SIZE","131072")`
- `setenv("FI_CXI_OFLOW_BUF_SIZE","8388608")`
