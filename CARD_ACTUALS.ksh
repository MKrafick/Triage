#!/bin/ksh
## CARD_ACTUALS.ksh | May 22, 2017 | Version 1 | Script: M. Krafick | No warranty implied, use at your own risk.
##
## Purpose: To compare actual row count to estimated cardinality to determine if a wide variance between the two is impacting query performance.
##
## Granularity: Low to Medium
##
## Values Returned:
##     Table name, Row Count, Cardinality
##
## Usage: CARD_ACTUALS.ksh

clear
echo "This script will pull actual ROW COUNT (as of now) and CARINALITY (as DB2 sees it from last statistics)."
echo ""
echo ""
read "DBNAME?Enter Database name: "
read "SCHEMA?Enter Schema name: "
read "TABLIST?Enter one to many tables to query (seperated by spaces): "
echo ""
echo ""

set -A array $TABLIST
#echo ${array[0]}

db2 connect to $DBNAME >/dev/null
echo "TABNAME                        COUNT       CARD"
echo "------------------------------ ----------- --------------------"
for TABLE in ${array[@]}
do
db2 -x "select substr(A.TABNAME,1,30) as TABLE, (select count(*) from $SCHEMA.$TABLE) AS COUNT, A.CARD FROM SYSCAT.TABLES A WHERE A.TABSCHEMA='$SCHEMA' AND A.TABNAME = '$TABLE' WITH UR"
done
db2 terminate >/dev/null