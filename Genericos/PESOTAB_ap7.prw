#include "rwmake.ch"

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���  Autor  � Esmerino Neto                            � Data � 25/09/06 ���
������������������������������������������������������������������������Ŀ��
���Descricao� Calcula o peso do produto pela multiplicacao do Comprimento���
���         � Externo, Espessura Externa e Largura Externa conforme      ���
���         � encontrado no cadastro do Produto.                         ���
������������������������������������������������������������������������Ĵ��
���   Uso   � Formacao de Precos - Custo/Estoque                         ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/


****************
User Function PESOTAB(nOp)
****************
	If nOp == 1  // Calculo do peso pelas medidas externas do produto
		cAlias := Alias()
		DBSelectArea( 'SB5' )
		SB5->( DBSetOrder(1) )
		SB5->( DBSeek( xFilial( 'SB1' ) + SB1->B1_COD, .T. ) )
		nPeso := Round( SB5->B5_COMPR2 * SB5->B5_LARG2 * SB5->B5_ESPESS2, 2 )
		SB5->( DBCloseArea() )
		DBSelectArea( cAlias )
	ElseIf nOp == 2  //Calculo do peso pelo campo B1_PESOR, ou seja, peso real do produto
		nPeso := Round( SB1->B1_PESOR, 2 )
	Else
		Alert("A funcao PESOTAB deve ter 1, para peso externo, ou 2, para peso real.")
		nPeso := 0
	EndIf
Return nPeso
