#INCLUDE "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT160AOK º Autor ³ Flávia Rocha       º Data ³  06/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       Análise da Cotação -> para gravar SC7                        º±±
             Indica se permite ou não, a continuação da Análise da Cotaçãoº±±
             caso o prazo médio pagto, esteja incoerente as regras da     º±±
             empresa, somente a senha do Diretor (Marcelo / Orley)        º±±
             podem liberar para que o pedido de compra seja gerado        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*
PARAMIXB[1]			Numérico			nOpcX - Número da operação realizada pela rotina:
										[3] - Inclusão
										[4] - Alteração
										[5] - Exclusão										
PARAMIXB[2]			Array of Record			nReg - Número do registro posicionado da cotação em análise.										
PARAMIXB[3]			Array of Record			aPlanilha - Vetor contendo a planinha de cotações.										
PARAMIXB[4]			Array of Record			aAuditoria - Vetor contendo a planilha de auditoria realizada.										
PARAMIXB[5]			Array of Record			aCotacao - Vetor contendo todos os itens da cotação posicionada.										
PARAMIXB[6]			Array of Record			aSC8 - Vetor contendo os campos utilizados como chave pela tabela de cotações SC8.
*/

**********************
USER FUNCTION MT160AOK
**********************

Local aCot1  := PARAMIXB
//Local aCot2  := PARAMIXB[5]
LOCAL lRet := .T.
Local cCondC8:= ""  
Local cNumProp := ""
Local cProduto := SC8->C8_PRODUTO
Local cDescCond := ""
Local nPrecoUni := 0
Local nTotCOT:= 0 
Local nPrzCOT:= 0
Local lBloqCond := GetMv("RV_BLQCOND") // se bloqueia e critica a condição pagto digitada 
Local lOk    := .F. //variável lógica que indica se a senha diretor digitada 
                    //tem acesso para continuar a inclusão do pedido em caso de bloqueio por prazo médio de condição de pagamento 
Local fr     := 0 
Local cMarca := ""
Local aForn  := {}
Local lDir   := .F.
//Local lSegue := .T.
Local cQuery := ""
Local nQtos  := 0 
Local lBloqFre := .F. //indica se bloqueiará a análise de compras, caso o valor frete estiver vazio (apenas para os tipos de produtos: MP,MS,AC,ME)
Local nValFre  := 0 
Local cTPFre   := ""
Local aFrete   := {}
Local lDecisao := GETMV("RV_MT160OK") //VOLTAR
Local lIGUAL   := .T. 
Local nOPANA   := 0
Local lHOMOLG  := .F. //indica se é homologado .T. ou não .F.
Local aQTOS    := {} //armazena o produto e qtas cotaçoes existem para o mesmo
Local lMelhor  := .F. //ATIVA O AVISO DA MELHOR DECISÃO COMPRA
PRIVATE aParam := PARAMIXB[1]
PRIVATE nOpc   := PARAMIXB[2] 
Private cMsg   := "" //mensagem a ser gravada nos campos do SC7 (C7_OBSDIR , C7_ANALISE)
Private cVar   := "" //variável do Combo
Private cNumCOT:= SC8->C8_NUM
Private cForn  := ""
Private cNomeForn := ""
Private cLj    := "" 
SetPrvt("oDlg1","oGrp1","oSayPerg","","oSayQuali","oSBtOK","oSBtCAN","oCBox1")

