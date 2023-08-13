#INCLUDE 'RWMAKE.CH'
#include "topconn.ch" 
#INCLUDE "Protheus.ch"
#INCLUDE "AP5MAIL.CH" 
#INCLUDE "TBICONN.CH"


/* 
///////////////////////////////////////////////////////////////////
//Programa: TMKC023                                              //
//Objetivo: Gerar o html de reenvio de ocorrência do Call Center //
//Autoria : Flávia Rocha                                         //
//Data    : 14/05/2010.                                          //
///////////////////////////////////////////////////////////////////
*/

*********************************************************************************
User Function TMKC023(aReenvio , cNOTACLI, cSERINF, cTransp, cRedesp, cNomeSup, cNomeOper )
*********************************************************************************

Local cBody   := ""
Local LF      := CHR(13)+CHR(10) 
Local cUsu:= ""
Local cResp
Local eEmail 		:= "" 
Local cNomTransp 	:= "" 
Local cNomRedesp	:= ""
Local cNumEnvio     := ""
Local cProb			:= "" 
Local cMailCopia	:= "" 
Local aParcelas     := {}
Local fr            := 0
Local cBanco        := ""
Local cCli          := ""
Local cCodCli       := ""
Local nCta          := 0

cBody := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + LF
cBody += '<html xmlns="http://www.w3.org/1999/xhtml">' + LF
cBody += '<head>' + LF
cBody += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />' + LF
cBody += '<title>Call Center</title>' + LF
cBody += '</head>'+ LF
cBody += '	<title>Call Center</title>'+ LF
cBody += '	<style type="text/css">'+ LF
cBody += '	body{'+ LF
cBody += '		/*'+ LF
cBody += '		You can remove these four options '+ LF
cBody += '		*/'+ LF
cBody += '		background-repeat:no-repeat;'+ LF
cBody += '		font-family: Trebuchet MS, Lucida Sans Unicode, Arial, sans-serif;'+ LF
cBody += '		margin:0px;'+ LF
cBody += '	}'+ LF
cBody += '	#ad{'+ LF
cBody += '		padding-top:220px;'+ LF
cBody += '		padding-left:10px;'+ LF
cBody += '	}'+ LF
cBody += '    </style>'+ LF
cBody += '<style type="text/css">'+ LF
cBody += '#calendarDiv{'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	width:205px;'+ LF
cBody += '	border:1px solid #317082;'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	background-color: #FFF;'+ LF
cBody += '	font-family:arial;'+ LF
cBody += '	font-size:10px;'+ LF
cBody += '	padding-bottom:20px;'+ LF
cBody += '	visibility:hidden;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv span,#calendarDiv img{'+ LF
cBody += '	float:left;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBox,#calendarDiv .selectBoxOver{'+ LF
cBody += '	line-height:12px;'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '	padding-left:2px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxTime,#calendarDiv .selectBoxTimeOver{	'+ LF
cBody += '	line-height:12px;'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '	padding-left:2px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv td{'+ LF
cBody += '	padding:3px;'+ LF
cBody += '	margin:0px;'+ LF
cBody += '	font-size:10px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBox{'+ LF
cBody += '	border:1px solid #E2EBED;		'+ LF
cBody += '	color: #E2EBED;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxOver{'+ LF
cBody += '	border:1px solid #FFF;'+ LF
cBody += '	background-color: #317082;'+ LF
cBody += '	color: #FFF;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxTime{'+ LF
cBody += '	border:1px solid #317082;		'+ LF
cBody += '	color: #317082;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .selectBoxTimeOver{'+ LF
cBody += '	border:1px solid #216072;	'+ LF
cBody += '	color: #216072;'+ LF
cBody += '	position:relative;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .topBar{'+ LF
cBody += '	height:16px;'+ LF
cBody += '	padding:2px;'+ LF
cBody += '	background-color: #317082;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .activeDay{	/* Active day in the calendar */'+ LF
cBody += '	color:#FF0000;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .todaysDate{'+ LF
cBody += '	height:17px;'+ LF
cBody += '	line-height:17px;'+ LF
cBody += '	padding:2px;'+ LF
cBody += '	background-color: #E2EBED;'+ LF
cBody += '	text-align:center;'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	bottom:0px;'+ LF
cBody += '	width:201px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .todaysDate div{'+ LF
cBody += '	float:left;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .timeBar{'+ LF
cBody += '	height:17px;'+ LF
cBody += '	line-height:17px;'+ LF
cBody += '	background-color: #E2EBED;'+ LF
cBody += '	width:72px;'+ LF
cBody += '	color:#FFF;'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	right:0px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .timeBar div{'+ LF
cBody += '	float:left;'+ LF
cBody += '	margin-right:1px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .monthYearPicker{'+ LF
cBody += '	background-color: #E2EBED;'+ LF
cBody += '	border:1px solid #AAAAAA;'+ LF
cBody += '	position:absolute;'+ LF
cBody += '	color: #317082;'+ LF
cBody += '	left:0px;'+ LF
cBody += '	top:15px;'+ LF
cBody += '	z-index:1000;'+ LF
cBody += '	display:none;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv #monthSelect{'+ LF
cBody += '	width:70px;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .monthYearPicker div{'+ LF
cBody += '	float:none;'+ LF
cBody += '	clear:both;	'+ LF
cBody += '	padding:1px;'+ LF
cBody += '	margin:1px;	'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .monthYearActive{'+ LF
cBody += '	background-color:#317082;'+ LF
cBody += '	color: #E2EBED;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv td{'+ LF
cBody += '	text-align:right;'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .topBar img{'+ LF
cBody += '	cursor:pointer;'+ LF
cBody += '}'+ LF
cBody += '#calendarDiv .topBar div{'+ LF
cBody += '	float:left;'+ LF
cBody += '	margin-right:1px;'+ LF
cBody += '}'+ LF
cBody += '/style>'+ LF

	
cBody += '<style type="text/css">'+ LF
cBody += '<!--'+ LF
cBody += '.style20 {font-family: Arial, Helvetica, sans-serif; font-size: 13px; }'+ LF
cBody += '.style21 {font-family: Arial, Helvetica, sans-serif}'+ LF
cBody += '.style22 {color: #FFFFFF}'+ LF
cBody += '.style26 {font-size: 14px}'+ LF
cBody += '-->'+ LF
cBody += '    </style>'+ LF
cBody += '</head>'+ LF
cBody += '<script language="JavaScript">'+ LF
/*-----------------------------------------------------------------------
Máscara para o campo data dd/mm/aaaa hh:mm:ss
Exemplo: <input maxlength="16" name="datahora" onKeyPress="DataHora(event, this)">
-----------------------------------------------------------------------*/
cBody += 'function Data(evento, objeto){'+ LF
cBody += '	var keypress=(window.event)?event.keyCode:evento.which;'+ LF
cBody += '	campo = eval (objeto);'+ LF
cBody += '	if (campo.value == "00/00/00")'+ LF
cBody += '	{'+ LF
cBody += '		campo.value="" '+ LF
cBody += '	}'+ LF

cBody += '	caracteres = "0123456789";'+ LF
cBody += "	separacao1 = '/';"+ LF
cBody += '	conjunto1 = 2;'+ LF
cBody += '	conjunto2 = 5;'+ LF
cBody += '	conjunto3 = 8;'+ LF
cBody += '	if ((caracteres.search(String.fromCharCode (keypress))!=-1) && campo.value.length < (8))'+ LF
cBody += '	{'+ LF
cBody += '		if (campo.value.length == conjunto1 )'+ LF
cBody += '		   campo.value = campo.value + separacao1;'+ LF
cBody += '		else if (campo.value.length == conjunto2)'+ LF
cBody += '		   campo.value = campo.value + separacao1;'+ LF
cBody += '	}'+ LF
cBody += '	else'+ LF
cBody += '		event.returnValue = false;'+ LF
cBody += '}'+ LF
cBody += '</script>'+ LF
//AQUI COMEÇA MESMO O HTML DA RAVA
cBody += '<body>'+ LF
cBody += '<form action="mailto:%WFMailTo%" method="POST" name="Form1" onsubmit="return Form1_Validator(this)">'+ LF
cBody += '  <p><a href="http://www.ravaembalagens.com.br" target="_blank"><span style="text-decoration:none;text-underline:none"><img'+ LF
cBody += '  src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" width="695"'+ LF
cBody += '  height="88" border="0" id="_x0000_i1025" /></span></a></p>'+ LF

For _nX := 1 to Len(aReenvio)         
   
   nrEnvio := aReenvio[_nX,16]
   
   
Next

cMailCopia := aReenvio[1,17] 

cNumEnvio := iif(nrEnvio <= 1, "", " No.: " + Str(nrEnvio + 1) )

cBody += '<p class="style20"><Strong>======================================</strong><BR>'+LF
cBody += '<Strong>REENVIO ' + cNumEnvio + '</strong><BR>'+LF
cBody += 'Cc: Depto. SAC / Diretoria / ' + cNomeSup + '<BR>'+LF
cBody += 'Cc: ' + cMailCopia + '<BR>'+LF
cBody += '<strong>======================================</strong></p>'+LF

////Localiza o nome do usuário responsável pelo atendimento:
PswOrder(1)                             
If PswSeek( aReenvio[1][7], .T. )       										
										
   aUsu   := PSWRET() 					
   cUsu   := Alltrim( aUsu[1][2] )      //Nome do usuário (responsável pelo atendimento)
   
   eEmail := Alltrim( aUsu[1][14] )     // Definição de e-mail padrão	
Endif   

cBody += '<p class="style20">Prezado(a) '+ cUsu +',</p>'+ LF

cBody += '<p class="style20"><strong>Neste(s) problema(s)</strong> foi(ram) inserida(s) Data(s) para Ação, porém, segundo a equipe do Call Center, ainda não tiveram'+LF
cBody += 'sua solução comprovada.<BR>'+LF
cBody += 'Pedimos a gentileza de informar a data efetiva para a&ccedil;&atilde;o.</p>'+LF

DbSelectArea(aReenvio[1,8])
DbSetOrder(1)
DbSeek(xFilial(aReenvio[1,8])+AllTrim(aReenvio[1,9]))

cCli := iif(aReenvio[1,8]=="SA1",SA1->A1_NOME,iif(aReenvio[1,8]=="SA2",SA2->A2_NOME,"") ) //nome cliente
cCodCli := Substr(aReenvio[1,9],1,6) + '/' + Substr(aReenvio[1,9],7,2)                    //código cliente / loja

SA4->(Dbsetorder(1))
SA4->(Dbseek(xFilial("SA4") + cTransp ))
cNomTransp := SA4->A4_NREDUZ

SA4->(Dbsetorder(1))
SA4->(Dbseek(xFilial("SA4") + cRedesp ))
cNomRedesp := SA4->A4_NREDUZ

//FR - 24/08/12
//modificação relativa ao chamado 00000074 - Neide
//incluir na informação da nota fiscal, o banco, parcelas e vencimento		
SE1->(DbsetOrder(1))
If SE1->(Dbseek(xFilial("SE1") + cSERINF + cNOTACLI ))  
	While SE1->(!EOF()) .And. SE1->E1_FILIAL == xFilial("SE1") .And. Alltrim(SE1->E1_PREFIXO) = Alltrim(cSERINF) .And. Alltrim(SE1->E1_NUM) = Alltrim(cNOTACLI)
		cBanco := SE1->E1_PORTADO
		Aadd( aParcelas , {SE1->E1_PARCELA, SE1->E1_VENCTO, SE1->E1_PORTADO, SE1->E1_AGEDEP, SE1->E1_CONTA, SE1->E1_VALOR } ) 
		//                       1                  2                3               4              5              6
		SE1->(DBSKIP())
	Enddo
Endif

fr := 1
SA6->(Dbsetorder(1))
If Len(aParcelas) > 0
	If SA6->(Dbseek(xFilial("SA6") + aParcelas[1,3] + aParcelas[1,4] + aParcelas[1,5] ))
		cBanco := aParcelas[1,3] //SA6->A6_NOME
	Endif
Endif
//modificação relativa ao chamado 00000074 - Neide
    
cBody += '<p class="style20">Referente ao Cliente:' + 'Codigo: ' + cCodCli + ' - ' + cCli + '</p>'+LF
cBody += '<p class="style20">Nota Fiscal:'+ cNOTACLI + ' / Série: ' + cSERINF + ' / Banco: ' + cBanco +'<BR><BR>'+LF
If Len(aParcelas) > 0
	cBody += 'Parcela(s) / Vencto(s) : <BR><BR>'+LF
	//FR - 24/08/12
	//modificação relativa ao chamado 00000074 - Neide
	//incluir na informação da nota fiscal, o banco, parcelas e vencimento	
	nCta := 1

	For fr := 1 to Len(aParcelas)	
		If fr <= Len(aParcelas)
			If !Empty(aParcelas[fr,1])			
				cBody += aParcelas[fr,1] + ' - ' +  Dtoc(aParcelas[fr,2]) + ' R$' + Transform(aParcelas[fr,6], "@E 9,999,999.99") + ' ;  ' 	   //parcela		
			Else
				cBody += " ' ' " + ' - ' +  Dtoc(aParcelas[fr,2]) + ' R$' + Transform(aParcelas[fr,6], "@E 9,999,999.99") + ' ;  ' //parcela em branco					   	
			Endif
			nCta++
			If nCta = 5 
				cBody += '<br>' + LF
				nCta := 1
			Endif
			
		Endif
	Next
Endif
cBody += '<BR>'+LF
cBody += '<BR>'+LF
//fim das modificações relativas ao chamado 00000074

cBody += 'Transportadora: ' + cTransp +'<br>'+LF
cBody += 'Redespacho: ' + cRedesp + '</p>'+LF

cBody += '<br>' + LF
 
cBody += '</strong>Acesse o sistema Siga e localize o atendimento abaixo, para colocar um prazo para solução.</strong><br>'+LF
cBody += '<strong>No Microsiga: CUSTOMIZAÇÕES >> Atendimentos por Responsável</strong><br>'+LF
cBody += '<strong>Voc&ecirc; tem 1 dia &uacute;til para inserir sua resposta ao atendimento no sistema.</strong></p>'+LF
cBody += '<p align= "left"><strong>Para maiores detalhes, veja o campo "Observações" do Atendimento:</strong></p>'+LF

cBody += '<table width="1000" height="56" border="1">'+LF
cBody += '  <tr>
///CHAMADO 001960 - ALTERAR DE PÓS-VENDAS PARA SAC
cBody += '<td width="587" colspan="6" height="20" bgcolor="#00CC66" align="center"><span class="style9 style21 style22">Dados da Ocorrência (Incluído pelo SAC)</span></td>'+LF
cBody += '<td width="587" colspan="2" height="20" bgcolor="#CBC967" aligh="center"><span class="style9 style21 style26" align="center">Resposta<BR>(Incluída pelo Resp. pela ação)</span></td></tr>'+LF
cBody += '<td width="92" height="20" bgcolor="#00CC66"><span class="style9 style21 style22">Atendimento </span></td>'+LF
cBody += '<td width="68" bgcolor="#00CC66" align="center"><span class="style9 style21 style22">Item</span></td>'+LF
cBody += '<td width="587" bgcolor="#00CC66" align="center"><span class="style9 style21 style22">Problema</span></td>'+LF
cBody += '<td width="2000" bgcolor="#00CC66" align="center"><span class="style9 style21 style22">Obs. do Atendimento</span></td>'+LF
cBody += '<td width="587" bgcolor="#00CC66" align="center"><span class="style9 style21 style22">Data do Envio</span></td>'+LF
cBody += '<td width="68" bgcolor="#00CC66" align="center"><span class="style9 style21 style22">Nro. Envio</span></td>'+LF
cBody += '<td width="587" bgcolor="#CBC967" align="center"><span class="style9 style21 style26">Data p/ Solução</span></td>'+LF
cBody += '<td width="587" bgcolor="#CBC967"><span class="style9 style21 style26">Obs. do Responsável</span></td>'+LF
cBody += '</tr>

For _nX := 1 to Len(aReenvio)     

	cBody += '<tr>
	cBody += '<td height="26"><span class="style7 style21 style26">'+ aReenvio[_nX,1] +'</span></td>'+LF   //cod.atendimento
	cBody += '<td><span class="style26">'+ aReenvio[_nX,10] + '</span></td>'+LF                            //item
	
	cProb := iif(!Empty(aReenvio[_nX,2]),Alltrim(Posicione("Z46",1,xFilial("Z46") + aReenvio[_nX,2],"Z46_DESCRI")),"")+;      //problema
	         iif(!Empty(aReenvio[_nX,3]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[_nX,3],"Z46_DESCRI")),"")+;
	         iif(!Empty(aReenvio[_nX,4]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[_nX,4],"Z46_DESCRI")),"")+;
	         iif(!Empty(aReenvio[_nX,5]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[_nX,5],"Z46_DESCRI")),"")+;
	         iif(!Empty(aReenvio[_nX,6]),"->"+Alltrim(Posicione("Z46",1,xFilial("Z46")+aReenvio[_nX,6],"Z46_DESCRI")),"") 
	
	cBody += '<td><span class="style7 style21 style26">' + cProb + '</span></td>'+LF                    	//problema
	cBody += '<td><span class="style7 style21 style26">' + Alltrim(aReenvio[_nX,18]) + '</span></td>'+LF	//Obs.histórico atend.
	cBody += '<td><span class="style7 style21 style26">' + Dtoc(aReenvio[_nX,15]) + '</span></td>'+LF		//Dt. envio
	cBody += '<td><span class="style7 style21 style26">' + Str(aReenvio[_nX,16]) + '</span></td>'+LF 		//Nr. envio
	cBody += '<td><span class="style7 style21 style26">' + Dtoc(aReenvio[_nX,13]) + '</span></td>'+LF 		//Dt. respondida pelo responsável
	cBody += '<td><span class="style7 style21 style26">' + Alltrim(aReenvio[_nX,14]) +'</span></td>'+LF		//Obs. respondida pelo responsável
	cBody += '</tr>'+LF    
   
   
