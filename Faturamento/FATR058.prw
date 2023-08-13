// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : FATR058
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 20/02/18 | Gustavo Costa     | Clientes compram a X dias
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include "Tbiconn.ch "
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Montagem da tela de processamento

@author    TOTVS Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     7/08/2012
/*/
//------------------------------------------------------------------------------------------
User function FATR058()
//--< variáveis >---------------------------------------------------------------------------

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local cQuery		:= ''
Local oFWMsExcel
Local oExcel
//Local cArquivo		:= GetTempPath()+'FATRXXX.xml'
Local cArquivo		:= "\temp\FATR058.xml" //GetTempPath()+'FATR058.xml'
Local dDataIni12m	//:= FirstDay(( ddatabase - 365 ))	
Local dDataFim12m	//:= FirstDay( ddatabase ) - 1
Local cWorkSheet	:= ""
Local cWorkSheet2	:= ""
Local cTitulo			:= ""

Local cMailTo 		//:= GetNewPar("MV_XFATR58","gustavo@ravaembalagens.com.br" )
Local cCopia  		:= "" 
Local cAnexo  		:= "FATR058.xml"
Local cAssun  		//:= "Clientes compram a " + Transform(mv_par02, "@R 999") + " dias" 
Local cCorpo		:= ""
Local lJob			:= .F.
		
						
//////////seleciona os dados
if Select( 'SX2' ) == 0
	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )   	
  	lJob	:= .T.
  	cMailTo 		:= GetNewPar("MV_XFATR58","flavia@ravaembalagens.com.br" )
  	cCopia 			:= GetNewPar("MV_XFATR58","gustavo@ravaembalagens.com.br" )
  	mv_par01 		:= 1 // Vendido
  	mv_par02		:= 90
  	cAssun  		:= "Clientes compram a " + Transform(mv_par02, "@R 999") + " dias"
  	
  	cCorpo  := "Para: " + cMailTo + CHR(13) + CHR(10)                                               
  	cCorpo  += "C/Copia: " + cCopia + CHR(13) + CHR(10)
  	cCorpo  += "Segue anexo a planilha." + CHR(13) + CHR(10)

Else
	Pergunte('FATR58',.T.)
	cArquivo		:= GetTempPath()+'FATR058.xml'
endif

dDataIni12m	:= FirstDay(( ddatabase - 365 ))	
dDataFim12m	:= FirstDay( ddatabase ) - 1
//fCriaTAB()

//***************************
//PRIMEIRA ABA
//***************************
cWorkSheet	:= "RENATA"
cTitulo	:= "RENATA"

cQuery := "SELECT A3_COD COD, A3_NREDUZ VENDEDOR, A1_COD, A1_LOJA LOJA, A1_NREDUZ, A1_CGC CNPJ, A1_EST UF, A1_TEL TEL, A1_CONTATO CONTATO, " 

cQuery += "ISNULL((SELECT TOP 1 substring(C5_EMISSAO,7,2) + '/' + substring(C5_EMISSAO,5,2) + '/' + substring(C5_EMISSAO,1,4) FROM SD2020 D2 "
cQuery += "INNER JOIN SC5020 SC5 WITH (NOLOCK) ON D2_FILIAL + D2_PEDIDO = C5_FILIAL + C5_NUM  "
cQuery += "WHERE D2_CLIENTE + D2_LOJA = A1_COD + A1_LOJA AND D2.D_E_L_E_T_ <> '*' "
cQuery += "		AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
cQuery += "		AND D2_QUANT-D2_QTDEDEV > 0 "
//cQuery += "		AND D2_EMISSAO < '" + DtoS( ddatabase - mv_par02 )+ "' "
cQuery += "		ORDER BY D2_EMISSAO DESC ),'') DATA_ULTCOM, "

If mv_par01 = 2
	cQuery += "ISNULL((SELECT SUM((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN) FROM SD2020 D2 " 
	cQuery += "INNER JOIN SC5020 SC5 WITH (NOLOCK) ON D2_FILIAL + D2_PEDIDO = C5_FILIAL + C5_NUM " 
	cQuery += "WHERE D2_CLIENTE + D2_LOJA = A1_COD + A1_LOJA AND D2.D_E_L_E_T_ <> '*' "
	cQuery += "		AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
	cQuery += "		AND SUBSTRING(C5_EMISSAO,1,6) = '" + SubStr( DtoS(ddatabase) ,1,6) + "' ),0) MESATU, "
Else
	cQuery += "ISNULL((SELECT SUM((C6_QTDVEN)*C6_PRCVEN-C6_VALDESC) FROM SC6020 C6 " 
	cQuery += "INNER JOIN SC5020 SC5 WITH (NOLOCK) ON C6_FILIAL + C6_NUM = C5_FILIAL + C5_NUM " 
	cQuery += "WHERE C5_CLIENTE + C5_LOJACLI = A1_COD + A1_LOJA AND C6.D_E_L_E_T_ <> '*' "
	cQuery += "		AND RTRIM(C6_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
	cQuery += "		AND SUBSTRING(C5_EMISSAO,1,6) = '" + SubStr( DtoS(ddatabase) ,1,6) + "' AND C6_BLQ <> 'R'),0) MESATU, "
EndIf

cQuery += "ISNULL((SELECT SUM( (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ) "
cQuery += "FROM SD2020 SD2 WITH (NOLOCK) WHERE RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) " 
cQuery += "AND SD2.D2_EMISSAO BETWEEN  '" + DtoS(dDataIni12m) + "'  AND  '" + DtoS(dDataFim12m) + "' "  
cQuery += "AND SD2.D_E_L_E_T_ =   '' "
cQuery += "AND SD2.D2_CLIENTE + SD2.D2_LOJA = A1_COD + A1_LOJA),0) AS TOTAL12M "

cQuery += " FROM SA1010 A1 WITH (NOLOCK) "
cQuery += " INNER JOIN SA3010 A3 "
cQuery += " ON A1_VEND = A3_COD "

cQuery += "WHERE A1_SATIV1 <> '000009' "
cQuery += "AND A1.D_E_L_E_T_ <> '*' "
cQuery += "AND A3.D_E_L_E_T_ <> '*' "

cQuery += "AND A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','MT','MS') " //ESTADOS DE MARCOS
//cQuery += "--A1_VEND = '2807' "
//cQuery += "AND A1_EST IN ('ES','RJ','DF','MT','MS','PR','RS','SC','BA','PE','MG','SP','PB','GO' " //ESTADOS DE JANAINA/GILDO

cQuery += "AND A1_COD NOT IN ('031732','031733','006543','007005') " 
cQuery += "AND A1_COD+A1_LOJA IN (SELECT DISTINCT D2_CLIENTE+D2_LOJA "
cQuery += "FROM SD2020 SD2 WITH (NOLOCK) WHERE RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) " 
cQuery += "AND SD2.D2_EMISSAO > '" + DtoS(ddatabase - mv_par02) + "' AND SD2.D_E_L_E_T_ =   '' AND D2_QUANT-D2_QTDEDEV > 0)  "
cQuery += "ORDER BY 2 DESC "

MemoWrite("C:\Temp\FATR058M.sql", cQuery )

If Select("AUX") > 0
	DbSelectArea("AUX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "AUX"
//TCSetField( "AUX", "ZZ2_DATA", "D")
//Criando o objeto que irá gerar o conteúdo do Excel
oFWMsExcel := FWMSExcel():New()
	
	//Aba 01 - Teste
oFWMsExcel:AddworkSheet(cWorkSheet) //Não utilizar número junto com sinal de menos. Ex.: 1-
//Criando a Tabela
oFWMsExcel:AddTable(cWorkSheet,cTitulo)
//Criando Colunas

//nAlign	Numérico	Alinhamento da coluna ( 1-Left,2-Center,3-Right )	
//nFormat	Numérico	Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )

oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"COD",2,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"VENDEDOR",1,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"CODCLI",2,1)
//oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"LOJA",2,1) 
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"CLIENTE",1,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"UF",2,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"TEL",1,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"CONTATO",1,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"DT. ULT COMP",2,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"CART + FAT",3,2)
//oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"ULT. 12M",3,2)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"MEDIA 12M",3,2)

//Criando as Linhas
AUX->(dbGoTop())
While !(AUX->(EoF()))

	oFWMsExcel:AddRow(cWorkSheet,cTitulo,{;
										AUX->COD ,;
										AUX->VENDEDOR ,;
										AUX->A1_COD ,;
										AUX->A1_NREDUZ ,;
										AUX->UF ,;
										AUX->TEL ,;
										AUX->CONTATO ,;
										AUX->DATA_ULTCOM ,;
										AUX->MESATU ,;
										AUX->TOTAL12M / 12;
										})

//										AUX->CNPJ ,;
//										AUX->TOTAL12M,;
//										AUX->LOJA ,;
	//Pulando Registro
	AUX->(DbSkip())
EndDo

//***************************
//SEGUNDA ABA
//***************************
cWorkSheet	:= "JANAINA"
cTitulo	:= "JANAINA"

cQuery := "SELECT A3_COD COD, A3_NREDUZ VENDEDOR, A1_COD, A1_LOJA LOJA, A1_NREDUZ, A1_CGC CNPJ, A1_EST UF, A1_TEL TEL, A1_CONTATO CONTATO, " 

cQuery += "ISNULL((SELECT TOP 1 substring(C5_EMISSAO,7,2) + '/' + substring(C5_EMISSAO,5,2) + '/' + substring(C5_EMISSAO,1,4) FROM SD2020 D2 "
cQuery += "INNER JOIN SC5020 SC5 WITH (NOLOCK) ON D2_FILIAL + D2_PEDIDO = C5_FILIAL + C5_NUM  "
cQuery += "WHERE D2_CLIENTE + D2_LOJA = A1_COD + A1_LOJA AND D2.D_E_L_E_T_ <> '*' "
cQuery += "		AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
cQuery += "		AND D2_QUANT-D2_QTDEDEV > 0 "
cQuery += "		ORDER BY D2_EMISSAO DESC ),'') DATA_ULTCOM, "

If mv_par01 = 2
	cQuery += "ISNULL((SELECT SUM((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN) FROM SD2020 D2 " 
	cQuery += "INNER JOIN SC5020 SC5 WITH (NOLOCK) ON D2_FILIAL + D2_PEDIDO = C5_FILIAL + C5_NUM " 
	cQuery += "WHERE D2_CLIENTE + D2_LOJA = A1_COD + A1_LOJA AND D2.D_E_L_E_T_ <> '*' "
	cQuery += "		AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
	cQuery += "		AND SUBSTRING(C5_EMISSAO,1,6) = '" + SubStr( DtoS(ddatabase) ,1,6) + "' ),0) MESATU, "
Else
	cQuery += "ISNULL((SELECT SUM((C6_QTDVEN)*C6_PRCVEN-C6_VALDESC) FROM SC6020 C6 " 
	cQuery += "INNER JOIN SC5020 SC5 WITH (NOLOCK) ON C6_FILIAL + C6_NUM = C5_FILIAL + C5_NUM " 
	cQuery += "WHERE C5_CLIENTE + C5_LOJACLI = A1_COD + A1_LOJA AND C6.D_E_L_E_T_ <> '*' "
	cQuery += "		AND RTRIM(C6_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
	cQuery += "		AND SUBSTRING(C5_EMISSAO,1,6) = '" + SubStr( DtoS(ddatabase) ,1,6) + "' AND C6_BLQ <> 'R'),0) MESATU, "
EndIf

cQuery += "ISNULL((SELECT SUM( (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ) "
cQuery += "FROM SD2020 SD2 WITH (NOLOCK) WHERE RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) " 
cQuery += "AND SD2.D2_EMISSAO BETWEEN  '" + DtoS(dDataIni12m) + "'  AND  '" + DtoS(dDataFim12m) + "' "  
cQuery += "AND SD2.D_E_L_E_T_ =   '' "
cQuery += "AND SD2.D2_CLIENTE + SD2.D2_LOJA = A1_COD + A1_LOJA),0) AS TOTAL12M "

cQuery += " FROM SA1010 A1 WITH (NOLOCK) "
cQuery += " INNER JOIN SA3010 A3 "
cQuery += " ON A1_VEND = A3_COD "

cQuery += "WHERE A1_SATIV1 <> '000009' "
cQuery += "AND A1.D_E_L_E_T_ <> '*' "
cQuery += "AND A3.D_E_L_E_T_ <> '*' "

//cQuery += "AND A1_EST IN ('AC','RO','RR','TO','AL','MA','PI','RN','SE','AP','AM','PA','CE') " //ESTADOS DE MARCOS
//cQuery += "--A1_VEND = '2807' "
cQuery += "AND A1_EST IN ('PE','RJ','SC','CE','MG','PR','ES','DF','RS','SP','BA','PB','GO') " //ESTADOS DE JANAINA/GILDO

cQuery += "AND A1_COD NOT IN ('031732','031733','006543','007005') " 
cQuery += "AND A1_COD+A1_LOJA IN (SELECT DISTINCT D2_CLIENTE+D2_LOJA "
cQuery += "FROM SD2020 SD2 WITH (NOLOCK) WHERE RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) " 
cQuery += "AND SD2.D2_EMISSAO > '" + DtoS(ddatabase - mv_par02) + "' AND SD2.D_E_L_E_T_ =   '' AND D2_QUANT-D2_QTDEDEV > 0)  "
cQuery += "ORDER BY 2 DESC "

MemoWrite("C:\Temp\FATR058J.sql", cQuery )

If Select("AUX") > 0
	DbSelectArea("AUX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "AUX"
//TCSetField( "AUX", "ZZ2_DATA", "D")
//Criando o objeto que irá gerar o conteúdo do Excel

//Aba 02
oFWMsExcel:AddworkSheet(cWorkSheet) //Não utilizar número junto com sinal de menos. Ex.: 1-
//Criando a Tabela
oFWMsExcel:AddTable(cWorkSheet,cTitulo)
//Criando Colunas

//nAlign	Numérico	Alinhamento da coluna ( 1-Left,2-Center,3-Right )	
//nFormat	Numérico	Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )

oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"COD",2,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"VENDEDOR",1,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"CODCLI",2,1)
//oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"LOJA",2,1) 
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"CLIENTE",1,1)
//oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"CNPJ",2,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"UF",2,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"TEL",1,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"CONTATO",1,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"DT. ULT COMP",2,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"CART + FAT",3,2)
//oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"ULT. 12M",3,2)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"MEDIA 12M",3,2)

//Criando as Linhas
AUX->(dbGoTop())
While !(AUX->(EoF()))

	oFWMsExcel:AddRow(cWorkSheet,cTitulo,{;
										AUX->COD ,;
										AUX->VENDEDOR ,;
										AUX->A1_COD ,;
										AUX->A1_NREDUZ ,;
										AUX->UF ,;
										AUX->TEL ,;
										AUX->CONTATO ,;
										AUX->DATA_ULTCOM ,;
										AUX->MESATU ,;
										AUX->TOTAL12M / 12;
										})

	//Pulando Registro
	AUX->(DbSkip())
EndDo

//Ativando o arquivo e gerando o xml
oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cArquivo)


	If lJob
		//Sleep(5000)
		//MsgAlert("gerou?")
		//U_SendPSV(cMailTo, cCopia, "FATR58", cCorpo, "\temp\", cAnexo)
	
		Sleep(5000)
		SendPSV(cMailTo, cCopia, cAssun, cCorpo,"\temp\", cAnexo )  

	Else
		//Abrindo o excel e abrindo o arquivo xml
		oExcel := MsExcel():New() 			//Abre uma nova conexão com Excel
		oExcel:WorkBooks:Open(cArquivo) 	//Abre uma planilha
		oExcel:SetVisible(.T.) 				//Visualiza a planilha
		oExcel:Destroy()						//Encerra o processo do gerenciador de tarefas

	EndIf

AUX->(DbCloseArea())
//RestArea(aArea)
Return



*****************************************************************
Static Function SendPSV(cMailTo,cCopia,cAssun,cCorpo,cDir,cAnexo)
*****************************************************************

Local cEmailCc := cCopia

Local cUser	  := Alltrim(GetMV( "MV_RELACNT" ))
Local cPass   := Alltrim(GetMV( "MV_RELPSW"  ))
Local cServer := Alltrim(GetMV( "MV_RELSERV" ))
Local cFrom	  := "ravasiga@ravaembalagens.com.br"
Local cFile   := cDir+cAnexo

Local xRet
Local oServer, oMessage
      
oMessage := TMailMessage():New()
oMessage:Clear()
   
oMessage:cDate := cValToChar( Date() )
oMessage:cFrom := cFrom
oMessage:cTo := cMailTo
oMessage:cSubject := cAssun
oMessage:cBody := cCorpo
xRet := oMessage:AttachFile( cFile )
if xRet < 0
    cMsg := "Could not attach file " + cFile
    conout( cMsg )
    return .F.
Else
    conout( "Attached file " + cFile )
endif  
Sleep(5000)
oServer := tMailManager():New()

//oServer:SetUseSSL( .T. )
     
xRet := oServer:Init( "", cServer, cUser, cPass, 0, 25 )
if xRet != 0
   cMsg := "Could not initialize SMTP server: " + oServer:GetErrorString( xRet )
   conout( cMsg )
   return
endif
   
xRet := oServer:SetSMTPTimeout( 60 )
if xRet != 0
   cMsg := "Could not set " + cProtocol + " timeout to " + cValToChar( nTimeout )
   conout( cMsg )
endif
   
xRet := oServer:SMTPConnect()
if xRet <> 0
   cMsg := "Could not connect on SMTP server: " + oServer:GetErrorString( xRet )
   conout( cMsg )
   return
endif
   
xRet := oServer:SmtpAuth( cUser, cPass )
if xRet <> 0
   cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
   conout( cMsg )
   oServer:SMTPDisconnect()
   return
endif
   
xRet := oMessage:Send( oServer )
if xRet <> 0
   cMsg := "Could not send message: " + oServer:GetErrorString( xRet )
   conout( cMsg )
Else
   conout( "Sended message" )
endif
   
xRet := oServer:SMTPDisconnect()
if xRet <> 0
   cMsg := "Could not disconnect from SMTP server: " + oServer:GetErrorString( xRet )
   conout( cMsg )
endif

return



