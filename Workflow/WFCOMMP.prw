#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFCOMPRA  บAutor  ณEurivan Marques     บ Data ณ  05/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail com informacoes de Solicitacoes e Pedidos de   บฑฑ
ฑฑบ          ณCompras.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*************
User Function WFCOMMP()
*************

//Este programa envia o e-mail ref. a todas as SCs e PCs somente de produtos tipo = MP

conOut( " " )
conOut( "***************************************************************************" )
conOut( "Programa de envio de Lista de Solitacoes e Pedidos de Compra.              " )
conOut( "***************************************************************************" )
conOut( " " )

if Select( 'SX2' ) == 0
	RPCSetType( 3 )  //Nao consome licensa de uso
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFCOMMP" Tables "SA3", "SF2", "SA1"
	Sleep( 5000 )  //aguarda 5 seg para que os jobs IPC subam
	
	ProcEmail()
endif

return



***************
static function ProcEmail()
***************

local cQuery
local lOK := .F.
local aGrupos := {}
local _nX

cQuery := "SELECT C1_NUM, C1_EMISSAO, C1_SOLICIT, C1_ITEM, C1_PRODUTO, C1_DESCRI,  "
cQuery += "C1_PEDIDO, C1_QUANT, C1_QUANT-C1_QUJE AS SALDO, "
cQuery += "CAST( CONVERT(DATETIME,'"+Dtos(dDataBase)+"') - CONVERT(DATETIME,C1_EMISSAO) AS INTEGER ) as DIAS, "
cQuery += "CASE WHEN C1_DTAPROV <> '' THEN CAST( CONVERT(DATETIME,C1_DTAPROV) - CONVERT(DATETIME,C1_EMISSAO) AS INTEGER ) "
cQuery += "ELSE CAST( CONVERT(DATETIME,'"+Dtos(dDataBase)+"') - CONVERT(DATETIME,C1_EMISSAO) AS INTEGER ) END AS DIASAP "
cQuery += "FROM "+RetSqlName("SC1")+" SC1,"+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE C1_EMISSAO >= '20080401' "
cQuery += "AND C1_RESIDUO <> 'S' AND C1_APROV <> 'R' "
cQuery += "AND ( SELECT COUNT(*) FROM "+RetSqlName("SC1")+" C1X WHERE C1X.C1_NUM = SC1.C1_NUM AND C1X.C1_QUANT-C1X.C1_QUJE > 0 AND C1X.C1_RESIDUO <> 'S' AND C1X.C1_APROV <> 'R' AND C1X.D_E_L_E_T_ = '' ) > 0 "
cQuery += "AND C1_QUANT-C1_QUJE > 0  "
cQuery += "AND C1_ORIGEM <> 'MATA106' "
cQuery += "AND SC1.D_E_L_E_T_ = ''  "
cQuery += "AND B1_COD = C1_PRODUTO  "
cQuery += "AND B1_TIPO = 'MP'  "
cQuery += "AND B1_ATIVO!='N' "   // ativo 
cQuery += "AND LEN(B1_COD) <= 7 " 
cQuery += "AND SB1.D_E_L_E_T_ = ' '  "
cQuery += "ORDER BY C1_EMISSAO " 

    
TCQUERY cQuery NEW ALIAS "TMP1"
TMP1->( DbGoTop() )
	
