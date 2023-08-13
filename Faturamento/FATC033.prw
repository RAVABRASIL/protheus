#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FATC033 - Bonificacao de clientes     º Data ³  11/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±ºAutoria   ³ Gustavo Costa                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

**************************
User Function FATC033()  
**************************

Local aIndexSB1 := {}
Local cFiltraSB1:= ""									// Expressão do filtro 
Local nTamanho  := 0
Local nPos		:= 0
Local cPos		:= "" 

Local aCores := {{"EMPTY(ZC7_STATUS)", "BR_VERDE"   },;		   			   
                 {"ZC7_STATUS='X'", "BR_VERMELHO"   }}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := ""
       

Private aRotina := {{"Pesquisar"	,"AxPesqui",0,1} ,;
             		{"Visualizar"	,"U_FCadMod",0,2} ,;
             		{"Incluir"		,"U_FCadMod",0,3} ,;
             		{"Alterar"		,"U_FCadMod",0,4} ,;
             		{"Relatório"	,"U_fRelMeta()",0,2} ,;
             		{"&Legenda"		,"fLeg033()", 0, 5} }
             
             
             //{"Conferir","U_fConfP()",0,4},;
Private cCadastro := OemToAnsi("Cadastro de Lote ")
Private cAlias1	   := "ZC8"	    // Alias de detalhe
Private lSemItens  := .F.		// Permite a nao existencia de itens
//Private cChave	   := "ZC7_FILIAL+ZC7_CLIENT+ZC7_LOJA"  // Chave que ligara a primeira tabela com a segunda
//Private cChave1	   := "ZC8_FILIAL+ZC8_CLIENT+ZC8_LOJA"  // Chave que ligara a segunda tabela com a primeira
//Private aChaves    := {{"ZC8_FILIAL+ZC8_CLIENT+ZC8_LOJA", "M->ZC7_FILIAL+M->ZC7_CLIENT+M->ZC7_LOJA"}}
Private cChave	   := "ZC7_CLIENT+ZC7_LOJA"  // Chave que ligara a primeira tabela com a segunda
Private cChave1	   := "ZC8_CLIENT+ZC8_LOJA"  // Chave que ligara a segunda tabela com a primeira
Private aChaves    := {}
Private cLinhaOk   := "AllwaysTrue()" //Funcao LinhaOk para a GetDados
Private cTudoOk    := "AllwaysTrue()" //Funcao TudoOk para a GetDados
Private cDelOK     :="AllwaysTrue()" //Funcao TudoOk para a GetDados

Private cString := "ZC7" 

