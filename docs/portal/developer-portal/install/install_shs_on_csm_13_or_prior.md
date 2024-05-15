
# Install SHS on CSM release 1.3 or prior

The SHS distribution provides firmware, diagnostics, and the network software stack for hosts which communicate using the HPE Slingshot network.

For upgrades, the manual steps or the Compute Node Environment (CNE) installer tool can be used. See [SHS upgrade with CNE installer](#shs-upgrade-with-cne-installer) for more information on the `cne-install` method.

## Common requirements of SHS

- SUSE Linux Enterprise Operating System for HPE Cray EX product must be installed.
- System Admin Toolkit (SAT) product must be installed and configured.
- Cray System Management (CSM) product must be installed and configured.
- The Cray CLI tool is initialized and configured on the system. See 'Configure the Cray Command Line Interface (CLI)' section of the Cray System Management (CSM) documentation for more information.
- COS 2.3+ must be used for HPE Slingshot 200Gbps NIC installations.
- HPE Cray EX System Software Configuration Framework Service (CFS) must be installed and available.
- SHS CFS plays should be one of the first plays run in the configuration.
- SHS CFS installation must occur before any product with dependencies on the network stack installs software.

## Requirements for new installations or upgrades of SHS

All image and node targets must be clear of software with dependencies on the network stack prior to the execution of the SHS CFS play.

## SHS upgrade with CNE installer

The CNE installer (`cne-install`) tool can only be used to upgrade SHS in this release. `cne-install` performs all the manual steps shown in the [Install product stream](#install-product-stream) and [Operational activities](../operations/operational_activities_csm.md#operational-activities) sections of the upgrade procedure.

See the "Compute Node Environment (CNE) Installer" section of the [HPE Cray EX System Software Getting Started Guide (S-8000)](https://www.hpe.com/support/ex-S-8000) for more information about the tool.

## Install product stream

1. Start a typescript to capture the commands and output from this installation.

   ```screen
   ncn-m001# script -af product-shs.$(date +%Y-%m-%d).log
   ncn-m001# export PS1='\u@\H \D{%Y-%m-%d} \t \w # '
   ```

2. Copy the release tar file of the target platform (cos-2.x, sle15spx, or other) to `ncn-m001`.

3. Unzip and extract the tar file.

   ```screen
   ncn-m001# tar xzvf slingshot-host-software-<version>-<OS distro>_<OS Architecture>.tar.gz
   ```

   `<release>` is the release version and build number of the release tar file, and `<platform>` is the target platform.
   An example of these values would be `2.0.0` for release, and `cos-2.4` for platform.
   This would result in the following command:

   ```screen
   ncn-m001# tar xzvf slingshot-host-software-2.0.0-cos-2.4_x86_64.tar.gz
   ```

4. Execute the `install.sh` script for COS.

   a. Change directory to the extracted COS tar file directory.

      ```screen
      ncn-m001# cd slingshot-host-software-<release>-<cos-release>
      ```

      `<release>` is the release version and build number of the release tar file, and `<cos-release>` is the release version of the COS release tar file. An example of this would be `2.0.0` for the release, and `cos-2.4` for the COS release. This would result in the following command:

      ```screen
      ncn-m001# cd slingshot-host-software-2.0.0-cos-2.4
      ```

   a. Run the `install.sh` script to install SHS.

      ```screen
      ncn-m001# ./install.sh
      ...
      < example output from install >
      ```

5. Execute the `install.sh` script for CSM.

   a. Change directory to the extracted CSM tar file directory.

      ```screen
      ncn-m001# cd slingshot-host-software-<release>-<csm-release>
      ```

      `<release>` is the release version and build number of the release tar file, and `<csm-release>` is the release version of the CSM release tar file. An example of this would be `2.0.0` for the release, and `csm-1.3` for the CSM release. This would result in the following command:

      ```screen
      ncn-m001# cd slingshot-host-software-2.0.0-csm-1.3
      ```

   a. Run the `install.sh` script to install SHS.

      ```screen
      ncn-m001# ./install.sh
      ...
      < example output from install >
      ```

6. Verify that the installation has completed successfully by querying Nexus to show the newly installed repositories.

   ```curl
   ncn-m001# curl -s -k https://packages.local/service/rest/v1/repositories \
   | jq -r '.[] | select(.name) .name' \
   | grep slingshot-host-software-<release>

   ncn-m001# sat showrev | grep slingshot-host-software
   # NOTE: may be deferred to a later step, or run when upgrading
   ```

   Example output:

   ```curl
   ncn-m001# curl -s -k https://packages.local/service/rest/v1/repositories \
   | jq -r '.[] | select(.name) .name' | grep slingshot-host-software-2.0.0

   slingshot-host-software-2.0.0-dev-csm-1.3.0-sle15-sp3-ncn-mellanox
   slingshot-host-software-2.0.0-dev-cos-2.4-sle15-sp4-cn-cassini
   slingshot-host-software-2.0.0-dev-cos-2.4-sle15-sp4-cn-mellanox
   slingshot-host-software-2.0.0-dev-csm-1.3.0-sle15-sp3-ncn-cassini

   # NOTE: may be deferred to a later step, or run when upgrading
   ncn-m001# sat showrev | grep slingshot-host-software

   | slingshot-host-software | 2.0.0 |
   ```

SHS now supports installation through HPE Cray EX System Software CFS. Proceed to the next section to install the software through HPE Cray EX System Software CFS. Otherwise, proceed to the [Legacy Install Procedure for non-CFS based installs](legacy_install_procedure_for_non_cfs_based_installs.md) section.

