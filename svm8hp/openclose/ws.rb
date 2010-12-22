# ws.rb

# Useful syntax for talking to Oracle

def ws s
  fhw = File.open("rn.sql","w")
  fhw.write "#{s};\n exit \n"
  fhw.close
end

SEL1 = "SELECT 'mydata='||"

def sout
  `sqt @rn|grep 'mydata='|grep -v SELECT`.chomp.sub(/mydata=/,'')
end
