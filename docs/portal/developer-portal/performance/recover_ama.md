# Recover AMA assignment after driver reload

If `cxi-ss1` or related driver modules are reloaded, the AMA assignment may need to be refreshed.

1. Restart the AMA service so the NIC re-acquires the correct AMA.

    ```screen
    systemctl restart cm-slingshot-ama
    ```

    For HPCM-managed nodes:

    ```screen
    admin# cm node run -n "x*" systemctl restart cm-slingshot-ama.service
    ```

1. After the service restarts, verify that `cm-slingshot-ama` is running.

    ```screen
    systemctl status cm-slingshot-ama
    ```
