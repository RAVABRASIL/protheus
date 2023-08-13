#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"

***************************
User Function MailTransp( cNota, cSerie, nOP )
***************************
LOCAL lAmost:=.F.
	If Alltrim( cSerie ) != ' '

		SetPrvt("nTotNF,cQuery,eEmail,oProcess,oHtml,_user,cProd")
		SetPrvt("cVenc,nTotNF,cQuery2,nTotQt,subj")

		cQuery := "SELECT SD2.D2_TES,SF2.F2_TRANSP, SA4.A4_NOME, SA4.A4_EMAIL, SF2.F2_DOC, SA1.A1_MUN, SF2.F2_EST, SF2.F2_PBRUTO, SF2.F2_VALBRUT, SD2.D2_COD, SD2.D2_QUANT "
		cQuery += "FROM " + RetSqlName('SF2') + " SF2, " + RetSqlName('SA4') + " SA4, " + RetSqlName('SD2') + " SD2, " + RetSqlName('SA1') + " SA1 "
		cQuery += "WHERE SF2.F2_TRANSP = SA4.A4_COD "
		cQuery += "AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE "
		cQuery += "AND SF2.F2_CLIENTE = SA1.A1_COD "
		cQuery += "AND SF2.F2_DOC = '" + cNota + "' AND SF2.F2_SERIE =  '" + cSerie + "' "    
		cQuery += "AND F2_TIPO='N'  "
		cQuery += "AND SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND SF2.D_E_L_E_T_ = ' ' "
		cQuery += "AND SA4.A4_FILIAL = '" + xFilial( "SA4" ) + "' AND SA4.D_E_L_E_T_ = ' ' "
		cQuery += "AND SD2.D2_FILIAL = '" + xFilial( "SD2" ) + "' AND SD2.D_E_L_E_T_ = ' ' "
		cQuery += "AND SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery( cQuery )
		
		If Select("TRAX") > 0
           DbSelectArea("TRAX")
           TRAX->(DbCloseArea())
        EndIf
		
		TCQUERY cQuery NEW ALIAS "TRAX"
		TRAX->( DbGoTop() )

		nTotQt := 0

		While ! TRAX->( EoF() )

			If Len( Alltrim( TRAX->D2_COD ) ) <= 7
  			cProd := TRAX->D2_COD
			Else
  			If Subs( TRAX->D2_COD, 5, 1 ) == "R"
			 		cProd := Padr( Subs( TRAX->D2_COD, 1, 1 ) + Subs( TRAX->D2_COD, 3, 4 ) + Subs( TRAX->D2_COD, 8, 2 ), 15 )
			  Else
					cProd := Padr( Subs( TRAX->D2_COD, 1, 1 ) + Subs( TRAX->D2_COD, 3, 3 ) + Subs( TRAX->D2_COD, 7, 2 ), 15 )
				EndIf
			EndIf

			dbselectarea( 'SB5' )
			SB5->( dbsetorder( 1 ) )
			SB5->( DbSeek( xFilial('SB5') + cProd ) )

			nTotQt += TRAX->D2_QUANT/(SB5->B5_QTDFIM/SB5->B5_QE2)

			// verifica se e amostra incluido em 29/06/2011 por antonio
			if ALLTRIM(TRAX->D2_TES) $'516'
			   lAmost:=.T.
			endif
			//
			
			TRAX->( DbSkip() )

		EndDo

		If Alltrim( TRAX->A4_EMAIL ) != ' '

			TRAX->( DbGoTop() )
			If nOP == 1
				oProcess := TWFProcess():New("MailTransp","Envio de e-mail para transportadora")
				oProcess:NewTask('Inicio',"\workflow\http\emp01\mailtransp.htm")
			ElseIf nOP == 2
				oProcess := TWFProcess():New("MailTransp","Cancelamento de e-mail para transportadora")
				oProcess:NewTask('Inicio',"\workflow\http\emp01\cancmailtransp.htm")
			EndIf
			oHtml   := oProcess:oHtml
			_user := Subs(cUsuario,7,15)
			oHtml:ValByName( "cTransp" 	, Alltrim( TRAX->A4_NOME ) )
			oHtml:ValByName( "cNF" 		  , Alltrim( TRAX->F2_DOC ) )
			oHtml:ValByName( "cDestino" , Alltrim( TRAX->A1_MUN ) )
			oHtml:ValByName( "cUF" 		  , Alltrim( TRAX->F2_EST ) )
			oHtml:ValByName( "nPeso" 	  , Transform( TRAX->F2_PBRUTO, '@E 999,999.99' ) )
			oHtml:ValByName( "nQtdVol"  , Round( nTotQt, 0 ) )
			oHtml:ValByName( "nValor"   , Transform( TRAX->F2_VALBRUT, '@E 999,999.99' ) )
            oHtml:ValByName( "cAmostra" , iif(lAmost,'Sim','Nao') )

			oProcess:ClientName( _user )
			If nOP == 1
	 		 	If !MsgBox( OemToAnsi( "Envia e-mail NOTIFICANDO a Transportadora e o Setor Faturamento (YES) ou apenas o Setor Faturamento (NO)?" ), "Escolha", "YESNO" )
					eEmail := "joao.emanuel@ravaembalagens.com.br"//"faturamento@ravaembalagens.com.br"
				Else
					eEmail := Alltrim( TRAX->A4_EMAIL ) + "; joao.emanuel@ravaembalagens.com.br"//"; faturamento@ravaembalagens.com.br"
				EndIf
			ElseIf nOP == 2
				If !MsgBox( OemToAnsi( "Envia e-mail de CANCELAMENTO para a Transportadora e o Setor Faturamento (YES) ou apenas o Setor Faturamento (NO)?" ), "Escolha", "YESNO" )
					eEmail :="joao.emanuel@ravaembalagens.com.br"//"faturamento@ravaembalagens.com.br; neto@ravaembalagens.com.br"
				Else
					eEmail := Alltrim( TRAX->A4_EMAIL ) + "; joao.emanuel@ravaembalagens.com.br"//"; faturamento@ravaembalagens.com.br; neto@ravaembalagens.com.br"
				EndIf
			EndIf
			oProcess:cTo	:= eEmail
			subj	:= "Solicitacao de coleta de mercadorias - RAVA Embalagens LTDA "
			oProcess:cSubject  := subj
 			oProcess:Start()
			WfSendMail()
			Sleep( 2000 ) //aguarda 2 seg para que o e-mail seja enviado
			oProcess:Finish()

			conOut( " " )
			conOut( "---------------------------------------------------------------------------" )
			conOut( "---------------------------------------------------------------------------" )
			conOut( "---------------------------------------------------------------------------" )
			conOut( "Programa de Solicitacao de Cotacao iniciado dia " + DtoC( Date() ) + " as " + Time() )// + " - NF: " + Alltrim( TRAX->F2_DOC )
			conOut( "---------------------------------------------------------------------------" )
			conOut( "---------------------------------------------------------------------------" )
			conOut( "---------------------------------------------------------------------------" )
			conOut( " " )

			TRAX->( DbCloseArea() )

		Else

			TRAX->( DbGoTop() )
			oProcess := TWFProcess():New("MailTransp","Cadastro de e-mail da transportadora")
			oProcess:NewTask('Inicio',"\workflow\http\emp01\mailtransp2.htm")
			oHtml   := oProcess:oHtml
			_user := Subs(cUsuario,7,15)

			oHtml:ValByName( "cCodTrans", Alltrim( TRAX->F2_TRANSP ) )
			oHtml:ValByName( "cTransp" 	, Alltrim( TRAX->A4_NOME ) )
			oHtml:ValByName( "cNF" 		  , Alltrim( TRAX->F2_DOC ) )
			oHtml:ValByName( "cDestino" , Alltrim( TRAX->A1_MUN ) )
			oHtml:ValByName( "cUF" 		  , Alltrim( TRAX->F2_EST ) )
			oHtml:ValByName( "nPeso" 	  , Transform( TRAX->F2_PBRUTO, '@E 999,999.99' ) )
			oHtml:ValByName( "nQtdVol"  , Round( nTotQt, 0 ) )
			oHtml:ValByName( "nValor"   , Transform( TRAX->F2_VALBRUT, '@E 999,999.99' ) )

			oProcess:ClientName( _user )
			eEmail := "joao.emanuel@ravaembalagens.com.br"//'faturamento@ravaembalagens.com.br'
			oProcess:cTo	:= eEmail
			subj	:= "Falha no envio do aviso de coleta para a transportadora " + Alltrim( TRAX->F2_TRANSP )
			oProcess:cSubject  := subj
 			oProcess:Start()
			WfSendMail()
			Sleep( 2000 ) //aguarda 2 seg para que o e-mail seja enviado
			oProcess:Finish()

			conOut( " " )
			conOut( "---------------------------------------------------------------------------" )
			conOut( "---------------------------------------------------------------------------" )
			conOut( "---------------------------------------------------------------------------" )
			conOut( "Programa de Solicitacao de Cotacao iniciado dia " + DtoC( Date() ) + " as " + Time() )// + " - NF: " + Alltrim( TRAX->F2_DOC )
			conOut( "---------------------------------------------------------------------------" )
			conOut( "---------------------------------------------------------------------------" )
			conOut( "---------------------------------------------------------------------------" )
			conOut( " " )

			TRAX->( DbCloseArea() )

		EndIf

		WfSendMail()
		Sleep( 2000 ) //aguarda 2 seg para que o e-mail seja enviado

	EndIf

Return
