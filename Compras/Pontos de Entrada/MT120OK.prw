#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120OK � Autor � Fl�via Rocha       � Data �  13/05/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada que valida a inclus�o do pedido de compra 
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Compras                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

*************************
USER FUNCTION MT120OK()  
*************************

Local lOk := .T.
Local nValCompra := 0 
Local nValorFrete:= aValores[3]   //array private do MATA120 que guarda o valor do Frete
Local nValorFre  := 0 //auxiliar
Local nPercent   := 0
Local lBloqueia  := GetMV("RV_BLQFRE") //bloqueia frete maior que 10% do valor do pedido compra?

Local nTotalPed := 0  //total dos produtos no pedido compra

Local cCondPed  := ""  //ir� guardar o conte�do da vari�vel ambiente CCONDICAO
Local nPrzPed   := 0   //ir� guardar o prazo m�dio de acordo com a vari�vel cCondPed (o que foi digitado no pedido
Local nPrzMedio := 0   //ir� trazer o prazo m�dio de pagamento de acordo com o hist�rico do fornecedor
Local x         := 0

Local nPosProd	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("C7_PRODUTO") })
Local cProduto  := ""
Local lPtoPed   := .F. 
Local nPtoPed   := 0

Local nMedia    := 0  //valor m�dio das �ltimas compras (hist�rico)
Local cFornece  := CA120FORN  //aCols[n,nPosForn]
Local cLj       := CA120LOJ   //aCols[n,nPosLj]
Local lBloqCond := GetMv("RV_BLQCOND") // se bloqueia e critica a condi��o pagto digitada 
Local lAltCOND  := .F.
Local lAprovAnt := .F.
//Local nPosURG   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7__URGEN'}) //CAMPO QUE INDICA A URG�NCIA DA COMPRA
Local cUrgente  := "" 
Local lUrgente  := .F.
//CTPFRETE
/*
C-CIF
F-FOB
T-TERCEIROS
S-SEM FRETE
*/
IF UPPER( Alltrim( FunName() ) ) $ "CNTA120/CNTA121"
  //ALERT("ROTINA CONTRATOS")
  RETURN .T.
