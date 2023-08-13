#INCLUDE 'RWMAKE.CH'
#include "topconn.ch" 
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TK271FIMGRºAutor  ³Eurivan Marques     º Data ³  24/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³WorkFlow na confirmacao do atendimento para responsaveis.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CallCenter                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//A função TK271FIMGR é um ponto de entrada na confirmação do atendimento, dentro de: 
//Call Center > Atualizações > Atendimento > Agenda do Operador

**************************
User function TK271FIMGR()
**************************

Local aArea     := GetArea()
Local aRespo    := {}
Local aReenvio  := {}
Local lEnvio    := .F.
Local lRenvio	:= .F.
Local cUCFilial := SUC->UC_FILIAL
Local cUCcodigo := SUC->UC_CODIGO
Local cUCchave  := SUC->UC_CHAVE     //CÓDIGO CLIENTE + LOJA
Local cNOTACLI  := SUC->UC_NFISCAL
Local cSERINF   := SUC->UC_SERINF
Local cEntidade := ""
Local cUCEntida := SUC->UC_ENTIDAD
Local cChave    := SUC->UC_CHAVE
//Local cUCorigem := SUC->UC_ORIGEM
Local dUCPrvChg := SUC->UC_PREVCHG
Local dUCRealChg:= SUC->UC_REALCHG
Local dUCAtraso := SUC->UC_DATRASO
Local dDtAgCli  := SUC->UC_DTAGCLI
Local cRetencao := SUC->UC_RETENC
//Local cPosFis   := SUC->UC_POSFIS
Local dAgINT	:= SUC->UC_DTAGINT
Local cLista	:= ""
Local cCodLig   := ""
Local cMailCC	:= "" 
Local cSegmento := ""
Local aParc     := {}
Local cCondPag  := ""  
Local nF2Valbrut:= 0
Local nF2Valipi := 0 
Local p			:= 0
Local cParcela  := ""


Local cUDCodigo := ""
Local cUDitem	:= ""
Local cExecut   := ""
Local cExecutAnt:= ""
Local lReagALT  := .F.
Local lReag2ALT := .F.
Local lReag3ALT := .F.
Local nFolderFR := nFolder
Local lItens    := .F. 
Local lSemItem  := .F.
Local lREAGENDAR:= .F.
Local lEncerP   := .F.  	//SINALIZA QUE PODE FINALIZAR A LIGAÇÃO PROBLEMA -> UC_OBSPRG = "S" - Atua na Inclusão
Local lEncerOK  := .F.      //SINALIZA QUE PODE FINALIZAR A LIGAÇÃO QUE JÁ TEM ITENS RESOLVIDOS E CHEGADA OK. - Atua na Alteração
Local lEncerT   := .F.      //SINALIZA QUE PODE FINALIZAR A LIGAÇÃO QUE É PARA TRANSPORTADORA - UC_ENTIDAD = "SA4" - Atua na Inclusão
Local cOperador := ""
Local cTipoATD  := ""
Local lTLV      := .F.

Local aRetenc	:= {}
Local aPosFis   := {}
Local cTransp	:= ""
Local cRedesp   := ""
Local cTelef	:= ""
Local lNewITEM:= .F.
Local dPrevCheg := CtoD("  /  /    ")
Local dAGcli	:= CtoD("  /  /    ")
Local nTipoMail := 0 
Local LF      	:= CHR(13)+CHR(10)
Local cU4Lista	:= "" 
Local cOper		:= GetNewPar("MV_XOPERTM","000018")

Private	cObsSUC	  := MSMM(SUC->UC_CODOBS)
Private cUsuario  := ""

cUsuario := __CUSERID
SU7->(DbSetorder(4))
If SU7->(Dbseek(xFilial("SU7") + cUsuario ))
  	cTipoATD := SU7->U7_TIPOATE	
Endif

lTLV := Alltrim( cTipoATD ) = "2"
	   	  
