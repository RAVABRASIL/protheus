#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "font.ch"
#include "colors.ch"
//#INCLUDE "shell.CH"

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF


*************

User Function FATGNF()

*************

If ! Pergunte( "FATRNF", .T. )
   Return NIL
EndIf

nX := mv_par01
dX := mv_par02

aESTRUT   := { { "A1_NREDUZ",  "C", 020, 0 }, ;
               { "A1_TEL",     "C", 020, 0 }, ;
               { "A1_MUN",     "C", 025, 0 }, ;
               { "F2_DOC",     "C", 015, 0 }, ;
               { "F2_EMISSAO", "D", 008, 0 }, ;
               { "SZ_PREVISO", "D", 012, 0 }, ;
               { "Z04_DATSAI", "D", 012, 0 }, ;
               { "Z04_DATCHE", "D", 012, 0 }, ;
               { "Z04_OBSVR",  "C", 100, 0 }, ;
               { "A4_NREDUZ",  "C", 020, 0 }, ;
               { "A4_DIATRAB", "C", 001, 0 }, ;
               { "A1_CONTATO", "C", 020, 0 }, ;
               { "ZZ_PRZENT",  "N", 003, 0 }, ;
               { "F2_VALBRUT", "N", 020, 6 }}

cARQTMP := CriaTrab( aESTRUT, .T. )
DbUseArea( .T.,, cARQTMP, "SZZZ", .F., .F. )
Index On A1_NREDUZ + A1_TEL + A1_MUN To &cARQTMP

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

aBOTOES := {}
aAdd( aBOTOES, { 'S4WB001N', {|| MITA001() }, "Inserir Dados..." } )
aAdd( aBOTOES, { 'S4WB007N', {|| Relato2() }, "Gerar Relatorio..." } )
aAdd( aBOTOES, { 'S4WB004N', {|| MITA002() }, "Apagar Dados..." } )


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

@ 000,000 TO 312,795 Dialog oDLG2 Title "Planilha Pos-Vendas V 1.0  Dia: " + Dtoc( date() ) + "             FUNCAO : " + cModulo
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
                         { "A4_NREDUZ"  ,,  OemToAnsi( "Transportadora      ") }, ;
                         { "A1_CONTATO" ,,  OemToAnsi( "Responsavel   ") }, ;
                         { "Z04_OBSVR"  ,,  OemToAnsi( "Observacoes") }}, ;
                           .F.,, { 013, 000, 155, 397 } )
oBRW1:oBROWSE:SetFont( oFont1 )
oBrw1:oBROWSE:blDblClick := { || MITA001() }
oBRW1:oBROWSE:nCLRFOREFOCUS := CLR_WHITE

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
Local dEdit5   := ctod(Space(8)) //ultimo campo adicionado
Local oEdit1
Local oEdit2
Local oEdit3
Local oEdit4
Local oEdit5


// Variaveis Private da Funcao
//Private _oDlg       // Dialog Principal
//Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

//FROM C(243),C(285) TO C(338),C(500) PIXEL

@ C(243), C(285) TO C(440),C(520) Dialog _oDlg Title "Informacoes Extras"
  // Cria Componentes Padroes do Sistema

  cEdit4 := "Nota Fiscal: " + alltrim(SZZZ->F2_DOC)
  @ C(005),C(003) Say    alltrim(cEdit4) object oEdit4     Size 125,125
  @ C(018),C(060) Get    dEdit1 object oEdit1 PICTURE "@!" Size 040,007
  @ C(019),C(003) Say    "Data de Saida:" Size 040,007
  @ C(032),C(060) Get    dEdit2 object oEdit2 PICTURE "@!" Size 040,007
  @ C(033),C(003) Say    "Data de Chegada:"  Size 045,015
  @ C(045),C(060) Get    dEdit5 object oEdit5 PICTURE "@!" Size 040,100 //cEdit5 e 0Edit5  para prazo
  @ C(046),C(003) Say    "Previsao Alterada:"  Size 045,015
  @ C(058),C(060) Get    cEdit3 object oEdit3 PICTURE "@!" Size 040,100
  @ C(058),C(003) Say    "Observa��es:"  Size 040,007
  @ C(072),C(030) BmpButton type 1 action ChecaEdits(dEdit1, dEdit2, cEdit3, dEdit5) //aten��o, cEdit5 � oq cont�m a data alterada
  @ C(072),C(065) BmpButton type 2 action close(_oDlg)

  oEdit4:SetFont( oFont4 )

  dEdit1 := SZZZ->Z04_DATSAI
  dEdit2 := SZZZ->Z04_DATCHE
  dEdit5 := SZZZ->SZ_PREVISO
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
  //���������������������������Ŀ
  //�Tratamento para tema "Flat"�
  //�����������������������������
  If "MP8" $ oApp:cVersion
    If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
      nTam *= 0.90
    EndIf
  EndIf
