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
      Index On SVIP+PRIOX To &cARQTMP
   else
      nOrdG := 2
      Index On C5_NUM To &cARQTMP  
   endif   
   CAB->(DbSetOrder(1))
   oBrowse:SetHeaderImage(nCol,"COLDOWN")
	oBrowse:Refresh()
endif
Return


*************
User Function LIBESTX()
*************
Private ldescRes := .F.
Private xDD      := 0
Private oSayV2
Private oNVALOR2

SetPrvt( "cMARCA,oDLG1,nOrdG,nPeso,oNTRANP1" )

cMARCA := GetMark()

aESTRUT := {{ "ITEM",       "C", 002, 0 }, ;
				{ "PRODUTO",    "C", 015, 0 }, ;
				{ "LOCALI",      "C", 002, 0 }, ;
				{ "DESCRICAO",  "C", 060, 0 }, ;
				{ "QTDPED",     "N", 015, 3 }, ;
				{ "QTDFAT",     "N", 015, 3 }, ;
				{ "QTDLIB",     "N", 015, 3 }, ;
				{ "QTDREJ",     "N", 015, 3 }, ;
				{ "RESERVA",    "N", 015, 3 }, ;
				{ "ESTOQUE",    "N", 015, 3 }, ;
				{ "TES",        "C", 003, 0 }, ;
				{ "SEGRE",      "C", 001, 0 }, ;
				{ "ALIBERAR",   "N", 015, 3 }}

cARQTMP := CriaTrab( aESTRUT, .T. )
DbUseArea( .T.,, cARQTMP, "ITE", .F., .F. )

