# Multiple network adapters

If a host has multiple network adapters connected to the HPE Slingshot fabric, it is recommended that each host run the `/usr/bin/slingshot-ifroute` script.
The script assumes that the network adapters follow the recommended prefix and attempts to configure the host with a routing policy required for a multi-homed network.
Every network adapter in a multi-home configuration should be able to communicate with every other network adapter in the multi-home configuration without the use of a bridge.
In addition, the routing modifications performed by the script ensure that traffic destined for one network adapter on a host from another network adapter on the same host should use the HPE Slingshot network instead of the host's loopback device.
This specific modification is a requirement for correct network data transfer behavior as required by some HPC API standards such as MPI, SHMEM, or PGAS.

Run an HPE Slingshot routing configuration utility for multi-homed networks.

```screen
root@host ~# /usr/bin/slingshot-ifroute
... <example output from the command>
```

As a result of the script, new routing tables and policies should be created in the kernel network routing tables.

The routing script should be run after all network adapters have been named by `systemd` or `udev`. As an alternative solution, the routing script can also be run as part of the `POST_UP` section of an `ifconfig` configuration file for the interface.
