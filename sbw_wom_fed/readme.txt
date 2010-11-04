sbw_wom_fed/readme.txt

The scripts in this dir are an attempt to answer the question,
"Can I find a pair and a specific week of the month when the pair consistently goes up or down?"

Using data from the Fed, I found the answer to be "No."

Outside of this effort though, if I have reason the be bullish or bearish on a particular pair,
the report below might be of interest.

For example, if I think that the Aus. Dollar (AUD) will rise relative
to USD, because Australia has access to natural resources and the US
Fed is dropping USD from helicopters then I should study the report below.

In particular, focus on the first row.

It tells me that a good time to buy AUD with USD is the 3rd week of the month in any 3rd quarter.

In the 3rd week of the 3rd quarter of 2010, the aud_usd pair gained an average of 111 pips.

A gain of 111 pips on $1.00 is:

100% x(111/10,000) which is 1.11% which is a decent rate of return for 1 week.

Typically though a Forex position is financed with 2.5% collateral.

So I could argue the gain of 111 pips was on 2.5% of $1.00 which is:

100% x (111/10,000) x (100 / 2.5) which is 44.4% which is a decent rate of return for 1 week.


14:19:50 SQL> SELECT * FROM wjww0 WHERE ABS(SIGN(avg08)+SIGN(avg09)+SIGN(avg10)) = 3;

PAIR    W Q      AVG08      AVG09      AVG10
------- - - ---------- ---------- ----------
aud_usd 3 3 .005609024 .011066753 .011087742
aud_usd 3 4 -.02487392 -.00869519 -.00473247
eur_usd 2 3 .001751127  .00746248 .008816956
eur_usd 3 3 .005777984 .004998471 .007681597
eur_usd 3 4 -.01373598 -.00124681 -.00534495
eur_usd 5 2 -.00193384 -.00206055 -.00579895
gbp_usd 1 3 -.01449898 -.00446618 -.00322086
gbp_usd 3 2 .005361459 .004531898 .003687887
gbp_usd 3 4 -.03506852 -.00679838  -.0051647
gbp_usd 5 2 -.00834908 -.00250951 -.01053439
usd_cad 2 4  .01074816 .005082746 .014399898
usd_cad 3 4 .020683254 .004347615  .00564593
usd_chf 1 2 -.00326551 -.00091719 -.00121924
usd_chf 2 2 .001037074  .00506718 .002686825
usd_chf 2 3 -.00544082 -.00871231 -.00717623
usd_chf 3 3 -.00113189 -.00500746 -.00984068
usd_chf 5 1 .006815322 .002890469 .010141942
usd_chf 5 2 .003389907 .001239113 .003102641
usd_jpy 1 1 -.00344727 -.00701281 -.00053224
usd_jpy 4 2 .001803252 .008600863  .00182281
usd_jpy 4 3 -.00364846 -.00576646 -.00843706
usd_jpy 5 1 .001624977 .021522574 .004257194

22 rows selected.
