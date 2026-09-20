# Post-Migration Validation Checklist

Use this checklist after the first successful KVM boot and before declaring the migration complete.

## Virtual Machine State

- [ ] KVM guest starts without unexpected errors
- [ ] Guest console is accessible
- [ ] Correct boot disk is selected
- [ ] Expected vCPU count is visible
- [ ] Expected memory is visible
- [ ] Virtual disks are attached correctly
- [ ] Virtual network interfaces are attached to the correct bridges
- [ ] Autostart remains disabled until final approval

## Operating System

- [ ] RHEL reaches the expected target state
- [ ] Expected kernel is running
- [ ] System architecture is correct
- [ ] Boot completed without emergency mode
- [ ] System time and timezone are correct
- [ ] No unexpected failed systemd units exist
- [ ] SELinux is in the expected mode
- [ ] No new critical boot errors are present

## Storage

- [ ] Root filesystem is mounted read-write
- [ ] `/boot` is mounted correctly
- [ ] Application filesystems are mounted
- [ ] Swap is active
- [ ] LVM physical and logical volumes are healthy
- [ ] Filesystem usage is within acceptable limits
- [ ] `/etc/fstab` entries resolve correctly
- [ ] No unexpected I/O errors are present
- [ ] QCOW2 image information is valid

## Networking

- [ ] Expected network interfaces are present
- [ ] Interface names match the intended configuration
- [ ] Correct IP address and prefix are assigned
- [ ] Default gateway is correct
- [ ] Expected routes are present
- [ ] DNS servers are configured correctly
- [ ] Gateway connectivity succeeds
- [ ] DNS resolution succeeds
- [ ] SSH access succeeds
- [ ] Required application ports are listening
- [ ] No duplicate-IP condition exists

## Services and Application

- [ ] Required services are active
- [ ] Application starts successfully
- [ ] Application health check passes
- [ ] Application logs show no unexpected migration-related errors
- [ ] Scheduled jobs and timers are present
- [ ] Monitoring agent is reporting
- [ ] Backup agent is reporting
- [ ] Security agent is reporting, where applicable
- [ ] Application owner completes functional testing

## Performance and Stability

- [ ] CPU usage is within the expected range
- [ ] Memory usage is within the expected range
- [ ] Disk latency is acceptable
- [ ] Network connectivity is stable
- [ ] No repeated kernel, storage, or network errors appear
- [ ] Guest remains stable during the observation period

## Migration Closure

- [ ] Application owner approves the migrated system
- [ ] Monitoring confirms normal operation
- [ ] Autostart setting is configured as approved
- [ ] Source Hyper-V VM remains powered off
- [ ] Rollback assets are retained for the agreed period
- [ ] Migration records are updated
- [ ] Final status is communicated
- [ ] Rollback assets are removed only after formal approval