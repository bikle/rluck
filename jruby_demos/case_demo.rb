# case_demo.rb

# http://web.njit.edu/all_topics/Prog_Lang_Docs/html/ruby/syntax.html#case

age = 33

case age
when 0 .. 2
  "baby"
when 3 .. 6
  "little child"
when 7 .. 12
  "child"
when 12 .. 18
  # Note: 12 already matched by "child"
  "youth"
else
  "adult"
end

case
when(age >=0 and age <=2)
  p "baby"
when(age >=3 and age <=6)
  p "little child"
else
  p "child, youth, or adult"
end
