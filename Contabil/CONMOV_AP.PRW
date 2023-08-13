#include "rwmake.ch"

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

USER FUNCTION CONMOV()

/*----------------------------------------------------------------
  DEFINIÇÃO DAS VARIÁVEIS LOCAIS DO RELATORIO
  ----------------------------------------------------------------
*/

SETPRVT("CALIASANT,CDESC1,CDESC2,CDESC3,CARQUIVO,AORD,CNOMREL,CTITULO,NLASTKEY,ARETURN,CTAMANHO")
SETPRVT("M_PAG,NVAL,NREG,ATRIM,NTRIM,NANO,NCOL,A100")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Mauricio Barros Silva                    ³ Data ³ 03/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Movimento contabil Trimestral                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Contabilidade                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

cALIASANT := alias()

/*----------------------------------------------------------------
  VARIÁVEIS DE PARAMETRIZAÇÃO DA IMPRESSÃO
  ----------------------------------------------------------------
*/

cDESC1   := "Analise vertical dos D.R.E. (trimestral)"
cDESC2   := ""
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "Faturamento", 2, 2, 1, "", 1 }
cARQUIVO := "SI2"
aORD     := {}
cNOMREL  := "CONMOV"
cTITULO  := "Analise vertical dos D.R.E. (trimestral)"
nLASTKEY := 0
cTAMANHO := "G"
M_PAG    := 1
/*----------------------------------------------------------------
  INÍCIO DO PROCESSAMENTO DO RELATÓRIO
  ----------------------------------------------------------------
*/
Pergunte( 'CONMOV', .F. )

cNOMREL := setprint( cARQUIVO, cNOMREL, "CONMOV", @cTITULO, cDESC1, cDESC2, cDESC3, .F. )
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
   RptStatus({|| RptDetail()})
   Return
   Static Function RptDetail()
#ENDIF

aTRIM := { "01*02*03", "04*05*06", "07*08*09", "10*11*12" }
nTRIM := MV_PAR02
nANO  := MV_PAR01
SI1->( DbSetorder( 1 ) )
DbSelectArea( "SI2" )
SI2->( dbSetOrder( 2 ) )
SI2->( DbSeek( Xfilial( "SI2" ) + Str( MV_PAR01, 4 ) + StrZero( Val( Right( aTRIM[ MV_PAR02 ], 2 ) ) + 1, 2 ), .T. ) )
nREG := If( SI2->( Eof() ), SI2->( Lastrec() ), SI2->( Recno() ) )
aANO := {}
For nCONT := 1 To 7
    Aadd( aANO, { nANO, aTRIM[ nTRIM ] } )
    nTRIM--
    If nTRIM < 1
       nTRIM := 4
       nANO--
    EndIf
Next
nTRIM++
If nTRIM == 5
   nTRIM := 1
EndIf
SI2->( DbSeek( Xfilial( "SI2" ) + Str( nANO, 4 ) + Left( aTRIM[ nTRIM ], 2 ), .T. ) )
SetRegua( nREG - SI2->( Recno() ) )

/*----------------------------------------------------------------
  PROCESSAMENTO DOS DADOS A SEREM IMPRESSOS NO RELATÓRIO
  ----------------------------------------------------------------
*/
aITE := {}
While SI2->( ! Eof() ) .and. SI2->I2_FILIAL == xFilial( "SI2" ) .and. SI2->I2_PERIODO <= Str( MV_PAR01, 4 ) + Right( aTRIM[ MV_PAR02 ], 2 )
  nPOST := ascan( aANO, { |X| X[1] == Val( Left( SI2->I2_PERIODO, 4 ) ) .and. Right( SI2->I2_PERIODO, 2 ) $ X[2] } ) + 1
  If ! Empty( SI2->I2_DEBITO ) .and. ! SubStr( SI2->I2_DEBITO, 1, 1 ) $ "12" .and. SI2->I2_LOTE < "9000"
*   NIVEL 1
    If Empty( nPOS := ascan( aITE, { |X| X[1,1] == SubStr( SI2->I2_DEBITO, 1, 1 ) } ) )
       Aadd( aITE, { { SubStr( SI2->I2_DEBITO, 1, 1 ), 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } } )
       nPOS := Len( aITE )
    EndIf
    aITE[ nPOS, nPOST, 2 ] += SI2->I2_VALOR