If !lTLV
	//nFolder = 1 -> Telemarketing
	//nFolder = 2 -> Televendas
	If nFolder = 1
	
			////atualiza operador 
			///será tratado no agendamento
			///as ligações de ocorrências, gravar o operador de Daniela
			///as ligações de feedback , gravar o operador SAC
			DbselectArea("SU4")
			SU4->(Dbsetorder(4))   //codlig
			If SU4->(Dbseek(xFilial("SU4") + SUC->UC_CODIGO ))
			    If ("!" $ SU4->U4_DESC )    //SE FOR LIGAÇÃO COM OCORRÊNCIA, GRAVA O OPERADOR pablo.alves
					If RecLock("SU4", .F.)
						//msgbox("achou a lista")
						SU4->U4_OPERAD := cOper //'000017' 
						SU4->(MsUnlock())
					Endif
				
					If RecLock("SUC", .F.)
						SUC->UC_OPERADO := cOper//'000017'
						SUC->(MsUnlock())
					Endif
				Else      //se não for ocorrência,grava o operador SAC
					
					If RecLock("SU4", .F.)
						//msgbox("achou a lista")
						SU4->U4_OPERAD := cOper//"000017"//'999999' 
						SU4->(MsUnlock())
					Endif
				
					If RecLock("SUC", .F.)
						SUC->UC_OPERADO := cOper//"000017"//'999999'
						SUC->(MsUnlock())
					Endif
				Endif
			Endif
			
			
			
			////atualiza SF2
			DbselectArea("SF2")
			Dbsetorder(1)
			If SF2->(Dbseek(xFilial("SF2") + cNOTACLI + cSERINF )) 
				cCondPag := SF2->F2_COND
				nF2Valipi:= SF2->F2_VALIPI
				nF2Valbrut:= SF2->F2_VALBRUT
				cPedVenda := ""				
				//While  SF2->(!EOF()) .And. SF2->F2_FILIAL == xFilial("SF2") .And. SF2->F2_DOC == cNOTACLI .And. SF2->F2_SERIE == cSERINF
				
					RecLock("SF2",.F.)
					SF2->F2_RETENC 	:= cRetencao
					//SF2->F2_POSFIS  := cPosFis
					//If !Empty(dDtAgCli)
						SF2->F2_DTAGCLI	:= dDtAgCli
					//Endif
					
					If !Empty(dUCRealChg)
						SF2->F2_REALCHG := dUCRealChg				
						///QDO REGISTRAR A DATA CHEGADA DA NF, ATUALIZA TAMBÉM O ARQUIVO ETAPAS PEDIDO VENDA
						/////////////////////////////////////////////////////////////////////////////////
						///SOLICITADO POR EURIVAN - ETAPAS PEDIDO VENDA
						///FR 16/10/13 - FLÁVIA ROCHA - IMPLEMENTAR HISTÓRICO DO PEDIDO A CADA ETAPA REALIZADA
						///AQUI, QDO REGISTRAR A CHEGADA DA NF, IRÁ REGISTRAR NO HISTÓRICO ZAC
						/////////////////////////////////////////////////////////////////////////////////
						aPedVenda := {}
						t := 1
						DBSelectArea("SD2")
						SD2->(Dbsetorder(3))
						If SD2->( DbSeek( xFilial("SD2") + cNOTACLI + cSERINF ) )
							While !SD2->(EOF()) .and. SD2->D2_FILIAL == xFilial("SD2") .AND. SD2->D2_DOC == cNOTACLI ;
							  .and. SD2->D2_SERIE == cSERINF
								cPedVenda := SD2->D2_PEDIDO
								If Ascan(aPedVenda , cPedVenda) == 0
									Aadd(aPedVenda , cPedVenda) //só adiciona se forem pedidos diferentes
								Endif
								SD2->(Dbskip())
							Enddo
						Endif
	                    
						If Len(aPedVenda) > 0
							For t := 1 to Len(aPedVenda)
								DbSelectArea("ZAC") 
								RecLock("ZAC", .T.)
								ZAC->ZAC_FILIAL := xFilial("SF2")	
								ZAC->ZAC_PEDIDO := aPedVenda[t] //cPedVenda
								ZAC->ZAC_STATUS := '05'     //ERA 04
								ZAC->ZAC_DESCST := "PRODUTO(S) ENTREGUE(S)"
								ZAC->ZAC_DTSTAT := dUCRealChg  //Date()
								ZAC->ZAC_HRSTAT := Time()
								ZAC->ZAC_USER   := __CUSERID //código do usuário que criou
								ZAC->(MsUnlock())
								
								SC5->(Dbsetorder(1))   
								If SC5->(Dbseek(xFilial("SC5") + aPedVenda[t] ))
									RecLock("SC5", .F. )
									SC5->C5_STATUS := '05'
									SC5->(MsUnlock())
								Endif            
							Next
						Endif
						//FR - 16/10/13
					Endif
					
					If !Empty(cObsSUC)
						SF2->F2_OBS		:= cObsSUC
					Endif
					
					If !Empty(dUCAtraso)
						SF2->F2_DATRASO := dUCAtraso
					Endif
					
					If !Empty(dAgINT)
						SF2->F2_DTAGINT := dAgINT
					Endif
		
					SF2->(MsUnlock())
					//SF2->(Dbskip())
				
				//Enddo
			Endif
			
			//ATUALIZA SE1 - SE FOR ÓRGÃO PÚBLICO, MUDA O VENCTO REAL
			SA1->(Dbsetorder(1))
			If SA1->(DbSeek(xFilial("SA1") + cUCchave ))
				cSegmento := SA1->A1_SATIV1
			Endif
			/*
			Sintaxe
			Condicao(nValTot,cCond,nVIPI,dData,nVSol)
			Parametros
			nValTot - Valor total a ser parcelado
			cCond - Código da condição de pagamento
			nVIPI - Valor do IPI, destacado para condição que obrigue o pagamento do IPI na 1ª parcela
			dData - Data inicial para considerar
          */
		If !Empty(dUCRealChg)
			If Alltrim(cSegmento) = '000009'   //se for órgão público, irá alterar o vencto real do título, qdo da chegada da mercadoria
				aParc := Condicao(nF2Valbrut,cCondPag,nF2Valipi,dUCRealChg)
				If Len(aParc) > 0
					For p := 1 to Len(aParc)
						//cParcela := Alltrim(str(p))
						SE1->(DbsetOrder(1))
						If SE1->(Dbseek(xFilial("SE1") + cSERINF + cNOTACLI ))
							//While !SE1->(EOF()) .and. SE1->E1_FILIAL == xFilial("SE1") .and. SE1->E1_PREFIXO == cSERINF .and. SE1->E1_NUM == cNOTACLI
					    	
					    	RecLock("SE1", .F.)
					    	SE1->E1_VENCREA := aParc[p,1]
					    	SE1->(MsUnlock())
					 	Endif
					Next
					
				Endif //len aparc
			Endif 
		Endif
			//FIM DO ATUALIZA SE1
			
			cLista:= ""
			cCodLig:= ""
			
			cQuery := " SELECT TOP 1 U6_DATA, U6_FILIAL,U6_LISTA, U6_CODLIG, U6_NFISCAL "
			cQuery += " FROM " + RetSqlname("SU6") + " SU6 "    			
			cQuery += " WHERE U6_NFISCAL = '" + Alltrim(cNOTACLI) + "' and U6_SERINF = '"+ Alltrim(cSERINF) + "' "
			cQuery += " AND U6_CODLIG   = '" + Alltrim(cUCcodigo) + "' "
			cQuery += " AND U6_FILIAL   = '" + xFilial("SU6") + "' "
			cQuery += " AND SU6.D_E_L_E_T_ = '' "
			cQuery += " ORDER BY U6_DATA DESC "
			
			If Select("SU6XX") > 0
				DbSelectArea("SU6XX")
				DbCloseArea()	
			EndIf
			
			TCQUERY cQuery NEW ALIAS "SU6XX" 
			TCSetField( "SU6XX" , "U6_DATA", "D")
			
			SU6XX->(DbGoTop())
			While SU6XX->(!EOF())
				cLista := SU6XX->U6_LISTA
				cCodLig:= SU6XX->U6_CODLIG
				SU6XX->(DBSKIP())
			Enddo
			
			DbSelectArea("SU6XX")
			DbCloseArea()			
			
			//////////////////////////////////
			//Atualiza o agendamento - SU6
			/////////////////////////////////
			DbSelectArea("SU6")
			DbSetOrder(1)          // U6_FILIAL + U6_LISTA + U6_CODIGO	
			SU6->(DbSeek(xFilial("SU6") + cLista ))	
			While !Eof() .And. SU6->U6_FILIAL == xFilial("SU6") .And.  SU6->U6_CODLIG == cCodLig;
				.And. SU6->U6_LISTA == cLista 						
			
				RecLock("SU6",.F.)
				SU6->U6_RETENC  := cRetencao
				//SU6->U6_POSFIS	:= cPosFis
				SU6->(MsUnLock())		
				SU6->(DbSkip())
			EndDo		
	
	    ///////////QUERY PRINCIPAL
		cQuery := " SELECT UC_FILIAL, SUD.R_E_C_N_O_ SUDRECNO, UD_FILIAL, UC_CODIGO, UD_CODIGO, UD_ITEM, UC_PENDENT, UC_PREVCHG, UC_DATRASO, UC_REALCHG,UC_DTAGCLI, UC_OBSPRB, "+LF
		cQuery += " UC_ENTIDAD, UC_ENCERRA, UC_RETENC, UC_ENVMAIL, UC_NFISCAL, UC_SERINF, UC_PREVCHG, UC_AGANTES, UC_REATIVA, UC_POSFIS, UC_EVMAIL2, "+LF
		cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_NRENVIO, UD_MAILCC, "+LF
		cQuery += " UD_OPERADO, UC_ENTIDAD, UC_CHAVE, UD_FLAGAT, UD_DATA, UD_DTINCLU, UD_RESOLVI, UD_DTRESOL , UD_HRRESOL , UD_OBSENC, UD_STATUS "+LF
		cQuery += " FROM "
		cQuery += " " +RetSqlName("SUC")+" SUC, " + LF
		cQuery += " " +RetSqlName("SUD")+" SUD " +LF
		
		cQuery += " WHERE UC_CODIGO = '" + cUCcodigo + "' "+LF
		cQuery += " AND UD_CODIGO = UC_CODIGO "+LF
		cQuery += " AND UC_FILIAL = '" + xFilial("SUC") + "' "+LF
		cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
		cQuery += " AND SUC.D_E_L_E_T_ = '' "+LF
		cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
		cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM "+LF
		
		//Memowrite("\C:\TK271A.SQL",cQuery)
		
		If Select("_SUDX") > 0
		
			DbSelectArea("_SUDX")
			DbCloseArea()
			
		EndIf
		
		
		TCQUERY cQuery NEW ALIAS "_SUDX"
		
		TCSetField( "_SUDX", "UC_PREVCHG", "D")
		TCSetField( "_SUDX", "UC_DTAGCLI", "D")
		TCSetField( "_SUDX", "UC_AGANTES", "D")
		TCSetField( "_SUDX", "UD_DATA"   , "D")
		TCSetField( "_SUDX", "UD_DTINCLU", "D")
		TCSetField( "_SUDX", "UD_DTRESOL"   , "D")
		
		_SUDX->(DbGoTop())
		aRecs := {} //array usado para guardar o recno do SUD , depois irei comparar nas tabelas ZUD e Z10 se ainda são válidos
		 
		While !_SUDX->(Eof()) 			//.AND. Alltrim(_SUDX->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5)) # ""	   		
			   	 
		   	  		   	  
		   	  lEnvio 	 := .F.
		   	  lRenvio	 := .F.
		   	  lREAGENDAR := .F.
		   	  cUDCodigo := _SUDX->UD_CODIGO
		   	  cUDitem	  := _SUDX->UD_ITEM
		   	  ////////////POSTO FISCAL
		   	  /*
		   	  If _SUDX->UC_POSFIS = "S" .And. Empty( _SUDX->UC_EVMAIL2 )     //FR: O campo UC_EVMAIL2 é o Flag que indica se já foi enviado o e-mail p/ Logística
		   	  
			  		nTipoMail := 3			//Retenção é tipo = 1 e Reagendamento tipo = 2  Posto Fiscal = 3
			  		cEntidade := _SUDX->UC_ENTIDAD
				    cChave    := _SUDX->UC_CHAVE
				    //cPosFis   := _SUDX->UC_POSFIS

					SF2->(Dbsetorder(1))
					SF2->(Dbseek( xFilial("SF2") + _SUDX->UC_NFISCAL + _SUDX->UC_SERINF))
					dEmiNF := SF2->F2_EMISSAO
					If Empty( SF2->F2_REDESP )
					     cTransp:= SF2->F2_TRANSP
					Else
						cTransp := SF2->F2_REDESP
					Endif
					SA4->(Dbsetorder(1))
					SA4->(Dbseek(xFilial("SA4") + cTransp ))
					cTelef := SA4->A4_TEL
					Aadd(aPosFis, { _SUDX->UC_NFISCAL	,;		//1
				    				_SUDX->UC_SERINF	,;  	//2
				         			dEmiNF			   	,;  	//3				         			   
				         			cEntidade			,;      //4
				         			cChave				,;    	//5
					                _SUDX->UC_FILIAL	,;		//6
					                _SUDX->UC_CODIGO	,;		//7
					                SA4->A4_NREDUZ      ,;		//8
					                cTelef				,;		//9
					                _SUDX->UC_PREVCHG	,;		//10
					                dAGcli				,;		//11    ////////////////////////////////////////////////////////////////////////
					                nTipoMail           })		//12    ////esta posição (12) do array, indica o tipo de opção q será executada
					                									/// 1 => retenção / 2 => reagendamento
					                									////////////////////////////////////////////////////////////////////////
					                
					                
					If Len( aPosFis ) > 0
					     U_TMKRetenc( aPosFis )  
					Endif
		   	  Endif
		   	  */
		   	  ///////////POSTO FISCAL		//solicitado por Daniela em 15/07/11 - desabilitado, pois não será mais utilizado o envio de mail relativo a chegada em posto fiscal
		   	  
		   	  If _SUDX->UC_RETENC = "S" .And. Empty( _SUDX->UC_ENVMAIL )     //FR: O campo UC_ENVMAIL é o Flag que indica se já foi enviado o e-mail Retenção
			  		nTipoMail := 1			//Retenção é tipo = 1 e Reagendamento tipo = 2
			  		cEntidade := _SUDX->UC_ENTIDAD
				    cChave    := _SUDX->UC_CHAVE
				    cRetencao := _SUDX->UC_RETENC

					SF2->(Dbsetorder(1))
					SF2->(Dbseek( xFilial("SF2") + _SUDX->UC_NFISCAL + _SUDX->UC_SERINF))
					dEmiNF := SF2->F2_EMISSAO
					If Empty( SF2->F2_REDESP )
					     cTransp:= SF2->F2_TRANSP
					Else
						cTransp := SF2->F2_REDESP
					Endif
					SA4->(Dbsetorder(1))
					SA4->(Dbseek(xFilial("SA4") + cTransp ))
					cTelef := SA4->A4_TEL
					Aadd(aRetenc, { _SUDX->UC_NFISCAL	,;		//1
				    				_SUDX->UC_SERINF	,;  	//2
				         			dEmiNF			   	,;  	//3				         			   
				         			cEntidade			,;      //4
				         			cChave				,;    	//5
					                _SUDX->UC_FILIAL	,;		//6
					                _SUDX->UC_CODIGO	,;		//7
					                SA4->A4_NREDUZ      ,;		//8
					                cTelef				,;		//9
					                _SUDX->UC_PREVCHG	,;		//10
					                dAGcli				,;		//11    ////////////////////////////////////////////////////////////////////////
					                nTipoMail           })		//12    ////esta posição (12) do array, indica o tipo de opção q será executada
					                									/// 1 => retenção / 2 => reagendamento
					                									////////////////////////////////////////////////////////////////////////
					                
					if Empty( _SUDX->UC_REALCHG )		                
						If Len( aRetenc ) > 0
						     U_TMKRetenc( aRetenc )  
						Endif
					endif
			  
			  Elseif Empty( _SUDX->UC_REALCHG )		///se não tem dt. chegada, verifica se existe reagendamento
			    If !Empty( _SUDX->UC_DTAGCLI )  .And. _SUDX->UC_DTAGCLI != _SUDX->UC_AGANTES 
			  		nTipoMail := 2
			  		cEntidade := _SUDX->UC_ENTIDAD
				    cChave    := _SUDX->UC_CHAVE
				    cRetencao := _SUDX->UC_RETENC
				    dAGcli	  := _SUDX->UC_DTAGCLI

					SF2->(Dbsetorder(1))
					SF2->(Dbseek( xFilial("SF2") + _SUDX->UC_NFISCAL + _SUDX->UC_SERINF))
					dEmiNF := SF2->F2_EMISSAO
					If Empty( SF2->F2_REDESP )
						cTransp:= SF2->F2_TRANSP
					Else
					 	cTransp := SF2->F2_REDESP
					Endif
					SA4->(Dbsetorder(1))
					SA4->(Dbseek(xFilial("SA4") + cTransp ))
					cTelef := SA4->A4_TEL
					Aadd(aRetenc, { _SUDX->UC_NFISCAL	,;		//1
				    				_SUDX->UC_SERINF	,;  	//2
				         			dEmiNF			   	,;  	//3				         			   
				         			cEntidade			,;      //4
				         			cChave				,;    	//5
					                _SUDX->UC_FILIAL	,;		//6
					                _SUDX->UC_CODIGO	,;		//7
					                SA4->A4_NREDUZ      ,;		//8
					                cTelef				,;		//9
					                _SUDX->UC_PREVCHG	,;		//10
					                dAGcli				,;		//11
					                nTipoMail           })		//12
					If Len( aRetenc ) > 0
						U_TMKRetenc( aRetenc )
					Endif
				
				Endif				  
			  Endif
			  /////////////////////////////////////////////////////////
			  //////CONFERÊNCIA SE EXISTEM ITENS NO ATENDIMENTO.... 
			  ////////////////////////////////////////////////////////
		   	  If Empty(Alltrim( _SUDX->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5 + UD_OPERADO ) )  )		//NÃO TEM ITENS DE PROBLEMAS (SUD)			    
					
					If Inclui
			
						
						If _SUDX->UC_ENCERRA = 'S' 
				   			lEncerT := .T.	   			
						Elseif _SUDX->UC_ENTIDAD = "SA4"
							lEncerT := .T.
						ElseIf  _SUDX->UC_ENTIDAD = "SA1" .And. _SUDX->UC_OBSPRB = "S"
							lEncerP := .T.					
						ElseIf _SUDX->UC_ENTIDAD = "SA1" .And. _SUDX->UC_OBSPRB != "S"
							lSemItem := .T.          //irá agir na mudança do nome do atendimento						
						Endif
						
						If !Empty( dUCRealChg ) 
								lEncerOK := .T.								
						Endif					
					
					Else
					
						If _SUDX->UC_ENCERRA = 'S'   //se escolhre "Sim" no combo "Encerra?" -> irá dar baixa no atendimento, encerrar
				   			lEncerOK := .T.	 					
						Endif
						
						//ElseIf !Empty( dUCRealChg )	 ///se já tem data de chegada, pode encerrar (qdo não tem itens)			    									
						If !Empty( dUCRealChg )	 ///se já tem data de chegada, pode encerrar (qdo não tem itens)			    									
								lEncerOK := .T.													
						Else
							//msgbox("ALTERA ATENDTO SEM ITENS")
							lReag3ALT := .T.		//Alteração onde não existem itens no SUD
						
						Endif
					Endif
			  
			  ////////////////////////////////////////////////////////
			  //AQUI CONSTA QUE Existem itens no atendimento (SUD)... 	
			  ///////////////////////////////////////////////////////  
		   	  Else 
		   	  
		   	  		//Se é alteração, na manipulação do atendimento, irá reagendar
					If !Inclui						
						lREAGENDAR := .T.
					Endif
				
			    	If EMPTY(_SUDX->UD_NRENVIO)
			    		lEnvio := .T.
			    	Elseif (_SUDX->UD_RESOLVI = 'N' .AND. _SUDX->UD_NRENVIO >= 1)
			    		lRenvio := .T.
			    	Endif
			    	
			  
			  Endif
			  
			  /////////////////////////////////////////////////////////////////////////////////////////
			  ////////INÍCIO ENVIO/REENVIO DO HTML POR EMAIL SOLICITANDO AO RESPONSÁVEL DT. PARA AÇÃO 
			  ////////////////////////////////////////////////////////////////////////////////////////
			  	If lEnvio
				    
					cUDCodigo := _SUDX->UD_CODIGO
					cUDitem	  := _SUDX->UD_ITEM
				    cExecut   := _SUDX->UD_OPERADO
				    SF2->(Dbsetorder(1))
				    SF2->(Dbseek( xFilial("SF2") + _SUDX->UC_NFISCAL + _SUDX->UC_SERINF))					
					cTransp:= SF2->F2_TRANSP
					cRedesp := SF2->F2_REDESP
						
			      	If cExecut != cExecutAnt       ////se o responsável for o mesmo, não fará a passagem abaixo, evita que envie duas vezes
				  
				      aRespo    := {} 
				      nItemUD := 0						 							
				      cEntidade := _SUDX->UC_ENTIDAD
				      cChave    := _SUDX->UC_CHAVE
					      
						cQuery := " SELECT UD_FILIAL,UD_CODIGO, UD_OPERADO, UD_ITEM, UD_DATA, UD_RESOLVI " + LF
						cQuery += ", UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_OBS, UD_MAILCC, SUD.R_E_C_N_O_ NREC_UD "+LF
						cQuery += " FROM "+RetSqlName("SUD")+" SUD "+LF
						cQuery += " WHERE UD_CODIGO = '" + cUDCodigo + "' "+LF
		   				cQuery += " AND UD_OPERADO = '"  + cExecut   + "' "+LF
		   				//cQuery += " AND UD_DATA = '' "+LF
		   				cQuery += " AND UD_NRENVIO = '' " + LF
		   				cQuery += " AND UD_RESOLVI = '' " + LF
		   				cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
						cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
						cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM "			+LF
						//Memowrite("C:\TK271Envio.SQL",cQuery)
			
						If Select("ENV") > 0		
							DbSelectArea("ENV")
							DbCloseArea()			
						EndIf
			
						TCQUERY cQuery NEW ALIAS "ENV"
						
						TCSetField( "ENV", "UD_DATA"   , "D")
						ENV->(DbGoTop())
							
						While !ENV->(Eof())								
								
							If !Empty(Alltrim( ENV->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO ) )  ) 				         	   
					         
					       			Aadd(aRespo, { ENV->UD_CODIGO,;       //1
					       			    ENV->UD_N1,;            	//2
					       			    ENV->UD_N2,;            	//3
					       			    ENV->UD_N3,;            	//4
					       			    ENV->UD_N4,;            	//5
					       			    ENV->UD_N5,;            	//6
					       			    ENV->UD_OPERADO,;       	//7
					       			    cEntidade,;             	//8
					       			    cChave,;            	    //9
					       			    ENV->UD_ITEM,;      	  	//10
					       			    ENV->UD_FILIAL,;	      	//11
					       			    ENV->UD_OBS,;      			//12
					       			    ENV->UD_DATA,;				//13
					       			    ENV->UD_MAILCC,;			//14
					       			    ENV->NREC_UD  } )          	//15
					       			    
					        			nItemUD++
					       	Endif						        
						  		
					      	ENV->(DBSKIP())
						Enddo
						cExecutAnt := cExecut
						If nItemUD > 0
						   	
						   	U_TMKEnvio(aRespo , cNOTACLI, cSERINF, cTransp, cRedesp )
						   	lItens := .T.	      	  		
						Endif						
			   	    Endif	   					   	  		   	  
				
				Elseif lRenvio		////2a. vez que envia para o responsável -> UD_RESOLVI = 'N'
					
					cUDCodigo := _SUDX->UD_CODIGO
				    cExecut   := _SUDX->UD_OPERADO
				    SF2->(Dbsetorder(1))
				    SF2->(Dbseek( xFilial("SF2") + _SUDX->UC_NFISCAL + _SUDX->UC_SERINF))					
					cTransp:= SF2->F2_TRANSP
					cRedesp := SF2->F2_REDESP
						
			      	If cExecut != cExecutAnt       ////se o responsável for o mesmo, não fará a passagem abaixo, evita que envie duas vezes
				  
				      aReenvio:= {} 
				      nItemUD := 0						 							
				      cEntidade := _SUDX->UC_ENTIDAD
				      cChave    := _SUDX->UC_CHAVE
					      
						cQuery := " SELECT UD_FILIAL,UD_CODIGO, UD_OPERADO, UD_ITEM, UD_DATA, UD_MAILCC, "+LF
						cQuery += " UD_RESOLVI, UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_OBS, UD_JUSTIFI, UD_DTENVIO, UD_NRENVIO, "+LF
						cQuery += " ZUD_CODIGO, ZUD_ITEM, ZUD_PROBLE, ZUD_OBSATE, ZUD_DTENV, ZUD_NRENV, ZUD_DTSOL, ZUD_OBSRES, ZUD_DTRESP, ZUD_OPERAD, "+LF
						cQuery += " SUD.R_E_C_N_O_ NRECNOUD " + LF
						
						cQuery += " FROM "+RetSqlName("SUD")+" SUD, "+LF
						cQuery += " "+RetSqlName("ZUD")+" ZUD "+LF
						cQuery += " WHERE UD_CODIGO = '" + cUDCodigo + "' "+LF
		   				cQuery += " AND UD_OPERADO = '"  + cExecut   + "' "+LF
		   				cQuery += " AND RTRIM(UD_RESOLVI) = 'N' "+LF 
		   				cQuery += " AND UD_NRENVIO >= 1 " + LF
		   				cQuery += " AND RTRIM(UD_CODIGO) = RTRIM(ZUD_CODIGO) "+LF
		   				cQuery += " AND RTRIM(UD_ITEM) = RTRIM(ZUD_ITEM) "+LF
		   				cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
						cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
						cQuery += " AND ZUD_FILIAL = '" + xFilial("ZUD") + "' "+LF
						cQuery += " AND ZUD.D_E_L_E_T_ = '' "+LF
						cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM, ZUD_CODIGO, ZUD_ITEM, ZUD.R_E_C_N_O_, ZUD_DTENV+ZUD_NRENV "+LF
						//Memowrite("\TempQry\TK271REnvio.SQL",cQuery)
			
						If Select("RENV") > 0		
							DbSelectArea("RENV")
							DbCloseArea()			
						EndIf
			
						TCQUERY cQuery NEW ALIAS "RENV"
						TCSetField( "RENV", "UD_DATA"   , "D")
						TCSetField( "RENV", "UD_DTENVIO"   , "D")
						TCSetField( "RENV", "ZUD_DTENV"   , "D")
						TCSetField( "RENV", "ZUD_DTSOL"   , "D")
						RENV->(DbGoTop())
						If !RENV->(EOF())	
							While !RENV->(Eof())								
									
								If !Empty(Alltrim( RENV->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO ) )  ) 				         	   
						                
						        		Aadd(aReenvio, { RENV->UD_CODIGO,;       //1
						       			    RENV->UD_N1,;            	//2
						       			    RENV->UD_N2,;            	//3
						       			    RENV->UD_N3,;            	//4
						       			    RENV->UD_N4,;            	//5
						       			    RENV->UD_N5,;            	//6
						       			    RENV->UD_OPERADO,;       	//7
						       			    cEntidade,;             	//8
						       			    cChave,;            	    //9
						       			    RENV->UD_ITEM,;        	//10
						       			    RENV->UD_FILIAL,;	      	//11
						       			    RENV->UD_OBS,;      		//12
						       			    RENV->ZUD_DTSOL,;			//13
						        			RENV->ZUD_OBSRES,;			//14
						        			RENV->ZUD_DTENV,;	 		//15
						        			RENV->ZUD_NRENV,; 			//16 
						        			RENV->UD_MAILCC,;			//17
						        			RENV->ZUD_OBSATE,;			//18
						        			RENV->NRECNOUD } )			//19
						        		
						        			nItemUD++
						       	Endif						        
							  		
						      	RENV->(DBSKIP())
							Enddo
							cExecutAnt := cExecut
							If nItemUD > 0
							   	
							   	U_TMKREnvio(aReenvio , cNOTACLI, cSERINF, cTransp, cRedesp )
							   	lItens := .T.	      	  		
							Endif						
			   	        Else		
			   	        	/////////////////////////////////////////////////////////
			   	        	////se não existir histórico do atendimento corrente... 
			   	        	/////////////////////////////////////////////////////////
			   	        	cQuery := " SELECT UD_FILIAL,UD_CODIGO, UD_OPERADO, UD_ITEM, UD_DATA, UD_MAILCC, "+LF
							cQuery += " UD_RESOLVI, UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_OBS, UD_JUSTIFI, UD_DTENVIO, UD_NRENVIO, SUD.R_E_C_N_O UDREC "+LF
							cQuery += " FROM "+RetSqlName("SUD")+" SUD "+LF
							cQuery += " WHERE UD_CODIGO = '" + cUDCodigo + "' "+LF
			   				cQuery += " AND UD_OPERADO = '"  + cExecut   + "' "+LF
			   				//cQuery += " AND UD_DATA <> '' "+LF
			   				cQuery += " AND RTRIM(UD_RESOLVI) = 'N' "+LF
			   				cQuery += " AND UD_NRENVIO >= 1 " + LF
			   				cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
							cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
							cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM "+LF
							//Memowrite("\TempQry\TK271REnvio2.SQL",cQuery)
				
							If Select("RENV2") > 0		
								DbSelectArea("RENV2")
								DbCloseArea()			
							EndIf
				
							TCQUERY cQuery NEW ALIAS "RENV2"
							TCSetField( "RENV2", "UD_DATA"   , "D")
							TCSetField( "RENV2", "UD_DTENVIO"   , "D")
							TCSetField( "RENV2", "ZUD_DTENV"   , "D")
							TCSetField( "RENV2", "ZUD_DTSOL"   , "D")
							RENV2->(DbGoTop())
							While !RENV2->(Eof())								
								If !Empty(Alltrim( RENV2->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO ) )  ) 				         	   
							         /*   qdo tem histórico tem 19 posições
							         Aadd(aReenvio, { RENV->UD_CODIGO,;       //1
						       			    RENV->UD_N1,;            	//2
						       			    RENV->UD_N2,;            	//3
						       			    RENV->UD_N3,;            	//4
						       			    RENV->UD_N4,;            	//5
						       			    RENV->UD_N5,;            	//6
						       			    RENV->UD_OPERADO,;       	//7
						       			    cEntidade,;             	//8
						       			    cChave,;            	    //9
						       			    RENV->UD_ITEM,;        	//10
						       			    RENV->UD_FILIAL,;	      	//11
						       			    RENV->UD_OBS,;      		//12
						       			    RENV->ZUD_DTSOL,;			//13
						        			RENV->ZUD_OBSRES,;			//14
						        			RENV->ZUD_DTENV,;	 		//15
						        			RENV->ZUD_NRENV,; 			//16 
						        			RENV->UD_MAILCC,;			//17
						        			RENV->ZUD_OBSATE,;			//18
						        			RENV->NRECNOUD } )			//19
						        	 */
						        	 		 
							    	Aadd(aReenvio, { RENV2->UD_CODIGO,;       //1
							    	    RENV2->UD_N1,;            	//2
							    	    RENV2->UD_N2,;            	//3
							    	    RENV2->UD_N3,;            	//4
							    	    RENV2->UD_N4,;            	//5
							    	    RENV2->UD_N5,;            	//6
							    	    RENV2->UD_OPERADO,;       	//7
							    	    cEntidade,;             	//8
							    	    cChave,;            	    //9
							    	    RENV2->UD_ITEM,;        	//10
							    	    RENV2->UD_FILIAL,;	      	//11
							    	    RENV2->UD_OBS,;      		//12
							    	    RENV2->UD_DATA,;			//13
							    		RENV2->UD_JUSTIFI,;			//14
							    		RENV2->UD_DTENVIO,;	 		//15
							    		RENV2->UD_NRENVIO,;			//16 
							    		RENV2->UD_MAILCC,;          //17
							    		RENV2->UD_OBS,;             //18
							    		RENV2->UDREC } )			//19
							        				
							    	nItemUD++
							    Endif						        
								RENV2->(DBSKIP())
							Enddo
							cExecutAnt := cExecut
							If nItemUD > 0
							   	
							   	U_TMKREnvio(aReenvio , cNOTACLI, cSERINF, cTransp, cRedesp )
							   	lItens := .T.	      	  		
							Endif						
			   	        
			   	        Endif			////ENDIF qdo não tem histórico
			   	        
			   	    Endif				///ENDIF do Execut != Executant
				Endif
			   ////FIM DO ENVIO / REENVIO
			   nNRENV := 0
			   ///SE ALGUM ITEM FOI MARCADO EM SEU CAMPO "RESOLVIDO = S/N" DEVE SER COLOCADO TAMBÉM NO HISTÓRICO
			   
			    //SUD->(Dbsetorder(1))
			    //If SUD->(Dbseek(xFilial("SUD") + cUCcodigo + cUDItem ))
			    //	If Alltrim(SUD->UD_RESOLVI) != '' .OR. Alltrim(SUD->UD_STATUS) = '2'
			    
			    //FR - Flavia Rocha - Revisado em 05/06/12
			    If Alltrim( _SUDX->UD_RESOLVI ) != '' .or. Alltrim( _SUDX->UD_STATUS ) = '2'
			            //SE MARCOU COMO RESOLVIDO S/N ou encerrou a ocorrência (status = '2')
			            //irá gravar no histórico
					   	nNRENV := 0
					    nRegZUD:= 0
					    ///ESTA QUERY É SÓ PARA PEGAR O ÚLTIMO RECNO DO ZUD COM A FINALIDADE DE GRAVAR O ENCERRAMENTO / RESOLVIDO DO SUD	
					   	cQuery := " SELECT TOP 1 ZUD.R_E_C_N_O_ AS REGZUD , *  " + LF
					   	cQuery += " FROM "+RetSqlName("ZUD")+" ZUD "+LF
						//cQuery += " WHERE ZUD_CODIGO = '" + Alltrim(cUCcodigo) + "' "+LF
						//cQuery += " AND ZUD_ITEM = '" + Alltrim(cUDitem) + "' " + LF
						cQuery += " WHERE ZUD_CODIGO = '" + Alltrim( _SUDX->UD_CODIGO) + "' "+LF
						cQuery += " AND ZUD_ITEM = '" + Alltrim( _SUDX->UD_ITEM) + "' " + LF
				   		cQuery += " AND ZUD_FILIAL = '" + xFilial("ZUD") + "' "+LF
						cQuery += " AND ZUD.D_E_L_E_T_ = '' "+LF
						cQuery += " ORDER BY ZUD.R_E_C_N_O_ DESC "			+LF
									
						If Select("ZUDX") > 0		
							DbSelectArea("ZUDX")
							DbCloseArea()			
						EndIf
						TCQUERY cQuery NEW ALIAS "ZUDX"					
								
						ZUDX->(DbGoTop())
						If !ZUDX->(EOF())
							While !ZUDX->(Eof())
								nRegZUD := ZUDX->REGZUD      //pega o recno do ZUD
								ZUDX->(Dbskip())
							Enddo
							DbSelectArea("ZUDX")
							DbCloseArea()			
							////grava no item do histórico, dentro da última resposta efetuada se foi resolvido
							///serve também qdo o usuário responde mais respostas do que o número de envios gerados 
							///(envio 0 qdo o usuário responde sem um envio / reenvio específico				
							DbselectArea("ZUD")						
							ZUD->(DBGOTOP())
							ZUD->(Dbgoto(nRegZUD))  //vai direto no registro						
							If Alltrim(ZUD->ZUD_CODIGO) = Alltrim( _SUDX->UD_CODIGO ) .And. Alltrim(ZUD->ZUD_ITEM) = Alltrim( _SUDX->UD_ITEM )						 
								RecLock("ZUD", .F.)
								ZUD->ZUD_RESOLV := _SUDX->UD_RESOLVI
								If Alltrim(_SUDX->UD_RESOLVI) = 'S'
									ZUD->ZUD_DTRESO := _SUDX->UD_DTRESOL
									ZUD->ZUD_HRRESO := _SUDX->UD_HRRESOL
								Endif
								ZUD->ZUD_OBSENC := _SUDX->UD_OBSENC          //grava a OBS de encerramento
								
								ZUD->(MsUnlock())									
							Endif						
						Endif	  //ENDIF DO !ZUDX->(EOF())		   	   
			       		///Solicitado por Daniela em 13/06/13 - ao encerrar a ocorrência, um aviso seguir ao responsável
			       		///FR - 26/06/13
			       		If Alltrim( _SUDX->UD_STATUS ) = '2' //SE ENCERROU
			       			//U_fENV_Encer(_SUDX->UD_CODIGO, _SUDX->UD_ITEM) //envia email ao responsável informando do Encerramento/Resolução
			       			//Dani solicitou não mais enviar este email - 19/07/13			       			
			       		Endif      //SE UD_STATUS = '2'
			       		
			       		///FR - 15/10/13     
			       		If Inclui  //SUC / SUD
			       			//FR - 15/10/13 - CHAMADO: 114 - IMPLEMENTAR ROTINA DE DEVOLUÇÃO DE NF
			       			//QDO O SAC INCLUIR OCORRÊNCIA DE DEVOLUÇÃO PARA LOGÍSTICA
			       			//IRÁ GRAVAR NUM HISTÓRICO O INÍCIO DO PROCESSO DE DEVOLUÇÃO QUE COMEÇA COM O ENCERRAMENTO DA OCORRÊNCIA
			       			//TABELA Z10.
			       			//cQuery += " SUD.UD_N1 = '0001' " + LF  //RECLAMAÇÃO
							//cQuery += " and SUD.UD_N2 = '0002' " + LF   //LOGÍSTICA
							//cQuery += " and SUD.UD_N3 IN ('0005' ) " + LF     //DEVOLUÇÃO                   
							
							//////////////////////////////////////////////////////////////////////////////////////////////////////////
							//AQUI STARTA O PROCESSO DE DEVOLUÇÃO, QDO A OCORRÊNCIA PARA LOGÍSTICA É INCLUÍDA
							//GRAVA NA TABELA Z10, PARA MARCAR NA MESMA A DATA DE INICIO DO PROCESSO,
							//HORA, E UMA FORMA DE COBRAR OS ENVOLVIDOS, ATRAVÉS DA VERIFICAÇÃO DESTES CAMPOS.                        
							//////////////////////////////////////////////////////////////////////////////////////////////////////////
							If _SUDX->UD_N1 = '0001'
								If _SUDX->UD_N2 = '0002'
									If _SUDX->UD_N3 = '0005'
										//LOCALIZA A NF NO SF2 PARA OBTER O CÓDIGO DO CLIENTE/LOJA
										DbselectArea("SF2")
										SF2->(Dbsetorder(1))
										SF2->(Dbseek(xFilial("SF2") + cNOTACLI + cSERINF )) 
										
										//FR - 06/11/13 - Comentei porque nem sempre na inclusao da ocorrência, a NF já 
										//foi devolvida no SF1/SD1
										//DTDIGIT := CTOD("  /  /    ")
										//DbSelectArea("SD1")
										//SD1->(Dbsetorder(10))
										//COM CÓDIGO DO CLIENTE E LOJA, PROCURO NO SD1, PARA OBTER A DATA DE ENTRADA DESTA NF DEVOLUÇÃO
										
										//If SD1->(Dbseek(xFilial("SD1") + SF2->F2_CLIENTE + SF2->F2_LOJA  )) 
										//	While SD1->(!EOF()) .and. SD1->D1_FORNECE == SF2->F2_CLIENTE .and. SD1->D1_LOJA == SF2->F2_LOJA
										//		If Alltrim(SD1->D1_TIPO) = "D" //DEVOLUÇÃO
										//			If Alltrim(SD1->D1_NFORI) = SF2->F2_DOC .and. Alltrim(SD1->D1_SERIORI) = SF2->F2_SERIE
										//				DTDIGIT := SD1->D1_DTDIGIT	
										//			Endif
										//		Endif
										//		SD1->(Dbskip())
										//	Enddo
											
											DbselectArea("Z10")
											Z10->(DBSETORDER(1))
											If !Z10->(Dbseek(xFilial("Z10") + cNOTACLI + cSERINF ))  //se não encontrar, cria registro												
												RecLock("Z10", .T.)
												Z10->Z10_FILIAL := xFilial("Z10")
												Z10->Z10_CODIGO := _SUDX->UD_CODIGO
												Z10->Z10_ITEM   := _SUDX->UD_ITEM
												Z10->Z10_NF     := cNOTACLI
												Z10->Z10_SERINF := cSERINF
												Z10->Z10_EMINF  := SF2->F2_EMISSAO
												//Z10->Z10_DTDEVO := DTDIGIT  //D1_DTDIGIT -> DATA EM QUE A NF FOI DEVOLVIDA
												//Z10->Z10_DTINI  := DATE()
												//Z10->Z10_HRINI  := TIME()
												Z10->Z10_STATUS := '01'       //OCORRENCIA INCLUÍDA -> status na X5 -> ZG
												Z10->Z10_DTSTAT := DATE()
												Z10->Z10_HRSTAT := TIME()
												Z10->Z10_RECSUD := _SUDX->SUDRECNO
												Z10->Z10_USER   := __CUSERID
												Z10->Z10_NOMUSR:= SUBSTR(cUSUARIO,7,15)
												Z10->(MsUnlock())
											Endif
										
										//Endif //SEEK NO D1
										
									Endif //SE UD_N3 = 0005
								Endif //SE UD_N2 = 0002
							Endif   //SE UD_N1 = 0001
			       		Else //altera                           
			       			////////////////////////////////////////////////////////////////////////////
			       			//FR - 21/10/13 - ATUALIZA ZUD e Z10
			       			//fiz esta passagem com a finalidade se o SUD for alterado (ou excluído)
			       			//pego o recno do SUD e atualizo no ZUD (HISTÓRICO OCORRÊNCIAS) 
			       			//e na Z10 (histórico de ocorrências devoluções)
			       			////////////////////////////////////////////////////////////////////////////
			       			//só posso fazer esta função depois do dia 23/10/13 , pois antes disso,
			       			//os recnos ainda não estavam sendo gravados na ZUD e Z10
			       			lFaz := iif( _SUDX->UD_DTINCLU > Ctod("23/10/2013") , .T. , .F.)
			       			If lFaz
			       				AtualizaZ( _SUDX->UD_CODIGO, _SUDX->UD_ITEM )
			       			Endif
			       			
			       		Endif //IF INCLUI
			       
			    Endif    //endif do Alltrim( _SUDX->UD_RESOLVI ) != '' .or. Alltrim( _SUDX->UD_STATUS ) = '2'
			    //////////fim da gravação do histórico ZUD
			   
			  //retoma a área aberta da query principal  
			  DbselectArea("_SUDX")
			  _SUDX->(Dbskip())      
		Enddo
		
		
		
	    ////////////////////////////////////
		////FAZ SOMENTE EM CASO DE INCLUSÃO
		////////////////////////////////////
		If Inclui
			If lItens		// Se é inclusão e tem itens, é porque houve o registro de um problema.
							// Se for problema, o retorno tem que ser para o dia seguinte (INCLUSÃO)      
				
				U_ReagINCLU(  cUCEntida, cUCFilial , cUCcodigo , cNOTACLI, cSERINF )	      	
			    
			ElseiF lEncerP                              //INCLUSÃO
				U_fEncerrIP( cUCFilial, cUCcodigo, cNOTACLI, cSERINF )   	//Encerra quando é uma 'ligação-problema entrega' , através do campo UC_OBSPRB = "S"
			
			ElseIf lEncerT
				U_fEncerIT( cUCFilial, cUCcodigo, cNOTACLI, cSERINF )   	//INCLUSÃO - Se for ligação para transportadora, esta ligação pode ser encerrada.
			
			Elseif lSemItem							//Sem itens - A utilidade de mais uma função de agendamento é somente para mudar o nome da lista de ligações
													//mas mantendo o agendamento previsto.
				U_ReagINC2(  cUCEntida, cUCFilial , cUCcodigo , cNOTACLI, cSERINF )	      	
			
			Endif
		
		///////////////////////////////////////
		////FAZ SOMENTE EM CASO DE ALTERAÇÃO
		//////////////////////////////////////
		ElseIf lREAGENDAR			
		    		   
				cQuery := ""
				cQuery += " SELECT UD_FILIAL,UD_CODIGO, UD_OPERADO, UD_ITEM, UD_DATA, "+LF
				cQuery += " UD_RESOLVI, UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_OBS, UD_JUSTIFI, UD_DTENVIO, UD_NRENVIO "+LF
				cQuery += " FROM "+RetSqlName("SUD")+" SUD "+LF
				
				cQuery += " WHERE UD_CODIGO = '" + cUCcodigo + "' "+LF
				cQuery += " AND RTRIM(UD_FLAGAT) = '' "+LF
				cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
				cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
				cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM "+LF
				//Memowrite("C:\NOVOITEM.SQL",cQuery)
				If Select("NOVOIT") > 0		
					DbSelectArea("NOVOIT")
					DbCloseArea()			
				EndIf
				TCQUERY cQuery NEW ALIAS "NOVOIT"
			
				NOVOIT->(DbGoTop())				
				While !NOVOIT->(Eof())								
					If !Empty(Alltrim( NOVOIT->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO ) )  ) 				         	   
						lNewITEM  := .T.												
					Endif
					NOVOIT->(DBSKIP())
				Enddo
				
				If !lNewITEM
					////
					cQuery := ""
					cQuery := " SELECT UD_FILIAL,UD_CODIGO, UD_OPERADO, UD_ITEM, UD_DATA, "+LF
					cQuery += " UD_RESOLVI, UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_OBS, UD_JUSTIFI, UD_DTENVIO, UD_NRENVIO "+LF
					cQuery += " FROM "+RetSqlName("SUD")+" SUD "+LF
					cQuery += " WHERE UD_CODIGO = '" + cUCcodigo + "' "+LF
					cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
					cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
					cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM "+LF
					//Memowrite("C:\Reagendar2.SQL",cQuery)
					If Select("REAGEN") > 0		
						DbSelectArea("REAGEN")
						DbCloseArea()			
					EndIf
					TCQUERY cQuery NEW ALIAS "REAGEN"
				
					REAGEN->(DbGoTop())				
					While !REAGEN->(Eof())								
						If !Empty(Alltrim( REAGEN->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO ) )  ) 				         	   
							If ( Alltrim(REAGEN->UD_RESOLVI) = ""  .or. Alltrim(REAGEN->UD_RESOLVI) = "N" )		    	
							   	
							   	lReagALT  := .T.						
							Endif	
						Endif
						REAGEN->(DBSKIP())
					Enddo
					
					If !lReagALT
						
						lReag2ALT := .T.
					Endif
				
				Endif    
				///////////////////////////////////////////////////////
				If lReagALT
				  	
				  	U_ReagALT(  cUCFilial, cUCcodigo, cNOTACLI, cSERINF )    	//Quando encontra pelo menos UM item não resolvido
					      
				Elseif lReag2ALT							//Quando TODOS os itens já estão resolvidos
				   	
				   	U_Reag2ALT( cUCFilial, cUCcodigo, cNOTACLI, cSERINF )
				
				Elseif lNewITEM
														//Quando é uma alteração e neste momento é que foram incluídos itens no atendimento.
					U_ALTItens( cUCEntida, cUCFilial , cUCcodigo , cNOTACLI, cSERINF )	 	
				Endif	 
				///////////////////////////////////////////////////////		
				      
		Endif 
		
		
			      
		If lReag3ALT 
			U_Reag3ALT( cUCFilial, cUCcodigo, cNOTACLI, cSERINF )		//Quando é alteração de um atendimento sem itens, vai mudar só o nome do cabeçalho
			
		Elseif lEncerOK
			U_fEncerrA( cUCFilial, cUCcodigo, cNOTACLI, cSERINF )		//Irá encerrar quando não tiver itens e o combo "Encerrar" estiver com "Sim"
		   											//ou já tiver data real de chegada no campo UC_REALCHG
		Endif	     
		
		
		
		RestArea( aArea )
		SUD->(DbCloseArea())
		_SUDX->(DbCloseArea())
	
	Endif
