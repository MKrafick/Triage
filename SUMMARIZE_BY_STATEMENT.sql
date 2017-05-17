-- Purpose: Displays count for specific statement involved in locking event from data within a locking event monitor.
--
-- SUMMARIZE_BY_STATEMENT.sql | May 16, 2017 | Version 1 |  Useage and Notes: M. Krafick, SQL: Ember Crooks | No warranty implied, use at your own risk.
--
-- Granularity: Medium 
--    
-- Values Returned: 
-- Count, Statement involved in locking event
--
-- Used with permission: Ember Crooks, DB2Commerce.com - "Analyzing Deadlocks the New Way"
--				 http://db2commerce.com/2012/01/23/analyzing-deadlocks-the-new-way/
--
-- Useage Notes:
--   Requires an active locking event monitor
--    Collected information from the monitor must be flushed to table or you can not query:
--   	db2 "call EVMON_FORMAT_UE_TO_TABLES ('LOCKING', NULL, NULL, NULL, 'DBA', NULL, NULL, -1, 'SELECT * FROM DBA.MY_LOCKS ORDER BY event_timestamp')"	
--      Dumps format into table with DBAMON schema and produces 4 new tables: LOCK_ACTIVITY_VALUES, LOCK_EVENT, LOCK_PARTICIPANTS, LOCK_PARTICIPANT_ACTIVITIES

with t1 as (select STMT_PKGCACHE_ID as STMT_PKGCACHE_ID, count(*) as stmt_count from dba.lock_participant_activities group by STMT_PKGCACHE_ID) select t1.stmt_count, (select substr(STMT_TEXT,1,100) as stmt_text from dba.lock_participant_activities a1 where a1.STMT_PKGCACHE_ID=t1.STMT_PKGCACHE_ID fetch first 1 row only) from t1 order by t1.stmt_count desc with ur;
