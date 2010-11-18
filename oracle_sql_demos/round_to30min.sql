--
-- round_to30min.sql
--

-- Rounding to nearest hour is simpler:
SELECT ROUND(sysdate,'HH24')FROM dual;

-- The main idea here is subtract 30 min from the date, round date to nearest hour, add 30 min to the date:
SELECT ROUND((sysdate - 30/60/24),'HH24') + 30/60/24 FROM dual;

exit
