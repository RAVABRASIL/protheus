#INCLUDE 'RWMAKE.CH'
#include "topconn.ch" 
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"

//////////////////////////////////////////////////////////////////////////////////////
//Programa: AGENDAMENTOS.PRW
//Autoria : Flávia Rocha
//Data    : 05/11/09
//Objetivo: Reunir num prw as funções de reagendamento do call Center, chamadas
//          através do ponto de entrada TK271FIMGR
///////////////////////////////////////////////////////////////////////////////////////

********************************************************************************
User Function ReagINCLU( cUCEntida, cUCFilial , cUCcodigo , cNOTACLI, cSERINF )	 
********************************************************************************
//USADA NO PONTO DE ENTRADA TK271FIMGR
//Esta função ReagINCLU só é usada na inclusão de atendimento, mas é acionada
//somente se foi registrado algum item (SUD)
//Se tem item, ou seja, houve um problema, o retorno tem que ser para o dia seguinte.

Local cQuery := ""
Local dDtReaU4 := CtoD("  /  /    ")
Local dDtReaU6 := CtoD("  /  /    ")
Local dDtReaUC := CtoD("  /  /    ")
Local dDTCheg  := CtoD("  /  /    ")

cQuery := " SELECT UC_FILIAL, UC_ENTIDAD, UC_CODIGO, UC_NFISCAL, UC_SERINF, UC_PREVCHG, UC_REALCHG, "
cQuery += " U4_CODLIG, U4_LISTA, U4_DATA, U4_STATUS "
cQuery += " FROM " + RetSqlName("SUC") + " SUC, " + RetSqlName("SU4") + " SU4 "
cQuery += " WHERE UC_CODIGO = '" + cUCcodigo + "' "
cQuery += " AND UC_CODIGO = U4_CODLIG "
cQuery += " AND UC_FILIAL = '" + cUCFilial + "' "
cQuery += " AND UC_NFISCAL = '" + cNOTACLI + "' "
cQuery += " AND UC_SERINF = '" + cSERINF + "' "
cQuery += " AND UC_ENTIDAD = '" + cUCEntida + "' "
cQuery += " AND U4_STATUS = '1' "
cQuery += " AND SUC.D_E_L_E_T_ = '' "
cQuery += " AND SU4.D_E_L_E_T_ = '' "
Memowrite("C:\REAGINCLU.SQL",cQuery)


If Select("REAGI") > 0

	DbSelectArea("REAGI")
	DbCloseArea()
	
EndIf


TCQUERY cQuery NEW ALIAS "REAGI"

TCSetField( "REAGI" , "UC_PREVCHG", "D")
TCSetField( "REAGI" , "UC_REALCHG", "D")

