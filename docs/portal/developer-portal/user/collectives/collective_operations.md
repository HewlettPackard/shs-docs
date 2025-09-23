# Collective operations

All collective operations are asynchronous and must be progressed by polling the Completion Queue (CQ).

Only eight concurrent reductions can be performed on a given multicast tree. Attempts to exceed this limit will result in the `-FI_EAGAIN` error, and the operation should be retried after polling the CQ at least once.

All collective operations below are syntactic variants based on `fi_allreduce()`, which is the only operation supported by accelerated collectives.
