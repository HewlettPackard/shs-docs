
# Install procedure

Use this section to install kdreg2 in the host images.
For more detailed instructions, see one of the following sections depending on the system management environment in use:

- [kdreg2 installation: Cray System Management (CSM)](#./kdreg2-installation-cray-system-management-csm)
- [kdreg2 installation: HPE Performance Cluster Manager (HPCM)](#./kdreg2-installation-hpe-performance-cluster-manager-hpcm)

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

See step 5 of the [HPE Slingshot 200Gbps CXI NIC system install procedure](HPE_Slingshot_200Gbps_cxi_nic_system_install_upgrade_procedure.md#hpe-slingshot-200gbps-cxi-nic-system-install-procedure) for detailed instructions. The appropriate kernel module packages differ based on whether DKMS or pre-built binaries are used. See the following guidelines for each image type:

- **SLES Images**

   - **With DKMS:** Use the following packages:
      
      ```screen
      echo -e "kdreg2 kdreg2-dkms kdreg2-devel" >> ./Slingshot-host-software.rpmlist
      ```

   - **Without DKMS:** Replace the DKMS package with the KMP package:
      
      ```screen
      echo -e "kdreg2 kdreg2-kmp-default kdreg2-devel" >> ./Slingshot-host-software.rpmlist
      ```

- **COS-based Images**

   - **With DKMS:** Use the following packages:
      
      ```screen
      echo -e "kdreg2 kdreg2-dkms kdreg2-devel" >> ./Slingshot-host-software.rpmlist
      ```

   - **Without DKMS:** Replace the DKMS package with the appropriate KMP variant based on architecture:
 
      - **COS on x86:** Replace `*-dkms` with `*-kmp-cray_shasta_c`.
         
         ```screen
         echo -e "kdreg2 kdreg2-kmp-cray_shasta_c kdreg2-devel" >> ./Slingshot-host-software.rpmlist
         ```

      - **COS on ARM64:** Replace `*-dkms` with `*-kmp-cray_shasta_c_64k`.
         
         ```screen
         echo -e "kdreg2 kdreg2-kmp-cray_shasta_c_64k kdreg2-devel" >> ./Slingshot-host-software.rpmlist
         ```

- **RHEL-based Images**

   - **With DKMS:** Use the following packages:
     
      ```screen
      echo -e "kdreg2 kdreg2-dkms kdreg2-devel" >> ./Slingshot-host-software.rpmlist
      ```

   - **Without DKMS:** Replace the DKMS package with the KMOD package:
      
      ```screen
      echo -e "kdreg2 kmod-kdreg2 kdreg2-devel" >> ./Slingshot-host-software.rpmlist
      ```

By replacing the `*-dkms` packages with the appropriate pre-built binary variants (`*-kmp` or `kmod-*`), you can configure the system based on your needs and architecture.