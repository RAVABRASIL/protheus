#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*  
//////////////////////////////////////////////////////////////////////////////////////////////
//Programa: MTA097 : Após a confirmação da liberação do documento, 
//                   deve ser utilizado para executar uma validação 
//                   do usuario na liberação a fim de interromper ou bloquear processo.
//Autoria : Flávia Rocha
//Data    : 04/06/2012
//////////////////////////////////////////////////////////////////////////////////////////////
*/             

User Function MTA097


Local lRet 		:= .F.   //variável que irá bloquear ou permitir o processo de liberação de docto.
Local cProd		:= ""    //variável que armazena o código do produto
Local cPC  		:= ""    //variável que armazena o número do pedido de compra
Local cTipDoc 	:= ""    //variável que armazena o tipo do documento (PC ou NF)
Local cNF    	:= ""    //variável que armazena o número da NF
Local cSeriNF	:= ""    //variável que armazena a série da NF
Local cItemPC   := ""    //variável que armazena o item do pedido
Local nQuant    := 0     //variável que armazena a qtde do item no pedido
Local nPreco    := 0	 //variável que armazena o preço unitário do item no pedido
Local nTotal    := 0	 //variável que armazena o valor total do pedido
Local nValipi   := 0 	 //variável que armazena o valor do ipi no item do pedido
Local nipi      := 0	 //variável que armazena a aliq. do ipi no item do pedido
Local cFornece  := ""	 //variável que armazena o código do fornecedor
Local cLojaFor  := ""	 //variável que armazena a loja do fornecedor 
Local cCondNF   := ""	 //variável que armazena a condição de pagto 
Local lInspeciona := .F. //variável que marca qdo algum item da nf é sujeito à inspeção
Local aNFE		:= {}    //array com os itens da NF
Local cChave    := ""    //código da chave no ambiente de inspeção Qualidade 
Local lINSPNEG  := .F.   //variável lógica que indica se a inspeção foi realizada e positiva
Local cSituaca  := ""    //variável que armazenará a msg de que não houve inspeção / ou inspeção negativa
Local datadigi  := Ctod("  /  /    ") //variável que armazenará a data da digitação da NF
Local cQuery    := ""
Local LF		:= CHR(13) + CHR(10) 
Local cUser     := __CUSERID  //irá armazenar o código do usuário logado
Local cCRUser   := ""
Local lSCR      := .F.
Local aUserCQ  := {}
Local aUserFR  := {}


//VARIÁVEIS LÓGICAS QUE INDICAM DIVERGÊNCIA ENTRE PC x NF
Local lDiverg   := .F.     	//DIVERGÊNCIA GERAL
Local lDivQ 	:= .F.		//DIVERGÊNCIA QTDE
Local lDivP		:= .F.		//DIVERGÊNCIA PREÇO UNITÁRIO 
Local lDivPG	:= .F.		//DIVERGÊNCIA COND. PAGTO 
Local lDivTot	:= .F.		//DIVERGÊNCIA VALOR TOTAL
Local lDivipi   := .F.		//DIVERGÊNCIA IPI (VALOR OU ALIQ.)
Local lDivF		:= .F.    	//DIVERGÊNCIA VLR. FRETE
Local cQuemPode := ""   //armazena o(s) nome(s) da(s) pessoa(s) que pode(m) liberar o docto em caso de divergência
Local cMsg		:= ""  //mensagem sobre qual diverência entre NF x PC ocorreu  
Local cAux 		:= ""  //var caracter auxiliar
Local aArea		:= getArea()

cTipDoc := SCR->CR_TIPO
cNF		:= Substr(SCR->CR_NUM,1,9)
cSeriNF := Substr(SCR->CR_NUM,10,3)
cFornece:= Substr(SCR->CR_NUM,13,6)
cLojaFor:= Substr(SCR->CR_NUM,19,2)

lFrete:=.F.

