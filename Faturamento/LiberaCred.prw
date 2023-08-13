#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "font.ch"
#include "colors.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³LIBERACRED³  Autor ³ Mauricio Barros      ³ Data ³28/07/2006³±±
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

User Function LIBERACRED()

*************

SetPrvt( "cMARCA,nTOTPED,oTOTPED,nTOTLIB,oTOTLIB" )

nTOTPED := nTOTLIB := 0

cMARCA := GetMark()

DEFINE FONT oFont NAME "Arial" SIZE 6, 15 BOLD

MsAguarde( {|| Cabec() }, OemToAnsi( "Aguarde" ), OemToAnsi( "Lendo pedidos da carteira..." ) )

@ 000,000 TO 512,795 Dialog oDLG1 Title "Liberacao do credito para faturamento"

oBRW1 := MsSelect():New(   "CAB", "MARCA",, ;
                        {{ "MARCA"     ,, " " }, ;
                         { "C5_NUM"     ,, OemToAnsi( "Pedido") }, ;
                         { "C5_EMISSAO" ,, OemToAnsi( "Data") }, ;
                         { "C5_CLIENTE" ,, OemToAnsi( "Cliente") }, ;
                         { "C5_LOJACLI" ,, OemToAnsi( "Loja") }, ;
                         { "( Left( A1_NOME, 30 ) )",, OemToAnsi( "Nome do cliente") }, ;
                         { "C5_VEND1"   ,, OemToAnsi( "Vendedor") }, ;
                         { "A3_NREDUZ"  ,, OemToAnsi( "Nome do vendedor") }, ;
                         { "( If( C5_PRIOR == 'P', 'Programado', If( C5_PRIOR == 'L', 'Licitacao', If( C5_PRIOR == 'T', 'Cliente TOP', '' ) ) ) )",, OemToAnsi( "Prioridade") }},, ;
                           cMARCA, { 005, 000, 215, 397 } )

oBRW1:oBrowse:lhasMark    := .F.
oBRW1:oBrowse:lCanAllmark := .F.
oBRW1:oBROWSE:bCHANGE     := { || ValPedido() }

oSay1 := TSAY():Create(oDlg1)
oSay1:cName := "oSay1"
oSay1:cCaption := "Total do pedido:"
oSay1:nLeft := 005
oSay1:nTop := 445
oSay1:nWidth := 136
oSay1:nHeight := 17
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oTOTPED := TSAY():Create(oDlg1)
oTOTPED:cName := "oTOTPED"
oTOTPED:cCaption := Trans( nTOTPED, "@E 999,999.99" )
oTOTPED:nLeft := 105
oTOTPED:nTop := 445
oTOTPED:nWidth := 72
oTOTPED:nHeight := 21
oTOTPED:lShowHint := .F.
oTOTPED:lReadOnly := .F.
oTOTPED:Align := 0
oTOTPED:lVisibleControl := .T.
oTOTPED:lWordWrap := .F.
oTOTPED:lTransparent := .F.
oTOTPED:SetFont( oFont )
oTOTPED:nCLRTEXT := CLR_BLUE

oSay2 := TSAY():Create(oDlg1)
oSay2:cName := "oSay2"
oSay2:cCaption := "Valor a liberar:"
oSay2:nLeft := 205
oSay2:nTop := 445
oSay2:nWidth := 136
oSay2:nHeight := 17
oSay2:lShowHint := .F.
oSay2:lReadOnly := .F.
oSay2:Align := 0
oSay2:lVisibleControl := .T.
oSay2:lWordWrap := .F.
oSay2:lTransparent := .F.

oTOTLIB := TSAY():Create(oDlg1)
oTOTLIB:cName := "oTOTLIB"
oTOTLIB:cCaption := Trans( nTOTLIB, "@E 999,999.99" )
oTOTLIB:nLeft := 305
oTOTLIB:nTop := 445
oTOTLIB:nWidth := 72
oTOTLIB:nHeight := 21
oTOTLIB:lShowHint := .F.
oTOTLIB:lReadOnly := .F.
oTOTLIB:Align := 0
oTOTLIB:lVisibleControl := .T.
oTOTLIB:lWordWrap := .F.
oTOTLIB:lTransparent := .F.
oTOTLIB:SetFont( oFont )
oTOTLIB:nCLRTEXT := CLR_BLUE

@ 240,140 Button "_Liberar / Rejeitar" Size 50,15 Action Liberar()
@ 240,210 Button "_Sair" Size 50,15 Action oDLG1:End()
Activate Dialog oDLG1 Centered On Init ValPedido()
CAB->( DbCloseArea() )
Return NIL



