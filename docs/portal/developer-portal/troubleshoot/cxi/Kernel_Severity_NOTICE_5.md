# Kernel Severity: NOTICE (5)

## Errors, Events, and Alerts

* ASIC
  * None
* SBL
  * None
* uC
  * ATT1_ASIC_EPO_TEMPERATURE

## 200Gbps NIC State

Healthy

## Actions

None.

## Notes

Temperature EPO is treated as a warning since the 200Gbps NIC driver will not be able to process this alert until the ASIC is power cycled or uC reset at which point the 200Gbps NIC may be healthy again.

