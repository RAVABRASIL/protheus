#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "TbiConn.ch"



User Function MT235G1()  
// eliminado por residuo
*************
LOCAL cMailTo  := " "
LOCAL cAssun   :=" "
LOCAL cCorpo   := " "
LOCAL cEmail   := " "    

If QtdResiduo()=1
//alert("ok")
	DbSelectArea("SC1")
	DbSetOrder(1)
	SC1->(DbSeek(xFilial("SC1")+SC7->C7_NUMSC))
	
	PswOrder(1)
	If PswSeek( SC1->C1_USER, .T. )
		aUser     := PSWRET() 					 // Retorna vetor com informações do usuário
		cEmail := Alltrim(aUser[1][14])  	     // e-mail
	Endif
	
	If empty(cEmail)
		cMailTo  := "informatica@ravaembalagens.com.br"
	else
		cMailTo  :=cEmail
	endif
	//cMailTo  := "rubem@ravaembalagens.com.br"
	
	
	
	cAssun   :="Pedido "+alltrim(SC7->C7_NUM)+" Eliminado por Residuo" 
	
	cCorpo := cabecEmail()
	cCorpo += "O Pedido "+alltrim(SC7->C7_NUM)+" foi Eliminado por Residuo.<br>"
	
	cQry:=""
	cQry+=" SELECT C7_PRODUTO PROD ,B1_DESC DESCRI ,C7_NUMSC NUM ,C7_QUANT QUANT "+CHR(10)
	cQry+=" FROM "+retSqlName("SC7")+" SC7 ," +retSqlName("SB1")+" SB1 " + CHR(10)
	cQry+=" WHERE                                                      " + CHR(10)
 	cQry+="     C7_NUM          = "+ValToSql(SC7->C7_NUM)                + CHR(10)
 	cQry+=" AND C7_RESIDUO      = 'S'                                  " + CHR(10)
 	cQry+=" AND C7_PRODUTO      = B1_COD                               " + CHR(10)
 	cQry+=" AND SC7.D_E_L_E_T_ != '*'                                  " + CHR(10)
 	cQry							+=" AND SB1.D_E_L_E_T_ != '*'                                  " + CHR(10)
 	
    TCQUERY cQry NEW ALIAS "TMP2" 
    
	cCorpo += "<TABLE  width='100%' BORDER='1' >" 
	cCorpo += "<tr><TD bgcolor='green'><font color='white' > COD.Produto </font></TD> " +; 
   				  "<TD bgcolor='green'><font color='white' > Descriçao   </font></TD> " +; 
				  "<TD bgcolor='green'><font color='white' > Solicitação </font></TD> " +; 
				  "<TD bgcolor='green'><font color='white' > Quantidade  </font></TD> " +;
	          "<tr>" 
	TMP2->(dbGoTop())
	WHILE TMP2->(!EOF())
	cCorpo += "<tr><TD>"+TMP2->PROD                +"</TD> " +; 
				  "<TD>"+TMP2->DESCRI              +"</TD> " +;
				  "<TD>"+TMP2->NUM                 +"</TD> " +;
			   	  "<TD>"+alltrim(str(TMP2->QUANT)) +"</TD> " +;
			  "<tr>" 
	TMP2->(dbSkip())
    enddo
    cCorpo += "</table>" 
	
	
	
	TMP2->(DBCLOSEAREA())
	 EnviaMail(cMailTo,cAssun,cCorpo)
Endif

RETURN    


***************

Static Function QtdResiduo()

***************
local cQry:=''
local nRet:=0

cQry:=" SELECT COUNT(*) QTD FROM "+retSqlName("SC7")+" SC7 "
cQry+=" WHERE C7_NUM='"+SC7->C7_NUM+"' "
cQry+=" AND C7_RESIDUO='S' "
cQry+=" AND D_E_L_E_T_!='*' "
TCQUERY cQry NEW ALIAS "TMP"

If TMP->(!EOF())
   nRet:=TMP->QTD
Endif
TMP->(DBCLOSEAREA())
Return  nRet   


static function CabecEmail()
Local cInicio:=" "

cInicio+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> ' 
cInicio+='<html xmlns="http://www.w3.org/1999/xhtml"> ' 
cInicio+='<head> '                                                                     
cInicio+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> ' 
cInicio+='<title></title> '                                           
cInicio+='</head> '                                                                    
cInicio+='<body> '                                                                     
cInicio+='<center>'                                                                    
     
cInicio+='<img src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" border="0"> ' 
cInicio+='<br>'
 	
return cInicio  



************************
static Function EnviaMail(cMailTo, cAssun, cCorpo)
************************

Local cEmailCc  := ""
Local lResult   := .F.
Local cError    := ""

Local cAccount	:= GetMV( "MV_RELACNT" )
Local cPassword := GetMV( "MV_RELPSW"  )
Local cServer	:= GetMV( "MV_RELSERV" )
Local cAttach 	:= ""
Local cFrom		:= GetMV( "MV_RELACNT" )

cEmailCc := ""

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

if lResult
	
	MailAuth( GetMV( "MV_RELACNT" ), GetMV( "MV_RELPSW"  ) ) //realiza a autenticacao no servidor de e-mail.

	SEND MAIL FROM cFrom TO cMailTo CC cEmailCc SUBJECT cAssun BODY cCorpo ATTACHMENT cAttach RESULT lResult
	
	if !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		Help(" ",1,"ATENCAO",,cError,4,5)
	endIf
	
	DISCONNECT SMTP SERVER
	
else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	Help(" ",1,"ATENCAO",,cError,4,5)
endif

Return(lResult)
