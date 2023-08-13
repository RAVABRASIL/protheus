#Include "RwMake.ch"
#Include "Colors.ch"
#include "topconn.ch"
#include "font.ch"

************
User Function VIWLEI_TL1()
************

local nCodigo1 := "Produto"
local cCodBarra1 := "Codigo de Barra"
local cHora1 := "Hora"
local dData1 := "Data"
local nQuantP1 := "Quant."
local nQuantE1 := "Estoque"
public cCodBarra := Space(17)
public cQuantidad := Space(2)
public cQuantCont := 0
public cDescProd := ""
public cProduto := ""
Private cBuffer := ""
Private nHandle
/* 27/05/2009 */
nHandle := FOpen("C:\maquina.txt")
FREAD( nHandle , @cBuffer , 8 )
if nHandle < 0
	//FClose( nHandle )
	//msgAlert("Não foi possível encontrar o arquivo de definição das máquinas!")
	//return
endIf
FClose( nHandle )
//Retirado a pedido de Alexandre, chamado 001190( RECOLOCADO EM 25/11/2009 CHAMADO 001418 )
/* 27/05/2009 */

DEFINE FONT oFontQt NAME "Arial" SIZE 9, 20 BOLD//6, 20//0, -128
DEFINE FONT oFontNu NAME "Arial" SIZE 0, 50 BOLD//6, 20//0, -128

oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Lista de produtos prontos para entrada no Estoque"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 800
oDlg:nHeight := 600
oDlg:lShowHint := .F.
oDlg:lCentered := .F.

oGrp1 := TGROUP():Create(oDlg)
oGrp1:cName := "oGrp1"
oGrp1:nLeft := 5
oGrp1:nTop := 5
oGrp1:nWidth := 386
oGrp1:nHeight := 565
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oGrp4 := TGROUP():Create(oDlg)
oGrp4:cName := "oGrp2"
oGrp4:nLeft := 400
oGrp4:nTop := 5
oGrp4:nWidth := 386
oGrp4:nHeight := 370
oGrp4:lShowHint := .F.
oGrp4:lReadOnly := .F.
oGrp4:Align := 0
oGrp4:lVisibleControl := .T.

oGrp4 := TGROUP():Create(oDlg)
oGrp4:cName := "oGrp3"
oGrp4:nLeft := 400
oGrp4:nTop := 380
oGrp4:nWidth := 386
oGrp4:nHeight := 190//370
oGrp4:lShowHint := .F.
oGrp4:lReadOnly := .F.
oGrp4:Align := 0
oGrp4:lVisibleControl := .T.

oSayCBarra1 := TSAY():Create(oDlg)
oSayCBarra1:cName := "oSayCBarra1"
oSayCBarra1:cCaption := "Código de Barra :"
oSayCBarra1:nLeft := 410
oSayCBarra1:nTop := 398
oSayCBarra1:nWidth := 84
oSayCBarra1:nHeight := 17
oSayCBarra1:lShowHint := .F.
oSayCBarra1:lReadOnly := .F.
oSayCBarra1:Align := 0
oSayCBarra1:lVisibleControl := .T.
oSayCBarra1:lWordWrap := .F.
oSayCBarra1:lTransparent := .F.

oGetCBarra1 := TGET():Create(oDlg)
oGetCBarra1:cName := "oGetCBarra1"
oGetCBarra1:cCaption := cCodBarra
oGetCBarra1:cMsg := "Insira o Código de Barra"
oGetCBarra1:nLeft := 505
oGetCBarra1:nTop := 395
oGetCBarra1:nWidth := 81
oGetCBarra1:nHeight := 22
oGetCBarra1:lShowHint := .T.
oGetCBarra1:lReadOnly := .F.
oGetCBarra1:Align := 0
oGetCBarra1:cVariable := "cCodBarra"//'cSeqMov'
oGetCBarra1:bSetGet := {|u| If(PCount()>0,cCodBarra:=u,cCodBarra) }//{|u| If(PCount()>0,oGetCBarra1:cCaption:=u,oGetCBarra1:cCaption) }//oGetCBarra1:bSetGet := {|u| If(PCount()>0,cCodBarra:=u,cCodBarra) }
oGetCBarra1:lVisibleControl := .T.
oGetCBarra1:lPassword := .F.
oGetCBarra1:Picture := "@!"
oGetCBarra1:lHasButton := .F.
oGetCBarra1:bValid := {|| PesqCod( cCodBarra )}

oSayProduto1 := TSAY():Create(oDlg)
oSayProduto1:cName := "oSayProduto1"
oSayProduto1:cCaption := "Produto :"
oSayProduto1:nLeft := 410
oSayProduto1:nTop := 430
oSayProduto1:nWidth := 65
oSayProduto1:nHeight := 17
oSayProduto1:lShowHint := .F.
oSayProduto1:lReadOnly := .F.
oSayProduto1:Align := 0
oSayProduto1:lVisibleControl := .T.
oSayProduto1:lWordWrap := .F.
oSayProduto1:lTransparent := .F.

oSayProduto2 := TSAY():Create(oDlg)
oSayProduto2:cName := "oSayProduto2"
oSayProduto2:cCaption := cProduto
oSayProduto2:nLeft := 460
oSayProduto2:nTop := 430
oSayProduto2:nWidth := 65
oSayProduto2:nHeight := 17
oSayProduto2:lShowHint := .F.
oSayProduto2:lReadOnly := .F.
oSayProduto2:Align := 0
oSayProduto2:lVisibleControl := .T.
oSayProduto2:lWordWrap := .F.
oSayProduto2:lTransparent := .F.
oSayProduto2:nClrText := CLR_HRED

oSayDesc := TSAY():Create(oDlg)
oSayDesc:cName := "oSayDesc"
oSayDesc:cCaption := cDescProd
oSayDesc:nLeft := 530
oSayDesc:nTop := 430
oSayDesc:nWidth := 250
oSayDesc:nHeight := 17
oSayDesc:lShowHint := .F.
oSayDesc:lReadOnly := .F.
oSayDesc:Align := 0
oSayDesc:lVisibleControl := .T.
oSayDesc:lWordWrap := .F.
oSayDesc:lTransparent := .F.
oSayDesc:nClrText := CLR_HRED

oSayQuant1 := TSAY():Create(oDlg)
oSayQuant1:cName := "oSayQuant1"
oSayQuant1:cCaption := "Lidos :"
oSayQuant1:nLeft := 545
oSayQuant1:nTop := 470
oSayQuant1:nWidth := 65
oSayQuant1:nHeight := 17
oSayQuant1:lShowHint := .F.
oSayQuant1:lReadOnly := .F.
oSayQuant1:Align := 0
oSayQuant1:lVisibleControl := .T.
oSayQuant1:lWordWrap := .F.
oSayQuant1:lTransparent := .F.
oSayQuant1:SetFont( oFontQt )
oSayQuant1:nClrText := CLR_GREEN

oSayQuant2 := TSAY():Create(oDlg)
oSayQuant2:cName := "oSayQuant2"
oSayQuant2:cCaption := Transform(cQuantCont, "@E 99")//STR(cQuantCont)//cQuantidad
oSayQuant2:nLeft := 615
oSayQuant2:nTop := 447
oSayQuant2:nWidth := 65
oSayQuant2:nHeight := 50
oSayQuant2:lShowHint := .F.
oSayQuant2:lReadOnly := .F.
oSayQuant2:Align := 0
oSayQuant2:lVisibleControl := .T.
oSayQuant2:lWordWrap := .F.
oSayQuant2:lTransparent := .F.
oSayQuant2:SetFont( oFontNu )
oSayQuant2:nClrText := CLR_GREEN

oSBtn1 := SBUTTON():Create(oDlg)
oSBtn1:cName := "oSBtn1"
oSBtn1:cCaption := "Atualizar"
oSBtn1:nLeft := 450
oSBtn1:nTop := 520
oSBtn1:nWidth := 54
oSBtn1:nHeight := 21
oSBtn1:lShowHint := .F.
oSBtn1:lReadOnly := .F.
oSBtn1:Align := 0
oSBtn1:lVisibleControl := .T.
oSBtn1:nType := 11
oSBtn1:bAction := {|| Atualiza() }

oSBtn2 := SBUTTON():Create(oDlg)
oSBtn2:cName := "oSBtn2"
oSBtn2:cCaption := "Fechar"
oSBtn2:nLeft := 700
oSBtn2:nTop := 520
oSBtn2:nWidth := 54
oSBtn2:nHeight := 21
oSBtn2:lShowHint := .F.
oSBtn2:lReadOnly := .F.
oSBtn2:Align := 0
oSBtn2:lVisibleControl := .T.
oSBtn2:nType := 2
oSBtn2:bAction := {|| Close( oDLG ) }

cTitulo := nCodigo1 + "         " + cCodBarra1 + "    " + cHora1 + "        " + dData1 + "            " + nQuantP1 + "        " + nQuantE1

oSayTidulE := TSAY():Create(oDlg)
oSayTidulE:cName := "oSayTidulE"
oSayTidulE:cCaption := cTitulo
oSayTidulE:nLeft := 10
oSayTidulE:nTop := 10
oSayTidulE:nWidth := 375
oSayTidulE:nHeight := 17
oSayTidulE:lShowHint := .F.
oSayTidulE:lReadOnly := .F.
oSayTidulE:Align := 0
oSayTidulE:lVisibleControl := .T.
oSayTidulE:lWordWrap := .F.
oSayTidulE:lTransparent := .F.

oSayTidulD := TSAY():Create(oDlg)
oSayTidulD:cName := "oSayTidulD"
oSayTidulD:cCaption := cTitulo
oSayTidulD:nLeft := 405
oSayTidulD:nTop := 10
oSayTidulD:nWidth := 375
oSayTidulD:nHeight := 17
oSayTidulD:lShowHint := .F.
oSayTidulD:lReadOnly := .F.
oSayTidulD:Align := 0
oSayTidulD:lVisibleControl := .T.
oSayTidulD:lWordWrap := .F.
oSayTidulD:lTransparent := .F.

Mostra()
oDlg:Activate()

Return Nil

************
Static Function Mostra()
************

local cLabel1 := cLabel2 := cLabel3 := cLabel4 := cLabel5 := cLabel6 := cLabel7 := cLabel8 := cLabel9 := cLabel10 := ""
local cLabel11 := cLabel12 := cLabel13 := cLabel14 := cLabel15 := cLabel16 := cLabel17 := cLabel18 := cLabel19 := cLabel20 := ""
local cLabel21 := cLabel22 := cLabel23 := cLabel24 := cLabel25 := cLabel26 := cLabel27 := cLabel28 := cLabel29 := cLabel30 := ""
local cLabel31 := cLabel32 := cLabel33 := cLabel34 := cLabel35 := cLabel36 := cLabel37 := cLabel38 := cLabel39 := cLabel40 := ""
local cLabel41 := cLabel42 := cLabel43 := cLabel44 := cLabel45 := cLabel46 := cLabel47 := cLabel48 := cLabel49 := cLabel50 := ""
local cLabel51 := cLabel52 := cLabel53 := cLabel54 := cLabel55 := cLabel56 := cLabel57 := cLabel58 := cLabel59 := cLabel60 := ""
local cLabel61 := cLabel62 := cLabel63 := cLabel64 := cLabel65 := cLabel66 := cLabel67 := ""
local nTopVar := 30
local nTopVar2 := 30
local nImpar := 1
local nPar := 2
local nTamArreyA
public oSayLin1 := oSayLin2 := oSayLin3 := oSayLin4 := oSayLin5 := oSayLin6 := oSayLin7 := oSayLin8 := oSayLin9 := oSayLin10 := ""
public oSayLin11 := oSayLin12 := oSayLin13 := oSayLin14 := oSayLin15 := oSayLin16 := oSayLin17 := oSayLin18 := oSayLin19 := oSayLin20 := ""
public oSayLin21 := oSayLin22 := oSayLin23 := oSayLin24 := oSayLin25 := oSayLin26 := oSayLin27 := oSayLin28 := oSayLin29 := oSayLin30 := ""
public oSayLin31 := oSayLin32 := oSayLin33 := oSayLin34 := oSayLin35 := oSayLin36 := oSayLin37 := oSayLin38 := oSayLin39 := oSayLin40 := ""
public oSayLin41 := oSayLin42 := oSayLin43 := oSayLin44 := oSayLin45 := oSayLin46 := oSayLin47 := oSayLin48 := oSayLin49 := oSayLin50 := ""
public oSayLin51 := oSayLin52 := oSayLin53 := oSayLin54 := oSayLin55 := oSayLin56 := oSayLin57 := oSayLin58 := oSayLin59 := oSayLin60 := ""
public oSayLin61 := oSayLin62 := oSayLin63 := oSayLin64 := oSayLin65 := oSayLin66 := oSayLin67 := ""

DEFINE FONT oFont NAME "Courier New" SIZE 6, 17//6, 20//0, -128

CONSULTA()

