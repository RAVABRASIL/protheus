#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function MT250TOK()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

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
lFLAG   := .T.
SB1->( DBSetOrder( 1 ) )
SC2->( DBSetOrder( 1 ) )
nRegSD4 := SD4->( RecNo() )
nRegSC2 := SC2->( RecNo() )

SB1->( DBSeek( xFilial("SB1") + M->D3_COD) )
SC2->( DBSeek( xFilial("SC2") + M->D3_OP ) )

If Empty( M->D3_USULIM )
   If M->D3_QUANT + SC2->C2_QUJE > SC2->C2_QUANT

   	  If SB1->B1_TIPO == "PA"
       	 If M->D3_QUANT + SC2->C2_QUJE > SC2->C2_QUANT + ( nLIMITE * SC2->C2_QUANT / 100 )
            MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (MR)-> "+ Transf( SC2->C2_QUANT+( nLIMITE * SC2->C2_QUANT / 100 )-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
            lFlag := .F.
         Endif
      Else

         If M->D3_PARCTOT == "P"
           	If M->D3_QUANT + SC2->C2_QUJE > SC2->C2_QUANT + ( nLIMITE * SC2->C2_QUANT / 100 )
           	   MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (KG)-> "+ Transf( SC2->C2_QUANT+( nLIMITE * SC2->C2_QUANT / 100 )-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
           	   lFlag := .F.
           	Endif
         Else

       	  	If M->D3_QUANT + SC2->C2_QUJE < SC2->C2_QUANT - ( nLIMITE * SC2->C2_QUANT / 100 ) .or. ;
           	   M->D3_QUANT + SC2->C2_QUJE > SC2->C2_QUANT + ( nLIMITE * SC2->C2_QUANT / 100 )

							 If M->D3_QUANT + SC2->C2_QUJE < SC2->C2_QUANT - ( nLIMITE * SC2->C2_QUANT / 100 )
           	      MSGBOX("Quant. Inferior a permitida p/ apontamento! Quant. Minima (KG)-> "+ Transf( SC2->C2_QUANT-( nLIMITE * SC2->C2_QUANT / 100 ) -SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
           	   Else
           	      MSGBOX("Quant. superior a permitida p/ apontamento! Quant. Maxima (KG)-> "+ Transf( SC2->C2_QUANT+( nLIMITE * SC2->C2_QUANT / 100 )-SC2->C2_QUJE,"@E 999,999.99") ,"M E N S A G E M","STOP")
           	   Endif
           	   lFlag := .F.
           	Endif
				 Endif
			Endif
   Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acerto do Empenho em funcao da quantidade produzida          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if lFLAG
   nImplemen := 0
   if SC2->C2_QUJE >= SC2->C2_QUANT
      nImplemen := Round( M->D3_QUANT * 100 / SC2->C2_QUANT / 100, 6 )
   elseif SC2->C2_QUJE < SC2->C2_QUANT .and. ( M->D3_QUANT + SC2->C2_QUJE ) > SC2->C2_QUANT
      nImplemen := Round( ( SC2->C2_QUJE + M->D3_QUANT - SC2->C2_QUANT ) * 100 / SC2->C2_QUANT / 100, 6 )
   endif

   if nImplemen > 0
      SD4->( dbSetOrder( 2 ) )
      SD4->( dbSeek( xFilial( "SD4" ) + M->D3_OP, .T. ) )

      While SD4->D4_OP == M->D3_OP .and. SD4->( !Eof() )
         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Gravacao do implemento no SD4                                ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         RecLock( "SD4", .f. )
         SD4->D4_QTDEORI += Round( SD4->D4_QTDEORI * nImplemen, 6 )
         SD4->D4_QTSEGUM += Round( SD4->D4_QTSEGUM * nImplemen, 6 )
         SD4->( MsUnlock() )
         SD4->( dbCommit() )
         SD4->( dbSkip() )
      End
      RecLock( "SC2", .f. )
      SC2->C2_QUANT   += Round( SC2->C2_QUANT * nImplemen, 6 )
      SC2->C2_QTSEGUM += Round( SC2->C2_QTSEGUM * nImplemen, 6 )
      SC2->( MsUnlock() )
      SC2->( dbCommit() )
   Endif
endif
SD4->( dbGoto( nRegSD4 ) )
SC2->( dbGoto( nRegSC2 ) )
Return( lFLAG )