MsAguarde( {|| Cabec() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Lendo pedidos da carteira..." ) )

DEFINE FONT oFont NAME "Arial" SIZE 6, 15 BOLD

//@ 000,000 TO 512,795 Dialog oDLG1 Title "Liberacao de estoque"
@ 000,000 TO 570,795 Dialog oDLG1 Title "Liberacao de estoque"

oBRW2 := MsSelect():New( "ITE",,, ;
{{ "ITEM"               ,, OemToAnsi( "It" ) }, ;
 { "LOCALI"              ,, OemToAnsi( "Lc" ) }, ;
 { "ALIBERAR"           ,, OemToAnsi( "Q.a lib." ),  "@E 999,999,999.999" }, ;
 { "ESTOQUE"            ,, OemToAnsi( "Est.Virt." ), "@E 999,999,999.999" }, ;
 { "( QTDPED - QTDFAT )",, OemToAnsi( "Sld a fat." ),"@E 999,999,999.999" }, ;
 { "QTDLIB"             ,, OemToAnsi( "Q.Lib." ), "@E 999,999,999.999" }, ;
 { "QTDREJ"             ,, OemToAnsi( "Q.Rej." ), "@E 999,999,999.999" }, ;
 { "RESERVA"            ,, OemToAnsi( "Q.Res." ), "@E 999,999,999.999" }, ;
 { "QTDPED"             ,, OemToAnsi( "Q.Ped." ), "@E 999,999,999.999" }, ;
 { "SEGRE"              ,, OemToAnsi( "Segreg." ), "@!" }, ;
 { "( ' ' )"            ,, OemToAnsi( " " ) } },,, ;
{ 130, 000, 215, 397 })

//{ 120, 000, 215, 397 } posicoes originais 

oBrw1 := MsSelect():New( "CAB", "MARCA",, ;
{{ "MARCA"               ,, " " }, ;
 { "SVIP"                ,, OemToAnsi( "Seq.Vip") }, ; //{ "PRIOR"               ,, OemToAnsi( "Prior.Res.") }, ;
 { "C5_NUM"              ,, OemToAnsi( "Pedido") }, ;
 { "C5_ENTREG"           ,, OemToAnsi( "Faturar em") }, ;
 { "C5_CLIENTE"          ,, OemToAnsi( "Cliente") }, ;
 { "C5_LOJACLI"          ,, OemToAnsi( "Loja") }, ;
 { "( Left( NOME, 30 ) )",, OemToAnsi( "Nome do cliente/fornecedor") }, ;
 { "C5_VEND1"            ,, OemToAnsi( "Vend.") }, ;
 { "A3_NREDUZ"           ,, OemToAnsi( "Nome do vendedor") }, ;
 { "( If( C5_PRIOR == 'P', 'Programado', If( C5_PRIOR == 'L', 'Licitacao', If( C5_PRIOR == 'T', 'Cliente TOP', '' ) ) ) )",, OemToAnsi( "Prioridade") },;
 { "XDD"                 ,, OemToAnsi( "xDD") } },, ;
cMARCA, { 005, 000, 090, 397 } )

oBRW1:oBrowse:lhasMark    := .F.
oBRW1:oBrowse:lCanAllmark := .F.
oBRW1:oBrowse:bCHANGE     := {|| Itens() }

//oBrw1:oBrowse:bHeaderClick := {|oBrw,nCol| MbrIdxCol(nCol,oBrw)}

//oBRW2:oBROWSE:blDblClick  := {|| QtdLib() }
//oBRW2:oBROWSE:bRClicked   := {|| QtdRes() }

//oBRW2:oBROWSE:bCHANGE     := {|| ObjectMethod( oPDTDESC, "SetText( Left( ITE->PRODUTO, 9 ) + '  -  ' + AllTrim( ITE->DESCRICAO ) )" ) }
oBRW2:oBROWSE:bCHANGE     := {|| atualiza() }
//colocado em 08/04/2010 chamado 001539
oSayTRANP := TSAY():Create(oDlg1)
oSayTRANP:cName := "oSayTRANP"
oSayTRANP:cCaption := "transp:"
oSayTRANP:nLeft := 440
oSayTRANP:nTop := 480
oSayTRANP:nWidth := 113
oSayTRANP:nHeight := 17
oSayTRANP:lShowHint := .F.
oSayTRANP:lReadOnly := .F.
oSayTRANP:Align := 0
oSayTRANP:lVisibleControl := .T.
oSayTRANP:lWordWrap := .F.
oSayTRANP:lTransparent := .F.

oNTRANP1 := TSAY():Create(oDlg1)
oNTRANP1:cName := "oNTRANP1"
oNTRANP1:cCaption := " "
oNTRANP1:nLeft := 480
oNTRANP1:nTop := 480
oNTRANP1:nWidth := 600 
oNTRANP1:nHeight := 17
oNTRANP1:lShowHint := .F.
oNTRANP1:lReadOnly := .F.
oNTRANP1:Align := 0
oNTRANP1:lVisibleControl := .T.
oNTRANP1:lWordWrap := .F.
oNTRANP1:lTransparent := .F.
oNTRANP1:SetFont( oFont )
oNTRANP1:nCLRTEXT := CLR_BLUE

oSayNATU := TSAY():Create(oDlg1)
oSayNATU:cName := "oSayNATU"
oSayNATU:cCaption := "Natureza:"
oSayNATU:nLeft := 510
oSayNATU:nTop := 450
oSayNATU:nWidth := 113
oSayNATU:nHeight := 17
oSayNATU:lShowHint := .F.
oSayNATU:lReadOnly := .F.
oSayNATU:Align := 0
oSayNATU:lVisibleControl := .T.
oSayNATU:lWordWrap := .F.
oSayNATU:lTransparent := .F.

oSayNATU2 := TSAY():Create(oDlg1)
oSayNATU2:cName := "oSayNATU2"
oSayNATU2:cCaption := "oSayNATU2"
oSayNATU2:nLeft := 570
oSayNATU2:nTop := 450
oSayNATU2:nWidth := 300
oSayNATU2:nHeight := 17
oSayNATU2:lShowHint := .F.
oSayNATU2:lReadOnly := .F.
oSayNATU2:Align := 0
oSayNATU2:lVisibleControl := .T.
oSayNATU2:lWordWrap := .F.
oSayNATU2:lTransparent := .F.
oSayNATU2:SetFont( oFont )
oSayNATU2:nCLRTEXT := CLR_BLUE

//

// colocado em 19/02/09 em chamado 000723
oSay11 := TSAY():Create(oDlg1)
oSay11:cName := "oSay11"
oSay11:cCaption := "Valor:"
oSay11:nLeft := 160
oSay11:nTop := 480
oSay11:nWidth := 100
oSay11:nHeight := 17
oSay11:lShowHint := .F.
oSay11:lReadOnly := .F.
oSay11:Align := 0
oSay11:lVisibleControl := .T.
oSay11:lWordWrap := .F.
oSay11:lTransparent := .F.

oNVALOR := TSAY():Create(oDlg1)
oNVALOR:cName := "oNVALOR"
oNVALOR:cCaption := ""
oNVALOR:nLeft := 200
oNVALOR:nTop := 480
oNVALOR:nWidth := 100
oNVALOR:nHeight := 17
oNVALOR:lShowHint := .F.
oNVALOR:lReadOnly := .F.
oNVALOR:Align := 0
oNVALOR:lVisibleControl := .T.
oNVALOR:lWordWrap := .F.
oNVALOR:lTransparent := .F.
oNVALOR:SetFont( oFont )
oNVALOR:nCLRTEXT := CLR_BLUE

oSay12 := TSAY():Create(oDlg1)
oSay12:cName := "oSay12"
oSay12:cCaption := "Saldo:"
oSay12:nLeft := 300
oSay12:nTop := 480
oSay12:nWidth := 113
oSay12:nHeight := 17
oSay12:lShowHint := .F.
oSay12:lReadOnly := .F.
oSay12:Align := 0
oSay12:lVisibleControl := .T.
oSay12:lWordWrap := .F.
oSay12:lTransparent := .F.

oNSALDO := TSAY():Create(oDlg1)
oNSALDO:cName := "oNSALDO"
oNSALDO:cCaption := ""
oNSALDO:nLeft := 340
oNSALDO:nTop := 480
oNSALDO:nWidth := 100 
oNSALDO:nHeight := 17
oNSALDO:lShowHint := .F.
oNSALDO:lReadOnly := .F.
oNSALDO:Align := 0
oNSALDO:lVisibleControl := .T.
oNSALDO:lWordWrap := .F.
oNSALDO:lTransparent := .F.
oNSALDO:SetFont( oFont )
oNSALDO:nCLRTEXT := CLR_BLUE

///valor 6DD - Solicitado por Jaciara em 18/06/13
oSayV2 := TSAY():Create(oDlg1)
oSayV2:cName := "oSayV2"
oSayV2:cCaption := "Val.xDD:"
oSayV2:nLeft := 160
oSayV2:nTop := 500
oSayV2:nWidth := 110
oSayV2:nHeight := 17
oSayV2:lShowHint := .F.
oSayV2:lReadOnly := .F.
oSayV2:Align := 0
oSayV2:lVisibleControl := .T. //fVerPV(CAB->C5_NUM, oSayV2) 
oSayV2:lWordWrap := .F.
oSayV2:lTransparent := .F.
	
oNVALOR2 := TSAY():Create(oDlg1)
oNVALOR2:cName := "oNVALOR2"
oNVALOR2:cCaption := ""
oNVALOR2:nLeft := 200
oNVALOR2:nTop := 500
oNVALOR2:nWidth := 100
oNVALOR2:nHeight := 17
oNVALOR2:lShowHint := .F.
oNVALOR2:lReadOnly := .F.
oNVALOR2:Align := 0
oNVALOR2:lVisibleControl := .T. //fVerPV(CAB->C5_NUM, oNVALOR2) 
oNVALOR2:lWordWrap := .F.
oNVALOR2:lTransparent := .F.
oNVALOR2:SetFont( oFont )
oNVALOR2:nCLRTEXT := CLR_BLUE   

oSaySalDD := TSAY():Create(oDlg1)
oSaySalDD:cName := "oSaySalDD"
oSaySalDD:cCaption := "Sld xDD:"
oSaySalDD:nLeft := 300
oSaySalDD:nTop := 500
oSaySalDD:nWidth := 113
oSaySalDD:nHeight := 17
oSaySalDD:lShowHint := .F.
oSaySalDD:lReadOnly := .F.
oSaySalDD:Align := 0
oSaySalDD:lVisibleControl := .T.
oSaySalDD:lWordWrap := .F.
oSaySalDD:lTransparent := .F.

oNSALDO2 := TSAY():Create(oDlg1)
oNSALDO2:cName := "oNSALDO2"
oNSALDO2:cCaption := ""
oNSALDO2:nLeft := 340
oNSALDO2:nTop := 500
oNSALDO2:nWidth := 100 
oNSALDO2:nHeight := 17
oNSALDO2:lShowHint := .F.
oNSALDO2:lReadOnly := .F.
oNSALDO2:Align := 0
oNSALDO2:lVisibleControl := .T.
oNSALDO2:lWordWrap := .F.
oNSALDO2:lTransparent := .F.
oNSALDO2:SetFont( oFont )
oNSALDO2:nCLRTEXT := CLR_BLUE

///FR - 25/06/13



//
oSay10 := TSAY():Create(oDlg1)
oSay10:cName := "oSay10"
oSay10:cCaption := "Peso:"
oSay10:nLeft := 14
oSay10:nTop := 480
oSay10:nWidth := 113
oSay10:nHeight := 17
oSay10:lShowHint := .F.
oSay10:lReadOnly := .F.
oSay10:Align := 0
oSay10:lVisibleControl := .T.
oSay10:lWordWrap := .F.
oSay10:lTransparent := .F.   

oNPESO := TSAY():Create(oDlg1)
oNPESO:cName := "oNPESO"
oNPESO:cCaption := ""
oNPESO:nLeft := 070
oNPESO:nTop := 480
oNPESO:nWidth := 090//380
oNPESO:nHeight := 17
oNPESO:lShowHint := .F.
oNPESO:lReadOnly := .F.
oNPESO:Align := 0
oNPESO:lVisibleControl := .T.
oNPESO:lWordWrap := .F.
oNPESO:lTransparent := .F.
oNPESO:SetFont( oFont )
oNPESO:nCLRTEXT := CLR_BLUE

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
/*02/06/09*/
oSay101 := TSAY():Create(oDlg1)
oSay101:cName := "oSay101"
oSay101:cCaption := "UF:"
oSay101:nLeft := 450
oSay101:nTop := 450
oSay101:nWidth := 30//113
oSay101:nHeight := 17
oSay101:lShowHint := .F.
oSay101:lReadOnly := .F.
oSay101:Align := 0
oSay101:lVisibleControl := .T.
oSay101:lWordWrap := .F.
oSay101:lTransparent := .F.

oSay102 := TSAY():Create(oDlg1)
oSay102:cName := "oSay102"
oSay102:cCaption := ""
oSay102:nLeft := 480
oSay102:nTop := 450
oSay102:nWidth := 30//113
oSay102:nHeight := 17
oSay102:lShowHint := .F.
oSay102:lReadOnly := .F.
oSay102:Align := 0
oSay102:lVisibleControl := .T.
oSay102:lWordWrap := .F.
oSay102:lTransparent := .F.
oSay102:SetFont( oFont )
oSay102:nCLRTEXT := CLR_BLUE

/*02/06/09*/
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
//oGroup1:nTop      := 203
oGroup1:nTop      := 223
oGroup1:nWidth    := 777

/**/

// teste pedido
oBtn70 := TButton():Create(oGroup1)
oBtn70:cCaption  := 'Pedido'
oBtn70:cName     := 'oBtn70'
oBtn70:cVariable := 'noBtn70'
oBtn70:lActive   := .T.
oBtn70:lShowHint := .F.
oBtn70:nHeight   := 17
oBtn70:nLeft     := 666
oBtn70:nTop      := 230
oBtn70:nWidth    := 75
oBtn70:bAction   := { || Pedido() }

/*
oBtn70 := TButton():Create(oGroup1)
oBtn70:cCaption  := 'Pedido'
oBtn70:cName     := 'oBtn70'
oBtn70:cVariable := 'noBtn70'
oBtn70:lActive   := .T.
oBtn70:lShowHint := .F.
oBtn70:nHeight   := 17
oBtn70:nLeft     := 688
oBtn70:nTop      := 230
oBtn70:nWidth    := 95//75
oBtn70:bAction := { || Pedido() }
*/
//


oBtn60 := TButton():Create(oGroup1)
oBtn60:cCaption  := 'descons. reserva'
oBtn60:cName     := 'oBtn60'
oBtn60:cVariable := 'noBtn60'
oBtn60:lActive   := .T.
oBtn60:lShowHint := .F.
oBtn60:nHeight   := 17
//oBtn60:nLeft     := 663
oBtn60:nLeft     := 558 //600
//oBtn60:nTop      := 212
oBtn60:nTop      := 230
oBtn60:nWidth    := 95//75
oBtn60:bAction := { || descRes() }

/*oBtn50 := TButton():Create(oGroup1)
oBtn50:cCaption  := 'ordena p/ data'
oBtn50:cName     := 'oBtn50'
oBtn50:cVariable := 'noBtn50'
oBtn50:lActive   := .T.
oBtn50:lShowHint := .F.
oBtn50:nHeight   := 17
//oBtn50:nLeft     := 622
//oBtn50:nLeft     := 600
oBtn50:nLeft     := 575
oBtn50:nTop      := 212
oBtn50:nWidth    := 75
oBtn50:bAction := { || msAguarde( {|| sortDate() }, "Favor aguardar...", "Reordenando os pedidos não-vips..."  ) }*/

oBtn50 := TButton():Create(oGroup1)
oBtn50:cCaption  := 'transport.'
oBtn50:cName     := 'oBtn50'
oBtn50:cVariable := 'noBtn50'
oBtn50:lActive   := .T.
oBtn50:lShowHint := .F.
oBtn50:nHeight   := 17
//oBtn50:nLeft     := 622
oBtn50:nLeft     := 470 //512
//oBtn50:nLeft     := 487
//oBtn50:nTop      := 212
oBtn50:nTop      := 230
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
oBtn40:nLeft     := 382 //424
//oBtn40:nLeft     := 399
oBtn40:nTop      := 230
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
oBtn4:nLeft     := 294 //336
//oBtn4:nLeft     := 311
//oBtn4:nTop      := 212
oBtn4:nTop      := 230
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
oBtn6:nLeft     := 206//248
//oBtn6:nLeft     := 223
//oBtn6:nTop      := 212
oBtn6:nTop      := 230
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
oBtn5:nLeft     := 118//160
//oBtn5:nLeft     := 135
//oBtn5:nTop      := 212
oBtn5:nTop      := 230
oBtn5:nWidth    := 75
oBtn5:bAction   := { || QtdLib() }

oBtnP := TButton():Create(oGroup1)
oBtnP:cCaption  := 'pesquisar'
oBtnP:cName     := 'oBtnP'
oBtnP:cVariable := 'noBtnP'
oBtnP:lActive   := .T.
oBtnP:lShowHint := .F.
oBtnP:nHeight   := 17
//oBtnP:nLeft     := 270
oBtnP:nLeft     := 30
//oBtnP:nLeft     := 35
//oBtnP:nTop      := 212
oBtnP:nTop      := 230
oBtnP:nWidth    := 75
oBtnP:bAction   := { || Pesquisar() }



//@ 240,140 Button "_Liberar"  Size 50,15 Action Liberar()
//@ 240,210 Button "_Sair"     Size 50,15 Action oDLG1:End()
@ 262,140 Button "_Liberar"  Size 50,15 Action Liberar()
@ 262,210 Button "_Sair"     Size 50,15 Action oDLG1:End()
Activate Dialog oDLG1 Centered On Init InitDlg() Valid Sair()

ITE->( DbCloseArea() )
CAB->( DbCloseArea() )

Ferase( cArqTmp+".dbf")
Ferase( cArqTmp+".cdx")
Return NIL

******************
static function InitDlg()
******************

//MbrIdxCol(2,oBrw1:oBrowse)
Itens()

return nil

***************
Static Function Cabec()
***************

Local cQuery
Local nSeq 	  := 1
Local cULT 	  := maxPrio()
Local cVIP    := '0050'
Local aABC    := {}
Local cCliVip := ""

//cQuery := "select '   ' AS SVIP, SC5.C5_PRIORES,PRIOX = CAST('' AS CHAR(3) ), ( case when ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) IS NOT NULL then '" + cMARCA + "' ELSE '  ' END ) AS MARCA,"
cQuery := "select SC5.C5_NUMPAI, SC5.C5_DESC1 AS XDD, SC5.C5_PRIORES AS SVIP, PRIOX = CAST('' AS CHAR(3) ), ( case when ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLEST = '  ' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) IS NOT NULL then '" + cMARCA + "' ELSE '  ' END ) AS MARCA,"
cQuery += "SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,( case when SC5.C5_TIPO IN ( 'D', 'B' ) then ( Select SA2.A2_NOME from " + retsqlname( "SA2" ) + " SA2 where SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA2.A2_COD + SA2.A2_LOJA and SA2.A2_FILIAL = '" + xfilial( "SA2" ) + "' and SA2.D_E_L_E_T_ = ' ' ) "
cQuery += "else ( Select SA1.A1_NOME from " + retsqlname( "SA1" ) + " SA1 where SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA and SA1.A1_FILIAL = '" + xfilial( "SA1" ) + "' and SA1.D_E_L_E_T_ = ' ' ) end ) AS NOME,"
cQuery += "SC5.C5_VEND1,SA3.A3_NREDUZ,SC5.C5_PRIOR,SC5.C5_EMISSAO,SC5.C5_ENTREG,SC5.C5_OBS,C5_TRANSP "
cQuery += "from " + retsqlname("SC5") + " SC5," + retsqlname( "SA3" ) + " SA3 "
cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
//cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ' ,'04') and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC5.C5_VEND1 = SA3.A3_COD "
cQuery += "and ( C5_NOTA = '' Or C5_LIBEROK <> 'E' And C5_BLQ <> '' ) "
cQuery += "and SC5.C5_FILIAL = '" + xfilial( "SC5" ) + "' and SA3.A3_FILIAL = '" + xfilial( "SA3" ) + "' "
cQuery += "and SC5.D_E_L_E_T_ = ' ' and SA3.D_E_L_E_T_ = ' ' " 

//cQuery += " and SC5.C5_NUM = 'Z99999' " //TESTE

cQuery += "order by SC5.C5_PRIORES, SC5.C5_ENTREG "
//cQuery += "order by SVIP, SC5.C5_ENTREG "

MemoWrite("C:\TEMP\CABEC.SQL", cQuery )

TCQUERY cQuery NEW ALIAS "CAB"
TCSetField( 'CAB', "C5_EMISSAO", "D", 8, 0 )
TCSetField( 'CAB', "C5_ENTREG",  "D", 8, 0 )

cARQTMP := CriaTrab( , .F. )
Copy To ( cARQTMP )
CAB->( DbCloseArea() )
DbUseArea( .T.,, cARQTMP, "CAB", .F., .F. )
Index On SVIP+PRIOX To &cARQTMP
CAB->(DbGotop())

DbSelectArea("SC5")
DbSetOrder(1)

U_ABC50(@aABC,@cCliVip)

while !CAB->(EOF())
  
	_nX := Ascan(aABC, {|x| x[2] == CAB->C5_CLIENTE})
	if _nX > 0
		CAB->SVIP := StrZero(aABC[_nX,1],4)
	else
		if empty( CAB->SVIP ) .or. upper( CAB->SVIP ) == "ZZZZ"
			if val(cULT) <= 50
				CAB->SVIP := cVIP := soma1(cVIP)
			else
				CAB->SVIP := cULT := soma1(cULT)
			endIf
		/*else//Caso um dia seja necessario reordenar
			cVIP := soma1(cVIP)			
			if CAB->SVIP != cVIP
				CAB->SVIP := cVIP// := soma1(cVIP)			
			endIF*/
		endIf				
		//CAB->SVIP := cVIP := soma1(cVIP)
   endif
    xDD := CAB->XDD
	SC5->(DbSeek(xFilial("SC5")+CAB->C5_NUM) )	
	RecLock("SC5",.F.)
	if !Empty(SC5->C5_PRIORES)
		if SC5->C5_PRIORES # CAB->SVIP
			SC5->C5_PRIORES := CAB->SVIP
		endif
	else
		SC5->C5_PRIORES := CAB->SVIP
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
nPeso  := 0
nValor :=0
nValor2:=0
nSaldo :=0
nSaldo2:= 0
cQuery := " select SC6.C6_LOCAL AS LOCALI,SC6.C6_ITEM AS ITEM,SC6.C6_PRODUTO AS PRODUTO,SB1.B1_DESC AS DESCRICAO, SB1.B1_LE " + CHR(13) + CHR(10)
cQuery += " ,XDD = (SELECT SC5.C5_DESC1 FROM " + RetSqlName("SC5") + " SC5 WHERE SC5.C5_NUM = '" + CAB->C5_NUM + "' " + CHR(13) + CHR(10)
cQuery += " AND SC5.C5_FILIAL = '" + Alltrim(xFilial("SC5")) + "' AND SC5.C5_NUM = SC6.C6_NUM AND SC5.D_E_L_E_T_ = '' )  "  + CHR(13) + CHR(10)

cQuery += " ,SC6.C6_QTDVEN AS QTDPED,SC6.C6_QTDENT AS QTDFAT, SC6.C6_TES AS TES,SC6.C6_PRCVEN AS PRECO, SC6.C6_PRUNIT AS PRECOCHEIO, " + CHR(13) + CHR(10)
cQuery += " ( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLEST = '  ' " + CHR(13) + CHR(10)
cQuery += " and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS QTDLIB, " + CHR(13) + CHR(10)
cQuery += " SC6.C6_QTDRESE AS RESERVA, " + CHR(13) + CHR(10)
cQuery += "( select sum( SC9.C9_QTDLIB ) from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM and SC9.C9_BLCRED = '09' " + CHR(13) + CHR(10)
cQuery += " and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) AS QTDREJ, " + CHR(13) + CHR(10)
cQuery += " 0 AS ESTOQUE,0 AS ALIBERAR " + CHR(13) + CHR(10)
cQuery += " from " + retsqlname("SC6") + " SC6," + retsqlname("SB1") + " SB1 " + CHR(13) + CHR(10)
cQuery += " where SC6.C6_NUM = '" + CAB->C5_NUM + "' and SC6.C6_PRODUTO = SB1.B1_COD " + CHR(13) + CHR(10)
cQuery += " and SC6.C6_NUM IN ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM " + CHR(13) + CHR(10)
cQuery += " and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) " + CHR(13) + CHR(10)
// NOVA LIBERACAO DE CRETIDO
//cQuery += " and SC9.C9_BLCRED IN ( '  ','99' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
//cQuery += "and SC6.C6_QTDVEN > SC6.C6_QTDENT "
cQuery += " and SC6.C6_FILIAL = '" + xfilial("SC6") + "' and SC6.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)
cQuery += " and SB1.B1_FILIAL = '" + xfilial("SB1") + "' and SB1.D_E_L_E_T_ = ' ' " + CHR(13) + CHR(10)

//cQuery += " and SC6.C6_NUM = 'Z99999' " //TESTE

cQuery += " order by SC6.C6_ITEM "
Memowrite("C:\Temp\itens.SQL", cQuery )

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
	ITE->LOCALI     := TMP->LOCALI
	ITE->DESCRICAO := TMP->DESCRICAO
	ITE->QTDPED    := TMP->QTDPED
	ITE->QTDFAT    := TMP->QTDFAT
	ITE->QTDLIB    := TMP->QTDLIB//ldescRes
	ITE->ESTOQUE   := U_SALDOEST( ITE->PRODUTO, ITE->LOCALI ) - iif( ldescRes, 0, SALDORES( ITE->PRODUTO ) )
	ITE->ALIBERAR  := TMP->ALIBERAR
	ITE->QTDREJ    := TMP->QTDREJ
	ITE->TES       := TMP->TES
//  ITE->RESERVA   := SALDORES( TMP->PRODUTO ) //TMP->RESERVA alterei para ele considerar reservado produto original e o generico
	ITE->RESERVA   := TMP->RESERVA
	ITE->SEGRE     := IIF(TMP->B1_LE > 1 , "X","")
	nPeso += ITE->QTDPED / posicione("SB1",1, xFilial("SB1") + ITE->PRODUTO, "B1_CONV" )
	nValor+=(TMP->QTDPED*TMP->PRECO)
	nSaldo+=( ( TMP->QTDPED - TMP->QTDFAT ) * TMP->PRECO )
	
	If TMP->XDD > 0
		nValor2+=(TMP->QTDPED*TMP->PRECOCHEIO)
		nSaldo2+=( ( TMP->QTDPED - TMP->QTDFAT ) * TMP->PRECOCHEIO )
	Else
		nValor2 := ""
		nSaldo2 := ""
	Endif
	
	TMP->( DbSkip() )
End

//TMP->( DbEval( {|| ITE->( DbAppend() ), Aeval( DbStruct(), { |X| ITE->( Fieldput( FieldPos( X[ 1 ] ), TMP->( FieldGet( FieldPos( X[ 1 ] ) ) ) ) ) } ) } ) )
TMP->( DbCloseArea() )
ITE->( DbGotop() )
oBRW2:oBrowse:Refresh()
ObjectMethod( oPDTDESC,  "SetText( Left( ITE->PRODUTO, 9 ) + '  -  ' + AllTrim( ITE->DESCRICAO ) )" )
ObjectMethod(  oDTPROG,  "SetText( AllTrim( Dtoc( CAB->C5_ENTREG ) ) )" )
ObjectMethod(    oOBS1,  "SetText( Left( CAB->C5_OBS, 65 ) )" )
ObjectMethod(    oOBS2,  "SetText( SubStr( CAB->C5_OBS, 66, 65 ) )" )
ObjectMethod(   oNPESO,  "SetText( transform(nPeso, '@E 9999,999,999.99' ) )" )//transform(nPeso, "@E 999.999.999,99" )
ObjectMethod(   oNVALOR, "SetText( transform(nValor*1.15, '@E 9999,999,999.99' ) )" )
ObjectMethod(   oNSALDO, "SetText( transform(nSaldo*1.15, '@E 9999,999,999.99' ) )" )

If !Empty(nValor2)
	ObjectMethod(   oNVALOR2, "SetText( transform(nValor2*1.15, '@E 9999,999,999.99' ) )" )
	ObjectMethod(   oNSALDO2, "SetText( transform(nSaldo2 * 1.15, '@E 9999,999,999.99' ) )" )
Else 
	ObjectMethod(   oNSALDO2, "SetText( nSaldo2 )")
	ObjectMethod(   oNVALOR2, "SetText( nValor2 )")
Endif

objectMethod(   oSay102, "SetText( posicione('SA1', 1, xFilial('SA1') + CAB->C5_CLIENTE + CAB->C5_LOJACLI, 'A1_EST') )"	 )
objectMethod(   oSayNatu2, "SetText( posicione('SF4', 1, xFilial('SF4') + ITE->TES, 'F4_TEXTO') )"	 )
DbSelectArea("SC5")
SC5->( dbSetOrder(1) )
SC5->( dbSeek( xFilial('SC5') + CAB->C5_NUM ) )
DbSelectArea("SA4")
SA4->( dbSetOrder(1) )
SA4->( dbSeek( xFilial('SA4') + SC5->C5_TRANSP ) )
objectMethod(   oNTRANP1, "SetText( SA4->A4_NOME )"	 )
Return NIL                   


***************
Static Function Liberar()
***************
lOCAL lValidaBonif := .T.
Local cTempo:=Left( Time(), 5 )
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
			If Empty( SC9->C9_BLCRED ) .and. ! Empty( SC9->C9_BLEST ) .and. SC9->C9_BLEST <> "10"  // Acha primeira ocorrencia do produto
              // NOVA LIBERACAO DE CRETIDO 
              //If (Empty( SC9->C9_BLCRED ) .OR. SC9->C9_BLCRED='99' ).and. ! Empty( SC9->C9_BLEST ) .and. SC9->C9_BLEST <> "10"  // Acha primeira ocorrencia do produto			
				Exit                                                                                // com bloqueio de estoque
			Endif
			SC9->( DbSkip() )
		EndDo
		// VALIDA BONIFICACAO
		SC6->( DbSeek( xFILIAL( "SC6" ) + CAB->C5_NUM + ITE->ITEM + ITE->PRODUTO ) )
		If SC6->C6_CF $ "5910/6910"
			lValidaBonif := fValBon(xFILIAL( "SC6" ) + CAB->C5_NUMPAI)
		EndIf
		If !lValidaBonif
			MsgAlert("PEDIDO PAI DA BONIFICAÇÃO NAO FATURADO TOTALMENTE!")
		Else
			
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
					// NOVA LIBERACAO DE CRETIDO 2 ENTROU EM DESUSO
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
			    // DATA E HORA DA LIBERACAO DE ESTOQUE
	              RecLock( "SC9", .F. )
	              SC9->C9_DTBLEST := dDataBase        //data
	              SC9->C9_HRBLEST := cTempo           //hora
	              SC9->C9_USRLBES := Substr(cUsuario, 7 , 15 ) //usuário
	  			  MsUnLock()
	            //
			EndIf
		EndIf
	Endif
	ITE->( DbSkip() )
EndDo

MsgInfo( "Foi(foram) liberado(s) " + AllTrim( Str( nCONT, 2 ) ) + " item(ns)", "Concluido" )
ITE->( DbGotop() )
oBRW1:oBrowse:Refresh()
oBRW2:oBrowse:Refresh()
Return NIL


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fValBon   º Autor ³ Gustavo Costa     º Data ³  06/03/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna o valor dos pedidos bonificados no período do clienteº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fValBon(cFilNum)

local cQry		:= ''
Local lRet		:= .T.

cQry:=" SELECT SUM(C6_QTDVEN - C6_QTDENT) QUANT FROM SC6020 SC6 WITH (NOLOCK) "  
cQry+=" WHERE  D_E_L_E_T_ <> '*' "
cQry+=" AND C6_FILIAL + C6_NUM = '" + cFilNum + "' "
		
TCQUERY cQry NEW ALIAS  "XBN"

dbSelectArea("XBN")
XBN->(dbGoTop())

If Select("XBN") > 0

	If XBN->QUANT > 0
		lRet := .F.
	EndIf
	
EndIf

XBN->(dbclosearea())

Return lRet

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
Local lValidaBonif := .T.
Private nQTD := ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB
// VALIDA BONIFICACAO
SC6->( DbSeek( xFILIAL( "SC6" ) + CAB->C5_NUM + ITE->ITEM + ITE->PRODUTO ) )
If Alltrim(SC6->C6_CF) $ "5910/6910"
	lValidaBonif := fValBon(xFILIAL( "SC6" ) + CAB->C5_NUMPAI)
EndIf
If !lValidaBonif
	MsgAlert("PEDIDO PAI DA BONIFICAÇÃO NAO FATURADO TOTALMENTE!")
	Return NIL
EndIf

@ 000,000 TO 90,250 Dialog oDLG2 Title "Quantidade a liberar"
@ 011,020 Say "Quantidade:"
@ 010,050 Get nQTD Size 40,40 Picture "@E 999,999.999" Valid Quant() .AND. FatParc() .and. U_VldQuant()
@ 030,040 BMPButton Type 01 Action ( ITE->ALIBERAR := nQTD, oBRW2:oBrowse:Refresh(), Close( oDLG2 ) )
@ 030,080 BMPButton Type 02 Action Close( oDLG2 )
Activate Dialog oDLG2 Centered

Return NIL





***************
Static Function QtdRes()
***************

Local cUfCli:=''

Private nQTD := ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB

SC6->( DbSetOrder( 1 ) )
SC6->( DbSeek( xFILIAL( "SC6" ) + CAB->C5_NUM + ITE->ITEM + ITE->PRODUTO ) )


if MsgBox( "A Reserva e Cross-Docking ?", "Escolha", "YESNO" )    
    cUfCli:=alltrim(posicione('SA1', 1, xFilial('SA1') + CAB->C5_CLIENTE + CAB->C5_LOJACLI, 'A1_EST'))  
    If  ALLTRIM(getReg(cUfCli)) $'SL/SD' .AND.  ITE->ESTOQUE<0 // regiao sul e sudaeste  
        ALERT('Nao e permitido Cross-Docking para regiao Sul e Sudeste com Estoque Virtual negativo ' )
        Return NIL
    ELSE 
        RecLock( "SC6", .F. )
        SC6->C6_CROSSDO:="S"
        MsUnLock()               
    ENDIF
endif

RecLock( "SC6", .F. )
if SC6->C6_QTDRESE > 0
	if MsgBox( "O Item selecionado já esta reservado. Deseja CANCELAR RESERVA ?", "Escolha", "YESNO" )
		IF ALLTRIM(SC6->C6_CROSSDO)=="S"
		   If u_senha2("16",1)[1] // RENATO MAIA, GLENNYSON
		      ITE->ESTOQUE    += ITE->RESERVA
		      ITE->RESERVA    := 0
		      SC6->C6_QTDRESE := ITE->RESERVA
	          SC6->C6_CROSSDO:=" "
	       EndIF
	    ELSE
	       ITE->ESTOQUE    += ITE->RESERVA
		   ITE->RESERVA    := 0
		   SC6->C6_QTDRESE := ITE->RESERVA
	    ENDIF
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

private cPrio := CAB->SVIP//CAB->PRIOR
if val( CAB->SVIP ) <= 0//val( CAB->SVIP ) < 50
	//Aviso("Aviso","Você só pode furar a fila dos NÃO VIPS.",{"OK"})
	Aviso("Aviso","Você só pode furar a fila até a primeira posição.",{"OK"})
	return
endIf
//if nOrdG = 2
   @ 000,000 TO 90,250 Dialog oDLG2 Title "Prioridade"
   @ 011,020 Say "Posição:"
   @ 010,050 Get cPrio Size 40,40 Picture "@R 9999"
   @ 030,040 BMPButton Type 01 Action ( MudaFila(), oBRW2:oBrowse:Refresh(), Close( oDLG2 ) )
   @ 030,080 BMPButton Type 02 Action Close( oDLG2 )
   Activate Dialog oDLG2 Centered
/*else
   Aviso("Aviso","Ordene por Prioridade de Reserva antes de Furar a Fila.",{"OK"})
endif*/

Return NIL


***************
Static Function MudaFila()
***************
Local nRec   := CAB->(RecNo())
Local cPrioN := StrZero( Val(cPrio), 4 )
Local cPrioO := CAB->SVIP
if val(cPrio) <= 0//val(cPrio) < 51
	//Aviso("Aviso","Você não pode passar da posição 50!",{"OK"})
	Aviso("Aviso","Você não pode passar da posição 1!",{"OK"})
	return
endIf
if Val(cPrio) > 0

	SC5->(DbSeek(xFilial("SC5")+CAB->C5_NUM) )
	RecLock("SC5",.F.)
    
    /**/
	CAB->( DbSeek( cPrioN ) )
	if CAB->( EoF() )
		CAB->( DbSeek( cPrioO ) )
		CAB->SVIP := cPrioN
		SC5->C5_PRIORES := cPrioN	
		MSUnlock()
		CAB->( DbGoTo(nRec) )
		Itens()
		Return
	endIf
	CAB->( DbSeek( cPrioO ) )
	/**/
    		
	if cPrioO < cPrioN
		CAB->PRIOX := cPrioN
		CAB->SVIP  := cPrioN
		SC5->C5_PRIORES := cPrioN
	else
		CAB->( DbSeek( cPrioN ) )
		CAB->PRIOX := CAB->SVIP

		CAB->( DbSeek( cPrioO ) )
		CAB->SVIP := cPrioN
		SC5->C5_PRIORES := cPrioN
	endif
	MSUnlock()

	CAB->( DbSeek( cPrioO+"   " ,.T. ) )
	if cPrioO < cPrioN
		while !CAB->(EOF())
			if !Empty(CAB->PRIOX)
				CAB->PRIOX := ''
				exit
			endif
			CAB->SVIP := StrZero(Val(CAB->SVIP)-1,4)
			
			SC5->(DbSeek(xFilial("SC5")+CAB->C5_NUM) )
			RecLock("SC5",.F.)
			SC5->C5_PRIORES := CAB->SVIP
			MsUnLock()
			CAB->(DbSkip())
		end
	else
		CAB->(DbSkip(-1))
		while !CAB->(BOF())
			CAB->SVIP := soma1(CAB->SVIP)
			
			SC5->(DbSeek(xFilial("SC5")+CAB->C5_NUM) )
			RecLock("SC5",.F.)
			SC5->C5_PRIORES := CAB->SVIP
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
Local nReserv := iif( ldescRes, 0, ITE->RESERVA )
Local lLib    := .T.

	If FWCodFil() == "07"
		//if nQTD < 0 .or. nQTD > Min( ITE->ESTOQUE + ITE->RESERVA, ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB - ITE->QTDREJ )
		if nQTD < 0 .or. nQTD > Min( ITE->ESTOQUE + nReserv, ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB - ITE->QTDREJ )
			if nQTD > (ITE->ESTOQUE + nReserv)
				MsgBox( "Estoque insuficiente para essa quantidade", "info", "stop" )
				// nao libera mas com senha    
				lLib := u_senha2( "15", 4 )[ 1 ] //MARCELO, JORGE
				//lLib := u_senha2( "28", 4 )[ 1 ] //TESTE FLAVIA
				/*
				If lLib
					MsgInfo("Liberado Estoque Insuficiente")
				Endif
				*/
				Return lLib
				
			elseif nQTD > ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB - ITE->QTDREJ
				MsgBox( "Quantidade superior ao saldo a liberar", "info", "stop" )
				Return .F.
			else
				Return .F.
			endif
		endIf
	EndIf
	
Return lLib



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
		cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + "D" + Subs( cPROD1, 2, If( Subs( cPROD1, 4, 1 ) $ "R/D", 4, 3 ) ) + "6" + Subs( cPROD1, If( Subs( cPROD1, 4, 1 ) $ "R/D", 6, 5 ), 2 ), 15 )
	else
		cPROD2 := Padr( Subs( cPROD1, 1, 1 ) + Subs( cPROD1, 3, If( Subs( cPROD1, 5, 1 ) $ "R/D", 4, 3 ) ) + Subs( cPROD1, If( Subs( cPROD1, 5, 1 ) $ "R/D", 8, 7 ), 2 ), 15 )
	endif
	
	cQuery := "select sum( C6_QTDRESE ) AS RESERVA "
	cQuery += "from " + retsqlname("SC6") + " SC6, "+ retsqlname("SC5") + " SC5 "
	cQuery += "where C6_PRODUTO IN( '"+cProd1+"', '"+cProd2+"' ) and "
	cQuery += "C6_NUM = C5_NUM AND C5_PRIORES <= '"+CAB->SVIP+"' AND "
	cQuery += "C6_QTDENT < C6_QTDVEN AND C6_QTDRESE > 0 AND C6_FILIAL = '" + xfilial("SC6") + "' and "
	cQuery += "C6_BLQ <> 'R' AND "
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
Local cGet := Space(6) //Space(3)
Local cGet2 := Space(8) //Space(3)

oDlg1      := MSDialog():New( 139,340,384,777,"Transportadora",,,,,,,,,.T.,,, )
oSay3      := TSay():New( 029,016,{||"Nome :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,011)
oSay4      := TSay():New( 029,064,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,011)
oSay5      := TSay():New( 047,016,{||"Destino :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 047,064,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,108,008)
oSay1      := TSay():New( 012,016,{||"Código :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,012)
oSay2      := TSay():New( 012,064,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,065,012)
oGrp1      := TGroup():New( 003,004,115,212,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGrp2      := TGroup():New( 066,030,070,186,"",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oGet1      := TGet():New( 079,045,{|u| If(PCount()>0,cGet:=u,cGet)},oGrp1,060,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA4","cGet",,)
oGet2      := TGet():New( 079,115,{|u| If(PCount()>0,cGet2:=u,cGet2)},oGrp1,060,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"DA3","cGet2",,)

oGet1:bValid := {||NaoVazio() }

oSBtn1     := SButton():New( 095,076,1,{ || storeTrn( cGet, cGet2 ), oDlg1:End() },oGrp1,,"", )
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
objectMethod(   oNTRANP1, "SetText( SA4->A4_NOME )"	 ) 
objectMethod( oNTRANP1,"Refresh()")


oGet1:bValid  := { || ExistCpo("SA4",cGet) }
oGet2:bValid  := { || ExistCpo("DA3",cGet2) }
                      /*,{ || objectMethod( oSay4,"SetText(SA4->A4_NREDUZ)"),;
					  objectMethod( oSay4,"Refresh()"),objectMethod( oSay2,"SetText(SA4->A4_COD)"),;
				      objectMethod( oSay2,"Refresh()") }, ) }*/

oGet1:bChange := { || objectMethod( oSay4,"SetText(SA4->A4_NREDUZ)"),;
					  objectMethod( oSay4,"Refresh()"),;
				      objectMethod( oSay2,"SetText(SA4->A4_COD)"),;
				      objectMethod( oSay2,"Refresh()") }
oDlg1:Activate(,,,.T.)

Return {|| SC5->( dbGoTo( nReg ) ), SC5->( dbSetOrder( nOrder ) ), objectMethod(   oNTRANP1, "SetText( SA4->A4_NOME )"	 ) ,objectMethod( oNTRANP1,"Refresh()") }



***************
Static Function storeTrn( cTrn, cVeic )
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
	   SC5->C5_VEICULO := cVeic
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

   	lOk := .T.
//   lOk := .F.
   
//	msgAlert( " O Pedido Totaliza R$:" + Transform( nTotal , "@E 999,999,999.99" ) + CHR(13) + CHR(10) ;
//	+ " Não Atingiu o Valor Mínimo de: R$ " + Transform( nPedMIN , "@E 999,999,999.99") + " Para a Região: " + cNomeReg ) //+ CHR(13) + CHR(10);
Else
   	lOk := .T.
endif   

return lOk
 



***************

Static Function maxPrio()

***************
local cMax := cQuery := ''

cQuery += "select max(SC5.C5_PRIORES) maximo "
cQuery += "from "+retSqlName('SC5')+" SC5, "+retSqlName('SA3')+" SA3 "
cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from SC9020 SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '01' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
//cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from SC9020 SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ','99' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '01' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC5.C5_VEND1 = SA3.A3_COD "
cQuery += "and ( C5_NOTA = '' Or C5_LIBEROK <> 'E' And C5_BLQ <> '' ) "
cQuery += "and SC5.C5_FILIAL = '01' and SA3.A3_FILIAL = '  ' "
cQuery += "and SC5.D_E_L_E_T_ = ' ' and SA3.D_E_L_E_T_ = ' ' "
TCQUERY cQuery NEW ALIAS 'TMP'

TMP->( dbGoTop() )
cMax := TMP->maximo
TMP->( dbCloseArea() )

return cMax

***************

Static Function sortDate()

***************

Local cQuery  := ''
Local cVIP    := '0050'
Local aABC    := {}
Local cCliVip := ""

cQuery := "select SC5.C5_PRIORES,SC5.C5_NUM "
cQuery += "from " + retsqlname("SC5") + " SC5," + retsqlname( "SA3" ) + " SA3 "
cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
// NOVA LIBERACAO DE CRETIDO
//cQuery += "where SC5.C5_NUM in ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLCRED IN ( '  ','99' ) and SC9.C9_BLEST <> '10' and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC5.C5_VEND1 = SA3.A3_COD and SC5.C5_PRIORES > '0050' "
cQuery += "and ( C5_NOTA = '' Or C5_LIBEROK <> 'E' And C5_BLQ <> '' ) "
cQuery += "and SC5.C5_FILIAL = '" + xfilial( "SC5" ) + "' and SA3.A3_FILIAL = '" + xfilial( "SA3" ) + "' "
cQuery += "and SC5.D_E_L_E_T_ = ' ' and SA3.D_E_L_E_T_ = ' ' "
cQuery += "order by SC5.C5_ENTREG "
TCQUERY cQuery NEW ALIAS "TMPX"
TMPX->( dbGoTop() )

DbSelectArea("SC5")
DbSetOrder(1)

do while !TMPX->( EoF() )
   
	SC5->( DbSeek( xFilial("SC5") + TMPX->C5_NUM, .F. ) )
	RecLock("SC5",.F.)
	SC5->C5_PRIORES := cVIP := soma1(cVIP)
  	MsUnlock()
	TMPX->( DbSkip() )
	
endDo
CAB->( __dbZap() );CAB->( dbCloseArea() )
cabec()
TMPX->( DbCloseArea() )

return

***************
Static Function Pesquisar()
***************
Local cPedido:=space(6)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg2","oGet1","oBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg2      := MSDialog():New( 244,330,319,494,"Pedido",,,.F.,,,,,,.T.,,,.F. )
oGet1      := TGet():New( 006,009,,oDlg2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPedido",,)
oGet1:bSetGet := {|u| If(PCount()>0,cPedido:=u,cPedido)}
oBtn1      := TButton():New( 019,020,"Ok",oDlg2,,037,012,,,,.T.,,"",,,,.F. )
oBtn1:bAction := {||getpedido(cPedido)}


oDlg2:Activate(,,,.T.)


Return

***************

Static Function getpedido(cPedido)

***************
Local nrec:= CAB->(RECNO())

dbselectarea("CAB")

LOCATE FOR CAB->C5_NUM=cPedido

If !CAB->(FOUND()) // Retorna: .T.
   alert("Pedido Não Encontrado!!!!")
   CAB->(DBGOTO(nrec))
   oDlg2:END()
   Return 
EndIf

ITENS()

oDlg2:END()

Return

***************

Static Function descRes()

***************
	if ldescRes
		ldescRes := .F.
		oBtn60:cCaption  := 'descons. reserva'
		Itens()
	else
		ldescRes := .T.
		oBtn60:cCaption  := 'conside. reserva'
		Itens()
	endIf			
Return

/***************

Static Function getEst()

***************
Local nReg   := SC5->( recno() )
Local nOrder := retIndex("SC5") 
Local cEst   := ""
SC5->( dbSetOrder(1) )
SC5->( dbSeek( xFilial('SC5') + CAB->C5_NUM ) )

cEst := posicione('SA1', 1, xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJAENT, 'A1_EST') 

SC5->( dbGoTo( nReg ) )
SC5->( dbSetOrder( nOrder ) )

Return cEst*/


***************
Static Function atualiza()
***************
ObjectMethod( oPDTDESC, "SetText( Left( ITE->PRODUTO, 9 ) + '  -  ' + AllTrim( ITE->DESCRICAO ) )" )
objectMethod(   oSayNatu2, "SetText( posicione('SF4', 1, xFilial('SF4') + ITE->TES, 'F4_TEXTO') )"	)
Return


***************

Static Function getReg(cUF)

***************

Local cRGNO := "AC AM AP PA RO RR TO"
Local cRGNE := "MA PI CE RN PB PE AL BA SE"
Local cRGCE := "GO MT MS DF"
Local cRGSD := "MG ES RJ SP"
Local cRGSL := "RS PR SC"

if cUF $ cRGNO
	return "NO"
elseIf cUF $ cRGNE
	return "NE"
elseIf cUF $ cRGCE
	return "CE"
elseIf cUF $ cRGSD
	return "SD"	
elseIf cUF $ cRGSL
	return "SL"				
endIf	
   
Return 


***************

Static Function FatParc()

***************
local nQtdLib:=ITE->QTDPED - ITE->QTDFAT - ITE->QTDLIB

If nQTD < nQtdLib
   MsgBox( "Faturamento Parcial, saldo de Faturamento "+ alltrim(str(nQtdLib-nQTD)), "info", "stop" )
   Return U_senha2( "16", 4 )[ 1 ]  //RENATO MAIA, GLENNYSON
   //Return U_senha2( "28", 4 )[ 1 ]  //TESTE FLAVIA
   
Endif 


Return .T.


***************

Static Function Pedido()

***************

DbSelectArea("SC5")
DbSetOrder(1)
   
If SC5->(DbSeek(xFilial("SC5")+CAB->C5_NUM,.F.))
      
   Private aRotina := {{"Pesquisar" , "AxPesqui"   , 0, 1},;
                          {"Visualizar", "A410Visual", 0, 2}}
                          
   A410Visual("SC5", SC5->(Recno()), 1)
Else
   alert("Esse nao e um Pedido "+CAB->C5_NUM+" Valido")
EndIf


Return 

****************************
Static Function fVerPV(cPV, obj) 
****************************

Local lMostra := .F.

SC5->(Dbsetorder(1))
If SC5->(Dbseek(xFilial("SC5") + cPV ))
	If SC5->C5_DESC1 > 0
		lMostra := .T.
		objectMethod( &obj,"Refresh()")
	Endif
Endif

Return lMostra
