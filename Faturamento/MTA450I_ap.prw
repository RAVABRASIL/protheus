#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function MTA450I()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTA450I    � Autor � Mauricio Barros      � Data � 11/08/06   ���
�������������������������������������������������������������������������Ŀ��
���Alterado por � Gustavo Costa      � Data � 14/08/12                    ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ponto de entrada apos gravacao do SC9 liberacao de credito     ���
�������������������������������������������������������������������������Ĵ��
���altera�ao �Adequacao a nova politica do financeiro.					    ���
// USADO EM  : MATA450 - Sempre bloquear o Estoque......
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Local cTempo:=Left( Time(), 5 )


RecLock( "SC9", .F. )

//SC9->C9_BLCRED2 := "01"
SC9->C9_BLEST   := "02"
// DATA E HORA DA LIBERACAO DE CREDITO
//SC9->C9_DTBLCRE := dDataBase       //data
//SC9->C9_HRBLCRE := cTempo          //hora
//SC9->C9_USRLBCR := SUBSTR(cUsuario,7,15) //usu�rio

MsUnLock()

Return NIL
