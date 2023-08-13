// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : PCPR051
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 20/02/18 | Gustavo Costa     | Resumo horas improdutivas
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch " 

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Montagem da tela de processamento

@author    TOTVS Developer Studio - Gerado pelo Assistente de C๓digo
@version   1.xx
@since     7/08/2012
/*/
//------------------------------------------------------------------------------------------
User function PCPR051()
//--< variแveis >---------------------------------------------------------------------------

/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Declara็ใo de Variaveis do Tipo Local, Private e Public                 ฑฑ
ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/

Local cQuery	:=''
Local oFWMsExcel
Local oExcel
Local cArquivo	:= GetTempPath()+'PCPR051.xml'
Local cTurno	:= ""
Local cTURNO1   := Left(GetMv("MV_TURNO1"),5)
Local cTURNO2   := Left(GetMv("MV_TURNO2"),5)

//////////seleciona os dados

Pergunte('PCPR51',.T.)

fCriaTAB()

cQuery := "SELECT H6_FILIAL, H6_RECURSO, H6_OPERADO, H6_LADO, H6_QTDPERD, H6_DATAINI, H6_HORAINI, H6_HORAFIN FROM SH6020 "
cQuery += "WHERE D_E_L_E_T_ <> '*' "
cQuery += "AND H6_DATAINI BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' " 
cQuery += "AND H6_MOTIVO = '600' "	
cQuery += "AND H6_RECURSO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' " 
cQuery += "ORDER BY H6_FILIAL, H6_DATAINI, H6_RECURSO, H6_LADO, H6_HORAINI, H6_OPERADO "

//MemoWrite("C:\Temp\PCPR51A.sql", cQuery )

If Select("AUX") > 0
	DbSelectArea("AUX")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "AUX"
//TCSetField( "AUX", "ZZ2_DATA", "D")

While AUX->( !EOF() )

	If AUX->H6_HORAINI < cTURNO2
		cTurno	:= "1"
	Else
		cTurno	:= "2"
	EndIf

	dbSelectArea("XE1")
	//TURNO+DIA+REC+LADO+PROD
	If XE1->(dbseek(cTurno + AUX->H6_DATAINI + Alltrim(AUX->H6_RECURSO) + Alltrim(AUX->H6_LADO) + Alltrim(AUX->H6_OPERADO)))
	
		RecLock("XE1", .F.)
		
		XE1->HRDISP		:= XE1->HRDISP + AUX->H6_QTDPERD
		
		If AUX->H6_HORAINI < XE1->HINI
			XE1->OBS	:= ""
		EndIf
		
		If AUX->H6_HORAFIN > XE1->HFIM
			XE1->OBS	:= XE1->OBS + XE1->HFIM + ' >> ' + AUX->H6_HORAFIN + ' | '
			XE1->HFIM		:= AUX->H6_HORAFIN
		EndIf

		XE1->(MsUnLock())
		
	Else

		RecLock("XE1", .T.)

		XE1->TURNO		:= cTurno
		XE1->DIA		:= AUX->H6_DATAINI
		XE1->REC		:= AUX->H6_RECURSO
		XE1->LADO		:= AUX->H6_LADO
		XE1->PROD		:= AUX->H6_OPERADO
		XE1->HINI		:= AUX->H6_HORAINI
		XE1->HFIM		:= AUX->H6_HORAFIN
		XE1->HRDISP		:= AUX->H6_QTDPERD
		XE1->HRINDISP	:= 0
		
		XE1->(MsUnLock())
		
	EndIf
	AUX->(Dbskip())
	
Enddo

AUX->( DbCloseArea() ) 

XE1->( DbGoTop() )
While XE1->( !EOF() )

	RecLock("XE1", .F.)
	
	XE1->HRINDISP		:= fHoraInd(xFilial() ,XE1->DIA, XE1->REC, XE1->HINI, XE1->HFIM, XE1->LADO, XE1->TURNO)

	XE1->(MsUnLock())

	XE1->(Dbskip())

Enddo

	//Criando o objeto que irแ gerar o conte๚do do Excel
	oFWMsExcel := FWMSExcel():New()
	
	//Aba 01 - Teste
	oFWMsExcel:AddworkSheet("PCPR051") //Nใo utilizar n๚mero junto com sinal de menos. Ex.: 1-
		//Criando a Tabela
		oFWMsExcel:AddTable("PCPR051","Resumo de Horas")
		//Criando Colunas
		oFWMsExcel:AddColumn("PCPR051","Resumo de Horas","TURNO",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("PCPR051","Resumo de Horas","DATA",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("PCPR051","Resumo de Horas","RECURSO",1,1) //2 = Valor sem R$
		oFWMsExcel:AddColumn("PCPR051","Resumo de Horas","LADO",1,1) //3 = Valor com R$
		oFWMsExcel:AddColumn("PCPR051","Resumo de Horas","PRODUTO",1,1)
		oFWMsExcel:AddColumn("PCPR051","Resumo de Horas","MINUTOS DISP.",2,2)
		oFWMsExcel:AddColumn("PCPR051","Resumo de Horas","MINUTOS INDISP.",2,2)
		oFWMsExcel:AddColumn("PCPR051","Resumo de Horas","RESULTADO",2,2)
		oFWMsExcel:AddColumn("PCPR051","Resumo de Horas","H. Ini",1,1)
		oFWMsExcel:AddColumn("PCPR051","Resumo de Horas","H. Fim",1,1)
		oFWMsExcel:AddColumn("PCPR051","Resumo de Horas","OBS",1,1)
		//Criando as Linhas
		XE1->(dbGoTop())
		While !(XE1->(EoF()))

			oFWMsExcel:AddRow("PCPR051","Resumo de Horas",{;
															XE1->TURNO ,;
															DtoC(StoD(XE1->DIA)) ,;
															XE1->REC ,;
															XE1->LADO ,;
															XE1->PROD ,;
															XE1->HRDISP * 60 ,;
															XE1->HRINDISP * 60 ,;
															(XE1->HRDISP - XE1->HRINDISP) * 60,;
															XE1->HINI ,;
															XE1->HFIM,;
															XE1->OBS;
															})
		
			//Pulando Registro
			XE1->(DbSkip())
		EndDo
	
	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)
		
	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New() 			//Abre uma nova conexใo com Excel
	oExcel:WorkBooks:Open(cArquivo) 	//Abre uma planilha
	oExcel:SetVisible(.T.) 				//Visualiza a planilha
	oExcel:Destroy()						//Encerra o processo do gerenciador de tarefas
	
	XE1->(DbCloseArea())
	//RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ fHoraInd บ Autor ณ Gustavo Costa     บ Data ณ  07/10/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada para calcular o as horas indisponiveisบฑฑ
ฑฑบ          ณ                       .                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fHoraInd(cEmp ,cData, cRec, cHoraIni, cHoraFim, cLado, cTurno)

Local cQuery	:=''
Local nRet		:= 0
Local cTURNO1   := Left(GetMv("MV_TURNO1"),5)
Local cTURNO2   := Left(GetMv("MV_TURNO2"),5)
Local cTURNO3   := Left(GetMv("MV_TURNO3"),5)

//////////seleciona os dados
//cQuery := " SELECT SUM(E1_SALDO) SALDO FROM " + RetSqlName("SE1") 
cQuery := " SELECT H6_FILIAL, H6_RECURSO, H6_LADO, H6_QTDPERD, H6_HORAINI, H6_HORAFIN FROM SH6020 "
cQuery += " WHERE D_E_L_E_T_ <> '*' "
//cQuery += " AND H6_FILIAL = '" + cEmp + "' " 
cQuery += " AND H6_DATAINI = '" + cData + "' " 
cQuery += " AND H6_MOTIVO <> '600'
cQuery += " AND H6_RECURSO = '" + cRec + "' "
cQuery += " AND H6_HORAINI >= '" + cHoraIni + "' "
cQuery += " AND H6_HORAINI < '" + IIF(cTurno = "1",cTURNO2,cTURNO3) + "' "
//cQuery += " AND H6_HORAFIN <= '" + cHoraFim + "' "
cQuery += " AND H6_LADO = '" + cLado + "' "
cQuery += " ORDER BY H6_FILIAL, H6_HORAINI "
 
//MemoWrite("C:\Temp\PCPR51B.sql", cQuery )
 
If Select("XSAL") > 0
	DbSelectArea("XSAL")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XSAL"

XSAL->( DbGoTop() )

While !(XSAL->(EoF()))

	If XSAL->H6_HORAFIN <= cHoraFim
		nRet := nRet + XSAL->H6_QTDPERD
	Else
		If XSAL->H6_HORAINI < cHoraFim
			msgAlert("Hini " + cHoraIni +" " + "Hfim " + cHoraFim + " " + XSAL->H6_RECURSO + XSAL->H6_LADO + XSAL->H6_HORAINI + XSAL->H6_HORAFIN + " dif " + ;
			 ElapTime ( XSAL->H6_HORAINI + ":00", cHoraFim + ":00" ))
		//nRet := nRet + fHoraToVal( SubStr( ElapTime ( XSAL->H6_HORAINI, IIF(cTurno = "1",cTURNO2,cTURNO3) ),1,5))
		EndIf 
	EndIf
	
	XSAL->(DbSkip())

EndDo
		
Return nRet

Static Function fHoraToVal (cHora, cSep)
    Local aArea   := GetArea()
    Local nAux    := 0
    Local cMin    := ""
    Local nValor  := 0
    Local nPosSep := 0
    Default cHora := ""
    Default cSep  := ':'
     
    //Se tiver a hora
    If !Empty(cHora)
        nPosSep := RAt(cSep, cHora)
        nAux    := Val(SubStr(cHora, nPosSep+1, 2))
        nAux    := Int(Round((nAux*100)/60, 0))
        cMin    := Iif(nAux > 10, cValToChar(nAux), "0"+cValToChar(nAux))
        nValor  := Val(SubStr(cHora, 1, nPosSep-1)+"."+cMin)
    EndIf
     
    RestArea(aArea)
Return nValor


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCriaTAB     บ Autor ณ Gustavo Costa  บ Data ณ  27/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ Cria a tabela temporaria de cada recurso.                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fCriaTAB()

Local aFds	:= {}
Private cTRAB	:= ""
Private cTAB	:= "XE1"

Aadd( aFds , {"TURNO"  		,"C",001,000} )
Aadd( aFds , {"DIA" 	  	,"C",008,000} )
Aadd( aFds , {"REC"   		,"C",003,000} )
Aadd( aFds , {"LADO" 		,"C",001,000} )
Aadd( aFds , {"PROD" 		,"C",015,000} )
Aadd( aFds , {"HINI" 		,"C",005,000} )
Aadd( aFds , {"HFIM" 		,"C",005,000} )
Aadd( aFds , {"HRDISP" 		,"N",014,002} )
Aadd( aFds , {"HRINDISP"   	,"N",014,002} )
Aadd( aFds , {"RESULT" 		,"N",014,002} )
Aadd( aFds , {"OBS" 		,"C",040,000} )

cTRAB := CriaTrab( aFds, .T. )
Use (cTRAB) Alias &cTAB New Exclusive
IndRegua(cTAB,cTRAB,"TURNO+DIA+REC+LADO+PROD",,,'Selecionando Registros...') //'Selecionando Registros...'

Return
