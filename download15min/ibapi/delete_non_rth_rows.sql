--
-- delete_non_rth_rows.sql
--

-- I use this script to delete rows which not for Regular Trading Hours.
-- The data I get from IB which is outside of RTH is unreliable so I dont want it.

-- ibs_stage may have data outside of RTH.
-- Remove data which is outside of RTH:
DELETE ibs15min WHERE TO_CHAR(ydate,'HH24:MI') < '14:30'AND ydate < '2011-03-14';
DELETE ibs15min WHERE TO_CHAR(ydate,'HH24:MI') > '20:55'AND ydate < '2011-03-14';
-- Daylight savings time started on 2011-03-14:	                                                                        
DELETE ibs15min WHERE TO_CHAR(ydate,'HH24:MI') < '13:30'AND ydate > '2011-03-14';
DELETE ibs15min WHERE TO_CHAR(ydate,'HH24:MI') > '19:55'AND ydate > '2011-03-14';
