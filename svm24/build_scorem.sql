--
-- build_scorem.sql
--

-- Demo:
-- @build_scorem.sql aud_usd

-- I use this script to build another script full of calls to a set of
-- scoring scripts.

SELECT cmd,ydate,'&1' pair FROM
(
SELECT '@score1_5min.sql 'cmd,ydate FROM modsrc24
WHERE ydate > '2011-01-10'
AND pair = '&1'
UNION
SELECT '@score1_5min_gattn.sql 'cmd,ydate FROM modsrc24
WHERE ydate > '2011-01-10'
AND pair = '&1'
)
WHERE '&1'||ydate NOT IN(SELECT DISTINCT prdate FROM svm24scores)
AND ydate > sysdate - 1
ORDER BY ydate,cmd
/


