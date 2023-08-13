#INCLUDE 'RWMAKE.CH'
#include "topconn.ch" 
#INCLUDE "Protheus.ch"
//#INCLUDE "AP5MAIL.CH" 
//#INCLUDE "TBICONN.CH"

//////////////////////////////////////////////////////////////////////////////////////
//Programa: ENCERRA-LIGACAO.PRW
//Autoria : Flávia Rocha
//Data    : 13/11/09
//Objetivo: Encerra a ligação. Esta função é acionada
//          através do ponto de entrada TK271FIMGR
///////////////////////////////////////////////////////////////////////////////////////

********************************************************************
User Function fEncerrIP( cUCFilial, cUCcodigo, cNOTACLI, cSERINF )   
********************************************************************
//encerra na inclusão de atendimento / ligação problema
Local cFilUC := ""
Local cCodUC := ""
Local cQuery := ""
Local cCodLig:= ""
Local cLista := ""
Local LF      	:= CHR(13)+CHR(10) 
Local cDesc		:= "" 

//Encerra o atual
cQuery := " SELECT UC_FILIAL, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_PENDENT, UC_PREVCHG, UC_REALCHG, UC_OBSPRB, UC_RETENC, "+LF
cQuery += " U4_CODLIG, U4_LISTA, U4_DATA, U4_STATUS, U6_CODLIG, U6_LISTA, U6_DATA, U6_ENTIDA, U6_CODENT, UC_TIPOATD, UC_REDESP, UC_DATRASO "+LF
cQuery += " FROM " + LF
cQuery += " " + RetSqlname("SUC") + " SUC, " + LF
cQuery += " " + RetSqlName("SU6") + " SU6, " + LF
cQuery += " " + RetSqlName("SU4") + " SU4 "  +LF

cQuery += " WHERE UC_CODIGO = U4_CODLIG "+LF 
cQuery += " AND U4_FILIAL = U6_FILIAL "       +LF 
cQuery += " AND U4_FILIAL = UC_FILIAL "       +LF   
cQuery += " AND U4_LISTA = U6_LISTA "       +LF   
//cQuery += " AND UC_FILIAL = '" + cUCFilial + "' "+LF
cQuery += " AND UC_CODIGO = '" + cUCcodigo + "' "+LF
cQuery += " AND (UC_NFISCAL) = '" + Alltrim(cNOTACLI) + "' "+LF
cQuery += " AND (UC_SERINF) = '" + Alltrim(cSERINF) + "' "+LF
cQuery += " AND (UC_FILIAL) = '" + Alltrim(xFilial("SUC")) + "' "+LF
cQuery += " AND U4_STATUS = '1' "+LF  
cQuery += " AND U4_TIPO = '3' "+LF
cQuery += " AND  (UC_OBSPRB) = 'S' " + LF
cQuery += " AND SUC.D_E_L_E_T_ = '' "+LF
cQuery += " AND SU6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SU4.D_E_L_E_T_ = '' "+LF
cQuery += " GROUP BY UC_FILIAL, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_PENDENT, UC_PREVCHG, UC_REALCHG, UC_OBSPRB, UC_RETENC, "+LF
cQuery += " U4_CODLIG, U4_LISTA, U4_DATA, U4_STATUS, U6_CODLIG, U6_LISTA, U6_DATA, U6_ENTIDA, U6_CODENT, UC_TIPOATD, UC_REDESP, UC_DATRASO "+LF
cQuery += " ORDER BY UC_FILIAL,UC_CODIGO "+LF
//Memowrite("C:\EncerI2.sql",cQuery)

If Select("ENCER") > 0

	DbSelectArea("ENCER")
	DbCloseArea()
	
EndIf

TCQUERY cQuery NEW ALIAS "ENCER"
TCSetField( "ENCER", "UC_PREVCHG", "D")
TCSetField( "ENCER", "UC_REALCHG", "D")
TCSetField( "ENCER", "UC_DATRASO", "D")


