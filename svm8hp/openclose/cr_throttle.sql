--
-- cr_throttle.sql
--

DROP   TABLE throttle;
PURGE RECYCLEBIN;
CREATE TABLE throttle
(
pair         VARCHAR2(4)
,longshort   NUMBER
,bottomscore NUMBER
,ok2open     DATE
,tval        NUMBER
)
/

INSERT INTO throttle VALUES('aud',1,0.85,sysdate,1);
INSERT INTO throttle VALUES('aud',-1,0.85,sysdate,1);

INSERT INTO throttle VALUES('eur',1,0.85,sysdate,1);
INSERT INTO throttle VALUES('eur',-1,0.85,sysdate,1);

INSERT INTO throttle VALUES('gbp',1,0.85,sysdate,1);
INSERT INTO throttle VALUES('gbp',-1,0.85,sysdate,1);

INSERT INTO throttle VALUES('cad',1,0.85,sysdate,1);
INSERT INTO throttle VALUES('cad',-1,0.85,sysdate,1);

INSERT INTO throttle VALUES('chf',1,0.85,sysdate,1);
INSERT INTO throttle VALUES('chf',-1,0.85,sysdate,1);

INSERT INTO throttle VALUES('jpy',1,0.85,sysdate,1);
INSERT INTO throttle VALUES('jpy',-1,0.85,sysdate,1);
