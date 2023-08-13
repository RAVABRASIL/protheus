#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"
#include "ap5mail.ch"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*
�����������������������������������������������������������������������������
���Desc.     � Consulta do gerenciador da cobranca                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rava Embalagens - Cobranca                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function COBC041()

Private dDataIni := dDatabase
Private dDataFim := dDatabase

@ 96,30 TO 200,300 DIALOG oDlg01 TITLE "Gerenciar Cobranca"

@ 005,010 Say "Data Inicial :"
@ 005,040 get dDataIni SIZE 40,30

@ 020,010 Say "Data Final   :"
@ 020,040 get dDataFim SIZE 40,30


@ 037,020 BUTTON "Confirma"   SIZE 40,15  ACTION OkConsulta()
@ 037,060 BUTTON "Cancela"    SIZE 40,15  ACTION oDlg01:End()

ACTIVATE DIALOG oDlg01 CENTERED

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COBC041   �Autor  �Microsiga           � Data �  06/21/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function OkConsulta()

******** VARIAVEIS USADAS **********

aCPOBRW2   := {}
lFLAG      := .F.
Private nAtend     := 0
Private nPosit     := 0
Private nAtivo     := 0
Private nLigac     := 0
Private nNegat     := 0
Private nRecep     := 0

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

@ 006,230 Say OemToAnsi("Ativo  :") COLOR CLR_HBLUE
@ 006,260 Say nAtivo COLOR CLR_HBLUE //Object oAtivo

@ 020,005 Say OemToAnsi("Data Final   :") COLOR CLR_GREEN
@ 020,040 Say dDataFim COLOR CLR_GREEN Object oDataFim

@ 020,085 Say OemToAnsi("Consultas :") COLOR CLR_HBLUE
@ 020,120 Say nLigac COLOR CLR_HBLUE //Object oligac

@ 020,160 Say OemToAnsi("Negativo :") COLOR CLR_HBLUE
@ 020,190 Say nNegat COLOR CLR_RED //Object oNegat

@ 020,230 Say OemToAnsi("Receptivo :") COLOR CLR_HBLUE
@ 020,260 Say nRecep COLOR CLR_RED //Object oRecep


oDataIni:SetText( DTOC(dDataIni) )
oDataFim:SetText( DTOC(dDataFim) )
/*
oAtend:SetText( Trans( nAtend , ( "@E 9,999" ) ) )
oPosit:SetText( Trans( nPosit , ( "@E 9,999" ) ) )
oAtivo:SetText( Trans( nAtivo , ( "@E 9,999" ) ) )
oLigac:SetText( Trans( nLigac , ( "@E 9,999" ) ) )
oNegat:SetText( Trans( nNegat , ( "@E 9,999" ) ) )
oRecep:SetText( Trans( nRecep , ( "@E 9,999" ) ) )
*/

Dbselectarea("MAR")

oBRW2:= MsSelect():New( "MAR",, "", aCPOBRW2,,, { 030, 002, 240, 393 } )

@ 255,100 Button OemToAnsi("_Imprimir") Size 40,12 Action ImpGeral() Object oImpGeral //ProcPreAc()
@ 255,160 Button OemToAnsi("_Detalhar") Size 40,12 Action Detalhar() Object oDetalhar //ProcPreAc()
@ 255,220 Button OemToAnsi("_Sair")     Size 40,12 Action oDLG11:End() Object oSAIR

Activate Dialog oDLG11 Centered Valid Sair()


Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COBC041   �Autor  �Microsiga           � Data �  06/21/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function LeAtendentes()

aCAMPOS := { { "CODATEND" , "C", 06, 0 }, ;
{ "NOMATEND"    , "C", 20, 0 }, ;
{ "CONSULTAS"   , "N", 05, 0 }, ;
{ "POSITIVOS"   , "N", 05, 0 }, ;
{ "NEGATIVOS"   , "N", 05, 0 }, ; //O campo padrao do tem 10 posicoes, diminuimos para diminuir na tela.
{ "AGENDADOS"   , "N", 05, 0 }, ;
{ "ATIVO"       , "N", 05, 0 }, ;
{ "RECEPTIVO"   , "N", 05, 0 }, ;
{ "HRUTEIS"     , "C", 08, 0 }, ;
{ "HRTRAB"      , "C", 08, 0 }, ;
{ "MEDHR"       , "C", 08, 0 } }

