#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function pcpop1()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NREG,NPVAROP")
SetPrvt("CCODETIQ,CPRODUTO,NOP,AMAT,NQUANT,CMAT")
SetPrvt("NCONT,NDENSIDA,LFLAG,CNUMPI,DEMISPI,CMAQPI")
SetPrvt("NQTDPI,CPRODPI,CCEMEPI,NBOBLGPI,NLFILPI,NESPPI")
SetPrvt("CSANLAMPI,CTRATAMPI,CSLITEXPI,NPTNEVEPI,CMATRIZPI,NLIN")
SetPrvt("NNUMETQ,I,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Mauricio de Barros Silva                 ³ Data ³ 03/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Impressao da OP (RAVA)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Industrial                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
cALIASANT := Alias()
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Variaveis de parametrizacao da impressao.                    ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

cDESC1   := ""
cDESC2   := ""
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "INDUSTRIAL", 2, 2, 1, "", 1 }
cARQUIVO := "SC2"
aORD     := { "Por OP" }
cNOMREL  := "PCPOP1"
cTITULO  := "Ordem de Producao"
nLASTKEY := 0

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicio do processamento                                      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Pergunte("PCPOP1",.F.)
cNOMREL := Setprint( cARQUIVO, cNOMREL, "PCPOP1", @cTITULO, cDESC1, cDESC2, cDESC3, .F., aORD )
If nLastKey == 27
   Return
Endif
Setdefault( aRETURN, cARQUIVO )
If nLastKey == 27
   Return
Endif
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicio do Processamento do Relatorio                         ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicializacao de variaveis                                ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

