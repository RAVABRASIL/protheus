#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"
#include "ap5mail.ch"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบDesc.     ณ Consulta do gerenciador de ligacoes da cobranca            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rava Embalagens - Cobranca                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COBC051()

Private dDataIni := dDatabase
Private dDataFim := dDatabase

@ 96,30 TO 200,300 DIALOG oDlg1 TITLE "Gerenciar ligacoes"

@ 005,010 Say "Data Inicial :"
@ 005,040 get dDataIni SIZE 40,30

@ 020,010 Say "Data Final   :"
@ 020,040 get dDataFim SIZE 40,30


@ 037,020 BUTTON "Confirma"   SIZE 40,15  ACTION OkConsulta()
@ 037,060 BUTTON "Cancela"    SIZE 40,15  ACTION Close(oDlg1)

ACTIVATE DIALOG oDlg1 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC041   บAutor  ณMicrosiga           บ Data ณ  06/21/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OkConsulta()

******** VARIAVEIS USADAS **********

aCPOBRW2   := {}
lFLAG      := .F.
Private nAtend     := 0
Private nPosit     := 0
Private nLigac     := 0
Private nNegat     := 0

******** INICIO DO PROCESSAMENTO ********

MsAguarde({|| lFLAG := LeAtendentes() }, OemToAnsi("Aguarde"), OemToAnsi("Gerando Informacoes..."))

If ! lFLAG
	Return NIL
EndIf

******** JANELA DE DIALOGO PRINCIPAL **********

@ 000,000 To 550,785 Dialog oDLG11 Title OemToAnsi( "Gerenciador da Cobranca" )

@ 006,005 Say OemToAnsi("Data Inicial :") COLOR CLR_GREEN
@ 006,040 Say dDataIni COLOR CLR_GREEN Object oDataIni

@ 006,085 Say OemToAnsi("Atendentes :") COLOR CLR_HBLUE
@ 006,120 Say nAtend COLOR CLR_HBLUE //Object oAtend

@ 006,160 Say OemToAnsi("Positivo :") COLOR CLR_HBLUE
@ 006,190 Say nPosit COLOR CLR_HBLUE //Object oPosit

@ 020,005 Say OemToAnsi("Data Final   :") COLOR CLR_GREEN
@ 020,040 Say dDataFim COLOR CLR_GREEN Object oDataFim

@ 020,085 Say OemToAnsi("Ligacoes :") COLOR CLR_HBLUE
@ 020,120 Say nLigac COLOR CLR_HBLUE //Object oligac

@ 020,160 Say OemToAnsi("Negativo :") COLOR CLR_HBLUE
@ 020,190 Say nNegat COLOR CLR_RED //Object oNegat

oDataIni:SetText( DTOC(dDataIni) )
oDataFim:SetText( DTOC(dDataFim) )
/*
oAtend:SetText( Trans( nAtend , ( "@E 9,999" ) ) )
oPosit:SetText( Trans( nPosit , ( "@E 9,999" ) ) )
oLigac:SetText( Trans( nLigac , ( "@E 9,999" ) ) )
oNegat:SetText( Trans( nNegat , ( "@E 9,999" ) ) )
*/

Dbselectarea("MAR")

Dbselectarea("MAR")

oBRW2:= MsSelect():New( "MAR",, "", aCPOBRW2,,, { 030, 002, 240, 393 } )

@ 255,090 Button OemToAnsi("_Imprimir") Size 40,12 Action ImpGeral() Object oImpGeral //ProcPreAc()
@ 255,150 Button OemToAnsi("_Detalhar") Size 40,12 Action Detalhar() Object oDetalhar //ProcPreAc()
@ 255,210 Button OemToAnsi("_Sair") Size 40,12 Action oDLG11:End() Object oSAIR

Activate Dialog oDLG11 Centered Valid Sair()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC041   บAutor  ณMicrosiga           บ Data ณ  06/21/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LeAtendentes()

