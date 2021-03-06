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
    sqt_out = `sqt @qry_tkrs_a_i.sql`
    sqt_out.should include("IBM")
    sqt_out.should include("94 rows selected")
    # Copy the tkrs I want into a long String:
    tkrs_s = /(AAPL\n)(\w+\n)+(IYR\n)/.match(sqt_out)[0]
    # Copy the tkrs I want into an Array:
    tkrs_a = []
    tkrs_s.each_line{ |al| tkrs_a << al.chomp }
    tkrs_a.size.should == 94
  end
##

  it "rlooper starting state should be not started yet" do
    tkrs_a.size.should == 94
    # I make note of my current state
    `echo not started yet > /pt/s/rluck/svmspy/rlooper/states.txt`
    `cat /pt/s/rluck/svmspy/rlooper/states.txt`.chomp.should == "not started yet"
  end
##

  it "rlooper state should transition to downloading 5 tkrs" do
    # I make note of my current state
    `echo downloading 5 tkrs > /pt/s/rluck/svmspy/rlooper/states.txt`
    `cat /pt/s/rluck/svmspy/rlooper/states.txt`.chomp.should == "downloading 5 tkrs"
    # Now download 5 tkrs.
    5.times.each{|tkr| first5tkrs << tkrs_a.pop}
    first5tkrs.size.should == 5
    p "Now downloading first5tkrs:"
    p first5tkrs
    `echo '#!/bin/bash' > /tmp/dl_first5tkrs.bash`
    first5tkrs.each{|tkr| `echo /pt/s/rluck/svmspy/ibapi/5min_data.bash #{tkr} >> /tmp/dl_first5tkrs.bash`}
    `/bin/bash /tmp/dl_first5tkrs.bash`
    # I wait for the shell script in /tmp/ to finish:
    `ps waux | grep dl_first5tkrs.bash |grep -v grep`.should == ""
    # I should see a recent CSV file younger than 5*60 seconds:
    recent_fn = Dir.glob("/pt/s/rluck/svmspy/ibapi/csv_files/#{first5tkrs.last}*csv").sort.last
    csv_time = File.ctime(recent_fn)
    (Time.now - csv_time).should < 5*60
    p "Now transition to next state."
  end
