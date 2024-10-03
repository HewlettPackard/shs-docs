# Libfabrics

[OpenFabrics Interfaces (OFI)](https://ofiwg.github.io/libfabric/) is a framework focused on exporting fabric communication services to applications. OFI is best described as a collection of libraries and applications used to export fabric services. OFI is designed to meet the performance and scalability requirements of high-performance computing (HPC) applications, such as MPI.

The key components of OFI are:

- Application interfaces
- Provider libraries
- Kernel services
- Daemons and test applications

The rest of the section outlines different techniques that are adopted to troubleshoot the performance mismatch between the expected and actual results. It is important to understand the expected results of a performance test based on the HSN configuration:

- Topology
- Number of Endpoints
- Switches
- Groups, and Switches per group,
- Local Links
- Single or dual NICs
