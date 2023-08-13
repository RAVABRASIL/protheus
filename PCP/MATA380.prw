#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑณPrograma  :MATR380X ณ Autor :Gustavo Costa          ณ Data :13/11/2013 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao : Rotina feita para realizar o controle dos empenhos e as    ณฑฑ
ฑฑณ            transferencias dos armazens para as OPดs                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametros:                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   :                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       :                                                            ณฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function MATR380X()

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Local aCampos		:= {}
Local nOpc 		:= GD_INSERT+GD_DELETE+GD_UPDATE
Local aObjects  	:= {}
Local aSizeAut  	:= MsAdvSize()

Private aHeader	:= {}
Private aCols	:= {}
Private NOBRW1 	:= 10
Private cOP		:= "           "
Private cMark   	:= GetMark()
Private _cProduto	:= ""
Private aAlter	:= {}
Private coTbl1

AADD(aAlter,'D4_TRANSF')

lInverte := .F.

SetPrvt("oFont1","oDlg1","oGrp1","oBrw1","oSBtn1","oSBtn2","oSay1","oGet1","oSBtn3","_cProduto")

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
oFont1     := TFont():New( "Arial Black",0,-21,,.F.,0,,400,.F.,.F.,,,,,, )

AAdd( aObjects, { 050, 050, .T., .T. } )
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 0, 0 }
aPosObj := MsObjSize( aInfo, aObjects, .T. )


//cria tabela temporaria
oTbl1()

AADD(aCampos,{"D4_OP" 		,"","OP"	  			,""  	})					
AADD(aCampos,{"D4_COD" 		,"","Produto"			,""  	})					
AADD(aCampos,{"D4_DESC"		,"","Nome" 			,""		})					
AADD(aCampos,{"D4_LOCAL"		,"","Local" 			,""		})					
AADD(aCampos,{"D4_QTDEORI"	,"","Qtd. Empenho"	,PesqPict('SD4','D4_QTDEORI')	})					
AADD(aCampos,{"D4_QUANT"		,"","Sal. Empenho"	,PesqPict('SD4','D4_QUANT')		})
AADD(aCampos,{"D4_QTSEGUM"	,"","Sal. Emp. 2UM"	,PesqPict('SD4','D4_QTSEGUM')	})
AADD(aCampos,{"D4_SALDO"		,"","Sal. 01"			,PesqPict('SD4','D4_QUANT')		})
AADD(aCampos,{"D4_TRANSF"	,"","Transfere"	 	,PesqPict('SD4','D4_QUANT')		})
AADD(aCampos,{"D4_TRANSF2"	,"","Transferido"	 	,PesqPict('SD4','D4_QUANT')		})