nTamArreyA := Len(aConsulta)
	If nTamArreyA > 0
		If nTamArreyA >= 1
			For X := 1 To 6
				cLabel1 := cLabel1 + Iif(X >=5, Transform(aConsulta[ 1, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 1, X ], "@!"), 1, 9),Transform(aConsulta[ 1, X ], "@!"))) + "  "
			Next
		Else
			cLabel1 := ""
		EndIf
		oSayLin1 := TSAY():Create(oDlg)
		oSayLin1:cName := "oSayLin1"
		oSayLin1:cCaption := cLabel1
		oSayLin1:nLeft := 10
		oSayLin1:nTop := nTopVar
		oSayLin1:nWidth := 375
		oSayLin1:nHeight := 17
		oSayLin1:lShowHint := .F.
		oSayLin1:lReadOnly := .F.
		oSayLin1:Align := 0
		oSayLin1:lVisibleControl := .T.
		oSayLin1:lWordWrap := .F.
		oSayLin1:lTransparent := .F.
		oSayLin1:SetFont( oFont )
		oSayLin1:nClrText := cColor(nImpar)

		If nTamArreyA >= 2
			For X := 1 To 6
				cLabel2 := cLabel2 + Iif(X >=5, Transform(aConsulta[ 2, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 2, X ], "@!"), 1, 9),Transform(aConsulta[ 2, X ], "@!"))) + "  "
			Next
		Else
			cLabel2 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin2 := TSAY():Create(oDlg)
		oSayLin2:cName := "oSayLin2"
		oSayLin2:cCaption := cLabel2
		oSayLin2:nLeft := 10
		oSayLin2:nTop := nTopVar
		oSayLin2:nWidth := 375
		oSayLin2:nHeight := 17
		oSayLin2:lShowHint := .F.
		oSayLin2:lReadOnly := .F.
		oSayLin2:Align := 0
		oSayLin2:lVisibleControl := .T.
		oSayLin2:lWordWrap := .F.
		oSayLin2:lTransparent := .F.
		oSayLin2:SetFont( oFont )
		oSayLin2:nClrText := cColor(nPar)

		If nTamArreyA >= 3
			For X := 1 To 6
				cLabel3 := cLabel3 + Iif(X >=5, Transform(aConsulta[ 3, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 3, X ], "@!"), 1, 9),Transform(aConsulta[ 3, X ], "@!"))) + "  "
			Next
		Else
			cLabel3 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin3 := TSAY():Create(oDlg)
		oSayLin3:cName := "oSayLin3"
		oSayLin3:cCaption := cLabel3
		oSayLin3:nLeft := 10
		oSayLin3:nTop := nTopVar
		oSayLin3:nWidth := 375
		oSayLin3:nHeight := 17
		oSayLin3:lShowHint := .F.
		oSayLin3:lReadOnly := .F.
		oSayLin3:Align := 0
		oSayLin3:lVisibleControl := .T.
		oSayLin3:lWordWrap := .F.
		oSayLin3:lTransparent := .F.
		oSayLin3:SetFont( oFont )
		oSayLin3:nClrText := cColor(nImpar)
		If nTamArreyA >= 4
			For X := 1 To 6
				cLabel4 := cLabel4 + Iif(X >=5, Transform(aConsulta[ 4, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 4, X ], "@!"), 1, 9),Transform(aConsulta[ 4, X ], "@!"))) + "  "
			Next
		Else
			cLabel4 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin4 := TSAY():Create(oDlg)
		oSayLin4:cName := "oSayLin4"
		oSayLin4:cCaption := cLabel4
		oSayLin4:nLeft := 10
		oSayLin4:nTop := nTopVar
		oSayLin4:nWidth := 375
		oSayLin4:nHeight := 17
		oSayLin4:lShowHint := .F.
		oSayLin4:lReadOnly := .F.
		oSayLin4:Align := 0
		oSayLin4:lVisibleControl := .T.
		oSayLin4:lWordWrap := .F.
		oSayLin4:lTransparent := .F.
		oSayLin4:SetFont( oFont )
		oSayLin4:nClrText := cColor(npar)
		If nTamArreyA >= 5
			For X := 1 To 6
				cLabel5 := cLabel5 + Iif(X >=5, Transform(aConsulta[ 5, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 5, X ], "@!"), 1, 9),Transform(aConsulta[ 5, X ], "@!"))) + "  "
			Next
		Else
			cLabel5 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin5 := TSAY():Create(oDlg)
		oSayLin5:cName := "oSayLin5"
		oSayLin5:cCaption := cLabel5
		oSayLin5:nLeft := 10
		oSayLin5:nTop := nTopVar
		oSayLin5:nWidth := 375
		oSayLin5:nHeight := 17
		oSayLin5:lShowHint := .F.
		oSayLin5:lReadOnly := .F.
		oSayLin5:Align := 0
		oSayLin5:lVisibleControl := .T.
		oSayLin5:lWordWrap := .F.
		oSayLin5:lTransparent := .F.
		oSayLin5:SetFont( oFont )
		oSayLin5:nClrText := cColor(nImpar)
		If nTamArreyA >= 6
			For X := 1 To 6
				cLabel6 := cLabel6 + Iif(X >=5, Transform(aConsulta[ 6, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 6, X ], "@!"), 1, 9),Transform(aConsulta[ 6, X ], "@!"))) + "  "
			Next
		Else
			cLabel6 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin6 := TSAY():Create(oDlg)
		oSayLin6:cName := "oSayLin6"
		oSayLin6:cCaption := cLabel6
		oSayLin6:nLeft := 10
		oSayLin6:nTop := nTopVar
		oSayLin6:nWidth := 375
		oSayLin6:nHeight := 17
		oSayLin6:lShowHint := .F.
		oSayLin6:lReadOnly := .F.
		oSayLin6:Align := 0
		oSayLin6:lVisibleControl := .T.
		oSayLin6:lWordWrap := .F.
		oSayLin6:lTransparent := .F.
		oSayLin6:SetFont( oFont )
		oSayLin6:nClrText := cColor(npar)
		If nTamArreyA >= 7
			For X := 1 To 6
				cLabel7 := cLabel7 + Iif(X >=5, Transform(aConsulta[ 7, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 7, X ], "@!"), 1, 9),Transform(aConsulta[ 7, X ], "@!"))) + "  "
			Next
		Else
			cLabel7 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin7 := TSAY():Create(oDlg)
		oSayLin7:cName := "oSayLin7"
		oSayLin7:cCaption := cLabel7
		oSayLin7:nLeft := 10
		oSayLin7:nTop := nTopVar
		oSayLin7:nWidth := 375
		oSayLin7:nHeight := 17
		oSayLin7:lShowHint := .F.
		oSayLin7:lReadOnly := .F.
		oSayLin7:Align := 0
		oSayLin7:lVisibleControl := .T.
		oSayLin7:lWordWrap := .F.
		oSayLin7:lTransparent := .F.
		oSayLin7:SetFont( oFont )
		oSayLin7:nClrText := cColor(nImpar)
		If nTamArreyA >= 8
			For X := 1 To 6
				cLabel8 := cLabel8 + Iif(X >=5, Transform(aConsulta[ 8, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 8, X ], "@!"), 1, 9),Transform(aConsulta[ 8, X ], "@!"))) + "  "
			Next
		Else
			cLabel8 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin8 := TSAY():Create(oDlg)
		oSayLin8:cName := "oSayLin8"
		oSayLin8:cCaption := cLabel8
		oSayLin8:nLeft := 10
		oSayLin8:nTop := nTopVar
		oSayLin8:nWidth := 375
		oSayLin8:nHeight := 17
		oSayLin8:lShowHint := .F.
		oSayLin8:lReadOnly := .F.
		oSayLin8:Align := 0
		oSayLin8:lVisibleControl := .T.
		oSayLin8:lWordWrap := .F.
		oSayLin8:lTransparent := .F.
		oSayLin8:SetFont( oFont )
		oSayLin8:nClrText := cColor(npar)
		If nTamArreyA >= 9
			For X := 1 To 6
				cLabel9 := cLabel9 + Iif(X >=5, Transform(aConsulta[ 9, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 9, X ], "@!"), 1, 9),Transform(aConsulta[ 9, X ], "@!"))) + "  "
			Next
		Else
			cLabel9 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin9 := TSAY():Create(oDlg)
		oSayLin9:cName := "oSayLin9"
		oSayLin9:cCaption := cLabel9
		oSayLin9:nLeft := 10
		oSayLin9:nTop := nTopVar
		oSayLin9:nWidth := 375
		oSayLin9:nHeight := 17
		oSayLin9:lShowHint := .F.
		oSayLin9:lReadOnly := .F.
		oSayLin9:Align := 0
		oSayLin9:lVisibleControl := .T.
		oSayLin9:lWordWrap := .F.
		oSayLin9:lTransparent := .F.
		oSayLin9:SetFont( oFont )
		oSayLin9:nClrText := cColor(nImpar)
		If nTamArreyA >= 10
			For X := 1 To 6
				cLabel10 := cLabel10 + Iif(X >=5, Transform(aConsulta[ 10, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 10, X ], "@!"), 1, 9),Transform(aConsulta[ 10, X ], "@!"))) + "  "
			Next
		Else
			cLabel10 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin10 := TSAY():Create(oDlg)
		oSayLin10:cName := "oSayLin10"
		oSayLin10:cCaption := cLabel10
		oSayLin10:nLeft := 10
		oSayLin10:nTop := nTopVar
		oSayLin10:nWidth := 375
		oSayLin10:nHeight := 17
		oSayLin10:lShowHint := .F.
		oSayLin10:lReadOnly := .F.
		oSayLin10:Align := 0
		oSayLin10:lVisibleControl := .T.
		oSayLin10:lWordWrap := .F.
		oSayLin10:lTransparent := .F.
		oSayLin10:SetFont( oFont )
		oSayLin10:nClrText := cColor(nPar)
		If nTamArreyA >= 11
			For X := 1 To 6
				cLabel11 := cLabel11 + Iif(X >=5, Transform(aConsulta[ 11, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 11, X ], "@!"), 1, 9),Transform(aConsulta[ 11, X ], "@!"))) + "  "
			Next
		Else
			cLabel11 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin11 := TSAY():Create(oDlg)
		oSayLin11:cName := "oSayLin11"
		oSayLin11:cCaption := cLabel11
		oSayLin11:nLeft := 10
		oSayLin11:nTop := nTopVar
		oSayLin11:nWidth := 375
		oSayLin11:nHeight := 17
		oSayLin11:lShowHint := .F.
		oSayLin11:lReadOnly := .F.
		oSayLin11:Align := 0
		oSayLin11:lVisibleControl := .T.
		oSayLin11:lWordWrap := .F.
		oSayLin11:lTransparent := .F.
		oSayLin11:SetFont( oFont )
		oSayLin11:nClrText := cColor(nImpar)
		If nTamArreyA >= 12
			For X := 1 To 6
				cLabel12 := cLabel12 + Iif(X >=5, Transform(aConsulta[ 12, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 12, X ], "@!"), 1, 9),Transform(aConsulta[ 12, X ], "@!"))) + "  "
			Next
		Else
			cLabel12 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin12 := TSAY():Create(oDlg)
		oSayLin12:cName := "oSayLin12"
		oSayLin12:cCaption := cLabel12
		oSayLin12:nLeft := 10
		oSayLin12:nTop := nTopVar
		oSayLin12:nWidth := 375
		oSayLin12:nHeight := 17
		oSayLin12:lShowHint := .F.
		oSayLin12:lReadOnly := .F.
		oSayLin12:Align := 0
		oSayLin12:lVisibleControl := .T.
		oSayLin12:lWordWrap := .F.
		oSayLin12:lTransparent := .F.
		oSayLin12:SetFont( oFont )
		oSayLin12:nClrText := cColor(nPar)
		If nTamArreyA >= 13
			For X := 1 To 6
				cLabel13 := cLabel13 + Iif(X >=5, Transform(aConsulta[ 13, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 13, X ], "@!"), 1, 9),Transform(aConsulta[ 13, X ], "@!"))) + "  "
			Next
		Else
			cLabel13 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin13 := TSAY():Create(oDlg)
		oSayLin13:cName := "oSayLin13"
		oSayLin13:cCaption := cLabel13
		oSayLin13:nLeft := 10
		oSayLin13:nTop := nTopVar
		oSayLin13:nWidth := 375
		oSayLin13:nHeight := 17
		oSayLin13:lShowHint := .F.
		oSayLin13:lReadOnly := .F.
		oSayLin13:Align := 0
		oSayLin13:lVisibleControl := .T.
		oSayLin13:lWordWrap := .F.
		oSayLin13:lTransparent := .F.
		oSayLin13:SetFont( oFont )
		oSayLin13:nClrText := cColor(nImpar)
		If nTamArreyA >= 14
			For X := 1 To 6
				cLabel14 := cLabel14 + Iif(X >=5, Transform(aConsulta[ 14, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 14, X ], "@!"), 1, 9),Transform(aConsulta[ 14, X ], "@!"))) + "  "
			Next
		Else
			cLabel14 := ""
		EndIf
		nTopVar := nTopVar + 13

		oSayLin14 := TSAY():Create(oDlg)
		oSayLin14:cName := "oSayLin14"
		oSayLin14:cCaption := cLabel14
		oSayLin14:nLeft := 10
		oSayLin14:nTop := nTopVar
		oSayLin14:nWidth := 375
		oSayLin14:nHeight := 17
		oSayLin14:lShowHint := .F.
		oSayLin14:lReadOnly := .F.
		oSayLin14:Align := 0
		oSayLin14:lVisibleControl := .T.
		oSayLin14:lWordWrap := .F.
		oSayLin14:lTransparent := .F.
		oSayLin14:SetFont( oFont )
		oSayLin14:nClrText := cColor(nPar)
		If nTamArreyA >= 15
			For X := 1 To 6
				cLabel15 := cLabel15 + Iif(X >=5, Transform(aConsulta[ 15, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 15, X ], "@!"), 1, 9),Transform(aConsulta[ 15, X ], "@!"))) + "  "
			Next
		Else
			cLabel15 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin15 := TSAY():Create(oDlg)
		oSayLin15:cName := "oSayLin15"
		oSayLin15:cCaption := cLabel15
		oSayLin15:nLeft := 10
		oSayLin15:nTop := nTopVar
		oSayLin15:nWidth := 375
		oSayLin15:nHeight := 17
		oSayLin15:lShowHint := .F.
		oSayLin15:lReadOnly := .F.
		oSayLin15:Align := 0
		oSayLin15:lVisibleControl := .T.
		oSayLin15:lWordWrap := .F.
		oSayLin15:lTransparent := .F.
		oSayLin15:SetFont( oFont )
		oSayLin15:nClrText := cColor(nImpar)
		If nTamArreyA >= 16
			For X := 1 To 6
				cLabel16 := cLabel16 + Iif(X >=5, Transform(aConsulta[ 16, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 16, X ], "@!"), 1, 9),Transform(aConsulta[ 16, X ], "@!"))) + "  "
			Next
		Else
			cLabel16 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin16 := TSAY():Create(oDlg)
		oSayLin16:cName := "oSayLin16"
		oSayLin16:cCaption := cLabel16
		oSayLin16:nLeft := 10
		oSayLin16:nTop := nTopVar
		oSayLin16:nWidth := 375
		oSayLin16:nHeight := 17
		oSayLin16:lShowHint := .F.
		oSayLin16:lReadOnly := .F.
		oSayLin16:Align := 0
		oSayLin16:lVisibleControl := .T.
		oSayLin16:lWordWrap := .F.
		oSayLin16:lTransparent := .F.
		oSayLin16:SetFont( oFont )
		oSayLin16:nClrText := cColor(nPar)
		If nTamArreyA >= 17
			For X := 1 To 6
				cLabel17 := cLabel17 + Iif(X >=5, Transform(aConsulta[ 17, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 17, X ], "@!"), 1, 9),Transform(aConsulta[ 17, X ], "@!"))) + "  "
			Next
		Else
			cLabel17 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin17 := TSAY():Create(oDlg)
		oSayLin17:cName := "oSayLin17"
		oSayLin17:cCaption := cLabel17
		oSayLin17:nLeft := 10
		oSayLin17:nTop := nTopVar
		oSayLin17:nWidth := 375
		oSayLin17:nHeight := 17
		oSayLin17:lShowHint := .F.
		oSayLin17:lReadOnly := .F.
		oSayLin17:Align := 0
		oSayLin17:lVisibleControl := .T.
		oSayLin17:lWordWrap := .F.
		oSayLin17:lTransparent := .F.
		oSayLin17:SetFont( oFont )
		oSayLin17:nClrText := cColor(nImpar)
		If nTamArreyA >= 18
			For X := 1 To 6
				cLabel18 := cLabel18 + Iif(X >=5, Transform(aConsulta[ 18, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 18, X ], "@!"), 1, 9),Transform(aConsulta[ 18, X ], "@!"))) + "  "
			Next
		Else
			cLabel18 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin18 := TSAY():Create(oDlg)
		oSayLin18:cName := "oSayLin18"
		oSayLin18:cCaption := cLabel18
		oSayLin18:nLeft := 10
		oSayLin18:nTop := nTopVar
		oSayLin18:nWidth := 375
		oSayLin18:nHeight := 17
		oSayLin18:lShowHint := .F.
		oSayLin18:lReadOnly := .F.
		oSayLin18:Align := 0
		oSayLin18:lVisibleControl := .T.
		oSayLin18:lWordWrap := .F.
		oSayLin18:lTransparent := .F.
		oSayLin18:SetFont( oFont )
		oSayLin18:nClrText := cColor(nPar)
		If nTamArreyA >= 19
			For X := 1 To 6
				cLabel19 := cLabel19 + Iif(X >=5, Transform(aConsulta[ 19, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 19, X ], "@!"), 1, 9),Transform(aConsulta[ 19, X ], "@!"))) + "  "
			Next
		Else
			cLabel19 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin19 := TSAY():Create(oDlg)
		oSayLin19:cName := "oSayLin19"
		oSayLin19:cCaption := cLabel19
		oSayLin19:nLeft := 10
		oSayLin19:nTop := nTopVar
		oSayLin19:nWidth := 375
		oSayLin19:nHeight := 17
		oSayLin19:lShowHint := .F.
		oSayLin19:lReadOnly := .F.
		oSayLin19:Align := 0
		oSayLin19:lVisibleControl := .T.
		oSayLin19:lWordWrap := .F.
		oSayLin19:lTransparent := .F.
		oSayLin19:SetFont( oFont )
		oSayLin19:nClrText := cColor(nImpar)
		If nTamArreyA >= 20
			For X := 1 To 6
				cLabel20 := cLabel20 + Iif(X >=5, Transform(aConsulta[ 20, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 20, X ], "@!"), 1, 9),Transform(aConsulta[ 20, X ], "@!"))) + "  "
			Next
		Else
			cLabel20 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin20 := TSAY():Create(oDlg)
		oSayLin20:cName := "oSayLin20"
		oSayLin20:cCaption := cLabel20
		oSayLin20:nLeft := 10
		oSayLin20:nTop := nTopVar
		oSayLin20:nWidth := 375
		oSayLin20:nHeight := 17
		oSayLin20:lShowHint := .F.
		oSayLin20:lReadOnly := .F.
		oSayLin20:Align := 0
		oSayLin20:lVisibleControl := .T.
		oSayLin20:lWordWrap := .F.
		oSayLin20:lTransparent := .F.
		oSayLin20:SetFont( oFont )
		oSayLin20:nClrText := cColor(nPar)
		If nTamArreyA >= 21
			For X := 1 To 6
				cLabel21 := cLabel21 + Iif(X >=5, Transform(aConsulta[ 21, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 21, X ], "@!"), 1, 9),Transform(aConsulta[ 21, X ], "@!"))) + "  "
			Next
		Else
			cLabel21 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin21 := TSAY():Create(oDlg)
		oSayLin21:cName := "oSayLin21"
		oSayLin21:cCaption := cLabel21
		oSayLin21:nLeft := 10
		oSayLin21:nTop := nTopVar
		oSayLin21:nWidth := 375
		oSayLin21:nHeight := 17
		oSayLin21:lShowHint := .F.
		oSayLin21:lReadOnly := .F.
		oSayLin21:Align := 0
		oSayLin21:lVisibleControl := .T.
		oSayLin21:lWordWrap := .F.
		oSayLin21:lTransparent := .F.
		oSayLin21:SetFont( oFont )
		oSayLin21:nClrText := cColor(nImpar)
		If nTamArreyA >= 22
			For X := 1 To 6
				cLabel22 := cLabel22 + Iif(X >=5, Transform(aConsulta[ 22, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 22, X ], "@!"), 1, 9),Transform(aConsulta[ 22, X ], "@!"))) + "  "
			Next
		Else
			cLabel22 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin22 := TSAY():Create(oDlg)
		oSayLin22:cName := "oSayLin22"
		oSayLin22:cCaption := cLabel22
		oSayLin22:nLeft := 10
		oSayLin22:nTop := nTopVar
		oSayLin22:nWidth := 375
		oSayLin22:nHeight := 17
		oSayLin22:lShowHint := .F.
		oSayLin22:lReadOnly := .F.
		oSayLin22:Align := 0
		oSayLin22:lVisibleControl := .T.
		oSayLin22:lWordWrap := .F.
		oSayLin22:lTransparent := .F.
		oSayLin22:SetFont( oFont )
		oSayLin22:nClrText := cColor(nPar)
		If nTamArreyA >= 23
			For X := 1 To 6
				cLabel23 := cLabel23 + Iif(X >=5, Transform(aConsulta[ 23, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 23, X ], "@!"), 1, 9),Transform(aConsulta[ 23, X ], "@!"))) + "  "
			Next
		Else
			cLabel23 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin23 := TSAY():Create(oDlg)
		oSayLin23:cName := "oSayLin23"
		oSayLin23:cCaption := cLabel23
		oSayLin23:nLeft := 10
		oSayLin23:nTop := nTopVar
		oSayLin23:nWidth := 375
		oSayLin23:nHeight := 17
		oSayLin23:lShowHint := .F.
		oSayLin23:lReadOnly := .F.
		oSayLin23:Align := 0
		oSayLin23:lVisibleControl := .T.
		oSayLin23:lWordWrap := .F.
		oSayLin23:lTransparent := .F.
		oSayLin23:SetFont( oFont )
		oSayLin23:nClrText := cColor(nImpar)
		If nTamArreyA >= 24
			For X := 1 To 6
				cLabel24 := cLabel24 + Iif(X >=5, Transform(aConsulta[ 24, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 24, X ], "@!"), 1, 9),Transform(aConsulta[ 24, X ], "@!"))) + "  "
			Next
		Else
			cLabel24 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin24 := TSAY():Create(oDlg)
		oSayLin24:cName := "oSayLin24"
		oSayLin24:cCaption := cLabel24
		oSayLin24:nLeft := 10
		oSayLin24:nTop := nTopVar
		oSayLin24:nWidth := 375
		oSayLin24:nHeight := 17
		oSayLin24:lShowHint := .F.
		oSayLin24:lReadOnly := .F.
		oSayLin24:Align := 0
		oSayLin24:lVisibleControl := .T.
		oSayLin24:lWordWrap := .F.
		oSayLin24:lTransparent := .F.
		oSayLin24:SetFont( oFont )
		oSayLin24:nClrText := cColor(nPar)
		If nTamArreyA >= 25
			For X := 1 To 6
				cLabel25 := cLabel25 + Iif(X >=5, Transform(aConsulta[ 25, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 25, X ], "@!"), 1, 9),Transform(aConsulta[ 25, X ], "@!"))) + "  "
			Next
		Else
			cLabel25 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin25 := TSAY():Create(oDlg)
		oSayLin25:cName := "oSayLin25"
		oSayLin25:cCaption := cLabel25
		oSayLin25:nLeft := 10
		oSayLin25:nTop := nTopVar
		oSayLin25:nWidth := 375
		oSayLin25:nHeight := 17
		oSayLin25:lShowHint := .F.
		oSayLin25:lReadOnly := .F.
		oSayLin25:Align := 0
		oSayLin25:lVisibleControl := .T.
		oSayLin25:lWordWrap := .F.
		oSayLin25:lTransparent := .F.
		oSayLin25:SetFont( oFont )
		oSayLin25:nClrText := cColor(nImpar)
		If nTamArreyA >= 26
			For X := 1 To 6
				cLabel26 := cLabel26 + Iif(X >=5, Transform(aConsulta[ 26, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 26, X ], "@!"), 1, 9),Transform(aConsulta[ 26, X ], "@!"))) + "  "
			Next
		Else
			cLabel26 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin26 := TSAY():Create(oDlg)
		oSayLin26:cName := "oSayLin26"
		oSayLin26:cCaption := cLabel26
		oSayLin26:nLeft := 10
		oSayLin26:nTop := nTopVar
		oSayLin26:nWidth := 375
		oSayLin26:nHeight := 17
		oSayLin26:lShowHint := .F.
		oSayLin26:lReadOnly := .F.
		oSayLin26:Align := 0
		oSayLin26:lVisibleControl := .T.
		oSayLin26:lWordWrap := .F.
		oSayLin26:lTransparent := .F.
		oSayLin26:SetFont( oFont )
		oSayLin26:nClrText := cColor(nPar)
		If nTamArreyA >= 27
			For X := 1 To 6
				cLabel27 := cLabel27 + Iif(X >=5, Transform(aConsulta[ 27, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 27, X ], "@!"), 1, 9),Transform(aConsulta[ 27, X ], "@!"))) + "  "
			Next
		Else
			cLabel27 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin27 := TSAY():Create(oDlg)
		oSayLin27:cName := "oSayLin27"
		oSayLin27:cCaption := cLabel27
		oSayLin27:nLeft := 10
		oSayLin27:nTop := nTopVar
		oSayLin27:nWidth := 375
		oSayLin27:nHeight := 17
		oSayLin27:lShowHint := .F.
		oSayLin27:lReadOnly := .F.
		oSayLin27:Align := 0
		oSayLin27:lVisibleControl := .T.
		oSayLin27:lWordWrap := .F.
		oSayLin27:lTransparent := .F.
		oSayLin27:SetFont( oFont )
		oSayLin27:nClrText := cColor(nImpar)
		If nTamArreyA >= 28
			For X := 1 To 6
				cLabel28 := cLabel28 + Iif(X >=5, Transform(aConsulta[ 28, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 28, X ], "@!"), 1, 9),Transform(aConsulta[ 28, X ], "@!"))) + "  "
			Next
		Else
			cLabel28 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin28 := TSAY():Create(oDlg)
		oSayLin28:cName := "oSayLin28"
		oSayLin28:cCaption := cLabel28
		oSayLin28:nLeft := 10
		oSayLin28:nTop := nTopVar
		oSayLin28:nWidth := 375
		oSayLin28:nHeight := 17
		oSayLin28:lShowHint := .F.
		oSayLin28:lReadOnly := .F.
		oSayLin28:Align := 0
		oSayLin28:lVisibleControl := .T.
		oSayLin28:lWordWrap := .F.
		oSayLin28:lTransparent := .F.
		oSayLin28:SetFont( oFont )
		oSayLin28:nClrText := cColor(nPar)
		If nTamArreyA >= 29
			For X := 1 To 6
				cLabel29 := cLabel29 + Iif(X >=5, Transform(aConsulta[ 29, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 29, X ], "@!"), 1, 9),Transform(aConsulta[ 29, X ], "@!"))) + "  "
			Next
		Else
			cLabel29 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin29 := TSAY():Create(oDlg)
		oSayLin29:cName := "oSayLin29"
		oSayLin29:cCaption := cLabel29
		oSayLin29:nLeft := 10
		oSayLin29:nTop := nTopVar
		oSayLin29:nWidth := 375
		oSayLin29:nHeight := 17
		oSayLin29:lShowHint := .F.
		oSayLin29:lReadOnly := .F.
		oSayLin29:Align := 0
		oSayLin29:lVisibleControl := .T.
		oSayLin29:lWordWrap := .F.
		oSayLin29:lTransparent := .F.
		oSayLin29:SetFont( oFont )
		oSayLin29:nClrText := cColor(nImpar)
		If nTamArreyA >= 30
			For X := 1 To 6
				cLabel30 := cLabel30 + Iif(X >=5, Transform(aConsulta[ 30, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 30, X ], "@!"), 1, 9),Transform(aConsulta[ 30, X ], "@!"))) + "  "
			Next
		Else
			cLabel30 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin30 := TSAY():Create(oDlg)
		oSayLin30:cName := "oSayLin30"
		oSayLin30:cCaption := cLabel30
		oSayLin30:nLeft := 10
		oSayLin30:nTop := nTopVar
		oSayLin30:nWidth := 375
		oSayLin30:nHeight := 17
		oSayLin30:lShowHint := .F.
		oSayLin30:lReadOnly := .F.
		oSayLin30:Align := 0
		oSayLin30:lVisibleControl := .T.
		oSayLin30:lWordWrap := .F.
		oSayLin30:lTransparent := .F.
		oSayLin30:SetFont( oFont )
		oSayLin30:nClrText := cColor(nPar)
		If nTamArreyA >= 31
			For X := 1 To 6
				cLabel31 := cLabel31 + Iif(X >=5, Transform(aConsulta[ 31, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 31, X ], "@!"), 1, 9),Transform(aConsulta[ 31, X ], "@!"))) + "  "
			Next
		Else
			cLabel31 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin31 := TSAY():Create(oDlg)
		oSayLin31:cName := "oSayLin31"
		oSayLin31:cCaption := cLabel31
		oSayLin31:nLeft := 10
		oSayLin31:nTop := nTopVar
		oSayLin31:nWidth := 375
		oSayLin31:nHeight := 17
		oSayLin31:lShowHint := .F.
		oSayLin31:lReadOnly := .F.
		oSayLin31:Align := 0
		oSayLin31:lVisibleControl := .T.
		oSayLin31:lWordWrap := .F.
		oSayLin31:lTransparent := .F.
		oSayLin31:SetFont( oFont )
		oSayLin31:nClrText := cColor(nImpar)
		If nTamArreyA >= 32
			For X := 1 To 6
				cLabel32 := cLabel32 + Iif(X >=5, Transform(aConsulta[ 32, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 32, X ], "@!"), 1, 9),Transform(aConsulta[ 32, X ], "@!"))) + "  "
			Next
		Else
			cLabel32 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin32 := TSAY():Create(oDlg)
		oSayLin32:cName := "oSayLin32"
		oSayLin32:cCaption := cLabel32
		oSayLin32:nLeft := 10
		oSayLin32:nTop := nTopVar
		oSayLin32:nWidth := 375
		oSayLin32:nHeight := 17
		oSayLin32:lShowHint := .F.
		oSayLin32:lReadOnly := .F.
		oSayLin32:Align := 0
		oSayLin32:lVisibleControl := .T.
		oSayLin32:lWordWrap := .F.
		oSayLin32:lTransparent := .F.
		oSayLin32:SetFont( oFont )
		oSayLin32:nClrText := cColor(nPar)
		If nTamArreyA >= 33
			For X := 1 To 6
				cLabel33 := cLabel33 + Iif(X >=5, Transform(aConsulta[ 33, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 33, X ], "@!"), 1, 9),Transform(aConsulta[ 33, X ], "@!"))) + "  "
			Next
		Else
			cLabel33 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin33 := TSAY():Create(oDlg)
		oSayLin33:cName := "oSayLin33"
		oSayLin33:cCaption := cLabel33
		oSayLin33:nLeft := 10
		oSayLin33:nTop := nTopVar
		oSayLin33:nWidth := 375
		oSayLin33:nHeight := 17
		oSayLin33:lShowHint := .F.
		oSayLin33:lReadOnly := .F.
		oSayLin33:Align := 0
		oSayLin33:lVisibleControl := .T.
		oSayLin33:lWordWrap := .F.
		oSayLin33:lTransparent := .F.
		oSayLin33:SetFont( oFont )
		oSayLin33:nClrText := cColor(nImpar)
		If nTamArreyA >= 34
			For X := 1 To 6
				cLabel34 := cLabel34 + Iif(X >=5, Transform(aConsulta[ 34, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 34, X ], "@!"), 1, 9),Transform(aConsulta[ 34, X ], "@!"))) + "  "
			Next
		Else
			cLabel34 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin34 := TSAY():Create(oDlg)
		oSayLin34:cName := "oSayLin34"
		oSayLin34:cCaption := cLabel34
		oSayLin34:nLeft := 10
		oSayLin34:nTop := nTopVar
		oSayLin34:nWidth := 375
		oSayLin34:nHeight := 17
		oSayLin34:lShowHint := .F.
		oSayLin34:lReadOnly := .F.
		oSayLin34:Align := 0
		oSayLin34:lVisibleControl := .T.
		oSayLin34:lWordWrap := .F.
		oSayLin34:lTransparent := .F.
		oSayLin34:SetFont( oFont )
		oSayLin34:nClrText := cColor(nPar)
		If nTamArreyA >= 35
			For X := 1 To 6
				cLabel35 := cLabel35 + Iif(X >=5, Transform(aConsulta[ 35, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 35, X ], "@!"), 1, 9),Transform(aConsulta[ 35, X ], "@!"))) + "  "
			Next
		Else
			cLabel35 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin35 := TSAY():Create(oDlg)
		oSayLin35:cName := "oSayLin35"
		oSayLin35:cCaption := cLabel35
		oSayLin35:nLeft := 10
		oSayLin35:nTop := nTopVar
		oSayLin35:nWidth := 375
		oSayLin35:nHeight := 17
		oSayLin35:lShowHint := .F.
		oSayLin35:lReadOnly := .F.
		oSayLin35:Align := 0
		oSayLin35:lVisibleControl := .T.
		oSayLin35:lWordWrap := .F.
		oSayLin35:lTransparent := .F.
		oSayLin35:SetFont( oFont )
		oSayLin35:nClrText := cColor(nImpar)
		If nTamArreyA >= 36
			For X := 1 To 6
				cLabel36 := cLabel36 + Iif(X >=5, Transform(aConsulta[ 36, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 36, X ], "@!"), 1, 9),Transform(aConsulta[ 36, X ], "@!"))) + "  "
			Next
		Else
			cLabel36 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin36 := TSAY():Create(oDlg)
		oSayLin36:cName := "oSayLin36"
		oSayLin36:cCaption := cLabel36
		oSayLin36:nLeft := 10
		oSayLin36:nTop := nTopVar
		oSayLin36:nWidth := 375
		oSayLin36:nHeight := 17
		oSayLin36:lShowHint := .F.
		oSayLin36:lReadOnly := .F.
		oSayLin36:Align := 0
		oSayLin36:lVisibleControl := .T.
		oSayLin36:lWordWrap := .F.
		oSayLin36:lTransparent := .F.
		oSayLin36:SetFont( oFont )
		oSayLin36:nClrText := cColor(nPar)
		If nTamArreyA >= 37
			For X := 1 To 6
				cLabel37 := cLabel37 + Iif(X >=5, Transform(aConsulta[ 37, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 37, X ], "@!"), 1, 9),Transform(aConsulta[ 37, X ], "@!"))) + "  "
			Next
		Else
			cLabel37 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin37 := TSAY():Create(oDlg)
		oSayLin37:cName := "oSayLin37"
		oSayLin37:cCaption := cLabel37
		oSayLin37:nLeft := 10
		oSayLin37:nTop := nTopVar
		oSayLin37:nWidth := 375
		oSayLin37:nHeight := 17
		oSayLin37:lShowHint := .F.
		oSayLin37:lReadOnly := .F.
		oSayLin37:Align := 0
		oSayLin37:lVisibleControl := .T.
		oSayLin37:lWordWrap := .F.
		oSayLin37:lTransparent := .F.
		oSayLin37:SetFont( oFont )
		oSayLin37:nClrText := cColor(nImpar)
		If nTamArreyA >= 38
			For X := 1 To 6
				cLabel38 := cLabel38 + Iif(X >=5, Transform(aConsulta[ 38, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 38, X ], "@!"), 1, 9),Transform(aConsulta[ 38, X ], "@!"))) + "  "
			Next
		Else
			cLabel38 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin38 := TSAY():Create(oDlg)
		oSayLin38:cName := "oSayLin38"
		oSayLin38:cCaption := cLabel38
		oSayLin38:nLeft := 10
		oSayLin38:nTop := nTopVar
		oSayLin38:nWidth := 375
		oSayLin38:nHeight := 17
		oSayLin38:lShowHint := .F.
		oSayLin38:lReadOnly := .F.
		oSayLin38:Align := 0
		oSayLin38:lVisibleControl := .T.
		oSayLin38:lWordWrap := .F.
		oSayLin38:lTransparent := .F.
		oSayLin38:SetFont( oFont )
		oSayLin38:nClrText := cColor(nPar)
		If nTamArreyA >= 39
			For X := 1 To 6
				cLabel39 := cLabel39 + Iif(X >=5, Transform(aConsulta[ 39, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 39, X ], "@!"), 1, 9),Transform(aConsulta[ 39, X ], "@!"))) + "  "
			Next
		Else
			cLabel39 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin39 := TSAY():Create(oDlg)
		oSayLin39:cName := "oSayLin39"
		oSayLin39:cCaption := cLabel39
		oSayLin39:nLeft := 10
		oSayLin39:nTop := nTopVar
		oSayLin39:nWidth := 375
		oSayLin39:nHeight := 17
		oSayLin39:lShowHint := .F.
		oSayLin39:lReadOnly := .F.
		oSayLin39:Align := 0
		oSayLin39:lVisibleControl := .T.
		oSayLin39:lWordWrap := .F.
		oSayLin39:lTransparent := .F.
		oSayLin39:SetFont( oFont )
		oSayLin39:nClrText := cColor(nImpar)
		If nTamArreyA >= 40
			For X := 1 To 6
				cLabel40 := cLabel40 + Iif(X >=5, Transform(aConsulta[ 40, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 40, X ], "@!"), 1, 9),Transform(aConsulta[ 40, X ], "@!"))) + "  "
			Next
		Else
			cLabel40 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin40 := TSAY():Create(oDlg)
		oSayLin40:cName := "oSayLin40"
		oSayLin40:cCaption := cLabel40
		oSayLin40:nLeft := 10
		oSayLin40:nTop := nTopVar
		oSayLin40:nWidth := 375
		oSayLin40:nHeight := 17
		oSayLin40:lShowHint := .F.
		oSayLin40:lReadOnly := .F.
		oSayLin40:Align := 0
		oSayLin40:lVisibleControl := .T.
		oSayLin40:lWordWrap := .F.
		oSayLin40:lTransparent := .F.
		oSayLin40:SetFont( oFont )
		oSayLin40:nClrText := cColor(nPar)
		If nTamArreyA >= 41
			For X := 1 To 6
				cLabel41 := cLabel41 + Iif(X >=5, Transform(aConsulta[ 41, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 41, X ], "@!"), 1, 9),Transform(aConsulta[ 41, X ], "@!"))) + "  "
			Next
		Else
			cLabel41 := ""
		EndIf
		nTopVar := nTopVar + 13
		oSayLin41 := TSAY():Create(oDlg)
		oSayLin41:cName := "oSayLin41"
		oSayLin41:cCaption := cLabel41
		oSayLin41:nLeft := 10
		oSayLin41:nTop := nTopVar
		oSayLin41:nWidth := 375
		oSayLin41:nHeight := 17
		oSayLin41:lShowHint := .F.
		oSayLin41:lReadOnly := .F.
		oSayLin41:Align := 0
		oSayLin41:lVisibleControl := .T.
		oSayLin41:lWordWrap := .F.
		oSayLin41:lTransparent := .F.
		oSayLin41:SetFont( oFont )
		oSayLin41:nClrText := cColor(nImpar)
		If nTamArreyA >= 42
			For X := 1 To 6
				cLabel42 := cLabel42 + Iif(X >=5, Transform(aConsulta[ 42, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 42, X ], "@!"), 1, 9),Transform(aConsulta[ 42, X ], "@!"))) + "  "
			Next
		Else
			cLabel42 := ""
		EndIf
		oSayLin42 := TSAY():Create(oDlg)
		oSayLin42:cName := "oSayLin42"
		oSayLin42:cCaption := cLabel42
		oSayLin42:nLeft := 405
		oSayLin42:nTop := nTopVar2
		oSayLin42:nWidth := 375
		oSayLin42:nHeight := 17
		oSayLin42:lShowHint := .F.
		oSayLin42:lReadOnly := .F.
		oSayLin42:Align := 0
		oSayLin42:lVisibleControl := .T.
		oSayLin42:lWordWrap := .F.
		oSayLin42:lTransparent := .F.
		oSayLin42:SetFont( oFont )
		oSayLin42:nClrText := cColor(nPar)
		If nTamArreyA >= 43
			For X := 1 To 6
				cLabel43 := cLabel43 + Iif(X >=5, Transform(aConsulta[ 43, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 43, X ], "@!"), 1, 9),Transform(aConsulta[ 43, X ], "@!"))) + "  "
			Next
		Else
			cLabel43 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin43 := TSAY():Create(oDlg)
		oSayLin43:cName := "oSayLin43"
		oSayLin43:cCaption := cLabel43
		oSayLin43:nLeft := 405
		oSayLin43:nTop := nTopVar2
		oSayLin43:nWidth := 375
		oSayLin43:nHeight := 17
		oSayLin43:lShowHint := .F.
		oSayLin43:lReadOnly := .F.
		oSayLin43:Align := 0
		oSayLin43:lVisibleControl := .T.
		oSayLin43:lWordWrap := .F.
		oSayLin43:lTransparent := .F.
		oSayLin43:SetFont( oFont )
		oSayLin43:nClrText := cColor(nImpar)
		If nTamArreyA >= 44
			For X := 1 To 6
				cLabel44 := cLabel44 + Iif(X >=5, Transform(aConsulta[ 44, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 44, X ], "@!"), 1, 9),Transform(aConsulta[ 44, X ], "@!"))) + "  "
			Next
		Else
			cLabel44 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin44 := TSAY():Create(oDlg)
		oSayLin44:cName := "oSayLin44"
		oSayLin44:cCaption := cLabel44
		oSayLin44:nLeft := 405
		oSayLin44:nTop := nTopVar2
		oSayLin44:nWidth := 375
		oSayLin44:nHeight := 17
		oSayLin44:lShowHint := .F.
		oSayLin44:lReadOnly := .F.
		oSayLin44:Align := 0
		oSayLin44:lVisibleControl := .T.
		oSayLin44:lWordWrap := .F.
		oSayLin44:lTransparent := .F.
		oSayLin44:SetFont( oFont )
		oSayLin44:nClrText := cColor(nPar)
		If nTamArreyA >= 45
			For X := 1 To 6
				cLabel45 := cLabel45 + Iif(X >=5, Transform(aConsulta[ 45, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 45, X ], "@!"), 1, 9),Transform(aConsulta[ 45, X ], "@!"))) + "  "
			Next
		Else
			cLabel45 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin45 := TSAY():Create(oDlg)
		oSayLin45:cName := "oSayLin45"
		oSayLin45:cCaption := cLabel45
		oSayLin45:nLeft := 405
		oSayLin45:nTop := nTopVar2
		oSayLin45:nWidth := 375
		oSayLin45:nHeight := 17
		oSayLin45:lShowHint := .F.
		oSayLin45:lReadOnly := .F.
		oSayLin45:Align := 0
		oSayLin45:lVisibleControl := .T.
		oSayLin45:lWordWrap := .F.
		oSayLin45:lTransparent := .F.
		oSayLin45:SetFont( oFont )
		oSayLin45:nClrText := cColor(nImpar)
		If nTamArreyA >= 46
			For X := 1 To 6
				cLabel46 := cLabel46 + Iif(X >=5, Transform(aConsulta[ 46, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 46, X ], "@!"), 1, 9),Transform(aConsulta[ 46, X ], "@!"))) + "  "
			Next
		Else
			cLabel46 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin46 := TSAY():Create(oDlg)
		oSayLin46:cName := "oSayLin46"
		oSayLin46:cCaption := cLabel46
		oSayLin46:nLeft := 405
		oSayLin46:nTop := nTopVar2
		oSayLin46:nWidth := 375
		oSayLin46:nHeight := 17
		oSayLin46:lShowHint := .F.
		oSayLin46:lReadOnly := .F.
		oSayLin46:Align := 0
		oSayLin46:lVisibleControl := .T.
		oSayLin46:lWordWrap := .F.
		oSayLin46:lTransparent := .F.
		oSayLin46:SetFont( oFont )
		oSayLin46:nClrText := cColor(nPar)
		If nTamArreyA >= 47
			For X := 1 To 6
				cLabel47 := cLabel47 + Iif(X >=5, Transform(aConsulta[ 47, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 47, X ], "@!"), 1, 9),Transform(aConsulta[ 47, X ], "@!"))) + "  "
			Next
		Else
			cLabel47 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin47 := TSAY():Create(oDlg)
		oSayLin47:cName := "oSayLin47"
		oSayLin47:cCaption := cLabel47
		oSayLin47:nLeft := 405
		oSayLin47:nTop := nTopVar2
		oSayLin47:nWidth := 375
		oSayLin47:nHeight := 17
		oSayLin47:lShowHint := .F.
		oSayLin47:lReadOnly := .F.
		oSayLin47:Align := 0
		oSayLin47:lVisibleControl := .T.
		oSayLin47:lWordWrap := .F.
		oSayLin47:lTransparent := .F.
		oSayLin47:SetFont( oFont )
		oSayLin47:nClrText := cColor(nImpar)
		If nTamArreyA >= 48
			For X := 1 To 6
				cLabel48 := cLabel48 + Iif(X >=5, Transform(aConsulta[ 48, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 48, X ], "@!"), 1, 9),Transform(aConsulta[ 48, X ], "@!"))) + "  "
			Next
		Else
			cLabel48 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin48 := TSAY():Create(oDlg)
		oSayLin48:cName := "oSayLin48"
		oSayLin48:cCaption := cLabel48
		oSayLin48:nLeft := 405
		oSayLin48:nTop := nTopVar2
		oSayLin48:nWidth := 375
		oSayLin48:nHeight := 17
		oSayLin48:lShowHint := .F.
		oSayLin48:lReadOnly := .F.
		oSayLin48:Align := 0
		oSayLin48:lVisibleControl := .T.
		oSayLin48:lWordWrap := .F.
		oSayLin48:lTransparent := .F.
		oSayLin48:SetFont( oFont )
		oSayLin48:nClrText := cColor(nPar)
		If nTamArreyA >= 49
			For X := 1 To 6
				cLabel49 := cLabel49 + Iif(X >=5, Transform(aConsulta[ 49, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 49, X ], "@!"), 1, 9),Transform(aConsulta[ 49, X ], "@!"))) + "  "
			Next
		Else
			cLabel49 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin49 := TSAY():Create(oDlg)
		oSayLin49:cName := "oSayLin49"
		oSayLin49:cCaption := cLabel49
		oSayLin49:nLeft := 405
		oSayLin49:nTop := nTopVar2
		oSayLin49:nWidth := 375
		oSayLin49:nHeight := 17
		oSayLin49:lShowHint := .F.
		oSayLin49:lReadOnly := .F.
		oSayLin49:Align := 0
		oSayLin49:lVisibleControl := .T.
		oSayLin49:lWordWrap := .F.
		oSayLin49:lTransparent := .F.
		oSayLin49:SetFont( oFont )
		oSayLin49:nClrText := cColor(nImpar)
		If nTamArreyA >= 50
			For X := 1 To 6
				cLabel50 := cLabel50 + Iif(X >=5, Transform(aConsulta[ 50, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 50, X ], "@!"), 1, 9),Transform(aConsulta[ 50, X ], "@!"))) + "  "
			Next
		Else
			cLabel50 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin50 := TSAY():Create(oDlg)
		oSayLin50:cName := "oSayLin50"
		oSayLin50:cCaption := cLabel50
		oSayLin50:nLeft := 405
		oSayLin50:nTop := nTopVar2
		oSayLin50:nWidth := 375
		oSayLin50:nHeight := 17
		oSayLin50:lShowHint := .F.
		oSayLin50:lReadOnly := .F.
		oSayLin50:Align := 0
		oSayLin50:lVisibleControl := .T.
		oSayLin50:lWordWrap := .F.
		oSayLin50:lTransparent := .F.
		oSayLin50:SetFont( oFont )
		oSayLin50:nClrText := cColor(nPar)
		If nTamArreyA >= 51
			For X := 1 To 6
				cLabel51 := cLabel51 + Iif(X >=5, Transform(aConsulta[ 51, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 51, X ], "@!"), 1, 9),Transform(aConsulta[ 51, X ], "@!"))) + "  "
			Next
		Else
			cLabel51 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin51 := TSAY():Create(oDlg)
		oSayLin51:cName := "oSayLin51"
		oSayLin51:cCaption := cLabel51
		oSayLin51:nLeft := 405
		oSayLin51:nTop := nTopVar2
		oSayLin51:nWidth := 375
		oSayLin51:nHeight := 17
		oSayLin51:lShowHint := .F.
		oSayLin51:lReadOnly := .F.
		oSayLin51:Align := 0
		oSayLin51:lVisibleControl := .T.
		oSayLin51:lWordWrap := .F.
		oSayLin51:lTransparent := .F.
		oSayLin51:SetFont( oFont )
		oSayLin51:nClrText := cColor(nImpar)
		If nTamArreyA >= 52
			For X := 1 To 6
				cLabel52 := cLabel52 + Iif(X >=5, Transform(aConsulta[ 52, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 52, X ], "@!"), 1, 9),Transform(aConsulta[ 52, X ], "@!"))) + "  "
			Next
		Else
			cLabel52 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin52 := TSAY():Create(oDlg)
		oSayLin52:cName := "oSayLin52"
		oSayLin52:cCaption := cLabel52
		oSayLin52:nLeft := 405
		oSayLin52:nTop := nTopVar2
		oSayLin52:nWidth := 375
		oSayLin52:nHeight := 17
		oSayLin52:lShowHint := .F.
		oSayLin52:lReadOnly := .F.
		oSayLin52:Align := 0
		oSayLin52:lVisibleControl := .T.
		oSayLin52:lWordWrap := .F.
		oSayLin52:lTransparent := .F.
		oSayLin52:SetFont( oFont )
		oSayLin52:nClrText := cColor(nPar)
		If nTamArreyA >= 53
			For X := 1 To 6
				cLabel53 := cLabel53 + Iif(X >=5, Transform(aConsulta[ 53, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 53, X ], "@!"), 1, 9),Transform(aConsulta[ 53, X ], "@!"))) + "  "
			Next
		Else
			cLabel53 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin53 := TSAY():Create(oDlg)
		oSayLin53:cName := "oSayLin53"
		oSayLin53:cCaption := cLabel53
		oSayLin53:nLeft := 405
		oSayLin53:nTop := nTopVar2
		oSayLin53:nWidth := 375
		oSayLin53:nHeight := 17
		oSayLin53:lShowHint := .F.
		oSayLin53:lReadOnly := .F.
		oSayLin53:Align := 0
		oSayLin53:lVisibleControl := .T.
		oSayLin53:lWordWrap := .F.
		oSayLin53:lTransparent := .F.
		oSayLin53:SetFont( oFont )
		oSayLin53:nClrText := cColor(nImpar)
		If nTamArreyA >= 54
			For X := 1 To 6
				cLabel54 := cLabel54 + Iif(X >=5, Transform(aConsulta[ 54, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 54, X ], "@!"), 1, 9),Transform(aConsulta[ 54, X ], "@!"))) + "  "
			Next
		Else
			cLabel54 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin54 := TSAY():Create(oDlg)
		oSayLin54:cName := "oSayLin54"
		oSayLin54:cCaption := cLabel54
		oSayLin54:nLeft := 405
		oSayLin54:nTop := nTopVar2
		oSayLin54:nWidth := 375
		oSayLin54:nHeight := 17
		oSayLin54:lShowHint := .F.
		oSayLin54:lReadOnly := .F.
		oSayLin54:Align := 0
		oSayLin54:lVisibleControl := .T.
		oSayLin54:lWordWrap := .F.
		oSayLin54:lTransparent := .F.
		oSayLin54:SetFont( oFont )
		oSayLin54:nClrText := cColor(nPar)
		If nTamArreyA >= 55
			For X := 1 To 6
				cLabel55 := cLabel55 + Iif(X >=5, Transform(aConsulta[ 55, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 55, X ], "@!"), 1, 9),Transform(aConsulta[ 55, X ], "@!"))) + "  "
			Next
		Else
			cLabel55 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin55 := TSAY():Create(oDlg)
		oSayLin55:cName := "oSayLin55"
		oSayLin55:cCaption := cLabel55
		oSayLin55:nLeft := 405
		oSayLin55:nTop := nTopVar2
		oSayLin55:nWidth := 375
		oSayLin55:nHeight := 17
		oSayLin55:lShowHint := .F.
		oSayLin55:lReadOnly := .F.
		oSayLin55:Align := 0
		oSayLin55:lVisibleControl := .T.
		oSayLin55:lWordWrap := .F.
		oSayLin55:lTransparent := .F.
		oSayLin55:SetFont( oFont )
		oSayLin55:nClrText := cColor(nImpar)
		If nTamArreyA >= 56
			For X := 1 To 6
				cLabel56 := cLabel56 + Iif(X >=5, Transform(aConsulta[ 56, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 56, X ], "@!"), 1, 9),Transform(aConsulta[ 56, X ], "@!"))) + "  "
			Next
		Else
			cLabel56 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin56 := TSAY():Create(oDlg)
		oSayLin56:cName := "oSayLin56"
		oSayLin56:cCaption := cLabel56
		oSayLin56:nLeft := 405
		oSayLin56:nTop := nTopVar2
		oSayLin56:nWidth := 375
		oSayLin56:nHeight := 17
		oSayLin56:lShowHint := .F.
		oSayLin56:lReadOnly := .F.
		oSayLin56:Align := 0
		oSayLin56:lVisibleControl := .T.
		oSayLin56:lWordWrap := .F.
		oSayLin56:lTransparent := .F.
		oSayLin56:SetFont( oFont )
		oSayLin56:nClrText := cColor(nPar)
		If nTamArreyA >= 57
			For X := 1 To 6
				cLabel57 := cLabel57 + Iif(X >=5, Transform(aConsulta[ 57, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 57, X ], "@!"), 1, 9),Transform(aConsulta[ 57, X ], "@!"))) + "  "
			Next
		Else
			cLabel57 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin57 := TSAY():Create(oDlg)
		oSayLin57:cName := "oSayLin57"
		oSayLin57:cCaption := cLabel57
		oSayLin57:nLeft := 405
		oSayLin57:nTop := nTopVar2
		oSayLin57:nWidth := 375
		oSayLin57:nHeight := 17
		oSayLin57:lShowHint := .F.
		oSayLin57:lReadOnly := .F.
		oSayLin57:Align := 0
		oSayLin57:lVisibleControl := .T.
		oSayLin57:lWordWrap := .F.
		oSayLin57:lTransparent := .F.
		oSayLin57:SetFont( oFont )
		oSayLin57:nClrText := cColor(nImpar)
		If nTamArreyA >= 58
			For X := 1 To 6
				cLabel58 := cLabel58 + Iif(X >=5, Transform(aConsulta[ 58, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 58, X ], "@!"), 1, 9),Transform(aConsulta[ 58, X ], "@!"))) + "  "
			Next
		Else
			cLabel58 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin58 := TSAY():Create(oDlg)
		oSayLin58:cName := "oSayLin58"
		oSayLin58:cCaption := cLabel58
		oSayLin58:nLeft := 405
		oSayLin58:nTop := nTopVar2
		oSayLin58:nWidth := 375
		oSayLin58:nHeight := 17
		oSayLin58:lShowHint := .F.
		oSayLin58:lReadOnly := .F.
		oSayLin58:Align := 0
		oSayLin58:lVisibleControl := .T.
		oSayLin58:lWordWrap := .F.
		oSayLin58:lTransparent := .F.
		oSayLin58:SetFont( oFont )
		oSayLin58:nClrText := cColor(nPar)
		If nTamArreyA >= 59
			For X := 1 To 6
				cLabel59 := cLabel59 + Iif(X >=5, Transform(aConsulta[ 59, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 59, X ], "@!"), 1, 9),Transform(aConsulta[ 59, X ], "@!"))) + "  "
			Next
		Else
			cLabel59 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin59 := TSAY():Create(oDlg)
		oSayLin59:cName := "oSayLin59"
		oSayLin59:cCaption := cLabel59
		oSayLin59:nLeft := 405
		oSayLin59:nTop := nTopVar2
		oSayLin59:nWidth := 375
		oSayLin59:nHeight := 17
		oSayLin59:lShowHint := .F.
		oSayLin59:lReadOnly := .F.
		oSayLin59:Align := 0
		oSayLin59:lVisibleControl := .T.
		oSayLin59:lWordWrap := .F.
		oSayLin59:lTransparent := .F.
		oSayLin59:SetFont( oFont )
		oSayLin59:nClrText := cColor(nImpar)
		If nTamArreyA >= 60
			For X := 1 To 6
				cLabel60 := cLabel60 + Iif(X >=5, Transform(aConsulta[ 60, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 60, X ], "@!"), 1, 9),Transform(aConsulta[ 60, X ], "@!"))) + "  "
			Next
		Else
			cLabel60 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin60 := TSAY():Create(oDlg)
		oSayLin60:cName := "oSayLin60"
		oSayLin60:cCaption := cLabel60
		oSayLin60:nLeft := 405
		oSayLin60:nTop := nTopVar2
		oSayLin60:nWidth := 375
		oSayLin60:nHeight := 17
		oSayLin60:lShowHint := .F.
		oSayLin60:lReadOnly := .F.
		oSayLin60:Align := 0
		oSayLin60:lVisibleControl := .T.
		oSayLin60:lWordWrap := .F.
		oSayLin60:lTransparent := .F.
		oSayLin60:SetFont( oFont )
		oSayLin60:nClrText := cColor(nPar)
		If nTamArreyA >= 61
			For X := 1 To 6
				cLabel61 := cLabel61 + Iif(X >=5, Transform(aConsulta[ 61, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 61, X ], "@!"), 1, 9),Transform(aConsulta[ 61, X ], "@!"))) + "  "
			Next
		Else
			cLabel61 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin61 := TSAY():Create(oDlg)
		oSayLin61:cName := "oSayLin61"
		oSayLin61:cCaption := cLabel61
		oSayLin61:nLeft := 405
		oSayLin61:nTop := nTopVar2
		oSayLin61:nWidth := 375
		oSayLin61:nHeight := 17
		oSayLin61:lShowHint := .F.
		oSayLin61:lReadOnly := .F.
		oSayLin61:Align := 0
		oSayLin61:lVisibleControl := .T.
		oSayLin61:lWordWrap := .F.
		oSayLin61:lTransparent := .F.
		oSayLin61:SetFont( oFont )
		oSayLin61:nClrText := cColor(nImpar)
		If nTamArreyA >= 62
			For X := 1 To 6
				cLabel62 := cLabel62 + Iif(X >=5, Transform(aConsulta[ 62, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 62, X ], "@!"), 1, 9),Transform(aConsulta[ 62, X ], "@!"))) + "  "
			Next
		Else
			cLabel62 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin62 := TSAY():Create(oDlg)
		oSayLin62:cName := "oSayLin62"
		oSayLin62:cCaption := cLabel62
		oSayLin62:nLeft := 405
		oSayLin62:nTop := nTopVar2
		oSayLin62:nWidth := 375
		oSayLin62:nHeight := 17
		oSayLin62:lShowHint := .F.
		oSayLin62:lReadOnly := .F.
		oSayLin62:Align := 0
		oSayLin62:lVisibleControl := .T.
		oSayLin62:lWordWrap := .F.
		oSayLin62:lTransparent := .F.
		oSayLin62:SetFont( oFont )
		oSayLin62:nClrText := cColor(nPar)
		If nTamArreyA >= 63
			For X := 1 To 6
				cLabel63 := cLabel63 + Iif(X >=5, Transform(aConsulta[ 63, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 63, X ], "@!"), 1, 9),Transform(aConsulta[ 63, X ], "@!"))) + "  "
			Next
		Else
			cLabel63 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin63 := TSAY():Create(oDlg)
		oSayLin63:cName := "oSayLin63"
		oSayLin63:cCaption := cLabel63
		oSayLin63:nLeft := 405
		oSayLin63:nTop := nTopVar2
		oSayLin63:nWidth := 375
		oSayLin63:nHeight := 17
		oSayLin63:lShowHint := .F.
		oSayLin63:lReadOnly := .F.
		oSayLin63:Align := 0
		oSayLin63:lVisibleControl := .T.
		oSayLin63:lWordWrap := .F.
		oSayLin63:lTransparent := .F.
		oSayLin63:SetFont( oFont )
		oSayLin63:nClrText := cColor(nImpar)
		If nTamArreyA >= 64
			For X := 1 To 6
				cLabel64 := cLabel64 + Iif(X >=5, Transform(aConsulta[ 64, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 64, X ], "@!"), 1, 9),Transform(aConsulta[ 64, X ], "@!"))) + "  "
			Next
		Else
			cLabel64 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin64 := TSAY():Create(oDlg)
		oSayLin64:cName := "oSayLin64"
		oSayLin64:cCaption := cLabel64
		oSayLin64:nLeft := 405
		oSayLin64:nTop := nTopVar2
		oSayLin64:nWidth := 375
		oSayLin64:nHeight := 17
		oSayLin64:lShowHint := .F.
		oSayLin64:lReadOnly := .F.
		oSayLin64:Align := 0
		oSayLin64:lVisibleControl := .T.
		oSayLin64:lWordWrap := .F.
		oSayLin64:lTransparent := .F.
		oSayLin64:SetFont( oFont )
		oSayLin64:nClrText := cColor(nPar)
		If nTamArreyA >= 65
			For X := 1 To 6
				cLabel65 := cLabel65 + Iif(X >=5, Transform(aConsulta[ 65, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 65, X ], "@!"), 1, 9),Transform(aConsulta[ 65, X ], "@!"))) + "  "
			Next
		Else
			cLabel65 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin65 := TSAY():Create(oDlg)
		oSayLin65:cName := "oSayLin65"
		oSayLin65:cCaption := cLabel65
		oSayLin65:nLeft := 405
		oSayLin65:nTop := nTopVar2
		oSayLin65:nWidth := 375
		oSayLin65:nHeight := 17
		oSayLin65:lShowHint := .F.
		oSayLin65:lReadOnly := .F.
		oSayLin65:Align := 0
		oSayLin65:lVisibleControl := .T.
		oSayLin65:lWordWrap := .F.
		oSayLin65:lTransparent := .F.
		oSayLin65:SetFont( oFont )
		oSayLin65:nClrText := cColor(nImpar)
		If nTamArreyA >= 66
			For X := 1 To 6
				cLabel66 := cLabel66 + Iif(X >=5, Transform(aConsulta[ 66, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 66, X ], "@!"), 1, 9),Transform(aConsulta[ 66, X ], "@!"))) + "  "
			Next
		Else
			cLabel66 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin66 := TSAY():Create(oDlg)
		oSayLin66:cName := "oSayLin66"
		oSayLin66:cCaption := cLabel66
		oSayLin66:nLeft := 405
		oSayLin66:nTop := nTopVar2
		oSayLin66:nWidth := 375
		oSayLin66:nHeight := 17
		oSayLin66:lShowHint := .F.
		oSayLin66:lReadOnly := .F.
		oSayLin66:Align := 0
		oSayLin66:lVisibleControl := .T.
		oSayLin66:lWordWrap := .F.
		oSayLin66:lTransparent := .F.
		oSayLin66:SetFont( oFont )
		oSayLin66:nClrText := cColor(nPar)
		If nTamArreyA >= 67
			For X := 1 To 6
				cLabel67 := cLabel67 + Iif(X >=5, Transform(aConsulta[ 67, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 67, X ], "@!"), 1, 9),Transform(aConsulta[ 67, X ], "@!"))) + "  "
			Next
		Else
			cLabel67 := ""
		EndIf
		nTopVar2 := nTopVar2 + 13
		oSayLin67 := TSAY():Create(oDlg)
		oSayLin67:cName := "oSayLin67"
		oSayLin67:cCaption := cLabel67
		oSayLin67:nLeft := 405
		oSayLin67:nTop := nTopVar2
		oSayLin67:nWidth := 375
		oSayLin67:nHeight := 17
		oSayLin67:lShowHint := .F.
		oSayLin67:lReadOnly := .F.
		oSayLin67:Align := 0
		oSayLin67:lVisibleControl := .T.
		oSayLin67:lWordWrap := .F.
		oSayLin67:lTransparent := .F.
		oSayLin67:SetFont( oFont )
		oSayLin67:nClrText := cColor(nImpar)

	Else
		Alert("Nao existem produtos (PA) pesados entre " + DtoC(Date() - 3) + " e " + DtoC(Date()) + " .")
		oSBtn1:lVisibleControl := .F.
		ObjectMethod( oSBtn1, "Refresh()" )
	EndIf

