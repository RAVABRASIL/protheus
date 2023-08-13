

#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function VLDPES()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �VLDPES                                           � 17/06/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida alteracao de peso                                    ���
���                                                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
If M->B1_PESO # 1 .and. M->B1_UM == "KG"
   msgbox( "Produto com unidade de medida Kg peso tem que ser 1","info","stop")
   Return .F.
EndIf
Return .T.
