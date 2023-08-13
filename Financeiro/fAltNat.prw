#include "totvs.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Sair     บAutor  ณMicrosiga           บ Data ณ  10/15/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera natureza do tํtulo a partir da baixa.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fAltNat()


Private oDlg,oCombo1,oSay2,oBRW0,cARQCLI1 
Private cPesquisa := Space(30)

If date() - CtoD("25/06/2018") > 0
	MsgAlert("Erro 503!!!")
	return 
EndIf

@ 000,000 To 500,1000 Dialog oDLG Title "Altera Natureza"

aCAMPOS := { { "PREF" 	, "C", 03, 0 }, ;
{ "NUM"		, "C", 09, 0 }, ;
{ "PARC"    , "C", 02, 0 }, ;
{ "NAT"	    , "C", 10, 0 }, ;
{ "DESCNAT" , "C", 25, 0 }, ;
{ "DATAR"   , "C", 10, 0 }, ;
{ "VALOR"   , "N", 14, 2 }, ;
{ "BENEF"   , "C", 30, 0 }, ;
{ "HISTOR"  , "C", 40, 0 }, ;
{ "RECPAG"  , "C", 01, 0 }}

cARQCLI1 := CriaTrab( aCAMPOS, .T. )
DbUseArea( .T.,, cARQCLI1, "CLI", .F., .F. )

oCombo1 := TCOMBOBOX():Create(oDlg)
oCombo1:cName := "oCombo1"
oCombo1:cCaption := "oCombo1"
oCombo1:nLeft := 300
oCombo1:nTop := 36
oCombo1:nWidth := 145
oCombo1:nHeight := 21
oCombo1:lShowHint := .F.
oCombo1:lReadOnly := .F.
oCombo1:Align := 0
oCombo1:lVisibleControl := .T.
oCombo1:cVariable := "cOpcao"
oCombo1:bSetGet := {|u| If(PCount()>0,cOpcao:=u,cOpcao) }
oCombo1:aItems := {"1 - TITULO","2 - BENEFICIARIO","3 - HISTORICO"}
oCombo1:nAt := 0

oCombo1 := TCOMBOBOX():Create(oDlg)
oCombo1:cName := "oCombo1"
oCombo1:cCaption := "oCombo1"
oCombo1:nLeft := 450
oCombo1:nTop := 36
oCombo1:nWidth := 145
oCombo1:nHeight := 21
oCombo1:lShowHint := .F.
oCombo1:lReadOnly := .F.
oCombo1:Align := 0
oCombo1:lVisibleControl := .T.
oCombo1:cVariable := "cCart"
oCombo1:bSetGet := {|u| If(PCount()>0,cCart:=u,cCart) }
oCombo1:aItems := {"1 - PAGAR","2 - RECEBER","3 - AMBAS"}
oCombo1:nAt := 0

oSay2 := TSAY():Create(oDlg)
oSay2:cName := "oSay2"
oSay2:cCaption := "Pesquisa por:"
oSay2:nLeft := 230
oSay2:nTop := 35
oSay2:nWidth := 60
oSay2:nHeight := 17
oSay2:lShowHint := .F.
oSay2:lReadOnly := .F.
oSay2:Align := 0
oSay2:lVisibleControl := .T.
oSay2:lWordWrap := .F.
oSay2:lTransparent := .F.

oGET_PESQ:= TGET():Create(oDlg)
oGET_PESQ:cName := "oGET_PESQ"
oGET_PESQ:nLeft := 300
oGET_PESQ:nTop := 70
oGET_PESQ:nWidth := 256
oGET_PESQ:nHeight := 21
oGET_PESQ:lShowHint := .F.
oGET_PESQ:lReadOnly := .F.
oGET_PESQ:Align := 0
oGET_PESQ:cVariable := "cPesquisa"
oGET_PESQ:bSetGet := {|u| If(PCount()>0,cPesquisa:=u,cPesquisa) }
oGET_PESQ:lVisibleControl := .T.
oGET_PESQ:lPassword := .F.
oGET_PESQ:lHasButton := .F.

oBOT_OK := TBUTTON():Create(oDlg)
oBOT_OK:cName := "oBOT_OK"
oBOT_OK:cCaption := "Filtrar"
oBOT_OK:nLeft := 570
oBOT_OK:nTop := 70
oBOT_OK:nWidth := 100
oBOT_OK:nHeight := 25
oBOT_OK:lShowHint := .F.
oBOT_OK:lReadOnly := .F.
oBOT_OK:Align := 0
oBOT_OK:lVisibleControl := .T.
oBOT_OK:bAction := {|| Processa({ || fFilBrwCLI(), fAtuBrw(oBRW0) }) }
//OK()

