
# Summary

Date of Release: September 05, 2025

This is Slingshot Host Software version 13.0.0.  It includes new hardware support, compatibility updates, support updates, and critical bug fixes.

Key Highlights:
 * Support for HPE Slingshot 400Gbps NICs
 * Upgrade to libfabric 2.2
 * Support for new distributions: SLES SP7 and RHEL 9.6
 * Support for New GPU Versions: AMD 6.4 and NVIDIA 25.5 with 570 driver for the new distros
 * SoftRoCE support for RHEL 9.4 (x86 Only) and SLES SP6 (x86 Only)
 * Removal of COS and CSM product streams — use SLES for all CSM installations

Note: SS10 is not supported — please continue using SHS-v12.0.x for any SS10 Systems

Note: Using the latest SLURM version 25.05 or PALS 1.7.1 can result in an application failure with libfabric error: 'Command failure' when > 252 ranks per node are used because of an issue with RGID sharing. If more than more than 252 ppn are required then recommend to use earlier versions of SLURM or PALS until this is resolved.

Note: CXI provider support for FI_ORDER_ATOMIC_WAR and FI_ORDER_ATOMIC_RAW message ordering is not conformant and have been deprecated. They will be removed in a future release.

HPE recommends thoroughly reviewing the release notes and readme.txt files before upgrading systems. Note that release notes are specific to each release, so customers should consider reviewing the cumulative set of release notes to understand the net changes.