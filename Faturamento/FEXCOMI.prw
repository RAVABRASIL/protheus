#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

*************

User Function FEXCOMI(cProd,cVend)

*************

local nRet:=Posicione( "SB1", 1, xFilial("SB1") + cProd, "B1_COMIS" )
                                             
IF substr(cVend,1,4) $ GetNewPar("RV_XBREP","0201/0308/0083/0127/0262")
	IF substr(cProd,1,1) $ 'A/B/G' // INST
	   nRet:= GetNewPar("RV_WREINS",3)
	ELSEIF substr(cProd,1,1) = 'C' // HOSP
	   nRet:= GetNewPar("RV_WREHOS",4) 
	ELSEIF substr(cProd,1,1) $ 'D/E' // DOME
	   nRet:= GetNewPar("RV_WREDOM",5) 
	endif
ElseIf substr(cVend,1,4) $ GetNewPar("RV_XBREP2","2826")
	nRet:= 4
ENDIF

Return nRet                        	
