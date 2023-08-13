#Include "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "font.ch"
#include "colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  GERAOP  ³ Autor ³   Mauricio Barros     ³ Data ³ 13/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Manutencao da programacao de producao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Rava Embalagens                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*********************
User Function GROP2()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
*********************

SetPrvt( "cCADASTRO, aROTINA, oDLG, lVOLTA, " )

aRotina   := {{ "Pesquisar" , "AxPesqui" , 0, 1 },;
              { "Visualizar", "U_GROP_M" , 0, 2 },;
              { "Gerar"     , "U_GROP_M" , 0, 3 },;
              { "Alterar"   , "U_GROP_M" , 0, 4 },;
              { "Excluir"   , "U_GROP_M" , 0, 5 },;
              { "Imprimir"  , "U_GROPIMP", 0, 6 }}

cCADASTRO := OemToAnsi( "Programacao de producao" )
mBrowse( 06, 01, 22, 75, 'Z02' )
Return NIL


*************
User Function GROP_M( cAlias, nReg, nAcao )
*************

PRIVATE aCpoGetDados := { "Z03_NUM" }  // Campos p/ nao mostrar no GETDADOS/ITEM
Private nOPCAO  := nACAO
Private aCols   := {}
Private aHeader := {}
Private nUsado  := 0
Private aRotina := { { "RDMAKE" ,"AxAltera", 0 , 3 } }
Private cPERG   := "GERAOP"

AADD( aRotina, aClone( aRotina[ 1 ] ) )
AADD( aRotina, aClone( aRotina[ 1 ] ) )

DbSelectArea("SA1")
DbSelectArea("SB1")
DbSelectArea("SB2")

DbSelectArea("Z02")
DbSelectArea("Z03")

SA1->( DbSetOrder( 1 ) )
SB1->( DbSetOrder( 1 ) )
SB2->( DbSetOrder( 1 ) )


If nACAO == 2 .or. nACAO == 4
	Z03->( DbSeek( xFilial( "Z03" ) + Z02->Z02_NUM, .T.  ) )
	While Z02->Z02_NUM == Z03->Z03_NUM
		SC2->( DbSeek( xFilial( "SC2" ) + Z03->Z03_NUMOP, .T. ) )
		If SC2->C2_NUM <> Z03->Z03_NUMOP
			Z03->( RecLock( "Z03", .F. ) )
			Z03->Z03_NUMOP := Space( 06 )
			Z03->( MsUnlock() )
		EndIf
		Z03->( DbSkip() )
	End
