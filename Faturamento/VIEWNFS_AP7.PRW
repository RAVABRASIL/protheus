#Include "RwMake.ch"
#Include "font.ch"
#Include "colors.ch"
#Include "topconn.ch"

*********************
User Function ViewNFS()
*********************

SetPrvt( "nCONT, nTOLERA, aIMP, nPESO, cOP, oMAQ, nQUANT, cPORTA, nSACOS, oSACOS, lINCOMP, nHandle, aUSUARIO, aUSUARI2, oTIPO, cTIPO, aTIPO, " )
SetPrvt( "nQTDLIB, cUSULIM, nLIMITE, cSEQ, cNOMUSUA," )

Private cRegRed := ""

DEFINE FONT oFont NAME "Courier New" SIZE 6, 19 BOLD //6, 20//0, -128
DEFINE FONT oFontOP NAME "Arial" SIZE 17, 31 BOLD //6, 20//0, -128
DEFINE FONT oFontDes NAME "Arial" SIZE 7, 30 BOLD //6, 20//0, -128
DEFINE FONT oFontTit NAME "Arial" SIZE 0, 14 BOLD //6, 20//0, -128
DEFINE FONT oFontNum NAME "Arial" SIZE 0, 25 BOLD //6, 20//0, -128

//Local oDlg,oGrp1,oGrp2,oGrp3,oSayOP,oGetOP,oSayMaq,oGetMaq,oSayQFD,oGetQFD,oSayPKG01,oSayPKG02,oChkINC,oSayQSac,oGetQSac,oSBtnLer,oSBtnReimp,oSBtnCanc,oSayTit01,oSayReg01,oSayReg02,oSayReg03,oSayReg04,oSayReg05,oSayReg06,oSayReg07,oSayReg08,oSayReg09,oSayReg10,oSayReg11,oSayReg12,oSayReg13,oSayReg14,oSayReg15,oSayReg16,oSayReg17,oSayReg18,oSayReg19,oSayReg20,oSayReg21,oSayReg22,oSayReg23,oSayReg24,oSayReg25,oSayReg26,oSayReg27,oSayTit02,oSayReg28,oSayReg29,oSayReg30,oSayReg31,oSayReg32,oSayReg33,oSayReg34,oSayReg35,oSayReg36,oSayReg37,oSayReg38,oSayReg39,oGrp4,oSayINFO01,oSayINFO02,oSayINFO03,oSayPESADA,oSayPROCES,oSayREST,oSayINFO04,oSayINFO05,oSayINFO06

latua		:= .T.
cOP	  	:= Space( 11 )
cMAQ		:= Space( 06 )
//nQUANT	:= 1
cProduto	:= Nil
cDescric	:= Nil
//lIncomp	:= .F.
//nSACOS	:= 0

//nTOLERA := Getmv( "MV_PESOTOL" )
//nLIMITE := GetMv( "MV_LIMAXOP" )
//SC2->( DbSetOrder( 1 ) )
//SB1->( DbSetOrder( 1 ) )
//SB5->( DbSetOrder( 1 ) )
//SH1->( DbSetOrder( 1 ) )
//SG1->( DbSetOrder( 1 ) )
//Z00->( DbSetOrder( 1 ) )
aIMP      := {}
aUSUARIO  := {}
aUSUARI2  := {}

oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Conferencia Nota Fiscal de Saida"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 800
oDlg:nHeight := 600
oDlg:lShowHint := .F.
oDlg:lCentered := .T.

oGrp1 := TGROUP():Create(oDlg)
oGrp1:cName := "oGrp1"
oGrp1:nLeft := 5
oGrp1:nTop := 5
oGrp1:nWidth := 390
oGrp1:nHeight := 565
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oGrp2 := TGROUP():Create(oDlg)
oGrp2:cName := "oGrp2"
oGrp2:nLeft := 400
oGrp2:nTop := 5
oGrp2:nWidth := 390
oGrp2:nHeight := 272
oGrp2:lShowHint := .F.
oGrp2:lReadOnly := .F.
oGrp2:Align := 0
oGrp2:lVisibleControl := .T.

