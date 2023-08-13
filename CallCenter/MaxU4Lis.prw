#Include "Rwmake.ch"
#Include "Topconn.ch"


**************************************
User Function MaxU4Lis()     
**************************************

Local cQry 		:= "" 
Local cMaxU4 	:= ""


cQry := " SELECT MAX(U4_LISTA) as U4_LISTA "
cQry += " FROM " + RetSqlname("SU4") + " SU4 "
cQry += " WHERE U4_FILIAL = '" + xFilial("SU4") + "' "
cQry += " AND SU4.D_E_L_E_T_ <>'*' "
Memowrite("C:\MAX_U4.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("MAXU4") > 0
	DbSelectArea("MAXU4")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "MAXU4" 

MAXU4->(DbGoTop())

While !MAXU4->(EOF())
    cMaxU4 := MAXU4->U4_LISTA
	MAXU4->(DBSKIP())
Enddo

cMaxU4 := Strzero(Val(cMaxU4) + 1,6)

DbCloseArea("MAXU4")

Return(cMaxU4)
