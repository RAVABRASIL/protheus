#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function FATREST1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt()

public nTotEst := nTotCart := nTotSRE := 0


#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Fatrcan  ³ Autor ³   Esmerino Neto     ³ Data ³ 28/10/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DescriCAo ³  Relacao em Estoque e media de venda em 6 meses            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Rava                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³                                                              ³
//³ mv_par01        Data de inicio                               ³
//³ mv_par02        Relatorio Geral ou por Segmento              ³
//³ mv_par03        Segmento (Institucional, Hospitalar ou Domes)³
//³ mv_par04        Imprime Ativos (Todos, Sim, Nao)             ³
//³                                                              ³
//³                                                              ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

tamanho   := "M"
titulo    := PADC("Relatorio Previsao de Venda de Produtos em Estoque",51) //74
cDesc1    := PADC("Este programa ira Emitir um Relatorio de ",74)
cDesc2    := PADC("Estoque com Media Semestral",74)
cDesc3    := ""
cNatureza := ""
aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "FATREST1"
cPerg     := "FATRES"
//cPerg     := "FATPVS"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "FATREST1"
M_PAG     := 1
cString := "SC5"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( cPerg, .T. )               // Pergunta no SX1
titulo += "De " + Dtoc( mv_par01 - 180 ) + " Ate " + Dtoc( mv_par01 ) + IIF(MV_PAR05=1," Estoq.Cabedelo",IIF(MV_PAR05=2," Estoq.São Paulo"," Todos os Estoques"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )
wnrel := SetPrint( cString, wnrel, , @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault( aReturn, cString )

If nLastKey == 27
	Return
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
	Return
	// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
	Static Function RptDetail()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DESENVOLVIMENTO DO PROGRAMA          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT )) AS CARTEIRA, SC6.C6_PRODUTO, SB1.B1_DESC "
cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery += "SC6.C6_TES != '540' AND "//Remessa MIXKIT
if MV_PAR05 = 1
   cQuery += "SC6.C6_LOCAL = '01' AND " //Considera so carteira de Cabedelo
elseif MV_PAR05 = 2
   cQuery += "SC6.C6_LOCAL = '10' AND " //Considera so carteira de Sao Paulo
endif   
cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY SC6.C6_PRODUTO, SB1.B1_DESC"
TCQUERY cQuery NEW ALIAS "SC6X"

cQuery2 := "SELECT @@ROWCOUNT AS NUMREG, SUM( SD2.D2_QUANT ) AS QUANT, COUNT(SD2.D2_COD) AS QTDPEDI, SD2.D2_COD, SB1.B1_DESC, SD2.D2_SERIE, SF2.F2_VEND1 "
cQuery2 += "FROM " + RetSqlName( "SD2" ) + " SD2, " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SF2" ) + " SF2 "
cQuery2 += "WHERE (SD2.D2_EMISSAO >= '" + Dtos( mv_par01 - 180 ) + "' AND SD2.D2_EMISSAO <= '" + Dtos( mv_par01 ) + "') AND "
cQuery2 += "SD2.D2_COD = SB1.B1_COD AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SB1.B1_TIPO = 'PA' AND "
cQuery2 += "RTRIM(SD2.D2_CF) IN ( '511','5101','5107','611','6101','512','5102','612','6102','6109','6107 ','5949','6949' ) AND "
if MV_PAR05 = 1
   cQuery2 += "SD2.D2_LOCAL = '01' AND " //Considera so Faturamento de Cabedelo
elseif MV_PAR05 = 2
   cQuery2 += "SD2.D2_LOCAL = '10' AND " //Considera so Faturamento de Sao Paulo
endif   
cQuery2 += "SD2.D2_FILIAL = '" + xFilial( "SD2" ) + "' AND SD2.D_E_L_E_T_ = ' ' AND "
cQuery2 += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cQuery2 += "SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND SF2.D_E_L_E_T_ = ' ' "
cQuery2 += "GROUP BY SD2.D2_COD, SB1.B1_DESC, SD2.D2_SERIE, SF2.F2_VEND1 "
TCQUERY cQuery2 NEW ALIAS "SD2X"

nTOTREG := SD2X->NUMREG
aSTRUT := {}

