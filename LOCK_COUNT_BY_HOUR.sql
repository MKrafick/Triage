-- LOCK_COUNT_BY_HOUR.sql | May 16, 2017 | Version 1 | Comments and Usage Notes: M. Krafick, SQL: Ember Crooks 
-- No warranty implied, use at your own risk.
--
-- Purpose: Displays Deadlock and Lock Wait Information (by hour) from data collected within a Locking Event Monitor.
--
-- Granularity: Medium to High
--    
-- Values Returned: 
-- Lock Type, Year, Month, Day, Hour
--
-- Used with permission: Ember Crooks, DB2Commerce.com - "Analyzing Deadlocks the New Way"
--				 http://db2commerce.com/2012/01/23/analyzing-deadlocks-the-new-way/
--
-- Useage Notes:
--   Requires an active locking event monitor
--    Collected information from the monitor must be flushed to table or you can not query:
--   	db2 "call EVMON_FORMAT_UE_TO_TABLES ('LOCKING', NULL, NULL, NULL, 'DBA', NULL, NULL, -1, 'SELECT * FROM DBA.MY_LOCKS ORDER BY event_timestamp')"	
--      Dumps format into table with DBAMON schema and produces 4 new tables: LOCK_ACTIVITY_VALUES, LOCK_EVENT, LOCK_PARTICIPANTS, LOCK_PARTICIPANT_ACTIVITIES



select substr(event_type,1,18) as event_type, year(event_timestamp) as year, month(event_timestamp) as month, day(event_timestamp) as day, hour(event_timestamp) as hour, count(*) as count from DBA.LOCK_EVENT group by year(event_timestamp), month(event_timestamp), day(event_timestamp), hour(event_timestamp), event_type order by year(event_timestamp), month(event_timestamp), day(event_timestamp), hour(event_timestamp), event_type with ur;
