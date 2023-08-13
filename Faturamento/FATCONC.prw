#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FATCONC()

Local aCores := {{"Z86_FRETE=Z86_FRESIS", "BR_VERDE"   },;		   			 
                 {"Z86_FRETE<>Z86_FRESIS", "BR_VERMELHO" }}



Private aRotina := {{"Pesquisar" , "AxPesqui"   , 0, 1},;
                    {"Visualizar", "U_CdMode2", 0, 2},;
                    {"Incluir"   , "U_CdMode2", 0, 3},; 
                    {"Alterar"   , "U_CdMode2", 0, 4},;
                    {"Excluir"   , "U_CdMode2", 0, 5},;
                    {"Legenda"   , "U_LegCon()", 0, 6},;                    
                    {"Relatorio"   , "U_RELCONH()", 0, 6}}
                    
                    

/*
Private aRotina := {{"Pesquisar" , "AxPesqui"   , 0, 1},;
                    {"Visualizar", "U_CdMode2", 0, 2},;
                    {"Incluir"   , "U_CdMode2", 0, 3},;
                    {"Alterar"   , "U_CdMode2", 0, 4},;
                    {"Excluir"   , "U_CdMode2", 0, 5}}
*/
Private cCadastro  := OemToAnsi( "Conhecimento de frete" )
Private cAlias1	   := "Z87"	    // Alias de detalhe
Private lSemItens  := .F.		// Permite a nao existencia de itens
Private cChave	   := "Z86_CONHEC+Z86_SERIE+Z86_FORNEC+Z86_LOJA"  // Chave que ligara a primeira tabela com a segunda
Private cChave1	   := "Z87_CODCON+Z87_SERIE+Z87_FORNEC+Z87_LOJA"  // Chave que ligara a segunda tabela com a primeira
Private aChaves    := {{"Z87_CODCON", "M->Z86_CONHEC"},{"Z87_SERIE", "M->Z86_SERIE"},{"Z87_FORNEC", "M->Z86_FORNEC"},{"Z87_LOJA", "M->Z86_LOJA"}}
Private cLinhaOk   := "AllwaysTrue()" //Funcao LinhaOk para a GetDados
Private cTudoOk    := "U_TuDOK()"//"AllwaysTrue()" //Funcao TudoOk para a GetDados
Private cDelOK     :="U_fDelOk()"

DbSelectArea("Z86")
DbSetOrder(1)

//mBrowse( 06, 01, 22, 75, "Z86" )
mBrowse( 06, 01, 22, 75, "Z86",,,,,,aCores )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CdaModelo ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 20/06/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para visualizacao em formato Modelo 2 ou 3          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CdaModelo(ExpC1,ExpN1,ExpN2)                               ³±±
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

User Function CdMode2(cAlias,nReg,nOpc)

Local nOpca := 0, nCnt := 0, nSavReg
Local oDlg, lModelo2 := .F., nCpoTela
Local nOrdSx3 := Sx3->(IndexOrd())
Local cCpoMod2  := ""
Local nHeader   := 0
local _nPos
Private Inclui	:= .F.
Private Altera	:= .F.
Private Exclui	:= .F.
Private Visual	:= .F.
Private cPref, cPref1
Private oGetD, cContador

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
	Case nOpc = 5
		Exclui	:= .T.
		Visual	:= .T.
EndCase

If Altera .OR. Exclui
   DbSelectArea("SF1")
   DbSetOrder(1)
   If SF1->(DbSeek(xFilial('SF1')+Z86->Z86_CONHEC+Z86->Z86_SERIE+Z86->Z86_FORNEC+Z86->Z86_LOJA ) )
      alert('O Conhecimento nao pode ser alterado, pois ja foi incluido documento de entrada')
      Return
   Endif
Endif


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
While !Eof() .And. x3_arquivo == cAlias1
	IF X3USO(x3_usado) .And. cNivel >= x3_nivel .And. ! X3_CAMPO $ cCpoMod2
		nUsado++
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo,;
		x3_context, x3_nivel, x3_relacao, Trim(x3_inibrw) } )
	Endif
	dbSkip()
End

If Type('cChave') = "U" .Or. cChave = Nil
	cChave  := (cAlias)->(IndexKey(1))
	cChave  := Subs(cChave, At(cChave, "_FILIAL") + 12)
Endif
If Type('cChave1') = "U" .Or. cChave1 = Nil
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
While ! INCLUI .And. !Eof() .And. xFilial(cAlias) + &(cChave) ==;
	xFilial(cAlias1) + &(cChave1)
	nCnt++
	dbSkip()
End

If ! INCLUI .And. ((Type("lSemItens") = "U" 	.Or.;
	lSemItens = Nil) 	.Or. ! lSemItens)	// Indica se verifica existencia dos
	If nCnt == 0                               						// itens
		cHelp := "Não existe(m) item(s) no "+cAlias1+" para este Registro no "+cAlias+"."
		
		Help( ''  , 1 , 'NVAZIO' ,OemToAnsi( "ITENS" ) ,OemToAnsi( cHelp ), 1 , 0 )
		Return .T.
	Endif
Endif

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

If Type("cTudoOk") = "U" .Or. cTudoOk = Nil
	cTudoOk := "AllwaysTrue()"
Endif

dbSetOrder(1)
dbGoTo(nSavReg)

