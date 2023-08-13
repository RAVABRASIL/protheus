#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"
//#INCLUDE "shell.CH"

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF


*************

User Function FATGN4()

*************

If ! Pergunte( "FATRNF", .T. )
   Return NIL
EndIf

nX := mv_par01
dX := mv_par02

aESTRUT   := { { "A1_NREDUZ",  "C", 020, 0 }, ;
               { "A1_TEL",     "C", 020, 0 }, ;
               { "A1_MUN",     "C", 025, 0 }, ;
               { "A1_EMAIL",   "C", 030, 0 }, ;
               { "F2_DOC",     "C", 015, 0 }, ;
               { "F2_EMISSAO", "D", 008, 0 }, ;
               { "SZ_PREVISO", "D", 012, 0 }, ;
               { "Z04_DATSAI", "D", 012, 0 }, ;
               { "Z04_DATCHE", "D", 012, 0 }, ;
               { "Z04_PROROG", "D", 012, 0 }, ;
               { "Z04_OBSVR",  "C", 100, 0 }, ;
               { "Z04_RETENC", "C", 001, 0 }, ;
               { "A4_NREDUZ",  "C", 020, 0 }, ;
               { "A4_CODCLIE", "C", 006, 0 }, ;
               { "A4_DIATRAB", "C", 001, 0 }, ;
               { "A4_TEL",     "C", 020, 0 }, ;
               { "A1_CONTATO", "C", 020, 0 }, ;
               { "ZZ_PRZENT",  "N", 003, 0 }, ;
               { "F2_VALBRUT", "N", 020, 6 }}

cARQTMP := CriaTrab( aESTRUT, .T. )
DbUseArea( .T.,, cARQTMP, "SZZZ", .F., .F. )
//Index On A1_NREDUZ + A1_TEL + A1_MUN To &cARQTMP

DEFINE FONT oFont4 NAME "Courier New"     SIZE 0, 19 BOLD
DEFINE FONT oFont1 NAME "Arial"           SIZE 0, 13 BOLD
DEFINE FONT oFont2 NAME "Courier New"     SIZE 0, 14 BOLD
DEFINE FONT oFont3 NAME "Arial"           SIZE 0, 13 BOLD UNDERLINE

CriaGrid()

SZZZ->( DbCloseArea() )

Return NIL

***************

Static Function CriaGrid()

***************
local lInit := .T.
aBOTOES := {}
aAdd( aBOTOES, { 'S4WB001N', {|| MITA001() }, "Inserir Dados..."	} )
aAdd( aBOTOES, { 'S4WB007N', {|| Relato2() }, "Gerar Relatorio..."	} )
aAdd( aBOTOES, { 'S4WB004N', {|| MITA002() }, "Apagar Dados..."		} )
aAdd( aBOTOES, { 'S4WB005N', {|| IMPRIME() }, "Imprimir..."			} )

IF mv_par01 == 1
  VenceHJ()
  cModulo := "PREVISAO DE ENTREGA"
ELSEIF mv_par01 == 2
  LeBase()
  cModulo := "NOTA(S) EMITIDA(S)"
ELSEIF mv_par01 == 3
  BuscaNota()
  cModulo := "NOTA(S) ESPECIFICA(S)"
ELSEIF mv_par01 == 4
  EmAberto()
  cModulo := "NOTA(S) EM ABERTO"
ENDIF

@ 000,000 TO 312,795 Dialog oDLG2 Title "Planilha Pos-Vendas V 1.1b  Dia: " + Dtoc( date() ) + "             FUNCAO : " + cModulo
DbSelectArea("SZZZ")
oBRW1 := MsSelect():New(   "SZZZ",,, ;
                        {{ "A1_NREDUZ"  ,,  OemToAnsi( "Nome") }, ;
                         { "A1_TEL"     ,,  OemToAnsi( "Telefone") }, ;
                         { "A1_MUN"     ,,  OemToAnsi( "Municipio") }, ;
                         { "F2_DOC"     ,,  OemToAnsi( "Nota Fiscal") }, ;
                         { "F2_EMISSAO" ,,  OemToAnsi( "Emissao") }, ;
                         { "Z04_DATSAI" ,,  OemToAnsi( "Dat. Saida Real") }, ;
                         { "ZZ_PRZENT"  ,,  OemToAnsi( "Prazo de Entrega") },;
                         { "SZ_PREVISO" ,,  OemToAnsi( "Previsao Entreg.") }, ;
                         { "Z04_DATCHE" ,,  OemToAnsi( "Dat. Cheg. Real") }, ;
                         { "Z04_PROROG" ,,  OemToAnsi( "Dat. Reagendamento") }, ;
                         { "A4_NREDUZ"  ,,  OemToAnsi( "Transportadora      ") }, ;
                         { "A1_CONTATO" ,,  OemToAnsi( "Responsavel   ") }, ;
                         { "Z04_OBSVR"  ,,  OemToAnsi( "Observacoes") }}, ;
                           .F.,, { 013, 000, 155, 397 } )
oBRW1:oBROWSE:SetFont( oFont1 )
oBrw1:oBROWSE:blDblClick := { || MITA001() }
oBRW1:oBROWSE:nCLRFOREFOCUS := CLR_WHITE
/**/
oBrw1:oBrowse:bHeaderClick := {|oBrw,nCol| MbrIdxCol(nCol,oBrw)}
/**/
if lInit
	MbrIdxCol(1,oBrw1:oBrowse)
	lInit := .F.
endIf
Activate Dialog oDLG2 Centered On Init EnchoiceBar( oDlg2, { || If( oDlg2:End(), oDlg2:End(), NIL ), .F. }, { || oDlg2:End() },, aBOTOES)

Return NIL


***************

STATIC Function MITA001()

***************

// Variaveis Locais da Funcao
Local dEdit1   := ctod(Space(8))
Local dEdit2   := ctod(Space(8))
Local cEdit3   := Space(90)
Local cEdit4   := Space(25)
Local dEdit5   := ctod(Space(8))
Local dEdit6   := ctod(Space(8))
Local oSay1
Local oCBox1
Local oEdit1
Local oEdit2
Local oEdit3
Local oEdit4
Local oEdit5
Local oEdit6
Local nVar
// Variaveis Private da Funcao
//Private _oDlg       // Dialog Principal
//Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.