AADD(aChaves,{"ZC8_CLIENT", "M->ZC7_CLIENT"})
AADD(aChaves,{"ZC8_LOJA", "M->ZC7_LOJA"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a funcao MBROWSE. Sintaxe:                                  ³
//³                                                                     ³
//³ mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              ³
//³ Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   ³
//³                        exibido. Para seguir o padrao da AXCADASTRO  ³
//³                        use sempre 6,1,22,75 (o que nao impede de    ³
//³                        criar o browse no lugar desejado da tela).   ³
//³                        Obs.: Na versao Windows, o browse sera exibi-³
//³                        do sempre na janela ativa. Caso nenhuma este-³
//³                        ja ativa no momento, o browse sera exibido na³
//³                        janela do proprio SIGAADV.                   ³
//³ Alias                - Alias do arquivo a ser "Browseado".          ³
//³ aCampos              - Array multidimensional com os campos a serem ³
//³                        exibidos no browse. Se nao informado, os cam-³
//³                        pos serao obtidos do dicionario de dados.    ³
//³                        E util para o uso com arquivos de trabalho.  ³
//³                        Segue o padrao:                              ³
//³                        aCampos := { {<CAMPO>,<DESCRICAO>},;         ³
//³                                     {<CAMPO>,<DESCRICAO>},;         ³
//³                                     . . .                           ³
//³                                     {<CAMPO>,<DESCRICAO>} }         ³
//³                        Como por exemplo:                            ³
//³                        aCampos := { {"TRB_DATA","Data  "},;         ³
//³                                     {"TRB_COD" ,"Codigo"} }         ³ 
//                         essa ordem acima tá inversa - FR - 09/11/11
//³ cCampo               - Nome de um campo (entre aspas) que sera usado³
//³                        como "flag". Se o campo estiver vazio, o re- ³
//³                        gistro ficara de uma cor no browse, senao fi-³
//³                        cara de outra cor.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
/*
aCampos := { {"Dt.Conferido", "B1_DTCONFE"},; 
			{"Conferido Por", "B1_USRCONF"},; 
			{"Codigo", "B1_COD"},;           
            {"Descricao"  ,"B1_DESC"} }  
*/
cCadastro := OemToAnsi("Cadastro de Meta de Bonificação dos Clientes" )

DbSelectArea("ZC7" )
DbSetOrder(1)

mBrowse( 06, 01, 22, 75, "ZC7",,,,,,aCores)

Return


*************

User Function FCadMod(cAlias,nReg,nOpc)

*************

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

//nOpc:=2 // sempre visualizar 

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a integridade dos campos de Bancos de Dados    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
/*
IF ! INCLUI .And. LastRec() == 0
	Help(" ",1,"A000FI")
	Return (.T.)
Endif
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se esta' na filial correta                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If ! INCLUI .And. xFilial(cAlias) != &(cPref + "_FILIAL")
	Help(" ",1,"A000FI")
	Return
Endif
*/

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

	oGetd := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,cLinhaOk,cTudoOk,cContador, .T.)
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

******************************************************************************************************
User Function fLeg033()
******************************************************************************************************


BrwLegenda( "Legenda", cCadastro, { {"BR_VERMELHO", "Campanha Inativa"},{"BR_VERDE", "Campanha Ativa"} })

Return(Nil)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fRelMeta    ³ Autor ³ Gustavo Costa        ³ Data ³06.03.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio COMPARATIVO DAS METAS DE BONIFICACAO DOS CLIENTES  .³±±
±±³          ³  LINHA                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function fRelMeta()

Local oReport
Local cPerg	:= "FATC33"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.T.)

Processa({|| expExcel()},"Aguarde","Exportando para Excel...") 

//oReport:= ReportDef()
//oReport:PrintDialog()


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FISR001  ³ Autor ³ Gustavo Costa          ³ Data ³20.09.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio dos valores para conferencia da desoneração.     .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

Local oReport
Local oSection1
//Local oSection2
//Local oSection3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:= TReport():New("FATC33","Meta de bonificação dos Clientes","FATC33", {|oReport| ReportPrint(oReport)},"Este relatório irá imprimir a Meta de bonificação de Cliente")
//oReport:SetLandscape()
oReport:SetPortrait()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Data de                ³
//³ mv_par02   // Data Até               ³
//³ mv_par03   // Vendedor               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Pergunte(oReport:uParam,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 1                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1 := TRSection():New(oReport,"PERÍODO de " + DtoC(mv_par02) + " até " + DtoC(mv_par03),{"TAB"}) 

//TRCell():New(oSection1,'REP'		,'','Cod.'			,	/*Picture*/		,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'NREP'		,'','Representante'	,	/*Picture*/		,20				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CODCLI'		,'','Cliente'		,	/*Picture*/		,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'LOJA'		,'','Loja'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NCLI'		,'','Nome'			,	/*Picture*/		,50				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PEDLIB'   	,'','Ped Lib+Fat'	,"@E 9,999,999.99"	,14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'META'		,'','Meta R$'		,"@E 9,999,999.99"	,14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PERCMT'		,'','% Atingido'	,"@E 9,999,999.99"  ,14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'BOMMET'		,'','R$ Bonif.'		,"@E 9,999,999.99"	,14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'BONMES'		,'','Boinficado mês',"@E 9,999,999.99"	,14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PERBON'		,'','% Bonif.'		,"@E 9,999,999.99"	,14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'SALBON'		,'','Saldo'			,"@E 9,999,999.99"	,14	,/*lPixel*/,/*{|| code-block de impressao }*/)

