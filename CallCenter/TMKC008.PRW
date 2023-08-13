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
- UC_NFISCAL - traz a nota fiscal do SU6 (item da ligação)
- UC_SERINF  - traz a série da nf do SU6
- UC_REALCHG 
- UC_OBS     - traz a observação do atendimento anterior
- UC_TIPOATD - tipo do atendimento: 1 = Telemarketing, 3 = TeleVendas
- UC_REDESP  - traz a transportadora que foi feito o redespacho


*/

*********************************
User function fGetNFU6()
*********************************

Local cQuery 	:= ""
Local cNFU6  	:= ""
Local cNFiscal 	:= ""
Local cSrNF		:= ""
Local cCli		:= ""
Local cLj		:= ""

If Alltrim(FUNNAME()) != 'TMKA271'

	cNFiscal 	:= SU6->U6_NFISCAL
	cSrNF		:= SU6->U6_SERINF
	cCli		:= Substr( SU6->U6_CODENT,1,6 )
	cLj			:= Substr( SU6->U6_CODENT,7,2 )

	cQuery := "SELECT TOP 1 U6_DATA, U6_FILIAL, U6_NFISCAL, U6_SERINF, U6_ENTIDA, U6_CODENT "
	cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
	cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
	cQuery += " AND RTRIM( U6_NFISCAL ) = '" + Alltrim( cNFiscal ) + "' "
	cQuery += " AND RTRIM( U6_SERINF ) = '"  + Alltrim( cSrNF ) + "' "
	cQuery += " AND U6_CODENT = '" + ( cCli + cLj ) + "' "
	cQuery += " AND SU6.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY U6_DATA DESC "
	
	//Memowrite("C:\NFU6.SQL",cQuery)
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
Endif  

Return(cNFU6) 


****************************************************
User function fGetseriU6( ) //irá trazer a série da nota correspondente
****************************************************

Local cQuery 	:= ""
Local cSeriNF	:= ""
Local cNFiscal 	:= ""
Local cSrNF		:= ""
Local cCli		:= ""
Local cLj		:= ""

If Alltrim(FUNNAME()) != 'TMKA271' 

	cNFiscal 	:= SU6->U6_NFISCAL
	cSrNF		:= SU6->U6_SERINF
	cCli		:= Substr( SU6->U6_CODENT,1,6 )
	cLj		:= Substr( SU6->U6_CODENT,7,2 )

	cQuery := "SELECT TOP 1 U6_DATA, U6_FILIAL, U6_NFISCAL, U6_SERINF, U6_ENTIDA, U6_CODENT "
	cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
	cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
	cQuery += " AND RTRIM( U6_NFISCAL ) = '" + Alltrim( cNFiscal ) + "' "
	cQuery += " AND RTRIM( U6_SERINF ) = '"  + Alltrim( cSrNF ) + "' "
	cQuery += " AND U6_CODENT = '" + ( cCli + cLj ) + "' "
	cQuery += " AND SU6.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY U6_DATA DESC "
	
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
  
Endif

Return(cSeriNF) 

****************************************************
User function fGetDTU6()
****************************************************
//Traz a nova data de chegada que foi gravada no SU6

Local cQuery 	:= ""
Local cNFiscal 	:= ""
Local cSrNF		:= ""
Local cCodlig	:= ""
Local cCli		:= ""
Local cLj		:= ""
Local dDTU6		:= CtoD("  /  /    ")

If Alltrim(FUNNAME()) != 'TMKA271' 

	cNFiscal 	:= SU6->U6_NFISCAL
	cSrNF		:= SU6->U6_SERINF
	cCodlig	:= SU6->U6_CODLIG
	cCli		:= Substr( SU6->U6_CODENT,1,6 )
	cLj		:= Substr( SU6->U6_CODENT,7,2 ) 

	cQuery := "SELECT TOP 1 U6_DATA, U6_FILIAL, U6_NFISCAL, U6_SERINF, U6_CODLIG, U6_REALCHG "
	cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
	cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
	cQuery += " AND U6_CODLIG  = '" + cCodlig + "' "
	cQuery += " AND RTRIM(U6_NFISCAL) = '" + Alltrim( cNFiscal ) + "' "
	cQuery += " AND RTRIM( U6_SERINF ) = '"  + Alltrim( cSrNF ) + "' "
	cQuery += " AND U6_CODENT = '" + ( cCli + cLj ) + "' "
	cQuery += " AND SU6.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY U6_DATA DESC "
	
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

