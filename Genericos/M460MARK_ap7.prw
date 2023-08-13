#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "topconn.ch"
User Function M460MARK()    // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

///////////////////////////////////////////////////////////////////////////////////
//PONTO DE ENTRADA NA GERAÇÃO DA NF SAÍDA, ONDE SERÁ VALIDADO SE PROSSEGUE OU NÃO
//COM A GERAÇÃO DA NF.
///////////////////////////////////////////////////////////////////////////////////

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cMsg := ""        
Local nSaldo := 0       
Local nTotFAT := 0       
Local eEmail := ""
Local aUsu   := {}
Local cUsu   := ""
Local subj   := ""
Local lSemSaldo := .F.
Local lBLQFATMIN := GetMv("RV_BLQFAT") //VOLTAR
Local nTOTALPED := 0
Local nSufr1    := 0
Local nSufr2    := 0
Local lTodoSelec:= .T.
Local nCtaITENS := 0 
Local cSelITENS := ""
Local cMsgC9    := ""
Local cMvEst		:= ""

SetPrvt("LFLAG,NC9ORD,NC9REG,NC5ORD,NC5REG,CHIST")
SetPrvt("CHIST1,CTES,CNOTA,ADIFE,NTOTAL,X")
SetPrvt("ADUPDNA,NC_EMIS,NC_BAIX,NBASE,NCOMIS,NPORCJUR")
Private lSacola := .F.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ M460MARK                                 ³ Data ³ 19.11.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Gera N.F. DNS para vendedor vd                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ponto de Entrada na geracao da nota fiscal.                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva as areas              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

