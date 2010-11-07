woq2010_1106/readme.txt

This directory contains some of my efforts to look at Week-Of-Quarter aggregations of Forex data.

I am mostly interested in aggregations after 2009-01-01.

A good place to start a study of this directory is this bash script:

https://github.com/bikle/rluck/blob/master/woq2010_1106/sbw_woq.bash

When the above script is finished running I have a table named fxw loaded with Forex data from here:

http://www.federalreserve.gov/releases/h10/hist/

Usually, after I run sbw_woq.bash, I run this bash script:

https://github.com/bikle/rluck/blob/master/woq2010_1106/qry_djd.bash

It is just a shell wrapper for this SQL script:

https://github.com/bikle/rluck/blob/master/woq2010_1106/qry_djd.sql

The above SQL script aggregates normalized-daily-gains for each currency pair and groups by Week-Of-Quarter.

I placed a copy of output from the script at this URL:

https://github.com/bikle/rluck/blob/master/woq2010_1106/qry_djd.txt

How might I use the above output?

I start by looking at my calendar.

Today is Saturday 2010-11-06.

Tomorrow on Sunday 2010-11-07 at 16:01 in California it will be 2010-11-08 00:01 GMT.

The Forex market at that time will be a bit quiet but it will be open.

That time will mark the start of week 7 of Quarter 4.

Next, I will look at this URL:

https://github.com/bikle/rluck/blob/master/woq2010_1106/qry_djd.txt

I will see, on average, that on week 7 of every quarter after 2009-01-01 the aud_usd pair lost about 16 pips / day.

Also, I will see that the average was calculated from measuring the results of 26 separate days since 2009-01-01.

That is a subtle point.  These results come from measuring daily-gains, not weekly-gains.

Then I will ask some questions:

  - Do I think this correlation trend will continue?
  - Do I think that 16 pips / day is a decent rate of return?
  - How risky is shorting aud_usd for 1 day on week 7 of the quarter?

My answers:

  - No, I do not think the trend will continue.
  Due to recent actions by the Fed I think that aud_usd will gain, not fall.
  When aud_usd gains that means traders are using USD to buy AUD.
  Currently the Fed is increasing the supply of USD:
  https://www.google.com/finance?q=audusd

  - Yes, 16 pips / day is a decent rate of return.  To get that rate I need to supply 250 pips of my own money.
  My rate of return for one day would be 16 pips / 250 pips which is 6.4% / day.

  - Shorting aud_usd for 1 day on week 7 of the quarter would be extremely risky.
  The report for this trade shows a standard deviation of 116 pips.
  I visualize the risk as a normal curve centered at -16 pips.
  You can see a normal curve here:

  http://en.wikipedia.org/wiki/Standard_deviation

  A standard deviation of 116 pips means that it is significantly probable that this trade would lose 116 pips.
  To do this trade I need to supply 250 pips.
  So, I could lose almost half my money in 1 day.

  On the plus side, it is significantly probable that this trade would gain 116 pips.
  On the minus side, look how the standard deviation of other rows compare to 116 pips.
  The first row for example has a standard deviation of 84 pips.

  To keep my risk low, I would avoid shorting aud_usd during week 7 of the quarter.

  Instead I would show patience and wait.
  I would go-long on aud_usd during week 10.
  It conforms to my bullish sentiment towards aud_usd.
  It shows an average return of 48 pips which is 3 times larger than 16 pips.
  And the price I pay in stddev is less than half of 116 pips.
