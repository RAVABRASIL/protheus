#Include "Rwmake.ch"             
#Include "Protheus.ch"
#Include "Topconn.ch"

/*
/////////////////////////////////////////////////////////////////////////////////////////////////
//Programa: MT140SAI - Ponto de Entrada após a gravação da Pré-Nota
//Objetivo: Realizar a gravação de dados para a inspeção, antes de ser
//          dada entrada na NF, pois esta ação só será realizada (Classificar Doc.Entrada)
            após o produto ter sido inspecionado e aprovado.
//Autoria : Flávia Rocha
//Data    : 15/02/2011        
////////////////////////////////////////////////////////////////////////////////////////////////
*/
***************************
USER FUNCTION MT140SAI()
***************************


Local nOrdem := SF1->( IndexOrd() )
//PARAMIXB[1] = Numero da operação - ( 2-Visualização, 3-Inclusão, 4-Alteração, 5-Exclusão )
//PARAMIXB[2] = Número da nota
//PARAMIXB[3] = Série da nota
//PARAMIXB[4] = Fornecedor
//PARAMIXB[5] = Loja
//PARAMIXB[6] = Tipo
//PARAMIXB[7] = Opção de Confirmação (1 = Confirma pré-nota; 0 = Não Confirma pré-nota)



Local cDocto := PARAMIXB[2] // Número da nota
Local cSerie := PARAMIXB[3] // Série da nota 
Local cFornece:= PARAMIXB[4]
Local cLojaFor:= PARAMIXB[5]
Local cTipoNF := PARAMIXB[6]
Local aDados := {}
Local cD7Num := ""
Local cChave := ""
Local nTamAmo:= 0 
Local cLocal := ""
Local LF := CHR(13) + CHR(10) 
Local nRegD1 := 0    
Local nRegF1 := 0
Local aNFE   := {}
Local cPedido:= ""
Local nItem  := ""
Local nQuant := 0
Local nPreco := 0
Local nTotal := 0
Local nValipi:= 0
Local nPCvalipi := 0
Local nipi   := 0
Local nF1Frete := 0
Local nC7Frete  := 0
Local lDiverg:= .F.
Local cPed   := ""
Local cIt    := ""
Local nSEQ   := 0  

Private aDiverg:= {}



Private lPRTAuto := .F. 

SetPrvt("OHTML,OPROCESS")

If PARAMIXB[1] = 4
	MsgAlert("Não é Permitida a Alteração de uma Pré-Nota Lançada, Por Favor, Se Necessário, Exclua e Lance Novamente. Obrigado")
	Return .F.


