# Retry Handler

Each HPE Slingshot 200Gbps NIC must have a Retry Handler daemon running and they are indexed by device number, such as `cxi0`, `cxi1`, and so on.

**Note:** These instructions refer to `cxi0` in the example.

If the retry handler crashes for some reason, the node must be rebooted. Due to the crash, an unpredictable state (missing traffic that requires retry) may be reached, which can result in putting the fabric into a bad state. In addition, restarting the retry handler with any amount of traffic flowing, regardless if it would generate a PCT event, is not a safe operation. This must be avoided. If you want to deploy a new retry handler configuration, reload `cxi-core` or reboot the node.

`systemd` and `udev` must automatically handle starting the retry handler, but in case of issues, verify handlers:

```screen
# systemctl status -q cxi_rh@cxi0
  cxi_rh@cxi0.service - Cassini Retry Handler on cxi0
   Loaded: loaded (/usr/lib/systemd/system/cxi_rh@.service; static; vendor preset: disabled)
   Active: active (running) since Tue 2021-02-09 10:44:08 CST; 1min 17s ago
```

If the retry handler failed to start, verify that the corresponding `/dev/cxi<n>` device is present, and check for errors in dmesg.

```screen
# ls /dev/ | grep cxi
```

```screen
# journalctl | grep cxi_core
or
# dmesg -T |grep cxi
```

If you do not find any issues, manually start the retry handler again:

```screen
# systemctl start cxi_rh@cxi0.service
```

If there are persistent issues or if the retry handler has crashed, it is useful to gather logs:

```screen
# journalctl --output=short-precise -u cxi_rh@cxi0 >> $LOG_PATH
```

There are retry handler counters that are also useful to gather for debugging. These files can be found in `/run/cxi/cxi<n>`.

```screen
# ls /run/cxi/cxi0/
accel_close_complete   nack_no_matching_conn  nacks         sct_in_use    spt_timeouts_o  trs_in_use
cancel_tct_closed      nack_no_target_conn    nack_sequence_error   sct_timeouts  spt_timeouts_u
connections_cancelled  nack_no_target_mst     pkts_cancelled_o      smt_in_use    srb_in_use
ignored_sct_timeouts   nack_no_target_trs     pkts_cancelled_u      spt_in_use    tct_in_use
mst_in_use         nack_resource_busy     rh_sct_status_change  spt_timeouts  tct_timeouts
```

Inside the "config" subdirectory there are counters related to retry handler configuration. For example, to get the current config file path you can use the following command:

```screen
# cat /run/cxi/cxi0/config/config_file_path
/scratch/shared/libcxi/install/etc/cxi_rh.conf
```

## Log Levels

The CXI Retry Handler supports multiple log levels, following the "SD-DAEMON" conventions. See the following man page for more details.

```screen
man sd-daemon
```

One of the following log levels should be used: _SD_NOTICE_(5), _SD_INFO_(6), _SD_DEBUG_(7), where _SD_DEBUG_ is the most verbose option. Since `cxi_rh` is a systemd service, normal systemd mechanisms can be used to adjust the log level. Each systemd service has a service file specifying certain configuration info. The service file for the RH is distributed as part of its RPM.

We can either edit the service file directly, or create an override file.

_**Method 1: Override File**_

1. Open a built in file editor and creates an empty override file.

   ```screen
   systemctl edit cxi_rh@cxi0
   ```

2. Add the following two lines, then save and quit.

   ```screen
   [Service]
   LogLevelMax=5
   ```

   The resulting file is saved to:

   ```screen
   /etc/systemd/system/cxi_rh@cxi0.service.d/override.conf
   ```

3. Restart the retry handler for these settings to take effect.

   ```screen
   systemctl restart cxi_rh@cxi0
   ```

These steps must be repeated for each `cxi_rh` instance (e.g. cxi1, cxi2, etc.).

_**Method 2: Modify Service File Directly**_

This method only requires changing one file as all the `cxi_rh` instances should refer to the same service file. The typical path to the service file is:

```screen
/usr/lib/systemd/system/cxi_rh@.service
```

1. In the service file, edit the "LogLevelMax" line to the desired level. For example to use the log level _SD_NOTICE_(5):

   ```screen
   LogLevelMax=5
   ```

2. Since the service file of a running unit was modified, the following command must be executed.

   ```screen
   systemctl daemon-reload
   ```

3. Restart the retry handler(s):

   ```screen
   systemctl restart cxi_rh@cxi1
   ```