aadd( aSTRUT, { "CODIGO",   "C", 15, 0 } )
aadd( aSTRUT, { "CARTEIRA", "N", 09, 2 } )
aadd( aSTRUT, { "VENDAS",   "N", 12, 2 } )
aadd( aSTRUT, { "COMUNI",	"N", 12, 2 } )
aadd( aSTRUT, { "NAOUNI",	"N", 12, 2 } )
aadd( aSTRUT, { "QTDPED",	"N", 09, 2 } )
aadd( aSTRUT, { "DESCR",    "C", 40, 2 } )
aadd( aSTRUT, { "PRODMES",	"N", 04, 0 } )

cARQ := CriaTrab( aSTRUT, .T. )
Use ( cARQ ) Alias TMP New Exclusive
Index On CODIGO To ( cARQ )

SC6X->( DbGotop() )
Do While ! SC6X->( Eof() )//preenchimento do valor em carteira e informações sobre o produto
	cPROD := SC6X->C6_PRODUTO
	If Len( AllTrim( cPROD ) ) >= 8
		If Subs( cPROD, 4, 1 ) == "R" .or. Subs( cPROD, 5, 1 ) == "R"
			cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 4 ) + Subs( cPROD, 8, 2 ), Len( SC6X->C6_PRODUTO ) )
		Else
			cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 3 ) + Subs( cPROD, 7, 2 ), Len( SC6X->C6_PRODUTO ) )
		EndIf
	EndIf
	If ! TMP->( Dbseek( cPROD ) )
		TMP->( DbAppend() )
		TMP->CODIGO   := cPROD
		TMP->CARTEIRA := SC6X->CARTEIRA
		TMP->DESCR    := SC6X->B1_DESC
	Else
		TMP->CARTEIRA += SC6X->CARTEIRA
	EndIf
	SC6X->( DbSkip() )
EndDo

SD2X->( DbGotop() )
Do While ! SD2X->( Eof() )
	nUNI  := 0
	nSUNI := 0
	cPROD := SD2X->D2_COD
	If Len( AllTrim( cPROD ) ) >= 8
		If Subs( cPROD, 4, 1 ) == "R" .or. Subs( cPROD, 5, 1 ) == "R"
			cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 4 ) + Subs( cPROD, 8, 2 ), Len( SD2X->D2_COD ) )
		Else
			cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 3 ) + Subs( cPROD, 7, 2 ), Len( SD2X->D2_COD ) )
		EndIf
		If ! Empty( SD2X->D2_SERIE ) .AND. !'VD' $ SD2X->F2_VEND1
			nSUNI := SD2X->QUANT
		EndIf
	Else
		nUNI := SD2X->QUANT
	EndIf
	
	If ! TMP->( Dbseek( cPROD ) )
		TMP->( DbAppend() )
		TMP->CODIGO  := cPROD
		TMP->VENDAS  := SD2X->QUANT
		TMP->QTDPED	 := SD2X->QTDPEDI
		TMP->DESCR   := SD2X->B1_DESC
		TMP->NAOUNI  += nSUNI
		TMP->COMUNI  += nUNI
	Else
		TMP->VENDAS  += SD2X->QUANT
		TMP->QTDPED	 += SD2X->QTDPEDI
		TMP->NAOUNI  += nSUNI
		TMP->COMUNI  += nUNI
	EndIf
	SD2X->( DbSkip() )
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DADOS IMPRESSOS NO RELATORIO    					         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin := Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho

/*
----------------------------------------------------------------
LAYOUT DA IMPRESSAO DO RELATORIO
----------------------------------------------------------------*/

cTitulos_1 := Iif (mv_par02==1,"Todos os Produtos ", "Segmento " + Iif (mv_par03==1, "Institucional", Iif (mv_par03==2, "Hospitalar", "Domestico"))) + Iif(mv_par04==2, " Ativos", Iif(mv_par04==3, " Inativos", " Ativos e Inativos"))
cTitulos_2 := "-------------------------------------------------------------------------------------------------------------------------------"
cTitulos_3 := "Num.  Codigo do  Descricao do Produto                     Produto  Saldo Atual    Total em  Saldo Virt. Media Venda    Qtd. em"
cTitulos_4 := "        Produto                                            Ativo   em Estoque     Carteira  em Estoque  Mens.Ul.6Ms    Estoque"
cTitulos_5 := "-------------------------------------------------------------------------------------------------------------------------------"
//9999   99999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    x      999,999,99  999,999,99  999,999,99   999,999,99  9,999 dias
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//0         1         2         3         4         5         6         7         8         9        10        11        12

