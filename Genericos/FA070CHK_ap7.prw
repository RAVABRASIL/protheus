#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA070CHK()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Local cUsrLib		:= GETNEWPAR("MV_XUSRLIB","PENHA/ADMIN/MARCE/INFO/REGINA/SOLANGE.MOTA/ERIKA")
Local cUsrLibXDD	:= GETNEWPAR("MV_XUSRLIX","SOLANGE.MOTA/REGINA")

SetPrvt("LFLAG,NJUROS,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿑A070CHK  �                               � Data � 04/04/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o � FINA070 - Baixa dos titulo na Rava                         낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
lFlag := .F.
//conout(FunName())
/*conout("**********WFBAIXAS************")
conout("WFBAIXAS ESTA FORA DO FA070CHK")
conout("**********WFBAIXAS************")*/   
if Upper( Substr( cUsuario, 7, 5 ) ) $ cUsrLib //"PENHA/ADMIN/MARCE/INFO/ORLAN/SILVANA/ANA NOBREGA"
   //conout("WFBAIXAS ENTROU NO SE PENHA MERCE AMIN INFO")	
   lFlag := .T.
elseif SE1->E1_PREFIXO # "   " .and. Upper( Alltrim( Substr( cUsuario, 7, 15 ) ) ) $ cUsrLibXDD//"REGINA/ANA NOBREGA/SOLANGE.MOTA/ORLANDO"
   lFlag := .T.
elseIf alltrim(upper(FunName())) == "WFBAIXAS"  .OR. alltrim(upper(FunName())) == "BAIXA20"
   /*conout("*********WFBAIXAS**********")
   conout("WFBAIXAS PASSOU NO FA070CHK")
   conout("*********WFBAIXAS**********")*/
   lFlag := .T.   
else
   lFlag := .F.
endif

If !lFlag
	MsgAlert("Sem Permiss�o Para Efetuar Baixas")
Endif

Return( lFlag )
