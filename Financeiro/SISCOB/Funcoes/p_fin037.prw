#include "rwmake.ch"
#INCLUDE "XMLXFUN.CH"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥ FIN037   ≥ Autor ≥ Mauricio Barros       ≥ Data ≥ 14/03/06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Funcoes diversas p/ Equifax                                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Financeiro                                                 ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function FIN037( cTIPO, cCLIENTE )

Local cError   := ""
Local cWarning := ""
Local oScript
Local aRETORNO := {}, ;
			lRET     := .T., ;
			aREPET   := { { "R2", 1 }, ;  // Campos que podem ter repeticao
									  { "R4", 1 }, ;
									  { "R6", 1 }, ;
									  { "R8", 1 }, ;
									  { "T0", 1 }, ;
									  { "T1", 1 }, ;
									  { "8A", 1 }, ;
									  { "8C", 1 }, ;
									  { "8D", 1 }, ;
									  { "8F", 1 }, ;
									  { "8G", 1 }, ;
									  { "V1", 1 }, ;
									  { "V2", 1 }, ;
									  { "V3", 1 }, ;
									  { "V4", 1 }, ;
									  { "V5", 1 }, ;
									  { "V6", 1 }, ;
									  { "V7", 1 }, ;
									  { "V8", 1 }, ;
									  { "V9", 1 }, ;
									  { "VA", 1 } }, ;
			aDECIM   := { { "W3", 10 }, ;   // Para gravar decimais de acordo com layout
									  { "R6", 100 }, ;
									  { "82", 100 }, ;
									  { "84", 100 }, ;
									  { "86", 100 }, ;
									  { "8C", 100 }, ;
									  { "UL", 100 }, ;
									  { "UN", 100 }, ;
									  { "UO", 100 }, ;
									  { "UQ", 100 }, ;
									  { "V4", 100 }, ;
									  { "V5", 10 }, ;
									  { "V6", 10 }, ;
									  { "V7", 10 }, ;
									  { "V8", 10 }, ;
									  { "V9", 10 }, ;
									  { "VA", 10 } }

C_senha := Alltrim(GetMv("MV_SEQFAX"))

If cTIPO == "P"
   cRETORNO := HttpGet( "https://novoequifaxpessoal.equifax.com.br/PessoalPlusWeb/ConectarHttps?codigoCliente=11000249063&senha="+C_senha+ ;
	 						 "&layout=EFX11&stringConsulta=%3C%3Fxml+version%3D%221.0%22+encoding%3D%22ISO-8859-1%22%3F%3E%0D%0A%3CEFX11" + ;
	 						 "%3E%0D%0A%09%3Cheader%3E%0D%0A%09%09%3CtipoLayout%3EEFX11%3C%2FtipoLayout%3E%0D%0A%09%09%3CnumeroDocumento" + ;
	 						 "%3E" + Left( cCLIENTE, 11 ) + "%3C%2FnumeroDocumento%3E%0D%0A%09%09%3CtipoDocumento%3E2%3C%2FtipoDocumento%3E%0D%0A%09%09%3" + ;
	 						 "Cidentificacao%3E05%3C%2Fidentificacao%3E%0D%0A%09%09%3CdadosCadastrais%3ES%3C%2FdadosCadastrais%3E%0D%0A" + ;
	 						 "%09%09%3Clocalizacao%3ES%3C%2Flocalizacao%3E%0D%0A%09%09%3CinfoEleitoral%3EA%3C%2FinfoEleitoral%3E%0D%0A%09" + ;
	 						 "%09%3CparticipacoesEmpresas%3ES%3C%2FparticipacoesEmpresas%3E%0D%0A%09%09%3CconsultasCPF%3ES%3C%2FconsultasCPF" + ;
	 						 "%3E%0D%0A%09%09%3CconsultasCheques%3ES%3C%2FconsultasCheques%3E%0D%0A%09%09%3CtitulosVencidosNaoPagos%3ES%3C%2" + ;
	 						 "FtitulosVencidosNaoPagos%3E%0D%0A%09%09%3CchequesSemFundos%3ES%3C%2FchequesSemFundos%3E%0D%0A%09%09%3Cprotestos" + ;
	 						 "%3ES%3C%2Fprotestos%3E%0D%0A%09%09%3CparticipacaoFalencias%3ES%3C%2FparticipacaoFalencias%3E%0D%0A%09%09%3" + ;
	 						 "CinformacoesComplementares%3ES%3C%2FinformacoesComplementares%3E%0D%0A%09%3C%2Fheader%3E%0D%0A%3C%2FEFX11%3E" + ;
	 						 "%0D%0A++++++++++++++++++++++++++++" )
Else
	 cRETORNO := HttpGet( "https://consulta.equifax.com.br/c%5Fremota%5Fnova.asp?Strcons=11000249063"+C_senha+ cTIPO + Left( cCLIENTE, 14 ) )
EndIf

If cTIPO == "P"  // Equifax Pessoal
		If cRETORNO == NIL
 			 MsgStop( OemToAnsi( "Erro no acesso a internet" ) )
			 Return .F.
		EndIf
		oScript := XmlParser( cRETORNO, "_", @cError, @cWarning )
		Memowrit( "EQUIFAX.TXT", cRETORNO )
		If XmlChildEx( oSCRIPT:_EFX11:_MENSAGENS, "_CODIGO" ) <> NIL
				If ValType( oSCRIPT:_EFX11:_MENSAGENS:_CODIGO ) <> "A"
					 If oSCRIPT:_EFX11:_MENSAGENS:_CODIGO:TEXT <> '501'
					  	MsgStop( OemToAnsi( oSCRIPT:_EFX11:_MENSAGENS:_CODIGO:TEXT + " - " + oSCRIPT:_EFX11:_MENSAGENS:_MENSAGEM:TEXT ) )
						  Return .F.
					 Endif
				Else
					 For nCONT := 1 To Len( oSCRIPT:_EFX11:_MENSAGENS:_CODIGO )
				 			If oSCRIPT:_EFX11:_MENSAGENS:_CODIGO[nCONT]:TEXT < '500'
				 				 MsgStop( OemToAnsi( oSCRIPT:_EFX11:_MENSAGENS:_CODIGO[nCONT]:TEXT + " - " + oSCRIPT:_EFX11:_MENSAGENS:_MENSAGEM[nCONT]:TEXT ) )
				 				 Return .F.
				 			Endif
					 Next
				EndIf
		EndIf
	 	Reclock( "ZAI", ! ZAI->( Dbseek( xFilial() + SA1->A1_COD + SA1->A1_LOJA + "P" ) ) )
	 	ZAI->ZAI_CODCLI := SA1->A1_COD
	 	ZAI->ZAI_LOJA   := SA1->A1_LOJA
	 	ZAI->ZAI_TIPO   := "P"
	 	ZAI->ZAI_DATA   := Date()
		If XmlChildEx( oSCRIPT:_EFX11:_HEADER, "_DATACONSULTA" ) <> NIL
 	 	   ZAI->ZAI_02 := Ctod( Left( oSCRIPT:_EFX11:_HEADER:_DATACONSULTA:TEXT, 2 ) + "/" + SubStr( oSCRIPT:_EFX11:_HEADER:_DATACONSULTA:TEXT, 3, 2 ) + "/" + Right( oSCRIPT:_EFX11:_HEADER:_DATACONSULTA:TEXT, 4 ) )
	 	   ZAI->ZAI_03 := oSCRIPT:_EFX11:_HEADER:_HORACONSULTA:TEXT
		Else
 	 	   ZAI->ZAI_02 := Date()
	 	   ZAI->ZAI_03 := Left( Time(), 2 ) + SubStr( Time(), 4, 2 ) + Right( TIme(), 2 )
		EndIf
		If ValType( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_IDENTIFICACAO ) == "A"
	 	   ZAI->ZAI_04 := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_IDENTIFICACAO[1]:_GRAFIA:TEXT
	 	   ZAI->ZAI_0C := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_IDENTIFICACAO[1]:_CPF:TEXT
		Else
	 	   ZAI->ZAI_04 := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_IDENTIFICACAO:_GRAFIA:TEXT
	 	   ZAI->ZAI_0C := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_IDENTIFICACAO:_CPF:TEXT
		EndIf
		If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS, "_LOCALIZACAO" ) <> NIL
			 If ValType( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO ) == "A"
					If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO[1], "_ENDERECO" ) <> NIL
  	 		 		 ZAI->ZAI_11 := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO[1]:_ENDERECO:TEXT
					EndIf
					If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO[1], "_BAIRRO" ) <> NIL
		 		 		 ZAI->ZAI_13 := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO[1]:_BAIRRO:TEXT
					EndIf
					If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO[1], "_CEP" ) <> NIL
   	 		 		 ZAI->ZAI_14 := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO[1]:_CEP:TEXT
					EndIf
					If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO[1], "_CIDADE" ) <> NIL
	 		 		   ZAI->ZAI_15 := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO[1]:_CIDADE:TEXT
					EndIf
					If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO[1], "_UF" ) <> NIL
	 		 			 ZAI->ZAI_17 := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO[1]:_UF:TEXT
					EndIf
			 Else
					If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO, "_ENDERECO" ) <> NIL
  	 		 		 ZAI->ZAI_11 := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO:_ENDERECO:TEXT
					EndIf
					If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO, "_BAIRRO" ) <> NIL
		 		 		 ZAI->ZAI_13 := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO:_BAIRRO:TEXT
					EndIf
					If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO, "_CEP" ) <> NIL
   	 		 		 ZAI->ZAI_14 := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO:_CEP:TEXT
					EndIf
					If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO, "_CIDADE" ) <> NIL
	 		 		   ZAI->ZAI_15 := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO:_CIDADE:TEXT
					EndIf
					If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO, "_UF" ) <> NIL
	 		 			 ZAI->ZAI_17 := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_LOCALIZACAO:_UF:TEXT
					EndIf
			 EndIf
		EndIf
		If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS, "_DADOSCADASTRAIS" ) <> NIL
			 If ValType( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_DADOSCADASTRAIS ) == "A"
					If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_DADOSCADASTRAIS[1], "_UFEMISSOR" ) <> NIL
	 			     ZAI->ZAI_0G := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_DADOSCADASTRAIS[1]:_UFEMISSOR:TEXT
					EndIf
			 Else
					If XmlChildEx( oSCRIPT:_EFX11:_LISTADEGRAFIAS:_DADOSCADASTRAIS, "_UFEMISSOR" ) <> NIL
	 	 			   ZAI->ZAI_0G := oSCRIPT:_EFX11:_LISTADEGRAFIAS:_DADOSCADASTRAIS:_UFEMISSOR:TEXT
					EndIf
			 EndIf
		EndIf
		If XmlChildEx( oSCRIPT:_EFX11, "_LISTADEPARTICIPACOESOUTRASEMPRESAS" ) <> NIL
	 		 If ValType( oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS ) == "A"
					For nCONT := 1 To Len( oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS )
						 cCONT := Str( nCONT, 1 )
							If XmlChildEx( oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS[ &cCONT ], "_CNPJ" ) == NIL
								 Exit
							EndIf
							cVAR := "ZAI_R3_" + StrZero( nCONT, 2 )
	 						ZAI->&cVAR := oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS[nCONT]:_CNPJ:TEXT
							cVAR := "ZAI_R4_" + StrZero( nCONT, 2 )
	 						ZAI->&cVAR := oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS[nCONT]:_EMPRESA:TEXT
							cVAR := "ZAI_R6_" + StrZero( nCONT, 2 )
	 						ZAI->&cVAR := Val( oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS[nCONT]:_PARTICIPACAO:TEXT )
							cVAR := "ZAI_R8_" + StrZero( nCONT, 2 )