cARQEMP := CriaTrab( aCAMPOS, .T. )
DbUseArea( .T.,, cARQEMP, "MAR", .F., .F. )

dbselectarea("ZA2")

//Monta a consulta para a selecao dos titulos
cQUERY := " Select ZA2.* "
cQUERY += " From " + RetSqlName( "ZA2" ) + " ZA2, "+ RetSqlName( "ZA1" ) + " ZA1 "
cQUERY += " Where ZA2.ZA2_DTATEN BETWEEN '" + DTOS(dDataIni) + "' AND '"+DTOS(dDataFim) + "' "
cQUERY += " AND ZA2_HRFIM <> '' "
cQUERY += " AND ZA2_CODATE = ZA1_COD "
cQUERY += " AND ZA1_ATIVO = 'S' "
cQUERY += " AND ZA1.D_E_L_E_T_ = '' "
cQUERY += " AND ZA2.D_E_L_E_T_ = '' "
cQUERY += " Order By ZA2.ZA2_CODATE, ZA2_HRINI"

cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TITSE1
TCQUERY cQUERY Alias TMPZA2 New
/*
TcSetField( "TITSE1", "E1_VALOR"  , "N", 12, 2 )
TcSetField( "TITSE1", "E1_SALDO"  , "N", 12, 2 )
TcSetField( "TITSE1", "E1_VENCREA", "D", 08, 0 )
TcSetField( "TITSE1", "E1_VENCTO" , "D", 08, 0 )
TcSetField( "TITSE1", "E1_EMISSAO", "D", 08, 0 )
*/
//Carrega arquivo de trabalho criado com os dados da consulta
Dbselectarea("TMPZA2")
dbgotop()

While !Eof()
	
	nAtend     ++
	cAtend     := TMPZA2->ZA2_CODATE
	cNomAtend  := TMPZA2->ZA2_NOMATE
	nConsultas := 0
	nPositivos := 0
	nNegativos := 0
	nAgendados := 0
	nAtivos    := 0
	nReceptivo := 0
	cHrUteis   := '08:00:00'
	nHoras     := 0
	nMinutos   := 0
	nSegundos  := 0
	cMedHr     := '00:00:00'
	
	While !eof() .And. cAtend == TMPZA2->ZA2_CODATE
		
		nConsultas  ++
		
		If TMPZA2->ZA2_QUALI == 'P'
			nPositivos ++
		Else
			nNegativos ++
		Endif
		
		If TMPZA2->ZA2_PRIOR $ 'P14 P16' //Agendado ou agendado pelo acordo
			nAgendados ++
		Endif
		
		If TMPZA2->ZA2_TIPO == 'A'
			nAtivos    ++
		ElseIf TMPZA2->ZA2_TIPO == 'R'
			nReceptivo ++
		Endif
		
		cHoras     := ElapTime(TMPZA2->ZA2_HRINI,TMPZA2->ZA2_HRFIM) //Tempo deste atendimento
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
	Replace ATIVO     With nAtivos
	Replace RECEPTIVO with nReceptivo
	Replace HRUTEIS   With cHrUteis
	Replace HRTRAB    With cTempoLiq
	Replace MEDHR     With cMinLig
	msunlock()
	nPosit += nPositivos
	nAtivo += nAtivos
	nLigac += nConsultas
	nNegat += nNegativos
	nRecep += nReceptivos
	Dbselectarea("TMPZA2")
End

Dbclosearea("TMPZA2")

MAR->( DbGotop() )

aCPOBRW2  :=  { { "NOMATEND"    ,,OemToAnsi( "Atendente" ) }, ;
{ "CONSULTAS"   ,, OemToAnsi( "Consultas"  ), "@E 99,999" } , ;
{ "POSITIVOS"   ,, OemToAnsi( "Lig Posit" ), "@E 99,999" } , ;
{ "NEGATIVOS"   ,, OemToAnsi( "Lig Negat" ), "@E 99,999" } , ;
{ "AGENDADOS"   ,, OemToAnsi( "Agendados" ), "@E 99,999" } , ;
{ "ATIVO"       ,, OemToAnsi( "Ativo"     ), "@E 99,999" } , ;
{ "RECEPTIVO"   ,, OemToAnsi( "Receptivo" ), "@E 99,999" } , ;
{ "HRUTEIS"     ,, OemToAnsi( "Hr Uteis"  ) }, ;
{ "HRTRAB"      ,, OemToAnsi( "Hr Trab"   ) }, ;
{ "MEDHR"       ,, OemToAnsi( "Med Hr"    ) } }

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COBC041   �Autor  �Microsiga           � Data �  06/22/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Detalhar()

