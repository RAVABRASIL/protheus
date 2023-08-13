#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include "Tbiconn.ch "

*************

User Function MovEdi()

*************

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "MovEdi" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa MovEdi na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa MovEdi sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
conOut( "Finalizando programa MovEdi em " + Dtoc( DATE() ) + ' - ' + Time() )
Return

***************

Static Function Exec()

***************

Local cQuery:=" "
Local nDif:=0
Local aInfFLA:={}
Local aInfZE:={}

Private cMensagem

cQuery:="SELECT Z17_LICITA,Z17_DTABER,Z17_HRABER,Z17_MODALI,Z17_NREDIT,Z17_STATUS  "
cQuery+="FROM "+RetsqlName('Z17')+" Z17  "
cQuery+="WHERE  Z17_FILIAL='"+xFilial('Z17')+"' AND Z17.D_E_L_E_T_!='*' "
TCQUERY cQuery NEW ALIAS 'AUUX'

TCSetField( "AUUX", "Z17_DTABER",  "D", 8, 0 )	
	 
AUUX->(DBGOTOP()) 

Do While AUUX->(!EOF())

   nDif:= ( DDATABASE -AUUX->Z17_DTABER)
   if nDif>=45
      
      if !AUUX->Z17_STATUS $ "/21"  // PERDEMOS
         aAdd( aInfFLA, {nDif,AUUX->Z17_LICITA,AUUX->Z17_DTABER,AUUX->Z17_HRABER,AUUX->Z17_MODALI,AUUX->Z17_NREDIT,AUUX->Z17_STATUS  } )
      EndIf
      
      if !AUUX->Z17_STATUS $ "/21/17"  // PERDEMOS E GANHAMOS 
         aAdd( aInfZE, {nDif,AUUX->Z17_LICITA,AUUX->Z17_DTABER,AUUX->Z17_HRABER,AUUX->Z17_MODALI,AUUX->Z17_NREDIT,AUUX->Z17_STATUS  } )
      EndIf
   
   Else
      
      if nDif>=25
         
         if !AUUX->Z17_STATUS $ "/21/17"  // PERDEMOS E GANHAMOS
            aAdd( aInfZE, {nDif,AUUX->Z17_LICITA,AUUX->Z17_DTABER,AUUX->Z17_HRABER,AUUX->Z17_MODALI,AUUX->Z17_NREDIT,AUUX->Z17_STATUS  } )
         EndIf
   
      EndIf
   
   EndIf

   AUUX->(dbSkip())

EndDo

AUUX->( DBCloseArea())

cAssunto := "Processo Licitorio Sem Movimentacao"

if len(aInfFLA)>0

   aSort(aInfFLA,,, { |x,y| x[1] < y[1] } )

   CorpoMAil(aInfFLA)
   
    cEmail   :="flavia@ravaembalagens.com.br"
    //cEmail   :="antonio@ravaembalagens.com.br" 
   //ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
   U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )
EndIf   

if len(aInfZE)>0
   
   aSort(aInfZE,,, { |x,y| x[1] < y[1] } )

   CorpoMAil(aInfZE)
   
   cEmail   :="bel.lima@ravaembalagens.com.br"
   U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )
   //ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
  
EndIf

Return 

***************

Static Function CorpoMAil(cVetor)

***************
   
   cMensagem:=" "
   cMensagem+='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> '
   cMensagem+='<html xmlns="http://www.w3.org/1999/xhtml"> '
   cMensagem+='<head> '
   cMensagem+='<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> '
   cMensagem+='<title>Untitled Document</title> '
   cMensagem+='<style type="text/css"> '
   cMensagem+='<!-- '
   cMensagem+='.style5 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14px; color: #FFFFFF; } '
   cMensagem+='.style12 {color: #000000} '
   cMensagem+='--> '
   cMensagem+='</style></head> '

   cMensagem+='<body> '
   cMensagem+='<table width="711" border="1"> '
   cMensagem+='<tr bgcolor="#00CC66"> '
   cMensagem+='<td width="173" class="style5"><div align="center">Org&atilde;o</div></td> '
   cMensagem+='<td width="34" class="style5"><div align="center">UF</div></td> '
   cMensagem+='<td width="103"><div align="center"><span class="style5">Dt. Abertura </span></div></td> '
   cMensagem+='<td width="103"><div align="center"><span class="style5">Hr. Abertura</span></div></td> '
   cMensagem+='<td width="103"><div align="center"><span class="style5">Modalidade</span></div></td> '
   cMensagem+='<td width="103"><div align="center"><span class="style5">Nº Edital</span></div></td> '
   cMensagem+='<td width="103"><div align="center"><span class="style5">Status</span></div></td> '
   cMensagem+='<td width="86"><div align="center"><span class="style5">P&eacute;riodo</span></div></td> '
   cMensagem+='</tr> '
   For y:=1 to len(cVetor) 
      cMensagem+='<td><span class="style12">'+alltrim(Posicione('Z15',1,xFilial("Z15")+cVetor[y][2],"Z15_NOMLIC"))+'</span></td> '
      cMensagem+='<td><div align="center"><span class="style12">'+alltrim(Posicione('Z15',1,xFilial("Z15")+cVetor[y][2],"Z15_UF" ))+'</span><div></td> '
      cMensagem+='<td><div align="center"><span class="style12">'+Dtoc(cVetor[y][3])+'</span><div></td> '
      cMensagem+='<td><div align="center"><span class="style12">'+cVetor[y][4]+'</span><div></td> '
      cMensagem+='<td><div align="center"><span class="style12">'+iif(alltrim(cVetor[y][5])  == '01', "Pregao Presencial",    iif( alltrim(cVetor[y][5]) == '02', "Pregao Eletronico" ,;
                                                                  iif( alltrim(cVetor[y][5]) == '03', "Concorrencia Publica",    iif( alltrim(cVetor[y][5]) == '04', "Tomada de Preco" ,;
                                                                  iif(alltrim(cVetor[y][5])  == '05', "Carta Convite",    iif( alltrim(cVetor[y][5]) == '06', "Dispensa da Licitacao",;
                                                                  iif( alltrim(cVetor[y][5]) == '07', "Cotacao Eletronica ", iif( alltrim(cVetor[y][5]) == '08', "Estimativa ",  iif(alltrim(cVetor[y][5]) =='09','Adesao',iif(alltrim(cVetor[y][5]) =='10','Prorrogacao',iif(alltrim(cVetor[y][5]) =='11','Acrescimo',iif(alltrim(cVetor[y][5]) =='12','Convite Eletronico','')))) ) ) ) ) ) ) ) )+'</span><div></td> ' 


