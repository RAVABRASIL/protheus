#Include "Rwmake.ch"
#Include "Topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "Ap5mail.ch"
#include  "Tbiconn.ch " 

/*/
//------------------------------------------------------------------------------------
//Programa: WFFIN001 
//Objetivo: Enviar e-mail avisando sobre títulos com mais de 120 dias vencido
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 06/06/12
//Chamado : 002534 - Ruben Castedo
//------------------------------------------------------------------------------------
/*/


********************************
User Function WFFIN001()
********************************


  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )
  f_120()      
  Reset Environment
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" 
  sleep( 5000 )
  f_120()      
  Reset Environment

Return

*****************************
Static Function f_120()  
*****************************

Local cQuery 	:= ""
Local LF      	:= CHR(13)+CHR(10)
Local cAvalTI   := ""
Local cAvalDIR  := ""
Local cAval     := ""
Local nItem     := 0
Local cEmpresa  := "" 
Local eEmail    := ""  //email das pessoas que receberão o relatório  

SetPrvt("OHTML,OPROCESS") 

If SM0->M0_CODFIL = '01'
	cEmpresa := SM0->M0_FILIAL
Else
	cEmpresa := "Rava Embalagens - " + SM0->M0_FILIAL
Endif

///títulos vencidos há mais de 120 dias (EXCETO 6DD) que irão para a COBRANÇA JURÍDICA 	
cQuery := " Select " + LF
cQuery += " VALOR = (CASE WHEN (SE1A.E1_PREFIXO = 'UNI' and LEN(RTRIM(SE1A.E1_NUM)) = 6 AND SE1A.E1_EMISSAO >= '20090401'  " + LF 
cQuery += "                                          OR ( SE1A.E1_PREFIXO = 'UNI' AND  SE1A.E1_NATUREZ = '21005') ) THEN 0                " + LF
cQuery += "                               ELSE  " + LF
cQuery += "                               CASE WHEN SE1A.E1_PREFIXO = 'UNI' and SE1A.E1_NATUREZ IN ('10101' , '40101') THEN SE1A.E1_SALDO  " + LF
cQuery += "                              else SE1A.E1_SALDO END END )   " + LF

cQuery += " ,CAST(CAST( '" + Dtos(dDatabase) + "' AS DATETIME) - CAST(SE1A.E1_VENCREA AS DATETIME)AS INTEGER) AS DIAS " + LF
cQuery += " ,SA1A.A1_COD, SA1A.A1_LOJA, SA1A.A1_NOME, SE1A.E1_EMISSAO, SE1A.E1_VENCTO, SE1A.E1_VENCREA, *  " + LF
cQuery += " FROM  "  + LF
cQuery += " " + RetSqlName("SE1") + " SE1A,  " + LF
cQuery += " " + RetSqlName("SA1") + " SA1A  " + LF
cQuery += " WHERE  " + LF

cQuery += " SE1A.E1_EMISSAO >= '20070101'   " + LF
cQuery += " AND SE1A.E1_CLIENTE = SA1A.A1_COD " + LF
cQuery += " AND SE1A.E1_LOJA = SA1A.A1_LOJA " + LF
cQuery += " AND SE1A.E1_SALDO > 0  " + LF
cQuery += " AND SE1A.E1_TIPO in ('NF','DP')  " + LF
cQuery += " AND SE1A.E1_PREFIXO <> ''  " + LF    //EXCETO 6DD
cQuery += " AND CAST(CAST( '" + Dtos(dDatabase) + "' AS DATETIME) - CAST(SE1A.E1_VENCREA AS DATETIME)AS INTEGER) >= 120 " + LF
cQuery += " AND SE1A.E1_FILIAL = '" + Alltrim(xFilial("SE1")) + "' " + LF
cQuery += " and SE1A.D_E_L_E_T_ = '' " + LF
cQuery += " Order by SE1A.E1_PREFIXO, SE1A.E1_NUM " + LF
MemoWrite("C:\Temp\WF120.SQL",cQuery)