//msgbox("TIPO: " + cTipoNF)
ELSEIF PARAMIXB[1] = 3		//Numero da operação - ( 2-Visualização, 3-Inclusão, 4-Alteração, 5-Exclusão )

	If PARAMIXB[7] = 1    //Opção de Confirmação (1 = Confirma pré-nota; 0 = Não Confirma pré-nota)
	
	
		If !cTipoNF $ "D/B" 
			  
			  While SD1->(!EOF()) .AND. SD1->D1_FILIAL == xFilial("SD1") .AND. Alltrim(SD1->D1_DOC) == Alltrim(cDocto) .AND. Alltrim(SD1->D1_SERIE) == Alltrim(cSerie)
				//MSGBOX("ENTROU")
								
				cPed := SD1->D1_PEDIDO
				cIt  := SD1->D1_ITEMPC
				//MSGBOX("pedido: " + cPed)
				If RecLock("SD1",.F.)
					cD7Num := fD1_numCQ()
					SD1->D1_NUMCQ := cD7Num
					SD1->(MsUnlock())
				Endif
				
				DbselectArea("SB1")
				SB1->(Dbsetorder(1))
				If SB1->(Dbseek(xFilial("SB1") + SD1->D1_COD))
					//If Alltrim(SB1->B1_TIPOCQ) = "Q"          //SÓ GERA INSPEÇÃO PARA OS PRODUTOS COM O FLAG = QUALITY
					If Alltrim(SB1->B1_RAVACQ) = "S"
					          
					///////////////////////////////////////////////////////////////////////
					//CRIEI ESTE CAMPO NOVO, PORQUE SE DEIXARMOS PELO FLAG PADRÃO, 
					//QDO CLASSIFICAR A NOTA, IRÁ REPETIR O PROCESSO PELO DOCTO. ENTRADA
					//E NÃO É NECESSÁRIO PORQUE JÁ FOI REALIZADO NA INCLUSÃO DA PRÉ-NOTA.
					//NÃO TEM COMO IMPEDIR O PROCESSO PELA PRÉ-NOTA VIA P.E., 
					//POR ESTE MOTIVO CRIEI ESTE NOVO CAMPO.
					///////////////////////////////////////////////////////////////////////
					
					    //MSGBOX(SD1->D1_COD + " - QUALITY")
					    //cLocal := '98'
					    
					    nSEQ++
						
					    //MSGBOX("CRIA SD7")
					    Dbselectarea("SD7")
					    //Dbsetorder(1)                    //D7_FILIAL + D7_NUMERO + D7_PRODUTO + D7_LOCAL + D7_SEQ + D7_DATA
					    //SD7_UNQ: D7_FILIAL + D7_SEQ + D7_NUMERO
					    //If !SD7->(Dbseek(xFilial("SD7") + cD7Num + SD1->D1_COD + SD1->D1_LOCAL + '001' + DTOS(SD1->D1_EMISSAO) ))
					    //If !SD7->(Dbseek(xFilial("SD7") + cD7Num + SD1->D1_COD + SD1->D1_LOCAL + Strzero(nSEQ , 3 ) + DTOS(SD1->D1_DTDIGIT) ))
					    
					    Dbsetorder(4)      //D7_FILIAL + D7_NUMERO  + D7_DOC + D7_SERIE + D7_FORNECE + D7_LOJA + D7_PRODUTO + D7_SEQ  //NOVO ÍNDICE
					    If !SD7->(Dbseek(xFilial("SD7") + cD7Num + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + Strzero(nSEQ , 3 )  ))
					    	//msgbox("entrou SD7")
							Reclock("SD7",.T.)
							SD7->D7_FILIAL := xFilial("SD7")
							SD7->D7_PRODUTO:= SD1->D1_COD
							SD7->D7_LOCAL  := '01' 
							SD7->D7_ORIGLAN:= 'PN'
							SD7->D7_CHAVE  := ''
							//SD7->D7_SEQ    := '001'
							SD7->D7_SEQ    := Strzero(nSEQ , 3 )	
							
				
							SD7->D7_ESTORNO:= ''
							SD7->D7_TIPO   := 0
							SD7->D7_SALDO  := SD1->D1_QUANT
							SD7->D7_QTSEGUM:= SD1->D1_QTSEGUM
							SD7->D7_USUARIO:= Substr(cUsuario,7,15)
							SD7->D7_DATA   := SD1->D1_EMISSAO
							SD7->D7_NUMSEQ := SD1->D1_NUMSEQ
							SD7->D7_LOCDEST:= '01' 
							SD7->D7_NUMERO := cD7Num //SD1->D1_NUMCQ
							SD7->D7_LIBERA := ''
							SD7->D7_LOTECTL:= SD1->D1_LOTECTL
							SD7->D7_NUMLOTE:= ''
							SD7->D7_MOTREJE:= ''
							SD7->D7_SALDO2 := SD1->D1_QUANT
							SD7->D7_TIPOCQ := 'M'
							SD7->D7_DOC    := SD1->D1_DOC
							SD7->D7_SERIE  := SD1->D1_SERIE
							SD7->D7_FORNECE:= SD1->D1_FORNECE
							SD7->D7_LOJA   := SD1->D1_LOJA
							SD7->D7_LOCALIZ:= ''
							SD7->D7_NUMSERI:= ''
							SD7->D7_POTENCI:= 0
							SD7->D7_ITEMSWN:= ''
							SD7->D7_DOCSWN := ''
							SD7->D7_SERVIC := ''
							
							SD7->(MsUnlock())
							//msgbox("SD7 OK: " + SD7->D7_NUMERO + '/' + SD7->D7_SEQ)
						Endif	
							aDados := {SD1->D1_DOC,; //1-Numero da Nota Fiscal
							SD1->D1_SERIE,;        //2-Serie da Nota Fiscal
							SD1->D1_TIPO,;         //3-Tipo da Nota Fiscal
							SD1->D1_EMISSAO,;      //4-Data de Emissao da Nota Fiscal
							SD1->D1_DTDIGIT,;      //5-Data de Entrada da Nota Fiscal
							"NF",;                 //6-Tipo de Documento
							SD1->D1_ITEM,;         //7-Item da Nota Fiscal
							" ",;                  //8-Numero do Remito (Localizacoes)
							SD1->D1_PEDIDO,;       //9-Numero do Pedido de Compra
							SD1->D1_ITEMPC,;       //10-Item do Pedido de Compra
							SD1->D1_FORNECE,;      //11-Codigo Fornecedor/Cliente
							SD1->D1_LOJA,;         //12-Loja Fornecedor/Cliente
							SD1->D1_LOTEFOR,;      //13-Numero do Lote do Fornecedor
							Space(6),;             //14-Codigo do Solicitante
							SD1->D1_COD,;          //15-Codigo do Produto
							SD1->D1_LOCAL,;        //16-Local Origem
							SD1->D1_DOC,;  //"LOTE000" ,; //aLote[1],;             //17-Numero do Lote     Lote é o número da NF + sequencial de cada item do PC
							SD1->D1_ITEMPC,;     // "001" ,; //aLote[2],;             //18-Sequencia do Sub-Lote
							SD1->D1_NUMSEQ,;       //19-Numero Sequencial
							SD7->D7_NUMERO,;       //20-Numero do CQ
							SD1->D1_QUANT,;        //21-Quantidade
							SD1->D1_TOTAL,;        //22-Preco
							0 ,; //nAtraso,;              //23-Dias de atraso
							'' ,; //SD1->D1_TES,;          //24-TES
							AllTrim(FunName()),;   //25-Origem						
							" ",;                  //26-Origem TXT	
							0}                     //27-Quantidade do Lote Original
							
							//cSeekQEK := aDadosQie[11]+aDadosQie[12]+aDadosQie[01]+aDadosQie[02]+aDadosQie[07]+aDadosQie[03]+cLoteQie+aDadosQie[19] 	  
							
						//Endif									
																	
					Endif
				Else
					msgbox("Produto não encontrado: " + SD1->D1_COD + ". Favor contatar o Administrador do Sistema.")
				Endif
				
				
				If Len(aDados) > 0
							
		   			U_qAtuMatQie(aDados,1,.F.,.F.)    //esta função está dentro do U_QIEXFUNA.PRW  (pasta Qualidade)
		   			nTamAmo := 0
					DbselectArea("QEK")
					QEK->(Dbsetorder(10)) //QEK_FILIAL+QEK_FORNEC+QEK_LOJFOR+QEK_NTFISC+QEK_SERINF+QEK_ITEMNF+QEK_TIPONF+QEK_NUMSEQ                                                                         
					If QEK->(Dbseek(xFilial("QEK") + cFornece + cLojaFor + cDocto + cSerie + SD1->D1_ITEM + SD1->D1_TIPO ))
						cChave := QEK->QEK_CHAVE
							QF5->(Dbsetorder(1)) //QF5_FILIAL + QF5_CHAVE
							If QF5->(Dbseek(xFilial("QF5") + cChave  ))
								While !QF5->(EOF()) .AND. QF5->QF5_FILIAL == xFilial("QF5") .AND. QF5->QF5_CHAVE == cChave .AND. QF5->QF5_PRODUT == SD1->D1_COD  	
									nTamAmo := QF5->QF5_TAMA1						
									QF5->(Dbskip())	 
								Enddo
							Endif
							
							DbselectArea("QEK")
							While !QEK->(EOF()) .and. QEK->QEK_FILIAL == xFilial("QEK")	.and. QEK->QEK_CHAVE == cChave .AND. QEK->QEK_PRODUT == SD1->D1_COD
								RecLock("QEK",.F.)
								QEK->QEK_TAM_AM := nTamAmo
								QEK->(MsUnlock())
								QEK->(Dbskip())			
							Enddo
					//Else
						//msgbox("não achou QEK: " + cFornece + '/' + cLojaFor + '/' + cDocto + '/' + cSerie )
					Endif
				Endif					
				aDados := {}
				
				Dbselectarea("SD1")			
				SD1->(DBSKIP())
			  Enddo			
			
		    ////////////////////////////////////////
			///IMPRESSÃO DO BOLETIM DE ENTRADA 
			////////////////////////////////////////
			U_finfoADC()
			
			nRegF1 := SF1->(RECNO())
			nF1Frete := SF1->F1_VALFRET
			DbselectArea("SD1")
			SD1->(DBSETORDER(1))
			SD1->(Dbgotop())
			SD1->(Dbseek(xFilial("SD1") + cDocto + cSerie ))
			While SD1->(!EOF()) .AND. SD1->D1_FILIAL == xFilial("SD1") .AND. Alltrim(SD1->D1_DOC) == Alltrim(cDocto) .AND. Alltrim(SD1->D1_SERIE) == Alltrim(cSerie)
				cPedido:= SD1->D1_PEDIDO
				cItem  := SD1->D1_ITEMPC
				nQuant := SD1->D1_QUANT
				nPreco := SD1->D1_VUNIT
				nTotal := SD1->D1_TOTAL
				nValipi:= SD1->D1_VALIPI
				nipi   := SD1->D1_IPI
				Aadd(aNFE, { cPedido, cItem, nQuant, nPreco, nF1Frete, nTotal, nValipi, nipi } )   //Armazena no array de itens da NF, para comparar com o pedido
				//finalidade: validar se imprime ou não o boletim de entrada (só imprimir em caso de divergência NF x Pedido)
			
				SD1->(Dbskip())
			Enddo
			//MSGBOX("REG: " + STR( SF1->( RECNO() ) )  )
				
			aNFE   := Asort( aNFE,,, { |X,Y| X[1] + X[2]  <  Y[1] + Y[2] } ) 
			
			///pesquisa no C7 o valor do frete
			///faço um loop para verificar todas as linhas de itens, pois pode ser que o usuário selecionou o botão frete qdo estava no item 1
			///e se ele adicionou os outros itens depois (nesse caso, a função do frete não gravará no acols todo)	
			cPed := ""
			nValipi := 0
			nPCvalipi := 0
			If Len(aNFE) > 0 
				cPed := aNFE[1,1]		
				nC7Frete := 0
				DbselectArea("SC7")
				SC7->(Dbsetorder(1))
				SC7->(DBGOTOP())
				If SC7->(Dbseek(xFilial("SC7") + cPed  ))
					While !SC7->(EOF()) .and. SC7->C7_FILIAL == xFilial("SC7") .and. Alltrim(SC7->C7_NUM) == Alltrim(cPed)
						If SC7->C7_VALFRET > 0
							nC7Frete := SC7->C7_VALFRET
						Endif 
						SC7->(DBSKIP())
					Enddo
				Endif
						
				DbselectArea("SC7")
				SC7->(Dbsetorder(1))
				SC7->(DBGOTOP())
				If SC7->(Dbseek(xFilial("SC7") + aNFE[1,1] + aNFE[1,2]   ))		
								
					//If lDiverg      //imprimir somente se houver divergência
						//If !lPRTAuto				
							//MsgInfo("Será Impresso o Boletim de Entrada...")
							U_ESTR008("SF1", nRegF1, 3, lDiverg, aDiverg ) //("SF1", cDocto, cSerie ) //MATR170("SF1", nRegF1, 3 )
							Pergunte("MTA140",.F.)
												
						//Endif
					//Endif
				//Else
					//msgbox("não tem pedido")
				Endif	//se encontrou SC7
			Endif
			
			
		
		Endif // tipo nf
		U_MailPrenota(cDocto, cSerie, cTipoNf)	
	Endif //se confirmou
			
