
# Summary

Date of Release: May 09, 2025

Slingshot Host Software (SHS) version 12.0.1 replaced SHS 12.0.0 for the Long-Term Support Release (LTS). The release notes for SHS 12.0.1 are cumulative - combining 12.0.0 and 12.0.1 notes and issues.

Slingshot Host Software (SHS) version 12.0.1 is our latest Long-Term Support (LTS) release, focused on stability, reliability, and performance. It includes critical bug fixes, security enhancements, and compatibility updates to ensure long-term support. Users on earlier LTS versions are encouraged to upgrade.

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
    * Enable parallel builds for DKMS modules using make.
    * Remove dependency on NVIDIA DKMS when it's installed outside the DKMS framework.

Note:  In 12.0.0 we identified an issue where in some cases Blanca Peak nodes crashed when using LNet.  This exposed a kfi_cxi bug on ARM blades running LNet (with Lustre or DVS over LNet) if iommu.passthough was not configured to be enabled impacted both to directly connected Lustre using LNET or an LNET router going from kfi to k2oib (Infiniband back-end Lustre). Starting with SHS v12.0.1, this has been resolved and  kfi_cxi will support either device IOMMU or passthrough.

HPE recommends thoroughly reviewing the release notes and readme.txt files before upgrading systems. Note that release notes are specific to each release, so customers should consider reviewing the cumulative set of release notes to understand the net changes.