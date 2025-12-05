
# Summary

Date of Release: December 18, 2025

HPE Slingshot Host Software (SHS) version 13.1.0 introduces new hardware enablement, expanded operating system compatibility, feature enhancements, and critical fixes to improve reliability and performance across HPE Slingshot systems.

Key Highlights

+ Enhanced DAOS Integration
    + Added support for configuring Virtual Network Interfaces (VNIs) on DAOS client nodes using mechanisms other than scheduler plug-ins.

    + Increased VNI capacity, enabling configurations requiring more than 256 VNIs.

 + HPE Slingshot 400Gbps Updates

    + Improvements and fixes specific to HPE Slingshot 400Gbps hardware to enhance stability and overall performance.
    + Updated firmware and improved compatibility with newer OS and driver versions.

 + Updates to Switch-Based Collectives
 + RGID-related fixes and additional stability improvements.
 + Updated OS and Driver Support
    + Added ROCm 7.0 and NVIDIA 580.x driver support for SLES 15 SP7, RHEL 8.10, and RHEL 9.6.
    + Tech Preview: Initial enablement for RHEL 10.0 and Ubuntu 24.04.
    + DMABUF enabled by default for improved GPU/NIC interoperability.

 + Soft-RoCE support added for RHEL 9.6 x86 and SLES 15 SP7 x86.

HPE recommends thoroughly reviewing the release notes and readme.txt files before upgrading systems. Note that release notes are specific to each release, so customers should consider reviewing the cumulative set of release notes to understand the net changes.