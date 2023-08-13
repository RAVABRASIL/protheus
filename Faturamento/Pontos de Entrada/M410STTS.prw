#Include "Rwmake.ch"


/*
----------------------------------------------------------------------------------------------------------
Programa: M410STTS - Este ponto de entrada pertence à rotina de pedidos de venda, MATA410().
                     Está em todas as rotinas de alteração, inclusão, exclusão e devolução de compras.
                     Executado após todas as alterações no arquivo de pedidos terem sido feitas.
Autoria : Flávia Rocha
Data    : 09/10/13
Objetivo: Gravar na tabela de histórico de Status do Pedido de Venda, cada mudança de status, data , hora e usuário
Solicitado por: EURIVAN - ETAPAS PEDIDO VENDA
-----------------------------------------------------------------------------------------------------------

*/                      

************************
User Function M410STTS
************************

If Inclui
	If RecLock("SC5",.F.)
		SC5->C5_STATUS := '01'
		SC5->(MsUnlock())
	Endif
	DbSelectArea("ZAC") 
	RecLock("ZAC", .T.)
	ZAC->ZAC_FILIAL := xFilial("SC5")	
	ZAC->ZAC_PEDIDO := SC5->C5_NUM
	ZAC->ZAC_STATUS := '01'  
	ZAC->ZAC_DESCST := "PEDIDO REALIZADO"
	ZAC->ZAC_DTSTAT := Date()
	ZAC->ZAC_HRSTAT := Time()
	ZAC->ZAC_USER   := __CUSERID //código do usuário que criou
	ZAC->(MsUnlock())
	
	//Msginfo("Histórico Atualizado com Sucesso")
Endif

Return
