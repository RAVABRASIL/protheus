#Include "RwMake.ch"
#INCLUDE "TOPCONN.CH"

*************
User Function APARA9091(xxOP)
*************

Local nSay1 := 0
Local nComboBox1 := 0

SetPrvt( "nTOLERA, aIMP, nPESO, cOP, oMAQ, nQUANT, cPORTA, nHandle, cNOMEO, oNOMEO, oTIPO, cTIPO, aTIPO, oOPERAD, cOPERAD, aOPERAD, aCODOPE, " )

DbSelectArea("SC2")
DbSelectArea("SB1")
DbSelectArea("SB5")
DbSelectArea("SH1")
//DbSelectArea("SRA")

SC2->( DbSetOrder( 1 ) )
SB1->( DbSetOrder( 1 ) )
SB5->( DbSetOrder( 1 ) )
SH1->( DbSetOrder( 1 ) )
//SRA->( DbSetOrder( 1 ) )

nHANDLE   := -1
cPORTABAL := "4"
cPORTAIMP := "3"
aIMP      := {}
cTIPO     := " "
cOPERAD   := Space( 6 )
cNOMEO    := Space( 30 )
nPESO     := 0
cOP       := Space( 11 )
cMAQ      := Space( 06 )
nQUANT    := 1
lEXTRUSAO := .F.

@ 000,000 TO 145,430 Dialog oDLG1 Title "Pesagem de aparas"
@ 011,005 Say "OP:"
@ 010,020 Get cOP Object oOP Size 50,40 F3 "SC2" Valid PesqOp()
@ 011,080 Say "Tipo:"
@ 011,095 Say cTIPO Size 80,40 OBJECT oTIPO
@ 011,155 Say "Maquina:"
@ 010,180 Get cMAQ Object oMAQ Size 30,40 F3 "SH1" Valid PesqMaq()

oEXTRUSAO           := TCHECKBOX():Create( oDlg1 )
oEXTRUSAO:cName     := "oEXTRUSAO"
oEXTRUSAO:cCaption  := "&Extrusao?"
oEXTRUSAO:nLeft     := 015
oEXTRUSAO:nTop      := 060
oEXTRUSAO:nWidth    := 79
oEXTRUSAO:nHeight   := 17
oEXTRUSAO:lShowHint := .F.
oEXTRUSAO:lReadOnly := .F.
oEXTRUSAO:Align     := 0
oEXTRUSAO:cVariable := "lEXTRUSAO"
oEXTRUSAO:bSetGet   := {|u| If(PCount()>0,lEXTRUSAO:=u,lEXTRUSAO) }
oEXTRUSAO:lVisibleControl := .T.
oEXTRUSAO:bChange    := {|| ValidExtru() }
/*if !empty(xxOP)
	cOP	:= xxOP
	lEXTRUSAO := .T.
	oEXTRUSAO:Disable()
endIf*/
@ 031,050 Say "Operador:"
@ 030,080 Get cOPERAD Object oOPERAD Size 30,40 F3 "SRA" //VALID PesqOperad()
oOPERAD:lReadOnly := .T.

//@ 029,108 Button "..."     Size 010,012 ACTION { cOPERAD := U_BuscaFun(1), PesqOperad() }
@ 031,120 Say cNOMEO Size 100,40 OBJECT oNOMEO
@ 055,025 Button "_Ler balanca" Size 50,15 Action Pegar()
@ 055,095 Button "_Reimp.etiq." Size 50,15 Action Reimprime()
@ 055,165 BMPButton Type 2 Action Close( oDLG1 )

Activate Dialog oDLG1 Centered

Return



***************
Static Function Pegar()
***************

cDLL    := "toledo9091.dll"
nHandle := ExecInDllOpen( cDLL )
if nHandle = -1
	MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	Return NIL
EndIf
// Parametro 1 = Porta serial do indicador
cRETDLL := ExecInDLLRun( nHandle, 1, cPORTABAL )
cPESO   := Left( cRETDLL, rat( ",", cRETDLL ) - 1 )
nPESO   := Val( Strtran( cPESO, ",", "." ) )
ExecInDLLClose( nHandle )
Grava()
Return NIL



***************
Static Function Grava()
***************

aIMP := {}
If nPESO <= 0
	 MsgAlert( "Erro na leitura do peso" )
	 Return NIL
EndIf
If ! ( ( ! Empty( cOP ) .and. ! Empty( cMAQ ) ) .or. ! Empty( cOPERAD ) )
	 MsgAlert( "Dados obrigatorios nao informados" )
	 Return NIL
