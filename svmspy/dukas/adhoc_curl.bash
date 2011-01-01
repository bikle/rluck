#! /bin/bash

# /pt/s/dukas/adhoc_curl.bash

# Get recent data from dukascopy.com

set -x
cd /pt/s/rluck/svmspy/dukas/

# I think that uagent cannot be passed via variable. So, hard code this string:
# 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)'

export url0='http://www.dukascopy.com/freeApplets/exp/exp.php?'

export url2='fromD='`date -u '+%m.%d.%Y'`
export url2='fromD=03.19.2010'

# 3600 is 1 hr
export url4='&np=2000&interval=3600&DF=m/d/y'
# 600 is 10 min
export url4='&np=2000&interval=600&DF=m/d/y'

export url8='&endSym=unix&split=tz'

# I want this 1 stock:
# 331 is SPY.
# HTML of form is here:
# dukasform.html
export url_stock='&Stock=331'

# Get the data
export myts=`date -u '+%Y_%m_%d_%H_%M'`
# echo ${url0}${url2}${url4}${url_EUR_JPY}${url8}

# Remove cookies from last time.
rm -f cj.txt

export socks4a='127.0.0.1:9050'

# curl --socks4a $socks4a --user-agent 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)' --cookie-jar cj.txt --cookie cj.txt --no-buffer --output stock_${myts}.csv ${url0}${url2}${url4}${url_stock}${url8}

curl --user-agent 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)' --cookie-jar cj.txt --cookie cj.txt --no-buffer --output stock_${myts}.csv ${url0}${url2}${url4}${url_stock}${url8}

# Load the data into adhoc table

