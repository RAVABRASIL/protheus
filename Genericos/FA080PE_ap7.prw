#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA080PE()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

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
±±³Fun‡„o    ³FA080PE   ³                               ³ Data ³ 13/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Baixa dos titulo a pagar na - RAVA                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
antigo FA080PE.prw
/*/
if SM0->M0_CODIGO == "02"

   //if SE2->E2_PREFIXO == "UNI"
   if SE2->E2_PREFIXO $ "UNI/0  "
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Baixa titulo - Rava                                          ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      If Select( "XE2" ) == 0
         cArq := "SE2010"
         Use (cArq) ALIAS XE2 VIA "TOPCONN" NEW SHARED
				 U_AbreInd( cARQ )
      endif
      XE2->( dbSetOrder( 6 ) )
      XE2->( dbSeek( xFilial( "SE2" ) + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO ) )

      if XE2->( !Eof() ) .and. SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO==;
                               XE2->E2_FORNECE + XE2->E2_LOJA + XE2->E2_PREFIXO + XE2->E2_NUM + XE2->E2_PARCELA + XE2->E2_TIPO .AND. SE2->E2_BAIXA # XE2->E2_BAIXA
//         msgbox( "xe2 "+xe2->e2_fornece + xe2->e2_loja + xe2->e2_prefixo + xe2->e2_num+xe2->e2_parcela+xe2->e2_tipo + " se2 "+se2->e2_fornece + se2->e2_loja + se2->e2_prefixo + se2->e2_num+se2->e2_parcela+se2->e2_tipo,"info","stop")
         RecLock( "XE2", .f. )
         XE2->E2_FILIAL  := xFilial("SE2");   XE2->E2_PREFIXO := SE2->E2_PREFIXO
         XE2->E2_NUM     := SE2->E2_NUM;      XE2->E2_PARCELA := SE2->E2_PARCELA
         XE2->E2_TIPO    := SE2->E2_TIPO;     XE2->E2_NATUREZ := SE2->E2_NATUREZ
         XE2->E2_FORNECE := SE2->E2_FORNECE;  XE2->E2_LOJA    := SE2->E2_LOJA
         XE2->E2_NOMFOR  := SE2->E2_NOMFOR;   XE2->E2_EMISSAO := SE2->E2_EMISSAO
         XE2->E2_VENCTO  := SE2->E2_VENCTO;   XE2->E2_VENCREA := SE2->E2_VENCREA
         XE2->E2_VALOR   := SE2->E2_VALOR;    XE2->E2_ISS     := SE2->E2_ISS
         XE2->E2_PORTADO := SE2->E2_PORTADO;  XE2->E2_NUMBCO  := SE2->E2_NUMBCO
         XE2->E2_INDICE  := SE2->E2_INDICE;   XE2->E2_BAIXA   := SE2->E2_BAIXA
         XE2->E2_BCOPAG  := SE2->E2_BCOPAG;   XE2->E2_EMIS1   := SE2->E2_EMIS1
         XE2->E2_HIST    := SE2->E2_HIST;     XE2->E2_LA      := SE2->E2_LA
         XE2->E2_LOTE    := SE2->E2_LOTE;     XE2->E2_MOTIVO  := SE2->E2_MOTIVO
         XE2->E2_MOVIMEN := SE2->E2_MOVIMEN;  XE2->E2_OP      := SE2->E2_OP
         XE2->E2_SALDO   := SE2->E2_SALDO;    XE2->E2_OK      := SE2->E2_OK
         XE2->E2_DESCONT := SE2->E2_DESCONT;  XE2->E2_MULTA   := SE2->E2_MULTA
         XE2->E2_JUROS   := SE2->E2_JUROS;    XE2->E2_CORREC  := SE2->E2_CORREC
         XE2->E2_VALLIQ  := SE2->E2_VALLIQ;   XE2->E2_VENCORI := SE2->E2_VENCORI
         XE2->E2_VALJUR  := SE2->E2_VALJUR;   XE2->E2_PORCJUR := SE2->E2_PORCJUR
         XE2->E2_MOEDA   := SE2->E2_MOEDA;    XE2->E2_NUMBOR  := SE2->E2_NUMBOR
         XE2->E2_FATPREF := SE2->E2_FATPREF;  XE2->E2_FATURA  := SE2->E2_FATURA
         XE2->E2_PROJETO := SE2->E2_PROJETO;  XE2->E2_CLASCON := SE2->E2_CLASCON
         XE2->E2_RATEIO  := SE2->E2_RATEIO;   XE2->E2_DTVARIA := SE2->E2_DTVARIA
         XE2->E2_VARURV  := SE2->E2_VARURV;   XE2->E2_VLCRUZ  := SE2->E2_VLCRUZ
         XE2->E2_DTFATUR := SE2->E2_DTFATUR;  XE2->E2_ACRESC  := SE2->E2_ACRESC
         XE2->E2_TITORIG := SE2->E2_TITORIG;  XE2->E2_IMPCHEQ := SE2->E2_IMPCHEQ
         XE2->E2_PARCIR  := SE2->E2_PARCIR;   XE2->E2_ARQRAT  := SE2->E2_ARQRAT
         XE2->E2_OCORREN := SE2->E2_OCORREN;  XE2->E2_ORIGEM  := SE2->E2_ORIGEM
         XE2->E2_IDENTEE := SE2->E2_IDENTEE;  XE2->E2_FLUXO   := SE2->E2_FLUXO
         XE2->E2_PARCISS := SE2->E2_PARCISS
         XE2->( msUnlock() )
         XE2->( dbCommit() )

         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ SE5 - titulo - Rava                                          ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

         If Select( "XE5" ) == 0
            cArq := "SE5010"
            Use (cArq) ALIAS XE5 VIA "TOPCONN" NEW SHARED
						U_AbreInd( cARQ )
         endif

         nE5Ord := SE5->( dbSetOrder() )
         nE5Reg := SE5->( Recno() )

         SE5->( dbSetOrder( 4 ) )
         SE5->( dbSeek( xFilial( "SE5" ) + SE2->E2_NATUREZ + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + Dtos( SE2->E2_BAIXA ) + "P" + SE2->E2_FORNECE + SE2->E2_LOJA ) )

         while SE5->E5_NATUREZ + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + Dtos( SE5->E5_DTDIGIT ) + SE5->E5_RECPAG + SE5->E5_CLIFOR ==;
               SE2->E2_NATUREZ + SE2->E2_PREFIXO + SE2->E2_NUM    + SE2->E2_PARCELA + SE2->E2_TIPO + Dtos( SE2->E2_BAIXA   ) + "P"            + SE2->E2_FORNECE .and. SE5->( !Eof() )

            RecLock( "XE5", .t. )
            XE5->E5_FILIAL  := xFilial( "SE5" ); XE5->E5_DATA    := SE5->E5_DATA
            XE5->E5_TIPO    := SE5->E5_TIPO    ; XE5->E5_MOEDA   := SE5->E5_MOEDA
            XE5->E5_VALOR   := SE5->E5_VALOR   ; XE5->E5_NATUREZ := SE5->E5_NATUREZ
            XE5->E5_BANCO   := SE5->E5_BANCO   ; XE5->E5_AGENCIA := SE5->E5_AGENCIA
            XE5->E5_CONTA   := SE5->E5_CONTA   ; XE5->E5_NUMCHEQ := SE5->E5_NUMCHEQ
            XE5->E5_DOCUMEN := SE5->E5_DOCUMEN ; XE5->E5_VENCTO  := SE5->E5_VENCTO
            XE5->E5_RECPAG  := SE5->E5_RECPAG  ; XE5->E5_BENEF   := SE5->E5_BENEF
            XE5->E5_HISTOR  := SE5->E5_HISTOR  ; XE5->E5_TIPODOC := SE5->E5_TIPODOC
            XE5->E5_VLMOED2 := SE5->E5_VLMOED2 ; XE5->E5_LA      := "  "
            XE5->E5_SITUACA := SE5->E5_SITUACA ; XE5->E5_LOTE    := SE5->E5_LOTE
            XE5->E5_PREFIXO := SE5->E5_PREFIXO ; XE5->E5_NUMERO  := SE5->E5_NUMERO
            XE5->E5_PARCELA := SE5->E5_PARCELA ; XE5->E5_CLIFOR  := SE5->E5_CLIFOR
            XE5->E5_LOJA    := SE5->E5_LOJA    ; XE5->E5_DTDIGIT := SE5->E5_DTDIGIT
            XE5->E5_TIPOLAN := SE5->E5_TIPOLAN ; XE5->E5_DEBITO  := SE5->E5_DEBITO
            XE5->E5_CREDITO := SE5->E5_CREDITO ; XE5->E5_MOTBX   := SE5->E5_MOTBX
            XE5->E5_RATEIO  := SE5->E5_RATEIO  ; XE5->E5_RECONC  := SE5->E5_RECONC
            XE5->E5_SEQ     := SE5->E5_SEQ     ; XE5->E5_DTDISPO := SE5->E5_DTDISPO
            XE5->E5_CCD     := SE5->E5_CCD     ; XE5->E5_CCC     := SE5->E5_CCC
            XE5->E5_OK      := SE5->E5_OK      ; XE5->E5_ARQRAT  := SE5->E5_ARQRAT
            XE5->E5_IDENTEE := SE5->E5_IDENTEE ; XE5->E5_FLSERV  := SE5->E5_FLSERV
            XE5->( MsUnlock() )
            XE5->( dbCommit() )

            SE5->( dbSkip() )
         end
         SE5->( dbSetOrder( 1 ) )
//         SE5->( dbSetOrder( nE5Ord ) )
      endif
   endif
endif

Return
