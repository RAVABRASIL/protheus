#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TopConn.CH"
#include "ap5mail.ch"

**************************************************************************************************
User Function TMKC015( cCli, cContato, cDia1, cMes1, cAno1, cTransp1, cTelTransp, cNF, cEmissao )
**************************************************************************************************

Local cText := "" 
Local LF      := CHR(13)+CHR(10) 

cText := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + LF
cText += '<html xmlns="http://www.w3.org/1999/xhtml">'+ LF
cText += '<head>'+ LF
cText += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'+ LF
cText += '<title>Call Center</title>'+ LF
cText += '</head>'+ LF
cText += '	<title>Call Center</title>'+ LF
cText += '	<style type="text/css">'+ LF
cText += '	body{'+ LF
cText += '	/*'
cText += '		You can remove these four options '+ LF
cText += '		*/'+ LF
cText += '	background-repeat:no-repeat;'+ LF
cText += '		font-family: Trebuchet MS, Lucida Sans Unicode, Arial, sans-serif;'+ LF
cText += '		margin:0px;'+ LF
cText += '	}'+ LF
cText += '	#ad{'+ LF
cText += '		padding-top:220px;'+ LF
cText += '		padding-left:10px;'+ LF
cText += '	}'+ LF
cText += '    </style>'+ LF
cText += '<style type="text/css">'+ LF
cText += '#calendarDiv{'+ LF
cText += '	position:absolute;'+ LF
cText += '	width:205px;'+ LF
cText += '	border:1px solid #317082;'+ LF
cText += '	padding:1px;'+ LF
cText += '	background-color: #FFF;'+ LF
cText += '	font-family:arial;'+ LF
cText += '	font-size:10px;'+ LF
cText += '	padding-bottom:20px;'+ LF
cText += '	visibility:hidden;'+ LF
cText += '}'+ LF
cText += '#calendarDiv span,#calendarDiv img{'+ LF
cText += '	float:left;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .selectBox,#calendarDiv .selectBoxOver{'+ LF
cText += '	line-height:12px; '+ LF
cText += '	padding:1px;             '+ LF
cText += '	cursor:pointer;'+ LF
cText += '	padding-left:2px;'+ LF
cText += '} '+ LF
cText += '#calendarDiv .selectBoxTime,#calendarDiv .selectBoxTimeOver{	'+ LF
cText += '	line-height:12px;'+ LF
cText += '	padding:1px;'+ LF
cText += '	cursor:pointer;'+ LF
cText += '	padding-left:2px;'+ LF
cText += '}'+ LF
cText += '#calendarDiv td{'+ LF
cText += '	padding:3px;'+ LF
cText += '	margin:0px;'+ LF
cText += '	font-size:10px;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .selectBox{'+ LF
cText += '	border:1px solid #E2EBED;		'+ LF
cText += '	color: #E2EBED;'+ LF
cText += '	position:relative;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .selectBoxOver{'+ LF
cText += '	border:1px solid #FFF;'+ LF
cText += '	background-color: #317082;'+ LF
cText += '	color: #FFF;'+ LF
cText += '	position:relative;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .selectBoxTime{'+ LF
cText += '	border:1px solid #317082;		'+ LF
cText += '	color: #317082;'+ LF
cText += '	position:relative;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .selectBoxTimeOver{'+ LF
cText += '	border:1px solid #216072;	'+ LF
cText += '	color: #216072;'+ LF
cText += '	position:relative;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .topBar{'+ LF
cText += '	height:16px;'+ LF
cText += '	padding:2px;'+ LF
cText += '	background-color: #317082;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .activeDay{	/* Active day in the calendar */'+ LF
cText += '	color:#FF0000;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .todaysDate{'+ LF
cText += '	height:17px;'+ LF
cText += '	line-height:17px;'+ LF
cText += '	padding:2px;'+ LF
cText += '	background-color: #E2EBED;'+ LF
cText += '	text-align:center;'+ LF
cText += '	position:absolute;'+ LF
cText += '	bottom:0px;'+ LF
cText += '	width:201px;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .todaysDate div{'+ LF
cText += '	float:left;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .timeBar{'+ LF
cText += '	height:17px;'+ LF
cText += '	line-height:17px;'+ LF
cText += '	background-color: #E2EBED;'+ LF
cText += '	width:72px;'+ LF
cText += '	color:#FFF;'+ LF
cText += '	position:absolute;'+ LF
cText += '	right:0px;'+ LF
cText += '}'+ LF
cText += ' #calendarDiv .timeBar div{'+ LF
cText += '	float:left;'+ LF
cText += '	margin-right:1px;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .monthYearPicker{'+ LF
cText += '	background-color: #E2EBED;'+ LF
cText += '	border:1px solid #AAAAAA;'+ LF
cText += '	position:absolute;'+ LF
cText += '	color: #317082;'+ LF
cText += '	left:0px;'+ LF
cText += '	top:15px;'+ LF
cText += '	z-index:1000;'+ LF
cText += '	display:none;'+ LF
cText += '}'+ LF
cText += '#calendarDiv #monthSelect{'+ LF
cText += '	width:70px;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .monthYearPicker div{'+ LF
cText += '	float:none;'+ LF
cText += '	clear:both;	'+ LF
cText += '	padding:1px;'+ LF
cText += '	margin:1px;	'+ LF
cText += '	cursor:pointer;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .monthYearActive{'+ LF
cText += '	background-color:#317082;'+ LF
cText += '	color: #E2EBED;'+ LF
cText += '}'+ LF
cText += '#calendarDiv td{'+ LF
cText += '	text-align:right;'+ LF
cText += '	cursor:pointer;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .topBar img{'+ LF
cText += '	cursor:pointer;'+ LF
cText += '}'+ LF
cText += '#calendarDiv .topBar div{'+ LF
cText += '	float:left;'+ LF
cText += '	margin-right:1px;'+ LF
cText += '}'+ LF
cText += ' style>'+ LF
cText += '<style type="text/css">'+ LF
cText += '<!--'+ LF
cText += '.style20 {font-family: Arial, Helvetica, sans-serif; font-size: 13px; }'+ LF
cText += '.style21 {font-family: Arial, Helvetica, sans-serif}'+ LF
cText += '.style22 {color: #FFFFFF}'+ LF
cText += '.style26 {font-size: 14px}'+ LF
cText += '-->'+ LF
cText += '    </style>'+ LF
cText += '</head>'+ LF
cText += '<script language="JavaScript"> '+ LF
cText += '/*-----------------------------------------------------------------------'+ LF
cText += 'Máscara para o campo data dd/mm/aaaa hh:mm:ss'+ LF
cText += 'Exemplo: <input maxlength="16" name="datahora" onKeyPress="DataHora(event, this)">'+ LF
cText += '-----------------------------------------------------------------------*/'+ LF
cText += 'function Data(evento, objeto){'+ LF
cText += '	var keypress=(window.event)?event.keyCode:evento.which;'+ LF
cText += '	campo = eval (objeto);'+ LF
cText += "	if (campo.value == '00/00/00')"+ LF
cText += '	{'+ LF
cText += '	campo.value=""'+ LF
cText += '	}'+ LF
cText += "	caracteres = '0123456789';"+ LF
cText += "	separacao1 = '/';"+ LF
cText += '	conjunto1 = 2;'+ LF
cText += '	conjunto2 = 5;'+ LF
cText += '	conjunto3 = 8;'+ LF
cText += '	if ((caracteres.search(String.fromCharCode (keypress))!=-1) && campo.value.length < (8))'+ LF
cText += '	{'+ LF
cText += '		if (campo.value.length == conjunto1 )'+ LF
cText += '		   campo.value = campo.value + separacao1;'+ LF
cText += '		else if (campo.value.length == conjunto2)'+ LF
cText += '		   campo.value = campo.value + separacao1;'+ LF
cText += '	}'+ LF
cText += '	else'+ LF
cText += '		event.returnValue = false;'+ LF
cText += '}'+ LF
cText += '</script>'+ LF
cText += '<body>'+ LF
cText += '<form action="mailto:%WFMailTo%" method="POST" name="Form1" onsubmit="return Form1_Validator(this)">'+ LF
cText += '  <p><a href="http://www.ravaembalagens.com.br" target="_blank"><span style="text-decoration:none;text-underline:none"><img'+ LF
cText += '  src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" width="695"'+ LF
cText += '  height="88" border="0" id="_x0000_i1025" /></span></a></p>'+ LF
//cCli, cContato, cDia1, cMes1, cAno1, cTransp1, cTelTransp, cNF, cEmissao )
cText += '<p align = "left">Cabedelo,' + cDia1 + ' de ' + cMes1 + ' de ' + cAno1 + '</p><br />'+ LF
//CHAMADO 1960 - ALTERAR DE: DEPTO. PÓS-VENDAS PARA: SAC
//cText += '<p class="style20">De: Rava Embalagens - Pós-Vendas <br />'+ LF
cText += '<p class="style20">De: Rava Embalagens - SAC <br />'+ LF
cText += '<p class="style20">Para: ' + cCli + '<br />'+ LF
cText += '<p class="style20">Prezado Sr.(a), ' + cContato + '</p>'+ LF

