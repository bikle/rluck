--
-- qry_ibs15min_stage.sql
--

-- I use this script to look at data recently loaded into ibs15min_stage.

SELECT
tkr
,MIN(clse)
,COUNT(clse)
,MAX(clse)
,STDDEV(clse)
,MIN(epochsec)
,MAX(epochsec)
,STDDEV(epochsec)
FROM ibs15min_stage
GROUP BY tkr
ORDER BY tkr
/

-- See if I can spot any price-duplicates:
SELECT
clse
,tkr
,epochsec
FROM ibs15min_stage
ORDER BY clse,epochsec,tkr

exit
