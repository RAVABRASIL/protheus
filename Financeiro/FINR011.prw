#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include "Tbiconn.ch " 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINR011  ºAutor  ³  Gustavo Costa       º Data ³ 26/06/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia os titulos por email para serem cobrados.             º±±
±±º          ³														           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

********************************
User Function WFINR011()
********************************

  //SACOS
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" 
  sleep( 5000 )
  U_FINR011()      
  Reset Environment 

Return

*************

User Function FINR011()

*************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cMensagem 	:= ""
Local cQuery		:= ""
Local lRodape		:= .F.
Local nDividendo	:= 3
Local cCliAnt		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Corpo do Programa                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := " SELECT TOP 200 E1_FILIAL, E1_CLIENTE, E1_LOJA, A1_NOME, A1_TEL, E1_PREFIXO, E1_NUM, E1_PARCELA, "  
cQuery += " E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_PORTADO, E1_CONTA, "
cQuery += " (SELECT TOP 1 YP_TEXTO FROM " + RETSQLNAME("SYP") + " WHERE YP_CHAVE = UC_CODOBS AND D_E_L_E_T_ <> '*') AS OBS_SAC"
cQuery += " FROM " + RETSQLNAME("SE1") + " E1 "
cQuery += " INNER JOIN " + RETSQLNAME("SA1") + " A1 "
cQuery += " ON E1_CLIENTE = A1_COD	"
cQuery += " AND E1_LOJA = A1_LOJA "
cQuery += " INNER JOIN " + RETSQLNAME("SUC") + " SU " 
cQuery += " ON UC_FILIAL = E1_FILIAL "
cQuery += " AND UC_NFISCAL = E1_NUM "
cQuery += " AND UC_SERINF = E1_PREFIXO "
cQuery += " WHERE E1_SALDO > 0 "
cQuery += " AND E1.D_E_L_E_T_ <> '*' " 
cQuery += " AND E1_TIPO NOT IN ('NCC','RA') " 
cQuery += " AND E1_STATUS = 'A' "
cQuery += " AND A1_SATIV1 <> '000009' "

If Time() < "12:00:00"
	//Titulos vencidos ontem
	If DOW(dDataBase) = 2 // se for segunda feira, pega data da sexta.
		cQuery += " AND E1_VENCREA = '" + DtoS(dDataBase - 3) + "' "
	Else
		cQuery += " AND E1_VENCREA = '" + DtoS(dDataBase - 1) + "' "
	EndIf 
Else
	//Resto dos titulos vencidos
	cQuery += " AND E1_VENCREA < '" + DtoS(dDataBase - 1) + "' " 
	cQuery += " AND E1_DTVARIA <= '" + DtoS(dDataBase - 1) + "' " 

EndIf
//cQuery += " AND E1_PREFIXO <> '' "
cQuery += " ORDER BY E1_VENCREA DESC "

conOut( cQuery )

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( 'TMP', 'E1_EMISSAO', 'D' )
TCSetField( 'TMP', 'E1_VENCREA', 'D' )

cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
cMensagem += '<head>'
cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cMensagem += '<title>Untitled Document</title>'
cMensagem += '<style type="text/css">'
cMensagem += '<!--'
cMensagem += '.style1 {'
cMensagem += '	font-family: Arial, Helvetica, sans-serif;'
cMensagem += '	color: #FFFFFF;'
cMensagem += '}'
cMensagem += '.style2 {'
cMensagem += '	font-family: Arial, Helvetica, sans-serif;'
cMensagem += '	color: #000000;'
cMensagem += '	font-size: 12px;'
cMensagem += '}'
cMensagem += '.style7 {color: #FFFFFF; font-weight: bold; font-family: Arial, Helvetica, sans-serif; }'
cMensagem += '.style8 {font-weight: bold; font-family: Arial, Helvetica, sans-serif}'
cMensagem += '.style9 {font-family: Arial, Helvetica, sans-serif; font-weight: bold; color: #FFFFFF; }'
cMensagem += '-->'
cMensagem += '</style>'
cMensagem += '</head>'
cMensagem += '<body>'
cMensagem += '<table width="800" border="0">'
cMensagem += '  <tr>'
cMensagem += '    <td colspan="12" bgcolor="#336600"><span class="style9">LISTA DE TÍTULOS PARA COBRANÇA</span></td>'
cMensagem += '  </tr>'
cMensagem += '  <tr>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Filial</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Cliente</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Nome</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Telefone</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Titulo</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Parc</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Emissão</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Vencimento</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Valor</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Saldo</span></td>'
cMensagem += '    <td width="10" bgcolor="#336600"><span class="style9">Banco/Conta</span></td>'
cMensagem += '    <td width="608" bgcolor="#336600"><span class="style9">OBS. SAC</span></td>'
cMensagem += '  </tr>'

