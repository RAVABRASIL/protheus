#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TransfProd³ Autor ³ Mauricio Barros       ³ Data ³26/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Estoque          ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TransfProd()

// Defina aqui os Botoes da sua EnchoiceBar
// Exemplo: Aadd(aButtons,{"USER", {|| Alert("Inclua a Acao")}, "Contatos"})
Local aButtons  := {}
// Variaveis Private da Funcao
Private _oDlg1        // Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.
Private cLOCDEST  := Space(02)
Private cLOCORIG  := Space(02)
Private cPRODDEST := Space(15)
Private cPRODORIG := Space(15)
Private lESTORNO  := .F.
Private oESTORNO
Private nQTDORIG  := 0
Private nQTDDEST  := 0
Private nSACOS    := 0
Private aSACOS    := {}
Private oLOCDEST
Private oLOCORIG
Private oPRODDEST
Private oPRODORIG
Private oQTDE
Private oNOMORIG
Private oUMORIG
Private oESTQORIG
Private oMOVORIG
Private oNOMDEST
Private oUMDEST
Private oESTQDEST
Private oMOVDEST

DEFINE MSDIALOG _oDlg1 TITLE "Transferência de produto" FROM C(196),C(195) TO C(505),C(750) PIXEL

  // Cria as Groups do Sistema
  @ C(025),C(002) TO C(075),C(277) LABEL "Origem" PIXEL OF _oDlg1
  @ C(081),C(002) TO C(131),C(277) LABEL "Destino" PIXEL OF _oDlg1

  // Cria Componentes Padroes do Sistema
  @ C(014),C(004) CheckBox oESTORNO Var lESTORNO Prompt "Movimentação de estorno" Size C(086),C(008) PIXEL OF _oDlg1 Valid Estorno()
  @ C(040),C(011) Say "Produto:" Size C(022),C(008) COLOR CLR_BLACK PIXEL OF _oDlg1
  @ C(040),C(033) MsGet oPRODORIG Var cPRODORIG F3 "SB1" Size C(050),C(009) COLOR CLR_BLACK PIXEL OF _oDlg1 Valid Produto( 1 )
  @ C(040),C(088) Say "Local:" Size C(016),C(008) COLOR CLR_BLACK PIXEL OF _oDlg1
  @ C(040),C(106) MsGet oLOCORIG Var cLOCORIG Size C(017),C(009) COLOR CLR_BLACK PIXEL OF _oDlg1 Valid Local( 1 )
  @ C(040),C(131) Say oNOMORIG Prompt "" Size C(142),C(008) COLOR CLR_GREEN PIXEL OF _oDlg1
  @ C(057),C(011) Say "UM:" Size C(012),C(008) COLOR CLR_BLACK PIXEL OF _oDlg1
  @ C(057),C(025) Say oUMORIG Prompt "" Size C(010),C(008) COLOR CLR_GREEN PIXEL OF _oDlg1
  @ C(057),C(042) Say "Estoque:" Size C(023),C(008) COLOR CLR_BLACK PIXEL OF _oDlg1
  @ C(057),C(070) Say oESTQORIG Prompt "" Size C(021),C(008) COLOR CLR_GREEN PIXEL OF _oDlg1
  @ C(057),C(102) Say "Qtd. Movimentada:" Size C(047),C(008) COLOR CLR_BLACK PIXEL OF _oDlg1
  @ C(057),C(155) Say oMOVORIG Prompt "" Size C(021),C(008) COLOR CLR_GREEN PIXEL OF _oDlg1
  @ C(097),C(011) Say "Produto:" Size C(022),C(008) COLOR CLR_BLACK PIXEL OF _oDlg1
  @ C(097),C(034) MsGet oPRODDEST Var cPRODDEST F3 "SB1" Size C(050),C(009) COLOR CLR_BLACK PIXEL OF _oDlg1 Valid Produto( 2 )
  @ C(097),C(089) Say "Local:" Size C(016),C(008) COLOR CLR_BLACK PIXEL OF _oDlg1
  @ C(097),C(110) MsGet oLOCDEST Var cLOCDEST Size C(017),C(009) COLOR CLR_BLACK PIXEL OF _oDlg1 Valid Local( 2 )
  @ C(097),C(134) Say oNOMDEST Prompt "" Size C(139),C(008) COLOR CLR_GREEN PIXEL OF _oDlg1
  @ C(115),C(011) Say "UM:" Size C(012),C(008) COLOR CLR_BLACK PIXEL OF _oDlg1
  @ C(115),C(026) Say oUMDEST Prompt "" Size C(010),C(008) COLOR CLR_GREEN PIXEL OF _oDlg1
  @ C(115),C(043) Say "Estoque:" Size C(023),C(008) COLOR CLR_BLACK PIXEL OF _oDlg1
  @ C(115),C(068) Say oESTQDEST Prompt "" Size C(021),C(008) COLOR CLR_GREEN PIXEL OF _oDlg1
  @ C(115),C(101) Say "Qtd. Movimentada:" Size C(047),C(008) COLOR CLR_BLACK PIXEL OF _oDlg1
  @ C(115),C(152) Say oMOVDEST Prompt "" Size C(021),C(008) COLOR CLR_GREEN PIXEL OF _oDlg1
  @ C(140),C(005) Say "Quantidade a ser transferida:" Size C(070),C(008) COLOR CLR_BLACK PIXEL OF _oDlg1
  @ C(140),C(077) MsGet oQTDE Var nQTDORIG Size C(045),C(009) COLOR CLR_BLACK PIXEL OF _oDlg1 Picture "@E 999,999.9999" Valid Qtde()
  @ C(140),C(128) Say "Quantidade de sacos capa destino:" Size C(086),C(008) COLOR CLR_BLACK PIXEL OF _oDlg1
  @ C(140),C(219) Say oSACOS Var nSACOS Size C(035),C(008) COLOR CLR_GREEN PIXEL OF _oDlg1 Picture "@E 999,999"

