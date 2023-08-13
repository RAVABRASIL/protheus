#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"


/*-----------------------------------------------------------------------------+
 * Programa PEDVENC2    º      Eurivan Candido    º      Data ³  19/06/2007    *
 +-----------------------------------------------------------------------------+
 *Objetivo   *Emitir e-mail com relacao de Pedidos com data de faturamento     *
 *           *expirada em mais de cinco dias.                                  *
 *-----------------------------------------------------------------------------+
 * Uso       ³WorkFlow - RAVA Embalagens                                       *
 *-----------------------------------------------------------------------------+
 | Starting  |Schedule                                                         |
 +-----------------------------------------------------------------------------+*/

************************
User Function PEDVENC2()
************************

conOut( " " )
conOut( "***************************************************************************" )
conOut( "Programa de envio de Lista de Pedidos Expirados.                           " )
conOut( "***************************************************************************" )
conOut( " " )


If Select( 'SX2' ) == 0
  	RPCSetType( 3 )  //Nao consome licensa de uso
    PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "PEDVENC2" Tables "SA3", "SF2", "SA1"
   	Sleep( 5000 )  //aguarda 5 seg para que os jobs IPC subam  
   	ProcEmail()
else
   	ProcEmail()
endif

Return


***************************
Static Function ProcEmail()
***************************
local lOk := .F.
/*
cQuery := "SELECT distinct SC5.C5_NUM AS PEDIDO, SC5.C5_ENTREG AS DTFATUR, SC5.C5_EMISSAO AS EMISS, A1_COD+' - '+A1_NOME AS CLIENTE, A1_EST AS UF  "
cQuery += "FROM  SA1010 SA1, SB1010 SB1, SC5020 SC5, SC6020 SC6, SC9020 SC9 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC5.C5_CLIENTE+SC5.C5_LOJACLI = SA1.A1_COD+SA1.A1_LOJA  AND SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND  "
cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
cQuery += "SB1.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' AND SC9.D_E_L_E_T_ = ' ' "
cQuery += "order by SC5.C5_ENTREG "
*/

cQuery := "SELECT FILIAL, PEDIDO,DTFATUR,EMISS,CLIENTE,UF,INSTITUCIONAL,HAMPER,INFECTANTE,OBITO,DOMESTICA, A3_NREDUZ "
//cQuery += "REGRA=CASE WHEN INSTITUCIONAL>0 AND HOSPITALAR>0 AND DOMESTICA>0 THEN CASE WHEN  HOSPITALAR>DOMESTICA THEN 'HOSPITALAR'ELSE 'DOMESTICA' END ELSE CASE WHEN INSTITUCIONAL>0 AND HOSPITALAR>0 THEN 'HOSPITALAR'ELSE CASE WHEN INSTITUCIONAL>0 AND DOMESTICA>0 THEN 'DOMESTICA'ELSE CASE WHEN INSTITUCIONAL>0 THEN 'INSTITUCIONAL'ELSE CASE WHEN DOMESTICA>0 THEN 'DOMESTICA'ELSE CASE WHEN HOSPITALAR>0 THEN 'HOSPITALAR'ELSE 'XXXX'END END END END END END "
cQuery += "FROM( "
cQuery += "SELECT distinct SC5.C5_FILIAL AS FILIAL, SC5.C5_NUM AS PEDIDO, SC5.C5_ENTREG AS DTFATUR, SC5.C5_EMISSAO AS EMISS, A1_COD+' - '+A1_NOME AS CLIENTE, A1_EST AS UF, "
cQuery += "INSTITUCIONAL=(SELECT  ISNULL(SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV),0) FROM SC6020 SC6, SB1010 SB1 "
cQuery += "WHERE SC6.C6_NUM IN (SC5.C5_NUM) AND SB1.B1_GRUPO in('A','B','G') AND SC6.C6_PRODUTO=SB1.B1_COD AND SC6.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' "
cQuery += "), "
cQuery += "HAMPER=(SELECT  ISNULL(SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV ),0) FROM SC6020 SC6, SB1010 SB1 " 
cQuery += "WHERE SC6.C6_NUM IN (SC5.C5_NUM) AND SB1.B1_SETOR IN ('05','37','40','56') AND SC6.C6_PRODUTO=SB1.B1_COD AND SC6.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' " 
cQuery += "), " 
cQuery += "INFECTANTE=(SELECT  ISNULL(SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV ),0) FROM SC6020 SC6, SB1010 SB1 " 
cQuery += "WHERE SC6.C6_NUM IN (SC5.C5_NUM) AND SB1.B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') AND SC6.C6_PRODUTO=SB1.B1_COD AND SC6.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' " 
cQuery += "), " 
cQuery += "OBITO=(SELECT  ISNULL(SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV ),0) FROM SC6020 SC6, SB1010 SB1  "
cQuery += "WHERE SC6.C6_NUM IN (SC5.C5_NUM) AND SB1.B1_SETOR IN ('06','54','98') AND SC6.C6_PRODUTO=SB1.B1_COD AND SC6.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' " 
cQuery += "), " 
cQuery += "DOMESTICA=(SELECT  ISNULL(SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV),0) FROM SC6020 SC6, SB1010 SB1 "
cQuery += "WHERE SC6.C6_NUM IN (SC5.C5_NUM) AND SB1.B1_GRUPO in('D','E') AND SC6.C6_PRODUTO=SB1.B1_COD AND SC6.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' "
cQuery += "), A3_NREDUZ "
cQuery += "FROM  SA1010 SA1, SB1010 SB1, SC5020 SC5, SC6020 SC6, SC9020 SC9, SA3010 SA3 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND  "
cQuery += "SC5.C5_CLIENTE+SC5.C5_LOJACLI = SA1.A1_COD+SA1.A1_LOJA  AND SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND  "
cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
cQuery += "SC5.C5_VEND1 = SA3.A3_COD AND "
cQuery += "SB1.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' AND SC9.D_E_L_E_T_ = ' ' AND SA3.D_E_L_E_T_ = ' ' "
cQuery += "AND C6_FILIAL = C5_FILIAL AND C5_FILIAL = C9_FILIAL "
cQuery += ") AS TABX "
cQuery += "ORDER BY DTFATUR "