ELSE
	For x:= 1 to Len(aCols)
		//apura o valor total da compra e valor do frete digitado, para depois comparar se o percentual do frete
		//excede mais que 10% do valor da compra
		If !(aCols[x,Len(aHeader)+1]) //se a linha do acols n�o estiver deletada						
			nValCompra +=	aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "C7_TOTAL" }) ]
			nValorFre  +=	aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "C7_VALFRET" }) ] 
            
            cProduto   := aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "C7_PRODUTO" }) ] 
            SB1->(Dbsetorder(1))     //FR - verifica se � pto pedido, se for, n�o deixa alterar o PC
            If SB1->(Dbseek(xFilial("SB1") + cProduto ))
	            If SM0->M0_CODFIL = "01"
				   	nPtoPed := SB1->B1_EMIN
				Elseif SM0->M0_CODFIL = "03"
				   	nPtoPed := SB1->B1_EMINCX
				Else
				  	nPtoPed := 0
				Endif
				If nPtoPed > 0  //se tiver pto pedido
					lPtoPed := .T.
				Endif
			Endif
			///FR - 17/03/14 - CHAMADO 00000357 - COMPRAS URGENTES
			cUrgente := aCols[x][ aScan( aHeader, {|x| alltrim(x[2]) == "C7__URGEN" }) ] 
			If cUrgente = "S" //se mudou o flag para Urgente = Sim, valida se � pessoa autorizada que pode fazer isso
			//somente Marcelo, Orley tem permiss�o                                         
				lUrgente := .T.
			Endif
							
		Endif  //ACOLS N�O DELETADA        
	
	Next
	
	///FR - 17/03/14 - CHAMADO 00000357 - COMPRAS URGENTES
	//AS COMPRAS URGENTES N�O DEVEM EXCEDER O LIMITE DE 5% DA M�DIA DE PEDIDOS DE COMPRAS DOS �LTIMOS 3 MESES.
	//e n�o 10 % como no Chamado Original.
	If lUrgente
		///ver M�DIA PEDIDOS
		///se dentro da m�dia:
		nMedia      := 0
		nMedia      := fMedia(cFornece,cLJ)  //calcula a m�dia de compra, para este fornecedor, nos �ltimos 3 meses                                                                                                   
		nLimite     := 0
		If nMedia > 0
			nLimite     := ( nMedia * 0.05) + nMedia     //limite = m�dia + (5% da m�dia )
			lDentroMedia := nValCompra <= nLimite
		Else 
			lDentroMedia := .T.	 //se n�o tem m�dia de compras, n�o tem hist�rico, ent�o assumo que est� dentro da m�dia
			                     //para que a senha seja solicitada.
		Endif   
        
		
		If lDentroMedia
			//FR - 15/04/14 - chamado #78 - AIRTON SOLICITOU QUE N�O PRECISA MAIS PEDIR SENHA PARA DEFINIR URGENTE, FICAR� PARA APROVA��O POSTERIOR DE ORLEY
			/*
			Aviso("M E N S A G E M", "Para Definir Compra URGENTE, " + CHR(13) + CHR(10);
				   + "Somente Com a Senha do Diretor.", {"OK"})
			lOk := U_senha2( "28", 5 )[ 1 ]  //voltar
			If !lOk
				Alert("Acesso Negado !!!") //voltar
				Return lOk	             //voltar
			Endif
			*/
		///se fora da m�dia, bloqueia geral
		Else
			Aviso("M E N S A G E M", "O Valor Total Desta Compra �:   R$ " + Transform(nValCompra , "@E 999,999.99") + CHR(13) + CHR(10) +;
			      "O Limite de Compra Urgente p/ Este Fornecedor �: R$ " + Transform( nLimite, "@E 999,999.99" ) + CHR(13) + CHR(10)+;
			      "LIMITE COMPRA URGENTE Excedido !!! " , {"OK"})  
			lOk := .F.    
			Return lOk             //voltar
		Endif
		///FR
	Endif
	
	If lPtoPed	//FR - FL�VIA ROCHA - se o produto for pto pedido, n�o deixa alterar a qtde
		Aviso("M E N S A G E M", "Este Produto Possui Ponto de Pedido, Inclus�o/Altera��o Manual n�o Permitida!!" + CHR(13) + CHR(10);
				   + "Somente Com a Senha do Diretor Poder� ser Liberado.", {"OK"})
			lOk := U_senha2( "28", 5 )[ 1 ] //voltar
			
		 	If !lOk
				Alert("Acesso Negado !!!")	//voltar
				Return lOk //voltar
			Endif
	Endif
	
	If nValorFrete <= 0 .or. nValorFrete < nValorFre
		nValorFrete := nValorFre
	Endif
	///VALIDA��O RELATIVA AO VALOR FRETE (CASO DIGITADO)                    
	If nValorFrete > 0
		nPercent := Round(( nValorFrete / nValCompra ) * 100 , 2)
		If lBloqueia  //Vari�vel que indica se haver� bloqueio por valor de frete (definida pelo par�metro)	
		
			If !lUrgente
				//usu�rio consegue liberar frete com valor at� 10% do valor total da compra
				If nPercent >= 10.01 .and. nPercent <= 20
					Alert("Limite de Valor Frete Excedido, Atingiu: " + Alltrim(Str(nPercent)) + "% Do Valor Total do Pedido," + CHR(13) + CHR(10);
					    + "O Limite por Comprador � de at�: 10% do Valor Total do Pedido." + CHR(13) + CHR(10);
					    + "Somente com a Senha do Diretor poder� ser Liberado.")
					lOk := U_senha2( "28", 5 )[ 1 ]    //diretoria libera se for maior que 10% e at� o limite de 20% 			
				Elseif nPercent > 20
					Alert("O Frete � maior que 20% do Valor Total do Pedido, Acesso Negado.")
					lOk := .F.
				//Else
				//	Alert("Frete OK!") //RETIRAR
				Endif 
				
				If !lOk
					Return lOk
				Endif      
				
			Else //se for compra urgente, o limite de frete sobe de 10% para 15% - usu�rio
			     //                       o limite de frete sobe de 20% para 30% - diretoria               
			     If nPercent >= 15.01 .and. nPercent <= 30
					Alert("Limite de Valor Frete Excedido, Atingiu: " + Alltrim(Str(nPercent)) + "% Do Valor Total do Pedido," + CHR(13) + CHR(10);
					    + "O Limite p/ Compra URGENTE � de at�: 15% do Valor Total do Pedido." + CHR(13) + CHR(10);
					    + "Somente com a Senha do Diretor poder� ser Liberado.")
					lOk := U_senha2( "28", 5 )[ 1 ]    //diretoria libera se for maior que 10% e at� o limite de 20% 	//voltar
				Elseif nPercent > 30
					Alert("O Frete � maior que 30% do Valor Total do Pedido, Acesso Negado.")
					lOk := .F.                  
				//Else
					//Alert("Frete OK!") //RETIRAR
				Endif
				
				If !lOk
					Return lOk //voltar
				Endif       
			
			Endif //lurgente
		Endif
	Endif
	
	///////////////////////////////////////////////////
	///FR - 01/06/13
	///CHAMADO : 00000353
	///VALIDA��ES RELATIVAS AO PRAZO M�DIO DE COMPRA
	///////////////////////////////////////////////////
	//If !msgyesno("Continua?") //retirar
	//	Return .F.
	//Endif
	
	nMedia := 0
	If lBloqCond
	 	nMedia := fMedia(cFornece,cLJ)                                                                                                     
	 	nTotalPed := nValCompra
	    
	    ///TABELA COMPARATIVA R$ x PRAZO PAGTO	    
	    //R$ 0 - 1000 -> Prazo M�dio de 30 Dias. 
		//R$ 1001 - 5000 -> Prazo M�dio de 35 Dias.
		//R$ 5001 - 10000 -> Prazo M�dio de 45 Dias. 
		//R$ 10001 - Em diante -> Prazo M�dio de 50 Dias.
				
	 	/*
	 	If nMedia > nTotalPed   //se a m�dia de compras for maior que o total do pedido, utilizo a m�dia como base para estabelecer o prazo
	 		If nMedia <= 1000
				nPrazo := 30
			Elseif nMedia <= 5000
				nPrazo := 35
			Elseif nMedia <= 10000
				nPrazo := 45
			Else            
				nPrazo := 50
			Endif
	 	Else
	  		If nTotalPed <= 1000
				nPrazo := 30
			Elseif nTotalPed <= 5000
				nPrazo := 35
			Elseif nTotalPed <= 10000
				nPrazo := 45
			Else            
				nPrazo := 50
			Endif
	 	Endif
	 	*/
	 	//FR - 13/08/13 - MARCELO SOLICITOU INCLUIR MAIS UM ITEM NO RANGE -> 0,01 A 100 REAIS
		/*
		0,01 - 100,00 -> a vista
		100,01 - 1.000,00 -> 30 dias
		1.000,01 - 5.000,00 -> 35 dias
		5.000,01 - 10.000,00 -> 45 dias
		10.000,01 - em diante -> 50 dias
		*/
	 	If nMedia > nTotalPed   //se a m�dia de compras for maior que o total do pedido, utilizo a m�dia como base para estabelecer o prazo
	 		If nMedia < 100.01
				nPrazo := 0
			Elseif nMedia <= 1000
				nPrazo := 30
			Elseif nMedia <= 5000
				nPrazo := 45
			Elseif nMedia <= 10000            
				nPrazo := 45
			Else
				nPrazo := 50
			Endif
	 	Else
	  		If nTotalPed < 100.01
				nPrazo := 0
			Elseif nTotalPed <= 1000
				nPrazo := 30
			Elseif nTotalPed <= 5000
				nPrazo := 45
			Elseif nTotalPed <= 10000            
				nPrazo := 45
			Else
				nPrazo := 50
			Endif
	 	Endif
	 	//cCondPed := fTrazCond( nPrazo )
	 	//CCONDICAO:= cCondPed
	 	If Inclui
	 		cCondPed := CCONDICAO
	 		
	 		SE4->(Dbsetorder(1))
		 	If SE4->(Dbseek(xFilial("SE4") + cCondPed ))
		 		nPrzPed := SE4->E4_PRZMED   //pedido de compra
		 	Endif
		 	//nPrzMedio  := fTrazCond( nPrazo )  //n�o precisa 
		 	
		 	If nPrazo > nPrzPed    //se o prazo do hist�rico for maior que o  prazo digitado no pedido de compra, faz cr�tica e pede senha diretor
				Alert("Condi��o de Pagamento Possui Prazo Abaixo do Praticado pelo Hist�rico do Fornecedor: " + CHR(13) + CHR(10) ;
				+ " - Prazo M�dio Digitado: " + Alltrim(Str( nPrzPed)) + CHR(13) + CHR(10);
				+ " - Prazo M�dio Hist�rico: " + Alltrim(Str( nPrazo)) + "." + CHR(13) + CHR(10);
				+ "Somente com a Senha do Diretor poder� ser Liberada a Inclus�o deste Pedido Compra.")
				lOk := U_senha2( "28", 5 )[ 1 ]    //diretoria libera prazo menor que hist�rico  
			Endif 
			
			If !lOk
				Return lOk
			Endif      
			
	 	Elseif Altera
	 	
	 		cCondPed := SC7->C7_COND
	 		lAprovAnt:= iif( Alltrim(SC7->C7_CONAPRO) = "L" , .T. , .F. ) 
	 		//SE J� ESTAVA PREVIAMENTE APROVADO, N�O FAREI CR�TICA NA COND PAGTO SE ESTA N�O FOI ALTERADA TB
	 		//S� HAVER� CR�TICA DE PRAZO M�DIO, SE A CONDI��O PAGTO. FOR ALTERADA.
	 		If cCondPed <> CCONDICAO
	 			lAltCOND := .T.  //ALTEROU CONDI��O
	 		Endif
	 		
	
	 		SE4->(Dbsetorder(1))
		 	If SE4->(Dbseek(xFilial("SE4") + CCONDICAO ))
		 		nPrzPed := SE4->E4_PRZMED   //pedido de compra
		 	Endif
		 
		 	If lAltCOND //se houve altera��o na cond pagto
			 	If nPrazo > nPrzPed    //se o prazo do hist�rico for maior que o  prazo digitado no pedido de compra, faz cr�tica e pede senha diretor
					Alert("Condi��o de Pagamento Possui Prazo Abaixo do Praticado pelo Hist�rico do Fornecedor: " + CHR(13) + CHR(10) ;
					+ " - Prazo M�dio Digitado: " + Alltrim(Str( nPrzPed)) + CHR(13) + CHR(10);
					+ " - Prazo M�dio Hist�rico: " + Alltrim(Str( nPrazo)) + "." + CHR(13) + CHR(10);
					+ "Somente com a Senha do Diretor poder� ser Liberada a Inclus�o deste Pedido Compra.")
					lOk := U_senha2( "28", 5 )[ 1 ]    //diretoria libera prazo menor que hist�rico  
				Endif 
		
			Endif  //lAltCOND
			
			If !lOk
				Return lOk
			Endif      
	 		
	 	Endif
	 	
	 	
	Endif //se bloqueia por condi��o pagto (prazo m�dio)
	
	//If lPtoPed //se � pto pedido
	//	If !lOk           //se a senha n�o foi autorizada...
	//		Alert("Acesso Negado !!!")	
	//	Endif
	//Endif

