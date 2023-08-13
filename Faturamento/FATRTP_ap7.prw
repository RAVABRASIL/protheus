#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATRTP()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,TAMANHO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,NLIN")
SetPrvt("WNREL,M_PAG,NTAMNF,CSTRING,TITULO,CABEC1")
SetPrvt("CABEC2,CINDSF2,CCHAVE,CFILTRO,NTOTAL,CDOC")
SetPrvt("AREGISTROS,CNOME,DEMISSAO,NVALBRUT,CREPRES,CNOTA")
SetPrvt("NTOTREP,J,CSERIE,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  FATRTP  ³ Autor ³   Adenildo M. Almeida ³ Data ³ 05/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de vendas diario                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Rava Embalagens                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                              ³
//³ mv_par01         // Do Representante                              ³
//³ mv_par02         // Ate o Representante                           ³
//³ mv_par03         // Da Emissao                                    ³
//³ mv_par04        	// Ate a Emissao                                 ³
//³ mv_par05         // Da Nota                                       ³
//³ mv_par06        	// Ate Nota                                      ³
//³ mv_par07         // Do Cliente                                    ³
//³ mv_par08         // Ate o Cliente                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt:=""
CbCont:=""
tamanho:="M"

cDesc1 :=PADC("Este programa ira Emitir relacao de vendas diaria",74)
cDesc2 :=""
cDesc3 :=""
cNatureza:=""
aReturn := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="FATRTP"
cPerg:="FATRTP"
nLastKey:= 0
nLin:=9
wnrel    := "FATRTP"
M_PAG    := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tamanho do Formulario de Nota Fiscal (em Linhas)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTamNf:=72     // Apenas Informativo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"
titulo :="Relacao de Notas Fiscais Por Representante"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
nLin     := 80

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FATR01",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="FATRTP"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
titulo := titulo + " ( " + DToC(mv_par03) + " a " +  DToC(mv_par04) + " )"

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          //         10        20        30        40        50        60        70        80        90       100       110       120       130
          //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
cabec1  := "Representante     N.F.     Nome do Cliente                  Transportadora    Dt Emissao     Valor Total   Dt Venct     Valor Duplic"
cabec2  := ""

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF

SF1->( dbSetorder( 2 ) )
SD1->( dbSetorder( 1 ) )
SD2->( dbSetorder( 3 ) )
SE1->( dbSetorder( 1 ) )
SA3->( dbSetorder( 1 ) )
SA4->( dbSetorder( 1 ) )
dbSelectArea("SF2")
cIndSf2 := "SF2"+Substr( Time(), 4, 2 ) + Substr( Time(), 7, 2 )
cChave  := "F2_FILIAL + SF2->F2_VEND1 + Dtos( F2_EMISSAO ) + F2_DOC"
cFiltro := "F2_VEND1 >= mv_par01 .And. F2_VEND1 <= mv_par02  .And. F2_EMISSAO >= mv_par03 .and. F2_EMISSAO <= mv_par04 .And. SF2->F2_DOC >= mv_par05  .And. SF2->F2_DOC <= mv_par06  .And. F2_SERIE >= mv_par09 .and. F2_SERIE <= mv_par10"
IndRegua( "SF2", cIndSf2, cChave, , cFiltro,"Selecionando Notas.." )
SetRegua( Lastrec() )
nTotal := 0
cDoc   := ""

aREGISTROS := {}
While SF2->( !Eof() ) .And. SF2->F2_FILIAL == xFilial( "SF2" )

   if SF2->F2_CLIENTE < mv_par07 .or. SF2->F2_CLIENTE > mv_par08
      SF2->( dbSkip() )
      Loop
      IncRegua()
   endif

   ********** (SE TIVER NOTA FISCAL DE DEVOLUCAO A EMPRESA) - ADENILDO **********
   If SF1->( dbSeek( xFilial( "SF1" ) + SF2->F2_CLIENTE + SF2->F2_LOJA, .T. ) )
      While SF1->F1_FORNECE == SF2->F2_CLIENTE .And. SF1->F1_LOJA == SF2->F2_LOJA .And. SF1->( !Eof() )
         If SD1->( dbSeek( xFilial( "SD1" ) + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA , .T. ) )
            //If SD1->D1_NFORI == SF2->F2_DOC .And. SD1->D1_SERIORI == "UNI"     //SF2->F2_SERIE
            If SD1->D1_NFORI == SF2->F2_DOC .And. SD1->D1_SERIORI $ "UNI/0  "     //SF2->F2_SERIE
               SF2->( dbSkip() )
               IncRegua()
               Loop
            Endif
         Endif
         SF1->( dbSkip() )
         IncRegua()
      End
   Endif
   ********** ADENILDO **********

   if SF2->F2_TIPO == "D"
      SA2->( dbSeek( xFilial( "SA2" ) + SF2->F2_CLIENTE + SF2->F2_LOJA, .T. ) )
      cNome := Substr( SA2->A2_NOME, 1, 30 )
   else
      SA1->( dbSeek( xFilial( "SA1" ) + SF2->F2_CLIENTE + SF2->F2_LOJA, .T. ) )
      cNome := Substr( SA1->A1_NOME, 1, 30 )
   endif

   SA3->( dbSeek( xFilial( "SA3" ) + SF2->F2_VEND1, .t. ) )
   SA4->( dbSeek( xFilial( "SA4" ) + SF2->F2_TRANSP, .T. ) )

   cDoc   := SF2->F2_DOC
   cSERIE := SF2->F2_SERIE

   dEmissao := SF2->F2_EMISSAO
   nValbrut := SF2->F2_VALBRUT

   While SF2->F2_DOC == cDoc .and. SF2->F2_SERIE == cSERIE .and. SF2->( !Eof() ) .And. SF2->F2_FILIAL == xFilial( "SF2" )

      SE1->( dbSeek( xFilial( "SE1" ) + SF2->F2_SERIE + SF2->F2_DOC, .T. ) )
      While SE1->E1_PREFIXO + SE1->E1_NUM == SF2->F2_SERIE + SF2->F2_DOC .and. SE1->( !Eof() )

         Aadd( aREGISTROS, { Substr( SA3->A3_NOME,1,16 ),cDoc+Left( cSERIE, 1 ),cNome,Substr( SA4->A4_NREDUZ,1,15 ),dEmissao,nValBrut,SE1->E1_VENCTO, SE1->E1_VALOR } )
         nTotal   := nTotal   + SE1->E1_VALOR
         SE1->( dbSkip() )

      Enddo

      SF2->( dbSkip() )
      IncRegua()

   Enddo

EndDo

   cREPRES := Space(16)
   cNOTA   := Space(06)
   nTOTREP := 0

   If Len( aREGISTROS ) > 0
      For J := 1 to Len( aREGISTROS )
         IF nLin > 58
            nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
         EndIf

         If aREGISTROS[J,1] == cREPRES  .Or. cREPRES == Space(16)
            nTOTREP := nTOTREP + aREGISTROS[ J, 8 ]
         Else
            nLin := nLin + 1
            @ nLin,00 pSay "Total Representante ==>"
            @ nLin,119 pSay nTOTREP  Picture "@E 99,999,999.99"
            nLin := nLin + 1
            @ nLin, 000 pSay Replicate( "-", 132 )
            nLin := nLin + 1
            nTOTREP := aREGISTROS[ J, 8 ]
         Endif

         If aREGISTROS[J,1] #cREPRES
            @ nLin,000 pSay aREGISTROS[J,1]
         Endif
         If aREGISTROS[J,2] #cNOTA
            @ nLin,018 pSay aREGISTROS[J,2]
            @ nLin,027 pSay aREGISTROS[J,3]
            @ nLin,060 pSay aREGISTROS[J,4]
            @ nLin,079 pSay aREGISTROS[J,5]
            @ nLin,091 pSay aREGISTROS[J,6] Picture "@E 99,999,999.99"
         Endif
         @ nLin,107 pSay aREGISTROS[J,7]
         @ nLin,119 pSay aREGISTROS[J,8] Picture "@E 99,999,999.99"
         nLin := nLin + 1

         cREPRES := aREGISTROS[J,1]
         cNOTA   := aREGISTROS[J,2]
      Next

      nLin := nLin + 1
      @ nLin,00 pSay "Total Representante ==>"
      @ nLin,119 pSay nTOTREP  Picture "@E 99,999,999.99"
      nLin := nLin + 1
      @ nLin, 000 pSay Replicate( "-", 132 )
      nLin := nLin + 1

   Endif

IF nLin > 58
   nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
EndIF

nLin := nLin + 1
@ nLin,00 pSay "Total Geral ==>"
@ nLin,119 pSay nTotal  Picture "@E 99,999,999.99"

roda(cbcont,cbtxt,tamanho)

Retindex( "SD2" )
Retindex( "SF1" )
Retindex( "SD1" )
RetIndex( "SE1" )
RetIndex( "SA3" )
RetIndex( "SA4" )
dbSelectArea("SF2")
RetIndex( "SF2" )
Ferase( cIndSf2+".idx" )
If aReturn[5] == 1
   dbCommitAll()
   ourspool(wnrel)
Endif

Return(.T.)
