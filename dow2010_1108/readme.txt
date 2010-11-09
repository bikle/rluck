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

https://github.com/bikle/rluck/blob/master/dow2010_1108/dow.txt

The first row in the report is interesting.

The consistent average return of 1.9 pips / hour looked attractive to me until I realized it was for Sunday.

The problem with Sunday is that the Forex market is only open for 3 hours from 9pm until Midnight GMT.

So that row corresponds to a total average gain of 3 x 1.9 pips which is 5.7 pips which is not large enough to interest me.

I would be interested if that Sunday position were to lead to a gbp_usd Monday position which I liked.

For example if that Monday were to fall on the 25th I would be tempted to enter the Sunday trade based on the report I find here:

https://github.com/bikle/rluck/blob/master/dom2010_1107/dom.txt

I scan of the calendar reveals that Monday will next fall on the 25th at 2011-04-25.

