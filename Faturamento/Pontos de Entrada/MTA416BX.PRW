#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#INCLUDE "fivewin.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER Chr(13)+Chr(10)

/*                                                            
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MTA416BX    ³ Autor ³ Gustavo Costa       ³ Data ³ 30/10/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Selecionar itens e autorizar baixa do orçamento             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

**********************
User Function MTA416BX()      // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
**********************

Local lRet	:= .T.

If FWCodFil() <> SCK->CK_FILVEN .OR. FWCodFil() <> SCK->CK_FILENT
	MsgAlert("Filial atual diferente da filial destino do pedido!" +;
	 ENTER + "Filial atual: " + FWCodFil() + " Filial destino: " + SCK->CK_FILENT)
	lRet	:= .F.
EndIf


Return lRet



**********************
User Function MT415AUT()     
**********************

Local lRet	:= .T.

SCK->(dbseek(xFilial("SCK") + SCJ->CJ_NUM))

If FWCodFil() <> SCK->CK_FILVEN .OR. FWCodFil() <> SCK->CK_FILENT
	MsgAlert("Filial atual diferente da filial destino do pedido!" +;
	 ENTER + ENTER + "Filial atual: " + FWCodFil() + " Filial destino: " + SCK->CK_FILENT)
	lRet	:= .F.
EndIf


Return lRet