//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("REP"),"Total",.F.)


//TRFunction():New(oSection1:Cell("METAKG"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("METAPV"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("METARS"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALKG"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALPV"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALRS"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)


Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PONR003 ³ Autor ³ Gustavo Costa           ³ Data ³20.06.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
Local cQuery 		:= ""
//Local cMatAnt		:= ""
//Local nNivel   	:= 0
//Local lContinua 	:= .T.
Local aFds 		:= {}
//Local aMeta		:= {}
//Local cLinha	:= ""

//******************************
// Monta a tabela temporária
//******************************

Aadd( aFds , {"CODCLI"		,"C",006,000} )
Aadd( aFds , {"LOJA"		,"C",002,000} )
Aadd( aFds , {"PEDLIB" 		,"N",016,002} )
Aadd( aFds , {"META"		,"N",016,002} )
Aadd( aFds , {"PERCMT" 		,"N",016,002} )
Aadd( aFds , {"BOMMET"		,"N",016,002} )
Aadd( aFds , {"BONMES" 		,"N",016,002} )
Aadd( aFds , {"PERBON" 		,"N",016,002} )
Aadd( aFds , {"SALBON"		,"N",016,002} )

coTbl := CriaTrab( aFds, .T. )
Use (coTbl) Alias TAB New Exclusive
dbCreateIndex(coTbl,'CODCLI+LOJA', {|| CODCLI+LOJA })

//***********************************
// Monta a tabela dos clientes com bonificação
//***********************************

cQuery := " SELECT ZC7.* FROM ZC7020 ZC7 "
cQuery += " INNER JOIN ZC8020 ZC8 " 
cQuery += " ON ZC7_CLIENT + ZC7_LOJA = ZC8_CLIENT + ZC8_LOJA " 
cQuery += " WHERE ZC7.D_E_L_E_T_ =   '' " 
cQuery += " AND ZC8.D_E_L_E_T_ =   '' " 
cQuery += " AND ZC7_MESANO = '" + mv_par01 + "' "
cQuery += " AND ZC8_DTINI <= '" + DtoS(mv_par02) + "' "
cQuery += " AND ZC8_DTFIM >= '" + DtoS(mv_par03) + "' "
cQuery += " ORDER BY ZC7_CLIENT "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

//******************************
//PREENCHE COM O REALIZADO
//******************************
While TMP->(!Eof())
	
	RecLock("TAB",.T.)
	
	Replace TAB->CODCLI 	with TMP->ZC7_CLIENT
	Replace TAB->LOJA 		with TMP->ZC7_LOJA
	Replace TAB->PEDLIB 	with fValPed(TMP->ZC7_CLIENT, TMP->ZC7_LOJA)
	Replace TAB->META 		with TMP->ZC7_META
	Replace TAB->PERCMT 	with (TAB->PEDLIB / TAB->META) * 100
	
	If TAB->PEDLIB * ( TMP->ZC7_PERC / 100) > TMP->ZC7_VALBON 
		Replace TAB->BOMMET		with (TAB->PEDLIB * ( TMP->ZC7_PERC / 100))
	Else
		Replace TAB->BOMMET		with 0
	EndIf
	
	Replace TAB->BONMES 	with fValBon(TMP->ZC7_CLIENT, TMP->ZC7_LOJA)
	Replace TAB->PERBON		with TMP->ZC7_PERC
	Replace TAB->SALBON		with TAB->BOMMET - TAB->BONMES
	
	MsUnlock()
	TMP->(dbSkip())

EndDo


