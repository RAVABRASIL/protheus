#INCLUDE "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT160AOK � Autor � Fl�via Rocha       � Data �  06/06/13   ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������͹��
���Uso       An�lise da Cota��o -> para gravar SC7                        ���
             Indica se permite ou n�o, a continua��o da An�lise da Cota��o���
             caso o prazo m�dio pagto, esteja incoerente as regras da     ���
             empresa, somente a senha do Diretor (Marcelo / Orley)        ���
             podem liberar para que o pedido de compra seja gerado        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

/*
PARAMIXB[1]			Num�rico			nOpcX - N�mero da opera��o realizada pela rotina:
										[3] - Inclus�o
										[4] - Altera��o
										[5] - Exclus�o										
PARAMIXB[2]			Array of Record			nReg - N�mero do registro posicionado da cota��o em an�lise.										
PARAMIXB[3]			Array of Record			aPlanilha - Vetor contendo a planinha de cota��es.										
PARAMIXB[4]			Array of Record			aAuditoria - Vetor contendo a planilha de auditoria realizada.										
PARAMIXB[5]			Array of Record			aCotacao - Vetor contendo todos os itens da cota��o posicionada.										
PARAMIXB[6]			Array of Record			aSC8 - Vetor contendo os campos utilizados como chave pela tabela de cota��es SC8.
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
Local lBloqCond := GetMv("RV_BLQCOND") // se bloqueia e critica a condi��o pagto digitada 
Local lOk    := .F. //vari�vel l�gica que indica se a senha diretor digitada 
                    //tem acesso para continuar a inclus�o do pedido em caso de bloqueio por prazo m�dio de condi��o de pagamento 
Local fr     := 0 
Local cMarca := ""
Local aForn  := {}
Local lDir   := .F.
//Local lSegue := .T.
Local cQuery := ""
Local nQtos  := 0 
Local lBloqFre := .F. //indica se bloqueiar� a an�lise de compras, caso o valor frete estiver vazio (apenas para os tipos de produtos: MP,MS,AC,ME)
Local nValFre  := 0 
Local cTPFre   := ""
Local aFrete   := {}
Local lDecisao := GETMV("RV_MT160OK") //VOLTAR
Local lIGUAL   := .T. 
Local nOPANA   := 0
Local lHOMOLG  := .F. //indica se � homologado .T. ou n�o .F.
Local aQTOS    := {} //armazena o produto e qtas cota�oes existem para o mesmo
Local lMelhor  := .F. //ATIVA O AVISO DA MELHOR DECIS�O COMPRA
PRIVATE aParam := PARAMIXB[1]
PRIVATE nOpc   := PARAMIXB[2] 
Private cMsg   := "" //mensagem a ser gravada nos campos do SC7 (C7_OBSDIR , C7_ANALISE)
Private cVar   := "" //vari�vel do Combo
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
	aParam[1][1][16] - DESCRI��O COND PAGTO
aParam[1][2]
	aParam[1][1][1] -  ' '  => MARCADA VAZIA
	aParam[1][1][2] - COD. FORN
	aParam[1][1][3] - LOJA 
	aParam[1][1][15] - COD COND PAGTO
	aParam[1][1][16] - DESCRI��O COND PAGTO
aParam[1][3]
	aParam[1][1][1] -  ' ' => MARCADA VAZIA
	aParam[1][1][2] - COD. FORN
	aParam[1][1][3] - LOJA 
	aParam[1][1][15] - COD COND PAGTO
	aParam[1][1][16] - DESCRI��O COND PAGTO 
	

*/
For fr := 1 to Len(aParam[1])
		If (aParam[1][fr][1]) $ "XX"
			cForn    := aParam[1][fr][2]  //c�digo fornecedor
			cLj      := aParam[1][fr][3]  //loja 
			cNomeForn:=aParam[1][fr][4]   //nome fornecedor
			nTotCOT  := aParam[1][fr][6] //valor total cota��o
			nPrecoUni:= aParam[1][fr][14] //pre�o unit�rio
			cCondC8  := aParam[1][fr][15] //c�digo cond.pagto
			cDescCond:= aParam[1][fr][16] //descri��o cond.pagto
			cNumProp := aParam[1][fr][5] //n�mero da proposta
		Endif              
	    //aParam[1][fr][4] : nome reduzido fornecedor
