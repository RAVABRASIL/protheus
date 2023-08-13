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
***************************************
Static Function MbrIdxCol(nCol,oBrowse)
***************************************
if nCol = 2 .OR. nCol = 3
	for nX := 1 to Len(oBrowse:aColumns)
	   if nX = 2 .OR. nX = 3
		   oBrowse:SetHeaderImage(nX,"COLRIGHT")
  	   endif   
	next nX   
   DbSelectArea("CAB")
   if nCol = 2
      nOrdG := 1
      Index On SVIP To &cARQTMP
   else
      nOrdG := 2
      Index On PRIOR+PRIOX To &cARQTMP  
   endif   
   CAB->(DbSetOrder(1))
   oBrowse:SetHeaderImage(nCol,"COLDOWN")
	oBrowse:Refresh()
endif
Return


*************
User Function LIBERESTN()
*************

SetPrvt( "cMARCA,oDLG1,nOrdG" )

cMARCA := GetMark()

aESTRUT := {{ "ITEM",       "C", 002, 0 }, ;
				{ "PRODUTO",    "C", 015, 0 }, ;
				{ "LOCAL",      "C", 002, 0 }, ;
				{ "DESCRICAO",  "C", 060, 0 }, ;
				{ "QTDPED",     "N", 015, 3 }, ;
				{ "QTDFAT",     "N", 015, 3 }, ;
				{ "QTDLIB",     "N", 015, 3 }, ;
				{ "QTDREJ",     "N", 015, 3 }, ;
				{ "RESERVA",    "N", 015, 3 }, ;
				{ "ESTOQUE",    "N", 015, 3 }, ;
				{ "TES",        "C", 003, 0 }, ;
				{ "ALIBERAR",   "N", 015, 3 }}

cARQTMP := CriaTrab( aESTRUT, .T. )
DbUseArea( .T.,, cARQTMP, "ITE", .F., .F. )

