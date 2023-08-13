#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"

/*-----------------------------------------------------------------------------+
 * Programa MAILDEVNF     º     Esmerino Neto     º      Data ³  21/08/2006    *
 +-----------------------------------------------------------------------------+
 *Objetivo   *Emitir e-mail quando uma nota fiscal for cancelada (excluida) do *
 *           *sistema por um usuario.                                          *
 *-----------------------------------------------------------------------------+
 * Uso       ³WorkFlow/AP7 - RAVA Embalagens                                   *
 *-----------------------------------------------------------------------------+
 | Starting  |Schedule / Menu                                                  |
 +-----------------------------------------------------------------------------+*/

************************
User Function MAILDEVNF(cNota, cSerie, cTipo)
************************
    local cemail:=ccodcli:=cNomecli:=''
    local LF    := CHR(13) + CHR(10)
    local cCoduser := __CUSERID 
    local cQuery := ""
    Local cTrans := ""
    
	SetPrvt("nTotNF,cQuery,eEmail,oProcess,oHtml,_user")
	SetPrvt("cVenc,nTotNF,cQuery2,cCodProd,nTotPd,subj")
	SetPrvt("oDlg,oSay,oSay2,")
	nTotNF := 0
	cVenc  := Ctod("  /  /    ")
	
	cQuery := "SELECT SF2.F2_DOC, SF2.F2_TIPO, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_VALBRUT, SF2.F2_CHVNFE, " + LF
	If Alltrim(cTipo) = "N"
		cQuery += " SA1.A1_COD CODCLI , SA1.A1_EMAIL MAILCLI , SA1.A1_NOME NOMECLI, " + LF
		cQuery += " SE1.E1_VENCREA VENCREA, SE1.E1_VALOR VALOR, SE1.E1_PARCELA, " + LF
		cQuery += " SA3.A3_COD, SA3.A3_NOME, " + LF
	Else
		cQuery += " SA2.A2_COD CODCLI , SA2.A2_EMAIL MAILCLI , SA2.A2_NOME NOMECLI, " + LF 
		//cQuery += " SE2.E2_VENCREA VENCREA, SE2.E2_VALOR VALOR, SE2.E2_PARCELA, " + LF
	Endif
	
	cQuery += " SE4.E4_DESCRI " + LF
	
	cQuery += "FROM " + RetSqlName("SF2") + " SF2, " + LF
	
	If Alltrim(cTipo) = "N"
		cQuery += "     " + RetSqlName("SA1") + " SA1, " + LF
		cQuery += "     " + RetSqlName("SA3") + " SA3, " + LF
		cQuery += "     " + RetSqlName("SE1") + " SE1, " + LF
	Else
		cQuery += "     " + RetSqlName("SA2") + " SA2, " + LF
		//cQuery += "     " + RetSqlName("SE2") + " SE2, " + LF
	Endif
	
	
	cQuery += "     " + RetSqlName("SE4") + " SE4 " + LF
	
	cQuery += "WHERE " + LF
	
	If Alltrim(cTipo) = "N"
		cQuery += " SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA " + LF
		cQuery += " AND SF2.F2_DOC = SE1.E1_NUM AND SF2.F2_SERIE = SE1.E1_SERIE " + LF
		cQuery += " AND SF2.F2_FILIAL = SE1.E1_FILIAL " + LF
		cQuery += " AND SF2.F2_VEND1 = SA3.A3_COD " + LF
		cQuery += " AND A1_FILIAL='" + xFilial( "SA1" ) + "' " + LF
		cQuery += " AND E1_FILIAL='" + xFilial( "SE1" ) + "' "   + LF
		cQuery += " AND A3_FILIAL='" + xFilial( "SA3" ) + "' " + LF
		//cQuery = "  AND SA1.D_E_L_E_T_ = '' " + LF 
		//cQuery = "  AND SE1.D_E_L_E_T_ = '' " + LF 
		//cQuery = "  AND SA3.D_E_L_E_T_ = '' " + LF 
	Else
		cQuery += " SF2.F2_CLIENTE = SA2.A2_COD AND SF2.F2_LOJA = SA2.A2_LOJA " + LF
		cQuery += " AND A2_FILIAL='" + xFilial( "SA2" ) + "' " + LF
		//cQuery += " AND SF2.F2_DOC = SE2.E2_NUM AND SF2.F2_SERIE = SE2.E2_PREFIXO " + LF
	Endif
	//cQuery = "  AND SF2.D_E_L_E_T_ = '' " + LF 
	cQuery += "AND SF2.F2_COND = SE4.E4_CODIGO " + LF
	cQuery += "AND SF2.F2_DOC = '" + cNota + "' AND SF2.F2_SERIE = '" + cSerie + "'  AND SF2.F2_TIPO = '" + Alltrim(cTipo) + "' " + LF
    // INCLUIDO EM 24/03/2011
    //cQuery += "AND F2_TIPO='N'   " + LF
    cQuery += "AND F2_FILIAL='" + xFilial( "SF2" ) + "' " + LF     
	If Alltrim(cTipo) = "N"
		cQuery += "ORDER BY E1_VENCREA "  + LF    
	//Else
		//cQuery += "ORDER BY E2_VENCREA "  + LF    
	Endif
	MemoWrite("C:\Temp\MAILDEVNF.SQL",cQuery )
	
   	//cQuery := ChangeQuery( cQuery )
	If Select("NFCX") > 0
		DbSelectArea("NFCX")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "NFCX"
	If ! NFCX->( EoF() )
		NFCX->( DbGoTop() )
		// informacao do cliente
		cemail:=alltrim(NFCX->MAILCLI)
		//cemail:= "flavia.rocha@ravaembalagens.com.br"
		ccodcli:=NFCX->CODCLI
		cNomecli:=alltrim( NFCX->NOMECLI)
		If !Empty(NFCX->F2_CHVNFE)
			cTrans := "Sim - Chave: " + NFCX->F2_CHVNFE
		Else
			cTrans := "Nao"
		Endif
		oProcess:=TWFProcess():New("MAILDEVNF","Notificacao de NF cancelada")
		If Alltrim(cTipo) = "N"
			oProcess:NewTask('Inicio',"\workflow\http\emp01\mailNFcanc.htm")
		Else 
			oProcess:NewTask('Inicio',"\workflow\http\emp01\mailNFcanc_FORNEC.htm")
		Endif
		oHtml   := oProcess:oHtml
		_user := Subs(cUsuario,7,15)
		
		oHtml:ValByName( "cUser" 			 , Alltrim( _user ) )
		oHtml:ValByName( "dData" 			 , Date() )
		oHtml:ValByName( "cHora" 			 , Substring( Time(), 1, 5 ) )
		oHtml:ValByName( "cNF"				 , Alltrim( NFCX->F2_DOC ) )
		oHtml:ValByName( "cSerie"			 , Substring( NFCX->F2_SERIE, 1, 1 ) )
		oHtml:ValByName( "dEmissao"		 , StoD( NFCX->F2_EMISSAO ) )
		oHtml:ValByName( "cCodCli"		 , Alltrim( NFCX->CODCLI ) )
		oHtml:ValByName( "cNomeCli"		 , Alltrim( NFCX->NOMECLI ) ) 
		If Alltrim(cTipo) = "N"
			oHtml:ValByName( "cCodRep" 		 , Alltrim( NFCX->A3_COD ) )
			oHtml:ValByName( "cNomeRep"		 , Alltrim( NFCX->A3_NOME ) )
			aadd( oHtml:ValByName( "it.dDataVenc" ), StoD( NFCX->VENCREA ) )
			aadd( oHtml:ValByName( "it.nValorPar" ), Transform( NFCX->VALOR, '@E 999,999.99' ) )
			cVenc := NFCX->VENCREA
			nTotNF += NFCX->VALOR 
			aadd( oHtml:ValByName( "it.cCondPag" ) , '&nbsp;&nbsp;&nbsp; <b>Cond. Pag.:</b> ' + Alltrim( NFCX->E4_DESCRI ) )
		Else 
			
			//cVenc := NFCX->E2_VENCREA
			nTotNF += NFCX->F2_VALBRUT //E2_VALOR 
		Endif
						
		While ! NFCX->( EoF() )
			If Alltrim(cTipo) = "N"
				If cVenc == NFCX->VENCREA
					NFCX->( DbSkip() )
				Else
					aadd( oHtml:ValByName( "it.cCondPag" ) , '&nbsp;' )
					aadd( oHtml:ValByName( "it.dDataVenc" ), StoD( NFCX->VENCREA ) )
					aadd( oHtml:ValByName( "it.nValorPar" ), Transform( NFCX->VALOR, '@E 999,999.99' ) )
					cVenc := NFCX->VENCREA
					nTotNF += NFCX->VALOR
				Endif
				
			//Else
				//nTotNF += NFCX->F2_VALBRUT 
			EndIf
			NFCX->( DbSkip() )
		EndDo
		oHtml:ValByName( "nTotNF" , Transform( nTotNF, '@E 999,999.99' ) )
		
		cQuery2 := " SELECT SD2.D2_COD, SB1.B1_DESC, SD2.D2_QUANT, SD2.D2_UM, D2_QTSEGUM, SD2.D2_SEGUM, SD2.D2_PRCVEN, SD2.D2_TOTAL " + LF
		cQuery2 += " FROM " +  RetSqlName("SD2")  + " SD2, " + LF
		cQuery2 += "      " +  RetSqlName("SB1")  + " SB1 " + LF
		cQuery2 += " WHERE SD2.D2_COD = SB1.B1_COD AND SD2.D2_LOCAL = SB1.B1_LOCPAD " + LF
		cQuery2 += " AND D2_DOC = '" + cNota + "' AND D2_SERIE = '" + cSerie + "' " + LF
		// INCLUIDO EM 24/03/2011
	
		cQuery2 += " AND D2_TIPO ='"+ Alltrim(cTipo) + "' " + LF
	    cQuery2 += " AND D2_FILIAL='" + xFilial( "SD2" ) + "' " + LF
	    cQuery2 += " AND B1_FILIAL='" + xFilial( "SB1" ) + "' "   + LF
	
		cQuery2 += "ORDER BY D2_COD " + LF
		MemoWrite("C:\Temp\MAILDEVD2.SQL",cQuery2 )
		cQuery2 := ChangeQuery( cQuery2 )
		TCQUERY cQuery2 NEW ALIAS "NFCY"
		NFCY->( DbGoTop() )
		cCodProd := NFCY->D2_COD
		nTotPd := 0
		While ! NFCY->( EoF() )
			If cCodProd == NFCY->D2_COD
				NFCY->( DbSkip() )
			Else
				aadd( oHtml:ValByName( "in.cCod" ) 		, Alltrim( NFCY->D2_COD ) )
				aadd( oHtml:ValByName( "in.cDesc" )		, Alltrim( NFCY->B1_DESC ) )
				aadd( oHtml:ValByName( "in.nQtd" )		, Transform( NFCY->D2_QUANT, '@E 999,999.99' ) )
				aadd( oHtml:ValByName( "in.cUn"	)  		, Alltrim( NFCY->D2_UM ) )
				aadd( oHtml:ValByName( "in.n2Qtd" )		, Transform( NFCY->D2_QTSEGUM, '@E 999,999.99' ) )
				aadd( oHtml:ValByName( "in.c2Un" )		, Alltrim( NFCY->D2_SEGUM ) )
				aadd( oHtml:ValByName( "in.nPco" )		, Transform( NFCY->D2_PRCVEN, '@E 999,999.99' ) )
				aadd( oHtml:ValByName( "in.nPcoTot" )	, Transform( NFCY->D2_TOTAL, '@E 999,999.99' ) )
				cCodProd := NFCY->D2_COD
				nTotPd += NFCY->D2_TOTAL
				NFCY->( DbSkip() )
			EndIf
		EndDo
		oHtml:ValByName("nTotPd"	, Transform( nTotPd, '@E 999,999.99') )
	
		////
		// JUSTIFICATIVA DE CANCELAMENTO
		DbselectArea("Z75")
		Dbsetorder(1)
		Z75->(Dbseek(xFilial("Z75")+cNota+cSerie))
		oHtml:ValByName( "cJust", Alltrim( Z75->Z75_JUSTCA ) )
		oHtml:ValByName( "cTrans", Alltrim( cTrans ) )
	
		//
		oProcess:ClientName(_user)
		eEmail := "financeiro@ravaembalagens.com.br;faturamento@ravaembalagens.com.br;comercial@ravaembalagens.com.br;contabilidade@ravaembalagens.com.br;roberta.gomes@ravaembalagens.com.br"
		//eEmail += ";orley@ravaembalagens.com.br"
		//eEmail += ";flavia.rocha@ravaembalagens.com.br"
		// EMAIL PARA O CLIENTE
		If !empty( cemail)
		   eEmail +=";"+alltrim( cemail) 
		else
		   cMailTo := "daniela@ravaembalagens.com.br"
	       cAssun  := "Email do Cliente "+ccodcli+" - "+alltrim( cNomecli)+" nao cadastrado"
	       cCorpo  := " O Email do Cliente "+ccodcli+" - "+alltrim( cNomecli)+" nao esta cadastrado, por isso ele nao recebeu o cancelamento da nota: "+alltrim(cNota)+" Serie: "+alltrim(cSerie)    
	       U_EnviaMail(cMailTo,cAssun,cCorpo)      
		endif
		//
		oProcess:cTo := eEmail
		subj := "Nota Fiscal CANCELADA por " + Alltrim( _user )
		oProcess:cSubject  := subj
	 	oProcess:Start()
		WfSendMail()
		Sleep( 2000 ) //aguarda 2 seg para que o e-mail seja enviado
		oProcess:Finish()
		NFCX->( DbCloseArea() )
		NFCY->( DbCloseArea() )
	
	Endif
	
	

Return