Next

////////////////////////////////////////////////////////////////////////////////
///VERIFICA��O DO PRODUTO
///REGRA: PRODUTOS HOMOLOGADOS: UMA COTA��O PARA CADA FORNECEDOR HOMOLOGADO, 
///       O SISTEMA ACEITA UMA APENAS, SE FOR O CASO
///       PRODUTOS N�O HOMOLOGADOS: 3 COTA��ES
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
//agora verifica no array aQTOS, se tem produto n�o homologado, se sim, precisa ter ao menos 3 cota��es
xn := 0
If Len(aQTOS) > 0
	For xn := 1 to Len(aQTOS)
		If Alltrim(aQTOS[xn,3]) != 'S'  //se n�o for homologado, precisa ao menos ter 3 cota��es
			If aQTOS[xn,2] < 3
				Alert("O Produto: " + aQTOS[xn,1] + " Possui Apenas " + alltrim(Str(aQTOS[xn,2]) ) + CHR(13) + CHR(10) + ; 
				" COTA��O(�es), a AN�LISE NECESSITA de Pelo Menos 3 COTA��ES! Favor Revisar.")
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
	
	If Alltrim(SB1->B1_HOMOLG) != "S"  //se for homologado, n�o precisa ter 3 cota��es
		//lSegue := .T.   //SE FOR PRODUTO HOMOLOGADO, N�O PRECISA DE TER 3 COTA��ES
		If nQtos < 3
			Alert("EXISTE(m) APENAS " + alltrim(Str( nQtos) ) + " COTA��O(�es), a AN�LISE NECESSITA de 3 COTA��ES! Favor Revisar.")
			lRet := .F.
			Return .F.
		Endif
	//Else
	//	alert('homologado')
	Endif
Endif	                         
*/
/////////////////////////////////
///AN�LISE DA DECIS�O DE COMPRA
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
//VERIFICA SE OS CUSTOS S�O IGUAIS
If C8XX->(!EOF())
	While C8XX->(!EOF())
		If nCTEQUIV <= 0      //na 1a. rodada esta� zero, ent�o atribuo direto         
			nCTEQUIV := C8XX->CEQUIV			
		ElseIf C8XX->CEQUIV > nCTEQUIV .or. C8XX->CEQUIV < nCTEQUIV 
			lIGUAL := .F.
		Endif
		C8XX->(DBSKIP())
	Enddo
Endif

If !lIGUAL //se tiver algum custo equivalente diferente, faz este la�o de verifica��o
	//alert("custos diferentes")
	C8XX->(Dbgotop())
	nCTEQUIV := 0
	If C8XX->(!EOF())
		While C8XX->(!EOF())
			If nCTEQUIV <= 0      //na 1a. rodada esta� zero, ent�o atribuo direto         
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



