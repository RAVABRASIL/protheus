#include "rwmake.ch"

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

USER FUNCTION FATMREP()

/*----------------------------------------------------------------
  DEFINIÇÃO DAS VARIÁVEIS LOCAIS DO RELATORIO
  ----------------------------------------------------------------
*/

SETPRVT("CALIASANT,CDESC1,CDESC2,CDESC3,CARQUIVO,AORD,CNOMREL,CTITULO,NLASTKEY,ARETURN,CTAMANHO")
SETPRVT("M_PAG,NVAL,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Mauricio Barros Silva                    ³ Data ³ 30/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Metas dos representantes                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

cALIASANT := alias()

/*----------------------------------------------------------------
  VARIÁVEIS DE PARAMETRIZAÇÃO DA IMPRESSÃO
  ----------------------------------------------------------------
*/

cDESC1   := "Metas dos representantes"
cDESC2   := ""
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "Faturamento", 2, 2, 1, "", 1 }
cARQUIVO := "SF2"
aORD     := {}
cNOMREL  := "FATMREP"
cTITULO  := "M e t a s   d  o s   R e p r e s e n t a n t e s   ( Q u i l o s )"
nLASTKEY := 0
cTAMANHO := "G"
M_PAG    := 1

/*----------------------------------------------------------------
  INÍCIO DO PROCESSAMENTO DO RELATÓRIO
  ----------------------------------------------------------------
*/

Pergunte( 'FATREP', .F. )

cNOMREL := setprint( cARQUIVO, cNOMREL, "FATREP", @cTITULO, cDESC1, cDESC2, cDESC3, .F. )
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

SCT->( dbSetorder( 1 ) )
SF1->( dbSetorder( 2 ) )
SD1->( dbSetorder( 1 ) )
SD2->( dbSetorder( 3 ) )
SA3->( dbSetorder( 1 ) )
dbSelectArea("SF2")
cIndSf2 := "SC"+Substr( Time(), 4, 2 ) + Substr( Time(), 7, 2 )
cChave  := "F2_FILIAL + SF2->F2_VEND1 + Dtos( F2_EMISSAO ) + F2_DOC"
cFiltro := "F2_VEND1 >= mv_par01 .And. F2_VEND1 <= mv_par02 .And. ( Year( F2_EMISSAO ) == mv_par03 .or. Year( F2_EMISSAO ) == mv_par03 - 1 )"
IndRegua( "SF2", cIndSf2, cChave, , cFiltro, "Selecionando Notas.." )
SetRegua( Lastrec() )

