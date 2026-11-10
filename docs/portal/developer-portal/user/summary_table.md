
# Frequently adjusted environment variables

The following table illustrates the default variables most often set outside their defaults for SHS 15.0 and later.
Increased values introduced in SHS 13.0 reduced the incidence of users needing to set these variables for applications running at scale on non-HPE Cray MPICH (or OpenSHMEM) distributions. HPE Cray MPICH has long set the higher values.

"Note NCCL/RCCL guidance" refers to the section in this document on RCCL and NCCL, which points to [shs-ccl-docs](https://github.com/HewlettPackard/shs-ccl-docs) for the most current best-known methods.

**Frequently adjusted environment variable defaults:**

|**Environment variable**|**Default**|**Max**|**Comments**|
|---|---:|---:|---|
|`FI_MR_CACHE_MONITOR`|`kdreg2`|&nbsp;|Note NCCL/RCCL guidance|
|`FI_MR_CACHE_MAX_SIZE`|`(unlimited)`|&nbsp;|&nbsp;|
|`FI_MR_CACHE_MAX_COUNT`|`4096`|&nbsp;|&nbsp;|
|`FI_CXI_DEFAULT_TX_SIZE`|`1024`|`16384`|&nbsp;|
|`FI_CXI_DEFAULT_RX_SIZE`|`1024`|`15360`|&nbsp;|
|`FI_CXI_DEFAULT_CQ_SIZE`|`131072`|&nbsp;|&nbsp;|
|`FI_CXI_RX_MATCH_MODE`|`hardware`|&nbsp;|Consider hybrid mode|
|`FI_CXI_OFLOW_BUF_SIZE`|`12MB`|&nbsp;|&nbsp;|
|`FI_CXI_REQ_BUF_SIZE`|`12MB`|&nbsp;|&nbsp;|
|`FI_CXI_REQ_BUF_MIN_POSTED`|`6`|&nbsp;|&nbsp;|
|`FI_CXI_RDZV_THRESHOLD`|`16384`|&nbsp;|Note NCCL/RCCL guidance|
|`FI_CXI_RDZV_GET_MIN`|`2049`|&nbsp;|Note NCCL/RCCL guidance|
|`FI_CXI_RDZV_EAGER_SIZE`|`2048`|&nbsp;|Note NCCL/RCCL guidance|
|`FI_CXI_RDZV_PROTO`|`default`|&nbsp;|Note NCCL/RCCL guidance|
|`FI_CXI_SW_RX_TX_INIT_MAX`|`1024`|`16384`|May be relevant for large-scale AI training|
