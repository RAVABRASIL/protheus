#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "ap5mail.ch"
#include "TbiConn.ch"


//----------------------------------------------------------------------------------------------
// WFLIC005 - Workflow para envio do relatório dos Editais Aproveitados / Rejeitados
// Solicitado pelo Projeto Licitação: Tópico 2.3
// Objetivo: Utilizado por: LICITAÇÃO
// Autoria: Flávia Rocha
// Data   : 20/03/2014
//-----------------------------------------------------------------------------------------------


****************************
User Function WFLIC005()
****************************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFLIC005"    //SACOS
  sleep( 5000 )
  conOut( "Programa WFLIC005 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  //Reset Environment  //DEIXEI NO FINAL DA FUNÇÃO
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" FUNNAME "WFLIC005"    //CAIXAS
  sleep( 5000 )
  conOut( "Programa WFLIC005 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
   
  
Else
  conOut( "Programa WFLIC005 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFLIC005 em " + Dtoc( DATE() ) + ' - ' + Time() )

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

cQuery := "SELECT * " + LF
//cQuery := "SELECT TOP * " + LF  //RETIRAR
cQuery += "FROM " + RetSqlname("Z57") + " Z57  " + LF
cQuery += "WHERE "   + LF
cQuery += "Z57.D_E_L_E_T_!='*' " + LF
cQuery += " and Z57.Z57_STATUS IN ('A', 'R') "  + LF 
cQuery += " AND Z57_CAPTUR <> '' " + LF    

//cQuery += " and Z57.Z57_CAPTUR BETWEEN '20140401' AND '20140430' " + LF //retirar depois, teste apenas

MemoWrite("C:\TEMP\WFLIC005.SQL" , cQuery )

If Select("TEMP1") > 0
	DbSelectArea("TEMP1")
	DbCloseArea()	
EndIf                  
TCQUERY cQuery NEW ALIAS "TEMP1" 
TCSetField( "TEMP1" , "Z57_ABERTU", "D")
TCSetField( "TEMP1" , "Z57_CAPTUR", "D")

If !TEMP1->(Eof())  
	cEmpresa := "" 
	DBSelectArea("SM0")
	SM0->(Dbseek( SM0->M0_CODIGO + TEMP1->Z57_FILIAL ))
	cEmpresa := SM0->M0_FILIAL

	//-------------------------------------------------------------------------------------
	// Iniciando o Processo WorkFlow de envio dos Processos Devolução x Status
	//-------------------------------------------------------------------------------------
	// Monte uma  descrição para o assunto:
	cCabeca  := "CAPTAÇÃO EDITAIS - Aproveitado/Rejeitado"
	cAssunto := "CAPTAÇÃO EDITAIS - Aproveitado/Rejeitado - " + Dtoc(dDatabase)
	cMsg     := "Seguem Abaixo, os Editais Captados Automaticamente e Seus Respectivos Status Participante:"
	// Informe o caminho e o arquivo html que será usado.
	cArqHtml := "\Workflow\http\oficial\WFLIC005.html"
		
	// Inicialize a classe de processo:
	oProcess := TWFProcess():New( "WFLIC005", cAssunto )
		
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask( "STATUS_EDITAIS", cArqHtml )
		
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
		SM0->(Dbseek( SM0->M0_CODIGO + TEMP1->Z57_FILIAL ))
		cEmpresa := SM0->M0_FILIAL
	    cStatus  := ""
	    
	    /*
	     aCores := {{"empty(TRB_STATUS) ", "BR_AMARELO" },;   //NÃO LIDO
            {"TRB_STATUS == 'L'", "BR_AZUL"    },;    //LIDO
            {"TRB_STATUS == 'D'", "BR_PRETO"    },;   //DUPLICADO
            {"TRB_STATUS == 'A'", "BR_VERDE"   },;    //APROVEITADO
            {"TRB_STATUS == 'R'", "BR_VERMELHO"    }} //REJEITADO
      */
      	If TEMP1->Z57_STATUS = 'A'
      		cStatus := "PARTICIPA"
      	Elseif TEMP1->Z57_STATUS = 'R'
      		cStatus := "NÃO PARTICIPA"
      	Endif
	
	     Aadd( oHtml:ValByName("it.cFilial") , cEmpresa )          
	     Aadd( oHtml:ValByName("it.cParticipa" ), cStatus ) 
	     Aadd( oHtml:ValByName("it.cCodigo" ), TEMP1->Z57_COD ) 
	     Aadd( oHtml:ValByName("it.cEmpresa") , TEMP1->Z57_NOME ) 
	     Aadd( oHtml:ValByName("it.cUF" ), TEMP1->Z57_UF )      
   	     Aadd( oHtml:ValByName("it.dDTABER") , DTOC(TEMP1->Z57_ABERTU) )      
   	     Aadd( oHtml:ValByName("it.cLicitante" ), TEMP1->Z57_LICITA )      
   	     Aadd( oHtml:ValByName("it.cEndereco" ), TEMP1->Z57_END )      
   	     Aadd( oHtml:ValByName("it.dDTCAP" ), DTOC(TEMP1->Z57_CAPTUR) )      
   	     Aadd( oHtml:ValByName("it.cEdital") , TEMP1->Z57_EDITAL )      
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
		
		//oProcess:cTo := ""  //retirar
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

