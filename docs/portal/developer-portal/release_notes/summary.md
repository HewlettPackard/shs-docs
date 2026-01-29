
# Summary

Date of Release: January 30, 2026

HPE Slingshot Host Software (SHS) version 13.1.0 introduces new hardware enablement, expanded operating system compatibility, feature enhancements, and critical fixes to improve reliability and performance across HPE Slingshot systems.

**Upgrade to SHS version 13.1 for the following features:**

+ **HPE Slingshot 400Gbps NIC deployments:** Recommended for systems using 400Gbps NICs with 200- or 400-series switches
+ **Latest OS support:** Validated support for the latest OS releases
+ **GPU driver updates:** New GPU drivers validated with this release, reducing upgrade risk
+ **New features:** Switch-based collectives, DAOS partitioning improvements, and multiple bug fixes
+ **High-process workloads:** Supports RGID sharing for jobs exceeding 252 processes (for example, 128-core CPUs with a single NIC) to improve scalability

**Key highlights:**

+ Enhanced DAOS integration
    +  Currently only supported for PALS/PBSPro systems
    + Added support for configuring DAOS Servers with Virtual Network Identifier (VNI) ranges to allow communication utilizing unique VNIs per DAOS client
    + Increased VNI capacity, enabling configurations requiring more than 256 VNIs
 + HPE Slingshot 400Gbps updates
    + Improvements and fixes specific to HPE Slingshot 400Gbps hardware to enhance stability and overall performance
    + Updated firmware and improved compatibility with newer OS and driver versions
 + Support for Switch-based collectives
    + Note: There are additional dependencies on the HPE Slingshot Fabric Manager and Switch software that are not covered in this release. Contact HPE before deploying collectives.
 + RGID-related fixes and additional stability improvements
 + Updated OS and driver support
    + Added ROCm 7.0 and NVIDIA 580.x driver support for SLES 15 SP7, RHEL 8.10, and RHEL 9.6
    + Tech Preview: Initial enablement for RHEL 10.0 and Ubuntu 24.04
    + DMABUF enabled by default for improved GPU/NIC interoperability
 + Soft-RoCE support added for RHEL 9.6 x86 and SLES 15 SP7 x86

HPE recommends thoroughly reviewing the release notes and readme.txt files before upgrading systems. Note that release notes are specific to each release, so customers should consider reviewing the cumulative set of release notes to understand the net changes.