ElseIf nACAO == 3
	Validperg()
	If ! Pergunte( cPERG, .T. )
		Return NIL
	EndIf
	lVOLTA := .F.
	MsAguarde( {|| GeraProg() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Gerando programacao..." ) )
	If lVOLTA
		Return NIL
	EndIf
ElseIf nACAO == 5
	Z03->( DbSeek( xFilial( "Z03" ) + Z02->Z02_NUM, .T. ) )
	While Z03->Z03_NUM == Z02->Z02_NUM
		If Z03->Z03_QTDOP > 0
			Alert( "Programacao iniciada nao pode ser excluida" )
			Return NIL
		EndIf
		Z03->( DbSkip() )
	End
EndIf
If Z02->Z02_TIPO == "C"
	Aadd( aCpoGetDados, "Z03_VALOR" )
	Z03->( DbSetOrder( 2 ) )
EndIf
cNUMERO  := Z02->Z02_NUM
dDATAI   := Z02->Z02_DTINI
dDATAF   := Z02->Z02_DTFIM
cTIPOP   := Z02->Z02_TIPO
For nI := 1 to Len( aCpoGetDados )
	aCpoGetDados[ nI ] := Padr( aCpoGetDados[ nI ], 10 )
Next
MontaHead()
MontaCols()

nPROGTOT := 0
nSOBRTOT := 0
nSUGETOT := 0
nNESSTOT := 0
CalcProg( .F. )
CalcSobr( .F. )
aBOTOES  := {}
aAdd( aBOTOES, { 'AUTOM', {|| MsAguarde( {|| GravaOP() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Gerando OP'S..." ) ) }, "Gerar OP" } )
aAdd( aBOTOES, { 'CONTAINR', {|| ConPad1( ,,, "EST" ) }, "Consultar estoque" } )
aAdd( aBOTOES, { 'S4WB005N', {|| U_PCPOP() }, "Imprimir OP's" } )
aAdd( aBOTOES, { 'S4WB011N', {|| PesqProd() }, "Localizar produto" } )

DEFINE FONT oFont NAME "Arial" SIZE 6, 15 BOLD

oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Programação de produção"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 795
oDlg:nHeight := 455
oDlg:lShowHint := .T.
oDlg:lCentered := .T.

oBRW := MSGetDados():New( 040, 005, 195, 390, 1, "U_GROPLI()", "U_GROPOK()",, .T.,,, .F., 999, "U_GROPFLD()",,, "U_GROPDEL()" )

oSay1 := TSAY():Create(oDlg)
oSay1:cName     := "oSay1"
oSay1:cCaption  := "Número:"
oSay1:nLeft     := 19
oSay1:nTop      := 30
oSay1:nWidth    := 46
oSay1:nHeight   := 17
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align     := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oNUMERO := TGET():Create(oDlg)
oNUMERO:cName := "oNUMERO"
oNUMERO:nLeft := 66
oNUMERO:nTop := 28
oNUMERO:nWidth := 72
oNUMERO:nHeight := 21
oNUMERO:lShowHint := .F.
oNUMERO:lReadOnly := .T.
oNUMERO:Align := 0
oNUMERO:cVariable := "cNUMERO"
oNUMERO:bSetGet := {|u| If(PCount()>0,cNUMERO:=u,cNUMERO) }
oNUMERO:lVisibleControl := .T.
oNUMERO:lPassword := .F.
oNUMERO:lHasButton := .F.

oSay3 := TSAY():Create(oDlg)
oSay3:cName := "oSay3"
oSay3:cCaption := "Data inicial do periodo:"
oSay3:nLeft := 172
oSay3:nTop := 30
oSay3:nWidth := 110
oSay3:nHeight := 17
oSay3:lShowHint := .F.
oSay3:lReadOnly := .F.
oSay3:Align := 0
oSay3:lVisibleControl := .T.
oSay3:lWordWrap := .F.
oSay3:lTransparent := .F.

oDATAI := TGET():Create(oDlg)
oDATAI:cName := "oDATAI"
oDATAI:nLeft := 288
oDATAI:nTop := 28
oDATAI:nWidth := 84
oDATAI:nHeight := 21
oDATAI:lShowHint := .F.
oDATAI:lReadOnly := .T.
oDATAI:Align := 0
oDATAI:cVariable := "dDATAI"
oDATAI:bSetGet := {|u| If(PCount()>0,dDATAI:=u,dDATAI) }
oDATAI:lVisibleControl := .T.
oDATAI:lPassword := .F.
oDATAI:lHasButton := .F.

oSay5 := TSAY():Create(oDlg)
oSay5:cName := "oSay5"
oSay5:cCaption := "Data final do periodo:"
oSay5:nLeft := 403
oSay5:nTop := 30
oSay5:nWidth := 113
oSay5:nHeight := 17
oSay5:lShowHint := .F.
oSay5:lReadOnly := .F.
oSay5:Align := 0
oSay5:lVisibleControl := .T.
oSay5:lWordWrap := .F.
oSay5:lTransparent := .F.

oDATAF := TGET():Create(oDlg)
oDATAF:cName := "oDATAF"
oDATAF:nLeft := 518
oDATAF:nTop := 28
oDATAF:nWidth := 68
oDATAF:nHeight := 21
oDATAF:lShowHint := .F.
oDATAF:lReadOnly := .T.
oDATAF:Align := 0
oDATAF:cVariable := "dDATAF"
oDATAF:bSetGet := {|u| If(PCount()>0,dDATAF:=u,dDATAF) }
oDATAF:lVisibleControl := .T.
oDATAF:lPassword := .F.
oDATAF:lHasButton := .F.

oSay7 := TSAY():Create(oDlg)
oSay7:cName := "oSay7"
oSay7:cCaption := "Tipo da programacao:"
oSay7:nLeft := 620
oSay7:nTop := 30
oSay7:nWidth := 113
oSay7:nHeight := 17
oSay7:lShowHint := .F.
oSay7:lReadOnly := .F.
oSay7:Align := 0
oSay7:lVisibleControl := .T.
oSay7:lWordWrap := .F.
oSay7:lTransparent := .F.

oTIPOP := TGET():Create(oDlg)
oTIPOP:cName := "oTIPOP"
oTIPOP:nLeft := 735
oTIPOP:nTop := 28
oTIPOP:nWidth := 28
oTIPOP:nHeight := 21
oTIPOP:lShowHint := .F.
oTIPOP:lReadOnly := .T.
oTIPOP:Align := 0
oTIPOP:cVariable := "oTIPOP"
oTIPOP:bSetGet := {|u| If(PCount()>0,cTIPOP:=u,cTIPOP) }
oTIPOP:lVisibleControl := .T.
oTIPOP:lPassword := .F.
oTIPOP:lHasButton := .F.

oSay6 := TSAY():Create(oDlg)
oSay6:cName := "oSay6"
oSay6:cCaption := "Descrição do produto:"
oSay6:nLeft := 19
oSay6:nTop := 55
oSay6:nWidth := 113
oSay6:nHeight := 17
oSay6:lShowHint := .F.
oSay6:lReadOnly := .F.
oSay6:Align := 0
oSay6:lVisibleControl := .T.
oSay6:lWordWrap := .F.
oSay6:lTransparent := .F.

oPDTDESC := TSAY():Create(oDlg)
oPDTDESC:cName := "oPDTDESC"
oPDTDESC:cCaption := ""
oPDTDESC:nLeft := 135
oPDTDESC:nTop := 55
oPDTDESC:nWidth := 380
oPDTDESC:nHeight := 17
oPDTDESC:lShowHint := .F.
oPDTDESC:lReadOnly := .F.
oPDTDESC:Align := 0
oPDTDESC:lVisibleControl := .T.
oPDTDESC:lWordWrap := .F.
oPDTDESC:lTransparent := .F.
oPDTDESC:SetFont( oFont )
oPDTDESC:nCLRTEXT := CLR_BLUE

oSay8 := TSAY():Create(oDlg)
oSay8:cName := "oSay8"
oSay8:cCaption := "UM do produto:"
oSay8:nLeft := 520
oSay8:nTop := 55
oSay8:nWidth := 113
oSay8:nHeight := 17
oSay8:lShowHint := .F.
oSay8:lReadOnly := .F.
oSay8:Align := 0
oSay8:lVisibleControl := .T.
oSay8:lWordWrap := .F.
oSay8:lTransparent := .F.

oPDTUM := TSAY():Create(oDlg)
oPDTUM:cName := "oPDTUM"
oPDTUM:cCaption := ""
oPDTUM:nLeft := 605
oPDTUM:nTop := 55
oPDTUM:nWidth := 200
oPDTUM:nHeight := 17
oPDTUM:lShowHint := .F.
oPDTUM:lReadOnly := .F.
oPDTUM:Align := 0
oPDTUM:lVisibleControl := .T.
oPDTUM:lWordWrap := .F.
oPDTUM:lTransparent := .F.
oPDTUM:SetFont( oFont )
oPDTUM:nCLRTEXT := CLR_BLUE

oSay9 := TSAY():Create(oDlg)
oSay9:cName := "oSay9"
oSay9:cCaption := "Necessidade total(KG):"
oSay9:nLeft := 19
oSay9:nTop := 400
oSay9:nWidth := 136
oSay9:nHeight := 17
oSay9:lShowHint := .F.
oSay9:lReadOnly := .F.
oSay9:Align := 0
oSay9:lVisibleControl := .T.
oSay9:lWordWrap := .F.
oSay9:lTransparent := .F.

oNESSTOT := TSAY():Create(oDlg)
oNESSTOT:cName := "oNESSTOT"
oNESSTOT:cCaption := Trans( nNESSTOT, "@E 999,999.99" )
oNESSTOT:nLeft := 139
oNESSTOT:nTop := 400
oNESSTOT:nWidth := 72
oNESSTOT:nHeight := 21
oNESSTOT:lShowHint := .F.
oNESSTOT:lReadOnly := .F.
oNESSTOT:Align := 0
oNESSTOT:lVisibleControl := .T.
oNESSTOT:lWordWrap := .F.
oNESSTOT:lTransparent := .F.
oNESSTOT:SetFont( oFont )
oNESSTOT:nCLRTEXT := CLR_BLUE

oSay10 := TSAY():Create(oDlg)
oSay10:cName := "oSay9"
oSay10:cCaption := "Sugestao total(KG):"
oSay10:nLeft := 209
oSay10:nTop := 400
oSay10:nWidth := 136
oSay10:nHeight := 17
oSay10:lShowHint := .F.
oSay10:lReadOnly := .F.
oSay10:Align := 0
oSay10:lVisibleControl := .T.
oSay10:lWordWrap := .F.
oSay10:lTransparent := .F.

oSUGETOT := TSAY():Create(oDlg)
oSUGETOT:cName := "oSUGETOT"
oSUGETOT:cCaption := Trans( nSUGETOT, "@E 999,999.99" )
oSUGETOT:nLeft := 319
oSUGETOT:nTop := 400
oSUGETOT:nWidth := 72
oSUGETOT:nHeight := 21
oSUGETOT:lShowHint := .F.
oSUGETOT:lReadOnly := .F.
oSUGETOT:Align := 0
oSUGETOT:lVisibleControl := .T.
oSUGETOT:lWordWrap := .F.
oSUGETOT:lTransparent := .F.
oSUGETOT:SetFont( oFont )
oSUGETOT:nCLRTEXT := CLR_BLUE

oSay9 := TSAY():Create(oDlg)
oSay9:cName := "oSay9"
oSay9:cCaption := "Programacao total(KG):"
oSay9:nLeft := 399
oSay9:nTop := 400
oSay9:nWidth := 136
oSay9:nHeight := 17
oSay9:lShowHint := .F.
oSay9:lReadOnly := .F.
oSay9:Align := 0
oSay9:lVisibleControl := .T.
oSay9:lWordWrap := .F.
oSay9:lTransparent := .F.

oPROGTOT := TSAY():Create(oDlg)
oPROGTOT:cName := "oPROGTOT"
oPROGTOT:cCaption := Trans( nPROGTOT, "@E 999,999.99" )
oPROGTOT:nLeft := 529
oPROGTOT:nTop := 400
oPROGTOT:nWidth := 72
oPROGTOT:nHeight := 21
oPROGTOT:lShowHint := .F.
oPROGTOT:lReadOnly := .F.
oPROGTOT:Align := 0
oPROGTOT:lVisibleControl := .T.
oPROGTOT:lWordWrap := .F.
oPROGTOT:lTransparent := .F.
oPROGTOT:SetFont( oFont )
oPROGTOT:nCLRTEXT := CLR_BLUE

oSay10 := TSAY():Create(oDlg)
oSay10:cName := "oSay9"
oSay10:cCaption := "Diferenca total(MR):"
oSay10:nLeft := 619
oSay10:nTop := 400
oSay10:nWidth := 136
oSay10:nHeight := 17
oSay10:lShowHint := .F.
oSay10:lReadOnly := .F.
oSay10:Align := 0
oSay10:lVisibleControl := .T.
oSay10:lWordWrap := .F.
oSay10:lTransparent := .F.

oSOBRTOT := TSAY():Create(oDlg)
oSOBRTOT:cName := "oSOBRTOT"
oSOBRTOT:cCaption := Trans( nSOBRTOT, "@E 999,999.99" )
oSOBRTOT:nLeft := 719
oSOBRTOT:nTop := 400
oSOBRTOT:nWidth := 72
oSOBRTOT:nHeight := 21
oSOBRTOT:lShowHint := .F.
oSOBRTOT:lReadOnly := .F.
oSOBRTOT:Align := 0
oSOBRTOT:lVisibleControl := .T.
oSOBRTOT:lWordWrap := .F.
oSOBRTOT:lTransparent := .F.
oSOBRTOT:SetFont( oFont )
oSOBRTOT:nCLRTEXT := CLR_BLUE

DbSelectArea("SB1")
DbSelectArea("SB5")

oBRW:oBROWSE:bCHANGE := { || If( SB1->( DbSeek( Xfilial( "SB1" ) + aCols[ n, iCOD ] ) ), ;
( ObjectMethod( oPDTDESC, "SetText( AllTrim( SB1->B1_COD ) + '  -  ' + AllTrim( SB1->B1_DESC ) )" ), ;
( ObjectMethod( oPDTUM,   "SetText( SB1->B1_UM + ' (' + AllTrim( Trans( Posicione( 'SB5', 1, xfilial( 'SB5' ) + SB1->B1_COD, 'B5_QE2' ), '@E 9999' ) ) + ')' )" ) ) ), ;
( ObjectMethod( oPDTDESC, "SetText( '' )" ), ObjectMethod( oPDTUM, "SetText( '' )" ) ) ) }

Activate Dialog oDLG Centered On Init EnchoiceBar( oDlg, { || If( oBRW:TudoOk(), oDlg:End(), NIL ), .F. }, { || oDlg:End() },, aBOTOES )
Return NIL



*************
Static Function CalcProg( lFLAG, nVALOR1, nVALOR2 )
*************

nPROGTOT := If( nVALOR1 <> NIL, nVALOR2 - nVALOR1, 0 )
AEval( aCOLS, { |X| nPROGTOT += X[ iQTDOP ] } )
If( lFLAG, ObjectMethod( oPROGTOT, "SetText( Trans( nPROGTOT, '@E 999,999.99' ) )" ), NIL )
	
Return NIL



*************
Static Function CalcSobr( lFLAG )
*************

nSOBRTOT := 0
If lFLAG
	AEval( aCOLS, { |X| nSOBRTOT += X[ iSOBRA ] } )
	ObjectMethod( oSOBRTOT, "SetText( Trans( nSOBRTOT, '@E 999,999.99' ) )" )
Else
	AEval( aCOLS, { |X| X[ iSOBRA ] := If( X[ iQTDOPM ] > 0, X[ iQTDOPM ] - X[ iQTSUGM ], 0 ), nSOBRTOT += X[ iSOBRA ] } )
	AEval( aCOLS, { |X| nNESSTOT += X[ iQTCARK ] } )
	AEval( aCOLS, { |X| nSUGETOT += X[ iQTDSUG ] } )
EndIf
Return NIL



*************
User Function GROPLI()
*************

Local nx
Local lRet := .T.
Local lDeleted := .F.

IF ValType( aCols[ n, Len( aCols[ n ] ) ] ) == "L"
	lDeleted := aCols[ n, Len( aCols[ n ] ) ]      // Verifica se esta Deletado
EndIf
IF ! lDeleted
	For nx = 1 To Len( aCols )
		IF Empty( aCOLS[ n, iCOD ] )
			Help( ' ', 1, 'OBRIGAT' )
			lRet := .F.
		EndIF
		IF ! lRet
			Exit
		EndIF
	Next nx
EndIF
Return lRet



***************
User Function GROPOK()
***************

If nOPCAO == 3 .or. nOPCAO == 4
	For nCONT1 := 1 To Len( aCols )
		IF ! aCols[ nCONT1, Len( aCols[ nCONT1 ] ) ] .and. ! Empty( aCOLS[ nCONT1, iCOD ] )
			nORD := Z03->( IndexOrd() )
			Z03->( DbSetOrder( 1 ) )
			IF Z03->( DbSeek( xFilial( "Z03" ) + Z02->Z02_NUM + aCols[ nCONT1, iCOD ] ) )
				Z03->( RecLock( "Z03", .F. ) )
				Z03->Z03_QTDOP  := aCols[ nCONT1, iQTDOP ]
				Z03->Z03_QTDOPM := aCols[ nCONT1, iQTDOPM ]
				Z03->Z03_DIAS   := aCols[ nCONT1, iDIAS ]				
				Z03->( MsUnlock() )
			Else
				RecLock( "Z03", .T. )
				Z03->Z03_FILIAL := xFilial( "Z03" )
				Z03->Z03_NUM    := Z02->Z02_NUM
				Z03->Z03_COD    := aCols[ nCONT1, iCOD ]
//				Z03->Z03_SVIP   := aCols[ nCONT1, iSVIP ]
				Z03->Z03_QTESTK := aCols[ nCONT1, iQTESTK ]
				Z03->Z03_QTDEST := aCols[ nCONT1, iQTDEST ]
				Z03->Z03_QTCARK := aCols[ nCONT1, iQTCARK ]
				Z03->Z03_QTDCAR := aCols[ nCONT1, iQTDCAR ]
				Z03->Z03_QTDSUG := aCols[ nCONT1, iQTDSUG ]
				Z03->Z03_QTSUGM := aCols[ nCONT1, iQTSUGM ]
				Z03->Z03_QTDOP  := aCols[ nCONT1, iQTDOP  ]
				Z03->Z03_QTDOPM := aCols[ nCONT1, iQTDOPM ]
				//Z03->Z03_SOBRA  := aCols[ nCONT1, iSOBRA  ]
				Z03->Z03_DIAS   := aCols[ nCONT1, iDIAS   ]
				
				//Z03->Z03_PESPED := aCols[ nCONT1, iPESPED ]
				//Z03->Z03_QTDPED := aCols[ nCONT1, iQTDPED ]
				Z03->Z03_QTPRIK := aCols[ nCONT1, iQTPRIK ]
				Z03->Z03_QTDPRI := aCols[ nCONT1, iQTDPRI ]
				Z03->Z03_PESBOB := aCols[ nCONT1, iPESBOB ]
				Z03->Z03_PESOP  := aCols[ nCONT1, iPESOP  ]
				Z03->Z03_MILHOP := aCols[ nCONT1, iMILHOP ]
				Z03->( MsUnlock() )
			EndIf
			Z03->( DbSetOrder( nORD ) )
		EndIf
	Next
ElseIf nOPCAO == 5
	Z03->( DbSeek( xFilial( "Z03" ) + Z02->Z02_NUM, .T. ) )
	While Z03->Z03_NUM == Z02->Z02_NUM
		Z03->( RecLock( "Z03", .F. ) )
		Z03->( DbDelete() )
		Z03->( MsUnlock() )
		Z03->( DbSkip() )
	End
	Z02->( RecLock( "Z02", .F. ) )
	Z02->( DbDelete() )
	Z02->( MsUnlock() )
EndIf
Return .T.



***************
User Function GROPFLD()
***************

If ReadVar() == "M->Z03_COD"
	IF ! Empty( aCols[ n, iNUMOP ] )
		MsgBox ( "Nao e permitido alterar programacao de produto com OP ja gerada", "Erro", "STOP" )
		Return .F.
	EndIf
	If Len( Alltrim( M->Z03_COD ) ) > 7
		MsgBox ( "Nao e permitido incluir produto secundario", "Erro", "STOP" )
		Return .F.
	EndIf
	SB1->( DbSeek( Xfilial( "SB1" ) + M->Z03_COD ) )
	If SB1->B1_COD <> M->Z03_COD
		Help( ' ', 1, 'NAOEXISTE' )
		Return .F.
	EndIf
	nORD := Z03->( IndexOrd() )
	Z03->( DbSetOrder( 1 ) )
	If Z03->( DbSeek( xFilial( "Z03" ) + Z02->Z02_NUM + M->Z03_COD ) )
		Help( " ", 1, "JAGRAVADO" )
		Z03->( DbSetOrder( nORD ) )
		Return .F.
	Endif
	Z03->( DbSetOrder( nORD ) )
	cPROD  := M->Z03_COD  // Query das op's programadas                                                                          //* SB1.B1_PESO
	cQuery := "SELECT SC2.C2_NUM, SC2.C2_QUJE, SC2.C2_QTSEGUM, SC2.C2_QUANT - SC2.C2_QUJE AS QUANT, ( SC2.C2_QUANT - SC2.C2_QUJE ) / SB1.B1_CONV AS PESO "
	cQuery += "FROM " + RetSqlName( "SC2" ) + " SC2, " + RetSqlName( "SB1" ) + " SB1 "
	cQuery += "WHERE SC2.C2_PRODUTO = '" + cPROD + "' AND SC2.C2_DATRF = '        ' AND "
	cQuery += "SC2.C2_PRODUTO = SB1.B1_COD AND "
	cQuery += "SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' AND "
	cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SC2X"
	
	cQuery := "SELECT SG1.G1_COMP "  // Codigo do PI (bobina)
	cQuery += "FROM " + RetSqlName( "SG1" ) + " SG1 "
	cQuery += "WHERE SG1.G1_COD = '" + cPROD + "' AND LEFT( SG1.G1_COMP, 2 ) = 'PI' AND "
	cQuery += "SG1.G1_FILIAL = '" + xFilial( "SG1" ) + "' AND SG1.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SG1X"
	
	nPESBOB := nPESOP := 0
	While ! SC2X->( Eof() )
		cQuery := "SELECT SC2.C2_QUANT,SC2.C2_QUJE "  // Query de estoque do PI (bobina)
		cQuery += "FROM " + RetSqlName( "SC2" ) + " SC2 "
		cQuery += "WHERE SC2.C2_NUM = '" + SC2X->C2_NUM + "' AND SC2.C2_PRODUTO = '" + SG1X->G1_COMP + "' AND "
		cQuery += "SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery( cQuery )
		TCQUERY cQuery NEW ALIAS "SC2Y"
		nPESOP += SC2X->PESO
		If Empty( SC2X->C2_QUJE )  // OP nao foi iniciada
			nPESBOB += SC2Y->C2_QUJE
		ElseIf SC2Y->C2_QUJE - ( SC2X->C2_QTSEGUM / SC2X->C2_QUJE * SC2X->C2_QUJE ) > 0  // OP ja iniciada
			nPESBOB += SC2Y->C2_QUJE - ( SC2X->C2_QTSEGUM / SC2X->C2_QUJE * SC2X->C2_QUJE )
		EndIf
		SC2Y->( DbCloseArea() )
		SC2X->( DbSkip() )
	End
	SC2X->( DbCloseArea() )
	SG1X->( DbCloseArea() )
	SB2->( DbSeek( xFilial() + cPROD + "01" ) )
	aCols[ n, iQTESTK ] := SB2->B2_QATU / SB1->B1_CONV
	aCols[ n, iQTDEST ] := SB2->B2_QATU
	/**/ //Incluido em 22/10/2007
	if SB2->( DbSeek( xFilial() + cPROD + "02", .F. ) ) 
	  aCols[ n, iQTESTK ] += SB2->B2_QATU / SB1->B1_CONV
	  aCols[ n, iQTDEST ] += SB2->B2_QATU
	endIf
	nSug := carteira( cProd ) - ( aCols[ n, iQTESTK ] + SldOPs( cProd ) )
	aCols[ n, iQTDSUG ] := iif(nSug > 0, nSug, 0); 	aCols[ n, iQTSUGM ] := iif(nSug > 0, nSug * SB1->B1_CONV, 0)
	aCols[ n, iPESBOB ] := nPESBOB
	aCols[ n, iPESOP  ] := nPESOP
	aCols[ n, iMILHOP ] := nPESOP * SB1->B1_CONV// / SB1->B1_PESO
ElseIf ReadVar() == "M->Z03_QTDOP"
	IF ! Empty( aCols[ n, iNUMOP ] )
		MsgBox ( "Nao e permitido alterar programacao de produto com OP ja gerada", "Erro", "STOP" )
		Return .F.
	EndIF
	SB1->( DbSeek( Xfilial( "SB1" ) + aCols[ n, iCOD ] ) )
	aCols[ n, iQTDOPM ] := M->Z03_QTDOP * SB1->B1_CONV// / SB1->B1_PESO
	aCols[ n, iSOBRA  ] := If( ( M->Z03_QTDOP * SB1->B1_CONV/* / SB1->B1_PESO*/ ) > 0, ( M->Z03_QTDOP * SB1->B1_CONV /* / SB1->B1_PESO*/ ) - aCols[ n, iQTSUGM ], 0 )
	aCols[ n, iDIAS   ] := EstDias( aCols[ n, iCOD ],, aCols[ n, iQTDOPM ] )
	CalcProg( .T., aCols[ n, iQTDOP ], M->Z03_QTDOP )
	CalcSobr( .T. )
ElseIf ReadVar() == "M->Z03_QTDOPM"
	IF ! Empty( aCols[ n, iNUMOP ] )
		MsgBox ( "Nao e permitido alterar programacao de produto com OP ja gerada", "Erro", "STOP" )
		Return .F.
	EndIF
	SB1->( DbSeek( Xfilial( "SB1" ) + aCols[ n, iCOD ] ) )
	CalcProg( .T., aCols[ n, iQTDOP ], M->Z03_QTDOPM / SB1->B1_CONV ) // * SB1->B1_PESO )
	aCols[ n, iQTDOP ] := M->Z03_QTDOPM / SB1->B1_CONV  // * SB1->B1_PESO
	aCols[ n, iSOBRA ] := If( M->Z03_QTDOPM > 0, M->Z03_QTDOPM - aCols[ n, iQTSUGM ], 0 )
	aCols[ n, iDIAS  ] := EstDias( aCols[ n, iCOD ], , M->Z03_QTDOPM )
	CalcSobr( .T. )

ElseIf ReadVar() == "M->Z03_DIAS"
	IF ! Empty( aCols[ n, iNUMOP ] )
		MsgBox ( "Nao e permitido alterar programacao de produto com OP ja gerada", "Erro", "STOP" )
		Return .F.
	EndIF
	SB1->( DbSeek( Xfilial( "SB1" ) + aCols[ n, iCOD ] ) )
	nQtdD := EstDias( aCols[ n, iCOD ], M->Z03_DIAS )
	aCols[ n, iQTDOPM ] := nQtdD // * SB1->B1_CONV  // / SB1->B1_PESO
	aCols[ n, iQTDOP ]  := nQtdD / SB1->B1_CONV  // * SB1->B1_PESO
	aCols[ n, iSOBRA ]  := If( aCols[ n, iQTDOPM ] > 0, aCols[ n, iQTDOPM ] - aCols[ n, iQTSUGM ], 0 )
	CalcProg( .T., aCols[ n, iQTDOP ], aCols[ n, iQTDOPM ] / SB1->B1_CONV ) // * SB1->B1_PESO )
	CalcSobr( .T. )
EndIf

DbSelectArea("Z03")

Return .T.



***************
User Function GROPDEL()
***************

Local nx
Local lRet := .T.
Local lDeleted := .F.

IF ValType( aCols[ n, Len( aCols[ n ] ) ] ) == "L"
	lDeleted := aCols[ n, Len( aCols[ n ] ) ]      // Verifica se esta Deletado
EndIf
IF ! lDeleted
	For nx = 1 To Len( aCols )
		IF ! Empty( aCOLS[ n, iCOD ] )
			lRet := .F.
		EndIF
		IF ! lRet
			Exit
		EndIF
	Next nx
EndIF

Return lRet



***************
Static Function MontaHead()//Aqui o cabeçário do grid é montado com base no SX3
***************

Local npos:= 0

SX3->( dbSetOrder( 1 ) )
SX3->( dbSeek( "Z03" ) )
While ! SX3->( Eof() ) .And. ( SX3->X3_ARQUIVO == "Z03" )
	nPos := Ascan( aCpoGetDados, SX3->X3_CAMPO )
	IF X3USO( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL .And. Empty( nPos )
//		if Alltrim(SX3->X3_CAMPO) == "Z03_SVIP" .and. MV_PAR05 = 2
//   	   SX3->( dbSkip() )
//		   loop
//		endif
		nUsado++
		AADD(aHeader,{ Trim(X3Titulo()), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, "AllwaysTrue()" , SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT } )
	EndIf
	SX3->( dbSkip() )
End
Return



***************
Static Function MontaCols()//Aqui os campos das colunas são preenchidos com base no Z03
***************

aCOLS := {}
DbSelectArea( "Z03" )
DbSeek( xFilial("Z03") + Z02->Z02_NUM, .T. )
While ! Eof() .And. Z03_NUM == Z02->Z02_NUM .and. xFilial( "Z03" ) == Z03->Z03_FILIAL
	AADD( aCols, Array( nUsado + 1 ) )
	For _ni := 1 to nUsado
		If ( aHeader[ _ni ][ 10 ] != "V" )
			aCols[ Len( aCols ), _ni ] := FieldGet( FieldPos( aHeader[ _ni, 2 ] ) )
		Else
			aCols[ Len( aCols ), _ni ] := CriaVar( aHeader[ _ni, 2 ], .t. )
		EndIf
	Next
	aCols[ Len( aCols ), nUsado + 1 ] := .F.
	dbSkip()
End

If Len( aCOLS ) == 0
	aCols := { Array( nUsado + 1 ) }
	aCols[ 1, nUsado + 1 ] := .F.
	For nCONT := 1 to nUsado
		aCols[ 1, nCONT ] := CriaVar( aHeader[ nCONT, 2 ] )
	Next
EndIf

public iCOD    := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_COD"    } )
//public iSVIP   := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_SVIP"   } )
public iQTESTK := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTESTK" } )
public iQTDEST := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDEST" } )
public iQTCARK := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTCARK" } )
public iQTDCAR := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDCAR" } )
public iQTDSUG := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDSUG" } )
public iQTSUGM := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTSUGM" } )
public iQTDOP  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDOP"  } )
public iQTDOPM := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDOPM" } )
public iSOBRA  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_SOBRA"  } )
public iDIAS   := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_DIAS"   } )
public iPESPED := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_PESPED" } )
public iQTDPED := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDPED" } )
public iQTPRIK := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTPRIK" } )
public iQTDPRI := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTDPRI" } )
public iPESBOB := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_PESBOB" } )
public iPESOP  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_PESOP"  } )
public iMILHOP := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_MILHOP" } )
public iPESOP  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_PESOP"  } )
public iNUMOP  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_NUMOP"  } )
public iDIAS2  := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_DIAS2"  } )
public iVALOR2 := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_VALOR2" } )
public iQTCAR2 := aScan( aHeader, { |x| AllTrim( x[2] ) == "Z03_QTCAR2" } )

Return



***************
Static Function GravaOP
***************

Local aMATRIZ := {}, ;
nIdx := nCONT := nQtdTT := nResto := nCount := nArred := nOrd := 0
Local aOPS    := {}
Local cQuery  := '' 
Procregua( Len( aCols ) )
For nCONT1 := 1 To Len( aCols )
	If Empty( aCols[ nCONT1, iNUMOP ] ) .and. !Empty( aCols[ nCONT1, iQTDOP ] );
	   .and. !aCols[ nCONT1, Len( aCols[ nCONT1 ] ) ] .and. !Empty( aCOLS[ nCONT1, iCOD ] )
		cQuery := "select G1_COMP, G1_QUANT "
		cQuery += "from   "+retSqlName('SG1')+" "
		cQuery += "where  G1_COD = '"+aCols[nCONT1,iCOD]+"' and substring(G1_COMP,1,2) = 'PI' "
		cQuery += "and G1_FILIAL = '"+xFilial('SG1')+"' and D_E_L_E_T_ != '*' "
		TCQUERY cQuery NEW ALIAS "_TMPX"
		_TMPX->( dbGoTop() )
		if _TMPX->( EoF() )
			msgAlert("Não existe estrtura para o produto " + aCols[nCONT1,iCOD] )
			_TMPX->( dbCloseArea() )
			Return
		endIf
		nQtdTT := aCols[ nCONT1, iQTDOP  ]//_TMPX->G1_QUANT * 
		nIdx := aScan( aOPS, { |x| x[1] == _TMPX->G1_COMP } )
		if nIdx <= 0
			aAdd( aOPS, { _TMPX->G1_COMP, nQtdTT, { nCONT1 } } )
		else
			aOPS[nIdx][2] += nQtdTT
			aAdd( aOPS[nIdx][3], nCONT1  )//guardo o índice do produto
		endIf
		_TMPX->( dbCloseArea() )
	endIf
	nQtdTT := 0
Next
For _d := 1 to len(aOPS)
	if !SB1->( DbSeek( xFilial( "SB1" ) + aOPS[_d][1], .F. ) )//trocar os campos de valores máximos e mínimos para SB5
		msgAlert("O produto " + aOPS[_d][1] + " não existe!")
		return
	endIF
	if (aOPS[_d][2]%SB1->B1_PSMNBOB) > 0//Saber se vai haver resto, checando se é múltiplo da qtd mínima
		Aviso("Atenção! ! !", "Existe uma quantidade quebrada ("+alltrim(transform(aOPS[_d][2]%SB1->B1_PSMNBOB,"@E 999,999.99"))+;
			  "KGs)para a produção da(s) bobina(s) do "+alltrim(aOPS[_d][1])+" que não atinge o valor mínimo"+;
			  "("+alltrim(transform(SB1->B1_PSMNBOB,"@E 999,999.99"))+"KGs) para extrusãodo mesmo. Corrija, por favor!", {"OK"})
		nArred := arredonda( aOPS[_d][2]%SB1->B1_PSMNBOB )
		if nArred > 0
			aOPS[_d][2] += nArred
			/*
			//SB1->( DbSeek( Xfilial( "SB1" ) + aCols[ n, iCOD ] ) )
			aCols[ n, iQTDOPM ] := M->Z03_QTDOP * SB1->B1_CONV
			aCols[ n, iSOBRA  ] := If( ( M->Z03_QTDOP * SB1->B1_CONV ) > 0, ( M->Z03_QTDOP * SB1->B1_CONV ) - aCols[ n, iQTSUGM ], 0 )
			aCols[ n, iDIAS   ] := EstDias( aCols[ n, iCOD ],, aCols[ n, iQTDOPM ] )
			CalcProg( .T., aCols[ n, iQTDOP ], M->Z03_QTDOP )
			CalcSobr( .T. )
			*/
		else
			msgAlert("Não é possível continuar até que você corrija todas as quantidades a serem produzidas!")
			return .F.
		endIf
	endIf
	nArred := 0
Next
For _x := 1 To Len(aOPS)
	aMATRIZ     := {}
	lMsErroAuto := .F.
	aMATRIZ     := {{ "C2_PRODUTO", aOPS[_x, 1],    NIL },;
               	    { "C2_QUANT",   aOPS[_x, 2],    NIL },;
               	    { "C2_PRIOR",   "500",          NIL },;
               	    { "C2_DESTINA", "E",            NIL },;
               	    { "C2_TPOP",    "F",            NIL },;
               	    { "C2_OPVIP",   Z02->Z02_PVIP,  NIL },;
               	    { "AUTEXPLODE", "S",            NIL }}
	Begin Transaction
	MSExecAuto( { |x| MATA650(x) }, aMATRIZ )
	IF lMsErroAuto
		DisarmTransaction()
		Break
	Endif
	End Transaction
	If lMSErroAuto
		MsgBox ( "Erro na geracao da OP do produto " + aOPS[_x, 1], "Erro", "STOP" )
		Return NIL
	EndIf
	nCONT++
	for _z := 1 to len( aOps[_x][3] )
		SB1->( DbSeek( Xfilial( "SB1" ) + aCols[ aOps[_x][3][_z], iCOD ] ) )
		/*Linha original abaixo*/
		aCols[ aOps[_x][3][_z], iNUMOP ] := SC2->C2_NUM
		/*Linha original acima */
		aCols[ aOps[_x][3][_z], iQTDOP  ] := aOps[_x][2]
		aCols[ aOps[_x][3][_z], iQTDOPM ] := aOps[_x][2] * SB1->B1_CONV
		aCols[ aOps[_x][3][_z], iSOBRA  ] := If( ( aOps[_x][2] * SB1->B1_CONV ) > 0, ( aOps[_x][2] * SB1->B1_CONV ) - aCols[ n, iQTSUGM ], 0 )
		aCols[ aOps[_x][3][_z], iDIAS   ] := EstDias( aCols[ aOps[_x][3][_z], iCOD ],, aCols[ aOps[_x][3][_z], iQTDOPM ] )
		CalcProg( .T., aCols[ aOps[_x][3][_z], iQTDOP ], aOps[_x][2] )
		CalcSobr( .T. )
	next
	IncProc()
Next
For nCONT1 := 1 To Len( aCols )
	IF ! aCols[ nCONT1, Len( aCols[ nCONT1 ] ) ] .and. ! Empty( aCOLS[ nCONT1, iCOD ] )
		nORD := Z03->( IndexOrd() )
		Z03->( DbSetOrder( 1 ) )
		IF Z03->( DbSeek( xFilial( "Z03" ) + Z02->Z02_NUM + aCols[ nCONT1, iCOD ] ) )
			Z03->( RecLock( "Z03", .F. ) )
			Z03->Z03_DIAS   := aCols[ nCONT1, iDIAS   ]			
			Z03->Z03_QTDOP  := aCols[ nCONT1, iQTDOP  ]
			Z03->Z03_QTDOPM := aCols[ nCONT1, iQTDOPM ]
			if !empty(aCols[ nCONT1, iNUMOP  ])
				Z03->Z03_NUMOP  := aCols[ nCONT1, iNUMOP  ]
			endIf
			Z03->( MsUnlock() )
		Else
			RecLock( "Z03", .T. )
			Z03->Z03_FILIAL := xFilial( "Z03" )
			Z03->Z03_NUM    := Z02->Z02_NUM
			Z03->Z03_COD    := aCols[ nCONT1, iCOD    ]
			Z03->Z03_QTESTK := aCols[ nCONT1, iQTESTK ]
			Z03->Z03_QTDEST := aCols[ nCONT1, iQTDEST ]
			Z03->Z03_QTCARK := aCols[ nCONT1, iQTCARK ]
			Z03->Z03_QTDCAR := aCols[ nCONT1, iQTDCAR ]
			Z03->Z03_QTDSUG := aCols[ nCONT1, iQTDSUG ]
			Z03->Z03_QTSUGM := aCols[ nCONT1, iQTSUGM ]
			Z03->Z03_DIAS   := aCols[ nCONT1, iDIAS   ]			
			Z03->Z03_QTDOP  := aCols[ nCONT1, iQTDOP  ]
			Z03->Z03_QTDOPM := aCols[ nCONT1, iQTDOPM ]
			Z03->Z03_QTPRIK := aCols[ nCONT1, iQTPRIK ]
			Z03->Z03_QTDPRI := aCols[ nCONT1, iQTDPRI ]
			Z03->Z03_PESBOB := aCols[ nCONT1, iPESBOB ]
			Z03->Z03_PESOP  := aCols[ nCONT1, iPESOP  ]
			Z03->Z03_MILHOP := aCols[ nCONT1, iMILHOP ]
			if !empty(aCols[ nCONT1, iNUMOP  ])
				Z03->Z03_NUMOP  := aCols[ nCONT1, iNUMOP  ]
			endIf
			Z03->( MsUnlock() )
		EndIf
		Z03->( DbSetOrder( nORD ) )
	EndIf	
Next
MsgBox( Alltrim( Trans( nCONT, "@E 999" ) ) + " OP(s) geradas com sucesso", "", "INFO" )

Return NIL

***************
User Function GROPIMP
***************

tamanho   := "M"
cDesc1    := PADC( "Este programa ira imprimir a programacao selecionada", 74 )
cDesc2    := ""
cDesc3    := ""
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "GERAOP"
nLastKey  := 0
wnrel     := "GERAOP"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao no SX1               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cString := "Z02"
titulo  := Padc( "Programacao de producao", 132 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel,, @titulo, cDesc1, cDesc2, cDesc3, .T., "",, Tamanho )
If nLastKey == 27
	Return
Endif

SetDefault( aReturn, cString )
If nLastKey == 27
	Return
Endif

RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})

Return



**********************
Static Function RptDetail()
***********************

M_PAG  := 1     //Variavel que acumula o numero de pagina
cabec1 := "NUMERO   EMISSAO    HORA    -----TIPO------   DT. INICIAL   DT. FINAL"
//         XXXXXX   XX/XX/XX   XX:XX   MEDIA DE VENDAS   XX/XX/XX      XX/XX/XX
//         0        9          20      28                46            60
cabec2 := "PRODUTO      --------------- D E S C R I C A O ----------------    PROG.(KG)    PROG.(MR)   DIF.PROG.(MR)   OP"
//         XXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999,999,99   999,999.99      999,999.99   999999
//         0            13                                                   66           79              95           108
Z03->( DbSetOrder( 1 ) )
nPROG := 0
Z03->( DbSeek( xFilial( "Z03" ) + Z02->Z02_NUM, .T.  ) )
While Z03->Z03_NUM == Z02->Z02_NUM
	nLin := Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 18 ) + 1 //Impressao do cabecalho
	@ nLIN,000 Psay Z02->Z02_NUM
	@ nLIN,009 Psay Z02->Z02_DATA
	@ nLIN,020 Psay Z02->Z02_HORA
	If Z02->Z02_TIPO == "C"
		@ nLIN,028 Psay "CARTEIRA"
	ElseIf Z02->Z02_TIPO == "F"
		@ nLIN,028 Psay "FINANCEIRO"
	Else
		@ nLIN,028 Psay "MEDIA DE VENDAS"
	EndIf
	@ nLIN,046 Psay Z02->Z02_DTINI
	@ nLIN,060 Psay Z02->Z02_DTFIM
	nLIN += 2
	While nLIN <= 60 .and. Z03->Z03_NUM == Z02->Z02_NUM
		If Z03->Z03_QTDOP > 0
			SB1->( DbSeek( Xfilial( "SB1" ) + Z03->Z03_COD ) )
			@ nLIN,000 Psay Left( Z03->Z03_COD, 10 )
			@ nLIN,013 Psay Left( SB1->B1_DESC, 50 )
			@ nLIN,066 Psay Z03->Z03_QTDOP Picture "@E 999,999.99"
			@ nLIN,079 Psay Z03->Z03_QTDOPM Picture "@E 999,999.99"
			@ nLIN,095 Psay Z03->Z03_QTDOPM - Z03->Z03_QTSUGM Picture "@E 999,999.99"
			@ nLIN,108 Psay Z03->Z03_NUMOP
			nPROG += Z03->Z03_QTDOP
			nLIN++
		EndIf
		Z03->( DbSkip() )
		IncProc()
	End
End

@ nLIN,000 Psay Repl( "-" , 132 )
@ nLIN + 1,000 Psay "T O T A L ------------------------------------------->"
@ nLIN + 1,066 Psay nPROG Picture "@E 999,999.99"
roda( 0, "" , tamanho )
If aReturn[5] == 1
	dbCommitAll()
	ourspool( wnrel )
Endif
MS_FLUSH()

Return NIL



***************
Static Function Sair
***************

If MsgBox( "Confirma saida do programa?", "Escolha", "YESNO" )
   Close( oDLG )
   Return .T.
EndIf

Return .F.



***************
Static Function GeraProg()
***************
Local nSug := nnVEN := 0
Local nREG, ;
cPROD, ;
CPROD1, ;
nPROG, ;
nQTDSUG, ;
nQTSUGM, ;
aCAMPOS

Local aRay 	  := {}

   cQuery := "SELECT SC5.C5_PRIOR AS PRIOR, SC6.C6_PRODUTO AS PRODUTO, SC5.C5_EMISSAO, "
   cQuery += "SC9.C9_QTDLIB AS QUANT, ( SC9.C9_QTDLIB / SB1.B1_CONV ) AS PESO, SC5.C5_CLIENTE AS CLIENTE "
   cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" ) + " SC6, " + RetSqlName( "SC9" ) + " SC9 "
   cQuery += "WHERE SC5.C5_EMISSAO BETWEEN '" + Dtos( mv_par01 ) + "' AND '" + Dtos( mv_par02 ) + "' AND "
   //Nao considera pedidos Programados
   cQuery += "SC5.C5_ENTREG <= '"+ dtos( lastday( dDataBase ) ) + "' AND "
   cQuery += "SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_PRODUTO = SB1.B1_COD AND "
   cQuery += "SC6.C6_PRODUTO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
   cQuery += "SC6.C6_BLQ <> 'R' AND SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC9.C9_ITEM AND "
   cQuery += "SC9.C9_BLCRED = '  ' AND SC9.C9_BLEST <> '10' AND SB1.B1_TIPO = 'PA' AND SC5.C5_TIPO <> 'B' AND "
   cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
   cQuery += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "
   cQuery += "ORDER BY SC6.C6_PRODUTO "
   TCQUERY cQuery NEW ALIAS "SC5X"

   TCSetField( 'SC5X', "VALOR", "N", 12, 2 )
   TCSetField( 'SC5X', "PESO", "N", 10, 4 )
   TCSetField( 'SC5X', "QUANT", "N", 10, 4 )
   TCSetField( 'SC5X', "C5_EMISSAO", "D" )
 
   cARQ := criatrab( .F., .F. )
   Copy To ( cARQ )
   SC5X->( DbCloseArea() )
   Use ( cARQ ) Alias SC5X New Exclusive
   SC5X->( DbGotop() )
 
   While ! SC5X->( Eof() )
	  RecLock( "SC5X", .F. )
      If Len( AllTrim( SC5X->PRODUTO ) ) > 7
         If Subs( SC5X->PRODUTO, 4, 1 ) == "R" .or. Subs( SC5X->PRODUTO, 5, 1 ) == "R"
    	    cPROD := Padr( Subs( SC5X->PRODUTO, 1, 1 ) + Subs( SC5X->PRODUTO, 3, 4 ) + Subs( SC5X->PRODUTO, 8, 2 ), 15 )
		 Else
		    cPROD := Padr( Subs( SC5X->PRODUTO, 1, 1 ) + Subs( SC5X->PRODUTO, 3, 3 ) + Subs( SC5X->PRODUTO, 7, 2 ), 15 )
		 EndIf
		 SC5X->PRODUTO := cPROD
	  EndIf
	  SC5X->( MsUnlock() )	
	
	  SC5X->( DbSkip() )
   End

   Index On PRODUTO + Dtos( C5_EMISSAO ) To ( cARQ )
   
if MV_PAR05 = 2
   SC5X->( __DbZap() )

   cQuery := "SELECT B1_COD "
   cquery += "FROM "+RetSqlName("SB1")+" "
   cQuery += "WHERE B1_ATIVO = 'S' "
   cQuery += "AND B1_TIPO = 'PA' "
   cQuery += "AND B1_FLAGOP = 'S' "
   cQuery += "AND D_E_L_E_T_ = '' "
   cQuery += "ORDER BY B1_COD "
   TCQUERY cQuery NEW ALIAS "SB1X"

   while ! SB1X->( Eof() )
      if Len( AllTrim( SB1X->B1_COD ) ) <= 7
         if ! SC5X->( DbSeek( SB1X->B1_COD ) )
            RecLock("SC5X", .T.)
    		   SC5X->PRODUTO := SB1X->B1_COD
    		   SC5X->( MsUnlock() )        
         endif
      endif
      SB1X->(DbSkip())
   end
   SB1X->(DbCloseArea())

endif


cNUM := GetSx8Num( "Z02", "Z02_NUM" )
RecLock( "Z02", .T. )
Z02->Z02_NUM   := cNUM
Z02->Z02_DATA  := Date()
Z02->Z02_HORA  := Left( Time(), 5 )
Z02->Z02_DTINI := MV_PAR01
Z02->Z02_DTFIM := MV_PAR02
Z02->Z02_TIPO  := IIF( MV_PAR05=1, "C", "M" )
Z02->Z02_PVIP  := IIF( MV_PAR05=1, "S", "N" )

Z02->( MsUnlock() )
ConfirmSX8()
Z02->( DbCommit() )
SC5X->( DbGotop() )
While ! SC5X->( Eof() )
//	cSeqVip := SC5X->SEQVIP
	cPROD  := SC5X->PRODUTO  // Query das op's programadas
	cQuery := "SELECT SC2.C2_NUM, SC2.C2_QUJE, SC2.C2_QUANT, SC2.C2_QTSEGUM, SC2.C2_QUANT - SC2.C2_QUJE AS QUANT, ( SC2.C2_QUANT - SC2.C2_QUJE ) / SB1.B1_CONV AS PESO "
	cQuery += "FROM " + RetSqlName( "SC2" ) + " SC2, " + RetSqlName( "SB1" ) + " SB1 "
	cQuery += "WHERE SC2.C2_PRODUTO = '" + cPROD + "' AND SC2.C2_DATRF = '        ' AND "
	cQuery += "SC2.C2_EMISSAO >= '" + Dtos( FirstDay( FirstDay( dDATABASE ) - 1 ) ) + "' AND SC2.C2_PRODUTO = SB1.B1_COD AND "
	cQuery += "SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' AND "
	cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SC2X"
	
	cQuery := "SELECT SG1.G1_COMP "  // Codigo do PI (bobina)
	cQuery += "FROM " + RetSqlName( "SG1" ) + " SG1 "
	cQuery += "WHERE SG1.G1_COD = '" + cPROD + "' AND LEFT( SG1.G1_COMP, 2 ) = 'PI' AND "
	cQuery += "SG1.G1_FILIAL = '" + xFilial( "SG1" ) + "' AND SG1.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SG1X"
	
	//Media de Vendas dos ultimos 6 meses
	if Len( AllTrim( cPROD ) ) <= 7
		cPROD2 := Padr( Subs( cPROD, 1, 1 ) + "D" + Subs( cPROD, 2, If( Subs( cPROD, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD, If( Subs( cPROD, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
	else
		cPROD2 := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, If( Subs( cPROD, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD, If( Subs( cPROD, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
	endif
	
	cQuery := "SELECT SD2.D2_COD, "
	cQuery += "( CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN  "
	cQuery += "     SUM(0)  "
	cQuery += "  ELSE SUM(D2_QUANT) "
	cQuery += "     END ) AS QUANT "
	cQuery += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF2")+" SF2 "
	cQuery += "WHERE D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA "
	cQuery += "AND SD2.D2_COD IN ( '"+cProd+"', '"+cProd2+"' ) AND SD2.D2_EMISSAO BETWEEN '"+DTOS(dDataBase - 180)+"' AND '"+DTOS(dDataBase)+"' "
	cQuery += "AND D2_FILIAL = '01' AND D2_TIPO = 'N' "
	cQuery += "AND RTRIM(D2_GRUPO) NOT IN ('G') "//Nao Considera Grupo Sacolas
	cQuery += "AND RTRIM(D2_COD) NOT IN ('187','188','189','190') " //Nao Considera aparas
	cQuery += "AND RTRIM(D2_CF) IN ( '511','5101','611','6101','512','5102','612','6102','6109','6107','5949 ','6949' ) "
	cQuery += "AND SD2.D_E_L_E_T_ = ' ' AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY SD2.D2_COD, D2_SERIE, F2_VEND1 "
	TCQUERY cQuery NEW ALIAS "SD2X"

	nVEN := 0
	SD2X->( DbEval( {|| nVEN += SD2X->QUANT } ) )
	
	SD2X->( DbCloseArea() )
	
	nPESBOB := nPESOP := 0
	While ! SC2X->( Eof() )
		cQuery := "SELECT SC2.C2_QUANT, SC2.C2_QUJE, SC2.C2_OPVIP "  // Query de estoque do PI (bobina)
		cQuery += "FROM " + RetSqlName( "SC2" ) + " SC2 "
		cQuery += "WHERE SC2.C2_NUM = '" + SC2X->C2_NUM + "' AND SC2.C2_PRODUTO = '" + SG1X->G1_COMP + "' AND "
		cQuery += "SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery( cQuery )
		TCQUERY cQuery NEW ALIAS "SC2Y"
		nPESOP += If( SC2Y->C2_QUANT - SC2Y->C2_QUJE > 0, SC2Y->C2_QUANT - SC2Y->C2_QUJE, 0 )
		If Empty( SC2X->C2_QUJE )  // OP nao foi iniciada
			nPESBOB += SC2Y->C2_QUJE
		ElseIf SC2Y->C2_QUJE - ( SC2X->C2_QTSEGUM / SC2X->C2_QUANT * SC2X->C2_QUJE ) > 0  // OP ja iniciada
			nPESBOB += SC2Y->C2_QUJE - ( SC2X->C2_QTSEGUM / SC2X->C2_QUANT * SC2X->C2_QUJE )
		EndIf
		SC2Y->( DbCloseArea() )
		SC2X->( DbSkip() )
	End
	
	SC2X->( DbCloseArea() )
	SG1X->( DbCloseArea() )
	SB2->( DbSeek( xFilial() + cPROD + "01" ) )
	nSug := nQUANT  := 0
	nPESO   := 0
	nPRIOR  := 0
	nDIAS := dDATABASE - SC5X->C5_EMISSAO
	nQUANTA := SC5X->QUANT
	nPESOA  := SC5X->PESO
	While SC5X->PRODUTO == cPROD
		nQUANT += SC5X->QUANT
		nPESO  += SC5X->PESO
		If ! Empty( SC5X->PRIOR )  // Pedido com prioridade
			nPRIOR += SC5X->QUANT
		EndIf
		SC5X->( DbSkip() )
	End
	nESTQ := SB2->B2_QATU
	SB1->( DbSeek( xFilial( "SB1" ) + cPROD ) )
	nMINIMO := 1  // Alterar aqui p/ producao minima
	RecLock( "Z03", .T. )
	Z03->Z03_NUM  := cNUM
//	Z03->Z03_SVIP := cSEQVIP
	Z03->Z03_COD  := cPROD
	Z03->Z03_QTDCAR := nQUANT
	Z03->Z03_QTCARK := nQUANT / SB1->B1_CONV //* SB1->B1_PESO

	nSug := Z03->Z03_QTCARK - ( nESTQ / SB1->B1_CONV) - SldOPs( cPROD )
	Z03->Z03_QTDSUG := iif( nSug > 0, nSug, 0 )
	Z03->Z03_QTSUGM := iif( nSug > 0, nSug * SB1->B1_CONV, 0 )
	
	Z03->Z03_QTDPED := nQUANTA
	Z03->Z03_PESPED := nPESOA

	Z03->Z03_QTDEST := nESTQ
	Z03->Z03_QTESTK := nESTQ / SB1->B1_CONV // * SB1->B1_PESO
	
	Z03->Z03_PESBOB := nPESBOB
	Z03->Z03_PESOP  := nPESOP
	Z03->Z03_MILHOP := nPESOP * SB1->B1_CONV// / SB1->B1_PESO

	//Dias de estoque
	Z03->Z03_DIAS2  := Round( DiasEst( cProd ), 1 )
	
	//Media de Vendas dos ultimos 6 meses - estoque - saldo de op programada
	if ( nVEN / 6 ) - Z03->Z03_MILHOP - Z03->Z03_QTDEST < 0
		Z03->Z03_QTDPRI := 0
	else
		Z03->Z03_QTDPRI :=  ( nVEN / 6 ) - Z03->Z03_MILHOP - Z03->Z03_QTDEST
	endif
	
	if ( ( nVEN / 6 ) / SB1->B1_CONV/* * SB1->B1_PESO*/ ) - Z03->Z03_PESOP - Z03->Z03_QTESTK < 0
		Z03->Z03_QTPRIK := 0
	else
		Z03->Z03_QTPRIK := ( ( nVEN / 6 ) / SB1->B1_CONV/* * SB1->B1_PESO*/ ) - Z03->Z03_PESOP - Z03->Z03_QTESTK
	endif
	
	Z03->( MsUnlock() )
End
Z03->( DbCommit() )
SC5X->( DbCloseArea() )

Return NIL


***************
User Function ESTREAL( cPROD1 )
***************

Local nQUANT := Posicione( "SB2", 1, xFilial( "SB2" ) + cPROD1 + "01", "SB2->B2_QATU" ), ;
cQUERY, ;
cALIASANT := Alias()

If Len( AllTrim( cPROD1 ) ) <= 7
	cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
	cQuery := "SELECT Sum( SC6.C6_QTDVEN - SC6.C6_QTDENT ) AS QUANT "
	cQuery += "FROM " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6") + " SC6 "
	cQuery += "WHERE SC5.C5_NUM = SC6.C6_NUM AND "
	cQuery += "SC6.C6_PRODUTO IN ( '" + cPROD1 + "', '" + cPROD2 + "' ) AND "
	cQuery += "( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND "
	cQuery += "SC5.C5_TIPO <> 'B' AND "
	cQuery += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
	cQuery += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SC5X"
	If ! SC5X->( Eof() )
		nQUANT := If( nQUANT - SC5X->QUANT < 0, 0, nQUANT - SC5X->QUANT )
	EndIf
	SC5X->( DbCloseArea() )
	DbSelectArea( cALIASANT )
EndIf
Return AllTrim( Trans( nQUANT, "@E 999,999.99" ) )



*******************
Static FUNCTION PesqProd()
*******************

Private oDLG, ;
cPROD := Space( 15 )

@ 000,000 To 120,246 Dialog oDLG Title "Localizar produto"

@ 00, 02 To 42, 132
@ 17, 60 Get cPROD F3 "EST" Picture "@!" Size 60, 10 Object oPERG
@ 18, 09 Say "Codigo do produto:" Size 54, 07

@ 45,035 BmpButton Type 1 Action LocaProd()
@ 45,072 BmpButton Type 2 Action ODLG:End()

Activate Dialog oDLG Centered
Return NIL



*******************
Static FUNCTION LocaProd()
*******************

Local nPOS

If ( nPos := Ascan( aCOLS, { |X| X[iCOD] == cPROD } ) ) == 0
	MsgBox( "Produto nao localizado nesta programacao", "Erro", "STOP" )
Else
	ODLG:End()
	N                := nPOS
	oBRW:oBROWSE:nAT := nPOS
	oBRW:lCHGFIELD   := .T.
	oBRW:oBROWSE:Refresh()
EndIf
Return NIL
	
	
	
***************
Static Function ValidPerg()
***************

PutSx1( cPERG, '01', 'Da data            ?', '', '', 'mv_ch1', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par01', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( cPERG, '02', 'Ate a data         ?', '', '', 'mv_ch2', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par02', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( cPERG, '03', 'Do produto         ?', '', '', 'mv_ch3', 'C', 15, 0, 0, 'G', '', 'SB1', '', '', 'mv_par03', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( cPERG, '04', 'Ate o produto      ?', '', '', 'mv_ch4', 'C', 15, 0, 0, 'G', '', 'SB1', '', '', 'mv_par04', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( cPERG, '05', 'Tipo Programação   ?', '', '', 'mv_ch5', 'N', 01, 0, 1, 'C', '', ''   , '', '', 'mv_par05', 'Carteira'    , '', '', '' ,'Media de Estoque', '', '', '', '', '', ''               , '', '', '', '', '', {}, {}, {} )
//PutSx1( cPERG, '05', 'Gerar por          ?', '', '', 'mv_ch5', 'N', 01, 0, 1, 'C', '', ''   , '', '', 'mv_par05', 'Carteira'       , '', '', '' ,'Financeiro'     , '', '', 'Media de vendas', '', '', ''               , '', '', '', '', '', {}, {}, {} )
//PutSx1( cPERG, '06', 'Dias de venda      ?', '', '', 'mv_ch6', 'N', 03, 0, 0, 'G', '', ''   , '', '', 'mv_par06', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
//PutSx1( cPERG, '07', 'Adic.prog.anterior ?', '', '', 'mv_ch7', 'C', 06, 0, 0, 'G', '', 'Z02', '', '', 'mv_par07', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
	
//PutSX1Help( 'P.' + cPERG + '01.', aHelpP01, aHelpE01, aHelpS01 )
Return NIL
	
	
******************
User function PDATIVO( cProd )
******************
	
local lOk := .T.
	
DbSelectArea("SB1")
DbSetOrder(1)
DBSeek( xFilial("SB1")+cProd )
if SB1->B1_ATIVO = "N"
	lOk := .F.
	Alert( "O produto informado está INATIVO, favor informar outro produto." )
endif
	
	
return lOk



************************
user function ABC500(aABC, cCliVip)
************************

Local nSeq
aABC    := {}
cCliVip := ""

//Curva ABC 50 Primeiros Clientes nos ultimos 6 meses
cQuery := "SELECT DISTINCT TOP 50  CLIENTE=D2_CLIENTE,NOME=A1_NOME, "
cQuery += "       QUANT=CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN 0 "
cQuery += "                ELSE SUM(D2_QUANT) END, "
cQuery += "       PESO=CASE WHEN D2_SERIE = '' AND F2_VEND1 NOT LIKE '%VD%' THEN CAST(0 AS FLOAT) "
cQuery += "                ELSE SUM(D2_QUANT*B1_PESOR) END, "
cQuery += "       CUSTO=SUM(D2_TOTAL/D2_QUANT), "
cQuery += "       VALOR=SUM(D2_TOTAL) "
cQuery += "FROM   "+RetSqlName("SD2")+" SD2 WITH (NOLOCK), "+RetSqlName("SB1")+" SB1 WITH (NOLOCK), "+RetSqlName("SA1")+" SA1 WITH (NOLOCK), "+RetSqlName("SA3")+" "
cQuery += "SA3 WITH (NOLOCK), "+RetSqlName("SF2")+" SF2 WITH (NOLOCK), "+RetSQlName("SBM")+" SBM WITH (NOLOCK) "
cQuery += "WHERE  D2_EMISSAO BETWEEN "+DtoS(dDataBase-180)+" AND "+DtoS(dDataBase)+" AND D2_FILIAL = '01' AND D2_TIPO = 'N' "
cQuery += "AND RTRIM(D2_COD) NOT IN ('187','188','189','190') "
cQuery += "AND RTRIM(D2_CF) IN ( '511','5101','611','6101','512','5102','612','6102','6109','6107','5949 ','6949' ) "
cQuery += "AND SD2.D_E_L_E_T_ = '' AND D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' AND D2_COD = B1_COD "
cQuery += "AND SB1.D_E_L_E_T_ = '' AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA AND F2_DUPL <> '' "
cQuery += "AND SF2.D_E_L_E_T_ = '' AND F2_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = '' AND SB1.B1_GRUPO = SBM.BM_GRUPO "
cQuery += "GROUP BY D2_CLIENTE,A1_NOME,A1_COD,D2_SERIE,F2_VEND1 "
cQuery += "ORDER BY PESO DESC "
TCQUERY cQuery NEW ALIAS "ABCX"

nSeq := 1
while !ABCX->(EOF())
   Aadd( aABC, { nSeq, ABCX->CLIENTE } )
   cCliVip += "'"+ABCX->CLIENTE+"'"
   nSeq++
   ABCX->(DbSkip())
   if !ABCX->(EOF())
      cCliVip += ","
   endif
end
ABCX->( DbCloseArea() )
aSort( aABC,,,{|x,y| x[2] < y[2]} ) 

return nil

***************
Static Function SldOPs( cProd )
***************

Local cQuery := ''
Local nTot := 0
//Local aArret := {}
//Local nTotNVIP := nTotVIP := 0

cQuery += "SELECT SC2.C2_NUM, SC2.C2_QUJE, SC2.C2_QUANT, SC2.C2_QTSEGUM, SC2.C2_QUANT - SC2.C2_QUJE AS QUANT, "
cQuery += "( SC2.C2_QUANT - SC2.C2_QUJE ) / SB1.B1_CONV AS PESO, SC2.C2_OPVIP "
cQuery += "FROM " + retSqlName('SC2') + " SC2, " + retSqlName('SB1') + " SB1 "
cQuery += "WHERE SC2.C2_PRODUTO = '" + cProd + "' AND SC2.C2_DATRF = '        ' AND "
cQuery += "SC2.C2_QUANT - SC2.C2_QUJE > 0  AND SC2.C2_PRODUTO = SB1.B1_COD AND "
cQuery += "SC2.C2_FILIAL = '" + xFilial('SC2') + "' AND SC2.D_E_L_E_T_ = ' ' AND "
cQuery += "SB1.B1_FILIAL = '" + xFilial('SB1') + "' AND SB1.D_E_L_E_T_ = ' ' "
TCQUERY cQuery NEW ALIAS "TMPZ"
TMPZ->( dbGoTop() )

While ! TMPZ->( EoF() )
//   if TMPZ->C2_OPVIP == 'S'
      nTot += TMPZ->PESO
//   else
//      nTotNVIP += TMPZ->PESO
//   endIf
   TMPZ->( dbSkip() )
end
TMPZ->( dbCloseArea() )
//aAdd(aArret, { nTotVIP, nTotNVIP } )

return nTot


*********************************
Static Function carteira( cProd )
*********************************

Local nCart := 0
Local cCart := ''
if( empty(mv_par02), Pergunte( cPERG, .T. ), )
cCart := "SELECT  "
cCart += "SUM( SC9.C9_QTDLIB ) AS QUANT "
cCart += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" ) + " SC6, " + RetSqlName( "SC9" ) + " SC9 "
cCart += "WHERE SC5.C5_EMISSAO BETWEEN '" + Dtos( mv_par01 ) + "' AND '" + Dtos( mv_par02 ) + "' AND "
//Nao considera pedidos Programados
cCart += "SC5.C5_ENTREG <= '"+ dtos( lastday( dDataBase ) ) + "' AND "
cCart += "SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_PRODUTO = SB1.B1_COD AND "
cCart += "SC6.C6_PRODUTO = '"+cProd+"' AND "
cCart += "SC6.C6_BLQ <> 'R' AND SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC9.C9_ITEM AND "
cCart += "SC9.C9_BLCRED = '  ' AND SC9.C9_BLEST <> '10' AND SB1.B1_TIPO = 'PA' AND SC5.C5_TIPO <> 'B' AND "
cCart += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cCart += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cCart += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cCart += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "
TCQUERY cCart NEW ALIAS "CARX"

/*TCSetField( 'SC5X', "VALOR", "N", 12, 2 )
TCSetField( 'SC5X', "PESO", "N", 10, 4 )
TCSetField( 'SC5X', "QUANT", "N", 10, 4 )
TCSetField( 'SC5X', "C5_EMISSAO", "D" )*/

CARX->( dbGoTop() )

if !CARX->( EoF() )
   nCart := CARX->QUANT
endIf
CARX->( dbCloseArea() )

return nCart


//Retorna quantidade de dias de Estoque 
//com base nas vendas dos ultimos 6 meses
*******************************
Static Function DiasEst( cCod1 )
*******************************

Local cQuery, cCod2
Local nEst

if Len( AllTrim( cCod1 ) ) <= 7
   cCod2 := Padr( Subs( cCod1, 1, 1 ) + "D" + Subs( cCod1, 2, If( Subs( cCod1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cCod1, If( Subs( cCod1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
else
   cCod2 := Padr( Subs( cCod1, 1, 1 ) + Subs( cCod1, 3, If( Subs( cCod1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cCod1, If( Subs( cCod1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
endif

cQuery := "SELECT SUM( SD2.D2_QUANT ) AS VENDAS "
cQuery += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE SD2.D2_COD IN ( '"+cCod1+"', '"+cCod2+"' ) AND "
cQuery += "(SD2.D2_EMISSAO >= '"+Dtos(dDataBase-180)+"' AND SD2.D2_EMISSAO <= '"+Dtos(dDataBase)+"') AND "
cQuery += "SD2.D2_COD = SB1.B1_COD AND "
cQuery += "SB1.B1_TIPO = 'PA' AND "
cQuery += "SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND SD2.D_E_L_E_T_ = ' ' AND "
cQuery += "SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ = ' ' "

TCQUERY cQuery NEW ALIAS "TMX"
DbSelectArea("TMX")

DbSelectArea("SB2")
DbSetOrder(1)
SB2->(DbSeek(xFilial("SB2")+cCod1+"01" ))

nDias := ( ( SB2->B2_QATU ) * 30 ) / ( TMX->VENDAS / 6 ) 
nDias := iif( nDias >= 0, nDias, 0 )

TMX->(DbCloseArea())

Return nDias


//Retorna quantidade do Produto para os dias 
//com base nas vendas dos ultimos 6 meses
*******************************
Static Function EstDias( cCod1, nDias, nQtd )
*******************************

Local cQuery, cCod2
Local nQuant

Default nDias := -1
Default nQtd  := -1

if Len( AllTrim( cCod1 ) ) <= 7
   cCod2 := Padr( Subs( cCod1, 1, 1 ) + "D" + Subs( cCod1, 2, If( Subs( cCod1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cCod1, If( Subs( cCod1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
else
   cCod2 := Padr( Subs( cCod1, 1, 1 ) + Subs( cCod1, 3, If( Subs( cCod1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cCod1, If( Subs( cCod1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
endif

cQuery := "SELECT SUM( SD2.D2_QUANT ) AS VENDAS "
cQuery += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE SD2.D2_COD IN ( '"+cCod1+"', '"+cCod2+"' ) AND "
cQuery += "(SD2.D2_EMISSAO >= '"+Dtos(dDataBase-180)+"' AND SD2.D2_EMISSAO <= '"+Dtos(dDataBase)+"') AND "
cQuery += "SD2.D2_COD = SB1.B1_COD AND "
cQuery += "SB1.B1_TIPO = 'PA' AND "
cQuery += "SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND SD2.D_E_L_E_T_ = ' ' AND "
cQuery += "SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ = ' ' "

TCQUERY cQuery NEW ALIAS "TMX"
DbSelectArea("TMX")

if nDias > -1
   nQuant := ( nDias * ( TMX->VENDAS / 6 ) ) / 30
endif   

if nQtd > -1
   nQuant := ( nQtd * 30 ) / ( TMX->VENDAS / 6 )
endif   

nQuant := iif( nQuant >= 0, nQuant, 0 )

TMX->(DbCloseArea())

Return nQuant

***************

Static Function arredonda( nValor )

***************

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local   nVar1  := SB1->B1_PSMNBOB - nValor
Private nRet := nVar1
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oGet1","oBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1 := MSDialog():New( 257,478,338,800,"Arredonde a quantidade",,,.F.,,,,,,.T.,,,.T. )
oGrp1 := TGroup():New( 000,002,037,157,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGet1 := TGet():New( 008,049,,oGrp1,060,008,'@E 999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nVar1",, )
oGet1:bSetGet := { |u| If(PCount()>0,nVar1:=u,nVar1) }
oGet1:bValid  := { || ValidCampo(nVar1, nValor) }
oBtn1 := TButton():New( 021,061,"&Ok",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := { || oDlg1:End() }
//oBtn1:bValid  := { || ValidCampo(nVar1, nValor) } Retirado a pedido de Lindenberg 21/11/08

oDlg1:Activate(,,,.T.)

Return nRet

***************

Static Function ValidCampo(nVar1, nValor)

***************

if ( ( nVar1 + nValor )%SB1->B1_PSMNBOB ) > 0
	msgAlert("O valor digitado "+alltrim(transform(nVar1,"@E 999,999.99"))+" não atinge o mínimo para uma bobina!")
	nRet := 0
	return .F.
else
	nRet := nVar1
	return .T.
endIf

Return

***************

Static Function updCampos()

***************

IF ! Empty( aCols[ n, iNUMOP ] )
	MsgBox ( "Nao e permitido alterar programacao de produto com OP ja gerada", "Erro", "STOP" )
	Return .F.
EndIF
SB1->( DbSeek( Xfilial( "SB1" ) + aCols[ n, iCOD ] ) )
aCols[ n, iQTDOPM ] := M->Z03_QTDOP * SB1->B1_CONV
aCols[ n, iSOBRA  ] := If( ( M->Z03_QTDOP * SB1->B1_CONV ) > 0, ( M->Z03_QTDOP * SB1->B1_CONV ) - aCols[ n, iQTSUGM ], 0 )
aCols[ n, iDIAS   ] := EstDias( aCols[ n, iCOD ],, aCols[ n, iQTDOPM ] )
CalcProg( .T., aCols[ n, iQTDOP ], M->Z03_QTDOP )
CalcSobr( .T. )

Return