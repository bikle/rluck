#! /usr/bin/env jruby

# req_hdata_1D.rb

# Gets historical data from IB TWS

require 'rubygems' 

require 'java'

java_import 'com.ib.client.Contract'
java_import 'com.ib.client.ContractDetails'
java_import 'com.ib.client.EClientSocket'
java_import 'com.ib.client.EWrapper'
java_import 'com.ib.client.EWrapperMsgGenerator'
java_import 'com.ib.client.Execution'
java_import 'com.ib.client.Order'
java_import 'com.ib.client.OrderState'
java_import 'com.ib.client.UnderComp'
java_import 'com.ib.client.Util'

java_import 'samples.base.SimpleWrapper'
java_import 'samples.base.StkContract'
java_import 'samples.base.OptContract'

java_import 'samples.rfq.RfqOrder'
java_import 'samples.rfq.SampleRfq'

class ReqHdata

  def self.jl_str(s)
    java.lang.String.new(s)
  end

  # Derived from main() in SampleRfq.java
  def self.get_hdata
    if $*.size != 1
      p "I want you to give me SYMBOL."
      p "Usage: req_hdata.rb SYMBOL"
      p "Demo: req_hdata.rb SPY"
      return 
    end
    p 'getting hdata'
    m_rfqId= (java.lang.System.currentTimeMillis() / 1000)
    mode= 0
    m_clientId= 3
    ut= SampleRfq.new(m_clientId, m_rfqId, mode)

    contract= Contract.new
    contract.m_currency= jl_str "USD"
    # contract.m_symbol= jl_str "SPY"
    contract.m_symbol= jl_str $*.first
    contract.m_secType= jl_str "STK"
    contract.m_exchange= jl_str "SMART"

    mid= 10 # This id comes back as values in a column. They want me to use it to id the data.
    tn= Time.now
    t60= tn+ 60
    gm_time=t60.gmtime.strftime("%Y%m%d %H:%M:%S")+" GMT"
    # m_backfillEndTime= jl_str "20100816 23:59:59 GMT"
    m_backfillEndTime= jl_str gm_time

    # I want 4 Weeks of data:
    m_backfillDuration= jl_str "4 W"

    # I want 1 Week of data:
    m_backfillDuration= jl_str "1 W"

    # I want 2 Days of data:
    m_backfillDuration= jl_str "2 D"

    m_barSizeSetting= jl_str "1 hour"
    # this does not work: m_whatToShow= jl_str "TRADES"
    m_whatToShow= jl_str "MIDPOINT"
    m_useRTH= 1 # Only get data corresponding to RTH.
    m_useRTH= 0 # Get data which may be outside of Reg. Trading Hours
    m_formatDate= 1
    m_formatDate= 2 # seconds since epoch

    # send a request to tws
    ut.connect
    p "ut.client.is_connected?:"
    p  ut.client.is_connected?

    ut.client.reqHistoricalData(
      mid,
      contract,
      m_backfillEndTime,
      m_backfillDuration,
      m_barSizeSetting,
      m_whatToShow,
      m_useRTH,
      m_formatDate
    )

    p 'done getting hdata'
    p 'wait a few seconds before disconnect'
    sleep 15
    ut.disconnect
    p 'Disconnected now. Bye'
  end # def get_hdata
end # class

# Run this class now
ReqHdata.get_hdata

# Look at the data place in sysout_1.log by SampleRfq object (named "ut"):
# system("cat sysout_1.log")
tn= Time.now.gmtime.strftime("%Y%m%d_%H_%M_%S")+"_gmt.csv"
File.rename('sysout_1.log',"csv_files/#{$*.first}_data_#{tn}")
p "done"
