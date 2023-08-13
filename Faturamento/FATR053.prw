// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : FATR053
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 20/02/18 | Gustavo Costa     | CRM 50 Melhores cliente.
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
User function FATR053()
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
Private cPerg  	:= "FATR53"

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
Aadd( aButtons, {"SIMULACA", {|| Processa({|| expExcel()}) }, "Exporta Excel", "Exporta Excel" , {|| .T.}} )
//Aadd( aButtons, {"MDIHELP", {|| fLegenda()}, "Legenda", "Legenda" , {|| .T.}} )

oDlg1      := MSDialog():New( 0, 0, aSizeAut[6], aSizeAut[5]-5,"Melhores Clientes",,,.F.,,,,,,.T.,,,.F. )
oDlg1:bInit := {|| EnchoiceBar(oDlg1,{|| oDlg1:End() }, {|| oDlg1:End()},,aButtons) }

//ValidPerg()

Pergunte(cPerg,.T.)

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
Local nFatMes	:= fFatMes(FirstDay(mv_par01), LastDay(mv_par01))

fCriaTAB()

//////////seleciona os dados

cQuery := " SELECT TOP " + Alltrim(STR(mv_par02)) + " A3_NREDUZ, A1_COD, A1_LOJA, A1_NREDUZ, F2_EST, "   
cQuery += "         SUM( (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ) AS 'FATANO', "
cQuery += "         SUM( (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN )/12 AS 'MEDIA', "
cQuery += "         AVG(E4_PRZMED) AS 'PRAZOM' "
cQuery += "         FROM SD2020 SD2 WITH (NOLOCK) " 
cQuery += "         INNER JOIN SF2020 SF2 WITH (NOLOCK) " 
cQuery += "         ON D2_FILIAL = F2_FILIAL " 
cQuery += "         AND D2_DOC = F2_DOC "
cQuery += "         AND D2_SERIE = F2_SERIE " 
cQuery += "         INNER JOIN SA1010 SA1 WITH (NOLOCK) " 
cQuery += "         ON F2_CLIENTE + F2_LOJA = A1_COD + A1_LOJA "
cQuery += "        	INNER JOIN SE4010 SE4 "
cQuery += "			ON F2_COND = E4_CODIGO " 
cQuery += "        	INNER JOIN SA3010 SA3 WITH (NOLOCK) " 
cQuery += "        	ON A1_VEND = A3_COD "
cQuery += "         WHERE " 
cQuery += "         SUBSTRING(SD2.D2_CF,1,2) IN ('51','61','59','69') AND " 
cQuery += " 		D2_EMISSAO BETWEEN '" + DtoS(ddatabase - 365) + "' AND '" + DtoS(ddatabase - 1) + "' AND "
cQuery += "         SF2.D_E_L_E_T_ =   ''   AND " 
cQuery += "         SA1.D_E_L_E_T_ =   ''   AND " 
cQuery += "         SA3.D_E_L_E_T_ =   ''   AND " 
cQuery += "         SE4.D_E_L_E_T_ =   ''   AND " 
cQuery += "         SD2.D_E_L_E_T_ =   '' "    
cQuery += "         GROUP BY A3_NREDUZ, A1_COD, A1_LOJA, A1_NREDUZ, F2_EST " 
cQuery += "         ORDER BY 6 DESC  "