REAGI->(DbGoTop())

   
While !REAGI->(Eof()) 

	If !Empty(REAGI->UC_REALCHG)
		If ( REAGI->UC_REALCHG > REAGI->UC_PREVCHG )
			dDTCheg := REAGI->UC_REALCHG
		Else 
			dDTCheg := REAGI->UC_PREVCHG
		Endif	
	Endif 
	
	DbSelectArea("SU4")
	DbSetOrder(1)          // U4_FILIAL + U4_LISTA
	SU4->(DbSeek(xFilial("SU4") + REAGI->U4_LISTA ))
	While !Eof() .And. SU4->U4_FILIAL == xFilial("SU4") .And. SU4->U4_CODLIG == REAGI->U4_CODLIG;
	.And. SU4->U4_LISTA == REAGI->U4_LISTA 	     
		
		If !Empty( dDTCheg )
			dDtReaU4 := DataValida( dDTCheg + 1 )
		Else 
			dDtReaU4 := Datavalida( dDatabase + 1 )
		Endif
		
		RecLock("SU4",.F.)
		SU4->U4_DATA	:= dDtReaU4							
		SU4->(MsUnLock())
		SU4->(DbSkip())
	EndDo 
	//---------------------------------------------------------------------

	DbSelectArea("SU6")
	DbSetOrder(1)          // U6_FILIAL + U6_LISTA + U6_CODIGO		
	SU6->(DbSeek(xFilial("SU6") + REAGI->U4_LISTA ))	
	While !Eof() .And. SU6->U6_FILIAL == xFilial("SU6") .And.  SU6->U6_CODLIG == REAGI->U4_CODLIG;
	.And. SU6->U6_LISTA == REAGI->U4_LISTA 		
		
		If !Empty( dDTCheg )
			dDtReaU6 := DataValida( dDTCheg + 1 )
		Else 
			dDtReaU6 := Datavalida( dDatabase + 1 )
		Endif
		//MsgAlert("achou su6" + SU6->U6_CODLIG )
		RecLock("SU6",.F.)		
		SU6->U6_DATA	:= dDtReaU6
		SU6->U6_NFISCAL := cNOTACLI
		SU6->U6_SERINF  := cSERINF		
		SU6->(MsUnLock())
		SU6->(DbSkip())
	EndDo
	
	//---------------------------------------------------------------------
	//Atualiza o agendamento do atendimento SUC
	DbselectArea("SUC")
	Dbsetorder(1)
	Dbseek( xFilial("SUC") + REAGI->UC_CODIGO )
	While !Eof() .And. SUC->UC_FILIAL == xFilial("SUC") .And.;
					   SUC->UC_CODIGO == REAGI->UC_CODIGO 
		
		If !Empty( dDTCheg )
			dDtReaUC := DataValida( dDTCheg + 1 )
		Else 
			dDtReaUC := Datavalida( dDatabase + 1 )
		Endif
		Reclock("SUC")		
		SUC->UC_PENDENT := dDtReaUC
		SUC->UC_STATUS  := "2"		
		SUC->( MsUnlock() )	
		SUC->(DbSkip())
	EndDo	
	
	DbselectArea("REAGI")
	REAGI->(DBSKIP())
Enddo     

Return

********************************************************************************
User Function ReagRESP( cFil, cAtendto )
********************************************************************************
//	U_ReagRESP( cFil, cAtend )
//Esta função ReagRESP só é usada no momento em que o responsável pela ação
//faz o registro de data, ou seja, responde o atendimento

Local cQuery 	:= ""
Local dDTCheg	:= CtoD("  /  /    ")
Local dDTReaU4	:= CtoD("  /  /    ")
Local dDTReaU6	:= CtoD("  /  /    ")
Local dDTReaUC	:= CtoD("  /  /    ")

cQuery := " SELECT UC_FILIAL, UC_PENDENT, UC_PREVCHG, UC_REALCHG, UC_CODIGO, UD_DATA, UD_RESOLVI, "
cQuery += " U4_CODLIG, U4_LISTA, U4_DATA, U4_STATUS "
cQuery += " FROM " + RetSqlName("SUC") + " SUC, "  + RetSqlName("SUD") + " SUD, " + RetSqlName("SU4") + " SU4 "
cQuery += " WHERE UC_FILIAL = UD_FILIAL "
cQuery += " AND UC_CODIGO = UD_CODIGO "
cQuery += " AND U4_CODLIG = UC_CODIGO "
cQuery += " AND UC_CODIGO = '" + cAtendto + "' "
cQuery += " AND UC_FILIAL = '" + cFil + "' "
cQuery += " AND UD_DATA <> '' "
cQuery += " AND UD_RESOLVI <> 'S' "
cQuery += " AND U4_STATUS = '1' "
cQuery += " AND SUC.D_E_L_E_T_ = '' "
cQuery += " AND SUD.D_E_L_E_T_ = '' "
cQuery += " AND SU4.D_E_L_E_T_ = '' "
cQuery += " GROUP BY UC_FILIAL, UC_PENDENT, UC_PREVCHG, UC_REALCHG, UC_CODIGO, UD_DATA, UD_RESOLVI, U4_CODLIG, U4_LISTA, U4_DATA, U4_STATUS  "
cQuery += " ORDER BY UC_CODIGO "
Memowrite("C:\REAGRESP.SQL",cQuery)


