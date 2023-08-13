#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"


/*-----------------------------------------------------------------------------+
 * Programa PEDVENC     º      Eurivan Candido    º      Data ³  19/06/2007    *
 +-----------------------------------------------------------------------------+
 *Objetivo   *Emitir e-mail com relacao de Pedidos com data de faturamento     *
 *           *expirada em mais de cinco dias.                                  *
 *-----------------------------------------------------------------------------+
 * Uso       ³WorkFlow - RAVA Embalagens                                       *
 *-----------------------------------------------------------------------------+
 | Starting  |Schedule                                                         |
 +-----------------------------------------------------------------------------+*/

************************
User Function CPEDVENC()
************************

conOut( " " )
conOut( "***************************************************************************" )
conOut( "Programa de envio de Lista de Pedidos Expirados.                           " )
conOut( "***************************************************************************" )
conOut( " " )


If Select( 'SX2' ) == 0

  	RPCSetType( 3 )  //Nao consome licensa de uso
    PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "cpedvenc" Tables "SA3", "SF2", "SA1"
   	Sleep( 5000 )  //aguarda 5 seg para que os jobs IPC subam
  
   	ProcEmail()
Else
	conOut( "Programa WFCTABC sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
   	ProcEmail()
endif

Return


***************************
Static Function ProcEmail()
***************************
local lOk := .F.

cQuery := "SELECT distinct SC5.C5_NUM AS PEDIDO, SC5.C5_ENTREG AS DTFATUR, SC5.C5_EMISSAO AS EMISS, A1_COD+' - '+A1_NOME AS CLIENTE  "
cQuery += "FROM  SA1010 SA1, SB1010 SB1, SC5020 SC5, SC6020 SC6, SC9020 SC9 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC5.C5_CLIENTE = SA1.A1_COD AND SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND  "
cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
cQuery += "SB1.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' AND SC9.D_E_L_E_T_ = ' ' "
cQuery += "order by SC5.C5_ENTREG "

/*
cQuery := "SELECT C5_NUM as PEDIDO, C5_ENTREG AS DTFATUR, A1_COD+' - '+A1_NOME AS CLIENTE "
cQuery += "FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SA1")+" SA1 "
cQuery += "WHERE C5_ENTREG <> '' AND "
cQuery += "C5_NOTA = '' AND "
cQuery += "CAST( '"+DTOS(dDataBase)+"' AS INTEGER ) - CAST( C5_ENTREG AS INTEGER ) > 5 AND "
cQuery += "C5_CLIENTE+C5_LOJACLI = A1_COD+A1_LOJA AND "
cQuery += "SC5.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' "
cQuery += "ORDER BY C5_ENTREG "
*/

TCQUERY cQuery NEW ALIAS "TMPX"
TMPX->( DbGoTop() )

oProcess:=TWFProcess():New("PEDVEN","Emails PV Expirados")
oProcess:NewTask('Inicio',"\workflow\http\emp01\cpedvenc.htm")
oHtml   := oProcess:oHtml
   
while !TMPX->(EOF())
   if dDataBase - STOD( TMPX->DTFATUR ) > 5 
      lOk := .T.
      aadd( oHtml:ValByName("it.pedido") , TMPX->PEDIDO )
      aadd( oHtml:ValByName("it.dtemiss"), StoD( TMPX->EMISS ) )
      aadd( oHtml:ValByName("it.dtfatur"), StoD( TMPX->DTFATUR ) )
      aadd( oHtml:ValByName("it.dias")   , Transform( dDataBase - STOD( TMPX->DTFATUR ), "@E 9999" ) )
      aadd( oHtml:ValByName("it.cliente"), Alltrim( TMPX->CLIENTE ) )
   endif
   TMPX->(DbSkip())
end

TMPX->( DbCloseArea() )

if lOk
	_user := Subs(cUsuario,7,15)
	oProcess:ClientName(_user)
//	oProcess:cTo	:= "alexandre@ravaembalagens.com.br; marcelo@ravaembalagens.com.br"
//	oProcess:cCC	:= "marcelo
	oProcess:cTo	:= "informatica@ravaembalagens.com.br"
	oProcess:cCC	:= "marcelo@ravaembalagens.com.br"
	subj	:= "Relação de Pedidos Expirados"
	oProcess:cSubject  := subj
	conOut( "Acesso a rotina de envio de Pedidos Expirados em: " + Dtoc( DATE() ) + ' - ' + Time() )
 	oProcess:Start()
	WfSendMail()
	Sleep( 5000 )  //aguarda 5 seg para que o e-mail seja enviado
endif	
oProcess:Finish()

return