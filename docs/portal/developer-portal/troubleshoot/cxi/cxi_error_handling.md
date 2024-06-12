
# Kernel Severity:  EMERG (0)

## Errors, Events, and Alerts

* ASIC
	* None
* SBL
	* None
* uC
	* None

## 200Gbps NIC State

N/A

## Actions

None.

# Kernel Severity:  ALERT (1)

## Errors, Events, and Alerts

* ASIC
  * None
* SBL
  * None
* uC
  * None

## 200Gbps NIC State

N/A

## Actions

None.

# Kernel Severity:  CRIT (2)

## Errors, Events, and Alerts

* ASIC
  * EC_UNCOR_NS
  * EC_UNCOR_S
  * EC_CRIT
* SBL
  * SBL_ASYNC_ALERT_SERDES_FW_CORRUPTION
* uC
  * ATT1_QSFP_EPO_TEMPERATURE
  * ATT1_SENSOR_ALERT - Fatal

## 200Gbps NIC State

200Gbps NIC is unusable. The 200Gbps NIC driver will disable all current access and prevent future access to the impacted device.

## Actions

* Workload manager drains node
* Check of the node `env`
  * For example, no algae growing in cooling tubes
* NIC goes through a power cycle
* NIC undergoes diags
* If the problems persist, replace the NIC

# Kernel Severity:  ERR (3)

## Errors, Events, and Alerts

* ASIC
  * EC_DEGRD_NS
* SBL
  * None
* uC
  * None

## 200Gbps NIC State

200Gbps NIC is functioning in a degraded state.

## Actions

At the bare minimum, the NIC must be power cycled (cold reset), which typically requires a node power cycle, to reset the NIC to not be functioning in a degraded state. Frequent errors is a sign hardware may have to be replaced.

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

# Kernel Severity:  INFO (6)

## Errors, Events, and Alerts

* ASIC
  * EC_SFTWR
  * EC_INFO
  * EC_TRS_NS
  * EC_TRS_S
  * EC_TRNSNT_NS
  * EC_TRNSNT_S
* SBL
  * None
* uC
  * ATT1_UC_RESET

## 200Gbps NIC State

Healthy

## Actions

None.

# Kernel Severity: DEBUG (7)

## Errors, Events, and Alerts

* ASIC
  * None
* SBL
  * None
* uC
  * ATT1_ASIC_PWR_UP_DONE

## 200Gbps NIC State

Healthy

## Actions

None.
