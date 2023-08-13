#include "Rwmake.ch"  

/*/
//--------------------------------------------------------------------------
//Programa: A010TOK - PE na Confirma��o do Cadastro de Produto
//Objetivo: Valida se prossegue com a inclus�o, altera��o ou c�pia do Produto
//Autoria : Fl�via Rocha
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
   aUsua := PSWRET() 						// Retorna vetor com informa��es do usu�rio
   //cCodUser  := Alltrim(aUsua[1][1])  	//c�digo do usu�rio no arq. senhas
   cNomeuser := Alltrim(aUsua[1][2])		// Nome do usu�rio
Endif


If UPPER(ALLTRIM(FUNNAME())) != "FATC022"   //quando a fun��o for a rotina de Confer�ncia de Produtos, n�o far� as valida��es abaixo
	// Valida��es do usu�rio para inclus�o ou altera��o do produto
	If lCopia		///a vari�vel lCopia � Private no fonte MATA010, por isso consigo utiliz�-la aqui.
	
		If M->B1_TIPO = "PA"  //SB1->B1_TIPO = "PA"  // ANTONIO: TROQUEI DO ALIAS SB1-> PARA M-> PQ PELO SB1 ELE VERIFICA O PRODUTO QUE ESTA SENDO COPIADO E NAO O COPIADO.
		                                             //Ex: se copio o produto CI0001 para o CI00XX COM O SB1-> ELE OLHA OS CAMPOS DO CI0001 E NAO DO CI00XX.
			msgbox("A C�pia de Produtos Tipo = PA n�o � permitida !!!")
			lExecuta := .F. 
		Else
			//msginfo("verificar al�ada")
			
			DbselectArea("SX5")
			SX5->(Dbseek(xFilial("SX5") + 'Z6' )) 
			While !SX5->(EOF()) .AND. SX5->X5_FILIAL == xFilial("SX5") .AND. SX5->X5_TABELA == 'Z6'
					
				If Alltrim(cCodUser) =  Alltrim(SX5->X5_CHAVE)			
				
					If !Alltrim(M->B1_TIPO) $ Alltrim(SX5->X5_DESCRI + SX5->X5_DESCSPA + SX5->X5_DESCENG)      //posiciona no c�digo do usu�rio e verifica se o tipo est� contido nas permiss�es
																			 //se n�o estiver, retornar� Falso
						lExecuta := .F. 
					
					Else
						lPermissao := .T.				
					
					Endif
				Endif
				SX5->(Dbskip())
			Enddo
			If !lPermissao
				//msgbox("Voc� n�o tem permiss�o para copiar este Tipo de Produto -->> " + SB1->B1_TIPO)
				msgbox("Voc� n�o tem permiss�o para copiar este Tipo de Produto -->> " + M->B1_TIPO)
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
	///esta parte j� existia no programa anterior feito pelo Eurivan, colei aqui.
	    
		//MSGBOX("N�O � C�PIA")
		
		If ( ( M->B1_TIPO == "PA" .and. Alltrim(FunName()) <> "ESTC003" ) .or.;
	     	( M->B1_TIPO <> "PA" .and. Alltrim(FunName()) == "ESTC003" ) ) .and. Inclui
	 		
	 		lOk := .F.
	   		
	   		Alert("Este tipo de produto n�o podera ser Incluido por essa rotina.")
	   		lExecuta := lOk         
		///FIM DA PARTE EXISTENTE, INCLUI EM 14/10/10 ESTA VALIDA��O PARA VERIFICAR AL�ADAS TAMB�M NA INCLUS�O / ALTERA��O
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
				msgbox("Voc� n�o tem permiss�o para INCLUIR este Tipo de Produto -->> " + M->B1_TIPO)
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
				msgbox("Voc� n�o tem permiss�o para ALTERAR este Tipo de Produto -->> " + M->B1_TIPO)
				lExecuta := .F.		
			Endif	
					
		Endif 
		
		
	Endif
Else
	lExecuta := .T.
Endif

Return (lExecuta)


