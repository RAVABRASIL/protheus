#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFCOMPRA  ºAutor  ³Eurivan Marques     º Data ³  05/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia e-mail com informacoes de Solicitacoes e Pedidos de   º±±
±±º          ³Compras.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

************************
User Function WFCOMPRA()
************************

//Este programa envia o e-mail ref. a todas as SCs e PCs
conOut( " " )
conOut( "***************************************************************************" )
conOut( "Programa de envio de Lista de Solitacoes e Pedidos de Compra.              " )
conOut( "***************************************************************************" )
conOut( " " )                         

if Select( 'SX2' ) == 0
	RPCSetType( 3 )  //Nao consome licensa de uso
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFCOMPRA" Tables "SA3", "SF2", "SA1"
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
local cRHEMAIL := ""
local x := 0
Local cGRP_LOG := ""  //grupo da logística e PCP
Local cGRP_RH  := ""  // grupo do RH
Local cGRP_ADM := ""  // grupo da Administração

//logística e pcp
cGRP_LOG := "compras@ravaembalagens.com.br"
cGRP_LOG += ";regina@ravaembalagens.com.br"
cGRP_LOG += ";almoxarifado@ravaembalagens.com.br"
cGRP_LOG += ";logistica@ravaembalagens.com.br"
cGRP_LOG += ";joao.emanuel@ravaembalagens.com.br"
cGRP_LOG += ";erickson@ravaembalagens.com.br"
cGRP_LOG += ";informatica@ravaembalagens.com.br" //FR - retirar depois q verificar que ficou ok

//rh
cGRP_RH := "rh@ravaembalagens.com.br"
cGRP_RH += ";aline.farias@ravaembalagens.com.br"
cGRP_RH += ";manoel.neto@ravaembalagens.com.br"                                                 
cGRP_RH += ";informatica@ravaembalagens.com.br" //FR - retirar depois q verificar que ficou ok

//adm -> estava antes o email de Miranildo, então substituí pelo de Rodrigo
cGRP_ADM := ""  //"humberto@ravaembalagens.com.br"
cGRP_ADM += ";informatica@ravaembalagens.com.br" //FR - retirar depois q verificar que ficou ok


Aadd(aGrupos, {1," <> '' ", cGRP_LOG })
Aadd(aGrupos, {1," IN ('Humberto' , 'Regineide', 'manoel.net', 'Aline.Fari') ", cGRP_RH })
Aadd(aGrupos, {1," IN ('Administra','Jorge','Alcir','Fabiano','Sebastiao','Izidro','Rubenaldo','Jonas') ","jorge@ravaembalagens.com.br" })
Aadd(aGrupos, {1," IN ('Administra','Marcelo Santos','Thallison','Izidro','Alcir','Mailson','Richard','Felipe.Santos','Jonas','Francisco Assis', 'Welton Soares','Rubenaldo','Diego Jose','Sebastiao','Aderildo Soares') ",cGRP_ADM })
Aadd(aGrupos, {2," IN ('GG','MA','ML','MV','RL','RM','SG','TR','VE') ","regineide.neves@ravaembalagens.com.br" })

