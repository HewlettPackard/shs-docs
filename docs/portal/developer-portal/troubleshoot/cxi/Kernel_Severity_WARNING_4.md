# Kernel Severity:  WARNING (4)

## Errors, Events, and Alerts

* ASIC
  * EC_BADCON_NS
  * EC_BADCON_S
  * EC_COR
* SBL
  * SBL_ASYNC_ALERT_LINK_DOWN
  * CXI_EVENT_LINK_DOWN
  * CXI_EVENT_LINK_UP
* uC
  * ATT1_QSFP_INSERT
  * ATT1_QSFP_REMOVE
  * ATT1_SENSOR_ALERT - Warning
  * ATT1_SENSOR_ALERT - Critical

## 200Gbps NIC State

Hardware encountered an unexpected condition or state. The ASIC is still functional. Whether traffic can flow or not is dependent on the SERDES state.

## Actions

No immediate action is required. Frequent warnings with the same signature are a sign of a hardware issue. For example, frequent link up and down events may be a sign of cable issues.
