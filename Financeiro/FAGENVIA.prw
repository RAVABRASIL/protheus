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

User Function FAGEVIA()

Local aCores := {{"EMPTY(ZZE_FECHAM)", "BR_VERDE"   },;		   			 
                 {"!EMPTY(ZZE_FECHAM)", "BR_VERMELHO" }}


Private aRotina := {{"Pesquisar" , "AxPesqui"   , 0, 1},;
                    {"Visualizar", "U_CdModAG", 0, 2},;
                    {"Incluir"   , "U_CdModAG", 0, 3},; 
                    {"Alterar"   , "U_CdModAG", 0, 4},;
                    {"Excluir"   , "U_CdModAG", 0, 5},;
                    {"Finalizar Agenda", "U_CdModAG", 0, 6},;                    
                    {"Legenda"   , "U_LegAG()", 0, 6},;               
                    {"Analise Cliente" , "U_FAnaCliX('','2')", 0, 6},;               
                    {"Relatorio" , "U_RAGEVIA()", 0, 6}}
                    


Private cCadastro  := OemToAnsi( "Agenda de Viagem" )
Private cAlias1	   := "ZZF"	    // Alias de detalhe
Private lSemItens  := .F.		// Permite a nao existencia de itens
Private cChave	   := "ZZE_CODIGO"  // Chave que ligara a primeira tabela com a segunda
Private cChave1	   := "ZZF_CODIGO"  // Chave que ligara a segunda tabela com a primeira
Private aChaves    := {{"ZZF_CODIGO", "M->ZZE_CODIGO"} }

DbSelectArea("ZZE")
DbSetOrder(1)


mBrowse( 06, 01, 22, 75, "ZZE",,,,,,aCores )

Return

*************

User Function CdModAG(cAlias,nReg,nOpc)

*************

Local nOpca := 0, nCnt := 0, nSavReg
Local oDlg, lModelo2 := .F., nCpoTela
Local nOrdSx3 := Sx3->(IndexOrd())
Local cCpoMod2  := "ZZF_REALIZ/ZZF_OBJECA/ZZF_MOTOBJ/ZZF_NAINCL/ZZF_OBS"
Local nHeader   := 0
local _nPos
Private Inclui	:= .F.
Private Altera	:= .F.
Private Exclui	:= .F.
Private Visual	:= .F.
Private _Fecham	:= .F.
Private cPref, cPref1
Private oGetD, cContador
Private cFColsG := "ZZF_TIPO/ZZF_DTVISI/ZZF_CODCP/ZZF_LOJA/ZZF_REALIZ/ZZF_OBJECAX/ZZF_MOTOBJX/ZZF_OBS/"

   
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
	Case nOpc = 6
		_Fecham	:= .T.
EndCase
 
If Altera .OR. Exclui .OR. _Fecham
   IF ! _Fecham
	   DbSelectArea("Z62")
	   DbSetOrder(5)
	   If Z62->(DbSeek(xFilial('Z62')+ZZE->ZZE_CODIGO ) )
	      IF Z62->Z62_BLOQ<>'3'
		      alert('A Agenda  nao pode ser alterada, pois a solicitacao de Viagem Ja foi Desbloqueada.')
		      Return
		  ENDIF
	   Endif
   ENDIF
   
  IF !EMPTY(ZZE->ZZE_FECHAM)
	  alert('A Agenda  nao pode ser alterada, pois Ja houve Fechamento')
	  Return  
  ENDIF

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
/*
if nOpc=2 // VISUALIZA 
   cCpoMod2:="ZZF_NAINCL/"
endif
*/

if nOpc=6 .OR. nOpc=2 // FECHAMENTO OU VISUALIZA 
   cCpoMod2:=" "
