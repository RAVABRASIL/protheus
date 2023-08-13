// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : CriaItemCTB
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 23/11/12 | Gustavo Costa 	 | Cria os itens contabeis.
// ---------+-------------------+-----------------------------------------------------------

#Include "Protheus.ch"
#include "rwmake.ch"

User Function CriaItemCTB()

Local cQuery 	:= ""

cQuery := " SELECT A1_COD, A1_LOJA, A1_NOME FROM " + RETSQLNAME("SA1")
cQuery += " WHERE D_E_L_E_T_ <> '*' "

cQuery := ChangeQuery(cQuery)

If Select("TMP") > 1
	TMP->(dbCloseArea())
EndIf
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)

dbSelectArea("TMP")
dbGoTop()

dbSelectArea("CTD")
dbSetOrder(1)

While TMP->(!Eof())

	If CTD->(!dbSeek(xFilial("CTD") + "CLI" + TMP->A1_COD + TMP->A1_LOJA))
	
		RecLock("CTD",.T.)
			
			CTD->CTD_FILIAL	:= xFilial("CTD")
			CTD->CTD_ITEM		:= "CLI" + TMP->A1_COD + TMP->A1_LOJA
			CTD->CTD_CLASSE	:= "2"
			CTD->CTD_DESC01	:= TMP->A1_NOME
			
		MsUnLock()
		
	EndIf	
	TMP->(dbSkip())

EndDo

TMP->(dbCloseArea())

cQuery := " SELECT A2_COD, A2_LOJA, A2_NOME FROM " + RETSQLNAME("SA2")
cQuery += " WHERE D_E_L_E_T_ <> '*' "

cQuery := ChangeQuery(cQuery)

If Select("TMP") > 1
	TMP->(dbCloseArea())
EndIf
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)

dbSelectArea("CTD")
dbSetOrder(1)

dbSelectArea("TMP")
dbGoTop()

While TMP->(!Eof())

	If CTD->(!dbSeek(xFilial("CTD") + "FOR"  + TMP->A2_COD + TMP->A2_LOJA))
	
		RecLock("CTD",.T.)
			
			CTD->CTD_FILIAL	:= xFilial("CTD")
			CTD->CTD_ITEM		:= "FOR" + TMP->A2_COD + TMP->A2_LOJA
			CTD->CTD_CLASSE	:= "2"
			CTD->CTD_DESC01	:= TMP->A2_NOME
			
		MsUnLock()
		
	EndIf	
	TMP->(dbSkip())

EndDo

TMP->(dbCloseArea())

Return

