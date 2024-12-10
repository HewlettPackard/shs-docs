# Expected number of ranks and peers (`FI_UNIVERSE_SIZE`)

The Libfabric `FI_UNIVERSE_SIZE` environment variable defines the number of expected ranks/peers an application needs to communicate with. This value is used in the CXI provider to scale portals flow-control resources used for side-band communication.

The side-band control event queue size is based on the universe size so that more resources are applied as the job scales.

Libfabric sets this default to 1024. The maximum number of ranks when using Cray MPI would be roughly one per core, so 256 ranks would be 256 cores (per NIC). Platforms that have more than 256 cores per NIC may need to increase this size.

If set too small, performance may be impacted by constraining the number of side-band messages that can be outstanding during portals flow-control recovery. If set too large, more memory may be needlessly confused.
