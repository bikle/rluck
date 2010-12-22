#!/usr/bin/env jruby

# oc.rb

# I use this script to help me open positions.

# I usually run this script after I complete an SVM run for a specific pair.
# 
# I want this script to then inspect these pieces of information:
# 
#   - The latest SVM-score for the pair
#   - FTR: The recent gain or loss for this pair where score > 0.7
# 
# Then I want to implement this logic:
# 
# Here is some throttle logic:
# First, measure full-throttle-rate-of-return (FTR)
# If FTR is unknown or negative:
#   set throttle = 1
# If FTR is positive:
#   set throttle = 2
# If FTR is > 1 pip / hour:
#   set throttle = 3
# 
# And,
# 
# If throttle = 1 then open position:
#   - if score > 0.85 
#   - This pair was last opened more than 1 hour ago
# 
# If throttle = 2 then open position:
#   - if score > 0.75
#   - This pair was last opened more than 1/2 hour ago
# 
# If throttle = 3 then open position:
#   - if score > 0.7
#   - This pair was last opened more than 1/4 hour ago
# 

require 'rubygems' 
require 'ruby-debug'
require 'ws'

class OpenClosePosition
  def self.opair
    # Obtain the latest SVM-score for the pairname passed in via cmd-line:
    pairname = 'aud'
    pairname = $*[0]
    longscore = `sqt @latest_score4 #{pairname}|grep longscore|grep matchthis|awk '{print $2}'`
    p longscore.chomp
    # If the score is high enough, decide if I want to open a position:
    if longscore.chomp.to_f > 0.7
      p "I will decide if I want to open a position now."
    else
      p "The latest score is too low for me to open a position now."
    end # if
  end # def


end # class

# Run this class now
OpenClosePosition.opair

