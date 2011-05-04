#!/bin/bash

. /pt/s/rluck/svmspy/.orcl
. /pt/s/rluck/svmspy/.jruby

set -x

date

cd $SVMSPY/ibapi
./5min_data.bash  AAPL
./5min_data.bash  ABT
./5min_data.bash  ABX
./5min_data.bash  ACI
./5min_data.bash  ADBE
./5min_data.bash  AEM
./5min_data.bash  AFL
./5min_data.bash  AGU
./5min_data.bash  AIG
./5min_data.bash  AKAM
./5min_data.bash  ALL
./5min_data.bash  AMGN
./5min_data.bash  AMT
./5min_data.bash  AMX
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
(./5min_data.bash DD;./5min_data.bash DE;./5min_data.bash DIA;./5min_data.bash DIS;./5min_data.bash DNDN;./5min_data.bash DTV)&
cd ..
./svmtkr.bash  AAPL
./svmtkr.bash  ABT
./svmtkr.bash  ABX
./svmtkr.bash  ACI
./svmtkr.bash  ADBE
./svmtkr.bash  AEM
./svmtkr.bash  AFL
./svmtkr.bash  AGU
./svmtkr.bash  AIG
./svmtkr.bash  AKAM
./svmtkr.bash  ALL
./svmtkr.bash  AMGN
./svmtkr.bash  AMT
./svmtkr.bash  AMX

cd $SVMSPY/ibapi
# ./5min_data.bash  DD
# ./5min_data.bash  DE
# ./5min_data.bash  DIA
# ./5min_data.bash  DIS
# ./5min_data.bash  DNDN
# ./5min_data.bash  DTV
./5min_data.bash    DVN
./5min_data.bash    EBAY
./5min_data.bash    EFA 
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
(./5min_data.bash HPQ;./5min_data.bash HON;./5min_data.bash HOC;./5min_data.bash HL;./5min_data.bash IBM; ./5min_data.bash IOC)&
cd ..
./svmtkr.bash  DD
./svmtkr.bash  DE
./svmtkr.bash  DIA
./svmtkr.bash  DIS
./svmtkr.bash  DNDN
./svmtkr.bash  DTV
./svmtkr.bash  DVN
./svmtkr.bash  EBAY
./svmtkr.bash  EFA 

cd $SVMSPY/ibapi
# ./5min_data.bash  HPQ
# ./5min_data.bash  HON
# ./5min_data.bash  HOC
# ./5min_data.bash  HL
# ./5min_data.bash  IBM
# ./5min_data.bash  IOC
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
(./5min_data.bash IWM;./5min_data.bash JNJ;./5min_data.bash JOYG;./5min_data.bash JPM;./5min_data.bash JWN; ./5min_data.bash KO)&
cd ..
./svmtkr.bash  HPQ
./svmtkr.bash  HON
./svmtkr.bash  HOC
./svmtkr.bash  HL
./svmtkr.bash  IBM
./svmtkr.bash  IOC

cd $SVMSPY/ibapi
# ./5min_data.bash IWM 
# ./5min_data.bash JNJ   
# ./5min_data.bash JOYG 
# ./5min_data.bash JPM   
# ./5min_data.bash JWN   
# ./5min_data.bash KO    
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
(./5min_data.bash LFT;./5min_data.bash LMT;./5min_data.bash LVS;./5min_data.bash MAR;./5min_data.bash MCD; ./5min_data.bash MDT)&
cd ..
./svmtkr.bash IWM  
./svmtkr.bash JNJ        
./svmtkr.bash JOYG 
./svmtkr.bash JPM        
./svmtkr.bash JWN        
./svmtkr.bash KO         

cd $SVMSPY/ibapi
# ./5min_data.bash LFT
# ./5min_data.bash LMT  
# ./5min_data.bash LVS 
# ./5min_data.bash MAR  
# ./5min_data.bash MCD  
# ./5min_data.bash MDT  
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
(./5min_data.bash MDY;./5min_data.bash MEE;./5min_data.bash YUM;./5min_data.bash XOM;./5min_data.bash XLU; ./5min_data.bash XLE)&
cd ..
./svmtkr.bash LFT
./svmtkr.bash LMT 
./svmtkr.bash LVS 
./svmtkr.bash MAR  
./svmtkr.bash MCD  
./svmtkr.bash MDT  

cd $SVMSPY/ibapi
# ./5min_data.bash MDY
# ./5min_data.bash MEE  
# ./5min_data.bash YUM
# ./5min_data.bash XOM
# ./5min_data.bash XLU
# ./5min_data.bash XLE
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
(./5min_data.bash XLB;./5min_data.bash X;./5min_data.bash WYNN;./5min_data.bash WMT;./5min_data.bash WHR; ./5min_data.bash WFMI)&
cd ..
./svmtkr.bash MDY
./svmtkr.bash MEE 
./svmtkr.bash YUM 
./svmtkr.bash XOM  
./svmtkr.bash XLU  
./svmtkr.bash XLE  

cd $SVMSPY/ibapi
# ./5min_data.bash XLB
# ./5min_data.bash X 
# ./5min_data.bash WYNN
# ./5min_data.bash WMT
# ./5min_data.bash WHR
# ./5min_data.bash WFMI
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
(./5min_data.bash WFC;./5min_data.bash WDC;./5min_data.bash VMW;./5min_data.bash VLO)&
cd ..
./svmtkr.bash XLB 
./svmtkr.bash X    
./svmtkr.bash WYNN 
./svmtkr.bash WMT   
./svmtkr.bash WHR   
./svmtkr.bash WFMI  

cd $SVMSPY/ibapi
# ./5min_data.bash WFC
# ./5min_data.bash WDC
# ./5min_data.bash VMW
# ./5min_data.bash VLO
sqt>update_di5min_stk.txt<<EOF
@update_di5min_stk.sql
EOF
cd ..
./svmtkr.bash WFC
./svmtkr.bash WDC
./svmtkr.bash VMW
./svmtkr.bash VLO

exit 0

