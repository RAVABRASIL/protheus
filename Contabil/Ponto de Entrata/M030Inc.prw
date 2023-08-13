// #########################################################################################
// Projeto:
// Modulo : Este Ponto de Entrada é chamado após a inclusão dos dados do cliente no Arquivo..
// Fonte  : M030Inc
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 23/11/12 | Gustavo Costa 	 | Utilizado para criar o Item contabil do cliente
// ---------+-------------------+-----------------------------------------------------------

#Include 'Protheus.ch'

User Function M030Inc()

//Se o usuario clicou em cancelar
If PARAMIXB == 3	

Else
	
	dbSelectArea("CTD")
	dbSetOrder(1)

	If CTD->(!dbSeek(xFilial("CTD") + "CLI" + M->A1_COD + M->A1_LOJA))
	
		RecLock("CTD",.T.)
			
			CTD->CTD_FILIAL	:= xFilial("CTD")
			CTD->CTD_ITEM		:= "CLI" + M->A1_COD + M->A1_LOJA
			CTD->CTD_CLASSE	:= "2"
			CTD->CTD_DESC01	:= M->A1_NOME
			
		MsUnLock()
		
	EndIf
	
EndIf


Return

