#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#INCLUDE "MATA330.CH"

/*
User Function XMATA330(lBat)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL nCnt:=1,nAtu:=5,nAnt:=5,nMult:=1,nTotRegs:=0   // ,cSav7,cSav20,cSaveMenuh
LOCAL lDigita,lAglutina
LOCAL nOpca
LOCAL oDlg,oSay,oBtn1,aLogsPart:={}
PRIVATE lMA330D1 :=.F.
PRIVATE lMA330D2 :=.F.
PRIVATE lMA330D3 :=.F.
PRIVATE lMA330CP :=.F.
PRIVATE lCstPart :=.F.
PRIVATE __HeadProva
PRIVATE __Contabil
PRIVATE __IntePms
PRIVATE __lChkFile
PRIVATE __lChgX5Fil
PRIVATE __lIntTMS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a permissao do programa em relacao aos modulos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AMIIn(4,12)
  lMA330D1 := (ExistBlock("MA330D1"))
  lMA330D2 := (ExistBlock("MA330D2"))
  lMA330D3 := (ExistBlock("MA330D3"))
  lMA330CP := (ExistBlock("MA330CP"))
  lA330Seq := (ExistBlock("MA330SEQ"))
  lA330TRB := (ExistBlock("MA330TRB"))
  lBat := If(lBat == NIL, .F., lBat)
  aRegraCP := {}
  nProdProp:= GetMV("MV_PRODPR0",NIL,1)
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preenche array com as regras do custo em partes.             ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If lMA330CP
    aRegraCP:=ExecBlock("MA330CP",.F.,.F.)
    If ValType(aRegraCP) # "A"
      aRegraCP:={}
    EndIf
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verifica se os campos do custo em partes estao Ok            ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If Len(aRegraCP) > 0
      lCstPart:=XMA330AvlCp(aRegracp,aLogsPart)
  EndIf

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Pega a variavel que identifica se o calculo do custo e' :    ³
  //³               O = On-Line                                    ³
  //³               M = Mensal                                     ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  PRIVATE cCusMed := GetMv("MV_CUSMED")
  PRIVATE dInicio := GetMv("MV_ULMES")+1
  PRIVATE lLancToOn

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Variavel que define o tamanho dos array que guardarao os cus-³
  //³ tos. Esta foi criada para facilitar alteracoes no programa da³
  //³ Willy Dresser.                                               ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  PRIVATE nTamArrCus := 5

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³Calculo das Data Validas usadas no sistema (outros modulos)   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  PRIVATE cMes, cMesMat, aDataIni, aDataFim, nNumero := 0, nSeqFIFO := 0

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Inicializa variavel de :                                     ³
  //³  - Baixa Proporcional do Empenho (cBxProp)                   ³
  //³  - Gera Requisicao Automatica    (cReqAut)                   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  PRIVATE cBxProp,cReqAut,cDocTran
  PRIVATE cLoteAnt,dDataAnt,cDocAnt

  PRIVATE lCusUnif := GetMV("MV_CUSFIL",.F.) // Identifica qdo utiliza custo por empresa

  cBxProp  := GetMv("MV_BXPROP")
  cReqAut  := GetMv("MV_REQAUT")
  aDataIni := DataInicio()
  aDataFim := DataFinal()
  PRIVATE aTabela22 := DataTabela()

  cDocTran := GetMV("MV_DOCTRAN")
  If Empty( cDocTran )
    cDocTran := "SK"
  Else
    cDocTran := SubStr( cDocTran,1,2 )
  EndIf

  If __cInternet != NIL
    lBat := .T.
  EndIf
  If !lBat
    If Getmv("MV_CUSTEXC") == "N"
      cMens := OemToAnsi(STR0001)+chr(13)   //"Esta rotina ser  executada em modo"
      cMens += OemToAnsi(STR0002)+chr(13)   //"compartilhado , conforme indicado"
      cMens += OemToAnsi(STR0003)+chr(13)   //"pelo parƒmetro MV_CUSTEXC."
      cMens += OemToAnsi(STR0004)+chr(13)   //"As movimenta‡”es que ocorrerem durante"
      cMens += OemToAnsi(STR0005)+chr(13)   //"o processo podem influir no c lculo."

      IF !MsgYesNo(cMens,OemToAnsi(STR0006))  //"ATEN€O"
        Return
      Endif
    Endif
  Else
    nOpca:=1
  End

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Carrega as perguntas selecionadas                            ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ dInicio  - Data Inicial para processamento                   ³
  //³ mv_par01 - Data limite para processamento                    ³
  //³ mv_par02 - Se mostra e permite digitar lancamentos contabeis ³
  //³ mv_par03 - Se deve aglutinar os lancamentos contabeis        ³
  //³ mv_par04 - Se deve atualizar os valores dos movimentos       ³
  //³ mv_par05 - Porcentual a ser adicionado ao custo medio da MOD ³
  //³ mv_par06 - 1 - centro de custo contabil  2 - extracontabil   ³
  //³ mv_par07 - Contas contabeis a serem inibidas - conta inicial ³
  //³ mv_par08 - Contas contabeis a serem inibidas - conta final   ³
  //³ mv_par09 - Deleta movimentos de Estorno, 1 = Sim  2 = Nao    ³
  //³ mv_par10 - Contabilizacao On line                            ³
  //³ mv_par11 - Gera estrutura p/movimentos                       ³
  //³ mv_par12 - Contabiliza ? 1 = Consumo 2 = Producao 3 = Ambas  ³
  //³ mv_par13 - Calcula MO  ? 1 = Sim     2 = Nao                 ³
  //³ mv_par14 - Metodo Apropriacao 1 = Sequencial                 ³
  //³                               2 = Mensal                     ³
  //³                               3 = Diaria                     ³
  //³ mv_par15 - Recalcula Niveis   1 = Sim 2 = Nao                ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  pergunte("MTA330",.F.)
  If !lBat
    pergunte("MTA330",.T.)
  EndIf

  lDigita   := Iif(mv_par02 == 1,.T.,.F.)
  lAglutina := Iif(mv_par03 == 1,.T.,.F.)
  lLanctoOn := Iif(mv_par10 == 1,.T.,.F.)
  lDigita   := IIf(lLanctoOn == .F.,.F.,lDigita)

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Identificacao da variavel cOpcoes                            ³
  //³                                                              ³
  //³  1a posicao - 1 Deve calcular o custo da MOD                 ³
  //³  2a posicao - 1 Calcula o custo com apropriacao sequencial   ³
  //³  3a posicao - 1 Calcula o custo com apropriacao mensal       ³
  //³  4a posicao - 1 Calcula o custo com apropriacao diaria       ³
  //³  Obs.: 0 sempre identifica que nao deve executar rotina      ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  if !lBat
    nOpca:=2
    DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi(STR0007) PIXEL //"Rec lculo do Custo M‚dio"
    @ 18,6 TO 70,287
    @ 27, 15 SAY OemToAnsi(STR0008) SIZE 268, 8         //"Este programa permite que o custo m‚dio seja recalculado de trˆs formas diferentes, atendendo"
    @ 37, 15 SAY OemToAnsi(STR0009) SIZE 268, 8         //"qualquer exigˆncia legal."
    @ 47, 15 SAY OemToAnsi(STR0010) + DTOC(dInicio) SIZE 268, 8 //"Data Inicial de Processamento : "
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Avisa o usuario sobre campos faltantes para calculo com      ³
    //³ custo em partes                                              ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Len(aRegraCP) > 0 .And. !lCstPart
      @ 57,015 SAY OemToAnsi(STR0028) Object oSay SIZE 268, 8  //"Custo em partes nao sera considerado pois algum(ns) campos(s) nao foi(ram) criado(s)"
      oSay:SetColor(CLR_HRED,GetSysColor(15))
      @ 110,470 BMPBUTTON TYPE 1 ACTION XMA330LPart(aLogsPart) OBJECT oBtn1
    EndIf
    DEFINE SBUTTON FROM 80, 193 TYPE 5 ACTION pergunte("MTA330",.T.) ENABLE
    DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE
    DEFINE SBUTTON FROM 80, 253 TYPE 2 ACTION oDlg:End() ENABLE
    ACTIVATE MSDIALOG oDlg
  EndIf
  If nOpca == 1
    Processa({|lEnd| XMA330Process(@lEnd)},STR0007,STR0011,.F.)    //"Recalculo do Custo Medio"###"Efetuando Recalculo do Custo Medio..."
  EndIf
EndIf
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA330Process³ Autor ³ Bregantim / Stiefano  ³ Data ³01/10/97³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa o recalculo do custo medio.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XMA330Process(lEnd)
LOCAL nTotRegs:=0
LOCAL cOrigens
LOCAL aTam:={}
LOCAL aStru:={},aCampos:={},aCamposTrx:={}
LOCAL cNomTrx:="",cNomTrx1:=""
LOCAL cNomTrb:="",cNomTrb1:="",cNomTrb2:="",cNomTrb3:="",cNomTrb4:="",cNomTrb5:=""
LOCAL cNomTrbU:="",cNomTrbU1:=""
Local lConsFil  :=  .T.
LOCAL lExiste:=lExistTRB:=lExistTRX:=lExistSG1:=.F., cProcNam:=""
Local lContinua := .T.
PRIVATE l330ArqExcl := Iif(Getmv("MV_CUSTEXC")!="N",.T.,.F.)    // Abertura de arq. exclusivos/compartilhados
lDigita   := Iif(mv_par02 == 1,.T.,.F.)
lAglutina := Iif(mv_par03 == 1,.T.,.F.)
lLanctoOn := Iif(mv_par10 == 1,.T.,.F.)
lDigita   := IIf(lLanctoOn == .F.,.F.,lDigita)
lCusFIFO  := GetMV("MV_CUSFIFO",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Identificacao da variavel cOpcoes                            ³
//³                                                              ³
//³  1a posicao - 1 Deve calcular o custo da MOD                 ³
//³  2a posicao - 1 Calcula o custo com apropriacao sequencial   ³
//³  3a posicao - 1 Calcula o custo com apropriacao mensal       ³
//³  4a posicao - 1 Calcula o custo com apropriacao diaria       ³
//³  Obs.: 0 sempre identifica que nao deve executar rotina      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cOPcoes := IIF(mv_par13== 1,"1000","0000")
cOpcoes := Subs(cOPcoes,1,mv_par14)+"1"+"0000"
cOPcoes := Subs(cOpcoes,1,4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atraves do parametro MV_CUSTEXC, verifica se a abertura de   ³
//³ arquivos e' exclusiva ou compartilhada.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l330ArqExcl
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Abre todos os arquivos de forma exclusiva                    ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If ! (MA280FLock("SD3") .And. MA280FLock("SD1") .And. MA280FLock("SB2") .And. MA280FLock("SC2") .And.;
      MA280FLock("SF4") .And. MA280FLock("SF5") .And. MA280FLock("SI1") .And. MA280FLock("SI2") .And.;
      MA280FLock("SI3") .And. MA280Flock("SI5") .And. MA280Flock("SI6") .And. MA280FLock("SI7") .And.;
      MA280FLock("SM2") .And. MA280FLock("SB9") .And. MA280Flock("SBD") .And. MA280Flock("SD8")) .And.;
      MA280FLock("SF8") .And. If(cPaisLoc#"BRA",MA280FLock("SCM") .And. MA280FLock("SCN"),.T.)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Fecha todos os arquivos e reabre-os de forma compartilhada   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbCloseAll()
    OpenFile(SubStr(cNumEmp,1,2))
    Return .T.
  EndIf

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Abre indices dos arquivos que foram abertos de forma exclusivo ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  OpenIndx("SD3")
  OpenIndx("SD1")
  OpenIndx("SB2")
  OpenIndx("SB9")
  OpenIndx("SC2")
  OpenIndx("SF4")
  OpenIndx("SF5")
  OpenIndx("SI1")
  OpenIndx("SI2")
  OpenIndx("SI3")
  OpenIndx("SI5")
  OpenIndx("SI6")
  OpenIndx("SI7")
  OpenIndx("SM2")
  OpenIndx("SBD")
  OpenIndx("SD8")
  OpenIndx("SF8")
  If cPaisLoc#"BRA"
    OpenIndx("SCM")
    OpenIndx("SCN")
  EndIf
Endif

If Subs(cOpcoes,1,1) == "1"
  dbSelectArea("SB2")           // saldos em estoque
  nTotRegs += RecCount()

  dbSelectArea("SB9")           // saldos iniciais
  nTotRegs += RecCount()

  dbSelectArea("SD3")           // movimentacoes internas (producao/requisicao/devolucao)
  nTotRegs += RecCount()
EndIf

If "1"$SubStr(cOpcoes,2,3)
  dbSelectArea("SB2")           // saldos em estoque
  nTotRegs += RecCount()

  dbSelectArea("SB9")           // saldos iniciais
  nTotRegs += RecCount()

  dbSelectArea("SC2")
  nTotRegs += RecCount()

  dbSelectArea("AF9")
  nTotRegs += RecCount()

  If SubStr(cOpcoes,3,1) == "1"
    nTotRegs += RecCount()
  EndIf

  dbSelectArea("SD1")           // itens das notas fiscais de entrada
  nTotRegs += RecCount()
  nTotRegs += RecCount()

  If SubStr(cOpcoes,4,1) == "1"
    nTotRegs += RecCount()
  EndIf

  dbSelectArea("SD2")           // itens das notas fiscais de saida
  nTotRegs += RecCount()
  nTotRegs += RecCount()

  If SubStr(cOpcoes,4,1) == "1"
    nTotRegs += RecCount()
  EndIf

  dbSelectArea("SD3")           // movimentacoes internas (producao/requisicao/devolucao)
  nTotRegs += RecCount()

  If SubStr(cOpcoes,3,1) == "1"
    nTotRegs += RecCount()
  EndIf

  If cPaisLoc # "BRA"
    dbSelectArea("SCM")           // Remitos
    nTotRegs += RecCount()
    nTotRegs += RecCount()

    dbSelectArea("SCN")
    nTotRegs += RecCount()
    nTotRegs += RecCount()
  EndIf
EndIf

ProcRegua(nTotRegs,16,4)

PRIVATE nHdlPrv  // Endereco do arquivo de contra prova dos lanctos cont.
PRIVATE cLoteEst // Numero do lote para lancamentos do estoque

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona numero do Lote para Lancamentos do Faturamento     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSeek(xFilial()+"09EST")
cLoteEst:=IIF(!Eof(),Trim(X5Descri()),"EST ")
PRIVATE nTotal := 0     // Total dos lancamentos contabeis
PRIVATE cArquivo        // Nome do arquivo contra prova

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se vai abrir o arquivo para lancamentos contabeis   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "1"$SubStr(cOpcoes,2,3)
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Cria o cabecalho do arquivo de prova                         ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  nHdlPrv := XA330HEAD(cLoteEst,"MATA330",Subs(cUsuario,7,6),@cArquivo)
  cOrigens := "MATA240/MATA250/MATA260/MATA330/MATA685/"
  IF mv_par12 != 2
    cOrigens += "MTA330C/"
  Endif
  IF mv_par12 != 1
    cOrigens += "MTA330P/"
  Endif
  If cPaisLoc <> "BRA"
    lConsFil  :=  !Empty(xFilial("SD1")+xFilial("SD2")+xFilial("SD3")+xFilial("SCN")+xFilial("SCM"))
  Endif
  cA100Apaga(cOrigens,mv_par01,lConsFil)
EndIf

If lCusFIFO
  dbSelectArea("SB7")
  dbCloseArea()

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Cria arquivo de trabalho para processar log da baixa.        ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cArqDBF  := CriaTrab(NIL,.f.)
  aStru    := { {"T_CONTEUDO" , "C" , 94 , 0 } }
  dbCreate( cArqDBF , aStru )
  dbUseArea( .T. ,, cArqDBF , "TMP" )
  dbGoTop()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho para processar pela sequencia.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos:={}
AADD(aCampos,{ "TRB_ALIAS"    ,"C",03,0 } )
AADD(aCampos,{ "TRB_RECNO"    ,"N",12,0 } )
AADD(aCampos,{ "TRB_ORDEM"    ,"C",03,0 } )
AADD(aCampos,{ "TRB_CHAVE"    ,"C",58,0 } )
AADD(aCampos,{ "TRB_NIVEL"    ,"C",03,0 } )
AADD(aCampos,{ "TRB_NIVSD3" ,"C",01,0 } )
AADD(aCampos,{ "TRB_COD"    ,"C",15,0 } )
AADD(aCampos,{ "TRB_DTBASE" ,"D",08,0 } )
AADD(aCampos,{ "TRB_OP"     ,"C",11,0 } )
AADD(aCampos,{ "TRB_CF"     ,"C",03,0 } )
AADD(aCampos,{ "TRB_SEQ"    ,"C",06,0 } )
AADD(aCampos,{ "TRB_SEQPRO" ,"C",06,0 } )
AADD(aCampos,{ "TRB_DTORIG" ,"D",08,0 } )
AADD(aCampos,{ "TRB_RECSD1" ,"N",08,0 } )
AADD(aCampos,{ "TRB_TES"    ,"C",03,0 } )
aTam:=TamSX3("D3_DOC")
AADD(aCampos,{ "TRB_DOC"    ,"C",aTam[1],0 } )
AADD(aCampos,{ "TRB_TIPO"   ,"C",01,0 } )
AADD(aCampos,{ "TRB_LOCAL"    ,"C",02,0 } )
AADD(aCampos,{ "TRB_RECSBD" ,"N",08,0 } )
AADD(aCampos,{ "TRB_RECTRB" ,"N",08,0 } )
AADD(aCampos,{ "TRB_TIPONF" ,"C",01,0 } )

cNomTrb  := CriaTrab(aCampos,.T.)
cNomTrb1 := Subs(cNomTrb,1,7)+"A"
cNomTrb2 := Subs(cNomTrb,1,7)+"B"
cNomTrb3 := Subs(cNomTrb,1,7)+"C"
cNomTrb4 := Subs(cNomTrb,1,7)+"D"
cNomTrb5 := Subs(cNomTrb,1,7)+"E"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho para processar producoes em locais  ³
//³ distintos                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nProdProp == 1
  AADD(aCamposTrx,{"TRX_DATA" ,"D",08,0 } )
  AADD(aCamposTrx,{"TRX_OP"   ,"C",11,0 } )
  AADD(aCamposTrx,{"TRX_COD"    ,"C",15,0 } )
  AADD(aCamposTrx,{"TRX_LOCAL"  ,"C",02,0 } )
  aTam:=TamSX3("D3_QUANT")
  AADD(aCamposTrx,{"TRX_QUANT"  ,"N",aTam[1],aTam[2] } )
  AADD(aCamposTrx,{"TRX_TOTAL"  ,"N",aTam[1]+1,aTam[2] } )
  AADD(aCamposTrx,{"TRX_QTDPRC","N",aTam[1]+1,aTam[2] } )
  cNomTrx  := CriaTrab(aCamposTrx,.T.)
  cNomTrx1 := Substr(cNomTrx,1,7)+"W"
EndIf
#IFDEF TOP
  if TcSrvType() <> "AS/400"
    cProcNam:="MAT004" //A330GRVTRB
    lExistTRB := TCCanOpen( "TRB"+SM0->M0_CODIGO+"0" )
    lExistTRX := TCCanOpen( "TRX"+SM0->M0_CODIGO+"0" )
    lExistSG1 := TCCanOpen( "TRB"+SM0->M0_CODIGO+"0SG1" )
    If ExistProc( cProcnam ) .AND. lExistTRB .AND. lExistTRX .AND. lExistSG1
      dbSelectArea("SG1")
      dbCloseArea()
      lExiste:=.T.
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Criando temp.SG1TRB - TRX - TRB - Utilizado pela MATA330 (caso n. existam)³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      dbUseArea( .T.,"TOPCONN","TRB"+SM0->M0_CODIGO+"0","TRB_SQL", .T., .F. )
      dbUseArea( .T.,"TOPCONN","TRX"+SM0->M0_CODIGO+"0","TRX_SQL", .T., .F. )
      dbUseArea( .T.,"TOPCONN","TR"+SM0->M0_CODIGO+"0SG1","SG1_SQL", .T., .F. )
      aTam:=TamSX3("D3_DOC")

      If Upper(TcGetDb()) == "INFORMIX"
        TCSpExec( "MSTRUNCATE" ) //Truncara as tabelas temporarias
      Else
        TCSqlExec("TRUNCATE TABLE "+"TRX"+SM0->M0_CODIGO+"0")
        TCSqlExec("TRUNCATE TABLE "+"TRB"+SM0->M0_CODIGO+"0")
        TCSqlExec("TRUNCATE TABLE "+"TRB"+SM0->M0_CODIGO+"0SG1")
      EndIf

      aResult := TCSpExec( xProcedures( cProcNam ),;
        SM0->M0_CODFIL         , GetMv("MV_NIVALT")   ,;
        GetMv("MV_LOCPROC")    , DtoS(MV_PAR01)       ,;
        MV_PAR09,MV_PAR11      , MV_PAR14             ,;
        If(GetMv("MV_CUSFIFO" ),'1','0')              ,;
        GetMv("MV_RASTRO")     , GetMv("MV_LOCALIZ")  ,;
        GetMv("MV_CQ")         , DtoS(dInicio)        ,;
        aTam[1];
        )
      if Empty(aResult)
        MsgAlert(STR0020) //'Erro na chamada do processo'
        dbSelectArea("SB1")
        dbSetOrder(1)
        If l330ArqExcl
          dbCloseAll()
          OpenFile(SubStr(cNumEmp,1,2))
        Endif
        Return
      elseif aResult[1] == "0"
        MsgAlert(STR0021) //'Reprocessamento com Erro'
        dbSelectArea("SB1")
        dbSetOrder(1)
        If l330ArqExcl
          dbCloseAll()
          OpenFile(SubStr(cNumEmp,1,2))
        Endif
        Return
      elseif aResult[1] == "1"
        TCSPEXEC( xProcedures( "MAT016" ) ) //A330PRCPR0 comentado por motivo de inconsistencia na procedure !!

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Efetuando Copia Tabela TRB### para arquivos Temporario  para utilizacao   ³
        //  da Logica CodeBase da Rotina 330Recalc()                                  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        dbSelectArea("TRB_SQL")
        dbGoTop()
        Copy To &cNomTrb //VIA __LocalDriver
        dbSelectArea("TRB_SQL")
        dbCloseArea()

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Efetuando Copia Tabela TRX### para arquivos Temporario para utilizacao    ³
        //³ da Logica CodeBase da Rotina 330Recalc()                                  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        dbSelectArea("TRX_SQL")
        dbGoTop()
        Copy To &cNomTrx //VIA __LocalDriver
        dbSelectArea("TRX_SQL")
        dbCloseArea()
      endif
    Else
      lExiste:=.F.
    EndIf
  Else
    lExiste:=.F.
  EndIf
#ENDIF

dbUseArea( .T.,,cNomTrb,"TRB", If(.T. .Or. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomTrb1,"DTOS(TRB_DTBASE)+TRB_ORDEM+TRB_CHAVE",,,STR0012)   //"Criando Arquivo Trabalho 1..."
IndRegua("TRB",cNomTrb2,"TRB_ALIAS+TRB_SEQ",,,STR0013)                //"Criando Arquivo Trabalho 2..."
IndRegua("TRB",cNomTrb3,"DTOS(TRB_DTBASE)+TRB_SEQPRO+TRB_ORDEM+TRB_NIVEL+TRB_NIVSD3+TRB_CHAVE+TRB_SEQ",,,STR0014)   //"Criando Arquivo Trabalho 3..."
IndRegua("TRB",cNomTrb4,"TRB_ALIAS+TRB_DOC+TRB_COD+TRB_LOCAL",,,STR0018)    //"Criando Arquivo Trabalho 4..."
IndRegua("TRB",cNomTrb5,"DTOS(TRB_DTORIG)+TRB_SEQ+TRB_NIVEL+TRB_NIVSD3",,,STR0019)    //"Criando Arquivo Trabalho 5..."
dbClearIndex()
dbSetIndex(cNomTrb1+OrdBagExt())
dbSetIndex(cNomTrb2+OrdBagExt())
dbSetIndex(cNomTrb3+OrdBagExt())
dbSetIndex(cNomTrb4+OrdBagExt())
dbSetIndex(cNomTrb5+OrdBagExt())
dbSetOrder(1)

If nProdProp == 1
  dbUseArea( .T.,,cNomTrx,"TRX", If(.T. .Or. .F., !.F., NIL), .F. )
  IndRegua("TRX",cNomTrx1,"DTOS(TRX_DATA)+TRX_OP+TRX_COD+TRX_LOCAL",,,STR0012)    //"Criando Arquivo Trabalho 1..."
  dbClearIndex()
  dbSetIndex(cNomTrx1+OrdBagExt())
  dbSetOrder(1)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta arquivo de trabalho p/ processar custo por empresa     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF lCusUnif
  XA330TRT(@cNomTrbU,@cNomTrbU1,lCstPart,Len(aRegraCP)+1)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Depois de definir o tamanho do salto do cursor ele executara'³
//³ as opcoes selecionadas.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Subs(cOpcoes,1,1) == "1"
  XA330Mod()
EndIf

If  lExiste == .F.
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Grava arquivo de trabalho                                    ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If (lContinua := XA330GrvTRB(@cNomTrbU,@cNomTrbU1,lExiste))
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Processa arquivo dos apontamentos                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lContinua .And. nProdProp == 1
      XA330PrcPR0()
    Endif
  Endif
EndIf

If lContinua
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Chama ponto de entrada para manipular arquivo de trabalho    ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If lA330TRB
    ExecBlock("MA330TRB",.F.,.F.)
  EndIf

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Recalcula o Custo                                            ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  XA330Recalc()

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Regrava o Custo no SB2                                       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  IF lCusUnif
    XA330TT2B2()
  Endif

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Processa Log se Tiver Problemas na Baixa dos Lotes "SBD".    ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If lCusFIFO
    cFile   :=  "LOGDIF.TXT"
    nHandler := MsFCreate(cFile)
    If fError() # 0 .Or. nHandler < 0
      Help(" ",1,"GPM350HAND")
      Return NIL
    Endif
    dbSelectArea( "TMP" )
    dbGoTop()
    While !Eof()
      fWrite( nHandler , T_CONTEUDO + CHR(13) + CHR(10) )
      dbSkip()
    EndDo
    Fclose( nHandler )

    If SELECT("TMP") # 0
      TMP->( dbCloseArea() )
      Ferase(cArqDBF + GetDBExtension())
      dbSelectArea( "SB1" )
    Endif
  Endif

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verifica se o custo medio e' calculado On-Line               ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If nHdlPrv != NIL
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se ele criou o arquivo de prova ele deve gravar o rodape'    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    XA330RODA(nHdlPrv,nTotal)
    If nTotal > 0
      cA100Incl(cArquivo,nHdlPrv,3,cLoteEst,lDigita,lAglutina,,mv_par01)
    EndIf
  EndIf
  Else
    Aviso("", STR0026, {"Ok"}) //"Cancelado pelo usuário"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivos de Trabalho (TRB/TRX)                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusFIFO .And. Select("TMP") # 0
  TMP->( dbCloseArea() )
  Ferase(cArqDBF + GetDBExtension())
Endif
dbSelectarea("TRB")
dbCloseArea()
Ferase(cNomTrb+GetDBExtension())
Ferase(cNomTrb1+OrdBagExt())
Ferase(cNomTrb2+OrdBagExt())
Ferase(cNomTrb3+OrdBagExt())
Ferase(cNomTrb4+OrdBagExt())
Ferase(cNomTrb5+OrdBagExt())
If nProdProp == 1
  dbSelectarea("TRX")
  dbCloseArea()
  Ferase(cNomTrx+GetDBExtension())
  Ferase(cNomTrx1+OrdBagExt())
EndIf
If lCusUnif
  dbSelectarea("TRT")
  dbCloseArea()
  Ferase(cNomTrbU+GetDBExtension())
  Ferase(cNomTrbU1+OrdBagExt())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha todos os arquivos e reabre-os de forma compartilhada,  ³
//³ se o parametro MV_CUSTEXC estiver p/ abertura exclusiva.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSetOrder(1)
If l330ArqExcl
  dbCloseAll()
  OpenFile(SubStr(cNumEmp,1,2))
Endif
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A330Mod  ³ Autor ³ Eveli Morasco         ³ Data ³ 04/02/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula o custo das requisicoes de mao de obra feitas no   ³±±
±±³          ³ periodo                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A330Mod(@ExpN1,@ExpN2,@ExpN3,ExpN4,@ExpC1,@ExpC2)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Contador continuo                                  ³±±
±±³          ³ ExpN2 = Posicao anterior da tela                           ³±±
±±³          ³ ExpN3 = Posicao atual calculada pelo nmult                 ³±±
±±³          ³ ExpN4 = Fator de multiplicacao para cada registro lido     ³±±
±±³          ³ ExpC1 = Linha original da regua                            ³±±
±±³          ³ ExpC2 = Regiao da tela apenas com o cursor                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XA330Mod()
LOCAL nX,nMes := Month(mv_par01),cCodant,aSaldos := {}
LOCAL aVFim[nTamArrCus],aCM[nTamArrCus],nQuant

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Zera os saldos de MOD para recalcular                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB2")
dbSeek( xFilial()+"MOD" )
While !EOF() .And. B2_FILIAL+Subs(B2_COD,1,3) == xFilial()+"MOD"
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Pega os saldos do centro de custo                            ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  aSaldos := XMA330SalCC(SubStr(SB2->B2_COD,4,9),mv_par01)

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Aplica o % de aumento no custo da MOD                        ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  For nX := 1 to Len(aSaldos)
    aSaldos[nX] += (aSaldos[nX] * (mv_par05/100))
  Next nX

  dbSelectArea("SB2")
  RecLock("SB2",.F.)
  Replace B2_CM1 With 0
  Replace B2_CM2 With 0
  Replace B2_CM3 With 0
  Replace B2_CM4 With 0
  Replace B2_CM5 With 0

  Replace B2_VFIM1 With aSaldos[01]
  Replace B2_VFIM2 With aSaldos[02]
  Replace B2_VFIM3 With aSaldos[03]
  Replace B2_VFIM4 With aSaldos[04]
  Replace B2_VFIM5 With aSaldos[05]
  MsUnlock()
  XTTFimMO(aSaldos)
  dbSkip()

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Movimentacao do Cursor                                       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  IncProc()
EndDo

dbSelectArea("SD3")
dbSetOrder(3)  // produto+sequencia
dbSeek(xFilial()+"MOD")
While !EOF() .And. D3_FILIAL+SUBS(D3_COD,1,3) == xFilial()+"MOD"

  dbSelectArea("SB2")
  dbSeek(xFilial()+SD3->D3_COD+SD3->D3_LOCAL)
  If EOF()
    CriaSB2(SD3->D3_COD,SD3->D3_LOCAL)
  EndIf
  dbSelectArea("SD3")
  cCodant:=D3_COD
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Totaliza as horas gastas no periodo                          ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  nQuant := 0
  While !EOF() .And. D3_FILIAL+D3_COD == xFilial()+cCodant

    If ( D3_EMISSAO >= dInicio .And. D3_EMISSAO <= mv_par01 )
      If D3_TM <= "500"
        nQuant += D3_QUANT
      Else
        nQuant -= D3_QUANT
      EndIf
    EndIf

    dbSkip()
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Movimentacao do Cursor                                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    IncProc()
  EndDo

  dbSelectArea("SB2")
  RecLock("SB2",.F.)
  Replace B2_QFIM With nQuant

  aVFim[01] := B2_VFIM1
  aVFim[02] := B2_VFIM2
  aVFim[03] := B2_VFIM3
  aVFim[04] := B2_VFIM4
  aVFim[05] := B2_VFIM5

  AFILL(aCM,0)

  For nX := 1 to 5
    If aVFim[nX] > 0
      aCM[nX] := aVFim[nX]/Abs(B2_QFIM)
    EndIf
  Next nX

  Replace B2_CM1 With aCM[01]
  Replace B2_CM2 With aCM[02]
  Replace B2_CM3 With aCM[03]
  Replace B2_CM4 With aCM[04]
  Replace B2_CM5 With aCM[05]
  MsUnlock()
  TTFimQtdMO()
  dbSelectArea("SD3")
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve ordem principal dos arquivos                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD3")
dbSetOrder(1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A330HEAD ³ Autor ³ Marcos Bregantim      ³ Data ³ 13/09/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Simula HEADPROVA testando lLanctoOn (Lancto. On-Line)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MA330HEad(xPar1,xPar2,xPar3,xPar4)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XA330HEAD(xPar1,xPar2,xPar3,xPar4)
Local nRet := 0
xPar2 := IIF(mv_par12==3,"MATA330",iif(mv_par12==1,"MTA330C","MTA330P"))
IF lLanctoOn
  nRet := XHEADPROVA(xPar1,xPar2,xPar3,@xPar4)
Endif
Return (nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A330RODA ³ Autor ³ Marcos Bregantim      ³ Data ³ 13/09/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Simula RODAPROVA testando lLanctoOn (Lancto. On-Line)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  A330RODA(xPar1,xPar2)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XA330RODA(xPar1,xPar2)
Local lRet:=.f.
IF lLanctoOn
  lRet := RodaProva(xPar1,xPar2)
Endif
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA330SalCC³ Autor ³ Marcos Bregantim      ³ Data ³ 19/05/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula a despesa do CC no mes especificado                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1 := MA330SalCC(ExpC1,ExpD1)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 := Array com os 5 custos devolvidos pela funcao      ³±±
±±³          ³ ExpC1 := Codigo do CC                                      ³±±
±±³          ³ ExpD1 := Data referente ao saldo a devolver                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XMA330SalCC(cCod,dData)
LOCAL nX,aSaldos[5],cDeb,cCre,nExercicio,nVar,cConta

AFILL(aSaldos,0)

If mv_par06 == 1
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Coloco o SI1 em ordem de Centro de Custo                     ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SI1")
  dbSetOrder(4)
  dbSeek(xFilial()+cCod)
  While !Eof() .And. xFilial()+cCod == I1_FILIAL+I1_CC
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Filtro de contas a serem inibidas (contas de transferencia)  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If I1_CODIGO >= mv_par07 .And. I1_CODIGO <= mv_par08
      dbSkip()
      Loop
    Endif

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Pego o saldo da moeda 1                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If DataMoeda(1,@cMes,dData)
      aSaldos[1] += I1_DEBM&cMes - I1_CRDM&cMes
    EndIF

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Vou ate o SI7 para pegar o saldo em outras moedas            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea("SI7")
    dbSeek(xFilial()+SI1->I1_CODIGO)
    While !Eof() .And. xFilial()+SI1->I1_CODIGO == I7_FILIAL+I7_CODIGO
      IF DataMoeda(Val(SI7->I7_MOEDA),@cMesMat,dData)
        aSaldos[Val(I7_MOEDA)] += I7_DEBM&cMesMat - I7_CRDM&cMesMat
      Endif
      dbSkip()
    EndDo
    dbSelectArea("SI1")
    dbSkip()
  EndDo
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Devolvo a ordem original do arquivo                          ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSetOrder(1)
Else
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Se for extracontabil eu pego todos os saldos do SI3          ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SI3")
  dbSeek(xFilial()+cCod)
  While !Eof() .And. xFilial()+cCod == I3_FILIAL+I3_CUSTO

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Filtro de contas a serem inibidas (contas de transferencia)  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If I3_CONTA >= mv_par07 .And. I3_CONTA <= mv_par08
      dbSkip()
      Loop
    Endif

    If I3_MOEDA$"12345"
      IF DataMoeda(Val(SI3->I3_MOEDA),@cMesMat,dData)
        aSaldos[Val(I3_MOEDA)] += I3_DEB&cMesMat - I3_CRE&cMesMat
      Endif
    EndIf
    dbSkip()
  EndDo
EndIf
Return aSaldos

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A330Ant   ³ Autor ³ Marcos Bregantim      ³ Data ³ 17/10/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se a DEV. VENDA e do mes anterior                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Xa330Ant(cNumero,cSerie)
Local cAlias := Alias(), lRet
dbSelectArea("SF2")
dbSetOrder(1)
dbSeek( xFilial() + cNumero + cSerie )
IF SF2->F2_EMISSAO >= dInicio .And. !Eof()
  lRet := .f.
Else
  lRet := .t.
Endif
dbSelectArea(cAlias)
Return lret

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A330RAnt  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 19/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se a DEV. VENDA e de remito do mes anterior        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Xa330RAnt(cNumero,cItem)
Local aArea := GetArea(),lRet
dbSelectArea("SCN")
dbSetOrder(1)
dbSeek( xFilial() + cNumero + cItem )
IF SCN->CN_EMISSAO >= dInicio .And. !Eof()
  lRet := .f.
Else
  lRet := .t.
Endif
RestArea(aArea)
Return lret


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA330DelD3³ Autor ³ Marcos Bregantim      ³ Data ³ 26/07/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Apaga movimentos de estorno no SD3                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MA330DelD3(Void)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XMA330DelD3()
Local aArea:=GetArea()
Local cSeek:=""
Local cCompara:=""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Remove registros estornados dos arquivos relacionados        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Rastro(SD3->D3_COD)
  dbSelectArea("SD5")
  dbSetOrder(3)
  cSeek:=xFilial()+SD3->D3_NUMSEQ+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_LOTECTL+IF(Rastro(SD3->D3_COD,"S"),SD3->D3_NUMLOTE,"")
  cCompara:="D5_FILIAL+D5_NUMSEQ+D5_PRODUTO+D5_LOCAL+D5_LOTECTL"+IF(Rastro(SD3->D3_COD,"S"),"+D5_NUMLOTE","")
  dbSeek(cSeek)
  While !Eof() .And. cSeek == &(cCompara)
    If D5_ESTORNO == "S"
      RecLock("SD5",.F.,.T.)
      dbDelete()
      MsUnlock()
    EndIf
    dbSkip()
  End
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Remove registros estornados dos arquivos relacionados        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Localiza(SD3->D3_COD)
  dbSelectArea("SDB")
  dbSetOrder(1)
  cSeek:=xFilial()+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_NUMSEQ+SD3->D3_DOC
  cCompara:="DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC"
  dbSeek(cSeek)
  While !Eof() .And. cSeek == &(cCompara)
    If DB_ESTORNO == "S"
      RecLock("SDB",.F.,.T.)
      dbDelete()
      MsUnlock()
    EndIf
    dbSkip()
  End
EndIf

RestArea(aArea)

RecLock("SD3",.F.,.T.)
dbDelete()
MsUnlock()
dbSkip()
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GRAVASEQ  ³ Autor ³ BREGANTIN             ³ Data ³ 23/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava Sequencia de Calculo                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XGravaSeq(cArq)
Local cAlias := Alias()
nNumero++
dbSelectArea(cArq)
IF cArq == "SD1"
  RecLock("SD1",.F.)
  Replace D1_SEQCALC With dTos(dInicio)+StrZero(nNumero,6,0)
ElseIf cArq == "SD2"
  RecLock("SD2",.F.)
  Replace D2_SEQCALC With dTos(dInicio)+StrZero(nNumero,6,0)
ElseIf cArq == "SD3"
  RecLock("SD3",.F.)
  Replace D3_SEQCALC With dTos(dInicio)+StrZero(nNumero,6,0)
ElseIf cArq == "SCM"
  RecLock("SCM",.F.)
  Replace CM_SEQCALC With dTos(dInicio)+StrZero(nNumero,6,0)
ElseIf cArq == "SCN"
  RecLock("SCN",.F.)
  Replace CN_SEQCALC With dTos(dInicio)+StrZero(nNumero,6,0)
Endif
MsUnlock()
dbSelectArea(cAlias)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A330DET  ³ Autor ³ Marcos Bregantim      ³ Data ³ 13/09/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Simula DETPROVA  testando lLanctoOn (Lancto. On-Line)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A330DET  (xPar1,xPar2,xPar3,xPar4,xPar5,xPar6)             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1: Handle de Arquivo                                   ³±±
±±³          ³ ExpC2: Codigo do Lancamento Padrao                         ³±±
±±³          ³ ExpC3: Rotina Chamadora                                    ³±±
±±³          ³ ExpC4: Lote Contabil                                       ³±±
±±³          ³ ExpC5: Alias                                               ³±±
±±³          ³ ExpL6: Forca 666/668 para Req/Dev de Consumo               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Xa330Det(xPar1,xPar2,xPar3,xPar4,xPar5,xPar6)
Local nRet := 0,cAlias := Alias(), lCCusto := .f.
Local l667669 := xPar2$"667#669"

xPar3 := IIF(mv_par12==3,"MATA330",iif(mv_par12==1,"MTA330C","MTA330P"))
xPar5 := IIF(xPar5==NIL,"SD3",xPar5)
xPar6 := IIF(xPar6==NIL,.F.,xPar6)

If xPar5 == "SD3"
  dbSelectArea("SD3")
  RecLock("SD3",.F.)
  IF lLanctoOn
    IF Empty(SD3->D3_OP) .And. Subs(SD3->D3_CF,2,2)$"E0#E3#E6#E8"
      lCCusto := .t.
    Endif
    Replace D3_DTLANC With dDataBase
    If ( mv_par12 == 1 .And. lCCusto .And. !l667669)
      nRet := xDETPROVA(xPar1,xPar2,xPar3,xPar4)
    ElseIf mv_par12 == 2 .And. ((!lCCusto .And. !l667669).Or.;
        (lCCusto .And. l667669).Or.;
        xPar6 )
      nRet := xDETPROVA(xPar1,xPar2,xPar3,xPar4)
    ElseIF mv_par12 == 3 .And. !l667669
      nRet := xDETPROVA(xPar1,xPar2,xPar3,xPar4)
    Endif
  Else
    Replace D3_DTLANC With CTOD("  /  /  ")
  Endif
  MsUnlock()
ElseIf mv_par12 != 1
  If lLanctoOn
    nRet := xDETPROVA(xPar1,xPar2,xPar3,xPar4)
  EndIf
Endif

dbSelectArea(cAlias)
Return (nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A330GrvTRB³ Autor ³ Bregantim / Stiefano  ³ Data ³ 15/10/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava arquivo de trabalho por nivel da estrutura           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A330GrvTRB(ExpC1,ExpC2)                                    ³±±
±±³          ³ ExpC1:= Variavel com nome do arquivo de trabalho p/ custo  ³±±
±±³          ³ unificado                                                  ³±±
±±³          ³ ExpC2:= Variavel com nome do indice  de trabalho p/ custo  ³±±
±±³          ³ unificado                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XA330GrvTRB(cNomTrbU,cNomTrbU1)
LOCAL cKey,cFilSD1,cFilSD2,cFilSD3,nIndex,lEofSD3
LOCAL cSeqGrava:="",aArea:={}
Local lRet := .T.

// LOCAL cSavAnt:=""

// Ordem Calculo
// 100 -> Compras "SD1"
// 105 -> LOCALIZACOES - Remitos de entrada por compra "SCM"
// 120 -> Entrada de beneficiamento fora e RE5 "SD1/SD3"
// 150 -> Devolucao Compras "SD2"
// 155 -> LOCALIZACOES - Devolucao Compras "SCM"
// 200 -> Devolucao Vendas Mes Anterior "SD1"
// 205 -> LOCALIZACOES - Devolucao de Vendas Mes Anterior "SCN"
// 250 -> Remessa Beneficiamento "Eu Benef." "SD1"
// 270 -> Remessa Beneficiamento "Fora" "SD2" de MP
// 280 -> Retorno Beneficiamento "Fora" "SD1" de MP
// 290 -> Retorno Beneficiamento "Eu Benef." "SD2"
// 300 -> Movimentacoes Internas "SD3" (menos req. p/ consumo)
// 301 -> Requisicoes para Consumo
// 400 -> Remessa Beneficiamento "Fora" "SD2" de PI e PA
// 450 -> Retorno Beneficiamento "Fora" "SD1" de PI e PA
// Observacao -> Se movimento tipo 450 for gerar um RE5 no SD3, muda para 300
// 480 -> Apontamento de Projetos ( SIGAPMS )
// 500 -> Vendas "SD2"
// 505 -> LOCALIZACOES - Remitos de saida Vendas "SCN"
// 550 -> Devolucoes Vendas do Mes "SD1"
// 555 -> LOCALIZACOES - Devolucao de Vendas do Mes "SCN"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acerta os niveis das estruturas no SG1                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If GetMv("MV_NIVALT") == "S" .And. MV_PAR11 == 2
  If ! MA320Nivel(NIL,mv_par15==1,.F.)
    lRet := XA330Continua()
  Endif
EndIf

If ! lRet
  Return(.F.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega valores do inicio do periodo para serem reprocessados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
YA330Inicia(@cNomTrbU,@cNomTrbU1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa as compras                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD1")
dbSetOrder(6)
dbSeek(xFilial()+dTos(dInicio),.t.)
While !Eof() .And. D1_FILIAL == xFilial() .And. D1_DTDIGIT <= mv_par01
  lEofSD3:=.T.
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Movimentacao do Cursor                                       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  IncProc()
  If D1_ORIGLAN == "LF"
    dbSkip()
    Loop
  Endif
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ LOCALIZACOES - Ignora NF de Entrada com REMITO               ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If cPaisLoc # "BRA"
    If !Empty(D1_REMITO)
      dbSkip()
      Loop
    EndIf
  EndIf
  dbSelectArea("SF4")
  dbSeek(xFilial()+SD1->D1_TES)
  dbSelectArea("SD1")
  If !Empty(D1_OP) .and. SF4->F4_ESTOQUE == "S" .and. !(SF4->F4_PODER3$"RS")
    dbSelectArea("SD3")
    dbSetOrder(4)
    dbSeek(xFilial()+SD1->D1_NUMSEQ)
    While !Eof() .And. SD3->D3_CF # "RE5" .And. SD3->D3_NUMSEQ == SD1->D1_NUMSEQ .And. SD3->D3_COD != SD1->D1_COD .And. SD3->D3_OP != SD1->D1_OP
      dbSkip()
    End
    dbSelectArea("SD1")
    lEofSD3 := IIF(SD1->D1_OP # SD3->D3_OP .Or. SD1->D1_NUMSEQ # SD3->D3_NUMSEQ .Or. SD3->(EOF()),.T.,.F.)
  EndIf
  dbSelectArea("SD1")
  If SF4->F4_ESTOQUE == "S"
    If D1_TIPO != "D"
      If SF4->F4_PODER3 == "D"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava Retorno Beneficiamento ( FORA ).                ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        IF XA330Est(SD1->D1_COD)
          cSeqGrava:=If(!lEofSD3,"300","450")
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ No caso do recalculo diario, verifica se a NF ORIGEM  ³
          //³ e' do mesmo dia que a NF DEVOLUCAO                    ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          If cSeqGrava == "450" .And. mv_par14 == 3 .And. ;
              !Empty(SD1->D1_NFORI+SD1->D1_SERIORI)
            dbSelectArea("SD2")
            aArea:=GetArea()
            dbSetOrder(3)
            If dbSeek(xFilial()+SD1->D1_NFORI+SD1->D1_SERIORI) .And.;
                SD2->D2_EMISSAO != SD1->D1_DTDIGIT
              cSeqGrava:="120"
            EndIf
            RestArea(aArea)
            dbSelectArea("SD1")
          EndIf
          XA330TRB("SD1",cSeqGrava,If(!lEofSD3,SD3->(Recno()),NIL))
          If !lEofSD3
            dbSelectArea("SD3")
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Grava Movimentacoes Internas.                         ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            XA330TRB("SD3",If(!lEofSD3,"300","450"),SD1->(Recno()),TRB->(Recno()))
            dbSelectArea("SD1")
          EndIf
        Else
          XA330TRB("SD1","280",If(!lEofSD3,SD3->(Recno()),NIL))
          If !lEofSD3
            dbSelectArea("SD3")
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Grava Movimentacoes Internas.                         ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            XA330TRB("SD3","280",SD1->(Recno()),TRB->(Recno()))
            dbSelectArea("SD1")
          EndIf
        Endif
      ElseIf SF4->F4_PODER3 == "R"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava Remessa de Beneficiamento ( EU BENEF. ).        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        XA330TRB("SD1","250")
      Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava Notas Fiscais de Compras.                       ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        XA330TRB("SD1",If(!lEofSD3,"120","100"),If(!lEofSD3,SD3->(Recno()),NIL))
        If !lEofSD3
          dbSelectArea("SD3")
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Grava Movimentacoes Internas.                         ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          XA330TRB("SD3","120",SD1->(Recno()),TRB->(Recno()))
          dbSelectArea("SD1")
        EndIf
      EndIf
    Elseif D1_TIPO == "D" .And. !(Xa330Ant(SD1->D1_NFORI,SD1->D1_SERIORI))
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Grava Notas Fiscais de Devolucoes de Compras.         ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      XA330TRB("SD1","550")
    Elseif D1_TIPO == "D" .And. (Xa330Ant(SD1->D1_NFORI,SD1->D1_SERIORI))
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Grava Devolucoes de Vendas Mes Anterior.              ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      XA330TRB("SD1","200")
    EndIf
  EndIf
  dbSelectArea("SD1")
  dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve ordem principal do arquivo                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD1")
dbSetorder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ LOCALIZACOES - Processa os remitos de COMPRAS - SCM          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc # "BRA"
  dbSelectArea("SCM")
  dbSetOrder(8) //Alterado de 7 para 8, Migracao para AP8
  dbSeek(xFilial()+dTos(dInicio),.t.)
  While !Eof() .And. CM_FILIAL == xFilial() .And. CM_EMISSAO <= mv_par01
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Movimentacao do Cursor                                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    IncProc()
    dbSelectArea("SF4")
    dbSeek(xFilial()+SCM->CM_TES)
    dbSelectArea("SCM")
    If SF4->F4_ESTOQUE == "S"
      // Remito de Entrada - Compra
      If CM_TIPOREM # "5"
        XA330TRB("SCM","105")
        // Remito de Saida - Dev. Compra
      Else
        XA330TRB("SCM","155")
      EndIf
    EndIf
    dbSelectArea("SCM")
    dbSkip()
  EndDo
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Devolve ordem principal do arquivo                           ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SCM")
  dbSetorder(1)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa as Vendas, Devolucoes, Beneficiamento               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD2")
dbSetOrder(5)
dbSeek(xFilial()+dTos(dInicio),.t.)
While !EOF() .And. D2_FILIAL == xFilial() .And. D2_EMISSAO <= mv_par01
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Movimentacao do Cursor                                       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  IncProc()
  If D2_ORIGLAN == "LF"
    dbSkip()
    Loop
  Endif
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ LOCALIZACOES - Ignora NF de Saida com REMITO que nao eh de   ³
  //³  consigacao (CN_TIPOREM # "1").                              ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If cPaisLoc # "BRA"
    If !Empty(D2_REMITO)
      SCN->(DbSetOrder(1))
      If SCN->(DbSeek(xFilial()+SD2->D2_REMITO+SD2->D2_ITEMREM)) .And. SCN->CN_TIPOREM <> "1"
        dbSkip()
        Loop
      Endif
    EndIf
  Endif
  dbSelectArea("SF4")
  dbSeek(xFilial()+SD2->D2_TES)
  dbSelectArea("SD2")
  If SF4->F4_ESTOQUE == "S"
    If D2_TIPO != "D"
      If SF4->F4_PODER3 == "R"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava Remessa Beneficiamento ( FORA ).                ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        IF XA330Est(SD2->D2_COD)
          XA330TRB("SD2","400")
        Else
          XA330TRB("SD2","270")
        Endif
      ElseIf SF4->F4_PODER3 == "D"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava Retorno Beneficiamento ( EU BENEF. ).           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        XA330TRB("SD2","290")
      Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava Notas Fiscais Vendas.                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        XA330TRB("SD2","500")
      Endif
    Else
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Grava Notas Fiscais de Dev. Compras                   ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      XA330TRB("SD2","150")
    Endif
  EndIf
  dbSelectArea("SD2")
  dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve ordem principal dos arquivos                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ LOCALIZACOES - Processa os remitos de VENDAS - SCN           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc # "BRA"
  dbSelectArea("SCN")
  dbSetOrder(6)
  dbSeek(xFilial()+dTos(dInicio),.t.)
  While !Eof() .And. CN_FILIAL == xFilial() .And. CN_EMISSAO <= mv_par01
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Movimentacao do Cursor                                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    IncProc()
    dbSelectArea("SF4")
    dbSeek(xFilial()+SCN->CN_TES)
    dbSelectArea("SCN")
    If SF4->F4_ESTOQUE == "S"
      // Remito de Entrada - Dev. Vendas
      If CN_TIPOREM == "5"
        // Dev Mes Anterior
        If XA330RAnt(CN_REMORI,CN_ITEMORI)
          XA330TRB("SCN","205")
          // Dev deste mes
        Else
          XA330TRB("SCN","555")
        EndIf
        // Remito de Saida - Vendas
      Else
        XA330TRB("SCN","505")
      EndIf
    EndIf
    dbSelectArea("SCN")
    dbSkip()
  EndDo
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Devolve ordem principal do arquivo                           ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SCN")
  dbSetorder(1)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa as movimentacoes internas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD3")
dbSetOrder(6)
dbSeek(xFilial()+dTos(dInicio),.t.)
While !EOF() .And. D3_FILIAL == xFilial() .And. D3_EMISSAO  <= mv_par01
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Movimentacao do Cursor                                       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  IncProc()

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Apaga movimentos de estorno                                  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If ( mv_par09 == 1 .And. SD3->D3_ESTORNO == "S" ) .Or. ( lCusFIFO .And. SD3->D3_ESTORNO == "S" )
    XMA330DelD3()
    Loop
  Endif

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Filtra RE5. J  foi processada no while do SD1                ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If SD3->D3_CF $ "RE5/DE5"
    dbSkip()
    Loop
  Endif

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Grava Movimentacoes Internas.                                ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If SD3->D3_CF $ "RE8/DE8" // Integracao com SIGAEIC
    XA330TRB("SD3","100")
  ElseIf !Empty(SD3->D3_PROJPMS)
    XA330TRB("SD3","480")
  ElseIf SD3->D3_CF $ "RE0" .And. Empty(SD3->D3_OP) // Requisicoes p/ Consumo
    XA330TRB("SD3","301")
  Else
    XA330TRB("SD3","300")
  EndIf
  dbSelectArea("SD3")
  dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava os niveis corretos nos arquivos SC2 e TRB              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (SG1->(LastRec())>0) .Or. MV_PAR11 == 1
  If ! XMA330NivCD()
    lRet := .F.
  Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a orden originai do arquivo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD3")
dbSetOrder(1)
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A330TRB  ³ Autor ³Bregantim / Stiefano   ³ Data ³ 15/10/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava arquivo de trabalho por nivel da estrutura           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A330TRB()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XA330TRB(cAlias,cOrdem,nRecRE5,nRecTRB)
Local nRecNo   := 0
Local nQuant   := 0
Local cProduto := ""
Local dData    := ""
Local cChave   := ""
Local cOP      := ""
Local cCF      := ""
Local cSeq     := ""
Local cSeqPro  := Space(Len(TRB->TRB_SEQPRO))
Local dDtOrig  := ""
Local cTES     := ""
Local cTipoNF  := ""
Local cNivel   := "  "
Local cNivSD3  := " "
Local cDoc     := Space(6)
Local nOldRec  := 0
Local cOldOrdem:= cOrdem
Local lSeekTrx := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama ponto de entrada para mudar sequencia do calculo       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lA330Seq
  cOrdem:=ExecBlock("MA330SEQ",.F.,.F.,{cOrdem,cAlias})
  If Valtype(cOrdem) != "C" .Or. Empty(cOrdem)
    cOrdem:=cOldOrdem
  EndIf
EndIf

nRecRE5 := IIF(nRecRE5 == NIL,0,nRecRE5)
nRecTRB := IIF(nRecTRB == NIL,0,nRecTRB)

If cAlias == "SD1"
  nRecNo   := SD1->(RecNo())
  cProduto := SD1->D1_COD
  cLocal   := SD1->D1_LOCAL
  dData    := SD1->D1_DTDIGIT
  cSeq     := SD1->D1_NUMSEQ
  cSeqPro  := IIF(mv_par14==1,SD1->D1_NUMSEQ,cSeqPro)
  dDtOrig  := SD1->D1_DTDIGIT
  nQuant   := SD1->D1_QUANT
  cTES     := SD1->D1_TES
  cDoc     := SD1->D1_DOC
  cChave   := SD1->D1_FORNECE+SD1->D1_DOC+DTOS(dData)+SD1->D1_NUMSEQ
  cTipoNF  := SD1->D1_TIPO
ElseIf cAlias == "SD2"
  nRecNo   := SD2->(RecNo())
  cProduto := SD2->D2_COD
  cLocal   := SD2->D2_LOCAL
  dData    := SD2->D2_EMISSAO
  cSeq     := SD2->D2_NUMSEQ
  cSeqPro  := IIF(mv_par14==1,SD2->D2_NUMSEQ,cSeqPro)
  dDtOrig  := SD2->D2_EMISSAO
  nQuant   := SD2->D2_QUANT
  cTES     := SD2->D2_TES
  cDoc     := SD2->D2_DOC
ElseIf cAlias == "SD3"
  nRecNo   := SD3->(RecNo())
  cProduto := SD3->D3_COD
  cLocal   := SD3->D3_LOCAL
  dData    := SD3->D3_EMISSAO
  IF nRecRE5 > 0
    nOldRec:= SD1->(Recno())
    SD1->(dbGoto(nRecRE5))
    cChave:= SD1->D1_FORNECE+SD1->D1_DOC+DTOS(dData)+SD1->D1_NUMSEQ+"z"
    SD1->(dbGoto(nOldRec))
  Else
    cChave:= SD3->D3_OP+SUBSTR(SD3->D3_CF,2,1)+DTOS(dData)+SD3->D3_NUMSEQ+IIF(D3_CF$"DE4/DE6/DE7","9","0")
  Endif
  cOP      := SD3->D3_OP
  cCF      := SD3->D3_CF
  cSeq     := SD3->D3_NUMSEQ
  cSeqPro  := IIF(mv_par14==1,SD3->D3_NUMSEQ,cSeqPro)
  dDtOrig  := SD3->D3_EMISSAO
  nQuant   := SD3->D3_QUANT
  cDoc     := SD3->D3_DOC
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ No caso das producoes grava arquivo de apontamentos p/ ratear³
  //³ custo no caso de apontamentos em locais diferentes           ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If cCf $ "PR0/PR1"
    If nProdProp == 1
      lSeekTrx := TRX->(dbSeek(IIF(mv_par14!=3,DTOS(mv_par01),DTOS(dData))+cOP+cProduto+cLocal))
      // Caso ja tenha achado apontamento, nao cria registro novo
      Reclock("TRX",!lSeekTrx)
      If !lSeekTrx
        Replace TRX->TRX_DATA    With IIF(mv_par14!=3,mv_par01,dData)
        Replace TRX->TRX_COD     With cProduto
        Replace TRX->TRX_OP      With cOP
        Replace TRX->TRX_LOCAL   With cLocal
      EndIf
      Replace TRX->TRX_QUANT   With TRX->TRX_QUANT + nQuant
      MsUnlock()
    EndIf
  EndIf
ElseIf cAlias == "SCM"
  nRecNo   := SCM->(RecNo())
  cProduto := SCM->CM_PRODUTO
  cLocal   := SCM->CM_LOCAL
  dData    := SCM->CM_EMISSAO
  cSeq     := SCM->CM_NUMSEQ
  cSeqPro  := IIF(mv_par14==1,SCM->CM_NUMSEQ,cSeqPro)
  dDtOrig  := SCM->CM_EMISSAO
  nQuant   := SCM->CM_QUANT
  cTES     := SCM->CM_TES
  cDoc     := SCM->CM_REMITO
  cChave   := SCM->CM_FORNECE+SCM->CM_REMITO+DTOS(dData)+SCM->CM_NUMSEQ
  cTipoNF  := SCM->CM_TIPO
ElseIf cAlias == "SCN"
  nRecNo   := SCN->(RecNo())
  cProduto := SCN->CN_PRODUTO
  cLocal   := SCN->CN_LOCAL
  dData    := SCN->CN_EMISSAO
  cSeq     := SCN->CN_NUMSEQ
  cSeqPro  := IIF(mv_par14==1,SCN->CN_NUMSEQ,cSeqPro)
  dDtOrig  := SCN->CN_EMISSAO
  nQuant   := SCN->CN_QUANT
  cTES     := SCN->CN_TES
  cDoc     := SCN->CN_REMITO
  cChave   := SCN->CN_CLIENTE+SCN->CN_REMITO+DTOS(dData)+SCN->CN_NUMSEQ
  cTipoNF  := SCN->CN_TIPO
EndIf
RecLock("TRB",.T.)
Replace TRB->TRB_ALIAS   With cAlias
Replace TRB->TRB_RECNO   With nRecNo
Replace TRB->TRB_ORDEM   With cOrdem
Replace TRB->TRB_NIVEL   With cNivel
Replace TRB->TRB_NIVSD3  With cNivSD3
Replace TRB->TRB_COD     With cProduto
Replace TRB->TRB_LOCAL   With cLocal
Replace TRB->TRB_DTBASE  With IIF(mv_par14!=3,mv_par01,dData)
Replace TRB->TRB_CHAVE   With cChave
Replace TRB->TRB_OP      With cOP
Replace TRB->TRB_CF      With cCF
Replace TRB->TRB_SEQ     With cSeq
Replace TRB->TRB_SEQPRO  With cSeqPro
Replace TRB->TRB_DTORIG  With dDtOrig
Replace TRB->TRB_RECSD1  With nRecRE5
Replace TRB->TRB_TES     With cTES
Replace TRB->TRB_DOC     With cDoc
Replace TRB->TRB_RECTRB  With nRecTRB
Replace TRB->TRB_TIPONF  With cTipoNF
MsUnlock()
dbSelectArea(cAlias)
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A330Recalc³ Autor ³ Bregantim / Stiefano  ³ Data ³ 15/10/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Recalcula o custo m‚dio                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A330GrvTRB()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XA330Recalc()
LOCAL aCM[nTamArrCus],aCusto[nTamArrCus],aAprInd[nTamArrCus],aAprDir[nTamArrCus],aApropria[nTamArrCus]
LOCAL nX,j,nIndice,cNumSeq,cApropri,lPassou,cIndice,aEnvCus
LOCAL cKey, cFilSD1,cFilSD2,cFilSD3, nIndex,lEofSD3, lOpParcial
LOCAL aApropFF[nTamArrCus],aCustoFF[nTamArrCus],aRet:={},aRetPartes:={},aRetAPAtu:={}
LOCAL aAprdirFF[nTamArrCus],aAprindFF[nTamArrCus],aCMFF[nTamArrCus],aRetPUnit:={}
LOCAL lLct667669 := .F.
LOCAL lMA330C3   := ExistBlock("MA330C3")
LOCAL lM330CD2   := ExistBlock("M330CD2")
LOCAL nLctTotal  := 0
LOCAL nRecOrig   := 0
LOCAL aImpCusto  := {},aBackCusto :={},aNFsCompl  :={{}}
LOCAL cNumSeqOrig:="" ,cSeekSD1:=""
LOCAL cSeekTRX   :="",cWhileTRX:=""
LOCAL nPropPR0   := 1
LOCAL cNumImport :=""
LOCAL cNfAnt   :=""
LOCAL nCountNf :=0,nCountSF8:=0
LOCAL nDec     := Set(3,8)
Local cLocOrig := ""
Local lProcSD2 := .T.
Local cChaveSD3:= ""
Local nRecSD8  := 0
Local lFifoEnt := GetMV("MV_FIFOENT")=="2"
LOCAL nPartes  := Len(aRegraCP)+1

If cPaisLoc # "BRA"
  //Definidas como privates para compatibilidade com a RetCUsent nas saidas por devolucao de compra
  Private nTaxa :=  0
  Private nMoedaNf:=  1
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa pela sequencia FIFO                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusFifo
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³Verifica a sequencia das notas originais e coloca as notas ³
  //³complementares na sequencia, para que o custo seja agregado³
  //³corretamente.                                              ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SD1")
  dbSetOrder(1)
  dbSelectArea("SF8")
  dbSetOrder(1)
  dbSelectArea("TRB")
  dbSetOrder(4)
  dbSeek("SD1")
  cNfAnt:=""
  nCountNf:=0
  While !Eof() .And. TRB->TRB_ALIAS == "SD1"
    If TRB->TRB_TIPONF $ "CIP"
      lSeek:=.F.
      dbSelectArea("SD1")
      dbGoto(TRB->TRB_RECNO)
      If cNfAnt != SD1->D1_DOC+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
        nCountNf:= 0
        cNfAnt  := SD1->D1_DOC+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
      EndIf
      nCountNf++
      cSeekSD1:=xFilial("SD1")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+D1_ITEMORI
      cSeekSF8:=xFilial("SF8")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
      cComplSF8:=SD1->D1_COD
      // Pesquisa no SD1 pela NF Original da NF de despesa
      lSeek:=dbSeek(cSeekSD1)
      If !lSeek
        // Pesquisa no SD1 pela NF de despesa e verifica quais as NFs amarradas
        dbSelectArea("SF8")
        dbSeek(cSeekSF8)
        nCountSF8:=0
        While !Eof() .And. nCountSF8 < nCountNf .And. ;
            F8_FILIAL+F8_NFDIFRE+F8_SEDIFRE+F8_FORNECE+F8_LOJA == cSeekSF8
          cSeekSD1:=xFilial("SD1")+SF8->F8_NFORIG+SF8->F8_SERORIG+SF8->F8_FORNECE+SF8->F8_LOJA+cComplSF8
          lSeek:=SD1->(dbSeek(cSeekSD1))
          If lSeek
            nCountSF8++
          EndIf
          dbSelectArea("SF8")
          dbSkip()
        End
      EndIf
      If lSeek
        If Len(aNFsCompl[Len(aNFsCompl)]) > 4095
          AADD(aNFsCompl,{})
        EndIf
        AADD(aNFsCompl[Len(aNFsCompl)],{TRB->(Recno()),SD1->D1_DTDIGIT,SD1->D1_NUMSEQ})
      EndIf
      dbSelectArea("TRB")
    EndIf
    dbSkip()
  EndDo

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³Verifica a sequencia dos movimentos de importacao          ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SD1")
  dbSetOrder(4)
  dbSelectArea("SD3")
  dbSetOrder(4)
  dbSelectArea("SWN")
  dbSetOrder(2)
  dbSelectArea("TRB")
  dbSetOrder(2)
  dbSeek("SD3")
  Do While !Eof() .And. TRB->TRB_ALIAS == "SD3"
    dbSelectArea("SD3")
    dbGoto(TRB->TRB_RECNO)
    If Substr(SD3->D3_CF,3,1) == "8" .And. QtdComp(SD3->D3_QUANT) == QtdComp(0)
      // Verifica se Utiliza NF de Importacao
      dbSelectArea("SD1")
      If dbSeek(xFilial()+SD3->D3_NUMSEQ) .And. (D1_DTDIGIT >= dInicio .And. D1_DTDIGIT <= mv_par01)
        dbSelectArea("SWN")
        dbSetOrder(2)
        dbSeek(xFilial()+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
        cNumImport:=""
        Do While !Eof() .And. Empty(cNumImport) .And. ;
            WN_FILIAL+WN_DOC+WN_SERIE+WN_FORNECE+WN_LOJA == ;
            xFilial()+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
          If QtdComp(WN_QUANT) == QtdComp(0) .And. ;
              SD3->D3_COD == SWN->WN_PRODUTO .And. ;
              SD1->D1_FORNECE+SD1->D1_LOJA == SWN->WN_FORNECE+SWN->WN_LOJA
            cNumImport:=SWN->WN_HAWB
          EndIf
          dbSkip()
        EndDo
        If !Empty(cNumImport)
          dbSetOrder(3)
          dbSeek(xFilial()+cNumImport)
          Do While !Eof() .And. WN_FILIAL+WN_HAWB == xFilial()+cNumImport
            If QtdComp(WN_QUANT) # QtdComp(0) .And. SD3->D3_COD == SWN->WN_PRODUTO
              dbSelectArea("SD1")
              dbSetOrder(1)
              If dbSeek(xFilial()+SWN->WN_DOC+SWN->WN_SERIE+SWN->WN_FORNECE+SWN->WN_LOJA)
                dbSelectArea("SD3")
                If dbSeek(xFilial()+SD1->D1_NUMSEQ)
                  If Len(aNFsCompl[Len(aNFsCompl)]) > 4095
                    AADD(aNFsCompl,{})
                  EndIf
                  AADD(aNFsCompl[Len(aNFsCompl)],{TRB->(Recno()),SD3->D3_EMISSAO,SD3->D3_NUMSEQ})
                EndIf
              EndIf
            EndIf
            dbSelectArea("SWN")
            dbSkip()
          EndDo
        EndIf
      EndIf
    EndIf
    dbSelectArea("TRB")
    dbSkip()
  EndDo
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³Muda a sequencia para respeitar NFs Originais              ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  For nx:=1 to Len(aNFsCompl)
    For j:=1 to Len(aNFsCompl[nx])
      dbGoto(aNFsCompl[nx,j,1])
      Reclock("TRB",.F.)
      Replace TRB_DTORIG With aNFsCompl[nx,j,2]
      Replace TRB_SEQ With aNFsCompl[nx,j,3]
      MsUnlock()
    Next j
  Next nx

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³Processa arquivo de trabalho pela ordem desejada           ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("TRB")
  dbSetOrder(5)
  dbGotop()

  ProcRegua(RecCount(),16,4)

  While !Eof()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Movimentacao do Cursor                                    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    IncProc(OemToAnsi(STR0015))   //"Processando Arquivo de Transa‡„o"

    If TRB->TRB_ALIAS == "SD1"

      dbSelectArea("SD1")
      dbGoto(TRB->TRB_RECNO)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Posiciona no SB1 para formulas de lancamento contabil        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      dbSelectArea("SB1")
      dbSeek(xFilial()+SD1->D1_COD)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Posiciona no SF4 - TES                                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      dbSelectArea("SF4")
      dbSeek(xFilial()+SD1->D1_TES)
      dbSelectArea("SD1")

      IF SF4->F4_PODER3 == "D"
        If TRB->TRB_RECSD1 > 0
          SD3->(dbGoto(TRB->TRB_RECSD1))
        EndIf
        aRet    := XA330PegaSB6("SD1",.T.,"330")
        aCMFF   := aRet[2]
        aRet    := GravaCusD1(NIL,"D",aCMFF,"330")
        aCustoFF:= aRet[2]
        If TRB->TRB_RECSD1 > 0 .And. mv_par04 == 1
          GravaCusD3(NIL,.T.,aCMFF,"330")
          SD3->(MsUnlock())
        Endif
        dbSelectArea("SD1")

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD1            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        B2FimComD1(NIL,aCustoFF,.T.)
        If lMA330D1
          ExecBlock("MA330D1",.F.,.F.)
        Endif

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o SBD FIFO com os dados do SD1                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        GravaSBD("SD1")

        dbSelectArea("TRB")
        dbSetOrder(5)
        dbSkip()
        Loop
      Endif

      If D1_TIPO != "D"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD1            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        B2FimComD1(NIL,NIL,lCusFIFO)
        If lMA330D1
          ExecBlock("MA330D1",.F.,.F.)
        Endif

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o SBD FIFO com os dados do SD1                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        GravaSBD("SD1")

        IF SF4->F4_PODER3 == "R"
          XA330GravaSB6("SD1",{SD1->D1_CUSTO,SD1->D1_CUSTO2,SD1->D1_CUSTO3,SD1->D1_CUSTO4,SD1->D1_CUSTO5},,.T.)
        Endif

        SD1->(MsUnlock())
      Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega os custos medios finais                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet  := PegaCmDev(.f.,SD1->D1_NFORI,SD1->D1_SERIORI,SD1->D1_COD,SD1->D1_LOCAL,SD1->D1_QUANT,.T.,"330",,.T.)
        aCMFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o custo da nota fiscal de devolucao                    ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet     := GravaCusD1(NIL,SD1->D1_TIPO,aCMFF,"330")
        aCustoFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD1            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        B2FimComD1(NIL,aCustoFF,.T.)
        If lMA330D1
          ExecBlock("MA330D1",.F.,.F.)
        Endif

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o SBD FIFO com os dados do SD1                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        GravaSBD("SD1",aCustoFF,"D")

        IF SF4->F4_PODER3 == "R"
          XA330GravaSB6("SD1",{SD1->D1_CUSTO,SD1->D1_CUSTO2,SD1->D1_CUSTO3,SD1->D1_CUSTO4,SD1->D1_CUSTO5},,.T.)
        Endif

        SD1->(MsUnlock())
      Endif
    ElseIf TRB->TRB_ALIAS == "SCM"

      dbSelectArea("SCM")
      dbGoto(TRB->TRB_RECNO)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Posiciona no SB1 para formulas de lancamento contabil        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      dbSelectArea("SB1")
      dbSeek(xFilial()+SCM->CM_PRODUTO)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Posiciona no SF4 - TES                                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      dbSelectArea("SF4")
      dbSeek(xFilial()+SCM->CM_TES)
      dbSelectArea("SCM")

      If CM_TIPOREM != "5"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD1            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        B2FimComCM(NIL,NIL,lCusFIFO)

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o SBD FIFO com os dados do SD1                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        GravaSBD("SCM")

        SCM->(MsUnlock())
      Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega os custos medios finais                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet  :=  PegaCmDevR(SCM->CM_PRODUTO,SCM->CM_LOCAL,SCM->CM_REMORI,SCM->CM_ITEMORI,;
          SCM->CM_FORNECE,SCM->CM_LOJA ,SCM->CM_QUANT,"330",.T.,"SCM")
        aCMFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o custo da nota fiscal de devolucao                    ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet     := GravaCusCM(NIL,"D",aCMFF,"330")
        aCustoFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD1            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        B2FimComCM(NIL,aCustoFF,.T.)

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o SBD FIFO com os dados do SD1                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        GravaSBD("SCM",aCustoFF,"D")

        SCM->(MsUnlock())
      Endif

    ElseIf TRB->TRB_ALIAS == "SD3"
      dbSelectArea("SD3")
      dbGoto(TRB->TRB_RECNO)
      IF SD3->D3_ESTORNO == "S" .And. mv_par04 == 1
        RecLock("SD3",.F.)
        Replace D3_CUSFF1 With 0
        Replace D3_CUSFF2 With 0
        Replace D3_CUSFF3 With 0
        Replace D3_CUSFF4 With 0
        Replace D3_CUSFF5 With 0
        MsUnlock()
        dbSelectArea("TRB")
        dbSkip()
        Loop
      Endif
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Posiciona no SB1 para formulas de lancamento contabil        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      dbSelectArea("SB1")
      dbSeek(xFilial()+SD3->D3_COD)
      dbSelectArea("SD3")
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Processa as movimentacoes internas                           ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      lPassou := .F.

      AFILL(aCMFF,0)
      AFILL(aCustoFF,0)
      AFILL(aApropFF,0)
      AFILL(aAprIndFF,0)
      AFILL(aAprDirFF,0)

      dbSelectArea("SF5")
      dbSeek(xFilial()+SD3->D3_TM)
      dbSelectArea("SD3")
      If D3_CF $ "PR0/PR1"          // Producoes

        dbSelectArea("SC2")
        If dbSeek(xFilial()+SD3->D3_OP)
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Pega o custo final (VFIM) desta OP                           ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          aRet        := PegaC2Fim("330",.T.)
          aApropFF    := aRet[2]

          RecLock("SC2",.F.)
          Replace C2_VFIMFF1 With 0
          Replace C2_VFIMFF2 With 0
          Replace C2_VFIMFF3 With 0
          Replace C2_VFIMFF4 With 0
          Replace C2_VFIMFF5 With 0
          MsUnlock()
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Atualiza movimento do Pai                                    ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          If mv_par04 == 1
            RecLock("SD3",.F.)
            Replace D3_CUSFF1 With aApropFF[01]
            Replace D3_CUSFF2 With aApropFF[02]
            Replace D3_CUSFF3 With aApropFF[03]
            Replace D3_CUSFF4 With aApropFF[04]
            Replace D3_CUSFF5 With aApropFF[05]
            MsUnlock()
          EndIf
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Atualiza o saldo final (VFIM) com os dados do SD3            ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Nao calcula produtos "MAO DE OBRA"                           ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          If !(Substr(SD3->D3_COD,1,3) == "MOD" .And. Subs(cOpcoes,1,1) == "1")
            B2FimComD3(NIL,NIL,aApropFF,.T.)
            If lMA330D3
              ExecBlock("MA330D3",.F.,.F.)
            Endif
          EndIf

          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Atualiza o SBD FIFO com os dados do SD3                      ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          dbSelectArea("SBD")
          dbSetOrder(3)
          dbSeek(xFilial()+SD3->D3_OP)
          lOpParcial := .F.
          While !Eof() .And. SBD->BD_OP == SD3->D3_OP
            If SBD->BD_DATA > dInicio
              //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              //³ Soma SBD quando producao parcial                       ³
              //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              RecLock("SBD",.F.)
              Replace BD_QFIM With BD_QFIM + SD3->D3_QUANT
              Replace BD_QFIM2UM With BD_QFIM2UM + SD3->D3_QTSEGUM
              MsUnlock()
              dbSelectArea("SD8")
              dbSetOrder(1)
              dbSeek(xFilial()+SBD->BD_PRODUTO+SBD->BD_LOCAL+SBD->BD_SEQ)
              If Found()
                RecLock("SD8",.F.)
                Replace D8_QUANT With D8_QUANT + SD3->D3_QUANT
                MsUnlock()
              Endif
              lOpParcial := .T.
            Endif
            dbSelectArea("SBD")
            dbSkip()
          End
          If !lOpParcial
            GravaSBD("SD3",aApropFF)
          Endif

          dbSelectArea("SC2")
          aCustoFF[01] := aApropFF[01] + C2_APFIFF1
          aCustoFF[02] := aApropFF[02] + C2_APFIFF2
          aCustoFF[03] := aApropFF[03] + C2_APFIFF3
          aCustoFF[04] := aApropFF[04] + C2_APFIFF4
          aCustoFF[05] := aApropFF[05] + C2_APFIFF5
          RecLock("SC2",.F.)
          Replace C2_APFIFF1 With aCustoFF[01]
          Replace C2_APFIFF2 With aCustoFF[02]
          Replace C2_APFIFF3 With aCustoFF[03]
          Replace C2_APFIFF4 With aCustoFF[04]
          Replace C2_APFIFF5 With aCustoFF[05]
          MsUnlock()
        Else
          Help(" ",1,"A650NOP",,SD3->D3_OP,02,01)
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Zera os valores dos arrays para novo lote de movimentos      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        AFILL(aCMFF,0)
        AFILL(aCustoFF,0)
        AFILL(aApropFF,0)
      ElseIf SubStr(D3_CF,3,1) == "4" // Transferencias
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega os custos medios finais                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Na Funcao () Esta Tratando CUSTO FIFO                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet  := PegaCMFim(D3_COD,D3_LOCAL,,,"SD3","330",,.T.)
        aCMFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o custo da movimentacao                                ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If mv_par04 == 1
          aRet     := GravaCusD3(NIL,,aCMFF,"330")
          aCustoFF := aRet[2]
          SD3->(MsUnlock())
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD3            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Nao calcula produtos "MAO DE OBRA"                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !(Substr(SD3->D3_COD,1,3) == "MOD" .And. Subs(cOpcoes,1,1) == "1")
          B2FimComD3(NIL,NIL,aCustoFF,.T.)
          If lMA330D3
            ExecBlock("MA330D3",.F.,.F.)
          Endif
        EndIf
            cChaveSD3   := SD3->(D3_COD+D3_TM+D3_CF+D3_LOCAL+D3_OP)
        // Verificar este SKIP
        dbSelectArea("TRB")
        nRecOrig:=Recno()
        dbSkip()
        dbSelectArea("SD3")
        dbGoto(TRB->TRB_RECNO)

        If SubStr(D3_CF,3,1) == "4" // Transferencias
          dbSelectArea("SB2")
          dbSeek(xFilial()+SD3->D3_COD+SD3->D3_LOCAL)
          If EOF()
            CriaSB2(SD3->D3_COD,SD3->D3_LOCAL)
          EndIf
          RecLock("SB2",.F.)
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Grava o custo da movimentacao                                ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          If mv_par04 == 1
            aRet     := GravaCusD3(NIL,,aCMFF,"330")
            aCustoFF := aRet[2]
            SD3->(MsUnlock())
          EndIf
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Atualiza o SBD FIFO com os dados do SD3                      ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

          //Se for diferente de brasil, vou gravar a entrada FIFO com as mesmas
          //quantidade e custos dos lotes de saida. E precisso  que o numero de
          //documento seja obrigatorio para poder ligar o parametro MV_FIFOENT com "2"
          //Bruno (Rodrigo está estudando um melhor solucao)

               If cPaisLoc <> "BRA" .And. lFifoEnt
            //MV_FIFOENT == 1 . e pelo total
            //MV_FIFOENT == 2 . e por lote
            SD8->(DbSetorder(3))
                 SD8->(DbSeek(xFilial()+SD3->D3_DOC+Space(TamSX3("D8_SERIE")[1])+SD3->D3_ITEM))
                 While !SD8->(EOF()) .And. SD3->D3_DOC+Space(TamSX3("D8_SERIE")[1])+SD3->D3_ITEM==;
                    SD8->D8_DOC+SD8->D8_SERIE+SD8->D8_ITEM .And. SD8->(xFilial()) == SD8->D8_FILIAL

                    If SD8->(D8_PRODUTO+D8_TM+D8_CF+D8_LOCAL+D8_OP+D8_TIPONF)==cChaveSD3+"N";
                          .And.SD8->D8_DATA ==SD3->D3_EMISSAO .And. SD8->D8_DTCALC==mv_par01
                nRecSD8 :=  SD8->(Recno())
                       GravaSBD("SD3",SD8->({D8_CUSTO1,D8_CUSTO2,D8_CUSTO3,D8_CUSTO4,D8_CUSTO5}),,SD8->D8_QUANT,SD8->D8_QT2UM)
                SD8->(dbGoTo(nRecSD8))
                    Endif
                    SD8->(DbSkip())
                 Enddo
          Else
            GravaSBD("SD3",aCustoFF)
          Endif
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Atualiza o saldo final (VFIM) com os dados do SD3            ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Nao calcula produtos "MAO DE OBRA"                           ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          If !(Substr(SD3->D3_COD,1,3) == "MOD" .And. Subs(cOpcoes,1,1) == "1")
            B2FimComD3(NIL,NIL,aCustoFF,.T.)
            If lMA330D3
              ExecBlock("MA330D3",.F.,.F.)
            Endif
          EndIf
          MsUnlock()
        Else
          dbSelectArea("TRB")
          dbGoto(nRecOrig)
        EndIf
      ElseIf D3_CF == "RE7"      // Transferencias Multiplas
        XA330ProcRE7(.T.)
      ElseIf D3_CF != "DE7"      // RE0,1,2,3 e suas DE's respectivas
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³     Pega o tipo de apropriacao do material                   ³
        //³==============================================================³
        //³ 0 = Requisicao Manual de material Direto                     ³
        //³ 1 = Requisicao Automatica de material Direto                 ³
        //³ 2 = Requisicao Automatica de material Indireto               ³
        //³ 3 = Requisicao Manual de material Indireto                   ³
        //³ 4 = Transferencias em geral                                  ³
        //³ 5 = Apropriacao direta de entrada na Op                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        cApropri := SubStr(D3_CF,3,1)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega os custos medios finais                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !(cApropri $ "568")
          aRet      := PegaCMFim(D3_COD,D3_LOCAL,,,"SD3","330",,.T.)
          aCMFF     := aRet[2]
          If mv_par04 == 1
            aRet      := GravaCusD3(NIL,,aCMFF,"330")
            aCustoFF  := aRet[2]
            dbSelectArea("SD3")
            SD3->(MsUnlock())
          EndIf
        Else
          aCMFF     := {D3_CUSTO1,D3_CUSTO2,D3_CUSTO3,D3_CUSTO4,D3_CUSTO5}
          aCustoFF  := aCMFF
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Atualiza o SBD FIFO com os dados do SD3                      ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          If SD3->D3_CF $ "DE6/DE8"
            GravaSBD("SD3",aCustoFF)
          Else
            aCMFF:=BaixaSBD("SD3",,TRB->TRB_RECTRB > 0)
            For i:=1 to 5
              aCustoFF[i]:=aCMFF[1,i]
            Next i
          Endif
          dbSelectArea("SD3")
          RecLock("SD3",.F.)
          Replace D3_CUSFF1 With aCustoFF[01]
          Replace D3_CUSFF2 With aCustoFF[02]
          Replace D3_CUSFF3 With aCustoFF[03]
          Replace D3_CUSFF4 With aCustoFF[04]
          Replace D3_CUSFF5 With aCustoFF[05]
          SD3->(MsUnlock())
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD3            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Nao calcula produtos "MAO DE OBRA"                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !(Substr(SD3->D3_COD,1,3) == "MOD" .And. Subs(cOpcoes,1,1) == "1")
          B2FimComD3(NIL,NIL,aCustoFF,.T.)
          If lMA330D3
            ExecBlock("MA330D3",.F.,.F.)
          Endif
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica se o movimento e' referente a requisicao manual     ³
        //³ de material indireto para atualizar o saldo final (VFIM)     ³
        //³ do processo com os dados do SD3                              ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If cApropri == "3"
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Atualiza o saldo final (VFIM) com os dados do SD3            ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Nao calcula produtos "MAO DE OBRA"                           ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          If !(Substr(SD3->D3_COD,1,3) == "MOD" .And. Subs(cOpcoes,1,1) == "1")
            B2FimComD3(NIL,GetMv("MV_LOCPROC"),aCustoFF,.T.)
            If lMA330D3
              ExecBlock("MA330D3",.F.,.F.)
            Endif
          EndIf
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza os saldos finais (VFIM) das OP's                    ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !Empty(SD3->D3_OP)
          If SC2->(dbSeek(xFilial("SC2")+SD3->D3_OP))
            C2FimComD3(NIL,aCustoFF,.T.)
          Else
            Help(" ",1,"A650NOP",,SD3->D3_OP,02,01)
          EndIf
        EndIf
        dbSelectArea("SD3")
        If D3_TM <= "500"
          If cApropri == "2"
            For nX := 1 To nTamArrCus
              aAprIndFF[nX] := aAprIndFF[nX] - aCustoFF[nX]
            Next nX
          ElseIf cApropri != "3"
            For nX := 1 To nTamArrCus
              aAprDirFF[nX] := aAprDirFF[nX] - aCustoFF[nX]
            Next nX
          EndIf
        Else
          If cApropri == "2"
            For nX := 1 To nTamArrCus
              aAprIndFF[nX] := aAprIndFF[nX] + aCustoFF[nX]
            Next nX
          ElseIf cApropri != "3"
            For nX := 1 To nTamArrCus
              aAprDirFF[nX] := aAprDirFF[nX] + aCustoFF[nX]
            Next nX
          EndIf
        EndIf
      Endif

    ElseIf TRB->TRB_ALIAS == "SD2"

      dbSelectArea("SD2")
      dbGoto(TRB->TRB_RECNO)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Posiciona no SB1 para formulas de lancamento contabil        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      dbSelectArea("SB1")
      dbSeek(xFilial()+SD2->D2_COD)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Posiciona no SF4 - TES                                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      dbSelectArea("SF4")
      dbSeek(xFilial()+SD2->D2_TES)
      dbSelectArea("SD2")

      If SF4->F4_PODER3 == "D"
        aRet    := XA330PegaSB6("SD2",.T.,"330")
        aCMFF   := aRet[2]
        If lM330CD2
          aBackCusto :=ACLONE(aCMFF)
          aCMFF:=ExecBlock("M330CD2",.F.,.F.,{aCMFF,.T.})
          If Valtype(aCMFF) != "A"
            aCMFF:=ACLONE(aBackCusto)
          EndIf
        EndIf
        aRet    := GravaCusD2(NIL,"N",aCMFF,"330")   // para forcar a gravacao
        aCustoFF:= aRet[2]
        B2FimComD2(NIL,aCustoFF,lCusFIFO)
        SD2->(MsUnlock())
        dbSelectArea("TRB")
        dbSetOrder(5)
        dbSkip()
        Loop
      Endif

      If SD2->D2_TIPO != "D"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Processa as vendas                                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aEnvCus := XA330EnvCus()

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega os custos medios finais                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet  := PegaCMFim(SD2->D2_COD,SD2->D2_LOCAL,SD2->D2_TIPO,aEnvCus,"SD2","330",,.T.)
        aCMFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o custo da nota fiscal de saida                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If lM330CD2
          aBackCusto :=ACLONE(aCMFF)
          aCMFF:=ExecBlock("M330CD2",.F.,.F.,{aCMFF,.T.})
          If Valtype(aCMFF) != "A"
            aCMFF:=ACLONE(aBackCusto)
          EndIf
        EndIf
        aRet     := GravaCusD2(NIL,SD2->D2_TIPO,aCMFF,"330")
        aCustoFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD2            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        B2FimComD2(NIL,aCustoFF,.T.)

        If lMA330D2
          ExecBlock("MA330D2",.F.,.F.)
        Endif

        IF SF4->F4_PODER3 == "R"
          XA330GravaSB6("SD2",NIL,aCustoFF,.T.)
        Endif


        SD2->(MsUnlock())
      Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Processa as devolucoes de compra                             ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aEnvCus := XA330EnvCus()

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega os custos medios finais                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Na Funcao PegaCMFim() Esta Tratando CUSTO FIFO               ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet  := PegaCMFim(SD2->D2_COD,SD2->D2_LOCAL,SD2->D2_TIPO,aEnvCus,"SD2","330",.T.,.T.)
        aCMFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o custo da nota fiscal de saida                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If lM330CD2
          aBackCusto :=ACLONE(aCMFF)
          aCMFF:=ExecBlock("M330CD2",.F.,.F.,{aCMFF,.T.})
          If Valtype(aCMFF) != "A"
            aCMFF:=ACLONE(aBackCusto)
          EndIf
        EndIf
        aRet     := GravaCusD2(NIL,SD2->D2_TIPO,aCMFF,"330")
        aCustoFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD2            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        B2FimComD2(NIL,aCustoFF,.T.)

        If lMA330D2
          ExecBlock("MA330D2",.F.,.F.)
        Endif

        IF SF4->F4_PODER3 == "R"
          XA330GravaSB6("SD2",NIL,aCustoFF,.T.)
        Endif

        SD2->(MsUnlock())
      Endif
    ElseIf TRB->TRB_ALIAS == "SCN"

      dbSelectArea("SCN")
      dbGoto(TRB->TRB_RECNO)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Posiciona no SB1 para formulas de lancamento contabil        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      dbSelectArea("SB1")
      dbSeek(xFilial()+SCN->CN_PRODUTO)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Posiciona no SF4 - TES                                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      dbSelectArea("SF4")
      dbSeek(xFilial()+SCN->CN_TES)
      dbSelectArea("SCN")

      If SCN->CN_TIPOREM # "5"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega os custos medios finais                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet  := PegaCMFim(SCN->CN_PRODUTO,SCN->CN_LOCAL,NIL,,"SCN","330",,.T.)
        aCMFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o custo da nota fiscal de saida                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet     := GravaCusCN(NIL,NIL,aCMFF,"330")
        aCustoFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD2            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        B2FimComCN(NIL,aCustoFF,.T.)

        SCN->(MsUnlock())
      Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega os custos medios finais                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Na Funcao PegaCMFim() Esta Tratando CUSTO FIFO               ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet  := PegaCMFim(SCN->CN_PRODUTO,SCN->CN_LOCAL,"D",NIL,"SCN","330",.T.,.T.)
        aCMFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o custo da nota fiscal de saida                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet     := GravaCusCN(NIL,"D",aCMFF,"330")
        aCustoFF := aRet[2]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD2            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        B2FimComCN(NIL,aCustoFF,.T.)

        SCN->(MsUnlock())

      Endif
    Endif
    dbSelectArea("TRB")
    dbSetOrder(5)
    dbSkip()
  End
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa pela sequencia CUSTO MEDIO                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbSetOrder(3)
dbGotop()

ProcRegua(RecCount(),16,4)

While !Eof()

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Movimentacao do Cursor                                    ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  IncProc(OemToAnsi(STR0015))   //"Processando Arquivo de Transa‡„o"

  If TRB->TRB_ALIAS == "SD1"

    dbSelectArea("SD1")
    dbGoto(TRB->TRB_RECNO)
    XGravaSeq("SD1")
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Posiciona no SB1 para formulas de lancamento contabil        ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea("SB1")
    dbSeek(xFilial()+SD1->D1_COD)
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Posiciona no SF4 - TES                                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea("SF4")
    dbSeek(xFilial()+SD1->D1_TES)
    dbSelectArea("SD1")

    IF SF4->F4_PODER3 == "D"
      If TRB->TRB_RECSD1 > 0
        SD3->(dbGoto(TRB->TRB_RECSD1))
        If mv_par04 == 1
          XGravaSeq("SD3")
        EndIf
      EndIf
      aRet       := XA330PegaSB6("SD1",.F.,"330",lCstPart,nPartes)
      aCM        := ACLONE(aRet[1])
      aRetPartes := ACLONE(aRet[3])
      aRet       := GravaCusD1(aCm,"D",NIL,"330",lCstPart,NIL,ACLONE(aRetPartes),1)
      aCusto     := ACLONE(aRet[1])
      aRetPartes := ACLONE(aRet[3])
      If TRB->TRB_RECSD1 > 0 .And. mv_par04 == 1
        aRet:=GravaCusD3(aCM,.T.,NIL,"330")
        SD3->(MsUnlock())
      Endif
      dbSelectArea("SD1")

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualiza o saldo final (VFIM) com os dados do SD1            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      B2FimComD1(aCusto,NIL,NIL,lCstPart,aRetPartes)
      XTTFimD1(aCusto,ACLONE(aRetPartes))
      If lMA330D1
        ExecBlock("MA330D1",.F.,.F.)
      Endif

      dbSelectArea("TRB")
      dbSetOrder(3)
      dbSkip()
      Loop
    Endif

    If D1_TIPO != "D"
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Grava o custo em partes no arquivo de movimento              ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      aRetPartes:=GravaCusCP(lCstPart,aRegraCP,{SD1->D1_CUSTO,SD1->D1_CUSTO2,SD1->D1_CUSTO3,SD1->D1_CUSTO4,SD1->D1_CUSTO5},"SD1",SD1->D1_COD,NIL,SD1->D1_QUANT)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualiza o saldo final (VFIM) com os dados do SD1            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      B2FimComD1(NIL,NIL,NIL,lCstPart,aRetPartes)
      XTTFimD1(NIL,ACLONE(aRetPartes))
      If lMA330D1
        ExecBlock("MA330D1",.F.,.F.)
      Endif

      IF SF4->F4_PODER3 == "R"
        XA330GravaSB6("SD1",{SD1->D1_CUSTO,SD1->D1_CUSTO2,SD1->D1_CUSTO3,SD1->D1_CUSTO4,SD1->D1_CUSTO5},NIL,NIL,lCstPart,aRegraCP,ACLONE(aRetPartes))
      Endif

      SD1->(MsUnlock())
    Else
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Pega os custos medios finais                                 ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      aRet      := PegaCmDev(.f.,SD1->D1_NFORI,SD1->D1_SERIORI,SD1->D1_COD,SD1->D1_LOCAL,SD1->D1_QUANT,.T.,"330",NIL,NIL,lCusUnif,lCstPart,nPartes)
      aCM       := ACLONE(aRet[1])
      aRetPartes:= ACLONE(aRet[3])
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Grava o custo da nota fiscal de devolucao                    ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      aRet      := GravaCusD1(aCM,SD1->D1_TIPO,NIL,"330",lCstPart,NIL,ACLONE(aRetPartes),SD1->D1_QUANT)
      aCusto    := ACLONE(aRet[1])
      aRetPartes:= ACLONE(aRet[3])
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualiza o saldo final (VFIM) com os dados do SD1            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      B2FimComD1(aCusto,NIL,NIL,lCstPart,aRetPartes)
      XTTFimD1(aCusto,ACLONE(aRetPartes))
      If lMA330D1
        ExecBlock("MA330D1",.F.,.F.)
      Endif

      IF SF4->F4_PODER3 == "R"
        XA330GravaSB6("SD1",{SD1->D1_CUSTO,SD1->D1_CUSTO2,SD1->D1_CUSTO3,SD1->D1_CUSTO4,SD1->D1_CUSTO5},NIL,NIL,lCstPart,aRegraCP,NIL)
      Endif

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Gera o lancamento no arquivo de prova                        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      nTotal+=XA330DET(nHdlPrv,"641","MATA330",cLoteEst,"SD1")

      SD1->(MsUnlock())
    Endif

  ElseIf TRB->TRB_ALIAS == "SCM"
    dbSelectArea("SCM")
    dbGoto(TRB->TRB_RECNO)
    XGravaSeq("SCM")
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Posiciona no SB1 para formulas de lancamento contabil        ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea("SB1")
    dbSeek(xFilial()+SCM->CM_PRODUTO)
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Posiciona no SF4 - TES                                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea("SF4")
    dbSeek(xFilial()+SCM->CM_TES)
    dbSelectArea("SCM")

    // Remito de Entrada
    If CM_TIPOREM # "5"
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualiza o saldo final (VFIM) com os dados do SCM            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      B2FimComCM()
      XTTFimCM()
      // Remito de Saida
    Else
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Processa as devolucoes de compra                             ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Pega os custos medios da entrada do iten devolvido           ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      aRet  := PegaCmDevR(SCM->CM_PRODUTO,SCM->CM_LOCAL,SCM->CM_REMORI,SCM->CM_ITEMORI,;
        SCM->CM_FORNECE,SCM->CM_LOJA ,SCM->CM_QUANT,"330",.F.,"SCM")
      If lCusUnif
        aRet  := XA330TTFim(SCM->CM_PRODUTO,SCM->CM_LOCAL,"D",NIL,"SCM","330",.T.)
      EndIf
      aCM   := ACLONE(aRet[1])
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Grava o custo do Remito de dev. compra                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      aRet     := GravaCusCM(aCM,"D",NIL,"330")
      aCusto   := ACLONE(aRet[1])
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualiza o saldo final (VFIM) com os dados do SCM            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      B2FimComCM(aCusto)
      XTTFimCM(aCusto)
    EndIf
  ElseIf TRB->TRB_ALIAS == "SD3"
    dbSelectArea("SD3")
    dbGoto(TRB->TRB_RECNO)
    If mv_par04 == 1
      XGravaSeq("SD3")
    EndIf
    IF SD3->D3_ESTORNO == "S" .And. mv_par04 == 1
      RecLock("SD3",.F.)
      Replace D3_CUSTO1 With 0
      Replace D3_CUSTO2 With 0
      Replace D3_CUSTO3 With 0
      Replace D3_CUSTO4 With 0
      Replace D3_CUSTO5 With 0
      MsUnlock()
      dbSelectArea("TRB")
      dbSkip()
      Loop
    Endif
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Posiciona no SB1 para formulas de lancamento contabil        ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea("SB1")
    dbSeek(xFilial()+SD3->D3_COD)
    dbSelectArea("SD3")
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Processa as movimentacoes internas                           ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    lPassou := .F.
    AFILL(aCM,0)
    AFILL(aCusto,0)
    AFILL(aApropria,0)
    AFILL(aAprInd,0)
    AFILL(aAprDir,0)
    dbSelectArea("SF5")
    dbSeek(xFilial()+SD3->D3_TM)
    dbSelectArea("SD3")
    If D3_CF $ "PR0/PR1"          // Producoes
      dbSelectArea("SC2")
      If dbSeek(xFilial()+SD3->D3_OP)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega o custo final (VFIM) desta OP                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet        := PegaC2Fim("330",.F.,lCstPart,nPartes)
        aApropria   := ACLONE(aRet[1])
        If nProdProp == 1
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Proporcionaliza custo do apontamento.                        ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          dbSelectArea("TRX")
          dbSeek(DTOS(TRB->TRB_DTBASE)+TRB->TRB_OP+TRB->TRB_COD+TRB->TRB_LOCAL)
          nPropPR0 := SD3->D3_QUANT/(TRX->TRX_TOTAL-TRX->TRX_QTDPRC)
          cSeekTRX:=DTOS(TRB->TRB_DTBASE)+TRB->TRB_OP+TRB->TRB_COD
          cWhileTRX:="DTOS(TRX_DATA)+TRX_OP+TRX_COD"
          dbSeek(cSeekTRX)
          While !Eof() .And. cSeekTRX == &(cWhileTRX)
            Reclock("TRX",.F.)
            Replace TRX_QTDPRC With TRX_QTDPRC + SD3->D3_QUANT
            MsUnlock()
            dbSkip()
          End
        ElseIf ((nProdProp == 2 .And. SD3->D3_RATEIO > 0) .Or. nProdProp == 3)
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Verifica valorizacao do apontamento quando todos componentes ³
          //³ ja foram requisitados                                        ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          If QtdComp(SC2->C2_APRFIM1) > QtdComp(0)
            nPropPR0 := 1-(SC2->C2_APRFIM1/(aApropria[1]+SC2->C2_APRFIM1))
            nPropPR0 := If(nProdProp==2,SD3->D3_RATEIO/100,SD3->D3_QUANT / SC2->C2_QUANT) / nPropPR0
          Else
            nPropPR0 := If(nProdProp==2,SD3->D3_RATEIO/100,SD3->D3_QUANT / SC2->C2_QUANT)
          EndIf
          nPropPR0 := Min(1,nPropPR0)
        EndIf
        For nx:=1 to Len(aApropria)
          aApropria[nx]:=aApropria[nx]*nPropPR0
        Next nx

        RecLock("SC2",.F.)
        Replace C2_VFIM1 With C2_VFIM1 - aApropria[01]
        Replace C2_VFIM2 With C2_VFIM2 - aApropria[02]
        Replace C2_VFIM3 With C2_VFIM3 - aApropria[03]
        Replace C2_VFIM4 With C2_VFIM4 - aApropria[04]
        Replace C2_VFIM5 With C2_VFIM5 - aApropria[05]
        MsUnlock()

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega o custo final em partes desta OP                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRetPartes:=PegaC2PFim(lCstPart,nPartes)
          For nx:=1 to Len(aRetPartes)
          aRetPartes[nx]:=aRetPartes[nx]*nPropPR0
          Next nx

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o custo final em partes desta OP                    ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              GravaC2CPF(aRetPartes)

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza movimento do Pai                                    ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If mv_par04 == 1
          Reclock("SD3",.F.)
          Replace D3_CUSTO1 With aApropria[1]
          Replace D3_CUSTO2 With aApropria[2]
          Replace D3_CUSTO3 With aApropria[3]
          Replace D3_CUSTO4 With aApropria[4]
          Replace D3_CUSTO5 With aApropria[5]
          MsUnlock()
          //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
          //³ Grava o custo em partes no arquivo de movimento              ³
          //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          aRetPartes:=GravaCusCP(lCstPart,aRegraCP,NIL,"SD3",SD3->D3_COD,aRetPartes,1)
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD3            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Nao calcula produtos "MAO DE OBRA"                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !(Substr(SD3->D3_COD,1,3) == "MOD" .And. Subs(cOpcoes,1,1) == "1")
          B2FimComD3(aApropria,NIL,NIL,NIL,lCusUnif,lCstPart,aRetPartes)
          XTTFimD3(aApropria,ACLONE(aRetPartes))
          If lMA330D3
            ExecBlock("MA330D3",.F.,.F.)
          Endif
        EndIf

        dbSelectArea("SC2")
        aCusto[01] := aApropria[01] + C2_APRFIM1
        aCusto[02] := aApropria[02] + C2_APRFIM2
        aCusto[03] := aApropria[03] + C2_APRFIM3
        aCusto[04] := aApropria[04] + C2_APRFIM4
        aCusto[05] := aApropria[05] + C2_APRFIM5
        RecLock("SC2",.F.)
        Replace C2_APRFIM1 With aCusto[01]
        Replace C2_APRFIM2 With aCusto[02]
        Replace C2_APRFIM3 With aCusto[03]
        Replace C2_APRFIM4 With aCusto[04]
        Replace C2_APRFIM5 With aCusto[05]
        MsUnlock()

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega o custo final em partes desta OP                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRetAPAtu:=PegaC2PFim(lCstPart,nPartes)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o custo apropriado final em partes desta OP         ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            For nx:=1 to Len(aRetPartes)
          aRetPartes[nx]:=aRetPartes[nx]+aRetAPAtu[nx]
          Next nx
            GravaC2APF(aRetPartes)

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Gera o lancamento no arquivo de prova                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        nTotal+=XA330DET(nHdlPrv,"668","MATA330",cLoteEst)
      Else
        Help(" ",1,"A650NOP",,SD3->D3_OP,02,01)
      EndIf
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Zera os valores dos arrays para novo lote de movimentos      ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      AFILL(aCM,0)
      AFILL(aCusto,0)
      AFILL(aApropria,0)
      AFILL(aAprInd,0)
    ElseIf SubStr(D3_CF,3,1) == "4" // Transferencias
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Pega os custos medios finais                                 ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Na Funcao PegaCMFim() Esta Tratando CUSTO FIFO               ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³Quando a entrada foi gerada por um remito de consignación, vou pegar ³
      //³o custo de saida do almoxarifado de origem. Bruno                    ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      aRet  :=  NIL
      If cPaisLoc <> "BRA" .And. D3_CF == "DE4" .And. D3_TM == "499" .And. !Empty(D3_DOC) .And. !Empty(D3_ITEM)
        SCN->(DbSetOrder(1))
        If SCN->(DbSeek(xFilial()+SD3->D3_DOC+SD3->D3_ITEM)) .And. SCN->CN_TIPOREM == "1"
          aRet  :={{SCN->CN_CUSTO1/SCN->CN_QUANT,SCN->CN_CUSTO2/SCN->CN_QUANT,SCN->CN_CUSTO3/SCN->CN_QUANT,SCN->CN_CUSTO4/SCN->CN_QUANT,SCN->CN_CUSTO5/SCN->CN_QUANT}}
        Endif
      Endif
      If aRet ==  NIL
        aRet  := PegaCMFim(D3_COD,D3_LOCAL,,,"SD3","330",NIL,NIL,lCstPart,nPartes)
        If lCusUnif
          aRet  := XA330TTFim(D3_COD,D3_LOCAL,,,"SD3","330",NIL,NIL,lCstPart,nPartes)
        EndIf
      EndIf
      aCM:=ACLONE(aRet[1])
        aRetPUnit:=ACLONE(aRet[3])
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Grava o custo da movimentacao                                ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If mv_par04 == 1
        aRet      := GravaCusD3(aCM,NIL,NIL,"330",NIL,lCstPart,aRegraCP,ACLONE(aRet[3]))
        aCusto    := ACLONE(aRet[1])
        aRetPartes:= ACLONE(aRet[3])
        SD3->(MsUnlock())
      EndIf
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualiza o saldo final (VFIM) com os dados do SD3            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Nao calcula produtos "MAO DE OBRA"                           ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If !(Substr(SD3->D3_COD,1,3) == "MOD" .And. Subs(cOpcoes,1,1) == "1")
        B2FimComD3(aCusto,NIL,NIL,NIL,lCusUnif,lCstPart,aRetPartes)
        XTTFimD3(aCusto,ACLONE(aRetPartes))
        If lMA330D3
          ExecBlock("MA330D3",.F.,.F.)
        Endif
      EndIf
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Gera o lancamento no arquivo de prova                        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      nTotal+=XA330DET(nHdlPrv,"670","MATA330",cLoteEst)

      // Verificar este SKIP
      dbSelectArea("TRB")
      nRecOrig:=Recno()
      cNumSeqOrig:=TRB_SEQ
      dbSkip()
      dbSelectArea("SD3")
      dbGoto(TRB->TRB_RECNO)

      If SubStr(D3_CF,3,1) == "4" .And. D3_NUMSEQ == cNumSeqOrig // Transferencias
        If mv_par04 == 1
          XGravaSeq("SD3")
        EndIf
        dbSelectArea("SB2")
        dbSeek(xFilial()+SD3->D3_COD+SD3->D3_LOCAL)
        If EOF()
          CriaSB2(SD3->D3_COD,SD3->D3_LOCAL)
        EndIf
        RecLock("SB2",.F.)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o custo da movimentacao                                ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If mv_par04 == 1
          aRet      := GravaCusD3(aCM,NIL,NIL,"330",NIL,lCstPart,aRegraCP,ACLONE(aRetPUnit))
          aCusto    := ACLONE(aRet[1])
          aRetPartes:= ACLONE(aRet[3])
          SD3->(MsUnlock())
        EndIf

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD3            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Nao calcula produtos "MAO DE OBRA"                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !(Substr(SD3->D3_COD,1,3) == "MOD" .And. Subs(cOpcoes,1,1) == "1")
          B2FimComD3(aCusto,NIL,NIL,NIL,lCusUnif,lCstPart,aRetPartes)
          XTTFimD3(aCusto,ACLONE(aRetPartes))
          If lMA330D3
            ExecBlock("MA330D3",.F.,.F.)
          Endif
        EndIf
        MsUnlock()
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Gera o lancamento no arquivo de prova                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        nTotal+=XA330DET(nHdlPrv,"672","MATA330",cLoteEst)
      Else
        dbSelectArea("TRB")
        dbGoto(nRecOrig)
      EndIf
    ElseIf D3_CF == "RE7"      // Transferencias Multiplas
      XA330ProcRE7(.F.,lCstPart,aRegraCP)
    ElseIf D3_CF != "DE7"      // RE0,1,2,3 e suas DE's respectivas
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³     Pega o tipo de apropriacao do material                   ³
      //³==============================================================³
      //³ 0 = Requisicao Manual de material Direto                     ³
      //³ 1 = Requisicao Automatica de material Direto                 ³
      //³ 2 = Requisicao Automatica de material Indireto               ³
      //³ 3 = Requisicao Manual de material Indireto                   ³
      //³ 4 = Transferencias em geral                                  ³
      //³ 5 = Apropriacao direta de entrada na Op                      ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      cApropri := SubStr(D3_CF,3,1)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Gera o lancamento no arquivo de prova                        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      lLct667669 := .F.
      If SubStr(SD3->D3_CF,3,1) != "2"
        nLctTotal := nTotal
        If SD3->D3_TM <= "500"
          nTotal+=XA330DET(nHdlPrv,"669","MATA330",cLoteEst)
        Else
          nTotal+=XA330DET(nHdlPrv,"667","MATA330",cLoteEst)
        EndIf
        If ( nLctTotal != nTotal )
          lLct667669 := .T.
        EndIf
      EndIf
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Pega os custos medios finais                                 ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If !(cApropri $ "568")
        aRet      := PegaCMFim(D3_COD,D3_LOCAL,,,"SD3","330",NIL,NIL,lCstPart,nPartes)
        If lCusUnif
          aRet      := XA330TTFim(D3_COD,D3_LOCAL,,,"SD3","330",NIL,NIL,lCstPart,nPartes)
        EndIf
        aCM       := ACLONE(aRet[1])
        aRetPartes:= ACLONE(aRet[3])
        If mv_par04 == 1
          aRet      := GravaCusD3(aCM,NIL,NIL,"330",NIL,lCstPart,aRegraCP,ACLONE(aRetPartes))
          aCusto    := ACLONE(aRet[1])
          aRetPartes:= ACLONE(aRet[3])
          dbSelectArea("SD3")
          SD3->(MsUnlock())
        EndIf
      Else
        aCM    := {D3_CUSTO1,D3_CUSTO2,D3_CUSTO3,D3_CUSTO4,D3_CUSTO5}
        aCusto := ACLONE(aCM)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o custo em partes no arquivo de movimento              ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRetPartes:=GravaCusCP(lCstPart,aRegraCP,aCM,"SD3",SD3->D3_COD,NIL,SD3->D3_QUANT)
      EndIf

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Executa P.E. para alterar valor do array com o custo medio   ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If lMA330C3
        aBackCusto :=ACLONE(aCusto)
        aCusto:=ExecBlock("MA330C3",.F.,.F.,aCusto)
        If Valtype(aCusto) != "A"
          aCusto:=ACLONE(aBackCusto)
        EndIf
      EndIf

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualiza o saldo final (VFIM) com os dados do SD3            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Nao calcula produtos "MAO DE OBRA"                           ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If !(Substr(SD3->D3_COD,1,3) == "MOD" .And. Subs(cOpcoes,1,1) == "1")
        B2FimComD3(aCusto,NIL,NIL,NIL,lCusUnif,lCstPart,aRetPartes)
        XTTFimD3(aCusto,ACLONE(aRetPartes))
        If lMA330D3
          ExecBlock("MA330D3",.F.,.F.)
        Endif
      EndIf
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Verifica se o movimento e' referente a requisicao manual     ³
      //³ de material indireto para atualizar o saldo final (VFIM)     ³
      //³ do processo com os dados do SD3                              ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If cApropri == "3"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD3            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Nao calcula produtos "MAO DE OBRA"                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !(Substr(SD3->D3_COD,1,3) == "MOD" .And. Subs(cOpcoes,1,1) == "1")
          B2FimComD3(aCusto,GetMv("MV_LOCPROC"),NIL,NIL,lCusUnif,lCstPart,aRetPartes)
          XTTFimD3(aCusto,ACLONE(aRetPartes))
          If lMA330D3
            ExecBlock("MA330D3",.F.,.F.)
          Endif
        EndIf
      EndIf

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualiza os saldos finais (VFIM) das OP's                    ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If !Empty(SD3->D3_OP)
        If SC2->(dbSeek(xFilial("SC2")+SD3->D3_OP))
          C2FimComD3(aCusto,NIL,NIL,lCstPart,aRetPartes)
        Else
          Help(" ",1,"A650NOP",,SD3->D3_OP,02,01)
        EndIf
      EndIf

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualiza os saldos finais (VFIM) das Tarefas                 ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If !Empty(SD3->D3_PROJPMS)
        AF9FimComD3(aCusto)
      EndIf

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Verifica se o custo medio e' calculado On-Line               ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If SubStr(SD3->D3_CF,3,1) != "2"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Gera o lancamento no arquivo de prova                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If SD3->D3_TM <= "500"
          nTotal+=XA330DET(nHdlPrv,"668","MATA330",cLoteEst,,lLct667669)
        Else
          nTotal+=XA330DET(nHdlPrv,"666","MATA330",cLoteEst,,lLct667669)
        EndIf
      Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Gera o lancamento no arquivo de prova                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If SD3->D3_TM <= "500"
          nTotal+=XA330DET(nHdlPrv,"679","MATA330",cLoteEst,,lLct667669)
        Else
          nTotal+=XA330DET(nHdlPrv,"680","MATA330",cLoteEst,,lLct667669)
        EndIf
      EndIf

      dbSelectArea("SD3")
      If D3_TM <= "500"
        If cApropri == "2"
          For nX := 1 To nTamArrCus
            aAprInd[nX] := aAprInd[nX] - aCusto[nX]
          Next nX
        ElseIf cApropri != "3"
          For nX := 1 To nTamArrCus
            aAprDir[nX] := aAprDir[nX] - aCusto[nX]
          Next nX
        EndIf
      Else
        If cApropri == "2"
          For nX := 1 To nTamArrCus
            aAprInd[nX] := aAprInd[nX] + aCusto[nX]
          Next nX
        ElseIf cApropri != "3"
          For nX := 1 To nTamArrCus
            aAprDir[nX] := aAprDir[nX] + aCusto[nX]
          Next nX
        EndIf
      EndIf
    Endif

  ElseIf TRB->TRB_ALIAS == "SD2"

    dbSelectArea("SD2")
    dbGoto(TRB->TRB_RECNO)
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ LOCALIZACOES - Grava o custo de saida do remito que originou ³
    //³ a nota, cuando esta proviene de um remito, pois as Notas de  ³
    //³ credito pegam o custo de saida original do SD2 a nao do SCN).³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    lProcSD2  :=  .T.
    If cPaisLoc # "BRA" .And. !Empty(SD2->D2_REMITO)
      SCN->(DbSetOrder(1))
      If SCN->(DbSeek(xFilial()+SD2->D2_REMITO+SD2->D2_ITEMREM))
        If SCN->CN_TIPOREM # "1"
          lProcSD2  :=  .F.
        Endif
      Endif
    Endif

    If cPaisLoc == "BRA"  .Or. Empty(SD2->D2_REMITO) .Or. lProcSD2
      XGravaSeq("SD2")
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Posiciona no SB1 para formulas de lancamento contabil        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      dbSelectArea("SB1")
      dbSeek(xFilial()+SD2->D2_COD)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Posiciona no SF4 - TES                                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      dbSelectArea("SF4")
      dbSeek(xFilial()+SD2->D2_TES)
      dbSelectArea("SD2")

      If SF4->F4_PODER3 == "D"
        aRet       := XA330PegaSB6("SD2",.F.,"330",lCstPart,nPartes)
        aCM        := aRet[1]
        aRetPartes := aRet[3]
        If lM330CD2
          aBackCusto :=ACLONE(aCM)
          aCM:=ExecBlock("M330CD2",.F.,.F.,{aCM,.F.})
          If Valtype(aCM) != "A"
            aCM:=ACLONE(aBackCusto)
          EndIf
        EndIf
        aRet       := GravaCusD2(aCM,"N",NIL,"330",lCstPart,aRegraCP,ACLONE(aRetPartes))   // para forcar a gravacao
        aCusto     := aRet[1]
        aRetPartes := aRet[3]
        SD2->(MsUnlock())
        B2FimComD2(aCusto,NIL,NIL,lCstPart,aRetPartes)
        XTTFimD2(aCusto,ACLONE(aRetPartes))
        dbSelectArea("TRB")
        dbSetOrder(3)
        dbSkip()
        Loop
      Endif
      // Posicionamento do SF2 para pegar a taxa e a moeda
      If cPaisLoc<>"BRA"
        DbselectArea("SF2")
        DbSetOrder(1)
        DbSeek(xFilial()+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
        Do While !Eof() .And. SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA
          If Alltrim(F2_ESPECIE) == Alltrim(SD2->D2_ESPECIE) // Modificado por Bruno 15/10/99
            EXIT
          Else
            DbSkip()
            Loop
          Endif
        Enddo
        Dbselectarea("SD2")
      Endif

      If SD2->D2_TIPO != "D"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Obter o array de Impostos para enviar para aCusto. S¢ paises  ³
        //³ do ConeSul. Allergan - 03/03/99 JLucas...                     ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If cPaisLoc # "BRA"
          If Type("SF2->F2_TXMOEDA") # "U"
            nTaxa :=  SF2->F2_TXMOEDA
            nMOedaNf:=  SF2->F2_MOEDA
          Else
            nTaxa :=  0
          Endif
          nRatFrete := xMoeda(SF2->F2_FRETE * (SD2->D2_TOTAL / SF2->F2_VALMERC),SF2->F2_MOEDA,1,SF2->F2_EMISSAO,,nTaxa)
          nRatDesp := XMoeda(SF2->F2_DESPESA * (SD2->D2_TOTAL / SF2->F2_VALMERC),SF2->F2_MOEDA,1,SF2->F2_EMISSAO,,nTaxa)
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Processa as vendas                                           ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aEnvCus := XA330EnvCus( aImpCusto )

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega os custos medios finais                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet  := PegaCMFim(SD2->D2_COD,SD2->D2_LOCAL,SD2->D2_TIPO,aEnvCus,"SD2","330",NIL,NIL,lCstPart,nPartes)
        If lCusUnif
          aRet  := XA330TTFim(SD2->D2_COD,SD2->D2_LOCAL,SD2->D2_TIPO,aEnvCus,"SD2","330",NIL,NIL,lCstPart,nPartes)
        EndIf
        aCM        := aRet[1]
        aRetPartes := aRet[3]
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o custo da nota fiscal de saida                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If lM330CD2
          aBackCusto :=ACLONE(aCM)
          aCM:=ExecBlock("M330CD2",.F.,.F.,{aCM,.F.})
          If Valtype(aCM) != "A"
            aCM:=ACLONE(aBackCusto)
          EndIf
        EndIf
        aRet       := GravaCusD2(aCM,SD2->D2_TIPO,NIL,"330",lCstPart,aRegraCP,ACLONE(aRetPartes))
        aCusto     := aRet[1]
        aRetPartes := aRet[3]
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD2            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        B2FimComD2(aCusto,NIL,NIL,lCstPart,aRetPartes)
        XTTFimD2(aCusto,ACLONE(aRetPartes))

        If lMA330D2
          ExecBlock("MA330D2",.F.,.F.)
        Endif

        IF SF4->F4_PODER3 == "R"
          XA330GravaSB6("SD2",aCusto,NIL,NIL,lCstPart,aRegraCP,aRetPartes)
        Endif

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Gera o lancamento no arquivo de prova                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        nTotal+=XA330DET(nHdlPrv,"678","MATA330",cLoteEst,"SD2")
        SD2->(MsUnlock())
      Else
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Processa as devolucoes de compra                             ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aEnvCus := XA330EnvCus()

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Pega os custos medios finais                                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Na Funcao PegaCMFim() Esta Tratando CUSTO FIFO               ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRet  := PegaCMFim(SD2->D2_COD,SD2->D2_LOCAL,SD2->D2_TIPO,aEnvCus,"SD2","330",.T.,NIL,lCstPart,nPartes)
        If lCusUnif
          aRet  := XA330TTFim(SD2->D2_COD,SD2->D2_LOCAL,SD2->D2_TIPO,aEnvCus,"SD2","330",.T.,NIL,lCstPart,nPartes)
        EndIf
        aCM       := aRet[1]
        aRetPartes:= aRet[3]

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o custo da nota fiscal de saida                        ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If lM330CD2
          aBackCusto :=ACLONE(aCM)
          aCM:=ExecBlock("M330CD2",.F.,.F.,{aCM,.F.})
          If Valtype(aCM) != "A"
            aCM:=ACLONE(aBackCusto)
          EndIf
        EndIf
        aRet       := GravaCusD2(aCM,SD2->D2_TIPO,NIL,"330",lCstPart,aRegraCP,ACLONE(aRetPartes))
        aCusto     := aRet[1]
        aRetPartes := aRet[3]
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza o saldo final (VFIM) com os dados do SD2            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        B2FimComD2(aCusto,NIL,NIL,lCstPart,aRetPartes)
        XTTFimD2(aCusto,ACLONE(aRetPartes))

        If lMA330D2
          ExecBlock("MA330D2",.F.,.F.)
        Endif

        IF SF4->F4_PODER3 == "R"
          XA330GravaSB6("SD2",aCusto,NIL,NIL,lCstPart,aRegraCP,aRetPartes)
        Endif

        SD2->(MsUnlock())
      Endif
    Else
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Grava o custo de saida que foi calculado para o SCN          ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      XA330GrvCN()
    EndIf
  ElseIf TRB->TRB_ALIAS == "SCN"
    dbSelectArea("SCN")
    dbGoto(TRB->TRB_RECNO)
    XGravaSeq("SCN")
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Posiciona no SB1 para formulas de lancamento contabil        ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea("SB1")
    dbSeek(xFilial()+SCN->CN_PRODUTO)
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Posiciona no SF4 - TES                                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    dbSelectArea("SF4")
    dbSeek(xFilial()+SCN->CN_TES)
    dbSelectArea("SCN")

    // Remito de Vendas - Saida
    If CN_TIPOREM # "5"
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Pega os custos medios finais                                 ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      aRet  := PegaCMFim(SCN->CN_PRODUTO,SCN->CN_LOCAL,NIL,NIL,"SCN","330",.F.,NIL,lCstPart,nPartes)
      If lCusUnif
        aRet  := XA330TTFim(SCN->CN_PRODUTO,SCN->CN_LOCAL,NIL,NIL,"SCN","330")
      EndIf
      aCM   := aRet[1]
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Grava o custo do Remito de Vendas.                           ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      aRet     := GravaCusCN(aCM,NIL,NIL,"330")
      aCusto   := aRet[1]
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualiza o saldo final (VFIM) com os dados do SCN            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      B2FimComCN(aCusto)
      XTTFimCN(aCusto)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Contabiliza a saida de materias por remito de saida. Bruno.  ³
      //³  Se nao for uma transferencia.                               ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If SCN->CN_TIPOREM # "6"
        nTotal+=XA330DET(nHdlPrv,"675","MATA330",cLoteEst,"SCN")
      Endif
      // Remito de Vendas - Entrada Devolucao
    Else
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualiza o saldo final (VFIM) com os dados do SCN            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      aRet  := PegaCMFim(SCN->CN_PRODUTO,SCN->CN_LOCAL,"D",NIL,"SCN","330",.F.,NIL,lCstPart,nPartes)
      aCM   := aRet[1]
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Grava o custo do Remito de Vendas.                           ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      aRet     := GravaCusCN(aCM,"D",NIL,"330")
      aCusto   := aRet[1]
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualiza o saldo final (VFIM) com os dados do SCN            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      B2FimComCN(aCusto)
      XTTFimCN(aCusto)

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Contabiliza a entrada por devolucao de vendas. Bruno.        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      nTotal+=XA330DET(nHdlPrv,"677","MATA330",cLoteEst,"SCN")
    EndIf
  Endif
  dbSelectArea("TRB")
  dbSetOrder(3)
  dbSkip()
End

Set(3,nDec)
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A330ProcRE7³ Autor ³ Marcos Bregantim     ³ Data ³ 17/10/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa RE7 (Transferencias Multiplas)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XA330ProcRE7(lProcFifo,lCstPart,aRegraCP)
Local aCM:={0,0,0,0,0},aCusto, aTots, cNumSeq,nReg,lLast,nI,aCustoPart
Local aCmFF:={0,0,0,0,0},aCustoFF,aTotsFF,aRetPartes:={},aTotsPart,aEnvio
Local nOrdemSD3:=SD3->(IndexOrd())

IF D3_ESTORNO != "S"
  aRet  := PegaCMFim(D3_COD,D3_LOCAL, , , ,"330",NIL,lCusFifo .And. lProcFifo,lCstPart,Len(aRegraCP)+1)
  If lCusUnif
    aRet  := XA330TTFim(D3_COD,D3_LOCAL, , , ,"330",NIL,lCusFifo .And. lProcFifo,lCstPart,Len(aRegraCP)+1)
  EndIf
  aCM        := aRet[1]
  aCMFF      := aRet[2]
  aRetPartes := aRet[3]
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve re-gravar os custos                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par04 == 1
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Grava o custo da movimentacao                                ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  aRet      := GravaCusD3(IF(lCusFifo .And. lProcFifo,NIL,aCM),,IF(lCusFifo .And. lProcFifo,aCMFF,NIL),"330",NIL,lCstPart,aRegraCP,ACLONE(aRetPartes))
  aCusto    := aRet[1]
  aCustoFF  := aRet[2]
  aCustoPart:= aRet[3]
  SD3->(MsUnlock())
EndIf

dbSelectArea("SB2")
dbSeek(xFilial()+SD3->D3_COD+SD3->D3_LOCAL)
If EOF()
  CriaSB2(SD3->D3_COD,SD3->D3_LOCAL)
EndIf
RecLock("SB2",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao calcula produtos "MAO DE OBRA"                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par04==1.And.!(Substr(SD3->D3_COD,1,3) == "MOD" .And. Subs(cOpcoes,1,1) == "1")
  B2FimComD3(aCusto,NIL,aCustoFF,lCusFifo .And. lProcFifo,lCusUnif,lCstPart,aCustoPart)
  XTTFimD3(aCusto,ACLONE(aCustoPart))
  If lMA330D3
    ExecBlock("MA330D3",.F.,.F.)
  Endif
EndIf
dbSelectArea("SD3")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no SB1 para formulas de lancamento contabil        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB1")
dbSeek(xFilial()+SD3->D3_COD)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o lancamento no arquivo de prova                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotal+=XA330DET(nHdlPrv,"670","MATA330",cLoteEst)

dbSelectArea("SD3")
dbSetOrder(4)

aTots := aClone(aCusto)
If lCusFIFO .And. lProcFifo
  aTotsFF:=AClone(aCustoFF)
Endif
If lCstPart
  aTotsPart:=AClone(aCustoPart)
EndIf
cNumSeq := SD3->D3_NUMSEQ

dbSkip()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Movimentacao do Cursor                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IncProc()

While !Eof() .And. D3_FILIAL == xFIlial("SD3") .And. SD3->D3_CF == "DE7" .And. SD3->D3_NUMSEQ == cNumSeq

  nReg := SD3->(Recno())
  dbSkip()
  IF (!Eof() .And. D3_FILIAL == xFIlial("SD3") .And. SD3->D3_CF == "DE7" .And. SD3->D3_NUMSEQ == cNumSeq)
    lLast := .f.
  Else
    lLast := .t.
  Endif
  SD3->(dbGoto(nReg))

  IF lLast
    aCm := aClone(aTots)
    If lCusFIFO .And. lProcFifo
      aCmFF := aClone(aTotsFF)
    Endif
    If lCstPart
      aRetPartes:=AClone(aTotsPart)
      aEnvio:=ACLONE(aRetPartes)
      For ni:=1 to Len(aEnvio)
        aEnvio[ni] := aEnvio[ni] /SD3->D3_QUANT
      Next ni
    EndIf
  ElseIf mv_par04==1
    For ni := 1 to 5
      If lCusFIFO .And. lProcFifo
        aCmFF[ni] := aCustoFF[ni] * (SD3->D3_RATEIO / 100 )
        aTotsFF[ni] -= aCmFF[ni]
        If aTotsFF[ni] < 0  // para nao deixar custo negativo da transacao
          aCmFF[ni] += aTotsFF[ni]
          aTotsFF[ni] := 0
        Endif
      Else
        aCm[ni] := aCusto[ni] * (SD3->D3_RATEIO / 100 )
        aTots[ni] -= aCm[ni]
        If aTots[ni] < 0  // para nao deixar custo negativo da transacao
          aCm[ni] += aTots[ni]
          aTots[ni] := 0
        Endif
      Endif
    Next
    If lCstPart
      For ni:=1 to Len(aTotsPart)
        aRetPartes[ni] := aCustoPart[ni] * (SD3->D3_RATEIO / 100 )
        aTotsPart[ni] -= aRetPartes[ni]
        If aTotsPart[ni] < 0  // para nao deixar custo negativo da transacao
          aRetPartes[ni] += aTotsPart[ni]
          aTotsPart[ni] := 0
        Endif
      Next ni
      aEnvio:=ACLONE(aRetPartes)
      For ni:=1 to Len(aEnvio)
        aEnvio[ni] := aEnvio[ni] /SD3->D3_QUANT
      Next ni
    EndIf
  Endif
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verifica se deve re-gravar os custos                         ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If mv_par04 == 1
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Grava o custo da movimentacao                                ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aRet      :=GravaCusD3(IF(lCusFifo .And. lProcFifo,NIL,aCM),.T.,IF(lCusFifo .And. lProcFifo,aCMFF,NIL),"330",NIL,lCstPart,aRegraCP,aEnvio)
    aCM       :=aRet[1]
    aCMFF     :=aRet[2]
    aRetPartes:=aRet[3]
    SD3->(MsUnlock())
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Atualiza o SBD FIFO com os dados do SD3                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lCusFIFO .And. lProcFifo
      GravaSBD("SD3",aCMFF)
    Endif
  EndIf
  dbSelectArea("SB2")
  dbSeek(xFilial()+SD3->D3_COD+SD3->D3_LOCAL)
  If EOF()
    CriaSB2(SD3->D3_COD,SD3->D3_LOCAL)
  EndIf
  RecLock("SB2",.F.)
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Atualiza o saldo final (VFIM) com os dados do SD3            ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Nao calcula produtos "MAO DE OBRA"                           ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If mv_par04==1.And.!(Substr(SD3->D3_COD,1,3) == "MOD" .And. Subs(cOpcoes,1,1) == "1")
    B2FimComD3(aCM,NIL,aCMFF,lCusFifo .And. lProcFifo,lCusUnif,lCstPart,aRetPartes)
    XTTFimD3(aCM,ACLONE(RetPartes))
    If lMA330D3
      ExecBlock("MA330D3",.F.,.F.)
    Endif
  EndIf
  MsUnlock()
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Movimentacao do Cursor                                       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  IncProc()
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Posiciona no SB1 para formulas de lancamento contabil        ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SB1")
  dbSeek(xFilial()+SD3->D3_COD)

  dbSelectArea("SD3")
  If mv_par04 == 1
    XGravaSeq("SD3")
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Gera o lancamento no arquivo de prova                        ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  nTotal+=XA330DET(nHdlPrv,"672","MATA330",cLoteEst)
  dbSkip()
End
SD3->(dbSetOrder(nOrdemSD3))
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A330Inicia³ Autor ³ Eveli Morasco         ³ Data ³ 05/01/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pega valores do inicio do periodo para serem reprocessados ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A330Inicia(ExpC1,ExpC2)                                    ³±±
±±³          ³ ExpC1:= Variavel com nome do arquivo de trabalho p/ custo  ³±±
±±³          ³ unificado                                                  ³±±
±±³          ³ ExpC2:= Variavel com nome do indice  de trabalho p/ custo  ³±±
±±³          ³ unificado                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC Function YA330Inicia(cNomTrbU,cNomTrbU1)
#IFDEF TOP
  Local cXFIlial,aResult
  IF !lCusFIFO .and. ExistProc('MAT007') .and. !lCusUnif
    aResult := TCSPExec( xProcedures('MAT007'), cFilAnt, "@@", Dtos(dINICIO), GetMv("MV_LOCPROC"))

    IF Len(aResult) = 0 .or. aResult[1] == "0"
      Final(STR0025) //"Probs. SP. A330INI"
    Endif
  Else
    Za330Inicia(cNomTrbU,cNomTrbU1)
  Endif
  Return NIL

  Static Function Za330Inicia(cNomTrbU,cNomTrbU1)
#ENDIF
LOCAL nV,nX,bBloco:={ |nV,nX| Trim(nV)+STR(nX,1) }
LOCAL aSaldoIni[07],cProduto:="",cLocal:=""
LOCAL aSaldoFF[05]

Afill(aSaldoIni,0.00)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Volta os saldos iniciais do arquivo de saldos SB2            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB2")           // saldos em estoque
dbSeek( xFilial() )
While !EOF() .And. B2_FILIAL == xFilial()
  If SubStr(B2_COD,1,3) != "MOD"
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Posicionar e Buscar os Saldos Iniciais SB9, SD1 ,SD2 e SD3.  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aSaldoIni := CalcEst(SB2->B2_COD,SB2->B2_LOCAL,dInicio)
  Else
    aSaldoIni :={0,0,0,0,0,0,0}
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Gravar os Valores finais no SB2 com os valores iniciais SB9. ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SB2")
  RecLock("SB2",.F.)

  Replace B2_QFIM WITH aSaldoIni[1]
  Replace B2_QFIM2 WITH aSaldoIni[7]
  For nX := 1 To nTamArrCus
    Replace &(Eval(bBloco,"B2_VFIM",nX)) WITH aSaldoIni[nX+1]
    If B2_QFIM > 0
      If &(Eval(bBloco,"B2_VFIM",nX)) > 0
        Replace &(Eval(bBloco,"B2_CM",nX)) WITH &(Eval(bBloco,"B2_VFIM",nX)) / B2_QFIM
      EndIf
    EndIf
  Next nX
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Gravar os Valores finais no SB2 com o CUSTO EM PARTES.       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  XM330InB2CP(lCstPart,dInicio)
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Atualiza arquivo de trabalho p/ processar custo por empresa  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If lCusUnif
    dbSelectArea("TRT")
    If !dbSeek(SB2->B2_COD)
      CriaTRT(SB2->B2_COD)
    EndIf
    RecLock("TRT",.F.)
    TRT->TRB_QFIM  := TRT->TRB_QFIM  + SB2->B2_QFIM
    TRT->TRB_QFIM2 := TRT->TRB_QFIM2 + SB2->B2_QFIM2
    TRT->TRB_VFIM1 := TRT->TRB_VFIM1 + SB2->B2_VFIM1
    TRT->TRB_VFIM2 := TRT->TRB_VFIM2 + SB2->B2_VFIM2
    TRT->TRB_VFIM3 := TRT->TRB_VFIM3 + SB2->B2_VFIM3
    TRT->TRB_VFIM4 := TRT->TRB_VFIM4 + SB2->B2_VFIM4
    TRT->TRB_VFIM5 := TRT->TRB_VFIM5 + SB2->B2_VFIM5
    TRT->TRB_CM1   := TRT->TRB_VFIM1 / TRT->TRB_QFIM
    TRT->TRB_CM2   := TRT->TRB_VFIM2 / TRT->TRB_QFIM
    TRT->TRB_CM3   := TRT->TRB_VFIM3 / TRT->TRB_QFIM
    TRT->TRB_CM4   := TRT->TRB_VFIM4 / TRT->TRB_QFIM
    TRT->TRB_CM5   := TRT->TRB_VFIM5 / TRT->TRB_QFIM
    MsUnlock()
    dbSelectArea("SB2")
  EndIf

  If lCusFIFO
    If SubStr(SB2->B2_COD,1,3) != "MOD"
      aSaldoFF := CalcEstFF(SB2->B2_COD,SB2->B2_LOCAL,dInicio)
    Else
      aSaldoFF := {0,0,0,0,0,0,0}
    EndIf
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se Saldos Negativos ou CM Negativo Inicializar com Zeros CM. ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    SB2->B2_QFIMFF:= aSaldoFF[1]
    SB2->B2_CMFF1 := 0
    SB2->B2_CMFF2 := 0
    SB2->B2_CMFF3 := 0
    SB2->B2_CMFF4 := 0
    SB2->B2_CMFF5 := 0
    For nX := 2 To (nTamArrCus-1)
      Replace &(Eval(bBloco,"B2_VFIMFF",(nX-1))) WITH aSaldoFF[nX]
      If B2_QFIM > 0
        If &(Eval(bBloco,"B2_VFIMFF",(nX-1))) > 0
          Replace &(Eval(bBloco,"B2_CMFF",(nX-1))) WITH &(Eval(bBloco,"B2_VFIMFF",(nX-1))) / B2_QFIM
        EndIf
      EndIf
    Next nX
  Endif
  MsUnlock()
  dbSkip()
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Movimentacao do Cursor                                       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  IncProc()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Volta os saldos iniciais das Ordens de Preducao SC2          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC2")
dbSeek( xFilial() )
While !EOF() .And. C2_FILIAL == xFilial()
  RecLock("SC2",.F.)
  For nX := 1 To nTamArrCus
    Replace &(Eval(bBloco,"C2_VFIM"  ,nX)) WITH &(Eval(bBloco,"C2_VINI"  ,nX))
    Replace &(Eval(bBloco,"C2_APRFIM",nX)) WITH &(Eval(bBloco,"C2_APRINI",nX))
    If lCusFIFO
      Replace &(Eval(bBloco,"C2_VFIMFF",nX)) WITH &(Eval(bBloco,"C2_VINIFF",nX))
      Replace &(Eval(bBloco,"C2_APFIFF",nX)) WITH &(Eval(bBloco,"C2_APINFF",nX))
    Endif
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravar os Valores finais no SC2 com o CUSTO EM PARTES.       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    XM330InC2CP(lCstPart)
  Next nX
  MsUnlock()
  dbSkip()
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Movimentacao do Cursor                                       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  IncProc()
EndDo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Volta os saldos iniciais das Tarefas de Projetos             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("AF9")
dbSeek( xFilial() )
While !EOF() .And. AF9_FILIAL == xFilial()
  RecLock("AF9",.F.)
  For nX := 1 To nTamArrCus
    Replace &(Eval(bBloco,"AF9_VFIM"  ,nX)) WITH &(Eval(bBloco,"AF9_VINI"  ,nX))
    If lCusFIFO
      Replace &(Eval(bBloco,"AF9_VFIMFF",nX)) WITH &(Eval(bBloco,"AF9_VINIFF",nX))
    Endif
  Next nX
  MsUnlock()
  dbSkip()
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Movimentacao do Cursor                                       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  IncProc()
EndDo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa lotes do custo FIFO                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusFIFO
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Apaga os lotes do ultimo calculo                             ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SBD")
  cIndice := CriaTrab("",.F.)
  dbSelectArea("SBD")
  cFilSBD := 'BD_FILIAL == "'+xFilial("SBD")+'" .And. dTos(BD_DTPROC) >="'+dtos(dInicio)+'"'
  cKey    := 'BD_FILIAL+Dtos(BD_DTPROC)'
  IndRegua("SBD",cIndice,cKey,,cFILSBD,STR0016)   //"Selecionando Saldo Lotes FIFO..."
  nIndex := Retindex("SBD")
  #IFNDEF TOP
    dbSetIndex(cIndice+OrdBagExt())
  #ENDIF
  dbSetOrder(nIndex+1)
  dbGoTop()
  While !EOF()
    RecLock("SBD",.F.,.T.)
    dbDelete()
    MsUnlock()
    dbSkip()
  EndDo

  RETINDEX("SBD")
  Set Filter To
  Ferase(cIndice+OrdBagExt())

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Caso os arquivos estejam em MODO EXCLUSIVO efetua PACK no SBD³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If l330ArqExcl
    PACK
  EndIf

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Apaga os lotes do ultimo calculo                             ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SBD")
  cIndice := CriaTrab("",.F.)
  dbSelectArea("SBD")
  cFilSBD := 'BD_FILIAL == "'+xFilial("SBD")+'" .And. dtos(BD_DTCALC) >="'+dtos(dInicio)+'"'
  cKey    := 'BD_FILIAL+Dtos(BD_DTCALC)'
  IndRegua("SBD",cIndice,cKey,,cFILSBD,STR0016)   //"Selecionando Saldo Lotes FIFO..."
  nIndex := Retindex("SBD")
  #IFNDEF TOP
    dbSetIndex(cIndice+OrdBagExt())
  #ENDIF
  dbSetOrder(nIndex+1)
  dbGoTop()
  While !EOF()
    RecLock("SBD",.F.)
    Replace BD_STATUS With " "
    MsUnlock()
    dbSkip()
  EndDo

  RETINDEX("SBD")
  Set Filter To
  Ferase(cIndice+OrdBagExt())

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Iniclializa os Saldos iniciais do arquivo SBD                ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SD8")
  cIndice := CriaTrab("",.F.)
  dbSelectArea("SD8")
  cFilSD8 := 'D8_FILIAL == "'+xFilial("SD8")+'" .And. (D8_TIPONF == "E") .And. DTOS(D8_DTCALC)=="'+DTOS(GetMv("MV_ULMES"))+'"'
  cKey    := 'D8_FILIAL+Dtos(D8_DTPROC)'
  IndRegua("SD8",cIndice,cKey,,cFILSD8,STR0017)   //"Selecionando Mov. Lotes FIFO..."
  nIndex := Retindex("SD8")
  #IFNDEF TOP
    dbSetIndex(cIndice+OrdBagExt())
  #ENDIF
  dbSetOrder(nIndex+1)
  dbGotop()
  While !Eof()
    dbSelectArea("SBD")
    dbSetOrder(1)
    If dbSeek(xFilial()+SD8->D8_PRODUTO+SD8->D8_LOCAL)
      RecLock("SBD",.F.)
      SBD->BD_QINI  := SD8->D8_QUANT
      SBD->BD_QINI2UM:= SD8->D8_QT2UM
      SBD->BD_CUSINI1:= SD8->D8_CUSTO1
      SBD->BD_CUSINI2:= SD8->D8_CUSTO2
      SBD->BD_CUSINI3:= SD8->D8_CUSTO3
      SBD->BD_CUSINI4:= SD8->D8_CUSTO4
      SBD->BD_CUSINI5:= SD8->D8_CUSTO5
      MsUnLock()
    EndIf
    dbSelectArea("SD8")
    dbSkip()
  End

  RETINDEX("SD8")
  Set Filter To
  Ferase(cIndice+OrdBagExt())


  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Apaga os lotes do ultimo calculo "SD8"                       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SD8")
  cIndice := CriaTrab("",.F.)
  dbSelectArea("SD8")
  cFilSD8 := 'D8_FILIAL == "'+xFilial("SD8")+'" .And. dtos(D8_DTPROC) >="'+dtos(dInicio)+'" .And. !(D8_TIPONF == "E")'
  cKey    := 'D8_FILIAL+Dtos(D8_DTPROC)'
  IndRegua("SD8",cIndice,cKey,,cFILSD8,STR0017)   //"Selecionando Mov. Lotes FIFO..."
  nIndex := Retindex("SD8")
  #IFNDEF TOP
    dbSetIndex(cIndice+OrdBagExt())
  #ENDIF
  dbSetOrder(nIndex+1)
  dbGoTop()
  While !EOF()
    RecLock("SD8",.F.,.T.)
    dbDelete()
    MsUnlock()
    dbSkip()
  EndDo

  RETINDEX("SD8")
  Set Filter To
  Ferase(cIndice+OrdBagExt())

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Apaga os lotes do ultimo calculo "SD8"                       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SD8")
  cIndice := CriaTrab("",.F.)
  dbSelectArea("SD8")
  cFilSD8 := 'D8_FILIAL == "'+xFilial("SD8")+'" .And. dtos(D8_DTCALC) >="'+dtos(dInicio)+'" .And. !(D8_TIPONF == "E")'
  cKey    := 'D8_FILIAL+Dtos(D8_DTCALC)'
  IndRegua("SD8",cIndice,cKey,,cFILSD8,STR0017)   //"Selecionando Mov. Lotes FIFO..."
  nIndex := Retindex("SD8")
  #IFNDEF TOP
    dbSetIndex(cIndice+OrdBagExt())
  #ENDIF
  dbSetOrder(nIndex+1)
  dbGoTop()
  While !EOF()
    RecLock("SD8",.F.,.T.)
    dbDelete()
    MsUnlock()
    dbSkip()
  EndDo

  RETINDEX("SD8")
  Set Filter To
  Ferase(cIndice+OrdBagExt())

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Caso os arquivos estejam em MODO EXCLUSIVO efetua PACK no SBD³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If l330ArqExcl
    PACK
  EndIf

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Atualiza o Saldos Iniciais SBD FIFO                          ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SBD")
  dbSetOrder(1)
  dbSeek( xFilial() )
  While !EOF() .And. BD_FILIAL == xFilial()
    RecLock("SBD",.F.)
    Replace BD_QFIM    With BD_QINI
    Replace BD_QFIM2UM With ConvUm(BD_PRODUTO,BD_QINI,BD_QINI2UM,2)
    Replace BD_CUSFIM1 With BD_CUSINI1
    Replace BD_CUSFIM2 With BD_CUSINI2
    Replace BD_CUSFIM3 With BD_CUSINI3
    Replace BD_CUSFIM4 With BD_CUSINI4
    Replace BD_CUSFIM5 With BD_CUSINI5
    MsUnlock()
    dbSkip()
  EndDo
Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA330NivCD³ Autor ³ Bregantim / Stiefano  ³ Data ³ 01/10/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava os niveis no SC2 e no TRB                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MA330NivCD()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XMA330NivCD()
LOCAL cChavNew:=""  // cSavAnt := ""
LOCAL cNomArq := CriaTrab("",.f.),cNivAlt, cNivel, lGrava, cNivSD3
LOCAL cLocCQ  := GetMV("MV_CQ")
LOCAL nNivel  := 0
LOCAL aBackArea:={}
LOCAL lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acerta os niveis do arquivo de OP's (SC2)                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par11 == 1    // Monta SG1 Temporario
  dbSelectArea("SG1")
  dbSetOrder(1)
  cChave := IndexKey()
  Copy Stru to &cNomArq
  dbSelectArea("SG1")
  dbCloseArea()
  Use &cNomarq Alias SG1 Exclusive NEW
  Index On &cChave to &cNomArq  // E' em
  dbSelectArea("TRB")
  dbSetOrder(2)
  dbSeek("SD3")
  While !Eof() .And. TRB->TRB_ALIAS == "SD3"
    IF !Empty(TRB_OP) .And. SUBS(TRB_CF,2,1) = "E"
      dbSelectArea("SC2")
      If dbSeek(xFilial()+TRB->TRB_OP)
        dbSelectArea("SG1")
        dbSeek(xFilial()+SC2->C2_PRODUTO+TRB->TRB_COD)
        IF Eof()
          RecLock("SG1",.t.)
          Replace G1_FILIAL With xFilial()
          Replace G1_COD    With SC2->C2_PRODUTO
          Replace G1_COMP   With TRB->TRB_COD
          Replace G1_FIM    With CTOD("31/12/49")
          MsUnlock()
        Endif
      Else
        Help(" ",1,"A650NOP",,TRB->TRB_OP,02,01)
      Endif
    Endif
    dbSelectArea("TRB")
    dbSkip()
  End
  dbSelectArea("TRB")
  dbSetorder(1)

  cNivAlt := GETMV("MV_NIVALT")
  If cNivAlt != NIL
    RecLock("SX6",.f.)
    Replace X6_CONTEUD With "S"
    MsUnlock()
    If ! MA320Nivel(.T.,mv_par15==1,.F.)
      lRet := XA330Continua()
    Endif
    If lRet
      RecLock("SX6",.f.)
      Replace X6_CONTEUD With cNivAlt
      MsUnlock()
    Endif
  EndIf
Endif

If lRet
  dbSelectArea("SC2")
  dbSeek( xFilial() )
  While !Eof() .And. C2_FILIAL == xFilial()
    dbSelectArea("SG1")
    If dbSeek(xFilial()+SC2->C2_PRODUTO)
      dbSelectArea("SC2")
      RecLock("SC2",.F.)
      Replace C2_NIVEL With StrZero(100-Val(SG1->G1_NIV),2)
    Else
      dbSelectArea("SC2")
      RecLock("SC2",.F.)
      Replace C2_NIVEL With "  "
    Endif
    MsUnlock()
    dbSkip()
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Movimentacao do Cursor                                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    IncProc()
  EndDo

  // Ordem para processamento do N¡vel do SD3
  // "1" - RE6 / DE6
  // "1" - RE6 / DE6 na rotina A330Estru para as transferencias do CQ
  // "5" - PR0 / PR1
  // "5" - RE1 / DE1
  // "5" - RE4 / DE4 na rotina A330Estru
  // "5" - RE5 / DE5 no caso de tratamento de poder de terceiros
  // "5" - RE7 / DE7 na rotina A330Estru
  // "7" - RE3 / DE3
  // "9" - RE0 / DE0
  // "9" - RE2 / DE2

  // E' calculado n¡vel para RE5 e DE5 somente no caso de devolucao de poder de
  // terceiros . O PI deve ter o custo processado no momento da producao da OP
  // informada no SD1.
  // Caso contrario estas sÆo processadas junto da NF de retorno de beneficiamento (SD1)

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Acerta os niveis do arquivo de trabalho (TRB)                ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If SG1->(LastRec()) > 0
    dbSelectArea("TRB")
    dbSetOrder(2)
    dbGotop()
    ProcRegua(RecCount(),16,4)
    While !Eof()
      lGrava  := .T.
      cChavNew:= ""
      cNivSD3 := " "
      dbSelectArea("SG1")
      dbSeek(xFilial()+TRB->TRB_COD)
      If SG1->(Eof())
        cNivel := "   "
      Else
        cNivel := StrZero(100-Val(SG1->G1_NIV),2)
      Endif
      If TRB->TRB_ALIAS == "SD3"
        dbSelectArea("TRB")
        If !Empty(TRB->TRB_OP) .And. Subs(TRB->TRB_CF,2,2) != "E3";
            .And. If(TRB->TRB_CF == "RE5",TRB->TRB_ORDEM == "300",.T.)
          dbSelectArea("SC2")
          If dbSeek(xFilial()+TRB->TRB_OP)
            dbSelectArea("TRB")
            cNivel  := SC2->C2_NIVEL
            cNivSD3 := "5"
            If TRB->TRB_CF == "RE5" .And. TRB->TRB_ORDEM == "300"
              SD3->(dbGoto(TRB->TRB_RECNO))
              cChavNew:= SD3->D3_OP+SUBSTR(SD3->D3_CF,2,1)+SD3->D3_NUMSEQ+IIF(SD3->D3_CF$"DE4/DE6/DE7","9","0")+"b"
            EndIf
          Else
            Help(" ",1,"A650NOP",,TRB->TRB_OP,02,01)
          EndIf
        ElseIf SubStr(TRB->TRB_CF,2,2) $ "E4/E7"
          XA330Estru(TRB->TRB_CF,cLocCQ)
          lGrava := .F.
        ElseIf Subs(TRB->TRB_CF,2,2) != "E3"
          cNivSD3 := "9"
        Else
          cNivSD3 := "7"
        EndIf
        If (SubStr(TRB->TRB_CF,2) == "E6")
          IF TRB->TRB_LOCAL == cLocCQ
            XA330Estru(TRB->TRB_CF,cLocCQ)
            lGrava  := .F.
          Else
            cNivSD3 := "1"
            aBackArea:=GetArea()
            dbSetOrder(2)
            cNumSeq:=TRB->TRB_SEQ
            dbSeek("SD3"+cNumSeq)
            While cNumSeq == TRB->TRB_SEQ .and. !Eof()
              If TRB->TRB_LOCAL == cLocCQ
                lGrava:=.F.
                Exit
              EndIf
              dbSkip()
            End
            RestArea(aBackArea)
          Endif
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Acerta os niveis do SD1 quando gerou RE5 de produto com estrutura³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      ElseIf TRB->TRB_ALIAS == "SD1"
        dbSelectArea("SD1")
        dbGoto(TRB->TRB_RECNO)
        dbSelectArea("SF4")
        dbSeek(xFilial()+SD1->D1_TES)
        dbSelectArea("SD1")
        If TRB->TRB_ORDEM == "300" .And. !Empty(D1_OP) .and. SF4->F4_ESTOQUE == "S" .And. SF4->F4_PODER3 == "D"
          dbSelectArea("SC2")
          If dbSeek(xFilial()+SD1->D1_OP)
            dbSelectArea("TRB")
            cNivel  := SC2->C2_NIVEL
            cNivSD3 := "5"
            SD3->(dbGoto(TRB->TRB_RECSD1))
            cChavNew:= SD3->D3_OP+SUBSTR(SD3->D3_CF,2,1)+DTOS(SD3->D3_EMISSAO)+SD3->D3_NUMSEQ+IIF(SD3->D3_CF$"DE4/DE6/DE7","9","0")+"a"
          Else
            Help(" ",1,"A650NOP",,SD1->D1_OP,02,01)
          EndIf
        Else
          lGrava:=.F.
        EndIf
      EndIf
      If lGrava .And. ;
          (AllTrim(TRB->TRB_NIVEL)#AllTrim(cNivel) .Or. AllTrim(TRB->TRB_NIVSD3)#AllTrim(cNivSD3) .Or. AllTrim(TRB->TRB_CHAVE)#AllTrim(cChavNew))
        RecLock("TRB",.f.)
        Replace TRB->TRB_NIVEL  With cNivel
        Replace TRB->TRB_NIVSD3 With cNivSD3
        If !Empty(cChavNew)
          Replace TRB->TRB_CHAVE With cChavNew
        EndIf
        MsUnlock()
      EndIf
      dbSelectArea("TRB")
      dbSkip()
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Movimentacao do Cursor                                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      IncProc()
    EndDo
  EndIf

Endif
IF MV_PAR11 == 1
  dbSelectArea("SG1")
  dbCloseArea()
  Ferase(cNomArq+GetDBExtension())
  Ferase(cNomArq+OrdBagExt())
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A330EnvCus³ Autor ³ Marcos Bregantim      ³ Data ³ 17/10/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta array EnvCus para devolucao de compra                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XA330EnvCus(aImpCusto)
Local aEnvCus:={}
Local nImpInc  := 0,nTotal := 0
aImpCusto   := IIf(aImpCusto == NIL, {}, aImpCusto)
// Allergan - 15/03/99 JLUCAS
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se est  sendo utilizado o Roteiro de c lculo para os ³
//³ impostos variaveis - Paises do ConeSul.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If GetMV("MV_GERIMPV") == "S"
  //Tratamento Provisorio ate re-formular a retcusent e
  //todos os Programas de entrada da versao de localizacoes,
  //que usam a RetCusEnt().
  //Bruno 27/04/00 07:01pm

  SFB->(DbSetOrder(1))
  SFC->(DbSeek(xFilial()+SD2->D2_TES))
  While !SFC->(EOF())  .And. SD2->D2_TES == SFC->FC_TES
    If SFB->(DbSeek(xFilial()+SFC->FC_IMPOSTO))
      If (SFC->FC_INCNOTA=="S".And.SFC->FC_CREDITA == "N") .or. SFC->FC_CREDITA=="1"
        nImpInc  += &("SD2->"+SFB->FB_CPOVRSI)
      ElseIf (SFC->FC_INCNOTA=="N".And.SFC->FC_CREDITA == "S") .or. SFC->FC_CREDITA=="2"
        nImpInc  -= &("SD2->"+SFB->FB_CPOVRSI)
      Endif
    Endif
    SFC->(DbSkip())
  Enddo

  nTotal   := IIf(Type("SF2->F2_TXMOEDA")#"U".And.SF2->F2_MOEDA > 1,;
    xMoeda(SD2->D2_TOTAL + nImpInc,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,,SF2->F2_TXMOEDA),;
    SD2->D2_TOTAL + nImpInc)

  aEnvCus := { nTotal,aImpCusto,0.00,SF4->F4_CREDIPI, SF4->F4_CREDICM, , , , , , }
Else
  aEnvCus := { SD2->D2_TOTAL,SD2->D2_VALIPI,SD2->D2_VALICM,SF4->F4_CREDIPI, SF4->F4_CREDICM, , , , , , }

  IF SF4->F4_IPI == "R" .And. SF4->F4_BASEIPI > 0
    aEnvCus[11] := NoRound(SD2->D2_TOTAL * (SB1->B1_IPI / 100) * (SF4->F4_BASEIPI/100))
  Else
    aEnvCus[11] := 0
  Endif
Endif
Return (aEnvCus)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A330Estru ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 03/06/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o produto da transferencia tem estrutura       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function XA330Estru(cCF,cLocCQ)
LOCAL aRegs:={},aAreaSD7:={}
LOCAL cAlias:="",cNumSeq:="",cNivel:=""
LOCAL dData
LOCAL lEstru :=.F.,lFlagCQ:=.F.,lAcertaMOV:=.F.
LOCAL nRecno:=0,nOrder:=0,n

If TRB->TRB_CF $ "RE4/RE7/RE6"
  // Ativa flag que indica que material veio do CQ atraves de PRODUCAO
  If TRB->TRB_LOCAL == cLocCQ
    dbSelectArea("SD7")
    aAreaSD7:=GetArea()
    dbSetOrder(3)
    // Verifica se flag indica producao
    If dbSeek(xFilial()+TRB->TRB_COD+TRB->TRB_SEQ+TRB->TRB_DOC) .And. SD7->D7_ORIGLAN == "PR"
      lFlagCQ:=.T.
      If Substr(TRB->TRB_CF,2) == "E6"
        lAcertaMOV:=.T.
      EndIf
    EndIf
    RestArea(aAreaSD7)
    dbSelectArea("TRB")
  EndIf
  cAlias  := Alias()
  nRecno  := Recno()
  nOrder  := IndexOrd()
  cNumSeq := TRB->TRB_SEQ
  dData   := TRB->TRB_DTORIG
  dbSetOrder(2)
  dbSeek("SD3"+cNumseq)
  While cNumseq == TRB->TRB_SEQ .and. !Eof()
    If TRB->TRB_DTORIG == dData .And. Subs(TRB->TRB_CF,2,2) == Subs(cCF,2,2)
      If Subs(TRB->TRB_CF,1,1) == "R" .And. SG1->(dbSeek(xFilial("SG1")+TRB->TRB_COD))
        lEstru:=.T.
        cNivel := StrZero(100-Val(SG1->G1_NIV),2)
      EndIf
      AADD(aRegs,Recno())
    EndIf
    dbSelectArea("TRB")
    dbSkip()
  EndDo
  For n:=1 to Len(aRegs)
    dbGoto(aRegs[n])

    // Indica se grava mov. do CQ atraves de producao com "RE4/DE4"
    If Substr(TRB->TRB_CF,2) == "E6" .And. lFlagCQ .And. lAcertaMOV
      dbSelectArea("SD3")
      dbGoto(TRB->TRB_RECNO)
      Reclock("SD3",.F.)
      Replace D3_CF With Substr(D3_CF,1,2)+"4"
      MsUnlock()
    EndIf

    RecLock("TRB",.F.)
    // Indica se grava mov. do CQ atraves de producao com "RE4/DE4"
    If Substr(TRB->TRB_CF,2) == "E6" .And. lFlagCQ .And. lAcertaMOV
      Replace TRB->TRB_CF With Substr(TRB_CF,1,2)+"4"
    EndIf

    IF lEstru
      Replace TRB->TRB_NIVEL  With cNivel + IIF(TRB->TRB_CF$"DE4/RE4/DE7/RE7","z"," ")
    Else
      Replace TRB->TRB_NIVEL  With "   "
    Endif
    Replace TRB->TRB_NIVSD3 With IIF(Subs(TRB->TRB_CF,2,2)=="E6","1","5")
    Replace TRB->TRB_TIPO   With "T"
    MsUnlock()
  Next n
  dbSelectArea(cAlias)
  dbSetOrder(nOrder)
  dbGoto(nRecno)
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A330Est   ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 12/07/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se DEVE considerar o produto como tendo estrutura ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XA330Est(cCod)
Local aArea,lRet,aOldArea:= GetArea()
If mv_par11 == 1
  dbSelectArea("SC2")
  aArea := GetArea()
  dbSetOrder(2)
Else
  dbSelectArea("SG1")
  aArea := GetArea()
Endif
lRet := dbSeek(xFilial()+cCod)
RestArea(aArea)
RestArea(aOldArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A330PrcPR0³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 09/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula qtd total da ordem de producao p/ proporcionalizar ³±±
±±³          ³ o custo de cada apontamento.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XA330PrcPR0()
Local cSeek:="",cWhile:="",lGrava:=.F.
Local nQuantTot:=0,nRecOrig:=0
dbSelectArea("TRX")
dbGotop()
While !Eof()
  If !lGrava
    nQuantTot:=0
    nRecOrig:=Recno()
  EndIf
  cSeek:=DTOS(TRX_DATA)+TRX_OP+TRX_COD
  cWhile:="DTOS(TRX_DATA)+TRX_OP+TRX_COD"
  While !Eof() .And. cSeek == &(cWhile)
    If !lGrava
      nQuantTot+=TRX_QUANT
    Else
      Reclock("TRX",.F.)
      Replace TRX_TOTAL With nQuantTot
      MsUnlock()
    EndIf
    dbSkip()
  End
  If !lGrava
    lGrava:=.T.
    dbGoto(nRecOrig)
  Else
    lGrava:=.F.
  EndIf
End
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A330TRT   ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 15/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria arquivo de trabalho para processar custo unificado    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A330TRT(ExpC1,ExpC2)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ ExpC1:= Variavel com nome do arquivo de trabalho p/ custo  ³±±
±±³          ³ unificado                                                  ³±±
±±³          ³ ExpC2:= Variavel com nome do indice  de trabalho p/ custo  ³±±
±±³          ³ unificado                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XA330TRT(cNomTrbU,cNomTrbU1,lCstPart,nPartes)
LOCAL nx:=0,nz:=0
LOCAL aCamposTRT:={}
LOCAL aArea:=GetArea()
aTam:=TamSX3("B1_COD")
AADD(aCamposTRT,{ "TRB_COD"   ,"C",aTam[1],0 } )
aTam:=TamSX3("B2_QFIM")
AADD(aCamposTRT,{ "TRB_QFIM"    ,"N",aTam[1]+2,aTam[2] } )
aTam:=TamSX3("B2_QFIM2")
AADD(aCamposTRT,{ "TRB_QFIM2"   ,"N",aTam[1]+2,aTam[2] } )
aTam:=TamSX3("B2_VFIM1")
AADD(aCamposTRT,{ "TRB_VFIM1"   ,"N",aTam[1]+2,aTam[2] } )
aTam:=TamSX3("B2_VFIM2")
AADD(aCamposTRT,{ "TRB_VFIM2"   ,"N",aTam[1]+2,aTam[2] } )
aTam:=TamSX3("B2_VFIM3")
AADD(aCamposTRT,{ "TRB_VFIM3"   ,"N",aTam[1]+2,aTam[2] } )
aTam:=TamSX3("B2_VFIM4")
AADD(aCamposTRT,{ "TRB_VFIM4"   ,"N",aTam[1]+2,aTam[2] } )
aTam:=TamSX3("B2_VFIM5")
AADD(aCamposTRT,{ "TRB_VFIM5"   ,"N",aTam[1]+2,aTam[2] } )
aTam:=TamSX3("B2_CM1")
AADD(aCamposTRT,{ "TRB_CM1"   ,"N",aTam[1]+2,aTam[2] } )
aTam:=TamSX3("B2_CM2")
AADD(aCamposTRT,{ "TRB_CM2"   ,"N",aTam[1]+2,aTam[2] } )
aTam:=TamSX3("B2_CM3")
AADD(aCamposTRT,{ "TRB_CM3"   ,"N",aTam[1]+2,aTam[2] } )
aTam:=TamSX3("B2_CM4")
AADD(aCamposTRT,{ "TRB_CM4"   ,"N",aTam[1]+2,aTam[2] } )
aTam:=TamSX3("B2_CM5")
AADD(aCamposTRT,{ "TRB_CM5"   ,"N",aTam[1]+2,aTam[2] } )
// Caso utilize custo em partes cria os campos no arquivo de trabalho
If lCstPart
  For nz:=1 to nPartes
    For nx:=1 to 5
      aTam:=TamSX3("B2_CM1")
      AADD(aCamposTRT,{ "TRB_CP"+StrZero(nz,2,0)+StrZero(nx,2,0),"N",aTam[1]+2,aTam[2]})
      aTam:=TamSX3("B2_VFIM1")
      AADD(aCamposTRT,{ "TRB_VF"+StrZero(nz,2,0)+StrZero(nx,2,0),"N",aTam[1]+2,aTam[2]})
    Next nx
  Next nz
EndIf
// Incluido para evitar duplicidade
INKEY(2)
cNomTrbU  := CriaTrab(aCamposTRT)
cNomTrbU1 := Subs(cNomTrbU,1,7)+"A"
dbUseArea( .T.,,cNomTrbU,"TRT", If(.T. .Or. .F., !.F., NIL), .F. )
IndRegua("TRT",cNomTrbU1,"TRB_COD",,,STR0012)   //"Criando Arquivo Trabalho 1..."
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TTFimComMO³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 13/11/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o saldo final do TRT (VFIM) baseado no val. da MOD³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TTFimComMO(ExpA1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os custos da MOD                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XTTFimMO(aCusto)
LOCAL nV,nX,aVFim[5],aCM[5],nMultiplic := 1
LOCAL bBloco := { |nV,nX| Trim(nV)+Str(nX,1) }
LOCAL nDec:=Set(3,8)
LOCAL aArea:=GetArea()
IF lCusUnif
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Posiciona no local a ser atualizado                   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("TRT")
  If !dbSeek(SB2->B2_COD)
    CriaTRT(SB2->B2_COD)
  EndIf
  RecLock("TRT",.F.)
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Pega o custo do campo e soma o custo da entrada       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If aCusto <> NIL
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Pega o custo do campo e soma o custo da entrada       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    For nX := 1 to 5
      aVfim[nX] := &(Eval(bBloco,"TRT->TRB_VFIM",nX)) + aCusto[nX]
    Next nX
  EndIf
  Replace TRB_VFIM1 With aVFim[01]
  Replace TRB_VFIM2 With aVFim[02]
  Replace TRB_VFIM3 With aVFim[03]
  Replace TRB_VFIM4 With aVFim[04]
  Replace TRB_VFIM5 With aVFim[05]
  MsUnlock()
EndIf
Set(3,nDec)
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TTFimQtdMO³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 13/11/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza a quantidade final do TRT baseado nos movimentos  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TTFimQtdMO()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XTTFimQtdMO()
LOCAL nV,nX,aVFim[5],aCM[5],nMultiplic := 1
LOCAL bBloco := { |nV,nX| Trim(nV)+Str(nX,1) }
LOCAL nDec:=Set(3,8)
LOCAL aArea:=GetArea()
IF lCusUnif
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Posiciona no local a ser atualizado                   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("TRT")
  If !dbSeek(SB2->B2_COD)
    CriaTRT(SB2->B2_COD)
  EndIf
  RecLock("TRT",.F.)
  Replace TRB_QFIM  With SB2->B2_QFIM
  aCM[01] := TRB_CM1
  aCM[02] := TRB_CM2
  aCM[03] := TRB_CM3
  aCM[04] := TRB_CM4
  aCM[05] := TRB_CM5
  For nX := 1 to 5
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Pega o custo final do campo correto                   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aVfim[nX] := &(Eval(bBloco,"TRT->TRB_VFIM",nX))
    aCM[nX]   := aVFIM[nX]/ABS(TRB_QFIM)
  Next nX
  Replace TRB_CM1 With aCM[01]
  Replace TRB_CM2 With aCM[02]
  Replace TRB_CM3 With aCM[03]
  Replace TRB_CM4 With aCM[04]
  Replace TRB_CM5 With aCM[05]
  MsUnlock()
EndIf
Set(3,nDec)
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TTFimComD1³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 15/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o saldo final do TRT (VFIM) baseado no SD1        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TTFimComD1(ExpA1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os custos gravados no SD1                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XTTFimD1(aCusto,aRetPartes)
LOCAL nV,nX,aVFim[5],aCM[5],nMultiplic := 1
LOCAL bBloco := { |nV,nX| Trim(nV)+Str(nX,1) }
LOCAL nDec:=Set(3,8)
IF lCusUnif
  If SD1->D1_TES > "500"
    nMultiplic := -1
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Posiciona Arq. de moedas pela data de digitacao ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SM2")
  dbSeek(SD1->D1_DTDIGIT,.T.)
  If !Found()
    dbSkip(-1)
  Endif
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Posiciona no local a ser atualizado                   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("TRT")
  If !dbSeek(SD1->D1_COD)
    CriaTRT(SD1->D1_COD)
  EndIf
  RecLock("TRT",.F.)
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Pega o custo do campo e soma o custo da entrada       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If aCusto == NIL
    aVFim[01] := TRB_VFIM1 + SD1->D1_CUSTO  * nMultiplic
    aVFim[02] := TRB_VFIM2 + SD1->D1_CUSTO2 * nMultiplic
    aVFim[03] := TRB_VFIM3 + SD1->D1_CUSTO3 * nMultiplic
    aVFim[04] := TRB_VFIM4 + SD1->D1_CUSTO4 * nMultiplic
    aVFim[05] := TRB_VFIM5 + SD1->D1_CUSTO5 * nMultiplic
  Else
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Pega o custo do campo e soma o custo da entrada       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    For nX := 1 to 5
      aVfim[nX] := &(Eval(bBloco,"TRT->TRB_VFIM",nX)) + aCusto[nX]
    Next nX
  EndIf
  Replace TRB_QFIM  With TRB_QFIM  + (SD1->D1_QUANT * nMultiplic)
  Replace TRB_QFIM2 With TRB_QFIM2 + (SD1->D1_QTSEGUM * nMultiplic)
  Replace TRB_VFIM1 With aVFim[01]
  Replace TRB_VFIM2 With aVFim[02]
  Replace TRB_VFIM3 With aVFim[03]
  Replace TRB_VFIM4 With aVFim[04]
  Replace TRB_VFIM5 With aVFim[05]
  aCM[01] := TRB_CM1
  aCM[02] := TRB_CM2
  aCM[03] := TRB_CM3
  aCM[04] := TRB_CM4
  aCM[05] := TRB_CM5
  For nX := 1 to 5
    If TRB_QFIM > 0 .And. aVFim[nX] > 0
      aCM[nX] := aVFIM[nX]/TRB_QFIM
    EndIf
  Next nX
  If SubStr(TRB_COD,1,3) != "MOD"
    Replace TRB_CM1 With aCM[01]
    Replace TRB_CM2 With aCM[02]
    Replace TRB_CM3 With aCM[03]
    Replace TRB_CM4 With aCM[04]
    Replace TRB_CM5 With aCM[05]
  EndIf
  // Caso utilize custo em partes atualiza o valor total do custo em partes
  AtuCPSB2(lCstPart,aRetPartes,nMultiplic,"TRB_VF")
    // Obtem o custo em partes unitario
  aRetPartes:=PegaCMPFim("TRB_VF",lCstPart,Len(aRetPartes)/5,TRT->TRB_QFIM)
  // Grava o custo em partes unitario
  GravaCusCP(lCstPart,NIL,NIL,"TRT",SD1->D1_COD,ACLONE(aRetPartes),1,"TRB_CP")
  MsUnlock()
EndIf
Set(3,nDec)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TTFimComD2³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 15/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o saldo final do TRT (VFIM) baseado no SD2        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TTFimComD2(ExpA1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os custos gravados no SD1                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION XTTFimD2(aCusto,aRetPartes)
LOCAL nX,aVFim[05],aCM[05],nMultiplic := 1
LOCAL nDec:=Set(3,8)
IF lCusUnif
  If SD2->D2_TES > "500"
    nMultiplic := -1
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Posiciona no local a ser atualizado                   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("TRT")
  If !dbSeek(SD2->D2_COD)
    CriaTRT(SD2->D2_COD)
  EndIf
  RecLock("TRT",.F.)
  aVFim[01] := TRB_VFIM1 + aCusto[01] * nMultiplic
  aVFim[02] := TRB_VFIM2 + aCusto[02] * nMultiplic
  aVFim[03] := TRB_VFIM3 + aCusto[03] * nMultiplic
  aVFim[04] := TRB_VFIM4 + aCusto[04] * nMultiplic
  aVFim[05] := TRB_VFIM5 + aCusto[05] * nMultiplic
  Replace TRB_QFIM With TRB_QFIM   + (SD2->D2_QUANT * nMultiplic)
  Replace TRB_QFIM2 With TRB_QFIM2 + (SD2->D2_QTSEGUM * nMultiplic)
  Replace TRB_VFIM1 With aVFim[01]
  Replace TRB_VFIM2 With aVFim[02]
  Replace TRB_VFIM3 With aVFim[03]
  Replace TRB_VFIM4 With aVFim[04]
  Replace TRB_VFIM5 With aVFim[05]
  aCM[01] := TRB_CM1
  aCM[02] := TRB_CM2
  aCM[03] := TRB_CM3
  aCM[04] := TRB_CM4
  aCM[05] := TRB_CM5
  For nX := 1 to 5
    If TRB_QFIM > 0 .And. aVFim[nX] > 0
      aCM[nX] := aVFim[nX]/TRB_QFIM
    EndIf
  Next nX
  If SubStr(TRB_COD,1,3) != "MOD"
    Replace TRB_CM1 With aCM[01]
    Replace TRB_CM2 With aCM[02]
    Replace TRB_CM3 With aCM[03]
    Replace TRB_CM4 With aCM[04]
    Replace TRB_CM5 With aCM[05]
  EndIf
  // Caso utilize custo em partes atualiza o valor total do custo em partes
  AtuCPSB2(lCstPart,aRetPartes,nMultiplic,"TRB_VF")
    // Obtem o custo em partes unitario
  aRetPartes:=PegaCMPFim("TRB_VF",lCstPart,Len(aRetPartes)/5,TRT->TRB_QFIM)
  // Grava o custo em partes unitario
  GravaCusCP(lCstPart,NIL,NIL,"TRT",SD2->D2_COD,ACLONE(aRetPartes),1,"TRB_CP")
  MsUnlock()
EndIf
Set(3,nDec)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TTFimComD3³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 15/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o saldo final do TRT (VFIM) baseado no SD3        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TTFimComD3(ExpA1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os custos gravados no SD3                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION XTTFimD3(aCusto,aRetPartes)
LOCAL nX,aVFim[05],aCM[05],nMultiplic := 1,cLocal
LOCAL lLockSd3 := .F.
LOCAL nDec:=Set(3,8)
IF lCusUnif
  If SD3->D3_TM > "500"
    nMultiplic := -1
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Posiciona no local a ser atualizado                   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("TRT")
  If !dbSeek(SD3->D3_COD)
    CriaTRT(SD3->D3_COD)
  EndIf
  RecLock("TRT",.F.)
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Aqui e' acertado o Saldo do Custo do Produto, quando  ³
  //³ a movimentacao do SD3 zerar o Saldo em Estoque do Prd.³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If ( TRB_QFIM+(SD3->D3_QUANT * nMultiplic) == 0 ) .And. ;
      !(SD3->D3_CF$"DE4|RE4|DE6|RE6")
    aCusto[1] := Abs(TRB_VFIM1)
    aCusto[2] := Abs(TRB_VFIM2)
    aCusto[3] := Abs(TRB_VFIM3)
    aCusto[4] := Abs(TRB_VFIM4)
    aCusto[5] := Abs(TRB_VFIM5)
    dbSelectArea("SD3")
    RecLock("SD3",.F.)
    SD3->D3_CUSTO1 := aCusto[1]
    SD3->D3_CUSTO2 := aCusto[2]
    SD3->D3_CUSTO3 := aCusto[3]
    SD3->D3_CUSTO4 := aCusto[4]
    SD3->D3_CUSTO5 := aCusto[5]
    MsUnLock()
    dbSelectArea("TRT")
  EndIf
  aVFim[01] := TRB_VFIM1 + aCusto[01] * nMultiplic
  aVFim[02] := TRB_VFIM2 + aCusto[02] * nMultiplic
  aVFim[03] := TRB_VFIM3 + aCusto[03] * nMultiplic
  aVFim[04] := TRB_VFIM4 + aCusto[04] * nMultiplic
  aVFim[05] := TRB_VFIM5 + aCusto[05] * nMultiplic
  Replace TRB_QFIM  With TRB_QFIM  + (SD3->D3_QUANT * nMultiplic)
  Replace TRB_QFIM2 With TRB_QFIM2 + (SD3->D3_QTSEGUM * nMultiplic)
  Replace TRB_VFIM1 With aVFim[01]
  Replace TRB_VFIM2 With aVFim[02]
  Replace TRB_VFIM3 With aVFim[03]
  Replace TRB_VFIM4 With aVFim[04]
  Replace TRB_VFIM5 With aVFim[05]
  aCM[01] := TRB_CM1
  aCM[02] := TRB_CM2
  aCM[03] := TRB_CM3
  aCM[04] := TRB_CM4
  aCM[05] := TRB_CM5
  For nX := 1 to 5
    If TRB_QFIM > 0 .And. aVFim[nX] > 0
      aCM[nX] := aVFim[nX]/TRB_QFIM
    EndIf
  Next nX
  If SubStr(TRB_COD,1,3) != "MOD"
    Replace TRB_CM1 With aCM[01]
    Replace TRB_CM2 With aCM[02]
    Replace TRB_CM3 With aCM[03]
    Replace TRB_CM4 With aCM[04]
    Replace TRB_CM5 With aCM[05]
  EndIf
  // Caso utilize custo em partes atualiza o valor total do custo em partes
  AtuCPSB2(lCstPart,aRetPartes,nMultiplic,"TRB_VF")
    // Obtem o custo em partes unitario
  aRetPartes:=PegaCMPFim("TRB_VF",lCstPart,Len(aRetPartes)/5,TRT->TRB_QFIM)
  // Grava o custo em partes unitario
  GravaCusCP(lCstPart,NIL,NIL,"TRT",SD3->D3_COD,ACLONE(aRetPartes),1,"TRB_CP")
  MsUnlock()
EndIf
Set(3,nDec)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A330TT2B2³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 15/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza os saldos do SB2 baseado no TRT                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XA330TT2B2()
Local aDifs := {0,0,0,0,0},nRec,nRec1
dbSelectArea("TRT")
dbGoTop()
While !Eof()
  aDifs[1] := TRT->TRB_VFIM1
  aDifs[2] := TRT->TRB_VFIM2
  aDifs[3] := TRT->TRB_VFIM3
  aDifs[4] := TRT->TRB_VFIM4
  aDifs[5] := TRT->TRB_VFIM5
  nRec := 0
  dbSelectArea("SB2")
  If dbSeek(xFilial()+TRT->TRB_COD)
    While !Eof() .and. B2_FILIAL == xFilial("SB2") .And. TRT->TRB_COD == SB2->B2_COD
      nRec:=0
      If QtdComp(SB2->B2_QFIM) > QtdComp(0)
        RecLock("SB2",.F.)
        SB2->B2_VFIM1 := SB2->B2_QFIM * ( TRT->TRB_VFIM1 / TRT->TRB_QFIM )
        aDifs[1] -= SB2->B2_VFIM1
        SB2->B2_VFIM2 := SB2->B2_QFIM * ( TRT->TRB_VFIM2 / TRT->TRB_QFIM )
        aDifs[2] -= SB2->B2_VFIM2
        SB2->B2_VFIM3 := SB2->B2_QFIM * ( TRT->TRB_VFIM3 / TRT->TRB_QFIM )
        aDifs[3] -= SB2->B2_VFIM3
        SB2->B2_VFIM4 := SB2->B2_QFIM * ( TRT->TRB_VFIM4 / TRT->TRB_QFIM )
        aDifs[4] -= SB2->B2_VFIM4
        SB2->B2_VFIM5 := SB2->B2_QFIM * ( TRT->TRB_VFIM5 / TRT->TRB_QFIM )
        aDifs[5] -= SB2->B2_VFIM5
        SB2->B2_CM1 := SB2->B2_VFIM1 / SB2->B2_QFIM
        SB2->B2_CM2 := SB2->B2_VFIM2 / SB2->B2_QFIM
        SB2->B2_CM3 := SB2->B2_VFIM3 / SB2->B2_QFIM
        SB2->B2_CM4 := SB2->B2_VFIM4 / SB2->B2_QFIM
        SB2->B2_CM5 := SB2->B2_VFIM5 / SB2->B2_QFIM
        MsUnlock()
        nRec := Recno()
      EndIf
      dbSkip()
      nRec1 := Recno()
      IF SB2->B2_COD != TRT->TRB_COD .and. nRec > 0
        dbGoto(nRec)
        RecLock("SB2",.F.)
        SB2->B2_VFIM1+= aDifs[1]
        SB2->B2_VFIM2+= aDifs[2]
        SB2->B2_VFIM3+= aDifs[3]
        SB2->B2_VFIM4+= aDifs[4]
        SB2->B2_VFIM5+= aDifs[5]
        SB2->B2_CM1 := SB2->B2_VFIM1 / SB2->B2_QFIM
        SB2->B2_CM2 := SB2->B2_VFIM2 / SB2->B2_QFIM
        SB2->B2_CM3 := SB2->B2_VFIM3 / SB2->B2_QFIM
        SB2->B2_CM4 := SB2->B2_VFIM4 / SB2->B2_QFIM
        SB2->B2_CM5 := SB2->B2_VFIM5 / SB2->B2_QFIM
        MsUnlock()
        dbGoto(nRec1)
      Endif
    End
  EndIf
  dbSelectArea("TRT")
  dbSkip()
End
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TTFimComCM³ Autor ³Bruno Sobieski .       ³ Data ³ 20.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o saldo final do TRT (VFIM) baseado no SCM        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TTFimComCM(ExpA1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os custos gravados no SCM                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XTTFimCM(aCusto)
LOCAL nV,nX,aVFim[5],aCM[5],nMultiplic := 1
LOCAL bBloco := { |nV,nX| Trim(nV)+Str(nX,1) }
LOCAL nDec:=Set(3,8)
IF lCusUnif
  If SCM->CM_TES > "500"
    nMultiplic := -1
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Posiciona Arq. de moedas pela data de digitacao ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SM2")
  dbSeek(SCM->CM_EMISSAO,.T.)
  If !Found()
    dbSkip(-1)
  Endif
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Posiciona no local a ser atualizado                   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("TRT")
  If !dbSeek(SCM->CM_PRODUTO)
    CriaTRT(SCM->CM_PRODUTO)
  EndIf
  RecLock("TRT",.F.)
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Pega o custo do campo e soma o custo da entrada       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If aCusto == NIL
    aVFim[01] := TRB_VFIM1 + SCM->CM_CUSTO1 * nMultiplic
    aVFim[02] := TRB_VFIM2 + SCM->CM_CUSTO2 * nMultiplic
    aVFim[03] := TRB_VFIM3 + SCM->CM_CUSTO3 * nMultiplic
    aVFim[04] := TRB_VFIM4 + SCM->CM_CUSTO4 * nMultiplic
    aVFim[05] := TRB_VFIM5 + SCM->CM_CUSTO5 * nMultiplic
  Else
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Pega o custo do campo e soma o custo da entrada       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    For nX := 1 to 5
      aVfim[nX] := &(Eval(bBloco,"TRT->TRB_VFIM",nX)) + aCusto[nX]
    Next nX
  EndIf
  Replace TRB_QFIM  With TRB_QFIM  + (SCM->CM_QUANT * nMultiplic)
  Replace TRB_QFIM2 With TRB_QFIM2 + (SCM->CM_QTSEGUM * nMultiplic)
  Replace TRB_VFIM1 With aVFim[01]
  Replace TRB_VFIM2 With aVFim[02]
  Replace TRB_VFIM3 With aVFim[03]
  Replace TRB_VFIM4 With aVFim[04]
  Replace TRB_VFIM5 With aVFim[05]
  aCM[01] := TRB_CM1
  aCM[02] := TRB_CM2
  aCM[03] := TRB_CM3
  aCM[04] := TRB_CM4
  aCM[05] := TRB_CM5
  For nX := 1 to 5
    If TRB_QFIM > 0 .And. aVFim[nX] > 0
      aCM[nX] := aVFIM[nX]/TRB_QFIM
    EndIf
  Next nX
  If SubStr(TRB_COD,1,3) != "MOD"
    Replace TRB_CM1 With aCM[01]
    Replace TRB_CM2 With aCM[02]
    Replace TRB_CM3 With aCM[03]
    Replace TRB_CM4 With aCM[04]
    Replace TRB_CM5 With aCM[05]
  EndIf
  // Caso utilize custo em partes atualiza o valor total do custo em partes
  AtuCPSB2(lCstPart,aRetPartes,nMultiplic,"TRB_VF")
    // Obtem o custo em partes unitario
  aRetPartes:=PegaCMPFim("TRB_VF",lCstPart,Len(aRetPartes)/5,TRT->TRB_QFIM)
  // Grava o custo em partes unitario
  GravaCusCP(lCstPart,NIL,NIL,"TRT",SCM->CM_PRODUTO,ACLONE(aRetPartes),1,"TRB_CP")
  MsUnlock()
EndIf
Set(3,nDec)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TTFimComCN³ Autor ³Bruno Sobieski         ³ Data ³ 20.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o saldo final do TRT (VFIM) baseado no SCN        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TTFimComCN(ExpA1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os custos gravados no SCN                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION XTTFimCN(aCusto)
LOCAL nX,aVFim[05],aCM[05],nMultiplic := 1
LOCAL nDec:=Set(3,8)
IF lCusUnif
  If SCN->CN_TES > "500"
    nMultiplic := -1
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Posiciona no local a ser atualizado                   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("TRT")
  If !dbSeek(SCN->CN_PRODUTO)
    CriaTRT(SCN->CN_PRODUTO)
  EndIf
  RecLock("TRT",.F.)
  aVFim[01] := TRB_VFIM1 + aCusto[01] * nMultiplic
  aVFim[02] := TRB_VFIM2 + aCusto[02] * nMultiplic
  aVFim[03] := TRB_VFIM3 + aCusto[03] * nMultiplic
  aVFim[04] := TRB_VFIM4 + aCusto[04] * nMultiplic
  aVFim[05] := TRB_VFIM5 + aCusto[05] * nMultiplic
  Replace TRB_QFIM With TRB_QFIM   + (SCN->CN_QUANT * nMultiplic)
  Replace TRB_QFIM2 With TRB_QFIM2 + (SCN->CN_QTSEGUM * nMultiplic)
  Replace TRB_VFIM1 With aVFim[01]
  Replace TRB_VFIM2 With aVFim[02]
  Replace TRB_VFIM3 With aVFim[03]
  Replace TRB_VFIM4 With aVFim[04]
  Replace TRB_VFIM5 With aVFim[05]
  aCM[01] := TRB_CM1
  aCM[02] := TRB_CM2
  aCM[03] := TRB_CM3
  aCM[04] := TRB_CM4
  aCM[05] := TRB_CM5
  For nX := 1 to 5
    If TRB_QFIM > 0 .And. aVFim[nX] > 0
      aCM[nX] := aVFim[nX]/TRB_QFIM
    EndIf
  Next nX
  If SubStr(TRB_COD,1,3) != "MOD"
    Replace TRB_CM1 With aCM[01]
    Replace TRB_CM2 With aCM[02]
    Replace TRB_CM3 With aCM[03]
    Replace TRB_CM4 With aCM[04]
    Replace TRB_CM5 With aCM[05]
  EndIf
  // Caso utilize custo em partes atualiza o valor total do custo em partes
  AtuCPSB2(lCstPart,aRetPartes,nMultiplic,"TRB_VF")
    // Obtem o custo em partes unitario
  aRetPartes:=PegaCMPFim("TRB_VF",lCstPart,Len(aRetPartes)/5,TRT->TRB_QFIM)
  // Grava o custo em partes unitario
  GravaCusCP(lCstPart,NIL,NIL,"TRT",SCN->CN_PRODUTO,ACLONE(aRetPartes),1,"TRB_CP")
  MsUnlock()
EndIf
Set(3,nDec)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A330GrvCN ³ Autor ³Bruno Sobieski         ³ Data ³ 15.12.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o custo do SD2 baseado no custo do SCN            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function XA330GrvCN()
Local aCusCN  :=  {}

SCN->(DbSetOrder(1))
If SCN->(dbSeek(xFilial()+SD2->D2_REMITO+SD2->D2_ITEMREM))
  If SD2->D2_QUANT == SCN->CN_QUANT
    aCusCN  :=  {SCN->CN_CUSTO1,SCN->CN_CUSTO2,SCN->CN_CUSTO3,SCN->CN_CUSTO4,SCN->CN_CUSTO5}
  Else
    aCusCN  :=  { SD2->D2_QUANT * (SCN->CN_CUSTO1/SCN->CN_QUANT),;
      SD2->D2_QUANT * (SCN->CN_CUSTO2/SCN->CN_QUANT),;
      SD2->D2_QUANT * (SCN->CN_CUSTO3/SCN->CN_QUANT),;
      SD2->D2_QUANT * (SCN->CN_CUSTO4/SCN->CN_QUANT),;
      SD2->D2_QUANT * (SCN->CN_CUSTO5/SCN->CN_QUANT)  }
  Endif

  Reclock("SD2",.F.)

  Replace D2_CUSTO1 With  aCusCN[1] ,;
    D2_CUSTO2 With  aCusCN[2] ,;
    D2_CUSTO3 With  aCusCN[3] ,;
    D2_CUSTO4 With  aCusCN[4] ,;
    D2_CUSTO5 With  aCusCN[5]
  MsUnLock()
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MATA330   ºAutor  ³MARCELO IUSPA       º Data ³  27/04/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pergunta ao usuario de continua ou nao o processamento em  º±±
±±º          ³ caso de recursividade                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function XA330Continua
Local lRet := .T.
If Aviso(STR0027, STR0022, {STR0023, STR0024}) # 1 //"Recursividade"###"Deseja prosseguir o Recalculo do Custo Medio?"###"Sim"###"Nao"
  lRet := .F.
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³M330InB2CP³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 23/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inicializa campos do SB2 com Custo em Partes no sistema    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MA330AvlCP(ExpL1,ExpD1)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 := Indica se o custo em partes esta habilitado ou nao³±±
±±³          ³ ExpD1 := Data inicial do calculo do custo medio            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XM330InB2CP(lCstPart,dInicio)
Local _cCampo:=""
Local _cCampo1:=""
Local _nLoop1:=1
Local _nLoop2:=1
Local lHasRec:=.F.
Local aArea:=GetArea()
Local aAreaSB9:=SB9->(GetArea())
// Array com os campos de saldo inicial existentes
Local _aSaldoIni:={}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de partida para compor o saldo inicial.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea( "SB9" )
dbSeek(xFilial()+SB2->B2_COD+SB2->B2_LOCAL)
While !Eof() .And. xFilial()+SB2->B2_COD+SB2->B2_LOCAL == B9_FILIAL+B9_COD+B9_LOCAL
  If (B9_DATA >= dInicio) .And. lHasRec
    Exit
  Else
    lHasRec := .T.
  EndIf
  DbSkip()
End
DbSkip(-1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preenche array com saldo inicial em partes           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cCampo:="B9_CP"
For _nLoop1:=1 to Len(aRegraCP)+1
  AADD(_aSaldoIni,ARRAY(5))
  For _nLoop2:=1 to 5
    If lHasRec
      _cCampo1:=_cCampo+Strzero(_nLoop1,2,0)+Strzero(_nLoop2,2,0)
      _aSaldoIni[_nLoop1,_nLoop2]:=FIELDGET(FieldPos(_cCampo1))
    Else
      _aSaldoIni[_nLoop1,_nLoop2]:=0
    EndIf
  Next _nLoop2
Next _nLoop1
SB9->(RestArea(aAreaSB9))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava informcao do custo em partes no SB2            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cCampo:="B2_CPF"
dbSelectArea("SB2")
For _nLoop1:=1 to Len(aRegraCP)+1
  For _nLoop2:=1 to 5
    _cCampo1:=_cCampo+Strzero(_nLoop1,2,0)+Strzero(_nLoop2,2,0)
    FIELDPUT(FieldPos(_cCampo1),_aSaldoIni[_nLoop1,_nLoop2])
  Next _nLoop2
Next _nLoop1
RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GravaC2CPF³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 10/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava no SC2 as informacoes do custo em partes             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os valores do custo em partes            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function XGravaC2CPF(aRetPartes)
LOCAL _cCampo := "C2_CPF"
LOCAL _nLoop0 :=0
LOCAL _nLoop1 :=0
LOCAL _nValorAtu:=0
LOCAL aArea   := GetArea()

If lCstPart
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Grava informacao do custo em partes no SC2           ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  For _nLoop0:=1 to Len(aRetPartes)/5
    For _nLoop1:=1 to 5
      _cCampo     := "C2_CPF"
      _cCampo     :=_cCampo+Strzero(_nLoop0,2,0)+Strzero(_nLoop1,2,0)
      _nValorAtu  :=FIELDGET(FieldPos(_cCampo))-aRetPartes[_nLoop1+If(_nLoop0==1,0,(_nLoop0-1)*5)]
      FIELDPUT(FieldPos(_cCampo),_nValorAtu)
    Next _nLoop1
  Next _nLoop0
EndIf
RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GravaC2APF³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 18/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava no SC2 as informacoes do custo em partes             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os valores do custo em partes            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function XGravaC2APF(aRetPartes)
LOCAL _cCampo := "C2_APF"
LOCAL _nLoop0 :=0
LOCAL _nLoop1 :=0
LOCAL aArea   := GetArea()

If lCstPart
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Grava informacao do custo em partes no SC2           ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  For _nLoop0:=1 to Len(aRetPartes)/5
    For _nLoop1:=1 to 5
      _cCampo     := "C2_APF"
      _cCampo     :=_cCampo+Strzero(_nLoop0,2,0)+Strzero(_nLoop1,2,0)
      FIELDPUT(FieldPos(_cCampo),aRetPartes[_nLoop1+If(_nLoop0==1,0,(_nLoop0-1)*5)])
    Next _nLoop1
  Next _nLoop0
EndIf
RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³M330InC2CP³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 26/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inicializa campos do SC2 com Custo em Partes no sistema    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MA330AvlCP(ExpL1)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 := Indica se o custo em partes esta habilitado ou nao³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XM330InC2CP(lCstPart)
Local _cCamp1Or :="C2_CPI"
Local _cCamp1Or1:=""
Local _cCamp1Ds :="C2_CPF"
Local _cCamp1Ds1:=""
Local _cCamp2Or :="C2_API"
Local _cCamp2Or1:=""
Local _cCamp2Ds :="C2_APF"
Local _cCamp2Ds1:=""
Local _nLoop1:=1
Local _nLoop2:=1
Local aArea:=GetArea()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava informacao do custo em partes no SC2           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC2")
For _nLoop1:=1 to Len(aRegraCP)+1
  For _nLoop2:=1 to 5
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Grava informacao do custo em partes no campo C2_CPF com³
    //³ o conteudo do campo C2_CPI.                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    _cCamp1Or1:=_cCamp1Or+Strzero(_nLoop1,2,0)+Strzero(_nLoop2,2,0)
    _cCamp1Ds1:=_cCamp1Ds+Strzero(_nLoop1,2,0)+Strzero(_nLoop2,2,0)
    FIELDPUT(FieldPos(_cCamp1Ds1),FieldGet(FieldPos(_cCamp1Or1)))
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Grava informacao do custo em partes no campo C2_APF com³
    //³ o conteudo do campo C2_API.                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    _cCamp2Or1:=_cCamp2Or+Strzero(_nLoop1,2,0)+Strzero(_nLoop2,2,0)
    _cCamp2Ds1:=_cCamp2Ds+Strzero(_nLoop1,2,0)+Strzero(_nLoop2,2,0)
    FIELDPUT(FieldPos(_cCamp2Ds1),FieldGet(FieldPos(_cCamp2Or1)))
  Next _nLoop2
Next _nLoop1
RestArea(aArea)
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PegaC2PFim³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 10/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pega os custos finais em parte de uma OP                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Variavel logica que indica se utiliza o custo em   ³±±
±±³          ³         partes ou nao                                      ³±±
±±³          ³ ExpN1 = Numero de custos possiveis                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION XPegaC2PFim(lCstPart,nRegras)
LOCAL aRetPartes:={}
LOCAL _cCampo := "C2_CPF"
LOCAL _nLoop0 :=0
LOCAL _nLoop1 :=0
LOCAL aArea   := GetArea()

If lCstPart
  dbSelectArea("SC2")
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Descobre informacao do custo em partes no SC2        ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  For _nLoop0:=1 to nRegras
    For _nLoop1:=1 to 5
      _cCampo     := "C2_CPF"
      _cCampo     :=_cCampo+Strzero(_nLoop0,2,0)+Strzero(_nLoop1,2,0)
      AADD(aRetPartes,FIELDGET(FieldPos(_cCampo)))
    Next _nLoop1
  Next _nLoop0
EndIf
RestArea(aArea)
RETURN aRetPartes

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PegaC2APF ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 18/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pega os custos apropriados finais em parte de uma OP       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Variavel logica que indica se utiliza o custo em   ³±±
±±³          ³         partes ou nao                                      ³±±
±±³          ³ ExpN1 = Numero de custos possiveis                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION XPegaC2APF(lCstPart,nRegras)
LOCAL aRetPartes:={}
LOCAL _cCampo := "C2_APF"
LOCAL _nLoop0 :=0
LOCAL _nLoop1 :=0
LOCAL aArea   := GetArea()

If lCstPart
  dbSelectArea("SC2")
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Descobre informacao do custo em partes no SC2        ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  For _nLoop0:=1 to nRegras
    For _nLoop1:=1 to 5
      _cCampo     := "C2_APF"
      _cCampo     :=_cCampo+Strzero(_nLoop0,2,0)+Strzero(_nLoop1,2,0)
      AADD(aRetPartes,FIELDGET(FieldPos(_cCampo)))
    Next _nLoop1
  Next _nLoop0
EndIf
RestArea(aArea)
RETURN aRetPartes

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA330LPart³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 25/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Indica o log dos arquivos nao criados                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA330                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function XMA330LPart(aLogsPart)
LOCAL oDlg,oQual,cVarq
DEFINE MSDIALOG oDlg TITLE STR0029 From 130,70 To 350,360 OF oMainWnd PIXEL //"Campo(s) nao criado(s) para Custo em Partes"
@ 10,13 TO 90,122
@ 20,18 LISTBOX oQual VAR cVarQ Fields HEADER STR0030,STR0031 SIZE 100,62 NOSCROLL OF oDlg PIXEL //"Arquivo"###"Campo"
oQual:SetArray(aLogsPart)
oQual:bLine := { || {aLogsPart[oQual:nAt,1],aLogsPart[oQual:nAt,2]}}
DEFINE SBUTTON FROM 95,90 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg PIXEL
ACTIVATE MSDIALOG oDlg
RETURN


Static Function xDetProva(nHdlPrv,cPadrao,cPrograma,cLote,nLinha,lExecuta,cCriterio,lRateio,cChaveBusca,aCT5)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na contabilizacao via CTB               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea      := GetArea()
Local aStruCT5   := CT5->(dbStruct())
Local aStruCTK   := CTK->(dbStruct())
Local aVlrCT5    := {}
Local cAliasCT5  := "CT5"
Local cQuery     := ""
Local cSeqChave  := ""
Local cCampoCTK  := ""
Local cCampoCT5  := ""
Local cValor     := ""
Local cHistorico := ""
Local cHist      := ""
Local lQuery     := .F.
Local nContador  := 0
Local nValor     := 0
Local nTotal     := 0
Local nPosCtk    := 0
Local nPosCt5    := 0
Local nPLanpad   := 0
Local nPSequen   := 0
Local nPSbLote   := 0
Local nPHist     := 0
Local nX         := 0
Local nY         := 0
Local nZ         := 0
Local nLen       := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas na contabilizacao via SIGACON           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aContas    := Array(30)
Local RetcProva  := {}
Local j          := 0
Local n          := 0
Local cSet       := ""
Local cValor1    := ""
Local cValor2    := ""
Local cValor3    := ""
Local cValor4    := ""
Local cValor5    := ""
Local cNitInt    := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o arquivo de de contra-prova foi criado correta- ³
//³ mente.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If __HeadProva[5] == -1
  Return(0)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os parametros default's da funcao                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRateio  := .F.
lExecuta := .T.
cCriterio:= Space(8)
nLinha   := 0
aCT5     := {}
PUBLIC LanceiCtb := .F.

cPrograma := PadR(AllTrim(UPPER(cPrograma)),10)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica qual o metodo de contabilizacao deve ser feito:     ³
//³ CTB ou CON.                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !CtbInUse()
  //ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
  // Fun‡„o de DETALHE no m¢dulo Cont bil - SIGACON
  // Grava‡„o dos Detalhes em Arquivo no Disco (\CPROVA)
  //ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
  cSet := Set(_SET_DATEFORMAT)
  Set(_SET_DATEFORMAT,"dd/mm/yyyy")
  /*/
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³               ARQUIVO DE LOG-LANC AUT                   ³
  ³               Mem¢ria de Calculos                       ³
  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³                 HEADER DO ARQUIVO                       ³
  ³ Descricao       Tamanho     Pos Ini     Pos Fim         ³
  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ Marca de In¡cio    002       001         002            ³
  ³ Data Base          010       003         013            ³
  ³ Lote               004       014         018            ³
  ³ Programa           008       019         027            ³
  ³ Operador           006       028         034            ³
  ³ Filial             002       035         037            ³
  ³ Filler             278       038         260            ³
  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³                 DETALHE DO ARQUIVO                      ³
  ³ Descricao       Tamanho     Pos Ini     Pos Fim         ³
  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³ Tipo Lancamento    001       001         001            ³
  ³ Codigo da Conta    020       002         021            ³
  ³ Contra Partida     020       022         041            ³
  ³ Valor Moeda 1      016       042         057            ³
  ³ Moedas             005       058         062            ³
  ³ Historico          040       063         102            ³
  ³ Valor Moeda 2      016       103         118            ³
  ³ Valor Moeda 3      016       119         134            ³
  ³ Valor Moeda 4      016       135         150            ³
  ³ Valor Moeda 5      016       151         166            ³
  ³ C Custo Debito     009       167         175            ³
  ³ C Custo Credito    009       176         184            ³
  ³ Cod/Seq Lanc Pad   005       185         189            ³
  ³ Data de Vencimento 010       190         199            ³
  ³ Origem do lanc.    040       200         239            ³
  ³ Ident Inter CP     001       240         240            ³
  ³ Nome do Programa   010       241         250            ³
  ³ Item Debito        009       251         259            ³
  ³ Item Credito       009       260         268            ³
  ³ Filler             042       269         310            ³
  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³                TOTALIZADOR DO ARQUIVO                   ³
  ³ Descricao       Tamanho     Pos Ini     Pos Fim         ³
  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
  ³  Valor Total       016       001         016            ³
  ³  Filler            294       017         300            ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  /*/
  DbSelectArea("SI5")
  dbSetOrder(1)
  DbSeek(cFilial+cPadrao)
  While !Eof() .And. I5_FILIAL == cFilial .And. cPadrao==I5_CODIGO

    aContas[1]:=I5_DC
    aContas[4] :=0
    aContas[7] :=0
    aContas[8] :=0
    aContas[9] :=0
    aContas[10]:=0

    cValor1 :=Trim(I5_CPOVAL1)
    cValor2 :=Trim(I5_CPOVAL2)
    cValor3 :=Trim(I5_CPOVAL3)
    cValor4 :=Trim(I5_CPOVAL4)
    cValor5 :=Trim(I5_CPOVAL5)
    If cPaisLoc == "COL" //Tratamento de Terceros - Local.Colombia
      cNitInt :=Trim(I5_NIT)
    Endif

    If cCriterio $ "FINA050/FINA100/FINA090"
      If lExecuta
        If AllTrim(Upper(cValor1)) == "VALOR" .or. "VLRINSTR" $ Upper(cValor1)
          DbSkip()
          Loop
        End
      EndIf
      If !lExecuta
        If ! (AllTrim(Upper(cValor1)) == "VALOR" .or. "VLRINSTR" $ Upper(cValor1))
          DbSkip()
          Loop
        End
      End
    End

    If !Empty(cValor1)
      aContas[4]:=&(cValor1)
    End
    If !Empty(cValor2)
      aContas[7]:=&(cValor2)
    EndIf
    If !Empty(cValor3)
      aContas[8]:=&(cValor3)
    EndIf
    If !Empty(cValor4)
      aContas[9]:=&(cValor4)
    EndIf
    If !Empty(cValor5)
      aContas[10]:=&(cValor5)
    EndIf

    If cPaisLoc == "COL" // Tratamento de Terceiros - Local.Colombia
      If !Empty(cNitInt)
        aContas[19]:=&(cNitInt)
      End
    Endif
    If GetMv("MV_CTVALZR") == "N"
      nValor := aContas[4]
    Else
      nValor := aContas[4]+aContas[7]+aContas[8]+aContas[9]+aContas[10]
    EndIf

    cHistorico:=AllTrim(TranslCta(I5_HISTORI,120))

    If (aContas[1] == "-" .Or. nValor > 0)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ VerIfica se na Conta devera estar o Debito ou Credito³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      aContas[2] :=TranslCta(I5_DEBITO, 20)  //Interpreta d‚bito
      aContas[3] :=TranslCta(I5_CREDITO,20)  //Interpreta cr‚dito
      aContas[17]:=TranslCta(I5_ITEMD,9)
      aContas[18]:=TranslCta(I5_ITEMC,9)

      If __HeadProva[5] == -5
        //
        // Cria o cabe‡alho do lan‡amento cont bil caso n„o tenha sido criado
        //
        RetcProva := xCriaCProva(__HeadProva[1],__HeadProva[2],__HeadProva[3])

        __HeadProva[4] := RetcProva[1]  // Nome do Arquivo
        __HeadProva[5] := RetcProva[2]  // Handle do Arquivo
      EndIf
      nHdlPrv := __HeadProva[5]

      aContas[5]:=I5_MOEDAS
      LanceiCtb := .T.
      If Len(cHistorico) > 40
        For n := 1 to Len(cHistorico) Step 40
          cHist := Substr(cHistorico,n,40)
          aContas[6] := cHist + Space(40 - Len(cHist))
          If n == 1
            aContas[11] :=TranslCta(I5_CCD, 9)      //Interpreta C.Custo D‚bito
            aContas[12] :=TranslCta(I5_CCC, 9)      //Interpreta C.Custo Cr‚dito
            aContas[13] :=I5_CODIGO+I5_SEQUENC
            aContas[14] :=TranslDta(I5_DTVENC)      //Interpreta data de vencimento
            aContas[15] :=TranslCta(I5_ORIGEM,40)   //Interpreta a origem
            aContas[16] :=Substr(I5_INTERCP,1,1)      //Inter Company
            aContas[17] :=TranslCta(I5_ITEMD,9)     // Item Debito
            aContas[18] :=TranslCta(I5_ITEMC,9)     // Item Credito
          Else
            aContas[1]  := "-"
            aContas[2]  := Space(20)
            aContas[3]  := Space(20)
            aContas[4]  := 0
            aContas[7]  := 0
            aContas[8]  := 0
            aContas[9]  := 0
            aContas[10] := 0
            aContas[11] := Space(9)
            aContas[12] := Space(9)
            aContas[13] := I5_CODIGO+I5_SEQUENC
            aContas[14] := TranslDta(I5_DTVENC)       //Interpreta data de vencimento
            aContas[15] := TranslCta(I5_ORIGEM,40)    //Interpreta a origem
            aContas[16] := Substr(I5_INTERCP,1,1)     //Inter Company
            aContas[17] := Space(9)
            aContas[18] := Space(9)
            If cPaisLoc ==  "COL" //Tratamento de Terceiros - Local.Colombia
              aContas[19] := Space(14)
            Endif
          EndIf
          If cPaisLoc == "COL" //Tratamento de Terceiros
            FWRITE(nHdlPrv,aContas[1]+aContas[2]+aContas[3]+;
            Str(aContas[4],16,2)+aContas[5]+aContas[6]+;
            Str(aContas[7],16,2)+Str(aContas[8],16,2)+;
            Str(aContas[9],16,2)+Str(aContas[10],16,2)+;
            aContas[11]+aContas[12]+aContas[13]+aContas[14]+;
            aContas[15]+aContas[16]+cPrograma+aContas[17]+;
            aContas[18]+aContas[19]+Space(28)+CHR(13)+CHR(10),312)
          Else
            FWRITE(nHdlPrv,aContas[1]+aContas[2]+aContas[3]+;
            Str(aContas[4],16,2)+aContas[5]+aContas[6]+;
            Str(aContas[7],16,2)+Str(aContas[8],16,2)+;
            Str(aContas[9],16,2)+Str(aContas[10],16,2)+;
            aContas[11]+aContas[12]+aContas[13]+aContas[14]+;
            aContas[15]+aContas[16]+cPrograma+aContas[17]+;
            aContas[18]+Space(42)+CHR(13)+CHR(10),312)
          Endif
          nTotal += nValor
        Next n
      Else
        aContas[6]  := cHistorico + Space(40 - Len(cHistorico))
        aContas[11] := TranslCta(I5_CCD, 9)     //Interpreta C.Custo D‚bito
        aContas[12] := TranslCta(I5_CCC, 9)     //Interpreta C.Custo Cr‚dito
        aContas[13] := I5_CODIGO+I5_SEQUENC
        aContas[14] := TranslDta(I5_DTVENC)  //Interpreta data de vencimento
        aContas[15] := TranslCta(I5_ORIGEM,40)    //Interpreta a origem
        aContas[16] := Substr(I5_INTERCP,1,1)   //Inter Company
        aContas[17] := TranslCta(I5_ITEMD,9)    //Item Debito
        aContas[18] := TranslCta(I5_ITEMC,9)    //Item Credito
        If cPaisLoc ==  "COL" //Tratamento de Terceiros - Local.Colombia
          FWRITE(nHdlPrv,aContas[1]+aContas[2]+aContas[3]+;
          Str(aContas[4],16,2)+aContas[5]+aContas[6]+;
          Str(aContas[7],16,2)+Str(aContas[8],16,2)+;
          Str(aContas[9],16,2)+Str(aContas[10],16,2)+;
          aContas[11]+aContas[12]+aContas[13]+aContas[14]+;
          aContas[15]+aContas[16]+cPrograma+aContas[17]+;
          aContas[18]+aContas[19]+Space(28)+CHR(13)+CHR(10),312)
        Else
          FWRITE(nHdlPrv,aContas[1]+aContas[2]+aContas[3]+;
          Str(aContas[4],16,2)+aContas[5]+aContas[6]+;
          Str(aContas[7],16,2)+Str(aContas[8],16,2)+;
          Str(aContas[9],16,2)+Str(aContas[10],16,2)+;
          aContas[11]+aContas[12]+aContas[13]+aContas[14]+;
          aContas[15]+aContas[16]+cPrograma+aContas[17]+;
          aContas[18]+Space(42)+CHR(13)+CHR(10),312)
        Endif
        nTotal+=nValor
      EndIf
    EndIf
    DbSelectArea("SI5")
    nLinha++
    DbSkip()
  EndDo
  Set(_SET_DATEFORMAT,cSet)
Else
  //ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
  //  Fun‡„o de DETALHE no m¢dulo SIGACTB -> Contabilidade Gerencial
  //  Grava‡„o dos dados na tabela CTK
  //ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verifica se a tabelas do SIGACTB estao disponiveis           ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If Select("CTK") == 0
    ChkFile("CTK")
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Arquivos de regras para drill down                           ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If cChaveBusca == Nil
    cChaveBusca := CtRelation(cPadrao)
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Pesquisa os lancamentos padroes a serem executados           ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  nX := aScan(aCT5,{|x| x[1] == cPadrao})
  If nX == 0
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Inicializa o array de otimizacao dos lancamentos padronizados³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aadd(aCT5,{cPadrao,{}})
    nX := Len(aCT5)

    DbSelectArea("CT5")
    dbSetOrder(1)
    #IFDEF TOP
      If TcSrvType()<>"AS/400"
        lQuery   := .T.
        cAliasCT5:= "DETPROVA"

        cQuery := ""
        For nY := 1 To Len(aStruCT5)
          cQuery += ","+aStruCT5[nY][1]
        Next nY
        cQuery := "SELECT "+SubStr(cQuery,2)+" "
        cQuery += "FROM "+RetSqlName("CT5")+" CT5 "
        cQuery += "WHERE CT5.CT5_FILIAL='"+xFilial("CT5")+"' AND "
        cQuery += "CT5.CT5_LANPAD='"+cPadrao+"' AND "
        cQuery += "CT5.D_E_L_E_T_=' ' "
        cQuery += "ORDER BY "+SqlOrder(CT5->(IndexKey()))

        cQuery := ChangeQuery(cQuery)

        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT5,.T.,.T.)

        For nY := 1 To Len(aStruCT5)
          If aStruCT5[nY][2] <> "C"
            TcSetField(cAliasCT5,aStruCT5[nY][1],aStruCT5[nY][2],aStruCT5[nY][3],aStruCT5[nY][4])
            EndIf
        Next nY
      Else
    #ENDIF
        MsSeek(xFilial("CT5")+cPadrao)
    #IFDEF TOP
      EndIf
    #ENDIF
    nZ := 0
    While !Eof() .And. (cAliasCT5)->CT5_FILIAL == xFilial("CT5") .And.;
      cPadrao == (cAliasCT5)->CT5_LANPAD

      nZ++
      aadd(aCT5[nX][2],{})
      For nY := 1 To (cAliasCT5)->(FCount())
        aadd(aCT5[nX][2][nZ],{(cAliasCT5)->(FieldName(nY)),(cAliasCT5)->(FieldGet(nY))})
      Next nY

      dbSelectArea(cAliasCT5)
      dbSkip()
    EndDo
    If lQuery
      dbSelectArea(cAliasCT5)
      dbCloseArea()
      dbSelectArea("CT5")
    EndIf
  EndIf
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Execucao dos lancamentos padronizados                        ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  nPLanpad   := aScan(aCT5[nX,2][1],{|x| x[1] == "CT5_LANPAD"})
  nPSequen   := aScan(aCT5[nX,2][1],{|x| x[1] == "CT5_SEQUEN"})
  nPSbLote   := aScan(aCT5[nX,2][1],{|x| x[1] == "CT5_SBLOTE"})
  nPHist     := aScan(aCT5[nX,2][1],{|x| x[1] == "CT5_HIST"})

  aVlrCT5 := Array(__nQuantas)

  For nY := 1 To Len(aCT5[nX,2])

    aVlrCT5   := AFill(aVlrCT5,0)
    nContador := 0

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se nao for continuacao de historico                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    nPosCT5 := aScan(aCT5[nX,2][nY],{|x| x[1] == "CT5_DC"})
    If aCT5[nX,2][nY][nPosCT5][2] <> "4"
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Verifica se existem valores a serem contabilizados.          ³
      //³                                                              ³
      //³ Como os valores podem ser expressoes complexas estes sao     ³
      //³ armazenados na variavel aVlrCt5 para que nao haja necessidade³
      //³ de serem executados novamente.                               ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      For nZ := 1 To __nQuantas
        nValor    := 0
        cCampoCT5 := "CT5_VLR"+StrZero(nZ,2)
        nPosCT5 := aScan(aCT5[nX,2][nY],{|x| x[1] == cCampoCT5 })
        If nPosCT5 > 0
          cValor := AllTrim(aCT5[nX,2][nY][nPosCT5][2])
          nValor := &(cValor)
          aVlrCT5[nZ] := nValor
          If Empty(nValor) .Or. nValor == 0
            nContador++
          Else
            nTotal += nValor
          EndIf
        EndIf
      Next nZ
    EndIf
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Se houver valores para contabilizar                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If nContador <> __nQuantas
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Cria semaforo para lancamento na tabela de contra-prova      ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If __HeadProva[5] == -5
        cSeqChave := GetSx8Num("CTK","CTK_SEQUEN",,1)
        __HeadProva[4] := cSeqChave   // Sequencia de Lan‡amento
        __HeadProva[5] := 1024      // Handle FIXO
      Else
        cSeqChave  := __HeadProva[4]
      EndIf
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Inicia a gravacao da tabela de contra-prova                  ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      DbSelectArea("CTK")
      DbSetOrder(1)
      RecLock("CTK",.T.)
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ As tabelas CTK e CT5 possuem campos comuns. Desta maneira    ³
      //³ devem ser repassado para os campos da tabela CTK os valores  ³
      //³ contidos nos campos da tabela CT5.                           ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      For nPosCtk := 1 To CTK->(FCount())
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Obtem o nome do campo de destino na tabela CTK               ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        cCampoCTK := CTK->(FieldName(nPosCTK))
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Obtem o nome do campo de origem na tabela CT5                ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        cCampoCT5 := "CT5_" + SubStr(cCampoCTK,5)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Transfere os valores do campo                                ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        nPosCT5 := aScan(aCT5[nX,2][nY],{|x| x[1] == cCampoCT5 })
        If nPosCT5 > 0
          Do Case
            Case SubStr(cCampoCT5,1,7)=="CT5_VLR"
              nValor := Val(SubStr(cCampoCT5,8,2))
              If nValor <= Len(aVlrCT5)
                CTK->(FieldPut(nPosCTK,aVlrCT5[nValor]))
              EndIf
            Case aStruCTK[nPosCTK][2] == "N"
              cValor  := AllTrim(aCT5[nX,2][nY][nPosCT5][2])
              If !Empty(cValor)
                nValor := &(cValor)
                CTK->(FieldPut(nPosCTK,nValor))
              Else
                CTK->(FieldPut(nPosCTK,0))
              EndIf
            Case aStruCTK[nPosCTK][2] == "C"
              If cCampoCT5 == "CT5_SBLOTE"
                cValor := aCT5[nX,2][nY][nPosCT5][2]
              Else
                cValor := AllTrim(TransLcta(aCT5[nX,2][nY][nPosCT5][2],aStruCTK[nPosCTK][3]))
              EndIf
              CTK->(FieldPut(nPosCTK,cValor))
            Case aStruCTK[nPosCTK][2] == "D"
              cValor := Ctod(AllTrim(TranslDta(aCT5[nX,2][nY][nPosCT5][2])))
              cValor := IIf(Empty(cValor),Ctod(""),cValor)
              CTK->(FieldPut(nPosCTK,cValor))
          EndCase
        EndIf
      Next nPosCTK
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Grava os campos nao relacionados com a tabela CT5            ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If lRateio
        CTK->CTK_CONTAB := "4"  // Contabilizacao de Rateio Contas a Pagar
      Else
        CTK->CTK_CONTAB := "2"  // Contabilizado automaticamente
      EndIf
      CTK->CTK_FILIAL := xFilial("CTK")
      CTK->CTK_ROTINA := FunName()
      CTK->CTK_KEY  := cChaveBusca
      CTK->CTK_LP   := aCT5[nX,2][nY][nPLanPad][2]
      CTK->CTK_LPSEQ  := aCT5[nX,2][nY][nPSequen][2]
      CTK->CTK_SEQUEN := cSeqChave
      CTK->CTK_SBLOTE := aCT5[nX,2][nY][nPSbLote][2]
      CTK->CTK_DATA := dDataBase
      CTK->CTK_LOTE := cLote
      If __lSx8
        ConfirmSX8()
      EndIf
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Verifica se havera quebra de historico                       ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If nPHist > 0 .And. CTK->(FieldPos("CTK_HIST")) > 0
        cHistorico  := AllTrim(TransLcta(aCT5[nX,2][nY][nPHist][2],250))
        nLen := Len(CTK->CTK_HIST)
        If Len(cHistorico) > nLen
          For nZ := nLen + 1 To Len(cHistorico) Step nLen
            cHist := SubStr(cHistorico,nZ,nLen)
            RecLock("CTK",.T.)
            CTK->CTK_DC     := "4"
            CTK->CTK_HIST   := cHist
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Grava os campos nao relacionados com a tabela CT5            ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If lRateio
              CTK->CTK_CONTAB := "4"          // Contabilizacao de Rateio Contas a Pagar
            Else
              CTK->CTK_CONTAB := "2"          // Contabilizado automaticamente
            EndIf
            CTK->CTK_FILIAL := xFilial("CTK")
            CTK->CTK_ROTINA := FunName()
            CTK->CTK_KEY  := cChaveBusca
            CTK->CTK_LP   := aCT5[nX,2][nY][nPLanPad][2]
            CTK->CTK_LPSEQ  := aCT5[nX,2][nY][nPSequen][2]
            CTK->CTK_SEQUEN := cSeqChave
            CTK->CTK_SBLOTE := aCT5[nX,2][nY][nPSbLote][2]
            CTK->CTK_DATA := dDataBase
            CTK->CTK_LOTE := cLote
          Next nZ
        EndIf
      EndIf

      LanceiCtb := .T.

    EndIf
  Next nY
EndIf
RestArea(aArea)
Return(nTotal)


Static Function XHeadProva(cLote,cPrograma,cOperador,cArquivo,lCria)
Local nRetHandle := 65536 // NAO MEXA NESTE NUMERO
Local aRetHead   := {}


//
// Elementos de __HeadProva
// [1] Lote cont bil
// [2] Programa
// [3] Operador
// [4] Nome do Arquivo no CProva
// [5] Handle do Arquivo  -5    Inicializa‡„o
//                  -1    Erro
//                  n >= 0  Arquivo gerado.
//

__HeadProva := {cLote,cPrograma,cOperador,"", -5 }
lCria       := If( lCria = NIL , .f. , lCria )

If !CtbInUse()    // M¢dulo SIGACON

  If lCria
    aRetHead := xCriaCProva(cLote,cPrograma,cOperador)
    __HeadProva[4] := aRetHead[1] // Nome do Arquivo
    cArquivo       := aRetHead[1] // Nome do Arquivo (X Referˆncia)
    __HeadProva[5] := aRetHead[2] // Handle do Arquivo
    nRetHandle    := aRetHead[2] // Handle do Arquivo
  EndIf

Else              // M¢dulo SIGACTB

  IF lCria
    // AQUI! No SIGACTB n„o vai criar cProva ! N„o pode for‡ar cria‡„o
    alert("HeadProva n„o pode for‡ar cria‡„o de Arquivo")
  Endif

Endif

Return nRetHandle


****************
Static Function xCriaCProva(cLote,cPrograma,cOperador)


Local cData, cAlias
Local aArquivos,cProva
Local nTrys:=0, cNum
Local cSet, nRet, aOpcoes
Local nHdlPrv := -1
Local cArquivo:=""

cSet := Set(_SET_DATEFORMAT)
Set(_SET_DATEFORMAT,"dd/mm/yyyy")

cData := DTOC(dDataBase)

If ExistBlock("LOTECONT")
  cLote := ExecBlock("LOTECONT",.F.,.F.,{cPrograma})
EndIf

cProva   := GetMv("MV_PROVA")
cNum     := GetSX8Num("CPR")

cPrograma := SubStr(cPrograma+Space(8-Len(cPrograma)),1,8)

cArquivo:=cProva+"SP"+cEmpAnt+cNum+".LAN"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo de LOG para LA                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdlPrv:=MSFCREATE(cArquivo,0)

nTrys := 0
DO While nHdlPrv < 0
  nTrys++
  If nTrys > 60
    If MsgYesNo(OemToAnsi(STR0025),OemtoAnsi(STR0026))
      nTrys := 0
      Loop
    Else
      RollBackSX8()
      HELP(" ",1,"HDLNAOGERA")
      Exit
    EndIf
  EndIf
  Inkey(.5)
  nHdlPrv:=MSFCREATE(cArquivo,0)
End

If nHdlPrv >= 0
  FWRITE(nHdlPrv,"00"+cData+cLote+cPrograma+cOperador+cFilial+Space(278)+CHR(13)+CHR(10),312)
  ConfirmSX8()
  Commit
EndIf

Set(_SET_DATEFORMAT,cSet)

Return {cArquivo,nHdlPrv}
*/


