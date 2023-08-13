#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTPDV()

tamanho   := "M"
titulo    := PADC("Relatorio analitico de Posicao de Vendas (FATPFI)", 74)
cDesc1    := PADC("Relatorio analitico de Posicao de Vendas (FATPFI)", 74)
cDesc2    := PADC("", 74)
cDesc3    := PADC("", 74)
cNatureza := ""
aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "ESTPDV"
cPerg     := "ESTHOSP"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "ESTPDV"
M_PAG     := 1

Pergunte( cPerg, .T. )
titulo += " de " + DtoC(mv_par01)
cString := "SB1"

aArr := aArray := {}
nFatest := U_FATEST()
nTotRS := nTotKG := 0
wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

If nLastKey == 27
	 Return
Endif

SetDefault( aReturn, cString )

If nLastKey == 27
	 Return
Endif

#IFDEF WINDOWS
	 RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
	 Return
	// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
	Static Function RptDetail()
#ENDIF

//lista de itens e notas por dia
cQuery := "select SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_PRCVEN, SD2.D2_COD, SD2.D2_QUANT, SD2.D2_QTSEGUM, SD2.D2_EMISSAO, SB1.B1_PESOR "
cQuery += "from   "+ RetSqlName("SD2") +" SD2, "+ RetSqlName("SF2") +" SF2, "+ RetSqlName("SB1") +" SB1 "
cQuery += "where  SD2.D2_EMISSAO = '" + alltrim(dtos(mv_par01)) + "' and SD2.D2_COD NOT LIKE '1%' " //sem apara
cQuery += "and SD2.D2_COD >= '" + alltrim(mv_par02) + "' and SD2.D2_COD <= '" + alltrim(mv_par03) + "' "

cQuery += "and SB1.B1_GRUPO in('E','D')"

cQuery += "and SF2.F2_DOC = SD2.D2_DOC and SF2.F2_SERIE = SD2.D2_SERIE "
cQuery += "and SD2.D2_CF IN ('511', '5101', '611', '6101', '512', '5102', '612', '6102', '6109', '6107', '5949', '6949') "
cQuery += "and SF2.F2_DUPL <> ' ' "
cQuery += "and SD2.D2_COD = SB1.B1_COD " //incluido em 01/12/06
cQuery += "and SD2.D2_FILIAL = '"+ xFilial("SD2") +"' and SD2.D_E_L_E_T_ != '*' "
cQuery += "and SF2.F2_FILIAL = '"+ xFilial("SF2") +"' and SF2.D_E_L_E_T_ != '*' "
cQuery += "and SB1.B1_FILIAL = '"+ xFilial("SB1") +"' and SB1.D_E_L_E_T_ != '*' " //incluido em 01/12/06
cQuery += "order by SD2.D2_DOC "
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery NEW ALIAS "TMPX"
TMPX->( DbGoTop() )

Do while ! TMPX->( EoF() )
	//Pôr um if aqui checando se D2_COD é limpbras e chamando a sua função
	//aArr := listAcs(TMPX->D2_COD)
	aArr := limpBras(TMPX->D2_COD)
	nTotRS += TMPX->D2_QUANT * TMPX->D2_PRCVEN
	nTotKG += TMPX->D2_QTSEGUM
	aAdd(aArray, {TMPX->D2_DOC, TMPX->D2_SERIE, TMPX->D2_COD, TMPX->D2_QUANT, TMPX->D2_PRCVEN, TMPX->B1_PESOR, aArr} )

	TMPX->( DbSkip() )
EndDo
			//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
			//        10        20        30        40        50        60        70        80        90	   100       110       120       130
cCabec_01 := "N. FISCAL  | SERIE | PRODUTO | QUANTIDADE/NF | PRC. VENDA | TOTAL/NF | COMPONENTE| QUANTIDADE/AC | UL. PRECO | QT*PRC R$ | DESP ACES"
Cabec( titulo, "", "", nomeprog, tamanho, 15 )

nTotGD := 0

SetRegua( Len(aArray) )