Endif	  

Return(dDTU6) 


****************************************************
User function fGetOBSU6()
****************************************************
//Traz OBSERVAÇÃO que foi gravada no SU6

Local cQuery 	:= ""
Local cNFiscal 	:= SU6->U6_NFISCAL
Local cSrNF		:= SU6->U6_SERINF
Local cCodlig	:= SU6->U6_CODLIG
Local cCli		:= Substr( SU6->U6_CODENT,1,6 )
Local cLj		:= Substr( SU6->U6_CODENT,7,2 ) 
Local cObsUC	:= SU6->U6_OBSLIG

cQuery := "SELECT TOP 1 U6_DATA, U6_FILIAL, U6_NFISCAL, U6_SERINF, U6_CODLIG, U6_OBSLIG "
cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQuery += " AND U6_CODLIG  = '" + cCodlig + "' "
cQuery += " AND RTRIM(U6_NFISCAL) = '" + Alltrim( cNFiscal ) + "' "
cQuery += " AND RTRIM( U6_SERINF ) = '"  + Alltrim( cSrNF ) + "' "
cQuery += " AND U6_CODENT = '" + ( cCli + cLj ) + "' "
cQuery += " AND SU6.D_E_L_E_T_ = '' "
cQuery += " ORDER BY U6_DATA DESC "

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

//MSMM(,,,cObsUC,1,,,'SUC','UC_CODOBS') //não pode usar aqui pq tá reclock

DbselectArea("OBSU6")
DbCloseArea("OBSU6")

//MSMM(,,,cObsUC,1,,,'SUC','UC_CODOBS')   //para gravar
//MSMM(SUC->UC_CODOBS,80)                 //para carregar

//Return(cObsUC) 
Return(cObsUC)



****************************************************
User function EhProb()
****************************************************
//Traz o flag de ligação problema qdo houver

Local cQuery 	:= ""
Local cCodlig	:= SU6->U6_CODLIG
Local cCli		:= Substr( SU6->U6_CODENT,1,6 )
Local cLj		:= Substr( SU6->U6_CODENT,7,2 ) 
Local cFlagProb	:= SU6->U6_LIGPROB

cQuery := "SELECT U6_FILIAL, U6_CODLIG, U6_LIGPROB "
cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQuery += " AND U6_CODLIG  = '" + cCodlig + "' "
cQuery += " AND U6_CODENT = '" + ( cCli + cLj ) + "' "
cQuery += " AND SU6.D_E_L_E_T_ = '' "