aAreaSC5	:= getArea("SC5")
aAreaSC6	:= getArea("SC6")
aAreaSC9	:= getArea("SC9")
aAreaSA1	:= getArea("SA1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva Integridade dos Dados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

lFlag     := .t. 
lOkVd :=_lOk:=_lOkPai:=_lOkFilho:=.T.
_cPedBon:='' 
_cPedLib:='' 
cItemped:= ""
nC9Boni:='' 

nTOTALPED := 0

if SM0->M0_CODIGO == "02"
	subj   := "SALDO ESTOQUE INSUFICIENTE p/ Atender pedido VD - " + SC9->C9_PEDIDO + " - Filial: " + xFilial()
	cMsg   += "Apresentou Saldo Insuficiente em estoque para o(s) produto(s): " + CHR(13) + CHR(10)
	cMsg   += CHR(13) + CHR(10)
	///CAPTURA O EMAIL DO USUÁRIO LOGADO
	PswOrder(1)
	If PswSeek( __CUSERID , .T. )  
	   aUsu   := PSWRET() 				
	   cUsu   := Alltrim( aUsu[1][2] )  
	   //cNomeUsr:= Alltrim( aUsu[1][4] )  
	   eEmail:= Alltrim( aUsu[1][14] )
	   //cDeptoUsr:= Alltrim( aUsu[1][12] )
	Endif
  
  //nC9Reg := SC9->( Recno() )
  _cPedLib := SC9->C9_PEDIDO
  cItemped := SC9->C9_ITEM
  nTotal   := 0
  C5CLI    := ""
  C5LJENT  := ""
  C6TES    := ""
  xDD      := 0
  SC9->(DBSETORDER(1))
  SC9->( dbGotop() )
  	lTodoSelec := .T.
  	nCtaITENS  := 0
  	cSelITENS  := ""
  	nSelITENS  := 0
  	If SC9->(Dbseek(xFilial("SC9") + _cPedLib  ))
  	////////////////////////////////////////////////////////////////////////////////////////////////////////////
  	///FR - 02/08/13 - Solicitado por Rogério, para evitar de faturar sem selecionar todos os itens do pedido
  	///1o.laço para verificar se todos os itens foram selecionados
	//////////////////////////////////////////////////////////////////////////////////////////////////////////// 
		  Do While SC9->( !Eof() ) .and. SC9->C9_FILIAL == xFilial("SC9") .and. SC9->C9_PEDIDO ==_cPedLib
		   		   
		    If SC9->C9_OK != PARAMIXB[ 1 ] .and. Empty(SC9->C9_NFISCAL) //fica gravado no C9_OK mesmo qdo fatura
		    	lTodoSelec := .F.  //ficou algum sem selecionar
		    	nCtaITENS++        //QTD TOTAL ITENS DO PEDIDO
		    Elseif SC9->C9_OK == PARAMIXB[ 1 ] .and. Empty(SC9->C9_NFISCAL) //fica gravado no C9_OK mesmo qdo fatura
		    	cSelITENS += SC9->C9_ITEM + ","     //quais itens foram selecionados
		    	nSelITENS++                         //qtos itens foram selecionados
		    	nCtaITENS++       //QTD TOTAL DE ITENS DO PEDIDO
		    Endif          
		    
		    SC9->(Dbskip())
		  Enddo		  
		 
	Endif //seek no C9
	
	If !lTodoSelec 
		If MsgYesNo("O Pedido " + _cPedLib + " Possui : " + Alltrim(Str(nCtaITENS)) + " Itens " + CHR(13) + CHR(10);
		+", Você SELECIONOU " + Alltrim(Str(nSelITENS)) + " Itens: " + cSelITENS + CHR(13) + CHR(10);
		+" Continua Mesmo Assim ?")		
			lTodoSelec := .T.
		//Else
		//	Alert("parou")
		Endif
	Endif
  
	If lTodoSelec
	  SC9->(DBSETORDER(1))
	  SC9->( dbGotop() )
	  If SC9->(Dbseek(xFilial("SC9") + _cPedLib  ))
		  _lOk:=_lOkPai:=_lOkFilho:=.T.
		  Do While SC9->( !Eof() ) .and. SC9->C9_FILIAL == xFilial("SC9") .and. SC9->C9_PEDIDO ==_cPedLib
				   		   
		    SC5->( dbSetOrder( 1 ) )
		    SC5->( dbSeek( xFilial( "SC5" ) + SC9->C9_PEDIDO ) )
		    C5CLI :=  SC5->C5_CLIENTE
		    C5LJENT:= SC5->C5_LOJAENT
		    xDD    := SC5->C5_DESC1  //se estiver preenchido, é 6DD
		    SC6->( dbSetOrder( 1 ) )
		    SC6->( dbSeek( xFilial( "SC6" ) + SC9->C9_PEDIDO +  SC9->C9_ITEM + SC9->C9_PRODUTO ) )
		    C6TES := SC6->C6_TES
		    cMvEst	:= Posicione('SF4', 1, xFilial('SF4') + C6TES , 'F4_ESTOQUE')
	    		    
		    If SC9->C9_OK == PARAMIXB[ 1 ]  //se está selecionado/liberado pra faturar
		    	
			   
			    ////////////////////////////////////////////////////////////////////////////////
			    ////para apurar se o valor a ser faturado, está maior igual ao mínimo requerido:
			    ////////////////////////////////////////////////////////////////////////////////
			    nTotal := nTotal + ( SC9->C9_QTDLIB * SC9->C9_PRCVEN )
			    /*  //sem ipi
			    IF ALLTRIM(posicione('SF4', 1, xFilial('SF4') + C6TES , 'F4_IPI' ))='S'
			       nTotal += nTotal * 1.15
			    endif
			    */
				//VERIFICAR SE FOR SACOLA, O PEDIDO MÍNIMO MUDARÁ
				if SC6->C6_PRODUTO $ "GUB"
					lSacola := .T.
				endIf
				/*
				if ! empty( posicione('SA1', 1, xFilial('SA1') + C5CLI + C5LJENT, 'A1_SUFRAMA' ) )
				        
			        if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + C6TES , 'F4_ICM'))='S' // CALCULA ICM 
			           if ALLTRIM(posicione('SA1', 1, xFilial('SA1') + C5CLI + C5LJENT , 'A1_CALCSUF' )) $ 'S/I' 
			              nSufr1 := nTotal * 0.12                      
			           Endif   
			        endif 
				                
			        if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + C6TES , 'F4_PISCOF')) != '4' // CALCULA PIS/COFINS 
				        if ALLTRIM(posicione('SA1', 1, xFilial('SA1') + C5CLI + C5LJENT, 'A1_CALCSUF' )) $ 'S'       
				           if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + C6TES , 'F4_PISCOF')) $ '3' // AMBOS
				               nSufr2 := nTotal * 0.0925                    
				           ELSEif ALLTRIM(posicione('SF4', 1, xFilial('SF4') + C6TES , 'F4_PISCOF')) $ '1' // PIS	   
				               nSufr2 := nTotal * 0.0165                    	           
				           ELSEif ALLTRIM(posicione('SF4', 1, xFilial('SF4') + C6TES , 'F4_PISCOF')) $ '2' // COFINS
				               nSufr2 := nTotal * 0.076                    	           
				           ENDIF
				        ENDIF        
				    Endif
				        
		        	nTotal -= (nSufr1+nSufr2)    
	      
	    		endIf		 //seek no A1
				*/    		    
			    //fim da apuração p/ verificação valor mínimo
				//alert("numero: " + vNumero + " - serie: " + cSerie )	    			    
			     If ( 'VD' $ SC5->C5_VEND1 .and. ( Left( SX5->X5_CHAVE, 3) == 'UNI' .or. Left( SX5->X5_CHAVE, 1) == '0' ) );
			        .or. ( !'VD' $ SC5->C5_VEND1 .and. Left( SX5->X5_CHAVE, 3) == '   ' )
			         
			        Alert( "A Série escolhida: " + Left( SX5->X5_CHAVE, 3) + ", para Esta Nota: " + Left( SX5->X5_DESCRI, 3) + " , Não É Válida Para Esse Pedido/Item: " + SC9->C9_PEDIDO + "-"+SC9->C9_ITEM )
			        lFLAG := .F.
			     Endif
				      
			     // Se for VD ou XDD 	    
					If (SC5->C5_DESC1 > 0) .OR. 'VD' $ SC5->C5_VEND1
						//Verifica estoque do produto
						If !qtd(SC9->C9_PRODUTO , "XDD" )  //O QUE GRAVA NO C9, É O CODIGO XDD E NÃO O CÓDIGO NORMAL 
						//POR ISSO, NÃO DÁ PRA USAR ESSA FUNÇÃO: (U_transgen(SC9->C9_PRODUTO))

							ALERT('Foi detectado que não há saldo suficiente para o faturamento do produto ' + U_transgen(SC9->C9_PRODUTO) )
							
							RestArea(aAreaSC5)
							RestArea(aAreaSC6)
							RestArea(aAreaSC9)
							RestArea(aAreaSA1)
							
							Return .F. 
						EndIf
						//Verifica o limite de faturamento
						nTotFat	:= fLimXDD()
						If nTotFat + nTotal  > SUPERGETMV("MV_LIMVD",,220000) 

							ALERT('Ultrapassado o valor limite de R$ ' + Transform(SUPERGETMV("MV_LIMVD",,220000),"@E 9,999,999.99") + '. O valor atual está em R$ ' + Transform(nTotFat + nTotal,"@E 9,999,999.99") )
							
							RestArea(aAreaSC5)
							RestArea(aAreaSC6)
							RestArea(aAreaSC9)
							RestArea(aAreaSA1)
							
							Return .F. 
					    Endif
					Endif	         
					
				//FR - 27/08/13 - Solicitado por Eurivan
				//Inserir validação se o Cliente for Órgão Público (000009)
				//Fica liberado da validação da "NOTA CHEIA"
				SA1->(DbSetOrder(1))
				SA1->(DbSeek( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI  ))
				
				//Tec1 - EMC - 18/02/21
                //COMENTEI A VALIDACAO para faturamento parcil a pedido de Joao e autorizado por Marcelo

				/*
				If Alltrim(SA1->A1_SATIV1) != "000009" //se for diferente de órgão público, faz a validação "nota cheia"
				  
					If !ntCheia()   //função que verifica se o faturamento está sendo feito de todos os itens do SC6 ou parcial
						//a função retornará:
						// .T. = nota cheia
						// .F. = nota não cheia
					    //msg que será mostrada ao usuário:
						//msgAlert("Foi Detectado um Faturamento Quebrado ou Parcial. Para Liberar o Faturamento do mesmo, Digite a Sua Senha." + CHR(13) + CHR(10) ;
						//+ " Pedido: "+ SC9->C9_PEDIDO + " - Item: " + SC9->C9_ITEM + " - Produto: " + SC9->C9_PRODUTO +chr(10)+chr(13);
						//+ " Valor a Faturar "+ transform(_TMP2->PRCLIB,'@E 999,999,999.99')+" , Saldo "+transform(_ABC->PRCSALDO,'@E 999,999,999.99')  )
						
						if u_senha2("13",1)[1] //MARCELO, RENATO MAIA
					
							////////////////////////////////////////////////////////////////////////////
							//coloquei aqui o reclock, pois aceitou a senha para faturamento parcial
							//qdo aceita a senha diretor para fat. parcial, 
							//deve gravar num campo obs no Sc9 como registro desta liberação por senha
							////////////////////////////////////////////////////////////////////////////					
							
							RecLock("SC9",.F.)
							cMsgC9 := "QTDE PARCIAL -> LIBERADO C/ SENHA DIRETORIA / "
							SC9->C9_LIBINF := cMsgC9
							SC9->(MsUnlock())
						else
							lFLAG := .F.  //não aceitou a senha digitada, então não deixa faturar parcial, pois só a senha diretor é que libera
						endIf //if senha
					ENDIF //ntCheia 
				Endif //seek no A1
				*/

				//Se o TES movimenta estoque, verifica saldo.
				IF cMvEst = "S"
					If (SC5->C5_DESC1 > 0) .OR. 'VD' $ SC5->C5_VEND1  //se for Xdd
						If !qtd(SC9->C9_PRODUTO, "XDD")
						  	lFLAG := .F.
						endIf
					Else
						If !qtd(SC9->C9_PRODUTO)
						  	lFLAG := .F.
						endIf
					Endif
				EndIf
				
				// testa bonificacao				       
				If _lOk
					If !EMPTY(SC5->C5_NUMPAI) .OR. !EMPTY(SC5->C5_NUMFILH)
						_cPedBon:=SC9->C9_PEDIDO
					    nC9Boni:=SC9->( Recno() ) 
					    SC9->( dbSetOrder( 1 ) )
					    // pai
					    If !EMPTY(SC5->C5_NUMPAI)
					    	If SC9->( dbSeek( xFilial( "SC9" ) +SC5->C5_NUMPAI) )
					        	Do While SC9->( !Eof() ) .AND. SC9->C9_PEDIDO==SC5->C5_NUMPAI
						        	If SC9->C9_OK != PARAMIXB[ 1 ]
						            	_lOkPai:=.F.
						             Endif
					                 SC9->( dbSkip() )
					          	EndDo              
					            If  !_lOkPai
					            	Alert("O Pedido Pai "+alltrim(SC5->C5_NUMPAI)+" nao esta marcado, por isso o Pedido de Bonificacao "+alltrim(_cPedBon)+" nao podera ser Faturado.")
						            lFLAG :=u_senha2("13",1)[1] //MARCELO , RENATO MAIA
					            Endif
					     	Else
					        	alert('Pedido Pai '+alltrim(SC5->C5_NUMPAI)+' nao encontrado ')
					            lFLAG := u_senha2("13",1)[1] //MARCELO, RENATO MAIA
					        Endif
					    Endif
					    // bonificacao
					    If !EMPTY(SC5->C5_NUMFILH)
					    	If SC9->( dbSeek( xFilial( "SC9" ) +SC5->C5_NUMFILH) )
					        	Do While SC9->( !Eof() ) .AND. SC9->C9_PEDIDO==SC5->C5_NUMFILH
						        	If SC9->C9_OK != PARAMIXB[ 1 ]
						            	_lOkFilho:=.F.
						             Endif
						             SC9->( dbSkip() )
					          	EndDo              
					            If !_lOkFilho
					            	Alert("O Pedido de Bonificacao "+alltrim(SC5->C5_NUMFILH)+" nao esta marcado, por isso o Pedido de Pai "+alltrim(_cPedBon)+" nao podera ser Faturado.")
						            lFLAG := u_senha2("13",1)[1] //MARCELO, RENATO MAIA
					            Endif
					     	Else
					        	alert('Pedido de Bonifiacao '+alltrim(SC5->C5_NUMFILH)+' nao encontrado ')
					            lFLAG := u_senha2("13",1)[1] //MARCELO, RENATO MAIA
					        Endif
					    Endif
					    	SC9->( dbGoto( nC9Boni ) )
					        _lOk:=.F.
					    EndIf   //empty c5_numfilh
				  	EndIf       //EMPTY C5_NUMPAI .OR. C5_NUMFILH
				
				EndIf  //
				    
			    SC9->( dbSkip() )
		  EndDo
		  
		if ! empty( posicione('SA1', 1, xFilial('SA1') + C5CLI + C5LJENT, 'A1_SUFRAMA' ) )
		        
	        if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + C6TES , 'F4_ICM'))='S' // CALCULA ICM 
	           if ALLTRIM(posicione('SA1', 1, xFilial('SA1') + C5CLI + C5LJENT , 'A1_CALCSUF' )) $ 'S/I' 
	              nSufr1 := nTotal * 0.12                      
	           Endif   
	        endif 
		                
	        if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + C6TES , 'F4_PISCOF')) != '4' // CALCULA PIS/COFINS 
		        if ALLTRIM(posicione('SA1', 1, xFilial('SA1') + C5CLI + C5LJENT, 'A1_CALCSUF' )) $ 'S'       
		           if ALLTRIM(posicione('SF4', 1, xFilial('SF4') + C6TES , 'F4_PISCOF')) $ '3' // AMBOS
		               nSufr2 := nTotal * 0.0925                    
		           ELSEif ALLTRIM(posicione('SF4', 1, xFilial('SF4') + C6TES , 'F4_PISCOF')) $ '1' // PIS	   
		               nSufr2 := nTotal * 0.0165                    	           
		           ELSEif ALLTRIM(posicione('SF4', 1, xFilial('SF4') + C6TES , 'F4_PISCOF')) $ '2' // COFINS
		               nSufr2 := nTotal * 0.076                    	           
		           ENDIF
		        ENDIF        
		    Endif
		        
        	nTotal -= (nSufr1+nSufr2)    
  
		endIf		 //seek no A1

		  If lSemSaldo       //se estiver "sem Saldo" , envia um email ao operador avisando
		  	cMsg += CHR(13) + CHR(10)
		  	cMsg += " Favor Regularizar o Saldo em Estoque, para que a NF VD possa ser emitida."
		  	eEmail += ";" + "logistica@ravaembalagens.com.br"
		  	eEmail += ";" + "joao.emanuel@ravaembalagens.com.br"
		  	//eEmail += ";" + "flavia.rocha@ravaembalagens.com.br" 
		  	Alert(cMsg + " Verifique o seu E-mail.")
		  	U_SendFatr11(eEmail, "", subj, cMsg, "" )  
		  Endif
	      
	  
		SA1->(DbSetOrder(1))
		SA1->(DbSeek( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI  ))
		/////////////////////////////////////////////////////////////
		//FR - 27/08/13 - Solicitado por Eurivan
		//Inserir validação se o Cliente for Órgão Público (000009)
		//Fica liberado da validação de valor mínimo                 
		/////////////////////////////////////////////////////////////
		  If xDD = 0  .and.  Alltrim(SA1->A1_SATIV1) != "000009"//SE NÃO FOR 6dd e não for órgão público
			  If lBLQFATMIN      //parâmetro que indica se haverá ou não bloqueio por valor mínimo no faturamento
				  If !minimo( _cPedLib , nTotal ) 
				  	
					SX5->(Dbsetorder(1))
					SX5->(Dbseek(xFilial("SX5") + 'ZY' + '13' )) 
					MsgInfo("Somente com a Senha de: " + Alltrim(SX5->X5_DESCRI + SX5->X5_DESCSPA + SX5->X5_DESCENG) + chr(13) + chr(10) + ", Poderá ser Liberado." )
					lFLAG := u_senha2("13",1)[1] //MARCELO , RENATO MAIA
					//lFLAG := u_senha2("28",1)[1] //TESTE FLAVIA
						//alert("pede senha")
						//lFLAG := .T.
					If lFLAG  //grava no C9 que foi liberado com Senha
						SC9->(DBSETORDER(1))
						SC9->( dbGotop() )
						If SC9->(Dbseek(xFilial("SC9") + _cPedLib  ))
						  Do While SC9->( !Eof() ) .and. SC9->C9_FILIAL == xFilial("SC9") .and. SC9->C9_PEDIDO ==_cPedLib
						  	If SC9->C9_OK == PARAMIXB[ 1 ] //SE O ITEM LIDO É O QUE ESTÁ SELECIONADO PARA FATURAR
							  	//cMsgC9 := "QTDE PARCIAL -> LIBERADO C/ SENHA DIRETORIA / " //já tem esta gravada, adiciona mais uma:
							  	cMsgC9 += "VLR MINIMO -> LIBERADO C/ SENHA DIRETORIA "
							  	If RecLock("SC9",.F.)
							  		SC9->C9_LIBINF := cMsgC9
							  	Endif
							Endif
						  	SC9->(Dbskip())
						  Enddo
						Endif //seek no C9
					
					Endif //IF lFLAG
					
				  Endif //if !minimo		  
				  
			  Endif //se bloqueia por fat valor mínimo
		  //Else
		  // 	alert("6DD ok!")
		  Endif                 
	  
	  Endif  //dbseek no SC9
    Else 		//If !lTodoSelec 
	  	Alert("Você Não Selecionou Todos os Itens do Pedido!")
		RestArea(aAreaSC5)
		RestArea(aAreaSC6)
		RestArea(aAreaSC9)
		RestArea(aAreaSA1)
	    Return .F.    
    Endif //lTodoSelec
    
