#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMATA410   บAutor  ณEurivan Marques     บ Data ณ  19/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada na gravacao do pedido de venda             บฑฑ
ฑฑบ          ณpara atualizar campos do SC9.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Alterado ณ Gustavo Costa - 23/08/12                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

***********************
User function MATA410()
***********************

Local nPOSPRO 	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
Local nSaldo90	:= 0
Local nSaldo	:= 0
Local nSaldoPed	:= 0
Local nSaldoLC	:= 0
Local l4Meses	:= .F.
Local lAntecip	:= .F.

DbSelectArea("SC9")
DbSetOrder(1)

DbSelectArea("SC6")
DbSetOrder(2)

// Alterado por Gustavo Costa 23/08/12
if SC5->C5_TIPO = 'N'

	If SC5->C5_CONDPAG = '001'
		lAntecip	:= .T.
	EndIf
	
	nSaldo		:= fSaldoTit(SC5->C5_CLIENTE, SC5->C5_LOJACLI)
	nSaldo90	:= fSaldo90(SC5->C5_CLIENTE, SC5->C5_LOJACLI)
	nSaldoPed	:= fSaldoPed(SC5->C5_NUM)
	nSaldoLC	:= Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE + SC5->C5_LOJACLI, "A1_LC") - nSaldo
	
	IF nSaldoLC < 0
		nSaldoLC := 0
	EndIf
		
	If	!Empty(SA1->A1_ULTCOM)

		If dDataBase - SA1->A1_ULTCOM >= 120 //4 meses
			l4Meses	:= .T.
		endIf

	EndIf

EndIf

If SC5->C5_TIPO = 'N' //.T. //nSaldo90 > 0 .OR. l4Meses .OR. nSaldoPed > nSaldoLC .OR. lAntecip

	if SC9->( DbSeek( SC5->C5_FILIAL+SC5->C5_NUM ))//+"0101"+aCols[1,nPOSPRO] ) )
		RecLock("SC9",.F.)
		SC9->C9_MSGFIN := SC5->C5_OBSFIN
		MsUnLock()
//Bloqueio o credito na alteracao ou inclusao do Pedido

		while !SC9->(EOF()) .and. SC9->C9_PEDIDO = SC5->C5_NUM  
			//SC6->(DbSeek( xFilial("SC6")+SC9->C9_PRODUTO+SC5->C5_NUM+SC9->C9_ITEM ))

			RecLock("SC9",.F.)
			//Se cliente for Nova ou Total libera
			If SC9->C9_CLIENTE $ ('006543/007005/000751')
	
				SC9->C9_BLCRED 	:= ""
				SC9->C9_BLEST 	:= ""
				SC9->C9_USRLBCR 	:= "MATA410"
				SC9->C9_USRLBES 	:= "MATA410"

			Else
	
				SC9->C9_BLCRED 	:= "01"
				SC9->C9_BLEST 	:= "02"
				SC9->C9_USRLBCR 	:= "MATA410"
			EndIf
			MsUnLock()

			SC9->(DbSkip())
		end
	endif
EndIf

if SC9->( DbSeek( SC5->C5_FILIAL+SC5->C5_NUM ) )
	while !SC9->(EOF()) .and. SC9->C9_PEDIDO = SC5->C5_NUM

		RecLock("SC9",.F.)
	
		If SC9->C9_CLIENTE $ ('006543/007005')
			SC9->C9_BLEST 	:= ""
		Else
			SC9->C9_BLEST 	:= "02"
			//SC9->C9_BLCRED 	:= "01"
		EndIf
		MsUnLock()
	
		SC9->(DbSkip())
	end
EndIf
//Fim da altera็ใo Gustavo Costa.

//Incluido por Eurivan em 05/05/08
//Atualizo o campo C6_PREPED com numero do pre-pedido
DbSelectArea("SZ6")
DbSetOrder(2)

if Type("cPrePed") == "C"
	if !Empty(cPrePed)
		DbSelectArea("SC6")
		DbSetORder(1)
		SC6->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
		while !SC6->(EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
			RecLock("SC6",.F.)
			SC6->C6_PREPED := cPrePed
			SC6->(MsUnlock())
			SC6->(DbSkip())
		end
		cPrePed := Space(6)
	endif
endif

//Atualiza precos com descontos concedidos na Campanha Preco X Volume
DbSelectArea("SC6")
DbSetORder(1)
SC6->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
while !SC6->(EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
	RecLock("SC6",.F.)
	SC6->C6_PREPED := cPrePed
	SC6->(MsUnlock())
	SC6->(DbSkip())
end


//Incluido em 10/02/2009 chamado 000784
DbSelectArea("SC6")
DbSetORder(1)
SC6->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))