If lDecisao //se houver o bloqueio para decis�o compra (par�metro no X6)

	
//FR - 25/07/13
/////////////////////////////////////////////////////////////////////////////////////////
///DECIS�O COMPRA, COMPARA O FORNECEDOR SELECIONADO COM A DECIS�O CALCULADA PELO SISTEMA
///E ALERTA CASO SEJA DIFERENTE	                                                         
/////////////////////////////////////////////////////////////////////////////////////////

	If !lIGUAL //s� vai fazer se for diferente um custo equivalente dos outros, qdo forem iguais, n�o precisa fazer este comparativo
	
		If Alltrim( Substr(cFornBest,1,6) + Substr(cFornBest,8,2) ) != Alltrim(cForn + cLJ)
			//Aviso( "Melhor Decis�o Compra", "O Fornecedor Selecionado: " + cNomeForn + " N�o � a Melhor Decis�o de Compra, Favor Escolher o Fornecedor: " + cNomeBest,;
			// {"OK"})
			Aviso( "Melhor Decis�o Compra" , "Voc� Selecionou o Fornecedor: " + cForn + "/" + cLj + "-" + cNomeForn + CHR(13) + CHR(10);
			+ "Por�m, A Melhor Decis�o de Compra � o Fornecedor: " + cFornBest + "-" + cNomeBest + CHR(13) + CHR(10);
			+ "Somente com a Senha Diretor Poder� Gerar PC p/ o Fornecedor: " + cNomeForn , {"OK"} )
			 //Return .F.  //retorna .F. , e o usu�rio ter� que clicar em "Analisar" novamente para escolher o Fornecedor certo
			 lOk := U_senha2( "28", 5 )[ 1 ]
			 
			 If !lOk
				ALERT("O PEDIDO N�O SER� CRIADO!")
				lRet := .F.
				Return .F. 		
			Endif		
			 //N�O ADIANTA FAZER ESTE BLOCO ABAIXO, PORQUE ELE N�O ASSUME A MUDAN�A DO "X" 
			 /*
			 For fr := 1 to Len(aParam[1])
				If Alltrim(aParam[1][fr][2] + aParam[1][fr][3]) = Alltrim(cForn+cLJ)
					aParam[1][fr][1] := ""				
				Elseif Alltrim(aParam[1][fr][2] + aParam[1][fr][3]) = Alltrim( Substr(cFornBest,1,6) + Substr(cFornBest,8,2) )
					aParam[1][fr][1] := "XX"
				Endif              
			    //aParam[1][fr][4] : nome reduzido fornecedor
			 Next
			 If !MsgYesNo('Prosseguir com a Gera��o do Pedido ?')
				Return .f.
			 Endif
			 */
			 ///BLOCO N�O FUNCIONA
			 
		Else 
			lMelhor := .T.
			//Aviso( "Melhor Decis�o Compra" , "Parab�ns, Voc� Selecionou A Melhor Decis�o de Compra: " + cFornBest + "-" + Alltrim(cNomeBest) + " -> OK!", {"OK"} )	
		Endif
	Else
		lMelhor := .T.
		//Aviso( "Melhor Decis�o Compra" , "Parab�ns, Voc� Selecionou A Melhor Decis�o de Compra: " + cFornBest + "-" + Alltrim(cNomeBest) + " -> OK!", {"OK"} )	
	ENDIF	        //lIGUAL                                    
Endif //lDecis�o

//FR - 18/07/13
/////////////////////////////////////////////////////////////
//VALIDA��O DO TIPO DE PRODUTO x FRETE
//PARA OS PRODUTOS TIPO: MP, MS, ME, AC e TIPO FRETE = FOB, 
//tem que haver um valor de Frete registrado! 
//Este registro � feito pela Log�stica
/////////////////////////////////////////////////////////////

	aFrete  := fGetCOT( SC8->C8_NUM, cForn, cLJ, cNumProp )
	nValFre := aFrete[1,1]
	cTPFre  := aFrete[1,2]
	If Alltrim(cTPFre) = "F" //FOB
		If lBloqFre
			If nValfre <= 0  //se for zero, n�o deixar� prosseguir com a an�lise 
				Alert("Para os Tipos de Produtos = 'MP/MS/ME/AC' , e Tipo Frete = FOB, o Valor de Frete Deve Ser Maior que Zero !")
				lRet := .F.
				Return .F.
			Endif
		Endif
	//Else
	//	alert("n�o � fob")
	Endif

//If !MsgYesNo("Continua?")
//	Return .f.
//Endif
                  
