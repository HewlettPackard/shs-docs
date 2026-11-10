# Hardware match engine effectiveness

These counters are useful when diagnosing high-scale behavior where
matching resources and packet buffer occupancy interact, or when trying
to understand whether the matching engines are operating near their
throughput limits. High match-attempt counts can indicate heavy matcher
activity even if higher-level match outcome counters (such as
priority/overflow/software match) look reasonable. For context, MPI
codes (or MPI libraries on their behalf) often create long
posted-receive lists by keeping many nonblocking receives outstanding
(for example, posting a "bank" of MPI_Irecv buffers), and they create
wildcard-heavy matching - receives by using `MPI_ANY_SOURCE` /
`MPI_ANY_TAG`, which forces the receive-side matcher to consider more
candidate receives per arriving message, increasing match work. This
can potentially degrade performance by forcing the LPE engine to work
harder to find matches for network requests. If this grows
disproportionately relative to successful matches, it can indicate
inefficient matching (long lists, heavy wildcard use, or high unexpected
traffic) and potential matching-engine pressure.

These counters are best analyzed as a derived metric that calculates the
average number of match attempts made by the List Processing Engine for
each successfully matched network message.

Attempts per Matched Message = *(lpe_sts_net_match_attempts_0) / (lpe_net_match_priority_0 + lpe_net_match_overflow_0 + lpe_net_match_request_0)*

- `lpe_sts_net_match_attempts_0`
  
  Number of match attempts made for requests. Sum over 32 matchers, each of which can match every 4 cycles.

- `lpe_sts_app_match_attempts_0`

  Number of match attempts made for appends. Sum over 32 matchers, each of which can match every 4 cycles.
  
  *Effort spent matching "append" style operations (for example, operations that add entries to match structures). High values can point to append-heavy workloads or matcher contention, which can contribute to additional overhead and latency.*