Next _nX

cBody += '</table>'+LF
//cBody += '<tr>'+LF
cBody += '<BR>'+LF

cBody += '<table width="500" height="26" border="1">'+LF
cBody += '  <tr>'+LF
cBody += '    <td width="587" colspan="2" height="20" bgcolor="#00CC66" align="center"><span class="style9 style21 style22">Motivo deste Reenvio:</span></td></tr>'+LF
cBody += '    <td width="18" bgcolor="#00CC66" align="center"><span class="style9 style21 style22">Item</span></td>'+LF
cBody += '    <td width="108" bgcolor="#00CC66" ><span class="style9 style21 style22">Obs Reenvio</span></td></tr>'+LF
cItAnt := ""
For _nX := 1 to Len(aReenvio)   
	
	If ( Alltrim(aReenvio[_nX,10]) != Alltrim(cItAnt) )
		cBody += '	<tr>'+LF
		cBody += '	<td><span class="style26">'+ aReenvio[_nX,10] + '</span></td>'+LF    
		cBody += '	<td><span class="style7 style21 style26">' + Alltrim(aReenvio[_nX,12]) + '</span></td>'+LF	//Obs. (atual) do atendimento
		cBody += '</tr>'+LF 
		cItAnt := aReenvio[_nX,10]
	Endif
Next

cBody += '</table>' + LF
cBody += '<tr>' + LF
cBody += '<p>'+ LF
cBody += 'Atenciosamente,<br><br>' + LF
cBody += cNomeOper + '<br>' + LF
cBody += 'Depto. SAC' + LF
cBody += '</p>' + LF
cBody += '<br>' + LF
cBody += '<br>' + LF
cBody += ' *** E-MAIL AUTOMÁTICO DO SISTEMA. FAVOR NÃO RESPONDER *** '+LF
cBody += '</form>
cBody += '</body>
cBody += '</html>


Return(cBody)