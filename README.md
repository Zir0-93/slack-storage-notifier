# :rocket: slack-storage-notifier

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

A Slack App that monitors disk storage levels.

![image](notification.png)

# Usage Instructions
1. Follow [these](https://zir0-93.github.io/2018/slack-disk-storage-notifier/) instructions to create a Slack WebHook.
2. Donwload and execute the bash script: `bash slack_storage_notifier.sh  <webhook_url>`. Use the webhook URL generated from step 1 as a param to the script. Or, execute 
`bash slack_storage_notifier.sh` and store webhook URL under the `SLACK_WEBHOOK_URL` environment variable.
**Note**: The machine name used in the slack message corresponds the the `$HOSTNAME` environment variable.
