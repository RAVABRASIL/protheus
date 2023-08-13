#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO3     บ Autor ณ AP6 IDE            บ Data ณ  14/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User Function FATC003()

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "FATC003" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa FATC003 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  PVMIX()
Else
  conOut( "Programa FATC003 sendo PVMIX utado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  PVMIX()
EndIf
 // conOut( "Finalizando programa FATC003 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

*************

Static Function PVMIX()

*************

Local cQry:=''
Local nSaveSX8:= GetSX8Len()
Local nCnt:=1
local lOk:=.F.
aCab   := {}
aItens := {}
cNumPV := ""

cQry:="SELECT B1_COD,B1_LENUSP,B1_EMINSP,ATUAL=SUM(B2_QATU) "
cQry+="FROM "+retSqlName("SB1")+" SB1,"+retSqlName("SB2")+" SB2  "
cQry+="WHERE  SB1.B1_COD=SB2.B2_COD "
cQry+="AND B1_ATIVO='S' "
cQry+="AND B1_EMSP='S' "
cQry+="AND LEN(B1_COD)<=7  "
cQry+="AND B2_LOCAL IN('10','09') "
cQry+="AND B1_LENUSP>0  "
cQry+="AND B1_FILIAL='"+xFilial('SB1')+"' AND B2_FILIAL='"+xFilial('SB2')+"'  "
cQry+="AND SB1.D_E_L_E_T_!='*' AND  SB2.D_E_L_E_T_!='*' "     
cQry+="GROUP BY  B1_COD,B1_LENUSP,B1_EMINSP HAVING (B1_EMINSP)<=SUM(B2_QATU)  "
cQry+="ORDER BY  B1_COD "
TCQUERY cQry NEW ALIAS "AUUX"
AUUX->( dbGoTop() )

DbSelectArea("SC5")
DbSetOrder(1)

DbSelectArea("SX5")
DbSetOrder(1)

If ! AUUX->( EoF() )
	
	If Empty(cNumPV)
       cNumPV:=GetSxeNum("SC5","C5_NUM")
       conOut( "TESTE-1")
       Do while SC5->( DbSeek( xFilial( "SC5" )+cNumPV ) )
          ConfirmSX8()
          cNumPV  := GetSxeNum("SC5","C5_NUM")
          conOut( "TESTE-1.1")
       EnDdO	    	       	   
    Endif 
	
	aCab := {{"C5_NUM"    , cNumPV  , NIL},;
             {"C5_TIPO"   , 'N'     , NIL},;
             {"C5_CLIENTE", '031248', NIL},; // MIXKIT
             {"C5_LOJACLI", '01'    , NIL},;
             {"C5_LOCALIZ", '149'   , ''},;
             {"C5_TRANSP" , '65'    , ''},;
             {"C5_MENNOTA",'REMESSA PARA ARMAZEM GERAL SAO PAULO', NIL},;                                                                                              
             {"C5_TIPOCLI", "R"     , NIL},;
             {"C5_CONDPAG", "012"   , ''},;
             {"C5_VEND1"  , "0018"  , NIL},;    
             {"C5_ENTREG" , dDataBase  , ''} }
   	conOut( "TESTE-2")
	Do While ! AUUX->( EoF() )                    
       
       If SX5->(DbSeek(xFilial("SX5")+'Z4'+ALLTRIM(AUUX->B1_COD)  ))

          Aadd(aItens, {{"C6_ITEM",StrZero(nCnt,2)       ,NIL},;
                        {"C6_PRODUTO",AUUX->B1_COD       ,NIL},;
                        {"C6_QTDVEN" ,AUUX->B1_LENUSP    ,''},;
                        {"C6_TES"    ,'540'              ,NIL},;
                        {"C6_LOCAL"  ,'01'               ,NIL},;
                        {"C6_PRUNIT" ,VAL(SX5->X5_DESCRI),NIL}})
	      nCnt+=1
	      conOut( "TESTE-3")
	   EndIf
	   conOut( "TESTE-4")
	   AUUX->(dbSkip())	
	EndDo

	if Len(aCab) > 0 .and. Len(aItens) >0 
	   conOut( "TESTE-5")
	   lMsErroAuto := .F.
	   MSExecAuto({|x,y,z| MATA410(x,y,z)}, aCab, aItens, 3)
	   conOut( "TESTE-6")
	   if lMsErroAuto
		  RollBackSX8()  	
		  //MostraErro()
	      conOut( "TESTE-7")
	   else
		  while ( GetSX8Len() > nSaveSX8 )
		    lOk:=.T.
		    ConfirmSX8()
		    conOut( "TESTE-8")
		  end	  
	      If lOk
     	     conOut( "Finalizando programa FATC003 em " + Dtoc( DATE() ) + ' - ' + Time() )
	      else
	         conOut( "PROBLEMA SX8 - Finalizando programa FATC003 em " + Dtoc( DATE() ) + ' - ' + Time() )
	      EndIf
	   endif             
	else
	   conOut( "VAZIO(aCab,aItens) - Finalizando programa FATC003 em " + Dtoc( DATE() ) + ' - ' + Time() )
	endif	
ELSE
    conOut( "VAZIO(Query) - Finalizando programa FATC003 em " + Dtoc( DATE() ) + ' - ' + Time() )
Endif

AUUX->(DbCloseArea())

Return 
