#! /usr/bin/env jruby
# /pt/s/api/fd/place_order.rb

# Usage: place_order.rb SYMBOL CURRENCY buy|sell opendate closedate
# Demo: place_order.rb EUR USD buy 20110206_20:06:12_GMT 20110207_00:06:12_GMT

require 'rubygems' 
require 'ruby-debug' 

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

java_import 'samples.rfq.RfqOrder'
java_import 'samples.rfq.SampleRfq'

class PlaceOrder

  def self.jl_str(s)
    java.lang.String.new(s)
  end

  def self.place_order
    if $*.size != 6
      p "I want you to give me 6 params"
      p "Usage: place_order.rb buy|sell size SYMBOL CURRENCY opendate closedate"
      p "Demo: place_order.rb buy 30000 USD JPY 20101216_20:06:12_GMT 20101217_00:06:12_GMT"
      return 
    end

    m_clientId= 2
    m_rfqId= (java.lang.System.currentTimeMillis() / 1000)
    mode= 0
    ut= SampleRfq.new(m_clientId, m_rfqId, mode)

    my_contract= Contract.new
    my_order=  Order.new
    buysell= $*[0]

    case
    when (buysell == "buy" or buysell == "BUY") then
      my_order.m_action     =  jl_str "BUY"
    when (buysell == "sell" or buysell == "SELL") then
      my_order.m_action     =  jl_str "SELL"
    end

    ssize= 40*1000
    # For AUD, CAD, CHF, JPY, that is about $40,000
    ssize= $*[1].to_i

    my_contract.m_symbol  = jl_str "EUR"
    my_contract.m_symbol  = jl_str $*[2]
    my_contract.m_currency= jl_str "USD"
    my_contract.m_currency= jl_str $*[3]
    my_contract.m_secType = jl_str "CASH"
    my_contract.m_exchange= jl_str "IDEALPRO"

    opdate = $*[4]

    # (my_order.methods - 1.methods).each{|m| p m}
    # I think that IB ignores my_order.m_orderId, so I set it to 10.
    my_order.m_orderId      = 10
    my_order.m_clientId     = m_clientId
    my_order.m_permId       = my_order.m_orderId

    # my_order.m_goodTillDate = jl_str "20110227 20:50:28 GMT"
    my_order.m_goodAfterTime = jl_str opdate.gsub(/_/,' ')  # I want: "20110227 19:40:28 GMT"
    my_order.m_totalQuantity= ssize
    my_order.m_orderType    = jl_str "MKT"
    my_order.m_lmtPrice     = nil
    my_order.m_tif          = jl_str "GTC"
    my_order.m_transmit     = false
    my_order.m_transmit     = true
    my_order.m_overridePercentageConstraints= false

    # send a request to tws
    ut.connect
    p "ut.client.is_connected?:"
    p  ut.client.is_connected?

    ut.client.placeOrder(m_rfqId,my_contract,my_order)

    # Wait a bit b4 disconnect.
    sleep 6
    ut.disconnect
    p 'Disconnected now. '
    p 'Attempting to connect again to enter closing order. '

    # Now enter order to close the position

    m_clientId= 3

    m_rfqId= (java.lang.System.currentTimeMillis() / 1000)
    mode= 0
    ut2= SampleRfq.new(m_clientId, m_rfqId, mode)

    my_contract2= Contract.new
    my_order2=  Order.new
    buysell= $*[0]

    case
    when (buysell == "buy" or buysell == "BUY") then
      # my_order2.m_action     =  jl_str "BUY"
      my_order2.m_action     =  jl_str "SELL"
    when (buysell == "sell" or buysell == "SELL") then
      # my_order2.m_action     =  jl_str "SELL"
      my_order2.m_action     =  jl_str "BUY"
    end

    ssize= 40*1000
    # For AUD, CAD, CHF, JPY, that is about $40,000
    ssize= $*[1].to_i

    my_contract2.m_symbol  = jl_str "EUR"
    my_contract2.m_symbol  = jl_str $*[2]
    my_contract2.m_currency= jl_str "USD"
    my_contract2.m_currency= jl_str $*[3]
    my_contract2.m_secType = jl_str "CASH"
    my_contract2.m_exchange= jl_str "IDEALPRO"

    clsdate = $*[5]

    # I think that IB ignores my_order2.m_orderId, so I set it to 11.
    my_order2.m_orderId      = 11
    my_order2.m_clientId     = m_clientId
    my_order2.m_permId       = my_order2.m_orderId

#    my_order2.m_goodTillDate = jl_str "20110227 20:50:28 GMT"
    my_order2.m_goodAfterTime = jl_str clsdate.gsub(/_/,' ')  # I want: "20110227 19:40:28 GMT"
    my_order2.m_totalQuantity= ssize
    my_order2.m_orderType    = jl_str "MKT"
    my_order2.m_lmtPrice     = nil
    my_order2.m_tif          = jl_str "GTC"
    my_order2.m_transmit     = false
    my_order2.m_transmit     = true
    my_order2.m_overridePercentageConstraints= false

    # send a request to tws
    ut2.connect
    p "ut2.client.is_connected?:"
    p  ut2.client.is_connected?

    ut2.client.placeOrder(m_rfqId,my_contract2,my_order2)

    # Wait a bit b4 disconnect.
    sleep 6
    ut2.disconnect
    p 'Disconnected now. '

  end # def self.place_order
end # class

# Run this class now
PlaceOrder.place_order

p "done"

