#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function GQREENTR()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CRET,CALIAS,CARQ,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MT100f4                                          ³ 13/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Geracao de Livros fiscais de entrada - RAVA                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

cRet  := "0 == 0"
cAlias := dbSelectArea("SM0")

//if SM0->M0_CODIGO == "02" .and. SF3->F3_SERIE == "UNI"
if SM0->M0_CODIGO == "02" .and. SF3->F3_SERIE $ "UNI/0  "

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Grava Livros fiscais na Rava                                 ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   if Select( "XF3" ) == 0
      cArq := "SF3010"
      Use (cArq) ALIAS XF3 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif

   SF3->( dbSetOrder( 4 ) )
   SF3->( dbSeek( xFilial( "SF3" ) + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_DOC + SD1->D1_SERIE ) )

   RecLock( "XF3", .t. )
   XF3->F3_FILIAL := SF3->F3_FILIAL ; XF3->F3_ENTRADA := SF3->F3_ENTRADA;XF3->F3_NFISCAL := SF3->F3_NFISCAL
   XF3->F3_SERIE  := SF3->F3_SERIE  ; XF3->F3_CLIEFOR := SF3->F3_CLIEFOR;XF3->F3_LOJA    := SF3->F3_LOJA
   XF3->F3_CFO    := SF3->F3_CFO    ; XF3->F3_CODISS  := SF3->F3_CODISS ;XF3->F3_ESTADO  := SF3->F3_ESTADO
   XF3->F3_EMISSAO:= SF3->F3_EMISSAO; XF3->F3_CONTA   := SF3->F3_CONTA  ;XF3->F3_ALIQICM := SF3->F3_ALIQICM
   XF3->F3_VALCONT:= SF3->F3_VALCONT; XF3->F3_BASEICM := SF3->F3_BASEICM;XF3->F3_VALICM  := SF3->F3_VALICM
   XF3->F3_ISENICM:= SF3->F3_ISENICM; XF3->F3_OUTRICM := SF3->F3_OUTRICM;XF3->F3_BASEIPI := SF3->F3_BASEIPI
   XF3->F3_VALIPI := SF3->F3_VALIPI ; XF3->F3_ISENIPI := SF3->F3_ISENIPI;XF3->F3_OUTRIPI := SF3->F3_OUTRIPI
   XF3->F3_OBSERV := SF3->F3_OBSERV ; XF3->F3_VALOBSE := 0              ;XF3->F3_ICMSRET := SF3->F3_ICMSRET
   XF3->F3_TIPO   := SF3->F3_TIPO   ; XF3->F3_LANCAM  := SF3->F3_LANCAM ;XF3->F3_DOCOR   := SF3->F3_DOCOR
   XF3->F3_ICMSCOM:= SF3->F3_ICMSCOM; XF3->F3_IPIOBS  := SF3->F3_IPIOBS ;XF3->F3_NRLIVRO := SF3->F3_NRLIVRO
   XF3->F3_ICMAUTO:= SF3->F3_ICMAUTO; XF3->F3_BASERET := SF3->F3_BASERET;XF3->F3_FORMUL  := SF3->F3_FORMUL
   XF3->F3_ESPECIE:= SF3->F3_ESPECIE; XF3->F3_FORMULA := SF3->F3_FORMULA;XF3->F3_DESPESA := SF3->F3_DESPESA
   XF3->F3_REPROC := "N"            ; XF3->F3_PDV    := SF3->F3_PDV
   XF3->( MsUnlock() )

endif
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return(cRet)
Return(cRet)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