Endif  

Return
///////FIM DO PTO TK271FIMGR - QUERY PRINCIPAL DO ATENDIMENTO //////////////



////////////////////////////////////////
// FUNÇÕES ADICIONAIS AO PTO ENTRADA  //
////////////////////////////////////////
                                    


/////////////////////////////////
////1o. ENVIO PARA O RESPONSÁVEL 
/////////////////////////////////
********************************
User Function TMKEnvio(aRespo , cNOTACLI, cSERINF, cTransp, cRedesp )
********************************

Local cUsu
Local aUsu			:= {}
Local cSup			:= ""
Local aSup			:= {}
Local cMailSup		:= ""
Local cNomeSup		:= ""
Local cNomeOper		:= ""
Local cVendedor		:= ""
Local cSuper		:= ""
Local cMailSuper	:= ""

Local cResp
Local eEmail 		:= "" 
Local eEmailResp	:= ""
Local cNomTransp 	:= "" 
Local cNomRedesp	:=""
Local LF      	:= CHR(13)+CHR(10) 
Local nEnvio	:= 0
Local cSetor	:= ""

Local cMailCopia:= ""
Local cCopiaFIN := "" 
Local lMarcelo  := .F. 
Local aParcelas := {}
Local cBanco    := ""  
Local cPar1     := ""
Local cPar2     := "" 
Local cPar3     := ""
Local cPar4     := ""
Local cPar5     := "" 
Local cPar6     := ""
Local cPar7     := ""
Local cPar8     := ""
Local cPar9     := ""
Local cPar10     := ""