User Function EST001()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("LFLAG,NANOEXERC,NREGTOT,NPRODUCAO,APRODUCAO,NPESQ")
SetPrvt("CTIPOOC,X,NSALDOD,NSALDOI,NVALTOT,CCOD,NC_TOTAL")
SetPrvt("NC_VAR,NC_FIXOD,NC_FIXOI,SAIR,NPOS,NREG,nVAL1,nVAL2")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Est001    ³ Autor ³ Silvano Araujo        ³ Data ³ 28/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina Calculo do Custo de Producao - Rava Embalagens Ltda  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
mv_par01 - Data inicial do periodo
mv_par02 - Data final do periodo
mv_par03 - Periodo a processar
mv_par04 - 1 - Gerar 2 - Cancelar
/*/


Pergunte("EST001",.t.)               // Pergunta no SX1
@ 0,0 TO 50,300 DIALOG oDlg1 TITLE "Calculo do Custo de Producao"
@ 10,020 BMPBUTTON TYPE 5 ACTION Pergunte("EST001")
@ 10,060 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> @ 10,060 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 10,100 BMPBUTTON TYPE 2 ACTION Close( oDlg1 )
ACTIVATE DIALOG oDlg1 CENTER
Return


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function OkProc
Static Function OkProc()

lFlag := MsgBox ("Confirma Calculo do Custo","Escolha","YESNO")
if ! lFlag
   Return
endif

Close(oDlg1)
Processa( {|| CalcCusto() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Processa( {|| Execute(CalcCusto) } )
Return



// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Rotina de Calculo do Custo de Producao.                      ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function CalcCusto
Static Function CalcCusto()

SX6->( dbSeek( xFilial( "SX6" ) + "MV_EXERC1" ) )
If Alltrim( SX6->X6_VAR ) == "MV_EXERC1"
   nAnoExerc := Val( Alltrim( SX6->X6_CONTEUD ) )
else
   MsgBox( "Parametro MV_EXERC1 nao Localizado","INFO","STOP")
   Return
endif

if mv_par04 == 2  // Apaga lancamentos

   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   // ³ Cancelamento do Calculo do Custo de Producao.                ³
   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   SZX->( dbSetOrder( 1 ) )
   SZX->( dbseek( xFilial( "SZX" ) + mv_par03, .T. ) )
   nRegTot := SZX->( LastRec() )
   ProcRegua( SZX->( Lastrec() ) )

   Do While SZX->ZX_PERIODO == mv_par03 .and. SZX->( !Eof() )

      if Reclock( "SZX", .F. )
         SZX->( dbdelete() )
         SZX->( dbunlock() )
      endif
      SZX->( dbskip() )
      IncProc()

   EndDo

   Return Nil
endif

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Calculo do custo variavel.                                   ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SZX->( dbSetOrder( 3 ) )
SD3->( dbsetorder( 6 ) )
SD3->( dbseek( xFilial( "SD3" )+Dtos( mv_par02 + 1 ), .T. ) )
nREG     := SD3->( Recno() )
SD3->( dbseek( xFilial( "SD3" )+Dtos( mv_par01 ), .T. ) )
nRegTot  := nREG - SD3->( Recno() )

ProcRegua( nRegTot )
nProducao := 0
aProducao := {}

Do While SD3->( !Eof() ) .and. SD3->D3_EMISSAO <= mv_par02
   If !Empty( SD3->D3_OP )
      if SD3->D3_TIPO=="PA"
         // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         // ³ Calculo do total producao do produto acabado.                ³
         // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         nProducao := nProducao + SD3->D3_QUANT
         nPesq := ASCAN( aProducao, { |x| x[1] == SD3->D3_COD } )
         if nPesq == 0
            Aadd( aProducao, { SD3->D3_COD, SD3->D3_QUANT, SD3->D3_QTSEGUM, 0 } )
         else
            aProducao[ nPesq, 2 ] += SD3->D3_QUANT
            aProducao[ nPesq, 3 ] += SD3->D3_QTSEGUM
         endif
      else
         SC2->( dbseek( xFilial( "SC2" ) + Substr( SD3->D3_OP, 1, 8), .T. ) )
         SZX->( dbSeek( xFilial( "SZX" ) + mv_par03 + SC2->C2_PRODUTO + SD3->D3_COD, .T. ) )
         if Substr( SD3->D3_OP, 9, 3 ) == "001"
            if SZX->ZX_PERIODO + SZX->ZX_COD + SZX->ZX_CC_PROD <> mv_par03 + SC2->C2_PRODUTO + SD3->D3_COD
               cTipoOc := If( SD3->D3_TIPO == "MP", "1A", "1B" )
               Reclock( "SZX", .T. )
               SZX->ZX_FILIAL  := xFilial( "SZX" ); SZX->ZX_COD    := SC2->C2_PRODUTO
               SZX->ZX_PERIODO := mv_par03
               SZX->ZX_TIPO_OC := cTipoOc        ; SZX->ZX_CC_PROD := SD3->D3_COD
               SZX->ZX_CONSUMO := SD3->D3_QUANT  ; SZX->ZX_VALTOT  := SD3->D3_CUSTO1
            else
               Reclock( "SZX", .F. )
               SZX->ZX_CONSUMO += SD3->D3_QUANT
               SZX->ZX_VALTOT  += SD3->D3_CUSTO1
            endif
            SZX->( MsUnlock() )
            SZX->( dbCommit() )
         endif
      endif
   endif
   SD3->( dbskip() )
   IncProc()
EndDo

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Calculo do percentual do produto dentro do total da producao.³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua( Len( aProducao ) )
for x := 1 to Len( aProducao )
*    aProducao[ x, 4 ] := Round( aProducao[ x, 2 ] * 100 / nProducao, 2 )
    aProducao[ x, 4 ] := aProducao[ x, 2 ] * 100 / nProducao
    IncProc()
Next

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Calculo do custo fixo                                        ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SZX->( dbSetOrder( 1 ) )
ProcRegua( Len( aProducao ) )
For x := 1 to Len( aProducao )
    SI1->( dbSeek( xFilial( "SI1" ) + "4712", .T. ) )
    Do While Substr( SI1->I1_CODIGO, 1, 3 ) <= "4799" .and. SI1->( ! Eof() )
       cMES1   := Substr( mv_par03, 1, 2 )
       cMES2   := StrZero( Val( cMES1 ) + 12, 2 )
       nSALDOI := 0
       nSALDOD := 0
       if Val( Substr( mv_par03, 4, 4 ) ) == nAnoExerc
          If SubStr( SI1->I1_CODIGO, 9, 2 ) $ "00*20"    // Indireto
             nSaldoi := if(SI1->I1_NORMAL=="D",&("SI1->I1_DEBM"+cMES1)-&("SI1->I1_CRDM"+cMES1),&("SI1->I1_CRDM"+cMES1)-&("SI1->I1_DEBM"+cMES1))
          ElseIf SubStr( SI1->I1_CODIGO, 9, 2 ) == "10"  // Direto
             nSaldod := if(SI1->I1_NORMAL=="D",&("SI1->I1_DEBM"+cMES1)-&("SI1->I1_CRDM"+cMES1),&("SI1->I1_CRDM"+cMES1)-&("SI1->I1_DEBM"+cMES1))
          EndIf
       elseIf cMES2 <= "17"
          If SubStr( SI1->I1_CODIGO, 9, 2 ) $ "00*20"    // Indireto
             nSaldoi := if(SI1->I1_NORMAL=="D",&("SI1->I1_DEBM"+cMES2)-&("SI1->I1_CRDM"+cMES2),&("SI1->I1_CRDM"+cMES2)-&("SI1->I1_DEBM"+cMES2))
          ElseIf SubStr( SI1->I1_CODIGO, 9, 2 ) == "10"  // Direto
             nSaldod := if(SI1->I1_NORMAL=="D",&("SI1->I1_DEBM"+cMES2)-&("SI1->I1_CRDM"+cMES2),&("SI1->I1_CRDM"+cMES2)-&("SI1->I1_DEBM"+cMES2))
          EndIf
       endif
       If ! Empty( nSALDOD )
*          nValTot := Round( nSaldod * aProducao[ x, 4 ] / 100, 2 )
          nValTot := nSaldod * aProducao[ x, 4 ] / 100
          Reclock( "SZX", .T. )
          SZX->ZX_FILIAL := xFilial( "SZX" ); SZX->ZX_COD     := aProducao[ x, 1 ]
          SZX->ZX_PERIODO:= mv_Par03        ; SZX->ZX_CONTA   := SI1->I1_CODIGO
          SZX->ZX_TIPO_OC:= "2A"            ; SZX->ZX_CC_PROD := SI1->I1_CODIGO
          SZX->ZX_CONSUMO:= 0               ; SZX->ZX_VALTOT  := nValTot
          SZX->ZX_PRODUC := aProducao[ x, 2 ] ; SZX->ZX_PRODUC2 := aProducao[ x, 3 ]
          SZX->( dbunlock() )
       EndIf
       If ! Empty( nSALDOI )
*          nValTot := Round( nSaldoi * aProducao[ x, 4 ] / 100, 2 )
          nValTot := nSaldoi * aProducao[ x, 4 ] / 100
          Reclock( "SZX", .T. )
          SZX->ZX_FILIAL := xFilial( "SZX" ); SZX->ZX_COD     := aProducao[ x, 1 ]
          SZX->ZX_PERIODO:= mv_Par03        ; SZX->ZX_CONTA   := SI1->I1_CODIGO
          SZX->ZX_TIPO_OC:= "3A"            ; SZX->ZX_CC_PROD := SI1->I1_CODIGO
          SZX->ZX_CONSUMO:= 0               ; SZX->ZX_VALTOT  := nValTot
          SZX->ZX_PRODUC := aProducao[ x, 2 ] ; SZX->ZX_PRODUC2 := aProducao[ x, 3 ]
          SZX->( dbunlock() )
       EndIf
       SI1->( dbSkip() )
   EndDo
   IncProc()
Next


// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Gerando ocorrencias de totais.                               ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SZX->( dbSetOrder( 2 ) )
SZX->( dbseek( xFilial( "SZX" ) + mv_par03, .T. ) )
ProcRegua( SZX->( lastrec() ) - SZX->( recno() ) )

Do while SZX->ZX_PERIODO == mv_par03 .and. SZX->( !eof() )
   cCOD     := SZX->ZX_COD
   nC_TOTAL := nC_VAR := nC_FIXOD := nC_FIXOI := 0
   Do while SZX->ZX_PERIODO == mv_par03 .and. SZX->ZX_COD == cCOD .and. SZX->( !eof() )
      nC_TOTAL := nC_TOTAL + SZX->ZX_VALTOT
      if Substr( SZX->ZX_TIPO_OC,1,1) == "1"
         nC_VAR   := nC_VAR   + SZX->ZX_VALTOT
      elseif Substr(SZX->ZX_TIPO_OC,1,1) == "2"
         nC_FIXOD := nC_FIXOD + SZX->ZX_VALTOT
      elseif Substr(SZX->ZX_TIPO_OC,1,1) == "3"
         nC_FIXOI := nC_FIXOI + SZX->ZX_VALTOT
      endif
      SZX->( dbskip() )
      IncProc()
   endDo
*   nC_TOTAL := ROUND( nC_TOTAL, 2 )
*   nC_VAR   := ROUND( nC_VAR, 2 )
*   nC_FIXOD := ROUND( nC_FIXOD, 2 )
*   nC_FIXOI := ROUND( nC_FIXOI, 2 )
   nC_TOTAL := nC_TOTAL
   nC_VAR   := nC_VAR
   nC_FIXOD := nC_FIXOD
   nC_FIXOI := nC_FIXOI
   SAIR  := SZX->( Eof() )
   nPOS  := SZX->( Recno() )
   nPesq := Ascan( aProducao, { |x| x[1] == cCOD } )
   For x := 1 to 4
       Reclock( "SZX", .T. )
       SZX->ZX_FILIAL  := "01"           ; SZX->ZX_COD     := cCOD
       SZX->ZX_PERIODO := mv_Par03       ; SZX->ZX_CONSUMO := 0
       SZX->ZX_PRODUC  := IIF( nPesq <> 0, aProducao[ nPesq, 2 ], 0 )
       SZX->ZX_PRODUC2 := IIF( nPesq <> 0, aProducao[ nPesq, 3 ], 0 )
       if X == 1
          SZX->ZX_TIPO_OC := " " ; SZX->ZX_VALTOT := nC_TOTAL
          If ! Empty( IIF( nPesq <> 0, aProducao[ nPesq, 2 ], 0 ) )
             SB2->( DbSeek( xFILIAL( "SB2" ) + cCOD + "01" ) )
             Reclock( "SB2", .F. )
             SB2->B2_CM1   := nC_TOTAL / aProducao[ nPesq, 2 ]
             SB2->B2_VATU1 := ( nC_TOTAL / aProducao[ nPesq, 2 ] ) * SB2->B2_QATU
             SB2->B2_VFIM1 := ( nC_TOTAL / aProducao[ nPesq, 2 ] ) * SB2->B2_QFIM
             SB2->( MsUnlock() )
             SB2->( dbCommit() )
          EndIf
       elseif X == 2
          SZX->ZX_TIPO_OC := "1" ; SZX->ZX_VALTOT  := nC_VAR
       elseif X == 3
          SZX->ZX_TIPO_OC := "2" ; SZX->ZX_VALTOT  := nC_FIXOD
       elseif X == 4
          SZX->ZX_TIPO_OC := "3" ; SZX->ZX_VALTOT  := nC_FIXOI
       endif
       SZX->( MsUnlock() )
       SZX->( dbCommit() )
   Next

   // Gerar lancamento contabil do custo mensal


   // ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //   Calculando percentual de participacao                        ³
   // ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   SZX->( dbSeek( xFilial( "SZX" ) + mv_par03 + cCod, .t. ) )
   Do While SZX->ZX_PERIODO == mv_par03 .and. SZX->ZX_COD == cCOD .and. SZX->( !eof() )
      RecLock( "SZX", .F. )
 *      SZX->ZX_PARTIC := Round( Iif( SZX->ZX_VALTOT==0,0,SZX->ZX_VALTOT/nC_TOTAL*100 ), 2 )
      SZX->ZX_PARTIC := Iif( SZX->ZX_VALTOT == 0, 0, SZX->ZX_VALTOT / nC_TOTAL * 100 )
      SZX->( MsUnlock() )
      SZX->( dbCommit() )
      SZX->( dbskip() )
   endDo
   IF Sair
      Exit
   else
      SZX->( dbGoto( nPos ) )
   endif
endDo

/*/
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Calculando percentual de participacao                        ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SZX->( dbseek( xFilial( "SZX" ) + mv_par03, .T. ) )
ProcRegua( SZX->( Lastrec() ) - SZX->( Recno() ) )