If ( Type("lCdaAuto") == "U" .OR. !lCdaAuto )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
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
			nLargSay 	:= GetTextWidth(0,cCaption) / 1.8  // estava 2.2
			cCaption 	:= oSay:cCaption
			cBlkGet 	:= "{ | u | If( PCount() == 0, M->"+cCampo+", M->"+cCampo+":= u ) }"
			cBlKVld 	:= "{|| "+cValid+"}"
			cBlKWhen 	:= "{|| "+cWhen+"}"
			oGet 		:= TGet():New( nX, nY+nLargSay,&cBlKGet,oDlg,,,cPict, &(cBlkVld),,,, .F.,, .T.,, .F., &(cBlkWhen), .F., .F.,, .F., .F. ,cF3,(cCampo))
		Next
		
		Sx3->(DbSetOrder(nOrdSx3))
	Endif
	
	//oGetd := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,cLinhaOk,cTudoOk,cContador, .T.)
	//oGetd := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]-30,aPosObj[2,4],nOpc,cLinhaOk,cTudoOk,cContador, .T.)
	
	oGetd :=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]-30,aPosObj[2,4],nOpc,cLinhaOk,cTudoOk,cContador, .T.,,,,,,,,cDelOK,,,)	         
	oFont1     := TFont():New( "MS Sans Serif",0,-19,,.F.,0,,400,.F.,.F.,,,,,, )
	oSayF := TSay():New( aPosObj[2,3]-20,aPosObj[2,2],{||"Total:"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,015)
	//oSayF := TSay():New( aPosObj[2,3]-20,aPosObj[2,2],{||"Total: "},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)	
	oSayT := TSay():New( aPosObj[2,3]-20,aPosObj[2,2]+50,{||"0"},oDlg,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,015)
	//oSayT := TSay():New( aPosObj[2,3]-20,aPosObj[2,2]+50,{||"0"},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)	
	lTab  := .T.
	
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
		GravMod(cAlias, cAlias1)
	    
	    if INCLUI
		    IF fDocEnt()
	           //EMAIL(Z86->Z86_CONHEC,Z86->Z86_SERIE,Z86->Z86_FORNEC,Z86->Z86_LOJA,Z86->Z86_FRETE,Z86->Z86_FRESIS) 
	           ALERT('Nota Incluida com Sucesso')
	        ENDIF
        ENDIF
        
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

Static Function GravMod(cAlias,cAlias1)

Local nCampos, nHeader, nMaxArray, bCampo, aAnterior:={}, nItem := 1
Local lModelo2 := cAlias = cAlias1
Local nChaves := 0
Local nSaveSX8Z5:= GetSX8Len()

bCampo := {|nCPO| Field(nCPO) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se o ultimo elemento do array esta em branco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMaxArray := Len(aCols)

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
    //ConfirmSX8()
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

Static Function CdaPrivate

aSize			:= Nil		// Objeto Bes
cChave			:= Nil		// Chave do arquivo principal
cChave1			:= Nil		// Chave do arquivo detalhe
lSemItens   	:= Nil		// Nao ter itens para aCols
aChaves 		:= Nil		// Campos CHAVES
cLinhaOk		:= Nil		// Verifica da Linha aCols
cTudoOk			:= Nil		// Verifica ao GRAVAR
cPodeExcluir	:= ""		// Verifica se pode ser excluido
cAlias1			:= Nil		// Alias de detalhe se Modelo2 = Nil
aPosTela		:= Nil		// Posicoes dos campos principais modelo 2

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
Static Function CdaMemory(cAlias)

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


**************

User Function TuDOK()

**************
local nPosDel:= len(aHeader)+1
local x:=0
local lRet:=.T.
local freteSist  :=0
local nPosFrete  := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_FRETE"}) 
local nPosICMS    := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_ICMS"})
local nPosFSICMS  := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_FSICMS"})  
local nPosFREPES := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_FREPES"}) 
local nPosTXFIXA := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_TXFIXA"}) 
local nPosADVALO := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_ADVALO"}) 
local nPosFlu    := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_FLUVIA"}) 
local nPosGRIS   := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_GRIS"}) 
local nPosADM    := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_ADM"}) 
local nPosPEDAGI := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_PEDAGI"}) 
local nPosSUFRAM := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_SUFRAM"})
local nPosTDE    := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_TDE" })
local nPosVALOR  := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_VALOR" })
LOCAL cTesFret:=GETMV("MV_TESFRE")
local nTolfret :=0

// VERIFICO SE JA EXISTE O CONHECIMENTO
DbSelectArea("Z86")
DbSetOrder(1)
If Z86->(DbSeek(xFilial('Z86')+M->Z86_CONHEC+M->Z86_SERIE+M->Z86_FORNEC+M->Z86_LOJA ) )
	alert('O Conhecimento de Frete Ja Existe !!!')
    RETURN .F. 
Endif



If ! ALLTRIM(M->Z86_TES)$cTesFret
   ALERT('Esse nao e um TES valido para frete')
   return .F.
ENDIF 

if ( Posicione('SC7',1,xFilial("SC7")+M->Z86_PEDIDO,"C7_FORNECE") <> M->Z86_FORNEC ) .or. ( Posicione('SC7',1,xFilial("SC7")+M->Z86_PEDIDO,"C7_LOJA") <> M->Z86_LOJA )
   alert('O Fornecedor desse pedido nao e igual ao do Conhecimento')
   RETURN .F. 
Endif



for _t := 1 to len(aCols)  

 	if empty(aCols[_t][1])        		
	   x:=_t
	   lRet:=.F.
	endIf 
	
	If ! aCols[_t,nPosDel]   
	   //freteSist:=freteSist+aCols[_t][nPosFREPES]+iif(_t=1,aCols[_t][nPosTXFIXA],0)+aCols[_t][nPosADVALO]+aCols[_t][nPosGRIS]+iif(_t=1,aCols[_t][nPosADM],0)+aCols[_t][nPosTDE]+aCols[_t][nPosPEDAGI]+aCols[_t][nPosSUFRAM]	     
	   //freteSist:=freteSist+( (aCols[_t][nPosFSICMS]-iif(_t=1,0,aCols[_t][nPosTXFIXA])-iif(_t=1,0,aCols[_t][nPosADM]) ) / ( 1 - (aCols[_t][nPosICMS] / 100) )  )
	   freteSist:=freteSist + aCols[_t][nPosFrete]
	endIf
next

If ! lRet
   msgAlert("Código da Nota faltando na linha " + alltrim(str(x)) + "." )
   Return lRet
endif

// PEGO O VALOR DO FRETE PELO PEDIDO
M->Z86_FRETE:=fValPed(M->Z86_PEDIDO)
//

// valor da tolerancia e  0.5 %
If round(freteSist,2)<>M->Z86_FRETE
   if freteSist < M->Z86_FRETE
      nTolfret := M->Z86_FRETE*(GetMv( "MV_TOLFRET" )/100)
      freteSist:=freteSist+nTolfret 
      ALERT('O valor calculado com tolerancia de ('+alltrim(str(GetMv( "MV_TOLFRET" )))+' )% '+alltrim(str(round(freteSist,2)))+' difere do valor do Conhecimento '+alltrim(str(round(M->Z86_FRETE,2))) )
   Else
      ALERT('O valor calculado '+alltrim(str(round(freteSist,2)))+' difere do valor do Conhecimento '+alltrim(str(round(M->Z86_FRETE,2))) )
   endif
endif

// VALOR DO FRETE DO SISTEMA 
M->Z86_FRESIS:=Round(freteSist,2)

// ENVIA EMAIL PARA FINANCEIRO E LOGISTICA
/*
if Inclui
   EMAIL(M->Z86_CONHEC,M->Z86_SERIE,M->Z86_FORNEC,M->Z86_LOJA,M->Z86_FRETE,M->Z86_FRESIS) 
endif
*/


Return lRet

*************

User Function TranspOK(cNota)

*************
local nPosNota  := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_NOTA"}) 
local ctranpN:=Posicione('SF2',1,xFilial("SF2")+cNota,"F2_TRANSP")
local ctranp1:=Posicione('SF2',1,xFilial("SF2")+aCols[1][nPosNota],"F2_TRANSP")
local cCliN:=Posicione('SF2',1,xFilial("SF2")+cNota,"F2_CLIENTE")
local cCli1:=Posicione('SF2',1,xFilial("SF2")+aCols[1][nPosNota],"F2_CLIENTE")

If n!=1     
   // VERIFICA SE A TRANSPORTADORA DA NOTA QUE ESTA SENDO DIGITADA E IGUAL A DA NOTA DA PRIMEIRA LINHA 
   IF ctranpN!= ctranp1
      alert("A transportadora "+alltrim(ctranpN)+" e diferente da transportadora "+alltrim(ctranp1)+ " da 1ª nota")
      RETURN .F.
   Endif
   // VERIFICA SE O CLIENTE DA NOTA QUE ESTA SENDO DIGITADO E IGUAL A DA NOTA DA PRIMEIRA LINHA    
   
   IF cCliN!= cCli1
      alert("O Cliente "+alltrim(cCliN)+" e diferente do Cliente "+alltrim(cCli1)+ " da 1ª nota")
      RETURN .F.
   Endif
   

Endif


Return .T.




*************

User Function CALC_FRETE(cDoc)

*************

local nPosDel:= len(aHeader)+1
Local nCubagem := 0
Local nVlrCubagem := 0
Local nVlrCUBA4   := 0
Local nQTVOLUMES  := 0
Local LF	   := CHR(13) + CHR(10)
Local aRet:={}
local nPosFrete  := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_FRETE"}) 
local nPosICMS    := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_ICMS"})
local nPosFSICMS  := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_FSICMS"})  
local nPosFREPES := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_FREPES"}) 
local nPosTXFIXA := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_TXFIXA"}) 
local nPosADVALO := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_ADVALO"}) 
local nPosflu    := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_FLUVIA"}) 
local nPosGRIS   := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_GRIS"}) 
local nPosADM    := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_ADM"}) 
local nPosPEDAGI := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_PEDAGI"}) 
local nPosSUFRAM := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_SUFRAM"})
local nPosTDE    := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_TDE" })
local nPosVALOR  := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_VALOR" })


SD2->( dbSetOrder( 3 ) )

dbSelectArea("SF2")
SD2->( dbSetOrder( 1 ) )

aFrete := {}

cQuery := "SELECT F2_DOC,F2_SERIE, F2_VALBRUT, F2_TRANSP, F2_REDESP, F2_LOCALIZ, F2_LOCRED, F2_EST, F2_VOLUME1 "+ LF
cQuery += ",D2_DOC, D2_SERIE, D2_PEDIDO, C5_NUM, F4_CODIGO, F4_DUPLIC  "+ LF
cQuery += ",CUBAGEM = SUM( B5_COMPRI * B5_LARGURA * B5_ALTURA ) "+ LF
cQuery += "FROM SF2020 SF2 "+ LF
cQuery += "join SD2020 SD2 on F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA=D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA  "+ LF
cQuery += "AND SD2.D_E_L_E_T_ = '' "+ LF
cQuery += "LEFT join SB5010 SB5 on case when len(D2_COD) >= 8 then "+ LF
cQuery += "case when ( SUBSTRING( D2_COD, 4, 1 ) = 'R') or ( SUBSTRING( D2_COD, 5, 1 ) = 'R') "+ LF
cQuery += "then SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 4) + SUBSTRING( D2_COD, 8, 2) "+ LF
cQuery += "else SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 3) + SUBSTRING( D2_COD, 7, 2) end "+ LF
cQuery += "else D2_COD END = B5_COD  "+ LF
cQuery += "AND SB5.D_E_L_E_T_ = ''  "+ LF
cQuery += "join SC5020 SC5 on D2_PEDIDO = C5_NUM  " + LF 
cQuery += "join SF4010 SF4 on D2_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = '' "+ LF
cQuery += " WHERE "+ LF
cQuery += "F2_TIPO  = 'N' "+ LF
// teste
//cQuery += " AND F2_DOC= '000027655'  " + LF
cQuery += " AND F2_DOC= '" +cDoc+ "'  " + LF
cQuery += " AND F2_FILIAL = '" + xFilial("SF2") + "' " + LF
// TESTE (diferenca com relacao ao faturamento diario)
//cQuery += "AND D2_CF IN  ('5101','6101','5102','6102','5109','6109','5107','6107','5949','6949','7501')  "+ LF
//cQuery += "AND D2_TES NOT  IN ('514','515') "+ LF
//EM 20/07/2012 - Emanuel solicitou que liberasse todos os TES e CFOPs
//E bloqueasse apenas as notas cujo frete for FOB
cQuery += " AND SF2.F2_TPFRETE = 'C' " + LF //só vai mostrar quando for Cif, pois Fob é o cliente que paga
cQuery += "AND SF2.D_E_L_E_T_ = '' "+ LF
cQuery += "GROUP BY  F2_DOC,F2_SERIE,F2_VALBRUT  , F2_TRANSP, F2_REDESP, F2_LOCALIZ, F2_LOCRED, F2_EST, F2_VALBRUT, F2_VOLUME1  "+ LF
cQuery += ",D2_DOC, D2_SERIE, D2_PEDIDO, C5_NUM, F4_CODIGO, F4_DUPLIC "+ LF
cQuery += "ORDER BY F2_DOC, F2_SERIE "+ LF


If Select("FT02") > 0
	DbSelectArea("FT02")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "FT02"  
FT02->( dbGoTop() )

While FT02->( !EOF())

   
   SZZ->(Dbsetorder(1))
   //  SZZ->(Dbsetorder(3))  // FILIAL+TRANSP+UF+LOCALIDADE   
   if Empty( FT02->F2_REDESP )   		
   		SZZ->( dbSeek( xFilial( "SZZ" ) + FT02->F2_TRANSP+FT02->F2_LOCALIZ ) )
   		//SZZ->( dbSeek( xFilial( "SZZ" ) + FT02->F2_TRANSP +FT02->F2_EST +FT02->F2_LOCALIZ ) )
      	Aadd( aFrete, { FT02->F2_TRANSP, FT02->F2_DOC, FT02->F2_SERIE, FT02->F2_LOCALIZ, " ", FT02->F2_EST + SZZ->ZZ_TIPO,ALLTRIM(getReg(FT02->F2_EST)), FT02->CUBAGEM, FT02->F2_VOLUME1,FT02->F2_EST } )
   //						1                 2              3                4           5        6                                 7                        8               9             10
   else   
          SZZ->( dbSeek( xFilial( "SZZ" ) + FT02->F2_REDESP+ FT02->F2_LOCALIZ ) )
   		//SZZ->( dbSeek( xFilial( "SZZ" ) + FT02->F2_REDESP +FT02->F2_EST+ FT02->F2_LOCALIZ ) )
      	Aadd( aFrete, { FT02->F2_TRANSP, FT02->F2_DOC, FT02->F2_SERIE, FT02->F2_LOCRED, " ", FT02->F2_EST + SZZ->ZZ_TIPO,ALLTRIM(getReg(FT02->F2_EST)),FT02->CUBAGEM, FT02->F2_VOLUME1,FT02->F2_EST } )
      	Aadd( aFrete, { FT02->F2_REDESP, FT02->F2_DOC, FT02->F2_SERIE, FT02->F2_LOCALIZ,"R", FT02->F2_EST + SZZ->ZZ_TIPO,ALLTRIM(getReg(FT02->F2_EST)),FT02->CUBAGEM, FT02->F2_VOLUME1,FT02->F2_EST } )
      	//                     1			2				3				4			 5	    	6				                    7				     8               9            10
   endif
   FT02->( dbSkip() )
	
Enddo

aFre_nf := Asort( aFrete,,, { |X,Y| X[7]+X[6]+X[1]+X[2]<Y[7]+Y[6]+Y[1]+Y[2] } )   
nDna    := nTot  := nFre := nTotal := nTotFret := nTotFrIcms := nTotIcms := nTotDna :=nTotRed := nTotpes:= nTotPesoFrete := 0
nDnaG   := nTotG := nFreG:= nTotGicms := 0
nDnaCI  := nTotCI:= nFreCI:= nTotCIicms := 0
//REGIAO
nTotCE:=nTotNE:=nTotNO:=nTotSD:=nTotSL:=0
nTotCEicms :=nTotNEicms :=nTotNOicms :=nTotSDicms :=nTotSLicms := 0
nFreCE :=nFreNE :=nFreNO :=nFreSD :=nFreSL :=0
nDnaCE :=nDnaNE :=nDnaNO :=nDnaSD :=nDnaSL :=0

nCubagem := 0
nQTVOLUMES := 0
//

if len(aFre_nf) > 0
	cEstCI  := Substr( aFre_nf[ 1, 6 ], 1, 2 )
endIf

For x := 1 to Len( aFre_nf )   
    cEstado := aFre_nf[ x, 6 ] 
    SX5->(DBSETORDER(1))
    SX5->( dbSeek( xFilial( "SX5" ) + "12" + Substr( cEstado, 1, 2 ) ) )    
    While aFre_nf[ x, 6 ] == cEstado       
       cTransp := aFre_nf[ x, 1 ]
       nCubagem    := 0
       nVlrCubagem := 0
       nVlrCUBA4   := 0                   //VLR CUBAGEM CADASTRADO NO SA4
       nQTVOLUMES  := aFre_nf[x,9]        //QTDE DE VOLUMES NA NOTA FISCAL               
       SA4->(DBSETORDER(1))
       If SA4->( dbSeek( xFilial( "SA4" ) + aFre_nf[ x, 1 ] ) )
       	nVlrCUBA4 := SA4->A4_VLRCUB     //VALOR DA CUBAGEM POR TRANSPORTADORA NO SA4
       Endif			
       While aFre_nf[ x, 1 ] == cTransp .and. aFre_nf[ x, 6 ] == cEstado
       
          nAd_valoren := 0
          nFluvial    := 0
          nFret_pes   := 0
          nTaxaFixa   := 0
          nADM		  := 0
          nPedagio	  := 0
          nSuframa	  := 0 
          nFretIcms	  := 0
          nFrete	  := 0
          nGRIS		  := 0
          nTDE		  := 0
          
          nCubagem:= aFre_nf[ x, 8 ]     //resultado da multiplicação (ALT X LARG X COMPRIMENTO)
           
          nVlrCubagem := (nCubagem * nVlrCUBA4 * nQTVOLUMES)   //valor a ser impresso no relatório
          
          SZZ->(DBSETORDER(1))
          //  SZZ->(DBSETORDER(3))  // FILIAL+TRANSP+UF+LOCALIDADE          

          SZZ->( dbSeek( xFilial( "SZZ" ) + aFre_nf[ x, 1 ]  + aFre_nf[ x, 4 ] ) )   
          //SZZ->( dbSeek( xFilial( "SZZ" ) + aFre_nf[ x, 1 ] + aFre_nf[ x, 10 ] + aFre_nf[ x, 4 ] ) )   
          
          SF2->(DBSETORDER(1))
          SF2->( dbSeek( xFilial( "SF2" ) + aFre_nf[ x, 2 ] + aFre_nf[ x, 3 ] ) )  //F2_DOC + F2_SERIE
          

          nValDna := 0
          
          //Fret Peso
          /*
          If SF2->F2_PLIQUI > 150
          	nFret_pes := (SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO)
            //SE O FRETE PESO CALCULADO FOR MENOR QUE O MÍNIMO, PEGA O MÍNIMO DO SA4
            If SZZ->ZZ_TIPO = 'C'    //CAPITAL
            	If nFret_pes < SA4->A4_FREMINC
            		nFret_pes := SA4->A4_FREMINC
            	Endif
            Elseif SZZ->ZZ_TIPO = 'I'   //INTERIOR
            	If nFret_pes < SA4->A4_FREMINI
            		nFret_pes := SA4->A4_FREMINI
            	Endif            
            Endif
            	
          ElseIf (SF2->F2_PLIQUI >= 101 .and. SF2->F2_PLIQUI <= 150)
          	If !Empty(SZZ->ZZ_101150K) 
          		nFret_pes := SZZ->ZZ_101150K
          	Else
          		nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          	Endif          	
          
          ElseIf SF2->F2_PLIQUI <= 10
            	If !Empty(SZZ->ZZ_1A10KG) 
          			nFret_pes := SZZ->ZZ_1A10KG 
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 20
          		If !Empty(SZZ->ZZ_11A20KG)
          			nFret_pes := SZZ->ZZ_11A20KG
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif SF2->F2_PLIQUI <= 30
          		If !Empty(SZZ->ZZ_21A30KG)
          			nFret_pes := SZZ->ZZ_21A30KG
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif SF2->F2_PLIQUI <= 40
          		If !Empty(SZZ->ZZ_31A40KG)
          			nFret_pes := SZZ->ZZ_31A40KG 
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 50
          		If !Empty(SZZ->ZZ_41A50KG)
          			nFret_pes := SZZ->ZZ_41A50KG 
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 60
          		If !Empty(SZZ->ZZ_51A60KG)
          			nFret_pes := SZZ->ZZ_51A60KG 
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 70
          		If !Empty(SZZ->ZZ_61A70KG)
          			nFret_pes := SZZ->ZZ_61A70KG
          			Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 80
          		If !Empty(SZZ->ZZ_71A80KG)
          			nFret_pes := SZZ->ZZ_71A80KG
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif SF2->F2_PLIQUI <= 90
          		If !Empty(SZZ->ZZ_81A90KG)
          			nFret_pes := SZZ->ZZ_81A90KG
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Else
          	If !Empty(SZZ->ZZ_91A100K)
          		nFret_pes := SZZ->ZZ_91A100K          	
          	Else
          		nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		
          	Endif          	
          
          Endif          
          */          
           // NOVO CALCULO DO FRETE 
          If SF2->F2_PLIQUI > 150
          	nFret_pes := (SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO)
            //SE O FRETE PESO CALCULADO FOR MENOR QUE O MÍNIMO, PEGA O MÍNIMO DO SA4
            If SZZ->ZZ_TIPO = 'C'    //CAPITAL
            	If nFret_pes < SA4->A4_FREMINC
            		nFret_pes := SA4->A4_FREMINC
            	Endif
            Elseif SZZ->ZZ_TIPO = 'I'   //INTERIOR
            	If nFret_pes < SA4->A4_FREMINI
            		nFret_pes := SA4->A4_FREMINI
            	Endif            
            Endif
            	
          ElseIf (SF2->F2_PLIQUI >= 101 .and. SF2->F2_PLIQUI <= 150)
          	If !Empty(SZZ->ZZ_101150K) 
          		nFret_pes := SZZ->ZZ_101150K
          	Else
          		nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          	Endif          	
          
          //FR - Flávia Rocha
          //chamado 002208:	Joao Emanuel
          //Para calculo de frete, quando a transportadora for cod 30
          // e o peso for até 10 KG, favor calcular só os valores abaixo:
          // Valor do campo de 1 a 10KG + Ad valorem (0,5%) sobre o valor da nota fiscal + Gris + Icms  
          ElseIf SF2->F2_PLIQUI <= 10
            	If !Empty(SZZ->ZZ_1A10KG) 
          			nFret_pes := SZZ->ZZ_1A10KG
          			If Alltrim( cTransp ) = "30"
          				nGRIS := ( SF2->F2_VALBRUT * SZZ->ZZ_GRIS) / 100	 //o Gris é o valor da nota vezes o Gris%
						//validação do Gris com o Gris mínimo (novo campo ZZ_GRISMIN)
						If !Empty(SZZ->ZZ_GRISMIN)
							If nGRIS <= SZZ->ZZ_GRISMIN
								nGRIS := SZZ->ZZ_GRISMIN
							Endif
						Endif
          				nFret_pes := SZZ->ZZ_1A10KG + ( SF2->F2_VALBRUT * 0.5 / 100 ) + nGRIS
          			Endif 
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 20
          		If !Empty(SZZ->ZZ_11A20KG)
          			nFret_pes := SZZ->ZZ_11A20KG
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif SF2->F2_PLIQUI <= 30
          		If !Empty(SZZ->ZZ_21A30KG)
          			nFret_pes := SZZ->ZZ_21A30KG
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif SF2->F2_PLIQUI <= 40
          		If !Empty(SZZ->ZZ_31A40KG)
          			nFret_pes := SZZ->ZZ_31A40KG 
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 50
          		If !Empty(SZZ->ZZ_41A50KG)
          			nFret_pes := SZZ->ZZ_41A50KG 
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 60
          		If !Empty(SZZ->ZZ_51A60KG)
          			nFret_pes := SZZ->ZZ_51A60KG 
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 70
          		If !Empty(SZZ->ZZ_61A70KG)
          			nFret_pes := SZZ->ZZ_61A70KG
          			Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          	
          Elseif SF2->F2_PLIQUI <= 80
          		If !Empty(SZZ->ZZ_71A80KG)
          			nFret_pes := SZZ->ZZ_71A80KG
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Elseif SF2->F2_PLIQUI <= 90
          		If !Empty(SZZ->ZZ_81A90KG)
          			nFret_pes := SZZ->ZZ_81A90KG
          		Else
          			nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		Endif
          		
          Else
          	If !Empty(SZZ->ZZ_91A100K)
          		nFret_pes := SZZ->ZZ_91A100K          	
          	Else
          		nFret_pes := ( SF2->F2_PLIQUI * SZZ->ZZ_FR_PESO )
          		
          	Endif          	
          
          Endif          
           
           //
           ///Modificação feita através do Chamado 001517 - 04/05/2010           
           	//TAXA FIXA
           	If !Empty(SZZ->ZZ_TXFIXA)
                // so considera taxa adm para primeira nota 
	     		nTaxaFixa := iif(n=1,SZZ->ZZ_TXFIXA,0)
	  		Endif
          	
          	//AD-VALOREM
          	If !Empty(SZZ->ZZ_ADVALOR)
	        	nAd_valoren := ( SF2->F2_VALBRUT * SZZ->ZZ_ADVALOR / 100 )	 
	        	         
			Elseif Alltrim( cTransp ) == "03" .and. Alltrim( SZZ->ZZ_LOCAL ) $ "07 09 20 59 94 46"
	      		nAd_valoren := ( SF2->F2_VALBRUT * 0.3 / 100 )
	      	Else
	      		nAd_valoren := 0
			Endif
			
			// TX FLUVIAL
			If !Empty(SZZ->ZZ_FLUVIAL)
	        	nFluvial := ( SF2->F2_VALBRUT * SZZ->ZZ_FLUVIAL / 100 )	 
	        Else
			    nFluvial := 0
			Endif
			
			
			//GRIS
			nGRIS := ( SF2->F2_VALBRUT * SZZ->ZZ_GRIS) / 100	 //o Gris é o valor da nota vezes o Gris%
			//validação do Gris com o Gris mínimo (novo campo ZZ_GRISMIN)
			If !Empty(SZZ->ZZ_GRISMIN)
				If nGRIS <= SZZ->ZZ_GRISMIN
					nGRIS := SZZ->ZZ_GRISMIN
				Endif
			Endif
			
			//ADM
			If !Empty(SZZ->ZZ_ADM)
				// so considera taxa adm para primeira nota 
				nADM := IIF(n=1,SZZ->ZZ_ADM,0) 
			Endif   
            
            //TDE
          	Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA, "A1_TDE")
          	nTDE := IIF(SA1->A1_TDE>0,SA1->A1_TDE,SZZ->ZZ_TDE)  
          	
            //PEDAGIO E SUFRAMA
            If SF2->F2_PLIQUI >= 100
	            Do Case
	            	Case ( SF2->F2_PLIQUI >= 100 .And. SF2->F2_PLIQUI < 101)
			            If !Empty(SZZ->ZZ_PEDAGIO)
			            	nPedagio := SZZ->ZZ_PEDAGIO
			            Endif
			            
			            If !Empty(SZZ->ZZ_SUFRAMA)
			            	nSuframa := SZZ->ZZ_SUFRAMA
			            Endif
	   	       		
	   	       		Case (SF2->F2_PLIQUI >= 101 .And. SF2->F2_PLIQUI <= 200 )
	   	       			If !Empty(SZZ->ZZ_PEDAGIO)
	   	       				nPedagio := ( SZZ->ZZ_PEDAGIO * 2 )
	   	       			Endif
	   	       			
	   	       			If !Empty(SZZ->ZZ_SUFRAMA)
	   	       				nSuframa := ( SZZ->ZZ_SUFRAMA * 2 )
	   	       			Endif
		  			
		  			Case (SF2->F2_PLIQUI >= 201)
		  				If !Empty(SZZ->ZZ_PEDAGIO)
		  					nPedagio := ( SF2->F2_PLIQUI / 100) * SZZ->ZZ_PEDAGIO
		  				Endif
		  				
		  				If !Empty(SZZ->ZZ_SUFRAMA)
		  					nSuframa := ( SF2->F2_PLIQUI / 100) * SZZ->ZZ_SUFRAMA
		  				Endif
		  				
		  		Endcase
	  		            
	  		Endif
            
            //SE A SOMA DAS TAXAS FOR MENOR QUE O VALOR DO FRETE MÍNIMO, ASSUME O FRETE MÍNIMO
	      	If ( nFret_pes + nTaxaFixa + nAd_valoren + nGRIS + nADM + nPedagio + nSuframa + nTDE + nFluvial ) >= SA4->A4_FREMINI
                nFrete :=round( nFret_pes,2) + round(nTaxaFixa,2) + round(nAd_valoren,2) + round(nGRIS,2) + round(nADM,2) + round(nPedagio,2) + round(nSuframa,2) + round(nTDE,2)+ round(nFluvial,2) 	          	    
          	Else
          		nFrete := round(SA4->A4_FREMINI,2)          	
          	Endif 
	                  
          Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA, "A1_TIPO")
          
          IF ALLTRIM(SF2->F2_TRANSP)!='80' // TRANSPORTADORA AGAPE E SEMPRE ZERO 
             nFretIcms :=  ( nFrete / ( 1 - (IIF(ALLTRIM(SA1->A1_TIPO)<>'F',SA4->A4_ICMS,17) / 100) )  )
          ELSE
             nFretIcms :=  ( nFrete / ( 1 - (SA4->A4_ICMS / 100) )  )
          ENDIF
          nValDna   := nValDna + SF2->F2_VALBRUT
          nPerc     := ( nFretIcms * 100 / nValDna ) 
          
          aCols[n][nPosFrete]:=   round(nFretIcms,2) // FRETE COM ICMS 
          
          IF ALLTRIM(SF2->F2_TRANSP)!='80' // TRANSPORTADORA AGAPE E SEMPRE ZERO 
              aCols[n][nPosICMS]:=IIF(ALLTRIM(SA1->A1_TIPO)<>'F',SA4->A4_ICMS,17) 
          ELSE
              aCols[n][nPosICMS]:=SA4->A4_ICMS  
	      ENDIF
	      aCols[n][nPosFSICMS]:= round(nFrete,2) // FRETE SEM ICMS
	     
	      If xFilial("SF2") != '03'    //SE NÃO FOR FILIAL CAIXAS, SEGUE NORMAL
	         aCols[n][nPosFREPES]:=round(nFret_pes,2)         
	      Elseif xFilial("SF2") = '03' 
	         If SF2->F2_PLIQUI > nVlrCubagem
		        aCols[n][nPosFREPES]:=round(nFret_pes,2)
		     Else
		        aCols[n][nPosFREPES]:= round((nVlrCubagem * SZZ->ZZ_FR_PESO),2)
		     Endif
	      Endif
	      aCols[n][nPosTXFIXA]:= round(nTaxaFixa,2)
	      aCols[n][nPosADVALO]:= round(nAd_valoren,2) 
	      aCols[n][nPosflu]:= round(nFluvial,2) 
	      aCols[n][nPosGRIS]:= round(nGRIS,2)	
	      aCols[n][nPosADM]:= round(nADM,2)		
	      aCols[n][nPosTDE]:= round(nTDE,2)		
	      aCols[n][ nPosPEDAGI]:= round(nPedagio,2)	
	      aCols[n][nPosSUFRAM]:= round(nSuframa,2) 
	      aCols[n][nPosVALOR]:=SF2->F2_VALBRUT  	       
	                         
          
          oSayT:SetText(transform( fValor() ,'@E 999,999.99')) 
          ObjectMethod( oSayT, "Refresh()" )
          
          Return .T.
       
       enddo
    Enddo    
