#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function MT250TO2()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NLIMITE,LFLAG,NIMPLEMEN,NREGSD4,NORDSD4,NREGSC2")
SetPrvt("NORDSC2,NIMPLCUSTO,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MT250TOK                                         ³ 30/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Validacao p/ inclusao de apontamento de OP's                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
MV_LIMAXOP - Percentual flexibilidade de apontamento de O.P.'s p/ P.A.
*/
nLimite := GetMv( "MV_LIMAXOP" )
lFlag   := .t.
SB1->( DBSetOrder(1) )
SC2->( DBSetOrder(1) )

SB1->( DBSeek( xFilial("SB1") + M->D3_COD) )
SC2->( DBSeek( xFilial("SC2") + M->D3_OP ) )

if SC2->C2_SEQUEN == "001"
   /*/
   if Round( m->d3_quant + SC2->C2_QUJE,2 ) > Round( SC2->C2_QUANT + (nLimite*SC2->C2_QUANT/100),2 ) .and.;
      Substr(cUSUARIO,7,5) #'Viana' .And. Substr(cUSUARIO,7,13) # 'Administrador'
      lFlag := .f.
   endif
   /*/
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Acerto do Empenho em funcao da quantidade produzida          ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   nImplemen := 0
   if SC2->C2_QUJE >= SC2->C2_QUANT
      nImplemen := Round( m->d3_quant * 100 / SC2->C2_QUANT / 100, 6 )
   elseif SC2->C2_QUJE < SC2->C2_QUANT .and.  ( m->d3_quant + SC2->C2_QUJE ) > SC2->C2_QUANT
      nImplemen := Round( ( SC2->C2_QUJE+m->d3_quant-SC2->C2_QUANT) * 100 / SC2->C2_QUANT / 100, 6 )
   endif

   if nImplemen > 0 .and. lFlag   // lFlag Valida a aprovacao acima do parametro MV_LIMAXOP

      nRegSD4 := SD4->( RecNo() )
      nOrdSD4 := SD4->( dbSetOrder() )
      nRegSC2 := SC2->( RecNo() )
      nOrdSC2 := SC2->( dbSetOrder() )

      SD4->( dbSetOrder( 2 ) )
      SD4->( dbSeek( xFilial( "SD4" ) + m->d3_op, .t. ) )

      While Substr( SD4->D4_OP, 1, 6 ) == Substr( m->d3_op, 1, 6 ) .and. SD4->( !Eof() )

         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Gravacao do implemento no SD4                                ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         RecLock( "SD4", .f. )
         nImplCusto := Round( SD4->D4_QTDEORI * nImplemen, 6 )
         SD4->D4_QTDEORI := SD4->D4_QTDEORI + nImplCusto
         SD4->D4_QUANT   := SD4->D4_QUANT   + nImplCusto
*         Msgbox( " sd4 "+Str(sd4->d4_qtdeori,12,4)+" inplcust "+str(nImplCusto,12, 4), "info","stop")
         SD4->( MsUnlock() )
         SD4->( dbCommit() )

         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Gravacao do implemento no SC2 - O.P. intermediaria           ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         if !Empty( SD4->D4_OPORIG )
            SC2->( dbSetOrder( 1 ) )
            SC2->( dbSeek( xFilial( "SC2" ) + SD4->D4_OPORIG, .T. ) )
            nImplCusto := Round( SC2->C2_QUANT * nImplemen, 6 )
            RecLock( "SC2", .f. )
            SC2->C2_QUANT := SC2->C2_QUANT + nImplCusto
            SC2->( MsUnlock() )
            SC2->( dbCommit() )
         endif

         SD4->( dbSkip() )

      End
      SD4->( dbSetOrder( nOrdSD4 ) )
      SD4->( dbGoto( nRegSD4 ) )
      SC2->( dbSetOrder( nOrdSC2 ) )
      SC2->( dbGoto( nRegSC2 ) )
   Endif

endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim tratamento apontamento PA / Custo Medio                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Subs(cUSUARIO,7,5) #'Viana' .And. Subs(cUSUARIO,7,13) # 'Administrador'.and.;//Retirado por Eurivan
   Subs(cUSUARIO,7,5) # 'Linde' .and. Subs(cUSUARIO,7,5) # 'Adalb' .and. Subs(cUSUARIO,7,5) # 'Raque'

   If M->D3_QUANT + SC2->C2_QUJE #SC2->C2_QUANT

      If SB1->B1_TIPO == "PA"

         If SC2->C2_QTSEGUM > 0 .And. SC2->C2_QTSEGUM < 200

            If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) <= Round( SC2->C2_QUANT + (0.06*SC2->C2_QUANT),2 )
               //MSGBOX("Apontamento OK!","M E N S A G E M","STOP")
               lFlag := .t.
            Else
