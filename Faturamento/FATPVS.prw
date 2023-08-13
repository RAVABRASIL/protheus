#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     º Autor ³ AP6 IDE            º Data ³  17/10/07   º±±
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

User Function FATPVS2

*************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio Previsao de Venda de Produtos em Estoque de"
Local cPict          := ""
Local titulo         := "Relatorio Previsao de Venda de Produtos em Estoque de "
Local nLin           := 80
Local Cabec1         := "Num.  Codigo do  Descricao do Produto                     Produto  Saldo Atual    Total em  Saldo Virt. Media Venda    Qtd. em"
Local Cabec2         := "        Produto                                            Ativo   em Estoque     Carteira  em Estoque  Mens.Ul.6Ms    Estoque"
Local imprime        := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "FATPVS2" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATPVS2" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""
Pergunte( "FATRES", .F. )
titulo += Dtoc( mv_par01 - 180 ) + " Ate " + Dtoc( mv_par01 )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"FATRES",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  17/10/07   º±±
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

Local nTOTREG
Local cQuery  := cQuery2 := ''
Local aStrut  := {}
Local aArray1 := {}
Local aArray2 := {}
Local cArq
Local cProd
Local nLin   := 9
Local nTotCart := nTotEst := nIndex := nQatu  := 0
Local Z := 1
/// SB1.B1_CONV
cQuery := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) ) AS CARTEIRA, SC6.C6_PRODUTO, SB1.B1_DESC, SB1.B1_ATIVO "
cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
//Sugerir pergunta padrão SBM e validações das perguntas
//mv_par02 == 1 >> geral >> todos
if mv_par02 == 2
  if mv_par03 == 1 //institucional
    cQuery += "SB1.B1_GRUPO = 'A' AND "
  elseIf mv_par03 == 2 //hospitalar
    cQuery += "SB1.B1_GRUPO = 'C' AND "
  else//doméstico
    cQuery += "SB1.B1_GRUPO in('D','E') AND "
  endIf    
endIf

//mv_par04 = 1 >> todos
if mv_par04 == 2
  cQuery += "SB1.B1_ATIVO = 'S' AND "
elseIf mv_par04 == 3
  cQuery += "SB1.B1_ATIVO = 'N' AND "  
endIf

cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY SC6.C6_PRODUTO, SB1.B1_DESC,SB1.B1_ATIVO "
cQuery += "order by SC6.C6_PRODUTO "
TCQUERY cQuery NEW ALIAS "SC6X"
SC6X->( dbGoTop() )

cQuery2 := "SELECT COUNT(SD2.D2_COD) AS QTDPEDI, SD2.D2_COD, SB1.B1_DESC, SD2.D2_SERIE, SF2.F2_VEND1, SB1.B1_ATIVO, "
cQuery2 += "sum(case "
cQuery2 += "when D2_SERIE = '' and F2_VEND1 not like '%VD%' "
cQuery2 += "then 0 "
cQuery2 += "else "
cQuery2 += "D2_QUANT "
cQuery2 += "end) QUANT "
cQuery2 += "FROM " + RetSqlName( "SD2" ) + " SD2, " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SF2" ) + " SF2 "
cQuery2 += "WHERE (SD2.D2_EMISSAO >= '" + Dtos( mv_par01 - 180 ) + "' AND SD2.D2_EMISSAO <= '" + Dtos( mv_par01 ) + "') AND "
cQuery2 += "SD2.D2_COD = SB1.B1_COD AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SB1.B1_TIPO = 'PA' AND "
cQuery2 += "SD2.D2_TIPO = 'N' AND SF2.F2_DUPL <> '' "
cQuery2 += "AND SD2.D2_CF IN ( '511','5101','611','6101','512','5102','612','6102','6109','6107','5949 ','6949' ) "
cQuery2 += "AND SD2.D2_CLIENTE NOT IN ('001588', '002655', '002311' ) AND "
//Sugerir pergunta padrão SBM e validações das perguntas
//mv_par02 == 1 >> geral >> todos
if mv_par02 == 2
  if mv_par03 == 1 //institucional
    cQuery2 += "SB1.B1_GRUPO = 'A' AND "
  elseIf mv_par03 == 2 //hospitalar
    cQuery2 += "SB1.B1_GRUPO = 'C' AND "
  else//doméstico
    cQuery2 += "SB1.B1_GRUPO in('D','E') AND "
  endIf    
endIf
//mv_par04 = 1 >> todos
if mv_par04 = 2
  cQuery2 += "SB1.B1_ATIVO = 'S' AND "
elseIf mv_par04 = 3
  cQuery2 += "SB1.B1_ATIVO = 'N' AND "  
endIf
cQuery2 += "SD2.D2_FILIAL = '" + xFilial( "SD2" ) + "' AND SD2.D_E_L_E_T_ = ' ' AND "
cQuery2 += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cQuery2 += "SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND SF2.D_E_L_E_T_ = ' ' "
cQuery2 += "GROUP BY SD2.D2_COD, SB1.B1_DESC, SD2.D2_SERIE, SF2.F2_VEND1, SB1.B1_ATIVO "
cQuery2 += "order by SD2.D2_COD "
TCQUERY cQuery2 NEW ALIAS "SD2X"
SD2X->( dbGoTop() )

