#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT150OK � Autor � Fl�via Rocha       � Data �  04/07/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Valida a linha digitada. NEGOCIACAO COTACAO                ���
�������������������������������������������������������������������������͹��
���Uso       � Atualiza��o da Cota��o                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

***********************
User Function MT150Ok
***********************


Local nOpcx := Paramixb[1]  
//Numero da op��o selecionada.2- Novo Participante3- Atualizar4- Proposta5- Excluir 

Local nPosPrd   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C8_PRODUTO'})
Local nPosItem  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C8_ITEM'})
Local nPosQT    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C8_QUANT'})
Local nPosPRC   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C8_PRECO'})
Local nPosPROP  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C8_NUMPRO'})  //N�MERO PROPOSTA
//Local nPosICMST := aScan(aHeader,{|x| AllTrim(x[2]) == 'C8_ICMSST'})
Local cNumCOT   := SC8->C8_NUM
Local lValido   := .T.
Local nLote     := 0  //armazenar� o B1_EMIN (Lote de Compra)
Local nEstSeg   := 0  //armazenar� o B1_ESTSEG (Pto pedido - estoque seguran�a)
Local nQuant    := 0  //SC8->C8_QUANT
Local nPreco    := 0 //SC8->C8_PRECO
Local lBloqPto  := GetMv("RV_BLQPTO") 
Local x			:= 0 


Private cForn     := CA150FORN
Private cLj       := CA150LOJ
//Private cTPFRETE  := C150FRETE  //pegar a vari�vel do tipo frete no Sc8
If nOpcx = 3     //se � atualizar

	If lBloqPto
	
		For x:= 1 to Len(aCols)
			If !(aCols[x,Len(aHeader)+1]) //se a linha do acols n�o estiver deletada						
				If SB1->(DbSeek(xFilial('SB1') + aCols[x][nPosPrd] ))
				    //3 //filial + num cota��o + produto
				    //SC8->(Dbgoto(nRecno))
				    //SC8->(Dbseek(xFilial("SC8") + cNumCOT + aCols[x][nPosPrd] ))
				    nQuant := fVerQT(cNumCOT, aCols[x][nPosprd],cForn, cLJ, aCols[x][nPosPROP] )   //SC8->C8_QUANT
				    
					If SM0->M0_CODFIL = "01"
				     	nLote := SB1->B1_EMIN
				     Elseif SM0->M0_CODFIL = "03"
				     	nLote := SB1->B1_EMINCX
				     Else
				     	nLote := 0
				     Endif                                  
				     If nLote > 0   //se possui ponto pedido		     		     	
				     	If nQuant > 0  //qtde original
					     	IF aCols[x][nPosQT] <> nQuant //se a qtde for diferente, n�o deixo alterar
					     		//Alert("Qtde Original: " + str(nQuant) + " - Qtde Alterada: " + str(aCols[x][nPosQT]) )
					     
						     	Aviso("M E N S A G E M", "Este Produto Possui Ponto de Pedido !!" + chr(13) + chr(10);
						     	+ chr(13) + chr(10) + "Qtde Original: " + Transform(nQuant, "@E 999,999,999.9999") + " -> Qtde Alterada: " + Transform(aCols[x][nPosQT] , "@E 999,999,999.9999") + CHR(13) + CHR(10);
						     	+ " Somente com a Senha do Diretor poder� Alterar esta Qtde." , {"OK"})
								lValido := U_senha2( "28", 5 )[ 1 ] 
								If !lValido
									Alert("Acesso Negado !!!")	
								Endif
							//ELSE
							//	ALERT("SEM ALTERA��O!")
							ENDIF
						Endif //nQuant
				     Endif //� pto ped
				     
				Endif  //seek no b1
	
			Endif //acols n�o deletada
		Next                          
	Endif //se bloqueia 
	
	If Empty(C150FRETE)  //n�o deixa confirmar sem informar o frete
		MsgAlert("Por Favor, Preencha o Tipo de Frete!")
		lValido := .F.
		Return .F.
	Endif
	/*
	For _x	:= 1 to Len(aCols)
	
		//If aCols[x][nPosICMST] == '1' //sim
		MsgAlert('OPA')
			
	
	Next
	*/               
Endif // se opcx = Atualiza			

Return(lValido) 


*************************************
Static Function fVerQT(cCot , cProd, cForn , cLJ, cProposta ) 
*************************************

Local cQuery := ""
Local nAux   := 0

cQuery := "Select C8_QUANT from " + RetSqlname("SC8") + " SC8 " + CHR(13) + CHR(10)
cQuery += " Where C8_NUM = '" + Alltrim(cCot) + "' "  + CHR(13) + CHR(10)
cQuery += " and C8_PRODUTO = '" + Alltrim(cProd) + "' " + CHR(13) + CHR(10)
cQuery += " and C8_FORNECE = '" + Alltrim(cForn) + "' " + CHR(13) + CHR(10)
cQuery += " and C8_LOJA    = '" + Alltrim(cLJ) + "' " + CHR(13) + CHR(10)
cQuery += " and C8_NUMPRO  = '" + Alltrim(cProposta) + "' " + CHR(13) + CHR(10)
cQuery += " and C8_FILIAL = '" + xFilial("SC8") + "' AND D_E_L_E_T_ = '' "  + CHR(13) + CHR(10)
Memowrite("C:\TEMP\Fqt.SQL",cQuery) 
	
If Select("SC8XX") > 0
	DbSelectArea("SC8XX")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "SC8XX" 
SC8XX->(DbGoTop())
If !SC8XX->(EOF())
	While SC8XX->(!EOF())
		nAux := SC8XX->C8_QUANT	
		SC8XX->(DBSKIP())
	Enddo
Endif

Return(nAux)
