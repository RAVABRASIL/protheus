#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA60FIL()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CFIL,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FA60FIL   �                               � Data � 19/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Filtro para transferencia bancario - bordero                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
cFil := "SE1->E1_PREFIXO $ 'UNI/0  '"
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return( cFil )
Return( cFil )        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02