/*        
aParam[1][1]
	aParam[1][1][1] -  XX => MARCADA
	aParam[1][1][2] - COD. FORN
	aParam[1][1][3] - LOJA 
	aParam[1][1][15] - COD COND PAGTO
	aParam[1][1][16] - DESCRIÇÃO COND PAGTO
aParam[1][2]
	aParam[1][1][1] -  ' '  => MARCADA VAZIA
	aParam[1][1][2] - COD. FORN
	aParam[1][1][3] - LOJA 
	aParam[1][1][15] - COD COND PAGTO
	aParam[1][1][16] - DESCRIÇÃO COND PAGTO
aParam[1][3]
	aParam[1][1][1] -  ' ' => MARCADA VAZIA
	aParam[1][1][2] - COD. FORN
	aParam[1][1][3] - LOJA 
	aParam[1][1][15] - COD COND PAGTO
	aParam[1][1][16] - DESCRIÇÃO COND PAGTO 
	

*/
For fr := 1 to Len(aParam[1])
		If (aParam[1][fr][1]) $ "XX"
			cForn    := aParam[1][fr][2]  //código fornecedor
			cLj      := aParam[1][fr][3]  //loja 
			cNomeForn:=aParam[1][fr][4]   //nome fornecedor
			nTotCOT  := aParam[1][fr][6] //valor total cotação
			nPrecoUni:= aParam[1][fr][14] //preço unitário
			cCondC8  := aParam[1][fr][15] //código cond.pagto
			cDescCond:= aParam[1][fr][16] //descrição cond.pagto
			cNumProp := aParam[1][fr][5] //número da proposta
		Endif              
	    //aParam[1][fr][4] : nome reduzido fornecedor
Next

////////////////////////////////////////////////////////////////////////////////
///VERIFICAÇÃO DO PRODUTO
///REGRA: PRODUTOS HOMOLOGADOS: UMA COTAÇÃO PARA CADA FORNECEDOR HOMOLOGADO, 
///       O SISTEMA ACEITA UMA APENAS, SE FOR O CASO
///       PRODUTOS NÃO HOMOLOGADOS: 3 COTAÇÕES
////////////////////////////////////////////////////////////////////////////////	
cQuery := "  Select C8_PRODUTO,B1_HOMOLG, B1_TIPO " + CHR(13) + CHR(10)
cQuery += " ,(SELECT COUNT(*) FROM " + RetSqlName("SC8") + " C8  " + CHR(13) + CHR(10)
cQuery += " WHERE C8.C8_NUM = SC8.C8_NUM AND C8.D_E_L_E_T_= ''  " + CHR(13) + CHR(10)
cQuery += " AND C8.C8_FILIAL = SC8.C8_FILIAL AND C8.C8_PRODUTO = SC8.C8_PRODUTO) AS QTOS " + CHR(13) + CHR(10)
cQuery += " from " + RetSqlName("SC8") + " SC8 , " + RetSqlName("SB1") + " B1 " + CHR(13) + CHR(10)
cQuery += " Where SC8.C8_NUM = '" + Alltrim(cNumCOT) + "'  " + CHR(13) + CHR(10)
cQuery += " and SC8.C8_PRODUTO = B1.B1_COD " + CHR(13) + CHR(10)
cQuery += " and SC8.C8_FILIAL = '" + Alltrim(xFilial("SC8")) + "' " + CHR(13) + CHR(10)
cQuery += " and SC8.C8_NUMPED = '' and SC8.C8_ITEMPED = '' " + CHR(13) + CHR(10)
cQuery += " and SC8.D_E_L_E_T_ = ''  " + CHR(13) + CHR(10)
cQuery += " AND B1.D_E_L_E_T_ = '' " + CHR(13) + CHR(10)
cQuery += " GROUP BY SC8.C8_FILIAL, SC8.C8_NUM,SC8.C8_PRODUTO , B1.B1_HOMOLG, B1.B1_TIPO " + CHR(13) + CHR(10)
cQuery += " ORDER BY SC8.C8_PRODUTO " + CHR(13) + CHR(10) 
MemoWrite("C:\TEMP\QTOS.SQL" , cQuery )
If Select("C8YY")  > 0
	DbselectArea("C8YY")
	DbCloseArea()
Endif            

TcQuery cQuery New Alias "C8YY"

If C8YY->(!EOF())
	C8YY->(Dbgotop())
		While C8YY->(!EOF())
			If Alltrim(C8YY->B1_TIPO) $ "MP/MS/AC/ME"  //SE FOR ALGUM DESTES TIPOS, PRECISA TER VALOR DE FRETE
				lBloqFre := .T.
			Endif
			
			Aadd( aQTOS , {C8YY->C8_PRODUTO, C8YY->QTOS, C8YY->B1_HOMOLG} )
			C8YY->(DBSKIP())
			
		Enddo
