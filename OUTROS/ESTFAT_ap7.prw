#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function ESTFAT()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("LFLAG,")

lFLAG := .T.
SB1->( DBSetOrder(1) )
Aviso("M E N S A G E M ","Fator de Conversao -> "+TRANSF(1/SB1->B1_PESO,"@E 999.999999"),{"OK"})
RetIndex("SB1")
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return ( lFLAG )
Return( lFLAG )        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
