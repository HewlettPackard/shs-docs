# Host adapter naming

On a Linux host, `udev` is responsible for naming system devices according to defined system and site-specific policies. The scripts provided by the `slingshot-network-config` RPM assume that the network devices are named according to a specific convention, `hsn<index>`.

To implement this policy, this `slingshot-network-config` RPM provides a script and an example udev rule which can be used as-is or modified to fit a site-specific configuration.

The example udev configuration file can be found here:

`/opt/slingshot/slingshot-network-config/default/share/udev/99-slingshot-network.conf`

The example udev configuration file above uses a script provided in the RPM to name the Mellanox CX-5 adapters used in the HPE Slingshot configuration with Mellanox NICs from the default name provided by the OS, to `hsn<index>` as appropriate.
The script can be found here:

`/opt/slingshot/slingshot-network-config/default/bin/slingshot-ifname.sh`

If a part of the host OS, or the host OS image is going to be mounted from the network, it is suggested that the host include the dracut example file for including the udev rules into the initrd.
The example dracut file can be found here:

`/opt/slingshot/slingshot-network-config/default/share/dracut/99-slingshot-network-udev/module-setup.sh`

To integrate these files into the image:

1. Create a link in the udev rules folder to the example udev rule file.

   ```screen
   root@host ~# ln -s \
   /opt/slingshot/slingshot-network-config/default/share/udev/99-slingshot-network.rules \
   /usr/lib/udev/rules.d/99-slingshot-network.rules
   ```

2. Create a link in dracut to the example udev module file.

   ```screen
   root@host ~# ln -s \
   /opt/slingshot/slingshot-network-config/default/share/dracut/99-slingshot-network-udev \
   /usr/lib/dracut/modules.d/99slingshot-network-udev
   ```

3. Rebuild the initrd with the udev module to support use cases requiring NFS mounts on boot.

   ```screen
   root@host ~# dracut --add slingshot-network-udev --verbose --rebuild /boot/initrd
   ```

If the resulting initrd is used for booting the host over the network, such as with a pxeboot, then the resultant initrd from the final step in the example should be used to boot the new image.
