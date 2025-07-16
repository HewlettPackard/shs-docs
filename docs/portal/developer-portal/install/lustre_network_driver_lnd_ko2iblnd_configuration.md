# Configure ko2iblnd Lustre Network Driver (LND) for Soft-RoCE performance

The ko2iblnd.ko module requires modifications to optimize Soft-RoCE performance.
If your setup does not involve Soft-RoCE connections, this section does not apply.

## Prerequisites

Ensure that Lustre is installed with the ko2iblnd module built for the Soft-RoCE driver (RXE) by specifying `--with-o2ib=yes` for `/.configure` or `rpmbuild`.
If this option is not specified, the build process will attempt to automatically detect external OFED installations or internal o2ib support.
If neither is detected, the ko2iblnd module will not be built.

For detailed instructions, see the _Cray ClusterStor Lustre Client Build Configuration Guide S-9100_.