ENCER->(DbGoTop())

   
While !ENCER->(Eof())    
      
	
	  	DbselectArea("SUC")
	  	SUC->(Dbsetorder(1))
	  	If SUC->(Dbseek(xFilial("SUC") + cUCcodigo ))
	  		While SUC->UC_FILIAL == xFilial("SUC") .and. Alltrim(SUC->UC_CODIGO) == Alltrim(cUCcodigo)
	  			If Alltrim(SUC->UC_NFISCAL) = Alltrim(cNOTACLI) .and.  Alltrim(SUC->UC_SERINF) = Alltrim(cSERINF)
		  			RecLock("SUC", .F.)
		  			SUC->UC_PENDENT := dDatabase
		  			SUC->UC_STATUS  := "3" 
		  			SUC->(MsUnlock())
		  		Endif
	  			
	  			SUC->(Dbskip())
	  		Enddo
	  	
	  	Endif
	  	
	  		
		DbselectArea("SUD")
	  	SUD->(Dbsetorder(1))
	  	If SUD->(Dbseek(xFilial("SUD") + cUCcodigo ))
	  		While SUD->UD_FILIAL == xFilial("SUD") .and. Alltrim(SUD->UD_CODIGO) == Alltrim(cUCcodigo)
	  			RecLock("SUD", .F.)
	  			SUD->UD_STATUS  := "2" 
		  		SUD->(MsUnlock())
		  			  			
	  			SUD->(Dbskip())
	  		Enddo
	  	
	  	Endif
	
			If ENCER->U6_ENTIDA = "SA4"
				
			   	cDesc := "Ligacao-Transp: " + ENCER->U4_CODLIG
			
			Elseif ENCER->U6_ENTIDA = "SA1" .And. ENCER->UC_OBSPRB = "S"							
				
			    cDesc := "Problema-Entreg: " + ENCER->UC_NFISCAL							 
			
			Elseif ENCER->U6_ENTIDA = "SA1" .And. ENCER->UC_OBSPRB != "S"							
				
				cDesc := "FeedBack-Cliente: " + ENCER->UC_NFISCAL
											
			Endif			
				
		
	  	DbselectArea("SU4")
	  	SU4->(DbsetOrder(1))
	  	If SU4->(Dbseek(xFilial("SU4") + ENCER->U4_LISTA ))
	  		While SU4->U4_FILIAL == xFilial("SU4") .and. Alltrim(SU4->U4_LISTA) == Alltrim(ENCER->U4_LISTA)
	  			If Alltrim(SU4->U4_CODLIG) = Alltrim(ENCER->U4_CODLIG)
		  			RecLock("SU4", .F.)
		  			SU4->U4_DATA 	:= dDatabase
		  			SU4->U4_STATUS  := "2"
		  			SU4->U4_DESC 	:= Alltrim(cDesc) 
		  			SU4->(MsUnlock())
		  		Endif
	  			
	  			SU4->(Dbskip())
	  		Enddo
	  	
	  	Endif		
	
		//--------------------------------------------------------------------------------------
		//// SU6
	
	    DbselectArea("SU6")
	  	SU6->(DbsetOrder(1))
	  	If SU6->(Dbseek(xFilial("SU6") + ENCER->U6_LISTA ))
	  		While SU6->U6_FILIAL == xFilial("SU6") .and. Alltrim(SU6->U6_LISTA) == Alltrim(ENCER->U6_LISTA)
	  			If Alltrim(SU6->U6_CODLIG) = Alltrim(ENCER->U6_CODLIG) .AND. Alltrim(SU6->U6_STATUS) = "1"
		  			RecLock("SU6", .F.)
		  			SU6->U6_DATA 	:= dDatabase
		  			SU6->U6_STATUS	:= "3"
		  			SU6->U6_NFISCAL := ENCER->UC_NFISCAL
		  			SU6->U6_SERINF  := ENCER->UC_SERINF
		  			SU6->U6_TIPO	:= ENCER->UC_TIPOATD
		  			SU6->U6_REDESP	:= ENCER->UC_REDESP
		  			SU6->U6_DATRASO	:= ENCER->UC_DATRASO
		  			SU6->U6_REALCHG := ENCER->UC_REALCHG
		  			SU6->U6_RETENC	:= ENCER->UC_RETENC		  			
		  			
		  			SU6->(MsUnlock())
		  		Endif
	  			
	  			SU6->(Dbskip())
	  		Enddo
	  	
	  	Endif
	
	DbSelectArea("ENCER")
	ENCER->(Dbskip())
	