Next


Return .T.



***************

Static Function getReg(cUF)

***************

Local cRGNO := "AC AM AP PA RO RR TO"
Local cRGNE := "MA PI CE RN PB PE AL BA SE"
Local cRGCE := "GO MT MS DF"
Local cRGSD := "MG ES RJ SP"
Local cRGSL := "RS PR SC"

if cUF $ cRGNO
	return "NO"
elseIf cUF $ cRGNE
	return "NE"
elseIf cUF $ cRGCE
	return "CE"
elseIf cUF $ cRGSD
	return "SD"	
elseIf cUF $ cRGSL
	return "SL"				
endIf	
   
Return 

*************

User Function VLDNOTA(cNota)

************* 

local nPosNota := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_NOTA" })  

if n!=1
	for _x:=len(aCols)  To 1 Step -1 
		if _x!=n
			if aCols[_x][nPosNota]=cNota
				alert("A Nota nao pode se repetir")
				return .F.
			endif
	    endif
	next _x
endif

return .T.



*************

User Function LegCon()

*************

Local aLegenda := {{"BR_VERDE"     ," Sem Divergencia" },;
   	   			   {"BR_VERMELHO" ,"Com Divergencia" }}                          


BrwLegenda("Conhecimento de Frete","Legenda",aLegenda)		   		

