# Logging

`systemd` services handle logging through the `systemd` journal, which is managed by `journald`.
Logs are stored in `/run/log/journal/` (temporary) and `/var/log/journal/` (persistent).

## View logs

These logs can be queried using a command such as:

```screen
journalctl -u cxi_rh@cxi0
```

## Log levels

As of the SHS 11.1 release, the RH primarily uses four log Levels. Some messages have been moved to different levels as compared to previous releases.

- **LOG_WARN**: Cancellation Related Messages, Config Messages, Connection Level Messages (SCTs, TCTs), Retrying a Connection.
- **LOG_NOTICE**: SPT Timeouts, Retry Completes for Timed out Packets.
- **LOG_INFO**: NACKS, Retry Completes for NACKs, and Retry messages for all SPTs.
- **LOG_DEBUG**: Internal RH debug help messages.

## Set the default log level

The default log level is set via the `systemd` service file for `cxi_rh` via the `LogLevelMax` parameter. This `systemd` service log level cannot be changed live.
A change to the service file requires that a service is restarted - which is unsafe to do for `cxi_rh`.
To change the default log level, modify the service file or a service override file.

## Change the log level dynamically

To dynamically change the RH Log Level (for cxi0 in this example) one may write to the `/run/cxi/cxi0/config/log_increment`:

- To increase verbosity by one step:

  ```screen
  echo 1 > /run/cxi/cxi0/config/log_increment
  ```

- To decrease verbosity by two steps:

  ```screen
  echo -2 > /run/cxi/cxi0/config/log_increment
  ```

Accepted values are in the range -7 to 7. Increment or decrement will be capped based on base LogLevelMax.
For example, if the base log level is `LOG_DEBUG (7)`, you cannot increase the log level further.

## Log forwarding

It is not uncommon for systems to be set up in such a way that journald logs are forwarded to traditional logging systems like rsyslog.
However, this can lead to unnecessary duplication as the logs will be present in multiple places.
To check if `journald` is being forwarded to syslog look for the `ForwardToSyslog` parameter in `/etc/systemd/journald.conf`.

It is possible (though not required) to drop `cxi_rh` messages sent to rsyslog to avoid duplication.
To avoid duplication, an optional rsyslog filter can be created at `/etc/rsyslog.d`. See the external [rsyslog filters](https://www.rsyslog.com/doc/configuration/filters.html) documentation for more information.
