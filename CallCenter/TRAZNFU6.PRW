#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Protheus.ch"

//--------------------------------
//Programa: TRAZNFU6.PRW
//Data    : 30/10/09
//Autoria : Flávia Rocha
//Função  : U_TRAZNFU6
//--------------------------------

//Funções utilizadas dentros dos inicalizadores padrões dos campos:
/*
- UC_NFISCAL
- UC_SERINF
- UC_REALCHG
- UC_OBS

*/

****************************************************
User function TRAZNFU6()
****************************************************

Local cQuery 	:= ""
Local cNFU6  	:= ""
Local cNFiscal 	:= SU6->U6_NFISCAL
Local cSrNF		:= SU6->U6_SERINF
Local cCli		:= Substr( SU6->U6_CODENT,1,6 )
Local cLj		:= Substr( SU6->U6_CODENT,7,2 )

cQuery := "SELECT U6_FILIAL, U6_NFISCAL, U6_SERINF, U6_ENTIDA, U6_CODENT "
cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQuery += " AND RTRIM( U6_NFISCAL ) = '" + Alltrim( cNFiscal ) + "' "
cQuery += " AND RTRIM( U6_SERINF ) = '"  + Alltrim( cSrNF ) + "' "
cQuery += " AND U6_CODENT = '" + ( cCli + cLj ) + "' "
cQuery += " AND SU6.D_E_L_E_T_ = '' "

Memowrite("C:\NFU6.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("NFU6") > 0
	DbSelectArea("NFU6")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "NFU6" 

NFU6->(DbGoTop())

While !NFU6->(EOF())

	cNFU6 := NFU6->U6_NFISCAL
	   
   DbSelectArea("NFU6")
   NFU6->(DbSkip())
Enddo

DbselectArea("NFU6")
DbCloseArea("NFU6")
  

Return(cNFU6) 


****************************************************
User function TRAZSRU6( ) //irá trazer a série da nota correspondente
****************************************************

Local cQuery 	:= ""
Local cSeriNF	:= ""
Local cNFiscal 	:= SU6->U6_NFISCAL
Local cSrNF		:= SU6->U6_SERINF
Local cCli		:= Substr( SU6->U6_CODENT,1,6 )
Local cLj		:= Substr( SU6->U6_CODENT,7,2 )

cQuery := "SELECT U6_FILIAL, U6_NFISCAL, U6_SERINF, U6_ENTIDA, U6_CODENT "
cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQuery += " AND RTRIM( U6_NFISCAL ) = '" + Alltrim( cNFiscal ) + "' "
cQuery += " AND RTRIM( U6_SERINF ) = '"  + Alltrim( cSrNF ) + "' "
cQuery += " AND U6_CODENT = '" + ( cCli + cLj ) + "' "
cQuery += " AND SU6.D_E_L_E_T_ = '' "

Memowrite("C:\SRU6.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("SRU6") > 0
	DbSelectArea("SRU6")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "SRU6" 

SRU6->(DbGoTop())

While !SRU6->(EOF())

	cSeriNF		:= SRU6->U6_SERINF   
	   
   DbSelectArea("SRU6")
   SRU6->(DbSkip())
Enddo

DbselectArea("SRU6")
DbCloseArea("SRU6")
  

Return(cSeriNF) 

****************************************************
User function FDTU6()
****************************************************
//Traz a nova data de chegada que foi gravada no SU6

Local cQuery 	:= ""
Local cNFiscal 	:= SU6->U6_NFISCAL
Local cSrNF		:= SU6->U6_SERINF
Local cCodlig	:= SU6->U6_CODLIG
Local cCli		:= Substr( SU6->U6_CODENT,1,6 )
Local cLj		:= Substr( SU6->U6_CODENT,7,2 ) 
Local dDTU6		:= CtoD("  /  /    ")

cQuery := "SELECT U6_FILIAL, U6_NFISCAL, U6_SERINF, U6_CODLIG, U6_REALCHG "
cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQuery += " AND U6_CODLIG  = '" + cCodlig + "' "
cQuery += " AND RTRIM(U6_NFISCAL) = '" + Alltrim( cNFiscal ) + "' "
cQuery += " AND RTRIM( U6_SERINF ) = '"  + Alltrim( cSrNF ) + "' "
cQuery += " AND U6_CODENT = '" + ( cCli + cLj ) + "' "
cQuery += " AND SU6.D_E_L_E_T_ = '' "

Memowrite("C:\DTU6.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("DTU6") > 0
	DbSelectArea("DTU6")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "DTU6"   
TCSetField( "DTU6", "U6_REALCHG", "D")

DTU6->(DbGoTop())

While !DTU6->(EOF())

	dDTU6 := DTU6->U6_REALCHG
	   
   DbSelectArea("DTU6")
   DTU6->(DbSkip())
Enddo

If Empty(dDTU6)
	dDTU6 := CtoD("  /  /    ")
Endif

DbselectArea("DTU6")
DbCloseArea("DTU6")
  

Return(dDTU6) 


****************************************************
User function FOBSU6()
****************************************************
//Traz a nova data de chegada que foi gravada no SU6

Local cQuery 	:= ""
Local cNFiscal 	:= SU6->U6_NFISCAL
Local cSrNF		:= SU6->U6_SERINF
Local cCodlig	:= SU6->U6_CODLIG
Local cCli		:= Substr( SU6->U6_CODENT,1,6 )
Local cLj		:= Substr( SU6->U6_CODENT,7,2 ) 
Local cObsUC	:= SU6->U6_OBSLIG

cQuery := "SELECT U6_FILIAL, U6_NFISCAL, U6_SERINF, U6_CODLIG, U6_OBSLIG "
cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQuery += " AND U6_CODLIG  = '" + cCodlig + "' "
cQuery += " AND RTRIM(U6_NFISCAL) = '" + Alltrim( cNFiscal ) + "' "
cQuery += " AND RTRIM( U6_SERINF ) = '"  + Alltrim( cSrNF ) + "' "
cQuery += " AND U6_CODENT = '" + ( cCli + cLj ) + "' "
cQuery += " AND SU6.D_E_L_E_T_ = '' "

Memowrite("C:\OBSU6.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("OBSU6") > 0
	DbSelectArea("OBSU6")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "OBSU6"   
//TCSetField( "DTU6", "U6_REALCHG", "D")

OBSU6->(DbGoTop())

While !OBSU6->(EOF())

	cObsUC := OBSU6->U6_OBSLIG
	   
   DbSelectArea("OBSU6")
   OBSU6->(DbSkip())
Enddo

DbselectArea("OBSU6")
DbCloseArea("OBSU6")
  

Return(cObsUC) 