aCAMPOS := { { "CODATEND" , "C", 06, 0 }, ;
{ "NOMATEND"    , "C", 20, 0 }, ;
{ "CONSULTAS"   , "N", 05, 0 }, ;
{ "POSITIVOS"   , "N", 05, 0 }, ;
{ "NEGATIVOS"   , "N", 05, 0 }, ; //O campo padrao do tem 10 posicoes, diminuimos para diminuir na tela.
{ "AGENDADOS"   , "N", 05, 0 }, ;
{ "HRUTEIS"     , "C", 08, 0 }, ;
{ "HRTRAB"      , "C", 08, 0 }, ;
{ "MEDHR"       , "C", 08, 0 } }

cARQEMP := CriaTrab( aCAMPOS, .T. )
DbUseArea( .T.,, cARQEMP, "MAR", .F., .F. )

dbselectarea("ZA8")

//Monta a consulta para a selecao dos titulos
cQUERY := " Select ZA8.* "
cQUERY += " From " + RetSqlName( "ZA8" ) + " ZA8, "+ RetSqlName( "ZA1" ) + " ZA1 "
cQUERY += " Where ZA8.ZA8_DTATEN BETWEEN '" + DTOS(dDataIni) + "' AND '"+DTOS(dDataFim) + "' "
cQUERY += " AND ZA8_HRFIM <> '' "
cQUERY += " AND ZA8_CODATE = ZA1_COD "
cQUERY += " AND ZA1_ATIVO = 'S' "
cQUERY += " AND ZA1.D_E_L_E_T_ = '' "
cQUERY += " AND ZA8.D_E_L_E_T_ = '' "
cQUERY += " Order By ZA8.ZA8_CODATE, ZA8_HRINI"

cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TITSE1
TCQUERY cQUERY Alias TMPZA8 New
/*
TcSetField( "TITSE1", "E1_VALOR"  , "N", 12, 2 )
TcSetField( "TITSE1", "E1_SALDO"  , "N", 12, 2 )
TcSetField( "TITSE1", "E1_VENCREA", "D", 08, 0 )
TcSetField( "TITSE1", "E1_VENCTO" , "D", 08, 0 )
TcSetField( "TITSE1", "E1_EMISSAO", "D", 08, 0 )
*/
//Carrega arquivo de trabalho criado com os dados da consulta
Dbselectarea("TMPZA8")
dbgotop()

While !Eof()

	nAtend     ++
	cAtend     := TMPZA8->ZA8_CODATE
	cNomAtend  := TMPZA8->ZA8_NOMATE
	nConsultas := 0
	nPositivos := 0
	nNegativos := 0
	nAgendados := 0
	cHrUteis   := '08:00:00'
	nHoras     := 0
	nMinutos   := 0
	nSegundos  := 0
	cMedHr     := '00:00:00'

	While !eof() .And. cAtend == TMPZA8->ZA8_CODATE

		nConsultas  ++

		If TMPZA8->ZA8_QUALI == 'P'
			nPositivos ++
		Else
			nNegativos ++
		Endif

		If TMPZA8->ZA8_PRIOR $ 'P14 P16' //Agendado ou agendado pelo acordo
			nAgendados ++
		Endif

		cHoras     := ElapTime(TMPZA8->ZA8_HRINI,TMPZA8->ZA8_HRFIM) //Tempo deste atendimento
		nHoras     += Val(Subst(cHoras,1,2))
		nMinutos   += Val(Subst(cHoras,4,2))
		nSegundos  += Val(Subst(cHoras,7,2))

		dbskip()
	End

	nMinLig    := Round(((nHoras*60) + nMinutos + (nSegundos/60)) / nConsultas,2)
	nMinLig    := Int(nMinLig)+ (((nMinLig-Int(nMinLig)) * 60) / 100)
	nMinLig    := nMinlig /100

	If Len(Alltrim(Str(Int(nMinLig)))) > 2
		cMinLig  := StrZero(Int(nMinLig),3)+":"+Subst(StrZero(int((nMinLig-Int(nMinLig))*10000),4),1,2)+":"+Subst(StrZero(int((nMinLig-Int(nMinLig))*10000),4),3,2)
	Else
		cMinLig  := StrZero(Int(nMinLig),2)+":"+Subst(StrZero(int((nMinLig-Int(nMinLig))*10000),4),1,2)+":"+Subst(StrZero(int((nMinLig-Int(nMinLig))*10000),4),3,2)
	Endif
	nMedHr     := nHoras/nConsultas
	nMedMin    := nMinutos/nConsultas
	nMedSeg    := nSegundos/nConsultas

	//Montando Horas Trabalhadas
	nSegundos1 := nSegundos/60
	nSegundos2 := (nSegundos1-Int(nSegundos1))*0.6
	nSegundos3 := nSegundos2/100

	nMinutos1  := ( nMinutos+Int(nSegundos1) )/60
	nMinutos2  := (nMinutos1-Int(nMinutos1))*0.6
	nMinutos3  := nMinutos2

	nHoras1    := nHoras + Int(nMinutos1)
	nTempoliq  := nHoras1+nMinutos3+nSegundos3

	If Len(Alltrim(Str(Int(nTempoliq)))) > 2
		cTempoLiq  := StrZero(Int(nTempoliq),3)+":"+Subst(StrZero(int((nTempoliq-Int(nTempoliq))*10000),4),1,2)+":"+Subst(StrZero(int((nTempoliq-Int(nTempoliq))*10000),4),3,2)
	Else
		cTempoLiq  := StrZero(Int(nTempoliq),2)+":"+Subst(StrZero(int((nTempoliq-Int(nTempoliq))*10000),4),1,2)+":"+Subst(StrZero(int((nTempoliq-Int(nTempoliq))*10000),4),3,2)
	Endif

	cMedHr  := '00:00:00'

	Reclock("MAR",.T.)
	Replace CODATEND  With cAtend
	Replace NOMATEND  With cNomAtend
	Replace CONSULTAS With nConsultas
	Replace POSITIVOS With nPositivos
	Replace NEGATIVOS with nNegativos
	Replace AGENDADOS With nAgendados
	Replace HRUTEIS   With cHrUteis
	Replace HRTRAB    With cTempoLiq
	Replace MEDHR     With cMinLig
	msunlock()
	nPosit += nPositivos
	nLigac += nConsultas
	nNegat += nNegativos
	Dbselectarea("TMPZA8")
