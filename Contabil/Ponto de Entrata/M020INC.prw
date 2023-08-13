// #########################################################################################
// Projeto:
// Modulo : Após incluir o Fornecedor, deve ser utilizado para gravar arquivos/campos do usuário, complementando a inclusão.
// Fonte  : M020INC
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 23/11/12 | Gustavo Costa 	 | Utilizado para criar o Item contabil do Fornecedor
// ---------+-------------------+-----------------------------------------------------------

#Include 'Protheus.ch'

User Function M020INC()

dbSelectArea("CTD")
dbSetOrder(1)

If CTD->(!dbSeek(xFilial("CTD") + "FOR" + M->A2_COD + M->A2_LOJA))

	RecLock("CTD",.T.)
		
		CTD->CTD_FILIAL	:= xFilial("CTD")
		CTD->CTD_ITEM		:= "FOR" + M->A2_COD + M->A2_LOJA
		CTD->CTD_CLASSE	:= "2"
		CTD->CTD_DESC01	:= M->A2_NOME
		
	MsUnLock()
	
EndIf

Return

