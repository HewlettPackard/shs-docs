# Workaround: Ensure `slingshot-eth-tuning.sh` settings persist after link bounce

There is a known issue where some of the settings applied by the `slingshot-eth-tuning.sh` script are not maintained when a link bounces.

## Procedure

1. Edit the Network Manager dispatcher script to call the `slingshot-eth-tuning.sh` script when interface status changes to UP.

    For example:

    ```screen
    cat << `EOF` >> /etc/NetworkManager/dispatcher.d/01-cm-slingshot-ama
    if [[ $INTERFACE =~ $NAME_PREFIX[0-9]{1,2}$ ]] && [ &ACTION == "up"] && [-d "/sys/class/net/$INTERFACE" ]; then
        /usr/bin/slingshot-eth-tuning --set recommendation --device $INTERFACE
    fi
    EOF
    ```

    This update appends the necessary logic to the end of the existing dispatcher script, which is invoked by the Network Manager whenever an interface changes state.

2. Apply the changes on a live system.

   On a live system, the Network Manager must be restarted.

   ```screen
   systemctl restart network-manager
   ```

## Alternative solutions

To make the change persistent across deployments, consider adding the modified dispatcher file into your image or configuration management workflow.

If you prefer not to modify the existing `slingshot-ama dispatcher`, consider creating a service to achieve this behavior.
