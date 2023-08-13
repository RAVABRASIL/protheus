#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function F070ALTV()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt( "NJUROS," )

//IF !EMPTY(SE1->E1_BAIXA)
//  njuros := Round( SE1->E1_SALDO * SE1->E1_PORCJUR / 100 * (dBaixa - iif(SE1->E1_BAIXA<SE1->E1_VENCREA,SE1->E1_VENCTO,SE1->E1_BAIXA) ), 2 )
//else
   if SE1->E1_VENCREA < dBaixa
      njuros := Round( SE1->E1_SALDO * SE1->E1_PORCJUR / 100 * (dBaixa - SE1->E1_VENCTO), 2 )
   ENDIF
//ENDIF

Return( nil ) // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

