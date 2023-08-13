#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"

*************

User Function MA410DEL()

*************   

Local nPOSPRO := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
Local nPOSDEC := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_DESCRI"  } )
Local nPOSQTD := aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_QTDVEN"  } )

cMensagem:="Segue abaixo informações sobre o Pedido Cancelado.<br><br>"
cMensagem+="Nº Pedido: "+SC5->C5_NUM+"<br>"
cMensagem+="Data de Emissão:"+dtoc(SC5->C5_EMISSAO)+"<br><br>"


// Funcao HTML para gerar o GRID(Codigo,Descricao,Quantidade)
cMensagem+=' <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
cMensagem+='<html xmlns="http://www.w3.org/1999/xhtml"> '
cMensagem+='<head> '
cMensagem+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
cMensagem+='<title>Untitled Document</title> '
cMensagem+='<style type="text/css"> '
cMensagem+='<!-- '
cMensagem+='.style1 {font-family: Arial, Helvetica, sans-serif} '
cMensagem+='.style7 {color: #FFFFFF; font-family: Arial, Helvetica, sans-serif;} '
cMensagem+='.style8 {color: #FFFFFF} '
cMensagem+='--> '
cMensagem+='</style> '
cMensagem+='</head>  '

cMensagem+='<body> '
cMensagem+='<table width="797" border="1"> '
cMensagem+=' <tr bgcolor="#00CC33">  '
cMensagem+='<td width="147"><span class="style7">C&oacute;digo</span></td> '
cMensagem+='<td width="471"><span class="style7">Descri&ccedil;&atilde;o</span></td> '
cMensagem+='<td width="157"><div align="right" class="style8"> '
cMensagem+='<div align="right"><span class="style1">Quantidade</span></div> '
cMensagem+='</div></td> '
cMensagem+='</tr> '

for nT := 1 to Len(aCols) 

cMensagem+='<tr> '
cMensagem+='<td>'+aCols[nT,nPOSPRO]+'</td> ' //Codigo
cMensagem+='<td>'+Posicione('SB1',1,xFilial("SB1")+aCols[nT,nPOSPRO],"B1_DESC")+'</td> ' // Descicao
cMensagem+='<td><div align="right">'+transform(aCols[nT,nPOSQTD],"@E 999,999,999.99")+'</div></td> '//Quantidade
cMensagem+='</tr> '

next nT  

cMensagem+='</table> '
cMensagem+='</body> '
cMensagem+='</html>  '


// Teste
//cEmail   :="antonio@ravaembalagens.com.br"

// Lindenberg
cEmail   :="lindenberg@ravaembalagens.com.br"


cAssunto := "Pedido Cancelado"

//ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )

         
Return 