#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATRAN()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NMIDIA,WREGFIN")
SetPrvt("NREGTOT,NVALTOT,NPESTOT,NQTD_ML,APRD,AGRP")
SetPrvt("CTES,NPRD,NCOD,NGRP,M_PAG,APRDP,AGRPP,APRDQ,AGRPQ")
SetPrvt("NPACUM,NCONTJ,NCONTI,NPCP,NLIN,NPERCQ,NPERQP")
SetPrvt("CTIPO,NFATOR,NMARGEM,NMEDMESKG,NMEDPRGKG,NMEDMESML")
SetPrvt("NMEDPRGML,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Eurivan Marques Candido                  ³ Data ³ 14/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Ranking de Produtos                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                              ³
//³ mv_par01        	// De emissao                                    ³
//³ mv_par02        	// Ate emissao                                   ³
//³ mv_par03        	// Preco da MP                                   ³
//³ mv_par04        	// De Tipo                                       ³
//³ mv_par04        	// Ate Tipo                                      ³
//³ mv_par06        	// Consolida Produtos                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
cALIASANT := alias()
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Variaveis de parametrizacao da impressao.                    ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
cDESC1   := ""
cDESC2   := ""
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "DECOM", 2, 2, 1, "", 1 }
cARQUIVO := "SF2"
aORD     := { "Por Data" }
cNOMREL  := "FATRAN"
cTITULO  := "Ranking de Produtos"
nLASTKEY := 0
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicio do processamento                                      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Pergunte( 'FATRAN', .f. )

cNOMREL := setprint( cARQUIVO, cNOMREL, "FATRAN", @cTITULO, cDESC1, cDESC2,;
cDESC3, .f., aORD )
If nLastKey == 27
   Return
Endif

setdefault( aRETURN, cARQUIVO )

If nLastKey == 27
   Return
Endif

nMIDIA := aRETURN[ 5 ]
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicio do processamento                                      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

dbselectarea( 'SA1' )
SA1->( dbsetorder( 1 ) )
dbselectarea( 'SF2' )
SF2->( dbsetorder( 9 ) ) //Alterado de 7 para 8 na migracao AP8
dbselectarea( 'SD2' )
SD2->( dbsetorder( 3 ) )
SF2->( dbseek( xFILIAL('SF2') + dtos( mv_par02 ), .T. ) )
wREGFIN := SF2->( recno() ) + 1
SF2->( dbseek( xFILIAL('SF2') + dtos( mv_par01 ), .T. ) )
nREGTOT := wREGFIN - SF2->( RECNO() )
nVALTOT := nPESTOT := nQtd_ml := 0

aPRDQ := {}
aPRDP := {}

aPRDQ2 := {}
aPRDP2 := {}

SetRegua( nREGTOT )

while ! SF2->( eof() ) .and. SF2->F2_EMISSAO <= mv_par02

   SD2->( dbSeek( xFilial( 'SD2' ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )

   while SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( ! eof() )

      if Alltrim( SD2->D2_CF ) $ "511  /611  /512  /612  "
         SB1->( dbSeek( xFilial( 'SB1' ) + SD2->D2_COD ) )

         If SB1->B1_TIPO >= mv_par04 .And. SB1->B1_TIPO <= mv_par05
            nPESTOT := nPESTOT + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )
            nVALTOT := nVALTOT + SD2->D2_TOTAL
            nQtd_ml := nQtd_ml + SD2->D2_QUANT
            nPRD    := ascan( aPRDQ,  { |X| X[1] == SD2->D2_COD } )

            If Empty( nPRD )

               aadd( aPRDQ, { SD2->D2_COD,;
                     SD2->D2_TOTAL,;
                     IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) ),;
                     Subs( SB1->B1_DESC, 1, 25 ),;
                     IIf( Empty( SD2->D2_SERIE ).and.!'VD' $ SF2->F2_VEND1, 0, SD2->D2_QUANT ),;
                     0,;//nFATOR
                     0,;//nMARGEM
                     ' ' } )

               aadd( aPRDP, { SD2->D2_COD,;
                     SD2->D2_TOTAL,;
                     IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) ),;
                     Subs( SB1->B1_DESC, 1, 25 ),;
                     IIf( Empty( SD2->D2_SERIE ).and.!'VD' $ SF2->F2_VEND1, 0, SD2->D2_QUANT ),;
                     0,;//nFATOR
                     0,;//nMARGEM
                     ' ' } )

            Else

               aPRDQ[nPRD,2] := aPRDQ[nPRD,2] + SD2->D2_TOTAL
               aPRDQ[nPRD,3] := aPRDQ[nPRD,3] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )
               aPRDQ[nPRD,5] := aPRDQ[nPRD,5] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, SD2->D2_QUANT )

               aPRDP[nPRD,2] := aPRDP[nPRD,2] + SD2->D2_TOTAL
               aPRDP[nPRD,3] := aPRDP[nPRD,3] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )
               aPRDP[nPRD,5] := aPRDP[nPRD,5] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, SD2->D2_QUANT )

            EndIf

         Endif

      Endif
      SD2->( dbSkip() )

   end

   SF2->( dbskip() )
   IncRegua()

