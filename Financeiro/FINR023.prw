#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

#DEFINE ENTER Chr(13)+Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :FINR023 ³ Autor :Gustavo Costa         ³ Data :15/06/2020   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Titulos vencidos por período                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FINR023()
	
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis do Tipo Local, Private e Public                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

local cQry		:= ''
Local nRet		:= 0
Local cDataIni	:= ddatabase - 6
Local cDataFim	:= ddatabase - 1
Local aSeries	:= {'A >> 01 - 05','B >> 06 - 15','C >> 16 - 30','D >> 31 - 60','E >> 61 - 90','F >> 91 - 120','G >> 121 - 150','H >> 151 - 180','I >> 181 - 360'}
Private coTbl7

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oFont2","oDlg5","oBrw5","oGrp1","oGrp2","oSay1","oGrp3","oSay2","oSay3")

oTbl7()

Processa({|| ,"Aguarde...", "Carregando Informações...",.F. })

ProcRegua(9)
For x := 1 to 9

	IncProc()
	Do case
		case x = 1
			cDataIni := ddatabase - 6
			cDataFim := ddatabase - 1
			cFiltro	 := "<= 5"
		case x = 2
			cDataIni := ddatabase - 16
			cDataFim := ddatabase - 7
			cFiltro	 := "BETWEEN 6 AND 15"
		case x = 3
			cDataIni := ddatabase - 31
			cDataFim := ddatabase - 17
			cFiltro	 := "BETWEEN 16 AND 30"
		case x = 4
			cDataIni := ddatabase - 61
			cDataFim := ddatabase - 32
			cFiltro	 := "BETWEEN 31 AND 60"
		case x = 5
			cDataIni := ddatabase - 91
			cDataFim := ddatabase - 62
			cFiltro	 := "BETWEEN 61 AND 90"
		case x = 6
			cDataIni := ddatabase - 121
			cDataFim := ddatabase - 92
			cFiltro	 := "BETWEEN 91 AND 120"
		case x = 7
			cDataIni := ddatabase - 151
			cDataFim := ddatabase - 122
			cFiltro	 := "BETWEEN 121 AND 150"
		case x = 8
			cDataIni := ddatabase - 181
			cDataFim := ddatabase - 152
			cFiltro	 := "BETWEEN 151 AND 180"
		case x = 9
			cDataIni := ddatabase - 361
			cDataFim := ddatabase - 182
			cFiltro	 := "BETWEEN 181 AND 360"
	EndCase
/*
	cQry+="         SUM ( CASE WHEN CAST(CONVERT(smalldatetime, '" + DtoS(ddatabase - 1) + "',101) - CONVERT(smalldatetime, E1_VENCREA,101) AS INT) " + cFiltro + " AND E1_PREFIXO = '0' THEN E1_SALDO ELSE 0 END ) VALOR, "
	cQry+="         COUNT(CASE WHEN CAST(CONVERT(smalldatetime, '" + DtoS(ddatabase - 1) + "',101) - CONVERT(smalldatetime, E1_VENCREA,101) AS INT) " + cFiltro + " AND E1_PREFIXO = '0' THEN 1 ELSE null END) Q_TIT, "
	cQry+="         SUM ( CASE WHEN CAST(CONVERT(smalldatetime, '" + DtoS(ddatabase - 1) + "',101) - CONVERT(smalldatetime, E1_VENCREA,101) AS INT) " + cFiltro + " AND E1_PREFIXO <> '0' THEN E1_SALDO ELSE 0 END ) VALORXDD, "
	cQry+="         COUNT(CASE WHEN CAST(CONVERT(smalldatetime, '" + DtoS(ddatabase - 1) + "',101) - CONVERT(smalldatetime, E1_VENCREA,101) AS INT) " + cFiltro + " AND E1_PREFIXO <> '0' THEN 1 ELSE null END) Q_TITXDD, "
	cQry+="         SUM ( CASE WHEN CAST(CONVERT(smalldatetime, '" + DtoS(ddatabase - 1) + "',101) - CONVERT(smalldatetime, E1_VENCREA,101) AS INT) " + cFiltro + " THEN E1_SALDO ELSE 0 END ) TOTAL  "
*/	
	cQry:=" SELECT '" + aSeries[x] + "' AS  SERIE, "
	cQry+="         SUM ( CASE WHEN E1_PREFIXO = '0' THEN E1_SALDO ELSE 0 END ) VALOR, "
	cQry+="         COUNT(CASE WHEN E1_PREFIXO = '0' THEN 1 ELSE null END) Q_TIT, "
	cQry+="         SUM ( CASE WHEN E1_PREFIXO <> '0' THEN E1_SALDO ELSE 0 END ) VALORXDD, "
	cQry+="         COUNT(CASE WHEN E1_PREFIXO <> '0' THEN 1 ELSE null END) Q_TITXDD, "
	cQry+="         SUM ( E1_SALDO ) TOTAL  "
	cQry+="         FROM SE1020  "
	cQry+="         WHERE D_E_L_E_T_ <> '*' " 
	cQry+="         AND E1_VENCREA BETWEEN '" + DtoS(cDataIni) + "' AND '" + DtoS(cDataFim) + "' "
	cQry+="         AND E1_TIPO NOT IN ('NCC','RA' ) "  
	cQry+="         AND E1_SALDO > 0  "
	
	TCQUERY cQry NEW ALIAS  "TMP7"
	MemoWrite("C:\Temp\finr023" + SubStr(aSeries[x],1,1) + ".SQL",cQry)
	
	dbSelectArea("TMP7")
	TMP7->(dbGoTop())
	
	While TMP7->(!EOF())
	
		RecLock("X90D", .T.)
		
		X90D->SERIE		:= TMP7->SERIE
		X90D->VALOR		:= TMP7->VALOR
		X90D->QTIT		:= TMP7->Q_TIT
		X90D->VALXDD	:= TMP7->VALORXDD
		X90D->QTITXDD	:= TMP7->Q_TITXDD
		X90D->TOTAL		:= TMP7->TOTAL
		X90D->DTINI		:= cDataIni
		X90D->DTFIM 	:= cDataFim
		
		X90D->(MsUnLock())
			
		TMP7->(dbSkip())
		
	EndDo
	
	TMP7->(dbclosearea())

