# Unexpected event type

The following errors occur when the client sends a packet and does not receive a response.

_Server:_

```screen
recv() failed: Connection reset by peer
Post-run handshake failed: Connection reset by peer
```

_Client:_

```screen
Unexpected event type: ACK (9) Expected TRIGGERED_OP
event RC != RC_OK: CANCELED
Failed to get initiator ACK TRIGGERED_OP event: No message of desired type
```

When High rate puts (HRP) are used, the RC might instead be HRP_RSP_DISCARD. This means that the packet made it as far as the switch.

```screen
Unexpected event type: ACK (9) Expected TRIGGERED_OP
event RC != RC_OK: HRP_RSP_DISCARD
Failed to get initiator ACK TRIGGERED_OP event: No message of desired type
```

If the RC is PKTBUF_ERROR, the node logs must be checked for pfc_fifo_oflw errors. This means the switch QoS configuration has not been applied correctly.

```screen
Unexpected event type: ACK (9) Expected TRIGGERED_OP
event RC != RC_OK: PKTBUF_ERROR
Failed to get initiator ACK TRIGGERED_OP event: No message of desired type
```

```screen
[ 1451.997298] cxi_ss1 0000:21:00.0: HNI error: pfc_fifo_oflw (40)
[ 1452.002035] cxi_ss1 0000:21:00.0:   pfc_fifo_oflw_cntr: 218
[ 1452.005821] cxi_ss1 0000:21:00.0: IXE error: pbuf_rd_err (48)
[ 1452.009456] cxi_ss1 0000:21:00.0:   pbuf_rd_errors: 105
```

These errors indicate that the link is not up or something is incorrectly configured.

- Verify the link state on both the NIC and the switch.
- Verify that the NIC's AMA has been applied and is correct.
- Verify that the switch routing configuration and QoS configuration have been applied and are correct.
