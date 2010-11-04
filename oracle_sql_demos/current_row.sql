
CREATE TABLE q13 COMPRESS AS
SELECT
pair
,ydate
,prdate
,rnum
,lg4
,lg8
,lg12
,volnt
,clse
,ld1
,ld2
,ld3
,ld4
,DECODE(SIGN(clse-lg8), 0 , -1 ,(SIGN(clse-lg8))) trend
-- step by 1
,clse-lg1 d01
,lg1-lg2  d12
,lg2-lg3  d23
,lg3-lg4  d34
,lg4-lg5  d45
,lg5-lg6  d56
,lg6-lg7  d67
,lg7-lg8  d78
,lg8-lg9  d89
-- step by 2
,clse-lg2 d02
,lg2-lg4 d24
,lg4-lg6 d46
,lg6-lg8 d68
-- step by 3
,clse-lg3 d03
,lg3-lg6  d36
,lg6-lg9  d69
,lg9-lg12 d912
-- step by 4
,clse-lg4 d04
,lg4-lg8  d48
,lg8-lg12 d812
,lg6-lg12 d612
,lg12-lg18 d1218
-- 
,ABS(clse-lg1)dc1
,ABS(clse-lg2)dc2
,ABS(clse-lg3)dc3
,ABS(clse-lg4)dc4
,ABS(clse-lg5)dc5
,ABS(clse-lg6)dc6
,ABS(clse-lg7)dc7
,ABS(clse-lg8)dc8
,ABS(clse-lg9)dc9
,ABS(clse-lg12)dc12
,ABS(clse-lg18)dc18
,ABS(clse-lg24)dc24
,ABS(clse-lg72)dc72
,(ld1-clse) g1
,(ld2-clse) g2
,(ld3-clse) g3
,(ld4-clse) g4
-- ,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY pair,ydate ROWS BETWEEN 2  PRECEDING AND CURRENT ROW)cvp2
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY pair,ydate ROWS BETWEEN 2  PRECEDING AND CURRENT ROW)crr2
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY pair,ydate ROWS BETWEEN 3  PRECEDING AND CURRENT ROW)crr3
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY pair,ydate ROWS BETWEEN 4  PRECEDING AND CURRENT ROW)crr4
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY pair,ydate ROWS BETWEEN 5  PRECEDING AND CURRENT ROW)crr5
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY pair,ydate ROWS BETWEEN 6  PRECEDING AND CURRENT ROW)crr6
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY pair,ydate ROWS BETWEEN 7  PRECEDING AND CURRENT ROW)crr7
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY pair,ydate ROWS BETWEEN 8  PRECEDING AND CURRENT ROW)crr8
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY pair,ydate ROWS BETWEEN 9  PRECEDING AND CURRENT ROW)crr9
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY pair,ydate ROWS BETWEEN 12 PRECEDING AND CURRENT ROW)crr12
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY pair,ydate ROWS BETWEEN 24 PRECEDING AND CURRENT ROW)crr24
,COVAR_POP(rnum,clse)OVER(PARTITION BY pair ORDER BY pair,ydate ROWS BETWEEN 72 PRECEDING AND CURRENT ROW)crr72
,0+TO_CHAR(ydate,'HH24')hh
,0+TO_CHAR(ydate,'DD')dd
,0+TO_CHAR(ydate,'D')d
,0+TO_CHAR(ydate,'W')w
FROM q11
ORDER BY pair,ydate
/