Local cVenc1    := ""
Local cVenc2    := ""
Local cVenc3    := ""
Local cVenc4    := ""
Local cVenc5    := ""
Local cVenc6    := ""
Local cVenc7    := ""
Local cVenc8    := ""
Local cVenc9    := ""
Local cVenc10    := ""
Local cVarP     := ""  //variável da parcela
Local cVarV     := ""  //variável do vencto
Local cVarVal   := ""  //variável do valor da parcela

SetPrvt("OHTML,OPROCESS")


// Inicialize a classe de processo:
oProcess:=TWFProcess():New("CALLCENTER","Call center")

// Crie uma nova tarefa, informando o html template a ser utilizado:
oProcess:NewTask('Inicio',"\workflow\http\oficial\WFSiga.html")
//oProcess:NewTask('Inicio',"\workflow\http\teste\WFSiga.html")
oHtml   := oProcess:oHtml


PswOrder(1)
If PswSeek( aRespo[1][7], .T. )      //UD_OPERADO
        
//////////////////////////////////////////////////////////////////////////////////////////////
//aRespo[1][7]===> UD_OPERADO - Responsável pelo atendimento
//O código do responsável pelo atendimento fica no UD_OPERADO, NÃO É o mesmo do UC_OPERADO
//no SUC, o código que fica no UC_OPERADO, é do operador que incluiu o atendto.
//////////////////////////////////////////////////////////////////////////////////////////////
   
   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
   cUsu   := Alltrim( aUsu[1][2] )      //Nome do usuário (responsável pelo atendimento)
   eEmailResp := Alltrim( aUsu[1][14] )     // Definição de e-mail padrão
   cSup	  := aUsu[1][11]
   ///verifica o superior do usuário para enviar a ocorrência com cópia ao Superior dele
   PswOrder(1)
   If PswSeek(cSup, .t.)
	   aSup := PswRet()
	   cNomeSup := If(!Empty(aSup),aSup[1][4],"") 		//Superior	(nome completo)
	   cMailSup := Alltrim( aSup[1][14])                //endereço e-mail
   Endif
Endif


oHtml:ValByName("cSuperior", Alltrim(cNomeSup) )
oHtml:ValByName("cResp", cUsu )

DbSelectArea(aRespo[1,8])
DbSetOrder(1)
DbSeek(xFilial(aRespo[1,8])+AllTrim(aRespo[1,9]))

oHtml:ValByName("cCli", iif(aRespo[1,8]=="SA1",SA1->A1_NOME,iif(aRespo[1,8]=="SA2",SA2->A2_NOME,"") ) )
oHtml:ValByName("cCodCli", Substr(aRespo[1,9],1,6) + '/' + Substr(aRespo[1,9],7,2) )
//oHtml:ValByName("cNF", cNOTACLI )
//oHtml:ValByName("cSERINF", cSERINF )

If !Empty(cNOTACLI)
	oHtml:ValByName("cNF", cNOTACLI )
	oHtml:ValByName("cSERINF", cSERINF )
//FR - 24/08/12
//modificação relativa ao chamado 00000074 - Neide
//incluir na informação da nota fiscal, o banco, parcelas e vencimento	
	SE1->(DbsetOrder(1))
	If SE1->(Dbseek(xFilial("SE1") + cSERINF + cNOTACLI ))  
		While SE1->(!EOF()) .And. SE1->E1_FILIAL == xFilial("SE1") .And. Alltrim(SE1->E1_PREFIXO) = Alltrim(cSERINF) .And. Alltrim(SE1->E1_NUM) = Alltrim(cNOTACLI)
			cBanco := SE1->E1_PORTADO			
			Aadd( aParcelas , {SE1->E1_PARCELA, SE1->E1_VENCTO, SE1->E1_PORTADO, SE1->E1_AGEDEP, SE1->E1_CONTA, SE1->E1_VALOR } )
			//                      1                  2                3                4              5             6
			SE1->(DBSKIP())
		Enddo
	Endif
	
Else 
	oHtml:ValByName("cNF", "Sem NF" )
	oHtml:ValByName("cSERINF", "" )
Endif

fr := 1
SA6->(Dbsetorder(1))
If Len(aParcelas) > 0
	If SA6->(Dbseek(xFilial("SA6") + aParcelas[1,3] + aParcelas[1,4] + aParcelas[1,5] ))
		//oHtml:ValByName("cBanco", SA6->A6_NOME ) 
		oHtml:ValByName("cBanco", aParcelas[1,3] ) //SÓ O BANCO (001, 341, 004 etc)
	Else 
		oHtml:ValByName("cBanco", "" )
	Endif
Endif

If Len(aParcelas) > 0
	For fr := 1 to 10
		cVarP := '"cParc' + Alltrim(str(fr)) + '"'
		cVarV := '"cVenc' + Alltrim(str(fr)) + '"'	
		cVarVal:= '"cVal' + Alltrim(str(fr)) + '"'	
		If fr <= Len(aParcelas)
			If !Empty(aParcelas[fr,1])
				oHtml:ValByName( &cVarP, aParcelas[fr,1] +  " -" )   //parcela
			Else
				oHtml:ValByName( &cVarP, " ' ' -" )          //parcela em branco
			Endif
				oHtml:ValByName( &cVarV, " " + Dtoc(aParcelas[fr,2]) )  //vencto
				oHtml:ValByName( &cVarVal, " " + "R$" + Transform(aParcelas[fr,6], "@E 9,999,999.99") + " ;  " )  //valor
		
			//ex.  1 - 01/09/2012  R$9.999.999,99 
			//ex. '' - 01/09/2012  R$9.999.999,99 ,
			//Else
			//	oHtml:ValByName( &cVarP, "" )
			//	oHtml:ValByName( &cVarV, "" )		
			//Endif
		Endif
	Next
Endif
//fim das modificações relativas ao chamado 00000074
SA4->(Dbsetorder(1))
SA4->(Dbseek(xFilial("SA4") + cTransp ))
cNomTransp := SA4->A4_NREDUZ

oHtml:ValByName("cTransp", cNomTransp )

SA4->(Dbsetorder(1))
SA4->(Dbseek(xFilial("SA4") + cRedesp ))
cNomRedesp := SA4->A4_NREDUZ
oHtml:ValByName("cRedesp", cNomRedesp ) 

//FR - 13/05/2011 - CHAMADO 002101 - DANIELA - COPIAR O COORDENADOR RESPECTIVO DO VENDEDOR NA NF
//NO ENVIO DAS OCORRÊNCIAS
SF2->(Dbsetorder(1))
If SF2->(Dbseek(xFilial("SF2") + cNOTACLI + cSERINF ))
	cVendedor := SF2->F2_VEND1
Endif

SA3->(Dbsetorder(1))
If SA3->(Dbseek(xFilial("SA3") + cVendedor ))
	cSuper := SA3->A3_SUPER
Endif

SA3->(Dbsetorder(1))
If SA3->(Dbseek(xFilial("SA3") + cSuper ))
	cMailSuper := SA3->A3_EMAIL
Endif
//FR - até aqui

PswOrder(1)
If PswSeek( cUsuario, .T. )      //USUÁRIO LOGADO QUE INCLUIU A OCORRÊNCIA        
   
   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
   cNomeOper := Alltrim(aUsu[1][4])		//Nome Completo
   eEmail := Alltrim( aUsu[1][14] )     // Definição de e-mail padrão   
   
Endif

oHtml:ValByName("cOperador", cNomeOper )

For _nX := 1 to Len(aRespo)
     
   aadd( oHtml:ValByName("it.cAtend"), aRespo[_nX,1] )
   aadd( oHtml:ValByName("it.cItem"),  aRespo[_nX,10] )	
   aadd( oHtml:ValByName("it.cProb") , iif(!Empty(aRespo[_nX,2]),Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,2],"Z46_DESCRI"),"")+;
	                                    iif(!Empty(aRespo[_nX,3]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,3],"Z46_DESCRI"),"")+;
	                                    iif(!Empty(aRespo[_nX,4]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,4],"Z46_DESCRI"),"")+;
	                                    iif(!Empty(aRespo[_nX,5]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,5],"Z46_DESCRI"),"")+;
	                                    iif(!Empty(aRespo[_nX,6]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,6],"Z46_DESCRI"),"") )
   aadd( oHtml:ValByName("it.Respon"), cUsu )
   aadd( oHtml:ValByName("it.cObs"), aRespo[_nX,12] )
   aadd( oHtml:ValByName("it.cMailCopia"), aRespo[_nX,14] + ";" )
   aadd( oHtml:ValByName("it.filial"), aRespo[_nX,11] )
   
   If Alltrim(aRespo[_nX,3]) = '0050'
       cSetor := aRespo[_nX,3]
   Endif 
   
   If !aRespo[_nX,14] $ cMailCopia
   	cMailCopia += aRespo[_nX,14] + ";"
   Endif
   ///verifica se enquadra nos problemas abaixo, e envia cópia do email para Marcelo 
   //em 22/04 Daniela solicitou que ao invés de enviar para Marcelo, seja enviada c/cópia p/ Flavia Leite
   SUD->(DBSETORDER(1))
	If SUD->(Dbseek(xFilial("SUD") + aRespo[_nX,1] + aRespo[_nX,10] ))
		////COMERCIAL
		If Alltrim(SUD->UD_N1) = '0001'      //reclamação
			If Alltrim(SUD->UD_N2) = '0034'              //comercial
				If Alltrim(SUD->UD_N3) = '0035'                     //produto
					If Alltrim(SUD->UD_N4) = '0100'						//FALHA
						lMarcelo := .T.					
					Endif
				Endif
			Endif
		Endif
		///////LICITAÇÃO
		If Alltrim(SUD->UD_N1) = '0001'      //reclamação
			If Alltrim(SUD->UD_N2) = '0075'              //LICITAÇÃO
				If Alltrim(SUD->UD_N3) = '0076'                     //produto
					If Alltrim(SUD->UD_N4) = '0077'						//FALHA
						lMarcelo := .T.				
					Endif
				Endif
			Endif
		Endif
	Endif



   
Next _nX


//SE O SETOR FOR FINANCEIRO (0050), Irá com cópia para Alessandra
If Alltrim(cSetor) = '0050'
	cCopiaFIN	:= GetMv("RV_FINMAIL")
//	cCopiaFIN	+= ";flavia.rocha@ravaembalagens.com.br"
Endif

//oProcess:cTo	:= eEmailResp  + ";" + eEmail  //eEmail -> email do usuário logado
oProcess:cTo      :=  eEmailResp   + ";sac@ravaembalagens.com.br"   //usar este

If !Empty(cMailSuper)
	oProcess:cTo      +=  ";" + cMailSuper     //email do coordenador do vendedor //voltar teste
Endif

If !Empty(cMailSup)
	oProcess:cTo      +=  ";" + cMailSup    //email do superior do responsável  //voltar teste
Endif

If !Empty(cCopiaFIN)
	oProcess:cTo      +=  ";" + cCopiaFIN    //email da Alessandra (qdo ocorrência do FIN, ela recebe cópia)
Endif

If !Empty(cMailCopia)
	oProcess:cTo      +=  ";" + cMailCopia    
Endif

If lMarcelo
	//oProcess:cTo      += ";marcelo@ravaembalagens.com.br" //";marcelo@ravaembalagens.com.br;flavia@ravaembalagens.com.br"     //af
Endif

 
//msgbox(oProcess:cTo)
//oProcess:bReturn  := "U_TMKRetorno()" 	//Não será necessária no novo fluxo
oProcess:cSubject := "SAC - NOVA Ocorrência"
//oProcess:bTimeOut := { {"U_TMKTimeout()", 0, 0, 1 } }   

// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
// de destinatários.
//oProcess:cTo    :=  ""  //teste
//oProcess:cCC    :=  "flavia.rocha@ravaembalagens.com.br" //teste
//oProcess:cBCC   := "flavia.rocha@ravaembalagens.com.br"
oProcess:Start()

WfSendMail()

//Depois que enviar, incrementa o UD_NRENVIO para saber qtas vezes já foi enviada a ocorrência
For _nX := 1 to Len(aRespo)
	//atualiza o SUD - Itens do atendimento
	DbSelectArea("SUD")    
	SUD->(DbsetOrder(1))
	If SUD->(Dbseek(xFilial("SUD") + aRespo[_nX,1] + aRespo[_nX,10] ))				
		While SUD->(!EOF()) .And. SUD->UD_FILIAL == xFilial("SUD") .And. SUD->UD_CODIGO == aRespo[_nX,1];
		.and. SUD->UD_ITEM == aRespo[_nX,10]
		    If Alltrim( SUD->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO) ) != ""
			    If Empty(SUD->UD_NRENVIO)		//SE O CONTADOR DE ENVIOS ESTIVER VAZIO, É PORQUE NUNCA ENVIOU A OCORRÊNCIA AINDA
			    	nEnvio := SUD->UD_NRENVIO
				    Reclock("SUD", .F.)
				    SUD->UD_DTENVIO := dDatabase
				    SUD->UD_HRENVIO := Time()
				    SUD->UD_NRENVIO := (nEnvio + 1)
				    SUD->(MsUnlock())					
				Endif
			Endif					
		SUD->(DBSKIP())
		Enddo		      
	Endif
	
	///////////////////////////////////////////////////////////
	///atualiza ZUD - Histórico de ocorrências do atendimento 
	///////////////////////////////////////////////////////////
	DbSelectArea("ZUD")    
	ZUD->(DbsetOrder(1))
	RecLock("ZUD",.T.)
	ZUD->ZUD_FILIAL := xFilial("ZUD")
	ZUD->ZUD_CODIGO := aRespo[_nX,1]
	ZUD->ZUD_ITEM   := aRespo[_nX,10]
	ZUD->ZUD_PROBLE := iif(!Empty(aRespo[_nX,2]),Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,2],"Z46_DESCRI")),"")+;
	                   iif(!Empty(aRespo[_nX,3]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,3],"Z46_DESCRI")),"")+;
	                   iif(!Empty(aRespo[_nX,4]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,4],"Z46_DESCRI")),"")+;
	                   iif(!Empty(aRespo[_nX,5]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,5],"Z46_DESCRI")),"")+;
	                   iif(!Empty(aRespo[_nX,6]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,6],"Z46_DESCRI")),"") 
   	ZUD->ZUD_OBSATE := aRespo[_nX,12]
	ZUD->ZUD_DTENV := dDatabase
	ZUD->ZUD_HRENV := Time()
	ZUD->ZUD_NRENV := (nEnvio + 1)
	ZUD->ZUD_OPERAD:= aRespo[_nX,7]
	ZUD->ZUD_RECSUD:= aRespo[_nX,15]  //GRAVA O RECNO DO SUD NA ZUD
	ZUD->(MsUnlock())
	
Next


Return
////////////////////////
// FIM DO 1o. ENVIO
///////////////////////

//////////////////////////////////////////////////////////////////////////////////////////
////2o. ENVIO PARA O RESPONSÁVEL -> CASO O OPERADOR DEFINA QUE A AÇÃO NÃO FOI RESOLVIDA
////UD_RESOLVI = 'N' 
//////////////////////////////////////////////////////////////////////////////////////////
********************************
User Function TMKREnvio(aReenvio , cNOTACLI, cSERINF, cTransp, cRedesp )
********************************