oGrp3 := TGROUP():Create(oDlg)
oGrp3:cName := "oGrp3"
oGrp3:nLeft := 400
oGrp3:nTop := 433
oGrp3:nWidth := 390
oGrp3:nHeight := 136
oGrp3:lShowHint := .F.
oGrp3:lReadOnly := .F.
oGrp3:Align := 0
oGrp3:lVisibleControl := .T.

oSayOP := TSAY():Create(oDlg)
oSayOP:cName := "oSayOP"
oSayOP:cCaption := "&NF :"
oSayOP:nLeft := 406
oSayOP:nTop := 445
oSayOP:nWidth := 25
oSayOP:nHeight := 17
oSayOP:lShowHint := .F.
oSayOP:lReadOnly := .F.
oSayOP:Align := 0
oSayOP:lVisibleControl := .T.
oSayOP:lWordWrap := .F.
oSayOP:lTransparent := .F.

oGetOP := TGET():Create(oDlg)
oGetOP:cF3 := "SF2"
oGetOP:cName := "oGetOP"
oGetOP:cCaption := cOP//"01289901001"
oGetOP:nLeft := 435
oGetOP:nTop := 442
oGetOP:nWidth := 93
oGetOP:nHeight := 21
oGetOP:lShowHint := .F.
oGetOP:lReadOnly := .F.
oGetOP:Align := 0
oGetOP:lVisibleControl := .T.
oGetOP:lPassword := .F.
oGetOP:lHasButton := .F.
oGetOP:Picture := "@!"
oGetOP:bValid := {|| PesqNF( cOP )}
oGetOP:bSetGet := {|u| If(PCount()>0,cOP:=u,cOP) }

oSBtnLer := TBUTTON():Create(oDlg)
oSBtnLer:cName := "oSBtnLer"
oSBtnLer:cCaption := "Ler balanca"
oSBtnLer:nLeft := 412
oSBtnLer:nTop := 536
oSBtnLer:nWidth := 80//53
oSBtnLer:nHeight := 30//23
oSBtnLer:lShowHint := .F.
oSBtnLer:lReadOnly := .F.
oSBtnLer:Align := 0
oSBtnLer:lVisibleControl := .T.
//oSBtnLer:nType := 1
oSBtnLer:bLClicked := {|| Pegar() }
//oSBtnLer:bLClicked := {|| AtuRegs() }

//oSBtnReimp := SBUTTON():Create(oDlg)
oSBtnReimp := TBUTTON():Create(oDlg)
oSBtnReimp:cName := "oSBtnReimp"
oSBtnReimp:cCaption := "Reimprimir"
oSBtnReimp:nLeft := 564
oSBtnReimp:nTop := 536
oSBtnReimp:nWidth := 80//52
oSBtnReimp:nHeight := 30//22
oSBtnReimp:lShowHint := .F.
oSBtnReimp:lReadOnly := .F.
oSBtnReimp:Align := 0
oSBtnReimp:lVisibleControl := .T.
//oSBtnReimp:nType := 5
oSBtnReimp:bLClicked := {|| Reimprime() }

oSBtnCanc := SBUTTON():Create(oDlg)
oSBtnCanc:cName := "oSBtnCanc"
oSBtnCanc:cCaption := "Cancelar"
oSBtnCanc:nLeft := 703
oSBtnCanc:nTop := 536
oSBtnCanc:nWidth := 52
oSBtnCanc:nHeight := 22
oSBtnCanc:lShowHint := .F.
oSBtnCanc:lReadOnly := .F.
oSBtnCanc:Align := 0
oSBtnCanc:lVisibleControl := .T.
oSBtnCanc:nType := 2
oSBtnCanc:bLClicked := {|| Close(oDlg) }

