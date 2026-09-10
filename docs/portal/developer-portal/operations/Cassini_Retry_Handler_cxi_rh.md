# Cassini retry handler (`cxi_rh`)

The Cassini Retry Handler (`cxi_rh`) is part of the HPE Slingshot network.
It handles events from the HPE Slingshot NIC by building retry state for a connection and retrying messages.
For ordered traffic, it retries messages in sequence so that an earlier message is retried before later messages.
For unordered traffic, it retries each eligible message as soon as possible, without waiting for earlier messages in the sequence.

Retransmission is necessary when network errors cause packets to be dropped or when target resources are unavailable.
The retry handler identifies these conditions as "Timeouts" and "NACKs", respectively.

- **Timeouts**: Indicates that a packet was sent but a response was not received within the expected time.
  This could mean that the request packet never made it to its destination or that the response from the destination never made it back to the source.
  Link flaps are a common reason packet timeouts may be observed.
- **NACKs**: Indicates that the target NIC observed some issue with a packet it received.
  A lack of space to land the packet could result in various NACKs being sent back to the source (depending on which resource was lacking).
  The most common NACK that is typically seen is a SEQUENCE_ERROR NACK. This simply indicates that a packet with an incorrect sequence number arrived. This is not an unusual situation.
  A prior packet being lost (say sequence number X) will lead to subsequent packets (all with sequence numbers greater than X) getting a SEQUENCE_ERROR NACK in response.

## Event handling summary

| Event type | Trigger | Expected software action |
| --- | --- | --- |
| Timeout | An in-flight packet does not complete within the configured timeout window. | Hardware marks the entry as timed out. The RH builds retry state for the connection, if applicable, and retries packets in sequence for ordered traffic. |
| NACK | The receiver rejects a message because of a sequence, resource, or state problem. | Build retry state, classify the entry as retryable or non-retryable, and retry eligible messages in sequence order for ordered traffic. |
| Retry complete | A previously retried packet receives a good response from the target. | Clear the retry state associated with this packet and, if applicable, with the connection. |
| SCT timeout | A connection that was attempting to clean up did not receive a response to a request to close target resources. | Retry the close or move on, according to RH policy. |
| TCT timeout | A target connection received no additional data packets or cleanup request. | Query target connection state and associated resources, and clean up this half of the connection. |
