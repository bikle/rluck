--
-- de_dup_using_rowid.sql
--

-- This demonstrates the idea of using rowid to help remove duplicate rows from a table.
-- Oracle offers rowid as a pseudo column which I/we know to be unique.
-- Since it is unique it is useful for removing duplicates.

-- In this example, tkrhr is supposed to be unique.

SELECT COUNT(tkrhr)FROM ibstk;

SELECT COUNT(tkrhr)FROM
  (SELECT tkrhr,MAX(rowid)mxr FROM ibstk GROUP BY tkrhr)
/

DROP TABLE ibstk_old;
RENAME ibstk TO ibstk_old;

CREATE TABLE ibstk COMPRESS AS
SELECT * FROM ibstk_old
WHERE rowid IN
  (SELECT mxr FROM
    (SELECT tkrhr,MAX(rowid)mxr FROM ibstk_old GROUP BY tkrhr)
  )
/

SELECT COUNT(tkrhr)FROM ibstk;
SELECT COUNT(tkrhr)FROM ibstk_old;


-- The above example has 3 DDL statements.
-- At the price of performance, here could be a pure DML approach:
DELETE ibstk WHERE rowid NOT IN
  (SELECT mxr FROM
    (SELECT tkrhr,MAX(rowid)mxr FROM ibstk GROUP BY tkrhr)
  )
/

exit
