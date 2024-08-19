# Telemetry Metrics and Counters

The Fabric Manager collects metrics and counters from the switch agents and controllers. It also generates fabric health metrics to track the running state of the system (Traffic, Congestion, & Runtime). Configure the Telemetry Endpoint for enabling the Telemetry for HSN. See the "Telemetry and Fabric Health" section of the _HPE Slingshot Administration Guide_ for more information.

All telemetry data is cached in the Fabric Manager and can be queried via odata queries. When querying via Odata query, the query can be filtered to select a category of metrics by using PhysicalContext = .Metric. For instance Congestion.rxBW.

The various type of telemetry data that can be used to analyze performance issues include the following:

## Cray Fabric Telemetry

Cray Fabric Telemetry is telemetry data generated by the switch agents associated with port runtime information.

## Cray Fabric Performance Telemetry

Cray Fabric Telemetry is telemetry data generated by the switch agents associated with per port utilization/congestion.
Congestion metrics are collected and posted based on a configurable periodic timer. The counters associated with RFCs
are optionally configurable and disabled by default. Enabling a category of RFC counters (for example, RFC3635) enables collection
of all counters in the group.

## Cray Fabric Critical Telemetry

Cray Fabric Critical Telemetry is telemetry data generated by the switch agents associated with critical port errors. These
errors are posted on occurrence. HardwareErrors are errors which should not occur and require immediate attention.

## Cray Fabric Health Telemetry

Cray Fabric Health Telemetry is telemetry data generated by the fabric manager to track the health of the system. Fabric
Health events are posted on error occurrence as well as when the error clears and a healthy state is reached. These include
Traffic, Configuration and Runtime data.