while SZX->ZX_PERIODO == mv_par03 .and. SZX->( !eof() )

   cCOD     := SZX->ZX_COD
   nC_TOTAL := SZX->ZX_VALTOT

   while SZX->ZX_PERIODO == mv_Par03 .and. SZX->ZX_COD == cCOD .and. SZX->( !eof() )

      Reclock( "SZX",.F.)
      SZX->ZX_PARTIC := Round( iif( SZX->ZX_VALTOT==0,0,SZX->ZX_VALTOT*100/nC_TOTAL ), 4 )
      SZX->( MsUnlock() )
      SZX->( dbCommit() )
      SZX->( dbskip() )

      IncProc()

   end

end
/*/

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Incluir lancamento contabil da apuracao do custo
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
nVAL1    := SomaMovim( "4711", "4719", Val( Left( MV_PAR03, 2 ) ), 1 )  // Variaveis usadas no lancamento padrao
nVAL2    := Saldo( "1131010002", If( Val( Left( MV_PAR03, 2 ) ) == 1, 12, Val( Left( MV_PAR03, 2 ) ) - 1 ), 1 )
cLOTE    := StrZero( Month( MV_PAR02 ), 2 ) + StrZero( Day( MV_PAR02 ), 2 )
cARQUIVO := ""
nTOTAL   := 0
lMOSTRA  := .F.
lAGLUT   := .F.

nHDLPRV  := HeadProva( cLOTE, "EST001", Substr( cUSUARIO, 7, 6 ), @cARQUIVO )
nTOTAL   += DetProva( nHDLPRV, "Z01", "EST001", cLOTE )
RodaProva( nHDLPRV, nTOTAL )
cA100incl( cARQUIVO, nHDLPRV, 3, cLOTE, lMOSTRA, lAGLUT )

SD2->( dbSetOrder( 5 ) )
SD2->( DbSeek( xFilial( "SD2" ) + Dtos( MV_PAR01 ), .T. ) )
While SD2->D2_EMISSAO <= MV_PAR02 .and. SD2->( ! Eof() )
   nVAL1 := 0
   cDOC  := SD2->D2_DOC
   cSER  := SD2->D2_SERIE
   Do While SD2->D2_DOC + SD2->D2_SERIE == cDOC + cSER
      If SD2->D2_TES $ "501/505/508"
         nCONT := 0
         cPER  := mv_par03
         Do While ! SZX->( dbseek( xFilial( "SZX" ) + cPER + SD2->D2_COD + "  " ) ) .and. nCONT <= 12
            nCONT++
            nPER := Val( Left( cPER, 2 ) ) - 1
            If nPER == 0
               cPER := "12/" + StrZero( Val( Right( cPER, 4 ) ) - 1, 4 )
            Else
               cPER := StrZero( nPER, 2 ) + Right( cPER, 5 )
            EndIf
         EndDo
         If nCONT == 12
            SD2->( dbSkip() )
            Loop
         EndIf
         RecLock( "SD2", .F. )
         SD2->D2_CUSTO1 := Round( SD2->D2_QUANT * ( SZX->ZX_VALTOT / SZX->ZX_PRODUC ), 2 )
         nVAL1 += SD2->D2_CUSTO1
         SD2->( MsUnlock() )
         SD2->( dbCommit() )
      EndIf
      SD2->( dbSkip() )
   EndDo
   cARQUIVO := ""
   nTOTAL   := 0

   nHDLPRV  := HeadProva( cLOTE, "EST001", Substr( cUSUARIO, 7, 6 ), @cARQUIVO )
   nTOTAL   += DetProva( nHDLPRV, "Z02", "EST001", cLOTE )
   RodaProva( nHDLPRV, nTOTAL )
   cA100incl( cARQUIVO, nHDLPRV, 3, cLOTE, lMOSTRA, lAGLUT )
EndDo
*/
RetIndex( "SZX" )
RetIndex( "SD3" )
return NIL
