#Include "Rwmake.ch"
#Include "Topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "Ap5mail.ch"
#include  "Tbiconn.ch " 

/*/
//------------------------------------------------------------------------------------
//Programa: WFQIP001 
//Objetivo: Enviar e-mail avisando sobre inspeções não realizadas no horário
//          E BLOQUEAR OPs caso haja inspeção = reprovada
//          DESBLOQUEAR em caso de inspeção = aprovada
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 08/05/12
//------------------------------------------------------------------------------------
/*/


********************************
User Function WFQIP001()  //( cMaquina, cTurno )
********************************

  Private cMAQUI := " " //"'" + Alltrim(cMaquina) + "'"
  Private cTURN  := " " //"'" + Alltrim(cTurno) + "'"
  Private aMaqs  := {}
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" 
  sleep( 5000 )
  
 ConOut("*** INICIANDO PROGRAMA: WFQIP001 *** ")
  /*
  cMaquina := "SEL"      //SEL - 07:09 / 09:17 / 12:10 
  cTURN   := '1'
  
  cMaquina := "MON"      //MON - 07:39 
  cTURN   := '1'
  
  cMaquina := "FEV"      //FEV - 07:59 / 10:59 / 12:59 /
  cTURN   := '1'
  
  cMaquina := "IMP"      //IMP - 08:41 / 11:41 / 13:41 / 
  cTURN   := '1'
  
  cMaquina := "COL1"     //COL1 - 08:48 / 
  cTURN   := '1'
  
  cMaquina := "COL2"     //COL2 - 09:54 / 11:00
  cTURN   := '1'
  
  cMaquina := "FAC"     //FAC - 09:09 / 10:15 / 11:21 /
  cTURN   := '1'
  
  cMaquina := "SHO"     //SHO - 09:21 / 10:27 / 11:33 /
  cTURN   := '1'
  
  //--------------------------------------------------------
  cMaquina := "SEL"      //SEL - 15:09 / 16:28 / 17:17
  cTURN   := '2'
   
  cMaquina := "MON"      //MON - 15:39
  cTURN   := '2'
    
  cMAQUI := "FEV"      //FEV - 15:59 / 16:48 / 17:37 /
  cTURN   := '2'
      
  //--------------------------------------------------------
	*/
	//cMAQUI := "SEL"    
  	//cTURN   := '1'
  //cMAQUI := "'" + Alltrim(cMaquina)+ "'"
  //cTURN  := "'" + Alltrim(cTurno) + "'"
    
  f_VerInsp() //( cMAQUI, cTURN ) 
  Reset Environment

Return

*****************************
Static Function f_VerInsp()  //( cMAQUI, cTURN)  
*****************************

Local cQuery 	:= ""
Local LF      	:= CHR(13)+CHR(10)
Local aHoras    := {}
Local aDados    := {}
Local aDadosNao := {}
Local aMaquinas := {}
Local aOPDesbLo := {} //irá armazenar as OPs que deverão ser desbloqueadas
Local nPos      := 0
Local cHora     := ""
Local nTam      := 0 
Local x			:= 0
Local cMaq		:= ""    //código da máquina
Local cDescMaq	:= ""    //nome da máquina
Local cHorarios := ""    //armazena os horários definidos para inspeção da máquina 
Local cDirHTM   := ""
Local cArqHTM   := ""
Local nHandle   := 0
Local cOperacao := ""
Local cHRVer    := "" 
Local y 		:= 1 
Local cOPNAO    := ""  //GRUPO DAS OPs que caso tenham registro de inspeção, não sofrerão nenhum bloqueio  
Local cMaqAnt   := ""
Local cHoragora := ""


Private nIntervalo:= ""  //GetMv("RV_ITVINSP")  //NUMÉRICO QUE INDICA O INTERVALO ENTRE INSPEÇÕES 
Private cHRAgend  := "" 
Private cHRLimite := ""
Private dDTMEDI   := dDatabase
Private cTime     := ""
Private cMaqIN    := ""
  
cTime := Alltrim(Substr( Time(),1,2 ))  //pega só os 2 primeiros dígitos da hora //voltar
//cTime := "13" //retirar
cMaqIN := ""                  
SetPrvt("OHTML,OPROCESS") 

DbselectArea("SX5")
SX5->(Dbsetorder(1))
If SX5->(Dbseek(xFilial("SX5") + 'IS' + cTime ))  //captura na tabela de horários inspeção x máquina , as máquinas q serão verificadas neste horário
	cMaqIN := Alltrim(SX5->X5_DESCRI) + Alltrim(SX5->X5_DESCSPA)+ Alltrim(SX5->X5_DESCENG)
