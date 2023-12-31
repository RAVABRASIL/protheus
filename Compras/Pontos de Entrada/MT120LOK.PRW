#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT120LOK � Autor � Fl�via Rocha       � Data �  04/06/13   ���
�������������������������������������������������������������������������͹��
���Descricao � O ponto se encontra no final da fun��o e deve ser utilizado���
���            para valida��es especificas do usuario onde ser� controlada���
���            pelo retorno do ponto de entrada oqual se for .F. o        ���
���            processo ser� interrompido e se .T. ser� validado.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pedido de Compra                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*************************
User Function  MT120LOK()
*************************

Local nPosPrd   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRODUTO'})
Local nPosItem  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEM'})
Local nPosQT    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_QUANT'})
Local lValido   := .T.
Local nLote     := 0  //armazenar� o B1_EMIN (Lote de Compra)
Local nEstSeg   := 0  //armazenar� o B1_ESTSEG (Pto pedido - estoque seguran�a)

Local cNumPed   := "" 
Local cItemPed  := ""
Local nQTPed    := 0
Local nResto    := 0
Local lBloqPto  := GetMv("RV_BLQPTO")

If lBloqPto
	If Inclui             
		DbSelectArea('SB1')
		DbSetOrder(1)
		If SB1->(DbSeek(xFilial('SB1') + aCols[n][nPosPrd] )) // + cA120Num+aCols[n][nPosItem])
		     If SM0->M0_CODFIL = "01"
		     	nLote := SB1->B1_EMIN
		     Elseif SM0->M0_CODFIL = "03"
		     	nLote := SB1->B1_EMINCX
		     Else
		     	nLote := 0
		     Endif
		     If nLote > 0   //se possui ponto pedido		     		     	
		     	Aviso("M E N S A G E M", "Este Produto Possui Ponto de Pedido, Inclus�o Manual no PC n�o Permitida!!" + CHR(13) + CHR(10);
			   + "Somente Com a Senha do Diretor Poder� ser Liberado.", {"OK"})
				lValido := U_senha2( "28", 5 )[ 1 ] 
				If !lValido
					Alert("Acesso Negado !!!")	
				Endif
		     Endif  //se for pto pedido
		EndIf //seek no B1
	
	
	ElseIf Altera
		cNumPed := SC7->C7_NUM
		cItemped:= SC7->C7_ITEM
		
		SC7->(Dbsetorder(1))
		SC7->(Dbseek(xFilial("SC7") + cNumPed + cItemPed ))
		nQTPed := SC7->C7_QUANT
		
		DbSelectArea('SB1')
		DbSetOrder(1)
		If SB1->(DbSeek(xFilial('SB1') + aCols[n][nPosPrd] )) // + cA120Num+aCols[n][nPosItem])	    
		     If SM0->M0_CODFIL = "01"
		     	nLote := SB1->B1_EMIN
		     Elseif SM0->M0_CODFIL = "03"
		     	nLote := SB1->B1_EMINCX
		     Else
		     	nLote := 0
		     Endif
		     If nLote > 0   //se for ponto pedido
		     	If aCols[n][nPosQT] <> nQTPed //se a qtde for diferente, n�o deixo alterar
		     		Alert(" Produto Possui Ponto de Pedido, e a Quantidade N�O Poder� Ser Alterada !!" + CHR(13) + CHR(10) ;
					+ " Favor Comunicar ao Respons�vel pelo Depto. Compras " )
		     		lValido := U_senha2( "28", 5 )[ 1 ] 
		     		If !lValido
						Alert("Acesso Negado !!!")	
					Endif
		     	Endif
		     Endif  //se for pto pedido
		EndIf //seek no B1
	Endif  //if altera
Endif // se bloqueia               
Return(lValido) 