@ Prow() + 1,000 PSay Padc( cTitulos_1, 126 )
@ Prow() + 1,000 PSay cTitulos_2
@ Prow() + 1,000 PSay cTitulos_3
@ Prow() + 1,000 PSay cTitulos_4
@ Prow() + 1,000 PSay cTitulos_5

TMP->( DBGoTop() )
TMP->( Dbseek( CODIGO ) )
SetRegua(nTOTREG)
nNumLinha := 1

if MV_PAR05 = 1
   cAlmox := '01'
else
   cAlmox := '10'
endif  

While ! TMP-> ( EOF() )
	SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO+cAlmox ) )
	SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
	
	If ( mv_par02 == 1 ) .or. ( mv_par03 == 1 .AND. Subs( TMP->CODIGO , 1, 1 ) == 'A' )
		If (mv_par04 == 1) .OR. (mv_par04 == 2 .AND. SB1->B1_ATIVO == 'S') .OR. ( mv_par04 > 2 .and. SB1->B1_ATIVO == 'N')
			IMPRIMA()
		EndIf
	ElseIf mv_par03 == 2 .AND. Subs( TMP->CODIGO , 1, 1 ) == 'C'
		If (mv_par04 == 1) .OR. (mv_par04 == 2 .AND. SB1->B1_ATIVO == 'S' ) .OR. ( mv_par04 > 2 .and. SB1->B1_ATIVO == 'N')
			IMPRIMA()
		EndIf
	Else
		If Subs( TMP->CODIGO , 1, 1 ) $ 'E D' 
		   if mv_par04 == 1 .OR. (mv_par04 == 2 .AND. SB1->B1_ATIVO == 'S') .or. ( mv_par04 > 2 .and. SB1->B1_ATIVO == 'N')
			  IMPRIMA()
		   EndIf
		EndIf
	EndIf	
	
	IncRegua()
	
	TMP->( DbSkip() )
EndDo

TOTAIS()

TMP->( DbCloseArea() )
SD2X->( DbCloseArea() )
SC6X->( DbCloseArea() )

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

Return Nil

***************
Static Function IMPRIMA()
***************
local nRet := 0
@ Prow() + 1,000 PSay nNumLinha
@ Prow()    ,007 PSay Alltrim( TMP->CODIGO )
@ Prow()    ,017 PSay Alltrim( TMP->DESCR )
@ Prow()    ,061 PSay Alltrim( SB1->B1_ATIVO )
@ Prow()    ,068 PSay SB2->B2_QATU Picture "@E 999,999.99"
@ Prow()    ,080 PSay TMP->CARTEIRA Picture "@E 999,999.99"
@ Prow()	,092 PSay (SB2->B2_QATU - TMP->CARTEIRA) Picture "@E 999,999.99"
@ Prow()    ,105 PSay (TMP->COMUNI + TMP->NAOUNI) / 6 Picture "@E 999,999.99"
nRet := Round( ( ( SB2->B2_QATU - TMP->CARTEIRA ) * 30 ) / ( ( TMP->COMUNI + TMP->NAOUNI ) / 6 ), 0 )
@ Prow()	,117 PSay transform(iif( ( ( SB2->B2_QATU - TMP->CARTEIRA) <= 0 ), 0, nRet ),"@E 9999") + " dias"

if Prow() > 58
	nLin:=Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
	@ Prow() + 1,000 PSay Padc( cTitulos_1, 126 )
	@ Prow() + 1,000 PSay cTitulos_2
	@ Prow() + 1,000 PSay cTitulos_3
	@ Prow() + 1,000 PSay cTitulos_4
	@ Prow() + 1,000 PSay cTitulos_5
endIf
nNumLinha := nNumLinha + 1
nTotEst := nTotEst + SB2->B2_QATU
nTotCart := nTotCart + TMP->CARTEIRA
nTotSRE := nTotSRE + (SB2->B2_QATU - TMP->CARTEIRA)
Return Nil

***************
Static Function TOTAIS()
***************

@ Prow() + 2,058 PSay "TOTAIS->"
@ Prow()    ,068 PSay nTotEst Picture "@E 999,999.99"
@ Prow()    ,080 PSay nTotCart Picture "@E 999,999.99"
@ Prow()    ,092 PSay nTotSRE Picture "@E 999,999.99"

Return Nil



