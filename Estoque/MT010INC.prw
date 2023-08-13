#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include "Tbiconn.ch "

/*
Ponto-de-Entrada: MT010INC - Grava arquivos e campos do usuário
Versões:	 Advanced Protheus 7.10 , Microsiga Protheus 8.11
Compatível Países:	 Todos
Sistemas Operacionais:	 Todos
Compatível às Bases de Dados:	 Todos
Idiomas:	 Espanhol , Inglês

Descrição:
Ponto de Entrada para complementar a inclusão no cadastro do Produto.

LOCALIZAÇÃO : Function A010Inclui - Função de Inclusão do Produto, após sua inclusão.

EM QUE PONTO: Após incluir o Produto, este Ponto de Entrada nem confirma nem cancela a operação, deve ser utilizado para gravar arquivos/campos do usuário, complementando a inclusão.

*/
*************
User Function MT010INC()
*************

RecLock( "SB1", .F. )
SB1->B1_MSBLQL:='1'// BLOQUEIA O PRODUTO 
SB1->( MsUnlock() )
// envia email para contabilidade 
EMAIL()

Return


***************
Static Function EMAIL()
***************
//cMailTo:='antonio@ravaembalagens.com.br'
cMailTo:='contabilidade@ravaembalagens.com.br'
cCopia:=''
cAssun:='Novo Produto Cadastrado: '+alltrim(SB1->B1_COD)
cCorpo:=''
cAnexo:=''

cCorpo:='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
cCorpo+='<html xmlns="http://www.w3.org/1999/xhtml"> '
cCorpo+='<head> '
cCorpo+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
cCorpo+='<title>Untitled Document</title> '
cCorpo+='<style type="text/css"> '
cCorpo+='<!-- '
cCorpo+='.style7 {	font-family: Arial, Helvetica, sans-serif; '
cCorpo+='	font-size: 14px; '
cCorpo+='} '
cCorpo+='.style9 {	font-family: Arial, Helvetica, sans-serif; '
cCorpo+='	color: #FFFFFF; '
cCorpo+='	font-size: 14px; '
cCorpo+='} '
cCorpo+='.style1 {font-family: Geneva, Arial, Helvetica, sans-serif} '
cCorpo+='-->  '
cCorpo+='</style> '
cCorpo+='</head> '

cCorpo+='<body> '
cCorpo+='<p>Produto Cadastrado com Sucesso. </p>  '
cCorpo+='<table width="235" height="48" border="1"> '
cCorpo+='  <tr> '
cCorpo+='    <td width="108" height="20" bgcolor="#00CC66"><span class="style9">Produto</span></td> '
cCorpo+='    <td width="111" bgcolor="#00CC66"><span class="style9"> Forma </span></td> '
cCorpo+='  </tr> '
cCorpo+='  <tr> '
cCorpo+='    <td height="20"><span class="style7">'+ SB1->B1_COD + '</span></td> '
cCorpo+='    <td width="111"><span class="style7">'+ IIF(lCopia,'Copia',iif(inclui,'Inclusao','')) + '</span></td> '
cCorpo+='  </tr> '
cCorpo+='</table> '
cCorpo+='</body> '
cCorpo+='</html> '

lEnviou := SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )				

if !lEnviou
	alert('email falhou, Favor Comunicar o setor de contabilidade para desbloquear o produto '+alltrim(SB1->B1_COD))
endif

Return


******************************************************************
Static Function SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
******************************************************************

Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""

Local cAccount	:= GetMV( "MV_RELACNT" )
Local cPassword := GetMV( "MV_RELPSW"  )
Local cServer	:= GetMV( "MV_RELSERV" )
Local cAttach 	:= cAnexo
Local cFrom		:= "" //GetMV( "MV_RELACNT" )
cFrom  := "rava@siga.ravaembalagens.com.br"

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cCopia;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cAnexo RESULT lEnviado
	
	if !lEnviado
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		//Msgbox("E-mail não enviado...")
		//conout(Replicate("*",60))
		//conout("FATR011")
	   //	conout("Relatorio Acomp. Cliente " + Dtoc( Date() ) + ' - ' + Time() )
		conout("E-mail nao enviado")
		conout(Replicate("*",60))
	//else
		//MsgInfo("E-mail Enviado com Sucesso!")
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult .And. lEnviado )


