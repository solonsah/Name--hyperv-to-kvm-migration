#!/usr/bin/env bash

# Read-only KVM host assessment for migration planning.
# Usage: ./kvm-host-precheck.sh [storage-path]
# This script makes no system changes.

set -uo pipefail

target_storage="${1:-/var/lib/libvirt/images}"

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
    "Read-only KVM host assessment." \
    "No VM, network, storage, or service configuration will be changed." \
    "Sanitize all generated output before sharing."

section "HOST INFORMATION"
run_check "Date" date --iso-8601=seconds
run_check "Operating system" cat /etc/redhat-release
run_check "Kernel" uname -r
run_check "Architecture" uname -m
run_check "CPU virtualization capabilities" lscpu
run_check "Memory availability" free -h

section "KVM AND LIBVIRT"
run_check "QEMU version" qemu-img --version
run_check "Virsh version" virsh --version
run_check "Virtualization support" virt-host-validate
run_check "Running virtualization services" systemctl --no-pager --type=service --state=running
run_check "Defined virtual machines" virsh list --all
run_check "Libvirt storage pools" virsh pool-list --all
run_check "Libvirt networks" virsh net-list --all

section "KERNEL MODULES"
for module in kvm kvm_intel kvm_amd vhost vhost_net; do
    printf '\n--- %s ---\n' "$module"

    if lsmod | awk '{print $1}' | grep -Fxq "$module"; then
        printf 'Loaded\n'
    else
        printf 'Not loaded or not applicable\n'
    fi
done

section "NETWORKING"
run_check "Network interfaces" ip -brief link
run_check "IP addresses" ip -brief address
run_check "Routes" ip route
run_check "NetworkManager connections" nmcli -t -f NAME,TYPE,DEVICE connection show
run_check "Linux bridges" bridge link

section "STORAGE"
printf '\nTarget storage path: %s\n' "$target_storage"

if [[ -d "$target_storage" ]]; then
    run_check "Target filesystem capacity" df -hT "$target_storage"
    run_check "Target filesystem details" findmnt -T "$target_storage"
    run_check "Target path permissions" ls -ldZ "$target_storage"
else
    printf 'Target storage path does not exist.\n'
fi

section "SECURITY STATE"
run_check "SELinux mode" getenforce
run_check "Firewall state" firewall-cmd --state

section "SYSTEM HEALTH"
run_check "Failed systemd units" systemctl --failed --no-pager
run_check "Recent high-priority kernel messages" journalctl -k -p err --no-pager -n 25

section "ASSESSMENT COMPLETE"
printf '%s\n' \
    "Review capacity, bridge mappings, security state, and virtualization health." \
    "Do not commit generated output containing real infrastructure details."