Next

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oFont2     := TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
oDlg7      := MSDialog():New( 241,176,451,1103,"TÍTULOS VENCIDOS POR PERÍODO",,,.F.,,,,,,.T.,,,.F. )


X90D->(dbGoTop())
DbSelectArea("X90D")
oBrw7      := MsSelect():New( "X90D","","",{{"SERIE"	,"","SERIE",""},;
											{"VALOR"	,"","Valor","@E 9,999,999.99"},;
											{"QTIT"		,"","Qtd Titulos","@E 9,999,999.99"},;
											{"VALXDD"	,"","Valro XDD","@E 9,999,999.99"},;
											{"QTITXDD"	,"","Qtd Tit XDD","@E 9,999,999.99"},;
											{"TOTAL"	,"","Total","@E 9,999,999.99"}},.F.,,{001,001,090,461},,, oDlg7 ) 
oBrw7:oBrowse:nClrPane := CLR_BLACK
oBrw7:oBrowse:nClrText := CLR_BLACK
oBrw7:oBrowse:bLDBLClick := {|| Processa({|| fGeraex( X90D->DTINI, X90D->DTFIM, X90D->SERIE ) }) }

oDlg7:Activate(,,,.T.)

X90D->(DbCloseArea())

Return


/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl7() - Cria temporario para o Alias: X90D
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl7()

Local aFds := {}

Aadd( aFds , {"SERIE"  	,"C",020,000} )
Aadd( aFds , {"VALOR"	,"N",014,002} )
Aadd( aFds , {"QTIT"	,"N",014,002} )
Aadd( aFds , {"VALXDD"	,"N",014,002} )
Aadd( aFds , {"QTITXDD"	,"N",014,002} )
Aadd( aFds , {"TOTAL"	,"N",014,002} )
Aadd( aFds , {"DTINI"   ,"D",008,000} )
Aadd( aFds , {"DTFIM"   ,"D",008,000} )

If Select("X90D") > 0
	DbSelectArea("X90D")
	X90D->(DbCloseArea())	
EndIf

coTbl7 := CriaTrab( aFds, .T. )
Use (coTbl7) Alias X90D New Exclusive

//IndRegua(cTAB,cTRAB,"DIA",,,'Selecionando Registros...') //'Selecionando Registros...'

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ fGeraex() - Cria temporario para o Alias: X90D
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function fGeraex(cDTIni, cDTFim, cSerie)