If Alltrim(cTipDoc) = "NF"  //SE FOR Nota Fiscal
	
	
	Z86->(Dbsetorder(1))
	///verifica se é NF frete:
	If Z86->( dbSeek( xFilial( "Z86" ) + cNF + cSeriNF + cFornece + cLojaFor  ) )
       lFrete:=.T.
    Endif
	
	
	SF1->(DBSetorder(1))
	If SF1->(Dbseek(xFilial("SF1") + cNF + cSeriNF + cFornece + cLojaFor ))   //localiza no SF1, a NF, para pegar a condição de pagto
		cCondNF := SF1->F1_COND  
		datadigi:= SF1->F1_DTDIGIT	
		nValfrete:= SF1->F1_VALFRET
	
		cQuery := " Select * from " + RetSqlName("SD1") + " SD1 " + LF
		cQuery += " Where D1_DOC = '" + Alltrim(cNF) + "' " + LF
		cQuery += " and D1_SERIE= '" + Alltrim(cSeriNF) + "' " + LF
		cQuery += " and D1_FORNECE = '" + Alltrim(cFornece) + "' " + LF
		cQuery += " and D1_LOJA    = '" + Alltrim(cLojaFor) + "' " + LF	
		cQuery += " and D1_FILIAL  = '" + Alltrim(xFilial("SD1"))  + "' " + LF
		cQuery += " and D_E_L_E_T_ = '' " + LF
		cQuery += " ORDER BY D1_ITEM " + LF
		
		MemoWrite("C:\Temp\LOCALD1.sql", cQuery)			
		If Select("SD1X") > 0
			DbSelectArea("SD1X")
			DbCloseArea()
		EndIf
		TCQUERY cQuery NEW ALIAS "SD1X"
		//TCSetField( 'SD1X', "D1_DTDIGIT", "D" )				
		SD1X->( DBGoTop() )			
		If !SD1X->(EOF())
			Do While !SD1X->( Eof() )
				SB1->(Dbsetorder(1))
				If SB1->(Dbseek(xFilial("SB1") + SD1X->D1_COD ))
					If Alltrim(SB1->B1_RAVACQ) = "S"
						lInspeciona := .T.		   //localiza o produto da nota e verifica se o mesmo deve receber inspeção de qualidade			
					Endif
				Endif
				
				//ESTE LOOP É SÓ PARA ADICIONAR OS DADOS NO aNFE para comparativo de divergência entre NF x PC
				cPC     := SD1X->D1_PEDIDO
				cItemPC := SD1X->D1_ITEMPC
				nQuant  := SD1X->D1_QUANT
				nPreco  := SD1X->D1_VUNIT
				nTotal  := SD1X->D1_TOTAL
				nValipi := SD1X->D1_VALIPI
				nipi    := SD1X->D1_IPI

				
				Aadd(aNFE, { cPC, cItemPC, nQuant, nPreco, cCondNF, nTotal, nValipi, nipi, nValfrete } )   //Armazena no array de itens da NF, para comparar com o pedido	 
							
		        SD1X->(DBSKIP())
   			Enddo
   			DbSelectArea("SD1X")
			DbCloseArea()	
		Else
			msgbox("MTA097 - nf não localizada: " + cNF)
		Endif	//endif do seek no SD1	
	
		If lInspeciona	
			
		    ///////////////////////////////////////////////////////////////////////////////////////////////////	        
		    ///procura no ambiente de inspeção se: existe registro de inspeção , e se o mesmo foi positivo	
			///se encontrar registro de inspeção e o mesmo for negativo, lINSPNEG = .T.
			///E se não encontrar nenhum registro de inspeção, lINSPNEG = .T. (TB True)
			///////////////////////////////////////////////////////////////////////////////////////////////////
			//DbselectArea("QEK")
			//QEK->(Dbsetorder(15)) //QEK_FILIAL + QEK->NTFISC + QEK_SERINF + QEK_FORNEC + QEK_LOJFOR + QEK_DTENTR                                                                         
			//If QEK->(Dbseek(xFilial("QEK") + cNF + cSeriNF + cFornece + cLojaFor + DtoS(datadigi) ))
			cQuery := " Select * from " + RetSqlName("QEK") + " QEK " + LF
			cQuery += " Where QEK_NTFISC = '" + Alltrim(cNF) + "' " + LF
			cQuery += " and QEK_SERINF= '" + Alltrim(cSeriNF) + "' " + LF
			cQuery += " and QEK_FORNEC = '" + Alltrim(cFornece) + "' " + LF
			cQuery += " and QEK_LOJFOR  = '" + Alltrim(cLojaFor) + "' " + LF	
			cQuery += " and QEK_FILIAL  = '" + Alltrim(xFilial("QEK"))  + "' " + LF
			cQuery += " and QEK_DTENTR  = '" + Dtos(datadigi) + "' " + LF
			cQuery += " and QEK.D_E_L_E_T_ = '' " + LF
			cQuery += " ORDER BY QEK_CHAVE " + LF
			
			MemoWrite("C:\Temp\LOCALQEK.sql", cQuery)			
			If Select("QEKX") > 0
				DbSelectArea("QEKX")
				DbCloseArea()
			EndIf
			TCQUERY cQuery NEW ALIAS "QEKX"
			//TCSetField( 'SD1X', "D1_DTDIGIT", "D" )				
			QEKX->( DBGoTop() )			
			If !QEKX->(EOF())
				Do While !QEKX->( Eof() )			
					cChave := QEKX->QEK_CHAVE
					While !QEKX->(EOF()) .and. Alltrim(QEKX->QEK_CHAVE) = Alltrim(cChave)
						If QEKX->QEK_SITENT != '2' .or. QEKX->QEK_SITENT != '4'  .or. QEKX->QEK_SITENT != '5'  .or. QEKX->QEK_SITENT != '6'
					    	Do Case
						    	 Case QEKX->QEK_SITENT == "1"
						    	  	cSituaca := "Inspeção pendente"
						    	  	lINSPNEG := .T.
							     //Case QEK->QEK_SITENT == "2"
								     	//cSituaca := "Inspeção aprovado"
								 Case QEKX->QEK_SITENT == "3"
								 	cSituaca := "Inspeção reprovada"
								 	lINSPNEG := .T.  
								 //Case QEK->QEK_SITENT == "4"
								 	//cSituaca := "Inspeção c/ liberação urgente"  
								 //Case QEK->QEK_SITENT == "5"
								 	//cSituaca := "Inspeção liberada condicionalmente"
							     //Case QEK->QEK_SITENT == "6"
							     	//cSituaca := "Inspeção s/ movto. estoque"
								Case QEKX->QEK_SITENT == "7"
									cSituaca := "Inspeção de entrada s/ medições"
									lINSPNEG := .T.
						    	Endcase								    					
						Endif
						QEKX->(Dbskip())
					Enddo     //enddo da QEK_CHAVE
								
				Enddo //enddo principal QEK
				DbSelectArea("QEKX")
				DbCloseArea()
			Else
				msgbox( Alltrim(Funname()) + " - Registro Não Encontrado na Tabela QEK : " + Alltrim(cNF) + '/' + Alltrim(cSeriNF) + " - Favor Entrar em contato com o Administrador." )
			Endif   //ENDIF DO SEEK NO QEK
							
			If lINSPNEG
				Aviso(	"Libera Doctos",;
						"Situação da NF: " + cSituaca + ;
						 ". Favor entrar em contato com o Depto. QUALIDADE",;
						{"&Ok"},,;
						"INSPEÇÃO ENTRADA")
				//lRet	:= .F.    //retorno final da função, .F. 
				//Return(lRet)     //FR - COMENTADO POR FLÁVIA ROCHA - NÃO SERÁ NECESSÁRIA A SENHA DE MARCELO
			Else
				msginfo("INSPEÇÃO APROVADA")
			Endif
		Endif  //endif do lInspeciona
			
		//checagem do pedido x nf	

		If Len(aNFE) > 0
			//checagem de divergências com o pedido
			DbselectArea("SC7")
			SC7->(Dbsetorder(1))
			SC7->(Dbgotop())			
			//Aadd(aNFE, { cPC, cItemPC, nQuant, nPreco, cCondNF, nTotal, nValipi, nipi, nValfrete } )   //Armazena no array de itens da NF, para comparar com o pedido	 
			For x := 1 to Len(aNFE)
				SC7->(Dbsetorder(1))
				SC7->(Dbgotop())
				If SC7->(Dbseek(xFilial("SC7") + aNFE[x,1] + aNFE[x,2]  ))				    
							    
				    If aNFE[x,3] > SC7->C7_QUANT      //DIVERGÊNCIA QTDE
				    	lDiverg := .T. 
				    	lDivQ   := .T.						    	
				    Endif
							    
				    If aNFE[x,4] > SC7->C7_PRECO  //DIVERGÊNCIA PREÇO
				    	lDiverg := .T.
				    	lDivP    := .T. 						    
				    Endif
							    
				    If aNFE[x,9] != SC7->C7_VALFRET  //DIVERGÊNCIA VALOR FRETE
				    	lDiverg := .T.
				    	lDivF   := .T.					    	
				    Endif
							    
				    If Alltrim(aNFE[x,5]) != Alltrim(SC7->C7_COND)  //DIVERGÊNCIA COND.PAGTO
				    	lDiverg := .T.
				    	lDivPG  := .T.
				    Endif
							    
				    If Round(aNFE[x,6],2) > Round(SC7->C7_TOTAL,2)  //DIVERGÊNCIA VAL TOTAL
				    	lDiverg := .T.
				    	lDivTot  := .T.						       
				    Endif
							    
				    If ( aNFE[x,7] > SC7->C7_VALIPI )  //DIVERGÊNCIA VAL IPI
				    	lDiverg := .T.
				    	lDivipi  := .T.						    
				    Endif
				    
				    If ( aNFE[x,8] > SC7->C7_IPI ) 
				    	lDiverg := .T.
				    	lDivipi  := .T.	
				    Endif								
				Endif   //endif do seek no SC7
			Next
				
			If lDiverg
				cMsg := "Esta NF Apresentou a(s) Seguinte(s) Divergência(s) com o Pedido de Compra:" + CHR(13) + CHR(10) 
			    If lDivQ
			    	cMsg += " - Quantidade" + CHR(13) + CHR(10)  
			    Endif
					    
				If lDivP
				   	cMsg += " - Preço Unitario" + CHR(13) + CHR(10)  
				Endif
				   
				If lDivF
					cMsg += " - Valor Frete" + CHR(13) + CHR(10)  					    
				Endif
				    
				If lDivPG
					cMsg += " - Cond. Pagto." + CHR(13) + CHR(10)  					    				    
				Endif 
					   
				If lDivTot
				  	cMsg += " - Valor Total" + CHR(13) + CHR(10)  					    				    
				Endif 
					    
				If lDivipi
				  	cMsg += " - Valor IPI" + CHR(13) + CHR(10)  					    				    
				Endif 
			
			//ELSE
				//ALERT("SEM DIVERGÊNCIA")
			Endif  //endif da verificação de lDiverg									
		
		Else
			MSGBOX("MTA097 - ARRAY VAZIO!!")
		Endif  //endif do array aNFE
		
				
	Endif //do seek no SF1
	
	
	If !lINSPNEG .and. !lDiverg   .and. !lFrete //a inspeção está positiva e a NF sem divergência -> tudo ok e nao e frete 
	    lRet:=.T. 
    	fMandMail(cNF) 
 	    //ALERT("NÃO INSPECIONA / SEM DIVERGÊNCIA")
 	Else 
 		///verifica grupo aprovação CQ:
 		cQuery := " Select * from " + RetSqlName("SAL") + " SAL " + LF
		cQuery += " Where SAL.AL_DESC LIKE 'QUALIDADE' " + LF
		cQuery += " and SAL.AL_FILIAL  = '" + Alltrim(xFilial("SAL"))  + "' " + LF
		cQuery += " and SAL.D_E_L_E_T_ = '' " + LF
		cQuery += " ORDER BY AL_USER " + LF
			
		MemoWrite("C:\Temp\LOCALSAL.sql", cQuery)			
		If Select("SALX") > 0
			DbSelectArea("SALX")
			DbCloseArea()
		EndIf
		TCQUERY cQuery NEW ALIAS "SALX"
		//TCSetField( 'SD1X', "D1_DTDIGIT", "D" )				
		SALX->( DBGoTop() )			
		If !SALX->(EOF())
			Do While !SALX->( Eof() )			
			    Aadd(aUserCQ, Alltrim(SALX->AL_USER) )
				SALX->(DBSKIP())			
			Enddo
		Endif
		
		If lINSPNEG      //sem inspeção
			If Ascan(aUserCQ, Alltrim(cUser) ) > 0 .and. !lDiverg
				//encontrou no array de usuários qualidade, o usuário logado		
 				lRet := .T.
 				fMandMail(cNF)  			
			ElseIf Ascan(aUserCQ, Alltrim(cUser) ) = 0
				//NÃO DEIXA LIBERAR QUALIDADE, SE NÃO for do Grupo Qualidade  				
 				lRet := .F.		                        				
 				msgbox("Usuário Sem Permissão para Liberar Qualidade") 	 			
 			Endif
 		Endif
 		
 		//verifica se faz parte do grupo de Frete
 		cQry := " Select * from " + RetSqlName("SAL") + " SAL " + LF
		cQry += " Where SAL.AL_DESC LIKE 'FRETE' " + LF
		cQry += " and SAL.AL_FILIAL  = '" + Alltrim(xFilial("SAL"))  + "' " + LF
		cQry += " and SAL.D_E_L_E_T_ = '' " + LF
		cQry += " ORDER BY AL_USER " + LF
			
		If Select("TMPX") > 0
			DbSelectArea("TMPX")
			DbCloseArea()
		EndIf
		
		TCQUERY cQry NEW ALIAS "TMPX"
			
		TMPX->( DBGoTop() )
		If !TMPX->(EOF())
			Do While !TMPX->( Eof() )
				Aadd(aUserFR, Alltrim(TMPX->AL_USER) )
				TMPX->(DBSKIP())
			Enddo
		Endif		 		 	
		

		
		///fim da verificação do grupo frete
 		If lDiverg   
 			//se tiver divergência entre pc x nf, não deixa o usuário da qualidade, nem frete liberar...
 			If Ascan(aUserCQ, Alltrim(cUser) ) > 0	 
 				//encontrou no array de usuários qualidade, o usuário logado
 				lRet := .F.
 				msgbox("Usuário Qualidade sem Permissão para Liberar Divergência P.C. : " + chr(13) + chr(10) + cMsg)	
 			ElseIf Ascan(aUserFR, Alltrim(cUser) ) > 0  .AND. (!Alltrim(cUser)$SuperGetMV("MV_XLIBFRT",,'000007/000395'))  // marcelo  E Giancarlo 
 				lRet := .F.
 				msgbox("Usuário Frete sem Permissão para Liberar Divergência P.C. : " + chr(13) + chr(10) + cMsg)	
 			Else              
 				//não encontrou no array de usuários qualidade, nem do frete, o usuário logado, então libera
 				lRet := .T.
 				fMandMail(cNF) 
 			Endif
 		
 		Else     //não tem divergência
 		
 			////VERIFICA SE É NF FRETE
 			///ANTONIO 			
		    		    
			If lFrete
				
				//se for, verifica se o usuário logado, está habilitado para liberá-la
				If Ascan(aUserFR, Alltrim(cUser) ) > 0
				   if Z86->Z86_FRETE>Z86->Z86_FRESIS
				      if MsgBox( OemToAnsi( "Deseja Gerar Titulo de Abatimento " ), "Escolha", "YESNO" )       
				         RecLock( "Z86", .F. )
				         Z86->Z86_GERATI:='S' 
				         Z86->( MsUnlock() )
					  Endif
				   Endif
					lRet:=.T. // LIBERA
					fMandMail(cNF) 				
				   
				Else
			    	lRet := .F.  // bloqueia 
					msgbox("Usuário Sem Permissão para Liberar Frete")
				Endif
			      
			Else  //se não for NF , chegou até aqui é porque não tem divergência, então pode liberar
				lRet := .T.
 				fMandMail(cNF) 
			Endif 			
 			////NF FRETE			
 		
 		Endif  //lDiverg		
 	
 	
 	Endif //da verificação da inspeção e diverg.
 		
