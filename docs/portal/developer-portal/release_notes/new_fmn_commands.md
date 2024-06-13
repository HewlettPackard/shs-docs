
# Appendix B: Slingshot FMN Command Changes

## Slingshot 2.1.0

| 1.0.0                            | 2.1.0                          | Description                                           |
|:---------------------------------|:-------------------------------|:------------------------------------------------------|
| fmn\_bound_\_ports               | fmn-reset-port                 | 1.0.0 command is subject to replace in future release |
|                                  | fmn-check-cable                | New 2.1.0 command. See FMN Command Reference Guide    |
|                                  | fmn-create-link-policy         | New 2.1.0 command. See FMN Command Reference Guide    |
|                                  | fmn-delete-link-policy         |                                                       |
|                                  | fmn-show-link-policy           |                                                       |
|                                  | fmn-show-link-policy           |                                                       |
|                                  | fmn-create-switch-policy       | New 2.1.0 command. See FMN Command Reference Guide    |
|                                  | fmn-delete-switch-policy       |                                                       |
|                                  | fmn-update-switch-policy       |                                                       |
|                                  | fmn-show-switch-policy         |                                                       |
|                                  | fmn-delete-backup              | New 2.1.0 command. See FMN Command Reference Guide    |
|                                  | fmn-show-backup                |                                                       |
|                                  | fmn-show-edge-port             | New 2.1.0 command. See FMN Command Reference Guide    |
|                                  | fmn-show-fabric-management     | New 2.1.0 command. See FMN Command Reference Guide    |
|                                  | fmn-update-fabric-management   |                                                       |
|                                  | fmn-show-fabric-port           | New 2.1.0 command. See FMN Command Reference Guide    |
|                                  | fmn-show-lag                   | New 2.1.0 command. See FMN Command Reference Guide    |
|                                  | fmn-show-port                  | New 2.1.0 command. See FMN Command Reference Guide    |
|                                  | fmn-show-switch-policy         | New 2.1.0 command. See FMN Command Reference Guide    |
| fmn-sync-active-standby          | fmn-synchronize-active-standby | 1.0.0 command is decommissioned in 2.1.0 release      |
|                                  | fmn-update-discovery-service   | New 2.1.0 command. See FMN Command Reference Guide    |
| fmn-update-active-standby-status |                                | 1.0.0 command is decommissioned in 2.1.0 release      |
| fmn-migrate-active               |                                | 1.0.0 command is decommissioned in 2.1.0 release      |

## Slingshot 2.0.0

| 1.0.0                                | 2.0.0                                | Description                                                                                           |
|:-------------------------------------|:-------------------------------------|:------------------------------------------------------------------------------------------------------|
| fmn-backup                           | fmn-create-backup                    | 1.0.0 command is decommissioned in 2.1.0                                                              |
| fmn\_bounce\_offline\_edgeports      |                                      | 1.0.0 command is subject to replace in future release                                                 |
| fmn\_build\_switch\_inventory        | fmn-create-switch-inventory          | 1.0.0 command is decommissioned in 2.1.0                                                              |
| fmn-sync-active-standby              | fmn-sync-active-standby              | No change                                                                                             |
| fmn\_cert\_provision                 | fmn-create-certificate               | 1.0.0 command is decommissioned. Both commands require mandatory parameter of `--all` or `--group` or |
|                                      | fmn-update-certificate               | `--name`                                                                                              |
| fmn\_cluster\_create                 |                                      | 1.0.0 command is decommissioned in 2.0.0                                                              |
| fmn\_cluster\_status                 | fmn-show-cluster                     | 1.0.0 command is decommissioned in 2.1.0                                                              |
| fmn\_compact\_telemetry              | fmn-delete-telemetry                 | 1.0.0 command is decommissioned in 2.0.0                                                              |
| fmn\_config\_telemetry               | fmn-update-telemetry-config          | 1.0.0 command is decommissioned in 2.0.0                                                              |
|                                      | fmn-show-telemetry-config            | New feature enhancements. See FMN Command Reference Guide                                             |
| fmn_disable_all_firmware_updates     |                                      | 1.0.0 command is decommissioned in 2.0.0                                                              |
| fmn\_fabric\_bringup                 |                                      | 1.0.0 command is decommissioned in 2.0.0                                                              |
| fmn\_fabric\_snapshot                | fmn-get-diagnostics                  | 1.0.0 command is decommissioned in 2.0.0                                                              |
| fmn-failover-active-standby          | fmn-failover-active-standby          | No change                                                                                             |
| fmn\_pw                              | fmn-update-password                  | 1.0.0 command is decommissioned. The command requires mandatory parameter of `--all` or `--group` or  |
|                                      |                                      | `--name`                                                                                              |
| fmn\_replace\_fabric\_links          | fmn-update-fabric-links              | 1.0.0 command is decommissioned in 2.1.0                                                              |
| fmn\_replace\_fabric\_nic\_ips       | fmn-update-hsn-nic-config            | 1.0.0 command is decommissioned in 2.1.0                                                              |
| fmn\_replace\_fabric\_policy         | fmn-update-fabric-policy             | 1.0.0 command is decommissioned in 2.1.0                                                              |
| fmn-restore                          | fmn-restore-backup                   | 1.0.0 command is decommissioned in 2.1.0                                                              |
| fmn\_shasta\_dns                     | fmn-update-dns                       | 1.0.0 command is decommissioned in 2.1.0                                                              |
| fmn\_subsystem\_config               |                                      | 1.0.0 command is decommissioned in 2.0.0                                                              |
| fmn\_switch_reset                    | fmn-reset-swtich                     | 1.0.0 command is decommissioned in 2.1.0                                                              |
| fmn-update-active-standby-status     | fmn-update-active-standby-status     | No change                                                                                             |
| fmn-update-switch-compute-hsn-health | fmn-update-switch-compute-hsn-health | No change                                                                                             |
| fmn\_update\_switch\_firmware        | fmn-update-switch-firmware           | 1.0.0 command is decommissioned in 2.0.0                                                              |
|                                      | fmn-show-switch-firmware             | Performance improvement and feature enhancements. See FMN Command Reference Guide                     |
| fmn-update-switch-lldp-health        | fmn-update-switch-lldp-health        | No change                                                                                             |
| fmn\_version                         | fmn-show-version                     | 1.0.0 command is decommissioned in 2.1.0                                                              |
| fmn\_status                          | fmn-show-status                      | 1.0.0 command is decommissioned in 2.1.0                                                              |
|                                      |                                      | Performance improvement and New feature enhancements. See FMN Command Reference Guide                 |
| fmn-backup-port-policy               | fmn-backup-port-policy               | No change                                                                                             |
|                                      | fmn-create-port-policy               | New 2.0.0 command. See FMN Command Reference Guide                                                    |
|                                      | fmn-delete-port-policy               |                                                                                                       |
|                                      | fmn-update-port-policy               |                                                                                                       |
| switch-show-asic-errors              | switch-show-asic-errors              | No change                                                                                             |
