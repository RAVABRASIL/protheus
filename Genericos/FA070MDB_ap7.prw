#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA070MDB()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Local cUsrLib6DD	:= GetNewPar("MV_XUSR6DD","PENHA/MARCE/ADMIN/INFO/HUMBE")
Local cUsrLibBX	:= GetNewPar("MV_XUSRBXR","NEIDE/REGINA/ANA NOBREGA/")

SetPrvt("LFLAG,CBANCO,CAGENCIA,CCONTA,NJUROS,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿑A070CHK  �                               � Data � 04/04/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿍aixa dos titulo na Rava                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
lFlag := .T.
nDescont := SE1->E1_DESCONT
/*conout("**********WFBAIXAS************")
conout("WFBAIXAS ESTA FORA DO FA070MDB")
conout("**********WFBAIXAS************")*/
if SE1->E1_PREFIXO == "   " .and. Upper( Alltrim( Substr( cUsuario, 7, 5 ) ) ) $ cUsrLib6DD //"PENHA MARCE ADMIN INFO "    
 //  conout("WFBAIXAS ENTROU NO SE PENHA MERCE AMIN INFO")	
   cBanco   := "CXD"
   cAgencia := "00000"
   cConta   := "0000000000"
//elseif SE1->E1_PREFIXO == "UNI" .and. Upper( Alltrim( Substr( cUsuario, 7, 5 ) ) ) == "NEIDE"   
//   cBanco   := "004"
//   cAgencia := "0185 "
//   cConta   := "20050-8   "
elseIf alltrim(upper(FunName())) == "WFBAIXAS"   .OR. alltrim(upper(FunName())) == "BAIXA20"
   cBanco   := "CXD"
   cAgencia := "00000"
   cConta   := "0000000000"
   /*conout("*********WFBAIXAS**********")
   conout("WFBAIXAS PASSOU NO FA070MDB")
   conout("*********WFBAIXAS**********")*/
endif
/*/
IF !EMPTY(SE1->E1_BAIXA)
   njuros := Round( SE1->E1_SALDO * SE1->E1_PORCJUR / 100 * (dDataBase - iif(SE1->E1_BAIXA<SE1->E1_VENCREA,SE1->E1_VENCTO,SE1->E1_BAIXA) ), 2 )
Else
  if SE1->E1_VENCREA < dDataBase
      njuros := Round( SE1->E1_SALDO * SE1->E1_PORCJUR / 100 * (dDataBase - SE1->E1_VENCTO), 2 )
Endif
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return( lFlag )
Return( lFlag )        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
