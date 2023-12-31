#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA040GRV()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

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
굇쿑un뇙o    쿑A040GRV                                         � 26/04/01 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿔nclusao de contas a receber - Rava                         낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
*/

If SM0->M0_CODIGO == "02" .and. SE1->E1_PREFIXO == "UNI"

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Atualizacao SE1 - Rava                                       �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

   If Select( "XE1" ) == 0
      Use SE1010 ALIAS XE1 VIA "TOPCONN" NEW SHARED
      XE1->( dbsetorder( 1 ) )
			U_AbreInd( "SE1010" )
   EndIf

   RecLock( "XE1", .T. )
   XE1->E1_FILIAL  := xFILIAL("SE1")
   XE1->E1_PREFIXO := SE1->E1_PREFIXO
   XE1->E1_NUM     := SE1->E1_NUM
   XE1->E1_PARCELA := SE1->E1_PARCELA
   XE1->E1_TIPO    := SE1->E1_TIPO
   XE1->E1_NATUREZ := SE1->E1_NATUREZ
   XE1->E1_CLIENTE := SE1->E1_CLIENTE
   XE1->E1_LOJA    := SE1->E1_LOJA
   XE1->E1_NOMCLI  := SA1->A1_NOME
   XE1->E1_EMISSAO := SE1->E1_EMISSAO
   XE1->E1_VENCTO  := SE1->E1_VENCTO
   XE1->E1_VENCREA := SE1->E1_VENCREA
   XE1->E1_VALOR   := SE1->E1_VALOR
   XE1->E1_SITUACA := SE1->E1_SITUACA
   XE1->E1_SALDO   := SE1->E1_SALDO
   XE1->E1_VEND1   := SE1->E1_VEND1
   XE1->E1_HIST    := SE1->E1_HIST
   XE1->E1_FLUXO   := SE1->E1_FLUXO
   XE1->E1_EMIS1   := SE1->E1_EMIS1
   XE1->E1_MOEDA   := SE1->E1_MOEDA
   XE1->E1_VLCRUZ  := SE1->E1_VLCRUZ
   XE1->E1_ORIGEM  := SE1->E1_ORIGEM
   XE1->E1_PORCJUR := SE1->E1_PORCJUR
   XE1->E1_VALJUR  := SE1->E1_VALJUR
   XE1->E1_PEDIDO  := SE1->E1_PEDIDO
   XE1->E1_HIST    := SE1->E1_HIST
   XE1->( MsUnlock() )
   XE1->( dbCommit() )
   XE1->( DbCloseArea() )
EndIf


Return
