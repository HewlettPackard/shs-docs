# The LINKx (LNX) Provider

Enabling the LNX Provider when building Libfabric allows applications to leverage multiple NICs or providers simultaneously, improving flexibility and performance.

For detailed setup instructions and usage examples, including integration with the `cxi` and `shm` providers, see the [`fi_lnx(7)` man page](https://ofiwg.github.io/libfabric/v2.3.0/man/fi_lnx.7.html).

## How to run OpenMPI and Libfabric with LINKx on HPE Slingshot

The following is an example of how to configure the necessary environment variables to run a basic internode, point-to-point communication micro-benchmark using OpenMPI and Libfabric with LINKx on HPE Slingshot systems.
In this example, both the `rocm` module and the compute node architecture-specific `craype-accel-amd-gfx` module are loaded.

1. Configure the OpenMPI-specific environment variables.

    ```screen
    export OMPI_MCA_mtl="ofi"
    export OMPI_MCA_btl="^tcp,ofi,vader,openib” # customize as needed
    export OMPI_MCA_pml="^ucx” # customize as needed
    export OMPI_MCA_opal_common_ofi_provider_include=”lnx"
    export PMIX_MCA_psec=“native”
    export PMIX_MCA_gds=“hash”
    ```

2. Configure the Libfabric (2.1.0 and newer) environment variables.

    The following example specifies a per‑device stripe.
    To have Libfabric automatically stripe messages across all available CXI devices instead, set `FI_LNX_PROV_LINKS="shm+cxi"`.

    ```screen
    export FI_LNX_PROV_LINKS="shm+cxi:cxi0|shm+cxi:cxi1|shm+cxi:cxi2|shm+cxi:cxi3"
    export FI_LNX_DISABLE_SHM=0
    export FI_SHM_USE_XPMEM=1
    export LD_LIBRARY_PATH=/opt/cray/libfabric/2.2.0rc1/lib64:$LD_LIBRARY_PATH
    ```

3. Launch a basic internode point-to-point communication micro-benchmark.

    In the following example:

    - SCALE_OPTS=`--nodes=2 --ntasks-per-node=1`
    - ADDITIONAL_OPTS=`--cpu-bind=map_cpu:1`
    - If running on a single node, you may have to include `--network=single_node_vni`

    ```screen
    srun --mpi=pmix ${SCALE_OPTS} ${ADDITIONAL_OPTS} ./set_gpu_affinity.sh ./osu_bibw -c -d rocm D D
    ```