Return

************
Static Function cColor(cCont)
************

	If Mod(cCont, 2) == 0
		Color := CLR_BLUE//CLR_HGREEN
	Else
		Color := CLR_HBLUE//CLR_GREEN
	EndIf

Return Color

************
Static Function CONSULTA()
************

local dDataIni := dDataBase - 3
//local dDataFim := dDataIni - 3
dbSelectArea('SD3')
SD3->( dbSetOrder( 12 ) )
public aConsulta := {}

cQuery := "SELECT SC2.C2_PRODUTO, Z00.Z00_CODBAR AS COD_BARRA, Z00.Z00_HORA, Z00.Z00_DATA, Z00_QUANT, SB2.B2_QATU "
cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00, " + RetSqlName( "SC2" ) + " SC2, " + RetSqlName( "SB2" ) + " SB2 "
cQuery += "WHERE SUBSTRING(Z00.Z00_OP,1,6) = SC2.C2_NUM AND SUBSTRING(Z00.Z00_OP,7,2) = SC2.C2_ITEM AND SUBSTRING(Z00.Z00_OP,9,3) = SC2.C2_SEQUEN "

//cQuery += "AND Z00.Z00_DATA >= '" + Dtos(dDataFim) + "' AND Z00.Z00_DATA <= '" + Dtos(dDataIni) + "' AND SC2.C2_PRODUTO NOT LIKE 'ME%' "
//cQuery += "AND Z00.Z00_DATA >= '"+dtos(dDataIni)+"' "
/*
cQuery += "AND NOT EXISTS(select SD3.D3_ESTORNO from  " + RetSqlName("SD3") + " SD3 "
cQuery += "where  SD3.D3_CODBAR = Z00.Z00_CODBAR AND SD3.D3_ESTORNO = 'S' "
cQuery += "AND SD3.D3_FILIAL  = '" + xFilial("SD3") + "' AND SD3.D_E_L_E_T_ = ' ') "
*/
/* 27/05/2009 */
//cQuery += "AND SB2.B2_COD "+if(alltrim(cBuffer) == "CX","","NOT")+" like 'C[LMNOP]%' "   //Retirado a pedido de Alexandre, chamado 001190 ( RECOLOCADO EM 25/11/2009 CHAMADO 001418 ) 
cQuery += "AND Z00.Z00_MAQ "+if(alltrim(cBuffer) == "CX","","NOT")+"  IN('CX','ICVR','MONT','TRIMAQ','CVP','PLAST','A01') "