Endif //m0_filial = '02'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura as areas           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
RestArea(aAreaSA1)

Return( lFLAG )        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02


**************************
Static Function checaEmp()
**************************
Local lRet := .F.
Local cQr1 := cQry2 := ""

cQry1 := "select C5_VALEMPE "
cQry1 += "from   "+retSqlName("SC5")+" SC5 "
cQry1 += "where  C5_NUM = '"+SC9->C9_PEDIDO+"' "
cQry1 += "and C5_FILIAL = '"+xFilial('SC5')+"' and SC5.D_E_L_E_T_ != '*' "
cQry1 := changeQuery(cQry1)
TCQUERY cQry1 NEW ALIAS "_TMPP"
_TMPP->( dbGoTop() )

if _TMPP->C5_VALEMPE = 0
	lRet := .T.
else

endIf

Return lRet


*************************
Static Function ntCheia()
*************************
Local lRet := .T.
Local cQry1 := ""
Local cQry2 := ""
Local nQtC6 := 0
Local nPrC6 := 0
Local nQtC9 := 0
Local nPrC9 := 0
// alterado em 27/05/11 por antonio
//cQry1 := "select isnull(sum(C6_QTDVEN) - sum(C6_QTDENT),0) XYZ "
cQry1 := "select isnull(sum(C6_QTDVEN) - sum(C6_QTDENT),0) XYZ ,isnull(sum((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN),0) PRCSALDO "
cQry1 += "from   "+retSqlName("SC6")+" SC6  "
cQry1 += "where  C6_NUM = '"+SC9->C9_PEDIDO+"' "
cQry1 += "and C6_FILIAL = '"+xFilial('SC6')+"' and D_E_L_E_T_ != '*' "
cQry1 := changeQuery(cQry1)
TCQUERY cQry1 NEW ALIAS "_ABC"
_ABC->( dbGoTop() )
If _ABC->(!EOF())
	nQtC6 := _ABC->XYZ
	nPrC6 := _ABC->PRCSALDO