Endif
//agora verifica no array aQTOS, se tem produto não homologado, se sim, precisa ter ao menos 3 cotações
xn := 0
If Len(aQTOS) > 0
	For xn := 1 to Len(aQTOS)
		If Alltrim(aQTOS[xn,3]) != 'S'  //se não for homologado, precisa ao menos ter 3 cotações
			If aQTOS[xn,2] < 3
				Alert("O Produto: " + aQTOS[xn,1] + " Possui Apenas " + alltrim(Str(aQTOS[xn,2]) ) + CHR(13) + CHR(10) + ; 
				" COTAÇÃO(ões), a ANÁLISE NECESSITA de Pelo Menos 3 COTAÇÕES! Favor Revisar.")
				lRet := .F.
				
			Endif	
		Endif
	Next
	
Endif

If !lRet
	Return .F.
Endif
	
/* 
SB1->(Dbsetorder(1))
If SB1->(Dbseek(xFilial("SB1") + cProduto ))
	//alert(cProduto)
	If Alltrim(SB1->B1_TIPO) $ "MP/MS/AC/ME"  //SE FOR ALGUM DESTES TIPOS, PRECISA TER VALOR DE FRETE
		lBloqFre := .T.
	Endif
	
	If Alltrim(SB1->B1_HOMOLG) != "S"  //se for homologado, não precisa ter 3 cotações
		//lSegue := .T.   //SE FOR PRODUTO HOMOLOGADO, NÃO PRECISA DE TER 3 COTAÇÕES
		If nQtos < 3
			Alert("EXISTE(m) APENAS " + alltrim(Str( nQtos) ) + " COTAÇÃO(ões), a ANÁLISE NECESSITA de 3 COTAÇÕES! Favor Revisar.")
			lRet := .F.
			Return .F.
		Endif
	//Else
	//	alert('homologado')
	Endif
Endif	                         
*/
/////////////////////////////////
///ANÁLISE DA DECISÃO DE COMPRA
/////////////////////////////////

nCTEQUIV := 0
cFornBest:= ""
cNomeBest:= ""
cQuery := " Select SUM(C8_CTEQUIV) CEQUIV , C8_FORNECE , C8_LOJA, A2_NREDUZ " + CHR(13) + CHR(10)
cQuery += " from " + RetSqlName("SC8") + " SC8 "+CHR(13) + CHR(10)
cQuery += " ,    " + RetSqlName("SA2") + " SA2 "+CHR(13) + CHR(10)
cQuery += " Where C8_NUM = '" + Alltrim(SC8->C8_NUM) + "' "+CHR(13) + CHR(10)
//cQuery += " and C8_PRODUTO = '" + Alltrim(SC8->C8_PRODUTO) + "' "+CHR(13) + CHR(10)
cQuery += " and C8_FORNECE = A2_COD AND C8_LOJA = A2_LOJA "+CHR(13) + CHR(10)
cQuery += " and C8_FILIAL = '" + Alltrim(xFilial("SC8")) + "' " + CHR(13) + CHR(10)
cQuery += " and SC8.D_E_L_E_T_ = '' "+CHR(13) + CHR(10)
cQuery += " and SA2.D_E_L_E_T_ = '' "+CHR(13) + CHR(10)
cQuery += " GROUP BY C8_FORNECE , C8_LOJA, A2_NREDUZ " 
MemoWrite("C:\TEMP\CTEQUIV.SQL",cQuery )
If Select("C8XX")  > 0
	DbselectArea("C8XX")
	DbCloseArea()
Endif            