Return .T.

***************

Static Function EMAIL(cConhec,cSerie,cFornec,cLoja,nFrete,nSist)

***************

oProcess:=TWFProcess():New("CONHEC","CONHEC")
oProcess:NewTask('Inicio',"\workflow\http\emp01\CONHEC.html")
oHtml   := oProcess:oHtml
 
oHtml:ValByName("cStatus",iif(inclui,'Incluido','Excluido') )

aadd( oHtml:ValByName("it.Conchec") ,cConhec )
aadd( oHtml:ValByName("it.Serie" ) , cSerie  )
aadd( oHtml:ValByName("it.Fornec" ) , cFornec+' - '+ Posicione('SA2',1,xFilial("SA2")+cFornec+cLoja,"A2_NOME" ) )
aadd( oHtml:ValByName("it.Loja" ) , cLoja  )
aadd( oHtml:ValByName("it.Frete" ) , transform(nFrete,'@E 999,999.99')  )
aadd( oHtml:ValByName("it.Sistema" ) , transform(nSist,'@E 999,999.99')  )

_user := Subs(cUsuario,7,15)
oProcess:ClientName(_user)
//oProcess:cTo := "antonio@ravaembalagens.com.br"
//oProcess:cTo := "logistica@ravaembalagens.com.br;financeiro@ravaembalagens.com.br;tercio@ravaembalagens.com.br"
oProcess:cTo := "logistica@ravaembalagens.com.br;tercio@ravaembalagens.com.br"
subj	:= "Conhecimento de frete "+cConhec+ ' - '+iif(inclui,'Incluido','Excluido')
oProcess:cSubject  := subj
oProcess:Start()
WfSendMail()
oProcess:Finish()

