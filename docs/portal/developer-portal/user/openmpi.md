# Open MPI

Open MPI can use Libfabric through two distinct integration paths that behave differently: the BTL (byte transport) path and the MTL (message transport) path.
In Open MPI, the BTL framework acts as a generic byte-moving layer and provides the lowest common denominator of compatibility across interconnects.
The MTL framework provides a tag-aware message transport that can take advantage of NIC performance features.
For HPE Slingshot, MTL is the preferred model because it delivers better performance.

When you use the MTL Libfabric path for Open MPI, no alternative mechanism exists for on-node communication.
All communication must pass through the Libfabric provider. This differs from HPE Cray MPICH, which uses Libfabric only for off-node communication and provides other performance-optimized mechanisms for on-node communication.
Many applications, especially GPU applications, do not use MPI for on-node parallelism. However, applications that do may not parallelize efficiently on node because intra-node traffic leaves the node and returns through the fabric.

To improve this behavior, the community developed the LINKx Libfabric provider to connect multiple providers.
On HPE Slingshot systems, Open MPI users can use LINKx to integrate shared memory (`shm`) for local communication and the CXI provider for remote communication under a unified Libfabric endpoint.
This setup enables efficient routing based on message location. For detailed setup instructions and examples, see the LINKx provider man page: `fi_lnx(7)`.

Use LINKx with Libfabric 2.1.0 or newer; recent HPE Slingshot software distributions include it.
Open MPI 5.0.0 or newer is required because earlier releases do not support the necessary Libfabric integration.
Because Open MPI 5 depends heavily on PMIx, the execution environment must provide PMIx support, such as a PMIx plugin for Slurm.
