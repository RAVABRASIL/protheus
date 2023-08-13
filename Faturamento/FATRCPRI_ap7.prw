#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATRCPRI  º Autor ³ Esmerino Neto      º Data ³  13/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relaciona os produtos que, segundo o carteira, tem suas    º±±
±±º          ³ Ordens de Produção como prioriárias                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento / Estoque                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º                PARAMETROS EM USO NESTE PROGRAMA                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  MV_PAR01                    Da data do Pedido                        º±±
±±º  MV_PAR02                    Ate a data do Pedido                     º±±
±±º  MV_PAR03                    Do Produto                               º±±
±±º  MV_PAR04                    Ate o Produto                            º±±
±±º  MV_PAR05                    Da data da OP                            º±±
±±º  MV_PAR06                    Ate a data da OP                         º±±
±±º  MV_PAR07                    Da OP                                    º±±
±±º  MV_PAR08                    Ate a OP                                 º±±
±±º  MV_PAR09                    Considera Produtos                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
*/

*******************
User Function FATRCPRI
*******************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatório "
Local cDesc2         := "que relaciona as OPs dos produtos com prioridade pa-"
Local cDesc3         := "ra produção.   "
Local cPict          := ""
Local titulo       := "Ordens de Producao com Prioridade"
Local nLin         := 80

Local Cabec1       := Cabeca01()//"Num | Produto |  Cart Kg  | Cart R$    |   Ord.Pr | Qtd.ML | Qtd.KG | Prodz.OP | Dt.Emissao"
Local Cabec2       := Cabeca02()
Local imprime      := .T.
Private aOrd       := {"Codigo"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220//140//80
Private tamanho          := "G"//"M"//"P"
Private nomeprog         := "FATRCPRI" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "FATRCP"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FATRCPRI" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SC6"

//dbSelectArea("SC6")
//dbSetOrder(1)


pergunte(cPerg,.T.)

titulo := titulo + " de " + DtoC( MV_PAR01 ) + " a " + DtoC( MV_PAR02 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  13/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
	
//Carteira de Pedidos
cQuery1 := "SELECT SC6.C6_PRODUTO AS PRODUTO, SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS CARTEIRA_KG, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS  "
cQuery1 += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC9" )+ " SC9, " + RetSqlName( "SC6" )+ " SC6," + RetSqlName( "SA1" ) + " SA1  "
cQuery1 += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery1 += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "         
cQuery1 += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "                
//cQuery1 += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND SC6.C6_TES != '540' AND "
// NOVA LIBERACAO DE CRETIDO
cQuery1 += "SC9.C9_BLCRED IN('  ','04') and SC9.C9_BLEST != '10' AND SC6.C6_TES != '540' AND "
cQuery1 += "SC5.C5_ENTREG  BETWEEN '" + DtoS( MV_PAR10 ) + "' AND '" + DtoS( MV_PAR11 ) + "' AND "
cQuery1 += "SC5.C5_EMISSAO BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' AND "
cQuery1 += "SC6.C6_PRODUTO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
cQuery1 += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cQuery1 += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cQuery1 += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cQuery1 += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' AND "
cQuery1 += "SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' AND "
cQuery1 += "SA1.A1_COD+SA1.A1_LOJA=SC5.C5_CLIENTE+SC5.C5_LOJACLI  "

if MV_PAR13==1
   cQuery1 +="AND SA1.A1_EST='SP'  "
elseif MV_PAR13==2
   cQuery1 +="AND SA1.A1_EST!='SP'  "
endif

cQuery1 += "GROUP BY SC6.C6_PRODUTO "
cQuery1 += "ORDER BY SC6.C6_PRODUTO "
cQuery1 := ChangeQuery( cQuery1 )
TCQUERY cQuery1 NEW ALIAS "CART"

CART->( DbGoTop() )
aCart := {}
While ! CART->( EoF() )
	cPROD := CART->PRODUTO
	If Len( AllTrim( cPROD ) ) >= 8
		If Subs( cPROD, 4, 1 ) == "R" .or. Subs( cPROD, 5, 1 ) == "R"
			cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 4 ) + Subs( cPROD, 8, 2 ), Len( SC6->C6_PRODUTO ) )
		Else
			cPROD := Padr( Subs( cPROD, 1, 1 ) + Subs( cPROD, 3, 3 ) + Subs( cPROD, 7, 2 ), Len( SC6->C6_PRODUTO ) )
		EndIf
	EndIf
	
	nPesq := Ascan( aCart, { |aVAL| aVAL[1] == cPROD } )

	if nPesq == 0
		aAdd(aCart,{ cPROD, CART->CARTEIRA_KG, CART->CARTEIRA_RS })
	else
		aCart[ nPesq, 2 ] += CART->CARTEIRA_KG
		aCart[ nPesq, 3 ] += CART->CARTEIRA_RS
	Endif
	
	CART->( DbSkip() )
