#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Esmerino Neto                            ³ Data ³ 14/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Calcula a media de preco (frete e impostos) dos produtos.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Estoque/Custos e Faturamento                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CALPREAC(cCodAce, nOpcao, dData)

Local nMedPrec := nTotKg := nTotRS := nTotIPI := nFrete := 0

if dData = nil
   dData := dDataBase
endif   

//	cQuery := "SELECT TOP 4 SD1.D1_EMISSAO, SD1.D1_QUANT, SD1.D1_TOTAL, SD1.D1_VALIPI "
//	cQuery += "FROM " + RetSqlName( "SD1" ) + " SD1 "
//	cQuery += "WHERE SD1.D1_COD = '" + cCodAce + "' AND D1_TES IN ('001', '010', '012', '015', '024', '132') AND SD1.D1_TIPO = 'N' AND SD1.D1_PEDIDO <> ' ' "
//	cQuery += "AND SD1.D1_FILIAL = '" + xFilial( "SD1" ) + "' AND SD1.D_E_L_E_T_ = ' ' "
//	cQuery += "ORDER BY SD1.D1_EMISSAO DESC "
//	cQuery := ChangeQuery( cQuery )
//	TCQUERY cQuery NEW ALIAS "SD1X"

	cQuery := "SELECT TOP 20 SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_EMISSAO, SD1.D1_QUANT, SD1.D1_TOTAL, SD1.D1_VALIPI, D1_TES, D1_PEDIDO "
	cQuery += "FROM " + RetSqlName( "SD1" ) + " SD1 "
	cQuery += "WHERE SD1.D1_COD = '" + cCodAce + "' AND D1_TES IN ('001', '010', '012', '015', '024', '132', '137') AND SD1.D1_TIPO = 'N' "
    cQuery += "AND SD1.D1_DTDIGIT <= '"+DtoS(dData)+ "' " //Inclui para Calcular o Custo Medio dos Acessorios ate uma Data ( Eurivan 12/01/07 )
	cQuery += "AND SD1.D1_FILIAL = '" + xFilial( "SD1" ) + "' AND SD1.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SD1.D1_DTDIGIT DESC " //Alterei esta D1_EMISSAO ( Eurivan 12/01/07 )
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SD1X"

	SD1X->( DbGoTop() )

	nCont := 1
	Do While ! SD1X->( EoF() ) .AND. nCont <= 4
		If SD1X->D1_TES # '/001 /024' .AND. ! Empty( Alltrim( SD1X->D1_PEDIDO ) )
			nTotKg  += SD1X->D1_QUANT
			nTotRS  += SD1X->D1_TOTAL
			nTotIPI += SD1X->D1_VALIPI
			aFrete := U_InfoFrete( SD1X->D1_DOC, SD1X->D1_SERIE, 2 )
			nLinha := aScan( aFrete, { |X| X[5] == cCodAce } )
			If Len( aFrete ) > 0 .AND. nLinha > 0
				nFrete += aFrete[ nLinha, 7 ]
			EndIf
			nCont ++
			SD1X->( DbSkip() )
		ElseIf SD1X->D1_TES $ '/001 /024'
			nTotKg  += SD1X->D1_QUANT
			nTotRS  += SD1X->D1_TOTAL
			nTotIPI += SD1X->D1_VALIPI
			aFrete := U_InfoFrete( SD1X->D1_DOC, SD1X->D1_SERIE, 2 )
			nLinha := aScan( aFrete, { |X| X[5] == cCodAce } )
			If Len( aFrete ) > 0 .AND. nLinha > 0
				nFrete += aFrete[ nLinha, 7 ]
			EndIf
			nCont ++
			SD1X->( DbSkip() )
		Else
			SD1X->( DbSkip() )
		EndIf
	EndDo

	SD1X->( DbCloseArea() )

	If nOpcao == 1
		nMedPrec := ( nTotRS + nFrete ) / nTotKg
	ElseIf nOpcao == 2
		nMedPrec := ( nTotRS + nFrete + nTotIPI ) / nTotKg  //adiciona IPI no valor da media
	EndIf

Return nMedPrec
