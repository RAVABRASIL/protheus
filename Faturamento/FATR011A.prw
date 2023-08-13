#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*/
//--------------------------------------------------------------------------
//Programa: FATR011A
//Objetivo: Relat�rio de Acompanhamento por Cliente  -  Ano 
//			Emitir relat�rio das vendas por representante e enviar por e-mail
//          para a diretoria.
//Autoria : Fl�via Rocha
//Empresa : RAVA
//Data    : 04/02/2010
//--------------------------------------------------------------------------
/*/
//Foi substitu�do por novos relat�rios solicitado por Sr. Viana em 23/11/2010
//somente deixei a fun��o de envio de email (U_SENDFATR11) pois � comum para todos os outros programas
//que fazem esta tarefa.



//Return

******************************************************************
User Function SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )
******************************************************************

Local cEmailCc  := cCopia
Local lResult   := .F. 
Local lEnviado  := .F.
Local cError    := ""

Local cAccount	:= GetMV( "MV_RELACNT" )
Local cPassword := GetMV( "MV_RELPSW"  )
Local cServer	:= GetMV( "MV_RELSERV" )
Local cAttach 	:= cAnexo
Local cFrom		:= GetMV( "MV_RELACNT" )
//cFrom  := "rava@siga.ravaembalagens.com.br"

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
		//Msgbox("E-mail n�o enviado...")
		conout(Replicate("*",60))
		conout("FATR011")
		conout("Relatorio Acomp. Cliente " + Dtoc( Date() ) + ' - ' + Time() )
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


************************
User function CriaDir( cDir ) 
************************

local nRet := 0

nRet := makeDir( cDir )
if nRet != 0
	conOut( "N�o foi poss�vel criar o diret�rio " )
endIf

return

**************************************
User Function fAbreHTM(cDir, cArq)  
**************************************

//Tenta com o MOZILLA COMUM
If WinExec("C:\Arquivos de programas\Mozilla Firefox\firefox.exe "+ cDir + cArq) <> 0
	///Se n�o conseguir, tenta com Mozilla (para Dell)
	If WinExec("C:\Program Files (x86)\Mozilla Firefox\firefox.exe "+ cDir + cArq) <> 0
		//Se n�o conseguir, tenta com Internet Explorer	
		If WinExec("C:\arquiv~1\intern~1\iexplore.exe " + cDir + cArq) <> 0						
				
			MsgBox("N�o foi poss�vel Abrir o Relat�rio Automaticamente."+Chr(13)+;
			"Por Favor, Verifique seu e-mail, o relat�rio estar� anexado."+Chr(13)+Chr(13)+;
			"", "Aten��o")	
	        ///se n�o conseguir abrir nenhum, ir� avisar que o arquivo chegou anexado por email
		EndIf
	Endif
EndIf

Return
