tkr = "XOM"

mydglb = Dir.glob("/pt/s/rluck/svmspy/ibapi/csv_files/#{tkr}*csv")
mylast = Dir.glob("/pt/s/rluck/svmspy/ibapi/csv_files/XOM*csv").last

myctime = File.ctime(mylast)

p dglb.first
p dglb.last


#    `/bin/bash /tmp/dl_first5tkrs.bash`

tkr = "IBM"

`echo /pt/s/rluck/svmspy/ibapi/5min_data.bash #{tkr} > /tmp/ibm.txt`
