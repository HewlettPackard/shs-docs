# Fix Algorithmic MAC Address (AMA) prefix after HPCM install

This procedure addresses an issue in HPCM environments where modifying the HPE Slingshot fabric AMA prefix from the default `02` prevents nodes' HSN NICs from booting with a configured AMA.

A fix for this issue is being investigated for a future HPCM release.
For more information on writing post-install scripts, see the `/opt/clmgr/image/scripts/post-install/README` file on an HPCM admin node.

## Procedure

1. Determine which nodes with HSN NICs on the HPE Slingshot fabric are using a disk for their ROOTFS.

   ```screen
   # cm node show -O | grep 'disk$' | awk '{print $1}'
   ```

2. Modify the `cm-slingshot-get-ama` script on disk-using nodes.
   For each node identified in the previous step, run the following commands to modify the `cm-slingshot-get-ama` script to use the desired AMA prefix.
   Replace `"06"` with the AMA prefix configured on the site.

   ```screen
   export AMA_PREFIX="06"
   sed -i -e "s/02:fe/${AMA_PREFIX}:fe/g" /opt/clmgr/bin/cm-slingshot-get-ama
   sed -i -e "s/02:00/${AMA_PREFIX}:00/g" /opt/clmgr/bin/cm-slingshot-get-ama
   ```

3. Create a post-install script to ensure that the `cm-slingshot-get-ama` script uses the desired AMA prefix during diskless and disk-ful node re-installs.

   1. Open a new file on the HPCM admin node.

      ```screen
      vi /opt/clmgr/image/scripts/post-install/01all.modify_cm_slingshot_get_ama
      ```

   2. Add the following content to the file, replacing `"06"` with the site's configured AMA prefix.

      ```screen
      #!/bin/bash
      # Modify cm-slingshot-get-ama to use the expected AMA prefix value
      AMA_PREFIX="06"
      echo "Modify /opt/clmgr/bin/cm-slingshot-get-ama to use the site AMA prefix '$AMA_PREFIX'"
      sed -i -e "s/02:fe/${AMA_PREFIX}:fe/g" /opt/clmgr/bin/cm-slingshot-get-ama
      sed -i -e "s/02:00/${AMA_PREFIX}:00/g" /opt/clmgr/bin/cm-slingshot-get-ama
      ```

4. If the system has SU-leader nodes, sync the post-install script to these nodes.

   1. Verify if there are SU-leader nodes.

      ```screen
      # cm node show -t role su-leader
      ```

   2. If SU-leader nodes are present, sync the script.

      ```screen
      # cm image sync --scripts
      ```

5. Reboot nodes.

    To apply the changes and ensure the nodes receive their AMA setting on the HSN NICs, issue a `reboot` command to the nodes.
