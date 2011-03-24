--
-- html_demo2.sql
--

-- Usage:
-- sqlplus trade/t @html_demo2.sql

SET TERMOUT OFF

-- ENTMAP ON "sanitizes" embedded HTML so I get entities rather than brackets which are interpreted.
SET MARKUP HTML ON TABLE "class='body_class'" ENTMAP ON

SPOOL html_demo2.html

SELECT * FROM DBA_DATA_FILES;

SPOOL OFF

EXIT

