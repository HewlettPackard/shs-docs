
# Summary

Date of Release: April 09, 2025

Slingshot Host Software (SHS) version 12.0.0 is our latest Long-Term Support (LTS) release, focused on stability, reliability, and performance. It includes critical bug fixes, security enhancements, and compatibility updates to ensure long-term support. Users on earlier LTS versions are encouraged to upgrade.

Key Highlights: 
* CXI Driver has been updated to allow AMD GPUs to use dmabuf.
* Install kdreg2 by Default
* New Distributions
    * RHEL 9.5 (x86 and Arm)
    * Updated SLES15 SP6 Kernel and Corresponding COS-base (COS 25.03.x w/ COS Base 3.3)
* GPU Driver for New Distros
    * ROCM 6.3
    * Nvidia 24.11
    * CUDA 565.57.01 
* DKMS Updates
    * Allow parallel execution  

Note:  Blanca Peak nodes may crash when using LNet. Starting in USS 1.2.0 the recommended configuration for the iommu.passthough kernel parameter was changed. The iommu.passthrough=y configuration was removed from aarch64 boot parameters to allow the NVIDIA drivers to use the IOMMU with GPU devices. This change allowed the default to be used which could take on either passthrough or no values. This exposed a kfi_cxi bug on ARM blades running LNet (with Lustre or DVS over LNet) if iommu.passthough was not configured to be enabled. This applies both to directly connected Lustre using LNET or an LNET router going from kfi to k2oib (Infiniband Back end Lustre). This will impact non-arm blades if IOMMU needs to be enabled.

Starting with SHS v12.0.1, kfi_cxi will support either device IOMMU or passthrough.

HPE recommends thoroughly reviewing the release notes and readme.txt files before upgrading systems. Note that release notes are specific to each release, so customers should consider reviewing the cumulative set of release notes to understand the net changes.