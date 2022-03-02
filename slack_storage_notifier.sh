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
pretext=" *$hostname* サーバのディスク容量が危険です。"
# ------------
# Generate the JSON payload to POST to slack
json="{"
if [[ $channel != "" ]]; then
        json+="\"channel\": \"$channel\","
fi
json+="\"attachments\":["
disks=""
IFS=$'\n'
for textLine in $text
do
        IFS=$' '
        words=($textLine)
        if [[ ${words[0]} == "Filesystem" ]]; then
                # This is the header line of df- h command
                json+="{\"text\": \"\`\`\`\n$textLine\n\`\`\`\", \"pretext\":\"$pretext\", \"color\":\"#ffffff\"},"
        else
                # Check the returned 'used' column to determine color
                used=${words[4]}
                used=${used%\%}
                if (( $used > 89 )); then
                        color="danger"
                elif (( $used > 79 )); then
                        color="warning"
                else
                        #color="good"
                        continue
                fi
                disks+="{\"text\": \"\`\`\`\n$textLine\n\`\`\`\", \"color\":\"$color\"},"
        fi
done

if [[ $disks == "" ]]; then
        exit
fi

# trim trailing comma
disks="${disks::${#disks}-1}"
# -----------
# Complete JSON payload and make API request
json+="$disks]}"
curl -s -d "payload=$json" "$webhook_url"