EndDo

CART->( DbCloseArea() )

Asort( aCart,,, { | x, y | x[ 1 ] < y[ 1 ] } )

cQuery2 := "SELECT C2_NUM AS OP, C2_PRODUTO AS PRODUTO, C2_QUANT AS QTD_ML, C2_QTSEGUM AS QTD_KG, C2_QUJE AS PRODUZ_ML, C2_EMISSAO "
cQuery2 += "FROM " + RetSqlName( "SC2" ) + " "
cQuery2 += "WHERE C2_EMISSAO BETWEEN '" + DtoS( MV_PAR05 ) + "' AND '" + DtoS( MV_PAR06 ) + "' "
cQuery2 += "AND C2_NUM BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
cQuery2 += "AND C2_SEQUEN LIKE '001%' "
cQuery2 += "AND C2_DATRF = ' ' "
cQuery2 += "AND C2_FILIAL = '" + xFilial( "SC2" ) + "' AND D_E_L_E_T_ = ' ' "
cQuery2	+= "ORDER BY C2_PRODUTO "
cQuery2 += ChangeQuery( cQuery2 )
TCQUERY cQuery2 NEW ALIAS "OPSP"

OPSP->( DbGoTop() )
aOPs 	:= {}

While ! OPSP->( EoF() )
	aAdd( aOPs, {OPSP->PRODUTO, OPSP->OP, OPSP->QTD_ML, OPSP->QTD_KG, OPSP->PRODUZ_ML, OPSP->C2_EMISSAO } )
	OPSP->( DbSkip() )
EndDo

OPSP->( DbCloseArea() )

nSeq  := 1
nCont := 1
nNumReg := Len(aCart)

nEstKG := nTotEsKG := nTotCrKG := nTotCrML:=FalKG:=FalUN := 0

