# Hyper-V to KVM Migration Framework

A structured and safety-focused framework for migrating Red Hat Enterprise Linux virtual machines from Microsoft Hyper-V to KVM/libvirt.

This project demonstrates migration planning, guest preparation, virtual disk conversion, libvirt configuration, validation, rollback planning, and operational documentation.

> This repository uses fictional systems and documentation-only network addresses. It contains no employer, customer, or production infrastructure data.

[![Shell Script Validation](https://github.com/solonsah/hyperv-to-kvm-migration/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/solonsah/hyperv-to-kvm-migration/actions/workflows/shellcheck.yml)

## Project Objectives

- Reduce migration risk through repeatable prechecks
- Prepare RHEL guests for KVM virtio devices
- Convert Hyper-V virtual disks into KVM-compatible formats
- Validate storage, networking, boot mode, and application health
- Define clear rollback conditions and recovery steps
- Maintain an auditable migration record

## Migration Workflow

1. Assess the Hyper-V source virtual machine
2. Validate RHEL guest readiness
3. Prepare virtio-capable initramfs
4. Confirm KVM host capacity and networking
5. Establish the migration and rollback window
6. Shut down the source virtual machine
7. Export and verify the source virtual disk
8. Convert the disk to `qcow2`
9. Apply ownership and SELinux labeling
10. Define the KVM virtual machine
11. Start and validate the migrated guest
12. Complete application acceptance testing
13. Retain rollback assets until approval

## Repository Structure

```text
.
├── checklists/      # Pre-migration and acceptance checklists
├── diagrams/        # Architecture and migration-flow diagrams
├── docs/            # Procedures, risk controls, and rollback plans
├── sample-output/   # Fictional examples of successful validation
├── scripts/         # Sanitized assessment and validation helpers
└── templates/       # Generic libvirt configuration templates