/*----------------------------------------------------------------
  PROCESSAMENTO DOS DADOS A SEREM IMPRESSOS NO RELATÓRIO
  ----------------------------------------------------------------
*/
aCAB := {}
aITE := {}
SF2->( DbGotop() )
While SF2->( !Eof() ) .And. SF2->F2_FILIAL == xFilial( "SF2" )
  cREP := Left( SF2->F2_VEND1, 4 )
  If Empty( nPOS := ascan( aCAB, { |X| X[1] == cREP } ) )
     Aadd( aCAB, { cREP, 0, 0, 0, 0 } )
     Aadd( aITE, { { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } } )
     nPOS := Len( aCAB )
  EndIf
  For i := 1 To 12   // Armazena metas
    SCT->( DbSeek( Xfilial( "SCT" ) + StrZero( i, 2 ) + Str( MV_PAR03 - 1, 4 ), .T. ) )
    Do While SCT->CT_DOC == StrZero( i, 2 ) + Str( MV_PAR03 - 1, 4 )
       If SCT->CT_VEND == Padr( cREP, Len( SCT->CT_VEND ) )
          aCAB[ nPOS, 2 ] += SCT->CT_QUANT
       EndIf
       SCT->( DbSkip() )
    EndDo
    SCT->( DbSeek( Xfilial( "SCT" ) + StrZero( i, 2 ) + Str( MV_PAR03, 4 ), .T. ) )
    Do While SCT->CT_DOC == StrZero( i, 2 ) + Str( MV_PAR03, 4 )
       If SCT->CT_VEND == Padr( cREP, Len( SCT->CT_VEND ) )
          aITE[ nPOS, i, 2 ] += SCT->CT_QUANT
          aCAB[ nPOS, 4 ]    += SCT->CT_QUANT
       EndIf
       SCT->( DbSkip() )
    EndDo
  Next
  While SF2->( !Eof() ) .And. SF2->F2_FILIAL == xFilial( "SF2" ) .and. cREP == Left( SF2->F2_VEND1, 4 )
     If Year( SF2->F2_EMISSAO ) == MV_PAR03 - 1   // Vendas ano anterior
        SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
        While SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE
           If SD2->D2_CF $ "511  /5101 /611  /6101 /512  /5102 /612  /6102 /6107 /6109 /5949 /6949 "
              SB1->( dbSeek( xFilial( 'SB1' ) + SD2->D2_COD ) )
              aITE[ nPOS, Month( SF2->F2_EMISSAO ), 1 ] += IIf( Empty( SD2->D2_SERIE ) .and. ! 'VD' $ SF2->F2_VEND1, 0, IIf( SD2->D2_UM == "KG", SD2->D2_QUANT, ( SD2->D2_QUANT * SB1->B1_PESOR ) ) )
              aCAB[ nPOS, 3 ]                           += IIf( Empty( SD2->D2_SERIE ) .and. ! 'VD' $ SF2->F2_VEND1, 0, IIf( SD2->D2_UM == "KG", SD2->D2_QUANT, ( SD2->D2_QUANT * SB1->B1_PESOR ) ) )
           EndIf
           SD2->( DbSkip() )
        EndDo
        SF1->( dbSeek( xFilial( "SF1" ) + SF2->F2_CLIENTE + SF2->F2_LOJA, .T. ) )   // Se houve devolucao
        While SF1->F1_FORNECE + SF1->F1_LOJA == SF2->F2_CLIENTE + SF2->F2_LOJA
           If SD1->( dbSeek( xFilial( "SD1" ) + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA , .T. ) )
              Do While SD1->D1_NFORI + SD1->D1_SERIORI == SF2->F2_DOC + SF2->F2_SERIE
                 SB1->( dbSeek( xFilial( 'SB1' ) + SD1->D1_COD ) )
                 aITE[ nPOS, Month( SF2->F2_EMISSAO ), 1 ] -= IIf( SD1->D1_UM == "KG", SD1->D1_QUANT, ( SD1->D1_QUANT * SB1->B1_PESOR ) )
                 aCAB[ nPOS, 3 ]                           -= IIf( SD1->D1_UM == "KG", SD1->D1_QUANT, ( SD1->D1_QUANT * SB1->B1_PESOR ) )
                 SD1->( DbSkip() )
              EndDo
           Endif
           SF1->( dbSkip() )
        EndDo
     EndIf
     If Year( SF2->F2_EMISSAO ) == MV_PAR03   // Vendas ano atual
        SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
        While SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE
           If SD2->D2_CF $ "511  /5101 /611  /6101 /512  /5102 /612  /6102 /6107 /6109 /5949 /6949 "
              SB1->( dbSeek( xFilial( 'SB1' ) + SD2->D2_COD ) )
              aITE[ nPOS, Month( SF2->F2_EMISSAO ), 3 ] += IIf( Empty( SD2->D2_SERIE ) .and. ! 'VD' $ SF2->F2_VEND1, 0, IIf( SD2->D2_UM == "KG", SD2->D2_QUANT, ( SD2->D2_QUANT * SB1->B1_PESOR ) ) )
              aCAB[ nPOS, 5 ]                           += IIf( Empty( SD2->D2_SERIE ) .and. ! 'VD' $ SF2->F2_VEND1, 0, IIf( SD2->D2_UM == "KG", SD2->D2_QUANT, ( SD2->D2_QUANT * SB1->B1_PESOR ) ) )
           EndIf
           SD2->( DbSkip() )
        EndDo
        SF1->( dbSeek( xFilial( "SF1" ) + SF2->F2_CLIENTE + SF2->F2_LOJA, .T. ) )  // Se houve devolucao
        While SF1->F1_FORNECE + SF1->F1_LOJA == SF2->F2_CLIENTE + SF2->F2_LOJA
           If SD1->( dbSeek( xFilial( "SD1" ) + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA , .T. ) )
              Do While SD1->D1_NFORI + SD1->D1_SERIORI == SF2->F2_DOC + SF2->F2_SERIE
                 SB1->( dbSeek( xFilial( 'SB1' ) + SD1->D1_COD ) )
                 aITE[ nPOS, Month( SF2->F2_EMISSAO ), 3 ] -= IIf( SD1->D1_UM == "KG", SD1->D1_QUANT, ( SD1->D1_QUANT * SB1->B1_PESOR ) )
                 aCAB[ nPOS, 5 ]                           -= IIf( SD1->D1_UM == "KG", SD1->D1_QUANT, ( SD1->D1_QUANT * SB1->B1_PESOR ) )
                 SD1->( DbSkip() )
              EndDo
           Endif
           SF1->( dbSkip() )
        EndDo
     EndIf
     SF2->( dbSkip() )
     IncRegua()
  EndDo