******** VARIAVEIS USADAS **********

aCPODET   := {}
lFLAG      := .F.
Private   cMemo := Space(80)     
Private nAtendDt     := 0
Private nPositDt     := 0
Private nAtivoDt     := 0
Private nLigacDt     := 0
Private nNegatDt     := 0
Private nRecepDt     := 0

******** INICIO DO PROCESSAMENTO ********

MsAguarde({|| lFLAG := Detalhes() }, OemToAnsi("Aguarde"), OemToAnsi("Detalhando Informacoes..."))

If ! lFLAG
	Return NIL
EndIf

******** JANELA DE DIALOGO PRINCIPAL **********

@ 000,000 To 550,785 Dialog oDLG12 Title OemToAnsi( "Detalhes - "+MAR->NOMATEND )

@ 006,005 Say OemToAnsi("Data Inicial :") COLOR CLR_GREEN
@ 006,040 Say dDataIni COLOR CLR_GREEN Object oDataIni

@ 006,085 Say OemToAnsi("Consultas  :") COLOR CLR_HBLUE
@ 006,120 Say nLigacDt COLOR CLR_HBLUE //Object oligacDt

@ 006,160 Say OemToAnsi("Positivo :") COLOR CLR_HBLUE
@ 006,190 Say nPositDT COLOR CLR_HBLUE //Object oPositDt

@ 006,230 Say OemToAnsi("Ativo  :") COLOR CLR_HBLUE
@ 006,260 Say nAtivoDT COLOR CLR_HBLUE //Object oAtivoDt

@ 006,300 Say OemToAnsi("Hr Trab:") COLOR CLR_HBLUE
@ 006,330 Say MAR->HRTRAB COLOR CLR_HBLUE //Object oAtivoDt

@ 020,005 Say OemToAnsi("Data Final   :") COLOR CLR_GREEN
@ 020,040 Say dDataFim COLOR CLR_GREEN Object oDataFim

@ 020,160 Say OemToAnsi("Negativo :") COLOR CLR_HBLUE
@ 020,190 Say nNegatDt COLOR CLR_RED //Object oNegatDt

@ 020,230 Say OemToAnsi("Receptivo :") COLOR CLR_HBLUE
@ 020,260 Say nRecepDt COLOR CLR_RED //Object oRecepDt

@ 020,300 Say OemToAnsi("Med Ligac:") COLOR CLR_HBLUE
@ 020,330 Say MAR->MEDHR COLOR CLR_RED //Object oRecepDt

oDataIni:SetText( DTOC(dDataIni) )
oDataFim:SetText( DTOC(dDataFim) )
/*
//oPositDt:SetText( Trans( nPositDt , ( "@E 9,999" ) ) )
oAtivoDt:SetText( Trans( nAtivoDt , ( "@E 9,999" ) ) )
oLigacDt:SetText( Trans( nLigacDt , ( "@E 9,999" ) ) )
oNegatDt:SetText( Trans( nNegatDt , ( "@E 9,999" ) ) )
oRecepDt:SetText( Trans( nRecepDt , ( "@E 9,999" ) ) )
*/

Dbselectarea("DET")

oBRW2:= MsSelect():New( "DET",, "", aCPODET,,, { 030, 002, 200, 393 } )
oBRW2:oBROWSE:bChange     := { || ExibeMemo() }

//@ 195,010 Say "Observa��o: " //  Nome para memo
@ 205,010 GET cMemo Size 330,45 MEMO ObJect oMemo
@ 255,100 Button OemToAnsi("_Imprimir") Size 40,12 Action ImpDetal()   Object oImpDetal
@ 255,160 Button OemToAnsi("_Cobranca") Size 40,12 Action Det_Cobra()  Object ODetCob
@ 255,220 Button OemToAnsi("_Voltar")   Size 40,12 Action oDLG12:End() Object oVoltar

