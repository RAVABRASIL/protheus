#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "ap5mail.ch"
//-------------------------------------------------------------------------------
// MT160WF - Ponto de entrada do sistema de análise de cotação, é executado após
//			 a gravação do pedido de compra a partir do botão "OK".
//Objetivo: Utilizado na nova rotina de Feedback Compras
// Autoria: Flávia Rocha
// Data   : 23/03/10
//-------------------------------------------------------------------------------


****************************
User Function MT160WF()
****************************


Local cFil	  := SC7->C7_FILIAL


Local oProcess, oHtml
Local cArqHtml:= ""
Local cAssunto:= ""
Local _xId	  := ""
Local cNumSC  := SC7->C7_NUMSC 
Local aPedido := {}
Local cPedido := ""
Local nTotGer := 0 
Local cSolic  := ""
Local cNomSolic	:= ""
Local dEmi		:= SC7->C7_EMISSAO //Ctod("  /  /    ")
Local xCond		:= SC7->C7_COND //""		//código da cond. pgto.
Local xCondicao	:= ""		//descrição da cond. pgto.
Local _nX		:= 0
Local LF        := CHR(13)+CHR(10)
Local cNomFor	:= ""
Local eEmail    := ""
Local cQuery    := ""
Local cAnalise  := "" 
Local nValFre   := 0
Local cDestDIR  := GetMv("RV_MT160WF")   
Local cMailCopia	:= ""
Local aAreaSC7	:= getArea("SC7")

Private cNumPed := SC7->C7_NUM
MSGBOX("Gravando numero: cNumPed - " + cNumPed + " SC7->C7_NUM - " + SC7->C7_NUM)
	////////////////////////////////////////////////////////////////////////////////////////////
	////ANÁLISE DE COMPRAS
    ////FR - 01/08/13
	////seleciona a cotação relativa a este pedido, para obter o conteúdo do campo C8_ANALISE
	////O Qual irei gravar no C7_ANALISE
	////////////////////////////////////////////////////////////////////////////////////////////
	cQuery := " SELECT C8_NUMPED,C8_ITEMPED, C8_NUM, C8_ANALISE, C8_VALFRE, (C8_CUSTIVP + C8_CUSTFVP) CTVP " + CHR(13) + CHR(10)
	cQuery += " From " +  RetSqlName("SC8") + " C8 " + CHR(13) + CHR(10)
	cQuery += " Where C8.C8_NUMPED = '" + Alltrim(cNumPed) + "' " + CHR(13) + CHR(10)
	cQuery += " AND C8.C8_FILIAL = '" + Alltrim(xFilial("SC7")) + "' " + CHR(13) + CHR(10)
	cQuery += " AND C8.D_E_L_E_T_ = '' " + CHR(13) + CHR(10)
	Memowrite("C:\COTMT160WF.SQL",cQuery) 
	
	If Select("TMPC8") > 0
		DbSelectArea("TMPC8")
		DbCloseArea()	
	EndIf

	TCQUERY cQuery NEW ALIAS "TMPC8" 
	
	TMPC8->(DbGoTop())
	If !TMPC8->(EOF())
		cAnalise := TMPC8->C8_ANALISE
		nValFre  := TMPC8->C8_VALFRE 
		//nCTVP    := TMPC8->CTVP
	Endif
	
	SC7->(DBSetorder(1))
	If SC7->(Dbseek(xFilial("SC7") + cNumPed )) 
		While !SC7->(EOF()) .and. SC7->C7_NUM == cNumPed .and. SC7->C7_FILIAL == xFilial("SC7") //grava em todos os itens do pedido
			If RecLock("SC7", .F.)
				SC7->C7_ANALISE := cAnalise
				SC7->C7_FRETE   := nValFre
				SC7->C7_VALFRE  := nValFre
				SC7->C7_VALFRET := nValFre
				SC7->(MsUnlock())
			Endif 
			SC7->(Dbskip())
		Enddo
	Endif
	///FIM DA GRAVAÇÃO DA ANÁLISE COMPRAS
	
	//RestArea(aAreaSC7)
	
	//-------------------------------------------------------------------------------------
	// Iniciando o Processo WorkFlow de envio do pedido gerado em formato HTML
	//-------------------------------------------------------------------------------------
	// Monte uma descrição para o assunto:
	cAssunto := "Pedido de Compra Gerado No: " + cNumPed
	
	// Informe o caminho e o arquivo html que será usado.
	cArqHtml := "\Workflow\http\oficial\GerouPC.html"
	
	// Inicialize a classe de processo:
	oProcess := TWFProcess():New( "PEDCOM", cAssunto )
	
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask( "Pedido Gerado", cArqHtml )
	
	// Informe o nome do shape correspondente a este ponto do fluxo:
	cShape := "INICIO"
	
	
	// Informe a função que deverá ser executada quando as respostas chegarem
	// ao Workflow.
	//oProcess:bReturn := "U_APCRetorno"
	oProcess:cSubject := cAssunto
	
	oHtml := oProcess:oHTML
	
	oHtml:ValByName("cCodSol",cNumSC)
	oHtml:ValByName("cNumPC",cNumPed)
	oHtml:ValByName("dEmissao",Dtoc(dEmi))
	
			