oSayTit01 := TSAY():Create(oDlg)
oSayTit01:cName := "oSayTit01"
oSayTit01:cCaption := "Item Produto     Descricao            Quantidade Status       "
oSayTit01:nLeft := 13
oSayTit01:nTop := 10
oSayTit01:nWidth := 372
oSayTit01:nHeight := 17
oSayTit01:lShowHint := .F.
oSayTit01:lReadOnly := .F.
oSayTit01:Align := 0
oSayTit01:lVisibleControl := .T.
oSayTit01:lWordWrap := .F.
oSayTit01:lTransparent := .F.
oSayTit01:SetFont( oFont )

nToplbl  := 30
nLeftlbl := 13
for nX := 1 to 39
	cSay := StrZero(nX,2)
	
	oSayReg&cSay := TSAY():Create(oDlg)
	oSayReg&cSay:cName := "oSayReg"+cSay
//                           "Item Produto     Descricao            Quantidade          "
	oSayReg&cSay:cCaption := "0001 AAA145      SACO PLASTICO        999.999,99          "
    if nX = 28 
       nLeftlbl := 407 
       nToplbl := 30
	endif
	oSayReg&cSay:nLeft := nLeftlbl
	oSayReg&cSay:nTop := nToplbl
	oSayReg&cSay:nWidth := 378
	oSayReg&cSay:nHeight := 17
	oSayReg&cSay:lShowHint := .F.
	oSayReg&cSay:lReadOnly := .F.
	oSayReg&cSay:Align := 0
	oSayReg&cSay:lVisibleControl := .T.
	oSayReg&cSay:lWordWrap := .F.
	oSayReg&cSay:lTransparent := .F.
	oSayReg&cSay:SetFont( oFont )
	nToplbl += 20
next nX

oSayTit02 := TSAY():Create(oDlg)
oSayTit02:cName := "oSayTit02"
oSayTit02:cCaption := "Item Produto     Descricao            Quantidade Status   "
oSayTit02:nLeft := 407
oSayTit02:nTop := 10
oSayTit02:nWidth := 372
oSayTit02:nHeight := 17
oSayTit02:lShowHint := .F.
oSayTit02:lReadOnly := .F.
oSayTit02:Align := 0
oSayTit02:lVisibleControl := .T.
oSayTit02:lWordWrap := .F.
oSayTit02:lTransparent := .F.
oSayTit02:SetFont( oFont )

oGrp4 := TGROUP():Create(oDlg)
oGrp4:cName := "oGrp4"
oGrp4:nLeft := 400
oGrp4:nTop := 282
oGrp4:nWidth := 390
oGrp4:nHeight := 146
oGrp4:lShowHint := .F.
oGrp4:lReadOnly := .F.
oGrp4:Align := 0
oGrp4:lVisibleControl := .T.

oSayINFO01 := TSAY():Create(oDlg)
oSayINFO01:cName := "oSayINFO01"
oSayINFO01:cCaption := cOP //"OP: 012899 - DDAR021"
oSayINFO01:nLeft := 405
oSayINFO01:nTop := 290
oSayINFO01:nWidth := 382 //350
oSayINFO01:nHeight := 47
oSayINFO01:lShowHint := .F.
oSayINFO01:lReadOnly := .F.
oSayINFO01:Align := 0
oSayINFO01:lVisibleControl := .T.
oSayINFO01:lWordWrap := .F.
oSayINFO01:lTransparent := .F.
oSayINFO01:SetFont( oFontOP )
oSayINFO01:nClrText := CLR_HRED

oSayINFO03 := TSAY():Create(oDlg)
oSayINFO03:cName := "oSayINFO03"
oSayINFO03:cCaption := cDescric //"SACO D. LIMPEZA AZUL 100L 75X105 MEDIO ROLO P"
oSayINFO03:nLeft := 407 //474
oSayINFO03:nTop := 330
oSayINFO03:nWidth := 381
oSayINFO03:nHeight := 25
oSayINFO03:lShowHint := .F.
oSayINFO03:lReadOnly := .F.
oSayINFO03:Align := 0
oSayINFO03:lVisibleControl := .T.
oSayINFO03:lWordWrap := .F.
oSayINFO03:lTransparent := .F.
oSayINFO03:SetFont( oFontDes )
oSayINFO03:nClrText := CLR_HRED

