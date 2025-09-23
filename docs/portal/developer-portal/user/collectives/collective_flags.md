# Collective flags

Calling any reduction function normally submits the reduction to the fabric.

In collective practice, multiple threads are used on a given compute node, each representing a separate reduction rank.
One of these ranks is designated the "captain rank," which pre-reduces data from each of the ranks (including itself) before initiating the multi-endpoint reduction.

The local reduction is typically performed using normal C operators, such as sum, multiply, logical operations, or bitwise operations.

Accelerated collectives provide two "novel" operators, the `MINMAXLOC` operator and the `REPSUM` operator.

To allow these functions to be easily used, the `FI_MORE` flag can be specified for any accelerated collective reduction. which informs the reduction that more data is expected. This reduces data (in software) and holds the reduction data without submitting it to the fabric.
This can be repeated any number of times to continue to accumulate results.
When a subsequent reduction is performed without the `FI_MORE` flag, the supplied value is taken as the final contribution, is locally reduced with the existing reduction data, and the result is submitted to the fabric for collective reduction across endpoints.

This mechanism can be used for any operator, such as `FI_SUM`, but this is not generally the most efficient way to do this, since the normal addition operators are available in C.
