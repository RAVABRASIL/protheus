#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

//Definicao do alinhamento
#DEFINE ESQUERDA 000
#DEFINE DIREITA  001
#DEFINE CENTRO   002


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATC21    ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 20/06/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para visualizacao em formato Modelo 2 ou 3          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FATC21 (ExpC1,ExpN1,ExpN2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCda                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PCPC21(cAlias,nReg,nOpc)

Local nOpca := 0, nCnt := 0, nSavReg
Local oDlg, oGetD, cContador, lModelo2 := .F., nCpoTela
Local nOrdSx3 := Sx3->(IndexOrd())
Local cCpoMod2  := ""
Local nHeader   := 0
local _nPos
Local nStack    := GetSX8Len()
Private Inclui	:= .F.
Private Altera	:= .F.
Private Exclui	:= .F.
Private Visual	:= .F.
Private cPref, cPref1

cAlias1  := If(Type("cAlias1") = "U" .Or. cAlias1 = Nil, cAlias, cAlias1)
lModelo2 := If(cAlias1 = cAlias, .T., .F.)

//Prefixos das tabelas
cPref := (cAlias)->(FieldName(1))
_nPos := At("_",cPref)
cPref := Substr( cPref, 1, _nPos - 1 )

cPref1 := (cAlias1)->(FieldName(1))
_nPos := At("_",cPref1)
cPref1 := Substr( cPref1, 1, _nPos - 1 )


If Type("aSize") = "U" .Or. aSize = Nil
	Private aSize		:= MsAdvSize(,.F.,430)
	Private aObjects 	:= {}
	Private aPosObj  	:= {}
	Private aSizeAut 	:= MsAdvSize()
	
	If lModelo2
		AAdd( aObjects, { 315, aPosTela[1][2] + 20      , .T., .T. } )
		AAdd( aObjects, { 100, 430 - aPosTela[1][2] - 20, .T., .T. } )
	Else
		AAdd( aObjects, { 315, 100, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )
	Endif
	
	aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	
	aPosObj := MsObjSize( aInfo, aObjects, lModelo2 )
Endif

Do Case
	Case nOpc = 2
		Visual 	:= .T.
	Case nOpc = 3
		Inclui 	:= .T.
		Altera 	:= .F.
	Case nOpc = 4
		Inclui 	:= .F.
		Altera 	:= .T.
		//Testo se o pedido ja foi Validado
		/*
		if ZC5->ZC5_STATUS == 'V'
		Aviso("Aviso","Pedido já Validado. Pedidos Validados não podem mais serem conferidos. Escolha outro.",{"OK"})
		Return
		endif
		*/
	Case nOpc = 5
		Exclui	:= .T.
		Visual	:= .T.
		//Testo se o pedido ja foi Validado
		/*
		if ZC5->ZC5_STATUS == 'V'
		Aviso("Aviso","Pedido já Validado. Pedidos Validados não podem ser excluidos. Escolha outro.",{"OK"})
		Return
		endif
		*/
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a integridade dos campos de Bancos de Dados    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)

IF ! INCLUI .And. LastRec() == 0
	Help(" ",1,"A000FI")
	Return (.T.)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se esta' na filial correta                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! INCLUI .And. xFilial(cAlias) != &(cPref + "_FILIAL")
	Help(" ",1,"A000FI")
	Return
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTELA[0][0],aGETS[0],aHeader[0]
PRIVATE nUsado:=0,lTab   := .F.

If ! lModelo2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva a integridade dos campos de Bancos de Dados    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ALTERA .Or. EXCLUI
		SoftLock(cAlias)
	Endif
	
	CdaMemory(cAlias)
Else
	Private aChaves	:= {}
	SX3->(DbSetOrder(2))
	For nCpoTela := 1 to Len(aPosTela)
		cCpoMod2 += aPosTela[nCpoTela][1] + ";"
		Aadd(aChaves, { aPosTela[nCpoTela][1], "M->" + aPosTela[nCpoTela][1] })
		
		// Bloco CdaMemory
		
		SX3->(DbSeek(aPosTela[nCpoTela][1]))
		
		If SX3->X3_CONTEXT = "V" 	// Campo virtual
			If ! Empty(SX3->X3_INIBRW)
				_SetOwnerPrvt(Trim(SX3->X3_CAMPO), &(AllTrim(SX3->X3_INIBRW)))
			Else
				_SetOwnerPrvt(Trim(SX3->X3_CAMPO), CriaVar(Trim(SX3->X3_CAMPO)))
			Endif
		Else
			If INCLUI
				_SetOwnerPrvt(Trim(SX3->X3_CAMPO), CriaVar(Trim(SX3->X3_CAMPO)))
			Else
				_SetOwnerPrvt(Trim(SX3->X3_CAMPO), (cAlias)->&(Trim(SX3->X3_CAMPO)))
			EndIf
		Endif
	Next
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta cabecalho.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek( cAlias1 )
while !Eof() .And. x3_arquivo == cAlias1
	IF X3USO(x3_usado) .And. cNivel >= x3_nivel .And. ! X3_CAMPO $ cCpoMod2
		nUsado++
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo,;
		x3_context, x3_nivel, x3_relacao, Trim(x3_inibrw) } )
	Endif
	dbSkip()
