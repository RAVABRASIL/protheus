#Include "RwMake.ch"
#include "font.ch"
#include "colors.ch"

User Function MONMAQ_TL1()

DEFINE FONT oFont1 NAME "Arial" SIZE 0, 16 BOLD
DEFINE FONT oFont2 NAME "Courier New" SIZE 0, 18 BOLD
DEFINE FONT oFont3 NAME "Arial" SIZE 0, 16 BOLD UNDERLINE

oDlg1           := MSDIALOG():Create()
oDlg1:cName     := "oDlg1"
oDlg1:cCaption  := "Situacao atual da producao - Dia: " + Dtoc( If( Time() < Left( cTURNO1, 5 ) + ":00", dDATABASE - 1, dDATABASE ) )
oDlg1:nLeft     := 0
oDlg1:nTop      := 0
oDlg1:nWidth    := 800
oDlg1:nHeight   := 600
oDlg1:lShowHint := .F.
oDlg1:lCentered := .T.

nLIN := 5
nCOL := 5
For nCONT := 1 To 6
		cCONT := StrZero( nCONT, 2 )
		nSAY  := 1

		oBmp&cCONT := TBITMAP():Create(oDlg1)
		oBmp&cCONT:cName := "oBmp&cCONT"
		oBmp&cCONT:nLeft := nCOL - 2
		oBmp&cCONT:nTop := nLIN + 2
		oBmp&cCONT:nWidth := 265
		oBmp&cCONT:nHeight := 275
		oBmp&cCONT:lShowHint := .F.
		oBmp&cCONT:lReadOnly := .F.
		oBmp&cCONT:Align := 0
		oBmp&cCONT:lVisibleControl := .T.
		oBmp&cCONT:cBmpFile := "MAQ" + cCONT + ".BMP"
		oBmp&cCONT:lStretch := .F.
		oBmp&cCONT:lAutoSize := .F.
/*
		oGRP&cCONT                 := TGROUP():Create(oDlg1)
		oGrp&cCONT:cName           := "oGrp" + cCONT
		oGrp&cCONT:nLeft           := nCOL
		oGrp&cCONT:nTop            := nLIN
		oGrp&cCONT:nWidth          := 251
		oGrp&cCONT:nHeight         := 275
		oGrp&cCONT:lShowHint       := .F.
		oGrp&cCONT:lReadOnly       := .F.
		oGrp&cCONT:Align           := 0
		oGrp&cCONT:lVisibleControl := .T.
*/
		cSAY := cCONT + StrZero( nSAY++, 3 )
/*
		oGRP&cSAY                 := TGROUP():Create(oDlg1)
		oGrp&cSAY:cName           := "oGrp" + cSAY
		oGrp&cSAY:nLeft           := nCOL
		oGrp&cSAY:nTop            := nLIN + 150
		oGrp&cSAY:nWidth          := 125
		oGrp&cSAY:nHeight         := 66
		oGrp&cSAY:lShowHint       := .F.
		oGrp&cSAY:lReadOnly       := .F.
		oGrp&cSAY:Align           := 0
		oGrp&cSAY:lVisibleControl := .T.
*/
		cSAY := cCONT + StrZero( nSAY++, 3 )
/*
		oGRP&cSAY                 := TGROUP():Create(oDlg1)
		oGrp&cSAY:cName           := "oGrp" + cSAY
		oGrp&cSAY:nLeft           := nCOL + 123
		oGrp&cSAY:nTop            := nLIN + 150
		oGrp&cSAY:nWidth          := 128
		oGrp&cSAY:nHeight         := 66
		oGrp&cSAY:lShowHint       := .F.
		oGrp&cSAY:lReadOnly       := .F.
		oGrp&cSAY:Align           := 0
		oGrp&cSAY:lVisibleControl := .T.
*/
		cSAY := cCONT + StrZero( nSAY++, 3 )
