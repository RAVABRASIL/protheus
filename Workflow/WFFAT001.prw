#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

User Function WFFAT001()

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFFAT001" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa WFFAT001 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa WFFAT001 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
conOut( "Finalizando programa WFFAT001 em " + Dtoc( DATE() ) + ' - ' + Time() )
Return

Static Function Exec() 

Local cQuery2:=" "
Local aNota:={}
Local cMensagem 

cQuery2:="SELECT  D2_CLIENTE,D2_COD,MIN(D2_EMISSAO) DTMIN  " 
cQuery2+="FROM "+retSqlName("SD2")+" SD2,"+retSqlName("SB1")+" SB1 "
cQuery2+="WHERE D2_FILIAL='"+xFilial('SD2')+"' AND B1_FILIAL='"+xFilial('SB1')+"' "
cQuery2+="AND D2_COD=B1_COD "
cQuery2+="AND B1_GRUPO='C'  " //HOSPITALAR
cQuery2+="AND B1_SETOR IN ('01','03','05','37','40')  " //HAMPER
cQuery2+="AND D2_TIPO='N' " // normal 
cQuery2+="AND SD2.D_E_L_E_T_!='*' AND SB1.D_E_L_E_T_!='*' "
cQuery2+="GROUP BY D2_CLIENTE,D2_COD HAVING MIN(D2_EMISSAO)='"+Dtos( DDATABASE )+"' "  
cQuery2+="ORDER BY D2_CLIENTE,D2_COD " 

TCQUERY cQuery2 NEW ALIAS 'AUUX'

AUUX->(DbGoTop())

if !AUUX->(EOF())

cMensagem:=" "
cMensagem+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
cMensagem+='<html xmlns="http://www.w3.org/1999/xhtml"> '
cMensagem+='<head> '
cMensagem+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
cMensagem+='<title>Untitled Document</title> '
cMensagem+='<style type="text/css"> '
cMensagem+='<!-- '
cMensagem+='.style2 {color: #000000} '
cMensagem+='.style3 {color: #FFFFFF; } '
cMensagem+='--> '
cMensagem+='</style>  '
cMensagem+='</head> '

cMensagem+='<body> '
cMensagem+='<p><a target="_blank" href="http://www.ravaembalagens.com.br"><span style="text-decoration:none;text-underline:none"><img '
cMensagem+='src="http://www.ravaembalagens.com.br/figuras/topemail.gif" name="_x0000_i1025" width="695" '
cMensagem+='height="88" border="0" id="_x0000_i1025" /></span></a></p> '
cMensagem+='<table width="695" border="1">

cMensagem+='<tr> '
cMensagem+='<td width="67" bgcolor="#00CC66" class="style3" scope="col">Emissao</td> '
cMensagem+='<td width="612" scope="col">'+Dtoc(Stod(AUUX->DTMIN))+'</td> '
cMensagem+='</tr> '
cMensagem+='</table> '

cMensagem+='<table width="695" border="1"> '
cMensagem+='<tr bgcolor="#00CC66">  '
cMensagem+='<td width="256" scope="col"><div align="center" class="style3">Cliente</div></td>  '
cMensagem+='<td width="224" scope="col"><div align="center" class="style3">Produto</div></td> '
cMensagem+='<td width="193" scope="col"><div align="center" class="style3"> Nota( Prev. Chegada ) </div></td> '
cMensagem+='</tr> '
cMensagem+='<tr> '
Do while !AUUX->(EOF())
  cMensagem+='<td>'+posicione("SA1",1,xFilial('SA1') + AUUX->D2_CLIENTE,"A1_NOME") +'</td>  '
  cMensagem+='<td>'+posicione("SB1",1,xFilial('SB1') + AUUX->D2_COD,"B1_DESC" )+'</td>  '
  // Vetor com as notas fiscais 
  aNota:=NotaFis(AUUX->D2_CLIENTE,AUUX->D2_COD, AUUX->DTMIN )
  cMensagem+='<td>'
  For _x:=1 to Len(aNota)
     cMensagem+=aNota[_x][1]+" ( "+dtoc(CalcPrv(stod(aNota[_x][2]),aNota[_x][3],aNota[_x][4] ))+" )" +'<br>'  
     
  Next
  cMensagem+='</td>'
  cMensagem+='</tr>  '
  AUUX->( DBSKIP() )
Enddo
cMensagem+='</table> '
cMensagem+='</body>  '
cMensagem+='</html> '
// Teste
//cEmail   :="antonio@ravaembalagens.com.br"  
//Padrao
//cEmail   :="flavia@ravaembalagens.com.br;Wagner@ravaembalagens.com.br"  
cEmail := ""
////12/08/2010 - Flávia Viana solicitou não receber mais este relatório. - Flávia Rocha
cAssunto := "1ª Compra Hamper- Programar Treinamento"

//ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )
	
endif

AUUX->(DBCLOSEAREA())


Return

***************

Static Function NotaFis(cCli,cProd,cDtEmi)

***************
Local cQry:=''
Local aRet:={}

/*cQry:="SELECT D2_DOC FROM "+retSqlName("SD2")+" SD2 "
cQry+="WHERE D2_FILIAL='"+xfilial('SD2')+"' " 
cQry+="AND D2_CLIENTE='"+cCli+"' "
cQry+="AND D2_COD='"+cProd+"' "
cQry+="AND D2_EMISSAO='"+cDtEmi+"' "
cQry+="AND SD2.D_E_L_E_T_!='*' "
cQry+="ORDER BY D2_DOC "
TCQUERY cQry NEW ALIAS 'TMPZ'*/

cQry:="SELECT D2_DOC,F2_EMISSAO, A4_DIATRAB, ZZ_PRZENT  "
cQry+="FROM "+retSqlName("SF2")+" SF2,"+retSqlName("SD2")+" SD2,"+retSqlName("SA4")+" SA4, "+retSqlName("SZZ")+" SZZ, "
cQry+=" "+retSqlName("SA1")+" SA1  "
cQry+="WHERE F2_DOC=D2_DOC "
cQry+="AND D2_CLIENTE='"+cCli+"' "
cQry+="AND D2_COD='"+cProd+"' "
cQry+="AND D2_EMISSAO='"+cDtEmi+"' "
cQry+="AND SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA    " 
cQry+="AND SF2.F2_TRANSP = SA4.A4_COD and SF2.F2_TRANSP = SZZ.ZZ_TRANSP " 
cQry+="AND SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ "  
cQry+="AND SD2.D2_TIPO='N' "
cQry+="AND SF2.D_E_L_E_T_ != '*'  and SA4.D_E_L_E_T_  != '*' and SZZ.D_E_L_E_T_ != '*' AND SD2.D_E_L_E_T_ != '*' "
cQry+="AND SA1.D_E_L_E_T_ != '*'  "
cQry+="AND SF2.F2_FILIAL  = '"+xfilial('SF2')+"' AND SA4.A4_FILIAL = '"+xfilial('SA4')+"' and SZZ.ZZ_FILIAL = '"+xfilial('SZZ')+"' AND SD2.D2_FILIAL  = '"+xfilial('SD2')+"' "
cQry+="AND SA1.A1_FILIAL  = '"+xfilial('SA1')+"'  "
cQry+="ORDER BY D2_DOC "
TCQUERY cQry NEW ALIAS 'TMPZ'

do While TMPZ->( !EoF() )
	aAdd( aRet, { TMPZ->D2_DOC,TMPZ->F2_EMISSAO, TMPZ->A4_DIATRAB, TMPZ->ZZ_PRZENT     }   )
	TMPZ->( dbSkip() )
endDo
TMPZ->( dbCloseArea() )


Return  aRet


***************

Static Function CalcPrv(dDatsai, cDiatrab, nPrzent)

***************

Local x := 1
Local dData := dDatsai

IF cDiatrab == alltrim(str(3))
   dData += nPrzent// + 1
Else
   while( x <= nPrzent )
      IF (dData == DataValida(dData) )
         dData++
         x++
      ElseIF DataValida(dData) - dData >= 2
         DO CASE
          CASE cDiatrab == alltrim(str(1)) //seg ate sexta
             dData := DataValida(dData)
             IF x == 1 //dayanne colocando saídas aos sábados de empresas que trabalham em 1
                x++
             ENDIF
          CASE cDiatrab == alltrim(str(2)) //seg ate sabado
             dData++
             x++
             /*Modificado*/
             IF (x > nPrzent) .AND. (dow(dData) == 1)
                dData++
             ENDIF
             /*Aqui*/
         ENDCASE
      Else
         dData := DataValida(dData)
      ENDIF
   EndDo
Endif

//dData++ 
//o dData++ foi Retirado a pedido de Daniela em 10/10/08, chamado 591
//o dData++ foi recolocado a pedido de Alexandre em 09/01/09, chamado 790
x := 1

while (x <= 2) .AND. (dData != DataValida(dData))
   //IF dData != DataValida(dData)
   DO CASE
    CASE cDiatrab == alltrim(str(1))
       IF dow(dData) == 1
          dData := DataValida(dData) + 1
       else
          dData := DataValida(dData)
       EndIf
    CASE cDiatrab == alltrim(str(2))
       IF dow(dData) != 7 //diferente de sábado
          dData := DataValida(dData)
       /*Else //talvez isso dê erro, pois a entrega pode ser feita no sábado.
          dData++*/
       ENDIF
   EndCase

   //ENDIF
   x++
EndDo

Return dData