# Semaphore file already exists

`cxi_heatsink_check` uses two semaphore files to synchronize processes.
The semaphore files are named based on the CXI device ID. For example, with cxi0 the files are `/dev/shm/sem.cxi_heatsink_p_cxi0` and `/dev/shm/sem.cxi_heatsink_c_cxi0`.
If either of these exists, `cxi_heatsink_check` cannot run.

```screen
sem_open(/cxi_heatsink_p_cxi0): File exists
```

Before deleting the semaphore files, check to see if `cxi_heatsink_check` is already running. Wait for any running processes to finish, or try to terminate them:

```screen
pkill cxi_heatsink_check
```

A single SIGINT or SIGTERM signal is often enough to break the processes out of their loops and cause them to clean up all NIC resources that were allocated through the driver. If they do not finish running within several seconds, they can be killed with a second SIGTERM.

**Note:** Killing the processes with SIGKILL or a second SIGTERM may result in degraded NIC performance until the next node reboot.