ElseIf PARAMIXB[1] = 5    ///exclusão pré-nota
	
	If PARAMIXB[7] = 1    //Opção de Confirmação (1 = Confirma pré-nota; 0 = Não Confirma pré-nota)
		 cNOTAD1 := ""
		 cSERID1 := ""
		 //MSGBOX("EXCLUI NOTA: " + cDocto )
		 
		 cQuery := " select TOP 1 * from " + RetSqlName("SD1") + " SD1 " + LF
		 cQuery += " where D1_DOC = '" + Alltrim(cDocto) + "' " + LF
		 cQuery += " and D1_SERIE = '" + Alltrim(cSerie) + "' " + LF
		 cQuery += " and D1_FORNECE = '" + Alltrim(cFornece) + "' " + LF
		 cQuery += " and D1_LOJA = '" + Alltrim(cLojaFor) + "' " + LF
		 cQuery += " and SD1.D1_FILIAL = '" + xFilial("SD1") + "' " + LF
		 //cQuery += " and SD1.D_E_L_E_T_ = '' " + LF 
		 cQuery += " Order by SD1.R_E_C_N_O_ " + LF
		 MemoWrite("C:\Temp\LOCALD1.sql", cQuery)			
			If Select("SD1X") > 0
				DbSelectArea("SD1X")
				DbCloseArea()
			EndIf
			TCQUERY cQuery NEW ALIAS "SD1X"
			TCSetField( 'SD1X', "D1_DTDIGIT", "D" )
				
			SD1X->( DBGoTop() )			
			Do While !SD1X->( Eof() )
				cNOTAD1 := SD1X->D1_DOC 
		        cSERID1 := SD1X->D1_SERIE
		        cPed    := SD1X->D1_PEDIDO
		 		cIt     := SD1X->D1_ITEMPC 
		 		datadigi:= SD1X->D1_DTDIGIT
				cFornece:= SD1X->D1_FORNECE
				cLojaFor:= SD1X->D1_LOJA
		        SD1X->(DBSKIP())
		  	Enddo
		  	DbSelectArea("SD1X")
			DbCloseArea()
		  	
		 //msgbox("confirmou exclusão: " + cNOTAD1 ) 
		 
	    //cFornece:= PARAMIXB[4]
		//cLojaFor:= PARAMIXB[5]
		//SD1->(DBSETORDER(1))
	  	//SD1->(DBGOTOP())
		//If SD1->(Dbseek(xFilial("SD1") + cDocto + cSerie + cFornece + cLojaFor ))
			//datadigi := SD1->D1_DTDIGIT
		//While SD1->(!EOF()) .AND. SD1->D1_FILIAL == xFilial("SD1") .AND. Alltrim(SD1->D1_DOC) == Alltrim(cDocto) .AND. Alltrim(SD1->D1_SERIE) == Alltrim(cSerie)
		    ///LOCALIZA SD7
		    cQuery := " select TOP 1 SD7.D7_NUMERO, R_E_C_N_O_ AS REGISTRO , * from " + RetSqlName("SD7") + " SD7 " + LF
		    cQuery += " where D7_DOC = '" + Alltrim(cDocto) + "' " + LF
		    cQuery += " and D7_SERIE = '" + Alltrim(cSerie) + "' " + LF
		    cQuery += " and D7_FORNECE = '" + Alltrim(cFornece) + "' " + LF
		    cQuery += " and D7_LOJA = '" + Alltrim(cLojaFor) + "' " + LF
		    cQuery += " and SD7.D7_FILIAL = '" + xFilial("SD7") + "' " + LF
		    cQuery += " and SD7.D_E_L_E_T_ = '' " + LF 
		    cQuery += " Order by SD7.R_E_C_N_O_ " + LF
		    MemoWrite("C:\Temp\LOCALD7.sql", cQuery)			
			If Select("SD7X") > 0
				DbSelectArea("SD7X")
				DbCloseArea()
			EndIf
			TCQUERY cQuery NEW ALIAS "SD7X"
			//TCSetField( 'SD7X', "D7_DATA", "D" )
				
			SD7X->( DBGoTop() )
			
			If !SD7X->( Eof() )
				cD7Num := SD7X->REGISTRO //SD7X->D7_NUMERO 
				Dbselectarea("SD7")
				//Dbsetorder(1)    //D7_FILIAL + D7_NUMERO + D7_PRODUTO + D7_LOCAL + D7_SEQ + D7_DATA
				SD7->(DBGOTO(cD7Num))
				//If SD7->(Dbseek(xFilial("SD7") + cD7Num + SD7X->D7_PRODUTO + SD7X->D7_LOCAL + '001' + SD7X->D7_DATA ))
					While !SD7->(EOF()) .AND. SD7->D7_FILIAL == xFilial("SD7") .AND. SD7->D7_DOC == cNOTAD1 .and. SD7->D7_SERIE == cSERID1
						//msgbox("deletando SD7")
						Reclock("SD7",.F.)
						SD7->(Dbdelete())
						SD7->(MsUnlock())
						SD7->(Dbskip())
					Enddo
				//Else
				//		msgbox("não achou SD7: " + cD7Num + '/' + SD7X->D7_PRODUTO + '/' + SD7X->D7_LOCAL + '/' + SD7X->D7_SEQ + '/' + SD7X->D7_DATA )
				//Endif
				//DbselectArea("SD7X")
				//SD7X->(Dbskip())
			Endif
			DbselectArea("SD7X")
			DBCLOSEAREA()
		    
			///LOCALIZA QEP
			cQuery := " select * from " + RetSqlName("QEP") + " QEP " + LF
			cQuery += " where QEP.QEP_NTFISC = '" + Alltrim(cNOTAD1) + "' " + LF
			cQuery += " and QEP.QEP_SERINF = '" + Alltrim(cSERID1) + "' " + LF
			cQuery += " and QEP.QEP_FORNEC = '" + Alltrim(cFornece) + "' " + LF
		    cQuery += " and QEP.QEP_LOJFOR = '" + Alltrim(cLojaFor) + "' " + LF
		    cQuery += " and QEP.QEP_PEDIDO = '" + Alltrim(cPed) + "' " + LF
		    cQuery += " and QEP.QEP_FILIAL = '" + xFilial("QEP") + "' " + LF
			cQuery += " and QEP.D_E_L_E_T_ = '' " + LF
			cQuery += " Order by QEP.R_E_C_N_O_ " + LF
			MemoWrite("C:\Temp\LOCAL_QEP.sql", cQuery)
			If Select("QEPX") > 0
				DbSelectArea("QEPX")
				DbCloseArea()
			EndIf
				
			TCQUERY cQuery NEW ALIAS "QEPX"
			//TCSetField( 'SD7X', "D7_DATA", "D" )
				
			QEPX->( DBGoTop() )
				
			Do While !QEPX->( Eof() )
					
				//'1'  QEP_CODTAB
				DbselectArea("QEP")
				QEP->(Dbsetorder(2)) //QEP_FILIAL+QEP_CODTAB+QEP_FORNECE + QEP_LOJFOR+ QEP_PRODUT + QEP_NTFISC+ QEP_SERINF + QEP_ITEMNF+ QEP_TIPONF
				If QEP->(Dbseek(xFilial("QEP") + QEPX->QEP_CODTAB + QEPX->QEP_FORNECE + QEPX->QEP_LOJFOR + QEPX->QEP_PRODUT + QEPX->QEP_NTFISC + QEPX->QEP_SERINF + QEPX->QEP_ITEMNF + QEPX->QEP_TIPONF )) 
						
					//While !QEP->(EOF()) .and. QEP->QEP_FILIAL == xFilial("QEP")	.and. QEP->QEP_FORNECE == QEPX->QEP_FORNECE .and. QEP->QEP_LOJFOR == QEPX->QEP_LOJFOR;
					 //.and. QEP->QEP_NTFISC == QEPX->QEP_NTFISC .and. QEP->QEP_SERINF == QEPX->QEP_SERINF .and. QEP->QEP_ITEMNF == QEPX->QEP_ITEMNF
						//msgbox("Deletando QEP")
						RecLock("QEP",.F.)
						QEP->(Dbdelete())
						QEP->(MsUnlock())
						//QEP->(Dbskip())			
					//Enddo
				//Else
					//msgbox("não achou QEP: " + QEPX->QEP_CODTAB + '/' + QEPX->QEP_FORNECE + '/' + QEPX->QEP_LOJFOR + '/' + QEPX->QEP_PRODUT + '/' + QEPX->QEP_NTFISC + '/' + QEPX->QEP_SERINF + '/' + QEPX->QEP_ITEMNF + '/' + QEPX->QEP_TIPONF )
				Endif
						
				DbselectArea("QEPX")
				QEPX->(Dbskip())
			Enddo
			DbselectArea("QEPX")
			Dbclosearea()
				
			//U_qAtuMatQie(aDados,2,.F.,.F.)    
			cChave := ""
			//'MP0701         '
			DbselectArea("QEK")
			//QEK->(Dbsetorder(10)) //QEK_FILIAL+QEK_FORNEC+QEK_LOJFOR+QEK_NTFISC+QEK_SERINF+QEK_ITEMNF+QEK_TIPONF+QEK_NUMSEQ                                                                         
			QEK->(Dbsetorder(15)) //QEK_FILIAL + QEK_NTFISC + QEK_SERINF + QEK_FORNEC+QEK_LOJFOR + QEK_DTENTR                                                                         
			QEK->(DBGOTOP())
			//If QEK->(Dbseek(xFilial("QEK") + cFornece + cLojaFor + cDocto + cSerie )) // + SD1->D1_ITEM + SD1->D1_TIPO ))
			If QEK->(Dbseek(xFilial("QEK") + cNOTAD1 + cSERID1 + cFornece + cLojaFor + DtoS(datadigi)  ))
				cChave := QEK->QEK_CHAVE
				While !QEK->(EOF()) .and. QEK->QEK_FILIAL == xFilial("QEK")	.and. QEK->QEK_NTFISC == cNOTAD1 .and. QEK->QEK_SERINF == cSERID1
				//cChave := QEK->QEK_CHAVE
				//While !QEK->(EOF()) .and. QEK->QEK_FILIAL == xFilial("QEK")	.and. QEK->QEK_CHAVE == cChave
					//msgbox("deletando QEK")
					RecLock("QEK",.F.)
					QEK->(Dbdelete())
					QEK->(MsUnlock())
					QEK->(Dbskip())			
				Enddo
			//Else
				//msgbox("não achou QEK: " + cFornece + '/' + cLojaFor + '/' + cNOTAD1 + '/' + cSERID1 )
			Endif
			
			///LOCALIZA QF5
			cQuery := " select * from " + RetSqlName("QF5") + " QF5 " + LF
			cQuery += " where " + LF
			cQuery += " QF5.QF5_CHAVE >= '" + Alltrim(cChave) + "' " + LF
			cQuery += " and QF5.QF5_FORNEC = '" + Alltrim(cFornece) + "' " + LF
		    cQuery += " and QF5.QF5_LOJFOR = '" + Alltrim(cLojaFor) + "' " + LF
		    cQuery += " and QF5.QF5_FILIAL = '" + xFilial("QF5") + "' " + LF
			cQuery += " and QF5.D_E_L_E_T_ = '' " + LF
			cQuery += " Order by QF5.R_E_C_N_O_ " + LF
			MemoWrite("C:\Temp\LOCAL_QF5.sql", cQuery)
			If Select("QF5X") > 0
				DbSelectArea("QF5X")
				DbCloseArea()
			EndIf
				
			TCQUERY cQuery NEW ALIAS "QF5X"
			//TCSetField( 'SD7X', "D7_DATA", "D" )
				
			QF5X->( DBGoTop() )
				
			Do While !QF5X->( Eof() )
						
				DbselectArea("QF5")
				QF5->(Dbsetorder(1)) //QF5_FILIAL + QF5_CHAVE
				If QF5->(Dbseek(xFilial("QF5") + QF5X->QF5_CHAVE  ))
					//While !QF5->(EOF()) .AND. QF5->QF5_FILIAL == xFilial("QF5") .AND. QF5->QF5_CHAVE == cChave 	
						//msgbox("deletando QF5")
						RecLock("QF5",.F.)
						QF5->(Dbdelete())
						QF5->(MsUnlock())
						//QF5->(Dbskip())	 
					//Enddo
					   		
				//Else
					//msgbox("não achou QF5 chave: " + cChave)
				Endif
				DbSelectArea("QF5X")
				QF5X->(DBSKIP())
			Enddo
			DbSelectArea("QF5X")
			DbCloseArea() 
				   	
	    //Endif
	
	Endif	//se confirmou
	                   
