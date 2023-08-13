#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#INCLUDE "fivewin.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE ENTER Chr(13)+Chr(10)

/*                                                            
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MA415END    ³ Autor ³ Gustavo Costa         ³ Data ³ 30/10/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Disparado após o encerramento das operações da rotina de orçamentos ( inclusão, alteração, exclusão ) ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

**********************
User Function MA415END( nTipo , nOper )      // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
**********************

	//If nTipo <> 0 //ndica se confirmou a operação: 0 - Não confirmou / 1 - Confirmou a operação
	If INCLUI //nTipo > 0
		dbSelectArea("SCJ")
		If dbSeek(xFilial("SCJ") + M->CJ_NUM)
			Processa({ || fEnviaOrc()},"Enviando Pedido...")
		EndIf
	Else
		If ALTERA //nOper = 2 //Indica o tipo de operação: 1 - Inclusão / 2 - Alteração / 3 - Exclusão
			If MsgBox( "Orçamento Alterado!", "Deseja enviar por e-mail?", "YESNO" )
				Processa({ || fEnviaOrc()},"Enviando Pedido...")
			EndIf
		EndIf
	EndIf
	
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fEnviaOrc º Autor ³ Gustavo Costa     º Data ³  22/02/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada para enviar um email com as          º±±
±±º          ³ pendencias do pedido bloqueado.                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fEnviaOrc()

Local cTitulo  	:= ""//"ORCAMENTO - " + SCJ->CJ_NUM
Local cCopia 	:= ""//GetNewPar('RV_XCOPBLQ',"gustavo@ravaembalagens.com.br")
Local cMailTo 	:= ""//"gustavo@ravaembalagens.com.br"
Local cConteudo	:= ""
Local cCodUser 	:= __CUSERID
local cMotivo	:= ""
lOCAL nTotal	:= 0
Local aAnexos := {}

//dbSelectArea("SCJ")
//dbSeek(xFilial("SCJ") + M->CJ_NUM)

cTitulo  	:= "ORCAMENTO - " + SCJ->CJ_NUM
PswOrder(1)
If PswSeek( cCoduser, .T. )
   aUsua := PSWRET() 						// Retorna vetor com informações do usuário
   //cCodUser  := Alltrim(aUsua[1][1])  	//código do usuário no arq. senhas
   //cNomeuser := Alltrim(aUsua[1][2])		// Nome do usuário
   cMailTo := Alltrim(aUsua[1][14])  	     // e-mail 
Endif

cMailTo := cMailTo + "; comercial@ravaembalagens.com.br"             

dbSelectArea("SA3")
dbSetOrder(1)
If dbSeek(xFilial("SA3") + SCJ->CJ_VEND1)
	cMailTo := cMailTo + ";" + AllTrim(SA3->A3_EMAIL)
EndIf

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA)

cConteudo +="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
cConteudo +="<html xmlns='http://www.w3.org/1999/xhtml'>"
cConteudo +="<head>"
cConteudo +="<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
cConteudo +="<title>Untitled Document</title>"
cConteudo +="</head>"

cConteudo +="<body>"
cConteudo +="<table width='1014' height='63' border='1'>"
  cConteudo +="<tr>"
    cConteudo +="<td height='23' colspan='9' bgcolor='#66FF99'><div align='center'><strong>ORCAMENTO - " + SCJ->CJ_NUM + "</strong></div></td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td ><strong>ORCAMENTO</strong></td>"
    cConteudo +="<td colspan='1'>" + SCJ->CJ_NUM + "</td>"
    cConteudo +="<td ><strong>DATA</strong></td>"
    cConteudo +="<td >" + DtoC(SCJ->CJ_EMISSAO) + "</td>"
    cConteudo +="<td ><strong>COND. PG.</strong></td>"
    cConteudo +="<td colspan='3'>" + SCJ->CJ_CONDPAG + " - " + AllTrim(Posicione('SE4',1,xFilial('SE4')+SCJ->CJ_CONDPAG,'E4_DESCRI')) + "</td>"
  cConteudo +="</tr>"

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1") + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA)
  
  cConteudo +="<tr>"
    cConteudo +="<td width='96' height='23'><strong>CLIENTE</strong></td>"
    cConteudo +="<td colspan='5'>" + SCJ->CJ_CLIENTE + '/' + SCJ->CJ_LOJA + ' - ' + AllTrim(Posicione('SA1',1,xFilial('SA1')+SCJ->CJ_CLIENTE + SCJ->CJ_LOJA,'A1_NOME')) + " </td>"
    cConteudo +="<td ><strong>FONE</strong></td>"
    cConteudo +="<td colspan='2'>" + SA1->A1_TEL + "</td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td width='96' height='23'><strong>END.</strong></td>"
    cConteudo +="<td colspan='4'>" + SA1->A1_END + "</td>"
    cConteudo +="<td ><strong>CEP</strong></td>"
    cConteudo +="<td colspan='3'>" + Transform(SA1->A1_CEP,"@R 99.999-99") + "</td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td ><strong>CIDADE</strong></td>"
    cConteudo +="<td colspan='1'>" + SA1->A1_MUN + "</td>"
    cConteudo +="<td ><strong>UF</strong></td>"
    cConteudo +="<td colspan='1'>" + SA1->A1_EST + "</td>"
    cConteudo +="<td ><strong>CNPJ</strong></td>"
    cConteudo +="<td colspan='1'>" + Transform(SA1->A1_CGC,"@R 99.999.999/9999-99") + "</td>"
    cConteudo +="<td ><strong>I.E.</strong></td>"
    cConteudo +="<td colspan='1'>" + SA1->A1_INSCR + "</td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td width='96' height='23'><strong>VENDEDOR</strong></td>"
    cConteudo +="<td colspan='8'>" + SCJ->CJ_VEND1 + ' - ' + AllTrim(Posicione('SA3',1,xFilial('SA3')+ SCJ->CJ_VEND1,'A3_NOME')) + " </td>"
  cConteudo +="</tr>"
cConteudo +="</table>"
cConteudo +="<p>&nbsp;</p>"
cConteudo +="<table width='1014' height='93' border='1'>"
  cConteudo +="<tr>"
    cConteudo +="<td height='23' colspan='9' bgcolor='#999999'><div align='center'><strong>ITENS</strong></div></td>"
  cConteudo +="</tr>"
  cConteudo +="<tr>"
    cConteudo +="<td width='91' height='23' bgcolor='#999999'><div align='center'><strong>COD.</strong></div></td>"
    cConteudo +="<td width='275' bgcolor='#999999'><div align='center'><strong>PRODUTO</strong></div></td>"
    //cConteudo +="<td width='51' bgcolor='#999999'><div align='center'><strong>PESO</strong></div></td>"
    cConteudo +="<td width='90' bgcolor='#999999'><div align='center'><strong>QTD</strong></div></td>"
    cConteudo +="<td width='90' bgcolor='#999999'><div align='center'><strong>PRECO</strong></div></td>"
    cConteudo +="<td width='91' bgcolor='#999999'><div align='center'><strong>DESC.</strong></div></td>"
    cConteudo +="<td width='90' bgcolor='#999999'><div align='center'><strong>VALOR</strong></div></td>"
    cConteudo +="<td width='110' bgcolor='#999999'><div align='center'><strong>TOTAL</strong></div></td>"
    //cConteudo +="<td width='90' bgcolor='#999999'><div align='center'><strong>ULT. DESC.</strong></div></td>"
    //cConteudo +="<td width='69' bgcolor='#999999'><div align='center'><strong>MOTIVO</strong></div></td>"
  cConteudo +="</tr>"

dbSelectArea("SCK")
dbsetOrder(1)
SCK->(dbSeek(xFilial("SCK") + SCJ->CJ_NUM))

While SCK->(!EOF()) .and. SCK->CK_NUM == SCJ->CJ_NUM
  

  cConteudo +="<tr>"
    cConteudo +="<td height='23'>" + SCK->CK_PRODUTO + "</td>"
    cConteudo +="<td>" + SCK->CK_DESCRI + "</td>"
    //cConteudo +="<td><div align='right'>" + Transform(XVL->PESO,"@E 999,999,999.99") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(SCK->CK_QTDVEN,"@E 999,999,999.99999") + "</div></td>"
    cConteudo +="<td><div align='right'>R$" + Transform(SCK->CK_PRUNIT,"@E 999,999,999.99999") + "</div></td>"
    cConteudo +="<td><div align='right'>" + Transform(SCK->CK_PDESC,"@E 999,999,999.99") + "%</div></td>"
    cConteudo +="<td><div align='right'>R$" + Transform(SCK->CK_PRCVEN,"@E 999,999,999.99999") + "</div></td>"
    cConteudo +="<td><div align='right'>R$" + Transform(SCK->CK_VALOR,"@E 999,999,999.99") + "</div></td>"
    //cConteudo +="<td><div align='right'>" + Transform(0,"@E 999,999,999.99") + "</div></td>"
    /*
    If Empty(cMotivo)
    	cConteudo +="<td><div align='center'>OK</div></td>"
    Else
    	cConteudo +="<td><div align='center'>" + "MOTIVO" + "</div></td>"
    EndIf
    */
  cConteudo +="</tr>"
  
  nTotal	:= nTotal + SCK->CK_VALOR
  
  SCK->(dbSkip())

