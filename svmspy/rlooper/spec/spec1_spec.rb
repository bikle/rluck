#!/usr/bin/env spec

# spec1_spec.rb

# Helps me ensure that rlooper is doing the right thing.

require 'spec_helper'

describe "rlooper helps me download tkr prices and then run SVM against them" do

  it "Some files should exist" do
    dglb = Dir.glob("/pt/s/rluck/svmspy/rlooper/spec/spec1_spec.rb")
    dglb.size.should == 1
    dglb = Dir.glob("/pt/s/rluck/svmspy/rlooper/.rlooper")
    dglb.size.should == 1
    dglb = Dir.glob("/pt/s/rluck/svmspy/rlooper/bin/sqt")
    dglb.size.should == 1
  end

  it "Some tkrs should exist" do
    sqt_out = `sqt @qry_tkrs.sql`
    sqt_out.should include("IBM")
    sqt_out.should include("173 rows selected")
    # Copy the tkrs I want into a long String:
    tkrs_s = /(AAPL\n)(\w+\n)+(YUM\n)/.match(sqt_out)[0]
    # Copy the tkrs I want into an Array:
    tkrs_a = []
    tkrs_s.each_line{ |al| tkrs_a << al.chomp }
debugger
    tkrs_a.size.should == 173
  end
##
end
