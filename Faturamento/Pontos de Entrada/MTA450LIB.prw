#Include 'Protheus.ch'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : MTA450LIB.prw
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 23/08/12 | Gustavo Costa     | PE ANTES DA LIBERACAO MANUAL DE PV
// ---------+-------------------+-----------------------------------------------------------
// Este ponto pertence เ rotina de libera็ใo de cr้dito, MATA450(). Estแ localizado na
// libera็ใo manual, A450LIBMAN(). Permite que o item a ser processado seja validado,
// permitindo ou nใo seu processamento.  .T. continua liberacao e .F. aborta.

**************************
User Function MTA450LIB() 
**************************

Local lRet			:= .F.
Local aGrps 		:= GetGrupos( cUserName )
Local nLC			:= SA1->A1_LC
Local nSaldoAb	:= fSaldoTit(SC9->C9_CLIENTE, SC9->C9_LOJA)
Local nMAtraso	:= 0
Local nSaldoLC	:= 0
Local nValPed		:= fSaldoPed(SC9->C9_PEDIDO)
Local nNivel		:= 0
Local nNivelGer	:= GETNEWPAR("MV_XLCGER",5)
Local nNivelDir	:= GETNEWPAR("MV_XLCDIR",10)
Local nSaldoRa	:= 0
Local cPedido		:= SC9->C9_PEDIDO 
Local cCondPG		:= POSICIONE("SC5",1,xFilial("SC5") + SC9->C9_PEDIDO, "C5_CONDPAG") 
Local cTempo    	:= "" 
Local lLicitacao	:= .F.
Local cPrePed   	:= ""
Local aTit2060	:= fTit2060(SC9->C9_CLIENTE, SC9->C9_LOJA)
Local cTPCli		:= POSICIONE("SA1",1, xFilial("SA1") + SC9->C9_CLIENTE + SC9->C9_LOJA, 'A1_SATIV1')

nSaldoLC	:= nLC - nSaldoAb

//FR - 06/03/14
//T๓pico 3.4 - Projeto Licita็ใo
//Avalia็ใo se atinge faturamento mํnimo, enviar e-mail para financeiro. Caso contrario envia e-mail (repr./coord./sup./assist.)
//05/03/14: Conversa Skype com Antonio, fui esclarecida que ้ preciso inserir o aviso por email
//no momento em que o pedido ้ liberado pelo Financeiro 
//// 