Endif
ConOut("WFQIP001 -> Maquinas: " + cMaqIN )
//captura o parâmetro de intervalo por máquina:
/* //desabilitei porque o intervalo fixou em 01:00h todas as máquinas
If Alltrim(cMAQUI) = "SEL"
	nIntervalo := GetMv("RV_ITVSEL") 

Elseif Alltrim(cMAQUI) = "MON"
	nIntervalo := GetMv("RV_ITVMONT") 

Elseif Alltrim(cMAQUI) = "FEV"
	nIntervalo := GetMv("RV_ITVFEVA") 

Elseif Alltrim(cMAQUI) = "IMP"
	nIntervalo := GetMv("RV_ITVIMP")

//Elseif Alltrim(cMAQUI) = "EXT1"
//	nIntervalo := GetMv("RV_ITVEXT1") 

//Elseif Alltrim(cMAQUI) = "EXT2"
//	nIntervalo := GetMv("RV_ITVEXT2") 

Elseif Alltrim(cMAQUI) = "COL"
	nIntervalo := GetMv("RV_ITVCOL")
	
Elseif Alltrim(cMAQUI) = "COL1"
	nIntervalo := GetMv("RV_ITVCOL1")

Elseif Alltrim(cMAQUI) = "COL2"
	nIntervalo := GetMv("RV_ITVCOL2")

Elseif Alltrim(cMAQUI) = "FAC"
	nIntervalo := GetMv("RV_ITVFACA")    	

Elseif Alltrim(cMAQUI) = "SHO"
	nIntervalo := GetMv("RV_ITVSHOC") 
Endif
*/

If Time() > "14:00"
	FVerT2() //se o horário for de 2o. turno, o qual ainda não tem inspetoras realizando inspeções, faço o desbloqueio das OPs bloqueadas no 1o. turno
	         //onde bloqueia qdo não encontra registro de inspeção
