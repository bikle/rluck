#!/usr/bin/env jruby

# sedem.rb

# This replaces sedem.bash
# It uses sed to create other scripts.

## PAIRS=%w{eur aud gbp jpy cad chf}
PAIRS=%w{eur aud}

# abc_svm.bash
PAIRS.each{|pair| `cat abc_svm.bash | sed 's/abc/#{pair}/g' > #{pair}_svm.bash`}

# In the calls below I rely on bld_eur6.bash to be the template.
(PAIRS-['eur']).each{|pair| `grep -v template bld_eur6.bash|sed 's/eur/#{pair}/'|sed 's/eur6/#{pair}6/g'>bld_#{pair}6.bash`}

# abc_build_scorem.sql
PAIRS.each{|pair| `cat abc_build_scorem.sql | sed 's/abc/#{pair}/g' > #{pair}_build_scorem.sql`}

# abc_score1day.sql
PAIRS.each{|pair| `cat abc_score1day.sql | sed 's/abc/#{pair}/g' > #{pair}_score1day.sql`}

# abc_score1day_gattn.sql
PAIRS.each{|pair| `cat abc_score1day_gattn.sql | sed 's/abc/#{pair}/g' > #{pair}_score1day_gattn.sql`}