TAB->( DbGoTop() )
oReport:SetMeter(TAB->(RecCount()))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1:Init()
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:Say(oReport:Row(),oReport:Col(),"PERÍODO de " + DtoC(mv_par02) + " até " + DtoC(mv_par03) )
oSection1:PrintLine()
oReport:SkipLine()
oReport:ThinLine()


While !oReport:Cancel() .And. TAB->(!Eof())

	oReport:IncMeter()

	oSection1:Cell("CODCLI"):SetValue(TAB->CODCLI)
	oSection1:Cell("CODCLI"):SetAlign("CENTER")
	oSection1:Cell("LOJA"):SetValue(TAB->LOJA)
	oSection1:Cell("LOJA"):SetAlign("CENTER")
	oSection1:Cell("NCLI"):SetValue(POSICIONE("SA1",1,XFILIAL("SA1")+TAB->CODCLI+TAB->LOJA,"A1_NOME"))
	oSection1:Cell("NCLI"):SetAlign("LEFT")
	oSection1:Cell("PEDLIB"):SetValue(TAB->PEDLIB)
	oSection1:Cell("PEDLIB"):SetAlign("RIGHT")
	oSection1:Cell("META"):SetValue(TAB->META)
	oSection1:Cell("META"):SetAlign("RIGHT")
	oSection1:Cell("PERCMT"):SetValue(TAB->PERCMT)
	oSection1:Cell("PERCMT"):SetAlign("RIGHT")
	oSection1:Cell("BOMMET"):SetValue(TAB->BOMMET)
	oSection1:Cell("BOMMET"):SetAlign("RIGHT")
	oSection1:Cell("BONMES"):SetValue(TAB->BONMES)
	oSection1:Cell("BONMES"):SetAlign("RIGHT")
	oSection1:Cell("PERBON"):SetValue(TAB->PERBON)
	oSection1:Cell("PERBON"):SetAlign("RIGHT")
	oSection1:Cell("SALBON"):SetValue(TAB->SALBON)
	oSection1:Cell("SALBON"):SetAlign("RIGHT")
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TAB->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TAB")
dbCloseArea("TMP")
Set Filter To

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fValPed   º Autor ³ Gustavo Costa     º Data ³  06/03/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna o valor dos pedidos no período do cliente.           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fValPed(cCliente, cLoja)

local cQry		:= ''
Local nRet		:= 0

cQry:=" SELECT SUM( C6_QTDVEN * C6_PRUNIT ) AS VALOR "
cQry+="         FROM SC6020 SC6 WITH (NOLOCK) " 
cQry+="         INNER JOIN SC5020 SC5 WITH (NOLOCK) " 
cQry+="         ON C6_FILIAL = C5_FILIAL " 
cQry+="         AND C6_NUM = C5_NUM  "
cQry+="         INNER JOIN SC9020 SC9 WITH (NOLOCK) " 
cQry+="         ON C6_FILIAL + C6_NUM + C6_ITEM = C9_FILIAL + C9_PEDIDO + C9_ITEM " 
cQry+="         WHERE  "
cQry+=" 		RTRIM(C6_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) AND "
cQry+="         SC5.C5_CLIENTE = '" + cCliente + "'   AND "
cQry+="         SC5.C5_LOJACLI = '" + cLoja + "' AND " 
cQry+="         SC5.C5_EMISSAO BETWEEN '" + DtoS(mv_par02) + "'  AND '" + DtoS(mv_par03) + "'  AND " 
cQry+="         SC5.D_E_L_E_T_ =   ''   AND " 
cQry+="         SC6.D_E_L_E_T_ =   ''   AND " 
cQry+="         SC9.D_E_L_E_T_ =   ''   AND " 
cQry+="         SC9.C9_SEQUEN = '01' AND "
cQry+="         SC9.C9_BLCRED IN( '','04','10') AND "
cQry+="         SC6.C6_BLQ <> 'R' "

