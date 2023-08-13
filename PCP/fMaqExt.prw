#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"



***************

User Function fMaqExt(cMaq)

***************

local cQry:=''
local lret:=.F.


if substr(cMaq,1,1)='e'
   alert('favor digitar a Extrusora com Letra Maiúscula')
   Return .F.
endif

cQry:="SELECT H1_CODIGO MAQUINA FROM "+ RetSqlName( "SH1" ) +" SH1 "
cQry+="WHERE  H1_FILIAL='"+xfilial('SH1')+"' "
cQry+="AND H1_CODIGO='"+alltrim(cMaq)+"'  "
cQry+="AND H1_CODIGO LIKE '[E][0123456789]%'  "
cQry+="AND SH1.D_E_L_E_T_!='*' "

If Select("AUXX") > 0
	DbSelectArea("AUXX")
	AUXX->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS "AUXX"

IF AUXX->(!EOF())

   lret:=.T.

ELSE
   
   IF SUBSTR(cMaq,1,1)='E'
      
      ALERT('Essa Extrusora '+alltrim(cMaq)+' não esta cadastrada no Sistema.')   
   
   ELSE
   
      ALERT('A Maquina Digitada '+alltrim(cMaq)+' Não é uma Extrusora.')
   
   ENDIF
   
ENDIF

AUXX->(DBCLOSEAREA())

Return lret 