Return 


***************

Static Function fValor()

**************
local nPosDel:= len(aHeader)+1
local nValor:=0
local nPosFrete  := aScan(aHeader,{|x| Alltrim(x[2]) == "Z87_FRETE"}) 

for _t := 1 to len(aCols)  
	
	If ! aCols[_t,nPosDel]   
	   nValor+=aCols[_t][nPosFrete]
	endIf
next

Return nValor 


*************

User Function fDelOk()

*************

oSayT:SetText(transform( fValor() ,'@E 999,999.99')) 
ObjectMethod( oSayT, "Refresh()" )
          
Return .T.


*************

Static Function fDocEnt()

*************

aCab  := {}
aItens := {}
lMsErroAuto := .F.
lConsMedic:=lNfMedic:=.T. 
nCtn:=1

//Begin Transaction
    

DBSELECTAREA('SC7')
DBSETORDER(1)
SC7->( dbSeek( xFilial( "SC7" ) +M->Z86_PEDIDO) )


aCab := { {"F1_FILIAL   "         , XFILIAL('SF1' )              , Nil},;  
          {"F1_TIPO   "           , "N"              , Nil},;  
          {"F1_FORMUL "           , ''         , Nil},;  
          {"F1_DOC    "           , M->Z86_CONHEC           , Nil},;  
          {"F1_SERIE  "           , M->Z86_SERIE           , Nil},;  
          {"F1_EMISSAO"           , /*M->Z86_EMISSA*/ dDataBase         , Nil},;  
          {"F1_FORNECE"           , SC7->C7_FORNECE  , Nil},;  
          {"F1_LOJA   "           , SC7->C7_LOJA            , Nil},;  
          {"F1_ESPECIE"           , M->Z86_ESPECI            , Nil},;  
          {"F1_DTDIGIT"           , DdATAbASE         , Nil},;  
          {"F1_EST"               , posicione("SA2",1, xFilial("SA2") + SC7->C7_FORNECE+SC7->C7_LOJA, "A2_EST" )   , Nil}}   

                                   

