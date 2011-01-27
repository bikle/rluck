--
-- cr_ystk21.sql
--

-- I use this script to create ystk21 from ystk so that I have access to a more accurate ydate.

DROP TABLE ystk21;
PURGE RECYCLEBIN;
CREATE TABLE ystk21 COMPRESS AS
SELECT
tkr
,TRUNC(ydate)+21/24 ydate
,tkr||TO_CHAR(TRUNC(ydate)+21/24,'YYYY-MM-DD HH24:MI:SS' )tkrdate
,clse,clse2,g1d
FROM ystk
/
