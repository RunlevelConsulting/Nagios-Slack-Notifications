# Nagios Slack Notifications

## Overview

The official Nagios Slack plugin is terrible, requiring multiple random perl dependencies. This uses a simple curl script in conjunction with a Webhook to post notifications directly.

This method is far simpler and allows you to maintain your Nagios configuration in a single location. The way it's set up also allows the script to be re-used for multiple channels if necessary.
<br>
## Screenshot
![Screenshot of Notifications](https://cloud.githubusercontent.com/assets/7113258/17119622/9c77a67a-52f9-11e6-8255-93173b6ef9ed.png)
<br>
## Installation

### Slack
1. Go to the **Apps and Integrations** page within Slack, search for **Incoming Webhooks** and hit **Add Configuration**
2. Select the channel you wish to post alerts to and hit **Add Incoming Webhook Integration**
3. Make a note of the **Webhook URL** (You'll need the part past the **https://hooks.slack.com/services/** bit. e.g - **T07B2S2CC/B1HDDQ83A/naizPgXARIlUSixE0RUL93Oy**)
4. Change the **Customize Name** field to: **nagios-alerts**
5. Change the icon to the **icon.png** image in this repository.
6. Hit **Save Settings**

### Nagios

Add the following line to your Nagios configuration and modify the details:
```bash
define command {
  command_name		notify-host-slack-mychannel1 
  command_line		/bin/bash /path/to/nagios-monitoring-scripts/notification_slack.sh -a "$NOTIFICATIONTYPE$" -b "$HOSTNAME$" -c "$HOSTSTATE$" -d "$HOSTOUTPUT$" -y "CHANNEL_NAME_HERE" -z "WEBHOOK_ADDRESS_HERE"
}

define command {
  command_name		notify-service-slack-mychannel1 
  command_line		/bin/bash /path/to/nagios-monitoring-scripts/notification_slack.sh -a "$NOTIFICATIONTYPE$" -b "$HOSTNAME$" -e "$SERVICEDESC$" -f "$SERVICESTATE$" -g "$SERVICEOUTPUT$"  -y "CHANNEL_NAME_HERE" -z "WEBHOOK_ADDRESS_HERE"
}
```

### notification_slack.sh

Open the notification_slack.sh script and modify the **SLACK_HOSTNAME** and **MONITORING_URL** variables to your environment.
<br><br>
## Other Information

This script has been tested on multiple servers with different versions of curl. The script accounts for older versions of curl with another command.

Please fork and contribute if you find any bugs.