If Select("RESP") > 0

	DbSelectArea("RESP")
	DbCloseArea()
	
EndIf

TCQUERY cQuery NEW ALIAS "RESP"
TCSetField( "RESP", "UC_PREVCHG", "D")
TCSetField( "RESP", "UC_REALCHG", "D")

RESP->(DbGoTop())

   
While !RESP->(Eof()) 

	
		
	//Atualiza o agendamento do atendimento
	DbselectArea("SUC")
	Dbsetorder(1)
	Dbseek( xFilial("SUC") + RESP->UC_CODIGO )
	While !Eof() .And. SUC->UC_FILIAL == xFilial("SUC") .And.;
					   SUC->UC_CODIGO == RESP->UC_CODIGO 
		
		dDTReaUC := DataValida( dDatabase + 1 )	
		DbselectArea("SUC")
		Reclock("SUC")     
		SUC->UC_PENDENT := dDTReaUC
		SUC->UC_STATUS  := "2"		// 2=Pendente ->MUDA O STATUS PARA PENDENTE PARA QUE POSSA SER MANIPULADO FUTURAMENTE
		SUC->( MsUnlock() )	
		SUC->(Dbskip())
	Enddo
	//----------------------------------------------------------
	//Reagenda a ligação para a data digitada - SU4
	//DbSelectArea("SU4")
	//DbSetOrder(4)          // U4_FILIAL + U4_CODLIG
	//SU4->( DbSeek(xFilial("SU4") + RESP->UC_CODIGO ))
	//While !Eof() .And. SU4->U4_FILIAL == xFilial("SU4") .And. SU4->U4_CODLIG == RESP->UC_CODIGO
	
	DbSelectArea("SU4")
	DbSetOrder(1)          // U4_FILIAL + U4_LISTA
	SU4->(DbSeek(xFilial("SU4") + RESP->U4_LISTA ))
	While !Eof() .And. SU4->U4_FILIAL == xFilial("SU4") .And. SU4->U4_CODLIG == RESP->U4_CODLIG;
	.And. SU4->U4_LISTA == RESP->U4_LISTA 	     
		
		dDTReaU4 := DataValida( dDatabase + 1 )			
		RecLock("SU4",.F.)
		SU4->U4_DATA	:= dDTReaU4
		SU4->(MsUnLock())
		SU4->(DbSkip())
	EndDo
	//----------------------------------------------------------
	//Reagenda a ligação para a data digitada - SU6
	//DbSelectArea("SU6")
	//DbSetOrder(4)          // U6_FILIAL + U6_CODLIG + U6_NFISCAL + U6_SERINF
	//SU6->(DbSeek(xFilial("SU6") + RESP->UC_CODIGO ))
	//While !Eof() .And. SU6->U6_FILIAL == xFilial("SU6") .And. SU6->U6_CODLIG == RESP->UC_CODIGO
	
	DbSelectArea("SU6")
	DbSetOrder(1)          // U6_FILIAL + U6_LISTA + U6_CODIGO		
	SU6->(DbSeek(xFilial("SU6") + RESP->U4_LISTA ))	
	While !Eof() .And. SU6->U6_FILIAL == xFilial("SU6") .And.  SU6->U6_CODLIG == RESP->U4_CODLIG;
	.And. SU6->U6_LISTA == RESP->U4_LISTA 		
		
		dDTReaU6 := DataValida( dDatabase + 1  )	
		RecLock("SU6",.F.)
		SU6->U6_DATA	:= dDTReaU6
		SU6->(MsUnLock())
		SU6->(DbSkip())
	EndDo 	
	
	DbselectArea("RESP")
	RESP->(DBSKIP())	

Enddo     

Return






****************************************
User Function Reag2ALT( cFil, cAtendto )
****************************************

