// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : FATF002.prw
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 17/08/12 | Gustavo Costa     | Rotina para bloquear os pedidos de venda com titulos em aberto
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"
#include "TOPCONN.CH"
#include "Tbiconn.ch " 

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo

@author    TOTVS Developer Studio - Gerado pelo Assistente de C๓digo
@version   1.xx
@since     17/08/2012

/*/

********************************
User Function WFFATF2()
********************************

  //SACOS
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )
  FATF002()      
  Reset Environment 
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" 
  sleep( 5000 )
  FATF002()      
  Reset Environment

Return

//------------------------------------------------------------------------------------------
Static function FATF002()
//--< variแveis >---------------------------------------------------------------------------

Local cAlias 	:= "SC9"
Local cQuery	:= ""
Local nQdias	:= GETNEWPAR("MV_XDIASBL",5)
Local nSaldo	:= 0
Local aBloq	:= {}

cQuery := " SELECT * FROM " + RETSQLNAME("SC9") + " C9 "
cQuery += " WHERE C9_DTBLCRE <= '" + DtoS(dDataBase - nQdias) + "' "
cQuery += " AND C9_DTBLCRE <> '' "
cQuery += " AND C9_FILIAL = '" + XFILIAL("SC9") + "' "
cQuery += " AND C9_NFISCAL = '' "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " AND C9_BLCRED = '' "
cQuery += " AND C9_CLIENTE + C9_LOJA IN ( "
cQuery += " SELECT DISTINCT E1_CLIENTE + E1_LOJA FROM " + RETSQLNAME("SE1") + " E1 "
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND E1_SALDO > 0 "
cQuery += " AND E1_TIPO NOT IN ('NCC','RA','TCC','JP ','TD ','TBX','JP ','TX ','TCB','TP ','TPR','TTV','TSP','TCD','') "
cQuery += " AND E1_VENCREA < '" + DtoS(dDataBase - 1) + "' " // titulos a partir 2 dias em aberto
cQuery += " AND E1_STATUS = 'A' ) "
cQuery += " ORDER BY C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_SEQUEN "

If Select("XTMP") > 0
	DbSelectArea("XTMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XTMP"

XTMP->( DbGoTop() )

While XTMP->(!EOF())

	nSaldo	:= fSaldoTit(XTMP->C9_CLIENTE, XTMP->C9_LOJA)
	ConOut("**** SC9 ****")
	ConOut("CLIENTE - " + XTMP->C9_CLIENTE +"/"+ XTMP->C9_LOJA)
	ConOut("Saldo - " + Transform(nSaldo,"@E 999,999,999.99") )
	
	dbSelectArea("SC9")
	If nSaldo > 0
		If SC9->(dbseek(xFilial("SC9")+XTMP->C9_PEDIDO + XTMP->C9_ITEM + XTMP->C9_SEQUEN))
		
			SC9->(RECLOCK("SC9",.F.))
			//Se cliente for Nova ou Total libera
			If SC9->C9_CLIENTE $ ('006543/007005')
				SC9->C9_BLCRED := ''
			Else
				SC9->C9_BLCRED := '04'
			EndIf
			MSUNLOCK()
			
			U_GrvHisLib(SC9->C9_PEDIDO, Time(), "WF_FATF002")
			
			ConOut("**** BLOQUEOU ****")
			ConOut("CLIENTE - " + XTMP->C9_CLIENTE +"/"+ XTMP->C9_LOJA)
			
			aaDD(aBloq, {SC9->C9_PEDIDO, SC9->C9_CLIENTE, SC9->C9_LOJA})
			
		EndIf
	EndIf
		
	dbSelectArea("XTMP")
	XTMP->(dbskip())
	nSaldo	:= 0

EndDo

If Select("XTMP") > 0
	DbSelectArea("XTMP")
	DbCloseArea()
EndIf

If Len(aBloq) > 0

	ConOut("**** ENVIA EMAIL ****")
	fEnviaEmail(aBloq)

EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ fSaldoTit บ Autor ณ Gustavo Costa     บ Data ณ  23/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular o saldo de titulos     บฑฑ
ฑฑบ          ณ em aberto com mais de 90 dias.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fSaldoTit(cCli, cLoja)

Local cQuery	:= ''
Local nRet		:= 0

cQuery := " SELECT SUM(E1_SALDO) SALDO "
cQuery += " FROM " + RetSqlName("SE1") + " E1 "
cQuery += " WHERE E1_SALDO > 0 "
cQuery += " AND E1_TIPO NOT IN ('NCC','RA') "
cQuery += " AND E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E1_CLIENTE = '" + cCli + "' "
cQuery += " AND E1_LOJA = '" + cLoja + "' "
cQuery += " AND E1_VENCREA < '" + DtoS(dDataBase) + "' "

If Select("XSAL") > 0
	DbSelectArea("XSAL")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XSAL"

XSAL->( DbGoTop() )

nRet := XSAL->SALDO

Return nRet
	
	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ fEnviaEmail บ Autor ณ Gustavo Costa   บ Data ณ  05/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para enviar um email com a lista de  บฑฑ
ฑฑบ          ณ titulos em aberto que foram bloqueados.                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fEnviaEmail(aBloq)

Local cTitulo  	:= "Tํtulos bloqueados em: " + DtoC(dDataBase)
Local cCopia 		:= ""//GetNewPar('MV_XCOPBLQ',"marcelo@ravaembalagens.com.br")
Local cMailTo 	:= GetNewPar('MV_XMAILPV',"gustavo@ravaembalagens.com.br")
Local cConteudo	:= ""
Local cCliAnt		:= ""

cConteudo +="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
cConteudo +="<html xmlns='http://www.w3.org/1999/xhtml' >"
cConteudo +="<head>"
cConteudo +="    <title>Untitled Page</title>"
cConteudo +="</head>"
cConteudo +="<body>"            
cConteudo +="Segue abaixo a lista dos Pedidos liberados que foram bloqueados!."
cConteudo +="<br /> <br /> <br />"                      

//aaDD(aBloq, {SC9->C9_PEDIDO, SC9->C9_CLIENTE, SC9->C9_LOJA})

For i :=1 to Len(aBloq)

	If aBloq[i][2] <> cCliAnt
		cConteudo += "<strong>Pedido: </strong>" + aBloq[i][1] 
		cConteudo += " -> "
		cConteudo += "Cliente: " + aBloq[i][2] + "/" + aBloq[i][3] + " - " + AllTrim(Posicione("SA1",1,xFilial("SA1")+aBloq[i][2]+ aBloq[i][3],"A1_NOME")) 
		cConteudo += "<br />"
	EndIf
	cCliAnt	:= aBloq[i][2]
Next i

cConteudo +="</body>"
cConteudo +="</html>"

cAnexo	:= ""

ConOut("**** CONTEUDO ****")
ConOut(cConteudo)

//cMailTo += ";flavia.rocha@ravaembalagens.com.br"

lEnviado := U_SendFatr11( cMailTo, cCopia, cTitulo, cConteudo, cAnexo )

Return

//--< fim de arquivo >----------------------------------------------------------------------