Else

	nIntervalo := "01:00"
	
	cHoragora  := Substr(Time(),1,5) //voltar
	cHRLimite  := Substr(Time(),1,5) //voltar
	//cHoragora  := "13:00" //retirar
	//cHRLimite  := "13:00" //retirar
	
	//cTime := "07"
	nTime := Val(cTime)
	nInter:= Val(Substr(nIntervalo,1,2))
	nHRAgend := nTime - nInter       //para descobrir a hora inicial q deveria ter sido feita a inspeção
	
	//cHRAgend := CALCHR (cHoragora, nIntervalo)  //substrai de Time, a hora inicial que deveria já ter começado as inspeções, ou seja, faz retroativo
	cHRAgend := StrZero(nHRAgend,2)
	
	If Len(cHRAgend) < 5
		cHRAgend := cHRAgend + ":00"
	Endif
	Conout("HORA INICIO: " + cHRAgend )
	Conout("HORA FIM: " + cHRLimite )
	
	//QUERY PARA OBTER OS CÓDIGOS DAS MÁQUINAS QUE POSSUEM ESPECIFICAÇÃO NO SIGAQIP...	
	cQuery := " Select DISTINCT  QQK_RECURS MAQ, QQK_DESCRI, QQK_OPERAC " + LF
	
	cQuery += " from " + RetSqlName("QQK") + " QQK " + LF  //--> Especificação das Operações
	cQuery += " WHERE " + LF
	cQuery += " QQK.D_E_L_E_T_ = '' "  + LF 
	
	cQuery += " AND QQK_RECURS in ( " + Alltrim(cMaqIN) + " ) " + LF  
	
	CONOUT("MAQUINAS: " + cMaqIN )
	
	cQuery += " order by QQK_RECURS, QQK_OPERAC " + LF
	
	MemoWrite("\Temp\WFQIP001.SQL",cQuery)
	
	If Select("TEMPX") > 0
		DbSelectArea("TEMPX")
		DbCloseArea()	
	EndIf 
	
	TCQUERY cQuery NEW ALIAS "TEMPX"
	
	TEMPX->( DbGotop() )
	If !TEMPX->(EOF())
		Do While !TEMPX->(EOF())
		    cMaq  := TEMPX->MAQ
		    cDescMaq := TEMPX->QQK_DESCRI
		    cOperacao:= TEMPX->QQK_OPERAC
		    	    
		    If Alltrim(cMaq) != Alltrim(cMaqAnt) 
		    	///VERIFICA MEDIÇÕES
			    cQuery := " Select   " + LF 
			    cQuery += " QPR_PRODUT, QPR_OP, QPR_DTMEDI, QPR_HRMEDI, QPR_RESULT, QPR_OPERAC  " + LF
				cQuery += " from " + RetSqlName("QPR") + " QPR " + LF
				cQuery += " WHERE " + LF
				cQuery += " QPR_OPERAC = '" + Alltrim(cOperacao) + "' " + LF
			
			
				//If cTURN = '1'
					cQuery += " and (  ( (QPR_DTMEDI + QPR_HRMEDI )  >= ( '" + Dtos(dDTMEDI) + cHRAgend + "'  ) " 
					cQuery += "           AND (QPR_DTMEDI + QPR_HRMEDI )  <= ( '" + Dtos(dDTMEDI) + Substr(cHRLimite,1,5) + "' ) )" + LF
					//cQuery += " or     (QPR_DTMEDI + QPR_HRMEDI)  <= ( '" + Dtos(dDTMEDI) + "' + '14:00:00' )   " 
					cQuery += " ) " + LF
				/*
				Elseif cTURN = '2'
					cQuery += " and (  ( (QPR_DTMEDI + QPR_HRMEDI )  >= ( '" + Dtos(dDTMEDI) + cHRAgend + "'  ) " 
					cQuery += "           AND (QPR_DTMEDI + QPR_HRMEDI )  <= ( '" + Dtos(dDTMEDI) + cHRLimite + "' ) )" + LF
					//cQuery += " or ( QPR_DTMEDI + QPR_HRMEDI)  <= ( '" + Dtos(dDTMEDI) + "' + '22:00:00' )  "
					cQuery += " )" + LF
				Elseif cTURN = '3'
					cQuery += " and ( ( (QPR_DTMEDI + QPR_HRMEDI )  >= ( '" + Dtos(dDTMEDI) + cHRAgend + "'  ) " 
					cQuery += "          AND (QPR_DTMEDI + QPR_HRMEDI )  <= ( '" + Dtos(dDTMEDI) + cHRLimite + "' ) )" + LF
					//cQuery += " or   ( QPR_DTMEDI + QPR_HRMEDI)  <= ( '" + Dtos(dDTMEDI + 1 ) + "' + '05:30:00' ) "
					cQuery += " )" + LF
				Endif
				*/
			
				cQuery += " AND QPR.D_E_L_E_T_ = '' AND QPR.QPR_FILIAL = '" + xFilial("QPR") + "' " + LF
				cQuery += "  GROUP BY QPR_PRODUT, QPR_OP, QPR_DTMEDI, QPR_HRMEDI, QPR_RESULT, QPR_OPERAC  " + LF
				cQuery += " ORDER BY QPR_DTMEDI, QPR_HRMEDI " + LF
				MemoWrite("\TEMP\WFQIP_insp.SQL" , cQuery )
				If Select("HORAS") > 0
					DbSelectArea("HORAS")
					DbCloseArea()	
				EndIf 
				TCQUERY cQuery NEW ALIAS "HORAS" 
				TCSetField( 'HORAS', "QPR_DTMEDI", "D")      //DATA DE ENTRADA DO LAUDO
				HORAS->( DbGotop() )
				If !HORAS->(EOF())							
					Do While !HORAS->(EOF())		
								      								
						Aadd(aDados, { cMaq,; 			//CÓDIGO DA MÁQUINA
									cDescMaq,; 		//DESCRIÇÃO DA MÁQUINA
									HORAS->QPR_OP,; 
									HORAS->QPR_PRODUT,;
									HORAS->QPR_DTMEDI,;
									HORAS->QPR_HRMEDI,;								
									HORAS->QPR_RESULT,;
									HORAS->QPR_OPERAC  } )
														
						HORAS->(DBSKIP()) 
					Enddo	
				Endif			
				
			   	//das OPs varridas no array aDados, só irá adicionar em cOPNAO se o laudo for diferente de REJEITADO
				//porque se o laudo for REJEITADO, esta OP será automaticamente bloqueada	
			
				For y:= 1 to Len(aDados)        
				//aDados: array que contem OPs que possuem registro de inspeção
				//se possui registro de inspeção, não serão bloqueadas, mas apenas se este registro for diferente de Rejeitado, 
				//ou seja, mesmo possuindo registro de inspeção, mas se este registro for REJEITADO, esta OP sim, será bloqueada
				//caso contrário, adiciono na variável cOPNAO, para que ela não seja considerada no intervalo de bloqueio
					If Alltrim(aDados[y,7]) = "A"	 //se o laudo estiver aprovado, adiciona no intervalo de OPs que não serão bloqueadas
						If y = 1
							cOPNAO += "'" +  Alltrim(Substr(aDados[y,3],1,6) ) + "'"    //se y = 1 inicia sem ","
							If Ascan(aOPDesblo,Substr(aDados[y,3],1,6) ) == 0
								Aadd(aOPDesbLo , Substr(aDados[y,3],1,6) )				
							Endif
						Else
							cOPNAO += "," + "'" +  Alltrim(Substr(aDados[y,3],1,6) ) + "'"    //se for > 1, já adiciona "," no inicio da string
							If Ascan(aOPDesblo,Substr(aDados[y,3],1,6) ) == 0
								Aadd(aOPDesbLo , Substr(aDados[y,3],1,6) ) 
							Endif				
						Endif
					Endif
				Next
				
				///bloqueia as OPs que não possuem registro de inspeção (utilizei uma regra ao "contrário")
				///tudo que NÃO foi encontrado no aDados, é que não foi inspecionado
				///exemplo; se no SC2 existem: OP1, OP2, OP3, OP4, OP5, e em aDados possui: OP1, OP2 (inspecionadas)
				///bloquearei a OP3, OP4, OP5 porque não foi encontrado registro de inspeção das mesmas
				
				cQuery := " Select " + LF 
				cQuery += " C2_FILIAL, C2_BLOQUEA, C2_OBSBLOQ, " + LF
				cQuery += " B1_SETOR, QP6_REVI = (SELECT TOP 1 QP6X.QP6_REVI FROM " + Retsqlname("QP6") + " QP6X WHERE QP6X.QP6_PRODUT = SC2.C2_PRODUTO AND QP6X.D_E_L_E_T_ = '' " + LF
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
				cQuery += " and C2_FILIAL = '" + xFilial("SC2") + "' " + LF
				cQuery += " and B1_SETOR = '39' " + LF //DESATIVAR QUANDO A INSPEÇÃO PROCESSOS SACOS ESTIVER OK
				cQuery += " and C2_DATRF = '' " + LF
				cQuery += " and C2_QUJE < C2_QUANT " + LF
				cQuery += " and C2_FINALIZ = '' " + LF
				If !Empty(cOPNAO)
					cQuery += " AND C2_NUM NOT IN (" + Alltrim(cOPNAO) + " ) " + LF 
				Endif
				cQuery += " AND SC2.D_E_L_E_T_ = '' " + LF
				cQuery += " AND SB1.D_E_L_E_T_ = '' " + LF
				cQuery += " AND QP6.D_E_L_E_T_ = '' " + LF
				cQuery += " order by C2_NUM " + LF
				
				MemoWrite("C:\Temp\SEEK_OP.SQL",cQuery)
			
				If Select("TEMPOP") > 0
					DbSelectArea("TEMPOP")
					DbCloseArea()	
				EndIf 
				
				TCQUERY cQuery NEW ALIAS "TEMPOP"
			
				TEMPOP->( DbGotop() )
				If !TEMPOP->(EOF())
					Do While !TEMPOP->(EOF()) 
						DbselectArea("SC2")
						Dbsetorder(1)
						If SC2->(DBseek( TEMPOP->C2_FILIAL + TEMPOP->C2_NUM + TEMPOP->C2_ITEM + TEMPOP->C2_SEQUEN + TEMPOP->C2_ITEMGRD ) )
							//verifica se há registro de inspeção para a OP
							cQuery := " Select   " + LF 
						    cQuery += " QPR_PRODUT, QPR_OP, QPR_DTMEDI, QPR_HRMEDI, QPR_RESULT, QPR_OPERAC  " + LF
							cQuery += " from " + RetSqlName("QPR") + " QPR " + LF
							cQuery += " WHERE " + LF
							cQuery += " QPR_OPERAC = '" + Alltrim(cOperacao) + "' " + LF
						    cQuery += " AND QPR_OP = '" + Alltrim(TEMPOP->C2_NUM) + "' " + LF
						    
						    //If cTURN = '1'
								cQuery += " and (  ( (QPR_DTMEDI + QPR_HRMEDI )  >= ( '" + Dtos(dDTMEDI) + cHRAgend + "'  ) " 
								cQuery += "           AND (QPR_DTMEDI + QPR_HRMEDI )  <= ( '" + Dtos(dDTMEDI) + cHRLimite + "' ) )" + LF
								//cQuery += " or     (QPR_DTMEDI + QPR_HRMEDI)  <= ( '" + Dtos(dDTMEDI) + "' + '14:00:00' )   "
								cQuery += " ) " + LF
							/*
							Elseif cTURN = '2'
								cQuery += " and (  ( (QPR_DTMEDI + QPR_HRMEDI )  >= ( '" + Dtos(dDTMEDI) + cHRAgend + "'  ) "  
								cQuery += "           AND (QPR_DTMEDI + QPR_HRMEDI )  <= ( '" + Dtos(dDTMEDI) + cHRLimite + "' ) )" + LF
								//cQuery += " or ( QPR_DTMEDI + QPR_HRMEDI)  <= ( '" + Dtos(dDTMEDI) + "' + '22:00:00' )  "
								cQuery += " )" + LF
							Elseif cTURN = '3'
								cQuery += " and ( ( (QPR_DTMEDI + QPR_HRMEDI )  >= ( '" + Dtos(dDTMEDI) + cHRAgend + "'  ) " 
								cQuery += "          AND (QPR_DTMEDI + QPR_HRMEDI )  <= ( '" + Dtos(dDTMEDI) + cHRLimite + "' ) )" + LF
								//cQuery += " or   ( QPR_DTMEDI + QPR_HRMEDI)  <= ( '" + Dtos(dDTMEDI + 1 ) + "' + '05:30:00' )  "
								cQuery += " )" + LF
							Endif
						    */
							cQuery += " AND QPR.D_E_L_E_T_ = '' AND QPR.QPR_FILIAL = '" + xFilial("QPR") + "' " + LF
							cQuery += "  GROUP BY QPR_PRODUT, QPR_OP, QPR_DTMEDI, QPR_HRMEDI, QPR_RESULT, QPR_OPERAC  " + LF
							cQuery += " ORDER BY QPR_DTMEDI, QPR_HRMEDI " + LF
							MemoWrite("\TEMP\OPSEM_INSP.SQL" , cQuery )
							If Select("OPSEM") > 0
								DbSelectArea("OPSEM")
								DbCloseArea()	
							EndIf 
							TCQUERY cQuery NEW ALIAS "OPSEM" 
							TCSetField( 'OPSEM', "QPR_DTMEDI", "D")      //DATA DE ENTRADA DO LAUDO
							OPSEM->( DbGotop() )
							If !OPSEM->(EOF())
								Do While !OPSEM(EOF()) 
									If Alltrim( OPSEM->QPR_RESULT ) = "R"
										//se possuir REGISTRO DE INSPEÇÃO, REPROVADO, BLOQUEIA A OP
																			
										Reclock("SC2" , .F. )
										SC2->C2_BLOQUEA := '*'
										SC2->C2_OBSBLOQ:= "WF-BLOQ Workflow - INSP.REPROVADA - " + " - OP origem: " + Substr(OPSEM->QPR_OP,1,6) + ;
										" - " + Dtoc(dDatabase) + " - " + Time()
										
										SC2->C2_NMBLOQ  := "Admin"
										SC2->(MsUnlock())
												
									Endif	
									OPSEM->(DBSKIP())
								Enddo
							Else	 //SEM REGISTRO DE INSPEÇÃO NA OP						
								//alert("SEM registro inspeção BLOQUEIA: " + TEMPOP->C2_NUM)
								
								cOP := TEMPOP->C2_NUM
								cProd := TEMPOP->C2_PRODUTO
								dDtINSP := CtoD("  /  /    ")
								cHrINSP:= ""
								cLaudo := ""
								If cOperacao $ "05"	 // .and. Time() <= "14:00"			
									Aadd(aDadosNao, { cMaq,; 			//CÓDIGO DA MÁQUINA
													cDescMaq,; 		//DESCRIÇÃO DA MÁQUINA
													cOP,;
													cProd,;
													dDtINSP,;
													cHrINSP,;
													cLaudo,;							
													cOperacao } )
								//SEM REGISTRO DE INSPEÇÃO, BLOQUEIA A OP
								
								///FR - EM 27/12/13 - FOI SOLICITADO PELO DEPTO. INSPEÇÃO, NÃO MAIS BLOQUEAR QDO NÃO ENCONTRAR REGISTRO DE INSPEÇÃO
								///SOMENTE IRÁ BLOQUEAR SE ENCONTRAR INSPEÇÃO : REPROVADA
								
								///FR - 30/12/13 - CONFORME DEFINIDO COM DEPTO. INSPEÇÃO (RENATA)
								///BLOQUEAR APENAS SE NÃO ENCONTRAR INSPEÇÃO NA ETAPA = MONTAGEM
								
								//If cOperacao $ "05/06"
									Reclock("SC2" , .F. )
									SC2->C2_BLOQUEA := '*'
									SC2->C2_OBSBLOQ:= "WF-BLOQ Workflow - INSP.NAO REALIZADA - " + " - OP origem: " + Substr(cOP,1,6) + ;
											" - " + Dtoc(dDatabase) + " - " + Time()
									SC2->C2_NMBLOQ  := "Admin"
									SC2->(MsUnlock())														
								Endif  //só faz este if se a operação for MONTAGEM (05/06)
							    
							Endif					
						Endif  //dbseek no SC2
						TEMPOP->(DBSKIP())
					Enddo
				Endif
			    
				////EFETUA DESBLOQUEIO EM CASO DE OPs Aprovadas no processo
				For x:= 1 to Len(aOPDesbLo)
					DbselectArea("SC2")
					Dbsetorder(1)
					If SC2->(DBseek( xFilial("SC2") + aOPDesblo[x] ) )  //o número da OP já está com 6 caracteres somente: C2_NUM
					//Dbsetorder(2) //ORDEM DE PRODUTO
					//If SC2->(DBseek( xFilial("SC2") + aOPDesblo[x] ) )  //o número da OP já está com 6 caracteres somente: C2_NUM
						cPROD := SC2->C2_PRODUTO    //TEM Q DESBLOQUEAR TODAS AS opS DAQUELE DETERMINADO PRODUTO, JÁ QUE UMA É DESBLOQUEADA, TODAS DEVEM SER.
						Dbsetorder(2)
						If SC2->(DBseek( xFilial("SC2") + cPROD ) )  //o número da OP já está com 6 caracteres somente: C2_NUM
							While SC2->(!EOF()) .AND. SC2->C2_FILIAL == xFilial("SC2") .and. SC2->C2_PRODUTO == cPROD
								//DESBLOQUEIA			
								Reclock("SC2" , .F. )
								SC2->C2_BLOQUEA := ''
								SC2->C2_OBSBLOQ := "WF-DESBLOQ Workflow - INSP.APROVADA - " + " - OP origem: " + aOPDesblo[x] + ;
												" - " + Dtoc(dDatabase) + " - " + Time()
								SC2->C2_NMBLOQ  := "Admin"
								SC2->(MsUnlock())
								SC2->(Dbskip())
							Enddo
						Endif
							
					Endif //procura OP
				Next
				////////////////////////////////////////////////////////////////////////////
				cMaqAnt := cMaq		
		   		If Len(aDados) > 0
		   			INSPEnv(cMaq, aDados, 1)  //faz o envio das informações por máquina, INSP REALIZADA
		   		Endif
		   		If Len(aDadosNao) > 0
		   			INSPEnv(cMaq, aDadosNao, 2)  //faz o envio das informações por máquina, INSP NÃO REALIZADA
		   		Endif
	  	    
	  	    Endif  //de maq = maqant
	  		aDados    := {}
	  		aDadosNao := {}
		    DbSelectArea("TEMPX")
		    TEMPX->(DBSKIP())
		
		Enddo
		DbSelectArea("TEMPX")
		DbCloseArea()
		
		
			
	Endif   //eof do tempx
