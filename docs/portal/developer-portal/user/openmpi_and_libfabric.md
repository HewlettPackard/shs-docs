# How to run Open MPI and Libfabric on HPE Slingshot

Open MPI should be configured to use the Libfabric MTL path and to disable conflicting transports.
In addition, Libfabric and LINKx environment variables must be set to define how providers are combined.

When communicating directly from GPU buffers, all GPU-relevant software modules appropriate for the compute node architecture must be loaded to ensure correct operation and performance.

The examples in this section were written for Open MPI 5.0.11 and Libfabric 2.5.1.

## Without LINKx

Set the following environment variables:

```screen
export OMPI_MCA_mtl=ofi
export OMPI_MCA_pml=cm                # set to ob1 instead to use the Open MPI BTLs
export PMIX_MCA_psec=native
export FI_PROVIDER=cxi
export FI_CXI_RX_MATCH_MODE=hardware
```

The launch command is the same with or without LINKx.
For example, to run a basic internode point-to-point communication micro-benchmark on GPU buffers:

```screen
srun --mpi=pmix --nodes=2 --ntasks-per-node=1 --cpu-bind=map_cpu:1 ./set_gpu_affinity.sh ./osu_bibw -c -d rocm D D
```

In this example, `set_gpu_affinity.sh` is a site script that assigns a GPU to each process.
If running on a single node, you may have to include `--network=single_node_vni`.

## With LINKx

The LINKx (`lnx`) provider links the `shm` and `cxi` providers, so that intra-node messages use shared memory and internode messages use the HPE Slingshot NICs.
LINKx does not support hardware tag matching, so it uses software tag matching.
See [The LINKx (LNX) Provider](linkx_provider.md) for more information.

LINKx provider linkage is configured using Libfabric environment variables.
A common configuration explicitly maps shared memory and multiple CXI devices.
For example, for nodes with four HPE Slingshot NICs:

```screen
export OMPI_MCA_mtl=ofi
export OMPI_MCA_pml=cm                # set to ob1 instead to use the Open MPI BTLs
export PMIX_MCA_psec=native
export FI_PROVIDER=lnx
export FI_CXI_RX_MATCH_MODE=software
export OMPI_MCA_mtl_ofi_av=table
export FI_SHM_USE_XPMEM=1
export FI_LNX_PROV_LINKS="shm+cxi:cxi0|shm+cxi:cxi1|shm+cxi:cxi2|shm+cxi:cxi3"
```

## With LINKx and multi-rail

To link all HPE Slingshot NICs of the node into one multi-rail link, set:

```screen
export FI_LNX_PROV_LINKS="shm+cxi"
```

The `FI_LNX_MULTI_RAIL_SELECTION` environment variable selects how messages are spread across the NICs:

- `PER_PEER` (default): the first message to a peer selects a local NIC and a peer address, which are then used for all messages to that peer. Messages between two processes are received in the order in which they are sent.
- `PER_MSG`: each message uses the next local NIC and peer address in turn. Messages can arrive out of order, so send-after-send ordering is not supported.

## Debugging

```screen
export FI_LOG_PROV=shm,cxi,lnx
export FI_LOG_LEVEL=debug             # debug messages require a Libfabric built with --enable-debug
export FI_LNX_DISABLE_SHM=1           # with LINKx, do not use shm; intra-node messages use the NICs
export OMPI_MCA_pml_base_verbose=100
export OMPI_MCA_mtl_base_verbose=100
export OMPI_MCA_mtl_ofi_verbose=100
export OMPI_MCA_btl_base_verbose=100
export OMPI_MCA_btl_ofi_verbose=100
```

`FI_LNX_DISABLE_SHM=1` is useful for debugging and performance analysis of LINKx.