/*
		oGRP&cSAY                 := TGROUP():Create(oDlg1)
		oGrp&cSAY:cName           := "oGrp" + cSAY
		oGrp&cSAY:nLeft           := nCOL
		oGrp&cSAY:nTop            := nLIN + 210
		oGrp&cSAY:nWidth          := 125
		oGrp&cSAY:nHeight         := 65
		oGrp&cSAY:lShowHint       := .F.
		oGrp&cSAY:lReadOnly       := .F.
		oGrp&cSAY:Align           := 0
		oGrp&cSAY:lVisibleControl := .T.
*/

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName           := "oSay" + cSAY
		oSay&cSAY:cCaption        := "Maquina:"
		oSay&cSAY:nLeft           := nCOL + 5
		oSay&cSAY:nTop            := nLIN + 5
		oSay&cSAY:nWidth          := 60
		oSay&cSAY:nHeight         := 17
		oSay&cSAY:lShowHint       := .F.
		oSay&cSAY:lReadOnly       := .F.
		oSay&cSAY:Align           := 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap       := .F.
		oSay&cSAY:lTransparent    := .T.
		oSay&cSAY:SetFont( oFont1 )

		oMaq&cCONT                 := TSAY():Create(oDlg1)
		oMaq&cCONT:cName           := "oMaq" + cCONT
		oMaq&cCONT:cCaption        := ""
		oMaq&cCONT:nLeft           := nCOL + 75
		oMaq&cCONT:nTop            := nLIN + 5
		oMaq&cCONT:nWidth          := 80
		oMaq&cCONT:nHeight         := 17
		oMaq&cCONT:lShowHint       := .F.
		oMaq&cCONT:lReadOnly       := .F.
		oMaq&cCONT:Align           := 0
		oMaq&cCONT:lVisibleControl := .T.
		oMaq&cCONT:lWordWrap       := .F.
		oMaq&cCONT:lTransparent    := .T.
		oMaq&cCONT:nClrText   		 := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oMaq&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName           := "oSay" + cSAY
		oSay&cSAY:cCaption        := "OP:"
		oSay&cSAY:nLeft           := nCOL + 130
		oSay&cSAY:nTop            := nLIN + 5
		oSay&cSAY:nWidth          := 24
		oSay&cSAY:nHeight         := 17
		oSay&cSAY:lShowHint       := .F.
		oSay&cSAY:lReadOnly       := .F.
		oSay&cSAY:Align           := 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap       := .F.
		oSay&cSAY:lTransparent    := .T.
		oSay&cSAY:SetFont( oFont1 )

		oOP&cCONT                 := TSAY():Create(oDlg1)
		oOP&cCONT:cName           := "oOP" + cCONT
		oOP&cCONT:cCaption        := ""
		oOP&cCONT:nLeft           := nCOL + 165
		oOP&cCONT:nTop            := nLIN + 5
		oOP&cCONT:nWidth          := 100
		oOP&cCONT:nHeight         := 17
		oOP&cCONT:lShowHint       := .F.
		oOP&cCONT:lReadOnly       := .F.
		oOP&cCONT:Align           := 0
		oOP&cCONT:lVisibleControl := .T.
		oOP&cCONT:lWordWrap       := .F.
		oOP&cCONT:lTransparent    := .T.
		oOP&cCONT:nClrText    		:= If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oOP&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName           := "oSay" + cSAY
		oSay&cSAY:cCaption        := "Produto:"
		oSay&cSAY:nLeft           := nCOL + 5
		oSay&cSAY:nTop            := nLIN + 25
		oSay&cSAY:nWidth          := 60
		oSay&cSAY:nHeight         := 17
		oSay&cSAY:lShowHint       := .F.
		oSay&cSAY:lReadOnly       := .F.
		oSay&cSAY:Align           := 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap       := .F.
		oSay&cSAY:lTransparent    := .T.
		oSay&cSAY:SetFont( oFont1 )

		oPROD&cCONT                 := TSAY():Create(oDlg1)
		oPROD&cCONT:cName           := "oPROD" + cCONT
		oPROD&cCONT:cCaption        := ""
		oPROD&cCONT:nLeft           := nCOL + 75
		oPROD&cCONT:nTop            := nLIN + 25
		oPROD&cCONT:nWidth          := 80
		oPROD&cCONT:nHeight         := 17
		oPROD&cCONT:lShowHint       := .F.
		oPROD&cCONT:lReadOnly       := .F.
		oPROD&cCONT:Align           := 0
		oPROD&cCONT:lVisibleControl := .T.
		oPROD&cCONT:lWordWrap       := .F.
		oPROD&cCONT:lTransparent    := .T.
		oPROD&cCONT:nClrText   		  := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oPROD&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName           := "oSay" + cSAY
		oSay&cSAY:cCaption        := "Descricao:"
		oSay&cSAY:nLeft           := nCOL + 5
		oSay&cSAY:nTop            := nLIN + 45
		oSay&cSAY:nWidth          := 70
		oSay&cSAY:nHeight         := 17
		oSay&cSAY:lShowHint       := .F.
		oSay&cSAY:lReadOnly       := .F.
		oSay&cSAY:Align           := 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap       := .F.
		oSay&cSAY:lTransparent    := .T.
		oSay&cSAY:SetFont( oFont1 )

		oDESCR1&cCONT                 := TSAY():Create(oDlg1)
		oDESCR1&cCONT:cName           := "oDESCR1" + cCONT
		oDESCR1&cCONT:cCaption        := ""
		oDESCR1&cCONT:nLeft           := nCOL + 75
		oDESCR1&cCONT:nTop            := nLIN + 45
		oDESCR1&cCONT:nWidth          := 185
		oDESCR1&cCONT:nHeight         := 17
		oDESCR1&cCONT:lShowHint       := .F.
		oDESCR1&cCONT:lReadOnly       := .F.
		oDESCR1&cCONT:Align           := 0
		oDESCR1&cCONT:lVisibleControl := .T.
		oDESCR1&cCONT:lWordWrap       := .F.
		oDESCR1&cCONT:lTransparent    := .T.
		oDESCR1&cCONT:nClrText   		 := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oDESCR1&cCONT:SetFont( oFont2 )

		oDESCR2&cCONT                 := TSAY():Create(oDlg1)
		oDESCR2&cCONT:cName           := "oDESCR2" + cCONT
		oDESCR2&cCONT:cCaption        := ""
		oDESCR2&cCONT:nLeft           := nCOL + 5
		oDESCR2&cCONT:nTop            := nLIN + 65
		oDESCR2&cCONT:nWidth          := 250
		oDESCR2&cCONT:nHeight         := 17
		oDESCR2&cCONT:lShowHint       := .F.
		oDESCR2&cCONT:lReadOnly       := .F.
		oDESCR2&cCONT:Align           := 0
		oDESCR2&cCONT:lVisibleControl := .T.
		oDESCR2&cCONT:lWordWrap       := .F.
		oDESCR2&cCONT:lTransparent    := .T.
		oDESCR2&cCONT:nClrText   		 := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oDESCR2&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName           := "oSay" + cSAY
		oSay&cSAY:cCaption        := "Program. na OP:"
		oSay&cSAY:nLeft           := nCOL + 5
		oSay&cSAY:nTop            := nLIN + 95
		oSay&cSAY:nWidth          := 115
		oSay&cSAY:nHeight         := 17
		oSay&cSAY:lShowHint       := .F.
		oSay&cSAY:lReadOnly       := .F.
		oSay&cSAY:Align           := 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap       := .F.
		oSay&cSAY:lTransparent    := .T.
		oSay&cSAY:SetFont( oFont3 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName           := "oSay" + cSAY
		oSay&cSAY:cCaption        := "Produzido na OP:"
		oSay&cSAY:nLeft           := nCOL + 130
		oSay&cSAY:nTop            := nLIN + 95
		oSay&cSAY:nWidth          := 115
		oSay&cSAY:nHeight         := 17
		oSay&cSAY:lShowHint       := .F.
		oSay&cSAY:lReadOnly       := .F.
		oSay&cSAY:Align           := 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap       := .F.
		oSay&cSAY:lTransparent    := .T.
		oSay&cSAY:SetFont( oFont3 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName 				  := "oSay" + cSAY
		oSay&cSAY:cCaption        := "KG:"
		oSay&cSAY:nLeft           := nCOL + 5
		oSay&cSAY:nTop            := nLIN + 115
		oSay&cSAY:nWidth          := 29
		oSay&cSAY:nHeight         := 17
		oSay&cSAY:lShowHint       := .F.
		oSay&cSAY:lReadOnly       := .F.
		oSay&cSAY:Align           := 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap       := .F.
		oSay&cSAY:lTransparent    := .T.
		oSay&cSAY:SetFont( oFont1 )

		oPROGKG&cCONT                 := TSAY():Create(oDlg1)
		oPROGKG&cCONT:cName           := "oPROGKG" + cCONT
		oPROGKG&cCONT:cCaption        := Trans( 0, "@E 999999.99" )
		oPROGKG&cCONT:nLeft           := nCOL + 30
		oPROGKG&cCONT:nTop            := nLIN + 115
		oPROGKG&cCONT:nWidth          := 100
		oPROGKG&cCONT:nHeight         := 17
		oPROGKG&cCONT:lShowHint       := .F.
		oPROGKG&cCONT:lReadOnly       := .F.
		oPROGKG&cCONT:Align           := 0
		oPROGKG&cCONT:lVisibleControl := .T.
		oPROGKG&cCONT:lWordWrap       := .F.
		oPROGKG&cCONT:lTransparent    := .T.
		oPROGKG&cCONT:nClrText   		  := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oPROGKG&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY  		            := TSAY():Create(oDlg1)
		oSay&cSAY:cName           := "oSay" + cSAY
		oSay&cSAY:cCaption        := "KG:"
		oSay&cSAY:nLeft           := nCOL + 130
		oSay&cSAY:nTop            := nLIN + 115
		oSay&cSAY:nWidth          := 31
		oSay&cSAY:nHeight         := 17
		oSay&cSAY:lShowHint       := .F.
		oSay&cSAY:lReadOnly       := .F.
		oSay&cSAY:Align           := 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap       := .F.
		oSay&cSAY:lTransparent    := .T.
		oSay&cSAY:SetFont( oFont1 )

		oPRODKG&cCONT                 := TSAY():Create(oDlg1)
		oPRODKG&cCONT:cName           := "oPRODKG" + cCONT
		oPRODKG&cCONT:cCaption        := Trans( 0, "@E 999999.99" )
		oPRODKG&cCONT:nLeft           := nCOL + 155
		oPRODKG&cCONT:nTop            := nLIN + 115
		oPRODKG&cCONT:nWidth          := 100
		oPRODKG&cCONT:nHeight         := 17
		oPRODKG&cCONT:lShowHint       := .F.
		oPRODKG&cCONT:lReadOnly       := .F.
		oPRODKG&cCONT:Align           := 0
		oPRODKG&cCONT:lVisibleControl := .T.
		oPRODKG&cCONT:lWordWrap       := .F.
		oPRODKG&cCONT:lTransparent    := .T.
		oPRODKG&cCONT:nClrText   		  := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oPRODKG&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName 					:= "oSay" + cSAY
		oSay&cSAY:cCaption 				:= "MR:"
		oSay&cSAY:nLeft 					:= nCOL + 5
		oSay&cSAY:nTop 						:= nLIN + 135
		oSay&cSAY:nWidth 					:= 26
		oSay&cSAY:nHeight 				:= 17
		oSay&cSAY:lShowHint 			:= .F.
		oSay&cSAY:lReadOnly 			:= .F.
		oSay&cSAY:Align 					:= 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap 			:= .F.
		oSay&cSAY:lTransparent 		:= .T.
		oSay&cSAY:SetFont( oFont1 )

		oPROGMR&cCONT                 := TSAY():Create(oDlg1)
		oPROGMR&cCONT:cName           := "oPROGMR" + cCONT
		oPROGMR&cCONT:cCaption        := Trans( 0, "@E 999999.99" )
		oPROGMR&cCONT:nLeft           := nCOL + 30
		oPROGMR&cCONT:nTop            := nLIN + 135
		oPROGMR&cCONT:nWidth          := 100
		oPROGMR&cCONT:nHeight         := 17
		oPROGMR&cCONT:lShowHint       := .F.
		oPROGMR&cCONT:lReadOnly       := .F.
		oPROGMR&cCONT:Align           := 0
		oPROGMR&cCONT:lVisibleControl := .T.
		oPROGMR&cCONT:lWordWrap       := .F.
		oPROGMR&cCONT:lTransparent    := .T.
		oPROGMR&cCONT:nClrText   		  := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oPROGMR&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY 								:= TSAY():Create(oDlg1)
		oSay&cSAY:cName 					:= "oSay" + cSAY
		oSay&cSAY:cCaption 				:= "MR:"
		oSay&cSAY:nLeft 					:= nCOL + 130
		oSay&cSAY:nTop 						:= nLIN + 135
		oSay&cSAY:nWidth					:= 30
		oSay&cSAY:nHeight 				:= 17
		oSay&cSAY:lShowHint 			:= .F.
		oSay&cSAY:lReadOnly 			:= .F.
		oSay&cSAY:Align 					:= 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap 			:= .F.
		oSay&cSAY:lTransparent 		:= .T.
		oSay&cSAY:SetFont( oFont1 )

		oPRODMR&cCONT                 := TSAY():Create(oDlg1)
		oPRODMR&cCONT:cName           := "oPRODMR" + cCONT
		oPRODMR&cCONT:cCaption        := Trans( 0, "@E 999999.99" )
		oPRODMR&cCONT:nLeft           := nCOL + 155
		oPRODMR&cCONT:nTop            := nLIN + 135
		oPRODMR&cCONT:nWidth          := 100
		oPRODMR&cCONT:nHeight         := 17
		oPRODMR&cCONT:lShowHint       := .F.
		oPRODMR&cCONT:lReadOnly       := .F.
		oPRODMR&cCONT:Align           := 0
		oPRODMR&cCONT:lVisibleControl := .T.
		oPRODMR&cCONT:lWordWrap       := .F.
		oPRODMR&cCONT:lTransparent    := .T.
		oPRODMR&cCONT:nClrText   		  := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oPRODMR&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName 					:= "oSay" + cSAY
		oSay&cSAY:cCaption 				:= "Turno 1"
		oSay&cSAY:nLeft 					:= nCOL + 35
		oSay&cSAY:nTop 						:= nLIN + 155
		oSay&cSAY:nWidth 					:= 50
		oSay&cSAY:nHeight 				:= 17
		oSay&cSAY:lShowHint 			:= .F.
		oSay&cSAY:lReadOnly 			:= .F.
		oSay&cSAY:Align 					:= 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap 			:= .F.
		oSay&cSAY:lTransparent 		:= .T.
		oSay&cSAY:SetFont( oFont3 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName           := "oSay" + cSAY
		oSay&cSAY:cCaption        := "Turno 2"
		oSay&cSAY:nLeft           := nCOL + 160
		oSay&cSAY:nTop            := nLIN + 155
		oSay&cSAY:nWidth          := 50
		oSay&cSAY:nHeight         := 17
		oSay&cSAY:lShowHint       := .F.
		oSay&cSAY:lReadOnly       := .F.
		oSay&cSAY:Align           := 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap       := .F.
		oSay&cSAY:lTransparent    := .T.
		oSay&cSAY:SetFont( oFont3 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName 				  := "oSay" + cSAY
		oSay&cSAY:cCaption        := "KG:"
		oSay&cSAY:nLeft           := nCOL + 5
		oSay&cSAY:nTop            := nLIN + 175
		oSay&cSAY:nWidth          := 29
		oSay&cSAY:nHeight         := 17
		oSay&cSAY:lShowHint       := .F.
		oSay&cSAY:lReadOnly       := .F.
		oSay&cSAY:Align           := 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap       := .F.
		oSay&cSAY:lTransparent    := .T.
		oSay&cSAY:SetFont( oFont1 )

		oTURN1KG&cCONT                 := TSAY():Create(oDlg1)
		oTURN1KG&cCONT:cName           := "oTURN1KG" + cCONT
		oTURN1KG&cCONT:cCaption        := Trans( 0, "@E 999999.99" )
		oTURN1KG&cCONT:nLeft           := nCOL + 30
		oTURN1KG&cCONT:nTop            := nLIN + 175
		oTURN1KG&cCONT:nWidth          := 100
		oTURN1KG&cCONT:nHeight         := 17
		oTURN1KG&cCONT:lShowHint       := .F.
		oTURN1KG&cCONT:lReadOnly       := .F.
		oTURN1KG&cCONT:Align           := 0
		oTURN1KG&cCONT:lVisibleControl := .T.
		oTURN1KG&cCONT:lWordWrap       := .F.
		oTURN1KG&cCONT:lTransparent    := .T.
		oTURN1KG&cCONT:nClrText   		 := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oTURN1KG&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY  		            := TSAY():Create(oDlg1)
		oSay&cSAY:cName           := "oSay" + cSAY
		oSay&cSAY:cCaption        := "KG:"
		oSay&cSAY:nLeft           := nCOL + 130
		oSay&cSAY:nTop            := nLIN + 175
		oSay&cSAY:nWidth          := 31
		oSay&cSAY:nHeight         := 17
		oSay&cSAY:lShowHint       := .F.
		oSay&cSAY:lReadOnly       := .F.
		oSay&cSAY:Align           := 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap       := .F.
		oSay&cSAY:lTransparent    := .T.
		oSay&cSAY:SetFont( oFont1 )

		oTURN2KG&cCONT                 := TSAY():Create(oDlg1)
		oTURN2KG&cCONT:cName           := "oTURN2KG" + cCONT
		oTURN2KG&cCONT:cCaption        := Trans( 0, "@E 999999.99" )
		oTURN2KG&cCONT:nLeft           := nCOL + 155
		oTURN2KG&cCONT:nTop            := nLIN + 175
		oTURN2KG&cCONT:nWidth          := 100
		oTURN2KG&cCONT:nHeight         := 17
		oTURN2KG&cCONT:lShowHint       := .F.
		oTURN2KG&cCONT:lReadOnly       := .F.
		oTURN2KG&cCONT:Align           := 0
		oTURN2KG&cCONT:lVisibleControl := .T.
		oTURN2KG&cCONT:lWordWrap       := .F.
		oTURN2KG&cCONT:lTransparent    := .T.
		oTURN2KG&cCONT:nClrText   		 := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oTURN2KG&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName 					:= "oSay" + cSAY
		oSay&cSAY:cCaption 				:= "MR:"
		oSay&cSAY:nLeft 					:= nCOL + 5
		oSay&cSAY:nTop 						:= nLIN + 195
		oSay&cSAY:nWidth 					:= 26
		oSay&cSAY:nHeight 				:= 17
		oSay&cSAY:lShowHint 			:= .F.
		oSay&cSAY:lReadOnly 			:= .F.
		oSay&cSAY:Align 					:= 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap 			:= .F.
		oSay&cSAY:lTransparent 		:= .T.
		oSay&cSAY:SetFont( oFont1 )

		oTURN1MR&cCONT                 := TSAY():Create(oDlg1)
		oTURN1MR&cCONT:cName           := "oTURN1MR" + cCONT
		oTURN1MR&cCONT:cCaption        := Trans( 0, "@E 999999.99" )
		oTURN1MR&cCONT:nLeft           := nCOL + 30
		oTURN1MR&cCONT:nTop            := nLIN + 195
		oTURN1MR&cCONT:nWidth          := 100
		oTURN1MR&cCONT:nHeight         := 17
		oTURN1MR&cCONT:lShowHint       := .F.
		oTURN1MR&cCONT:lReadOnly       := .F.
		oTURN1MR&cCONT:Align           := 0
		oTURN1MR&cCONT:lVisibleControl := .T.
		oTURN1MR&cCONT:lWordWrap       := .F.
		oTURN1MR&cCONT:lTransparent    := .T.
		oTURN1MR&cCONT:nClrText   		 := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oTURN1MR&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY 								:= TSAY():Create(oDlg1)
		oSay&cSAY:cName 					:= "oSay" + cSAY
		oSay&cSAY:cCaption 				:= "MR:"
		oSay&cSAY:nLeft 					:= nCOL + 130
		oSay&cSAY:nTop 						:= nLIN + 195
		oSay&cSAY:nWidth					:= 30
		oSay&cSAY:nHeight 				:= 17
		oSay&cSAY:lShowHint 			:= .F.
		oSay&cSAY:lReadOnly 			:= .F.
		oSay&cSAY:Align 					:= 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap 			:= .F.
		oSay&cSAY:lTransparent 		:= .T.
		oSay&cSAY:SetFont( oFont1 )

		oTURN2MR&cCONT                 := TSAY():Create(oDlg1)
		oTURN2MR&cCONT:cName           := "oTURN2MR" + cCONT
		oTURN2MR&cCONT:cCaption        := Trans( 0, "@E 999999.99" )
		oTURN2MR&cCONT:nLeft           := nCOL + 155
		oTURN2MR&cCONT:nTop            := nLIN + 195
		oTURN2MR&cCONT:nWidth          := 100
		oTURN2MR&cCONT:nHeight         := 17
		oTURN2MR&cCONT:lShowHint       := .F.
		oTURN2MR&cCONT:lReadOnly       := .F.
		oTURN2MR&cCONT:Align           := 0
		oTURN2MR&cCONT:lVisibleControl := .T.
		oTURN2MR&cCONT:lWordWrap       := .F.
		oTURN2MR&cCONT:lTransparent    := .T.
		oTURN2MR&cCONT:nClrText   		 := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oTURN2MR&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY 								:= TSAY():Create(oDlg1)
		oSay&cSAY:cName 					:= "oSay" + cSAY
		oSay&cSAY:cCaption 				:= "Turno 3"
		oSay&cSAY:nLeft 					:= nCOL + 35
		oSay&cSAY:nTop 						:= nLIN + 215
		oSay&cSAY:nWidth 					:= 50
		oSay&cSAY:nHeight 				:= 17
		oSay&cSAY:lShowHint 			:= .F.
		oSay&cSAY:lReadOnly 			:= .F.
		oSay&cSAY:Align 					:= 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap 			:= .F.
		oSay&cSAY:lTransparent 		:= .T.
		oSay&cSAY:SetFont( oFont3 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY                 := TSAY():Create(oDlg1)
		oSay&cSAY:cName	 					:= "oSay" + cSAY
		oSay&cSAY:cCaption 				:= "Produzido no dia:"
		oSay&cSAY:nLeft 					:= nCOL + 130
		oSay&cSAY:nTop					 	:= nLIN + 215
		oSay&cSAY:nWidth 					:= 115
		oSay&cSAY:nHeight 				:= 17
		oSay&cSAY:lShowHint 			:= .F.
		oSay&cSAY:lReadOnly 			:= .F.
		oSay&cSAY:Align 					:= 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap 			:= .F.
		oSay&cSAY:lTransparent 		:= .T.
		oSay&cSAY:SetFont( oFont3 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY 								:= TSAY():Create(oDlg1)
		oSay&cSAY:cName 					:= "oSay" + cSAY
		oSay&cSAY:cCaption 				:= "KG:"
		oSay&cSAY:nLeft 					:= nCOL + 5
		oSay&cSAY:nTop					  := nLIN + 235
		oSay&cSAY:nWidth 					:= 27
		oSay&cSAY:nHeight 				:= 17
		oSay&cSAY:lShowHint 			:= .F.
		oSay&cSAY:lReadOnly 			:= .F.
		oSay&cSAY:Align 					:= 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap 			:= .F.
		oSay&cSAY:lTransparent 		:= .T.
		oSay&cSAY:SetFont( oFont1 )

		oTURN3KG&cCONT                 := TSAY():Create(oDlg1)
		oTURN3KG&cCONT:cName           := "oTURN3KG" + cCONT
		oTURN3KG&cCONT:cCaption        := Trans( 0, "@E 999999.99" )
		oTURN3KG&cCONT:nLeft           := nCOL + 30
		oTURN3KG&cCONT:nTop            := nLIN + 235
		oTURN3KG&cCONT:nWidth          := 100
		oTURN3KG&cCONT:nHeight         := 17
		oTURN3KG&cCONT:lShowHint       := .F.
		oTURN3KG&cCONT:lReadOnly       := .F.
		oTURN3KG&cCONT:Align           := 0
		oTURN3KG&cCONT:lVisibleControl := .T.
		oTURN3KG&cCONT:lWordWrap       := .F.
		oTURN3KG&cCONT:lTransparent    := .T.
		oTURN3KG&cCONT:nClrText   		 := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oTURN3KG&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY 								:= TSAY():Create(oDlg1)
		oSay&cSAY:cName 					:= "oSay" + cSAY
		oSay&cSAY:cCaption 				:= "KG:"
		oSay&cSAY:nLeft 					:= nCOL + 130
		oSay&cSAY:nTop 						:= nLIN + 235
		oSay&cSAY:nWidth 					:= 25
		oSay&cSAY:nHeight 				:= 17
		oSay&cSAY:lShowHint 			:= .F.
		oSay&cSAY:lReadOnly 			:= .F.
		oSay&cSAY:Align 					:= 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap 			:= .F.
		oSay&cSAY:lTransparent 		:= .T.
		oSay&cSAY:SetFont( oFont1 )

		oPRODDKG&cCONT                 := TSAY():Create(oDlg1)
		oPRODDKG&cCONT:cName           := "oPRODDKG" + cCONT
		oPRODDKG&cCONT:cCaption        := Trans( 0, "@E 999999.99" )
		oPRODDKG&cCONT:nLeft           := nCOL + 155
		oPRODDKG&cCONT:nTop            := nLIN + 235
		oPRODDKG&cCONT:nWidth          := 100
		oPRODDKG&cCONT:nHeight         := 17
		oPRODDKG&cCONT:lShowHint       := .F.
		oPRODDKG&cCONT:lReadOnly       := .F.
		oPRODDKG&cCONT:Align           := 0
		oPRODDKG&cCONT:lVisibleControl := .T.
		oPRODDKG&cCONT:lWordWrap       := .F.
		oPRODDKG&cCONT:lTransparent    := .T.
		oPRODDKG&cCONT:nClrText   		 := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oPRODDKG&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY 								:= TSAY():Create(oDlg1)
		oSay&cSAY:cName 					:= "oSay" + cSAY
		oSay&cSAY:cCaption 				:= "MR:"
		oSay&cSAY:nLeft 					:= nCOL + 5
		oSay&cSAY:nTop 						:= nLIN + 255
		oSay&cSAY:nWidth 					:= 25
		oSay&cSAY:nHeight 				:= 17
		oSay&cSAY:lShowHint 			:= .F.
		oSay&cSAY:lReadOnly 			:= .F.
		oSay&cSAY:Align 					:= 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap 			:= .F.
		oSay&cSAY:lTransparent 		:= .T.
		oSay&cSAY:SetFont( oFont1 )

		oTURN3MR&cCONT                 := TSAY():Create(oDlg1)
		oTURN3MR&cCONT:cName           := "oTURN3MR" + cCONT
		oTURN3MR&cCONT:cCaption        := Trans( 0, "@E 999999.99" )
		oTURN3MR&cCONT:nLeft           := nCOL + 30
		oTURN3MR&cCONT:nTop            := nLIN + 255
		oTURN3MR&cCONT:nWidth          := 100
		oTURN3MR&cCONT:nHeight         := 17
		oTURN3MR&cCONT:lShowHint       := .F.
		oTURN3MR&cCONT:lReadOnly       := .F.
		oTURN3MR&cCONT:Align           := 0
		oTURN3MR&cCONT:lVisibleControl := .T.
		oTURN3MR&cCONT:lWordWrap       := .F.
		oTURN3MR&cCONT:lTransparent    := .T.
		oTURN3MR&cCONT:nClrText   		 := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oTURN3MR&cCONT:SetFont( oFont2 )

		cSAY := cCONT + StrZero( nSAY++, 3 )

		oSay&cSAY 								:= TSAY():Create(oDlg1)
		oSay&cSAY:cName 					:= "oSay" + cSAY
		oSay&cSAY:cCaption 				:= "MR:"
		oSay&cSAY:nLeft 					:= nCOL + 130
		oSay&cSAY:nTop 						:= nLIN + 255
		oSay&cSAY:nWidth 					:= 25
		oSay&cSAY:nHeight 				:= 17
		oSay&cSAY:lShowHint				:= .F.
		oSay&cSAY:lReadOnly 			:= .F.
		oSay&cSAY:Align 					:= 0
		oSay&cSAY:lVisibleControl := .T.
		oSay&cSAY:lWordWrap 			:= .F.
		oSay&cSAY:lTransparent 		:= .T.
		oSay&cSAY:SetFont( oFont1 )

		oPRODDMR&cCONT                 := TSAY():Create(oDlg1)
		oPRODDMR&cCONT:cName           := "oPRODDMR" + cCONT
		oPRODDMR&cCONT:cCaption        := Trans( 0, "@E 999999.99" )
		oPRODDMR&cCONT:nLeft           := nCOL + 155
		oPRODDMR&cCONT:nTop            := nLIN + 255
		oPRODDMR&cCONT:nWidth          := 100
		oPRODDMR&cCONT:nHeight         := 17
		oPRODDMR&cCONT:lShowHint       := .F.
		oPRODDMR&cCONT:lReadOnly       := .F.
		oPRODDMR&cCONT:Align           := 0
		oPRODDMR&cCONT:lVisibleControl := .T.
		oPRODDMR&cCONT:lWordWrap       := .F.
		oPRODDMR&cCONT:lTransparent    := .T.
		oPRODDMR&cCONT:nClrText   		 := If( nCONT <= 3, CLR_HBLUE, CLR_HCYAN )
		oPRODDMR&cCONT:SetFont( oFont2 )

		nLIN := If( nCOL <> 531, nLIN, nLIN + 285 )
		nCOL := If( nCOL == 531, 5, nCOL + 263 )
Next
Return NIL
