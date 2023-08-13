#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function CONR01()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,AORDEM,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,ARETURN,NOMEPROG,CPERG,WNREL,NLASTKEY")
SetPrvt("LCONTINUA,NLIN,M_PAG,CSTRING,CABEC1,CABEC2")
SetPrvt("AESTRUT,CARQTMP,CFILTRO,CCHAVE,CINDSE1,LFLAG")
SetPrvt("CCC,DEMISSAO,DEMIS,NVALINDX,NSALINDX,NVALORIGINDX")
SetPrvt("NVALORANT,NVALATU,NBPARCIAL,DBAIXA,AVALOR,CCARTEIRA")
SetPrvt("NVALREC,NVALJUR,NVALDESC,NCORRECAO,NCORR1999,NCORR2000")
SetPrvt("NPERC,NPERCREC,NVALORIG,DDEZ99,NJURPANT,NJURPPOS")
SetPrvt("NJURIANT,NJURIPOS,NJURINDX,NVALCORR,CARQ,ADISTRATO")
SetPrvt("NP,CCODIGO,CARQIND,MPAG,NBASECALC,NDISTRATO")
SetPrvt("NCCORIG,NCCCORR,NCCCORR99,NCCCORR00,NCCJUROS,NCCVLREC")
SetPrvt("NCCDESC,NCCDACAO,NCCNTRIB,NTBASECALC,NTDISTRATO,NTOTORIG")
SetPrvt("NTOTCORR,NTOTCORR99,NTOTCORR00,NTOTJUROS,NTOTVLREC,NTOTDESC")
SetPrvt("NTOTDACAO,NTOTNTRIB,NTCOFINS,NTIRPJ,NTCSLL,NTPISREP")
SetPrvt("NTPISDED,NCOFINS,NCSLL,NIRPJ,NPISREP,NPISDED")
SetPrvt("ACC,AROTINA,CARQUIVO,NTOTAL,LLANC,CLOTER01")
SetPrvt("NHDLPRV,CDESC,NIRPJ1,NRECEITFIN,NATIVOIMOB,NDESCONOBT")
SetPrvt("NBASEDED,NANO,Y,X,NSALDOCONT,NLUCROPRE")
SetPrvt("NADICIONAL,NCCTOTORIG,NCCTOTCORR,NCC99TOTCOR,NCC00TOTCOR,NCCTOTJUROS")
SetPrvt("NCCTOTDESC,NCCTOTVLREC,NCCTOTDACAO,AMATRIZ,CFORNEC,CLOJA")
SetPrvt("NMOEDA,CNATUREZA,CPREFIXO,CNUMERO,CPARCELA,CTIPO")
SetPrvt("NMOEDATIT,NVALOR,NVALBAIX,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  CONR01  ³ Autor ³   Silvano Araujo      ³ Data ³ 19/02/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Recebimneto Contabil                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Queiroz Galvao                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De Centro de Custo                   ³
//³ mv_par02             // Ate Centro de Custo                  ³
//³ mv_par03             // De Cliente                           ³
//³ mv_par04             // Ate Cliente                          ³
//³ mv_par05             // De Baixa                             ³
//³ mv_par06             // Ate Baixa                            ³
//³ mv_par07             // 1-Analitico ou 2-Sintetico           ³
//³ mv_par08             // Calcula Receita fin. 1-Nao ou 2-Sim  ³
//³ mv_par09             // Valor deducao do adicional           ³
//³ mv_par10             // Centro de custo Administracao        ³
//³ mv_par11             // Conta Contabil Receita Financeira    ³
//³ mv_par12             // Conta Contabil Ativo Imob.           ³
//³ mv_par13             // Conta Contabil Descontos Obtidos     ³
//³ mv_par14             // Contabilizar 1-Nao ou 2-Sim          ³
//³ mv_par15             // Mostra Lancamentos 1-Sim ou 2-Nao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt :=CbCont:=""
nOrdem:=Alfa := Z:=M:=0
tamanho:="G"
limite:=254
aOrdem:= { "Por C.C.   " }
titulo :=PADC("Relacao de Recebimentos",74)
cDesc1 :=PADC("Este programa ira emitir Relacao de recebimentos",74)
cDesc2 :=PADC("por centro de custos, com valores de correcao no ano 2000",74)
cDesc3 :=PADC("para efeito de calculo de imposto",74)
aReturn := { "Financeiro", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:=cPerg:=wnrel:="CONR01"
nLastKey:= 0
lContinua := .T.
nLin:=9
M_PAG    := 1
Pergunte(cPerg,.F.)               // Pergunta no SX1
cString:="SE1"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.t.,aOrdem )
If nLastKey == 27
   Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif

if mv_par07 == 1
   Cabec1 := "Codigo Lj Nome do Cliente                Valor Permuta Num. Titulo  Dt.Emissao  Dt.Receb.       Valor Face Corr.Acumulada Corr.Ate 31/12 Corr.Apo 31/12      Juros  Descontos    Valor Recebido   " //Valor Titulo Saldo a Receb."
else
   Cabec1 := "Centro de Custo                          Valor Permuta                                          Valor Face Corr.Acumulada Corr.Ate 31/12 Corr.Apo 31/12      Juros  Descontos Valor Recebido"
endif
Cabec2 := ""

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  de variaveis                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEstrut := {}
Aadd( aEstrut, { "E1_CLIENTE","C", 6, 0 } )
Aadd( aEstrut, { "A1_NREDUZ", "C",15, 0 } )
Aadd( aEstrut, { "E1_LOJA",   "C", 2, 0 } )
Aadd( aEstrut, { "A1_CONTA",  "C",20, 0 } )
Aadd( aEstrut, { "E1_CC",     "C",10, 0 } )
Aadd( aEstrut, { "E1_TITULO", "C",10, 0 } )
Aadd( aEstrut, { "A1_DATAVEN","D", 8, 0 } )
Aadd( aEstrut, { "E1_BAIXA",  "D", 8, 0 } )
Aadd( aEstrut, { "E1_VALORIG","N",12, 2 } )
Aadd( aEstrut, { "CORRECAO",  "N",12, 2 } )
Aadd( aEstrut, { "CORR1999",  "N",12, 2 } )
Aadd( aEstrut, { "CORR2000",  "N",12, 2 } )
Aadd( aEstrut, { "JUROS",     "N",12, 2 } )
Aadd( aEstrut, { "DESCONTOS", "N",12, 2 } )
Aadd( aEstrut, { "VALREC",    "N",12, 2 } )
Aadd( aEstrut, { "DACAO",     "N",12, 2 } )

cArqTmp := CriaTrab( aEstrut, .t. )
use ( cArqTmp ) alias TMP new

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processando o arquivo de empreendimentos                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Filtro arquivo SE1
dbselectArea("SE1")
cFiltro := "E1_CC>=mv_par01.and.E1_CC<=mv_par02.and.E1_CLIENTE>=mv_par03.and.E1_CLIENTE<=mv_par04.and.!Empty(E1_BAIXA)"
cChave  := "E1_CC+Dtos(E1_BAIXA)"
cIndSe1 := CriaTrab(nil,.f.)
IndRegua( "SE1", cIndSe1, cChave, , cFiltro,"Selecionando Titulos...." )
SE1->( dbGoTop() )

SetRegua( Lastrec() )

lFlag    := .t.
while SE1->( !Eof() )

   if SM0->M0_CODIGO == "01"
      cCC := SE1->E1_CC
   else
      cCC := Substr( SE1->E1_CC, 1, 4 )
   endif
   SEZ->( dbSetOrder( 1 ) )
   SEZ->( dbSeek( xFilial( "SEZ" ) + SE1->E1_NUM, .T. ) )
   if SEZ->EZ_NUM #SE1->E1_NUM .or. SEZ->EZ_CLIENTE # SE1->E1_CLIENTE
      SEZ->( dbSetOrder( 3 ) )
      SEZ->( dbSeek( xFilial( "SEZ" ) + SE1->E1_CLIENTE + SE1->E1_LOJA, .T. ) )
      SEZ->( dbSetOrder( 1 ) )
   else
      while SEZ->EZ_NUM == SE1->E1_NUM .and. SEZ->( !Eof() )
         if SEZ->EZ_NUM == SE1->E1_NUM .and. ( SE1->E1_PARCELA == SEZ->EZ_SEQ .or. SE1->E1_ADITIVO == SEZ->EZ_SEQ )
            exit
         endif
         SEZ->( dbSkip() )
      end
   endif

   SA1->( dbSeek( xFilial( "SA1" ) + SE1->E1_CLIENTE + SE1->E1_LOJA, .T. ) )

   if SE1->E1_ADITIVO == " "
      dEmissao := SA1->A1_DATAVEN
   elseif SE1->E1_ADITIVO == "1"
      dEmissao := SA1->A1_DATAV1
   elseif SE1->E1_ADITIVO == "2"
      dEmissao := SA1->A1_DATAV2
   elseif SE1->E1_ADITIVO == "3"
      dEmissao := SA1->A1_DATAV3
   elseif SE1->E1_ADITIVO == "4"
      dEmissao := SA1->A1_DATAV4
   elseif SE1->E1_ADITIVO == "5"
      dEmissao := SA1->A1_DATAV5
   elseif SE1->E1_ADITIVO == "6"
      dEmissao := SA1->A1_DATAV6
   elseif SE1->E1_ADITIVO == "7"
      dEmissao := SA1->A1_DATAV7
   endif

   dEmis      := dEmissao
   nValIndx   := nSalIndx := nValOrigIndx := SE1->E1_VALINDX
   nValorAnt  := nValAtu := SE1->E1_VALORIG
   nBparcial  := 0
   dBaixa     := SE1->E1_BAIXA
   aValor     := { 0, 0, 0, 0, 0, 0, 0, 0, "", 0 }
   cCarteira  := "R"

   Baixa_per()  // Baixas realizadas no periodo, funcao BAIXAS adaptada.

   nValRec  := aValor[ 5 ]
   nValjur  := aValor[ 3 ] + aValor[ 4 ]
   nValDesc := aValor[ 2 ]

   if nValrec == 0
      SE1->( dbSkip() )
      IncRegua()
      Loop
   endif

   nCorrecao:= SE1->E1_VALOR - SE1->E1_VALORIG

   if Year( dEmissao) >= 2000
      nCorr1999 := 0
      nCorr2000 := nCorrecao
   else
      nCorr1999:= SE1->E1_SALDO99 - SE1->E1_VALORIG
      nCorr2000:= SE1->E1_VALOR   - SE1->E1_SALDO99
   endif

   if nBparcial > 0 .or. ( SE1->E1_SALDO #0 .and. !Empty( SE1->E1_BAIXA )  ) // Se houve baixa parcial
      nCorrecao := nValAtu - SE1->E1_VALORIG
      nPerc     := Round( SE1->E1_VALORIG * 100 / nValAtu, 6 )
      nPercRec  := Round( aValor[ 6 ] * 100 / nValAtu, 4 )
      nCorrecao := Round( aValor[ 6 ] * (100-nPerc)/100, 2 )     // aValor[ 6 ] * ( 100 - nPerc ) / 100
      if Substr( SE1->E1_NTIT, 5, 1 ) #"S"
         nValorig := Round( aValor[ 6 ] * nPerc / 100, 2 )
      else
         nValorig := aValor[ 6 ]
      endif
      if Year( dEmissao) >= 2000
         nCorr1999 := 0
         nCorr2000 := nCorrecao
      else
         nCorr1999 := Round( (SE1->E1_SALDO99 - SE1->E1_VALORIG) * nPercRec/100, 2 )
         nCorr2000 := nCorrecao - nCorr1999
      endif
   else
      nValorig  := SE1->E1_VALORIG
   endif

   // Inicio do calculo por fator a partir do valor original obtido
   dDez99 := Ctod( "01/01/2000" )
   SEX->( dbSeek( xFilial( "SEX" ) + SEZ->EZ_INDICE + Dtos( dDez99 ), .t. ) )
   nValIndx := Round( nValorig / SEX->EX_VALOR, 6 )
   nJurPant := Round( nValIndx * SEZ->EZ_PCORANT/30/100, 6 )
   nJurPpos := Round( nValIndx * SEZ->EZ_PCORPOS/30/100, 6 )
   nJurIant := Round( nValIndx * SEZ->EZ_CMINTAN/30/100, 6 )
   nJurIpos := Round( nValIndx * SEZ->EZ_CMINTDP/30/100, 6 )

   SEX->( dbSeek( xFilial( "SEX" ) + SEZ->EZ_INDICE + Dtos( dBaixa ), .t. ) )

   if dBaixa < SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "MEN MEX" .or. SE1->E1_PREFIXO $ "MEN MEX" )
      nJurIndx := Round( nJurPant * ( dBaixa - dDez99 ) * SEX->EX_VALOR, 2 )
   elseif dBaixa < SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "INT YNT IT0"  .or. SE1->E1_PREFIXO $ "INT YNT IT0" )
      nJurIndx := Round( nJurIant * ( dBaixa - dDez99 ) * SEX->EX_VALOR, 2 )
   elseif dBaixa >= SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "MEN MEX" .or. SE1->E1_PREFIXO $ "MEN MEX" )
      nJurIndx := Round( nJurPant * ( SEZ->EZ_DATENT - dDez99 ) * SEX->EX_VALOR, 2 )
      nJurIndx := Round( nJurPpos * ( dBaixa - (SEZ->EZ_DATENT)   ) * SEX->EX_VALOR, 2 ) + nJurIndx
   elseif dBaixa >= SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "INT YNT IT0" .or. SE1->E1_PREFIXO $ "INT YNT IT0" )
      nJurIndx := Round( nJurIant * ( SEZ->EZ_DATENT - dDez99 ) * SEX->EX_VALOR, 2 )
      nJurIndx := Round( nJurIpos * ( dBaixa - (SEZ->EZ_DATENT)   ) * SEX->EX_VALOR, 2 ) + nJurIndx
   else
      nJurIndx := 0
   endif
   nValCorr  := nJurIndx + Round( nValIndx * SEX->EX_VALOR, 2 )
   if Year( dEmissao ) < 2000
      nCorr2000 := nValCorr - nValorig
      nCorr1999 := nCorrecao - nCorr2000
   else
      nCorr2000 := nCorrecao
      nCorr1999 := 0
   endif
   if nCorr2000 > nCorrecao
      nCorr2000 := nCorrecao
      nCorr1999 := nCorrecao - nCorr2000
   endif
   // Fim Calculo por fator a partir de 31/12/1999
   if Alltrim( SE1->E1_CC ) $ "202010 202011"
      nCorr1999 := 0
      nCorr2000 := nCorrecao
   endif
   IF nCorrecao == 0 .or. Substr( SE1->E1_NTIT, 5, 1 ) == "S" .and. SE1->E1_PREFIXO #"RES"
      nCorr1999 := 0
      nCorr2000 := 0
      nCorrecao := 0
   endif
   cCC := SE1->E1_CC

   RecLock( "TMP", .t. )
   TMP->E1_CLIENTE := SE1->E1_CLIENTE;   TMP->A1_NREDUZ := SA1->A1_NREDUZ
   TMP->E1_LOJA    := SE1->E1_LOJA;      TMP->A1_CONTA  := SA1->A1_CONTA
   TMP->E1_CC      := cCC;               TMP->E1_TITULO := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
   TMP->A1_DATAVEN := dEmissao;          TMP->E1_BAIXA  := dBaixa
   TMP->E1_VALORIG := nValorig;          TMP->CORRECAO  := nCorrecao
   TMP->CORR1999   := nCorr1999;         TMP->CORR2000  := nCorr2000
   TMP->JUROS      := nValJur;           TMP->DESCONTOS := nValDesc
   TMP->VALREC     := nValRec+aValor[10];TMP->DACAO     := aValor[ 10 ]
   TMP->( MsUnlock() )
   TMP->( dbCommit() )

   SE1->( dbSkip() )
   IncRegua()