endif

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek( cAlias1 )
While !Eof() .And. x3_arquivo == cAlias1
	IF X3USO(x3_usado) .And. cNivel >= x3_nivel .And. ! ALLTRIM(X3_CAMPO) $ cCpoMod2
		nUsado++
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_F3,;
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
				IF  ALLTRIM(aHeader[nHeader][2]) $ "ZZF_REALIZ/ZZF_OBJECA"  .AND. Nopc=6
				    IF EMPTY(&(cAlias1 + "->" + aHeader[nHeader][2]))
				       aCOLS[nCnt][nUsado] := "N"
				    ELSE
				       aCOLS[nCnt][nUsado] := &(cAlias1 + "->" + aHeader[nHeader][2])
				    ENDIF
				ELSE
                    aCOLS[nCnt][nUsado] := &(cAlias1 + "->" + aHeader[nHeader][2])				
				ENDIF    
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
				IF ALLTRIM(aHeader[nHeader][2]) $ "ZZF_REALIZ/ZZF_OBJECA" .AND. Nopc=6
				    IF EMPTY(&(cAlias1 + "->" + aHeader[nHeader][2]))
				       aCOLS[nCnt][nUsado] := 'N'
				    ELSE
				       aCOLS[nCnt][nUsado] := &(cAlias1 + "->" + aHeader[nHeader][2])
				    ENDIF
				ELSE
                    aCOLS[nCnt][nUsado] := &(cAlias1 + "->" + aHeader[nHeader][2])				
				ENDIF    
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
	
	//oGetd :=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]-30,aPosObj[2,4],nOpc,cLinhaOk,cTudoOk,cContador, .T.,,,,,,,,cDelOK,,,)	         
	if _fecham
	   _aFeCols := aClone(aCols)
	endif   
//	oGetd :=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]-30,aPosObj[2,4],if(Visual.or.Exclui, Nil,if(Altera, GD_INSERT+GD_DELETE+GD_UPDATE,if(nOPc=6,GD_INSERT+GD_UPDATE,GD_INSERT+GD_DELETE+GD_UPDATE))) ,'U_FLINAG()','AllwaysTrue()','', Campos(cFColsG,"/",.T.),0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg,aHeader,aCols,IIF(nOpc=6,'U_FVDAG()',nil) )
	oGetd :=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]-30,aPosObj[2,4],if(Visual.or.Exclui, Nil,if(Altera, GD_INSERT+GD_DELETE+GD_UPDATE,if(nOPc=6,GD_INSERT+GD_UPDATE,GD_INSERT+GD_DELETE+GD_UPDATE))) ,'U_FLINAG()','AllwaysTrue()','', Campos(cFColsG,"/",.T.),0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg,aHeader,aCols,"U_FCHAG()" )
	oFont1     := TFont():New( "MS Sans Serif",0,-19,,.F.,0,,400,.F.,.F.,,,,,, )
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
	   
	    if nOPc= 3  // na inclusao fazer a analise de clientes 
           if MsgBox( OemToAnsi( "Deseja Gerar a Analise do Cliente?" ), "Escolha", "YESNO" )       
              MsAguarde( { || U_FAnaCliX(M->ZZE_CODIGO,'1')	 }, "Aguarde. . .", "Gerando Analise de Clientes. . ." )    //U_FAnaCliX(M->ZZE_CODIGO,'1')	
           endif
	    endif
	   
	Endif
	
	END TRANSACTION
Endif

dbSelectArea(cAlias)

Return nOpca

***************

Static Function GravMod(cAlias,cAlias1)

***************

Local nCampos, nHeader, nMaxArray, bCampo, aAnterior:={}, nItem := 1
Local lModelo2 := cAlias = cAlias1
Local nChaves := 0
Local nSaveSX8Z5:= GetSX8Len()

