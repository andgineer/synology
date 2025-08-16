# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains shell scripts for Synology NAS maintenance and backup tasks. The codebase consists of bash scripts that handle rsync operations, SMART drive monitoring, and system notifications using Synology's native notification system.

## Key Components

### Script Categories
- **Backup Scripts**: `rsync series2.sh`, `rsync PlexFolders.sh`, `rsync time machine.sh` - Perform data synchronization between volumes
- **Monitoring Scripts**: `Ext drives SMART info.sh`, `External drives temp.sh` - Monitor external drive health and temperature
- **Verification Scripts**: `Check backup series2.sh`, `Check external disks tags.sh` - Validate backup operations and disk status

### Directory Structure
- `task_scripts/` - Contains all operational bash scripts
- `docs/` - Documentation including notification setup guide
- `mails` - Directory for mail templates (empty in current state)

## Script Architecture

### Rsync Operations
Scripts use standard rsync patterns with common flags:
- `--recursive --checksum --dry-run --delete` for verification scripts
- `-av` for actual sync operations
- Standard exclusions: `@eaDir`, `.DS_Store`

### Volume Paths
Scripts operate on specific USB volume paths:
- `/volumeUSB3/usbshare/` - Source volumes
- `/volumeUSB4/usbshare/` - Backup destinations

### SMART Monitoring
- Uses `smartctl` to query external USB drives (`/dev/usb1` through `/dev/usb5`)
- Temperature monitoring with configurable thresholds (default: 40°C)
- Health status checks for drive reliability metrics

### Exit Code Conventions
Scripts use exit codes to indicate status:
- `0` - Success/no issues found
- `1` - Failure/issues detected (used for notification triggers)

## Synology Notification System

The repository includes comprehensive documentation for setting up custom notifications through Synology DSM. Key files involved:
- `/usr/syno/synoman/webman/texts/enu/mails` - Notification templates
- `/usr/syno/etc/notification/notification_filter.settings` - Notification routing
- Scripts trigger notifications via `/usr/syno/bin/synonotify`

### Custom Notification Categories
- `Backup/Restore` - For backup operation status
- Categories support priority levels: `Important` (Critical) or default (Informative)

## Development Notes

### Testing Scripts
- Use `--dry-run` flag with rsync for safe testing
- Scripts include timestamp output via `date` command for logging
- Temperature and SMART scripts output structured data for monitoring

### Adding New Scripts
- Follow existing naming convention with descriptive names
- Include proper exit code handling for notification integration
- Use consistent volume path patterns
- Add timestamp logging where appropriate

### Notification Integration
- Define notification templates in mails file following existing format
- Configure delivery methods in notification_filter.settings
- Use meaningful tag names that reflect script purpose
- Test notifications after DSM reboots (required for new configurations)