oBOT_COB := TBUTTON():Create(oDlg)
oBOT_COB:cName := "oBOT_COB"
oBOT_COB:cCaption := "Altarar"
oBOT_COB:nLeft := 700
oBOT_COB:nTop := 110
oBOT_COB:nWidth := 100
oBOT_COB:nHeight := 25
oBOT_COB:lShowHint := .F.
oBOT_COB:lReadOnly := .F.
oBOT_COB:Align := 0
oBOT_COB:lVisibleControl := .T.
oBOT_COB:bAction := {|| Processa({ || fUpdTit() }) }

oBOT_OK := TBUTTON():Create(oDlg)
oBOT_OK:cName := "oBOT_LP"
oBOT_OK:cCaption := "Limpa Filtro"
oBOT_OK:nLeft := 570
oBOT_OK:nTop := 110
oBOT_OK:nWidth := 100
oBOT_OK:nHeight := 25
oBOT_OK:lShowHint := .F.
oBOT_OK:lReadOnly := .F.
oBOT_OK:Align := 0
oBOT_OK:lVisibleControl := .T.
oBOT_OK:bAction := {|| Processa({ || fLimpaFil() }) }


Dbselectarea("CLI")

oBRW0          := MsSelect():New( "CLI",,, ;
{ { "PREF" 	,,   OemToAnsi( "Pref." ) }, ;
{ "NUM"    	,,   OemToAnsi( "Numero" ) }, ;
{ "PARC"    ,,   OemToAnsi( "Parc." ) }, ;
{ "NAT"     ,,   OemToAnsi( "Cod." ) }, ;
{ "DESCNAT" ,,   OemToAnsi( "Natureza" ) }, ;
{ "DATAR"  	,,   OemToAnsi( "Data" ) }, ;
{ "VALOR"   ,"@R 999,999,999.99",   OemToAnsi( "Valor"     ) }, ;
{ "BENEF"	,,   OemToAnsi( "Beneficiario" ) }, ;
{ "HISTOR"  ,,   OemToAnsi( "Historico" ) }}, .F.,, { 070, 002, 250, 500 } )


//oBRW0:oBROWSE:bChange     := { || ExibeBrw1() }
//oBRW0:oBROWSE:bGotFocus   := { || ExibeBrw1() }

fListaCLI(cCart)

Dbselectarea("CLI")
dbgotop()

//oDlg:Activate()
Activate Dialog oDLG Centered Valid Sair() On Init TpPesq()
Return

Static Function TpPesq()

cOpcao := oCombo1:aItems[1]

ObjectMethod( oCombo1, "Refresh()" )

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Sair     บAutor  ณMicrosiga           บ Data ณ  10/15/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function fFilBrwCLI()

Local cFiltro
//Local cData	:= DtoC(dDataSet)

Dbselectarea("CLI")

Do Case
	Case Subst(cOpcao,1,2) == '1 ' //NUMERO TITULO
		//cFiltro := "NUM = '" + AllTrim(cPesquisa) + "'"
		cFiltro := "'" + AllTrim(cPesquisa) + "' $ NUM"
	Case Subst(cOpcao,1,2) == '2 ' //BENEFICIARIO
		cFiltro := "'" + AllTrim(cPesquisa) + "' $ BENEF"
	Case Subst(cOpcao,1,2) == '3 ' //HISTORICO
		cFiltro := "'" + AllTrim(cPesquisa) + "' $ HISTOR"
EndCase

//CLI->( DbSetFilter({|| $cFiltro }, cFiltro ))
CLI->( DbSetFilter( { || &cFiltro }, cFiltro ) )


CLI->(DBGoTop())

//oBRW0:oBROWSE:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Sair     บAutor  ณMicrosiga           บ Data ณ  10/15/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fLimpafil()

Dbselectarea("CLI")
CLI->(DBClearFilter())
fListaCLI()
CLI->(DBGoTop())

oBRW0:oBROWSE:Refresh()

Return

Static Function fAtuBrw(oBRW0)

oBRW0:oBROWSE:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Sair     บAutor  ณMicrosiga           บ Data ณ  10/15/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Sair

If MsgBox( "Confirma saida do programa?", "Escolha", "YESNO" )
	CLI->( DbCloseArea() )
	FErase(cARQCLI1 + GetDbExtension()) 
	//FWTemporaryTable():Delete()
	
	Return .T.
EndIf