//             ZAI->&cVAR := Ctod( "01/" + Right( oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS:_ENTRADAEMPRESA[nCONT]:TEXT, 2 ) + ;
//                 "/" + Left( oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS:_ENTRADAEMPRESA[nCONT]:TEXT, 4 ) )
					Next
	 		 Else
	 				ZAI->ZAI_R3_01 := oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS:_CNPJ:TEXT
	 				ZAI->ZAI_R4_01 := oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS:_EMPRESA:TEXT
	 				ZAI->ZAI_R6_01 := Val( oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS:_PARTICIPACAO:TEXT )
//         ZAI->ZAI_R8_01 := Ctod( "01/" + Right( oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS:_ENTRADAEMPRESA:TEXT, 2 ) + ;
//             "/" + Left( oSCRIPT:_EFX11:_LISTADEPARTICIPACOESOUTRASEMPRESAS:_PARTICIPACOESOUTRASEMPRESAS:_ENTRADAEMPRESA:TEXT, 4 ) )
	 		 EndIf
		EndIf
		If XmlChildEx( oSCRIPT:_EFX11, "_CONSULTASCPF" ) <> NIL
			 If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_QUANTIDADEMESATUAL" ) <> NIL
   			  ZAI->ZAI_20 := Val( oSCRIPT:_EFX11:_CONSULTASCPF:_QUANTIDADEMESATUAL:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_QUANTIDADEMES1" ) <> NIL
					ZAI->ZAI_21 := Val( oSCRIPT:_EFX11:_CONSULTASCPF:_QUANTIDADEMES1:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_QUANTIDADEMES2" ) <> NIL
					ZAI->ZAI_22 := Val( oSCRIPT:_EFX11:_CONSULTASCPF:_QUANTIDADEMES2:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_QUANTIDADEMES3" ) <> NIL
					ZAI->ZAI_23 := Val( oSCRIPT:_EFX11:_CONSULTASCPF:_QUANTIDADEMES3:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_QUANTIDADEMES4" ) <> NIL
					ZAI->ZAI_24 := Val( oSCRIPT:_EFX11:_CONSULTASCPF:_QUANTIDADEMES4:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_QUANTIDADEMES5" ) <> NIL
					ZAI->ZAI_25 := Val( oSCRIPT:_EFX11:_CONSULTASCPF:_QUANTIDADEMES5:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_QUANTIDADEMES6" ) <> NIL
					ZAI->ZAI_26 := Val( oSCRIPT:_EFX11:_CONSULTASCPF:_QUANTIDADEMES6:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_QUANTIDADEMES7" ) <> NIL
					ZAI->ZAI_27 := Val( oSCRIPT:_EFX11:_CONSULTASCPF:_QUANTIDADEMES7:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_QUANTIDADEMES8" ) <> NIL
					ZAI->ZAI_28 := Val( oSCRIPT:_EFX11:_CONSULTASCPF:_QUANTIDADEMES8:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_QUANTIDADEMES9" ) <> NIL
					ZAI->ZAI_29 := Val( oSCRIPT:_EFX11:_CONSULTASCPF:_QUANTIDADEMES9:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_QUANTIDADEMES10" ) <> NIL
					ZAI->ZAI_2A := Val( oSCRIPT:_EFX11:_CONSULTASCPF:_QUANTIDADEMES10:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_QUANTIDADEMES11" ) <> NIL
					ZAI->ZAI_2B := Val( oSCRIPT:_EFX11:_CONSULTASCPF:_QUANTIDADEMES11:TEXT )
			 EndIf
				If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF, "_LISTACONSULTASCPF" ) <> NIL
	 				 If ValType( oSCRIPT:_EFX11:_CONSULTASCPF:_LISTACONSULTASCPF:_DETALHECONSULTA ) == "A"
							For nCONT := 1 To Len( oSCRIPT:_EFX11:_CONSULTASCPF:_LISTACONSULTASCPF:_DETALHECONSULTA )
								 cCONT := Str( nCONT, 1 )
									If XmlChildEx( oSCRIPT:_EFX11:_CONSULTASCPF:_LISTACONSULTASCPF:_DETALHECONSULTA[ &cCONT ], "_DATAOCORRENCIA" ) == NIL
										 Exit
									EndIf
									cVAR := "ZAI_T0_" + StrZero( nCONT, 2 )
	 								ZAI->&cVAR := Ctod( Right( oSCRIPT:_EFX11:_CONSULTASCPF:_LISTACONSULTASCPF:_DETALHECONSULTA[nCONT]:_DATAOCORRENCIA:TEXT, 2 ) + ;
 	 										"/" + SubStr( oSCRIPT:_EFX11:_CONSULTASCPF:_LISTACONSULTASCPF:_DETALHECONSULTA[nCONT]:_DATAOCORRENCIA:TEXT, 5, 2 ) + ;
	 										"/" + Left( oSCRIPT:_EFX11:_CONSULTASCPF:_LISTACONSULTASCPF:_DETALHECONSULTA[nCONT]:_DATAOCORRENCIA:TEXT, 4 ) )
									cVAR := "ZAI_T1_" + StrZero( nCONT, 2 )
	 								ZAI->&cVAR := oSCRIPT:_EFX11:_CONSULTASCPF:_LISTACONSULTASCPF:_DETALHECONSULTA[nCONT]:_DATAOCORRENCIA:TEXT

							Next
	 				 Else
	 						ZAI->ZAI_T0_01 := Ctod( Right( oSCRIPT:_EFX11:_CONSULTASCPF:_LISTACONSULTASCPF:_DETALHECONSULTA:_DATAOCORRENCIA:TEXT, 2 ) + ;
 	 								"/" + SubStr( oSCRIPT:_EFX11:_CONSULTASCPF:_LISTACONSULTASCPF:_DETALHECONSULTA:_DATAOCORRENCIA:TEXT, 5, 2 ) + ;
	 								"/" + Left( oSCRIPT:_EFX11:_CONSULTASCPF:_LISTACONSULTASCPF:_DETALHECONSULTA:_DATAOCORRENCIA:TEXT, 4 ) )
	 						ZAI->ZAI_T1_01 := oSCRIPT:_EFX11:_CONSULTASCPF:_LISTACONSULTASCPF:_DETALHECONSULTA:_DATAOCORRENCIA:TEXT
	 				 EndIf
				EndIf
		EndIf
		If XmlChildEx( oSCRIPT:_EFX11, "_RESUMOCONSULTASCHEQUES" ) <> NIL
			 If XmlChildEx( oSCRIPT:_EFX11:_RESUMOCONSULTASCHEQUES, "_QUANTIDADEATUAL" ) <> NIL
			 		ZAI->ZAI_U0 := Val( oSCRIPT:_EFX11:_RESUMOCONSULTASCHEQUES:_QUANTIDADEATUAL:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_RESUMOCONSULTASCHEQUES, "_QUANTIDADEMES1" ) <> NIL
			 		ZAI->ZAI_U1 := Val( oSCRIPT:_EFX11:_RESUMOCONSULTASCHEQUES:_QUANTIDADEMES1:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_RESUMOCONSULTASCHEQUES, "_QUANTIDADEMES2" ) <> NIL
			 		ZAI->ZAI_U2 := Val( oSCRIPT:_EFX11:_RESUMOCONSULTASCHEQUES:_QUANTIDADEMES2:TEXT )
			 EndIf
			 If XmlChildEx( oSCRIPT:_EFX11:_RESUMOCONSULTASCHEQUES, "_QUANTIDADEMES3" ) <> NIL
			 		ZAI->ZAI_U3 := Val( oSCRIPT:_EFX11:_RESUMOCONSULTASCHEQUES:_QUANTIDADEMES3:TEXT )
			 EndIf
		EndIf
		If XmlChildEx( oSCRIPT:_EFX11, "_TITULOSVENCIDOSNAOPAGOS" ) <> NIL
			 ZAI->ZAI_U4 := Val( oSCRIPT:_EFX11:_TITULOSVENCIDOSNAOPAGOS:_QUANTIDADETOTAL:TEXT )
		EndIf
		If XmlChildEx( oSCRIPT:_EFX11, "_CHEQUESSEMFUNDO" ) <> NIL
			 ZAI->ZAI_N1 := Val( oSCRIPT:_EFX11:_CHEQUESSEMFUNDO:_QUANTIDADETOTAL:TEXT )
	 		 ZAI->ZAI_N2 := Ctod( Right( oSCRIPT:_EFX11:_CHEQUESSEMFUNDO:_DATAULTOCORRENCIA:TEXT, 2 ) + ;
 	 					"/" + SubStr( oSCRIPT:_EFX11:_CHEQUESSEMFUNDO:_DATAULTOCORRENCIA:TEXT, 5, 2 ) + ;
	 					"/" + Left( oSCRIPT:_EFX11:_CHEQUESSEMFUNDO:_DATAULTOCORRENCIA:TEXT, 4 ) )
			 ZAI->ZAI_N3 := oSCRIPT:_EFX11:_CHEQUESSEMFUNDO:_BANCOULTOCORRENCIA:TEXT
			 ZAI->ZAI_N4 := Val( oSCRIPT:_EFX11:_CHEQUESSEMFUNDO:_AGENCIAULTOCORRENCIA:TEXT )
		EndIf
		If XmlChildEx( oSCRIPT:_EFX11, "_PROTESTOS" ) <> NIL
			 ZAI->ZAI_80 := Val( oSCRIPT:_EFX11:_PROTESTOS:_QUANTIDADETOTAL:TEXT )
			 cZAI_82     := StrTran( oSCRIPT:_EFX11:_PROTESTOS:_VALORTOTAL:TEXT, ".", "" )
			 ZAI->ZAI_82 := Val( StrTran( cZAI_82, ",", "." ) )
	 		 ZAI->ZAI_83 := Ctod( Right( oSCRIPT:_EFX11:_PROTESTOS:_DATAPRIMEIRO:TEXT, 2 ) + ;
 	 					"/" + SubStr( oSCRIPT:_EFX11:_PROTESTOS:_DATAPRIMEIRO:TEXT, 5, 2 ) + ;
	 					"/" + Left( oSCRIPT:_EFX11:_PROTESTOS:_DATAPRIMEIRO:TEXT, 4 ) )
			 cZAI_84     := StrTran( oSCRIPT:_EFX11:_PROTESTOS:_VALORPRIMEIRO:TEXT, ".", "" )
			 ZAI->ZAI_84 := Val( StrTran( cZAI_84, ",", "." ) )
	 		 ZAI->ZAI_85 := Ctod( Right( oSCRIPT:_EFX11:_PROTESTOS:_DATAMAIOR:TEXT, 2 ) + ;
 	 					"/" + SubStr( oSCRIPT:_EFX11:_PROTESTOS:_DATAMAIOR:TEXT, 5, 2 ) + ;
	 					"/" + Left( oSCRIPT:_EFX11:_PROTESTOS:_DATAMAIOR:TEXT, 4 ) )
			 cZAI_86     := StrTran( oSCRIPT:_EFX11:_PROTESTOS:_VALORMAIOR:TEXT, ".", "" )
			 ZAI->ZAI_86 := Val( StrTran( cZAI_86, ",", "." ) )
			 If XmlChildEx( oSCRIPT:_EFX11:_PROTESTOS, "_LISTAPROTESTOS" ) <> NIL
	 				 If ValType( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO ) == "A"
							For nCONT := 1 To Len( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO )
								 cCONT := Str( nCONT, 1 )
									If XmlChildEx( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO[ &cCONT ], "_CIDADE" ) == NIL
										 Exit
									EndIf
									cVAR := "ZAI_8A_" + StrZero( nCONT, 2 )
	 								ZAI->&cVAR := Ctod( Right( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO[nCONT]:_DATAOCORRENCIA:TEXT, 2 ) + ;
 	 										"/" + SubStr( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO[nCONT]:_DATAOCORRENCIA:TEXT, 5, 2 ) + ;
	 										"/" + Left( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO[nCONT]:_DATAOCORRENCIA:TEXT, 4 ) )
									cVAR  := "ZAI_8C_" + StrZero( nCONT, 2 )
	 								ccVAR := StrTran( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO[nCONT]:_VALOR:TEXT, ".", "" )
	 								ZAI->&cVAR := Val( StrTran( cCVAR, ",", "." ) )
									cVAR := "ZAI_8D_" + StrZero( nCONT, 2 )
	 								ZAI->&cVAR := oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO[nCONT]:_CIDADE:TEXT
									cVAR := "ZAI_8F_" + StrZero( nCONT, 2 )
	 								ZAI->&cVAR := oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO[nCONT]:_UF:TEXT
									cVAR := "ZAI_8G_" + StrZero( nCONT, 2 )
	 								ZAI->&cVAR := Val( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO[nCONT]:_NUMEROCARTORIO:TEXT )
							Next
	 				 Else
	 						ZAI->ZAI_8A_01 := Ctod( Right( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO:_DATAOCORRENCIA:TEXT, 2 ) + ;
 	 								"/" + SubStr( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO:_DATAOCORRENCIA:TEXT, 5, 2 ) + ;
	 								"/" + Left( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO:_DATAOCORRENCIA:TEXT, 4 ) )
	 						cZAI_8C_01     := StrTran( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO:_VALOR:TEXT, ".", "" )
	 						ZAI->ZAI_8C_01 := Val( StrTran( cZAI_8C_01, ",", "." ) )
	 						ZAI->ZAI_8D_01 := oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO:_CIDADE:TEXT
	 						ZAI->ZAI_8F_01 := oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO:_UF:TEXT
	 						ZAI->ZAI_8G_01 := Val( oSCRIPT:_EFX11:_PROTESTOS:_LISTAPROTESTOS:_DETALHEPROTESTO:_NUMEROCARTORIO:TEXT )
	 				 EndIf
			 EndIf
		EndIf
		If XmlChildEx( oSCRIPT:_EFX11, "_FALENCIASEMPRESARIAISASSOCIADAS" ) <> NIL
			 ZAI->ZAI_90 := Val( oSCRIPT:_EFX11:_FALENCIASEMPRESARIAISASSOCIADAS:_QUANTIDADEFALENCIAS:TEXT )
	 		 ZAI->ZAI_91 := Ctod( Right( oSCRIPT:_EFX11:_FALENCIASEMPRESARIAISASSOCIADAS:_DATAOCORRENCIAANTIGA:TEXT, 2 ) + ;
 	 					"/" + SubStr( oSCRIPT:_EFX11:_FALENCIASEMPRESARIAISASSOCIADAS:_DATAOCORRENCIAANTIGA:TEXT, 5, 2 ) + ;
	 					"/" + Left( oSCRIPT:_EFX11:__FALENCIASEMPRESARIAISASSOCIADAS:_DATAOCORRENCIAANTIGA:TEXT, 4 ) )
		EndIf
*/
	 	MsUnLock()
	 	Reclock( "SA1", .F. )
	 	SA1->A1_DTEQF := dDATABASE
	 	MsUnLock()
	 	MsgBox( "Dados do cliente atualizados com sucesso!", "Consulta Equifax", "INFO" )
Else     // Equifax Empresarial
		If cRETORNO == NIL
 			 MsgStop( OemToAnsi( "Erro no acesso a internet" ) )
			 lRET := .F.
		ElseIf SubStr( cRETORNO, 8, 1 ) <> "@"
			 If SubStr( cRETORNO, 8, 2 ) == "05"
				 MsgStop( OemToAnsi( "CÛdigo de cliente inv·lido" ) )
			 ElseIf SubStr( cRETORNO, 8, 2 ) == "06"
				 MsgStop( OemToAnsi( "Senha inv·lida" ) )
			 ElseIf SubStr( cRETORNO, 8, 2 ) == "07"
				 MsgStop( OemToAnsi( "Tipo de informaÁ„o inv·lida" ) )
			 ElseIf SubStr( cRETORNO, 8, 2 ) == "08"
				 MsgStop( OemToAnsi( "CNPJ inv·lido" ) )
			 ElseIf SubStr( cRETORNO, 8, 2 ) == "09"
				 MsgStop( OemToAnsi( "Formato inv·lido" ) )
			 ElseIf SubStr( cRETORNO, 8, 2 ) == "12"
				 MsgStop( OemToAnsi( "Tipo de consulta inv·lida" ) )
			 Else
				 MsgStop( OemToAnsi( "Erro no acesso a internet" ) )
			 EndIf
			 lRET := .F.
		Else
			 Do While .T.
					nPOS     := At( "@", cRETORNO )
					cRETORNO := SubStr( cRETORNO, nPOS + 1 )
					If ( nPOS := At( "@", cRETORNO ) ) > 0
					   Aadd( aRETORNO, { Substr( cRETORNO, 1, 2 ), Substr( cRETORNO, 3, nPOS - 3 ) } )
					   cRETORNO := SubStr( cRETORNO, nPOS )
					Else
					   Aadd( aRETORNO, { Substr( cRETORNO, 1, 2 ), Substr( cRETORNO, 3 ) } )
						 Exit
					EndIf
			 EndDo
			 Reclock( "ZAI", ! ZAI->( Dbseek( xFilial() + SA1->A1_COD + SA1->A1_LOJA + "E" ) ) )
			 ZAI->ZAI_CODCLI := SA1->A1_COD
			 ZAI->ZAI_LOJA   := SA1->A1_LOJA
			 ZAI->ZAI_TIPO   := "E"
			 ZAI->ZAI_DATA   := dDATABASE
			 For nCONT := 1 To Len( aRETORNO )
					 cVAR := "ZAI->ZAI_" + aRETORNO[ nCONT, 1 ]
					 If ( nPOS := Ascan( aREPET, {|X| X[1] = aRETORNO[ nCONT, 1 ] } ) ) > 0
							If Left( aREPET[ nPOS, 1 ], 1 ) <> "V" .and. aREPET[ nPOS, 2 ] > 5
								 Loop
							EndIf
							cVAR += "_" + StrZero( aREPET[ nPOS, 2 ]++, 2 )
					 EndIf
					 If Type( cVAR ) == "U"
							Loop
					 ElseIf Type( cVAR ) == "D"
		 					&( cVAR ) := Ctod( Left( aRETORNO[ nCONT, 2 ], 2 ) + "/" + SubStr( aRETORNO[ nCONT, 2 ], 3, 2 ) + "/" + Right( aRETORNO[ nCONT, 2 ], 4 ) )
					 ElseIf Type( cVAR ) == "N"
			 			  If ( nPOS := Ascan( aDECIM, {|X| X[1] = aRETORNO[ nCONT, 1 ] } ) ) > 0
								 &( cVAR ) := Val( aRETORNO[ nCONT, 2 ] ) / aDECIM[ nPOS, 2 ]
							Else
							   &( cVAR ) := Val( aRETORNO[ nCONT, 2 ] )
							EndIf
					 Else
							&( cVAR ) := aRETORNO[ nCONT, 2 ]
					 EndIf
			 Next
			 MsUnLock()
			 Reclock( "SA1", .F. )
			 SA1->A1_DTEQF := dDATABASE
			 MsUnLock()
			 MsgBox( "Dados do cliente atualizados com sucesso!", "Consulta Equifax", "INFO" )
		EndIf
EndIf
Return lRET



*************

User Function LeEqfEmp

*************

Local cTEXTO, ;
      cCRLF := Chr( 13 ) + Chr( 10 ), ;
			dDATA

cTEXTO := "                     E Q U I F A X   E M P R E S A R I A L" + cCRLF
cTEXTO += cCRLF
cTEXTO += "Data: " + StrZero( Day( ZAI->ZAI_02 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_02 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_02 ), 4 ) + ;
          "                                                 Hora: " + Left( ZAI->ZAI_03, 2 ) + ":" + SubStr( ZAI->ZAI_03, 3, 2 ) + ":" + Right( AllTrim( ZAI->ZAI_03 ), 2 ) + cCRLF
cTEXTO += cCRLF
cTEXTO += Trans( SA1->A1_CGC, PesqPict( "SA1", "A1_CGC" ) ) + cCRLF
cTEXTO += AllTrim( ZAI->ZAI_04 ) + " (" + SA1->A1_COD + ")" + cCRLF
cTEXTO += cCRLF
If ! Empty( ZAI->ZAI_0C )
	 cTEXTO += "RAZAO SOCIAL ANTERIOR: " + AllTrim( ZAI->ZAI_0C ) + cCRLF
EndIf
cTEXTO += "ENDERECO: " + AllTrim( ZAI->ZAI_10 ) + " " + AllTrim( ZAI->ZAI_11 ) + ", " + AllTrim( ZAI->ZAI_12 ) + " " + AllTrim( ZAI->ZAI_13 ) + cCRLF
cTEXTO += Left( ZAI->ZAI_14, 5 ) + "-" + Right( ZAI->ZAI_14, 3 ) + " " + ZAI->ZAI_17 + "-" + ZAI->ZAI_15 + cCRLF
cTEXTO += "DATA DE FUNDACAO: " + Left( MesExtenso( Val( Left( ZAI->ZAI_09, 2 ) ) ), 3 ) + "/" + Right( AllTrim( ZAI->ZAI_09 ), 4 ) + cCRLF
cTEXTO += "RAMO DE ATIVIDADE: " + ZAI->ZAI_0G + cCRLF
If ! Empty( ZAI->ZAI_W1 )
	 cTEXTO += cCRLF
	 cTEXTO += Repl( "-", 80 ) + cCRLF
	 cTEXTO += "EQUIFAX SCORE EMPRESARIAL" + cCRLF
	 cTEXTO += "SCORE: " + Str( ZAI->ZAI_W1, 3 ) + "  (999-MENOR RISCO  1-MAIOR RISCO)" + cCRLF
	 cTEXTO += "PROBABILIDADE MEDIA: " + Trans( ZAI->ZAI_W3, "@E 99.9%" ) + cCRLF
	 cTEXTO += "CLASSE DE RISCO: " + Str( ZAI->ZAI_W2, 1 ) + "  (1-MENOR RISCO  7-MAIOR RISCO)" + cCRLF
EndIf
If ! Empty( ZAI->ZAI_R4_01 )
	 cTEXTO += cCRLF
	 cTEXTO += Repl( "-", 80 ) + cCRLF
	 cTEXTO += "SOCIOS" + cCRLF
	 cTEXTO += "SOCIO: " + ZAI->ZAI_R4_01 + cCRLF
	 cTEXTO += "CPF: " + Trans( ZAI->ZAI_R2_01, "@R 999.999.999-99" ) + ", " + Trans( ZAI->ZAI_R6_01, "@E 999.99%" ) + " DE PARTICIPACAO" + cCRLF
	 If ! Empty( ZAI->ZAI_R4_02 )
	 	  cTEXTO += "SOCIO: " + ZAI->ZAI_R4_02 + cCRLF
	 	  cTEXTO += "CPF: " + Trans( ZAI->ZAI_R2_02, "@R 999.999.999-99" ) + ", " + Trans( ZAI->ZAI_R6_02, "@E 999.99%" ) + " DE PARTICIPACAO" + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_R4_03 )
			cTEXTO += "SOCIO: " + ZAI->ZAI_R4_03 + cCRLF
			cTEXTO += "CPF: " + Trans( ZAI->ZAI_R2_03, "@R 999.999.999-99" ) + ", " + Trans( ZAI->ZAI_R6_03, "@E 999.99%" ) + " DE PARTICIPACAO" + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_R4_04 )
			cTEXTO += "SOCIO: " + ZAI->ZAI_R4_04 + cCRLF
			cTEXTO += "CPF: " + Trans( ZAI->ZAI_R2_04, "@R 999.999.999-99" ) + ", " + Trans( ZAI->ZAI_R6_04, "@E 999.99%" ) + " DE PARTICIPACAO" + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_R4_05 )
			cTEXTO += "SOCIO: " + ZAI->ZAI_R4_05 + cCRLF
			cTEXTO += "CPF: " + Trans( ZAI->ZAI_R2_05, "@R 999.999.999-99" ) + ", " + Trans( ZAI->ZAI_R6_05, "@E 999.99%" ) + " DE PARTICIPACAO" + cCRLF
	 EndIf
EndIf
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += "CONSULTAS" + cCRLF
cTEXTO += "ATE " + StrZero( Day( ZAI->ZAI_02 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_02 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_02 ), 4 ) + "- " + Str( ZAI->ZAI_20, 4 )
dDATA  := FirstDay( ZAI->ZAI_02 ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_21, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_22, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_23, 4 ) + cCRLF
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 07 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_24, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_25, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_26, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_27, 4 ) + cCRLF
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 07 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_28, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_29, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_2A, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_2B, 4 ) + cCRLF
If ! Empty( ZAI->ZAI_T0_01 )
	 cTEXTO += "ULTIMAS:" + cCRLF
	 cTEXTO += "   DATA        EMPRESA" + cCRLF
	 cTEXTO += StrZero( Day( ZAI->ZAI_T0_01 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_T0_01 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_T0_01 ), 4 )
	 cTEXTO += Space( 04 ) + ZAI->ZAI_T1_01 + cCRLF
	 If ! Empty( ZAI->ZAI_T0_02 )
	 		cTEXTO += StrZero( Day( ZAI->ZAI_T0_02 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_T0_02 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_T0_02 ), 4 )
	 		cTEXTO += Space( 04 ) + ZAI->ZAI_T1_02 + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_T0_03 )
	 		cTEXTO += StrZero( Day( ZAI->ZAI_T0_03 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_T0_03 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_T0_03 ), 4 )
	 		cTEXTO += Space( 04 ) + ZAI->ZAI_T1_03 + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_T0_04 )
	 		cTEXTO += StrZero( Day( ZAI->ZAI_T0_04 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_T0_04 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_T0_04 ), 4 )
	 		cTEXTO += Space( 04 ) + ZAI->ZAI_T1_04 + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_T0_05 )
	 		cTEXTO += StrZero( Day( ZAI->ZAI_T0_05 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_T0_05 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_T0_05 ), 4 )
	 		cTEXTO += Space( 04 ) + ZAI->ZAI_T1_05 + cCRLF
	 EndIf
EndIf
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += "TEMPO DE RELACIONAMENTO COM FORNECEDORES" + cCRLF
cTEXTO += "      ATE  6 MESES: " + Str( ZAI->ZAI_U0, 4 ) + "      DE 1 ATE 2 ANOS: " + Str( ZAI->ZAI_U2, 4 ) + "      DE 6 ATE 10 ANOS: " + Str( ZAI->ZAI_U4, 4 ) + cCRLF
cTEXTO += "DE 7  ATE 12 MESES: " + Str( ZAI->ZAI_U1, 4 ) + "      DE 3 ATE 5 ANOS: " + Str( ZAI->ZAI_U3, 4 ) + "       MAIS DE 10 ANOS: " + Str( ZAI->ZAI_U5, 4 ) + cCRLF
If ! Empty( ZAI->ZAI_V4_01 )
	 cTEXTO += cCRLF
	 cTEXTO += Repl( "-", 80 ) + cCRLF
	 cTEXTO += "HISTORICO DE PAGAMENTOS NO ULTIMO ANO" + cCRLF
	 cTEXTO += "        FORNE-    QTDE.  VALOR TOTAL  PONTUAL  --- DIAS DE ATRASO (%) ---   ATR." + cCRLF
	 cTEXTO += "       CEDORES  TITULOS         (R$)      (%)   6-15  16-30  31-60   + 60  MEDIO" + cCRLF
	 cTEXTO += " TOTAL " + Str( ZAI->ZAI_V2_01, 7 ) + "  " + Str( ZAI->ZAI_V3_01, 7 ) + "   " + Trans( ZAI->ZAI_V4_01, "@E 99,999,999" ) + "    " + ;
  	 Trans( ZAI->ZAI_V5_01, "@E 999.9" ) + "  " + Trans( ZAI->ZAI_V6_01, "@E 999.9" ) + "  " + Trans( ZAI->ZAI_V7_01, "@E 999.9" ) + ;
		 "  " + Trans( ZAI->ZAI_V8_01, "@E 999.9" ) + "  " + Trans( ZAI->ZAI_V9_01, "@E 999.9" ) + "  " + Trans( ZAI->ZAI_VA_01, "@E 999.9" ) + cCRLF
	 aDATA := {}
	 For nCONT := 2 To 14
			cVAR1 := "ZAI->ZAI_V1_"  + StrZero( nCONT, 2 )
			cVAR2 := "ZAI->ZAI_V2_"  + StrZero( nCONT, 2 )
			cVAR3 := "ZAI->ZAI_V3_"  + StrZero( nCONT, 2 )
			cVAR4 := "ZAI->ZAI_V4_"  + StrZero( nCONT, 2 )
			cVAR5 := "ZAI->ZAI_V5_"  + StrZero( nCONT, 2 )
			cVAR6 := "ZAI->ZAI_V6_"  + StrZero( nCONT, 2 )
			cVAR7 := "ZAI->ZAI_V7_"  + StrZero( nCONT, 2 )
			cVAR8 := "ZAI->ZAI_V8_"  + StrZero( nCONT, 2 )
			cVAR9 := "ZAI->ZAI_V9_"  + StrZero( nCONT, 2 )
			cVARA := "ZAI->ZAI_VA_"  + StrZero( nCONT, 2 )
			Aadd( aDATA, { &cVAR1, &cVAR2, &cVAR3, &cVAR4, &cVAR5, &cVAR6, &cVAR7, &cVAR8, &cVAR9, &cVARA } )
	 Next
	 dDATA := FirstDay( ZAI->ZAI_02 ) - 1
	 For nCONT := 2 To 14
			If ( nPOS := Ascan( aDATA, {|X| X[1] = StrZero( Month( dDATA ), 2 ) + Str( Year( dDATA ), 4 ) } ) ) > 0
	 			 cTEXTO += Left( MesExtenso( Val( Left( aDATA[ nPOS, 1 ], 2 ) ) ), 3 ) + "/" + Right( AllTrim( aDATA[ nPOS, 1 ] ), 2 ) + " " + ;
   				 Str( aDATA[ nPOS, 2 ], 7 ) + "  " + Str( aDATA[ nPOS, 3 ], 7 ) + "   " + Trans( aDATA[ nPOS, 4 ], "@E 99,999,999" ) + "    " + ;
   				 Trans( aDATA[ nPOS, 5 ], "@E 999.9" ) + "  " + Trans( aDATA[ nPOS, 6 ], "@E 999.9" ) + "  " + Trans( aDATA[ nPOS, 7 ], "@E 999.9" ) + ;
	 				 "  " + Trans( aDATA[ nPOS, 8 ], "@E 999.9" ) + "  " + Trans( aDATA[ nPOS, 9 ], "@E 999.9" ) + "  " + Trans( aDATA[ nPOS, 10 ], "@E 999.9" ) + cCRLF
			Else
	 			 cTEXTO += Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Right( Str( Year( dDATA ), 4 ), 2 ) + cCRLF
			EndIf
			dDATA := FirstDay( dDATA ) - 1
	 Next
EndIf
If ! Empty( ZAI->ZAI_UL )
	 cTEXTO += cCRLF
	 cTEXTO += "MAIOR FATURA   " + Left( MesExtenso( Month( ZAI->ZAI_UM ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_UM ), 4 ) + "   R$ " + Trans( ZAI->ZAI_UL, "@E 99,999,999" ) + ;
  	 " - MEDIA DA MAIOR FATURA    R$ " + Trans( ZAI->ZAI_UN, "@E 99,999,999" ) + cCRLF
	 cTEXTO += "MAIOR ACUMULO  " + Left( MesExtenso( Month( ZAI->ZAI_UP ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_UP ), 4 ) + "   R$ " + Trans( ZAI->ZAI_UO, "@E 99,999,999" ) + ;
  	 " - MEDIA DO MAIOR ACUMULO   R$ " + Trans( ZAI->ZAI_UQ, "@E 99,999,999" ) + cCRLF
EndIf
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += "CHEQUES SEM FUNDO" + cCRLF
If Empty( ZAI->ZAI_N1 )
   cTEXTO += "NAO CONSTAM INFORMACOES." + cCRLF
Else
   cTEXTO += Str( ZAI->ZAI_N1, 4 ) + " CHEQUE(S) SEM FUNDO" + cCRLF
   cTEXTO += "     ULTIMO EM " + Left( MesExtenso( Month( ZAI->ZAI_N2 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_N2 ), 4 ) + " AGENCIA " + Str( ZAI->ZAI_N4, 4 ) + " DO " + ZAI->ZAI_N3 + cCRLF
EndIf
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += "PROTESTOS" + cCRLF
If Empty( ZAI->ZAI_80 )
   cTEXTO += "NAO CONSTAM INFORMACOES." + cCRLF
Else
   cTEXTO += Str( ZAI->ZAI_80, 4 ) + " PROTESTO(S) COM VALOR TOTAL DE                            R$ " + Trans( ZAI->ZAI_82, "@E 999,999.99" ) + cCRLF
   cTEXTO += "     PRIMEIRO: " + Left( MesExtenso( Month( ZAI->ZAI_83 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_83 ), 4 ) + "   R$ " + ;
	   Trans( ZAI->ZAI_84, "@E 999,999.99" ) + "      MAIOR: " + Left( MesExtenso( Month( ZAI->ZAI_85 ) ), 3 ) + "/" + ;
		 Str( Year( ZAI->ZAI_85 ), 4 ) + "   R$ " + Trans( ZAI->ZAI_86, "@E 999,999.99" ) + cCRLF
	 cTEXTO += "ULTIMOS:" + cCRLF
	 cTEXTO += "DATA DE OCORRENCIA   CARTORIO                                         VALOR" + cCRLF
	 cTEXTO += Left( MesExtenso( Month( ZAI->ZAI_8A_01 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_8A_01 ), 4 )
	 cTEXTO += Space( 12 ) + Str( ZAI->ZAI_8G_01, 2 ) + " CARTORIO DE " + ZAI->ZAI_8F_01 + "-" + Left( ZAI->ZAI_8D_01, 25 ) + "R$ " + Trans( ZAI->ZAI_8C_01, "@E 999,999.99" ) + cCRLF
	 If ! Empty( ZAI->ZAI_8A_02 )
	 		cTEXTO += Left( MesExtenso( Month( ZAI->ZAI_8A_02 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_8A_02 ), 4 )
	 		cTEXTO += Space( 12 ) + Str( ZAI->ZAI_8G_02, 2 ) + " CARTORIO DE " + ZAI->ZAI_8F_02 + "-" + Left( ZAI->ZAI_8D_02, 25 ) + "R$ " + Trans( ZAI->ZAI_8C_02, "@E 999,999.99" ) + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_8A_03 )
	 		cTEXTO += Left( MesExtenso( Month( ZAI->ZAI_8A_03 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_8A_03 ), 4 )
	 		cTEXTO += Space( 12 ) + Str( ZAI->ZAI_8G_03, 2 ) + " CARTORIO DE " + ZAI->ZAI_8F_03 + "-" + Left( ZAI->ZAI_8D_03, 25 ) + "R$ " + Trans( ZAI->ZAI_8C_03, "@E 999,999.99" ) + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_8A_04 )
	 		cTEXTO += Left( MesExtenso( Month( ZAI->ZAI_8A_04 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_8A_04 ), 4 )
	 		cTEXTO += Space( 12 ) + Str( ZAI->ZAI_8G_04, 2 ) + " CARTORIO DE " + ZAI->ZAI_8F_04 + "-" + Left( ZAI->ZAI_8D_04, 25 ) + "R$ " + Trans( ZAI->ZAI_8C_04, "@E 999,999.99" ) + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_8A_05 )
	 		cTEXTO += Left( MesExtenso( Month( ZAI->ZAI_8A_05 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_8A_05 ), 4 )
	 		cTEXTO += Space( 12 ) + Str( ZAI->ZAI_8G_05, 2 ) + " CARTORIO DE " + ZAI->ZAI_8F_05 + "-" + Left( ZAI->ZAI_8D_05, 25 ) + "R$ " + Trans( ZAI->ZAI_8C_05, "@E 999,999.99" ) + cCRLF
	 EndIf
EndIf
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += "ACOES" + cCRLF
If Empty( ZAI->ZAI_K0 ) .and. Empty( ZAI->ZAI_L0 ) .and. Empty( ZAI->ZAI_M0 )
   cTEXTO += "NAO CONSTAM INFORMACOES." + cCRLF
Else
   cTEXTO += Str( ZAI->ZAI_K0, 4 ) + " ACAO(OES) EXECUTIVA FAZENDA MUNICIPAL" + cCRLF
   cTEXTO += "     ULTIMA EM " + Left( MesExtenso( Month( ZAI->ZAI_K1 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_K1 ), 4 ) + "   " + Str( ZAI->ZAI_K5, 4 ) + " VARA DE " + AllTrim( ZAI->ZAI_K2 ) + " - " + ZAI->ZAI_K4 + cCRLF
	 If ! Empty( ZAI->ZAI_L0 )
   		cTEXTO += Str( ZAI->ZAI_L0, 4 ) + " ACAO(OES) EXECUTIVA FAZENDA ESTADUAL" + cCRLF
   		cTEXTO += "     ULTIMA EM " + Left( MesExtenso( Month( ZAI->ZAI_L1 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_L1 ), 4 ) + "   " + Str( ZAI->ZAI_L5, 4 ) + " VARA DE " + AllTrim( ZAI->ZAI_L2 ) + " - " + ZAI->ZAI_L4 + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_M0 )
   		cTEXTO += Str( ZAI->ZAI_M0, 4 ) + " ACAO(OES) EXECUTIVA FAZENDA FEDERAL" + cCRLF
   		cTEXTO += "     ULTIMA EM " + Left( MesExtenso( Month( ZAI->ZAI_M1 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_M1 ), 4 ) + "   " + Str( ZAI->ZAI_M5, 4 ) + " VARA DE " + AllTrim( ZAI->ZAI_M2 ) + " - " + ZAI->ZAI_M4 + cCRLF
	 EndIf
EndIf
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += "INFORMACOES MAIS RECENTES" + cCRLF
If Empty( ZAI->ZAI_30 )
   cTEXTO += "NAO CONSTAM INFORMACOES." + cCRLF
Else
	 SX5->( DbSeek( xFILIAL() + 'ZH' + StrZero( ZAI->ZAI_30, 2 ) + "    " ) )
   cTEXTO += Left( MesExtenso( Val( Left( ZAI->ZAI_31, 2 ) ) ), 3 ) + "/" + Right( ZAI->ZAI_31, 4 ) + "     " + SX5->X5_DESCRI + cCRLF
	 If ! Empty( ZAI->ZAI_32 )
	 		SX5->( DbSeek( xFILIAL() + 'ZH' + StrZero( ZAI->ZAI_32, 2 ) + "    " ) )
   		cTEXTO += Left( MesExtenso( Val( Left( ZAI->ZAI_33, 2 ) ) ), 3 ) + "/" + Right( ZAI->ZAI_33, 4 ) + "     " + SX5->X5_DESCRI + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_34 )
	 		SX5->( DbSeek( xFILIAL() + 'ZH' + StrZero( ZAI->ZAI_34, 2 ) + "    " ) )
   		cTEXTO += Left( MesExtenso( Val( Left( ZAI->ZAI_35, 2 ) ) ), 3 ) + "/" + Right( ZAI->ZAI_35, 4 ) + "     " + SX5->X5_DESCRI + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_36 )
	 		SX5->( DbSeek( xFILIAL() + 'ZH' + StrZero( ZAI->ZAI_36, 2 ) + "    " ) )
   		cTEXTO += Left( MesExtenso( Val( Left( ZAI->ZAI_37, 2 ) ) ), 3 ) + "/" + Right( ZAI->ZAI_37, 4 ) + "     " + SX5->X5_DESCRI + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_38 )
	 		SX5->( DbSeek( xFILIAL() + 'ZH' + StrZero( ZAI->ZAI_38, 2 ) + "    " ) )
   		cTEXTO += Left( MesExtenso( Val( Left( ZAI->ZAI_39, 2 ) ) ), 3 ) + "/" + Right( ZAI->ZAI_39, 4 ) + "     " + SX5->X5_DESCRI + cCRLF
	 EndIf
EndIf
Return cTEXTO



*************

User Function LeEqfPes

*************

Local cTEXTO, ;
      cCRLF := Chr( 13 ) + Chr( 10 ), ;
			dDATA

cTEXTO := Padc( "E Q U I F A X   P E S S O A L", 80 ) + cCRLF
cTEXTO += cCRLF
cTEXTO += "Data: " + StrZero( Day( ZAI->ZAI_02 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_02 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_02 ), 4 ) + ;
          "                                                 Hora: " + Left( ZAI->ZAI_03, 2 ) + ":" + SubStr( ZAI->ZAI_03, 3, 2 ) + ":" + Right( AllTrim( ZAI->ZAI_03 ), 2 ) + cCRLF
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += Padc( "I D E N T I F I C A C A O", 80 ) + cCRLF
cTEXTO += "CPF               " + Trans( AllTrim( ZAI->ZAI_0C ), "@R 999.999.999-99" ) + cCRLF
cTEXTO += "Nome              " + AllTrim( ZAI->ZAI_04 ) + " (" + SA1->A1_COD + ")" + cCRLF
*SX5->( DbSeek( xFILIAL() + '12' + AllTrim( ZAI->ZAI_0G ) + "    " ) )
*cTEXTO += "Regiao de origem  " + AllTrim( SX5->X5_DESCRI ) + cCRLF
*cTEXTO += "do CPF            " + cCRLF
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += Padc( "D A D O S   C A D A S T R A I S", 80 ) + cCRLF
cTEXTO += "Endereco    " + AllTrim( ZAI->ZAI_11 ) + " - " + Trans( ZAI->ZAI_14, "@R 99999-999" ) + " - " + AllTrim( ZAI->ZAI_13 ) + " - " + AllTrim( ZAI->ZAI_15 ) + " - " + AllTrim( ZAI->ZAI_17 ) + cCRLF
If ! Empty( ZAI->ZAI_R4_01 )
	 cTEXTO += cCRLF
	 cTEXTO += Repl( "-", 80 ) + cCRLF
	 cTEXTO += Padc( "P A R T I C I P A C O E S   E M   E M P R E S A S", 80 ) + cCRLF
	 cTEXTO += "CNPJ: " + Trans( ZAI->ZAI_R3_01, PesqPict( "SA1", "A1_CGC" ) ) + "  " + AllTrim( ZAI->ZAI_R4_01 ) + cCRLF
	 cTEXTO += "Tipo: Socio           Participacao: " + Trans( ZAI->ZAI_R6_01, "@E 999.99%" ) + "          Entrada: " + StrZero( Day( ZAI->ZAI_R8_01 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_R8_01 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_R8_01 ), 4 ) + cCRLF
	 If ! Empty( ZAI->ZAI_R4_02 )
	 		cTEXTO += "CNPJ: " + Trans( ZAI->ZAI_R3_02, PesqPict( "SA1", "A1_CGC" ) ) + "  " + AllTrim( ZAI->ZAI_R4_02 ) + cCRLF
	 		cTEXTO += "Tipo: Socio           Participacao: " + Trans( ZAI->ZAI_R6_02, "@E 999.99%" ) + "          Entrada: " + StrZero( Day( ZAI->ZAI_R8_02 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_R8_02 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_R8_02 ), 4 ) + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_R4_03 )
	 		cTEXTO += "CNPJ: " + Trans( ZAI->ZAI_R3_03, PesqPict( "SA1", "A1_CGC" ) ) + "  " + AllTrim( ZAI->ZAI_R4_03 ) + cCRLF
	 		cTEXTO += "Tipo: Socio           Participacao: " + Trans( ZAI->ZAI_R6_02, "@E 999.99%" ) + "          Entrada: " + StrZero( Day( ZAI->ZAI_R8_03 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_R8_03 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_R8_03 ), 4 ) + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_R4_04 )
	 		cTEXTO += "CNPJ: " + Trans( ZAI->ZAI_R3_04, PesqPict( "SA1", "A1_CGC" ) ) + "  " + AllTrim( ZAI->ZAI_R4_04 ) + cCRLF
	 		cTEXTO += "Tipo: Socio           Participacao: " + Trans( ZAI->ZAI_R6_02, "@E 999.99%" ) + "          Entrada: " + StrZero( Day( ZAI->ZAI_R8_04 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_R8_04 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_R8_04 ), 4 ) + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_R4_05 )
	 		cTEXTO += "CNPJ: " + Trans( ZAI->ZAI_R3_05, PesqPict( "SA1", "A1_CGC" ) ) + "  " + AllTrim( ZAI->ZAI_R4_05 ) + cCRLF
	 		cTEXTO += "Tipo: Socio           Participacao: " + Trans( ZAI->ZAI_R6_02, "@E 999.99%" ) + "          Entrada: " + StrZero( Day( ZAI->ZAI_R8_05 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_R8_05 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_R8_05 ), 4 ) + cCRLF
	 EndIf
EndIf
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += Padc( "C O N S U L T A S   A O   C P F", 80 ) + cCRLF
cTEXTO += Padc( "Total de consultas: " + Trans( ZAI->ZAI_20 + ZAI->ZAI_21 + ZAI->ZAI_22 + ZAI->ZAI_23 + ZAI->ZAI_24 + ZAI->ZAI_25 + ZAI->ZAI_26 + ZAI->ZAI_27 + ZAI->ZAI_28 + ZAI->ZAI_29 + ZAI->ZAI_2A + ZAI->ZAI_2B, "9999" ), 80 ) + cCRLF
cTEXTO += "ATE " + StrZero( Day( ZAI->ZAI_02 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_02 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_02 ), 4 ) + "- " + Str( ZAI->ZAI_20, 4 )
dDATA  := FirstDay( ZAI->ZAI_02 ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_21, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_22, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_23, 4 ) + cCRLF
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 07 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_24, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_25, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_26, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_27, 4 ) + cCRLF
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 07 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_28, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_29, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_2A, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_2B, 4 ) + cCRLF
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += Padc( "C O N S U L T A S   A   C H E Q U E S", 80 ) + cCRLF
cTEXTO += Padc( "Total de consultas: " + Trans( ZAI->ZAI_U0 + ZAI->ZAI_U1 + ZAI->ZAI_U2 + ZAI->ZAI_U3, "9999" ), 80 ) + cCRLF
cTEXTO += "ATE " + StrZero( Day( ZAI->ZAI_02 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_02 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_02 ), 4 ) + "- " + Str( ZAI->ZAI_U0, 4 )
dDATA  := FirstDay( ZAI->ZAI_02 ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_U1, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_U2, 4 )
dDATA  := FirstDay( dDATA ) - 1
cTEXTO += Space( 05 ) + Left( MesExtenso( Month( dDATA ) ), 3 ) + "/" + Str( Year( dDATA ), 4 ) + "- " + Str( ZAI->ZAI_U3, 4 ) + cCRLF
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += Padc( "T I T U L O S   V E N C I D O S   E   N A O   P A G O S", 80 ) + cCRLF
If Empty( ZAI->ZAI_U4 )
   cTEXTO += Padc( "NAO CONSTAM INFORMACOES.", 80 ) + cCRLF
Else
	 cTEXTO += Padc( "Total de titulos: " + Trans( ZAI->ZAI_U4, "9999" ), 80 ) + cCRLF
EndIf
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += Padc( "C H E Q U E S   S E M   F U N D O", 80 ) + cCRLF
If Empty( ZAI->ZAI_N1 )
   cTEXTO += Padc( "NAO CONSTAM INFORMACOES.", 80 ) + cCRLF
Else
	 cTEXTO += Padc( AllTrim( Trans( ZAI->ZAI_N1, "9999" ) ) + " cheque(s) sem fundo", 80 ) + cCRLF
	 cTEXTO += Padc( "Ultimas ocorrencias", 80 ) + cCRLF
	 cTEXTO += "Qtde.  Data ultimo   Banco                                  Agencia" + cCRLF
   cTEXTO += Trans( ZAI->ZAI_N1, "9999" ) + "   " + StrZero( Day( ZAI->ZAI_N2 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_N2 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_N2 ), 4 ) + "   " + ZAI->ZAI_N3 + "         " + Str( ZAI->ZAI_N4, 4 ) + cCRLF
EndIf
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += Padc( "P R O T E S T O S", 80 ) + cCRLF
If Empty( ZAI->ZAI_80 )
   cTEXTO += Padc( "NAO CONSTAM INFORMACOES.", 80 ) + cCRLF
Else
   cTEXTO += Str( ZAI->ZAI_80, 4 ) + " PROTESTO(S) COM VALOR TOTAL DE                            R$ " + Trans( ZAI->ZAI_82, "@E 999,999.99" ) + cCRLF
   cTEXTO += "     PRIMEIRO: " + Left( MesExtenso( Month( ZAI->ZAI_83 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_83 ), 4 ) + "   R$ " + ;
	   Trans( ZAI->ZAI_84, "@E 999,999.99" ) + "      MAIOR: " + Left( MesExtenso( Month( ZAI->ZAI_85 ) ), 3 ) + "/" + ;
		 Str( Year( ZAI->ZAI_85 ), 4 ) + "   R$ " + Trans( ZAI->ZAI_86, "@E 999,999.99" ) + cCRLF
	 cTEXTO += "ULTIMOS:" + cCRLF
	 cTEXTO += "DATA DE OCORRENCIA   CARTORIO                                          VALOR" + cCRLF
	 cTEXTO += Left( MesExtenso( Month( ZAI->ZAI_8A_01 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_8A_01 ), 4 )
	 cTEXTO += Space( 12 ) + Str( ZAI->ZAI_8G_01, 2 ) + " CARTORIO DE " + ZAI->ZAI_8F_01 + "-" + Left( ZAI->ZAI_8D_01, 25 ) + "R$ " + Trans( ZAI->ZAI_8C_01, "@E 999,999.99" ) + cCRLF
	 If ! Empty( ZAI->ZAI_8A_02 )
	 		cTEXTO += Left( MesExtenso( Month( ZAI->ZAI_8A_02 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_8A_02 ), 4 )
	 		cTEXTO += Space( 12 ) + Str( ZAI->ZAI_8G_02, 2 ) + " CARTORIO DE " + ZAI->ZAI_8F_02 + "-" + Left( ZAI->ZAI_8D_02, 25 ) + "R$ " + Trans( ZAI->ZAI_8C_02, "@E 999,999.99" ) + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_8A_03 )
	 		cTEXTO += Left( MesExtenso( Month( ZAI->ZAI_8A_03 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_8A_03 ), 4 )
	 		cTEXTO += Space( 12 ) + Str( ZAI->ZAI_8G_03, 2 ) + " CARTORIO DE " + ZAI->ZAI_8F_03 + "-" + Left( ZAI->ZAI_8D_03, 25 ) + "R$ " + Trans( ZAI->ZAI_8C_03, "@E 999,999.99" ) + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_8A_04 )
	 		cTEXTO += Left( MesExtenso( Month( ZAI->ZAI_8A_04 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_8A_04 ), 4 )
	 		cTEXTO += Space( 12 ) + Str( ZAI->ZAI_8G_04, 2 ) + " CARTORIO DE " + ZAI->ZAI_8F_04 + "-" + Left( ZAI->ZAI_8D_04, 25 ) + "R$ " + Trans( ZAI->ZAI_8C_04, "@E 999,999.99" ) + cCRLF
	 EndIf
	 If ! Empty( ZAI->ZAI_8A_05 )
	 		cTEXTO += Left( MesExtenso( Month( ZAI->ZAI_8A_05 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_8A_05 ), 4 )
	 		cTEXTO += Space( 12 ) + Str( ZAI->ZAI_8G_05, 2 ) + " CARTORIO DE " + ZAI->ZAI_8F_05 + "-" + Left( ZAI->ZAI_8D_05, 25 ) + "R$ " + Trans( ZAI->ZAI_8C_05, "@E 999,999.99" ) + cCRLF
	 EndIf
EndIf
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += Padc( "F A L E N C I A S   E M P R E S A R I A I S   D E C R E T A D A S", 80 ) + cCRLF
If Empty( ZAI->ZAI_90 )
   cTEXTO += Padc( "NAO CONSTAM INFORMACOES.", 80 ) + cCRLF
Else
   cTEXTO += AllTrim( Str( ZAI->ZAI_90, 4 ) ) + " FALENCIA(S)     MAIS ANTIGA: " + StrZero( Day( ZAI->ZAI_91 ), 2 ) + "/" + Left( MesExtenso( Month( ZAI->ZAI_91 ) ), 3 ) + "/" + Str( Year( ZAI->ZAI_91 ), 4 ) + cCRLF
EndIf
cTEXTO += cCRLF
cTEXTO += Repl( "-", 80 ) + cCRLF
cTEXTO += Padc( "O U T R A S   I N F O R M A C O E S", 80 ) + cCRLF
cTEXTO += Padc( "NAO CONSTAM INFORMACOES.", 80 ) + cCRLF
Return cTEXTO


/*
cRETORNO := "OmniStr@0001@0102982584000173@0224022006@03142628@04JOSE MARIA DE MELO ME " + ;
"@06FORTALEZA @071389@08CE@09021999@0A112000@0B23022006@0D52159@0GLOJAS DE" + ;
"DEPARTAMENTOS OU MAGAZINES @0H5215901@10RUA @11GENERAL SAMPAIO @12577 @13@1460020030@15FORTALEZA" + ;
"@161389@17CE@2600004@2700003@2900002@2A00001@3051@31012006@3282@33122005@3401@35102005@3682@37092005@3801@39092005@401@4100005" + ;
"@420000000044742@430000000168669@5000004@510000000123927@6400001@650000000044742@66005@67015@8000001@811@82000000000135000" + ;
"@8331072002@840000000135000@8531072002@860000000135000@8A31072002@8B1@8C0000000135000@8DFORTALEZA" + ;
"@8E1389@8FCE@8G05@N022022006@N100001@N211012006@N3BRADESCO@N40452@W1425@W205@W3544@T022082005@T1BRINQ MARALEX LTDA" + ;
"@T019082005@T1CONTRATUAL URBE SOC FOMENTO MERCL LTDA @T018082005@T1FRASNEW IND" + ;
"COM EMBALAGENS LTDA @T009082005@T1PLASMONT IND COM PLAST LTDA-EPP@T025072005@T1UNIBRAS REPRES S/C LTDA" + ;
"@U000000@U100001@U200003@U300001@U400000@U500000@U600000@U700000@U80000000000000@U900000@UA00000" + ;
"@UB0000000000000@UC00000@UD00000@UE0000000000000@UF00000@UG00000@UH0000000000000@UI00000@UJ00000000" + ;
"@UK0000000000000@UL0000000044671@UM29122005@UN0000000036700@UO0000000122650@UP01022005@UQ0000000052650" + ;
"@V1999999@V200005@V300000016@V40000000503056@V50722@V60278@V70000@V80000@V90000@VA0024@V1122005@V200001" + ;
"@V300000001@V40000000044671@V50000@V61000@V70000@V80000@V90000@VA0080@V1102005@V200001@V300000001@V40000000030600" + ;
"@V51000@V60000@V70000@V80000@V90000@VA0000@V1092005@V200002@V300000002@V40000000074095@V50498@V60502@V70000@V80000" + ;
"@V90000@VA0065@V1072005@V200001@V300000001@V40000000035216@V50000@V61000@V70000@V80000@V90000@VA0060@V1062005@V200002" + ;
"@V300000005@V40000000104731@V51000@V60000@V70000@V80000@V90000@VA0000@V1052005@V200001@V300000001@V40000000022876@V50000" + ;
"@V61000@V70000@V80000@V90000@VA0060@V1042005@V200001@V300000001@V40000000040883@V51000@V60000@V70000@V80000@V90000@VA0000" + ;
"@V1032005@V200002@V300000003@V40000000105900@V51000@V60000@V70000@V80000@V90000@VA0000@V1022005@V200001@V300000001@V40000000044084" + ;
"@V51000@V60000@V70000@V80000@V90000@VA0000"
*/
/*
EFX11 21032006 104750 15725871053 2 10 S S A S S S S S S S S ARAMIS JOSE PEREIRA GOMES 15725871053 19500930 SUPERIOR COM
 ARAMIS JOSE PEREIRA GOMES 15725871053 R ANDRADAS 1560 AP 904 CENTRO PORTO ALEGRE RS 90026900 51 02252791 ARAMIS JOSE PEREIRA GOMES
 15725871053 R ANDRADAS 1560 AP 904 CENTRO PORTO ALEGRE RS 90026900 51 02252791 ARAMIS JOSE PEREIRA GOMES 15725871053
 ARAMIS JOSE PEREIRA GOMES 15725871053 19500930 A 20050722 IRACY PEREIRA GOMES , RS ARAMIS JOSE PEREIRA GOMES 15725871053
 048046900469 ARAMIS JOSE PEREIRA GOMES Regular 22072005 113 53 AV PROTASIO ALVES, 3435
 ASSOCIACAO ISRAELITA - CIRCULO SOCIAL E PETROPOLIS PORTO ALEGRE RS 8 2 1 1 1 1 1 1 20060313 CONFIANCA CIA SEG 20060308
 CONFIANCA CIA SEG 20060203 TELECOMUNICACOES SAO PAULO S/A 20060103 TELECOMUNICACOES SAO PAULO S/A 20051020 TELECOMUNICACOES
 SAO PAULO S/A 20050901 TELECOMUNICACOES SAO PAULO S/A 20050830 TELECOMUNICACOES SAO PAULO S/A 20050722
 TELECOMUNICACOES SAO PAULO S/A 500 NAO CONSTA RESTRICOES PARA ESSE DOCUMENTO 501 CONSULTA CONCLUIDA
*/
/*
<?xml version="1.0" encoding="ISO-8859-1"?>
<efx11>
	<Header>
		<TipoLayout></TipoLayout>
		<DataConsulta></DataConsulta>
		<HoraConsulta></HoraConsulta>
		<NumeroDocumento></NumeroDocumento>
		<TipoDocumento></TipoDocumento>
		<Identificacao></Identificacao>
		<DadosCadastrais></DadosCadastrais>
		<Localizacao></Localizacao>
		<ParticipacoesEmpresas></ParticipacoesEmpresas>
		<ConsultasCpf></ConsultasCpf>
		<ConsultasCheques></ConsultasCheques>
		<TitulosVencidosNaoPago></TitulosVencidosNaoPago>
		<Cheques></Cheques>
		<Protestos></Protestos>
		<Falencia></Falencia>
		<InfoComplementar></InfoComplementar>
	</Header>
	<ListaDeGrafias>
			<Identificacao>
				<Grafia></Grafia>
				<CPF></CPF>
				<DataNascimento></DataNascimento>
				<Situacao></Situacao>
				<DataAtualiza></DataAtualiza>
			</Identificacao>
			<DadosCadastrais>
				<NomeMae></NomeMae>
				<TipoDoc></TipoDoc>
				<Numdoc></Numdoc>
				<orgaoEmissor></orgaoEmissor>
				<Sexo></Sexo>
				<UFEmissor></UFEmissor>
				<DataEmissao></DataEmissao>
				<Instrucao></Instrucao>
				<Dependentes></Dependentes>
				<EstadoCivil></EstadoCivil>
			</DadosCadastrais>
			<Localizacao>
				<Endereco></Endereco>
				<Bairro></Bairro>
				<Cidade></Cidade>
				<UF></UF>
				<CEP></CEP>
				<DDDRes></DDDRes>
				<FoneRes></FoneRes>
				<DDDComl></DDDComl>
				<FoneComl></FoneComl>
				<DDDcel></DDDcel>
				<Celular></Celular>
			</Localizacao>
	</ListaDeGrafias>
	<ListaDeParticipacoesOutrasEmpresas>
		<ParticipacoesOutrasEmpresas>
			<CNPJ></CNPJ>
			<Empresa></Empresa>
			<TipoRelacionamento></TipoRelacionamento>
			<Participacao></Participacao>
			<Cargo></Cargo>
			<EntradaEmpresa></EntradaEmpresa>
			<SaidaEmpresa></SaidaEmpresa>
			<Nome></Nome>
			<Estado></Estado>
		</ParticipacoesOutrasEmpresas>
	</ListaDeParticipacoesOutrasEmpresas>
		<ConsultasCPF>
			<QuantidadeTotal></QuantidadeTotal>
			<QuantidadeMesAtual></QuantidadeMesAtual>
			<QuantidadeMes1></QuantidadeMes1>
			<QuantidadeMes2></QuantidadeMes2>
			<QuantidadeMes3></QuantidadeMes3>
			<QuantidadeMes4></QuantidadeMes4>
			<QuantidadeMes5></QuantidadeMes5>
			<QuantidadeMes6></QuantidadeMes6>
			<QuantidadeMes7></QuantidadeMes7>
			<QuantidadeMes8></QuantidadeMes8>
			<QuantidadeMes9></QuantidadeMes9>
			<QuantidadeMes10></QuantidadeMes10>
			<QuantidadeMes11></QuantidadeMes11>
			<ListaConsultasCPF>
				<DetalheConsulta>
					<DataOcorrencia></DataOcorrencia>
					<Origem></Origem>
				<DetalheConsulta>
			<ListaConsultasCPF>
		</ConsultasCPF>
		<ResumoConsultasCheques>
			<QuantidadeAtual></QuantidadeAtual>
			<QuantidadeMes1></QuantidadeMes1>
			<QuantidadeMes2></QuantidadeMes2>
			<QuantidadeMes3></QuantidadeMes3>
		</ResumoConsultasCheques>
		<TitulosVencidosNaoPagos>
			<QuantidadeTotal></QuantidadeTotal>
			<ListaTitulos>
				<Titulo>
					<DataOcorrencia></DataOcorrencia>
					<RazaoSocial></RazaoSocial>
					<TipoMoeda></TipoMoeda>
					<Valor></Valor>
					<Contrato></Contrato>
				</Titulo>
			</ListaTitulos>
		</TitulosVencidosNaoPagos>
	<ChequesSemFundo>
		<DataUltOcorrencia></DataUltOcorrencia>
		<BancoUltOcorrencia></BancoUltOcorrencia>
		<AgenciaUltOcorrencia></AgenciaUltOcorrencia>
		<QuantidadeTotal></QuantidadeTotal>
		<ListaUltChequesSemFundo>
			<DetalheCheque>
				<Quantidade></Quantidade>
				<NomeBanco></NomeBanco>
				<Agencia></Agencia>
			</DetalheCheque>
		</ListaUltChequesSemFundo>
	</ChequesSemFundo>
	<Protestos>
		<QuantidadeTotal></QuantidadeTotal>
		<TipoMoeda></TipoMoeda>
		<ValorTotal></ValorTotal>
		<DataPrimeiro></DataPrimeiro>
		<ValorPrimeiro></ValorPrimeiro>
		<DataMaior></DataMaior>
		<ValorMaior></ValorMaior>
		<ListaProtestos>
			<DetalheProtesto>
				<DataOcorrencia></DataOcorrencia>
				<TipoMoeda></TipoMoeda>
				<Valor></Valor>
				<Cidade></Cidade>
				<CodigoCidade></CodigoCidade>
				<UF></UF>
				<NumeroCartorio></NumeroCartorio>
			</DetalheProtesto>
		</ListaProtestos>
	</Protestos>
	<FalenciasEmpresariaisAssociadas>
		<QuantidadeFalencias></QuantidadeFalencias>
		<DataOcorrenciaAntiga></DataOcorrenciaAntiga>
		<ListaParticipacaoFalencias>
			<DetalheFalenciasEmpresariaisAssociadas>
				<DataOcorrencia></DataOcorrencia>
				<CNPJ></CNPJ>
				<NomeEmpresa></NomeEmpresa>
				<VaraCivel></VaraCivel>
			</DetalheFalenciasEmpresariaisAssociadas>
		</ListaParticipacaoFalencias>
	</FalenciasEmpresariaisAssociadas>
	<InformacoesComplementares>
		<InformacaoComplementar>
			<TextoLivre></TextoLivre>
				</InformacaoComplementar>
				<InformacaoComplementar>
			<TextoLivre></TextoLivre>
		</InformacaoComplementar>
	</InformacoesComplementares>
		<Mensagens>
			<Codigo></Codigo>
			<Mensagem></Mensagem>
		</Mensagens>
</efx11>
*/