Activate Dialog oDLG12 Centered Valid Voltar()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COBC041   �Autor  �Microsiga           � Data �  06/22/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Sair()

Dbselectarea("MAR")
DbCloseArea("MAR")

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COBC041   �Autor  �Microsiga           � Data �  06/22/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Voltar()

Dbselectarea("DET")
DbCloseArea("DET")

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COBC041   �Autor  �Microsiga           � Data �  06/21/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Detalhes()

aCAMPOS := { { "DTATEN" , "D", 08, 0 }, ;
{ "CODCLI"      , "C", 09, 0 }, ;
{ "NOMCLI"      , "C", 25, 0 }, ;
{ "HRINI"       , "C", 08, 0 }, ;
{ "HRFIM"       , "C", 08, 0 }, ;
{ "FILA"        , "C", 03, 0 }, ; //O campo padrao do tem 10 posicoes, diminuimos para diminuir na tela.
{ "DESCFILA"    , "C", 20, 0 }, ;
{ "SEQUEN"      , "C", 04, 0 }, ;
{ "QUALIDADE"   , "C", 01, 0 }, ;
{ "TIPO"        , "C", 01, 0 }, ;
{ "TEMPO"       , "C", 08, 0 } }

cARQEMP := CriaTrab( aCAMPOS, .T. )
DbUseArea( .T.,, cARQEMP, "DET", .F., .F. )

dbselectarea("ZA2")

//Monta a consulta para a selecao dos titulos
cQUERY := " Select ZA2.* "
cQUERY += " From " + RetSqlName( "ZA2" ) + " ZA2 "
cQUERY += " Where ZA2.ZA2_DTATEN BETWEEN '" + DTOS(dDataIni) + "' AND '"+DTOS(dDataFim) + "' "
cQUERY += " AND ZA2_HRFIM <> '' "
cQUERY += " AND ZA2_CODATE = '" + MAR->CODATEND+"' "
cQUERY += " AND ZA2.D_E_L_E_T_ = '' "
cQUERY += " Order By ZA2.ZA2_CODATE, ZA2_HRINI"

cQUERY := ChangeQuery( cQUERY )

//Cria arquivo temporario com o alias TITSE1
TCQUERY cQUERY Alias TMPZA2 New

TcSetField( "TMPZA2", "ZA2_DTATEN"  , "D", 8, 0 )

//Carrega arquivo de trabalho criado com os dados da consulta
Dbselectarea("TMPZA2")
dbgotop()

