#include "Rwmake.ch"  

/*/
//--------------------------------------------------------------------------
//Programa: A010TOK - PE na Confirmação do Cadastro de Produto
//Objetivo: Valida se prossegue com a inclusão, alteração ou cópia do Produto
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 16/09/2010
//--------------------------------------------------------------------------


/*/




************************
User Function A010TOK()
************************

Local lExecuta 	:= .T.
Local aUsua		:= {} 
Local cCodUser	:= ""
Local cNomeuser	:= "" 
Local lPermissao:= .F.

Local lOk		:= .T.

cCodUser := __CUSERID


PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
Endif


If UPPER(ALLTRIM(FUNNAME())) != "FATC022"   //quando a função for a rotina de Conferência de Produtos, não fará as validações abaixo
	// Validações do usuário para inclusão ou alteração do produto
	If lCopia		///a variável lCopia é Private no fonte MATA010, por isso consigo utilizá-la aqui.
	
		If M->B1_TIPO = "PA"  //SB1->B1_TIPO = "PA"  // ANTONIO: TROQUEI DO ALIAS SB1-> PARA M-> PQ PELO SB1 ELE VERIFICA O PRODUTO QUE ESTA SENDO COPIADO E NAO O COPIADO.
		                                             //Ex: se copio o produto CI0001 para o CI00XX COM O SB1-> ELE OLHA OS CAMPOS DO CI0001 E NAO DO CI00XX.
			msgbox("A Cópia de Produtos Tipo = PA não é permitida !!!")
			lExecuta := .F. 
		Else
			//msginfo("verificar alçada")
			
			DbselectArea("SX5")
			SX5->(Dbseek(xFilial("SX5") + 'Z6' )) 
			While !SX5->(EOF()) .AND. SX5->X5_FILIAL == xFilial("SX5") .AND. SX5->X5_TABELA == 'Z6'
					
				If Alltrim(cCodUser) =  Alltrim(SX5->X5_CHAVE)			
				
					If !Alltrim(M->B1_TIPO) $ Alltrim(SX5->X5_DESCRI + SX5->X5_DESCSPA + SX5->X5_DESCENG)      //posiciona no código do usuário e verifica se o tipo está contido nas permissões
																			 //se não estiver, retornará Falso
						lExecuta := .F. 
					
					Else
						lPermissao := .T.				
					
					Endif
				Endif
				SX5->(Dbskip())
			Enddo
			If !lPermissao
				//msgbox("Você não tem permissão para copiar este Tipo de Produto -->> " + SB1->B1_TIPO)
				msgbox("Você não tem permissão para copiar este Tipo de Produto -->> " + M->B1_TIPO)
				lExecuta := .F.		 
			Endif	
			// incluido por antonio 
		   //	IF Alltrim(M->B1_TIPO)<>'PA' 
		   	IF !Alltrim(M->B1_TIPO)$'PA/PP'
				If Alltrim(M->B1_TIPO)!=SUBSTR(M->B1_COD,1,2)		
			       alert('O Tipo de Produto '+Alltrim(M->B1_TIPO)+' e diferente do codigo do produto '+Alltrim(M->B1_COD) ) 
			       lExecuta := .F. 
			    Endif
		    ENDIF
		Endif 
	
	Else
	///esta parte já existia no programa anterior feito pelo Eurivan, colei aqui.
	    
		//MSGBOX("NÃO É CÓPIA")
		
		If ( ( M->B1_TIPO == "PA" .and. Alltrim(FunName()) <> "ESTC003" ) .or.;
	     	( M->B1_TIPO <> "PA" .and. Alltrim(FunName()) == "ESTC003" ) ) .and. Inclui
	 		
	 		lOk := .F.
	   		
	   		Alert("Este tipo de produto não podera ser Incluido por essa rotina.")
	   		lExecuta := lOk         
		///FIM DA PARTE EXISTENTE, INCLUI EM 14/10/10 ESTA VALIDAÇÃO PARA VERIFICAR ALÇADAS TAMBÉM NA INCLUSÃO / ALTERAÇÃO
		Elseif Inclui
			
			DbselectArea("SX5")
			SX5->(Dbseek(xFilial("SX5") + 'Z6' )) 
			While !SX5->(EOF()) .AND. SX5->X5_FILIAL == xFilial("SX5") .AND. SX5->X5_TABELA == 'Z6'
					
				If Alltrim(cCodUser) =  Alltrim(SX5->X5_CHAVE)			
					
					If !Alltrim(M->B1_TIPO) $ Alltrim(SX5->X5_DESCRI + SX5->X5_DESCSPA + SX5->X5_DESCENG) 
						lExecuta := .F. 
						
					Else
						lPermissao := .T.					
					Endif
				
				Endif
				SX5->(Dbskip())
			Enddo
			If !lPermissao
				msgbox("Você não tem permissão para INCLUIR este Tipo de Produto -->> " + M->B1_TIPO)
				lExecuta := .F.	
			Endif	
			// incluido por antonio 
			IF !Alltrim(M->B1_TIPO)$'PA/PP'
				If Alltrim(M->B1_TIPO)!=SUBSTR(M->B1_COD,1,2)		
			       alert('O Tipo de Produto '+Alltrim(M->B1_TIPO)+' e diferente do codigo do produto '+Alltrim(M->B1_COD) ) 
			       lExecuta := .F. 
			    Endif
            ENDIF
		Elseif Altera
		
		    If Alltrim(SB1->B1_TIPO) =='PA'
		       Return lExecuta 
		    Endif
		
	//		lExecuta := .F.
			DbselectArea("SX5")
			SX5->(Dbseek(xFilial("SX5") + 'Z6' )) 
			While !SX5->(EOF()) .AND. SX5->X5_FILIAL == xFilial("SX5") .AND. SX5->X5_TABELA == 'Z6'
					
				If Alltrim(cCodUser) =  Alltrim(SX5->X5_CHAVE)				
							
					If !Alltrim(M->B1_TIPO) $ Alltrim(SX5->X5_DESCRI + SX5->X5_DESCSPA + SX5->X5_DESCENG) 
						lExecuta := .F. 				
					Else
						lPermissao := .T.				
					Endif
				
				Endif
				SX5->(Dbskip())
			Enddo
			If !lPermissao
				msgbox("Você não tem permissão para ALTERAR este Tipo de Produto -->> " + M->B1_TIPO)
				lExecuta := .F.		
			Endif	
					
		Endif 
		
		
	Endif
Else
	lExecuta := .T.
Endif

Return (lExecuta)


