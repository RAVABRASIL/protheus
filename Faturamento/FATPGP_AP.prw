#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATPGP()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt ("cbTxt, cbCont, nOrdem, Alfa, Z, M " )
SetPrvt ("Ctamanho, limite, cDesc1, cDesc2, cDesc3 " )
SetPrvt ("cNatureza, aReturn, nomeprog, cPerg " )
SetPrvt ("nLastKey, lContinua, cNOMREL, M_Pag, cabec1, cabec2 " )

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  FATMATR610 ³ Autor ³   Diego Araujo     ³ Data ³ 16/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ RELATORIO PARA EMITIR A RELACAO DE PEDIDOS POR GRUPO DE    ³±±
±±             PRODUTOS                                                   ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// Data Inicial                             ³
//³ mv_par02        	// Data Final                               ³
//³ mv_par03        	// Vendedor de                              ³
//³ mv_par04 	    	// Vendedor ate                             ³
//³ mv_par05	     	// Produto de                               ³
//³ mv_par06        	// Produto ate                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CbTxt    := ""
CbCont   := ""
nOrdem   := 0
Alfa     := 0
Z        := 0
M        := 0
ctamanho := "P"
limite   := 80

cDesc1    := "Este programa ira Emitir relacao de pedidos"
cDesc2    := "por vendedor/grupo de produtos."
cDesc3    := ""
cNatureza := ""
aReturn   := {"Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "FATPGP"
cPerg     := "FATPGP"
nLastKey  := 0
lContinua := .T.
cNOMREL   := "FATPGP"
M_PAG     := 1
cString   := "SC5"
ctitulo   := "Pedidos por vendedor/grupo de produtos"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE( 10 )
cbcont   := 0
nLin     := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte( cPerg, .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cNOMREL := SetPrint( cString, cNOMREL, cPerg, @ctitulo, cDesc1, cDesc2, cDESC3, .F., "",, cTamanho )
If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalho                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cabec1  := "Grup  Denominacao                     Quant.Pedida  Quant.Fatur.     Valor Total"
          //9999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   999999,9999   999999,9999  999.999.999,99
          //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
          //         10        20        30        40        50        60        70        80        90        100       110       120       130
cabec2  := ""

SA3->( dbSetorder( 1 ) )
SD2->( dbSetorder( 3 ) )
SC6->( dbSetorder( 1 ) )
dbSelectarea( "SC5" )
SC5->( dbSetorder( 2 ) )
dbseek( xFilial("SC5") + Dtos( mv_par02 + 1 ), .T. )
nREGTOT := If( Eof(), Lastrec(), Recno() )
dbseek( xFilial("SC5") + Dtos( mv_par01 ), .T. )
SetRegua( nRegtot - SC5->( Recno() ) )

nLin    := 0
aRELATO := {}

Do While SC5->C5_EMISSAO >= mv_par01 .and. SC5->C5_EMISSAO <= mv_par02
   If ! ( SC5->C5_VEND1 >= MV_PAR03 .and. SC5->C5_VEND1 <= MV_PAR04 .and. SC5->C5_CLIENTE >= MV_PAR05 .and. SC5->C5_CLIENTE <= MV_PAR06)
      SC5->( DbSkip() )
      Loop
   EndIf
   cVEND := Left( SC5->C5_VEND1, 4 )
   SC6->( dbseek( xFilial("SC6") + SC5->C5_NUM, .T. ) )
   Do While SC6->C6_NUM == SC5->C5_NUM
      SB1->( Dbseek( xFilial("SB1") + SC6->C6_PRODUTO ) )
      cGRUPO := SB1->B1_GRUPO
      If Empty( nPOS := ascan( aRELATO, { |X| X[1] == cVEND .and. X[2] == cGRUPO } ) )
         Aadd( aRELATO, { cVEND, cGRUPO, 0, 0, 0 } )
         nPOS := Len( aRELATO )
      EndIf
      aRELATO[ nPOS, 3 ] += SC6->C6_QTDVEN
      aRELATO[ nPOS, 4 ] += SC6->C6_QTDENT
      SC9->( dbseek( xFilial("SC9") + SC6->C6_NUM + SC6->C6_ITEM, .T. ) )
      Do While SC9->C9_PEDIDO + SC9->C9_ITEM == SC6->C6_NUM + SC6->C6_ITEM
         If ! Empty( SC9->C9_NFISCAL )
            SD2->( dbseek( xFilial("SD2") + SC9->C9_NFISCAL + SC9->C9_SERIENF, .T. ) )
            Do While SD2->D2_DOC + SD2->D2_SERIE == SC9->C9_NFISCAL + SC9->C9_SERIENF
               If SD2->D2_PEDIDO + SD2->D2_ITEMPV == SC9->C9_PEDIDO + SC9->C9_ITEM
                  aRELATO[ nPOS, 5 ] += SD2->D2_TOTAL
               EndIf
               SD2->( DbSkip() )
            EndDo
            If ! Empty( SC9->C9_SERIENF )
              SD2->( dbseek( xFilial("SD2") + SC9->C9_NFISCAL + "   ", .T. ) )
              Do While SD2->D2_DOC + SD2->D2_SERIE == SC9->C9_NFISCAL + "   "
                 If SD2->D2_PEDIDO + SD2->D2_ITEMPV == SC9->C9_PEDIDO + SC9->C9_ITEM
                    aRELATO[ nPOS, 5 ] += SD2->D2_TOTAL
                 EndIf
                 SD2->( DbSkip() )
              EndDo
            EndIf
         EndIf
         SC9->( DbSkip() )
      EndDo
      SC6->( DbSkip() )
   EndDo
   IncRegua()
   SC5->( DbSkip() )
EndDo
aRELATO := Asort( aRELATO,,, { |X,Y| X[1] + x[2] < Y[1] + Y[2] } )
/*----------------------------------------------------------------
  IMPRESSÃO DOS DADOS NO RELATÓRIO
  ----------------------------------------------------------------*/
nLIN := Cabec( cTITULO, cABEC1, CABEC2, cNOMREL, cTAMANHO, 18 ) + 1
*@ nLIN++,000 pSay Repl( '*', 80 )
nTOTAL  := 0
nSTOTAL := 0
i       := 1
Do While i <= Len( aRELATO )
    cVEND := aRELATO[ i, 1 ]
    SA3->( DbSeek( xFilial( "SA3" ) + Padr( aRELATO[ i, 1 ], 6 ) ) )
    @ ++nLIN,000 Psay "Representante: " + aRELATO[ i, 1 ] + " - " + SA3->A3_NOME
    nLIN++
    Do While i <= Len( aRELATO ) .and. cVEND == aRELATO[ i, 1 ]
        SX5->( DbSeek( xFilial( "SX5" ) + "03" + Padr( aRELATO[ i, 2 ], 6 ) ) )
        @ nLIN,000 Psay aRELATO[ i, 2 ]
        @ nLIN,006 Psay Left( SX5->X5_DESCRI, 30 )
        @ nLIN,039 Psay aRELATO[ i, 3 ] Picture "@E 999999.9999"
        @ nLIN,053 Psay aRELATO[ i, 4 ] Picture "@E 999999.9999"
        @ nLIN++,066 Psay aRELATO[ i, 5 ] Picture "@E 999,999,999.99"
        nTOTAL  += aRELATO[ i, 5 ]
        nSTOTAL += aRELATO[ i, 5 ]
        If nLIN > 58
            nLIN := Cabec( cTITULO, cABEC1, CABEC2, cNOMREL, cTAMANHO, 18 ) + 1
    *        @ nLIN++,000 pSay Repl( '*', 80 )
        EndIf
        i++
    EndDo
    If i > Len( aRELATO ) .or. cVEND != aRELATO[ i, 1 ]
        @ nLIN,030 Psay "TOTAL REPRESENTANTE ------->"
        @ nLIN++,066 Psay nSTOTAL Picture "@E 999,999,999.99"
        nSTOTAL := 0
    EndIf
EndDo
/*----------------------------------------------------------------
  FINALIZAÇÃO DA IMPRESSÃO DO RELATÓRIO
  ----------------------------------------------------------------
*/
@ nLIN,030 Psay "TOTAL GERAL --------------->"
@ nLIN,066 Psay nTOTAL Picture "@E 999,999,999.99"
Roda( 0, Space( 10 ), cTAMANHO )

If aReturn[ 5 ] == 1
   dbCommitAll()
   ourspool( cNOMREL )
Endif

MS_FLUSH()