cQuery := "SELECT C7_NUM,C7_EMISSAO, A2_NOME, A2_TEL,A2_CONTATO,  "
cQuery += "ISNULL( (SELECT TOP 1 C1X.C1_SOLICIT FROM "+RetSqlName("SC1")+" C1X WHERE C1_NUM = C7_NUMSC  AND C1X.D_E_L_E_T_ = ''),'S/SC' ) AS C7_SOLIC,  "
cQuery += "C7_NUMSC, C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT, "
cQuery += "CAST( CONVERT(DATETIME,'"+Dtos(dDataBase)+"') - CONVERT(DATETIME,C7_EMISSAO) AS INTEGER ) AS DIASPED, "
cQuery += "ISNULL(CAST( CONVERT(DATETIME,C7_EMISSAO) - CONVERT(DATETIME,(SELECT TOP 1 C1_EMISSAO FROM "+RetSqlName("SC1")+" C1X WHERE C1_NUM = C7_NUMSC  AND C1X.D_E_L_E_T_ = '') ) AS INTEGER ),0) AS DIASSOL, "
cQuery += "C7_QUANT-C7_QUJE AS SALDO "
cQuery += "FROM "+RetSqlName("SC7")+" SC7, "+RetSqlName("SA2")+" SA2,"+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE ( SELECT COUNT(*) FROM "+RetSqlName("SC7")+" C7X WHERE C7X.C7_NUM = SC7.C7_NUM AND C7X.C7_QUANT-C7X.C7_QUJE > 0 AND C7X.C7_RESIDUO <> 'S' AND C7X.C7_APROV <> 'R' AND C7X.D_E_L_E_T_ = '' ) > 0 "
cQuery += "AND C7_QUANT-C7_QUJE > 0 "
cQuery += "AND C7_FORNECE+C7_LOJA = A2_COD+A2_LOJA "
cQuery += "AND C7_RESIDUO <> 'S' "
cQuery += "AND C7_APROV <> 'R' " 
cQuery += "AND SC7.D_E_L_E_T_ = '' "
cQuery += "AND SA2.D_E_L_E_T_ = '' "
cQuery += "AND B1_COD = C7_PRODUTO  "
cQuery += "AND B1_TIPO = 'MP'  "
cQuery += "AND B1_ATIVO!='N'   "  // ativo
cQuery += "AND LEN(B1_COD) <= 7 " 
cQuery += "AND SB1.D_E_L_E_T_ = ' '  "
cQuery += "ORDER BY C7_NUM  "

TCQUERY cQuery NEW ALIAS "TMP2"
TMP2->( DbGoTop() )
	
oProcess:=TWFProcess():New("SOLCOMMP","Emails Solitacao MP, Pedidos de Compra MP")
oProcess:NewTask('Inicio',"\workflow\http\emp01\COMPRAMP.htm")
oHtml   := oProcess:oHtml
	
if !TMP1->(EOF())
	while !TMP1->(EOF())
		cSC := TMP1->C1_NUM
		lOk := .T.
		aadd( oHtml:ValByName("it1.num"    ), TMP1->C1_NUM )
		aadd( oHtml:ValByName("it1.emiss"  ), StoD( TMP1->C1_EMISSAO ) )
		aadd( oHtml:ValByName("it1.solicit"), iif( Alltrim(TMP1->C1_SOLICIT) == "Administra", "Automatica", Alltrim(TMP1->C1_SOLICIT) ) )
		aadd( oHtml:ValByName("it1.dias"   ), Transform( TMP1->DIAS, "@E 9999" ) )
		aadd( oHtml:ValByName("it1.it"    ), TMP1->C1_ITEM )
		aadd( oHtml:ValByName("it1.cod"   ), TMP1->C1_PRODUTO )
		aadd( oHtml:ValByName("it1.descr" ), SUBSTR(TMP1->C1_DESCRI,1,40) )
		aadd( oHtml:ValByName("it1.qtd"   ), Transform( TMP1->C1_QUANT,"@E 9,999,999.99" ) )
		aadd( oHtml:ValByName("it1.sld"   ), Transform( TMP1->SALDO,"@E 9,999,999.99" ) )
		aadd( oHtml:ValByName("it1.ped"   ), IIF(!Empty(TMP1->C1_PEDIDO), TMP1->C1_PEDIDO,"S/PC") )
		aadd( oHtml:ValByName("it1.diasap"), Transform( iif( Empty(TMP1->DIASAP),TMP1->DIAS,TMP1->DIASAP), "@E 9999" ) )
		TMP1->(DbSkip())
		while !TMP1->(EOF()) .AND. cSC == TMP1->C1_NUM
			aadd( oHtml:ValByName("it1.num"    ), " " )
			aadd( oHtml:ValByName("it1.emiss"  ), " " )
			aadd( oHtml:ValByName("it1.solicit"), " " )
			aadd( oHtml:ValByName("it1.dias"   ), " " )
			aadd( oHtml:ValByName("it1.it"    ), TMP1->C1_ITEM )
			aadd( oHtml:ValByName("it1.cod"   ), TMP1->C1_PRODUTO )
			aadd( oHtml:ValByName("it1.descr" ), SUBSTR(TMP1->C1_DESCRI,1,40) )
			aadd( oHtml:ValByName("it1.qtd"   ), Transform( TMP1->C1_QUANT,"@E 9,999,999.99" ) )
			aadd( oHtml:ValByName("it1.sld"   ), Transform( TMP1->SALDO,"@E 9,999,999.99" ) )
			aadd( oHtml:ValByName("it1.ped"   ), iif(!Empty(TMP1->C1_PEDIDO), TMP1->C1_PEDIDO,"S/PC") )
			aadd( oHtml:ValByName("it1.diasap"), Transform( iif( Empty(TMP1->DIASAP),TMP1->DIAS,TMP1->DIASAP), "@E 9999" ) )
			TMP1->(DbSkip())
		end
	end
