#!/bin/bash

# loop_til_sat.bash

# This is a simple loop which keeps running until the calendar hits Saturday.

the_day=`date +"%A"`
while [ $the_day != 'Saturday' ]
do
  echo hello
  the_day=`date +"%A"`
  echo Today is $the_day
  ./loop_once.bash
  sleep 2
done

  