Endif

//cQuery := "select isnull(sum(C9_QTDLIB),0) CONT2 "
cQuery := "select isnull(sum(C9_QTDLIB),0) CONT2 ,isnull(sum(C9_QTDLIB*C9_PRCVEN),0) PRCLIB "
cQuery += "from   "+retSqlName("SC9")+" SC9  "
cQuery += "where  C9_PEDIDO = '"+SC9->C9_PEDIDO+"' "
cQuery += "and C9_NFISCAL = '' "  
//cQuery += "AND C9_BLEST = '' AND C9_BLCRED = '' "
// NOVA LIBERACAO DE CREDITO 
cQuery += "AND C9_BLEST = '' AND C9_BLCRED IN( '','04') "
cQuery += "and C9_FILIAL = '"+xFilial('SC9')+"' and D_E_L_E_T_ != '*' "
cQuery := changeQuery(cQuery)
TCQUERY cQuery NEW ALIAS "_TMP2"
_TMP2->( dbGoTop() )
If _TMP2->(!EOF())
	nQtC9 := _TMP2->CONT2
	nPrC9 := _TMP2->PRCLIB
Endif

//if _ABC->XYZ != _TMP2->CONT2
IF nQtC9 < nQtC6 .or. nQtC9 <> nQtC6
   lRet := .F.
endIf

if !lRet //retorno .F. para nota não cheia , retorno .T. para nota cheia
	msgAlert("Foi Detectado um Faturamento Quebrado ou Parcial. Para Liberar o Faturamento do mesmo, Digite a Sua Senha." + CHR(13) + CHR(10) ;
	+ " Pedido: "+ SC9->C9_PEDIDO + " - Item: " + SC9->C9_ITEM + " - Produto: " + SC9->C9_PRODUTO +chr(10)+chr(13);
	+ " Valor a Faturar "+ transform(_TMP2->PRCLIB,'@E 999,999,999.99')+" , Saldo "+transform(_ABC->PRCSALDO,'@E 999,999,999.99')  )
	//comentado por Flávia Rocha - 13/08/13 eu coloquei esta chamada da senha lá em cima onde é chamada a função ntcheia
	if u_senha2("13",1)[1] //MARCELO, RENATO MAIA 	
		lRet := .T.
	endIf
endIf

_ABC->( dbCloseArea() )
_TMP2->( dbCloseArea() )

Return lRet

*********************
Static Function qtd(cCodP, cTipoVen)
*********************
Local lRet    := .T.
Local cQuery  := cQuery2 := ""  
Local LF := CHR(13) + CHR(10)
Local cESTNEG := GetMv("MV_ESTNEG")  //se permite (S) ou não (N) movimentação que deixará o saldo negativo

cQuery := "select isnull(sum(C9_QTDLIB),0) XC9_QTDLIB " + LF
cQuery += "from  "+retSqlName("SC9")+" SC9, "  + LF
cQuery += " " +RetSqlName("SC6")+" SC6 " + LF
cQuery += "where C9_PEDIDO = '" + SC9->C9_PEDIDO + "' "  + LF

cQuery += " and C9_PRODUTO = '" + cCodP +"' " + LF
cQuery += " and C6_NUM = C9_PEDIDO "  + LF
cQuery += " and C9_PRODUTO = C6_PRODUTO "  + LF
cQuery += " and C9_ITEM = C6_ITEM " + LF
cQuery += " and C9_FILIAL = C6_FILIAL "  + LF

// NOVA LIBERACAO DE CREDITO
//cQuery += " and C9_BLEST = '' AND C9_BLCRED IN( '','04' ) " + LF //AGUARDANDO LIB CREDITO
cQuery += " and SC9.C9_BLCRED IN( '  ','99') and SC9.C9_BLEST != '10' " + LF   //LIBERADO NO CRÉDITO
cQuery += " and SC9.C9_NFISCAL = '' " + LF //só o SC9 cujo campo nota fiscal está em branco, senão, soma tudo e dá erro de saldo
cQuery += " and C9_FILIAL = '"+xFilial('SC9')+"' and SC9.D_E_L_E_T_ != '*' " + LF
cQuery += " and C6_FILIAL = '"+xFilial('SC6')+"' and SC6.D_E_L_E_T_ != '*' " + LF

MemoWrite("\TEMP\M460QTD.SQL", cQuery )
cQuery := changeQuery(cQuery) 

