#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#INCLUDE "fivewin.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER Chr(13)+Chr(10)

/*                                                            
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTA416BX    � Autor � Gustavo Costa       � Data � 30/10/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Selecionar itens e autorizar baixa do or�amento             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
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