for _nX := 1 to Len( aGrupos )

	cQuery := "SELECT  "
	cQuery += "CASE WHEN C1_RESIDUO!='' THEN 'SC Eliminada por Residuo' ELSE "
    cQuery += "CASE WHEN C1_QUJE=0 And C1_COTACAO='' And RTRIM(C1_APROV) = 'L' THEN 'SC Pendente' ELSE  "
    cQuery += "CASE WHEN C1_QUJE=0 And (C1_COTACAO='' Or C1_COTACAO='IMPORT')And C1_APROV='R'THEN 'SC Rejeitada' ELSE  "
    cQuery += "CASE WHEN C1_QUJE=0 And (C1_COTACAO='' Or C1_COTACAO='IMPORT')And C1_APROV='B' THEN 'SC Bloqueada' ELSE  "
    cQuery += "CASE WHEN C1_QUJE=C1_QUANT THEN'SC Totalmente Atendida' ELSE "
    cQuery += "CASE WHEN C1_QUJE>0 THEN 'SC Parcialmente Atendida' ELSE "
    cQuery += "CASE WHEN C1_QUJE=0 And C1_COTACAO<>'' And C1_IMPORT <>'S'THEN 'SC em Processo de Cotacao' ELSE  "
    cQuery += "CASE WHEN C1_QUJE=0 And C1_COTACAO<>'' And C1_IMPORT ='S' And C1_APROV IN('L') THEN'SC com Produto Importado' "
    cQuery += "END END END END END END END END LEGENDA  "
	cQuery += ",C1_NUM, C1_EMISSAO, C1_SOLICIT, C1_ITEM, C1_PRODUTO, C1_DESCRI, C1_PEDIDO, C1_QUANT, "
	cQuery += "C1_QUANT-C1_QUJE AS SALDO,"
	cQuery += "CAST( CONVERT(DATETIME,'"+Dtos(dDataBase)+"') - CONVERT(DATETIME,C1_EMISSAO) AS INTEGER ) as DIAS, "
	cQuery += "CASE WHEN C1_DTAPROV <> '' THEN CAST( CONVERT(DATETIME,C1_DTAPROV) - CONVERT(DATETIME,C1_EMISSAO) AS INTEGER ) ELSE CAST( CONVERT(DATETIME,'"+Dtos(dDataBase)+"') - CONVERT(DATETIME,C1_EMISSAO) AS INTEGER ) END AS DIASAP "
	cQuery += "FROM "+RetSqlName("SC1")+" SC1 "
	cQuery += "WHERE C1_EMISSAO >= '20080401' AND C1_RESIDUO <> 'S' AND C1_APROV <> 'R' "
	cQuery += "AND ( SELECT COUNT(*) FROM "+RetSqlName("SC1")+" C1X WHERE C1X.C1_FILIAL = SC1.C1_FILIAL AND C1X.C1_NUM = SC1.C1_NUM AND C1X.C1_QUANT-C1X.C1_QUJE > 0 "
	cQuery += "      AND C1X.C1_RESIDUO <> 'S' AND C1X.C1_APROV <> 'R' AND C1X.D_E_L_E_T_ = '' ) > 0 "
	cquery += "AND C1_QUANT-C1_QUJE > 0 "
	if aGrupos[_nX,1] == 1
   	   cQuery += "AND C1_SOLICIT "+aGrupos[_nX,2]
   	else
   	   cQuery += "AND C1_TPPROD "+aGrupos[_nX,2]   	   
   	endif   
	cQuery += "AND C1_ORIGEM <> 'MATA106' "
	cQuery += "AND SC1.D_E_L_E_T_ = '' "
	cQuery += "ORDER BY C1_EMISSAO "
