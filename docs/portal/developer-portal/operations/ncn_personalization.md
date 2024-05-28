
# NCN personalization

This section is only for systems using CSM 1.2 or earlier versions. For systems using CSM 1.3 or later versions, skip this section and instead proceed to the [NCN image customization](ncn_image_customization.md#ncn-image-customization) instructions.

Ensure that the [Setup](setup.md#setup) section preceding this section has been completed prior to running any steps in this section.

Two subsections are provided in this section for NCN installation and configuration use cases:

- Installation and upgrade
- Migration

Installation and upgrade are aimed at discussing the process and procedure for installing or upgrading SHS on an NCN worker.

Migration is aimed at discussing how to replace the SHS networking software stack on an NCN with a different networking stack from SHS. Only migration from systems with Mellanox NICs to systems with HPE Slingshot 200Gbps NICs is supported at this time.

## Install or upgrade with NCN personalization

The following steps describe how to use the NCN personalization CFS configuration in conjunction with HPE Cray EX CFS software to install, update, and configure SHS provided content on NCN workers.

These steps provide the networking drivers, management software, and device firmware.

1. Run the following command for all worker nodes, one at a time, before continuing to the next step.

   ```screen
   ncn-m001# cray cfs components update XNAME --enabled false
   ```

   NOTE: The XNAME of the node can be found in `sat status`.

2. Update or add the SHS config commit hash in the NCN personalization CFS configuration.

   a. Download the current NCN personalization CFS configuration. (or create a new one)

      ```screen
      ncn-m001# cray cfs configurations describe ncn-personalization \
      --format json | jq ". | {layers}" > ncn-personalization.json
      {
        "layers": [
          {
            "cloneUrl": "<git repository url>",
            "commit": "<git commit hash>",
            "name": "<name of the CFS layer>",
            "playbook": "<ansible playbook to run>"
          },
      ...
      ```

      The above shows an example of what the configuration could look like with stub values for each field.

   b. Edit the JSON file.

      A CFS layer is defined by four fields: `cloneUrl`, `commit`, `name`, and `playbook`.

      The entry for the play should have the following format. Replace values in the format with the instructions below.

      ```json
      {
        "cloneUrl": "<git repository url>",
        "commit": "<git commit hash>",
        "name": "<name of the CFS layer>",
        "playbook": "<ansible playbook to run>"
      }
      ```

      - Replace `<git repository url>` with the value saved in `${CLONE_URL}`.
      - Replace `<git commit hash>` with the value saved in `${SHS_CONFIG_COMMIT_HASH}`.
      - Replace `<name of the CFS layer>` with `shs-integration-<release>`.
        `<release>` should be replaced by the SHS release.
        Earlier examples provided `2.0.0` as the release. The release field should match the release of SHS that is being installed or match the targeted update release.
      - Replace `<ansible playbook to run>` with one of the following:
        - `shs_cassini_install.yml` if the HPE Slingshot 200Gbps NIC software stack should be installed or updated.
        - `shs_mellanox_install.yml` if the Mellanox software stack should be installed or updated.

      **_If an entry exists for SHS, then perform the following substep._**

   c. Edit the existing layer for SHS in the `layers` list of the JSON file. Save the changes to the file.

      **_If an entry does not exist for SHS, then perform the following substep._**

   d. Add a new layer for SHS to the `layers` list in the JSON file.

      Consult the Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) for guidance on how to order layers following the `sat bootprep` input files.

      Save the changes to the JSON file after adding in the new layer.

      After the edits are complete, the SHS layer should look like this:

      ```json
      {
        "layers": [
          {
            "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
            "commit": "<git commit hash>",
            "name": "shs-integration-2.0.0",
            "playbook": "shs_cassini_install.yml"
          }
        ]
      }
      ```

      NOTE: The above values are provided as examples. The values in the JSON file may differ for each installation or upgrade. Cross-reference the values with the `cray-product-catalog` information, and the saved values from previous steps to verify your work.

   e. Upload the new configuration into CFS. It should look similar to the following output.

      ```json
      ncn-m001# cray cfs configurations update ncn-personalization \
      --file ncn-personalization.json --format json
      {
        "lastUpdated": "2022-08-08T17:51:09Z",
        "layers": [
            {
                "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
                "commit": "<git commit hash>",
                "name": "shs-integration-<release>",
                "playbook": "shs_cassini_install.yml"
            },
            ...
        ],
        "name": "ncn-personalization"
      }
      ```

   f. Run NCN personalization for the worker nodes to install, upgrade, and/or configure the software.
   For a fresh install, this step can be performed on all worker nodes at once. For upgrades, see the **CSM documentation on best practices on how to upgrade worker nodes safely**. This step will show the process for updating a single worker.

   g. Enable and run NCN personalization on the worker.
      _If this is a fresh install, then perform the following steps:_

      ```console
      ncn-m001# cray cfs components update --desired-config ncn-personalization \
                          --enabled true --state '[]' --error-count 0 XNAME --format json
      ```

      _Otherwise, perform the following steps:_

      ```console
      ncn-m001# cray cfs components update \
                          --enabled true --state '[]' --error-count 0 XNAME --format json
      ```

   `XNAME` must be replaced with the XNAME of the worker node.

   h. Wait for ncn-personalization to be in the `configured` state. The state of the job can be monitored with the following command:

      ```console
      ncn-m001# watch "cray cfs components describe --format json XNAME"
      ```

      `XNAME` must be replaced with the XNAME of the worker node.

   i. Verify that the worker is running new software.

      ```console
      ncn-w001# lsmod | grep -P 'mlx|cxi'
      # if the Mellanox software stack is installed
      ncn-w001# modinfo mlx5_core
      # if the HPE Slingshot 200Gbps NIC software stack is installed
      ncn-w001# modinfo cxi_core
      # if performing an upgrade with a live Slingshot fabric
      ncn-w001# slingshot-diag
      ```

   If the modules are not listed for each worker node, and you have done the steps above, see `Perform NCN personalization` in the CSM documentation for NCN Personalization details.

At this stage in the documentation, SHS content has been installed or upgraded and configured on the NCN workers.

If other HPE Cray EX software products are being installed in conjunction with SHS, see the "Install and Upgrade Framework (IUF)" section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) to determine what step to perform next.

