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
±±³Programa  ³INADIMP  ³ Autor ³ Gustavo Costa          ³ Data ³06.08.2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o   ³Relatorio Inadimplencia por periodo .                       .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INADIMP()

Local oReport
Local cPerg	:= "INADIP"

Private lJob		:= .F.
PRIVATE aCampos	:= {}

//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//Não consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SX1" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Relatorio Inadimplencia por periodo... '+Dtoc(DATE())+' - '+Time())
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
		ConOut('Relatorio Inadimplencia por periodo. '+Dtoc(DATE())+' - '+Time())
	EndIf


Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Periodo ?'     	, '', '', 'mv_ch1', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
//putSx1(cPerg, '02', 'Data até?'  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
//putSx1(cPerg, '03', 'Nota Fiscal?' 	, '', '', 'mv_ch3', 'C', 9                     	, 0, 0, 'G', '', 'SF2', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Em branco para todos"},{},{})
//putSx1(cPerg, '04', 'Cliente?'			, '', '', 'mv_ch4', 'C', 9                     	, 0, 0, 'G', '', 'SF2', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Em branco para todos"},{},{})

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

oReport:= TReport():New("INADIP","Inadimplencia por periodo" ,"INADIP", {|oReport| ReportPrint(oReport)},"Este relatório irá listar a Inadimplencia por periodo.")
oReport:SetLandscape()
//oReport:SetPortrait()

If lJob
	oReport:nDevice	 	:= 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
	oReport:cEmail		:= GetNewPar("MV_XINADIP",'gustavo@ravaembalagens.com.br')
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