Local cBodyhtm := ""


Local cUsu
Local cResp
Local eEmail 		:= ""
Local eEmailResp	:= ""
Local LF      	:= CHR(13)+CHR(10) 
Local fr		:= 1  
Local fl		:= 1
Local aSup		:= {}
Local cSup		:= ""
Local cNomeSup	:= ""
Local cMailSup	:= ""
Local cSetor	:= ""
Local cNomeOper	:= ""

Local cVendedor		:= ""
Local cSuper  		:= ""
Local cMailSuper	:= ""		//email do coordenador do vendedor 
Local cMailCopia	:= ""
Local cCopiaFIN		:= "" 
Local lFlavia       :=.F.

PswOrder(1)                             
If PswSeek( aReenvio[1][7], .T. )       
///////////////////////////////////////////////////////////////////////////////////////////////
//aReenvio[1][7]===> UD_OPERADO - Responsável pelo atendimento
//O código do responsável pelo atendimento fica no UD_OPERADO, NÃO É o mesmo do UC_OPERADO
//no SUC, o código que fica no UC_OPERADO, é do operador que incluiu o atendto.
// Retorna vetor com informações do usuário
//Nome do usuário (responsável pelo atendimento)
// Definição de e-mail padrão	
///////////////////////////////////////////////////////////////////////////////////////////////
	
	aUsu   := PSWRET() 
	cUsu   := Alltrim( aUsu[1][2] )      
	eEmailResp := Alltrim( aUsu[1][14] ) 
	cSup   := aUsu[1][11]
	///verifica o superior do usuário para enviar a ocorrência com cópia ao Superior dele
   	PswOrder(1)
   	If PswSeek(cSup, .t.)
	   aSup := PswRet()
	   cNomeSup := If(!Empty(aSup),aSup[1][4],"") 		//Superior	(nome completo)
	   cMailSup := Alltrim( aSup[1][14])                //endereço e-mail
   Endif
Endif

PswOrder(1)
If PswSeek( cUsuario, .T. )      //USUÁRIO LOGADO QUE INCLUIU A OCORRÊNCIA        
   
   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
   cNomeOper := Alltrim(aUsu[1][4])		//Nome Completo
   eEmail := Alltrim( aUsu[1][14] )    
Endif 

//FR - 13/05/2011 - CHAMADO 002101 - DANIELA - COPIAR O COORDENADOR RESPECTIVO DO VENDEDOR NA NF
//NO ENVIO DAS OCORRÊNCIAS
SF2->(Dbsetorder(1))
If SF2->(Dbseek(xFilial("SF2") + cNOTACLI + cSERINF ))
	cVendedor := SF2->F2_VEND1
Endif

SA3->(Dbsetorder(1))
If SA3->(Dbseek(xFilial("SA3") + cVendedor ))
	cSuper := SA3->A3_SUPER
Endif

SA3->(Dbsetorder(1))
If SA3->(Dbseek(xFilial("SA3") + cSuper ))
	cMailSuper := SA3->A3_EMAIL
Endif
//FR - até aqui

cBodyhtm := U_TMKC023(aReenvio , cNOTACLI, cSERINF, cTransp, cRedesp, cNomeSup, cNomeOper )

cSetor := aReenvio[1][3]
//SE O SETOR FOR FINANCEIRO (0050), Irá com cópia para Alessandra
If Alltrim(cSetor) = '0050'
	//cCopiaFIN := "alessandra@ravaembalagens.com.br"
	cCopiaFIN	:= GetMv("RV_FINMAIL")
//	cCopiaFIN += ";flavia.rocha@ravaembalagens.com.br"
Endif


cMailCopia := aReenvio[1][17] //FR - 14/06/2011 - solicitado por Daniela - chamado 002134 - incluir campo para email cópia da ocorrência

cRemete	:= "rava@siga.ravaembalagens.com.br" 
//cDesti	:= eEmailResp + ";" + eEmail	 
cDesti	:= eEmailResp + ";sac@ravaembalagens.com.br" 
//25/07/11 - Flávia Rocha - solicitado por Daniela retirar email de Marcio                                                   
//13/08/11 - Flavia Rocha - solicitado retirar email de Marcelo - chamado 002177 - substituir pelo Rel. Resumo Ocorrências SAC


If !Empty(cMailSup)
	cDesti += ";" + cMailSup      //superior do responsável
Endif

If !Empty(cMailSuper)
	cDesti += ";" + cMailSuper	   //coordenador respectivo ao vendedor da NF	//voltar teste
Endif

If !Empty(cMailCopia)
	cDesti += ";" + cMailCopia         //email cópia definido na ocorrência (UD_MAILCC)
Endif

If !Empty(cCopiaFIN)
	cDesti += ";" + cCopiaFIN         //email da Ass.Financeiro (qdo a ocorrência é destinada ao Financeiro)
Endif

//FR: 22/04/13 - DANIELA SOLICITOU QUE OS REENVIOS P/ COMERCIAL OU LICITAÇÃO, VÃO C/ CÓPIA P/ FLAVIA LEITE
fl := 1
For fl := 1 to Len(aReenvio)
	If SUD->(Dbseek(xFilial("SUD") + aReenvio[fl,1] + aReenvio[fl,10] )) 
		////COMERCIAL
		If Alltrim(SUD->UD_N1) = '0001'      //reclamação
			If Alltrim(SUD->UD_N2) = '0034'              //comercial
				//If Alltrim(SUD->UD_N3) = '0035'                     //produto
				//	If Alltrim(SUD->UD_N4) = '0100'						//FALHA
						lFlavia := .T.					
				//	Endif
				//Endif
			Endif
		Endif
		///////LICITAÇÃO
		If Alltrim(SUD->UD_N1) = '0001'      //reclamação
			If Alltrim(SUD->UD_N2) = '0075'              //LICITAÇÃO
				//If Alltrim(SUD->UD_N3) = '0076'                     //produto
				//	If Alltrim(SUD->UD_N4) = '0077'						//FALHA
						lFlavia := .T.				
				//	Endif
				//Endif
			Endif
		Endif
	Endif
	
Next
fl := 0
If lFlavia
	cDesti += ";" + "flavia@ravaembalagens.com.br"
Endif                                             
///FR - 25/04/13

cAssunto := "SAC - REENVIO Ocorrência"

//cDesti		:= eEmailResp + ";flavia.rocha@ravaembalagens.com.br"
cCC		:= ""

U_EnvEMail( cRemete, cDesti, cCC, cAssunto, cBodyhtm )  //Envia o email com as informações do html

nEnvio := 0 
cCodAnt:= ""
cItAnt := ""
nrEnvio:= 0
//Depois que enviar, incrementa o UD_NRENVIO para saber qtas vezes já foi enviada a ocorrência
If Len(aReenvio) > 0
	For fl := 1 to Len(aReenvio)
	
		//atualiza o SUD - Itens do atendimento
		DbSelectArea("SUD")    
		SUD->(DbsetOrder(1))
		If Alltrim(aReenvio[fl,1] + aReenvio[fl,10]) != Alltrim(cCodAnt + cItAnt)
			If SUD->(Dbseek(xFilial("SUD") + aReenvio[fl,1] + aReenvio[fl,10] )) 
			    			    				
				While SUD->(!EOF()) .And. SUD->UD_FILIAL == xFilial("SUD") .And. SUD->UD_CODIGO == aReenvio[fl,1];
				.and. SUD->UD_ITEM == aReenvio[fl,10]
				    
				    If Alltrim( SUD->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO) ) != ""
					    If ( SUD->UD_NRENVIO >= 1 .and. SUD->UD_RESOLVI = "N" )
						    nEnvio := SUD->UD_NRENVIO
						    Reclock("SUD", .F.)
						    SUD->UD_DTENVIO := dDatabase
						    SUD->UD_HRENVIO := Time()
						    SUD->UD_NRENVIO := nEnvio + 1					    
						    SUD->(MsUnlock())					
						Endif
					Endif					
				
				SUD->(DBSKIP())
				Enddo		      
			
			Endif
			
			///////////////////////////////////////////////////////////
			///atualiza ZUD - Histórico de ocorrências do atendimento 
			///////////////////////////////////////////////////////////
			cQuery := ""
			cQuery += " SELECT  TOP 1 ZUD_CODIGO, ZUD_ITEM, ZUD_PROBLE, ZUD_OBSATE, ZUD_DTENV, ZUD_NRENV, ZUD_DTSOL, ZUD_OBSRES, ZUD_DTRESP, ZUD_OPERAD "+LF
			cQuery += " FROM " +RetSqlName("ZUD")+" ZUD "+LF
			cQuery += " WHERE ZUD_CODIGO = '" + aReenvio[fl,1] + "' "+LF
			cQuery += " AND ZUD_OPERAD = '"  + aReenvio[fl,7]   + "' "+LF
			cQuery += " AND ZUD_ITEM = '"  + aReenvio[fl,10]   + "' "+LF
			cQuery += " AND ZUD_FILIAL = '" + xFilial("ZUD") + "' "+LF
			cQuery += " AND ZUD.D_E_L_E_T_ = '' "+LF
			cQuery += " ORDER BY ZUD_CODIGO, ZUD_ITEM, ZUD_DTENV+ZUD_NRENV DESC "+LF
			//Memowrite("\TempQry\ZUDREnvio.SQL",cQuery)
			If Select("ZUDX2") > 0		
				DbSelectArea("ZUDX2")
				DbCloseArea()			
			EndIf
			TCQUERY cQuery NEW ALIAS "ZUDX2"
			ZUDX2->(DbGoTop())
			If !ZUDX2->(EOF())
				While !ZUDX2->(Eof())
					nrEnvio := ZUDX2->ZUD_NRENV			
					
					DbSelectArea("ZUDX2")
					ZUDX2->(Dbskip())
				Enddo
				DbSelectArea("ZUD")    
				ZUD->(DbsetOrder(1))
				RecLock("ZUD",.T.)         //NO REENVIO, CRIA MAIS UM REGISTRO (P/ CADA ENVIO CRIA UM)
				ZUD->ZUD_FILIAL := xFilial("ZUD")
				ZUD->ZUD_CODIGO := aReenvio[fl,1]
				ZUD->ZUD_ITEM   := aReenvio[fl,10]
				ZUD->ZUD_PROBLE := iif(!Empty(aReenvio[fl,2]),Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,2],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,3]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,3],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,4]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,4],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,5]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,5],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,6]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,6],"Z46_DESCRI")),"") 
			   	ZUD->ZUD_OBSATE := aReenvio[fl,12]
				ZUD->ZUD_DTENV := dDatabase
				ZUD->ZUD_HRENV := Time()
				ZUD->ZUD_NRENV := nrEnvio + 1
				ZUD->ZUD_OPERAD:= aReenvio[fl,7]
				ZUD->ZUD_RECSUD:= aReenvio[fl,19]
				ZUD->(MsUnlock())
			Else		///se não encontrar o histórico, captura o número máximo de envio pelo SUD
				cQuery := ""
				cQuery += " SELECT  TOP 1 UD_DTENVIO, UD_NRENVIO, UD_CODIGO, UD_ITEM, UD_OPERADO "+LF
				cQuery += " FROM " +RetSqlName("SUD")+" SUD "+LF
				cQuery += " WHERE UD_CODIGO = '" + aReenvio[fl,1] + "' "+LF
				cQuery += " AND UD_OPERADO = '"  + aReenvio[fl,7]   + "' "+LF
				cQuery += " AND UD_ITEM = '"  + aReenvio[fl,10]   + "' "+LF
				cQuery += " AND UD_FILIAL = '" + xFilial("SUD") + "' "+LF
				cQuery += " AND SUD.D_E_L_E_T_ = '' "+LF
				cQuery += " ORDER BY UD_CODIGO, UD_ITEM, UD_DTENVIO+UD_NRENVIO DESC "+LF
				//Memowrite("\TempQry\SUDREnvio.SQL",cQuery)
				If Select("SUDX2") > 0		
					DbSelectArea("SUDX2")
					DbCloseArea()			
				EndIf
				TCQUERY cQuery NEW ALIAS "SUDX2"
				SUDX2->(DbGoTop())
				While !SUDX2->(Eof())
					nrEnvio := SUDX2->UD_NRENVIO				
					DbSelectArea("SUDX2")
					SUDX2->(Dbskip())
				Enddo
				DbSelectArea("ZUD")    
				ZUD->(DbsetOrder(1))
				RecLock("ZUD",.T.)
				ZUD->ZUD_FILIAL := xFilial("ZUD")
				ZUD->ZUD_CODIGO := aReenvio[fl,1]
				ZUD->ZUD_ITEM   := aReenvio[fl,10]
				ZUD->ZUD_PROBLE := iif(!Empty(aReenvio[fl,2]),Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,2],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,3]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,3],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,4]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,4],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,5]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,5],"Z46_DESCRI")),"")+;
				                   iif(!Empty(aReenvio[fl,6]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[fl,6],"Z46_DESCRI")),"") 
			   	ZUD->ZUD_OBSATE := aReenvio[fl,12]
				ZUD->ZUD_DTENV := dDatabase
				ZUD->ZUD_HRENV := Time()
				ZUD->ZUD_NRENV := nrEnvio + 1
				ZUD->ZUD_OPERAD:= aReenvio[fl,7]
				ZUD->ZUD_RECSUD:= aReenvio[fl,19]
				ZUD->(MsUnlock())
			
			Endif	
				
				cCodAnt := aReenvio[fl,1]
				cItAnt  := aReenvio[fl,10]	
	    Endif
	Next
Endif

Return
////////////////////
//FIM do REENVIO
////////////////////


///////////////////////////////////////////////////////////
//////Primeiro TIMEOUT - OCORRÊNCIA SEM RESPOSTA NO PRAZO
//////////////////////////////////////////////////////////
**********************************
User Function TMKTimeOut( )
********************************** 
//desabilitado por solicitação do chamado 002177 - Marcelo - 13/08/11
///substituído pelo Resumo das ocorrências do SAC
//Por Flavia Rocha

Local aAtend 		:= {} 
Local aUser			:= {}     
Local _nX    		:= 0
Local dDataIni		:= CtoD("  /  /    ")
Local cHoraIni		:= "" 
Local dDtInclu		:= CtoD("  /  /    ")
Local nHoraspassou 	:= 0
Local dDataFim		:= CtoD("  /  /    ")		
Local cHoraFim		:= ""
Local cQuery 		:= ""
Local lEnvia		:= .F.
Local cAtendi		:= ""
Local cFil			:= ""
Local nDifData		:= 0
Local cUserNome		:= ""
Local eEmail		:= ""
Local cAtendiAnt	:= ""
Local cOperador     := ""
Local cCodUser      := ""
Local cNFiscal		:= ""
Local cLista		:= ""
Local cCodLig		:= ""
Local LF      	:= CHR(13)+CHR(10) 


SetPrvt("OHTML,OPROCESS")


// Habilitar somente para Schedule
//prepare environment Empresa _Empresa  Filial _Filial  

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"


conout(Replicate("*",60))
conout("Timeout CallCenter - INICIO")
conout(Replicate("*",60))

oProcess:=TWFProcess():New("CALLCENTER","Timeout - Call center")
oProcess:NewTask('Timeout',"\workflow\http\oficial\WFTimeout.html")
oHtml := oProcess:oHtml
////////////////////////////////////////////////////////////////////////////////////
//Verifica se dentre os atendimentos, existem não-respondidos (UD_DATA = "branco")
//E FAZ O TIMEOUT
///////////////////////////////////////////////////////////////////////////////////

cQuery := " SELECT UC_FILIAL, UC_CODIGO, UC_DATA, UC_PENDENT, UC_HRPEND,  UC_INICIO, UC_NFISCAL, "+LF
cQuery += " UC_CHAVE, UC_ENTIDAD,  UD_FILIAL,UD_CODIGO, UD_ITEM, UD_FLAGAT, UD_DATA, UD_RESOLVI,   "+LF
cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5,  UC_OPERADO, UD_OPERADO  "+LF
cQuery += " FROM SUC020 SUC, "+LF
cQuery += " SUD020 SUD  "+LF
cQuery += " WHERE UC_CODIGO = UD_CODIGO  "+LF
cQuery += " and ( GETDATE()  - UC_PENDENT) >= 1 " + LF
cQuery += " AND ( UD_DATA = '' )"
cQuery += " AND (UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO) <> ''   "+LF
cQuery += " AND UD_STATUS <> '2' "+LF
cQuery += " AND SUD.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SUC.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF
cQuery += " AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' "+LF
cQuery += " Group by UC_FILIAL, UC_CODIGO, UC_DATA, UC_PENDENT, UC_HRPEND,  UC_INICIO, UC_NFISCAL, "+LF
cQuery += " UC_CHAVE, UC_ENTIDAD,  UD_FILIAL,UD_CODIGO, UD_ITEM, UD_FLAGAT, UD_DATA, UD_RESOLVI, "+LF
cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5,  UC_OPERADO, UD_OPERADO   "+LF
cQuery += " ORDER BY UD_CODIGO,UD_ITEM " +LF
//Memowrite("\Temp\TK271TOUT.SQL",cQuery) 

If Select("TIMOUT") > 0
	DbSelectArea("TIMOUT")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TIMOUT" 
