#!/bin/bash

# date_format.bash

# This demonstrates some ways to create useful strings from the bash date command.

# 10-12-31
date +"%y-%m-%d"

# 2010-12-31
date +"%Y-%m-%d"

# 2010-12-31 23:59:59
date +"%Y-%m-%d %T"

# Fri
date +"%a"

# Friday
date +"%A"
