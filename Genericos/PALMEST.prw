#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function PALMEST()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �PALMEST   � Autor � Eurivan Marques       � Data � 24/05/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Manutencao da tabela de Conferencia de Notas Fiscais        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

Private cCadastro := "Observacao da Conferencia de Notas"

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar" ,"AxPesqui",0,1} ,;
                     {"Visualizar","AxVisual",0,2} ,;
                     {"Alterar"   ,"AxAltera",0,4},; 
                     {"Excluir"   ,"AxDeleta",0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

dbSelectArea("Z06")
dbSetOrder(1)

mBrowse( 6,1,22,75,"Z06")

Return