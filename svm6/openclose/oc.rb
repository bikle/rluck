#!/usr/bin/env jruby

# oc.rb

# Demo:
# jruby oc.rb aud

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
#   - if score > 0.8
#   - This pair was last opened more than 1 hour ago
# 
# If throttle = 2 then open position:
#   - if score > 0.72
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
    p "cmd line arg count:"
    p $*.size
    if $*.size != 1
      p "You need to supply a 3 letter code."
      p "Please supply a 3 letter code for a pair: aud, eur, gbp, cad, chf, jpy, ech"
      return
    end
    # Obtain the latest SVM-score for the pairname passed in via cmd-line:
    pairname = 'aud'
    pairname = $*[0]
    p "pairname:"
    p pairname
    longscore = `sqt @latest_score4 #{pairname}|grep longscore|grep matchthis|awk '{print $2}'`
    p "latest longscore 4 #{pairname} :"
    p longscore.chomp

    # 1st assume the score is too low for me act on it:
    throttle_long = 0

    # If the score (for a long position) is high enough, decide if I want to open a position:
    if longscore.chomp.to_f > 0.7
      p "The score is high. I will now decide if I want to open a long position."
      # Find out the avg gain of this pair where score is high and score is recent:
      `cat qry_gain4recent_long_aud.sql|sed 's/aud/#{pairname}/g' >qry_gain4recent_long.sql`
      avg_gain = `sqt @qry_gain4recent_long|grep avg_g6|grep matchthis|awk '{print $2}'`
      p "avg_gain:"
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

    # Now look at and act on scores for short positions.
    # Keep in mind that this is for short positions so large NEGATIVE gains are lucrative.
    shortscore = `sqt @latest_score4 #{pairname}|grep shortscore|grep matchthis|awk '{print $2}'`
    p "latest shortscore 4 #{pairname} :"
    p shortscore.chomp

    # 1st assume the score is too low for me act on it:
    throttle_short = 0

    # If the score (for a short position) is high enough, decide if I want to open a position:

    if shortscore.chomp.to_f > 0.7
      p "The score is high. I will now decide if I want to open a short position."
      # Find out the avg gain of this pair where score is high and score is recent:
      `cat qry_gain4recent_short_aud.sql|sed 's/aud/#{pairname}/g' >qry_gain4recent_short.sql`
      avg_gain = `sqt @qry_gain4recent_short|grep avg_g6|grep matchthis|awk '{print $2}'`
      p "avg_gain:"
      p avg_gain.chomp
      # Now that I know the gain, I can set and act on a throttle_short value.
      throttle_short = 1
      case
      when(avg_gain.chomp.to_f < -0.0024)
        throttle_short = 3
      when(avg_gain.chomp.to_f < 0.0)
        throttle_short = 2
      else
        throttle_short = 1
      end # case
      p "throttle_short is now:"
      p throttle_short
    else
      p "The latest shortscore is too low for me to open a short position now."
    end # if

    # Now act on the long throttle values:

    score_floor_long = 1.0
    delay_long = 2.0
    case throttle_long
    when 0
      p "0: throttle_long is #{throttle_long}"
      score_floor_long = 1.0
      delay_long = 2.0
    when 1
      p "1: throttle_long is #{throttle_long}"
      score_floor_long = 0.8
      delay_long = (1.0/24).to_s.slice(0,5)
    when 2
      p "2: throttle_long is #{throttle_long}"
      score_floor_long = 0.72
      delay_long = (0.5/24).to_s.slice(0,5)
    when 3
      p "3: throttle_long is #{throttle_long}"
      score_floor_long = 0.70
      delay_long = (0.25/24).to_s.slice(0,5)
    end # case
    p "score_floor_long is #{score_floor_long}"
    p "delay_long is #{delay_long}"

    # Now act on the short throttle values:

    score_floor_short = 1.0
    delay_short = 2.0
    case throttle_short
    when 0
      p "0: throttle_short is #{throttle_short}"
      score_floor_short = 1.0
      delay_short = 2.0
    when 1
      p "1: throttle_short is #{throttle_short}"
      score_floor_short = 0.8
      delay_short = (1.0/24).to_s.slice(0,5)
    when 2
      p "2: throttle_short is #{throttle_short}"
      score_floor_short = 0.72
      delay_short = (0.5/24).to_s.slice(0,5)
    when 3
      p "3: throttle_short is #{throttle_short}"
      score_floor_short = 0.70
      delay_short = (0.25/24).to_s.slice(0,5)
    end # case
    p "score_floor_short is #{score_floor_short}"
    p "delay_short is #{delay_short}"

    # Now I have what I need to call oc.sql
    oc_cmd = "sqt @oc #{pairname} #{score_floor_long} #{score_floor_short} #{delay_long} #{delay_short}"
    p "oc_cmd:"
    p oc_cmd
    oc_out = `#{oc_cmd}`
    # Put oc_out in a file and cat the file:
    `rm -f /tmp/oc_out.txt`
    fhw = File.open("/tmp/oc_out.txt","w")
    fhw.write oc_out
    fhw.close
    `cat /tmp/oc_out.txt`

  end # def

end # class

# Run this class now
OpenClosePosition.opair