ENDIF   //fim inclusão ou exclusão


Return


******************************
Static Function fD1_numCQ()
******************************

Local cQry 		:= "" 
Local cMax 	:= ""
Local cNumCQ := ""


cQry := " SELECT MAX(D1_NUMCQ) as NUMCQ "
cQry += " FROM " + RetSqlname("SD1") + " SD1 "
cQry += " WHERE D1_FILIAL = '" + xFilial("SD1") + "' "
//cQry += " AND SD1.D_E_L_E_T_ <>'*' "
//Memowrite("c:\Temp\MAXd1.SQL",cQry)

cQry := ChangeQuery( cQry )

If Select("MAXD1") > 0
	DbSelectArea("MAXD1")
	DbCloseArea()	
EndIf

TCQUERY cQry NEW ALIAS "MAXD1" 

MAXD1->(DbGoTop())

While !MAXD1->(EOF())
    cMax := MAXD1->NUMCQ
	MAXD1->(DBSKIP())
Enddo

//cMax := Strzero(Val(cMax) + 1,6)
cNumCQ := Soma1(cMax,Len(cMax))
//msgbox("prox. numero cq: " + cNumCQ)

DbCloseArea("MAXD1")

Return(cNumCQ)

///////////////////////////
//LOCALIZA PEDIDO NO SC7
///////////////////////////
Static Function LocalC7( cPedido, cItem )