/* 27/05/2009 */
cQuery += "AND SB2.B2_LOCAL  = '01'"
cQuery += "AND Z00.Z00_BAIXA <> 'S' AND Z00_QUANT > 0 AND SC2.C2_PRODUTO = SB2.B2_COD "
cQuery += "AND SB2.B2_FILIAL  = '" + xFilial( "SB2" ) + "' AND SB2.D_E_L_E_T_ = ' ' "
cQuery += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQuery += "AND SC2.C2_FILIAL  = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY Z00.Z00_DATA, SC2.C2_PRODUTO "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SZ0X"
TCSetField( 'SZ0X', "C2_PRODUTO", "C" )
TCSetField( 'SZ0X', "Z00_DATA", "D" )
TCSetField( 'SZ0X', "Z00_QUANT", "N", 5, 0 )
TCSetField( 'SZ0X', "B2_QATU", "N", 5, 2 )
SZ0X->( DBGoTop() )

DbSelectArea("SD3")
DbSetOrder(12)
Do While ! SZ0X->( Eof() )
 if SD3->(DbSeek(xFilial("SD3")+SZ0X->COD_BARRA)) .AND. SD3->D3_ESTORNO = 'S'
    SZ0X->( dbskip() )
    Loop
 endif   
 Aadd( aConsulta, { SZ0X->C2_PRODUTO, Alltrim(SZ0X->COD_BARRA), SZ0X->Z00_HORA, SZ0X->Z00_DATA, SZ0X->Z00_QUANT, SZ0X->B2_QATU } )
 SZ0X->( dbskip() )