*               MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (MR)-> "+ Transf( SC2->C2_QUANT+(0.06*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
               lFlag := .f.
            Endif

         ElseIf SC2->C2_QTSEGUM >= 200 .And. SC2->C2_QTSEGUM < 300

            If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) <= Round( SC2->C2_QUANT + (0.03*SC2->C2_QUANT),2 )
               //MSGBOX("Apontamento OK!","M E N S A G E M","STOP")
               lFlag := .t.
            Else
*               MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (MR)-> "+ Transf( SC2->C2_QUANT+(0.03*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
               lFlag := .f.
            Endif

         ElseIf SC2->C2_QTSEGUM >= 300 .And. SC2->C2_QTSEGUM < 400

            If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) <= Round( SC2->C2_QUANT + (0.02*SC2->C2_QUANT),2 )
               //MSGBOX("Apontamento OK!","M E N S A G E M","STOP")
               lFlag := .t.
            Else
*              MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (MR)-> "+ Transf( SC2->C2_QUANT+(0.02*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
               lFlag := .f.
            Endif

         ElseIf SC2->C2_QTSEGUM >= 400

            If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) <= Round( SC2->C2_QUANT + (0.01*SC2->C2_QUANT),2 )
               //MSGBOX("Apontamento OK!","M E N S A G E M","STOP")
               lFlag := .T.
            Else
*               MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (MR)-> "+ Transf( SC2->C2_QUANT+(0.01*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
               lFlag := .F.
            Endif

         Endif

      Else

         If M->D3_PARCTOT == "P"

            If SC2->C2_QUANT > 0 .And. SC2->C2_QUANT < 200

               If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) <= Round( SC2->C2_QUANT + (0.06*SC2->C2_QUANT),2 )
                  //MSGBOX("Apontamento OK!","M E N S A G E M","STOP")
                  lFlag := .t.
               Else
 *                 MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (KG)-> "+ Transf( SC2->C2_QUANT+(0.06*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
                  lFlag := .f.
               Endif

            ElseIf SC2->C2_QTSEGUM >= 200 .And. SC2->C2_QTSEGUM < 300

               If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) <= Round( SC2->C2_QUANT + (0.03*SC2->C2_QUANT),2 )
                  //MSGBOX("Apontamento OK!","M E N S A G E M","STOP")
                  lFlag := .t.
               Else
*                  MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (KG)-> "+ Transf( SC2->C2_QUANT+(0.03*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
                  lFlag := .F.
               Endif

            ElseIf SC2->C2_QTSEGUM >= 300 .And. SC2->C2_QTSEGUM < 400

               If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) <= Round( SC2->C2_QUANT + (0.02*SC2->C2_QUANT),2 )
                  //MSGBOX("Apontamento OK!","M E N S A G E M","STOP")
                  lFlag := .t.
               Else
*                  MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (KG)-> "+ Transf( SC2->C2_QUANT+(0.02*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
                  lFlag := .f.
               Endif

            ElseIf SC2->C2_QTSEGUM >= 400

               If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) <= Round( SC2->C2_QUANT + (0.01*SC2->C2_QUANT),2 )
                  //MSGBOX("Apontamento OK!","M E N S A G E M","STOP")
                  lFlag := .t.
               Else