Endif //do horário de verificação > 14h
cMsg  := ""
eEmail:= ""
subj  := ""

cMsg   := "WORKFLOW OK" + chr(13) + chr(10)
cMsg   += "Data: " + Dtoc(Date()) + chr(13) + chr(10)
cMsg   += "Hora: " + Time() + chr(13) + chr(10)
cMsg   += "Máquina(s): " + cMaqIN + chr(13) + chr(10)
cMsg   += "Agendado para: " + cTime

eEmail := "flavia.rocha@ravaembalagens.com.br"
subj   := "WORKFLOW OK - INSP.PROCESSOS: " + Time()
U_SendFatr11(eEmail, "", subj, cMsg, "" ) 	

ConOut("*** FINALIZANDO PROGRAMA: WFQIP001 *** ")

Return

****************************************************
Static Function InspENV( cMaq , aDados, nOpc)
****************************************************

Local x := 0
Local cMsg := ""
Local cSimNao := ""

If Len(aDados) > 0
	oProcess:=TWFProcess():New("AVISO_INSPECAO","AVISO_INSP")		
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask('Inicio',"\workflow\http\oficial\WFQIP001.htm")
	oHtml   := oProcess:oHtml
	If nOpc = 1
		cMsg := "e foram encontrados os registros de inspeção, APROVADOS abaixo,<BR><BR>"
        cMsg += "            As Ordens de Produção abaixo serão DESBLOQUEADAS.<br>"         
        cSimNao := ""		
        oHtml:ValByName("cSimNao" , cSimNao ) 
        oHtml:ValByName("cMsg" , cMsg )
		oHtml:ValByName("dDTVER" , Dtoc(dDTMEDI) )
		oHtml:ValByName("cOperacao" , Alltrim(aDados[1,8]) )
		oHtml:ValByName("cMaq" , Alltrim(aDados[1,1]) )
		oHtml:ValByName("cDescMaq" , Alltrim(aDados[1,2]) ) 
		oHtml:ValByName("cHoras" , "A cada intervalo de: " + nIntervalo + " Hora(s)" )
	    
	    For x:= 1 to Len(aDados)
		
			aadd( oHtml:ValByName("it.cOP" )    , Substr(aDados[x,3],1,6)  )
			aadd( oHtml:ValByName("it.cProd")   , Alltrim(aDados[x,4]) )
			aadd( oHtml:ValByName("it.dDTINSP" ), DTOC(aDados[x,5]) )
			aadd( oHtml:ValByName("it.cHRINSP")  , Alltrim(aDados[x,6]) ) 
			aadd( oHtml:ValByName("it.cHRVER")  , cHRAgend + " - " + Substr(cHRLimite,1,5) ) 
			Do Case
				Case (aDados[x,7]) = 'A'
					cLaudo := "Aprovado"
				Case (aDados[x,7]) = 'R'
					cLaudo := "Reprovado"			
			Endcase
			aadd( oHtml:ValByName("it.cLaudo")  , cLaudo ) 
		
	    Next
	
	Else
		        
		cSimNao := "NAO"
		cMsg := "e NÃO foram encontrados registros de inspeção até o momento.<BR><BR>"
        cMsg += "            As Ordens de Produção abaixo serão BLOQUEADAS até que sejam realizadas as devidas inspeções.<br>"
        
        oHtml:ValByName("cSimNao" , cSimNao ) 
        oHtml:ValByName("cMsg" , cMsg )
		oHtml:ValByName("dDTVER" , Dtoc(dDTMEDI) )
		oHtml:ValByName("cOperacao" , Alltrim(aDados[1,8]) )
		oHtml:ValByName("cMaq" , Alltrim(aDados[1,1]) )
		oHtml:ValByName("cDescMaq" , Alltrim(aDados[1,2]) ) 
		oHtml:ValByName("cHoras" , "A cada intervalo de: " + nIntervalo + " Hora(s)" )	    
	    
	    For x:= 1 to Len(aDados)
		    If !Empty(aDados[x,3])
				aadd( oHtml:ValByName("it.cOP" )    , Substr(aDados[x,3],1,6)  )
			Else
				aadd( oHtml:ValByName("it.cOP" )    , "---"  )
			Endif
			If !Empty(aDados[x,4])
				aadd( oHtml:ValByName("it.cProd")   , Alltrim(aDados[x,4]) )
			Else 
				aadd( oHtml:ValByName("it.cProd")   , "---" )
			Endif
			If !Empty(aDados[x,5])
				aadd( oHtml:ValByName("it.dDTINSP" ), DTOC(aDados[x,5]) )
			Else
				aadd( oHtml:ValByName("it.dDTINSP" ), "Sem Registro Insp." )
			Endif
			If !Empty(aDados[x,6])
				aadd( oHtml:ValByName("it.cHRINSP")  , Alltrim(aDados[x,6]) ) 
			Else
				aadd( oHtml:ValByName("it.cHRINSP")  , "Sem Registro Insp." ) 
			Endif
			
			aadd( oHtml:ValByName("it.cHRVER")  , cHRAgend + " - " + Substr(cHRLimite,1,5)  )	
			aadd( oHtml:ValByName("it.cLaudo")  , "Sem Registro Insp." ) 
		
	    Next
	Endif		
		
	// Informe a função que deverá ser executada quando as respostas chegarem
	// ao Workflow.		

	//oProcess:cTo    :=  "marcelo@ravaembalagens.com.br"
	oProcess:cTo    := GetNewPar("MV_WQIP001",";inspecao@ravaembalagens.com.br")
	//oProcess:cTo    += ";jorge@ravaembalagens.com.br"
	//oProcess:cTo    += ";ronaldo.lisboa@ravaembalagens.com.br"
	//oProcess:cTo    += ";inspecao@ravaembalagens.com.br"
	//oProcess:cTo    += ";renata@ravaembalagens.com.br"
	//oProcess:cTo    += ";flavia.rocha@ravaembalagens.com.br" //retirar
	
	If nOpc = 1
		oProcess:cSubject := cMaq + " - Inspeções Realizadas - " + Dtoc(dDTMEDI) "
		oProcess:Start()
		WfSendMail()
		//msginfo("processo finalizado 1")  
	ElseIF nOpc = 2
		oProcess:cSubject := cMaq + " - Inspeções Não Realizadas - " + Dtoc(dDTMEDI) "
		oProcess:Start()
		WfSendMail()
		//msginfo("processo finalizado 2")  
	Endif
			
	// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
	// de destinatários.
	         

