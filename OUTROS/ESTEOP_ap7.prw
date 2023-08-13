#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function ESTEOP()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("LFLAG,ACOLS,")

lFLAG := .T.
SB1->( DBSetOrder(1) )
If FunName() == "MATA250"      //Se estiver apontando a producao...
   If SB1->( DbSeek( xFILIAL('SB1') + M->D3_COD ) )
      //aCOLS[ n, 4 ] := SZ2->Z2_PRUNIT
      If SB1->B1_UM == "FD"
         Aviso("M E N S A G E M ","NÆo esque‡a a conversÆo (MILHEIRO ->FARDO)",{"OK"})
      Endif
   Endif

//Else
   //lFLAG := .F.
EndIf
RetIndex("SB1")
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return ( lFLAG )
Return( lFLAG )        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
