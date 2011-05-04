#!/bin/bash
# rspec.bash

# This script depends on an rvm gemset:
# rvm use ruby-1.9.2-head@rlooper1 --default
# or
# rvm gemset use rlooper1 --default

. /pt/s/rluck/svmspy/rlooper/.rlooper

bundle exec rspec $1

