
# NVIDIA Collective Communications Library (NCCL) and AMD ROCm Collective Communications Library (RCCL)

Running NCCL and RCCL on HPE Slingshot NICs requires coordination the broader software configuration, including NCCL/RCCL, a Libfabric back-end plug-in for NCCL/RCCL (`aws-ofi-nccl`) that is the bridge layer that causes NCCL and RCCL to use Libfabric, Libfabric environment variables, and other host side dependencies.

Refer to [shs-ccl-docs](https://github.com/HewlettPackard/shs-ccl-docs) for the most current best-known-methods including a summary of all required and recommended Libfabric and NCCL/RCCL environment variables.

For illustration, extracted from those pages below are some of the Libfabric variables changed from the defaults, most notable a requirement to change from memhooks and use the alternative rendezvous protocol with eager transfers disabled. Refer to the on-line site for the complete configuration.

**NCCL and RCCL Libfabric recommendations:**

|**Variable**|**Recommended**|**Comments**|
|---|---|---|
|`FI_MR_CACHE_MONITOR`|`userfaultfd` or `kdreg2`|Memhooks creates deadlocks|
|`FI_CXI_RDZV_PROTO`|`alt_read`|Note other alt_read related settings|
|`FI_CXI_RDZV_EAGER_SIZE`|`0`|Prevents unexpected messages|
|`FI_CXI_RDZV_THRESHOLD`|`0`|Forces messages through rendezvous path.|
|`FI_CXI_RDZV_GET_MIN`|`0`|Forces messages through rendezvous path.|
