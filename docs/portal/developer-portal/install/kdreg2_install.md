
# Install procedure

Use this section to install kdreg2 in the host images.
For more detailed instructions, see one of the following sections depending on the system management environment in use:

- [kdreg2 installation: Cray System Management (CSM)](#kdreg2-installation-cray-system-management-csm)
- [kdreg2 installation: HPE Performance Cluster Manager (HPCM)](#kdreg2-installation-hpe-performance-cluster-manager-hpcm)

## kdreg2 installation: Cray System Management (CSM)

CSM customers must install the Slingshot Host Software product stream, and then edit the Configuration Framework Service (CFS) files provided in the Gitea (VCS) stage of the IUF workflow.

1. Clone the SHS CFS repository to the Master node to edit the Ansible plays, or navigate to the SHS CFS repository that has already been cloned.

2. Edit the `roles/setup/defaults/main.yml` file and change the value for `shs_experimental_enable_kdreg2` from false to true.

    This can be found on line seven of an unmodified version of the code.

    ```screen
    # Copyright 2021 Hewlett Packard Enterprise Development LP
    #
    ---
    # defaults file for setup
    ## Public experimental values. Set as appropriate for enabling/disabling experimental features
    shs_experimental_enable_kdreg: false
    ```

    Change it to the following:

    ```screen
    # Copyright 2021 Hewlett Packard Enterprise Development LP
    #
    ---
    # defaults file for setup
    ## Public experimental values. Set as appropriate for enabling/disabling experimental features
    shs_experimental_enable_kdreg: true
    ```

3. Save the file and exit the editor.

4. Commit the change and push it back to the repository.

5. Continue to step 3.15.4.2.7 of the CSM installation procedure for SHS (See the 2.0.2 version of the _HPE Slingshot Operations Guide_). Otherwise, proceed to the IUF manual configuration stage of the IUF workflow.

At the end of this process, SHS will be configured to install kdreg2 into images on CSM systems.

## kdreg2 installation: HPE Performance Cluster Manager (HPCM)

HPCM customers must add the following RPMs to the rpmlist for the image before constructing the image.

- **SLE-based images (COS and SLE):** See step 5 in section 6.2 of the _HPE Slingshot Operations Guide_ (version 2.0.2) for more information.

   ```screen
   “‘console echo -e “““
   kdreg2 kdreg2-kmp kdreg2-devel”“” » ./Slingshot-host-software.rpmlist
   ```

- **RHEL-based images:** See step 5 in section 6.2 of the _HPE Slingshot Operations Guide_ (version 2.0.2) for more information.

   ```screen
   “‘console echo -e “““
   kdreg2 kmod-kdreg2 kdreg2-devel”“” » ./Slingshot-host-software.rpmlist
   ```
