#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE STR0001 "Servico de Constulta aos Arduinos"
#DEFINE STR0002 "Método para pesquisa das intervencoes dos Arduinos"
#DEFINE STR0003 "Método para retornar a URL"

/*/
	WSSERVICE:	u_wsARDInfo
	Autor:		Gustavo Costa
	Data:		31/03/2014
	Descri‡…o:	Servico de Constulta ao arduino ligado nas maquinas
	Uso:		Consultar as intervencoes nas maquinas 
/*/

WSSERVICE u_wsARDInfo DESCRIPTION STR0001 NAMESPACE "http://10.0.0.10:8088/ws/u_wsardinfo.apw" 

	WSDATA ARD				As String
	WSDATA XML				As String
	WSDATA cString		As String

	WSMETHOD ARDSearch		DESCRIPTION STR0002 //"Método para pesquisa das intervencoes dos Arduinos"
	WSMETHOD RetornaUrl		DESCRIPTION STR0003 //"Método para retornar a URL"

ENDWSSERVICE

/*/
	WSMETHOD:	ARDSearch
	Autor:		Gustavo Costa
	Data:		31/03/2014
	Uso:		Consulta do Arduino
	Obs.:		Metodo Para a Pesquisa das intervensoes do arduino
	Retorna:	XML com a Consulta do arduino
	
/*/
WSMETHOD ARDSearch WSRECEIVE ARD WSSEND XML WSSERVICE u_wsARDInfo

	Local cUrl		:= ""
	Local lWsReturn	:= .T.

	DEFAULT ARD		:= Self:ARD
	
	HTTPGetStatus()
	//"http://www.portaltransparencia.gov.br/copa2014/api/rest/"
	//"http://cep.republicavirtual.com.br/web_cep.php?cep=58037843&formato=xml"
	cUrl			:= 'http://' + ARD  
	conOut(cUrl)
	Self:XML		:= HttpGet( cUrl, ,120 )
	//Self:XML		:= HttpPost(cUrl)
	conOut(Self:XML) 
	XML				:= Self:XML

Return( lWsReturn )

WSMETHOD RetornaUrl WSRECEIVE NULLPARAM WSSEND cString WSSERVICE u_wsARDInfo
 
//::cString := HttpGet("http://192.168.0.160/getdt",,120)
Self:cString 		:= HttpGet("http://192.168.0.160/getdt",,120)
cString			:= Self:cString

Return .T.