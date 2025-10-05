# Synology Scripts

Rsync tools and monitoring scripts for internal and external Synology storage.

## Notifications
Adapted from [www.beatificabytes.be article](docs/send-custom-notifications-from-scripts-running-on-a-synology-new.md)

### Define Template
Copy content from `/usr/syno/synoman/webman/texts/enu/mails` to `/usr/syno/synoman/webman/texts/enu/notification_category`

- The `Category` groups notifications in the DSM `Control Panel` > `Notification` > `Advanced` tab
- Categories are separated by commas with priority levels

### Define Notification
Edit `/usr/syno/etc/notification/notification_filter.settings`

#### DSM 6 and Earlier
Look for this definition: `{"group":"Backup/Restore","name":"NetBkpS3OK","title":"Amazon S3 backup completed"}`

Insert the following definition next to it:
```
,{"group":"Backup/Restore","name":"MySqlBkpOK","title":"Database Backup completed"},{"group":"Backup/Restore","name":"MySqlBkpError","title":"Database Backup failed"}
```

#### DSM 7 and Later
At the end of the file, insert a configuration line for each custom tag:
```
ChkBkpFail="mail"
```

Reboot the Synology.

### Send Notification
Add to script:
```bash
/usr/syno/bin/synonotify ChkBkpFail
```

### Enable Notification
In the DSM `Control Panel` > `Notification` > `Advanced` tab, enable emails for this notification.

## External Drives SMART

### Full SMART Info
```bash
sudo smartctl -a /dev/usb1 -d sat
```

### 2-Minute Self-Test
```bash
sudo smartctl -t short /dev/usb1 -d sat
```

### Temperature Check
```bash
sudo smartctl -a /dev/usb2 -d sat | grep "Temperature_Celsius" | awk '{print $NF}'
```

### Overall Health
```bash
sudo smartctl -a /dev/usb2 -d sat | grep "test result"
```
