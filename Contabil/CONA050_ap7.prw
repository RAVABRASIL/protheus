#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function CONA050()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CARQ,NSI2ORD,NSI2REG,CNUM,CLINHA,CPERIODO")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CONA050                                          ³ 09/05/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Inclusao de Lancamentos contabeis                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/


//if SM0->M0_CODIGO == "02" .and. Alltrim( SI2->I2_ORIGEM ) == "UNI"
  if SM0->M0_CODIGO == "02" .and. Alltrim( SI2->I2_ORIGEM ) $ "UNI/0  "
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ ABrindo SI6 - Rava                                           ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   if Select( "XI6" ) == 0
      cArq := "SI6010"
      Use (cArq) ALIAS XI1 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Abrindo SI2 - Rava                                           ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   if Select( "XI2" ) == 0
      cArq := "SI2010"
      Use (cArq) ALIAS XI1 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cARQ )
   endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Atualizacao SI6 - Rava                                       ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 XI6->( DbSetOrder( 1 ) )
   XI6->( dbSeek( xFilial( "SI6" ) + SI6->I6_NUM + SI6->I6_MES, .t. ) )

   if XI6->( Eof() )
      RecLock( "XI6", .t. )
   else
      RecLock( "XI6", .f. )
   endif

   XI6->I6_FILIAL  := xFilial("SI6"); XI6->I6_NUM  := SI6->I6_NUM
   XI6->I6_MES     := SI6->I6_MES   ; XI6->I6_INF  := SI6->I6_INF
   XI6->I6_DEB     := SI6->I6_DEB   ; XI6->I6_CRD  := SI6->I6_CRD
   XI6->I6_DIG     := SI6->I6_DIG   ; XI6->I6_LAST := SI6->I6_LAST
   XI6->I6_PREDIG  := SI6->I6_PREDIG; XI6->I6_DATA := SI6->I6_DATA
   XI6->( dbcommit() )
   XI6->( MsUnlock() )

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Atualizacao SI2 - Rava                                       ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If Inclui
      nSI2Ord := SI2->( dbSetOrder() )
      nSI2Reg := SI2->( Recno() )
      cNum    := SI2->I2_NUM  //; cLinha := SI2->I2_LINHA; cPeriodo := SI2->I2_PERIODO

      While SI2->I2_NUM == cNum .and. SI2->( !Bof() )
         SI2->( dbSkip( -1 ) )
      End
      SI2->( dbSkip() )

      While SI2->I2_NUM == cNum .and. SI2->( !Eof() )

         RecLock( "XI2", .t. )
         XI2->I2_FILIAL  := xFilial("SI2") ;  XI2->I2_NUM     := SI2->I2_NUM
         XI2->I2_LINHA   := SI2->I2_LINHA;    XI2->I2_DATA    := SI2->I2_DATA
         XI2->I2_DC      := SI2->I2_DC   ;    XI2->I2_DEBITO  := SI2->I2_DEBITO
         XI2->I2_CREDITO := SI2->I2_CREDITO;  XI2->I2_DCC     := SI2->I2_DCC
         XI2->I2_MOEDAS  := SI2->I2_MOEDAS;   XI2->I2_VALOR   := SI2->I2_VALOR
         XI2->I2_HP      := SI2->I2_HP     ;  XI2->I2_HIST    := SI2->I2_HIST
         XI2->I2_CCD     := SI2->I2_CCD    ;  XI2->I2_CCC     := SI2->I2_CCC
         XI2->I2_ATIVDEB := SI2->I2_ATIVDEB;  XI2->I2_ATIVCRD := SI2->I2_ATIVCRD
         XI2->I2_VLMOED2 := SI2->I2_VLMOED2;  XI2->I2_VLMOED3 := SI2->I2_VLMOED3
         XI2->I2_VLMOED4 := SI2->I2_VLMOED4;  XI2->I2_VLMOED5 := SI2->I2_VLMOED5
         XI2->I2_DTVENC  := SI2->I2_DTVENC;   XI2->I2_CRITER  := SI2->I2_CRITER
         XI2->I2_ROTINA  := SI2->I2_ROTINA;   XI2->I2_PERIODO := SI2->I2_PERIODO
         XI2->I2_LISTADO := SI2->I2_LISTADO;  XI2->I2_ORIGEM  := SI2->I2_ORIGEM
         XI2->I2_PERMAT  := SI2->I2_PERMAT;   XI2->I2_FILORIG := SI2->I2_FILORIG
         XI2->I2_INTERCP := SI2->I2_INTERCP;  XI2->I2_IDENTCP := SI2->I2_IDENTCP
         XI2->I2_LOTE    := SI2->I2_LOTE;     XI2->I2_DOC     := SI2->I2_DOC
         XI2->I2_EMPORIG := SI2->I2_EMPORIG;  XI2->I2_LP      := SI2->I2_LP
         XI2->I2_ITEMD   := SI2->I2_ITEMD;    XI2->I2_ITEMC   := SI2->I2_ITEMC
         XI2->I2_PRELAN  := SI2->I2_PRELAN;   XI2->I2_TIPO    := SI2->I2_TIPO
         XI2->( dbcommit() )
         XI2->( MsUnlock() )
         SI2->( dbSkip() )
      End
      SI2->( dbSetOrder( nSI2Ord ) )
      SI2->( dbGoto( nSI2Reg ) )
   Else
      MsgBox( "ATENCAO atualizar o lancamento UNI","info","stop")
   endif

endif

Return(.t.)        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