FOR X := 1 TO len(aArray)
    nTotDes := 0
    nDesAce := 0
	If PRow() >= 56
  	Cabec( titulo, "", "", nomeprog, tamanho, 15 )
 	endIf
    

	@ Prow() + 1, 000 PSay cCabec_01
    @ Prow() + 1, 000 PSay Repl( '-', 132 )
	@ PRow() + 1, 001 PSay alltrim(aArray[X][1]) //NF
	@ PRow()    , 013 PSay Iif(alltrim(aArray[X][2]) != '', alltrim(aArray[X][2]), 'BRANCO')//SERIE
	@ PRow()    , 021 PSay alltrim(Iif(Len( AllTrim( aArray[X][3] ) ) >= 8, alltrim(U_transgen(aArray[X][3])), aArray[X][3])) //PRODUTO
	@ PRow()    , 031 PSay transform(aArray[X][4], "@E 999,999.99") //QUANTIDADE
	@ PRow()		, 046 PSay transform(aArray[X][5], "@E 999,999.99") //PRECO DE VENDA
	@ PRow()		, 059 PSay transform(aArray[X][4] * aArray[X][5], "@E 999,999.99") //PRECO DE VENDA
	nPesor := aArray[X][6]
	If Len( aArray[X][7] ) != 0
		nTot := 0
		FOR Z := 1 TO len(aArray[X][7])
			@ PRow()    , 072 PSay alltrim(aArray[X][7][Z][1])//Componente
			@ PRow()    , 084 PSay transform(aArray[X][7][Z][2], "@E 999,999.99999")//Quantidade
			if substr(aArray[X][7][Z][1], 1, 2) != 'PI'
				@ PRow()    , 099 PSay transform(aArray[X][7][Z][3], "@E 999,999.99")//Ultimo preco
				@ PRow()    , 110 PSay transform(aArray[X][7][Z][3] * aArray[X][7][Z][2], "@E 999,999.999")//qtd*prec
				nTotGD += nTot += aArray[X][7][Z][3] * aArray[X][7][Z][2]
				@ Prow() + 1, 000 PSay ""
				If PRow() >= 56
  				//Cabec( titulo, "", "", nomeprog, tamanho, 15 )
				@ Prow() + 1, 000 PSay ""
 				endIf
			EndIf
			If PRow() >= 56
  			Cabec( titulo, "", "", nomeprog, tamanho, 15 )
				@ Prow() + 1, 000 PSay ""
 			endIf
			If substr(aArray[X][7][Z][1], 1, 2) = 'PI'
				aArr2 := listAcs( alltrim( aArray[X][7][Z][1] ) )
				nTot4 := nTot3 := nTot2 := 0
				If Len( aArr2 ) != 0
					FOR W := 1 TO len( aArr2 )
						nTot2 += aArr2[W][2] * aArr2[W][3]
					NEXT
					nTot4 := (nTot2/100) * aArray[X][7][Z][2]
					nTot2 := (nTot2/100)// + nFatest
					nTot3 := nTot2 * aArray[X][7][Z][2]
					@ PRow()    , 099 PSay transform(nTot2, "@E 999,999.99")//Ultimo preco para 1kg do PI!!!
					@ PRow()    , 110 PSay transform(nTot2 * aArray[X][7][Z][2], "@E 999,999.999")//quantidade pra fazer esse PA x ULT.PRC.
					@ Prow() + 1, 000 PSay ""
					FOR K := 1 TO len( aArr2 )
						@ PRow()    , 072 PSay alltrim(aArr2[K][1])
						@ PRow()    , 084 PSay transform(aArr2[K][2], "@E 999,999.99999")//Quantidade
						@ PRow()    , 099 PSay transform(aArr2[K][3], "@E 999,999.99")//Ultimo preco
						@ PRow()    , 110 PSay transform(aArr2[K][2] * aArr2[K][3], "@E 999,999.999")
 						@ Prow() + 1, 000 PSay ""
					NEXT
				Else
					@ PRow() + 1, 059 PSay "PI sem extrutura."
				EndIf
			EndIf

		NEXT
		//nTot5 := (nTot + nTot3) + (nPesor * nFatest)                      //(nTot + nTot3) + (nPesor * nFatest)
		//@ PRow()	, 079 PSay "Custo de fabric. + M. de Obra: " + transform( nTot5 , "@E 999,999.99" )//+" "+ transform(nTot4 + nTot, "@E 999.9999")
		@ PRow() + 1, 075 PSay "Quantidade do item na nota fiscal: " + transform( aArray[X][4], "@E 999,999.99" )
		//@ PRow() + 1, 103 PSay "Total: " + transform( nTot5 *  aArray[X][4], "@E 999,999.99" )
		@ PRow() + 1, 077 PSay "Total de Material de embalagem.: " + transform( nTot, "@E 999,999.99" )
		@ PRow() + 1, 103 PSay "Total: " + transform( nTot *  aArray[X][4], "@E 999,999.99" )
		
	Else
		@ PRow() + 1, 001 PSay "Produto sem extrutura."
	EndIf
	@ Prow() + 1, 000 PSay " "
    IncRegua()
