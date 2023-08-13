#include "protheus.CH"
#include "topconn.ch"

**********

User Function ESTPREC()

**********

// Variaveis Locais da Funcao
Local aComboBx1  := {"PA","PI","ME","TODOS"}
Local aComboBx2  := {"SIM","NÃO"}
Local cComboBx1
Local cComboBx2
Local cEdit1   := Space(7)
Local cEdit2   := Space(7)
Local cEdit3   := Space(25)
Local oEdit1
Local oEdit2
Local oEdit3
Local cTabela
Local cTip1 := "Escolha um tipo de produto..."
Local cTip2 := "Escolha outro de produto..."
// Variaveis Private da Funcao
Private _oDlg       // Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

                                                        //201,207       //354,614
DEFINE DIALOG _oDlg TITLE "Formação de Preços" FROM C(201),C(207) TO C(394),C(614) PIXEL

  // Cria as Groups do Sistema
  @ C(001),C(003) TO C(095),C(202) LABEL " Filtros " PIXEL OF _oDlg
    //001,003         //075,202
  // Cria Componentes Padroes do Sistema
  @ C(017),C(039) MsGet oEdit1 Var cEdit1 Size C(060),C(010) COLOR CLR_BLACK PIXEL OF _oDlg F3 "SB1"
  @ C(017),C(133) MsGet oEdit2 Var cEdit2 Size C(060),C(010) COLOR CLR_BLACK PIXEL OF _oDlg F3 "SB1"
  @ C(019),C(009) Say "Do produto:" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
  @ C(019),C(102) Say "Até produto:" Size C(031),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
  @ C(034),C(039) ComboBox cComboBx1 Items aComboBx1 Size C(061),C(010) PIXEL OF _oDlg
  @ C(034),C(133) ComboBox cComboBx2 Items aComboBx2 Size C(061),C(010) PIXEL OF _oDlg
  @ C(051),C(039) MsGet oEdit3 Var cEdit3 Size C(060),C(010) COLOR CLR_BLACK PIXEL READONLY
  @ C(036),C(009) Say "Do tipo:" Size C(020),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
  @ C(036),C(102) Say "Ativos:" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
  @ C(053),C(009) Say "Planilha:" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
  @ C(075),C(052) Button "Confirmar" Size C(037),C(012) PIXEL OF _oDlg ACTION QueryEx(alltrim(cEdit1),;
                                                                                      alltrim(cEdit2),;
                                                                                      cComboBx1, cComboBx2,;
                                                                                      alltrim(cEdit3))

  @ C(075),C(093) Button "Cancelar"  Size C(037),C(012) PIXEL OF _oDlg ACTION _oDlg:End()
  @ C(075),C(135) Button "Planilha"  Size C(037),C(012) PIXEL OF _oDlg ACTION {cEdit3 := Planilha(),;
                                                                               ObjectMethod(oEdit3,"Refresh()")}
ACTIVATE DIALOG _oDlg CENTERED

Return(.T.)


**********

Static Function QueryEx(cEd1, cEd2, cCmb1, cCmb2, cTable)

**********

Local nCont := 0