***************

Static Function Cabec()

***************

Local cQUERY := ""


cQuery := "select ( case when ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 "
//cQuery += "where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLEST = '  ' and SC9.C9_BLCRED = '  ' and SC9.C9_BLCRED2 IN ( '01', '04', '09' ) "
// NOVA LIBERACAO DE CRETIDO
cQuery += "where SC9.C9_PEDIDO = SC5.C5_NUM and SC9.C9_BLEST = '  ' and SC9.C9_BLCRED IN('  ','04')  "
cQuery += "and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) IS NULL then '" + cMARCA + "' ELSE '  ' END ) AS MARCA,"
cQuery += "SC5.C5_NUM,SC5.C5_CLIENTE,SC5.C5_LOJACLI,SA1.A1_NOME,SC5.C5_VEND1,SA3.A3_NREDUZ,SA3.A3_SUPER, SC5.C5_PRIOR,SC5.C5_EMISSAO "
cQuery += "from " + retsqlname("SC5") + " SC5," 
cQuery += " " + retsqlname("SA1") + " SA1," 
cQuery += " " + retsqlname("SA3") + " SA3 "
cQuery += "where EXISTS ( select top 1 SC9.C9_PEDIDO from " + retsqlname("SC9") + " SC9 where SC9.C9_PEDIDO = SC5.C5_NUM "
//cQuery += " and SC9.C9_DATALIB <= '" + Dtos( dDATABASE ) + "' and SC9.C9_BLEST = '  ' and SC9.C9_BLCRED = '  ' "
cQuery += " and SC9.C9_DATALIB <= '" + Dtos( dDATABASE ) + "' and SC9.C9_BLEST = '  ' and SC9.C9_BLCRED IN( '  ','04') "
cQuery += " and SC9.C9_FILIAL = '" + xfilial("SC9") + "' and SC9.D_E_L_E_T_ = ' ' ) "
cQuery += "and SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA and SC5.C5_VEND1 = SA3.A3_COD "
cQuery += "and SC5.C5_FILIAL = '" + xfilial("SC5") + "' and SA1.A1_FILIAL = '" + xfilial("SA1") + "' and SA3.A3_FILIAL = '" + xfilial("SA3") + "' "
cQuery += "and SC5.D_E_L_E_T_ = ' ' and SA1.D_E_L_E_T_ = ' ' and SA3.D_E_L_E_T_ = ' ' "
cQuery += "order by SC5.C5_NUM "
MemoWrite("C:\Temp\liberacred.sql", cQuery )

cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "CAB"
TCSetField( 'CAB', "C5_EMISSAO", "D", 8, 0 )

cARQTMP := CriaTrab( , .F. )
Copy To ( cARQTMP )
CAB->( DbCloseArea() )
DbUseArea( .T.,, cARQTMP, "CAB", .F., .F. )
Return NIL



***************

Static Function Liberar()

***************
//³          C9_BLCRED: 01 - Bloqueio de Credito por Valor               ³±±
//³                     04 - Vencto do Limite de Credito                 ³±±
//³                     05 - Bloqueio de Credito por Estorno             ³±±
//³                     06 - Bloqueio de Credito por Risco               ³±±
//³                     09 - Rejeicao de Credito                         ³±±
//³                                                                      ³±±
//³          C9_BLEST:  02 - Bloqueio de Estoque                         ³±±
//³                     03 - Bloqueio Manual de Estoque                  ³±±

Local nCONT := 0, ;
      nALIBERAR, ;
      aREG, ;
      nCAMPO, ;
      nREG := 0

Local lContinua := .T.
Local dLimLib   := dDATABASE
Local cTempo:=Left( Time(), 5 )

Private aRotina := { { "Pesquisar", "PesqBrw", 0, 1 },;
                     { "Automatica", "A450LibAut", 0 , 0 },;
                     { "Manual", "A450LibMan", 0, 0 },;
                     { "Legenda", "A450Legend", 0, 3 } }

Private cREJEITA := Space( 30 )

