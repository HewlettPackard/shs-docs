# Post-install tasks

The `slingshot-network-config` RPM provides template configuration files to be used to create site-specific configuration files.
The configuration templates are found in the `/opt/slingshot/slingshot-network-config/default/share` directory, while the binaries and scripts are found in the `/opt/slingshot/slingshot-network-config/default/bin` directory.
When `slingshot-network-config` is installed, the RPM creates a link from the specific installed version of the RPM to a `default` link so that it is easy for customers to reference files between releases.