TCQUERY cQry NEW ALIAS  "TMP3"

dbSelectArea("TMP3")
TMP3->(dbGoTop())

If Select("TMP3") > 0

	nRet := TMP3->VALOR
	
EndIf

TMP3->(dbclosearea())

Return nRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fValBon   º Autor ³ Gustavo Costa     º Data ³  06/03/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna o valor dos pedidos bonificados no período do clienteº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fValBon(cCliente, cLoja)

local cQry		:= ''
Local nRet		:= 0

cQry:=" SELECT SUM( C6_QTDVEN * C6_PRUNIT ) AS VALOR "
cQry+="        FROM SC6020 SC6 WITH (NOLOCK) " 
cQry+="        INNER JOIN SC5020 SC5 WITH (NOLOCK) " 
cQry+="        ON SC6.C6_FILIAL = SC5.C5_FILIAL " 
cQry+="        AND SC6.C6_NUM = SC5.C5_NUM " 
cQry+="        WHERE " 
cQry+="		RTRIM(SC6.C6_CF) IN ( '5910','6910' ) AND "
cQry+="		SC5.C5_FILIAL+SC5.C5_NUMPAI IN ( SELECT DISTINCT C5.C5_FILIAL+C5.C5_NUM FROM SC5020 C5 " 
cQry+="		INNER JOIN SC6020 C6 WITH (NOLOCK) " 
cQry+="        ON C6.C6_FILIAL = C5.C5_FILIAL " 
cQry+="        AND C6.C6_NUM = C5.C5_NUM "
cQry+="		AND RTRIM(C6.C6_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) AND "
cQry+="        C5.C5_CLIENTE = '" + cCliente + "'  AND "
cQry+="        C5.C5_LOJACLI = '" + cLoja + "' AND " 
cQry+="        C5.C5_EMISSAO BETWEEN '" + DtoS(mv_par02) + "'  AND '" + DtoS(mv_par03) + "' AND " 
cQry+="        C6.D_E_L_E_T_ =   ''   AND " 
cQry+="        C5.D_E_L_E_T_ =   '' ) AND "
cQry+="        SC5.D_E_L_E_T_ =   ''  AND " 
cQry+="        SC6.D_E_L_E_T_ =   '' AND " 
cQry+="        SC6.C6_BLQ <> 'R' "


TCQUERY cQry NEW ALIAS  "TMP4"

dbSelectArea("TMP4")
TMP4->(dbGoTop())

If Select("TMP4") > 0

	nRet := TMP4->VALOR
	
EndIf

TMP4->(dbclosearea())

Return nRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fFatBon   º Autor ³ Gustavo Costa     º Data ³  06/03/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna o valor dos pedidos bonificados no período do clienteº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fFatBon(cCliente, cLoja)

local cQry		:= ''
Local nRet		:= 0

cQry:=" SELECT SUM(D2_QUANT*D2_PRCVEN) AS VALOR "
cQry+="        FROM SD2020 SD2 WITH (NOLOCK) " 
cQry+="        INNER JOIN SC5020 SC5 WITH (NOLOCK) " 
cQry+="        ON SD2.D2_FILIAL = SC5.C5_FILIAL " 
cQry+="        AND SD2.D2_PEDIDO = SC5.C5_NUM " 
cQry+="        WHERE " 
cQry+="		RTRIM(SD2.D2_CF) IN ( '5910','6910' ) AND "
cQry+="		SC5.C5_FILIAL+SC5.C5_NUMPAI IN ( SELECT DISTINCT C5.C5_FILIAL+C5.C5_NUM FROM SC5020 C5 " 
cQry+="		INNER JOIN SC6020 C6 WITH (NOLOCK) " 
cQry+="        ON C6.C6_FILIAL = C5.C5_FILIAL " 
cQry+="        AND C6.C6_NUM = C5.C5_NUM "
cQry+="		AND RTRIM(C6.C6_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) AND "
cQry+="        C5.C5_CLIENTE = '" + cCliente + "'  AND "
cQry+="        C5.C5_LOJACLI = '" + cLoja + "' AND " 
cQry+="        C5.C5_EMISSAO BETWEEN '" + DtoS(mv_par02) + "'  AND '" + DtoS(mv_par03) + "' AND " 
cQry+="        C6.D_E_L_E_T_ =   ''   AND " 
cQry+="        C5.D_E_L_E_T_ =   '' ) AND "
cQry+="        SC5.D_E_L_E_T_ =   ''  AND " 
cQry+="        SD2.D_E_L_E_T_ =   '' " 