If Select("TMPX") > 0
	DbSelectArea("TMPX")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "TMPX"

TCSetField( 'TMPX', "E1_EMISSAO", "D")
TCSetField( 'TMPX', "E1_VENCTO", "D")
TCSetField( 'TMPX', "E1_VENCREA", "D")

eEmail := "financeiro@ravaembalagens.com.br"
nItem  := 0
TMPX->( DbGotop() )
If !TMPX->(EOF())
	// Inicialize a classe de processo:
	oProcess:=TWFProcess():New("TITULOS_120","TITULOS_120")
	
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask('Inicio',"\workflow\http\oficial\WF120TIT.htm")
	oHtml   := oProcess:oHtml
	oHtml:ValByName("cEmpresa" , cEmpresa )                        
	Do While !TMPX->( Eof() ) 
		
		nItem++		
		aadd( oHtml:ValByName("it.nItem") , Alltrim(Str(nItem)) )
		aadd( oHtml:ValByName("it.cPref") , TMPX->E1_PREFIXO )
		aadd( oHtml:ValByName("it.cNum" ) , TMPX->E1_NUM )
		aadd( oHtml:ValByName("it.cParc" ) , TMPX->E1_PARCELA )
		aadd( oHtml:ValByName("it.dEmissao"), Dtoc(TMPX->E1_EMISSAO) )
		aadd( oHtml:ValByName("it.dVencRea" ), Dtoc(TMPX->E1_VENCREA) )
		aadd( oHtml:ValByName("it.cCli")  , Alltrim( TMPX->A1_COD + '/' + TMPX->A1_NOME) )  
		aadd( oHtml:ValByName("it.nDias")  , Alltrim(Str(TMPX->DIAS)) ) 

	    TMPX->(Dbskip())
	Enddo
	DbSelectArea("TMPX")
	DbCloseArea()	
	// Informe a função que deverá ser executada quando as respostas chegarem
	// ao Workflow.
	
	oProcess:cTo    :=  eEmail
	//oProcess:cTo      :=  "flavia.rocha@ravaembalagens.com.br"
	//oProcess:cCC	  := "flavia.rocha@ravaembalagens.com.br"
	oProcess:cBCC	  := ""
	//oProcess:bReturn  := "U_TMKRetorno()" 	//Não será necessária no novo fluxo
	oProcess:cSubject := "Encaminhar para Cobrança Jurídica - Mais de 120 Dias Vencidos - " + Dtoc(dDatabase) "
		
	// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
	// de destinatários.
	oProcess:Start()
	
	WfSendMail()
	
Endif

nItem := 0
///títulos vencidos há mais de 120 dias (APENAS 6DD) que irão para a COBRANÇA 6DD
cQuery := " Select " + LF
cQuery += " VALOR = (CASE WHEN (SE1A.E1_PREFIXO = 'UNI' and LEN(RTRIM(SE1A.E1_NUM)) = 6 AND SE1A.E1_EMISSAO >= '20090401'  " + LF 
cQuery += "                                          OR ( SE1A.E1_PREFIXO = 'UNI' AND  SE1A.E1_NATUREZ = '21005') ) THEN 0                " + LF
cQuery += "                               ELSE  " + LF
cQuery += "                               CASE WHEN SE1A.E1_PREFIXO = 'UNI' and SE1A.E1_NATUREZ IN ('10101' , '40101') THEN SE1A.E1_SALDO  " + LF
cQuery += "                              else SE1A.E1_SALDO END END )   " + LF

cQuery += " ,CAST(CAST( '" + Dtos(dDatabase) + "' AS DATETIME) - CAST(SE1A.E1_VENCREA AS DATETIME)AS INTEGER) AS DIAS " + LF
cQuery += " ,SA1A.A1_COD, SA1A.A1_LOJA, SA1A.A1_NOME, SE1A.E1_EMISSAO, SE1A.E1_VENCTO, SE1A.E1_VENCREA, *  " + LF
cQuery += " FROM  "  + LF
cQuery += " " + RetSqlName("SE1") + " SE1A,  " + LF
cQuery += " " + RetSqlName("SA1") + " SA1A  " + LF
cQuery += " WHERE  " + LF