While nCont <= nNumReg
	
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
		nLin := 8
		
	Endif
	lOk := .T.
	
	if MV_PAR09 = 2
		DBSelectArea( 'SB1' )
		SB1->( DBSetOrder( 1 ) )
		DBSeek( xFilial( "SB1" ) + Alltrim( aCart[ nCont, 1 ] ), .T. )
		DBSelectArea( 'SB2' )
		SB2->( DBSetOrder( 1 ) )
		DBSeek( xFilial( "SB2" ) + Alltrim( aCart[ nCont, 1 ] ), .T. )
		nEstKG := SB2->B2_QATU / SB1->B1_CONV //Quant Estoque Kg
		/**/ //Inserido em 22/10/2007
		/* APENAS O ESTOQUE PADRAO (01)
		if SB2->( dbSeek( xFilial( "SB2" ) + aCart[ nCont, 1 ] + "02", .F. ) )
		  nEstKG += SB2->B2_QATU / SB1->B1_CONV //Quant Estoque Kg		
		endIf
		*/
		/**/
		
		//Inserido em 02/06/2009 CHAMADO 001072   ALMOXARIFADO SAO PAULO(10)
   	    /* APENAS O ESTOQUE PADRAO (01)
		if MV_PAR12 = 1
		   if SB2->( dbSeek( xFilial( "SB2" ) + aCart[ nCont, 1 ] + "10", .F. ) )
		      nEstKG += SB2->B2_QATU / SB1->B1_CONV //Quant Estoque Kg		
		   endIf
		endif
		*/
		//
		
		lOk := ( nEstKG < aCart[ nCont, 2 ] ) //Quant Estoque for Menor que a quant Carteira
	endif
	
	if lOk
		
		nLin := nLin + 1 // Avanca a linha de impressao
		@nLin,00 PSAY nNum := StrZero( nSeq, 3 )
		@nLin,06 PSAY Alltrim( aCart[ nCont, 1 ] )
		//@nLin,15 PSAY aCart[ nCont, 2 ] Picture '@E 999,999'
		//@nLin,27 PSAY aCart[ nCont, 3 ] Picture '@E 999,999.99'
		DBSelectArea( 'SB1' )
		SB1->( DBSetOrder( 1 ) )
		DBSeek( xFilial( "SB1" ) + Alltrim( aCart[ nCont, 1 ] ), .T. )
		DBSelectArea( 'SB2' )
		SB2->( DBSetOrder( 1 ) )
		DBSeek( xFilial( "SB2" ) + Alltrim( aCart[ nCont, 1 ] ), .T. )
		nEstKG := SB2->B2_QATU / SB1->B1_CONV
		/**/ //Inserido em 22/10/2007
		/* APENAS O ESTOQUE PADRAO (01)
		if SB2->( dbSeek( xFilial( "SB2" ) + aCart[ nCont, 1 ] + "02", .F. ) )
		  nEstKG += SB2->B2_QATU / SB1->B1_CONV //Quant Estoque Kg		
		endIf
		*/
		/**/
		
		//Inserido em 02/06/2009 CHAMADO 001072 ALMOXARIFADO SAO PAULO(10)
		/* APENAS O ESTOQUE PADRAO (01)		
		if MV_PAR12 = 1
		   if SB2->( dbSeek( xFilial( "SB2" ) + aCart[ nCont, 1 ] + "10", .F. ) )
		      nEstKG += SB2->B2_QATU / SB1->B1_CONV //Quant Estoque Kg		
		   endIf
		endif
		*/
		//
		
		@nLin,14 PSAY  Round(nEstKG, 2) Picture '@E 999,999.99'
		@nLin,25 PSAY aCart[ nCont, 2 ] Picture '@E 999,999.99'
		@nLin,36 PSAY Round( nEstKG-(aCart[ nCont, 2 ]), 2) Picture '@E 999,999.99'
		@nLin,46 PSAY Round( (nEstKG * SB1->B1_CONV)-(aCart[ nCont, 2 ] * SB1->B1_CONV), 2) Picture '@E 999,999.99'
		nPesq2 := Ascan( aOPs, { |aVAL| aVAL[1] == aCart[ nCont, 1 ] } )
		
		If nPesq2 > 0
			cProdOP := aOPs[ nPesq2, 1 ]
			nTotal := nTotQtML := nTotQtKG := nTotPzOP := nTotRsOP := nTotRsUN := 0
			While cProdOP == aOPs[ nPesq2, 1 ]
				@nLin,/*51*/60 PSAY "-> " + Alltrim( aOPs[ nPesq2, 2 ] )
				@nLin,71 PSAY Round( aOPs[ nPesq2, 3 ], 2 ) Picture '@E 999,999.99'
				@nLin,82 PSAY Round( aOPs[ nPesq2, 4 ], 2 ) Picture '@E 999,999.99'
				@nLin,93 PSAY Round( aOPs[ nPesq2, 5 ]/SB1->B1_CONV, 2 ) Picture '@E 999,999.99'
				@nLin,104 PSAY Round( aOPs[ nPesq2, 4 ] - (aOPs[ nPesq2, 5 ]/SB1->B1_CONV), 2 ) Picture '@E 999,999.99'
				@nLin,115 PSAY Round( ( aOPs[ nPesq2, 4 ] - (aOPs[ nPesq2, 5 ]/SB1->B1_CONV) ) * SB1->B1_CONV, 2 ) Picture '@E 999,999.99'
				@nLin,132 PSAY StoD( aOPs[ nPesq2, 6 ] )
				//@nLin,95 PSAY aOPs[ nPesq2, 1 ]
				nTotQtML += aOPs[ nPesq2, 3 ]
				nTotQtKG += aOPs[ nPesq2, 4 ]
				nTotPzOP += (aOPs[ nPesq2, 5 ]/SB1->B1_CONV)
				nTotRsOP += aOPs[ nPesq2, 4 ] - (aOPs[ nPesq2, 5 ]/SB1->B1_CONV)
				nTotRsUN += ( aOPs[ nPesq2, 4 ] - (aOPs[ nPesq2, 5 ]/SB1->B1_CONV) ) * SB1->B1_CONV
				nPesq2++
				nTotal++
				nLin++
			EndDo
			If nTotal >= 2
				@nLin,63 PSAY "TOTAL->"
				@nLin,71 PSAY Round( nTotQtML, 2 ) Picture '@E 999,999.99'
				@nLin,82 PSAY Round( nTotQtKG, 2 ) Picture '@E 999,999.99'
				@nLin,93 PSAY Round( nTotPzOP, 2 ) Picture '@E 999,999.99'
				@nLin,104 PSAY Round( nTotRsOP, 2 ) Picture '@E 999,999.99'
				@nLin,115 PSAY Round( nTotRsUN, 2 ) Picture '@E 999,999.99'
				nLin++
			EndIf
		Else
			nLin++
		EndIf
		
		nTotCrKG += aCart[ nCont, 2 ]
		//nTotCrML += aCart[ nCont, 3 ]
		nTotEsKG += nEstKG
	    FalKG    += Round(nEstKG-(aCart[ nCont, 2 ]),2)
	    FalUN    +=Round( (nEstKG * SB1->B1_CONV)-(aCart[ nCont, 2 ] * SB1->B1_CONV), 2)
	    nSeq++
	endif
	nCont++