Endif  //len aDados

Return

***************************************************************
Static Function fDifData(dDataIni,dDataFim,cHoraIni,cHorafim )
***************************************************************

//ex: após a meia noite: fDifData( mv_par01,(mv_par01 + 1),cHoraIni3,cHoraFim3)     //ex: (17/03/11 , 18/03/11, "22:00:00", 03:00:00")
//ex: antes da meia noite: fDifData( mv_par01,(mv_par01 + 1),cHoraIni3,cHoraFim3)     //ex: (17/03/11 , 17/03/11, "22:00:00", 23:00:00")
Local nDifdia := 0
Local cMeiaNoite := "00:00:00"
Local cElap1
Local cHoraspassou := ""
Local nHoraspassou := 0
Local nHorastotal  := 0
Local lSemHrFIM    := .F.
Local lSemHrINI	   := .F.


set date brit

If !Empty(cHoraIni)
	If Len(cHoraIni) <= 5
		cHoraIni := cHoraIni + ":00"
	Endif
Else
	lSemHrINI := .T.
Endif	

If !Empty(cHoraFim)
	If Len(cHoraFim) <= 5
		cHoraFim := cHoraFim + ":00"
	Endif
Else
	lSemHrFIM := .T.
Endif	

nDifdia := (dDataFim - dDataIni)

