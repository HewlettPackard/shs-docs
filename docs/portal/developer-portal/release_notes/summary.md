
# Summary

Date of Release: March 13, 2026

This is Slingshot Host Software version 14.0.0.  It includes compatibility updates, support updates, and critical bug fixes.

 

*When to upgrade to SHS version 14.0.0:*
 * *LTS:*  Align with the latest Long Term Support Release
 * *HPE Slingshot 400Gbps NIC deployments:* Recommended for systems using 400GBPS NICs with 200 or 400 series switches
 * *Latest OS Support:* Adds support for RHEL 9.7

 

*Key Highlights new to 14.0.0:*

+ Long Term Support (LTS) release aligned with the March 2026 recipe

+ SHMEM enhancements, including libfabric append support

+ Support for RHEL 9.7

 

*Since 14.0.0 is a fast follower to SHS 13.1.0, here is a summary of what was introduced in 13.1.0:*

*HPE Slingshot Host Software 13.1.0 Key Highlights*

+ Enhanced DAOS Integration

+ Added support for configuring DAOS Servers with Virtual Network Identifier (VNI) ranges to allow communication utilizing unique VNIs per DAOS client.

+ Increased VNI capacity beyond 256

+ Slingshot 400Gbps Improvements

+ Switch-Based Collectives improvements

+ RGID-related fixes and additional stability updates

+ Updated OS & Driver Support

+ Added ROCm 7.0 and NVIDIA 580.x drivers for SLES 15 SP7, RHEL 8.10, and RHEL 9.6

+ Tech Preview: Initial enablement for RHEL 10.0 and Ubuntu 24.04

+ DMABUF enabled by default for improved GPU/NIC interoperability

+ Added Soft-RoCE support for RHEL 9.6 x86 and SLES 15 SP7 x86

HPE recommends thoroughly reviewing the release notes and readme.txt files before upgrading systems. Note that release notes are specific to each release, so customers should consider reviewing the cumulative set of release notes to understand the net changes.