TCQUERY cQuery NEW ALIAS "TMPX"
TMPX->( DbGoTop() )

oProcess:=TWFProcess():New("PEDVEN2","Emails PV Expirados")
oProcess:NewTask('Inicio',"\workflow\http\emp01\PEDVENC2.htm")
//oProcess:NewTask('Inicio',"\workflow\http\emp01\PEDVENC.htm")
oHtml   := oProcess:oHtml
   
while !TMPX->(EOF())
   //if dDataBase - STOD( TMPX->DTFATUR ) > 5 
      lOk := .T.
      aadd( oHtml:ValByName("it.pedido") , TMPX->FILIAL+TMPX->PEDIDO )
      aadd( oHtml:ValByName("it.dtemiss"), StoD( TMPX->EMISS ) )
      aadd( oHtml:ValByName("it.dtfatur"), StoD( TMPX->DTFATUR ) )
      aadd( oHtml:ValByName("it.dias")   , Transform( dDataBase - STOD( TMPX->DTFATUR ), "@E 9999" ) )
      aadd( oHtml:ValByName("it.cliente"), Alltrim( TMPX->CLIENTE ) )
      aadd( oHtml:ValByName("it.uf"), Alltrim( TMPX->UF ) ) 
      aadd( oHtml:ValByName("it.Ins")   , Transform(TMPX->INSTITUCIONAL ,"@E 9,999,999.99") )     
      aadd( oHtml:ValByName("it.Hamp")   , Transform(TMPX->HAMPER ,"@E 9,999,999.99") )     
      aadd( oHtml:ValByName("it.Infe")   , Transform(TMPX->INFECTANTE ,"@E 9,999,999.99") )     
      aadd( oHtml:ValByName("it.Obit")   , Transform(TMPX->OBITO ,"@E 9,999,999.99") )     
      aadd( oHtml:ValByName("it.Dom")   , Transform(TMPX->DOMESTICA ,"@E 9,999,999.99") )   
//      aadd( oHtml:ValByName("it.regra") , TMPX->REGRA )  
   
      cData:=fDtFin(TMPX->PEDIDO) // data do financeiro 
      aadd( oHtml:ValByName("it.dtfin") , dtoc(stod(cData)))  
      aadd( oHtml:ValByName("it.cVend") , AllTrim(TMPX->A3_NREDUZ) )  
   //endif
   TMPX->(DbSkip())
end

TMPX->( DbCloseArea() )

if lOk
	_user := Subs(cUsuario,7,15)
	oProcess:ClientName(_user)
   //Em 03/05 Eurivan solicitou trocar o email de josenilton por rodrigo.pereira
    //oProcess:cTo := "renato.maia@ravaembalagens.com.br; marcelo@ravaembalagens.com.br; geisa@ravaembalagens.com.br;rodrigo.pereira@ravaembalagens.com.br;glennyson@ravaembalagens.com.br;marcio@ravaembalagens.com.br"
	
    oProcess:cTo := SuperGetMV("RV_PEVEN2", ,"marcelo@ravaembalagens.com.br;glennyson@ravaembalagens.com.br;giancarlo.sousa@ravaembalagens.com.br;francisco.neves@ravaembalagens.com.br")
	//oProcess:cTo := "gustavo@ravaembalagens.com.br"
	
	//oProcess:cTo := "antonio.feitosa@ravabrasil.com.br"
	subj	:= "Relação de Pedidos Expirados"
	oProcess:cSubject  := subj
	conOut( "Acesso a rotina de envio de Pedidos Expirados em: " + Dtoc( DATE() ) + ' - ' + Time() )
 	oProcess:Start()
	WfSendMail()
	Sleep( 5000 )  //aguarda 5 seg para que o e-mail seja enviado
endif	
oProcess:Finish()
alert('email ok ')
return

***************

Static Function fDtFin(cPedido)

***************

local cQry:=' '
local cRet:= " "

cQry:="select TOP 1 ZAC_DTSTAT "
cQry+="from ZAC020 ZAC "
cQry+="WHERE ZAC_PEDIDO='"+cPedido+"' "
cQry+="AND ZAC.D_E_L_E_T_=''  "
cQry+="ORDER BY ZAC_DTSTAT  "

TCQUERY cQry NEW ALIAS "AUX3"

If AUX3->(!EOF())
   
   cRet:=AUX3->ZAC_DTSTAT

EndIf

AUX3->(dbclosearea())


Return cRet