Enddo

  
MsgInfo("Ligação Encerrada.")
	
Return 

//DbSelectArea("ENCER")
//DbCloseArea("ENCER")  

********************************************************************
User Function fEncerIT( cUCFilial, cUCcodigo, cNOTACLI, cSERINF )   
********************************************************************
//encerra na inclusão de atendimento / ligação TRANSP
Local cFilUC := ""
Local cCodUC := ""
Local cQuery := ""
Local cCodLig:= ""
Local cLista := ""
Local LF      	:= CHR(13)+CHR(10) 
Local cDesc		:= "" 

//Encerra o atual
cQuery := " SELECT UC_FILIAL, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_PENDENT, UC_PREVCHG, UC_REALCHG, UC_OBSPRB, UC_RETENC, "+LF
cQuery += " U4_CODLIG, U4_LISTA, U4_DATA, U4_STATUS, U6_CODLIG, U6_LISTA, U6_DATA, U6_ENTIDA, U6_CODENT, UC_TIPOATD, UC_REDESP, UC_DATRASO "+LF
cQuery += " FROM  "+LF

cQuery += " " + RetSqlname("SUC") + " SUC, " + LF
cQuery += " " + RetSqlName("SU6") + " SU6, " + LF
cQuery += " " + RetSqlName("SU4") + " SU4 "  +LF

cQuery += " WHERE UC_CODIGO = U4_CODLIG "+LF
cQuery += " AND U4_LISTA = U6_LISTA "       +LF  
cQuery += " AND U4_FILIAL = U6_FILIAL "       +LF 
cQuery += " AND U4_FILIAL = UC_FILIAL "       +LF    
//cQuery += " AND UC_FILIAL = '" + cUCFilial + "' "+LF 
cQuery += " AND (UC_FILIAL) = '" + Alltrim(xFilial("SUC")) + "' "+LF
cQuery += " AND UC_CODIGO = '" + cUCcodigo + "' "+LF
cQuery += " AND  (UC_NFISCAL) = '" + Alltrim(cNOTACLI) + "' "+LF
cQuery += " AND  (UC_SERINF) = '" + Alltrim(cSERINF) + "' "+LF
cQuery += " AND U4_STATUS = '1' "+LF 
cQuery += " AND U4_TIPO <> '3' "+LF
//cQuery += " AND  (UC_OBSPRB) = 'S' " + LF
cQuery += " AND SUC.D_E_L_E_T_ = '' "+LF
cQuery += " AND SU6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SU4.D_E_L_E_T_ = '' "+LF
cQuery += " GROUP BY UC_FILIAL, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_PENDENT, UC_PREVCHG, UC_REALCHG, UC_OBSPRB, UC_RETENC, "+LF
cQuery += " U4_CODLIG, U4_LISTA, U4_DATA, U4_STATUS, U6_CODLIG, U6_LISTA, U6_DATA, U6_ENTIDA, U6_CODENT, UC_TIPOATD, UC_REDESP, UC_DATRASO "+LF
cQuery += " ORDER BY UC_FILIAL,UC_CODIGO "+LF
//Memowrite("C:\EncerI2.sql",cQuery)

If Select("ENCER") > 0

	DbSelectArea("ENCER")
	DbCloseArea()
	
EndIf

TCQUERY cQuery NEW ALIAS "ENCER"
TCSetField( "ENCER", "UC_PREVCHG", "D")
TCSetField( "ENCER", "UC_REALCHG", "D")
TCSetField( "ENCER", "UC_DATRASO", "D")


