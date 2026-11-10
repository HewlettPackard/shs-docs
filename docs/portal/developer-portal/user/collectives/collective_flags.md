# Collective flags

Calling any reduction function normally submits the reduction to the fabric.

In collective practice, multiple threads are used on a given compute node, each representing a separate reduction rank.
One of these ranks is designated the "captain rank," which pre-reduces data from each of the ranks (including itself) before initiating the multi-endpoint reduction.

The local reduction is typically performed using normal C operators, such as sum, multiply, logical operations, or bitwise operations.

Accelerated collectives provide two "novel" operators, the `MINMAXLOC` operator and the `REPSUM` operator.

`FI_SUM` is also an `fi_op` reduction operator, not a flag.
`fi_broadcast()` does not support flags.
`fi_reduce()` and `fi_allreduce()` support `FI_MORE` and `FI_CXI_PRE_REDUCED`:

- `FI_MORE` accumulates locally into an opaque `struct cxip_coll_accumulator` without submitting to the fabric. It can be specified on successive reductions to continue accumulating. A subsequent reduction without `FI_MORE` adds the final contribution and submits the result to the fabric.
- `FI_CXI_PRE_REDUCED` overloads `FI_SOURCE` and indicates that `buf` points to a pre-reduced `struct cxip_coll_accumulator`.