//@ C(243), C(285) TO C(440),C(520) Dialog _oDlg Title "Informacoes Extras"
@ C(243), C(285) TO C(500),C(520) Dialog _oDlg Title "Informacoes Extras"
  // Cria Componentes Padroes do Sistema

  cEdit4 := "Nota Fiscal: " + alltrim(SZZZ->F2_DOC)
  @ C(005),C(003) Say    alltrim(cEdit4) object oEdit4     Size 125,125
  @ C(018),C(060) Get    dEdit1 object oEdit1 PICTURE "@!" Size 040,007
  @ C(019),C(003) Say    "Data de Saida:" Size 040,007
  @ C(032),C(060) Get    dEdit2 object oEdit2 PICTURE "@!" Size 040,007
  @ C(033),C(003) Say    "Data de Chegada:"  Size 045,015
  @ C(045),C(060) Get    dEdit5 object oEdit5 PICTURE "@!" Size 040,100 //cEdit5 e 0Edit5  para prazo
  @ C(046),C(003) Say    "Previsao de Chegada:"  Size 045,015
  @ C(059),C(060) Get    dEdit6 object oEdit6 PICTURE "@!" Size 040,100 //cEdit5 e 0Edit5  para prazo
  @ C(060),C(003) Say    "Reagendamento:"  Size 045,015
  
  oSay1      := TSay():New( 085,003,{||"Mercadoria Retida ?"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
  oCBox1     := TComboBox():New( 085,069,{|u| If(PCount()>0,nVAR:=u,nVAR)},{"S=Sim","N=Não"},040,010,_oDlg,,,,;
  														CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
  
  @ C(092),C(060) Get    cEdit3 object oEdit3 PICTURE "@!" Size 060,100
  @ C(092),C(003) Say    "Observações:"  Size 040,007
  @ C(106),C(030) BmpButton type 1 action ChecaEdits(dEdit1, dEdit2, cEdit3, dEdit5, dEdit6, oCBox1:nAT) //atenção, cEdit5 é oq contém a data alterada
  @ C(106),C(065) BmpButton type 2 action close(_oDlg)

  oEdit4:SetFont( oFont4 )

  dEdit1 := SZZZ->Z04_DATSAI
  dEdit2 := SZZZ->Z04_DATCHE
  cEdit3 := SZZZ->Z04_OBSVR
  dEdit5 := SZZZ->SZ_PREVISO
  dEdit6 := SZZZ->Z04_PROROG
  nVar := iif( empty(SZZZ->Z04_RETENC), 2, 1)
  ObjectMethod( oEdit1, "Refresh()" )
  ObjectMethod( oEdit2, "Refresh()" )
  ObjectMethod( oEdit5, "Refresh()" )
ACTIVATE MsDIALOG _oDlg CENTERED

Return(.T.)

***************

STATIC Function MITA002()

***************

// Variaveis Locais da Funcao
Local cEdit1   := Space(25)
Local cEdit2   := Space(25)
Local cEdit3   := Space(25)
Local cEdit4   := Space(25)
Local oEdit1
Local oEdit2
Local oEdit3
Local oEdit4


// Variaveis Private da Funcao
//Private _oDlg       // Dialog Principal
//Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

//FROM C(243),C(285) TO C(338),C(500) PIXEL

  @ C(243), C(285) TO C(390),C(520) Dialog _oDlg Title "Apagar dados inseridos"
  // Cria Componentes Padroes do Sistema

  cEdit4 := "Nota Fiscal: " + alltrim(SZZZ->F2_DOC)
  @ C(005),C(003) Say    alltrim(cEdit4) object oEdit4     Size 125,125
  @ C(019),C(003) Say    "Voce deseja apagar as informacoes adicionais sobre esta nota?" Size 125,125
  @ C(058),C(030) BmpButton type 1 action ApagReg(SZZZ->F2_DOC, .T.)
  @ C(058),C(065) BmpButton type 2 action close(_oDlg)

  oEdit4:SetFont( oFont4 )

ACTIVATE MsDIALOG _oDlg CENTERED

Return(.T.)


***************

Static Function C(nTam)

***************

Local nHRes :=  oMainWnd:nClientWidth // Resolucao horizontal do monitor
  If nHRes == 640 // Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
    nTam *= 0.8
  ElseIf (nHRes == 798).Or.(nHRes == 800) // Resolucao 800x600
    nTam *= 1
  Else  // Resolucao 1024x768 e acima
    nTam *= 1.28
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³Tratamento para tema "Flat"³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If "MP8" $ oApp:cVersion
    If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
      nTam *= 0.90
    EndIf
  EndIf
Return Int(nTam)



***************

Static Function ChecaEdits( dEdit1, dEdit2, cEdit3, dEdit5, dEdit6, nCombo )

***************

  Local dSaida  :=  dEdit1
  Local dChegd  :=  dEdit2
  Local dAlter  :=  dEdit5
  Local dProro  :=  dEdit6
  Local cMemo   :=  cEdit3
  Local nCount  := 1
  Local nChoice := 0

  cQuery := "select * from " + retsqlname("Z04") + " where Z04_DOC = '" + SZZZ->F2_DOC + "' "
  cQuery += "and Z04_FILIAL = '" + xfilial("Z04") + "' and D_E_L_E_T_ = ' ' "
  cQuery := ChangeQuery( cQuery )
  TCQUERY cQuery NEW ALIAS "ZZZ"
  ZZZ->( DbGoTop() )
  DbSelectArea("Z04")
  cEdit1 := dtos(dEdit1)
  cEdit2 := dtos(dEdit2)

  If ZZZ->( Eof() ) .AND. ( (substr(cEdit1, 1, 3) != "   ")  .OR. (substr(cEdit2, 1, 3) != "   ") .OR. (substr(cMemo, 1, 3) != "   " ) )
    Z04->( DbAppend() )

		if Z04->( RecLock("Z04", .F.) )
  		Z04->Z04_DOC := SZZZ->F2_DOC
  		Z04->( MsUnlock() )
		else
			msgBox("Nao foi possivel incluir o registro. Favor tentar novamente!")
		endif

  EndIf

  dTempr1 := stod(ZZZ->Z04_DATSAI)
  IF (dSaida != dTempr1) .AND. (dSaida >= SZZZ->F2_EMISSAO)
    if testaDbt( alltrim(SZZZ->F2_DOC) )
    
		if Z04->( DbSeek( xFilial( "Z04" ) + alltrim(SZZZ->F2_DOC), .T. ) )
	    	Z04->( RecLock("Z04", .F.) )
	    	Z04->Z04_DATSAI := dSaida
	    	Z04->Z04_PRAZO  := SZZZ->SZ_PREVISO := U_CalcPrv(dSaida, SZZZ->A4_DIATRAB, SZZZ->ZZ_PRZENT)//(SZZZ->ZZ_PRZENT + SZZZ->Z04_DATSAI) + 1
	    	SZZZ->Z04_DATSAI := dSaida
	    	Z04->( MsUnlock() )
		else
			msgbox("Nao foi possivel encontrar uma entrada para a nota " + alltrim(SZZZ->F2_DOC) + " !")
		endif
		
    endIf
  EndIf

  dTempr2 := stod(ZZZ->Z04_DATCHE)
  IF (dChegd != dTempr2) .AND. (dChegd >= SZZZ->F2_EMISSAO) .AND. (dChegd >= dTempr1)
    if testaDbt( alltrim(SZZZ->F2_DOC) ) .AND. testaCod( SZZZ->A4_CODCLIE )
    
		if Z04->( DbSeek( xFilial( "Z04" ) + alltrim(SZZZ->F2_DOC), .T. ) )
	    	Z04->( RecLock("Z04", .F.) )
	    	Z04->Z04_DATCHE := dChegd
	    	SZZZ->Z04_DATCHE := dChegd
	    	Z04->( MsUnlock() )
	    	If SZZZ->Z04_DATCHE - SZZZ->SZ_PREVISO > 0 .and. empty( SZZZ->Z04_PROROG ) .and. empty(SZZZ->Z04_RETENC)
	    		geraDBT( SZZZ->Z04_DATCHE - SZZZ->SZ_PREVISO )
	    	EndIf
		else
			msgbox("Nao foi possivel encontrar uma entrada para a nota " + alltrim(SZZZ->F2_DOC) + " !")
		endif
    
    endIf
  EndIf

  dTempr3 := stod(ZZZ->Z04_PRAZO)
  IF (dAlter != dTempr3) .AND. (dAlter >= SZZZ->F2_EMISSAO) .AND. (dAlter >= dTempr1)
    if testaDbt( alltrim(SZZZ->F2_DOC) )
    
		if Z04->( DbSeek( xFilial( "Z04" ) + alltrim(SZZZ->F2_DOC), .T. ) )
    		Z04->( RecLock("Z04", .F.) )
    		Z04->Z04_PRAZO := dAlter
    		SZZZ->SZ_PREVISO := dAlter
    		Z04->( MsUnlock() )
		else
			msgbox("Nao foi possivel encontrar uma entrada para a nota " + alltrim(SZZZ->F2_DOC) + " !")
		endif
    
    endIf    
  EndIf  
  
  if empty( SZZZ->Z04_DATCHE ) .and. ( SZZZ->Z04_RETENC != iif(nCombo == 1,'*','') )
	  if testaDbt( alltrim(SZZZ->F2_DOC) )
			if Z04->( DbSeek( xFilial( "Z04" ) + alltrim(SZZZ->F2_DOC), .T. ) )
	    		Z04->( RecLock("Z04", .F.) )
	    		Z04->Z04_RETENC  := iif(nCombo == 1,'*','')
	    		SZZZ->Z04_RETENC := iif(nCombo == 1,'*','')
	    		Z04->( MsUnlock() )
	    		iif( !empty(SZZZ->Z04_RETENC), EnviaMail( 1 ), )
			else
				msgbox("Nao foi possivel encontrar uma entrada para a nota " + alltrim(SZZZ->F2_DOC) + " !")
			endif
	  endIf    
  endIf
  
  IF !empty( dProro ) .and. ( !empty( SZZZ->SZ_PREVISO ) .and. (dProro > SZZZ->SZ_PREVISO) ) .and. empty( SZZZ->Z04_DATCHE );
     .and. dProro !=	SZZZ->Z04_PROROG
   if testaDbt( alltrim(SZZZ->F2_DOC) )  
     if Z04->( DbSeek( xFilial( "Z04" ) + alltrim(SZZZ->F2_DOC), .T. ) )
   		Z04->( RecLock("Z04", .F.) )
    		Z04->Z04_PROROG  := dProro
	    	SZZZ->Z04_PROROG := dProro
    		Z04->( MsUnlock() )
    		EnviaMail( 2 )
		else
			msgbox("Nao foi possivel encontrar uma entrada para a nota " + alltrim(SZZZ->F2_DOC) + " !")
		endif  

	endIF
  EndIf

  IF alltrim(cMemo) != alltrim(ZZZ->Z04_OBS) .AND. (substr(cMemo, 1, 3) != "   " )

		if Z04->( DbSeek( xFilial( "Z04" ) + alltrim(SZZZ->F2_DOC), .T. ) )
    	Z04->( RecLock("Z04", .F.) )
    	Z04->Z04_OBS := cMemo
    	SZZZ->Z04_OBSVR := cMemo
    	Z04->( MsUnlock() )
		else
			msgbox("Nao foi possivel encontrar uma entrada para a nota " + alltrim(SZZZ->F2_DOC) + " !")
		endif

  EndIf

  Z04->( DbCloseArea() )
  ZZZ->( DbCloseArea() )
  close(_oDlg)

Return Nil


***************

Static Function LeBase()

***************

cQuery := "select SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SF2.F2_VALBRUT F2_VALNOTA, SA4.A4_TEL, SA1.A1_EMAIL, "
cQuery += "SF2.F2_DOC, SF2.F2_EMISSAO, SA4.A4_NREDUZ, SA1.A1_CONTATO, SZZ.ZZ_PRZENT, SA4.A4_DIATRAB, SA4.A4_CODCLIE "
cQuery += "from "+ RetSqlName("SA1") + " SA1, " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, "
cQuery += " "+ RetSqlName("SZZ") + " SZZ "
cQuery += "where SF2.F2_CLIENTE = SA1.A1_COD and SF2.F2_EMISSAO >= '" + Dtos(mv_par02) + "' and SF2.F2_EMISSAO <= '" + Dtos(mv_par03) + "' "
cQuery += "and SF2.F2_TRANSP = SA4.A4_COD and SF2.F2_TRANSP = SZZ.ZZ_TRANSP and SF2.F2_TIPO = 'N' "
cQuery += "and SF2.F2_LOJA = SA1.A1_LOJA and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ and SF2.F2_SERIE != ' ' "
cQuery += "and SA1.D_E_L_E_T_ = ' ' and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' and SZZ.D_E_L_E_T_ = ' ' "
cQuery += "and SA1.A1_FILIAL  = '" + xFilial("SA1") + "' and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' and SA4.A4_FILIAL = '" + xFilial("SA4") + "' and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' "
//cQuery += "and SA1.A1_FILIAL  = ' ' and SF2.F2_FILIAL  = '01' and SA4.A4_FILIAL = ' ' and SZZ.ZZ_FILIAL = '01' "
cQuery += "order by SF2.F2_EMISSAO, SF2.F2_DOC"
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SFFA"
TCSetField( 'SFFA', "F2_EMISSAO", "D")

SZZZ->( __DbZap() )
SFFA->( DbGotop() )

Do While ! SFFA->( Eof() )

  SZZZ->( DbAppend() )

  /*dTemp := DadosAdc(SFFA->F2_DOC, 3) //lendo prazo
  IF (dTemp + 1) < mv_par02
    dTemp := DadosAdc(SFFA->F2_DOC, 1)   //busca na Z04. datsai, controla caso a previsão seja nula
    IF (dTemp + 1) > mv_par02
      dTemp := CalcPrv(dTemp, SFFA->A4_DIATRAB, SFFA->ZZ_PRZENT)
    ENDIF
  ENDIF*/ //10/10/06

  SZZZ->A1_NREDUZ  := SFFA->A1_NREDUZ
  SZZZ->A1_TEL     := SFFA->A1_TEL
  SZZZ->A1_MUN     := SFFA->A1_MUN
  SZZZ->A1_EMAIL   := SFFA->A1_EMAIL  
  SZZZ->F2_DOC     := SFFA->F2_DOC
  SZZZ->F2_EMISSAO := SFFA->F2_EMISSAO
  SZZZ->SZ_PREVISO := DadosAdc(SFFA->F2_DOC, 3)//30/10/06 dTemp
  SZZZ->Z04_DATSAI := DadosAdc(SFFA->F2_DOC, 1)
  SZZZ->Z04_DATCHE := DadosAdc(SFFA->F2_DOC, 2)
  SZZZ->Z04_PROROG := DadosAdc(SFFA->F2_DOC, 5)  
  SZZZ->Z04_RETENC := DadosAdc(SFFA->F2_DOC, 6)  
  SZZZ->A4_NREDUZ  := SFFA->A4_NREDUZ
  SZZZ->A4_DIATRAB := SFFA->A4_DIATRAB
  SZZZ->A4_CODCLIE := SFFA->A4_CODCLIE
  SZZZ->A4_TEL     := SFFA->A4_TEL
  SZZZ->A1_CONTATO := SFFA->A1_CONTATO
  SZZZ->ZZ_PRZENT  := SFFA->ZZ_PRZENT
  SZZZ->F2_VALBRUT := SFFA->F2_VALNOTA
  SZZZ->Z04_OBSVR  := DadosAdc(SFFA->F2_DOC, 4)

  SFFA->( DBSkip() )

EndDo

SFFA->( DBCloseArea() )

Return NIL


***************

Static Function VenceHj()

***************

  dData  := mv_par02 - 45 // data de vencimento menos 45 dias, i.e., um mês e meio.
  dData2 := mv_par03

  cQuery := "select SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SF2.F2_VALBRUT F2_VALNOTA, SA4.A4_TEL, SA1.A1_EMAIL, "
  cQuery += "SF2.F2_DOC, SF2.F2_EMISSAO, SA4.A4_NREDUZ, SA1.A1_CONTATO, SZZ.ZZ_PRZENT, SA4.A4_DIATRAB, SA4.A4_CODCLIE "
  cQuery += "from "+ RetSqlName("SA1") + " SA1, " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, "
  cQuery += " "+ RetSqlName("SZZ") + " SZZ "
  cQuery += "where SF2.F2_CLIENTE = SA1.A1_COD and SF2.F2_EMISSAO >= '" + Dtos(dData) + "' and  SF2.F2_EMISSAO <= '"+ Dtos(dData2) +"' "
  cQuery += "and SF2.F2_TRANSP = SA4.A4_COD and SF2.F2_TRANSP = SZZ.ZZ_TRANSP and SF2.F2_TIPO = 'N' "
  cQuery += "and SF2.F2_LOJA = SA1.A1_LOJA and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ and SF2.F2_SERIE != ' ' "
  cQuery += "and SA1.D_E_L_E_T_ = ' ' and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' and SZZ.D_E_L_E_T_ = ' ' "
  cQuery += "and SA1.A1_FILIAL  = '" + xFilial("SA1") + "' and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' and SA4.A4_FILIAL = '" + xFilial("SA4") + "' and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' "
//cQuery += "and SA1.A1_FILIAL  = ' ' and SF2.F2_FILIAL  = '01' and SA4.A4_FILIAL = ' ' and SZZ.ZZ_FILIAL = '01' "
  cQuery += "order by SF2.F2_EMISSAO, SF2.F2_DOC"
  cQuery := ChangeQuery( cQuery )
  TCQUERY cQuery NEW ALIAS "SFFA"
  TCSetField( 'SFFA', "F2_EMISSAO", "D")


  SZZZ->( __DbZap() )
  SFFA->( DbGotop() )

  Do While ! SFFA->( Eof() )
    dTemp := DadosAdc(SFFA->F2_DOC, 3) //lendo prazo
    /*IF (dTemp + 1) < mv_par02
      dTemp := DadosAdc(SFFA->F2_DOC, 1)   //busca na Z04. datsai, controla caso a previsão seja nula
      IF (dTemp + 1) > mv_par02
        dTemp := CalcPrv(dTemp, SFFA->A4_DIATRAB, SFFA->ZZ_PRZENT)
      ENDIF
    ENDIF*///30/10/06

    if (dTemp == mv_par02)

      SZZZ->( DbAppend() )

      SZZZ->A1_NREDUZ  := SFFA->A1_NREDUZ
      SZZZ->A1_TEL     := SFFA->A1_TEL
      SZZZ->A1_MUN     := SFFA->A1_MUN
      SZZZ->A1_EMAIL   := SFFA->A1_EMAIL      
      SZZZ->F2_DOC     := SFFA->F2_DOC
      SZZZ->F2_EMISSAO := SFFA->F2_EMISSAO
      SZZZ->SZ_PREVISO := dTemp
      SZZZ->Z04_DATSAI := DadosAdc(SFFA->F2_DOC, 1)
      SZZZ->Z04_DATCHE := DadosAdc(SFFA->F2_DOC, 2)
      SZZZ->Z04_PROROG := DadosAdc(SFFA->F2_DOC, 5)  
      SZZZ->Z04_RETENC := DadosAdc(SFFA->F2_DOC, 6)
      SZZZ->A4_NREDUZ  := SFFA->A4_NREDUZ
      SZZZ->A4_CODCLIE := SFFA->A4_CODCLIE
      SZZZ->A4_TEL     := SFFA->A4_TEL
      SZZZ->A4_DIATRAB := SFFA->A4_DIATRAB
      SZZZ->A1_CONTATO := SFFA->A1_CONTATO
      SZZZ->ZZ_PRZENT  := SFFA->ZZ_PRZENT
      SZZZ->F2_VALBRUT := SFFA->F2_VALNOTA
      SZZZ->Z04_OBSVR  := DadosAdc(SFFA->F2_DOC, 4)

    EndIf

    SFFA->( DBSkip() )

  EndDo

  SFFA->( DBCloseArea() )

Return NIL



***************

Static Function BuscaNota()

***************

cNota1 := mv_par04
IF mv_par05 == "      "
  cNota2 := mv_par04
ELSE
  cNota2 := mv_par05
ENDIF

cQuery := "select SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SF2.F2_VALBRUT F2_VALNOTA, SA4.A4_TEL, SA1.A1_EMAIL, "
cQuery += "SF2.F2_DOC, SF2.F2_EMISSAO, SA4.A4_NREDUZ, SA1.A1_CONTATO, SZZ.ZZ_PRZENT, SA4.A4_DIATRAB, SA4.A4_CODCLIE "
cQuery += "from "+ RetSqlName("SA1") + " SA1, " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, "
cQuery += " "+ RetSqlName("SZZ") + " SZZ "
cQuery += "where SF2.F2_CLIENTE = SA1.A1_COD and SF2.F2_DOC >= '" + cNota1 + "' and SF2.F2_DOC <= '" + cNota2 + "' "
cQuery += "and SF2.F2_TRANSP = SA4.A4_COD and SF2.F2_TRANSP = SZZ.ZZ_TRANSP and SF2.F2_TIPO = 'N' "
cQuery += "and SF2.F2_LOJA = SA1.A1_LOJA and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ and SF2.F2_SERIE != ' ' "
cQuery += "and SA1.D_E_L_E_T_ = ' ' and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' and SZZ.D_E_L_E_T_ = ' ' "
cQuery += "and SA1.A1_FILIAL  = '" + xFilial("SA1") + "' and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' and SA4.A4_FILIAL = '" + xFilial("SA4") + "' and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' "
//cQuery += "and SA1.A1_FILIAL  = ' ' and SF2.F2_FILIAL  = '01' and SA4.A4_FILIAL = ' ' and SZZ.ZZ_FILIAL = '01' "
cQuery += "order by SF2.F2_EMISSAO, SF2.F2_DOC"
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "SFFA"
TCSetField( 'SFFA', "F2_EMISSAO", "D")

SZZZ->( __DbZap() )
SFFA->( DbGotop() )

Do While ! SFFA->( Eof() )

  SZZZ->( DbAppend() )

	//dTemp := DadosAdc(SFFA->F2_DOC, 3)

  SZZZ->A1_NREDUZ  := SFFA->A1_NREDUZ
  SZZZ->A1_TEL     := SFFA->A1_TEL
  SZZZ->A1_MUN     := SFFA->A1_MUN
  SZZZ->A1_EMAIL   := SFFA->A1_EMAIL
  SZZZ->F2_DOC     := SFFA->F2_DOC
  SZZZ->F2_EMISSAO := SFFA->F2_EMISSAO
  SZZZ->SZ_PREVISO := DadosAdc(SFFA->F2_DOC, 3) //preivsao de chegada  //30/10/06 dTemp
  SZZZ->Z04_DATSAI := DadosAdc(SFFA->F2_DOC, 1) //data de saida
  SZZZ->Z04_DATCHE := DadosAdc(SFFA->F2_DOC, 2) //data de chegada real
  SZZZ->Z04_PROROG := DadosAdc(SFFA->F2_DOC, 5)  
  SZZZ->Z04_RETENC := DadosAdc(SFFA->F2_DOC, 6)
  SZZZ->A4_NREDUZ  := SFFA->A4_NREDUZ
  SZZZ->A4_DIATRAB := SFFA->A4_DIATRAB
  SZZZ->A4_CODCLIE := SFFA->A4_CODCLIE
  SZZZ->A4_TEL     := SFFA->A4_TEL
  SZZZ->A1_CONTATO := SFFA->A1_CONTATO
  SZZZ->ZZ_PRZENT  := SFFA->ZZ_PRZENT
  SZZZ->F2_VALBRUT := SFFA->F2_VALNOTA
  SZZZ->Z04_OBSVR  := DadosAdc(SFFA->F2_DOC, 4)

  SFFA->( DBSkip() )

EndDo

SFFA->( DBCloseArea() )

Return NIL


***************

Static Function  EmAberto( )

***************

  cQuery := "select SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SF2.F2_VALBRUT F2_VALNOTA, SA4.A4_TEL, SA1.A1_EMAIL,"
  cQuery += "SF2.F2_DOC, SF2.F2_EMISSAO, SA4.A4_NREDUZ, SA1.A1_CONTATO, SZZ.ZZ_PRZENT, SA4.A4_DIATRAB, SA4.A4_CODCLIE "
  cQuery += "from "+ RetSqlName("SA1") + " SA1, " + RetSqlName("SF2") +" SF2, " + RetSqlName("SA4") + " SA4, "
  cQuery += " "+ RetSqlName("SZZ") + " SZZ "
  cQuery += "where SF2.F2_CLIENTE = SA1.A1_COD and SF2.F2_EMISSAO >= '" + Dtos(mv_par02) + "' and SF2.F2_EMISSAO <= '" + Dtos(mv_par03) + "' "
  cQuery += "and SF2.F2_TIPO = 'N' "
  cQuery += "and SF2.F2_TRANSP = SA4.A4_COD and SF2.F2_TRANSP = SZZ.ZZ_TRANSP "
  cQuery += "and SF2.F2_LOJA = SA1.A1_LOJA and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ and SF2.F2_SERIE != ' ' "
  cQuery += "and SA1.D_E_L_E_T_ = ' ' and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' and SZZ.D_E_L_E_T_ = ' ' "
  cQuery += "and SA1.A1_FILIAL  = '" + xFilial("SA1") + "' and SF2.F2_FILIAL  = '" + xFilial("SF2") + "' and SA4.A4_FILIAL = '" + xFilial("SA4") + "' and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' "
//cQuery += "and SA1.A1_FILIAL  = ' ' and SF2.F2_FILIAL  = '01' and SA4.A4_FILIAL = ' ' and SZZ.ZZ_FILIAL = '01' "
  cQuery += "order by SF2.F2_EMISSAO, SF2.F2_DOC"
  cQuery := ChangeQuery( cQuery )
  TCQUERY cQuery NEW ALIAS "SFFA"
  TCSetField( 'SFFA', "F2_EMISSAO", "D")


  SZZZ->( __DbZap() )
  SFFA->( DbGotop() )

  Do While ! SFFA->( Eof() )

  /*dTemp := DadosAdc(SFFA->F2_DOC, 3) //lendo prazo
  IF (dTemp + 1) < mv_par02
    dTemp := DadosAdc(SFFA->F2_DOC, 1)   //busca na Z04. datsai, controla caso a previsão seja nula
    IF (dTemp + 1) > mv_par02
      dTemp := CalcPrv(dTemp, SFFA->A4_DIATRAB, SFFA->ZZ_PRZENT)
    ENDIF
  ENDIF*/
	//retirado em 30/10/06

  dTemp2 := DadosAdc(SFFA->F2_DOC, 2)  //o nº 2 é a data de chegada real

  IF dtos(dTemp2) == "        "

    SZZZ->( DbAppend() )

    SZZZ->A1_NREDUZ  := SFFA->A1_NREDUZ
    SZZZ->A1_TEL     := SFFA->A1_TEL
    SZZZ->A1_MUN     := SFFA->A1_MUN
    SZZZ->A1_EMAIL   := SFFA->A1_EMAIL
    SZZZ->F2_DOC     := SFFA->F2_DOC
    SZZZ->F2_EMISSAO := SFFA->F2_EMISSAO
    //SZZZ->SZ_PREVISO := dTemp //retirado em 30/10/06
	SZZZ->SZ_PREVISO := DadosAdc(SFFA->F2_DOC, 3)
    SZZZ->Z04_DATSAI := DadosAdc(SFFA->F2_DOC, 1)
    SZZZ->Z04_DATCHE := DadosAdc(SFFA->F2_DOC, 2)
    SZZZ->Z04_PROROG := DadosAdc(SFFA->F2_DOC, 5)
    SZZZ->Z04_RETENC := DadosAdc(SFFA->F2_DOC, 6)
    SZZZ->A4_NREDUZ  := SFFA->A4_NREDUZ
    SZZZ->A4_DIATRAB := SFFA->A4_DIATRAB
	SZZZ->A4_CODCLIE := SFFA->A4_CODCLIE
	SZZZ->A4_TEL     := SFFA->A4_TEL	 
    SZZZ->A1_CONTATO := SFFA->A1_CONTATO
    SZZZ->ZZ_PRZENT  := SFFA->ZZ_PRZENT
    SZZZ->F2_VALBRUT := SFFA->F2_VALNOTA
    SZZZ->Z04_OBSVR  := DadosAdc(SFFA->F2_DOC, 4)

  ENDIF

  SFFA->( DBSkip() )

  EndDo

  SFFA->( DBCloseArea() )

Return NIL


***************

Static Function  DadosAdc(cNotaf, nTipo)

***************

  Local dAux := ("        ")
  Local cRet := ''
  cQuery := "select  Z04.Z04_DATSAI, Z04.Z04_DATCHE, Z04.Z04_OBS, Z04.Z04_PRAZO, Z04.Z04_PROROG, Z04.Z04_RETENC "
  cQuery += "from  " + RetSqlName("Z04") + " Z04 "
  cQuery += "where '" + cNotaf + "' = Z04.Z04_DOC and Z04.Z04_FILIAL = '" + XFilial("Z04") + "' and Z04.D_E_L_E_T_ = ' ' "
  cQuery := ChangeQuery( cQuery )
  TCQUERY cQuery NEW ALIAS "ZYK"
  TCSetField( 'ZYK', "Z04_DATSAI", "D")
  TCSetField( 'ZYK', "Z04_DATCHE", "D")
  TCSetField( 'ZYK', "Z04_PRAZO" , "D")
  TCSetField( 'ZYK', "Z04_PROROG" , "D")
  
  ZYK->( DbGotop() )

  IF nTipo == 1
    dAux := ZYK->Z04_DATSAI
  ElseIf nTipo == 2
    dAux := ZYK->Z04_DATCHE
  ElseIf nTipo == 3
    dAux := ZYK->Z04_PRAZO
  ElseIf nTipo == 4
    cObs := ZYK->Z04_OBS
  ElseIf nTipo == 5
    dAux := ZYK->Z04_PROROG
  ElseIf nTipo == 6
    cRet := ZYK->Z04_RETENC
  ENDIF

  ZYK->( DBCloseArea() )

IF nTipo == 4
  Return cObs
ElseIf  nTipo == 6
  Return cRet
Else
  Return dAux
ENDIF

***************

Static Function  ApagReg(cNotaf, lFecha)

***************
  
  local cQuery := "select * from "+retSqlName('SE2')+" where E2_FILIAL = '"+xFilial('SE2')+"' and  "
  		  //cQuery += "E2_NUM = '"+alltrim(cNotaf)+"' and E2_PREFIXO = 'UNI' and E2_TIPO = 'NDF' and E2_NATUREZ = '21005' "
  		  cQuery += "E2_NUM = '"+alltrim(cNotaf)+"' and E2_PREFIXO IN( 'UNI','0' ) and E2_TIPO = 'NDF' and E2_NATUREZ = '21005' " 
  		  cQuery += "and E2_CODORCA = 'POSVENDA' and D_E_L_E_T_ != '*' "
  TCQUERY cQuery NEW ALIAS 'TMPYP'
  TMPYP->( dbGoTop() )
  if !TMPYP->( EoF() )
     msgAlert("Esse registro não pode ser alterado, pois há um débito para o mesmo. " + alltrim(cNotaf) )     
     If(lFecha == .T.)
    	 close(_oDlg)
     EndIf
     TMPYP->( dbCloseArea() )
     Return
  endIf
  
  cChar := "        "
  DBSelectArea("Z04")
  Z04->( DbSeek( xFilial( "Z04" ) + alltrim(SZZZ->F2_DOC), .T. ) )
  Z04->( RecLock("Z04", .F.) )
  Z04->( DbDelete() )
  /*Z04->Z04_DATSAI := stod(cChar)
  Z04->Z04_DATCHE := stod(cChar)
  Z04->Z04_PRAZO  := stod(cChar)
  Z04->Z04_OBS := "  "          */
  Z04->( MsUnlock() )

  SZZZ->Z04_DATSAI := stod(cChar)
  SZZZ->Z04_DATCHE := stod(cChar)
  SZZZ->SZ_PREVISO := stod(cChar)
  SZZZ->Z04_PROROG := stod(cChar)
  SZZZ->Z04_OBSVR  := "  "
  SZZZ->Z04_RETENC := ""
  
  If(lFecha == .T.)
    close(_oDlg)
  EndIf

  TMPYP->( dbCloseArea() )
Return Nil

***************

Static Function Relato2()

***************

   aSTRUT  := {}
   aadd( aSTRUT, { "CHAVE"  , "C",  01 , 0 } )
   aadd( aSTRUT, { "CLIENTE", "C",  25 , 0 } )
   aadd( aSTRUT, { "NUM"    , "C",  13 , 0 } )
   aadd( aSTRUT, { "DATAE"  , "C",  23 , 0 } )
   aadd( aSTRUT, { "DATAENT", "C",  23 , 0 } )
   aadd( aSTRUT, { "DATAHJ" , "C",  23 , 0 } )
   aadd( aSTRUT, { "DATSAI" , "C",  23 , 0 } )
   aadd( aSTRUT, { "VALOR"  , "C",  18 , 0 } )
   aadd( aSTRUT, { "TRANS"  , "C",  35 , 0 } )
   aadd( aSTRUT, { "CONTATO", "C",  20 , 0 } )

   cARQ  := criatrab( aSTRUT, .T. ) //cria arquivo de trabalho
   use ( cARQ ) alias TIT new
   Index on CHAVE + CLIENTE + NUM to ( cARQ )

   TIT->( DBAppend() )

    TIT->CHAVE   := " "
    TIT->CLIENTE := "NOME"
    TIT->TRANS   := ";TRANS"
    TIT->NUM     := ";NUM"
    TIT->DATAE   := ";DATA"
    TIT->DATAENT := ";DATAENT"
    TIT->DATAHJ  := ";DATAHJ"
    TIT->DATSAI  := ";DATSAI"
    TIT->VALOR   := ";VALOR"
    TIT->CONTATO := ";CONTATO"

   TIT->( DBCommit() )

   TIT->( DBAppend() )

   cDATA  := Right( DToS(SZZZ->F2_EMISSAO),2 ) + " de " + mes(month(SZZZ->F2_EMISSAO)) + " de " + ;
             Left(  DToS(SZZZ->F2_EMISSAO),4 )


    IF dtos(SZZZ->SZ_PREVISO) != '        '
    cDATA2 := Right( DToS(SZZZ->SZ_PREVISO),2 ) + " de " + mes(month(SZZZ->SZ_PREVISO)) + " de " + ;
              Left(  DToS(SZZZ->SZ_PREVISO),4 )
    ELSE
      cDATA2 := '        '
    ENDIF

    IF dtos(SZZZ->Z04_DATSAI) != '        '
    cDATA3 := Right( DToS(SZZZ->Z04_DATSAI),2 ) + " de " + mes(month(SZZZ->Z04_DATSAI)) + " de " + ;
              Left(  DToS(SZZZ->Z04_DATSAI),4 )
    ELSE
      cDATA3 := '        '
    ENDIF


    cDATA4 := alltrim(str(day(date())))+" de " + alltrim(mes(month(date()))) + " de " + alltrim(str(year(date())))

     TIT->CHAVE   := "*"
     TIT->CLIENTE := SZZZ->A1_NREDUZ
     TIT->CONTATO := ";" + SZZZ->A1_CONTATO
     TIT->TRANS   := ";" + SZZZ->A4_NREDUZ
     TIT->NUM     := ";n§ " + SZZZ->F2_DOC
     TIT->DATAE   := ";" + cDATA
     TIT->DATAENT := ";" + cDATA2
     TIT->DATSAI  := ";" + cDATA3
     TIT->DATAHJ  := ";" + cDATA4
     TIT->VALOR   := ";R$ " + alltrim(transform(SZZZ->F2_VALBRUT, "@E 999,999.99"))
     TIT->( DBCommit() )

     DBSelectArea("TIT")
     cARQ := "Malafat.txt"
     aFields := { "CLIENTE", "NUM" }
     cPATH := "C:\" + cARQ
     //cPATH := "Z:\ap7sql\relato\dayanne\" + cARQ
     //aUsuario := PswRet()
     //cPATH := Alltrim(aUsuario[2,3]) + cARQ
     Copy Fields CLIENTE,TRANS,NUM,DATAE,DATAENT,DATAHJ,DATSAI,VALOR,CONTATO To ( cPATH ) SDF
     TIT ->( DBCloseArea() )

     //ShellExecute( 'open', cPATH + '\Malafat.doc','','', 1 )
     //ShellExecute( 'open', 'Z:\ap7sql\relato\dayanne\Malafat.doc','','', 1 )
     If Empty( Directory( "C:\" + cARQ, "D" ) )
       Alert("Caminho ou arquivo '" + cARQ + "' nao encontrado. Impossivel abrir o Word. Usuario sem acesso.")
     Else
       ShellExecute( 'open', 'C:\Malafat.doc','','', 1 ) //shownormal
     EndIf


Return Nil

***************

Static Function Relato()

***************

  tamanho   := "M"
  titulo    := PADC("Relatorio de Notas Fiscais", 74)
  cDesc1    := PADC("Relatorio de Notas Fiscais", 74)
  cDesc2    := PADC("", 74)
  cDesc3    := PADC("", 74)
  cNatureza := ""
  aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
  nomeprog  := "FATGNF"
  cPerg     := " "
  nLastKey  := 0
  lContinua := .T.
  nLin      := 9
  wnrel     := "FATGNF"
  M_PAG     := 1

  cString := "SB1"

  wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

  If nLastKey == 27
     Return
  Endif

  SetDefault( aReturn, cString )

  If nLastKey == 27
     Return
  Endif

  #IFDEF WINDOWS
     RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
     Return
    // Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
    Static Function RptDetail()
  #ENDIF

  cCabec_01 := "                                        RAVA EMBALAGENS INDUSTRIA E COMERCIO LTDA."
  cCabec_02 := "Cabedelo/PB, "+alltrim(str(day(date())))+" de " + alltrim(mes(month(date()))) + " de " + alltrim(str(year(date()))) + " "
  cCabec_03 := "**********************************************************************************************************************************"
  cCabec_04 := "*                                                                                                                                *"
  cCabec_05 := "*                                                   POS-VENDAS / RAVA                                                            *"
  cCabec_06 := "*                                     Informativo de Faturamento de pedido de compra                                             *"
  cCabec_07 := "*                  Programacao de entrega de acordo com o prazo da transportadora para sua localidade                            *"
  cCabec_04 := "*                                                                                                                                *"
  cCabec_03 := "**********************************************************************************************************************************"
  //           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
  //           0         1         2         3         4         5         6         7         8         9        10        11        12        13        14

  cCabec_08 := "*  Procuramos atender a todas as exigencias. Solicitamos que nos comuniquem as ocorrencias de eventuais problemas, tais como:    *"
  cCabec_09 := "*  Atraso na entrega; Devolucao de mercadorias; O nao recebimento do boleto bancario; O nao recebimento do aviso de vencimento.  *"
  cCabec_10 := "*  Caso haja a solicitacao de prorrogacao, fazer a gentileza de nos comunicar com 15 dias de antecedencia ao vencimento.         *"

  cCabec_11 := "*   Em caso de devolucao, nao aceitamos sem a previa autorizacao do servico de Pos-Vendas ao cliente.                            *"

  cCabec_12 := "     > Solicitacoes de total acompanhamento de entrega atraves do n. 0800 014 2345 ou pelo e-mail posvendas@ravaembalgens.com.br . "

  cCabec_13 := "----------------------------------------------------------------------------------------------------------------------------------"
  cCabec_14 := "Obrigado por confiar em nossos servicos. Esperamos que as mercadorias cheguem de acordo com os seus desejos e nos declaramos    "
  cCabec_15 := "prontos para atender a qualquer reclamacao."
  cCabec_16 := "----------------------------------------------------------------------------------------------------------------------------------"

  cCabec_17 := "Rua Jose Geronimo da Silva Filho (Dede), 66 Renascer - Cabedelo-PB CEP:58310-000 Contato: (83)3048-1315 sac@ravaembalagens.com.br "
  cCabec_18 := "Atendimento a clientes 0800 014 2345 CNPJ:41.150.160/0001-02 - Inscricao Estadual:16.100.765-1"

                 *********************************************************************************************************************************************
    //           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
  //             0         1         2         3         4         5         6         7         8         9        10        11        12        13        14

  Cabec( titulo, "", "", nomeprog, tamanho, 15 )
  @ Prow() + 2, 000 PSay cCabec_01
  @ Prow() + 1, 046 PSay cCabec_02
  @ Prow() + 1, 000 PSay cCabec_03
  @ Prow() + 1, 000 PSay cCabec_04
  @ Prow() + 1, 000 PSay cCabec_05
  @ Prow() + 1, 000 PSay cCabec_06
  @ Prow() + 1, 000 PSay cCabec_07
  @ Prow() + 1, 000 PSay cCabec_04
  @ Prow() + 1, 000 PSay cCabec_03
  @ Prow() + 3, 000 PSay "Empresa / Cliente: " + SZZZ->A1_NREDUZ
  @ Prow() + 1, 000 PSay "At.: Dep. de Compras/Sr.(a) " + SZZZ->A1_CONTATO
  @ Prow() + 2, 000 PSay "Passamos os dados abaixo em relação ao envio de sua mercadoria: "
  @ Prow() + 1, 000 PSay "Data do faturamento: "
  @ Prow()    , 021 PSay  SZZZ->F2_EMISSAO
  @ Prow()    , 031 PSay  "Data de saida:"
  @ Prow()    , 046 PSay  SZZZ->Z04_DATSAI
  @ Prow() + 1, 000 PSay "Transportadora: " + SZZZ->A4_NREDUZ
  @ Prow() + 1, 000 PSay "Nota(s) Fiscal(is): n. " + SZZZ->F2_DOC
  @ Prow() + 1, 000 PSay "Faturamento parcial( ) Total( ) Saldo( ) "
  @ Prow() + 1, 000 PSay "Valor(es) total(is): R$" + alltrim(transform(SZZZ->F2_VALBRUT, "@E 999,999.99"))
  @ Prow() + 1, 000 PSay "Previsao de entrega: "
  @ Prow()    , 021 PSay  SZZZ->SZ_PREVISO
  @ Prow() + 1, 000 PSay "Previsao alterada:     /  /   "
  @ Prow() + 1, 000 PSay "Motivo:__________________________________________________________________________________________________________ "

  @ Prow() + 3, 000 PSay cCabec_03
  @ Prow() + 1, 000 PSay cCabec_04
  @ Prow() + 1, 000 PSay cCabec_08
  @ Prow() + 1, 000 PSay cCabec_09
  @ Prow() + 1, 000 PSay cCabec_10
  @ Prow() + 1, 000 PSay cCabec_04
  @ Prow() + 1, 000 PSay cCabec_11
  @ Prow() + 1, 000 PSay cCabec_04
  @ Prow() + 1, 000 PSay cCabec_03
  @ Prow() + 2, 000 PSay cCabec_12

  @ Prow() + 2, 000 PSay cCabec_13
  @ Prow() + 1, 000 PSay cCabec_14
  @ Prow() + 1, 000 PSay cCabec_15
  @ Prow() + 1, 000 PSay cCabec_16

  @ 054       , 000 PSay "Pos-Vendas/RAVA"

  @ 056       , 000 PSay cCabec_17
  @ 057       , 000 PSay cCabec_18


  If aReturn[5] == 1
     Set Printer To
     Commit
     ourspool( wnrel ) //Chamada do Spool de Impressao
  Endif

   MS_FLUSH()

Return (.T.)


***************

Static Function mes(ndata)

***************

  DO Case

    CASE nData == 1
      cMes := "Janeiro"

    CASE nData == 2
      cMes := "Fevereiro"

    CASE nData == 3
      cMes := "Marco"

    CASE nData == 4
      cMes := "Abril"

    CASE nData == 5
      cMes := "Maio"

    CASE nData == 6
      cMes := "Junho"

    CASE nData == 7
      cMes := "Julho"

    CASE nData == 8
      cMes := "Agosto"

    CASE nData == 9
      cMes := "Setembro"

    CASE nData == 10
      cMes := "Outubro"

    CASE nData == 11
      cMes := "Novembro"

    CASE nData == 12
      cMes := "Dezembro"

  EndCase

Return cMes

**********

User Function CalcPrv(dDatsai, cDiatrab, nPrzent)

**********

  Local x := 1
  Local dData := dDatsai

  IF cDiatrab == alltrim(str(3))
    dData += nPrzent + 1  // a pedido de alexandre 001370 em 16/10/2009
  Else
    while( x <= nPrzent )

      IF (dData == DataValida(dData) )
        dData++
        x++
      ElseIF DataValida(dData) - dData >= 2
        DO CASE
          CASE cDiatrab == alltrim(str(1)) //seg ate sexta
            dData := DataValida(dData)
            IF x == 1 //dayanne colocando saídas aos sábados de empresas que trabalham em 1
              x++
            ENDIF
          CASE cDiatrab == alltrim(str(2)) //seg ate sabado
            dData++
            x++
            /*Modificado*/
            IF (x > nPrzent) .AND. (dow(dData) == 1)
              dData++
            ENDIF
            /*Aqui*/
        ENDCASE
      Else
        dData := DataValida(dData)
      ENDIF
    EndDo
  Endif

  //dData++ 
  //o dData++ foi Retirado a pedido de Daniela em 10/10/08, chamado 591
  //o dData++ foi recolocado a pedido de Alexandre em 09/01/09, chamado 790
  x := 1

  while (x <= 2) .AND. (dData != DataValida(dData))

  //IF dData != DataValida(dData)
    DO CASE
      CASE cDiatrab == alltrim(str(1))
        IF dow(dData) == 1
          dData := DataValida(dData) + 1
        else
          dData := DataValida(dData)
        EndIf
      CASE cDiatrab == alltrim(str(2))
        IF dow(dData) != 7 //diferente de sábado
          dData := DataValida(dData)
        /*Else //talvez isso dê erro, pois a entrega pode ser feita no sábado.
          dData++*/
        ENDIF
    EndCase

  //ENDIF
  x++
  EndDo

Return dData

***************

Static Function MbrIdxCol(nCol,oBrowse)

***************

if nCol == 1 .OR. nCol == 8 .OR. nCol == 11
	for nX := 1 to Len(oBrowse:aColumns)
	   if nX == 1 .OR. nX == 8 .OR. nX == 11
		   oBrowse:SetHeaderImage(nX,"COLRIGHT")
  	   endif   
	next nX   
   DbSelectArea("SZZZ")
   if nCol == 1
      nOrdG := 1
      Index On A1_NREDUZ  To &cARQTMP
   elseIf nCol == 8
      nOrdG := 2
      Index On SZ_PREVISO To &cARQTMP  
   else
      nOrdG := 3
      Index On A4_NREDUZ  To &cARQTMP     
   endif   
   SZZZ->(DbSetOrder(1))
   oBrowse:SetHeaderImage(nCol,"COLDOWN")
	oBrowse:Refresh()
endif
Return

***************

Static Function geraDBT( nDias )

***************

Local aVetor := {}
Local cAlias := cQuery := ''
Local nTotal := nQuant := 0

cQuery += "select count(*) quant "
cQuery += "from   " + retSqlName('SE1') + " "
cQuery += "where  E1_FILIAL = '" + xFilial("SE1") + "' AND E1_NUM = '"+alltrim(SZZZ->F2_DOC)+"' AND E1_PREFIXO != '' "
cQuery += "and    D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS 'TMP'
TMP->( dbGoTop() )
if ! TMP->( EoF() )
	nQuant := TMP->quant
endIf
TMP->( dbCloseArea() )
                //Valor total do título           //Dias em atrasados
nTotal := ( ( ( SZZZ->F2_VALBRUT * 0.07 ) / 30 ) * nDias ) + nQuant * 2
																				//Número de títulos x Taxa bancária
cAlias := Alias()
lMsErroAuto := .F.

aVetor  := {{"E1_PREFIXO" ,"UNI"           ,Nil},;
			{"E1_NUM"	  ,SZZZ->F2_DOC    ,Nil},;
			{"E1_PARCELA" ,"9"             ,Nil},;
			{"E1_TIPO"	  ,"NF"            ,Nil},;
          	{"E1_CLIENTE" ,SZZZ->A4_CODCLIE,Nil},;
			{"E1_NATUREZ" ,"21005"         ,Nil},;
            {"E1_LOJA"	  ,"01"            ,Nil},;
          	{"E1_EMISSAO" ,dDataBase       ,Nil},;
	       	{"E1_VENCTO"  ,dDataBase       ,Nil},;
	       	{"E1_VALOR"	  ,nTotal          ,Nil},;
 		    {"E1_HIST"	  ,"ATRASO NF: "+alltrim(SZZZ->F2_DOC),  Nil},;
 		    {"E1_CODORCA" ,"POSVENDA"      ,Nil}}
//	       	{"E1_VENCREA" ,dDataBase       ,Nil},;			  
dbSelectArea( "SE2" )
MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) 
If lMsErroAuto
	Alert("Erro: Contactar setor de T.I.")
Endif

iif(!empty(cAlias),dbSelectArea( cAlias ),)

return

***************

Static Function testaDbt( cNotaf )

***************

  local cQuery := "select * from "+retSqlName('SE1')+" where E1_FILIAL = '"+xFilial('SE1')+"' and "
  		//cQuery += "E1_NUM = '"+alltrim(cNotaf)+"' and E1_PREFIXO = 'UNI' and E1_TIPO = 'NF' and E1_NATUREZ = '21005' "
  		cQuery += "E1_NUM = '"+alltrim(cNotaf)+"' and E1_PREFIXO IN( 'UNI','0' ) and E1_TIPO = 'NF' and E1_NATUREZ = '21005' "
  		cQuery += "and E1_CODORCA = 'POSVENDA' and D_E_L_E_T_ != '*' "
  TCQUERY cQuery NEW ALIAS 'TMPYP'
  TMPYP->( dbGoTop() )

  if !TMPYP->( EoF() )
     msgAlert("Esse registro não pode ser alterado, pois já há um débito para o mesmo. ")
     TMPYP->( dbCloseArea() )
     Return .F.
  endIf
  TMPYP->( dbCloseArea() )  
Return .T.

***************

Static Function testaCod( cCodClie )

***************
if empty(cCodClie)
   msgAlert("Essa transportadora está com seu código de cliente VAZIO! Favor corrigir.")	
   return .F.
endIF
Return .T.

***************

Static Function EnviaMail( nOpt )

***************

Local cEmailTo  	:= "posvendas@ravaembalagens.com.br;financeiro@ravaembalagens.com.br"+iif( !empty(SZZZ->A1_EMAIL),";"+SZZZ->A1_EMAIL,'')
Local cEmailCc  	:= ""
Local lResult   	:= .F.
Local cError    	:= "ERRO NO ENVIO DO EMAIL"
Local cUser
Local nAt      
Local cMsg      	:= ""
Local cAccount		:= GetMV( "MV_RELACNT" )
Local cPassword	    := GetMV( "MV_RELPSW"  )
Local cServer		:= GetMV( "MV_RELSERV" )
Local cAttach 		:= ""
Local cAssunto		:= iif(nOpt == 1, "Aviso de retenção em posto fiscal", "Aviso de reagendamento")
Local cFrom			:= GetMV( "MV_RELACNT" )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como CC                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cEmailCc := ""                                  
                                                                      
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if empty(SZZZ->A1_EMAIL)
   cMsg := "<b>O EMAIL DO CLIENTE ESTÁ EM BRANCO! ELE NÃO RECEBERÁ ESTE INFORMATIVO. </b><br> <br> "
endif

cMsg += "<p align='justify'>Cabedelo, "+ alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) ) +", <br> <br> <br> "
cMsg += "De: Rava Embalagens - Pós-Vendas <br> <br>"
cMsg += "Para: "+alltrim(SZZZ->A1_NREDUZ)+" <br> <br>"
cMsg += "" + alltrim(SZZZ->A1_CONTATO) + " <br> <br>"
cMsg += "INFORMATIVO <br> <br>"

if nOpt == 1
	cMsg += "Informamos que o material referente a nota fiscal " + alltrim(SZZZ->F2_DOC) + ", emitida em " + dtoc(SZZZ->F2_EMISSAO) + ", encontra-se no depósito <br>"
	cMsg += "da transportadora "+alltrim(SZZZ->A4_NREDUZ)+", em razão da NF está retida no Posto fiscal do seu Estado. <br> <br>"
	cMsg += "Pedimos que entre em contato com a transportadora através dos telefones " + alltrim(SZZZ->A4_TEL) + ", <br>"
	cMsg += "para maiores esclarecimentos e soluções. <br> <br>"
	cMsg += "<b>Lembrando também que o material possui um prazo de até 07 dias corridos para permanecer em depósito sem <br>"
	cMsg += "cobrança de taxa para armazenamento.</b> <br> <br>"
else
	cMsg += "Informamos que, com relação à mercadoria de N.F. " + alltrim(SZZZ->F2_DOC) + ", emitida em " + dtoc(SZZZ->F2_EMISSAO) + ", com previsão de entrega <br> "
	cMsg += "para " + dtoc(SZZZ->SZ_PREVISO) + ", conforme solicitação de V.Sa. será reagendada, no entanto suas duplicatas  não serão <br> "
	cMsg += "prorrogadas. <br> <br>"
endIf

cMsg += "Estarei à inteira disposição para esclarecer qualquer dúvida.<br> <br> <br> <br>"
cMsg += "Atenciosamente, <br>"
//cMsg += "Daniela Barros<br>"
cMsg += "SAC<br>"
cMsg += "sac@ravaembalagens.com.br <br><br></p>"

if lResult
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) )
	SEND MAIL FROM cFrom TO cEmailTo CC cEmailCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAttach	RESULT lResult
	
	if !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif
