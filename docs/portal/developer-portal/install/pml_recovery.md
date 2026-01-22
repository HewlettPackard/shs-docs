# Configure PML recovery

Starting in the Slingshot Host Software (SHS) 11.1.0 release, PML recovery is supported for edge links. Edge links of earlier SHS versions will flap instead of recovering.

**Note:** PML recovery is only available for HPE Slingshot 200Gbps NICs.

PML recovery is disabled by default and must be enabled on the fabric before configuring it on the host. See the [PML recovery on the fabric](#./pml-recovery-on-the-fabric) section.

PML recovery enables links to recover from transient faults that would otherwise cause the link to flap, without packet loss and only a brief delay in transmission. This can stabilize the fabric by reducing occasional random disruptions.

Links that frequently PML recover require hardware action like repeat flappers. Monitor `HsnPmlRecoveryDetected` and `HsnLinkFlapDetected` Redfish events to identify maintenance candidates.
See the "PML recovery summary events" section of the _HPE Slingshot Administration Guide_ for more information.

Recovery must be enabled on both ends of a link. Use `ethtool` to enable it on the host as follows.

```screen
ethtool --set-priv-flags <hsn-iface> disable-pml-recovery off
```

## PML recovery on the fabric

PML recovery is available for the HPE Slingshot fabric.
See the "Configure PML recovery" section in the _HPE Slingshot Installation Guide_ for the environment you are installing.