/*
User Function FATREST1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt()

public nTotEst := nTotCart := nTotSRE := 0


#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Programa  ³  Fatrcan  ³ Autor ³   Esmerino Neto     ³ Data ³ 28/10/2005³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³DescriCAo ³  Relacao em Estoque e media de venda em 6 meses            ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Uso       ³ Especifico para Rava                                       ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³                                                              ³
//³ mv_par01        Data de inicio                               ³
//³ mv_par02        Relatorio Geral ou por Segmento              ³
//³ mv_par03        Segmento (Institucional, Hospitalar ou Domes)³
//³ mv_par04        Imprime Ativos (Todos, Sim, Nao)             ³
//³                                                              ³
//³                                                              ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

tamanho   := "M"
titulo    := PADC("Relatorio Previsao de Venda de Produtos em Estoque",51) //74
cDesc1    := PADC("Este programa ira Emitir um Relatorio de ",74)
cDesc2    := PADC("Estoque com Media Semestral",74)
cDesc3    := ""
cNatureza := ""
aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "FATREST1"
cPerg     := "FATRES"
//cPerg     := "FATPVS"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "FATREST1"
M_PAG     := 1
cString := "SC5"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte( cPerg, .T. )               // Pergunta no SX1
titulo += "De " + Dtoc( mv_par01 - 180 ) + " Ate " + Dtoc( mv_par01 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )
wnrel := SetPrint( cString, wnrel, , @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault( aReturn, cString )

If nLastKey == 27
	Return
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
	Return
	// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
	Static Function RptDetail()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DESENVOLVIMENTO DO PROGRAMA          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT )) AS CARTEIRA, SC6.C6_PRODUTO, SB1.B1_DESC "
cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY SC6.C6_PRODUTO, SB1.B1_DESC"
TCQUERY cQuery NEW ALIAS "SC6X"

cQuery2 := "SELECT @@ROWCOUNT AS NUMREG, SUM( SD2.D2_QUANT ) AS QUANT, COUNT(SD2.D2_COD) AS QTDPEDI, SD2.D2_COD, SB1.B1_DESC, SD2.D2_SERIE, SF2.F2_VEND1 "
cQuery2 += "FROM " + RetSqlName( "SD2" ) + " SD2, " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SF2" ) + " SF2 "
cQuery2 += "WHERE (SD2.D2_EMISSAO >= '" + Dtos( mv_par01 - 180 ) + "' AND SD2.D2_EMISSAO <= '" + Dtos( mv_par01 ) + "') AND "
cQuery2 += "SD2.D2_COD = SB1.B1_COD AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SB1.B1_TIPO = 'PA' AND "
cQuery2 += "SD2.D2_FILIAL = '" + xFilial( "SD2" ) + "' AND SD2.D_E_L_E_T_ = ' ' AND "
cQuery2 += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cQuery2 += "SF2.F2_FILIAL = '" + xFilial( "SF2" ) + "' AND SF2.D_E_L_E_T_ = ' ' "
cQuery2 += "GROUP BY SD2.D2_COD, SB1.B1_DESC, SD2.D2_SERIE, SF2.F2_VEND1 "
TCQUERY cQuery2 NEW ALIAS "SD2X"

nTOTREG := SD2X->NUMREG
aSTRUT := {}

aadd( aSTRUT, { "CODIGO",   "C", 15, 0 } )
aadd( aSTRUT, { "CARTEIRA", "N", 09, 2 } )
aadd( aSTRUT, { "VENDAS",   "N", 12, 2 } )
aadd( aSTRUT, { "COMUNI",	"N", 12, 2 } )
aadd( aSTRUT, { "NAOUNI",	"N", 12, 2 } )
aadd( aSTRUT, { "QTDPED",	"N", 09, 2 } )
aadd( aSTRUT, { "DESCR",    "C", 40, 2 } )
aadd( aSTRUT, { "PRODMES",	"N", 04, 0 } )

cARQ := CriaTrab( aSTRUT, .T. )
Use ( cARQ ) Alias TMP New Exclusive
Index On CODIGO To ( cARQ )

SC6X->( DbGotop() )
Do While ! SC6X->( Eof() )//preenchimento do valor em carteira e informações sobre o produto
	cPROD := SC6X->C6_PRODUTO
	If Len( AllTrim( cPROD ) ) >= 8
		If Subs( cPROD, 4, 1 ) == "R" .or. Subs( cPROD, 5, 1 ) == "R"
			cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 4 ) + Subs( cPROD, 8, 2 ), Len( SC6X->C6_PRODUTO ) )
		Else
			cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 3 ) + Subs( cPROD, 7, 2 ), Len( SC6X->C6_PRODUTO ) )
		EndIf
	EndIf
	If ! TMP->( Dbseek( cPROD ) )
		TMP->( DbAppend() )
		TMP->CODIGO   := cPROD
		TMP->CARTEIRA := SC6X->CARTEIRA
		TMP->DESCR    := SC6X->B1_DESC
	Else
		TMP->CARTEIRA += SC6X->CARTEIRA
	EndIf
	SC6X->( DbSkip() )
EndDo

SD2X->( DbGotop() )
Do While ! SD2X->( Eof() )
	nUNI  := 0
	nSUNI := 0
	cPROD := SD2X->D2_COD
	If Len( AllTrim( cPROD ) ) >= 8
		If Subs( cPROD, 4, 1 ) == "R" .or. Subs( cPROD, 5, 1 ) == "R"
			cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 4 ) + Subs( cPROD, 8, 2 ), Len( SD2X->D2_COD ) )
		Else
			cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 3 ) + Subs( cPROD, 7, 2 ), Len( SD2X->D2_COD ) )
		EndIf
		If ! Empty( SD2X->D2_SERIE ) .AND. !'VD' $ SD2X->F2_VEND1
			nSUNI := SD2X->QUANT
		EndIf
	Else
		nUNI := SD2X->QUANT
	EndIf
	
	If ! TMP->( Dbseek( cPROD ) )
		TMP->( DbAppend() )
		TMP->CODIGO  := cPROD
		TMP->VENDAS  := SD2X->QUANT
		TMP->QTDPED	 := SD2X->QTDPEDI
		TMP->DESCR   := SD2X->B1_DESC
		TMP->NAOUNI  += nSUNI
		TMP->COMUNI  += nUNI
	Else
		TMP->VENDAS  += SD2X->QUANT
		TMP->QTDPED	 += SD2X->QTDPEDI
		TMP->NAOUNI  += nSUNI
		TMP->COMUNI  += nUNI
	EndIf
	SD2X->( DbSkip() )
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DADOS IMPRESSOS NO RELATORIO    					         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin := Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho


cTitulos_1 := Iif (mv_par02==1,"Todos os Produtos ", "Segmento " + Iif (mv_par03==1, "Institucional", Iif (mv_par03==2, "Hospitalar", "Domestico"))) + Iif(mv_par04==2, " Ativos", Iif(mv_par04==3, " Inativos", " Ativos e Inativos"))
cTitulos_2 := "-------------------------------------------------------------------------------------------------------------------------------"
cTitulos_3 := "Num.  Codigo do  Descricao do Produto                     Produto  Saldo Atual    Total em  Saldo Virt. Media Venda    Qtd. em"
cTitulos_4 := "        Produto                                            Ativo   em Estoque     Carteira  em Estoque  Mens.Ul.6Ms    Estoque"
cTitulos_5 := "-------------------------------------------------------------------------------------------------------------------------------"
//9999   99999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    x      999,999,99  999,999,99  999,999,99   999,999,99  9,999 dias
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//0         1         2         3         4         5         6         7         8         9        10        11        12

@ Prow() + 1,000 PSay Padc( cTitulos_1, 126 )
@ Prow() + 1,000 PSay cTitulos_2
@ Prow() + 1,000 PSay cTitulos_3
@ Prow() + 1,000 PSay cTitulos_4
@ Prow() + 1,000 PSay cTitulos_5

TMP->( DBGoTop() )
TMP->( Dbseek( CODIGO ) )
SetRegua(nTOTREG)
nNumLinha := 1
While ! TMP-> ( EOF() )
	
	If mv_par02 == 1
		If mv_par04 == 1		
			SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO ) )
			SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
			IMPRIMA()
		ElseIf mv_par04 == 2
			SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO ) )
			SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
			If SB1->B1_ATIVO $ 'S'
				IMPRIMA()
			EndIf
		ElseIf mv_par04 == 3
			SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO ) )
			SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
			If SB1->B1_ATIVO $ 'N'
				IMPRIMA()
			EndIf
		EndIf
	Else
		If mv_par03 == 1
			If mv_par04 == 1
				If Subs( TMP->CODIGO , 1, 1 )  $  'A'
					SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO ) )
					SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
					IMPRIMA()
				EndIf
			ElseIf mv_par04 == 2
				If Subs( TMP->CODIGO , 1, 1 )  $  'A'
					SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO ) )
					SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
					If SB1->B1_ATIVO $ 'S'
						IMPRIMA()
					EndIf
				EndIf
			Else
				If Subs( TMP->CODIGO , 1, 1 )  $  'A'
					SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO ) )
					SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
					If SB1->B1_ATIVO $ 'N'
						IMPRIMA()
					EndIf
				EndIf
			EndIf
		ElseIf mv_par03 == 2
			If mv_par04 == 1
				If Subs( TMP->CODIGO , 1, 1 )  $  'C'
					SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO ) )
					SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
					IMPRIMA()
				EndIf
			ElseIf mv_par04 == 2
				If Subs( TMP->CODIGO , 1, 1 )  $  'C'
					SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO ) )
					SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
					If SB1->B1_ATIVO == 'S'
						IMPRIMA()
					EndIf
				EndIf
			Else
				If Subs( TMP->CODIGO , 1, 1 )  $  'C'
					SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO ) )
					SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
					If SB1->B1_ATIVO == 'N'
						IMPRIMA()
					EndIf
				EndIf
			EndIf
		Else
			If mv_par04 == 1
				If Subs( TMP->CODIGO , 1, 1 )  $  'E D'
					SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO ) )
					SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
					IMPRIMA()
				EndIf
			ElseIf mv_par04 == 2
				If Subs( TMP->CODIGO , 1, 1 )  $  'E D'
					SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO ) )
					SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
					If SB1->B1_ATIVO == 'S'
						IMPRIMA()
					EndIf
				EndIf
			Else
				If Subs( TMP->CODIGO , 1, 1 )  $  'E D'
					SB2->( dbseek( xFILIAL("SB2") + TMP->CODIGO ) )
					SB1->( dbseek( xFILIAL("SB1") + TMP->CODIGO ) )
					If SB1->B1_ATIVO == 'N'
						IMPRIMA()
					EndIf
				EndIf
			EndIf
		EndIf
		
	EndIf
	
	IncRegua()
	
	TMP->( DbSkip() )
EndDo

TOTAIS()

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool( wnrel ) //Chamada do Spool de Impressao
Endif

TMP->( DbCloseArea() )
SD2X->( DbCloseArea() )
SC6X->( DbCloseArea() )
MS_FLUSH()
Return Nil

***************
Static Function IMPRIMA()
***************
local nRet := 0
@ Prow() + 1,000 PSay nNumLinha
@ Prow()    ,007 PSay Alltrim( TMP->CODIGO )
@ Prow()    ,017 PSay Alltrim( TMP->DESCR )
@ Prow()    ,061 PSay Alltrim( SB1->B1_ATIVO )
@ Prow()    ,068 PSay SB2->B2_QATU Picture "@E 999,999.99"
@ Prow()    ,080 PSay TMP->CARTEIRA Picture "@E 999,999.99"
@ Prow()	,092 PSay (SB2->B2_QATU - TMP->CARTEIRA) Picture "@E 999,999.99"
@ Prow()    ,105 PSay (TMP->COMUNI + TMP->NAOUNI) / 6 Picture "@E 999,999.99"
nRet := Round( ( ( SB2->B2_QATU - TMP->CARTEIRA ) * 30 ) / ( ( TMP->COMUNI + TMP->NAOUNI ) / 6 ), 0 )
@ Prow()	,117 PSay transform(iif( ( ( SB2->B2_QATU - TMP->CARTEIRA) <= 0 ), 0, nRet ),"@E 9999") + " dias"

if Prow() > 58
	nLin:=Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
	@ Prow() + 1,000 PSay Padc( cTitulos_1, 126 )
	@ Prow() + 1,000 PSay cTitulos_2
	@ Prow() + 1,000 PSay cTitulos_3
	@ Prow() + 1,000 PSay cTitulos_4
	@ Prow() + 1,000 PSay cTitulos_5
endIf
nNumLinha := nNumLinha + 1
nTotEst := nTotEst + SB2->B2_QATU
nTotCart := nTotCart + TMP->CARTEIRA
nTotSRE := nTotSRE + (SB2->B2_QATU - TMP->CARTEIRA)
Return Nil

***************
Static Function TOTAIS()
***************

@ Prow() + 2,058 PSay "TOTAIS->"
@ Prow()    ,068 PSay nTotEst Picture "@E 999,999.99"
@ Prow()    ,080 PSay nTotCart Picture "@E 999,999.99"
@ Prow()    ,092 PSay nTotSRE Picture "@E 999,999.99"

Return Nil

*/