#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

User Function Mailcr()
Local cQuery2:=" "
Private cMensagem

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "Mailcr" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa Mailcr na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec1()
Else
  conOut( "Programa Mailcr sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec1()
EndIf
conOut( "Finalizando programa Mailcr em " + Dtoc( DATE() ) + ' - ' + Time() )
Return

Static Function Exec1() 

cQuery2:=" select Z17_CODIGO ,Z18_CODEDI,Z15_NOMLIC,Z17_MODALI,Z17_NREDIT,Z17_DTABER,Z17_HRABER,Z18_ITEM,Z18_PROD,Z18_DESCPR,X5_DESCRI,Z18_ALTURA,Z18_LARGUR   "
cQuery2+="from  "+RetsqlName('Z17')+" Z17  LEFT join  "+RetsqlName('Z15')+" Z15  "
cQuery2+="on Z17.Z17_FILIAL + Z17.Z17_LICITA = Z15.Z15_FILIAL + Z15.Z15_COD AND Z17.D_E_L_E_T_= Z15.D_E_L_E_T_  "
cQuery2+="LEFT join  Z18020 Z18 on Z17.Z17_FILIAL + Z17.Z17_CODIGO = Z18.Z18_FILIAL + Z18.Z18_CODEDI AND Z17.D_E_L_E_T_= Z18.D_E_L_E_T_  "
cQuery2+="join SX5020 SX5 on X5_CHAVE=Z18_COR   "
cQuery2+="where Z15_FILIAL = '"+xFilial('Z15')+"' and Z17_FILIAL = '"+xFilial('Z17')+"' and Z18_FILIAL = '"+xFilial('Z18')+"' "
cQuery2+="AND Z17_DTLCRE='"+Dtos( DDATABASE )+"'AND X5_TABELA='70'AND Z17.D_E_L_E_T_!='*'  "
cQuery2+="ORDER BY Z17_CODIGO "
 
TCQUERY cQuery2 NEW ALIAS 'AUUX'

TCSetField( "AUUX", "Z17_DTABER",  "D", 8, 0 )

 
AUUX->(DBGOTOP()) 

if AUUX->(!EOF())
cMensagem:=" "
While AUUX->(!EOF())
 
 cCod:=AUUX->Z17_CODIGO 
 cMensagem+="Por solicitação do Licitante: "+Alltrim(AUUX->Z15_NOMLIC)+" através do Edital"+Alltrim(AUUX->Z17_NREDIT)+" , Modalidade: "+iif(AUUX->Z17_MODALI='01',"Pregão Presencial",iif(AUUX->Z17_MODALI='02',"Pregao eletronico",;
 iif(AUUX->Z17_MODALI='03',"Concorrência Pública",iif(AUUX->Z17_MODALI='04',"Tomada de Preço",;
 iif(AUUX->Z17_MODALI='05',"Carta Convite",iif(AUUX->Z17_MODALI='06',"Dispensa de Licitação",;
 iif(AUUX->Z17_MODALI='07',"Cotação Eletronica",iif(AUUX->Z17_MODALI='08',"Estimativa",iif(AUUX->Z17_MODALI=='09','Adesao',iif(AUUX->Z17_MODALI=='10','Prorrogacao',iif(AUUX->Z17_MODALI=='11','Acrescimo',iif(AUUX->Z17_MODALI=='12','Convite eletronico',''))))))))))))+;
 " com Abertura em: "+ Dtoc(AUUX->Z17_DTABER) +" às "+AUUX->Z17_HRABER+", com os  produtos relacionados abaixo. <br> <br>"
 
 lOk:=.F.
 While AUUX->(!EOF()) .AND. AUUX->Z17_CODIGO=cCod
 lOk:=.T.
 cMensagem+= +AUUX->Z18_ITEM+" - "+AUUX->Z18_PROD+" - "+AUUX->Z18_DESCPR+" - " +AUUX->X5_DESCRI+" - "+cvaltochar(AUUX->Z18_ALTURA)+" - "+cvaltochar(AUUX->Z18_LARGUR)+" <br> "
 AUUX->(DbSkip())
 EndDo

cMensagem+=" <br> "

If !lOk
AUUX->(DbSkip())
EndIf

EndDo
cMensagem += "<br>"
cMensagem += "Certo da providência, meus agradecimentos. <br> <br>"
cMensagem += "Atenciosamente, <br> "
cMensagem += "Departamento de Licitações"

// Teste
//cEmail   :="antonio@ravaembalagens.com.br"
// Pessoal da licitacao  
cEmail   :="licitacao@ravaembalagens.com.br"

cAssunto := "Data Limite de Credenciamento Atingida"

//ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )
EndIF

AUUX->( DBCloseArea())


Return
