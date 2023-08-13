#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
/* WSSERVICE: u_wsCEPInfo Autor: Marinaldo de Jesus Data: 20/09/2010 
Descrio: Servico de Constulta ao Codigo de Enderacamento Postal 
a partir da URL http://cep.republicavirtual.com.br/web_cep.php?cep=[cep] 
Uso: Consulta ao CEP (Codigo de Enderecamento Postal) */ 

WSSERVICE u_wsCEPInfo DESCRIPTION "Servico de Constulta ao Codigo de Enderacamento Postal" NAMESPACE "http://localhost/naldo/ws/u_wscepinfo.apw" 
//"Servico de Constulta ao Codigo de Enderacamento Postal" 

WSDATA CEP As String 
WSDATA XML As String 

WSMETHOD CEPSearch DESCRIPTION "Método para pesquisa do CEP" //"Método para pesquisa do CEP" 

ENDWSSERVICE 

/* WSMETHOD: CEPSearch 
Autor: Marinaldo de Jesus Data: 20/09/2010 
Uso: Consulta de CEP Obs.: 
Metodo Para a Pesquisa do CEP 
Retorna: XML com a Consulta do CEP */ 

WSMETHOD CEPSearch WSRECEIVE CEP WSSEND XML WSSERVICE u_wsCEPInfo 

Local cUrl := "" 
Local lWsReturn := .T. 
DEFAULT CEP := Self:CEP 

cUrl := "http://cep.republicavirtual.com.br/web_cep.php?cep="+StrTran(CEP,"-","")+"&formato=xml" 

Self:XML := HttpGet( cUrl ) 
XML := Self:XML 

Return( lWsReturn )

/* =============================================================================== 
WSDL Location http://187.94.60.197:98/ws/U_WSCEPINFO.apw?WSDL 
Gerado em 09/20/10 19:27:10 
Observações Código-Fonte gerado por ADVPL WSDL Client 1.090116 
Alterações neste arquivo podem causar funcionamento incorreto 
e serão perdidas caso o código-fonte seja gerado novamente. 
=============================================================================== */ 

User Function _FTNRRNN ; Return // "dummy" function - Internal Use 

/* ------------------------------------------------------------------------------- 
WSDL Service WSU_WSCEPINFO 
------------------------------------------------------------------------------- */ 

WSCLIENT WSU_WSCEPINFO 

WSMETHOD NEW 
WSMETHOD INIT 
WSMETHOD RESET 
WSMETHOD CLONE 
WSMETHOD CEPSEARCH 

WSDATA _URL AS String 
WSDATA cCEP AS string 
WSDATA cCEPSEARCHRESULT AS string 

ENDWSCLIENT 

WSMETHOD NEW WSCLIENT WSU_WSCEPINFO 
::Init() 

If !FindFunction("XMLCHILDEX") 
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.090818P-20100111] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.") 
EndIf 
Return Self 

WSMETHOD INIT WSCLIENT WSU_WSCEPINFO 

Return 

WSMETHOD RESET WSCLIENT WSU_WSCEPINFO 
::cCEP := NIL 
::cCEPSEARCHRESULT := NIL 
::Init() 

Return 

WSMETHOD CLONE WSCLIENT WSU_WSCEPINFO 

Local oClone := WSU_WSCEPINFO():New() 
oClone:_URL := ::_URL 
oClone:cCEP := ::cCEP 
oClone:cCEPSEARCHRESULT := ::cCEPSEARCHRESULT 

Return oClone 

// WSDL Method CEPSEARCH of Service WSU_WSCEPINFO 

WSMETHOD CEPSEARCH WSSEND cCEP WSRECEIVE cCEPSEARCHRESULT WSCLIENT WSU_WSCEPINFO 

Local cSoap := "" , oXmlRet 

BEGIN WSMETHOD 

cSoap += '' 
cSoap += WSSoapValue("CEP", ::cCEP, cCEP , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "" 

oXmlRet := SvcSoapCall( Self,cSoap,; 
"http://localhost/naldo/ws/u_wscepinfo.apw/CEPSEARCH",; 
"DOCUMENT","http://localhost/naldo/ws/u_wscepinfo.apw",,"1.031217",; 
"http://187.94.60.197:98/ws/U_WSCEPINFO.apw") 

::Init() 
::cCEPSEARCHRESULT := WSAdvValue( oXmlRet,"_CEPSEARCHRESPONSE:_CEPSEARCHRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD 

oXmlRet := NIL 

Return .T.