TCSetField( "TIMOUT" , "UC_PENDENT", "D")
TCSetField( "TIMOUT" , "UD_DATA", "D")

TIMOUT->(DbGoTop())
While TIMOUT->(!EOF())
	
	//If Alltrim( TIMOUT->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5) ) # ""
			
		dDataIni  := TIMOUT->UC_PENDENT 	//Data agendada para retorno do atendimento
		cHoraIni  := TIMOUT->UC_HRPEND				//Hora agendada para retorno do atendimento
		If Len(cHoraIni) <= 5
			cHoraIni := cHoraIni + ":00"
		Endif
		
		dDataFim  := dDatabase 							//Data atual para efeito de cálculo do timeout
		cHoraFim  := Time()							//Hora atual para efeito de cálculo do timeout (se passou 24 horas)
		//Calcula quantas horas já passaram desde a inclusão do atendimento
		nHoraspassou := U_fDifData( dDataIni,dDataFim,cHoraIni,cHorafim )    
		
		If nHoraspassou >= 24
		
			cAtendi   := TIMOUT->UC_CODIGO
			cFil	  := TIMOUT->UC_FILIAL
			lEnvia    := .F.
			aAtend    := {}
			cCodUser  := TIMOUT->UD_OPERADO
			
			//Verifica se for o item faz parte do mesmo atendimento vai para o próximo, 
			//porque mais abaixo, já adiciona os itens pelo "for/next"
			If cAtendi == cAtendiAnt
				TIMOUT->(Dbskip())
				Loop
			Endif
			
			cNFiscal := TIMOUT->UC_NFISCAL
			
		
			cQuery := " SELECT UD_FILIAL,UD_CODIGO, UD_ITEM, UD_FLAGAT, UD_DATA, "
			cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, "
			cQuery += " UD_OPERADO "
			cQuery += " FROM SUD020 SUD "    			
			cQuery += " WHERE UD_CODIGO = '" + cAtendi + "' "
			cQuery += " AND UD_FILIAL   = '" + xFilial("SUD") + "' "
			cQuery += " AND UD_DATA = '' "
			cQuery += " AND UD_STATUS <> '2' "
			cQuery += " AND (UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO) <> '' "
			cQuery += " AND SUD.D_E_L_E_T_ = '' "
			cQuery += " ORDER BY UD_CODIGO,UD_ITEM "
			//Memowrite("\Temp\SUD-TOUT.SQL",cQuery)
			
			If Select("SUDXX") > 0
				DbSelectArea("SUDXX")
				DbCloseArea()	
			EndIf
			
			TCQUERY cQuery NEW ALIAS "SUDXX" 
			TCSetField( "SUDXX" , "UC_PENDENT", "D")
			
			SUDXX->(DbGoTop())
			While SUDXX->(!EOF())
			
				dDtInclu := Ctod("  /  /    ")
				dDtInclu := dDataIni
							
				PswOrder(1)
				If PswSeek( cCodUser, .T. )
					aUser     := PSWRET() 					 // Retorna vetor com informações do usuário
					cUserNome := Alltrim(aUser[1][2])        // Nome do usuário
					//eEmail := Alltrim(aUser[1][14])  	     // e-mail 
				Endif
						
						
				aadd( aAtend, { SUDXX->UD_CODIGO,;
				       			SUDXX->UD_ITEM,;                      
				   			    iif(!Empty(SUDXX->UD_N1),"->"+Posicione("Z46",1,xFilial("Z46") + SUDXX->UD_N1,"Z46_DESCRI"),"")+;
				                iif(!Empty(SUDXX->UD_N2),"->"+Posicione("Z46",1,xFilial("Z46") + SUDXX->UD_N2,"Z46_DESCRI"),"")+;
				                iif(!Empty(SUDXX->UD_N3),"->"+Posicione("Z46",1,xFilial("Z46") + SUDXX->UD_N3,"Z46_DESCRI"),"")+;
				                iif(!Empty(SUDXX->UD_N4),"->"+Posicione("Z46",1,xFilial("Z46") + SUDXX->UD_N4,"Z46_DESCRI"),"")+;
				                iif(!Empty(SUDXX->UD_N5),"->"+Posicione("Z46",1,xFilial("Z46") + SUDXX->UD_N5,"Z46_DESCRI"),""),;
								cUserNome,;
								DtoC(dDtInclu),;
								cHoraIni          } )                   
						
											
				//Processo do workflow
				oProcess:=TWFProcess():New("CALLCENTER","Timeout - Call center")
				oProcess:NewTask('Timeout',"\workflow\http\oficial\WFTimeout.html")
				oHtml := oProcess:oHtml			
				oProcess:cTo	:= ""  //"marcelo@ravaembalagens.com.br" //;marcio@ravaembalagens.com.br"  //E-mail da diretoria
				//25/07/11 - Flávia Rocha - solicitado por Daniela retirar email de Marcio
				////Em 09/08/10 - Foi solicitado incluir junto ao email do Marcelo o e-mail do Marcio.
				//oProcess:cBCC	:= "flavia.rocha@ravaembalagens.com.br"
				
				
				oProcess:cSubject:= "Prazo para retorno SAC expirado"
									
				For _nX := 1 to len(aAtend)
					      aadd( oHtml:ValByName("it.cAtend") , aAtend[_nX,1] )     //código do atendimento
					      aadd( oHtml:ValByName("it.cItem")  , aAtend[_nX,2] )     //item do atendimento
					      aadd( oHtml:ValByName("it.cProb")  , aAtend[_nX,3] )     //descrição do problema					      
					      aadd( oHtml:ValByName("it.Respon") , aAtend[_nX,4] )	   //nome do responsável  
					      aadd( oHtml:ValByName("it.dtinclu"), aAtend[_nX,5] )	   //data da inclusão do atendimento
					      aadd( oHtml:ValByName("it.hrinclu"), aAtend[_nX,6] )	   //hora da inclusão do atendimento
				Next _nX
						
				lEnvia := .T.				
					
				DbselectArea("SUDXX")
				SUDXX->(Dbskip())			
			
			Enddo
			DbselectArea("SUDXX")
   			SUDXX->(DBCLOSEAREA())
			
			If lEnvia
				oProcess:Start()
				WfSendMail()
			Endif
			
			//////////////////////////////////
			//Atualiza o agendamento - SUC
			/////////////////////////////////
			DbselectArea("SUC")
			Dbsetorder(1)
			SUC->(Dbseek( cFil + cAtendi ) )
			While SUC->(!EOF()) .And. SUC->UC_FILIAL == cFil .And. SUC->UC_CODIGO == cAtendi
				Reclock("SUC",.F.)
				SUC->UC_PENDENT := DataValida( dDatabase + 1 )
				SUC->( MsUnlock() )		
				SUC->(Dbskip())
			Enddo
			
			
			cQuery := " SELECT TOP 1 U6_DATA, U6_FILIAL,U6_LISTA, U6_CODLIG, U6_NFISCAL "
			cQuery += " FROM SU6020 SU6 "    			
			cQuery += " WHERE U6_NFISCAL = '" + cNFiscal + "' "
			cQuery += " AND U6_CODLIG   = '" + cAtendi + "' "
			cQuery += " AND U6_FILIAL   = '" + xFilial("SU6") + "' "
			cQuery += " AND SU6.D_E_L_E_T_ = '' "
			cQuery += " ORDER BY U6_DATA DESC "
			//Memowrite("\Temp\SU6-TOUT.SQL",cQuery)
			
			If Select("SU6XX") > 0
				DbSelectArea("SU6XX")
				DbCloseArea()	
			EndIf
			
			TCQUERY cQuery NEW ALIAS "SU6XX" 
			TCSetField( "SU6XX" , "U6_DATA", "D")
			
			SU6XX->(DbGoTop())
			While SU6XX->(!EOF())
				cLista := SU6XX->U6_LISTA
				cCodLig:= SU6XX->U6_CODLIG
				SU6XX->(DBSKIP())
			Enddo
			
			DbSelectArea("SU6XX")
			DbCloseArea()

			
			//////////////////////////////////
			//Atualiza o agendamento - SU4
			/////////////////////////////////
			DbSetOrder(1)          // U4_FILIAL + U4_LISTA		
			SU4->(DbSeek(xFilial("SU4") + cLista ))
			While !Eof() .And. SU4->U4_FILIAL == xFilial("SU4") .And. SU4->U4_CODLIG == cCodLig;
				.And. SU4->U4_LISTA == cLista
			
				RecLock("SU4",.F.)
				SU4->U4_DATA	:=  DataValida( dDatabase + 1 )
				SU4->(MsUnLock())				
				SU4->(DbSkip())
			EndDo				
			
			//////////////////////////////////
			//Atualiza o agendamento - SU6
			/////////////////////////////////
			DbSelectArea("SU6")
			DbSetOrder(1)          // U6_FILIAL + U6_LISTA + U6_CODIGO	
			SU6->(DbSeek(xFilial("SU6") + cLista ))	
			While !Eof() .And. SU6->U6_FILIAL == xFilial("SU6") .And.  SU6->U6_CODLIG == cCodLig;
				.And. SU6->U6_LISTA == cLista 						
			
				RecLock("SU6",.F.)
				SU6->U6_DATA	:= DataValida( dDatabase + 1 )
				SU6->(MsUnLock())		
				SU6->(DbSkip())
			EndDo		
			 
			cAtendiAnt := cAtendi          //a variável cAtendiAnt é uma auxiliar
										   // para eu checar se é o mesmo atendimento, para não armazenar
										   // no array novamente (porque o atendimento pode ter vários itens)
		
		Endif
	//Endif
	DbselectArea("TIMOUT")
	TIMOUT->(DBSKIP())
	
Enddo 

DbselectArea("TIMOUT")
TIMOUT->(DBCLOSEAREA()) 

// Habilitar somente para Schedule
Reset environment		

Return .T.         
//////////////////////
//FIM DO 1o. TIMEOUT 
//////////////////////


//////////////////////////////////////////////////////////////
//TMKRETENC - Envia e-mail para o cliente informando sobre
//a retenção de sua NF/MERCADORIA EM POSTO FISCAL
//////////////////////////////////////////////////////////////
********************************
User Function TMKRetenc( aInfo )
********************************


Local eEmail
Local cFilAtend := ""
Local cAtendim	:= ""
Local cTelTransp:= ""
Local cDia1		:= ""
Local cMes1		:= ""
Local cAno1		:= ""
Local cContato  := ""
Local cNF		:= ""
Local cSerNF	:= ""
Local cNomTransp:= ""
Local dEmissao	:= Ctod("  /  /    ")
Local lEnviou1	:= .F.
Local cVendedor := ""
Local dPrevCheg := Ctod("  /  /    ")
Local dAgcli    := Ctod("  /  /    ")
Local cEntidade := ""
Local cChave	:= ""
Local cUCFilial	:= ""
Local nOpcao	:= 0
Local cQuery	:= ""

For fr:= 1 to Len( aInfo )
	
	cNF			:= aInfo[fr,1]  
	cSerNF		:= aInfo[fr,2]
	dEmissao	:= aInfo[fr,3]
	cEntidade	:= aInfo[fr,4]
	cChave		:= aInfo[fr,5]
	cUCFilial	:= aInfo[fr,6]	
	cAtendim  	:= aInfo[fr,7]
	cNomTransp 	:= aInfo[fr,8]
	cTelTransp	:= aInfo[fr,9]	
	dPrevCheg	:= aInfo[fr,10]
	dAgcli		:= aInfo[fr,11]
	nOpcao		:= aInfo[fr,12]	
	
Next 


lEnviou1 := U_FREnvMail( dPrevCheg, dAgcli, cNF, cSerNF, dEmissao, cEntidade, cChave, cUCFilial, cNomTransp, cTelTransp, nOpcao )
//U_FRENVMAIL - DENTRO DO TMKC016
///NESTE P.E. SÓ IRÁ FAZER ENVIO RELATIVO A RETENÇÃO E REAGENDAMENTO (CLIENTE)
If lEnviou1
	//////////////////////////////////////////////////////////////
	//Atualiza o atendimento - cpo envio de email Retenção - SUC
	//////////////////////////////////////////////////////////////
	If nOpcao = 1	        //Opção 1 => retenção, então grava flag de envio de email retenção (pois somente é enviado uma vez)
		DbselectArea("SUC")
		Dbsetorder(1)
		SUC->(Dbseek( cUCFilial + cAtendim ) )
		While SUC->(!EOF()) .And. SUC->UC_FILIAL == cUCFilial .And. SUC->UC_CODIGO == cAtendim
			Reclock("SUC",.F.)
			SUC->UC_ENVMAIL := "S"
			SUC->( MsUnlock() )		
			SUC->(Dbskip())
			
		Enddo
		cLista := ""
		cCodLig:= ""
		
		cQuery := " SELECT TOP 1 U6_DATA, U6_FILIAL,U6_LISTA, U6_CODLIG, U6_NFISCAL "
		cQuery += " FROM SU6020 SU6 "    			
		cQuery += " WHERE U6_NFISCAL = '" + Alltrim(cNF) + "' and U6_SERINF = '"+ Alltrim(cSerNF) + "' "
		cQuery += " AND U6_CODLIG   = '" + Alltrim(cAtendim) + "' "
		cQuery += " AND U6_FILIAL   = '" + xFilial("SU6") + "' "
		cQuery += " AND SU6.D_E_L_E_T_ = '' "
		cQuery += " ORDER BY U6_DATA DESC "
			
		If Select("SU6XX") > 0
			DbSelectArea("SU6XX")
			DbCloseArea()	
		EndIf
			
		TCQUERY cQuery NEW ALIAS "SU6XX" 
		TCSetField( "SU6XX" , "U6_DATA", "D")
			
		SU6XX->(DbGoTop())
		While SU6XX->(!EOF())
			cLista := SU6XX->U6_LISTA
			cCodLig:= SU6XX->U6_CODLIG
			SU6XX->(DBSKIP())
		Enddo
			
		DbSelectArea("SU6XX")
		DbCloseArea()			
			
		//////////////////////////////////
		//Atualiza o agendamento - SU6
		/////////////////////////////////
		DbSelectArea("SU6")
		DbSetOrder(1)          // U6_FILIAL + U6_LISTA + U6_CODIGO	
		SU6->(DbSeek(xFilial("SU6") + cLista ))	
		While !Eof() .And. SU6->U6_FILIAL == xFilial("SU6") .And.  SU6->U6_CODLIG == cCodLig;
			.And. SU6->U6_LISTA == cLista 						
		
			RecLock("SU6",.F.)
			SU6->U6_ENVMAIL := "S"

			SU6->(MsUnLock())		
			SU6->(DbSkip())
		EndDo		
			
		
		    
    Elseif nOpcao = 2    
    		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    		///Opção 2 => aviso de reagendamento, grava no campo UC_AGANTES (dt. anterior de agendamento) este novo agendamento
    		////para em caso de novo reagendamento, comparar se o novo é diferente do antigo e mais uma vez, enviar o e-mail
    		////(só envia e-mail reagendamento, se a data for diferente da anterior)
    		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    	
    	DbselectArea("SUC")
		Dbsetorder(1)
		SUC->(Dbseek( cUCFilial + cAtendim ) )
		While SUC->(!EOF()) .And. SUC->UC_FILIAL == cUCFilial .And. SUC->UC_CODIGO == cAtendim
			Reclock("SUC",.F.)
			SUC->UC_AGANTES := dAgcli
			SUC->( MsUnlock() )		
			SUC->(Dbskip())
			
		Enddo
    	
    	DbselectArea("SF2")
		Dbsetorder(1)
		SUC->(Dbseek(xFilial("SF2") + cNF + cSerNF ) )
		While SF2->(!EOF()) .And. SF2->F2_FILIAL == xFilial("SF2") .And. SF2->F2_DOC == cNF .And. SF2->F2_SERIE == cSerNF
			Reclock("SF2",.F.)
			SF2->F2_DTAGCLI := dAgcli
			SF2->( MsUnlock() )		
			SF2->(Dbskip())
			
		Enddo
        
	Else    //SE FOR APENAS O AVISO DE POSTO FISCAL PARA LOGÍSTICA
	
		DbselectArea("SUC")
		Dbsetorder(1)
		SUC->(Dbseek( cUCFilial + cAtendim ) )
		While SUC->(!EOF()) .And. SUC->UC_FILIAL == cUCFilial .And. SUC->UC_CODIGO == cAtendim
			Reclock("SUC",.F.)
			SUC->UC_EVMAIL2 := "S"
			SUC->( MsUnlock() )		
			SUC->(Dbskip())
			
		Enddo
		
		cLista := ""
		cCodLig:= ""
		
		cQuery := " SELECT TOP 1 U6_DATA, U6_FILIAL,U6_LISTA, U6_CODLIG, U6_NFISCAL "
		cQuery += " FROM SU6020 SU6 "    			
		cQuery += " WHERE U6_NFISCAL = '" + Alltrim(cNF) + "' and U6_SERINF = '"+ Alltrim(cSerNF) + "' "
		cQuery += " AND U6_CODLIG   = '" + Alltrim(cAtendim) + "' "
		cQuery += " AND U6_FILIAL   = '" + xFilial("SU6") + "' "
		cQuery += " AND SU6.D_E_L_E_T_ = '' "
		cQuery += " ORDER BY U6_DATA DESC "
			
		If Select("SU6XX") > 0
			DbSelectArea("SU6XX")
			DbCloseArea()	
		EndIf
			
		TCQUERY cQuery NEW ALIAS "SU6XX" 
		TCSetField( "SU6XX" , "U6_DATA", "D")
			
		SU6XX->(DbGoTop())
		While SU6XX->(!EOF())
			cLista := SU6XX->U6_LISTA
			cCodLig:= SU6XX->U6_CODLIG
			SU6XX->(DBSKIP())
		Enddo
			
		DbSelectArea("SU6XX")
		DbCloseArea()			
			
		//////////////////////////////////
		//Atualiza o agendamento - SU6
		/////////////////////////////////
		DbSelectArea("SU6")
		DbSetOrder(1)          // U6_FILIAL + U6_LISTA + U6_CODIGO	
		SU6->(DbSeek(xFilial("SU6") + cLista ))	
		While !Eof() .And. SU6->U6_FILIAL == xFilial("SU6") .And.  SU6->U6_CODLIG == cCodLig;
			.And. SU6->U6_LISTA == cLista 						
		
			RecLock("SU6",.F.)
			SU6->U6_EVMAIL2 := "S"

			SU6->(MsUnLock())		
			SU6->(DbSkip())
		EndDo		
		
		DbselectArea("SF2")
		Dbsetorder(1)
		SUC->(Dbseek(xFilial("SF2") + cNF + cSerNF ) )
		While SF2->(!EOF()) .And. SF2->F2_FILIAL == xFilial("SF2") .And. SF2->F2_DOC == cNF .And. SF2->F2_SERIE == cSerNF
			Reclock("SF2",.F.)
			SF2->F2_EVMAIL2 := "S"			
			SF2->( MsUnlock() )		
			SF2->(Dbskip()) 
		Enddo
			
	Endif
		
