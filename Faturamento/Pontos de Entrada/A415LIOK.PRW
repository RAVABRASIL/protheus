#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TOTVS.CH"

/*
Este ponto de entrada é executado na mudança de linha da GetDb do processo de orçamento de venda. Ele pode ser utilizado para complementar a validação realizada pelo sistema.

Programa Fonte
.PRW
Sintaxe
A415LIOK - Validação da linha do item digitado no Orçamento de Venda --> Nil
*/

*************

User Function A415LIOK()

local cProd		:= TMP1->CK_PRODUTO
Local aAreaTMP	:= GetArea("TMP1")
Local nN		:= TMP1->(RECCOUNT())
Local lRet      := .T.
Local nCont     := 1
/*
if nN > 1
	dbSelectArea("TMP1")
	TMP1->(dbGoTop())

	While TMP1->(!EOF()) .AND. nCont < nN
		if TMP1->CK_PRODUTO == cProd
			alert("O produto nao pode se repetir")
			RestArea(aAreaTMP)
			return .F.
		endif
		TMP1->(dbSkip())
        nCont++
	EndDo
	RestArea(aAreaTMP)
endif
*/
return lRet