bCampo := {|nCPO| Field(nCPO) }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verifica se o ultimo elemento do array esta em branco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMaxArray := Len(oGetd:aCols)

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
			IF _Fecham // FECHAMENTO 
			   IF "ZZE_FECHAM"$Field(nCampos)
			       FieldPut(nCampos,"X")
			   ELSE
			       FieldPut(nCampos,M->&(EVAL(bCampo,nCampos)))
			   ENDIF
			ELSE
			  FieldPut(nCampos,M->&(EVAL(bCampo,nCampos)))
			ENDIF
		EndIf
	Next
    ConfirmSX8()
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
	If oGetd:aCols[nCampos][Len(oGetd:aCols[nCampos])]
		RecLock(cAlias1,.F.,.T.)
		dbDelete()
	Else
		For nHeader := 1 to Len(oGetd:aHeader)
			If oGetd:aHeader[nHeader][10] # "V" .And. ! "_ITEM" $ AllTrim(oGetd:aHeader[nHeader][2])
				Replace &(Trim(oGetd:aHeader[nHeader][2])) With oGetd:aCols[nCampos][nHeader]
			ElseIf "_ITEM" $ AllTrim(oGetd:aHeader[nHeader][2])
				Replace &(AllTrim(oGetd:aHeader[nHeader][2])) With StrZero(nItem ++,;
				Len(&(AllTrim(oGetd:aHeader[nHeader][2]))))
			Endif
		Next
		
        IF INCLUI  .OR. ALTERA // QUANDO FOR INCLUSO NO FECHAMENTO FICA VAZIO 
            Replace ZZF_NAINCL With 'X'
        ENDIF
		
		
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

***************

Static Function ApagMod(cAlias,cAlias1)

***************

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


***************

Static Function CdaPrivate

***************

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

*************

User Function ftipozzf(cOPc,cXcp)

*************
local nTIPO   := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_TIPO"})
local nCODCP  := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_CODCP"})
local nNOMECP := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_NOMECP"})
local nLOJA   := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_LOJA"})

IF cOpc='C'
   oGetd:aHeader[nCODCP][9]:='SA1'

ELSEIF cOpc='P'
   oGetd:aHeader[nCODCP][9]:='SUS'

ELSEIF cOpc='H'
   oGetd:aHeader[nCODCP][9]:='Z99'

ENDIF

if !empty(cXcp)
    IF cOpc<>oGetd:aCols[n][nTIPO]
       oGetd:aCols[n][nCODCP]:=space(9)
       oGetd:aCols[n][nNOMECP]:=space(40)
       oGetd:aCols[n][nLOJA]:=space(2)       
    ENDIF   
endif

Return .T. 


***************

Static Function Campos( cString,;	// String a ser processada
					    cDelim,;	// Delimitador
					    lAllTrim;	// Tira espacos em brancos
				                  )
***************

Local aRetorno := {}	// Array de retorno
Local nPos				// Posicao do caracter

cDelim		:= If( cDelim = Nil, ' ', cDelim )
lAllTrim 	:= If( lAllTrim = Nil, .t., lAllTrim )
             
If lAllTrim
	cString := AllTrim( cString )
Endif

Do While .t.
	If ( nPos := At( cDelim, cString ) ) != 0
 		Aadd( aRetorno, Iif( lAllTrim, AllTrim( Substr( cString, 1, nPos - 1 ) ), Substr( cString, 1, nPos - 1 ) ) )
		cString := Substr( cString, nPos + Len( cDelim ) )
	Else
		If !Empty( cString )
			Aadd( aRetorno,  Iif( lAllTrim, AllTrim( cString ), cString ) )
		Endif
		Exit
	Endif	
Enddo

Return aRetorno


*************

User Function fcodcp()

*************

Local aArea	    := GetArea()
local nTipo := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_TIPO"})
local nNome := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_NOMECP"})
local nLoja := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_LOJA"})

local lRet:=.T.
local cCodPro:=''

IIF(EMPTY(oGetd:aCols[n][nlOJA]),oGetd:aCols[n][nlOJA]:='01',oGetd:aCols[n][nlOJA])

IF oGetd:aCols[n][nTipo]='P'
   cQuery :="SELECT  US_NOME NOME FROM "+RetSqlName("SUS")+" SUS WHERE US_COD='"+M->ZZF_CODCP+"' AND US_LOJA='"+oGetd:aCols[n][nlOJA]+"' AND SUS.D_E_L_E_T_='' "
   cCodPro:='Prospect'