Return Int(nTam)



***************

Static Function ChecaEdits(dEdit1, dEdit2, cEdit3, dEdit5)

***************

  dSaida  :=  dEdit1
  dChegd  :=  dEdit2
  dAlter  :=  dEdit5
  cMemo   :=  cEdit3
  nCount  := 1
  nChoice := 0

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

		if Z04->( DbSeek( xFilial( "Z04" ) + alltrim(SZZZ->F2_DOC), .T. ) )
    	Z04->( RecLock("Z04", .F.) )
    	Z04->Z04_DATSAI := dSaida
    	Z04->Z04_PRAZO := SZZZ->SZ_PREVISO := CalcPrv(dSaida, SZZZ->A4_DIATRAB, SZZZ->ZZ_PRZENT)//(SZZZ->ZZ_PRZENT + SZZZ->Z04_DATSAI) + 1
    	SZZZ->Z04_DATSAI := dSaida
    	Z04->( MsUnlock() )
		else
			msgbox("Nao foi possivel encontrar uma entrada para a nota " + alltrim(SZZZ->F2_DOC) + " !")
		endif

  EndIf

  dTempr2 := stod(ZZZ->Z04_DATCHE)
  IF (dChegd != dTempr2) .AND. (dChegd >= SZZZ->F2_EMISSAO) .AND. (dChegd >= dTempr1)

		if Z04->( DbSeek( xFilial( "Z04" ) + alltrim(SZZZ->F2_DOC), .T. ) )
    	Z04->( RecLock("Z04", .F.) )
    	Z04->Z04_DATCHE := dChegd
    	SZZZ->Z04_DATCHE := dChegd
    	Z04->( MsUnlock() )
		else
			msgbox("Nao foi possivel encontrar uma entrada para a nota " + alltrim(SZZZ->F2_DOC) + " !")
		endif

  EndIf

  dTempr3 := stod(ZZZ->Z04_PRAZO)
  IF (dAlter != dTempr3) .AND. (dAlter >= SZZZ->F2_EMISSAO) .AND. (dAlter >= dTempr1)

		if Z04->( DbSeek( xFilial( "Z04" ) + alltrim(SZZZ->F2_DOC), .T. ) )
    	Z04->( RecLock("Z04", .F.) )
    	Z04->Z04_PRAZO := dAlter
    	SZZZ->SZ_PREVISO := dAlter
    	Z04->( MsUnlock() )
		 else
			msgbox("Nao foi possivel encontrar uma entrada para a nota " + alltrim(SZZZ->F2_DOC) + " !")
		endif

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

