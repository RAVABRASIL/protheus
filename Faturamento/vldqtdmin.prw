#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

// gatilho com chamada de execblock para validar a quantidade minima no pedido de vendas

User Function vldqtdmin()

Local nPosPrd := aCols[n,aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO" } )]
Local nPosQtdP	:= aCols[n,aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_QTDVEN" } )]

dbSelectArea("SB1")
dbSeek(xFilial()+nPosPrd)
lret := nPosqtdP
If lRet < SB1->B1__QTVDMI
		msgAlert("Quantidade menor que o minimo para este produto")
		lret := 0
Endif
Return (lret)