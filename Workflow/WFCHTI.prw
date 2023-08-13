#Include "Rwmake.ch"
#Include "Topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "Ap5mail.ch"
#include  "Tbiconn.ch " 

/*/
//------------------------------------------------------------------------------------
//Programa: WFCHTI 
//Objetivo: Enviar e-mail avisando sobre chamados sem avaliação pela DIR ou TI
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 27/01/12
//Chamado : 002296 - Marcelo
//------------------------------------------------------------------------------------
/*/


********************************
User Function WFCHTI()
********************************


  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )
  f_AvalCh()      
  Reset Environment

Return

*****************************
Static Function f_AvalCh()  
*****************************

Local cQuery 	:= ""
Local LF      	:= CHR(13)+CHR(10)
Local cAvalTI   := ""
Local cAvalDIR  := ""
Local cAval     := ""
Local nItem     := 0

SetPrvt("OHTML,OPROCESS") 

	
cQuery := " Select " + LF
cQuery += " Z12_PROJET, Z12_TAREFA CHAMADO, Z12_TIPO, Z12_COMPTI AVALTI, Z12_IMPDIR AVALDIR, Z12_UULTM SOLICITANTE " + LF
cQuery += " ,Z12_MEMO1, Z12_DTINC INCLUSAO " + LF
cQuery += " FROM " + RetSqlName("Z12") + " Z12 " + LF
cQuery += " WHERE Z12.D_E_L_E_T_ = '' " + LF
cQuery += " AND ( Z12_COMPTI = '' OR Z12_IMPDIR = '') " + LF

cQuery += " AND Z12_PROJET = '000061' " + LF
//cQuery += " and Z12_TAREFA = '002387' " + LF 
//cQuery += " AND Z12_STATUS <> '8' " + LF
//cQuery += " AND Z12_PRIORI <> 'ZZZZ' " + LF
cQuery += " AND Z12_DTCONC = '' " + LF
cQuery += " ORDER BY Z12_TAREFA " + LF

MemoWrite("C:\Temp\WFCHTI.SQL",cQuery)

If Select("CHTI") > 0
	DbSelectArea("CHTI")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "CHTI"

TCSetField( 'CHTI', "INCLUSAO", "D")


CHTI->( DbGotop() )
If !CHTI->(EOF())
	// Inicialize a classe de processo:
	oProcess:=TWFProcess():New("AVISO_CHAMADOS","AVISO_CHAMADOS")
	
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask('Inicio',"\workflow\http\oficial\WF_ChTI.html")
	oHtml   := oProcess:oHtml

	Do While !CHTI->( Eof() ) 
		cAvalTI := "Aguardando..."
		cAvalDIR:= "Aguardando..."
		If ! EMPTY(CHTI->Z12_TIPO) .AND. !EMPTY(CHTI->AVALDIR) .AND.! empty(CHTI->AVALTI)   // COMPLETAMENTE AVALIADO
		   cAval := "COMPLETAMENTE AVALIADO" //Return "BR_VERDE"
		   cAvalTI := "OK"
		   cAvalDIR:= "OK"
		ElseIf ! empty(CHTI->AVALTI) // AVALIADO PELO T.I
		   cAval := "AVALIADO PELO T.I." //Return "BR_AZUL"
		   cAvalTI := "OK"
		   cAvalDIR:= "Aguardando..."
		ElseIf ! EMPTY(CHTI->Z12_TIPO) .AND. !EMPTY(CHTI->AVALDIR) // AVALIADO PELA DIRETORIA
		   cAval := "AVALIADO PELA DIRETORIA" //Return "BR_AMARELO"
		   cAvalDIR := "OK"          
		   cAvalTI  := "Aguardando..."
		Endif
		
		cDescham:= MSMM( Posicione( "Z12", 1, xFilial("Z12") + CHTI->Z12_PROJET + CHTI->CHAMADO, "Z12_MEMO1" ) ) 
		nItem++		
		aadd( oHtml:ValByName("it.nItem") , Alltrim(Str(nItem)) )
		aadd( oHtml:ValByName("it.cChamad") , CHTI->CHAMADO )
		aadd( oHtml:ValByName("it.cDesCh" ) , cDescham )
		aadd( oHtml:ValByName("it.dInclu" ) , Dtoc(CHTI->INCLUSAO) )
		aadd( oHtml:ValByName("it.cSolicit"), CHTI->SOLICITANTE )
		aadd( oHtml:ValByName("it.cAvalTI" ), cAvalTI )
		aadd( oHtml:ValByName("it.cAvalDIR")  , cAvalDIR ) 

	    CHTI->(Dbskip())
	Enddo
	DbSelectArea("CHTI")
	DbCloseArea()	
	// Informe a função que deverá ser executada quando as respostas chegarem
	// ao Workflow.
	//oProcess:cTo      :=  "flavia.rocha@ravaembalagens.com.br"
	oProcess:cTo      :=  "marcelo@ravaembalagens.com.br;eurivan@ravaembalagens.com.br"
	//oProcess:cCC	  := "flavia.rocha@ravaembalagens.com.br"
	oProcess:cBCC	  := ""
	//oProcess:bReturn  := "U_TMKRetorno()" 	//Não será necessária no novo fluxo
	oProcess:cSubject := "Chamados TI - Aguardando Avaliação - " + Dtoc(dDatabase) "
		
	// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
	// de destinatários.
	oProcess:Start()
	
	WfSendMail()
	
	//msginfo("email enviado")

Endif


Return