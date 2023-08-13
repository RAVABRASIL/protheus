#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"

************************************************************************
User Function FSendMail(cMailTo,cCopia,cAssun,cCorpo,cDir,cAnexo,nTenta)
************************************************************************

Local cEmailCc := ""
Local lResult  := .F.
Local lEnviado := .F.
Local cError   := ""

Local cAccount	 := GetMV( "MV_RELACNT" )
Local cPassword := GetMV( "MV_RELPSW"  )
Local cServer	 := GetMV( "MV_RELSERV" )
Local cFrom		 := "ravasiga@ravaembalagens.com.br"
Local cDes      := ""
Local cArq      := ""

Default nTenta := 5

if cDir <> nil .AND. cAnexo <> nil
   cDes      := cDir+cAnexo
   cArq      := cAnexo
endif

if cCopia <> nil
   cEmailCc := cCopia
endif

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom;
	TO cMailTo;
	CC cEmailCc;
	SUBJECT cAssun;
	BODY cCorpo;
	ATTACHMENT cDes; 	
	RESULT lEnviado
  
   nTent := 0
   while !lEnviado .and. nTent <= nTenta
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
		conout(Replicate("*",60))
		conout(cAssun+" - "+Dtoc( Date() ) + ' - ' + Time() )
		conout("E-mail nao enviado. Erro encontrado: "+cError)			
		conout(Replicate("*",60))
	   
	   SEND MAIL FROM cFrom;
   	TO cMailTo;
	   CC cEmailCc;
	   SUBJECT cAssun;
	   BODY cCorpo;
	   ATTACHMENT cDes; 	
	   RESULT lEnviado      
	   nTent += 1
   end
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return ( lResult .And. lEnviado )