/*   
"01- Aguardando Reposta do Esclarecimento"
"02 - Advogado Fazendo Impugnacao"
"03 - Aguardando Reposta de Impugnacao"
"04 - Advogado Fazendo Recurso"
"05 - Aguardando Reposta do Recurso"
"06 - Advogado Fazendo Mandato de Seguranca"
"07 - Aguardando Reposta do Mandato de Seguranca"
"08 - Aguardando Ata ou Contrato para Assinatura"
"09 - Buscar precos finais no Orgao"
"10 - Ganhamos"
"11 - Perdemos"
"12 - Prorrogada"
"13 - Cancelada"
"14 - Negado Pelo Financeiro"
*/


      cMensagem+='<td><div align="center"><span class="style12">'+cVetor[y][6]+'</span><div></td> '
/*      cMensagem+='<td><span class="style12">'+iif(empty(alltrim(cVetor[y][7])),'Em Andamento',iif(alltrim(cVetor[y][7])=='01','Não participamos',;
                                              iif(alltrim(cVetor[y][7])=='02','Suspensa',iif(alltrim(cVetor[y][7])=='03','Concluídas',;
                                              iif(alltrim(cVetor[y][7])=='04','Impugnadas',iif(alltrim(cVetor[y][7])=='05','Em recurso',;
                                              iif(alltrim(cVetor[y][7])=='06','Perdemos',iif(alltrim(cVetor[y][7])=='07','Cancelado',;
                                              iif(alltrim(cVetor[y][7])=='08','Ganhamos',iif(alltrim(cVetor[y][7])=='09','Tribunal de Contas/Justiça', " " ))))))))))+'</span></td> '  
*/                                              

/*  
      cMensagem+='<td><span class="style12">'+iif(alltrim(cVetor[y][7])=='01','Aguardando Reposta do Esclarecimento',iif(alltrim(cVetor[y][7])=='02','Advogado Fazendo Impugnacao',;
                                              iif(alltrim(cVetor[y][7])=='03','Aguardando Reposta de Impugnacao',iif(alltrim(cVetor[y][7])=='04','Advogado Fazendo Recurso',;
                                              iif(alltrim(cVetor[y][7])=='05','Aguardando Reposta do Recurso',iif(alltrim(cVetor[y][7])=='06','Advogado Fazendo Mandato de Seguranca',;
                                              iif(alltrim(cVetor[y][7])=='07','Aguardando Reposta do Mandato de Seguranca',iif(alltrim(cVetor[y][7])=='08','Aguardando Ata ou Contrato para Assinatura',;
                                              iif(alltrim(cVetor[y][7])=='09','Buscar precos finais no Orgao',iif(alltrim(cVetor[y][7])=='10','Ganhamos',;
                                              iif(alltrim(cVetor[y][7])=='11','Perdemos',iif(alltrim(cVetor[y][7])=='12','Prorrogada',;
                                              iif(alltrim(cVetor[y][7])=='13','Cancelada',iif(alltrim(cVetor[y][7])=='14','Negado Pelo Financeiro'," "))))))))))))))+'</span></td> '  
*/
     
      dbSelectArea("SX5")
      dbSetOrder(1)
      DbSeek(xFilial("SX5")+'Z5'+cVetor[y][7])
    
      cMensagem+='<td><span class="style12">'+ALLTRIM(SX5->X5_DESCRI)+'</span></td> '
      cMensagem+='<td><div align="center"><span class="style12">'+str(cVetor[y][1])+'</span><div></td> '
      cMensagem+='</tr> '
   Next
   cMensagem+='</table> '
   cMensagem+='</body>  '
   cMensagem+='</html>  '

Return