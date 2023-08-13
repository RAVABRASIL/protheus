#Include "Rwmake.ch"
#Include "Protheus.ch"
//Feito por Romildo
User Function MTA185MNU()

	aAdd(aRotina,{'Libera Saldo','U_LiberaSald()', 0 , 2})

Return

User Function LiberaSald()

IF (SCP->CP_QUANT = SCP->CP_QUJE)
	Alert("Saldo da Requisição Totalmente Entregue")
Else
	RECLOCK("SCP",.F.)
		SCP->CP_PREREQU := ''
	SCP->(MsUnlock())
	Alert("Saldo da Requisição " + SCP->CP_NUM + " é Produto " + SCP->CP_PRODUTO + " Liberado" )
Endif

Return