MsAguarde( {|| Cabec() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Lendo pedidos da carteira..." ) )

DEFINE FONT oFont NAME "Arial" SIZE 6, 15 BOLD

@ 000,000 TO 512,795 Dialog oDLG1 Title "Liberacao de estoque"

oBRW2 := MsSelect():New( "ITE",,, ;
{{ "ITEM"               ,, OemToAnsi( "It" ) }, ;
 { "LOCAL"              ,, OemToAnsi( "Lc" ) }, ;
 { "ALIBERAR"           ,, OemToAnsi( "Q.a lib." ), "@E 99999999999.999" }, ;
 { "ESTOQUE"            ,, OemToAnsi( "Est.Virt." ), "@E 99999999999.999" }, ;
 { "( QTDPED - QTDFAT )",, OemToAnsi( "Sld a fat." ), "@E 99999999999.999" }, ;
 { "QTDLIB"             ,, OemToAnsi( "Q.Lib." ), "@E 99999999999.999" }, ;
 { "QTDREJ"             ,, OemToAnsi( "Q.Rej." ), "@E 99999999999.999" }, ;
 { "RESERVA"            ,, OemToAnsi( "Q.Res." ), "@E 99999999999.999" }, ;
 { "QTDPED"             ,, OemToAnsi( "Q.Ped." ), "@E 99999999999.999" }, ;
 { "( ' ' )"            ,, OemToAnsi( " " ) } },,, ;
{ 120, 000, 215, 397 })

oBrw1 := MsSelect():New( "CAB", "MARCA",, ;
{{ "MARCA"               ,, " " }, ;
 { "SVIP"                ,, OemToAnsi( "Seq.Vip") }, ;
 { "PRIOR"               ,, OemToAnsi( "Prior.Res.") }, ;
 { "C5_NUM"              ,, OemToAnsi( "Pedido") }, ;
 { "C5_ENTREG"           ,, OemToAnsi( "Faturar em") }, ;
 { "C5_CLIENTE"          ,, OemToAnsi( "Cliente") }, ;
 { "C5_LOJACLI"          ,, OemToAnsi( "Loja") }, ;
 { "( Left( NOME, 30 ) )",, OemToAnsi( "Nome do cliente/fornecedor") }, ;
 { "C5_VEND1"            ,, OemToAnsi( "Vend.") }, ;
 { "A3_NREDUZ"           ,, OemToAnsi( "Nome do vendedor") }, ;
 { "( If( C5_PRIOR == 'P', 'Programado', If( C5_PRIOR == 'L', 'Licitacao', If( C5_PRIOR == 'T', 'Cliente TOP', '' ) ) ) )",, OemToAnsi( "Prioridade") }},, ;
cMARCA, { 005, 000, 090, 397 } )

oBRW1:oBrowse:lhasMark    := .F.
oBRW1:oBrowse:lCanAllmark := .F.
oBRW1:oBrowse:bCHANGE     := {|| Itens() }

oBrw1:oBrowse:bHeaderClick := {|oBrw,nCol| MbrIdxCol(nCol,oBrw)}

//oBRW2:oBROWSE:blDblClick  := {|| QtdLib() }
//oBRW2:oBROWSE:bRClicked   := {|| QtdRes() }
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
oSay2:nTop := 185
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
oOBS1:nTop := 185
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
oOBS2:nTop := 202
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
oSay3:nTop := 185
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
oDTPROG:nTop := 185
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

oGroup1 := TGroup():Create(oDlg1)
oGroup1:cName     := 'oGroup1'
oGroup1:lActive   := .T.
oGroup1:lShowHint := .F.
oGroup1:nHeight   := 33
oGroup1:nLeft     := 8
oGroup1:nTop      := 203
oGroup1:nWidth    := 777

/**/

oBtn50 := TButton():Create(oGroup1)
oBtn50:cCaption  := 'transport.'
oBtn50:cName     := 'oBtn50'
oBtn50:cVariable := 'noBtn50'
oBtn50:lActive   := .T.
oBtn50:lShowHint := .F.
oBtn50:nHeight   := 17
//oBtn50:nLeft     := 622
oBtn50:nLeft     := 537
oBtn50:nTop      := 212
oBtn50:nWidth    := 75
oBtn50:bAction := { || salvaTrn() }

oBtn40 := TButton():Create(oGroup1)
oBtn40:cCaption  := 'observações'
oBtn40:cName     := 'oBtn40'
oBtn40:cVariable := 'noBtn40'
oBtn40:lActive   := .T.
oBtn40:lShowHint := .F.
oBtn40:nHeight   := 17
//oBtn40:nLeft     := 534
oBtn40:nLeft     := 449
oBtn40:nTop      := 212
oBtn40:nWidth    := 75
oBtn40:bAction := { || salvaObs() }

/**/

oBtn4 := TButton():Create(oGroup1)
oBtn4:cCaption  := 'fura fila'
oBtn4:cName     := 'oBtn4'
oBtn4:cVariable := 'noBtn4'
oBtn4:lActive   := .T.
oBtn4:lShowHint := .F.
oBtn4:nHeight   := 17
//oBtn4:nLeft     := 446
oBtn4:nLeft     := 361
oBtn4:nTop      := 212
oBtn4:nWidth    := 75
oBtn4:bAction := { || FFila() }

oBtn6 := TButton():Create(oGroup1)
oBtn6:cCaption  := 'reserva item'
oBtn6:cName     := 'oBtn6'
oBtn6:cVariable := 'noBtn6'
oBtn6:lActive   := .T.
oBtn6:lShowHint := .F.
oBtn6:nHeight   := 17
//oBtn6:nLeft     := 358
oBtn6:nLeft     := 273
oBtn6:nTop      := 212
oBtn6:nWidth    := 75
oBtn6:bAction   := { || QtdRes() }

oBtn5 := TButton():Create(oGroup1)
oBtn5:cCaption  := 'libera item'
oBtn5:cName     := 'oBtn5'
oBtn5:cVariable := 'noBtn5'
oBtn5:lActive   := .T.
oBtn5:lShowHint := .F.
oBtn5:nHeight   := 17
//oBtn5:nLeft     := 270
oBtn5:nLeft     := 185
oBtn5:nTop      := 212
oBtn5:nWidth    := 75
oBtn5:bAction   := { || QtdLib() }

@ 240,140 Button "_Liberar"  Size 50,15 Action Liberar()
@ 240,210 Button "_Sair"     Size 50,15 Action oDLG1:End()
Activate Dialog oDLG1 Centered On Init InitDlg() Valid Sair()

ITE->( DbCloseArea() )
CAB->( DbCloseArea() )

Ferase( cArqTmp+".dbf")
Ferase( cArqTmp+".cdx")
Return NIL

******************
static function InitDlg()
******************

MbrIdxCol(2,oBrw1:oBrowse)
Itens()

return nil

***************
Static Function Cabec()
***************

Local cQuery
Local nSeq := 1

Local aABC    := {}
Local cCliVip := ""

cQuery := "select '   ' AS SVIP, SC5.C5_PRIORES AS PRIOR, PRIOX = CAST('' AS CHAR(4) ), ( case when ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) IS NOT NULL then '" + cMARCA + "' ELSE '  ' END ) AS MARCA,"
cQuery += "SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,( case when SC5.C5_TIPO IN ( 'D', 'B' ) then ( Select SA2.A2_NOME from " + retsqlname( "SA2" ) + " SA2 where SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA2.A2_COD + SA2.A2_LOJA and SA2.A2_FILIAL = '" + xfilial( "SA2" ) + "' and SA2.D_E_L_E_T_ = ' ' ) "
cQuery += "else ( Select SA1.A1_NOME from " + retsqlname( "SA1" ) + " SA1 where SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA and SA1.A1_FILIAL = '" + xfilial( "SA1" ) + "' and SA1.D_E_L_E_T_ = ' ' ) end ) AS NOME,"
cQuery += "SC5.C5_VEND1,SA3.A3_NREDUZ,SC5.C5_PRIOR,SC5.C5_EMISSAO,SC5.C5_ENTREG,SC5.C5_OBS "
cQuery += "from " + retsqlname("SC5") + " SC5," + retsqlname( "SA3" ) + " SA3 "
//cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ','04' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC5.C5_VEND1 = SA3.A3_COD "
cQuery += "and ( C5_NOTA = '' Or C5_LIBEROK <> 'E' And C5_BLQ <> '' ) "
cQuery += "and SC5.C5_FILIAL = '" + xfilial( "SC5" ) + "' and SA3.A3_FILIAL = '" + xfilial( "SA3" ) + "' "
cQuery += "and SC5.D_E_L_E_T_ = ' ' and SA3.D_E_L_E_T_ = ' ' "
cQuery += "order by SC5.C5_PRIORES, SC5.C5_ENTREG "
//cQuery += "order by SVIP, SC5.C5_ENTREG "

//MemoWrit( "CARTEIRA.SQL", cQuery )

TCQUERY cQuery NEW ALIAS "CAB"
TCSetField( 'CAB', "C5_EMISSAO", "D", 8, 0 )
TCSetField( 'CAB', "C5_ENTREG",  "D", 8, 0 )

cARQTMP := CriaTrab( , .F. )
Copy To ( cARQTMP )
CAB->( DbCloseArea() )
DbUseArea( .T.,, cARQTMP, "CAB", .F., .F. )

CAB->(DbGotop())

DbSelectArea("SC5")
DbSetOrder(1)

U_ABC50(@aABC,@cCliVip)

while !CAB->(EOF())
  
	_nX := Ascan(aABC, {|x| x[2] == CAB->C5_CLIENTE})
	if _nX > 0
		CAB->SVIP := StrZero(aABC[_nX,1],3)
	else
		CAB->SVIP := "999"		
   endif

	CAB->PRIOR := StrZero( nSeq, 4 )
   
	SC5->(DbSeek(xFilial("SC5")+CAB->C5_NUM) )
	RecLock("SC5",.F.)
	if !Empty(SC5->C5_PRIORES)
		if SC5->C5_PRIORES # StrZero( nSeq, 4 )
			SC5->C5_PRIORES := CAB->PRIOR
		endif
	else
		SC5->C5_PRIORES := StrZero( nSeq, 4 )
	endif
  	MsUnlock()		
	nSeq ++

	CAB->(DbSkip())
end

//IndRegua("CAB",cARQTMP,"PRIOR+PRIOX")


//CAB->( dbSetIndex( cARQTMP + OrdBagExt() ) )
//CAB->(DbSetOrder(1))

CAB->(DbGotop())

Return NIL



***************
Static Function Itens()
***************

cQuery := "select SC6.C6_LOCAL AS LOCAL,SC6.C6_ITEM AS ITEM,SC6.C6_PRODUTO AS PRODUTO,SC6.C6_LOCAL AS LOCAL,SB1.B1_DESC AS DESCRICAO,SC6.C6_QTDVEN AS QTDPED,SC6.C6_QTDENT AS QTDFAT, SC6.C6_TES AS TES, "
cQuery += "( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS QTDLIB, "
cQuery += "SC6.C6_QTDRESE AS RESERVA, "
cQuery += "( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED = '09' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS QTDREJ, "
cQuery += "0 AS ESTOQUE,0 AS ALIBERAR "
cQuery += "from " + retsqlname("SC6") + " SC6," + retsqlname("SB1") + " SB1 "
cQuery += "where SC6.C6_NUM = '" + CAB->C5_NUM + "' and SC6.C6_PRODUTO = SB1.B1_COD "
//cQuery += "and SC6.C6_NUM IN ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
cQuery += "and SC6.C6_NUM IN ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED IN ( '  ','04' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
//cQuery += "and SC6.C6_QTDVEN > SC6.C6_QTDENT "
cQuery += "and SC6.C6_FILIAL = '" + xfilial("SC6") + "' and SC6.D_E_L_E_T_ = ' ' "
cQuery += "and SB1.B1_FILIAL = '" + xfilial("SB1") + "' and SB1.D_E_L_E_T_ = ' ' "
cQuery += "order by SC6.C6_ITEM "

TCQUERY cQuery NEW ALIAS "TMP"

TCSetField( 'TMP', "QTDPED",   "N", 15, 3 )
TCSetField( 'TMP', "QTDFAT",   "N", 15, 3 )
TCSetField( 'TMP', "QTDLIB",   "N", 15, 3 )
TCSetField( 'TMP', "ESTOQUE",  "N", 15, 3 )
TCSetField( 'TMP', "ALIBERAR", "N", 15, 3 )
TCSetField( 'TMP', "QTDREJ",   "N", 15, 3 )
TCSetField( 'TMP', "RESERVA",  "N", 15, 3 )

ITE->( __DbZap() )
While ! TMP->( Eof() )
	ITE->( DbAppend() )
	ITE->ITEM      := TMP->ITEM
	ITE->PRODUTO   := TMP->PRODUTO
	ITE->LOCAL     := TMP->LOCAL
	ITE->DESCRICAO := TMP->DESCRICAO
	ITE->QTDPED    := TMP->QTDPED
	ITE->QTDFAT    := TMP->QTDFAT
	ITE->QTDLIB    := TMP->QTDLIB
	ITE->ESTOQUE   := U_SALDOEST( ITE->PRODUTO, ITE->LOCAL ) - SALDORES( ITE->PRODUTO )
	ITE->ALIBERAR  := TMP->ALIBERAR
	ITE->QTDREJ    := TMP->QTDREJ
	ITE->TES       := TMP->TES
//  ITE->RESERVA   := SALDORES( TMP->PRODUTO ) //TMP->RESERVA alterei para ele considerar reservado produto original e o generico
	ITE->RESERVA   := TMP->RESERVA
	TMP->( DbSkip() )
End

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
            // NOVA LIBERACAO DE CRETIDO 
			If (Empty( SC9->C9_BLCRED ) .OR. SC9->C9_BLCRED='04').and. ! Empty( SC9->C9_BLEST ) .and. SC9->C9_BLEST <> "10"  // Acha primeira ocorrencia do produto	
				Exit                                                                                // com bloqueio de estoque			
			Endif
			SC9->( DbSkip() )
		EndDo
		If SC9->C9_PEDIDO == CAB->C5_NUM .and. SC9->C9_ITEM == ITE->ITEM
			Begin Transaction
			If SC9->C9_QTDLIB <> ITE->ALIBERAR  // Usa rotinas padrao Microsiga p/ quando quantidade for menor que a liberada pelo credito
				SC6->( DbSeek( xFILIAL( "SC6" ) + CAB->C5_NUM + ITE->ITEM + ITE->PRODUTO ) )
				//             nREG := SC6->( Recno() )
				nVlrCred := 0
				nQtdOld  := SC9->C9_QTDLIB
				nQtdNew  := ITE->ALIBERAR
				RecLock( "SC9", .F. )
				SC9->C9_QTDLIB2 -= SC9->C9_QTDLIB2 / SC9->C9_QTDLIB * ITE->ALIBERAR
				SC9->C9_QTDLIB  -= ITE->ALIBERAR
				MsUnLock()
				//MaLibDoFat( SC6->( RecNo() ), @nQtdNew, .T., .T., .F., .F., .T., .F., /*aEmpenho*/, { || SC9->C9_BLCRED2 := "01" }, /*aEmpPronto*/, /*lTrocaLot*/, /*lOkExpedicao*/, @nVlrCred, /*nQtdalib2*/ )
				// NOVA LIBRACAO DE CREDITO 2 ENTROU EM DESUSO
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
			//ITE->RESERVA  += ITE->ALIBERAR
			ITE->RESERVA  := 0
			
			SC6->( DbSeek( xFILIAL( "SC6" ) + CAB->C5_NUM + ITE->ITEM + ITE->PRODUTO ) )
			RecLock( "SC6", .F. )
			SC6->C6_QTDRESE := ITE->RESERVA
			MsUnLock()
			
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

/* 
***************
//Libera direto apenas ao clicar no botao libera item
***************
Static Function QtdLib()
***************

Private nQTD := ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB

if Quant()
	ITE->ALIBERAR := nQTD
endif
oBRW2:oBrowse:Refresh()

Return NIL
*/

***************
//Solicita Quantidade a ser liberada
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
Static Function QtdRes()
***************

Private nQTD := ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB

SC6->( DbSetOrder( 1 ) )
SC6->( DbSeek( xFILIAL( "SC6" ) + CAB->C5_NUM + ITE->ITEM + ITE->PRODUTO ) )

RecLock( "SC6", .F. )
if SC6->C6_QTDRESE > 0
	if MsgBox( "O Item selecionado já esta reservado. Deseja CANCELAR RESERVA ?", "Escolha", "YESNO" )
		ITE->ESTOQUE    += ITE->RESERVA
		ITE->RESERVA    := 0
		SC6->C6_QTDRESE := ITE->RESERVA
	endif
else
	if nQtd > 0
		ITE->RESERVA    := nQTD
		ITE->ESTOQUE    -= ITE->RESERVA
		SC6->C6_QTDRESE := ITE->RESERVA
	else
		MsgBox( "O Item selecionado já esta LIBERADO, portanto não será RESERVADO.", "Informação", "OK" )
	endif
endif
MsUnLock()


oBRW2:oBrowse:Refresh()

Return NIL


***************
Static Function FFila()
***************

private cPrio := CAB->PRIOR

if nOrdG = 2
   @ 000,000 TO 90,250 Dialog oDLG2 Title "Prioridade"
   @ 011,020 Say "Posição:"
   @ 010,050 Get cPrio Size 40,40 Picture "@R 9999"
   @ 030,040 BMPButton Type 01 Action ( MudaFila(), oBRW2:oBrowse:Refresh(), Close( oDLG2 ) )
   @ 030,080 BMPButton Type 02 Action Close( oDLG2 )
   Activate Dialog oDLG2 Centered
else
   Aviso("Aviso","Ordene por Prioridade de Reserva antes de Furar a Fila.",{"OK"})
endif

Return NIL


***************
Static Function MudaFila()
***************
Local nRec   := CAB->(RecNo())
Local cPrioN := StrZero( Val(cPrio), 4 )
Local cPrioO := CAB->PRIOR

if Val(cPrio) > 0
	
	SC5->(DbSeek(xFilial("SC5")+CAB->C5_NUM) )
	RecLock("SC5",.F.)
	
	if cPrioO < cPrioN
		CAB->PRIOX := cPrioN
		CAB->PRIOR := cPrioN
		SC5->C5_PRIORES := cPrioN
	else
		CAB->( DbSeek( cPrioN ) )
		CAB->PRIOX := CAB->PRIOR
		
		CAB->( DbSeek( cPrioO ) )
		CAB->PRIOR := cPrioN
		SC5->C5_PRIORES := cPrioN
	endif
	MSUnlock()
	
	CAB->( DbSeek( cPrioO+"    " ,.T. ) )
	if cPrioO < cPrioN
		while !CAB->(EOF())
			if !Empty(CAB->PRIOX)
				CAB->PRIOX := ''
				exit
			endif
			CAB->PRIOR := StrZero(Val(CAB->PRIOR)-1,4)
			
			SC5->(DbSeek(xFilial("SC5")+CAB->C5_NUM) )
			RecLock("SC5",.F.)
			SC5->C5_PRIORES := CAB->PRIOR
			MsUnLock()
			CAB->(DbSkip())
		end
	else
		CAB->(DbSkip(-1))
		while !CAB->(BOF())
			CAB->PRIOR := StrZero(Val(CAB->PRIOR)+1,4)

			SC5->(DbSeek(xFilial("SC5")+CAB->C5_NUM) )
			RecLock("SC5",.F.)
			SC5->C5_PRIORES := CAB->PRIOR
			MsUnLock()

			if !Empty(CAB->PRIOX)
				CAB->PRIOX := ''
				exit
			endif
			CAB->(DbSkip(-1))
		end
	endif
	
	CAB->(DbGoTo(nRec) )
	Itens()
else
	MsgBox( "A Prioridade deve ser maior que zero", "info", "stop" )
endif

Return nil

***************
Static Function Quant()
***************

if nQTD < 0 .or. nQTD > Min( ITE->ESTOQUE + ITE->RESERVA, ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB - ITE->QTDREJ )
	if nQTD > (ITE->ESTOQUE + ITE->RESERVA)
		MsgBox( "Estoque insuficiente para essa quantidade", "info", "stop" )
		Return U_senha2( "07", 4 )[ 1 ]
	elseif nQTD > ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB - ITE->QTDREJ
		MsgBox( "Quantidade superior ao saldo a liberar", "info", "stop" )
		Return .F.
	else
		Return .F.
	endif
endIf

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

if ! Empty( cPROD1 )
	if Len( AllTrim( cPROD1 ) ) <= 7
		cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) == "R", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) == "R", 6, 5 ), 2 ), 15 )
	else
		cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) == "R", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) == "R", 8, 7 ), 2 ), 15 )
	endif
	
	cQuery := "select sum( C6_QTDRESE ) AS RESERVA "
	cQuery += "from " + retsqlname("SC6") + " SC6, "+ retsqlname("SC5") + " SC5 "
	cQuery += "where C6_PRODUTO IN( '"+cProd1+"', '"+cProd2+"' ) and "
	cQuery += "C6_NUM = C5_NUM AND C5_PRIORES <= '"+CAB->PRIOR+"' AND "
	cQuery += "C6_QTDENT < C6_QTDVEN AND C6_QTDRESE > 0 AND C6_FILIAL = '" + xfilial("SC6") + "' and "
	cQuery += "SC6.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' "
	
	TCQUERY cQuery NEW ALIAS "C6X"
	DbSelectArea("C6X")
	nQuant := C6X->RESERVA
	C6X->(DbCloseArea())