/////REUNE OS DADOS PARA GERAR O HTML	
	cQuery := " SELECT C7_FILIAL, C7_NUM, C1_NUM, C7_ITEM,C1_ITEM, C7_DESCRI, C1_USER, C7_EMISSAO  " +LF
	cQuery += " , C7_COND, C7_PRODUTO, C7_QUANT, C7_PRECO, C7_TOTAL, C7_VALFRET,C7_VALIPI, C7_VALICM, B1_DESC "+LF
	cQuery += " ,C7_PEJUROS, A2_COD,A2_LOJA, A2_NREDUZ, (C8_CUSTIVP + C8_CUSTFVP) C8CTVP  "+LF
	cQuery += " ,E4_DESCRI  "+LF
	
	///ÚLTIMO FORNECEDOR
  	cQuery += " ,(SELECT TOP 1 A2.A2_NREDUZ  FROM " + RetSqlName("SC7") + " L , " + RetSqlName("SA2") + " A2 " + LF
  	cQuery += " WHERE L.C7_FILIAL = SC7.C7_FILIAL AND L.C7_FORNECE = A2.A2_COD AND L.C7_LOJA = A2.A2_LOJA " + LF
  	cQuery += " AND L.C7_PRODUTO = SC7.C7_PRODUTO AND L.D_E_L_E_T_ = '' " + LF
  	cQuery += " AND L.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY L.C7_EMISSAO DESC) C7UFOR " + LF + LF
  		
	///ÚLTIMO PRODUTO
	cQuery += " ,(SELECT TOP 1 A.C7_PRODUTO FROM " + RetSqlName("SC7") + " A " + LF
	cQuery += " WHERE A.C7_FILIAL = SC7.C7_FILIAL " + LF
  	cQuery += " AND A.C7_PRODUTO = SC7.C7_PRODUTO AND A.D_E_L_E_T_ = ''  " + LF
  	cQuery += " AND A.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY A.C7_EMISSAO DESC) C7UPROD " + LF + LF
  	
  	///ÚLTIMO PREÇO UNITARIO
  	cQuery += " ,(SELECT TOP 1 B.C7_PRECO FROM " + RetSqlName("SC7") + " B " + LF
  	cQuery += " WHERE B.C7_FILIAL = SC7.C7_FILIAL " + LF
  	cQuery += " AND B.C7_PRODUTO = SC7.C7_PRODUTO AND B.D_E_L_E_T_ = ''  " + LF
  	cQuery += " AND B.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY B.C7_EMISSAO DESC) C7UPRE " + LF + LF

  	///ÚLTIMO IPI
  	cQuery += " ,(SELECT TOP 1 C.C7_VALIPI FROM " + RetSqlName("SC7") + " C " + LF
  	cQuery += " WHERE C.C7_FILIAL = SC7.C7_FILIAL " + LF
  	cQuery += " AND C.C7_PRODUTO = SC7.C7_PRODUTO AND C.D_E_L_E_T_ = ''  " + LF
  	cQuery += " AND C.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY C.C7_EMISSAO DESC) C7UIPI " + LF + LF
  	
  	///ÚLTIMO ICM
  	cQuery += " ,(SELECT TOP 1 D.C7_VALICM FROM " + RetSqlName("SC7") + " D " + LF
  	cQuery += " WHERE D.C7_FILIAL = SC7.C7_FILIAL " + LF
  	cQuery += " AND D.C7_PRODUTO = SC7.C7_PRODUTO AND D.D_E_L_E_T_ = '' " + LF
  	cQuery += " AND D.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY D.C7_EMISSAO DESC) C7UICM " + LF + LF
  	
  	///ÚLTIMA CONDIÇÃO PAG
  	cQuery += " ,(SELECT TOP 1 E.C7_COND FROM " + RetSqlName("SC7") + " E " + LF
  	cQuery += " WHERE E.C7_FILIAL = SC7.C7_FILIAL " + LF
  	cQuery += " AND E.C7_PRODUTO = SC7.C7_PRODUTO AND E.D_E_L_E_T_ = ''  " + LF
  	cQuery += " AND E.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY E.C7_EMISSAO DESC) C7UCOND " + LF + LF
  	
  	///ÚLTIMO VAL FRETE
  	cQuery += " ,(SELECT TOP 1 F.C7_VALFRET FROM " + RetSqlName("SC7") + " F " + LF
  	cQuery += " WHERE F.C7_FILIAL = SC7.C7_FILIAL " + LF
  	cQuery += " AND F.C7_PRODUTO = SC7.C7_PRODUTO AND F.D_E_L_E_T_ = ''  " + LF
  	cQuery += " AND F.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY F.C7_EMISSAO DESC) C7UFRE " + LF + LF
  	
  	///ÚLTIMO PERCENTUAL JUROS
  	cQuery += " ,(SELECT TOP 1 G.C7_PEJUROS FROM " + RetSqlName("SC7") + " G " + LF
  	cQuery += " WHERE G.C7_FILIAL = SC7.C7_FILIAL " + LF
  	cQuery += " AND G.C7_PRODUTO = SC7.C7_PRODUTO AND G.D_E_L_E_T_ = ''  " + LF
  	cQuery += " AND G.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY G.C7_EMISSAO DESC) C7UJUR " + LF + LF
  	
  	///ÚLTIMO CUSTO TOTAL A VP
  	cQuery += " ,(SELECT TOP 1 (H.C8_CUSTIVP + H.C8_CUSTFVP)  FROM " + RetSqlName("SC8") + " H, " + LF
  	cQuery += " " + RetSqlname("SC7") + " X7 " + LF
  	cQuery += " WHERE H.C8_FILIAL = SC7.C7_FILIAL AND H.C8_FILIAL = X7.C7_FILIAL " + LF
  	cQuery += " AND H.C8_PRODUTO = SC7.C7_PRODUTO AND H.C8_PRODUTO = X7.C7_PRODUTO " + LF
  	cQuery += " AND H.D_E_L_E_T_ = '' " + LF
  	cQuery += " AND X7.D_E_L_E_T_ = '' " + LF
  	cQuery += " AND H.C8_NUMPED = X7.C7_NUM  AND H.C8_NUMPED NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY H.C8_EMISSAO DESC) C8UCTVP " + LF + LF
  	
  	///ÚLTIMO PEDIDO
  	cQuery += " ,(SELECT TOP 1 I.C7_NUM  FROM " + RetSqlName("SC7") + " I " + LF
  	cQuery += " WHERE I.C7_FILIAL = SC7.C7_FILIAL " + LF
  	cQuery += " AND I.C7_PRODUTO = SC7.C7_PRODUTO AND I.D_E_L_E_T_ = '' " + LF
  	cQuery += " AND I.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY I.C7_EMISSAO DESC) C7UPED " + LF + LF
  	
  	///EMISSAO DO ÚLTIMO PEDIDO
  	cQuery += " ,(SELECT TOP 1 J.C7_EMISSAO  FROM " + RetSqlName("SC7") + " J " + LF
  	cQuery += " WHERE J.C7_FILIAL = SC7.C7_FILIAL " + LF
  	cQuery += " AND J.C7_PRODUTO = SC7.C7_PRODUTO AND J.D_E_L_E_T_ = ''  " + LF
  	cQuery += " AND J.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY J.C7_EMISSAO DESC) C7UEMI " + LF + LF

  	///ÚLTIMO VALOR TOTAL
  	cQuery += " ,(SELECT TOP 1 K.C7_TOTAL FROM " + RetSqlName("SC7") + " K " + LF
  	cQuery += " WHERE K.C7_FILIAL = SC7.C7_FILIAL " + LF
  	cQuery += " AND K.C7_PRODUTO = SC7.C7_PRODUTO AND K.D_E_L_E_T_ = ''  " + LF
  	cQuery += " AND K.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY K.C7_EMISSAO DESC) C7UTOT " + LF + LF
	
	
	cQuery += " FROM " + RetSqlname("SC7") + " SC7 , " +LF
	cQuery += " " + RetSqlname("SC8") + " SC8, " +LF
	cQuery += " " + RetSqlname("SC1") + " SC1, " +LF
	cQuery += " " + RetSqlname("SB1") + " SB1, " +LF
	cQuery += " " + RetSqlname("SA2") + " SA2, " +LF
	cQuery += " " + RetSqlname("SE4") + " SE4 " +LF
	cQuery += " WHERE "
	cQuery += " SC7.C7_FILIAL = '" + cFil + "' AND "+LF
	cQuery += " SC7.C7_NUM = '" + cNumPed + "' "+LF
	
	cQuery += " AND SC8.C8_NUMPED = SC7.C7_NUM " +LF //NUM.PEDIDO
	cQuery += " AND SC8.C8_NUM    = SC7.C7_NUMCOT " +LF //NUM.COTAÇÃO
	cQuery += " AND SC8.C8_NUMSC  = SC1.C1_NUM " +LF    //NUM. SC
	cQuery += " AND SC8.C8_ITEMSC = SC1.C1_ITEM  " + LF //NUM. ITEM SC

	cQuery += " AND SC8.C8_FILIAL = SC7.C7_FILIAL " +LF
	cQuery += " AND SC8.C8_FILIAL = SC1.C1_FILIAL " +LF
	
	cQuery += " AND SC7.C7_NUMSC = SC1.C1_NUM " +LF
	cQuery += " AND SC7.C7_ITEMSC = SC1.C1_ITEM " +LF
	
	cQuery += " AND SC7.C7_FORNECE = SA2.A2_COD "+LF
	cQuery += " AND SC7.C7_LOJA = SA2.A2_LOJA "+LF
	cQuery += " AND SC7.C7_COND = SE4.E4_CODIGO "+LF
	cQuery += " AND SC7.C7_PRODUTO = SB1.B1_COD "+LF
	cQuery += " AND SC7.C7_FILIAL = '" + xFilial("SC7") + "' AND SC7.D_E_L_E_T_ = '' "+LF
	cQuery += " AND SC8.C8_FILIAL = '" + xFilial("SC8") + "' AND SC8.D_E_L_E_T_ = '' "+LF
	cQuery += " AND SC1.C1_FILIAL = '" + xFilial("SC1") + "' AND SC1.D_E_L_E_T_ = '' "+LF
	cQuery += " AND SA2.D_E_L_E_T_ = '' "+LF
	cQuery += " AND SE4.D_E_L_E_T_ = '' "+LF
	cQuery += " ORDER BY C7_NUM, C7_ITEM "+LF
	
	Memowrite("C:\TEMP\MT160WF.SQL",cQuery) 
	
	If Select("TMPC7") > 0
		DbSelectArea("TMPC7")
		DbCloseArea()	
	EndIf

	TCQUERY cQuery NEW ALIAS "TMPC7" 
	TCSetField( "TMPC7" , "C7UEMI", "D")

	TMPC7->(DbGoTop())
	If !TMPC7->(EOF())
		//MSGBOX("ENTROU NA QUERY")
		While TMPC7->(!EOF())
		
			aPedido		:= {}
			dEmi		:= TMPC7->C7_EMISSAO 
			cPedido		:= TMPC7->C7_NUM
			cSolic		:= TMPC7->C1_USER
			cNomSolic	:= ""
			xCond		:= TMPC7->C7_COND
			xCondicao	:= TMPC7->E4_DESCRI
			cNomFor		:= TMPC7->A2_NREDUZ
			cNumSC      := TMPC7->C1_NUM
				
			PswOrder(1)
			If PswSeek( cSolic, .T. )											
			   aUsu   := PSWRET() 					
			   cNomSolic:= Alltrim( aUsu[1][2] )      
			   eEmail := Alltrim( aUsu[1][14] )  ///e-mail do solicitante   
			Endif
			
			nTotGer += TMPC7->C7_TOTAL
			
			aadd( aPedido, { TMPC7->C7_ITEM,;  		//1
			      			 TMPC7->C7_PRODUTO,;	//2
			       			 TMPC7->B1_DESC,;   	//3
			   			     TMPC7->C7_QUANT,;  	//4
			   			     TMPC7->C7_PRECO,;    	//5
			   			     TMPC7->C7_TOTAL  } ) 	//6
				
			For _nX := 1 to len(aPedido)
		      
		      aadd( oHtml:ValByName("it.cItem")  , aPedido[_nX,1] )        	//ITEM
		      aadd( oHtml:ValByName("it.cProd")  , aPedido[_nX,2] )      	//COD. PRODUTO
		      aadd( oHtml:ValByName("it.cDesc")  , aPedido[_nX,3] )       	//DESCRIÇÃO PRODUTO
		      aadd( oHtml:ValByName("it.nQtde") , aPedido[_nX,4] )     		//QTDE
		      aadd( oHtml:ValByName("it.nValUni"), Transform(aPedido[_nX,5], "@E 999,999.99") )         //VALOR UNITÁRIO
		      aadd( oHtml:ValByName("it.nValTot"), Transform(aPedido[_nX,6], "@E 999,999.99") )	       	//VALOR TOTAL
		      
			Next _nX
	
	
			DbselectArea("TMPC7")
			TMPC7->(DBSKIP())
		
		Enddo
    Else
    	    MSGBOX("Antes restarea: cNumPed - " + cNumPed + " SC7->C7_NUM - " + SC7->C7_NUM)
    	    RestArea(aAreaSC7)
    	    MSGBOX("DEPOIS restarea: cNumPed - " + cNumPed + " SC7->C7_NUM - " + SC7->C7_NUM)
    	    //cNumPed	:= SC7->C7_NUM
    	    //MSGBOX("Antes rest area: cNumPed - " + cNumPed + " SC7->C7_NUM - " + SC7->C7_NUM)
    	    SC7->(Dbsetorder(1))
    	    If SC7->(Dbseek(xFilial("SC7") + cNumPed ))
	    	    aPedido := {}
	    	    While !SC7->(EOF()) .AND. SC7->C7_FILIAL == xFilial("SC7") .AND. SC7->C7_NUM == cNumPed
		    		DbselectArea("SC1")
		    		SC1->(Dbsetorder(1))
		    		SC1->(Dbseek(xFilial("SC1") + SC7->C7_NUMSC ))
		    		cSolic		:= SC1->C1_USER		    		
		    		
					dEmi		:= SC7->C7_EMISSAO 
					cPedido		:= SC7->C7_NUM			
					xCond		:= SC7->C7_COND
					DbselectArea("SE4")
		    		SE4->(Dbsetorder(1))
		    		SE4->(Dbseek(xFilial("SE4") + xCond ))
					xCondicao	:= SE4->E4_DESCRI
					
					DbselectArea("SA2")
		    		SA2->(Dbsetorder(1))
		    		SA2->(Dbseek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA ))
					cNomFor		:= SA2->A2_NREDUZ
					
					SB1->(Dbsetorder(1))
					SB1->(Dbseek(xFilial("SB1") + SC7->C7_PRODUTO ))
						
					PswOrder(1)
					If PswSeek( cSolic, .T. )											
					   aUsu   := PSWRET() 					
					   cNomSolic:= Alltrim( aUsu[1][2] )      
					   eEmail := Alltrim( aUsu[1][14] )    ///e-mail do solicitante 
					Endif
					
					nTotGer += SC7->C7_TOTAL
					
					aadd( aPedido, { SC7->C7_ITEM,;  		//1
					      			 SC7->C7_PRODUTO,;	//2
					       			 SB1->B1_DESC,;   	//3
					   			     SC7->C7_QUANT,;  	//4
					   			     SC7->C7_PRECO,;    	//5
					   			     SC7->C7_TOTAL  } ) 	//6
		    
		    		
					SC7->(DBSKIP())
				Enddo
				For _nX := 1 to len(aPedido)
				      
				      aadd( oHtml:ValByName("it.cItem")  , aPedido[_nX,1] )        	//ITEM
				      aadd( oHtml:ValByName("it.cProd")  , aPedido[_nX,2] )      	//COD. PRODUTO
				      aadd( oHtml:ValByName("it.cDesc")  , aPedido[_nX,3] )       	//DESCRIÇÃO PRODUTO
				      aadd( oHtml:ValByName("it.nQtde") , aPedido[_nX,4] )     		//QTDE
				      aadd( oHtml:ValByName("it.nValUni"), Transform(aPedido[_nX,5], "@E 999,999.99") )         //VALOR UNITÁRIO
				      aadd( oHtml:ValByName("it.nValTot"), Transform(aPedido[_nX,6], "@E 999,999.99") )	       	//VALOR TOTAL
				      
					Next _nX	
            Else 
            	MSGBOX("PEDIDO NÃO ENCONTRADO: " + cNumPed)
            Endif
    Endif