end

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processando o arquivo de CQG                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if Select("XE1")==0
   cArq := "\gestao\dadosadv\se1020"
   dbUseArea( .T.,"TOPCONN", ( cArq ), "xe1", .T. , .F. )
   dbSetindex( ( cArq ) )

   cArq := "\gestao\dadosadv\sa1020"
   dbUseArea( .T.,"TOPCONN", ( cArq ), "xa1", .T. , .F. )
   dbSetindex( ( cArq ) )

   cArq := "\gestao\dadosadv\se5020"
   dbUseArea( .T.,"TOPCONN", ( cArq ), "xe5", .T. , .F. )
   dbSetindex( ( cArq ) )

   cArq := "\gestao\dadosadv\sez020"
   dbUseArea( .T.,"TOPCONN", ( cArq ), "xez", .T. , .F. )
   dbSetindex( ( cArq ) )

   cArq := "\gestao\dadosadv\se2020"
   dbUseArea( .T.,"TOPCONN", ( cArq ), "xe2", .T. , .F. )
   dbSetindex( ( cArq ) )
endif

// Filtro arquivo xE1
dbselectArea("XE1")
cFiltro := "E1_CC>=mv_par01.and.E1_CC<=mv_par02.and.E1_CLIENTE>=mv_par03.and.E1_CLIENTE<=mv_par04.and.!Empty(E1_BAIXA)"
cChave  := "E1_CC+Dtos(E1_BAIXA)"
cIndSe1 := CriaTrab(nil,.f.)
IndRegua( "XE1", cIndSe1, cChave, , cFiltro,"Selecionando Titulos...." )
XE1->( dbGoTop() )