IF cTable != ''

  DO CASE

    CASE cCmb2 == "SIM"
      cOpcao := "N"

    CASE cCmb2 == "NÃO"
      cOpcao := "S"

    OTHERWISE
      cOpcao := " " //todos

  END CASE

  DO CASE

    CASE cCmb1 == "PA"
      cOpcao_2 := "PA"
      cNegacao := " "

    CASE cCmb1 == "PI"
      cOpcao_2 := "PI"
      cNegacao := " "

    CASE cCmb1 == "ME"
      cOpcao_2 := "ME "
      cNegacao := " "

    CASE cCmb1 == "TODOS"
      cOpcao_2 := " "
      cNegacao := "NOT"

    OTHERWISE

  END CASE

  cQuery := "select B1_COD, B1_DESC "
  cQuery += "from " + RetSqlName( "SB1" ) + " "
  cQuery += "where  B1_TIPO " + cNegacao + " in  ('" + cOpcao_2 + "') "
  cQuery += "and B1_ATIVO != '" + cOpcao + "' "
  cQuery += "and B1_COD >= '" + cEd1 + "' and B1_COD <= '" + cEd2 + "' and B1_COD not in('188','189') "
  cQuery += "and len( B1_COD ) < = 7 "
  cQuery += "and B1_FILIAL  = '01' and D_E_L_E_T_ = ' '  " //" + xFilial( "SB1" ) + " está retornando ' '
  cQuery += "order by B1_COD"
  cQuery := ChangeQuery( cQuery )
  TCQUERY cQuery NEW ALIAS "TMPX"
  TMPX->( DbGoTop() )
	count to nREGTOT while ! TMPX->( EoF() )
	ProcRegua( nREGTOT )
	TMPX->( DbGoTop() )

  Pergunte("MTC010",.T.)

  dbSelectArea("SB1")

  while ! TMPX->( EoF() )
    nPrecoV := MaPrcPlan(alltrim(TMPX->B1_COD),cTable,"")//"precvend"
    SB1->( DbSetOrder( 1 ) )
    cCod := alltrim(TMPX->B1_COD)
    SB1->( DbSeek( xFilial("SB1") + cCod, .T.) )
    SB1->( RecLock("SB1", .F.) )

    SB1->B1_PRV1 := nPrecoV

    SB1->( MsUnlock() )
		SB1->( DBCommit() )
		IncProc("Atualizando registros...")
    TMPX->( DbSkip() )
    nCont++
  EndDo

  DBclosearea("SB1")
  DBCloseArea("TMPX")
  IW_MsgBox(str(nCont)+" produto(s) afetado(s)! ")
  _oDlg:End()

ELSE
  IW_MsgBox("Você precisa escolher uma Planilha!!!")
ENDIF

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Planilha ³ Autor ³ Cristiane Maeda       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Le planilha gravada no disco                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAEST                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Planilha()

LOCAL aDiretorio,nX,oPlan, _oDlg2, oBtnA
LOCAL lRet:=.F.
aDiretorio := Directory("*.PDV")
For nX := 1 To Len(aDiretorio)

  aDiretorio[nX] := SubStr(aDiretorio[nX][1],1,AT(".",aDiretorio[nX][1])-1)
  If aDiretorio[nX] == "STANDARD"
    aDiretorio[nX] := Space(14)
  Else
    aDiretorio[nX] := "   "+aDiretorio[nX]+Space(11-Len(aDiretorio[nX]))
  EndIf

Next nX

Asort(aDiretorio)

If Empty(aDiretorio[1])
  aDiretorio[1] := "   STANDARD   "
EndIf

nX :=1

DEFINE MSDIALOG _oDlg2 FROM 15,6 TO 222,309 TITLE "" PIXEL            //"Selecione Planilha"
  @ 11,12 LISTBOX oPlan FIELDS HEADER  ""  SIZE 131, 69 OF _oDlg2 PIXEL;
  ON CHANGE (nX := oPlan:nAt) ON DBLCLICK (Eval(oBtnA:bAction))
  oPlan:SetArray(aDiretorio)
  oPlan:bLine := { || {aDiretorio[oPlan:nAT]} }
  DEFINE SBUTTON oBtnA FROM 83, 088 TYPE 1 ENABLE OF _oDlg2 Action(lRet := .T.,_oDlg2:End())
  DEFINE SBUTTON FROM 83, 115 TYPE 2 ENABLE OF _oDlg2 Action (lRet:= .F.,_oDlg2:End())

ACTIVATE MSDIALOG _oDlg2 CENTER
cArqMemo := AllTrim(aDiretorio[nX])
//IW_MsgBox(cArqMemo)
RETURN cArqMemo




**********

Static Function C(nTam)

**********

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