TCQUERY cQuery NEW ALIAS  "_TMPA"
_TMPA->( dbGoTop() )
cCodNormal := ""
if _TMPA->XC9_QTDLIB > 0
   ////////////////////////////////////////////
   ////FR - 07/03/14
   ///VERIFICA O SALDO DO PRODUTO NO SB2:      
   ////////////////////////////////////////////
   If Alltrim(cESTNEG) = "N"  //VERIFICA B2 SE ESTNEG = NÃO
   	 
	   cQuery1 := "select (B2_QATU) SALDO "
	   cQuery1 += "from  "+retSqlName('SB2')+" "
	   If Empty(cTipoVen)
	   		cQuery1 += "where B2_COD = '"+ cCodP +"' and B2_LOCAL = '"+SC9->C9_LOCAL+"' and D_E_L_E_T_ != '*' and B2_FILIAL = '"+xFilial('SB2')+"'
	   Else 
	   		//muda o código genérico para código normal, pra verificar o saldo, quando a venda for xDD.
	   		cCodNormal := U_Transgen(cCodP)
	   		cQuery1 += "where B2_COD = '"+ cCodNormal +"' and B2_LOCAL = '"+SC9->C9_LOCAL+"' and D_E_L_E_T_ != '*' and B2_FILIAL = '"+xFilial('SB2')+"'
	   Endif
	   	MEMOWRITE("\TEMP\B2SALDO460.SQL", cQuery1 )
	   
	   TCQUERY cQuery1 NEW ALIAS "_TMPB"
	   _TMPB->( dbGoTop() )
	
	   if _TMPB->SALDO - _TMPA->XC9_QTDLIB < 0
	      If Empty(cTipoVen)
	      	msgAlert("Foi detectado que não há saldo suficiente para o faturamento do produto "+ cCodP +" do pedido "+SC9->C9_PEDIDO+".") //voltar
	      Else       	
	      	cCodNormal := U_Transgen(cCodP)
	      	msgAlert("Foi detectado que não há saldo suficiente para o faturamento do produto "+ cCodNormal +" do pedido "+SC9->C9_PEDIDO+".")    //voltar
	      Endif
	      lRet := .F. //voltar
	   endIf
	   _TMPB->(dbCloseArea()) 
   Endif  
   
ELSE
      //
      msgAlert("Quantidade Liberada zerada ou negativa")
      //msgAlert("Quantidade Liberada zerada ou negativa - click OK para passar")
      lRet := .F.
endif
//lRet := .T.
_TMPA->(dbCloseArea())

Return lRet