While SC7->(!EOF()) .AND. SC7->C7_NUM=M->Z86_PEDIDO 

       Aadd(aItens, {{"D1_FILIAL"     ,XFILIAL('SD1'),NIL},; 
                       {"D1_ITEM"     ,SC7->C7_ITEM,NIL},; 
                       {"D1_COD"      ,SC7->C7_PRODUTO,NIL},; 
                       {"D1_UM"       ,SC7->C7_UM ,NIL},;
                       {"D1_QUANT"    ,SC7->C7_QUANT,NIL},; 
                       {"D1_VUNIT"    ,SC7->C7_PRECO,NIL},; 
                       {"D1_TOTAL"    ,SC7->C7_QUANT*SC7->C7_PRECO,NIL},;                        
                       {"D1_TES"      ,M->Z86_TES,NIL},; 
                       {"D1_VALIPI"   ,0,NIL},; 
                       {"D1_PEDIDO"   ,SC7->C7_NUM,nil},;
                       {"D1_ITEMPC"   ,SC7->C7_ITEM,nil},;  
                       {"D1_CC"       ,SC7->C7_CC,nil},;
                       {"D1_CONTA"   ,SC7->C7_CONTA,nil},;                                                                                     
                       {"D1_VALICM"   ,SC7->C7_VALICM,NIL}})  
nCtn+=1
SC7->(DBSKIP())
Enddo

    LMsErroAuto:=.F. 
    IF Z86->Z86_FRETE>Z86->Z86_FRESIS // DIVERGENCIA NO FRETE 
       MsExecAuto({|x,y,z,w| Mata103(x,y,z,w)},aCab,aItens,3,.F.  )  // doc entrada 
    ELSE
       MsExecAuto({|x,y,z| Mata140(x,y,z)},aCab,aItens,3  ) // PREE-NOTA
    ENDIF  

		IF lMsErroAuto
			alert('favor contactar o TI.')
			DisarmTransaction()
			MostraErro()
		ELSE
		    IF Z86->Z86_FRETE>Z86->Z86_FRESIS // DIVERGENCIA NO FRETE                     
		       EMAILBLOQ(Z86->Z86_CONHEC,Z86->Z86_SERIE,Z86->Z86_FORNEC,Z86->Z86_LOJA,Z86->Z86_FRETE,Z86->Z86_FRESIS,'Bloqueado') 
		    ELSEIF Z86->Z86_FRETE<Z86->Z86_FRESIS // ALERTA PARA MARCELO QUE O FRETE DO SISTEMA E MAIOR QUE O FRETE DA TRANSPORTADORA 
		       EMAILBLOQ(Z86->Z86_CONHEC,Z86->Z86_SERIE,Z86->Z86_FORNEC,Z86->Z86_LOJA,Z86->Z86_FRETE,Z86->Z86_FRESIS,'Sistema Calculou a Maior') 
		    ENDIF
		Endif


//End Transaction

Return ! lMSErroAuto
          

***************

Static Function fValPed(cPedi)

***************
local cQry:=''
local nRet:=0

If Select("TMPX") > 0
  DbSelectArea("TMPX")
  TMPX->(DbCloseArea())
EndIf



cQry:="SELECT SUM(C7_TOTAL) TOTAL FROM SC7020 "
cQry+="WHERE C7_NUM='"+cPedi+"' "
cQry+="AND C7_FILIAL='"+xFilial('SC7')+"' "
cQry+="AND D_E_L_E_T_<>'*' "
TCQUERY cQry NEW ALIAS 'TMPX'

if TMPX->(!EOF())
   nRet:=TMPX->TOTAL
Endif

Return nRet



***************

Static Function EMAILBLOQ(cConhec,cSerie,cFornec,cLoja,nFrete,nSist,cStatus)

***************

NFREPES:=0
NTXFIXA:=0
NADVALO:=0
NGRIS:=0
NADM:=0
NPEDAGI:=0
NSUFRAM:=0
NTDE:=0
NFLUVIA:=0


//
cMensagem:=' '
cMensagem+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
cMensagem+='<html xmlns="http://www.w3.org/1999/xhtml"> '
cMensagem+='<head> '
cMensagem+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
cMensagem+='<title>Untitled Document</title> '
cMensagem+='<style type="text/css"> '
cMensagem+='<!-- '
cMensagem+='.style7 {	font-family: Arial, Helvetica, sans-serif; '
cMensagem+='	font-size: 14px; '
cMensagem+='} '
cMensagem+='.style9 {	font-family: Arial, Helvetica, sans-serif; '
cMensagem+='	color: #FFFFFF;   '
cMensagem+='	font-size: 14px; '
cMensagem+='} '
cMensagem+='.style1 {font-family: Geneva, Arial, Helvetica, sans-serif} '
cMensagem+='.style11 {font-family: Arial, Helvetica, sans-serif; font-size: 14px; color: #FF0066; }
cMensagem+='-->  '
cMensagem+='</style> '
cMensagem+='</head>  '

