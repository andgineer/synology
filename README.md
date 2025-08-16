# Synology Scripts

Rsync tools and monitoring scripts for internal and external Synology storage.

## Notifications
Adapted from [www.beatificabytes.be article](docs/send-custom-notifications-from-scripts-running-on-a-synology-new.md)

### Define template
Add `/usr/syno/synoman/webman/texts/enu/mails` content to `/usr/syno/synoman/webman/texts/enu/notification_category`

- The `Category` groups notifications in `DSM` > `Control Panel` > `Notification` > `Advanced` tab
- Each category separated by comma with priority

### Define notification
Edit `/usr/syno/etc/notification/notification_filter.settings`

#### Old version
Look for this definition: `{"group":"Backup/Restore","name":"NetBkpS3OK","title":"Amazon S3 backup completed"}`

Insert the following definition next to it:
```
,{"group":"Backup/Restore","name":"MySqlBkpOK","title":"Database Backup completed"},{"group":"Backup/Restore","name":"MySqlBkpError","title":"Database Backup failed"}
```

#### New version
At the end of the file, insert a configuration line for each custom tag:
```
ChkBkpFail="mail"
```

Reboot the Synology.

### Send notification
Add to script:
```bash
/usr/syno/bin/synonotify ChkBkpFail
```

### Enable notification
In DSM "Advanced" tab of "Control Panel" > "Notifications", enable emails for this notification.

## External Drives SMART

### Full SMART info
```bash
sudo smartctl -a /dev/usb1 -d sat
```

### 2-minute self-test
```bash
sudo smartctl -t short /dev/usb1 -d sat
```

### Temperature check
```bash
sudo smartctl -a /dev/usb2 -d sat | grep "Temperature_Celsius" | awk '{print $NF}'
```

### Overall health
```bash
sudo smartctl -a /dev/usb2 -d sat | grep "test result"
```
