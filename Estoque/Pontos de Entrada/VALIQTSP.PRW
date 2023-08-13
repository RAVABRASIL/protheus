#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'


USER FUNCTION VALIQTSP(nCPQuan)  

nPosloc  := aScan(aHeader,{|x| Alltrim(x[2]) == "CP_LOCAL"})
cArmazem := aCols[n,nPosloc]
nPosProd := aScan(aHeader,{|x| Alltrim(x[2]) == "CP_PRODUTO"})
cProduto := aCols[n,nPosProd]
cResulta := .T.
nB2Qatu  := 0

SB2->(DBSETORDER(1))
IF SB2->(DBSEEK(xFilial("SB2") + cProduto + cArmazem))
	nB2Qatu := SB2->B2_QATU
EndIf

IF (nB2Qatu < nCPQuan)
	cResulta := .F.
	alert("Saldo em Estoque Indisponível")
EndIf

Return(cResulta)