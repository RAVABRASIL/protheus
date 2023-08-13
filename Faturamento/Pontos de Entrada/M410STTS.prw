#Include "Rwmake.ch"


/*
----------------------------------------------------------------------------------------------------------
Programa: M410STTS - Este ponto de entrada pertence � rotina de pedidos de venda, MATA410().
                     Est� em todas as rotinas de altera��o, inclus�o, exclus�o e devolu��o de compras.
                     Executado ap�s todas as altera��es no arquivo de pedidos terem sido feitas.
Autoria : Fl�via Rocha
Data    : 09/10/13
Objetivo: Gravar na tabela de hist�rico de Status do Pedido de Venda, cada mudan�a de status, data , hora e usu�rio
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
	ZAC->ZAC_USER   := __CUSERID //c�digo do usu�rio que criou
	ZAC->(MsUnlock())
	
	//Msginfo("Hist�rico Atualizado com Sucesso")
Endif

Return
