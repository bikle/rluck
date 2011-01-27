--
-- gen_svmtkr.sql
--

-- I use this script to generate a list of shell commands in random order.

SET pages 222

SELECT cmd FROM
(
SELECT
DISTINCT './svmtkr.bash '||tkr cmd
FROM ystk
)
ORDER BY dbms_random.value
/

exit