EndDo
/*
----------------------------------------------------------------
  LAYOUT DA IMPRESSAO DO RELATORIO
----------------------------------------------------------------
          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
/--------- R e p r e s e n t a n t e ---------\    Meta xxxx   Vendas xxxx   %Vendas xxxx    Meta xxxx   Vendas xxxx   %Vendas xxxx
XXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999,999.99  9,999,999.99         999.99   999,999.99  9,999,999.99         999.99
/---------------- J a n e i r o ---------------\   /-------------- F e v e r e i r o -------------\   /------------------ M a r c o  ----------------\   /------------------ A b r i l  ----------------\
Vendas xxxx    Meta xxxx   Vendas xxxx   %Vendas   Vendas xxxx    Meta xxxx   Vendas xxxx   %Vendas   Vendas xxxx    Meta xxxx   Vendas xxxx   %Vendas   Vendas xxxx    Meta xxxx   Vendas xxxx   %Vendas
 999,999.99   999,999.99    999,999.99    999.99    999,999.99   999,999.99    999,999.99    999.99    999,999.99   999,999.99    999,999.99    999.99    999,999.99   999,999.99    999,999.99    999.99
/------------------- M a i o ------------------\   /------------------- J u n h o ----------------\   /------------------ J u l h o  ----------------\   /----------------- A g o s t o ----------------\
/--------------- S e t e m b r o --------------\   /----------------  O u t u b r o --------------\   /--------------- N o v e m b r o --------------\   /--------------- D e z e m b r o --------------\
*/
/*----------------------------------------------------------------
  IMPRESSÃO DOS DADOS NO RELATÓRIO
  ----------------------------------------------------------------*/
nLIN := Cabec( cTITULO, "", "", cNOMREL, cTAMANHO, 15 ) + 1
@ Prow() + 1,000 PSay "/--------- R e p r e s e n t a n t e ---------\"
//     Meta " + Str( MV_PAR03 - 1, 4 ) + "   Vendas " + Str( MV_PAR03 - 1, 4 ) + "   %Vendas " + Str( MV_PAR03 - 1, 4 ) + "    Meta " + Str( MV_PAR03, 4 ) + "   Vendas " + Str( MV_PAR03, 4 ) + "   %Vendas " + Str( MV_PAR03, 4 )
@ Prow() + 1,000 PSay "Vendas " + Str( MV_PAR03 - 1, 4 ) + "    Meta " + Str( MV_PAR03, 4 ) + "   Vendas " + Str( MV_PAR03, 4 ) + "   %Vendas   " + ;
                      "Vendas " + Str( MV_PAR03 - 1, 4 ) + "    Meta " + Str( MV_PAR03, 4 ) + "   Vendas " + Str( MV_PAR03, 4 ) + "   %Vendas   " + ;
                      "Vendas " + Str( MV_PAR03 - 1, 4 ) + "    Meta " + Str( MV_PAR03, 4 ) + "   Vendas " + Str( MV_PAR03, 4 ) + "   %Vendas   " + ;
                      "Vendas " + Str( MV_PAR03 - 1, 4 ) + "    Meta " + Str( MV_PAR03, 4 ) + "   Vendas " + Str( MV_PAR03, 4 ) + "   %Vendas   "
@ Prow() + 1,000 pSay Repl( '*', 220 )
For i := 1 To Len( aCAB )
    SA3->( dbSeek( xFilial( "SA3" ) + aCAB[ i, 1 ] ) )
    @ Prow() + 1,000 Psay aCAB[ i, 1 ] + "-" + SA3->A3_NOME