SetRegua( XE1->( Lastrec() ) )
while XE1->( !Eof() )

   if SM0->M0_CODIGO == "01"
      cCC := XE1->E1_CC
   else
      cCC := Substr( XE1->E1_CC, 1, 4 )
   endif

   XEZ->( dbSetOrder( 1 ) )
   XEZ->( dbSeek( xFilial( "XEZ" ) + XE1->E1_NUM, .T. ) )
   if XEZ->EZ_NUM #XE1->E1_NUM .or. XEZ->EZ_CLIENTE # XE1->E1_CLIENTE
      XEZ->( dbSetOrder( 3 ) )
      XEZ->( dbSeek( xFilial( "XEZ" ) + XE1->E1_CLIENTE + XE1->E1_LOJA, .T. ) )
      XEZ->( dbSetOrder( 1 ) )
   else
      while XEZ->EZ_NUM == XE1->E1_NUM .and. XEZ->( !Eof() )
         if XEZ->EZ_NUM == XE1->E1_NUM .and. ( XE1->E1_PARCELA == XEZ->EZ_SEQ .or. XE1->E1_ADITIVO == XEZ->EZ_SEQ )
            exit
         endif
         XEZ->( dbSkip() )
      end
   endif

   XA1->( dbSeek( xFilial( "SA1" ) + XE1->E1_CLIENTE + XE1->E1_LOJA, .T. ) )

   if XE1->E1_ADITIVO == " "
      dEmissao := XA1->A1_DATAVEN
   elseif XE1->E1_ADITIVO == "1"
      dEmissao := XA1->A1_DATAV1
   elseif XE1->E1_ADITIVO == "2"
      dEmissao := XA1->A1_DATAV2
   elseif XE1->E1_ADITIVO == "3"
      dEmissao := XA1->A1_DATAV3
   elseif XE1->E1_ADITIVO == "4"
      dEmissao := XA1->A1_DATAV4
    elseif XE1->E1_ADITIVO == "5"
      dEmissao := XA1->A1_DATAV5
   elseif XE1->E1_ADITIVO == "6"
      dEmissao := XA1->A1_DATAV6
   elseif XE1->E1_ADITIVO == "7"
      dEmissao := XA1->A1_DATAV7
   endif

   dEmis      := dEmissao
   nValIndx   := nSalIndx := nValOrigIndx := XE1->E1_VALINDX
   nValorAnt  := nValAtu := XE1->E1_VALORIG
   nBparcial  := 0
   dBaixa     := XE1->E1_BAIXA
   aValor     := { 0, 0, 0, 0, 0, 0, 0, 0, "", 0 }
   cCarteira  := "R"

   Baix_perx()  // Baixas realizadas no periodo, funcao BAIXAS adaptada.

   nValRec  := aValor[ 5 ]
   nValjur  := aValor[ 3 ] + aValor[ 4 ]
   nValDesc := aValor[ 2 ]

   if nValrec == 0
      XE1->( dbSkip() )
      IncRegua()
      Loop
   endif

   nCorrecao:= XE1->E1_VALOR - XE1->E1_VALORIG

   if Year( dEmissao) >= 2000
      nCorr1999 := 0
      nCorr2000 := nCorrecao
   else
      nCorr1999:= XE1->E1_SALDO99 - XE1->E1_VALORIG
      nCorr2000:= XE1->E1_VALOR   - XE1->E1_SALDO99
   endif

   if nBparcial > 1 .or. ( XE1->E1_SALDO #0 .and. !Empty( XE1->E1_BAIXA )  ) // Se houve baixa parcial
      // msgbox( "valor "+str(XE1->e1_VALOR,12,2)+" NVALATU "+STR(NVALATU,12,2),"INFO","STOP")
      nCorrecao := nValAtu - XE1->E1_VALORIG
      nPerc     := Round( XE1->E1_VALORIG * 100 / nValAtu, 6 )
      nPercRec  := Round( aValor[ 6 ] * 100 / nValAtu, 4 )
      nCorrecao := Round( aValor[ 6 ] * (100-nPerc)/100, 2 )     // aValor[ 6 ] * ( 100 - nPerc ) / 100
      if Substr( XE1->E1_NTIT, 5, 1 ) #"S"
         nValorig := Round( aValor[ 6 ] * nPerc / 100, 2 )
      else
         nValorig := aValor[ 6 ]
      endif
      if Year( dEmissao) >= 2000
         nCorr1999 := 0
         nCorr2000 := nCorrecao
      else
         nCorr1999 := Round( (XE1->E1_SALDO99 - XE1->E1_VALORIG) * nPercRec/100, 2 )
         nCorr2000 := nCorrecao - nCorr1999
      endif

      // msgbox( "parcela "+XE1->e1_prefixo+XE1->e1_num+" valor orig "+str(XE1->e1_valorig,12,2)+" valor atu "+str(NVALATU,12,2)+" perc. "+str(nperc,6,2)+" saldo 99 "+ str(XE1->e1_saldo99,12,2)+ " avalor "+str(aValor[6],12,2),"INFO","STOP")
      // msgbox( "parcela "+XE1->e1_prefixo+XE1->e1_num+" orig "+str(nvalorig,12,2)+" cor.acm "+str(ncorrecao,12,2)+" cor.31/12 "+str(ncorr1999,12,2)+" apos "+str(ncorr2000,12,2),"info","stop")
   else
      nValorig  := XE1->E1_VALORIG
   endif

   // Inicio do calculo por fator a partir do valor original obtido
   dDez99 := Ctod( "01/01/2000" )
   SEX->( dbSeek( xFilial( "SEX" ) + SEZ->EZ_INDICE + Dtos( dDez99 ), .t. ) )
   nValIndx := Round( nValorig / SEX->EX_VALOR, 6 )
   nJurPant := Round( nValIndx * XEZ->EZ_PCORANT/30/100, 6 )
   nJurPpos := Round( nValIndx * XEZ->EZ_PCORPOS/30/100, 6 )
   nJurIant := Round( nValIndx * XEZ->EZ_CMINTAN/30/100, 6 )
   nJurIpos := Round( nValIndx * XEZ->EZ_CMINTDP/30/100, 6 )

   SEX->( dbSeek( xFilial( "SEX" ) + XEZ->EZ_INDICE + Dtos( dBaixa ), .t. ) )

   if dBaixa < XEZ->EZ_DATENT .and. ( XE1->E1_PREFIMO $ "MEN MEX" .or. XE1->E1_PREFIXO $ "MEN MEX" )
      nJurIndx := Round( nJurPant * ( dBaixa - dDez99 ) * SEX->EX_VALOR, 2 )
   elseif dBaixa < XEZ->EZ_DATENT .and. ( XE1->E1_PREFIMO $ "INT YNT IT0"  .or. XE1->E1_PREFIXO $ "INT YNT IT0" )
      nJurIndx := Round( nJurIant * ( dBaixa - dDez99 ) * SEX->EX_VALOR, 2 )
   elseif dBaixa >= XEZ->EZ_DATENT .and. ( XE1->E1_PREFIMO $ "MEN MEX" .or. XE1->E1_PREFIXO $ "MEN MEX" )
      nJurIndx := Round( nJurPant * ( XEZ->EZ_DATENT - dDez99 ) * SEX->EX_VALOR, 2 )
      nJurIndx := Round( nJurPpos * ( dBaixa - (XEZ->EZ_DATENT)   ) * SEX->EX_VALOR, 2 ) + nJurIndx
   elseif dBaixa >= XEZ->EZ_DATENT .and. ( XE1->E1_PREFIMO $ "INT YNT IT0" .or. XE1->E1_PREFIXO $ "INT YNT IT0" )
      nJurIndx := Round( nJurIant * ( XEZ->EZ_DATENT - dDez99 ) * SEX->EX_VALOR, 2 )
      nJurIndx := Round( nJurIpos * ( dBaixa - (XEZ->EZ_DATENT)   ) * SEX->EX_VALOR, 2 ) + nJurIndx
   else
      nJurIndx := 0
   endif

   nValCorr  := nJurIndx + Round( nValIndx * SEX->EX_VALOR, 2 )
   if Year( dEmissao ) < 2000
      nCorr2000 := nValCorr - nValorig
      nCorr1999 := nCorrecao - nCorr2000
   else
      nCorr2000 := nCorrecao
      nCorr1999 := 0
   endif

   if nCorr2000 > nCorrecao
      nCorr2000 := nCorrecao
      nCorr1999 := nCorrecao - nCorr2000
   endif
   // Fim Calculo por fator a partir de 31/12/1999

   if Alltrim( XE1->E1_CC ) $ "202010 202011"
      nCorr1999 := 0
      nCorr2000 := nCorrecao
   endif

   IF nCorrecao == 0 .or. Substr( XE1->E1_NTIT, 5, 1 ) == "S" .and. XE1->E1_PREFIXO #"RES"
      nCorr1999 := 0
      nCorr2000 := 0
      nCorrecao := 0
   endif

   // Tratamento especifico para centro de custo da CQG
   if Substr( XE1->E1_CC, 1, 4 ) == "2101"
      cCC := "202031"
   elseif Substr( XE1->E1_CC, 1, 4 ) == "2104"
      cCC := "202026"
   elseif Substr( XE1->E1_CC, 1, 4 ) == "2105"
      cCC := "202032"
   elseif Substr( XE1->E1_CC, 1, 4 ) == "2110"
      cCC := "202023"
   elseif Substr( XE1->E1_CC, 1, 4 ) == "2111"
      cCC := "202035"
   elseif Substr( XE1->E1_CC, 1, 4 ) == "2112"
      cCC := "202024"
   elseif Substr( XE1->E1_CC, 1, 4 ) == "2114"
      cCC := "202025"
   elseif Substr( XE1->E1_CC, 1, 4 ) == "2116"
      cCC := "202027"
   elseif Substr( XE1->E1_CC, 1, 4 ) == "2117"
      cCC := "202028"
   elseif Substr( XE1->E1_CC, 1, 4 ) == "2118"
      cCC := "202030"
   elseif Substr( XE1->E1_CC, 1, 4 ) == "2201"
      cCC := "202029"
   elseif Substr( XE1->E1_CC, 1, 7 ) == "1602008"
      cCC := "202035"
   else
      cCC := XE1->E1_CC
   endif

   RecLock( "TMP", .t. )
   TMP->E1_CLIENTE := XE1->E1_CLIENTE;   TMP->A1_NREDUZ := XA1->A1_NREDUZ
   TMP->E1_LOJA    := XE1->E1_LOJA;      TMP->A1_CONTA  := XA1->A1_CONTA
   TMP->E1_CC      := cCC;               TMP->E1_TITULO := XE1->E1_PREFIXO+XE1->E1_NUM+XE1->E1_PARCELA
   TMP->A1_DATAVEN := dEmissao;          TMP->E1_BAIXA  := dBaixa
   TMP->E1_VALORIG := nValorig;          TMP->CORRECAO  := nCorrecao
   TMP->CORR1999   := nCorr1999;         TMP->CORR2000  := nCorr2000
   TMP->JUROS      := nValJur;           TMP->DESCONTOS := nValDesc
   TMP->VALREC     := nValRec+aValor[10];TMP->DACAO     := aValor[ 10 ]
   TMP->( MsUnlock() )
   TMP->( dbCommit() )

   XE1->( dbSkip() )
   IncRegua()

end

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Distratos - Processando o arquivo de empreendimentos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Filtro arquivo SEZ
SE2->( dbSetOrder( 6 ) )
dbselectArea("SEZ")
SEZ->( dbGoTop() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  regua de impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua( Lastrec() )
aDistrato := {}
while SEZ->( !Eof() )

   if Empty( SEZ->EZ_FORNECE )
      SEZ->( dbSkip() )
      IncRegua()
      Loop
   endif

   SE2->( dbSeek( xFilial( "SE2" ) + SEZ->EZ_FORNECE + SEZ->EZ_LOJAFOR, .t. ) )
   While SE2->( !Eof() ) .and. SEZ->EZ_FORNECE + SEZ->EZ_LOJAFOR == SE2->E2_FORNECE + SE2->E2_LOJA

      if SE2->E2_CC>=mv_par01.and.SE2->E2_CC<=mv_par02.and.SE2->E2_BAIXA>= mv_par05.and.SE2->E2_BAIXA<=mv_par06
         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Vetor total de distrato por centro de custo               ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

         // Tratamento especifico para centro de custo da CQG
         if Substr( SE2->E2_CC, 1, 4 ) == "2101"
            cCC := "202031"
         elseif Substr( SE2->E2_CC, 1, 4 ) == "2104"
            cCC := "202026"
         elseif Substr( SE2->E2_CC, 1, 4 ) == "2105"
            cCC := "202032"
         elseif Substr( SE2->E2_CC, 1, 4 ) == "2110"
            cCC := "202023"
         elseif Substr( SE2->E2_CC, 1, 4 ) == "2111"
            cCC := "202035"
         elseif Substr( SE2->E2_CC, 1, 4 ) == "2112"
            cCC := "202024"
         elseif Substr( SE2->E2_CC, 1, 4 ) == "2114"
            cCC := "202025"
         elseif Substr( SE2->E2_CC, 1, 4 ) == "2116"
            cCC := "202027"
         elseif Substr( SE2->E2_CC, 1, 4 ) == "2117"
            cCC := "202028"
         elseif Substr( SE2->E2_CC, 1, 4 ) == "2118"
            cCC := "202030"
         elseif Substr( SE2->E2_CC, 1, 4 ) == "2201"
            cCC := "202029"
         elseif Substr( SE2->E2_CC, 1, 7 ) == "1602008"
            cCC := "202035"
         else
            cCC := SE2->E2_CC
         endif

         nP := Ascan( aDistrato, { |aVal| aVal[1]==Substr(cCC,1,6) } )
         If nP == 0
            Aadd( aDistrato, { Substr(cCC,1,6), 0 } )
            nP := Len( aDistrato )
         Endif

         aDistrato[ nP, 2 ] := aDistrato[ nP, 2 ] + SE2->E2_VALOR
      endif

      SE2->( dbSkip() )

   End

   SEZ->( dbSkip() )
   IncRegua()

end


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Distratos - Processando o arquivo de CQG                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Filtro arquivo XEZ
XE2->( dbSetOrder( 6 ) )
dbselectArea("XEZ")
XEZ->( dbGoTop() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  regua de impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua( Lastrec() )
while XEZ->( !Eof() )

   if Empty( XEZ->EZ_FORNECE )
      XEZ->( dbSkip() )
      IncRegua()
      Loop
   endif

   XE2->( dbSeek( xFilial( "SE2" ) + XEZ->EZ_FORNECE + XEZ->EZ_LOJAFOR, .t. ) )
   While XE2->( !Eof() ) .and. XEZ->EZ_FORNECE + XEZ->EZ_LOJA == XE2->E2_FORNECE + XE2->E2_LOJA

      if XE2->E2_CC>=mv_par01.and.XE2->E2_CC<=mv_par02.and.XE2->E2_BAIXA>= mv_par05.and.XE2->E2_BAIXA<=mv_par06
         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Vetor total de distrato por centro de custo               ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

         // Tratamento especifico para centro de custo da CQG
         if Substr( XE2->E2_CC, 1, 4 ) == "2101"
            cCC := "202031"
         elseif Substr( XE2->E2_CC, 1, 4 ) == "2104"
            cCC := "202026"
         elseif Substr( XE2->E2_CC, 1, 4 ) == "2105"
            cCC := "202032"
         elseif Substr( XE2->E2_CC, 1, 4 ) == "2110"
            cCC := "202023"
         elseif Substr( XE2->E2_CC, 1, 4 ) == "2111"
            cCC := "202035"
         elseif Substr( XE2->E2_CC, 1, 4 ) == "2112"
            cCC := "202024"
         elseif Substr( XE2->E2_CC, 1, 4 ) == "2114"
            cCC := "202025"
         elseif Substr( XE2->E2_CC, 1, 4 ) == "2116"
            cCC := "202027"
         elseif Substr( XE2->E2_CC, 1, 4 ) == "2117"
            cCC := "202028"
         elseif Substr( XE2->E2_CC, 1, 4 ) == "2118"
            cCC := "202030"
         elseif Substr( XE2->E2_CC, 1, 4 ) == "2201"
            cCC := "202029"
         elseif Substr( XE2->E2_CC, 1, 7 ) == "1602008"
            cCC := "202035"
         else
            cCC := XE2->E2_CC
         endif

         nP := Ascan( aDistrato, { |aVal| aVal[1]==Substr(cCC,1,6) } )
         If nP == 0
            Aadd( aDistrato, { Substr(cCC,1,6), 0 } )
            nP := Len( aDistrato )
         Endif

         aDistrato[ nP, 2 ] := aDistrato[ nP, 2 ] + XE2->E2_VALOR
      endif

      XE2->( dbSkip() )
      IncRegua()

   End

   SEZ->( dbSkip() )
   IncRegua()

end

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Impressao do Relatorio                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cFiltro := ""
if aReturn[ 8 ] == 1
   cChave  := "E1_CC"
   cCodigo := cCC := Substr( TMP->E1_CC, 1, 6 )
else
   cChave  := "A1_CONTA"
   cCodigo := Substr( TMP->A1_CONTA, 1, 9 )
endif
TMP->( dbGotop() )
cArqInd := CriaTrab( nil,.f. )
IndRegua( "TMP", cArqInd, cChave, , cFiltro, "Indexando Arquivo de Trabalho..." )
SetRegua( TMP->( LastRec() ) )

mPag      := 1
nLin      := 66
nBaseCalc :=nDistrato := nCCorig  := nCCcorr  := nCCcorr99  := nCCcorr00  := nCCjuros  := nCCvlrec  := nCCdesc  := nCCdacao  := nCCnTrib  := 0
nTBaseCalc:=nTDistrato:= nTotorig := nTotcorr := nTotcorr99 := nTotcorr00 := nTotjuros := nTotvlrec := nTotdesc := nTotdacao := nTotnTrib := 0
nTCofins  := nTIrpj   := nTCsll     := nTPisRep   := nTPisDed  := 0
nCofins   := nCsll := nIrpj := nPisRep := nPisDed := 0

if nLin > 60
   mPag := mPag + 1
   nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) + 2 //Impressao do cabecalho
endif

aCC := {}

if mv_par14 == 2

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Funcoes para lancamento padrao                               ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   aRotina := {    { "Pesquisar" ,"A460Pesqui", 0 , 1},;
                   { "Ordem",     "A460Ordem",  0 , 0},;
                   { "Gera Notas","A460Nota",   0 , 3},;
                   { "Estornar","A460Estor", 0 , 0}    }
   cArquivo := ""; nTotal := 0
   lLanc    := iif( mv_par15==1,.t.,.t.)
   SX5->( dbSeek( xFilial( "SX5" ) + "09R01", .t. ) )
   cLoteR01 := Alltrim( SX5->X5_DESCRI )
   nHdlPrv := HeadProva( cLoteR01, "CONR01",Substr( cUsuario,7,6 ), @cArquivo )
endif

While TMP->( !Eof() )

   #IFNDEF WINDOWS
      IF LastKey()==286
         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
         lContinua := .F.
         Exit
      Endif
   #ELSE
      IF lAbortPrint
         @ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
         lContinua := .F.
         Exit
      Endif
   #ENDIF

   if mv_par07 == 1
      if aReturn[ 8 ] == 1
         SI3->( dbSeek( xFilial( "SI3" ) + cCodigo, .t. ) )
         cDesc := SI3->I3_DESC
      else
         SI1->( dbSeek( xFilial( "SI1" ) + cCodigo, .t. ) )
         cDesc := SI1->I1_DESC
      endif
      @ nLin,000 pSay cCodigo + " " + cDesc
      nLin := nLin + 2
   endif

   While Iif( aReturn[ 8 ]==1, Substr( TMP->E1_CC, 1, 6 ), Substr( TMP->A1_CONTA, 1, 9 ) ) == cCodigo .and. TMP->( !Eof() )

      if nLin > 60
         mPag := mPag + 1
         nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) + 2 //Impressao do cabecalho
         if mv_par07 == 1
            @ nLin,000 PSAY cCodigo + " " + cDesc
            nLin  := nLin + 2
         endif
      endif

      if mv_par07 == 1
         @ nLin, 000 pSay TMP->E1_CLIENTE
         @ nLin, 007 pSay TMP->E1_LOJA
         @ nLin, 010 pSay TMP->A1_NREDUZ
         @ nLin, 040 pSay TMP->DACAO      Picture "@E 999,999,999.99"
         @ nLin, 057 pSay TMP->E1_TITULO
         @ nLin, 070 pSay TMP->A1_DATAVEN
         @ nLin, 081 pSay TMP->E1_BAIXA
         @ nLin, 094 pSay TMP->E1_VALORIG Picture "@E 999,999,999.99"
         @ nLin, 107 pSay TMP->CORRECAO   Picture "@E 999,999,999.99"
         @ nLin, 120 pSay TMP->CORR1999   Picture "@E 999,999,999.99"
         @ nLin, 133 pSay TMP->CORR2000   Picture "@E 999,999,999.99"
         @ nLin, 152 pSay TMP->JUROS      Picture "@E 999,999.99"
         @ nLin, 163 pSay TMP->DESCONTOS  Picture "@E 999,999.99"
         @ nLin, 182 pSay TMP->VALREC     Picture "@E 999,999,999.99"
         nLin      := nLin      + 1
      endif

      if Month( TMP->E1_BAIXA ) == 1 .and. Year( TMP->E1_BAIXA ) == 2000
         if TMP->E1_CLIENTE $ "120001 100204 131103 120102 150001 160901 120002"
            nCsll     := nCsll  + ( TMP->CORR2000 * .0144 ) + ( TMP->JUROS * .12 )
         else
            nCsll     := nCsll  + ( ( ( TMP->E1_VALORIG + TMP->CORR2000 ) * .0144 ) + ( TMP->JUROS * .09 ) )
         endif
      else
         if TMP->E1_CLIENTE $ "120001 100204 131103 120102 150001 160901 120002"
            nCsll     := nCsll  + ( TMP->CORR2000 * .0108 ) + ( TMP->JUROS * .09 )
         else
            nCsll     := nCsll  + ( ( ( TMP->E1_VALORIG + TMP->CORR2000 ) * .0108 ) + ( TMP->JUROS * .09 ) )
         endif
      endif

      nCCdacao  := nCCdacao  + TMP->DACAO
      nCCorig   := nCCorig   + TMP->E1_VALORIG
      nCCcorr   := nCCcorr   + TMP->CORRECAO
      nCCcorr99 := nCCcorr99 + TMP->CORR1999
      nCCcorr00 := nCCcorr00 + TMP->CORR2000
      nCCjuros  := nCCjuros  + TMP->JUROS
      nCCdesc   := nCCdesc   + TMP->DESCONTOS
      nCCvlrec  := nCCvlrec  + TMP->VALREC

      if TMP->E1_CLIENTE $ "120001 100204 131103 120102 150001 160901 120002"
         nBaseCalc := nBaseCalc + TMP->CORR2000
         nCCnTrib  := nCCnTrib  + TMP->E1_VALORIG
      else
         nBaseCalc := nBaseCalc + TMP->E1_VALORIG + TMP->CORR2000
      endif

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Vetor para resumo por centro de custo                     ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      nP      := Ascan( aCC, { |aVal| aVal[1]==TMP->E1_CC } )
      If nP == 0
         Aadd( aCC, { TMP->E1_CC, 0, 0, 0, 0, 0, 0, 0, 0 } )
         nP := Len( aCC )
      Endif

      aCC[ nP, 2 ] := aCC[ nP, 2 ] + TMP->E1_VALORIG
      aCC[ nP, 3 ] := aCC[ nP, 3 ] + TMP->CORRECAO
      aCC[ nP, 4 ] := aCC[ nP, 4 ] + TMP->CORR1999
      aCC[ nP, 5 ] := aCC[ nP, 5 ] + TMP->CORR2000
      aCC[ nP, 6 ] := aCC[ nP, 6 ] + TMP->JUROS
      aCC[ nP, 7 ] := aCC[ nP, 7 ] + TMP->DESCONTOS
      aCC[ nP, 8 ] := aCC[ nP, 8 ] + TMP->VALREC
      aCC[ nP, 9 ] := aCC[ nP, 9 ] + TMP->DACAO

      TMP->( dbSkip() )
      IncRegua()

   end

   if nCCvlrec #0

      if nLin > 56
         mPag := mPag + 1
         nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) + 2 //Impressao do cabecalho
         if mv_par07 == 1
            @ nLin,000 PSAY cCodigo + " " + cDesc
            nLin  := nLin + 2
         endif
      endif

      nLin := nLin + 1
      if mv_par07 == 1
         @ nLin, 000 pSay "Sub- Total do "+iif(aReturn[ 8 ]==1,"Centro de Custo","Edificio" )
      else
         SI3->( dbSeek( xFilial( "SI3" ) + cCodigo, .t. ) )
         cDesc := SI3->I3_DESC
         @ nLin, 000 pSay cCodigo + "  " + cDesc
      endif
      @ nLin, 040 pSay nCCdacao   Picture "@E 999,999,999.99"
      @ nLin, 094 pSay nCCorig    Picture "@E 999,999,999.99"
      @ nLin, 107 pSay nCCcorr    Picture "@E 999,999,999.99"
      @ nLin, 120 pSay nCCcorr99  Picture "@E 999,999,999.99"
      @ nLin, 133 pSay nCCcorr00  Picture "@E 999,999,999.99"
      @ nLin, 152 pSay nCCjuros   Picture "@E 999,999.99"
      @ nLin, 163 pSay nCCdesc    Picture "@E 999,999.99"
      @ nLin, 182 pSay nCCvlrec   Picture "@E 999,999,999.99"
      nLin  := nLin + 2
      lFlag := .t.

      nP      := Ascan( aDistrato, { |aVal| Substr(aVal[1],1,6)==Substr(cCodigo,1,6) } )
      If nP == 0
         nDistrato := 0
      else
         nDistrato := aDistrato[ nP, 2 ]
      Endif

      nBaseCalc := nBasecalc - nDistrato
      nCofins   := Round( ( nBaseCalc ) * 0.02, 2 )
      nIrpj1    := Round( ( ( nBaseCalc ) * 0.012 ) + ( nCCjuros * 0.15 ), 2 )
      nPisRep   := nPisDed := Round( nIrpj1 * 0.05, 2 )
      nIrpj     := nIrpj1 - nPisDed
      nCsll     := Round( nCsll, 2 )

      @ nLin  ,070 pSay "Receita...........: "+Transform( ( nBaseCalc + nDistrato ),"@E 999,999,999.99" ) + " Receita nao Tributada.: "+Transform( nCCnTrib, "@E 999,999,999.99" )
      @ nLin+1,070 pSay "Distratos.........: "+Transform( nDistrato,"@E 999,999,999.99" )
      @ nLin+2,070 pSay "Base de Calculo...: "+Transform( nBaseCalc,"@E 999,999,999.99" ) + " Receita Financeira "+Transform( nCCjuros, "@E 999,999,999.99" )
      @ nLin+3,070 pSay "Valor do Cofins...: "+Transform( nCofins, "@E 999,999,999.99" )
      @ nLin+4,070 pSay "Valor I.R.P.J.....: "+Transform( nIrpj,   "@E 999,999,999.99" )
      @ nLin+5,070 pSay "Valor C.S.L.L.....: "+Transform( nCsll,   "@E 999,999,999.99" )
      @ nLin+6,070 pSay "Valor PIS Repique.: "+Transform( nPisRep, "@E 999,999,999.99" )
      @ nLin+7,070 pSay "Valor PIS Deducao.: "+Transform( nPisDed, "@E 999,999,999.99" )

      nLin     := nLin + 9

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Contabilizacao do relatorio                               ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      if mv_par14 == 2          // Contabilizar 2-Sim
         nTotal := nTotal + DetProva( nHdlPrv,"R01","CONR01",cLoteR01 )
      endif

      nTDistrato:= nTDistrato + nDistrato
      nTBaseCalc:= nTBaseCalc + nBaseCalc
      nTCofins  := nTCofins   + nCofins
      nTIrpj    := nTIrpj     + nIrpj
      nTPisRep  := nTPisRep   + nPisRep
      nTPisDed  := nTPisDed   + nPisDed
      nTCsll    := nTCsll     + nCsll
      nTotnTrib := nTotnTrib  + nCCnTrib
      nCofins   := nIrpj := nPisRep := nPisDed := nCsll := nDistrato := nBaseCalc := nCCnTrib := 0

   endif

   if aReturn[ 8 ] == 1
      cCodigo := cCC := Substr( TMP->E1_CC, 1, 6 )
   else
      cCodigo := Substr( TMP->A1_CONTA, 1, 9 )
   endif


   nTotdacao  := nTotdacao  + nCCdacao
   nTotorig   := nTotorig   + nCCorig
   nTotcorr   := nTotcorr   + nCCcorr
   nTotcorr99 := nTotcorr99 + nCCcorr99
   nTotcorr00 := nTotcorr00 + nCCcorr00
   nTotjuros  := nTotjuros  + nCCjuros
   nTotdesc   := nTotdesc   + nCCdesc
   nTotvlrec  := nTotvlrec  + nCCvlrec
   nCCorig    := nCCcorr := nCCcorr99 := nCCcorr00 := nCCjuros := nCCdesc := nCCvlrec := nCCdacao := 0

