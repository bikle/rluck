--
-- create_other_pairs.sql
--

-- I use this script to create other non-USD pairs like EUR/CHF.

-- DROP TABLE op5min;
-- CREATE TABLE op5min(prdate VARCHAR2(26),pair VARCHAR2(7), ydate DATE, clse NUMBER);

TRUNCATE TABLE op5min;

-- Create the EUR/CHF pair and call it ech_usd:

INSERT INTO op5min(prdate,pair,ydate,clse)
SELECT
'ech_usd'||e.ydate prdate
,'ech_usd' pair
,e.ydate
,e.clse*c.clse clse
FROM di5min0 e, di5min0 c
WHERE e.ydate = c.ydate
AND e.pair = 'eur_usd'
AND c.pair = 'usd_chf'
/

-- Create the EUR/GBP pair and call it egb_usd:

INSERT INTO op5min(prdate,pair,ydate,clse)
SELECT
'egb_usd'||e.ydate prdate
,'egb_usd' pair
,e.ydate
,e.clse/g.clse clse
FROM di5min0 e, di5min0 g
WHERE e.ydate = g.ydate
AND e.pair = 'eur_usd'
AND g.pair = 'gbp_usd'
/

-- Create the EUR/JPY pair and call it ejp_usd:

INSERT INTO op5min(prdate,pair,ydate,clse)
SELECT
'ejp_usd'||e.ydate prdate
,'ejp_usd' pair
,e.ydate
,e.clse*j.clse clse
FROM di5min0 e, di5min0 j
WHERE e.ydate = j.ydate
AND e.pair = 'eur_usd'
AND j.pair = 'usd_jpy'
/

-- Create the AUD/JPY pair and call it ajp_usd:

INSERT INTO op5min(prdate,pair,ydate,clse)
SELECT
'ajp_usd'||a.ydate prdate
,'ajp_usd' pair
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
