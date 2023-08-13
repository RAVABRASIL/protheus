#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  CARTEIRA ³ Autor ³   Esmerino Neto     ³ Data ³ 07/12/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DescriCAo ³ Carteira de produtos para uso no Excel                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Rava                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ESTCARXLS(cCdPr)

	Local cCarteira := 0
	Local cCodProduto := cCdPr
	Local cLetra
	Local cQuery
	Local aSTRUT
	Local cARQ
	Local cPROD
	Local lSai

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DESENVOLVIMENTO DO PROGRAMA          						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cLetra := Alltrim(Substr(cCodProduto,1,1))

	cQuery := "SELECT SUM( SC6.C6_QTDVEN - SC6.C6_QTDENT ) AS CARTEIRA, SC6.C6_PRODUTO "
	cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" ) + " SC6 "
	cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
	cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_PRODUTO LIKE '" + cLetra + "%' AND "
	cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
	cQuery += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
	cQuery += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY SC6.C6_PRODUTO"
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SC6X"
	TCSetField( 'SC6X', "CARTEIRA", "N" , 9, 2 )

	aSTRUT := {}

	aadd( aSTRUT, { "PRODUTO",   "C", 15, 0 } )
	aadd( aSTRUT, { "CARTEIRA", "N", 09, 2 } )
	//MemoWrit( "CARTEIRA.SQL", cQuery )  // <--- Essa funcao cria um arquivo no Sigaadv com o conteudo da variavel
	cARQ := CriaTrab( aSTRUT, .T. )
	Use ( cARQ ) Alias TMP New Exclusive
	Index On PRODUTO To ( cARQ )

	SC6X->( DbGotop() )
	Do While ! SC6X->( Eof() )
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
	 			TMP->PRODUTO  := cPROD
	 			TMP->CARTEIRA := SC6X->CARTEIRA
		 Else
	 			TMP->CARTEIRA += SC6X->CARTEIRA
		 EndIf
		 SC6X->( DbSkip() )
	EndDo

	lSai := .T.
	TMP->( DBGoTop() )
	TMP->( Dbseek( PRODUTO ) )
	Do While ! TMP->( Eof() ) .and. lSai
		If Alltrim(TMP->PRODUTO) == cCodProduto
			cCarteira := TMP->CARTEIRA
			lSai := .F.
		EndIf
		TMP->( Dbskip() )
	EndDo

	TMP->( DbCloseArea() )
	SC6X->( DbCloseArea() )
	MS_FLUSH()

Return cCarteira