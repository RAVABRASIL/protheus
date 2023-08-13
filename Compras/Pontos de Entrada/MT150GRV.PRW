#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ   ปฑฑ
ฑฑบPrograma  ณ MT150GRV บ Autor ณ Flแvia Rocha       บ Data ณ  27/06/13      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       LOCALIZAวรO : Function A150Grava() - Responsแvel por efetuar a  นฑฑ 
ฑฑบ          atualiza็ใo das cota็๕es de compra. APOS GRAVACAO DO SC8        นฑฑ
ฑฑบ			 EM QUE PONTO : Apos a atualizacao do SC8 (Cotacoes)             บฑฑ 
ฑฑบ          Este ponto de entrada serแ usado para enviar um email a         บฑฑ 
ฑฑบ          Logํstica, avisando que deve ser atualizado o valor e prazo     บฑฑ 
ฑฑบ          pagamento do Frete                                              บฑฑ 
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

/*


MT150GRV ( < PARAMIXB> ) --> Nil
Parโmetros:
	Nome			Tipo			Descri็ใo			
	PARAMIXB		Vetor			PARAMIXB[1] = 3 situa็ใo em inclusใo de cota็ใo ; 
									PARAMIXB[1] = 4 situa็ใo em proposta de cota็ใo
*/

**********************
USER FUNCTION MT150GRV
**********************

