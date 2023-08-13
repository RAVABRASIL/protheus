#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#include "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFTMK003                               º Data ³  03/08/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatório Resumo de Ocorrências do Call Center             º±±
±±ºAutoria   ³ Flávia Rocha                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Solicitado pelo chamado 002177 - Marcelo Viana             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                                                                          							

/*

SCHEDULE CONFIGURADOR - EXECUTA TODA 2A. FEIRA - SEMANAL

Solicitado no chamado 002177:
Criar e-mail com resumo das ocorrencias do SAC. 
O mesmo contera, uma lista com tas as ocorrencias, agrupadas da seguinte forma:
SETOR PROBLEMA Quantidade problema | Qtd.Respostas Atrasadas | Qtd. Resoluções atra sadas. 
Obs. Este e-mail sera enviado para Marcelo toda semana. 
O mesmo substituir a os e-mails enviados atualmente para ele. 

Conceito: capturar todas as ocorrências incluídas no sistema utilizando data de inclusão >= dDatabase - 7 até dDatabase
Dentre estas ocorrências selecionar as que estão sem resposta (qtde),
Selecionar a qtde. das que foram respondidas e que a resolução está atrasada (utilizar data do "Resolvido" - Dt.Solução)
Se esta diferença for maior que 2 dias, está atrasada a solução.
Devido o sistema agendar o atendimento para um dia após a data solução, então coloquei que a diferença (entre dia que "flagou" 
o Resolvido e Dta. Solução) deve ser maior que 2 dias, pois no dia seguinte será suficiente para averiguar se a ocorrência 
já foi resolvida ou não. Caso não, já estará em atraso.

*/