cMensagem+='<body> '
cMensagem+='<p><a target="_blank" href="http://www.ravaembalagens.com.br"></a></p> '
cMensagem+='<p> '
cMensagem+='    <span class="style7">Segue abaixo informa&ccedil;&otilde;es do conhecimento de frete '+cStatus+'.</span></p> '
cMensagem+='<table width="941" height="48" border="1"> '
cMensagem+='  <tr> '
cMensagem+='    <td width="116" height="20" bgcolor="#00CC66"><span class="style9">N&ordm; Conchecimento </span></td> '
cMensagem+='    <td width="78" bgcolor="#00CC66"><span class="style9">Serie</span></td>  '
cMensagem+='    <td width="400" bgcolor="#00CC66"><span class="style9">Fornecedor</span></td>  '
cMensagem+='    <td width="73" bgcolor="#00CC66"><span class="style9">Loja </span></td>  '
cMensagem+='    <td width="143" bgcolor="#00CC66"><span class="style9">Valor do Frete </span></td> '
cMensagem+='    <td width="91" bgcolor="#00CC66"><span class="style9">Frete Sstema </span></td> '
cMensagem+='  </tr>  '
// 
cMensagem+='  <tr> '
cMensagem+='    <td height="20"><span class="style7">'+cConhec+'</span></td>  '
cMensagem+='    <td width="78"><span class="style7">'+cSerie+'</span></td>  '
cMensagem+='    <td width="400"><span class="style7">'+cFornec+' - '+ Posicione('SA2',1,xFilial("SA2")+cFornec+cLoja,"A2_NOME" )+'</span></td>  '
cMensagem+='    <td width="73"><span class="style7">'+cloja+'</span></td> '
cMensagem+='    <td><span class="style7">'+transform(nFrete,'@E 999,999.99')+'</span></td>  '
cMensagem+='    <td><span class="style7">'+transform(nSist,'@E 999,999.99')+'</span></td> '
cMensagem+='  </tr> '
//
cMensagem+='</table> '
cMensagem+='<p>Conchecimento:</p> '
cMensagem+='<table width="946" height="48" border="1"> '
cMensagem+='  <tr> '
cMensagem+='    <td width="115" height="20" bgcolor="#00CC66"><span class="style9">Frete Peso </span></td> '
cMensagem+='    <td width="77" bgcolor="#00CC66"><span class="style9">Tx. Fixa </span></td> '
cMensagem+='    <td width="95" bgcolor="#00CC66"><span class="style9">Ad-Valoren</span></td>  '
cMensagem+='    <td width="74" bgcolor="#00CC66"><span class="style9">GRIS </span></td>  '
cMensagem+='    <td width="78" bgcolor="#00CC66"><span class="style9">Tx. Adm </span></td>  '
cMensagem+='    <td width="85" bgcolor="#00CC66"><span class="style9">Pedagio</span></td>  '
cMensagem+='    <td width="92" bgcolor="#00CC66"><span class="style9">Suframa</span></td>  '
cMensagem+='    <td width="108" bgcolor="#00CC66"><span class="style9">TDE</span></td>  '
cMensagem+='    <td width="600" bgcolor="#00CC66"><span class="style9">Fluvial</span></td> '
cMensagem+='    <td width="929" bgcolor="#00CC66"><span class="style9">Valor ICMS</span></td> '
cMensagem+='  </tr>  '
// conche.
cMensagem+='  <tr> '
cMensagem+='    <td height="20"><span class="style7">'+transform(Z86->Z86_FREPES,'@E 999,999.99')+'</span></td>  '
cMensagem+='    <td width="77"><span class="style7">'+transform(Z86->Z86_TXFIXA,'@E 9,999.99')+'</span></td>  '
cMensagem+='    <td width="95"><span class="style7">'+transform(Z86->Z86_ADVALO,'@E 9,999,999.99')+'</span></td> '
cMensagem+='    <td width="74"><span class="style7">'+transform(Z86->Z86_GRIS,'@E 999,999.99')+'</span></td> '
cMensagem+='    <td><span class="style7">'+transform(Z86->Z86_ADM,'@E 999,999.99')+'</span></td>  '
cMensagem+='    <td><span class="style7">'+transform(Z86->Z86_PEDAGI,'@E 999,999.99')+'</span></td> '
cMensagem+='    <td><span class="style7">'+transform(Z86->Z86_SUFRAM,'@E 999,999.99')+'</span></td>  '
cMensagem+='    <td><span class="style7">'+transform(Z86->Z86_TDE,'@E 999,999.99')+'</span></td>  '
cMensagem+='    <td><span class="style7">'+transform(Z86->Z86_FLUVIA,'@E 9,999,999.99')+'</span></td> '
cMensagem+='    <td><span class="style7">'+transform(Z86->Z86_VALICM,'@E 9,999.99')+'</span></td> '
cMensagem+='  </tr>  '
//
cMensagem+='</table>  '
cMensagem+='<p>Sistema:</p> '
cMensagem+='<table width="1010" height="48" border="1"> '
cMensagem+='  <tr> '
cMensagem+='    <td width="95" bgcolor="#00CC66"><span class="style9">Nota</span></td>  '
cMensagem+='    <td width="132" height="20" bgcolor="#00CC66"><span class="style9">Frete Peso </span></td> '
cMensagem+='    <td width="76" bgcolor="#00CC66"><span class="style9">Tx. Fixa </span></td>  '
cMensagem+='    <td width="97" bgcolor="#00CC66"><span class="style9">Ad-Valoren</span></td> '
cMensagem+='    <td width="73" bgcolor="#00CC66"><span class="style9">GRIS </span></td>   '
cMensagem+='    <td width="77" bgcolor="#00CC66"><span class="style9">Tx. Adm </span></td> '
cMensagem+='    <td width="101" bgcolor="#00CC66"><span class="style9">Pedagio</span></td> '
cMensagem+='    <td width="101" bgcolor="#00CC66"><span class="style9">Suframa</span></td>  '
cMensagem+='    <td width="86" bgcolor="#00CC66"><span class="style9">TDE</span></td> '
cMensagem+='    <td width="108" bgcolor="#00CC66"><span class="style9">Fluvial</span></td> '
cMensagem+='  </tr> '
// sistema
//aNotas:=Notas(cConhec)
aNotas:=Notas(cConhec,cSerie,cFornec,cLoja)
For _x:=1 to len(aNotas)

	cMensagem+='  <tr> '
	cMensagem+='    <td><span class="style7">'+aNotas[_x][1]+'</span></td>  '
	cMensagem+='    <td height="20"><span class="style7">'+transform(aNotas[_x][4],'@E 999,999.99')+'</span></td>  '
	cMensagem+='    <td width="76"><span class="style7">'+transform(aNotas[_x][5],'@E 9,999.99')+'</span></td>  '
	cMensagem+='    <td width="97"><span class="style7">'+transform(aNotas[_x][6],'@E 9,999,999.99')+'</span></td>   '
	cMensagem+='    <td width="73"><span class="style7">'+transform(aNotas[_x][7],'@E 999,999.99')+'</span></td> '
	cMensagem+='    <td><span class="style7">'+transform(aNotas[_x][8],'@E 999,999.99')+'</span></td>  '
	cMensagem+='    <td><span class="style7">'+transform(aNotas[_x][9],'@E 999,999.99')+'</span></td> '
	cMensagem+='    <td><span class="style7">'+transform(aNotas[_x][10],'@E 999,999.99')+'</span></td> '
	cMensagem+='    <td><span class="style7">'+transform(aNotas[_x][11],'@E 999,999.99')+'</span></td>  '
	cMensagem+='    <td><span class="style7">'+transform(aNotas[_x][14],'@E 9,999,999.99')+'</span></td> '
	cMensagem+='  </tr> '

	NFREPES+=aNotas[_x][4]
	NTXFIXA+=aNotas[_x][5]
	NADVALO+=aNotas[_x][6]
	NGRIS+=aNotas[_x][7]
	NADM+=aNotas[_x][8]
	NPEDAGI+=aNotas[_x][9]
	NSUFRAM+=aNotas[_x][10]
	NTDE+=aNotas[_x][11]
	NFLUVIA+=aNotas[_x][14]
	

