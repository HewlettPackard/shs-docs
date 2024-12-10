# Tag matching mode settings (`FI_CXI_RX_MATCH_MODE`)

The CXI provider supports three different operational modes for tag matching: hardware, hybrid, and software.
Hardware tag matching (`FI_CXI_RX_MATCH_MODE=hardware`) offers performance benefits as matching on the host is expensive in terms of CPU and memory bandwidth utilization.
Hardware match mode is appropriate for users who can ensure the sum of unexpected messages and posted receives will not exceed the configured hardware receive resource limit for the application. Hardware matching is the default setting.

Hybrid match mode (`FI_CXI_RX_MATCH_MODE=hybrid`) is appropriate for users who are unsure if the sum of unexpected messages and posted receives will not exceed the configured hardware receive resource limit for the application but want to ensure they application still functions if hardware receive resources are consumed.
Hybrid match mode extends hardware match by allowing for an automated transition into software match mode if resources are consumed.
Hybrid is generally a good mode to run in over just hardware matching, but the trade-off is that it requires approximately eight MB per rank/domain of additional host memory consumption even if the rank never transitions use the software match.

Software match mode (`FI_CXI_RX_MATCH_MODE=software`) is appropriate for users who know the sum of unexpected messages and posted receives will exceed the configured hardware receive resource limit for the application.
In software match mode, the CXI provider maintains an unexpected software and posted receive list rather than offloading to hardware.
This avoids having to allocate a hardware receive resource for each unexpected message and posted receive.
This will consume approximately eight MB per rank/domain of additional host memory consumption.

## Hardware matching

When hardware receive resources are consumed (list/match entries or overflow buffers), receive operations can be disabled to ensure that the match order is maintained as the provider attempts to recover hardware resources.
If resources can be recovered, operation can be resumed. Otherwise a different receive match mode is required (hybrid or software).
During the resource recovery process, side-band communication is required to synchronize re-enablement of the receive function. An improperly sized side-band communication event queue can lengthen the recovery time at scale.

For this reason, with SHS release 2.1.1 and beyond, hybrid can be set as the global default, albeit at the cost of host memory and can avoid this situation. See the next section for more information on configuring hybrid match mode.
The current default setting is hardware matching, and Cray MPI uses hardware matching, both largely as a legacy of prior releases when the hybrid matching was not performing optimally.

Running with `FI_LOG_LEVEL=warn` and `FI_LOG_PROV=cxi` will report if this flow control transition is happening. This can be useful to understand other application failures because there are other scenarios where software and hybrid match modes may still enter flow control: if a user is not draining the Libfabric completion queue at a reasonable rate, corresponding hardware events may fill up which will also trigger flow control. In practice, dependent processes (For example, parallel jobs) will most likely be sharing a common receive hardware resource pool.

## Hybrid match mode configuration options

Hybrid Match Mode has further configurability to ensure the process requiring more hardware receive resources does not consume them all which would force all the other processes to be forced into the software match mode.
For example, considered a parallel application which has multiple processes (For instance, ranks) per NIC all sharing the same hardware receive resource pool. Suppose that the application communication pattern results in an all-to-one communication to only a single rank (For example, rank 0) while other ranks may be doing communication among each other.
If the width of the all-to-one exceeds hardware resource consumptions, all ranks on the target NIC will transition to software match mode. The preemptive options help ensure that only rank 0 would transition to software match mode instead of all the ranks on the target NIC.

The `FI_CXI_HYBRID_POSTED_RECV_PREEMPTIVE` and `FI_CXI_HYBRID_UNEXPECTED_MSG_PREEMPTIVE` environment variables enable users to control the transition to software match. One approach is to set the receive size attribute to expected usage, and if this expected usage is exceeded, only the offending endpoints will transition to software match mode.

`FI_CXI_HYBRID_PREEMPTIVE` and `FI_CXI_HYBRID_RECV_PREEMPTIVE` environment variables will force the transition to software match mode when hardware receive resources in the pool are running low. The CXI provider will do a multi-step process to transition the Libfabric endpoint to software match mode.
The benefit of running with these enabled is that the number of endpoints transitioning to software match mode may be smaller when compared to forced software match mode transition due to zero hardware resources available.
These two settings are disabled by default by setting the value to zero.
