dom2010_1107/readme.txt

This directory contains some scripts I use to see recent historical returns for each pair for each day of the month.

Currently I am interested in 6 currency pairs:

aud_usd
gbp_usd
eur_usd

usd_cad
usd_chf
usd_jpy

And I know that Day Of Month can range from 1 to 31.

6 x 31 is 186 and that is the number of combinations of pairs and Day-Of-Months I might be interested in.

I visualize this set of combinations as an SQL-view with 186 rows named hdom.

I constructed hdom so it has these column names:

pair
day_of_month
avg_nhgain
sum_nhgain
count_nhgain
stddev_nhgain

The column, avg_nhgain, is the average normalized hourly gain for a given pair on a given Day-Of-Month.
The column, sum_nhgain, is the sum of normalized hourly gains for a given pair on a given Day-Of-Month.
The column, count_nhgain, tells me how many rows I had to aggregate to calculate both the average and the sum.
The column, stddev_nhgain, is the standard deviation of normalized hourly gains for a given pair on a given Day-Of-Month.

I use stddev_nhgain as a feeble attempt to measure the amount of risk behind each trade.

Normalized hourly gain is calculated by this expression: (closing_price - opening_price)/opening_price

For some currencies, price is near 1 USD: AUD, CAD, CHF
For others, price is not far from 1 USD: GBP, EUR
For JPY the price is near 80 JPY for 1 USD.

So, the main purpose of normalized hourly gain is to allow me to compare JPY to other currencies.

The data that the scripts focus on is hourly data.

I found it using this query:

https://encrypted.google.com/search?q=forex+historical+data

Inside of the query which creates the hdom view,
I arbitrarily set a constraint that says I am only interested in hdom-rows having an average-normalized-hourly-gain
greater than 1 pip / hour.

With this constraint in place, I see a subset of hdom which is only 38 rows long:

https://github.com/bikle/rluck/blob/master/dom2010_1107/dom.txt

Another bit of helpful SQL I wrote separates hdom into 2 categories:

  - USD bearish results
  - USD bullish results

The USD bearish results contain 29 rows and the  USD bullish results contain 9 rows.

For after 2009-01-01 the trade with the best average hourly return was
a short of usd_chf (Sell USD, Buy CHF) on the 31st Day-Of-Month.

This opportunity appeared 175 times between 2009-01-01 and 2010-11-01.

On average the trade returned almost 3 pips / hour for a total of 511 pips.

A trader pursuing this trade would have needed 250 pips in collateral to finance the trade.

So that hypothetical trader would have easily doubled his collateral.

The standard deviation behind this result was about 15 pips which compares favorably with 
standard deviation from other trades.

As a trader I want to see high absolute values for average-nhgain and low values for standard deviation.
