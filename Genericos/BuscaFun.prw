#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

**********

User Function BuscaFun(nOpc)

**********

// Variaveis Locais da Funcao
Local cEdit1    := Space(6)
Local cEdit12   := Space(10)
Local oEdit12
Local cQuery
// Variaveis Private da Funcao
Private _oDlg9       // Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

DEFINE FONT oFont1 NAME "Arial" SIZE 0, 13 BOLD

DEFINE MSDIALOG _oDlg9 TITLE "Busca de Funcionários" FROM C(178),C(181) TO C(394),C(562) PIXEL

cQuery := "select  SRA.RA_NOME, SRA.RA_MAT, SR6.R6_DESC "
cQuery += "from " + RetSqlName("SRA") + " SRA, " + RetSqlName("SR6") + " SR6, " + RetSqlName("SRJ") + " SRJ "
cQuery += "where SRA.RA_TNOTRAB = SR6.R6_TURNO and SRA.RA_DEMISSA = ' ' "
IF nOpc == 1 //extrusores apenas
  cQuery += "and SRA.RA_CODFUNC = SRJ.RJ_FUNCAO and SRJ.RJ_DESC like '%EXTRUS%' "
ENDIF
cQuery += "and SRA.RA_FILIAL = '" + xFilial("SRA") + "' and SR6.R6_FILIAL = '" + xFilial("SR6") + "' and SRJ.RJ_FILIAL =  '01' " //'" + xFilial("SRJ") + "'
cQuery += "and SRA.D_E_L_E_T_ = ' ' and SR6.D_E_L_E_T_ = ' ' and SRJ.D_E_L_E_T_ = ' ' "
cQuery += "order by SRA.RA_NOME"
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "XXX"
XXX->( DbGoTop() )

cARQTMP := CriaTrab( , .F. )
COPY TO ( cARQTMP )
XXX->( DbCloseArea() )
DbUseArea( .T., , cARQTMP, "XXX", .F., .F. )
Index On RA_NOME + RA_MAT to &cARQTMP

oBRW1 := MsSelect():New(   "XXX",,, ;
                        {{ "RA_MAT"     ,,  OemToAnsi( "Matrícula") }, ;
                         { "RA_NOME"    ,,  OemToAnsi( "Nome") }, ;
                         { "R6_DESC"    ,,  OemToAnsi( "Turno") }}, ;
                           .F.,, { 005, 006, 090, 152 } )
oBRW1:oBROWSE:SetFont( oFont1 )
oBrw1:oBROWSE:blDblClick := { || cEdit1 := alltrim(XXX->RA_MAT), _oDlg9:End() }
oBRW1:oBROWSE:nCLRFOREFOCUS := CLR_WHITE

  // Cria as Groups do Sistema
  @ C(001),C(004) TO C(108),C(190) LABEL "" PIXEL OF _oDlg9

  // Cria Componentes Padroes do Sistema
  @ C(093),C(085) Say "<< Busca pelo nome" Size C(065),C(008) COLOR CLR_BLACK PIXEL OF _oDlg9
  @ C(093),C(016) MsGet oEdit12 Var cEdit12 Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg9 ON CHANGE { ctest := upper(alltrim(cEdit12)) ,XXX->( DbSeek( ctest ,.T.) ), oBRW1:oBrowse:Refresh() }
  DEFINE SBUTTON FROM C(027),C(156) TYPE 1 ENABLE OF _oDlg9 ACTION { || cEdit1 := alltrim(XXX->RA_MAT),  _oDlg9:End() }
  DEFINE SBUTTON FROM C(047),C(156) TYPE 2 ENABLE OF _oDlg9 ACTION _oDlg9:End()

ACTIVATE MSDIALOG _oDlg9 CENTERED

XXX->( DbCloseArea() )

Return(cEdit1)


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