ENDIF // IF FUNNAME
Return(lOk)
            





**********************************************************
Static Function fMedia( cForn, cLoj )
**********************************************************


Local LF        := CHR(13)+CHR(10)
Local cQuery    := ""
Local nMedia    := 0
Local nPrazo    := 0  //ser� usado na tabela de escalas de prazo m�dio de acordo com o valor do pedido / hist�rico compras
//_xId    := SC7->C7_USER


	cQuery := " SELECT SUM(D1_TOTAL), COUNT(*) AS QTAS, MEDIA = ROUND((SUM(D1_TOTAL) / COUNT(*) ),2)   " +LF
	cQuery += " FROM " + RetSqlname("SD1") + " SD1 " +LF

	cQuery += " WHERE "
	cQuery += " SD1.D1_FILIAL = '" + Alltrim(xFilial("SD1")) + "' "+LF
	cQuery += " AND SD1.D_E_L_E_T_ = '' "+LF
	cQuery += " and SD1.D1_FORNECE = '" + cForn + "' "+LF
	cQuery += " and SD1.D1_LOJA = '" + cLoj + "' "+LF
	cQuery += " AND SD1.D1_EMISSAO BETWEEN '" + Alltrim( Dtos(dDatabase - 90)) + "' AND '" + Alltrim( Dtos(dDatabase) ) + "' "+LF //�ltimos 3 meses
	Memowrite("C:\TEMP\FMEDIA.SQL",cQuery) 
	
	If Select("TMPD1") > 0
		DbSelectArea("TMPD1")
		DbCloseArea()	
	EndIf

	TCQUERY cQuery NEW ALIAS "TMPD1" 
	TMPD1->(DbGoTop())
	If !TMPD1->(EOF())
		While TMPD1->(!EOF())		
			nMedia		:= TMPD1->MEDIA
			TMPD1->(DBSKIP())		
		Enddo
    Endif 
    	
	
