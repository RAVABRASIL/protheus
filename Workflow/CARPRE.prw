#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include "Tbiconn.ch "

User Function CARPRE()
Local cQry:=''

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "CARPRE" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa CARPRE na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa CARPRE sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
conOut( "Finalizando programa CARPRE em " + Dtoc( DATE() ) + ' - ' + Time() )

Return 

Static Function Exec()


cQry:="SELECT distinct Z5_NUM,Z5_EDITAL,Z5_EMISSAO,A1_NOME,SUM((Z6_QTDVEN - Z6_QTDENT) * Z6_PRCVEN) VAL_RS, sum(Z6_QTDVEN/B1_CONV) VAL_KG, "
cQry+="Z5_CLIENTE " 
cQry+="FROM "+RetsqlName('SB1')+" SB1, "+RetsqlName('SZ5')+" SZ5, "+RetsqlName('SZ6')+" SZ6,"+RetsqlName('SA1')+" SA1 "
cQry+="WHERE ( SZ6.Z6_QTDVEN - SZ6.Z6_QTDENT ) > 0  AND  "
cQry+="SZ6.Z6_PRODUTO = SB1.B1_COD "
cQry+="AND SZ5.Z5_NUM = SZ6.Z6_NUM  "
cQry+="AND SZ5.Z5_CLIENTE +SZ5.Z5_LOJACLI = SA1.A1_COD +SA1.A1_LOJA AND  "
cQry+="SA1.A1_FILIAL = '"+xFilial('SA1')+"'  AND SA1.D_E_L_E_T_  != '*'AND "
cQry+="SB1.B1_FILIAL = '"+xFilial('SB1')+"'  AND SB1.D_E_L_E_T_ != '*' AND "
cQry+="SZ5.Z5_FILIAL = '"+xFilial('SZ5')+"'  AND SZ5.D_E_L_E_T_ != '*' AND "
cQry+="SZ6.Z6_FILIAL = '"+xFilial('SZ6')+"'  AND SZ6.D_E_L_E_T_ != '*'  "
cQry+="GROUP BY SZ5.Z5_NUM,SZ5.Z5_EDITAL,SZ5.Z5_EMISSAO,SA1.A1_NOME,SZ5.Z5_CLIENTE  "
cQry+="ORDER BY SZ5.Z5_NUM " 

TCQUERY cQry NEW ALIAS 'AUUX'
TCSetField( "AUUX", "Z5_EMISSAO",  "D", 8, 0 )	

AUUX->(DBGOTOP()) 


if AUUX->(!EOF())

cMensagem:=" "
cMensagem+='<style type="text/css"> '
cMensagem+='<!-- '
cMensagem+='.style1 {font-family: Verdana, Arial, Helvetica, sans-serif} '
cMensagem+='.style5 {font-family: Verdana, Arial, Helvetica, sans-serif; color: #FFFFFF; } '
cMensagem+='.style6 {color: #FFFFFF} '
cMensagem+='--> '
cMensagem+='</style> '
cMensagem+='<table width="930" height="64" border="1"> '
cMensagem+='<tr bgcolor="#00CC66"> '
cMensagem+='<td width="84"><span class="style5">Pre-Pedido</span></td> '
cMensagem+='<td width="75"><span class="style5">Data de Emiss&atilde;o </span></td> '
cMensagem+='<td width="273"><div align="center"><span class="style5">Cliente</span></div></td> ' 
cMensagem+='<td width="273"><span class="style5">Dias Carteira</span></td> '
cMensagem+='<td width="98"><div align="center" class="style6"><span class="style1">Val_RS</span></div></td> '
cMensagem+='<td width="91"><div align="center" class="style6"><span class="style1">Val_kg</span></div></td> '
cMensagem+='<td width="33"><span class="style5">Mod</span></td> '
cMensagem+='<td width="90"><span class="style5">N&ordm; Edital </span></td> '
cMensagem+='<td width="76"><div align="center"><span class="style5">Data Abertura </span></div></td> '
cMensagem+='<td width="273"><div align="center"><span class="style5">Org&atilde;o</span></div></td> '
cMensagem+='</tr> '
cMensagem+='<tr> '

While AUUX->(!EOF())
	
	DbSelectArea("Z17")
    DbSetOrder(1)
	Z17->(DbSeek(xFilial("Z17")+AUUX->Z5_EDITAL))

    cMensagem+='<td>'+alltrim(AUUX->Z5_NUM)+'</td>  '
    cMensagem+='<td>'+DTOC(AUUX->Z5_EMISSAO)+'</td> ' 
    cMensagem+='<td>'+alltrim(AUUX->A1_NOME)+'</td> '  
    cMensagem+='<td><div align="center">'+alltrim( STR( dDataBase - AUUX->Z5_EMISSAO ) ) +'</div></td> '
    cMensagem+='<td><div align="right">'+transform(AUUX->VAL_RS,"@E 999,999,999.99")+'</div></td>  '
	cMensagem+='<td><div align="right">'+transform(AUUX->VAL_KG,"@E 999,999,999.99")+'</div></td> '
	cMensagem+='<td><div align="center">'+iif(alltrim(Z17->Z17_MODALI)  == '01', "PP",    iif( alltrim(Z17->Z17_MODALI) == '02', "PE" ,;
                                          iif( alltrim(Z17->Z17_MODALI) == '03', "CP",    iif( alltrim(Z17->Z17_MODALI) == '04', "TP" ,;
                                          iif(alltrim(Z17->Z17_MODALI)  == '05', "CC",    iif( alltrim(Z17->Z17_MODALI) == '06', "DL",;
	                                      iif( alltrim(Z17->Z17_MODALI) == '07', "CE ",   iif( alltrim(Z17->Z17_MODALI) == '08',"EP",iif(alltrim(Z17->Z17_MODALI) =='09','AD',iif(alltrim(Z17->Z17_MODALI) =='10','PRO',iif(alltrim(Z17->Z17_MODALI) =='11','ACR',iif(alltrim(Z17->Z17_MODALI) =='12','CVE',''))))) ) ) ) ) ) ) )+'</div></td> '	
	cMensagem+='<td>'+alltrim(Z17->Z17_NREDIT)+'</td> '
	cMensagem+='<td>'+alltrim(DTOC(Z17->Z17_DTABER))+'</td> '
	cMensagem+='<td>'+alltrim(Posicione('Z15',1,xFilial("Z15")+Z17->Z17_LICITA,"Z15_NOMLIC"))+'</td> ' 
	cMensagem+='</tr> '
	
	AUUX->(DbSkip())

EndDo
cMensagem+='</table> '


// Teste
//cEmail   :="antonio@ravaembalagens.com.br"
// Pessoal da licitacao 
cEmail   :="zelice@ravaembalagens.com.br"

cAssunto := "Carteira Pre-Pedido"

U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )
//ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
EndIF

AUUX->( DBCloseArea())

Return