end

nReceitFin := nAtivoImob := nDesconObt := 0
if mv_par08 == 2              // Calcula Receita Financeira - Sim
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Inicio - Valor Receita financeira - Administracao         ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   cCodigo    := cCC := mv_par10
   nReceitFin := nAtivoImob := nDesconObt := 0
   nBaseDed   := nCsll := 0
   nAno       := Year( mv_par05 )

   For y := 1 to 3

       if y == 1
          SI1->( dbSeek( xFilial( "SI1" ) + mv_par11, .t. ) )
       elseif Y == 2
          SI1->( dbSeek( xFilial( "SI1" ) + mv_par12, .t. ) )
       elseif y == 3
          SI1->( dbSeek( xFilial( "SI1" ) + mv_par13, .t. ) )
       endif

       For x :=  Month( mv_par05 ) to Month( mv_par06 )

           if x == 1
              nSaldoCont := ( SI1->I1_CRDM01 - SI1->I1_DEBM01 )
           elseif x == 2
              nSaldoCont := ( SI1->I1_CRDM02 - SI1->I1_DEBM02 )
           elseif x == 3
              nSaldoCont := ( SI1->I1_CRDM03 - SI1->I1_DEBM03 )
           elseif x == 4
              nSaldoCont := ( SI1->I1_CRDM04 - SI1->I1_DEBM04 )
           elseif x == 5
              nSaldoCont := ( SI1->I1_CRDM05 - SI1->I1_DEBM05 )
           elseif x == 6
              nSaldoCont := ( SI1->I1_CRDM06 - SI1->I1_DEBM06 )
           elseif x == 7
              nSaldoCont := ( SI1->I1_CRDM07 - SI1->I1_DEBM07 )
           elseif x == 8
              nSaldoCont := ( SI1->I1_CRDM08 - SI1->I1_DEBM08 )
           elseif x == 9
              nSaldoCont := ( SI1->I1_CRDM09 - SI1->I1_DEBM09 )
           elseif x == 10
              nSaldoCont := ( SI1->I1_CRDM10 - SI1->I1_DEBM10 )
           elseif x == 11
              nSaldoCont := ( SI1->I1_CRDM11 - SI1->I1_DEBM11 )
           elseif x == 12
              nSaldoCont := ( SI1->I1_CRDM12 - SI1->I1_DEBM12 )
           endif

           if y == 1
              nReceitFin := nReceitFin + nSaldoCont
              nBaseDed   := nBaseDed + mv_par09
           elseif y == 2
              nAtivoImob := nAtivoImob + nSaldoCont
           elseif y == 3
              nDesconObt := nDesconObt + nSaldoCont
           endif

           if x == 1 .and. nAno == 2000
              nCsll := nCsll + Round( nSaldoCont * 0.12, 2 )
           else
              nCsll := nCsll + Round( nSaldoCont * 0.09, 2 )
           endif

       Next

   Next

   if aReturn[ 8 ] == 1
      SI3->( dbSeek( xFilial( "SI3" ) + cCodigo, .t. ) )
      cDesc := SI3->I3_DESC
   else
      SI1->( dbSeek( xFilial( "SI1" ) + cCodigo, .t. ) )
      cDesc := SI1->I1_DESC
   endif
   @ nLin,000 pSay cCodigo + " " + cDesc
   nLin := nLin + 1

   if nLin > 60
      mPag := mPag + 1
      nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) + 2 //Impressao do cabecalho
      @ nLin,000 PSAY cCodigo + " " + cDesc
      nLin := nLin + 2
   endif

   @ nLin, 000 pSay cCodigo
   @ nLin, 007 pSay "Receita Financeira"
   @ nLin, 152 pSay nReceitFin Picture "@E 999,999,999.99"
   nLin      := nLin      + 1

   nBaseCalc := nReceitFin

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Vetor para resumo por centro de custo                     ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   nP      := Ascan( aCC, { |aVal| aVal[1]==cCodigo } )
   If nP == 0
      Aadd( aCC, { cCodigo, 0, 0, 0, 0, 0, 0, 0, 0 } )
      nP := Len( aCC )
   Endif

   aCC[ nP, 8 ] := aCC[ nP, 8 ] + nReceitFin

   if nLin > 56
      mPag := mPag + 1
      nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) + 2 //Impressao do cabecalho
      if mv_par07 == 1
         @ nLin,000 PSAY cCodigo + " " + cDesc
         nLin  := nLin + 2
      endif
   endif

   nLin := nLin + 1
   if mv_par07 == 1
      @ nLin, 000 pSay "Sub- Total do "+iif(aReturn[ 8 ]==1,"Centro de Custo","Edificio" )
   endif
   @ nLin, 152 pSay nReceitFin   Picture "@E 999,999,999.99"
   nLin  := nLin + 2

   nP := Ascan( aDistrato, { |aVal| Substr(aVal[1],1,6)==Substr(cCodigo,1,6) } )
   If nP == 0
      nDistrato := 0
   else
      nDistrato := aDistrato[ nP, 2 ]
   Endif

   nLucroPre := Round( nTBaseCalc * 0.08, 2 )
   nBaseCalc := nBasecalc - nDistrato + nAtivoImob + nDesconObt

   nCofins   := 0
   nIrpj1    := Round( ( nBaseCalc * 0.15 ), 2 )
   nPisRep   := nPisDed := Round( nIrpj1 * 0.05, 2 )
   nIrpj     := nIrpj1 - nPisDed
   nAdicional:= Round( ( nLucroPre + nBasecalc + nTotJuros - nBaseDed ) * 0.10, 2 )

   @ nLin  ,040 pSay "Receita...........: "+Transform( ( nDistrato ),"@E 999,999,999.99" )
   @ nLin+1,040 pSay "Distratos.........: "+Transform( nDistrato,"@E 999,999,999.99" )
   @ nLin+2,040 pSay "Base de Calculo...: "+Transform( nDistrato,"@E 999,999,999.99" ) + " Receita Financeira "+Transform( nReceitFin, "@E 999,999,999.99" );
     +" Venda Ativo Imob.: "+Transform( nAtivoImob,"@E 999,999,999.99" )+" Descontos Obtidos.: "+Transform( nDesconObt,"@E 999,999,999.99" )
   @ nLin+3,040 pSay "Valor do Cofins...: "+Transform( nCofins, "@E 999,999,999.99" )
   @ nLin+4,040 pSay "Valor I.R.P.J.....: "+Transform( nIrpj+nAdicional,"@E 999,999,999.99" )
   @ nLin+5,040 pSay "Valor C.S.L.L.....: "+Transform( nCsll,   "@E 999,999,999.99" )
   @ nLin+6,040 pSay "Valor PIS Repique.: "+Transform( nPisRep, "@E 999,999,999.99" )
   @ nLin+7,040 pSay "Valor PIS Deducao.: "+Transform( nPisDed, "@E 999,999,999.99" )
   nLin     := nLin + 9

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Contabilizacao do relatorio                               ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   if mv_par14 == 2          // Contabilizar 2-Sim
      nTotal := nTotal + DetProva( nHdlPrv,"R01","CONR01",cLoteR01 )
   endif
   nTDistrato:= nTDistrato + nDistrato
   nTCofins  := nTCofins   + nCofins
   nTIrpj    := nTIrpj     + nIrpj  + nAdicional
   nTPisRep  := nTPisRep   + nPisRep
   nTPisDed  := nTPisDed   + nPisDed
   nTCsll    := nTCsll     + nCsll
   nCCjuros  := nCCJuros   + nBaseCalc - nAtivoImob - nDesconObt
   nCofins   := nIrpj := nPisRep := nPisDed := nCsll := nDistrato := nBaseCalc := 0
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim - Receita financeira - Administracao                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTotdacao  := nTotdacao  + nCCdacao
nTotorig   := nTotorig   + nCCorig
nTotcorr   := nTotcorr   + nCCcorr
nTotcorr99 := nTotcorr99 + nCCcorr99
nTotcorr00 := nTotcorr00 + nCCcorr00
nTotjuros  := nTotjuros  + nCCjuros
nTotdesc   := nTotdesc   + nCCdesc
nTotvlrec  := nTotvlrec  + nCCvlrec
nCCorig    := nCCcorr := nCCcorr99 := nCCcorr00 := nCCjuros := nCCdesc := nCCvlrec := nCCdacao := 0