****************
Static Function RunProc()
****************
/*
nC9Ord := SC9->( dbSetOrder() )
nC9Reg := SC9->( Recno() )
SC9->( dbSetOrder( 1 ) )
SC9->( dbGotop() )
ProcRegua( RecCount() )
While SC9->( !Eof() )
         // CMARCA LINVERTE
   If SC9->C9_OK == "    " .and. SC9->C9_NFISCAL == SPACE( 06 ) .and. SC9->C9_BLEST == "  " .and. SC9->C9_BLCRED == "  "
      nC5Ord := SC5->( DbSetOrder() )
      nC5Reg := SC5->( Recno() )
      SC5->( dbSetOrder( 1 ) )
      SC5->( dbSeek( xFilial( "SC5" ) + SC9->C9_PEDIDO ) )
      SA1->( dbSeek( xFilial( "SA1" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI, .T. ) )
      cHist  := Alltrim( SA1->A1_TEL )
      cHIst  := cHist + iif( Substr( SC5->C5_TIPAGTO, 1, 1 )=="C"," - Ch.nao Rc",iif( Substr( SC5->C5_TIPAGTO, 1, 1 )=="R"," - Ch.nao Rc","" ) )
      cHist1 := Alltrim( SA1->A1_TEL )
      cHIst1 := cHist + iif( Substr( SC5->C5_TIPAGTO, 2, 1 )=="C"," - Ch.Receb.",iif( Substr( SC5->C5_TIPAGTO, 2, 1 )=="R"," - Ch.Receb.","" ) )
      if 'VD' $ SC5->C5_VEND1
         SX6->( dbSeek( xFilial( "SX6" ) + "MV_TESDNA", .T. ) )
         cTes := Alltrim( SX6->X6_CONTEUD )
         SX6->( dbSeek( xFilial( "SX6" ) + "MV_DNS", .T. ) )
         cNota := Strzero( Val( Alltrim( SX6->X6_CONTEUD ) ) + 1, 6 )
         aDife := {}
         while SC9->C9_PEDIDO == SC5->C5_NUM .and. SC9->( !Eof() )
            SC6->( dbSeek( xFIlial( "SC6" ) + SC9->C9_PEDIDO + SC9->C9_ITEM ) )
            Aadd( aDife, { SC9->C9_PRODUTO, SC9->C9_QTDLIB, SC9->C9_PRCVEN, cTes, SC6->C6_CF,;
               SC6->C6_NUM, SC6->C6_ITEM, SC6->C6_LOCAL, SC6->C6_UNSVEN, "N",;
               SC5->C5_COMIS1, SC6->C6_CLASFIS, SC5->C5_COMIS1 } )
            Reclock( "SC6", .F. )
            SC6->C6_QTDENT := SC6->C6_QTDENT + SC9->C9_QTDLIB
            SC6->C6_QTDEMP := SC6->C6_QTDLIB := 0
            SC6->C6_ENTREG := dDatabase
            SC6->C6_NOTA   := cNota;          SC6->C6_SERIE  := "   "
            SC6->C6_DATFAT := dDatabase
            SC6->( msUnlock() )

            Reclock( "SC9", .f. )
            SC9->C9_BLEST   := SC9->C9_BLEST := "10"
            SC9->C9_NFISCAL := cNota; SC9->C9_SERIENF := "   "
//            SC9->C9_OK      := "DN"
            SC9->( msUnlock() )
            SC9->( dbSkip() )

         end

         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Geracao itens nota fiscal Ravitec                            ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         nTotal := 0
         For x := 1 to Len( aDife )
             SB1->( dbSeek( xFilial( "SB1" ) + aDife[ x, 1 ], .t. ) )
             RecLock( "SD2", .T. )
             SD2->D2_FILIAL  := xFilial( "SD2" ); SD2->D2_COD     := aDife[ x, 1 ]
             SD2->D2_UM      := SB1->B1_UM   ;    SD2->D2_SEGUM   := SB1->B1_SEGUM
             SD2->D2_QUANT   := aDife[ x, 2 ]  ;  SD2->D2_PRCVEN  := aDife[ x, 3 ]
             SD2->D2_TOTAL   := Round( aDife[ x, 2 ] * aDife[ x, 3 ], 2 )
             SD2->D2_TES     := aDife[ x, 4 ]  ;  SD2->D2_CF      := aDife[ x, 5 ]
             SD2->D2_PEDIDO  := aDife[ x, 6 ]  ;  SD2->D2_ITEMPV  := aDife[ x, 7 ]
             SD2->D2_CLIENTE := SC5->C5_CLIENTE;  SD2->D2_LOJA    := SC5->C5_LOJACLI
             SD2->D2_LOCAL   := aDife[ x, 8 ]  ;  SD2->D2_DOC     := cNota
             SD2->D2_EMISSAO := dDatabase      ;  SD2->D2_GRUPO   := SB1->B1_GRUPO
             SD2->D2_TP      := SB1->B1_TIPO   ;  SD2->D2_SERIE   := "   "
             SD2->D2_PRUNIT  := aDife[ x, 3 ]  ;  SD2->D2_QTSEGUM := aDife[ x, 9 ]
             SD2->D2_NUMSEQ  := " "            ;  SD2->D2_EST     := SA1->A1_EST
             SD2->D2_TIPO    := aDife[ x, 10 ] ;  SD2->D2_ITEM    := StrZero( x, 2 )
             SD2->D2_COMIS1  := aDife[ x, 11 ] ;  SD2->D2_CLASFIS := aDife[ x, 10 ]
             SD2->( msUnlock() )
             SD2->( dbcommit() )

             nTotal := nTotal + SD2->D2_TOTAL

         Next

         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Geracao Comissao pela emissao Ravitec                        ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         SA3->( dbSeek( xFilial( "SA3" ) + SC5->C5_VEND1 ) )
         aDupDna := Condicao( nTotal, SC5->C5_CONDPAG )
         nC_emis := SA3->A3_ALEMISS
         nC_baix := SA3->A3_ALBAIXA

         if nC_emis > 0
            nBase  := Round( nTotal*nC_emis/100, 2 )
            nComis := Round( nBase *SC5->C5_COMIS1/100, 2 )
            Reclock( "SE3", .T. )
            SE3->E3_FILIAL  := xFilial( "SE3" ); SE3->E3_VEND    := SF2->F2_VEND1
            SE3->E3_NUM     := SF2->F2_DOC;      SE3->E3_COMIS   := nComis
            SE3->E3_PORC    := SC5->C5_COMIS1;   SE3->E3_EMISSAO := SF2->F2_EMISSAO
            SE3->E3_CODCLI  := SF2->F2_CLIENTE;  SE3->E3_LOJA    := SF2->F2_LOJA
            SE3->E3_BASE    := nBase
            SE3->E3_PREFIXO := "   "        ;    SE3->E3_PEDIDO  := SC5->C5_NUM
            SE3->E3_TIPO    := "NF";             SE3->E3_BAIEMI  := "E"
            SE3->( msUnlock() )
         endif

         SX6->( dbSeek( "  MV_TXPER", .t. ) )
         nPorcJur := Val( SX6->X6_CONTEUD )
         nBase := Round( nTotal*nC_baix/100/ Len( aDupDna ),2 )
         nComis:= Round( nBase *SC5->C5_COMIS1/100, 2 )

         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Geracao Duplicatas Ravitec                                   ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

         For x := 1 to Len( aDupDna )
             RecLock( "SE1", .T. )
             SE1->E1_FILIAL  := xFilial("SE1") ;  SE1->E1_PREFIXO := "   "
             SE1->E1_NUM     := cNota          ;  SE1->E1_PARCELA := Strzero( x, 1 )
             SE1->E1_TIPO    := "NP"           ;  SE1->E1_NATUREZ := SA1->A1_NATUREZ
             SE1->E1_CLIENTE := SC5->C5_CLIENTE;  SE1->E1_LOJA    := SC5->C5_LOJACLI
             SE1->E1_NOMCLI  := SA1->A1_NREDUZ ;  SE1->E1_EMISSAO := dDatabase
             SE1->E1_VENCTO  := aDupDna[ x, 1] ;  SE1->E1_VENCREA := DataValida( aDupDna[ x, 1 ] )
             SE1->E1_VALOR   := aDupDna[ x, 2 ];  SE1->E1_SITUACA := "0"
             SE1->E1_SALDO   := aDupDna[ x, 2 ];  SE1->E1_VEND1   := SC5->C5_VEND1
             SE1->E1_FLUXO   := "S"            ;  SE1->E1_LA      := "S"
             SE1->E1_EMIS1   := aDupDna[ x, 1 ];  SE1->E1_MOEDA   := 1
             SE1->E1_VLCRUZ  := aDupDna[ x, 2 ];  SE1->E1_ORIGEM  := "M460MARK"
             SE1->E1_VALJUR  := 0              ;  SE1->E1_PORCJUR := nPorcJur
             SE1->E1_COMIS1  := SC5->C5_COMIS1 ;  SE1->E1_BASCOM1 := nBase
             SE1->E1_VALCOM1 := nComis         ;  SE1->E1_VENCORI := aDupDna[ x, 1 ]
             SE1->E1_PEDIDO  := SC5->C5_NUM    ;  SE1->E1_HIST    := cHist
             SE1->( msUnlock() )

             If aDupDna[ x, 2 ] > SA1->A1_MAIDUPL
                RecLock( "SA1", .f. )
                SA1->A1_MAIDUPL := aDupDna[ x, 2 ]
                SA1->( MsUnlock() )
             Endif

         Next

         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Grava cabecalho de nota fiscal na Ravitec                    ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

         RecLock( "SF2", .T. )
         SF2->F2_FILIAL  := xFilial( "SF2" ); SF2->F2_DOC     := cNota
         SF2->F2_SERIE   := "   "          ;  SF2->F2_CLIENTE := SC5->C5_CLIENTE
         SF2->F2_LOJA    := SC5->C5_LOJACLI;  SF2->F2_COND    := SC5->C5_CONDPAG
         SF2->F2_DUPL    := cNota          ;  SF2->F2_EMISSAO := dDatabase
         SF2->F2_EST     := SA1->A1_EST    ;  SF2->F2_FRETE   := SC5->C5_FRETE
         SF2->F2_SEGURO  := SC5->C5_SEGURO ;  SF2->F2_TIPOCLI := SA1->A1_TIPO
         SF2->F2_VALBRUT := nTotal         ;  SF2->F2_VALMERC := nTotal
         SF2->F2_TIPO    := "N"            ;  SF2->F2_ESPECI1 := SC5->C5_ESPECI1
         SF2->F2_VOLUME1 := SC5->C5_VOLUME1;  SF2->F2_TRANSP  := SC5->C5_TRANSP
         SF2->F2_REDESP  := SC5->C5_REDESP ;  SF2->F2_VEND1   := SC5->C5_VEND1
//         SF2->F2_OK      := " "            ;  SF2->F2_FIMP    := " "
         SF2->F2_VALFAT  := nTotal         ;  SF2->F2_ESPECIE := "NF"
         SF2->F2_DESPESA := SC5->C5_DESPESA;  SF2->F2_PREFIXO := "   "

         SF2->( msUnlock() )
         SF2->( dbcommit() )

         RecLock( "SA1", .f. )
         if nTotal > SA1->A1_MCOMPRA
            SA1->A1_MCOMPRA := nTotal
         endif

         if nTotal  + SA1->A1_SALDUP > SA1->A1_MSALDO
            SA1->A1_MSALDO := SA1->A1_SALDUP + nTotal
         endif

         if Empty( SA1->A1_PRICOM )
            SA1->A1_PRICOM := dDatabase
         endif

         SA1->A1_NROCOM := SA1->A1_NROCOM + 1
         SA1->A1_ULTCOM := dDatabase
         SA1->A1_SALDUP := SA1->A1_SALDUP + nTotal
         SA1->A1_VACUM  := SA1->A1_VACUM  + nTotal
         SA1->( MsUnlock() )
         SA1->( dbCommit() )

         SX6->( dbSeek( xFilial( "SX6" ) + "MV_DNS", .T. ) )
         RecLock( "SX6", .f. )
         SX6->X6_CONTEUD := cNota
         SX6->( msUnlock() )
         SX6->( dbcommit() )

      endif

   EndIf
   SC9->( dbSkip() )
   IncProc()
EndDo

SC9->( dbSetOrder( nC9Ord ) )
SC9->( dbGoto( nC9Reg ) )
*/
Return              