SC9->( DbSetOrder( 1 ) )
SC9->( DbSeek( xFILIAL( "SC9" ) + CAB->C5_NUM, .T. ) )
Do While SC9->C9_PEDIDO == CAB->C5_NUM
   //If Empty( SC9->C9_BLCRED ) .and. Empty( SC9->C9_BLEST ) .and. ! Empty( SC9->C9_BLCRED2 )  // Acha primeira ocorrencia do produto
     // NOVA LIBERACAO DE CRETIDO
     If (Empty( SC9->C9_BLCRED ) .OR. SC9->C9_BLCRED='04' ).and. Empty( SC9->C9_BLEST )   // Acha primeira ocorrencia do produto    
      RecLock( "SC9", .F. )                                                                  // com bloqueio de credito 2
      SC9->C9_BLCRED := "01"
      MsUnLock()
      nREG := SC9->( Recno() )
      Exit
   Endif
   SC9->( DbSkip() )
EndDo
nOPCAO := a450Tela( @lContinua , .T. , .F., @dDATABASE )   // Rotina padrao do siga

If nOPCAO == 3 .or. nOPCAO == 4  // Rejeita ou Libera
   If nOPCAO == 3
      Rejeitado()
   EndIf
   SC9->( DbSeek( xFILIAL( "SC9" ) + CAB->C5_NUM, .T. ) )
   Do While SC9->C9_PEDIDO == CAB->C5_NUM
   //   If ( ( Empty( SC9->C9_BLCRED ) .and. Empty( SC9->C9_BLEST ) ) .or. nREG == SC9->( Recno() ) ) .and. ! Empty( SC9->C9_BLCRED2 )
        // NOVA LIBERACAO DE CRETIDO        
        If ( ( (Empty( SC9->C9_BLCRED ) .OR. SC9->C9_BLCRED='04' ).and. Empty( SC9->C9_BLEST ) ) .or. nREG == SC9->( Recno() ) ) 
         RecLock( "SC9", .F. )
         If nOPCAO == 3
            //SC9->C9_BLCRED2 := "09"
            SC9->C9_BLCRED  := "09"
            SC9->C9_BLEST   := "02"
            SC9->C9_BLINF   := cREJEITA
         Else
            //SC9->C9_BLCRED2 := "  "
         Endif
         // DATA E HORA DA LIBERACAO DE CREDITO
         //  SC9->C9_DTBLCRE := dDataBase
         //  SC9->C9_HRBLCRE := cTempo
         //
         MsUnLock()
         nCONT++
      Endif
      SC9->( DbSkip() )
   EndDo
Endif
If nREG <> 0 .and. nOPCAO <> 3
   SC9->( DbGoto( nREG ) )
   RecLock( "SC9", .F. )
   SC9->C9_BLCRED := "  "
   MsUnLock()
Endif
If nCONT > 0
   CAB->MARCA := cMARCA
   MsgInfo( "Foi(foram) " + If( nOPCAO == 3, "rejeitado(s) ", "liberado(s) " ) + AllTrim( Str( nCONT, 2 ) ) + " item(ns)", "Concluido" )
   oBRW1:oBrowse:Refresh()
	 ValPedido()
	////10/08/2010 - Chamado 001713 - Solicitado o envio por email ao vendedor resp. pelo pedido
	///Faz o envio de email ao vendedor resp. pelo pedido informando a aprovação/reprovação
	
	U_MAIL_LIBCRED( CAB->C5_NUM, CAB->C5_CLIENTE, CAB->C5_LOJACLI, nOPCAO, cRejeita, CAB->A3_SUPER)
Endif
DbSelectArea( "CAB" )
Return NIL



***************

Static Function ValPedido()

***************

Local cQUERY

cQuery := "select ( select Sum( SC6.C6_PRCVEN * SC6.C6_QTDVEN ) from " + retsqlname( "SC6" ) + " SC6 where SC6.C6_NUM = '" + CAB->C5_NUM + "' and SC6.C6_FILIAL = '" + xfilial( "SC6" ) + "' and SC6.D_E_L_E_T_ = ' ' ) AS VALTOT, "
//cQuery += "( select Sum( SC9.C9_QTDLIB * SC9.C9_PRCVEN ) from " + retsqlname( "SC9" ) + " SC9 where SC9.C9_PEDIDO = '" + CAB->C5_NUM + "' and SC9.C9_BLEST = '  ' and SC9.C9_BLCRED = '  ' and SC9.C9_BLCRED2 <> '  ' and SC9.C9_FILIAL = '" + xfilial( "SC9" ) + "' and SC9.D_E_L_E_T_ = ' ' ) AS VALLIB "
// NOVA LIBERACAO DE CRETIDO
cQuery += "( select Sum( SC9.C9_QTDLIB * SC9.C9_PRCVEN ) from " + retsqlname( "SC9" ) + " SC9 where SC9.C9_PEDIDO = '" + CAB->C5_NUM + "' and SC9.C9_BLEST = '  ' and SC9.C9_BLCRED IN( '  ','04')  and SC9.C9_FILIAL = '" + xfilial( "SC9" ) + "' and SC9.D_E_L_E_T_ = ' ' ) AS VALLIB "
cQuery += "from " + retsqlname("SC5") + " SC5 "
cQuery += "where SC5.C5_NUM = '" + CAB->C5_NUM + "' and SC5.C5_FILIAL = '" + xfilial( "SC5" ) + "' and SC5.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "PED"