EndDo

SD3->( dbCloseArea() )
SZ0X->( DbCloseArea() )

Return (aConsulta)

***************
Static Function estornd(cCdBarra)
***************

cQuery2 := "SELECT SD3.D3_ESTORNO FROM " + RetSqlName("SD3") + " SD3 "
cQuery2 += "WHERE (substring(SD3.D3_OP,1,6) + substring(SD3.D3_OBS,12,6)) = '" + alltrim(cCdBarra) + "' "
cQuery2 += "AND SD3.D3_ESTORNO = 'S' "
//cQuery2 := ChangeQuery( cQuery2 )
TCQUERY cQuery2 NEW ALIAS "TMP"
TMP->( DbGoTop() )
/*Se houve um estorno, .T., qualquer outra coisa, .F.*/
If	TMP->( EoF() )
	TMP->( DbCloseArea() )
	Return .F.
Else
	TMP->( DbCloseArea() )
	Return .T.
EndIf

************
Static Function Atualiza()
************

local cLabel1 := cLabel2 := cLabel3 := cLabel4 := cLabel5 := cLabel6 := cLabel7 := cLabel8 := cLabel9 := cLabel10 := ""
local cLabel11 := cLabel12 := cLabel13 := cLabel14 := cLabel15 := cLabel16 := cLabel17 := cLabel18 := cLabel19 := cLabel20 := ""
local cLabel21 := cLabel22 := cLabel23 := cLabel24 := cLabel25 := cLabel26 := cLabel27 := cLabel28 := cLabel29 := cLabel30 := ""
local cLabel31 := cLabel32 := cLabel33 := cLabel34 := cLabel35 := cLabel36 := cLabel37 := cLabel38 := cLabel39 := cLabel40 := ""
local cLabel41 := cLabel42 := cLabel43 := cLabel44 := cLabel45 := cLabel46 := cLabel47 := cLabel48 := cLabel49 := cLabel50 := ""
local cLabel51 := cLabel52 := cLabel53 := cLabel54 := cLabel55 := cLabel56 := cLabel57 := cLabel58 := cLabel59 := cLabel60 := ""
local cLabel61 := cLabel62 := cLabel63 := cLabel64 := cLabel65 := cLabel66 := cLabel67 := ""
local nImpar := 1
local nPar := 2
local nTamArrey

