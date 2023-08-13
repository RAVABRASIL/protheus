#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#INCLUDE "topconn.ch"

User Function FATR03()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

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
SetPrvt("CABEC2,ACARTEIRA,CNUM,NVALOR,NQTD1UM,NPESQ")
SetPrvt("NTOTAL,NTOTKG,ACART,X,NQTDKG,NFATOR","cPROD, nTOTQT")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Fatr03  ³ Autor ³   Silvano Araujo      ³ Data ³ 08/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de pedidos em carteira                             ³±±
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
//³ mv_par01          // De Emissao                              ³
//³ mv_par02          // Ate Emissao                             ³
//³ mv_par03          // De Pedido                               ³
//³ mv_par04          // Ate Pedido                              ³
//³ mv_par05          // De Produto                              ³
//³ mv_par06          // Ate Produto                             ³
//³ mv_par07          // De Cliente                              ³
//³ mv_par08          // Ate a Cliente                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="M"
limite:=254

cDesc1 :=PADC("Este programa ira Emitir posicao carteira pedidos de vendas",74)
cDesc2 :=""
cDesc3 :=""
cNatureza:=""
aReturn := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="FATR03"
cPerg:="FATR03"
nLastKey:= 0
lContinua := .T.
nLin:=9
wnrel    := "FATR03"
M_PAG    := 1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tamanho do Formulario de Nota Fiscal (em Linhas)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTamNf:=72     // Apenas Informativo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString := "SC5"
titulo  := PADC("Relatorio Carteira de Pedidos",74)

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
//          10        20        30        40        50        60        70        80        90        100       110       120
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Cabec1 := "Cod              Descricao do Produto                     Quant. 1a Um   Quant. Kg 2a Um   Valor Ped.     Fator     Margem"
cabec2 := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//pergunte("FATR03",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="FATR03"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})

Return



Static Function RptDetail()

local cCart
local aCarteira := {}
local aCart := {}

cCart := "SELECT ( CASE WHEN LEN(C6_PRODUTO)>=8 THEN "
//cCart += "         SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,3)+SUBSTRING(C6_PRODUTO,7,2) "
//cCart += "         SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,3)+SUBSTRING(C6_PRODUTO,len(rtrim(C6_PRODUTO))-1,2) "
cCart += "CASE when (Substring( C6_PRODUTO, 4, 1 ) = 'R') or  (Substring( C6_PRODUTO, 5, 1 ) = 'R') "
cCart += "     then SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,4)+SUBSTRING(C6_PRODUTO,8,2) "
cCart += "     else SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,3)+SUBSTRING(C6_PRODUTO,7,2) end "
cCart += "     ELSE C6_PRODUTO END ) AS C6_PRODUTO, B1_DESC, "
cCart += "SUM( SC6.C6_QTDVEN - SC6.C6_QTDENT) AS QUANT1, B1_UM, "
cCart += "SUM( (SC6.C6_QTDVEN - SC6.C6_QTDENT) / SB1.B1_CONV ) AS QUANT2, B1_SEGUM, "
cCart += IIf(!Empty(aReturn[7]),A285QryFil("SC5",cCart,aReturn[7]),"")
cCart += "SUM( (SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT ) AS VALPED "
cCart += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9 "
cCart += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cCart += "SC5.C5_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
cCart += "SC6.C6_PRODUTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
cCart += "SC5.C5_CLIENTE BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND "
if MV_PAR11 = 1
   cCart += "SC6.C6_LOCAL = '01' AND "
elseif MV_PAR11 = 2
   cCart += "SC6.C6_LOCAL = '10' AND "
endif   
cCart += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cCart += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cCart += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cCart += "SC9.C9_BLCRED IN('  ','04') and SC9.C9_BLEST != '10' AND "
cCart += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cCart += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cCart += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cCart += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "
cCart += "GROUP BY C6_PRODUTO, B1_DESC, B1_UM, B1_SEGUM, C5_ENTREG "
cCart += "ORDER BY C6_PRODUTO "

TCQUERY cCart NEW ALIAS "CARX"
DbSelectArea("CARX")


while !CARX->(Eof())
	nPesq := Ascan( aCarteira, { |aVAL| aVAL[1] == CARX->C6_PRODUTO } )
	
	if nPesq == 0
		Aadd( aCarteira, { CARX->C6_PRODUTO, CARX->VALPED, CARX->QUANT1, CARX->QUANT2, CARX->B1_UM, CARX->B1_SEGUM, CARX->B1_DESC } )
	else
		aCarteira[ nPesq, 2 ] := aCarteira[ nPesq, 2 ] + CARX->VALPED
		aCarteira[ nPesq, 3 ] := aCarteira[ nPesq, 3 ] + CARX->QUANT1
		aCarteira[ nPesq, 4 ] := aCarteira[ nPesq, 4 ] + CARX->QUANT2
	endif
	CARX->( dbSkip() )
end

CARX->(DbCloseArea())