Memowrite("C:\EHPROB.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("PROBU6") > 0
	DbSelectArea("PROBU6")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "PROBU6"   

PROBU6->(DbGoTop())

While !PROBU6->(EOF())

	cFlagProb := PROBU6->U6_LIGPROB
	   
   DbSelectArea("PROBU6")
   PROBU6->(DbSkip())
Enddo


DbselectArea("PROBU6")
DbCloseArea("PROBU6")

Return(cFlagProb)

****************************************************
User function fGetTipo()
****************************************************

Local cQuery 	:= ""
Local cNFU6  	:= ""
Local cNFiscal 	:= SU6->U6_NFISCAL
Local cSrNF		:= SU6->U6_SERINF
Local cCli		:= Substr( SU6->U6_CODENT,1,6 )
Local cLj		:= Substr( SU6->U6_CODENT,7,2 )
Local cTipoATD  := ""

cQuery := "SELECT TOP 1 U6_DATA, U6_FILIAL, U6_NFISCAL, U6_SERINF, U6_ENTIDA, U6_CODENT, U6_TIPO "
cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQuery += " AND RTRIM( U6_NFISCAL ) = '" + Alltrim( cNFiscal ) + "' "
cQuery += " AND RTRIM( U6_SERINF ) = '"  + Alltrim( cSrNF ) + "' "
cQuery += " AND U6_CODENT = '" + ( cCli + cLj ) + "' "
cQuery += " AND SU6.D_E_L_E_T_ = '' "
cQuery += " ORDER BY U6_DATA DESC "

Memowrite("C:\TIPOU6.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("TIPOU6") > 0
	DbSelectArea("TIPOU6")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TIPOU6" 

TIPOU6->(DbGoTop())

While !TIPOU6->(EOF())

	cTipoATD := TIPOU6->U6_TIPO
	   
   DbSelectArea("TIPOU6")
   TIPOU6->(DbSkip())
Enddo

DbselectArea("TIPOU6")
DbCloseArea("TIPOU6")
  

Return(cTipoATD) 


****************************************************
User function fRedesp()
****************************************************

Local cQuery 	:= ""
Local cNFU6  	:= ""
Local cNFiscal 	:= SU6->U6_NFISCAL
Local cSrNF		:= SU6->U6_SERINF
Local cCli		:= Substr( SU6->U6_CODENT,1,6 )
Local cLj		:= Substr( SU6->U6_CODENT,7,2 )
Local cRedesp   := ""

cQuery := "SELECT TOP 1 U6_DATA, U6_FILIAL, U6_NFISCAL, U6_SERINF, U6_ENTIDA, U6_CODENT, U6_REDESP "
cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQuery += " AND RTRIM( U6_NFISCAL ) = '" + Alltrim( cNFiscal ) + "' "
cQuery += " AND RTRIM( U6_SERINF ) = '"  + Alltrim( cSrNF ) + "' "
cQuery += " AND U6_CODENT = '" + ( cCli + cLj ) + "' "
cQuery += " AND SU6.D_E_L_E_T_ = '' "
cQuery += " ORDER BY U6_DATA DESC "

Memowrite("C:\REDESPUC.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("SU6XX") > 0
	DbSelectArea("SU6XX")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "SU6XX" 

SU6XX->(DbGoTop())

While !SU6XX->(EOF())

	cRedesp := SU6XX->U6_REDESP
	   
   DbSelectArea("SU6XX")
   SU6XX->(DbSkip())
Enddo

DbselectArea("SU6XX")
DbCloseArea("SU6XX")
  

Return(cRedesp) 



****************************************************
User function fGetOriU6()
****************************************************
//Traz a ligação que originou o atendimento

Local cQuery 	:= ""
Local cNFiscal 	:= SU6->U6_NFISCAL
Local cSrNF		:= SU6->U6_SERINF
Local cCodlig	:= SU6->U6_CODLIG
Local cLista    := SU6->U6_LISTA
Local cCodigo   := SU6->U6_CODIGO
Local cCli		:= Substr( SU6->U6_CODENT,1,6 )
Local cLj		:= Substr( SU6->U6_CODENT,7,2 ) 
Local cLigOri	:= ""

cQuery := "SELECT TOP 1 U6_DATA, U6_FILIAL, U6_NFISCAL, U6_SERINF, U6_CODLIG, U6_OBSLIG, U6_CODENT, U6_LISTA, U6_CODIGO "
cQuery += " FROM "+RetSqlName("SU6") +" SU6 "
cQuery += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQuery += " AND U6_CODLIG  = '" + cCodlig + "' "
cQuery += " AND U6_LISTA  = '" + cLista + "' "
cQuery += " AND U6_CODIGO  = '" + cCodigo + "' "
cQuery += " AND RTRIM( U6_NFISCAL) = '"  + Alltrim( cNFiscal ) + "' "
cQuery += " AND RTRIM( U6_SERINF ) = '"  + Alltrim( cSrNF ) + "' "
cQuery += " AND RTRIM( U6_CODENT ) = '"  + ( cCli + cLj ) + "' "
cQuery += " AND SU6.D_E_L_E_T_ = '' "
cQuery += " ORDER BY U6_DATA DESC "

Memowrite("C:\LIGORI.SQL",cQuery)
cQuery := ChangeQuery( cQuery )

If Select("LIGORI") > 0
	DbSelectArea("LIGORI")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "LIGORI"   


LIGORI->(DbGoTop())

While !LIGORI->(EOF())

	cLigOri := LIGORI->U6_CODLIG      //U6_LISTA ORIGEM
	   
   DbSelectArea("LIGORI")
   LIGORI->(DbSkip())
Enddo

DbselectArea("LIGORI")
DbCloseArea("LIGORI")


Return(cLigOri)