End

Dbclosearea("TMPZA8")

MAR->( DbGotop() )

aCPOBRW2  :=  { { "NOMATEND"    ,,OemToAnsi( "Atendente" ) }, ;
{ "CONSULTAS"   ,, OemToAnsi( "Ligacoes"  ), "@E 99,999" } , ;
{ "POSITIVOS"   ,, OemToAnsi( "Lig Posit" ), "@E 99,999" } , ;
{ "NEGATIVOS"   ,, OemToAnsi( "Lig Negat" ), "@E 99,999" } , ;
{ "AGENDADOS"   ,, OemToAnsi( "Agendados" ), "@E 99,999" } , ;
{ "HRUTEIS"     ,, OemToAnsi( "Hr Uteis"  ) }, ;
{ "HRTRAB"      ,, OemToAnsi( "Hr Trab"   ) }, ;
{ "MEDHR"       ,, OemToAnsi( "Med Hr"    ) } }

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC041   บAutor  ณMicrosiga           บ Data ณ  06/22/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Detalhar()

******** VARIAVEIS USADAS **********

aCPODET   := {}
lFLAG      := .F.

Private nAtendDt     := 0
Private nPositDt     := 0
Private nLigacDt     := 0
Private nNegatDt     := 0

******** INICIO DO PROCESSAMENTO ********

MsAguarde({|| lFLAG := Detalhes() }, OemToAnsi("Aguarde"), OemToAnsi("Detalhando Informacoes..."))

If ! lFLAG
	Return NIL
EndIf

******** JANELA DE DIALOGO PRINCIPAL **********

@ 000,000 To 550,785 Dialog oDLG12 Title OemToAnsi( "Detalhes - "+MAR->NOMATEND )

@ 006,005 Say OemToAnsi("Data Inicial :") COLOR CLR_GREEN
@ 006,040 Say dDataIni COLOR CLR_GREEN Object oDataIni

@ 006,085 Say OemToAnsi("Ligacoes  :") COLOR CLR_HBLUE
@ 006,120 Say nLigacDt COLOR CLR_HBLUE //Object oligacDt

