#INCLUDE "rwmake.ch"
#INCLUDE "topconn.CH"
#INCLUDE "PROTHEUS.CH"
#include "PRTOPDEF.CH"

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���  Autor  � Gustavo Costa                            � Data � 25/05/12 ���
������������������������������������������������������������������������Ŀ��
���Descricao� Ponto de entrada utilizado para realizar um procedimento   ���
���         � de execu��o complementar ap�s a confirma��o de "Inclus�o,  ���
���         � Classifica��o ou exclus�o" de um Documento de Entrada.     ���
������������������������������������������������������������������������Ĵ��
���Localiza��o:           Function A103NFiscal - Programa de inclus�o,   ���
���			altera��o, exclus�o e visualiza��o de Nota Fiscal de Entrada.���
�������������������������������������������������������������������������ٱ�
���Finalidade:  Alterar o status do guia de confer�ncia relacionado ao   ���
���			    pedido de compra dessa nota fiscal.                      ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

User Function MT100AG

Local cCodMoti 	:= ""
Local cMotivo  	:= ""
Local nOpcao   	:= 0
Local aCompra  	:= {}										//Array com os dados das compras
Local nElem    	:= 0											//Indexado ro aCompra
Local cFlag		:= ""

Local nPosPC   := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_PEDIDO' })					//Posicao Pedido no acols
Local nPosItem := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_ITEMPC' })					//Posicao item pedido no acols
Local nPosProd := aScan(aHeader,{|x| AllTrim(x[2]) == 'D1_COD'    })					//Posicao produto no acols
Local nPosCont := ascan(aheader,{|x| Alltrim(x[2]) == 'D1_XCONTAG'})					//Posicao do numero da contagem

If Inclui .OR. !Altera
	
	If !(SF1->F1_TIPO $ "D/C")
		
		//Varre aCols, alterando a informa��o do status da guia de referencia.
		For nCont := 1 to Len(aCols)
			
			//Ignora os deletados
			If aCols[nCont][Len(aHeader)+1]
				Loop
			EndIf
			
			//----------------------------------------
			//Localiza, no array, pela ocorrencia de
			//Pedido+Produto+Item
			//----------------------------------------
			
			nElem := aScan(aCompra,{ |x| x[1] == aCols[nCont][nPosPC] })
			
			If Empty(nElem)
				
				aADD(aCompra,{	aCols[nCont][nPosPC],;				//01-Pedido de Compra
								cA100For,;							//02-Fornecedor
								cLoja,;								//03-Loja
				                aCols[nCont][nPosCont]})			//04-Codigo da contagem
				                
				nElem := Len(aCompra)
			EndIf
			If Inclui
				cFlag := "X"
			Else
				cFlag := " "
			EndIf
			//Atualiza o status de todos os pedidos de compra dentro da NFE.
			atuGConf(aCompra,cFlag)
		Next nCont
		
	Endif
Endif

Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � atuGConf  �Autor  �Gustavo Costa      � Data �  25/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza o status do guia de conferencia da NFE.           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function atuGConf(aChv, cFlg)

Local aChaves := aChv
Local nCont
Local cQuery

For nCont := 1 to Len(aChaves)
	
	cQuery := " UPDATE " + RetSqlName("ZAA")
	cQuery += " SET ZAA_STATUS = '" + cFlg + "' "
	cQuery += " WHERE ZAA_FILIAL = '" + xFilial("ZAA") + "' "
	cQuery += " AND	ZAA_PEDCOM = '" + aChaves[nCont][1] + "' "
	cQuery += " AND ZAA_FORNEC = '" + aChaves[nCont][2] + "' "
	cQuery += " AND ZAA_LOJA = '" + aChaves[nCont][3] + "' "
	cQuery += " AND ZAA_DOC = '" + aChaves[nCont][4] + "' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	TcSqlExec(cQuery)
Next

Return