Return .F.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Sair     บAutor  ณMicrosiga           บ Data ณ  10/15/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fListaCLI()


	cQUERY := " SELECT E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_DATA, E5_VALOR, E5_BENEF, E5_HISTOR, E5_RECPAG, E5_NATUREZ, ED_DESCRIC "
	cQUERY += " FROM " + RetSqlName( "SE5" ) + " SE5 "
	cQUERY += " LEFT JOIN " + RetSqlName( "SED" ) + " SED "
	cQUERY += " ON E5_NATUREZ = ED_CODIGO "
	cQUERY += " WHERE SE5.D_E_L_E_T_ = ''"
	cQUERY += " AND SE5.D_E_L_E_T_ = ''"
	cQUERY += " AND E5_DATA BETWEEN '20180101' AND '20180230' "
	Do Case
		Case Subst(cCart,1,2) == '1 ' //PAGAR
			cQUERY += " AND E5_RECPAG = 'P' "
		Case Subst(cCart,1,2) == '2 ' //RECEBER
			cQUERY += " AND E5_RECPAG = 'R' "
//		Case Subst(cCart,1,2) == '3 ' //AMBAS
	EndCase
	cQUERY += " ORDER BY E5_DATA"


//cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TMPSA1
TCQUERY cQUERY Alias TMPSA1 New
//TCSetField( 'CLI', "E5_DATA", "D" )

CLI->( __DbZap() )
Dbselectarea("TMPSA1")
dbgotop()
If !Eof()
	While !Eof()

		Dbselectarea("CLI")
		Reclock("CLI",.T.)
		Replace PREF 	With TMPSA1->E5_PREFIXO
		Replace NUM    	With TMPSA1->E5_NUMERO
		Replace PARC    With TMPSA1->E5_PARCELA
		Replace NAT     With TMPSA1->E5_NATUREZ
		Replace DESCNAT With TMPSA1->ED_DESCRIC
		Replace DATAR   With DtoC(StoD(TMPSA1->E5_DATA))
		Replace VALOR   With TMPSA1->E5_VALOR
		Replace BENEF  	With TMPSA1->E5_BENEF
		Replace HISTOR  With TMPSA1->E5_HISTOR
		Replace RECPAG  With TMPSA1->E5_RECPAG

		msunlock()
		Dbselectarea("TMPSA1")
		dbskip()
	End

//	oBRW0:oBROWSE:bChange     := { || ExibeBrw1() }
//	oBRW0:oBROWSE:bGotFocus   := { || ExibeBrw1() }

//	Dbselectarea("CLI")
//	dbgotop()

Else
	Alert("Nenhum cliente Encontrado. Verifique informacoes !!!")
Endif

CLI->( dbgotop() )

