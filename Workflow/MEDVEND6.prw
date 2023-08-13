#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

*************

User Function MEDVEND6()

*************


If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "MEDVEND6" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa MEDVEND6 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa MEDVEND6 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
conOut( "Finalizando programa MEDVEND6 em " + Dtoc( DATE() ) + ' - ' + Time() )
Return

***************

Static Function Exec() 

***************
Local cQuery2:=" "
Private cMensagem:=" "

cQuery2:="SELECT " 
cQuery2+="(CASE WHEN LEN(D2_COD)>=8 THEN "
cQuery2+="CASE when (Substring( D2_COD, 4, 1 ) = 'R') or  (Substring( D2_COD, 5, 1 ) = 'R') "
cQuery2+="then SUBSTRING(D2_COD,1,1)+SUBSTRING(D2_COD,3,4)+SUBSTRING(D2_COD,8,2) "
cQuery2+="else SUBSTRING(D2_COD,1,1)+SUBSTRING(D2_COD,3,3)+SUBSTRING(D2_COD,7,2) end  "
cQuery2+="ELSE D2_COD END ) AS PRODUTO,UM=B1_UM,ESTOQUE=B2_QATU,SUM(D2_TOTAL)/3 'MEDIA' "    
cQuery2+="FROM "+RetsqlName('SD2')+" SD2 WITH (NOLOCK), "+RetsqlName('SB1')+" SB1 WITH (NOLOCK), "+RetsqlName('SB2')+" SB2 WITH (NOLOCK) "
cQuery2+="WHERE SD2.D2_FILIAL = '"+xFilial('SD2')+"' AND SD2.D_E_L_E_T_ != '*' "
cQuery2+="AND   SB1.B1_FILIAL = '"+xFilial('SB1')+"' AND SB1.D_E_L_E_T_ != '*' "
cQuery2+="AND   SB2.B2_FILIAL = '"+xFilial('SB2')+"' AND SB2.D_E_L_E_T_ != '*' "
cQuery2+="AND SD2.D2_COD = SB1.B1_COD "
cQuery2+="AND ( CASE WHEN LEN(D2_COD)>=8 THEN "
cQuery2+="CASE when (Substring( D2_COD, 4, 1 ) = 'R') or  (Substring( D2_COD, 5, 1 ) = 'R') "
cQuery2+="then SUBSTRING(D2_COD,1,1)+SUBSTRING(D2_COD,3,4)+SUBSTRING(D2_COD,8,2) "
cQuery2+="else SUBSTRING(D2_COD,1,1)+SUBSTRING(D2_COD,3,3)+SUBSTRING(D2_COD,7,2) end "
cQuery2+="ELSE D2_COD END )= B2_COD "
cQuery2+="AND B2_LOCAL='01' "
cQuery2+="AND B2_QATU>0 "
cQuery2+="AND D2_TIPO = 'N' "
cQuery2+="AND D2_TP := 'AP' " 
cQuery2+="AND RTRIM(D2_CF) IN ( '511','5101','611','6101','512','5102','612','6102','6109','6107' ) "
cQuery2+="AND ( (B1_UM='MR' AND (D2_QUANT)<=2) OR (B1_UM='FD' AND (D2_QUANT)<=12)  ) "
cQuery2+="AND D2_EMISSAO BETWEEN '"+Dtos( DDATABASE-90)+"' AND '"+Dtos( DDATABASE )+"' "
cQuery2+="GROUP BY (CASE WHEN LEN(D2_COD)>=8 THEN "
cQuery2+="CASE when (Substring( D2_COD, 4, 1 ) = 'R') or  (Substring( D2_COD, 5, 1 ) = 'R') "
cQuery2+="then SUBSTRING(D2_COD,1,1)+SUBSTRING(D2_COD,3,4)+SUBSTRING(D2_COD,8,2) "
cQuery2+="else SUBSTRING(D2_COD,1,1)+SUBSTRING(D2_COD,3,3)+SUBSTRING(D2_COD,7,2) end "
cQuery2+="ELSE D2_COD END ),B1_UM,B2_QATU "
cQuery2+="HAVING (  (B1_UM='MR' AND SUM(D2_QUANT)<=2) OR (B1_UM='FD' AND SUM(D2_QUANT)<=12)  ) "
cQuery2+="ORDER BY PRODUTO "
TCQUERY cQuery2 NEW ALIAS 'AUUX'
 
AUUX->(DBGOTOP()) 

if AUUX->(!EOF())
   cMensagem:=" "         
   cMensagem+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> ' 
   cMensagem+='<html xmlns="http://www.w3.org/1999/xhtml"> ' 
   cMensagem+='<head> ' 
   cMensagem+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
   cMensagem+='<title>Untitled Document</title> '
   cMensagem+='<style type="text/css"> '
   cMensagem+='<!-- '
   cMensagem+='.style1 { '
   cMensagem+='font-family: Geneva, Arial, Helvetica, sans-serif; ' 
   cMensagem+='font-size: 16px; ' 
   cMensagem+='color: #FFFFFF; '  
   cMensagem+='} ' 
   cMensagem+='--> '
   cMensagem+='</style> '
   cMensagem+='</head> '
   cMensagem+='<body> '
   cMensagem+='<table width="721" border="1"> ' 
   cMensagem+='<tr bgcolor="#00CC66"> ' 
   cMensagem+='<td width="99"><div align="left"><span class="style1">Codigo</span></div></td> ' 
   cMensagem+='<td width="352"><div align="center"><span class="style1">Decricao</span></div></td> ' 
   cMensagem+='<td width="25"><div align="center"><span class="style1">UM</span></div></td> '
   cMensagem+='<td width="148"><div align="center"><span class="style1">Media de vendas </span></div></td> ' 
   cMensagem+='<td width="63"><div align="center"><span class="style1">Estoque</span></div></td> ' 
   cMensagem+='</tr> '
   Do While AUUX->(!EOF())
      cMensagem+='<tr> ' 
      cMensagem+='<td><span class="style3">'+AUUX->PRODUTO+'</span></td> ' 
      cMensagem+='<td><span class="style3">'+Posicione("SB1",1,xFilial("SB1")+AUUX->PRODUTO, "B1_DESC")+'</span></td> ' 
      cMensagem+='<td><span class="style3">'+AUUX->UM+'</span></td> '
      cMensagem+='<td><div align="right"><span class="style3">'+transform(AUUX->MEDIA,"@E 999,999,999.9999")+'</span></div></td> '
      cMensagem+='<td><div align="right"><span class="style3">'+TRANSFORM(AUUX->ESTOQUE,"@E 999,999.999")+'</span></div></td> '
      cMensagem+='</tr> '
      AUUX->(DbSkip())
   Enddo
   cMensagem+='</table> '
   cMensagem+='</body> ' 
   cMensagem+='</html> ' 
   // Teste
   // cEmail   :="antonio@ravaembalagens.com.br"
   // Marcelo 
   cEmail   :="marcelo@ravaembalagens.com.br"

   cAssunto := "Media de vendas dos Ultimos 6 meses "

   //ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
   U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )

EndIF

AUUX->( DBCloseArea())


Return