TMP->( dbGoTop() )

While TMP->( !EoF() )

	If Mod ( nDividendo, 2 ) > 0
	
		cMensagem += '  <tr>'
		cMensagem += '    <td><span class="style2">' + TMP->E1_FILIAL + '</span></td>'
		cMensagem += '    <td><span class="style2">' + TMP->E1_CLIENTE + '-' + TMP->E1_LOJA + '</span></td>'
		cMensagem += '    <td><span class="style2">' + TMP->A1_NOME + '</span></td>'
		cMensagem += '    <td><span class="style2">' + TMP->A1_TEL + '</span></td>'
		cMensagem += '    <td><span class="style2">' + TMP->E1_PREFIXO + '-' + TMP->E1_NUM  + '</span></td>'
		cMensagem += '    <td><span class="style2">' + TMP->E1_PARCELA + '</span></td>'
		cMensagem += '    <td><span class="style2">' + DtoC(TMP->E1_EMISSAO) + '</span></td>'
		cMensagem += '    <td><span class="style2">' + DtoC(TMP->E1_VENCREA) + '</span></td>'
		cMensagem += '    <td><span class="style2">' + Transform(TMP->E1_VALOR,'@E 9,999,999.99') + '</span></td>'
		cMensagem += '    <td><span class="style2">' + Transform(TMP->E1_SALDO,'@E 9,999,999.99') + '</span></td>'
		cMensagem += '    <td><span class="style2">' + TMP->E1_PORTADO + '-' + TMP->E1_CONTA + '</span></td>'
		cMensagem += '    <td><span class="style2">' + TMP->OBS_SAC + '</span></td>'
		cMensagem += '  </tr>
	
	Else
	
		cMensagem += '  <tr>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + TMP->E1_FILIAL + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + TMP->E1_CLIENTE + '-' + TMP->E1_LOJA + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + TMP->A1_NOME + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + TMP->A1_TEL + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + TMP->E1_PREFIXO + '-' + TMP->E1_NUM  + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + TMP->E1_PARCELA + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + DtoC(TMP->E1_EMISSAO) + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + DtoC(TMP->E1_VENCREA) + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + Transform(TMP->E1_VALOR,'@E 9,999,999.99') + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + Transform(TMP->E1_SALDO,'@E 9,999,999.99') + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + TMP->E1_PORTADO + '-' + TMP->E1_CONTA + '</span></td>'
		cMensagem += '    <td bgcolor="#91FFB5"><span class="style2">' + TMP->OBS_SAC + '</span></td>'
		cMensagem += '  </tr>
	
	EndIf
	
	TMP->( dbSkip() )
	nDividendo	:= nDividendo + 1
	
endDo

cMensagem += '</table>'
cMensagem += '</body>'
cMensagem += '</html>'

cEmail   	:= GetNewPar("MV_XSERASA","gustavo@ravaembalagens.com.br") 

cCopia   	:= GetNewPar("MV_XCPSERA","gustavo@ravaembalagens.com.br") 
cAssunto 	:= "Lista dos Títulos a serem cobrados"
cAnexo		:= ""

//U_fNewSendMail(cEmail, cAssunto, cMensagem, '', cCopia)

lRet	:= U_SendFatr11( cEmail, cCopia, cAssunto, cMensagem, cAnexo )
/*			
If lRet
	msgAlert("Email enviado com sucesso!")
Else
	msgAlert("Falha no envio do email, por favor, tente novamente.")
EndIf
*/
TMP->(DbCloseArea())

Return

