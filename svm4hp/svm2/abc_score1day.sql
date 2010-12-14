--
-- abc_score1day.sql
--

CREATE OR REPLACE VIEW sme AS
SELECT
'abc'||m.ydate prdate
,NULL gatt
,m.ydate - TO_DATE('2000-01-01','YYYY-MM-DD')daycount
,eur_g00
,eur_g01
,eur_g02
,eur_g03
,eur_g04
,eur_g05
,eur_g06
,eur_g07
,eur_g08
,eur_g09
,eur_g10
,eur_g11
,eur_g12
,eur_g13
,eur_g14
,eur_g15
,eur_g16
,eur_g17
,eur_g18
,eur_g19
,eur_g20
,eur_g21
,eur_g22
,eur_g23
,eur_g24
,eur_g25
,eur_g26
,eur_g27
,eur_g28
,eur_g29
,eur_g30
,eur_g31
,eur_g32
,eur_g33
,eur_g34
,eur_g35
,aud_g00
,aud_g01
,aud_g02
,aud_g03
,aud_g04
,aud_g05
,aud_g06
,aud_g07
,aud_g08
,aud_g09
,aud_g10
,aud_g11
,aud_g12
,aud_g13
,aud_g14
,aud_g15
,aud_g16
,aud_g17
,aud_g18
,aud_g19
,aud_g20
,aud_g21
,aud_g22
,aud_g23
,aud_g24
,aud_g25
,aud_g26
,aud_g27
,aud_g28
,aud_g29
,aud_g30
,aud_g31
,aud_g32
,aud_g33
,aud_g34
,aud_g35
,gbp_g00
,gbp_g01
,gbp_g02
,gbp_g03
,gbp_g04
,gbp_g05
,gbp_g06
,gbp_g07
,gbp_g08
,gbp_g09
,gbp_g10
,gbp_g11
,gbp_g12
,gbp_g13
,gbp_g14
,gbp_g15
,gbp_g16
,gbp_g17
,gbp_g18
,gbp_g19
,gbp_g20
,gbp_g21
,gbp_g22
,gbp_g23
,gbp_g24
,gbp_g25
,gbp_g26
,gbp_g27
,gbp_g28
,gbp_g29
,gbp_g30
,gbp_g31
,gbp_g32
,gbp_g33
,gbp_g34
,gbp_g35
,jpy_g00
,jpy_g01
,jpy_g02
,jpy_g03
,jpy_g04
,jpy_g05
,jpy_g06
,jpy_g07
,jpy_g08
,jpy_g09
,jpy_g10
,jpy_g11
,jpy_g12
,jpy_g13
,jpy_g14
,jpy_g15
,jpy_g16
,jpy_g17
,jpy_g18
,jpy_g19
,jpy_g20
,jpy_g21
,jpy_g22
,jpy_g23
,jpy_g24
,jpy_g25
,jpy_g26
,jpy_g27
,jpy_g28
,jpy_g29
,jpy_g30
,jpy_g31
,jpy_g32
,jpy_g33
,jpy_g34
,jpy_g35
,cad_g00
,cad_g01
,cad_g02
,cad_g03
,cad_g04
,cad_g05
,cad_g06
,cad_g07
,cad_g08
,cad_g09
,cad_g10
,cad_g11
,cad_g12
,cad_g13
,cad_g14
,cad_g15
,cad_g16
,cad_g17
,cad_g18
,cad_g19
,cad_g20
,cad_g21
,cad_g22
,cad_g23
,cad_g24
,cad_g25
,cad_g26
,cad_g27
,cad_g28
,cad_g29
,cad_g30
,cad_g31
,cad_g32
,cad_g33
,cad_g34
,cad_g35
,chf_g00
,chf_g01
,chf_g02
,chf_g03
,chf_g04
,chf_g05
,chf_g06
,chf_g07
,chf_g08
,chf_g09
,chf_g10
,chf_g11
,chf_g12
,chf_g13
,chf_g14
,chf_g15
,chf_g16
,chf_g17
,chf_g18
,chf_g19
,chf_g20
,chf_g21
,chf_g22
,chf_g23
,chf_g24
,chf_g25
,chf_g26
,chf_g27
,chf_g28
,chf_g29
,chf_g30
,chf_g31
,chf_g32
,chf_g33
,chf_g34
,chf_g35
FROM abc_ms14 m
WHERE m.ydate = '&1'||' '||'&2'
/

-- rpt
-- We should see just 1 row:
SELECT COUNT(prdate) FROM sme;

