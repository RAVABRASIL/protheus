#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function F040ALT()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CARQ,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LJ040X                                           ³ 26/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Alteracao de contas a receber - Rava                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

//if SM0->M0_CODIGO == "02" .and. SE1->E1_PREFIXO == "UNI"
if SM0->M0_CODIGO == "02" .and. SE1->E1_PREFIXO $ "UNI/0  "
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Atualizacao SE1 - Rava                                       ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   if Select( "XE1" ) == 0
      cArq := "SE1010"
      Use (cArq) ALIAS XE1 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif
	 XE1->( DbSetOrder( 1 ) )
   XE1->( dbSeek( xFilial( "SE1" ) + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO ) )
   if XE1->E1_PREFIXO + XE1->E1_NUM + XE1->E1_PARCELA + XE1->E1_TIPO == SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO .and. XE1->( !Eof() )
      RecLock( "XE1", .F. )
      XE1->E1_FILIAL  := xFilial("SE1") ;XE1->E1_PREFIXO := SE1->E1_PREFIXO
      XE1->E1_NUM     := SE1->E1_NUM;      XE1->E1_PARCELA := SE1->E1_PARCELA
      XE1->E1_TIPO    := SE1->E1_TIPO;     XE1->E1_NATUREZ := SE1->E1_NATUREZ
      XE1->E1_CLIENTE := SE1->E1_CLIENTE;  XE1->E1_LOJA    := SE1->E1_LOJA
      XE1->E1_NOMCLI  := SE1->E1_NOMCLI;   XE1->E1_EMISSAO := SE1->E1_EMISSAO
      XE1->E1_VENCTO  := SE1->E1_VENCTO ;  XE1->E1_VENCREA := SE1->E1_VENCREA
      XE1->E1_VALOR   := SE1->E1_VALOR  ;  XE1->E1_SITUACA := SE1->E1_SITUACA
      XE1->E1_SALDO   := SE1->E1_VALOR  ;  XE1->E1_VEND1   := SE1->E1_VEND1
      XE1->E1_HIST    := SE1->E1_HIST   ;  XE1->E1_FLUXO   := SE1->E1_FLUXO
      XE1->E1_EMIS1   := SE1->E1_EMIS1;    XE1->E1_MOEDA   := SE1->E1_MOEDA
      XE1->E1_VLCRUZ  := SE1->E1_VLCRUZ ;  XE1->E1_ORIGEM  := SE1->E1_ORIGEM
      XE1->E1_PORCJUR := SE1->E1_PORCJUR ; XE1->E1_VALJUR  := SE1->E1_VALJUR
      XE1->E1_PEDIDO  := SE1->E1_PEDIDO ;  XE1->E1_HIST    := SE1->E1_HIST
      XE1->( dbcommit() )
      XE1->( MsUnlock() )
   endif

endif

Return
