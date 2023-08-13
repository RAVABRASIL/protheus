#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "TbiConn.ch"
#INCLUDE 'PROTHEUS.CH'

*************

User Function EXPCLI()

*************

Local _nX
Local nPOSLOC := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_LOCAL" } )

If M->C5_TIPO=='D'
   aCols[1,nPOSLOC]:='01'
   return .T.
EndIF


DbselectArea("SA1")  // Clientes
DbSetoRder(1)
DbSeek(xFilial("SA1")+M->C5_CLIENTE)

For _nX := 1 to len(aCols)	
		If ALLTRIM(getReg(SA1->A1_EST)) $'SL/SD/CE' .AND. SA1->A1_TIPO=='F' // Consumidor Final 
		   aCols[_nX,nPOSLOC]:='10' // Sao Paulo 
		Else
		   aCols[_nX,nPOSLOC]:='01' // Joao Pessoa 
		EndIf	
Next



Return .T.
     
*************

User Function EXPLOJA()

*************

Local _nX
Local nPOSLOC := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_LOCAL" } )

If M->C5_TIPO=='D'
   aCols[1,nPOSLOC]:='01'
   return .T.
EndIF

DbselectArea("SA1")  // Clientes
DbSetoRder(1)
DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)

For _nX := 1 to len(aCols)	
		If ALLTRIM(getReg(SA1->A1_EST)) $'SL/SD/CE' .AND. SA1->A1_TIPO=='F' // Consumidor Final 
		   aCols[_nX,nPOSLOC]:='10' // Sao Paulo 
		Else
		   aCols[_nX,nPOSLOC]:='01' // Joao Pessoa 
		EndIf	
Next

Return .T.

*************

User Function EXPPROD()

*************

Local _nX
Local nPOSLOC := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_LOCAL" } )
Local cLocal:=''

If M->C5_TIPO=='D'
   cLocal:='01' // Joao Pessoa 
   return cLocal
EndIF


DbselectArea("SA1")  // Clientes   	
DbSetoRder(1)
DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)


If ALLTRIM(getReg(SA1->A1_EST)) $'SL/SD/CE' .AND. SA1->A1_TIPO=='F' // Consumidor Final
	cLocal:='10' // Sao Paulo
Else
	cLocal:='01' // Joao Pessoa
endIf

Return cLocal

***************

Static Function getReg(cUF)

***************

Local cRGNO := "AC AM AP PA RO RR TO"
Local cRGNE := "MA PI CE RN PB PE AL BA SE"
Local cRGCE := "GO MT MS DF"
Local cRGSD := "MG ES RJ SP"
Local cRGSL := "RS PR SC"

if cUF $ cRGNO
	return "NO"
elseIf cUF $ cRGNE
	return "NE"
elseIf cUF $ cRGCE
	return "CE"
elseIf cUF $ cRGSD
	return "SD"	
elseIf cUF $ cRGSL
	return "SL"				
endIf	
   
Return


*************

User Function TES002()

*************

//Local nPOSLOC := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_LOCAL" } )


//IF(M->C6_TES$"541/542/543","10",IF(M->C6_TES$"516","02","01"))  

/*If aCols[n,nPOSLOC]=='10'.AND.  !M->C6_TES $ "541/542/543"
   Alert(" O TES nao e valido para o Almoxarifado 10.")
   Return .F.
Endif

If aCols[n,nPOSLOC]=='01'.AND.  M->C6_TES $ "541/542/543"
   Alert(" O TES nao e valido para o Almoxarifado 01.")
   Return .F.       	
Endif */

/*
If aCols[n,nPOSLOC]=='02'
   M->C6_TES:='516' 
Endif 
*/

if alltrim(upper(FunName())) = "ESTC005"
   return .T.
ELSEif alltrim(upper(FunName())) = "MATA410" .AND. alltrim(M->C6_TES)= "516" .and. FWCodFil() == "01"
 ALERT("Não e permitido digitação de Pedido de amostra!!!") 
 RETURN .F.
Endif


Return .T.                         


*************

User Function TES001()

*************

Return IIF("VD"$ M->C5_VEND1.OR.M->C6_TES=="599",.F.,IIF(M->C5_TIPOCLI="F",M->C6_TES$"504/505/514/516/519/535/537/532/539/531/541/542/502/548/517",.T.)) 


