#INCLUDE "RWMAKE.CH"

USER FUNCTION BUSCAMP()

Local valmp := 0

SX5->(DBSETORDER(1))
If SX5->(Dbseek(xFilial("SX5") + 'Z3' + Alltrim( Substr(Dtos(dDatabase),1,6)) ))
	valmp := Val( Alltrim(SX5->X5_DESCRI) )
Endif

Return(valmp)