*                  MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (KG)-> "+ Transf( SC2->C2_QUANT+(0.01*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
                  lFLag := .f.
               Endif

            Endif

         ElseIf M->D3_PARCTOT == "T"

            If SC2->C2_QUANT > 0 .And. SC2->C2_QUANT < 200

               If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) >= Round( SC2->C2_QUANT - (0.06*SC2->C2_QUANT),2 ) .And. ;
                  Round( M->D3_QUANT + SC2->C2_QUJE,2 ) <= Round( SC2->C2_QUANT + (0.06*SC2->C2_QUANT),2 )
                  //MSGBOX("Apontamento OK!","M E N S A G E M","STOP")
                  lFlag := .t.
               Else
                  If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) < Round( SC2->C2_QUANT - (0.06*SC2->C2_QUANT),2 )
*                     MSGBOX("Quant. Inferior a permitida p/ apontamento! Quant. Minima (KG)-> "+ Transf( SC2->C2_QUANT-(0.06*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
                  Else
*                     MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (KG)-> "+ Transf( SC2->C2_QUANT+(0.06*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
                  Endif
                  lFlag := .f.
               Endif

            Endif

            If SC2->C2_QUANT >= 200 .And. SC2->C2_QTSEGUM < 300

               If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) >= Round( SC2->C2_QUANT - (0.03*SC2->C2_QUANT),2 ) .And. ;
                  Round( M->D3_QUANT + SC2->C2_QUJE,2 ) <= Round( SC2->C2_QUANT + (0.03*SC2->C2_QUANT),2 )
                  //MSGBOX("Apontamento OK!","M E N S A G E M","STOP")
                  lFlag := .t.
               Else
                  If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) < Round( SC2->C2_QUANT - (0.03*SC2->C2_QUANT),2 )
 *                    MSGBOX("Quant. Inferior a permitida p/ apontamento! Quant. Minima (KG)-> "+ Transf( SC2->C2_QUANT-(0.03*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
                  Else
*                     MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (KG)-> "+ Transf( SC2->C2_QUANT+(0.03*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
                  Endif
                  lFlag := .f.
               Endif

            Endif

            If SC2->C2_QUANT >= 300 .And. SC2->C2_QTSEGUM < 400

               If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) >= Round( SC2->C2_QUANT - (0.02*SC2->C2_QUANT),2 ) .And. ;
                  Round( M->D3_QUANT + SC2->C2_QUJE,2 ) <= Round( SC2->C2_QUANT + (0.02*SC2->C2_QUANT),2 )
                  //MSGBOX("Apontamento OK!","M E N S A G E M","STOP")
                  lFlag := .t.
               Else
                  If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) < Round( SC2->C2_QUANT - (0.02*SC2->C2_QUANT),2 )
 *                    MSGBOX("Quant. Inferior a permitida p/ apontamento! Quant. Minima (KG)-> "+ Transf( SC2->C2_QUANT-(0.02*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
                  Else
*                     MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (KG)-> "+ Transf( SC2->C2_QUANT+(0.02*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
                  Endif
                  lFlag := .f.
               Endif
            Endif

            If SC2->C2_QUANT >= 400

               If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) >= Round( SC2->C2_QUANT - (0.01*SC2->C2_QUANT),2 ) .And. ;
                  Round( M->D3_QUANT + SC2->C2_QUJE,2 ) <= Round( SC2->C2_QUANT + (0.01*SC2->C2_QUANT),2 )
                  //MSGBOX("Apontamento OK!","M E N S A G E M","STOP")
                  lFlag := .t.
               Else
                  If Round( M->D3_QUANT + SC2->C2_QUJE,2 ) < Round( SC2->C2_QUANT - (0.01*SC2->C2_QUANT),2 )
 *                    MSGBOX("Quant. Inferior a permitida p/ apontamento! Quant. Minima (KG)-> "+ Transf( SC2->C2_QUANT-(0.01*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
                  Else
 *                    MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (KG)-> "+ Transf( SC2->C2_QUANT+(0.01*SC2->C2_QUANT)-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
                  Endif
                  lFlag := .f.
               Endif

            Endif

         Endif

      Endif

   Endif

Endif

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> __Return( lFlag )
Return( lFlag )        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
