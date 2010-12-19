#!/usr/bin/env jruby

# sed_rpt.rb

# I use this script to help me create other scripts to report on SVM effectiveness.

PAIRS=%w{eur aud gbp jpy cad chf}

PAIRS.each{|pair| `cat abc_rpt.sql       | sed '1,$s/abc/#{pair}/g' > #{pair}_rpt.sql`}
PAIRS.each{|pair| `cat abc_rpt_gattn.sql | sed '1,$s/abc/#{pair}/g' > #{pair}_rpt_gattn.sql`}
p "Scripts have just been generated using sed."