nTOTPED := PED->VALTOT
nTOTLIB := PED->VALLIB
PED->( DbCloseArea() )
ObjectMethod( oTOTPED, "SetText( Trans( nTOTPED, '@E 999,999.99' ) )" )
ObjectMethod( oTOTLIB, "SetText( Trans( nTOTLIB, '@E 999,999.99' ) )" )
DbSelectArea( "CAB" )
Return NIL



***************

Static Function Rejeitado()

***************

Local oDLG2

@ 000,000 TO 90,250 Dialog oDLG2 Title "Credito rejeitado"
@ 011,005 Say "Motivo:"
@ 010,025 Get cREJEITA Size 90,25
@ 030,050 BMPButton Type 01 Action Close( oDLG2 )
Activate Dialog oDLG2 Centered
Return NIL
                                                    

******************************************************
User Function MAIL_LIBCRED( cNumPed, cCliente, cLoja, nTipo, cMsg, cSuper )
******************************************************

Local aPedido 	:= {}
Local dEmissao	:= Ctod("  /  /    ")
Local _nX    	:= 0
Local cQuery 	:= ""
Local aUsu		:= {} 
Local eEmail	:= ""
Local nTotGer	:= 0
Local cCodUser  := ""	//código do usuário que está logado
Local cUserMail := ""   //irá armazenar o email do usuário logado
Local cVendMail	:= "" 
Local cNomeCliente:= ""

Local cCodUser := ""
Local cMotivo  := ""

////Informações do usuário que está logado...
cCodUser := __CUSERID

PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsu := PSWRET() 						// Retorna vetor com informações do usuário
   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   //cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
   cUserMail := Alltrim( aUsu[1][14] )     
Endif


SetPrvt("OHTML,OPROCESS")


////CRIA O PROCESSO WORKFLOW
oProcess:=TWFProcess():New("LIBERACRED","PC - Aprovado")
oProcess:NewTask('PV Aprov/Reprov',"\workflow\http\oficial\LIBERACRED.html")
oHtml := oProcess:oHtml

DbselectArea("SA1")
If SA1->(Dbseek(xFilial("SA1") + cCliente + cLoja))
	cNomeCliente := Alltrim(SA1->A1_NOME)
Endif

oHtml:ValByName("cPedido", cNumPed )
oHtml:ValByName("cCliente", cCliente )
oHtml:ValByName("cLoja", cLoja )
oHtml:ValByName("cNomeCli", cNomeCliente )



If nTipo <> 3		//APROVAÇÃO

	conout(Replicate("*",60))
	conout("LIBERACRED - PV Aprov - " + Dtoc(Date()) + "-" + Time() + " INICIO")
	conout(Replicate("*",60))
	oHtml:ValByName("cAprov", "Aprovado" )
	oProcess:cSubject:= "Pedido de Venda - Crédito Aprovado"

Else				//REPROVAÇÃO
	conout(Replicate("*",60))
	conout("LIBERACRED - PV Reprov - " + Dtoc(Date()) + "-" + Time() + " INICIO")
	conout(Replicate("*",60))
	oHtml:ValByName("cAprov", "Reprovado" )
	cMotivo := "MOTIVO DA RECUSA: " + cMsg + "."
	oProcess:cSubject:= "Pedido de Venda - Crédito Reprovado"
	
Endif
	
oHtml:ValByName("cMotivo", cMotivo )

//seleciona dados do pedido	
cQuery := " SELECT C5_EMISSAO, C5_ENTREG, C5_NUM, C5_VEND1, C5_CLIENTE, C5_LOJACLI, A1_NREDUZ, "
cQuery += " A3_NREDUZ, A3_EMAIL, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_PRCVEN, C6_VALOR, B1_DESC  "
cQuery += " FROM " + RetSqlname("SC5") + " SC5, " 
cQuery += " " + RetSqlname("SC6") + " SC6, " 
cQuery += " " + RetSqlname("SA1") + " SA1, " 
cQuery += " " + RetSqlname("SA3") + " SA3, " 
cQuery += " " + RetSqlname("SB1") + " SB1 " 
cQuery += " WHERE "
cQuery += " SC5.C5_NUM = '" + cNumPed + "' "
cQuery += " AND SC5.C5_NUM = SC6.C6_NUM "
cQuery += " AND SC5.C5_CLIENTE = SC6.C6_CLI "
cQuery += " AND SC5.C5_LOJACLI = SC6.C6_LOJA "
cQuery += " AND SC5.C5_CLIENTE = SA1.A1_COD "
cQuery += " AND SC5.C5_LOJACLI = SA1.A1_LOJA "
cQuery += " AND SC5.C5_VEND1 = SA3.A3_COD "
cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD "

