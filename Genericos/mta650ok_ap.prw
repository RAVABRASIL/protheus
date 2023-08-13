#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function MTA650OK()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("NPVAROP,")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTA650I                                          � 30/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Apos inclusao das opo de apontamento de OP's                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
MV_PVAROP - Percentual flexibilidade de apontamento de O.P.'s p/ P.A.
*/
If SC2->C2_SEQUEN # "001" .and. Left( SC2->C2_PRODUTO, 2 ) == "PI"
  nPVarOp := GetMv( "MV_PVAROP" )
  RecLock( "SC2", .F. )
  SC2->C2_QUANT   := SC2->C2_QUANT   + ( SC2->C2_QUANT * nPVarOp / 100 )
  SC2->C2_QTSEGUM := SC2->C2_QTSEGUM + ( SC2->C2_QTSEGUM * nPVarOp / 100 )
  SC2->( MsUnlock() )
  SC2->( dbCommit() )
EndIf
Return .T.
