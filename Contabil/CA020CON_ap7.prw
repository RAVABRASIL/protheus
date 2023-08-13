#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function CA020CON()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CARQ,LACHOUXI1,LACHOUXI7,X,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CA020CON                                         ³ 26/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Inclusao de contas contabeis - Rava                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

if SM0->M0_CODIGO == "01"
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Atualizacao SI1 - Rava                                       ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   if Select( "XI1" ) == 0
			cArq := "SI1020"
      //SX6->( dbSeek( xFilial( "SX6" ) + "MV_DIRRAVA", .T. ) )
      Use (cArq) ALIAS XI1 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cArq )
   endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Atualizacao SI7 - Rava                                       ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   if Select( "XI7" ) == 0
      //SX6->( dbSeek( xFilial( "SX6" ) + "MV_DIRRAVA", .T. ) )
      cArq := "SI7020"
      Use ( cArq ) ALIAS XI7 VIA "TOPCONN" NEW SHARED
			U_AbreInd( cArq )
   endif

   lAchouXI1 := lAchouXI7 := .F.
   if !Inclui
      If XI1->( dbSeek( xFilial( "SI1" ) + SI1->I1_CODIGO ) )
         lAchouXI1 := .T.
      Endif
      If XI7->( dbSeek( xFilial( "SI7" ) + SI1->I1_CODIGO, .t. ) )
         lAchouXI7 := .T.
      Endif
   endif


   //PROCESSANDO SI7 (PLANO DE CONTAS EM OUTRAS MOEDAS)
   For x := 2 to 5

       if Inclui .And. !lAchouXI7
          RecLock( "XI7", .t. )
       elseIf !Inclui .And. lAchouXI7
          RecLock( "XI7", .f. )
       endif

       if ( Inclui .And. !lAchouXI7 ) .or. ( Altera .And. lAchouXI7 )
          XI7->I7_FILIAL  := xFilial("SI7") ;  XI7->I7_CODIGO  := SI1->I1_CODIGO
          XI7->I7_MOEDA   := Str(x,1)
       elseif !Inclui .and. !Altera  .And. lAchouXI7
          XI7->( dbDelete() )
       endif
       XI7->( dbcommit() )
       XI7->( MsUnlock() )

       if !Inclui
          XI7->( dbSkip() )
       endif

   Next


   //PROCESSANDO SI1 (PLANO DE CONTAS)
   if Inclui .And. !lAchouXI1
      RecLock( "XI1", .T. )
   elseif !Inclui .And. lAchouXI1
      RecLock( "XI1", .f. )
   endif

   if ( Inclui .And. !lAchouXI1 ) .or. ( Altera .And. lAchouXI1 )
      XI1->I1_FILIAL  := xFilial("SI1") ;  XI1->I1_CODIGO  := SI1->I1_CODIGO
      XI1->I1_DESC    := SI1->I1_DESC;     XI1->I1_CLASSE  := SI1->I1_CLASSE
      XI1->I1_NIVEL   := SI1->I1_NIVEL;    XI1->I1_RES     := SI1->I1_RES
      XI1->I1_NORMAL  := SI1->I1_NORMAL;   XI1->I1_ESTADO  := SI1->I1_ESTADO
      XI1->I1_DC      := SI1->I1_DC;       XI1->I1_HP      := SI1->I1_HP
      XI1->I1_CTAVM   := SI1->I1_CTAVM  ;  XI1->I1_NCUSTO  := SI1->I1_NCUSTO
      XI1->I1_CV2     := SI1->I1_CV2    ;  XI1->I1_CV3     := SI1->I1_CV3
      XI1->I1_CV4     := SI1->I1_CV4    ;  XI1->I1_CV5     := SI1->I1_CV5
   elseif !Inclui .and. !Altera .And. lAchouXI1
      XI1->( dbDelete() )
   endif
   XI1->( dbcommit() )
   XI1->( MsUnlock() )

endif

Return
