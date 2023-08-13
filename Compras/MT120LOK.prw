#Include "Rwmake.ch"
#Include "Topconn.ch"

/*
Programa: MT120LOK - Ponto de entrada na valida��o da linha do pedido de compra
Objetivo: N�o permitir que o campo C7_NCM fique sem preenchimento
Autoria : Fl�via Rocha
Data    : 21/02/2011
Altera��o: 13/06/2011 - solicitado por Rodrigo - Chamado: 002051
           Validar o pre�o digitado do produto, se for maior que o �ltimo pre�o,
           enviar email para Marcelo, Rodrigo e compradores.
           Exceto se o produto for ST0178
*/

*************************
User Function  MT120LOK()
*************************

Local nPosPrd    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRODUTO'})
Local nPosNCM    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_NCM'})
Local nPosPreco  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRECO'})
Local nPrcMaior  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_MAIORVL'})
Local lValido := .T.
Local cFornece   := ""
Local cLojFor	 := ""
Local cNomeFor   := ""
Local nUltPreco  := 0
Local LF		 := CHR(13) + CHR(10) 
Local nLote      := 0 //armazena a qtde a comprar (B1_EMIN ou B1_EMINCX)
Local lOK		 := .F. 
Local lBloqPto  := GetMv("RV_BLQPTO")  

//Se for gerado pela rotina de medi��es de contratos
If AllTrim(Upper(FunName())) == "CNTA120"

	Return .T.

EndIf

If !(aCols[n,Len(aHeader)+1])   //se n�o estiver deletada a linha

	If lBloqPto
		SB1->(Dbsetorder(1))
		If SB1->(Dbseek(xFilial("SB1") + aCols[n][nPosPrd] ))
			If SM0->M0_CODFIL = "01"
			   	nLote := SB1->B1_EMIN
			Elseif SM0->M0_CODFIL = "03"
			   	nLote := SB1->B1_EMINCX
			Else
			  	nLote := 0
			Endif
			If nLote > 0  //se tiver pto pedido
				Aviso("M E N S A G E M", "Este Produto Possui Ponto de Pedido, Inclus�o/Altera��o Manual n�o Permitida!!" + CHR(13) + CHR(10);
				   + "Somente Com a Senha do Diretor Poder� ser Liberado.", {"OK"})
				lOk := U_senha2( "28", 5 )[ 1 ] 
				//Alert("Este Produto possui Ponto de Pedido, Inclus�o manual na SC n�o Permitida!!")
				   
				If !lOk
					Alert("Acesso Negado !!!")	
					Return .F.
				Endif
			Endif
		//Else
			//Alert("Produto n�o � pto pedido")
		Endif
	Endif  //se bloqueia

	////localiza �ltimo pre�o de compra
	///LOCALIZA SC7
    cQuery := " select top 1 C7_PRODUTO, C7_PRECO, C7_FORNECE,C7_LOJA, A2_COD,A2_LOJA,A2_NOME " + LF
    cQuery += "  from " + LF
    cQuery += " " + RetSqlName("SC7") + " SC7, " + LF
    cQuery += " " + RetSqlName("SA2") + " SA2 " + LF
    
    cQuery += " where C7_PRODUTO = '" + Alltrim( aCols[n][nPosPrd] ) + "' " + LF
    cQuery += " and C7_PRODUTO <> 'ST0178' " + LF
    
    cQuery += " and (C7_FORNECE + C7_LOJA) = (A2_COD + A2_LOJA) " + LF
    cQuery += " and C7_FILIAL = '" + xFilial("SC7") + "' " + LF
    cQuery += " and SC7.D_E_L_E_T_ = '' " + LF
    cQuery += " and SA2.D_E_L_E_T_ = '' " + LF
    cQuery += " Order by C7_PRECO DESC " + LF
        
    MemoWrite("C:\Temp\PRECOSC7.sql", cQuery)
    If Select("SC7XX") > 0
		DbSelectArea("SC7XX")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "SC7XX"
	TCSetField( 'SC7XX', "C7_EMISSAO", "D" )
	
	SC7XX->( DBGoTop() )
	If !SC7XX->(EOF())
		Do While !SC7XX->( Eof() )
		
			cFornece   := SC7XX->C7_FORNECE
			cLojFor	 := SC7XX->C7_LOJA
			cNomeFor   := SC7XX->A2_NOME
			nUltPreco  := SC7XX->C7_PRECO
		
				
			DbselectArea("SC7XX")
			SC7XX->(Dbskip())
		Enddo
	
		If !Empty( aCols[n][nPosPreco] )
			If aCols[n][nPosPreco] > nUltPreco
			    /*
				Aviso(	"Pedido de Compra",;
				"O �ltimo Pre�o de Compra � menor que o Atual para o produto " + BuscAcols("C7_PRODUTO")+".",;
				"Dados da �ltima Compra: Fornecedor: " + cNomeFor + ", Pre�o: " + Transform(nUltPreco, "@E 99,999,999.99"),;
				{"&Ok"},,;
				"Compara��o de Pre�os")
				*/
				If MsgYesNo("O �ltimo Pre�o de Compra foi: " +  Alltrim(Transform(nUltPreco, "@E 99,999,999.99")) + ". Menor que o Atual, deseja continuar ?" )
					aCols[n][nPrcMaior] := "S"
				Endif
			
			Endif
		Endif
		
	Endif 

Endif

///valida o campo NCM
///retirado, pois ser� obrigat�rio na entrada da NF
//FR - 06/08/12
/*
If !(aCols[n,Len(aHeader)+1])    //se a linha n�o estiver deletada
	If Empty( aCols[n][nPosNCM] )
		lValido := .F.
		Aviso(	"Pedido de Compra",;
				"Falta informar a NCM para o item "+BuscAcols("C7_ITEM")+".",;
				{"&Ok"},,;
				"Classifica��o Fiscal")
			
	Endif
	
Endif
*/


	


Return(lValido) 