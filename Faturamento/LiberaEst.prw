#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "font.ch"
#include "colors.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³LIBERAEST³  Autor ³ Mauricio Barros       ³ Data ³28/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Faturamento      ³Contato ³                                ³±±
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

*************

User Function LIBERAEST()

*************

SetPrvt( "cMARCA,oDLG1," )

cMARCA := GetMark()

aESTRUT := { { "ITEM",       "C", 002, 0 }, ;
             { "PRODUTO",    "C", 015, 0 }, ;
             { "LOCAL",      "C", 002, 0 }, ;
             { "DESCRICAO",  "C", 060, 0 }, ;
             { "QTDPED",     "N", 010, 3 }, ;
             { "QTDFAT",     "N", 010, 3 }, ;
             { "QTDLIB",     "N", 010, 3 }, ;
             { "QTDREJ",     "N", 010, 3 }, ;
             { "RESERVA",    "N", 010, 3 }, ;
             { "ESTOQUE",    "N", 010, 3 }, ;
             { "TES",        "C", 003, 0 }, ;
             { "ALIBERAR",   "N", 010, 3 } }

cARQTMP := CriaTrab( aESTRUT, .T. )
DbUseArea( .T.,, cARQTMP, "ITE", .F., .F. )

MsAguarde( {|| Cabec() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Lendo pedidos da carteira..." ) )

DEFINE FONT oFont NAME "Arial" SIZE 6, 15 BOLD

@ 000,000 TO 512,795 Dialog oDLG1 Title "Liberacao de estoque"
oBRW2 := MsSelect():New( "ITE",,, ;
                        {{ "ITEM",, OemToAnsi( "It" ) }, ;
                         { "LOCAL",, OemToAnsi( "Lc" ) }, ;
                         { "ALIBERAR",, OemToAnsi( "Q.a lib." ), "@E 99999.999" }, ;
                         { "ESTOQUE",, OemToAnsi( "Est.Virt." ), "@E 99999.999" }, ;
                         { "( QTDPED - QTDFAT )",, OemToAnsi( "Sld a fat." ), "@E 99999.999" }, ;
                         { "QTDLIB",, OemToAnsi( "Q.Lib." ), "@E 99999.999" }, ;
                         { "QTDREJ",, OemToAnsi( "Q.Rej." ), "@E 99999.999" }, ;
                         { "RESERVA",, OemToAnsi( "Q.Res." ), "@E 99999.999" }, ;
                         { "QTDPED",, OemToAnsi( "Q.Ped." ), "@E 99999.999" }, ;
                         { "( ' ' )",, OemToAnsi( " " ) } },,, ;
                         { 120, 000, 215, 397 } )

oBRW1 := MsSelect():New( "CAB", "MARCA",, ;
                        {{ "MARCA"     ,, " " }, ;
                         { "C5_NUM"     ,, OemToAnsi( "Pedido") }, ;
                         { "C5_EMISSAO" ,, OemToAnsi( "Data") }, ;
                         { "C5_CLIENTE" ,, OemToAnsi( "Cliente") }, ;
                         { "C5_LOJACLI" ,, OemToAnsi( "Loja") }, ;
                         { "( Left( NOME, 30 ) )",, OemToAnsi( "Nome do cliente/fornecedor") }, ;
                         { "C5_VEND1"   ,, OemToAnsi( "Vend.") }, ;
                         { "A3_NREDUZ"  ,, OemToAnsi( "Nome do vendedor") }, ;
                         { "( If( C5_PRIOR == 'P', 'Programado', If( C5_PRIOR == 'L', 'Licitacao', If( C5_PRIOR == 'T', 'Cliente TOP', '' ) ) ) )",, OemToAnsi( "Prioridade") }},, ;
                           cMARCA, { 005, 000, 090, 397 } )

oBRW1:oBrowse:lhasMark    := .F.
oBRW1:oBrowse:lCanAllmark := .F.
oBRW1:oBROWSE:bCHANGE     := {|| Itens() }
oBRW2:oBROWSE:blDblClick  := {|| QtdLib() }
oBRW2:oBROWSE:bCHANGE     := {|| ObjectMethod( oPDTDESC, "SetText( Left( ITE->PRODUTO, 9 ) + '  -  ' + AllTrim( ITE->DESCRICAO ) )" ) }

oSay1 := TSAY():Create(oDlg1)
oSay1:cName := "oSay1"
oSay1:cCaption := "Produto:"
oSay1:nLeft := 14
oSay1:nTop := 450
oSay1:nWidth := 113
oSay1:nHeight := 17
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oPDTDESC := TSAY():Create(oDlg1)
oPDTDESC:cName := "oPDTDESC"
oPDTDESC:cCaption := ""
oPDTDESC:nLeft := 070
oPDTDESC:nTop := 450
oPDTDESC:nWidth := 380
oPDTDESC:nHeight := 17
oPDTDESC:lShowHint := .F.
oPDTDESC:lReadOnly := .F.
oPDTDESC:Align := 0
oPDTDESC:lVisibleControl := .T.
oPDTDESC:lWordWrap := .F.
oPDTDESC:lTransparent := .F.
oPDTDESC:SetFont( oFont )
oPDTDESC:nCLRTEXT := CLR_BLUE

oSay2 := TSAY():Create(oDlg1)
oSay2:cName := "oSay2"
oSay2:cCaption := "Observação do pedido:"
oSay2:nLeft := 184
oSay2:nTop := 195
oSay2:nWidth := 113
oSay2:nHeight := 17
oSay2:lShowHint := .F.
oSay2:lReadOnly := .F.
oSay2:Align := 0
oSay2:lVisibleControl := .T.
oSay2:lWordWrap := .F.
oSay2:lTransparent := .F.

oOBS1 := TSAY():Create(oDlg1)
oOBS1:cName := "oOBS1"
oOBS1:cCaption := ""
oOBS1:nLeft := 304
oOBS1:nTop := 195
oOBS1:nWidth := 580
oOBS1:nHeight := 17
oOBS1:lShowHint := .F.
oOBS1:lReadOnly := .F.
oOBS1:Align := 0
oOBS1:lVisibleControl := .T.
oOBS1:lWordWrap := .F.
oOBS1:lTransparent := .F.
oOBS1:SetFont( oFont )
oOBS1:nCLRTEXT := CLR_BLUE

oOBS2 := TSAY():Create(oDlg1)
oOBS2:cName := "oOBS2"
oOBS2:cCaption := ""
oOBS2:nLeft := 304
oOBS2:nTop := 212
oOBS2:nWidth := 580
oOBS2:nHeight := 17
oOBS2:lShowHint := .F.
oOBS2:lReadOnly := .F.
oOBS2:Align := 0
oOBS2:lVisibleControl := .T.
oOBS2:lWordWrap := .F.
oOBS2:lTransparent := .F.
oOBS2:SetFont( oFont )
oOBS2:nCLRTEXT := CLR_BLUE

oSay3 := TSAY():Create(oDlg1)
oSay3:cName := "oSay3"
oSay3:cCaption := "Data programada:"
oSay3:nLeft := 14
oSay3:nTop := 195
oSay3:nWidth := 113
oSay3:nHeight := 17
oSay3:lShowHint := .F.
oSay3:lReadOnly := .F.
oSay3:Align := 0
oSay3:lVisibleControl := .T.
oSay3:lWordWrap := .F.
oSay3:lTransparent := .F.

oDTPROG := TSAY():Create(oDlg1)
oDTPROG:cName := "oDTPROG"
oDTPROG:cCaption := ""
oDTPROG:nLeft := 110
oDTPROG:nTop := 195
oDTPROG:nWidth := 070
oDTPROG:nHeight := 17
oDTPROG:lShowHint := .F.
oDTPROG:lReadOnly := .F.
oDTPROG:Align := 0
oDTPROG:lVisibleControl := .T.
oDTPROG:lWordWrap := .F.
oDTPROG:lTransparent := .F.
oDTPROG:SetFont( oFont )
oDTPROG:nCLRTEXT := CLR_BLUE

@ 240,140 Button "_Liberar" Size 50,15 Action Liberar()
@ 240,210 Button "_Sair" Size 50,15 Action oDLG1:End()
Activate Dialog oDLG1 Centered On Init Itens() Valid Sair()
ITE->( DbCloseArea() )
CAB->( DbCloseArea() )
Return NIL



***************

Static Function Cabec()

***************

Local cQUERY

cQuery := "select ( case when ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) IS NOT NULL then '" + cMARCA + "' ELSE '  ' END ) AS MARCA,"
cQuery += "SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,( case when SC5.C5_TIPO IN ( 'D', 'B' ) then ( Select SA2.A2_NOME from " + retsqlname( "SA2" ) + " SA2 where SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA2.A2_COD + SA2.A2_LOJA and SA2.A2_FILIAL = '" + xfilial( "SA2" ) + "' and SA2.D_E_L_E_T_ = ' ' ) "
cQuery += "else ( Select SA1.A1_NOME from " + retsqlname( "SA1" ) + " SA1 where SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA and SA1.A1_FILIAL = '" + xfilial( "SA1" ) + "' and SA1.D_E_L_E_T_ = ' ' ) end ) AS NOME,"
cQuery += "SC5.C5_VEND1,SA3.A3_NREDUZ,SC5.C5_PRIOR,SC5.C5_EMISSAO,SC5.C5_ENTREG,SC5.C5_OBS "
cQuery += "from " + retsqlname("SC5") + " SC5," + retsqlname( "SA3" ) + " SA3 "
//cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ', '09' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ','04','09' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC5.C5_VEND1 = SA3.A3_COD "
cQuery += "and SC5.C5_FILIAL = '" + xfilial( "SC5" ) + "' and SA3.A3_FILIAL = '" + xfilial( "SA3" ) + "' "
cQuery += "and SC5.D_E_L_E_T_ = ' ' and SA3.D_E_L_E_T_ = ' ' "
cQuery += "order by SC5.C5_NUM "

cQuery := ChangeQuery( cQuery )

MemoWrit( "CARTEIRA.SQL", cQuery )

TCQUERY cQuery NEW ALIAS "CAB"
TCSetField( 'CAB', "C5_EMISSAO", "D", 8, 0 )
TCSetField( 'CAB', "C5_ENTREG", "D", 8, 0 )

cARQTMP := CriaTrab( , .F. )
Copy To ( cARQTMP )
CAB->( DbCloseArea() )
DbUseArea( .T.,, cARQTMP, "CAB", .F., .F. )
Return NIL

***************

Static Function Itens()

***************

cQuery := "select SC6.C6_LOCAL AS LOCAL,SC6.C6_ITEM AS ITEM,SC6.C6_PRODUTO AS PRODUTO,SC6.C6_LOCAL AS LOCAL,SB1.B1_DESC AS DESCRICAO,SC6.C6_QTDVEN AS QTDPED,SC6.C6_QTDENT AS QTDFAT, SC6.C6_TES AS TES, "
cQuery += "( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS QTDLIB, "
cQuery += "( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PRODUTO = SC6.C6_PRODUTO and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS RESERVA, "
cQuery += "( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED = '09' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS QTDREJ, "
cQuery += "0 AS ESTOQUE,0 AS ALIBERAR "
cQuery += "from " + retsqlname("SC6") + " SC6," + retsqlname("SB1") + " SB1 "
cQuery += "where SC6.C6_NUM = '" + CAB->C5_NUM + "' and SC6.C6_PRODUTO = SB1.B1_COD "
//cQuery += "and SC6.C6_NUM IN ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED IN ( '  ', '09' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
cQuery += "and SC6.C6_NUM IN ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED IN ( '  ','04', '09' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC6.C6_FILIAL = '" + xfilial("SC6") + "' and SC6.D_E_L_E_T_ = ' ' "
cQuery += "and SB1.B1_FILIAL = '" + xfilial("SB1") + "' and SB1.D_E_L_E_T_ = ' ' "
cQuery += "order by SC6.C6_ITEM "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "TMP"

TCSetField( 'TMP', "QTDPED", "N", 10, 3 )
TCSetField( 'TMP', "QTDFAT", "N", 10, 3 )
TCSetField( 'TMP', "QTDLIB", "N", 10, 3 )
TCSetField( 'TMP', "ESTOQUE", "N", 10, 3 )
TCSetField( 'TMP', "ALIBERAR", "N", 10, 3 )
TCSetField( 'TMP', "QTDREJ", "N", 10, 3 )
TCSetField( 'TMP', "RESERVA", "N", 10, 3 )

ITE->( __DbZap() )
DO While ! TMP->( Eof() )
   ITE->( DbAppend() )
   ITE->ITEM      := TMP->ITEM
   ITE->PRODUTO   := TMP->PRODUTO
   ITE->LOCAL     := TMP->LOCAL
   ITE->DESCRICAO := TMP->DESCRICAO
   ITE->QTDPED    := TMP->QTDPED
   ITE->QTDFAT    := TMP->QTDFAT
   ITE->QTDLIB    := TMP->QTDLIB
   ITE->ESTOQUE   := U_SALDOEST( TMP->PRODUTO, TMP->LOCAL )
   ITE->ALIBERAR  := TMP->ALIBERAR
   ITE->QTDREJ    := TMP->QTDREJ
   ITE->TES       := TMP->TES
   ITE->RESERVA   := SALDORES( TMP->PRODUTO ) //TMP->RESERVA alterei para ele considerar reservado produto original e o generico
   TMP->( DbSkip() )
EndDO
//TMP->( DbEval( {|| ITE->( DbAppend() ), Aeval( DbStruct(), { |X| ITE->( Fieldput( FieldPos( X[ 1 ] ), TMP->( FieldGet( FieldPos( X[ 1 ] ) ) ) ) ) } ) } ) )
TMP->( DbCloseArea() )
ITE->( DbGotop() )
oBRW2:oBrowse:Refresh()
ObjectMethod( oPDTDESC, "SetText( Left( ITE->PRODUTO, 9 ) + '  -  ' + AllTrim( ITE->DESCRICAO ) )" )
ObjectMethod( oDTPROG, "SetText( AllTrim( Dtoc( CAB->C5_ENTREG ) ) )" )
ObjectMethod( oOBS1, "SetText( Left( CAB->C5_OBS, 65 ) )" )
ObjectMethod( oOBS2, "SetText( SubStr( CAB->C5_OBS, 66, 65 ) )" )
Return NIL



***************

Static Function Liberar()

***************

Local nCONT := 0, ;
      nALIBERAR, ;
      aREG, ;
      nCAMPO, ;
      nREG

If CAB->C5_ENTREG > dDATABASE .and. ! MsgBox( "Pedido com data programada para " + Dtoc( CAB->C5_ENTREG ) + ". Confirma a liberacao?", "Escolha", "YESNO" )
   Return NIL
Endif

SC9->( DbSetOrder( 1 ) )
SC6->( DbSetOrder( 1 ) )
ITE->( DbGotop() )
DO While ! ITE->( Eof() )
   If ITE->ALIBERAR > 0
      SC9->( DbSeek( xFILIAL( "SC9" ) + CAB->C5_NUM + ITE->ITEM, .T. ) )
      Do While SC9->C9_PEDIDO == CAB->C5_NUM .and. SC9->C9_ITEM == ITE->ITEM
         //If Empty( SC9->C9_BLCRED ) .and. ! Empty( SC9->C9_BLEST ) .and. SC9->C9_BLEST <> "10"  // Acha primeira ocorrencia do produto
         // NOVA lIBERACAO DE CRETIDO
         If (Empty( SC9->C9_BLCRED ) .OR. SC9->C9_BLCRED='04' ).and. ! Empty( SC9->C9_BLEST ) .and. SC9->C9_BLEST <> "10"  // Acha primeira ocorrencia do produto
            Exit                                                                                // com bloqueio de estoque
         Endif
         SC9->( DbSkip() )
      EndDo
      If SC9->C9_PEDIDO == CAB->C5_NUM .and. SC9->C9_ITEM == ITE->ITEM
         Begin Transaction
            If SC9->C9_QTDLIB <> ITE->ALIBERAR  // Usa rotinas padrao Microsiga p/ quando quantidade for menor que a liberada pelo credito
               SC6->( DbSeek( xFILIAL( "SC6" ) + CAB->C5_NUM + ITE->ITEM + ITE->PRODUTO ) )
//               nREG := SC6->( Recno() )
               nVlrCred := 0
               nQtdOld  := SC9->C9_QTDLIB
               nQtdNew  := ITE->ALIBERAR
               RecLock( "SC9", .F. )
               SC9->C9_QTDLIB2 -= SC9->C9_QTDLIB2 / SC9->C9_QTDLIB * ITE->ALIBERAR
               SC9->C9_QTDLIB  -= ITE->ALIBERAR
               MsUnLock()
               //MaLibDoFat( SC6->( RecNo() ), @nQtdNew, .T., .T., .F., .F., .T., .F., /*aEmpenho*/, { || SC9->C9_BLCRED2 := "01" }, /*aEmpPronto*/, /*lTrocaLot*/, /*lOkExpedicao*/, @nVlrCred, /*nQtdalib2*/ )
               // LIBERACAO DE CREDITO 2 ENTROU EM DESUSO
               MaLibDoFat( SC6->( RecNo() ), @nQtdNew, .T., .T., .F., .F., .T., .F., /*aEmpenho*/, /*{ || SC9->C9_BLCRED2 := "01" }*/, /*aEmpPronto*/, /*lTrocaLot*/, /*lOkExpedicao*/, @nVlrCred, /*nQtdalib2*/ )
               SC6->( MaLiberOk( { SC9->C9_PEDIDO }, .F. ) )
               RecLock( "SC6", .F. )
               SC6->C6_QTDEMP -= nQtdNew
               MsUnLock()
            Else                                // Usa rotina padrao Microsiga p/ quando quantidade for igual a liberada pelo credito
               a450Grava( 1, .F., .T., Nil, {} )
            Endif
         End Transaction
         ITE->ESTOQUE  -= ITE->ALIBERAR
         ITE->QTDLIB   += ITE->ALIBERAR
         ITE->RESERVA  += ITE->ALIBERAR
         ITE->ALIBERAR := 0
         CAB->MARCA    := cMARCA
         nCONT++
      EndIf
   Endif
   ITE->( DbSkip() )
EndDo
MsgInfo( "Foi(foram) liberado(s) " + AllTrim( Str( nCONT, 2 ) ) + " item(ns)", "Concluido" )
ITE->( DbGotop() )
oBRW1:oBrowse:Refresh()
oBRW2:oBrowse:Refresh()
Return NIL



***************
Static Function QtdLib()
***************

Private nQTD := ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB

@ 000,000 TO 90,250 Dialog oDLG2 Title "Quantidade a liberar"
@ 011,020 Say "Quantidade:"
@ 010,050 Get nQTD Size 40,40 Picture "@E 999,999.999" Valid Quant() .AND. U_VldQuant()
@ 030,040 BMPButton Type 01 Action ( ITE->ALIBERAR := nQTD, oBRW2:oBrowse:Refresh(), Close( oDLG2 ) )
@ 030,080 BMPButton Type 02 Action Close( oDLG2 )
Activate Dialog oDLG2 Centered
Return NIL



***************
Static Function Quant()
***************

If nQTD < 0 .or. nQTD > Min( ITE->ESTOQUE, ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB - ITE->QTDREJ )
  If nQTD > ITE->ESTOQUE
     MsgBox( "Estoque insuficiente para essa quantidade", "info", "stop" )
     Return U_senha2( "07", 4 )[ 1 ]
  ElseIf nQTD > ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB - ITE->QTDREJ
     MsgBox( "Quantidade superior ao saldo a liberar", "info", "stop" )
     Return .F.
  Else
     Return .F.
  Endif
EndIf
Return .T.



***************
Static Function Sair( lFLAG )
***************

Local nREG := ITE->( Recno() )
Local nQTD := 0

ITE->( DbEval( {|| nQTD += ITE->ALIBERAR } ) )
ITE->( DbGoto( nREG ) )
If nQTD > 0 .and. ! MsgBox( "Item(ns) com quantidade(s) informada(s) e nao liberado(s). Confirma a saida?", "Escolha", "YESNO" )
   Return .F.
EndIf
Return .T.



*********************
Static function SALDORES( cProd1 )
*********************

local nQuant := 0
local cQuery
local cProd2
cALIASANT := Alias()

If ! Empty( cPROD1 )
    If Len( AllTrim( cPROD1 ) ) <= 7
       cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
    Else
       cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
    EndIf

    cQuery := "select sum( SC9.C9_QTDLIB ) AS RESERVA "
    cQuery += "from " + retsqlname("SC9") + " SC9 "
    cQuery += "where SC9.C9_PRODUTO IN( '"+cProd1+"', '"+cProd2+"' ) and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' "

    TCQUERY cQuery NEW ALIAS "C9X"
    DbSelectArea("C9X")
    nQuant := C9X->RESERVA
    C9X->(DbCloseArea())
endif
DbSelectArea(cALIASANT)

return nQuant