*   NIVEL 2
    If Empty( nPOS := ascan( aITE, { |X| X[1,1] == SubStr( SI2->I2_DEBITO, 1, 2 ) } ) )
       Aadd( aITE, { { SubStr( SI2->I2_DEBITO, 1, 2 ), 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } } )
       nPOS := Len( aITE )
    EndIf
    aITE[ nPOS, nPOST, 2 ] += SI2->I2_VALOR
*   NIVEL 3
    If Empty( nPOS := ascan( aITE, { |X| X[1,1] == SubStr( SI2->I2_DEBITO, 1, 3 ) } ) )
       Aadd( aITE, { { SubStr( SI2->I2_DEBITO, 1, 3 ), 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } } )
       nPOS := Len( aITE )
    EndIf
    aITE[ nPOS, nPOST, 2 ] += SI2->I2_VALOR
*   NIVEL 4
    If Empty( nPOS := ascan( aITE, { |X| X[1,1] == SubStr( SI2->I2_DEBITO, 1, 4 ) } ) )
       Aadd( aITE, { { SubStr( SI2->I2_DEBITO, 1, 4 ), 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } } )
       nPOS := Len( aITE )
    EndIf
    aITE[ nPOS, nPOST, 2 ] += SI2->I2_VALOR
*   NIVEL 5
    If Empty( nPOS := ascan( aITE, { |X| X[1,1] == SubStr( SI2->I2_DEBITO, 1, 6 ) } ) )
       Aadd( aITE, { { SubStr( SI2->I2_DEBITO, 1, 6 ), 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } } )
       nPOS := Len( aITE )
    EndIf
    aITE[ nPOS, nPOST, 2 ] += SI2->I2_VALOR
  EndIf

  If ! Empty( SI2->I2_CREDITO ) .and. ! SubStr( SI2->I2_CREDITO, 1, 1 ) $ "12" .and. SI2->I2_LOTE < "9000"
*   NIVEL 1
    If Empty( nPOS := ascan( aITE, { |X| X[1,1] == SubStr( SI2->I2_CREDITO, 1, 1 ) } ) )
       Aadd( aITE, { { SubStr( SI2->I2_CREDITO, 1, 1 ), 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } } )
       nPOS := Len( aITE )
    EndIf
    aITE[ nPOS, nPOST, 1 ] += SI2->I2_VALOR
*   NIVEL 2
    If Empty( nPOS := ascan( aITE, { |X| X[1,1] == SubStr( SI2->I2_CREDITO, 1, 2 ) } ) )
       Aadd( aITE, { { SubStr( SI2->I2_CREDITO, 1, 2 ), 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } } )
       nPOS := Len( aITE )
    EndIf
    aITE[ nPOS, nPOST, 1 ] += SI2->I2_VALOR
*   NIVEL 3
    If Empty( nPOS := ascan( aITE, { |X| X[1,1] == SubStr( SI2->I2_CREDITO, 1, 3 ) } ) )
       Aadd( aITE, { { SubStr( SI2->I2_CREDITO, 1, 3 ), 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } } )
       nPOS := Len( aITE )
    EndIf
    aITE[ nPOS, nPOST, 1 ] += SI2->I2_VALOR
*   NIVEL 4
    If Empty( nPOS := ascan( aITE, { |X| X[1,1] == SubStr( SI2->I2_CREDITO, 1, 4 ) } ) )
       Aadd( aITE, { { SubStr( SI2->I2_CREDITO, 1, 4 ), 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } } )
       nPOS := Len( aITE )
    EndIf
    aITE[ nPOS, nPOST, 1 ] += SI2->I2_VALOR
*   NIVEL 5
    If Empty( nPOS := ascan( aITE, { |X| X[1,1] == SubStr( SI2->I2_CREDITO, 1, 6 ) } ) )
       Aadd( aITE, { { SubStr( SI2->I2_CREDITO, 1, 6 ), 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 }, { 0, 0 } } )
       nPOS := Len( aITE )
    EndIf
    aITE[ nPOS, nPOST, 1 ] += SI2->I2_VALOR
  EndIf
*/
  SI2->( dbSkip() )
  IncRegua()
