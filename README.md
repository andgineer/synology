# Synology
Synology scripts

### Notifications

Add content of `mails` to `/usr/syno/synoman/webman/texts/enu/mails`.

[Custom notification](https://www.beatificabytes.be/send-custom-email-notifications-from-scripts-running-on-a-synology/)

`/usr/syno/synoman/webman/texts/enu/notification_category`

Look for the following definition in that file: {"group":"Backup/Restore","name":"NetBkpS3OK","title":"Amazon S3 backup completed"}

Insert the following definition next to it:

    ,{"group":"Backup/Restore","name":"MySqlBkpOK","title":"Database Backup completed"},{"group":"Backup/Restore","name":"MySqlBkpError","title":"Database Backup failed"}

In DSM "Advanced" tab of the "Control Panel" > "Notifications" enable emails in this notification.

# External drives SMART

    sudo smartctl -a /dev/usb1 -d sat

2 minutes self-test

    sudo smartctl -t short /dev/usb1 -d sat

Temperature

    sudo smartctl -a /dev/usb2 -d sat | grep "Temperature_Celsius" | awk '{print $NF}'

Overall

    sudo smartctl -a /dev/usb2 -d sat | grep "test result"
