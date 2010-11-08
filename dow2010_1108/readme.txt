dow2010_1108/readme.txt

This directory contains some scripts I use to see recent historical returns for each pair for each day of the week.

Currently I am interested in 6 currency pairs:

aud_usd
gbp_usd
eur_usd

usd_cad
usd_chf
usd_jpy

For my purposes I will often use numbers to identify a day of the week:

1: Sunday
2: Monday
3: Tuesday
4: Wednesday
5: Thursday
6: Friday
7: Saturday

The Forex market does not trade on Saturday so I should not see any results for Day-Of-Week #7 in my reports.

I wrote a simple query to show if any pairs returned more than 1/2 pip per hour for a given day after 2009-01-01.

It only returned 4 rows.  

Perhaps that should be expected because
if a pair consistently gain or lost value on a specific weekday 
then it would eventually lose all of its value.

Output from the query can be seen here:

