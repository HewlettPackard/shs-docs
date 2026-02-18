# About this publication

This document provides an overview of the HPE Slingshot NIC software environment
for application users. It includes background information on the "theory of operations" to offer context for product configuration and troubleshooting. This document supplements the configuration and troubleshooting information found in the product documentation.

Tuning guidance discussed here is specific to each system or application, so consider your intended application workload and system configuration. For example, the HPE Cray Supercomputing Programming Environment runtime middleware (MPI and SHMEM) sets default values, as detailed in this document and in the Cray PE documentation.
Users may need to adjust settings for non-HPE Cray Software, such as open-source MPI stacks that may not have tuned values, and for specific applications.

Default environment settings are rarely changed to avoid unintended impacts during upgrades. Therefore, users are encouraged to evaluate whether adjusting environment variables will improve performance. Tuning environment settings is also useful when a specific application is failing or running slowly.