endif

DbSelectArea(cALIASANT)

return nQuant


***************
Static Function salvaObs()
***************

Local cGet
Local oDlg1, oGrp1, oGrp2, oSBtn1, oSBtn2, oMGet1
Local nOrder, nReg
nReg   := SC5->( recno() )
nOrder := retIndex("SC5") 
SC5->( dbSetOrder(1) )
SC5->( dbSeek( xFilial('SC5') + CAB->C5_NUM ) )
cGet := SC5->C5_OBSERVA

oDlg1      := MSDialog():New( 176,316,446,815,"Observações :",,,,,,,,,.T.,,, )
oGrp1      := TGroup():New( 003,004,128,244,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp2      := TGroup():New( 099,020,103,228,"",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSBtn1     := SButton():New( 108,070,1,{ || storeObs( cGet ), oDlg1:End() },oGrp1,,"", )
oSBtn2     := SButton():New( 108,132,2,{ || oDlg1:End() },oGrp1,,"", )
oMGet1     := TMultiGet():New( 011,008,{|u| If(PCount()>0,cGet:=u,cGet)},oGrp1,231,085,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

oDlg1:Activate(,,,.T.)

Return {|| SC5->( dbGoTo( nReg ) ), SC5->( dbSetOrder( nOrder ) ) }


***************
Static Function storeObs( cObs )
***************

recLock("SC5", .F.)
SC5->C5_OBSERVA := cObs
SC5->( msUnlock() )

return


***************
Static Function salvaTrn()
***************

Local oDlg1, oGrp1, oGrp2, oBtn1, oBtn2, oMGet1, oSay1, oSay2, oSay3, oSay4
Local nOrder, nReg
Local cGet := Space(3)

oDlg1      := MSDialog():New( 139,340,384,777,"Transportadora",,,,,,,,,.T.,,, )
oSay3      := TSay():New( 029,016,{||"Nome :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,011)
oSay4      := TSay():New( 029,064,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,011)
oSay5      := TSay():New( 047,016,{||"Destino :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 047,064,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)
oSay1      := TSay():New( 012,016,{||"Código :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,012)
oSay2      := TSay():New( 012,064,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,065,012)
oGrp1      := TGroup():New( 003,004,115,212,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp2      := TGroup():New( 066,030,070,186,"",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGet1      := TGet():New( 079,077,{|u| If(PCount()>0,cGet:=u,cGet)},oGrp1,060,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA4","cGet",,)
oSBtn1     := SButton():New( 095,076,1,{ || storeTrn( cGet ), oDlg1:End() },oGrp1,,"", )
oSBtn2     := SButton():New( 095,112,2,{ || oDlg1:End() },oGrp1,,"", )

nReg   := SC5->( recno() )
nOrder := retIndex("SC5") 
SC5->( dbSetOrder(1) )
SC5->( dbSeek( xFilial('SC5') + CAB->C5_NUM ) )
SA4->( dbSetOrder(1) )
SA4->( dbSeek( xFilial('SA4') + SC5->C5_TRANSP ) )
objectMethod( oSay2,"SetText(SC5->C5_TRANSP)")
objectMethod( oSay4,"SetText(SA4->A4_NREDUZ)")
objectMethod( oSay6,"SetText( posicione('SA1', 1, xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJAENT, 'A1_MUN') )"	 )
oGet1:bValid  := { || ExistCpo("SA4",cGet) }/*,{ || objectMethod( oSay4,"SetText(SA4->A4_NREDUZ)"),;
					  objectMethod( oSay4,"Refresh()"),objectMethod( oSay2,"SetText(SA4->A4_COD)"),;
				      objectMethod( oSay2,"Refresh()") }, ) }*/
oGet1:bChange := { || objectMethod( oSay4,"SetText(SA4->A4_NREDUZ)"),;
					  objectMethod( oSay4,"Refresh()"),;
				      objectMethod( oSay2,"SetText(SA4->A4_COD)"),;
				      objectMethod( oSay2,"Refresh()") }
oDlg1:Activate(,,,.T.)

Return {|| SC5->( dbGoTo( nReg ) ), SC5->( dbSetOrder( nOrder ) ) }



***************
Static Function storeTrn( cTrn )
***************

If ALLTRIM(cTrn)='024'
   recLock("SC5", .F.)
   SC5->C5_TRANSP := cTrn
   SC5->( msUnlock() )
   return
endif

DbSelectArea("SZZ")
DbSetOrder(1) 
if DbSeek(xFilial("SZZ")+cTrn+SC5->C5_LOCALIZ,.F.)

	If minimo()
	   recLock("SC5", .F.)
	   SC5->C5_TRANSP := cTrn
	   SC5->( msUnlock() )
	EndIf

   return

else	
 alert("Essa transportadora "+ALLTRIM(SA4->A4_NREDUZ)+" nao entrega nessa localidade "+ALLTRIM(posicione('SA1', 1, xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJAENT, 'A1_MUN'))    )
 return
endif

return

************************
Static Function minimo()
************************

Local nReg
Local nOrder
Local cEST   := ""
Local nIdx   := nTotal := nSufr1 := nSufr2 := 0
Local nInd1  := nInd2  := nInd3  := 0
Local lOk := .T.
Local nPedMIN := 0 //VALOR MÍNIMO PARA PEDIDOS QUE IRÁ VARIAR DE ACORDO COM A REGIÃO
Local cRegiao  := ""
Local cNomeReg := ""
Local lSacola := .F.  
Local lLIBMIN := .F. //chama a função LIBMIN que é uma "2a. chance" de ver se mesmo abaixo do valor mínimo, o sistema liberará

if SC5->C5_TIPO=='D'
   Return .T.
endif

// pedido para grande joao pessoa
 DbSelectArea("SA1")
 DbSetORder(1)
 if SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,.F.))
                               // JP  /BAYEX/S.RITA/CABEDELO
    If alltrim(SA1->A1_COD_MUN)$'07507/01807/13703/03209'
       Return .T.
    Endif           
    If SA1->A1_EST $ "AC,/AM/AP/PA/RO/RR/TO"
    	cRegiao := 'NO'  //NORTE
    	nPedMIN := GETMV("RV_VALMINO") 
    	cNomeReg:= "NORTE"
    ElseIf SA1->A1_EST $ "/MA/PI/CE/RN/PB/PE/AL/BA/SE"
    	cRegiao := 'NE'         //NORDESTE
    	nPedMIN := GETMV("RV_VALMINE")
	   	cNomeReg:= "NORDESTE"
	ElseIf SA1->A1_EST $ "GO/MT/MS/DF"
		cRegiao := 'CO'                   //CENTRO-OESTE
		nPedMIN := GETMV("RV_VALMICO")
    	cNomeReg:= "CENTRO-OESTE"
	ElseIf SA1->A1_EST $ "MG/ES/RJ/SP"
		cRegiao := 'SD'               //SUDESTE
		nPedMIN := GETMV("RV_VALMISD")
    	cNomeReg:= "SUDESTE"
	ElseIf SA1->A1_EST $ "RS/PR/SC"
		cRegiao := "SU"	            //SUL
		nPedMIN := GETMV("RV_VALMISU")
    	cNomeReg:= "SUL"
	Endif
 endif
/*
nInd1    := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_QTDVEN" } )
nInd2    := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRUNIT" } )
nInd3    := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_TES"    } )
nPOSLOC  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_LOCAL"  } )
nPOSPROD := aScan( aHeader, { |x| Alltrim( x[2] ) == "C6_PRODUTO"} )
nIndPRC  := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRCVEN" } )
nPosDel  := Len( aHeader ) + 1
*/
/*
//VERIFICAR SE FOR SACOLA, O PEDIDO MÍNIMO MUDARÁ
DbSelectArea("SC6")
DbSetORder(1)
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

While SC6->(!EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
	if Alltrim(SC6->C6_PRODUTO) $ "GUB"
		lSacola := .T.
	endIf
	SC6->(dbSkip())
EndDo
*/
DbSelectArea("SC6")
DbSetORder(1)
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

While SC6->(!EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
    	If SC6->C6_PRUNIT = 0
			nTotal +=SC6->C6_QTDVEN*SC6->C6_PRCVEN    		
		Else
	       	nTotal +=SC6->C6_QTDVEN*SC6->C6_PRUNIT
	 	Endif
	SC6->(dbSkip())
EndDo

DbSelectArea("SC6")
DbSetORder(1)
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

if ! empty( posicione('SA1', 1, xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJAENT, 'A1_SUFRAMA' ) )
    
    if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + SC6->C6_TES , 'F4_ICM'))='S' // CALCULA ICM 
       if ALLTRIM(posicione('SA1', 1, xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJAENT, 'A1_CALCSUF' )) $ 'S/I' 
          nSufr1 := nTotal * 0.12                      
       Endif   
    endif 
            
    if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + SC6->C6_TES , 'F4_PISCOF')) != '4' // CALCULA PIS/COFINS 
        if ALLTRIM(posicione('SA1', 1, xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJAENT, 'A1_CALCSUF' )) $ 'S'       
           if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + SC6->C6_TES , 'F4_PISCOF')) $ '3' // AMBOS
               nSufr2 := nTotal * 0.0925                    
           ELSEif ALLTRIM(posicione('SF4', 1, xFilial('SF4') + SC6->C6_TES , 'F4_PISCOF')) $ '1' // PIS	   
               nSufr2 := nTotal * 0.0165                    	           
           ELSEif ALLTRIM(posicione('SF4', 1, xFilial('SF4') + SC6->C6_TES , 'F4_PISCOF')) $ '2' // COFINS
               nSufr2 := nTotal * 0.076                    	           
           ENDIF
        ENDIF        
    Endif
    
    nTotal -= (nSufr1+nSufr2)    
    
endIf


//NOVA SISTEMÁTICA DE PEDIDO MÍNIMO POR REGIÃO
if nTotal < nPedMIN

   lOk := .F.
   
	msgAlert( " O Pedido Totaliza R$:" + Transform( nTotal , "@E 999,999,999.99" ) + CHR(13) + CHR(10) ;
	+ " Não Atingiu o Valor Mínimo de: R$ " + Transform( nPedMIN , "@E 999,999,999.99") + " Para a Região: " + cNomeReg ) //+ CHR(13) + CHR(10);
Else
   	lOk := .T.
endif   

return lOk
 