//	MemoWrite("C:\Temp\wfcompra_SC.sql",cQuery )

	TCQUERY cQuery NEW ALIAS "TMP1"
	TMP1->( DbGoTop() )
	
	cQuery := "SELECT " 
	cQuery += "CASE WHEN C7_TIPO!='1' THEN 'Autorizacao de Entrega' ELSE  "
    cQuery += "CASE WHEN C7_CONAPRO='B' And C7_QUJE < C7_QUANT THEN 'Pedido Bloqueado' ELSE  "
    cQuery += "CASE WHEN C7_QUJE=0 And C7_QTDACLA=0 THEN 'Pedido Pendente' ELSE "
    cQuery += "CASE WHEN C7_QUJE<>0 And C7_QUJE<C7_QUANT THEN 'Pedido Parcialmente Atendido' ELSE  "
    cQuery += "CASE WHEN C7_QUJE>=C7_QUANT THEN 'Pedido Atendido' ELSE  "
    cQuery += "CASE WHEN C7_QTDACLA >0 THEN 'Utilizado em Pre Documento de entrada'  "
    cQuery += "END END END END END END LEGENDA "
	cQuery += ",C7_NUM,C7_EMISSAO, A2_NOME, A2_TEL,A2_CONTATO, "
	cQuery += "ISNULL( (SELECT TOP 1 C1X.C1_SOLICIT FROM SC1020 C1X WHERE C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC  AND C1X.D_E_L_E_T_ = ''),'S/SC' ) AS C7_SOLIC, "
    cQuery += "C7_NUMSC, C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT, "
	cQuery += "CAST( CONVERT(DATETIME,'"+Dtos(dDataBase)+"') - CONVERT(DATETIME,C7_EMISSAO) AS INTEGER ) AS DIASPED, "
	cQuery += "ISNULL(CAST( CONVERT(DATETIME,C7_EMISSAO) - CONVERT(DATETIME,(SELECT TOP 1 C1_EMISSAO FROM "+RetSqlName("SC1")+" C1X WHERE  C1_FILIAL = C7_FILIAL AND C1_NUM = C7_NUMSC  AND C1X.D_E_L_E_T_ = '') ) AS INTEGER ),0) AS DIASSOL, "
	cQuery += "C7_QUANT-C7_QUJE AS SALDO "
	cQuery += "FROM "+RetSqlName("SC7")+" SC7, "+RetSqlName("SA2")+" SA2, "+RetSqlName("SC1")+" SC1 "
	cQuery += "WHERE ( SELECT COUNT(*) FROM SC7020 C7X WHERE C7X.C7_FILIAL = SC7.C7_FILIAL AND C7X.C7_NUM = SC7.C7_NUM AND C7X.C7_QUANT-C7X.C7_QUJE > 0 "
	cQuery += "        AND C7X.C7_RESIDUO <> 'S' AND C7X.C7_APROV <> 'R' AND C7X.D_E_L_E_T_ = '' ) > 0 "
	cquery += "AND C7_QUANT-C7_QUJE > 0 "
    cquery += "AND C7_FILIAL = C1_FILIAL AND C7_NUMSC = C1_NUM AND C7_ITEMSC = C1_ITEM "
	if aGrupos[_nX,1] == 1
   	   cQuery += "AND C1_SOLICIT "+aGrupos[_nX,2]
   	else
   	   cQuery += "AND C1_TPPROD "+aGrupos[_nX,2]   	   
   	endif   
	cQuery += "AND C7_FORNECE+C7_LOJA = A2_COD+A2_LOJA AND C7_RESIDUO <> 'S' AND C7_APROV <> 'R'  "
	cQuery += "AND SC7.D_E_L_E_T_ = '' AND SA2.D_E_L_E_T_ = '' AND SC1.D_E_L_E_T_ = '' "
	cQuery += "ORDER BY C7_NUM "