@ 006,160 Say OemToAnsi("Positivo :") COLOR CLR_HBLUE
@ 006,190 Say nPositDT COLOR CLR_HBLUE //Object oPositDt

@ 006,300 Say OemToAnsi("Hr Trab:") COLOR CLR_HBLUE
@ 006,330 Say MAR->HRTRAB COLOR CLR_HBLUE //Object oAtivoDt

@ 020,005 Say OemToAnsi("Data Final   :") COLOR CLR_GREEN
@ 020,040 Say dDataFim COLOR CLR_GREEN Object oDataFim

@ 020,160 Say OemToAnsi("Negativo :") COLOR CLR_HBLUE
@ 020,190 Say nNegatDt COLOR CLR_RED //Object oNegatDt

@ 020,300 Say OemToAnsi("Med Ligac:") COLOR CLR_HBLUE
@ 020,330 Say MAR->MEDHR COLOR CLR_RED //Object oRecepDt

oDataIni:SetText( DTOC(dDataIni) )
oDataFim:SetText( DTOC(dDataFim) )
/*
//oPositDt:SetText( Trans( nPositDt , ( "@E 9,999" ) ) )
oLigacDt:SetText( Trans( nLigacDt , ( "@E 9,999" ) ) )
oNegatDt:SetText( Trans( nNegatDt , ( "@E 9,999" ) ) )
*/

Dbselectarea("DET")

oBRW2:= MsSelect():New( "DET",, "", aCPODET,,, { 030, 002, 240, 393 } )

@ 255,150 Button OemToAnsi("_Imprimir") Size 40,12 Action ImpDetal() Object oImpDetal
@ 255,210 Button OemToAnsi("_Voltar") Size 40,12 Action oDLG12:End() Object oVoltar

Activate Dialog oDLG12 Centered Valid Voltar()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC041   บAutor  ณMicrosiga           บ Data ณ  06/22/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Sair()

Dbselectarea("MAR")
DbCloseArea("MAR")

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC041   บAutor  ณMicrosiga           บ Data ณ  06/22/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Voltar()

Dbselectarea("DET")
DbCloseArea("DET")

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC041   บAutor  ณMicrosiga           บ Data ณ  06/21/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Detalhes()

aCAMPOS := { { "DTATEN" , "D", 08, 0 }, ;
{ "CODCLI"      , "C", 09, 0 }, ;
{ "NOMCLI"      , "C", 25, 0 }, ;
{ "HRINI"       , "C", 08, 0 }, ;
{ "HRFIM"       , "C", 08, 0 }, ;
{ "FILA"        , "C", 03, 0 }, ; //O campo padrao do tem 10 posicoes, diminuimos para diminuir na tela.
{ "SEQUEN"      , "C", 04, 0 }, ;
{ "QUALIDADE"   , "C", 01, 0 }, ;
{ "TEMPO"       , "C", 08, 0 } }

cARQEMP := CriaTrab( aCAMPOS, .T. )
DbUseArea( .T.,, cARQEMP, "DET", .F., .F. )

dbselectarea("ZA8")

//Monta a consulta para a selecao dos titulos
cQUERY := " Select ZA8.* "
cQUERY += " From " + RetSqlName( "ZA8" ) + " ZA8 "
cQUERY += " Where ZA8.ZA8_DTATEN BETWEEN '" + DTOS(dDataIni) + "' AND '"+DTOS(dDataFim) + "' "
cQUERY += " AND ZA8_HRFIM <> '' "
cQUERY += " AND ZA8_CODATE = '" + MAR->CODATEND+"' "
cQUERY += " AND ZA8.D_E_L_E_T_ = '' "
cQUERY += " Order By ZA8.ZA8_CODATE, ZA8_HRINI"

cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TITSE1
TCQUERY cQUERY Alias TMPZA8 New

TcSetField( "TMPZA8", "ZA8_DTATEN"  , "D", 8, 0 )

//Carrega arquivo de trabalho criado com os dados da consulta
Dbselectarea("TMPZA8")
dbgotop()

