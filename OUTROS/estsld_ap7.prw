#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function estsld()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,CDESC1,CDESC2,CDESC3,CNATUREZA,ARETURN")
SetPrvt("NOMEPROG,CPERG,NLASTKEY,WNREL,CSTRING,TITULO")
SetPrvt("CALMOXAR,NLIN,LCONTINUA,CDOC,DEMISSAO,CCC")
SetPrvt("CFORNEC,I,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Estsld  ³ Autor ³   Adenildo Almeida    ³ Data ³14/01/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Saldo em Estoque dos Produtos                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Estoque                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // da Solicitacao                        ³
//³ mv_par02            // Ate a Solicitacao                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="P"

cDesc1 :=PADC("Este programa ira imprimir o Saldo em estoque dos Produtos Ativos)",74)
cDesc2 :=""
cDesc3 :=""
cNatureza:=""
aReturn := { "Empreendimentos", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="ESTIRO"
cPerg:="ESTIRO"
nLastKey:= 0
wnrel    := "ESTIRO"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao no SX1               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SD3"
titulo :=Padc("Romaneio - Requisicao de Mercadoria",40)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:="ESTIRO"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,"",,Tamanho)
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

dbSelectArea("SI3")
SI3->( DBSetOrder(1) )

dbSelectArea("SA2")
SA2->( DBSetOrder(1) )

dbSelectArea("SB1")
SB1->( DBSetOrder(1) )

dbSelectArea("SD3")
SD3->( dbSetOrder( 2 ) )
dbSeek(xFilial("SD3") + mv_par01,.t.)
Count To nREGTOT While SD3->D3_FILIAL == xFilial("SD3") .And. SD3->D3_DOC <= mv_par02 .And. ! SD3->( EOF() )
dbSeek(xFilial("SD3") + mv_par01,.t.)
SetRegua( nREGTOT )
//ProcRegua( nREGTOT )

If nREGTOT > 0
   SX6->( DBSeek( xFilial("SX6") + "MV_ALMOXAR" ) )
   cALMOXAR := AllTrim( SX6->X6_CONTEUD )
   //Aviso("M e n s a g e m", cALMOXAR, {"OK"})
   nLin := 0
   lCONTINUA := .F.
   CABECA()
   cDOC     := SD3->D3_DOC
   dEMISSAO := SD3->D3_EMISSAO
   If SI3->( DBSeek( xFilial("SI3") + SD3->D3_CC, .T. ) )
      cCC := SubStr(SI3->I3_DESC,1,20)
   Endif
   If SA2->( DBSeek( xFilial("SA2") + SD3->D3_FORNEC + SD3->D3_LOJA ) )
      cFORNEC:= SubStr(SA2->A2_NOME,1,26)
   Endif


   While SD3->D3_FILIAL == xFilial("SD3") .And. SD3->D3_DOC <= mv_par02 .And. ! SD3->( EOF() )

      If SD3->D3_DOC #cDOC
         If nLin < 23
            For I:= nLin To 21
               @ I,001 pSay "**"
            Next
            nLin := 23
            RODAPE()

         Else
            For I:= nLin To 52
               @ I,001 pSay "**"
            Next
            nLin := 54
            RODAPE()

         Endif

      Endif
      lCONTINUA := .F.
      If nLin >= 22 .And. nLin <= 23
         If SD3->D3_DOC == cDOC
            @ 25,001 pSay "Continua..."
            lCONTINUA := .T.
         Endif
         nLin := 31
         CABECA()
      Else
         If nLin >= 53 
            If SD3->D3_DOC == cDOC
               @ 56,001 pSay "Continua..."
               lCONTINUA := .T.
            Endif
            nLin := 0
            CABECA()
         Endif
      Endif

      cDOC     := SD3->D3_DOC

      dEMISSAO := SD3->D3_EMISSAO
      If SI3->( DBSeek( xFilial("SI3") + SD3->D3_CC, .T. ) )
         cCC := SubStr(SI3->I3_DESC,1,20)
      Endif
      If SA2->( DBSeek( xFilial("SA2") + SD3->D3_FORNEC + SD3->D3_LOJA ) )
         cFORNEC:= SubStr(SA2->A2_NOME,1,26)
      Endif

      @ nLin,000 pSay SD3->D3_COD
      If SB1->( DBSeek( xFilial("SB1") + SD3->D3_COD ) )
         @ nLin,016 pSay SB1->B1_DESC
      Endif
      @ nLin,062 pSay SD3->D3_UM
      @ nLin,070 pSay SD3->D3_QUANT
      nLin := nLin + 1

    SD3->( DBSkip() )
    IncRegua()
    //IncProc()

   Enddo
   If nLin < 23
      For I:= nLin To 21
         @ I,001 pSay "**"
      Next
      nLin := 23
      RODAPE()

   Else
      For I:= nLin To 52
         @ I,001 pSay "**"
      Next
      nLin := 54
      RODAPE()

   Endif

Endif


//Roda(0,"","G")
If aReturn[5] == 1
   dbCommitAll()
   ourspool(wnrel)
Endif

RetIndex('SI3')
RetIndex('SD3')
RetIndex('SA2')
RetIndex('SB1')

MS_FLUSH()

Return(.T.)



****************
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function CABECA
Static Function CABECA()
****************
   @ nLin  ,000 pSay Repl("*",80)
   @ nLin+1,000 pSay "*" + Alltrim(SM0->M0_NOME) + " / " + SM0->M0_FILIAL
   @ nLin+1,062 pSay  "Numero..:" + SD3->D3_DOC + "  *"
   @ nLin+2,000 pSay "*Siga /" + wnrel + "/v.4.07 " +;
     If(Val(SD3->D3_TM)<500,"   Romaneio de Entrega de Mercadoria","       Requisicao de Mercadoria")
   @ nLin+2,062 pSay "DT. Ref.:" + DToc(DDatabase) + "*"
   @ nLin+3,000 pSay "*Hora..." + Time()
   If lCONTINUA == .T.
      @ nLin+3,033 pSay "( Continuacao )"
   Endif
   @ nLin+3,062 pSay "Emissao.:" + DToC(Date()) + "*"
   @ nLin+4,000 pSay Repl("*",80)
                    //         10        20        30        40        50        60        70        80
                    //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   @ nLin+5,000 pSay "CODIGO          DISCRIMINACAO DO PRODUTO                      UN      QUANTIDADE"
   @ nLin+6,000 pSay Repl("*",80)
   nLin := nLin +7

Return NIL


****************
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function RODAPE
Static Function RODAPE()
****************
                    //         10        20        30        40        50        60        70        80
                    //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   @ nLin+1,000 pSay "Declaro que Recebi e conferi os materiais aqui discriminados       em   " + DToC(dEMISSAO)
   @ nLin+2,060 pSay Padc(AllTrim(cCC),20)
   @ nLin+3,000 pSay "______________________      __________________________      ____________________"
   @ nLin+4,000 pSay "  Ass. do Almoxarife            Ass. do Fornecedor             Centro de Custo"
   @ nLin+5,000 pSay Padc(cALMOXAR,22)
   @ nLin+5,028 pSay Padc(AllTrim(cFORNEC),26)

Return NIL
