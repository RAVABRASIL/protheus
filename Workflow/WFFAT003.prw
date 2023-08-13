#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

*************

User Function WFFAT003()

*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT003" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa WFFAT003 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa WFFAT003 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
  conOut( "Finalizando programa WFFAT003 em " + Dtoc( DATE() ) + ' - ' + Time() )

Return

***************

Static Function Exec()

***************

Local CQry:=''
Local aItens:={}
Local aPedido:={}
Local cMensagem:=''

CQry:="SELECT Z17_CODIGO,Z17_NREDIT,Z17_DTABER,Z17_LICITA,SUM(Z18_QUANT/B5_QE2) TOTVEN "
CQry+="FROM " + RetSqlName('Z17') + " Z17," + RetSqlName('Z18') + " Z18," + RetSqlName('SB5') + " SB5 "
CQry+="WHERE Z17_FILIAL='" + xFilial( "Z17" ) + "' "
CQry+="AND Z18_FILIAL='" + xFilial( "Z18" ) + "' "
CQry+="AND B5_FILIAL='" + xFilial( "SB5" ) + "' "
CQry+="AND Z17_CODIGO=Z18_CODEDI AND Z18_GERAPP='S' "
CQry+="AND B5_COD=case when len(Z18_PROD) >= 8 then  "
CQry+="case when ( SUBSTRING( Z18_PROD, 4, 1 ) = 'R') or ( SUBSTRING( Z18_PROD, 5, 1 ) = 'R') "
CQry+="then SUBSTRING( Z18_PROD, 1, 1) + SUBSTRING( Z18_PROD, 3, 4) + SUBSTRING( Z18_PROD, 8, 2) "
CQry+="else SUBSTRING( Z18_PROD, 1, 1) + SUBSTRING( Z18_PROD, 3, 3) + SUBSTRING( Z18_PROD, 7, 2) end  "
CQry+="else Z18_PROD END "
CQry+="AND Z17.D_E_L_E_T_!='*' "
CQry+="AND Z18.D_E_L_E_T_!='*' "
CQry+="AND SB5.D_E_L_E_T_!='*' "
CQry+="GROUP BY Z17_CODIGO,Z17_NREDIT,Z17_DTABER,Z17_LICITA "
CQry+="ORDER BY Z17_CODIGO "
TCQUERY CQry NEW ALIAS 'AUUX'

TCSetField( "AUUX", "Z17_DTABER","D", 8, 0 )	

AUUX->( DBGoTop() )

