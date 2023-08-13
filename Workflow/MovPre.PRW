#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include "Tbiconn.ch "

User Function MovPre()
Local cQuery:=cQuery2:=" "
Local nDif:=0
Local aDados:={}
Local aEdita:={}
Local aPedido:={}
Local nIdx:=0
Private cMensagem   
Private aGrps  := {}
aGrps     := U_GetGrps(Substr( cUsuario,7,15 ))

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "MovPre" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa MovPre na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa MovPre sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
conOut( "Finalizando programa MovPre em " + Dtoc( DATE() ) + ' - ' + Time() )
Return

Static Function Exec() 


cQuery2:=" SELECT  Z5_NUM,Z5_EDITAL,Z5_EMISSAO,SUM(Z6_QTDVEN)QTDVEN "
cQuery2+=" FROM "+RetsqlName('SZ5')+" SZ5  JOIN "+RetsqlName('SZ6')+" SZ6 "
cQuery2+=" ON Z5_FILIAL+Z5_NUM=Z6_FILIAL+Z6_NUM "  
cQuery2+=" AND  SZ6.D_E_L_E_T_!='*' "
cQuery2+="JOIN "+RetsqlName('SA1')+" SA1 ON SA1.A1_COD=SZ5.Z5_CLIENTE AND  SA1.D_E_L_E_T_!='*'  "
cQuery2+=" WHERE  Z5_FILIAL='"+xFilial('SZ5')+"' AND SZ5.D_E_L_E_T_!='*' "   

/*IF "LICITACAO" $ aGrps[3]
   cQuery2+="AND  A1_SATIV1='000009' "  //RAVA DIRETO
ELSE
   cQuery2+="AND  A1_SATIV1!='000009' " // DISTRIBUIDOR
ENDIF*/ 

cQuery2+=" GROUP BY Z5_NUM,Z5_EDITAL,Z5_EMISSAO "     
cQuery2+=" ORDER BY Z5_NUM  "  
TCQUERY cQuery2 NEW ALIAS 'AUUX'

TCSetField( "AUUX", "Z5_EMISSAO",  "D", 8, 0 )	
 
AUUX->(DBGOTOP()) 


if AUUX->(!EOF())

cMensagem:=" "

//

