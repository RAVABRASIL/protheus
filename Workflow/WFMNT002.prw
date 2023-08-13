#Include "Rwmake.ch"
#Include "Topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "Ap5mail.ch"
#include  "Tbiconn.ch " 

/*/
//------------------------------------------------------------------------------------
//Programa: WFMNT002 
//Objetivo: ENVIAR EMAIL PARA MARCELO E MARCIO CASO AS 
//          OS DE SERVICO =000013 (LEMISTAS ) NAO FOREM ENCERRADAS EM 1 DIA.  
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 29/03/12
//Chamado : 002345 - Marcelo
//------------------------------------------------------------------------------------
/*/


********************************
User Function WFMNT002()
********************************


  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )
  f_Manut()      
  Reset Environment

Return

*****************************
Static Function f_Manut()  
*****************************

Local cQuery 	:= ""
Local LF      	:= CHR(13)+CHR(10)
Local nItem     := 0


SetPrvt("OHTML,OPROCESS") 

	                                                                                             //prevista  //real
cQuery := " Select TJ_FILIAL, T9_FILIAL, TJ_ORDEM, T9_NOME, TJ_SERVICO, TF_NOMEMAN , TJ_DTORIGI, TJ_DTMPINI, TJ_DTMRINI, TJ_DTMRFIM " + LF
//cQuery += " ,CAST(CAST( GETDATE() AS DATETIME)  - CAST(TJ_DTMPINI AS DATETIME) AS INTEGER) AS DIAS " + LF
cQuery += " ,DIAS = CASE WHEN TJ_DTMRINI <> '' THEN CAST(CAST( GETDATE() AS DATETIME)  - CAST(TJ_DTMRINI AS DATETIME) AS INTEGER) " + LF
cQuery += " ELSE CAST(CAST( GETDATE() AS DATETIME)  - CAST(TJ_DTMPINI AS DATETIME) AS INTEGER) END " + LF

cQuery += " , T9_CODBEM, TJ_CODBEM, TJ_TERMINO " + LF
cQuery += " FROM " + RetSqlName("STJ") + "  STJ, " + LF
cQuery += "      " + RetSqlName("ST9") + "  ST9,  " + LF
cQuery += "      " + RetSqlName("STF") + "  STF  " + LF
cQuery += " WHERE TJ_TERMINO <> 'S' " + LF
cQuery += " and TJ_SERVICO = '000013' " + LF   
// incluido por antonio pra ficar igual a tela de retorno de OS 
cQuery += " AND TJ_SITUACA = 'L' AND TJ_LUBRIFI <> 'S' " + LF

//cQuery += " AND CAST(CAST( GETDATE() AS DATETIME)  - CAST(TJ_DTMPINI AS DATETIME) AS INTEGER) >=2 " + LF
//cQuery += " AND CAST(CAST( GETDATE() AS DATETIME)  - CAST(TJ_DTMRINI AS DATETIME) AS INTEGER) >=2 " + LF
//cQuery += " and CASE WHEN TJ_DTMRINI <> '' THEN CAST(CAST( GETDATE() AS DATETIME)  - CAST(TJ_DTMRINI AS DATETIME) AS INTEGER) >=2 " + LF
//cQuery += " ELSE CAST(CAST( GETDATE() AS DATETIME)  - CAST(TJ_DTMPINI AS DATETIME) AS INTEGER) >= 2 END " + LF

cQuery += "  and ( CAST(CAST( GETDATE() AS DATETIME)  - CAST(TJ_DTMRINI AS DATETIME) AS INTEGER) >= 2  or " + LF
cQuery += "        CAST(CAST( GETDATE() AS DATETIME)  - CAST(TJ_DTMPINI AS DATETIME) AS INTEGER) >= 2 )   " + LF

cQuery += " AND TJ_DTORIGI >= '20120320' " + LF

cQuery += " AND TJ_CODBEM = T9_CODBEM " + LF
cQuery += " AND TF_CODBEM = T9_CODBEM " + LF
cQuery += " AND TJ_CODBEM = TF_CODBEM " + LF
cQuery += " AND TJ_SERVICO = TF_SERVICO " + LF


cQuery += " AND TJ_FILIAL = T9_FILIAL " + LF
cQuery += " AND TF_FILIAL = T9_FILIAL " + LF
cQuery += " AND TJ_FILIAL = TF_FILIAL " + LF
cQuery += " AND STJ.D_E_L_E_T_ = '' " + LF
cQuery += " AND STF.D_E_L_E_T_ = '' " + LF
cQuery += " AND ST9.D_E_L_E_T_ = '' " + LF
cQuery += " order by TJ_DTMPINI " + LF
MemoWrite("C:\Temp\WFMNT002.SQL",cQuery)

If Select("TMPX") > 0
	DbSelectArea("TMPX")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "TMPX"

TCSetField( 'TMPX', "TJ_DTORIGI", "D")
TCSetField( 'TMPX', "TJ_DTMRFIM", "D") 
TCSetField( 'TMPX', "TJ_DTMPINI", "D")
TCSetField( 'TMPX', "TJ_DTMRINI", "D")


TMPX->( DbGotop() )
If !TMPX->(EOF())
	// Inicialize a classe de processo:
	oProcess:=TWFProcess():New("MANUT_ATIVOS","MANUT_ATIVOS")
	
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask('Inicio',"\workflow\http\oficial\WFMNT002.htm")
	oHtml   := oProcess:oHtml

	Do While !TMPX->( Eof() ) 
	 If TMPX->DIAS >= 2
		nItem++		
		aadd( oHtml:ValByName("it.nItem") , Alltrim(Str(nItem)) )
		aadd( oHtml:ValByName("it.cNumOS") , TMPX->TJ_ORDEM )
		aadd( oHtml:ValByName("it.cDescBem" ) , TMPX->T9_NOME )
		aadd( oHtml:ValByName("it.cServico" ) , TMPX->TJ_SERVICO + ' - ' + TMPX->TF_NOMEMAN )
		aadd( oHtml:ValByName("it.DtInclu" ) , Dtoc(TMPX->TJ_DTORIGI) )
		aadd( oHtml:ValByName("it.PrvIni" ) , Dtoc(TMPX->TJ_DTMPINI) )   //dt prevista de início
		aadd( oHtml:ValByName("it.DtIni" ) , Dtoc(TMPX->TJ_DTMRINI) )    //dt real início
		aadd( oHtml:ValByName("it.nDias" ) , Str(TMPX->DIAS) )
		aadd( oHtml:ValByName("it.DtFim" ) , Dtoc(TMPX->TJ_DTMRFIM) )
	 Endif
	    TMPX->(Dbskip())
	Enddo
	DbSelectArea("TMPX")
	DbCloseArea()	
	// Informe a função que deverá ser executada quando as respostas chegarem
	// ao Workflow.
	//oProcess:cTo      :=  ""
	oProcess:cTo      :=  "marcelo@ravaembalagens.com.br;miranildo@ravaembalagens.com.br;marcio@ravaembalagens.com.br;robinson@ravaembalagens.com.br"
	oProcess:cCC	  := ""
	//oProcess:cBCC	  := "flavia.rocha@ravaembalagens.com.br"
	//oProcess:bReturn  := "U_TMKRetorno()" 	//Não será necessária no novo fluxo
	oProcess:cSubject := "OS's Serviço 000013 - Com mais de 1 dia em aberto - " + Dtoc(dDatabase) "
		
	// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
	// de destinatários.
	If nItem > 0
		oProcess:Start()
	   	WfSendMail()
	Endif
	//msginfo("email enviado")

Endif


Return