nLin := nLin + 2

if nLin > 56
   nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) + 2 //Impressao do cabecalho
   if mv_par07 == 1
      @ nLin,000 PSAY cCC + " " + SI3->I3_DESC
      nLin := nLin + 2
   endif
endif

@ nLin, 000 pSay "Total Geral"
@ nLin, 040 pSAy nTotdacao   Picture "@E 999,999,999.99"
@ nLin, 094 pSay nTotorig    Picture "@E 999,999,999.99"
@ nLin, 107 pSay nTotcorr    Picture "@E 999,999,999.99"
@ nLin, 120 pSay nTotcorr99  Picture "@E 999,999,999.99"
@ nLin, 133 pSay nTotcorr00  Picture "@E 999,999,999.99"
@ nLin, 151 pSay nTotjuros   Picture "@E 9,999,999.99"
@ nLin, 162 pSay nTotdesc    Picture "@E 9,999,999.99"
@ nLin, 182 pSay nTotvlrec   Picture "@E 999,999,999.99"

nLin := nLin + 2

@ nLin  ,034 pSay "Receita.................: "+Transform( (nTBaseCalc+nTDistrato),"@E 999,999,999.99" ) + " Receita nao Tributada.: "+Transform( nTotnTrib, "@E 999,999,999.99" )
@ nLin+1,034 pSay "Distratos...............: "+Transform( nTDistrato,"@E 999,999,999.99" )
@ nLin+2,034 pSay "Base de Calculo.........: "+Transform( nTBaseCalc,"@E 999,999,999.99" )+" Receita Financeira.: "+Transform( nTotJuros, "@E 999,999,999.99" )+;
  " Venda Ativo Imob.: "+Transform( nAtivoImob,"@E 999,999,999.99" )+" Descontos Obtidos.: "+Transform( nDesconObt,"@E 999,999,999.99" )