*    @ Prow()    ,050 Psay aCAB[ i, 2 ] Picture "@E 999,999.99"
*    @ Prow()    ,062 Psay aCAB[ i, 3 ] Picture "@E 9,999,999.99"
*    @ Prow()    ,083 Psay aCAB[ i, 3 ] / aCAB[ i, 2 ] * 100 Picture "@E 999.99"
*    @ Prow()    ,092 Psay aCAB[ i, 4 ] Picture "@E 999,999.99"
*    @ Prow()    ,104 Psay aCAB[ i, 5 ] Picture "@E 9,999,999.99"
*    @ Prow()    ,125 Psay aCAB[ i, 5 ] / aCAB[ i, 4 ] * 100 Picture "@E 999.99"
    @ Prow() + 1,000 PSay "/---------------- J a n e i r o ---------------\   /--------------- F e v e r e i r o ------------\   /------------------ M a r c o  ----------------\   /------------------ A b r i l  ----------------\"
    @ Prow() + 1,001 Psay aITE[ i, 1, 1 ] Picture "@E 999,999.99"
    @ Prow()    ,014 Psay aITE[ i, 1, 2 ] Picture "@E 999,999.99"
    @ Prow()    ,028 Psay aITE[ i, 1, 3 ] Picture "@E 999,999.99"
    @ Prow()    ,042 Psay aITE[ i, 1, 3 ] / aITE[ i, 1, 2 ] * 100 Picture "@E 999.99"
    @ Prow()    ,052 Psay aITE[ i, 2, 1 ] Picture "@E 999,999.99"
    @ Prow()    ,065 Psay aITE[ i, 2, 2 ] Picture "@E 999,999.99"
    @ Prow()    ,079 Psay aITE[ i, 2, 3 ] Picture "@E 999,999.99"
    @ Prow()    ,093 Psay aITE[ i, 2, 3 ] / aITE[ i, 2, 2 ] * 100 Picture "@E 999.99"
    @ Prow()    ,103 Psay aITE[ i, 3, 1 ] Picture "@E 999,999.99"
    @ Prow()    ,116 Psay aITE[ i, 3, 2 ] Picture "@E 999,999.99"
    @ Prow()    ,130 Psay aITE[ i, 3, 3 ] Picture "@E 999,999.99"
    @ Prow()    ,144 Psay aITE[ i, 3, 3 ] / aITE[ i, 3, 2 ] * 100 Picture "@E 999.99"
    @ Prow()    ,154 Psay aITE[ i, 4, 1 ] Picture "@E 999,999.99"
    @ Prow()    ,167 Psay aITE[ i, 4, 2 ] Picture "@E 999,999.99"
    @ Prow()    ,181 Psay aITE[ i, 4, 3 ] Picture "@E 999,999.99"
    @ Prow()    ,195 Psay aITE[ i, 4, 3 ] / aITE[ i, 4, 2 ] * 100 Picture "@E 999.99"
    @ Prow() + 1,000 PSay "/------------------- M a i o ------------------\   /------------------- J u n h o ----------------\   /------------------ J u l h o  ----------------\   /----------------- A g o s t o ----------------\"
    @ Prow() + 1,001 Psay aITE[ i, 5, 1 ] Picture "@E 999,999.99"
    @ Prow()    ,014 Psay aITE[ i, 5, 2 ] Picture "@E 999,999.99"
    @ Prow()    ,028 Psay aITE[ i, 5, 3 ] Picture "@E 999,999.99"
    @ Prow()    ,042 Psay aITE[ i, 5, 3 ] / aITE[ i, 5, 2 ] * 100 Picture "@E 999.99"
    @ Prow()    ,052 Psay aITE[ i, 6, 1 ] Picture "@E 999,999.99"
    @ Prow()    ,065 Psay aITE[ i, 6, 2 ] Picture "@E 999,999.99"
    @ Prow()    ,079 Psay aITE[ i, 6, 3 ] Picture "@E 999,999.99"
    @ Prow()    ,093 Psay aITE[ i, 6, 3 ] / aITE[ i, 6, 2 ] * 100 Picture "@E 999.99"
    @ Prow()    ,103 Psay aITE[ i, 7, 1 ] Picture "@E 999,999.99"
    @ Prow()    ,116 Psay aITE[ i, 7, 2 ] Picture "@E 999,999.99"
    @ Prow()    ,130 Psay aITE[ i, 7, 3 ] Picture "@E 999,999.99"
    @ Prow()    ,144 Psay aITE[ i, 7, 3 ] / aITE[ i, 7, 2 ] * 100 Picture "@E 999.99"
    @ Prow()    ,154 Psay aITE[ i, 8, 1 ] Picture "@E 999,999.99"
    @ Prow()    ,167 Psay aITE[ i, 8, 2 ] Picture "@E 999,999.99"
    @ Prow()    ,181 Psay aITE[ i, 8, 3 ] Picture "@E 999,999.99"
    @ Prow()    ,195 Psay aITE[ i, 8, 3 ] / aITE[ i, 8, 2 ] * 100 Picture "@E 999.99"
    @ Prow() + 1,000 PSay "/--------------- S e t e m b r o --------------\   /----------------  O u t u b r o --------------\   /--------------- N o v e m b r o --------------\   /--------------- D e z e m b r o --------------\"
    @ Prow() + 1,000 Psay aITE[ i, 9, 1 ] Picture "@E 999,999.99"
    @ Prow()    ,014 Psay aITE[ i, 9, 2 ] Picture "@E 999,999.99"
    @ Prow()    ,028 Psay aITE[ i, 9, 3 ] Picture "@E 999,999.99"
    @ Prow()    ,042 Psay aITE[ i, 9, 3 ] / aITE[ i, 9, 2 ] * 100 Picture "@E 999.99"
    @ Prow()    ,052 Psay aITE[ i, 10, 1 ] Picture "@E 999,999.99"
    @ Prow()    ,065 Psay aITE[ i, 10, 2 ] Picture "@E 999,999.99"
    @ Prow()    ,079 Psay aITE[ i, 10, 3 ] Picture "@E 999,999.99"
    @ Prow()    ,093 Psay aITE[ i, 10, 3 ] / aITE[ i, 10, 2 ] * 100 Picture "@E 999.99"
    @ Prow()    ,103 Psay aITE[ i, 11, 1 ] Picture "@E 999,999.99"
    @ Prow()    ,116 Psay aITE[ i, 11, 2 ] Picture "@E 999,999.99"
    @ Prow()    ,130 Psay aITE[ i, 11, 3 ] Picture "@E 999,999.99"
    @ Prow()    ,144 Psay aITE[ i, 11, 3 ] / aITE[ i, 11, 2 ] * 100 Picture "@E 999.99"
    @ Prow()    ,154 Psay aITE[ i, 12, 1 ] Picture "@E 999,999.99"
    @ Prow()    ,167 Psay aITE[ i, 12, 2 ] Picture "@E 999,999.99"
    @ Prow()    ,181 Psay aITE[ i, 12, 3 ] Picture "@E 999,999.99"
    @ Prow()    ,195 Psay aITE[ i, 12, 3 ] / aITE[ i, 12, 2 ] * 100 Picture "@E 999.99"
    @ Prow() + 2,000 Psay ""
    If Prow() > 60
        nLIN := Cabec( cTITULO, "", "", cNOMREL, cTAMANHO, 15 ) + 1
        @ Prow() + 1,000 PSay "/--------- R e p r e s e n t a n t e ---------\"
