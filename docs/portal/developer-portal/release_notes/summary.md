
# Summary

Date of Release: August 01, 2025

Slingshot Host Software (SHS) version 12.0.2 is a patch to the SHS 12.0.1 Long-Term Support Release (LTS) and contains notes and issues for this patch only.  Refer to the SHS 12.0.1 Release Notes for details on the contents of that release.

Slingshot Host Software (SHS) version 12.0.2 is our latest Long-Term Support (LTS) release, focused on stability, reliability, and performance. It includes critical bug fixes and performance enhancements to ensure long-term support. Users on earlier LTS versions are recommended to upgrade if they encounter any of the listed defects or performance issues.

The following is a summary of the critical bug fixes contained in this patch:
 * Libfabric hardening to handle data integrity issues arising from applications not properly synchronizing buffers during overlapping CUDA P2P RDMA accesses and memory copies
 * CXI driver fix to address a resource leak related to Communication Profiles
 * NCCL performance improvement at large node counts
 * NCCL performance when using the alt_read rendezvous protocol
 * CXI driver fix to improve performance for incast-heavy traffic patterns at larger scales
 * Retry Handler exit handling

HPE recommends thoroughly reviewing the release notes and readme.txt files before upgrading systems. Note that release notes are specific to each release, so customers should consider reviewing the cumulative set of release notes to understand the net changes.