If !lSemHrFIM .AND. !lSemHrINI
	If nDifdia = 0
	
		cElap1 := ElapTime( cHoraIni, cHoraFim ) // Resultado: "01:00:00"
		cHoraspassou := cElap1
		//msgbox("cElap1 = 0 : " + cHoraspassou)
		nHoraspassou := Val(Substr(cHoraspassou,1,2))
		nHoraspassou += Val(Substr(cHoraspassou,4,2) ) / 60
	
	Else
	
	
		cElap1 := ElapTime(cHoraIni,cMeiaNoite)
		cHoraspassou := cElap1
		//msgbox("cElap1: " + cHoraspassou)
		
		nHoraspassou := Val(Substr(cHoraspassou,1,2) )
		nHoraspassou += Val(Substr(cHoraspassou,4,2) ) / 60
		
		//msgbox("nHoras passou: " + str(nHoraspassou) )
		
		cElap1 := ElapTime(cMeiaNoite,cHoraFim) 
		//msgbox("cElap2: " + cElap1)
		cHorasPassou := cElap1
		nHoraspassou += Val(Substr(cHoraspassou,1,2) )
		nHoraspassou += Val(Substr(cHoraspassou,4,2) )  / 60
		//msgbox("nHoras passou: " + str(nHoraspassou) )
		
	Endif
