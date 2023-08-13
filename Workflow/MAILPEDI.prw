#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "TbiConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บ Autor ณ AP6 IDE            บ Data ณ  17/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

*************

User Function MAILPEDI()

*************

If Select( 'SX2' ) == 0
	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "MAILPEDI" Tables "SE1"
	sleep( 5000 )
	conOut( "Programa MAILPEDI na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
	EnviaMail()
Else
	conOut( "Programa MAILPEDI sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
	EnviaMail()
EndIf
conOut( "Finalizando programa MAILPEDI em " + Dtoc( DATE() ) + ' - ' + Time() )

Return


*************

Static Function EnviaMail()

*************
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cQuery := cMensagem := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Corpo do Programa                                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery += "select C7_NUM,C7_PRODUTO,C7_DESCRI,C7_EMISSAO,C7_DATPRF,C7_QUJE,C7_QUANT "
cQuery += "from   "+retSqlName('SC7')+" SC7, "+retSqlName('SC1')+" SC1 "
cQuery += "where  C7_NUMSC = C1_NUM and C1_ITEM + C1_PRODUTO = C7_ITEM + C7_PRODUTO and "
cQuery += "C1_EMISSAO <= '"+dtos(dDataBase - 15)+"'  and "//15 dias atrแs
cQuery += "C7_QUJE < C7_QUANT and C7_RESIDUO != 'S' and "
cQuery += "C7_FILIAL = '"+xFilial('SC7')+"' and SC7.D_E_L_E_T_ != '*' and "
cQuery += "C1_FILIAL = '"+xFilial('SC1')+"' and SC1.D_E_L_E_T_ != '*' "
cQuery += "order by C7_EMISSAO asc "
TCQUERY cQuery NEW ALIAS "_TMPK"
_TMPK->( dbGoTop() )

cMensagem += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
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
cMensagem += '-->'
cMensagem += '</style>'
cMensagem += '</head>'
cMensagem += '<body>'
cMensagem += '<table width="873" border="1">'
cMensagem += '  <tr bgcolor="#00CC66">'
cMensagem += '    <th width="125" scope="col"><span class="style1">Nบ do Pedido</span></th>'
cMensagem += '    <th width="125" scope="col"><span class="style1">C&oacute;d. Produto </span></th>'
cMensagem += '    <th width="269" scope="col"><span class="style1">Descri&ccedil;&atilde;o</span></th>'
cMensagem += '    <th width="149" scope="col"><span class="style1">Data do Pedido </span></th>'
//cMensagem += '    <th width="132" scope="col"><span class="style1">Data de Entrega </span></th>'
cMensagem += '    <th width="78" scope="col"><span class="style1">Qtd. do Pedido </span></th>'
cMensagem += '    <th width="80" scope="col"><span class="style1">Qtd. Entregue </span></th>'
cMensagem += '  </tr>'
do While !_TMPK->( EoF() )
	cMensagem += '  <tr>'
	cMensagem += '    <td><div align="center">'+_TMPK->C7_NUM    +'</div></td>'
	cMensagem += '    <td><div align="center">'+_TMPK->C7_PRODUTO+'</div></td>'
	cMensagem += '    <td><div align="center">'+_TMPK->C7_DESCRI +'</div></td>'
	cMensagem += '    <td><div align="center">'+dtoc(stod(_TMPK->C7_EMISSAO))+'</div></td>'
	//cMensagem += '    <td><div align="center">'+dtoc(stod(_TMPK->C7_DATPRF)) +'</div></td>'
	cMensagem += '    <td><div align="right" >'+transform(_TMPK->C7_QUANT, "@E 999,999.99")+'</div></td>'
	cMensagem += '    <td><div align="right" >'+transform(_TMPK->C7_QUJE,"@E 999,999.99")+'</div></td>'
	cMensagem += '  </tr>'
	_TMPK->( dbSkip() )
endDo
cMensagem += '</table>'
cMensagem += '</body>'
cMensagem += '</html>'

_TMPK->( dbCloseArea() )

cEmail   :="marcelo@ravaembalagens.com.br"
cAssunto := "Pedidos em aberto"
//ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )

Return