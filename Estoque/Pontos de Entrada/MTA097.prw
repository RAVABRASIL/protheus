#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*  
//////////////////////////////////////////////////////////////////////////////////////////////
//Programa: MTA097 : Ap�s a confirma��o da libera��o do documento, 
//                   deve ser utilizado para executar uma valida��o 
//                   do usuario na libera��o a fim de interromper ou bloquear processo.
//Autoria : Fl�via Rocha
//Data    : 04/06/2012
//////////////////////////////////////////////////////////////////////////////////////////////
*/             

User Function MTA097


Local lRet 		:= .F.   //vari�vel que ir� bloquear ou permitir o processo de libera��o de docto.
Local cProd		:= ""    //vari�vel que armazena o c�digo do produto
Local cPC  		:= ""    //vari�vel que armazena o n�mero do pedido de compra
Local cTipDoc 	:= ""    //vari�vel que armazena o tipo do documento (PC ou NF)
Local cNF    	:= ""    //vari�vel que armazena o n�mero da NF
Local cSeriNF	:= ""    //vari�vel que armazena a s�rie da NF
Local cItemPC   := ""    //vari�vel que armazena o item do pedido
Local nQuant    := 0     //vari�vel que armazena a qtde do item no pedido
Local nPreco    := 0	 //vari�vel que armazena o pre�o unit�rio do item no pedido
Local nTotal    := 0	 //vari�vel que armazena o valor total do pedido
Local nValipi   := 0 	 //vari�vel que armazena o valor do ipi no item do pedido
Local nipi      := 0	 //vari�vel que armazena a aliq. do ipi no item do pedido
Local cFornece  := ""	 //vari�vel que armazena o c�digo do fornecedor
Local cLojaFor  := ""	 //vari�vel que armazena a loja do fornecedor 
Local cCondNF   := ""	 //vari�vel que armazena a condi��o de pagto 
Local lInspeciona := .F. //vari�vel que marca qdo algum item da nf � sujeito � inspe��o
Local aNFE		:= {}    //array com os itens da NF
Local cChave    := ""    //c�digo da chave no ambiente de inspe��o Qualidade 
Local lINSPNEG  := .F.   //vari�vel l�gica que indica se a inspe��o foi realizada e positiva
Local cSituaca  := ""    //vari�vel que armazenar� a msg de que n�o houve inspe��o / ou inspe��o negativa
Local datadigi  := Ctod("  /  /    ") //vari�vel que armazenar� a data da digita��o da NF
Local cQuery    := ""
Local LF		:= CHR(13) + CHR(10) 
Local cUser     := __CUSERID  //ir� armazenar o c�digo do usu�rio logado
Local cCRUser   := ""
Local lSCR      := .F.
Local aUserCQ  := {}
Local aUserFR  := {}


