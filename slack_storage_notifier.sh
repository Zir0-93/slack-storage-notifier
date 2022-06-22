#!/bin/bash
# ------------
# Read HOSTNAME
hostname=${HOSTNAME}
# ------------
# Read webhook URL param
webhook_url=$1
if [[ $webhook_url == "" ]]; then
        webhook_url=${SLACK_WEBHOOK_URL}
        if [[ $webhook_url == "" ]]; then
                echo "No webhook_url specified" >&2
                exit 1
        fi
fi
# ------------
# Execute df-h
text="$(df -h)"
# ------------
# Generate the JSON payload to POST to slack
json="{\"attachments\":["
disks=""
IFS=$'\n'
i=0
for textLine in $text
do
        IFS=$' '
        words=($textLine)
        if [[ $i -eq 0 ]]; then
                # This is the header line of df- h command
                pretext=" *$hostname* サーバのディスク容量不足"
                json+="{\"text\": \"\`\`\`\n$textLine\n\`\`\`\", \"pretext\":\"$pretext\", \"color\":\"#ffffff\"},"
        else
                # Check the returned 'used' column to determine color
                used=${words[4]}
                used=${used%\%}
                if (( $used > 89 )); then
                        color="danger"
                        disks+="{\"text\": \"\`\`\`\n$textLine\n\`\`\`\", \"color\":\"$color\"},"
                elif (( $used > 79 )); then
                        color="warning"
                        disks+="{\"text\": \"\`\`\`\n$textLine\n\`\`\`\", \"color\":\"$color\"},"
                fi
        fi
        i=`expr $i + 1`
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