//Se é alteração, na manipulação do atendimento, 
//irá reagendar quando TODOS os itens estiverem resolvidos:
//UD_RESOLVI = "S" 

Local cQuery 	:= ""
Local dDT2   	:= CtoD("  /  /    ")
Local dDTCheg	:= CtoD("  /  /    ")
Local dDTReaU4	:= CtoD("  /  /    ")
Local dDTReaU6	:= CtoD("  /  /    ")
Local dDTReaUC	:= CtoD("  /  /    ")
Local lEncerrar := .F.
Local cFilUC	:= ""
Local cCodUC	:= ""

cQuery := " SELECT TOP 1 UD_DATA, UD_RESOLVI, UC_FILIAL, UC_PENDENT, UC_PREVCHG, UC_REALCHG, UC_CODIGO, UD_RESOLVI, " 
cQuery += " U4_CODLIG, U4_LISTA, U4_DATA, U4_STATUS "
cQuery += " FROM " + RetSqlName("SUC") + " SUC, "  + RetSqlName("SUD") + " SUD, " + RetSqlName("SU4") + " SU4 "
cQuery += " WHERE UC_FILIAL = UD_FILIAL "
cQuery += " AND UC_CODIGO = UD_CODIGO "
cQuery += " AND U4_CODLIG = UC_CODIGO "
cQuery += " AND UC_CODIGO = '" + cAtendto + "' "
cQuery += " AND UC_FILIAL = '" + cFil + "' "
cQuery += " AND UD_DATA <> '' "
cQuery += " AND UD_RESOLVI = 'S' "
cQuery += " AND U4_STATUS = '1' "
cQuery += " AND SUC.D_E_L_E_T_ = '' "
cQuery += " AND SUD.D_E_L_E_T_ = '' "
cQuery += " AND SU4.D_E_L_E_T_ = '' "
cQuery += " GROUP BY UD_DATA, UD_RESOLVI, UC_FILIAL, UC_PENDENT, UC_PREVCHG, UC_REALCHG, UC_CODIGO, U4_CODLIG, U4_LISTA, U4_DATA, U4_STATUS  "
cQuery += " ORDER BY UD_DATA "
Memowrite("C:\REAG2ALT.SQL",cQuery)

If Select("RESOL1") > 0

	DbSelectArea("RESOL1")
	DbCloseArea()
	
EndIf

TCQUERY cQuery NEW ALIAS "RESOL1"
TCSetField( "RESOL1", "UC_PREVCHG", "D")
TCSetField( "RESOL1", "UC_REALCHG", "D")