Return(lResult)

***************

Static Function IMPRIME()

***************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Planilha Pos-Venda"
Local nLin           := 132
Local Cabec1         := "Nome                 Municipio                 Fone                 Nota Fiscal     Prev. Entrega   Transportadora"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "FATGN4" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATGN4" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := SZZZ->( recno() )
SZZZ->( dbGoTop() )
Do While SZZZ->( !EOF() )

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   /*
   aESTRUT   := { { "A1_NREDUZ",  "C", 020, 0 }, ;
               { "A1_TEL",     "C", 020, 0 }, ;
               { "A1_MUN",     "C", 025, 0 }, ;
               { "A1_EMAIL",   "C", 030, 0 }, ;
               { "F2_DOC",     "C", 015, 0 }, ;
               { "F2_EMISSAO", "D", 008, 0 }, ;
               { "SZ_PREVISO", "D", 012, 0 }, ;
               { "Z04_DATSAI", "D", 012, 0 }, ;
               { "Z04_DATCHE", "D", 012, 0 }, ;
               { "Z04_PROROG", "D", 012, 0 }, ;
               { "Z04_OBSVR",  "C", 100, 0 }, ;
               { "Z04_RETENC", "C", 001, 0 }, ;
               { "A4_NREDUZ",  "C", 020, 0 }, ;
               { "A4_CODCLIE", "C", 006, 0 }, ;
               { "A4_DIATRAB", "C", 001, 0 }, ;
               { "A4_TEL",     "C", 020, 0 }, ;
               { "A1_CONTATO", "C", 020, 0 }, ;
               { "ZZ_PRZENT",  "N", 003, 0 }, ;
               { "F2_VALBRUT", "N", 020, 6 }}
   
   */

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   //@nLin,00 PSAY SA1->A1_COD
    
    
   @nLin,00 PSAY SZZZ->A1_NREDUZ+" "+A1_MUN+" "+SZZZ->A1_TEL+" "+SZZZ->F2_DOC+" "+DTOC(SZZZ->SZ_PREVISO)+"        "+SZZZ->A4_NREDUZ	
   
   
   
   
   nLin := nLin + 1 // Avanca a linha de impressao
   incRegua()
   SZZZ->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
EndDo

SZZZ->( dbGoTo(nOrdem) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()
Return


Return//Fim da funcao que chama o relatorio