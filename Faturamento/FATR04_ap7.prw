#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATR04()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,CDESC1,CDESC2,CDESC3,CNATUREZA")
SetPrvt("ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA,NLIN")
SetPrvt("WNREL,M_PAG,NTAMNF,CSTRING,TITULO,CABEC1")
SetPrvt("CABEC2,NPMEDIO,NQTDPED,APRAZ,CDOC,CSERIE")
SetPrvt("NPESQ,ACONDICAO,NMED,X,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Fatr04  ³ Autor ³   Silvano Araujo      ³ Data ³ 13/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de prazo medio faturado                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Rava                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// De Nota                                  ³
//³ mv_par02        	// Ate Nota                                 ³
//³ mv_par03        	// De Emissao                               ³
//³ mv_par04        	// Ate Emissao                              ³
//³ mv_par05        	// De Cliente                               ³
//³ mv_par06        	// Ate a Cliente                            ³
//³ mv_par07        	// Considera a vista   Sim ou Nao           ³
//³ mv_par08        	// Condicoes a vista                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="m"
limite:=254

cDesc1 :=PADC("Este programa ira Emitir posicao carteira pedidos de vendas",74)
cDesc2 :=""
cDesc3 :=""
cNatureza:=""
aReturn := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="FATR04"
cPerg:="FATR04"
nLastKey:= 0
lContinua := .T.
nLin:=9
wnrel    := "FATR04"
M_PAG    := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tamanho do Formulario de Nota Fiscal (em Linhas)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTamNf:=72     // Apenas Informativo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SC5"
titulo :=PADC("Relatorio Condicao de pagamento",74)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
nLin     := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1:= "Pedido  1a Cond. 2a Cond. 3a Cond. Media Nota"
cabec2:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FATR04",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="FATR04"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
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
SC5->( dbSetOrder( 1 ) )
SD2->( dbSetOrder( 3 ) )
dbSelectArea("SF2")
dbSeek( xFilial( "SF2" )+ mv_par01,.t. )
SetRegua( LastRec() )
nPMedio := nQtdPed := 0

While SF2->F2_FILIAL == xFilial( "SF2" )  .and. SF2->F2_DOC <= mv_par02 .and. SF2->( !Eof() ) .and. lContinua

   if SF2->F2_CLIENTE < mv_par05 .or. SF2->F2_CLIENTE > mv_par06
      SF2->( dbSkip() )
      IncRegua()
      Loop
   endif

   if mv_par07 == 2 .and. Alltrim( SF2->F2_COND ) $ mv_par08 .or. mv_par07 == 2 .and. Alltrim( SF2->F2_CONDPA1) $ mv_par08
      SF2->( dbSkip() )
      IncRegua()
      loop
   endif

   if SF2->F2_EMISSAO < mv_par03 .or. SF2->F2_EMISSAO > mv_par04
      SF2->( dbSkip() )
      IncRegua()
      loop
   end

   aPraz    := {}
   cDoc     := SF2->F2_DOC
   cSerie   := SF2->F2_SERIE

   While SF2->F2_DOC == cDOc .and. SF2->( !Eof() )
      SE1->( dbSeek( xFilial( "SE1" ) + SF2->F2_SERIE + SF2->F2_DOC, .T. ) )
      while SE1->E1_PREFIXO + SE1->E1_NUM == SF2->F2_SERIE + SF2->F2_DOC .and. SE1->( !Eof() )
         nPesq   := Ascan( aPraz, { |aVAL| aVAL[1]==SE1->E1_VENCTO } )
         if nPesq == 0
            Aadd( aPraz, { SE1->E1_VENCTO, SE1->E1_VENCTO - SF2->F2_EMISSAO } )
         endif
         SE1->( dbSkip() )
      end

      SF2->( dbSkip() )
      IncRegua()
   end

   aCondicao := Asort( aPraz,,, { |X,Y| X[1]<Y[1] } )
   nMed      := 0
   for x := 1 to Len( aCondicao )
       nMed := nMed + aCondicao[ x, 2 ]
   next
   nMed := Round( nMed / Len( aCondicao ), 2 )

   SD2->( dbSeek( xFilial( "SD2" ) + cDoc + cSerie, .T. ) )
   SC5->( dbSeek( xFilial( "SC5" ) + SD2->D2_PEDIDO, .T. ) )

   IF nLin > 60
      nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
   EndIF

   @ nLin, 00 pSay SC5->C5_NUM
   @ nLin, 14 pSay Iif( Len( aCondicao ) >= 1, aCondicao[ 1, 2 ], 0 )    Picture "99"
   @ nLin, 23 pSay Iif( Len( aCondicao ) >= 2, aCondicao[ 2, 2 ], 0 )    Picture "99"
   @ nLin, 32 pSay Iif( Len( aCondicao ) >= 3, aCondicao[ 3, 2 ], 0 )    Picture "99"
   @ nLin, 35 pSay nMed                                              Picture "@E 99.99"
   @ nLin, 41 pSay cDoc

   nQtdPed := nQtdped + 1
   nPmedio := nPmedio + nMed
   nLin    := nLin    + 1

   IncRegua()

End

IF nLin > 60
   nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
EndIF

nLin := nLin + 1
@ nLin,00 pSay "Total Medio Geral Periodo ==>"
@ nLin,35 pSay Round( nPmedio / nQtdPed, 2 )  Picture "@E 99.99"
roda(cbcont,cbtxt,tamanho)

Retindex( "SC5" )

If aReturn[5] == 1
   dbCommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()
Return(.T.)
