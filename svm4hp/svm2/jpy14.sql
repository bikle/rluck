--
-- jpy14.sql
--

-- For jpy-model, calc goodness from attributes of gbp, etc.

DROP TABLE jpy_ms14;
CREATE TABLE jpy_ms14 COMPRESS AS
SELECT
g.ydate
,jpy_trend
,jpy_g4
,jpy_gatt gatt
,jpy_gattn gattn
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att00 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g00
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att01 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g01
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att02 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g02
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att03 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g03
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att04 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g04
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att05 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g05
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att06 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g06
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att07 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g07
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att08 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g08
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att09 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g09
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att10 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g10
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att11 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g11
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att12 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g12
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att13 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g13
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att14 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g14
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att15 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g15
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att16 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g16
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att17 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g17
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att18 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g18
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att19 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g19
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att20 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g20
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att21 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g21
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att22 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g22
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att23 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g23
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att24 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g24
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att25 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g25
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att26 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g26
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att27 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g27
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att28 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g28
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att29 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g29
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att30 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g30
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att31 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g31
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att32 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)eur_g32
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att32 ORDER BY j.ydate ROWS BETWEEN 6*40 PRECEDING AND CURRENT ROW)eur_g33
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att32 ORDER BY j.ydate ROWS BETWEEN 6*30 PRECEDING AND CURRENT ROW)eur_g34
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att32 ORDER BY j.ydate ROWS BETWEEN 6*20 PRECEDING AND CURRENT ROW)eur_g35
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,eur_att32 ORDER BY j.ydate ROWS BETWEEN 6*10 PRECEDING AND CURRENT ROW)eur_g36
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att00 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g00
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att01 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g01
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att02 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g02
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att03 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g03
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att04 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g04
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att05 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g05
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att06 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g06
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att07 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g07
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att08 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g08
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att09 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g09
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att10 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g10
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att11 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g11
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att12 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g12
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att13 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g13
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att14 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g14
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att15 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g15
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att16 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g16
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att17 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g17
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att18 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g18
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att19 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g19
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att20 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g20
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att21 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g21
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att22 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g22
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att23 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g23
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att24 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g24
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att25 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g25
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att26 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g26
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att27 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g27
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att28 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g28
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att29 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g29
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att30 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g30
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att31 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g31
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att32 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)aud_g32
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att32 ORDER BY j.ydate ROWS BETWEEN 6*40 PRECEDING AND CURRENT ROW)aud_g33
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att32 ORDER BY j.ydate ROWS BETWEEN 6*30 PRECEDING AND CURRENT ROW)aud_g34
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att32 ORDER BY j.ydate ROWS BETWEEN 6*20 PRECEDING AND CURRENT ROW)aud_g35
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,aud_att32 ORDER BY j.ydate ROWS BETWEEN 6*10 PRECEDING AND CURRENT ROW)aud_g36
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att00 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g00
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att01 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g01
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att02 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g02
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att03 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g03
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att04 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g04
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att05 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g05
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att06 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g06
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att07 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g07
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att08 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g08
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att09 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g09
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att10 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g10
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att11 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g11
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att12 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g12
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att13 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g13
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att14 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g14
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att15 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g15
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att16 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g16
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att17 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g17
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att18 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g18
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att19 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g19
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att20 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g20
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att21 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g21
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att22 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g22
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att23 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g23
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att24 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g24
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att25 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g25
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att26 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g26
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att27 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g27
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att28 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g28
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att29 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g29
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att30 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g30
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att31 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g31
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att32 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)gbp_g32
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att32 ORDER BY j.ydate ROWS BETWEEN 6*40 PRECEDING AND CURRENT ROW)gbp_g33
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att32 ORDER BY j.ydate ROWS BETWEEN 6*30 PRECEDING AND CURRENT ROW)gbp_g34
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att32 ORDER BY j.ydate ROWS BETWEEN 6*20 PRECEDING AND CURRENT ROW)gbp_g35
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,gbp_att32 ORDER BY j.ydate ROWS BETWEEN 6*10 PRECEDING AND CURRENT ROW)gbp_g36
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att00 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g00
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att01 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g01
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att02 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g02
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att03 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g03
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att04 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g04
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att05 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g05
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att06 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g06
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att07 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g07
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att08 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g08
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att09 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g09
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att10 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g10
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att11 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g11
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att12 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g12
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att13 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g13
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att14 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g14
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att15 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g15
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att16 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g16
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att17 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g17
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att18 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g18
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att19 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g19
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att20 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g20
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att21 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g21
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att22 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g22
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att23 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g23
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att24 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g24
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att25 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g25
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att26 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g26
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att27 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g27
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att28 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g28
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att29 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g29
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att30 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g30
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att31 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g31
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att32 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)jpy_g32
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att32 ORDER BY j.ydate ROWS BETWEEN 6*40 PRECEDING AND CURRENT ROW)jpy_g33
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att32 ORDER BY j.ydate ROWS BETWEEN 6*30 PRECEDING AND CURRENT ROW)jpy_g34
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att32 ORDER BY j.ydate ROWS BETWEEN 6*20 PRECEDING AND CURRENT ROW)jpy_g35
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,jpy_att32 ORDER BY j.ydate ROWS BETWEEN 6*10 PRECEDING AND CURRENT ROW)jpy_g36
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att00 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g00
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att01 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g01
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att02 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g02
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att03 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g03
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att04 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g04
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att05 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g05
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att06 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g06
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att07 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g07
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att08 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g08
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att09 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g09
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att10 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g10
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att11 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g11
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att12 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g12
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att13 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g13
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att14 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g14
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att15 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g15
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att16 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g16
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att17 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g17
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att18 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g18
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att19 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g19
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att20 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g20
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att21 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g21
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att22 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g22
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att23 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g23
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att24 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g24
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att25 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g25
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att26 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g26
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att27 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g27
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att28 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g28
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att29 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g29
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att30 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g30
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att31 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g31
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att32 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)cad_g32
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att32 ORDER BY j.ydate ROWS BETWEEN 6*40 PRECEDING AND CURRENT ROW)cad_g33
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att32 ORDER BY j.ydate ROWS BETWEEN 6*30 PRECEDING AND CURRENT ROW)cad_g34
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att32 ORDER BY j.ydate ROWS BETWEEN 6*20 PRECEDING AND CURRENT ROW)cad_g35
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,cad_att32 ORDER BY j.ydate ROWS BETWEEN 6*10 PRECEDING AND CURRENT ROW)cad_g36
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att00 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g00
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att01 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g01
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att02 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g02
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att03 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g03
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att04 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g04
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att05 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g05
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att06 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g06
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att07 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g07
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att08 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g08
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att09 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g09
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att10 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g10
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att11 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g11
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att12 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g12
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att13 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g13
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att14 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g14
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att15 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g15
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att16 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g16
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att17 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g17
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att18 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g18
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att19 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g19
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att20 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g20
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att21 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g21
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att22 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g22
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att23 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g23
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att24 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g24
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att25 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g25
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att26 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g26
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att27 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g27
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att28 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g28
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att29 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g29
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att30 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g30
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att31 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g31
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att32 ORDER BY j.ydate ROWS BETWEEN 6*22*30 PRECEDING AND CURRENT ROW)chf_g32
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att32 ORDER BY j.ydate ROWS BETWEEN 6*40 PRECEDING AND CURRENT ROW)chf_g33
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att32 ORDER BY j.ydate ROWS BETWEEN 6*30 PRECEDING AND CURRENT ROW)chf_g34
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att32 ORDER BY j.ydate ROWS BETWEEN 6*20 PRECEDING AND CURRENT ROW)chf_g35
,SUM(jpy_g4)OVER(PARTITION BY jpy_trend,chf_att32 ORDER BY j.ydate ROWS BETWEEN 6*10 PRECEDING AND CURRENT ROW)chf_g36
FROM jpy_ms10 m
,eur_att e
,aud_att a
,gbp_att g
,jpy_att j
,cad_att d
,chf_att f
WHERE m.ydate = e.ydate
AND   m.ydate = a.ydate
AND   m.ydate = g.ydate
AND   m.ydate = j.ydate
AND   m.ydate = d.ydate
AND   m.ydate = f.ydate
/

-- rpt
SELECT COUNT(ydate),MIN(ydate),MAX(ydate)FROM jpy_ms14;
