--
-- qry_recent_fxscores.sql
--

SELECT * FROM fxscores8hp       WHERE rundate> sysdate -4/24 ORDER BY ydate;
SELECT * FROM fxscores8hp_gattn WHERE rundate> sysdate -4/24 ORDER BY ydate;

SELECT * FROM fxscores8hp       WHERE rundate> sysdate -4/24 AND score > 0.75 ORDER BY ydate;

SELECT * FROM fxscores8hp_gattn WHERE rundate> sysdate -4/24 AND score > 0.75 ORDER BY ydate;

exit
