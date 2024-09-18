# Legacy install procedure for non-CFS based installs

## Updating compute and UAN image recipe

See subsection "Upload and Register an Image Recipe" under the "Image Management" section of the CSM documentation for general steps on how to download, modify, upload, and register an image recipe.

In the following examples, the `config.xml` files will show '2.0' as the version of HPE Slingshot defined within the image recipe. The version of HPE Slingshot in the image recipe may differ from the examples shown here.

For systems equipped with Mellanox NICs, follow the instructions in 1. below. For systems equipped with HPE Slingshot 200Gbps NIC, follow the instructions in 2.

1. Mellanox systems:

   For the compute image recipe, replace the following lines in config.xml:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-2.0-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-2.0-cos-2.4/"/>
   </repository>
   ```

   with the following lines, replacing `<slingshot-version>` with the version of HPE Slingshot that is being installed:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-<slingshot-version>-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-<slingshot-version>-cos-2.4/"/>
   </repository>
   ```

   For the UAN image recipe, replace the following lines in config.xml:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-2.0-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-2.0-cos-2.4/"/>
   </repository>
   ```

   with the following lines, replacing `<slingshot-version>` with the version of Slingshot that is being installed:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-<slingshot-version>-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-<slingshot-version>-cos-2.4/"/>
   </repository>
   ```

   For both compute and UAN image recipes, in the recipe object, update references to the slingshot-host-software URL in the file `root/root/bin/zypper-addrepo.sh`.

   For example, replace the following line:

   ```screen
   zypper addrepo --priority 2 https://packages.local/repository/slingshot-host-software-2.0-cos-2.4 slingshot-host-software-2.0-cos-2.4
   ```

   with:

   ```screen
   zypper addrepo --priority 2 https://packages.local/repository/slingshot-host-software-<slingshot-version>-cos-2.4 \
   slingshot-host-software-<slingshot-version>-cos-2.4
   ```

2. HPE Slingshot 200Gbps NIC systems.

   For the compute image recipe, replace the following lines in config.xml:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-2.0-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-2.0-cos-2.4/"/>
   </repository>
   ```

   with the following lines, replacing `<slingshot-version>` with the version of HPE Slingshot that is being installed:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-cassini-<slingshot-version>-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-cassini-<slingshot-version>-cos-2.4/"/>
   </repository>
   ```

   For the UAN image recipe, replace the following lines in `config.xml`:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-2.0-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-2.0-cos-2.4/"/>
   </repository>
   ```

   with the following lines, replacing `<slingshot-version>` with the version of HPE Slingshot that is being installed:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-cassini-<slingshot-version>-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-cassini-<slingshot-version>-cos-2.4/"/>
   </repository>
   ```

   In the `<packages>` block, remove the following line:

   ```xml
   <package name="slingshot-firmware-mellanox"/>
   ```

   and all `<package>` items under `<!-- SECTION: OFED Packages -->`.

   In place of the removed OFED Packages section, add the following:

   ```xml
   <!-- Section: Cassini Packages -->
   <package name="cray-hms-firmware"/>
   <package name="cray-slingshot-base-link-dkms"/>
   <package name="cray-slingshot-base-link-devel"/>
   <package name="sl-driver-dkms"/>
   <package name="cray-cxi-driver-dkms"/>
   <package name="cray-cxi-driver-udev"/>
   <package name="cray-cxi-driver-devel"/>
   <package name="cray-libcxi"/>
   <package name="cray-libcxi-retry-handler"/>
   <package name="cray-libcxi-utils"/>
   <package name="cray-libcxi-devel"/>
   <package name="cray-cassini-headers-user"/>
   <package name="slingshot-firmware-cassini"/>
   <package name="cray-libcxi-dracut"/>
   ```

   For both compute and UAN image recipes, in the recipe object, update references to the slingshot-host-software URL in the file `root/root/bin/zypper-addrepo.sh`. For example, replace the following line:

   ```screen
   zypper addrepo --priority 2 https://packages.local/repository/slingshot-host-software-2.0-cos-2.4 slingshot-host-software-2.0-cos-2.4
   ```

   with:

   ```screen
   zypper addrepo --priority 2 https://packages.local/repository/slingshot-host-software-cassini-<slingshot-version>-cos-2.4 \
   slingshot-host-software-cassini-<slingshot-version>-cos-2.4
   ```

   When building a HPE Slingshot 200Gbps NIC image, additional steps are required in the image customization process, as listed below:

   - If building using SLES15sp4, execute the following:

     ```screen
     chroot /mnt/image/image-root
     sed -i 's/^allow_unsupported_modules 0/allow_unsupported_modules 1/' /lib/modprobe.d/10-unsupported-modules.conf
     ```

   - Otherwise, execute the following:

     ```screen
     chroot /mnt/image/image-root
     sed -i 's/^allow_unsupported_modules 0/allow_unsupported_modules 1/' /etc/modprobe.d/10-unsupported-modules.conf
     ```