dbselectarea( 'SB1' )
SB1->( dbsetorder( 1 ) )
dbselectarea( 'SB5' )
SB5->( dbsetorder( 1 ) )
dbselectarea( 'SC2' )
SC2->( dbsetorder( 1 ) )
DbSeek( xFILIAL("SC2" ) + MV_PAR01, .T. )
nREG := SC2->( RecNo() )
Count To nREGTOT While SC2->C2_NUM <= MV_PAR02
SC2->( DbGoTo( nREG ) )
nPVarOP := GetMv("MV_PVAROP")
cCodEtiq := ""
SetRegua( nREGTOT )
Do While ! SC2->( Eof() ) .and. SC2->C2_NUM <= MV_PAR02
   SB1->( DbSeek( xFILIAL("SB1") + SC2->C2_PRODUTO ) )
   SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )
   If MV_PAR03 == 1
      cCodEtiq := Alltrim( SC2->C2_PRODUTO )+"-"
      @ 00,000 psay " ______________________________________________________________________"
      @ 01,000 psay "|                                                                      |"
      @ 02,000 psay "|RAVA Embalagens Industria e Comercio Ltda.                            |"
      @ 03,000 psay "|                                                                      |"
      @ 04,000 psay "|       O R D E M   D E   P R O D U C A O         Numero.: ___________ |"
      @ 04,000 psay ""
      @ 04,061 psay SC2->C2_NUM
      @ 04,061 psay SC2->C2_NUM
      @ 05,000 psay ""
      @ 05,000 psay "|                                                                      |"
      @ 06,000 psay "|                                                 Data...: ___________ |"
      @ 06,000 psay ""
      @ 06,060 psay SC2->C2_EMISSAO
      @ 06,000 psay ""
      @ 06,011 psay "V I A   P A R A   C O R T E"
      @ 07,000 psay ""
      @ 07,000 psay "|                                                                      |"
      @ 08,000 psay "|                                                 Maquina: ___________ |"
      @ 08,000 psay ""
      @ 08,060 psay "*********"
      @ 09,000 psay "|                                                                      |"
      @ 10,000 psay "|Produto: ___________      Quilos: _________      Qtd: ___________  __ |"
      @ 10,000 psay ""
      cPRODUTO := Left( SC2->C2_PRODUTO, 8 )
      @ 10,010 psay cPRODUTO
      @ 10,035 psay Round(SC2->C2_QTSEGUM*100/(100+nPVarOp),0)  Picture "@E 99999.99"
      If SC2->C2_UM == "MR"
         @ 10,055 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3 ) Picture "@E 9999999.999" + "  MR"
      ElseIf SC2->C2_UM == "FD"
         @ 10,055 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3) Picture "@E 99999.999" + "  FD"
      Endif
      @ 11,000 psay ""
      @ 11,000 psay "|                                                                      |"
      @ 12,000 psay "|Descricao.....: _____________________________________________________ |"
      @ 12,000 psay ""
      @ 12,017 psay Left( SB1->B1_DESC, 50 )
      @ 13,000 psay ""
      @ 13,000 psay "|                                                                      |"
      @ 14,000 psay "|Largura p/ Corte......: ___________    Espessura.........: __________ |"
      @ 14,000 psay ""
      @ 14,027 psay SB5->B5_LARG  Picture "999"
      @ 14,061 psay SB5->B5_ESPESS Picture "@E 9.9999"
      @ 15,000 psay ""
      @ 15,000 psay "|                                                                      |"
      @ 16,000 psay "|Comprimento para corte: ___________    Sanfonado/Laminado: __________ |"
      @ 16,000 psay ""
      @ 16,027 psay SB5->B5_COMPR Picture "999"
      @ 16,065 psay SB5->B5_SANLAM
      @ 17,000 psay ""
      @ 17,000 psay "|                                                                      |"
      @ 18,000 psay "|Solda Fundo/Lateral...: ___________    Quantid. bobinas..: __________ |"
      @ 18,000 psay ""
      @ 18,029 psay SB5->B5_SOLDFL
      @ 18,063 psay SC2->C2_QTSEGUM / 100 Picture "999"
      @ 19,000 psay ""
      @ 19,000 psay "|                                                                      |"
      @ 20,000 psay "|Sanf. Fundo/Lateral...: ___________    Quant. p/ pacote..: __________ |"
      @ 20,000 psay ""
      @ 20,029 psay SB5->B5_SANFFL
      @ 20,063 psay SB5->B5_QE1 Picture "9999"
      @ 21,000 psay ""
      @ 21,000 psay "|                                                                      |"
      @ 22,000 psay "|Slit...: __________________________    Peso p/milheiro..: ___________ |"
      @ 22,000 psay ""
      @ 22,012 psay IIf(SB5->B5_SLIT=='S','SIM','NAO')
      @ 22,059 psay SB1->B1_PESO / SB5->B5_QE2 * 1000 Picture "@E 9,999.999"
      @ 23,000 psay ""
      @ 23,000 psay "|______________________________________________________________________|"
      @ 24,000 psay "|       |          |                 |            |       |            |"
      @ 25,000 psay "| No.de |          |      Hora       |            | Apara |            |"
      @ 26,000 psay "|       |          |                 |            |       |            |"
      @ 27,000 psay "|Bobinas|   Data   | Inicio | Termino| Quantidade |  KG   |  Operador  |"
      @ 28,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 29,000 psay "|       |          |        |        |            |       |            |"
      @ 30,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 31,000 psay "|       |          |        |        |            |       |            |"
      @ 32,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 33,000 psay "|       |          |        |        |            |       |            |"
      @ 34,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 35,000 psay "|       |          |        |        |            |       |            |"
      @ 36,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 37,000 psay "|       |          |        |        |            |       |            |"
      @ 38,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 39,000 psay "|       |          |        |        |            |       |            |"
      @ 40,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 41,000 psay "|       |          |        |        |            |       |            |"
      @ 42,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 43,000 psay "|       |          |        |        |            |       |            |"
      @ 44,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 45,000 psay "|       |          |        |        |            |       |            |"
      @ 46,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 47,000 psay "|       |          |        |        |            |       |            |"
      @ 48,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 49,000 psay "|       |          |        |        |            |       |            |"
      @ 50,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 51,000 psay "|       |          |        |        |            |       |            |"
      @ 52,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 53,000 psay "|       |          |        |        |            |       |            |"
      @ 54,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 55,000 psay "|       |          |        |        |            |       |            |"
      @ 56,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 57,000 psay "|       |          |        |        |            |       |            |"
      @ 58,000 psay "|_______|__________|________|________|____________|_______|____________|"
      @ 59,000 psay "|Observacoes:                                                          |"
      @ 59,015 psay SC2->C2_OBS
      @ 60,000 psay "|______________________________________________________________________|"
      @ 61,000 psay "|______________________________________________________________________|"
      @ 62,000 psay "|______________________________________________________________________|"

      nOP := SC2->C2_NUM
      SC2->( DbSkip() )
      Do While ( Left( SC2->C2_PRODUTO, 2 ) #"PI" .or. SC2->C2_SEQPAI # "001" ) .and. SC2->C2_NUM == nOP
         SC2->( DbSkip() )
      EndDo

      If SC2->C2_NUM #nOP
         nREG := SC2->( RecNo() )
         IncRegua()
         Loop
      EndIf

      SB1->( DbSeek( xFILIAL("SB1") + SC2->C2_PRODUTO ) )
      SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )
      cCodEtiq := cCodEtiq + Alltrim(SC2->C2_PRODUTO)
      @ 00,000 psay " ______________________________________________________________________"
      @ 01,000 psay "|                                                                      |"
      @ 02,000 psay "|RAVA Embalagens Industria e Comercio Ltda.                            |"
      @ 03,000 psay "|                                                                      |"
      @ 04,000 psay "|       O R D E M   D E   P R O D U C A O         Numero.: ___________ |"
      @ 04,000 psay ""
      @ 04,061 psay SC2->C2_NUM
      @ 05,000 psay ""
      @ 05,000 psay "|                                                                      |"
      @ 06,000 psay "|                                                 Data...: ___________ |"
      @ 06,000 psay ""
      @ 06,060 psay SC2->C2_EMISSAO
      @ 06,000 psay ""
      @ 06,008 psay "V I A   P A R A   E X T R U S A O"
      @ 06,008 psay "V I A   P A R A   E X T R U S A O"
      @ 07,000 psay ""
      @ 07,000 psay "|                                                                      |"
      @ 08,000 psay "|                                                 Maquina: ___________ |"
      @ 08,061 psay Left(SB5->B5_MAQ,10)
      @ 09,000 psay "|                                                                      |"
      @ 10,000 psay "|Quilos: _____________________________      Produto: ________/________ |"
      @ 10,000 psay ""

      Do While Left( SC2->C2_PRODUTO, 2 ) #"PI" .or. SC2->C2_SEQPAI # "001"
         SC2->( DbSkip() )
      EndDo

      @ 10,009 psay Round(SC2->C2_QUANT*100/(100+nPVarOp),0)  Picture "@E 99999.99"
      @ 10,053 psay Left( SC2->C2_PRODUTO, 8 ) + " " + cPRODUTO

      SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )

      @ 11,000 psay ""
      @ 11,000 psay "|                                                                      |"
      @ 12,000 psay "|Descricao.....: _____________________________________________________ |"
      @ 12,018 psay Left(SB5->B5_CEME,50)
      @ 13,000 psay ""
      @ 13,000 psay "|                                                                      |"
      @ 14,000 psay "|Materia prima.: _____________________________________________________ |"
      SG1->( DbSeek( xFILIAL("SG1") + SC2->C2_PRODUTO, .T. ) )
      aMAT   := {}
      nQUANT := 0

      Do While ! SG1->( Eof() ) .and. SG1->G1_COD == SC2->C2_PRODUTO
         If Left( SG1->G1_COMP, 4 ) == "MP01"
            SB1->( DbSeek( xFILIAL("SB1") + SG1->G1_COMP ) )
            Aadd( aMAT, { Left( SB1->B1_DESC, 8 ), SG1->G1_QUANT } )
            nQUANT := nQUANT + SG1->G1_QUANT
         EndIf
         SG1->( DbSkip() )
      EndDo

      cMAT  := ""
      nCONT := 1

      Do While nCONT <= Len( aMAT )
         cMAT := cMAT + AllTrim( aMAT[ nCONT, 1 ] ) + " " + Trans( aMAT[ nCONT, 2 ] / nQUANT * 100, "999%" ) + " "
         nCONT := nCONT + 1
      EndDo

      @ 14,018 psay If( ! Empty( cMAT ), cMAT, "NAO CADASTRADA" )
      @ 15,000 psay ""
      @ 15,000 psay ""
      @ 15,000 psay "|                                                                      |"
      @ 16,000 psay "|Largura do Filme......: ___________    Espessura: ___________________ |"
      @ 16,000 psay ""
      @ 16,026 psay SB5->B5_LARGFIL Picture "999.99"
      @ 16,056 psay SB5->B5_ESPESS Picture "@E 9.9999"
      @ 17,000 psay ""
      @ 17,000 psay "|                                                                      |"
      @ 18,000 psay "|Largura da Bobina.....: ___________    Sanfonado/Laminado: __________ |"
      @ 18,000 psay ""
      @ 18,026 psay SB5->B5_BOBLARG Picture "999.99"
      @ 18,062 psay SB5->B5_SANLAM2
      @ 19,000 psay ""
      @ 19,000 psay "|                                                                      |"
      @ 20,000 psay "|Tratamento: _______________________    Slit: ________________________ |"
      @ 20,000 psay ""
      @ 20,015 psay IIf(SB5->B5_TRATAM=='S','SIM','NAO')
      @ 20,048 psay IIf(SB5->B5_SLITEXT=='S','SIM','NAO')
      @ 21,000 psay ""
      @ 21,000 psay "|                                                                      |"
      @ 22,000 psay "|Metros por 100 Kg.....: ___________    Peso p/ Metro: _______________ |"
      @ 22,000 psay ""
      nDENSIDA := SB5->B5_DENSIDA
      @ 22,025 psay SB5->B5_METRBOB Picture "@E 999,999"
      @ 22,055 psay 100/(100 / ( ( SB5->B5_LARGFIL * nDENSIDA * SB5->B5_ESPESS * 100 ) / 1000 )) Picture "@E 999.999999"
      @ 23,000 psay ""
      @ 24,000 psay "|Alt.de Pescoco........: ___________    Matriz.......: _______________ |"
      @ 24,000 psay ""
      @ 24,025 psay SB5->B5_PTONEVE Picture "999999.99"
      @ 24,057 psay Left(SB5->B5_MATRIZ,12)
      @ 25,000 psay ""
      @ 25,000 psay "|______________________________________________________________________|"
      @ 26,000 psay "|       |          |              |        |        |       |          |"
      @ 27,000 psay "| No.de |          |     Hora     | Bobina | Bobina | Peso  |          |"
      @ 28,000 psay "|       |          |              |        |        |  p/   |          |"
      @ 29,000 psay "|Bobinas|   Data   |Inicio|Termino|   Km   |   Kg   | Metro | Operador |"
      @ 30,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 31,000 psay "|       |          |      |       |        |        |       |          |"
      @ 32,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 33,000 psay "|       |          |      |       |        |        |       |          |"
      @ 34,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 35,000 psay "|       |          |      |       |        |        |       |          |"
      @ 36,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 37,000 psay "|       |          |      |       |        |        |       |          |"
      @ 38,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 39,000 psay "|       |          |      |       |        |        |       |          |"
      @ 40,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 41,000 psay "|       |          |      |       |        |        |       |          |"
      @ 42,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 43,000 psay "|       |          |      |       |        |        |       |          |"
      @ 44,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 45,000 psay "|       |          |      |       |        |        |       |          |"
      @ 46,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 47,000 psay "|       |          |      |       |        |        |       |          |"
      @ 48,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 49,000 psay "|       |          |      |       |        |        |       |          |"
      @ 50,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 51,000 psay "|       |          |      |       |        |        |       |          |"
      @ 52,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 53,000 psay "|       |          |      |       |        |        |       |          |"
      @ 54,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 55,000 psay "|       |          |      |       |        |        |       |          |"
      @ 56,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 57,000 psay "|       |          |      |       |        |        |       |          |"
      @ 58,000 psay "|_______|__________|______|_______|________|________|_______|__________|"
      @ 59,000 psay "|Observacoes:                                                          |"
      @ 60,000 psay "|______________________________________________________________________|"
      @ 61,000 psay "|Apara KG: __________    Apara KG: __________    Apara KG: _________   |"
      @ 62,000 psay "|______________________________________________________________________|"
   Else
      cCodEtiq := Alltrim( SC2->C2_PRODUTO )+"-"
      nOP  := SC2->C2_NUM
      SC2->( DbSkip() )

      Do While ( Left( SC2->C2_PRODUTO, 2 ) #"PI" .or. SC2->C2_SEQPAI # "001" ) .and. SC2->C2_NUM == nOP
         SC2->( DbSkip() )
      EndDo

      lFLAG := If( SC2->C2_NUM #nOP, .F., .T. )
      SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )
      cCodEtiq := cCodEtiq + Alltrim(SC2->C2_PRODUTO)
      cNUMPI    := SC2->C2_NUM
      dEMISPI   := SC2->C2_EMISSAO
      cMAQPI    := Left(SB5->B5_MAQ,10)
      nQTDPI    := Round( SC2->C2_QUANT*100/(100+nPVarOp), 2 )
      cPRODPI   := SC2->C2_PRODUTO
      cCEMEPI   := SB5->B5_CEME
      nBOBLGPI  := SB5->B5_BOBLARG
      nLFILPI   := SB5->B5_LARGFIL
      nESPPI    := SB5->B5_ESPESS
      cSANLAMPI := SB5->B5_SANLAM2
      cTRATAMPI := SB5->B5_TRATAM
      cSLITEXPI := SB5->B5_SLITEXT
      nPTNEVEPI := SB5->B5_PTONEVE
      cMATRIZPI := SB5->B5_MATRIZ

      SC2->( DbGoTo( nREG ) )
      SB5->( DbSeek( xFILIAL("SB5") + SC2->C2_PRODUTO ) )

      @ 00,000 psay CHR(27)+CHR(38)+"l1O"+chr(27)+CHR(38)+"l26A"+chr(27)+CHR(38)+"l09D"+chr(27)+CHR(38)+"l72P"+chr(27)+"(12U"+chr(27)+"(s0p08h12v0s0b3T"
      @ 00,000 psay ""
      @ 00,000 psay " __________________________________________________"
      @ 00,056 psay If( ! lFLAG, "", " __________________________________________________" )
      @ 01,000 psay "|                                                  |"
      @ 01,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 02,000 psay "|RAVA Embalagens Industria e Comercio Ltda.        |"
      @ 02,056 psay If( ! lFLAG, "", "|RAVA Embalagens Industria e Comercio Ltda.        |" )
      @ 03,000 psay "|                                                  |"
      @ 03,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 04,000 psay "|       ORDEM DE PRODUCAO        Numero.: ________ |"
      @ 04,056 psay If( ! lFLAG, "", "|       ORDEM DE PRODUCAO        Numero.: ________ |" )
      @ 04,000 psay chr(27)+"(s0p12h16v0s1b3T"
      @ 04,069 psay SC2->C2_NUM
      @ 04,136 psay If( ! lFLAG, "", cNUMPI )
      @ 05,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 05,000 psay "|                                                  |"
      @ 05,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 06,000 psay "|                                Data...: ________ |"
      @ 06,056 psay If( ! lFLAG, "", "|                                Data...: ________ |" )
      @ 06,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 06,068 psay SC2->C2_EMISSAO
      @ 06,135 psay If( ! lFLAG, "", dEMISPI )
      @ 06,000 psay chr(27)+"(s0p12h16v0s1b3T"
      @ 06,014 psay "VIA PARA CORTE"
      @ 06,080 psay If( ! lFLAG, "", "VIA PARA EXTRUSAO" )
      @ 07,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 07,000 psay "|                                                  |"
      @ 07,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 08,000 psay "|                                Maquina: ________ |"
      @ 08,056 psay If( ! lFLAG, "", "|                                Maquina: ________ |" )
      @ 08,000 psay chr(27)+"(s0p12h16v0s1b3T"
      @ 08,068 psay If( ! lFLAG, "", "********" )
      @ 08,136 psay If( ! lFLAG, "", cMAQPI )
      @ 09,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 09,000 psay "|                                                  |"
      @ 09,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 10,000 psay "|Prod.: ________ Quilos: _______ Qtd:__________ __ |"
      @ 10,056 psay If( ! lFLAG, "", "|Quilos: __________     Produto: ________/________ |" )
      @ 10,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 10,012 psay Left( SC2->C2_PRODUTO, 8 )
      @ 10,032 psay Round(SC2->C2_QTSEGUM*100/(100+nPVarOp),0)  Picture "@E 9999.99"

      If SC2->C2_UM == "MR"
         @ 10,048 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3) Picture "@E 99999.999" + '  MR'
      ElseIf SC2->C2_UM == "FD"
         @ 10,048 psay Round( SC2->C2_QUANT*100/(100+nPVarOp), 3) Picture "@E 99999.999" + '  FD'
      Endif

      @ 10,080 psay If( ! lFLAG, "", Round(nQTDPI,0) )  Picture If( ! lFLAG, "", "@E 9999.99" )
      @ 10,109 psay If( ! lFLAG, "", Left(cPRODPI,8) + '  ' + Left( SC2->C2_PRODUTO, 8 ) )
      @ 11,000 psay Chr(27)+"(s0p08h12v0s0b3T"
      @ 11,000 psay "|                                                  |"
      @ 11,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 12,000 psay "|Descr.: _________________________________________ |"
      @ 12,056 psay If( ! lFLAG, "", "|Descr.: _________________________________________ |" )
      @ 12,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 12,012 psay SB5->B5_CEME
      @ 12,079 psay If( ! lFLAG, "", cCEMEPI )
      @ 13,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 13,000 psay "|                                                  |"
      @ 13,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 14,000 psay "|Larg. p/ Corte: ___________ Espessura: __________ |"
      @ 14,056 psay If( ! lFLAG, "", "|M.Prim: _________________________________________ |" )
      @ 14,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 14,040 psay SB5->B5_LARG Picture "999.99"
      @ 14,066 psay SB5->B5_ESPESS Picture "@E 9.9999"
      SG1->( DbSeek( xFILIAL("SG1") + cPRODPI, .T. ) )
      aMAT   := {}
      nQUANT := 0

      Do While ! SG1->( Eof() ) .and. SG1->G1_COD == cPRODPI
         If Left( SG1->G1_COMP, 4 ) == "MP01"
            SB1->( DbSeek( xFILIAL("SB1") + SG1->G1_COMP ) )
            Aadd( aMAT, { Left( SB1->B1_DESC, 8 ), SG1->G1_QUANT } )
            nQUANT := nQUANT + SG1->G1_QUANT
         EndIf
         SG1->( DbSkip() )
      EndDo

      cMAT  := ""
      nCONT := 1

      Do While nCONT <= Len( aMAT )
         cMAT := cMAT + AllTrim( aMAT[ nCONT, 1 ] ) + " " + Trans( aMAT[ nCONT, 2 ] / nQUANT * 100, "999%" ) + " "
         nCONT := nCONT + 1
      EndDo

      @ 14,095 psay If( ! lFLAG, "", If( ! Empty( cMAT ), cMAT, "NAO CADASTRADA" ) )
      @ 15,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 15,000 psay "|                                                  |"
      @ 15,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 16,000 psay "|Comp. p/ corte.: __________ Sanf/Lami: __________ |"
      @ 16,056 psay If( ! lFLAG, "", "|Larg. do Filme: ___________ Espessura: __________ |" )
      @ 16,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 16,040 psay SB5->B5_COMPR Picture "999"
      @ 16,069 psay SB5->B5_SANLAM
      @ 16,107 psay If( ! lFLAG, "", nLFILPI ) Picture If( ! lFLAG, "", "@E 999.99" )
      @ 16,134 psay If( ! lFLAG, "", nESPPI ) Picture If( ! lFLAG, "", "@E 9.9999" )
      @ 17,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 17,000 psay "|                                                  |"
      @ 17,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 18,000 psay "|Solda Fund/Late: __________ Qtd. bob.: __________ |"
      @ 18,056 psay If( ! lFLAG, "", "|Larg. da Bobina: __________ Sanf/Lami: __________ |" )
      @ 18,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 18,042 psay SB5->B5_SOLDFL
      @ 18,067 psay Round( SC2->C2_QTSEGUM*100/(100+nPVarOp), 2 ) / 100 Picture "999"
      @ 18,107 psay If( ! lFLAG, "", nBOBLGPI ) Picture If( ! lFLAG, "", "999.99" )
      @ 18,135 psay If( ! lFLAG, "", cSANLAMPI )
      @ 19,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 19,000 psay "|                                                  |"
      @ 19,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 20,000 psay "|Sanf. Fund/Late: __________ Qtd.p/pac: __________ |"
      @ 20,056 psay If( ! lFLAG, "", "|Tratamento.....: __________ Slit.....: __________ |" )
      @ 20,000 psay chr(27)+"(s0p12h12v1s0b3T"
      @ 20,042 psay SB5->B5_SANFFL

      nDENSIDA := SB5->B5_DENSIDA

      @ 20,066 psay If( ! lFLAG, "", SB5->B5_QE1 ) Picture If( ! lFLAG, "", "9999" )
      @ 20,106 psay If( ! lFLAG, "", IIf(cTRATAMPI=='S','SIM','NAO') )
      @ 20,133 psay If( ! lFLAG, "", IIf(cSLITEXPI=='S','SIM','NAO') )
      @ 21,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 21,000 psay "|                                                  |"
      @ 21,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 22,000 psay "|Slit: _____________________ Peso p/MR: __________ |"
      @ 22,056 psay If( ! lFLAG, "", "|Metros p/100 kg: __________ Peso p/ Metro:_______ |" )
      SB1->( DbSeek( xFILIAL("SB1") + SC2->C2_PRODUTO ) )
      @ 22,000 psay Chr(27)+"(s0p12h12v1s0b3T"
      @ 22,035 psay IIf(SB5->B5_SLIT=='S','SIM','NAO')
      @ 22,065 psay SB1->B1_PESO / SB5->B5_QE2 * 1000  Picture "@E 9,999.999"
      @ 22,104 psay If( ! lFLAG, "", 100 / ( ( nLFILPI * nDENSIDA * SB5->B5_ESPESS * 100 ) / 1000 ) ) Picture If( ! lFLAG, "", "@E 999,999" )
      @ 22,134 psay If( ! lFLAG, "", 100/(100 / ( ( nLFILPI * nDENSIDA * SB5->B5_ESPESS * 100 ) / 1000 ) ) ) Picture If( ! lFLAG, "", "@E 999.999999" )
      @ 22,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 23,000 psay "|                                                  |"
      @ 23,056 psay If( ! lFLAG, "", "|                                                  |" )
      @ 24,056 psay "|Alt.  Pescoco: ____________ Matriz: _____________ |"
      @ 24,000 psay Chr(27)+"(s0p12h12v1s0b3T"
      @ 24,102 psay nPTNEVEPI Picture "999999.99"
      @ 24,133 psay Left(cMATRIZPI,12)
      @ 25,000 psay chr(27)+"(s0p08h12v0s0b3T"
      @ 25,000 psay "|__________________________________________________|"
      @ 25,056 psay If( ! lFLAG, "", "|__________________________________________________|" )
      @ 26,000 psay "|     |      |           |          |     |        |"
      @ 26,056 psay If( ! lFLAG, "", "|    |      |         |      |       |     |       |" )
      @ 27,000 psay "|No.de|      |    Hora   |          |Apara|        |"
      @ 27,056 psay If( ! lFLAG, "", "| No.|      |   Hora  | Bob. |  Bob. |Peso |       |" )
      @ 28,000 psay "|     |      |           |          |     |        |"
      @ 28,056 psay If( ! lFLAG, "", "|    |      |         |      |       |     |       |" )
      @ 29,000 psay "| Bob.| Data |Inic.|Term.|Quantidade| Kg  |Operador|"
      @ 29,056 psay If( ! lFLAG, "", "|Bob.| Data |Inic|Term|  Km  |   Kg  |Metro|Operad.|" )
      @ 30,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 30,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 31,000 psay "|     |      |     |     |          |     |        |"
      @ 31,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 32,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 32,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 33,000 psay "|     |      |     |     |          |     |        |"
      @ 33,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 34,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 34,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 35,000 psay "|     |      |     |     |          |     |        |"
      @ 35,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 36,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 36,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 37,000 psay "|     |      |     |     |          |     |        |"
      @ 37,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 38,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 38,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 39,000 psay "|     |      |     |     |          |     |        |"
      @ 39,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 40,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 40,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 41,000 psay "|     |      |     |     |          |     |        |"
      @ 41,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 42,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 42,056 psay If( ! lFLAG, "", "|____|______|____|____|______|_______|_____|_______|" )
      @ 43,000 psay "|     |      |     |     |          |     |        |"
      @ 43,056 psay If( ! lFLAG, "", "|    |      |    |    |      |       |     |       |" )
      @ 44,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 44,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 45,000 psay "|     |      |     |     |          |     |        |"
      @ 45,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 46,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 46,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 47,000 psay "|     |      |     |     |          |     |        |"
      @ 47,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 48,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 48,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 49,000 psay "|     |      |     |     |          |     |        |"
      @ 49,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 50,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 50,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 51,000 psay "|     |      |     |     |          |     |        |"
      @ 51,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 52,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 52,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 53,000 psay "|     |      |     |     |          |     |        |"
      @ 53,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 54,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 54,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 55,000 psay "|     |      |     |     |          |     |        |"
      @ 55,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 56,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 56,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 57,000 psay "|     |      |     |     |          |     |        |"
      @ 57,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 58,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 58,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 59,000 psay "|     |      |     |     |          |     |        |"
      @ 59,056 psay If( ! lFLAG, "",  "|    |      |    |    |      |       |     |       |" )
      @ 60,000 psay "|_____|______|_____|_____|__________|_____|________|"
      @ 60,056 psay If( ! lFLAG, "",  "|____|______|____|____|______|_______|_____|_______|" )
      @ 61,000 psay "|Observacoes:                                      |"
      @ 61,056 psay If( ! lFLAG, "",  "|Observacoes:                                      |" )
      @ 61,015 psay SC2->C2_OBS
      @ 62,000 psay "|__________________________________________________|"
      @ 62,056 psay If( ! lFLAG, "",  "|                                                  |" )
      @ 63,000 psay "|                                                  |"
      @ 63,056 psay If( ! lFLAG, "",  "|Apara KG:______  Apara KG:_______  Apara KG:______|" )
      @ 64,000 psay "|__________________________________________________|"
      @ 64,056 psay If( ! lFLAG, "",  "|__________________________________________________|" )

    //"&l0O&l2A&l07D&l72P(12U(s0p12h12v0s0b3T


      @ 00,000 psay CHR(27)+CHR(38)+"l0O"+CHR(27)+CHR(38)+"12A"+CHR(27)+CHR(38)+"107D"+CHR(27)+CHR(38)+"l72P(12U(s0p12h12v0s0b3T"

   EndIf

   nLIN := 1
   nNUMETQ := 0

   If mv_par03 == 1
      nNUMETQ := Round( ( SC2->C2_QUANT*100/100+nPVarOp) /100,0)
   Else
      nNUMETQ := Round(nQTDPI/100,0)
   Endif

   For I:=1 To ( nNUMETQ * 2 )
                  //         10        20        30        40        50        60        70        80
                  //01234567890123456789012345678901234567890123456789012345678901234567890123456789
      @ nLIN,000 PSay Padc("R A V A    E M B A L A G E N S",80)
      @ nLIN,060 pSay cCodEtiq
      @ nLIN+2,005 PSay "N§ da O.P.......:________    Peso(kg)....:________    Bobina N§:_______"
      @ nLIN+2,024 PSay SC2->C2_NUM
      @ nLIN+2,071 PSay StrZero(I,2)
      @ nLIN+3,005 PSay "Desc. do Produto:______________________________________________________"
      If mv_par03 == 1
         @ nLIN+3,024 PSay Left(SB5->B5_CEME,50)
      Else
         @ nLIN+3,024 PSay Left(cCEMEPI,50)
      Endif
      @ nLIN+4,005 PSay "Larg. do Filme..:________    Compr. Corte:________    Espessura:_______"
      If mv_par03 == 1
         @ nLIN+4,024 PSay SB5->B5_LARGFIL Picture "@E 999.99"
         @ nLIN+4,049 PSay SB5->B5_COMPR Picture "@E 999.99"
         @ nLIN+4,071 psay SB5->B5_ESPESS Picture "@E 9.9999"
      Else
         @ nLIN+4,024 PSay nLFILPI Picture "@E 999.99"
         @ nLIN+4,049 PSay SB5->B5_COMPR Picture "@E 999.99"
         @ nLIN+4,071 psay nESPPI Picture "@E 9.9999"
      Endif

      @ nLIN+5,005 PSay "Tratamento......:________    Operador:____________    Data: ___/___/___"
      If mv_par03 == 1
         @ nLIN+5,024 Psay IIf(SB5->B5_TRATAM=='S','SIM','NAO')
      Else
         @ nLIN+5,024 Psay IIf(cTRATAMPI=='S','SIM','NAO')
      Endif
      @ nLIN+7,005 PSay "......................................................................."
      nLIN := nLIN + 9
      If nLIN >= 64
         nLIN := 1
         If mv_par03 == 2  .And. I #nNUMETQ
            Eject
         Endif
       //@ nLIN,000 PSay ""
      Endif

   Next

   nOP := SC2->C2_NUM
   Do While SC2->C2_NUM == nOP
      SC2->( DbSkip() )
   EndDo
   nREG := SC2->( RecNo() )
   IncRegua()

   //Pular pagina
   If ! SC2->( Eof() ) .and. SC2->C2_NUM <= MV_PAR02
      Eject
   Endif

EndDo

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool( cNomRel )   // Chamada do Spool de Impressao
Endif
MS_FLUSH()   // Libera fila de relatorios em spool

Return
