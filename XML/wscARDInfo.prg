#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://10.0.0.16:8081/ws/U_WSARDINFO.apw?WSDL
Gerado em        09/20/10 19:27:10
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.090116
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _FTNRRNN ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSU_WSARDINFO
------------------------------------------------------------------------------- */

WSCLIENT WSU_WSARDINFO

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ARDSEARCH

	WSDATA   _URL                      AS String
	WSDATA   cARD                      AS string
	WSDATA   cARDSEARCHRESULT          AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSU_WSARDINFO
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.090818P-20100111] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSU_WSARDINFO
Return

WSMETHOD RESET WSCLIENT WSU_WSADINFO
	::cAD               := NIL 
	::cARDSEARCHRESULT   := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSU_WSARDINFO
Local oClone := WSU_WSADINFO():New()
	oClone:_URL          := ::_URL 
	oClone:cARD          := ::cARD
	oClone:cARDSEARCHRESULT := ::cARDSEARCHRESULT
Return oClone

// WSDL Method ARDSEARCH of Service WSU_WSARDINFO

WSMETHOD ARDSEARCH WSSEND cARD WSRECEIVE cARDSEARCHRESULT WSCLIENT WSU_WSARDINFO
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ARDSEARCH xmlns="http://10.0.0.16/ws/u_wsardinfo.apw">'
cSoap += WSSoapValue("ARD", ::cARD, cARD , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</ARDSEARCH>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://10.0.0.16/ws/u_wsardinfo.apw/ARDSEARCH",; 
	"DOCUMENT","http://10.0.0.16/ws/u_wsardinfo.apw",,"1.031217",; 
	"http://10.0.0.16:8081/ws/U_WSARDINFO.apw")

::Init()
::cARDSEARCHRESULT   :=  WSAdvValue( oXmlRet,"_ARDSEARCHRESPONSE:_ARDSEARCHRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.