While AUUX->(!EOF())
 
 aPedido:=Pedido(AUUX->Z5_NUM)
 
 if EMPTY(aPedido[1][1])
   nDif:= ( DDATABASE -AUUX->Z5_EMISSAO)
   if nDif>=30
     
     aEdita:=Edital(AUUX->Z5_EDITAL)
   //  nIdx := aScan( aEdita, { |t| t[6]!='03' } ) // Edital nao foi concluido
       
     //if nIdx > 0
	     cMensagem+= +" Pre-Pedido: "+alltrim(AUUX->Z5_NUM)
	     cMensagem+= +" Dias Sem Movimentacao:  "+alltrim(str(nDif))+"<BR>"
	     
	     //
	     
	     for y:=1 to len(aEdita)
		     cMensagem+= +" Licitante:  "+alltrim(Posicione('Z15',1,xFilial("Z15")+aEdita[y][1],"Z15_NOMLIC"))
		     cMensagem+= +" Edital: "+alltrim(aEdita[y][5])
		     cMensagem+= +" Modalidade: "+iif(alltrim(aEdita[y][4]) == '01', "PP",    iif( alltrim(aEdita[y][4]) == '02', "PE" ,;
		                                  iif( alltrim(aEdita[y][4]) == '03', "CP",   iif( alltrim(aEdita[y][4]) == '04', "TP" ,;
		                                  iif(alltrim(aEdita[y][4]) == '05', "CC",    iif( alltrim(aEdita[y][4]) == '06', "DL",;
			                              iif( alltrim(aEdita[y][4]) == '07', "CE ",  iif( alltrim(aEdita[y][4]) == '08', "EP ",  iif(alltrim(aEdita[y][4]) =='09','Adesao',iif(alltrim(aEdita[y][4]) =='10','Prorrogacao',iif(alltrim(aEdita[y][4]) =='11','Acrescimo',iif(alltrim(aEdita[y][4]) =='12','Convite Eletronico','')))) ) ) ) ) ) ) ) )
		     cMensagem+= +" Data de Abertura: "+alltrim(Dtoc(aEdita[y][2]))
		     cMensagem+= +" Hora: "+alltrim(aEdita[y][3])+"<br><br>"
	     next
	     //
	     aDados:=Itens(AUUX->Z5_NUM)
	
	     cMensagem+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
	     cMensagem+='<html xmlns="http://www.w3.org/1999/xhtml"> '
	     cMensagem+='<head> '
	     cMensagem+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
	     cMensagem+='<title>Untitled Document</title> '
	     cMensagem+='<style type="text/css"> '
	     cMensagem+='<!-- '
	     cMensagem+='.style1 {color: #FFFFFF} '
	     cMensagem+='--> '
	     cMensagem+='</style> '
	     cMensagem+='</head> '
	     cMensagem+='<body> '
	     cMensagem+='<table width="751" height="66" border="1"> '
	     cMensagem+='<tr bgcolor="#00CC66"> '
	     cMensagem+='<td width="148"><span class="style1">Produto</span></td> '
	     cMensagem+='<td width="330"><span class="style1">Descricao</span></td> '
	     cMensagem+='<td width="81"><span class="style1">Unidade</span></td> '
	     cMensagem+='<td width="164"><span class="style1">Quantidade</span></td> '
	     cMensagem+='</tr> '
	     for z:=1 to len(aDados)
		     cMensagem+='<tr> '
		     cMensagem+='<td>'+alltrim(aDados[z][1])+'</td> '
		     cMensagem+='<td>'+alltrim(aDados[z][2])+'</td> '
		     cMensagem+='<td>'+alltrim(aDados[z][3])+'</td>  '
		     cMensagem+='<td><div align="right">'+transform(aDados[z][4],"@E 999,999,999.99")+'</div></td> '
		     cMensagem+='</tr> '
	     next
	     cMensagem+='</table> '
	     cMensagem+='</body> '
	     cMensagem+='</html> '
	     cMensagem+="<BR>"
    // Endif
   EndIf
 else
   nDif:= (DDATABASE-aPedido[1][1])
   if nDif>=30
     
     aEdita:=Edital(AUUX->Z5_EDITAL)
     //nIdx := aScan( aEdita, { |t| t[6]!='03' } ) // Edital nao foi concluido
       
     if aPedido[1][2] < AUUX->QTDVEN //.AND. nIdx > 0
	                       
	     cMensagem+= +" Pre-Pedido: "+alltrim(AUUX->Z5_NUM)
	     cMensagem+= +" Dias Sem Movimentacao:  "+alltrim(str(nDif))+"<BR>"
	     
	     //
	     aEdita:=Edital(AUUX->Z5_EDITAL)
	     for y:=1 to len(aEdita)
		     cMensagem+= +" Licitante:  "+alltrim(Posicione('Z15',1,xFilial("Z15")+aEdita[y][1],"Z15_NOMLIC"))
		     cMensagem+= +" Edital: "+alltrim(aEdita[y][5])
		     cMensagem+= +" Modalidade: "+iif(alltrim(aEdita[y][4]) == '1', "PP",    iif( alltrim(aEdita[y][4]) == '2', "PE" ,;
		                                  iif( alltrim(aEdita[y][4]) == '3', "CP",    iif( alltrim(aEdita[y][4]) == '4', "TP" ,;
		                                  iif(alltrim(aEdita[y][4]) == '5', "CC",    iif( alltrim(aEdita[y][4]) == '6', "DL",;
			                              iif( alltrim(aEdita[y][4]) == '7', "CE ",  "EP" ) ) ) ) ) ) ) 
		     cMensagem+= +" Data de Abertura: "+alltrim(Dtoc(aEdita[y][2]))
		     cMensagem+= +" Hora: "+alltrim(aEdita[y][3])+"<br><br>"
	     next
	     //
	     
	     aDados:=Itens(AUUX->Z5_NUM)
	
	     cMensagem+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
	     cMensagem+='<html xmlns="http://www.w3.org/1999/xhtml"> '
	     cMensagem+='<head> '
	     cMensagem+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
	     cMensagem+='<title>Untitled Document</title> '
	     cMensagem+='<style type="text/css"> '
	     cMensagem+='<!-- '
	     cMensagem+='.style1 {color: #FFFFFF} '
	     cMensagem+='--> '
	     cMensagem+='</style> '
	     cMensagem+='</head> '
	     cMensagem+='<body> '
	     cMensagem+='<table width="751" height="66" border="1"> '
	     cMensagem+='<tr bgcolor="#00CC66"> '
	     cMensagem+='<td width="148"><span class="style1">Produto</span></td> '
	     cMensagem+='<td width="330"><span class="style1">Descricao</span></td> '
	     cMensagem+='<td width="81"><span class="style1">Unidade</span></td> '
	     cMensagem+='<td width="164"><span class="style1">Quantidade</span></td> '
	     cMensagem+='</tr> '
	     for x:=1 to len(aDados)
		     cMensagem+='<tr> '
		     cMensagem+='<td>'+alltrim(aDados[x][1])+'</td> '
		     cMensagem+='<td>'+alltrim(aDados[x][2])+'</td> '
		     cMensagem+='<td>'+alltrim(aDados[x][3])+'</td>  '
		     cMensagem+='<td><div align="right">'+transform(aDados[x][4],"@E 999,999,999.99")+'</div></td> '
		     cMensagem+='</tr> '
	     next
	     cMensagem+='</table> '
	     cMensagem+='</body> '
	     cMensagem+='</html> '
	     cMensagem+="<BR>"
     EndIf  
   Endif
 Endif
