
# NVIDIA Communications Collectives Libraries (NCCL)

This information is summarized from the “Running NCCL Applications” note that is available on the HPE Support Center (HPESC).

## Prerequisites

- Linux kernel 5.12 or later
- NCCL support for Libfabric: Use the [open-source “OFI Plug-In” in for Libfabric-to-NCCL version 1.6.0](https://github.com/aws/aws-ofi-nccl/releases/tag/v1.6.0)
- HPE Slingshot Host Software (SHS) version 2.1  or greater
- CUDA and NVIDIA GPU Driver supported by the HPE SHS release version
- GDRCopy must be installed

## Environment Settings for Libfabric

- `FI_MR_CACHE_MONITOR=userfaultfd`
- `FI_CXI_DISABLE_HOST_REGISTER=1`  
- `FI_CXI_DEFAULT_CQ_SIZE=131072`
- `FI_CXI_DEFAULT_TX_SIZE` must be set to at least as large as the number of outstanding unexpected rendezvous messages that must be supported for the endpoint plus 256; the default of 256 will be sufficient for most applications
- `FI_CXI_RDZV_PROTO=alt_read`
- Enable the [Alternative Rendezvous Protocol](./rendezvous_protocol_configuration.md#alternative-rendezvous-configuration-fi_cxi_rdzv_protoalt_read) (either `sysfs` variable, or job through job scheduler)
