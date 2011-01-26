-- 
-- qry_bme_sc_corr.sql
--

-- I use this script to see how sc_corr is distributed in the bme view.

select
to_char(to_date(substr(prdate,8)),'yyyy_mm w')
,avg(sc_corr)
,count(sc_corr)
from bme
group by to_char(to_date(substr(prdate,8)),'yyyy_mm w')
order by to_char(to_date(substr(prdate,8)),'yyyy_mm w')
/

exit

