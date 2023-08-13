#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

User Function CARTEIRA( dData1, dData2 )

	SetPrvt("CQUERY,CPROD,CCODPROD")

	cQuery := "SELECT  SC6.C6_ENTREG AS EMISSAO, SC6.C6_NUM AS PEDIDO, SC6.C6_CLI AS COD_CLI, SA1.A1_NOME AS CLIENTE, "
	cQuery += 			  "SC6.C6_PRODUTO AS PRODUTO, SC6.C6_ITEM AS ITEM_PEDIDO, "
	cQuery += 	 			"((SC6.C6_QTDVEN - SC6.C6_QTDENT2) / SB1.B1_CONV) AS CARTEIRA_KG, "
	cQuery += 			  "((SC6.C6_QTDVEN - SC6.C6_QTDENT2) * SC6.C6_PRUNIT) AS CARTEIRA_RS "
	cQuery += "FROM   " + RetSqlName('SC6') + " SC6, " + RetSqlName('SB1') + " SB1, " + RetSqlName('SA1') + " SA1 "
	cQuery += "WHERE   SC6.C6_PRODUTO = SB1.B1_COD AND SC6.C6_LOCAL = SB1.B1_LOCPAD "
	cQuery += 			  "AND SC6.C6_CLI = SA1.A1_COD AND SC6.C6_LOJA = SA1.A1_LOJA "
	cQuery += 			  "AND (((SC6.C6_QTDVEN - SC6.C6_QTDENT2) > 0 AND SC6.C6_NOTA = ' ') OR (SC6.C6_QTDVEN - SC6.C6_QTDENT) > 0) "
	cQuery += 			  "AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' "
	cQuery +=					"AND SC6.C6_ENTREG BETWEEN '" + DtoS( dData1 ) + "' AND '" + DtoS( dData2 ) + "' "
	cQuery += 			  "AND SC6.C6_FILIAL = " + xFilial() + " AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += 			  "AND SB1.B1_FILIAL = " + xFilial() + " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += 			  "AND SA1.A1_FILIAL = " + xFilial() + " AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SC6.C6_ENTREG, SC6.C6_NUM, SC6.C6_ITEM "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "CARX"

	CARX->( GotoTop() )

	Do While !CARX->( EoF() )

		If Len( Alltrim( CARX->PRODUTO ) ) <= 7
  		cCodProd := CARX->PRODUTO
		Else
   		If Subs( CARX->PRODUTO, 5, 1 ) == "R"
	  		cCodProd := Padr( Subs( CARX->PRODUTO, 1, 1 ) + Subs( CARX->PRODUTO, 3, 4 ) + Subs( CARX->PRODUTO, 8, 2 ), 15 )
		  Else
				cCodProd := Padr( Subs( CARX->PRODUTO, 1, 1 ) + Subs( CARX->PRODUTO, 3, 3 ) + Subs( CARX->PRODUTO, 7, 2 ), 15 )
			EndIf
		EndIf

		CARX->( DbSkip() )
	EndDo

	CARX->( DbCloseArea() )

Return aResult