EndDo
/*
----------------------------------------------------------------
  LAYOUT DA IMPRESSAO DO RELATORIO
----------------------------------------------------------------
          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                                               /-xo. trimestre xxxx-\   /-xo. trimestre xxxx-\   /-xo. trimestre xxxx-\   /-xo. trimestre xxxx-\   /-xo. trimestre xxxx-\   /-xo. trimestre xxxx-\   /-xo. trimestre xxxx--\
/- Conta -\   /--------- Descricao --------\           Reais      (%)           Reais      (%)           Reais      (%)           Reais      (%)           Reais      (%)           Reais      (%)            Reais      (%)
X.X.X.X.XX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   99,999,999.99  9999.99   99,999,999.99  9999.99   99,999,999.99  9999.99   99,999,999.99  9999.99   99,999,999.99  9999.99   99,999,999.99  9999.99   999,999,999.99  9999.99
*/
/*----------------------------------------------------------------
  IMPRESSÃO DOS DADOS NO RELATÓRIO
  ----------------------------------------------------------------*/
nLIN := Cabec( cTITULO, "", "", cNOMREL, cTAMANHO, 15 ) + 1
nCOL := 47
@ Prow() + 1,000 Psay ""
For nCONT := 7 To 1 Step -1
    @ Prow(),nCOL PSay "/-" + Str( Ascan( aTRIM, aANO[ nCONT, 2 ] ), 1 ) + "o. trimestre " + Str( aANO[ nCONT, 1 ], 4 ) + "-\   "
    nCOL += 25
Next
@ Prow() + 1,000 PSay "/--------------- Descricao ----------------\           Reais      (%)           Reais      (%)           Reais      (%)           Reais      (%)           Reais      (%)           Reais      (%)            Reais     (%)"
@ Prow() + 1,000 pSay Repl( '*', 220 )
aITE := Asort( aITE,,, { |X,Y| X[1,1] < Y[1,1] } )
nPOS := ascan( aITE, { |X| X[1,1] == "311" } )
a100 := { aITE[ nPOS, 2, 1 ] - aITE[ nPOS, 2, 2 ],  aITE[ nPOS, 3, 1 ] - aITE[ nPOS, 3, 2 ], aITE[ nPOS, 4, 1 ] - aITE[ nPOS, 4, 2 ], ;
  aITE[ nPOS, 5, 1 ] - aITE[ nPOS, 5, 2 ], aITE[ nPOS, 6, 1 ] - aITE[ nPOS, 6, 2 ], aITE[ nPOS, 7, 1 ] - aITE[ nPOS, 7, 2 ], ;
  aITE[ nPOS, 8, 1 ] - aITE[ nPOS, 8, 2 ] }
For i := 1 To Len( aITE )
    SI1->( dbSeek( xFilial( "SI1" ) + aITE[ i, 1, 1 ] ) )
