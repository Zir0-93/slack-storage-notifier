# :rocket: slack-storage-notifier

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

# 使い方
### 1. gitインストール
監視対象サーバにsshしてgitコマンドが存在しているか確認。なければインストールする。
```
$ git --version  # git存在確認
-bash: git: コマンドが見つかりません
$ sudo yum install git  # Redhat系の場合
$ sudo apt install git  # Debian系の場合
$ git --version  # gitインストール確認
git version 1.8.3.1
```

### 2. slack-storage-notifierシェルの設置
監視対象サーバのホームディレクトリでgitクローンしてslack-storage-notifierシェルの設置する。
```
$ cd ~
$ git clone https://github.com/kak1/slack-storage-notifier.git
```
※ 1でgitをインストールできなかった場合は、ローカル環境でgitクローンしてホームディレクトリにslack-storage-notifierディレクトリごとアップロードする。

### 3. cronの設定追加
監視対象サーバにて下記内容をcrontabファイルに追加する。
```
# ディスク容量監視
HOSTNAME="【◯△□様】https://xxxxx.xx/ WEB1"
SLACK_WEBHOOK_URL=<webhook_url>
0 * * * * sh slack-storage-notifier/slack_storage_notifier.sh
```
※ HOSTNAMEやSLACK_WEBHOOK_URLの内容は適時置き換え