cText += '<p class="style20">INFORMATIVO</p><br>'+ LF

cText += '<p align = "left">Informamos que o material referente a nota fiscal ' + cNF + ', emitida em ' + cEmissao + ',<br>'+ LF
cText += 'encontra-se no depósito da transportadora ' + cTransp1 + ', em razão da NF estar retida<br>'+ LF
cText += 'no Posto fiscal do seu Estado.</p>'+ LF

cText += '<p align = "left">Pedimos que entre em contato urgente com a transportadora atravé do telefone  ' + cTelTransp + ',<br> '+ LF
cText += 'para maiores esclarecimentos e soluções.</p>'+ LF

cText += '<p align = "left"><strong>Lembrando também que o material possui um prazo de até 07 dias corridos para permanecer<br>'+ LF
cText += 'em depósito sem cobrança de taxa para armazenamento. </strong></p>'+ LF

cText += '<p align = "left">Estarei à inteira disposição para esclarecer qualquer dúvida.</p> '+ LF
cText += '<br>'+ LF
cText += '<p align = "left">Atenciosamente,<br> '+ LF
//cText += 'Daniela Barros<br>'+ LF
//CHAMADO 1960 - ALTERAR DE: PÓS VENDAS PARA: SAC
//cText += 'Pós-Vendas<br>'+ LF
cText += 'SAC<br>'+ LF
cText += '<a href="mailto:sac@ravaembalagens.com.br">sac@ravaembalagens.com.br</a></p>'+ LF
 
cText += '<br />'+ LF
cText += '      <br /> '+ LF
cText += '  <br />'+ LF
cText += '<tr>'+ LF
cText += '  <p>'+ LF
cText += '  </p>'+ LF
cText += '	<div id="debug"></div>'+ LF
cText += '</form>'+ LF
cText += '</body>'+ LF
cText += '</html>' + LF

Return(cText)

