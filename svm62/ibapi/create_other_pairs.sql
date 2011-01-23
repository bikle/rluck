--
-- create_other_pairs.sql
--

-- I use this script to create other non-USD pairs like EUR/CHF.

-- DROP TABLE op5min;
-- CREATE TABLE op5min(prdate VARCHAR2(26),pair VARCHAR2(7), ydate DATE, clse NUMBER);

TRUNCATE TABLE op5min;

-- Create the EUR/CHF pair:

INSERT INTO op5min(prdate,pair,ydate,clse)
SELECT
'eur_chf'||e.ydate prdate
,'eur_chf' pair
,e.ydate
,e.clse*c.clse clse
FROM di5min0 e, di5min0 c
WHERE e.ydate = c.ydate
AND e.pair = 'eur_usd'
AND c.pair = 'usd_chf'
/

-- Create the EUR/GBP pair:

INSERT INTO op5min(prdate,pair,ydate,clse)
SELECT
'eur_gbp'||e.ydate prdate
,'eur_gbp' pair
,e.ydate
,e.clse/g.clse clse
FROM di5min0 e, di5min0 g
WHERE e.ydate = g.ydate
AND e.pair = 'eur_usd'
AND g.pair = 'gbp_usd'
/

-- Create the EUR/JPY pair:

INSERT INTO op5min(prdate,pair,ydate,clse)
SELECT
'eur_jpy'||e.ydate prdate
,'eur_jpy' pair
,e.ydate
,e.clse*j.clse clse
FROM di5min0 e, di5min0 j
WHERE e.ydate = j.ydate
AND e.pair = 'eur_usd'
AND j.pair = 'usd_jpy'
/

-- Create the AUD/JPY pair:

INSERT INTO op5min(prdate,pair,ydate,clse)
SELECT
'aud_jpy'||a.ydate prdate
,'aud_jpy' pair
,a.ydate
,a.clse*j.clse clse
FROM di5min0 a, di5min0 j
WHERE a.ydate = j.ydate
AND a.pair = 'aud_usd'
AND j.pair = 'usd_jpy'
/

-- rpt

SELECT * FROM op5min
WHERE ydate > sysdate - 0.5/24
ORDER BY prdate
/

-- Dont put an exit here.
-- This script is called from another SQL script.
