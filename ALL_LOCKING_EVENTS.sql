-- Purpose: Displays Deadlock and Lock Wait Information from data collected within a Locking Event Monitor.
--
-- Granularity: Low to Medium
--    
-- Values Returned: 
-- Lock Type, Timestamp, Connection, Participant who rolled back
--
-- Used with permission: Ember Crooks, DB2Commerce.com - "Analyzing Deadlocks the New Way"
--				 http://db2commerce.com/2012/01/23/analyzing-deadlocks-the-new-way/
--
-- Useage Notes:
--   Requires an active locking event monitor
--    Collected information from the monitor must be flushed to table or you can not query:
--   	db2 "call EVMON_FORMAT_UE_TO_TABLES ('LOCKING', NULL, NULL, NULL, 'DBA', NULL, NULL, -1, 'SELECT * FROM DBA.MY_LOCKS ORDER BY event_timestamp')"	
--      Dumps format into table with DBAMON schema and produces 4 new tables: LOCK_ACTIVITY_VALUES, LOCK_EVENT, LOCK_PARTICIPANTS, LOCK_PARTICIPANT_ACTIVITIES
   
select event_id, substr(event_type,1,18) as event_type, event_timestamp, dl_conns, rolled_back_participant_no from DBA.LOCK_EVENT order by event_id, event_timestamp with ur;
