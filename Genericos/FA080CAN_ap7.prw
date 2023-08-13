#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA080CAN()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CARQ,NE5ORD,NE5REG,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA080WN   ³                               ³ Data ³ 14/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cancelamento baixa a pagar                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//If SM0->M0_CODIGO == "02" .and. SE2->E2_PREFIXO == "UNI"
If SM0->M0_CODIGO == "02" .and. SE2->E2_PREFIXO $ "UNI/0  "
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Cancelamento baixa titulo - Rava                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If Select( "XE2" ) == 0
      cArq := "SE2010"
      Use (cArq) ALIAS XE2 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
      XE2->( dbSetOrder( 6 ) )
   EndIf
   XE2->( dbSeek( xFilial( "SE2" ) + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO ) )
   If XE2->( !Eof() )
      RecLock( "XE2", .f. )
      XE2->E2_BAIXA   := Ctod( "  /  /  " ); XE2->E2_MOTIVO := Space(30)
      XE2->E2_MOVIMEN := dDatabase         ; XE2->E2_SALDO  := SE2->E2_VALOR
      XE2->E2_DESCONT := 0                 ; XE2->E2_MULTA  := 0
      XE2->E2_JUROS   := 0                 ; XE2->E2_CORREC := 0
      XE2->E2_VALLIQ  := 0
      XE2->( msUnlock() )
      XE2->( dbCommit() )

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ SE5 - Cancelamento baixa - Rava                              ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      If Select( "XE5" ) == 0
         cArq := "SE5010"
         Use (cArq) ALIAS XE5 VIA "TOPCONN" NEW SHARED
				 U_AbreInd( cARQ )
         XE5->( dbSetOrder( 4 ) )
      EndIf

      nE5Ord := SE5->( dbSetOrder() )
      nE5Reg := SE5->( Recno() )

      SE5->( dbSetOrder( 4 ) )
      SE5->( dbSeek( xFilial( "SE5" ) + SE2->E2_NATUREZ + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO, .T. ) )

      While SE5->E5_NATUREZ + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO == ;
            SE2->E2_NATUREZ + SE2->E2_PREFIXO + SE2->E2_NUM    + SE2->E2_PARCELA + SE2->E2_TIPO

         if SE5->E5_RECPAG == "P" .AND. SE5->E5_CLIFOR == SE2->E2_FORNECE .AND. SE5->E5_LOJA == SE2->E2_LOJA
            If XE5->( dbSeek( xFilial( "SE5" ) + SE5->E5_NATUREZ + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + Dtos( SE5->E5_DTDIGIT ) + SE5->E5_RECPAG + SE2->E2_FORNECE + SE2->E2_LOJA ) )
               RecLock( "XE5", .f. )
               XE5->( dbDelete() )
               XE5->( MsUnlock() )
              XE5->( dbCommit() )
            EndIf
         endif
         SE5->( dbSkip() )
      end

      SE5->( dbSetOrder( 1 ) )
//      SE5->( dbSetOrder( nE5Ord ) )
      SE5->( dbGoto( nE5Reg ) )
   endif
endif

Return