While !Eof()

	Reclock("DET",.T.)
	Replace DTATEN    With TMPZA8->ZA8_DTATEN
	Replace CODCLI    With TMPZA8->ZA8_CODCLI+"-"+TMPZA8->ZA8_LJCLI
	Replace NOMCLI    With TMPZA8->ZA8_NOMCLI
	Replace HRINI     With TMPZA8->ZA8_HRINI
	Replace HRFIM     with TMPZA8->ZA8_HRFIM
	Replace FILA      With TMPZA8->ZA8_PRIOR
	Replace SEQUEN    With TMPZA8->ZA8_SEQUEN
	Replace QUALIDADE with TMPZA8->ZA8_QUALI
	Replace TEMPO     With ElapTime(TMPZA8->ZA8_HRINI,TMPZA8->ZA8_HRFIM)
	msunlock()
	If TMPZA8->ZA8_QUALI == 'P'
		nPositDt ++
	Else
		nNegatDt ++
	Endif

	nLigacDt ++

	Dbselectarea("TMPZA8")
	dbskip()
End

Dbclosearea("TMPZA8")

DET->( DbGotop() )

aCPODET  :=  { { "DTATEN"        ,,OemToAnsi( "Data" ) }, ;
{ "CODCLI"      ,, OemToAnsi( "Cliente"   ) } , ;
{ "NOMCLI"      ,, OemToAnsi( "Nome"      ) } , ;
{ "HRINI"       ,, OemToAnsi( "Inicio"    ) } , ;
{ "HRFIM"       ,, OemToAnsi( "Fim"       ) } , ;
{ "FILA"        ,, OemToAnsi( "Fila"      ) } , ;
{ "SEQUEN"      ,, OemToAnsi( "Seq"       ) } , ;
{ "QUALIDADE"   ,, OemToAnsi( "Quali"     ) } , ;
{ "TEMPO"       ,, OemToAnsi( "Tempo"     ) } }

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC041   บAutor  ณMicrosiga           บ Data ณ  06/22/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpGeral()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Controle Geral de Ligacoes - SISCOB"
Local cPict          := ""
Local titulo       := "Controle Geral de Ligacoes - SISCOB"
Local nLin         := 80