**************

Static Function fVALORX(cNum)

***************
local cQry:=''
Local nRet:=0

cQry:="SELECT VALOR=SUM((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN) "
cQry+="FROM  "+retSqlName("SD2")+" SD2 WITH (NOLOCK),  "+retSqlName("SB1")+" SB1 WITH (NOLOCK),  "+retSqlName("SF2")+" SF2 WITH (NOLOCK) "
cQry+="WHERE SUBSTRING(D2_EMISSAO,1,6) ='"+SUBSTR(DTOS(DDATABASE),1,6)+"' "
cQry+="AND D2_SERIE = '' "
cQry+="AND D2_TIPO = 'N' "
cQry+="AND D2_TP != 'AP'  "
cQry+="AND RTRIM(D2_CF) IN ('511','5101','5107','611','6101','512','5102','612','6102','6109','6107','5949','6949','5922','6922','5116','6116' ) "
cQry+="AND D2_TES NOT IN ('540','516') "
cQry+="AND SUBSTRING(D2_COD,1,1)!='M'   "
cQry+="AND SD2.D_E_L_E_T_ = '' AND D2_COD = B1_COD "
cQry+="AND SB1.D_E_L_E_T_ = '' "
cQry+="AND D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA "
cQry+="AND F2_DUPL <> ' ' "
cQry+="AND SF2.D_E_L_E_T_ = ''  "
TCQUERY cQry NEW ALIAS  "TMPM"
cQry:=''
cQry:="SELECT SUM(C6_VALOR) VALOR FROM  "+retSqlName("SC6")+" SC6 "
cQry+="WHERE  C6_FILIAL='"+XFILIAL('SC6')+"' "
cQry+="AND C6_NUM='"+cNum+"'"
cQry+="AND SC6.D_E_L_E_T_<>'*' "
MemoWrite("C:\TEMP\FVALORX.SQL",cQry)
TCQUERY cQry NEW ALIAS  "TMPN"

nRet:= TMPM->VALOR+TMPN->VALOR

TMPM->(dbclosearea())
TMPN->(dbclosearea())

Return nRet



***************
Static Function minimo( cPedido, nTotal )
***************

Local nReg
Local nOrder
Local cEST   := ""
Local lOk := .T.
//Local nPedMINSC := GETMV("RV_PDMINSC") //sacos  1.600,00
//Local nPedMINCX := GETMV("RV_PDMINCX") //CAIXAS 1.600,00
//Local nPedMINS:= GETMV("RV_PEDMINS") //sacolas
Local cPedC5  := ""
Local nQTC6   := 0
Local nPrcC6  := 0 
Local cTESC6  := ""
Local cLOCC6  := ""
Local cProdC6 := ""
Local cCli    := ""
Local cLj     := "" 
Local cLJEnt  := ""
Local nCount  := 0
Local cItemC6 := ""
//Local nPedMINE := GETMV("RV_VALMINE") //VALOR MÍNIMO REGIÃO NORDESTE
//Local nPedMINO := GETMV("RV_VALMINO") //VALOR MÍNIMO REGIÃO NORTE
//Local nPedMICO := GETMV("RV_VALMICO") //VALOR MÍNIMO REGIÃO CENTRO-OESTE
//Local nPedMISU := GETMV("RV_VALMISU") //VALOR MÍNIMO REGIÃO SUDESTE
//Local nPedMISD := GETMV("RV_VALMISD") //VALOR MÍNIMO REGIÃO SUL
Local nPedMIN := 0 //VALOR MÍNIMO PARA PEDIDOS QUE IRÁ VARIAR DE ACORDO COM A REGIÃO
Local cRegiao  := ""
Local cNomeReg := ""

DbSelectArea("SC5")
SC5->(Dbsetorder(1))
If SC5->(Dbseek(xFilial("SC5") + cPedido ))
	cPedC5 := SC5->C5_NUM
	cCli   := SC5->C5_CLIENTE
	cLj    := SC5->C5_LOJACLI
	cLJEnt := SC5->C5_LOJAENT
	if SC5->C5_TIPO == 'D'
	   Return .T.
	endif
	
	if alltrim(SC5->C5_TRANSP) $ "024"
	   return .T.
	endIf

Endif

// pedido para grande joao pessoa
 DbSelectArea("SA1")
 DbSetORder(1)
 if SA1->(DbSeek(xFilial("SA1")+ cCli + cLj,.F.))
                               // JP  /BAYEX/S.RITA/CABEDELO
    If alltrim(SA1->A1_COD_MUN)$'07507/01807/13703/03209'
       Return .T.
    Endif
      
	if SA1->A1_SATIV1 == "000009"
	   return .T.
	endIf	
	
	If SA1->A1_EST $ "AC/AM/AP/PA/RO/RR/TO"
    	cRegiao := 'NO'  //NORTE
    	nPedMIN := GETMV("RV_VALMINO") 
    	cNomeReg:= "NORTE"
    ElseIf SA1->A1_EST $ "MA/PI/CE/RN/PB/PE/AL/BA/SE"
    	cRegiao := 'NE'         //NORDESTE
    	nPedMIN := GETMV("RV_VALMINE")
	   	cNomeReg:= "NORDESTE"
	ElseIf SA1->A1_EST $ "GO/MT/MS/DF"
		cRegiao := 'CO'                   //CENTRO-OESTE
		nPedMIN := GETMV("RV_VALMICO")
    	cNomeReg:= "CENTRO-OESTE"
	ElseIf SA1->A1_EST $ "MG/ES/RJ/SP"
		cRegiao := 'SD'               //SUDESTE
		nPedMIN := GETMV("RV_VALMISD")
    	cNomeReg:= "SUDESTE"
	ElseIf SA1->A1_EST $ "RS/PR/SC"
		cRegiao := "SU"	            //SUL
		nPedMIN := GETMV("RV_VALMISU")
    	cNomeReg:= "SUL"
	Endif

 endif