***************************
User Function WFTMK003()
***************************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFTMK003"
  sleep( 5000 )
  conOut( "Programa WFTMK003 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  //Reset Environment  //DEIXEI NO FINAL DA FUNÇÃO
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" FUNNAME "WFTMK003"
  sleep( 5000 )
  conOut( "Programa WFTMK003 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  //Reset Environment   //DEIXEI NO FINAL DA FUNÇÃO
  
Else
  conOut( "Programa WFTMK003 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFTMK003 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

***********************
Static Function Exec()
***********************

Local cQuery	:=' '
Local LF 		:= CHR(13) + CHR(10)
Local eEmail	:= ""
Local cEmpresa  := ""   
Local cNomeSetor:= "" 
Local aDados    := {}
Local cOperador := ""
Local cNomeOp   := ""
Local cOcorrant := ""
Local nRESOLV   := 0

cQuery:=" SELECT " + LF 
	
//sintético por Setor
cQuery+= " UD_N2 as SETOR " + LF
cQuery+= " , NOMESETOR = ( Select Z46_DESCRI FROM " + RetSqlName("Z46") + " Z46 " + " " + LF
cQuery+= " Where Z46.Z46_CODIGO = SUD.UD_N2 AND  Z46.D_E_L_E_T_ = '' AND Z46.Z46_N2 = '0001' )" + LF + LF 

cQuery += " , UD_CODIGO, UD_DTINCLU , ZUD_DTENV , ZUD_DTSOL, UD_DATA , ZUD_DTRESP , UD_DTRESP " + LF
cQuery += " , UD_NRENVIO , ZUD_NRENV, UD_DTRESOL , UD_RESOLVI , UD_OPERADO  " + LF
cQuery += " , UD_DTENVIO  " + LF
cQuery += " , ZUD_DTRESO , ZUD_RESOLV " + LF
cQuery += " , UC_NFISCAL , UC_SERINF  " + LF
	
cQuery+=" FROM "
cQuery+= " "+RetSqlName("SUD") + " SUD, " + LF
cQuery+= " "+RetSqlName("ZUD") + " ZUD, " + LF
cQuery+= " "+RetSqlName("SUC") + " SUC " + LF
	
cQuery+=" Where " + LF

cQuery+=" SUD.UD_OPERADO <> '' "+LF
cQuery+=" AND SUD.UD_FILIAL = SUC.UC_FILIAL " + LF
cQuery+=" AND SUD.UD_CODIGO = SUC.UC_CODIGO " + LF
cQuery+=" AND SUD.UD_FILIAL = ZUD.ZUD_FILIAL " + LF
cQuery+=" AND SUD.UD_CODIGO = ZUD.ZUD_CODIGO " + LF
cQuery+=" AND SUD.UD_ITEM   = ZUD.ZUD_ITEM " + LF
	
//não resolvido
//cQuery += " AND SUD.UD_RESOLVI <> 'S' " + LF

//STATUS = 2 -> encerrado
//cQuery += " AND SUD.UD_STATUS <> '2' " + LF

//SETOR NÃO PODE ESTAR EM BRANCO
cQuery += " AND SUD.UD_N2 <> '' " + LF
cQuery += " AND SUD.UD_N2 not in ('0034') " + LF  //diferente do COMERCIAL

//cQuery += " AND SUD.UD_N2 = '0002' " + LF   //retirar
		
cQuery += " AND SUD.D_E_L_E_T_ = '' AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' "+LF	
cQuery += " AND ZUD.D_E_L_E_T_ = '' AND ZUD.ZUD_FILIAL = '" + xFilial("ZUD") + "' "+LF	
cQuery += " AND SUC.D_E_L_E_T_ = '' AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF	
cQuery+= "  AND SUD.UD_DTINCLU >= '" + DtoS(dDatabase - 7) + "' " + LF 
//cQuery+= "  AND SUD.UD_DTINCLU between '20121119' and '20121123'  " + LF  //retirar
cQuery += " AND SUD.UD_DTINCLU <> '' " + LF   //incluídas há uma semana atrás (ref. database)

//cQuery+=" GROUP BY " + LF 
//cQuery+= " SUD.UD_N2, SUD.UD_FILIAL " + LF
cQuery+= " ORDER BY NOMESETOR, UD_OPERADO, UD_CODIGO,UD_ITEM, ZUD.R_E_C_N_O_ " + LF //ZUD_NRENV  "+LF
MemoWrite("C:\Temp\WFTMK003_" + Alltrim(SM0->M0_CODFIL) +".SQL",cQuery)

TCQUERY cQuery NEW ALIAS "AUUX"
TCSetField("AUUX" , "UD_DATA" , "D")
TCSetField("AUUX" , "UD_DTRESOL" , "D")
TCSetField("AUUX" , "UD_DTINCLU" , "D")
TCSetField("AUUX" , "UD_DTENVIO" , "D")
TCSetField("AUUX" , "UD_DTRESP" , "D")

TCSetField("AUUX" , "ZUD_DTSOL" , "D")
TCSetField("AUUX" , "ZUD_DTRESO" , "D")
TCSetField("AUUX" , "ZUD_DTENV" , "D")
TCSetField("AUUX" , "ZUD_DTRESP" , "D")
                                                       
AUUX->(DbGoTop())

///só COMERCIAL
cQuery:=" SELECT " + LF 

cQuery+= " UD_N2 as SETOR " + LF
cQuery+= " , NOMESETOR = ( Select Z46_DESCRI FROM " + RetSqlName("Z46") + " Z46 " + " " + LF
cQuery+= " Where Z46.Z46_CODIGO = SUD.UD_N2 AND  Z46.D_E_L_E_T_ = '' AND Z46.Z46_N2 = '0001' )" + LF + LF 

cQuery += " , UD_CODIGO, UD_DTINCLU , ZUD_DTENV , ZUD_DTSOL , UD_DATA , ZUD_DTRESP , UD_DTRESP" + LF
cQuery += " , UD_NRENVIO , ZUD_NRENV, UD_DTRESOL , UD_RESOLVI , UD_OPERADO  " + LF
cQuery += " , UD_DTENVIO  " + LF
cQuery += " , ZUD_DTRESO , ZUD_RESOLV " + LF
cQuery += " , UC_NFISCAL , UC_SERINF  " + LF
	
cQuery+=" FROM "
cQuery+= " "+RetSqlName("SUD") + " SUD, " + LF
cQuery+= " "+RetSqlName("ZUD") + " ZUD, " + LF
cQuery+= " "+RetSqlName("SUC") + " SUC " + LF
	
cQuery+=" Where " + LF

//SETOR NÃO PODE ESTAR EM BRANCO
cQuery += " SUD.UD_N2 <> '' " + LF
cQuery += " AND SUD.UD_N2 in ('0034') " + LF  //somente COMERCIAL
cQuery+=" AND SUD.UD_FILIAL = SUC.UC_FILIAL " + LF
cQuery+=" AND SUD.UD_CODIGO = SUC.UC_CODIGO " + LF
cQuery+=" AND SUD.UD_FILIAL = ZUD.ZUD_FILIAL " + LF
cQuery+=" AND SUD.UD_CODIGO = ZUD.ZUD_CODIGO " + LF
cQuery+=" AND SUD.UD_ITEM   = ZUD.ZUD_ITEM " + LF


cQuery += " AND SUD.D_E_L_E_T_ = '' AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' "+LF
cQuery += " AND ZUD.D_E_L_E_T_ = '' AND ZUD.ZUD_FILIAL = '" + xFilial("ZUD") + "' "+LF
cQuery += " AND SUC.D_E_L_E_T_ = '' AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF		
cQuery+= "  AND SUD.UD_DTINCLU >= '" + DtoS(dDatabase - 7) + "' " + LF 
//cQuery+= "  AND SUD.UD_DTINCLU between '20121119' and '20121123'  " + LF //retirar
cQuery += " AND SUD.UD_DTINCLU <> '' " + LF   //incluídas há uma semana atrás (ref. database)

cQuery+= " ORDER BY NOMESETOR, UD_OPERADO, UD_CODIGO,UD_ITEM, ZUD.R_E_C_N_O_  " + LF //ZUD_NRENV  "+LF
MemoWrite("C:\Temp\_WFTMK003_" + Alltrim(SM0->M0_CODFIL) +".SQL",cQuery)

TCQUERY cQuery NEW ALIAS "AAUX"
TCSetField("AAUX" , "UD_DATA" , "D")
TCSetField("AAUX" , "UD_DTRESOL" , "D")
TCSetField("AAUX" , "UD_DTINCLU" , "D")
TCSetField("AAUX" , "UD_DTENVIO" , "D")
TCSetField("AAUX" , "UD_DTRESP" , "D")  

TCSetField("AAUX" , "ZUD_DTSOL" , "D")
TCSetField("AAUX" , "ZUD_DTRESO" , "D")
TCSetField("AAUX" , "ZUD_DTENV" , "D")
TCSetField("AAUX" , "ZUD_DTRESP" , "D")  


AAUX->(DbGoTop())

If SM0->M0_CODFIL = '01'
	cEmpresa := SM0->M0_FILIAL
Else
	cEmpresa := "Rava Embalagens - " + SM0->M0_FILIAL
Endif

n1QtRespA := 0  //1a. resposta em atraso
nRESOLV   := 0  //qtde de ocorrências resolvidas
n2QtRespA := 0  //resposta ao reenvio em atraso
nQtSolA  := 0  //soluções em atraso
nDUtil   := 0
dAux     := 0
dDtIni   := Ctod("  /  /    ")
dDtMov   := Ctod("  /  /    ")
aFeriados := { '0101' , '0421' , '0501' , '0907' , '1012' , '1115' , '1225' }
nDias    := 0
nQtde    := 0
nTotRespA := 0
cOcorrant := ""
nQtENV    := 0

If !AUUX->(EOF())		
	Do while !AUUX->(EOF())
		cOperador:= AUUX->UD_OPERADO 
		cNomeOp  := NomeOp( cOperador )
		cSetor	 := AUUX->SETOR //UD_N2
  		cNomeSetor:= AUUX->NOMESETOR //POSICIONE("Z46",1,XFILIAL("Z46")+AUUX->SETOR,"Z46_DESCRI")
  		nSEMRESP := 0      //QTDE OCORRENCIAS SEM 1A. RESPOSTA
  		n2QtRespA := 0
  		nQtSolA  := 0       //QTDE OCORRÊNCIAS COM DT. SOLUÇÃO VENCIDA SEM CUMPRIR
  		nQtde    := 0       //QTDE TOTAL DE OCORRÊNCIAS
  		dDtIni   := Ctod("  /  /    ")
		dDtMov   := Ctod("  /  /    ")
		nTotRespA:= 0
		nTOTRESOLV  := 0      //QTDE TOTAL DE OCORRÊNCIAS RESOLVIDAS
		nQtENV   := 0      //QTDE DE ENVIO
		nQtRENV  := 0      //QTDE DE REENVIOS
		
		nRESOLpRZ   := 0 //QTDE OCORRENCIAS RESOLVIDAS DENTRO DO PRAZO 5 DIAS
		nRESOLforaP := 0 //QTDE OCORRENCIAS RESOLVIDAS FORA DO PRAZO 5 DIAS  
		nDTVENCnOK  := 0 //QTDE OCORRÊNCIAS C/ DT SOLUÇÃO VENCIDA SEM CUMPRIR
		nDTVENCOK  := 0 //QTDE OCORRÊNCIAS C/ DT SOLUÇÃO A VENCER
		nDUtil      := 0 //CONTADOR DE DIAS ÚTEIS
		nAGUARDA    := 0  //QTDE OCORRENCIAS SEM RESPOSTA MAS DENTRO DO PRAZO 1 DIA
	    
		nTOTNAORESOL := 0
		nRESPFORA    := 0
		While Alltrim(AUUX->SETOR) == Alltrim(cSetor)
	    	If Alltrim(AUUX->UD_CODIGO) != Alltrim(cOcorrant)		
		 	    /////////////////////////////////////////////////
		  	    ///TOTAL qtde de ocorrências RESOLVIDAS = S
		  	    /////////////////////////////////////////////////
		  	    If Alltrim(AUUX->UD_RESOLVI) = "S"
			  	   	nTOTRESOLV++      //total ocorrências resolvidas
			  	ENDIF
			  	    
			  	IF !Empty(AUUX->UD_DATA) .AND. AUUX->UD_RESOLVI != "S"
			  	   	nTOTNAORESOL++
			  	Endif
		  	    
		  	    
		  	    ////////////////////////////////////////////////////////////////////////
		  	    ///QTDE OCORRÊNCIAS SEM RESPOSTA (FORA PRAZO PRAZO 1 DIA)
		  	    ///UD_DATA VAZIO 
		  	    ////////////////////////////////////////////////////////////////////////	  	    	  	    
			
			  	    nDUtil := 0
					dDtIni := AUUX->UD_DTINCLU
					dDtMov := dDtIni
					//qdo ainda não tem a primeira resposta...
					If Empty(AUUX->UD_DATA) 				
					  If ((dDatabase - AUUX->UD_DTINCLU) >= 2)  					 
						While dDtMov <= dDatabase
							dDtMov := dDtMov + 1 
							If Ascan(aFeriados, Substr( DtoS(dDtMov),5,4) ) == 0 								    	 	 
				    	 	 //se não for feriado.... 						
								If Dow(dDtMov) != 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= dDatabase  //verifica se não é sábado, nem domingo
									nDUtil := nDUtil + 1	
								Endif	
							Endif
						EndDo
					  Endif
					Endif			
				
					If nDUtil >= 2   //como o prazo de resposta é um dia, então coloco maior = 2, pois é a tolerância necessária para saber se atrasou
						nSEMRESP++   //CONTADOR de ocorrências sem a 1a. RESPOSTA (estourou o prazo de 1 dia)				
					Endif
			
				
				////////////////////////////////////////////////////////////////////////
		  	    ///QTDE OCORRÊNCIAS RESPONDIDA (FORA PRAZO PRAZO 1 DIA)
		  	    ///UD_DATA PREENCHIDO EM ATRASO
		  	    ////////////////////////////////////////////////////////////////////////	  	    	  	    
			   	    nDUtil := 0
					dDtIni := AUUX->UD_DTINCLU
					dDtMov := dDtIni
					DTINCLU:= AUUX->UD_DTINCLU
					DTRESP := IIF(!EMPTY(AUUX->ZUD_DTRESP), AUUX->ZUD_DTRESP, AUUX->UD_DTRESP)
				
					  If (( DTRESP - DTINCLU ) >= 2)  
						While dDtMov <= DTRESP  //CONTA DA DATA DA INCLUSÃO ATÉ O DIA EM QUE EFETUOU A RESPOSTA
							dDtMov := dDtMov + 1 
							If Ascan(aFeriados, Substr( DtoS(dDtMov),5,4) ) == 0 								    	 	 
				    	 	 //se não for feriado.... 						
								If Dow(dDtMov) != 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= DTRESP  //verifica se não é sábado, nem domingo
									nDUtil := nDUtil + 1	
								Endif	
							Endif
						EndDo
					  Endif
				
					If nDUtil >= 2   //como o prazo de resposta é um dia, então coloco maior = 2, pois é a tolerância necessária para saber se atrasou
						//MSGBOX("DIAS ÚTEIS: " + str(nDUtil) )
						nRESPFORA++   //CONTADOR de ocorrências CUJA RESPOSTA FOI REGISTRADA EM ATRASO (a 1a. RESPOSTA estourou o prazo de 1 dia)				
					Endif
				
							
				/////////////////////////////////////////////////////////////////////////////////////////////////////
		  	    /// QTDE OCORRências S/ RESOLVER (PASSOU O PRAZO) - NAO RESOLVIDAS
		  	    /////////////////////////////////////////////////////////////////////////////////////////////////////
					nDias := 0
					DTSOL := iif(!Empty(AUUX->ZUD_DTSOL), AUUX->ZUD_DTSOL, AUUX->UD_DATA)
					UDRESOLVI := AUUX->UD_RESOLVI
					
					If !Empty(DTSOL) .AND. UDRESOLVI != 'S' 
						If (dDatabase - DTSOL) >= 2				
							dDtIni := DTSOL
							dDtMov := dDtIni
							While dDtMov <= dDatabase //AUUX->UD_DTRESOL
								dDtMov := dDtMov + 1 
								If Ascan(aFeriados, Substr( Dtos(dDtMov),5,4) ) == 0 						 
					    	 	 //se não for feriado.... 						
									If Dow(dDtMov) != 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= dDatabase //verifica se não é sábado, nem domingo							
										nDias := nDias + 1	
									Endif	
								Endif
							EndDo
							If nDias >= 2 
								nDTVENCnOK++  //CONTADOR DE DT SOLUÇÃO SEM CUMPRIR
							Endif				
						Endif
					
					Endif				
					
					////////////////////////////////////////////////////////////////////////
					//CONTADOR GERAL DE NÚMERO DE OCORRÊNCIAS DO SETOR (TOTAL OCORRÊNCIAS)
					////////////////////////////////////////////////////////////////////////								   	
		       		nQtde++	   
		    		cOcorrant := AUUX->UD_CODIGO
		    		//If AUUX->UD_NRENVIO >= 1
		    			nQtENV ++
		    		//Endif
		    		If AUUX->UD_NRENVIO >= 2
		    			nQtRENV += AUUX->UD_NRENVIO - 1
		    		Endif	    		
		    	
		  Endif //se é igual a ocorrencia anterior, pula
	    	
	  		AUUX->( DBSKIP() )
		Enddo		
		Aadd(aDados, { cNomeSetor,;
					  nQtde,;
					  nTOTRESOLV,;
					  nSEMRESP,;
					  nRESOLpRZ,;
					  nRESOLforaP,;
					  nDTVENCnOK,;
					  nQtENV,;
					  nQtRENV,;
					  cSetor,;
					  nAGUARDA,;
					  cNomeOp,;
					  nDTVENCOK,;
					  nTOTNAORESOL,;
					  nRESPFORA } )  
				
	enddo
	
	
endif


AUUX->(DbCloseArea())
///SÓ COM OS OPERADORES : JANAINA, MARCOS E JOSENILDO

n1QtRespA := 0  //1a. resposta em atraso
n2QtRespA := 0  //resposta ao reenvio em atraso
nRESOLV   := 0  //qtde de ocorrências resolvidas
nQtSolA  := 0  //soluções em atraso
nDUtil   := 0
dAux     := 0
dDtIni   := Ctod("  /  /    ")
dDtMov   := Ctod("  /  /    ")
nDias    := 0
nQtde    := 0
nTotRespA := 0
cOcorrant := ""
nQtENV    := 0

If !AAUX->(EOF())		
	Do while !AAUX->(EOF())
			
		cOperador:= AAUX->UD_OPERADO 
		cNomeOp  := NomeOp( cOperador )
		cSetor	 := AAUX->SETOR //UD_N2
  		cNomeSetor:= AAUX->NOMESETOR //POSICIONE("Z46",1,XFILIAL("Z46")+AAUX->SETOR,"Z46_DESCRI")
  		nSEMRESP := 0      //QTDE OCORRENCIAS SEM 1A. RESPOSTA
  		n2QtRespA := 0
  		nQtSolA  := 0       //QTDE OCORRÊNCIAS COM DT. SOLUÇÃO VENCIDA SEM CUMPRIR
  		nQtde    := 0       //QTDE TOTAL DE OCORRÊNCIAS
  		dDtIni   := Ctod("  /  /    ")
		dDtMov   := Ctod("  /  /    ")
		nTotRespA:= 0
		nTOTRESOLV  := 0      //QTDE TOTAL DE OCORRÊNCIAS RESOLVIDAS
		nQtENV   := 0      //QTDE DE ENVIO
		nQtRENV  := 0      //QTDE DE REENVIOS
		
		nRESOLpRZ   := 0 //QTDE OCORRENCIAS RESOLVIDAS DENTRO DO PRAZO 5 DIAS
		nRESOLforaP := 0 //QTDE OCORRENCIAS RESOLVIDAS FORA DO PRAZO 5 DIAS  
		nDTVENCnOK  := 0 //QTDE OCORRÊNCIAS C/ DT SOLUÇÃO VENCIDA SEM CUMPRIR
		nDTVENCOK  := 0 //QTDE OCORRÊNCIAS C/ DT SOLUÇÃO A VENCER
		nDUtil      := 0 //CONTADOR DE DIAS ÚTEIS
		nAGUARDA    := 0  //QTDE OCORRENCIAS SEM RESPOSTA MAS DENTRO DO PRAZO 1 DIA
		
		nTOTNAORESOL:= 0
		nRESPFORA    := 0
	
		While Alltrim(AAUX->UD_OPERADO) == Alltrim(cOperador)
			If Alltrim(AAUX->UD_CODIGO) != Alltrim(cOcorrant)		
		 	    /////////////////////////////////////////////////
		  	    ///TOTAL qtde de ocorrências RESOLVIDAS = S
		  	    /////////////////////////////////////////////////
		  	    If Alltrim(AAUX->UD_RESOLVI) = "S"
			  	   	nTOTRESOLV++      //total ocorrências resolvidas
			  	ENDIF
			  	    
			  	IF !Empty(AAUX->UD_DATA) .AND. AAUX->UD_RESOLVI != "S"
			  	   	nTOTNAORESOL++
			  	Endif
		  	    
		  	    
		  	    ////////////////////////////////////////////////////////////////////////
		  	    ///QTDE OCORRÊNCIAS SEM RESPOSTA (FORA PRAZO PRAZO 1 DIA)
		  	    ///UD_DATA VAZIO 
		  	    ////////////////////////////////////////////////////////////////////////	  	    	  	    
			
			  	    nDUtil := 0
					dDtIni := AAUX->UD_DTINCLU
					dDtMov := dDtIni
					//qdo ainda não tem a primeira resposta...
					If Empty(AAUX->UD_DATA) 				
					  If ((dDatabase - AAUX->UD_DTINCLU) >= 2)  					 
						While dDtMov <= dDatabase
							dDtMov := dDtMov + 1 
							If Ascan(aFeriados, Substr( DtoS(dDtMov),5,4) ) == 0 								    	 	 
				    	 	 //se não for feriado.... 						
								If Dow(dDtMov) != 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= dDatabase  //verifica se não é sábado, nem domingo
									nDUtil := nDUtil + 1	
								Endif	
							Endif
						EndDo
					  Endif
					Endif			
				
					If nDUtil >= 2   //como o prazo de resposta é um dia, então coloco maior = 2, pois é a tolerância necessária para saber se atrasou
						nSEMRESP++   //CONTADOR de ocorrências sem a 1a. RESPOSTA (estourou o prazo de 1 dia)				
					Endif
			
				
				////////////////////////////////////////////////////////////////////////
		  	    ///QTDE OCORRÊNCIAS RESPONDIDA (FORA PRAZO PRAZO 1 DIA)
		  	    ///UD_DATA PREENCHIDO EM ATRASO
		  	    ////////////////////////////////////////////////////////////////////////	  	    	  	    
			   	    nDUtil := 0
					dDtIni := AAUX->UD_DTINCLU
					dDtMov := dDtIni
					DTINCLU:= AAUX->UD_DTINCLU
					DTRESP := IIF(!EMPTY(AAUX->ZUD_DTRESP), AAUX->ZUD_DTRESP, AAUX->UD_DTRESP)
				
					  If (( DTRESP - DTINCLU ) >= 2)  
						While dDtMov <= DTRESP  //CONTA DA DATA DA INCLUSÃO ATÉ O DIA EM QUE EFETUOU A RESPOSTA
							dDtMov := dDtMov + 1 
							If Ascan(aFeriados, Substr( DtoS(dDtMov),5,4) ) == 0 								    	 	 
				    	 	 //se não for feriado.... 						
								If Dow(dDtMov) != 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= DTRESP  //verifica se não é sábado, nem domingo
									nDUtil := nDUtil + 1	
								Endif	
							Endif
						EndDo
					  Endif
				
					If nDUtil >= 2   //como o prazo de resposta é um dia, então coloco maior = 2, pois é a tolerância necessária para saber se atrasou
						//MSGBOX("DIAS ÚTEIS: " + str(nDUtil) )
						nRESPFORA++   //CONTADOR de ocorrências CUJA RESPOSTA FOI REGISTRADA EM ATRASO (a 1a. RESPOSTA estourou o prazo de 1 dia)				
					Endif
				
							
				/////////////////////////////////////////////////////////////////////////////////////////////////////
		  	    /// QTDE OCORRências S/ RESOLVER (PASSOU O PRAZO) - NAO RESOLVIDAS
		  	    /////////////////////////////////////////////////////////////////////////////////////////////////////
					nDias := 0
					DTSOL := iif(!Empty(AAUX->ZUD_DTSOL), AAUX->ZUD_DTSOL, AAUX->UD_DATA)
					UDRESOLVI := AAUX->UD_RESOLVI
					
					If !Empty(DTSOL) .AND. UDRESOLVI != 'S' 
						If (dDatabase - DTSOL) >= 2				
							dDtIni := DTSOL
							dDtMov := dDtIni
							While dDtMov <= dDatabase //AAUX->UD_DTRESOL
								dDtMov := dDtMov + 1 
								If Ascan(aFeriados, Substr( Dtos(dDtMov),5,4) ) == 0 						 
					    	 	 //se não for feriado.... 						
									If Dow(dDtMov) != 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= dDatabase //verifica se não é sábado, nem domingo							
										nDias := nDias + 1	
									Endif	
								Endif
							EndDo
							If nDias >= 2 
								nDTVENCnOK++  //CONTADOR DE DT SOLUÇÃO SEM CUMPRIR
							Endif				
						Endif
					
					Endif				
					
					////////////////////////////////////////////////////////////////////////
					//CONTADOR GERAL DE NÚMERO DE OCORRÊNCIAS DO SETOR (TOTAL OCORRÊNCIAS)
					////////////////////////////////////////////////////////////////////////								   	
		       		nQtde++	   
		    		cOcorrant := AAUX->UD_CODIGO
		    		//If AAUX->UD_NRENVIO >= 1
		    			nQtENV ++
		    		//Endif
		    		If AAUX->UD_NRENVIO >= 2
		    			nQtRENV += AAUX->UD_NRENVIO - 1
		    		Endif	    		

		  Endif //se é igual a ocorrencia anterior, pula
	    	
	  		AAUX->( DBSKIP() )
		Enddo		
		Aadd(aDados, { cNomeSetor,;
					  nQtde,;
					  nTOTRESOLV,;
					  nSEMRESP,;
					  nRESOLpRZ,;
					  nRESOLforaP,;
					  nDTVENCnOK,;
					  nQtENV,;
					  nQtRENV,;
					  cSetor,;
					  nAGUARDA,;
					  cNomeOp,;
					  nDTVENCOK,;
					  nTOTNAORESOL,;
					  nRESPFORA } )  
	enddo
	
	
endif


AAUX->(DbCloseArea())

///
//Aadd(aDados, { cNomeSetor,  nQtde, nTotRespA, nQtSolA, cSetor, nRESOLV } )  
If Len(aDados) > 0
	oProcess:=TWFProcess():New("WFTMK003","WFTMK003")
	//oProcess:NewTask('Inicio',"\workflow\http\teste\WFTMK003.htm")
	oProcess:NewTask('Inicio',"\workflow\http\oficial\WFTMK003.htm")
	oHtml   := oProcess:oHtml
	
	oHtml:ValByName("cEmpresa" , cEmpresa )                        
	oHtml:ValByName("dDE" , DtoC(dDatabase - 7 ) ) 
	oHtml:ValByName("dATE" , DtoC(dDatabase) ) 
	//oHtml:ValByName("dDE" , "29/10/2012"  ) 
	//oHtml:ValByName("dATE" , "02/11/2012" )
	//Aadd(aDados, { cNomeSetor,  nQtde, nTOTRESOLV, nSEMRESP, nRESOLpRZ, nRESOLforaP, nDTVENCnOK, nQtENV, nQtRENV, cSetor, nAGUARDA, cNomeOp, nDTVENCOK, nTOTNAORESOL } )  
	For x := 1 to Len(aDados)
		If !Empty( aDados[x,1])
			//If UPPER(Alltrim(aDados[x,1]))  $ "MARCOS/JANAINA/JOSENILDO"
			If Alltrim(aDados[x,10]) = '0034'
		   		aadd( oHtml:ValByName("it.cSetor") , "Ass.Vendas: " + aDados[x,12] )                        
		 	Else
		 		aadd( oHtml:ValByName("it.cSetor") , aDados[x,1] )                        
		 	Endif
		   aadd( oHtml:ValByName("it.cQtd") , Str(aDados[x,2])    )      //qtde total ocorrências
		   aadd( oHtml:ValByName("it.nSEMresp") , STR(aDados[x,4])  )    //qtde ocorrências sem resposta
		   aadd( oHtml:ValByName("it.nRESPfora") , STR(aDados[x,15])  )    //qtde ocorrências dt registro resposta fora do prazo (1 dia)
		   //aadd( oHtml:ValByName("it.nTOTrESOLV") , Str(aDados[x,3])    )   //qtde ocorrências resolvidas 
		   //aadd( oHtml:ValByName("it.nTOTrESOLV") , Str(aDados[x,6])    )   //qtde ocorrências resolvidas dANI pediu pra colocar só as fora do prazo
		   
		   //aadd( oHtml:ValByName("it.nSEMresp") , STR( aDados[x,4] + aDados[x,11])  )    //qtde ocorrências sem resposta (fora prazo 1 dia + dentro prazo 1 dia)
		   //aadd( oHtml:ValByName("it.nRESOLprz" ) , STR(aDados[x,5])   )   //qtde ocorrências resolvidas dentro do prazo
		   //aadd( oHtml:ValByName("it.nRESOLforaP" ) , STR(aDados[x,6])   )   //qtde ocorrências resolvidas fora do prazo
		   aadd( oHtml:ValByName("it.nDTVENCnOK" ) , STR(aDados[x,7])   )   //qtde ocorrências sem resolver
		   //aadd( oHtml:ValByName("it.nDTVENCOK" ) , STR(aDados[x,13])   )   //qtde ocorrências c/ dt solução a vencer
		   //aadd( oHtml:ValByName("it.nQTAGUARDA" ) , STR(aDados[x,11])   )   //qtde ocorrências aguardando resposta dentro prazo 1 dia
		   //aadd( oHtml:ValByName("it.NAORESOLV") , Str(aDados[x,14])    )   //qtde ocorrências S/ RESOLVER   
		   aadd( oHtml:ValByName("it.nQTENV" ) , STR(aDados[x,8])   )   //qtde total envios
		   //aadd( oHtml:ValByName("it.nQTRENV" ) , STR(aDados[x,9])   )   //qtde total Reenvios
		Endif    
	
	Next
	_user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 eEmail := ""	 
	 //eEmail := "marcelo@ravaembalagens.com.br"
	 eEmail += ";daniela@ravaembalagens.com.br"   //31/10 Daniela solicitou que por eqto. (até ela avisar) que somente ela deve receber este email
	 //eEmail += ";humberto.filho@ravaembalagens.com.br" 	         
	 
	 //eEmail := "" //RETIRAR
	 //eEmail += ";flavia.rocha@ravaembalagens.com.br" 	//retirar
	 oProcess:cTo := eEmail
	 oProcess:cBcc:= "informatica@ravaembalagens.com.br"
	 subj	:= "Resumo das Ocorrências SAC - " + cEmpresa
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail()
	 //msgbox("Email enviado ok") 
Endif


Reset Environment
Return

***************

Static Function NomeOp( cOperado )

***************
PswOrder(1)
If PswSeek( cOperado, .T. )
   aUsuarios  := PSWRET() 					
   cNome := Alltrim(aUsuarios[1][2])     	// Nome do usuário
Endif 

return cNome
