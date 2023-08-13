#Include 'Protheus.ch'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : M410VRES.prw
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 23/08/12 | Gustavo Costa     | .T. permite eliminar os resíduos e .F. não elimina os resíduos
// ---------+-------------------+-----------------------------------------------------------
// O ponto de entrada MA235PC está localizado na rotina Eliminar Resíduos e possibilita 
// a eliminação dos residuos.

// criado para zerar o empenho negativo causado pelo cancelamento de notas

**************************
User Function M410VRES() 
**************************

Local ExpL1 := .T.
Local aAreaSC5 := getArea("SC5")
Local aAreaSC6 := getArea("SC6")
Local aAreaSC9 := getArea("SC9")
//Local nOpc  := PARAMIXB [1]


	dbSelectArea("SC6")
	dbSeek(xFilial("SC6") + SC5->C5_NUM)
	
	//Zera os empenhos
	While SC6->(!EOF()) .and. SC5->C5_NUM == SC6->C6_NUM .AND. SC6->C6_FILIAL == xFilial("SC6")
	
		RecLock("SC6",.F.)
		
		SC6->C6_QTDEMP := 0
		SC6->C6_QTDEMP2 := 0
		
		MsUnLock()
		SC6->(dbSkip())
	
	EndDo
	
	dbSelectArea("SC9")
	dbSeek(xFilial("SC9") + SC5->C5_NUM)
	
	//exclui as liberacoes
	While SC9->(!EOF()) .and. SC5->C5_NUM == SC9->C9_PEDIDO .AND. SC9->C9_FILIAL == xFilial("SC9")
	
		If Empty(SC9->C9_NFISCAL)
			RecLock("SC9",.F.)
			
			SC9->(Dbdelete())
		
			MsUnLock()
		EndIf
		SC9->(dbSkip())
	
	EndDo

	RestArea(aAreaSC5)
	RestArea(aAreaSC6)
	RestArea(aAreaSC9)

Return ExpL1


