// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : FATR061
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 20/02/18 | Gustavo Costa     | Evolução de clientes
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
User function FATR061()
//--< variáveis >---------------------------------------------------------------------------

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local cQuery		:= ''
Local oFWMsExcel
Local oExcel
//Local cArquivo		:= GetTempPath()+'FATRXXX.xml'
Local cArquivo		:= "\temp\FATR061.xml" //GetTempPath()+'FATR058.xml'
Local dDataIni	
Local dDataFim
Local cWorkSheet	:= ""
Local cWorkSheet2	:= ""
Local cTitulo		:= ""
Local cMes1			:= ""
Local cMes2			:= ""
Local cCampo1		:= ""
Local cCampo2		:= ""
Local nDivisor		:= 1
Local nEvol			:= 1
Local cMailTo 		//:= GetNewPar("MV_XFATR58","gustavo@ravaembalagens.com.br" )
Local cCopia  		:= "" 
Local cAnexo  		:= "FATR061.xml"
Local cAssun  		//:= "Clientes compram a " + Transform(mv_par02, "@R 999") + " dias" 
Local cCorpo		:= ""
Local cEvol		:= ""
Local lJob			:= .F.
Local dDataParan	//:= date()
						
//////////seleciona os dados
if Select( 'SX2' ) == 0
	conout( "PROGRAMA - FATR061 " )
	RPCSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01"
  	sleep( 5000 )   	
  	lJob	:= .T.
  	cMailTo 		:= GetNewPar("MV_XFATR60","flavia@ravaembalagens.com.br" )
  	cCopia 			:= GetNewPar("MV_XFATR60","gustavo@ravaembalagens.com.br" )

	conout( "DDATABASE -  " + DtoS(dDataBase) )
	conout( "DATE -  " + DtoS(date()))

  	mv_par01 		:= SubStr(DtoS(dDataBase),5,2) + SubStr(DtoS(dDataBase),1,4) 
  	//mv_par02		:= 90
  	cAssun  		:= "Evolução de Clientes  "
  	
  	cCorpo  := "Para: " + cMailTo + CHR(13) + CHR(10)                                               
  	cCorpo  += "C/Copia: " + cCopia + CHR(13) + CHR(10)
  	cCorpo  += "Segue anexo a planilha." + CHR(13) + CHR(10)

Else
	Pergunte('FATR60',.T.)
	cArquivo		:= GetTempPath()+'FATR061.xml'
endif

//Volta um mes
dDataParan	:= FirstDay(CtoD("01/" + SubStr(MV_PAR01,1,2) + "/" + SubStr(MV_PAR01,3,4) ) - 1)
cMes2	:= SubStr( DtoS(dDataParan),1,6)// + SubStr( DtoS(dDataParan) ,5,2) 

//Volta outro mes
dDataParan	:= FirstDay(dDataParan - 1)

dDataIni	:= dDataParan //CtoD("01/" + SubStr(MV_PAR01,3,4))	
dDataFim	:= LastDay( CtoD("01/" + SubStr(MV_PAR01,1,2) + "/" + SubStr(MV_PAR01,3,4)) )
//fCriaTAB()

cMes1	:= SubStr( DtoS(dDataIni),1,6)// + SubStr( DtoS(dDataIni) ,5,2) 
cMes3	:= SubStr( DtoS(dDataFim),1,6)// + SubStr( DtoS(dDataFim) ,5,2)

nDivisor	:= VAL(SubStr(MV_PAR01,1,2)) - 1

//***************************
//PRIMEIRA ABA
//***************************
cWorkSheet	:= "EVOLUCAO"
cTitulo	:= "EVOLUCAO"

