#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#Include "Topconn.ch"

/////////////////////////////////////////////////////////////////////////////
//Programa: Q215TDOK - PTO DE ENTRADA NA CONFIRMAÇÃO DA ROTINA RESULTADOS
//Autoria : Flávia Rocha
//Data    : 25/04/2011 
//Usado em: Inspeção Processos
//Solicitado por Marcelo: Quando uma inspeção for reprovada, BLOQUEAR A OP
/////////////////////////////////////////////////////////////////////////////

****************************************
User Function Q215TDOK()

****************************************


Local cOP 		:= QPK->QPK_OP     //JUNTOS: C2_NUM + C2_ITEM + C2_SEQUEN
Local dEmissao  := QPK_EMISSA
Local cProduto	:= QPK->QPK_PRODUT
Local cRevisao  := QPK->QPK_REVI
Local cStatus	:= QPK->QPK_SITOP
Local cLaudo	:= ""
Local nPOSOPER  := 0
//Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "QQK_OPERAC"}) 
Local cOperacao := "" //aResultados[1,1]  //M->QPL_OPERAC
Local cDescLaudo:= ""
Local cQuery    := ""
Local LF	    := CHR(13) + CHR(10)
Local cBloqueia := Getmv("RV_BLOQCQ")  // parâmetro que indica se irá bloquear pelo lançamento reprovado do laudo RAVA
Local lTemInsp  := .F.  //rege se encontrou medições na máquina lida no momento 
Local cOPTST    := ""
Local cRVDeslau := M->QPL_DESCL    //DESCRIÇÃO DO LAUDO RAVA
Local cMotivo   := M->QPL_RVJUST  //JUSTIFICATIVA DO LAUDO RAVA  
Local cDescOPER := ""
Local cSTATUS   := M->QPL_STMAQ  //1=FUNCIONANDO, 2=PARADA, 3=SETUP
//Public LTMK503AUTO := .T.

//SÓ FARÁ AS VALIDAÇÕES CASO A MÁQUINA ESTEJA FUNCIONANDO

cOperacao := QP7->QP7_OPERAC   
If Empty(cOperacao)       //se não obtiver a operação via posição do ensaio normal, verifica se está posicionado num ensaio texto:
	cOperacao := QP8->QP8_OPERAC
Endif 

QQK->(DbsetOrder(3))
If QQK->(Dbseek(xFilial("QQK") + cProduto + cOperacao ))
	If Alltrim(QQK->QQK_REVIPR) = Alltrim(cRevisao)
		cDescOPER := QQK->QQK_RECURS //nome da máquina, ex.: SEL03
	Endif

Endif


//cLaudo := M->QPM_LAUDO   //será usado o laudo da operação
//cLaudo := M->QPL_LAUDO   //Laudo laboratório
cLaudo := M->QPL_RVLAUD  //Laudo Rava

If Empty(M->QPL_RVJUST)  //JUSTIFICATIVA DO LAUDO RAVA 
	cMotivo := cRVDeslau  //se a Justificativa que o usuário preenche, estiver vazia, pega a descrição do laudo Rava (ex.: REJEITADO TOTALMENTE)
Endif

////////////////////////////////////////////////////////////////////////////////////////////////
//Flavia Rocha - em 14/05 em reunião conferência com Marcelo e Eurivan,
// ficou definido que a verificação de bloqueio/desbloqueio deverá ser por laudo de operação
// e não por Laudo final (Laudo Geral que é dado ao final de todo o processo)
////////////////////////////////////////////////////////////////////////////////////////////////


/*
LAUDOS FINAIS:
A - APROVADO SEM RESTRIÇÕES
B - ACEITO COM DESVIO SIMPLES
C - ACEITO COM DESVIO GRAVE
D - COM SELEÇÃO PELO FORNECEDOR
E - REJEITADO TOTALMENTE

*/

If Alltrim(cLaudo) = "A"
	cDescLaudo := "APROVADO SEM RESTRICOES"
Elseif Alltrim(cLaudo) = "B"
	cDescLaudo := "ACEITO COM DESVIO SIMPLES"
Elseif Alltrim(cLaudo) = "C"
	cDescLaudo := "ACEITO COM DESVIO GRAVE"
Elseif Alltrim(cLaudo) = "D"
	cDescLaudo := "COM SELECAO PELO FORNECEDOR"