oSayPESADA := TSAY():Create(oDlg)
oSayPESADA:cName := "oSayPESADA"
oSayPESADA:cCaption := "QTD. PESADA :"
oSayPESADA:nLeft := 408
oSayPESADA:nTop := 377
oSayPESADA:nWidth := 82
oSayPESADA:nHeight := 17
oSayPESADA:lShowHint := .F.
oSayPESADA:lReadOnly := .F.
oSayPESADA:Align := 0
oSayPESADA:lVisibleControl := .T.
oSayPESADA:lWordWrap := .F.
oSayPESADA:lTransparent := .F.
oSayPESADA:SetFont( oFontTit )
oSayPESADA:nClrText := CLR_RED

oSayPROCES := TSAY():Create(oDlg)
oSayPROCES:cName := "oSayPROCES"
oSayPROCES:cCaption := "TOTAL PESADO :"
oSayPROCES:nLeft := 536
oSayPROCES:nTop := 377
oSayPROCES:nWidth := 96
oSayPROCES:nHeight := 17
oSayPROCES:lShowHint := .F.
oSayPROCES:lReadOnly := .F.
oSayPROCES:Align := 0
oSayPROCES:lVisibleControl := .T.
oSayPROCES:lWordWrap := .F.
oSayPROCES:lTransparent := .F.
oSayPROCES:SetFont( oFontTit )
oSayPROCES:nClrText := CLR_BLUE

oSayREST := TSAY():Create(oDlg)
oSayREST:cName := "oSayREST"
oSayREST:cCaption := "QTD. RESTANTE DA OP :"
oSayREST:nLeft := 657
oSayREST:nTop := 377
oSayREST:nWidth := 128
oSayREST:nHeight := 17
oSayREST:lShowHint := .F.
oSayREST:lReadOnly := .F.
oSayREST:Align := 0
oSayREST:lVisibleControl := .T.
oSayREST:lWordWrap := .F.
oSayREST:lTransparent := .F.
oSayREST:SetFont( oFontTit )
oSayREST:nClrText := CLR_GREEN

oSayINFO04 := TSAY():Create(oDlg)
oSayINFO04:cName := "oSayINFO04"
oSayINFO04:cCaption := "0 FDs"
oSayINFO04:nLeft := 408
oSayINFO04:nTop := 393
oSayINFO04:nWidth := 101
oSayINFO04:nHeight := 25
oSayINFO04:lShowHint := .F.
oSayINFO04:lReadOnly := .F.
oSayINFO04:Align := 0
oSayINFO04:lVisibleControl := .T.
oSayINFO04:lWordWrap := .F.
oSayINFO04:lTransparent := .F.
oSayINFO04:SetFont( oFontNum )
oSayINFO04:nClrText := CLR_RED

oSayINFO05 := TSAY():Create(oDlg)
oSayINFO05:cName := "oSayINFO05"
oSayINFO05:cCaption := "0 FDs"
oSayINFO05:nLeft := 536
oSayINFO05:nTop := 393
oSayINFO05:nWidth := 97
oSayINFO05:nHeight := 25
oSayINFO05:lShowHint := .F.
oSayINFO05:lReadOnly := .F.
oSayINFO05:Align := 0
oSayINFO05:lVisibleControl := .T.
oSayINFO05:lWordWrap := .F.
oSayINFO05:lTransparent := .F.
oSayINFO05:SetFont( oFontNum )
oSayINFO05:nClrText := CLR_BLUE

oSayINFO06 := TSAY():Create(oDlg)
oSayINFO06:cName := "oSayINFO06"
oSayINFO06:cCaption := "0,00 FDs"
oSayINFO06:nLeft := 659
oSayINFO06:nTop := 393
oSayINFO06:nWidth := 124
oSayINFO06:nHeight := 25
oSayINFO06:lShowHint := .F.
oSayINFO06:lReadOnly := .F.
oSayINFO06:Align := 0
oSayINFO06:lVisibleControl := .T.
oSayINFO06:lWordWrap := .F.
oSayINFO06:lTransparent := .F.
oSayINFO06:SetFont( oFontNum )
oSayINFO06:nClrText := CLR_GREEN

