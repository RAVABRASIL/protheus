#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function dbu()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CCADASTRO,AROTINA,")

Ccadastro := "TESTE"
aRotina := { { "Pesquisar", "AxPesqui",0,1}, ;
             { "Visualizar", "AxVisual",0,2}}
MarkBrowse( "SIX" )

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