local cabec1       := "Atendente                  |           |   Qualidade   |       |       Tempo        |         |"
Local Cabec2       := "                           | Ligacoes  |  Posit  Negat | Agend |   Util      Trab   |  Media  |"
//                     1234567890123456789012345      999,999    9,999  9,999   9,999  9,999    9,999  00:00:00  00:00:00   00:00:00
//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                               1         2         3         4         5         6         7         8

Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "IMPGERAL" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "IMPGERAL" // Coloque aqui o nome do arquivo usado para impressao em disco

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cString := "ZA8"

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunRepGeral(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  03/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunRepGeral(Cabec1,Cabec2,Titulo,nLin)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do cabecalho do relatorio. . .                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If nLin > 50 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

/*
oAtend:SetText( Trans( nAtend , ( "@E 9,999" ) ) )
oPosit:SetText( Trans( nPosit , ( "@E 9,999" ) ) )
oLigac:SetText( Trans( nLigac , ( "@E 9,999" ) ) )
oNegat:SetText( Trans( nNegat , ( "@E 9,999" ) ) )
*/

@ nlin,000 pSay "Data Inicial : "+DTOC(dDataIni)
@ nlin,029 pSay "Atendentes: "+Transform( nAtend ,("@E 9,999") )
@ nlin,051 pSay "Positivo: "  +Transform( nPosit ,("@E 9,999") )
//Data Inicial: 22/06/2005     Atendentes: 9,999     Positivo: 9,999    Ativo    : 9,999
//Data Final  : 22/06/2005     Consultas : 9,999     Negativo: 9,999    Receptivo: 9,999
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          1         2         3         4         5         6         7         8         9

nlin ++
@ nlin,000 pSay "Data Final   : "+DTOC(dDataFim)
@ nlin,029 pSay "Ligacoes  : "+Transform( nLigac ,("@E 9,999") )
@ nlin,051 pSay "Negativo: "  +Transform( nNegat ,("@E 9,999") )
nlin ++
nlin ++
Dbselectarea("MAR")
dbgotop()

While !Eof()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	@ nlin,000 pSay MAR->NOMATEND
	@ nlin,031 pSay MAR->CONSULTAS  Picture "@E 999,999"
	@ nlin,042 pSay MAR->POSITIVOS Picture "@E 9,999"
	@ nlin,049 pSay MAR->NEGATIVOS Picture "@E 9,999"
	@ nlin,058 pSay MAR->AGENDADOS Picture "@E 9,999"
	@ nlin,065 pSay MAR->HRUTEIS   Picture "@!"
	@ nlin,075 pSay MAR->HRTRAB    Picture "@!"
	@ nlin,086 pSay MAR->MEDHR     Picture "@!"
	nlin ++
	dbskip()
End

dbgotop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOBC041   บAutor  ณMicrosiga           บ Data ณ  06/22/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpDetal()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Controle Geral de Ligacoes - SISCOB - DETALHADO"
Local cPict          := ""
Local titulo       := "Controle Geral de Ligacoes - SISCOB - DETALHADO"
Local nLin         := 80

local cabec1       := "                                                     |    Atendimento    |  Fila Seq  | Quali |  Tempo   |"
Local Cabec2       := "Data       Cliente   Nome                            |  Inicio    Fim    |            |       |          |"
//                     99/99/9999 123456-99 123456789012345678901234567890    99:99:99 99:99:99    123  1234     1      1     99:99:99
//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//                               1         2         3         4         5         6         7         8

Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "IMPDETAL" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "IMPDETAL" // Coloque aqui o nome do arquivo usado para impressao em disco

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cString := "ZA8"

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunRepDetal(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  03/02/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunRepDetal(Cabec1,Cabec2,Titulo,nLin)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do cabecalho do relatorio. . .                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If nLin > 50 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

/*
oAtend:SetText( Trans( nAtend , ( "@E 9,999" ) ) )
oPosit:SetText( Trans( nPosit , ( "@E 9,999" ) ) )
oLigac:SetText( Trans( nLigac , ( "@E 9,999" ) ) )
oNegat:SetText( Trans( nNegat , ( "@E 9,999" ) ) )
*/

@ nlin,000 pSay "Detalhes Atendente : "+MAR->NOMATEND
nlin := nlin + 2
@ nlin,000 pSay "Data Inicial : "+DTOC(dDataIni)
@ nlin,029 pSay "Ligacoes  : "+Transform( nLigacDt ,("@E 9,999") )
@ nlin,051 pSay "Positivo: "  +Transform( nPositDt ,("@E 9,999") )
//Data Inicial: 22/06/2005     Atendentes: 9,999     Positivo: 9,999    Ativo    : 9,999
//Data Final  : 22/06/2005     Consultas : 9,999     Negativo: 9,999    Receptivo: 9,999
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          1         2         3         4         5         6         7         8         9

nlin ++
@ nlin,000 pSay "Data Final   : "+DTOC(dDataFim)
@ nlin,051 pSay "Negativo: "  +Transform( nNegatDt ,("@E 9,999") )
nlin := nlin + 2
Dbselectarea("DET")
dbgotop()

While !Eof()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	/*
	local cabec1       := "Atendente                                            |    Atendimento    |  Fila Seq  | Quali |  Tempo   |"
	Local Cabec2       := "Data       Cliente   Nome                            |  Inicio    Fim    |            |       |          |"
	//                     99/99/9999 123456-99 123456789012345678901234567890    99:99:99 99:99:99    123  1234     1      1     99:99:99
	//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
	//                               1         2         3         4         5         6         7         8
	*/
	@ nlin,000 pSay DTOC(DET->DTATEN)
	@ nlin,011 pSay DET->CODCLI    Picture "@!"
	@ nlin,021 pSay DET->NOMCLI    Picture "@!"
	@ nlin,055 pSay DET->HRINI     Picture "@!"
	@ nlin,064 pSay DET->HRFIM     Picture "@!"
	@ nlin,076 pSay DET->FILA      Picture "@!"
	@ nlin,081 pSay DET->SEQUEN    Picture "@!"
	@ nlin,090 pSay DET->QUALIDADE Picture "@!"
	@ nlin,096 pSay DET->TEMPO     Picture "@!"
	nlin ++
	dbskip()
End

dbgotop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return .t.
