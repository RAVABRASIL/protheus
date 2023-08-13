#include "Topconn.ch"
#include "rwmake.ch"

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function fatacs()
nToal := 0

	If substring(cCod,1,1) == 'C'
		cQuery := "select sum(SG1.G1_QUANT * SB1.B1_UPRC) as total"
		cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
		cQuery += "where  SB1.B1_COD = SG1.G1_COD and SB1.B1_ATIVO = 'S' "
		cQuery += "and SB1.B1_COD = " + alltrim(cCod) + " "
		cQuery += "and (substring(SG1.G1_COMP,1,2) in ('AC','MH','ST') or SG1.G1_COMP in ('ME0106','ME0104')) "
		cQuery += "and SB1.FILIAL = " + xFilial("SB1") + " and SG1.FILIAL = " + xFilial("SG1") + " "
		cQuery += "and SB1.D_E_L_E_T_ != '*' and SG1.D_E_L_E_T_ != '*' "
		cQuery += "group by SG1.G1_COD "
		cQUery += "order by SG1.G1_COD "
		cQuery := ChangeQUery(cQuery)
		TCQUERY cQUery NEW ALIAS "TMP"
		TMP->( DbGoTop() )
	Else
		Alert("Produto nao e hospitalar.")
		return Nil
	EndIf

	nTotal := TMP->total
	TMP->( DbCloseArea() )

return nTotal


