#!/usr/bin/env jruby

# oc.rb

# I use this script to help me open positions.

# I usually run this script after I complete an SVM run for a specific pair.
# 
# I want this script to then inspect these pieces of information:
# 
#   - The latest SVM-score (or just "score") for the pair
#   - FTR: The recent gain or loss for this pair where score > 0.7
# 
# Then I want to implement some logic.
# 
# Here is some logic to set throttle value:
# If score is < 0.7
#   set throttle = 0
# If score is > 0.7 and
# If FTR is unknown or negative:
#   set throttle = 1
# If FTR is positive:
#   set throttle = 2
# If FTR is > 1 pip / hour:
#   set throttle = 3
# 
# And, here is some logic to act on a throttle value:
# 
# If throttle = 0, do nothing
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
    p $*.size
    if $*.size != 1
      p "You need to supply a 3 letter code."
      p "Please supply a 3 letter code for a pair: aud, eur, gbp, cad, chf, jpy, ech"
      return
    end
    # Obtain the latest SVM-score for the pairname passed in via cmd-line:
    pairname = 'aud'
    pairname = $*[0]
    longscore = `sqt @latest_score4 #{pairname}|grep longscore|grep matchthis|awk '{print $2}'`
    p longscore.chomp

    # 1st assume the score is too low for me act on it:
    throttle_long = 0

    # If the score is high enough, decide if I want to open a position:
    if longscore.chomp.to_f > 0.5
      p "The score is high. I will now decide if I want to open a long position."
      # Find out the avg gain of this pair where score is high and score is recent:
      `cat qry_gain4recent_long_aud.sql|sed 's/aud/#{pairname}/g' >qry_gain4recent_long.sql`
      avg_gain = `sqt @qry_gain4recent_long|grep avg_g8|grep matchthis|awk '{print $2}'`
      p avg_gain.chomp
      # Now that I know the gain, I can set and act on a throttle_long value:
      throttle_long = 1
      case
      when(avg_gain.chomp.to_f > 0.0024)
        throttle_long = 3
      when(avg_gain.chomp.to_f > 0.0)
        throttle_long = 2
      else
        throttle_long = 1
      end # case
      p "throttle_long is now:"
      p throttle_long
    else
      p "The latest longscore is too low for me to open a long position now."
    end # if
  end # def


end # class

# Run this class now
OpenClosePosition.opair

