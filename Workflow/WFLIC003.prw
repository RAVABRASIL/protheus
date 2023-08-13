#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

/*
--------------------------------------------------------------------------------------------------
Programa: WFLIC003
Objetivo: Enviar email avisando sobre o vencimento da Data de Credenciamento do Edital
Solicitado pelo Projeto Licitação: Tópico 3.2
Alterado por  : Flávia Rocha
Data Alteração: 05/03/14
--------------------------------------------------------------------------------------------------
*/


*************************
User Function WFLIC003()   
*************************

If Select( 'SX2' ) == 0
  //RAVA EMB
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFLIC003"
  sleep( 5000 )
  conOut( "Programa WFLIC003 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  
  //RAVA CAIXAS  
  RPCSetType( 3 )
  PREPARE ENVIRONMENT EMPRESA "02" FILIAL "03" FUNNAME "WFLIC003"
  sleep( 5000 )
  conOut( "Programa WFLIC003 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
  
Else
  conOut( "Programa WFLIC003 sendo executado pelo MENU ou com erro " + Dtoc( Date() ) + ' - ' + Time() )
  Exec()
EndIf
conOut( "Finalizando programa WFLIC003 em " + Dtoc( DATE() ) + ' - ' + Time() )
Return

***********************
Static Function Exec() 
***********************

Local cQuery2:=" "
Local LF     := CHR(13) + CHR(10) 
Local cEmpresa := ""


cQuery2:=" select Z17_FILIAL, Z17_DTLCRE, Z17_CODIGO ,Z18_CODEDI,Z15_NOMLIC,Z17_MODALI,Z17_NREDIT,Z17_DTABER,Z17_HRABER,Z18_ITEM,Z18_PROD,Z18_DESCPR " + LF
//,X5_DESCRI
//cQuery2 += " ,Z18_ALTURA,Z18_LARGUR   " + LF

cQuery2 += " from  "+ LF
cQuery2 += " " + RetsqlName('Z17')  + " Z17  " + LF  
cQuery2 += " , " + RetSqlName('Z18') +" Z18  " + LF
cQuery2 += " , " + RetSqlName('Z15') +" Z15  " + LF

cQuery2 += " Where " + LF
cQuery2 += " Z17.Z17_FILIAL = Z18.Z18_FILIAL " + LF 
cQuery2 += " and Z17.Z17_CODIGO = Z18.Z18_CODEDI " + LF
cQuery2 += " and Z17.Z17_LICITA = Z15.Z15_COD " + LF
cQuery2 += " and Z17.D_E_L_E_T_= '' " + LF
cQuery2 += " and Z18.D_E_L_E_T_= '' " + LF
cQuery2 += " and Z15.D_E_L_E_T_ = '' " + LF

//cQuery2+=" join SX5020 SX5 on X5_CHAVE=Z18_COR   " + LF
cQuery2 += " and Z17_FILIAL = '"+xFilial('Z17')+"' and Z18_FILIAL = '"+xFilial('Z18')+"' " + LF
//DATA LIMITE CREDENCIAMENTO
cQuery2 += " and Z17_DTLCRE = '"+ Dtos( DDATABASE )+"' " + LF  //VOLTAR

//cQuery2 += " and Z17_DTLCRE BETWEEN  '20140401' AND '20140430'  " + LF //testes, RETIRAR

//cQuery2 += " and X5_TABELA='70'AND Z17.D_E_L_E_T_!='*'  " + LF
cQuery2 += " ORDER BY Z17_FILIAL, Z17_CODIGO " + LF
MemoWrite("C:\TEMP\WFLIC003.SQL" , cQuery2)
 
TCQUERY cQuery2 NEW ALIAS 'AUUX'

TCSetField( "AUUX", "Z17_DTABER",  "D" )
TCSetField( "AUUX", "Z17_DTLCRE",  "D" )

 
AUUX->(DBGOTOP()) 

if AUUX->(!EOF())
	cMensagem:=" "
	While AUUX->(!EOF())
		 cEmpresa := "" 
		 DBSelectArea("SM0")
		 SM0->(Dbseek( SM0->M0_CODIGO + AUUX->Z17_FILIAL ))
		 cEmpresa := SM0->M0_FILIAL
		 
		 cCod:=AUUX->Z17_CODIGO
		 cMensagem += "Empresa: " + cEmpresa + "<br>" 
		 cMensagem += "Por solicitação do Licitante: "+Alltrim(AUUX->Z15_NOMLIC)+" através do Edital: "+Alltrim(AUUX->Z17_NREDIT)+" <br> " 
		 cMensagem += "Modalidade: "+iif(AUUX->Z17_MODALI='01',"Pregão Presencial",iif(AUUX->Z17_MODALI='02',"Pregao eletronico",;
		 iif(AUUX->Z17_MODALI='03',"Concorrência Pública",iif(AUUX->Z17_MODALI='04',"Tomada de Preço",;
		 iif(AUUX->Z17_MODALI='05',"Carta Convite",iif(AUUX->Z17_MODALI='06',"Dispensa de Licitação",;
		 iif(AUUX->Z17_MODALI='07',"Cotação Eletronica",iif(AUUX->Z17_MODALI='08',"Estimativa",iif(AUUX->Z17_MODALI=='09','Adesao',iif(AUUX->Z17_MODALI=='10','Prorrogacao',iif(AUUX->Z17_MODALI=='11','Acrescimo',iif(AUUX->Z17_MODALI=='12','Convite eletronico',''))))))))))))+;
		 "<br>"                                                                                                                              
		 cMensagem += "Data Limite Credenciamento: "+ Dtoc(AUUX->Z17_DTLCRE)+ "<br>"
		 cMensagem += "Com Abertura em: "+ Dtoc(AUUX->Z17_DTABER) +" às "+AUUX->Z17_HRABER+", com os  produtos relacionados abaixo: <br><br>"
		 
		 lOk:=.F.
		 While AUUX->(!EOF()) .AND. AUUX->Z17_CODIGO=cCod
			 lOk:=.T.
			// cMensagem+= +AUUX->Z18_ITEM+" - "+AUUX->Z18_PROD+" - "+AUUX->Z18_DESCPR+" - " +AUUX->X5_DESCRI+" - "+cvaltochar(AUUX->Z18_ALTURA)+" - "+cvaltochar(AUUX->Z18_LARGUR)+" <br> "
			 cMensagem+= AUUX->Z18_ITEM+" - "+AUUX->Z18_PROD+" - "+AUUX->Z18_DESCPR+"<br><br> "
			 
			 AUUX->(DbSkip())
		 EndDo
	 	cMensagem += Replicate("_" , 80 )
		cMensagem+=" <br><br>"
	
		If !lOk
		AUUX->(DbSkip())
		EndIf

	EndDo
	cMensagem += "<br>"
	cMensagem += "Certo da providência, meus agradecimentos. <br> <br>"
	cMensagem += "Atenciosamente, <br> "
	cMensagem += "Departamento de Licitações"


	// Pessoal da licitacao  
	cEmail   := "licitacao@ravaembalagens.com.br"
	cEmail   += ";regineide.neves@ravaembalagens.com.br"
	
	//cEmail   := "" //retirar
	//cEmail   += ";flavia.rocha@ravaembalagens.com.br" //retirar
	
	cAssunto := "Data Limite de Credenciamento Atingida - " + Dtoc(dDatabase)
	
	ACSendMail(,,,,cEmail,cAssunto,cMensagem,)
EndIF

AUUX->( DBCloseArea())


Return
