#Include "Rwmake.ch"
#Include "Topconn.ch"


*******************************
User Function MaxU6Cod()
*******************************

Local cQry 		:= "" 
Local cMaxU6 	:= ""

cQry := " SELECT MAX(U6_CODIGO) as U6_CODIGO "
cQry += " FROM " + RetSqlname("SU6") + " SU6 "
cQry += " WHERE U6_FILIAL = '" + xFilial("SU6") + "' "
cQry += " AND SU6.D_E_L_E_T_ <>'*' "
Memowrite("C:\MAX_U6.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("MAXU6") > 0
	DbSelectArea("MAXU6")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "MAXU6" 

MAXU6->(DbGoTop())

While !MAXU6->(EOF())
    cMaxU6 := MAXU6->U6_CODIGO
	MAXU6->(DBSKIP())
Enddo

cMaxU6 := Strzero(Val( cMaxU6 ) + 1,6)

DbCloseArea("MAXU6")

Return(cMaxU6)