ENCER->(DbGoTop())

   
While !ENCER->(Eof())       
	
	  	DbselectArea("SUC")
	  	SUC->(Dbsetorder(1))
	  	If SUC->(Dbseek(xFilial("SUC") + cUCcodigo ))
	  		While SUC->UC_FILIAL == xFilial("SUC") .and. Alltrim(SUC->UC_CODIGO) == Alltrim(cUCcodigo)
	  			If Alltrim(SUC->UC_NFISCAL) = Alltrim(cNOTACLI) .and.  Alltrim(SUC->UC_SERINF) = Alltrim(cSERINF);
	  			.AND. Alltrim(SUC->UC_STATUS) != '3'
		  			RecLock("SUC", .F.)
		  			SUC->UC_PENDENT := dDatabase
		  			SUC->UC_STATUS  := "3" 
		  			SUC->(MsUnlock())
		  		Endif
	  			
	  			SUC->(Dbskip())
	  		Enddo
	  	
	  	Endif
	  	
	  	DbselectArea("SUD")
	  	SUD->(Dbsetorder(1))
	  	If SUD->(Dbseek(xFilial("SUD") + cUCcodigo ))
	  		While SUD->UD_FILIAL == xFilial("SUD") .and. Alltrim(SUD->UD_CODIGO) == Alltrim(cUCcodigo)
	  			RecLock("SUD", .F.)
	  			SUD->UD_STATUS  := "2" 
		  		SUD->(MsUnlock())
		  			  			
	  			SUD->(Dbskip())
	  		Enddo
	  	
	  	Endif		
		
	
			If ENCER->U6_ENTIDA = "SA4"
				
			   	cDesc := "Ligacao-Transp: " + ENCER->U4_CODLIG
			
			Elseif ENCER->U6_ENTIDA = "SA1" .And. ENCER->UC_OBSPRB = "S"							
				
			    cDesc := "Problema-Entreg: " + ENCER->UC_NFISCAL							 
			
			Elseif ENCER->U6_ENTIDA = "SA1" .And. ENCER->UC_OBSPRB != "S"							
				
				cDesc := "FeedBack-Cliente: " + ENCER->UC_NFISCAL
											
			Endif		
			
			    
	    DbselectArea("SU4")
	  	SU4->(DbsetOrder(1))
	  	If SU4->(Dbseek(xFilial("SU4") + ENCER->U4_LISTA ))
	  		While SU4->U4_FILIAL == xFilial("SU4") .and. Alltrim(SU4->U4_LISTA) == Alltrim(ENCER->U4_LISTA)
	  			If Alltrim(SU4->U4_CODLIG) = Alltrim(ENCER->U4_CODLIG)
		  			RecLock("SU4", .F.)
		  			SU4->U4_DATA 	:= dDatabase
		  			SU4->U4_STATUS  := "2"
		  			SU4->U4_DESC 	:= Alltrim(cDesc) 
		  			SU4->(MsUnlock())
		  		Endif
	  			
	  			SU4->(Dbskip())
	  		Enddo
	  	
	  	Endif	
	    
	    DbselectArea("SU6")
	  	SU6->(DbsetOrder(1))
	  	If SU6->(Dbseek(xFilial("SU6") + ENCER->U6_LISTA ))
	  		While SU6->U6_FILIAL == xFilial("SU6") .and. Alltrim(SU6->U6_LISTA) == Alltrim(ENCER->U6_LISTA)
	  			If Alltrim(SU6->U6_CODLIG) = Alltrim(ENCER->U6_CODLIG) .AND. Alltrim(SU6->U6_STATUS) = "1"
		  			RecLock("SU6", .F.)
		  			SU6->U6_DATA 	:= dDatabase
		  			SU6->U6_STATUS	:= "3"
		  			SU6->U6_NFISCAL := ENCER->UC_NFISCAL
		  			SU6->U6_SERINF  := ENCER->UC_SERINF
		  			SU6->U6_TIPO	:= ENCER->UC_TIPOATD
		  			SU6->U6_REDESP	:= ENCER->UC_REDESP
		  			SU6->U6_DATRASO	:= ENCER->UC_DATRASO
		  			SU6->U6_REALCHG := ENCER->UC_REALCHG
		  			SU6->U6_RETENC	:= ENCER->UC_RETENC		  			
		  			
		  			SU6->(MsUnlock())
		  		Endif
	  			
	  			SU6->(Dbskip())
	  		Enddo
	  	
	  	Endif
	
	DbSelectArea("ENCER")
	ENCER->(Dbskip())
	
