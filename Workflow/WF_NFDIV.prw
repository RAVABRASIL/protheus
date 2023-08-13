#Include "Rwmake.ch"
#Include "Topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#include "Ap5mail.ch"
#include  "Tbiconn.ch " 

/*/
//------------------------------------------------------------------------------------
//Programa: WF_NFDIV 
//Objetivo: Enviar e-mail avisando sobre as notas de entrada que possuem divergência 
//          com os pedidos de compra
//Autoria : Flávia Rocha
//Empresa : RAVA
//Data    : 10/02/2012
//Chamado : 002416 - Ruben
//------------------------------------------------------------------------------------
/*/


********************************
User Function WF_NFDIV()
********************************

  //SACOS
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )
  f_NFDiv()      
  Reset Environment 
  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" 
  sleep( 5000 )
  f_NFDiv()      
  Reset Environment

Return

*****************************
Static Function f_NFDiv()  
*****************************

Local cQuery 	:= ""
Local LF      	:= CHR(13)+CHR(10) 
Local cMsg      := "" 
Local cNota     := ""
Local cNotaAnt  := ""
Local cEmpresa  := "" 
Local cEmail    := ""


SetPrvt("OHTML,OPROCESS") 

	
cQuery := " Select " + LF
cQuery += " F1_EMISSAO, F1_DOC, F1_SERIE, F1_ESPECIE, F1_TIPO, D1_PEDIDO, C7_NUM, F1_COND,C7_COND, D1_QUANT, C7_QUANT, D1_VUNIT, C7_PRECO " + LF
cQuery += " ,F1_VALFRET, C7_VALFRET " + LF
cQuery += " FROM " + RetSqlName("SF1") + " SF1, " + LF
cQuery += " "      + RetSqlName("SD1") + " SD1, " + LF
cQuery += " "      + RetSqlName("SC7") + " SC7 " + LF
cQuery += " WHERE " + LF 
cQuery += " D1_FILIAL = F1_FILIAL
cQuery += " AND D1_DOC = F1_DOC
cQuery += " AND D1_SERIE = F1_SERIE
cQuery += " AND C7_FILIAL = F1_FILIAL
cQuery += " AND F1_FILIAL = '" + Alltrim(xFilial("SF1") ) + "' " + LF
cQuery += " AND (D1_QUANT <> C7_QUANT OR D1_VUNIT <> C7_PRECO OR F1_VALFRET <> C7_VALFRET OR F1_COND <> C7_COND ) " + LF
cQuery += " AND SD1.D1_PEDIDO = SC7.C7_NUM " + LF
cQuery += " AND SD1.D1_FILIAL = SC7.C7_FILIAL " + LF
cQuery += " AND SF1.D_E_L_E_T_ = '' " + LF
cQuery += " AND SD1.D_E_L_E_T_ = '' " + LF
cQuery += " AND SC7.D_E_L_E_T_ = '' " + LF
cQuery += " AND  F1_EMISSAO BETWEEN '" + Dtos(dDatabase - 8) + "' AND '"+ Dtos(dDatabase) + "' " + LF //marco zero
cQuery += " ORDER BY SF1.F1_EMISSAO, SF1.F1_DOC, SF1.F1_SERIE " + LF

MemoWrite("C:\Temp\WF_NFDIV.SQL",cQuery)

If Select("CHTI") > 0
	DbSelectArea("CHTI")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "TMPX"

TCSetField( 'TMPX', "F1_EMISSAO", "D")

If SM0->M0_CODFIL = '01' 
	cEmpresa := SM0->M0_FILIAL
Else
	cEmpresa:= "Rava " + SM0->M0_FILIAL
Endif

TMPX->( DbGotop() )
If !TMPX->(EOF())
	// Inicialize a classe de processo:
	oProcess:=TWFProcess():New("NF_DIV","NF_DIV")
	
	// Crie uma nova tarefa, informando o html template a ser utilizado:
	oProcess:NewTask('Inicio',"\workflow\http\oficial\WF_NF_DIV.html")
	oHtml   := oProcess:oHtml

	Do While !TMPX->( Eof() ) 
		cNota := Alltrim(TMPX->F1_DOC)+ Alltrim(TMPX->F1_SERIE)
		cMsg := ""
		If cNotaAnt != cNota 
		
			oHtml:ValByName("cEmpresa" , cEmpresa )
			
			DbselectArea("SC7")
		    If TMPX->D1_QUANT != TMPX->C7_QUANT      //DIVERGÊNCIA QTDE
		    	cMsg += " - Quantidade"  + '<BR> ' + LF
		    Endif
						    
		    If TMPX->D1_VUNIT != TMPX->C7_PRECO  //DIVERGÊNCIA PREÇO
		       	cMsg += " - Preço" + '<BR> ' + LF
		    Endif
						    
		    If TMPX->F1_VALFRET != TMPX->C7_VALFRET  //DIVERGÊNCIA VALOR FRETE
		    	cMsg += " - Valor Frete"  + '<BR> ' + LF
		    Endif
						    
		    If Alltrim(TMPX->F1_COND) != Alltrim(TMPX->C7_COND)  //DIVERGÊNCIA COND.PAGTO
		    	cMsg += " - Cond. Pagto."  + '<BR> ' + LF
		    Endif		
		
			aadd( oHtml:ValByName("it.cNota") , Alltrim(TMPX->F1_DOC) + '/' + Alltrim(TMPX->F1_SERIE) )
			aadd( oHtml:ValByName("it.dEmissao") , Dtoc(TMPX->F1_EMISSAO) )
			aadd( oHtml:ValByName("it.cPC" ) , Alltrim(TMPX->C7_NUM)  )
			aadd( oHtml:ValByName("it.cDiverg" ) , cMsg )
			
			cNotaAnt := Alltrim(cNota)
		Endif
	
	    TMPX->(Dbskip())
	Enddo
	DbSelectArea("TMPX")
	DbCloseArea()	
	// Informe a função que deverá ser executada quando as respostas chegarem
	// ao Workflow.
	cEmail := "cintia@ravaembalagens.com.br"
	cEmail += ";ruben.castedo@ravaembalagens.com.br"
	//cEmail   := ""
	oProcess:cTo      :=  cEmail 
	//oProcess:cCC	  := "flavia.rocha@ravaembalagens.com.br"
	oProcess:cBCC	  := ""
	//oProcess:bReturn  := "U_TMKRetorno()" 	//Não será necessária no novo fluxo
	oProcess:cSubject := "NF's Entrada com Divergência x Pedido Compra - " + cEmpresa + "  - " + Dtoc(dDatabase) "
		
	// Neste ponto, o processo será criado e será enviada uma mensagem para a lista
	// de destinatários.
	oProcess:Start()
	
	WfSendMail()


Endif


Return