DbselectArea("SC6")
SC6->(DbSetorder(1))
If SC6->(Dbseek(xFilial("SC6") + cPedC5 ))
	While SC6->(!EOF()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == cPedC5 
		
		nQTC6   := SC6->C6_QTDVEN
		nPrcC6  := SC6->C6_PRUNIT
		cTESC6  := SC6->C6_TES
		cLOCC6  := SC6->C6_LOCAL
		cProdC6 := SC6->C6_PRODUTO
		cItemC6 := SC6->C6_ITEM
        
		////////////////////////////
		///TESTA TES
		//if testaTes(cTESC6)
		//	return .T.
		//endIf
		if SC6->C6_TES $ "514/516/561/522"
			Return .T.
		endIf	
		SC6->(Dbskip())
    Enddo
    /*
	If !lSacola
		If ALLTRIM(xfilial('SC9'))='01' // SACO
			if nTotal < nPedMINSC  // < 1600
			   lOk := .F.
			   //msgAlert("O pedido não atingiu o valor mínimo de: R$ 1.000,00" )
			   msgAlert("SACOS: A NOTA FISCAL NÃO atingiu o valor mínimo de: R$ " + Transform( nPedMINSC , "@E 9,999,999.99") )
			   //Return LIBMIN(cPedC5)	   
			endif   
		ELSEIf ALLTRIM(xfilial('SC9'))='03' // CAIXA	
			if nTotal < nPedMINCX 	  // < 1600
			   lOk := .F.
			   //msgAlert("O pedido não atingiu o valor mínimo de: R$ 500,00" )
			   msgAlert("CAIXAS: A NOTA FISCAL NÃO atingiu o valor mínimo de: R$ " + Transform( nPedMINCX , "@E 9,999,999.99") )
			   //Return LIBMIN(cPedC5)	   
			endif   
		ENDIF
	Else
		if nTotal < nPedMINS  //< 1000
		   lOk := .F.
		   //msgAlert("O pedido não atingiu o valor mínimo de: R$ 1.000,00" )
		   msgAlert("SACOLA: A NOTA FISCAL NÃO atingiu o valor mínimo de: R$ " + Transform( nPedMINS , "@E 9,999,999.99") )
		   //Return LIBMIN(cPedC5)	   
		endif  
	Endif 
	*/
//FR - 23/07/13
///////////////////////////////////////////////
//NOVA SISTEMÁTICA DE PEDIDO MÍNIMO POR REGIÃO 
///////////////////////////////////////////////
//nPedMIN := 1600 //retirar
If nTotal < nPedMIN
   lOk := .F.
   msgAlert(" A NOTA FISCAL Não Atingiu o Valor Mínimo de: R$ " + Transform( nPedMIN , "@E 999,999,999.99") + " Para a Região: " + cNomeReg )   
endif   
	
Endif //seek no C6

return lOk
 

***************
     
Static Function LIBMIN( C5NUM )

***************

//Posiciona na Tab. de Liberacao Pedido  
DbSelectArea("Z40")
DbSetOrder(1)      
If DbSeek(xFilial("Z40")+ C5NUM+'V')  
   If Z40->Z40_STATUS='B'	 // Bloqueado	       
      Alert( "Pedido ainda não foi Liberado para o Valor Mínimo !!" )
      Return .F.
   ElseIf  Z40->Z40_STATUS='J' // Liberado
	  Alert( "Pedido precisa de uma  Nova Liberação para o Valor Mínimo !!" )
	  Return .F.   
   ElseIf  Z40->Z40_STATUS='L' // Liberando...	       
      RecLock("Z40",.F.) 
	  Z40->Z40_STATUS:='J'	// finaliza a liberacao e muda o status para liberado	       
	  Z40->(MsUnLock())
      Return .T.
   Endif      
Else
   RecLock("Z40",.T.)
   Z40->Z40_FILIAL:=xFilial("Z40")
   Z40->Z40_PEDIDO:=M->C5_NUM
   Z40->Z40_DTEMIS:=M->C5_EMISSAO
   Z40->Z40_STATUS:='B'
   Z40->Z40_TIPO:='V'
   Z40->(MsUnLock())
   Alert( "Pedido precisa de Liberação para o Valor Mínimo !!" )
   Return .F.
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fLimXDD  º Autor ³ Gustavo Costa     º Data ³  14/08/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada para calcular o % do XDD           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fLimXDD()

local cQry		:= ''
Local nRet		:= 0
Local nFora	:= 0
Local nTotal	:= 0

cQry:=" SELECT SUM(E1_VALOR) FORA FROM  " + RetSqlName("SE1") + " WITH (NOLOCK) "
cQry+=" WHERE D_E_L_E_T_ <> '*' "
cQry+=" AND E1_FILIAL = '" + xFilial("SE1") + "'"
cQry+=" AND E1_EMISSAO >= '" + DtoS(FirstDay(dDataBase)) + "'" 
cQry+=" AND E1_PREFIXO = ''"
cQry+=" AND E1_TIPO = 'NF' "

TCQUERY cQry NEW ALIAS  "TMPM"

dbSelectArea("TMPM")
TMPM->(dbGoTop())

nFora := TMPM->FORA

TMPM->(dbclosearea())

cQry:=" SELECT SUM(D2_TOTAL) VALOR FROM " + RetSqlName("SD2") + " WITH (NOLOCK) "
cQry+=" WHERE D_E_L_E_T_ <> '*' "
cQry+=" AND D2_EMISSAO >= '" + DtoS(FirstDay(dDataBase)) + "'"
cQry+=" AND D2_TIPO = 'N' "
cQry+=" AND D2_FILIAL = '" + xFilial("SD2") + "'"
cQry+=" AND substring(D2_CF,1,2) IN ('51','61') "
cQry+=" AND D2_CF NOT IN ('5151','5152') "

TCQUERY cQry NEW ALIAS  "TMPM"

dbSelectArea("TMPM")
TMPM->(dbGoTop())

nTotal := TMPM->VALOR

TMPM->(dbclosearea())

//se não tiver faturamento, considera 100% já utilizado
If nFora = 0 .OR. nTotal = 0
	nRet	:= 100
Else
	nRet	:= ( nFora / nTotal ) * 100
EndIf

//alterado para retornar só o faturamento.
//Return nRet
Return nFora

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fTotPV   º Autor ³ Gustavo Costa     º Data ³  14/08/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada para calcular o total do pedido    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fTotPV()

local cQry		:= ''
Local nRet		:= 0

cQry:=" SELECT SUM(D2_TOTAL) VALOR FROM " + RetSqlName("SD2") + " WITH (NOLOCK) "
cQry+=" WHERE D_E_L_E_T_ <> '*' "
cQry+=" AND D2_EMISSAO >= '" + DtoS(FirstDay(dDataBase)) + "'"
cQry+=" AND D2_TIPO = 'N' "
cQry+=" AND D2_FILIAL = '" + xFilial("SD2") + "'"
cQry+=" AND substring(D2_CF,1,2) IN ('51','61') "
cQry+=" AND D2_CF NOT IN ('5151','5152') "

TCQUERY cQry NEW ALIAS  "TMPM"

dbSelectArea("TMPM")
TMPM->(dbGoTop())

nTotal := TMPM->VALOR

TMPM->(dbclosearea())

//se não tiver faturamento, considera 100% já utilizado
If nFora = 0 .OR. nTotal = 0
	nRet	:= 100
Else
	nRet	:= ( nFora / nTotal ) * 100
EndIf

//alterado para retornar só o faturamento.
//Return nRet
Return nTotal

