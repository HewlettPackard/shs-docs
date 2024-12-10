# AMD ROCm Communications Collectives Libraries (RCCL)

This information is summarized from the “Running RCCL Applications” note that is available on the HPE Support Center (HPESC).

## Prerequisites

- Linux kernel 5.12 or later
- RCCL Support for Libfabric: Use the [open-source “OFI Plug-In” in for Libfabric-to-RCCL version 1.4](https://github.com/ROCmSoftwarePlatform/aws-ofi-rccl/)
- HPE Slingshot Host Software (SHS) version 2.1  or greater
- ROCm GPU driver and user stack supported by the HPE SHS release version

## Environment settings for Libfabric

- `FI_MR_CACHE_MONITOR=userfaultfd`
- `FI_CXI_DISABLE_HOST_REGISTER=1`  
- `FI_CXI_DEFAULT_CQ_SIZE=131072`
- `FI_CXI_DEFAULT_TX_SIZE` must be set to at least as large as the number of outstanding unexpected rendezvous messages that must be supported for the endpoint plus 256; the default of 256 will be sufficient for most applications
- `FI_CXI_RDZV_PROTO=alt_read`
- Enable the [Alternative Rendezvous Protocol](./rendezvous_protocol_configuration.md#alternative-rendezvous-configuration-fi_cxi_rdzv_protoalt_read) (either `sysfs` variable, or job through job scheduler)