end

nMIDIA := aReturn[5]
M_PAG     := 1

nPACUMa := nPERCa := 0

if mv_par06 = 1

   for e := 1 to len( aPRDQ )

      if Len( AllTrim( aPRDQ[ e, 1 ] ) ) = 6
         nCOD := ascan( aPRDQ,  { |X| X[1] == ;
                  PadR( Subs( aPRDQ[ e, 1 ], 1, 1 ) + 'D' + ;
                        Subs( aPRDQ[ e, 1 ], 2, 3 ) + '6' + ;
                        Subs( aPRDQ[ e, 1 ], 5, 2 ), 15 ) } )

         if !Empty( nCOD )

            aadd( aPRDQ2, { aPRDQ[ e, 1 ],;
                            aPRDQ[ e, 2 ] + iif( !Empty( nCOD ), aPRDQ[ nCOD, 2 ], 0 ),;
                            aPRDQ[ e, 3 ] + iif( !Empty( nCOD ), aPRDQ[ nCOD, 3 ], 0 ),;
                            aPRDQ[ e, 4 ],;
                            aPRDQ[ e, 5 ] + iif( !Empty( nCOD ), aPRDQ[ nCOD, 5 ], 0 ),;
                            aPRDQ[ e, 6 ],;
                            aPRDQ[ e, 7 ],;
                            aPRDQ[ e, 8 ] } )

            aadd( aPRDP2, { aPRDP[ e, 1 ],;
                            aPRDP[ e, 2 ] + iif( !Empty( nCOD ), aPRDP[ nCOD, 2 ], 0 ),;
                            aPRDP[ e, 3 ] + iif( !Empty( nCOD ), aPRDP[ nCOD, 3 ], 0 ),;
                            aPRDP[ e, 4 ],;
                            aPRDP[ e, 5 ] + iif( !Empty( nCOD ), aPRDP[ nCOD, 5 ], 0 ),;
                            aPRDP[ e, 6 ],;
                            aPRDP[ e, 7 ],;
                            aPRDP[ e, 8 ] } )

            nCOD := 0

         endif

      endif

   next

endif


//QUILO
if MV_PAR06 = 1

   APRDQL  := Asort( aPRDQ2,,, { | x, y | x[ 3 ] > y[ 3 ] } )
   APRDPC  := Asort( aPRDP2,,, { | x, y | x[ 3 ] > y[ 3 ] } )

else

   APRDQL  := Asort( aPRDQ ,,, { | x, y | x[ 3 ] > y[ 3 ] } )
   APRDPC  := Asort( aPRDP ,,, { | x, y | x[ 3 ] > y[ 3 ] } )

endif

for e := 1 to len( aPRDQL )

	nPERCa    := round( ( aPRDQL[ e, 3 ] / nPESTOT ) * 100, 2 )
 	nPACUMa   := nPACUMa + nPERCa

   nFATOR    := Round( aPRDQL[ e, 2 ] / aPRDQL[ e, 3 ], 2 )
	nMARGEM   := Round( ( nFATOR * 100 / MV_PAR03 ) - 100, 2 )

   aPRDPC[ e, 6 ] := nFATOR
   aPRDPC[ e, 7 ] := nMARGEM

   aPRDQL[ e, 6 ] := nFATOR
   aPRDQL[ e, 7 ] := nMARGEM

   if nPACUMa >= 98

      aPRDPC[ e, 8 ] := '*'
      aPRDQL[ e, 8 ] := '*'

   endif

next


//MARGEM
APRDPC := Asort( aPRDPC,,, { | x, y | x[ 7 ] > y[ 7 ] } )

nREGTOT := Len( aPRDQL )

SetRegua( nREGTOT )

m_PAG    := 1
nPACUMQ  := nPACUMP  := 0
nVLACUMQ := nVLACUMP := 0
nCONTJ   := Len( aPRDQL )
nCONTI   := 1
nPCP     := Round( ( mv_par02 - mv_par01 ) / 30, 0 )

