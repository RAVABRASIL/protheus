#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://10.0.0.16:8081/ws/U_WSARDINFO.apw?WSDL
Gerado em        03/31/14 13:42:46
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _HLPWCMJ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSU_WSARDINFO
------------------------------------------------------------------------------- */

WSCLIENT WSU_WSARDINFO

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ARDSEARCH
	WSMETHOD RETORNAURL

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cARD                      AS string
	WSDATA   cARDSEARCHRESULT          AS string
	WSDATA   cRETORNAURLRESULT         AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSU_WSARDINFO
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.120420A-20120726] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSU_WSARDINFO
Return

WSMETHOD RESET WSCLIENT WSU_WSARDINFO
	::cARD               := NIL 
	::cARDSEARCHRESULT   := NIL 
	::cRETORNAURLRESULT  := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSU_WSARDINFO
Local oClone := WSU_WSARDINFO():New()
	oClone:_URL          := ::_URL 
	oClone:cARD          := ::cARD
	oClone:cARDSEARCHRESULT := ::cARDSEARCHRESULT
	oClone:cRETORNAURLRESULT := ::cRETORNAURLRESULT
Return oClone

// WSDL Method ARDSEARCH of Service WSU_WSARDINFO

WSMETHOD ARDSEARCH WSSEND cARD WSRECEIVE cARDSEARCHRESULT WSCLIENT WSU_WSARDINFO
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ARDSEARCH xmlns="http://10.0.0.10:8088/ws/u_wsardinfo.apw">'
cSoap += WSSoapValue("ARD", ::cARD, cARD , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</ARDSEARCH>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://10.0.0.10:8088/ws/u_wsardinfo.apw/ARDSEARCH",; 
	"DOCUMENT","http://10.0.0.10:8088/ws/u_wsardinfo.apw",,"1.031217",; 
	"http://10.0.0.10:8088/ws/U_WSARDINFO.apw")

::Init()
::cARDSEARCHRESULT   :=  WSAdvValue( oXmlRet,"_ARDSEARCHRESPONSE:_ARDSEARCHRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method RETORNAURL of Service WSU_WSARDINFO

WSMETHOD RETORNAURL WSSEND NULLPARAM WSRECEIVE cRETORNAURLRESULT WSCLIENT WSU_WSARDINFO
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RETORNAURL xmlns="http://10.0.0.10:8088/ws/u_wsardinfo.apw">'
cSoap += "</RETORNAURL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://10.0.0.10:8088/ws/u_wsardinfo.apw/RETORNAURL",; 
	"DOCUMENT","http://10.0.0.10:8088/ws/u_wsardinfo.apw",,"1.031217",; 
	"http://10.0.0.10:8088/ws/U_WSARDINFO.apw")

::Init()
::cRETORNAURLRESULT  :=  WSAdvValue( oXmlRet,"_RETORNAURLRESPONSE:_RETORNAURLRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


