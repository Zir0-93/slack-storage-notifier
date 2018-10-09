#!/bin/bash
# ------------
hostname=${HOSTNAME}
# ------------
# Read webhook URL param
webhook_url=$1
if [[ $webhook_url == "" ]]; then
        webhook_url=${SLACK_WEBHOOK_URL}
        if [[ $webhook_url == "" ]]; then
                echo "No webhook_url specified"
                exit 1
        fi
fi
# ------------
# Rea
shift
channel=$1
if [[ $channel == "" ]]; then
        channel=${SLACK_CHANNEL}
        if [[ $channel == "" ]]; then
                echo "No channel specified, posting to default channel."
        fi
fi
# ------------
# Execute df-h
text="$(df -h)"
pretext="Summary of available disk storage space on *$hostname*."
# ------------
# Generate the JSON payload to POST to slack
json="{"
if [[ $channel != "" ]]; then
        json+="\"channel\": \"$channel\","
fi
json+="\"attachments\":["
IFS=$'\n'
for textLine in $text
do
        IFS=$' '
        words=($textLine)
        if [[ ${words[0]} == "Filesystem" ]]; then
                # This is the header line of df- h command
                json+="{\"text\": \"\`\`\`\n$textLine\n\`\`\`\", \"pretext\":\"$pretext\", \"color\":\"#0080ff\"},"
        else
                # Check the returned 'used' column to determine color
                if [[ ${words[4]} == 9* ]] || [[ ${words[4]} == 100* ]]; then
                        color="danger"
                elif [[ ${words[4]} == 7* ]] || [[ ${words[4]} == 8* ]]; then
                        color="warning"
                else
                        color="good"
                fi
                json+="{\"text\": \"\`\`\`\n$textLine\n\`\`\`\", \"color\":\"$color\"},"
        fi
done
# trim trailing comma
json="${json::-1}"
# -----------
# Complete JSON payload and make API request
json+="]}"
curl -s -d "payload=$json" "$webhook_url"
