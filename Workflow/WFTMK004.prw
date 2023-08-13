#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "ap5mail.ch"
#include "TbiConn.ch"


//-------------------------------------------------------------------------------
// WFTMK004 - Workflow para envio das NFs em Processo de Devolução 
//Objetivo: Utilizado pelo : SAC, LOGÍSTICA, FINANCEIRO
// Autoria: Flávia Rocha
// Data   : 14/11/13
//-------------------------------------------------------------------------------


****************************
User Function WFTMK004()
****************************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFTMK004"
  sleep( 5000 )
  conOut( "Programa WFTMK004 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  //Reset Environment  //DEIXEI NO FINAL DA FUNÇÃO
 
  
Else
  conOut( "Programa WFTMK003 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFTMK003 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return
                      

**********************
Static Function Exec()
**********************

Local oProcess, oHtml
Local cArqHtml:= ""
Local cAssunto:= ""
Local LF        := CHR(13)+CHR(10)
Local cQuery    := ""
Local cEmpresa  := ""


	
	//-------------------------------------------------------------------------------------
	// Iniciando o Processo WorkFlow de envio dos Processos Devolução x Status
	//-------------------------------------------------------------------------------------
	// Monte uma descrição para o assunto:
	cAssunto := "NFs Em Processo Devolução"
	cMsg     := "Segue(m) Abaixo, a(s) Nota(s) Fiscal(is) que estão em Processo de Devolução e Seu(s) Respectivo(s) Status:"
	// Informe o caminho e o arquivo html que será usado.
	cArqHtml := "\Workflow\http\oficial\WFTMK004.html"
	
	// Inicialize a classe de processo:
	oProcess := TWFProcess():New( "WFTMK004", cAssunto )
	
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask( "NF DEV", cArqHtml )
	
	// Informe o nome do shape correspondente a este ponto do fluxo:
	cShape := "INICIO"
	
	
	// Informe a função que deverá ser executada quando as respostas chegarem
	// ao Workflow.
	//oProcess:bReturn := "U_APCRetorno"
	oProcess:cSubject := cAssunto
	
	oHtml := oProcess:oHTML
	
	oHtml:ValByName("Cabeca",cAssunto)
	oHtml:ValByName("cMSG",cMsg)
	
			
/////REUNE OS DADOS PARA GERAR O HTML	
	cQuery := " SELECT " +LF
	cQuery += " Z10_FILIAL, Z10_STATUS, Z10_DTSTAT, Z10_HRSTAT, Z10_USER, Z10_NOMUSR, Z10_NF,Z10_SERINF, X5_DESCRI " + LF
	cQuery += " , A1_COD, A1_LOJA, A1_NOME, A1_MUN, A1_EST " + LF
	cQuery += " , F2_DOC, F2_SERIE, F2_EMISSAO, F2_DTEXP, F2_PREVCHG, F2_COND, F2_VALBRUT " + LF
	cQuery += " , E4_CODIGO, E4_DESCRI  " + LF  
	
	cQuery += " FROM " + RetSqlName("Z10") + " Z10 " + LF
	cQuery += "  ,   " + RetSqlName("SX5") + " X5  " + LF
	cQuery += "  ,   " + RetSqlName("SA1") + " A1  " + LF
	cQuery += "  ,   " + RetSqlName("SF2") + " F2  " + LF
	cQuery += "  ,   " + RetSqlName("SE4") + " E4  " + LF
	
	cQuery += " WHERE " + LF
	
	//associa as tabelas:
	//Z10 x SX5
	cQuery += " X5.X5_TABELA = 'ZG' " + LF
	cQuery += " AND X5.X5_CHAVE = Z10_STATUS " + LF
	cQuery += " AND Z10.Z10_FILIAL = X5.X5_FILIAL " + LF 
	
	//SF2 x Z10
	cQuery += " AND Z10.Z10_FILIAL = F2.F2_FILIAL " + LF
	cQuery += " AND Z10.Z10_NF = F2.F2_DOC " + LF
	cQuery += " AND Z10.Z10_SERINF = F2.F2_SERIE " + LF
	
	//SF2 x SA1
	cQuery += " AND F2.F2_CLIENTE = A1.A1_COD " + LF
	cQuery += " AND F2.F2_LOJA = A1.A1_LOJA " + LF
	
	//SF2 x SE4
	cQuery += " AND F2.F2_COND = E4.E4_CODIGO " + LF
	
	//SF2 x SX5
	cQuery += " AND F2.F2_FILIAL = X5.X5_FILIAL " + LF
	
	cQuery += " AND Z10.D_E_L_E_T_='' " + LF
	cQuery += " AND X5.D_E_L_E_T_='' " + LF
	cQuery += " AND A1.D_E_L_E_T_='' " + LF
	cQuery += " AND F2.D_E_L_E_T_='' " + LF
	cQuery += " AND E4.D_E_L_E_T_='' " + LF
	
	//cQuery += " AND Z10_STATUS <>
	
	
	cQuery += " ORDER BY Z10_FILIAL, Z10_NF " + LF
	

	Memowrite("C:\TEMP\WFTMK004.SQL",cQuery) 
	
	If Select("TMP1") > 0
		DbSelectArea("TMP1")
		DbCloseArea()	
	EndIf

	TCQUERY cQuery NEW ALIAS "TMP1" 
	TCSetField( "TMP1" , "F2_EMISSAO", "D")
	TCSetField( "TMP1" , "F2_PREVCHG", "D")
	TCSetField( "TMP1" , "F2_DTEXP", "D")
	TCSetField( "TMP1" , "Z10_DTSTAT", "D")

	TMP1->(DbGoTop())
	If !TMP1->(EOF())
	
		While TMP1->(!EOF())
		   /*
			PswOrder(1)
			If PswSeek( cSolic, .T. )											
			   aUsu   := PSWRET() 					
			   cNomSolic:= Alltrim( aUsu[1][2] )      
			   eEmail := Alltrim( aUsu[1][14] )  ///e-mail do solicitante   
			Endif
		  */ 
		  	cEmpresa := "" 
		  	DBSelectArea("SM0")
		  	SM0->(Dbseek( SM0->M0_CODIGO + TMP1->Z10_FILIAL ))
		  	cEmpresa := SM0->M0_FILIAL
			  //DADOS DA NF SAÍDA    
		      aadd( oHtml:ValByName("it.cFilial") , cEmpresa )        
		      aadd( oHtml:ValByName("it.cNFSER") , TMP1->F2_DOC + '/' + TMP1->F2_SERIE )        
		      aadd( oHtml:ValByName("it.dEmi")  , DTOC(TMP1->F2_EMISSAO) )      
		      //aadd( oHtml:ValByName("it.dExp")  , DTOC(TMP1->F2_DTEXP) )       
		      //aadd( oHtml:ValByName("it.dPrev") , DTOC(TMP1->F2_PREVCHG) )     
		      aadd( oHtml:ValByName("it.cCodCli"), TMP1->A1_COD + '/' + TMP1->A1_LOJA )         
		      aadd( oHtml:ValByName("it.cNomCli"), TMP1->A1_NOME )	       	
		      aadd( oHtml:ValByName("it.cLocali"), TMP1->A1_MUN )	       
		      aadd( oHtml:ValByName("it.cUF"),     TMP1->A1_EST )	       	
		      aadd( oHtml:ValByName("it.nValTot"), Transform( TMP1->F2_VALBRUT, "@E 999,999.99") )	      
		      aadd( oHtml:ValByName("it.cCondPG"), TMP1->E4_DESCRI )
		      //dados do processo Z10	 
		      aadd( oHtml:ValByName("it.cDescST"), TMP1->Z10_STATUS + '-' + TMP1->X5_DESCRI )	 		//descrição status
		      aadd( oHtml:ValByName("it.dDTST")  , DTOC(TMP1->Z10_DTSTAT ))	  	//data status
		      aadd( oHtml:ValByName("it.cHRST")  , TMP1->Z10_HRSTAT )	      	//hora status
		      cNomeUser := ""
		      If !Empty(TMP1->Z10_NOMUSR)
		      	aadd( oHtml:ValByName("it.cUserST")  , TMP1->Z10_NOMUSR )	      	//usuário que fez o registro
		      Else
		      	cNomeUser := NomeOp( TMP1->Z10_USER )
		      	aadd( oHtml:ValByName("it.cUserST")  , cNomeUser )	      	//usuário que fez o registro
		      Endif
		      	/*
		      	01    	OCORRENCIA INCLUIDA                                    
				02    	ENTRADA NF DEVOLUCAO                                   
				03    	RESPOSTA EFETUADA P/ SAC 
				04      BAIXA FINANCEIRO DA NFD                              
				*/
				If TMP1->Z10_STATUS = '01'
		      		aadd( oHtml:ValByName("it.cAguarda") , "Aguardando Resposta na Ocorrência" )     	//incluiu ocorrencia, o que falta fazer
		  		Elseif TMP1->Z10_STATUS = '02'
		  			aadd( oHtml:ValByName("it.cAguarda") , "Aguardando Entrada NFD")	      	//respondeu ocorrência, o que falta fazer
		  		Elseif TMP1->Z10_STATUS = '03'
		  			aadd( oHtml:ValByName("it.cAguarda") , "Aguardando Baixa do Financeiro" )	      	//deu entrada na NFD, o que falta fazer
		  		Elseif TMP1->Z10_STATUS = '04'
		  			aadd( oHtml:ValByName("it.cAguarda") , "Processo Finalizado OK" )	  //financeiro baixou, FIM    	
		  		Else                                                                            
		  			aadd( oHtml:ValByName("it.cAguarda") , "***" )	      	
		  		Endif
		      
			
			DbselectArea("TMP1")
			TMP1->(DBSKIP())
		
		Enddo
    
    Endif

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

oProcess:cTo := "daniela@ravaembalagens.com.br" 
oProcess:cTo += ";logistica@ravaembalagens.com.br" 
oProcess:cTo += ";contabilidade@ravaembalagens.com.br" 
oProcess:cTo += ";edna@ravaembalagens.com.br" 
oProcess:cTo += ";financeiro@ravaembalagens.com.br" 

oProcess:cTo += ";flavia.rocha@ravaembalagens.com.br" 

oHtml:ValByName("cUser",cNome)
oHtml:ValByName("cDepto",cDepto)
oHtml:ValByName("cMail",cMail)



// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
// de destinatários.
oProcess:Start()
WfSendMail()

Reset Environment

Return


***************

Static Function NomeOp( cOperado )

***************
Local cNome := ""

PswOrder(1)
If PswSeek( cOperado, .T. )
   aUsuarios  := PSWRET() 					
   //cNome := Alltrim(aUsuarios[1][2])     	// Nome do usuário
   cNome := Alltrim(aUsuarios[1][4])     	// Nome do usuário
Endif 

return cNome