nTotal  := nTotKg  := nTotQt  := 0
nTotPQt := nTotPKg := nTotPal := nTotPKg := 0

aCart   := Asort( aCarteira,,, { |X,Y| X[1]<Y[1] } )
SetRegua( Len( aCart ) )

if Len(aCart) > 0
   cTipSeg := Subs( aCart[ 1, 1 ], 1, 1 )
endif
for x := 1 to len( aCart )
	
	IF nLin > 60
		nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 1
	EndIF
	
	If cTipSeg != Subs( aCart[ x, 1 ], 1, 1 )
		@ nLin,00  PSay "Total do Segmento" + IIf( cTipSeg == 'A', " Institucional ",;
		IIf( cTipSeg == 'B', " ABNT "      ,;
		IIf( cTipSeg == 'C', " Hospitalar ",;
		IIf( cTipSeg $ 'DE', " Domestico " ,;
		IIf( cTipSeg == 'F', " Lanche "    ," Sacola ") ) ) ) ) + " ==>"
		@ nLin,56  PSay nTotPQt         Picture "@E 999,999.99"
		@ nLin,75  PSay nTotPKg         Picture "@E 999,999.99"
		@ nLin,89  PSay nTotPal         Picture "@E 9,999,999.99"
		@ nLin,102 PSay nTotPal/nTotPKg Picture "@E 999,999.99"
		@ nLin,116 PSay (((nTotPal/nTotPKg)/mv_par09) - 1) * 100 Picture "@E 999.99" /*nTotPal/nTotPKg*/
		nTotPQt := nTotPKg := nTotPal := nTotPKg := 0
		cTipSeg := Subs( aCart[ x, 1 ], 1, 1 )
		nLin    := nLin + 3
	EndIf
	
	
	nQtdKg := aCart[ x, 4 ]
	nFator := Round( aCart[ x, 2 ] / nQtdkg, 2 )
	
	@ nLin,00  PSay Left(aCart[ x, 1 ],10)
	@ nLin,13  PSay Left(aCart[ x, 7 ],40)
	@ nLin,56  PSay aCart[ x, 3 ]    Picture "@E 999,999.99"
	@ nLin,67  PSay aCart[ x, 5 ]
	@ nLin,75  PSay nQtdKg           Picture "@E 999,999.99"
	@ nLin,86  PSay aCart[ x, 6 ]
	@ nLin,89  PSay aCart[ x, 2 ]    Picture "@E 999,999.99"
	@ nLin,102 PSay nFator           Picture "@E 999,999.99"
	@ nLin,116 PSay ((nFator/mv_par09) - 1) * 100	 Picture "@E 999.99" /*nTotPal/nTotPKg*/
	
	nTotQt += aCart[ x, 3 ]
	nTotKg := nTotKg + nQtdKg
	nTotal := nTotal + aCart[ x, 2 ]
	nLin   := nLin   + 1
	
	nTotPQt += aCart[ x, 3 ]
	nTotPKg += nQtdKg
	nTotPal += aCart[ x, 2 ]
	IncRegua()
Next
/**/
//O último segmento precisa ter seus totais impressos!
if len( aCart ) > 0
  @ nLin,00  PSay "Total do Segmento" + IIf( cTipSeg == 'A', " Institucional ",;
  IIf( cTipSeg == 'B', " ABNT "      ,;
  IIf( cTipSeg == 'C', " Hospitalar ",;
  IIf( cTipSeg $ 'DE', " Domestico " ,;
  IIf( cTipSeg == 'F', " Lanche "    ," Sacola ") ) ) ) ) + " ==>"
  @ nLin,56  PSay nTotPQt         Picture "@E 999,999.99"
  @ nLin,75  PSay nTotPKg         Picture "@E 999,999.99"
  @ nLin,89  PSay nTotPal         Picture "@E 9,999,999.99"
  @ nLin,102 PSay nTotPal/nTotPKg Picture "@E 999,999.99"
  @ nLin,116 PSay (((nTotPal/nTotPKg)/mv_par09) - 1) * 100 Picture "@E 999.99" /*nTotPal/nTotPKg*/
  nTotPQt := nTotPKg := nTotPal := nTotPKg := 0
  //cTipSeg := Subs( aCart[ x, 1 ], 1, 1 )
  nLin    := nLin + 3
endIf
/**/
IF nLin > 55
	nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) + 1
EndIf
nLin++
@ nLin,00  PSay "Total Geral ==>"
@ nLin,56  PSay nTotQt         Picture "@E 999,999.99"
@ nLin,75  PSay nTotKg         Picture "@E 999,999.99"
@ nLin,89  PSay nTotal         Picture "@E 9,999,999.99"
@ nLin,102 PSay nTotal/nTotKg  Picture "@E 999,999.99"
@ nLin,116 PSay (((nTotal/nTotKg)/mv_par09) - 1) * 100 Picture "@E 999.99" /*nTotPal/nTotPKg*/

roda(cbcont,cbtxt,tamanho)

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

Return(.T.)