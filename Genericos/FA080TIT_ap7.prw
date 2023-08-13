#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA080TIT()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("LFLAG,NJUROS,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FA080TIT  �                               � Data � 12/02/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Baixa dos titulo na Rava (Verifica divergencias nas datas)  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

lFlag := .f.

if DBAIXA = dDataBase
   lFlag := .t.
else
   Help( '', 1, 'DATAS DIFERENTES', , 'Data de recebimento diferente da Data base.', 1, 0 )
   lFlag := .F.
endif

Return( lFlag )        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
