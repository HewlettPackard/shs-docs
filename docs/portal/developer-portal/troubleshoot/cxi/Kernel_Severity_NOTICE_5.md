# Kernel Severity: NOTICE (5)

## Errors, Events, and Alerts

- ASIC
  - None
- SBL
  - None
- uC
  - ATT1_ASIC_EPO_TEMPERATURE

## HPE Slingshot CXI NIC State

Healthy

## Actions

None.

## Notes

Temperature EPO is treated as a warning since the NIC driver will not be able to process this alert until the ASIC is power cycled or uC reset at which point the NIC may be healthy again.