EndDo
DBCloseArea( "SB1" )
DBCloseArea( "SB2" )
@nLin + 2,07 PSAY "TOTAL->"
@nLin + 2,15 PSAY Round(nTotEsKG,2) Picture '@E 999,999.99'
//@nLin + 2,27 PSAY nTotCrML Picture '@E 999,999.99'
@nLin + 2,27 PSAY Round(nTotCrKG,2) Picture '@E 999,999.99'
@nLin + 2,37 PSAY Round(FalKG,2)    Picture '@E 999,999.99'
@nLin + 2,47 PSAY Round(FalUN,2)    Picture '@E 999,999.99'

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

Static Function Cabeca01()
cCab1 := "Num | Descri. |--Estoque--|--Carteira do Produto-----------|-----------------Ordens de Producao Ativas para este Produto----------------------|"
Return cCab1

Static Function Cabeca02()
cCab2 := "Ord | Produto | Atual KG  | Em KG   | Falta KG  | Falta UN |   Codigo |  Qtd.UN   |  Qtd.KG   | Prodz.KG  | Resta KG  | Resta UN  | Dt.Emissao"
		//999   XXXXXX  |999.999.99 |999.999,99  999.999,99  -> xxxxxx  999.999,99 999.999,99 999.999,99 999.999,99 999.999,99  99/99/99
		//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		//0         1         2         3         4         5         6         7         8         9        10        11        12
Return cCab2