Return(nMedia)


**********************************************************
Static Function fTrazCond( nPrzMed )
**********************************************************


Local LF        := CHR(13)+CHR(10)
Local cQuery    := ""
Local nMedia    := 0
Local cCond     := ""
Local nPrazoMed := 0

	cQuery := " SELECT top 1 *  " +LF
	cQuery += " FROM " + RetSqlname("SE4") + " SE4 " +LF

	cQuery += " WHERE "
	cQuery += " E4_PRZMED >= " + Alltrim(Str(nPrzMed)) + "" + LF //" and E4_PRZMED <= " + nPrzMed + " " +LF
	cQuery += " AND SE4.D_E_L_E_T_ = '' "+LF
	Memowrite("C:\TEMP\FCOND.SQL",cQuery) 
	
	If Select("TMPE4") > 0
		DbSelectArea("TMPE4")
		DbCloseArea()	
	EndIf

	TCQUERY cQuery NEW ALIAS "TMPE4" 
	TMPE4->(DbGoTop())
	If !TMPE4->(EOF())
		While TMPE4->(!EOF())		
			cCond		:= TMPE4->E4_CODIGO
			nPrazoMed   := TMPE4->E4_PRZMED
			TMPE4->(DBSKIP())		
		Enddo
    Endif

//Return(cCond)
Return(nPrazoMed)


