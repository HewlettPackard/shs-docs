# Install compute nodes

Perform this procedure to install SHS on compute nodes.

## Install via package managers (recommended)

1. For each distribution and distribution version, download the required RPMs mentioned in the _HPE Slingshot Host Software Release Notes_.

2. Copy or move the RPMs to a location accessible to one or more hosts.
   This can be a network file share, a physically backed location such as a disk drive on the host, or a remotely accessible location such as a web server that hosts the RPMs.

3. Modify the host or host OS image to add a repository for the newly downloaded RPMs for the package manager used in the OS distribution. Select the RPMs from the distribution file for your environment (`slingshot_compute_cos-2.4...` for COS 2.4, `slingshot_compute_sle15_sp4` for SLE15_sp4, and so on).

   For SLE 15, `zypper` is used as the package manager for the host. A Zypper repository should be added which provides the path to the RPMs are hosted. An example for this could be the following:

   Assume that the RPMs were downloaded and added to a web server that is external to the host,
   located at the following path: `https://content-server.cust.net/rpms/sles15/sp4/slingshot-2.0.2`

   An example command to add the repository to the host or host OS image could be the following:

   ```screen
   root@host: ~# zypper ar --help
   addrepo (ar) [OPTIONS] <URI> <ALIAS>
   addrepo (ar) [OPTIONS] <FILE.repo>

   Add a repository to the system.
   The repository can be specified by its URI or can be read from specified .repo file (even remote).

     Command options:
   ...
   -c, --check                 Probe URI.
   ...
   -p, --priority <PRIORITY>   Set priority of the repository. Default: 0
   ...
   -G, --no-gpgcheck           Disable GPG check for this repository.
   ...
   root@host: ~# zypper ar -c -p 1 \
   -G https://content-server.cust.net/rpms/sles15/sp4/slingshot-2.0.2 slingshot-2.0.2
   ```

   The commands above would have displayed the help for the `zypper add-repo`
   command, and then added the URL above to the local host's Zypper registry
   of repositories where packages could be located. The second command would have
   done the following:

   1. Added an entry to the registry pointing to the URL.
   2. Ensured that Zypper would check to make sure the URL is valid.
   3. Set the priority of the repository higher than the default priority to ensure that the Slingshot version of libfabric was chosen over the distribution-provided version of libfabric.
   4. Told Zypper to ignore the GPG check on the repository.

   The `zypper ar` command should be tailored specifically to the customer's environment as needed and is only provided here as an example.

## Install via command line

1. For each distribution and distribution version, download the required RPMs mentioned in the _HPE Slingshot Host Software Release Notes_.

2. Copy or move the RPMs to a location accessible to one or more hosts.
   This can be a network file share, or a physically backed location such as a disk drive on the host.
