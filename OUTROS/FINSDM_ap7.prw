#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FINSDM()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("LFLAG,")

//NUMERO SEQUENCIAL DO DOCUMENTO NA MOVIMENTACAO BANCARIA
lFLAG := .T.
SX6->( DBSetOrder(1) )
If FunName() == "FINA100"      //Se estiver na Movimentacao Bancaria
   If SX6->( DbSeek( "  MV_DOCMVB" ) )
      //Aviso("M E N S A G E M ","Numero sequencial do documento -> "+StrZero(Val(SX6->X6_CONTEUD)+1,6) ,{"OK"})
      Aviso("M E N S A G E M ",SX6->X6_CONTEUD ,{"OK"})
      If RecLock( "SX6", .F. )
         SX6->X6_CONTEUD := StrZero(Val(SX6->X6_CONTEUD)+1,6)
         SX6->( DbUnlock() )
      Endif
   Endif

Else
   lFLAG := .F.
EndIf
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return ( lFLAG )
Return( lFLAG )        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
