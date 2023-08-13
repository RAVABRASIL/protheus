#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบDesc.     ณ Pesquisa Avancada da cobranca                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rava Embalagens - Cobranca                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COBC012()

Private oDlg,oCombo1,oSay2,oGet3,oSBtn4,oSBtn5
Private cPesquisa := Space(30)

@ 000,000 To 400,750 Dialog oDLG Title "Cobranca Geral"

aCAMPOS := { { "CLIENTE", "C", 06, 0 }, ;
{ "LOJA"   , "C", 02, 0 }, ;
{ "NOME"   , "C", 30, 0 }, ;
{ "CGC"    , "C", 15, 0 }, ;
{ "GR"     , "C", 04, 0 }, ;
{ "CIDADE" , "C", 30, 0 }, ;
{ "UF"     , "C", 02, 0 }, ;
{ "STATUS" , "C", 15, 0 }, ;
{ "AGENDADO", "D", 08, 0 }, ;
{ "HORA"   , "C", 05, 0 }, ;
{ "CONTATO", "D", 08, 0 } }

cARQCLI1 := CriaTrab( aCAMPOS, .T. )
DbUseArea( .T.,, cARQCLI1, "CLI", .F., .F. )
//Index On CLIENTE To &cARQCLI1
//Set Index To &cARQCLI1

oCombo1 := TCOMBOBOX():Create(oDlg)
oCombo1:cName := "oCombo1"
oCombo1:cCaption := "oCombo1"
oCombo1:nLeft := 100
oCombo1:nTop := 36
oCombo1:nWidth := 145
oCombo1:nHeight := 21
oCombo1:lShowHint := .F.
oCombo1:lReadOnly := .F.
oCombo1:Align := 0
oCombo1:lVisibleControl := .T.
oCombo1:cVariable := "cOpcao"
oCombo1:bSetGet := {|u| If(PCount()>0,cOpcao:=u,cOpcao) }
oCombo1:aItems := {"1 - Codigo Cliente","2 - Nome Cliente","3 - CGC / CPF","4 - Pedido","5 - Tํtulo","6 - Valor","7 - Cidade",;
"8 - Cod Identificador","9 - Nosso N๚mero","10 - Status Cob","11 - Telefone","12 - Grupo Empresarial",;
"13 - Representante","14 - Retorno Agendado","15 - D-(n Dias)","16 - Acordo Agendado","17 - Cheques"}
oCombo1:nAt := 0

oSay2 := TSAY():Create(oDlg)
oSay2:cName := "oSay2"
oSay2:cCaption := "Pesquisa"
oSay2:nLeft := 20
oSay2:nTop := 38
oSay2:nWidth := 65
oSay2:nHeight := 17
oSay2:lShowHint := .F.
oSay2:lReadOnly := .F.
oSay2:Align := 0
oSay2:lVisibleControl := .T.
oSay2:lWordWrap := .F.
oSay2:lTransparent := .F.

oGET_PESQ:= TGET():Create(oDlg)
oGET_PESQ:cName := "oGET_PESQ"
oGET_PESQ:nLeft := 100
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
oBOT_OK:cCaption := "OK"
oBOT_OK:nLeft := 370
oBOT_OK:nTop := 70
oBOT_OK:nWidth := 100
oBOT_OK:nHeight := 25
oBOT_OK:lShowHint := .F.
oBOT_OK:lReadOnly := .F.
oBOT_OK:Align := 0
oBOT_OK:lVisibleControl := .T.
oBOT_OK:bAction := {|| OK() }

oBOT_COB := TBUTTON():Create(oDlg)
oBOT_COB:cName := "oBOT_COB"
oBOT_COB:cCaption := "Cobranca"
oBOT_COB:nLeft := 370
oBOT_COB:nTop := 36
oBOT_COB:nWidth := 100
oBOT_COB:nHeight := 25
oBOT_COB:lShowHint := .F.
oBOT_COB:lReadOnly := .F.
oBOT_COB:Align := 0
oBOT_COB:lVisibleControl := .T.
oBOT_COB:bAction := {|| Cobranca() }

