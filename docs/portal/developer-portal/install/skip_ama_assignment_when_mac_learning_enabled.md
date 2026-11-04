# Skip AMA assignment when MAC learning is enabled

If MAC learning is enabled, AMA assignment can be disabled.

To disable it, modify `/etc/sysconfig/cm-slingshot` in the image assigned to the node by using `cm image chroot`.

```screen
admin# cm image chroot -i <image_name> 'sed -i -e "s/SKIP_AMA_ASSIGNMENT=\".*\"/SKIP_AMA_ASSIGNMENT=\"*\"/g" /etc/sysconfig/cm-slingshot'
```

If the image is used for BitTorrent image transfer, refresh the image.

```screen
admin# cm image refresh -i <image_name> -b
```

If the image is activated for diskless nodes, shut down the nodes assigned to the image, then activate the image.

```screen
admin# cm image activate -i <image_name> --force
```