NEXT
	if PRow() >= 56
		Cabec( titulo, "", "", nomeprog, tamanho, 15 )
	endif
	@ PRow() + 1, 000 PSay "Totais do dia: "
	@ PRow() 		, 015 PSay mv_par01
	@ PRow() + 1, 000 PSay "---------------------------"
	//@ PRow() + 1, 000 PSay "Mao de obra      :" + transform( nFatest, "@E 999,999.99")
	@ PRow() + 1, 000 PSay "Total em R$      :" + transform( nTotRS, "@E 999,999.99")
	@ PRow() + 1, 000 PSay "Total em KG      :" + transform( nTotKG, "@E 999,999.99")
	@ PRow() + 1, 000 PSay "Total Desp.Acess.:" + transform( nTotGD, "@E 999,999.99")

If aReturn[5] == 1
	 Set Printer To
	 Commit
	 ourspool( wnrel ) //Chamada do Spool de Impressao
Endif

TMPX->( DbCloseArea() )
MS_FLUSH()


Return Nil


**********

Static Function listAcs(cCod)

**********

Local aArr := {}

	If Len( AllTrim( cCod ) ) >= 8
	   cCod := U_transgen(cCod)
	EndIf

	cQuery2 := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC "
  cQuery2 += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
  cQuery2 += "where 	SG1.G1_COD = '" + alltrim(cCod) + "' "
  cQuery2 += "and  SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
  cQuery2 += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
	cQuery2 += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
	cQuery2 := ChangeQUery(cQuery2)
	TCQUERY cQuery2 NEW ALIAS "AUX"
	AUX->( DbGoTop() )

	Do while ! AUX->( EoF() )
		nCheck := 0
		nPcMed := U_CALPREAC(AUX->G1_COMP, 1, STOD(TMPX->D2_EMISSAO))
		If substr(AUX->G1_COMP, 1, 2) == 'ME'
			nCheck := precProd( AUX->G1_COMP ) / 100
			If nCheck > 0
				aAdd(aArr, {AUX->G1_COMP, AUX->G1_QUANT, nCheck } )
			Else
//				aAdd(aArr, {AUX->G1_COMP, AUX->G1_QUANT, AUX->B1_UPRC} )
                aAdd(aArr, {AUX->G1_COMP, AUX->G1_QUANT, nPcMed} )
			EndIf
			AUX->( DbSkip() )
		Else
//			aAdd(aArr, {AUX->G1_COMP, AUX->G1_QUANT, AUX->B1_UPRC} )
            aAdd(aArr, {AUX->G1_COMP, AUX->G1_QUANT, nPcMed} )
			AUX->( DbSkip() )
		EndIf

	EndDo

	if len(aArr) < 1
		aArr := {}
	endif

	AUX->( DbCloseArea() )

Return aArr


**********

Static Function precProd( cCod )

**********

Local nTotal := 0
Local aArray := {}
Local cQuery3


	If Len( AllTrim( cCod ) ) >= 8
	  cCod := U_transgen(cCod)
	EndIf

	cQuery3 := "select	SG1.G1_COD, SG1.G1_COMP, SG1.G1_QUANT, SB1.B1_UPRC "
  cQuery3 += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
  cQuery3 += "where 	SG1.G1_COD = '" + alltrim(cCod) + "' "
  cQuery3 += "and SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
  cQuery3 += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
	cQuery3 += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
	cQuery3 += "order by G1_COMP"
	cQuery3 := ChangeQUery(cQuery3)
	TCQUERY cQuery3 NEW ALIAS "PRPX"
	PRPX->( DbGoTop() )

	Do While ! PRPX->( EoF() )