Enddo

  
MsgInfo("A ligação foi Encerrada.")
	
Return 

//DbSelectArea("ENCER")
//DbCloseArea("ENCER")






*******************************************************************
User Function fEncerrA( cUCFilial, cUCcodigo, cNOTACLI, cSERINF )   
*******************************************************************

Local cFilUC := ""
Local cCodUC := ""
Local cQuery := ""
Local cCodLig:= ""
Local cLista := ""
//Local lEncerrar:= .F.
Local LF      	:= CHR(13)+CHR(10)
Local cDesc := ""  

cQuery := " SELECT UC_FILIAL, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_PENDENT, UC_PREVCHG, UC_REALCHG, UC_OBSPRB, "+LF
cQuery += " U4_CODLIG, U4_LISTA, U4_DATA, U4_STATUS, U6_CODLIG, U6_LISTA, U6_DATA, U6_ENTIDA, UC_TIPOATD, UC_REDESP, UC_DATRASO, UC_RETENC "+LF

cQuery += " FROM  "+LF

cQuery += " " + RetSqlname("SUC") + " SUC, " + LF
cQuery += " " + RetSqlName("SU6") + " SU6, " + LF
cQuery += " " + RetSqlName("SU4") + " SU4 "  +LF

cQuery += " WHERE UC_CODIGO = U4_CODLIG "+LF
cQuery += " AND U4_LISTA = U6_LISTA "       +LF  
cQuery += " AND U4_FILIAL = U6_FILIAL "       +LF 
cQuery += " AND U4_FILIAL = UC_FILIAL "       +LF    

cQuery += " AND (UC_FILIAL) = '" + Alltrim(xFilial("SUC")) + "' "+LF
cQuery += " AND UC_CODIGO = '" + cUCcodigo + "' "+LF
cQuery += " AND UC_NFISCAL = '" + Alltrim(cNOTACLI) + "' "+LF
cQuery += " AND UC_SERINF = '" + Alltrim(cSERINF) + "' "+LF
cQuery += " AND U4_STATUS = '1' "+LF
cQuery += " AND SUC.D_E_L_E_T_ = '' "+LF
cQuery += " AND SU6.D_E_L_E_T_ = '' "+LF
cQuery += " AND SU4.D_E_L_E_T_ = '' "+LF
cQuery += " GROUP BY UC_FILIAL, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_PENDENT, UC_PREVCHG, UC_REALCHG, UC_OBSPRB, "+LF
cQuery += " U4_CODLIG, U4_LISTA, U4_DATA, U4_STATUS, U6_CODLIG, U6_LISTA, U6_DATA, U6_ENTIDA, UC_TIPOATD, UC_REDESP, UC_DATRASO, UC_RETENC "+LF
cQuery += " ORDER BY UC_FILIAL,UC_CODIGO "+LF
//Memowrite("C:\EncerrA.sql",cQuery)

If Select("ENCA") > 0

	DbSelectArea("ENCA")
	DbCloseArea()
	
EndIf

TCQUERY cQuery NEW ALIAS "ENCA"
TCSetField( "ENCA", "UC_PREVCHG", "D")
TCSetField( "ENCA", "UC_REALCHG", "D")
TCSetField( "ENCA", "UC_DATRASO", "D")

