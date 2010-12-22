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