cQuery := "select SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SF2.F2_VALBRUT F2_VALNOTA, "
cQuery += "SF2.F2_DOC, SF2.F2_EMISSAO, SA4.A4_NREDUZ, SA1.A1_CONTATO, SZZ.ZZ_PRZENT, SA4.A4_DIATRAB "
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
    dTemp := DadosAdc(SFFA->F2_DOC, 1)   //busca na Z04. datsai, controla caso a previs�o seja nula
    IF (dTemp + 1) > mv_par02
      dTemp := CalcPrv(dTemp, SFFA->A4_DIATRAB, SFFA->ZZ_PRZENT)
    ENDIF
  ENDIF*/ //10/10/06

  SZZZ->A1_NREDUZ  := SFFA->A1_NREDUZ
  SZZZ->A1_TEL     := SFFA->A1_TEL
  SZZZ->A1_MUN     := SFFA->A1_MUN
  SZZZ->F2_DOC     := SFFA->F2_DOC
  SZZZ->F2_EMISSAO := SFFA->F2_EMISSAO
  SZZZ->SZ_PREVISO := DadosAdc(SFFA->F2_DOC, 3)//30/10/06 dTemp
  SZZZ->Z04_DATSAI := DadosAdc(SFFA->F2_DOC, 1)
  SZZZ->Z04_DATCHE := DadosAdc(SFFA->F2_DOC, 2)
  SZZZ->A4_NREDUZ  := SFFA->A4_NREDUZ
  SZZZ->A4_DIATRAB := SFFA->A4_DIATRAB
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

  dData  := mv_par02 - 45 // data de vencimento menos 45 dias, i.e., um m�s e meio.
  dData2 := mv_par03

  cQuery := "select SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SF2.F2_VALBRUT F2_VALNOTA, "
  cQuery += "SF2.F2_DOC, SF2.F2_EMISSAO, SA4.A4_NREDUZ, SA1.A1_CONTATO, SZZ.ZZ_PRZENT, SA4.A4_DIATRAB "
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
      dTemp := DadosAdc(SFFA->F2_DOC, 1)   //busca na Z04. datsai, controla caso a previs�o seja nula
      IF (dTemp + 1) > mv_par02
        dTemp := CalcPrv(dTemp, SFFA->A4_DIATRAB, SFFA->ZZ_PRZENT)
      ENDIF
    ENDIF*///30/10/06

    if (dTemp == mv_par02)

      SZZZ->( DbAppend() )

      SZZZ->A1_NREDUZ  := SFFA->A1_NREDUZ
      SZZZ->A1_TEL     := SFFA->A1_TEL
      SZZZ->A1_MUN     := SFFA->A1_MUN
      SZZZ->F2_DOC     := SFFA->F2_DOC
      SZZZ->F2_EMISSAO := SFFA->F2_EMISSAO
      SZZZ->SZ_PREVISO := dTemp
      SZZZ->Z04_DATSAI := DadosAdc(SFFA->F2_DOC, 1)
      SZZZ->Z04_DATCHE := DadosAdc(SFFA->F2_DOC, 2)
      SZZZ->A4_NREDUZ  := SFFA->A4_NREDUZ
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

cQuery := "select SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SF2.F2_VALBRUT F2_VALNOTA, "
cQuery += "SF2.F2_DOC, SF2.F2_EMISSAO, SA4.A4_NREDUZ, SA1.A1_CONTATO, SZZ.ZZ_PRZENT, SA4.A4_DIATRAB "
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
  SZZZ->F2_DOC     := SFFA->F2_DOC
  SZZZ->F2_EMISSAO := SFFA->F2_EMISSAO
  SZZZ->SZ_PREVISO := DadosAdc(SFFA->F2_DOC, 3) //preivsao de chegada  //30/10/06 dTemp
  SZZZ->Z04_DATSAI := DadosAdc(SFFA->F2_DOC, 1) //data de saida
  SZZZ->Z04_DATCHE := DadosAdc(SFFA->F2_DOC, 2) //data de chegada real
  SZZZ->A4_NREDUZ  := SFFA->A4_NREDUZ
  SZZZ->A4_DIATRAB := SFFA->A4_DIATRAB
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

  cQuery := "select SA1.A1_NREDUZ, SA1.A1_TEL, SA1.A1_MUN, SF2.F2_VALBRUT F2_VALNOTA, "
  cQuery += "SF2.F2_DOC, SF2.F2_EMISSAO, SA4.A4_NREDUZ, SA1.A1_CONTATO, SZZ.ZZ_PRZENT, SA4.A4_DIATRAB "
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
    dTemp := DadosAdc(SFFA->F2_DOC, 1)   //busca na Z04. datsai, controla caso a previs�o seja nula
    IF (dTemp + 1) > mv_par02
      dTemp := CalcPrv(dTemp, SFFA->A4_DIATRAB, SFFA->ZZ_PRZENT)
    ENDIF
  ENDIF*/
	//retirado em 30/10/06

  dTemp2 := DadosAdc(SFFA->F2_DOC, 2)  //o n� 2 � a data de chegada real

  IF dtos(dTemp2) == "        "

    SZZZ->( DbAppend() )

    SZZZ->A1_NREDUZ  := SFFA->A1_NREDUZ
    SZZZ->A1_TEL     := SFFA->A1_TEL
    SZZZ->A1_MUN     := SFFA->A1_MUN
    SZZZ->F2_DOC     := SFFA->F2_DOC
    SZZZ->F2_EMISSAO := SFFA->F2_EMISSAO
    //SZZZ->SZ_PREVISO := dTemp //retirado em 30/10/06
		SZZZ->SZ_PREVISO := DadosAdc(SFFA->F2_DOC, 3)
    SZZZ->Z04_DATSAI := DadosAdc(SFFA->F2_DOC, 1)
    SZZZ->Z04_DATCHE := DadosAdc(SFFA->F2_DOC, 2)
    SZZZ->A4_NREDUZ  := SFFA->A4_NREDUZ
    SZZZ->A4_DIATRAB := SFFA->A4_DIATRAB
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

  cQuery := "select  Z04.Z04_DATSAI, Z04.Z04_DATCHE, Z04.Z04_OBS, Z04.Z04_PRAZO "
  cQuery += "from  " + RetSqlName("Z04") + " Z04 "
  cQuery += "where '" + cNotaf + "' = Z04.Z04_DOC and Z04.Z04_FILIAL = '" + XFilial("Z04") + "' and Z04.D_E_L_E_T_ = ' ' "
  cQuery := ChangeQuery( cQuery )
  TCQUERY cQuery NEW ALIAS "ZYK"
  TCSetField( 'ZYK', "Z04_DATSAI", "D")
  TCSetField( 'ZYK', "Z04_DATCHE", "D")
  TCSetField( 'ZYK', "Z04_PRAZO" , "D")

  ZYK->( DbGotop() )

  IF nTipo == 1
    dAux := ZYK->Z04_DATSAI
  ElseIf nTipo == 2
    dAux := ZYK->Z04_DATCHE
  ElseIf nTipo == 3
    dAux := ZYK->Z04_PRAZO
  ElseIf nTipo == 4
    cObs := ZYK->Z04_OBS
  ENDIF

  ZYK->( DBCloseArea() )


