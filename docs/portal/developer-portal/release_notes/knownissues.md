
# Known Issues

|ID|Description|Workaround|
|:--:|:---------|:---------|
|2497306|Mellanox OFED kernel modules fail to load on CSM workers using 5.14.21-150500.55.39.1.27360.1.PTF.1215587-default kernel|Please see Appendix B of these release notes for<br>  complete details|
|2452300|SLES 15 SP5 installs on HPCM 1.10 use the distribution libfabric packages instead of the SHS-provided libfabric packages|specify the full rpm name:<br>  libfabric-1.12.1.2.46-SSHOT2.1.1\_20231103052708\_6e98e15b2f2c.x86\_64<br>  libfabric-devel-1.12.1.2.46-SSHOT2.1.1\_20231103052708\_6e98e15b2f2c.x86\_64<br>  instead of libfabric and libfabric-devel.|
|2215092|libfabric MR cache with memhooks may deadlock with CUDA and ROCM/ROCR|When doing RDMA with device memory, memhooks cannot be used as the system memory monitor. Either userfaultfd or HPE provided kdreg2 need to be used. The following environment variables are used to select these two memory monitors respectively.<br>  FI\_MR\_CACHE\_MONITOR=userfaultfd<br>  FI\_MR\_CACHE\_MONITOR=kdreg2|
