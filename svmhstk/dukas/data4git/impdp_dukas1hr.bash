#!/bin/bash

# impdp_dukas1hr.bash

cd /pt/s/rluck/svmhstk/

. .orcl

ls -la /oracle/app/oracle/admin/orcl/dpdump/dukas1hr_stk_2011_0106.dpdmp

impdp trade/t dumpfile=dukas1hr_stk_2011_0106.dpdmp table_exists_action=replace tables=dukas1hr_stk

exit
