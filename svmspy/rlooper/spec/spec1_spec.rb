#!/usr/bin/env spec

# spec1_spec.rb

# Helps me ensure that rlooper is doing the right thing.

describe "sb5.bash helps me scan for buys" do

  it "/pt/s/rluck/svmspy/rlooper/spec/spec1_spec.rb should exist" do

    dglb = Dir.glob("/pt/s/rluck/svmspy/rlooper/spec/spec1_spec.rb")
    dglb.size.should == 1

  end
##
end
