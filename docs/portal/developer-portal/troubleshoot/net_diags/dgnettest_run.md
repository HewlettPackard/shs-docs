
# `dgnettest_run.sh`

While `dgnettest` can be run as a standalone test for troubleshooting specific
issues, it must run multiple times to get a full picture of the
state of a system. The script `dgnettest_run.sh` makes this easier by running the
`dgnettest` in a number of configurations. There are four test configurations that
`dgnettest_run.sh` runs.

**Loopback:** This configuration runs the loopback bandwidth test.

**Latency:** This configuration runs the latency test. By default, it is
excluded from the test list. It can be included by providing `dgnettest_run.sh`
with test list arguments that include `latency`. Note that specifying the test
list requires supplying a set size value with `-s` as well.

**Switch:** This configuration runs the bisect bandwidth and all2all tests
using the `dgnettest` option `-S` to display statistics. The set size is the
number of edge ports on a switch, which is chosen based on the network class
of the system, optionally specified with the `dgnettest_run.sh` option `-c`.

**Group:** This configuration runs the bisect bandwidth and all2all tests
using the `dgnettest` option `-S` to display statistics. The set size is 512,
which is the number of nodes in a high-density cabinet.