/*
cQuery := "SELECT COD, NOME, EST, LINHA, "
cQuery += "        SUM( MES1 )/" + cMes1 + ", "
cQuery += "        SUM( MES2 )/" + cMes2 + ", "
cQuery += "        SUM( MES3 ) " + cMes3
cQuery += " FROM  "
cQuery += "(SELECT "  
cQuery += "A1_COD COD, replace(A1_NREDUZ, CHAR(9),'') NOME, " 
cQuery += "F2_EST EST,  "
cQuery += " LINHA=CASE  "
cQuery += "           WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA' " 
cQuery += "           WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL' " 
cQuery += "           WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR'            "
cQuery += "           ELSE B1_GRUPO  "
cQuery += "         END, "              
 
cQuery += "        SUM( CASE WHEN SUBSTRING(C5_EMISSAO,1,6) BETWEEN '" + SubStr(MV_PAR01,3,4) + "01' AND '" + SubStr(MV_PAR01,3,4) + StrZero(nDivisor,2) + "' THEN (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ELSE 0 END ) AS MES1, "
cQuery += "        SUM( 0 ) AS MES2 "
cQuery += "        FROM SD2020 SD2 WITH (NOLOCK) " 
cQuery += "        INNER JOIN SF2020 SF2 WITH (NOLOCK) " 
cQuery += "        ON D2_FILIAL = F2_FILIAL  "
cQuery += "        AND D2_DOC = F2_DOC  "
cQuery += "        AND D2_SERIE = F2_SERIE " 
cQuery += "        INNER JOIN SB1010 SB1 WITH (NOLOCK) " 
cQuery += "        ON D2_COD = B1_COD  "
cQuery += "        INNER JOIN SA1010 SA1 WITH (NOLOCK) " 
cQuery += "        ON F2_CLIENTE + F2_LOJA = A1_COD + A1_LOJA " 
cQuery += "        INNER JOIN SA3010 SA3 WITH (NOLOCK)  "
cQuery += "        ON F2_VEND1 = A3_COD   "
cQuery += "        INNER JOIN SC5020 SC5 WITH (NOLOCK) " 
cQuery += "        ON D2_FILIAL + D2_PEDIDO = C5_FILIAL + C5_NUM " 
cQuery += "        WHERE  "
cQuery += "		RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) AND "
cQuery += "        SC5.C5_EMISSAO BETWEEN  '" + DtoS(dDataIni) + "' AND '" + DtoS(dDataFim) + "' AND " 
cQuery += "        SB1.D_E_L_E_T_ =   ''   AND  "
cQuery += "        SA1.D_E_L_E_T_ =   ''   AND  "
cQuery += "        SD2.D_E_L_E_T_ =   ''   AND  "
cQuery += "        SA3.D_E_L_E_T_ =   ''   "
cQuery += "		AND A1_COD NOT IN ('031732','031733','006543','007005') "
cQuery += "        AND A1_SATIV1 <> '000009' "
cQuery += "		AND A1_SATIV8 = '100000' "
cQuery += "        GROUP BY   "
cQuery += "        A1_COD, A1_NREDUZ, " 
cQuery += "        F2_EST,  "
cQuery += "		CASE  "
cQuery += "           WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA' " 
cQuery += "           WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL' " 
cQuery += "           WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR' "           
cQuery += "           ELSE B1_GRUPO " 
cQuery += "         END "     


cQuery += "UNION "		


cQuery += "SELECT "  
cQuery += "A1_COD COD, replace(A1_NREDUZ, CHAR(9),'') NOME, " 
cQuery += "A1_EST EST, " 
cQuery += " LINHA=CASE " 
cQuery += "           WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA' " 
cQuery += "           WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL' " 
cQuery += "           WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR' "           
cQuery += "           ELSE B1_GRUPO " 
cQuery += "         END, "              
 
cQuery += "        SUM(  0 ) AS MES1, "
cQuery += "        SUM( CASE WHEN SUBSTRING(C5_EMISSAO,1,6) = '" + SubStr(MV_PAR01,3,4) + SubStr(MV_PAR01,1,2) + "' THEN (C6_QTDVEN)*C6_PRUNIT ELSE 0 END ) AS MES2 "
cQuery += "        FROM SC6020 SC6 WITH (NOLOCK)  "
cQuery += "        INNER JOIN SC5020 SC5 WITH (NOLOCK) " 
cQuery += "        ON C6_FILIAL + C6_NUM = C5_FILIAL + C5_NUM " 
cQuery += "        INNER JOIN SB1010 SB1 WITH (NOLOCK) " 
cQuery += "        ON C6_PRODUTO = B1_COD " 
cQuery += "        INNER JOIN SA1010 SA1 WITH (NOLOCK) " 
cQuery += "        ON C5_CLIENTE + C5_LOJACLI = A1_COD + A1_LOJA " 
cQuery += "        INNER JOIN SA3010 SA3 WITH (NOLOCK) " 
cQuery += "        ON C5_VEND1 = A3_COD "  
cQuery += "        WHERE " 
cQuery += "		RTRIM(C6_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) AND "
cQuery += "        SC5.C5_EMISSAO BETWEEN '" + DtoS(dDataIni) + "' AND '" + DtoS(dDataFim) + "' AND " 
cQuery += "        SB1.D_E_L_E_T_ =   ''   AND " 
cQuery += "        SC6.D_E_L_E_T_ =   ''   AND " 
cQuery += "        SA1.D_E_L_E_T_ =   ''   AND " 
cQuery += "        SA3.D_E_L_E_T_ =   ''  "
cQuery += "		AND A1_COD NOT IN ('031732','031733','006543','007005') "
cQuery += "        AND A1_SATIV1 <> '000009' "
cQuery += "		AND A1_SATIV8 = '100000' "
cQuery += "        GROUP BY   "
cQuery += "        A1_COD, A1_NREDUZ, " 
cQuery += "        A1_EST, " 
cQuery += "		CASE " 
cQuery += "           WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA' " 
cQuery += "           WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL' " 
cQuery += "           WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR' "           
cQuery += "           ELSE B1_GRUPO " 
cQuery += "         END "     
cQuery += ")  AS TABA "		
 
cQuery += "        GROUP BY "  
cQuery += "        COD, NOME, EST, LINHA "    
cQuery += "        ORDER BY " 
cQuery += "		COD, NOME, EST, LINHA "   
	*/