Local cQuery := ""
Local aPedido:= {}


///LOCALIZA SC7
cQuery := " select * from " + RetSqlName("SC7") + " SC7 " + LF
cQuery += " where C7_NUM = '" + Alltrim(cPedido) + "' " + LF
cQuery += " and C7_ITEM = '" + Alltrim(cItem) + "' " + LF
cQuery += " and SC7.C7_FILIAL = '" + xFilial("SC7") + "' " + LF
cQuery += " and SC7.D_E_L_E_T_ = '' " + LF
MemoWrite("C:\Temp\LOCALC7.sql", cQuery)

		
If Select("SC7X") > 0
	DbSelectArea("SC7X")
	DbCloseArea()
EndIf
	
TCQUERY cQuery NEW ALIAS "SC7X"
//TCSetField( 'SD7X', "D7_DATA", "D" )
	
SC7X->( DBGoTop() )	
Do While !SC7X->( Eof() )
	//Aadd(aPedido, { SC7X->C7_NUM, SC7X->C7_ITEM, SC7X->C7_QUANT, SC7X->C7_PRECO } )
	Aadd(aPedido, { SC7X->C7_QUANT, SC7X->C7_PRECO } )
	DbselectArea("SD7X")
	SD7X->(Dbskip())
Enddo
DbselectArea("SD7X")
DBCLOSEAREA()