Endif


Return
//////////////////////////////////////////////////
////VALIDAÇÃO NO CAMPO UC_REALCHG
////PARA AVISAR AO USUÁRIO QUE SE ELE PREENCHER 
////ESTE CAMPO, O ATENDIMENTO SERÁ ENCERRADO
//////////////////////////////////////////////////
****************************
User Function MSGCHEG()
****************************

MsgINfo("Ao preencher a Data Real de Chegada, o atendimento será Encerrado.")

Return .T.   

**********************************
User Function TMKAvisar( )
**********************************

Local aRespo 		:= {} 
Local aUser			:= {}     
Local _nX    		:= 0
Local dDataHj		:= CtoD("  /  /    ")
Local dDataPrev		:= CtoD("  /  /    ")		
Local cQuery 		:= ""
Local lEnvia		:= .F.
Local cAtendi		:= ""
Local cFil			:= ""
Local cUserNome		:= ""
Local eEmail		:= ""
Local cCodUser      := ""
Local cNFiscal		:= ""
Local cLista		:= ""
Local cCodLig		:= ""
Local LF      	:= CHR(13)+CHR(10) 
Local nFalta	:= 0 
Local cUsu
Local cResp
Local eEmail 		:= ""
Local cTransp		:= ""
Local cRedesp		:= "" 
Local cNomTransp 	:= "" 
Local cNomRedesp	:= ""
Local cNota			:= ""
Local cSerinf		:= ""
Local nItemUD		:= 0
Local cUCcodigo		:= ""
Local cExecut		:= ""
Local cExecutAnt	:= "" 

SetPrvt("OHTML,OPROCESS")


// Habilitar somente para Schedule
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"


conout(Replicate("*",60))
conout("Aviso CallCenter - INICIO")
conout(Replicate("*",60))

oProcess:=TWFProcess():New("CALLCENTER","Aviso - Call center")
oProcess:NewTask('Aviso Prazo',"\workflow\http\oficial\WFAviso.html")
oHtml := oProcess:oHtml


cQuery := " SELECT UD_DATA, UD_RESOLVI, UC_FILIAL, UC_CODIGO, UC_DATA, UC_PENDENT, UC_HRPEND,  UC_INICIO, UC_NFISCAL,UC_SERINF, "+LF
cQuery += " UC_CHAVE, UC_ENTIDAD,  UD_FILIAL,UD_CODIGO, UD_ITEM, UD_FLAGAT,   "+LF
cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5,  UC_OPERADO, UD_OPERADO  "+LF
cQuery += " FROM SUC020 SUC, "+LF
cQuery += " SUD020 SUD  "+LF
cQuery += " WHERE UC_CODIGO = UD_CODIGO  "+LF
cQuery += " AND (UD_DATA <> '' and UD_RESOLVI = '') "+LF     ///data para ação preenchida e resolvido = branco
cQuery += " AND (UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO) <> ''   "+LF
cQuery += " AND UD_STATUS <> '2' "+LF
cQuery += " AND SUD.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SUC.D_E_L_E_T_ = ''  "+LF
cQuery += " AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF
cQuery += " AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' "+LF
cQuery += " Group by UD_DATA, UD_RESOLVI, UC_FILIAL, UC_CODIGO, UC_DATA, UC_PENDENT, UC_HRPEND,  UC_INICIO, UC_NFISCAL,UC_SERINF, "+LF
cQuery += " UC_CHAVE, UC_ENTIDAD,  UD_FILIAL,UD_CODIGO, UD_ITEM, UD_FLAGAT,   "+LF
cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5,  UC_OPERADO, UD_OPERADO  "+LF
cQuery += " ORDER BY UD_CODIGO,UD_ITEM " +LF
//Memowrite("\Temp\TMKAviso.SQL",cQuery) 

If Select("TMPA") > 0
	DbSelectArea("TMPA")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "TMPA" 
TCSetField( "TMPA" , "UC_PENDENT", "D")
TCSetField( "TMPA" , "UD_DATA", "D")

TMPA->(DbGoTop())
dDataHj := dDatabase
While TMPA->(!EOF())
	
	cUCcodigo := TMPA->UC_CODIGO
	cExecut   := TMPA->UD_OPERADO
	If cExecut != cExecutAnt       ////se o responsável for o mesmo, não fará a passagem abaixo, evita que envie duas vezes
	      aRespo    := {} 
	      nItemUD := 0						 							
	      cEntidade := TMPA->UC_ENTIDAD
	      cChave    := TMPA->UC_CHAVE
	      cNota		:= TMPA->UC_NFISCAL
	      cSerinf	:= TMPA->UC_SERINF
					      
			cQuery := " SELECT UD_FILIAL,UD_CODIGO, UD_OPERADO, UD_ITEM, UD_DATA, UD_RESOLVI, " + LF
			cQuery += " UD_N1, UD_N2, UD_N3, UD_N4, UD_N5, UD_OBS, " + LF
			cQuery += " UC_CODIGO, UC_NFISCAL, UC_SERINF " + LF
			cQuery += " FROM "+RetSqlName("SUD")+" SUD, " + LF
			cQuery += " "+RetSqlName("SUC")+" SUC " + LF
			cQuery += " WHERE UC_CODIGO = UD_CODIGO  "+LF
			cQuery += " AND SUD.D_E_L_E_T_ = ''  "+LF
			cQuery += " AND SUC.D_E_L_E_T_ = ''  "+LF
			cQuery += " AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF
			cQuery += " AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' "+LF
			cQuery += " AND UD_CODIGO = '" + cUCcodigo + "' " + LF
			cQuery += " AND UD_OPERADO = '"  + cExecut   + "' " + LF
			cQuery += " ORDER BY UD_CODIGO, UD_OPERADO, UD_ITEM "			 + LF
			//Memowrite("C:\TMKAviso2.SQL",cQuery)
			If Select("SUDX1") > 0		
				DbSelectArea("SUDX1")
				DbCloseArea()			
			EndIf
			TCQUERY cQuery NEW ALIAS "SUDX1"
			TCSetField( "SUDX1", "UD_DATA"   , "D")
			SUDX1->(DbGoTop())
			While !SUDX1->(Eof())								
				dDataPrev  := SUDX1->UD_DATA 		/////////////////////////////////////////////////////////////////////////	
				nFalta := dDataPrev - dDataHj  		///AQUI DEFINE SE ENVIA OU NAO O AVISO PARA O RESPONSÁVEL
													///SÓ ENVIA UM DIA ANTES E NO PRÓPRIO DIA DA DATA PREV. AÇÃO (UD_DATA)
													/////////////////////////////////////////////////////////////////////////
													
				If ( nFalta = 1 .or. nFalta = 0 )     ////se falta um dia para expirar, ou se a ação expira no dia
					If !Empty(Alltrim( SUDX1->(UD_N1+UD_N2+UD_N3+UD_N4+UD_N5+UD_OPERADO ) )  ) 				         	   
						         
						Aadd(aRespo, { SUDX1->UD_CODIGO,;       //1
										SUDX1->UD_N1,;            	//2
						       			SUDX1->UD_N2,;            	//3
						       			SUDX1->UD_N3,;            	//4
						       			SUDX1->UD_N4,;            	//5
						       			SUDX1->UD_N5,;            	//6
						       			SUDX1->UD_OPERADO,;       	//7
						       			cEntidade,;             	//8
						       			cChave,;            	    //9
						       			SUDX1->UD_ITEM,;        	//10
						       			SUDX1->UD_FILIAL,;	      	//11
						       			SUDX1->UD_OBS,;      		//12
						       			SUDX1->UD_DATA,;    		//13
						        		SUDX1->UC_NFISCAL,; 		//14
						        		SUDX1->UC_SERINF  })        //15
						        		nItemUD++
			       	Endif
			    Endif						        
		      	SUDX1->(DBSKIP())
			Enddo
			cExecutAnt := cExecut
			If nItemUD > 0
			   	
			   	// Inicialize a classe de processo:
				oProcess:=TWFProcess():New("CALLCENTER","Call center")
	
				// Crie uma nova tarefa, informando o html template a ser utilizado:
				oProcess:NewTask('Inicio',"\workflow\http\oficial\WFAviso.html")
				oHtml   := oProcess:oHtml			
				
				PswOrder(1)                             ///////////////////////////////////////////////////////////////////////////////////////////////
				If PswSeek( aRespo[1][7], .T. )         //aRespo[1][7]===> UD_OPERADO - Responsável pelo atendimento
														//O código do responsável pelo atendimento fica no UD_OPERADO, 
				   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
				   cUsu   := Alltrim( aUsu[1][2] )      //Nome do usuário (responsável pelo atendimento)
				   eEmail := Alltrim( aUsu[1][14] )     // Definição de e-mail padrão	
				Endif                                   ///////////////////////////////////////////////////////////////////////////////////////////////
				
				
				oHtml:ValByName("cResp", cUsu )
				oHtml:ValByName("nFalta", iif(nFalta = 0, "HOJE", " em " + Str(nFalta)+ " dia") )
				
				DbSelectArea(aRespo[1,8])
				DbSetOrder(1)
				DbSeek(xFilial(aRespo[1,8])+AllTrim(aRespo[1,9]))
				
				oHtml:ValByName("cCli", iif(aRespo[1,8]=="SA1",SA1->A1_NOME,iif(aRespo[1,8]=="SA2",SA2->A2_NOME,"") ) )
				oHtml:ValByName("cNF", cNota )
				oHtml:ValByName("cSERINF", cSerinf )
				
				SF2->(Dbsetorder(1))
				If SF2->(Dbseek( xFilial("SF2") + cNota + cSerinf ))					
					cTransp:= SF2->F2_TRANSP
					cRedesp := SF2->F2_REDESP
				Endif
				SA4->(Dbsetorder(1))
				SA4->(Dbseek(xFilial("SA4") + cTransp ))
				cNomTransp := SA4->A4_NREDUZ
				
				oHtml:ValByName("cTransp", cNomTransp )
				
				SA4->(Dbsetorder(1))
				SA4->(Dbseek(xFilial("SA4") + cRedesp ))
				cNomRedesp := SA4->A4_NREDUZ
				oHtml:ValByName("cRedesp", cNomRedesp )
				
				
				For _nX := 1 to Len(aRespo)
				     
				   aadd( oHtml:ValByName("it.cAtend"), aRespo[_nX,1] )
				   aadd( oHtml:ValByName("it.cItem"),  aRespo[_nX,10] )	
				   aadd( oHtml:ValByName("it.cProb") , iif(!Empty(aRespo[_nX,2]),Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,2],"Z46_DESCRI"),"")+;
					                                    iif(!Empty(aRespo[_nX,3]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,3],"Z46_DESCRI"),"")+;
					                                    iif(!Empty(aRespo[_nX,4]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,4],"Z46_DESCRI"),"")+;
					                                    iif(!Empty(aRespo[_nX,5]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,5],"Z46_DESCRI"),"")+;
					                                    iif(!Empty(aRespo[_nX,6]),"->"+Posicione("Z46",1,xFilial("Z46")+aRespo[_nX,6],"Z46_DESCRI"),"") )
				   aadd( oHtml:ValByName("it.Respon"), cUsu )
				   aadd( oHtml:ValByName("it.cObs"), aRespo[_nX,12] )
				   aadd( oHtml:ValByName("it.1aData"), Dtoc(aRespo[_nX,13]) )
				   aadd( oHtml:ValByName("it.filial"), aRespo[_nX,11] )
				Next _nX			
				
				
				// Informe a função que deverá ser executada quando as respostas chegarem
				// ao Workflow.
				oProcess:cTo      :=  eEmail  + ";sac@ravaembalagens.com.br;posvendas@ravaembalagens.com.br"
				oProcess:cBCC	  := "" //"flavia.rocha@ravaembalagens.com.br"
				oProcess:cSubject := "AVISO DE PRAZO A EXPIRAR - Ocorrência - SAC"
							
				// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
				// de destinatários.
				oProcess:Start()				
				WfSendMail()	
				
			Endif							
		
	Endif
 
	TMPA->(DBSKIP())
Enddo

DbselectArea("TMPA")
TMPA->(DBCLOSEAREA()) 


// Habilitar somente para Schedule
Reset environment		

Return .T.




********************************
User Function fENV_Encer( cOcorr, cItemO )
********************************

Local cUsu
Local aUsu			:= {}
Local cSup			:= ""
Local aSup			:= {}
Local cMailSup		:= ""
Local cNomeSup		:= ""
Local cNomeOper		:= ""
Local cVendedor		:= ""
Local cSuper		:= ""
Local cMailSuper	:= ""

Local cResp
Local eEmail 		:= "" 
Local eEmailResp	:= ""
Local cNomTransp 	:= "" 
Local cNomRedesp	:=""
Local LF      	:= CHR(13)+CHR(10) 
Local nEnvio	:= 0
Local cSetor	:= ""

Local cMailCopia:= ""
Local cCopiaFIN := "" 
Local lMarcelo  := .F. 
Local aParcelas := {}
Local cBanco    := ""  
Local cPar1     := ""
Local cPar2     := "" 
Local cPar3     := ""
Local cPar4     := ""
Local cPar5     := "" 
Local cPar6     := ""
Local cPar7     := ""
Local cPar8     := ""
Local cPar9     := ""
Local cPar10     := ""

Local cVenc1    := ""
Local cVenc2    := ""
Local cVenc3    := ""
Local cVenc4    := ""
Local cVenc5    := ""
Local cVenc6    := ""
Local cVenc7    := ""
Local cVenc8    := ""
Local cVenc9    := ""
Local cVenc10    := ""
Local cVarP     := ""  //variável da parcela
Local cVarV     := ""  //variável do vencto
Local cVarVal   := ""  //variável do valor da parcela
Local aEnce     := {}
Local cAlias    := "SUC"
Local cCHAVCLI  := ""
Local cNOTA     := ""
Local cSERI     := ""
Local cTransp   := "" 
Local cNomtransp:= ""
Local cRedesp   := "" 
Local cNomRedesp:= ""

SetPrvt("OHTML,OPROCESS")


// Inicialize a classe de processo:
oProcess:=TWFProcess():New("CALLCENTER","Call center")

// Crie uma nova tarefa, informando o html template a ser utilizado:
oProcess:NewTask('Inicio',"\workflow\http\oficial\WFSAC_E.html")
oHtml   := oProcess:oHtml

SUC->(Dbsetorder(1))
SUC->(Dbseek(xFilial("SUC") + cOcorr))
cCHAVCLI := SUC->UC_CHAVE
cNOTA    := SUC->UC_NFISCAL
cSERI    := SUC->UC_SERINF

SUD->(DBSETORDER(1))
If SUD->(Dbseek(xFilial("SUD") + cOcorr + cItemO ))
	While SUD->(!EOF()) .and. SUD->UD_FILIAL == xFilial("SUD") .and. SUD->UD_CODIGO == cOcorr .and. SUD->UD_ITEM == cItemO
		If !Empty(Alltrim(SUD->UD_OPERADO) )
			Aadd(aEnce, { SUD->UD_CODIGO,;       //1
		       			    SUD->UD_N1,;            	//2
		       			    SUD->UD_N2,;            	//3
		       			    SUD->UD_N3,;            	//4
		       			    SUD->UD_N4,;            	//5
		       			    SUD->UD_N5,;            	//6
		       			    SUD->UD_OPERADO,;       	//7
		       			    cAlias,;             	    //8
		       			    cCHAVCLI,;            	    //9
		       			    SUD->UD_ITEM,;      	  	//10
		       			    SUD->UD_FILIAL,;	      	//11
		       			    SUD->UD_OBS,;      			//12
		       			    SUD->UD_DATA,;				//13
		       			    SUD->UD_MAILCC,;            //14
		       			    SUD->UD_OBSENC } )          //15
		Endif
	SUD->(Dbskip())	
	Enddo