While !Eof()
	
      cDescricao := ""
      Do Case
         Case TMPZA2->ZA2_PRIOR == 'CRD'
   	        cDescricao := "CREDITO"
         Case TMPZA2->ZA2_PRIOR == 'CLI'
              cDescricao := "CLIENTE"   
         Case TMPZA2->ZA2_PRIOR == 'P1 '
              cDescricao := "Codigo Cliente"
         Case TMPZA2->ZA2_PRIOR == 'P2 '
              cDescricao := "Nome Cliente"
         Case TMPZA2->ZA2_PRIOR == 'P3 '
              cDescricao :="CGC / CPF"
         Case TMPZA2->ZA2_PRIOR == 'P4 '
              cDescricao := "Pedido"
         Case TMPZA2->ZA2_PRIOR == 'P5 '
              cDescricao := "T�tulo"
         Case TMPZA2->ZA2_PRIOR == 'P6 '
              cDescricao := "Valor"
         Case TMPZA2->ZA2_PRIOR == 'P7 ' 
              cDescricao := "Cidade"
         Case TMPZA2->ZA2_PRIOR == 'P8 '
              cDescricao := "Cod Identificador"
         Case TMPZA2->ZA2_PRIOR == 'P9 '
              cDescricao := "Nosso N�mero"
         Case TMPZA2->ZA2_PRIOR == 'P10'
              cDescricao := "Status Cob"
         Case TMPZA2->ZA2_PRIOR == 'P11'
              cDescricao := "Telefone"
         Case TMPZA2->ZA2_PRIOR == 'P12'
              cDescricao := "Grupo Empresarial"
         Case TMPZA2->ZA2_PRIOR == 'P13'
              cDescricao := "Representante"
         Case TMPZA2->ZA2_PRIOR == 'P14'
              cDescricao := "Retorno Agendado"
         Case TMPZA2->ZA2_PRIOR == 'P15'
              cDescricao := "D-(n Dias)"
         Case TMPZA2->ZA2_PRIOR == 'P16'
              cDescricao := "Acordo Agendado"
         Case TMPZA2->ZA2_PRIOR == 'P17'
              cDescricao := "Cheques"
         Otherwise
              cQryZZ7 := "Select ZZ7_DESNAT, ZZ7_DESSTA "
              cQryZZ7 += "from "+RetSqlName("ZZ7")+" "
              cQryZZ7 += "where ZZ7_PRIORI = '"+TMPZA2->ZA2_PRIOR+"' "
              cQryZZ7 += "and D_E_L_E_T_ <> '*'"
      
              TCQUERY cQryZZ7 NEW ALIAS "ZZ7TMP"
      
              Dbselectarea("ZZ7TMP")
              dbGoTop()
              cDescricao := trim(ZZ7TMP->ZZ7_DESNAT)
              cDescricao += ' - '
              cDescricao += trim(ZZ7TMP->ZZ7_DESSTA)
              DbCloseArea("ZZ7TMP")
      endcase

   	Reclock("DET",.T.)
	   Replace DTATEN    With TMPZA2->ZA2_DTATEN
	   Replace CODCLI    With TMPZA2->ZA2_CODCLI+"-"+TMPZA2->ZA2_LJCLI
 	   Replace NOMCLI    With TMPZA2->ZA2_NOMCLI
	   Replace HRINI     With TMPZA2->ZA2_HRINI
	   Replace HRFIM     with TMPZA2->ZA2_HRFIM
	   Replace FILA      With TMPZA2->ZA2_PRIOR
	   Replace DESCFILA  With cDescricao
	   Replace SEQUEN    With TMPZA2->ZA2_SEQUEN
	   Replace QUALIDADE with TMPZA2->ZA2_QUALI
	   Replace TIPO      With TMPZA2->ZA2_TIPO
	   Replace TEMPO     With ElapTime(TMPZA2->ZA2_HRINI,TMPZA2->ZA2_HRFIM)

	   msunlock()
	   If TMPZA2->ZA2_QUALI == 'P'
		   nPositDt ++
	   Else
		   nNegatDt ++
	   Endif
	   If TMPZA2->ZA2_TIPO == 'A'
		   nAtivoDt ++
	   ElseIf TMPZA2->ZA2_TIPO == 'R'
		   nRecepDt ++
	   Endif
	
	   nLigacDt ++
	
	   Dbselectarea("TMPZA2")
	   dbskip()
Enddo

Dbclosearea("TMPZA2")

DET->( DbGotop() )

aCPODET  :=  { { "DTATEN"        ,,OemToAnsi( "Data" ) }, ;
{ "CODCLI"      ,, OemToAnsi( "Cliente"   ) } , ;
{ "NOMCLI"      ,, OemToAnsi( "Nome"      ) } , ;
{ "HRINI"       ,, OemToAnsi( "Inicio"    ) } , ;
{ "HRFIM"       ,, OemToAnsi( "Fim"       ) } , ;
{ "FILA"        ,, OemToAnsi( "Fila"      ) } , ;
{ "DESCFILA"    ,, OemToAnsi( "Descricao" ) } , ;
{ "SEQUEN"      ,, OemToAnsi( "Seq"       ) } , ;
{ "QUALIDADE"   ,, OemToAnsi( "Quali"     ) } , ;
{ "TIPO"        ,, OemToAnsi( "Tipo"      ) } , ;
{ "TEMPO"       ,, OemToAnsi( "Tempo"     ) } }

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COBC041   �Autor  �Microsiga           � Data �  06/22/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImpGeral()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Controle Geral de Consultas - SISCOB"
Local cPict          := ""
Local titulo       := "Controle Geral de Consultas - SISCOB"
Local nLin         := 80