//So apresenta para os usuarios da cobranca
Dbselectarea("SX5")
Dbseek(xFilial()+"ZU26")
If UPPER(Trim(Subst(cUsuario,7,15))) $ SX5->X5_DESCRI
	oPED_CRED := TBUTTON():Create(oDlg)
	oPED_CRED:cName := "oPED_CRED"
	oPED_CRED:cCaption := "Ped Credito"
	oPED_CRED:nLeft := 500
	oPED_CRED:nTop := 36
	oPED_CRED:nWidth := 100
	oPED_CRED:nHeight := 25
	oPED_CRED:lShowHint := .F.
	oPED_CRED:lReadOnly := .F.
	oPED_CRED:Align := 0
	oPED_CRED:lVisibleControl := .T.
	oPED_CRED:bAction := {|| PedCredito() }
Endif   
//So apresenta para os usuarios da cobranca com pedido antecipado
Dbselectarea("SX5")
Dbseek(xFilial()+"ZU49")
If UPPER(Trim(Subst(cUsuario,7,15))) $ SX5->X5_DESCRI
	oPED_ANTE := TBUTTON():Create(oDlg)
	oPED_ANTE:cName := "oPED_ANTE"
	oPED_ANTE:cCaption := "Ped Antecipado"
	oPED_ANTE:nLeft := 630
	oPED_ANTE:nTop := 36
	oPED_ANTE:nWidth := 100
	oPED_ANTE:nHeight := 25
	oPED_ANTE:lShowHint := .F.
	oPED_ANTE:lReadOnly := .F.
	oPED_ANTE:Align := 0
	oPED_ANTE:lVisibleControl := .T.
	oPED_ANTE:bAction := {|| PedAntecip() }
Endif

/*
oPED_FAT := TBUTTON():Create(oDlg)
oPED_FAT:cName := "oPED_FAT"
oPED_FAT:cCaption := "Ped Cobranca"
oPED_FAT:nLeft := 500
oPED_FAT:nTop := 70
oPED_FAT:nWidth := 100
oPED_FAT:nHeight := 25
oPED_FAT:lShowHint := .F.
oPED_FAT:lReadOnly := .F.
oPED_FAT:Align := 0
oPED_FAT:lVisibleControl := .T.
oPED_FAT:bAction := {|| PedCobranca() }
*/

/*
oBOT_FILA := TBUTTON():Create(oDlg)
oBOT_FILA:cName := "oBOT_FILA"
oBOT_FILA:cCaption := "Fila / Contatos"
oBOT_FILA:nLeft := 551
oBOT_FILA:nTop := 70
oBOT_FILA:nWidth := 140
oBOT_FILA:nHeight := 25
oBOT_FILA:lShowHint := .F.
oBOT_FILA:lReadOnly := .F.
oBOT_FILA:Align := 0
oBOT_FILA:lVisibleControl := .T.
oBOT_FILA:bAction := {|| GeraFila() }
*/

Dbselectarea("CLI")

oBRW1          := MsSelect():New( "CLI",,, ;
{ { "CLIENTE" ,,   OemToAnsi( "Cliente" ) }, ;
{ "LOJA"    ,,   OemToAnsi( "Loja" ) }, ;
{ "NOME"    ,,   OemToAnsi( "Nome" ) }, ;
{ "CIDADE"  ,,   OemToAnsi( "Cidade" ) }, ;
{ "UF"      ,,   OemToAnsi( "UF"     ) }, ;
{ "AGENDADO",,   OemToAnsi( "Dt Agend" ) }, ;
{ "HORA"    ,,   OemToAnsi( "Hr Agend" ) }, ;
{ "CONTATO" ,,   OemToAnsi( "Ult Cont" ) }, ;
{ "STATUS"  ,,   OemToAnsi( "Status" ) }, ;
{ "CGC"     ,,   OemToAnsi( "CGC/CPF" ) }, ;
{ "GR"      ,,   OemToAnsi( "Grupo" ) } }, ;
.F.,, { 050, 002, 200, 375 } )