IF nTipo == 4
  Return cObs
Else
  Return dAux
ENDIF



***************

Static Function  ApagReg(cNotaf, lFecha)

***************
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
  SZZZ->Z04_OBSVR  := "  "

  If(lFecha == .T.)
    close(_oDlg)
  EndIf

Return Nil



***************

Static Function Relato2()

***************

   aSTRUT  := {}
   aadd( aSTRUT, { "CHAVE"  , "C",  01 , 0 } )
   aadd( aSTRUT, { "CLIENTE", "C",  25 , 0 } )
   aadd( aSTRUT, { "NUM"    , "C",  10 , 0 } )
   aadd( aSTRUT, { "DATAE"  , "C",  20 , 0 } )
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
     TIT->NUM     := ";n� " + SZZZ->F2_DOC
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
//  cCabec_12 := "     > Solicitacoes de total acompanhamento de entrega atraves do n. 0800 727 1915 ou pelo e-mail posvendas@ravaembalgens.com.br . "

  cCabec_13 := "----------------------------------------------------------------------------------------------------------------------------------"
  cCabec_14 := "Obrigado por confiar em nossos servicos. Esperamos que as mercadorias cheguem de acordo com os seus desejos e nos declaramos    "
  cCabec_15 := "prontos para atender a qualquer reclamacao."
  cCabec_16 := "----------------------------------------------------------------------------------------------------------------------------------"

  cCabec_17 := "Rua Jose Geronimo da Silva Filho (Dede), 66 Renascer - Cabedelo-PB CEP:58310-000 Contato: (83)3048-1315 sac@ravaembalagens.com.br "
  cCabec_18 := "Atendimento a clientes 0800 014 2345 CNPJ:41.150.160/0001-02 - Inscricao Estadual:16.100.765-1"
//  cCabec_18 := "Atendimento a clientes 0800 727 1915 CNPJ:41.150.160/0001-02 - Inscricao Estadual:16.100.765-1"

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
  @ Prow() + 2, 000 PSay "Passamos os dados abaixo em rela��o ao envio de sua mercadoria: "
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

Static Function CalcPrv(dDatsai, cDiatrab, nPrzent)

**********

  Local x := 1
  Local dData := dDatsai

  IF cDiatrab == alltrim(str(3))
    dData += nPrzent// + 1
  Else
    while( x <= nPrzent )

      IF (dData == DataValida(dData) )
        dData++
        x++
      ElseIF DataValida(dData) - dData >= 2
        DO CASE
          CASE cDiatrab == alltrim(str(1)) //seg ate sexta
            dData := DataValida(dData)
            IF x == 1 //dayanne colocando sa�das aos s�bados de empresas que trabalham em 1
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

  dData++
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
        IF dow(dData) != 7 //diferente de s�bado
          dData := DataValida(dData)
        /*Else //talvez isso d� erro, pois a entrega pode ser feita no s�bado.
          dData++*/
        ENDIF
    EndCase

  //ENDIF
  x++
  EndDo

Return dData

