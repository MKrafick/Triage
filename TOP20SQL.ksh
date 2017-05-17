#!/bin/ksh
## TOP20SQL.ksh | May 16, 2017 | Version 1 | Script: M. Krafick, SQL: Ember Crooks | No warranty implied, use at your own risk.
##
## Purpose: Returns list of SQL Statement Fragments and key metrics ranked in order of Rows Read,
##          Execution Time, or Number Executions
##
## Granularity: Medium - High, Multiple characteristic returned from package cache on indvidual SQL
##
## Credit/Source:
## Script written by M. Krafick. SQL was written by Ember Crooks and used with permission.
## http://db2commerce.com/2015/02/12/db2-administrative-sql-cookbook-finding-problem-sql-in-the-package-cache/
##
## Metrics shown:
## SQL Fragment, Rows Read, Percent Total Rows Read, Total CPU Time, Percent Total CPU, Statment Execution Time, Percent Total Execution Time
## Total Section Sort Time, Percent Total Sort, Number Executions, Percent Total Executions, Avg Execution Time
##
## Execution notes:
## Execute with DB2 Instance ID, or monitoring ID with SYSMON access
## Must input how you would like the data sorted.
## Statement fragments are truncated to 10 characters to display all within one screen, the substr can be elongated if needed.
## Will display only 20 rows, but can be adjusted if needed in "fetch first X rows only" clause,
## Statement only returns rows that consume 10% or more of one of the identified critical resources.
## Displays data in the Package Cache, this data can be blown out under stress or reset when flushed or on database recycle
##
## Usage: ./TOP20SQL.ksh <dbname> <RR | TIME | EXEC>
##

############ Variable Assignments, Check for Empty Input ##########
typeset -u DBNAME
DBNAME=$1
typeset -u FLAG
FLAG=$2


if ! [[ $FLAG = 'RR' || $FLAG = 'TIME' || $FLAG = 'EXEC' ]]; then
   echo "Useage: ./TOP20SQL.ksh <dbname> <RR | TIME | EXEC>"
   exit 1
fi


########## Main Script Body ##########

## Connect to database, prep column to sort on
db2 "CONNECT TO $DBNAME" > /dev/null

if [[ $FLAG = 'RR' ]];then
   SWITCH='ROWS_READ'
elif [[ $FLAG = 'TIME' ]];then
   SWITCH='STMT_EXEC_TIME';
elif [[ $FLAG = 'EXEC' ]]; then
   SWITCH='NUM_EXECUTIONS'
fi


## Main SQL run
db2 " WITH SUM_TAB (SUM_RR, SUM_CPU, SUM_EXEC, SUM_SORT, SUM_NUM_EXEC) AS (
        SELECT  FLOAT(SUM(ROWS_READ)),
                FLOAT(SUM(TOTAL_CPU_TIME)),
                FLOAT(SUM(STMT_EXEC_TIME)),
                FLOAT(SUM(TOTAL_SECTION_SORT_TIME)),
                FLOAT(SUM(NUM_EXECUTIONS))
            FROM TABLE(MON_GET_PKG_CACHE_STMT ( 'D', NULL, NULL, -2)) AS T
        )
SELECT
        SUBSTR(STMT_TEXT,1,20) as STATEMENT,
        ROWS_READ,
        DECIMAL(100*(FLOAT(ROWS_READ)/SUM_TAB.SUM_RR),5,2) AS PCT_TOT_RR,
        TOTAL_CPU_TIME,
        DECIMAL(100*(FLOAT(TOTAL_CPU_TIME)/SUM_TAB.SUM_CPU),5,2) AS PCT_TOT_CPU,
        STMT_EXEC_TIME,
        DECIMAL(100*(FLOAT(STMT_EXEC_TIME)/SUM_TAB.SUM_EXEC),5,2) AS PCT_TOT_EXEC,
        TOTAL_SECTION_SORT_TIME,
        DECIMAL(100*(FLOAT(TOTAL_SECTION_SORT_TIME)/SUM_TAB.SUM_SORT),5,2) AS PCT_TOT_SRT,
        NUM_EXECUTIONS,
        DECIMAL(100*(FLOAT(NUM_EXECUTIONS)/SUM_TAB.SUM_NUM_EXEC),5,2) AS PCT_TOT_EXEC,
        DECIMAL(FLOAT(STMT_EXEC_TIME)/FLOAT(NUM_EXECUTIONS),10,2) AS AVG_EXEC_TIME
    FROM TABLE(MON_GET_PKG_CACHE_STMT ( 'D', NULL, NULL, -2)) AS T, SUM_TAB
    WHERE DECIMAL(100*(FLOAT(ROWS_READ)/SUM_TAB.SUM_RR),5,2) > 10
        OR DECIMAL(100*(FLOAT(TOTAL_CPU_TIME)/SUM_TAB.SUM_CPU),5,2) >10
        OR DECIMAL(100*(FLOAT(STMT_EXEC_TIME)/SUM_TAB.SUM_EXEC),5,2) >10
        OR DECIMAL(100*(FLOAT(TOTAL_SECTION_SORT_TIME)/SUM_TAB.SUM_SORT),5,2) >10
        OR DECIMAL(100*(FLOAT(NUM_EXECUTIONS)/SUM_TAB.SUM_NUM_EXEC),5,2) >10
    ORDER BY $SWITCH DESC FETCH FIRST 20 ROWS ONLY WITH UR"

db2 "TERMINATE" > /dev/null