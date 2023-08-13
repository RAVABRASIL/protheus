#IFDEF WINDOWS
	#include "fivewin.ch"
#ENDIF

#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include "Tbiconn.ch "


User Function MT010INC()

SetPrvt("_cCODSEC,ODLG,CTITULO,CGETDESC,CSAYDESC")

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±± Nome     : Eurivan Marques Candido                    Data  : 04/11/02  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±± Descricao: Inclusao do produto Secundario na Inclusao do Primario       ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

// Solicitacao de Criação Produto
If AllTrim(Upper(FunName())) = "ESTC003"  //"SOLICPROD"
   RecLock("Z47",.F.)
   Z47->Z47_PROD:=SB1->B1_COD
   Z47->Z47_STATUS:='X' // Produto Criado
   Z47->(MsUnLock())
EndIf
//

if SB1->B1_TIPO == 'PA'
	oDlg     :=  ""
	cTitulo  :=  ""
	cTitulo  :=  "Produto Generico"
	cSayDesc := "Descricao:"
	
	//If Subs( SB1->B1_COD, 4, 1 ) == "R"
      If Subs( SB1->B1_COD, 4, 1 ) $ "R/D"
		_cCodSec := Subs( SB1->B1_COD, 1, 1 ) + "D" + Subs( SB1->B1_COD, 2, 4 ) + "6";
		+ Subs( SB1->B1_COD, 6, 2 )
	Else
		_cCodSec := Subs( SB1->B1_COD, 1, 1 ) + "D" + Subs( SB1->B1_COD, 2, 3 ) + "6";
		+ Subs( SB1->B1_COD, 5, 2 )
	EndIf
	nPosSB1  := SB1->( Recno() )
	cGetDesc := SB1->B1_DESC
	
	dbselectarea( "SX3" )
	dbsetorder( 1 )
	dbseek( "SB1", .T. )
	_aSB1 := {}
	while SX3->X3_ARQUIVO == "SB1"
		//   if empty( SX3->X3_CONTEXT )   Excluído por Diego
		If SX3->X3_CAMPO != "B1_MRP"  .and. SX3->X3_CAMPO != "B1_LE"
			AAdd( _aSB1, AllTrim( SX3->X3_CAMPO ) )    //16/07/2010-Alterado por Flávia Rocha - não deixar copiar o campo B1_MRP
														//03/10/2011-Alterado por Flávia Rocha - não deixar copiar o campo B1_LE
		Endif
		//   endif
		SX3->( dbskip() )
	end
	
	_aCONTEUD := {}
	
	dbselectarea( "SB1" )
	for I := 1 to len( _aSB1 )
		if _aSB1[ I ]="B1_COD"
			AAdd( _aCONTEUD, { _aSB1[ I ], _cCodSec } )
		else
			AAdd( _aCONTEUD, { _aSB1[ I ], FieldGet( FieldPos( _aSB1[ I ] ) ) } )
		endif
	next
	
	dbselectarea( "SB1" )
	dbsetorder( 1 )
	
	if len( Alltrim( SB1->B1_COD ) ) <= 7
		if ! dbSeek( xFilial( "SB1" ) + _cCodSec, .T. )
			
			RecLock( "SB1", .T. )
			
			for I := 1 to len( _aSB1 )
				if _aSB1[ I ] # "B1_COD"
					FieldPut( FieldPos( _aCONTEUD[ I, 1 ] ), _aCONTEUD[ I, 2 ] )
				else
					SB1->B1_COD := _cCodSec
				endif
				
			next
			
			//Inclusao da Descricao Produto Generico
			#IFDEF WINDOWS
				DEFINE MSDIALOG oDlg TITLE OemtoAnsi( cTitulo ) FROM  00,00 TO 80,400 PIXEL OF oMainWnd
				@ 010, 005 SAY cSayDesc SIZE 040, 0 OF oDlg PIXEL
				@ 019, 005 GET cGetDesc SIZE 160, 0 OF oDlg PIXEL
				DEFINE SBUTTON FROM 018, 170 TYPE 1 ACTION ( SB1->B1_DESC:=cGetDesc, oDlg:End() ) ENABLE OF oDlg
				ACTIVATE MSDIALOG oDlg CENTER
			#ENDIF
			
			SB1->( MsUnlock() )
			SB1->( dbCommit() )
		endif
	endif
	
	SB1->( dbgoto( nPosSB1 ) )
endif   

// incluido por antonio 
IF !ALTERA
	RecLock( "SB1", .F. )
	SB1->B1_MSBLQL:='1'// BLOQUEIA O PRODUTO 
	SB1->( MsUnlock() )
	// envia email para contabilidade 
	EMAIL()
ENDIF

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


