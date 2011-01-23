--
-- upd_np.sql
--

-- I use this to enhance some pair names.

UPDATE op5min SET pair='eur_aud'WHERE pair='eau_usd';
UPDATE op5min SET pair='eur_chf'WHERE pair='ech_usd';
UPDATE op5min SET pair='eur_gbp'WHERE pair='egb_usd';
UPDATE op5min SET pair='eur_jpy'WHERE pair='ejp_usd';
UPDATE op5min SET pair='aud_jpy'WHERE pair='ajp_usd';
UPDATE op5min SET prdate=pair||ydate;

UPDATE di5min SET pair='eur_aud'WHERE pair='eau_usd';
UPDATE di5min SET pair='eur_chf'WHERE pair='ech_usd';
UPDATE di5min SET pair='eur_gbp'WHERE pair='egb_usd';
UPDATE di5min SET pair='eur_jpy'WHERE pair='ejp_usd';
UPDATE di5min SET pair='aud_jpy'WHERE pair='ajp_usd';
UPDATE di5min SET prdate=pair||ydate;

UPDATE svm62scores SET pair='eur_aud'WHERE pair='eau_usd';
UPDATE svm62scores SET pair='eur_chf'WHERE pair='ech_usd';
UPDATE svm62scores SET pair='eur_gbp'WHERE pair='egb_usd';
UPDATE svm62scores SET pair='eur_jpy'WHERE pair='ejp_usd';
UPDATE svm62scores SET pair='aud_jpy'WHERE pair='ajp_usd';
UPDATE svm62scores SET prdate=pair||ydate;

-- Check
SELECT pair,COUNT(pair)FROM op5min GROUP BY pair;
SELECT pair,COUNT(pair)FROM di5min GROUP BY pair;
SELECT pair,COUNT(pair)FROM svm62scores GROUP BY pair;

SELECT SUBSTR(prdate,1,7)pair,COUNT(SUBSTR(prdate,1,7))ccount FROM op5min GROUP BY SUBSTR(prdate,1,7);
SELECT SUBSTR(prdate,1,7)pair,COUNT(SUBSTR(prdate,1,7))ccount FROM di5min GROUP BY SUBSTR(prdate,1,7);
SELECT SUBSTR(prdate,1,7)pair,COUNT(SUBSTR(prdate,1,7))ccount FROM svm62scores GROUP BY SUBSTR(prdate,1,7);

ANALYZE TABLE op5min COMPUTE STATISTICS;
ANALYZE TABLE di5min COMPUTE STATISTICS;
ANALYZE TABLE svm62scores COMPUTE STATISTICS;