Endif

/*
//carga horária já passada para hora/60:
T1: 7,08
T2: 7,08
T3: 6,5
*/
	
nHorastotal := nHoraspassou
//msgbox("horas passadas: " + str(nHorastotal) )


Return(nHorastotal)

****************************************
Static function CALCHR (cHoraGora, cInt) 
****************************************
//calcula a hora
//Local cHoragora := Time()
//Local cInt  := "00:20:00"
//Local cHRAntes:= ""
Local cHRAux  := ""
Local nInt  := 0
Local cH := ""  
Local H      := ""
Local M      := ""  
Local nM     := 0
Local S      := ""
Local cNovaH := ""    //é a hora início da inspeção

             //hora                          min                     seg
cHRAux := ( Val(Substr(cHoragora,1,2))  + (Val(Substr(cHoragora,4,2))/60) + Val(Substr(cHoragora,6,2)) ) //transforma a hora para valores numéricos

nInt := ( Val(Substr(cInt,1,2))  + (Val(Substr(cInt,4,2))/60) + Val(Substr(cInt,6,2)) ) //transforma o intervalo (caracter) em valores numéricos
cHRAux := cHRAux - nInt      //para que possa fazer a subtração do intervalo da hora atual, exemplo: 15:30 - 20 min = 15:20h


