# CXI HealthCheck

The HPE Slingshot 200Gbps NIC software stack includes the `pycxi-utils` package, which contains a health and diagnostic utility that was developed using the `pycxi` library. This utility can be used to monitor the health and troubleshoot HPE Slingshot 200GB NIC issues.

## `cxi_healthcheck`

The `cxi_healthcheck` utility helps you to verify the health of an HPE Slingshot 200GB NIC.
It checks the following items:

- PCIe speed and width
- Presence of PCIe errors
- Algorithmic MAC assignment (optional)
- Link state and speed
- Link-layer retry setting is enabled
- Internal loopback mode is disabled
- Priority Flow Control (PFC) is enabled
- Acceptable number of link flaps in the past hour (< 5) and the past 10 hours (< 10)
- Presence of common error messages related to HPE Slingshot 200GB NIC in the kernel log
- Services (retry handler, etc.) are in a running state (optional)
- Resource and retry handler leak detection
- Successful ping from HPE Slingshot 200 GB NIC interface to an external host / interface (optional)
- Good, corrected, and uncorrected codeword rate check
- Firmware revision check (optional)

This utility is found in the `pycxi-utils` package and must be run as a privileged user.

## Running the diagnostic

Running cxi_healthcheck requires root privileges. It runs on compute nodes only. The '--not_idle' option must be used when running `cxi_healthcheck` on a non-idle system where traffic is flowing. This helps to avoid false positives that may occur when a system is in a non-idle state.

_**Usage**_

```screen
usage: cxi_healthcheck [-h] [--devices DEVICES] [--drain_precheck] [--drain]
                       [--redeem] [--status_dir STATUS_DIR]
                       [--ping_host PING_HOST] [--ping_ifaces [PING_IFACES]]
                       [--services [SERVICES]] [--mac_addr [MAC_ADDR]]
                       [--fw [FW]] [-v] [--not_idle]

This script provides a number of checks to verify the health of a Cassini
interface. It can be run as a standalone script or invoked via a wrapper
script using Slurm's Prolog, Epilog, or HealthCheckProgram options. This
script typically completes in a few seconds, but it may take up to ~60 seconds
when additional time is required for the devices to be in a quiesced state.

optional arguments:
  -h, --help            show this help message and exit
  --devices DEVICES     Comma separated list of device numbers to check
                        (0,1,etc.)
  --drain_precheck      Check that node is not in drain state prior to running
                        the healthcheck. Note that this check will pass if the
                        node was put into the drain state by the --drain
                        option.
  --drain               Drain node in slurm on failure
  --redeem              Resume node in slurm on pass
  --status_dir STATUS_DIR, -s STATUS_DIR
                        Directory to store a file containing the results of
                        each check
  --ping_host PING_HOST
                        Name of host to ping. Requires --ping_ifaces option.
  --ping_ifaces [PING_IFACES]
                        Perform ping from the Cassini interfaces in the
                        --devices parameter to the host defined in
                        --ping_host. An optional comma-separated list of
                        network interfaces (hsn0,hsn1,etc.) can be supplied
                        for this check. Requires --ping_host option.
  --services [SERVICES]
                        Verify services are running. If no services are
                        provided with this option, the Retry Handler service
                        will be checked for all devices associated with the
                        --devices parameter. Optionally, a comma-separated
                        list of services to check can be provided
                        (cxi_rh@cxi0,cxi_rh@cxi1,etc.)
  --mac_addr [MAC_ADDR]
                        Checks that Cassini MAC addresses associated with the
                        --devices parameter begin with "02:". An optional
                        comma-separated list of network interfaces
                        (hsn0,hsn1,etc.) can be supplied for this check.
  --fw [FW]             Checks Cassini FW version. If a version is not
                        supplied with this option, the FW version is expected
                        to match the installed slingshot-firmware-cassini RPM
                        version (and will fail if this RPM is not found on the
                        node).
  -v                    Enable verbose test output
  --not_idle            Use this option when running the healthcheck on a
                        Cassini interface that is in a non-idle state (i.e.
                        traffic is running). This option will skip checks that
                        are likely to fail on an active system.
```

**Examples:**

In this example, the `cxi_healthcheck` utility runs with default checks on interface cxi0:

```screen

system:/ # cxi_healthcheck --device 0
---------- Health Check Summary ----------
Check: pci_check  Result: Pass
Check: mac_check  Result: Skip
Check: link_check  Result: Pass
Check: link_properties_check  Result: Pass
Check: link_flap_check  Result: Pass
Check: dmesg_check  Result: Pass
Check: service_check  Result: Pass
Check: run_idle_check  Result: Pass
Check: trs_leak_check  Result: Pass
Check: ping_check  Result: Skip
Check: codeword_rate_check  Result: Pass
Check: pci_error_check  Result: Pass
Check: fw_version_check  Result: Skip
```

In this example, the `cxi_healthcheck` utility runs with all checks enabled on interface cxi0:

```screen
system:/ # cxi_healthcheck --device 0 --mac_addr --ping_ifaces
--ping_host 10.150.0.99 --fw 1.5.41
---------- Health Check Summary ----------
Check: pci_check  Result: Pass
Check: mac_check  Result: Pass
Check: link_check  Result: Pass
Check: link_properties_check  Result: Pass
Check: link_flap_check  Result: Pass
Check: dmesg_check  Result: Pass
Check: service_check  Result: Pass
Check: run_idle_check  Result: Pass
Check: trs_leak_check  Result: Pass
Check: ping_check  Result: Pass
Check: codeword_rate_check  Result: Pass
Check: pci_error_check  Result: Pass
Check: fw_version_check  Result: Pass
```