TRCell():New(oSection1,'FILIAL'			,'','Filial'				,	/*Picture*/			,02				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'EST'			,'','Estado'				,	/*Picture*/			,02				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'PREVATU'		,'','Prev. Atual'			,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'REALATU'		,'','N Rec Atual'			,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')
TRCell():New(oSection1,'PERCATU'		,'','% Inad. Atual'			,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')
TRCell():New(oSection1,'PERCMA'			,'','% Inad. Mes Ant.'		,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')
TRCell():New(oSection1,'PERCAA'			,'','% Inad. Ano Ant.'		,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')

TRCell():New(oSection1,'PREVATX'		,'','Prev. XDD Atu'			,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'REALATX'		,'','N Rec XDD Atu'			,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')
TRCell():New(oSection1,'PERCATX'		,'','% Inad XDD Atu'		,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')
TRCell():New(oSection1,'PERCMAX'		,'','% Inad XDD M.A.'		,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')
TRCell():New(oSection1,'PERCAAX'		,'','% Inad XDD A.A.'		,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')

TRCell():New(oSection1,'PREVATT'		,'','Prev. Tot Atual'		,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'REALATT'		,'','N Rec Tot Atual'		,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')
TRCell():New(oSection1,'PERCATT'		,'','% Inad Tot At.'		,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')
TRCell():New(oSection1,'PERCMAT'		,'','% Inad Tot M.A.'		,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')
TRCell():New(oSection1,'PERCAAT'		,'','% Inad Tot A.A.'		,	"@E 999,999,999.99"	,16				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')
//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

aADD(aCampos,{"FILIAL" 	,"C",02,0})
aADD(aCampos,{"EST" 	,"C",02,0})

//NOTA
aADD(aCampos,{"PREVATU" ,"N",16,2})
aADD(aCampos,{"REALATU" ,"N",16,2})
aADD(aCampos,{"PREVMA" 	,"N",16,2})
aADD(aCampos,{"REALMA" 	,"N",16,2})
aADD(aCampos,{"PREVAA" 	,"N",16,2})
aADD(aCampos,{"REALAA" 	,"N",16,2})
//XDD
aADD(aCampos,{"PREVATX" ,"N",16,2})
aADD(aCampos,{"REALATX" ,"N",16,2})
aADD(aCampos,{"PREVMAX" ,"N",16,2})
aADD(aCampos,{"REALMAX" ,"N",16,2})
aADD(aCampos,{"PREVAAX" ,"N",16,2})
aADD(aCampos,{"REALAAX" ,"N",16,2})

cNomeArq := CriaTrab(aCampos,.T.)
dbUseArea( .T.,, cNomeArq, "XTS", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("XTS",cNomeArq,"EST",,,OemToAnsi("Selecionando Registros..."))  //

oBreak := TRBreak():New(oSection1,oSection1:Cell("FILIAL"),"Total:",.F.)

//New(oParent,uBreak,uTitle,lTotalInLine,cName,lPageBreak)
//TRFunction():New(oSection2:Cell("DESCO"),NIL,"SUM",oBreak,"Total Horas Descontadas",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)
TRFunction():New(oSection1:Cell('PREVATU') 	,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell('REALATU') 	,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell('PREVATX') 	,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell('REALATX') 	,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell('PREVATT') 	,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell('REALATT') 	,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell('PERC') 		,NIL,"AVAREGE",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)

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
Local cMatAnt		:= ""
Local nNivel   		:= 0
Local lPula	 		:= .T.
Local lOK 			:= .T.
Local d1			:= IIF(lJob,FirstDay(dDataBase),CtoD("01/" + SubStr(mv_par01, 1, 2) + "/" + SubStr(mv_par01, 3, 4) ))
Local d2			:= LastDay(d1)
Local lCabec		:= .T.
Local nPerc1		:= 0
Local nPerc2		:= 0
Local nPerc3		:= 0

Local nTRAtu		:= 0
Local nTPAtu		:= 0
Local nTRXDD		:= 0
Local nTPXDD		:= 0

Local nTRAtuMA		:= 0
Local nTPAtuMA		:= 0
Local nTRXDDMA		:= 0
Local nTPXDDMA		:= 0

Local nTRAtuAA		:= 0
Local nTPAtuAA		:= 0
Local nTRXDDAA		:= 0
Local nTPXDDAA		:= 0

Local aValor		:= {}
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
oReport:Say(oReport:Row(),oReport:Col(),"PERÍODO ATUAL " + DtoC(d1) + " até " + DtoC(LastDay(d1)) )
oReport:SkipLine()

//***************************************************
//PREVISAO RECEBIMENTO ATUAL, MES ANTERIOR E ANO ANTERIOR	
//***************************************************
For x := 1 To 3

	cQuery := " SELECT A1_EST, " 
	cQuery += " SUM( CASE WHEN E1_SERIE = '0' THEN E1_VALOR ELSE 0 END ) DENTRO, "
	cQuery += " SUM( CASE WHEN E1_SERIE = '' THEN E1_VALOR ELSE 0 END ) FORA "
	cQuery += " FROM " + RetSqlName("SE1") + " E1 "
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1 "
	cQuery += " ON E1_CLIENTE = A1_COD "
	cQuery += " AND E1_LOJA = A1_LOJA "
	cQuery += " WHERE E1.D_E_L_E_T_ <> '*' "
	cQuery += " AND E1_TIPO NOT IN ('NCC','RA') "
	cQuery += " AND E1_FILIAL = '" + xFilial("SE1") + "' "
	cQuery += " AND A1_SATIV1 <> '000009' "

	Do Case
	
		Case x == 1
			cQuery 	+= " AND E1_VENCREA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "'"
		Case x == 2
			d1	:= FirstDay( (CtoD("15/" + SubStr(mv_par01, 1, 2) + "/" + SubStr(mv_par01, 3, 4) )) - 30) //Mes Passado
			cQuery += " AND E1_VENCREA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(LastDay(d1)) + "'"
		Case x == 3
			d1	:= FirstDay( (CtoD("15/" + SubStr(mv_par01, 1, 2) + "/" + SubStr(mv_par01, 3, 4) )) - 365) //Ano Passado
			cQuery += " AND E1_VENCREA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(LastDay(d1)) + "'"
	EndCase

	cQuery += " GROUP BY A1_EST "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TMP"
	//TCSetField( "TMP", "QPK_DTPROD", "D")

	TMP->( DbGoTop() )
			
	While !oReport:Cancel() .And. TMP->(!EOF())

		IF !XTS->(dbseek(TMP->A1_EST))
				
			RecLock("XTS", .T.)
						
			XTS->EST		:= TMP->A1_EST
				
			Do Case
				Case x == 1
					XTS->PREVATU	:= TMP->DENTRO
				Case x == 2
					XTS->PREVMA		:= TMP->DENTRO	
				Case x == 3
					XTS->PREVAA		:= TMP->DENTRO
			EndCase

			XTS->REALATU	:= 0	
			XTS->REALMA		:= 0	
			XTS->REALAA		:= 0	

			Do Case
				Case x == 1
					XTS->PREVATX	:= TMP->FORA	
				Case x == 2
					XTS->PREVMAX	:= TMP->FORA	
				Case x == 3
					XTS->PREVAAX	:= TMP->FORA	
			EndCase

			XTS->REALATX	:= 0	
			XTS->REALMAX	:= 0	
			XTS->REALAAX	:= 0	
			
			MsUnlock()
			
		Else
			
			RecLock("XTS", .F.)
					
			Do Case
				Case x == 1
					XTS->PREVATU	+= TMP->DENTRO
				Case x == 2
					XTS->PREVMA		+= TMP->DENTRO	
				Case x == 3
					XTS->PREVAA		+= TMP->DENTRO
			EndCase

			Do Case
				Case x == 1
					XTS->PREVATX	+= TMP->FORA	
				Case x == 2
					XTS->PREVMAX	+= TMP->FORA	
				Case x == 3
					XTS->PREVAAX	+= TMP->FORA	
			EndCase

			MsUnlock()
			
		EndIf

		TMP->(dbSkip())

	EndDo

Next

d1			:= IIF(lJob,FirstDay(dDataBase),CtoD("01/" + SubStr(mv_par01, 1, 2) + "/" + SubStr(mv_par01, 3, 4) ))

For x := 1 To 3

	dbSelectArea("XTS")
	XTS->(dbGoTop())
	
	While XTS->(!EOF())
	
		Do Case
		
			Case x == 1
				aValor	:= fNaoPg(XTS->EST, d1, d2)
			Case x == 2
				d1	:= FirstDay( (CtoD("15/" + SubStr(mv_par01, 1, 2) + "/" + SubStr(mv_par01, 3, 4) )) - 30) //Mes Passado
				aValor	:= fNaoPg(XTS->EST, d1, LastDay(d1))
			Case x == 3
				d1	:= FirstDay( (CtoD("15/" + SubStr(mv_par01, 1, 2) + "/" + SubStr(mv_par01, 3, 4) )) - 365) //Ano Passado
				aValor	:= fNaoPg(XTS->EST, d1, LastDay(d1))
		EndCase

		RecLock("XTS", .F.)
				
		Do Case
			Case x == 1
				XTS->REALATU	+= aValor[1]
			Case x == 2
				XTS->REALMA		+= aValor[1]	
			Case x == 3
				XTS->REALAA		+= aValor[1]
		EndCase

		Do Case
			Case x == 1
				XTS->REALATX	+= aValor[2]	
			Case x == 2
				XTS->REALMAX	+= aValor[2]	
			Case x == 3
				XTS->REALAAX	+= aValor[2]	
		EndCase

		MsUnlock()
	
		XTS->(dbSkip())
	EndDo
Next
//***************************************************
//RECEBIDO ATUAL, MES ANTERIOR E ANO ANTERIOR	
//***************************************************
/*
For x := 1 To 3

	cQuery := " SELECT A1_EST, " 
	cQuery += " SUM( CASE WHEN E5_PREFIXO = '0' THEN E5_VALOR ELSE 0 END ) DENTRO, " 
	cQuery += " SUM( CASE WHEN E5_PREFIXO = '' THEN E5_VALOR ELSE 0 END ) FORA "
	cQuery += " FROM " + RetSqlName("SE5") + " A "
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
	cQuery += " ON E5_CLIENTE = A1_COD "
	cQuery += " AND E5_LOJA = A1_LOJA "
	cQuery += " WHERE A.D_E_L_E_T_ <> '*' "
	cQuery += " AND E5_FILIAL = '" + xFilial("SE5") + "' "
	
	Do Case
	
		Case x == 1
			cQuery 	+= " AND E5_DATA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "'"
		Case x == 2
			d1	:= FirstDay( (CtoD("15/" + SubStr(mv_par01, 1, 2) + "/" + SubStr(mv_par01, 3, 4) )) - 30) //Mes Passado
			cQuery += " AND E5_DATA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(LastDay(d1)) + "'"
		Case x == 3
			d1	:= FirstDay( (CtoD("15/" + SubStr(mv_par01, 1, 2) + "/" + SubStr(mv_par01, 3, 4) )) - 365) //Ano Passado
			cQuery += " AND E5_DATA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(LastDay(d1)) + "'"
	EndCase

	cQuery += " AND E5_TIPO NOT IN ('NCC','RA') "
	cQuery += " AND E5_TIPODOC NOT IN ('CP','DC') "
	cQuery += " AND E5_MOTBX NOT IN ('DAC','LIQ') "
	cQuery += " AND E5_RECPAG = 'R' "
	cQuery += " AND A1_SATIV1 <> '000009' "
	cQuery += " AND E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIENTE + E5_LOJA + E5_SEQ NOT IN ( "
	cQuery += " SELECT E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIENTE + E5_LOJA + E5_SEQ FROM  SE5020 B " 
	cQuery += " WHERE D_E_L_E_T_ <> '*' " 
	cQuery += " AND B.E5_FILIAL = A.E5_FILIAL " 
	cQuery += " AND B.E5_PREFIXO = A.E5_PREFIXO "
	cQuery += " AND B.E5_NUMERO =  A.E5_NUMERO "
	cQuery += " AND B.E5_PARCELA =  A.E5_PARCELA "
	cQuery += " AND B.E5_TIPO =  A.E5_TIPO "
	cQuery += " AND B.E5_CLIENTE = A.E5_CLIENTE "
	cQuery += " AND B.E5_LOJA = A.E5_LOJA "
	cQuery += " AND B.E5_SEQ = A.E5_SEQ " 
	cQuery += " AND B.E5_RECPAG = 'P' ) "
	cQuery += " GROUP BY A1_EST "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TMP"
	//TCSetField( "TMP", "QPK_DTPROD", "D")

	TMP->( DbGoTop() )
			
	While !oReport:Cancel() .And. TMP->(!EOF())

		IF !XTS->(dbseek(TMP->A1_EST))
				
			RecLock("XTS", .T.)
						
			XTS->EST		:= TMP->A1_EST
				
			Do Case
				Case x == 1
					XTS->REALATU	:= TMP->DENTRO
				Case x == 2
					XTS->REALMA		:= TMP->DENTRO	
				Case x == 3
					XTS->REALAA		:= TMP->DENTRO
			EndCase

			Do Case
				Case x == 1
					XTS->REALATX	:= TMP->FORA	
				Case x == 2
					XTS->REALMAX	:= TMP->FORA	
				Case x == 3
					XTS->REALAAX	:= TMP->FORA	
			EndCase

			MsUnlock()
			
		Else
			
			RecLock("XTS", .F.)
					
			Do Case
				Case x == 1
					XTS->REALATU	+= TMP->DENTRO
				Case x == 2
					XTS->REALMA		+= TMP->DENTRO	
				Case x == 3
					XTS->REALAA		+= TMP->DENTRO
			EndCase

			Do Case
				Case x == 1
					XTS->REALATX	+= TMP->FORA	
				Case x == 2
					XTS->REALMAX	+= TMP->FORA	
				Case x == 3
					XTS->REALAAX	+= TMP->FORA	
			EndCase

			MsUnlock()
			
		EndIf

		TMP->(dbSkip())

	EndDo

Next
*/

d1			:= IIF(lJob,FirstDay(dDataBase),CtoD("01/" + SubStr(mv_par01, 1, 2) + "/" + SubStr(mv_par01, 3, 4) ))
//***************************************************
//RECEBIMENTO ANTECIPADO ATUAL, MES ANTERIOR E ANO ANTERIOR	
//***************************************************
For x := 1 To 3

	cQuery := " SELECT A1_EST, " 
	cQuery += " SUM( CASE WHEN E5_PREFIXO = '0' THEN E5_VALOR ELSE 0 END ) DENTRO, " 
	cQuery += " SUM( CASE WHEN E5_PREFIXO = '' THEN E5_VALOR ELSE 0 END ) FORA "
	cQuery += " FROM " + RetSqlName("SE5") + " A "
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
	cQuery += " ON E5_CLIENTE = A1_COD "
	cQuery += " AND E5_LOJA = A1_LOJA "
	cQuery += " WHERE A.D_E_L_E_T_ <> '*' "
	cQuery += " AND E5_FILIAL = '" + xFilial("SE5") + "' "
	
	Do Case
	
		Case x == 1
			cQuery 	+= " AND E5_DATA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "'"
		Case x == 2
			d1	:= FirstDay( (CtoD("15/" + SubStr(mv_par01, 1, 2) + "/" + SubStr(mv_par01, 3, 4) )) - 30) //Mes Passado
			cQuery += " AND E5_DATA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(LastDay(d1)) + "'"
		Case x == 3
			d1	:= FirstDay( (CtoD("15/" + SubStr(mv_par01, 1, 2) + "/" + SubStr(mv_par01, 3, 4) )) - 365) //Ano Passado
			cQuery += " AND E5_DATA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(LastDay(d1)) + "'"
	EndCase

	cQuery += " AND E5_TIPO = 'RA' "
	cQuery += " AND E5_MOTBX = 'NOR' "
	cQuery += " AND E5_RECPAG = 'R' "
	cQuery += " AND A1_SATIV1 <> '000009' "
	cQuery += " AND E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIENTE + E5_LOJA + E5_SEQ NOT IN ( "
	cQuery += " SELECT E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIENTE + E5_LOJA + E5_SEQ FROM  SE5020 B " 
	cQuery += " WHERE D_E_L_E_T_ <> '*' " 
	cQuery += " AND B.E5_FILIAL = A.E5_FILIAL " 
	cQuery += " AND B.E5_PREFIXO = A.E5_PREFIXO "
	cQuery += " AND B.E5_NUMERO =  A.E5_NUMERO "
	cQuery += " AND B.E5_PARCELA =  A.E5_PARCELA "
	cQuery += " AND B.E5_TIPO =  A.E5_TIPO "
	cQuery += " AND B.E5_CLIENTE = A.E5_CLIENTE "
	cQuery += " AND B.E5_LOJA = A.E5_LOJA "
	cQuery += " AND B.E5_SEQ = A.E5_SEQ " 
	cQuery += " AND B.E5_RECPAG = 'P' ) "
	cQuery += " GROUP BY A1_EST "

	If Select("TMP") > 0
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TMP"
	//TCSetField( "TMP", "QPK_DTPROD", "D")

	TMP->( DbGoTop() )
			
	While !oReport:Cancel() .And. TMP->(!EOF())

		IF !XTS->(dbseek(TMP->A1_EST))
				
			RecLock("XTS", .T.)
						
			XTS->EST		:= TMP->A1_EST
				
			Do Case
				Case x == 1
					XTS->REALATU	:= TMP->DENTRO
				Case x == 2
					XTS->REALMA		:= TMP->DENTRO	
				Case x == 3
					XTS->REALAA		:= TMP->DENTRO
			EndCase

			Do Case
				Case x == 1
					XTS->REALATX	:= TMP->FORA	
				Case x == 2
					XTS->REALMAX	:= TMP->FORA	
				Case x == 3
					XTS->REALAAX	:= TMP->FORA	
			EndCase

			MsUnlock()
			
		Else
			
			RecLock("XTS", .F.)
					
			Do Case
				Case x == 1
					XTS->REALATU	+= TMP->DENTRO
				Case x == 2
					XTS->REALMA		+= TMP->DENTRO	
				Case x == 3
					XTS->REALAA		+= TMP->DENTRO
			EndCase

			Do Case
				Case x == 1
					XTS->REALATX	+= TMP->FORA	
				Case x == 2
					XTS->REALMAX	+= TMP->FORA	
				Case x == 3
					XTS->REALAAX	+= TMP->FORA	
			EndCase

			MsUnlock()
			
		EndIf

		TMP->(dbSkip())

	EndDo

Next

dbSelectArea("XTS")
XTS->(dbGoTop())

oReport:IncMeter()
oSection1:Init()

While !oReport:Cancel() .And. XTS->(!EOF())
		
	nTRAtu		:= nTRAtu + XTS->REALATU
	nTPAtu		:= nTPAtu + XTS->PREVATU
	nTRXDD		:= nTRXDD + XTS->REALATX
	nTPXDD		:= nTPXDD + XTS->PREVATX

	nTRAtuMA	:= nTRAtu + XTS->REALMA
	nTPAtuMA	:= nTPAtu + XTS->PREVMA
	nTRXDDMA	:= nTRXDD + XTS->REALMAX
	nTPXDDMA	:= nTPXDD + XTS->PREVMAX

	nTRAtuAA	:= nTRAtu + XTS->REALAA
	nTPAtuAA	:= nTPAtu + XTS->PREVAA
	nTRXDDAA	:= nTRXDD + XTS->REALAAX
	nTPXDDAA	:= nTPXDD + XTS->PREVAAX

	oSection1:Cell("FILIAL"):SetValue("01")
	oSection1:Cell("FILIAL"):SetAlign("CENTER")
	oSection1:Cell("EST"):SetValue(XTS->EST)
	oSection1:Cell("EST"):SetAlign("CENTER")
	oSection1:Cell("PREVATU"):SetValue(XTS->PREVATU)
	oSection1:Cell("PREVATU"):SetAlign("RIGHT")
	oSection1:Cell("REALATU"):SetValue(XTS->REALATU)
	oSection1:Cell("REALATU"):SetAlign("RIGHT")
	
//	nPerc1	:= ((XTS->REALATU - XTS->PREVATU) / XTS->PREVATU) * 100
	nPerc1	:= ((XTS->REALATU) / XTS->PREVATU) * 100
	oSection1:Cell("PERCATU"):SetValue(nPerc1)
	oSection1:Cell("PERCATU"):SetAlign("RIGHT")
	
	//nPerc2	:= ((XTS->REALMA - XTS->PREVMA) / XTS->PREVMA) * 100
	nPerc2	:= ((XTS->REALMA) / XTS->PREVMA) * 100
	oSection1:Cell("PERCMA"):SetValue(nPerc2)
	oSection1:Cell("PERCMA"):SetAlign("RIGHT")
	
	//nPerc3	:= ((XTS->REALAA - XTS->PREVAA) / XTS->PREVAA) * 100
	nPerc3	:= ((XTS->REALAA) / XTS->PREVAA) * 100
	oSection1:Cell("PERCAA"):SetValue(nPerc3)
	oSection1:Cell("PERCAA"):SetAlign("RIGHT")

	oSection1:Cell("PREVATX"):SetValue(XTS->PREVATX)
	oSection1:Cell("PREVATX"):SetAlign("RIGHT")
	oSection1:Cell("REALATX"):SetValue(XTS->REALATX)
	oSection1:Cell("REALATX"):SetAlign("RIGHT")
	
	//nPerc1	:= ((XTS->REALATX - XTS->PREVATX) / XTS->PREVATX) * 100
	nPerc1	:= ((XTS->REALATX) / XTS->PREVATX) * 100
	oSection1:Cell("PERCATX"):SetValue(nPerc1)
	oSection1:Cell("PERCATX"):SetAlign("RIGHT")
	
	//nPerc2	:= ((XTS->REALMAX - XTS->PREVMAX) / XTS->PREVMAX) * 100
	nPerc2	:= ((XTS->REALMAX) / XTS->PREVMAX) * 100
	oSection1:Cell("PERCMAX"):SetValue(nPerc2)
	oSection1:Cell("PERCMAX"):SetAlign("RIGHT")
	
	//nPerc3	:= ((XTS->REALAAX - XTS->PREVAAX) / XTS->PREVAAX) * 100
	nPerc3	:= ((XTS->REALAAX) / XTS->PREVAAX) * 100
	oSection1:Cell("PERCAAX"):SetValue(nPerc3)
	oSection1:Cell("PERCAAX"):SetAlign("RIGHT")

	oSection1:Cell("PREVATT"):SetValue(XTS->PREVATU + XTS->PREVATX)
	oSection1:Cell("PREVATT"):SetAlign("RIGHT")
	oSection1:Cell("REALATT"):SetValue(XTS->REALATU + XTS->REALATX)
	oSection1:Cell("REALATT"):SetAlign("RIGHT")
	
	//nPerc1	:= (((XTS->REALATU + XTS->REALATX) - (XTS->PREVATU + XTS->PREVATX)) / (XTS->PREVATU + XTS->PREVATX)) * 100
	nPerc1	:= (((XTS->REALATU + XTS->REALATX)) / (XTS->PREVATU + XTS->PREVATX)) * 100
	oSection1:Cell("PERCATT"):SetValue(nPerc1)
	oSection1:Cell("PERCATT"):SetAlign("RIGHT")
	
	//nPerc2	:= (((XTS->REALMA + XTS->REALMAX) - (XTS->PREVMA + XTS->PREVMAX)) / (XTS->PREVMA + XTS->PREVMAX)) * 100
	nPerc2	:= (((XTS->REALMA + XTS->REALMAX)) / (XTS->PREVMA + XTS->PREVMAX)) * 100
	oSection1:Cell("PERCMAT"):SetValue(nPerc2)
	oSection1:Cell("PERCMAT"):SetAlign("RIGHT")
	
	//nPerc3	:= (((XTS->REALAA + XTS->REALAAX) - (XTS->PREVAA + XTS->PREVAAX)) / (XTS->PREVAA + XTS->PREVAAX)) * 100
	nPerc3	:= (((XTS->REALAA + XTS->REALAAX)) / (XTS->PREVAA + XTS->PREVAAX)) * 100
	oSection1:Cell("PERCAAT"):SetValue(nPerc3)
	oSection1:Cell("PERCAAT"):SetAlign("RIGHT")

	oSection1:PrintLine()

	XTS->(dbSkip())
	
EndDo

oSection1:Finish()

/*
oReport:Say(oReport:Row()-1,700, Transform(((nTRAtu - nTPAtu) / nTPAtu)*100, "@E 99,999.99") )
oReport:Say(oReport:Row()-1,870, Transform(((nTRAtuMA - nTPAtuMA) / nTPAtuMA)*100, "@E 99,999.99") )
oReport:Say(oReport:Row()-1,1040, Transform(((nTRAtuAA - nTPAtuAA) / nTPAtuAA)*100, "@E 99,999.99") )

oReport:Say(oReport:Row()-1,1770, Transform(((nTRXDD - nTPXDD) / nTPXDD)*100, "@E 99,999.99") )
oReport:Say(oReport:Row()-1,1950, Transform(((nTRXDDMA - nTPXDDMA) / nTPXDDMA)*100, "@E 99,999.99") )
oReport:Say(oReport:Row()-1,2120, Transform(((nTRXDDAA - nTPXDDAA) / nTPXDDAA)*100, "@E 99,999.99") )

oReport:Say(oReport:Row()-1,2840, Transform((((nTRAtu + nTRXDD) - (nTPAtu + nTPXDD)) / (nTPAtu + nTPXDD))*100, "@E 99,999.99") )
oReport:Say(oReport:Row()-1,3020, Transform((((nTRAtuMA + nTRXDDMA) - (nTPAtuMA + nTPXDDMA)) / (nTPAtuMA + nTPXDDMA))*100, "@E 99,999.99") )
oReport:Say(oReport:Row()-1,3200, Transform((((nTRAtuAA + nTRXDDAA) - (nTPAtuAA + nTPXDDAA)) / (nTPAtuAA + nTPXDDAA))*100, "@E 99,999.99") )
*/

oReport:Say(oReport:Row()-1,700, Transform(((nTRAtu) / nTPAtu)*100, "@E 99,999.99") )
oReport:Say(oReport:Row()-1,870, Transform(((nTRAtuMA) / nTPAtuMA)*100, "@E 99,999.99") )
oReport:Say(oReport:Row()-1,1040, Transform(((nTRAtuAA) / nTPAtuAA)*100, "@E 99,999.99") )

oReport:Say(oReport:Row()-1,1770, Transform(((nTRXDD) / nTPXDD)*100, "@E 99,999.99") )
oReport:Say(oReport:Row()-1,1950, Transform(((nTRXDDMA) / nTPXDDMA)*100, "@E 99,999.99") )
oReport:Say(oReport:Row()-1,2120, Transform(((nTRXDDAA) / nTPXDDAA)*100, "@E 99,999.99") )

oReport:Say(oReport:Row()-1,2840, Transform((((nTRAtu + nTRXDD)) / (nTPAtu + nTPXDD))*100, "@E 99,999.99") )
oReport:Say(oReport:Row()-1,3020, Transform((((nTRAtuMA + nTRXDDMA)) / (nTPAtuMA + nTPXDDMA))*100, "@E 99,999.99") )
oReport:Say(oReport:Row()-1,3200, Transform((((nTRAtuAA + nTRXDDAA)) / (nTPAtuAA + nTPXDDAA))*100, "@E 99,999.99") )

Set Filter To

Return

//------------------------------------------------------------------------------------------
/*
Calcula o valor em aberto dos titulos por estado em um determinado periodo.

@author    Gustavo Costa
@version   1.xx
@since     05/02/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fNaoPg(cEst, d1, d2)	

Local nTotal	:= 0
Local cQuery	:= ""
Local nTotal	:= 0
Local nTotalX	:= 0


cQuery := " SELECT E1.*, A1_EST FROM " + RetSqlName("SE1") + " E1 " 
cQuery += " INNER JOIN SA1010 A1 "
cQuery += " ON E1_CLIENTE = A1_COD " 
cQuery += " AND E1_LOJA = A1_LOJA "
cQuery += " WHERE E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E1_FILIAL = '01' "
cQuery += " AND E1_SATIV1 <> '000009' "
cQuery += " AND A1_EST = '" + cEst + "' "
cQuery += " AND E1_VENCREA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "' "
cQuery += " ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA "

If Select("PUB") > 0
	DbSelectArea("PUB")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "PUB"
dbselectArea("PUB")
dbGoTop("PUB")

While PUB->(!EOF())
		
	nSaldo := 0
	dbSelectArea("SE1")
	dbSetOrder(1)
	SE1->(dbSeek(PUB->E1_FILIAL + PUB->E1_PREFIXO + PUB->E1_NUM + PUB->E1_PARCELA + PUB->E1_TIPO))
	//Verifica se foi baixado
	nSaldo := SaldoTit(PUB->E1_PREFIXO,PUB->E1_NUM,PUB->E1_PARCELA,PUB->E1_TIPO,PUB->E1_NATUREZ,"R",;
							 PUB->E1_CLIENTE,1,StoD(PUB->E1_VENCREA),d2,PUB->E1_LOJA,PUB->E1_FILIAL,,1)
	
	If nSaldo > 0
		If Alltrim(PUB->E1_PREFIXO) == '0'
			nTotal 	:= nTotal + nSaldo
		Else
			nTotalX := nTotalX + nSaldo
		EndIf
	EndIf

	dbSelectArea("PUB")
	PUB->(dbSkip())
		
EndDo
	
dbCloseArea("PUB")
	
Return {nTotal,nTotalX}