oDlg:Activate()

Return


***************

Static Function PesqNF()

***************

lRET := .T.

If "REIMP" $ Upper( oDlg:oCtlFocus:ccaption )
	Return lRET
EndIf

DBSelectArea("SF2")

SF2->( DbSeek( xFilial( "SF2" ) + cOP, .T. ) )

	
Atualiza( cOP )
	
Return lRET




***************

Static Function Incomp()

***************

If lINCOMP
	oSayQSac:lVisibleControl := .T.
	ObjectMethod( oSayQSac, "Refresh()" )
	oGetQSac:lVisibleControl := .T.
	ObjectMethod( oGetQSac, "Refresh()" )
	ObjectMethod( oGetQSac, "SetFocus()" )
ElseIf ! lINCOMP
	oSayQSac:lVisibleControl := .F.
	ObjectMethod( oSayQSac, "Refresh()" )
	oGetQSac:lVisibleControl := .F.
	ObjectMethod( oGetQSac, "Refresh()" )
EndIf

Return .T.



***************
Static Function Atualiza(cOP)
***************

Public nTotNPes := 0
nTotaPes := nRestOP := nPrdTur1 := nPrdTur2 := nPrdTur3A := nPrdTur3B := nPrdTur3C := 0
cHora := cQuery01 := cQuery02 := cQuery03 := Nil

cOPtmp := cOP

cDataAtu 	:= DtoS( Date() )
cDataAnt 	:= DtoS( Date() - 1 )
cHora			:= Time()

Colora( 1 )

	cQuery01 := "SELECT Z00.Z00_OP, Z00.Z00_HORA, Z00.Z00_DATA FROM " + RetSqlName( "Z00" ) + " Z00 "
	cQuery01 += "WHERE Z00.Z00_OP = '" + cOPtmp + "' AND Z00.Z00_QUANT > 0 AND Z00.Z00_HORA BETWEEN '05:35' AND '13:54' "
	cQuery01 += "AND Z00.Z00_DATA = '" + cDataAtu + "' "
	cQuery01 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
	cQuery01 += "ORDER BY Z00.Z00_DATA, Z00.Z00_HORA "
	cQuery01 := ChangeQuery( cQuery01 )
	TCQUERY cQuery01 NEW ALIAS "Z00W"
	Z00W->( DBGoTop() )
	
	While ! Z00W->( EoF() )
		nPrdTur1 ++
		Z00W->( DbSkip() )
	End
	
	Z00W->( DbCloseArea() )
	

cQuery05 := "SELECT * FROM " + RetSqlName( "Z00" ) + " Z00 "
cQuery05 += "WHERE Z00.Z00_OP = '" + cOPtmp + "' AND Z00.Z00_QUANT > 0 "
cQuery05 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQuery05 := ChangeQuery( cQuery05 )
TCQUERY cQuery05 NEW ALIAS "Z00V"

While ! Z00V->( EoF() )
	nTotaPes ++
	Z00V->( DbSkip() )
End

Z00V->( DbCloseArea() )

SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )

oSayINFO05:cCaption :=  Alltrim( Str( nTotaPes ) + " FDs" )
ObjectMethod( oSayINFO05, "Refresh()" )

cQuery06 := "SELECT * FROM " + RetSqlName( "Z00" ) + " Z00 "
cQuery06 += "WHERE Z00.Z00_OP = '" + cOPtmp + "' AND Z00.Z00_QUANT > 0 AND Z00.Z00_BAIXA = 'N' "
cQuery06 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQuery06 := ChangeQuery( cQuery06 )
TCQUERY cQuery06 NEW ALIAS "Z00U"

While ! Z00U->( EoF() )
	nTotNPes ++
	Z00U->( DbSkip() )
End

Z00U->( DbCloseArea() )

