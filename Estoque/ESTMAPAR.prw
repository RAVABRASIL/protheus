#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTMAPAR  º Autor ³ AP6 IDE            º Data ³  05/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*************

User Function ESTMAPAR()

*************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Análise do motivo de apara"
Local cPict          := ""
Local titulo         := "Análise do motivo de apara"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "ESTMAPAR" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "ESTMAPAR" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""

Pergunte("ESTMAP", .F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"ESTMAP",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec1 := padr("Movimento de aparas de "+ dtoc(mv_par01) +" ate "+ dtoc(mv_par02),220)
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  05/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

***************

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

***************

Local nRes := nOrdemn := nCol := nCol2 := nLin := x := y := nInd := nProuc := 0
Local aArrCt  := {}                                                                                                                                 //LIMITE
Local aArrEx  := {}
Local aTmp    := {}
Local aProdEx := {}
Local cQuery  := cNome   := cMaqi := ''
Local nTTCS1 := nTTCS2 := nTTCS3 := nTTCS4 := nTTCS5 := nTTCS6 := nTTCS7 := nTTCS8 := nTTCS9 := nTTCS10 := nTTCS11 := nTTCS12 := 0
Local aCores:={}
Local cnt:=0
Local nPercent:=0
//                012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220       230
local cCabec1 := "  MAQUINA   |           APARA TOTAL          |                                                                        MOTIVOS DAS APARAS                                                                         |"
local cCabec2 := "            |                                |         Amostra/Teste          |        Rev. de Material        |       Defeito de Bobina        |             Processo           |            Impressao          |"
local cCabec3 := "            |   Apara Kg      |    Apara %   |   Apara Kg      |    Apara %   |    Apara Kg     |    Apara %   |    Apara Kg     |    Apara %   |    Apara Kg     |    Apara %   |    Apara Kg     |   Apara %   |"
//                               999.999,99    999,99    999.999,99     999,99    999.999,99     999,99     999.999,99    999,99    999.999,99     999,99    999.999,99    999,99
Local cCabec4 := "      EXTRUSOR      | MAQ. |  PRODUCAO  |      APARA TOTAL       |                                                 MOTIVOS DAS APARAS                                                         |"
Local cCabec5 := "                    |      |            |                        |         Teste          |         Setup          |     Furo de Balao      |     Troca de tela      |     Queda de Energia   |"
Local cCabec6 := "                    |      |            | Apara Kg    |  Apara % | Apara Kg    |  Apara % |  Apara Kg   |  Apara % |  Apara Kg   |  Apara % |  Apara Kg   |  Apara % |  Apara Kg   | Apara %  |"
//                 ABCDEFGHIJKLMNOPQR   XXX    999.999,99  999.999,99      999,99    999.999,99     999,99    999.999,99     999,99     999.999,99    999,99    999.999,99     999,99    999.999,99    999,99
SetRegua(0)
cQuery += "select Z00_MAQ,Z00_MAPAR, Z00_NOME, sum(Z00_PESO) TOTAL "
cQuery += "from   " + retSqlName('Z00') + " "
cQuery += "where  Z00_FILIAL = ' " +xFilial('Z00') + " ' and Z00_APARA != '' and Z00_MAQ != 'S01' "//as sacoleiras possuem um processo natural de aparas
cQuery += "and Z00_DATA between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' and substring(Z00_MAQ,1,2) = 'E0' "
cQuery += "and D_E_L_E_T_ != '*' "
cQuery += "group by Z00_NOME, Z00_MAQ, Z00_MAPAR "
TCQUERY cQuery NEW ALIAS 'TMP' 	
TMP->( dbGoTop() )
cQuery := "select Z00_MAQ,Z00_MAPAR, sum(Z00_PESO) TOTAL "
cQuery += "from   " + retSqlName('Z00') + " "
cQuery += "where  Z00_FILIAL = ' " +xFilial('Z00') + " ' and Z00_APARA != '' and D_E_L_E_T_ != '*' and Z00_MAQ != 'S01' "//as sacoleiras possuem um processo natural de aparas
cQuery += "       and Z00_DATA between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' and substring(Z00_MAQ,1,2) in( 'C0','P0')  "
cQuery += "group by Z00_MAQ, Z00_MAPAR "
cQuery += "order by Z00_MAQ "
TCQUERY cQuery NEW ALIAS 'TMPX'
TMPX->( dbGoTop() )

cNome := TMP->Z00_NOME
cMaqi := TMP->Z00_MAQ
 do While ! TMP->( EoF() )
     do While ( cNome + cMaqi == TMP->Z00_NOME + TMP->Z00_MAQ ) .and. ! TMP->( EoF() )
      aAdd( aTmp, { TMP->TOTAL, TMP->Z00_MAPAR } )
      TMP->( dbSkip() )
     endDo
  aAdd(aArrEx, { cNome, cMaqi, aTmp } )
  cNome := TMP->Z00_NOME
  cMaqi := TMP->Z00_MAQ
  aTmp := {} 
endDo    
TMP->( dbCloseArea() )
cMaqi := TMPX->Z00_MAQ
do While ! TMPX->( EoF() )
  do While  ( cMaqi == TMPX->Z00_MAQ ) .and. ! TMPX->( EoF() )
    aAdd( aTmp, { TMPX->TOTAL, TMPX->Z00_MAPAR } )
    TMPX->( dbSkip() )
  endDo
  aAdd(aArrCt, { cMaqi, aTmp } )
  cMaqi := TMPX->Z00_MAQ
  aTmp := {}
endDo
TMPX->( dbCloseArea() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua( len( aArrEx ) + len( aArrCt ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
@008,000 PSAY cCabec4
@009,000 PSAY cCabec5
@010,000 PSAY cCabec6
@011,000 PSAY repl('-',190)
nLin := 12
aProdEx := producao()
For x := 1 to len( aArrEx ) //While !EOF()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     @008,000 PSAY cCabec4
     @009,000 PSAY cCabec5
     @010,000 PSAY cCabec6
     @011,000 PSAY repl('-',170)
     nLin := 12
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
//cal cCabec4 := "      EXTRUSOR      | MAQ. |  PRODUCAO  |      APARA TOTAL       |                                                 MOTIVOS DAS APARAS                                                        |"
//cal cCabec5 := "                    |      |            |                        |         Teste          |         Setup          |     Furo de Balao      |     Troca de tela      |       Processo        |"
//cal cCabec6 := "                    |      |            | Apara Kg    |  Apara % | Apara Kg    |  Apara % |  Apara Kg   |  Apara % |  Apara Kg   |  Apara % |  Apara Kg   |  Apara % |  Apara Kg   | Apara % |"
//                 ABCDEFGHIJKLMNOPQR   XXX    999.999,99  999.999,99      999,99    999.999,99     999,99    999.999,99     999,99     999.999,99    999,99    999.999,99     999,99    999.999,99    999,99
//                012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220       230
  nInd  := meuScan( aProdEx, alltrim(aArrEx[x][1]),  alltrim(aArrEx[x][2]) )
  if nInd != 0
    nProd := aProdEx[nInd][3]
    nInd  := 0
  else
    nProd := 0
    nInd  := 0
  endIf
  @nLin,001 PSAY substr( alltrim( aArrEx[x][1] ), 1, 17 ) //nome
  @nLin,022 PSAY aArrEx[x][2]//maq
  @nLin,029 PSAY transform( nProd, "@E 999,999.99" )//producao
  aEval( aArrEx[x][3], { |zyk| nRes += zyk[1] } )
  nTTCS1 += nRes
  @nLin,041 PSAY transform(nRes,"@E 999,999.99")//apara total +13 a partir daqui
  nPercent:=(nRes/nProd)*100
  @nLin,054 PSAY transform( iif(nProd > 0, nPercent, 0 ),"@E 999,999.99")//apara total +13 a partir daqui
  for y := 1 to len(aArrEx[x][3])
    if aArrEx[x][3][y][2] == 'EX02'
      nCol  := 066//14
      nCol2 := 081
      nTTCS2 += aArrEx[x][3][y][1]
    elseIf aArrEx[x][3][y][2] == 'EX03'
      nCol  := 091
      nCol2 := 105
      nTTCS3 += aArrEx[x][3][y][1]
    elseIf aArrEx[x][3][y][2] == 'EX04'
      nCol  := 117
      nCol2 := 133
      nTTCS4 += aArrEx[x][3][y][1]
    elseIf aArrEx[x][3][y][2] == 'EX05'
      nCol  := 142
      nCol2 := 157
      nTTCS5 += aArrEx[x][3][y][1]
    else
      nCol  := 167
      nCol2 := 182
      nTTCS6 += aArrEx[x][3][y][1]
    endIf
    @nLin,nCol PSAY transform(aArrEx[x][3][y][1],"@E 999,999.99")
    @nLin,nCol2 PSAY transform( (  aArrEx[x][3][y][1] / nRes ) * 100 ,"@E 999.99")
  next
  nLin := nLin + 1 // Avanca a linha de impressao
  nRes := 0
  incRegua()
NEXT//EndDo
@Prow() + 2, 000 Psay "Totais :"
@Prow()    , 041 PSAY transform(nTTCS1,"@E 999,999.99")
@Prow()    , 066 PSAY transform(nTTCS2,"@E 999,999.99")
@Prow()    , 091 PSAY transform(nTTCS3,"@E 999,999.99")
@Prow()    , 117 PSAY transform(nTTCS4,"@E 999,999.99")
@Prow()    , 142 PSAY transform(nTTCS5,"@E 999,999.99")
@Prow()    , 167 PSAY transform(nTTCS6,"@E 999,999.99")

nTTCS1 := nTTCS2 := nTTCS3 := nTTCS4 := nTTCS5 := nTTCS6 := nTTCS7 := nTTCS8 := nTTCS9 := nTTCS10 := nTTCS11 := nTTCS12 := 0

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
@008,000 PSAY cCabec1
@009,000 PSAY cCabec2
@010,000 PSAY cCabec3
@011,000 PSAY repl('-',210)
nLin := 12; nRes := 0
For x := 1 to len( aArrCt ) //While !EOF()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     @008,000 PSAY cCabec1
     @009,000 PSAY cCabec2
     @010,000 PSAY cCabec3
     @011,000 PSAY repl('-',210)
     nLin := 12
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
//                012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220       230
//cal cCabec1 := "  MAQUINA   |           APARA TOTAL          |                                                                        MOTIVOS DAS APARAS                                                                         |"
//cal cCabec2 := "            |                                |         Amostra/Teste          |        Rev. de Material        |       Defeito de Bobina        |            Pocesso             |            Impressao          |"
//cal cCabec3 := "            |   Apara Kg      |    Apara %   |   Apara Kg      |    Apara %   |    Apara Kg     |    Apara %   |    Apara Kg     |    Apara %   |    Apara Kg     |    Apara %   |    Apara Kg     |   Apara %   |"
//                               999.999,99          999,99       999.999,99          999,99        999.999,99         999,99        999.999,99         999,99        999.999,99         999,99        999.999,99        999,99
  nPdtt  := produc_2( aArrCt[x][1] )
  @nLin,001 PSAY alltrim( aArrCt[x][1] ) //nome
  aEval( aArrCt[x][2], { |zyk| nRes += zyk[1] } )
  nTTCS1 += nRes
  @nLin,013 PSAY transform( nRes, "@E 999,999.99" )
  @nLin,035 PSAY transform( ( nRes / nPdtt ) * 100,"@E 999.99")
  for y := 1 to len(aArrCt[x][2])
    if aArrCt[x][2][y][2] == 'CS02'
      nCol   := 048//040
      nCol2  := 068
      nTTCS2 += aArrCt[x][2][y][1]
    elseIf aArrCt[x][2][y][2] == 'CS03'
      nCol   := 081//065
      nCol2  := 101
      nTTCS3 += aArrCt[x][2][y][1]
    elseIf aArrCt[x][2][y][2] == 'CS04'
      nCol   := 115//090
      nCol2  := 135
      nTTCS4 += aArrCt[x][2][y][1]
    elseIf aArrCt[x][2][y][2] == 'CS05'
      nCol   := 148//115
      nCol2  := 168
      nTTCS5 += aArrCt[x][2][y][1]
    else
      nCol   := 182//140
      nCol2  := 200
      nTTCS6 += aArrCt[x][2][y][1]
    endIf
    @nLin,nCol  PSAY transform(aArrCt[x][2][y][1],"@E 999,999.99")
    @nLin,nCol2 PSAY transform( (  aArrCt[x][2][y][1] / nRes ) * 100 ,"@E 999.99")
  next
  nLin := nLin + 1 // Avanca a linha de impressao
  nRes := 0
  incRegua()
NEXT//EndDo
@Prow() + 2, 000 Psay "Totais :"
@Prow()    , 013 PSAY transform(nTTCS1,"@E 999,999.99")
@Prow()    , 048 PSAY transform(nTTCS2,"@E 999,999.99")
@Prow()    , 081 PSAY transform(nTTCS3,"@E 999,999.99")
@Prow()    , 115 PSAY transform(nTTCS4,"@E 999,999.99")
@Prow()    , 148 PSAY transform(nTTCS5,"@E 999,999.99")
@Prow()    , 182 PSAY transform(nTTCS6,"@E 999,999.99")

//
aCores:=Maquina( 'EXT' ) // EXTRUSORA
titulo         := "Movimento de aparas de "+ dtoc(mv_par01) +" ate "+ dtoc(mv_par02)
Cabec1:="Maquina          Azul       Branco        Preto         Vermelho      Amarelo       Verde         Cinza         Laranja       Transparente"
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 
nLin:=08
nTotal:=nTotA:=nTotB:=nTotC:=nTotD:=nTotE:=nTotF:=nTotG:=nTotL:=nTotZ:=0
For _x:=1 to Len(aCores)
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 
     nLin:=08
   Endif


   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
    @nLin++,00 PSAY aCores[_x][1]+space(4)+transform( aCores[_x][2][1][2], "@E 999,999.99" ); 
                               +space(4)+transform( aCores[_x][2][2][2], "@E 999,999.99" );
                               +space(4)+transform( aCores[_x][2][3][2], "@E 999,999.99" );                                                         
                               +space(4)+transform( aCores[_x][2][4][2], "@E 999,999.99" );
                               +space(4)+transform( aCores[_x][2][5][2], "@E 999,999.99" );
                               +space(4)+transform( aCores[_x][2][6][2], "@E 999,999.99" );
                               +space(4)+transform( aCores[_x][2][7][2], "@E 999,999.99" );
                               +space(4)+transform( aCores[_x][2][8][2], "@E 999,999.99" );
                               +space(4)+transform( aCores[_x][2][9][2], "@E 999,999.99" )

    nTotA+=aCores[_x][2][1][2]
    nTotB+=aCores[_x][2][2][2]
    nTotC+=aCores[_x][2][3][2]
    nTotD+=aCores[_x][2][4][2]
    nTotE+=aCores[_x][2][5][2]
    nTotF+=aCores[_x][2][6][2]
    nTotG+=aCores[_x][2][7][2]
    nTotL+=aCores[_x][2][8][2]
    nTotZ+=aCores[_x][2][9][2]
Next
nLin++
@nLin++,00 PSAY  "Total: "+space(03)+transform( nTotA, "@E 999,999.99" ); 
                               +space(4)+transform( nTotB, "@E 999,999.99" );
                               +space(4)+transform( nTotC, "@E 999,999.99" );                                                         
                               +space(4)+transform( nTotD, "@E 999,999.99" );
                               +space(4)+transform( nTotE, "@E 999,999.99" );
                               +space(4)+transform( nTotF, "@E 999,999.99" );
                               +space(4)+transform( nTotG, "@E 999,999.99" );
                               +space(4)+transform( nTotL, "@E 999,999.99" );
                               +space(4)+transform( nTotZ, "@E 999,999.99" )

nTotal:=nTotA+nTotB+nTotC+nTotD+nTotE+nTotF+nTotG+nTotL+nTotZ

@nLin,00 PSAY  "%"+space(09)+transform( (nTotA/nTotal)*100, "@E 999,999.99" ); 
                               +space(4)+transform( (nTotB/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotC/nTotal)*100, "@E 999,999.99" );                                                         
                               +space(4)+transform( (nTotD/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotE/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotF/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotG/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotL/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotZ/nTotal)*100, "@E 999,999.99" )


//
 
//
aCores:=Maquina( '' ) //CORTE E SOLDA E PICOTADEIRA 
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 
nLin:=08
nTotal:=nTotA:=nTotB:=nTotC:=nTotD:=nTotE:=nTotF:=nTotG:=nTotL:=nTotZ:=0
For _x:=1 to Len(aCores)
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) 
     nLin:=08
   Endif


   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
    
    if _x > 1
	   if Left(aCores[_x][1],1) != Left(aCores[_x-1][1],1) 
	    nLin++
        @nLin++,00 PSAY  "Total: "+space(03)+transform( nTotA, "@E 999,999.99" ); 
                               +space(4)+transform( nTotB, "@E 999,999.99" );
                               +space(4)+transform( nTotC, "@E 999,999.99" );                                                         
                               +space(4)+transform( nTotD, "@E 999,999.99" );
                               +space(4)+transform( nTotE, "@E 999,999.99" );
                               +space(4)+transform( nTotF, "@E 999,999.99" );
                               +space(4)+transform( nTotG, "@E 999,999.99" );
                               +space(4)+transform( nTotL, "@E 999,999.99" );
                               +space(4)+transform( nTotZ, "@E 999,999.99" )
        
        nTotal:=nTotA+nTotB+nTotC+nTotD+nTotE+nTotF+nTotG+nTotL+nTotZ
        
        @nLin++,00 PSAY  "%"+space(09)+transform( (nTotA/nTotal)*100, "@E 999,999.99" ); 
                               +space(4)+transform( (nTotB/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotC/nTotal)*100, "@E 999,999.99" );                                                         
                               +space(4)+transform( (nTotD/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotE/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotF/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotG/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotL/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotZ/nTotal)*100, "@E 999,999.99" )

        nLin++
        nTotal:=nTotA:=nTotB:=nTotC:=nTotD:=nTotE:=nTotF:=nTotG:=nTotL:=nTotZ:=0
	   endif
     endif
     
     @nLin++,00 PSAY aCores[_x][1]+space(4)+transform( aCores[_x][2][1][2], "@E 999,999.99" ); 
	                               +space(4)+transform( aCores[_x][2][2][2], "@E 999,999.99" );
	                               +space(4)+transform( aCores[_x][2][3][2], "@E 999,999.99" );                                                         
	                               +space(4)+transform( aCores[_x][2][4][2], "@E 999,999.99" );
	                               +space(4)+transform( aCores[_x][2][5][2], "@E 999,999.99" );
	                               +space(4)+transform( aCores[_x][2][6][2], "@E 999,999.99" );
	                               +space(4)+transform( aCores[_x][2][7][2], "@E 999,999.99" );
	                               +space(4)+transform( aCores[_x][2][8][2], "@E 999,999.99" );
	                               +space(4)+transform( aCores[_x][2][9][2], "@E 999,999.99" )
    
    nTotA+=aCores[_x][2][1][2]
    nTotB+=aCores[_x][2][2][2]
    nTotC+=aCores[_x][2][3][2]
    nTotD+=aCores[_x][2][4][2]
    nTotE+=aCores[_x][2][5][2]
    nTotF+=aCores[_x][2][6][2]
    nTotG+=aCores[_x][2][7][2]
    nTotL+=aCores[_x][2][8][2]
    nTotZ+=aCores[_x][2][9][2]	   

Next
nLin++
@nLin++,00 PSAY  "Total: "+space(03)+transform( nTotA, "@E 999,999.99" ); 
                               +space(4)+transform( nTotB, "@E 999,999.99" );
                               +space(4)+transform( nTotC, "@E 999,999.99" );                                                         
                               +space(4)+transform( nTotD, "@E 999,999.99" );
                               +space(4)+transform( nTotE, "@E 999,999.99" );
                               +space(4)+transform( nTotF, "@E 999,999.99" );
                               +space(4)+transform( nTotG, "@E 999,999.99" );
                               +space(4)+transform( nTotL, "@E 999,999.99" );
                               +space(4)+transform( nTotZ, "@E 999,999.99" )

nTotal:=nTotA+nTotB+nTotC+nTotD+nTotE+nTotF+nTotG+nTotL+nTotZ
        
@nLin++,00 PSAY  "%"+space(09)+transform( (nTotA/nTotal)*100, "@E 999,999.99" ); 
                               +space(4)+transform( (nTotB/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotC/nTotal)*100, "@E 999,999.99" );                                                         
                               +space(4)+transform( (nTotD/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotE/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotF/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotG/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotL/nTotal)*100, "@E 999,999.99" );
                               +space(4)+transform( (nTotZ/nTotal)*100, "@E 999,999.99" )


//

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

***************

Static Function producao()

***************

Local nRet   := 0
Local cQuery := ""
Local aArret := {}
cQuery += "select Z00_MAQ, Z00_NOME, sum(Z00_PESO) TOTAL "
cQuery += "from   " + retSqlName('Z00') + " "
cQuery += "where  Z00_FILIAL = ' " +xFilial('Z00') + " ' and Z00_APARA = '' "
cQuery += "and Z00_DATA between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' and substring(Z00_MAQ,1,2) = 'E0' "
cQuery += "and Z00_CODIGO = '' and D_E_L_E_T_ != '*' "
cQuery += "group by Z00_MAQ, Z00_NOME "
TCQUERY cQuery NEW ALIAS 'TEMP'
TEMP->( dbGoTop() )
do While ! TEMP->( EoF() )
  aAdd( aArret, { TEMP->Z00_MAQ, TEMP->Z00_NOME, TEMP->TOTAL } )
  TEMP->( dbSkip() )
endDo
TEMP->( dbCloseArea() )
return aArret

***************

Static Function produc_2( cMaq )

***************

Local nRet   := 0
Local cQuery := ""
cQuery += "select sum(Z00_PESO) TOTAL "
cQuery += "from   "+retSqlName('Z00')+" "
cQuery += "where  Z00_FILIAL = '" + xFilial('Z00') + "' and Z00_APARA = '' "
cQuery += "and Z00_DATA between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' and Z00_MAQ = '"+cMaq+"' "
cQuery += "and Z00_USUAR != 'TRANSFORMADOR' "
cQuery += "and D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS 'TEMP'
do While ! TEMP->( EoF() )
  nRet := TEMP->TOTAL
  TEMP->( dbSkip() )
endDo
TEMP->( dbCloseArea() )

return nRet

***************

Static Function meuScan( aArr, cHave, cHave2 )

***************
Local nIdx := 0

for x := 1 to len(aArr)
 if alltrim(upper(aArr[x][2])) $ alltrim(upper(cHave))
   if alltrim(upper(aArr[x][1])) == alltrim(upper(cHave2))
     return x
   endIf
 endIf
next
return 0 

***************

Static Function Maquina( cMaqui )

***************
Local aRes:={}

cQury:="SELECT Z00_MAQ,CASE WHEN SUBSTRING(C2_PRODUTO,1,2)IN ('ME','PI') THEN 'Z' ELSE SUBSTRING(C2_PRODUTO,3,1) END AS COR,SUM(Z00_PESO)AS PESO "
cQury+="FROM Z00020 Z00,SC2020 SC2   "
cQury+="WHERE Z00_FILIAL = '" + xFilial("Z00") + "' AND C2_FILIAL= '" + xFilial("SC2") + "' "
cQury+="AND C2_NUM=SUBSTRING(Z00_OP,1,6) "
cQury+="AND C2_SEQUEN='001' "
cQury+="AND Z00_APARA != ''  "
cQury+=" " + iif(cMaqui == 'EXT', "and SUBSTRING(Z00_MAQ,1,2) IN ('E0')", " and SUBSTRING(Z00_MAQ,1,2) IN ('C0','P0')") + " "
cQury+="AND Z00_DATA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'  "
cQury+="AND  Z00.D_E_L_E_T_ != '*' AND SC2.D_E_L_E_T_ != '*' "
cQury+="GROUP by Z00_MAQ,CASE WHEN SUBSTRING(C2_PRODUTO,1,2)IN ('ME','PI') THEN 'Z' ELSE SUBSTRING(C2_PRODUTO,3,1) END "
cQury+="ORDER by Z00_MAQ,COR "   

TCQUERY cQury NEW ALIAS 'TMPZ'

TMPZ->( dbGoTop() )
cnt:=1
do While ! TMPZ->( EoF() )
   cMaq:=TMPZ->Z00_MAQ
   aadd(aRes,{TMPZ->Z00_MAQ,{ {'A',0},{'B',0},{'C',0},{'D',0},{'E',0},{'F',0},{'G',0},{'L',0},{'Z',0} } } )
   do While ! TMPZ->( EoF() ) .AND. TMPZ->Z00_MAQ=cMaq
	  nIdx  := aScan(aRes[1][2], {|t| t[1]==TMPZ->COR     } )
	  If nIdx>0
	     aRes[cnt][2][nIdx][2]:=TMPZ->PESO
      endif
   TMPZ->( dbskip() )
   Enddo
   cnt+=1
Enddo

TMPZ->( DbCloseArea() )

Return aRes