TCQUERY cQry NEW ALIAS  "TMP5"

dbSelectArea("TMP5")
TMP5->(dbGoTop())

If Select("TMP5") > 0

	nRet := TMP5->VALOR
	
EndIf

TMP5->(dbclosearea())

Return nRet




Static Function expExcel()

Local oFWMsExcel
Local oExcel
Local cArquivo	:= GetTempPath()+'FATC033.xml'
Local aDados	:= {}
Local nTotalCol	:= 0
Local nTotalG	:= 0
Local aFds 		:= {}
Local cVend		:= ""
//Local cLinha	:= ""

//******************************
// Monta a tabela temporária
//******************************

Aadd( aFds , {"CODCLI"		,"C",006,000} )
Aadd( aFds , {"LOJA"		,"C",002,000} )
Aadd( aFds , {"PEDLIB" 		,"N",016,002} )
Aadd( aFds , {"META"		,"N",016,002} )
Aadd( aFds , {"PERCMT" 		,"N",016,002} )
Aadd( aFds , {"BOMMET"		,"N",016,002} )
Aadd( aFds , {"BONMES" 		,"N",016,002} )
Aadd( aFds , {"FATBON" 		,"N",016,002} )
Aadd( aFds , {"PERBON" 		,"N",016,002} )
Aadd( aFds , {"SALBON"		,"N",016,002} )

coTbl := CriaTrab( aFds, .T. )
Use (coTbl) Alias TAB New Exclusive
dbCreateIndex(coTbl,'CODCLI+LOJA', {|| CODCLI+LOJA })

//***********************************
// Monta a tabela dos clientes com bonificação
//***********************************

cQuery := " SELECT ZC7.* FROM ZC7020 ZC7 "
cQuery += " INNER JOIN ZC8020 ZC8 " 
cQuery += " ON ZC7_CLIENT + ZC7_LOJA = ZC8_CLIENT + ZC8_LOJA " 
cQuery += " WHERE ZC7.D_E_L_E_T_ =   '' " 
cQuery += " AND ZC8.D_E_L_E_T_ =   '' " 
cQuery += " AND ZC7_MESANO = '" + mv_par01 + "' "
cQuery += " AND ZC8_DTINI <= '" + DtoS(mv_par02) + "' "
cQuery += " AND ZC8_DTFIM >= '" + DtoS(mv_par03) + "' "
cQuery += " ORDER BY ZC7_CLIENT "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

//******************************
//PREENCHE COM O REALIZADO
//******************************
While TMP->(!Eof())
	
	RecLock("TAB",.T.)
	
	Replace TAB->CODCLI 	with TMP->ZC7_CLIENT
	Replace TAB->LOJA 		with TMP->ZC7_LOJA
	Replace TAB->PEDLIB 	with fValPed(TMP->ZC7_CLIENT, TMP->ZC7_LOJA)
	Replace TAB->META 		with TMP->ZC7_META
	Replace TAB->PERCMT 	with (TAB->PEDLIB / TAB->META) * 100
	
	If TAB->PEDLIB * ( TMP->ZC7_PERC / 100) > TMP->ZC7_VALBON 
		Replace TAB->BOMMET		with (TAB->PEDLIB * ( TMP->ZC7_PERC / 100))
	Else
		Replace TAB->BOMMET		with 0
	EndIf
	
	Replace TAB->BONMES 	with fValBon(TMP->ZC7_CLIENT, TMP->ZC7_LOJA)
	Replace TAB->FATBON 	with fFatBon(TMP->ZC7_CLIENT, TMP->ZC7_LOJA)
	Replace TAB->PERBON		with TMP->ZC7_PERC
	Replace TAB->SALBON		with TAB->BOMMET - TAB->BONMES
	
	MsUnlock()
	TMP->(dbSkip())

