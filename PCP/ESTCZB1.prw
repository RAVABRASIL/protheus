#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ESTCZB1     � Autor � Fl�via Rocha    � Data �  31/10/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Metas por M�quina e Produto - Tabela ZB1       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ESTCZB1()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZB1"

dbSelectArea("ZB1")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Metas por M�quina e Produto",cVldExc,cVldAlt)

Return