end

If Type('cChave') = "U" .Or. cChave = Nil
	cChave  := (cAlias)->(IndexKey(1))
	cChave  := Subs(cChave, At(cChave, "_FILIAL") + 12)
Endif
if Type('cChave1') = "U" .Or. cChave1 = Nil
	If lModelo2
		cChave1 := cChave
	Else
		cChave1 := StrTran(cChave, cAlias, cAlias1)
	Endif
Endif

If Len(cChave1) # Len(cChave) .And. ! lModelo2
	cChave := Left(cChave, Len(cChave1))
Endif

dbSelectArea(cAlias1)
dbSetOrder(1)
MsSeek(xFilial(cAlias1) + &(cChave))
nSavReg := Recno()

nCnt := 0
while ! INCLUI .And. !Eof() .And. xFilial(cAlias) + &(cChave) ==;
	xFilial(cAlias1) + &(cChave1)
	nCnt++
	dbSkip()
end

if ! INCLUI .And. ((Type("lSemItens") = "U" 	.Or.;
	lSemItens = Nil) 	.Or. ! lSemItens)	// Indica se verifica existencia dos
	if nCnt == 0                               						// itens
		cHelp := "Não existe(m) item(s) no "+cAlias1+" para este Registro no "+cAlias+"."
		
		Help( ''  , 1 , 'NVAZIO' ,OemToAnsi( "ITENS" ) ,OemToAnsi( cHelp ), 1 , 0 )
		Return .T.
	endif
endif

nCnt := If(nCnt = 0, 1, nCnt)

PRIVATE aCOLS[nCnt][nUsado + 1]

dbSelectArea(cAlias1)
dbSetOrder(1)
dbGoTo(nSavReg)
nCnt := 0

While 	! INCLUI .And. ! Eof() .And.;
	xFilial(cAlias) + &(cChave1) == xFilial(cAlias1) + &(cChave)
	
	nUsado 	:= 0
	nCnt++
	
	For nHeader := 1 To Len(aHeader)
		If X3USO(aHeader[nHeader][7]) .And. cNivel >= aHeader[nHeader][11]
			nUsado++
			If aHeader[nHeader][10] = "V"				// Campo virtual
				If ! Empty(aHeader[nHeader][13])		// inicializador BROWSE
					aCOLS[nCnt][nUsado] := &(aHeader[nHeader][13])
				Endif
			ElseIf INCLUI
				aCOLS[nCnt][nUsado] := CriaVar(AllTrim(aHeader[nHeader][2]))
				If "_ITEM" $ aHeader[nHeader][2]
					aCOLS[nCnt][nUsado] := StrZero(nCnt, Len(aCOLS[nCnt][nUsado]))
				Endif
			Else
				aCOLS[nCnt][nUsado] := &(cAlias1 + "->" + aHeader[nHeader][2])
			Endif
		Endif
	Next
	aCOLS[nCnt][nUsado + 1] := .F.
	
	If ALTERA .Or. EXCLUI
		SoftLock(cAlias1)
	Endif
	
	DbSkip()
Enddo

If nCnt = 0
	nCnt ++
	nUsado := 0
	For nHeader := 1 To Len(aHeader)
		If X3USO(aHeader[nHeader][7]) .And. cNivel >= aHeader[nHeader][11]
			nUsado++
			If aHeader[nHeader][10] = "V"				// Campo virtual
				If ! Empty(aHeader[nHeader][13])		// inicializador BROWSE
					aCOLS[nCnt][nUsado] := &(aHeader[nHeader][13])
				Endif
			ElseIf INCLUI
				aCOLS[nCnt][nUsado] := CriaVar(AllTrim(aHeader[nHeader][2]))
				If "_ITEM" $ aHeader[nHeader][2]
					aCOLS[nCnt][nUsado] := StrZero(nCnt, Len(aCOLS[nCnt][nUsado]))
				Endif
			Else
				aCOLS[nCnt][nUsado] := &(cAlias1 + "->" + aHeader[nHeader][2])
			Endif
		Endif
	Next
	aCOLS[nCnt][nUsado + 1] := .F.
Endif

dbSelectArea(cAlias1)

If FieldPos(cPref1 + "_ITEM") > 0
	cContador := "+" + cPref1 + "_ITEM"
Endif

