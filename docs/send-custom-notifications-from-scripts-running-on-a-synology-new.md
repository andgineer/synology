---
created: 2023-11-15T08:38:40 (UTC +01:00)
tags: []
source: https://www.beatificabytes.be/2016/11/11/send-custom-notifications-from-scripts-running-on-a-synology-new/
author: 
---

# Send Custom Notifications from scripts running on a Synology [new] – BeatificaBytes

> ## Excerpt
> This is an update of a old post written for DSM 4 and 5: how to use the native Notification Mechanism of Synology to sent custom notifications. It’s now tested on my DS1815+ with DSM 6.0.

---
This is an update of a old post written for DSM 4 and 5: how to use the native Notification Mechanism of Synology to sent custom notifications. It’s now tested on my DS1815+ with DSM 6.0.

First, define the Notifications to be sent:

1.  Open a dos command prompt, and execute: telnet <YourSynoHostname>
    1.  As an alternative, I am using the free telnet client “[Putty](https://www.beatificabytes.be/launch-a-ssh-console-onto-synology-with-putty/)” to open SSH Console.
2.  Login as administrator
3.  Once connected via telnet, enter the root mode with the command ‘sudo -i’, using here also the password of your administrator
4.  Execute next: cd /usr/syno/synoman/webman/texts/
5.  Execute: ls
6.  Now you see a list of folders for each language supported by your Synology. You must **at least** defined your custom notifications in the ‘enu’ version and next the version that match your language.
7.  Copy the file with the definition of the existing notifications in a shared folder to edit it easily: cp enu/mails /volume1/web/
    1.  I presume here that the web station is enabled, otherwise, copy the file ‘mails’ in any other shared folder.
    2.  As an alternative, you can use the Package “[Config File Editor](http://www.mertymade.com/syno/#cfe)” to edit “/usr/syno/synoman/webman/texts/enu/mails”
8.  Edit now this file ‘mails’ (e.g.: with notepad++: \\\\<yourSynoHostname>\\web\\mails)
9.  Add your new custom “tags” at the end of the file with an adequate definition (see bellow for an example). You must specify a Title, a Subject, the text, and a Category with its priority. The category is used to group the Notifications in the DSM > Control Panel > Notification > Advanced Tab. For each Category, specify one of the possible values with a “Priority”, separated by a coma. The priority is used to filter the notifications in the “Advanced” tab (Look at existing tags in the file for illustration):
    1.  Possible values for “Category”
        1.  Backup/Restore: group under ‘Backup and Restoration’ in the “Advanced” tab
        2.  CMS
        3.  External Storage
        4.  HA: grouped under ‘High-availability cluster’
        5.  AHA: not displayed in the “Advanced” tab but related to External Storage
        6.  Storage: grouped under ‘Internal Storage’
        7.  USB Copy: not displayed in the “Advanced” tab but related to External Storage
        8.  Power System: grouped under ‘Power supply’
        9.  System
        10.  PerfEvent: not displayed in the “Advanced” tab but related to System
    2.  Possible values for “Priority”
        1.  Important: displayed as Critical
        2.  (no value): displayed as Informative
            
            [![Synology Notifications](https://www.beatificabytes.be/wp-content/uploads/2013/12/NotificationsList-161x300.png)](https://www.beatificabytes.be/wp-content/uploads/2013/12/NotificationsList.png)
            
            Synology Notifications
            
10.  Save your changes (E.g.: back to the telnet console, execute: cp /volume1/web/mails enu/mails)

Examples:

\[MySqlBkpError\]

Category: Backup/Restore,Important  
Title: Database backup failed  
Subject: Database backup on %HOSTNAME% has failed

Dear User,

Database backup on %HOSTNAME% has failed.

\[MySqlBkpOK\]

Category: Backup/Restore  
Title: Database backup completed  
Subject: Database backup on %HOSTNAME% has succeeded

Dear User,

Database backup on %HOSTNAME% has successfully completed.

Next, define how to sent those custom Notifications if and only if they are in a Category which does not appear in the “Advanced” tab of the “Control Panel” > “Notifications” pane > “Advanced” tab (Ex.: the categoryPerfEvent). It’s indeed via that Tab that you should to enable  the desired delivery modes: “email”, “sms”, …. which is obviously only possible for Notifications in a Category which is displayed.

1.  Go back to the telnet console and execute: cp /usr/syno/etc/notification/notification\_filter.settings /volume1/web/  
    1.  As an alternative, you can use the Package “[Config File Editor](http://www.mertymade.com/syno/#cfe)” to edit “/usr/syno/etc/notification/notification\_filter.settings”
2.  Edit the file ‘notification\_filter.settings’ (E.g. with notepad++)
3.  At the end of that file, insert a configuration line for each custom tag, specifying how the notification must be sent (Look at the other line for illustrations). Possible delivery mode are:
    1.  mail
    2.  sms
    3.  mobile
    4.  cms: this is the native popup notification mechanism of DSM, enabled by default for all notifications
    5.  msn: [not supported anymore](https://www.synology.com/en-global/knowledgebase/DSM/tutorial/General/Why_are_Skype_and_MSN_push_notifications_no_longer_supported_in_DSM) since 17th July 2014
    6.  skype: [not supported anymore](https://www.synology.com/en-global/knowledgebase/DSM/tutorial/General/Why_are_Skype_and_MSN_push_notifications_no_longer_supported_in_DSM) since 17th July 2014
4.  Copy the file back to its original location: cp /volume1/web/notification\_filter.settings /usr/syno/etc/

Examples:

MySqlBkpOK=”mail”

MySqlBkpError=”mail”

Now, reboot your Synology

It seems that in the past, I was able to apply my changes in those files without a reboot. But while testing this trick on DSM 6.x, I didn’t find how to do it without a reboot.

Finally, modify your script to sent your notifications:

1.  Edit your script (E.g. with notepad++).
2.  Add where required the following command: /usr/syno/bin/synonotify <YourCustomTag>
3.  Save your changes.

In the example here after, I sent notifications depending on the success or failure of the previous command:

if \[ $? -eq 0 \] then /usr/syno/bin/synonotify MySqlBkpOK  
else /usr/syno/bin/synonotify MySqlBkpError  
fi

Finally, check that the “Notifications” are enabled on your Synology and tick options like emails, SMS, … for the new tags if required:

1.  In your DSM, go to “Control Panel” > “Notification” > “E-Mail”
2.  Tick the option “Enable e-mail notifications”.
3.  Complete all the fields in that tab. At least: SMTP server, SMTP port, SMTP authentication and Primary email.
4.  Send also a test mail from this tab to verify your settings.
5.  Go next to the “Advanced” tab
6.  Tick the “E-mail” option (and possibly others) for the new tags which appear now in the list.
    1.  If the tags do not appear, ~close and reopen the control panel.~ restart your DSM!
    2.  The tags appear with their Title under their Category

[![Notifications Configuration](https://www.beatificabytes.be/wp-content/uploads/2013/12/NotificationsConfig-300x143.png)](https://www.beatificabytes.be/wp-content/uploads/2013/12/NotificationsConfig.png)

Notifications Configuration

And here are the outcomes: a popup message and an email

[![Database Backup Email](https://www.beatificabytes.be/wp-content/uploads/2013/12/DatabaseBackupEmail-300x158.png)](https://www.beatificabytes.be/wp-content/uploads/2013/12/DatabaseBackupEmail.png)

Database Backup Email

[![Database Backup Custom Notification](https://www.beatificabytes.be/wp-content/uploads/2013/12/DatabaseBackupNotification1-300x195.png)](https://www.beatificabytes.be/wp-content/uploads/2013/12/DatabaseBackupNotification1.png)

Database Backup Custom Notification

Pay attention that the tags are case sensitive ! Also backup the changes you made in the file ‘mails’ and ‘notification\_category’ as they will be overwritten for sure when you will update the DSM… Finally, delete the files ‘mails’ and ‘notification\_category’ from your web folder…

Notice: the user EConceptApplications suggested on Synology Forum to use a script as here under to automatically reinsert the notifications

grep -q “MySqlBkpOK” /usr/syno/etc/notification/notification\_filter.settings  
if \[ $? -ne 0 \] then

echo MySqlBkpOK=”mail” >> /usr/syno/etc/notification/notification\_filter.settings

fi

Notice: a reader, k13tas, suggested that it was much easier to reuse an existing notification tag and customize its text via Control Panel > Notification > Advanced. Indeed, those changes are not lost after a DSM update.

Notice: a reader, Rusmin, posted here that he found how to pass parameters to be used  in the notification message, via a hash json string. In his sample, one passes the value “value1” via a variable named %VAR1%. The value can obviously come from any variable of your shell script. Ex.: $PPID, $MyVariable, $$, etc…

Usage: /usr/syno/bin/synonotify tag\_event \[hash\_json\_string\]

/usr/syno/bin/synonotify Tag\_Name ‘{“\[%VAR1%\]”: “value1”, “\[%VAR2%\]”: “value2”}’

NB: another reader, Paul Marcos, reports however that for him:

this wouldn’t work with the brackets:

/usr/syno/bin/synonotify Tag\_Name ‘{“\[%VAR1%\]”: “value1”}’

but this, without the brackets would:

/usr/syno/bin/synonotify Tag\_Name ‘{“%VAR1%”: “value1”}’
