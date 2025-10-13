# Kernel Severity: CRIT (2)

## Errors, Events, and Alerts

- ASIC
  - EC_UNCOR_NS
  - EC_UNCOR_S
  - EC_CRIT
- SBL
  - SBL_ASYNC_ALERT_SERDES_FW_CORRUPTION
- uC
  - ATT1_QSFP_EPO_TEMPERATURE
  - ATT1_SENSOR_ALERT - Fatal

## HPE Slingshot CXI NIC State

The NIC is unusable. The NIC driver will disable all current access and prevent future access to the impacted device.

## Actions

- Workload manager drains node
- Check of the node `env`
  - For example, no algae growing in cooling tubes
- NIC goes through a power cycle
- NIC undergoes diags
- If the problems persist, replace the NIC