oBRW1:oBROWSE:bChange     := { || ExibeBrw1() }
oBRW1:oBROWSE:bGotFocus   := { || ExibeBrw1() }

Dbselectarea("CLI")
dbgotop()

//oDlg:Activate()
Activate Dialog oDLG Centered Valid Sair() On Init TpPesq()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIODLG1    บAutor  ณMicrosiga           บ Data ณ  10/14/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ExibeBrw1( lFLAG )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIODLG     บAutor  ณMicrosiga           บ Data ณ  10/14/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PedCobranca()

U_A_EST019()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIODLG     บAutor  ณMicrosiga           บ Data ณ  10/14/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PedCredito()

U_A_EST021()

Return 

Static Function PedAntecip()

U_A_EST031()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIODLG     บAutor  ณMicrosiga           บ Data ณ  10/14/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cobranca()

Dbselectarea("SA1")
Dbsetorder(1)
Dbseek(xfilial()+CLI->CLIENTE+CLI->LOJA)

If Subst(cOpcao,1,2) $ '14151617'
   lTipo := .T.
Else
   lTipo := .F.
Endif
if !CLI->(EOF()) .OR. !CLI->(BOF())
   U_COBC011(,,,lTipo,'P'+Subst(cOpcao,1,2))
else
   Alert("Defina a pesquisa antes de clicar em cobran็a")
endif   

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIODLG     บAutor  ณMicrosiga           บ Data ณ  10/14/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ok()

If Empty(Subst(cOpcao,1,2))
	Alert("Informe a condicao da Pesquisa")
	Return
Endif

If Subst(cOpcao,1,2) == '1 ' //Codigo Cliente
	If Empty(cPesquisa)
		Alert("Pesquisa invalida!!!")
		Return
	Endif

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1 "
	cQUERY += " Where SA1.A1_COD+SA1.A1_LOJA LIKE '" + Trim(cPesquisa) + "%' "
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"
	cQUERY += " ORDER BY SA1.A1_NOME	"

ElseIf Subst(cOpcao,1,2) == '2 ' //Nome Cliente
	If Empty(cPesquisa)
		Alert("Pesquisa invalida!!!")
		Return
	Endif

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1"
	cQUERY += " Where SA1.A1_NOME LIKE '%" + Trim(cPesquisa) + "%' "
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"
	cQUERY += " ORDER BY SA1.A1_NOME	"

ElseIf Subst(cOpcao,1,2) == '3 ' //CGC / CPF
	If Empty(cPesquisa)
		Alert("Pesquisa invalida!!!")
		Return
	Endif

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1 "
	cQUERY += " Where SA1.A1_CGC LIKE '" + Trim(cPesquisa) + "%' "
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"
	cQUERY += " ORDER BY SA1.A1_NOME	"

ElseIf Subst(cOpcao,1,2) == '4 ' //Pedido
	If Empty(cPesquisa)
		Alert("Pesquisa invalida!!!")
		Return
	Endif

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1, " + RetSqlName( "SC5" ) + " SC5 "
	cQUERY += " Where SC5.C5_NUM = '" + Trim(cPesquisa) + "' "
	cQUERY += " AND SC5.C5_CLIENTE+SC5.C5_LOJACLI = SA1.A1_COD+SA1.A1_LOJA"
	cQUERY += " AND SC5.D_E_L_E_T_ = ''"
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"

ElseIf Subst(cOpcao,1,2) == '5 ' //Tํtulo
	If Empty(cPesquisa)
		Alert("Pesquisa invalida!!!")
		Return
	Endif

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1, " + RetSqlName( "SE1" ) + " SE1 "
	cQUERY += " Where SE1.E1_PREFIXO+SE1.E1_NUM+SE1.E1_PARCELA+SE1.E1_TIPO LIKE '%" + Trim(cPesquisa) + "%' "
	cQUERY += " AND SE1.E1_CLIENTE+SE1.E1_LOJA = SA1.A1_COD+SA1.A1_LOJA"
	cQUERY += " AND SE1.D_E_L_E_T_ = ''"
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"
	cQUERY += " GROUP BY A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"

