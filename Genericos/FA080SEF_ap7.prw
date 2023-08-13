#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function FA080SEF()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CARQ,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA080SEF  ³                               ³ Data ³ 14/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Geracao do cheque na - Rava                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
   //³ Gravacao cheque - Rava                                       ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if SM0->M0_CODIGO == "02"

   If Select( "YEF" ) == 0
      cArq := "SEF010"
      Use (cArq) ALIAS YEF VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif

   RecLock( "YEF", .T. )
   YEF->EF_FILIAL  := xFilial("SEF") ;  YEF->EF_PREFIXO := SEF->EF_PREFIXO
   YEF->EF_TITULO  := SEF->EF_TITULO;   YEF->EF_PARCELA := SEF->EF_PARCELA
   YEF->EF_TIPO    := SEF->EF_TIPO;     YEF->EF_NUM     := SEF->EF_NUM
   YEF->EF_BANCO   := SEF->EF_BANCO  ;  YEF->EF_AGENCIA := SEF->EF_AGENCIA
   YEF->EF_BENEF   := SEF->EF_BENEF;    YEF->EF_VALOR   := SEF->EF_VALOR
   YEF->EF_DATA    := SEF->EF_DATA   ;  YEF->EF_CONTA   := SEF->EF_CONTA
   YEF->EF_IMPRESS := SEF->EF_IMPRESS;  YEF->EF_HIST    := SEF->EF_HIST
   YEF->EF_FORNECE := SEF->EF_FORNECE;  YEF->EF_OK      := SEF->EF_OK
   YEF->EF_LOJA    := SEF->EF_LOJA   ;  YEF->EF_CART    := SEF->EF_CART
   YEF->EF_DEPOSIT := SEF->EF_DEPOSIT;  YEF->EF_NUMNOTA := SEF->EF_NUMNOTA
   YEF->EF_RG      := SEF->EF_RG   ;    YEF->EF_SERIE   := SEF->EF_SERIE
   YEF->EF_TEL     := SEF->EF_TEL    ;  YEF->EF_VENCTO  := SEF->EF_VENCTO
   YEF->EF_LIBER   := SEF->EF_LIBER  ;  YEF->EF_SEQUENC := SEF->EF_SEQUENC
   YEF->EF_GARANT  := SEF->EF_GARANT ;  YEF->EF_LA      := SEF->EF_LA
   YEF->EF_PORTADO := SEF->EF_PORTADO;  YEF->EF_ORIGEM  := SEF->EF_ORIGEM
   YEF->EF_FLSERV  := SEF->EF_FLSERV
   YEF->( msUnlock() )
   YEF->( dbCommit() )

endif

Return