else  	//se a query nใo trouxe nenhum resultado
	aadd( oHtml:ValByName("it1.num")    , "------" )
	aadd( oHtml:ValByName("it1.emiss")  , "------" )
	aadd( oHtml:ValByName("it1.solicit"), "------" )
	aadd( oHtml:ValByName("it1.dias")   , "------" )
	aadd( oHtml:ValByName("it1.diasap") , "------" )
endif

TMP1->( DbCloseArea() )

if !TMP2->(EOF())
	while !TMP2->(EOF())
		cPC := TMP2->C7_NUM
		aadd( oHtml:ValByName("it2.num")    , TMP2->C7_NUM )
		aadd( oHtml:ValByName("it2.emiss"  ), StoD( TMP2->C7_EMISSAO ) )
		aadd( oHtml:ValByName("it2.fornec") , Alltrim(TMP2->A2_NOME) )
		aadd( oHtml:ValByName("it2.tel")    , iif(!empty(TMP2->A2_TEL),TMP2->A2_TEL,"S/TEL" ) )
		aadd( oHtml:ValByName("it2.contat") , IIF(!EMPTY(TMP2->A2_CONTATO),TMP2->A2_CONTATO,"S/CONTATO" ) )
		aadd( oHtml:ValByName("it2.diasped"), Transform( TMP2->DIASPED, "@E 9999" ) )
		aadd( oHtml:ValByName("it2.solicit"), Alltrim(TMP2->C7_SOLIC) )
		aadd( oHtml:ValByName("it2.diasSol"), Transform( TMP2->DIASSOL , "@E 9999" ) )
		aadd( oHtml:ValByName("it2.sc")     , IIF(!EMPTY(TMP2->C7_NUMSC),TMP2->C7_NUMSC,"S/SC") )
		aadd( oHtml:ValByName("it2.it")     , Alltrim(TMP2->C7_ITEM) )
		aadd( oHtml:ValByName("it2.cod")    , Alltrim(TMP2->C7_PRODUTO) )
		aadd( oHtml:ValByName("it2.desc")   , TMP2->C7_DESCRI )
		aadd( oHtml:ValByName("it2.qtd")    , Transform( TMP2->C7_QUANT , "@E 9,999,999.99" ) )
		aadd( oHtml:ValByName("it2.sld")    , Transform( TMP2->SALDO, "@E 9,999,999.99" ) )
		//		   aadd( oHtml:ValByName("it2.diasAp") , Transform( iif( Empty(TMP2->DIASAP),TMP2->DIASSOL,TMP2->DIASAP), "@E 9999" ) )
		TMP2->(DbSkip())
		while !TMP2->(EOF()) .AND. cPC = TMP2->C7_NUM
			aadd( oHtml:ValByName("it2.num")    , "" )
			aadd( oHtml:ValByName("it2.emiss"  ), "" )
			aadd( oHtml:ValByName("it2.fornec") , "" )
			aadd( oHtml:ValByName("it2.tel")    , "" )
			aadd( oHtml:ValByName("it2.contat") , "" )
			aadd( oHtml:ValByName("it2.diasped"), "" )
			aadd( oHtml:ValByName("it2.solicit"), Alltrim(TMP2->C7_SOLIC) )
			aadd( oHtml:ValByName("it2.diasSol"), Transform( TMP2->DIASSOL , "@E 9999" ) )
			aadd( oHtml:ValByName("it2.sc")     , IIF(!EMPTY(TMP2->C7_NUMSC),TMP2->C7_NUMSC,"S/SC") )
			aadd( oHtml:ValByName("it2.it")     , Alltrim(TMP2->C7_ITEM) )
			aadd( oHtml:ValByName("it2.cod")    , Alltrim(TMP2->C7_PRODUTO) )
			aadd( oHtml:ValByName("it2.desc")   , TMP2->C7_DESCRI )
			aadd( oHtml:ValByName("it2.qtd")    , Transform( TMP2->C7_QUANT , "@E 9,999,999.99" ) )
			aadd( oHtml:ValByName("it2.sld")    , Transform( TMP2->SALDO, "@E 9,999,999.99" ) )
			//aadd( oHtml:ValByName("it2.diasAp") , Transform( iif( Empty(TMP2->DIASAP),TMP2->DIASSOL,TMP2->DIASAP), "@E 9999" ) )
			TMP2->(DbSkip())
		end
	end