//MemoWrite("C:\Temp\FINR008.sql", cQuery )

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
		aSaldo	:= fSaldoTit(SE1X->A1_COD, SE1X->A1_LOJA)
		RecLock("XE1", .T.)
		XE1->VEND		:= SE1X->A3_NREDUZ
		XE1->COD		:= SE1X->A1_COD
		XE1->LOJA		:= SE1X->A1_LOJA
		XE1->NOME		:= SE1X->A1_NREDUZ
		XE1->FATM		:= fCalcFat(SE1X->A1_COD, SE1X->A1_LOJA, FirstDay(mv_par01), LastDay(mv_par01))
		XE1->FATMA		:= fCalcFat(SE1X->A1_COD, SE1X->A1_LOJA, FirstDay(FirstDay(mv_par01)-1), FirstDay(mv_par01)-1)
		XE1->FATAA		:= fCalcFat(SE1X->A1_COD, SE1X->A1_LOJA, FirstDay(mv_par01 - 365), LastDay(mv_par01 -365))
		XE1->MEDIAFAT	:= SE1X->MEDIA
		XE1->QTDPED		:= fQtdPed(SE1X->A1_COD, SE1X->A1_LOJA, FirstDay(mv_par01), LastDay(mv_par01))
		XE1->PRZM		:= SE1X->PRAZOM
		XE1->VENCIDO	:= aSaldo[1]
		XE1->AVENCER	:= aSaldo[2]
		XE1->PERC		:= (XE1->FATM / nFatMes) * 100

		XE1->(MsUnLock())

		SE1X->(Dbskip())
		IncProc(SE1X->A1_COD + " - " + SE1X->A1_NREDUZ)

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
ฑฑบFuno    ณ fCalcFat Autor ณ Gustavo Costa        บ Data ณ  07/08/12     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular faturamento do cliente บฑฑ
ฑฑบ          ณ dos clientes.                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fCalcFat(cCli, cLoja, dIni, dFim)

Local cQuery		:= ''
Local nRet			:= 0

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQuery := " SELECT SUM( (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ) AS 'FAT' "
cQuery += "         FROM SD2020 SD2 WITH (NOLOCK) " 
cQuery += "         WHERE " 
cQuery += " 		D2_CLIENTE = '" + cCli + "' AND "
cQuery += " 		D2_LOJA = '" + cLoja + "' AND "
cQuery += "         SUBSTRING(SD2.D2_CF,1,2) IN ('51','61','59','69') AND " 
cQuery += "         SD2.D2_EMISSAO BETWEEN '" + DtoS(dIni) + "' AND '" + DtoS(dFim) + "' AND "
cQuery += "         SD2.D_E_L_E_T_ =   '' "

TCQUERY cQuery NEW ALIAS "TMP"
		
TMP->( DbGoTop() )

If TMP->(!EOF())
	nRet := TMP->FAT
EndIf

