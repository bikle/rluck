#!/usr/bin/env jruby

# /pt/s/sb5/spec/svm2_spec.rb

# I use this spec to spec files in this dir: /pt/s/sb5/svm2

# Some useful constants:
PAIRS =        ['eur','aud','gbp','jpy','cad','chf']
PAIRS7 = ['abc','eur','aud','gbp','jpy','cad','chf']
SVMDIR = "/pt/s/sb5/svm2"

describe "svm2 is SVM working directory" do

  it "abc10.sql, should create a q11 view which has only 1 pair in it" do
    # Currently q11 depends on ibfu_view.
    # When I coded this up, I forgot to constrain ibfu_view.
    # q11 was filled with data from 6 pairs instead of 1.
    # The result was a cartesian product which caused this script to hang:
    # eur14.sql which is a 7 table join.
    # So, q11 needs to only have 1 pair in it.
    # I should check this reqt in 2 places:
    # - the code (here)
    # - the db (db_spec.rb)
    `grep ibfu_view /pt/s/sb5/svm2/abc10.sql|grep 'WHERE pair LIKE..abc..'|wc -l`.should == "1\n"
  end
##

  it "The eur14.sql scripts join eur_ms10 and 6 other attribute tables" do
    #  eur14.sql does a 7 table join. 1st table is eur_ms10
    PAIRS.map{|pr| `grep '^FROM #{pr}_ms10 m' #{SVMDIR}/#{pr}14.sql|wc -l`}.sort.uniq.should == ["1\n"]
    # The next 6 join tables: ,eur_att ,aud_att, ...
    PAIRS.map{|pr| PAIRS.map{|jt| `grep '^,#{jt}_att .$' #{SVMDIR}/#{pr}14.sql|wc -l`}}.flatten.sort.uniq.should == ["1\n"]
  end
##

  it "The eur14.sql scripts should create 6 x 32 goodness attributes based on SUM of eur_g4." do
    PAIRS.map{|pr| `grep '^,SUM.#{pr}_g4.' #{SVMDIR}/#{pr}14.sql|wc -l`}.sort.uniq.should == ["198\n"]
  end
##

  it "eur14.sql, should have 6 sql scripts patterned off it." do
    (esize = File.size("#{SVMDIR}/eur14.sql")).should == 24253
    PAIRS.each{|pr| File.size("#{SVMDIR}/#{pr}14.sql").should == esize}
  end
##

  it "sedem.bash should have a template which depends on the eur pair." do
    # I have a script named bld_eur14.bash which builds eur14.sql
    # It seemed difficult to create it from a template.
    # So, I built bld_eur14.bash by hand.
    # Then I use it as a template to build bash scripts for the other 5 pairs: aud, gbp, ...
    `grep template  #{SVMDIR}/bld_eur14.bash|wc -l`.should == "1\n"
    num_grep_hits = ["0\n", "0\n", "0\n", "0\n", "0\n", "1\n"]
    PAIRS.map{|pr| `grep template  #{SVMDIR}/bld_#{pr}14.bash|wc -l`}.sort.should == num_grep_hits
    # I should have no file called bld_abc14.bash
    `/bin/ls -1 /pt/s/sb5/svm2/bld_???14.bash|grep abc|wc -l`.should == "0\n"
    # But I should have 6 other bash scripts
    `/bin/ls -1 #{SVMDIR}/bld_???14.bash|wc -l`.should == "6\n"
  end
##

  it "sedem.bash should have 3 abc templates of 6 calls each." do
    # Useful shell command: grep  '^cat abc'|wc -l
    `grep '^cat abc' #{SVMDIR}/sedem.bash|wc -l`.should == "18\n"
    # Each template should reference just 6 pairs.
    # When I grep a pair from a template I should get 1 match.
    # Since I have 3 templates, I should get 3 matches for each pair.
    # Useful shell command: grep  '^cat abc' sedem.bash|grep eur|wc -l
    PAIRS.map{|pr| `grep '^cat abc' #{SVMDIR}/sedem.bash|grep #{pr}|wc -l`}.sort.uniq.should==["3\n"]
  end
