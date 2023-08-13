#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/07/01

/*
�����������������������������������������������������������������������������
���Desc.     � Cobranca Externa                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rava Embalagens - Cobranca                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function COBC03()        // incluido pelo assistente de conversao do AP5 IDE em 26/07/01

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CCADASTRO,AROTINA,")


cCadastro := "Cobranca Externa"

aRotina := { { "Criar Bordero" ,'U_COBC031()',0,6 },;            
             { "Canc. Bordero" ,'U_COBC037()',0,6 },;             
             { "Impr. Bordero" ,'U_COBC033()',0,6 },;             
             { "Rec.  Bordero" ,'U_COBC034()',0,6 },;
             { "Relat Receb."  ,'U_COBC035()',0,6 },;
             { "Carg.Expirada" ,'U_COBC036()',0,6 } }

mBrowse(6,1,22,75,"SA1")

Return(nil) //incluido pelo assistente de conversao do AP5 IDE em 26/07/01