oDlg1      := MSDialog():New( 0, 0, aSizeAut[6], aSizeAut[5]-5,"Ajuste de empenho e transfer๊ncias",,,.F.,,,,,,.T.,,,.F. )
//126,254,626,1259
oGrp1      := TGroup():New( 004,003,044,496,"Selecione a OP",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGet1      := TGet():New( 020,012,{|u| If(PCount()>0,cOP:=u,cOP)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC2","cOP",,)
oGet1:bValid := {|| NaoVazio() }

//oSBtn3     := SButton():New( 020,080,1,{ || fCarregaOP( cOP ) },oGrp1,,"", )
oBtn1      := TButton():New( 019,076,"&Carregar",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := { || Processa({ || fCarregaOP( cOP ) }) }

oSay1      := TSay():New( 016,124,{|| _cProduto },oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,336,016)

DbSelectArea("TMP1")

cLinhaOk:="U_fSegUM() .and. U_fVldTR()"
cTudOk:="AllwaysTrue()"

//Monta o aHeader com aCols em branco
MHoBrw1()

oBrw1     	:= MsNewGetDados():New(044,003,aPosObj[1][3], aPosObj[1][4]-5,nOpc,cLinhaOk,cTudOk,'',{'D4_TRANSF'},0,99,'AllwaysTrue()','',.F.,oDlg1,aHeader,aCols )
oBrw1:EditAction("D4_QTDEORI") := {|| U_fSegUM()}
//044,003,234,496

oSBtn1     := SButton():New( aPosObj[1][3], aPosObj[1][4]-80,1,{|| Processa({|| U_fMyMata261()}) },oDlg1,,"Confirmar", )
oSBtn2     := SButton():New( aPosObj[1][3], aPosObj[1][4]-40,2,{|| oDlg1:End() },oDlg1,,"Sair", )

oDlg1:Activate(,,,.T.)

Return

**************************
Static Function oTbl1()
**************************

Local aCampos := {}

AADD(aCampos,{"D4_OP"		,"C",011,000})		
AADD(aCampos,{"D4_COD" 		,"C",015,000})					
AADD(aCampos,{"D4_DESC"		,"C",050,000})					
AADD(aCampos,{"D4_LOCAL"		,"C",002,000})					
AADD(aCampos,{"D4_QTDEORI"	,"N",018,006})					
AADD(aCampos,{"D4_QUANT"		,"N",018,006})
Aadd(aCampos,{"D4_QTSEGUM"	,"N",018,006})
AADD(aCampos,{"D4_SALDO"		,"N",018,006})
Aadd(aCampos,{"D4_TRANSF"	,"N",018,006})
Aadd(aCampos,{"D4_TRANSF2"	,"N",018,006})

coTbl1 := CriaTrab( aCampos, .T. )
Use (coTbl1) Alias TMP1 New Exclusive

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fCarregaOP บ Autor ณ Gustavo Costa      บ Data ณ  13/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao para carregar os empenhos da OP na tela de manuten็ใo บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fCarregaOP( cOP )

Local cQuery	:= ""
//MsgAlert(cOP)

cQuery	:= " SELECT * FROM " + RETSQLNAME("SD4") + " D4 "
cQuery	+= " WHERE D4_OP LIKE '" + AllTrim(cOP) + "%'" 
cQuery	+= " AND D4_FILIAL = '" + xFilial("SD4") + "' "
cQuery	+= " AND D_E_L_E_T_ <> '*' "
cQuery	+= " ORDER BY D4_OP, D4_COD "

//Se tiver alguma OP no aCols, limpa para carregar outra
If !Empty(oBrw1:aCols[1][1])

	TMP1->(dbGoTop())
	
	While TMP1->(!EOF())
		dbDelete()
		TMP1->(dbSkip())
	EndDo
	 
EndIf

If Select("TMPX") > 0
	TMPX->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "TMPX"
TMPX->(dbGoTop())

WHILE !TMPX->(EOF())
	
	RECLOCK("TMP1",.T.)
		TMP1->D4_OP  		:= TMPX->D4_OP
		TMP1->D4_COD  	:= TMPX->D4_COD
		TMP1->D4_DESC 	:= POSICIONE("SB1",1,XFILIAL("SB1") + TMPX->D4_COD, 'B1_DESC')
		TMP1->D4_LOCAL 	:= TMPX->D4_LOCAL
		TMP1->D4_QTDEORI 	:= TMPX->D4_QTDEORI
		TMP1->D4_QUANT 	:= TMPX->D4_QUANT
		TMP1->D4_QTSEGUM 	:= TMPX->D4_QTSEGUM
		TMP1->D4_SALDO 	:= IIF(LEFT(TMPX->D4_COD,3) == "MOD",0,fSaldoAtu(TMPX->D4_COD))
		TMP1->D4_TRANSF 	:= 0
		TMP1->D4_TRANSF2 	:= IIF(LEFT(TMPX->D4_COD,3) == "MOD",0,fSaldoTransf(TMPX->D4_COD, TMPX->D4_OP))
	MsUnLock()
	TMPX->(DbSKIP())

EndDO

TMPX->(DbCloseArea())

dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2") + Alltrim(cOP))

_cProduto := POSICIONE("SB1",1,XFILIAL("SB1") + SC2->C2_PRODUTO, 'B1_DESC')

dbSelectArea("TMP1")
TMP1->(dbGoTop())

//MHoBrw1()
MCoBrw1()
oBrw1:oBrowse:Refresh()

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

Aadd(aCols,Array(noBrw1+1))

Aadd( aHeader , {"Ordem de Prod."	,"D4_OP"			,"@!"								,011,000,"AllwaysTrue()","๛","C"} )
Aadd( aHeader , {"Codigo"			,"D4_COD"			,"@!"								,015,000,"AllwaysTrue()","๛","C"} )
Aadd( aHeader , {"Produto"			,"D4_DESC"			,"@!"								,050,000,"AllwaysTrue()","๛","C"} )
Aadd( aHeader , {"Armazem"			,"D4_LOCAL"		,"@!"								,002,000,"AllwaysTrue()","๛","C"} )
Aadd( aHeader , {"Qtd. Empenho"		,"D4_QTDEORI"		,PesqPict('SD4','D4_QTDEORI') 	,018,006,"AllwaysTrue()","๛","N"} )
Aadd( aHeader , {"Sal. Empenho"		,"D4_QUANT"		,PesqPict('SD4','D4_QUANT') 	,018,006,"AllwaysTrue()","๛","N"} )
Aadd( aHeader , {"Sal. Emp. 2UM"	,"D4_QTSEGUM"		,PesqPict('SD4','D4_QTSEGUM')	,018,006,"AllwaysTrue()","๛","N"} )
Aadd( aHeader , {"Saldo 01"			,"D4_SALDO"		,PesqPict('SD4','D4_QUANT') 	,018,006,"AllwaysTrue()","๛","N"} )
Aadd( aHeader , {"Transfere"		,"D4_TRANSF"		,PesqPict('SD4','D4_QTSEGUM')	,018,006,"AllwaysTrue()","๛","N"} )
Aadd( aHeader , {"Transferido"		,"D4_TRANSF2"		,PesqPict('SD4','D4_QTSEGUM')	,018,006,"AllwaysTrue()","๛","N"} )

For nI := 1 To noBrw1
	
	Do Case
		Case aHeader[nI][2] = "D4_OP"
			aCols[1][nI] := CriaVar("D4_OP")
		Case aHeader[nI][2] = "D4_COD"
			aCols[1][nI] := CriaVar("B1_COD")
		Case aHeader[nI][2] = "D4_DESC"
			aCols[1][nI] := CriaVar("B1_DESC")
		Case aHeader[nI][2] = "D4_LOCAL"
			aCols[1][nI] := CriaVar("D4_LOCAL")
			AADD(aAlter,aHeader[nI][2])	
		Case aHeader[nI][2] $ "D4_QTDEORI#D4_QUANT#D4_QTSEGUM#D4_TRANSF2#D4_SALDO"
			aCols[1][nI] := CriaVar("D4_QUANT")
			AADD(aAlter,aHeader[nI][2])	
	EndCase

Next
aCols[1][noBrw1+1] := .F.
	
Return
        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AtAcols1()  บ Autor ณ Gustavo Costa   บ Data ณ  14/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Atualiza o aCols1 - TMP1                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function MCoBrw1()

Local aAux 	:= {}
local nI	:= 1

dbSelectArea("TMP1")
TMP1->(dbgoTop())

aCols := {}
oBrw1:aCols := {}

While TMP1->(!EOF())

	Aadd(oBrw1:aCols,Array(noBrw1+1))
	oBrw1:aCols[Len(oBrw1:aCols)][01] := TMP1->D4_OP
	oBrw1:aCols[Len(oBrw1:aCols)][02] := TMP1->D4_COD
	oBrw1:aCols[Len(oBrw1:aCols)][03] := TMP1->D4_DESC
	oBrw1:aCols[Len(oBrw1:aCols)][04] := TMP1->D4_LOCAL
	oBrw1:aCols[Len(oBrw1:aCols)][05] := TMP1->D4_QTDEORI
	oBrw1:aCols[Len(oBrw1:aCols)][06] := TMP1->D4_QUANT
	oBrw1:aCols[Len(oBrw1:aCols)][07] := TMP1->D4_QTSEGUM
	oBrw1:aCols[Len(oBrw1:aCols)][08] := TMP1->D4_SALDO
	oBrw1:aCols[Len(oBrw1:aCols)][09] := TMP1->D4_TRANSF
	oBrw1:aCols[Len(oBrw1:aCols)][10] := TMP1->D4_TRANSF2
	oBrw1:aCols[Len(oBrw1:aCols)][noBrw1+1] := .F.
    
	TMP1->(dbSkip())
EndDo

//oBrw1:oBrowse:Refresh()
     
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fCarregaOP บ Autor ณ Gustavo Costa      บ Data ณ  13/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao para carregar os empenhos da OP na tela de manuten็ใo บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MyMata380()

Local aVetor := {}
Local nOpc   := 3 // Inclusใo

lMsErroAuto := .F.
aVetor:={ {"D4_COD" ,"PROD001 ",Nil},; //COM O TAMANHO EXATO DO CAMPO
			{"D4_LOCAL" 		,"00"                 ,Nil},;
			{"D4_OP" ,"00000101001"        ,Nil},;
			{"D4_DATA" ,dDatabase        ,Nil},;
			{"D4_QTDEORI",10                 ,Nil},;
			{"D4_QUANT" ,10                 ,Nil},;
			{"D4_TRT",""         ,Nil},;
			{"D4_QTSEGUM",0                 ,Nil}}


MSExecAuto({|x,y| mata380(x,y)},aVetor,nOpc) //Inclusao

If lMsErroAuto
	Alert("Erro")
	MostraErro()
Else
	Alert("Ok")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fSegUM บ Autor ณ Gustavo Costa      บ Data ณ  13/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ x บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fSegUM()

Local cOP		:= aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_OP"})]
Local cCod		:= aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_COD"})]
Local nQtdPri	:= aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_QTDEORI"})]
Local nQtdSeg	:= aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_QTSEGUM"})]
Local nConvert:= 0

nConvert	:= ConvUm(cCod,nQtdPri,nQtdSeg,2)

aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_QUANT"})] := nQtdPri
aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_QTSEGUM"})] := nConvert

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fVldTR    บ Autor ณ Gustavo Costa      บ Data ณ  13/11/13    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Valida a quanditade a ser transferida.                       บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fVldTR()

Local cCodigo	:= aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_COD"})]
Local nQtdPri	:= aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_QTDEORI"})]
Local nQtdATR	:= aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_TRANSF"})] 	// a transferir
Local nQtdTR	:= aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_TRANSF2"})] 	// transferida
Local nSaldo	:= aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_SALDO"})] 	// Saldo em estoque
Local lRet		:= .T.
Local nQE		:= POSICIONE("SB1",1,XFILIAL("SB1") + cCodigo, 'B1_QE')
Local nLimite	:= 0

If nQE > 0

	If Mod( nQtdPri, nQE ) > 0
		nLimite	:= (Int(nQtdPri/nQE) + 1) * nQE
	Else
		nLimite	:= nQtdPri
	EndIf 

Else

	nLimite	:= nQtdPri

EndIf

// Se a quantidade a transferir ้ maior que o saldo
If nQtdATR > nSaldo

	MsgAlert("Saldo insuficiente para transferir!")
	aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_TRANSF"})] 	:= 0

EndIf

//se a quantidade a transferir + o ja transferido supera a quantidade do empenho.
If nQtdATR + nQtdTR > nLimite

	MsgAlert("Quantidade a transferir superior ao empenho!")
	aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_TRANSF"})] 	:= 0

Else
	If nQE > 0
		If Mod( nQtdATR, nQE ) > 0
			MsgAlert("Quantidade a transferir deve ser multiplo de " + Transform(nQE,PesqPict('SD4','D4_QUANT')) + "!")
			aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_TRANSF"})]	:= (Int(nQtdATR/nQE) + 1) * nQE
		EndIf
	Else
		aCols[n][aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D4_TRANSF"})]	:= nQtdATR
	EndIf 

EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fSegUM บ Autor ณ Gustavo Costa      บ Data ณ  13/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ x บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fSaldoAtu(cCod)

Local nSaldo		:= 0

dbSelectArea("SB2")

IF dbSeek(xFilial("SB2") + cCod + "01")
	nSaldo :=  SB2->(B2_QATU - B2_QACLASS - B2_RESERVA - B2_QEMP) //SaldoSb2()
EndIf

Return nSaldo


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fSaldoTransf บ Autor ณ Gustavo Costa     บ Data ณ  13/12/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Retorna a quantidade transferida para o armazem de processo. บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fSaldoTransf(Cod, OP)

Local cOP		:= OP
Local cCod		:= Cod
Local nRet		:= 0
Local cQuery	:= ""

cQuery	:= " SELECT SUM(D3_QUANT) QUANT FROM " + RETSQLNAME("SD3") + " D3 "
cQuery	+= " WHERE D_E_L_E_T_ <> '*' "
cQuery	+= " AND D3_FILIAL = '" + xFilial("SD3") + "' "
cQuery	+= " AND D3_CF = 'DE4' "
cQuery	+= " AND D3_COD = '" + AllTrim(cCod) + "' "
cQuery	+= " AND D3_DOC = '" + SubStr(cOP,1,6) + SubStr(cOP,9,3) + "' "
cQuery	+= " AND D3_LOCAL = '" + GetNewPar("MV_XLOCPRO","02") + "' "

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
TMP->(dbGoTop())

WHILE !TMP->(EOF())

	nRet	:= TMP->QUANT
	TMP->(dbSkip())
	
EndDo

Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fMyMata261   บ Autor ณ Gustavo Costa     บ Data ณ  13/12/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ rotina p/ transferida dos produtos p/ o armazem de processo. บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function fMyMata261()

Local cProd	:= "PA001"
Local cUM		:= ""
Local cLocal	:= ""
Local cDoc		:= ""
Local cLote	:= ""
Local dDataVl	:= CtoD("  /  /  ")   
Local nQuant	:= 0
Local lOk		:= .T.
Local aItem	:= {}
Local nOpcAuto:= 3 // Indica qual tipo de a็ใo serแ tomada (Inclusใo/Exclusใo)

PRIVATE lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.
PRIVATE _cOP := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//| Abertura do ambiente                                         |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If MsgYesNo("Confirma as transfer๊ncias dos produtos ?")

	For x := 1 To Len(oBrw1:aCols)

		//Se tiver preenchido a quantidade a transferir
		If oBrw1:aCols[x][9] > 0

			DbSelectArea("SB1")
			DbSetOrder(1)
			dbSeek(xFilial("SB1")+ oBrw1:aCols[x][2])

			cProd 		:= B1_COD
			cDescri	:= B1_DESC
			cUM 		:= B1_UM
			cLocal		:= B1_LOCPAD
			nQuant		:= oBrw1:aCols[x][9]
			_cOP 		:= oBrw1:aCols[x][1]
			
			If lOk
				cDoc	:= SubStr(oBrw1:aCols[x][1],1,6) + SubStr(oBrw1:aCols[x][1],9,3) //GetSxENum("SD3","D3_DOC",1)
				ConOut(Repl("-",80))
				ConOut(PadC("Teste de Transf. Mod2",80))
				ConOut("Inicio: "+Time())

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//| Teste de Inclusao                                            |
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

				Begin Transaction
					//Cabecalho a Incluir
					aAuto := {}
					aItem := {}
					aadd(aAuto,{cDoc,dDataBase})  //Cabecalho

					//Itens a Incluir
					aadd(aItem,cProd)  		//D3_COD
					aadd(aItem,cDescri)     	//D3_DESCRI
					aadd(aItem,cUM)  			//D3_UM
					aadd(aItem,cLocal)      	//D3_LOCAL
					aadd(aItem,"")			//D3_LOCALIZ
					aadd(aItem,cProd)  		//D3_COD
					aadd(aItem,cDescri)     	//D3_DESCRI
					aadd(aItem,cUM)  			//D3_UM
					aadd(aItem,GetNewPar("MV_XLOCPRO","02"))      	//D3_LOCAL
					aadd(aItem,"")			//D3_LOCALIZ
					aadd(aItem,"")          	//D3_NUMSERI
					aadd(aItem,cLote)			//D3_LOTECTL
					aadd(aItem,"")         	//D3_NUMLOTE
					aadd(aItem,dDataVl)		//D3_DTVALID
					aadd(aItem,0)				//D3_POTENCI
					aadd(aItem,nQuant) 		//D3_QUANT
					aadd(aItem,0)				//D3_QTSEGUM
					aadd(aItem,"")   			//D3_ESTORNO
					aadd(aItem,"")         	//D3_NUMSEQ
					aadd(aItem,cLote)			//D3_LOTECTL
					aadd(aItem,dDataVl)		//D3_DTVALID
					aadd(aItem,"")			//D3_ITEMGRD
					aadd(aAuto,aItem)

					MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

					If !lMsErroAuto
						ConOut("Incluido com sucesso! " + cDoc)
					Else
						ConOut("Erro na inclusao!")
						MostraErro()
					EndIf

					ConOut("Fim  : "+Time())

				End Transaction
			EndIf
		EndIf

	Next x

EndIf

oDlg1:End()

Return Nil