##

  it "Should have 0 Oracle errors in the output txt files." do
    `grep ERROR #{SVMDIR}/*out*txt|wc -l`.should == "0\n"
    `grep ORA #{SVMDIR}/*out*txt|wc -l`.should == "0\n"
  end
##
  it "Each abc_score1day.sql has sme view which needs 2 cmd line args to form a ydate." do
    # It should look like this: 
                          # WHERE ydate = '&1'||' '||'&2'
    PAIRS7.each{|pr|`grep '^WHERE ydate = ' #{SVMDIR}/#{pr}_score1day.sql|grep 1|grep 2|wc -l`.should=="1\n"}
  end
##
  it "Each abc_score1day.sql depends on abc_ms14." do
    PAIRS7.each{|pr|`grep '^FROM #{pr}_ms14$' #{SVMDIR}/#{pr}_score1day.sql|wc -l`.should=="2\n"}
  end
##

  it "Each abc_score1day.sql should have 1 non-backtest ydate predicate." do
    # When I backtest I use a predicate in bme which looks something like this:
    # WHERE ydate+3.01 < '&1'||' '||'&2'
    # It prevents future data from slipping into the backtest.
    # When I do daily SVM-operation, the future is unknown so I have no future data to worry about.
    # So, I use a different predicate which is based on gatt rather than on ydate.
    PAIRS7.each{|pr|
      scmd = "grep '^WHERE gatt IN..nup...up..$' #{SVMDIR}/#{pr}_score1day.sql| wc -l"
      grp = `#{scmd}`
      grp.should == "1\n"
    }
  end
##

  it "Each abc_score1day.sql should have 2 gatt attributes. 1 of which is NULL" do
    PAIRS7.each{|pr|
      scmd = "grep '^,NULL gatt$' #{SVMDIR}/#{pr}_score1day.sql| wc -l"
      grp = `#{scmd}`.chomp
      grp.should == "1"
      scmd = "grep '^,gatt$' #{SVMDIR}/#{pr}_score1day.sql| wc -l"
      grp = `#{scmd}`.chomp
      grp.should == "1"
    }
  end
##

  it "each abc_score1day.sql should have 2 x 6 x 33 goodness attributes" do
    PAIRS7.each{|pr|
      scmd = "grep '^,..._g..$' #{SVMDIR}/#{pr}_score1day.sql| wc -l"
      grp = `#{scmd}`.chomp
      grp.should == (2*6*33).to_s
    }
  end
##

  it "each abc_score1day.sql should have a prdate which matches the filename" do
    # I should see 2 lines like this:
    # 'abc'||ydate prdate
    PAIRS7.map{|pr|
      grp = `grep #{pr} #{SVMDIR}/#{pr}_score1day.sql|grep ydate|grep prdate|wc -l`.chomp
      grp.should == "2"
    }
  end
##

  it "should have 7 abc_score1day.sql files and they should all be the same size" do
    glb = Dir.glob("#{SVMDIR}/???_score1day.sql").sort
    glb.should == PAIRS7.map{|pr|"#{SVMDIR}/#{pr}_score1day.sql"}.sort
    PAIRS7.map{|pr|File.size("#{SVMDIR}/#{pr}_score1day.sql")}.sort.uniq.should == [4043]
  end
