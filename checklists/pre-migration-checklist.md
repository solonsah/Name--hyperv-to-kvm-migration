# Pre-Migration Checklist

Use this checklist before migrating a RHEL virtual machine from Hyper-V to KVM/libvirt.

## Authorization and Planning

- [ ] Migration request and business justification documented
- [ ] System owner and application owner identified
- [ ] Approved maintenance window confirmed
- [ ] Expected outage communicated
- [ ] Console access to both hypervisors confirmed
- [ ] Rollback decision deadline established
- [ ] Acceptance-test owner identified
- [ ] Backup or recovery requirements confirmed

## Source Hyper-V Virtual Machine

- [ ] VM name recorded using a sanitized migration worksheet
- [ ] Hyper-V generation confirmed
- [ ] Boot mode confirmed as BIOS or UEFI
- [ ] Secure Boot status recorded
- [ ] vCPU and memory configuration recorded
- [ ] Virtual disk count, format, and size recorded
- [ ] Network adapters and VLAN assignments recorded
- [ ] Static MAC dependencies reviewed
- [ ] Checkpoints identified and handled appropriately
- [ ] Integration-service dependencies reviewed
- [ ] Source VM shutdown procedure validated

## RHEL Guest Readiness

- [ ] RHEL version and architecture confirmed
- [ ] Current kernel recorded
- [ ] Known-good fallback kernel available
- [ ] Bootloader configuration reviewed
- [ ] Root filesystem and `/boot` layout documented
- [ ] Filesystem UUIDs recorded
- [ ] `/etc/fstab` reviewed for device-name dependencies
- [ ] LVM configuration reviewed
- [ ] Free disk space checked
- [ ] NetworkManager profiles reviewed
- [ ] Persistent Hyper-V interface naming dependencies identified
- [ ] Required services and listening ports recorded
- [ ] Application start and stop procedures documented
- [ ] Guest health is acceptable before migration

## Virtio Preparation

- [ ] Virtio block driver available
- [ ] Virtio SCSI driver available
- [ ] Virtio network driver available
- [ ] Virtio PCI driver available
- [ ] Initramfs backup created
- [ ] Virtio-capable initramfs generated
- [ ] New initramfs inspected successfully
- [ ] Default boot kernel confirmed

## Destination KVM Host

- [ ] KVM and libvirt services healthy
- [ ] Compatible machine type selected
- [ ] Destination boot mode matches the source guest
- [ ] Sufficient CPU and memory capacity available
- [ ] Sufficient storage capacity available
- [ ] Storage pool path validated
- [ ] Destination filesystem supports the planned image
- [ ] Required Linux bridges exist
- [ ] VLAN mappings validated
- [ ] Firewall and security requirements reviewed
- [ ] SELinux is enforcing and labeling procedure is documented
- [ ] VM console access tested
- [ ] Autostart remains disabled during initial validation

## Transfer and Conversion

- [ ] Source disk will remain unchanged during rollback retention
- [ ] Transfer method selected
- [ ] Transfer path has sufficient capacity
- [ ] Source checksum will be captured
- [ ] Transferred checksum will be compared
- [ ] `qemu-img info` validation planned
- [ ] VHDX-to-QCOW2 conversion command reviewed
- [ ] QCOW2 destination path confirmed
- [ ] Ownership and SELinux context procedures reviewed

## Network and Application Validation

- [ ] Destination bridge selected
- [ ] IP address, prefix, gateway, and DNS settings documented
- [ ] Duplicate-IP prevention plan confirmed
- [ ] Source and destination will not run simultaneously
- [ ] DNS validation steps documented
- [ ] SSH validation steps documented
- [ ] Required service checks documented
- [ ] Application health-check procedure documented
- [ ] Monitoring and alerting validation planned

## Final Go/No-Go Review

- [ ] All blocking issues resolved
- [ ] Migration commands peer-reviewed
- [ ] Rollback steps peer-reviewed
- [ ] Required personnel available
- [ ] Application owner authorizes shutdown
- [ ] Migration team records the start time
- [ ] Final go decision documented