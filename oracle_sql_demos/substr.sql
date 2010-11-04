--
-- substr.sql
--

SELECT 'SPY2010_10_15_14'tkrhr FROM dual;

-- Get 1st 4 chars:
SELECT 
SUBSTR(tkrhr,1,4)sb
FROM
  (SELECT 'SPY2010_10_15_14'tkrhr FROM dual)
/

-- At 3rd char get 4 chars.
-- Y201
SELECT 
SUBSTR(tkrhr,3,4)sb
FROM
  (SELECT 'SPY2010_10_15_14'tkrhr FROM dual)
/

-- Count backwards from end:
SELECT 
SUBSTR(tkrhr,-14,9)sb
FROM
  (SELECT 'SPY2010_10_15_14'tkrhr FROM dual)
/

-- Left trim (counting from right).
-- 2010_10_15_14
SELECT 
SUBSTR(tkrhr,-13)sb
FROM
  (SELECT 'SPY2010_10_15_14'tkrhr FROM dual)
/

-- Left trim (counting from left):
-- 5_14
SELECT 
SUBSTR(tkrhr,13)sb
FROM
  (SELECT 'SPY2010_10_15_14'tkrhr FROM dual)
/

-- Right trim (counting from right).
-- SPY:
SELECT 
SUBSTR(tkrhr,-LENGTH(tkrhr),LENGTH(tkrhr)-13)sb
FROM
  (SELECT 'SPY2010_10_15_14'tkrhr FROM dual)
/

exit