ElseIf Subst(cOpcao,1,2) == '6 '//Valor
	If Empty(cPesquisa)
		Alert("Pesquisa invalida!!!")
		Return
	Endif

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1, " + RetSqlName( "SE1" ) + " SE1 "
	cQUERY += " Where SE1.E1_VALOR LIKE '%" + Trim(cPesquisa) + "%' "
	cQUERY += " AND SE1.E1_CLIENTE+SE1.E1_LOJA = SA1.A1_COD+SA1.A1_LOJA"
	cQUERY += " AND SE1.D_E_L_E_T_ = ''"
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"
	cQUERY += " Group by A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"

ElseIf Subst(cOpcao,1,2) == '7 ' //Cidade
	If Empty(cPesquisa)
		Alert("Pesquisa invalida!!!")
		Return
	Endif

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1"
	cQUERY += " Where SA1.A1_MUN LIKE '" + Trim(cPesquisa) + "%' "
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"

ElseIf Subst(cOpcao,1,2) == '8 ' //Cod Identificador

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1, " + RetSqlName( "SE1" ) + " SE1 "
	cQUERY += " Where SE1.E1_NUMDPID = '" + Trim(cPesquisa) + "' "
	cQUERY += " AND SE1.E1_CLIENTE+SE1.E1_LOJA = SA1.A1_COD+SA1.A1_LOJA"
	cQUERY += " AND SE1.D_E_L_E_T_ = ''"
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"
	cQUERY += " GROUP BY A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"

ElseIf Subst(cOpcao,1,2) == '9 ' //Nosso N๚mero

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1, " + RetSqlName( "SE1" ) + " SE1 "
	cQUERY += " Where SE1.E1_NUMBCO LIKE '" + Trim(cPesquisa) + "%' "
	cQUERY += " AND SE1.E1_CLIENTE+SE1.E1_LOJA = SA1.A1_COD+SA1.A1_LOJA"
	cQUERY += " AND SE1.D_E_L_E_T_ = ''"
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"
	cQUERY += " GROUP BY A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"

ElseIf Subst(cOpcao,1,2) == '10' //Status Cob

	Alert("Ainda nao disponivel!!!")
	Return

ElseIf Subst(cOpcao,1,2) == '11' //Telefone
	If Empty(cPesquisa)
		Alert("Pesquisa invalida!!!")
		Return
	Endif

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1"
	cQUERY += " Where SA1.A1_TEL LIKE '%" + Trim(cPesquisa) + "%' "
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"

ElseIf Subst(cOpcao,1,2) == '12' //Grupo Empresarial

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1"
	cQUERY += " Where SA1.A1_GPEMP = '" + Trim(cPesquisa) + "' "
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"

ElseIf Subst(cOpcao,1,2) == '13' //Representante

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1"
	cQUERY += " Where SA1.A1_VEND = '" + Trim(cPesquisa) + "' "
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"

ElseIf Subst(cOpcao,1,2) == '14' //Retorno Agendado
	dRet := DTOS( CTOD( Left( cPesquisa, 8 ) ) )
	hRet := Substr( cPesquisa, 9, 5 )
	If ! Empty( hRet ) .and. ! U_VldHora( hRet )
		 Return
	EndIf
	If Empty(dRet)
		Alert("Data invalida!!!")
		Return
	Endif
	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1, "+ RetSqlName( "ZZ6" ) + " Z6 "