nRestOP := Iif( ( ( SC2->C2_QUANT - SC2->C2_QUJE ) / ( SB5->B5_QTDFIM / SB5->B5_QE2 ) ) - nTotNPes < 0, 0, ( ( SC2->C2_QUANT - SC2->C2_QUJE ) / ;
( SB5->B5_QTDFIM / SB5->B5_QE2 ) ) - nTotNPes )
oSayINFO06:cCaption := Alltrim( Str( Round( nRestOP, 2 ) ) + " FDs" )
ObjectMethod( oSayINFO06, "Refresh()" )

cProduto := SC2->C2_PRODUTO
oSayINFO01:cCaption := "OP: " + Substr( cOP, 1, 6 ) + " - " + Alltrim( cProduto )
ObjectMethod( oSayINFO01, "Refresh()" )

cDescric := SB1->B1_DESC
oSayINFO03:cCaption := Alltrim( cDescric )
ObjectMethod( oSayINFO03, "Refresh()" )

Return Nil


***************
Static Function AtuPeso()
***************

ObjectMethod( oSayINFO04, "SetText( Alltrim( Str( nQUANT, 0 ) + ' FDs' ) )" )

Return Nil


***************
Static Function AtuRegs()
***************

Local X := nBranco := Nil
Local lBranco := .T.
Local cSAY	:= cRegRed := cXTmp := cEmBranc := ""

Colora( 2 )

FOR X := 1 TO 39
	
	cXTmp := StrZero( X, 2 )
	IF oSayReg&cXTmp:cCaption == "" .AND. lBranco == .T.
		lBranco := .F.
		cEmBranc := StrZero( X, 2 )
		IF cEmBranc == "01"
			Exit
		ENDIF
	ENDIF
	
	IF Alltrim( Substr( oSayReg&cXTmp:cCaption, 10, 10 ) ) $ Substr( cOP, 1, 6 )
		IF oSayReg&cXTmp:nClrText == CLR_WHITE
			cSAY := cRegRed := StrZero( X, 2 )
			Exit
		Else
			cSAY := StrZero( X, 2 )
		ENDIF
	EndIf
	
	If oSayReg&cXTmp:nClrText == CLR_WHITE
		cRegRed := StrZero( X, 2 )
	ENDIF
	
NEXT

IF cSAY <> ""
	ModReg( cSAY, cRegRed, cOP )
ElseIf cSAY == "" .AND. cRegRed <> "" .AND. cEmBranc <> "01" .AND. cEmBranc <> ""
	ModReg( cEmBranc, cRegRed, cOP )
ElseIf cSAY == "" .AND. cRegRed == "" .AND. cEmBranc == "01"
	ModReg( "01", "01", cOP )
ElseIf cSAY == "" .AND. cRegRed <> "" .AND. cEmBranc == ""
	Reorgan()
ENDIF


Return Nil


***************
Static Function Reorgan()
***************

local nTmpX := sSAY := ""

For X := 39 to 2 step -1
	cSAY	:= StrZero( X, 2 )
	cTmpX := StrZero( X - 1, 2 )
	oSayReg&cSAY:cCaption := oSayReg&cTmpX:cCaption
	ObjectMethod( oSayReg&cSAY, "Refresh()" )
	IF oSayReg&cSAY:nClrText == CLR_WHITE
		cRegRed := StrZero( X, 2 )
	ENDIF
Next
ModReg( "01", cRegRed, cOP )
//cRegRed := "01"

Return Nil


***************
Static Function ModReg(cSAYM, cRegRedM, cOP)
***************