//VARI�VEIS L�GICAS QUE INDICAM DIVERG�NCIA ENTRE PC x NF
Local lDiverg   := .F.     	//DIVERG�NCIA GERAL
Local lDivQ 	:= .F.		//DIVERG�NCIA QTDE
Local lDivP		:= .F.		//DIVERG�NCIA PRE�O UNIT�RIO 
Local lDivPG	:= .F.		//DIVERG�NCIA COND. PAGTO 
Local lDivTot	:= .F.		//DIVERG�NCIA VALOR TOTAL
Local lDivipi   := .F.		//DIVERG�NCIA IPI (VALOR OU ALIQ.)
Local lDivF		:= .F.    	//DIVERG�NCIA VLR. FRETE
Local cQuemPode := ""   //armazena o(s) nome(s) da(s) pessoa(s) que pode(m) liberar o docto em caso de diverg�ncia
Local cMsg		:= ""  //mensagem sobre qual diver�ncia entre NF x PC ocorreu  
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
	///verifica se � NF frete:
	If Z86->( dbSeek( xFilial( "Z86" ) + cNF + cSeriNF + cFornece + cLojaFor  ) )
       lFrete:=.T.
    Endif
	
	
	SF1->(DBSetorder(1))
	If SF1->(Dbseek(xFilial("SF1") + cNF + cSeriNF + cFornece + cLojaFor ))   //localiza no SF1, a NF, para pegar a condi��o de pagto
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
						lInspeciona := .T.		   //localiza o produto da nota e verifica se o mesmo deve receber inspe��o de qualidade			
					Endif
				Endif
				
				//ESTE LOOP � S� PARA ADICIONAR OS DADOS NO aNFE para comparativo de diverg�ncia entre NF x PC
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
			msgbox("MTA097 - nf n�o localizada: " + cNF)
		Endif	//endif do seek no SD1	
	
		If lInspeciona	
			
		    ///////////////////////////////////////////////////////////////////////////////////////////////////	        
		    ///procura no ambiente de inspe��o se: existe registro de inspe��o , e se o mesmo foi positivo	
			///se encontrar registro de inspe��o e o mesmo for negativo, lINSPNEG = .T.
			///E se n�o encontrar nenhum registro de inspe��o, lINSPNEG = .T. (TB True)
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
						    	  	cSituaca := "Inspe��o pendente"
						    	  	lINSPNEG := .T.
							     //Case QEK->QEK_SITENT == "2"
								     	//cSituaca := "Inspe��o aprovado"
								 Case QEKX->QEK_SITENT == "3"
								 	cSituaca := "Inspe��o reprovada"
								 	lINSPNEG := .T.  
								 //Case QEK->QEK_SITENT == "4"
								 	//cSituaca := "Inspe��o c/ libera��o urgente"  
								 //Case QEK->QEK_SITENT == "5"
								 	//cSituaca := "Inspe��o liberada condicionalmente"
							     //Case QEK->QEK_SITENT == "6"
							     	//cSituaca := "Inspe��o s/ movto. estoque"
								Case QEKX->QEK_SITENT == "7"
									cSituaca := "Inspe��o de entrada s/ medi��es"
									lINSPNEG := .T.
						    	Endcase								    					
						Endif
						QEKX->(Dbskip())
					Enddo     //enddo da QEK_CHAVE
								
				Enddo //enddo principal QEK
				DbSelectArea("QEKX")
				DbCloseArea()
			Else
				msgbox( Alltrim(Funname()) + " - Registro N�o Encontrado na Tabela QEK : " + Alltrim(cNF) + '/' + Alltrim(cSeriNF) + " - Favor Entrar em contato com o Administrador." )
			Endif   //ENDIF DO SEEK NO QEK
							
			If lINSPNEG
				Aviso(	"Libera Doctos",;
						"Situa��o da NF: " + cSituaca + ;
						 ". Favor entrar em contato com o Depto. QUALIDADE",;
						{"&Ok"},,;
						"INSPE��O ENTRADA")
				//lRet	:= .F.    //retorno final da fun��o, .F. 
				//Return(lRet)     //FR - COMENTADO POR FL�VIA ROCHA - N�O SER� NECESS�RIA A SENHA DE MARCELO
			Else
				msginfo("INSPE��O APROVADA")
			Endif
		Endif  //endif do lInspeciona
			
		//checagem do pedido x nf	

		If Len(aNFE) > 0
			//checagem de diverg�ncias com o pedido
			DbselectArea("SC7")
			SC7->(Dbsetorder(1))
			SC7->(Dbgotop())			
			//Aadd(aNFE, { cPC, cItemPC, nQuant, nPreco, cCondNF, nTotal, nValipi, nipi, nValfrete } )   //Armazena no array de itens da NF, para comparar com o pedido	 
			For x := 1 to Len(aNFE)
				SC7->(Dbsetorder(1))
				SC7->(Dbgotop())
				If SC7->(Dbseek(xFilial("SC7") + aNFE[x,1] + aNFE[x,2]  ))				    
							    
				    If aNFE[x,3] > SC7->C7_QUANT      //DIVERG�NCIA QTDE
				    	lDiverg := .T. 
				    	lDivQ   := .T.						    	
				    Endif
							    
				    If aNFE[x,4] > SC7->C7_PRECO  //DIVERG�NCIA PRE�O
				    	lDiverg := .T.
				    	lDivP    := .T. 						    
				    Endif
							    
				    If aNFE[x,9] != SC7->C7_VALFRET  //DIVERG�NCIA VALOR FRETE
				    	lDiverg := .T.
				    	lDivF   := .T.					    	
				    Endif
							    
				    If Alltrim(aNFE[x,5]) != Alltrim(SC7->C7_COND)  //DIVERG�NCIA COND.PAGTO
				    	lDiverg := .T.
				    	lDivPG  := .T.
				    Endif
							    
				    If Round(aNFE[x,6],2) > Round(SC7->C7_TOTAL,2)  //DIVERG�NCIA VAL TOTAL
				    	lDiverg := .T.
				    	lDivTot  := .T.						       
				    Endif
							    
				    If ( aNFE[x,7] > SC7->C7_VALIPI )  //DIVERG�NCIA VAL IPI
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
				cMsg := "Esta NF Apresentou a(s) Seguinte(s) Diverg�ncia(s) com o Pedido de Compra:" + CHR(13) + CHR(10) 
			    If lDivQ
			    	cMsg += " - Quantidade" + CHR(13) + CHR(10)  
			    Endif
					    
				If lDivP
				   	cMsg += " - Pre�o Unitario" + CHR(13) + CHR(10)  
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
				//ALERT("SEM DIVERG�NCIA")
			Endif  //endif da verifica��o de lDiverg									
		
		Else
			MSGBOX("MTA097 - ARRAY VAZIO!!")
		Endif  //endif do array aNFE
		
				
	Endif //do seek no SF1
	
	
	If !lINSPNEG .and. !lDiverg   .and. !lFrete //a inspe��o est� positiva e a NF sem diverg�ncia -> tudo ok e nao e frete 
	    lRet:=.T. 
    	fMandMail(cNF) 
 	    //ALERT("N�O INSPECIONA / SEM DIVERG�NCIA")
 	Else 
 		///verifica grupo aprova��o CQ:
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
		
		If lINSPNEG      //sem inspe��o
			If Ascan(aUserCQ, Alltrim(cUser) ) > 0 .and. !lDiverg
				//encontrou no array de usu�rios qualidade, o usu�rio logado		
 				lRet := .T.
 				fMandMail(cNF)  			
			ElseIf Ascan(aUserCQ, Alltrim(cUser) ) = 0
				//N�O DEIXA LIBERAR QUALIDADE, SE N�O for do Grupo Qualidade  				
 				lRet := .F.		                        				
 				msgbox("Usu�rio Sem Permiss�o para Liberar Qualidade") 	 			
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
		

		
		///fim da verifica��o do grupo frete
 		If lDiverg   
 			//se tiver diverg�ncia entre pc x nf, n�o deixa o usu�rio da qualidade, nem frete liberar...
 			If Ascan(aUserCQ, Alltrim(cUser) ) > 0	 
 				//encontrou no array de usu�rios qualidade, o usu�rio logado
 				lRet := .F.
 				msgbox("Usu�rio Qualidade sem Permiss�o para Liberar Diverg�ncia P.C. : " + chr(13) + chr(10) + cMsg)	
 			ElseIf Ascan(aUserFR, Alltrim(cUser) ) > 0  .AND. (!Alltrim(cUser)$SuperGetMV("MV_XLIBFRT",,'000007/000395'))  // marcelo  E Giancarlo 
 				lRet := .F.
 				msgbox("Usu�rio Frete sem Permiss�o para Liberar Diverg�ncia P.C. : " + chr(13) + chr(10) + cMsg)	
 			Else              
 				//n�o encontrou no array de usu�rios qualidade, nem do frete, o usu�rio logado, ent�o libera
 				lRet := .T.
 				fMandMail(cNF) 
 			Endif
 		
 		Else     //n�o tem diverg�ncia
 		
 			////VERIFICA SE � NF FRETE
 			///ANTONIO 			
		    		    
			If lFrete
				
				//se for, verifica se o usu�rio logado, est� habilitado para liber�-la
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
					msgbox("Usu�rio Sem Permiss�o para Liberar Frete")
				Endif
			      
			Else  //se n�o for NF , chegou at� aqui � porque n�o tem diverg�ncia, ent�o pode liberar
				lRet := .T.
 				fMandMail(cNF) 
			Endif 			
 			////NF FRETE			
 		
 		Endif  //lDiverg		
 	
 	
 	Endif //da verifica��o da inspe��o e diverg.
 		