Local cArquivo		:= GetTempPath(.T.)+'FINR023.xml'
Local cWorkSheet	:= "DETALHES"
Local cTitulo		:= "DETALHES"
Local cMailTo 		:= UsrRetMail(RetCodUsr())
Local cCopia 		:= ""
Local cAssun  		:= "Detalhes CR - " + cSerie
Local cAnexo  		:= "FINR023.xml"
  	
  	cCorpo  := "Para: " + cMailTo + CHR(13) + CHR(10)                                               
  	cCorpo  += "C/Copia: " + cCopia + CHR(13) + CHR(10)
  	cCorpo  += "Segue anexo a planilha." + CHR(13) + CHR(10)


	cQry:=" SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_SALDO, E1_EMISSAO, E1_VENCREA "
	cQry+="         FROM SE1020  "
	cQry+="         WHERE D_E_L_E_T_ <> '*' " 
	cQry+="         AND E1_VENCREA BETWEEN '" + DtoS(cDTIni) + "' AND '" + DtoS(cDTFim) + "' "
	cQry+="         AND E1_TIPO NOT IN ('NCC','RA' ) "  
	cQry+="         AND E1_SALDO > 0  "
	
	TCQUERY cQry NEW ALIAS  "TMP1"
	//MemoWrite("C:\Temp\finr023A.SQL",cQry)
	
	dbSelectArea("TMP1")

	oFWMsExcel := FWMSExcel():New()
		
		//Aba 01 - Teste
	oFWMsExcel:AddworkSheet(cWorkSheet) //Não utilizar número junto com sinal de menos. Ex.: 1-
	//Criando a Tabela
	oFWMsExcel:AddTable(cWorkSheet,cTitulo)
	//Criando Colunas
	
	//nAlign	Numérico	Alinhamento da coluna ( 1-Left,2-Center,3-Right )	
	//nFormat	Numérico	Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
	
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"FILIAL",1,1)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"PREF",1,1)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"NUMERO",1,1)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"PARCELA",1,1) 
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"TIPO",1,1)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"CLIENTE",1,1)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"LOJA",1,1)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"NOME",1,1)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"SALDO",3,2)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"EMISSAO",2,4)
	oFWMsExcel:AddColumn(cWorkSheet,cTitulo,"VENCIMENTO",2,4)
	
	//Criando as Linhas
	TMP1->(dbGoTop())
	While !(TMP1->(EoF()))
	
		oFWMsExcel:AddRow(cWorkSheet,cTitulo,{;
											TMP1->E1_FILIAL ,;
											TMP1->E1_PREFIXO ,;
											TMP1->E1_NUM ,;
											TMP1->E1_PARCELA ,;
											TMP1->E1_TIPO ,;
											TMP1->E1_CLIENTE ,;
											TMP1->E1_LOJA ,;
											TMP1->E1_NOMCLI ,;
											TMP1->E1_SALDO ,;
											TMP1->E1_EMISSAO ,;
											TMP1->E1_VENCREA ;
											})
	
	//										AUX->CNPJ ,;
	//										AUX->TOTAL12M,;
		//Pulando Registro
		TMP1->(DbSkip())
	EndDo

	TMP1->(DbCloseArea())

	If MsgYesNo("Deseja enviar por email para?" + ENTER + ENTER + cMailTo)
		
		cArquivo		:= "\temp\FINR023" + SubStr(X90D->SERIE,1,1) + ".xml"
		cAnexo			:= "FINR023" + SubStr(X90D->SERIE,1,1) + ".xml"
		//Ativando o arquivo e gerando o xml
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo)

		Sleep(5000)
		SendPSV(cMailTo, cCopia, cAssun, cCorpo,"\temp\", cAnexo )
		//U_SendFatr11(cMailTo, cCopia, cAssun, cCorpo, cAnexo )

	Else
		
		cArquivo  := cGetFile( '*.XML |*.XML|',"Inclua o nome do arquivo",,,.F.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE,.F.)  //"Escolha o arquivo de Mala Direta"
		
		//Ativando o arquivo e gerando o xml
		oFWMsExcel:Activate()
		oFWMsExcel:GetXMLFile(cArquivo)
		//Abrindo o excel e abrindo o arquivo xml
		oExcel := MsExcel():New() 			//Abre uma nova conexão com Excel
		oExcel:WorkBooks:Open(cArquivo) 	//Abre uma planilha
		oExcel:SetVisible(.T.) 				//Visualiza a planilha
		oExcel:Destroy()						//Encerra o processo do gerenciador de tarefas
	
	EndIf

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



