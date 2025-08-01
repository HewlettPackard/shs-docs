
# Resolved Issues
|ID|Description|Impact|Component|Affected Version/s|
|:--:|:---------|:---------|:----|:----|
|3131390|Libfabric CXI provider missing cuda P2P sync\_memops|This change addresses a scenario where overlapping CUDA P2P RDMA access and memory copies to the same buffer could lead to data integrity risks if buffers are not properly synchronized. This update ensures that, even in cases where synchronization is missed in user code, the libfabric layer handles operations safely to prevent race conditions and maintain reliable behavior.|cxiprov|SHS v11.1.0<br>  SHS v12.0.0|
|3125881|CXI Communication Profile Leak|A cxi\_ss1 driver refcounting issue was introduced in SHS 12.0.0 that could cause Communication Profile resources to be leaked when reused. This has now been rectified.|cxicore|SHS v12.0.0<br>  SHS v12.0.1|
|3111596|NCCL performance at large node counts|This change further improves *CCL performance over large collective message sizes by dedicating a rendezvous command queue. It is enabled by default when the FI\_CXI\_RDZV\_PROTO=alt\_read is enabled. If application wishes to disable the use of the additional alt\_read hardware resource it should set FI\_CXI\_DISABLE\_ALT\_READ\_CMDQ=1.|cxiprov|SHS v11.0.0|
|3099828|Slow NCCL performance using alt\_read rendezvous protocol|Without the associated fix, NCCL performance using the alt\_read rendezvous protocol will be lower than expected.|cxiprov<br>  libfabric|SHS v11.0.0|
|3092834|Retune CXI Resource Reservations for Incasts|A driver change that affects 12.0.0 and 12.0.1 caused  performance issues that were particularly observable under incast-heavy traffic patterns at larger scales than internal testing could accommodate. This is now fixed.|cxicore|SHS v12.0.0|
|3088653|Retry Handler mount point becomes inaccessible after modifying the log level.|In SHS 12.0.0 and 12.0.1 - restarting the CXI Retry Handler would fail. This is now resolved.|cxirh|SHS v12.0.0|
