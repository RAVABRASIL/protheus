#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "ap5mail.ch"
#include "TbiConn.ch"


//-------------------------------------------------------------------------------
// WFFIN003 - Workflow para envio dos Títulos A Pagar 
//Objetivo: Utilizado pelo : FINANCEIRO, CONTROLLER
// Autoria: Flávia Rocha
// Data   : 28/01/2014
//-------------------------------------------------------------------------------


****************************
User Function WFFIN003()
****************************

If Select( 'SX2' ) == 0
	//plásticos
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFIN003"
  sleep( 5000 )
  conOut( "Programa WFFIN003 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  //Reset Environment  //DEIXEI NO FINAL DA FUNÇÃO   
  
  //caixas
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" FUNNAME "WFFIN003"
  sleep( 5000 )
  conOut( "Programa WFFIN003 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  //Reset Environment  //DEIXEI NO FINAL DA FUNÇÃO
 
  
Else
  conOut( "Programa WFFIN003 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFFIN003 em " + Dtoc( DATE() ) + ' - ' + Time() )

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
Local nTOTGER1  := 0
Local nTOTGER2  := 0
Local nTOTGER3  := 0 


	
	//-------------------------------------------------------------------------------------
	// Iniciando o Processo WorkFlow de envio dos Processos Devolução x Status
	//-------------------------------------------------------------------------------------
	// Monte uma descrição para o assunto:
	
	cMsg     := "Segue(m) Abaixo, o(s) Titulo(s) a Pagar: <br><br>" + LF
	cMsg     += "PARÂMETROS: <BR>" + LF
	cMsg     += "Prefixo   : Diferente de: 'branco' <br>" + LF //"Três espaços em branco(títulos do caixa especial);<br>" + LF
    cMsg     += "Natureza  : Diferente de: 20115(comissões);<br>" + LF
	cMsg     += "Tipo      : Diferente de: GCT,PR,PA e TX (previsões,adiantamentos e taxas); <br> " + LF
    cMsg     += "Vencimento: De: 01/01/2013 Até " + Dtoc(dDatabase - 1) + ";<br>" + LF
	cMsg     += "Emissão   : De: 01/01/2012 Até " + Dtoc(dDatabase - 1) + "."
	// Informe o caminho e o arquivo html que será usado.
	cArqHtml := "\Workflow\http\oficial\WFFIN003.html"
	
	// Inicialize a classe de processo:
	oProcess := TWFProcess():New( "WFFIN003", cAssunto )
	
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask( "TIT PAG", cArqHtml )
	
	// Informe o nome do shape correspondente a este ponto do fluxo:
	cShape := "INICIO"
	
	
	// Informe a função que deverá ser executada quando as respostas chegarem
	// ao Workflow.
	//oProcess:bReturn := "U_APCRetorno"

	oHtml := oProcess:oHTML
	
	
	oHtml:ValByName("cMSG",cMsg)
	
			
/////REUNE OS DADOS PARA GERAR O HTML	
	cQuery := " SELECT * " +LF

	
	cQuery += " FROM " + RetSqlName("SE2") + " SE2 " + LF
	cQuery += "  ,   " + RetSqlName("SA2") + " SA2  " + LF
	cQuery += "  ,   " + RetSqlName("SED") + " SED  " + LF

	cQuery += " WHERE " + LF
	
	//associa as tabelas:
	cQuery += " SE2.E2_FORNECE = SA2.A2_COD " + LF
	cQuery += " AND SE2.E2_LOJA = SA2.A2_LOJA " + LF
	cQuery += " AND SE2.E2_NATUREZ = SED.ED_CODIGO " + LF                   
	
	cQuery += " AND SE2.E2_FILIAL = '" + Alltrim(xFilial("SE2")) + "' " + LF
	
	//FILTRO:
	/*
	Prefixo: três espaços em branco(títulos do caixa especial)
	Natureza :20115(comissões)	
	Tipo:DIFERENTES DE: GCT,PR,PA E TX (previsões,adiantamentos e taxas)
	Parametros:	
	Vencimento: de 01/01/13 até o dia anterior, exemplo :amanhã precisamos do relatório de vencidos até hoje 23/01	
	Emissão de 01/01/12 até a data igual do vencimento.
	*/                                                          
	cQuery += " AND SE2.E2_PREFIXO <> '   ' " + LF
	cQuery += " AND SE2.E2_NATUREZ <> '20115' " + LF
	cQuery += " AND SE2.E2_TIPO NOT IN ('GCT','PR','PA','TX') " + LF
	cQuery += " AND SE2.E2_VENCREA BETWEEN '20130101' AND '" + DTOS(dDatabase - 1) + "' " + LF
	cQuery += " AND SE2.E2_EMISSAO BETWEEN '20120101' AND '" + DTOS(dDatabase - 1) + "' " + LF
	cQuery += " AND SE2.E2_SALDO > 0 " + LF
	
	
	cQuery += " AND SE2.D_E_L_E_T_='' " + LF
	cQuery += " AND SA2.D_E_L_E_T_='' " + LF
	cQuery += " AND SED.D_E_L_E_T_='' " + LF

	
	cQuery += " ORDER BY SE2.E2_FILIAL, SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA " + LF
	

	Memowrite("C:\TEMP\WFFIN003.SQL",cQuery) 
	
	If Select("TMP1") > 0
		DbSelectArea("TMP1")
		DbCloseArea()	
	EndIf

	TCQUERY cQuery NEW ALIAS "TMP1" 
	TCSetField( "TMP1" , "E2_EMISSAO", "D")
	TCSetField( "TMP1" , "E2_VENCREA", "D")
	TCSetField( "TMP1" , "E2_VENCTO", "D")

	TMP1->(DbGoTop())
	If !TMP1->(EOF())
	
		While TMP1->(!EOF())
		  
		  	cEmpresa := "" 
		  	DBSelectArea("SM0")
		  	SM0->(Dbseek( SM0->M0_CODIGO + TMP1->E2_FILIAL ))
		  	cEmpresa := SM0->M0_FILIAL
		  	
		  	/*
		  		<td width="142" align="left">%it.cCodFor%</td>
				<td width="142" align="left">%it.cNomeFor%</td>
    			<td width="142" align="left">%it.cPrefNum%</td>
    			<td width="192" align="left">%it.cParcela%</td>
				<td width="492" align="left">%it.cTipo%</td>
          		<td width="492" align="left">%it.cNaturez%</td>
          		<td width="192" align="left">%it.dEmissao%</td>
          		<td width="192" align="left">%it.dVencto%</td>
          		<td width="492" align="center">%it.dVencRea%</td>
          		<td width="492" align="center">%it.nValOri%</td>
          		<td width="192" align="center">%it.nValNom%</td>
          		<td width="192" align="center">%it.nValCorr%</td>
          		<td width="492" align="center">%it.nValNom2%</td>
          		<td width="492" align="center">%it.cPortado%</td>
          		<td width="492" align="center">%it.nValJur%</td>
          		<td width="492" align="center">%it.nDias%</td>
          		<td width="492" align="center">%it.cHist%</td>
		  	*/
			  //DADOS DA NF SAÍDA    
		      aadd( oHtml:ValByName("it.cFilial")   , cEmpresa )        
		      aadd( oHtml:ValByName("it.cCodFor")   , TMP1->E2_FORNECE + '/' + TMP1->E2_LOJA )        
		      aadd( oHtml:ValByName("it.cNomeFor")  , TMP1->A2_NOME )        
		      aadd( oHtml:ValByName("it.cPrefNum")  , TMP1->E2_PREFIXO + '-' + TMP1->E2_NUM )      
		      aadd( oHtml:ValByName("it.cParcela")  , TMP1->E2_PARCELA )       
		      aadd( oHtml:ValByName("it.cTipo")     , TMP1->E2_TIPO )     
		      aadd( oHtml:ValByName("it.cNaturez")  , TMP1->E2_NATUREZ )         
		      aadd( oHtml:ValByName("it.dEmissao")  , DTOC(TMP1->E2_EMISSAO) )	       	
		      aadd( oHtml:ValByName("it.dVencto")   , DTOC(TMP1->E2_VENCTO)  )	       
		      aadd( oHtml:ValByName("it.dVencRea")  , DTOC(TMP1->E2_VENCREA) )	       	
		      aadd( oHtml:ValByName("it.nValOri")   , Transform( TMP1->E2_VALOR, "@E 999,999.99") )	      
		      aadd( oHtml:ValByName("it.nValNom")   , Transform( TMP1->E2_SALDO, "@e 999,999.99") )
		      aadd( oHtml:ValByName("it.nValCorr")  , Transform( (TMP1->E2_SALDO + TMP1->E2_VALJUR) , "@E 999,999.99") )
		      //aadd( oHtml:ValByName("it.nValNom2"), TMP1->E4_DESCRI )
		      aadd( oHtml:ValByName("it.cPortado")  , TMP1->E2_PORTADO )
		      aadd( oHtml:ValByName("it.nValJur")   , Transform(TMP1->E2_VALJUR, "@E 999,999.99") )
		      aadd( oHtml:ValByName("it.nDias")     , Transform( (dDatabase - TMP1->E2_VENCREA) , "@E 99999") )
		      aadd( oHtml:ValByName("it.cHist")     , TMP1->E2_HIST )
		      
			  nTOTGER1 += TMP1->E2_VALOR
			  nTOTGER2 += TMP1->E2_SALDO
			  nTOTGER3 += (TMP1->E2_SALDO + TMP1->E2_VALJUR)
			DbselectArea("TMP1")
			TMP1->(DBSKIP())
		
		Enddo
		cAssunto := "Títulos a Pagar - " + cEmpresa 
		oHtml:ValByName("Cabeca",cAssunto)
		oHtml:ValByName("nTOTGER1",Transform(nTOTGER1 , "@E 99,999,999.99")) //TOTAL GERAL VALOR ORIGINAL
		oHtml:ValByName("nTOTGER2",Transform(nTOTGER2 , "@E 99,999,999.99")) //TOTAL GERAL SALDO
		oHtml:ValByName("nTOTGER3",Transform(nTOTGER3 , "@E 99,999,999.99")) //TOTAL GERAL SALDO + JUROS

		
		oProcess:cSubject := cAssunto
		
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
		
		oProcess:cTo := ""  //"humberto.filho@ravaembalagens.com.br" 
		oProcess:cTo += ";deise@ravaembalagens.com.br" 
		oProcess:cTo += ";financeiro@ravaembalagens.com.br" 
		//oProcess:cTo += ";giordano@ravaembalagens.com.br" 
		oProcess:cTo += ";wagner.cabral@ravaembalagens.com.br" //FR - 19/05/14
		
		//oProcess:cTo := "" //retirar
		//oProcess:cTo += ";flavia.rocha@ravaembalagens.com.br" 
		
		oHtml:ValByName("cUser",cNome)
		oHtml:ValByName("cDepto",cDepto)
		oHtml:ValByName("cMail",cMail)
		
		
		
		// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
		// de destinatários.
		oProcess:Start()
		WfSendMail()

    //Else
    //	alert("sem dados!")
    Endif


Reset Environment

Return

