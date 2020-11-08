set echo off
set heading off
SET newpage none
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
column INSTANCE_NAME format a10
column HOST_NAME format a10
column STATUS format a10
column STARTUP_TIME format a20
select INSTANCE_NAME, HOST_NAME, STATUS, STARTUP_TIME from v$instance;
quit