while nCONTI <= nCONTJ

   /*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     ³ Imprime cabecalho do relatorio      ³
     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   */

   nLIN := cabec( 'RANKING DE PRODUTOS EM QUILO E MARGEM DE PARTICIPACAO', '', '','FATRAN', 'G', 15 )
   @ nLIN+01,00 pSay PadC( 'De ' + DTOC( MV_PAR01 ) + ' ate ' + DTOC( MV_PAR02 ) + ' - ' + iif( mv_par06 = 1, 'Produtos consolidados', 'Produtos nao consolidados' ), 220 )
   @ nLIN+02,00 pSay Repl( '*', 220 )
   @ nLIN+03,00 pSay  'Codigo    Nome                       Valor Liquido  Peso Liquido  RNK-P  %Ac.Peso    Milheiro       Vlr.Acum. | Codigo    Nome                       Valor Liquido  Fator Prc  Marg.MP  RNK-Mg    Milheiro        Vlr.Acum'
                     //99999999  XXXXXXXXXXXXXXXXXXXXXXXXX   9.999.999,99  9.999.999,99    999    999,99  999.999,99 *  9.999.999,99 | 99999999  XXXXXXXXXXXXXXXXXXXXXXXXX   9.999.999,99   9.999,99   999,99   9999   999.999,99 *   9.999.999,99
                     //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                     //          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
   @ nLIN + 04,00 pSay repl( '*', 220 )
   nLIN := nLIN + 06

   while nCONTI <= nCONTJ .and. nLIN <= 60

      //QUILO
      nPERCQ    := round( ( aPRDQL[nCONTI, 3 ] / nPESTOT ) * 100, 2 )
      nPACUMQ   := nPACUMQ + nPERCQ
      nVLACUMQ  := nVLACUMQ + aPRDQL[ nCONTI, 2 ]

      @ nLIN,000 pSay Alltrim( aPRDQL[nCONTI,1] )
      @ nLIN,010 pSay aPRDQL[nCONTI,4]
      @ nLIN,038 pSay aPRDQL[nCONTI,2]  Picture '@E 9,999,999.99'
      @ nLIN,052 pSay aPRDQL[nCONTI,3]  Picture '@E 9,999,999.99'
      @ nLIN,067 pSay Transform( nCONTI, "@E 999" ) + "o"
      @ nLIN,075 pSay nPACUMQ           Picture '@E 999.99' + '%'
      @ nLIN,083 pSay aPRDQL[nCONTI,5]  Picture '@E 999,999.99' + ' ' + aPRDQL[nCONTI,8]
      @ nLIN,097 pSay nVLACUMQ          Picture '@E 9,999,999.99'

      //PRECO
      nPERCP     := round( ( aPRDPC[nCONTI,3] / nPESTOT ) * 100, 2 )
      nPACUMP   := nPACUMP + nPERCP
      nVLACUMP  := nVLACUMP + aPRDPC[nCONTI,2]

      @ nLIN,110 pSay '|'

      @ nLIN,112 pSay Alltrim( aPRDPC[nCONTI,1] )
      @ nLIN,122 pSay aPRDPC[nCONTI,4]
      @ nLIN,150 pSay aPRDPC[nCONTI,2] Picture '@E 9,999,999.99'
      @ nLIN,165 pSay aPRDPC[nCONTI,6] Picture '@E 9,999.99'
      @ nLIN,176 pSay aPRDPC[nCONTI,7] Picture '@E 999.99'
      @ nLIN,185 pSay Transform( nCONTI, "@E 999" ) + "o"
      @ nLIN,192 pSay aPRDPC[nCONTI,5] Picture '@E 999,999.99' + ' ' + aPRDPC[nCONTI,8]
      @ nLIN,207 pSay nVLACUMP         Picture '@E 9,999,999.99'

      nLIN   := nLIN   + 1
      nCONTI := nCONTI + 1
      IncRegua()

   end

end

nLIN := nLIN + 1

@ nLIN,022 pSay 'TOTAL VALOR ==> '
@ nLIN,040 pSay nVALTOT   Picture '@E 9,999,999.99'
@ nLIN,060 pSay 'TOTAL PESO ==> '
@ nLIN,080 pSay nPESTOT   Picture '@E 9,999,999.99'

Roda(0,"","G")

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(cNomRel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
retindex( "SF2" )
retindex( "SD2" )
retindex( "SA1" )
retindex( "SB1" )
return
