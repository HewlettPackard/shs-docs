# HPE Cray MPICH and HPE Slingshot SHMEM

HPE Cray MPICH optimizes for the HPE Slingshot NIC, meaning it configures Libfabric and CXI behavior optimally for HPE Slingshot to achieve high performance and robustness at scale, and takes advantage of the unique capabilities that HPE Slingshot offers.
It also includes enhancements for on-node performance for both CPU and GPU nodes.

Specific use of HPE Slingshot capabilities include:

- Traffic class optimizations
- Optimized on-node capability well integrated with off-node to optimize performance (hardware tag matching, GPU-to-GPU RDMA)
- In-network (switch-based) collectives enablement  
- Counter collection and reporting subsystem (described later in this document)
- Triggered operations for GPU optimizations

Refer to the specific product documentation for more information.  
All these capabilities are available in the HPE Slingshot NIC provider to any software using Libfabric and any middleware can take advantage of them.
