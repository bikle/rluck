sbw_wom_h/readme.txt

This directory is essentially a wrapper for one SQL query.

The idea behind the query is simple.

I want a list of Week-Of-Months which have done well after 2009-01-01.

The data which the query SELECTs from is more fine-grained than the data I get from the Fed.

The data is at the hourly level rather than the daily level.

I found the data using this google query:

https://encrypted.google.com/search?q=free+forex+historical+data

I compared the data to high quality data I get from my broker.

As far as I can tell, the data is accurate for after 2009.

For 2008, some of the data for the usd_jpy pair is corrupt.  

The corrupt usd_jpy data appears to be off by a factor of 2.

So, the SQL in this directory avoids data before 2009.

Here is some information about the SQL query I wrote.

The query aggregates one attribute of each currency pair which I deem important.

It is an attribute I call "Normalized Hourly Gain".

For 1 hour it is easy to calculate.  

I subtract opening price from closing price for that hour for each pair.

Then, I divide that difference by the opening price.

This gives me a number which is comparable between currency pairs.

If I just used (closing price - opening price) to calculate the gain for each hour,
the usd_jpy pair would dominate the results.

Why?

This is because the Forex prices for the usd_jpy pair is about 80 times larger than the other USD-pairs.

Another obvious question which falls out of this discussion is,
"Why am I looking at hourly gain?"

If I am looking for a best Week-Of-Month to buy a pair and hold it for 1 week and then sell it,
I should be looking at weekly gain.

Answer:
Writing SQL to report on hourly gain is easy because the data is at the hourly level.

Reporting at the weekly level is more difficult because I would need 2 views of the data and then join them.

The first view would be a list of pairs and prices for every Sunday at 21:00 GMT when the Forex market opens for that week.

The second view would be a list of pairs and prices for every Friday at 21:00 GMT when the Forex market closes for that week.

Instead of doing that, I just look at the data at the hourly level and aggregate Normalized Hourly Gain 3 obvious ways:

  - Average
  - Sum
  - Count

One convenient feature of SQL is that I can derive the Week-Of-Month attribute for every hour in the data.

So I do that and pass that attribute into the SQL query as a GROUP BY attribute.

In theory, the aggregation done by the SUM() function should give me the same result as the 2-view-route, but that would only be true if I have every single hour for every single pair.

Also that assumption would depend on a complete lack of rounding errors in the data.

This method might be a little less accurate than going the 2-view-route but for my purposes it is good enough.

Also I like the fact that the SQL query is only 18 lines long.