TcQuery cQuery New Alias "C8XX"
//VERIFICA SE OS CUSTOS SÃO IGUAIS
If C8XX->(!EOF())
	While C8XX->(!EOF())
		If nCTEQUIV <= 0      //na 1a. rodada esta´ zero, então atribuo direto         
			nCTEQUIV := C8XX->CEQUIV			
		ElseIf C8XX->CEQUIV > nCTEQUIV .or. C8XX->CEQUIV < nCTEQUIV 
			lIGUAL := .F.
		Endif
		C8XX->(DBSKIP())
	Enddo
Endif

If !lIGUAL //se tiver algum custo equivalente diferente, faz este laço de verificação
	//alert("custos diferentes")
	C8XX->(Dbgotop())
	nCTEQUIV := 0
	If C8XX->(!EOF())
		While C8XX->(!EOF())
			If nCTEQUIV <= 0      //na 1a. rodada esta´ zero, então atribuo direto         
				nCTEQUIV := C8XX->CEQUIV
				cFornBest:= C8XX->C8_FORNECE + '/' + C8XX->C8_LOJA
				cNomeBest:= C8XX->A2_NREDUZ
			ElseIf C8XX->CEQUIV < nCTEQUIV
				nCTEQUIV := C8XX->CEQUIV
				cFornBest:= C8XX->C8_FORNECE + '/' + C8XX->C8_LOJA
				cNomeBest:= C8XX->A2_NREDUZ
			Endif
			C8XX->(DBSKIP())
		Enddo
	Endif    
//Else
//	alert("custos iguais")
Endif



If lDecisao //se houver o bloqueio para decisão compra (parâmetro no X6)

	
//FR - 25/07/13
/////////////////////////////////////////////////////////////////////////////////////////
///DECISÃO COMPRA, COMPARA O FORNECEDOR SELECIONADO COM A DECISÃO CALCULADA PELO SISTEMA
///E ALERTA CASO SEJA DIFERENTE	                                                         
/////////////////////////////////////////////////////////////////////////////////////////

	If !lIGUAL //só vai fazer se for diferente um custo equivalente dos outros, qdo forem iguais, não precisa fazer este comparativo
	
		If Alltrim( Substr(cFornBest,1,6) + Substr(cFornBest,8,2) ) != Alltrim(cForn + cLJ)
			//Aviso( "Melhor Decisão Compra", "O Fornecedor Selecionado: " + cNomeForn + " Não é a Melhor Decisão de Compra, Favor Escolher o Fornecedor: " + cNomeBest,;
			// {"OK"})
			Aviso( "Melhor Decisão Compra" , "Você Selecionou o Fornecedor: " + cForn + "/" + cLj + "-" + cNomeForn + CHR(13) + CHR(10);
			+ "Porém, A Melhor Decisão de Compra É o Fornecedor: " + cFornBest + "-" + cNomeBest + CHR(13) + CHR(10);
			+ "Somente com a Senha Diretor Poderá Gerar PC p/ o Fornecedor: " + cNomeForn , {"OK"} )
			 //Return .F.  //retorna .F. , e o usuário terá que clicar em "Analisar" novamente para escolher o Fornecedor certo
			 lOk := U_senha2( "28", 5 )[ 1 ]
			 
			 If !lOk
				ALERT("O PEDIDO NÃO SERÁ CRIADO!")
				lRet := .F.
				Return .F. 		
			Endif		
			 //NÃO ADIANTA FAZER ESTE BLOCO ABAIXO, PORQUE ELE NÃO ASSUME A MUDANÇA DO "X" 
			 /*
			 For fr := 1 to Len(aParam[1])
				If Alltrim(aParam[1][fr][2] + aParam[1][fr][3]) = Alltrim(cForn+cLJ)
					aParam[1][fr][1] := ""				
				Elseif Alltrim(aParam[1][fr][2] + aParam[1][fr][3]) = Alltrim( Substr(cFornBest,1,6) + Substr(cFornBest,8,2) )
					aParam[1][fr][1] := "XX"
				Endif              
			    //aParam[1][fr][4] : nome reduzido fornecedor
			 Next
			 If !MsgYesNo('Prosseguir com a Geração do Pedido ?')
				Return .f.
			 Endif
			 */
			 ///BLOCO NÃO FUNCIONA
			 
		Else 
			lMelhor := .T.
			//Aviso( "Melhor Decisão Compra" , "Parabéns, Você Selecionou A Melhor Decisão de Compra: " + cFornBest + "-" + Alltrim(cNomeBest) + " -> OK!", {"OK"} )	
		Endif
	Else
		lMelhor := .T.
		//Aviso( "Melhor Decisão Compra" , "Parabéns, Você Selecionou A Melhor Decisão de Compra: " + cFornBest + "-" + Alltrim(cNomeBest) + " -> OK!", {"OK"} )	
	ENDIF	        //lIGUAL                                    