ACTIVATE MSDIALOG _oDlg1 CENTERED  ON INIT EnchoiceBar( _oDlg1, {|| Grava() },{|| _oDlg1:End() },, aButtons )

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes :=  oMainWnd:nClientWidth // Resolucao horizontal do monitor
//  If nHRes == 640 // Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
//    nTam *= 0.8
//  ElseIf (nHRes == 798).Or.(nHRes == 800) // Resolucao 800x600
//    nTam *= 1
//  Else  // Resolucao 1024x768 e acima
    nTam *= 1.28
//  EndIf

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

Static Function Produto( nPOS )

***************

If ! SB1->( Dbseek( xFilial( "SB1" ) + If( nPOS == 1, cPRODORIG, cPRODDEST ) ) )
   MsgAlert( "Produto nao cadastrado" )
   Return .F.
EndIf
If nPOS == 1
   ObjectMethod( oNOMORIG, "SetText( SB1->B1_DESC )" )
   ObjectMethod( oUMORIG, "SetText( SB1->B1_UM )" )
Else
   If cPRODORIG == cPRODDEST
      MsgAlert( "Produto destino tem que ser diferente do origem" )
      Return .F.
   endif
   ObjectMethod( oNOMDEST, "SetText( SB1->B1_DESC )" )
   ObjectMethod( oUMDEST, "SetText( SB1->B1_UM )" )
Endif
Return .T.



***************

Static Function Local( nPOS )

***************

If ! SB2->( Dbseek( xFilial( "SB2" ) + If( nPOS == 1, cPRODORIG + cLOCORIG, cPRODDEST + cLOCDEST ) ) )
   MsgAlert( "Local nao cadastrado para esse produto" )
   Return .F.
EndIf
If( nPOS == 1, ObjectMethod( oESTQORIG, "SetText( Trans( SB2->B2_QATU, '@E 999,999.9999' ) )" ), ObjectMethod( oESTQDEST, "SetText( Trans( SB2->B2_QATU, '@E 999,999.99' ) )" ) )
Return .T.



***************

Static Function Qtde()

***************

If Empty( cPRODORIG ) .or. Empty( cPRODDEST )
   MsgAlert( "Informe produto de origem e destino" )
Else
   Calcula()
Endif
Return .T.



***************

Static Function Estorno()

***************

If ! Empty( cPRODORIG ) .and. ! Empty( cPRODDEST )
   Calcula()
Endif
Return .T.



***************

Static Function Calcula()

***************

SB5->( DbSetOrder( 1 ) )
ObjectMethod( oMOVORIG, "SetText( Trans( nQTDORIG, '@E 999,999.9999' ) )" )
SB5->( Dbseek( xFilial( "SB5" ) + cPRODORIG ) )
nQTDDEST := nQTDORIG * SB5->B5_QE2
SB5->( Dbseek( xFilial( "SB5" ) + cPRODDEST ) )
nQTDDEST := nQTDDEST / SB5->B5_QE2
ObjectMethod( oMOVDEST, "SetText( Trans( nQTDDEST, '@E 999,999.9999' ) )" )
SG1->( DbSetOrder( 1 ) )
SG1->( DbSeek( xFilial( "SG1" ) + If( lESTORNO, cPRODORIG, cPRODDEST ), .T. ) )
aSACOS := {}
nSACOS := 0
Do While ! SG1->( Eof() ) .and. SG1->G1_COD == If( lESTORNO, cPRODORIG, cPRODDEST )
   If Subs( SG1->G1_COMP, 1, 2 ) == 'ME'
      SB5->( Dbseek( xFilial( "SB5" ) + SG1->G1_COMP ) )
      Aadd( aSACOS, { SG1->G1_COMP, nQTDDEST * SG1->G1_QUANT } )
      nSACOS += SB5->B5_QE2 * ( nQTDDEST * SG1->G1_QUANT )
   Endif
   SG1->( DbSkip() )
