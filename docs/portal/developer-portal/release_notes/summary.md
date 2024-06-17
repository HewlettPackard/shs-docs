
# Summary

Date of Release: February 28, 2024

The HPE Slingshot 2.1.2 release only contains Slingshot Host Software packages. The release packages include updated firmware for the HPE Slingshot NIC that may be installed as needed.

This HPE Slingshot 2.1.2 release resolves issues in a number of areas for Slingshot Host Software:

* A kernel panic was resolved for some systems running SLES15 SP5, RHEL 8.8, or COS 3.0. If sites plan on running SLES15 SP5, RHEL 8.8, or COS 3.0, you will need to update to SHS 2.1.2 to avoid the possibility of the kernel panic. A Customer Advisory is being issued with more details.
* An updated Cassini UEFI driver firmware (1.5.49) was introduced to address an exception found in 1.5.47. If you are on Cassini firmware 1.5.41, an upgrade is not required. If you do plan to upgrade, skip 1.5.47 and go directly to 1.5.49.
* SoftRoCE hangs were resolved by fixing the Ethernet driver transmit queue size. 
* Limitations with appropriate workarounds for systems running the MELLANOX OFED software stack are provided in the release notes.

HPE recommends all sites running SLES15 SP5, RHEL 8.8, or COS 3.0. upgrade to release 2.1.2 to utilize these fixes. This release is designated as "extended support" in conjunction with other HPE software components. 

HPE recommends thoroughly reviewing the release notes and readme.txt files before upgrading systems. Note that release notes are specific to each release, so customers should consider reviewing the cumulative set of release notes to understand the net changes.