cQuery += "SELECT "  
cQuery += "A1_COD COD, replace(A1_NREDUZ, CHAR(9),'') NOME, " 
cQuery += "A1_EST EST, " 
cQuery += " LINHA=CASE " 
cQuery += "           WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA' " 
cQuery += "           WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL' " 
cQuery += "           WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR' "           
cQuery += "           ELSE B1_GRUPO " 
cQuery += "         END, "              
cQuery += "        SUM( CASE WHEN SUBSTRING(C5_EMISSAO,1,6) = '" + cMes1 + "' THEN (C6_QTDVEN)*C6_PRUNIT ELSE 0 END  ) AS MES1, "         
cQuery += "        SUM( CASE WHEN SUBSTRING(C5_EMISSAO,1,6) = '" + cMes2 + "' THEN (C6_QTDVEN)*C6_PRUNIT ELSE 0 END  ) AS MES2, "         
cQuery += "        SUM( CASE WHEN SUBSTRING(C5_EMISSAO,1,6) = '" + cMes3 + "' THEN (C6_QTDVEN)*C6_PRUNIT ELSE 0 END ) AS MES3 "        
cQuery += "        FROM SC6020 SC6 WITH (NOLOCK)  "
cQuery += "        INNER JOIN SC5020 SC5 WITH (NOLOCK) " 
cQuery += "        ON C6_FILIAL + C6_NUM = C5_FILIAL + C5_NUM " 
cQuery += "        INNER JOIN SB1010 SB1 WITH (NOLOCK) " 
cQuery += "        ON C6_PRODUTO = B1_COD " 
cQuery += "        INNER JOIN SA1010 SA1 WITH (NOLOCK) " 
cQuery += "        ON C5_CLIENTE + C5_LOJACLI = A1_COD + A1_LOJA " 
cQuery += "        INNER JOIN SA3010 SA3 WITH (NOLOCK) " 
cQuery += "        ON C5_VEND1 = A3_COD "  
cQuery += "        WHERE " 
cQuery += "		RTRIM(C6_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) AND "
cQuery += "        SC5.C5_EMISSAO BETWEEN '" + DtoS(dDataIni) + "' AND '" + DtoS(dDataFim) + "' AND " 
cQuery += "        SB1.D_E_L_E_T_ =   ''   AND " 
cQuery += "        SC6.D_E_L_E_T_ =   ''   AND " 
cQuery += "        SA1.D_E_L_E_T_ =   ''   AND " 
cQuery += "        SA3.D_E_L_E_T_ =   ''  "
cQuery += "		AND A1_COD NOT IN ('031732','031733','006543','007005') "
cQuery += "        AND A1_SATIV1 <> '000009' "
cQuery += "		AND A1_SATIV8 = '100000' "
cQuery += "        GROUP BY   "
cQuery += "        A1_COD, A1_NREDUZ, " 
cQuery += "        A1_EST, " 
cQuery += "		CASE " 
cQuery += "           WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA' " 
cQuery += "           WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL' " 
cQuery += "           WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR' "           
cQuery += "           ELSE B1_GRUPO " 
cQuery += "         END "     

MemoWrite("C:\Temp\FATR061.sql", cQuery )

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
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"NOME",1,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"UF",2,1)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"LINHA",1,1) 
//oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"MEDIA",3,2)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,SubStr(cMes1,5,2) + '-' + SubStr(cMes1,1,4),3,2)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,SubStr(cMes2,5,2) + '-' + SubStr(cMes2,1,4),3,2)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,SubStr(cMes3,5,2) + '-' + SubStr(cMes3,1,4),3,2)
oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"EVOLUCAO",3,2)


//cCampo1	:= "AUX->" + cMes1
//cCampo2	:= "AUX->" + cMes2

//Criando as Linhas
AUX->(dbGoTop())
While !(AUX->(EoF()))

/*
	If &cCampo2 > 0
		If &cCampo1 >0 
			nEvol := ((&cCampo2 - &cCampo1)/&cCampo1 ) * 100
		Else
			nEvol := 100
		EndIf
	Else
		nEvol := 0
	EndIf
*/	
	nEvol := 0
	Do Case
		Case AUX->MES3 > AUX->MES2
			cEvol	:= "SUBIU"
		Case AUX->MES3 > AUX->MES1
			cEvol	:= "SUBIU"
		Case AUX->MES3 < AUX->MES2
			cEvol	:= "CAIU"
		Case AUX->MES3 < AUX->MES1
			cEvol	:= "CAIU"
		Otherwise
			cEvol	:= "NEUTRO"
	EndCase
	
	oFWMsExcel:AddRow(cWorkSheet,cTitulo,{;
										AUX->COD ,;
										AUX->NOME ,;
										AUX->EST ,;
										AUX->LINHA ,;
										AUX->MES1 ,;
										AUX->MES2 ,;
										AUX->MES3 ,;
										cEvol;
										})

//										AUX->CNPJ ,;
//										AUX->TOTAL12M,;
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



