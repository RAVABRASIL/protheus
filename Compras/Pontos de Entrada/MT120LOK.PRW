#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120LOK º Autor ³ Flávia Rocha       º Data ³  04/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ O ponto se encontra no final da função e deve ser utilizadoº±±
±±º            para validações especificas do usuario onde será controladaº±±
±±º            pelo retorno do ponto de entrada oqual se for .F. o        º±±
±±º            processo será interrompido e se .T. será validado.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Pedido de Compra                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*************************
User Function  MT120LOK()
*************************

Local nPosPrd   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRODUTO'})
Local nPosItem  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEM'})
Local nPosQT    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_QUANT'})
Local lValido   := .T.
Local nLote     := 0  //armazenará o B1_EMIN (Lote de Compra)
Local nEstSeg   := 0  //armazenará o B1_ESTSEG (Pto pedido - estoque segurança)

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
		     	Aviso("M E N S A G E M", "Este Produto Possui Ponto de Pedido, Inclusão Manual no PC não Permitida!!" + CHR(13) + CHR(10);
			   + "Somente Com a Senha do Diretor Poderá ser Liberado.", {"OK"})
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
		     	If aCols[n][nPosQT] <> nQTPed //se a qtde for diferente, não deixo alterar
		     		Alert(" Produto Possui Ponto de Pedido, e a Quantidade NÃO Poderá Ser Alterada !!" + CHR(13) + CHR(10) ;
					+ " Favor Comunicar ao Responsável pelo Depto. Compras " )
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

