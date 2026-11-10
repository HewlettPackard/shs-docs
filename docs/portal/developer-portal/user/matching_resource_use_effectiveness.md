# Matching resource use effectiveness

There are four lists on each LPE.

- **Priority List:** this is used for hardware matching of messages to
  pre-posted receives. This is the highest performance path.
- **Overflow List:** if an unexpected message arrives, meaning there is no
  receive buffer posted, the message is parked in an overflow buffer.
  There is a set of wildcard filters that go in an Overflow list
  determine whether to park the message in the overflow buffer, or have
  the NIC reject the message. Those wildcard filters can be configured
  by the software, which can be configured to be too permissive.
- **Request List:** this list is used to steer messages to a software
  matching endpoint, with data written to the software receive buffers
  to be processed in the software stack.
- **Unexpected List:** when an unexpected message is parked in the
  overflow buffer, and an entry is made into the unexpected list. That way,
  when the receive buffer location is processed in a subsequent message,
  the data can be transferred from the overflow message buffer into the
  right destination memory.

When a message comes in and is matched on the first three of these, the
corresponding counters get incremented: `LPE_NET_MATCH_PRIORITY_0`,
`LPE_NET_MATCH_OVERFLOW_0`, `LPE_NET_MATCH_REQUEST_0`.

A different counter with a similar name - `LPE_NET_MATCH_REQUESTS_0` -
counts the number of match requests LPE block receives, which includes
requests that did not match on any lists and triggered an error
response.