##

  it "rlooper state should transition to downloading 5 tkrs and running SVM" do
    `echo downloading 5 tkrs and running SVM > /pt/s/rluck/svmspy/rlooper/states.txt`
    `cat /pt/s/rluck/svmspy/rlooper/states.txt`.chomp.should == "downloading 5 tkrs and running SVM"
    first5tkrs.size.should == 5
    # Get the next five tkrs lined up
    next5tkrs = []
    5.times.each{|tkr| next5tkrs << tkrs_a.pop} unless tkrs_a.size < 5
    next5tkrs.size.should == 5

    p "Now downloading next5tkrs in the background:"
    p next5tkrs
    `echo '#!/bin/bash' > /tmp/dl_next5tkrs.bash`
    next5tkrs.each{|tkr| `echo /pt/s/rluck/svmspy/ibapi/5min_data.bash #{tkr} >> /tmp/dl_next5tkrs.bash`}
    `echo '#!/bin/bash' > /tmp/run_dl_next5tkrs.bash`
    `echo '/tmp/dl_next5tkrs.bash &' >> /tmp/run_dl_next5tkrs.bash`
    `chmod +x /tmp/dl_next5tkrs.bash /tmp/run_dl_next5tkrs.bash`
    # I want the script below to run in the background so the command should return quickly:
    time0 = Time.now
    `/tmp/run_dl_next5tkrs.bash > /tmp/out_of_run_dl_next5tkrs.txt 2>&1`
    sleep 1
    (Time.now - time0).should < 5
    # I should see the dl_script in the ps-listing:
    `ps waux | grep /tmp/dl_next5tkrs.bash | grep -v grep | wc -l`.chomp.should == "1"
    p "Now running SVM on first5tkrs."
    `echo '#!/bin/bash' > /tmp/svm_first5tkrs.bash`
    `echo 'set -x' >> /tmp/svm_first5tkrs.bash`
    `echo /pt/s/rluck/svmspy/ibapi/update_di5min_stk.bash >> /tmp/svm_first5tkrs.bash`
    first5tkrs.each{|tkr| `echo /pt/s/rluck/svmspy/svmtkr.bash #{tkr} >> /tmp/svm_first5tkrs.bash`}
    `chmod +x /tmp/svm_first5tkrs.bash`
    # Look for the 1st tkr in the svm shell script:
    `grep svmtkr.bash /tmp/svm_first5tkrs.bash`.chomp.should include first5tkrs.first
    # Now run SVM against the first5tkrs.  It should take awhile, at least 2 * 60 seconds:
    time0 = Time.now
    `/tmp/svm_first5tkrs.bash > /tmp/out_of_svm_first5tkrs.txt 2>&1`
    (Time.now - time0).should > (2 * 60)
    # Now I am setup to loop through groups of tkrs while tkrs_a contains more than 4 tkrs.
    # Each group has 5 tkrs.
    while(tkrs_a.size > 4)
      p "Now inside a loop to loop through groups of 5 tkrs."
      # Save next5tkrs so I may run SVM against them.
      next5tkrs_saved = next5tkrs
      next5tkrs_saved.size.should == 5
      # Fill next5tkrs with 5 tkrs I intend to download.
      next5tkrs = []
      5.times.each{|tkr| next5tkrs << tkrs_a.pop}
      next5tkrs.size.should == 5

      # Wait if there is another download running.
      other_dl_count=`ps waux | grep 5min_data | grep -v grep|wc -l`.chomp.to_i
      while(other_dl_count > 0)
        p "Waiting 20 seconds  for other download to finish."
        sleep 20
        other_dl_count=`ps waux | grep 5min_data | grep -v grep|wc -l`.chomp.to_i
      end

      p "Now downloading:"
      p next5tkrs
      `echo '#!/bin/bash' > /tmp/dl_next5tkrs.bash`
      next5tkrs.each{|tkr| `echo /pt/s/rluck/svmspy/ibapi/5min_data.bash #{tkr} >> /tmp/dl_next5tkrs.bash`}
      `echo '#!/bin/bash' > /tmp/run_dl_next5tkrs.bash`
      `echo '/tmp/dl_next5tkrs.bash &' >> /tmp/run_dl_next5tkrs.bash`
      `chmod +x /tmp/dl_next5tkrs.bash /tmp/run_dl_next5tkrs.bash`
      p '/tmp/run_dl_next5tkrs.bash > /tmp/out_of_run_dl_next5tkrs.txt 2>&1'
      `/tmp/run_dl_next5tkrs.bash > /tmp/out_of_run_dl_next5tkrs.txt 2>&1`
      sleep 1
      `ps waux | grep /tmp/dl_next5tkrs.bash | grep -v grep`.should include "dl_next5tkrs.bash"
      p "Now running SVM on:"
      p next5tkrs_saved
      `echo '#!/bin/bash' > /tmp/svm_next5tkrs.bash`
      `echo 'set -x' >> /tmp/svm_next5tkrs.bash`
      `echo /pt/s/rluck/svmspy/ibapi/update_di5min_stk.bash >> /tmp/svm_next5tkrs.bash`
      next5tkrs_saved.each{|tkr| `echo /pt/s/rluck/svmspy/svmtkr.bash #{tkr} >> /tmp/svm_next5tkrs.bash`}
      `chmod +x /tmp/svm_next5tkrs.bash`
      # Look for the 1st tkr in the svm shell script:
      `grep svmtkr.bash /tmp/svm_next5tkrs.bash`.chomp.should include next5tkrs_saved.first
      # Now run SVM:
      p '/tmp/svm_next5tkrs.bash > /tmp/out_of_svm_next5tkrs.txt 2>&1'
      `/tmp/svm_next5tkrs.bash > /tmp/out_of_svm_next5tkrs.txt 2>&1`
    end
    # Now, I should be at the end of tkrs_a 
    tkrs_a.size.should == 4
    next5tkrs.should == ["AGU", "AFL", "AEM", "ADM", "ADBE"]
  end
##

  it "rlooper state should transition to running SVM" do
    `echo running SVM > /pt/s/rluck/svmspy/rlooper/states.txt`
    `cat /pt/s/rluck/svmspy/rlooper/states.txt`.chomp.should == "running SVM"
    next5tkrs.should == ["AGU", "AFL", "AEM", "ADM", "ADBE"]
    p "Now running SVM on:"
    p next5tkrs
    `echo '#!/bin/bash' > /tmp/svm_next5tkrs.bash`
    `echo 'set -x' >> /tmp/svm_next5tkrs.bash`
    `echo /pt/s/rluck/svmspy/ibapi/update_di5min_stk.bash >> /tmp/svm_next5tkrs.bash`
    next5tkrs.each{|tkr| `echo /pt/s/rluck/svmspy/svmtkr.bash #{tkr} >> /tmp/svm_next5tkrs.bash`}
    `chmod +x /tmp/svm_next5tkrs.bash`
    # Look for the 1st tkr in the svm shell script:
    `grep svmtkr.bash /tmp/svm_next5tkrs.bash`.chomp.should include next5tkrs.first
    # Now run SVM:
    `/tmp/svm_next5tkrs.bash > /tmp/out_of_svm_next5tkrs.txt 2>&1`
  end
##

  it "rlooper state should transition to not started yet" do
    `echo not started yet > /pt/s/rluck/svmspy/rlooper/states.txt`
    `cat /pt/s/rluck/svmspy/rlooper/states.txt`.chomp.should == "not started yet"
  end
##

end
