#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "
                   

*************

User Function WFFAT007()

*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT007" Tables "SC9"
  sleep( 5000 )
  conOut( "Programa WFFAT007 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa WFFAT007 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFFAT007 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

***************

Static Function Exec()

***************

LOCAL lOK:=.F.
Local cQuery:=' '
Local LF	:= CHR(13) + CHR(10)
Local cObserv := "" 
Local cDepto  := ""
Local cOcorren:= ""
local cCorpo:= " "
local cEmailTo  := " " 
local cAssunto  := " "

cQuery:="SELECT F2_REALCHG,F2_PREVCHG, F2_RETENC, F2_DTAGCLI, A1_COD,A1_NOME CLIENTE,C5_NUM PEDIDO ,C5_EMISSAO DIGITACAO,  " + LF
cQuery+="C9_DTBLCRE LIBERACAO,A1_MUN MUNI,A1_EST UF,C5_TRANSP,   " + LF
cQuery+="CASE WHEN C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,C9_DTBLCRE,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END AS DIAS1,  " + LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT='')   " + LF
cQuery+="THEN   " + LF
cQuery+="'Aguardando...'   " + LF
cQuery+="ELSE  " + LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT!='')   " + LF
cQuery+="THEN  " + LF
cQuery+=" 'Aguardando, Previsão =>'+SUBSTRING(C5_PREVFAT,7,2)+'/'+SUBSTRING(C5_PREVFAT,5,2)+'/'+SUBSTRING(C5_PREVFAT,3,2)  " + LF
cQuery+="ELSE "  + LF
cQuery+="CASE WHEN (NOT D2_DOC IS NULL)  " + LF
cQuery+="THEN   " + LF
cQuery+="SUBSTRING(D2_EMISSAO ,7,2)+'/'+SUBSTRING(D2_EMISSAO ,5,2)+'/'+SUBSTRING(D2_EMISSAO ,3,2)  " + LF
cQuery+="ELSE   " + LF
cQuery+="'NAO' " + LF
cQuery+="END  "     + LF
cQuery+="END "   + LF
cQuery+="END	AS FATURAMENTO, "  + LF
cQuery+="D2_DOC NOTA,F2_OBS OBS,  " + LF
cQuery+="CASE WHEN NOT D2_EMISSAO IS NULL AND C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,D2_EMISSAO,112) - CONVERT(datetime,C9_DTBLCRE,112)AS INT)  END AS DIAS2, " + LF
cQuery+="CASE WHEN   CONVERT(datetime,C5_ENTREG,112)>CAST(CONVERT(VARCHAR,GETDATE(),112)AS DATETIME) THEN C5_ENTREG ELSE '' END PROGRAMADO,  " + LF

cQuery+= " CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN SUBSTRING(F2_REALCHG ,7,2)+'/'+SUBSTRING(F2_REALCHG ,5,2)+'/'+SUBSTRING(F2_REALCHG ,3,2) " + LF
cQuery += " ELSE CASE WHEN NOT F2_DTAGCLI IS NULL AND F2_DTAGCLI!='' THEN 'Agendado pelo Cliente p/ =>'+SUBSTRING(F2_DTAGCLI ,7,2)+'/'+SUBSTRING(F2_DTAGCLI ,5,2)+'/'+SUBSTRING(F2_DTAGCLI ,3,2)" + LF 
cQuery+= " ELSE CASE WHEN NOT F2_DATRASO IS NULL AND F2_DATRASO!='' THEN 'Nova Previsao=>'+SUBSTRING(F2_DATRASO ,7,2)+'/'+SUBSTRING(F2_DATRASO ,5,2)+'/'+SUBSTRING(F2_DATRASO ,3,2) " + LF
cQuery+= " ELSE CASE WHEN NOT F2_PREVCHG IS NULL AND F2_PREVCHG!=''THEN 'Previsao=>'+SUBSTRING(F2_PREVCHG ,7,2)+'/'+SUBSTRING(F2_PREVCHG ,5,2)+'/'+SUBSTRING(F2_PREVCHG ,3,2) " + LF
cQuery+= " END  END END END AS ENTREGA, " + LF

cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,D2_EMISSAO,112)AS INT) END AS DIAS3, " + LF
cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!=''THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END AS TOTALDIAS " + LF

cQuery+="FROM SC5020 SC5  " + LF
cQuery+="JOIN SC6020 SC6 " + LF
cQuery+="ON SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_BLQ <> 'R' AND SC6.D_E_L_E_T_ = '' " + LF
cQuery+="JOIN SC9020 SC9  " + LF
cQuery+="ON SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM AND SC9.D_E_L_E_T_ = ''  " + LF
cQuery+="JOIN SB1010 SB1  " + LF
cQuery+="ON SB1.B1_COD = SC6.C6_PRODUTO AND SB1.B1_TIPO = 'PA' AND SB1.D_E_L_E_T_ = ''  " + LF
cQuery+="JOIN SA1010 SA1  " + LF
cQuery+="ON SC5.C5_CLIENTE+SC5.C5_LOJACLI = SA1.A1_COD+SA1.A1_LOJA AND  " + LF
cQuery+="SA1.A1_SATIV1 IN( '000001','000002','000003','000004') AND SA1.D_E_L_E_T_ = ''  " + LF
cQuery+="LEFT JOIN SD2020 SD2  " + LF
cQuery+="ON D2_PEDIDO = C5_NUM AND D2_ITEMPV = C6_ITEM AND D2_SERIE!='' AND SD2.D_E_L_E_T_ = ''  " + LF
cQuery+="AND D2_DOC=C9_NFISCAL  " + LF
cQuery+="LEFT JOIN SF2020 SF2 " + LF
cQuery+="ON F2_DOC+F2_SERIE=D2_DOC+D2_SERIE AND SF2.D_E_L_E_T_ = '' " + LF