cH := Strzero(cHRAux,2)      //cH recebe o resultado da subtração
H := Substr(Alltrim(cH),1,2)        //reparto em H o valor da HOra
If !empty( Substr(Alltrim(cH),4,2) )
	M := '0.' + Substr(Alltrim(cH),4,2) //reparto em M o valor dos minutos
else
	//M := ":00"
Endif

nM:= Val(M) * 60                    //transformo de volta os minutos valor para min * 60 -> para virar caracter novamente
If Len(Str(nM)) >= 3
	cNovaH := H + ':' + Substr(Alltrim(Str(nM)),1,2)     //concateno H + : + M -> Hora : Minuto
Else
	cNovaH := H + ':' + Alltrim(Str(nM))     //concateno H + : + M -> Hora : Minuto
Endif

//msgbox( "agora ficou: " + cNovaH )


Return(cNovaH)

*****************************
Static Function FVerT2()    
*****************************
//QUERY PARA OBTER OS CÓDIGOS DAS MÁQUINAS QUE POSSUEM ESPECIFICAÇÃO NO SIGAQIP...	
Local cQuery := ""
Local LF     := CHR(13) + CHR(10)

cQuery := " Select * " + LF

cQuery += " from " + RetSqlName("SC2") + " SC2 " + LF  //--> Especificação das Operações
cQuery += " WHERE " + LF
cQuery += " SC2.D_E_L_E_T_ = '' "  + LF 
cQuery += " and SC2.C2_FILIAL = '" + xFilial("SC2") + "' " + LF
cQuery += " AND C2_OBSBLOQ LIKE '%WF-BLOQ Workflow - INSP.NAO REALIZADA%' " + LF //OPs bloqueadas por falta de inspeção
cQuery += " AND C2_BLOQUEA <> ''  " + LF
cQuery += " and C2_DATRF = '' " + LF
cQuery += " and C2_QUJE < C2_QUANT " + LF
cQuery += " and C2_FINALIZ = '' " + LF
MemoWrite("\Temp\WFQIP001_c2.SQL",cQuery)

If Select("TEMPX") > 0
	DbSelectArea("TEMPX")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "TEMPX"

TEMPX->( DbGotop() )
If !TEMPX->(EOF()) 
	While !TEMPX->(EOF())
		//FR - 28/04/14 - FABRICIO SOLICITOU QUE APÓS AS 14H, NÃO TEM PESSOAS NA INSPEÇÃO PARA QUE 
		//FAÇAM O REGISTRO DE INSPEÇÃO, ENTÃO, PARA QUE AS OPs NÃO FIQUEM BLOQUEADAS, EU IREI RODAR
		//AQUI O DESBLOQUEIO APÓS AS 14H PARA OPs que não POSSUEM REGISTRO INSPEÇÃO, 
		//PARA AS REPROVADAS, NÃO FAREI DESBLOQUEIO.
		DbselectArea("SC2")
		Dbsetorder(1)
		If SC2->(DBseek( xFilial("SC2") + TEMPX->C2_NUM ) ) 
				Reclock("SC2" , .F. )
				SC2->C2_BLOQUEA := ''
				SC2->C2_OBSBLOQ := "WF-DESBLOQ Workflow - 2o.TURNO - " + Dtoc(dDatabase) + " - " + Time()
				SC2->C2_NMBLOQ  := "Admin"
				SC2->(MsUnlock())
		Endif
		TEMPX->(Dbskip())
	Enddo
Endif                    
//alert("desbloqueio")
Return