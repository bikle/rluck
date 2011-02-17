--
-- score_gaps.sql
--

-- I use this script to help me find score_gaps.

-- Get a count of prices 1st.
SELECT COUNT(tkrdate)FROM di5min_stk_c2 WHERE ydate > '2011-02-13';

-- Join scores and prices and count that
SELECT COUNT(d.tkrdate)
FROM di5min_stk_c2 d, stkscores s
WHERE d.ydate > '2011-02-13'
AND   s.ydate > '2011-02-13'
AND d.tkrdate = s.tkrdate
AND s.targ = 'gatt'
/
SELECT COUNT(d.tkrdate)
FROM di5min_stk_c2 d, stkscores s
WHERE d.ydate > '2011-02-13'
AND   s.ydate > '2011-02-13'
AND d.tkrdate = s.tkrdate
AND s.targ = 'gattn'
/

exit
