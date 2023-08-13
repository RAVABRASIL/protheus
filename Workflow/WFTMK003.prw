#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#include "TbiConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WFTMK003                               � Data �  03/08/2011 ���
�������������������������������������������������������������������������͹��
���Descricao � Relat�rio Resumo de Ocorr�ncias do Call Center             ���
���Autoria   � Fl�via Rocha                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Solicitado pelo chamado 002177 - Marcelo Viana             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                                                                                                          							

/*

SCHEDULE CONFIGURADOR - EXECUTA TODA 2A. FEIRA - SEMANAL

Solicitado no chamado 002177:
Criar e-mail com resumo das ocorrencias do SAC. 
O mesmo contera, uma lista com tas as ocorrencias, agrupadas da seguinte forma:
SETOR PROBLEMA Quantidade problema | Qtd.Respostas Atrasadas | Qtd. Resolu��es atra sadas. 
Obs. Este e-mail sera enviado para Marcelo toda semana. 
O mesmo substituir a os e-mails enviados atualmente para ele. 

Conceito: capturar todas as ocorr�ncias inclu�das no sistema utilizando data de inclus�o >= dDatabase - 7 at� dDatabase
Dentre estas ocorr�ncias selecionar as que est�o sem resposta (qtde),
Selecionar a qtde. das que foram respondidas e que a resolu��o est� atrasada (utilizar data do "Resolvido" - Dt.Solu��o)
Se esta diferen�a for maior que 2 dias, est� atrasada a solu��o.
Devido o sistema agendar o atendimento para um dia ap�s a data solu��o, ent�o coloquei que a diferen�a (entre dia que "flagou" 
o Resolvido e Dta. Solu��o) deve ser maior que 2 dias, pois no dia seguinte ser� suficiente para averiguar se a ocorr�ncia 
j� foi resolvida ou n�o. Caso n�o, j� estar� em atraso.

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
  //Reset Environment  //DEIXEI NO FINAL DA FUN��O
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" FUNNAME "WFTMK003"
  sleep( 5000 )
  conOut( "Programa WFTMK003 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  //Reset Environment   //DEIXEI NO FINAL DA FUN��O
  
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
	
//sint�tico por Setor
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
	
//n�o resolvido
//cQuery += " AND SUD.UD_RESOLVI <> 'S' " + LF

//STATUS = 2 -> encerrado
//cQuery += " AND SUD.UD_STATUS <> '2' " + LF

//SETOR N�O PODE ESTAR EM BRANCO
cQuery += " AND SUD.UD_N2 <> '' " + LF
cQuery += " AND SUD.UD_N2 not in ('0034') " + LF  //diferente do COMERCIAL

//cQuery += " AND SUD.UD_N2 = '0002' " + LF   //retirar
		
cQuery += " AND SUD.D_E_L_E_T_ = '' AND SUD.UD_FILIAL = '" + xFilial("SUD") + "' "+LF	
cQuery += " AND ZUD.D_E_L_E_T_ = '' AND ZUD.ZUD_FILIAL = '" + xFilial("ZUD") + "' "+LF	
cQuery += " AND SUC.D_E_L_E_T_ = '' AND SUC.UC_FILIAL = '" + xFilial("SUC") + "' "+LF	
cQuery+= "  AND SUD.UD_DTINCLU >= '" + DtoS(dDatabase - 7) + "' " + LF 
//cQuery+= "  AND SUD.UD_DTINCLU between '20121119' and '20121123'  " + LF  //retirar
cQuery += " AND SUD.UD_DTINCLU <> '' " + LF   //inclu�das h� uma semana atr�s (ref. database)

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

///s� COMERCIAL
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

//SETOR N�O PODE ESTAR EM BRANCO
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
cQuery += " AND SUD.UD_DTINCLU <> '' " + LF   //inclu�das h� uma semana atr�s (ref. database)

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
nRESOLV   := 0  //qtde de ocorr�ncias resolvidas
n2QtRespA := 0  //resposta ao reenvio em atraso
nQtSolA  := 0  //solu��es em atraso
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
  		nQtSolA  := 0       //QTDE OCORR�NCIAS COM DT. SOLU��O VENCIDA SEM CUMPRIR
  		nQtde    := 0       //QTDE TOTAL DE OCORR�NCIAS
  		dDtIni   := Ctod("  /  /    ")
		dDtMov   := Ctod("  /  /    ")
		nTotRespA:= 0
		nTOTRESOLV  := 0      //QTDE TOTAL DE OCORR�NCIAS RESOLVIDAS
		nQtENV   := 0      //QTDE DE ENVIO
		nQtRENV  := 0      //QTDE DE REENVIOS
		
		nRESOLpRZ   := 0 //QTDE OCORRENCIAS RESOLVIDAS DENTRO DO PRAZO 5 DIAS
		nRESOLforaP := 0 //QTDE OCORRENCIAS RESOLVIDAS FORA DO PRAZO 5 DIAS  
		nDTVENCnOK  := 0 //QTDE OCORR�NCIAS C/ DT SOLU��O VENCIDA SEM CUMPRIR
		nDTVENCOK  := 0 //QTDE OCORR�NCIAS C/ DT SOLU��O A VENCER
		nDUtil      := 0 //CONTADOR DE DIAS �TEIS
		nAGUARDA    := 0  //QTDE OCORRENCIAS SEM RESPOSTA MAS DENTRO DO PRAZO 1 DIA
	    
		nTOTNAORESOL := 0
		nRESPFORA    := 0
		While Alltrim(AUUX->SETOR) == Alltrim(cSetor)
	    	If Alltrim(AUUX->UD_CODIGO) != Alltrim(cOcorrant)		
		 	    /////////////////////////////////////////////////
		  	    ///TOTAL qtde de ocorr�ncias RESOLVIDAS = S
		  	    /////////////////////////////////////////////////
		  	    If Alltrim(AUUX->UD_RESOLVI) = "S"
			  	   	nTOTRESOLV++      //total ocorr�ncias resolvidas
			  	ENDIF
			  	    
			  	IF !Empty(AUUX->UD_DATA) .AND. AUUX->UD_RESOLVI != "S"
			  	   	nTOTNAORESOL++
			  	Endif
		  	    
		  	    
		  	    ////////////////////////////////////////////////////////////////////////
		  	    ///QTDE OCORR�NCIAS SEM RESPOSTA (FORA PRAZO PRAZO 1 DIA)
		  	    ///UD_DATA VAZIO 
		  	    ////////////////////////////////////////////////////////////////////////	  	    	  	    
			
			  	    nDUtil := 0
					dDtIni := AUUX->UD_DTINCLU
					dDtMov := dDtIni
					//qdo ainda n�o tem a primeira resposta...
					If Empty(AUUX->UD_DATA) 				
					  If ((dDatabase - AUUX->UD_DTINCLU) >= 2)  					 
						While dDtMov <= dDatabase
							dDtMov := dDtMov + 1 
							If Ascan(aFeriados, Substr( DtoS(dDtMov),5,4) ) == 0 								    	 	 
				    	 	 //se n�o for feriado.... 						
								If Dow(dDtMov) != 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= dDatabase  //verifica se n�o � s�bado, nem domingo
									nDUtil := nDUtil + 1	
								Endif	
							Endif
						EndDo
					  Endif
					Endif			
				
					If nDUtil >= 2   //como o prazo de resposta � um dia, ent�o coloco maior = 2, pois � a toler�ncia necess�ria para saber se atrasou
						nSEMRESP++   //CONTADOR de ocorr�ncias sem a 1a. RESPOSTA (estourou o prazo de 1 dia)				
					Endif
			
				
				////////////////////////////////////////////////////////////////////////
		  	    ///QTDE OCORR�NCIAS RESPONDIDA (FORA PRAZO PRAZO 1 DIA)
		  	    ///UD_DATA PREENCHIDO EM ATRASO
		  	    ////////////////////////////////////////////////////////////////////////	  	    	  	    
			   	    nDUtil := 0
					dDtIni := AUUX->UD_DTINCLU
					dDtMov := dDtIni
					DTINCLU:= AUUX->UD_DTINCLU
					DTRESP := IIF(!EMPTY(AUUX->ZUD_DTRESP), AUUX->ZUD_DTRESP, AUUX->UD_DTRESP)
				
					  If (( DTRESP - DTINCLU ) >= 2)  
						While dDtMov <= DTRESP  //CONTA DA DATA DA INCLUS�O AT� O DIA EM QUE EFETUOU A RESPOSTA
							dDtMov := dDtMov + 1 
							If Ascan(aFeriados, Substr( DtoS(dDtMov),5,4) ) == 0 								    	 	 
				    	 	 //se n�o for feriado.... 						
								If Dow(dDtMov) != 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= DTRESP  //verifica se n�o � s�bado, nem domingo
									nDUtil := nDUtil + 1	
								Endif	
							Endif
						EndDo
					  Endif
				
					If nDUtil >= 2   //como o prazo de resposta � um dia, ent�o coloco maior = 2, pois � a toler�ncia necess�ria para saber se atrasou
						//MSGBOX("DIAS �TEIS: " + str(nDUtil) )
						nRESPFORA++   //CONTADOR de ocorr�ncias CUJA RESPOSTA FOI REGISTRADA EM ATRASO (a 1a. RESPOSTA estourou o prazo de 1 dia)				
					Endif
				
							
				/////////////////////////////////////////////////////////////////////////////////////////////////////
		  	    /// QTDE OCORR�ncias S/ RESOLVER (PASSOU O PRAZO) - NAO RESOLVIDAS
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
					    	 	 //se n�o for feriado.... 						
									If Dow(dDtMov) != 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= dDatabase //verifica se n�o � s�bado, nem domingo							
										nDias := nDias + 1	
									Endif	
								Endif
							EndDo
							If nDias >= 2 
								nDTVENCnOK++  //CONTADOR DE DT SOLU��O SEM CUMPRIR
							Endif				
						Endif
					
					Endif				
					
					////////////////////////////////////////////////////////////////////////
					//CONTADOR GERAL DE N�MERO DE OCORR�NCIAS DO SETOR (TOTAL OCORR�NCIAS)
					////////////////////////////////////////////////////////////////////////								   	
		       		nQtde++	   
		    		cOcorrant := AUUX->UD_CODIGO
		    		//If AUUX->UD_NRENVIO >= 1
		    			nQtENV ++
		    		//Endif
		    		If AUUX->UD_NRENVIO >= 2
		    			nQtRENV += AUUX->UD_NRENVIO - 1
		    		Endif	    		
		    	
		  Endif //se � igual a ocorrencia anterior, pula
	    	
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
///S� COM OS OPERADORES : JANAINA, MARCOS E JOSENILDO

n1QtRespA := 0  //1a. resposta em atraso
n2QtRespA := 0  //resposta ao reenvio em atraso
nRESOLV   := 0  //qtde de ocorr�ncias resolvidas
nQtSolA  := 0  //solu��es em atraso
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
  		nQtSolA  := 0       //QTDE OCORR�NCIAS COM DT. SOLU��O VENCIDA SEM CUMPRIR
  		nQtde    := 0       //QTDE TOTAL DE OCORR�NCIAS
  		dDtIni   := Ctod("  /  /    ")
		dDtMov   := Ctod("  /  /    ")
		nTotRespA:= 0
		nTOTRESOLV  := 0      //QTDE TOTAL DE OCORR�NCIAS RESOLVIDAS
		nQtENV   := 0      //QTDE DE ENVIO
		nQtRENV  := 0      //QTDE DE REENVIOS
		
		nRESOLpRZ   := 0 //QTDE OCORRENCIAS RESOLVIDAS DENTRO DO PRAZO 5 DIAS
		nRESOLforaP := 0 //QTDE OCORRENCIAS RESOLVIDAS FORA DO PRAZO 5 DIAS  
		nDTVENCnOK  := 0 //QTDE OCORR�NCIAS C/ DT SOLU��O VENCIDA SEM CUMPRIR
		nDTVENCOK  := 0 //QTDE OCORR�NCIAS C/ DT SOLU��O A VENCER
		nDUtil      := 0 //CONTADOR DE DIAS �TEIS
		nAGUARDA    := 0  //QTDE OCORRENCIAS SEM RESPOSTA MAS DENTRO DO PRAZO 1 DIA
		
		nTOTNAORESOL:= 0
		nRESPFORA    := 0
	
		While Alltrim(AAUX->UD_OPERADO) == Alltrim(cOperador)
			If Alltrim(AAUX->UD_CODIGO) != Alltrim(cOcorrant)		
		 	    /////////////////////////////////////////////////
		  	    ///TOTAL qtde de ocorr�ncias RESOLVIDAS = S
		  	    /////////////////////////////////////////////////
		  	    If Alltrim(AAUX->UD_RESOLVI) = "S"
			  	   	nTOTRESOLV++      //total ocorr�ncias resolvidas
			  	ENDIF
			  	    
			  	IF !Empty(AAUX->UD_DATA) .AND. AAUX->UD_RESOLVI != "S"
			  	   	nTOTNAORESOL++
			  	Endif
		  	    
		  	    
		  	    ////////////////////////////////////////////////////////////////////////
		  	    ///QTDE OCORR�NCIAS SEM RESPOSTA (FORA PRAZO PRAZO 1 DIA)
		  	    ///UD_DATA VAZIO 
		  	    ////////////////////////////////////////////////////////////////////////	  	    	  	    
			
			  	    nDUtil := 0
					dDtIni := AAUX->UD_DTINCLU
					dDtMov := dDtIni
					//qdo ainda n�o tem a primeira resposta...
					If Empty(AAUX->UD_DATA) 				
					  If ((dDatabase - AAUX->UD_DTINCLU) >= 2)  					 
						While dDtMov <= dDatabase
							dDtMov := dDtMov + 1 
							If Ascan(aFeriados, Substr( DtoS(dDtMov),5,4) ) == 0 								    	 	 
				    	 	 //se n�o for feriado.... 						
								If Dow(dDtMov) != 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= dDatabase  //verifica se n�o � s�bado, nem domingo
									nDUtil := nDUtil + 1	
								Endif	
							Endif
						EndDo
					  Endif
					Endif			
				
					If nDUtil >= 2   //como o prazo de resposta � um dia, ent�o coloco maior = 2, pois � a toler�ncia necess�ria para saber se atrasou
						nSEMRESP++   //CONTADOR de ocorr�ncias sem a 1a. RESPOSTA (estourou o prazo de 1 dia)				
					Endif
			
				
				////////////////////////////////////////////////////////////////////////
		  	    ///QTDE OCORR�NCIAS RESPONDIDA (FORA PRAZO PRAZO 1 DIA)
		  	    ///UD_DATA PREENCHIDO EM ATRASO
		  	    ////////////////////////////////////////////////////////////////////////	  	    	  	    
			   	    nDUtil := 0
					dDtIni := AAUX->UD_DTINCLU
					dDtMov := dDtIni
					DTINCLU:= AAUX->UD_DTINCLU
					DTRESP := IIF(!EMPTY(AAUX->ZUD_DTRESP), AAUX->ZUD_DTRESP, AAUX->UD_DTRESP)
				
					  If (( DTRESP - DTINCLU ) >= 2)  
						While dDtMov <= DTRESP  //CONTA DA DATA DA INCLUS�O AT� O DIA EM QUE EFETUOU A RESPOSTA
							dDtMov := dDtMov + 1 
							If Ascan(aFeriados, Substr( DtoS(dDtMov),5,4) ) == 0 								    	 	 
				    	 	 //se n�o for feriado.... 						
								If Dow(dDtMov) != 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= DTRESP  //verifica se n�o � s�bado, nem domingo
									nDUtil := nDUtil + 1	
								Endif	
							Endif
						EndDo
					  Endif
				
					If nDUtil >= 2   //como o prazo de resposta � um dia, ent�o coloco maior = 2, pois � a toler�ncia necess�ria para saber se atrasou
						//MSGBOX("DIAS �TEIS: " + str(nDUtil) )
						nRESPFORA++   //CONTADOR de ocorr�ncias CUJA RESPOSTA FOI REGISTRADA EM ATRASO (a 1a. RESPOSTA estourou o prazo de 1 dia)				
					Endif
				
							
				/////////////////////////////////////////////////////////////////////////////////////////////////////
		  	    /// QTDE OCORR�ncias S/ RESOLVER (PASSOU O PRAZO) - NAO RESOLVIDAS
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
					    	 	 //se n�o for feriado.... 						
									If Dow(dDtMov) != 1 .and. Dow(dDtMov) != 7 .and. dDtMov <= dDatabase //verifica se n�o � s�bado, nem domingo							
										nDias := nDias + 1	
									Endif	
								Endif
							EndDo
							If nDias >= 2 
								nDTVENCnOK++  //CONTADOR DE DT SOLU��O SEM CUMPRIR
							Endif				
						Endif
					
					Endif				
					
					////////////////////////////////////////////////////////////////////////
					//CONTADOR GERAL DE N�MERO DE OCORR�NCIAS DO SETOR (TOTAL OCORR�NCIAS)
					////////////////////////////////////////////////////////////////////////								   	
		       		nQtde++	   
		    		cOcorrant := AAUX->UD_CODIGO
		    		//If AAUX->UD_NRENVIO >= 1
		    			nQtENV ++
		    		//Endif
		    		If AAUX->UD_NRENVIO >= 2
		    			nQtRENV += AAUX->UD_NRENVIO - 1
		    		Endif	    		

		  Endif //se � igual a ocorrencia anterior, pula
	    	
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
		   aadd( oHtml:ValByName("it.cQtd") , Str(aDados[x,2])    )      //qtde total ocorr�ncias
		   aadd( oHtml:ValByName("it.nSEMresp") , STR(aDados[x,4])  )    //qtde ocorr�ncias sem resposta
		   aadd( oHtml:ValByName("it.nRESPfora") , STR(aDados[x,15])  )    //qtde ocorr�ncias dt registro resposta fora do prazo (1 dia)
		   //aadd( oHtml:ValByName("it.nTOTrESOLV") , Str(aDados[x,3])    )   //qtde ocorr�ncias resolvidas 
		   //aadd( oHtml:ValByName("it.nTOTrESOLV") , Str(aDados[x,6])    )   //qtde ocorr�ncias resolvidas dANI pediu pra colocar s� as fora do prazo
		   
		   //aadd( oHtml:ValByName("it.nSEMresp") , STR( aDados[x,4] + aDados[x,11])  )    //qtde ocorr�ncias sem resposta (fora prazo 1 dia + dentro prazo 1 dia)
		   //aadd( oHtml:ValByName("it.nRESOLprz" ) , STR(aDados[x,5])   )   //qtde ocorr�ncias resolvidas dentro do prazo
		   //aadd( oHtml:ValByName("it.nRESOLforaP" ) , STR(aDados[x,6])   )   //qtde ocorr�ncias resolvidas fora do prazo
		   aadd( oHtml:ValByName("it.nDTVENCnOK" ) , STR(aDados[x,7])   )   //qtde ocorr�ncias sem resolver
		   //aadd( oHtml:ValByName("it.nDTVENCOK" ) , STR(aDados[x,13])   )   //qtde ocorr�ncias c/ dt solu��o a vencer
		   //aadd( oHtml:ValByName("it.nQTAGUARDA" ) , STR(aDados[x,11])   )   //qtde ocorr�ncias aguardando resposta dentro prazo 1 dia
		   //aadd( oHtml:ValByName("it.NAORESOLV") , Str(aDados[x,14])    )   //qtde ocorr�ncias S/ RESOLVER   
		   aadd( oHtml:ValByName("it.nQTENV" ) , STR(aDados[x,8])   )   //qtde total envios
		   //aadd( oHtml:ValByName("it.nQTRENV" ) , STR(aDados[x,9])   )   //qtde total Reenvios
		Endif    
	
	Next
	_user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 eEmail := ""	 
	 //eEmail := "marcelo@ravaembalagens.com.br"
	 eEmail += ";daniela@ravaembalagens.com.br"   //31/10 Daniela solicitou que por eqto. (at� ela avisar) que somente ela deve receber este email
	 //eEmail += ";humberto.filho@ravaembalagens.com.br" 	         
	 
	 //eEmail := "" //RETIRAR
	 //eEmail += ";flavia.rocha@ravaembalagens.com.br" 	//retirar
	 oProcess:cTo := eEmail
	 oProcess:cBcc:= "informatica@ravaembalagens.com.br"
	 subj	:= "Resumo das Ocorr�ncias SAC - " + cEmpresa
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
   cNome := Alltrim(aUsuarios[1][2])     	// Nome do usu�rio
Endif 

return cNome
