--
-- html_demo1.sql
--

-- Usage 1 (to get html-tag and body-tag [which I rarely want]):
-- sqlplus -MARKUP "HTML ON" trade/t @html_demo1.sql

-- Usage 2 (to only get table-tag [which I usually want]):
-- sqlplus @html_demo1.sql


SET TERMOUT OFF

SET MARKUP HTML ON HEAD " -
 -
  body {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
  p {   font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
        table,tr,td {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#f7f7e7; -
        padding:0px 0px 0px 0px; margin:0px 0px 0px 0px; white-space:nowrap;} -
  th {  font:bold 10pt Arial,Helvetica,sans-serif; color:#336699; background:#cccc99; -
        padding:0px 0px 0px 0px;} -
  h1 {  font:16pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; -
        border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;} -
  h2 {  font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; -
        margin-top:4pt; margin-bottom:0pt;} a {font:9pt Arial,Helvetica,sans-serif; color:#663300; -
        background:#ffffff; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
 -
" -
BODY "class='bodyclass" -
TABLE "border='1' align='center' summary='Script output'" -
ENTMAP ON PREFORMAT OFF

SPOOL html_demo1.html

SELECT * FROM DBA_DATA_FILES;

SPOOL OFF

EXIT

