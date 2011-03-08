#!/bin/bash

# sqlloadem.bash

. /pt/s/rluck/svmd/.orcl

set -x

cd /pt/s/rluck/svmd/cf/


cat TLT.csv | awk  '{print "TLT,"$0}' | grep 0 > ystk_stage.csv

cat HL.csv | awk  '{print "HL,"$0}' | grep 0 >>ystk_stage.csv

cat ORCL.csv | awk  '{print "ORCL,"$0}' | grep 0 >>ystk_stage.csv

cat HOC.csv | awk  '{print "HOC,"$0}' | grep 0 >>ystk_stage.csv

cat TKR.csv | awk  '{print "TKR,"$0}' | grep 0 >>ystk_stage.csv

cat SU.csv | awk  '{print "SU,"$0}' | grep 0 >>ystk_stage.csv
cat CVE.csv | awk  '{print "CVE,"$0}' | grep 0 >>ystk_stage.csv
cat VLO.csv | awk  '{print "VLO,"$0}' | grep 0 >>ystk_stage.csv
cat TSO.csv | awk  '{print "TSO,"$0}' | grep 0 >>ystk_stage.csv

cat GD.csv | awk  '{print "GD,"$0}' | grep 0 >>ystk_stage.csv
cat RTN.csv | awk  '{print "RTN,"$0}' | grep 0 >>ystk_stage.csv
cat NOC.csv | awk  '{print "NOC,"$0}' | grep 0 >>ystk_stage.csv
cat LMT.csv | awk  '{print "LMT,"$0}' | grep 0 >>ystk_stage.csv
cat GFI.csv | awk  '{print "GFI,"$0}' | grep 0 >>ystk_stage.csv
cat CHK.csv | awk  '{print "CHK,"$0}' | grep 0 >>ystk_stage.csv
cat SOHU.csv | awk  '{print "SOHU,"$0}' | grep 0 >>ystk_stage.csv
cat RDY.csv | awk  '{print "RDY,"$0}' | grep 0 >>ystk_stage.csv
cat CEO.csv | awk  '{print "CEO,"$0}' | grep 0 >>ystk_stage.csv
cat AGU.csv | awk  '{print "AGU,"$0}' | grep 0 >>ystk_stage.csv
cat SCCO.csv | awk  '{print "SCCO,"$0}' | grep 0 >>ystk_stage.csv
cat RTP.csv | awk  '{print "RTP,"$0}' | grep 0 >>ystk_stage.csv
cat VALE.csv | awk  '{print "VALE,"$0}' | grep 0 >>ystk_stage.csv
cat EBAY.csv | awk  '{print "EBAY,"$0}' | grep 0 >>ystk_stage.csv
cat SWC.csv | awk  '{print "SWC,"$0}' | grep 0 >>ystk_stage.csv
cat SLW.csv | awk  '{print "SLW,"$0}' | grep 0 >>ystk_stage.csv
cat AXU.csv | awk  '{print "AXU,"$0}' | grep 0 >>ystk_stage.csv
cat PAAS.csv | awk  '{print "PAAS,"$0}' | grep 0 >>ystk_stage.csv
cat CDE.csv | awk  '{print "CDE,"$0}' | grep 0 >>ystk_stage.csv
cat EXK.csv | awk  '{print "EXK,"$0}' | grep 0 >>ystk_stage.csv
cat MVG.csv | awk  '{print "MVG,"$0}' | grep 0 >>ystk_stage.csv
cat SVM.csv | awk  '{print "SVM,"$0}' | grep 0 >>ystk_stage.csv
cat PALL.csv | awk  '{print "PALL,"$0}' | grep 0 >>ystk_stage.csv
cat PPLT.csv | awk  '{print "PPLT,"$0}' | grep 0 >>ystk_stage.csv
cat MDY.csv | awk  '{print "MDY,"$0}' | grep 0 >>ystk_stage.csv
cat XLB.csv | awk  '{print "XLB,"$0}' | grep 0 >>ystk_stage.csv
cat EWZ.csv | awk  '{print "EWZ,"$0}' | grep 0 >>ystk_stage.csv
cat GLD.csv    | awk  '{print "GLD,"$0}' | grep 0 >>ystk_stage.csv
cat SLV.csv    | awk  '{print "SLV,"$0}' | grep 0 >>ystk_stage.csv
cat OIH.csv    | awk  '{print "OIH,"$0}' | grep 0 >>ystk_stage.csv
cat DIA.csv    | awk  '{print "DIA,"$0}' | grep 0 >>ystk_stage.csv
cat AAPL.csv   | awk  '{print "AAPL,"$0}' | grep 0 >>ystk_stage.csv
cat ABT.csv    | awk  '{print "ABT,"$0}' | grep 0 >>ystk_stage.csv
cat ABX.csv    | awk  '{print "ABX,"$0}' | grep 0 >>ystk_stage.csv
cat ADBE.csv   | awk  '{print "ADBE,"$0}' | grep 0 >>ystk_stage.csv
cat AEM.csv    | awk  '{print "AEM,"$0}' | grep 0 >>ystk_stage.csv
cat AFL.csv    | awk  '{print "AFL,"$0}' | grep 0 >>ystk_stage.csv
cat AIG.csv    | awk  '{print "AIG,"$0}' | grep 0 >>ystk_stage.csv
cat AKAM.csv   | awk  '{print "AKAM,"$0}' | grep 0 >>ystk_stage.csv
cat ALL.csv    | awk  '{print "ALL,"$0}' | grep 0 >>ystk_stage.csv
cat AMGN.csv   | awk  '{print "AMGN,"$0}' | grep 0 >>ystk_stage.csv
cat AMT.csv    | awk  '{print "AMT,"$0}' | grep 0 >>ystk_stage.csv
cat AMX.csv    | awk  '{print "AMX,"$0}' | grep 0 >>ystk_stage.csv
cat AMZN.csv   | awk  '{print "AMZN,"$0}' | grep 0 >>ystk_stage.csv
cat APA.csv    | awk  '{print "APA,"$0}' | grep 0 >>ystk_stage.csv
cat APC.csv    | awk  '{print "APC,"$0}' | grep 0 >>ystk_stage.csv
cat ARG.csv    | awk  '{print "ARG,"$0}' | grep 0 >>ystk_stage.csv
cat AXP.csv    | awk  '{print "AXP,"$0}' | grep 0 >>ystk_stage.csv
cat BA.csv     | awk  '{print "BA,"$0}' | grep 0 >>ystk_stage.csv
cat BBT.csv    | awk  '{print "BBT,"$0}' | grep 0 >>ystk_stage.csv
cat BBY.csv    | awk  '{print "BBY,"$0}' | grep 0 >>ystk_stage.csv
cat BEN.csv    | awk  '{print "BEN,"$0}' | grep 0 >>ystk_stage.csv
cat BHP.csv    | awk  '{print "BHP,"$0}' | grep 0 >>ystk_stage.csv
cat BIDU.csv   | awk  '{print "BIDU,"$0}' | grep 0 >>ystk_stage.csv
cat BP.csv     | awk  '{print "BP,"$0}' | grep 0 >>ystk_stage.csv
cat BRCM.csv   | awk  '{print "BRCM,"$0}' | grep 0 >>ystk_stage.csv
cat BTU.csv    | awk  '{print "BTU,"$0}' | grep 0 >>ystk_stage.csv
cat BUCY.csv   | awk  '{print "BUCY,"$0}' | grep 0 >>ystk_stage.csv
cat CAT.csv    | awk  '{print "CAT,"$0}' | grep 0 >>ystk_stage.csv
cat CELG.csv   | awk  '{print "CELG,"$0}' | grep 0 >>ystk_stage.csv
cat CLF.csv    | awk  '{print "CLF,"$0}' | grep 0 >>ystk_stage.csv
cat CMI.csv    | awk  '{print "CMI,"$0}' | grep 0 >>ystk_stage.csv
cat COF.csv    | awk  '{print "COF,"$0}' | grep 0 >>ystk_stage.csv
cat COP.csv    | awk  '{print "COP,"$0}' | grep 0 >>ystk_stage.csv
cat COST.csv   | awk  '{print "COST,"$0}' | grep 0 >>ystk_stage.csv
cat CREE.csv   | awk  '{print "CREE,"$0}' | grep 0 >>ystk_stage.csv
cat CRM.csv    | awk  '{print "CRM,"$0}' | grep 0 >>ystk_stage.csv
cat CSX.csv    | awk  '{print "CSX,"$0}' | grep 0 >>ystk_stage.csv
cat CTSH.csv   | awk  '{print "CTSH,"$0}' | grep 0 >>ystk_stage.csv
cat CVS.csv    | awk  '{print "CVS,"$0}' | grep 0 >>ystk_stage.csv
cat CVX.csv    | awk  '{print "CVX,"$0}' | grep 0 >>ystk_stage.csv
cat DD.csv     | awk  '{print "DD,"$0}' | grep 0 >>ystk_stage.csv
cat DE.csv     | awk  '{print "DE,"$0}' | grep 0 >>ystk_stage.csv
cat DIS.csv    | awk  '{print "DIS,"$0}' | grep 0 >>ystk_stage.csv
cat DNDN.csv   | awk  '{print "DNDN,"$0}' | grep 0 >>ystk_stage.csv
cat DTV.csv    | awk  '{print "DTV,"$0}' | grep 0 >>ystk_stage.csv
cat DVN.csv    | awk  '{print "DVN,"$0}' | grep 0 >>ystk_stage.csv
cat EFA.csv    | awk  '{print "EFA,"$0}' | grep 0 >>ystk_stage.csv
cat EOG.csv    | awk  '{print "EOG,"$0}' | grep 0 >>ystk_stage.csv
cat ESRX.csv   | awk  '{print "ESRX,"$0}' | grep 0 >>ystk_stage.csv
cat FCX.csv    | awk  '{print "FCX,"$0}' | grep 0 >>ystk_stage.csv
cat FDX.csv    | awk  '{print "FDX,"$0}' | grep 0 >>ystk_stage.csv
cat FFIV.csv   | awk  '{print "FFIV,"$0}' | grep 0 >>ystk_stage.csv
cat FLS.csv    | awk  '{print "FLS,"$0}' | grep 0 >>ystk_stage.csv
cat FSLR.csv   | awk  '{print "FSLR,"$0}' | grep 0 >>ystk_stage.csv
cat GDX.csv    | awk  '{print "GDX,"$0}' | grep 0 >>ystk_stage.csv
cat GG.csv     | awk  '{print "GG,"$0}' | grep 0 >>ystk_stage.csv
cat GILD.csv   | awk  '{print "GILD,"$0}' | grep 0 >>ystk_stage.csv
cat GOOG.csv   | awk  '{print "GOOG,"$0}' | grep 0 >>ystk_stage.csv
cat GS.csv     | awk  '{print "GS,"$0}' | grep 0 >>ystk_stage.csv
cat HD.csv     | awk  '{print "HD,"$0}' | grep 0 >>ystk_stage.csv
cat HES.csv    | awk  '{print "HES,"$0}' | grep 0 >>ystk_stage.csv
cat HON.csv    | awk  '{print "HON,"$0}' | grep 0 >>ystk_stage.csv
cat HPQ.csv    | awk  '{print "HPQ,"$0}' | grep 0 >>ystk_stage.csv
cat IBM.csv    | awk  '{print "IBM,"$0}' | grep 0 >>ystk_stage.csv
cat IOC.csv    | awk  '{print "IOC,"$0}' | grep 0 >>ystk_stage.csv
cat IWM.csv    | awk  '{print "IWM,"$0}' | grep 0 >>ystk_stage.csv
cat JNJ.csv    | awk  '{print "JNJ,"$0}' | grep 0 >>ystk_stage.csv
cat JOYG.csv   | awk  '{print "JOYG,"$0}' | grep 0 >>ystk_stage.csv
cat JPM.csv    | awk  '{print "JPM,"$0}' | grep 0 >>ystk_stage.csv
cat JWN.csv    | awk  '{print "JWN,"$0}' | grep 0 >>ystk_stage.csv
cat KO.csv     | awk  '{print "KO,"$0}' | grep 0 >>ystk_stage.csv
cat LFT.csv    | awk  '{print "LFT,"$0}' | grep 0 >>ystk_stage.csv
cat MAR.csv    | awk  '{print "MAR,"$0}' | grep 0 >>ystk_stage.csv
cat MCD.csv    | awk  '{print "MCD,"$0}' | grep 0 >>ystk_stage.csv
cat MDT.csv    | awk  '{print "MDT,"$0}' | grep 0 >>ystk_stage.csv
cat MEE.csv    | awk  '{print "MEE,"$0}' | grep 0 >>ystk_stage.csv
cat MET.csv    | awk  '{print "MET,"$0}' | grep 0 >>ystk_stage.csv
cat MJN.csv    | awk  '{print "MJN,"$0}' | grep 0 >>ystk_stage.csv
cat MMM.csv    | awk  '{print "MMM,"$0}' | grep 0 >>ystk_stage.csv
cat MON.csv    | awk  '{print "MON,"$0}' | grep 0 >>ystk_stage.csv
cat MOS.csv    | awk  '{print "MOS,"$0}' | grep 0 >>ystk_stage.csv
cat MRK.csv    | awk  '{print "MRK,"$0}' | grep 0 >>ystk_stage.csv
cat MT.csv     | awk  '{print "MT,"$0}' | grep 0 >>ystk_stage.csv
cat NEM.csv    | awk  '{print "NEM,"$0}' | grep 0 >>ystk_stage.csv
cat NFLX.csv   | awk  '{print "NFLX,"$0}' | grep 0 >>ystk_stage.csv
cat NUE.csv    | awk  '{print "NUE,"$0}' | grep 0 >>ystk_stage.csv
cat OXY.csv    | awk  '{print "OXY,"$0}' | grep 0 >>ystk_stage.csv
cat PBR.csv    | awk  '{print "PBR,"$0}' | grep 0 >>ystk_stage.csv
cat PEP.csv    | awk  '{print "PEP,"$0}' | grep 0 >>ystk_stage.csv
cat PG.csv     | awk  '{print "PG,"$0}' | grep 0 >>ystk_stage.csv
cat PM.csv     | awk  '{print "PM,"$0}' | grep 0 >>ystk_stage.csv
cat PNC.csv    | awk  '{print "PNC,"$0}' | grep 0 >>ystk_stage.csv
cat POT.csv    | awk  '{print "POT,"$0}' | grep 0 >>ystk_stage.csv
cat PRU.csv    | awk  '{print "PRU,"$0}' | grep 0 >>ystk_stage.csv
cat QCOM.csv   | awk  '{print "QCOM,"$0}' | grep 0 >>ystk_stage.csv
cat QQQQ.csv   | awk  '{print "QQQQ,"$0}' | grep 0 >>ystk_stage.csv
cat RIG.csv    | awk  '{print "RIG,"$0}' | grep 0 >>ystk_stage.csv
cat RIMM.csv   | awk  '{print "RIMM,"$0}' | grep 0 >>ystk_stage.csv
cat SINA.csv   | awk  '{print "SINA,"$0}' | grep 0 >>ystk_stage.csv
cat SJM.csv    | awk  '{print "SJM,"$0}' | grep 0 >>ystk_stage.csv
cat SKX.csv    | awk  '{print "SKX,"$0}' | grep 0 >>ystk_stage.csv
cat SLB.csv    | awk  '{print "SLB,"$0}' | grep 0 >>ystk_stage.csv
cat SNDK.csv   | awk  '{print "SNDK,"$0}' | grep 0 >>ystk_stage.csv
cat SPY.csv    | awk  '{print "SPY,"$0}' | grep 0 >>ystk_stage.csv
cat STT.csv    | awk  '{print "STT,"$0}' | grep 0 >>ystk_stage.csv
cat SUN.csv    | awk  '{print "SUN,"$0}' | grep 0 >>ystk_stage.csv
cat TEVA.csv   | awk  '{print "TEVA,"$0}' | grep 0 >>ystk_stage.csv
cat TGT.csv    | awk  '{print "TGT,"$0}' | grep 0 >>ystk_stage.csv
cat UNH.csv    | awk  '{print "UNH,"$0}' | grep 0 >>ystk_stage.csv
cat UNP.csv    | awk  '{print "UNP,"$0}' | grep 0 >>ystk_stage.csv
cat UPS.csv    | awk  '{print "UPS,"$0}' | grep 0 >>ystk_stage.csv
cat V.csv      | awk  '{print "V,"$0}' | grep 0 >>ystk_stage.csv
cat VECO.csv   | awk  '{print "VECO,"$0}' | grep 0 >>ystk_stage.csv
cat VMW.csv    | awk  '{print "VMW,"$0}' | grep 0 >>ystk_stage.csv
cat WDC.csv    | awk  '{print "WDC,"$0}' | grep 0 >>ystk_stage.csv
cat WFMI.csv   | awk  '{print "WFMI,"$0}' | grep 0 >>ystk_stage.csv
cat WHR.csv    | awk  '{print "WHR,"$0}' | grep 0 >>ystk_stage.csv
cat WMT.csv    | awk  '{print "WMT,"$0}' | grep 0 >>ystk_stage.csv
cat WYNN.csv   | awk  '{print "WYNN,"$0}' | grep 0 >>ystk_stage.csv
cat X.csv      | awk  '{print "X,"$0}' | grep 0 >>ystk_stage.csv
cat XLE.csv    | awk  '{print "XLE,"$0}' | grep 0 >>ystk_stage.csv
cat XLU.csv    | awk  '{print "XLU,"$0}' | grep 0 >>ystk_stage.csv
cat XOM.csv    | awk  '{print "XOM,"$0}' | grep 0 >>ystk_stage.csv

## use a soft link instead of this: cp ystk_stage.csv ..

cd ..
rm -f ystk_stage.csv
ln -s cf/ystk_stage.csv .

# sqt>cr_ystk_stage.txt <<EOF
# -- @cr_ystk_stage.sql
# EOF

sqlldr trade/t bindsize=20971520 readsize=20971520 rows=123456 control=ystk_stage.ctl
grep loaded ystk_stage.log

# Report and merge with ystk
sqt>merge.txt<<EOF
@merge.sql
EOF

# Create ystk21 which has a more accurate ydate:
sqt>merge.txt<<EOF
@cr_ystk21.sql
EOF


exit

