#INCLUDE "rwmake.ch"

User Function FA070CA4()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Local cUsrLib6DD	:= GetNewPar("MV_XUSR6DD","PENHA/MARCE/ADMIN/INFO/HUMBE")
Local cUsrLibBX	:= GetNewPar("MV_XUSRBXR","NEIDE/REGINA/ANA NOBREGA/")

SetPrvt("LFLAG,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿑A070CA4  �                               � Data � 11/04/00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿎ancelamento da Baixa dos titulo - Verificacao do usuario   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

lFlag := .F.
/*conout("**********WFBAIXAS************")
conout("WFBAIXAS ESTA FORA DO FA070MDB")
conout("**********WFBAIXAS************")   */
If SE1->E1_PREFIXO # "   " .and. ( Upper( Substr( cUsuario, 7, 7 ) ) $ cUsrLibBX .OR. Upper( Substr( cUsuario, 7, 5 ) ) $ cUsrLib6DD )
   lFlag := .T.
endif

if SE1->E1_PREFIXO == "   " .and. Upper( Substr( cUsuario, 7, 5 ) ) $ cUsrLib6DD
   //conout("WFBAIXAS ENTROU NO SE PENHA MERCE AMIN INFO")	
   lFlag := .T.
//elseif SE1->E1_PREFIXO # "   " .and. Upper( Substr( cUsuario, 7, 5 ) ) $ "NEIDE/REGIN/KATIA/ALESS"
EndIf

Return( lFlag )
