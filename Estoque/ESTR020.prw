#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ESTR020  ³ Autor ³ Gustavo Costa          ³ Data ³04.05.2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o   ³Relacao  de Horas Improdutivas / Produtivas apontadas      .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ESTR020()

Local oReport
Local cPerg	:= "ESTR20"

Private lJob		:= .F.

//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//Não consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SX1" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Relacao de Horas Improdutivas / Produtivas apontadas... '+Dtoc(DATE())+' - '+Time())
		lJob := .T.
	EndIf

	If	lJob
		oReport:= ReportDef()
		oReport:Print(.F.)
	Else
		criaSx1(cPerg)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Interface de impressao                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		oReport:= ReportDef()
		oReport:PrintDialog()
	EndIf

	If	( lJob )
		RpcClearEnv()		   				//Libera o Environment
		ConOut('Relacao de Horas Improdutivas / Produtivas apontadas. '+Dtoc(DATE())+' - '+Time())
	EndIf


Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data de?'     	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data até?'  	, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
putSx1(cPerg, '03', 'Do Recurso?' 	, '', '', 'mv_ch3', 'C', 9                     	, 0, 0, 'G', '', 'SH1', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Recurso inicial"},{},{})
putSx1(cPerg, '04', 'Ate Recurso?'	, '', '', 'mv_ch4', 'C', 9                     	, 0, 0, 'G', '', 'SH1', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Recurso final"},{},{})
putSx1(cPerg, '05', 'Do Motivo?' 	, '', '', 'mv_ch5', 'C', 9                     	, 0, 0, 'G', '', '', '', '', 'mv_par05','','','','','','','','','','','','','','','','',{"Motivo inicial"},{},{})
putSx1(cPerg, '06', 'Ate Motivo?'	, '', '', 'mv_ch6', 'C', 9                     	, 0, 0, 'G', '', '', '', '', 'mv_par06','','','','','','','','','','','','','','','','',{"Motivo final"},{},{})

return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ESTR018  ³ Autor ³ Gustavo Costa          ³ Data ³11.03.2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio das Índice das Inspeções de Processo                .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:= TReport():New("ESTR20","Relacao de Horas Improdutivas / Produtivas apontadas" ,"ESTR20", {|oReport| ReportPrint(oReport)},"Este relatório irá listar a Relacao de Horas Improdutivas / Produtivas apontadas.")
//oReport:SetLandscape()
oReport:SetPortrait()

If lJob
	oReport:nDevice	 	:= 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
	oReport:cEmail		:= GetNewPar("MV_XESTR20",'gustavo@ravaembalagens.com.br')
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Data de                ³
//³ mv_par02   // Data Até               ³
//³ mv_par03   // Vendedor               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(oReport:uParam,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 1                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1 := TRSection():New(oReport,"Nota Fiscal",{"TMP"}) 

//TRCell():New(oSection1,'FILIAL'			,'','Filial'		,	/*Picture*/			,02				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'DIA'			,'','Data'			,	/*Picture*/			,10				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'XTURNO'			,'','Turno'			,	"@!"				,10				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'REC'			,'','Recurso'		,	"@!"				,08				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'LADO'			,'','Lado'			,	/*Picture*/			,01				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'TIPO'			,'','Área'			,	/*Picture*/			,15				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'TEMPO'			,'','Tempo Parado'	,	/*Picture*/			,12				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'PERC'			,'','% Parado'		,	"@E 9,999.99"		,12				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")

//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("REC"),"Recurso:",.F.)

//New(oParent,uBreak,uTitle,lTotalInLine,cName,lPageBreak)
//TRFunction():New(oSection2:Cell("DESCO"),NIL,"SUM",oBreak,"Total Horas Descontadas",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)
//TRFunction():New(oSection1:Cell('PERC') ,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell('REAL') ,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell('REALP') ,NIL,"AVERAGE",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell('RESTA') ,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)

Return(oReport)

/*/
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
//Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
Local lOK 			:= .T.
Local d1			:= IIF(lJob,FirstDay(dDataBase),mv_par01)
Local d2			:= IIF(lJob,dDataBase-1,mv_par02)
Local lCabec		:= .T.
Local cGrupoAnt		:= ""
Local nHorasProd	:= 0
Local cTurno		:= ""
Local nResta		:= 0
lOCAL cRecAnt		:= ""
lOCAL nDispon		:= 0
lOCAL nDisponA		:= 0
lOCAL nDisponB		:= 0
Local lLadoA		:= .F.
Local lLadoB		:= .F.
Local nTotalH		:= 0

PRIVATE lMudouDia	:= .F.
PRIVATE dDiaAtu		:= CtoD("  /  /  ")
PRIVATE dDiaAnt		:= CtoD("  /  /  ")
PRIVATE cTURNO1   	:= SubStr(GetMv( "MV_TURNO1" ),1,5) 
PRIVATE cTURNO2   	:= SubStr(GetMv( "MV_TURNO2" ),1,5)
PRIVATE cTURNO3   	:= SubStr(GetMv( "MV_TURNO3" ),1,5)
PRIVATE nTmpT1 		:= 440 //TempoLig( cTURNO2, cTURNO1, .F.) //Val(subStr(cTURNO1,5,2)) + (Val(subStr(cTURNO1,1,3)) * 60)
PRIVATE nTmpT2 		:= 440 //TempoLig( cTURNO3, cTURNO2, .F.) //Val(subStr(cTURNO2,5,2)) + (Val(subStr(cTURNO2,1,3)) * 60)
PRIVATE nTmpT3 		:= 380 //TempoLig( cTURNO1, cTURNO3, .T.) //Val(subStr(cTURNO3,5,2)) + (Val(subStr(cTURNO3,1,3)) * 60)

//MsgAlert("T1 " + StrZero(nTmpT1,3) + " T2 " + StrZero(nTmpT2,3) + " T3 " + StrZero(nTmpT3,3) )
mv_par01 := d1

oTbl1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"PERÍODO de " + DtoC(d1) + " até " + DtoC(d2) )
oReport:SkipLine()

While !oReport:Cancel() .And. d1 <= d2

	cQuery := " SELECT SUBSTRING(H6_MOTIVO,1,1) GMOTIVO, SH6.H6_FILIAL, SH6.H6_PRODUTO, SH6.H6_OPERAC, SH6.H6_SEQ, SH6.H6_DATAINI, SH6.H6_HORAINI, " 
	cQuery += "        SH6.H6_DATAFIN, SH6.H6_HORAFIN, SH6.H6_RECURSO, SH6.H6_OP, SH6.H6_MOTIVO, SH6.H6_DTAPONT, "
	cQuery += "        SH6.H6_OPERADO, SH6.H6_TEMPO, SH6.H6_TIPOTEM, SH6.H6_TIPO, SH6.H6_FERRAM, SH6.H6_LADO "
	cQuery += " FROM " + RetSqlName("SH6") + " SH6 "
	cQuery += " WHERE H6_FILIAL = '" + xFilial("SH6") + "' AND "
	cQuery += " 	  H6_DATAINI+H6_HORAINI  Between '" + DtoS(d1) + cTURNO1 + "' AND '" + DtoS(d1+1) + cTURNO1 + "' AND "
	cQuery += "  	  H6_RECURSO  Between '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
	cQuery += "  	  H6_MOTIVO   Between '" + mv_par05 + "' AND '" + mv_par06 + "' AND "
	cQuery += " 	  D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY H6_DATAINI, SUBSTRING(H6_MOTIVO,1,1), H6_HORAINI "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf

	TCQUERY cQuery NEW ALIAS "TMP"
	TCSetField( "TMP", "H6_DATAINI", "D")
	TCSetField( "TMP", "H6_DATAFIN", "D")

	nCount	:= TMP->(RECCOUNT())
	TMP->( DbGoTop() )

	oReport:SetMeter(nCount)

	While TMP->(!EOF())

		oReport:IncMeter()
		
		If TMP->H6_DATAFIN - TMP->H6_DATAINI > 0
			lMudouDia	:= .T.
		Else
			lMudouDia	:= .F.
		EndIf

		Do Case
			case TMP->H6_HORAINI > cTURNO1 .and. TMP->H6_HORAINI < cTURNO2

				cTurno	:= "1"

				If TMP->H6_HORAFIN > cTURNO2 .OR. TMP->H6_DATAFIN > TMP->H6_DATAINI
					nResta 	:= TempoLig(TMP->H6_HORAFIN, cTURNO2, lMudouDia)
				EndIf

			case TMP->H6_HORAINI > cTURNO2 .and. TMP->H6_HORAINI < cTURNO3

				cTurno	:= "2"

				If TMP->H6_HORAFIN > cTURNO3 .OR. TMP->H6_DATAFIN > TMP->H6_DATAINI
					nResta 	:= TempoLig(TMP->H6_HORAFIN, cTURNO3, lMudouDia)
				EndIf

			//case TMP->H6_HORAINI > cTURNO2 .and. TMP->H6_HORAINI < cTURNO3
			OtherWise
			
				cTurno	:= "3"
				/*
				If TMP->H6_HORAFIN > cTURNO1 .OR. TMP->H6_DATAFIN > TMP->H6_DATAINI
					nResta 	:= TempoLig(TMP->H6_HORAFIN, cTURNO1, lMudouDia)
				EndIf
				*/
		EndCase
		
		nHorasProd 	:= Val(subStr(TMP->H6_TEMPO,5,2)) + (Val(subStr(TMP->H6_TEMPO,1,3)) * 60) - nResta

		dbSelectArea("XMP")
		If XMP->(dbSeek(DtoC(TMP->H6_DATAINI) + cTurno + Alltrim(TMP->H6_RECURSO) + TMP->H6_LADO + TMP->GMOTIVO))
		
			RecLock("XMP",.F.)
			
			XMP->TEMPO		:= XMP->TEMPO + nHorasProd
			
			Do Case
				case cTurno	== "1"
					XMP->PERC		:= (XMP->TEMPO/nTmpT1) * 100
					//XMP->PERC		:= ((XMP->TEMPO + nHorasProd)/nTmpT1) * 100
				case cTurno	== "2"
					XMP->PERC		:= (XMP->TEMPO/nTmpT2) * 100
				case cTurno	== "3"
					XMP->PERC		:= (XMP->TEMPO/nTmpT3) * 100
			EndCase
			
			MsUnLock()
		
		Else

			RecLock("XMP",.T.)
			
			XMP->DIA		:= DtoC(TMP->H6_DATAINI)
			XMP->TURNO		:= cTurno
			XMP->REC		:= TMP->H6_RECURSO
			XMP->LADO		:= TMP->H6_LADO
			XMP->TIPO		:= TMP->GMOTIVO
			XMP->TEMPO		:= XMP->TEMPO + nHorasProd
			
			Do Case
				case cTurno	== "1"
					XMP->PERC		:= (XMP->TEMPO/nTmpT1) * 100
				case cTurno	== "2"
					XMP->PERC		:= (XMP->TEMPO/nTmpT2) * 100
				case cTurno	== "3"
					XMP->PERC		:= (XMP->TEMPO/nTmpT3) * 100
			EndCase
			
			MsUnLock()
		
		EndIf
		
		If nResta > 0
		
			cTurno	:= Soma1(cTurno)
			
			If XMP->(dbSeek(DtoC(TMP->H6_DATAINI) + cTurno + Alltrim(TMP->H6_RECURSO) + TMP->H6_LADO + TMP->GMOTIVO))
			
				RecLock("XMP",.F.)
				
				XMP->TEMPO		:= XMP->TEMPO + nResta - nHorasProd
				
				Do Case
					case cTurno	== "1"
						XMP->PERC		:= (XMP->TEMPO/nTmpT1) * 100
					case cTurno	== "2"
						XMP->PERC		:= (XMP->TEMPO/nTmpT2) * 100
					case cTurno	== "3"
						XMP->PERC		:= (XMP->TEMPO/nTmpT3) * 100
				EndCase
				
				MsUnLock()
			
			Else
	
				RecLock("XMP",.T.)
				
				XMP->DIA		:= DtoC(TMP->H6_DATAINI)
				XMP->TURNO		:= cTurno
				XMP->REC		:= TMP->H6_RECURSO
				XMP->LADO		:= TMP->H6_LADO
				XMP->TIPO		:= TMP->GMOTIVO
				XMP->TEMPO		:= XMP->TEMPO + nResta - nHorasProd
				
				Do Case
					case cTurno	== "1"
						XMP->PERC		:= (XMP->TEMPO/nTmpT1) * 100
					case cTurno	== "2"
						XMP->PERC		:= (XMP->TEMPO/nTmpT2) * 100
					case cTurno	== "3"
						XMP->PERC		:= (XMP->TEMPO/nTmpT3) * 100
				EndCase
				
				MsUnLock()
			
			EndIf

		EndIf
		
		nResta	:= 0
		dbSelectArea("TMP")
		TMP->(dbSkip())
		
	EndDo

	d1 := d1 + 1
	
EndDo

dbSelectArea("XMP")
XMP->(dbGoTop())

oSection1:Init()
		
While XMP->(!EOF())

	oSection1:Cell("DIA"):SetValue(XMP->DIA)
	oSection1:Cell("DIA"):SetAlign("CENTER")
	oSection1:Cell("XTURNO"):SetValue(XMP->TURNO)
	oSection1:Cell("XTURNO"):SetAlign("CENTER")
	oSection1:Cell("REC"):SetValue(XMP->REC)
	oSection1:Cell("REC"):SetAlign("CENTER")
	oSection1:Cell("LADO"):SetValue(XMP->LADO)
	oSection1:Cell("LADO"):SetAlign("CENTER")
	//MsgAlert("Turno: " + XMP->TURNO + " TIPO " + XMP->TIPO + " TEMPO " + STRZero(XMP->TEMPO,6))
	Do Case
	
		Case XMP->TIPO == "0" //Engenharia
			oSection1:Cell("TIPO"):SetValue("ENGENHARIA")
		Case XMP->TIPO == "1" //PCP
			oSection1:Cell("TIPO"):SetValue("PCP")
		Case XMP->TIPO == "2" //RH
			oSection1:Cell("TIPO"):SetValue("RH")
		Case XMP->TIPO == "3" //TI
			oSection1:Cell("TIPO"):SetValue("TI")
		Case XMP->TIPO == "4" //MANUTENÇÃO
			oSection1:Cell("TIPO"):SetValue("MANUTENÇÃO")
		Case XMP->TIPO == "5" //PRODUÇÃO
			oSection1:Cell("TIPO"):SetValue("PRODUÇÃO")
	
	EndCase
	oSection1:Cell("TIPO"):SetAlign("LEFT")
	
	oSection1:Cell("TEMPO"):SetValue(StrZero(Int(XMP->TEMPO / 60),2) + ":" + StrZero(XMP->TEMPO % 60,2))
	oSection1:Cell("TEMPO"):SetAlign("RIGHT")
	oSection1:Cell("PERC"):SetValue(XMP->PERC)
	oSection1:Cell("PERC"):SetAlign("RIGHT")

	oSection1:PrintLine()
	
	//nDispon		:= (nDispon + XMP->PERC)/2
	nTotalH		:= nTotalH + XMP->TEMPO

	If XMP->LADO == "A"
		nDisponA	:= nDisponA + XMP->PERC
		lLadoA		:= .T.
	Else
		nDisponB	:= nDisponB + XMP->PERC
		lLadoB		:= .T.
	EndIf

	cRecAnt		:= XMP->REC
	
	XMP->(dbSkip())

	If cRecAnt	<> XMP->REC
		//oSection1:Finish()
		If lLadoA .AND. lLadoB
			nDispon	:= (nTotalH / (nTmpT1 + nTmpT2)) * 100
		Else
			nDispon	:= (nTotalH / (nTmpT1 + nTmpT2)) * 100
		EndIf

		oReport:Say(oReport:Row(),oReport:Col(),"DISPONIBILIDADE - " + Alltrim(cRecAnt) + ;
		" Lado A = " + Transform( 100 - nDisponA, "@E 9,999.99") + "%" +;
		" Lado B = " + Transform( 100 - nDisponB, "@E 9,999.99") + "%" +;
		" TOTAL = " + Transform( 100 - nDispon, "@E 9,999.99") + "%" )
		oReport:SkipLine()
		oReport:SkipLine()
		nDispon		:= 0
		nDisponA	:= 0
		nDisponB	:= 0
		lLadoA		:= .F.
		lLadoB		:= .F.
		nTotalH		:= 0
		//oSection1:Init()
	EndIf
	
EndDo

oSection1:Finish()
dbCloseArea("TMP")

Set Filter To

Return

/*ÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Function  ³ oTbl1() - Cria temporario para o Alias: XMP
ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Static Function oTbl1()

Local aFds := {}

Aadd( aFds , {"DIA"  	,"C",010,000} )
Aadd( aFds , {"TURNO" 	,"C",001,000} )
Aadd( aFds , {"REC" 	,"C",003,000} )
Aadd( aFds , {"LADO" 	,"C",001,000} )
Aadd( aFds , {"TIPO"  	,"C",001,000} )
Aadd( aFds , {"TEMPO"  	,"N",005,000} )
Aadd( aFds , {"PERC" 	,"N",008,002} )

//coTbl1 := CriaTrab( aFds, .T. )
//Use (coTbl1) Alias XMP New Exclusive

cNomeArq := CriaTrab(aFds,.T.)
dbUseArea( .T.,, cNomeArq, "XMP", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("XMP",cNomeArq,"DIA+TURNO+REC+LADO+TIPO",,,OemToAnsi("Selecionando Registros..."))  //

Return 


**************
Static Function TempoLig( _cHora1, _cHora2, lDiaSeg)
**************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1:=_nRs2:=_nRs3:=0
local _cRes:=''
local Hr,ResHr,Mi,Seg
local cHr:=''
local cRs4:='' 

If lDiaSeg
	
	//********************************************************
	//Inverte as horas para calcular até meia noite 
	//********************************************************
	cHoraDS	:= _cHora1
	_cHora1	:= "23:59:59"

	_nHr1 	:= Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
	_nMi1 	:= Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
	cRs4	:= Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
	_nSg1 	:= Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 
	
	_nHr2 	:= Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
	_nMi2 	:= Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
	cRs4	:= Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
	_nSg2 	:= Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )
	
	_nRs1	:= _nHr1+_nMi1+_nSg1
	_nRs2	:= _nHr2+_nMi2+_nSg2
	
	_nRs3	:= _nRs1 - _nRs2 + 1
	
	//********************************************************
	//Calcula de 00:00 até a proxima hora.
	//********************************************************

	_cHora1	:= cHoraDS
	_cHora2	:= "00:00:00"

	_nHr1 	:= Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
	_nMi1 	:= Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
	cRs4	:= Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
	_nSg1 	:= Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 
	
	_nHr2 	:= Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
	_nMi2 	:= Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
	cRs4	:= Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
	_nSg2 	:= Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )
	
	_nRs1	:= _nHr1+_nMi1+_nSg1
	_nRs2	:= _nHr2+_nMi2+_nSg2
	
	_nRs3	+= _nRs1 - _nRs2

	lMudouDia	:= .F.
	
Else

	_nHr1 	:= Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
	_nMi1 	:= Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
	cRs4	:= Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
	_nSg1 	:= Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 
	
	_nHr2 := Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
	_nMi2 := Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
	cRs4:=Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
	_nSg2 := Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )
	
	_nRs1:=_nHr1+_nMi1+_nSg1
	_nRs2:=_nHr2+_nMi2+_nSg2
	
	_nRs3:=_nRs1 - _nRs2

EndIf
	
if _nRs3<0
  _nRs3	:= 0  
Endif
//Retronando em minutos
Return(  Round(_nRs3/60,0)  )    
