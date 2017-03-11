#!/bin/bash

while getopts 'a:b:c:d:e:f:g:y:z:' opt ; do
  case $opt in
    a) NOTIFICATIONTYPE=$OPTARG ;;
    b) CLIENT=$OPTARG ;;
    c) HOSTSTATE=$OPTARG ;;
    d) HOSTOUTPUT=$OPTARG ;;
    e) SERVICEDESC=$OPTARG ;;
    f) SERVICESTATE=$OPTARG ;;
    g) SERVICEOUTPUT=$OPTARG ;;
    y) CHANNEL=$OPTARG ;;
    z) WEBHOOK_PATH=$OPTARG ;;
  esac
done

SLACK_HOSTNAME="slack_hostname.slack.com"
SLACK_BOTUSERNAME="nagios-alerts"
MONITORING_URL="https://nagios_server.domain/nagios"
SLACK_CHANNEL="#${CHANNEL}"
WEBHOOK_ADDRESS="https://hooks.slack.com/services/${WEBHOOK_PATH}"


if [ -x $HOSTSTATE ]; then

  if [ "$NOTIFICATIONTYPE" = "ACKNOWLEDGEMENT" ]; then
    ICON=":memo:"
  elif [ "$SERVICESTATE" = "CRITICAL" ]; then
    ICON=":no_entry:"
  elif [ "$SERVICESTATE" = "WARNING" ]; then
    ICON=":warning:"
  elif [ "$SERVICESTATE" = "OK" ]; then
    ICON=":white_check_mark:"
  elif [ "$SERVICESTATE" = "UNKNOWN" ]; then
    ICON=":question:"
  else
    ICON=":white_medium_square:"
  fi

  SLACK_MESSAGE="${ICON} *[${NOTIFICATIONTYPE}]* *<${MONITORING_URL}/#cgi-bin/status.cgi?host=${CLIENT}|${CLIENT}>* service <${MONITORING_URL}/#cgi-bin/extinfo.cgi?type=2&host=${CLIENT}&service=${SERVICEDESC}|${SERVICEDESC}> is *${SERVICESTATE}*\n_${SERVICEOUTPUT}_"

else

  if [ "$HOSTSTATE" = "UP" ]; then
    ICON=":white_check_mark:"
  elif [ "$HOSTSTATE" = "DOWN" ]; then
    ICON=":no_entry:"
  elif [ "$HOSTSTATE" = "UNREACHABLE" ]; then
    ICON=":warning:"
  else
    ICON=":white_medium_square:"
  fi

  SLACK_MESSAGE="${ICON} *[${NOTIFICATIONTYPE}]* *<${MONITORING_URL}/#cgi-bin/status.cgi?host=${CLIENT}|${CLIENT}>* is *${HOSTSTATE}*\n_${HOSTOUTPUT}_"

fi

curl -X POST --data-urlencode "payload={\"channel\": \"${SLACK_CHANNEL}\", \"username\": \"${SLACK_BOTUSERNAME}\", \"text\": \"${SLACK_MESSAGE}\"}" ${WEBHOOK_ADDRESS}
if [ $? -ne 0 ]; then
  # Try again with a method for older versions of curl
  curl -X POST -d "payload={\"channel\": \"${SLACK_CHANNEL}\", \"username\": \"${SLACK_BOTUSERNAME}\", \"text\": \"${SLACK_MESSAGE}\"}" ${WEBHOOK_ADDRESS}
fi