Endif //lDecisão

//FR - 18/07/13
/////////////////////////////////////////////////////////////
//VALIDAÇÃO DO TIPO DE PRODUTO x FRETE
//PARA OS PRODUTOS TIPO: MP, MS, ME, AC e TIPO FRETE = FOB, 
//tem que haver um valor de Frete registrado! 
//Este registro é feito pela Logística
/////////////////////////////////////////////////////////////

	aFrete  := fGetCOT( SC8->C8_NUM, cForn, cLJ, cNumProp )
	nValFre := aFrete[1,1]
	cTPFre  := aFrete[1,2]
	If Alltrim(cTPFre) = "F" //FOB
		If lBloqFre
			If nValfre <= 0  //se for zero, não deixará prosseguir com a análise 
				Alert("Para os Tipos de Produtos = 'MP/MS/ME/AC' , e Tipo Frete = FOB, o Valor de Frete Deve Ser Maior que Zero !")
				lRet := .F.
				Return .F.
			Endif
		Endif
	//Else
	//	alert("não é fob")
	Endif

//If !MsgYesNo("Continua?")
//	Return .f.
//Endif
                  
//FR - 26/06/13
///TABELA COMPARATIVA R$ x PRAZO PAGTO
//R$ 0 - 1000 -> Prazo Médio de 30 Dias. 
//R$ 1001 - 5000 -> Prazo Médio de 35 Dias.
//R$ 5001 - 10000 -> Prazo Médio de 45 Dias. 
//R$ 10001 - Em diante -> Prazo Médio de 50 Dias.

		
If lBloqCond
	nMedia := fMedia(cForn,cLj)                                                                                                     	
 	/*
 	If nMedia > nTotCOT   //se a média de compras for maior que o total do pedido, utilizo a média como base para estabelecer o prazo
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
  		If nTotCOT <= 1000
			nPrazo := 30
		Elseif nTotCOT <= 5000
			nPrazo := 35
		Elseif nTotCOT <= 10000
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
 	If nMedia > nTotCOT   //se a média de compras for maior que o total do pedido, utilizo a média como base para estabelecer o prazo
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
  		If nTotCOT < 100.01
			nPrazo := 0
		Elseif nTotCOT <= 1000
			nPrazo := 30
		Elseif nTotCOT <= 5000
			nPrazo := 45
		Elseif nTotCOT <= 10000            
			nPrazo := 45
		Else
			nPrazo := 50
		Endif
 	Endif
	 	
 	SE4->(Dbsetorder(1))
 	If SE4->(Dbseek(xFilial("SE4") + cCondC8 ))
 		nPrzCOT := SE4->E4_PRZMED   //pedido de compra
 	Endif
	 	
 	If nPrazo > nPrzCOT    //se o prazo do histórico for maior que o  prazo digitado no pedido de compra, faz crítica e pede senha diretor
		Alert("A Condição de Pagamento Possui Prazo Abaixo do Praticado pelo Histórico do Fornecedor: " + CHR(13) + CHR(10) ;
		+ " - Prazo Médio Digitado: " + Alltrim(Str( nPrzCOT)) + CHR(13) + CHR(10);
		+ " - Prazo Médio Histórico: " + Alltrim(Str( nPrazo)) + "." + CHR(13) + CHR(10);
		+ "FAVOR ALTERAR A COTAÇÃO OU Somente com a Senha do Diretor poderá ser Liberada a Inclusão deste Pedido Compra.")
		lOk := U_senha2( "28", 5 )[ 1 ]    //diretoria libera prazo menor que histórico  
		//lOk := .T.
		If lOk
			lDir:= .T.
		Else				
			ALERT("O PEDIDO NÃO SERÁ CRIADO!")
			lRet := .F. 		
			Return .F.
		Endif		
		/*	
		If lDir
			ExecBlock("MT160GRPC")
		Endif
		*/
	Endif  //nprazo > nprzcot
		
