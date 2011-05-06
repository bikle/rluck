#!/usr/bin/env spec

# spec1_spec.rb

# Helps me ensure that rlooper is doing the right thing.

require 'spec_helper'

describe "rlooper helps me download tkr prices and then run SVM against them" do

  # I use tkrs_a to hold an array of tkr-strings which help me download tkr-prices.
  # Once I have a list of prices for a tkr, I feed the list to SVM for scoring.
  tkrs_a = []
  first5tkrs = []
  next5tkrs = []

  it "Some files should exist" do
    dglb = Dir.glob("/pt/s/rluck/svmspy/rlooper/spec/spec1_spec.rb")
    dglb.size.should == 1
    dglb = Dir.glob("/pt/s/rluck/svmspy/rlooper/.rlooper")
    dglb.size.should == 1
    dglb = Dir.glob("/pt/s/rluck/svmspy/rlooper/bin/sqt")
    dglb.size.should == 1
    dglb = Dir.glob("/pt/s/rluck/svmspy/rlooper/states.txt")
    dglb.size.should == 1
  end
##

  it "Some tkrs should exist" do
    sqt_out = `sqt @qry_tkrs.sql`
    sqt_out.should include("IBM")
    sqt_out.should include("175 rows selected")
    # Copy the tkrs I want into a long String:
    tkrs_s = /(AAPL\n)(\w+\n)+(YUM\n)/.match(sqt_out)[0]
    # Copy the tkrs I want into an Array:
    tkrs_a = []
    tkrs_s.each_line{ |al| tkrs_a << al.chomp }
    tkrs_a.size.should == 175
  end
##

  it "rlooper starting state should be not started yet" do
    # pending("dev being done.")
    tkrs_a.size.should == 175
    File.open("/pt/s/rluck/svmspy/rlooper/states.txt","r"){|ln1|
      ln1.read.chomp.should == "not started yet"
    }
  end
##

  it "rlooper state should transition to downloading 5 tkrs" do
    fhw = File.open("/pt/s/rluck/svmspy/rlooper/states.txt","w")
    fhw.write "downloading 5 tkrs\n"
    fhw.close
    File.open("/pt/s/rluck/svmspy/rlooper/states.txt","r"){|ln1|
      ln1.read.chomp.should == "downloading 5 tkrs"
    }
    # Now download 5 tkrs.
    5.times.each{|tkr_cntr| first5tkrs << tkrs_a.pop}
    first5tkrs.size.should == 5
    p "Now downloading:"
    p first5tkrs
    p "Now transition to next state."
  end
##

  it "rlooper state should transition to downloading 5 tkrs and running SVM" do
    fhw = File.open("/pt/s/rluck/svmspy/rlooper/states.txt","w")
    fhw.write "downloading 5 tkrs and running SVM\n"
    fhw.close
    File.open("/pt/s/rluck/svmspy/rlooper/states.txt","r"){|ln1|
      ln1.read.chomp.should == "downloading 5 tkrs and running SVM"
    }
    first5tkrs.size.should == 5
    # Get the next five tkrs lined up
    next5tkrs = []
    5.times.each{|tkr_cntr| next5tkrs << tkrs_a.pop} unless tkrs_a.size < 5
    next5tkrs.size.should == 5
    p "Now downloading next5tkrs."
    p "Now running SVM on first5tkrs."
    while(tkrs_a.size > 4)
      # save next5tkrs
      next5tkrs_saved = next5tkrs
      next5tkrs_saved.size.should == 5
      next5tkrs = []
      5.times.each{|tkr_cntr| next5tkrs << tkrs_a.pop}
      next5tkrs.size.should == 5
      p "Now downloading:"
      p next5tkrs
      p "Now running SVM on:"
      p next5tkrs_saved
    end
    tkrs_a.size.should == 0
    next5tkrs.should == ["ADBE", "ACI", "ABX", "ABT", "AAPL"]
  end
##

  it "rlooper state should transition to running SVM" do
    fhw = File.open("/pt/s/rluck/svmspy/rlooper/states.txt","w")
    fhw.write "running SVM\n"
    fhw.close
    File.open("/pt/s/rluck/svmspy/rlooper/states.txt","r"){|ln1|
      ln1.read.chomp.should == "running SVM"
    }
    next5tkrs.should == ["ADBE", "ACI", "ABX", "ABT", "AAPL"]
    p "Now running SVM on:"
    p next5tkrs
  end
##

  it "rlooper state should transition to not started yet" do
    fhw = File.open("/pt/s/rluck/svmspy/rlooper/states.txt","w")
    fhw.write "not started yet\n"
    fhw.close
    File.open("/pt/s/rluck/svmspy/rlooper/states.txt","r"){|ln1|
      ln1.read.chomp.should == "not started yet"
    }
  end
##

end