AUUX->(DbSkip())
//cMensagem+="<BR>"
EndDo




// Teste
//cEmail   :="antonio@ravaembalagens.com.br"
// Pessoal da licitacao 
cEmail   :="licitacao@ravaembalagens.com.br"

cAssunto := "Pre-Pedido sem Movimentacao"

//ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )

EndIF

AUUX->( DBCloseArea())


Return
***************

Static Function Itens(cNum)

***************
 
Local cQuery   := ''
Local aRet     := {}
cQuery:="SELECT Z6_PRODUTO,Z6_DESCRI,Z6_UM,Z6_QTDVEN FROM "+RetsqlName('SZ6')+" SZ6 "
cQuery+="WHERE Z6_NUM='"+cNum+"' "
cQuery+="AND Z6_FILIAL='"+xFilial('SZ6')+"' AND SZ6.D_E_L_E_T_!='*' "
TCQUERY cQuery NEW ALIAS 'TMPZ'
TMPZ->(DBGOTOP())

do While TMPZ->( !EoF() )
    
	aAdd( aRet, {TMPZ->Z6_PRODUTO,TMPZ->Z6_DESCRI,TMPZ->Z6_UM,TMPZ->Z6_QTDVEN  } )
	TMPZ->( dbSkip() )
endDo
TMPZ->( dbCloseArea() )



Return aRet

***************

Static Function Edital(cEdital)

***************
 
Local cQuery   := ''
Local aRet     := {}
cQuery:="SELECT Z17_LICITA,Z17_DTABER,Z17_HRABER,Z17_MODALI,Z17_NREDIT,Z17_STATUS FROM "+RetsqlName('Z17')+" Z17 "
cQuery+="WHERE Z17_CODIGO='"+cEdital+"' "
cQuery+="AND Z17_FILIAL='"+xFilial('Z17')+"' AND Z17.D_E_L_E_T_!='*' "
TCQUERY cQuery NEW ALIAS 'TMPZ'
TCSetField( "TMPZ", "Z17_DTABER",  "D", 8, 0 )
TMPZ->(DBGOTOP())

do While TMPZ->( !EoF() )
    
	aAdd( aRet, {TMPZ->Z17_LICITA,TMPZ->Z17_DTABER,TMPZ->Z17_HRABER,TMPZ->Z17_MODALI,TMPZ->Z17_NREDIT,TMPZ->Z17_STATUS   } )
	TMPZ->( dbSkip() )
endDo
TMPZ->( dbCloseArea() )



Return aRet

***************

Static Function Pedido(cNum)

***************
 
Local cQuery   := ''
Local aRet     := {}

cQuery:="SELECT  Z5_NUM,MAX(C5_EMISSAO)DATA_MAX,ISNULL(SUM(C6_QTDENT),0) QTDENT  "
cQuery+="FROM "+RetsqlName('SZ5')+" SZ5  JOIN "+RetsqlName('SZ6')+" SZ6 "
cQuery+="ON Z5_FILIAL+Z5_NUM=Z6_FILIAL+Z6_NUM "
cQuery+="AND  SZ6.D_E_L_E_T_!='*' " 
cQuery+="LEFT JOIN "+RetsqlName('SC6')+" SC6 ON C6_FILIAL+C6_PREPED+C6_PRODUTO=Z6_FILIAL+Z6_NUM+Z6_PRODUTO  "
cQuery+="AND SC6.D_E_L_E_T_!='*'  "
cQuery+="LEFT JOIN "+RetsqlName('SC5')+" SC5 ON C5_FILIAL+C5_NUM=C6_FILIAL+C6_NUM  "
cQuery+="WHERE  Z5_FILIAL='"+xFilial('SZ5')+"' AND SZ5.D_E_L_E_T_!='*' "
cQuery+="AND Z5_NUM='"+cNum+"' "
cQuery+="GROUP BY Z5_NUM  "
cQuery+="ORDER BY Z5_NUM  "
TCQUERY cQuery NEW ALIAS 'TMPZ'

TCSetField( "TMPZ", "DATA_MAX",  "D", 8, 0 )

TMPZ->(DBGOTOP())

do While TMPZ->( !EoF() )
    
	aAdd( aRet, {TMPZ->DATA_MAX,TMPZ->QTDENT  } )
	TMPZ->( dbSkip() )
endDo
TMPZ->( dbCloseArea() )



Return aRet