TMP->(dbcloseArea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fFatMes Autor ณ Gustavo Costa        บ Data ณ  07/08/12     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular faturamento do mes     บฑฑ
ฑฑบ          ณ dos clientes.                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fFatMes(dIni, dFim)

Local cQuery		:= ''
Local nRet			:= 0

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQuery := " SELECT SUM( (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ) AS 'FAT' "
cQuery += "         FROM SD2020 SD2 WITH (NOLOCK) " 
cQuery += "         WHERE " 
//cQuery += " 		D2_CLIENTE = '" + cCli + "' AND "
//cQuery += " 		D2_LOJA = '" + cLoja + "' AND "
cQuery += "         SUBSTRING(SD2.D2_CF,1,2) IN ('51','61','59','69') AND " 
cQuery += "         SD2.D2_EMISSAO BETWEEN '" + DtoS(dIni) + "' AND '" + DtoS(dFim) + "' AND "
cQuery += "         SD2.D_E_L_E_T_ =   '' "

TCQUERY cQuery NEW ALIAS "TMP"
		
TMP->( DbGoTop() )

If TMP->(!EOF())
	nRet := TMP->FAT
EndIf

TMP->(dbcloseArea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fQtdPed Autor ณ Gustavo Costa        บ Data ณ  07/08/12     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular qtd pedido do cliente บฑฑ
ฑฑบ          ณ dos clientes.                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fQtdPed(cCli, cLoja, dIni, dFim)

Local cQuery		:= ''
Local nRet			:= 0

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

cQuery := " SELECT COUNT(*) AS 'PED' "
cQuery += "         FROM SC5020 SC5 WITH (NOLOCK) " 
cQuery += "         WHERE " 
cQuery += " 		C5_CLIENTE = '" + cCli + "' AND "
cQuery += " 		C5_LOJACLI = '" + cLoja + "' AND "
cQuery += "         SC5.C5_EMISSAO BETWEEN '" + DtoS(dIni) + "' AND '" + DtoS(dFim) + "' AND "
cQuery += "         SC5.D_E_L_E_T_ =   '' "

TCQUERY cQuery NEW ALIAS "TMP"
		
TMP->( DbGoTop() )

If TMP->(!EOF())
	nRet := TMP->PED
EndIf

TMP->(dbcloseArea())

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
	PutSx1( cPerg,'01','Data Ref?' 		,'','','mv_ch1','D',8,0,0,'G','','','','','mv_par01','','','',''	,'','','','','','','','','','','','',{"Data de Emissao Inicial"},{},{} )
	//PutSx1( cPerg,'02','Data Final?'   	,'','','mv_ch2','D',8,0,0,'G','','','','','mv_par02','','','',''  	,'','','','','','','','','','','','',{"Data de Emissao Final."},{},{} )
	//PutSx1( cPerg,'03','Do Cliente'       	,'','','mv_ch3','C',6,0,0,'G','','SA1','','','mv_par03','','','',''   ,'','','','','','','','','','','','',{"Cliente Inicial"},{},{} )
	//PutSx1( cPerg,'04','At้ Cliente'		,'','','mv_ch4','C',6,0,0,'G','','SA1','','','mv_par04','','','',''  ,'','','','','','','','','','','','',{"Cliente Final"},{},{} )
	//PutSx1( cPerg,'05','Da Loja'       	,'','','mv_ch5','C',2,0,0,'G','','','','','mv_par05','','','',''     	,'','','','','','','','','','','','',{"Loja Inical"},{},{} )
	//PutSx1( cPerg,'06','Ate Loja'			,'','','mv_ch6','C',2,0,0,'G','','','','','mv_par06','','','',''  	,'','','','','','','','','','','','',{"Loja Final"},{},{} )
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

Aadd( aFds , {"VEND"   	,"C",020,000} )
Aadd( aFds , {"COD"   	,"C",006,000} )
Aadd( aFds , {"LOJA"  	,"C",002,000} )
Aadd( aFds , {"NOME"  	,"C",040,000} )
Aadd( aFds , {"FATM"  	,"N",012,002} )
Aadd( aFds , {"FATMA"  	,"N",012,002} )
Aadd( aFds , {"FATAA"  	,"N",012,002} )
Aadd( aFds , {"MEDIAFAT","N",012,002} )
Aadd( aFds , {"QTDPED"  ,"N",006,000} )
Aadd( aFds , {"PRZM"  	,"N",006,000} )
Aadd( aFds , {"VENCIDO" ,"N",014,002} )
Aadd( aFds , {"AVENCER" ,"N",014,002} )
Aadd( aFds , {"PERC"  	,"N",014,002} )

cTRAB := CriaTrab( aFds, .T. )
Use (cTRAB) Alias &cTAB New Exclusive
//IndRegua(cTAB,cTRAB,"COD+LOJA",,,'Selecionando Registros...') //'Selecionando Registros...'

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

Aadd( aHoBrw1 , {"Vendedor"		,"VEND"		,"@!"				,020,000,"AllwaysTrue()","๛","C"} )
Aadd( aHoBrw1 , {"Codigo"		,"COD"		,"@!"				,006,000,"AllwaysTrue()","๛","C"} )
Aadd( aHoBrw1 , {"loja"			,"LOJA"		,"@!"				,002,000,"AllwaysTrue()","๛","C"} )
Aadd( aHoBrw1 , {"Nome"			,"NOME"		,"@!"				,040,000,"AllwaysTrue()","๛","C"} )
Aadd( aHoBrw1 , {"Fat. Mes"		,"FATM"		,"@E 9,999,999.99"	,012,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Fat. Mes Ant.","FATMA"	,"@E 9,999,999.99"	,012,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Fat. Mes AA."	,"FATAA"	,"@E 9,999,999.99"	,012,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Fat. Medio"	,"MEDIAFAT"	,"@E 9,999,999.99"	,012,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Qtd. Ped. Mes","QTDPED"	,"@E 99,999"		,006,000,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Prazo Med."	,"PRZM"		,"@E 99,999"		,006,000,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Tit. Vencidos","VENCIDO"	,"@E 9,999,999.99"	,012,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"Tit A Vencer"	,"AVENCER"	,"@E 9,999,999.99"	,012,002,"AllwaysTrue()","๛","N"} )
Aadd( aHoBrw1 , {"% Fat X Geral","PERC"		,"@E 9,999,999.99"	,006,002,"AllwaysTrue()","๛","N"} )

For nI := 1 To noBrw1
	
	Do Case
		Case aHoBrw1[nI][2] = "COD"
			aCoBrw1[1][nI] := CriaVar("A1_COD")
		Case aHoBrw1[nI][2] = "LOJA"
			aCoBrw1[1][nI] := CriaVar("A1_LOJA")
		Case aHoBrw1[nI][2] $ "FATM#FATMA#FATAA#MEDIAFAT#QTDPED#PRZM"
			aCoBrw1[1][nI] := CriaVar("E1_SALDO")
		Case aHoBrw1[nI][2] $ "VENCIDO#AVENCER"
			aCoBrw1[1][nI] := CriaVar("A1_LC")
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
	aCoBrw1[Len(aCoBrw1)][01] := XE1->VEND
	aCoBrw1[Len(aCoBrw1)][02] := XE1->COD
	aCoBrw1[Len(aCoBrw1)][03] := XE1->LOJA
	aCoBrw1[Len(aCoBrw1)][04] := XE1->NOME
	aCoBrw1[Len(aCoBrw1)][05] := XE1->FATM
	aCoBrw1[Len(aCoBrw1)][06] := XE1->FATMA
	aCoBrw1[Len(aCoBrw1)][07] := XE1->FATAA
	aCoBrw1[Len(aCoBrw1)][08] := XE1->MEDIAFAT
	aCoBrw1[Len(aCoBrw1)][09] := XE1->QTDPED
	aCoBrw1[Len(aCoBrw1)][10] := XE1->PRZM
	aCoBrw1[Len(aCoBrw1)][11] := XE1->VENCIDO
	aCoBrw1[Len(aCoBrw1)][12] := XE1->AVENCER
	aCoBrw1[Len(aCoBrw1)][13] := XE1->PERC
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

Static Function expExcel()

	Local oFWMsExcel
	Local oExcel
	Local cArquivo	:= GetTempPath()+'FATR53.xml'

	//Criando o objeto que irแ gerar o conte๚do do Excel
	oFWMsExcel := FWMSExcel():New()
	
	//Aba 01 - Teste
	oFWMsExcel:AddworkSheet("FATR53") //Nใo utilizar n๚mero junto com sinal de menos. Ex.: 1-
		//Criando a Tabela
		oFWMsExcel:AddTable("FATR53","Titulo Tabela")
		//Criando Colunas
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","Vendedor",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","Codigo",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","loja",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","Nome",3,3) //3 = Valor com R$
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","Fat. Mes",2,2)
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","Fat. Mes Ant.",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","Fat. Mes AA.",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","Fat. Medio",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","Qtd. Ped. Mes",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","Prazo Med.",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","Tit. Vencidos",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","Tit A Vencer",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("FATR53","Titulo Tabela","% Fat X Geral",2,2) //2 = Valor sem R$
		//Criando as Linhas
		XE1->(dbGoTop())
		While !(XE1->(EoF()))
			oFWMsExcel:AddRow("FATR53","Titulo Tabela",{;
															XE1->VEND,;
															XE1->COD,;
															XE1->LOJA,;
															XE1->NOME,;
															XE1->FATM,;
															XE1->FATMA,;
															XE1->FATAA,;
															XE1->MEDIAFAT,;
															XE1->QTDPED,;
															XE1->PRZM,;
															XE1->VENCIDO,;
															XE1->AVENCER,;
															XE1->PERC;
															})
		
			//Pulando Registro
			XE1->(DbSkip())
		EndDo
	
	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)
		
	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New() 			//Abre uma nova conexใo com Excel
	oExcel:WorkBooks:Open(cArquivo) 	//Abre uma planilha
	oExcel:SetVisible(.T.) 				//Visualiza a planilha
	oExcel:Destroy()						//Encerra o processo do gerenciador de tarefas
	
	//QRYPRO->(DbCloseArea())
	//RestArea(aArea)
Return
