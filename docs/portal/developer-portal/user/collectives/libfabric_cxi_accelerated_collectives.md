# Appendix 2: Developer guide for HPE Slingshot in-network accelerated collectives

The `libfabric` CXI provider supports HPC hardware-accelerated collectives through the `libfabric` `fi_collectives` API.
This is a subset of collectives, with some extensions.

The `libfabric` CXI provider does not support non-accelerated collectives.

This document describes the specific features of this API.
