#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �FindGConf � Autor � Gustavo Costa      � Data �  24/05/12   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao para retornar um array com as informa��es da conta- ���
���          � gem de um produto, cadastrada no guia de conferencia.      ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FindGConf(cProd, cFor, cLj, cPedC, cIPC, cNumCont)

Local cQuery	:= ""
Local cProduto	:= cProd
Local cFornece  := cFor
Local cLoja     := cLj
Local cPedCom   := cPedC
Local cItemPC   := cIPC
Local cDoc   	:= cNumCont
Local cString	:= "TMP"
Local aRet		:= {}

cQuery := " SELECT * FROM " + RetSqlName("ZAB") 
cQuery += " WHERE ZAB_FILIAL = '" + xFilial("ZAB") + "' "
cQuery += " AND ZAB_COD = '" + cProduto + "' "
cQuery += " AND ZAB_FORNEC = '" + cFornece + "' "
cQuery += " AND ZAB_DOC = '" + cDoc + "' "
cQuery += " AND ZAB_PEDIDO = '" + cPedCom + "' "
cQuery += " AND ZAB_ITEMPC = '" + cItemPC + "' "
cQuery += " AND D_E_L_E_T_ <> '*' "   
cQuery += " ORDER BY ZAB_COD, ZAB_SEQ DESC "

If Select(cString) > 0
	(cString)->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS &cString

(cString)->(DBGOTOP())
               
AADD( aRet, { (cString)->ZAB_COD, (cString)->ZAB_QUANT, (cString)->ZAB_DOC })                

(cString)->(dbCloseArea())
                    
Return aRet