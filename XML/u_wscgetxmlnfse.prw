#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://10.0.0.16:8081/ws/u_wsgetxmlnfse.apw?WSDL
Gerado em        04/10/14 14:09:02
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _DNXQFPU ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSU_WSGETXMLNFSE
------------------------------------------------------------------------------- */

WSCLIENT WSU_WSGETXMLNFSE

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GETXMLNFSE

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCODEMP                   AS string
	WSDATA   cCODFIL                   AS string
	WSDATA   cCNPJ                     AS string
	WSDATA   cNUMERODANFS              AS string
	WSDATA   cGETXMLNFSERESULT         AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSU_WSGETXMLNFSE
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.120420A-20120726] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSU_WSGETXMLNFSE
Return

WSMETHOD RESET WSCLIENT WSU_WSGETXMLNFSE
	::cCODEMP            := NIL 
	::cCODFIL            := NIL 
	::cCNPJ              := NIL 
	::cNUMERODANFS       := NIL 
	::cGETXMLNFSERESULT  := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSU_WSGETXMLNFSE
Local oClone := WSU_WSGETXMLNFSE():New()
	oClone:_URL          := ::_URL 
	oClone:cCODEMP       := ::cCODEMP
	oClone:cCODFIL       := ::cCODFIL
	oClone:cCNPJ         := ::cCNPJ
	oClone:cNUMERODANFS  := ::cNUMERODANFS
	oClone:cGETXMLNFSERESULT := ::cGETXMLNFSERESULT
Return oClone

// WSDL Method GETXMLNFSE of Service WSU_WSGETXMLNFSE

WSMETHOD GETXMLNFSE WSSEND cCODEMP,cCODFIL,cCNPJ,cNUMERODANFS WSRECEIVE cGETXMLNFSERESULT WSCLIENT WSU_WSGETXMLNFSE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETXMLNFSE xmlns="http://10.0.0.16:8081/ws/u_wsgetxmlnfse.apw">'
cSoap += WSSoapValue("CODEMP", ::cCODEMP, cCODEMP , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CODFIL", ::cCODFIL, cCODFIL , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CNPJ", ::cCNPJ, cCNPJ , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("NUMERODANFS", ::cNUMERODANFS, cNUMERODANFS , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETXMLNFSE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://10.0.0.16:8081/ws/u_wsgetxmlnfse.apw/GETXMLNFSE",; 
	"DOCUMENT","http://10.0.0.16:8081/ws/u_wsgetxmlnfse.apw",,"1.031217",; 
	"http://10.0.0.16:8081/ws/U_WSGETXMLNFSE.apw")

::Init()
::cGETXMLNFSERESULT  :=  WSAdvValue( oXmlRet,"_GETXMLNFSERESPONSE:_GETXMLNFSERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



