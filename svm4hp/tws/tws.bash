#!/bin/bash

# tws.bash

# I use this script to start TraderWorkStation aka TWS from IB.

. /pt/s/rluck/svm4hp/.orcl
. /pt/s/rluck/svm4hp/.jruby

set -x 

cd $SVM4HP
cd tws/IBJts/

${JAVA_HOME}/bin/java -Xms100m -cp jts.jar:hsqldb.jar:jcommon-1.0.12.jar:jfreechart-1.0.9.jar:jhall.jar:other.jar:rss.jar -Xmx512M jclient.LoginFrame . &