ENDIF  //lBloqCond

///FR 29/07/13 - Gravação no campo C7_ANALISE
////////////////////////////////////////////////////////////////////////////////
///Dialog que aparecerá por último, para o comprador informar sobre a
///Qualidade do item comprado, se é: idêntica, superior, inferior, 1a. compra 
///em relação ao último fornecimento                                            
////////////////////////////////////////////////////////////////////////////////

If lMelhor
	Aviso( "Melhor Decisão Compra" , "Parabéns, Você Selecionou A Melhor Decisão de Compra: " + cFornBest + "-" + Alltrim(cNomeBest) + " -> OK!", {"OK"} )	
Endif

IF lRet

	//GRAVA A TAXA DE JUROS
	PJ := 0
	SX5->(Dbsetorder(1))
	SX5->(Dbseek(xFilial("SX5") + 'PJ' + 'JURMES'))
	PJ := VAL(ALLTRIM(SX5->X5_DESCRI))
	SC8->(DBSetorder(1))
	If SC8->(Dbseek(xFilial("SC8") + cNumCOT + cForn + cLj )) 
		While !SC8->(EOF()) .and. SC8->C8_NUM == cNumCOT .and. SC8->C8_FILIAL == xFilial("SC8") 
			If SC8->C8_FORNECE == cForn .and. SC8->C8_LOJA == cLJ
				//grava em todos os itens da cotação do fornecedor vencedor
				If RecLock("SC8", .F.)
					SC8->C8_PEJUROS := PJ
					SC8->(MsUnlock())
				Endif
			Endif 
			SC8->(Dbskip())
		Enddo
	Endif
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1      := MSDialog():New( 126,254,371,803,"Informações Adicionais",,,.F.,,,,,,.T.,,,.F. )
	oGrp1      := TGroup():New( 012,008,082,268,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSayPerg   := TSay():New( 020,018,{||"EM RELAÇÃO AO FORNECIMENTO ANTERIOR, Por Favor, Responda:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,169,009)
	//oCBox1     := TComboBox():New( 051,100,,,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	  
	oSayQuali  := TSay():New( 048,022,{||"Qualidade dos Produtos: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,061,008)
	
	oCBox1     := TComboBox():New( 047,087,{|u| If(PCount()>0,cVAR:=u,cVAR)},{ "" , "I=Identico", "F=Inferior", "S=Superior", "P=1a.Compra" },040,010,oGrp1,,,,;
  														CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )  	
	oSBtOK     := SButton():New( 100,156,1,{||oDlg1:End()},oDlg1,,"", )
	oSBtOK:bAction := {|| (nOPANA := 1,oDlg1:End()) }
	
	oSBtCAN    := SButton():New( 100,208,2,{||oDlg1:End()},oDlg1,,"", )
	oSBtCAN:bAction := {|| (nOPANA := 0 , oDlg1:End()) }
	
	
	oDlg1:Activate(,,,.T.)
	
	If nOPANA = 1
		If cVar = "I" //1
			cMsg :=  "QUALIDADE IDENTICA"
		ElseIf cVar = "F" //2
			cMsg :=  "QUALIDADE INFERIOR"
		ElseIf cVar = "S" //3
			cMsg :=  "QUALIDADE SUPERIOR"
		ElseIf cVar = "P" //4
			cMsg :=  "1a.COMPRA"
		Endif
		
		//ExecBlock("MT160GRPC(.F.," + &(cMsg) + " )" )
		SC8->(DBSetorder(1))
		If SC8->(Dbseek(xFilial("SC8") + cNumCOT + cForn + cLj )) 
			While !SC8->(EOF()) .and. SC8->C8_NUM == cNumCOT .and. SC8->C8_FILIAL == xFilial("SC8") //grava em todos os itens da cotação
				If SC8->C8_FORNECE == cForn .and. SC8->C8_LOJA == cLJ
					If RecLock("SC8", .F.)
						SC8->C8_ANALISE := cMsg
						SC8->(MsUnlock())
					Endif
				Endif 
				SC8->(Dbskip())
			Enddo
		Endif
	Endif
ENDIF

RETURN lRet


**********************************************************
Static Function fMedia( cForn, cLoj )
**********************************************************


Local LF        := CHR(13)+CHR(10)
Local cQuery    := ""
Local nMedia    := 0
Local nPrazo    := 0  //será usado na tabela de escalas de prazo médio de acordo com o valor do pedido / histórico compras

	cQuery := " SELECT SUM(D1_TOTAL), COUNT(*) AS QTAS, MEDIA = ROUND((SUM(D1_TOTAL) / COUNT(*) ),2)   " +LF
	cQuery += " FROM " + RetSqlname("SD1") + " SD1 " +LF

	cQuery += " WHERE "
	cQuery += " SD1.D1_FILIAL = '" + Alltrim(xFilial("SD1")) + "' "+LF
	cQuery += " AND SD1.D_E_L_E_T_ = '' "+LF
	cQuery += " and SD1.D1_FORNECE = '" + cForn + "' "+LF
	cQuery += " and SD1.D1_LOJA = '" + cLoj + "' "+LF
	cQuery += " AND SD1.D1_EMISSAO BETWEEN '" + Alltrim( Dtos(dDatabase - 90)) + "' AND '" + Alltrim( Dtos(dDatabase) ) + "' "+LF //últimos 3 meses
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


************************************************************************************************
Static Function fGetCOT( cCOT, cForn, cLJ, cNumPro )
************************************************************************************************

Local cQuery    := ""
Local cAlias    := "SC8X"
Local aCols		:= {}        
Local LF 		:= CHR(13) + CHR(10)
Local nAux		:= 0
Local cTPF      := ""
Local aRetorno  := {}


		cQuery := " SELECT  C8_VALFRE, C8_TPFRETE,C8_NUM,C8_FORNECE,C8_LOJA,C8_NUMPRO " + LF
	    cQuery += " From " + RetSqlname("SC8") + " SC8 " + LF
	    cQuery += " WHERE " + LF
		cQuery += " C8_FILIAL  = '" + xFilial("SC8") + "' " + LF
		cQuery += " AND C8_NUM = '"  + Alltrim(cCOT)  + "' " + LF
		cQuery += " AND C8_FORNECE = '"  + Alltrim(cForn)  + "' " + LF
		cQuery += " AND C8_LOJA = '"  + Alltrim(cLJ)  + "' " + LF
		cQuery += " AND C8_NUMPRO = '"  + Alltrim(cNumPro)  + "' " + LF
		//cQuery += " AND C8_TPFRETE = 'F' " + LF
		cQuery += " AND SC8.D_E_L_E_T_ = ' '  "
		cQuery += " ORDER BY C8_NUM, C8_ITEM, C8_NUMPRO " + LF
MemoWrite("C:\Temp\FGETCOT.SQL",cQuery)

If Select("SC8X") > 0
	DbSelectArea("SC8X")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "SC8X" 
SC8X->(Dbgotop())
If !SC8X->(EOF())
	While ! SC8X->(EOF())   
		nAux += SC8X->C8_VALFRE
		cTPF := SC8X->C8_TPFRETE
	   SC8X->(DbSkip())
	Enddo
	Aadd( aRetorno , {nAux , cTPF } ) //valor frete , tipo frete

Else
	Aadd(aRetorno , { 0 , "" } )
Endif                      

Return(aRetorno)