EndIf
For nCONT := 1 To nQUANT
	cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
	RecLock( "Z00", .T. )
	Z00->Z00_SEQ    := cSEQ
	Z00->Z00_OP     := cOP
	Z00->Z00_PESO   := nPESO
	Z00->Z00_BAIXA  := "N"
	Z00->Z00_MAQ    := cMAQ
	Z00->Z00_DATA   := Date()
	Z00->Z00_HORA   := Left( Time(), 5 )
	//Z00->Z00_APARA  := If( cTIPO == "APARA MISTA", "1", If( cTIPO == "APARA BRANCA", "2", "3" ) )
	//Comentado Eurivan 28/01/10 - Chamado 001479 MArcelo
	//Z00->Z00_APARA  := If( cTIPO == "APARA MISTA", "1", If( cTIPO == "APARA BRANCA", "2", If( cTIPO == "APARA AZUL", "4", "3" ) ) )

    //Incluido para atender o chamdo 001479 - MArcelo
	if  cTIPO == "APARA AZUL"
	   Z00->Z00_APARA := "A"
	elseif cTIPO == "APARA BRANCA"
	   Z00->Z00_APARA := "B"	  
	elseif cTIPO == "APARA BRANCA HOSP"
	   Z00->Z00_APARA := "Y"
	elseif cTIPO == "APARA DE AL€A"
	   Z00->Z00_APARA := "W"
	elseif cTIPO == "APARA PRETA"
	   Z00->Z00_APARA := "C"	  
	elseif cTIPO == "APARA VERMELHA"
	   Z00->Z00_APARA := "D"	  
	elseif cTIPO == "APARA AMARELA"
	   Z00->Z00_APARA := "E"	  
	elseif cTIPO == "APARA VERDE"
	   Z00->Z00_APARA := "F"	  
	elseif cTIPO == "APARA CINZA"
	   Z00->Z00_APARA := "G"	  
	endif   

	Z00->Z00_OPERAD := cOPERAD
	Z00->( MsUnlock() )
	ConfirmSX8()
	Z00->( DbCommit() )

	Aadd( aIMP, { "B" + "Rava Embalagens", "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ } )
	If Abre_Impress()
		Inc_Linha( aIMP[ nCONT, 1 ], .T. )
		Inc_Linha( aIMP[ nCONT, 2 ], .F. )
		Inc_Linha( aIMP[ nCONT, 3 ], .F. )
		Fecha_Impress()
	EndIf
Next
If SC2->C2_RECURSO <> cMAQ
	 RecLock( "SC2", .F. )
   SC2->C2_RECURSO := cMAQ
	 SC2->( MsUnlock() )
	 SC2->( DbCommit() )
EndIf
nPESO     := 0
cOP       := Space( 11 )
cMAQ      := Space( 06 )
cOPERAD   := Space( 06 )
cNOMEO     := Space( 30 )
cTIPO     := " "
lEXTRUSAO := .F.
oOPERAD:lReadOnly := .T.
ObjectMethod( oNOMEO, "SetText( OemToAnsi( cNOMEO ) )" )
ObjectMethod( oOP, "SetFocus()" )
Return NIL


***************
Static Function PesqOp()
***************

lRET := .T.

If "REIMP" $ Upper( oDLG1:oCtlFocus:ccaption )
	 Return lRET
EndIf
If Len( AllTrim( cOP ) ) == 6
	 cOP := Left( cOP, 6 ) + "01001"
EndIf
SC2->( DbSeek( xFilial( "SC2" ) + cOP, .T. ) )
If SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN == cOP
	 If ! SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
			MsgAlert( OemToAnsi( "Produto desta OP nao cadastrado" ) )
			lRET := .F.
	 EndIf
Else
	 MsgAlert( OemToAnsi( "OP nao cadastrada" ) )
	 lRET := .F.
EndIf
If lRET
/*
	 If Left( SC2->C2_PRODUTO, 3 ) == "GUB"
	 	  If MsgBox( OemToAnsi( "Esta apara ‚ de al‡a?" ), "Escolha", "YESNO" )
	 			 cTIPO := "APARA DE AL€A"
			Else
	 			 cTIPO := "APARA BRANCA"
			EndIf
	 Else
 	 		If SubStr( SC2->C2_PRODUTO, 1, 1 ) == "C"//Chamado 000393, feito em 18/02/09 a pedidos de Alexandre e Lindenberg
	 			 cTIPO := "APARA MISTA"
	 		ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "B"
	 			 cTIPO := "APARA BRANCA"
			ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "A"
	 			 cTIPO := "APARA AZUL"	 			 
	 		Else
	 			 cTIPO := "APARA MISTA"
	 		EndIf
	 Endif
*/
	 //Inclui Eurivan 28/01/10 - Chamado 001479 - Marcelo
	 If Left( SC2->C2_PRODUTO, 3 ) == "GUB"
	 	If MsgBox( OemToAnsi( "Esta apara ‚ de al‡a?" ), "Escolha", "YESNO" )
	 	   cTIPO := "APARA DE AL€A"
		Else
		   cTIPO := "APARA BRANCA"
		EndIf
	 Else
	 	if SubStr( SC2->C2_PRODUTO, 3, 1 ) == "A"//Chamado 000393, feito em 18/02/09 a pedidos de Alexandre e Lindenberg
	 		cTIPO := "APARA AZUL"
	 	ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "B"
	 		if Left( SC2->C2_PRODUTO, 1 ) == "C"
  	 		   cTIPO := "APARA BRANCA HOSP"	 		
	 		else   
	 		   cTIPO := "APARA BRANCA"
	 		endif
		ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "C"
 			cTIPO := "APARA PRETA"
		ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "D"
 			cTIPO := "APARA VERMELHA"
		ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "E"
 			cTIPO := "APARA AMARELA"
		ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "F"
 			cTIPO := "APARA VERDE"
		ElseIf SubStr( SC2->C2_PRODUTO, 3, 1 ) == "G"
 			cTIPO := "APARA CINZA"
	 	EndIf
	 Endif

	 ObjectMethod( oTIPO, "SetText( OemToAnsi( cTIPO ) )" )
	 If ! Empty( SC2->C2_RECURSO )
			cMAQ := SC2->C2_RECURSO
	 EndIf
EndIf
Return lRET



***************
Static Function PesqMaq()
***************

lRET := .T.

If ! SH1->( DbSeek( xFilial( "SH1" ) + cMAQ ) )
	 MsgAlert( OemToAnsi( "Maquina nao cadastrada" ) )
	 lRET := .F.
EndIf
If lRET
	 If ! Empty( SC2->C2_RECURSO ) .and. cMAQ <> SC2->C2_RECURSO
		  //lRET := U_senha2( "02" )[ 1 ]  Esmerino Neto
		  lRET := U_senha2( "02", 1 )[ 1 ]
	 EndIf
EndIf

Return lRET


***************
Static Function PesqOperad()
***************

lRET := .T.
/*MODIFICADO AQUI*/
cOPERAD := U_BuscaFun(1)
/*FIM DA MODIFICACAO*/
cQuery := "SELECT RA_MAT, RA_NOME FROM "
cQuery += RetSQlName("SRA")+" WHERE RA_MAT = '"+cOPERAD+"' AND D_E_L_E_T_ <> '*'"

TCQUERY cQuery NEW ALIAS "RAX"
If RAX->( EOF() )
	MsgAlert( OemToAnsi( "Operador nao cadastrado" ) )
  //MODIFICADO AQUI
  cNOMEO := ""
  ObjectMethod( oNOMEO, "SetText( OemToAnsi( cNOMEO ) )" )
  //FIM DA MODIFICAÇÃO
	lRET := .F.
EndIf


/*
If ! SRA->( DbSeek( xFilial( "SRA" ) + cOPERAD ) )
	MsgAlert( OemToAnsi( "Operador nao cadastrado" ) )
  //MODIFICADO AQUI
  cNOMEO := ""
  ObjectMethod( oNOMEO, "SetText( OemToAnsi( cNOMEO ) )" )
  //FIM DA MODIFICAÇÃO
	lRET := .F.
EndIf
*/

If lRET
	cNOMEO := Left( RAX->RA_NOME, 30 )
	ObjectMethod( oNOMEO, "SetText( OemToAnsi( cNOMEO ) )" )
EndIf

DBCloseArea("RAX")
Return lRET




***************
Static Function Abre_Impress()
***************

cDLL    := "impressora451.dll"
nHandle := ExecInDllOpen( cDLL )
if nHandle = -1
	 MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	 Return .F.
EndIf
// Parametro 1 = Porta serial da impressora
ExecInDLLRun( nHandle, 1, cPORTAIMP )
Return .T.



***************
Static Function Inc_Linha( cIMP, lPRIMLINHA )
***************

// Parametro 1 = Linha a ser impressa
// Parametro 2 = Limpa buffer
ExecInDLLRun( nHandle, 2, cIMP + "," + If( lPRIMLINHA, "1", "0" ) )
Return NIL



***************
Static Function Fecha_Impress()
***************

ExecInDLLRun( nHandle, 3, "" )
ExecInDLLClose( nHandle )
Return NIL



***************
Static Function Reimprime()
***************

For nCONT := 1 To Len( aIMP )
		If Abre_Impress()
			 Inc_Linha( aIMP[ nCONT, 1 ], .T. )
			 Inc_Linha( aIMP[ nCONT, 2 ], .F. )
			 Inc_Linha( aIMP[ nCONT, 3 ], .F. )
			 Fecha_Impress()
		EndIf
Next
ObjectMethod( oOP, "SetFocus()" )
Return NIL



***************
Static Function ValidExtru()
***************

oOPERAD:lReadOnly := ! lEXTRUSAO

cOPERAD           := Space( 06 )
cNOMEO            := Space( 30 )
ObjectMethod( oNOMEO, "SetText( OemToAnsi( cNOMEO ) )" )
If lEXTRUSAO
   ObjectMethod( oOPERAD, "SetFocus()" )
EndIf

Return NIL



***************
Static Function IoDlgConsulta()
***************

Local oDlgConsulta,oBTOK,oBTSAIR,oSay3,oSay4,oPesquisa,oLocaliza

oDlgConsulta := MSDIALOG():Create()
oDlgConsulta:cName := "oDlgConsulta"
oDlgConsulta:cCaption := "Consulta"
oDlgConsulta:nLeft := 0
oDlgConsulta:nTop := 0
oDlgConsulta:nWidth := 425
oDlgConsulta:nHeight := 258
oDlgConsulta:lShowHint := .F.
oDlgConsulta:lCentered := .F.

oBTOK := SBUTTON():Create(oDlgConsulta)
oBTOK:cName := "oBTOK"
oBTOK:nLeft := 351
oBTOK:nTop := 12
oBTOK:nWidth := 52
oBTOK:nHeight := 25
oBTOK:lShowHint := .F.
oBTOK:lReadOnly := .F.
oBTOK:Align := 0
oBTOK:lVisibleControl := .T.
oBTOK:nType := 1
oBTOK:bAction := {|| ConsultaOk() }

oBTSAIR := SBUTTON():Create(oDlgConsulta)
oBTSAIR:cName := "oBTSAIR"
oBTSAIR:nLeft := 352
oBTSAIR:nTop := 46
oBTSAIR:nWidth := 52
oBTSAIR:nHeight := 25
oBTSAIR:lShowHint := .F.
oBTSAIR:lReadOnly := .F.
oBTSAIR:Align := 0
oBTSAIR:lVisibleControl := .T.
oBTSAIR:nType := 2
oBTSAIR:bAction := {|| oDlgConsulta:End() }

oSay3 := TSAY():Create(oDlgConsulta)
oSay3:cName := "oSay3"
oSay3:cCaption := "Pesquisa por:"
oSay3:nLeft := 15
oSay3:nTop := 167
oSay3:nWidth := 75
oSay3:nHeight := 17
oSay3:lShowHint := .F.
oSay3:lReadOnly := .F.
oSay3:Align := 0
oSay3:lVisibleControl := .T.
oSay3:lWordWrap := .F.
oSay3:lTransparent := .F.

oSay4 := TSAY():Create(oDlgConsulta)
oSay4:cName := "oSay4"
oSay4:cCaption := "Localizar:"
oSay4:nLeft := 35
oSay4:nTop := 199
oSay4:nWidth := 54
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .F.

oPesquisa := TCOMBOBOX():Create(oDlgConsulta)
oPesquisa:cName := "oPesquisa"
oPesquisa:nLeft := 93
oPesquisa:nTop := 166
oPesquisa:nWidth := 232
oPesquisa:nHeight := 21
oPesquisa:lShowHint := .F.
oPesquisa:lReadOnly := .F.
oPesquisa:Align := 0
oPesquisa:lVisibleControl := .T.
oPesquisa:nAt := 0
oPesquisa:bChange := {|| MudaIndex() }

oLocaliza := TGET():Create(oDlgConsulta)
oLocaliza:cName := "oLocaliza"
oLocaliza:nLeft := 93
oLocaliza:nTop := 198
oLocaliza:nWidth := 232
oLocaliza:nHeight := 21
oLocaliza:lShowHint := .F.
oLocaliza:lReadOnly := .F.
oLocaliza:Align := 0
oLocaliza:lVisibleControl := .T.
oLocaliza:lPassword := .F.
oLocaliza:lHasButton := .F.
oLocaliza:bValid := {|| VldPesq() }

oDlgConsulta:Activate()

Return