# The retry handler

The retry handler is a user-space service in the NIC driver stack that works in conjunction with NIC functions including a temporary packet cache to provide last-resort end-to-end recovery for RDMA transactions.
Its role is to track whether requests complete successfully, and when they do not, replay the affected transmission without disrupting the application. (It is implemented in user space rather than kernel space for performance.)

The NIC driver invokes the retry handler when a request does not complete normally.
The two primary trigger conditions are a timeout, meaning the target does not respond within the expected time window, and a negative acknowledgement (NACK), meaning the target responds but cannot process the request at that moment.
In both cases, the retry handler attempts recovery by replaying the transaction.

An unresponsive endpoint or a transient network disturbance, such as a link flap that drops a packet, causes timeouts.
Most transient loss conditions are handled automatically by lower-level hardware and fabric mechanisms like link-level retry, but a small fraction can still escape those protections because of the time it takes the fabric manager to detect and push new routes around a down link.  

Temporary unavailability of NIC or host resources needed to process a packet usually causes NACKs. An unrestricted transport flow can also generate a NACK when the network drops a packet and subsequent packets arrive out of order before the flow processes the missing packet.
This sequence-related NACK error requires the retry handler to replay the transfers in order.

From a user perspective, the retry handler preserves correctness by replaying lost or blocked transactions successfully or reporting them as failed. However, retries and their associated backoff consume time, introduce stalls, and can increase latency.
In a healthy run, retry activity caused by timeouts is typically near zero. When retry activity rises, applications often complete but may run slower and show run-to-run variability.

If the retry handler exhausts its retry policy (typically four times) in the presence of faulty hardware or a persistent endpoint problem, it cancels the connection and allows the error to propagate through Libfabric and higher-level middleware.
In practice, this causes MPI jobs to abort, while Lustre may engage its own retry behavior.

The retry handler counters are an important tool for users to understand how the network is affecting their application behavior and retry handler logs can identify target endpoints that are the source of communication disruption.
As a general rule, treat time-out-driven retry activity as a yellow-to-red warning signal: near-zero is the normal baseline, low non-zero values can explain mild slowdowns and tail latency, and high or connection-canceling values usually indicate a real fault that requires prompt administrative attention.
By contrast, high NACK counts are not always signs of a fabric fault; they may be normal for a workload, or they may indicate an opportunity to improve application communication patterns or resource usage.

Later sections describe how to use retry handler counters to narrow root causes.