CONSULTA()

nTamArrey := Len(aConsulta)

	If nTamArrey >= 1
		For X := 1 To 6
			cLabel1 := cLabel1 + Iif(X >=5, Transform(aConsulta[ 1, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 1, X ], "@!"), 1, 9),Transform(aConsulta[ 1, X ], "@!"))) + "  "
		Next
		oSayLin1:cCaption := cLabel1
		oSayLin1:nClrText := cColor(nImpar)
	Else
		oSayLin1:cCaption := ""
	EndIf
	If nTamArrey >= 2
		For X := 1 To 6
			cLabel2 := cLabel2 + Iif(X >=5, Transform(aConsulta[ 2, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 2, X ], "@!"), 1, 9),Transform(aConsulta[ 2, X ], "@!"))) + "  "
		Next
		oSayLin2:cCaption := cLabel2
		oSayLin2:nClrText := cColor(nPar)
	Else
		oSayLin2:cCaption := ""
	EndIf
	If nTamArrey >= 3
		For X := 1 To 6
			cLabel3 := cLabel3 + Iif(X >=5, Transform(aConsulta[ 3, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 3, X ], "@!"), 1, 9),Transform(aConsulta[ 3, X ], "@!"))) + "  "
		Next
		oSayLin3:cCaption := cLabel3
		oSayLin3:nClrText := cColor(nImpar)
	Else
		oSayLin3:cCaption := ""
	EndIf
	If nTamArrey >= 4
		For X := 1 To 6
			cLabel4 := cLabel4 + Iif(X >=5, Transform(aConsulta[ 4, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 4, X ], "@!"), 1, 9),Transform(aConsulta[ 4, X ], "@!"))) + "  "
		Next
		oSayLin4:cCaption := cLabel4
		oSayLin4:nClrText := cColor(nPar)
	Else
		oSayLin4:cCaption := ""
	EndIf
	If nTamArrey >= 5
		For X := 1 To 6
			cLabel5 := cLabel5 + Iif(X >=5, Transform(aConsulta[ 5, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 5, X ], "@!"), 1, 9),Transform(aConsulta[ 5, X ], "@!"))) + "  "
		Next
		oSayLin5:cCaption := cLabel5
		oSayLin5:nClrText := cColor(nImpar)
	Else
		oSayLin5:cCaption := ""
	EndIf
	If nTamArrey >= 6
		For X := 1 To 6
			cLabel6 := cLabel6 + Iif(X >=5, Transform(aConsulta[ 6, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 6, X ], "@!"), 1, 9),Transform(aConsulta[ 6, X ], "@!"))) + "  "
		Next
		oSayLin6:cCaption := cLabel6
		oSayLin6:nClrText := cColor(nPar)
	Else
		oSayLin6:cCaption := ""
	EndIf
	If nTamArrey >= 7
		For X := 1 To 6
			cLabel7 := cLabel7 + Iif(X >=5, Transform(aConsulta[ 7, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 7, X ], "@!"), 1, 9),Transform(aConsulta[ 7, X ], "@!"))) + "  "
		Next
		oSayLin7:cCaption := cLabel7
		oSayLin7:nClrText := cColor(nImpar)
	Else
		oSayLin7:cCaption := ""
	EndIf
	If nTamArrey >= 8
		For X := 1 To 6
			cLabel8 := cLabel8 + Iif(X >=5, Transform(aConsulta[ 8, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 8, X ], "@!"), 1, 9),Transform(aConsulta[ 8, X ], "@!"))) + "  "
		Next
		oSayLin8:cCaption := cLabel8
		oSayLin8:nClrText := cColor(nPar)
	Else
		oSayLin8:cCaption := ""
	EndIf
	If nTamArrey >= 9
		For X := 1 To 6
			cLabel9 := cLabel9 + Iif(X >=5, Transform(aConsulta[ 9, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 9, X ], "@!"), 1, 9),Transform(aConsulta[ 9, X ], "@!"))) + "  "
		Next
		oSayLin9:cCaption := cLabel9
		oSayLin9:nClrText := cColor(nImpar)
	Else
		oSayLin9:cCaption := ""
	EndIf
	If nTamArrey >= 10
		For X := 1 To 6
			cLabel10 := cLabel10 + Iif(X >=5, Transform(aConsulta[ 10, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 10, X ], "@!"), 1, 9),Transform(aConsulta[ 10, X ], "@!"))) + "  "
		Next
		oSayLin10:cCaption := cLabel10
		oSayLin10:nClrText := cColor(nPar)
	Else
		oSayLin10:cCaption := ""
	EndIf
	If nTamArrey >= 11
		For X := 1 To 6
			cLabel11 := cLabel11 + Iif(X >=5, Transform(aConsulta[ 11, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 11, X ], "@!"), 1, 9),Transform(aConsulta[ 11, X ], "@!"))) + "  "
		Next
		oSayLin11:cCaption := cLabel11
		oSayLin11:nClrText := cColor(nImpar)
	Else
		oSayLin11:cCaption := ""
	EndIf
	If nTamArrey >= 12
		For X := 1 To 6
			cLabel12 := cLabel12 + Iif(X >=5, Transform(aConsulta[ 12, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 12, X ], "@!"), 1, 9),Transform(aConsulta[ 12, X ], "@!"))) + "  "
		Next
		oSayLin12:cCaption := cLabel12
		oSayLin12:nClrText := cColor(nPar)
	Else
		oSayLin12:cCaption := ""
	EndIf
	If nTamArrey >= 13
		For X := 1 To 6
			cLabel13 := cLabel13 + Iif(X >=5, Transform(aConsulta[ 13, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 13, X ], "@!"), 1, 9),Transform(aConsulta[ 13, X ], "@!"))) + "  "
		Next
		oSayLin13:cCaption := cLabel13
		oSayLin13:nClrText := cColor(nImpar)
	Else
		oSayLin13:cCaption := ""
	EndIf
	If nTamArrey >= 14
		For X := 1 To 6
			cLabel14 := cLabel14 + Iif(X >=5, Transform(aConsulta[ 14, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 14, X ], "@!"), 1, 9),Transform(aConsulta[ 14, X ], "@!"))) + "  "
		Next
		oSayLin14:cCaption := cLabel14
		oSayLin14:nClrText := cColor(nPar)
	Else
		oSayLin14:cCaption := ""
	EndIf
	If nTamArrey >= 15
		For X := 1 To 6
			cLabel15 := cLabel15 + Iif(X >=5, Transform(aConsulta[ 15, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 15, X ], "@!"), 1, 9),Transform(aConsulta[ 15, X ], "@!"))) + "  "
		Next
		oSayLin15:cCaption := cLabel15
		oSayLin15:nClrText := cColor(nImpar)
	Else
		oSayLin15:cCaption := ""
	EndIf
	If nTamArrey >= 16
		For X := 1 To 6
			cLabel16 := cLabel16 + Iif(X >=5, Transform(aConsulta[ 16, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 16, X ], "@!"), 1, 9),Transform(aConsulta[ 16, X ], "@!"))) + "  "
		Next
		oSayLin16:cCaption := cLabel16
		oSayLin16:nClrText := cColor(nPar)
	Else
		oSayLin16:cCaption := ""
	EndIf
	If nTamArrey >= 17
		For X := 1 To 6
			cLabel17 := cLabel17 + Iif(X >=5, Transform(aConsulta[ 17, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 17, X ], "@!"), 1, 9),Transform(aConsulta[ 17, X ], "@!"))) + "  "
		Next
		oSayLin17:cCaption := cLabel17
		oSayLin17:nClrText := cColor(nImpar)
	Else
		oSayLin17:cCaption := ""
	EndIf
	If nTamArrey >= 18
		For X := 1 To 6
			cLabel18 := cLabel18 + Iif(X >=5, Transform(aConsulta[ 18, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 18, X ], "@!"), 1, 9),Transform(aConsulta[ 18, X ], "@!"))) + "  "
		Next
		oSayLin18:cCaption := cLabel18
		oSayLin18:nClrText := cColor(nPar)
	Else
		oSayLin18:cCaption := ""
	EndIf
	If nTamArrey >= 19
		For X := 1 To 6
			cLabel19 := cLabel19 + Iif(X >=5, Transform(aConsulta[ 19, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 19, X ], "@!"), 1, 9),Transform(aConsulta[ 19, X ], "@!"))) + "  "
		Next
		oSayLin19:cCaption := cLabel19
		oSayLin19:nClrText := cColor(nImpar)
	Else
		oSayLin19:cCaption := ""
	EndIf
	If nTamArrey >= 20
		For X := 1 To 6
			cLabel20 := cLabel20 + Iif(X >=5, Transform(aConsulta[ 20, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 20, X ], "@!"), 1, 9),Transform(aConsulta[ 20, X ], "@!"))) + "  "
		Next
		oSayLin20:cCaption := cLabel20
		oSayLin20:nClrText := cColor(nPar)
	Else
		oSayLin20:cCaption := ""
	EndIf
	If nTamArrey >= 21
		For X := 1 To 6
			cLabel21 := cLabel21 + Iif(X >=5, Transform(aConsulta[ 21, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 21, X ], "@!"), 1, 9),Transform(aConsulta[ 21, X ], "@!"))) + "  "
		Next
		oSayLin21:cCaption := cLabel21
		oSayLin21:nClrText := cColor(nImpar)
	Else
		oSayLin21:cCaption := ""
	EndIf
	If nTamArrey >= 22
		For X := 1 To 6
			cLabel22 := cLabel22 + Iif(X >=5, Transform(aConsulta[ 22, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 22, X ], "@!"), 1, 9),Transform(aConsulta[ 22, X ], "@!"))) + "  "
		Next
		oSayLin22:cCaption := cLabel22
		oSayLin22:nClrText := cColor(nPar)
	Else
		oSayLin22:cCaption := ""
	EndIf
	If nTamArrey >= 23
		For X := 1 To 6
			cLabel23 := cLabel23 + Iif(X >=5, Transform(aConsulta[ 23, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 23, X ], "@!"), 1, 9),Transform(aConsulta[ 23, X ], "@!"))) + "  "
		Next
		oSayLin23:cCaption := cLabel23
		oSayLin23:nClrText := cColor(nImpar)
	Else
		oSayLin23:cCaption := ""
	EndIf
	If nTamArrey >= 24
		For X := 1 To 6
			cLabel24 := cLabel24 + Iif(X >=5, Transform(aConsulta[ 24, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 24, X ], "@!"), 1, 9),Transform(aConsulta[ 24, X ], "@!"))) + "  "
		Next
		oSayLin24:cCaption := cLabel24
		oSayLin24:nClrText := cColor(nPar)
	Else
		oSayLin24:cCaption := ""
	EndIf
	If nTamArrey >= 25
		For X := 1 To 6
			cLabel25 := cLabel25 + Iif(X >=5, Transform(aConsulta[ 25, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 25, X ], "@!"), 1, 9),Transform(aConsulta[ 25, X ], "@!"))) + "  "
		Next
		oSayLin25:cCaption := cLabel25
		oSayLin25:nClrText := cColor(nImpar)
	Else
		oSayLin25:cCaption := ""
	EndIf
	If nTamArrey >= 26
		For X := 1 To 6
			cLabel26 := cLabel26 + Iif(X >=5, Transform(aConsulta[ 26, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 26, X ], "@!"), 1, 9),Transform(aConsulta[ 26, X ], "@!"))) + "  "
		Next
		oSayLin26:cCaption := cLabel26
		oSayLin26:nClrText := cColor(nPar)
	Else
		oSayLin26:cCaption := ""
	EndIf
	If nTamArrey >= 27
		For X := 1 To 6
			cLabel27 := cLabel27 + Iif(X >=5, Transform(aConsulta[ 27, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 27, X ], "@!"), 1, 9),Transform(aConsulta[ 27, X ], "@!"))) + "  "
		Next
		oSayLin27:cCaption := cLabel27
		oSayLin27:nClrText := cColor(nImpar)
	Else
		oSayLin27:cCaption := ""
	EndIf
	If nTamArrey >= 28
		For X := 1 To 6
			cLabel28 := cLabel28 + Iif(X >=5, Transform(aConsulta[ 28, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 28, X ], "@!"), 1, 9),Transform(aConsulta[ 28, X ], "@!"))) + "  "
		Next
		oSayLin28:cCaption := cLabel28
		oSayLin28:nClrText := cColor(nPar)
	Else
		oSayLin28:cCaption := ""
	EndIf
	If nTamArrey >= 29
		For X := 1 To 6
			cLabel29 := cLabel29 + Iif(X >=5, Transform(aConsulta[ 29, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 29, X ], "@!"), 1, 9),Transform(aConsulta[ 29, X ], "@!"))) + "  "
		Next
		oSayLin29:cCaption := cLabel29
		oSayLin29:nClrText := cColor(nImpar)
	Else
		oSayLin29:cCaption := ""
	EndIf
	If nTamArrey >= 30
		For X := 1 To 6
			cLabel30 := cLabel30 + Iif(X >=5, Transform(aConsulta[ 30, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 30, X ], "@!"), 1, 9),Transform(aConsulta[ 30, X ], "@!"))) + "  "
		Next
		oSayLin30:cCaption := cLabel30
		oSayLin30:nClrText := cColor(nPar)
	Else
		oSayLin30:cCaption := ""
	EndIf
	If nTamArrey >= 31
		For X := 1 To 6
			cLabel31 := cLabel31 + Iif(X >=5, Transform(aConsulta[ 31, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 31, X ], "@!"), 1, 9),Transform(aConsulta[ 31, X ], "@!"))) + "  "
		Next
		oSayLin31:cCaption := cLabel31
		oSayLin31:nClrText := cColor(nImpar)
	Else
		oSayLin31:cCaption := ""
	EndIf
	If nTamArrey >= 32
		For X := 1 To 6
			cLabel32 := cLabel32 + Iif(X >=5, Transform(aConsulta[ 32, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 32, X ], "@!"), 1, 9),Transform(aConsulta[ 32, X ], "@!"))) + "  "
		Next
		oSayLin32:cCaption := cLabel32
		oSayLin32:nClrText := cColor(nPar)
	Else
		oSayLin32:cCaption := ""
	EndIf
	If nTamArrey >= 33
		For X := 1 To 6
			cLabel33 := cLabel33 + Iif(X >=5, Transform(aConsulta[ 33, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 33, X ], "@!"), 1, 9),Transform(aConsulta[ 33, X ], "@!"))) + "  "
		Next
		oSayLin33:cCaption := cLabel33
		oSayLin33:nClrText := cColor(nImpar)
	Else
		oSayLin33:cCaption := ""
	EndIf
	If nTamArrey >= 34
		For X := 1 To 6
			cLabel34 := cLabel34 + Iif(X >=5, Transform(aConsulta[ 34, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 34, X ], "@!"), 1, 9),Transform(aConsulta[ 34, X ], "@!"))) + "  "
		Next
		oSayLin34:cCaption := cLabel34
		oSayLin34:nClrText := cColor(nPar)
	Else
		oSayLin34:cCaption := ""
	EndIf
	If nTamArrey >= 35
		For X := 1 To 6
			cLabel35 := cLabel35 + Iif(X >=5, Transform(aConsulta[ 35, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 35, X ], "@!"), 1, 9),Transform(aConsulta[ 35, X ], "@!"))) + "  "
		Next
		oSayLin35:cCaption := cLabel35
		oSayLin35:nClrText := cColor(nImpar)
	Else
		oSayLin35:cCaption := ""
	EndIf
	If nTamArrey >= 36
		For X := 1 To 6
			cLabel36 := cLabel36 + Iif(X >=5, Transform(aConsulta[ 36, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 36, X ], "@!"), 1, 9),Transform(aConsulta[ 36, X ], "@!"))) + "  "
		Next
		oSayLin36:cCaption := cLabel36
		oSayLin36:nClrText := cColor(nPar)
	Else
		oSayLin36:cCaption := ""
	EndIf
	If nTamArrey >= 37
		For X := 1 To 6
			cLabel37 := cLabel37 + Iif(X >=5, Transform(aConsulta[ 37, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 37, X ], "@!"), 1, 9),Transform(aConsulta[ 37, X ], "@!"))) + "  "
		Next
		oSayLin37:cCaption := cLabel37
		oSayLin37:nClrText := cColor(nImpar)
	Else
		oSayLin37:cCaption := ""
	EndIf
	If nTamArrey >= 38
		For X := 1 To 6
			cLabel38 := cLabel38 + Iif(X >=5, Transform(aConsulta[ 38, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 38, X ], "@!"), 1, 9),Transform(aConsulta[ 38, X ], "@!"))) + "  "
		Next
		oSayLin38:cCaption := cLabel38
		oSayLin38:nClrText := cColor(nPar)
	Else
		oSayLin38:cCaption := ""
	EndIf
	If nTamArrey >= 39
		For X := 1 To 6
			cLabel39 := cLabel39 + Iif(X >=5, Transform(aConsulta[ 39, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 39, X ], "@!"), 1, 9),Transform(aConsulta[ 39, X ], "@!"))) + "  "
		Next
		oSayLin39:cCaption := cLabel39
		oSayLin39:nClrText := cColor(nImpar)
	Else
		oSayLin39:cCaption := ""
	EndIf
	If nTamArrey >= 40
		For X := 1 To 6
			cLabel40 := cLabel40 + Iif(X >=5, Transform(aConsulta[ 40, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 40, X ], "@!"), 1, 9),Transform(aConsulta[ 40, X ], "@!"))) + "  "
		Next
		oSayLin40:cCaption := cLabel40
		oSayLin40:nClrText := cColor(nPar)
	Else
		oSayLin40:cCaption := ""
	EndIf
	If nTamArrey >= 41
		For X := 1 To 6
			cLabel41 := cLabel41 + Iif(X >=5, Transform(aConsulta[ 41, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 41, X ], "@!"), 1, 9),Transform(aConsulta[ 41, X ], "@!"))) + "  "
		Next
		oSayLin41:cCaption := cLabel41
		oSayLin41:nClrText := cColor(nImpar)
	Else
		oSayLin41:cCaption := ""
	EndIf
	If nTamArrey >= 42
		For X := 1 To 6
			cLabel42 := cLabel42 + Iif(X >=5, Transform(aConsulta[ 42, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 42, X ], "@!"), 1, 9),Transform(aConsulta[ 42, X ], "@!"))) + "  "
		Next
		oSayLin42:cCaption := cLabel42
		oSayLin42:nClrText := cColor(nPar)
	Else
		oSayLin42:cCaption := ""
	EndIf
	If nTamArrey >= 43
		For X := 1 To 6
			cLabel43 := cLabel43 + Iif(X >=5, Transform(aConsulta[ 43, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 43, X ], "@!"), 1, 9),Transform(aConsulta[ 43, X ], "@!"))) + "  "
		Next
		oSayLin43:cCaption := cLabel43
		oSayLin43:nClrText := cColor(nImpar)
	Else
		oSayLin43:cCaption := ""
	EndIf
	If nTamArrey >= 44
		For X := 1 To 6
			cLabel44 := cLabel44 + Iif(X >=5, Transform(aConsulta[ 44, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 44, X ], "@!"), 1, 9),Transform(aConsulta[ 44, X ], "@!"))) + "  "
		Next
		oSayLin44:cCaption := cLabel44
		oSayLin44:nClrText := cColor(nPar)
	Else
		oSayLin44:cCaption := ""
	EndIf
	If nTamArrey >= 45
		For X := 1 To 6
			cLabel45 := cLabel45 + Iif(X >=5, Transform(aConsulta[ 45, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 45, X ], "@!"), 1, 9),Transform(aConsulta[ 45, X ], "@!"))) + "  "
		Next
		oSayLin45:cCaption := cLabel45
		oSayLin45:nClrText := cColor(nImpar)
	Else
		oSayLin45:cCaption := ""
	EndIf
	If nTamArrey >= 46
		For X := 1 To 6
			cLabel46 := cLabel46 + Iif(X >=5, Transform(aConsulta[ 46, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 46, X ], "@!"), 1, 9),Transform(aConsulta[ 46, X ], "@!"))) + "  "
		Next
		oSayLin46:cCaption := cLabel46
		oSayLin46:nClrText := cColor(nPar)
	Else
		oSayLin46:cCaption := ""
	EndIf
	If nTamArrey >= 47
		For X := 1 To 6
			cLabel47 := cLabel47 + Iif(X >=5, Transform(aConsulta[ 47, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 47, X ], "@!"), 1, 9),Transform(aConsulta[ 47, X ], "@!"))) + "  "
		Next
		oSayLin47:cCaption := cLabel47
		oSayLin47:nClrText := cColor(nImpar)
	Else
		oSayLin47:cCaption := ""
	EndIf
	If nTamArrey >= 48
		For X := 1 To 6
			cLabel48 := cLabel48 + Iif(X >=5, Transform(aConsulta[ 48, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 48, X ], "@!"), 1, 9),Transform(aConsulta[ 48, X ], "@!"))) + "  "
		Next
		oSayLin48:cCaption := cLabel48
		oSayLin48:nClrText := cColor(nPar)
	Else
		oSayLin48:cCaption := ""
	EndIf
	If nTamArrey >= 49
		For X := 1 To 6
			cLabel49 := cLabel49 + Iif(X >=5, Transform(aConsulta[ 49, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 49, X ], "@!"), 1, 9),Transform(aConsulta[ 49, X ], "@!"))) + "  "
		Next
		oSayLin49:cCaption := cLabel49
		oSayLin49:nClrText := cColor(nImpar)
	Else
		oSayLin49:cCaption := ""
	EndIf
	If nTamArrey >= 50
		For X := 1 To 6
			cLabel50 := cLabel50 + Iif(X >=5, Transform(aConsulta[ 50, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 50, X ], "@!"), 1, 9),Transform(aConsulta[ 50, X ], "@!"))) + "  "
		Next
		oSayLin50:cCaption := cLabel50
		oSayLin50:nClrText := cColor(nPar)
	Else
		oSayLin50:cCaption := ""
	EndIf
	If nTamArrey >= 51
		For X := 1 To 6
			cLabel51 := cLabel51 + Iif(X >=5, Transform(aConsulta[ 51, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 51, X ], "@!"), 1, 9),Transform(aConsulta[ 51, X ], "@!"))) + "  "
		Next
		oSayLin51:cCaption := cLabel51
		oSayLin51:nClrText := cColor(nImpar)
	Else
		oSayLin51:cCaption := ""
	EndIf
	If nTamArrey >= 52
		For X := 1 To 6
			cLabel52 := cLabel52 + Iif(X >=5, Transform(aConsulta[ 52, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 52, X ], "@!"), 1, 9),Transform(aConsulta[ 52, X ], "@!"))) + "  "
		Next
		oSayLin52:cCaption := cLabel52
		oSayLin52:nClrText := cColor(nPar)
	Else
		oSayLin52:cCaption := ""
	EndIf
	If nTamArrey >= 53
		For X := 1 To 6
			cLabel53 := cLabel53 + Iif(X >=5, Transform(aConsulta[ 53, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 53, X ], "@!"), 1, 9),Transform(aConsulta[ 53, X ], "@!"))) + "  "
		Next
		oSayLin53:cCaption := cLabel53
		oSayLin53:nClrText := cColor(nImpar)
	Else
		oSayLin53:cCaption := ""
	EndIf
	If nTamArrey >= 54
		For X := 1 To 6
			cLabel54 := cLabel54 + Iif(X >=5, Transform(aConsulta[ 54, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 54, X ], "@!"), 1, 9),Transform(aConsulta[ 54, X ], "@!"))) + "  "
		Next
		oSayLin54:cCaption := cLabel54
		oSayLin54:nClrText := cColor(nPar)
	Else
		oSayLin54:cCaption := ""
	EndIf
	If nTamArrey >= 55
		For X := 1 To 6
			cLabel55 := cLabel55 + Iif(X >=5, Transform(aConsulta[ 55, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 55, X ], "@!"), 1, 9),Transform(aConsulta[ 55, X ], "@!"))) + "  "
		Next
		oSayLin55:cCaption := cLabel55
		oSayLin55:nClrText := cColor(nImpar)
	Else
		oSayLin55:cCaption := ""
	EndIf
	If nTamArrey >= 56
		For X := 1 To 6
			cLabel56 := cLabel56 + Iif(X >=5, Transform(aConsulta[ 56, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 56, X ], "@!"), 1, 9),Transform(aConsulta[ 56, X ], "@!"))) + "  "
		Next
		oSayLin56:cCaption := cLabel56
		oSayLin56:nClrText := cColor(nPar)
	Else
		oSayLin56:cCaption := ""
	EndIf
	If nTamArrey >= 57
		For X := 1 To 6
			cLabel57 := cLabel57 + Iif(X >=5, Transform(aConsulta[ 57, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 57, X ], "@!"), 1, 9),Transform(aConsulta[ 57, X ], "@!"))) + "  "
		Next
		oSayLin57:cCaption := cLabel57
		oSayLin57:nClrText := cColor(nImpar)
	Else
		oSayLin57:cCaption := ""
	EndIf
	If nTamArrey >= 58
		For X := 1 To 6
			cLabel58 := cLabel58 + Iif(X >=5, Transform(aConsulta[ 58, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 58, X ], "@!"), 1, 9),Transform(aConsulta[ 58, X ], "@!"))) + "  "
		Next
		oSayLin58:cCaption := cLabel58
		oSayLin58:nClrText := cColor(nPar)
	Else
		oSayLin58:cCaption := ""
	EndIf
	If nTamArrey >= 59
		For X := 1 To 6
			cLabel59 := cLabel59 + Iif(X >=5, Transform(aConsulta[ 59, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 59, X ], "@!"), 1, 9),Transform(aConsulta[ 59, X ], "@!"))) + "  "
		Next
		oSayLin59:cCaption := cLabel59
		oSayLin59:nClrText := cColor(nImpar)
	Else
		oSayLin59:cCaption := ""
	EndIf
	If nTamArrey >= 60
		For X := 1 To 6
			cLabel60 := cLabel60 + Iif(X >=5, Transform(aConsulta[ 60, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 60, X ], "@!"), 1, 9),Transform(aConsulta[ 60, X ], "@!"))) + "  "
		Next
		oSayLin60:cCaption := cLabel60
		oSayLin60:nClrText := cColor(nPar)
	Else
		oSayLin60:cCaption := ""
	EndIf
	If nTamArrey >= 61
		For X := 1 To 6
			cLabel61 := cLabel61 + Iif(X >=5, Transform(aConsulta[ 61, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 61, X ], "@!"), 1, 9),Transform(aConsulta[ 61, X ], "@!"))) + "  "
		Next
		oSayLin61:cCaption := cLabel61
		oSayLin61:nClrText := cColor(nImpar)
	Else
		oSayLin61:cCaption := ""
	EndIf
	If nTamArrey >= 62
		For X := 1 To 6
			cLabel62 := cLabel62 + Iif(X >=5, Transform(aConsulta[ 62, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 62, X ], "@!"), 1, 9),Transform(aConsulta[ 62, X ], "@!"))) + "  "
		Next
		oSayLin62:cCaption := cLabel62
		oSayLin62:nClrText := cColor(nPar)
	Else
		oSayLin62:cCaption := ""
	EndIf
	If nTamArrey >= 63
		For X := 1 To 6
			cLabel63 := cLabel63 + Iif(X >=5, Transform(aConsulta[ 63, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 63, X ], "@!"), 1, 9),Transform(aConsulta[ 63, X ], "@!"))) + "  "
		Next
		oSayLin63:cCaption := cLabel63
		oSayLin63:nClrText := cColor(nImpar)
	Else
		oSayLin63:cCaption := ""
	EndIf
	If nTamArrey >= 64
		For X := 1 To 6
			cLabel64 := cLabel64 + Iif(X >=5, Transform(aConsulta[ 64, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 64, X ], "@!"), 1, 9),Transform(aConsulta[ 64, X ], "@!"))) + "  "
		Next
		oSayLin64:cCaption := cLabel64
		oSayLin64:nClrText := cColor(nPar)
	Else
		oSayLin64:cCaption := ""
	EndIf
	If nTamArrey >= 65
		For X := 1 To 6
			cLabel65 := cLabel65 + Iif(X >=5, Transform(aConsulta[ 65, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 65, X ], "@!"), 1, 9),Transform(aConsulta[ 65, X ], "@!"))) + "  "
		Next
		oSayLin65:cCaption := cLabel65
		oSayLin65:nClrText := cColor(nImpar)
	Else
		oSayLin65:cCaption := ""
	EndIf
	If nTamArrey >= 66
		For X := 1 To 6
			cLabel66 := cLabel66 + Iif(X >=5, Transform(aConsulta[ 66, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 66, X ], "@!"), 1, 9),Transform(aConsulta[ 66, X ], "@!"))) + "  "
		Next
		oSayLin66:cCaption := cLabel66
		oSayLin66:nClrText := cColor(nPar)
	Else
		oSayLin66:cCaption := ""
	EndIf
	If nTamArrey >= 67
		For X := 1 To 6
			cLabel67 := cLabel67 + Iif(X >=5, Transform(aConsulta[ 67, X ], "@E 99,999.99"), Iif(X == 1, Substr(Transform(aConsulta[ 67, X ], "@!"), 1, 9),Transform(aConsulta[ 67, X ], "@!"))) + "  "
		Next
		oSayLin67:cCaption := cLabel67
		oSayLin67:nClrText := cColor(nImpar)
	Else
		oSayLin67:cCaption := ""
	EndIf

	cQuantCont := 0
	//oSayQuant1:lVisibleControl := .F.
	//oSayQuant2:lVisibleControl := .F.
	oSayQuant2:cCaption := Transform(cQuantCont, "@E 99")
	//ObjectMethod( oSayQuant1, "Refresh()" )
	ObjectMethod( oSayQuant2, "Refresh()" )

