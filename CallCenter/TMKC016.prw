#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#Include 'Topconn.ch'
#include "ap5mail.ch"


*****************************************************************************************************************************

User Function FREnvMail( dPrevCheg, dAgcli, cDocto, cSeriNF, dEmiNF, cEntidade, cSUCChave, cUCFilial, cNomTransp, cTelTransp, nOpt )
*****************************************************************************************************************************
///CHAMADO DENTRO DO U_TK271FIMGR

//Local cEmailTo  	:= "flavia.rocha@ravaembalagens.com.br"
Local cEmailTo		:= "" //"posvendas@ravaembalagens.com.br;financeiro@ravaembalagens.com.br"
Local cEmailCc  	:= ""
Local lResult   	:= .F.
Local cError    	:= "ERRO NO ENVIO DO EMAIL"
Local cUser
Local nAt      
Local cMsg      	:= ""
Local cAccount		:= GetMV( "MV_RELACNT" )
Local cPassword	    := GetMV( "MV_RELPSW"  )
Local cServer		:= GetMV( "MV_RELSERV" )
Local cAttach 		:= ""
Local cAssunto		:= "" //iif(nOpt == 1, "Aviso de reten��o em posto fiscal", "Aviso de reagendamento")
Local cFrom			:= GetMV( "MV_RELACNT" )
Local cContato		:= ""       
Local cA1Nreduz		:= ""
Local cA1NOME       := ""
Local cA1Mail		:= ""
Local cVendedor		:= ""
Local cSuper	:= ""
Local cMailSuper:= ""
Local cUF		:= ""
Local dUFChg    := Ctod("  /  /    ")




//�������������������������������������������������������������������������������Ŀ
//�Envia o e-mail para a lista selecionada. Envia como CC                         �
//���������������������������������������������������������������������������������
If nOpt = 1 
	cAssunto := "Aviso de reten��o em posto fiscal"
Elseif nOpt = 2
	cAssunto := "Aviso de reagendamento"
//Else
	//cAssunto := "Posto Fiscal - Aviso p/ Log�stica"  //desabilitado por solicita��o de Daniela no chamado 002197
Else	  //Fl�via Rocha - 03/08/2011 - solicitado por Daniela - chamado 002197
	
	cAssunto := "Chegada na UF Destino - Aviso p/ LOG�STICA"
Endif

cEmailCc := ""                                  
                                                                      
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult
DbselectArea("SA1")
Dbsetorder(1)
SA1->(Dbseek(xFilial("SA1") + cSUCChave ))
cA1Mail		:= SA1->A1_EMAIL
cA1Nreduz	:= SA1->A1_NREDUZ
cContato	:= SA1->A1_CONTATO
//cVendedor	:= SA1->A1_VEND
cA1NOME     := SA1->A1_NOME

//FR - 27/06/2011 - CHAMADO 002179 - DANIELA - COPIAR O COORDENADOR RESPECTIVO DO VENDEDOR NA NF 
//NO ENVIO DOS EMAILS DE RETEN��O E AGENDAMENTO
SF2->(Dbsetorder(1))
If SF2->(Dbseek(xFilial("SF2") + cDocto + cSeriNF ))
	cVendedor	:= SF2->F2_VEND1
	cUF			:= SF2->F2_EST
	dUFChg      := SF2->F2_UFCHG
Endif

SA3->(Dbsetorder(1))
If SA3->(Dbseek(xFilial("SA3") + cVendedor ))
	cSuper 		:= SA3->A3_SUPER
	cMailVend	:= SA3->A3_EMAIL
Endif

SA3->(Dbsetorder(1))
If SA3->(Dbseek(xFilial("SA3") + cSuper ))
	cMailSuper := SA3->A3_EMAIL
	//por solicita��o de Daniela em 17/08/11 - incluir os supervisores de venda na c�pia
	/*
	If Alltrim(cSuper) = '0229'
		cMailSuper += ";janaina@ravaembalagens.com.br"
	Elseif Alltrim(cSuper) = '0245'
		cMailSuper += ";marcos@ravaembalagens.com.br"
	Elseif Alltrim(cSuper) = '0248'
		cMailSuper += ";josenildo@ravaembalagens.com.br"
	Endif
	*/
Endif
//FR - at� aqui 
cMailSuper += ";comercial@ravaembalagens.com.br"

//If nOpt = 1 .or. nOpt = 2
	//cEmailTo := "sac@ravaembalagens.com.br;posvendas@ravaembalagens.com.br;financeiro@ravaembalagens.com.br"
	cEmailTo := "sac@ravaembalagens.com.br;financeiro@ravaembalagens.com.br"
	//Flavia Rocha - 11/05/12 - Solicitado por Daniela retirar o email posvendas e deixar apenas o SAC
	
	if empty(SA1->A1_EMAIL)
	   cMsg := "<b>O EMAIL DO CLIENTE EST� EM BRANCO! ELE N�O RECEBER� ESTE INFORMATIVO. </b><br> <br> "
	Else
		cEmailTo	+= ";" + cA1Mail	
	endif	

	If !Empty(cMailVend)
		cEmailTo += ";" + cMailVend //SA3->A3_EMAIL           //Flavia Rocha - Chamado 001272 - Daniela - Solicitou incluir o email do representante/vendedor para tamb�m receber este e-mail
	Endif
	
	If !Empty(cMailSuper)
		cEmailTo += ";" + cMailSuper
	Endif
 