cNome  := ""		
cMail  := ""     
cDepto := ""
PswOrder(1)
If PswSeek( __CUSERID, .T. )
	aUsers := PSWRET() 						// Retorna vetor com informações do usuário	   
   	cNome := Alltrim(aUsers[1][4])		// Nome completo do usuário logado
   	cMail := Alltrim(aUsers[1][14])     // e-mail do usuário logado
	cDepto:= aUsers[1][12]  //Depto do usuário logado	
Endif    
oProcess:cTo:= eEmail      //email do solicitante
oProcess:cTo+= ";" + cMail //email do usuário que gerou o pedido

cMailCopia	:= GetNewPar("MV_XMT160",'giancarlo.sousa@ravaembalagens.com.br')

iF Len(cMailCopia) > 2
	
	oProcess:cTo+= ";" + cMailCopia //email doutros usuarios

EndIf

//oProcess:cTo+= ";flavia.rocha@ravaembalagens.com.br" 
//oHtml:ValByName("dEmissao",Dtoc(dEmi))
oHtml:ValByName("cSolici",cNomSolic)
oHtml:ValByName("cCondicao",xCondicao)
oHtml:ValByName("cFornece",cNomFor)
oHtml:ValByName("nTotGer", Transform(nTotGer,"@E 999,999.99") )

// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
// de destinatários.
oProcess:Start()
WfSendMail()
//msginfo("enviou email 1")	

//dbclosearea("TMPC7")

///////////////////////////////////////////////////////////////////////////////
////ANÁLISE DE COMPRAS - EMAIL
////FR - 01/08/13
////ENVIO DO EMAIL PARA MARCELO/ORLEY SOBRE A ANÁLISE DO PEDIDO COMPRA GERADO  
///////////////////////////////////////////////////////////////////////////////

//03/04/14 - ORLEY SOLICITOU NÃO MAIS RECEBER ESTE EMAIL, NEM ELE, NEM MARCELO
/*
	
	// Monte uma descrição para o assunto:
	cAssunto := "**Análise de Compras - Novo P.C. Nro: " + cNumPed
	
	oProcess:=TWFProcess():New("MT160WF","MT160WF")
	oProcess:NewTask('Inicio',"\workflow\http\oficial\MT160WF.html")	
	//oProcess:NewTask('Inicio',"\workflow\http\teste\MT160WF.html")	
	oHtml := oProcess:oHTML                                         
	
	cCabeca := "Análise do Pedido Compra Gerado"
	cTexto  := "Prezado(s), Segue Abaixo, a ANÁLISE do Pedido de Compra: " + cNumped + ", Em Virtude do Processo de Cotação para Compras." + CHR(13) + CHR(10)
	
	oHtml:ValByName("Cabeca",cCabeca)
	
	
	cNome  := ""		
	cMail  := ""     
	cDepto := ""
	PswOrder(1)
	If PswSeek( __CUSERID, .T. )
		aUsers := PSWRET() 						// Retorna vetor com informações do usuário	   
	   	cNome := Alltrim(aUsers[1][4])		// Nome completo do usuário logado
	   	cMail := Alltrim(aUsers[1][14])     // e-mail do usuário logado
		cDepto:= aUsers[1][12]  //Depto do usuário logado	
	Endif
	oHtml:ValByName("cUser"  , cNome )	//usuário logado que atualizou
	oHtml:ValByName("cDepto" , cDepto )	//nome do Depto
	oHtml:ValByName("cMail"  , cMail )	//email
	
	
	DbselectArea("TMPC7")	
	TMPC7->(DbGoTop())
	If !TMPC7->(EOF())
		//MSGBOX("ENTROU NA QUERY")
		While TMPC7->(!EOF())
		
			cSolic		:= TMPC7->C1_USER
			cNomSolic	:= ""
			xCond		:= TMPC7->C7_COND
			xCondicao	:= TMPC7->E4_DESCRI
			cNomFor		:= TMPC7->A2_NREDUZ
		    
				
		      ///DADOS DA COMPRA ATUAL
		      aadd( oHtml:ValByName("it.cPC")  , TMPC7->C7_NUM )        	//PEDIDO
		      aadd( oHtml:ValByName("it.cItem")  , TMPC7->C7_ITEM )        	//ITEM
		      aadd( oHtml:ValByName("it.cProd")  , TMPC7->C7_PRODUTO )      	//COD. PRODUTO
		      aadd( oHtml:ValByName("it.cDescProd")  , TMPC7->B1_DESC )       	//DESCRIÇÃO PRODUTO
		      aadd( oHtml:ValByName("it.nPreco") , Transform(TMPC7->C7_PRECO, "@E 999,999.9999") )     		//PREÇO UNITÁRIO
		      aadd( oHtml:ValByName("it.nValTot") , Transform(TMPC7->C7_TOTAL, "@E 999,999.99") )     		//TOTAL COMPRA
		      
		      aadd( oHtml:ValByName("it.cVaria") , cAnalise )     		//Análise da Variação
		      
		      aadd( oHtml:ValByName("it.nValIPI"), Transform(TMPC7->C7_VALIPI, "@E 999,999.99") )         //VALOR IPI
		      aadd( oHtml:ValByName("it.nValICM"), Transform(TMPC7->C7_VALICM, "@E 999,999.99") )         //VALOR ICM
		      aadd( oHtml:ValByName("it.cPrzPag"), xCondicao )	       	//condição pagamento                         
		      aadd( oHtml:ValByName("it.nValFre"), Transform(TMPC7->C7_VALFRET, "@E 999,999.99") )         //VALOR FRETE
		      aadd( oHtml:ValByName("it.nJurMes"), Transform(TMPC7->C7_PEJUROS, "@E 999,999.99") )         //%JUROS
		      aadd( oHtml:ValByName("it.nCVP"), Transform(TMPC7->C8CTVP, "@E 999,999.99") )         //CUSTO TOTAL A VP
		      
		      ///DADOS DA ÚLTIMA COMPRA 
		      xCond := TMPC7->C7UCOND		
		      SE4->(Dbsetorder(1))
		      SE4->(Dbseek(xFilial("SE4") + xCond ))
		      xCondicao := SE4->E4_DESCRI
		      
		      aadd( oHtml:ValByName("it.dUltima") , Dtoc(TMPC7->C7UEMI) )     		//EMISSAO
		      aadd( oHtml:ValByName("it.cUltFOR") , TMPC7->C7UFOR )     		//FORNECEDOR
		      aadd( oHtml:ValByName("it.nUltPre") , Transform(TMPC7->C7UPRE, "@E 999,999.9999") )     		//PREÇO UNITÁRIO
		      aadd( oHtml:ValByName("it.nUltTot") , Transform(TMPC7->C7UTOT, "@E 999,999.99") )     		//VALOR TOTAL
		      //aadd( oHtml:ValByName("it.nQtde") , aPedido[_nX,4] )     		//QTDE
		      aadd( oHtml:ValByName("it.nUltIPI"), Transform(TMPC7->C7UIPI, "@E 999,999.99") )         //VALOR IPI
		      aadd( oHtml:ValByName("it.nUltICM"), Transform(TMPC7->C7UICM, "@E 999,999.99") )         //VALOR ICM
		      aadd( oHtml:ValByName("it.cUltPrz"), xCondicao )	       	//condição pagamento                         
		      aadd( oHtml:ValByName("it.nUltVFRE"), Transform(TMPC7->C7UFRE, "@E 999,999.99") )         //VALOR FRETE
		      aadd( oHtml:ValByName("it.nUltJU"), Transform(TMPC7->C7UJUR, "@E 999,999.99") )         //%JUROS
		      aadd( oHtml:ValByName("it.nUltCVP"), Transform(TMPC7->C8UCTVP, "@E 999,999.99") )         //CUSTO TOTAL A VP
		
	
	
			DbselectArea("TMPC7")
			TMPC7->(DBSKIP())
		
		Enddo
		cTexto  += "Fornecedor Vencedor: " + cNomFor
		oHtml:ValByName("cMsg",cTexto)
   		dbclosearea("TMPC7")    
    Else
    	//ALERT("SEM DADOS")
    	aUlt := {}
    	SC7->(Dbsetorder(1))
        If SC7->(Dbseek(xFilial("SC7") + cNumPed ))
	   	
	   	    While !SC7->(EOF()) .AND. SC7->C7_FILIAL == xFilial("SC7") .AND. SC7->C7_NUM == cNumPed 
	   	    	aUlt := {}
	   	    	SC1->(Dbsetorder(1))
	   	    	SC1->(Dbseek(xFilial("SC1") + SC7->C7_NUMSC ))
	   	    		cSolic		:= SC1->C1_USER
				
				cNomSolic	:= ""
				xCond		:= SC7->C7_COND
				SE4->(Dbsetorder(1))
		      	SE4->(Dbseek(xFilial("SE4") + xCond ))
				xCondicao	:= SE4->E4_DESCRI
				
				SA2->(Dbsetorder(1))
				SA2->(Dbseek(xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA ))
				cNomFor		:= SA2->A2_NREDUZ
		    
				SB1->(Dbsetorder(1))
				SB1->(Dbseek(xFilial("SB1") + SC7->C7_PRODUTO ))
				
				SC8->(DbsetOrder(1))
				nCTVP := 0
				IF SC8->(Dbseek(xFilial("SC8") + SC1->C1_COTACAO ))
					nCTVP := round((SC8->C8_CUSTIVP + SC8->C8_CUSTFVP),2)
				ENDIF
		      ///DADOS DA COMPRA ATUAL
		      aadd( oHtml:ValByName("it.cPC")  , SC7->C7_NUM )        	//PEDIDO
		      aadd( oHtml:ValByName("it.cItem")  , SC7->C7_ITEM )        	//ITEM
		      aadd( oHtml:ValByName("it.cProd")  , SC7->C7_PRODUTO )      	//COD. PRODUTO
		      aadd( oHtml:ValByName("it.cDescProd")  , SB1->B1_DESC )       	//DESCRIÇÃO PRODUTO
		      aadd( oHtml:ValByName("it.nPreco") , Transform(SC7->C7_PRECO, "@E 999,999.9999") )     		//PREÇO UNITÁRIO
   		      aadd( oHtml:ValByName("it.nValTot") , Transform(SC7->C7_TOTAL, "@E 999,999.99") )     		//VALOR TOTAL
		      
		      aadd( oHtml:ValByName("it.cVaria") , cAnalise )     		//Análise da Variação
		      
		      aadd( oHtml:ValByName("it.nValIPI"), Transform(SC7->C7_VALIPI, "@E 999,999.99") )         //VALOR IPI
		      aadd( oHtml:ValByName("it.nValICM"), Transform(SC7->C7_VALICM, "@E 999,999.99") )         //VALOR ICM
		      aadd( oHtml:ValByName("it.cPrzPag"), xCondicao )	       	//condição pagamento                         
		      aadd( oHtml:ValByName("it.nValFre"), Transform(SC7->C7_VALFRET, "@E 999,999.99") )         //VALOR FRETE
		      aadd( oHtml:ValByName("it.nJurMes"), Transform(SC7->C7_PEJUROS, "@E 999,999.99") )         //%JUROS
		      aadd( oHtml:ValByName("it.nCVP"), Transform(nCTVP, "@E 999,999.99") )         //CUSTO TOTAL A VP
		      
		      ///DADOS DA ÚLTIMA COMPRA 
		      //Aadd( aResult, { TMPC8->C7UCOND, TMPC8->C7UPRE, TMPC8->C7UIPI, TMPC8->C7UICM , TMPC8->C7UFRE, TMPC8->C7UJUR, TMPC8->C8UCTVP } )
		      aUlt := fUltC7( SC7->C7_PRODUTO )  
		      xCond := ""
		      xCondicao := ""
		      cUFOR := ""
		      nUPRE := 0
		      nUTOT := 0
		      nUIPI := 0
		      nUICM := 0
		      nUFRE := 0
		      nUJUR := 0
		      nUCTVP:= 0
		      dUEmi := Ctod("  /  /    ")
		      
		      If Len(aUlt) > 0
		      	xCondicao := aUlt[1,1]
			    nUPRE := aUlt[1,2]
			    nUIPI := aUlt[1,3]
			    nUICM := aUlt[1,4]
			    nUFRE := aUlt[1,5]
			    nUJUR := aUlt[1,6]
			    nUCTVP:= aUlt[1,7]
			    cUFOR := aUlt[1,8]
			    dUEmi := aUlt[1,9]
			    nUTOT := aUlt[1,10]
		      Endif
		      
		      aadd( oHtml:ValByName("it.dUltima") , Dtoc(dUEmi) )     		//EMISSAO		      
		      aadd( oHtml:ValByName("it.cUltFOR") , cUFOR )     		//NOME REDUZ. FORNECEDOR
		      aadd( oHtml:ValByName("it.nUltPre") , Transform(nUPRE, "@E 999,999.9999") )     		//PREÇO UNITÁRIO
		      aadd( oHtml:ValByName("it.nUltTot") , Transform(nUTOT, "@E 999,999.99") )     		//VALOR TOTAL
		      aadd( oHtml:ValByName("it.nUltIPI"), Transform(nUIPI, "@E 999,999.99") )         //VALOR IPI
		      aadd( oHtml:ValByName("it.nUltICM"), Transform(nUICM, "@E 999,999.99") )         //VALOR ICM
		      aadd( oHtml:ValByName("it.cUltPrz"), xCondicao )	       	//condição pagamento                         
		      aadd( oHtml:ValByName("it.nUltVFRE"), Transform(nUFRE, "@E 999,999.99") )         //VALOR FRETE
		      aadd( oHtml:ValByName("it.nUltJU"), Transform(nUJUR, "@E 999,999.99") )         //%JUROS
		      aadd( oHtml:ValByName("it.nUltCVP"), Transform(nUCTVP, "@E 999,999.99") )         //CUSTO TOTAL A VP
	   	    
	   	    
	   	    	SC7->(Dbskip())
	   	    Enddo
	   		cTexto  += "Fornecedor Vencedor: " + cNomFor
			oHtml:ValByName("cMsg",cTexto)
	   	Endif //dbseek no C7
    Endif
    oProcess:cSubject  := cAssunto
	oProcess:cTo := cDestDIR //destinatários do email estão dentro do parâmetro RV_MT160WF
	//oProcess:cTo:= "flavia.rocha@ravaembalagens.com.br" //retirar

	// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
	// de destinatários.
	//oProcess:Start()
	//WfSendMail()
	//FR - 03/04/14 - ORLEY SOLICITOU NÃO ENVIAR MAIS ESTE EMAIL PARA ELE, NEM PARA MARCELO, POIS NÃO ESTÃO TENDO TEMPO DE ANALISAR
*/



