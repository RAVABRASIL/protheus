#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINFRE     º Autor ³ Esmerino Neto     º Data ³  28/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna as informacoes de frete de NF de entrada informada.º±±
±±º          ³Podendo ser consultada por Conhecimento ou NF de Entrada.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro/Faturamento                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/



********************
User Function InfoFrete( cCodigo, cSerie, nOP )
********************

	Local cQuery
	Public aInfoFre := {}

	cQuery := "SELECT 	SF8.F8_NFDIFRE, SF8.F8_SEDIFRE, SF8.F8_NFORIG, SF8.F8_SERORIG, SA2.A2_COD, SA2.A2_NOME, SD1.D1_COD, "
	cQuery += "SB1.B1_DESC, SD1.D1_TOTAL, SF8.F8_TRANSP, SF8.F8_LOJTRAN "
	cQuery += "FROM " + RetSqlName('SF8') + " SF8, " + RetSqlName('SD1') + " SD1, " + RetSqlName('SA2') + " SA2, " + RetSqlName('SB1') + " SB1 "
	cQuery += "WHERE SF8.F8_NFDIFRE = SD1.D1_DOC AND SF8.F8_SEDIFRE = SD1.D1_SERIE "
	cQuery += "AND SF8.F8_FORNECE = SA2.A2_COD AND SF8.F8_LOJA = SF8.F8_LOJA "
	cQuery += "AND SD1.D1_COD = SB1.B1_COD AND SD1.D1_LOCAL = SB1.B1_LOCPAD "
	If nOp == 1      //busca por NF de Conhedimento
		cQuery += "AND SF8.F8_NFDIFRE = '" + cCodigo + "' AND SF8.F8_SEDIFRE = '" + cSerie + "' "
	ElseIf nOp == 2  //busca por NF de Entrada
		cQuery += "AND SF8.F8_NFORIG  = '" + cCodigo + "' AND SF8.F8_SERORIG = '" + cSerie + "' "
	EndIf
	cQuery += "AND SF8.F8_FILIAL = '" + xFilial( "SF8" ) + "' AND SF8.D_E_L_E_T_ = ' ' "
	cQuery += "AND SD1.D1_FILIAL = '" + xFilial( "SD1" ) + "' AND SD1.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SF8X"

	SF8X->( DbGoTop() )
		While ! SF8X->( EoF() )
			cAnAlias := Alias()
			DbSelectArea( "SA2" )
			DbSetOrder( 1 )
			DbSeek( xFilial() + SF8X->F8_TRANSP + SF8X->F8_LOJTRAN, .T. )
			cNTrans := SA2->A2_NOME
			DbSelectArea( "SD1" )
			DbSetOrder( 2 )
			DbSeek( xFilial() + SF8X->D1_COD + SF8X->F8_NFORIG + SF8X->F8_SERORIG, .T. )
			aAdd( aInfoFre,  {SF8X->F8_NFDIFRE,; // 1-NF de Frete
												SF8X->F8_SEDIFRE,; // 2-Serie de Frete
												SF8X->F8_TRANSP, ; // 3-Codigo do Fornecedor do Frete
												cNTrans,				 ; // 4-Nome do Fornecedor do Frete
												SF8X->D1_COD,		 ; // 5-Codigo do Produto
												SF8X->B1_DESC,	 ; // 6-Descricao do Produto
												SF8X->D1_TOTAL,	 ; // 7-Preco do Frete do Produto
												SF8X->F8_NFORIG, ; // 8-Codigo da NF original
												SF8X->F8_SERORIG,; // 9-Serie da NF original
												SF8X->A2_COD,		 ; //10-Codigo do Cliente da NF original
												SF8X->A2_NOME,	 ; //11-Nome do Cliente da NF original
												SD1->D1_TOTAL,   ; //12-Valor do Produto da NF original
												SD1->D1_COD } )		 //13-Codigo do Produto da NF original
			DbSelectArea( cAnAlias )
			SF8X->( DbSkip() )
		EndDo
  SF8X->( DbCloseArea() )
Return aInfoFre
