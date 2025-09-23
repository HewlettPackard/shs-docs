# Requirements

The following are requirements for Cray System Management (CSM) and HPE Performance Cluster Manager (HPCM) environments:

- HPE Slingshot CXI NICs
- Rosetta fabric switches
- Fabric Manager REST API (FM API)
- Supported Workload Manager (WLM)
- `libfabric`/`cxi` libraries
- `libcurl.so` library
- `libjson-c.so` library

**Note:** The `libcurl.so` and `libjson-c.so` libraries must be present, but will be dynamically loaded into the collective application at runtime the first time `libcurl` and `libjson` routines are needed. Specifically, `libcurl.so` and `libjson-c.so` must be present on any endpoint that serves as rank 0 for any call to `fi_join_collective()`.
If they are not present, the join will fail.