Return(aPedido)

****************************
User Function finfoADC()
****************************


Local nOpcA   := 0
//Local nPOSFRE := aScan( aHeader,{ |x| AllTrim( x[2] ) == "F1_VALFRET" } )
Local x       := 0
Local cNomeCond := Space(10)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Private nValFrete  := 0
Private cSayFret   := Space(1)
Private nValFrete  := 0
Private cCond      := Space(6)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oValFrete","oSBtn1","oSBtn2", "oSay2","oCondPag", "oNomeCond", "oSay2", "oSay3")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 088,232,292,670,"INFORMAÇÕES ADICIONAIS",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 008,004,076,212,"  Por Favor, Informe:   ", oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay3      := TSay():New( 023,117,{||"Descrição"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)
//código da cond. pagto
oSay2      := TSay():New( 032,012,{||"Cond. Pagto.   :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oCondPag   := TGet():New( 032,056,{|u| If(PCount()>0,cCond:=u,cCond)},oGrp1,045,008,'@X',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SE4","cCond",,)
//nome da cond. pagto
oNomeCond  := TGet():New( 032,117,{|| cNomeCond := fTrazCond(cCond) },oGrp1,060,008,'@!',,CLR_BLACK,CLR_LIGHTGRAY,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cNomeCond",,)
oNomeCond  :lReadOnly   := .T. 

//oSay1      := TSay():New( 052,012,{||"Valor Frete R$ (Caso Haja):"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,072,008)
oSay1      := TSay():New( 052,012,{||"Valor Frete R$ (Caso Haja):"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,024)
oValFrete  := TGet():New( 052,056,{|u| If(PCount()>0,nValFrete:=u,nValFrete)},oGrp1,060,008,'@E 99,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValFrete",,)

oSBtn1     := SButton():New( 084,140,1,,oDlg1,,"", )
oSBtn1:bAction := {|| (nOpcA := 1, oDlg1:End() )} 
  
oSBtn2     := SButton():New( 084,180,2,,oDlg1,,"", )
oSBtn2:bAction := {|| (nOpcA := 0,oDlg1:End())}  

oDlg1:Activate(,,,.T.)

If nOpcA = 1 

	If RecLock("SF1",.F.)
		SF1->F1_VALFRET := nValFrete
		SF1->F1_COND    := cCond
		SF1->(MsUnlock())
	Endif
	
Endif

Return 

**********************************
Static Function fTrazCond(cCond)
**********************************

Local cNomeC := ""


SE4->(DbsetOrder(1))
If SE4->(Dbseek(xFilial("SE4") + cCond ))
	cNomeC := SE4->E4_DESCRI
Endif

Return(cNomeC)