Elseif Alltrim(cLaudo) = "E"
	cDescLaudo := "REJEITADO TOTALMENTE"
Endif

//.and. !Empty(aResultados[nFldLauGer,1,3])  //verifica se o Laudo Geral está preenchido
//MsgBOX("OPERAÇÃO: " + cOperacao)

//A variável nOpcX armazena o número da opção escolhida:
//1-Pesquisar
//2-Visualizar
//3-Resultados
//4-Excluir

//MSGBOX("OPÇÃO: " + STR(nOpcX) + ' - ' + cLaudo )
//Como este P.E. é executado toda vez em que se clica no botão "OK", resolvi filtrar
//pela opção "Resultados" pois quando clicar em "Excluir" não será necessário a execução do mesmo.
//FR - 27/04/2011

	If nOpcX = 3 // CONFIRMOU NO OK
		If Empty(cRVDeslau) 
			IF Alltrim(cSTATUS) = '1' //FUNCIONANDO                                           
				Msginfo("Preencha o LAUDO RAVA por Favor ")
				Return .F.
			ENDIF
		
		Else
	
		    IF Alltrim(cSTATUS) = '1' //FUNCIONANDO                                           
		    	//FR - 15/10/13 - FLÁVIA ROCHA - 
		        //SOMENTE IRÁ EXECUTAR INSTRUÇÕES DE BLOQUEIO SE A MÁQUINA ESTIVER FUNCIONANDO
			    If Alltrim(cBloqueia) = "S"  //está ativado o bloqueio de OP ?
			    
			    	////////////////////////////////////////////////////////////////////////////////////////////////////////////
					///DENTRO DAS OPs ABERTAS, PROCURA AS QUE POSSUEM INSPEÇÃO REALIZADA NA OPERAÇÃO LIDA NO MOMENTO
					///EXEMPLO: SE A OPERAÇÃO REGISTRADA AGORA FOR 01 - LAMINADORA, VERIFICA SE JÁ TEM ALGUMA OUTRA INSPEÇÃO
					///REALIZADA NA LAMINADORA, PARA AÍ SIM, VERIFICAR SE IRÁ BLOQUEAR OU DESBLOQUEAR 
					////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//msginfo("ver medições normais")
					lTemInsp := .F.
					//1o. VERIFICA AS MEDIÇÕES NÃO TEXTO....
					cQuery := " SELECT QP7_PRODUT, QP7_OPERAC, QP7_ENSAIO " + LF
					cQuery += " ,QTINSP = (SELECT COUNT(*) FROM " + RetSqlName("QPR") + " QPR  " + LF
					cQuery += "            WHERE QP7.QP7_ENSAIO = QPR.QPR_ENSAIO " + LF
					cQuery += "            AND QP7.QP7_PRODUT = QPR.QPR_PRODUT " + LF
					cQuery += "            AND QP7.QP7_REVI = QPR.QPR_REVI AND QPR.D_E_L_E_T_ = '' " + LF
					cQuery += "            AND QPR_DTMEDI >= '" + Dtos(dEmissao) + "'  " + LF
					//cQuery += "            AND QPR_OP = '" + Alltrim(cOP) + "' ) " + LF
					cQuery += "            ) " + LF
					cQuery += " ,QP1.QP1_DESCPO " + LF
					cQuery += "  FROM " + RetSqlName("QP7") + " QP7, " + LF
					cQuery += "  "      + RetSqlName("QP1") + " QP1 " + LF
					cQuery += " WHERE QP7_PRODUT = '" + Alltrim(cProduto) + "' AND QP7_REVI = '" + Alltrim(cRevisao) + "' " + LF
					cQuery += " AND QP7_OPERAC = '" + Alltrim(cOperacao) + "' " + LF
					cQuery += " AND QP7.D_E_L_E_T_ = ''  " + LF 
					cQuery += " AND QP7.QP7_ENSAIO = QP1.QP1_ENSAIO " + LF
					cQuery += " AND QP1.D_E_L_E_T_='' " + LF
						
					MemoWrite("C:\Temp\QPR7.SQL",cQuery)
					If Select("QPRX") > 0
						DbSelectArea("QPRX")
						DbCloseArea()	
					EndIf 
					TCQUERY cQuery NEW ALIAS "QPRX"
					QPRX->( DbGotop() )
					If !QPRX->(EOF())
						Do While !QPRX->(EOF())
							If QPRX->QTINSP >= 1
								lTemInsp := .T.
							//Else
							//	lTemInsp := .F.
							Endif
							QPRX->(Dbskip())
						Enddo
					Endif
					//msginfo("ver medições texto...")		
					//2o. VERIFICA AS MEDIÇÕES TEXTO....
					cQuery := " SELECT QP8_PRODUT, QP8_OPERAC, QP8_ENSAIO " + LF
					cQuery += " ,QTINSP = (SELECT COUNT(*) FROM " + RetSqlName("QPR") + " QPR  " + LF
					cQuery += "            WHERE QP8.QP8_ENSAIO = QPR.QPR_ENSAIO " + LF
					cQuery += "            AND QP8.QP8_PRODUT = QPR.QPR_PRODUT " + LF
					cQuery += "            AND QP8.QP8_REVI = QPR.QPR_REVI AND QPR.D_E_L_E_T_ = '' " + LF
					cQuery += "            AND QPR_DTMEDI >= '" + Dtos(dEmissao) + "'  " + LF
					//cQuery += "            AND QPR_OP = '" + Alltrim(cOP) + "' ) " + LF
					cQuery += "            ) " + LF
					cQuery += " ,QP1.QP1_DESCPO " + LF
					cQuery += "  FROM " + RetSqlName("QP8") + " QP8, " + LF
					cQuery += "  "      + RetSqlName("QP1") + " QP1 " + LF
					cQuery += " WHERE QP8_PRODUT = '" + Alltrim(cProduto) + "' AND QP8_REVI = '" + Alltrim(cRevisao) + "' " + LF
					cQuery += " AND QP8_OPERAC = '" + Alltrim(cOperacao) + "' " + LF
					cQuery += " AND QP8.D_E_L_E_T_ = ''  " + LF 
					cQuery += " AND QP8.QP8_ENSAIO = QP1.QP1_ENSAIO " + LF
					cQuery += " AND QP1.D_E_L_E_T_='' " + LF                   
					MemoWrite("C:\Temp\QPR8.SQL",cQuery)
					If Select("QPRXX") > 0
						DbSelectArea("QPRXX")
						DbCloseArea()	
					EndIf 
					TCQUERY cQuery NEW ALIAS "QPRXX"
					QPRXX->( DbGotop() )
					If !QPRXX->(EOF())
						Do While !QPRXX->(EOF())
							If QPRXX->QTINSP >= 1
								lTemInsp := .T.
							//Else
							//	lTemInsp := .F.
							Endif
							QPRXX->(Dbskip())
						Enddo
					Endif 
			       
			    	
						///PROCURA POR TODAS AS OPs abertas que possuem especificação no SIGAQIP,
						///E bloqueia ou desbloqueia conforme o laudo registrado na inspeção da operação corrente
						///pois entendemos que sendo as OPs, parte da mesma máquina, inspecionando uma , e a mesma for bloqueada/desbloqueada
						///todas deverão ser também.
						cQuery := " Select " + LF
						cQuery += " C2_BLOQUEA, C2_NMBLOQ, C2_OBSBLOQ, B1_SETOR, QP6_REVI = (SELECT TOP 1 QP6X.QP6_REVI FROM " + Retsqlname("QP6") + " QP6X WHERE QP6X.QP6_PRODUT = SC2.C2_PRODUTO AND QP6X.D_E_L_E_T_ = '' " + LF
						cQuery += "                 Order by QP6X.QP6_REVI DESC ) " + LF
						cQuery += " , C2_FILIAL, C2_NUM , C2_PRODUTO, C2_ITEM, C2_SEQUEN, C2_ITEMGRD " + LF
						cQuery += " from " + RetSqlName("SC2") + " SC2, " + LF
						cQuery += "      " + RetSqlName("QP6") + " QP6,  " + LF
						cQuery += "      " + RetSqlName("SB1") + " SB1  " + LF
						cQuery += " WHERE " + LF
						cQuery += " SC2.C2_PRODUTO = QP6.QP6_PRODUT " + LF
						cQuery += " and SC2.C2_PRODUTO = SB1.B1_COD " + LF
						cQuery += " and QP6_REVI = (SELECT TOP 1 QP6_REVI FROM " + Retsqlname("QP6") + " QXP6 WHERE QXP6.QP6_PRODUT = QP6.QP6_PRODUT AND QXP6.D_E_L_E_T_ = '' " + LF
						cQuery += "                 Order by QXP6.QP6_REVI DESC ) " + LF
						cQuery += " and SC2.C2_PRODUTO = '" + Alltrim(cProduto) + "' " + LF
						//cQuery += " and C2_FILIAL = '03' " + LF
						cQuery += " and B1_SETOR = '39' " + LF 
						cQuery += " and B1_TIPO  = 'PA' " + LF
						cQuery += " and C2_DATRF = '' " + LF
						cQuery += " and C2_QUJE < C2_QUANT " + LF
						cQuery += " and C2_FINALIZ = '' " + LF
						//If !Empty(cOPNAO)
						//	cQuery += " AND C2_NUM NOT IN ('" + Alltrim(cOPNAO) + "' ) " + LF 
						//Endif
						cQuery += " AND SC2.D_E_L_E_T_ = '' " + LF
						cQuery += " AND SB1.D_E_L_E_T_ = '' " + LF
						cQuery += " AND QP6.D_E_L_E_T_ = '' " + LF
						cQuery += " order by C2_NUM " + LF
					
						MemoWrite("C:\Temp\INSP_SEEK_OP.SQL",cQuery)
						
						If Select("TEMPX") > 0
							DbSelectArea("TEMPX")
							DbCloseArea()	
						EndIf 
						
						TCQUERY cQuery NEW ALIAS "TEMPX"
						
						TEMPX->( DbGotop() )
						If !TEMPX->(EOF())
							Do While !TEMPX->(EOF())							    			
								////EFETUA BLOQUEIO E/OU DESBLOQUEIO
								DbselectArea("SC2")
								Dbsetorder(1)
								If xFilial("SC2") = '03'  //somente irá realizar a operação abaixo, na Rava/Caixas
									If SC2->(DBseek( TEMPX->C2_FILIAL + TEMPX->C2_NUM + TEMPX->C2_ITEM + TEMPX->C2_SEQUEN + TEMPX->C2_ITEMGRD ) )  //procura a OP
										If !Empty(cLaudo) 	//pegar pela descrição do laudo Rava!!!				            
										   	If lTemInsp
										   		/////////////////////////////////////////////////////////////////////////////     
										   		//Somente se tiver registro de inspeção da Operação (Máq),
										        //lida, irá permitir o bloqueio e/ou desbloqueio das OP do processo
										        //A mesma máquina que viabilizar o bloqueio, será a mesma que irá desbloquear
										        //na revisão da inspeção.
										        //uma máquina (operação) diferente, não desbloqueia a outra. 
										        //////////////////////////////////////////////////////////////////////////////
											    If (Alltrim(Substr(SC2->C2_OBSBLOQ,1,2)) = Alltrim(cOperacao) .OR. ;
											    Alltrim(Substr(SC2->C2_OBSBLOQ,1,2)) = "WF" ) .OR. Alltrim(SC2->C2_BLOQCQ) = "BLOQOP"
											    	//ou seja, se a operação lida agora é a mesma que gerou o bloqueio, desbloqueia
												   	IF Alltrim(cLaudo) $ "A/B/C"			
														RecLock("SC2",.F.)
														SC2->C2_BLOQUEA := ''      //libera a OP
														SC2->C2_NMBLOQ := Substr(cUSUARIO,7,15)
														//SC2->C2_OBSBLOQ:= cOperacao + "- DESBLOQ CQ: " + cDescLaudo 
														//FR - 30/11/12 - Lucia solicitou incluir na OBS de Bloqueio:
														  //nome da máquina que gerou o bloqueio
														  //motivo (justificativa do laudo)
														  //data
														  //hora
														  //OP origem bloqueio
														  SC2->C2_OBSBLOQ:= cOperacao + " - " + Alltrim(cDescOPER) + " - " + Alltrim(cMotivo) + " - OP origem: " + Substr(cOP,1,6) + ;
														  " - " + Dtoc(dDatabase) + " - " + Time()
														
														SC2->( MSUnlock() )
														//MsgInfo("Laudo RAVA APROVADO." )	
												
													ELSEIF Alltrim(cLaudo) $ "D/E"		
														RecLock("SC2",.F.)		
														SC2->C2_BLOQUEA := '*'		//bloqueia a OP
														SC2->C2_NMBLOQ := Substr(cUSUARIO,7,15)
														//SC2->C2_OBSBLOQ:= cOperacao + "- BLOQ CQ: " + cDescLaudo 
														//FR - 30/11/12 - Lucia solicitou incluir na OBS de Bloqueio:
														  //nome da máquina que gerou o bloqueio
														  //motivo (justificativa do laudo)
														  //data
														  //hora
														  //OP origem bloqueio
														  SC2->C2_OBSBLOQ:= cOperacao + " - " + Alltrim(cDescOPER) + " - " + Alltrim(cMotivo) + " - OP origem: " + Substr(cOP,1,6) + ;
														  " - " + Dtoc(dDatabase) + " - " + Time()													
														
														SC2->( MSUnlock() )
														//MsgInfo("Laudo Rava REPROVADO." )			
													ENDIF
												
												Else //se for outra operação
													 //SÓ BLOQUEIA, NÃO DESBLOQUEIA
													IF Alltrim(cLaudo) $ "D/E"		
														RecLock("SC2",.F.)		
														SC2->C2_BLOQUEA := '*'		//bloqueia a OP
														SC2->C2_NMBLOQ := Substr(cUSUARIO,7,15)
														//SC2->C2_OBSBLOQ:= cOperacao + "- BLOQ CQ: " + cDescLaudo 
														//FR - 30/11/12 - Lucia solicitou incluir na OBS de Bloqueio:
														  //nome da máquina que gerou o bloqueio
														  //motivo (justificativa do laudo)
														  //data
														  //hora
														  //OP origem bloqueio
														  SC2->C2_OBSBLOQ:= cOperacao + " - " + Alltrim(cDescOPER) + " - " + Alltrim(cMotivo) + " - OP origem: " + Substr(cOP,1,6) + ;
														  " - " + Dtoc(dDatabase) + " - " + Time()													
														  
														SC2->( MSUnlock() )
														//MsgInfo("Laudo Rava REPROVADO." )			
													ENDIF
												
												Endif
												
											Else
												//msginfo("sem qtde inspeção suficiente")
												IF Alltrim(cLaudo) $ "D/E"
													//msginfo("só bloqueia")
													RecLock("SC2",.F.)		
													SC2->C2_BLOQUEA := '*'		//bloqueia a OP
													SC2->C2_NMBLOQ := Substr(cUSUARIO,7,15)
													//SC2->C2_OBSBLOQ:= cOperacao + " - BLOQ CQ: " + cDescLaudo
													//FR - 30/11/12 - Lucia solicitou incluir na OBS de Bloqueio:
													  //nome da máquina que gerou o bloqueio
													  //motivo (justificativa do laudo)
													  //data
													  //hora
													  //OP origem bloqueio
													  SC2->C2_OBSBLOQ:= cOperacao + " - " + Alltrim(cDescOPER) + " - " + Alltrim(cMotivo) + " - OP origem: " + Substr(cOP,1,6) + ;
													  " - " + Dtoc(dDatabase) + " - " + Time()													
														  
													SC2->( MSUnlock() )
												Endif
											Endif  //lTemInsp
									
										Endif   //empty cLaudo
									Endif
								Endif
								DbselectArea("TEMPX")
								TEMPX->(DBSKIP())
							Enddo
							
							IF Alltrim(cLaudo) $ "A/B/C"
								MsgInfo("Laudo RAVA APROVADO" )	
							ELSEIF Alltrim(cLaudo) $ "D/E"
								MsgInfo("Laudo RAVA REPROVADO" )
							Else
								MsgInfo("Sem Registro do Laudo RAVA" )		
							ENDIF
							
						Endif  //eof		
					
				Else     //parâmetro não bloqueia
					IF Alltrim(cLaudo) $ "A/B/C"
						MsgInfo("Laudo RAVA APROVADO" )	
					ELSEIF Alltrim(cLaudo) $ "D/E"
						MsgInfo("Laudo RAVA REPROVADO" )	
					Else
						MsgInfo("Sem Registro do Laudo RAVA" )	
					ENDIF
				
				Endif  //cBloqueia
			ENDIF //STATUS MÁQUINA
		
		Endif //do laudo rava preenchido		
			
	Endif  //confirmou a operação

Return(.T.)

