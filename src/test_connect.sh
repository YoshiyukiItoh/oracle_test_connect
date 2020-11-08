#!/bin/bash
CONNECT_STR="$1"
TEST_ID="$2"
BASE_PATH="/usr/local/work/oracle_test_connect"
LOG_PATH="${BASE_PATH}/logs"
LOG_FILE="${LOG_PATH}/test${TEST_ID}-`date '+%Y%m%d_%H%M%S'`.log"
CON_USER="system"
CON_PASS="manager"
ORACLE_UNQNAME="RON"

export TNS_ADMIN=${BASE_PATH}

function usage() {
  echo ""
  echo "usage : "
  echo "$ ./test_connect.sh <CONNECT_STR> <TEST_ID>"
  echo ""
}

function output_log() {
  echo "[`date '+%Y/%m/%d %H:%M:%S'`] $@" >> ${LOG_FILE}
}

if [ $# != 2 ]; then
  usage
  exit 1
fi

echo -e "\nTo Stop, input Ctrl+C.\n"

while true;
do
  SQLRET=`sqlplus -s -L ${CON_USER}/${CON_PASS}@${CONNECT_STR} @getname.sql | grep ${ORACLE_UNQNAME}`
  if [ ${PIPESTATUS[0]} -eq 0 -a "${SQLRET}" != "ERROR:" ]; then
    output_log "$SQLRET"
  else
    output_log "connect failed."
    sleep 1
  fi
done

exit 0
