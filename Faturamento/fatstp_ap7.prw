#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function fatstp()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,CDESC1,CDESC2,CDESC3,CNATUREZA,ARETURN")
SetPrvt("NOMEPROG,CPERG,NLASTKEY,WNREL,CSTRING,TITULO")
SetPrvt("NQTDOP,NQTD,CDESC,APROD,NCONT,I")
SetPrvt("CPARCOD,NPARQTD,NLIN,NIMP,NQTDEST,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Fatstp  ³ Autor ³   Adenildo Almeida    ³ Data ³19/01/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Solicitacao de Transferencia de Produtos                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
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

cDesc1 :=PADC("Este programa ira gerar Solicit. p/ Transferencia de Saldo Entre Produtos)",74)
cDesc2 :=""
cDesc3 :=""
cNatureza:=""
aReturn := { "Empreendimentos", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="FATSTP"
cPerg:="FATSTP"
nLastKey:= 0
wnrel    := "FATSTP"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao no SX1               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SC2"
titulo :=Padc("Solicitacao p/ Transf. de Produtos",40)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

dbSelectArea("SC2")
SC2->( DBSetOrder(1) )

dbSelectArea("SB1")
SB1->( DBSetOrder(1) )

dbSelectArea("SB2")
SB2->( DBSetOrder(1) )

dbSelectArea("SB5")
SB5->( DBSetOrder(1) )


/*
DbSelectArea("SD3")
SD3->( dbSetOrder( 2 ) )
DbSeek(xFilial("SD3") + mv_par01,.t.)
Count To nREGTOT While SD3->D3_FILIAL == xFilial("SD3") .And. SD3->D3_DOC <= mv_par02 .And. ! SD3->( EOF() )
DbSeek(xFilial("SD3") + mv_par01,.t.)
SetRegua( nREGTOT )
*/


If mv_par02 == 1
   DbSelectArea("SC2")
   If DbSeek( xFilial("SC2") + mv_par03 + "01001" )
      If SC2->C2_DATRF == CToD("  /  /  ")
         If Alltrim(SC2->C2_PRODUTO) == Alltrim(mv_par01)
            SB1->( DbSeek( xFILIAL("SB1") + SC2->C2_PRODUTO ) )
            SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )
            nQTDOP := If(SC2->C2_UM == "MR",SC2->C2_QUANT, (SC2->C2_QUANT*SB5->B5_QE2)/1000)
            nQTD := 0
            cDESC := SB1->B1_DESC
            aPROD := Array(05,04)
            nCONT := 0
            For I:=4 To 12 STEP 2
               cPARCOD := "mv_par" + StrZero(I,2)
               nPARQTD := "mv_par" + StrZero(I+1,2)
               //Aviso("M E N S A G E M", (&cPARCOD), {"OK"})
               //Aviso("M E N S A G E M", Str((&nPARQTD)), {"OK"})
               If SB1->( DbSeek( xFILIAL("SB1") + (&cPARCOD) ) )
                  SB5->( DbSeek( xFILIAL("SB5") + (&cPARCOD) ) )
                  nQTD := nQTD + If(SB1->B1_UM == "MR",(&nPARQTD), ((&nPARQTD)*SB5->B5_QE2)/1000)
                  //nQTD := nQTD + (&nPARQTD)
                  nCONT := nCONT + 1
                  If (&cPARCOD) #Space(15)
                     aPROD[nCONT,1] := (&cPARCOD)
                     aPROD[nCONT,2] := SB1->B1_DESC
                     aPROD[nCONT,3] := SB1->B1_UM
                     aPROD[nCONT,4] := (&nPARQTD)
                     //Aviso("M E N S A G E M 1", aPROD[nCONT,1]+" - "+aPROD[nCONT,2], {"OK"})
                     //Aviso("M E N S A G E M 2", aPROD[nCONT,3]+" - "+STR(aPROD[nCONT,4]), {"OK"})
                  Endif

               Endif
            Next
            //Aviso("M E N S A G E M", Transf(nQTDOP,"@E 999999.999"), {"OK"})
            //Aviso("M E N S A G E M", Transf(nQTD,"@E 999999.999"), {"OK"})
            If nQTD > nQTDOP
               Aviso("M E N S A G E M", "Quantidade solicitada maior que a quant. da OP", {"OK"})
               SAI_PROG()
            Else
               //If MV_PAR02 == 1
                nLIN := -2
                For nIMP:=1 To 2
                  nLIN := nLIN + 2
                  @ nLIN+00,000 psay " _______________________________________________________________________________"
                  @ nLIN+01,000 psay "|                                                                               |"
                  If nIMP==1
                     @ nLIN+02,000 psay "|  RAVA Embalagens Industria e Comercio Ltda.  ***( VIA SOLICITANTE)***         |"
                  Else
                     @ nLIN+02,000 psay "|  RAVA Embalagens Industria e Comercio Ltda.  ***( VIA AUTORIZADOR)***         |"
                  Endif
                  @ nLIN+03,000 psay "|                                                                               |"
                  @ nLIN+04,000 psay "|         S O L I C I T A € A O  P/  T R A N S F O R M A € A O                  |"
                  @ nLIN+05,000 psay "|                                                                               |"
                  @ nLIN+06,000 psay "|         Ordem de Produ‡ao N§: ______          Data: ________                  |"
                  @ nLIN+06,000 psay ""
                  @ nLIN+06,032 psay SC2->C2_NUM
                  @ nLIN+06,054 psay DToC(DDataBase)
                  @ nLIN+07,000 psay ""
                  @ nLIN+07,000 psay "|                                                                               |"
                  @ nLIN+08,000 psay "|-------------------------------------------------------------------------------|"
                  @ nLIN+09,000 psay "|                                                                               |"
                  @ nLIN+10,000 psay "|                                                                               |"
                  @ nLIN+10,000 psay ""
                  @ nLIN+10,000 psay "  PRODUTO ORIGINAL-> " + Alltrim(mv_par01) + " - " + Alltrim(cDESC)
                  @ nLIN+11,000 psay ""
                  @ nLIN+11,000 psay "|                                                                               |"
                  @ nLIN+12,000 psay "|-------------------------------------------------------------------------------|"
                  @ nLIN+13,000 psay "|                                                                               |"
                  @ nLIN+13,000 psay ""
                  @ nLIN+13,000 psay "                          P R O D U T O S   F I N A I S"
                  @ nLIN+14,000 psay ""
                  @ nLIN+14,000 psay "|-------------------------------------------------------------------------------|"
                  @ nLIN+15,000 psay "|            |                                                   |  |           |"
                  @ nLIN+15,000 psay ""
                  @ nLIN+15,000 psay "  CODIGO      DESCRI€AO                                           UM  QUANT"
                  @ nLIN+16,000 psay ""
                  @ nLIN+16,000 psay "|-------------------------------------------------------------------------------|" 
                
                  nLIN  := nLIN + 16
                  For I:=1 To 5
                     If aPROD[I,1] #NIL
                        nLIN := nLIN + 1
                        @ nLIN,000 psay "|            |                                                   |  |           |"
                        @ nLIN,000 psay ""
                        @ nLIN,000 psay "  "+Subs(aPROD[I,1],1,10)+"  "+Subs(aPROD[I,2],1,50)+"  "+aPROD[I,3]+"  "+Transf(aPROD[I,4],"@E 99999.999") 
                        nLIN := nLIN + 1
                        @ nLIN,000 psay ""
                        @ nLIN,000 psay "|-------------------------------------------------------------------------------|" 
                     Endif
                  Next
                  @ nLIN+1,000 psay "| SOLICITANTE:______________  AUTORIZA€AO:______________  APONTADO:_____________|"
                  @ nLIN+2,000 psay "|_______________________________________________________________________________|"
                  nLIN := nLIN + 2
                Next


               //Endif
                                                                                               
            Endif


         Else
            Aviso("M E N S A G E M", "Produto nÆo Contido na Ordem de Produ‡Æo!", {"OK"})
            SAI_PROG()
         Endif
      Else
         Aviso("M E N S A G E M", "Ordem de Producao Encontra-se Encerrada!", {"OK"})
         SAI_PROG()
      Endif
   Else
      Aviso("M E N S A G E M", "Ordem de Produ‡Æo nÆo Encontrada!", {"OK"})
      SAI_PROG()
   Endif
Else
   If SB1->( DbSeek( xFILIAL("SB1") + mv_par01 ) )
      SB2->( DbSeek( xFILIAL("SB2") + mv_par01 ) )
      SB5->( DbSeek( xFILIAL("SB5") + mv_par01 ) )
      nQTDEST := If(SB1->B1_UM == "MR",SB2->B2_QATU, (SB2->B2_QATU*SB5->B5_QE2)/1000)
      nQTD := 0
      cDESC := SB1->B1_DESC
      aPROD := Array(05,04)
      nCONT := 0
      For I:=4 To 12 STEP 2
         cPARCOD := "mv_par" + StrZero(I,2)
         nPARQTD := "mv_par" + StrZero(I+1,2)
         //Aviso("M E N S A G E M", (&cPARCOD), {"OK"})
         //Aviso("M E N S A G E M", Str((&nPARQTD)), {"OK"})
         If SB1->( DbSeek( xFILIAL("SB1") + (&cPARCOD) ) )
            SB5->( DbSeek( xFILIAL("SB5") + (&cPARCOD) ) )
            nQTD := nQTD + If(SB1->B1_UM == "MR",(&nPARQTD), ((&nPARQTD)*SB5->B5_QE2)/1000)
            //nQTD := nQTD + (&nPARQTD)
            nCONT := nCONT + 1
            If (&cPARCOD) #Space(15)
               aPROD[nCONT,1] := (&cPARCOD)
               aPROD[nCONT,2] := SB1->B1_DESC
               aPROD[nCONT,3] := SB1->B1_UM
               aPROD[nCONT,4] := (&nPARQTD)
               //Aviso("M E N S A G E M 1", aPROD[nCONT,1]+" - "+aPROD[nCONT,2], {"OK"})
               //Aviso("M E N S A G E M 2", aPROD[nCONT,3]+" - "+STR(aPROD[nCONT,4]), {"OK"})
            Endif
         Endif
      Next
      //Aviso("M E N S A G E M", Transf(nQTDEST,"@E 999999.999"), {"OK"})
      //Aviso("M E N S A G E M", Transf(nQTD,"@E 999999.999"), {"OK"})
      If nQTD > nQTDEST
         Aviso("M E N S A G E M", "Quantidade solicitada maior que a quant. em estoque", {"OK"})
         SAI_PROG()
      Else
         nLIN := -2
         For nIMP:=1 To 2
            nLIN := nLIN + 2
            @ nLIN+00,000 psay " _______________________________________________________________________________"
            @ nLIN+01,000 psay "|                                                                               |"
            If nIMP==1
               @ nLIN+02,000 psay "|  RAVA Embalagens Industria e Comercio Ltda.  ***( VIA SOLICITANTE)***         |"
            Else
               @ nLIN+02,000 psay "|  RAVA Embalagens Industria e Comercio Ltda.  ***( VIA AUTORIZADOR)***         |"
            Endif
            @ nLIN+03,000 psay "|                                                                               |"
            @ nLIN+04,000 psay "|         S O L I C I T A € A O  P/  T R A N S F O R M A € A O                  |"
            @ nLIN+05,000 psay "|                                                                               |"
            @ nLIN+06,000 psay "|                                               Data: ________                  |"
            @ nLIN+06,000 psay ""
            @ nLIN+06,054 psay DToC(DDataBase)
            @ nLIN+07,000 psay ""
            @ nLIN+07,000 psay "|                                                                               |"
            @ nLIN+08,000 psay "|-------------------------------------------------------------------------------|"
            @ nLIN+09,000 psay "|                                                                               |"
            @ nLIN+10,000 psay "|                                                                               |"
            @ nLIN+10,000 psay ""
            @ nLIN+10,000 psay "  PRODUTO ORIGINAL -> " + Alltrim(mv_par01) + " - " + Alltrim(cDESC)
            @ nLIN+11,000 psay ""
            @ nLIN+11,000 psay "|                                                                               |"
            @ nLIN+12,000 psay "|-------------------------------------------------------------------------------|"
            @ nLIN+13,000 psay "|                                                                               |"
            @ nLIN+13,000 psay ""
            @ nLIN+13,000 psay "                          P R O D U T O S   F I N A I S"
            @ nLIN+14,000 psay ""                         
            @ nLIN+14,000 psay "|-------------------------------------------------------------------------------|"
            @ nLIN+15,000 psay "|            |                                                   |  |           |"
            @ nLIN+15,000 psay ""
            @ nLIN+15,000 psay "  CODIGO      DESCRI€AO                                           UM  QUANT"
            @ nLIN+16,000 psay ""
            @ nLIN+16,000 psay "|-------------------------------------------------------------------------------|" 
              
            nLIN  := nLIN + 16
            For I:=1 To 5
               If APROD[I,1] #NIL
                  nLIN := nLIN + 1
                  @ nLIN,000 psay "|            |                                                   |  |           |"
                  @ nLIN,000 psay ""                                                            
                  @ nLIN,000 psay "  "+Subs(aPROD[I,1],1,10)+"  "+Subs(aPROD[I,2],1,50)+"  "+aPROD[I,3]+"  "+Transf(aPROD[I,4],"@E 99999.999") 
                  nLIN := nLIN + 1
                  @ nLIN,000 psay ""
                  @ nLIN,000 psay "|-------------------------------------------------------------------------------|" 
               Endif
            Next
            @ nLIN+1,000 psay "| SOLICITANTE:______________  AUTORIZA€AO:______________  APONTADO:_____________|"
            @ nLIN+2,000 psay "|_______________________________________________________________________________|"
            nLIN := nLIN + 2
         Next
      
      Endif

   Else
      Aviso("M E N S A G E M", "Produto nÆo Cadastrado!", {"OK"})
      SAI_PROG()
   Endif

Endif

SAI_PROG()

Return(.T.)


******************
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function SAI_PROG
Static Function SAI_PROG()
******************
//Roda(0,"","G")
If aReturn[5] == 1
   dbCommitAll()
   ourspool(wnrel)
Endif

RetIndex('SC2')
RetIndex('SB2')
RetIndex('SB5')
RetIndex('SB1')

MS_FLUSH()

/*

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

*/