cQuery += " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = '' "
cQuery += " AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.D_E_L_E_T_ = '' "
cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.D_E_L_E_T_ = '' "
cQuery += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SA3.D_E_L_E_T_ = '' "
cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = '' "
cQuery += " ORDER BY C5_NUM, C6_ITEM "

//Memowrite("C:\Temp\Libcred1.SQL",cQuery) 

If Select("TMPC5") > 0
	DbSelectArea("TMPC5")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TMPC5" 
TCSetField( "TMPC5" , "C5_EMISSAO", "D")
TCSetField( "TMPC5" , "C5_ENTREG", "D")

TMPC5->(DbGoTop())
While TMPC5->(!EOF())
	
	aPedido		:= {}
	dEmissao	:= TMPC5->C5_EMISSAO
	cVendedor	:= TMPC5->A3_NREDUZ 
	dDtFat		:= TMPC5->C5_ENTREG
	cVendMail	:= Alltrim(TMPC5->A3_EMAIL)
	

	nTotGer += TMPC5->C6_VALOR
	
	aadd( aPedido, { TMPC5->C6_ITEM,;  		//1
	      			 TMPC5->C6_PRODUTO,;	//2
	       			 TMPC5->B1_DESC,;   	//3
	   			     TMPC5->C6_QTDVEN,;  	//4
	   			     TMPC5->C6_PRCVEN,;    	//5
	   			     TMPC5->C6_VALOR  } ) 	//6
			
		For _nX := 1 to len(aPedido)
	      
	      aadd( oHtml:ValByName("it.cItem")  , aPedido[_nX,1] )        	//ITEM
	      aadd( oHtml:ValByName("it.cProd")  , aPedido[_nX,2] )      	//COD. PRODUTO
	      aadd( oHtml:ValByName("it.cDesc")  , aPedido[_nX,3] )       	//DESCRIÇÃO PRODUTO
	      aadd( oHtml:ValByName("it.nQtde") , aPedido[_nX,4] )     		//QTDE
	      aadd( oHtml:ValByName("it.nValUni"), Transform(aPedido[_nX,5], "@E 999,999.9999") )         //VALOR UNITÁRIO
	      aadd( oHtml:ValByName("it.nValTot"), Transform(aPedido[_nX,6], "@E 999,999.99") )	       	//VALOR TOTAL
	      
		Next _nX


	DbselectArea("TMPC5")
	TMPC5->(DBSKIP())
	
Enddo

oHtml:ValByName("dEmissao", Dtoc(dEmissao) )  
oHtml:ValByName("dFat"    , Dtoc(dDtFat) )  

//oProcess:cTo:= "flavia.rocha@ravaembalagens.com.br"
oProcess:cTo:= cUserMail  + ";" + cVendMail 

If nTipo = 3
	If Alltrim(cSuper) = '0255'
	 	oProcess:cTo += ";vendas.sp@ravaembalagens.com.br"    //alterado por Flavia Rocha - 02/09/11
	 	//oProcess:cBCC:= "flavia.rocha@ravaembalagens.com.br"
	Endif       
Endif

oProcess:cBCC:= ""
oHtml:ValByName("cVendedor", cVendedor )
oHtml:ValByName("nTotGer", Transform(nTotGer,"@E 999,999.99") )

oProcess:Start()
WfSendMail()
//msginfo("enviou email")	

If nTipo <> 3
	conout(Replicate("*",60))
	conout("LIBERACRED - PV Aprov - " + Dtoc(Date()) + "-" + Time() + " FIM")
	conout(Replicate("*",60)) 
Else
	conout(Replicate("*",60))
	conout("LIBERACRED - PV Reprov - " + Dtoc(Date()) + "-" + Time() + " FIM")
	conout(Replicate("*",60))

Endif
 

DbselectArea("TMPC5")
TMPC5->(DBCLOSEAREA()) 


Return .T.