SC2->( Dbseek( xFilial( "SC2" ) + Substr( cOP, 1, 6 ) ) )
cNewReg := Left( SC2->C2_PRODUTO, 7 ) + Space( 5 ) + Alltrim( SC2->C2_NUM ) + Space( 4 ) + Alltrim( SC2->C2_RECURSO ) + Space( 3 ) + ;
PADR( Transform( SC2->C2_QUANT, "@E 9,999.99" ), 8 ) + Space( 1 ) + Alltrim( SC2->C2_UM ) + ;//+ Space( 2 ) + ;
Iif( ( SC2->C2_QUANT - SC2->C2_QUJE ) - nTotNPes < 0, Space( 5 ) + "00,00", Space( 2 ) + PADR( Transform( ( SC2->C2_QUANT - SC2->C2_QUJE ) - nTotNPes, "@E 9,999.99" ), 8 ) ) + ;
Space( 1 ) + Alltrim( SC2->C2_UM ) + Space( 3 ) + CalcTurn(cOP) + Space( 1 ) + "FDs"
ObjectMethod( oSayReg&cSAYM, "SetText( cNewReg )" )
ObjectMethod( oSayReg&cSAYM, "SetColor( " +  str( CLR_WHITE ) + ", " + str( CLR_GRAY ) + ", " + str( CLR_WHITE ) +" )" )
If cRegRedM <> "" .AND. cRegRedM <> cSAYM// .AND. cRegRed <> "01"// .OR. nTmpX <> ""
	ObjectMethod( oSayReg&cRegRedM, "SetColor( " +  str( CLR_BLACK ) + ", " + str( CLR_WHITE ) + ", " + str( CLR_WHITE ) +" )" )
EndIf

Return Nil

***************
Static Function Colora( nOpcao )
***************

Local nOpTmp := nOpcao

IF nOpTmp == 1
	oSayINFO01:nClrText 	:= CLR_HRED		//OP - Produto
	ObjectMethod( oSayINFO01, "Refresh()" )
	oSayINFO03:nClrText 	:= CLR_HRED		//Descricao do Produto
	ObjectMethod( oSayINFO03, "Refresh()" )
	oSayPESADA:nClrText 	:= CLR_RED		//Qtd Pesada
	ObjectMethod( oSayPESADA, "Refresh()" )
	oSayINFO04:nClrText 	:= CLR_RED		//Valor da Qtd Pesada
	ObjectMethod( oSayINFO04, "Refresh()" )
	oSayPROCES:nClrText 	:= CLR_BLUE		//Total Pesado
	ObjectMethod( oSayPROCES, "Refresh()" )
	oSayINFO05:nClrText 	:= CLR_BLUE		//Valor do Total Pesado
	ObjectMethod( oSayINFO05, "Refresh()" )
	oSayREST:nClrText 	:= CLR_GREEN	//Rest. da OP
	ObjectMethod( oSayREST, "Refresh()" )
	oSayINFO06:nClrText 	:= CLR_GREEN	//Valor do Rest. da OP
	ObjectMethod( oSayINFO06, "Refresh()" )
Else
	oSayINFO01:nClrText 	:= CLR_LIGHTGRAY		//OP - Produto
	ObjectMethod( oSayINFO01, "Refresh()" )
	oSayINFO03:nClrText 	:= CLR_LIGHTGRAY		//Descricao do Produto
	ObjectMethod( oSayINFO03, "Refresh()" )
	oSayPESADA:nClrText 	:= CLR_LIGHTGRAY		//Qtd Pesada
	ObjectMethod( oSayPESADA, "Refresh()" )
	oSayINFO04:nClrText 	:= CLR_LIGHTGRAY		//Valor da Qtd Pesada
	ObjectMethod( oSayINFO04, "Refresh()" )
	oSayPROCES:nClrText 	:= CLR_LIGHTGRAY		//Total Pesado
	ObjectMethod( oSayPROCES, "Refresh()" )
	oSayINFO05:nClrText 	:= CLR_LIGHTGRAY		//Valor do Total Pesado
	ObjectMethod( oSayINFO05, "Refresh()" )
	oSayREST:nClrText 	:= CLR_LIGHTGRAY	//Rest. da OP
	ObjectMethod( oSayREST, "Refresh()" )
	oSayINFO06:nClrText 	:= CLR_LIGHTGRAY	//Valor do Rest. da OP
	ObjectMethod( oSayINFO06, "Refresh()" )
ENDIF

Return Nil