RESOL1->(DbGoTop())

   
While !RESOL1->(Eof()) 

	//MsgAlert(" CODLIG /LISTA / STATUS: " + RESOL1->U4_CODLIG + "/" + RESOL1->U4_LISTA + "/" + RESOL1->U4_STATUS )
	
	If Empty(RESOL1->UC_REALCHG)
		dDTCheg := RESOL1->UC_PREVCHG
	
	Elseif ( RESOL1->UC_REALCHG > RESOL1->UC_PREVCHG )
		dDTCheg := RESOL1->UC_REALCHG
	
	Else
		dDTCheg := RESOL1->UC_PREVCHG	
	Endif
	
		
	//Atualiza o agendamento do atendimento
	DbselectArea("SUC")
	Dbsetorder(1)
	Dbseek( RESOL1->UC_FILIAL + RESOL1->UC_CODIGO )
	While !Eof() .And. SUC->UC_FILIAL == xFilial("SUC") .And.;
					   SUC->UC_CODIGO == RESOL1->UC_CODIGO 
		
		If dDTCheg > dDatabase
			dDTReaUC := dDTCheg
		
		Elseif dDTCheg < dDatabase   //SE A DATA DE CHEGADA FOR MENOR QUE A DATABASE, TEORICAMENTE O PRODUTO JÁ CHEGOU.
			dDTReaUC  := dDatabase
			lEncerrar := .T.
		
		Elseif dDTCheg == dDatabase
			dDTReaUC := dDTCheg
		Endif				
		
		DbselectArea("SUC")
		Reclock("SUC")     
		
		
		//If MsgYesNo("Os itens foram resolvidos, deseja ENCERRAR este atendimento?")
			lEncerrar := .T.
			SUC->UC_STATUS := "3"     //3= Encerrado -> Encerra o atendimento
			cFilUC := SUC->UC_FILIAL
			cCodUC := SUC->UC_CODIGO
			//ATUALIZA SUD
			DbselectArea("SUD")
			SUD->(Dbsetorder(1))
			SUD->(Dbseek( cFilUC + cCodUC ))
			While SUD->(!Eof()) .And. SUD->UD_FILIAL == cFilUC .And. SUD->UD_CODIGO == cCodUC
    			If SUD->UD_RESOLVI = "S"
    				Reclock("SUD",.F.)
    				SUD->UD_STATUS := "2"
    				SUD->(MsUnlock())    	
    			Endif
				SUD->(Dbskip())
			Enddo             
			
		//Else
			//SUC->UC_PENDENT := DataValida(dDTReaUC + 1)
			//SUC->UC_STATUS  := "2"		// 2=Pendente ->MUDA O STATUS PARA PENDENTE PARA QUE POSSA SER MANIPULADO FUTURAMENTE
			//lEncerrar := .F.
		//Endif		
		SUC->( MsUnlock() )	
		SUC->(Dbskip())
	Enddo
	
	//-------------------------------------------------------------
	DbSelectArea("SU4")
	DbSetOrder(1)          // U4_FILIAL + U4_LISTA
	//Procura o atendimento (itens) e grava a data de resposta		
	SU4->(DbSeek(xFilial("SU4") + RESOL1->U4_LISTA ))
	While !Eof() .And. SU4->U4_FILIAL == xFilial("SU4") .And. SU4->U4_CODLIG == RESOL1->U4_CODLIG;
	.And. SU4->U4_LISTA == RESOL1->U4_LISTA 	    
		
		If dDTCheg > dDatabase
			dDTReaU4 := dDTCheg
		
		Elseif dDTCheg < dDatabase
			dDTReaU4 := dDatabase			
		
		Elseif dDTCheg == dDatabase
			dDTReaU4 := dDTCheg
		Endif	
		
		RecLock("SU4",.F.)
		If lEncerrar
			SU4->U4_STATUS := "2"      // 2 = Encerrada
		//Else
			//SU4->U4_DATA	:= DataValida(dDTReaU4 + 1 )
		Endif
		SU4->(MsUnLock())
		SU4->(DbSkip())
	EndDo	

	//--------------------------------------------------------------------------------------				   
	DbSelectArea("SU6")
	DbSetOrder(1)          // U6_FILIAL + U6_LISTA + U6_CODIGO		
	SU6->(DbSeek(xFilial("SU6") + RESOL1->U4_LISTA ))	
	While !Eof() .And. SU6->U6_FILIAL == xFilial("SU6") .And.  SU6->U6_CODLIG == RESOL1->U4_CODLIG;
	.And. SU6->U6_LISTA == RESOL1->U4_LISTA 		
		
		If dDTCheg > dDatabase
			dDTReaU6 := dDTCheg
		
		Elseif dDTCheg < dDatabase
			dDTReaU6 := dDatabase
				
		Elseif dDTCheg == dDatabase
			dDTReaU6 := dDTCheg
		Endif	
		
		RecLock("SU6",.F.)
		If lEncerrar
			SU6->U6_STATUS = "2"       // 2= Em Uso -> Desta forma, ficará com a legenda verde na lista, VERDE = Encerrado
		//Else
			//SU6->U6_DATA	:= DataValida( dDTReaU6 + 1 )
		Endif
		SU6->(MsUnLock())
		SU6->(DbSkip())
	EndDo 
	
	
	DbselectArea("RESOL1")
	RESOL1->(DBSKIP())	

Enddo     

Return


