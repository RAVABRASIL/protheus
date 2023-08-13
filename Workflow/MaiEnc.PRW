#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

User Function MaiEnc()
Local cQuery2:=" "
Private cMensagem

If Select( 'SX2' ) == 0
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "MaiEnc" Tables "SE1"
  sleep( 5000 )
  conOut( "Programa MaiEnc na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
Else
  conOut( "Programa MaiEnc sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
conOut( "Finalizando programa MaiEnc em " + Dtoc( DATE() ) + ' - ' + Time() )
Return
Static Function Exec() 

cQuery2:="select Z17_CODIGO ,Z18_CODEDI,Z15_NOMLIC,Z17_MODALI,Z17_NREDIT,Z17_DTABER,Z17_HRABER,Z18_ITEM,Z18_PROD,Z18_DESCPR,Z18_ENCERR,Z28_EDITAL,Z28_PRODUT,Z28_DATA,Z28_HORA,Z28_OCORRE,Z28_RESULT  "
cQuery2+="from  "+RetsqlName('Z17')+" Z17  LEFT join  "+RetsqlName('Z15')+"  Z15     "
cQuery2+="on Z17.Z17_FILIAL + Z17.Z17_LICITA = Z15.Z15_FILIAL + Z15.Z15_COD AND Z17.D_E_L_E_T_= Z15.D_E_L_E_T_   "
cQuery2+="LEFT join  "+RetsqlName('Z18')+" Z18 on Z17.Z17_FILIAL + Z17.Z17_CODIGO = Z18.Z18_FILIAL + Z18.Z18_CODEDI AND Z17.D_E_L_E_T_= Z18.D_E_L_E_T_   "
cQuery2+="JOIN "+RetsqlName('Z28')+" Z28 ON Z28.Z28_FILIAL+Z28.Z28_LICITA+Z28.Z28_EDITAL+Z28.Z28_PRODUT=Z17.Z17_FILIAL+Z17.Z17_CODIGO+Z18.Z18_ITEM+Z18.Z18_PROD AND Z28.D_E_L_E_T_= Z18.D_E_L_E_T_   "
cQuery2+="where Z15_FILIAL = '"+xFilial('Z15')+"' and Z17_FILIAL = '"+xFilial('Z17')+"' and Z18_FILIAL = '"+xFilial('Z18')+"' "
cQuery2+="AND Z18_ENCERR!='*' AND Z28_OCORRE !='' AND Z17.D_E_L_E_T_!='*'  "
cQuery2+="ORDER BY Z17_CODIGO,Z28_EDITAL,Z28_DATA,Z28_HORA  "

TCQUERY cQuery2 NEW ALIAS 'AUUX'

TCSetField( "AUUX", "Z17_DTABER",  "D", 8, 0 )
TCSetField( "AUUX", "Z28_DATA"  ,  "D", 8, 0 )
 
AUUX->(DBGOTOP()) 

if AUUX->(!EOF())
cMensagem:=" "
While AUUX->(!EOF())
 
 cCod:=AUUX->Z17_CODIGO 
 cMensagem+="Codigo: "+AUUX->Z17_CODIGO+" Licitante: "+Alltrim(AUUX->Z15_NOMLIC)+" Edital: "+Alltrim(AUUX->Z17_NREDIT)+" Modalidade: "+iif(AUUX->Z17_MODALI='01',"Pregão Presencial",iif(AUUX->Z17_MODALI='02',"Pregao eletronico",;
 iif(AUUX->Z17_MODALI='03',"Concorrência Pública",iif(AUUX->Z17_MODALI='04',"Tomada de Preço",;
 iif(AUUX->Z17_MODALI='05',"Carta Convite",iif(AUUX->Z17_MODALI='06',"Dispensa de Licitação",;
 iif(AUUX->Z17_MODALI='07',"Cotatação Eletronica",iif(AUUX->Z17_MODALI='08',"Estimativa",iif(AUUX->Z17_MODALI='09','Adesao',iif(AUUX->Z17_MODALI='10','Prorrogacao',iif(AUUX->Z17_MODALI='11','Acrescimo',iif(AUUX->Z17_MODALI='12','Convite Eletronico',''))))))))))))+;
 " Data de Abertura: "+ Dtoc(AUUX->Z17_DTABER) +" às "+AUUX->Z17_HRABER+", com o(s) Produto(s)em Aberto: <br><br>"
 
 lOk:=.F.
 While AUUX->(!EOF()) .AND. AUUX->Z17_CODIGO=cCod
 lOk:=.T.
 cItem:=AUUX->Z18_ITEM
 cProd:=AUUX->Z18_PROD
 lExiste:=.F.
 
 cMensagem+= +AUUX->Z18_ITEM+" - "+AUUX->Z18_PROD+" - "+AUUX->Z18_DESCPR+" <br> "
  
  cMensagem+="<br>"
  cMensagem+="Ocorrencia(s): <br>"
  
  While AUUX->(!EOF()) .AND. AUUX->Z17_CODIGO=cCod .AND. AUUX->Z28_EDITAL=cItem .AND. AUUX->Z28_PRODUT=cProd  
  
  aOcorr:={}
  lExiste:=.T.
  cOcorr:=MSMM(AUUX->Z28_OCORRE)

  iif(len( alltrim(cOcorr))>=64,aOcorr := wordWrap( ALLTRIM(cOcorr),64 ),aOcorr := wordWrap( ALLTRIM(cOcorr), LEN(ALLTRIM(cOcorr)) ) )
   
   cMensagem+=+Dtoc(AUUX->Z28_DATA)+" - "+AUUX->Z28_HORA+" - "
   
   for x := 1 to len( aOcorr )
    cMensagem+=aOcorr[x][1]+" <br> "
   next   
   
  AUUX->(DbSkip())
  
  Enddo
  cMensagem+="<br> "
  If !lExiste
  AUUX->(DbSkip())
  EndIf

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

cAssunto := "Produtos Em Aberto"

//ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
U_SendMailSC(cEmail ,"" , cAssunto, cMensagem,"" )
EndIF

AUUX->( DBCloseArea())

Return

***************

Static Function wordWrap( cText, nRegua )

***************

Local aRet  := {}
Local cTemp := ''
Local i 	:= 1
cTemp := memoline( cText, nRegua, i, 4, .T. )
do while len( cTemp ) > 0
	aAdd(aRet, { alltrim(cTemp) } )
	i++
	cTemp := memoline( cText, nRegua, i, 4, .T. )
endDo

Return aRet
  