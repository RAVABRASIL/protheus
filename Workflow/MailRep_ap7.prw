#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"



/*-----------------------------------------------------------------------------+
 * Programa MAILREP     º      Esmerino Neto      º      Data ³  02/08/2006    *
 +-----------------------------------------------------------------------------+
 *Objetivo   *Emitir e-mail com a relacao das NF faturadas para os respectivos *
 *           *representantes.                                                  *
 *-----------------------------------------------------------------------------+
 * Uso       ³WorkFlow/AP7 - RAVA Embalagens                                   *
 *-----------------------------------------------------------------------------+
 | Starting  |Schedule / Menu                                                  |
 +-----------------------------------------------------------------------------+*/

************************
User Function MAILREP()
************************

Private lMenu

	conOut( " " )
	conOut( "***************************************************************************" )
	conOut( "***************************************************************************" )
	conOut( "***************************************************************************" )
	conOut( "Programa de envio de NF para Representantes iniciado as " + DtoC( Date() ) + " - " + Time() )
	conOut( "***************************************************************************" )
	conOut( "***************************************************************************" )
	conOut( "***************************************************************************" )
	conOut( " " )
	lMenu := .T.

	If Select( 'SX2' ) == 0  //Testa se esta sendo executado pelo menu ou pelo Workflow
		RPCSetType( 3 )  //Nao consome licensa de uso
		PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "MAILREP" Tables "SF2", "SA1", "SA3", "SA4", "SE1"  //Prepara a empresa caso uso pelo Workflow
		Sleep( 5000 )  //aguarda 5 seg para que os jobs IPC subam
		lMenu := .F.
		fGeraRep()
	
	Else
		conOut( "Programa MAILREP sendo executado pelo MENU ou com erro." )
       lMenu := .T.
       fGeraRep() 
    Endif
 
 ****************************   
 Static Function fGeraRep() 
 ****************************  
    
	If lMenu       
		dEdit1 := CtoD( Space(8) )
		dEdit2 := CtoD( Space(8) )
		cRep1 := Space(6)
		cRep2 := Space(6)
		cMail := Space(50)

		DEFINE FONT oFont  NAME "Arial" SIZE 6, 15 BOLD
		DEFINE FONT oFont2 NAME "Arial" SIZE 5, 14 ITALIC
		DEFINE FONT oFont3 NAME "Arial" SIZE 5, 14

		@ 000,000 To 300,300 Dialog oDlg Title "WORKFLOW - Mails de NF para Representantes"
		@ 010,030 Say "Data de:" Object oSay1
		@ 020,030 Get dEdit1 Object oDataDe Size 40,40 /*Valid PesqOp( cOP )*/
		
		@ 010,080 Say "Data ate:" Object oSay2
		@ 020,080 Get dEdit2 Object oOP Size 40,40 /*Valid PesqOp( cOP )*/
		
		@ 040,010 Say "Do Representante:"  Object oSay3
		@ 050,010 Get cRep1 Object oRep1 F3 "SA3" Size 30,40 Valid Atualiza( cRep1, 1 )
		@ 050,040 Say " " Object oSay4 Size 120,40

		@ 070,010 Say "Ate Representante:" Object oSay5
		@ 080,010 Get cRep2 Object oRep2 F3 "SA3" Size 30,40 Valid Atualiza( cRep2, 2 )
		@ 080,040 Say " " Object oSay6 Size 120,40

		@ 100,010 Say "E-mail do Destinatario:" Object oSay7
		@ 110,010 Get cMail Object oEmail Size 120,40 /*Valid PesqOp( cOP )*/
		
		@ 120,005 Say "Deixar branco caso envio para Representantes da consulta" Object oSay8

		oSay1:SetFont( oFont )
		oSay2:SetFont( oFont )
		oSay3:SetFont( oFont )
		oSay4:SetFont( oFont2 )
		oSay5:SetFont( oFont )
		oSay6:SetFont( oFont2 )
		oSay7:SetFont( oFont )
		oSay8:SetFont( oFont3 )
		oSay8:SetColor( CLR_RED )

		@ 130,040 BMPBUTTON Type 1 Action Processa( { |lEnd| PesqRep( dEdit1, dEdit2, cRep1, cRep2, cMail ) } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON Type 1 Action Execute(OkProc)
		@ 130,080 BMPBUTTON Type 2 Action Close( oDlg )

		Activate Dialog oDlg Center

		Return Nil
       
	EndIf     //só faz se for pelo menu Siga
	
	SetPrvt("OHTML,N_TERMINA,OPROCESS,CIND")
	SetPrvt("CCHAVE,CFILTRO,eFaturamento,CPOVI,ACOND,AREGS_PROCESSADOS")
	SetPrvt("NCOTACAO,LFORNENEW,NPOSFOR,NI,CEMAIL,AFORNEC")
	SetPrvt("wvlr_tot")
	SetPrvt("_NREC_ATUAL,_NI,NNUMEMAIL,NCOUNT,ITEM,_USER")
	SetPrvt("TO,CC,BCC,SUBJ,SUBJECT,BODY")
	SetPrvt("CODERETURN,CODETIMEOUT,")

	If ! lMenu
	   dDateAtu := Date() - 1
	   PesqRep( dDateAtu, dDateAtu )	
	EndIf

 	//oProcess:Start()
	//WfSendMail()
	//Sleep( 2000 )  //aguarda 2 seg para que o e-mail seja enviado
	//oProcess:Finish()
Return


************************
Static Function Atualiza( cCod, nOpc )
************************

	Local cRep

	If nOpc == 1
		DbSelectArea( "SA3" )
		DbSetOrder( 1 )
		DbSeek( xFilial("SA3") + cCod )
		cRep := SA3->A3_NOME
		oSay4:SetText( cRep )
		DbCloseArea( "SA3" )
	Else
		DbSelectArea( "SA3" )
		DbSetOrder( 1 )
		DbSeek( xFilial("SA3") + cCod )
		cRep := SA3->A3_NOME
		oSay6:SetText( cRep )
		DbCloseArea( "SA3" )
	EndIf

Return Nil


************************
Static Function PesqRep( dEdit1, dEdit2, cRep1, cRep2, cMail )
************************
	Local cQuery := Nil
	Local cSuper  := ""
	Local cMailSuper := ""
	//dData := DtoS( Date() - 1 )
	dData1 := DtoS( dEdit1 )
	dData2 := DtoS( dEdit2 )
	cVend1 := cRep1
	cVend2 := cRep2
	cEndEle := cMail
	
	cQuery := "SELECT SF2.F2_FILIAL,SE1.E1_FILIAL, SA3.A3_COD, SA3.A3_NOME, SA3.A3_EMAIL, SF2.F2_DOC, SF2.F2_SERIE, SA1.A1_NOME, SA4.A4_NREDUZ, SF2.F2_EMISSAO, SF2.F2_VALFAT, SE1.E1_VENCTO, SE1.E1_VALOR "
	cQuery += "FROM " + RetSqlName( "SF2" ) + " SF2, " + RetSqlName( "SA1" ) + " SA1, " + RetSqlName( "SA3" ) + " SA3, " + RetSqlName( "SA4" ) + " SA4, " + RetSqlName( "SE1" ) + " SE1 "
	cQuery += "WHERE SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA "
	cQuery += "AND SF2.F2_DOC = SE1.E1_NUM AND SF2.F2_SERIE = SE1.E1_PREFIXO "
	//colocada em 13/05/2011
	cQuery += "AND SF2.F2_FILIAL = SE1.E1_FILIAL "
	//
	cQuery += "AND SF2.F2_VEND1 = SA3.A3_COD "
	cQuery += "AND SF2.F2_TRANSP = SA4.A4_COD "
	//cQuery += "AND SF2.F2_EMISSAO = '" + dData + "' "
	If Alltrim(dData1) == '' .OR. Alltrim(dData2) == ''
		Alert( 'ATENCAO: O intervalo de DATA deve ser preenchido para esta consulta.' )
		Return Nil
	Else
		cQuery += "AND SF2.F2_EMISSAO BETWEEN '" + dData1 + "' AND '" + dData2 + "' "
	EndIf
	If Alltrim( cVend1 ) != '' .OR. Alltrim( cVend2 ) != ''
		cQuery += "AND SF2.F2_VEND1 BETWEEN '" + cVend1 + "' AND '" + cVend2 + "' "
	EndIf
    cQuery += "AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += "AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "AND SA4.D_E_L_E_T_ = ' ' "
	cQuery += "AND SE1.D_E_L_E_T_ = ' ' "
    /*  retirado para junta fabrica de caixa e saco
  	cQuery += "AND SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += "AND SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "AND SA3.A3_FILIAL = '" + xFilial( "SA3" ) + "' AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "AND SA4.A4_FILIAL = '" + xFilial( "SA4" ) + "' AND SA4.D_E_L_E_T_ = ' ' "
	cQuery += "AND SE1.E1_FILIAL = '" + xFilial( "SE1" ) + "' AND SE1.D_E_L_E_T_ = ' ' "
    */
	cQuery += "ORDER BY SA3.A3_NOME, SF2.F2_DOC, SF2.F2_SERIE, SE1.E1_VENCTO "
	MemoWrite("C:\TEMP\MAILREP.SQL",cQuery )
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "CONX"
	CONX->( DbGoTop() )
	While ! CONX->( EoF() )
		cNomeRep := CONX->A3_NOME
		cSuper := ""
		cMailSuper := ""
        SA3->(DBSETORDER(1))
        If SA3->(Dbseek(xFilial("SA3") + CONX->A3_COD ))
        	cSuper := SA3->A3_SUPER
        Endif
        
        If !Empty(cSuper)
        	SA3->(DBSETORDER(1))
	        If SA3->(Dbseek(xFilial("SA3") + cSuper ))
	        	cMailSuper := SA3->A3_EMAIL
	        	cMailSuper += ";steves.scanoni@ravaembalagens.com.br"
	        Endif
        Endif
        
        
		If Alltrim( cEndEle ) != ''
			cMailRep := cMail
		Else
			cMailRep := Alltrim( CONX->A3_EMAIL )
		EndIf

		aConslt := {}
		nFatTot := 0

		While cNomeRep == CONX->A3_NOME
			aAdd( aConslt, { CONX->F2_DOC, 			CONX->F2_SERIE,	CONX->A1_NOME, 		CONX->A4_NREDUZ,;
											 CONX->F2_EMISSAO, 	CONX->F2_VALFAT, 	CONX->E1_VENCTO, 	CONX->E1_VALOR,	CONX->F2_FILIAL  } )
			nFatTot += CONX->E1_VALOR
			CONX->( DbSkip() )
		EndDo

		If Alltrim( cMailRep ) <> ''
			EnviaMail(cNomeRep, cMailRep, aConslt, nFatTot, cSuper, cMailSuper)
		Else
			conOut( "ATENCAO: " + cNomeRep + " com o campo A3_EMAIL em branco." )
			//Alert('ATENCAO: ' + Alltrim( cNomeRep ) + ' nao possui e-mail no cadastro.')
		EndIf

	EndDo
	CONX->( DbCloseArea() )
	conOut( "Acesso a funcao PesqRep" )
Return


************************
Static Function EnviaMail( cNomeRep, cMailRep, aConslt, nFatTot, cSuper, cMailSuper )
************************
	wvlr_tot := 0
	oProcess:=TWFProcess():New("MAILREP","Mails para Representantes")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\mailfatre.htm")
	oHtml   := oProcess:oHtml
	eEmail := cMailRep // Definição de e-mail padrão
	
	eCopia := "" 
	eCopia := cMailSuper 
       
      	  
//aAdd( aConslt, { CONX->F2_DOC, 			CONX->F2_SERIE,	CONX->A1_NOME, 		CONX->A4_NREDUZ, CONX->F2_EMISSAO, 	CONX->VALFAT, 	CONX->E1_VENCTO, 	CONX->E1_VALOR } )
	oHtml:ValByName("dData"		, StoD( dData1 ) )
	oHtml:ValByName("cRep"			, cNomeRep )
	X := 1
	lValid := .F.
	While X <= Len( aConslt )
		cNF := aConslt[X,1]
		cSerie := aConslt[X,2]
		aadd( oHtml:ValByName("it.cNota")			, aConslt[X,1] )
		aadd( oHtml:ValByName("it.cSerie")		, Substring( aConslt[X,2], 1, 1 ) )
		//
		aadd( oHtml:ValByName("it.cFab")	, iif(aConslt[X,9]='01','Saco',iif(aConslt[X,9]='03','Caixa','')) )
		//
		aadd( oHtml:ValByName("it.cCliente")	, aConslt[X,3] )
		aadd( oHtml:ValByName("it.cTransp")		, aConslt[X,4] )
		aadd( oHtml:ValByName("it.cDTEmis")		, StoD( aConslt[X,5] ) )
		aadd( oHtml:ValByName("it.nValNF")		, Transform( aConslt[X,6], '@E 999,999.99') )
		aadd( oHtml:ValByName("it.cDTVenc")		, StoD( aConslt[X,7] ) )
		aadd( oHtml:ValByName("it.nValParc")	, Transform( aConslt[X,8], '@E 999,999.99') )
		X++
		If X <= Len( aConslt ) .AND. cNF == aConslt[X,1] .AND. cSerie == aConslt[X,2]
			While X <= Len( aConslt ) .AND. cNF == aConslt[X,1] .AND. cSerie == aConslt[X,2]
				aadd( oHtml:ValByName("it.cNota")			, "&nbsp;" )
				aadd( oHtml:ValByName("it.cSerie")		, "&nbsp;" )
				aadd( oHtml:ValByName("it.cCliente")	, "&nbsp;" )
				aadd( oHtml:ValByName("it.cTransp")		, "&nbsp;" )
				aadd( oHtml:ValByName("it.cDTEmis")		, "&nbsp;" )
				aadd( oHtml:ValByName("it.nValNF")		, "&nbsp;" )
				aadd( oHtml:ValByName("it.cDTVenc")		, StoD( aConslt[X,7] ) )
				aadd( oHtml:ValByName("it.nValParc")	, Transform( aConslt[X,8], '@E 999,999.99') )
				X++
			EndDo
		EndIf
	EndDo
	oHtml:ValByName("nValTot"	, Transform( nFatTot, '@E 999,999.99') )
	// Start do WorkFlow
	_user := Subs(cUsuario,7,15)
	oProcess:ClientName(_user)
	oProcess:cTo	:= eEmail
	oProcess:cCC	:= eCopia
	//oProcess:cbCC    := "flavia.rocha@ravaembalagens.com.br"  //teste
	subj	:= "Vendas de " + cNomeRep
	oProcess:cSubject  := subj
	conOut( "Acesso a rotina de envio de e-mails para " + cNomeRep + " em: " + Dtoc( DATE() ) + ' - ' + Time() )
 	oProcess:Start()
	WfSendMail()
	Sleep( 5000 )  //aguarda 5 seg para que o e-mail seja enviado
	oProcess:Finish()
Return