Local nOpc  := PARAMIXB[1]
Local cNumCot  := SC8->C8_NUM
Local cTipoFre := SC8->C8_TPFRETE
Local cITCOT   := SC8->C8_ITEM
Local cProd    := SC8->C8_PRODUTO
Local cTiProd  := SC8->C8_TIPROD
Local nQuant   := SC8->C8_QUANT
Local cUM	   := SC8->C8_UM
Local nPreco   := SC8->C8_PRECO
local nValIpi  := SC8->C8_VALIPI
Local nTotal   := 0
Local dPREVENT := SC8->C8_DATPRF 
Local cCondPG  := SC8->C8_COND //condi็ใo de pagto da cota็ใo (produtos)
Local nValFRE  := 0
Local nPRZPFRE := 0
Local cForn    := SC8->C8_FORNECE
Local cLJ      := SC8->C8_LOJA 
Local cNomeFor := Posicione('SA2',1,xFilial("SA2")+cForn + cLJ,"A2_NREDUZ") 
Local cParMail  := GETMV("RV_COMC013") 
Local PJ      		:= 0
Local nTOTALit		:= 0  
Local nPrazoit 		:= "" //prazo pagto da cota็ใo
Local nCIVP    		:= 0
Local nCFVP    		:= 0
Local nCUSTOTVP 	:= 0  
Local nPrzPONDit	:= 0 
Local nMenorCSTVP 	:= 0 
Local nPECUSTO		:= 0
Local nPACUSTO		:= 0 
Local nPEPRAZO		:= 0
Local nPAPRAZO		:= 0
Local nFatMult		:= 0
Local nPrazoFR      := 0 				//PRAZO MษDIO (DIAS) PAGTO FRETE
Local cPrzPFre      := SC8->C8_CNDPFRE //c๓digo da condi็ใo pagto frete
Local nValFreit     := SC8->C8_VALFRE  //VALOR FRETE ITEM 
Local nICMFRE       := SC8->C8_ICMFRE  //aliq. ICM Frete
Local nValICMFRE    := 0
If nOpc = 3  //se op็ใo = "Atualiza"
	If RecLock("SC8", .F.)
		nCIVP := 0
		nCFVP := 0
		nTOTALit := 0
		nCUSTOTVP:= 0
		nValICMFRE  := 0
		nValICMFRE  := Round(nValFreit * (nICMFRE / 100),2)  //calcula o valor do ICM do Frete
		///////////////////////////////////////////////////////////////
		////FR - 23/07/13                           
		////ATUALIZA O REGISTRO CORRENTE, CAMPOS PARA DECISรO COMPRA
		//////////////////////////////////////////////////////////////
		
		////////////////////////////////////////////
		////cแlculo do custo item a valor presente: 
		////////////////////////////////////////////
		SE4->(Dbsetorder(1))
		SE4->(Dbseek(xFilial("SE4") + SC8->C8_COND))
		nPrazoit 	:= SE4->E4_PRZMED	//PRAZO PAGTO ITEM
		nElevado	:= nPrazoIT / 30 
		SX5->(Dbsetorder(1))
		SX5->(Dbseek(xFilial("SX5") + 'PJ' + 'JURMES' ))
		PJ := VAL(ALLTRIM(SX5->X5_DESCRI))
		nResult		:= ( 1 + ( PJ / 100) ) ^ nElevado
		
		nTOTALit    := 	(SC8->C8_PRECO * SC8->C8_QUANT) + SC8->C8_VALICM // + SC8->C8_VALIPI //FR - 31/07/13 solicitado por Orley retirar o IPI
		nCIVP       := ( nTOTALit / nResult ) // CUSTO ITEM VALOR PRESENTE = pre็o unitแrio / ( ( 1 + taxa juros m๊s) ^ ( prazo / 30 dias) )
		///fim do cแlculo CI                         
		
		/////////////////////////////////////////////			
		///CมLCULO DO CUSTO FRETE A VALOR PRESENTE
		////////////////////////////////////////////
		SE4->(DbSetorder(1))
		If SE4->(Dbseek(xFilial("SE4") + cPrzPFre ))
			nPrazoFR := SE4->E4_PRZMED
		Endif	
		nElevado 	:= nPrazoFR / 30
		nResult 	:= (  1 + (PJ / 100) ) ^ nElevado
		nCFVP		:= ( nValFreit / nResult ) + nValICMFRE  //FR - 08/08/13 - SOLICITADO POR ORLEY EM 31/07/13, incluir o ICM no Frete , pois ้ cobrado na NF conhecimento
		// CUSTO FRETE VALOR PRESENTE
		// nCFVP = ( valor frete / ( ( 1 + taxa juros m๊s) ^ ( prazo / 30 dias) ) ) + Valor ICM
		//fim cแlculo do CUSTO FRETE VP
				
		///CUSTO TOTAL DO ITEM A VP:
		nCUSTOTVP 		:= nCIVP + nCFVP  //CUSTO ITEM A VP + CUSTO FRETE A VP
	
		////////////////////////////////////////////////
		///CมLCULO DO PRAZO MษDIO PONDERADO DE ENTREGA: 
		////////////////////////////////////////////////
		nPrzPONDit 		:= ( (nTOTALit * nPrazoit) + ( nValFreit * nPrazoFR) ) / ( nTOTALit + nValFreit)
		//fim do cแlculo do prazo m้dio entrega ponderado
		
		/////////////////////////////////////////////////////////				
		///cแlculo do fator multiplicador do Custo Equivalente   
		/////////////////////////////////////////////////////////
		nMenorCSTVP 	:= fMenor(cNumCot) //captura valor do item que possuir menor Custo VP , dentre os fornecedores da cota็ใo selecionada
		nPECUSTO	:= Round( (nCUSTOTVP / nMenorCSTVP) - 1 , 4 )
		nPACUSTO	:= Round( (nCUSTOTVP / nMenorCSTVP) , 4 )	
		nMaiorPRZPON:= 0
		nMaiorPRZPON	:= fMaior(cNumCot) 		//CAPTURA O MAIOR PRAZO PONDERADO
		If nMaiorPRZPON <= 0
			nMaiorPRZPON := nPrazoit
		Endif
		nPEPRAZO		:= 1 - nPECUSTO
		nPAPRAZO		:= nMaiorPRZPON / nPrzPONDit  //MAIOR PRAZO MษDIO PONDERADO / PRAZO MษDIO PONDERADO DO ITEM
		nFatMult		:= Round( ( (nPECUSTO * nPACUSTO) + (nPEPRAZO * nPAPRAZO) ) / ( nPECUSTO + nPEPRAZO) , 4 )
		///fim do cแlculo fator multiplicador do CT
					
		//SC8->C8_VALFRE  := nValFreit      
		//SC8->C8_CNDPFRE := cPrzPFre       
		SC8->C8_PRZPFRE := nPrazoFR
		//SC8->C8_TRANSP  := cTransp
		//SC8->C8_PALLET  := cPallet
					
		SC8->C8_CUSTIVP := nCIVP	
		SC8->C8_CUSTFVP := nCFVP
		SC8->C8_PRZPOND := nPrzPONDit
		SC8->C8_CTEQUIV := nCUSTOTVP * nFatMult
		SC8->C8_PECUSTO := nPECUSTO
		SC8->C8_PACUSTO := nPACUSTO
		SC8->C8_PEPRAZO := nPEPRAZO
		SC8->C8_PAPRAZO := nPAPRAZO
		SC8->C8_FTEQUIV := nFatMult
		//SC8->C8_KGTOTAL := nTOTKG2
	
		SC8->(MsUnlock())
	
	Endif		
	///FIM DA ATUALIZAวรO DO REGISTRO CORRENTE
	
	////INอCIO DA ATUALIZAวรO DE TODOS OS FORNECEDORES DA COTAวรO
	////ESTE LOOP PARA TODOS ษ NECESSมRIO, POIS, COM A MษDIA PONDERADA,
	////PRECISO TER OS DADOS DE TODOS OS FORNECEDORES DA COTAวรO
	nCIVP    		:= 0
	nCFVP    		:= 0
	nCUSTOTVP 	:= 0  
	nPrzPONDit	:= 0 
	nMenorCSTVP 	:= 0 
	nPECUSTO		:=  0
	nPACUSTO		:= 0 
	nPEPRAZO		:= 0
	nPAPRAZO		:= 0
	nFatMult		:= 0
	nPrazoFR      := 0 //PRAZO PAGTO FRETE
	nValFreit     := 0 //VALOR FRETE ITEM 
	
	SC8->(Dbsetorder(1))                    
	SC8->(Dbgotop())
	SC8->(Dbseek(xFilial("SC8") + cNumCot ))
		///////////////////////////////////////////////////////////////
		////FR - 23/07/13                           
		////ATUALIZA TODOS OS REGISTROS DA COTAวรO, CAMPOS PARA DECISรO COMPRA
		//////////////////////////////////////////////////////////////
		While !SC8->(EOF()) .and. SC8->C8_FILIAL == xFilial("SC8") .and. SC8->C8_NUM == cNumCot
			nCIVP := 0
			nCFVP := 0
			nTOTALit := 0
			nCUSTOTVP:= 0
		    nICMFRE   := SC8->C8_ICMFRE //aliquota icm frete
		    nValFreit := SC8->C8_VALFRE
		    
		    nValICMFRE  := 0
			nValICMFRE  := Round(nValFreit * (nICMFRE / 100),2)  //calcula o valor do ICM do Frete
			
		    nPrazoFR  := SC8->C8_PRZPFRE
			SE4->(Dbsetorder(1))
			SE4->(Dbseek(xFilial("SE4") + SC8->C8_COND))
					
			////cแlculo do custo item a valor presente:
			nPrazoit 	:= SE4->E4_PRZMED	//PRAZO PAGTO ITEM
			nElevado	:= nPrazoIT / 30
			SX5->(Dbsetorder(1))
			SX5->(Dbseek(xFilial("SX5") + 'PJ' + 'JURMES' ))
			PJ := VAL(ALLTRIM(SX5->X5_DESCRI)) 
			nResult		:= ( 1 + ( PJ / 100) ) ^ nElevado
			nTOTALit    := 	(SC8->C8_PRECO * SC8->C8_QUANT)  + SC8->C8_VALICM // + SC8->C8_VALIPI //FR - 31/07/13 solicitado por Orley retirar o IPI
			nCIVP       := ( nTOTALit / nResult ) // CUSTO ITEM VALOR PRESENTE = pre็o unitแrio / ( ( 1 + taxa juros m๊s) ^ ( prazo / 30 dias) )
			///fim do cแlculo CI                          
			
			//////////////////////////////////////////////		
			///CมLCULO DO CUSTO FRETE A VALOR PRESENTE  //o frete quem atualiza ้ a logํstica na rotina COMC013		
			//////////////////////////////////////////////
			If nPrazoFR > 0
				nElevado 	:= nPrazoFR / 30
			Else
				nPrazoFR := 30
				nElevado := nPrazoFR / 30
			Endif
					
			nResult 	:= ( 1 + ( PJ / 100) ) ^ nElevado
			nCFVP		:= ( nValFreit / nResult ) + nValICMFRE	//FR - 08/08/13 - SOLICITADO POR ORLEY EM 31/07/13, incluir o ICM no Frete , pois ้ cobrado na NF conhecimento
			// CUSTO FRETE VALOR PRESENTE
			// nCFVP = ( valor frete / ( ( 1 + taxa juros m๊s) ^ ( prazo / 30 dias) ) ) + Valor ICM
			//fim cแlculo do CUSTO FRETE VP
			
			////////////////////////////		
			///CUSTO TOTAL DO ITEM A VP:
			////////////////////////////
			nCUSTOTVP 		:= nCIVP   + nCFVP 
			
			/////////////////////////////////////////////////		
			///CมLCULO DO PRAZO MษDIO PONDERADO DE ENTREGA:  
			/////////////////////////////////////////////////
			nPrzPONDit 		:= ( (nTOTALit * nPrazoit) + ( nValFreit * nPrazoFR) ) / ( nTOTALit + nValFreit)
			//fim do cแlculo do prazo m้dio entrega ponderado
			
			///////////////////////////////////////////////////////		
			///cแlculo do fator multiplicador do Custo Equivalente 
			///////////////////////////////////////////////////////
			nMenorCSTVP 	:= fMenor(cNumCot) //captura valor do item que possuir menor Custo VP , dentre os fornecedores da cota็ใo selecionada
			nPECUSTO	:= Round( (nCUSTOTVP / nMenorCSTVP) - 1 , 4)
			nPACUSTO	:= Round( (nCUSTOTVP / nMenorCSTVP) , 4 )	
			nMaiorPRZPON:= 0
			nMaiorPRZPON	:= fMaior(cNumCot) 		//CAPTURA O MAIOR PRAZO PONDERADO
			If nMaiorPRZPON <= 0
				nMaiorPRZPON := nPrazoit
			Endif
			nPEPRAZO		:= 1 - nPECUSTO
			nPAPRAZO		:= nMaiorPrzPON / nPrzPONDit  //MAIOR PRAZO MษDIO PONDERADO / PRAZO MษDIO PONDERADO DO ITEM
			nFatMult		:= Round( ( (nPECUSTO * nPACUSTO) + (nPEPRAZO * nPAPRAZO) ) / ( nPECUSTO + nPEPRAZO)  , 4 )
			///fim do cแlculo fator multiplicador do CT
					
			RecLock("SC8", .F.)    
			//SC8->C8_VALFRE  := nValFreit  
			//SC8->C8_PRZPFRE := nPrazoFR   
			SC8->C8_CUSTIVP := nCIVP	
			SC8->C8_CUSTFVP := nCFVP    
			SC8->C8_PRZPOND := nPrzPONDit
			SC8->C8_CTEQUIV := nCUSTOTVP * nFatMult		
			SC8->C8_PECUSTO := nPECUSTO
			SC8->C8_PACUSTO := nPACUSTO
			SC8->C8_PEPRAZO := nPEPRAZO
			SC8->C8_PAPRAZO := nPAPRAZO
			SC8->C8_FTEQUIV := nFatMult

			SC8->(MsUnlock())

			SC8->(DBSKIP())
		Enddo
			
		//FR - 18/07/13 - Solicitado por Marcelo
	    
	    //////////////////////////////////////////////
		///ENVIA EMAIL PARA LOGอSTICA ATUALIZAR FRETE
		///Sำ FAZ QDO O TIPO FRETE FOR FOB 
		///E OS PRODUTOS FOREM TIPO: AC, ME, MP, MS 
		/////////////////////////////////////////////
		//If cTiProd $ 'AC/ME/MP/MS'  //s๓ faz para estes tipos de produtos
		//FR - 17/04/14 - ALTERADO PARA ATENDER AO CHAMADO #39 - INCLUIR TODOS OS TIPOS DE PRODUTOS QUE PRECISEM DE FRETE PARA CHEGAR NA RAVA
		If cTiProd != "PA"
	  		If cTipoFre = "F" //se o FRETE for FOB, Envia E-mail para a logํstica, para a mesma atualizar valor e prazo pagto Frete:
	            If nPreco > 0 .and. !Empty(cCondPG)
					//Alert("Envia Email Logํstica")
					oProcess:=TWFProcess():New("MT150GRV","MT150GRV")
					oProcess:NewTask('Inicio',"\workflow\http\oficial\MT150GRV.htm")
					oHtml   := oProcess:oHtml
					
					 cCabeca := "Aviso de Nova Cota็ใo Para Atualizar Frete"
					 cMsg    := "Informamos que a Seguinte Cota็ใo Necessita de Sua Atualiza็ใo de Valor e Prazo Pagto Frete: "
				
					aadd( oHtml:ValByName("it.cCOT")     , cNumCOT )                                            
					aadd( oHtml:ValByName("it.cNomeFor")     , cNomeFor )                                            
				   	aadd( oHtml:ValByName("it.cItem") , cITCOT )    
				   	aadd( oHtml:ValByName("it.cProd") , cProd )    
				   	aadd( oHtml:ValByName("it.cTiProd") , cTiProd )    
				   	aadd( oHtml:ValByName("it.nQt")    , Transform(nQuant , "@E 9,999,999.99") )    
				   	aadd( oHtml:ValByName("it.cUM") , cUM )    
				   	aadd( oHtml:ValByName("it.nValUni" )   , Transform(nPreco, "@E 999,999,999.99") ) 
				   	aadd( oHtml:ValByName("it.nValTot")     , Transform( (nQuant * nPreco)+nValIpi , "@E 999,999,999.99") )       
				   	aadd( oHtml:ValByName("it.dPrev")     , DtoC(dPREVENT) )       
				   	aadd( oHtml:ValByName("it.cTPFRE")     , iif(cTipoFre == "F" , "FOB" , iif(cTipoFre = "C" , "CIF" , "OUTROS") ) )       
				   	aadd( oHtml:ValByName("it.nValFRE")     , Transform(nValFRE, "@E 999,999,999.99") )       
				   	aadd( oHtml:ValByName("it.nPRZPFRE")     , Transform(nPRZPFRE, "@E 9999") + " Dias ?" )  
				   	aadd( oHtml:ValByName("it.nPeso" )   , Transform(Posicione( "SB1", 1, xFilial("SB1") +cProd , "B1_PESOR" ), "@E 999,999,999.9999") )      
				   	
					cNome := ""		// Nome do usuแrio comprador
					cMail := ""     // e-mail do usuแrio comprador
					cDepto:= ""
					PswOrder(1)
					If PswSeek( __CUSERID, .T. )
			   			aUsers := PSWRET() 						// Retorna vetor com informa็๕es do usuแrio				   
					   	cNome:= Alltrim(aUsers[1][4])		// Nome completo do usuแrio logado
					   	cMail:= Alltrim(aUsers[1][14])     // e-mail do usuแrio logado
						cDepto:= aUsers[1][12]  //Depto do usuแrio logado
					
					Endif
					oHtml:ValByName("CABECA"  , cCabeca )	//tํtulo aviso
					oHtml:ValByName("cMSG"  , cMsg )	//texto do aviso
					oHtml:ValByName("cUser"  , cNome )	//nome do comprador
					oHtml:ValByName("cDepto"    , cDepto )	//nome do Depto
					oHtml:ValByName("cMail"    , cMail )	//email
				
					 eEmail := ""
					 eEmail := cMail 
					 eEmail += ";" + cParMail
					 
					 //eEmail := ""  //RETIRAR
					 //eEmail += ";flavia.rocha@ravaembalagens.com.br"
					 oProcess:cTo := eEmail 
					 subj	:= "COTAวรO COMPRAS - Favor Registrar Frete - " + cNomeFor
					 oProcess:cSubject  := subj
					 oProcess:Start()
					 WfSendMail()
				Endif //se preco > 0 e cond.pagto preenchida
	  		//Else
		  		//Alert("Sem A็ใo")
	  		Endif //tipo frete
  		Endif  //tipo produto
