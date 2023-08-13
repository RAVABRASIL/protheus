#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function F050ALT()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

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
±±³Fun‡„o    ³FA050GRV                                         ³ 26/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Altercao de contas a pagar - RAVA                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

//if SM0->M0_CODIGO == "02" .and. SE2->E2_PREFIXO == "UNI"
if SM0->M0_CODIGO == "02" .and. SE2->E2_PREFIXO $ "UNI/0  "

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Grava Duplicatas na Rava                                     ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   if Select( "XE2" ) == 0
      cArq := "SE2010"
      Use (cArq) ALIAS XE2 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif

   XE2->( dbSetOrder( 6 ) )
   XE2->( dbSeek( xFilial( "SE2" ) + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO ) )

   if XE2->E2_FORNECE + XE2->E2_LOJA + XE2->E2_PREFIXO + XE2->E2_NUM == SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM .and. XE2->( !Eof() )

      RecLock( "XE2", .f. )
      XE2->E2_FILIAL  := xFilial("SE1") ;  XE2->E2_PREFIXO := SE2->E2_PREFIXO
      XE2->E2_NUM     := SE2->E2_NUM;      XE2->E2_PARCELA := SE2->E2_PARCELA
      XE2->E2_TIPO    := SE2->E2_TIPO;     XE2->E2_NATUREZ := SE2->E2_NATUREZ
      XE2->E2_FORNECE := SE2->E2_FORNECE;  XE2->E2_LOJA    := SE2->E2_LOJA
      XE2->E2_NOMFOR  := SE2->E2_NOMFOR;   XE2->E2_EMISSAO := SE2->E2_EMISSAO
      XE2->E2_VENCTO  := SE2->E2_VENCTO ;  XE2->E2_VENCREA := SE2->E2_VENCREA
      XE2->E2_VALOR   := SE2->E2_VALOR  ;  XE2->E2_ISS     := SE2->E2_ISS
      XE2->E2_PORTADO := SE2->E2_PORTADO;  XE2->E2_NUMBCO  := SE2->E2_NUMBCO
      XE2->E2_INDICE  := SE2->E2_INDICE ;  XE2->E2_BAIXA   := SE2->E2_BAIXA
      XE2->E2_BCOPAG  := SE2->E2_BCOPAG ;  XE2->E2_EMIS1   := SE2->E2_EMIS1
      XE2->E2_HIST    := SE2->E2_HIST ;    XE2->E2_LA      := SE2->E2_LA
      XE2->E2_LOTE    := SE2->E2_LOTE   ;  XE2->E2_MOTIVO  := SE2->E2_MOTIVO
      XE2->E2_MOVIMEN := SE2->E2_MOVIMEN;  XE2->E2_OP      := SE2->E2_OP
      XE2->E2_SALDO   := SE2->E2_SALDO  ;  XE2->E2_OK      := SE2->E2_OK
      XE2->E2_DESCONT := SE2->E2_DESCONT;  XE2->E2_MULTA   := SE2->E2_MULTA
      XE2->E2_JUROS   := SE2->E2_JUROS  ;  XE2->E2_CORREC  := SE2->E2_CORREC
      XE2->E2_VALLIQ  := SE2->E2_VALLIQ ;  XE2->E2_VENCORI := SE2->E2_VENCORI
      XE2->E2_VALJUR  := SE2->E2_VALJUR ;  XE2->E2_PORCJUR := SE2->E2_PORCJUR
      XE2 ->E2_MOEDA  := SE2->E2_MOEDA  ;  XE2->E2_NUMBOR  := SE2->E2_NUMBOR
      XE2->E2_FATPREF := SE2->E2_FATPREF;  XE2->E2_FATURA  := SE2->E2_FATURA
      XE2->E2_PROJETO := SE2->E2_PROJETO;  XE2->E2_CLASCON := SE2->E2_CLASCON
      XE2->E2_RATEIO  := SE2->E2_RATEIO ;  XE2->E2_DTVARIA := SE2->E2_DTVARIA
      XE2->E2_VARURV  := SE2->E2_VARURV ;  XE2->E2_VLCRUZ  := SE2->E2_VLCRUZ
      XE2->E2_DTFATUR := SE2->E2_DTFATUR;  XE2->E2_ACRESC  := SE2->E2_ACRESC
      XE2->E2_TITORIG := SE2->E2_TITORIG;  XE2->E2_IMPCHEQ := SE2->E2_IMPCHEQ
      XE2->E2_PARCIR  := SE2->E2_PARCIR ;  XE2->E2_ARQRAT  := SE2->E2_ARQRAT
      XE2->E2_OCORREN := SE2->E2_OCORREN;  XE2->E2_ORIGEM  := SE2->E2_ORIGEM
      XE2->E2_IDENTEE := SE2->E2_IDENTEE;  XE2->E2_FLUXO   := SE2->E2_FLUXO
      XE2->E2_PARCISS := SE2->E2_PARCISS
      XE2->( msUnlock() )
      XE2->( dbCommit() )

   endif
endif

Return
