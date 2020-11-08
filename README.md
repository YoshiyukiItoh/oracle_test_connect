# oracle_test_connect

対象のOracle Databaseへ接続し、インスタンス名などをログに保存します。
F/O時の接続不可な時間をログに残すために使います。
おおよそ1秒か2秒に1回ログを出力します。

## Install

```
# git clone https://github.com/YoshiyukiItoh/oracle_test_connect.git
# cd oracle_test_connect
# sh install.sh
```

## test_connect.sh
### Usage

設定値の確認を行います。

```
# cd /usr/local/work/oracle_test_connect
# vi test_connect.sh
```

スクリプトを実行します。

```
# ./test_connect.sh RONSCAN 1

To Stop, input Ctrl+C.

```

別ターミナルでログを確認します。
[タイムスタンプ] 接続インスタンス 接続ホスト ステータス STARTUP時間

```
# cd /usr/local/work/oracle_test_connect
# cd logs
# ll
合計 12
-rw-r--r-- 1 root root  136 11月  8 17:51 test1-20201108_175148.log
# tailf test1-20201108_175148.log
[2020/11/08 17:51:49] RON_1	   ron1901.sn OPEN	 2020-11-08 17:37:25
[2020/11/08 17:51:50] RON_1	   ron1901.sn OPEN	 2020-11-08 17:37:25
```

## cdataxm.sql
### Usage

処理中にF/Oさせ、セッションを確認したい場合に利用します。
処理に時間のかかるSQLを記載しています。

```
sqlplus -S -L system/manager@RONSCAN @cdata.sql
```