Do While ! SC6X->( Eof() )//preenchimento do valor em carteira e informações sobre o produto
   cPROD := SC6X->C6_PRODUTO
   If Len( AllTrim( cPROD ) ) >= 8
      If Subs( cPROD, 4, 1 ) == "R" .or. Subs( cPROD, 5, 1 ) == "R"
        cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 4 ) + Subs( cPROD, 8, 2 ), Len( SC6X->C6_PRODUTO ) )
      Else
	    cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 3 ) + Subs( cPROD, 7, 2 ), Len( SC6X->C6_PRODUTO ) )
	  EndIf
   EndIf
   if Mais6M(cProd)
      nIndex := aScan(aArray1, { |X| X[1] == cProd } )
      If  (nIndex == 0) //.and. (len(aArray) > 0)
        aAdd(aArray1,{cPROD, round(SC6X->CARTEIRA,4), SC6X->B1_DESC, SD2X->B1_ATIVO, 0, 0} )
      Else
        aArray1[nIndex][2] += round(SC6X->CARTEIRA,4)
      EndIf
   endif   
   SC6X->( DbSkip() )
EndDo
SC6X->( dbCloseArea() )
nIndex := 0

Do While ! SD2X->( Eof() )
  cPROD := SD2X->D2_COD
  If Len( AllTrim( cPROD ) ) >= 8
     If Subs( cPROD, 4, 1 ) == "R" .or. Subs( cPROD, 5, 1 ) == "R"//DUVIDA AQUI!DUVIDA AQUI!DUVIDA AQUI!
       cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 4 ) + Subs( cPROD, 8, 2 ), Len( SD2X->D2_COD ) )
     Else
       cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 3 ) + Subs( cPROD, 7, 2 ), Len( SD2X->D2_COD ) )
  	 EndIf
  EndIf 
  if Mais6M(cProd) 	 
     nIndex := aScan(aArray1, { |X| X[1] == cProd } )
     If  (nIndex == 0) //.and. (len(aArray) > 0)
       aAdd(aArray1,{cPROD, 0, SD2X->B1_DESC, SD2X->B1_ATIVO, round(SD2X->QTDPEDI,4), round(SD2X->QUANT,4) } )
     Else
       aArray1[nIndex][5] += round(SD2X->QTDPEDI,4)
       aArray1[nIndex][6] += round(SD2X->QUANT,4)
     EndIf
  endif   
  SD2X->( DbSkip() )
EndDo
SD2X->( dbCloseArea() )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSort(aArray1,,, { |X,Y| X[1] < Y[1] } )
SetRegua(len(aArray1))

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
for k := 1 to len( aArray1 )  

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
      nLin := 9
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:   
   //"Num.  Codigo do  Descricao do Produto                     Produto  Saldo Atual    Total em  Saldo Virt. Media Venda    Qtd. em"
   //"        Produto                                            Ativo   em Estoque     Carteira  em Estoque  Mens.Ul.6Ms    Estoque"     
   // 9999   99999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    x      999,999,99  999,999,99  999,999,99   999,999,99  9,999 dias
   // 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   // 0         1         2         3         4         5         6         7         8         9        10        11        12
   //{cPROD, 0, SD2X->B1_DESC, SD2X->B1_ATIVO, SD2X->QTDPEDI, SD2X->QUANT }
   @nLin ,000 PSay Z++
   @nLin ,007 PSay Alltrim( aArray1[K][1] )
   @nLin ,017 PSay substr(  aArray1[K][3],1,35 )  
   @nLin ,061 PSay alltrim( aArray1[K][4] )//Alltrim( Posicione( "SB1", 1, xFilial("SB1") + TMPX->CODIGO, "B1_ATIVO" ) )
   nQatu := Posicione( "SB2", 1, xFilial("SB2") + aArray1[K][1], "B2_QATU" )
   /**/ //Inserido em 22/10/2007
   nQatu += Posicione( "SB2", 1, xFilial("SB2") + aArray1[K][1] + '02', "B2_QATU" )
   /**/
   @nLin ,068 PSay transform(nQatu, "@E 999,999.999")
   @nLin ,080 PSay aArray1[K][2] Picture "@E 999,999.999"
   @nLin ,092 PSay (nQatu - aArray1[K][2]) Picture "@E 999,999.999"   
   @nLin ,105 PSay (aArray1[K][6]) / 6 Picture "@E 999,999.999"
   nRet :=  ( ( nQatu - aArray1[K][2] ) * 30 ) / ( ( aArray1[K][6] ) / 6 )
   @nLin ,117 PSay transform(iif( ( ( nQatu - aArray1[K][2]) <= 0 ), 0, nRet ),"@E 9999") + " dias"
   nTotCart += aArray1[K][2]
   nTotEst += nQatu
   nLin := nLin + 1 // Avanca a linha de impressao
   incRegua()
Next

@ Prow() + 2,058 PSay "TOTAIS->"
@ Prow()    ,068 PSay nTotEst Picture "@E 999,999.99"
@ Prow()    ,080 PSay nTotCart Picture "@E 999,999.99"
//@ Prow()    ,092 PSay nTotSRE Picture "@E 999,999.99"



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

//Funcao para testar se a primeira OP do produto
//tem mais de 6 meses, ou seja, o produto já tem
//pelo menos 6 meses de fabricado.
*****************************
static function Mais6M(cProd)
*****************************
local cQuery
local lOk

cQuery := "SELECT C2_PRODUTO, MIN(C2_EMISSAO) AS C2_EMISSAO "
cQuery += "FROM "+RetSqlName("SC2")+ " "
cQuery += "WHERE C2_PRODUTO = '"+cProd+"' AND D_E_L_E_T_ = '' "
cQuery += "GROUP BY C2_PRODUTO "
cQuery += "ORDER BY MIN(C2_EMISSAO) "

TCQUERY cQuery NEW ALIAS "_SC2X"
TCSetField( '_SC2X', "C2_EMISSAO", "D")

lOk := ( dDataBase - _SC2X->C2_EMISSAO ) >= 180

_SC2X->(DbCloseArea())

return lOK