##

  it "should have 6 abc10.sql files in file system which also appear in bld_run_big10.bash" do
    grp = `grep 'cat eur10.sql gbp10.sql aud10.sql jpy10.sql cad10.sql chf10.sql' #{SVMDIR}/bld_run_big10.bash`.chomp
    grp =~ /(\w\w\w10.sql) (\w\w\w10.sql) (\w\w\w10.sql) (\w\w\w10.sql) (\w\w\w10.sql) (\w\w\w10.sql)/
    md = $~
    # Look for them in the file system and ensure they all the same size
    # The file names are in md positions 1,2,... 6
    [1..6].map{|n| md[n]}.flatten.map{|pr|File.size("#{SVMDIR}/#{pr}")}.sort.uniq.should == [8031]
  end

  it "should have a big10.sql made from smaller abc10.sql files" do
    glb = Dir.glob("#{SVMDIR}/big10.sql")
    File.size(glb[0]).should > 48150
    File.size(glb[0]).should < 48160
    psize = 0
    PAIRS.each{|pr| psize += File.size("#{SVMDIR}/#{pr}10.sql")}
    psize.should == 48186
    glb2 = Dir.glob("#{SVMDIR}/bld_run_big10.bash")
    File.size(glb2[0]).should == 854
  end

  it "should have bld_eur14.bash as a template and working script" do
    glb = Dir.glob("#{SVMDIR}/bld_???14.bash").sort
    glb.should == PAIRS.map{|pr|"#{SVMDIR}/bld_#{pr}14.bash"}.sort
    ['aud','gbp','jpy','cad','chf'].map{|pr|File.size("#{SVMDIR}/bld_#{pr}14.bash")}.sort.uniq.should==[966]
    # bld_eur14.bash is a little bigger due to template comment inside.
    File.size("#{SVMDIR}/bld_eur14.bash").should == 1021
  end

  it "should have 7 abc14b.txt files" do
    glb = Dir.glob("#{SVMDIR}/???14b.txt").sort
    glb.should == PAIRS7.map{|pr|"#{SVMDIR}/#{pr}14b.txt"}.sort
    PAIRS7.map{|pr|File.size("#{SVMDIR}/#{pr}14b.txt")}.sort.uniq.should == [292]
  end
##

  it "should have 7 abc14m.txt files" do
    glb = Dir.glob("#{SVMDIR}/???14m.txt").sort
    glb.should == PAIRS.map{|pr|"#{SVMDIR}/#{pr}14m.txt"}.sort
    PAIRS.map{|pr|File.size("#{SVMDIR}/#{pr}14m.txt")}.sort.uniq.should == [23760]
  end
##

  it "should have 7 abc14t.txt files" do
    glb = Dir.glob("#{SVMDIR}/???14t.txt").sort
    glb.should == PAIRS7.map{|pr|"#{SVMDIR}/#{pr}14t.txt"}.sort
    PAIRS.map{|pr|File.size("#{SVMDIR}/#{pr}14t.txt")}.sort.uniq.should == [201]
  end
##

  it "should have 6 out2abc.txt files" do
    glb = Dir.glob("#{SVMDIR}/out2???.txt").sort
    glb.should == PAIRS.map{|pr|"#{SVMDIR}/out2#{pr}.txt"}.sort
  end
##

  it "should have 6 abc_scorem.txt files" do
    glb = Dir.glob("#{SVMDIR}/???_scorem.txt").sort
    glb.should == PAIRS.map{|pr|"#{SVMDIR}/#{pr}_scorem.txt"}.sort
  end
##

  it "should have 6 abc_scorem.sql files" do
    glb = Dir.glob("#{SVMDIR}/???_scorem.sql").sort
    ## Not any more: glb.should == PAIRS.map{|pr|"#{SVMDIR}/#{pr}_scorem.sql"}.sort
    # I dropped aud and chf. I should now have 4:
    glb.should == ["/pt/s/sb5/svm2/cad_scorem.sql", "/pt/s/sb5/svm2/eur_scorem.sql", "/pt/s/sb5/svm2/gbp_scorem.sql", "/pt/s/sb5/svm2/jpy_scorem.sql"]
  end
##

  it "should have 6 scorem out files" do
    glb = Dir.glob("#{SVMDIR}/out_of_???_scorem.txt").sort
    glb.should==PAIRS.map{|pr|"#{SVMDIR}/out_of_#{pr}_scorem.txt"}.sort
  end
##

end # describe