Endif //nOpc

Return nil                                



****************************
Static Function fMenor(cCot)
****************************

Local cQuery := ""
Local nAux   := 0

cQuery := "Select MIN(C8_CUSTIVP + C8_CUSTFVP) MENORCT from " + RetSqlname("SC8") + " SC8 " + CHR(13) + CHR(10)
cQuery += " Where C8_NUM = '" + Alltrim(cCot) + "' "  + CHR(13) + CHR(10)
cQuery += " and (C8_CUSTIVP + C8_CUSTFVP) > 0 " + CHR(13) + CHR(10)
cQuery += " and C8_FILIAL = '" + xFilial("SC8") + "' AND D_E_L_E_T_ = '' "  + CHR(13) + CHR(10)

Memowrite("C:\TEMP\FMENOR.SQL",cQuery) 
	
If Select("MENOR") > 0
	DbSelectArea("MENOR")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "MENOR" 
MENOR->(DbGoTop())
If !MENOR->(EOF())
	While MENOR->(!EOF())		
		nAux := MENOR->MENORCT
		MENOR->(Dbskip())
	Enddo
Endif
Return(nAux)


****************************
Static Function fMaior(cCot)
****************************

Local cQuery := ""
Local nAux   := 0

cQuery := "Select Max(C8_PRZPOND) MAIORPRZ from " + RetSqlname("SC8") + " SC8 " + CHR(13) + CHR(10)
cQuery += " Where C8_NUM = '" + Alltrim(cCot) + "' "  + CHR(13) + CHR(10)
cQuery += " and (C8_PRZPOND) > 0 " + CHR(13) + CHR(10)
cQuery += " and C8_FILIAL = '" + xFilial("SC8") + "' AND D_E_L_E_T_ = '' "  + CHR(13) + CHR(10)
Memowrite("C:\TEMP\FMAIOR.SQL",cQuery) 
	
If Select("MAIOR") > 0
	DbSelectArea("MAIOR")
	DbCloseArea()	
EndIf

TCQUERY cQuery NEW ALIAS "MAIOR" 
MAIOR->(DbGoTop())
If !MAIOR->(EOF())
	While MAIOR->(!EOF())		
		nAux := MAIOR->MAIORPRZ
		MAIOR->(Dbskip())
	Enddo
Endif
Return(nAux)