dbclosearea("TMPSA1")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Sair     บAutor  ณMicrosiga           บ Data ณ  10/15/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fUpdTit()
/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis do Tipo Local, Private e Public                 ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
Local lContinua		:= .F.
Local COBS	:= Space(10)

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
SetPrvt("oDlg1","oPanel1","oSay1","oGet1","oSBtn1","oSBtn2")

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
oDlg1      := MSDialog():New( 331,340,428,953,"Nova Natureza",,,.F.,,,,,,.T.,,,.F. )
oPanel1    := TPanel():New( 0-3,000,"",oDlg1,,.F.,.F.,,,300,045,.T.,.F. )
oSay1      := TSay():New( 004,004,{||"Natureza"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,009)
oGet1      := TGet():New( 012,004,,oPanel1,120,013,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SED","cOBS",,)
oGet1:bSetGet := {|u| If(PCount()>0,cOBS:=u,cOBS)}

oSBtn1     := SButton():New( 031,216,1,,oPanel1,,"", )
oSBtn1:bAction := {||lContinua	:= .T., oDlg1:end()}

oSBtn2     := SButton():New( 031,267,2,,oPanel1,,"", )
oSBtn2:bAction := {||lContinua	:= .F., oDlg1:end()}

oDlg1:Activate(,,,.T.)

If lContinua

	fUPDATE(COBS, CLI->NUM, CLI->PARC, CLI->PREF, CLI->RECPAG )

EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fUPDATE  บAutor  ณGustavo Costa      บ Data ณ  25/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza o status do guia de conferencia da NFE.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fUPDATE(cNat, cNum, cParc, cPref, cRP)

Local cQuery
local cQry 
Loca cIdOri

cQry := "SELECT E5_IDORIG FROM "+RetSqlName("SE5") + " E5 "
cQry += " WHERE E5_NUMERO = '" + cNum + "' "
cQry += " AND E5_PARCELA = '" + cParc + "' "
cQry += " AND E5_PREFIXO = '" + cPref + "' "
cQry += " AND D_E_L_E_T_ <> '*' "

If Select("LOTX") > 0
	DbSelectArea("LOTX")
	LOTX->(DbCloseArea())
EndIf

TCQUERY cQry NEW ALIAS 'LOTX'    

IF LOTX->(!EOF())

   cIdOri:= LOTX->E5_IDORIG 

ENDIF

LOTX->(DbCloseArea())


cQuery := " UPDATE " + RetSqlName("SE5")
cQuery += " SET E5_NATUREZ = '" + cNat + "' "
cQuery += " WHERE E5_NUMERO = '" + cNum + "' "
cQuery += " AND E5_PARCELA = '" + cParc + "' "
cQuery += " AND E5_PREFIXO = '" + cPref + "' "
cQuery += " AND D_E_L_E_T_ <> '*' "

	//TcSqlExec(cQuery)
ConOut("UPD SE5 ")
If TCSqlExec( cQuery ) < 0
   
   ConOut("Erro SE5 ")
   Return .F.
   
EndIf

	cQuery := " UPDATE " + RetSqlName("FK5")
	cQuery += " SET FK5_NATURE = '" + cNat + "' "
	cQuery += " WHERE FK5_IDMOV = '" + cIdOri + "' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	ConOut("UPD FK5 ")
	If TCSqlExec( cQuery ) < 0
	   
	   ConOut("Erro FK5 ")
	   Return .F.
	   
	EndIf


If	cRP = 'P' //pagar

	cQuery := " UPDATE " + RetSqlName("SE2")
	cQuery += " SET E2_NATUREZ = '" + cNat + "' "
	cQuery += " WHERE E2_NUM = '" + cNum + "' "
	cQuery += " AND E2_PARCELA = '" + cParc + "' "
	cQuery += " AND E2_PREFIXO = '" + cPref + "' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	ConOut("UPD SE2 ")
	If TCSqlExec( cQuery ) < 0
	   
	   ConOut("Erro SE2 ")
	   Return .F.
	   
	EndIf

	cQuery := " UPDATE " + RetSqlName("SK1")
	cQuery += " SET K1_NATUREZ = '" + cNat + "' "
	cQuery += " WHERE K1_NUM = '" + cNum + "' "
	cQuery += " AND K1_PARCELA = '" + cParc + "' "
	cQuery += " AND K1_PREFIXO = '" + cPref + "' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	ConOut("UPD SK1 ")
	If TCSqlExec( cQuery ) < 0
	   
	   ConOut("Erro SK1 ")
	   Return .F.
	   
	EndIf
	
	cQuery := " UPDATE " + RetSqlName("FK2")
	cQuery += " SET FK2_NATURE = '" + cNat + "' "
	cQuery += " WHERE FK2_IDFK2 = '" + cIdOri + "' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	ConOut("UPD FK2 ")
	If TCSqlExec( cQuery ) < 0
	   
	   ConOut("Erro FK2 ")
	   Return .F.
	   
	EndIf

Else

	cQuery := " UPDATE " + RetSqlName("SE1")
	cQuery += " SET E1_NATUREZ = '" + cNat + "' "
	cQuery += " WHERE E1_NUM = '" + cNum + "' "
	cQuery += " AND E1_PARCELA = '" + cParc + "' "
	cQuery += " AND E1_PREFIXO = '" + cPref + "' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	ConOut("UPD SE1 ")
	If TCSqlExec( cQuery ) < 0
	   
	   ConOut("Erro SE1 ")
	   Return .F.
	   
	EndIf

	cQuery := " UPDATE " + RetSqlName("SK1")
	cQuery += " SET K1_NATUREZ = '" + cNat + "' "
	cQuery += " WHERE K1_NUM = '" + cNum + "' "
	cQuery += " AND K1_PARCELA = '" + cParc + "' "
	cQuery += " AND K1_PREFIXO = '" + cPref + "' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	ConOut("UPD SK1 ")
	If TCSqlExec( cQuery ) < 0
	   
	   ConOut("Erro SK1 ")
	   Return .F.
	   
	EndIf

	cQuery := " UPDATE " + RetSqlName("FK1")
	cQuery += " SET FK1_NATURE = '" + cNat + "' "
	cQuery += " WHERE FK1_IDFK1 = '" + cIdOri + "' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	ConOut("UPD FK1 ")
	If TCSqlExec( cQuery ) < 0
	   
	   ConOut("Erro FK1 ")
	   Return .F.
	   
	EndIf

EndIf

Return .T.