cQuery+="WHERE  (  SC6.C6_QTDVEN - SC6.C6_QTDENT  > 0  OR C9_NFISCAL <> ''  AND D2_EMISSAO >= '20100101' ) " + LF
// colocado em 22/02/2011 para otimizar a query 
cQuery+="AND( (F2_REALCHG ='' OR F2_REALCHG IS NULL) OR CAST(CONVERT(datetime,'"+DTOS(ddatabase)+"',112) - CONVERT(datetime,F2_REALCHG,112)AS INT)<8 ) " + LF
//
cQuery+="AND SC6.C6_BLQ <> 'R'     " + LF
cQuery+="AND SB1.B1_TIPO = 'PA'    " + LF
cQuery+="AND SC5.C5_TIPO='N'  " + LF
cQuery+="AND SC5.C5_TRANSP!='024'  " + LF
cQuery+="AND SC6.C6_TES != '540'  " + LF

cQuery+="AND SC5.C5_FILIAL='"+xFilial('SC5')+"' " + LF 
cQuery+="AND SC5.D_E_L_E_T_ = '' "  + LF
cQuery+="AND SC6.D_E_L_E_T_ = '' "  + LF
cQuery+="AND SC9.D_E_L_E_T_ = '' "  + LF
cQuery+="AND SB1.D_E_L_E_T_ = '' "  + LF

cQuery+="GROUP BY A1_MUN ,A1_EST ,F2_REALCHG,F2_PREVCHG, F2_RETENC, F2_DTAGCLI, A1_COD,A1_NOME ,C5_NUM ,C5_EMISSAO, " + LF
cQuery+="C9_DTBLCRE ,C5_TRANSP, " + LF
cQuery+="CASE WHEN C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,C9_DTBLCRE,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END , " + LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT='')  " + LF
cQuery+="THEN  " + LF
cQuery+="'Aguardando...'  " + LF
cQuery+="ELSE  " + LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT!='')  " + LF
cQuery+="THEN  " + LF
cQuery+="'Aguardando, Previsão =>'+SUBSTRING(C5_PREVFAT,7,2)+'/'+SUBSTRING(C5_PREVFAT,5,2)+'/'+SUBSTRING(C5_PREVFAT,3,2)  " + LF
cQuery+="ELSE  " + LF
cQuery+="CASE WHEN (NOT D2_DOC IS NULL)  " + LF
cQuery+="THEN  " + LF
cQuery+="SUBSTRING(D2_EMISSAO ,7,2)+'/'+SUBSTRING(D2_EMISSAO ,5,2)+'/'+SUBSTRING(D2_EMISSAO ,3,2)  " + LF
cQuery+="ELSE   " + LF
cQuery+="'NAO'  " + LF
cQuery+="END  "     + LF
cQuery+="END  "  + LF
cQuery+="END, "  + LF
cQuery+="D2_DOC ,F2_OBS , " + LF
cQuery+="CASE WHEN NOT D2_EMISSAO IS NULL AND C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,D2_EMISSAO,112) - CONVERT(datetime,C9_DTBLCRE,112)AS INT)  END , " + LF
cQuery+="CASE WHEN   CONVERT(datetime,C5_ENTREG,112)>CAST(CONVERT(VARCHAR,GETDATE(),112)AS DATETIME) THEN C5_ENTREG ELSE '' END , " + LF

cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN SUBSTRING(F2_REALCHG ,7,2)+'/'+SUBSTRING(F2_REALCHG ,5,2)+'/'+SUBSTRING(F2_REALCHG ,3,2) " + LF
cQuery += " ELSE CASE WHEN NOT F2_DTAGCLI IS NULL AND F2_DTAGCLI!='' THEN 'Agendado pelo Cliente p/ =>'+SUBSTRING(F2_DTAGCLI ,7,2)+'/'+SUBSTRING(F2_DTAGCLI ,5,2)+'/'+SUBSTRING(F2_DTAGCLI ,3,2)" + LF 
cQuery+= " ELSE CASE WHEN NOT F2_DATRASO IS NULL AND F2_DATRASO!='' THEN 'Nova Previsao=>'+SUBSTRING(F2_DATRASO ,7,2)+'/'+SUBSTRING(F2_DATRASO ,5,2)+'/'+SUBSTRING(F2_DATRASO ,3,2) " + LF
cQuery+= " ELSE CASE WHEN NOT F2_PREVCHG IS NULL AND F2_PREVCHG!=''THEN 'Previsao=>'+SUBSTRING(F2_PREVCHG ,7,2)+'/'+SUBSTRING(F2_PREVCHG ,5,2)+'/'+SUBSTRING(F2_PREVCHG ,3,2) " + LF
cQuery+= " END  END END END , "  + LF

cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,D2_EMISSAO,112)AS INT) END , " + LF
cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!=''THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END  " + LF

cQuery+="ORDER BY C5_NUM " + LF
//Memowrite("C:\Temp\WFfat007.sql",cQuery)
TCQUERY cQuery NEW ALIAS 'AUUX'

TCSetField( 'AUUX', "DIGITACAO", "D")
TCSetField( 'AUUX', "LIBERACAO", "D")
TCSetField( 'AUUX', "PROGRAMADO", "D")
TCSetField( 'AUUX', "F2_DTAGCLI", "D")


AUUX->(DbGoTop())