*	cQUERY += " Where ((Z6.ZZ6_ULCONT < Z6.ZZ6_RETORN AND Z6.ZZ6_ULCONT <> '' AND Z6.ZZ6_RETORN = '"+dRet+"')"
*	cQUERY += " OR (Z6.ZZ6_RETORN <= '"+dRet+"' AND Z6.ZZ6_ULCONT < Z6.ZZ6_RETORN) ) "
	cQUERY += " Where ((Z6.ZZ6_ULCONT < Z6.ZZ6_RETORN AND Z6.ZZ6_ULCONT <> '' AND Z6.ZZ6_RETORN < '"+dRet+"')"
	cQUERY += " OR (Z6.ZZ6_RETORN = '"+dRet+"' AND Z6.ZZ6_ULCONT <= Z6.ZZ6_RETORN AND Z6.ZZ6_HORRET >= '"+hRet+"') ) "
	cQUERY += " AND Z6.ZZ6_TIPRET  = '1'"
	cQUERY += " AND SA1.A1_COD+SA1.A1_LOJA = Z6.ZZ6_CLIENT+Z6.ZZ6_LOJA "
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"
	cQUERY += " AND Z6.D_E_L_E_T_ = ''"
	cQUERY += " ORDER BY Z6.ZZ6_RETORN,Z6.ZZ6_HORRET"

ElseIf Subst(cOpcao,1,2) == '15' //D - (n) Dias

	d1   := dDatabase - Val(cPesquisa)
	dRet := DTOS(d1)
	If Empty(dRet)
		Alert("Data invalida!!!")
		Return
	Endif
	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1, " + RetSqlName( "SE1" ) + " SE1 "
	cQUERY += " Where SE1.E1_VENCREA = '" + dRet + "' "
	cQUERY += " AND SE1.E1_TIPO NOT IN ('NCC','AB-','RA') "
	cQUERY += " AND SE1.E1_SALDO > 0 "
	cQUERY += " AND SE1.E1_CLIENTE+SE1.E1_LOJA = SA1.A1_COD+SA1.A1_LOJA"
	cQUERY += " AND SE1.D_E_L_E_T_ = ''"
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"
	cQUERY += " GROUP BY A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"

ElseIf Subst(cOpcao,1,2) == '16' //Acordo agendado
	dRet := DTOS( CTOD( Left( cPesquisa, 8 ) ) )
	hRet := Substr( cPesquisa, 9, 5 )
	If ! Empty( hRet ) .and. ! U_VldHora( hRet )
		 Return
	EndIf
	If Empty(dRet)
		Alert("Data invalida!!!")
		Return
	Endif
	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1, "+ RetSqlName( "ZZ6" ) + " Z6 "
*	cQUERY += " Where ((Z6.ZZ6_ULCONT < Z6.ZZ6_RETORN AND Z6.ZZ6_ULCONT <> '' AND Z6.ZZ6_RETORN = '"+dRet+"')"
*	cQUERY += " OR (Z6.ZZ6_RETORN <= '"+dRet+"' AND Z6.ZZ6_ULCONT < Z6.ZZ6_RETORN) ) "
	cQUERY += " Where ((Z6.ZZ6_ULCONT < Z6.ZZ6_RETORN AND Z6.ZZ6_ULCONT <> '' AND Z6.ZZ6_RETORN < '"+dRet+"')"
	cQUERY += " OR (Z6.ZZ6_RETORN = '"+dRet+"' AND Z6.ZZ6_ULCONT <= Z6.ZZ6_RETORN AND Z6.ZZ6_HORRET >= '"+hRet+"') ) "
	cQUERY += " AND Z6.ZZ6_TIPRET  = '3'"
	cQUERY += " AND SA1.A1_COD+SA1.A1_LOJA = Z6.ZZ6_CLIENT+Z6.ZZ6_LOJA "
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"
	cQUERY += " AND Z6.D_E_L_E_T_ = ''"
	cQUERY += " ORDER BY Z6.ZZ6_RETORN,Z6.ZZ6_HORRET"