While !SC6->(EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM

	if SZ6->(DbSeek(xFilial("SZ6")+SC6->C6_PRODUTO+SC6->C6_PREPED))

		RecLock("SZ6", .F.)

		If Inclui
			SZ6->Z6_QTDENT += SC6->C6_QTDVEN
		EndIF


		If Altera
			nIdx  := aScan( _aQtdAnt, {|t| t[2]==SC6->C6_PRODUTO     } )
			if nIdx>0
				If _aQtdAnt[nIdx][3]!=SC6->C6_QTDVEN
					If SZ6->Z6_QTDENT!=0
						SZ6->Z6_QTDENT -= _aQtdAnt[nIdx][3]
					EndIf
					SZ6->Z6_QTDENT +=  SC6->C6_QTDVEN
				EndIf
			EndIf
		EndIF


		SZ6->( msUnlock() )
		SZ6->( dbCommit() )
/*
//Posiciono no cab. Pre-Pedido
DbSelectArea("SZ5")
DbSetOrder(1)
SZ5->(DbSeek(xFilial("SZ5")+SC6->C6_PREPED))
//Posiciono no Cab. Edital
DbSelectArea("Z17")
DbSetOrder(1)

if Z17->(DbSeek(xFilial("Z17")+SZ5->Z5_EDITAL))
RecLock("Z17",.F.)
if U_GetSldPP(SC6->C6_PREPED) <= 0
Z17->Z17_STATUS := '03' //Edital Concluido
//else
// if U_GetPartRV(SZ5->Z5_EDITAL)
//    Z17->Z17_STATUS := '  ' //Edital em Andamento
// else
//    Z17->Z17_STATUS := '01' //Edital nao participamos
// endif Retirado em 19/06/2008 por Emmanuel Lacerda
endif
Z17->(MsUnlock())
endif*/
	endif
	SC6->(dbSkip())
EndDo
_aQtdAnt:={}

// colacado em 16/02/09 chamado 000891
//Posiciona na Tab. de Liberacao Pedido

DbSelectArea("Z40")
DbSetOrder(1)

If  DbSeek(SC5->C5_FILIAL+SC5->C5_NUM+'Q')
	if Z40->Z40_STATUS='L' //liberando...
		RecLock("Z40",.F.)
		Z40->Z40_STATUS:='J'	// finaliza a liberacao e muda o status para liberado
		Z40->(MsUnLock())
	EndIf
Endif

If SC5->C5_TIPO = 'N'
	fBlqCred(SC5->C5_NUM)
EndIf

return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณ fSaldo90  บ Autor ณ Gustavo Costa     บ Data ณ  23/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular o saldo de titulos     บฑฑ
ฑฑบ          ณ em aberto com mais de 90 dias.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fSaldo90(cCli, cLoja)

Local cQuery	:= ''
Local nRet		:= 0

cQuery := " SELECT SUM(E1_SALDO) SALDO "
cQuery += " FROM " + RetSqlName("SE1") + " E1 "
cQuery += " WHERE E1_SALDO > 0 "
cQuery += " AND E1_TIPO NOT IN ('NCC','RA') "
cQuery += " AND E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E1_CLIENTE = '" + cCli + "' "
cQuery += " AND E1_LOJA = '" + cLoja + "' "
cQuery += " AND E1_VENCREA <= '" + DtoS(dDataBase - 90) + "' "

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

cQuery := " SELECT SUM((C9_QTDLIB*C9_PRCVEN) + (C9_QTDLIB*C9_PRCVEN*B1_IPI)/100) VTOTAL "
cQuery += " FROM " + RetSqlName("SC9") + " C9 "
cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
cQuery += " ON C9_PRODUTO = B1_COD "
cQuery += " WHERE C9.D_E_L_E_T_ <> '*' " 
cQuery += " AND C9_PEDIDO = '" + cPed + "' "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

nRet := TMP->VTOTAL

Return nRet


//************************************************
// Rotina para bloquear credito de todos pedidos
//************************************************
Static Function fBlqCred(cPedido)

Local aAreaSC9	:= getArea("SC9")

dbSelectArea("SC9")
SC9->(DBSETORDER(1))

If SC9->(Dbseek(xFilial("SC9") + cPedido ))

	If SC9->C9_CLIENTE $ ('031732/031733/006543/007005/000751')
		While SC9->(!EOF()) .AND. SC9->C9_FILIAL == xFilial("SC9") .AND. SC9->C9_PEDIDO == cPedido
			If Reclock("SC9",.F.)
				SC9->C9_BLCRED	:= "" 
				SC9->C9_BLEST 	:= ""
				SC9->C9_USRLBCR := "MATA410"
				SC9->(MsUnlock())
			Endif
			SC9->(DBSKIP())
		Enddo
	Else
		If SC9->(Dbseek(xFilial("SC9") + cPedido )) 
			While SC9->(!EOF()) .AND. SC9->C9_FILIAL == xFilial("SC9") .AND. SC9->C9_PEDIDO == cPedido
				If Reclock("SC9",.F.)
					SC9->C9_BLCRED:= "01" 
					SC9->(MsUnlock())
				Endif
				SC9->(DBSKIP())
			Enddo
		Endif
	EndIf
EndIf
RestArea(aAreaSC9)

Return
