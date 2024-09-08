# Synology Scripts

Rsync tools for internal and external Synology storage.

### Notifications
Adapted from [www.beatificabytes.be article](docs/send-custom-notifications-from-scripts-running-on-a-synology-new.md)

#### Define template
Add `/usr/syno/synoman/webman/texts/enu/mails` content to
`/usr/syno/synoman/webman/texts/enu/notification_category`

- The `Category` is used to group the Notifications in the `DSM` > `Control Panel` > `Notification` > `Advanced` Tab
- Each Category separated by comma with Priority

#### Define notification
`/usr/syno/etc/notification/notification_filter.settings`

##### Old version
Look for the following definition in that file: {"group":"Backup/Restore","name":"NetBkpS3OK","title":"Amazon S3 backup completed"}

Insert the following definition next to it:

    ,{"group":"Backup/Restore","name":"MySqlBkpOK","title":"Database Backup completed"},{"group":"Backup/Restore","name":"MySqlBkpError","title":"Database Backup failed"}

##### New version
At the end of that file, insert a configuration line for each custom tag, like

    ChkBkpFail=”mail”

Reboot the Synology

#### Send notification
Add to script

    /usr/syno/bin/synonotify/ChkBkpFail

#### Enable notification
In DSM "Advanced" tab of the "Control Panel" > "Notifications" enable emails in this notification.

# External drives SMART

    sudo smartctl -a /dev/usb1 -d sat

2 minutes self-test

    sudo smartctl -t short /dev/usb1 -d sat

Temperature

    sudo smartctl -a /dev/usb2 -d sat | grep "Temperature_Celsius" | awk '{print $NF}'

Overall

    sudo smartctl -a /dev/usb2 -d sat | grep "test result"