EndDo
ObjectMethod( oSACOS, "SetText( Trans( nSACOS, '@E 999,999.9999' ) )" )
Return NIL



***************

Static Function Grava()

***************

Local nCONT, ;
      cTESORIG := "505", ;
      cTESDEST := "105"


If Empty( cPRODORIG ) .or. Empty( cPRODDEST )
   MsgAlert( "Informe produto de origem e destino" )
   Return .F.
ElseIf Empty( nQTDORIG )
   MsgAlert( "Informe a quantidade a ser transferida" )
   Return .F.
EndIf
If ! SF5->( dbSeek( xFilial() + cTESORIG ) ) .or. ! SF5->( dbSeek( xFilial() + cTESDEST ) )
   MsgAlert( "Cadastre os tipos de movimentacao " + cTESORIG + " e " + cTESDEST )
   Return .F.
EndIf

lMsErroAuto := .T.
Do While lMsErroAuto
    lMsErroAuto := .F.
    aMATRIZ     := { { "D3_TM", cTESORIG, NIL},;
                     { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
                     { "D3_FILIAL", xFilial( "SD3" ), NIL},;
                     { "D3_LOCAL", cLOCORIG, NIL },;
                     { "D3_COD", cPRODORIG, NIL},;
                     { "D3_QUANT", nQTDORIG, NIL },;
                     { "D3_EMISSAO", dDATABASE, NIL} }

    Begin Transaction
       MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
       IF lMsErroAuto
         DisarmTransaction()
       Endif
    End Transaction
EndDo

If lESTORNO
   cTESORIG := cTESDEST
Endif

For nCONT := 1 to Len( aSACOS )
    lMsErroAuto := .T.
    Do While lMsErroAuto
      lMsErroAuto := .F.
      aMATRIZ     := { { "D3_TM", cTESORIG, NIL},;
                       { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
                       { "D3_FILIAL", xFilial( "SD3" ), NIL},;
                       { "D3_LOCAL", "01", NIL },;
                       { "D3_COD", aSACOS[ nCONT, 1 ], NIL},;
                       { "D3_QUANT", aSACOS[ nCONT, 2 ], NIL },;
                       { "D3_EMISSAO", dDATABASE, NIL} }

      Begin Transaction
         MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
         IF lMsErroAuto
           DisarmTransaction()
         Endif
      End Transaction
   EndDo
Next

lMsErroAuto := .T.
Do While lMsErroAuto
    lMsErroAuto := .F.
    aMATRIZ     := { { "D3_TM", cTESDEST, NIL},;
                     { "D3_DOC", NextNumero( "SD3", 2, "D3_DOC", .T. ), NIL},;
                     { "D3_FILIAL", xFilial( "SD3" ), NIL},;
                     { "D3_LOCAL", cLOCDEST, NIL },;
                     { "D3_COD", cPRODDEST, NIL},;
                     { "D3_QUANT", nQTDDEST, NIL },;
                     { "D3_EMISSAO", dDATABASE, NIL} }

    Begin Transaction
       MSExecAuto( { | x, y | MATA240( x, y ) }, aMATRIZ, 3 )
       IF lMsErroAuto
          DisarmTransaction()
       Endif
    End Transaction
EndDo
cLOCDEST  := Space( 02 )
cLOCORIG  := Space( 02 )
cPRODDEST := Space( 15 )
cPRODORIG := Space( 15 )
nQTDORIG  := 0
nQTDDEST  := 0
nSACOS    := 0
lESTORNO  := .F.
ObjectMethod( oNOMORIG, "SetText( '' )" )
ObjectMethod( oUMORIG, "SetText( '' )" )
ObjectMethod( oNOMDEST, "SetText( '' )" )
ObjectMethod( oUMDEST, "SetText( '' )" )
ObjectMethod( oESTQORIG, "SetText( '' )" )
ObjectMethod( oESTQDEST, "SetText( '' )" )
ObjectMethod( oMOVORIG, "SetText( '' )" )
ObjectMethod( oMOVDEST, "SetText( '' )" )
ObjectMethod( oPRODORIG, "SetFocus()" )
Return .T.