@ nLin+3,034 pSay "Valor Total do Cofins...: "+Transform( nTCofins,  "@E 999,999,999.99" )
@ nLin+4,034 pSay "Valor Total I.R.P.J.....: "+Transform( nTIrpj,    "@E 999,999,999.99" )
@ nLin+5,034 pSay "Valor Total C.S.L.L.....: "+Transform( nTCsll,    "@E 999,999,999.99" )
@ nLin+6,034 pSay "Valor Total PIS Repique.: "+Transform( nTPisRep,  "@E 999,999,999.99" )
@ nLin+7,034 pSay "Valor Total PIS Deducao.: "+Transform( nTPisDed,  "@E 999,999,999.99" )

nCcTotorig := nCcTotcorr := nCc99Totcor:= nCc00Totcor:= nCcTotjuros:= nCcTotdesc := nCcTotvlrec:= nCcTotdacao := 0
nLin := 60
For x := 1 to Len( aCC )

    if nLin > 56
       nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) + 2 //Impressao do cabecalho
    endif

    SI3->( dbSeek( xFilial( "SI3" ) + aCC[ x, 1 ], .t. ) )

    @ nLin, 000 pSay aCC[ X, 1 ]
    @ nLin, 010 pSay SI3->I3_DESC
    @ nLin, 040 pSay aCC[ X, 9 ] Picture "@E 999,999,999.99"
    @ nLin, 094 pSay aCC[ X, 2 ] Picture "@E 999,999,999.99"
    @ nLin, 107 pSay aCC[ X, 3 ] Picture "@E 999,999,999.99"
    @ nLin, 120 pSay aCC[ X, 4 ] Picture "@E 999,999,999.99"
    @ nLin, 133 pSay aCC[ X, 5 ] Picture "@E 999,999,999.99"
    @ nLin, 152 pSay aCC[ X, 6 ] Picture "@E 999,999.99"
    @ nLin, 163 pSay aCC[ X, 7 ] Picture "@E 999,999.99"
    @ nLin, 182 pSay aCC[ X, 8 ] Picture "@E 999,999,999.99"

    nLin       := nLin       + 1
    nCcTotdacao:= nCcTotdacao+ aCC[ x, 9 ]
    nCcTotorig := nCcTotorig + aCC[ x, 2 ]
    nCcTotcorr := nCcTotcorr + aCC[ x, 3 ]
    nCc99Totcor:= nCc99Totcor+ aCC[ x, 4 ]
    nCc00Totcor:= nCc00Totcor+ aCC[ x, 5 ]
    nCcTotjuros:= nCcTotjuros+ aCC[ x, 6 ]
    nCcTotdesc := nCcTotdesc + aCC[ x, 7 ]
    nCcTotvlrec:= nCcTotvlrec+ aCC[ x, 8 ]

Next

nLin := nLin + 1
if nLin > 56
   nLin := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) + 2 //Impressao do cabecalho
endif

@ nLin, 000 pSay "Total Geral"
@ nLin, 040 pSay nCcTotdacao Picture "@E 999,999,999.99"
@ nLin, 094 pSay nCcTotorig  Picture "@E 999,999,999.99"
@ nLin, 107 pSay nCcTotcorr  Picture "@E 999,999,999.99"
@ nLin, 120 pSay nCc99Totcor Picture "@E 999,999,999.99"
@ nLin, 133 pSay nCc00Totcor Picture "@E 999,999,999.99"
@ nLin, 152 pSay nCcTotjuros Picture "@E 999,999.99"
@ nLin, 163 pSay nCcTotdesc  Picture "@E 999,999.99"
@ nLin, 182 pSay nCcTotvlrec Picture "@E 999,999,999.99"

Roda(0,"","G")
If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

if mv_par14 == 2
   RodaProva( nHdlPrv, nTotal )
   cA100incl( cArquivo, nHdlPrv,3,cLoteR01,lLanc,.f.)
endif

TMP->( dbClosearea() )
Retindex( "SE1" )
RetIndex( "SE5" )
Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Baixa_per   ³ Autor ³ Silvano Araujo     ³ Data ³ 11.10.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna uma matriz com os valores pagos ou recebidos de um ³±±
±±³          ³ t¡tulo por periodo de baixa.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ aMatriz := Baixa_per()                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Espec¡fico para os relat¢rios FinR340 e FinR350.           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Baixa_per
Static Function Baixa_per()

if cCarteira == "R"
   cFornec  := SE1->E1_CLIENTE
   cLoja    := SE1->E1_LOJA
   nMoeda   := SE1->E1_MOEDA
   cNatureza:= SE1->E1_NATUREZ
   cPrefixo := SE1->E1_PREFIXO
   cNumero  := SE1->E1_NUM
   cParcela := SE1->E1_PARCELA
   cTipo    := SE1->E1_TIPO
else
   cFornec  := SE2->E2_FORNECE
   cLoja    := SE2->E2_LOJA
   nMoeda   := SE2->E2_MOEDA
   cNatureza:= SE2->E2_NATUREZ
   cPrefixo := SE2->E2_PREFIXO
   cNumero  := SE2->E2_NUM
   cParcela := SE2->E2_PARCELA
   cTipo    := SE2->E2_TIPO
endif

SE5->( dbSetOrder(4) )
SE5->( dbSeek( xFilial( "SE5" )+cNatureza+cPrefixo+cNumero+cParcela+cTipo,.T.) )

nMoedaTit := Iif( cCarteira == "R", SE1-> E1_MOEDA , SE2 -> E2_MOEDA )

