--
-- h15c.sql
--

-- I use this script to generate prices for 9 additional pairs from my original 6 pairs.
-- I know the prices are good because if they were bad, 
-- traders with fast market connections would make them good using arbitrage trades.


-- I start by creating h15c with the eur_gbp pair:
DROP TABLE h15c;
CREATE TABLE h15c COMPRESS AS
SELECT 'eur_gbp' pair,e.ydate,e.clse/g.clse clse
FROM hourly e, hourly g
WHERE e.pair = 'eur_usd' AND g.pair = 'gbp_usd'
AND e.ydate = g.ydate
/

-- rpt
SELECT MIN(ydate),COUNT(*),MAX(ydate)FROM hourly WHERE pair = 'eur_usd';
SELECT MIN(ydate),COUNT(*),MAX(ydate)FROM hourly WHERE pair = 'gbp_usd';
SELECT MIN(ydate),COUNT(*),MAX(ydate)FROM h15c;

-- Mix-in the eur_aud pair:
INSERT INTO h15c(pair,ydate,clse)
SELECT 'eur_aud' pair, e.ydate, e.clse/a.clse clse
FROM hourly e, hourly a
WHERE e.pair = 'eur_usd' AND a.pair = 'aud_usd'
AND e.ydate = a.ydate
/

-- Mix-in the eur_jpy pair:

INSERT INTO h15c(pair,ydate,clse)
SELECT 'eur_jpy' pair, e.ydate, e.clse*j.clse clse
FROM hourly e, hourly j
WHERE e.pair = 'eur_usd' AND j.pair = 'usd_jpy'
AND e.ydate = j.ydate
/

-- Mix-in the eur_cad pair:
INSERT INTO h15c(pair,ydate,clse)
SELECT 'eur_cad' pair, e.ydate, e.clse*c.clse clse
FROM hourly e, hourly c
WHERE e.pair = 'eur_usd' AND c.pair = 'usd_cad'
AND e.ydate = c.ydate
/

-- Mix-in the eur_chf pair:
INSERT INTO h15c(pair,ydate,clse)
SELECT 'eur_chf' pair, e.ydate, e.clse*c.clse clse
FROM hourly e, hourly c
WHERE e.pair = 'eur_usd' AND c.pair = 'usd_chf'
AND e.ydate = c.ydate
/

-- Mix-in the gbp_aud pair:
INSERT INTO h15c(pair,ydate,clse)
SELECT 'gbp_aud' pair, g.ydate, g.clse/a.clse clse
FROM hourly g, hourly a
WHERE g.pair = 'gbp_usd' AND a.pair = 'aud_usd'
AND g.ydate = a.ydate
/

-- Mix-in the gbp_jpy pair:
INSERT INTO h15c(pair,ydate,clse)
SELECT 'gbp_jpy' pair, g.ydate, g.clse*j.clse clse
FROM hourly g, hourly j
WHERE g.pair = 'gbp_usd' AND j.pair = 'usd_jpy'
AND g.ydate = j.ydate
/

-- Mix-in the gbp_cad pair:
INSERT INTO h15c(pair,ydate,clse)
SELECT 'gbp_cad' pair, g.ydate, g.clse*c.clse clse
FROM hourly g, hourly c
WHERE g.pair = 'gbp_usd' AND c.pair = 'usd_cad'
AND g.ydate = c.ydate
/

-- Mix-in the gbp_chf pair:
INSERT INTO h15c(pair,ydate,clse)
SELECT 'gbp_chf' pair, g.ydate, g.clse*c.clse clse
FROM hourly g, hourly c
WHERE g.pair = 'gbp_usd' AND c.pair = 'usd_chf'
AND g.ydate = c.ydate
/

-- Now I need to copy in the source data:
INSERT INTO h15c(pair,ydate,clse)
SELECT           pair,ydate,clse
FROM hourly
/

--rpt
SELECT pair,MIN(ydate),COUNT(*),MAX(ydate)FROM h15c GROUP BY pair;

exit