Return Nil

************
Static Function Procura(cCBarra, lOK)
************

	local nItem
	cNovoLabel := ""
	cBarra := Alltrim(cCBarra)

    SB1->( DBSETORDER( 1 ) )
	SB1->( Dbseek( xFilial( "SB1" ) + Z00->Z00_CODIGO ) )

	If !('ME' $ cProduto)
		nItem := aScan( aConsulta, {|x| x[2] == cBarra } )
//	    SB1->( DBSETORDER( 1 ) )
	    if lOK .OR. SB1->B1_SETOR = '39'  //Pesagem de sacos-capa
//			SB1->( Dbseek( xFilial( "SB1" ) + Z00->Z00_CODIGO ) )
			cDescProd := Alltrim(SB1->B1_DESC)
			cProduto  := Alltrim(SB1->B1_COD )
	    else
			SB1->( Dbseek( xFilial( "SB1" ) + aConsulta[nItem,1] ) )
			cDescProd := Alltrim(SB1->B1_DESC)
			cProduto  := Alltrim(aConsulta[nItem, 1])
		endIf
	    oSayProduto2:cCaption := cProduto
        oSayDesc:cCaption := cDescProd   	
		if  Type("oSayLin"+Alltrim(Str(nItem))) != "U"
    	   &("oSayLin"+Alltrim(Str(nItem))+":nClrText") := CLR_HRED
    	endif
	EndIf

	cQuantCont := cQuantCont + 1
	//oSayQuant1:lVisibleControl := .T.
	//oSayQuant2:lVisibleControl := .T.
	oSayQuant2:cCaption := Transform(cQuantCont, "@E 99")
	//ObjectMethod( oSayQuant1, "Refresh()" )
	ObjectMethod( oSayQuant2, "Refresh()" )

