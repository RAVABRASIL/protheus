#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FATBLC()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("LFLAG,")

lFLAG := .T.
SA1->( DBSetOrder(1) )
//If FunName() == "MATA250"      //Se estiver apontando a producao...
   If SA1->( DbSeek( xFILIAL('SA1') + M->C5_CLIENTE, .T. ) )
      If SA1->A1_SITCLI == "I"
         Aviso("M E N S A G E M ","CLIENTE INADIMPLENTE",{"OK"})
         lFLAG := .F.
      Endif
   Endif

//Else
   //lFLAG := .F.
//EndIf
RetIndex("SA1")
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return ( lFLAG )
Return( lFLAG )        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
