#!/bin/bash

# shell_var_awk_var.bash

# I use this demo to show how to transfer the value of a shell variable into an awk program
# via the use of an awk variable set using the -v command line option.

export shell_var=fish

echo dog cat bird monkey $shell_var

echo dog cat bird monkey |awk '{print $1, $2, $3}'

echo dog cat bird monkey |awk -v awk_var=$shell_var '{print awk_var, $1, $2, $3}'
