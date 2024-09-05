# Appendix B: Slingshot 200G NIC, Fabric Manager and Switch Workaround

## 2497306 Mellanox OFED kernel modules fail to load on CSM workers using 5.14.21-150500.55.39.1.27360.1.PTF.1215587-default kernel

Due to changes in the CSM worker node kernel, 5.14.21-150500.55.39.1.27360.1.PTF.1215587-default, SHS RPMs will not be loaded by default. The following change is needed during build time as an work-around.

- Append the following code at the end of `roles/install/tasks/main.yml` Ansible file during the `update-vcs-config` IUF stage:

  ```screen
  - block:
    - name: WAR NETETH-2313
      ansible.builtin.shell: |
        # $(uname -r ) returns IMS kernel instead of image kernel
        KERN=$( rpm -ql kernel-default | egrep '/lib/modules' | cut -d / -f 4 | head -n 1 )
        cd /lib/modules/${KERN}/weak-updates/updates
        for v in /lib/modules/5.14.21-150500.55.28.1.26977.2.PTF.1214754-default/updates/* ; do ln -s $v ; done
        depmod -a
        dracut --force --force-add 'dmsquash-live livenet' --kver ${KERN} --no-hostonly --no-hostonly-cmdline --printsize

    when:
      - shs_using_ncn_profile
  ```

[//]: # "EOF"