//            Meta " + Str( MV_PAR03 - 1, 4 ) + "   Vendas " + Str( MV_PAR03 - 1, 4 ) + "   %Vendas " + Str( MV_PAR03 - 1, 4 ) + "    Meta " + Str( MV_PAR03, 4 ) + "   Vendas " + Str( MV_PAR03, 4 ) + "   %Vendas " + Str( MV_PAR03, 4 )
        @ Prow() + 1,000 PSay "Vendas " + Str( MV_PAR03 - 1, 4 ) + "    Meta " + Str( MV_PAR03, 4 ) + "   Vendas " + Str( MV_PAR03, 4 ) + "   %Vendas   " + ;
                              "Vendas " + Str( MV_PAR03 - 1, 4 ) + "    Meta " + Str( MV_PAR03, 4 ) + "   Vendas " + Str( MV_PAR03, 4 ) + "   %Vendas   " + ;
                              "Vendas " + Str( MV_PAR03 - 1, 4 ) + "    Meta " + Str( MV_PAR03, 4 ) + "   Vendas " + Str( MV_PAR03, 4 ) + "   %Vendas   " + ;
                              "Vendas " + Str( MV_PAR03 - 1, 4 ) + "    Meta " + Str( MV_PAR03, 4 ) + "   Vendas " + Str( MV_PAR03, 4 ) + "   %Vendas   "
        @ Prow() + 1,000 pSay Repl( '*', 220 )
    EndIf
Next

/*----------------------------------------------------------------
  FINALIZAÇÃO DA IMPRESSÃO DO RELATÓRIO
  ----------------------------------------------------------------
*/

Roda( 0, Space( 10 ), cTAMANHO )
RetIndex( "SF2" )
If aReturn[ 5 ] == 1
   dbCommitAll()
   ourspool( cNOMREL )
Endif

MS_FLUSH()
Return