Return

****************************
 Static Function fUltC7 ( cProd )  
****************************
//captura informações do último pedido para aquele produto
Local cQuery := ""
Local LF     := CHR(13) + CHR(10) 
Local aResult:= {}
    //ALERT("DADOS ÚLTIMA COMPRA")
    
 	///ÚLTIMO PRODUTO
 	cQuery := " Select " + LF
	cQuery += " (SELECT TOP 1 A.C7_PRODUTO FROM " + RetSqlName("SC7") + " A " + LF
	cQuery += " WHERE A.C7_FILIAL = SC7.C7_FILIAL " + LF
  	cQuery += " AND A.C7_PRODUTO = SC7.C7_PRODUTO AND A.D_E_L_E_T_ = ''  ORDER BY A.C7_EMISSAO DESC) C7UPROD " + LF
  	
  	///ÚLTIMO FORNECEDOR
  	cQuery += " ,(SELECT TOP 1 A2.A2_NREDUZ  FROM " + RetSqlName("SC7") + " L , " + RetSqlName("SA2") + " A2 " + LF
  	cQuery += " WHERE L.C7_FILIAL = SC7.C7_FILIAL AND L.C7_FORNECE = A2.A2_COD AND L.C7_LOJA = A2.A2_LOJA " + LF
  	cQuery += " AND L.C7_PRODUTO = SC7.C7_PRODUTO AND L.D_E_L_E_T_ = ''  and L.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF 
  	cQuery += " ORDER BY L.C7_EMISSAO DESC) C7UFOR " + LF
  	
  	///ÚLTIMO PREÇO
  	cQuery += " ,(SELECT TOP 1 B.C7_PRECO FROM " + RetSqlName("SC7") + " B " + LF
  	cQuery += " WHERE B.C7_FILIAL = SC7.C7_FILIAL and B.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF
  	cQuery += " AND B.C7_PRODUTO = SC7.C7_PRODUTO AND B.D_E_L_E_T_ = ''  ORDER BY B.C7_EMISSAO DESC) C7UPRE " + LF
  	
  	///ÚLTIMO IPI
  	cQuery += " ,(SELECT TOP 1 C.C7_VALIPI FROM " + RetSqlName("SC7") + " C " + LF
  	cQuery += " WHERE C.C7_FILIAL = SC7.C7_FILIAL and C.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF 
  	cQuery += " AND C.C7_PRODUTO = SC7.C7_PRODUTO AND C.D_E_L_E_T_ = ''  ORDER BY C.C7_EMISSAO DESC) C7UIPI " + LF
  	
  	///ÚLTIMO ICM
  	cQuery += " ,(SELECT TOP 1 D.C7_VALICM FROM " + RetSqlName("SC7") + " D " + LF
  	cQuery += " WHERE D.C7_FILIAL = SC7.C7_FILIAL and D.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF 
  	cQuery += " AND D.C7_PRODUTO = SC7.C7_PRODUTO AND D.D_E_L_E_T_ = ''  ORDER BY D.C7_EMISSAO DESC) C7UICM " + LF
  	
  	///ÚLTIMA CONDIÇÃO PAG
  	cQuery += " ,(SELECT TOP 1 E4.E4_DESCRI FROM " + RetSqlName("SC7") + " E, " + RetSqlname("SE4") + " E4 " + LF
  	cQuery += " WHERE E.C7_FILIAL = SC7.C7_FILIAL AND E.C7_COND = E4.E4_CODIGO and E.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF 
  	cQuery += " AND E.C7_PRODUTO = SC7.C7_PRODUTO AND E.D_E_L_E_T_ = ''  AND E4.D_E_L_E_T_ = '' ORDER BY E.C7_EMISSAO DESC) C7UCOND " + LF
  	
  	///ÚLTIMO VAL FRETE
  	cQuery += " ,(SELECT TOP 1 F.C7_VALFRET FROM " + RetSqlName("SC7") + " F " + LF
  	cQuery += " WHERE F.C7_FILIAL = SC7.C7_FILIAL and F.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF 
  	cQuery += " AND F.C7_PRODUTO = SC7.C7_PRODUTO AND F.D_E_L_E_T_ = ''  ORDER BY F.C7_EMISSAO DESC) C7UFRE " + LF
  	
  	///ÚLTIMO PERCENTUAL JUROS
  	cQuery += " ,(SELECT TOP 1 G.C7_PEJUROS FROM " + RetSqlName("SC7") + " G " + LF
  	cQuery += " WHERE G.C7_FILIAL = SC7.C7_FILIAL and G.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF 
  	cQuery += " AND G.C7_PRODUTO = SC7.C7_PRODUTO AND G.D_E_L_E_T_ = ''  ORDER BY G.C7_EMISSAO DESC) C7UJUR " + LF
  	
  	///ÚLTIMO CUSTO TOTAL A VP
  	//cQuery += " ,(SELECT TOP 1 (H.C8_CUSTIVP + H.C8_CUSTFVP)  FROM " + RetSqlName("SC8") + " H " + LF
  	//cQuery += " WHERE H.C8_FILIAL = SC7.C7_FILIAL AND H.C8_NUMPED = SC7.C7_NUM " + LF
  	//cQuery += " AND H.C8_PRODUTO = SC7.C7_PRODUTO AND H.D_E_L_E_T_ = ''  ORDER BY H.C8_EMISSAO DESC) C8UCTVP " + LF
  	
  	///ÚLTIMO CUSTO TOTAL A VP
  	cQuery += " ,(SELECT TOP 1 (H.C8_CUSTIVP + H.C8_CUSTFVP)  FROM " + RetSqlName("SC8") + " H, " + LF
  	cQuery += " " + RetSqlname("SC7") + " X7 " + LF
  	cQuery += " WHERE H.C8_FILIAL = X7.C7_FILIAL " + LF
  	cQuery += " AND H.C8_PRODUTO = SC7.C7_PRODUTO AND H.C8_PRODUTO = X7.C7_PRODUTO " + LF
  	cQuery += " AND H.D_E_L_E_T_ = '' " + LF
  	cQuery += " AND X7.D_E_L_E_T_ = '' " + LF
  	cQuery += " AND H.C8_NUMPED = X7.C7_NUM  AND H.C8_NUMPED NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY H.C8_EMISSAO DESC) C8UCTVP " + LF
  	
  	///ÚLTIMO PEDIDO
  	//cQuery += " ,(SELECT TOP 1 I.C7_NUM  FROM " + RetSqlName("SC7") + " I " + LF
  	//cQuery += " WHERE I.C7_FILIAL = SC7.C7_FILIAL " + LF
  	//cQuery += " AND I.C7_PRODUTO = SC7.C7_PRODUTO AND I.D_E_L_E_T_ = ''  ORDER BY I.C7_EMISSAO DESC) C7UPED " + LF
  	
  	///EMISSAO DO ÚLTIMO PEDIDO
  	cQuery += " ,(SELECT TOP 1 J.C7_NUM  FROM " + RetSqlName("SC7") + " J " + LF
  	cQuery += " WHERE J.C7_FILIAL = SC7.C7_FILIAL  and J.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF 
  	cQuery += " AND J.C7_PRODUTO = SC7.C7_PRODUTO AND J.D_E_L_E_T_ = ''  ORDER BY J.C7_EMISSAO DESC) C7UEMI " + LF
  	
  	///ÚLTIMO VALOR TOTAL
  	cQuery += " ,(SELECT TOP 1 K.C7_TOTAL FROM " + RetSqlName("SC7") + " K " + LF
  	cQuery += " WHERE K.C7_FILIAL = SC7.C7_FILIAL " + LF
  	cQuery += " AND K.C7_PRODUTO = SC7.C7_PRODUTO AND K.D_E_L_E_T_ = ''  " + LF
  	cQuery += " AND K.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
  	cQuery += " ORDER BY K.C7_EMISSAO DESC) C7UTOT " + LF + LF
  		
	cQuery += " FROM " + RetSqlname("SC7") + " SC7 " +LF
	
	cQuery += " WHERE "
	cQuery += " SC7.C7_FILIAL = '" + xFilial("SC7") + "' "+LF
	cQuery += " AND SC7.C7_NUM NOT IN ('"+ cNumped + "' ) " + LF  //SENÃO ,ELE PEGA O MESMO PEDIDO QUE ESTÁ SENDO GERADO
	cQuery += " AND SC7.C7_PRODUTO = '" + cProd + "' "+LF
	
	cQuery += " AND SC7.C7_FILIAL = '" + xFilial("SC7") + "' AND SC7.D_E_L_E_T_ = '' "+LF
	cQuery += " GROUP BY SC7.C7_FILIAL, SC7.C7_PRODUTO  "+LF
	
	Memowrite("C:\TEMP\fultimoc7.SQL",cQuery) 
	If Select("TMPC8") > 0
		DbSelectArea("TMPC8")
		DbCloseArea()	
	EndIf

	TCQUERY cQuery NEW ALIAS "TMPC8" 
	TCSetField( "TMPC8" , "C7UEMI", "D")
	TMPC8->(DbGoTop())
	If !TMPC8->(EOF())
		/*
		xCond := ""
	    xCondicao := ""		
	    nUPRE := 0
	    nUIPI := 0
	    nUICM := 0
	    nUFRE := 0
	    nUJUR := 0
	    nUCTVP:= 0
		*/      
		
		While TMPC8->(!EOF())
			//ALERT("ULT FOR: " + TMPC8->C7UFOR)
		    Aadd( aResult, { TMPC8->C7UCOND, TMPC8->C7UPRE, TMPC8->C7UIPI, TMPC8->C7UICM , TMPC8->C7UFRE, TMPC8->C7UJUR, TMPC8->C8UCTVP, TMPC8->C7UFOR, TMPC8->C7UEMI } )
			TMPC8->(Dbskip())
		Enddo
	Endif
	
Return(aResult)