SC6->(Dbsetorder(1))
If SC6->(Dbseek(xFilial("SC6") + cPedido))
	While !SC6->(EOF()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == cPedido
		If !Empty(SC6->C6_PREPED)
			cPrePed    := SC6->C6_PREPED
			lLicitacao := .T.
		Endif
	SC6->(DBSKIP())
	Enddo	
Endif

//se nao for orgao publico, pega a media de atraso.
If cTPCli <> '000009'

	nMAtraso	:= fMediaAtraso(SC9->C9_CLIENTE, SC9->C9_LOJA)

EndIf

If SA1->A1_RISCO == "E" .OR. cCondPG == '001' .OR. nMAtraso > GetNewPar("MV_XDIASMA",30)

	nSaldoRa	:= fTemRa(cPedido)
	
	If nValPed <= nSaldoRa
		lRet 	:= .T.
	Else
		If nMAtraso > GetNewPar("MV_XDIASMA",30)
			MsgAlert("Cliente com m่dia de atraso de " + Alltrim(Str(nMAtraso)) + " dias. Libera็ใo apenas com Recebimento Antecipado! ")
			lRet := U_senha2( "30", 4 )[ 1 ]
		Else
			MsgAlert("Cliente Risco E ou Condi็ใo de Pagamento Antecipada, necessita de Recebimento Antecipado associado ao pedido! ")
			lRet := U_senha2( "30", 4 )[ 1 ]
		EndIf
	EndIf

Else

	nNivel		:= Round(((nValPed - nSaldoLC) / nSaldoLC ) * 100,2)

	Do Case

	Case nNivel < nNivelGer

		lRet	:= .T.

	Case nNivel >= nNivelGer .and. nNivel < nNivelDir

		If "GERENCIA" $ agrps[3] .OR. "DIRETORIA" $ agrps[3] .OR. "ADMINISTRA" $ agrps[3]
			lRet	:= .T.
		Else
			If nNivel < nNivelDir
				MsgAlert("Limite de credito ultrapassado. Solicite a libera็ใo a Gerencia/Diretoria!")
			Else
				MsgAlert("Limite de credito ultrapassado. Apenas a Diretoria pode liberar!")
			EndIf
		EndIf

	Case nNivel >= nNivelDir

		If "DIRETORIA" $ agrps[3] .OR. "ADMINISTRA" $ agrps[3]
			lRet	:= .T.
		Else
			MsgAlert("Limite de credito ultrapassado. Apenas a Diretoria pode liberar!")
		EndIf

	EndCase

EndIf

If len(aTit2060) > 0

	If aTit2060[1][1] = '000009'
		MsgAlert("Impossํvel liberar. Cliente com tํtulo(s) em aberto acima de 60 dias!")
		lRet := U_senha2( "30", 4 )[ 1 ]
	EndIf

EndIf

If lRet
	U_GrvHisLib(cPedido, Time(), "MTA450LIB", cPrePed)
	//envia e-mail para Licita็ใo tamb้m 
	//If lLicitacao
		//EnvStatus(cPedido) nใo ้ pra enviar email	
	//Endif
EndIf

Return lRet


/*ฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
Function  ณ GetGrupos() Retorna string com grupos que o usuario atual faz parte
ฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Static function GetGrupos(cUsuario)

Local aUser   := {}
Local cGrupos := ""
Local cDGrps := ""
Local cGrp

aGroup	:= UsrRetGrp(cUsuario)

for k := 1 to Len( aGroup )
	cDGrps 	+= Upper(AllTrim(GrpRetName(aGroup[k]))) + "/" //Descricao dos Grupos
	cGrupos 	+= aGroup[k] + "/" //Codigos dos Grupos

	if k = 1
		cGrp := aGroup[1]//Retorna Codigo do Primeiro Grupo
	endif
next k

return { cGrupos, cGrp, cDGrps }


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ fSaldoTit บ Autor ณ Gustavo Costa     บ Data ณ  23/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular o saldo de titulos     บฑฑ
ฑฑบ          ณ em aberto.                                                 บฑฑ
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
//cQuery += " AND E1_VENCREA <= '" + DtoS(dDataBase) + "' "

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
ฑฑบFun็ใo    ณ fSaldoPed บ Autor ณ Gustavo Costa     บ Data ณ  27/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular o saldo de pedido      บฑฑ
ฑฑบ          ณ a ser liberado.                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fSaldoPed(cPed)

Local cQuery	:= ''
Local nRet		:= 0

//cQuery := " SELECT SUM((C9_QTDLIB*C9_PRCVEN) + (C9_QTDLIB*C9_PRCVEN*B1_IPI)/100) VTOTAL "
cQuery := " SELECT SUM(C9_QTDLIB*C9_PRCVEN) VTOTAL "
cQuery += " FROM " + RetSqlName("SC9") + " C9 "
cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
cQuery += " ON C9_PRODUTO = B1_COD "
cQuery += " WHERE C9.D_E_L_E_T_ <> '*' " 
cQuery += " AND C9_PEDIDO = '" + cPed + "' "
cQuery += " AND C9_NFISCAL = ''"

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

nRet := TMP->VTOTAL

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ fTemRA    บ Autor ณ Gustavo Costa     บ Data ณ  27/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para localizar o Recebimento         บฑฑ
ฑฑบ          ณ Antecipado do pedido a ser liberado.                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fTemRa(cPed)

Local cQuery	:= ''
Local nRet		:= 0

cQuery := " SELECT SUM(E1_SALDO) SALDO "
cQuery += " FROM " + RetSqlName("SE1") + " E1 "
cQuery += " WHERE D_E_L_E_T_ <> '*' " 
cQuery += " AND E1_TIPO = 'RA' "
cQuery += " AND E1_PEDIDO = '" + cPed + "' "


If Select("XE1") > 0
	DbSelectArea("XE1")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XE1"

XE1->( DbGoTop() )

nRet := XE1->SALDO

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ GrvHisLib บ Autor ณ Gustavo Costa     บ Data ณ  23/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para gravar o historico da libera็ใo  บฑฑ
ฑฑบ        ณ dos pedidos de venda.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GrvHisLib(cPed, cHora, cOrigem, cPrePed)

Local aArea	:= GETAREA()
Local nSeq	:= 1
Local LF    := CHR(13) + CHR(10)

dbSelectArea("ZB3")
dbsetorder(2)

If ZB3->(dbseek(xFilial("ZB3") + cPed ))

	If ZB3->(dbseek(xFilial("ZB3") + cPed + SubStr(cHora,1,4)))

		Return

	Else
		dbsetorder(1)
		While ZB3->(!EOF()) .AND. cPed == ZB3->ZB3_PEDIDO
			nSeq	:= nSeq + 1
			ZB3->(dbskip())
		EndDo

	EndIf
EndIf
///TABELA ZB3 - HISTำRICO LIBERAวีES CRษDITO
ZB3->(RECLOCK("ZB3",.T.))

ZB3->ZB3_FILIAL	:= XFILIAL("ZB3")
ZB3->ZB3_PEDIDO	:= cPed
ZB3->ZB3_SEQ		:= strZero(nSeq,2)
ZB3->ZB3_DATALI	:= dDataBase
ZB3->ZB3_HORA		:= cHora
ZB3->ZB3_ORIGEM	:= cOrigem
ZB3->ZB3_USUARI	:= cUserName
ZB3->ZB3_CODUSU	:= __cUserId

MSUNLOCK()

///IMPLEMENTADO POR FR - 09/10/12
///PRECISO DESTAS INFORMAวีES NO SC9 para a tela consulta que REgina utiliza para saber quem liberou o pedido (cr้dito)
///A TELA CONSULTA ESTม NO PROGRAMA FINC008
cTempo:=Left( Time(), 5 )
SC9->(Dbsetorder(1))   //C9_FILIAL + C9_PEDIDO
If SC9->(Dbseek(xFilial("SC9") + cPed ))
	While SC9->(!Eof()) .and. SC9->C9_FILIAL == xFilial("SC9") .and. SC9->C9_PEDIDO == cPed 
	     If RecLock("SC9", .F. )
	     	SC9->C9_DTBLCRE := dDataBase       	//data
			If !Empty(cHora)
				SC9->C9_HRBLCRE := cHora          	//hora
			Else
				SC9->C9_HRBLCRE := cTempo          	//hora
			Endif
			SC9->C9_USRLBCR := cUserName 		//usuแrio
			SC9->C9_BLEST   := "02"
			SC9->(MsUnlock())	     
	     Endif
	     SC9->(DBSKIP())
	Enddo 
Endif
///FIM FR - 09/10/12  

////////////////////////////////////////////////////////////////////////////////
///SOLICITADO POR EURIVAN - ETAPAS PEDIDO VENDA
///FR - FLมVIA ROCHA - IMPLEMENTAR HISTำRICO DO PEDIDO A CADA ETAPA REALIZADA
///AQUI, QDO LIBERAR O CRษDITO IRม REGISTRAR NO HISTำRICO ZAC                   
////////////////////////////////////////////////////////////////////////////////
DbSelectArea("ZAC") 

	RecLock("ZAC", .T.)
	ZAC->ZAC_FILIAL := xFilial("SC9")	
	ZAC->ZAC_PEDIDO := cPed
	ZAC->ZAC_STATUS := '02'  //SC5->C5_STATUS
	ZAC->ZAC_DESCST := "APROVACAO DO CREDITO"   //"APROVACAO DE PAGAMENTO" //06/05/14 - EURIVAN PEDIU PARA MUDAR OS DIZERES
	ZAC->ZAC_DTSTAT := Date()
	ZAC->ZAC_HRSTAT := Time()
	ZAC->ZAC_USER   := __CUSERID //c๓digo do usuแrio que criou
	ZAC->(MsUnlock())
	
	SC5->(Dbsetorder(1))   
	If SC5->(Dbseek(xFilial("SC5") + cPed ))
		RecLock("SC5", .F. )
		SC5->C5_STATUS := '02'
		SC5->(MsUnlock())
	Endif

cQuery := ""
If !Empty(cPrePed)
	cTempo:=Left( Time(), 5 )
	SC9->(Dbgotop())
	SC9->(Dbsetorder(1))   //C9_FILIAL + C9_PEDIDO
	If SC9->(Dbseek(xFilial("SC9") + cPed ))
		While SC9->(!Eof()) .and. SC9->C9_FILIAL == xFilial("SC9") .and. SC9->C9_PEDIDO == cPed 
		     
		     //busca na tabela SZ6 - pr้-pedido o respectivo produto/item
		     nRecSZ6 := 0   //recno do item pr้-pedido
		     nRecZ18 := 0   //recno do item edital
		      
		    cQuery := "Select Z17.R_E_C_N_O_ Z17REC, Z18.R_E_C_N_O_ Z18REC, SZ6.R_E_C_N_O_ Z6REC, Z18.Z18_PROD " + LF
			cQuery += " , Z18.Z18_ITEM, Z18.Z18_NUMPP, SZ6.Z6_NUM, SZ6.Z6_ITEM, * " + LF
			cQuery += " From " + RetSqlName("Z17") + " Z17 " + LF //CABEวALHO DO EDITAL
			cQuery += " , " + RetSqlName("Z18") + " Z18 " + LF
			cQuery += " , " + RetSqlName("SC6") + " SC6 " + LF
			cQuery += " , " + RetSqlName("SZ6") + " SZ6 " + LF
			
			cQuery += " Where Z17.D_E_L_E_T_ = '' " + LF
			cQuery += " and Z18.D_E_L_E_T_ = '' " + LF
			cQuery += " and SC6.D_E_L_E_T_ = '' " + LF
			cQuery += " and SZ6.D_E_L_E_T_ = '' " + LF
			
			cQuery += " and Z17.Z17_FILIAL = '" + Alltrim(xFilial("Z17")) + "' " +LF
			cQuery += " and SC6.C6_FILIAL = '" + Alltrim(xFilial("SC6")) + "' " +LF
			
			cQuery += " and Z18.Z18_PROD = '" + Alltrim(SC9->C9_PRODUTO) + "' " + LF
			//ASSOCIA COM ITENS DO EDITAL
			cQuery += " and Z18.Z18_FILIAL = Z17.Z17_FILIAL " + LF
			cQuery += " and Z18.Z18_FILIAL = SZ6.Z6_FILIAL " + LF
			cQuery += " and SC6.C6_FILIAL  = Z17.Z17_FILIAL " + LF
			cQuery += " and SC6.C6_FILIAL  = Z18.Z18_FILIAL " + LF
			cQuery += " AND SC6.C6_PRODUTO = Z18.Z18_PROD   " + LF
			cQuery += " AND SC6.C6_PRODUTO = SZ6.Z6_PRODUTO " + LF
			
			cQuery += " and SC6.C6_FILIAL  = SZ6.Z6_FILIAL " + LF
			cQuery += " and SC6.C6_PREPED  = SZ6.Z6_NUM " + LF
			
			cQuery += " and Z18.Z18_CODEDI = Z17.Z17_CODIGO " + LF
			cQuery += " and SC6.C6_PREPED  = Z18.Z18_NUMPP  " + LF
			cQuery += " and Z18.Z18_NUMPP  = SZ6.Z6_NUM     " + LF

			cQuery += " and SC6.C6_NUM = '" + Alltrim(SC9->C9_PEDIDO) + "' " + LF		
			MemoWrite("C:\TEMP\MTA450LIB.SQL" , cQuery )
			
			If Select("TEMP1") > 0
				DbSelectArea("TEMP1")
				DbCloseArea()	
			EndIf                  
			TCQUERY cQuery NEW ALIAS "TEMP1" 
			//TCSetField( "TEMP1" , "Z17_EMISS", "D")
			//TCSetField( "TEMP1" , "Z17_DTABER", "D")
			If !TEMP1->(Eof())
				While !TEMP1->(Eof())
					//RECLOCK NO Z18 -> ITENS EDITAL
					//RECLOCK NO SZ6 -> ITENS PRษ PEDIDO
					nRecSZ6 := TEMP1->Z6REC
			     	nRecZ18 := TEMP1->Z18REC
			     	
			     	DbSelectArea("Z18")
			     	Z18->(Dbgoto(nRecZ18))
			     	Reclock("Z18", .F.)
			     	Z18->Z18_DLIBCR := dDataBase
			     	If !Empty(cHora)
			     		Z18->Z18_HLIBCR := cHora
			     	Else 
			     		Z18->Z18_HLIBCR := cTempo
			     	Endif
			     	Z18->Z18_ULIBCR := cUserName 
			     	Z18->(MsUnlock())
			     	
			     	DbSelectArea("SZ6")
			     	SZ6->(Dbgoto(nRecSZ6))
			     	Reclock("SZ6", .F.)
			     	SZ6->Z6_DLIBCRE := dDataBase
			     	If !Empty(cHora)
			     		SZ6->Z6_HLIBCRE := cHora
			     	Else                        
			     		SZ6->Z6_HLIBCRE := cTempo
			     	Endif		     		
			     	SZ6->Z6_ULIBCRE := cUserName
			     	SZ6->(MsUnlock())
			     	
			     	DbSelectArea("TEMP1")				
			     	TEMP1->(Dbskip())
		     	Enddo
				 
			Endif  //eof do temp1
			DbSelectArea("TEMP1")
			DbCloseArea()	     
			DbSelectArea("SC9")
		    SC9->(DBSKIP())
		Enddo  //while do c9
	Endif      //dbseek no c9
Endif          //se empty cpreped



RESTAREA(aArea)

Return


***************
Static Function secQuery( cPedid )
***************

Local cQuery
Local aRet := {}
Local LF   := CHR(13) + CHR(10)

If Select("TMP2") > 0  
  DbSelectArea("TMP2")
  TMP2->(DbCloseArea())
EndIf


cQuery := " Select	SC6.C6_PRODUTO, SC6.C6_QTDVEN, SC6.C6_UM, SB1.B1_DESC, SB1.B1_IPI, SC6.C6_PRUNIT, SC6.C6_TES " + LF
cQuery += " from	"  + LF
cQuery += " " + RetSqlName("SC6") + " SC6 " + LF
cQuery += " inner join " + RetSqlName("SB1") + "  SB1 on SC6.C6_PRODUTO = SB1.B1_COD " + LF
cQuery += " where	SC6.C6_NUM = '"+alltrim(cPedid)+"' " + LF
cQuery += " and SC6.D_E_L_E_T_ != '*' " + LF
cQuery += " and SC6.C6_FILIAL = '" + xFilial("SC6") + "' " + LF
cQuery += " and SB1.D_E_L_E_T_ != '*' " + LF
cQuery += " order by SC6.C6_NUM, SC6.C6_QTDVEN desc " + LF 
MemoWrite("C:\TEMP\itFATPDV2.SQL" , cQuery )
cQuery := changeQuery( cQuery )
TCQUERY cQuery NEW ALIAS 'TMP2'
TMP2->( dbGoTop() )
dbSelectArea('SB5')
SB5->( dbSetOrder( 1 ) )
dbSelectArea('SX5')
SX5->( dbSetOrder( 1 ) )

do while TMP2->( !EoF() )

	if SB5->( dbSeek( xFilial('SB5') + iif( len(TMP2->C6_PRODUTO) > 7, U_transgen(TMP2->C6_PRODUTO), TMP2->C6_PRODUTO ), .T. ) )
		nLarg := SB5->B5_LARG2
		nAltu := SB5->B5_COMPR2
		SX5->( dbSeek( xFilial('SX5') + '70' + SB5->B5_COR ), .T. )
		cCor	:= SX5->X5_DESCRI
	else
		nAltu := nLarg := 0
		cCor := ''
	endIf

   aAdd( aRet, {alltrim(TMP2->C6_PRODUTO), alltrim(str(TMP2->C6_QTDVEN)), alltrim(TMP2->C6_UM), alltrim(TMP2->B1_DESC),;
   				 alltrim(cCor), alltrim(str(nLArg)), alltrim(str(nAltu)), TMP2->C6_PRUNIT , TMP2->B1_IPI , TMP2->C6_TES} )
   
   
	TMP2->( dbSkip() )
endDo
TMP2->( dbCloseArea() )
SX5->( dbCloseArea() )
SB5->( dbCloseArea() )

Return aRet


********************************************
Static Function EnvStatus(cPedido) 
********************************************

Local cQuery := ""
Local LF     := CHR(13) + CHR(10) 
Local cArqHtml := ""
Local cEmpresa := ""
Local cCabeca  := ""
Local nTotGer  := 0
Local cSup      := "" //superior do usuแrio
Local cNomeSup  := ""
Local cMailSup  := "" //email do superior do usuแrio
Local cVend     := "" //c๓digo do vendedor
Local cMailVend := ""
Local cCoord    := ""  //coordenador do vendedor
Local cMailCoord:= ""
Local cMailUserI:= ""
Local cNomeI    := ""               
Local cNomeVend := "" 
Local cNomeCoord:= ""

cQuery := "Select " + LF
cQuery += " * " + LF
cQuery += " From " + RetSqlName("Z17") + " Z17 " + LF //CABEวALHO DO EDITAL
cQuery += " , " + RetSqlName("Z18") + " Z18 " + LF
cQuery += " , " + RetSqlName("SC6") + " SC6 " + LF
cQuery += " , " + RetSqlName("SC9") + " SC9 " + LF
cQuery += " , " + RetSqlName("SC5") + " SC5 " + LF

cQuery += " Where Z17.D_E_L_E_T_ = '' " + LF
cQuery += " and Z18.D_E_L_E_T_ = '' " + LF
cQuery += " and SC6.D_E_L_E_T_ = '' " + LF
cQuery += " and SC9.D_E_L_E_T_ = '' " + LF
cQuery += " and SC5.D_E_L_E_T_ = '' " + LF

cQuery += " and Z17.Z17_FILIAL = '" + Alltrim(xFilial("Z17")) + "' " +LF
cQuery += " and SC6.C6_FILIAL = '" + Alltrim(xFilial("SC6")) + "' " +LF
//ASSOCIA COM ITENS DO EDITAL
cQuery += " and Z18.Z18_FILIAL = Z17.Z17_FILIAL " + LF
cQuery += " and SC6.C6_FILIAL  = Z17.Z17_FILIAL " + LF
cQuery += " and SC6.C6_FILIAL  = Z18.Z18_FILIAL " + LF
cQuery += " AND SC6.C6_PRODUTO = Z18.Z18_PROD   " + LF
cQuery += " AND SC6.C6_PRODUTO = SC9.C9_PRODUTO " + LF

cQuery += " and SC5.C5_FILIAL  = SC6.C6_FILIAL " + LF
cQuery += " and SC5.C5_FILIAL  = SC9.C9_FILIAL " + LF 

cQuery += " and SC6.C6_FILIAL  = SC9.C9_FILIAL " + LF
cQuery += " and SC6.C6_NUM     = SC5.C5_NUM " + LF
cQuery += " and SC6.C6_NUM     = SC9.C9_PEDIDO " + LF
//cQuery += " and SC6.C6_ITEM    = SC9.C9_ITEM " + LF

cQuery += " and Z18.Z18_CODEDI = Z17.Z17_CODIGO " + LF
cQuery += " and SC6.C6_PREPED  = Z18.Z18_NUMPP  " + LF

cQuery += " and SC9.C9_PEDIDO = '" + Alltrim(cPedido) + "' " + LF
cQuery += " and SC9.C9_NFISCAL = '' " + LF
MemoWrite("C:\TEMP\MTA450LIB.SQL" , cQuery )

If Select("TEMP1") > 0
	DbSelectArea("TEMP1")
	DbCloseArea()	
EndIf                  
TCQUERY cQuery NEW ALIAS "TEMP1" 
TCSetField( "TEMP1" , "Z17_EMISS", "D")
TCSetField( "TEMP1" , "Z17_DTABER", "D")
If !TEMP1->(Eof())  
	cEmpresa := "" 
	DBSelectArea("SM0")
	SM0->(Dbseek( SM0->M0_CODIGO + TEMP1->Z17_FILIAL ))
	cEmpresa := SM0->M0_FILIAL  
	
	//captura os dados de quem incluiu o edital 
	PswOrder(2)
	If PswSeek( TEMP1->Z17_USUARI, .T. )
		aUsers := PSWRET() 						// Retorna vetor com informa็๕es do usuแrio	   
	   	cNomeI := Alltrim(aUsers[1][4])		// Nome completo do usuแrio logado
	   	cMailUserI := Alltrim(aUsers[1][14])     // e-mail do usuแrio logado
		//cDepto:= aUsers[1][12]  //Depto do usuแrio logado	
		cSup	  := aUsers[1][11] //superior do usuแrio logado
	Endif                                              
	
	//dados do superior do usuแrio que incluiu o edital	
	PswOrder(1)
	If PswSeek( cSup, .T. )
		aUsers := PSWRET() 						// Retorna vetor com informa็๕es do usuแrio	   
	   	cNomeSup := Alltrim(aUsers[1][4])		// Nome completo do usuแrio logado
	   	cMailSup := Alltrim(aUsers[1][14])     // e-mail do usuแrio logado
	Endif   
	
	
	//-------------------------------------------------------------------------------------
	// Iniciando o Processo WorkFlow de envio dos Processos Devolu็ใo x Status
	//-------------------------------------------------------------------------------------
	// Monte uma  descri็ใo para o assunto:
	cCabeca  := "PEDIDO LICITAวรO LIBERADO"
	cAssunto := "PEDIDO LICITAวรO LIBERADO - " + cPedido
	cMsg     := "O Seguinte Edital teve seu Pedido de Venda Liberado Pelo Financeiro, conforme Segue Abaixo:<br><br>"
	// Informe o caminho e o arquivo html que serแ usado.
	cArqHtml := "\Workflow\http\oficial\MTA450LIB.html"
		
	// Inicialize a classe de processo:
	oProcess := TWFProcess():New( "LICF010", cAssunto )
		
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask( "STATUS LICITACAO", cArqHtml )
		
	// Informe o nome do shape correspondente a este ponto do fluxo:
	cShape := "INICIO"
		
	// Informe a fun็ใo que deverแ ser executada quando as respostas chegarem
	// ao Workflow.
	//oProcess:bReturn := "U_APCRetorno"
	oProcess:cSubject := cAssunto
		
	oHtml := oProcess:oHTML
		
	oHtml:ValByName("Cabeca",cCabeca)
	oHtml:ValByName("cPedido",cPedido)
	TEMP1->(Dbgotop())
	//While !TEMP1->(EOF())
	
	     oHtml:ValByName("cStatus" , TEMP1->Z17_STATUS + "-" + posicione('SX5',1,xFilial('SX5') + 'Z5' + TEMP1->Z17_STATUS , "X5_DESCRI" ) )     	      
	     oHtml:ValByName("cFilial" , cEmpresa )          
	     oHtml:ValByName("cEdital" , TEMP1->Z17_CODIGO ) 
	     oHtml:ValByName("cLicita" , TEMP1->Z17_LICITA + '-' + posicione('Z15',1,xFilial('Z15') + TEMP1->Z17_LICITA , "Z15_NOMLIC" ) ) 
	     oHtml:ValByName("dEmissao" , Dtoc(TEMP1->Z17_EMISS) ) 
	     oHtml:ValByName("cHoraEmi" , TEMP1->Z17_HREMIS )      
   	     oHtml:ValByName("dDTAber" , Dtoc(TEMP1->Z17_DTABER) ) 
   	     oHtml:ValByName("cHoraber" , TEMP1->Z17_HRABER )  
   	     oHtml:ValByName("cUserInc" , TEMP1->Z17_USUARI )          
   	     oHtml:ValByName("cModali" , TEMP1->Z17_MODALI )      
   	     oHtml:ValByName("cNroEdital" , TEMP1->Z17_NREDIT )      
   	     oHtml:ValByName("cProcesso" , TEMP1->Z17_PROCES )      
   	     oHtml:ValByName("cSRP" , TEMP1->Z17_SRP )      
   	     oHtml:ValByName("cCondPag" , TEMP1->Z17_CPAG )      
   	     oHtml:ValByName("cPrzEnt" , TEMP1->Z17_PRZENT )      
   	     oHtml:ValByName("cValiProp" , TEMP1->Z17_VALPRO )      
		//TEMP1->(Dbskip())
	//Enddo  
	
	//TEMP1->(Dbgotop())
	While !TEMP1->(EOF())	
	     cVend := TEMP1->C5_VEND1 //VENDEDOR
	     SA3->(Dbsetorder(1))
	     SA3->(Dbseek(xFilial("SA3") + cVend ))
	     cNomeVend := SA3->A3_NREDUZ
	     cMailVend := SA3->A3_EMAIL
	     cCoord    := SA3->A3_SUPER
	     
	     SA3->(Dbsetorder(1))
	     SA3->(Dbseek(xFilial("SA3") + cCoord ))
	     cNomeCoord := SA3->A3_NREDUZ
	     cMailCoord := SA3->A3_EMAIL
     
	     
	     
	     //aadd( oHtml:ValByName("it.cItem")    , TEMP1->Z18_ITEM ) 
	     aadd( oHtml:ValByName("it.cItemE")    , TEMP1->Z18_ITEM ) 
	     aadd( oHtml:ValByName("it.cItemP")    , TEMP1->C9_ITEM ) 
	     aadd( oHtml:ValByName("it.cProduto") , TEMP1->Z18_PROD )          
	     aadd( oHtml:ValByName("it.cDescri")  , TEMP1->Z18_DESCPR ) 
	     aadd( oHtml:ValByName("it.nQtde")    , Transform(TEMP1->Z18_QUANT, "@E 999,999,999") ) 
	     aadd( oHtml:ValByName("it.nPrcUni"), Transform(TEMP1->C6_PRUNIT, "@E 999,999,999.99") )      
   	     aadd( oHtml:ValByName("it.nValTot"), Transform(TEMP1->C6_VALOR, "@E 999,999,999.99") )      
   	     aadd( oHtml:ValByName("it.cUM")   ,  TEMP1->C6_UM )     	     

   	     nTotGer += TEMP1->C6_VALOR
		 TEMP1->(Dbskip())
	Enddo
		oHtml:ValByName("nTOTGER",Transform( nTOTGER, "@E 999,999,999.99") )
        
		//dados do usuแrio que estแ efetuando a libera็ใo cr้dito:
		cNome  := ""		
		cMail  := ""     
		cDepto := "" 
		aUsers := {}
		PswOrder(1)
		If PswSeek( __CUSERID, .T. )
			aUsers := PSWRET() 						// Retorna vetor com informa็๕es do usuแrio	   
		   	cNome := Alltrim(aUsers[1][4])		// Nome completo do usuแrio logado
		   	cMail := Alltrim(aUsers[1][14])     // e-mail do usuแrio logado
			cDepto:= aUsers[1][12]  //Depto do usuแrio logado	
			//cSup	  := aUsers[1][11] //superior do usuแrio logado
		Endif
		

		oProcess:cTo := cMail           //quem liberou
		oProcess:cTo += ";" + cMailUserI    //quem incluiu edital
		oProcess:cTo += ";" + cMailSup      //supervisor de quem incluiu edital
		oProcess:cTo += ";" + cMailVend     //vendedor no pedido
		oProcess:cTo += ";" + cMailCoord    //coordenador do vendedor
		
		cMsg += "Quem Incluiu Edital: " + cNomeI    + ' - ' + cMailUserI + '<br>'
		cMsg += "Supervisor         : " + cNomeSup  + ' - ' + cMailSup  + '<br>'
		cMsg += "Representante      : " + cNomeVend + ' - ' + cMailVend + '<br>'
		cMsg += "Coordenador        : " + cNomeCoord+ ' - ' + cMailCoord+ '<br>'
		oHtml:ValByName("cMSG",cMsg)     
		
		//oProcess:cTo := ""  //retirar
		//oProcess:cTo += ";flavia.rocha@ravaembalagens.com.br"  //retirar
		
		oHtml:ValByName("cUser",cNome)
		oHtml:ValByName("cDepto",cDepto)
		oHtml:ValByName("cMail",cMail)
		
		
		
		// Neste ponto, o processo serแ criado e serแ enviada uma mensagem para a lista
		// de destinatแrios.
		oProcess:Start()
		WfSendMail()
	

Endif //SE !EOF()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ fTit2060  บ Autor ณ Gustavo Costa     บ Data ณ  18/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para listar os titulos com mais de 20บฑฑ
ฑฑบ          ณ dias em aberto.                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fTit2060(cCli, cLoja)

Local cQuery	:= ''
Local aRet		:= {}
Local cGrupo	:= POSICIONE("SA1",1, xFilial("SA1") + cCli + cLoja, 'A1_SATIV1')

cQuery := " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_VALOR, E1_SALDO, E1_EMISSAO, E1_VENCTO "
cQuery += " FROM " + RetSqlName("SE1") + " E1 "
cQuery += " WHERE E1_SALDO > 0 "
cQuery += " AND E1_TIPO NOT IN ('NCC','RA') "
cQuery += " AND E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E1_CLIENTE = '" + cCli + "' "
cQuery += " AND E1_LOJA = '" + cLoja + "' "

//Se for publico 
If cGrupo == '000009'

	cQuery += " AND E1_VENCREA < '" + DtoS(DATE() - 60) + "' "

Else //Privado

	cQuery += " AND E1_VENCREA < '" + DtoS(DATE() - 20) + "' "

EndIf

If Select("XTT") > 0
	DbSelectArea("XTT")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XTT"

XTT->( DbGoTop() )

While !XTT->(EOF())	

	AAdd(aRet, {cGrupo, XTT->E1_FILIAL, XTT->E1_PREFIXO, XTT->E1_NUM, XTT->E1_PARCELA, XTT->E1_TIPO, XTT->E1_CLIENTE, ;
				XTT->E1_LOJA, XTT->E1_NOMCLI, XTT->E1_VALOR, XTT->E1_SALDO, XTT->E1_EMISSAO, XTT->E1_VENCTO})

	XTT->(Dbskip())
	
Enddo

Return aRet



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ fEnviaEmail บ Autor ณ Gustavo Costa   บ Data ณ  18/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao Envia email para vendas com a informa็ใo do bloqueio  บฑฑ
ฑฑบ          ณ do peido.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fEnviaEmail(aTit)

Local nDividendo	:= 3
Local cMensagem 	:= ""

cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
cMensagem += '<head>'
cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cMensagem += '<title>Untitled Document</title>'
cMensagem += '<style type="text/css">'
cMensagem += '<!--'
cMensagem += '.style1 {'
cMensagem += '	font-family: Arial, Helvetica, sans-serif;'
cMensagem += '	color: #FFFFFF;'
cMensagem += '}'
cMensagem += '.style2 {'
cMensagem += '	font-family: Arial, Helvetica, sans-serif;'
cMensagem += '	color: #000000;'
cMensagem += '	font-size: 12px;'
cMensagem += '}'
cMensagem += '.style7 {color: #FFFFFF; font-weight: bold; font-family: Arial, Helvetica, sans-serif; }'
cMensagem += '.style8 {font-weight: bold; font-family: Arial, Helvetica, sans-serif}'
cMensagem += '.style9 {font-family: Arial, Helvetica, sans-serif; font-weight: bold; color: #FFFFFF; }'
cMensagem += '-->'
cMensagem += '</style>'
cMensagem += '</head>'
cMensagem += '<body>'
cMensagem += '<table width="800" border="0">'

cMensagem += '  <tr>'
cMensagem += '   	<td bgcolor="#CCCCCC" colspan="12"><p align="left"><span class="style8">Pedido Bloqueado - ' + SC9->C9_PEDIDO + ;
					' - CLIENTE: ' + POSICIONE("SA1",1, xFilial("SA1") + SC9->C9_CLIENTE + SC9->C9_LOJA, "A1_NOME" ) + '</span></p></td>'
cMensagem += '  </tr>'
cMensagem += '  <tr>'

If aTit[1][1] == "000009"
	cMensagem += '    <td colspan="12" bgcolor="#336600"><span class="style9">TอTULO(S) EM ABERTO COM MAIS DE 60 DIAS</span></td>'
Else
	cMensagem += '    <td colspan="12" bgcolor="#336600"><span class="style9">TอTULO(S) EM ABERTO COM MAIS DE 20 DIAS</span></td>'
EndIf

cMensagem += '  </tr>'
cMensagem += '  <tr>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Filial</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Cliente</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Nome</span></td>'
//cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Telefone</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Tํtulo</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Par.</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Emissใo</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Vencimento</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Valor</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Saldo</span></td>'
//cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Banco/Conta</span></td>'
//cMensagem += '    <td width="608" bgcolor="#336600"><span class="style9">OBS. SAC</span></td>'
cMensagem += '  </tr>'


For x := 1 To Len(aTit)

	If Mod ( nDividendo, 2 ) > 0
	
		cMensagem += '  <tr>'
		cMensagem += '    <td><span class="style2">' + aTit[x][2] + '</span></td>'
		cMensagem += '    <td><span class="style2">' + aTit[x][7] + '-' + aTit[x][8] + '</span></td>'
		cMensagem += '    <td><span class="style2">' + aTit[x][9] + '</span></td>'
		//cMensagem += '    <td><span class="style2">' + TMP->A1_TEL + '</span></td>'
		cMensagem += '    <td><span class="style2">' + aTit[x][3] + '-' + aTit[x][4]  + '</span></td>'
		cMensagem += '    <td><span class="style2">' + aTit[x][5] + '</span></td>'
		cMensagem += '    <td><span class="style2">' + aTit[x][12] + '</span></td>'
		cMensagem += '    <td><span class="style2">' + aTit[x][13] + '</span></td>'
		cMensagem += '    <td><span class="style2">' + Transform(aTit[x][10],'@E 9,999,999.99') + '</span></td>'
		cMensagem += '    <td><span class="style2">' + Transform(aTit[x][11],'@E 9,999,999.99') + '</span></td>'
		//cMensagem += '    <td><span class="style2">' + TMP->E1_PORTADO + '-' + TMP->E1_CONTA + '</span></td>'
		//cMensagem += '    <td><span class="style2">' + TMP->OBS_SAC + '</span></td>'
		cMensagem += '  </tr>
	
	Else
	
		cMensagem += '  <tr>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + aTit[x][2] + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + aTit[x][7] + '-' + aTit[x][8] + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + aTit[x][9] + '</span></td>'
		//cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + TMP->A1_TEL + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + aTit[x][3] + '-' + aTit[x][4]  + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + aTit[x][5] + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + aTit[x][12] + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + aTit[x][13] + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + Transform(aTit[x][10],'@E 9,999,999.99') + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + Transform(aTit[x][11],'@E 9,999,999.99') + '</span></td>'
		//cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + TMP->E1_PORTADO + '-' + TMP->E1_CONTA + '</span></td>'
		//cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + TMP->OBS_SAC + '</span></td>'
		cMensagem += '  </tr>
	
	EndIf
	
	nDividendo	:= nDividendo + 1
	
Next

cMensagem += '</table>'

cMensagem += 'OBS. Este pedido s๓ serแ liberado com autoriza็ใo da Diretoria!'
cMensagem += '</body>'
cMensagem += '</html>'

cEmail   	:= GetNewPar("MV_XBLQ206","gustavo@ravaembalagens.com.br") 

cCopia   	:= ""//GetNewPar("MV_XCPSERA","gustavo@ravaembalagens.com.br") 
cAssunto 	:= "Pedido " + SC9->C9_PEDIDO + " - Bloqueado no Financeiro!!!"
cAnexo		:= ""

lRet	:= U_SendFatr11( cEmail, cCopia, cAssunto, cMensagem, cAnexo )
		
If lRet
	msgAlert("Email enviado com sucesso!")
Else
	msgAlert("Falha no envio do email, por favor, tente novamente.")
EndIf

TMP->(DbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ fMediaAtraso  บ Autor ณ Gustavo Costa  บ Data ณ  19/08/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular a media de atraso de   บฑฑ
ฑฑบ          ณ pagamento dos clientes.                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fMediaAtraso(cCli, cLoja)

Local cQuery	:= ''
Local nRet		:= 0
Local cGrupo	:= POSICIONE("SA1",1, xFilial("SA1") + cCli + cLoja, 'A1_SATIV1')
Local cData	:= Alltrim( Str( Val( SubStr( DtoS( Date()),1,4)) - 1)) + SubStr(DtoS(date()),5,4) //um ano atras

cQuery := " SELECT COUNT(*) QTD_TIT, SUM(DATEDIFF(day, CONVERT(DATE,E1_VENCREA,106), CONVERT(DATE,E1_BAIXA,106) )) SOMA_DIAS, " 
cQuery += " SUM(DATEDIFF(day, CONVERT(DATE,E1_VENCREA,106), CONVERT(DATE,E1_BAIXA,106) ))/COUNT(*) MEDIA_ATRASO "
cQuery += " FROM " + RetSqlName("SE1") + " E1 "
cQuery += " WHERE E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E1_CLIENTE = '" + cCli + "' "
cQuery += " AND E1_LOJA = '" + cLoja + "' "
cQuery += " AND E1_EMIS1 > '" + cData + "' "
cQuery += " AND E1_BAIXA <> '' "
cQuery += " AND E1_TIPO IN ('NF','') "

If Select("XTA") > 0
	DbSelectArea("XTA")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XTA"

XTA->( DbGoTop() )

While !XTA->(EOF())	

	nRet	:= XTA->MEDIA_ATRASO
	
	XTA->(Dbskip())
	
Enddo

Return nRet