Return (cDescProd, cProduto)


//Retorna a Sequencia do Produto Tipo "IS" Produto Intermediario Secundario
//20/08/08 - Eurivan Marques
*********************************
static function GetSeqOP(cCODX)
********************************

local cQuery
local cRet
local cProd

//Vejo qual é o Produto no Z00
dbSelectArea('Z00')
dbSetOrder(1)
Z00->( Dbseek( xFilial( "Z00" ) + Right( alltrim(cCODX), 6 ) ) )
cProd := Z00->Z00_CODIGO

cQuery := "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO "
cQuery += "FROM "+RetSqlName("SC2")+" SC2  "
cQuery += "WHERE C2_NUM = '"+Left(cCODX,6)+"' "
cQuery += "AND C2_PRODUTO = '"+cProd+"' "
cQuery += "AND SC2.D_E_L_E_T_ = '' "
cQuery += "ORDER BY C2_NUM, C2_ITEM, C2_SEQUEN "
TCQUERY cQuery NEW ALIAS "C2X"

C2X->( dbGoTop() )

if !C2X->(EOF())
   cRet := C2X->(C2_ITEM+C2_SEQUEN)
else
   cRet := "01001"
endif   
C2X->(DbCloseArea())

return cRet


***************
Static Function PesqCod( cCODX )
***************

Local cSeq := GetSeqOP(cCODX)

dbSelectArea('Z00')
dbSetOrder(1)

public cCodBarr := cCODX

	If Len(Alltrim(cCodBarr)) > 0
		If Len( AllTrim( cCODX ) ) == 12
		   cCODX := Left( cCODX, 6 ) + cSeq + SubStr( cCODX, 7, 6 )
		//   cCODX := Left( cCODX, 6 ) + "01001" + SubStr( cCODX, 7, 6 )
		EndIf
		If Empty( cCODX )
			Erro( "Informe o codigo de barra do produto" )
			Return .F.
		EndIf
		If ! Z00->( Dbseek( xFilial( "Z00" ) + SubStr( cCODX, 12, 6 ) ) )
			Erro( "Codigo de barra invalido (sequencia)" )
			Return .F.
		EndIf
		If Z00->Z00_OP <> Left( cCODX, 11 )
			if ! ( alltrim(Z00->Z00_MAQ) == "XXX" .and. alltrim(Z00->Z00_OP) == Left( cCODX, 6 ) )//Pesagem de sacos-capa 27/04/09
				Erro( "Codigo de barra invalido (OP)" )
				Return .F.
			endIf
		EndIf
		If Z00->Z00_BAIXA == "S"
			Erro( "Codigo de barra ja foi lido anteriormente" )
			Return .F.
		EndIf
		SC2->( DbSeek( xFilial( "SC2" ) + Left( cCODX, 11 ), .T. ) )
		/*Inserido em 18/08/08*/
		if !Empty( SC2->C2_BLOQUEA )
			MsgAlert( "Esta OP está bloqueada pelo setor de qualidade! ! !" )
			ObjectMethod( oSayMaq, "SetFocus()" )
			Return NIL
		EndIf
		/**/
		If BlqInvent( SC2->C2_PRODUTO, "01" )
			Help( " ", 1, "BLQINVENT",, SC2->C2_PRODUTO + OemToAnsi( " Almox: 01" ), 1, 11 )
			Return .F.
		EndIf
		SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
		SB2->( Dbseek( xFilial( "SB2" ) + SC2->C2_PRODUTO + "01" ) )
		SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
		//If ! Producao( cCODX )Pesagem de sacos-capa
		If ! Producao( cCODX, ( alltrim(Z00->Z00_MAQ) == "XXX" .and. alltrim(Z00->Z00_OP) == Left( cCODX, 6 ) ) )
			Erro( "Erro na inclusao deste fardo no estoque (" + AllTrim( cCODX ) + ")" )
			ObjectMethod( oGetCBarra1, "SetFocus()" )
			cCodBarra := Space(17)
			ObjectMethod( oGetCBarra1, "Refresh()" )
			Return .F.
		EndIf
		PesoReal()
	    nORD := SD3->( Indexord() )
	    SD3->( DbSetOrder( 4 ) )
	    SD3->( DbGobottom() )
	    SD3->( DbSetOrder( nORD ) )
		Reclock( "Z00", .F. )
		Z00->Z00_BAIXA := "S"
	    Z00->Z00_DOC   := SD3->D3_DOC
		Z00->( MsUnlock() )
		Z00->( dbCommit() )
		endOP( Left( cCODX, 11 ) )
		MostraOK( ( alltrim(Z00->Z00_MAQ) == "XXX" .and. alltrim(Z00->Z00_OP) == Left( cCODX, 6 ) ) )
		//MostraOK() Pesagem de sacos-capa
		cPROD  := SB1->B1_DESC
		nQUANT := Z00->Z00_QUANT
		ObjectMethod( oGetCBarra1, "SetFocus()" )
		cCodBarra := Space(17)
		ObjectMethod( oGetCBarra1, "Refresh()" )
	EndIf

Return .T.

***************
Static Function Erro( cMENS )
***************

MsgAlert( cMENS )
cCOD   := Space( 17 )
cPROD  := Space( 50 )
nQUANT := 0
Return NIL


***************
//Static Function Producao( cCODX )
Static Function Producao( cCODX, lOP )
***************
local lTipMe:=.F.
Local aMATRIZ := {}
Local lInacab := Z00->Z00_QUANT < SB5->B5_QTDFIM
Local cAlmox  := '01'
lMsErroAuto := .F.

/*Incluir Saldo B2 no local "02" quando for inacabado p/ criacao do Almoxarifado "02"
  e diferente capa(tipo ME) */
DbSelectArea("SB1")
DbSetOrder(1)
If SB1->( DbSeek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
   If SB1->B1_TIPO == 'ME'
      lTipMe:=.T.
   Endif
endif

DbSelectArea("SB2")
DbSetOrder(1)
if lInacab .AND. !lTipMe 
   cAlmox := '02'
   if !SB2->( DbSeek(xFilial("SB2") + SC2->C2_PRODUTO + "02",.F. ) ) .and. SC2->C2_OPLIC != 'S'//Incompletos
      RecLock("SB2",.T.)
      SB2->B2_FILIAL := xFilial("SB2")
      SB2->B2_COD    := SC2->C2_PRODUTO
      SB2->B2_LOCAL  := "02"
      SB2->(MsUnLock())
   endif
endif   
//Incluir Saldo B2 no local "03" quando for OP de amostra para licitação p/ criacao do Almoxarifado "03"
iif(SC2->C2_OPLIC == 'S', cAlmox := '03',)
if !SB2->( DbSeek( xFilial("SB2") + SC2->C2_PRODUTO + "03",.F. ) ) .and. SC2->C2_OPLIC == 'S'
	RecLock("SB2",.T.)
    SB2->B2_FILIAL := xFilial("SB2")
    SB2->B2_COD    := SC2->C2_PRODUTO
    SB2->B2_LOCAL  := "03"
    SB2->(MsUnLock())
endIf


if lOP//Pesagem de sacos-capa 28/04/09, se for, sem op
	Begin Transaction	 	  
	    aMatriz :=  {{"D3_FILIAL",  xFilial("SD3"),                                             NIL },;
	                 {"D3_COD"     ,Z00->Z00_CODIGO,										 	Nil},;
	    			 {"D3_TM"      ,"003",												 		Nil},;
	    			 {"D3_LOCAL"   ,"01",												 		Nil},;
	    			 {"D3_UM"      ,posicione("SB1",1,xFilial('SB1') + Z00->Z00_CODIGO,"B1_UM"),Nil},;
	    			 {"D3_QUANT"   ,Z00->Z00_QUANT/1000,										Nil},;
	    			 {"D3_EMISSAO" ,dDataBase,													Nil},;
					 { "D3_USULIM" ,Z00->Z00_NOME,                 							Nil},;
					 { "D3_PARCTOT","P",                             							Nil},;
					 { "D3_CODBAR" ,Z00->Z00_CODBAR,                 							Nil} } 


// { "D3_USULIM" ,Z00->Z00_USULIM,                 							Nil},;

    	MSExecAuto( { | x,y | MATA240( x,y ) }, aMatriz, 3 )
	 	if lMsErroAuto
			MostraErro()
 		    DisarmTransaction()
	 		Return
	 	endIf
    End Transaction				 
else
	aMATRIZ := { { "D3_FILIAL",  xFilial("SD3"),                  NIL },;
	             { "D3_OP",      Left( cCODX, 11 ),               NIL },;
				 { "D3_COD",     SC2->C2_PRODUTO,                 NIL },;
	    		 { "D3_TM"      ,"100",							   Nil},;
	   			 { "D3_LOCAL",   cAlmox,                          NIL },;//{ "D3_LOCAL",   iif(lInacab,'02','01'),          NIL },;
				 { "D3_EMISSAO", Date(),                          NIL },;
				 { "D3_QUANT", IIF(ALLTRIM(Z00->Z00_MAQ)!='A01',Z00->Z00_QUANT / SB5->B5_QE2,Z00->Z00_QUANT),    NIL },;
				 { "D3_OBS",     "COD. BARRA " + Z00->Z00_SEQ,    NIL },;
				 { "D3_USULIM",  Z00->Z00_USULIM,                 NIL },;
				 { "D3_PARCTOT", "P",                             NIL },;
				 { "D3_CODBAR" , Left( cCODX, 6 ) + Z00->Z00_SEQ, NIL} } //03/04/07 basta tirar essa linha

	Begin Transaction
		MSExecAuto({|x, y| mata250(x, y)},aMATRIZ, 3 )
		IF lMsErroAuto
			MostraErro()
			DisarmTransaction()
			Break
		Endif
	End Transaction				 
endIf

Return ! lMSErroAuto


***************
Static Function PesoReal()
***************

If Z00->Z00_QUANT == SB5->B5_QTDFIM
	 Reclock( "SB1", .F. )
	 If ! SB2->( Eof() ) .and. SB2->B2_QATU > 0
	    SB1->B1_PESOR := ( ( SB2->B2_QATU * SB1->B1_PESO ) + Z00->Z00_PESO ) / ( SB2->B2_QATU + ( Z00->Z00_QUANT / SB5->B5_QE2 ) )
	 Else
	    SB1->B1_PESOR := Z00->Z00_PESO / ( Z00->Z00_QUANT / SB5->B5_QE2 )
	 EndIf
	 SB1->( MsUnlock() )
	 SB1->( dbCommit() )
EndIf
Return NIL


***************
Static Function MostraOK(lOK)
***************
/*
DEFINE FONT oFont NAME "Arial" SIZE 0, -128 BOLD
DEFINE MSDIALOG oDLG2 FROM 000, 000 TO 15,50 TITLE "Leitura da etiqueta"

@ 015, 045 SAY OemToAnsi( "OK" ) Object oOBJ SIZE 130, 130
oOBJ:SetFont( oFont )
oOBJ:SetColor( CLR_GREEN )
oTimer := TTimer():New( 500, { || oTimer:End(), oDLG2:End() }, oDLG2 )
ACTIVATE TIMER oTimer
ACTIVATE MSDIALOG oDLG2 CENTERED
*/
//Procura( oGetCBarra1:cCaption )


//Procura( cCodBarra ) Pesagem de sacos-capa
Procura( cCodBarra, lOK)

***************

Static Function endOP( cOPx )

***************
/*
Obs.: O SD3 já chega posicionado no registro que deve ser alterado.
*/
Local lMsErroAuto := .F.
Local aMata250 := {}
Local nRec := SD3->( recno() )
Local nIdx := SD3->( indexOrd() )
Local cQuery := ''
Private LPERDINF := .F.
SD3->( dbSetOrder(1) )
//dbSelectArea('SD3')
if empty(SC2->C2_FINALIZ)
	SD3->( dbGoTo( nRec ) )
	SD3->( dbSetOrder( nIdx ) )
	return
endIf
cQuery +="select  count(*) nReg "
cQuery +="from	" + retSqlName('Z00') + " Z00 "
cQuery +="where   Z00.Z00_OP = '"+cOPx+"' and Z00.Z00_BAIXA = 'N' "
cQuery +="and Z00.Z00_APARA  = '' "
cQuery +="and Z00.Z00_FILIAL = '"+xFilial("Z00")+"' and Z00.D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS 'TMPZ'
TMPZ->( dbGoTop() )
if TMPZ->nReg > 0
	TMPZ->( dbCloseArea() )
	SD3->( dbGoTo( nRec ) )
	SD3->( dbSetOrder( nIdx ) )
	return
endIf
/*if .T.
  return
endIf*/
if ! SD3->( dbSeek( xFilial('SD3') + padr(alltrim(cOPx),14) + SC2->C2_PRODUTO, .T. ) )
	msgbox( "Impossível encontrar a OP "+ alltrim(cOPx) +"!" )
	msgbox( "ENCERRAMENTO ABORTADO ! ! !" )
	msgbox( "Favor contactar o setor de Informatica! " + alltrim(cOPx) )
	SD3->( dbGoTo( nRec ) )
	SD3->( dbSetOrder( nIdx ) )
	Return
endIf
//msgBox("A OP "+cOPx+" foi encerrada com sucesso!")
Private l250Auto := .T.
Private lIntQual := .F.
Private mv_par03 := 2
Private dDataFec := getMV('MV_ULMES')
Private LDELOPSC := getMV('MV_DELOPSC') == 'S'
Private LPRODAUT := getMV('MV_PRODAUT')

A250Encer('SD3', SD3->( recno() ), 5 )

SD3->( dbGoTo( nRec ) )
SD3->( dbSetOrder( nIdx ) )

Return