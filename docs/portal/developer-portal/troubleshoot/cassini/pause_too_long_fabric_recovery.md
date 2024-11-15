# Fabric recovery

When the HPE Slingshot switch ASIC detects `pause too long` condition, the HPE Slingshot switch driver asserts an alert to indicate link is in `pause too long` state. Then the driver removes the load on the node to recover the link from `pause too long` state while allowing the link to stay up.

The driver achieves this by configuring the `R_PF_EEG_SIZE_CFG` register max frame size value to less than the minimum frame size threshold value. This will cause any packets sent to the node to be discarded instead of sending the packets.
The driver also stops honoring PFC from the node by setting `PCP_ENABLE` bit to 0 to prevent fabric from being clogged up because the NIC will assert pause and hence causes `HOLB(Head Of Line Blocking)` with other non-congesting traffic within the body of the fabric.
The driver then monitors `pause timeout(R_TF_CFTX_STS_PAUSE_TIMEOUT)` status to determine when the NIC has stopped asserting pause and then reverts the max frame size and PCP enable settings to default. The driver sends an event up the stack to the Fabric Manager, which then clears its view of which ports are in a `pause too long` state.

## Pause too long assertion log messages (`/var/log/messages`)

```screen
<3>1 2019-02-14T12:57:32.927818+00:00 x0c0r4b0 kernel - - - [ 9943.791452] rossw rossw0: pm 19: pause too long detected, chan timeouts 0x0
<11>1 2019-02-14T12:57:32.929731+00:00 x0c0r4b0 fabric_routing 3960 - -  Error: Node connected to port 19 (port name: x0c0r4j3p1) has asserted Ethernet flow control pause for too long
<11>1 2019-02-14T12:57:32.930043+00:00 x0c0r4b0 fabric_routing 3960 - -  Port 19 (port name: x0c0r4j3p1) has moved to an error state. Reason: ERROR_STATE_ETHERNET_FLOW_CONTROL_TOO_LONG
```

## Pause too long clear log messages (`/var/log/messages`)

```screen
<14>1 2019-02-14T12:57:33.120815+00:00 x0c0r4b0 fabric_routing 3960 - -  Port 19 (port name: x0c0r4j3p1) has stopped asserting pause for too long.
<14>1 2019-02-14T12:57:33.121175+00:00 x0c0r4b0 fabric_routing 3960 - -  Port 19 (port name: x0c0r4j3p1) is no longer in an error state
```