EndDo

cConteudo +="<tr>"
cConteudo +="<td colspan='6' width='96' height='23'><strong>TOTAL</strong></td>"
cConteudo +="<td ><div align='right'> R$ " + Transform(nTotal,"@E 999,999,999.99") + "</div></td>"
cConteudo +="</tr>"
cConteudo +="<tr>"
cConteudo +="<td colspan='6' width='96' height='23'><strong>TOTAL COM IPI</strong></td>"
cConteudo +="<td ><div align='right'> R$ " + Transform(nTotal * 1.15,"@E 999,999,999.99") + "</div></td>"
cConteudo +="</tr>"

cConteudo +="<tr>"
cConteudo +="<td width='96' height='23'><strong>JUSTIF.</strong></td>"
cConteudo +="<td colspan='8' >" + AllTrim(SCJ->CJ_OBSERVA) + " </td>"
cConteudo +="</tr>"

cConteudo +="</table>"
cConteudo +="Orcamento Transmitido em: " + DtoC(dDataBase) + " " + Time()

cConteudo +="</body>"
cConteudo +="</html>"

cAnexo	:= ""
Memowrite("D:\Temp\pedido.html", cConteudo)
ConOut("**** CONTEUDO ****")
ConOut(cConteudo)

//lEnviado := U_fEnvMail(cMailTo, cTitulo, cConteudo, aAnexos, .T., .F.)
lEnviado := U_SendFatr11( cMailTo, cCopia, cTitulo, cConteudo, cAnexo )

If lEnviado
	MsgAlert("Email enviado com sucesso! " + cMailTo)
Else
	MsgAlert("Problema no envio do email!")
EndIf

Return .T.


