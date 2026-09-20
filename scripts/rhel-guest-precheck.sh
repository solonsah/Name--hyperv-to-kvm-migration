#!/usr/bin/env bash

# Read-only RHEL guest assessment for Hyper-V to KVM migration planning.
# This script makes no system changes.
# Its output may contain host-specific information. Sanitize it before sharing.

set -uo pipefail

section() {
    printf '\n============================================================\n'
    printf '%s\n' "$1"
    printf '============================================================\n'
}

run_check() {
    local description="$1"
    shift

    printf '\n--- %s ---\n' "$description"

    if command -v "$1" >/dev/null 2>&1; then
        "$@" 2>&1 || printf 'Check returned a non-zero status.\n'
    else
        printf 'Command not available: %s\n' "$1"
    fi
}

section "ASSESSMENT NOTICE"
printf '%s\n' \
    "Read-only assessment. No configuration changes will be made." \
    "Review and sanitize the output before storing or sharing it."

section "SYSTEM IDENTITY"
run_check "Date" date --iso-8601=seconds
run_check "Hostname information" hostnamectl
run_check "Operating system" cat /etc/redhat-release
run_check "Kernel" uname -r
run_check "Architecture" uname -m

section "BOOT MODE"
if [[ -d /sys/firmware/efi ]]; then
    printf 'Boot mode: UEFI\n'
else
    printf 'Boot mode: Legacy BIOS\n'
fi

section "COMPUTE RESOURCES"
run_check "CPU summary" lscpu
run_check "Memory summary" free -h

section "BLOCK DEVICES AND FILESYSTEMS"
run_check "Block devices" lsblk -e 7 -o NAME,TYPE,SIZE,FSTYPE,UUID,MOUNTPOINTS
run_check "Filesystem utilization" df -hT
run_check "Active swap" swapon --show
run_check "LVM physical volumes" pvs
run_check "LVM volume groups" vgs
run_check "LVM logical volumes" lvs

section "FSTAB REVIEW"
if [[ -r /etc/fstab ]]; then
    grep -Ev '^[[:space:]]*(#|$)' /etc/fstab || true
else
    printf '/etc/fstab is not readable.\n'
fi

section "BOOTLOADER AND INSTALLED KERNELS"
run_check "Kernel packages" rpm -q kernel
run_check "Default kernel" grubby --default-kernel
run_check "All boot entries" grubby --info=ALL

section "VIRTIO DRIVER AVAILABILITY"
for module in virtio virtio_pci virtio_blk virtio_scsi virtio_net; do
    printf '\n--- %s ---\n' "$module"

    if modinfo "$module" >/dev/null 2>&1; then
        modinfo -F filename "$module" 2>/dev/null || true
    else
        printf 'Module metadata not found.\n'
    fi
done

section "NETWORK CONFIGURATION"
run_check "Interfaces" ip -brief address
run_check "Routes" ip route
run_check "NetworkManager connections" nmcli -t -f NAME,TYPE,DEVICE connection show
run_check "DNS configuration" cat /etc/resolv.conf

section "SYSTEMD HEALTH"
run_check "Failed systemd units" systemctl --failed --no-pager

section "SECURITY STATE"
run_check "SELinux status" getenforce
run_check "Firewall state" firewall-cmd --state

section "VIRTUALIZATION INDICATORS"
run_check "Detected virtualization" systemd-detect-virt
run_check "Hyper-V related modules" lsmod

section "ASSESSMENT COMPLETE"
printf '%s\n' \
    "Review all findings before migration." \
    "Do not commit generated output containing real infrastructure details."