ENCA->(DbGoTop())

   
While !ENCA->(Eof())
		
		DbselectArea("SUC")
	  	SUC->(Dbsetorder(1))
	  	If SUC->(Dbseek(xFilial("SUC") + cUCcodigo ))
	  		While SUC->UC_FILIAL == xFilial("SUC") .and. Alltrim(SUC->UC_CODIGO) == Alltrim(cUCcodigo)
	  			If Alltrim(SUC->UC_NFISCAL) = Alltrim(cNOTACLI) .and.  Alltrim(SUC->UC_SERINF) = Alltrim(cSERINF);
	  			.AND. Alltrim(SUC->UC_STATUS) != '3'
		  			RecLock("SUC", .F.)
		  			SUC->UC_PENDENT := dDatabase
		  			SUC->UC_STATUS  := "3" 
		  			SUC->(MsUnlock())
		  		Endif
	  			
	  			SUC->(Dbskip())
	  		Enddo
	  	
	  	Endif
	  	
	  	DbselectArea("SUD")
	  	SUD->(Dbsetorder(1))
	  	If SUD->(Dbseek(xFilial("SUD") + cUCcodigo ))
	  		While SUD->UD_FILIAL == xFilial("SUD") .and. Alltrim(SUD->UD_CODIGO) == Alltrim(cUCcodigo)
	  			RecLock("SUD", .F.)
	  			SUD->UD_STATUS  := "2" 
		  		SUD->(MsUnlock())
		  			  			
	  			SUD->(Dbskip())
	  		Enddo
	  	
	  	Endif				
		
		//-------------------------------------------------------------
	
			If ENCA->U6_ENTIDA = "SA4"
			
			    cDesc :="Ligacao-Transp: " + ENCA->U4_CODLIG
			
			Elseif ENCA->U6_ENTIDA = "SA1" .And. ENCA->UC_OBSPRB = "S"							
			
			    cDesc := "Problema-Entreg: " + ENCA->UC_NFISCAL							
			
			Elseif ENCA->U6_ENTIDA = "SA1" .And. ENCA->UC_OBSPRB != "S"							
			
				cDesc := "FeedBack-Cliente: " + ENCA->UC_NFISCAL							
			
			Endif
	  	
	  	DbselectArea("SU4")
	  	SU4->(DbsetOrder(1))
	  	If SU4->(Dbseek(xFilial("SU4") + ENCA->U4_LISTA ))
	  		While SU4->U4_FILIAL == xFilial("SU4") .and. Alltrim(SU4->U4_LISTA) == Alltrim(ENCA->U4_LISTA)
	  			If Alltrim(SU4->U4_CODLIG) = Alltrim(ENCA->U4_CODLIG)
		  			RecLock("SU4", .F.)
		  			SU4->U4_DATA 	:= dDatabase
		  			SU4->U4_STATUS  := "2"
		  			SU4->U4_DESC 	:= Alltrim(cDesc) 
		  			SU4->(MsUnlock())
		  		Endif
	  			
	  			SU4->(Dbskip())
	  		Enddo
	  	
	  	Endif	
	    
	    DbselectArea("SU6")
	  	SU6->(DbsetOrder(1))
	  	If SU6->(Dbseek(xFilial("SU6") + ENCA->U6_LISTA ))
	  		While SU6->U6_FILIAL == xFilial("SU6") .and. Alltrim(SU6->U6_LISTA) == Alltrim(ENCA->U6_LISTA)
	  			If Alltrim(SU6->U6_CODLIG) = Alltrim(ENCA->U6_CODLIG) .AND. Alltrim(SU6->U6_STATUS) = "1"
		  			RecLock("SU6", .F.)
		  			SU6->U6_DATA 	:= dDatabase
		  			SU6->U6_STATUS	:= "3"
		  			SU6->U6_NFISCAL := ENCA->UC_NFISCAL
		  			SU6->U6_SERINF  := ENCA->UC_SERINF
		  			SU6->U6_TIPO	:= ENCA->UC_TIPOATD
		  			SU6->U6_REDESP	:= ENCA->UC_REDESP
		  			SU6->U6_DATRASO	:= ENCA->UC_DATRASO
		  			SU6->U6_REALCHG := ENCA->UC_REALCHG
		  			SU6->U6_RETENC	:= ENCA->UC_RETENC		  			
		  			
		  			SU6->(MsUnlock())
		  		Endif
	  			
	  			SU6->(Dbskip())
	  		Enddo
	  	
	  	Endif
	  	
	  			
	DbSelectArea("ENCA")
	ENCA->(Dbskip())
	
Enddo
  
		MsgInfo("LIGAÇÃO ENCERRADA")
	
Return              

//DbSelectArea("ENCA")
//DbCloseArea("ENCA")
