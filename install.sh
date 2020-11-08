#!/bin/bash

########################################
# Common Info
########################################
SCRIPT_BASE_PATH="/usr/local/work/oracle_test_connect"
TNSNAMES="${SCRIPT_BASE_PATH}/tnsnames.ora"
ORACLE_UNQNAME="RON"
ORACLE_SVCNAME="SVRON"

TNS_TEMPLATE=$(cat << EOF
<CONSTR> =
  (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = <IP>)(PORT = <PORT>))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = <SERVICENAME>)
    )
  )
EOF
)

VIPS=("172.16.2.33" "172.16.2.34")
SCANNAME="scan"
SCANIPS=("172.16.2.35" "172.16.2.36" "172.16.2.37")
LSNR_PORT="1521"
########################################
# Oracle Instant Client Yum Repository
########################################
OIC_YUM_REPO='http://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64'

OIC_BASIC_RPM='oracle-instantclient19.8-basic-19.8.0.0.0-1.x86_64.rpm'
OIC_SQLPLUS_RPM='oracle-instantclient19.8-sqlplus-19.8.0.0.0-1.x86_64.rpm'

OIC_BASIC_URL="${OIC_YUM_REPO}/getPackage/${OIC_BASIC_RPM}"
OIC_SQLPLUS_URL="${OIC_YUM_REPO}/getPackage/${OIC_SQLPLUS_RPM}"

########################################
### Main
########################################
## Install Module
echo -e "\n# Install Oracle Instant Client ...\n"
yum install -y ${OIC_BASIC_URL} ${OIC_SQLPLUS_URL}

## copy to ${SCRIPT_BASE_PATH}
echo -e "\n# mkdir ${SCRIPT_BASE_PATH} ...\n"
mkdir -p ${SCRIPT_BASE_PATH}

echo -e "\n# copy to script file ...\n"
for iname in `ls src/*`; do
  cp -p ${iname} ${SCRIPT_BASE_PATH}
done

echo -e "\n# add execute permission(chmod) to script file ...\n"
chmod u+x ${SCRIPT_BASE_PATH}/*.sh

echo -e "\n# create log dorectory ...\n"
mkdir ${SCRIPT_BASE_PATH}/logs

## create tnsnames.ora
echo -e "\n# create tnsname.ora ...\n"
echo "#create at `date '+%Y/%m/%d %H:%M:%S'`" > ${TNSNAMES}

# create VIP entry
echo -e "\n## add vip entry ...\n"

{
  for i in "${!VIPS[@]}"; do
    echo ${TNS_TEMPLATE} | \
      sed -e "s/<CONSTR>/${ORACLE_UNQNAME}VIP`expr ${i} + 1`/" \
      -e "s/<IP>/${VIPS[$i]}/" \
      -e "s/<PORT>/${LSNR_PORT}/" \
      -e "s/<SERVICENAME>/${ORACLE_SVCNAME}/"
    echo "" # add blank line.
  done
} >> ${TNSNAMES}

# create SCAN entry
echo -e "\n## add scan entry ...\n"
{
  echo ${TNS_TEMPLATE} | \
    sed -e "s/<CONSTR>/${ORACLE_UNQNAME}SCAN/" \
    -e "s/<IP>/${SCANNAME}/" \
    -e "s/<PORT>/${LSNR_PORT}/" \
    -e "s/<SERVICENAME>/${ORACLE_SVCNAME}/"
  echo "" # add blank line.

  for i in "${!SCANIPS[@]}"; do
    echo ${TNS_TEMPLATE} | \
      sed -e "s/<CONSTR>/${ORACLE_UNQNAME}SCAN`expr ${i} + 1`/" \
      -e "s/<IP>/${SCANIPS[$i]}/" \
      -e "s/<PORT>/${LSNR_PORT}/" \
      -e "s/<SERVICENAME>/${ORACLE_SVCNAME}/"
    echo "" # add blank line.
  done
} >> ${TNSNAMES}

echo -e "\n# Install finished .\n"

exit 0
