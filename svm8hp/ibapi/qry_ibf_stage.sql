--
-- qry_ibf_stage.sql
--

-- I use this script to look at data recently loaded into ibf_stage.

SELECT
pair
,MIN(clse)
,COUNT(clse)
,MAX(clse)
,STDDEV(clse)
,MIN(epochsec)
,MAX(epochsec)
,STDDEV(epochsec)
FROM ibf_stage
GROUP BY pair
ORDER BY pair
/

-- See if I can spot any price-duplicates:
SELECT
clse
,pair
,epochsec
FROM ibf_stage
ORDER BY clse,epochsec,pair

exit
