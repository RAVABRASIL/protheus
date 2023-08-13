#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#INCLUDE "TOPCONN.CH"
#INCLUDE "SHELL.CH"
#include "font.ch"
#include "colors.ch"
#include "TbiConn.ch"


#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function MAILFAX()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIASANT,ASTRUT,CARQ,CARQI,CEXTENSO,CFILTRO")
SetPrvt("CCHAVE,CINDSE1,DVENCTO,CMES,CVENCTO,CDATA")
SetPrvt("CVALEXT,AFIELDS,CPATH,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Esmerino Toscano de Brito Neto           ³ Data ³ 09/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Geracao de e-mails para cobranca dos Clientes por Fax      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Financeiro                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	Janela()

Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc

************************
Static Function OkProc()
************************

	cALIASANT := Alias()
	Close( oDlg1 )
	If SM0->M0_CODIGO=="02"
	   Processa( {|| Fin_Gmc() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Processa( {|| Execute(Fin_Gmc) } )
	Else
	   Aviso("M E N S A G E M", "Entre na Empresa 02 - RAVA", {"OK"})
	Endif

Return


************************
Static Function Janela()
************************

	dEdit1 := CtoD( Space(8) )
	dEdit2 := CtoD( Space(8) )
	dEdit3 := CtoD( Space(8) )
	dEdit4 := CtoD( Space(8) )
	cPrfx1 := Space(3)
	cPrfx2 := Space(3)
	cCli1  := Space(6)
	cCliLog1 := Space(2)
	cCli2 := Space(6)
	cCliLog2 := Space(2)
	cMail := "mariagraca_2006@yahoo.com.br"// + Space(50)


	DEFINE FONT oFont NAME "Arial" SIZE 6, 15 BOLD
	DEFINE FONT oFont2 NAME "Arial" SIZE 5, 14 ITALIC
	DEFINE FONT oFont3 NAME "Arial" SIZE 5, 14

	@ 000,000 To 450,300 Dialog oDlg Title "WORKFLOW - Gera E-Mails para cobranca de Cliente"

	@ 010,030 Say "Emissao de:" Object oSay1
	@ 020,030 Get dEdit1 Object oDataDe Size 40,40 /*Valid PesqOp( cOP )*/
	@ 010,080 Say "Emissao ate:" Object oSay2
	@ 020,080 Get dEdit2 Object oGet1 Size 40,40 /*Valid PesqOp( cOP )*/

	@ 040,030 Say "Vencimento de:" Object oSay3
	@ 050,030 Get dEdit3 Object oDataDe Size 40,40 /*Valid PesqOp( cOP )*/
	@ 040,080 Say "Vencimento ate:" Object oSay4
	@ 050,080 Get dEdit4 Object oGet2 Size 40,40 /*Valid PesqOp( cOP )*/

	@ 070,030 Say "Do Prefixo:"  Object oSay5
	@ 080,030 Get cPrfx1 Object oPrfx1 Size 30,40 Picture "@!" /*Valid Atualiza( cCli1, 1 )*/
	/*@ 070,060 Say " " Object oSay6 Size 120,40*/
	@ 070,080 Say "Ate Prefixo:" Object oSay6
	@ 080,080 Get cPrfx2 Object oPrfx2 Size 30,40 Picture "@!" /*Valid Atualiza( cCli2, 2 )*/
	/*@ 070,040 Say " " Object oSay8 Size 120,40*/

	@ 100,010 Say "Do Cliente:"  Object oSay7
	@ 100,045 Get cCli1 Object oCli1 F3 "SA1" Size 30,40 Valid Atualiza( cCli1, 1 )
	@ 100,085 Say "Loja:"  Object oSay8
	@ 100,100 Get cCliLog1 Object oCliLog1 Size 10,40 /*Valid Atualiza( cCli1, 1 )*/
	@ 115,045 Say " " Object oSay9 Size 120,40

	@ 125,010 Say "Ate Cliente:" Object oSay10
	@ 125,045 Get cCli2 Object oCli2 F3 "SA1" Size 30,40 Valid Atualiza( cCli2, 2 )
	@ 125,085 Say "Loja:" Object oSay11
	@ 125,100 Get cCliLog2 Object oCliLog2 Size 10,40 /*Valid Atualiza( cCli2, 2 )*/
	@ 140,045 Say " " Object oSay12 Size 120,40

	@ 160,010 Say "E-mail do Destinatario:" Object oSay13
	@ 170,010 Get cMail Object oEmail Size 120,40 Valid Atualiza( cMail, 3 )
	@ 180,005 Say "Digite o e-mail de quem enviara o Fax para os Clientes" Object oSay14

	oSay1:SetFont( oFont )
	oSay2:SetFont( oFont )
	oSay3:SetFont( oFont )
	oSay4:SetFont( oFont )
	oSay5:SetFont( oFont )
	oSay6:SetFont( oFont )
	oSay7:SetFont( oFont )
	oSay8:SetFont( oFont )
	oSay9:SetFont( oFont2 )
	oSay10:SetFont( oFont )
	oSay11:SetFont( oFont )
	oSay12:SetFont( oFont3 )
	oSay13:SetFont( oFont )
	oSay14:SetColor( CLR_RED )

	@ 200,040 BMPBUTTON Type 1 Action Processa( { |lEnd| Fin_Gmc( dEdit1, dEdit2, dEdit3, dEdit4, cPrfx1, cPrfx2, cCli1, cCli2, cMail ) } )
	//@ 200,040 BMPBUTTON Type 1 Action Processa( { |lEnd| Fin_Gmc() } )
	@ 200,080 BMPBUTTON Type 2 Action Close( oDlg )

	Activate Dialog oDlg Center //On Init Inicio()

Return Nil

************************
Static Function Atualiza( cCod, nOpc )
************************

	Local cDado := cCod
	Local cLoja := '01'

	If nOpc == 1 .AND. Alltrim( cCod ) != ''
		DbSelectArea( "SA1" )
		DbSetOrder( 1 )
		DbSeek( xFilial("SA1") + cCod, .T. )
		cDado := SA1->A1_NOME
		oSay9:SetText( cDado )
		DbCloseArea( "SA1" )
		oCli2:SetFocus()
	ElseIf nOpc == 2 .AND. Alltrim( cCod ) != ''
		DbSelectArea( "SA1" )
		DbSetOrder( 1 )
		DbSeek( xFilial("SA1") + cCod, .T. )
		cDado := SA1->A1_NOME
		oSay12:SetText( cDado )
		DbCloseArea( "SA1" )
		oEmail:SetFocus()
	ElseIf nOPc == 3
		If Alltrim( cDado ) == ''
			Alert( 'ATENCAO: Insira o e-mail para onde sera enviado o relatorio.', 'Atencao!' )
			oEmail:SetFocus()
		EndIf
	EndIf

Return Nil


************************
Static Function Fin_Gmc( cDtEmis1, cDtEmis2, cDtVenc1, cDtVenc2, cPrefx1, cPrefx2, cCodCli1, cCodCli2, cMail )
************************

	aResu := {}

	DBSelectArea("SA1")
 	SA1->( DBSetOrder(1) )

 	cQuery := "SELECT SE1.E1_NUM, SE1.E1_EMISSAO, SE1.E1_VENCTO, SE1.E1_SALDO, SE1.E1_CLIENTE, SE1.E1_LOJA "
 	cQuery += "FROM " + RetSqlName( "SE1" ) + " SE1 "
 	cQuery += "WHERE E1_SALDO > 0 AND "
	cQuery += "E1_PREFIXO >= '" + cPrefx1 + "' AND E1_PREFIXO <= '" + cPrefx2 + "' AND "
 	If Alltrim( cCodCli1 ) != '' .OR. Alltrim( cCodCli2 ) != ''
 		cQuery += "E1_CLIENTE >= '" + cCodCli1 + "' AND E1_CLIENTE <= '" + cCodCli2 + "' AND "
 	EndIf
 	If Alltrim( DtoS( cDtEmis1 ) ) != '' .OR. Alltrim( DtoS( cDtEmis2 ) )
		cQuery += "E1_EMISSAO >= '" + Dtos( cDtEmis1 ) + "' AND E1_EMISSAO <= '" + Dtos( cDtEmis2 ) + "' AND "
 	EndIf
 	If Alltrim( DtoS( cDtVenc1 ) ) != '' .OR. Alltrim( DtoS( cDtVenc1 ) ) != ''
		cQuery += "E1_VENCTO >= '" + Dtos( cDtVenc1 ) + "' AND E1_VENCTO <= '" + Dtos( cDtVenc2 ) + "' AND "
 	EndIf
 	cQuery += "E1_FILIAL = '" + xFilial( "SE1" ) + "' AND "
 	cQuery += "D_E_L_E_T_ = ' ' "
 	cQuery += "ORDER BY E1_CLIENTE,E1_VENCTO,E1_NUM "
 	cQuery := ChangeQuery( cQuery )
 	TCQUERY cQuery NEW ALIAS "SE1X"
	TCSetField( 'SE1X', "SE1.E1_EMISSAO", "D" )
 	TCSetField( 'SE1X', "SE1.E1_VENCTO", "D" )

 	SE1X->( DBGoTop() )

 	While  ! SE1X->( EOF() )

		cClitmp := SE1X->E1_CLIENTE
		cLojaCli := SE1X->E1_LOJA
		nTotal 	:= 0
		aNFs 		:= {}

		While cClitmp == SE1X->E1_CLIENTE


			aAdd( aNFs,{ SE1X->E1_NUM, SE1X->E1_EMISSAO, SE1X->E1_SALDO, SE1X->E1_VENCTO } )
			nTotal += SE1X->E1_SALDO
			SE1X->( DbSkip() )

		EndDo

		SA1->( DBSeek( xFilial( "SA1" ) + cClitmp + cLojaCli ) )
		cNomecli := SA1->A1_NOME
		cTelcli := SA1->A1_TEL

		aAdd( aResu,{ cNomecli, aNFs } )
        Sleep(30000)
		EnviaMail( cNomecli, cTelcli, aNFs, nTotal )
 	EndDo

	
	Resumo( aResu )

	SE1X->( DBCloseArea() )

Return

****************
Static Function MESEXT( dData, nOP )
****************

	If Month(dData) == 1
		 If nOP == 1
		 	cMES := "Jan"
		 Else
			cMES := "Janeiro"
		 EndIf
	ElseIf Month(dData) == 2
		 If nOP == 1
		 	cMES := "Fev"
		 Else
			cMES := "Fevereiro"
		 EndIf
	ElseIf Month(dData) == 3
		 If nOP == 1
		 	cMES := "Mar"
		 Else
			cMES := "Marco"
		 EndIf
	ElseIf Month(dData) == 4
		 If nOP == 1
		 	cMES := "Abr"
		 Else
			cMES := "Abril"
		 EndIf
	ElseIf Month(dData) == 5
		 If nOP == 1
		 	cMES := "Mai"
		 Else
			cMES := "Maio"
		 EndIf
	ElseIf Month(dData) == 6
		 If nOP == 1
		 	cMES := "Jun"
		 Else
			cMES := "Junho"
		 EndIf
	ElseIf Month(dData) == 7
		 If nOP == 1
		 	cMES := "Jul"
		 Else
			cMES := "Julho"
		 EndIf
	ElseIf Month(dData) == 8
		 If nOP == 1
		 	cMES := "Ago"
		 Else
			cMES := "Agosto"
		 EndIf
	ElseIf Month(dData) == 9
		 If nOP == 1
		 	cMES := "Set"
		 Else
			cMES := "Setembro"
		 EndIf
	ElseIf Month(dData) == 10
		 If nOP == 1
		 	cMES := "Out"
		 Else
			cMES := "Outubro"
		 EndIf
	ElseIf Month(dData) == 11
		 If nOP == 1
		 	cMES := "Nov"
		 Else
			cMES := "Novembro"
		 EndIf
	ElseIf Month(dData) == 12
		 If nOP == 1
		 	cMES := "Dez"
		 Else
			cMES := "Dezembro"
		 EndIf
	Endif

Return cMES


************************
Static Function EnviaMail( cCliente, cTel, aNfs, nTotNfs )
************************

	cDiaAtu := StrZero( Day( Date() ), 2 )
	cMesAtu := MESEXT( Date(), 2 )
	cAnoAtu := Alltrim( Str( Year( Date() ) ) )

	wvlr_tot := 0
	oProcess:=TWFProcess():New("MAILREP","Mails de cobranca dos Clientes")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\malacli.htm")
	oHtml   := oProcess:oHtml
	eEmail := cMail // Definição de e-mail padrão
   oProcess:cTo := eEmail
	oHtml:ValByName("nDia"			, cDiaAtu )
	oHtml:ValByName("cMes"			, cMesAtu )
	oHtml:ValByName("nAno"			, cAnoAtu )
	oHtml:ValByName("cCliente"	, cCliente )
	X := 1
	lValid := .F.

	While X <= Len( aNfs )
		aadd( oHtml:ValByName("it.cNF")				, aNfs[X, 1] )
		aadd( oHtml:ValByName("it.cEmissao")	, StoD( aNfs[X, 2] ) )
		aadd( oHtml:ValByName("it.nValNF")		, Transform( aNfs[X, 3], '@E 999,999.99') )
		aadd( oHtml:ValByName("it.cVenc")			, StoD( aNfs[X, 4] ) )
		X++
	EndDo
	
	oHtml:ValByName("nTotal"	, Transform( nTotNfs, '@E 999,999.99') )
	_user := Subs(cUsuario,7,15)
//	oProcess:ClientName(_user)
	oProcess:cBCc	:= Alltrim( eEmail )
	subj	:= "Cobranca de " + Alltrim( cCliente ) + " Tel: " + Alltrim( cTel )
	oProcess:cSubject  := subj
	oProcess:cFromName := 'Cobranca'
	conOut( "Acesso a rotina de envio de e-mails para " + cCliente + " em: " + Dtoc( DATE() ) + ' - ' + Time() )

 	oProcess:Start()
	WfSendMail()
	Sleep( 5000 )  //aguarda 5 seg para que o e-mail seja enviado
	oProcess:Finish()

Return



************************
Static Function Resumo( aResumo )
************************

	dDataAtu := Date()
	cTime := Substring( Time(), 1, 5 )

	oProcess:=TWFProcess():New("MAILREP","Mails de cobranca dos Clientes")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\resmalacli.htm")
	oHtml   := oProcess:oHtml
	eEmail := cMail // Definição de e-mail padrão
	oProcess:cTo := eEmail
	_user := Subs(cUsuario,7,15)
	oHtml:ValByName("cUser"			, Alltrim( _user ) )
	oHtml:ValByName("cHora"			, cTime )
	oHtml:ValByName("dData"			, dDataAtu )
	X := 1
	Y := 2
	nTotal := 0
	lValid := .F.

//	While X <= Len( aNfs )
//		aadd( oHtml:ValByName("it.cNF")				, aNfs[X, 1] )
//		aadd( oHtml:ValByName("it.cEmissao")	, StoD( aNfs[X, 2] ) )
//		aadd( oHtml:ValByName("it.nValNF")		, Transform( aNfs[X, 3], '@E 999,999.99') )
//		aadd( oHtml:ValByName("it.cVenc")			, StoD( aNfs[X, 4] ) )
//		X++
//	EndDo

	//dW := Len( aResumo[1,2] )

	While X <= Len( aResumo )
		//cNF := aResumo[X,1]
		//cSerie := aConslt[X,2]
		aadd( oHtml:ValByName("it.cNome")			, aResumo[X,1] )
		aadd( oHtml:ValByName("it.cNF")				, aResumo[X, 2, 1, 1] )
		aadd( oHtml:ValByName("it.dEmissao") 	, StoD( aResumo[X, 2, 1, 2] ) )
		aadd( oHtml:ValByName("it.dVenc")			, StoD( aResumo[X, 2, 1, 4] ) )
		aadd( oHtml:ValByName("it.nValNF")		, Transform( aResumo[X, 2, 1, 3], '@E 999,999.99' ) )

		nTotal += aResumo[X, 2, 1, 3]
		If Len( aResumo[1,2] ) > 1
			While Y <= Len( aResumo[1,2] ) //.AND. cNF == aResumo[X,1] .AND. cSerie == aResumo[X,2]
				aadd( oHtml:ValByName("it.cNome")			, aResumo[X,1] )
				aadd( oHtml:ValByName("it.cNF")				, aResumo[X, 2, Y, 1] )
				aadd( oHtml:ValByName("it.dEmissao") 	, StoD( aResumo[X, 2, Y, 2] ) )
				aadd( oHtml:ValByName("it.dVenc")			, StoD( aResumo[X, 2, Y, 4] ) )
				aadd( oHtml:ValByName("it.nValNF")		, Transform( aResumo[X, 2, Y, 3], '@E 999,999.99' ) )
				nTotal += aResumo[X, 2, Y, 3]
				Y++
			EndDo
		EndIf
		X++
	EndDo


	oHtml:ValByName("nTotal"		, Transform( nTotal, '@E 999,999.99') )
	oHtml:ValByName("ntotemail" , Len( aResumo ) )
//	oProcess:ClientName(_user)
	oProcess:cBCc	:= Alltrim( eEmail )
	//oProcess:cCC	:= eCopia
	//oProcess:cCC := "Voce <" + eEmail + ">"
	subj	:= "Cobranca Resumo"
	oProcess:cSubject  := subj
	oProcess:cFromName := 'Cobranca'
//	oProcess:cFromAddr := ''
//	conOut( "Acesso a rotina de envio de e-mails para " + cCliente + " em: " + Dtoc( DATE() ) + ' - ' + Time() )
 	oProcess:Start()
	WfSendMail()
	Sleep( 5000 )  //aguarda 5 seg para que o e-mail seja enviado
   oProcess:Finish()


Return