next
// TOTAIS 
	cMensagem+='  <tr> '
	cMensagem+='    <td><span class="style7">'+'Total: '+'</span></td>  '	
	cMensagem+='    <td height="20"><span class='+iif(Z86->Z86_FREPES<>NFREPES,"style11","style7")+'>'+transform(NFREPES,'@E 999,999.99')+'</span></td>  '
	cMensagem+='    <td width="76"><span class='+iif(Z86->Z86_TXFIXA<>NTXFIXA,"style11","style7")+'>'+transform(NTXFIXA,'@E 9,999.99')+'</span></td>  '
	cMensagem+='    <td width="97"><span class='+iif(Z86->Z86_ADVALO<>NADVALO,"style11","style7")+'>'+transform(NADVALO,'@E 9,999,999.99')+'</span></td>   '
	cMensagem+='    <td width="73"><span class='+iif(Z86->Z86_GRIS<>NGRIS,"style11","style7")+'>'+transform(NGRIS,'@E 999,999.99')+'</span></td> '
	cMensagem+='    <td><span class='+iif(Z86->Z86_ADM<>NADM,"style11","style7")+'>'+transform(NADM,'@E 999,999.99')+'</span></td>  '
	cMensagem+='    <td><span class='+iif(Z86->Z86_PEDAGI<>NPEDAGI,"style11","style7")+'>'+transform(NPEDAGI,'@E 999,999.99')+'</span></td> '
	cMensagem+='    <td><span class='+iif(Z86->Z86_SUFRAM<>NSUFRAM,"style11","style7")+'>'+transform(NSUFRAM,'@E 999,999.99')+'</span></td> '
	cMensagem+='    <td><span class='+iif(Z86->Z86_TDE<>NTDE,"style11","style7")+'>'+transform(NTDE,'@E 999,999.99')+'</span></td>  '
	cMensagem+='    <td><span class='+iif(Z86->Z86_FLUVIA<>NFLUVIA,"style11","style7")+'>'+transform(NFLUVIA,'@E 9,999,999.99')+'</span></td> '
	cMensagem+='  </tr> '

//
//
cMensagem+='</table>  ' 
cMensagem+='<p><strong>OBS:</strong></p>   '
cMensagem+='<table width="1005" border="1"> '
cMensagem+='  <tr>
IF ! EMPTY(Z86->Z86_OBS)
   cMensagem+='    <td>'+Z86->Z86_OBS+'</td>  '
ELSE
   cMensagem+='    <td>SEM OBS</td>  '
ENDIF
cMensagem+='  </tr>  '
cMensagem+='</table>   '
cMensagem+='<p>&nbsp;</p>  '

cMensagem+='<p></p> '
cMensagem+='<p>&nbsp;</p> '
cMensagem+='</body> '
cMensagem+='</html> '

// Teste
//cEmail   :="antonio@ravaembalagens.com.br"
cEmail  := "marcelo@ravaembalagens.com.br"
cEmail  += ";orley@ravaembalagens.com.br"
cEmail  += ";joao.emanuel@ravaembalagens.com.br"
cEmail  += ";logistica@ravaembalagens.com.br"

cAssunto := "Conhecimento de frete "+cConhec+ ' - '+cStatus+'.'

U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )
//ACSendMail(,,,,cEmail,cAssunto,cMensagem,)


Return 


***************

Static Function Notas(cConhe,cSerie,cFornec,cLoja)

***************

Local cQry:=''
LOCAL aRet:={}

cQry:="SELECT *  "
cQry+="FROM  " + RetSqlName("Z87") + " Z87 "
cQry+="WHERE  Z87_CODCON='"+cConhe+"'"
cQry+="AND Z87_FILIAL='"+XFILIAL('Z87')+"'  "
cQry+="AND Z87_SERIE='"+cSerie+"'  " 
cQry+="AND Z87_FORNEC='"+cFornec+"'  "
cQry+="AND Z87_LOJA='"+cLoja+"'  "
cQry+="AND Z87.D_E_L_E_T_ = ''  "

TCQUERY cQry NEW ALIAS 'TMPY'

if TMPY->(!EOF())
	Do While  TMPY->(!EOF())
	Aadd( aRet, { TMPY->Z87_NOTA,TMPY->Z87_VALOR,TMPY->Z87_FRETE,TMPY->Z87_FREPES,TMPY->Z87_TXFIXA,TMPY->Z87_ADVALO,TMPY->Z87_GRIS,TMPY->Z87_ADM,TMPY->Z87_PEDAGI,TMPY->Z87_SUFRAM,TMPY->Z87_TDE,TMPY->Z87_ICMS,TMPY->Z87_FSICMS,TMPY->Z87_FLUVIA} )
	TMPY->(DBSKIP())
	EndDo
ELSE
    Aadd( aRet, { "",0,0,0,0,0,0,0,0,0,0,0,0} )
ENDIF
TMPY->(DBCLOSEAREA())

Return aRet

***************************
Static Function fStatusBRW(cConc,cSerie) 
***************************

Local cQuery := "" 
Local LF     := CHR(13) + CHR(10) 
Local cStatus:= ""

cQuery := " SELECT F1_STATUS " + LF
//cQuery += " SUBSTRING(Z86_DATA,7,2)+'/'+SUBSTRING(Z86_DATA,5,2)+'/'+SUBSTRING(Z86_DATA,1,4) DATA , " + LF
cQuery += " ,FILIAL = CASE WHEN Z86_FILIAL='01' THEN 'Saco' else 'Caixa'end  " + LF
cQuery += " ,Z86_CONHEC CONHECIMENTO,Z86_SERIE SERIE ,Z86_FORNEC FORNECEDOR ,Z86_LOJA LOJA  " + LF
cQuery += " ,NOME=(SELECT A2_NOME FROM SA2010 SA2 WHERE A2_COD=Z86_FORNEC AND A2_LOJA=Z86_LOJA AND SA2.D_E_L_E_T_='') " + LF
cQuery += " ,Z86_FRETE FRETE ,Z86_FRESIS FRETE_SISTEMA ,F1_STATUS " + LF

cQuery += " FROM " + LF
cQuery += " " + RetSqlName("Z86") + " Z86 " + LF
cQuery += " ,"+ RetSqlName("SF1") + " SF1 " + LF
cQuery += " WHERE " + LF
//cQuery += " Z86_DATA>='20131227' " + LF
//cQuery += " AND F1_STATUS  IN('B') -- bloqueado " + LF
cQuery += " Z86_FILIAL = '" + Alltrim(xFilial("Z86")) + "' " + LF
cQuery += " AND Z86_CONHEC = F1_DOC " + LF
cQuery += " AND Z86_SERIE  = F1_SERIE " + LF
cQuery += " AND Z86_FORNEC = F1_FORNECE " + LF
cQuery += " AND Z86_LOJA   = F1_LOJA " + LF

cQuery += " AND Z86_CONHEC = '" + Alltrim(cConc)    + "' " + LF
cQuery += " AND Z86_SERIE  = '" + Alltrim(cSerie)   + "' " + LF
//cQuery += " AND Z86_FORNEC = '" + Alltrim(cFornece) + "' " + LF
//cQuery += " AND Z86_LOJA   = '" + Alltrim(cLoja)    + "' " + LF

cQuery += " AND Z86.D_E_L_E_T_='' " + LF
cQuery += " AND SF1.D_E_L_E_T_='' " + LF
//cQuery += " ORDER BY Z86_DATA,Z86_CONHEC " + LF
MemoWrite("C:\TEMP\ST_FATCONC.SQL",cQuery )

If Select("TMPS") > 0
	DbSelectArea("TMPS")
	DBCloseArea()
Endif            

TCQUERY cQry NEW ALIAS 'TMPS'

If !TMPS->(EOF())
	TMPS->(Dbgotop()) 
	cStatus := iif(Alltrim(TMPS->F1_STATUS) = "" , "" , iif( Alltrim(TMPS->F1_STATUS)= "A", "Liberado" , "Bloqueado" )  )	
Endif

DbSelectArea("TMPS")
DBCloseArea()

Return(cStatus)