If !AUUX->(EOF())


	cCorpo:='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">  '
	cCorpo+='<html xmlns="http://www.w3.org/1999/xhtml">  '
	cCorpo+='<head>  '
	cCorpo+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />  '
	cCorpo+='<title>Info-Mail</title>  '
	cCorpo+='</head>  '
	cCorpo+='<title>Call Center</title>  '
	cCorpo+='<style type="text/css">  '
	cCorpo+='body{  '
	cCorpo+='background-repeat:no-repeat;  '
	cCorpo+='		font-family: Trebuchet MS, Lucida Sans Unicode, Arial, sans-serif;  '
	cCorpo+='		margin:0px;  '
	cCorpo+='	}  '
	cCorpo+='	#ad{  '
	cCorpo+='		padding-top:220px;  '
	cCorpo+='		padding-left:10px;  '
	cCorpo+='	}  '
	cCorpo+='    </style>  '
	
	cCorpo+='<style type="text/css">  '
	cCorpo+='#calendarDiv{  '
	cCorpo+='	position:absolute;  '
	cCorpo+='	width:205px;  '
	cCorpo+='	border:1px solid #317082;  '
	cCorpo+='	padding:1px;  '
	cCorpo+='	background-color: #FFF;  '
	cCorpo+='	font-family:arial;  '
	cCorpo+='	font-size:10px;  '
	cCorpo+='	padding-bottom:20px;  '
	cCorpo+='	visibility:hidden;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv span,#calendarDiv img{  '
	cCorpo+='	float:left;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .selectBox,#calendarDiv .selectBoxOver{  '
	cCorpo+='	line-height:12px;  '
	cCorpo+='	padding:1px;  '
	cCorpo+='	cursor:pointer;  '
	cCorpo+='	padding-left:2px;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .selectBoxTime,#calendarDiv .selectBoxTimeOver{  '
	cCorpo+='	line-height:12px;  '
	cCorpo+='	padding:1px;  '
	cCorpo+='	cursor:pointer;  '
	cCorpo+='	padding-left:2px;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv td{  '
	cCorpo+='	padding:3px;  '
	cCorpo+='	margin:0px;  '
	cCorpo+='	font-size:10px;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .selectBox{  '
	cCorpo+='	border:1px solid #E2EBED;  '
	cCorpo+='	color: #E2EBED;  '
	cCorpo+='	position:relative;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .selectBoxOver{  '
	cCorpo+='	border:1px solid #FFF;  '
	cCorpo+='	background-color: #317082;  '
	cCorpo+='	color: #FFF;  '
	cCorpo+='	position:relative;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .selectBoxTime{  '
	cCorpo+='	border:1px solid #317082;  '
	cCorpo+='	color: #317082;  '
	cCorpo+='	position:relative;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .selectBoxTimeOver{  '
	cCorpo+='	border:1px solid #216072;  '
	cCorpo+='	color: #216072;  '
	cCorpo+='	position:relative;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .topBar{  '
	cCorpo+='	height:16px;  '
	cCorpo+='	padding:2px;  '
	cCorpo+='	background-color: #317082;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .activeDay{	  '
	cCorpo+='	color:#FF0000;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .todaysDate{  '
	cCorpo+='	height:17px;  '
	cCorpo+='	line-height:17px;  '
	cCorpo+='	padding:2px;  '
	cCorpo+='	background-color: #E2EBED;  '
	cCorpo+='	text-align:center;  '
	cCorpo+='	position:absolute;  '
	cCorpo+='	bottom:0px;  '
	cCorpo+='	width:201px;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .todaysDate div{  '
	cCorpo+='	float:left;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .timeBar{  '
	cCorpo+='	height:17px;  '
	cCorpo+='	line-height:17px;  '
	cCorpo+='	background-color: #E2EBED;  '
	cCorpo+='	width:72px;  '
	cCorpo+='	color:#FFF;  '
	cCorpo+='	position:absolute;  '
	cCorpo+='	right:0px;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .timeBar div{  '
	cCorpo+='	float:left;  '
	cCorpo+='	margin-right:1px;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .monthYearPicker{  '
	cCorpo+='	background-color: #E2EBED;  '
	cCorpo+='	border:1px solid #AAAAAA;  '
	cCorpo+='	position:absolute;  '
	cCorpo+='	color: #317082;  '
	cCorpo+='	left:0px;  '
	cCorpo+='	top:15px;  '
	cCorpo+='	z-index:1000;  '
	cCorpo+='	display:none;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv #monthSelect{  '
	cCorpo+='	width:70px;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .monthYearPicker div{  '
	cCorpo+='	float:none;  '
	cCorpo+='	clear:both;  '
	cCorpo+='	padding:1px;  '
	cCorpo+='	margin:1px;  '
	cCorpo+='	cursor:pointer;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .monthYearActive{  '
	cCorpo+='	background-color:#317082;  '
	cCorpo+='	color: #E2EBED;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv td{  '
	cCorpo+='	text-align:right;  '
	cCorpo+='	cursor:pointer;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .topBar img{  '
	cCorpo+='	cursor:pointer;  '
	cCorpo+='}  '
	cCorpo+='#calendarDiv .topBar div{  '
	cCorpo+='	float:left;  '
	cCorpo+='	margin-right:1px;  '
	cCorpo+='}  '
	cCorpo+='/style>  '
	
		
	cCorpo+='<style type="text/css">  '
	cCorpo+='<!--  '
	cCorpo+='.style20 {font-family: Arial, Helvetica, sans-serif; font-size: 13px; }  '
	cCorpo+='.style21 {font-family: Arial, Helvetica, sans-serif}  '
	cCorpo+='.style22 {color: #FFFFFF}  '
	cCorpo+='.style26 {font-size: 14px}  '
	cCorpo+='.style27 {color: #000000}  '
	cCorpo+='-->  '
	cCorpo+='    </style>  '
	cCorpo+='</head>  '
	
	cCorpo+='<script language="JavaScript">  '
	cCorpo+='function Data(evento, objeto){  '
	cCorpo+='	var keypress=(window.event)?event.keyCode:evento.which;  '
	cCorpo+='	campo = eval (objeto);  '
	cCorpo+='	if (campo.value == "00/00/00")  '
	cCorpo+='	{  '
	cCorpo+='		campo.value=""  '
	cCorpo+='	}  '
	
	cCorpo+='	caracteres = "0123456789";  '
	cCorpo+='	separacao1 = "/";  '
	cCorpo+='	conjunto1 = 2;  '
	cCorpo+='	conjunto2 = 5;  '
	cCorpo+='	conjunto3 = 8;  '
	cCorpo+='	if ((caracteres.search(String.fromCharCode (keypress))!=-1) && campo.value.length < (8))    '
	cCorpo+='	{  '
	cCorpo+='		if (campo.value.length == conjunto1 )  '
	cCorpo+='		   campo.value = campo.value + separacao1;  '
	cCorpo+='		else if (campo.value.length == conjunto2)  '
	cCorpo+='		   campo.value = campo.value + separacao1;  '
	cCorpo+='	}  '
	cCorpo+='	else  '
	cCorpo+='		event.returnValue = false;  '
	cCorpo+='}  '
	cCorpo+='</script>  '
	
	cCorpo+='<body>  '
	cCorpo+='<form action="mailto:%WFMailTo%" method="POST" name="Form1" onsubmit="return Form1_Validator(this)">  '
	cCorpo+='  <p><a href="http://www.ravaembalagens.com.br" target="_blank"><span style="text-decoration:none;text-underline:none"><img  '
	cCorpo+='  src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" width="991"  '
	cCorpo+='  height="88" border="0" id="_x0000_i1025" /></span></a></p>  '
	cCorpo+='<p class="style20">&nbsp;</p>  '
	cCorpo+='<table width="1105" height="56" border="1">  '
	cCorpo+='   <tr>  '
	cCorpo+='     <td height="20" colspan="3" align="center" bgcolor="#FFFFFF">&nbsp;</td>  '
	cCorpo+='     <td height="20" colspan="2" align="center" bgcolor="#AD5254"><span class="style7 style21 style22">1&ordf; Etapa </span></td>  '
	cCorpo+='     <td height="20" colspan="2" align="center" bgcolor="#CBC967"><span class="style7 style21 style27">2&ordf; Etapa</span></td>  '
	cCorpo+='     <td height="20" colspan="2" align="center" bgcolor="#3CB9C4"><span class="style7 style21 style22">3&ordf; Etapa</span></td>  '
	cCorpo+='     <td height="20" align="center" bgcolor="#FFFFFF">&nbsp;</td>  '
	cCorpo+='     <td height="20" bgcolor="#FFFFC0" colspan="3" align="center"><span class="style7 style21 style27">Observações</span></td>  '
	cCorpo+='   </tr>  '
	cCorpo+='   <tr>  '
	cCorpo+='   <td width="133" height="20" align="center" bgcolor="#00CC66"><span class="style7 style21 style22">Cliente</span></td>  '
	cCorpo+='   <td width="72" align="center" bgcolor="#00CC66"><span class="style7 style21 style22">Cidade</span></td>  '
	cCorpo+='   <td width="60" align="center" bgcolor="#00CC66"><span class="style7 style21 style22">UF</span></td>  '
	cCorpo+='   <td width="108" align="center" bgcolor="#AD5254"><span class="style7 style21 style22">Pedido</span></td>  '
	cCorpo+='   <td width="108" height="20" align="center" bgcolor="#AD5254"><span class="style7 style21 style22">Transportadora</span></td>  '
	cCorpo+='   <td width="99" height="20" bgcolor="#CBC967" align="center"><span class="style7 style21 style27">Faturamento</span></td>  '
	cCorpo+='	<td width="122" height="20" bgcolor="#CBC967" align="center"><span class="style7 style21 style27">Nota Fiscal</span></td>  '
	cCorpo+='	<td width="103" height="20" align="center" bgcolor="#3CB9C4"><span class="style7 style21 style22">Entrega</span></td>  '
	cCorpo+='	<td width="104" height="20" align="center" bgcolor="#3CB9C4"><span class="style22">Dias na 3 &ordf; Etapa</span></td>  '
	cCorpo+='	<td width="132" height="20" align="center" bgcolor="#00CC66" class="style22 style21 style7">Dias Ate o Cliente Receber o Pedido </td>  '
	cCorpo+='    <td width="150" height="20" align="center" bgcolor="#FFFFC0" class="style22 style21 style27">Ocorrencia</td>  '
	cCorpo+='	<td width="150" height="20" align="center" bgcolor="#FFFFC0" class="style22 style21 style27">Depto</td>  '
	cCorpo+='	<td width="150" height="20" ><span class="style7 style21 style27">Outros</span></td>  '
	cCorpo+='   </tr>  '
		
	Do while !AUUX->(EOF())                    
	   Iif(EMPTY(AUUX->F2_REALCHG),lOK:=.T.,iif(ddatabase-StoD(AUUX->F2_REALCHG)<8,lOK:=.T.,lOK:=.F.))  
	    If lOK
	        cCorpo+='  <tr>  '    	
			cCorpo+='<td><span class="style7 style21 style26">'+AUUX->CLIENTE+'</span></td>  '
			cCorpo+='<td><span class="style7 style21 style26">'+AUUX->MUNI+'</span></td>  '
			cCorpo+='<td><span class="style7 style21 style26">'+AUUX->UF+'</span></td>  '
			cCorpo+='<td><span class="style7 style21 style26">'+AUUX->PEDIDO+'</span></td>  '
			cCorpo+='<td><span class="style7 style21 style26">'+posicione("SA4",1,xFilial('SA4') + AUUX->C5_TRANSP,"A4_NOME" )+'</span></td>  '
			cCorpo+='<td><span class="style7 style21 style26">'+AUUX->FATURAMENTO+'</span></td>  '
			cCorpo+='<td><span class="style7 style21 style26">'+IIF(!EMPTY(AUUX->NOTA),AUUX->NOTA,"&nbsp;")+'</span></td>  '
			cCorpo+='<td><span class="style7 style21 style26">'+IIF(!EMPTY(AUUX->ENTREGA),AUUX->ENTREGA,"&nbsp;")+'</span></td>  '
			cCorpo+='<td><span class="style7 style21 style26">'+STR(AUUX->DIAS3)+'</span></td>  '
			cCorpo+='<td><span class="style7 style21 style26">'+STR(AUUX->TOTALDIAS)+'</span></td>  '
       
       
       		IF !EMPTY(AUUX->NOTA)
				cDepto 		:= ""
				cOcorren 	:= ""
								
				If Alltrim(AUUX->F2_RETENC) = 'S'
					cObserv	:= "Retenção Fiscal"
				
				Else
					cObserv := ""
				Endif
				
								
				cQuery := "	SELECT UC_CODIGO,UD_ITEM,UC_STATUS,UC_PENDENT,UC_NFISCAL,UC_REALCHG,UD_N2,UD_OPERADO,UD_STATUS,UD_RESOLVI " + LF
			 	cQuery += " FROM " + RetSqlName("SUC") + " SUC, " + LF
			 	cQuery += " " + RetSqlName("SUD") + " SUD " + LF
			 
				cQuery += " WHERE RTRIM(UC_NFISCAL) = '" + Alltrim(AUUX->NOTA) + "' "  + LF
				cQuery += " AND UC_CODIGO = UD_CODIGO"  + LF
				cQuery += "	AND SUC.D_E_L_E_T_ = '' "  + LF
				cQuery += "	AND SUD.D_E_L_E_T_ = '' "  + LF
				cQuery += "	AND UC_OBSPRB <> 'S'"  + LF
				cQuery += "	AND UD_OPERADO <> ''"  + LF
				cQuery += "	AND UD_STATUS <> '2'"  + LF
				If Select("OCO") > 0
					DbSelectArea("OCO")
					DbCloseArea()
				EndIf
				TCQUERY cQuery NEW ALIAS "OCO"			
				OCO->( DbGoTop() )			
				If !OCO->(EOF())
					While OCO->( !EOF() )
						cOcorren += OCO->UC_CODIGO + "-" + OCO->UD_ITEM + " / "
						cDepto   += SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+ OCO->UD_N2,"Z46_DESCRI"),1,15) + " / "
						//msgbox("Ocorrencia: " + cOcorren + " - Depto: " + cDepto )
						OCO->(Dbskip())					
					Enddo
					
				Endif
				
				cCorpo+='	<td><span class="style7 style21 style26">'+IIF(!EMPTY(cOcorren) , cOcorren, "&nbsp;")+'</span></td>  '
                cCorpo+='	<td><span class="style7 style21 style26">'+IIF(!EMPTY(cDepto)   , cDepto   ,"&nbsp;")+'</span></td>  '
                cCorpo+='	<td><span class="style7 style21 style26">'+IIF(!EMPTY(cObserv)   , cObserv ,"&nbsp;")+'</span></td>  '
				
	   		ELSE
	       		cCorpo+='	<td><span class="style7 style21 style26">'+IIF(!EMPTY(cOcorren) , cOcorren, "&nbsp;")+'</span></td>  '
                cCorpo+='	<td><span class="style7 style21 style26">'+IIF(!EMPTY(cDepto)   , cDepto   ,"&nbsp;")+'</span></td>  '
                cCorpo+='	<td><span class="style7 style21 style26">'+IIF(!EMPTY(cObserv)   , cObserv ,"&nbsp;")+'</span></td>  '

	        ENDIF
        
        Endif
        cCorpo+='    </tr>  '
		AUUX->( DBSKIP() )
	Enddo

