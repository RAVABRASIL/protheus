#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "font.ch"
#include "colors.ch"



************************
User Function WFREPSEM()
************************

Local crepI := ""
Local crepF := ""

	conOut( " " )
	conOut( "***************************************************************************" )
	conOut( "***************************************************************************" )
	conOut( "***************************************************************************" )
	conOut( "Programa de envio de NF para Representantes Semanal iniciado as " + DtoC( Date() ) + " - " + Time() )
	conOut( "***************************************************************************" )
	conOut( "***************************************************************************" )
	conOut( "***************************************************************************" )
	conOut( " " )
	lMenu := .T.

	If Select( 'SX2' ) == 0  //Testa se esta sendo executado pelo menu ou pelo Workflow
		RPCSetType( 3 )  //Nao consome licensa de uso
		PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFREPSEM" Tables "SF2", "SA1", "SA3", "SA4", "SE1"  //Prepara a empresa caso uso pelo Workflow
		Sleep( 5000 )  //aguarda 5 seg para que os jobs IPC subam
		lMenu := .F.
	Else
		conOut( "Programa WFREPSEM sendo executado pelo MENU ou com erro." )
       lMenu := .F.   
	EndIf
	
	SetPrvt("OHTML,N_TERMINA,OPROCESS,CIND")
	SetPrvt("CCHAVE,CFILTRO,eFaturamento,CPOVI,ACOND,AREGS_PROCESSADOS")
	SetPrvt("NCOTACAO,LFORNENEW,NPOSFOR,NI,CEMAIL,AFORNEC")
	SetPrvt("wvlr_tot")
	SetPrvt("_NREC_ATUAL,_NI,NNUMEMAIL,NCOUNT,ITEM,_USER")
	SetPrvt("TO,CC,BCC,SUBJ,SUBJECT,BODY")
	SetPrvt("CODERETURN,CODETIMEOUT,")
                                
	If ! lMenu
	   
	   dDateI :=DATE()-5
	   dDateF :=DATE()-1
	   PesqRep( dDateI, dDateF,crepI,crepF )
	
	EndIf
	 	
Return


***************

Static Function PesqRep( dEdit1, dEdit2, cRep1, cRep2, cMail )

***************

	cQuery := Nil
	dData1 := DtoS( dEdit1 )
	dData2 := DtoS( dEdit2 )
	cVend1 := cRep1
	cVend2 := cRep2
	cEndEle := cMail
	cQuery := "SELECT SA3.A3_COD, SA3.A3_NOME, SA3.A3_EMAIL, SF2.F2_DOC, SF2.F2_SERIE, SA1.A1_NOME, SA4.A4_NREDUZ, SF2.F2_EMISSAO, SF2.F2_VALFAT, SE1.E1_VENCTO, SE1.E1_VALOR "
	cQuery += "FROM " + RetSqlName( "SF2" ) + " SF2, " + RetSqlName( "SA1" ) + " SA1, " + RetSqlName( "SA3" ) + " SA3, " + RetSqlName( "SA4" ) + " SA4, " + RetSqlName( "SE1" ) + " SE1 "
	cQuery += "WHERE SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA "
	cQuery += "AND SF2.F2_DOC = SE1.E1_NUM AND SF2.F2_SERIE = SE1.E1_PREFIXO "
	cQuery += "AND SF2.F2_VEND1 = SA3.A3_COD "
	cQuery += "AND SF2.F2_TRANSP = SA4.A4_COD "
	
	If Alltrim(dData1) == '' .OR. Alltrim(dData2) == ''
		Alert( 'ATENCAO: O intervalo de DATA deve ser preenchido para esta consulta.' )
		Return Nil
	Else
		cQuery += "AND SF2.F2_EMISSAO BETWEEN '" + dData1 + "' AND '" + dData2 + "' "
	EndIf
	If Alltrim( cVend1 ) != '' .OR. Alltrim( cVend2 ) != ''
		cQuery += "AND SF2.F2_VEND1 BETWEEN '" + cVend1 + "' AND '" + cVend2 + "' "
	EndIf
	cQuery += "AND SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += "AND SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "AND SA3.A3_FILIAL = '" + xFilial( "SA3" ) + "' AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "AND SA4.A4_FILIAL = '" + xFilial( "SA4" ) + "' AND SA4.D_E_L_E_T_ = ' ' "
	cQuery += "AND SE1.E1_FILIAL = '" + xFilial( "SE1" ) + "' AND SE1.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SA3.A3_NOME, SF2.F2_DOC, SF2.F2_SERIE, SE1.E1_VENCTO "
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
											 CONX->F2_EMISSAO, 	CONX->F2_VALFAT, 	CONX->E1_VENCTO, 	CONX->E1_VALOR } )
			nFatTot += CONX->E1_VALOR
			CONX->( DbSkip() )
		EndDo

		If Alltrim( cMailRep ) <> ''
			EnviaMail(cNomeRep, cMailRep, aConslt, nFatTot, cSuper, cMailSuper )
		Else
			conOut( "ATENCAO: " + cNomeRep + " com o campo A3_EMAIL em branco." )
			Alert('ATENCAO: ' + Alltrim( cNomeRep ) + ' nao possui e-mail no cadastro.')
		EndIf

	EndDo
	CONX->( DbCloseArea() )
	conOut( "Acesso a funcao PesqRep" )
Return


************************
Static Function EnviaMail( cNomeRep, cMailRep, aConslt, nFatTot, cSuper, cMailSuper )
************************
	wvlr_tot := 0
	oProcess:=TWFProcess():New("WFREPSEM","Mails para Representantes semanal")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\mailfatreSem.htm")
	oHtml   := oProcess:oHtml
	
	eEmail := cMailRep // Definição de e-mail padrão
	eCopia := ""  //'posvendas@ravaembalagens.com.br' //Flavia Rocha - Em 25/07/11 Daniela solicitou retirar o email do SAC do envio deste Informativo.
	//If Alltrim(cSuper) $ "0320"
	eCopia := cMailSuper //"flavia.rocha@ravaembalagens.com.br" //testando para ver se recebo
    //Endif
    
    If Alltrim(cSuper) $ "0320"
		//eCopia += ";flavia.rocha@ravaembalagens.com.br" //testando para ver se recebo
    Endif	  	  
	
	oHtml:ValByName("dData"		, StoD( dData1 ) )
	oHtml:ValByName("dData2", StoD( dData2 ) )
	oHtml:ValByName("cRep"			, cNomeRep )
	
	X := 1
	lValid := .F.
	While X <= Len( aConslt )
		cNF := aConslt[X,1]
		cSerie := aConslt[X,2]
		aadd( oHtml:ValByName("it.cNota")			, aConslt[X,1] )
		aadd( oHtml:ValByName("it.cSerie")		, Substring( aConslt[X,2], 1, 1 ) )
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
	//oProcess:cBCC   := "flavia.rocha@ravaembalagens.com.br"
	
	subj	:= "Vendas de " + cNomeRep
	oProcess:cSubject  := subj
	conOut( "Acesso a rotina de envio de e-mails para " + cNomeRep + " em: " + Dtoc( DATE() ) + ' - ' + Time() )
 	oProcess:Start()
	WfSendMail()
	Sleep( 5000 )  //aguarda 5 seg para que o e-mail seja enviado
	oProcess:Finish()
Return