ELSEIF oGetd:aCols[n][nTipo]='C'
   cQuery :="SELECT A1_NOME NOME FROM "+RetSqlName("SA1")+" SA1 WHERE A1_COD='"+M->ZZF_CODCP+"' AND A1_LOJA='"+oGetd:aCols[n][nlOJA]+"' AND SA1.D_E_L_E_T_='' "
   cCodPro:='Cliente'
ELSEIF oGetd:aCols[n][nTipo]='H'
   cQuery :="SELECT Z99_NOME NOME FROM "+RetSqlName("Z99")+" Z99 WHERE Z99_CNES='"+M->ZZF_CODCP+"' AND Z99.D_E_L_E_T_='' "
   cCodPro:='Hospital'
ENDIF

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf
TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

IF AUXZ->(EOF())    
   
   alert('Esse codigo de '+cCodPro+' Nao e Valido: '+ M->ZZF_CODCP  )
   oGetd:aCols[n][nNome]:=SPACE(40)
   lRet:=.F.

Else

   oGetd:aCols[n][nNome]:=AUXZ->NOME

EndIF

AUXZ->(DbCloseArea())

RestArea(aArea)

Return lRet

*************

User Function fzzfRealiz()

*************
//cFColsG := "ZZF_TIPO/ZZF_DTVISI/ZZF_CODCP/ZZF_LOJA/ZZF_REALIZ/ZZF_OBJECAX/ZZF_MOTOBJX/"

local nOBJECA := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_OBJECA" })
local nMOTOBJ := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_MOTOBJ" })

IF M->ZZF_REALIZ<>'N' // SIM 
   
   oGetd:aALTER[6]:="ZZF_OBJECA" 
   IF oGetd:aCols[n][nOBJECA]<>'N' // SIM 
      oGetd:aCols[n][nMOTOBJ]:=SPACE(6)
      oGetd:aALTER[7]:="ZZF_MOTOBJX" 
   ELSE      
      oGetd:aALTER[7]:="ZZF_MOTOBJ"   
   ENDIF


ELSE // NAO 

   oGetd:aCols[n][nOBJECA]:="N"
   oGetd:aCols[n][nMOTOBJ]:=SPACE(6)

   oGetd:aALTER[6]:="ZZF_OBJECAX"
   oGetd:aALTER[7]:="ZZF_MOTOBJX"     
   

ENDIF

Return .T. 


*************

User Function fzzfOBEJA()

*************
//cFColsG := "ZZF_TIPO/ZZF_DTVISI/ZZF_CODCP/ZZF_LOJA/ZZF_REALIZ/ZZF_OBJECAX/ZZF_MOTOBJX/"

local nMOTOBJ := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_MOTOBJ" })


IF M->ZZF_OBJECA<>'S' // NAO 
   oGetd:aALTER[7]:="ZZF_MOTOBJ" 

ELSE // SIM  

   
   oGetd:aCols[n][nMOTOBJ]:=SPACE(6)

   oGetd:aALTER[7]:="ZZF_MOTOBJX"     
   

ENDIF

Return .T.

*************

USER FUNCTION FLINAG()

*************
local nCODCP := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_CODCP"})
local nDTVISI := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_DTVISI"})
local nREALIZ := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_REALIZ"})
local nOBJECA := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_OBJECA"})
local nMOTOBJ := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_MOTOBJ"})

local nPosDel:= len(oGetd:aHeader)+1

//oGetd:aHeader[nCODCP][9]:='SA1'



If _fecham
	
	IF oGetd:aCols[n][nREALIZ]<>'N'  .AND. oGetd:aCols[n][nOBJECA]<>'S' .AND. EMPTY(oGetd:aCols[n][nMOTOBJ])
	   alert('Motivo da Objecao Nao Foi Informado')
	   Return .F. 
	ENDIF
	
endif


Return .T. 


*************

USER FUNCTION FVDAG()

*************

