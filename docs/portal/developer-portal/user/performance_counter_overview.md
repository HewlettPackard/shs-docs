# Overview

The HPE Slingshot NIC exposes many hardware performance counters that
help users understand network behavior. The hardware generates the
counters rather than software inferring them, so the counters report
what happened on the NIC rather than what the application or middleware
expected to happen. Users can use the counters to distinguish
network-induced performance issues from issues in the host, GPU, or
application itself.

The counters measure fixed functions, and users cannot program them.
Many counters originated to help engineers debug and validate the NIC
silicon, so this section does not document all \~1300 counters. Instead,
it covers the counters most useful to users and administrators, including
definitions, collection strategies, and example scenarios. This document
does not describe the silicon design in detail, but the taxonomy provides
useful context: each hardware block prefixes the counter names it
generates.

At a high level it is helpful to consider counters in two categories:

- Users running and debugging applications can answer practical
  questions: Did the fabric become congested? Did packets require
  retries? Did network or host backpressure limit performance? These
  counters help users explain run-to-run variation, scaling bottlenecks,
  and unexpected slowdowns by showing whether the NIC delivered or
  dropped packets, how much load the NIC injected into the fabric, and
  whether the network developed congestion. For example, an incast
  pattern such as a naive gather, where many endpoints send to one
  destination, can trigger backpressure that the counters reveal. The
  counters also help users understand latency-sensitive applications
  whose communication delays affect progress even when traffic volume
  remains low and the network appears idle.

- Developers writing or tuning communication libraries and applications
  can use the counters for detailed insight into message matching,
  unexpected messages, rendezvous usage, DMA efficiency, and address
  translation. The counters help developers map communication patterns
  onto NIC hardware resources and identify inefficiencies that can guide
  advanced tuning.

*Users* who are not system administrators can use counters to determine
whether congestion affected their applications. While "blaming the
network" is common, many conditions can cause congestion. Instead of
assuming that an incast of too many senders caused the problem, consider
any condition that prevents the destination from consuming data at the
send rate. Storage rebuilding, GPU memory pressure, CPU overhead,
thermal throttling, and other host activity can slow consumption. When
hosts cannot accept data fast enough, they push back on the NIC. The NIC
then applies backpressure to the network and tells it to slow down. HPE
Slingshot NIC counters help users distinguish network-induced congestion
from host-induced congestion.