else    		//se a query nใo trouxe nenhum resultado
	aadd( oHtml:ValByName("it2.num")    , "" )//  C7_NUM
	aadd( oHtml:ValByName("it2.emiss")  , "" )//  C7_EMISSAO
	aadd( oHtml:ValByName("it2.fornec") , "" )//  A2_NOME
	aadd( oHtml:ValByName("it2.tel")    , "" )//  A2_TEL
	aadd( oHtml:ValByName("it2.contat") , "" )//  A2_CONTATO
	aadd( oHtml:ValByName("it2.diasped"), "" )//  DIASPED
	aadd( oHtml:ValByName("it2.solicit"), "" )//  C7_SOLIC
	aadd( oHtml:ValByName("it2.diasSol"), "" )//  DIASSOL
	aadd( oHtml:ValByName("it2.sc")     , "" )//  C7_NUMSC
	aadd( oHtml:ValByName("it2.it")     , "" )//  C7_ITEM
	aadd( oHtml:ValByName("it2.cod")    , "" )//  C7_PRODUTO
	aadd( oHtml:ValByName("it2.desc")   , "" )//  C7_DESCRI
	aadd( oHtml:ValByName("it2.qtd")    , "" )//  C7_QUANT
	aadd( oHtml:ValByName("it2.sld")    , "" )//  SALDO
	//   aadd( oHtml:ValByName("it2.diasAp") , "" )
	
endif
TMP2->( DbCloseArea() )



_user := Subs(cUsuario,7,15)
oProcess:ClientName(_user)

oProcess:cTo := "alexandre@ravaembalagens.com.br;joao.emanuel@ravaembalagens.com.br;jorge@ravaembalagens.com.br;rodrigo.pereira@ravaembalagens.com.br;bruno@ravaembalagens.com.br"  
////Em 19/11 - Joใo Emanuel solicitou que este e-mail fosse com c๓pia para o Bruno
subj	:= "Rela็ใo de Solicita็๕es e Pedidos de Compra em andamento Materia Prima"
oProcess:cSubject  := subj
conOut( "Acesso a rotina de envio de Solic.Pedidos Compras Materia Prima em: " + Dtoc( DATE() ) + ' - ' + Time() )

oProcess:Start()
WfSendMail()
Sleep( 5000 )  //aguarda 5 seg para que o e-mail seja enviado

oProcess:Finish()


return