local cabec1       := "Atendente                  |           |   Qualidade   |    Tipo      |       |       Tempo        |         |"
Local Cabec2       := "                           | Consultas |  Posit  Negat | Ativo  Recep | Agend |   Util      Trab   |  Media  |"
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

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
cString := "ZA2"

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunRepGeral(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  03/02/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunRepGeral(Cabec1,Cabec2,Titulo,nLin)


//���������������������������������������������������������������������Ŀ
//� Impressao do cabecalho do relatorio. . .                            �
//�����������������������������������������������������������������������

If nLin > 50 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

/*
oAtend:SetText( Trans( nAtend , ( "@E 9,999" ) ) )
oPosit:SetText( Trans( nPosit , ( "@E 9,999" ) ) )
oAtivo:SetText( Trans( nAtivo , ( "@E 9,999" ) ) )
oLigac:SetText( Trans( nLigac , ( "@E 9,999" ) ) )
oNegat:SetText( Trans( nNegat , ( "@E 9,999" ) ) )
oRecep:SetText( Trans( nRecep , ( "@E 9,999" ) ) )
*/

@ nlin,000 pSay "Data Inicial : "+DTOC(dDataIni)
@ nlin,029 pSay "Atendentes: "+Transform( nAtend ,("@E 9,999") )
@ nlin,051 pSay "Positivo: "  +Transform( nPosit ,("@E 9,999") )
@ nlin,070 pSay "Ativo    : " +Transform( nAtivo ,("@E 9,999") )
//Data Inicial: 22/06/2005     Atendentes: 9,999     Positivo: 9,999    Ativo    : 9,999
//Data Final  : 22/06/2005     Consultas : 9,999     Negativo: 9,999    Receptivo: 9,999
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          1         2         3         4         5         6         7         8         9

nlin ++
@ nlin,000 pSay "Data Final   : "+DTOC(dDataFim)
@ nlin,029 pSay "Consultas : "+Transform( nLigac ,("@E 9,999") )
@ nlin,051 pSay "Negativo: "  +Transform( nNegat ,("@E 9,999") )
@ nlin,070 pSay "Receptivo: "  +Transform( nRecep ,("@E 9,999") )
nlin ++
nlin ++
Dbselectarea("MAR")
dbgotop()

While !Eof()
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	@ nlin,000 pSay MAR->NOMATEND
	@ nlin,031 pSay MAR->CONSULTAS  Picture "@E 999,999"
	@ nlin,042 pSay MAR->POSITIVOS Picture "@E 9,999"
	@ nlin,049 pSay MAR->NEGATIVOS Picture "@E 9,999"
	@ nlin,057 pSay MAR->ATIVO     Picture "@E 9,999"
	@ nlin,064 pSay MAR->RECEPTIVO Picture "@E 9,999"
	@ nlin,073 pSay MAR->AGENDADOS Picture "@E 9,999"
	@ nlin,080 pSay MAR->HRUTEIS   Picture "@!"
	@ nlin,090 pSay MAR->HRTRAB    Picture "@!"
	@ nlin,101 pSay MAR->MEDHR     Picture "@!"
	nlin ++
	dbskip()
End

dbgotop()

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return .t.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COBC041   �Autor  �Microsiga           � Data �  06/22/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImpDetal()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Controle Geral de Consultas - SISCOB - DETALHADO"
Local cPict          := ""
Local titulo       := "Controle Geral de Consultas - SISCOB - DETALHADO"
Local nLin         := 80

local cabec1       := "                                                    |   Atendimento    | Fila Seq |     Descricao      | Quali | Tipo | Tempo  |"
Local Cabec2       := "Data       Cliente   Nome                           | Inicio    Fim    |          |        Fila        |       |      |        |"

/*                        
                                                    |   Atendimento    | Fila Seq |     Descricao      | Quali | Tipo | Tempo  |
Data       Cliente   Nome                           | Inicio    Fim    |          |        Fila        |       |      |        |
0....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....0....+....1....+....2....+....3....+....4
99/99/9999 123456-99 123456789012345678901234567890  99:99:99 99:99:99   123  1234 XXXXXXXXXXXXXXXXXXXX    1      1    99:99:99

*/

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

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
cString := "ZA2"

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunRepDetal(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  03/02/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunRepDetal(Cabec1,Cabec2,Titulo,nLin)


//���������������������������������������������������������������������Ŀ
//� Impressao do cabecalho do relatorio. . .                            �
//�����������������������������������������������������������������������

If nLin > 50 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

/*
oAtend:SetText( Trans( nAtend , ( "@E 9,999" ) ) )
oPosit:SetText( Trans( nPosit , ( "@E 9,999" ) ) )
oAtivo:SetText( Trans( nAtivo , ( "@E 9,999" ) ) )
oLigac:SetText( Trans( nLigac , ( "@E 9,999" ) ) )
oNegat:SetText( Trans( nNegat , ( "@E 9,999" ) ) )
oRecep:SetText( Trans( nRecep , ( "@E 9,999" ) ) )
*/

@ nlin,000 pSay "Detalhes Atendente : "+MAR->NOMATEND
nlin := nlin + 2
@ nlin,000 pSay "Data Inicial : "+DTOC(dDataIni)
@ nlin,029 pSay "Consultas : "+Transform( nLigacDt ,("@E 9,999") )
@ nlin,051 pSay "Positivo: "  +Transform( nPositDt ,("@E 9,999") )
@ nlin,070 pSay "Ativo    : " +Transform( nAtivoDt ,("@E 9,999") )
//Data Inicial: 22/06/2005     Atendentes: 9,999     Positivo: 9,999    Ativo    : 9,999
//Data Final  : 22/06/2005     Consultas : 9,999     Negativo: 9,999    Receptivo: 9,999
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//          1         2         3         4         5         6         7         8         9

nlin ++
@ nlin,000 pSay "Data Final   : "+DTOC(dDataFim)
@ nlin,051 pSay "Negativo: "  +Transform( nNegatDt ,("@E 9,999") )
@ nlin,070 pSay "Receptivo: "  +Transform( nRecepDt ,("@E 9,999") )
nlin := nlin + 2
Dbselectarea("DET")
dbgotop()

While !Eof()
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	@ nlin,000 pSay DTOC(DET->DTATEN)
	@ nlin,011 pSay DET->CODCLI    Picture "@!"
	@ nlin,021 pSay DET->NOMCLI    Picture "@!"
	@ nlin,053 pSay DET->HRINI     Picture "@!"
	@ nlin,062 pSay DET->HRFIM     Picture "@!"
	@ nlin,073 pSay DET->FILA      Picture "@!"
	@ nlin,078 pSay DET->SEQUEN    Picture "@!"
	@ nlin,083 pSay DET->DESCFILA  Picture "@!"
	@ nlin,107 pSay DET->QUALIDADE Picture "@!"
	@ nlin,114 pSay DET->TIPO      Picture "@!"
	@ nlin,119 pSay DET->TEMPO     Picture "@!"
	nlin ++
	dbskip()
End

dbgotop()

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return .t.    


Static Function Det_Cobra()

C_codcli := Det->codcli
C_codcli := StrTran(C_codcli,'-','')


SA1->(Dbsetorder(1))
SA1->(Dbseek(xfilial("SA1")+C_codcli))
U_COBC011(,,,.f.,'P1')

return .t.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIN000_P  �Autor  �Microsiga           � Data �  11/03/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ExibeMemo()

Dbselectarea("ZA2")
Dbsetorder(1)
/*
aCAMPOS := { { "DTATEN" , "D", 08, 0 }, ;
{ "CODCLI"      , "C", 09, 0 }, ;
{ "NOMCLI"      , "C", 25, 0 }, ;
{ "HRINI"       , "C", 08, 0 }, ;
{ "HRFIM"       , "C", 08, 0 }, ;
{ "FILA"        , "C", 03, 0 }, ; //O campo padrao do tem 10 posicoes, diminuimos para diminuir na tela.
{ "DESCFILA"    , "C", 20, 0 }, ;
{ "SEQUEN"      , "C", 04, 0 }, ;
{ "QUALIDADE"   , "C", 01, 0 }, ;
{ "TIPO"        , "C", 01, 0 }, ;
{ "TEMPO"       , "C", 08, 0 } }
*/
If Dbseek(xfilial()+DTOS(DET->DTATEN)+DET->HRINI+MAR->CODATEND)

	cMemo    := ZA2->ZA2_MEMO //CriaVar("ZZ6->ZZ6_MEMO")
	
   ObjectMethod(oMemo,"Refresh()")

Endif

Dbselectarea("DET") 

Return