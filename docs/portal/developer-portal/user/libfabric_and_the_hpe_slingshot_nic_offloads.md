# Overview

HPE Slingshot uses the industry standard Libfabric open-source communications library as its RDMA interface for middleware and applications. Libfabric enables hardware specific features through providers.
The HPE Slingshot CXI provider maps Libfabric semantics onto the HPE Slingshot NIC hardware to enable applications to benefit from the advanced hardware while retaining application portability to other hardware.
Middleware and applications can often benefit from tuning the CXI provider via environment variables for the hardware capabilities, especially at large scale, and some types of applications require specific configuration.
This section explains many of the relevant settings, and at the end is a summary table of most commonly touched settings.
The following section covers settings for specific common scenarios.
