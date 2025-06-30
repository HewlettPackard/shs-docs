# SHS CFS variable reference

These Ansible variables are publicly exposed for use by customers or administrators with SHS CFS playbooks:

- name: `shs_libfabric_enabled`
  type: `bool`
  description: If enabled, then `libfabric` and dependencies will be installed or upgraded.
- name: `shs_target_node_type`
  type: `string`
  description: Sets the node type. Available choices are one of (`cn` ,`ncn`).
- name: `shs_devel_enabled`
  type: `bool`
  description: If enabled, then `-devel` and header packages will be installed or upgraded.
- name: `shs_profile`
  type: `string`
  description: Sets the node profile. This is an advanced usage variable to set the configuration of a node to a pre-determined configuration. The configuration is viewable in `ansible/roles/setup/defaults/main.yml`. Available choices are one of (`compute`, `application`, `worker`).
- name: `shs_target_network`
  type: `string`
  description: Sets the network type. (`cassini`)
- name: `shs_release`
  type: `string`
  description: Sets the SHS release. This can be used to control the release used for a specific image, or node type.
- name: `shs_target_distro`
  type: `string`
  description: Sets the target distribution to use when defining repository URIs. Available choices are one of (`sle15-sp3`, `sle15-sp4`). See guidance below for selecting a target distribution.
- name: `shs_target_platform`
  type: `string`
  description: Sets the target platform to use when defining repository URIs. Available choices are in the format `cos-<version>` or `csm-<version>`. COS version 3.1 and later or CSM version 1.5 and later may be used.