local nOBJECA := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_OBJECA" })
local nMOTOBJ := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_MOTOBJ" })
local nREALIZ := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_REALIZ" })
local nMOTOBJ := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_MOTOBJ" })
local nNaIncl := aScan(oGetd:aHeader,{|x| AllTrim(x[2]) == "ZZF_NAINCL" })


IF ALLTRIM(oGetd:aCols[n][nNaIncl])='X'   //LEN(oGetd:aCols)=LEN(_aFeCols) // EDITANDO
   oGetd:aALTER[1]:="ZZF_TIPOX" 
   oGetd:aALTER[2]:="ZZF_DTVISIX" 
   oGetd:aALTER[3]:="ZZF_CODCPX" 
ELSE // INSERINDO
   oGetd:aALTER[1]:="ZZF_TIPO" 
   oGetd:aALTER[2]:="ZZF_DTVISI" 
   oGetd:aALTER[3]:="ZZF_CODCP" 
ENDIF




IF oGetd:aCols[n][nREALIZ]<>'N' // SIM
	oGetd:aALTER[6]:="ZZF_OBJECA"
	IF oGetd:aCols[n][nOBJECA]<>'N' // SIM
		oGetd:aCols[n][nMOTOBJ]:=SPACE(6)
		oGetd:aALTER[7]:="ZZF_MOTOBJX"
	ELSE
		oGetd:aALTER[7]:="ZZF_MOTOBJ"
	ENDIF
	
ELSE // NAO
	
	oGetd:aCols[n][nOBJECA]:="N"
	oGetd:aCols[n][nMOTOBJ]:=SPACE(6)
	
	oGetd:aALTER[6]:="ZZF_OBJECAX"
	oGetd:aALTER[7]:="ZZF_MOTOBJX"
	
	
ENDIF





Return .T.


*************

User Function LegAG()

*************

Local aLegenda := {{"BR_VERDE"     ,"Sem Fechamento" },;
   	   			   {"BR_VERMELHO" ,"Com Fechamento" }}                          


BrwLegenda("Agenda de Viagem","Legenda",aLegenda)		   		

Return .T.

*************

USER FUNCTION FDTVIZZF()

*************

Local aArea	    := GetArea()
Local lRet:=.T.

_VLDTVI:=SUPERGETMV("RV_VLDTVI",,.T.)  // VALENDO

IF !_VLDTVI
    RestArea(aArea)
    RETURN .T.
ENDIF



IF ! INCLUI // _Fecham
    RestArea(aArea)
    RETURN .T.
ENDIF


if EMPTY(M->ZZE_GESTOR)
   ALERT('Favor Informar o Gestor')
    RestArea(aArea)
   RETURN .F.
ENDIF



	cQuery :="SELECT DISTINCT ZZE_CODIGO FROM ZZE020 ZZE, ZZF020 ZZF "
	cQuery +="WHERE "
	cQuery +="ZZE_CODIGO=ZZF_CODIGO "
	cQuery +="AND ZZF_DTVISI<'"+DTOS(DATE())+"' "
	cQuery +="AND ZZE_GESTOR='"+M->ZZE_GESTOR+"' "
	cQuery +="AND ZZE_FECHAM<>'X' "
	cQuery +="AND ZZE.D_E_L_E_T_ = ' ' "
	cQuery +="AND ZZF.D_E_L_E_T_ = ' ' "
	
	If Select("AUXD") > 0
		DbSelectArea("AUXD")
		AUXD->(DbCloseArea())
	EndIf
	TCQUERY cQuery NEW ALIAS "AUXD"
	
	AUXD->(DbGoTop())
	
	IF AUXD->(!EOF())
		
		alert('Existe(m) Agenda(s) que precisa(m) de Fechamento(s) ' )
		lRet:= .F.
		
	EndIF

	AUXD->(DbCloseArea())
    RestArea(aArea)


RETURN lRet


*************

User Function FCHAG()

*************


IF _fecham
   U_FVDAG()
ENDIF

U_ftipozzf(oGetd:aCols[n][1],' ') 


Return .T.