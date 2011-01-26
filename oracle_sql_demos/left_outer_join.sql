--
-- left_outer_join.sql
--

CREATE OR REPLACE VIEW dropme_lojl AS
SELECT 1 one from dual
/

CREATE OR REPLACE VIEW dropme_lojr AS
SELECT 2 one from dual
/

SELECT l.one l_one, r.one r_one
FROM dropme_lojl l, dropme_lojr r
WHERE l.one = r.one(+)
/

exit


-- 02:25:42 SQL> SELECT l.one l_one, r.one r_one
-- 02:25:42   2  FROM dropme_lojl l, dropme_lojr r
-- 02:25:42   3  WHERE l.one = r.one(+)
-- 02:25:42   4  /
-- 
--      L_ONE      R_ONE
-- ---------- ----------
--          1
-- 
-- Elapsed: 00:00:00.01
-- 02:25:42 SQL> 