Endif

If Len(aEnce) > 0	
	PswOrder(1)
	If PswSeek( aEnce[1][7], .T. )      //UD_OPERADO
	        
	//////////////////////////////////////////////////////////////////////////////////////////////
	//aRespo[1][7]===> UD_OPERADO - Responsável pelo atendimento
	//O código do responsável pelo atendimento fica no UD_OPERADO, NÃO É o mesmo do UC_OPERADO
	//no SUC, o código que fica no UC_OPERADO, é do operador que incluiu o atendto.
	//////////////////////////////////////////////////////////////////////////////////////////////
	   
	   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
	   cUsu   := Alltrim( aUsu[1][2] )      //Nome do usuário (responsável pelo atendimento)
	   eEmailResp := Alltrim( aUsu[1][14] )     // Definição de e-mail padrão
	   cSup	  := aUsu[1][11]
	   ///verifica o superior do usuário para enviar a ocorrência com cópia ao Superior dele
	   PswOrder(1)
	   If PswSeek(cSup, .t.)
		   aSup := PswRet()
		   cNomeSup := If(!Empty(aSup),aSup[1][4],"") 		//Superior	(nome completo)
		   cMailSup := Alltrim( aSup[1][14])                //endereço e-mail
	   Endif
	Endif
	
	
	oHtml:ValByName("cSuperior", Alltrim(cNomeSup) )
	oHtml:ValByName("cResp", cUsu )
	
	DbSelectArea(aEnce[1,8])
	DbSetOrder(1)
	DbSeek(xFilial(aEnce[1,8])+AllTrim(aEnce[1,9]))
	
	oHtml:ValByName("cCli", iif(aEnce[1,8]=="SA1",SA1->A1_NOME,iif(aEnce[1,8]=="SA2",SA2->A2_NOME,"") ) )
	oHtml:ValByName("cCodCli", Substr(aEnce[1,9],1,6) + '/' + Substr(aEnce[1,9],7,2) )
	
	If !Empty(cNOTA)
		oHtml:ValByName("cNF", cNOTA )
		oHtml:ValByName("cSERINF", cSERI )
	
		SE1->(DbsetOrder(1))
		If SE1->(Dbseek(xFilial("SE1") + cSERI + cNOTA ))  
			While SE1->(!EOF()) .And. SE1->E1_FILIAL == xFilial("SE1") .And. Alltrim(SE1->E1_PREFIXO) = Alltrim(cSERI) .And. Alltrim(SE1->E1_NUM) = Alltrim(cNOTA)
				cBanco := SE1->E1_PORTADO			
				Aadd( aParcelas , {SE1->E1_PARCELA, SE1->E1_VENCTO, SE1->E1_PORTADO, SE1->E1_AGEDEP, SE1->E1_CONTA, SE1->E1_VALOR } )
				//                      1                  2                3                4              5             6
				SE1->(DBSKIP())
			Enddo
		Endif
		
	Else 
		oHtml:ValByName("cNF", "Sem NF" )
		oHtml:ValByName("cSERINF", "" )
	Endif
	
	fr := 1
	SA6->(Dbsetorder(1))
	If Len(aParcelas) > 0
		If SA6->(Dbseek(xFilial("SA6") + aParcelas[1,3] + aParcelas[1,4] + aParcelas[1,5] ))
			//oHtml:ValByName("cBanco", SA6->A6_NOME ) 
			oHtml:ValByName("cBanco", aParcelas[1,3] ) //SÓ O BANCO (001, 341, 004 etc)
		Else 
			oHtml:ValByName("cBanco", "" )
		Endif
	Endif
	
	If Len(aParcelas) > 0
		For fr := 1 to 10
			cVarP := '"cParc' + Alltrim(str(fr)) + '"'
			cVarV := '"cVenc' + Alltrim(str(fr)) + '"'	
			cVarVal:= '"cVal' + Alltrim(str(fr)) + '"'	
			If fr <= Len(aParcelas)
				If !Empty(aParcelas[fr,1])
					oHtml:ValByName( &cVarP, aParcelas[fr,1] +  " -" )   //parcela
				Else
					oHtml:ValByName( &cVarP, " ' ' -" )          //parcela em branco
				Endif
					oHtml:ValByName( &cVarV, " " + Dtoc(aParcelas[fr,2]) )  //vencto
					oHtml:ValByName( &cVarVal, " " + "R$" + Transform(aParcelas[fr,6], "@E 9,999,999.99") + " ;  " )  //valor
			
				//ex.  1 - 01/09/2012  R$9.999.999,99 
				//ex. '' - 01/09/2012  R$9.999.999,99 ,
				//Else
				//	oHtml:ValByName( &cVarP, "" )
				//	oHtml:ValByName( &cVarV, "" )		
				//Endif
			Endif
		Next
	Endif
	//fim das modificações relativas ao chamado 00000074
	
	SF2->(Dbsetorder(1))
	If SF2->(Dbseek(xFilial("SF2") + cNOTA + cSERI ))
		cVendedor := SF2->F2_VEND1
		cTransp   := SF2->F2_TRANSP 
		cRedesp := SF2->F2_REDESP
	Endif
	SA4->(Dbsetorder(1))
	SA4->(Dbseek(xFilial("SA4") + cTransp ))
	cNomTransp := SA4->A4_NREDUZ
	
	oHtml:ValByName("cTransp", cNomTransp )
	
	SA4->(Dbsetorder(1))
	SA4->(Dbseek(xFilial("SA4") + cRedesp ))
	cNomRedesp := SA4->A4_NREDUZ
	oHtml:ValByName("cRedesp", cNomRedesp ) 
	
	
	
	SA3->(Dbsetorder(1))
	If SA3->(Dbseek(xFilial("SA3") + cVendedor ))
		cSuper := SA3->A3_SUPER
	Endif
	
	SA3->(Dbsetorder(1))
	If SA3->(Dbseek(xFilial("SA3") + cSuper ))
		cMailSuper := SA3->A3_EMAIL
	Endif
	//FR - até aqui
	
	PswOrder(1)
	If PswSeek( cUsuario, .T. )      //USUÁRIO LOGADO QUE INCLUIU A OCORRÊNCIA        
	   
	   aUsu   := PSWRET() 					// Retorna vetor com informações do usuário
	   cNomeOper := Alltrim(aUsu[1][4])		//Nome Completo
	   eEmail := Alltrim( aUsu[1][14] )     // Definição de e-mail padrão   
	   
	Endif
	
	oHtml:ValByName("cOperador", cNomeOper )
	
	For _nX := 1 to Len(aEnce)
	     
	   aadd( oHtml:ValByName("it.cAtend"), aEnce[_nX,1] )
	   aadd( oHtml:ValByName("it.cItem"),  aEnce[_nX,10] )	
	   aadd( oHtml:ValByName("it.cProb") , iif(!Empty(aEnce[_nX,2]),Posicione("Z46",1,xFilial("Z46")+aEnce[_nX,2],"Z46_DESCRI"),"")+;
		                                    iif(!Empty(aEnce[_nX,3]),"->"+Posicione("Z46",1,xFilial("Z46")+aEnce[_nX,3],"Z46_DESCRI"),"")+;
		                                    iif(!Empty(aEnce[_nX,4]),"->"+Posicione("Z46",1,xFilial("Z46")+aEnce[_nX,4],"Z46_DESCRI"),"")+;
		                                    iif(!Empty(aEnce[_nX,5]),"->"+Posicione("Z46",1,xFilial("Z46")+aEnce[_nX,5],"Z46_DESCRI"),"")+;
		                                    iif(!Empty(aEnce[_nX,6]),"->"+Posicione("Z46",1,xFilial("Z46")+aEnce[_nX,6],"Z46_DESCRI"),"") )
	   aadd( oHtml:ValByName("it.Respon"), cUsu )
	   aadd( oHtml:ValByName("it.cObs"), aEnce[_nX,12] )
	   aadd( oHtml:ValByName("it.cSolu"), aEnce[_nX,15] )
	   aadd( oHtml:ValByName("it.cMailCopia"), aEnce[_nX,14] + ";" )
	   aadd( oHtml:ValByName("it.filial"), aEnce[_nX,11] )
	   
	   If Alltrim(aEnce[_nX,3]) = '0050'
	       cSetor := aEnce[_nX,3]
	   Endif 
	   
	   If !aEnce[_nX,14] $ cMailCopia
	   	cMailCopia += aEnce[_nX,14] + ";"
	   Endif
	   ///verifica se enquadra nos problemas abaixo, e envia cópia do email para Marcelo 
	   //em 22/04 Daniela solicitou que ao invés de enviar para Marcelo, seja enviada c/cópia p/ Flavia Leite
	   SUD->(DBSETORDER(1))
		If SUD->(Dbseek(xFilial("SUD") + aEnce[_nX,1] + aEnce[_nX,10] ))
			////COMERCIAL
			If Alltrim(SUD->UD_N1) = '0001'      //reclamação
				If Alltrim(SUD->UD_N2) = '0034'              //comercial
					If Alltrim(SUD->UD_N3) = '0035'                     //produto
						If Alltrim(SUD->UD_N4) = '0100'						//FALHA
							lMarcelo := .T.					
						Endif
					Endif
				Endif
			Endif
			///////LICITAÇÃO
			If Alltrim(SUD->UD_N1) = '0001'      //reclamação
				If Alltrim(SUD->UD_N2) = '0075'              //LICITAÇÃO
					If Alltrim(SUD->UD_N3) = '0076'                     //produto
						If Alltrim(SUD->UD_N4) = '0077'						//FALHA
							lMarcelo := .T.				
						Endif
					Endif
				Endif
			Endif
		Endif
	
	
	
	   
	Next _nX
	
	
	//SE O SETOR FOR FINANCEIRO (0050), Irá com cópia para Alessandra
	If Alltrim(cSetor) = '0050'
		cCopiaFIN	:= GetMv("RV_FINMAIL")
	//	cCopiaFIN	+= ";flavia.rocha@ravaembalagens.com.br"
	Endif
	
	//oProcess:cTo	:= eEmailResp  + ";" + eEmail  //eEmail -> email do usuário logado
	oProcess:cTo      :=  eEmailResp   + ";sac@ravaembalagens.com.br"   //usar este
	
	If !Empty(cMailSuper)
		oProcess:cTo      +=  ";" + cMailSuper     //email do coordenador do vendedor //voltar teste
	Endif
	
	If !Empty(cMailSup)
		oProcess:cTo      +=  ";" + cMailSup    //email do superior do responsável  //voltar teste
	Endif
	
	If !Empty(cCopiaFIN)
		oProcess:cTo      +=  ";" + cCopiaFIN    //email da Alessandra (qdo ocorrência do FIN, ela recebe cópia)
	Endif
	
	//oProcess:cTo := ""   //teste
	
	If !Empty(cMailCopia)
		oProcess:cTo      +=  ";" + cMailCopia    
	Endif
	
	//If lMarcelo
		//oProcess:cTo      += ";marcelo@ravaembalagens.com.br" //";marcelo@ravaembalagens.com.br;flavia@ravaembalagens.com.br"     //af
	//Endif
	
	oProcess:cSubject := "SAC - Ocorrência ENCERRADA"
	
	// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
	// de destinatários.
	//oProcess:cTo    :=  "flavia.rocha@ravaembalagens.com.br"  //teste
	//oProcess:cCC    := "flavia.rocha@ravaembalagens.com.br"  //teste
	//oProcess:cBCC	  := "flavia.rocha@ravaembalagens.com.br"
	oProcess:Start()
	
	WfSendMail()
	//alert("enviou")
Endif

Return

*************************************************************
Static Function AtualizaZ( cCod, cIT )
*************************************************************
//FR - 22/10/13 - FIZ ESTA FUNÇÃO, PARA QUE AO SER FEITO
//REMANEJAMENTO DE ITENS DAS OCORRÊNCIAS, SEJA TAMBÉM
//ATUALIZADO NOS ARQUIVOS ZUD - HISTÓRICO OCORRÊNCIAS
// E Z10 - PROCESSOS DEVOLUÇÃO

Local nRecUD := 0
Local aRecZ  := {} 
Local aRecFica := {} 
Local t      := 0

//primeiro alimenta o array de recnos do ZUD
DbselectArea("ZUD")
Dbsetorder(1)                 //ZUD_CODIGO
ZUD->(Dbgotop())
ZUD->(Dbseek(xFilial("ZUD") + cCod ))  //+ cIT ))
While ZUD->(!EOF()) .and. ZUD->ZUD_FILIAL == xFilial("ZUD") .and. ZUD->ZUD_CODIGO == cCod

  	
  	Aadd( aRecZ , {ZUD->ZUD_CODIGO , ZUD->ZUD_ITEM , ZUD->ZUD_RECSUD } )
  	
	ZUD->(Dbskip())  
Enddo 
aRecZ := Asort( aRecZ,,, { |X,Y| X[3] <  Y[3]  } ) 
//pega este array e verifica na SUD (que é a matriz) SE ESTES RECNOS EXISTEM LÁ. 
//se existe, grava no aRecFica 
t:= 0
For  t := 1 to Len(aRecZ)
	DbselectArea("SUD")
	Dbsetorder(1)                 //UD_CODIGO
	SUD->(Dbgotop())
	SUD->(Dbseek(xFilial("SUD") + cCod ))  //+ aRecZ[t,2] ))
	While SUD->(!EOF()) .and. SUD->UD_FILIAL == xFilial("SUD") .and. SUD->UD_CODIGO == cCod
	  
	  	If SUD->(RECNO()) == aRecZ[t,3] .OR. (aRecZ[t,3] = 0) //os recsud do ZUD antes dessa implementação são = 0
	  		Aadd( aRecFica , aRecZ[t,3] ) //roda até o fim do arquivo procurando este recno da linha t,3 do array
	  	Endif	  	
		SUD->(Dbskip())  
	Enddo 
Next 

//DEPOIS , volta na ZUD e compara os recnos da ZUD se constam no array aRecFica
//se constarem, ficam, senão, deleta
DbselectArea("ZUD")
Dbsetorder(1)  //(2)    //ZUD_RECSUD
ZUD->(Dbgotop()) //ordena por e procura o recno
ZUD->(Dbseek(xFilial("ZUD") + cCod )) 
While ZUD->(!EOF()) .and. ZUD->ZUD_FILIAL == xFilial("ZUD") .and. ZUD->ZUD_CODIGO == cCod 

	If Ascan(aRecFica, ZUD->ZUD_RECSUD )= 0  	//SE NÃO ENCONTRAR, DELETA
    	RECLOCK("ZUD" , .F.)
    	ZUD->(DBDelete())
    	ZUD->(MsUnlock()) 
    	//ZUD->(Dbskip())
    	//Loop
 	Endif
 	//Else
 		ZUD->(Dbskip())  
 	//Endif
  	
	
Enddo 

//agora faz o mesmo com a tabela Z10
//primeiro alimenta o array de recnos do Z10
aRecZ := {}
aRecFica := {}
t := 0
DbselectArea("Z10")
Dbsetorder(2)                 //ZUD_CODIGO
Z10->(Dbseek(xFilial("Z10") + cCod ))  
While Z10->(!EOF()) .and. Z10->Z10_FILIAL == xFilial("Z10") .and. Z10->Z10_CODIGO == cCod 
  	
  	Aadd( aRecZ , {Z10->Z10_CODIGO , Z10->Z10_ITEM , Z10->Z10_RECSUD } )
  	
	Z10->(Dbskip())  
Enddo 

//pega este array e verifica na SUD (que é a matriz) SE ESTES RECNOS EXISTEM LÁ. 
//se existe, grava no aRecFica
aRecZ := Asort( aRecZ,,, { |X,Y| X[3] <  Y[3]  } ) 
For  t := 1 to Len(aRecZ)
	DbselectArea("SUD")
	Dbsetorder(1)                 //UD_CODIGO
	SUD->(Dbseek(xFilial("SUD") + cCod ))  
	While SUD->(!EOF()) .and. SUD->UD_FILIAL == xFilial("SUD") .and. SUD->UD_CODIGO == cCod
	  
	  	If SUD->(RECNO()) == aRecZ[t,3]	.OR. (aRecZ[t,3] = 0)		
	  		Aadd( aRecFica , aRecZ[t,3] )
	  	Endif	  	
		SUD->(Dbskip())  
	Enddo 
Next 

DbselectArea("Z10")
Dbsetorder(2) //ORDEM CÓDIGO OCORRÊNCIA //(3)            //ordena por e procura o recno
Z10->(Dbseek(xFilial("Z10") + cCod )) //aRecZ[1,3] ))  //cCod )) 
While Z10->(!EOF()) .and. Z10->Z10_FILIAL == xFilial("Z10") .and. Z10->Z10_CODIGO == cCod 

	If Ascan(aRecFica, Z10->Z10_RECSUD )= 0  	//SE NÃO ENCONTRAR, DELETA
    	RECLOCK("Z10" , .F.)
    	Z10->(DBDelete())
    	Z10->(MsUnlock())
    	//Z10->(Dbskip())  
    	//Loop
 	Endif
 	//Else
 		Z10->(Dbskip())  
 	//Endif
  	
	
Enddo 

Return

