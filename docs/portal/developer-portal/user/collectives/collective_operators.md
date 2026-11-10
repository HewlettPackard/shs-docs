# Collective operators

The following reduction operators are supported (maximum count in parentheses):

**Supported reduction operators:**

|**Operator**|**(u)int8/16/32**|**int64**|**uint64**|**double**|**minmaxloc**|
|:----------|:--------------|:------|:-------|:-------|:----------|
|BAND|yes*|&nbsp;|yes(4)|&nbsp;|&nbsp;|
|BXOR|yes*|&nbsp;|yes(4)|&nbsp;|&nbsp;|
|BOR|yes*|&nbsp;|yes(4)|&nbsp;|&nbsp;|
|MIN|&nbsp;|yes(4)|&nbsp;|yes(4)|&nbsp;|
|MAX|&nbsp;|yes(4)|&nbsp;|yes(4)|&nbsp;|
|SUM|&nbsp;|yes(4)|&nbsp;|yes(4)|&nbsp;|
|REPSUM|&nbsp;|&nbsp;|&nbsp;|yes(1)|&nbsp;|
|MINMAXLOC|&nbsp;|&nbsp;|&nbsp;|&nbsp;|yes(1)|

**Note:** `BAND`, `BXOR`, and `BOR` do not test to reject collections of signed 8/16/32 bits, but reduce them as packed collections of up to 4 `uint64_t`.

## New operator: `MINMAXLOC`

The `minmaxloc` operation performs a minimum and a maximum in a single operation, returning both the minimum and maximum values, along with the index of the endpoint that contributed that minimum or maximum.

It can be used to implement the `MINLOC` or `MAXLOC` operations by simply setting the unwanted fields to zero and ignoring the result.

The `minmaxloc` structure is specialized:

**MINMAXLOC structure fields:**

|**Offset**|**Field**|**Data Type**|
|:-------|:----------|:----------|
|0|minval|int64|
|8|minidx|uint64|
|16|maxval|int64|
|24|maxidx|uint64|

## New operator: `REPSUM`

The REPSUM operator uses the REPROBLAS algorithm described in the following document:

[REPROBLAS technical report](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2016/EECS-2016-121.pdf)

Algorithm 7 provides extended-precision double precision summation, with associative behavior (summation is order-independent).

Because the summation occurs within a multicast tree that may take different paths through the fabric on different runs based on other jobs that are running and using the fabric, the order of summation within the reduction cannot be generally predicted or controlled.
The well-known ordering problem of double-precision floating point can lead to varying results on each run.

The REPSUM algorithm improves on the accuracy of the summation by implicitly adding more bits to the computations, but more importantly, guarantees that all additions are associative, meaning they are order-independent.
