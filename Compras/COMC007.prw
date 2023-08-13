#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "Ap5Mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWF_COMC007บAutor  ณGustavo Costa       บ Data ณ  01/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio enviado por email para os diretores com as SC     บฑฑ
ฑฑบ          ณBloqueadas (Falta liberar).  								    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACOM                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function  WF_COMC007()


Local cCopia 		:= ""
Local cMailTo 		:= GetNewPar('MV_XMAILSC',"gustavo@ravaembalagens.com.br")
Local lEnviado		:= .F.
Local cTitulo		:= "Solicita็๕es de Compras em Aberto - " + DtoC(dDataBase)
Local cCabec		:= ""
Local cConteudo		:= ""
Local cAnexo		:= ""
LOCAL lOk			:= .F.
LOCAL cQry			:= ''
Local cCCAnt		:= ""

cCabec +="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
cCabec +="<html xmlns='http://www.w3.org/1999/xhtml' >"
cCabec +="<head>"
cCabec +="	<title>Untitled Page</title>"
cCabec +="</head>"
cCabec +="<body>"
cCabec +="    <table width='800' height='79' border='1'>"
cCabec +="        <tr>
cCabec +="            <td align='center' colspan='6' bgcolor='#009933'>"
cCabec +="               <strong> LISTA DAS SOLICITAวรO DE COMPRA - " + DtoC(dDataBase) + "</strong> </td>"
cCabec +="        </tr>"
cCabec +="        <tr>"
cCabec +="            <td align='center' width='80' height='23' bgcolor='#CCFFCC'>"
cCabec +="                <strong>NฺMERO</strong></td>"
cCabec +="            <td align='center' width='228' bgcolor='#CCFFCC'>"
cCabec +="                <strong>SOLICITANTE</strong></td>"
cCabec +="            <td align='center' width='40' bgcolor='#CCFFCC'>"
cCabec +="                <strong>CENTRO DE CUSTO</strong></td>"
cCabec +="        </tr>"
            
//CONSULTA DAS SOLICITAวีES.

cQry	:= " SELECT C1_NUM, C1_SOLICIT, C1_CC FROM " + RETSQLNAME("SC1") + " C1 "
cQry	+= " WHERE C1.D_E_L_E_T_ <> '*' "
cQry	+= " AND C1_QUANT - C1_QUJE > 0 "
cQry	+= " AND C1_APROV = 'B' "
cQry	+= " ORDER BY C1_CC, C1_FILIAL, C1.C1_NUM "

TCQUERY cQry NEW ALIAS "XTMP"

XTMP->(dbgotop())

While XTMP->(!EOF())
   
	cConteudo +="        <tr>"
	cConteudo +="            <td align='left' width='80' height='23'>"
	cConteudo += aCols[x][nPosPrd] + "</td>"
	cConteudo +="            <td align='left' width='228'>"
	cConteudo += aCols[x][nPosDesc] + "</td>"
	cConteudo +="            <td align='center' width='40'>"
	cConteudo += aCols[x][nPosUM] + "</td>"
	cConteudo +="            <td align='rigth' width='90'>"
	cConteudo += Transform(aCols[x][nPosQtd],"@E 99,999,999.99") + "</td>"
	cConteudo +="            <td align='rigth' width='100'>"
	cConteudo += Transform(nVal,"@E 99,999,999.99") + "</td>"
	cConteudo +="            <td align='left' width='222'>"
	cConteudo += aCols[x][nPosOBS] + "</td>"
	cConteudo +="        </tr>"
	
	cCCAnt	:= XTMP->C1_CC
   
	XTMP->(dbskip())

	If cCCAnt <> XTMP->C1_CC
    
	EndIf
   
EndDo

XTMP->(DBCLOSEAREA())

//Itens

//Totalizador
cConteudo +="<tr>"
cConteudo +="    <td height='23' colspan='5' bgcolor='#CCFFCC'><strong> TOTAL </strong></td>"
cConteudo +="    <td align='rigth' width='90' bgcolor='#CCFFCC'><strong>"
cConteudo += Transform(nTotal,"@E 99,999,999.99") + "</strong></td>"
cConteudo +="  </tr>"

cConteudo +="    </table>"
cConteudo +="</body>"
cConteudo +="</html>"

cCopia 	:= GetNewPar('MV_XCOPSC',"gustavo@ravaembalagens.com.br")

cAnexo	:= ""

If SubStr(aCols[1][nPosCC],1,1) $ "7" //Produ็ใo
	cMailTo 	:= GetNewPar('MV_XMAILSC1',"orley@ravaembalagens.com.br")
Else
	cMailTo 	:= GetNewPar('MV_XMAILSC2',"rh@ravaembalagens.com.br")
EndIf

lEnviado := U_SendFatr11( cMailTo, cCopia, cTitulo, cConteudo, cAnexo )

Return .T. 


