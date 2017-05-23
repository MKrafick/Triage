-- LOCK_WAIT_CHAIN.sql | May 16, 2017 | Version 1 |  Useage and Notes: M. Krafick, SQL: Ember Crooks | No warranty implied, use at your own risk.
--
-- Purpose: Lock wait and lock chain information.
--
-- Granularity: Medium to High.
--    
-- Values Returned: 
-- Lock Name (for SQL #2, Object Details), Agent Blocking, Agent Waiting, Lock Status, Lock Wait Start Time
--
-- Useage Notes:
--   More detail on the object/lock in question can be pulled with plugging LOCK_NAME from first query into second query.




-- SQL (Lock Wait and Lock Chain details):
	
	SELECT
	 LOCK_NAME,
	 HLD_APPLICATION_HANDLE as AGENT_BLOCKING_LOCK,
	 REQ_APPLICATION_HANDLE as AGENT_WANTING_LOCK,
	 LOCK_STATUS as CURRENT_STATUS,
	 LOCK_WAIT_START_TIME as LOCK_WAIT_START
	FROM TABLE (MON_GET_APPL_LOCKWAIT(NULL, -2));
	

-- SQL (Object in contention):
--	SELECT 
--	 SUBSTR(NAME,1,20) AS OBJ_DETAIL,
--	 SUBSTR(VALUE,1,50) AS VALUE
--	FROM TABLE( MON_FORMAT_LOCK_NAME('<Lock Name>')) as LOCK;