Else  //se o tipo for PC, n�o existe valida��o....
	
	lRet	:= .T.  //retorna .T. e envia um alerta ao solicitante
	
	//FR - 08/05/13
	//chamado 00000354
	//DO PRAZO DE ENTREGA: DESENVOLVER UM ALERTA POR EMAIL PARA O SOLICITANTE
	// SER INFORMADO DO PRAZO DE ENTREGA NO MOMENTO DA APROVA��O DO PEDIDO DE COMPRA

Endif  //endif principal se o tipo doc � NF


RestArea(aArea)

Return(lRet)

**************************
Static Function fAt(cCF)
**************************

Local nTam := Len(cCF)
Local nConta := 1
Local cPar   := ""

//a fun��o AT retorna um valor num�rico
//que corresponde � posi��o do caracter especificado, ex; a v�rgula
//retornou a posi��o 5 que � a primeira v�rgula q ele encontrou


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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fMandMail  � Autor � Gustavo Costa    � Data �  25/03/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Envia email informando que foi cadastrado uma confer�ncia. ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fMandMail(cNF)

Local cTitulo  	:= "Libera��o do Documento - " + Alltrim(cNF)
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
cConteudo +="Voc� j� pode classificar <strong>Nota Fiscal</strong> de n�mero <strong>" + Alltrim(cNF) + "</strong> " + "<br /><br />"
cConteudo +="<br /><br /> "
cConteudo +="</body>"
cConteudo +="</html>"

lEnviado := U_SendFatr11( cMailTo, cCopia, cTitulo, cConteudo, cAnexo ) 

//cMailTo += ";flavia.rocha@ravaembalagens.com.br"

If lEnviado
  	MsgAlert("Docto. Liberado, E-mail enviado com sucesso !! ")
Else
	MsgStop("E-mail n�o enviado !! Por favor, informar a Contabilidade a libera��o do documento.")
EndIf

Return



