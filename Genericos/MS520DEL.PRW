#Include "Rwmake.ch"
#Include "Topconn.ch"


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
//³Programa:  M520DEL( ) -   PE no cancelamento da NF saída ³
//³Autoria   : Flávia Rocha                                 ³
//³Data: 01/10/2008.                                        ³
//Em caso de cancelamento da nf, este ponto irá limpar os 
//bloqueios para que qdo for efetuar o estorno da liberação,
//não precisar antes desbloquear para estornar.
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

User Function MS520DEL( ) 

Local cPedido := ""

SD2->(DBSETORDER(3))
If SD2->(Dbseek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE ))
	cPedido := SD2->D2_PEDIDO
Endif


SC9->(DBSETORDER(1))
If SC9->(Dbseek(xFilial("SC9") + cPedido )) 	
	While SC9->(!EOF()) .AND. SC9->C9_FILIAL == xFilial("SC9") .AND. SC9->C9_PEDIDO == cPedido
			If Reclock("SC9",.F.)
				SC9->C9_BLEST := ""
				SC9->C9_BLCRED:= "" 
				SC9->(MsUnlock())
			Endif
			SC9->(DBSKIP())
	Enddo
Endif




Return .T.
