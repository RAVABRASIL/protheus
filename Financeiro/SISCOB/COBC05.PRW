#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/07/01

/*
�����������������������������������������������������������������������������
���Desc.     � Gerenciador de ligacoes da cobranca                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rava Embalagens - Cobranca                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function COBC05()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CCADASTRO,AROTINA,")


cCadastro := "Gerenciador de ligacoes da cobranca"

aRotina := { { "Pesquisar" ,'AxPesqui',0,1} ,;
				 { "Consultar" ,'U_COBC051()',0,6 } }

mBrowse( 6, 1, 22, 75, "ZA8")
Return(nil)