Else  //se o tipo for PC, não existe validação....
	
	lRet	:= .T.  //retorna .T. e envia um alerta ao solicitante
	
	//FR - 08/05/13
	//chamado 00000354
	//DO PRAZO DE ENTREGA: DESENVOLVER UM ALERTA POR EMAIL PARA O SOLICITANTE
	// SER INFORMADO DO PRAZO DE ENTREGA NO MOMENTO DA APROVAÇÃO DO PEDIDO DE COMPRA

Endif  //endif principal se o tipo doc é NF


RestArea(aArea)

Return(lRet)

**************************
Static Function fAt(cCF)
**************************

Local nTam := Len(cCF)
Local nConta := 1
Local cPar   := ""

//a função AT retorna um valor numérico
//que corresponde à posição do caracter especificado, ex; a vírgula
//retornou a posição 5 que é a primeira vírgula q ele encontrou


While nConta <= Len( cCF )
	
	If Substr( cCF , nConta, 1 ) != '*'
		cPar += Substr(cCF , nConta , 1 )
	Elseif Substr( cCF , nConta, 1 ) = '*' .and. nConta < nTam
		cPar += " , "
	Elseif Substr( cCF , nConta, 1 ) = '*' .and. nConta = nTam 
		cPar += " "	
	Endif
    nConta++
    
    //MARCELO*                            