//FR - 26/06/13
///TABELA COMPARATIVA R$ x PRAZO PAGTO
//R$ 0 - 1000 -> Prazo M�dio de 30 Dias. 
//R$ 1001 - 5000 -> Prazo M�dio de 35 Dias.
//R$ 5001 - 10000 -> Prazo M�dio de 45 Dias. 
//R$ 10001 - Em diante -> Prazo M�dio de 50 Dias.

		
If lBloqCond
	nMedia := fMedia(cForn,cLj)                                                                                                     	
 	/*
 	If nMedia > nTotCOT   //se a m�dia de compras for maior que o total do pedido, utilizo a m�dia como base para estabelecer o prazo
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
 	If nMedia > nTotCOT   //se a m�dia de compras for maior que o total do pedido, utilizo a m�dia como base para estabelecer o prazo
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
	 	
 	If nPrazo > nPrzCOT    //se o prazo do hist�rico for maior que o  prazo digitado no pedido de compra, faz cr�tica e pede senha diretor
		Alert("A Condi��o de Pagamento Possui Prazo Abaixo do Praticado pelo Hist�rico do Fornecedor: " + CHR(13) + CHR(10) ;
		+ " - Prazo M�dio Digitado: " + Alltrim(Str( nPrzCOT)) + CHR(13) + CHR(10);
		+ " - Prazo M�dio Hist�rico: " + Alltrim(Str( nPrazo)) + "." + CHR(13) + CHR(10);
		+ "FAVOR ALTERAR A COTA��O OU Somente com a Senha do Diretor poder� ser Liberada a Inclus�o deste Pedido Compra.")
		lOk := U_senha2( "28", 5 )[ 1 ]    //diretoria libera prazo menor que hist�rico  
		//lOk := .T.
		If lOk
			lDir:= .T.
		Else				
			ALERT("O PEDIDO N�O SER� CRIADO!")
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

///FR 29/07/13 - Grava��o no campo C7_ANALISE
////////////////////////////////////////////////////////////////////////////////
///Dialog que aparecer� por �ltimo, para o comprador informar sobre a
///Qualidade do item comprado, se �: id�ntica, superior, inferior, 1a. compra 
///em rela��o ao �ltimo fornecimento                                            
////////////////////////////////////////////////////////////////////////////////

If lMelhor
	Aviso( "Melhor Decis�o Compra" , "Parab�ns, Voc� Selecionou A Melhor Decis�o de Compra: " + cFornBest + "-" + Alltrim(cNomeBest) + " -> OK!", {"OK"} )	
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
				//grava em todos os itens da cota��o do fornecedor vencedor
				If RecLock("SC8", .F.)
					SC8->C8_PEJUROS := PJ
					SC8->(MsUnlock())
				Endif
			Endif 
			SC8->(Dbskip())
		Enddo
	Endif
	
	/*������������������������������������������������������������������������ٱ�
	�� Declara��o de Variaveis Private dos Objetos                             ��
	ٱ�������������������������������������������������������������������������*/
	
	
	/*������������������������������������������������������������������������ٱ�
	�� Definicao do Dialog e todos os seus componentes.                        ��
	ٱ�������������������������������������������������������������������������*/
	oDlg1      := MSDialog():New( 126,254,371,803,"Informa��es Adicionais",,,.F.,,,,,,.T.,,,.F. )
	oGrp1      := TGroup():New( 012,008,082,268,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSayPerg   := TSay():New( 020,018,{||"EM RELA��O AO FORNECIMENTO ANTERIOR, Por Favor, Responda:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,169,009)
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
			While !SC8->(EOF()) .and. SC8->C8_NUM == cNumCOT .and. SC8->C8_FILIAL == xFilial("SC8") //grava em todos os itens da cota��o
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
Local nPrazo    := 0  //ser� usado na tabela de escalas de prazo m�dio de acordo com o valor do pedido / hist�rico compras

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
