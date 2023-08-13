#INCLUDE "PROTHEUS.CH"

#DEFINE STR0001 "Informe o endereço do arduino"
#DEFINE STR0002 "Endereco Arduino"
#DEFINE STR0003 "UF"
#DEFINE STR0004 "Cidade"
#DEFINE STR0005 "Bairro"
#DEFINE STR0006 "Tipo de Logradouro"
#DEFINE STR0007 "Logradouro"
#DEFINE STR0008 "Resultado da Consulta"
#DEFINE STR0009 "CEP"
#DEFINE STR0010 "Mensagem"
#DEFINE STR0011 "Consultar Novo CEP?"
#DEFINE STR0012 "Consultando CEP"
#DEFINE STR0013 "Aguarde..."

/*/
	Funcao: ARDInfo
	Autor:	Gustavo Costa
	Data:	31/03/2014
	Uso:	Consulta do arduino
	Obs.:	Exemplo de Consumo do WEB Service u_wsADInfo para Consulta das interferencias do arduino
/*/

User Function ARDInfo()

	Local aPerg			:= {}
	Local aResult		:= {}
	
	Local bARDSearch
	
	Local cXML

	Local cError		:= ""
	Local cWarning		:= ""

	Local cOcorrD
	Local cOcorr
	Local cMaq
	Local cLado
	Local cTipo
	Local cData
	Local cHora

	Local oWs
	Local oWs2
	Local oWSARD
	Local oXML
	
	WSDLDbgLevel(2)

	oWs := WSU_WSARDINFO():New()
 	oWs:cARD	:= '20140329'

	If oWs:ARDSEARCH()
 		alert(oWs:cRETORNAURLRESULT)
 	Else
	 	cSvcError := GetWSCError() // Resumo do erro 11 
 		cSoapFCode := GetWSCError(2) // Soap Fault Code
		cSoapFDescr := GetWSCError(3) // Soap Fault Description
 		alert('Erro de Execução : '+GetWSCError())
 	Endif

	If oWs:RETORNAURL()
 		alert(oWs:cRETORNAURLRESULT)
 	Else
 		alert('Erro de Execução : '+GetWSCError())
 	Endif
 
	BEGIN SEQUENCE
	
		aAdd( aPerg , { 1 , STR0002 , Space(35) ,  , ".T." , "" , ".T." , 35 , .T. } ) //"Informe o CEP"
		IF ParamBox( @aPerg , STR0002 , NIL , NIL , NIL , .T. )
			
			bARDSearch := { ||											; 
								oWSARD 		:= WSU_WSARDINFO():New(),	;
								oWSARD:cARD	:= AllTrim(MV_PAR01),				;
								oWSARD:ARDSEARCH()						;
						   }	

			MsgRun( STR0013 , STR0012 , bARDSearch ) //"Aguarde"###"Consultando CEP"

			cXML		:= oWSARD:cARDSEARCHRESULT
			oXML		:= XmlParser( cXML , "_" , @cError , @cWarning )
	
			cResultado	:= oXml:_WebServiceArd:_Resultado:Text
			//cMensagem	:= oXml:_WebServiceArd:_Resultado_Txt:Text
	
			IF ( cResultado == "1" )
	
				/*
				cUF				:= oXml:_WebServiceArd:_UF:Text
				cCidade			:= oXml:_WebServiceCep:_Cidade:Text
				cBairro			:= oXml:_WebServiceCep:_Bairro:Text
				cLogradouro		:= oXml:_WebServiceCep:_Logradouro:Text
				cTpLogradouro	:= oXml:_WebServiceCep:_Tipo_Logradouro:Text

				aAdd( aResult , { 1 , STR0009 , MV_PAR01		, "99999999"	, ".T." , "" , ".F." , 08	, .F. } ) //"CEP"
				aAdd( aResult , { 1 , STR0003 , cUF 	  		, "@"			, ".T." , "" , ".F." , 04 	, .F. } ) //"UF"
				aAdd( aResult , { 1 , STR0004 , cCidade			, "@"			, ".T." , "" , ".F." , 100	, .F. } ) //"Cidade"
				aAdd( aResult , { 1 , STR0005 , cBairro			, "@" 		 	, ".T." , "" , ".F." , 100	, .F. } ) //"Bairro"
				aAdd( aResult , { 1 , STR0006 , cTpLogradouro	, "@" 		 	, ".T." , "" , ".F." , 100	, .F. } ) //"Tipo de Logradouro"
				aAdd( aResult , { 1 , STR0007 , cLogradouro		, "@"			, ".T." , "" , ".F." , 100	, .F. } ) //"Logradouro"
				*/
				
			Else
			
				aAdd( aResult , { 1 , STR0009 , MV_PAR01		, "99999999" 	, ".T." , "" , ".F." , 08	, .F. } ) //"CEP"
	
			EndIF

			ParamBox( @aResult , STR0008 + " : " + cMensagem , NIL , NIL , NIL , .T. )	//"Resultado da Consulta"


			IF !( MsgNoYes( "Consultar Novo CEP?" , ProcName() ) )
				BREAK
			EndIF
	
			U_ARDInfo()
	
		EndIF

	END SEQUENCE

Return( MBrChgLoop( .F. ) )