#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "ap5mail.ch"
#include "TbiConn.ch"


//-------------------------------------------------------------------------------
// WFLIC001 - Workflow para envio do relatório Status dos Editais (DIÁRIO)
// Solicitado pelo Projeto Licitação: Tópico 3.9
// STATUS : 10 - LICITAÇÃO SUSPENSA ou 12 - LICITAÇÃO CANCELADA
// Objetivo: Utilizado por: LICITAÇÃO
// Autoria: Flávia Rocha
// Data   : 03/03/2014
//-------------------------------------------------------------------------------


****************************
User Function WFLIC001()
****************************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFLIC001"    //SACOS
  sleep( 5000 )
  conOut( "Programa WFLIC001 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  //Reset Environment  //DEIXEI NO FINAL DA FUNÇÃO
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" FUNNAME "WFLIC001"    //CAIXAS
  sleep( 5000 )
  conOut( "Programa WFLIC001 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
   
  
Else
  conOut( "Programa WFLIC001 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFLIC001 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return
                      

**********************
Static Function Exec()
**********************

Local oProcess, oHtml
Local cArqHtml:= ""
Local cAssunto:= ""
Local cMail     := ""
Local cQuery := ""
Local LF     := CHR(13) + CHR(10) 
Local cArqHtml := ""
Local cEmpresa := ""
Local cCabeca  := ""
Local nTotGer1  := 0
Local nTotGer2  := 0
Local nTotGer3  := 0
Local nTotGer4  := 0
Local cSup      := ""
Local cMailSup  := ""

cQuery := "Select " + LF
cQuery += " * " + LF
cQuery += " From " + RetSqlName("Z17") + " Z17 " + LF //CABEÇALHO DO EDITAL
//cQuery += " , " + RetSqlName("Z18") + " Z18 " + LF
cQuery += " Where Z17.D_E_L_E_T_ = '' " + LF
cQuery += " and Z17.Z17_FILIAL = '" + Alltrim(xFilial("Z17")) + "' " +LF
//ASSOCIA COM ITENS DO EDITAL
//cQuery += " and Z18.Z18_FILIAL = Z17.Z17_FILIAL " + LF
//cQuery += " and Z18.Z18_CODEDI = Z17.Z17_CODIGO " + LF

//cQuery += " and Z17.Z17_CODIGO = '" + Alltrim(cEdital) + "' " + LF
cQuery += " and Z17.Z17_STATUS IN ('10', '12') " + LF     //10 - LICITAÇÃO SUSPENSA ou 12 - LICITAÇÃO CANCELADA
cQuery += " and Z17.Z17_FILIAL = '" + Alltrim(xFilial("Z17")) + "' " + LF
cQuery += " Order by Z17.Z17_CODIGO " + LF
MemoWrite("C:\TEMP\WFLIC001.SQL" , cQuery )

If Select("TEMP1") > 0
	DbSelectArea("TEMP1")
	DbCloseArea()	
EndIf                  
TCQUERY cQuery NEW ALIAS "TEMP1" 
TCSetField( "TEMP1" , "Z17_EMISS", "D")
TCSetField( "TEMP1" , "Z17_DTABER", "D")
If !TEMP1->(Eof())  
	cEmpresa := "" 
	DBSelectArea("SM0")
	SM0->(Dbseek( SM0->M0_CODIGO + TEMP1->Z17_FILIAL ))
	cEmpresa := SM0->M0_FILIAL

	//-------------------------------------------------------------------------------------
	// Iniciando o Processo WorkFlow de envio dos Processos Devolução x Status
	//-------------------------------------------------------------------------------------
	// Monte uma  descrição para o assunto:
	cCabeca  := "AVISO STATUS LICITAÇÃO"
	cAssunto := "Aviso Licitação - SUSPENSA/CANCELADA: " + Dtoc(dDatabase)
	cMsg     := "Os Seguintes Editais Estão com Status: 10 - LICITAÇÃO SUSPENSA ou 12 - LICITAÇÃO CANCELADA, Por Gentileza, Analisar e Proceder com Andamento:"
	// Informe o caminho e o arquivo html que será usado.
	cArqHtml := "\Workflow\http\oficial\WFLIC001.html"
		
	// Inicialize a classe de processo:
	oProcess := TWFProcess():New( "WFLIC001", cAssunto )
		
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask( "STATUS LICITACAO", cArqHtml )
		
	// Informe o nome do shape correspondente a este ponto do fluxo:
	cShape := "INICIO"
		
	// Informe a função que deverá ser executada quando as respostas chegarem
	// ao Workflow.
	//oProcess:bReturn := "U_APCRetorno"
	oProcess:cSubject := cAssunto
		
	oHtml := oProcess:oHTML
	
		
	oHtml:ValByName("Cabeca",cCabeca)
	oHtml:ValByName("cMSG",cMsg) 
	TEMP1->(Dbgotop())
	While !TEMP1->(EOF())
	
		cEmpresa := "" 
		DBSelectArea("SM0")
		SM0->(Dbseek( SM0->M0_CODIGO + TEMP1->Z17_FILIAL ))
		cEmpresa := SM0->M0_FILIAL
	
		 Aadd( oHtml:ValByName("it.cStatus") , TEMP1->Z17_STATUS + "-" + posicione('SX5',1,xFilial('SX5') + 'Z5' + TEMP1->Z17_STATUS , "X5_DESCRI" ) )     	      
	     Aadd( oHtml:ValByName("it.cFilial") , cEmpresa )          
	     Aadd( oHtml:ValByName("it.cEdital" ), TEMP1->Z17_CODIGO ) 
	     Aadd( oHtml:ValByName("it.cLicita" ), TEMP1->Z17_LICITA + '-' + posicione('Z15',1,xFilial('Z15') + TEMP1->Z17_LICITA , "Z15_NOMLIC" ) ) 
	     Aadd( oHtml:ValByName("it.dEmissao") , Dtoc(TEMP1->Z17_EMISS) ) 
	     Aadd( oHtml:ValByName("it.cHoraEmi") , TEMP1->Z17_HREMIS )      
   	     Aadd( oHtml:ValByName("it.dDTAber" ), Dtoc(TEMP1->Z17_DTABER) ) 
   	     Aadd( oHtml:ValByName("it.cHoraber") , TEMP1->Z17_HRABER )  
   	     Aadd( oHtml:ValByName("it.cUserInc") , TEMP1->Z17_USUARI )          
   	     Aadd( oHtml:ValByName("it.cModali" ), TEMP1->Z17_MODALI )      
   	     Aadd( oHtml:ValByName("it.cNroEdital") , TEMP1->Z17_NREDIT )      
   	     Aadd( oHtml:ValByName("it.cProcesso" ), TEMP1->Z17_PROCES )      
   	     Aadd( oHtml:ValByName("it.cSRP" ), TEMP1->Z17_SRP )      
   	     Aadd( oHtml:ValByName("it.cCondPag" ), TEMP1->Z17_CPAG )      
   	     Aadd( oHtml:ValByName("it.cPrzEnt" ), TEMP1->Z17_PRZENT )      
   	     Aadd( oHtml:ValByName("it.cValiProp") , TEMP1->Z17_VALPRO )      
		TEMP1->(Dbskip())
	Enddo  
	    
		cNome  := ""		
		cMail  := ""     
		cDepto := ""
		PswOrder(1)
		If PswSeek( '000000', .T. )
			aUsers := PSWRET() 						// Retorna vetor com informações do usuário	   
		   	cNome := Alltrim(aUsers[1][4])		// Nome completo do usuário logado
		   	cMail := Alltrim(aUsers[1][14])     // e-mail do usuário logado
			cDepto:= aUsers[1][12]  //Depto do usuário logado	
			//cSup	  := aUsu[1][11] //superior do usuário logado
		Endif
		
		
		oProcess:cTo := "" 
		oProcess:cTo += "licitacao@ravaembalagens.com.br"
		oProcess:cTo += ";licitacaosp@ravaembalagens.com.br"
		//oProcess:cTo += ";flavio@ravaembalagens.com.br" 
		oProcess:cTo += ";renata.aragao@ravaembalagens.com.br" 
		
		//oProcess:cTo := "" //retirar
		//oProcess:cTo += ";flavia.rocha@ravaembalagens.com.br" 
		
		oHtml:ValByName("cUser",cNome)
		oHtml:ValByName("cDepto",cDepto)
		oHtml:ValByName("cMail",cMail)
		
		
		
		// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
		// de destinatários.
		oProcess:Start()
		WfSendMail()
	

Endif //SE !EOF()



Reset Environment

Return