cCorpo+='    </tr>  '
cCorpo+='</table>  '
cCorpo+='<p>&nbsp;</p>  '
cCorpo+='</form>  '
cCorpo+='</body>  '
cCorpo+='</html>  '
	
cEmailTo  := "geisa@ravaembalagens.com.br;alexandre@ravaembalagens.com.br;joao.emanuel@ravaembalagens.com.br;daniela@ravaembalagens.com.br;alexandre.saraiva@ravaembalagens.com.br;marcilio@ravaembalagens.com.br;antonio@ravaembalagens.com.br" 
cAssunto  := "Situação de Faturamento ate Entrega"

U_EnviaMail(cEmailTo,cAssunto,cCorpo)
//alert("Email enviado com Sucesso!!!" )

Endif
AUUX->(DbCloseArea())
Return

/*
***************

Static Function Exec()

***************

LOCAL lOK:=.F.
Local cQuery:=' '
Local LF	:= CHR(13) + CHR(10)
Local cObserv := "" 
Local cDepto  := ""
Local cOcorren:= ""

cQuery:="SELECT F2_REALCHG,F2_PREVCHG, F2_RETENC, F2_DTAGCLI, A1_COD,A1_NOME CLIENTE,C5_NUM PEDIDO ,C5_EMISSAO DIGITACAO,  " + LF
cQuery+="C9_DTBLCRE LIBERACAO,A1_MUN MUNI,A1_EST UF,C5_TRANSP,   " + LF
cQuery+="CASE WHEN C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,C9_DTBLCRE,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END AS DIAS1,  " + LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT='')   " + LF
cQuery+="THEN   " + LF
cQuery+="'Aguardando...'   " + LF
cQuery+="ELSE  " + LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT!='')   " + LF
cQuery+="THEN  " + LF
cQuery+=" 'Aguardando, Previsão =>'+SUBSTRING(C5_PREVFAT,7,2)+'/'+SUBSTRING(C5_PREVFAT,5,2)+'/'+SUBSTRING(C5_PREVFAT,3,2)  " + LF
cQuery+="ELSE "  + LF
cQuery+="CASE WHEN (NOT D2_DOC IS NULL)  " + LF
cQuery+="THEN   " + LF
cQuery+="SUBSTRING(D2_EMISSAO ,7,2)+'/'+SUBSTRING(D2_EMISSAO ,5,2)+'/'+SUBSTRING(D2_EMISSAO ,3,2)  " + LF
cQuery+="ELSE   " + LF
cQuery+="'NAO' " + LF
cQuery+="END  "     + LF
cQuery+="END "   + LF
cQuery+="END	AS FATURAMENTO, "  + LF
cQuery+="D2_DOC NOTA,F2_OBS OBS,  " + LF
cQuery+="CASE WHEN NOT D2_EMISSAO IS NULL AND C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,D2_EMISSAO,112) - CONVERT(datetime,C9_DTBLCRE,112)AS INT)  END AS DIAS2, " + LF
cQuery+="CASE WHEN   CONVERT(datetime,C5_ENTREG,112)>CAST(CONVERT(VARCHAR,GETDATE(),112)AS DATETIME) THEN C5_ENTREG ELSE '' END PROGRAMADO,  " + LF

cQuery+= " CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN SUBSTRING(F2_REALCHG ,7,2)+'/'+SUBSTRING(F2_REALCHG ,5,2)+'/'+SUBSTRING(F2_REALCHG ,3,2) " + LF
cQuery += " ELSE CASE WHEN NOT F2_DTAGCLI IS NULL AND F2_DTAGCLI!='' THEN 'Agendado pelo Cliente p/ =>'+SUBSTRING(F2_DTAGCLI ,7,2)+'/'+SUBSTRING(F2_DTAGCLI ,5,2)+'/'+SUBSTRING(F2_DTAGCLI ,3,2)" + LF 
cQuery+= " ELSE CASE WHEN NOT F2_DATRASO IS NULL AND F2_DATRASO!='' THEN 'Nova Previsao=>'+SUBSTRING(F2_DATRASO ,7,2)+'/'+SUBSTRING(F2_DATRASO ,5,2)+'/'+SUBSTRING(F2_DATRASO ,3,2) " + LF
cQuery+= " ELSE CASE WHEN NOT F2_PREVCHG IS NULL AND F2_PREVCHG!=''THEN 'Previsao=>'+SUBSTRING(F2_PREVCHG ,7,2)+'/'+SUBSTRING(F2_PREVCHG ,5,2)+'/'+SUBSTRING(F2_PREVCHG ,3,2) " + LF
cQuery+= " END  END END END AS ENTREGA, " + LF

cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,D2_EMISSAO,112)AS INT) END AS DIAS3, " + LF
cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!=''THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END AS TOTALDIAS " + LF

cQuery+="FROM SC5020 SC5  " + LF
cQuery+="JOIN SC6020 SC6 " + LF
cQuery+="ON SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_BLQ <> 'R' AND SC6.D_E_L_E_T_ = '' " + LF
cQuery+="JOIN SC9020 SC9  " + LF
cQuery+="ON SC9.C9_PEDIDO = SC6.C6_NUM and SC9.C9_ITEM = SC6.C6_ITEM AND SC9.D_E_L_E_T_ = ''  " + LF
cQuery+="JOIN SB1010 SB1  " + LF
cQuery+="ON SB1.B1_COD = SC6.C6_PRODUTO AND SB1.B1_TIPO = 'PA' AND SB1.D_E_L_E_T_ = ''  " + LF
cQuery+="JOIN SA1010 SA1  " + LF
cQuery+="ON SC5.C5_CLIENTE+SC5.C5_LOJACLI = SA1.A1_COD+SA1.A1_LOJA AND  " + LF
cQuery+="SA1.A1_SATIV1 IN( '000001','000002','000003','000004') AND SA1.D_E_L_E_T_ = ''  " + LF
cQuery+="LEFT JOIN SD2020 SD2  " + LF
cQuery+="ON D2_PEDIDO = C5_NUM AND D2_ITEMPV = C6_ITEM AND D2_SERIE!='' AND SD2.D_E_L_E_T_ = ''  " + LF
cQuery+="AND D2_DOC=C9_NFISCAL  " + LF
cQuery+="LEFT JOIN SF2020 SF2 " + LF
cQuery+="ON F2_DOC+F2_SERIE=D2_DOC+D2_SERIE AND SF2.D_E_L_E_T_ = '' " + LF

cQuery+="WHERE  (  SC6.C6_QTDVEN - SC6.C6_QTDENT  > 0  OR C9_NFISCAL <> ''  AND D2_EMISSAO >= '20100101' ) " + LF
//cQuery+="AND( (F2_REALCHG ='' OR F2_REALCHG IS NULL) OR CAST(CONVERT(datetime,'"+DTOS(ddatabase)+"',112) - CONVERT(datetime,F2_REALCHG,112)AS INT)<8 ) " + LF
cQuery+="AND SC6.C6_BLQ <> 'R'     " + LF
cQuery+="AND SB1.B1_TIPO = 'PA'    " + LF
cQuery+="AND SC5.C5_TIPO='N'  " + LF
cQuery+="AND SC5.C5_TRANSP!='024'  " + LF
cQuery+="AND SC6.C6_TES != '540'  " + LF

cQuery+="AND SC5.C5_FILIAL='"+xFilial('SC5')+"' " + LF 
cQuery+="AND SC5.D_E_L_E_T_ = '' "  + LF
cQuery+="AND SC6.D_E_L_E_T_ = '' "  + LF
cQuery+="AND SC9.D_E_L_E_T_ = '' "  + LF
cQuery+="AND SB1.D_E_L_E_T_ = '' "  + LF

cQuery+="GROUP BY A1_MUN ,A1_EST ,F2_REALCHG,F2_PREVCHG, F2_RETENC, F2_DTAGCLI, A1_COD,A1_NOME ,C5_NUM ,C5_EMISSAO, " + LF
cQuery+="C9_DTBLCRE ,C5_TRANSP, " + LF
cQuery+="CASE WHEN C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,C9_DTBLCRE,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END , " + LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT='')  " + LF
cQuery+="THEN  " + LF
cQuery+="'Aguardando...'  " + LF
cQuery+="ELSE  " + LF
cQuery+="CASE WHEN (D2_DOC IS NULL AND C5_PREVFAT!='')  " + LF
cQuery+="THEN  " + LF
cQuery+="'Aguardando, Previsão =>'+SUBSTRING(C5_PREVFAT,7,2)+'/'+SUBSTRING(C5_PREVFAT,5,2)+'/'+SUBSTRING(C5_PREVFAT,3,2)  " + LF
cQuery+="ELSE  " + LF
cQuery+="CASE WHEN (NOT D2_DOC IS NULL)  " + LF
cQuery+="THEN  " + LF
cQuery+="SUBSTRING(D2_EMISSAO ,7,2)+'/'+SUBSTRING(D2_EMISSAO ,5,2)+'/'+SUBSTRING(D2_EMISSAO ,3,2)  " + LF
cQuery+="ELSE   " + LF
cQuery+="'NAO'  " + LF
cQuery+="END  "     + LF
cQuery+="END  "  + LF
cQuery+="END, "  + LF
cQuery+="D2_DOC ,F2_OBS , " + LF
cQuery+="CASE WHEN NOT D2_EMISSAO IS NULL AND C9_DTBLCRE!='' THEN CAST( CONVERT(datetime,D2_EMISSAO,112) - CONVERT(datetime,C9_DTBLCRE,112)AS INT)  END , " + LF
cQuery+="CASE WHEN   CONVERT(datetime,C5_ENTREG,112)>CAST(CONVERT(VARCHAR,GETDATE(),112)AS DATETIME) THEN C5_ENTREG ELSE '' END , " + LF

cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN SUBSTRING(F2_REALCHG ,7,2)+'/'+SUBSTRING(F2_REALCHG ,5,2)+'/'+SUBSTRING(F2_REALCHG ,3,2) " + LF
cQuery += " ELSE CASE WHEN NOT F2_DTAGCLI IS NULL AND F2_DTAGCLI!='' THEN 'Agendado pelo Cliente p/ =>'+SUBSTRING(F2_DTAGCLI ,7,2)+'/'+SUBSTRING(F2_DTAGCLI ,5,2)+'/'+SUBSTRING(F2_DTAGCLI ,3,2)" + LF 
cQuery+= " ELSE CASE WHEN NOT F2_DATRASO IS NULL AND F2_DATRASO!='' THEN 'Nova Previsao=>'+SUBSTRING(F2_DATRASO ,7,2)+'/'+SUBSTRING(F2_DATRASO ,5,2)+'/'+SUBSTRING(F2_DATRASO ,3,2) " + LF
cQuery+= " ELSE CASE WHEN NOT F2_PREVCHG IS NULL AND F2_PREVCHG!=''THEN 'Previsao=>'+SUBSTRING(F2_PREVCHG ,7,2)+'/'+SUBSTRING(F2_PREVCHG ,5,2)+'/'+SUBSTRING(F2_PREVCHG ,3,2) " + LF
cQuery+= " END  END END END , "  + LF

cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!='' THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,D2_EMISSAO,112)AS INT) END , " + LF
cQuery+="CASE WHEN NOT F2_REALCHG IS NULL AND F2_REALCHG!=''THEN CAST( CONVERT(datetime,F2_REALCHG,112) - CONVERT(datetime,C5_EMISSAO,112)AS INT)  END  " + LF

cQuery+="ORDER BY C5_NUM " + LF
//Memowrite("C:\Temp\WFfat007.sql",cQuery)
TCQUERY cQuery NEW ALIAS 'AUUX'

TCSetField( 'AUUX', "DIGITACAO", "D")
TCSetField( 'AUUX', "LIBERACAO", "D")
TCSetField( 'AUUX', "PROGRAMADO", "D")
TCSetField( 'AUUX', "F2_DTAGCLI", "D")


AUUX->(DbGoTop())


If !AUUX->(EOF())

	oProcess:=TWFProcess():New("WFFAT007","WFFAT007")
	oProcess:NewTask('Inicio',"\workflow\http\emp01\WFFAT007.html")
	//oProcess:NewTask('Inicio',"\workflow\http\teste\WFFAT007.html")
	oHtml   := oProcess:oHtml
	Do while !AUUX->(EOF())                    
	   Iif(EMPTY(AUUX->F2_REALCHG),lOK:=.T.,iif(ddatabase-StoD(AUUX->F2_REALCHG)<8,lOK:=.T.,lOK:=.F.))  
	    If lOK
	    	    	
	       aadd( oHtml:ValByName("it.cCli") , AUUX->CLIENTE)

           aadd( oHtml:ValByName("it.cMuni") , AUUX->MUNI)
           
           aadd( oHtml:ValByName("it.cUF") , AUUX->UF)
           
           aadd( oHtml:ValByName("it.cPedido") , AUUX->PEDIDO)

           aadd( oHtml:ValByName("it.cTrans") , posicione("SA4",1,xFilial('SA4') + AUUX->C5_TRANSP,"A4_NOME" ))
           
           //aadd( oHtml:ValByName("it.dEmiss") , DTOC(AUUX->DIGITACAO))

	       //aadd( oHtml:ValByName("it.dLibCred") , DTOC(AUUX->LIBERACAO))
	
	       //aadd( oHtml:ValByName("it.cDias1") , STR(AUUX->DIAS1))
	
	       aadd( oHtml:ValByName("it.dFat") , AUUX->FATURAMENTO)
	
	       aadd( oHtml:ValByName("it.cNF") , IIF(!EMPTY(AUUX->NOTA),AUUX->NOTA,"---"))
	
	      // aadd( oHtml:ValByName("it.cObs") , IIF(!EMPTY(AUUX->OBS),AUUX->OBS,"---" ))
	
	      // aadd( oHtml:ValByName("it.cDias2") , STR(AUUX->DIAS2))
	
	       //aadd( oHtml:ValByName("it.cProgram") , IIF(!EMPTY(AUUX->PROGRAMADO),DTOC(AUUX->PROGRAMADO),"Imediato") )
	
	       aadd( oHtml:ValByName("it.dEntreg") , IIF(!EMPTY(AUUX->ENTREGA),AUUX->ENTREGA,"---"))
	
	       aadd( oHtml:ValByName("it.cDias3") , STR(AUUX->DIAS3))
	       
	       aadd( oHtml:ValByName("it.cDiastot") , STR(AUUX->TOTALDIAS))
       
       
       		IF !EMPTY(AUUX->NOTA)
				cDepto 		:= ""
				cOcorren 	:= ""
								
				If Alltrim(AUUX->F2_RETENC) = 'S'
					cObserv	:= "Retenção Fiscal"
				
				Else
					cObserv := ""
				Endif
				
								
				cQuery := "	SELECT UC_CODIGO,UD_ITEM,UC_STATUS,UC_PENDENT,UC_NFISCAL,UC_REALCHG,UD_N2,UD_OPERADO,UD_STATUS,UD_RESOLVI " + LF
			 	cQuery += " FROM " + RetSqlName("SUC") + " SUC, " + LF
			 	cQuery += " " + RetSqlName("SUD") + " SUD " + LF
			 
				cQuery += " WHERE RTRIM(UC_NFISCAL) = '" + Alltrim(AUUX->NOTA) + "' "  + LF
				cQuery += " AND UC_CODIGO = UD_CODIGO"  + LF
				cQuery += "	AND SUC.D_E_L_E_T_ = '' "  + LF
				cQuery += "	AND SUD.D_E_L_E_T_ = '' "  + LF
				cQuery += "	AND UC_OBSPRB <> 'S'"  + LF
				cQuery += "	AND UD_OPERADO <> ''"  + LF
				cQuery += "	AND UD_STATUS <> '2'"  + LF
				If Select("OCO") > 0
					DbSelectArea("OCO")
					DbCloseArea()
				EndIf
				TCQUERY cQuery NEW ALIAS "OCO"			
				OCO->( DbGoTop() )			
				If !OCO->(EOF())
					While OCO->( !EOF() )
						cOcorren += OCO->UC_CODIGO + "-" + OCO->UD_ITEM + " / "
						cDepto   += SUBSTR(POSICIONE("Z46",1,XFILIAL("Z46")+ OCO->UD_N2,"Z46_DESCRI"),1,15) + " / "
						//msgbox("Ocorrencia: " + cOcorren + " - Depto: " + cDepto )
						OCO->(Dbskip())					
					Enddo
					
				Endif
				
				aadd( oHtml:ValByName("it.cOcorr") ,  IIF(!EMPTY(cOcorren) , cOcorren, ""))
				aadd( oHtml:ValByName("it.cDepto") ,  IIF(!EMPTY(cDepto)   , cDepto  , ""))
				aadd( oHtml:ValByName("it.cRet_Agd") , cObserv )
				
				
				
	   		ELSE
	       		aadd( oHtml:ValByName("it.cOcorr") ,  "")
				aadd( oHtml:ValByName("it.cDepto") ,  "")
				aadd( oHtml:ValByName("it.cRet_Agd") , cObserv )
	        ENDIF
        
        Endif
        
		AUUX->( DBSKIP() )
	Enddo
	
	 _user := Subs(cUsuario,7,15)
	 oProcess:ClientName(_user)
	 oProcess:cTo := "geisa@ravaembalagens.com.br;alexandre@ravaembalagens.com.br;joao.emanuel@ravaembalagens.com.br;daniela@ravaembalagens.com.br;alexandre.saraiva@ravaembalagens.com.br;marcilio@ravaembalagens.com.br;antonio@ravaembalagens.com.br" 
	 oProcess:cCC := "flavia.rocha@ravaembalagens.com.br"
	 subj	:= "Situação de Faturamento ate Entrega"
	 oProcess:cSubject  := subj
	 oProcess:Start()
	 WfSendMail()
//	 msginfo("EMAIL ENVIADO") 
Endif
AUUX->(DbCloseArea())
Return
*/