//Else
//	cEmailTo := "posvendas@ravaembalagens.com.br;alexandre@ravaembalagens.com.br;joao.emanuel@ravaembalagens.com.br"
	//cEmailTo := "flavia.rocha@ravaembalagens.com.br
	
//Endif
cEmailCc := ""  //"flavia.rocha@ravaembalagens.com.br




cMsg += "<p align='justify'>Cabedelo, "+ alltrim( str( day( dDataBase ) ) ) +" de "+mesextenso()+" de "+alltrim( str( year(dDataBase ) ) ) +", <br> <br> <br> "
//CHAMADO 1960 - ALTERAR DE: P�S VENDAS PARA: SAC
//cMsg += "De: Rava Embalagens - P�s-Vendas <br> <br>"
cMsg += "De: Rava Embalagens - SAC <br> <br>"


if nOpt == 1            //Reten��o
	
	cMsg += "Para: "+alltrim( cA1NOME )+" <br> <br>"
	cMsg += "A/c: " + alltrim( cContato ) + " <br> <br>"
	cMsg += "INFORMATIVO <br> <br>"

	cMsg += "Informamos que o material referente a nota fiscal " + cDocto + ", emitida em " + dtoc( dEmiNF ) + ", encontra-se no dep�sito <br>"
	cMsg += "da transportadora "+alltrim( cNomTransp )+", em raz�o da NF est� retida no Posto fiscal do seu Estado. <br> <br>"
	//cMsg += "Pedimos que entre em contato com a transportadora atrav�s dos telefones " + alltrim( cTelTransp ) + ", <br>" //FR - 04/04/13 - SOLICITADO POR DANIELA
	cMsg += "Pedimos que entre em contato com a SECRETARIA DA FAZENDA para maiores esclarecimentos e solu��es. <br> <br>"
	cMsg += "<b>Lembrando tamb�m que o material possui um prazo de at� 07 dias corridos para permanecer em dep�sito sem <br>"
	cMsg += "cobran�a de taxa para armazenamento.</b> <br> <br>"

elseif nOpt == 2                   //Reagendamento

	//cMsg += "Para: "+alltrim( cA1Nreduz )+" <br> <br>"
	cMsg += "Para: "+alltrim( cA1NOME )+" <br> <br>"  //FR - 04/04/13 - SOLICITADO POR DANIELA
	cMsg += "A/c: " + alltrim( cContato ) + " <br> <br>" 
	cMsg += "INFORMATIVO <br> <br>"

	cMsg += "Informamos que, com rela��o � mercadoria de N.F. " + alltrim( cDocto ) + ", emitida em " + dtoc( dEmiNF ) + ", com previs�o de entrega <br> "
	cMsg += "para " + dtoc( dPrevCheg ) + ", conforme solicita��o de V.Sa. <br> <br>"
//else		//aviso para Log�stica sobre Posto Fiscal

//	cMsg += "Para: DEPTO. LOG�STICA<br> <br>"
//	cMsg += "INFORMATIVO <br> <br>"
//	cMsg += "Informamos que o material referente a nota fiscal " + alltrim(cDocto) + ", emitida em " + dtoc(dEmiNF) + ", encontra-se<br>"
//	cMsg += "no Posto Fiscal do Estado. <br> <br>"

else		//aviso para Log�stica sobre Chegada na UF Destino

	cMsg += "Para: DEPTO. LOG�STICA<br> <br>"
	cMsg += "INFORMATIVO <br> <br>"
	
	cMsg += "Informamos que o material referente a nota fiscal " + cDocto + ", emitida em " + dtoc( dEmiNF ) + ",<br> " 
	cMsg += "com previsao chegada no Cliente para: "+ Dtoc(dPrevCheg) + ", chegou <br>"
	cMsg += "na UF Destino: " + cUF +", em " + Dtoc(dUFChg) + ".<br>"
	cMsg += "Transportadora: "+alltrim( cNomTransp )+". <br>"
	cMsg += "Cliente: "+alltrim( cA1Nreduz )+" <br> <br>"
endIf

cMsg += "Estarei � inteira disposi��o para esclarecer qualquer d�vida.<br> <br> <br> <br>"
cMsg += "Atenciosamente, <br>"
//cMsg += "Daniela Barros<br>"
cMsg += "SAC<br>"
cMsg += "sac@ravaembalagens.com.br <br><br>
cMsg += "<br>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += " *** E-MAIL AUTOM�TICO DO SISTEMA. FAVOR N�O RESPONDER *** "
cMsg += "<br>"
cMsg += "<br>"
cMsg += "<br>"
cMsg += '<font size = "2" face="Arial"><< prg: TMKC016.PRW >></font></p>'

if lResult
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) )
	SEND MAIL FROM cFrom TO cEmailTo CC cEmailCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAttach	RESULT lResult
	
	if !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
	else
		MsgInfo("E-mail -> " + cAssunto + ", Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif
Return(lResult)