//		aAdd( aArray, {PRPX->G1_COD, PRPX->G1_COMP, PRPX->G1_QUANT, PRPX->B1_UPRC} )
		aAdd( aArray, {PRPX->G1_COD, PRPX->G1_COMP, PRPX->G1_QUANT, U_CALPREAC(PRPX->G1_COMP, 1, STOD(TMPX->D2_EMISSAO))} )
		If substr(PRPX->G1_COMP, 1, 2) == 'PI'
			nPIQT := PRPX->G1_QUANT
		EndIf
		PRPX->( DbSkip() )
	EndDo
	PRPX->( DbCloseArea() )

	If len( aArray ) > 0
		FOR A := 1 TO len( aArray )
			If substr(aArray[A][2], 1, 2) == 'MP'
				nTotal += aArray[A][3] * aArray[A][4]
			Else
				nTotal += precProd( aArray[A][2] ) * nPIQT
			EndIf
		NEXT
	EndIf

Return nTotal

***************

Static Function limpBras( cCod )

***************
// se o produto for dona limpeza ou brasileirinho, incluir sacos-capa como acessorios!
Local nTotal := 0
Local cAlias
Local aArea := {}
Local aArr  := {}
cAlias := iif( substr( alias(), 1, 4 ) == 'TMPX', soma1(alias()), 'TMPX1')
aArea := getArea()

If Len( AllTrim( cCod ) ) >= 8
	cCod := U_transgen(cCod)
EndIf
cQuery := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC, "
cQuery += " (select	top 1 SD1.D1_VUNIT "
cQuery += " from	" + RetSqlName('SD1') + " SD1 "
cQuery += " where	SG1.G1_COMP = SD1.D1_COD and SD1.D1_TIPO = 'N' and SD1.D_E_L_E_T_ != '*' "
cQuery += " order by SD1.D1_DTDIGIT desc) as D1_VUNIT "
cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
cQuery += "where 	SG1.G1_COD = '" + alltrim(cCod) + "' "
if substr(cCod,1,1) $ 'E /D'
  cQuery += "and substring(SG1.G1_COMP,1,2) in ('ME') "  //apenas sacos-capa
endIf
cQuery += "and  SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
cQuery += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
cQuery += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
cQuery := ChangeQUery(cQuery)
TCQUERY cQUery NEW ALIAS &cAlias
&(cAlias+"->( DbGoTop() )")

Do while ! &(cAlias+"->( EoF() )")
  if &(cAlias+"->G1_COMP") >= 'ME0700' .and. &(cAlias+"->G1_COMP") <= 'ME0799' //ME comprado, não é fabricado internamente
    aAdd(aArr, { &(cAlias+"->G1_COMP"), &(cAlias+"->G1_QUANT"),  &(cAlias+"->D1_VUNIT") } )
  elseIf substr(alltrim( &(cAlias+"->G1_COMP") ),1,2 ) == 'MP'
    nTotal += &(cAlias+"->G1_QUANT") * &(cAlias+"->D1_VUNIT")
  elseIf substr(alltrim( &(cAlias+"->G1_COMP") ),1,2 ) == 'PI'
  	nTotal += &(cAlias+"->G1_QUANT") * limpBras( &(cAlias+"->G1_COMP") ) / 100
  elseIf substr(alltrim( &(cAlias+"->G1_COMP") ),1,2 ) == 'ME'
    aAdd(aArr, { &(cAlias+"->G1_COMP"), &(cAlias+"->G1_QUANT"), limpBras( &(cAlias+"->G1_COMP") ) } )
  endIf
  &(cAlias+"->( DbSkip() )" )
EndDo

&(cAlias+"->( DbCloseArea() )" )
restArea( aArea )

Return iif( len(aArr) > 0, aArr, nTotal)