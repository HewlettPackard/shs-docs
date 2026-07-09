
# Install Slingshot Host Software (SHS) on HPCM compute nodes

This documentation provides step-by-step instructions to install and/or upgrade HPE Slingshot Host Software (SHS) on compute node images on an HPE Performance Cluster Manager (HPCM) using SLES15-SP4 as an example.

The procedure outlined here is applicable to SLES and RHEL distributions.
See the "System Software Requirements for HPE Slingshot Host Software (SHS)" section in the _HPE Slingshot Host Software Release Notes_ for exact version support for the release.

NOTE: The upgrade process is nearly identical to the installation, and the proceeding instructions will note where the two processes delineate.

## GPU driver and SDK prerequisites

For GPU-enabled HPCM systems, refer to the _HPE Cray Supercomputing User Services Software Administration Guide for HPE Performance Cluster Manager Software_ for GPU driver and SDK installation procedures:

- [Install AMD Driver and ROCm for GPU Support with SLES](https://support.hpe.com/hpesc/public/docDisplay?docId=dp00006837en_us&page=install-hpcm/gpu/Install_AMD_Driver_and_ROCm_for_GPU_Support_with_SLES.html)
- [Install NVIDIA Driver and HPC SDK for GPU Support with SLES](https://support.hpe.com/hpesc/public/docDisplay?docId=dp00006837en_us&page=install-hpcm/gpu/Install_NVIDIA_GPU_Driver_and_HPC_SDK_for_GPU_Support_with_SLES.html)
- [Install AMD Driver and ROCm for GPU Support with RHEL](https://support.hpe.com/hpesc/public/docDisplay?docId=dp00006837en_us&page=install-hpcm/gpu/Install_AMD_Driver_and_ROCm_for_GPU_Support_with_RHEL.html)
- [Install NVIDIA Driver and HPC SDK for GPU Support with RHEL](https://support.hpe.com/hpesc/public/docDisplay?docId=dp00006837en_us&page=install-hpcm/gpu/Install_NVIDIA_GPU_Driver_and_HPC_SDK_for_GPU_Support_with_RHEL.html)