If Type("cLinhaOk") = "U" .Or. cLinhaOk = Nil
	cLinhaOk := "AllwaysTrue()"
Endif

cLinhaOk += " .and. U_C21LOK()"

If Type("cTudoOk") = "U" .Or. cTudoOk = Nil
	cTudoOk := "AllwaysTrue()"
Endif

cTudoOk += " .AND. U_C21TOK()"

dbSetOrder(1)
dbGoTo(nSavReg)

If ( Type("lCdaAuto") == "U" .OR. !lCdaAuto )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	oFont1     := TFont():New( "MS Sans Serif",0,-21,,.T.,0,,700,.F.,.F.,,,,,, )
	oFont2     := TFont():New( "Courier New"  ,0,-21,,.T.,0,,700,.F.,.F.,,,,,, )
	
	If ! lModelo2
		EnChoice( cAlias, nReg, nOpc, , , , , aPosObj[1], , 3, , , , , , .T. )
	Else
		SX3->(DbSetOrder(2))
		For nCpoTela 	:= 1 to Len(aPosTela)
			cCampo		:= aPosTela[nCpoTela][1]
			SX3->(DbSeek(cCampo))
			nX			:= aPosTela[nCpoTela][2]
			nY			:= aPosTela[nCpoTela][3]
			cCaption	:= X3Titulo()
			cPict		:= If(Empty(SX3->X3_PICTURE),Nil,SX3->X3_PICTURE)
			cValid		:= If(Empty(SX3->X3_VALID),".t.",SX3->X3_VALID)
			cF3			:= If(Empty(SX3->X3_F3),NIL,SX3->X3_F3)
			cWhen		:= If(Empty(SX3->X3_WHEN),"(.t.)","(" +;
			AllTrim(SX3->X3_WHEN) + ")")
			If Len(aPosTela[nCpoTela]) > 3
				cWhen += " .And. (" + aPosTela[nCpoTela][4] + ")"
			Endif
			cBlKSay 	:= "{|| OemToAnsi('"+cCaption+"')}"
			oSay 		:= TSay():New( nX + 1, nY, &cBlkSay,oDlg,,, .F., .F., .F., .T.,,,,, .F., .F., .F., .F., .F. )
			nLargSay := GetTextWidth(0,cCaption) / 1.8  // estava 2.2
			cCaption := oSay:cCaption
			cBlkGet 	:= "{ | u | If( PCount() == 0, M->"+cCampo+", M->"+cCampo+":= u ) }"
			cBlKVld 	:= "{|| "+cValid+"}"
			cBlKWhen := "{|| "+cWhen+"}"
			oGet 		:= TGet():New( nX, nY+nLargSay,&cBlKGet,oDlg,,,cPict, &(cBlkVld),,,, .F.,, .T.,, .F., &(cBlkWhen), .F., .F.,, .F., .F. ,cF3,(cCampo))
		Next
		
		Sx3->(DbSetOrder(nOrdSx3))
	Endif
	
	oGetd  := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]-120,aPosObj[2,4],nOpc,cLinhaOk,cTudoOk,cContador, .F.,,,,10)
	lTab   := .T.
	
	oSay01 := TSay():New( aPosObj[2,3]-110,004,{||"Média Larg. Amostras:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,130,013)
	oSay04 := TSay():New( aPosObj[2,3]-110,140,{||Transform(0,"@E 999,999" ) },oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	oSay02 := TSay():New( aPosObj[2,3]-095,004,{||"Média Comp. Amostras:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,130,013)
	oSay05 := TSay():New( aPosObj[2,3]-095,140,{||Transform(0,"@E 999,999" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	oSay03 := TSay():New( aPosObj[2,3]-080,004,{||"Média Espess. Amostras:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,130,013)
	oSay06 := TSay():New( aPosObj[2,3]-080,140,{||Transform(0,"@E 9.99999" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)

	oSay30 := TSay():New( aPosObj[2,3]-110,300,{||"Diferença Peso:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,130,013)
	oSay31 := TSay():New( aPosObj[2,3]-110,390,{||Transform(0,"@E 999.9999" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	oSay28 := TSay():New( aPosObj[2,3]-095,300,{||"Peso Calculado:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,130,013)
	oSay29 := TSay():New( aPosObj[2,3]-095,390,{||Transform(0,"@E 999.9999" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	oSay26 := TSay():New( aPosObj[2,3]-080,300,{||"Espess.Gramat.:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,130,013)
	oSay27 := TSay():New( aPosObj[2,3]-080,390,{||Transform(0,"@E 99.99999" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	
	oSay07 := TSay():New( aPosObj[2,3]-065,004,{||Replicate("-",78)},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,700,013)
	
	oSay08 := TSay():New( aPosObj[2,3]-050,004,{||"Erro de Largura:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,130,013)
	oSay09 := TSay():New( aPosObj[2,3]-050,140,{||Transform(0,"@E 999,999" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	oSay10 := TSay():New( aPosObj[2,3]-050,230,{||Transform(0,"@E 9999.99" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	
	oSay11 := TSay():New( aPosObj[2,3]-035,004,{||"Erro de Comprimento:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,130,013)
	oSay12 := TSay():New( aPosObj[2,3]-035,140,{||Transform(0,"@E 999,999" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	oSay13 := TSay():New( aPosObj[2,3]-035,230,{||Transform(0,"@E 9999.99" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	
	oSay14 := TSay():New( aPosObj[2,3]-020,004,{||"Erro de Espessura:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,130,013)
	oSay15 := TSay():New( aPosObj[2,3]-020,140,{||Transform(0,"@E 9.99999" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	oSay16 := TSay():New( aPosObj[2,3]-020,230,{||Transform(0,"@E 9999.99" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)


	oSay17 := TSay():New( aPosObj[2,3]-050,300,{||"Erro Qtd.Pcte:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,130,013)
	oSay18 := TSay():New( aPosObj[2,3]-050,390,{||Transform(0,"@E 999,999" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	oSay19 := TSay():New( aPosObj[2,3]-050,445,{||Transform(0,"@E 9999.99" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	
	oSay20 := TSay():New( aPosObj[2,3]-035,300,{||"Erro Qtd.Fardinho:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,130,013)
	oSay21 := TSay():New( aPosObj[2,3]-035,390,{||Transform(0,"@E 999,999" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	oSay22 := TSay():New( aPosObj[2,3]-035,445,{||Transform(0,"@E 9999.99" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	
	oSay23 := TSay():New( aPosObj[2,3]-020,300,{||"Erro Qtd.Fardão:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,130,013)
	oSay24 := TSay():New( aPosObj[2,3]-020,390,{||Transform(0,"@E 999,999" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	oSay25 := TSay():New( aPosObj[2,3]-020,445,{||Transform(0,"@E 9999.99" )},oDlg,,oFont2,.F.,.F.,.F.,.T.,CLR_HRED,CLR_WHITE,098,013)
	
	CalcRoda()
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(if(!lModelo2,Obrigatorio(aGets,aTela),.T.).and.oGetd:TudoOk(),oDlg:End(),nOpca := 0) }, { || if(Inclui.AND.__lSX8,RollBackSX8(),),oDlg:End() })
else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ validando dados pela rotina automatica                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Altera
	if EnchAuto(cAlias,aAutoCab,{|| if(!lModelo2,Obrigatorio(aGets,aTela),.T.)},aRotina[nOpc][4]) .and. MsGetDAuto(aAutoItens,cLinhaOk,{||&(cTudoOk)},aAutoCab,aRotina[nOpc][4])
		nOpcA := 1
	endif
endif

If nOpca = 1 .And. nOpc # 2
	BEGIN TRANSACTION
	
	If nOpc = 5 .And. (Type("cPodeExcluir") = "U" .Or. Empty(cPodeExcluir) .Or.;
		&(cPodeExcluir))
		ApagMod(cAlias, cAlias1)
	ElseIf nOpc # 5
		GravMod(cAlias, cAlias1, nStack)
	Endif
	
	END TRANSACTION
Endif

dbSelectArea(cAlias)

Return nOpca

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GrvModelo ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 21/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para gravacao em formato Modelo 2 ou 3          	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GrvModelo(cPar1, cPar2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpC1 = Alias detalhe do arquivo                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCda                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GravMod(cAlias,cAlias1,nStack)

Local nCampos, nHeader, nMaxArray, bCampo, aAnterior:={}, nItem := 1
Local lModelo2   := cAlias = cAlias1
Local nChaves    := 0
Local nSaveSX8Z5 := GetSX8Len()
Local nTolera    := 1-GetMV("MV_PESOTOL")
Local lTolera    := .F.

bCampo := {|nCPO| Field(nCPO) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se o ultimo elemento do array esta em branco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMaxArray := Len(aCols)

lTolera := nPesoC >= M->Z93_PESO*(1-nTolera) .and.;
           nPesoC <= M->Z93_PESO*(1+nTolera)

if lTolera
   Alert("Essa inspeção NÃO é justificada, pois a diferença encontrada é tolerável.")
   M->Z93_QTDLIB := 999
endif

If ! lModelo2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava arquivo PRINCIPAL ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAlias)
	
	RecLock(cAlias, If(INCLUI,.T.,.F.))
	
	For nCampos := 1 TO FCount()
		If "FILIAL"$Field(nCampos)
			FieldPut(nCampos,xFilial(cAlias))
		Else
			FieldPut(nCampos,M->&(EVAL(bCampo,nCampos)))
		EndIf
	Next
	
	//Caso seja "Conferencia" Altero o Status do Pedido, o usuario e a data da conferencia
	/*
	if Altera
	ZC5->ZC5_STATUS := 'C'
	ZC5->ZC5_USUCON := __cUserId
	ZC5->ZC5_DTCON  := Date()
	ZC5->ZC5_HRCON  := Substr(Time(),1,5)
	endif
	*/
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega ja gravados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias1)
If ! INCLUI .And. MsSeek(xFilial(cAlias1)+&(cChave))
	While !Eof() .And. xFilial(cAlias) + &(cChave1) == xFilial(cAlias1) + &(cChave)
		Aadd(aAnterior,RecNo())
		dbSkip()
	Enddo
Endif

dbSelectArea(cAlias1)
nItem := 1

For nCampos := 1 to nMaxArray
	
	If Len(aAnterior) >= nCampos
		If ! INCLUI
			DbGoto(aAnterior[nCampos])
		EndIf
		RecLock(cAlias1,.F.)
	Else
		RecLock(cAlias1,.T.)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se tem marcacao para apagar.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aCols[nCampos][Len(aCols[nCampos])]
		RecLock(cAlias1,.F.,.T.)
		dbDelete()
	Else
		For nHeader := 1 to Len(aHeader)
			If aHeader[nHeader][10] # "V" .And. ! "_ITEM" $ AllTrim(aHeader[nHeader][2])
				Replace &(Trim(aHeader[nHeader][2])) With aCols[nCampos][nHeader]
			ElseIf "_ITEM" $ AllTrim(aHeader[nHeader][2])
				Replace &(AllTrim(aHeader[nHeader][2])) With StrZero(nItem ++,;
				Len(&(AllTrim(aHeader[nHeader][2]))))
			Endif
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza as chaves de itens ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Type("aChaves") # "U" .Or. aChaves # Nil
			Replace &(cPref1 + "_FILIAL") With xFilial(cAlias1)
			For nChaves := 1 To Len(aChaves)
				Replace &(aChaves[nChaves][1]) With &(aChaves[nChaves][2])
			Next
		Endif
		
		dbSelectArea(cAlias1)
	Endif
	
Next nCampos

If INCLUI
	While GetSX8Len() > nStack 
		ConfirmSX8()
	EndDo
EndIf

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DelModelo3³ Autor ³ Wagner Mobile Costa   ³ Data ³ 21/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para delecao em formato Modelo 2 ou 3          	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DelModelo(cPar1, cPar2)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpC1 = Alias detalhe do arquivo                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCda                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ApagMod(cAlias,cAlias1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta os itens ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( cAlias1 )
MsSeek(xFilial(cAlias1) + &(cChave))
While !Eof() .And. xFilial(cAlias) + &(cChave1) == xFilial(cAlias1) + &(cChave)
	RecLock(cAlias1,.F.,.T.)
	dbDelete()
	dbSkip()
End

If cAlias # cAlias1    	// Se igual eh modelo 2, ou seja nao tem cabecalho
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Deleta o cabecalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAlias)
	RecLock(cAlias,.F.,.T.)
	dbDelete()
	dbSelectArea(cAlias)
Endif

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CdaPrivate³ Autor ³ Wagner Mobile Costa   ³ Data ³ 03/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Zera as privates para uso da funcao CdaModelo         	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CdaPrivate()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaCda                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
**************************
Static Function CdaPrivate
**************************

aSize			 := Nil		// Objeto Bes
cChave		 := Nil		// Chave do arquivo principal
cChave1		 := Nil		// Chave do arquivo detalhe
lSemItens    := Nil		// Nao ter itens para aCols
aChaves 		 := Nil		// Campos CHAVES
cLinhaOk		 := Nil		// Verifica da Linha aCols
cTudoOk		 := Nil		// Verifica ao GRAVAR
cPodeExcluir := ""		// Verifica se pode ser excluido
cAlias1		 := Nil		// Alias de detalhe se Modelo2 = Nil
aPosTela		 := Nil		// Posicoes dos campos principais modelo 2

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³CdaMemory   ³ Autor ³ Wagner Mobile       ³ Data ³ 04/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria variaveis M-> para uso na Enchoice()					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Enchoice												  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*********************************
Static Function CdaMemory(cAlias)
*********************************

SX3->(DbSetOrder(1))
SX3->(MsSeek(cAlias))

While ! SX3->(Eof()) .And. SX3->x3_arquivo == cAlias
	If SX3->X3_CONTEXT = "V" 	// Campo virtual
		If ! Empty(SX3->X3_INIBRW)
			_SetOwnerPrvt(Trim(SX3->X3_CAMPO), &(AllTrim(SX3->X3_INIBRW)))
		Else
			_SetOwnerPrvt(Trim(SX3->X3_CAMPO), CriaVar(Trim(SX3->X3_CAMPO)))
		Endif
	Else
		If INCLUI
			_SetOwnerPrvt(Trim(SX3->X3_CAMPO), CriaVar(Trim(SX3->X3_CAMPO)))
		Else
			_SetOwnerPrvt(Trim(SX3->X3_CAMPO), (cAlias)->&(Trim(SX3->X3_CAMPO)))
		EndIf
	Endif
	SX3->(DbSkip())
EndDo

Return .T.

**********************
User Function C21LOK()
**********************

CalcRoda()

return .T.


**********************
User Function C21TOK()
**********************

local lOk
if Len(aCols)=10
	lOk := .T.
else
	Alert("Cada inspeção precisa ter 10 amostras.")
	lOk := .F.
endif

return lOk


**************************
Static Function CalcRoda()
**************************

Local iLarg  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z94_LARGUR" } )
Local iComp  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z94_COMPRI" } )
Local iEspe5 := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z94_ESPES5" } )

Public nLargD := nCompD := nEspeD := 0
Public nQtPD  := nQtFiD := nQtFaD := 0
Public cSLarg := cSComp := cSEspe := ""
Public nLarg  := nComp  := nEspe  := 0
Public nPesoC := nDifP  := 0

AEval( aCols, { |X| nLarg  += X[ iLarg  ] } )
AEval( aCols, { |X| nComp  += X[ iComp  ] } )
AEval( aCols, { |X| nEspe  += X[ iEspe5 ] } )

if nLarg+nComp+nEspe > 0
   nLarg := nLarg/Len(Acols)  //Media
   nComp := nComp/Len(Acols)  //Media
   nEspe := nEspe/Len(Acols)  //Media

   ObjectMethod( oSay04, "SetText( Trans( nLarg, '@E 999,999.99' ) )" )
   ObjectMethod( oSay05, "SetText( Trans( nComp, '@E 999,999.99' ) )" )
   ObjectMethod( oSay06, "SetText( Trans( nEspe, '@E 9999.99999' ) )" )
  
   //Peso Calculado
   nPesoC := (nLarg*nComp*nEspe*M->Z93_DENSID)*(M->Z93_QE2/1000)
   ObjectMethod( oSay29, "SetText( Trans( nPesoC, '@E 999.9999' ) )" )

   //Diferenca Peso
   nDifP := ( (nPesoC-M->Z93_PESO)/M->Z93_PESO )*100
   ObjectMethod( oSay31, "SetText( Trans( nDifP , '@E 9,999.99' )+'%' )" )

   nLargD := ( nLarg-M->Z93_LARGUR )
   nCompD := ( nComp-M->Z93_COMPRI )
   nEspeD := ( nEspe-M->Z93_ESPESS )

   //cSLarg := if(nLargD <0,"Menor",if(nCompD =0,"Ok","Maior"))
   //cSComp := if(nCompD <0,"Menor",if(nCompD =0,"Ok","Maior"))
   //cSEspe := if(nEspeD <0,"Menor",if(nEspeD =0,"Ok","Maior"))

   ObjectMethod( oSay09, "SetText( Trans( nLargD, '@E 999,999.99' ) )" )
   ObjectMethod( oSay10, "SetText( Trans( (nLargD/M->Z93_LARGUR)*100, '@E 9999.99' )+'%' )" )

   ObjectMethod( oSay12, "SetText( Trans( nCompD, '@E 999,999.99' ) )" )
   ObjectMethod( oSay13, "SetText( Trans( (nCompD/M->Z93_COMPRI)*100, '@E 9999.99' )+'%' )" )

   ObjectMethod( oSay15, "SetText( Trans( nEspeD, '@E 9999.99999' ) )" )
   ObjectMethod( oSay16, "SetText( Trans( (nEspeD/M->Z93_ESPESS)*100, '@E 9999.99' )+'%' )" )
endif

//Espessura pela gramatura
ObjectMethod( oSay27, "SetText( Trans( M->Z93_PESGRA/M->Z93_DENSID/100, '@E 99.99999' ) )" )

//Quantidade do Pacote
nQtPD := M->Z93_QTPCT2-M->Z93_QTPCT1
ObjectMethod( oSay18, "SetText( Trans( nQtPD, '@E 999,999' ) )" )
ObjectMethod( oSay19, "SetText( Trans( (nQtPD/M->Z93_QTPCT1)*100, '@E 9999.99' )+'%' )" )

	
//Quantidade do Fardinho
nQtFiD := M->Z93_QTFDI2-M->Z93_QTFDI1
ObjectMethod( oSay21, "SetText( Trans( nQtFiD, '@E 999,999' ) )" )
ObjectMethod( oSay22, "SetText( Trans( (nQtFiD/M->Z93_QTFDI1)*100, '@E 9999.99' )+'%' )" )
	

//Quantidade do Fardao
nQtFaD := M->Z93_QTFDA2-M->Z93_QTFDA1
ObjectMethod( oSay24, "SetText( Trans( nQtFaD, '@E 999,999' ) )" )
ObjectMethod( oSay25, "SetText( Trans( (nQtFaD/M->Z93_QTFDA1)*100, '@E 9999.99' )+'%' )" )


Return .T.


**********************
user function IMPC21()
**********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Inspeção de Sobrepeso"
Local cPict          := ""
Local titulo         := "Inspecao de Sobrepeso"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "PCPR21" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PCPR21" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""

//oPerg1()

//Pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


****************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
****************************************************

Local cQuery
Local nMedL := nMedC := nMedE := 0
Local nLarP := nComP := nEspP := nDenP := 0
Local nPesP := nQtPcP := nQtFiP := nQtFaP := nPesGP := 0
local nQtPcR := nQtFiR := nQtFaR := 0

If Select("IPQX") > 0
	IPQX->(dbCloseArea())
EndIf

cQuery := "SELECT "
cQuery += "   Z93_DOC, Z93_DATA, Z93_TURNO, Z93_COD, Z93_OP, Z93_MAQUIN, Z93_OPECS, "
cQuery += "   Z93_EXTRUS, Z93_OPEXTR, Z93_QTPCT2, Z93_QTFDI2, Z93_QTFDA2, Z93_COMPRI, "
cQuery += "   Z93_LARGUR, Z93_DENSID, Z93_ESPESS, Z93_PESO, Z93_QTDLIB, Z93_QTPCT1, "
cQuery += "   Z93_QTFDI1, Z93_QTFDA1, Z93_PESGRA, "
cQuery += "   Z94_ITEM, Z94_LARGUR, Z94_COMPRI, Z94_ESPES1, Z94_ESPES2, Z94_ESPES3, 
cQuery += "   Z94_ESPES4, Z94_ESPES5 "
cQuery += "FROM "
cQuery += "   "+RetSqlName("Z93")+" Z93, "+RetSqlName("Z94")+" Z94 "
cQuery += "WHERE "
cQuery += "   Z93_DOC = '"+Z93->Z93_DOC+"' AND Z93_DOC = Z94_DOC AND "
cQuery += "   Z93.D_E_L_E_T_ <> '*' AND Z94.D_E_L_E_T_ <> '*' "  
cQuery += "ORDER BY Z93_DOC, Z94_ITEM "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"IPQX",.T.,.T.)

SetRegua(RecCount())

while !IPQX->(EOF())
   if nLin > 55
      nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)+1
      @nLin,00 PSAY "Documento: "+IPQX->Z93_DOC   +"  Dt.Producao: "+DTOC(STOD(IPQX->Z93_DATA))+"  Turno: "+IPQX->Z93_TURNO; nLin++
      @nLin,00 PSAY "Numero OP: "+IPQX->Z93_OP    +"  Extrusora: "  +Alltrim(IPQX->Z93_EXTRUS) +"  Extrusor: "+IPQX->Z93_OPEXTR; nLin++      
      @nLin,00 PSAY "Maquina: "  +Alltrim(IPQX->Z93_MAQUIN)+"  Operador: "   +IPQX->Z93_OPECS; nLin++      
      @nLin,00 PSAY "Produto: "  +Alltrim(IPQX->Z93_COD)+" - "+Posicione("SB1",1,Xfilial("SB1")+IPQX->Z93_COD,"B1_DESC"); nLin++ 
      @nLin,00 PSAY Replicate("-", limite ); nLin++
      @nLin,00 PSAY "Amostra Largura  Comprim.  Espess.1  Espess.2  Espess.3  Espess.4     Media" ; nLin++
                   //  999   999,999   999,999  99.99999  99.99999  99.99999  99.99999  99.99999
                   //1234567890123456789012345678901234567890123456789012345678901234567890123456
                   //         1         2         3         4         5         6         7      
      nLarP  := IPQX->Z93_LARGUR
      nComP  := IPQX->Z93_COMPRI
      nEspP  := IPQX->Z93_ESPESS
      nDenP  := IPQX->Z93_DENSID
      nPesP  := IPQX->Z93_PESO
      nQtPcP := IPQX->Z93_QTPCT1
      nQtFiP := IPQX->Z93_QTFDI1
      nQtFaP := IPQX->Z93_QTFDA1
      nPesGP := IPQX->Z93_PESGRA
      nQtPcR := IPQX->Z93_QTPCT2
      nQtFiR := IPQX->Z93_QTFDI2
      nQtFaR := IPQX->Z93_QTFDA2
   endif

	@nLin,02 PSAY IPQX->Z94_ITEM
	@nLin,08 PSAY Transform( IPQX->Z94_LARGUR, "@E 999,999" )
	@nLin,18 PSAY Transform( IPQX->Z94_COMPRI, "@E 999,999" )
	@nLin,27 PSAY Transform( IPQX->Z94_ESPES1, "@E 99.99999")
	@nLin,37 PSAY Transform( IPQX->Z94_ESPES2, "@E 99.99999")
	@nLin,47 PSAY Transform( IPQX->Z94_ESPES3, "@E 99.99999")
	@nLin,57 PSAY Transform( IPQX->Z94_ESPES4, "@E 99.99999")
	@nLin,67 PSAY Transform( IPQX->Z94_ESPES5, "@E 99.99999")
	nMedL += IPQX->Z94_LARGUR
	nMedC += IPQX->Z94_COMPRI
	nMedE += IPQX->Z94_ESPES5
   nLin++
   IPQX->(dbSkip())
enddo

nMedL := nMedL / 10
nMedC := nMedC / 10
nMedE := nMedE / 10

if nMedL+nMedC+nMedE > 0 
   @nLin,00 PSAY Replicate("-", limite ); nLin++
   @nLin,02 PSAY "Medias"
   @nLin,07 PSAY Transform( nMedL, "@E 9999,999" )
   @nLin,17 PSAY Transform( nMedC, "@E 9999,999" )
   @nLin,66 PSAY Transform( nMedE, "@E 99.99999" );nLin++
   @nLin,45 PSAY "Espess.por Gramatura"    
   @nLin,67 PSAY Transform( nPesGP/nDenP/100, "@E 99.99999")
   nLin++;nLin++
   @nLin,00 PSAY Replicate("-", limite ); nLin++
   @nLin,00 PSAY "Medidas Padrao"; nLin++
   @nLin,00 PSAY Replicate("-", limite ); nLin++
   @nLin,00 PSAY "Peso        : "+Transform(nPesP,  "@E 9999,999") ; nLin++
   @nLin,00 PSAY "Comprimento : "+Transform(nComP,  "@E 9999,999") ; nLin++
   @nLin,00 PSAY "Largura     : "+Transform(nLarP,  "@E 9999,999") ; nLin++
   @nLin,00 PSAY "Espessura   : "+Transform(nEspP,  "@E 99.99999") ; nLin++
   @nLin,00 PSAY "Densidade   : "+Transform(nDenP,  "@E 99.99999") ; nLin++
   @nLin,00 PSAY "Qtd.Pacote  : "+Transform(nQtPcP, "@E 9999,999") ; nLin++
   @nLin,00 PSAY "Qtd.Fardinho: "+Transform(nQtFiP, "@E 9999,999") ; nLin++
   @nLin,00 PSAY "Qtd.Fardão  : "+Transform(nQtFaP, "@E 9999,999") ; nLin++


   @nLin,00 PSAY Replicate("-", limite ); nLin++
   @nLin,00 PSAY "Erros"; nLin++
   @nLin,00 PSAY Replicate("-", limite ); nLin++
   @nLin,00 PSAY "Comprimento : "+Transform(nComP-nMedC, "@E 9999,999")  +"  "+Transform( ((nComP-nMedC)/nComP)*100, "@E 999.99" )+"%"; nLin++
   @nLin,00 PSAY "Largura     : "+Transform(nLarP-nMedL, "@E 9999,999")  +"  "+Transform( ((nLarP-nMedL)/nLarP)*100, "@E 999.99" )+"%"; nLin++
   @nLin,00 PSAY "Espessura   : "+Transform(nEspP-nMedE, "@E 99.99999")  +"  "+Transform( ((nEspP-nMedE)/nEspP)*100, "@E 999.99" )+"%"; nLin++
   @nLin,00 PSAY "Qtd.Pacote  : "+Transform(nQtPcP-nQtPcR, "@E 9999,999")+"  "+Transform( ((nQtPcP-nQtPcR)/nQtPcP)*100, "@E 999.99" )+"%" ; nLin++
   @nLin,00 PSAY "Qtd.Fardinho: "+Transform(nQtFiP-nQtFiR, "@E 9999,999")+"  "+Transform( ((nQtFiP-nQtFiR)/nQtFiP)*100, "@E 999.99" )+"%" ; nLin++
   @nLin,00 PSAY "Qtd.Fardão  : "+Transform(nQtFaP-nQtFaR, "@E 9999,999")+"  "+Transform( ((nQtFaP-nQtFaR)/nQtFaP)*100, "@E 999.99" )+"%" ; nLin++


//Local  :=  :=  :=  := nPesGP := 0   
   
endif

if Select("IPQX") > 0
	IPQX->(dbCloseArea())
endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return