//	MemoWrite("C:\Temp\wfcompra_PC.sql",cQuery )


	TCQUERY cQuery NEW ALIAS "TMP2"
	TMP2->( DbGoTop() )
	
	oProcess:=TWFProcess():New("SOLCOM","Emails Solitacao, Pedidos de Compra")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\COMPRA1.htm")
	//oProcess:NewTask('Inicio',"\workflow\http\emp01\COMPRA2.htm")
	//oProcess:NewTask('Inicio',"\workflow\http\emp01\COMPRA3.htm")
	oHtml   := oProcess:oHtml
	
	if !TMP1->(EOF())
   	   while !TMP1->(EOF())
    	   cSC := TMP1->C1_NUM
		   lOk := .T.
	       aadd( oHtml:ValByName("it1.LegSC"    ), TMP1->LEGENDA )
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
	          aadd( oHtml:ValByName("it1.LegSC" ), TMP1->LEGENDA )
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
	else
	   
	   aadd( oHtml:ValByName("it1.LegSC"    ), "------" )
	   aadd( oHtml:ValByName("it1.num"    )  , "------" )
	   aadd( oHtml:ValByName("it1.emiss"  )  , "------" )
	   aadd( oHtml:ValByName("it1.solicit")  , "------" )
	   aadd( oHtml:ValByName("it1.dias"   )  , "------" )
       aadd( oHtml:ValByName("it1.it"    )   , "------" )
	   aadd( oHtml:ValByName("it1.cod"   )   , "------" )
	   aadd( oHtml:ValByName("it1.descr" )   , "------" )
	   aadd( oHtml:ValByName("it1.qtd"   )   , "------" ) 
	   aadd( oHtml:ValByName("it1.sld"   )   , "------" )
	   aadd( oHtml:ValByName("it1.ped"   )   , "------" )
	   aadd( oHtml:ValByName("it1.diasap")   , "------" )
 	       
	   /*
	   aadd( oHtml:ValByName("it1.num")    , "------" )
	   aadd( oHtml:ValByName("it1.emiss")  , "------" )
	   aadd( oHtml:ValByName("it1.solicit"), "------" )
	   aadd( oHtml:ValByName("it1.dias")   , "------" )
	   aadd( oHtml:ValByName("it1.diasap") , "------" )	   
	    */
	endif   
	
	TMP1->( DbCloseArea() )
	
	if !TMP2->(EOF())
   	   while !TMP2->(EOF())
   	       
   	       cPC := TMP2->C7_NUM
		   /*
		   aadd( oHtml:ValByName("it.2LegP")    , TMP2->LEGENDA )
		   aadd( oHtml:ValByName("it.2num")    , TMP2->C7_NUM )
		   aadd( oHtml:ValByName("it.2emiss"  ), StoD( TMP2->C7_EMISSAO ) )
   		   
   		   aadd( oHtml:ValByName("it.2fornec") , Alltrim(TMP2->A2_NOME) )
   		   aadd( oHtml:ValByName("it.2tele")    , iif(!empty(TMP2->A2_TEL),TMP2->A2_TEL,"S/TEL" ) )
   		   aadd( oHtml:ValByName("it.2contat") , IIF(!EMPTY(TMP2->A2_CONTATO),TMP2->A2_CONTATO,"S/CONTATO" ) )
   		   aadd( oHtml:ValByName("it.2diasped"), Transform( TMP2->DIASPED, "@E 9999" ) )
   		   aadd( oHtml:ValByName("it.2diasSol"), Transform( TMP2->DIASSOL , "@E 9999" ) )	   
   		   aadd( oHtml:ValByName("it.2solicit"), Alltrim(TMP2->C7_SOLIC) )
   		   aadd( oHtml:ValByName("it.2sc")     , IIF(!EMPTY(TMP2->C7_NUMSC),TMP2->C7_NUMSC,"S/SC") )   		   
   		   aadd( oHtml:ValByName("it.2item")     , Alltrim(TMP2->C7_ITEM) )
   		   aadd( oHtml:ValByName("it.2cod")    , Alltrim(TMP2->C7_PRODUTO) )
		   aadd( oHtml:ValByName("it.2desc")   , TMP2->C7_DESCRI )
		   aadd( oHtml:ValByName("it.2qtd")    , Transform( TMP2->C7_QUANT , "@E 9,999,999.99" ) )		   
		   aadd( oHtml:ValByName("it.2sld")    , Transform( TMP2->SALDO, "@E 9,999,999.99" ) )
		   */
