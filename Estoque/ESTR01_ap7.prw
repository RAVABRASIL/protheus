#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTR01()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,CDESC1,CDESC2,CDESC3,CNATUREZA")
SetPrvt("ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA,NLIN")
SetPrvt("WNREL,M_PAG,NTAMNF,CSTRING,TITULO,CARQUIVO")
SetPrvt("NTOTAL,CLOTEPRO,NHDLPRV,CABEC1,CABEC2,NFIM")
SetPrvt("NREGTOT,NTOT_CUST,NTOT_QTD,NCUSTOFIXO,NCUSTOVAR,ASINTETICO")
SetPrvt("CPERIODO,CCOD,CDESC,NPROD2,NPRODUCAO,NVALTOT")
SetPrvt("NCUSTUNIT,NCONS_KG,NVALUNIT,NPESQ,ASINT,X")
SetPrvt("NPARTIC,AROTINA,LLANC,LAGLUT,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CONRCP    ³ Autor ³ Silvano Araujo        ³ Data ³ 26.08.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Relatorio de Custo de Producao                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Parametros do Relatorio
mv_par01 = Produto Inicial
mv_par02 = Produto Final
mv_par03 = Periodo Inicial
mv_par04 = Periodo Final
mv_par05 = Tipo do Relatorio 1-Analitico, 2-Sintetico ou 3-Ambos
mv_par06 = 1- Gerar Requisicao 2-Nao Gerar req. 3-Cancelar Req.
mv_par07 = Data Lanc. Custo Medio
mv_par08 = Apresentar a producao em 1¦ ou 2¦ unidade de medida
mv_par09 = NUmero do fornecedor padrao para lancamento de custo de producao
mv_par10 = Nuemro do Tes padrao para lancamento do custo de producao
mv_par11 = Mostra lancamento contabil 1-Sim ou 2-Nao
*/

CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="M"
limite:=254

cDesc1 :=PADC("Este programa ira Emitir Relatorio de Custo de Producao",74)
cDesc2 :=PADC("bem com a geracao de ocorrencia para calculo do custo medio",74)
cDesc3 :=PADC("do produto.",74)
cNatureza:=""
aReturn := { "Estoque/Custos", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="ESTR01"
cPerg:="ESTR01"
nLastKey:= 0
lContinua := .T.
nLin:=9
wnrel    := "ESTR01"
M_PAG    := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tamanho do Formulario de Nota Fiscal (em Linhas)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTamNf:=72     // Apenas Informativo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SZX"
titulo :=PADC("Relatorio de Custo de Producao",74)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
nLin     := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("ESTR01",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="ESTR01"            //Nome Default do relatorio em Disco

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


cArquivo := ""; nTotal := 0

if mv_par06 == 1
   SX5->( dbSeek( xFilial( "SX5" ) + "09PRO", .t. ) )
   cLotePRO := Alltrim( SX5->X5_DESCRI )
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Funcoes para lancamento padrao                               ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   nHdlPrv := HeadProva( cLotePRO, "ESTR01", Substr( cUsuario, 7, 6 ), @cArquivo )
endif

titulo      :="Relatorio de Custo de Producao"
cabec1      :="Cod.Item    Descricao                 UM.      CONSUMO    CONS/Kg  Val.Unit   Custo Total   C.Unit. %Part."
cabec2      :=""

m_PAG:= 1     //Variavel que acumula o numero de pagina
NOMEPROG:="ESTR01"     //Nome do relatorio em Disco

dbSelectarea( "SZX" )
SZX->( dbSetorder( 2 ) )
dbseek( xFilial("SZX") + mv_par04 + mv_par02, .T. )
nFIM := nREGTOT := recno()
dbseek( xFilial("SZX") + mv_par03 + mv_par01, .T. )
SetRegua( nRegtot - SZX->( Recno() ) )

nTot_Cust  := nTot_Qtd := nCustoFixo := nCustoVar := 0
aSintetico := {}
nLin       := 0

while SZX->ZX_PERIODO <= mv_par04 .AND. SZX->ZX_COD <= mv_par02 .AND. SZX->( ! eof() )

   nLin     := IF(mv_par05==2,nLin,61)
   cPeriodo := SZX->ZX_PERIODO
   cCod     := SZX->ZX_COD
   SB1->( dbseek( xFilial( "SB1" ) + cCod, .t. ) )
   cDesc    := SB1->B1_DESC
   nProducao:= If( MV_PAR08 == 1, SZX->ZX_PRODUC, SZX->ZX_PRODUC2 )
   nValtot  := SZX->ZX_VALTOT

   while SZX->ZX_PERIODO == cPeriodo .and. SZX->ZX_COD == cCod .and. SZX->( !Eof() )

      if nLin > 60
         nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15) + 1 //Impressao do cabecalho
         @ nLin  , 00 pSay "Periodo..: " + cPeriodo
         @ nLin  , 00 pSay "Periodo..: " + cPeriodo
         @ nLin+1, 00 pSay "Produto..: " + cCod + cDesc
         @ nLin+1, 00 pSay "Produto..: " + cCod + cDesc
         @ nLin+2, 00 pSay "Producao (Kg).: "
         @ nLin+2, 17 pSay nPRODUCAO Picture "@E 999,999,999.99"
         @ nLin+2, 00 pSay "Producao (Kg).: "
         @ nLin+2, 17 pSay nPRODUCAO Picture "@E 999,999,999.99"
         nLin := nLin + 4

      endif

      SB1->( dbSeek( xFilial( "SB1" ) + SZX->ZX_CC_PROD ) )
      SI1->( dbSeek( xFILIAL( "SI1" ) + SZX->ZX_CONTA, .T. ) )

      if SZX->ZX_TIPO_OC == "  "
         if mv_par05 == 1 .OR. mv_par05 == 3
            nLin := nLin + 1
            @ nLin,012 pSay "CUSTO TOTAL ( VAR + FIXO )"
            nCustUnit := SZX->ZX_VALTOT / nPRODUCAO
            @ nLin,075 pSay SZX->ZX_VALTOT Picture "@E 999,999,999.99"
            @ nLin,090 pSay nCustUnit      Picture "@E 9,999.999"
            @ nLin,100 pSay SZX->ZX_PARTIC Picture "@E 999.99"
            nLin := nLin + 1
         endif
         nTot_Cust := nTot_Cust + SZX->ZX_VALTOT
         nTot_Qtd  := nTot_Qtd  + nPRODUCAO
      elseif SZX->ZX_TIPO_OC == "1 "
         nCustoVar := nCustoVar + SZX->ZX_VALTOT
         if mv_par05 == 1 .OR. mv_par05 == 3
            nLin := nLin + 1
            @ nLin,012 pSay "CUSTO VARIAVEL"
            nCustUnit := SZX->ZX_VALTOT / nPRODUCAO
            @ nLin,075 pSay SZX->ZX_VALTOT Picture "@E 999,999,999.99"
            @ nLin,090 pSay nCustUnit      Picture "@E 9,999.999"
            @ nLin,100 pSay SZX->ZX_PARTIC Picture "@E 999.99"
            nLin := nLin + 1
         endif
      elseif SZX->ZX_TIPO_OC == "2 "
         nCustoFixo := nCustoFixo + SZX->ZX_VALTOT
         if mv_par05 == 1 .OR. mv_par05 == 3
            nLin := nLin + 1
            @ nLin,012 pSay "CUSTO FIXO DIRETO"
            nCustUnit := SZX->ZX_VALTOT / nPRODUCAO
            @ nLin,075 pSay SZX->ZX_VALTOT Picture "@E 999,999,999.99"
            @ nLin,090 pSay nCustUnit      Picture "@E 9,999.999"
            @ nLin,100 pSay SZX->ZX_PARTIC Picture "@E 999.99"
            nLin := nLin + 1
         endif
      elseif SZX->ZX_TIPO_OC == "3 "
         nCustoFixo := nCustoFixo + SZX->ZX_VALTOT
         if mv_par05 == 1 .OR. mv_par05 == 3
            nLin := nLin + 1
            @ nLin,012 pSay "CUSTO FIXO INDIRETO"
            nCustUnit := SZX->ZX_VALTOT / nPRODUCAO
            @ nLin,075 pSay SZX->ZX_VALTOT Picture "@E 999,999,999.99"
            @ nLin,090 pSay nCustUnit      Picture "@E 9,999.999"
            @ nLin,100 pSay SZX->ZX_PARTIC Picture "@E 999.99"
            nLin := nLin + 1
         endif
      else

         if mv_par05==1.or.mv_par05==3

            if Substr( SZX->ZX_TIPO_OC, 1, 1 ) == "1"
               @ nLin,000 pSay Alltrim( SZX->ZX_CC_PROD )
            else
               @ nLin,000 pSay Alltrim( SZX->ZX_CONTA )
            endif

            if Substr( SZX->ZX_TIPO_OC, 1, 1 ) == "1"
               @ nLin,012 pSay Substr( SB1->B1_DESC, 1, 25 )
            else
               @ nLin,012 pSay Substr( SI1->I1_DESC, 1, 25 )
            endif

            if Substr( SZX->ZX_TIPO_OC, 1, 1 ) == "1"

               nCons_Kg := If( SB1->B1_TIPCONV == "M", SZX->ZX_CONSUMO, SZX->ZX_CONSUMO / SB1->B1_CONV )
               nValUnit := Round( SZX->ZX_VALTOT / SZX->ZX_CONSUMO, 2 )

               @ nLin,038 pSay SB1->B1_UM
               @ nLin,042 pSay SZX->ZX_CONSUMO
               @ nLin,055 pSay nCons_Kg  Picture "@E 9,999.9999"
               @ nLin,067 pSay nValUnit Picture "@E 9,999.99"

            endif

            nCustunit := SZX->ZX_VALTOT / nPRODUCAO

            @ nLin,075 pSay SZX->ZX_VALTOT Picture "@E 999,999,999.99"
            @ nLin,090 pSay nCustunit      Picture "@E 9,999.999"
            @ nLin,100 pSay SZX->ZX_PARTIC Picture "@E 999.99"

            nLin := nLin + 1

         endif

      endif

      if mv_par05 > 1
         nPesq := Ascan( aSintetico, { |aVAL| aVAL[1]==SZX->ZX_TIPO_OC+SZX->ZX_CC_PROD+SZX->ZX_CONTA } )
         if nPesq==0
            Aadd( aSintetico, { SZX->ZX_TIPO_OC+SZX->ZX_CC_PROD+SZX->ZX_CONTA, SZX->ZX_CONSUMO, SZX->ZX_VALTOT, nPRODUCAO, SZX->ZX_CONTA } )
         else
            aSintetico[ nPesq,2 ] := aSintetico[ nPesq,2 ] + SZX->ZX_CONSUMO
            aSintetico[ nPesq,3 ] := aSintetico[ nPesq,3 ] + SZX->ZX_VALTOT
         endif
      endif

      SZX->( dbSkip() )
      IncRegua()

   End

   if mv_par06 == 1
      SF1->( dbSeek( xFilial("SF1")+"CP"+SUBSTR(MV_PAR03,1,2)+SUBSTR(MV_PAR03,4,2),.T. ) )
      if SF1->F1_DOC=="CP"+SUBSTR(MV_PAR03,1,2)+SUBSTR(MV_PAR03,4,2)
         RecLock("SF1",.F.)
         SF1->F1_VALMERC := SF1->F1_VALMERC + nCustoFixo
         SF1->( MsUnlock() )
         SF1->( dbCommit() )
      else
         RecLock("SF1",.T.)
         SF1->F1_FILIAL  := "01";      SF1->F1_SERIE   := "PRO"
         SF1->F1_FORNECE := mv_par09; SF1->F1_LOJA    := "01";           SF1->F1_COND    := "001"
         SF1->F1_EST     := "PB";      SF1->F1_VALMERC := nCUSTOFIXO;    SF1->F1_EMISSAO := mv_par07
         SF1->F1_TIPO    := "N";       SF1->F1_ESPECIE := "NF";          SF1->F1_DTDIGIT := mv_par07
         SF1->F1_DOC     := "CP"+SUBSTR(MV_PAR03,1,2)+SUBSTR(MV_PAR03,4,2)
         SF1->( Msunlock() )
         SF1->( dbCommit() )
      endif

      RecLock("SD1",.T.)
      SD1->D1_FILIAL  := "01";      SD1->D1_COD     := cCOD;       SD1->D1_UM    := "KG"
      SD1->D1_QUANT   := 0.01;      SD1->D1_VUNIT   := nCUSTOFIXO; SD1->D1_TOTAL := nCUSTOFIXO
      SD1->D1_TES     := mv_par10;  SD1->D1_CF      := "1101";     SD1->D1_LOCAL := "01"
      SD1->D1_SERIE   := "PRO";     SD1->D1_FORNECE := mv_par09;  SD1->D1_LOJA  := "01"
      SD1->D1_CUSTO   := nCUSTOFIXO;SD1->D1_EMISSAO := mv_par07;   SD1->D1_TP := "PA"
      SD1->D1_TIPO    := "N";       SD1->D1_DTDIGIT := mv_par07
      SD1->D1_DOC     := "CP"+SUBSTR(MV_PAR03,1,2)+SUBSTR(MV_PAR03,4,2)
      SD1->( Msunlock() )
      SD1->( dbCommit() )

      nTotal := nTotal + DetProva( nHdlPrv, "PRO", "ESTR01", cLotePRO )

   elseif mv_par06 == 3

      SF1->( dbSeek( xFilial( "SF1") +"CP"+Substr(mv_par03,1,2)+Substr(mv_par03,4,2)+"PRO", .T. ) )
      if SF1->F1_DOC=="CP"+Substr(mv_par03,1,2)+Substr(mv_par03,4,2)

         RecLock("SF1",.F.)
         SF1->( dbdelete() )
         SF1->( Msunlock() )
         SF1->( dbCommit() )

         SD1->( dbSeek( xFilial( "SD1" ) + "CP"+Substr(mv_par03,1,2)+Substr(mv_par03,4,2)+"PRO", .T. ) )

         while SD1->D1_DOC=="CP"+Substr(mv_par03,1,2)+Substr(mv_par03,4,2) .and. SD1->( !Eof() )
            RecLock("SD1",.F.)
            SD1->( dbdelete() )
            SD1->( Msunlock() )
            SD1->( dbCommit() )
            SD1->( dbskip() )
         end

      endif

   endif

   nCustoFixo := nCustoVar := 0

End

/*
if mv_par05 == 1 .OR. mv_par05 == 3
   @ nLin,075 pSay nTOT_CUST Picture "@E 999,999,999.99"
endif
*/

if mv_par05 > 1

   aSint := ASORT( aSintetico,,, { |X,Y| X[1] < Y[1] } )
   nLin    := 61
   SetRegua( Len( aSint ) )

   For x := 1 to Len( aSint )

       if nLin > 60
          nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15) + 1 //Impressao do cabecalho
          @ nLin  , 00 pSay "Periodo..: " + mv_par04
          @ nLin  , 00 pSay "Periodo..: " + mv_par04
          @ nLin+1, 00 pSay "Produto..: " + "PRODUCAO EMPRESA"
          @ nLin+1, 00 pSay "Produto..: " + "PRODUCAO EMPRESA"
          @ nLin+2, 00 pSay "Producao (Kg).: "
          @ nLin+2, 17 pSay nTot_Qtd Picture "@E 999,999,999.99"
          @ nLin+2, 00 pSay "Producao (Kg).: "
          @ nLin+2, 17 pSay nTot_Qtd PICTURE "@E 999,999,999.99"
          nLin := nLin + 4

       endif

       SB1->( dbSeek( xFilial("SB1") + Substr( aSint[ X,1],3,15) ) )
       SI1->( dbSeek( xFilial("SI1") + aSint[ X,5], .T. ) )

       nPartic   := Round( aSint[ X, 3 ] / aSint[ 1, 3 ] * 100, 2 )
       nCustUnit := Round( aSint[ X, 3 ] / nTot_qtd, 3 )
       // nTOT_CUST := nTOT_CUST + aSINT[ X,3 ]

       if Substr(aSint[X,1],1,2) == "  "
          nLin := nLin + 1
          @ nLin,012 pSay "CUSTO TOTAL ( VAR + FIXO )"
       elseif Substr(aSint[X,1],1,2) == "1 "
          nLin := nLin + 1
          @ nLin,012 pSay "CUSTO VARIAVEL"
       elseif Substr(aSint[X,1],1,2) == "2 "
          nLin := nLin + 1
          @ nLin,012 pSay "CUSTO FIXO DIRETO"
       elseif Substr(aSint[X,1],1,2) == "3 "
          nLin := nLin + 1
          @ nLin,012 pSay "CUSTO FIXO INDIRETO"
       else
          @ nLin,000 pSay Alltrim( Substr( aSint[X,1],3,15) )

          if Substr( Substr(aSint[X,1],1,2),1,1 ) == "1"
             nCons_KG := Round( aSint[ X, 2 ] / aSint[ 1, 4 ], 4 )
             nValUnit := Round( aSint[ X, 3 ] / aSint[ X, 2 ], 2 )
             @ nLin,012 pSay Substr( SB1->B1_DESC, 1, 25 )
             @ nLin,038 pSay SB1->B1_UM
             @ nLin,042 pSay aSint[ X, 2 ] Picture "@E 9,999,999.99"
             @ nLin,055 pSay nCons_KG      Picture "@E 9,999.9999"
             @ nLin,067 pSay nValUnit      Picture "@E 9,999.99"
          else
             @ nLin,012 pSay Substr( SI1->I1_DESC, 1, 25 )
          Endif

       endif

       @ nLin,075 pSay aSint[ X, 3 ] Picture "@E 999,999,999.99"
       @ nLin,090 pSay nCustUnit     Picture "@E 9,999.999"
       @ nLin,100 pSay nPartic       Picture "@E 999.99"

       nLin := nLin + 1 + iif( Substr(aSint[X,1],1,2) $ "  1 2 3 ",1,0)
       IncRegua()

   Next

Endif

aRotina := {    { "Pesquisar" ,"A460Pesqui", 0 , 1},;
                { "Ordem",     "A460Ordem",  0 , 0},;
                { "Gera Notas","A460Nota",   0 , 3},;
                { "Estornar","A460Estor", 0 , 0}    }

if mv_par06 == 1
   lLanc  := iif( mv_par11==1, .t., .f. )
   lAglut := .t.
   RodaProva( nHdlPrv, nTotal )
   cA100incl( cArquivo, nHdlPrv, 3, cLotePRO, lLanc, lAglut )
endif

roda(cbcont,cbtxt,tamanho)

If aReturn[5] == 1
   dbCommitAll()
   ourspool(wnrel)
Endif

ms_flush()
return