cQuery += " SE1A.E1_EMISSAO >= '20070101'   " + LF
cQuery += " AND SE1A.E1_CLIENTE = SA1A.A1_COD " + LF
cQuery += " AND SE1A.E1_LOJA = SA1A.A1_LOJA " + LF
cQuery += " AND SE1A.E1_SALDO > 0  " + LF
cQuery += " AND SE1A.E1_TIPO in ('NF','DP')  " + LF
cQuery += " AND SE1A.E1_PREFIXO = ''  " + LF    //EXCETO 6DD
cQuery += " AND CAST(CAST( '" + Dtos(dDatabase) + "' AS DATETIME) - CAST(SE1A.E1_VENCREA AS DATETIME)AS INTEGER) >= 120 " + LF
cQuery += " AND SE1A.E1_FILIAL = '" + Alltrim(xFilial("SE1")) + "' " + LF
cQuery += " and SE1A.D_E_L_E_T_ = '' " + LF
cQuery += " Order by SE1A.E1_PREFIXO, SE1A.E1_NUM " + LF
MemoWrite("C:\Temp\WF1206D.SQL",cQuery)

If Select("TMPX") > 0
	DbSelectArea("TMPX")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "TMPX"

TCSetField( 'TMPX', "E1_EMISSAO", "D")
TCSetField( 'TMPX', "E1_VENCTO", "D")
TCSetField( 'TMPX', "E1_VENCREA", "D")


TMPX->( DbGotop() )
If !TMPX->(EOF())
	// Inicialize a classe de processo:
	oProcess:=TWFProcess():New("TITULOS_120","TITULOS_120")
	
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask('Inicio',"\workflow\http\oficial\WF120TIT6D.htm")
	oHtml   := oProcess:oHtml
	oHtml:ValByName("cEmpresa" , cEmpresa )                        
	Do While !TMPX->( Eof() ) 
		
		nItem++		
		aadd( oHtml:ValByName("it.nItem") , Alltrim(Str(nItem)) )
		aadd( oHtml:ValByName("it.cPref") , TMPX->E1_PREFIXO )
		aadd( oHtml:ValByName("it.cNum" ) , TMPX->E1_NUM )
		aadd( oHtml:ValByName("it.cParc" ) , TMPX->E1_PARCELA )
		aadd( oHtml:ValByName("it.dEmissao"), Dtoc(TMPX->E1_EMISSAO) )
		aadd( oHtml:ValByName("it.dVencRea" ), Dtoc(TMPX->E1_VENCREA) )
		aadd( oHtml:ValByName("it.cCli")  , Alltrim( TMPX->A1_COD + '/' + TMPX->A1_NOME) )  
		aadd( oHtml:ValByName("it.nDias")  , Alltrim(Str(TMPX->DIAS)) ) 

	    TMPX->(Dbskip())
	Enddo
	DbSelectArea("TMPX")
	DbCloseArea()	
	// Informe a função que deverá ser executada quando as respostas chegarem
	// ao Workflow.
	oProcess:cTo    :=  eEmail
	//oProcess:cTo      :=  "flavia.rocha@ravaembalagens.com.br"
	//oProcess:cCC	  := "flavia.rocha@ravaembalagens.com.br"
	oProcess:cBCC	  := ""
	//oProcess:bReturn  := "U_TMKRetorno()" 	//Não será necessária no novo fluxo
	oProcess:cSubject := "Encaminhar para Cobrança 6DD - Mais de 120 Dias Vencidos - " + Dtoc(dDatabase) "
		
	// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
	// de destinatários.
	oProcess:Start()
	
	WfSendMail()
	
Endif


Return