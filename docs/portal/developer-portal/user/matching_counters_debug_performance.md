# Using these counters to debug performance

- A healthy application typically shows a high proportion of priority
  matches relative to overflow or software matches. This indicates that
  receives are posted early enough and that hardware matching resources
  are sufficient.
- A simple interpretation rule is: priority matches are "as intended"
  (the receive was posted early enough to match on arrival), while
  overflow matches are the signature of late posting (the message
  arrived first, was held in overflow, and only matched later when a
  receive was posted). A small amount of overflow is normal in real
  applications, but overflow should remain a small fraction of total
  matches; a high overflow fraction often indicates reduced overlap
  between computation and communication.
- Elevated overflow or request counts suggest that receives are being
  posted late, that communication is highly asynchronous, or that
  matching resources are under pressure. For GPU-centric workloads,
  overflow behavior is particularly costly because data held in overflow
  buffers in CPU memory must be transferred into GPU memory which can be
  inefficient.
- Comparing the ratio of priority matches to total matches provides a
  quick assessment of matching efficiency and is often one of the first
  checks when diagnosing performance issues related to messaging.
- While there are counters for the "request" list in this group, note
  this is conceptually different because it is counting messages
  delivered to the software message-queue / software-matching path
  without hardware matching.

## Message matching counter reference

**Message matching counters:**

|**Counter Name**|**Description**|
|---|---|
|`LPE_NET_MATCH_PRIORITY_0`|Number of messages matched on the priority list (receive posted before message arrival).|
|`LPE_NET_MATCH_OVERFLOW_0`|Number of messages delivered to overflow buffers (for example, unexpected messages) because no priority match existed.|
|`LPE_NET_MATCH_REQUEST_0`|Count of messages whose receive matching was performed in software rather than by NIC hardware, indicating fallback from hardware offload because of match mode selection, resource exhaustion, or highly asynchronous communication patterns.|
|`LPE_NET_MATCH_REQUESTS_0`|Number of network requests received by the LPE, including requests that did not match a list and triggered an error response. This is not a count of successful matches.|
|`LPE_NET_MATCH_SUCCESS_0`|Number of network requests successfully completed by the List Processing Engine.|