While SE1->E1_FILIAL+SE1->E1_NATUREZ+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==SE5->E5_FILIAL+SE5->E5_NATUREZA+;
   SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO

   if SE5->E5_SITUACA == "C" .or. SE5->E5_RECPAG != cCarteira .or. ;
      SE5->E5_TIPODOC = "ES"
      SE5->( dbSkip() )
      Loop
   elseif SE5->E5_CLIFOR+SE5->E5_LOJA #cFornec + cLoja
      SE5->( dbSkip() )
      Loop
   elseif TemBxCanc()
      SE5->( DbSkip() )
      Loop
   elseif SE5->E5_MOTBX == "DAC"
      aValor[ 10 ] := aValor[ 10 ] + Iif(nMoeda==1,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
   elseif SE5->E5_DATA < mv_par05  .or. SE5->E5_DATA > mv_par06
      nBparcial  := nBparcial + 1
      if SE5->E5_TIPODOC $ "VLüBA/V2" .and. SE5->E5_DATA < mv_par05

         // Calculando a correcao contratual
         IF Upper( Substr( SE1->E1_NTIT, 5, 1 ) ) #"S" .or. SEZ->EZ_NUM == SE1->E1_NUM .or. ( SEZ->EZ_CLIENTE == SE1->E1_CLIENTE .and. ( SE1->E1_PREFIXO $ "MEN MEX INT YNT" .or. SE1->E1_PREFIMO $ "MEN MEX INT YNT" ) )

            SEX->( dbSetOrder( 1 ) )
            SEX->( dbSeek( xFilial( "SEX" ) + SEZ->EZ_INDICE + Dtos( SE5->E5_DATA ),.T. ) )

            if SE5->E5_DATA < SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "MEN MEX" .or. SE1->E1_PREFIXO $ "MEN MEX" )
               nJurIndx := Round( SEZ->EZ_PCORANT / 30 * ( SE5->E5_DATA - dEmis ), 6 )
            elseif SE5->E5_DATA < SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "INT YNT"  .or. SE1->E1_PREFIXO $ "INT YNT" )
               nJurIndx := Round( SEZ->EZ_CMINTAN / 30 * ( SE5->E5_DATA - dEmis ), 6 )
            elseif SE5->E5_DATA >= SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "MEN MEX" .or. SE1->E1_PREFIXO $ "MEN MEX" )
               if SE5->E5_DATA >= dEmis
                  nJurIndx := Round( SEZ->EZ_PCORANT / 30 * ( SEZ->EZ_DATENT - dEmis ), 6 )
               else
                  nJurIndx := 0
               endif
               nJurIndx := Round( SEZ->EZ_PCORPOS / 30 * ( SE5->E5_DATA - SEZ->EZ_DATENT ), 6 ) + nJurIndx
            elseif SE5->E5_DATA >= SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "INT YNT" .or. SE1->E1_PREFIXO $ "INT YNT" )
               if SE5->E5_DATA >= dEmis
                  nJurIndx := Round( SEZ->EZ_CMINTAN / 30 * ( SEZ->EZ_DATENT - dEmis ), 6 )
               else
                  nJurIndx := 0
               endif
               nJurIndx := Round( SEZ->EZ_CMINTDP / 30 * ( SE5->E5_DATA - SEZ->EZ_DATENT), 6 ) + nJurIndx
            else
               nJurIndx := 0
            endif
            dEmis := SE5->E5_DATA

            nValIndx  := nValIndx + Round(( nSalIndx * nJurIndx / 100 ), 6 )
            nSalIndx  := nSalIndx + Round(( nSalIndx * nJurIndx / 100 ), 6 )  // Calculo Variacao monetaria
            nValor    := Round( nSalIndx * SEX->EX_VALOR, 2 )           // Saldo Atual em Reais
            nValAtu   := nValAtu  + ( nValor - nValorAnt )              // Calculo do valor em reais
            nValBaix  := Round( ( SE5->E5_VALOR + aValor[ 2 ] - aValor[ 3 ] - aValor[ 4 ] ) / SEX->EX_VALOR, 6 )      // Calculo do valor baixado em indice
            nSalIndx  := nSalIndx - nValBaix                            // Calculo do novo saldo em indice
            nValorAnt := Round( nSalIndx * SEX->EX_VALOR, 2 )         // Novo saldo anterior em reais para o calculo do valor atual na proxima baixa
         else
            nValAtu   := nValAtu  + SE5->E5_VALOR + aValor[ 2 ] - aValor[ 3 ] - aValor[ 4 ]
         endif
      endif
      SE5->( dbSkip() )
      Loop
   elseif SE5->E5_TIPODOC $ "VLüBA/V2" .and. SE5->E5_DATA >= mv_par05 .and. SE5->E5_DATA <= mv_par06
      nBparcial  := nBparcial + 1
      // Calculando a correcao contratual
      if Upper( Substr( SE1->E1_NTIT, 5, 1 ) ) #"S" .and.;
         SEZ->EZ_NUM == SE1->E1_NUM

         SEX->( dbSetOrder( 1 ) )
         SEX->( dbSeek( xFilial( "SEX" ) + SEZ->EZ_INDICE + Dtos( SE5->E5_DATA ),.T. ) )

         if SE5->E5_DATA < SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "MEN MEX" .or. SE1->E1_PREFIXO $ "MEN MEX" )
            nJurIndx := Round( SEZ->EZ_PCORANT / 30 * ( SE5->E5_DATA - dEmis ), 6 )
         elseif SE5->E5_DATA < SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "INT YNT"  .or. SE1->E1_PREFIXO $ "MEN MEX" )
            nJurIndx := Round( SEZ->EZ_CMINTAN / 30 * ( SE5->E5_DATA - dEmis ), 6 )
         elseif SE5->E5_DATA >= SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "MEN MEX" .or. SE1->E1_PREFIXO $ "MEN MEX" )
            if SE5->E5_DATA >= dEmis
               nJurIndx := Round( SEZ->EZ_PCORANT / 30 * ( SEZ->EZ_DATENT - dEmis ), 6 )
            else
               nJurIndx := 0
            endif
            nJurIndx := Round( SEZ->EZ_PCORPOS / 30 * ( SE5->E5_DATA - SEZ->EZ_DATENT ), 6 ) + nJurIndx
         elseif SE5->E5_DATA >= SEZ->EZ_DATENT .and. ( SE1->E1_PREFIMO $ "INT YNT" .or. SE1->E1_PREFIXO $ "MEN MEX" )
            if SE5->E5_DATA >= dEmis
               nJurIndx := Round( SEZ->EZ_CMINTAN / 30 * ( SEZ->EZ_DATENT - dEmis ), 6 )
            else
               nJurIndx := 0
            endif
            nJurIndx := Round( SEZ->EZ_CMINTDP / 30 * ( SE5->E5_DATA - SEZ->EZ_DATENT), 6 ) + nJurIndx
         else
            nJurIndx := 0
         endif
         dEmis := SE5->E5_DATA

         nValIndx  := nValIndx + Round(( nSalIndx * nJurIndx / 100 ), 6 )
         nSalIndx  := nSalIndx + Round(( nSalIndx * nJurIndx / 100 ), 6 )  // Calculo Variacao monetaria
         nValor    := Round( nSalIndx * SEX->EX_VALOR, 2 )           // Saldo Atual em Reais
         nValAtu   := nValAtu  + ( nValor - nValorAnt )              // Calculo do valor em reais
         nValBaix  := Round( ( SE5->E5_VALOR + aValor[ 2 ] - aValor[ 3 ] - aValor[ 4 ] ) / SEX->EX_VALOR, 6 )      // Calculo do valor baixado em indice
         nSalIndx  := nSalIndx - nValBaix                            // Calculo do novo saldo em indice
         nValorAnt := Round( nSalIndx * SEX->EX_VALOR, 2 )         // Novo saldo em reais para o calculo do valor atual na proxima baixa
      else
         nValAtu   := nValAtu  + SE5->E5_VALOR + aValor[ 2 ] - aValor[ 3 ] - aValor[ 4 ]
      endif
      aValor[ 5 ] := aValor[ 5 ] + Iif(nMoeda==1,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
      aValor[ 6 ] := aValor[ 6 ] + Iif(nMoeda==1,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
   elseif SE5->E5_TIPODOC $ "DC/D2"
      aValor[ 2 ] := aValor[ 2 ] + Iif(nMoeda==1,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
      aValor[ 6 ] := aValor[ 6 ] + Iif(nMoeda==1,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
   elseif SE5->E5_TIPODOC $ "JR/J2"
      aValor[ 3 ] := aValor[ 3 ] + Iif(nMoeda==1,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
      aValor[ 6 ] := aValor[ 6 ] - Iif(nMoeda==1,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
   elseif SE5->E5_TIPODOC $ "MT/M2"
      aValor[ 4 ] := aValor[ 4 ] + Iif(nMoeda==1,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
      aValor[ 6 ] := aValor[ 6 ] - Iif(nMoeda==1,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
   elseif SE5->E5_TIPODOC $ "CM/C2/CX"
      aValor[ 1 ] := aValor[ 1 ] + Iif(nMoeda==1,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,SE5->E5_DATA))
   elseif SE5->E5_TIPODOC $ "RA /" // +MV_CRNEG
      aValor[ 7 ] := aValor[ 7 ] + Iif(nMoeda==1,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA))
   elseif SE5->E5_TIPODOC == "PA"  // .or. SE5->E5_TIPODOC $ MV_CPNEG
      aValor[ 8 ] := aValor[ 8 ] + Iif(nMoeda==1,SE5->E5_VALOR,xMoeda(SE5->E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA))
   endif

   aValor[ 9 ] := SE5->E5_MOTBX
   dBaixa      := SE5->E5_DATA

   SE5->( dbSkip() )
End
Return nil


// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==> Function Baix_perx
Static Function Baix_perx()
if cCarteira == "R"
   cFornec  := XE1->E1_CLIENTE
   cLoja    := XE1->E1_LOJA
   nMoeda   := XE1->E1_MOEDA
   cNatureza:= XE1->E1_NATUREZ
   cPrefixo := XE1->E1_PREFIXO
   cNumero  := XE1->E1_NUM
   cParcela := XE1->E1_PARCELA
   cTipo    := XE1->E1_TIPO
else
   cFornec  := XE2->E2_FORNECE
   cLoja    := XE2->E2_LOJA
   nMoeda   := XE2->E2_MOEDA
   cNatureza:= XE2->E2_NATUREZ
   cPrefixo := XE2->E2_PREFIXO
   cNumero  := XE2->E2_NUM
   cParcela := XE2->E2_PARCELA
   cTipo    := XE2->E2_TIPO
endif

XE5->( dbSetOrder(4) )
XE5->( dbSeek( "01"+cNatureza+cPrefixo+cNumero+cParcela+cTipo,.T.) )

nMoedaTit := Iif( cCarteira == "R", XE1-> E1_MOEDA , XE2 -> E2_MOEDA )
While XE1->E1_FILIAL+XE1->E1_NATUREZ+XE1->E1_PREFIXO+XE1->E1_NUM+XE1->E1_PARCELA+XE1->E1_TIPO==XE5->E5_FILIAL+XE5->E5_NATUREZ+;
   XE5->E5_PREFIXO+XE5->E5_NUMERO+XE5->E5_PARCELA+XE5->E5_TIPO .and. XE5->( !Eof() )

   if XE5->E5_SITUACA == "C" .or. XE5->E5_RECPAG != cCarteira .or. ;
      XE5->E5_TIPODOC = "ES"
      XE5->( dbSkip() )
      Loop
   elseif XE5->E5_CLIFOR+XE5->E5_LOJA #cFornec + cLoja
      XE5->( dbSkip() )
      Loop
   elseif XE5->E5_DATA < mv_par05  .or. XE5->E5_DATA > mv_par06
      nBparcial  := nBparcial + 1
      if XE5->E5_TIPODOC $ "VL/BA/V2" .and. XE5->E5_DATA < mv_par05

         // Calculando a correcao contratual
         IF Upper( Substr( XE1->E1_NTIT, 5, 1 ) ) #"S" .or. XEZ->EZ_NUM == XE1->E1_NUM .or. ( XEZ->EZ_CLIENTE == XE1->E1_CLIENTE .and. ( XE1->E1_PREFIXO $ "MEN MEX INT YNT" .or. XE1->E1_PREFIMO $ "MEN MEX INT YNT" ) )

            SEX->( dbSetOrder( 1 ) )
            SEX->( dbSeek( xFilial( "SEX" ) + XEZ->EZ_INDICE + Dtos( XE5->E5_DATA ),.T. ) )

            if XE5->E5_DATA < XEZ->EZ_DATENT .and. ( XE1->E1_PREFIMO $ "MEN MEX" .or. XE1->E1_PREFIXO $ "MEN MEX" )
               nJurIndx := Round( XEZ->EZ_PCORANT / 30 * ( XE5->E5_DATA - dEmis ), 6 )
            elseif XE5->E5_DATA < XEZ->EZ_DATENT .and. ( XE1->E1_PREFIMO $ "INT YNT"  .or. XE1->E1_PREFIXO $ "INT YNT" )
               nJurIndx := Round( XEZ->EZ_CMINTAN / 30 * ( XE5->E5_DATA - dEmis ), 6 )
            elseif XE5->E5_DATA >= XEZ->EZ_DATENT .and. ( XE1->E1_PREFIMO $ "MEN MEX" .or. XE1->E1_PREFIXO $ "MEN MEX" )
               if XE5->E5_DATA >= dEmis
                  nJurIndx := Round( XEZ->EZ_PCORANT / 30 * ( XEZ->EZ_DATENT - dEmis ), 6 )
               else
                  nJurIndx := 0
               endif
               nJurIndx := Round( XEZ->EZ_PCORPOS / 30 * ( XE5->E5_DATA - XEZ->EZ_DATENT ), 6 ) + nJurIndx
            elseif XE5->E5_DATA >= XEZ->EZ_DATENT .and. ( XE1->E1_PREFIMO $ "INT YNT" .or. XE1->E1_PREFIXO $ "INT YNT" )
               if XE5->E5_DATA >= dEmis
                  nJurIndx := Round( XEZ->EZ_CMINTAN / 30 * ( XEZ->EZ_DATENT - dEmis ), 6 )
               else
                  nJurIndx := 0
               endif
               nJurIndx := Round( XEZ->EZ_CMINTDP / 30 * ( XE5->E5_DATA - XEZ->EZ_DATENT), 6 ) + nJurIndx
            else
               nJurIndx := 0
            endif
            dEmis := XE5->E5_DATA

            nValIndx  := nValIndx + Round(( nSalIndx * nJurIndx / 100 ), 6 )
            nSalIndx  := nSalIndx + Round(( nSalIndx * nJurIndx / 100 ), 6 )  // Calculo Variacao monetaria
            nValor    := Round( nSalIndx * SEX->EX_VALOR, 2 )           // Saldo Atual em Reais
            nValAtu   := nValAtu  + ( nValor - nValorAnt )              // Calculo do valor em reais
            nValBaix  := Round( ( XE5->E5_VALOR + aValor[ 2 ] - aValor[ 3 ] - aValor[ 4 ] ) / SEX->EX_VALOR, 6 )      // Calculo do valor baixado em indice
            nSalIndx  := nSalIndx - nValBaix                            // Calculo do novo saldo em indice
            nValorAnt := Round( nSalIndx * SEX->EX_VALOR, 2 )         // Novo saldo anterior em reais para o calculo do valor atual na proxima baixa
         else
            nValAtu   := nValAtu  + XE5->E5_VALOR + aValor[ 2 ] - aValor[ 3 ] - aValor[ 4 ]
         endif
      endif
      XE5->( dbSkip() )
      Loop
   elseif TemBxCanc()
      XE5->( DbSkip() )
      Loop
   elseif SE5->E5_MOTBX == "DAC"
      aValor[ 10 ] := aValor[ 10 ] + Iif(nMoeda==1,XE5->E5_VALOR,xMoeda(XE5->E5_VLMOED2,nMoedaTit,nMoeda,XE5->E5_DATA))
   elseif XE5->E5_TIPODOC $ "VL/BA/V2" .and. XE5->E5_DATA >= mv_par05 .and. XE5->E5_DATA <= mv_par06
      nBparcial  := nBparcial + 1
      // Calculando a correcao contratual
      if Upper( Substr( XE1->E1_NTIT, 5, 1 ) ) #"S" .and.;
         XEZ->EZ_NUM == XE1->E1_NUM

         SEX->( dbSetOrder( 1 ) )
         SEX->( dbSeek( xFilial( "SEX" ) + XEZ->EZ_INDICE + Dtos( XE5->E5_DATA ),.T. ) )

         if XE5->E5_DATA < XEZ->EZ_DATENT .and. ( XE1->E1_PREFIMO $ "MEN MEX RES" .or. XE1->E1_PREFIXO $ "MEN MEX RES" )
            nJurIndx := Round( XEZ->EZ_PCORANT / 30 * ( XE5->E5_DATA - dEmis ), 6 )
         elseif XE5->E5_DATA < XEZ->EZ_DATENT .and. ( XE1->E1_PREFIMO $ "INT YNT"  .or. XE1->E1_PREFIXO $ "INT YNT" )
            nJurIndx := Round( XEZ->EZ_CMINTAN / 30 * ( XE5->E5_DATA - dEmis ), 6 )
         elseif XE5->E5_DATA >= XEZ->EZ_DATENT .and. ( XE1->E1_PREFIMO $ "MEN MEX" .or. XE1->E1_PREFIXO $ "MEN MEX" )
            if XE5->E5_DATA >= dEmis
               nJurIndx := Round( XEZ->EZ_PCORANT / 30 * ( XEZ->EZ_DATENT - dEmis ), 6 )
            else
               nJurIndx := 0
            endif
            nJurIndx := Round( XEZ->EZ_PCORPOS / 30 * ( XE5->E5_DATA - XEZ->EZ_DATENT ), 6 ) + nJurIndx
         elseif XE5->E5_DATA >= XEZ->EZ_DATENT .and. ( XE1->E1_PREFIMO $ "INT YNT" .or. XE1->E1_PREFIXO $ "INT YNT" )
            if XE5->E5_DATA >= dEmis
               nJurIndx := Round( XEZ->EZ_CMINTAN / 30 * ( XEZ->EZ_DATENT - dEmis ), 6 )
            else
               nJurIndx := 0
            endif
            nJurIndx := Round( XEZ->EZ_CMINTDP / 30 * ( XE5->E5_DATA - XEZ->EZ_DATENT), 6 ) + nJurIndx
         else
            nJurIndx := 0
         endif
         dEmis := XE5->E5_DATA

         nValIndx  := nValIndx + Round(( nSalIndx * nJurIndx / 100 ), 6 )
         nSalIndx  := nSalIndx + Round(( nSalIndx * nJurIndx / 100 ), 6 )  // Calculo Variacao monetaria
         nValor    := Round( nSalIndx * SEX->EX_VALOR, 2 )           // Saldo Atual em Reais
         nValAtu   := nValAtu  + ( nValor - nValorAnt )              // Calculo do valor em reais
         nValBaix  := Round( ( XE5->E5_VALOR + aValor[ 2 ] - aValor[ 3 ] - aValor[ 4 ] ) / SEX->EX_VALOR, 6 )      // Calculo do valor baixado em indice
         nSalIndx  := nSalIndx - nValBaix                            // Calculo do novo saldo em indice
         nValorAnt := Round( nSalIndx * SEX->EX_VALOR, 2 )         // Novo saldo em reais para o calculo do valor atual na proxima baixa
      else
         nValAtu   := nValAtu  + XE5->E5_VALOR + aValor[ 2 ] - aValor[ 3 ] - aValor[ 4 ]
      endif
      aValor[ 5 ] := aValor[ 5 ] + Iif(nMoeda==1,XE5->E5_VALOR,xMoeda(XE5->E5_VLMOED2,nMoedaTit,nMoeda,XE5->E5_DATA))
      aValor[ 6 ] := aValor[ 6 ] + Iif(nMoeda==1,XE5->E5_VALOR,xMoeda(XE5->E5_VLMOED2,nMoedaTit,nMoeda,XE5->E5_DATA))
   elseif XE5->E5_TIPODOC $ "DC/D2"
      aValor[ 2 ] := aValor[ 2 ] + Iif(nMoeda==1,XE5->E5_VALOR,xMoeda(XE5->E5_VLMOED2,nMoedaTit,nMoeda,XE5->E5_DATA))
      aValor[ 6 ] := aValor[ 6 ] + Iif(nMoeda==1,XE5->E5_VALOR,xMoeda(XE5->E5_VLMOED2,nMoedaTit,nMoeda,XE5->E5_DATA))
   elseif XE5->E5_TIPODOC $ "JR/J2"
      aValor[ 3 ] := aValor[ 3 ] + Iif(nMoeda==1,XE5->E5_VALOR,xMoeda(XE5->E5_VLMOED2,nMoedaTit,nMoeda,XE5->E5_DATA))
      aValor[ 6 ] := aValor[ 6 ] - Iif(nMoeda==1,XE5->E5_VALOR,xMoeda(XE5->E5_VLMOED2,nMoedaTit,nMoeda,XE5->E5_DATA))
   elseif XE5->E5_TIPODOC $ "MT/M2"
      aValor[ 4 ] := aValor[ 4 ] + Iif(nMoeda==1,XE5->E5_VALOR,xMoeda(XE5->E5_VLMOED2,nMoedaTit,nMoeda,XE5->E5_DATA))
      aValor[ 6 ] := aValor[ 6 ] - Iif(nMoeda==1,XE5->E5_VALOR,xMoeda(XE5->E5_VLMOED2,nMoedaTit,nMoeda,XE5->E5_DATA))
   elseif XE5->E5_TIPODOC $ "CM/C2/CX"
      aValor[ 1 ] := aValor[ 1 ] + Iif(nMoeda==1,XE5->E5_VALOR,xMoeda(XE5->E5_VLMOED2,nMoedaTit,nMoeda,XE5->E5_DATA))
   elseif XE5->E5_TIPODOC $ "RA /" // +MV_CRNEG
      aValor[ 7 ] := aValor[ 7 ] + Iif(nMoeda==1,XE5->E5_VALOR,xMoeda(XE5->E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA))
   elseif XE5->E5_TIPODOC == "PA"  // .or. XE5->E5_TIPODOC $ MV_CPNEG
      aValor[ 8 ] := aValor[ 8 ] + Iif(nMoeda==1,XE5->E5_VALOR,xMoeda(XE5->E5_VLMOED2,nMoedaTit,nMoeda,E5_DATA))
   endif

   aValor[ 9 ] := XE5->E5_MOTBX
   dBaixa      := XE5->E5_DATA

   XE5->( dbSkip() )
End
Return nil
