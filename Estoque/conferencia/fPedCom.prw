/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fPedCom     ° Autor ³ Gustavo Costa     º Data ³  16/07/08 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função utilizada para exibir preparar em um array todos os º±±
±±º          ³ pedidos de compra.                    					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cEmpresa		-> Código da Empresa						  °±±
±±º          ³ cFil				-> Código da Filial						  º±±
±±º          ³ cProduto		-> Código do Produto						  º±±
±±º          ³ nQuant			-> Quantidade a ser vendida				  º±±
±±º          ³ cLote			-> Lote do Produto						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function fPedCom(cFor, cLj, cProd)

Local cQuery
Local cString	:= "PDC"
Local nSaldo
Local aArea	:= getArea()
Local aCampos := {}								//Array para criacao de arq. temporario
Local cIndex  										//Alias arquivo temporario

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define estrutura do arquivo de trabalho sobre o qual atuara³
//³o MarkBrowse.                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aADD(aCampos,{"OK"  			,"C",02,0})
aADD(aCampos,{"DT"	 			,"D",08,0})
aADD(aCampos,{"NUM" 			,"C",09,0})
aADD(aCampos,{"ITEM"			,"C",04,0})
aADD(aCampos,{"PRODUTO"			,"C",08,0})
aADD(aCampos,{"DESCRICAO"		,"C",50,0})
aADD(aCampos,{"QUANT"			,"C",07,0})
//aADD(aCampos,{"PRECO"			,"C",10,0})
//aADD(aCampos,{"TOTAL"			,"C",13,0})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria arquivo de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

cIndex := CriaTrab(aCampos,.T.)
dbUseArea( .T.,, cIndex, "TMP", if(.F. .OR. .F., !.F., NIL), .F. )

// Prepara a Query

cQuery	:= "SELECT C7_NUM, C7_FORNECE, C7_LOJA, C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_QUJE, C7_PRECO, C7_TOTAL, C7_EMISSAO "
cQuery	+= "FROM " + RetSqlName("SC7") + " AS C7 "
cQuery	+= "WHERE C7.D_E_L_E_T_ <> '*' "
cQuery	+= "AND		C7_FILIAL = '" + xFilial("SC7") + "' "
cQuery	+= "AND		C7_PRODUTO = '" + cProd + "' "
cQuery	+= "AND		C7_FORNECE = '" + cFor + "' "
cQuery	+= "AND		C7_LOJA = '" + cLj + "' "
cQuery  += "AND		C7_QUANT - C7_QUJE > 0 "

// Prepara e executa a query
cQuery := ChangeQuery(cQuery)

If Select(cstring) > 0
	(cstring)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cString, .F., .T.)
Count to nQtdReg

// Se encontrou algum registro
If (nQtdReg <= 0)
	ApMsgAlert ("Não há Pedido de Compra.")
	Return
EndIf

PDC->(dbGoTop())
nQtdProd := 0

While PDC->(!EOF())
	
		nQtdProd++
		
		nSaldo	:= (cString)->C7_QUANT - (cString)->C7_QUJE
		
		RecLock('TMP',.T.)
		
		TMP->DT				:= StoD((cString)->C7_EMISSAO)
		TMP->NUM			:= (cString)->C7_NUM
		TMP->ITEM			:= (cString)->C7_ITEM
		TMP->PRODUTO		:= cProd
		TMP->DESCRICAO		:= Substr(POSICIONE ("SB1", 1, xFilial("SB1") + cProd, "B1_DESC"),1,50)
		TMP->QUANT			:= PADL(ALLTRIM(Transform(nSaldo, "@E 999,999")),7)

//		TMP->PRECO	:= PADL(ALLTRIM(Transform((cString)->C7_PRECO, "@E 999,999.99")),10)
//		TMP->TOTAL	:= PADL(ALLTRIM(Transform((cString)->C7_TOTAL, "@E 99,999,999.99")),13)
		
		TMP->(MsUnLock())

	PDC->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

// Se existir algum pedido, mostra tela.
If (nQtdProd > 0)
	aPDC := U_TelaPC ("TMP")
	
	aCols[n,ascan(aheader,{|x|upper(alltrim(x[2]))=="D1_PEDIDO"})] := aPDC[1][2]
	aCols[n,ascan(aheader,{|x|upper(alltrim(x[2]))=="D1_ITEMPC"})] := aPDC[1][3]
	
Else
	ApMsgAlert ("Não há Pedido de Compra em aberto para esse produto.")
	Return .F.
EndIf

TMP->(dbCloseArea())    

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TelaPC  ° Autor ³ Gustavo Costa         º Data ³  28/02/08 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função utilizada para exibir uma tela com os pedidos       º±±
±±º          ³ de compra em aberto.		    							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cArquivo		-> Arquivo de Trabalho	        			  °±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TelaPC (cArquivo)

Local cMarca  := GetMark()				//Flag para marcacao
Local aCampos := {}								//Array para criacao de arq. temporario
Local oMark												//Objeto MarkBrowse
Local oDlg 												//Objeto Dialogo
Local lOk     := .F.							//Retorno da janela de dialogo
Local nElem   := 0								//Localizador de arrays
Local lInvert := .F.

Local cQuant	:= ""
Local cPreco	:= ""
Local cNum		:= ""
Local cTotal	:= ""
Local cItem		:= ""

Local aRetorno:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Redefine o array aCampos com a estrutura do MarkBrowse³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"OK"  			,"",""         	,""  	})					//Flag marcacao
AADD(aCampos,{"DT" 				,"","Data"  	,""  	})					//Data PDCessa
AADD(aCampos,{"NUM" 			,"","Num"		,""  	})					//Documento
AADD(aCampos,{"ITEM"			,"","Item" 		,""		})					//Item
AADD(aCampos,{"PRODUTO"			,"","Produto" 	,""		})					//Código do Produto
AADD(aCampos,{"DESCRICAO"		,"","Descricao"	,"@!"	})					//Descricao do Produto
AADD(aCampos,{"QUANT"			,"","Saldo" 	,""		})					//Quantidade
//AADD(aCampos,{"PRECO"			,"","Preço" 	,""		})					//Preço de Venda
//AADD(aCampos,{"TOTAL"			,"","Total" 	,""		})					//Total

DEFINE MSDIALOG oDlg TITLE 'Pedido de Compra' FROM 9,0 To 28,80 OF oMainWnd

oMark:=MsSelect():New(cArquivo,"OK",,aCampos,@lInvert,@cMarca,{02,1,123,316},)
oMark:oBrowse:lCanAllmark := .F.

TMP->(dbGoTop())

DEFINE SBUTTON FROM 126,246.3 TYPE 1 ACTION (lOk := .T.,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 126,274.4 TYPE 2 ACTION oDlg:End()              ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa MarkBrowse colocando verificando qual a PDCessa selecio-	³
//³nada e preenchendo a nota fiscal original, serie e item no pedido	³
//³de vendas.		                                                     	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOk
	TMP->(dbGoTop())
	While TMP->(!Eof()) .And. lOk
		
		If TMP->OK == cMarca
			cQuant 	:= TMP->QUANT
//			cPreco 	:= TMP->PRECO
//			cTotal 	:= TMP->TOTAL
			cNum	:= TMP->NUM
			cItem	:= TMP->ITEM
			lOk := .F.
		EndIf
		
		TMP->(dbSkip())
	EndDo
EndIf

AADD(aRetorno,{cQuant, cNum, cItem})
//AADD(aRetorno,{cQuant,cPreco, cTotal, cNum, cItem})
Return aRetorno
