#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTROPS()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetPrvt( "tamanho, titulo, cDesc1, cDesc2, cDesc3, cNatureza, aReturn, nomeprog, cPerg, nLsastKey, lContinua, nLin, wnrel, M_PAG, cString," )
	SetPrvt( "cQuery1, cQuery2, cQuery3, cQuery4, cCabec_01, cCabec_02, aDados, cProd" )

	#IFNDEF WINDOWS
	#ENDIF

	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ESTROPS    º Autor ³ ESMERINO NETO      º Data ³  28/11/05   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Relatório para conferencia das Ordens de Producao geradas eº±±
	±±º          ³ quantidades produzidas dos produtos relacionados.          º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ CUSTO/ESTOQUE                                              º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis Ambientais                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01        	// Da Data ?                               ³
	//³ mv_par02        	// Ate a Data ?                            ³
	//³ mv_par03        	// Da OP ?                                 ³
	//³ mv_par04        	// Ate a OP ?                              ³
	//³ mv_par05        	// Listar OPs Abertas, Encerradas, Todas ? ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	tamanho   := "G"
	titulo    := PADC("Relatorio de Conferencia de OPs" ,40)
	cDesc1    := PADC("Este relatório mostrara as OPs que estao em",74)
	cDesc2    := PADC(" execucao para conferencia.", 74)
	cDesc3    := PADC(" ",74)
	cNatureza := ""
	aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
	nomeprog  := "ESTROPS"
	cPerg     := "ESTROP"
	nLastKey  := 0
	lContinua := .T.
	nLin      := 9
	wnrel     := "ESTROPS"
	M_PAG     := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte( cPerg, .T. )               // Pergunta no SX1

	If mv_par05 = 1
		titulo := titulo + "Encerradas entre " + DtoC(mv_par01) + "  ate " + DtoC(mv_par02)
	ElseIf mv_par05 = 2
		titulo := titulo + "Em Aberto entre " + DtoC(mv_par01) + "  ate " + DtoC(mv_par02)
	ElseIf mv_par05 = 3
		titulo := titulo + "Emcerradas e em Aberto entre entre " + DtoC(mv_par01) + "  ate " + DtoC(mv_par02)
	EndIf

	cString := "SC2"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

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
		Static Function RptDetail()
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DESENVOLVIMENTO DO PROGRAMA          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery1 := "SELECT SC2.C2_NUM, SC2.C2_SEQUEN, SC2.C2_PRODUTO, SC2.C2_QUANT, SC2.C2_QTSEGUM, SC2.C2_EMISSAO, SC2.C2_QUJE AS SALDO, SC2.C2_PERDA AS APARA, SC2.C2_RECURSO AS MAQ "
	cQuery1 += "FROM " + RetSqlName( "SC2" ) + " SC2 "
	cQuery1 += "WHERE SC2.C2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
	cQuery1 += "AND SC2.C2_QUJE >= 0 AND SC2.C2_PRODUTO NOT LIKE 'ME%' AND SC2.C2_PRODUTO NOT LIKE 'PI%' AND SC2.C2_NUM BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	If mv_par05 = 2
		cQuery1 += "AND SC2.C2_DATRF = ' ' "
	ElseIf mv_par05 = 1
		cQuery1 += "AND SC2.C2_DATRF <> ' ' "
	EndIf
	cQuery1 += "AND SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' "
	cQuery1 += "ORDER BY SC2.C2_EMISSAO "
	cQuery1 += ChangeQuery( cQuery1 )
	TCQUERY cQuery1 NEW ALIAS "SOP1"
	TCSetField( 'SOP1', "SC2.C2_EMISSAO", "D" )
	TCSetField( 'SOP1', "SC2.C2_QUANT", "N", 5, 2 )
	TCSetField( 'SOP1', "SC2.C2_QTSEGUM", "N", 5, 2 )
	TCSetField( 'SOP1', "SALDO", "N", 5, 2 )
	TCSetField( 'SOP1', "APARA", "N", 3, 2 )

	/*
	cQuery1 := "SC2.C2_NUM, SC2.C2_SEQUEN, SC2.C2_PRODUTO, SC2.C2_QUANT, SC2.C2_QTSEGUM, SC2.C2_EMISSAO, SC2.C2_QUJE AS SALDO, SC2.C2_PERDA AS APARA, SC2.C2_RECURSO AS MAQ "
	cQuery1 += "FROM " + RetSqlName( "SC2" ) + " SC2, " + RetSqlName( "SD3" ) + " SD3 "
	cQuery1 += "WHERE SC2.C2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
	cQuery1 += "AND SC2.C2_NUM BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cQuery1 += "AND SC2.C2_NUM = SUBSTRING(SD3.D3_OP, 1, 6) AND SC2.C2_PRODUTO = SD3.D3_COD "
	cQuery1 += "AND SC2.C2_SEQUEN = '001' AND SC2.C2_QUJE >= 0 AND SD3.D3_QUANT = 0 "
	cQuery1 += "AND SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' "
	cQuery1 += "AND SD3.D3_FILIAL = '" + xFilial( "SD3" ) + "' AND SD3.D_E_L_E_T_ = ' ' "
	cQuery1 += ChangeQuery( cQuery1 )
	TCQUERY cQuery1 NEW ALIAS "SOP1"
	TCSetField( 'SOP1', "SC2.C2_EMISSAO", "D" )
	TCSetField( 'SOP1', "SC2.C2_QUANT", "N", 5, 2 )
	TCSetField( 'SOP1', "SC2.C2_QTSEGUM", "N", 5, 2 )
	TCSetField( 'SOP1', "SALDO", "N", 5, 2 )
	TCSetField( 'SOP1', "APARA", "N", 3, 2 )
	*/

	aDados := {}
	//cMSG := Nil
	SOP1->( DBGoTop() )

	Do While ! SOP1->( EOF() )
		If ! Substr(SOP1->C2_PRODUTO, 1, 2) $ 'ME /PI'
			cCodProd := Alltrim(SOP1->C2_PRODUTO)
			cQuery4 := "SELECT SG1.G1_COD, SG1.G1_COMP "
			cQuery4 += "FROM " + RetSqlName( "SG1" ) + " SG1 "
			cQuery4 += "WHERE SG1.G1_COD = '" + cCodProd + "' "
			cQuery4 += "AND SG1.G1_COMP LIKE 'PI%' "
			cQuery4 += "AND SG1.G1_FILIAL = '" + xFilial( "SG1" ) + "' AND SG1.D_E_L_E_T_ = ' ' "
			cQuery4 += ChangeQuery( cQuery4 )
			TCQUERY cQuery4 NEW ALIAS "SOP4"
			SOP4->( DBGoTop() )
			cCodOP := SOP1->C2_NUM
			dEmisaoOP := SOP1->C2_EMISSAO
			nSaldoOP := SOP1->C2_QUANT - SOP1->SALDO
			cCodBub := SOP4->G1_COMP

			cQuery6 := "SELECT SUBSTRING(SD3.D3_OP, 1, 6) AS COD_OP, SD3.D3_QUANT, SD3.D3_PERDA "
			cQuery6 += "FROM " + RetSqlName( "SD3" ) + " SD3 "
			cQuery6 += "WHERE SD3.D3_COD = '" + Alltrim(cCodBub) + "' AND SD3.D3_CF LIKE 'PR%' AND SD3.D3_OP LIKE '" + Alltrim(cCodOP) + "%' "
			cQuery6 += "AND SD3.D3_ESTORNO = ' ' "
			cQuery6 += "AND SD3.D3_FILIAL = '" + xFilial( "SD3" ) + "' AND SD3.D_E_L_E_T_ = ' ' "
			cQuery6 += ChangeQuery( cQuery6 )
			TCQUERY cQuery6 NEW ALIAS "SOP6"
			TCSetField( 'SOP6', "D3_QUANT", "N", 5, 2 )
			TCSetField( 'SOP6', "D3_PERDA", "N", 5, 2 )
			SOP6->( DBGoTop() )
			If ! SOP6->( EOF() )
				nProdBub := SOP6->D3_QUANT
				nAPARABub := SOP6->D3_PERDA
				cMSG := Nil
			Else
				nProdBub := 0
				nAPARABub := 0
				cMSG := "FALTA INSERIR"
			EndIf

			cQuery2 := "SELECT SUM(Z00.Z00_PESO + Z00.Z00_PESCAP) AS QTD_KG, (SUM(Z00.Z00_QUANT)/1000) AS QTD_ML "
			cQuery2 += "FROM " + RetSqlName( "Z00" ) + " Z00 "
			cQuery2 += "WHERE Z00.Z00_QUANT > 0 AND SUBSTRING(Z00.Z00_OP, 1, 6) BETWEEN '" + cCodOP + "' AND '" + cCodOP + "' AND Z00.Z00_BAIXA = 'N'"
			cQuery2 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
			cQuery2 += ChangeQuery( cQuery2 )
			TCQUERY cQuery2 NEW ALIAS "SOP2"
			TCSetField( 'SOP2', "QTD_KG", "N", 5, 2 )
			TCSetField( 'SOP2', "QTD_ML", "N", 5, 2 )

			cQuery8 := "SELECT SB1.B1_COD, SB1.B1_CONV "
			cQuery8 += "FROM " + RetSqlName( "SB1" ) + " SB1 "
			cQuery8 += "WHERE SB1.B1_COD = '" + cCodProd + "' "
			cQuery8 += ChangeQuery( cQuery8 )
			TCQUERY cQuery8 NEW ALIAS "SOP8"

			SOP2->( DBGoTop() )
			SOP8->( DBGoTop() )
			If SOP2->QTD_KG + SOP2->QTD_ML <= 0
				nQtdPrKG := 0
				nQtdPrML := 0
			Else
				nQtdPrKG := SOP2->QTD_KG
				nQtdPrML := SOP2->QTD_ML
			EndIf

			cQuery7 := "SELECT SUM(Z00.Z00_PESO + Z00.Z00_PESCAP) AS QTD_PR_KG, (SUM(Z00.Z00_QUANT)/1000) AS QTD_PR_ML "
			cQuery7 += "FROM " + RetSqlName( "Z00" ) + " Z00 "
			cQuery7 += "WHERE Z00.Z00_QUANT > 0 AND SUBSTRING(Z00.Z00_OP, 1, 6) BETWEEN '" + cCodOP + "' AND '" + cCodOP + "' AND Z00.Z00_BAIXA = 'S'"
			cQuery7 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
			cQuery7 += ChangeQuery( cQuery2 )
			TCQUERY cQuery7 NEW ALIAS "SOP7"
			TCSetField( 'SOP7', "QTD_PR_KG", "N", 5, 2 )
			TCSetField( 'SOP7', "QTD_PR_ML", "N", 5, 2 )

			SOP7->( DBGoTop() )
			nQtdEsPrKG := SOP7->QTD_PR_KG
			nQtdEsPrML := SOP7->QTD_PR_ML

			cQuery3 := "SELECT SUM(Z00.Z00_PESO) AS APARA "
			cQuery3 += "FROM " + RetSqlName( "Z00" ) + " Z00 "
			cQuery3 += "WHERE Z00.Z00_QUANT = 0 AND SUBSTRING(Z00.Z00_OP, 1, 6) BETWEEN '" + cCodOP + "' AND '" + cCodOP + "' "
			cQuery3 += "AND Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
			cQuery3 += ChangeQuery( cQuery3 )
			TCQUERY cQuery3 NEW ALIAS "SOP3"
			TCSetField( 'SOP3', "APARA", "N", 5, 2 )

			SOP3->( DBGoTop() )
			nQtAPARA := SOP3->APARA
			nTotProd := nQtdPrKG + nQtdEsPrKG + nQtAPARA

			nProgKG := SOP1->C2_QTSEGUM
			nProgML := SOP1->C2_QUANT
			cMAQ := SOP1->MAQ

			cQuery5 := "SELECT (SB1.B1_PESO * SB2.B2_QATU) AS KG, SB2.B2_QATU AS ML "
			cQuery5 += "FROM SB1010 SB1, SB2020 SB2 "
			cQuery5 += "WHERE SB2.B2_COD = '" + Alltrim(cCodProd) + "' "
			cQuery5 += "AND SB1.B1_COD = SB2.B2_COD "
			cQuery5 += ChangeQuery( cQuery5 )
			TCQUERY cQuery5 NEW ALIAS "SOP5"
			SOP5->( DBGoTop() )
			nEstoqueKG := SOP5->KG
			nEstoqueML := SOP5->ML

			SOP2->( DbCloseArea() )
			SOP3->( DbCloseArea() )
			SOP4->( DbCloseArea() )
			SOP5->( DbCloseArea() )
			SOP6->( DbCloseArea() )
			SOP7->( DbCloseArea() )
			SOP8->( DbCloseArea() )

			Aadd( aDados, { cCodOP, dEmisaoOP, nSaldoOP, cCodBub, cMSG, nProdBub, nAPARABub, nProgKG, nProgML, cMAQ, cCodProd, nQtdPrKG, nQtdPrML, nQtdEsPrKG, nQtdEsPrML, nQtAPARA, nTotProd, nEstoqueKG, nEstoqueML } )

		/*
		ElseIf SOP1->C2_PRODUTO == cCodBub
			nPrdBub := SOP1->C2_QUANT
			nProBub := SOP1->SALDO
			nApara  := SOP1->APARA
		*/
		EndIf

		SOP1->( dbskip() )

	EndDo

	/*----------------------------------------------------------------
	  LAYOUT DA IMPRESSAO DO RELATORIO
	  ----------------------------------------------------------------*/
	cCabec_01 := "|----Ordem de Producao---||----Bubina Produzida----||--Producao Programada--||-----------------Producao Atual sem Saco-Capa-------------------||----Est. Atual----|"
	cCabec_02 := " Numero   Emissao   Saldo  Codigo  Produzido  APARA     KG      ML/FD    MAQ  Codigo   |--Fora da Exped-||---Na Expedicao---|  APARA  Total da      KG      ML/FD"
	cCabec_03 := "                    ML/FD                                                     Produto      KG     ML/FD      KG      ML/FD     em KG  Producao"
	//           " 999999  99/99/99  999,99  9999999  9.999,99 999,99  9.999,99  9.999,99  XXX  9999999   9.999,99  999,99  9.999,99  9.999,99  999,99  9.999,99   9.999,99  9.999,99
	//            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	//            0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16

	nLin := Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
	@ Prow() + 1,000 PSay cCabec_01
	@ Prow() + 1,000 PSay cCabec_02
	@ Prow() + 1,000 PSay cCabec_03
	//@ Prow() + 1,000 PSay "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012"
	@ Prow() + 1,000 pSay Repl( '*', 163 )

	For X := 1 To Len(aDados)

		If aDados[X,5] == Nil
			@ Prow() + 1,001 PSay Alltrim(aDados[X,1]) //---------------------Numero da OP
			@ Prow()    ,009 PSay StoD(aDados[X,2]) //------------------------Data da Emissao
			@ Prow()	  ,019 PSay Round(aDados[X,3], 2) Picture "@E 999.99" //-Saldo atual da OP
			@ Prow()    ,027 PSay Alltrim(aDados[X,4]) //---------------------Codigo da Bubina
			@ Prow()    ,036 PSay Round(aDados[X,6], 2) Picture "@E 9,999.99" //----------Qtd da Bubina Produzida
			@ Prow()    ,045 PSay Round(aDados[X,7], 2) Picture "@E 999.99" //--------Qtd de Apara produzida pela Bubina
			@ Prow()    ,053 PSay Round(aDados[X,8], 2) Picture "@E 9,999.99" //--------Producao Programada em KG
			@ Prow()    ,063 PSay Round(aDados[X,9], 2) Picture "@E 9,999.99" //--------Producao Programada em ML
			@ Prow()    ,073 PSay aDados[X,10] //-----------------------------Maquina da Producao
			@ Prow()    ,078 PSay aDados[X,11] //-----------------------------Codigo do Produto a Produzir
			@ Prow()    ,087 PSay Round(aDados[X,12], 2) Picture "@E 9,999.99" //-------Producao fora da Expedicao em KG
			@ Prow()    ,097 PSay Round(aDados[X,13], 2) Picture "@E 999.99" //---------Producao fora da Expedicao em ML
			@ Prow()    ,105 PSay Round(aDados[X,14], 2) Picture "@E 9,999.99" //-------Producao na Expedicao em KG
			@ Prow()    ,115 PSay Round(aDados[X,15], 2) Picture "@E 999.99" //---------Producao na Expedicao em ML
			@ Prow()    ,125 PSay Round(aDados[X,16], 2) Picture "@E 999.99" //-------Apara de Corte em KG
			@ Prow()    ,133 PSay Round(aDados[X,17], 2) Picture "@E 9,999.99" //-------Total da Producao em KG
			@ Prow()    ,144 PSay Round(aDados[X,18], 2) Picture "@E 9,999.99" //-------Estoque atual em KG
			@ Prow()    ,153 PSay Round(aDados[X,19], 2) Picture "@E 9,999.99" //-------Estoque atual em ML
		Else
			@ Prow() + 1,001 PSay Alltrim(aDados[X,1])
			@ Prow()    ,009 PSay StoD(aDados[X,2])
			@ Prow()	  ,019 PSay Round(aDados[X,3], 2) Picture "@E 999.99"
			@ Prow()    ,027 PSay Alltrim(aDados[X,4])
			@ Prow()    ,036 PSay Alltrim(aDados[X,5])
			@ Prow()    ,053 PSay Round(aDados[X,8], 2) Picture "@E 9,999.99"
			@ Prow()    ,063 PSay Round(aDados[X,9], 2) Picture "@E 9,999.99"
			@ Prow()    ,073 PSay aDados[X,10]
			@ Prow()    ,078 PSay aDados[X,11]
			@ Prow()    ,087 PSay Round(aDados[X,12], 2) Picture "@E 9,999.99"
			@ Prow()    ,097 PSay Round(aDados[X,13], 2) Picture "@E 999.99"
			@ Prow()    ,105 PSay Round(aDados[X,14], 2) Picture "@E 9,999.99"
			@ Prow()    ,115 PSay Round(aDados[X,15], 2) Picture "@E 999.99"
			@ Prow()    ,125 PSay Round(aDados[X,16], 2) Picture "@E 999.99"
			@ Prow()    ,133 PSay Round(aDados[X,17], 2) Picture "@E 9,999.99"
			@ Prow()    ,144 PSay Round(aDados[X,18], 2) Picture "@E 9,999.99"
			@ Prow()    ,153 PSay Round(aDados[X,19], 2) Picture "@E 9,999.99"
		EndIf

		If Prow() > 60
			nLin:=Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
			@ Prow() + 1,000 PSay cCabec_01
			@ Prow() + 1,000 PSay cCabec_02
			@ Prow() + 1,000 PSay cCabec_03
			@ Prow() + 1,000 pSay Repl( '*', 163 )
		endIf

	Next

	If aReturn[5] == 1
	   Set Printer To
	   Commit
	   ourspool( wnrel ) //Chamada do Spool de Impressao
	Endif

	SOP1->( DbCloseArea() )
	MS_FLUSH()

Return Nil
