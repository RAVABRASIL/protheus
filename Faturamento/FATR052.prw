// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : FATR052
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 07/08/12 | Gustavo Costa     | Rotina para calcular o Limite de Credito dos Clientes.
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch " 

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Montagem da tela de processamento

@author    TOTVS Developer Studio - Gerado pelo Assistente de C๓digo
@version   1.xx
@since     7/08/2012
/*/
//------------------------------------------------------------------------------------------
User function FATR052()
//--< variแveis >---------------------------------------------------------------------------

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis do Tipo Local, Private e Public                 ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Local nOpc 		:= GD_INSERT+GD_DELETE+GD_UPDATE
Local aSize     	:= {}
Local aSizeAut  	:= MsAdvSize()
Local aObjects  	:= {}
Local aPosObj   	:= {}     
Local ABUTTONS	:= {}
Private aCoBrw1 	:= {}
Private aHoBrw1 	:= {}
Private noBrw1  	:= 13
//Private cPerg  	:= "FIN008"

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
SetPrvt("oDlg1","oBrw1")

AAdd( aObjects, { 050, 050, .T., .T. } )
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 0, 0 }
aPosObj := MsObjSize( aInfo, aObjects, .T. )

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Aadd( aButtons, {"SIMULACA", {|| Processa({|| fAtuLC()}) }, "Atualiza LC", "At. LC" , {|| .T.}} )
Aadd( aButtons, {"MDIHELP", {|| fLegenda()}, "Legenda", "Legenda" , {|| .T.}} )

oDlg1      := MSDialog():New( 0, 0, aSizeAut[6], aSizeAut[5]-5,"Limite de Credito - Clientes",,,.F.,,,,,,.T.,,,.F. )
oDlg1:bInit := {|| EnchoiceBar(oDlg1,{|| oDlg1:End() }, {|| oDlg1:End()},,aButtons) }

ValidPerg()

//Pergunte(cPerg,.T.)

Processa({|| RunReport() })

MHoBrw1()
MCoBrw1()
oBrw1      := MsNewGetDados():New(030,000,aPosObj[1][3], aPosObj[1][4]-5,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHoBrw1,aCoBrw1 )

oDlg1:Activate(,,,.T.)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  26/10/09     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS   บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cQuery	:=''
Local LF		:= CHR(13) + CHR(10)
Local nValTot	:= 0
Local	_nQtdReg	:= 0
Local aSaldo	:= {}

fCriaTAB()

//////////seleciona os dados

cQuery := " SELECT TMP.E1_CLIENTE, TMP.E1_LOJA, TMP.A1_NOME, SUM(A) CLI_A, SUM(B) CLI_B, SUM(C) CLI_C, SUM(D) CLI_D, SUM(E) CLI_E, "
cQuery += " SUM(A) + SUM(B) + SUM(C) + SUM(D) + SUM(E) QTOTAL "
cQuery += " FROM ( "
cQuery += " SELECT E1_CLIENTE, E1_LOJA, A1_NOME, "
cQuery += " CASE WHEN convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) <= 0 THEN COUNT(*) ELSE 0 END A, " 
cQuery += " CASE WHEN convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) > 0 AND "
cQuery += " convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) <= 7 THEN COUNT(*) ELSE 0 END B, " 
cQuery += " CASE WHEN convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) > 7 AND "
cQuery += " convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) <= 15 THEN COUNT(*) ELSE 0 END C, " 
cQuery += " CASE WHEN convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) > 15 AND "
cQuery += " convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) <= 30 THEN COUNT(*) ELSE 0 END D, " 
cQuery += " CASE WHEN convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) > 30 THEN COUNT(*) ELSE 0 END E "
cQuery += " FROM " + RetSqlName("SE1") + " E1 "
cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
cQuery += " ON A1_COD = E1_CLIENTE "
cQuery += " AND A1_LOJA = E1_LOJA "
cQuery += " WHERE E1_BAIXA <> '' "
cQuery += " AND E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E1_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
cQuery += " AND E1_CLIENTE BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
cQuery += " AND E1_LOJA BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
cQuery += " GROUP BY E1_CLIENTE, E1_LOJA, A1_NOME, convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) "
cQuery += " ) AS TMP "
cQuery += " GROUP BY TMP.E1_CLIENTE, TMP.E1_LOJA, TMP.A1_NOME "
cQuery += " ORDER BY E1_CLIENTE, E1_LOJA "

MemoWrite("C:\Temp\FINR008.sql", cQuery )

If Select("SE1X") > 0
	DbSelectArea("SE1X")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SE1X"

count to nREGTOT
SE1X->( DbGoTop() )
ProcRegua( nREGTOT )

If SE1X->(!EOF())
	While SE1X->( !EOF() )
		aSaldo	:= fSaldoTit(SE1X->E1_CLIENTE, SE1X->E1_LOJA)
		RecLock("XE1", .T.)
		XE1->COD	:= SE1X->E1_CLIENTE
		XE1->LOJA	:= SE1X->E1_LOJA
		XE1->NOME	:= SE1X->A1_NOME
		XE1->A		:= (SE1X->CLI_A / SE1X->QTOTAL ) * 100
		XE1->B		:= (SE1X->CLI_B / SE1X->QTOTAL ) * 100
		XE1->C		:= (SE1X->CLI_C / SE1X->QTOTAL ) * 100
		XE1->D		:= (SE1X->CLI_D / SE1X->QTOTAL ) * 100
		XE1->E		:= (SE1X->CLI_E / SE1X->QTOTAL ) * 100
		XE1->RES	:= ((45*XE1->A)/100) + ((25*XE1->B)/100) + ((15*XE1->C)/100) + ((10*XE1->D)/100) + ((5*XE1->E)/100)
		XE1->VENCIDO	:= aSaldo[1]
		XE1->AVENCER	:= aSaldo[2]
		XE1->LCC	:= fCalcLC(XE1->COD, XE1->LOJA, XE1->RES, mv_par01, mv_par02)

		Do Case
		Case XE1->RES	>= 45	//Credito 100% do valor calculado

			XE1->RISCO	:= "B"

		Case XE1->RES	>= 30 .AND. XE1->RES	< 45 //Credito 80% do valor calculado

			XE1->RISCO	:= "C"

		Case XE1->RES	>= 20 .AND. XE1->RES	< 30    //Credito 60% do valor calculado

			XE1->RISCO	:= "D"

		Case XE1->RES	>= 10 .AND. XE1->RES	< 20    //Credito 0.00

			XE1->RISCO	:= "D"

		OtherWise    //sem credito

			XE1->RISCO	:=	"E"

		EndCase

		//XE1->RISCO	:= Posicione("SA1",1,xFilial("SA1")+SE1X->E1_CLIENTE+SE1X->E1_LOJA, "A1_RISCO")
		XE1->(MsUnLock())

		SE1X->(Dbskip())
		IncProc(SE1X->E1_CLIENTE + " - " + SE1X->A1_NOME)

	Enddo

Else
	MsgInfo("arquivo vazio!!")
Endif

SE1X->( DbCloseArea() ) 

Return
//--< fim de arquivo >----------------------------------------------------------------------

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno      ณWF_FINR008 บ Autor ณ AP6 IDE         บ Data ณ  29/08/12     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio   ณ Funcao auxiliar chamada pela WorkFlow. A funcao WF_FINR008 บฑฑ
ฑฑบ          ณ Atualizarแ automaticamente o LC dos Clientes.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function WF_FINR008()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cQuery		:=''
Local LF			:= CHR(13) + CHR(10)
Local nValTot		:= 0
Local _nQtdReg	:= 0
Local aSaldo		:= {}
Local nA, nB, nC, nD, nE, nRes	:= 0

RPCSetType( 3 )
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
sleep( 5000 )
  
cQuery := " SELECT TMP.E1_CLIENTE, TMP.E1_LOJA, TMP.A1_NOME, SUM(A) CLI_A, SUM(B) CLI_B, SUM(C) CLI_C, SUM(D) CLI_D, SUM(E) CLI_E, "
cQuery += " SUM(A) + SUM(B) + SUM(C) + SUM(D) + SUM(E) QTOTAL "
cQuery += " FROM ( "
cQuery += " SELECT E1_CLIENTE, E1_LOJA, A1_NOME, "
cQuery += " CASE WHEN convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) <= 0 THEN COUNT(*) ELSE 0 END A, " 
cQuery += " CASE WHEN convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) > 0 AND "
cQuery += " convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) <= 7 THEN COUNT(*) ELSE 0 END B, " 
cQuery += " CASE WHEN convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) > 7 AND "
cQuery += " convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) <= 15 THEN COUNT(*) ELSE 0 END C, " 
cQuery += " CASE WHEN convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) > 15 AND "
cQuery += " convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) <= 30 THEN COUNT(*) ELSE 0 END D, " 
cQuery += " CASE WHEN convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) > 30 THEN COUNT(*) ELSE 0 END E "
cQuery += " FROM " + RetSqlName("SE1") + " E1 "
cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
cQuery += " ON A1_COD = E1_CLIENTE "
cQuery += " AND A1_LOJA = E1_LOJA "
cQuery += " WHERE E1_BAIXA <> '' "
cQuery += " AND E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E1_EMISSAO BETWEEN '" + DtoS(dDataBase - 180) + "' AND '" + DtoS(dDataBase) + "' "
cQuery += " AND E1_CLIENTE BETWEEN ' ' AND 'ZZZZZZ' "
cQuery += " AND E1_LOJA BETWEEN '  ' AND 'ZZ' "
cQuery += " GROUP BY E1_CLIENTE, E1_LOJA, A1_NOME, convert(int, CONVERT(datetime, E1_BAIXA) - CONVERT(datetime, E1_VENCREA) ) "
cQuery += " ) AS TMP "
cQuery += " GROUP BY TMP.E1_CLIENTE, TMP.E1_LOJA, TMP.A1_NOME "
cQuery += " ORDER BY E1_CLIENTE, E1_LOJA "

MemoWrite("C:\Temp\FINR008.sql", cQuery )

If Select("SE1X") > 0
	DbSelectArea("SE1X")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "SE1X"

SE1X->( DbGoTop() )

While SE1X->( !EOF() )

	aSaldo	:= fSaldoTit(SE1X->E1_CLIENTE, SE1X->E1_LOJA)

	dbSelectArea("SA1")

	If SA1->(dbseek(xFilial("SA1") + SE1X->E1_CLIENTE + SE1X->E1_LOJA))
		RecLock("SA1", .F.)
		nA			:= (SE1X->CLI_A / SE1X->QTOTAL ) * 100
		nB			:= (SE1X->CLI_B / SE1X->QTOTAL ) * 100
		nC			:= (SE1X->CLI_C / SE1X->QTOTAL ) * 100
		nD			:= (SE1X->CLI_D / SE1X->QTOTAL ) * 100
		nE			:= (SE1X->CLI_E / SE1X->QTOTAL ) * 100
		nRES		:= ((45*nA)/100) + ((25*nB)/100) + ((15*nC)/100) + ((10*nD)/100) + ((5*nE)/100)
		SA1->A1_LC	:= fCalcLC(SA1->A1_COD, SA1->A1_LOJA, nRES, dDataBase - 180, dDataBase)

		Do Case
		Case nRES	>= 45	//Credito 100% do valor calculado

			SA1->A1_RISCO	:= "B"

		Case nRES	>= 30 .AND. nRES	< 45 //Credito 80% do valor calculado

			SA1->A1_RISCO	:= "C"

		Case nRES	>= 20 .AND. nRES	< 30    //Credito 60% do valor calculado

			SA1->A1_RISCO	:= "D"

		Case nRES	>= 10 .AND. nRES	< 20    //Credito 0.00

			SA1->A1_RISCO	:= "D"

		OtherWise    //sem credito

			SA1->A1_RISCO	:=	"E"

		EndCase
		SA1->(MsUnLock())
	EndIf

	dbSelectArea("SE1X")

	SE1X->(Dbskip())

Enddo

SE1X->( DbCloseArea() ) 

Reset Environment 

Return
//--< fim de arquivo >----------------------------------------------------------------------


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fAtuLC บ Autor ณ Gustavo Costa        บ Data ณ  07/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para  atualizar o Limite de Compra บฑฑ
ฑฑบ          ณ dos clientes.                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fAtuLC()

Local cQuery	:=''
Local nRet		:= 0

dbSelectArea("SA1")
SA1->(dbSetOrder(1))

ProcRegua( len(aCoBrw1) )

//////////seleciona os dados
For i := 1 TO Len(aCoBrw1)
	
	If SA1->(dbSeek(xFilial("SA1") + aCoBrw1[i][1] + aCoBrw1[i][2] ))
	
		RecLock("SA1", .F.)
		
		SA1->A1_LC		:= aCoBrw1[i][12] 
		SA1->A1_RISCO	:= aCoBrw1[i][13] 
		SA1->A1_VENCLC:= dDataBase+7 
		 
		SA1->(MsUnLock())
		
	EndIf
	IncProc("Gravando...")
Next

MsgAlert("Altera็ใo realizada com sucesso!")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fCalcLCบ Autor ณ Gustavo Costa        บ Data ณ  07/08/12     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular o Limite de Compra     บฑฑ
ฑฑบ          ณ dos clientes.                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fCalcLC(cliente, loja, media, dIni, dFim)

Local cQuery		:= ''
Local nRet			:= 0
Local nMedia		:= media
Local nCont		:= 0
Local nTotal 		:= 0
Local cCli      	:= cliente
Local cLoja		:= loja
Local nDiasMed	:= 0

//////////seleciona os dados
If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQuery := " SELECT SUM(convert(int, CONVERT(datetime, E1_VENCREA) - CONVERT(datetime, E1_EMIS1) )) SOMA, COUNT(*) QTD_TIT, "
cQuery += " SUM(E1_VALOR) VTOTAL "
cQuery += " FROM " + RetSqlName("SE1") + " E1 "
cQuery += " WHERE E1_CLIENTE = '" + cCli + "' "
cQuery += " AND E1_LOJA = '" + cLoja + "' "
cQuery += " AND E1_EMIS1 BETWEEN '" + DtoS(dIni) + "' AND '" + DtoS(dFim) + "' "
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " AND E1_TIPO NOT IN ('NCC','PA') "

TCQUERY cQuery NEW ALIAS "TMP"
		
TMP->( DbGoTop() )

//Divide a soma dos dias de prazo dos titulos pela quantidade de titulos
nDiasMed	:= TMP->SOMA / TMP->QTD_TIT 
//O fator ้ o prazo m้dio dividido por 30 dias
nFator		:= nDiasMed / 30

If nFator < 1
	nFator := 1
EndIf

Do Case
	Case nMedia	>= 45	//Maior credito
		
		nRet	:= TMP->VTOTAL / nFator

	Case nMedia	>= 30 .AND. nMedia	< 45 //media de credito

		nRet	:= (TMP->VTOTAL / nFator)* 0.8
		
	Case nMedia	>= 20 .AND. nMedia	< 30    //menor credito

		nRet	:= (TMP->VTOTAL / nFator)* 0.6

	OtherWise    //sem credito
		nRet	:= 0
EndCase

//TMP->(dbcloseArea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณValidPerg บ Autor ณ AP6 IDE            บ Data ณ  20/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Valida ao grupo de perguntas. Caso noa exista, cria.       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg()

Local _sAlias 	:= Alias()
Local aHelpPor	:= {}

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,6)

If !dbSeek(cPerg)//+aRegs[i,2])
	PutSx1( cPerg,'01','Data Inicial?' 	,'','','mv_ch1','D',8,0,0,'G','','','','','mv_par01','','','',''	,'','','','','','','','','','','','',{"Data de Emissao Inicial"},{},{} )
	PutSx1( cPerg,'02','Data Final?'   	,'','','mv_ch2','D',8,0,0,'G','','','','','mv_par02','','','',''  	,'','','','','','','','','','','','',{"Data de Emissao Final."},{},{} )
	PutSx1( cPerg,'03','Do Cliente'       	,'','','mv_ch3','C',6,0,0,'G','','SA1','','','mv_par03','','','',''   ,'','','','','','','','','','','','',{"Cliente Inicial"},{},{} )
	PutSx1( cPerg,'04','At้ Cliente'		,'','','mv_ch4','C',6,0,0,'G','','SA1','','','mv_par04','','','',''  ,'','','','','','','','','','','','',{"Cliente Final"},{},{} )
	PutSx1( cPerg,'05','Da Loja'       	,'','','mv_ch5','C',2,0,0,'G','','','','','mv_par05','','','',''     	,'','','','','','','','','','','','',{"Loja Inical"},{},{} )
	PutSx1( cPerg,'06','Ate Loja'			,'','','mv_ch6','C',2,0,0,'G','','','','','mv_par06','','','',''  	,'','','','','','','','','','','','',{"Loja Final"},{},{} )
Endif

dbSelectArea(_sAlias)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCriaTAB     บ Autor ณ Gustavo Costa  บ Data ณ  27/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Cria a tabela temporaria de cada recurso.                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fCriaTAB()

Local aFds	:= {}
Private cTRAB	:= ""
Private cTAB	:= "XE1"

Aadd( aFds , {"COD"   	,"C",006,000} )
Aadd( aFds , {"LOJA"  	,"C",002,000} )
Aadd( aFds , {"NOME"  	,"C",040,000} )
Aadd( aFds , {"A"  		,"N",006,002} )
Aadd( aFds , {"B"  		,"N",006,002} )
Aadd( aFds , {"C"  		,"N",006,002} )
Aadd( aFds , {"D"  		,"N",006,002} )
Aadd( aFds , {"E"  		,"N",006,002} )
Aadd( aFds , {"RES"  	,"N",006,002} )
Aadd( aFds , {"VENCIDO" 	,"N",014,002} )
Aadd( aFds , {"AVENCER" 	,"N",014,002} )
Aadd( aFds , {"LCC"  	,"N",014,002} )
Aadd( aFds , {"RISCO"  	,"C",001,000} )

cTRAB := CriaTrab( aFds, .T. )
Use (cTRAB) Alias &cTAB New Exclusive
IndRegua(cTAB,cTRAB,"COD+LOJA",,,'Selecionando Registros...') //'Selecionando Registros...'

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MCoBrwOP      บ Autor ณ Gustavo Costa  บ Data ณ  03/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Monta o aCols										      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MHoBrw1()

Local aAux := {}

Aadd(aCoBrw1,Array(noBrw1+1))

Aadd( aHoBrw1 , {"Codigo"		,"COD"		,"@!"					,006,000,"AllwaysTrue()","๛","C"} )
Aadd( aHoBrw1 , {"loja"			,"LOJA"	,"@!"					,002,000,"AllwaysTrue()","๛","C"} )
Aadd( aHoBrw1 , {"Nome"			,"NOME"	,"@!"					,040,000,"AllwaysTrue()","๛","C"} )
Aadd( aHoBrw1 , {"Classe A"		,"A"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Classe B"		,"B"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Classe C"		,"C"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Classe D"		,"D"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Classe E"		,"E"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Result."		,"RES"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"R$ Vencido"	,"VENCIDO"	,"@E 9,999,999.99"	,014,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"R$ A vencer"	,"AVENCER"	,"@E 9,999,999.99"	,014,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"LC Calc."		,"LCC"		,"@E 9,999,999.99"	,014,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Risco"			,"RISCO"	,"@!"					,001,000,"Pertence('A,B,C,D,E')","๛","C"} )

For nI := 1 To noBrw1
	
	Do Case
		Case aHoBrw1[nI][2] = "COD"
			aCoBrw1[1][nI] := CriaVar("A1_COD")
		Case aHoBrw1[nI][2] = "LOJA"
			aCoBrw1[1][nI] := CriaVar("A1_LOJA")
		Case aHoBrw1[nI][2] $ "A#B#C#D#E#RES"
			aCoBrw1[1][nI] := CriaVar("E1_PORCJUR")
		Case aHoBrw1[nI][2] $ "LCC#VENCIDO#AVENCER"
			aCoBrw1[1][nI] := CriaVar("A1_LC")
		Case aHoBrw1[nI][2] = "RISCO"
			aCoBrw1[1][nI] := CriaVar("A1_RISCO")
	EndCase

Next
aCoBrw1[1][noBrw1+1] := .F.
	
Return
        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AtAcols1()  บ Autor ณ Gustavo Costa   บ Data ณ  03/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Atualiza o aCols1 - XMP                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MCoBrw1()

Local aAux 	:= {}
local nI	:= 1

dbSelectArea("XE1")
XE1->(dbgoTop())

aCoBrw1 := {}

While XE1->(!EOF())

	Aadd(aCoBrw1,Array(noBrw1+1))
	aCoBrw1[Len(aCoBrw1)][01] := XE1->COD
	aCoBrw1[Len(aCoBrw1)][02] := XE1->LOJA
	aCoBrw1[Len(aCoBrw1)][03] := XE1->NOME
	aCoBrw1[Len(aCoBrw1)][04] := XE1->A
	aCoBrw1[Len(aCoBrw1)][05] := XE1->B
	aCoBrw1[Len(aCoBrw1)][06] := XE1->C
	aCoBrw1[Len(aCoBrw1)][07] := XE1->D
	aCoBrw1[Len(aCoBrw1)][08] := XE1->E
	aCoBrw1[Len(aCoBrw1)][09] := XE1->RES
	aCoBrw1[Len(aCoBrw1)][10] := XE1->VENCIDO
	aCoBrw1[Len(aCoBrw1)][11] := XE1->AVENCER
	aCoBrw1[Len(aCoBrw1)][12] := XE1->LCC
	aCoBrw1[Len(aCoBrw1)][13] := XE1->RISCO
	aCoBrw1[Len(aCoBrw1)][noBrw1+1] := .F.
    
	XE1->(dbSkip())
EndDo

//oBrw1:oBrowse:Refresh()
     
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fLegenda()  บ Autor ณ Gustavo Costa   บ Data ณ  03/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Mostra a legenda da rotina                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fLegenda()

Local cTexto := ""
Local _EOL   := CHR(13) + CHR(10)
/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
SetPrvt("oDlg2","oMGet1")

cTexto	:= " PONTUAวรO		   		REGRAS " + _EOL
cTexto	+= " > = 45 pontos			Conceder 100% do valor comprado nos ๚ltimos 6 meses. " + _EOL
cTexto	+= " De 30 a 45 pontos		Conceder 80% do valor comprado nos ๚ltimos 6 meses. " + _EOL
cTexto	+= " De 20 a 30 pontos		Conceder 60% do valor comprado nos ๚ltimos 6 meses. " + _EOL
cTexto	+= " De 10 a 20 pontos		Credito por pedido. " + _EOL
cTexto	+= " < 10 pontos   			Pagamento antecipado. " + _EOL
//cTexto	+= " Fatura em aberto		Rejeitar solicita็ใo. " + _EOL


/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
oDlg2      := MSDialog():New( 126,254,272,775,"Legenda",,,.F.,,,,,,.T.,,,.F. )
oMGet1     := TMultiGet():New( 000,000,,oDlg2,258,071,,,CLR_BLACK,CLR_WHITE,,.T.,"Legenda",,,.F.,.F.,.T.,,,.F.,,  )
oMGet1:bSetGet := {|u| If(PCount()>0,cTexto:=u,cTexto)}

oDlg2:Activate(,,,.T.)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fSaldoTit บ Autor ณ Gustavo Costa     บ Data ณ  07/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular o saldo de titulos   บฑฑ
ฑฑบ          ณ em aberto dos clientes.                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fSaldoTit(cCli, cLoja)

Local cQuery	:=''
Local aRet		:= {}

//////////seleciona os dados
//cQuery := " SELECT SUM(E1_SALDO) SALDO FROM " + RetSqlName("SE1") 
cQuery := " SELECT " 
cQuery += " SUM( CASE WHEN E1_VENCREA < '" + DtoS(dDataBase) + "' THEN E1_SALDO ELSE 0 END ) VENCIDO, "
cQuery += " SUM( CASE WHEN E1_VENCREA >= '" + DtoS(dDataBase) + "' THEN E1_SALDO ELSE 0 END ) AVENCER "
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

aRet := {XSAL->VENCIDO, XSAL->AVENCER}

Return aRet