ElseIf Subst(cOpcao,1,2) == '17' //Cheques
   If Val(cPesquisa) < 0 .or. Val(cPesquisa) > 120
		Alert("O n๚mero de dias deve estar entre 0 e 120, n๚mero invalido!!!")
		Return
	Endif
	dRet := dDatabase - Val(cPesquisa)
   dLimite := dRet - 120 //CTOD("14/02/2005") //Data limite para este tipo de controle

	cQUERY := "Select A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST, MAX(E1_EMISSAO) E1_EMISSAO, SUM(E1_SALDO) SALDO"
	cQUERY += " From " + RetSqlName( "SA1" ) + " SA1, " + RetSqlName( "SE1" ) + " SE1 "
	cQUERY += " Where SE1.E1_EMISSAO BETWEEN '" + DTOS(dLimite) + "' AND '" + DTOS(dRet)+ "' "
	cQUERY += " AND SE1.E1_SALDO > 0 " //So titulos com saldo a receber
	cQUERY += " AND SE1.E1_ORIGEM <> 'FINA460' " //So titulos nใo incluidos pela liquida็ใo
	cQUERY += " AND (SE1.E1_NATUREZ = '10101' OR SE1.E1_NATUREZ = '10104') "	//So cheques //Mudar naturezas para nat.usadas na Rava
	cQUERY += " AND SE1.E1_CLIENTE+SE1.E1_LOJA = SA1.A1_COD+SA1.A1_LOJA"
	cQuery += " AND NOT (LEFT(SE1.E1_NUM,1) = 'L' AND RIGHT(RTRIM(SE1.E1_NATUREZ),2)='03' AND SE1.E1_VENCREA >= '"+DTOS(DdataBase)+"') " //Mudar regra
	cQUERY += " AND SE1.D_E_L_E_T_ = ''"
	cQUERY += " AND SA1.D_E_L_E_T_ = ''"
	cQUERY += " GROUP BY A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST"
	cQUERY += " ORDER BY SALDO DESC" //A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_GPEMP, A1_MUN, A1_EST, E1_EMISSAO"

Endif

cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TMPSA1
TCQUERY cQUERY Alias TMPSA1 New

CLI->( __DbZap() )
Dbselectarea("TMPSA1")
dbgotop()
If !Eof()
	While !Eof()
		Dbselectarea("ZZ6")
		Dbsetorder(1)
		Dbseek(xFilial()+TMPSA1->A1_COD+TMPSA1->A1_LOJA)
		If Found() .And. Subst(cOpcao,1,2) == '17' //Cheques
		   //Se for diferente de automatico
		   If (ZZ6->ZZ6_TIPRET <> '2' .And. ZZ6->ZZ6_RETORN > dDatabase) .Or. DTOS(ZZ6->ZZ6_ULCONT) > TMPSA1->E1_EMISSAO
				Dbselectarea("TMPSA1")
		      dbskip()
		      Loop
		   Endif
		Endif
		Dbselectarea("CLI")
		Reclock("CLI",.T.)
		Replace CLIENTE With TMPSA1->A1_COD
		Replace LOJA    With TMPSA1->A1_LOJA
		Replace NOME    With TMPSA1->A1_NOME
		Replace CGC     With TMPSA1->A1_CGC
		Replace GR      With TMPSA1->A1_GPEMP
		Replace CIDADE  With TMPSA1->A1_MUN
		Replace UF      With TMPSA1->A1_EST
		If Empty(ZZ6->ZZ6_FLAG)
			Replace STATUS  With IIF(ZZ6->ZZ6_TIPRET=="1","AGENDADO",IIF(ZZ6->ZZ6_TIPRET=="3","ACORDO AGENDADO","AUTOMATICO"))
		Else
//			Replace STATUS  With "EM CONSULTA"
			Replace STATUS  With "C/ " + ZZ6->ZZ6_FLAG
		Endif
		Replace AGENDADO With ZZ6->ZZ6_RETORN
		Replace HORA     With ZZ6->ZZ6_HORRET
		Replace CONTATO  With ZZ6->ZZ6_ULCONT
		msunlock()
		Dbselectarea("TMPSA1")
		dbskip()
	End

//	oBRW1:oBROWSE:bChange     := { || ExibeBrw1() }
//	oBRW1:oBROWSE:bGotFocus   := { || ExibeBrw1() }

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
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Sair

If MsgBox( "Confirma saida do programa?", "Escolha", "YESNO" )
	CLI->( DbCloseArea() )
	Return .T.
EndIf

Return .F.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC012   บAutor  ณMicrosiga           บ Data ณ  06/17/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TpPesq()

cOpcao := oCombo1:aItems[1]

ObjectMethod( oCombo1, "Refresh()" )

Return(.t.)
