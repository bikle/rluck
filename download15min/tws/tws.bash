#!/bin/bash

# tws.bash

# I use this script to start TraderWorkStation aka TWS from IB.

. /pt/s/rluck/dl15/.orcl
. /pt/s/rluck/dl15/.jruby

set -x 

cd /pt/s/rluck/dl15/tws/

${JAVA_HOME}/bin/java -Xms100m -cp jts.jar:hsqldb.jar:jcommon-1.0.12.jar:jfreechart-1.0.9.jar:jhall.jar:other.jar:rss.jar -Xmx512M jclient.LoginFrame . &