EndDo


TAB->( DbGoTop() )

	//Criando o objeto que irá gerar o conteúdo do Excel
	oFWMsExcel := FWMSExcel():New()
	
		//***************************
		//PRIMEIRA ABA
		//***************************
	//Aba 01 - Teste
	oFWMsExcel:AddworkSheet("BONIFICACAO") //Não utilizar número junto com sinal de menos. Ex.: 1-
		//Criando a Tabela
		oFWMsExcel:AddTable("BONIFICACAO","Conf. Bonificacao")
		//Criando Colunas
		//FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)-> NIL
		oFWMsExcel:AddColumn("BONIFICACAO","Conf. Bonificacao","Vendedor",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("BONIFICACAO","Conf. Bonificacao","Cliente",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("BONIFICACAO","Conf. Bonificacao","Loja",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("BONIFICACAO","Conf. Bonificacao","Nome",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("BONIFICACAO","Conf. Bonificacao","Ped Lib+Fat",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("BONIFICACAO","Conf. Bonificacao","Meta R$",2,2) //1 = Modo Texto
		oFWMsExcel:AddColumn("BONIFICACAO","Conf. Bonificacao","% Atingido",2,2,.T.)
		oFWMsExcel:AddColumn("BONIFICACAO","Conf. Bonificacao","R$ Bonif.",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("BONIFICACAO","Conf. Bonificacao","Boinficado mês",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("BONIFICACAO","Conf. Bonificacao","Boinf. Fat.",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("BONIFICACAO","Conf. Bonificacao","% Bonif.",2,2) //2 = Valor sem R$
		oFWMsExcel:AddColumn("BONIFICACAO","Conf. Bonificacao","Saldo",3,2) //2 = Valor sem R$

		//Criando as Linhas
		dbSelectArea("TAB")
		While !(TAB->(EoF()))
		
			cVend	:= POSICIONE("SA1",1,xFilial("SA1") + TAB->CODCLI + TAB->LOJA, "A1_VEND")
			
			AADD(adados,POSICIONE("SA3",1,xFilial("SA3") + cVend, "A3_NREDUZ"))
			AADD(adados,TAB->CODCLI)
			AADD(adados,TAB->LOJA)
			AADD(adados,POSICIONE("SA1",1,XFILIAL("SA1")+TAB->CODCLI+TAB->LOJA,"A1_NOME"))
			AADD(adados,TAB->PEDLIB)
			AADD(adados,TAB->META)
			AADD(adados,TAB->PERCMT)
			AADD(adados,TAB->BOMMET)
			AADD(adados,TAB->BONMES)
			AADD(adados,TAB->FATBON)
			AADD(adados,TAB->PERBON)
			AADD(adados,TAB->SALBON)
			
			oFWMsExcel:AddRow("BONIFICACAO","Conf. Bonificacao",aDados)
			
			aDados	:= {}
			//Pulando Registro
			TAB->(DbSkip())
		EndDo
		
		
	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)
		
	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New() 			//Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo) 	//Abre uma planilha
	oExcel:SetVisible(.T.) 				//Visualiza a planilha
	oExcel:Destroy()						//Encerra o processo do gerenciador de tarefas
	
	//QRYPRO->(DbCloseArea())
	//RestArea(aArea)


TAB->(dbCloseArea())
TMP->(dbCloseArea())
	
Return



