# Triage
Triage Scripts and SQL for root cause analysis and troubleshooting.

### Disclaimer:
I am not an advanced scripter or SQL writer. Use these at your own risk.

### Purpose:
I'm slowly updating and preparing scripts I use for triage for general use via Github. These are scripts or SQL I may use outside tools like db2top, db2pd, or MONREPORT.DBSUMMARY. Many '%LOCK%' SQL are directly taken (or manipulated) with permission from Ember Crooks and can be found on DB2Commerce.com. 

### Notes:
Read script and SQL comments, especially around Locking SQL.

### Pre-Requisites:
Many '%LOCK%' SQL are developed to query deadlock information flushed from an event monitor. You are not collecting deadlock data this way or flushing data to a table via EVMON_FORMAT_UE_TO_TABLES, they won't work.

### Available SQL and Scripts:

*ALL_LOCKING_EVENTS.sql*

Displays Deadlock and Lock Wait Information from data collected within a Locking Event Monitor.
Values Returned - Lock Type, Timestamp, Connection, Participant who rolled back


*CARD_ACTUALS.ksh*

To compare actual row count to estimated cardinality to determine if a wide variance between the two is impacting query performance.


*LOCK_COUNT_BY_HOUR.sql*

Displays Deadlock and Lock Wait Information (by hour) from data collected within a Locking Event Monitor.
Values Returned - Lock Type, Year, Month, Day, Hour


*LOCK_WAIT_CHAIN.sql*

Lock wait and lock chain information.
Values Returned - Lock Name (for SQL #2, Object Details), Agent Blocking, Agent Waiting, Lock Status, Lock Wait Start Time


*STMTS_IN_DEADLOCKS.sql*

Displays Statements involved in deadlock from data collected within a Locking Event Monitor.
Values Returned - Number of time statment appeard, statement

*SUMMARIZE_BY_STATEMENT.sql*

Displays count for specific statement involved in locking event from data within a locking event monitor.
Values Returned - Count, Statement involved in locking event


*SUM_LOCK_EVENTS.sql*

Displays count of locking type from data collected within a Locking Event Monitor.
Values Returned - Lock, Type, Count


*SUM_TABLE_LOCK_EVENT.sql*

Displays count of locking type (per table) from data collected within a Locking Event Monitor.
Values Returned - Table Schema, Table, Lock Type, Count


*TOP20SQL.ksh*
Returns list of SQL Statement Fragments and key metrics ranked in order of Rows Read, Execution Time, or Number Executions
