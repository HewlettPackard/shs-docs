# Introduction

The Cassini Retry Handler (`cxi_rh`) is an integral part of the HPE Slingshot 200Gbps network.
It handles events from the HPE Slingshot 200Gbps NIC to provide end-to-end retransmission when necessary.

Retransmission is necessary when packets are dropped because of errors in the network.
It is also required when the target resources needed to receive packets are exhausted.
The retry handler identifies these scenarios as "Timeouts" or "NACKs" respectively.

- **Timeouts**: Indicates that a packet was sent but a response was not received in a timely fashion.
  This could mean that the request packet never made it to its destination or that the response from the destination never made it back to the source.
  Link flaps are a common reason packet timeouts may be observed.
- **NACKs**: Indicates that the target NIC observed some issue with a packet it received.
  A lack of space to land the packet could result in various NACKs being sent back to the source (depending on which resource was lacking).
  The most common NACK that is typically seen is a SEQUENCE_ERROR NACK. This simply indicates that a packet with an incorrect sequence number arrived. This is not an unusual situation.
  A prior packet being lost (say sequence number X) will lead to subsequent packets (all with sequence numbers greater than X) getting a SEQUENCE_ERROR NACK in response.
