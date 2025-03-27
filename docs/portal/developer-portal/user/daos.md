# DAOS

To ensure compatibility between DAOS and the HPE Slingshot Host Software (SHS) stack, configure the following environment variables globally in the `/etc/environment` file.

- `setenv("FI_CXI_RX_MATCH_MODE","hybrid")`
- `setenv("FI_MR_CACHE_MONITOR","kdreg2")`
- `setenv("FI_CXI_DEFAULT_CQ_SIZE","131072")`