If other HPE Cray EX software products are not being installed at this time, continue to the next section of this document to configure compute content.

## Migration

If a fresh install of the NCN worker has occurred and SHS has never been installed before on the target node, see `Install/Upgrade` section above. If SHS has never been installed, then the node can be considered to be 'clean' and does not require uninstallation of the HPE Slingshot software stack with Mellanox NICs.

The following steps describe how to use the NCN personalization CFS configuration in conjunction with HPE Cray EX System Software CFS to migrate SHS provided content on NCN Workers from an installation with Mellanox NICs to an installation with HPE Slingshot 200Gbps NICs.
These steps are necessary to provide the networking drivers, management software, and device firmware as required.

1. Run the following command for all worker nodes, one at a time, before continuing to the next step.

   ```screen
   ncn-m001# cray cfs components update XNAME --enabled false
   ```

   NOTE: The XNAME of the node can be found in `sat status`.

2. Update or add the SHS config commit hash in the NCN personalization CFS configuration

   a. Download the current NCN personalization CFS configuration. (or create a new one)

      ```json
      ncn-m001# cray cfs configurations describe ncn-personalization \
      --format json | jq ". | {layers}" > ncn-personalization.json
      {
        "layers": [
          {
            "cloneUrl": "<git repository url>",
            "commit": "<git commit hash>",
            "name": "<name of the CFS layer>",
            "playbook": "<ansible playbook to run>"
          },
      ...
      ```

      The above shows an example of what the configuration could look like with stub values for each field.

   b. Edit the JSON file.

      A CFS layer is defined by four fields: `cloneUrl`, `commit`, `name`, and `playbook`.

      The entries for the play should have the following format. Replace values in the format with the instructions below.

      ```json
      {
        "cloneUrl": "<git repository url>",
        "commit": "<git commit hash>",
        "name": "<name of the CFS layer>",
        "playbook": "<ansible playbook to run>"
      }
      ```

      - Replace `<git repository url>` with the value saved in `${CLONE_URL}`.
      - Replace `<git commit hash>` with the value saved in `${SHS_CONFIG_COMMIT_HASH}`.
      - Replace `<name of the CFS layer>` with `shs-integration-<release>`. `<release>` should be replaced by the SHS release.
        Earlier examples provided `2.0.0` as the release. The release field should match the release of SHS that is being installed or updated to.
      - Replace `<ansible playbook to run>` with one of the following:
        - `shs_cassini_install.yml` if the HPE Slingshot 200Gbps NIC software stack should be installed or updated.
        - `shs_mellanox_install.yml` if the Mellanox software stack should be installed or updated.
        - `shs_cassini_uninstall.yml` if the HPE Slingshot 200Gbps NIC software stack should be uninstalled.
        - `shs_mellanox_uninstall.yml` if the Mellanox software stack should be uninstalled.

      **_If an entry exists for SHS, then perform the following substep._**

   c. Edit the existing layer for SHS in the `layers` list of the JSON file. Save the changes to the file.

      **_If an entry does not exist for SHS, then perform the following substep._**

   d. Add a new layer for SHS to the `layers` list in the JSON file.

      Consult the Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) for guidance on how to order layers following the `sat bootprep` input files.

      Save the changes to the JSON file when complete.

      A CFS configuration that is defined for the migration use case should have two layers for SHS. See the example below for comparison.

      NOTE: In the following JSON example, some configuration layers have been omitted for readability and the values are provided only as examples. The values in the JSON file may differ for each migration, so cross-reference the values with the cray-product-catalog information and the saved values from previous steps to verify the accuracy of the values.

      ```json
      {
      "layers": [
          ... other layers before Slingshot such as SMA ...
          {
            "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
            "commit": "<git commit hash>",
            "name": "shs-integration-2.0.0",
            "playbook": "shs_mellanox_uninstall.yml"
          },
          {
            "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
            "commit": "<git commit hash>",
            "name": "shs-integration-2.0.0",
            "playbook": "shs_cassini_install.yml"
          }
        ]
      }
      ```

   e. Upload the new configuration into CFS. It should look similar to the output below.

      ```json
      ncn-m001# cray cfs configurations update ncn-personalization \
      --file ncn-personalization.json --format json
      {
        "lastUpdated": "2022-08-17T17:51:09Z",
        "layers": [
            ...
            {
                "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
                "commit": "<git commit hash>",
                "name": "shs-integration-<release>",
                "playbook": "shs_cassini_install.yml"
            },
            ...
        ],
        "name": "ncn-personalization"
      }
      ```

   f. Run NCN personalization for the worker nodes to install, upgrade, and/or configure the software.
      For a fresh install, this step can be performed on all worker nodes at once. For upgrades, see the **CSM documentation on best practices on how to upgrade worker nodes safely**. This step will show the process for updating a single worker.

   g. Enable and run NCN personalization on the worker.
      _If this is a fresh install, then perform the following steps:_

      ```screen
      ncn-m001# cray cfs components update --desired-config ncn-personalization \
                          --enabled true --state '[]' --error-count 0 XNAME --format json
      ```

      _Otherwise, perform these step below:_

      ```screen
      ncn-m001# cray cfs components update \
                          --enabled true --state '[]' --error-count 0 XNAME --format json
      ```

      `XNAME` must be replaced with the XNAME of the worker node.

   h. Wait for ncn-personalization to be in the `configured` state. The state of the job can be monitored with the following command:

      ```screen
      ncn-m001# cray cfs components describe --format json XNAME
      ```

      `XNAME` must be replaced with the XNAME of the worker node.

   i. Verify that the worker is running new software.

      ```screen
      ncn-w001# lsmod | grep -P 'mlx|cxi'
      ncn-w001# modinfo mlx5_core  # if the Mellanox software stack is installed
      ncn-w001# modinfo cxi_core   # if the HPE Slingshot 200Gbps NIC software stack is installed
      ncn-w001# slingshot-diag     # if performing an upgrade with a live Slingshot fabric
      ```

      If the modules are not listed for each worker node, and you have done the steps above, refer to `Perform NCN personalization` in the CSM documentation for NCN Personalization details.
