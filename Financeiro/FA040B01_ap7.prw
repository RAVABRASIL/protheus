#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA040B01()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CARQ,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿑A040B01                                         � 26/04/01 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿐xclusao de contas a receber - Rava                         낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
*/

//if SM0->M0_CODIGO == "02" .and. SE1->E1_PREFIXO == "UNI"
if SM0->M0_CODIGO == "02" .and. SE1->E1_PREFIXO $ "UNI/0  "
   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Atualizacao SE1 - Rava                                       �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   if Select( "XE1" ) == 0
      cArq := "SE1010"
      Use (cArq) ALIAS XE1 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif
	 XE1->( DbSetOrder( 1 ) )
   XE1->( dbSeek( xFilial( "SE1" ) + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO ) )
   if XE1->E1_PREFIXO+XE1->E1_NUM+XE1->E1_PARCELA+XE1->E1_TIPO==SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO .and. XE1->( !Eof() )
      RecLock( "XE1", .F. )
      XE1->( dbDelete() )
      XE1->( MsUnlock() )
      XE1->( dbCommit() )
   endif
endif

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