*    @ Prow() + 1,000 Psay aITE[ i, 1, 1 ] Picture "@R 9.9.9.9.99"
*    @ Prow()    ,014 Psay Left( SI1->I1_DESC, 35 )
    If Left( aITE[ i, 1, 1 ], 1 ) == "3"
        If aITE[ i, 1, 1 ] == "3111"
           @ Prow() + 1,000 Psay "( + ) RECEITA OPERACIONAL BRUTA"
           a3111 := { aITE[ i, 2, 1 ] - aITE[ i, 2, 2 ], aITE[ i, 3, 1 ] - aITE[ i, 3, 2 ], aITE[ i, 4, 1 ] - aITE[ i, 4, 2 ], ;
             aITE[ i, 5, 1 ] - aITE[ i, 5, 2 ], aITE[ i, 6, 1 ] - aITE[ i, 6, 2 ], aITE[ i, 7, 1 ] - aITE[ i, 7, 2 ], aITE[ i, 8, 1 ] - aITE[ i, 8, 2 ] }
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "3111"
           @ Prow() + 1,000 Psay "      " + Left( SI1->I1_DESC, 35 )
        Elseif aITE[ i, 1, 1 ] == "3118"
           @ Prow() + 2,000 Psay "( - ) DEDUCOES SOBRE VENDAS"
           a3118 := { aITE[ i, 2, 1 ] - aITE[ i, 2, 2 ], aITE[ i, 3, 1 ] - aITE[ i, 3, 2 ], aITE[ i, 4, 1 ] - aITE[ i, 4, 2 ], ;
             aITE[ i, 5, 1 ] - aITE[ i, 5, 2 ], aITE[ i, 6, 1 ] - aITE[ i, 6, 2 ], aITE[ i, 7, 1 ] - aITE[ i, 7, 2 ], aITE[ i, 8, 1 ] - aITE[ i, 8, 2 ] }
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "3118"
           @ Prow() + 1,000 Psay "      " + Left( SI1->I1_DESC, 35 )
        Elseif aITE[ i, 1, 1 ] == "315"
            @ Prow() + 2,000 Psay "( = ) RECEITA OPERACIONAL LIQUIDA"
            @ Prow()    ,047 Psay a3111[ 7 ] + a3118[ 7 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,063 Psay ( a3111[ 7 ] + a3118[ 7 ] ) / a100[ 7 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,072 Psay a3111[ 6 ] + a3118[ 6 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,088 Psay ( a3111[ 6 ] + a3118[ 6 ] ) / a100[ 6 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,097 Psay a3111[ 5 ] + a3118[ 5 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,113 Psay ( a3111[ 5 ] + a3118[ 5 ] ) / a100[ 5 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,122 Psay a3111[ 4 ] + a3118[ 4 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,138 Psay ( a3111[ 4 ] + a3118[ 4 ] ) / a100[ 4 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,147 Psay a3111[ 3 ] + a3118[ 3 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,163 Psay ( a3111[ 3 ] + a3118[ 3 ] ) / a100[ 3 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,172 Psay a3111[ 2 ] + a3118[ 2 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,188 Psay ( a3111[ 2 ] + a3118[ 2 ] ) / a100[ 2 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,197 Psay a3111[ 1 ] + a3118[ 1 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,213 Psay ( a3111[ 1 ] + a3118[ 1 ] ) / a100[ 1 ] * 100 Picture "@E( 9999.9"
            @ Prow() + 2,000 Psay "( - ) CUSTO DOS PRODUTOS VENDIDOS"
            a315 := { aITE[ i, 2, 1 ] - aITE[ i, 2, 2 ], aITE[ i, 3, 1 ] - aITE[ i, 3, 2 ], aITE[ i, 4, 1 ] - aITE[ i, 4, 2 ], ;
             aITE[ i, 5, 1 ] - aITE[ i, 5, 2 ], aITE[ i, 6, 1 ] - aITE[ i, 6, 2 ], aITE[ i, 7, 1 ] - aITE[ i, 7, 2 ], aITE[ i, 8, 1 ] - aITE[ i, 8, 2 ] }
        Elseif aITE[ i, 1, 1 ] == "3181"
            @ Prow() + 2,000 Psay "( = ) LUCRO OPERACIONAL BRUTO"
            @ Prow()    ,047 Psay a3111[ 7 ] + a3118[ 7 ] + A315[ 7 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,063 Psay ( a3111[ 7 ] + a3118[ 7 ] + A315[ 7 ] ) / a100[ 7 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,072 Psay a3111[ 6 ] + a3118[ 6 ] + A315[ 6 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,088 Psay ( a3111[ 6 ] + a3118[ 6 ] + A315[ 6 ] ) / a100[ 6 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,097 Psay a3111[ 5 ] + a3118[ 5 ] + A315[ 5 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,113 Psay ( a3111[ 5 ] + a3118[ 5 ] + A315[ 5 ] ) / a100[ 5 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,122 Psay a3111[ 4 ] + a3118[ 4 ] + A315[ 4 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,138 Psay ( a3111[ 4 ] + a3118[ 4 ] + A315[ 4 ] ) / a100[ 4 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,147 Psay a3111[ 3 ] + a3118[ 3 ] + A315[ 3 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,163 Psay ( a3111[ 3 ] + a3118[ 3 ] + A315[ 3 ] ) / a100[ 3 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,172 Psay a3111[ 2 ] + a3118[ 2 ] + A315[ 2 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,188 Psay ( a3111[ 2 ] + a3118[ 2 ] + A315[ 2 ] ) / a100[ 2 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,197 Psay a3111[ 1 ] + a3118[ 1 ] + A315[ 1 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,213 Psay ( a3111[ 1 ] + a3118[ 1 ] + A315[ 1 ] ) / a100[ 1 ] * 100 Picture "@E( 9999.9"
            @ Prow() + 2,000 Psay "( + ) RECEITAS FINANCEIRAS"
            a3181 := { aITE[ i, 2, 1 ] - aITE[ i, 2, 2 ], aITE[ i, 3, 1 ] - aITE[ i, 3, 2 ], aITE[ i, 4, 1 ] - aITE[ i, 4, 2 ], ;
             aITE[ i, 5, 1 ] - aITE[ i, 5, 2 ], aITE[ i, 6, 1 ] - aITE[ i, 6, 2 ], aITE[ i, 7, 1 ] - aITE[ i, 7, 2 ], aITE[ i, 8, 1 ] - aITE[ i, 8, 2 ] }
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "3181"
           @ Prow() + 1,000 Psay "      " + Left( SI1->I1_DESC, 35 )
        Elseif aITE[ i, 1, 1 ] == "3186"
            @ Prow() + 2,000 Psay "( - ) DESPESAS FINANCEIRAS"
            a3186 := { aITE[ i, 2, 1 ] - aITE[ i, 2, 2 ], aITE[ i, 3, 1 ] - aITE[ i, 3, 2 ], aITE[ i, 4, 1 ] - aITE[ i, 4, 2 ], ;
             aITE[ i, 5, 1 ] - aITE[ i, 5, 2 ], aITE[ i, 6, 1 ] - aITE[ i, 6, 2 ], aITE[ i, 7, 1 ] - aITE[ i, 7, 2 ], aITE[ i, 8, 1 ] - aITE[ i, 8, 2 ] }
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "3186"
           @ Prow() + 1,000 Psay "      " + Left( SI1->I1_DESC, 35 )
        Else
           Loop
        EndIf
        @ Prow()    ,047 Psay aITE[ i, 8, 1 ] - aITE[ i, 8, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,063 Psay ( aITE[ i, 8, 1 ] - aITE[ i, 8, 2 ] ) / a100[ 7 ] * 100 Picture "@E( 9999.9"
        @ Prow()    ,072 Psay aITE[ i, 7, 1 ] - aITE[ i, 7, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,088 Psay ( aITE[ i, 7, 1 ] - aITE[ i, 7, 2 ] ) / a100[ 6 ] * 100 Picture "@E( 9999.9"
        @ Prow()    ,097 Psay aITE[ i, 6, 1 ] - aITE[ i, 6, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,113 Psay ( aITE[ i, 6, 1 ] - aITE[ i, 6, 2 ] ) / a100[ 5 ] * 100 Picture "@E( 9999.9"
        @ Prow()    ,122 Psay aITE[ i, 5, 1 ] - aITE[ i, 5, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,138 Psay ( aITE[ i, 5, 1 ] - aITE[ i, 5, 2 ] ) / a100[ 4 ] * 100 Picture "@E( 9999.9"
        @ Prow()    ,147 Psay aITE[ i, 4, 1 ] - aITE[ i, 4, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,163 Psay ( aITE[ i, 4, 1 ] - aITE[ i, 4, 2 ] ) / a100[ 3 ] * 100 Picture "@E( 9999.9"
        @ Prow()    ,172 Psay aITE[ i, 3, 1 ] - aITE[ i, 3, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,188 Psay ( aITE[ i, 3, 1 ] - aITE[ i, 3, 2 ] ) / a100[ 2 ] * 100 Picture "@E( 9999.9"
        @ Prow()    ,197 Psay aITE[ i, 2, 1 ] - aITE[ i, 2, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,213 Psay ( aITE[ i, 2, 1 ] - aITE[ i, 2, 2 ] ) / a100[ 1 ] * 100 Picture "@E( 9999.9"
    Else
        If aITE[ i, 1, 1 ] == "411"
           @ Prow() + 2,000 Psay "( - ) DESPESAS ADMINISTRATIVAS"
           a411 := { aITE[ i, 2, 1 ] - aITE[ i, 2, 2 ], aITE[ i, 3, 1 ] - aITE[ i, 3, 2 ], aITE[ i, 4, 1 ] - aITE[ i, 4, 2 ], ;
             aITE[ i, 5, 1 ] - aITE[ i, 5, 2 ], aITE[ i, 6, 1 ] - aITE[ i, 6, 2 ], aITE[ i, 7, 1 ] - aITE[ i, 7, 2 ], aITE[ i, 8, 1 ] - aITE[ i, 8, 2 ] }
        ElseIf aITE[ i, 1, 1 ] == "4112"
           @ Prow() + 1,000 Psay "      " + Left( SI1->I1_DESC, 35 )
        ElseIf aITE[ i, 1, 1 ] == "4113"
           @ Prow() + 1,000 Psay "      " + Left( SI1->I1_DESC, 35 )
        ElseIf aITE[ i, 1, 1 ] == "4114"
           @ Prow() + 1,000 Psay "      " + Left( SI1->I1_DESC, 35 )
        ElseIf aITE[ i, 1, 1 ] == "4115"
           @ Prow() + 1,000 Psay "      " + Left( SI1->I1_DESC, 35 )
        ElseIf aITE[ i, 1, 1 ] == "4711"
            @ Prow() + 2,000 Psay "( = ) LUCRO ANTES DA CSLL E IRPJ"
            @ Prow()    ,047 Psay a3111[ 7 ] + a3118[ 7 ] + A315[ 7 ] + a3181[ 7 ] + a3186[ 7 ] + a411[ 7 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,063 Psay ( a3111[ 7 ] + a3118[ 7 ] + A315[ 7 ] + a3181[ 7 ] + a3186[ 7 ] + a411[ 7 ] ) / a100[ 7 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,072 Psay a3111[ 6 ] + a3118[ 6 ] + A315[ 6 ] + a3181[ 6 ] + a3186[ 6 ] + a411[ 6 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,088 Psay ( a3111[ 6 ] + a3118[ 6 ] + A315[ 6 ] + a3181[ 6 ] + a3186[ 6 ] + a411[ 6 ] ) / a100[ 6 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,097 Psay a3111[ 5 ] + a3118[ 5 ] + A315[ 5 ] + a3181[ 5 ] + a3186[ 5 ] + a411[ 5 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,113 Psay ( a3111[ 5 ] + a3118[ 5 ] + A315[ 5 ] + a3181[ 5 ] + a3186[ 5 ] + a411[ 5 ] ) / a100[ 5 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,122 Psay a3111[ 4 ] + a3118[ 4 ] + A315[ 4 ] + a3181[ 4 ] + a3186[ 4 ] + a411[ 4 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,138 Psay ( a3111[ 4 ] + a3118[ 4 ] + A315[ 4 ] + a3181[ 4 ] + a3186[ 4 ] + a411[ 4 ] ) / a100[ 4 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,147 Psay a3111[ 3 ] + a3118[ 3 ] + A315[ 3 ] + a3181[ 3 ] + a3186[ 3 ] + a411[ 3 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,163 Psay ( a3111[ 3 ] + a3118[ 3 ] + A315[ 3 ] + a3181[ 3 ] + a3186[ 3 ] + a411[ 3 ] ) / a100[ 3 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,172 Psay a3111[ 2 ] + a3118[ 2 ] + A315[ 2 ] + a3181[ 2 ] + a3186[ 2 ] + a411[ 2 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,188 Psay ( a3111[ 2 ] + a3118[ 2 ] + A315[ 2 ] + a3181[ 2 ] + a3186[ 2 ] + a411[ 2 ] ) / a100[ 2 ] * 100 Picture "@E( 9999.9"
            @ Prow()    ,197 Psay a3111[ 1 ] + a3118[ 1 ] + A315[ 1 ] + a3181[ 1 ] + a3186[ 1 ] + a411[ 1 ] Picture "@E( 99,999,999.99"
            @ Prow()    ,213 Psay ( a3111[ 1 ] + a3118[ 1 ] + A315[ 1 ] + a3181[ 1 ] + a3186[ 1 ] + a411[ 1 ] ) / a100[ 1 ] * 100 Picture "@E( 9999.9"
            @ Prow() + 2,000 Psay "CUSTO DE PRODUCAO"
            @ Prow() + 1,000 Psay "  " + Left( SI1->I1_DESC, 35 )
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "4711"
           @ Prow() + 1,000 Psay "    " + Left( SI1->I1_DESC, 35 )
        Elseif aITE[ i, 1, 1 ] == "4712"
           @ Prow() + 1,000 Psay "  " + Left( SI1->I1_DESC, 35 )
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "4712"
           @ Prow() + 1,000 Psay "    " + Left( SI1->I1_DESC, 35 )
        Elseif aITE[ i, 1, 1 ] == "4713"
           @ Prow() + 1,000 Psay "  " + Left( SI1->I1_DESC, 35 )
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "4713"
           @ Prow() + 1,000 Psay "    " + Left( SI1->I1_DESC, 35 )
        Elseif aITE[ i, 1, 1 ] == "4714"
           @ Prow() + 1,000 Psay "  " + Left( SI1->I1_DESC, 35 )
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "4714"
           @ Prow() + 1,000 Psay "    " + Left( SI1->I1_DESC, 35 )
        Elseif aITE[ i, 1, 1 ] == "4715"
           @ Prow() + 1,000 Psay "  " + Left( SI1->I1_DESC, 35 )
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "4715"
           @ Prow() + 1,000 Psay "    " + Left( SI1->I1_DESC, 35 )
        Elseif aITE[ i, 1, 1 ] == "4716"
           @ Prow() + 1,000 Psay "  " + Left( SI1->I1_DESC, 35 )
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "4716"
           @ Prow() + 1,000 Psay "    " + Left( SI1->I1_DESC, 35 )
        Elseif aITE[ i, 1, 1 ] == "4717"
           @ Prow() + 1,000 Psay "  " + Left( SI1->I1_DESC, 35 )
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "4717"
           @ Prow() + 1,000 Psay "    " + Left( SI1->I1_DESC, 35 )
        Elseif aITE[ i, 1, 1 ] == "4718"
           @ Prow() + 1,000 Psay "  " + Left( SI1->I1_DESC, 35 )
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "4718"
           @ Prow() + 1,000 Psay "    " + Left( SI1->I1_DESC, 35 )
        Elseif aITE[ i, 1, 1 ] == "4719"
           @ Prow() + 1,000 Psay "  " + Left( SI1->I1_DESC, 35 )
           a4719 := { aITE[ i, 2, 1 ] - aITE[ i, 2, 2 ], aITE[ i, 3, 1 ] - aITE[ i, 3, 2 ], aITE[ i, 4, 1 ] - aITE[ i, 4, 2 ], ;
             aITE[ i, 5, 1 ] - aITE[ i, 5, 2 ], aITE[ i, 6, 1 ] - aITE[ i, 6, 2 ], aITE[ i, 7, 1 ] - aITE[ i, 7, 2 ], aITE[ i, 8, 1 ] - aITE[ i, 8, 2 ] }
        Elseif Left( aITE[ i, 1, 1 ], 4 ) == "4719"
           @ Prow() + 1,000 Psay "    " + Left( SI1->I1_DESC, 35 )
        Else
           Loop
        EndIf
        @ Prow()    ,047 Psay aITE[ i, 8, 1 ] - aITE[ i, 8, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,063 Psay ( aITE[ i, 8, 1 ] - aITE[ i, 8, 2 ] ) / a100[ 7 ] * 100 Picture "@E( 9999.9"
        @ Prow()    ,072 Psay aITE[ i, 7, 1 ] - aITE[ i, 7, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,088 Psay ( aITE[ i, 7, 1 ] - aITE[ i, 7, 2 ] ) / a100[ 6 ] * 100 Picture "@E( 9999.9"
        @ Prow()    ,097 Psay aITE[ i, 6, 1 ] - aITE[ i, 6, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,113 Psay ( aITE[ i, 6, 1 ] - aITE[ i, 6, 2 ] ) / a100[ 5 ] * 100 Picture "@E( 9999.9"
        @ Prow()    ,122 Psay aITE[ i, 5, 1 ] - aITE[ i, 5, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,138 Psay ( aITE[ i, 5, 1 ] - aITE[ i, 5, 2 ] ) / a100[ 4 ] * 100 Picture "@E( 9999.9"
        @ Prow()    ,147 Psay aITE[ i, 4, 1 ] - aITE[ i, 4, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,163 Psay ( aITE[ i, 4, 1 ] - aITE[ i, 4, 2 ] ) / a100[ 3 ] * 100 Picture "@E( 9999.9"
        @ Prow()    ,172 Psay aITE[ i, 3, 1 ] - aITE[ i, 3, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,188 Psay ( aITE[ i, 3, 1 ] - aITE[ i, 3, 2 ] ) / a100[ 2 ] * 100 Picture "@E( 9999.9"
        @ Prow()    ,197 Psay aITE[ i, 2, 1 ] - aITE[ i, 2, 2 ] Picture "@E( 99,999,999.99"
        @ Prow()    ,213 Psay ( aITE[ i, 2, 1 ] - aITE[ i, 2, 2 ] ) / a100[ 1 ] * 100 Picture "@E( 9999.9"
    EndIf
    If Prow() > 58
        nLIN := Cabec( cTITULO, "", "", cNOMREL, cTAMANHO, 15 ) + 1
        nCOL := 47
        @ Prow() + 1,000 Psay ""
        For nCONT := 7 To 1 Step -1
          @ Prow(),nCOL PSay "/-" + Str( Ascan( aTRIM, aANO[ nCONT, 2 ] ), 1 ) + "o. trimestre " + Str( aANO[ nCONT, 1 ], 4 ) + "-\   "
          nCOL += 25
        Next
        @ Prow() + 1,000 PSay "/--------------- Descricao ----------------\           Reais      (%)           Reais      (%)           Reais      (%)           Reais      (%)           Reais      (%)           Reais      (%)            Reais     (%)"
        @ Prow() + 1,000 pSay Repl( '*', 220 )
    EndIf
Next
@ Prow() + 2,000 Psay "C.P.V. - CUSTO DE PRODUCAO"
@ Prow()    ,047 Psay A315[ 7 ] + a4719[ 7 ] Picture "@E( 99,999,999.99"
@ Prow()    ,063 Psay ( A315[ 7 ] + a4719[ 7 ] ) / a100[ 7 ] * 100 Picture "@E( 9999.9"
@ Prow()    ,072 Psay A315[ 6 ] + a4719[ 6 ] Picture "@E( 99,999,999.99"
@ Prow()    ,088 Psay ( A315[ 6 ] + a4719[ 6 ] ) / a100[ 6 ] * 100 Picture "@E( 9999.9"
@ Prow()    ,097 Psay A315[ 5 ] + a4719[ 5 ] Picture "@E( 99,999,999.99"
@ Prow()    ,113 Psay ( A315[ 5 ] + a4719[ 5 ] ) / a100[ 5 ] * 100 Picture "@E( 9999.9"
@ Prow()    ,122 Psay A315[ 4 ] + a4719[ 4 ] Picture "@E( 99,999,999.99"
@ Prow()    ,138 Psay ( A315[ 4 ] + a4719[ 4 ] ) / a100[ 4 ] * 100 Picture "@E( 9999.9"
@ Prow()    ,147 Psay A315[ 3 ] + a4719[ 3 ] Picture "@E( 99,999,999.99"
@ Prow()    ,163 Psay ( A315[ 3 ] + a4719[ 3 ] ) / a100[ 3 ] * 100 Picture "@E( 9999.9"
@ Prow()    ,172 Psay A315[ 2 ] + a4719[ 2 ] Picture "@E( 99,999,999.99"
@ Prow()    ,188 Psay ( A315[ 2 ] + a4719[ 2 ] ) / a100[ 2 ] * 100 Picture "@E( 9999.9"
@ Prow()    ,197 Psay A315[ 1 ] + a4719[ 1 ] Picture "@E( 99,999,999.99"
@ Prow()    ,213 Psay ( A315[ 1 ] + a4719[ 1 ] ) / a100[ 1 ] * 100 Picture "@E( 9999.9"

/*----------------------------------------------------------------
  FINALIZAÇÃO DA IMPRESSÃO DO RELATÓRIO
  ----------------------------------------------------------------
*/

Roda( 0, Space( 10 ), cTAMANHO )

If aReturn[ 5 ] == 1
   dbCommitAll()
   ourspool( cNOMREL )
Endif

MS_FLUSH()
Return
