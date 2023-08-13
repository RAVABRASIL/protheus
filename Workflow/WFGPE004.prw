#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "ap5mail.ch"
#include "TbiConn.ch"


//-------------------------------------------------------------------------------
// WFGPE004 - Workflow para envio do relatório ATOS INSEGUROS 
//Objetivo: Utilizado por: EQUIPE 5S
// Autoria: Flávia Rocha
// Data   : 03/01/14
//-------------------------------------------------------------------------------


****************************
User Function WFGPE004()
****************************
Private lDentroSiga := .F.
If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFGPE004"
  sleep( 5000 )
  conOut( "Programa WFGPE004 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  //Reset Environment  //DEIXEI NO FINAL DA FUNÇÃO
 
  
Else
  conOut( "Programa WFGPE004 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  lDentroSiga := .T.
  Exec()
EndIf
  conOut( "Finalizando programa WFGPE004 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return
                      

**********************
Static Function Exec()
**********************

Local oProcess, oHtml
Local cArqHtml:= ""
Local cAssunto:= ""
Local LF        := CHR(13)+CHR(10)
Local cQuery    := ""
Local aDad      := {}
Local cMail5S   := GetMV("RV_EQP5S") 
Local cResp     := ""   
Local dDTINCLU  := CTOD("  /  /    ")
Local dDTPREV  := CTOD("  /  /    ")
Local DATADE   := CTOD("  /  /    ")
Local DATATE   := CTOD("  /  /    ")
Local nMesatual:= Month(dDatabase) //pega o mês atual
Local nMesant  := nMesatual - 1                                                  
Local nAno     := 0 
Local cDestina := ""

If nMesatual = 1
	nAno := Year(dDatabase)
	DATADE := CTOD("01/" + alltrim(str(nMesant)) + "/" + Alltrim(str(nAno - 1)) )
Else
	DATADE := CTOD("01/" + alltrim(str(nMesant)) + "/" + str(year(dDatabase)) )
Endif
DATATE := LastDay(DATADE)
		
/////REUNE OS DADOS PARA GERAR O HTML
	//ato inseguro
	cQuery := " SELECT Z80_FILIAL FILIAL, Z80_DESC_S, Z80_CODMP, Z80_NUMSOL NUMSOL, Z80_QAPLIC " + LF
	cQuery += " , CAST(CAST(GETDATE() AS DATETIME) - CAST(Z80_DTPREV AS DATETIME)AS INTEGER) as DIASAB " +LF
	cQuery += " ,* " + LF
	
	cQuery += " FROM " + RetSqlName("Z80") + " Z80 " + LF	
	cQuery += " WHERE " + LF	
	cQuery += " Z80_TIPO = 'AI' " + LF    //ATO INSEGURO	
	cQuery += " AND Z80_EMISSA BETWEEN '" + Dtos(DATADE) + "' and '" + Dtos(DATATE)+ "' " + LF
	cQuery += " AND Z80.D_E_L_E_T_='' " + LF
	cQuery += " ORDER BY Z80_FILIAL, Z80_NUMSOL " + LF	

	Memowrite("C:\TEMP\WFGPE004.SQL",cQuery) 
	
	If Select("TMP1") > 0
		DbSelectArea("TMP1")
		DbCloseArea()	
	EndIf

	TCQUERY cQuery NEW ALIAS "TMP1" 
	TCSetField( "TMP1" , "Z80_EMISSA", "D")
	TCSetField( "TMP1" , "Z80_DTPREV", "D")
	TCSetField( "TMP1" , "Z80_DTSOL", "D")

	
	If !TMP1->(EOF())
		TMP1->(DbGoTop())
	    cNumSolant := ""
		While TMP1->(!EOF())
			
			cNumSol := TMP1->NUMSOL
			//If Alltrim(cNumSol) != Alltrim(cNumSolant)
			
				cEmpresa := "" 
			  	DBSelectArea("SM0")
			  	SM0->(Dbseek( SM0->M0_CODIGO + TMP1->FILIAL ))
			  	cEmpresa := SM0->M0_FILIAL 
			  	nDiasAB  := TMP1->DIASAB  //(dDatabase - TMP1->Z80_EMISSA)
			  	cArea    := ""
			  	SX5->(DBSETORDER(1))
				If SX5->(Dbseek(xFilial("SX5") + "5S" + TMP1->Z80_AREA))
					cArea := SX5->X5_DESCRI
				Endif  
				
				cDescAto := ""
				If !Empty(TMP1->Z80_DESC1)
					cDescAto := TMP1->Z80_DESC1 + ';' + CHR(13) + CHR(10)
				Endif
				
				If !Empty(TMP1->Z80_DESC2)
					cDescAto += TMP1->Z80_DESC2 + ';' + CHR(13) + CHR(10)
				Endif
				
				If !Empty(TMP1->Z80_DESC3)
					cDescAto += TMP1->Z80_DESC3 + ';' + CHR(13) + CHR(10)
				Endif
				
				If !Empty(TMP1->Z80_DESC4)
					cDescAto += TMP1->Z80_DESC4 + ';' + CHR(13) + CHR(10)
				Endif
				
				If !Empty(TMP1->Z80_DESC5)
					cDescAto += TMP1->Z80_DESC5 + ';' + CHR(13) + CHR(10)
				Endif
				
				If !Empty(TMP1->Z80_DESC6)
					cDescAto += TMP1->Z80_DESC6 + ';' + CHR(13) + CHR(10)
				Endif
				
				If !Empty(TMP1->Z80_DESC7)
					cDescAto += TMP1->Z80_DESC7 + ';' + CHR(13) + CHR(10)
				Endif
				
				If !Empty(TMP1->Z80_DESC8)
					cDescAto += TMP1->Z80_DESC8 + ';' + CHR(13) + CHR(10)
				Endif
				
				If !Empty(TMP1->Z80_DESC9)
					cDescAto += TMP1->Z80_DESC9 + ';' + CHR(13) + CHR(10)
				Endif
				
				If !Empty(TMP1->Z80_DESC10)
					cDescAto += TMP1->Z80_DESC10 + ';' + CHR(13) + CHR(10)
				Endif
				
				If !Empty(TMP1->Z80_DESC11)
					cDescAto += TMP1->Z80_DESC11 
				Endif
				
	            cNumSol := TMP1->NUMSOL
	            dDTINCLU:= TMP1->Z80_EMISSA
	            dDTPREV := TMP1->Z80_DTPREV
	            cNomeResp := TMP1->Z80_NOME1
				cNomeGest := TMP1->Z80_NOME2
				cQuemApl  := TMP1->Z80_QAPLIC
				/*
				cQuemApl  := ""
				If !Empty(TMP1->Z80_QAPLIC)
					PswOrder(2)
					If PswSeek( TMP1->Z80_QAPLIC )
						aUsers := PSWRET() 						// Retorna vetor com informações do usuário	   
					   	cQuemApl := Alltrim(aUsers[1][4])		// Nome completo do usuário logado
					   	//cMail := Alltrim(aUsers[1][14])     // e-mail do usuário logado
						//cDepto:= aUsers[1][12]  //Depto do usuário logado	
					Endif                      
				Endif
		        */
			  	Aadd(aDad , {cEmpresa,;        	//1
			  				dDTPREV,;			//2
			  				cNumSol,;			//3
			  				dDTINCLU,;          //4
			  				cNomeResp,;		    //5
			  				nDiasAB,;           //6
			  				cArea,;             //7
			  				TMP1->Z80_JUSTIF,;  //8
			  				cDescAto,;			//9
			  				cNomeGest,;          //10
			  				cQuemApl;			//11
			  					} ) 
			  	//cNumsolant := cNumSol
			//Endif	
			DbselectArea("TMP1")
			TMP1->(DBSKIP())
		
		Enddo
		aDad := Asort( aDad,,, { | x, y | x[ 5 ] + x[ 3 ]  <  y[ 5 ] + y[ 3 ]  } )
		
		//-------------------------------------------------------------------------------------
		// Iniciando o Processo WorkFlow de envio dos Processos Devolução x Status
		//-------------------------------------------------------------------------------------
		// Monte uma descrição para o assunto:
		cAssunto := "RELATORIO DOS ATOS INSEGUROS"
		
		cMsg     := "Segue(m) Abaixo, a Relação dos Atos Inseguros, Registrados pela Equipe 5S, Com Seus Respectivos Responsáveis e Gestores:"
		cMsg     += "<br>(Para os seguintes emails): " 
		cMsg     += "<br>equipe5s@ravaembalagens.com.br"
		cMsg     += "<br>marcelo@ravaembalagens.com.br"
		cMsg     += "<br>rh@ravaembalagens.com.br"
		cMsg     += "<br>"
		// Informe o caminho e o arquivo html que será usado.
		cArqHtml := "\Workflow\http\oficial\WFGPE004.html"
		
		// Inicialize a classe de processo:
		oProcess := TWFProcess():New( "WFGPE004", cAssunto )
		
		// Crie uma nova tarefa, informando o html template a ser utilizado:
		oProcess:NewTask( "WF 5S", cArqHtml )
		
		// Informe o nome do shape correspondente a este ponto do fluxo:
		cShape := "INICIO"
		
		
		// Informe a função que deverá ser executada quando as respostas chegarem
		// ao Workflow.
		//oProcess:bReturn := "U_APCRetorno"
		oProcess:cSubject := cAssunto
		
		oHtml := oProcess:oHTML
		
		oHtml:ValByName("Cabeca",cAssunto)
		oHtml:ValByName("cMSG",cMsg) 
		nItem := 1
		For x := 1 to Len(aDad)
			//DADOS DA SOLICITAÇÃO
			If x > 1
				If Alltrim(aDad[x,5]) != Alltrim(aDad[x-1,5])   //qdo mudar o responsável, reinicializa a numeração
					nItem := 1
				Endif
			Endif
		      aadd( oHtml:ValByName("it.cFilial") , aDad[x,1] )
		      aadd( oHtml:ValByName("it.cItem") , Alltrim(Str(nItem)) )  
		      aadd( oHtml:ValByName("it.dPrev") , Dtoc(aDad[x,2]) )        
		      aadd( oHtml:ValByName("it.cNumSol")  , aDad[x,3] )      
		      aadd( oHtml:ValByName("it.dDTINCLU")  , DTOC(aDad[x,4]) )       
		      aadd( oHtml:ValByName("it.cResp") , aDad[x,5] )     
		      aadd( oHtml:ValByName("it.cGestor") , aDad[x,10] )     
		      aadd( oHtml:ValByName("it.cDescSol"),     aDad[x,9] )	   
		      aadd( oHtml:ValByName("it.cQuemApl"),     aDad[x,11] )	   
		      nItem++
		Next
		cNome  := ""		
		cMail  := ""     
		cDepto := ""
		PswOrder(1)
		If PswSeek( '000000', .T. )
			aUsers := PSWRET() 						// Retorna vetor com informações do usuário	   
		   	cNome := Alltrim(aUsers[1][4])		// Nome completo do usuário logado
		   	cMail := Alltrim(aUsers[1][14])     // e-mail do usuário logado
			cDepto:= aUsers[1][12]  //Depto do usuário logado	
		Endif    
		
		cDestina := "equipe5s@ravaembalagens.com.br"
		cDestina += ";marcelo@ravaembalagens.com.br"
		cDestina += ";rh@ravaembalagens.com.br"
		cDestina += ";aline.farias@ravaembalagens.com.br"
		
		oProcess:cTo := cDestina
	
		//oProcess:cTo := ""  //retirar
		oProcess:cTo += ";flavia.rocha@ravaembalagens.com.br" 
		
		oHtml:ValByName("cUser",cNome)
		oHtml:ValByName("cDepto",cDepto)
		oHtml:ValByName("cMail",cMail)
		
		
		
		// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
		// de destinatários.
		oProcess:Start()
		WfSendMail()
		IF lDentroSiga
			MsgInfo("Você Recebeu o Relatório Por Email, Favor Verificar.")
		ENDIF
    
    Endif


If !lDentroSiga
	Reset Environment
Endif

Return


***************

Static Function NomeOp( cOperado )

***************
Local cNome := ""

PswOrder(1)
If PswSeek( cOperado, .T. )
   aUsuarios  := PSWRET() 					
   cNome := Alltrim(aUsuarios[1][4])     	// Nome do usuário
Endif 

return cNome
