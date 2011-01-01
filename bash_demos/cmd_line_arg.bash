#!/bin/bash

# cmd_line_arg.bash

# I use this script to demo:
## if then else fi
## -gt (greater than operator)
## $#
## $@

if [ $# -gt 0 ]
then
  echo We have cmd line args.
  echo Just:
  echo $#
  echo Cmd line args:
  echo $@
else
  echo We have no cmd line args
fi
