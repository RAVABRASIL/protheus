#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "ap5mail.ch"
#include "TbiConn.ch"


//-------------------------------------------------------------------------------------------------
// WFGPE002 - Workflow para envio do relatório: CONDIÇÕES INSEGURAS NÃO SOLUCIONADAS NO PRAZO
//Objetivo: Utilizado por: EQUIPE 5S - SEMANAL
// Autoria: Flávia Rocha
// Data   : 19/11/13
//-------------------------------------------------------------------------------------------------


****************************
User Function WFGPE002()
****************************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFGPE002"
  sleep( 5000 )
  conOut( "Programa WFGPE002 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  //Reset Environment  //DEIXEI NO FINAL DA FUNÇÃO
 
  
Else
  conOut( "Programa WFGPE002 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFGPE002 em " + Dtoc( DATE() ) + ' - ' + Time() )

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


	
	
	
			
/////REUNE OS DADOS PARA GERAR O HTML
//condição insegura
	
	cQuery := " SELECT Z80_FILIAL FILIAL, YP_TEXTO, Z80_DESC_S, Z80_CODMP, Z80_NUMSOL NUMSOL " + LF
	cQuery += " , CAST(CAST(GETDATE() AS DATETIME) - CAST(Z80_DTPREV AS DATETIME)AS INTEGER) as DIASAB " +LF
	cQuery += " ,* " + LF
	
	cQuery += " FROM " + RetSqlName("Z80") + " Z80 " + LF
	//cQuery += " ,    " + RetSqlName("Z81") + " Z81 " + LF
	cQuery += " ,    " + RetSqlName("SYP") + " YP " + LF
	
	cQuery += " WHERE " + LF
	
	cQuery += " Z80_TIPO = 'CI' " + LF  //CONDIÇÃO INSEGURA
	cQuery += " AND Z80_EMISSA >= '20150301' " //PEDIDO DE ALINE FARIAS
	cQuery += " AND CAST(CAST(GETDATE() AS DATETIME) - CAST(Z80_DTPREV AS DATETIME)AS INTEGER) >= 1 " + LF
	cQuery += " AND Z80_DTSOL = '' " + LF
	//cQuery += " AND Z80_NUMSOL = Z81_NUMSOL " + LF
	cQuery += " AND YP_CHAVE = Z80_CODMP " + LF

	cQuery += " AND Z80.D_E_L_E_T_='' " + LF
	//cQuery += " AND Z81.D_E_L_E_T_='' " + LF
	cQuery += " AND YP.D_E_L_E_T_='' " + LF
	cQuery += " ORDER BY Z80_FILIAL, Z80_NUMSOL " + LF
	Memowrite("C:\TEMP\WFGPE002.SQL",cQuery) 
	
	If Select("TMP1") > 0
		DbSelectArea("TMP1")
		DbCloseArea()	
	EndIf

	TCQUERY cQuery NEW ALIAS "TMP1" 
	TCSetField( "TMP1" , "Z80_EMISSA", "D")
	TCSetField( "TMP1" , "Z80_DTPREV", "D")
	TCSetField( "TMP1" , "Z80_DTSOL", "D")

	TMP1->(DbGoTop())
	If !TMP1->(EOF())
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
				cResp   := ""
				cGestor := ""
				
				cGest   := substr(TMP1->Z80_INTEG2,1,6)  ////gestor
				cResp   := substr(TMP1->Z80_INTEGR,1,6) ////responsável
				nTam := Len(cGest)
				nConta := 0
				nPos := At("-",cGest)
				nConta := nPos + 1
				//a função AT retorna um valor numérico
				//que corresponde à posição do caracter especificado, ex; a vírgula
				//retornou a posição 5 que é a primeira vírgula q ele encontrou
				
			
				cNomeResp := NomeOp(cResp)
				cNomeGest := NomeOp(cGest)
	            cNumSol := TMP1->NUMSOL
	            dDTINCLU:= TMP1->Z80_EMISSA
	            dDTPREV := TMP1->Z80_DTPREV
	            //condição insegura
	            
			  	Aadd(aDad , {cEmpresa,;        	//1
			  				dDTPREV,;			//2
			  				cNumSol,;			//3
			  				dDTINCLU,;          //4
			  				cNomeResp,;			    //5
			  				nDiasAB,;           //6
			  				cArea,;             //7
			  				TMP1->Z80_JUSTIF,;  //8
			  				TMP1->YP_TEXTO,;	//9
			  				cNomeGest;           //10
			  					} ) 
			  	
			  	//cNumsolant := cNumSol
			//Endif	
			DbselectArea("TMP1")
			TMP1->(DBSKIP())
		
		Enddo
		
		//-------------------------------------------------------------------------------------
		// Iniciando o Processo WorkFlow de envio dos Processos Devolução x Status
		//-------------------------------------------------------------------------------------
		// Monte uma descrição para o assunto:
		cAssunto := "5S - Condições Inseguras em Aberto"
				
		cMsg     := "Segue(m) Abaixo, a Relação de Todas as Pendências dos Gestores e Seu(s) Respectivo(s) Status:"
		// Informe o caminho e o arquivo html que será usado.
		cArqHtml := "\Workflow\http\oficial\WFGPE002.html"
		
		// Inicialize a classe de processo:
		oProcess := TWFProcess():New( "WFGPE002", cAssunto )
		
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
		
		For x := 1 to Len(aDad)
			//DADOS DA SOLICITAÇÃO
		      aadd( oHtml:ValByName("it.cFilial") , aDad[x,1] ) 
		      aadd( oHtml:ValByName("it.dPrev") , Dtoc(aDad[x,2]) )        
		      aadd( oHtml:ValByName("it.cNumSol")  , aDad[x,3] )      
		      aadd( oHtml:ValByName("it.dDTINCLU")  , DTOC(aDad[x,4]) )       
		      aadd( oHtml:ValByName("it.cResp") , aDad[x,5] )     
		      aadd( oHtml:ValByName("it.cGestor") , aDad[x,10] )     
		      aadd( oHtml:ValByName("it.nDiasAB"), Str(aDad[x,6]) )         
		      aadd( oHtml:ValByName("it.cSenso"), aDad[x,7] )	       	
		      aadd( oHtml:ValByName("it.cFeedb"), aDad[x,8] )	       
		      aadd( oHtml:ValByName("it.cDescSol"),     aDad[x,9] )	   
		
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
		
		oProcess:cTo := cMail5S
		//oProcess:cTo := ""  //retirar
		//oProcess:cTo += ";flavia.rocha@ravaembalagens.com.br" 
		
		oHtml:ValByName("cUser",cNome)
		oHtml:ValByName("cDepto",cDepto)
		oHtml:ValByName("cMail",cMail)
				
		// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
		// de destinatários.
		oProcess:Start()
		WfSendMail()
    
    Endif



Reset Environment

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
