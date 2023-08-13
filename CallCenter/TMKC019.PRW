#INCLUDE "TMKXFUN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TMKDEF.CH"
#INCLUDE "COLOR.CH"
#include "topconn.ch"

/////FUNÇÃO TKNUMERO MODIFICADA
////FLÁVIA ROCHA - 03/03/2010
****************************************
User Function TMKC019(cAlias,cCampo) 
**************************************** 


Local aArea		:= GetArea()						// Salva a area atual
Local cNumAtend	:= "" //GetSxeNum(cAlias,cCampo)			// Numero do atendimento
Local nSaveSx8 	:= GetSX8Len()						// Funcao de numeracao
Local cLista    := ""
Local cCodLig   := ""

//cNumAtend := MaxU4Liga()
//cLista := cNumAtend 
//cCodLig:= GetSxeNum("SU4","U4_CODLIG")
//DbselectArea("SU4")
//	Dbsetorder(4)
//	Dbgobottom()
//    cCodLig := SU4->U4_CODLIG

cCodLig := MaxU4Liga()	
cNumAtend := cCodLig

DbSelectArea(cAlias)
DbSetOrder(1)
While .T.
    /*
	////PROCURA PRIMEIRO NO SU4
	Dbselectarea("SU4")
	Dbsetorder(1)
	If Dbseek(xFilial("SU4") + cLista )
		while SU4->( DbSeek( xFilial( "SU4" ) + cLista ) )
	   		ConfirmSX8()
	   		//cNumAtend := GetSxeNum("SU4","U4_LISTA")
	   		cLista := Strzero(Val(cLista) + 1,6)
		enddo	
	Endif
	*/
	/*
	DbselectArea("SU4")
	Dbsetorder(4)
	DBGOTOP()
	If Dbseek(xFilial("SU4") + cCodLig )
		while SU4->( DbSeek( xFilial( "SU4" ) + cCodLig ) )
	   		ConfirmSX8()
	   		//cNumAtend := GetSxeNum("SU4","U4_LISTA")
	   		cCodLig := Strzero(Val(cCodLig) + 1,6)
		enddo	
	Endif
	
	cNumAtend := cCodLig
	*/
	////depois do SU4, verifica tb SUC
	Dbselectarea("SUC")
	Dbsetorder(1)
	If SUC->(DbSeek(xFilial("SUC") + cNumAtend) )
		while SUC->( DbSeek( xFilial( "SUC" ) + cNumAtend ) )		///enquanto encontrar número igual, confirma no SXE
			ConfirmSX8()
			cNumAtend := Strzero(Val(cNumAtend) + 1,6)   ///incrementa e volta a procurar
		Enddo
		
	Else
		Exit          ////se não encontrou, sai do loop		
	Endif
	
Enddo


RestArea(aArea)
Return(cNumAtend) 

//User Function TkNumero(cAlias,cCampo)
/*
Local aArea		:= GetArea()						// Salva a area atual
Local cNumAtend	:= GetSxeNum(cAlias,cCampo)			// Numero do atendimento
Local nSaveSx8 	:= GetSX8Len()						// Funcao de numeracao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se houver problemas na tentativa de pegar um novo numero para o Telemarketing/Televendas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cAlias)
DbSetOrder(1)
While .T.
	
	If ! DbSeek(xFilial(cAlias) + cNumAtend)
		Exit
	Endif
	While (GetSx8Len() > nSaveSx8)
		ConfirmSX8()
	End	
	
	cNumAtend:= GetSxeNum(cAlias,cCampo)
End

RestArea(aArea)
Return(cNumAtend)


*/

**************************************
Static Function MaxU4Liga()     
**************************************

Local cQry 		:= "" 
Local cMaxU4 	:= ""


cQry := " SELECT top 1 U4_CODLIG AS U4_CODLIG " //MAX(U4_CODLIG) as U4_CODLIG "
cQry += " FROM " + RetSqlname("SU4") + " SU4 "
cQry += " WHERE U4_FILIAL = '" + xFilial("SU4") + "' "
cQry += " AND SU4.D_E_L_E_T_ <>'*' "
cQry += " ORDER BY U4_CODLIG DESC "
Memowrite("C:\Temp\MAX_U4LIG.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("MAXU4") > 0
	DbSelectArea("MAXU4")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "MAXU4" 

MAXU4->(DbGoTop())

While !MAXU4->(EOF())
    cMaxU4 := MAXU4->U4_CODLIG
	MAXU4->(DBSKIP())
Enddo

cMaxU4 := Strzero(Val(cMaxU4) + 1,6) 
DbselectArea("SU4")
	Dbsetorder(4)
	DBGOTOP()
	If Dbseek(xFilial("SU4") + cMaxU4 )
		while SU4->( DbSeek( xFilial( "SU4" ) + cMaxU4 ) )
	   		ConfirmSX8()
	   		//cNumAtend := GetSxeNum("SU4","U4_LISTA")
	   		cMaxU4 := Strzero(Val(cMaxU4) + 1,6)
		enddo	
	Endif

DbCloseArea("MAXU4")

Return(cMaxU4)