//		   aadd( oHtml:ValByName("it.2diasAp") , Transform( iif( Empty(TMP2->DIASAP),TMP2->DIASSOL,TMP2->DIASAP), "@E 9999" ) )	   		      

			aadd( oHtml:ValByName("it2.LegP")    , TMP2->LEGENDA )
		   	aadd( oHtml:ValByName("it2.num")    , TMP2->C7_NUM )
			aadd( oHtml:ValByName("it2.emiss"  ), StoD( TMP2->C7_EMISSAO ) )
	   		aadd( oHtml:ValByName("it2.fornec") , Alltrim(TMP2->A2_NOME) )
	   		aadd( oHtml:ValByName("it2.tel")    , iif(!empty(TMP2->A2_TEL),TMP2->A2_TEL,"S/TEL" ) )
	   		aadd( oHtml:ValByName("it2.contat") , IIF(!EMPTY(TMP2->A2_CONTATO),TMP2->A2_CONTATO,"S/CONTATO" ) )
	   		aadd( oHtml:ValByName("it2.diasped"), Transform( TMP2->DIASPED, "@E 9999" ) )
	   		aadd( oHtml:ValByName("it2.diasSol"), Transform( TMP2->DIASSOL , "@E 9999" ) )	   
	   		aadd( oHtml:ValByName("it2.solicit"), Alltrim(TMP2->C7_SOLIC) )
	   		aadd( oHtml:ValByName("it2.sc")     , IIF(!EMPTY(TMP2->C7_NUMSC),TMP2->C7_NUMSC,"S/SC") )   		   
	   		aadd( oHtml:ValByName("it2.it")     , Alltrim(TMP2->C7_ITEM) )
	   		aadd( oHtml:ValByName("it2.cod")    , Alltrim(TMP2->C7_PRODUTO) )
			aadd( oHtml:ValByName("it2.desc")   , TMP2->C7_DESCRI )
			aadd( oHtml:ValByName("it2.qtd")    , Transform( TMP2->C7_QUANT , "@E 9,999,999.99" ) )		   
			aadd( oHtml:ValByName("it2.sld")    , Transform( TMP2->SALDO, "@E 9,999,999.99" ) )
		
		   TMP2->(DbSkip())
		        	                   
     	   while !TMP2->(EOF()) .AND. cPC = TMP2->C7_NUM
     	      /*
		      aadd( oHtml:ValByName("it.2LegP")    , TMP2->LEGENDA )
		      aadd( oHtml:ValByName("it.2num")    , "" )
   		      aadd( oHtml:ValByName("it.2emiss"  ), "" )
   		      aadd( oHtml:ValByName("it.2fornec") , "" )
   		      aadd( oHtml:ValByName("it.2tele")    , "" )
   		      aadd( oHtml:ValByName("it.2contat") , "" )
     		  aadd( oHtml:ValByName("it.2diasped"), "" )
   		      aadd( oHtml:ValByName("it.2diasSol"), Transform( TMP2->DIASSOL , "@E 9999" ) )	   
   		      aadd( oHtml:ValByName("it.2solicit"), Alltrim(TMP2->C7_SOLIC) )
   		      aadd( oHtml:ValByName("it.2sc")     , IIF(!EMPTY(TMP2->C7_NUMSC),TMP2->C7_NUMSC,"S/SC") )
   		      aadd( oHtml:ValByName("it.2item")     , Alltrim(TMP2->C7_ITEM) )
   		      aadd( oHtml:ValByName("it.2cod")    , Alltrim(TMP2->C7_PRODUTO) )
		      aadd( oHtml:ValByName("it.2desc")   , TMP2->C7_DESCRI )
		      aadd( oHtml:ValByName("it.2qtd")    , Transform( TMP2->C7_QUANT , "@E 9,999,999.99" ) )		   
		      aadd( oHtml:ValByName("it.2sld")    , Transform( TMP2->SALDO, "@E 9,999,999.99" ) )
		      */
		      //aadd( oHtml:ValByName("it.2diasAp") , Transform( iif( Empty(TMP2->DIASAP),TMP2->DIASSOL,TMP2->DIASAP), "@E 9999" ) )     	   
		      aadd( oHtml:ValByName("it2.LegP")    , TMP2->LEGENDA )
		      aadd( oHtml:ValByName("it2.num")    , "" )
   		      aadd( oHtml:ValByName("it2.emiss"  ), "" )
   		      aadd( oHtml:ValByName("it2.fornec") , "" )
   		      aadd( oHtml:ValByName("it2.tel")    , "" )
   		      aadd( oHtml:ValByName("it2.contat") , "" )
     		  aadd( oHtml:ValByName("it2.diasped"), "" )
   		      aadd( oHtml:ValByName("it2.diasSol"), Transform( TMP2->DIASSOL , "@E 9999" ) )	   
   		      aadd( oHtml:ValByName("it2.solicit"), Alltrim(TMP2->C7_SOLIC) )
   		      aadd( oHtml:ValByName("it2.sc")     , IIF(!EMPTY(TMP2->C7_NUMSC),TMP2->C7_NUMSC,"S/SC") )
   		      aadd( oHtml:ValByName("it2.it")     , Alltrim(TMP2->C7_ITEM) )
   		      aadd( oHtml:ValByName("it2.cod")    , Alltrim(TMP2->C7_PRODUTO) )
		      aadd( oHtml:ValByName("it2.desc")   , TMP2->C7_DESCRI )
		      aadd( oHtml:ValByName("it2.qtd")    , Transform( TMP2->C7_QUANT , "@E 9,999,999.99" ) )		   
		      aadd( oHtml:ValByName("it2.sld")    , Transform( TMP2->SALDO, "@E 9,999,999.99" ) )
		      
   		      TMP2->(DbSkip())     	   
     	   end
     	    
	   Enddo
	else
	 /*	   
       aadd( oHtml:ValByName("it.2LegP")   ," " )//  LEGENDA
       aadd( oHtml:ValByName("it.2num")    , "" )//  C7_NUM
       aadd( oHtml:ValByName("it.2emiss")  , "" )//  C7_EMISSAO
	   aadd( oHtml:ValByName("it.2fornec") , "" )//  A2_NOME
   	   aadd( oHtml:ValByName("it.2tele")    , "" )//  A2_TEL
   	   aadd( oHtml:ValByName("it.2contat") , "" )//  A2_CONTATO
   	   aadd( oHtml:ValByName("it.2diasped"), "" )//  DIASPED
   	   aadd( oHtml:ValByName("it.2diasSol"), "" )//  DIASSOL	   
   	   aadd( oHtml:ValByName("it.2solicit"), "" )//  C7_SOLIC	   
   	   aadd( oHtml:ValByName("it.2sc")     , "" )//  C7_NUMSC  		   
   	   aadd( oHtml:ValByName("it.2item")     , "" )//  C7_ITEM
   	   aadd( oHtml:ValByName("it.2cod")    , "" )//  C7_PRODUTO
	   aadd( oHtml:ValByName("it.2desc")   , "" )//  C7_DESCRI
	   aadd( oHtml:ValByName("it.2qtd")    , "" )//  C7_QUANT
	   aadd( oHtml:ValByName("it.2sld")    , "" )//  SALDO
	   
	//   aadd( oHtml:ValByName("it2.diasAp") , "" )
	*/
	
	
	   aadd( oHtml:ValByName("it2.LegP")   ," " )//  LEGENDA
       aadd( oHtml:ValByName("it2.num")    , "" )//  C7_NUM
       aadd( oHtml:ValByName("it2.emiss")  , "" )//  C7_EMISSAO
	   aadd( oHtml:ValByName("it2.fornec") , "" )//  A2_NOME
   	   aadd( oHtml:ValByName("it2.tel")    , "" )//  A2_TEL
   	   aadd( oHtml:ValByName("it2.contat") , "" )//  A2_CONTATO
   	   aadd( oHtml:ValByName("it2.diasped"), "" )//  DIASPED
   	   aadd( oHtml:ValByName("it2.diasSol"), "" )//  DIASSOL	   
   	   aadd( oHtml:ValByName("it2.solicit"), "" )//  C7_SOLIC	   
   	   aadd( oHtml:ValByName("it2.sc")     , "" )//  C7_NUMSC  		   
   	   aadd( oHtml:ValByName("it2.it")     , "" )//  C7_ITEM
   	   aadd( oHtml:ValByName("it2.cod")    , "" )//  C7_PRODUTO
	   aadd( oHtml:ValByName("it2.desc")   , "" )//  C7_DESCRI
	   aadd( oHtml:ValByName("it2.qtd")    , "" )//  C7_QUANT
	   aadd( oHtml:ValByName("it2.sld")    , "" )//  SALDO
     
	endif
	

	TMP2->( DbCloseArea() )
	
	_user := Subs(cUsuario,7,15)
	oProcess:ClientName(_user)
       
    oProcess:cTo := aGrupos[_nX,3] //Grupo  de envio original
    //oProcess:cTo := "flavia.rocha@ravaembalagens.com.br"  //teste  de envio 
	//subj	:= "Relação Pedidos de Compra em andamento"
	subj	:= "Relação de Solicitações e Pedidos de Compra em andamento"
	oProcess:cSubject  := subj
	conOut( "Acesso a rotina de envio de Solic.Pedidos Compras em: " + Dtoc( DATE() ) + ' - ' + Time() )
	oProcess:Start()
	WfSendMail()
	//Sleep( 5000 )  //aguarda 5 seg para que o e-mail seja enviado

	oProcess:Finish()
next _nX

return