-- Build the model:
CREATE OR REPLACE VIEW bme AS
SELECT
'abc'||m.ydate prdate
,gatt
,m.ydate - TO_DATE('2000-01-01','YYYY-MM-DD')daycount
,eur_g00
,eur_g01
,eur_g02
,eur_g03
,eur_g04
,eur_g05
,eur_g06
,eur_g07
,eur_g08
,eur_g09
,eur_g10
,eur_g11
,eur_g12
,eur_g13
,eur_g14
,eur_g15
,eur_g16
,eur_g17
,eur_g18
,eur_g19
,eur_g20
,eur_g21
,eur_g22
,eur_g23
,eur_g24
,eur_g25
,eur_g26
,eur_g27
,eur_g28
,eur_g29
,eur_g30
,eur_g31
,eur_g32
,eur_g33
,eur_g34
,eur_g35
,aud_g00
,aud_g01
,aud_g02
,aud_g03
,aud_g04
,aud_g05
,aud_g06
,aud_g07
,aud_g08
,aud_g09
,aud_g10
,aud_g11
,aud_g12
,aud_g13
,aud_g14
,aud_g15
,aud_g16
,aud_g17
,aud_g18
,aud_g19
,aud_g20
,aud_g21
,aud_g22
,aud_g23
,aud_g24
,aud_g25
,aud_g26
,aud_g27
,aud_g28
,aud_g29
,aud_g30
,aud_g31
,aud_g32
,aud_g33
,aud_g34
,aud_g35
,gbp_g00
,gbp_g01
,gbp_g02
,gbp_g03
,gbp_g04
,gbp_g05
,gbp_g06
,gbp_g07
,gbp_g08
,gbp_g09
,gbp_g10
,gbp_g11
,gbp_g12
,gbp_g13
,gbp_g14
,gbp_g15
,gbp_g16
,gbp_g17
,gbp_g18
,gbp_g19
,gbp_g20
,gbp_g21
,gbp_g22
,gbp_g23
,gbp_g24
,gbp_g25
,gbp_g26
,gbp_g27
,gbp_g28
,gbp_g29
,gbp_g30
,gbp_g31
,gbp_g32
,gbp_g33
,gbp_g34
,gbp_g35
,jpy_g00
,jpy_g01
,jpy_g02
,jpy_g03
,jpy_g04
,jpy_g05
,jpy_g06
,jpy_g07
,jpy_g08
,jpy_g09
,jpy_g10
,jpy_g11
,jpy_g12
,jpy_g13
,jpy_g14
,jpy_g15
,jpy_g16
,jpy_g17
,jpy_g18
,jpy_g19
,jpy_g20
,jpy_g21
,jpy_g22
,jpy_g23
,jpy_g24
,jpy_g25
,jpy_g26
,jpy_g27
,jpy_g28
,jpy_g29
,jpy_g30
,jpy_g31
,jpy_g32
,jpy_g33
,jpy_g34
,jpy_g35
,cad_g00
,cad_g01
,cad_g02
,cad_g03
,cad_g04
,cad_g05
,cad_g06
,cad_g07
,cad_g08
,cad_g09
,cad_g10
,cad_g11
,cad_g12
,cad_g13
,cad_g14
,cad_g15
,cad_g16
,cad_g17
,cad_g18
,cad_g19
,cad_g20
,cad_g21
,cad_g22
,cad_g23
,cad_g24
,cad_g25
,cad_g26
,cad_g27
,cad_g28
,cad_g29
,cad_g30
,cad_g31
,cad_g32
,cad_g33
,cad_g34
,cad_g35
,chf_g00
,chf_g01
,chf_g02
,chf_g03
,chf_g04
,chf_g05
,chf_g06
,chf_g07
,chf_g08
,chf_g09
,chf_g10
,chf_g11
,chf_g12
,chf_g13
,chf_g14
,chf_g15
,chf_g16
,chf_g17
,chf_g18
,chf_g19
,chf_g20
,chf_g21
,chf_g22
,chf_g23
,chf_g24
,chf_g25
,chf_g26
,chf_g27
,chf_g28
,chf_g29
,chf_g30
,chf_g31
,chf_g32
,chf_g33
,chf_g34
,chf_g35
FROM abc_ms14 m
WHERE gatt IN('nup','up')
AND 1+m.ydate < '&1'||' '||'&2'
/

-- rpt
SELECT gatt, COUNT(prdate) FROM bme GROUP BY gatt;
SELECT MAX(prdate) FROM bme;

-- Now build model from bme and score sme
@score1.sql