if AUUX->(!EOF())
   
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
   cMensagem+='<a href="http://www.ravaembalagens.com.br" target="_blank"><span style="text-decoration:none;text-underline:none"><img '
   cMensagem+='src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" width="744"  '
   cMensagem+='height="88" border="0" id="_x0000_i1025" /></span></a> '
  
   Do While AUUX->(!EOF())
    
    aPedido:=Pedido(AUUX->Z17_CODIGO,'') 
    
    If EMPTY(aPedido[1][1])
         
       cMensagem+='<table width="736" border="1"> '
       cMensagem+='<tr> '
       cMensagem+='<td width="60" bgcolor="#00CC66"><span class="style1">N Edital: </span></td> '
       cMensagem+='<td width="405">'+AUUX->Z17_NREDIT+'( '+AUUX->Z17_CODIGO+' )'+'</td> '
       cMensagem+='<td width="103" bgcolor="#00CC66"><span class="style1">Data Abertura: </span></td> '
       cMensagem+='<td width="140">'+DtoC(AUUX->Z17_DTABER)+'</td> '
       cMensagem+='</tr> '
       cMensagem+='<tr> '
       cMensagem+='<td bgcolor="#00CC66"><span class="style1">Orgao:</span></td> '
       cMensagem+='<td colspan="3">'+alltrim(Posicione('Z15',1,xFilial("Z15")+AUUX->Z17_LICITA,"Z15_NOMLIC"))+'</td> '
       cMensagem+='</tr> '
       cMensagem+='</table>  '
       cMensagem+='<table width="737" border="1"> '
       cMensagem+='<tr bgcolor="#00CC66"> '
       cMensagem+='<td width="67"><div align="center"><span class="style1">Codigo</span></div></td> '
       cMensagem+='<td width="172"><div align="center"><span class="style1">Descritivo</span></div></td> '
       cMensagem+='<td width="156"><div align="center"><span class="style1">QTD</span> <span class="style1">Vendida</span></div></td> '
       cMensagem+='<td width="156"><div align="center"><span class="style1">QTD Entregue </span></div></td> '
       cMensagem+='<td width="152"><div align="center"><span class="style1">Saldo</span></div></td> '
       cMensagem+='</tr> '
       
       aItens:=Itens(AUUX->Z17_CODIGO)
	   For _x:=1 to len(aItens)
	       cMensagem+='<tr> '
	       cMensagem+=' <td>'+aItens[_x][1]+'</td> '
	       cMensagem+='<td>'+alltrim(Posicione('SB1',1,xFilial("SB1")+aItens[_x][1],"B1_DESC"))+'</td> '
	       cMensagem+='<td><div align="right">'+transform(aItens[_x][3],'@E 999,999,999.9999' )+'</div></td> '
	       cMensagem+='<td><div align="right">'+transform(0,'@E 999,999,999.9999' )+'</td> '
	       cMensagem+='<td><div align="right">'+transform(aItens[_x][3],'@E 999,999,999.9999' )+'</div></td> '
	       cMensagem+='</tr> '	           
       Next
    
    Else
       nDif:= (DDATABASE-aPedido[1][1])%30
	     
	   If nDif=0 .AND. AUUX->TOTVEN-aPedido[1][2]>0
	      cMensagem+='<table width="736" border="1"> '
          cMensagem+='<tr> '
          cMensagem+='<td width="60" bgcolor="#00CC66"><span class="style1">N Edital: </span></td> '
          cMensagem+='<td width="405">'+AUUX->Z17_NREDIT+'( '+AUUX->Z17_CODIGO+' )'+'</td> '
          cMensagem+='<td width="103" bgcolor="#00CC66"><span class="style1">Data Abertura: </span></td> '
          cMensagem+='<td width="140">'+DtoC(AUUX->Z17_DTABER)+'</td> '
          cMensagem+='</tr> '
          cMensagem+='<tr> '
          cMensagem+='<td bgcolor="#00CC66"><span class="style1">Orgao:</span></td> '
          cMensagem+='<td colspan="3">'+alltrim(Posicione('Z15',1,xFilial("Z15")+AUUX->Z17_LICITA,"Z15_NOMLIC"))+'</td> '
          cMensagem+='</tr> '
          cMensagem+='</table>  '
          cMensagem+='<table width="737" border="1"> '
          cMensagem+='<tr bgcolor="#00CC66"> '
          cMensagem+='<td width="67"><div align="center"><span class="style1">Codigo</span></div></td> '
          cMensagem+='<td width="172"><div align="center"><span class="style1">Descritivo</span></div></td> '
          cMensagem+='<td width="156"><div align="center"><span class="style1">QTD</span> <span class="style1">Vendida</span></div></td> '
          cMensagem+='<td width="156"><div align="center"><span class="style1">QTD Entregue </span></div></td> '
          cMensagem+='<td width="152"><div align="center"><span class="style1">Saldo</span></div></td> '
          cMensagem+='</tr> '
       
          aItens:=Itens(AUUX->Z17_CODIGO)
	      For _x:=1 to len(aItens)
	         aPedido:=Pedido(AUUX->Z17_CODIGO,aItens[_x][1])
	         cMensagem+='<tr> '
	         cMensagem+=' <td>'+aItens[_x][1]+'</td> '
	         cMensagem+='<td>'+alltrim(Posicione('SB1',1,xFilial("SB1")+aItens[_x][1],"B1_DESC"))+'</td> '
	         cMensagem+='<td><div align="right">'+transform(aItens[_x][3],'@E 999,999,999.9999' )+'</div></td> '
	         cMensagem+='<td><div align="right">'+transform(aPedido[1][2],'@E 999,999,999.9999' )+'</td> '
	         cMensagem+='<td><div align="right">'+transform(aItens[_x][3]-aPedido[1][2],'@E 999,999,999.9999' )+'</div></td> '
	         cMensagem+='</tr> '	           
          Next  
	        
	   Endif
    
    Endif
      	
   AUUX->( DbSkip() )
   EndDo	
	cMensagem+='</table> '
	cMensagem+='</body> '
	cMensagem+='</html> ' 
	cEmail   :="josenildo@ravaembalagens.com.br"
    cAssunto := "Alerta de Empenho"
    //ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
    U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )
Endif

AUUX->( DbCloseArea() )	

Return

***************

Static function Pedido(cEdita,cItem)

***************

Local cQuery:=cQry:= ''
Local aRet := {}
Local cNum:=''

cQry:="SELECT Z5_NUM FROM SZ5020  SZ5 "
cQry+="WHERE Z5_EDITAL='"+cEdita+"'  AND Z5_FILIAL='01' AND SZ5.D_E_L_E_T_!='*'"
cQry+="ORDER BY Z5_NUM "
TCQUERY cQry NEW ALIAS 'TMPX'

TMPX->(DBGOTOP())
do While TMPX->( !EoF() )
   cNum+= "'"+TMPX->Z5_NUM+"'"
   TMPX->(DBSKIP())
   if !TMPX->(EOF())
      cNum += ","
   endif  
endDo
TMPX->( dbCloseArea() )

if !empty(cNum)
	cQuery:="SELECT MAX(C5_EMISSAO)DATA_MAX,ISNULL(SUM(C6_QTDENT),0) TOTENT "
	cQuery+="FROM SC5020 SC5,SC6020 SC6 "
	cQuery+="WHERE C5_NUM=C6_NUM "
	cQuery+="AND  C5_FILIAL='01' AND C6_FILIAL='01' "
	cQuery+="AND C6_PREPED IN("+cNum+") "
	If !empty(cItem)
	   cQuery+="AND C6_PRODUTO='"+cItem+"' "
	Endif
	cQuery+="AND SC5.D_E_L_E_T_!='*' AND SC6.D_E_L_E_T_!='*' "
	
	TCQUERY cQuery NEW ALIAS 'TMPZ'
	
	TCSetField( "TMPZ", "DATA_MAX",  "D", 8, 0 )
	
	TMPZ->(DBGOTOP())
	
	do While TMPZ->( !EoF() )
		aAdd( aRet, {TMPZ->DATA_MAX,TMPZ->TOTENT  } )
		TMPZ->( dbSkip() )
	endDo
	TMPZ->( dbCloseArea() )
Else
    aAdd( aRet, {'',0} )
Endif


Return aRet

***************

Static Function Itens(cedita)

***************
Local cQry:= ''
Local aRet := {}

cQry:="SELECT Z18_PROD,Z18_DESCPR,(Z18_QUANT/B5_QE2) QTDVEN "
cQry+="FROM Z18020 Z18,SB5010 SB5 "
cQry+="WHERE Z18_CODEDI='"+cEdita+"' "  
cQry+="AND Z18_PROD=B5_COD "
TCQUERY cQry NEW ALIAS 'TMPY'
TMPY->(DBGOTOP())

do While TMPY->( !EoF() )    
	aAdd( aRet, {TMPY->Z18_PROD,TMPY->Z18_DESCPR,TMPY->QTDVEN } )
	TMPY->( dbSkip() )
endDo
TMPY->( dbCloseArea() )



Return aRet