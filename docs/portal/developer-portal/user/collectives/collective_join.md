# Collective join

"Joining" a collective is the process by which a collective group is created. Each endpoint in the collective group must "join" the collective before it can participate in the collective.
The join operation itself is a collective, and no endpoint can proceed from the join until all endpoints in that group have joined.

**Note:** `libfabric` endpoints in the CXI provider represent NICs, and each NIC can be individually joined to the collective. MPI applications use the term RANK to represent compute processes, and these typically outnumber endpoints. These RANKS must be locally reduced before submitting the partial results to the fabric endpoint.

The following system-wide considerations apply to joining collectives:

1. Only endpoints included within a WLM JOB can be joined to a collective.
1. Collective groups may overlap (for instance, an endpoint can belong to multiple collective groups).
1. The number of collective groups in a job is limited (see `FI_CXI_HWCOLL_ADDRS_PER_JOB`).
1. Any endpoint can serve as HWRoot for _at most_ one collective group.
