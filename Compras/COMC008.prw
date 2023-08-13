#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "TbiConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMC008   º Autor ³ Gustavo Costa      º Data ³  11/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envio por email a lista dos pedidos de compra bloqueados.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COMC008()

// executa primeiro para Saco
RPCSetType( 3 )
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "COMC008" Tables "SC7", "SC1"
sleep( 5000 )
conOut( "Programa COMC008 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
fListaPC()

conOut( "Finalizando fListaPC na emp. 02 filial " + xFilial() + " em " + Dtoc( DATE() ) + ' - ' + Time() )
Reset environment

// executa segundo para caixa
RPCSetType( 3 )
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" FUNNAME "COMC008" Tables "SC7"
sleep( 5000 )
conOut( "Programa COMC008 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
fListaPC()

conOut( "Finalizando fListaPC na emp. 02 filial " + xFilial() + " em " + Dtoc( DATE() ) + ' - ' + Time() )

conOut( "Finalizando programa COMC008 em " + Dtoc( DATE() ) + ' - ' + Time() )
// Habilitar somente para Schedule
Reset environment	

Return


*************

Static Function fListaPC()

*************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cQuery 		:= ""
Local cMensagem 	:= ""
Local cPedAnt		:= ""
Local lCabec		:= .T.
Local lRodape		:= .F.
Local nTotal		:= 0
Local cNomeEmp	:= ""
Local nCont			:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Corpo do Programa                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While nCont < 3

	cQuery := "SELECT C7_NUM, C7_FORNECE, A2_NOME, C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_EMISSAO, C7_DATPRF, "
	cQuery += "C7_QUJE, C7_QUANT, C7_PRECO, C7_TOTAL, C7_VALFRE "
	cQuery += "FROM " + retSqlName('SC7') + " SC7 "
	cQuery += "INNER JOIN " + retSqlName('SA2') + " SA2 "
	cQuery += "ON C7_FORNECE = A2_COD "
	cQuery += "AND C7_LOJA = A2_LOJA "
	cQuery += "WHERE  C7_QUJE = 0 "
	cQuery += "AND C7_CONAPRO <> 'L' "
	cQuery += "AND C7_RESIDUO <> 'S' "
	cQuery += "and C7_FILIAL = '"+xFilial('SC1')+"' " 
	cQuery += "and SC7.D_E_L_E_T_ != '*' "
	
	If nCont = 1
		cQuery += "AND SUBSTRING(C7_CC,1,1) <> '7' "
	Else
		cQuery += "AND SUBSTRING(C7_CC,1,1) = '7' "
	EndIf
	
	cQuery += "ORDER BY C7_NUM, C7_ITEM, C7_EMISSAO "
	
	If Select("_TMPK") > 0       
		_TMPK->(DbCloseArea())
	Endif
	
	TCQUERY cQuery NEW ALIAS "_TMPK"
	
	dbSelectArea("SM0")
	
	cNomeEmp	:= SM0->M0_FILIAL
	
	dbSelectArea("_TMPK")
	_TMPK->( dbGoTop() )
	
	If _TMPK->( EOF() )
	
		//MsgAlert("Nenhum pedido a ser enviado.")
		ConOut("Nenhum pedido a ser enviado.")
		Return
	EndIf
	
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
	cMensagem += '}'
	cMensagem += '-->'
	cMensagem += '</style>'
	cMensagem += '</head>'
	cMensagem += '<body>'
	cMensagem += '<table width="873" border="1">'
	
	While !_TMPK->( EoF() )
	
		If lcabec
			cMensagem += '<tr bgcolor="#00CC66">'
	       cMensagem += '	<th scope="col" colspan="6">'
	       cMensagem += '    <span class="style2"> Pedido - ' + _TMPK->C7_NUM + ' - ' + _TMPK->A2_NOME + ' em ' + dtoc(stod(_TMPK->C7_EMISSAO))
	       cMensagem += '    </span></th></tr>'
	         
	       cMensagem += '     <tr bgcolor="#00CC66">'    
	       cMensagem += '         <th width="90" scope="col">'
	       cMensagem += '         <span class="style1">C&oacute;d. Produto </span></th>'    
	       cMensagem += '         <th width="270" scope="col">'
	       cMensagem += '         <span class="style1">Descri&ccedil;&atilde;o</span></th>'    
	       cMensagem += '         <th width="73" scope="col">'
	       cMensagem += '         <span class="style1">Qtd. do Pedido  </span></th>'  
	       cMensagem += '         <th width="78" scope="col">'
	       cMensagem += '         <span class="style1">Val. Unit. </span></th>'    
	       cMensagem += '         <th width="100" scope="col">'
	       cMensagem += '         <span class="style1">Total </span></th> ' 
	       cMensagem += '         <th scope="col" width="80">'
	       cMensagem += '         <span class="style1">Entrega&nbsp;</span></th>'
	       cMensagem += '     </tr>'  
	
			lCabec := .F.
		EndIf
		
		cMensagem += '  <tr>'
		cMensagem += '    <td><div align="center">'+_TMPK->C7_PRODUTO+'</div></td>'
		cMensagem += '    <td><div align="center">'+_TMPK->C7_DESCRI +'</div></td>'
		cMensagem += '    <td><div align="center">'+transform(_TMPK->C7_QUANT, "@E 999,999,999")+'</div></td>'
		cMensagem += '    <td><div align="right" >'+transform(_TMPK->C7_PRECO, "@E 999,999.99")+'</div></td>'
		cMensagem += '    <td><div align="right" >'+transform(_TMPK->C7_TOTAL,"@E 9,999,999.99")+'</div></td>'
		cMensagem += '    <td><div align="center">'+dtoc(stod(_TMPK->C7_DATPRF)) +'</div></td>'
		cMensagem += '  </tr>'
	
		nTotal		:= nTotal + _TMPK->C7_TOTAL
		
		cPedAnt	:= _TMPK->C7_NUM
		
		_TMPK->( dbSkip() )
		
		If cPedAnt	<> _TMPK->C7_NUM
		
			lCabec 	:= .T.
			lRodape	:= .T.
		EndIf
	
		If lRodape
			cMensagem += '<tr >'
			cMensagem += '	<th scope="col" colspan="4">'
			cMensagem += '	<span class="style2">TOTAL ----> </span></th>'
			cMensagem += '	<th scope="col" colspan="2">'
			cMensagem += '	<span class="style2"> ' + transform(nTotal,"@E 99,999,999.99") + '</span></th>'
			cMensagem += '</tr>'
			cMensagem += '<tr>'
	       cMensagem += '   	<th scope="col" colspan="6">'
	       cMensagem += '	</th>'
	       cMensagem += '</tr>'
			nTotal 	:= 0
			lRodape := .F.
		EndIf
		//cMensagem += '<tr>'
		//cMensagem += '   	<th scope="col" colspan="6">'
		//cMensagem += cQuery + '	</th>'
		//cMensagem += '</tr>'
	endDo
	
	cMensagem += '</table>'
	cMensagem += '</body>'
	cMensagem += '</html>'
	
	_TMPK->( dbCloseArea() )
	
	If nCont == 1
		cEmail   	:= GetNewPar("MV_XPCBLC","gustavo@ravaembalagens.com.br") 
	Else
		cEmail   	:= GetNewPar("MV_XPCBLC2","gustavo@ravaembalagens.com.br") 
	EndIf
	cCopia   	:= ""//GetNewPar("gustavo@ravaembalagens.com.br") 
	cAssunto 	:= "Lista dos Pedidos de Compra bloqueados - " + cNomeEmp
	cAnexo		:= ""
	
	U_SendFatr11( cEmail, cCopia, cAssunto, cMensagem, cAnexo )
	//ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
	
	nCont  := nCont + 1
	
EndDo

Return