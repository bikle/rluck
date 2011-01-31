#!/bin/bash
# wgetem.bash

# Use wget to download csv files full of pricing data from finance.yahoo.com

set -x

# cd to the right place
cd /pt/s/rluck/svmd/cf/

# avoid bumping into old data

rm -f *csv

# wget em


wget --output-document=HL.csv http://ichart.finance.yahoo.com/table.csv?s=HL
wget --output-document=CHK.csv http://ichart.finance.yahoo.com/table.csv?s=CHK
wget --output-document=SOHU.csv http://ichart.finance.yahoo.com/table.csv?s=SOHU
wget --output-document=RDY.csv http://ichart.finance.yahoo.com/table.csv?s=RDY
wget --output-document=CEO.csv http://ichart.finance.yahoo.com/table.csv?s=CEO
wget --output-document=AGU.csv http://ichart.finance.yahoo.com/table.csv?s=AGU

wget --output-document=SCCO.csv http://ichart.finance.yahoo.com/table.csv?s=SCCO
wget --output-document=RTP.csv http://ichart.finance.yahoo.com/table.csv?s=RTP
wget --output-document=VALE.csv http://ichart.finance.yahoo.com/table.csv?s=VALE
wget --output-document=SWC.csv http://ichart.finance.yahoo.com/table.csv?s=SWC
wget --output-document=PALL.csv http://ichart.finance.yahoo.com/table.csv?s=PALL
wget --output-document=PPLT.csv http://ichart.finance.yahoo.com/table.csv?s=PPLT
wget --output-document=SLW.csv http://ichart.finance.yahoo.com/table.csv?s=SLW 
wget --output-document=AXU.csv http://ichart.finance.yahoo.com/table.csv?s=AXU
wget --output-document=PAAS.csv http://ichart.finance.yahoo.com/table.csv?s=PAAS
wget --output-document=CDE.csv http://ichart.finance.yahoo.com/table.csv?s=CDE
wget --output-document=EXK.csv http://ichart.finance.yahoo.com/table.csv?s=EXK
wget --output-document=MVG.csv http://ichart.finance.yahoo.com/table.csv?s=MVG
wget --output-document=SVM.csv http://ichart.finance.yahoo.com/table.csv?s=SVM  
wget --output-document=TLT.csv http://ichart.finance.yahoo.com/table.csv?s=TLT
wget --output-document=EWZ.csv http://ichart.finance.yahoo.com/table.csv?s=EWZ
wget --output-document=MDY.csv http://ichart.finance.yahoo.com/table.csv?s=MDY
wget --output-document=XLB.csv http://ichart.finance.yahoo.com/table.csv?s=XLB
wget --output-document=GLD.csv http://ichart.finance.yahoo.com/table.csv?s=GLD
wget --output-document=SLV.csv http://ichart.finance.yahoo.com/table.csv?s=SLV
wget --output-document=OIH.csv http://ichart.finance.yahoo.com/table.csv?s=OIH
wget --output-document=DIA.csv http://ichart.finance.yahoo.com/table.csv?s=DIA
wget --output-document=AAPL.csv http://ichart.finance.yahoo.com/table.csv?s=AAPL  
wget --output-document=ABT.csv http://ichart.finance.yahoo.com/table.csv?s=ABT   
wget --output-document=ABX.csv http://ichart.finance.yahoo.com/table.csv?s=ABX   
wget --output-document=ADBE.csv http://ichart.finance.yahoo.com/table.csv?s=ADBE  
wget --output-document=AEM.csv http://ichart.finance.yahoo.com/table.csv?s=AEM   
wget --output-document=AFL.csv http://ichart.finance.yahoo.com/table.csv?s=AFL   
wget --output-document=AIG.csv http://ichart.finance.yahoo.com/table.csv?s=AIG   
wget --output-document=AKAM.csv http://ichart.finance.yahoo.com/table.csv?s=AKAM  
wget --output-document=ALL.csv http://ichart.finance.yahoo.com/table.csv?s=ALL   
wget --output-document=AMGN.csv http://ichart.finance.yahoo.com/table.csv?s=AMGN  
wget --output-document=AMT.csv http://ichart.finance.yahoo.com/table.csv?s=AMT   
wget --output-document=AMX.csv http://ichart.finance.yahoo.com/table.csv?s=AMX   
wget --output-document=AMZN.csv http://ichart.finance.yahoo.com/table.csv?s=AMZN  
wget --output-document=APA.csv http://ichart.finance.yahoo.com/table.csv?s=APA   
wget --output-document=APC.csv http://ichart.finance.yahoo.com/table.csv?s=APC   
wget --output-document=ARG.csv http://ichart.finance.yahoo.com/table.csv?s=ARG   
wget --output-document=AXP.csv http://ichart.finance.yahoo.com/table.csv?s=AXP   
wget --output-document=BA.csv http://ichart.finance.yahoo.com/table.csv?s=BA    
wget --output-document=BBT.csv http://ichart.finance.yahoo.com/table.csv?s=BBT   
wget --output-document=BBY.csv http://ichart.finance.yahoo.com/table.csv?s=BBY   
wget --output-document=BEN.csv http://ichart.finance.yahoo.com/table.csv?s=BEN   
wget --output-document=BHP.csv http://ichart.finance.yahoo.com/table.csv?s=BHP   
wget --output-document=BIDU.csv http://ichart.finance.yahoo.com/table.csv?s=BIDU  
wget --output-document=BP.csv http://ichart.finance.yahoo.com/table.csv?s=BP    
wget --output-document=BRCM.csv http://ichart.finance.yahoo.com/table.csv?s=BRCM  
wget --output-document=BTU.csv http://ichart.finance.yahoo.com/table.csv?s=BTU   
wget --output-document=BUCY.csv http://ichart.finance.yahoo.com/table.csv?s=BUCY  
wget --output-document=CAT.csv http://ichart.finance.yahoo.com/table.csv?s=CAT   
wget --output-document=CELG.csv http://ichart.finance.yahoo.com/table.csv?s=CELG  
wget --output-document=CLF.csv http://ichart.finance.yahoo.com/table.csv?s=CLF   
wget --output-document=CMI.csv http://ichart.finance.yahoo.com/table.csv?s=CMI   
wget --output-document=COF.csv http://ichart.finance.yahoo.com/table.csv?s=COF   
wget --output-document=COP.csv http://ichart.finance.yahoo.com/table.csv?s=COP   
wget --output-document=COST.csv http://ichart.finance.yahoo.com/table.csv?s=COST  
wget --output-document=CREE.csv http://ichart.finance.yahoo.com/table.csv?s=CREE  
wget --output-document=CRM.csv http://ichart.finance.yahoo.com/table.csv?s=CRM   
wget --output-document=CSX.csv http://ichart.finance.yahoo.com/table.csv?s=CSX   
wget --output-document=CTSH.csv http://ichart.finance.yahoo.com/table.csv?s=CTSH  
wget --output-document=CVS.csv http://ichart.finance.yahoo.com/table.csv?s=CVS   
wget --output-document=CVX.csv http://ichart.finance.yahoo.com/table.csv?s=CVX   
wget --output-document=DD.csv http://ichart.finance.yahoo.com/table.csv?s=DD    
wget --output-document=DE.csv http://ichart.finance.yahoo.com/table.csv?s=DE    
wget --output-document=DIS.csv http://ichart.finance.yahoo.com/table.csv?s=DIS   
wget --output-document=DNDN.csv http://ichart.finance.yahoo.com/table.csv?s=DNDN  
wget --output-document=DTV.csv http://ichart.finance.yahoo.com/table.csv?s=DTV   
wget --output-document=DVN.csv http://ichart.finance.yahoo.com/table.csv?s=DVN   
wget --output-document=EFA.csv http://ichart.finance.yahoo.com/table.csv?s=EFA   
wget --output-document=EOG.csv http://ichart.finance.yahoo.com/table.csv?s=EOG   
wget --output-document=ESRX.csv http://ichart.finance.yahoo.com/table.csv?s=ESRX  
wget --output-document=FCX.csv http://ichart.finance.yahoo.com/table.csv?s=FCX   
wget --output-document=FDX.csv http://ichart.finance.yahoo.com/table.csv?s=FDX   
wget --output-document=FFIV.csv http://ichart.finance.yahoo.com/table.csv?s=FFIV  
wget --output-document=FLS.csv http://ichart.finance.yahoo.com/table.csv?s=FLS   
wget --output-document=FSLR.csv http://ichart.finance.yahoo.com/table.csv?s=FSLR  
wget --output-document=GDX.csv http://ichart.finance.yahoo.com/table.csv?s=GDX   
wget --output-document=GG.csv http://ichart.finance.yahoo.com/table.csv?s=GG    
wget --output-document=GILD.csv http://ichart.finance.yahoo.com/table.csv?s=GILD  
wget --output-document=GOOG.csv http://ichart.finance.yahoo.com/table.csv?s=GOOG  
wget --output-document=GS.csv http://ichart.finance.yahoo.com/table.csv?s=GS    
wget --output-document=HD.csv http://ichart.finance.yahoo.com/table.csv?s=HD    
wget --output-document=HES.csv http://ichart.finance.yahoo.com/table.csv?s=HES   
wget --output-document=HON.csv http://ichart.finance.yahoo.com/table.csv?s=HON   
wget --output-document=HPQ.csv http://ichart.finance.yahoo.com/table.csv?s=HPQ   
wget --output-document=IBM.csv http://ichart.finance.yahoo.com/table.csv?s=IBM   
wget --output-document=IOC.csv http://ichart.finance.yahoo.com/table.csv?s=IOC   
wget --output-document=IWM.csv http://ichart.finance.yahoo.com/table.csv?s=IWM   
wget --output-document=JNJ.csv http://ichart.finance.yahoo.com/table.csv?s=JNJ   
wget --output-document=JOYG.csv http://ichart.finance.yahoo.com/table.csv?s=JOYG  
wget --output-document=JPM.csv http://ichart.finance.yahoo.com/table.csv?s=JPM   
wget --output-document=JWN.csv http://ichart.finance.yahoo.com/table.csv?s=JWN   
wget --output-document=KO.csv http://ichart.finance.yahoo.com/table.csv?s=KO    
wget --output-document=LFT.csv http://ichart.finance.yahoo.com/table.csv?s=LFT   
wget --output-document=MAR.csv http://ichart.finance.yahoo.com/table.csv?s=MAR   
wget --output-document=MCD.csv http://ichart.finance.yahoo.com/table.csv?s=MCD   
wget --output-document=MDT.csv http://ichart.finance.yahoo.com/table.csv?s=MDT   
wget --output-document=MEE.csv http://ichart.finance.yahoo.com/table.csv?s=MEE   
wget --output-document=MET.csv http://ichart.finance.yahoo.com/table.csv?s=MET   
wget --output-document=MJN.csv http://ichart.finance.yahoo.com/table.csv?s=MJN   
wget --output-document=MMM.csv http://ichart.finance.yahoo.com/table.csv?s=MMM   
wget --output-document=MON.csv http://ichart.finance.yahoo.com/table.csv?s=MON   
wget --output-document=MOS.csv http://ichart.finance.yahoo.com/table.csv?s=MOS   
wget --output-document=MRK.csv http://ichart.finance.yahoo.com/table.csv?s=MRK   
wget --output-document=MT.csv http://ichart.finance.yahoo.com/table.csv?s=MT    
wget --output-document=NEM.csv http://ichart.finance.yahoo.com/table.csv?s=NEM   
wget --output-document=NFLX.csv http://ichart.finance.yahoo.com/table.csv?s=NFLX  
wget --output-document=NUE.csv http://ichart.finance.yahoo.com/table.csv?s=NUE   
wget --output-document=OXY.csv http://ichart.finance.yahoo.com/table.csv?s=OXY   
wget --output-document=PBR.csv http://ichart.finance.yahoo.com/table.csv?s=PBR   
wget --output-document=PEP.csv http://ichart.finance.yahoo.com/table.csv?s=PEP   
wget --output-document=PG.csv http://ichart.finance.yahoo.com/table.csv?s=PG    
wget --output-document=PM.csv http://ichart.finance.yahoo.com/table.csv?s=PM    
wget --output-document=PNC.csv http://ichart.finance.yahoo.com/table.csv?s=PNC   
wget --output-document=POT.csv http://ichart.finance.yahoo.com/table.csv?s=POT   
wget --output-document=PRU.csv http://ichart.finance.yahoo.com/table.csv?s=PRU   
wget --output-document=QCOM.csv http://ichart.finance.yahoo.com/table.csv?s=QCOM  
wget --output-document=QQQQ.csv http://ichart.finance.yahoo.com/table.csv?s=QQQQ  
wget --output-document=RIG.csv http://ichart.finance.yahoo.com/table.csv?s=RIG   
wget --output-document=RIMM.csv http://ichart.finance.yahoo.com/table.csv?s=RIMM  
wget --output-document=SINA.csv http://ichart.finance.yahoo.com/table.csv?s=SINA  
wget --output-document=SJM.csv http://ichart.finance.yahoo.com/table.csv?s=SJM   
wget --output-document=SKX.csv http://ichart.finance.yahoo.com/table.csv?s=SKX   
wget --output-document=SLB.csv http://ichart.finance.yahoo.com/table.csv?s=SLB   
wget --output-document=SNDK.csv http://ichart.finance.yahoo.com/table.csv?s=SNDK  
wget --output-document=SPY.csv http://ichart.finance.yahoo.com/table.csv?s=SPY   
wget --output-document=STT.csv http://ichart.finance.yahoo.com/table.csv?s=STT   
wget --output-document=SUN.csv http://ichart.finance.yahoo.com/table.csv?s=SUN   
wget --output-document=TEVA.csv http://ichart.finance.yahoo.com/table.csv?s=TEVA  
wget --output-document=TGT.csv http://ichart.finance.yahoo.com/table.csv?s=TGT   
wget --output-document=UNH.csv http://ichart.finance.yahoo.com/table.csv?s=UNH   
wget --output-document=UNP.csv http://ichart.finance.yahoo.com/table.csv?s=UNP   
wget --output-document=UPS.csv http://ichart.finance.yahoo.com/table.csv?s=UPS   
wget --output-document=V.csv http://ichart.finance.yahoo.com/table.csv?s=V     
wget --output-document=VECO.csv http://ichart.finance.yahoo.com/table.csv?s=VECO  
wget --output-document=VMW.csv http://ichart.finance.yahoo.com/table.csv?s=VMW   
wget --output-document=WDC.csv http://ichart.finance.yahoo.com/table.csv?s=WDC   
wget --output-document=WFMI.csv http://ichart.finance.yahoo.com/table.csv?s=WFMI  
wget --output-document=WHR.csv http://ichart.finance.yahoo.com/table.csv?s=WHR   
wget --output-document=WMT.csv http://ichart.finance.yahoo.com/table.csv?s=WMT   
wget --output-document=WYNN.csv http://ichart.finance.yahoo.com/table.csv?s=WYNN  
wget --output-document=X.csv http://ichart.finance.yahoo.com/table.csv?s=X     
wget --output-document=XLE.csv http://ichart.finance.yahoo.com/table.csv?s=XLE   
wget --output-document=XLU.csv http://ichart.finance.yahoo.com/table.csv?s=XLU   
wget --output-document=XOM.csv http://ichart.finance.yahoo.com/table.csv?s=XOM   