Enddo

Return(cPar)  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fMandMail  º Autor ³ Gustavo Costa    º Data ³  25/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envia email informando que foi cadastrado uma conferência. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fMandMail(cNF)

Local cTitulo  	:= "Liberação do Documento - " + Alltrim(cNF)
Local cConteudo	:= ""
Local cMailTo	:= GetNewPar('MV_XMAILGC',"informatica@ravaembalagens.com.br") 
//Local cMailTo	:= "flavia.rocha@ravaembalagens.com.br"
Local cCopia 	:= ""
Local cAnexo	:= ""
Local lEnviado  := .F.

cConteudo +="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
cConteudo +="<html xmlns='http://www.w3.org/1999/xhtml' >"
cConteudo +="<head>"
cConteudo +="    <title>Untitled Page</title>"
cConteudo +="</head>"
cConteudo +="<body>"
dbSelectArea("SM0")
cConteudo +="Na empresa " + SM0->M0_CODIGO + SM0->M0_CODFIL + " - " + AllTrim(SM0->M0_FILIAL) + ".<br /><br />"
cConteudo +="Você já pode classificar <strong>Nota Fiscal</strong> de número <strong>" + Alltrim(cNF) + "</strong> " + "<br /><br />"
cConteudo +="<br /><br /> "
cConteudo +="</body>"
cConteudo +="</html>"

lEnviado := U_SendFatr11( cMailTo, cCopia, cTitulo, cConteudo, cAnexo ) 

//cMailTo += ";flavia.rocha@ravaembalagens.com.br"

If lEnviado
  	MsgAlert("Docto. Liberado, E-mail enviado com sucesso !! ")
Else
	MsgStop("E-mail não enviado !! Por favor, informar a Contabilidade a liberação do documento.")
EndIf

Return



