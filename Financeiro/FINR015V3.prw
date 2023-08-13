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
±±³Programa  ³FINR015  ³ Autor ³ Gustavo Costa          ³ Data ³23.05.2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o   ³Relatorio para gerar retorno da cobrança em valor e juros  .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FINR0153()

Local oReport
Local cPerg	:= "FINR15"

Private lJob		:= .F.
Private aMeses	:= {}
Private aMesesAnt	:= {}
PRIVATE aCampos	:= {}
Private nAtend	:= 0
Private nDiasUt	:= 0
Private dPriDia
Private dUltDia

//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//Não consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SX1" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Relatorio retorno da cobrança... '+Dtoc(DATE())+' - '+Time())
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
		Pergunte(cPerg, .T.)
		
		oReport:= ReportDef()
		oReport:PrintDialog()
	EndIf

	If	( lJob )
		RpcClearEnv()		   				//Libera o Environment
		ConOut('Relatorio retorno da cobrança. '+Dtoc(DATE())+' - '+Time())
	EndIf


Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data de?'     	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data até?'  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
putSx1(cPerg, '03', 'Relatório?'     	, '', '', 'mv_ch3', 'N', 1                     	, 0, 0, 'C', '', ''	 , '', '', 'mv_par03','Sintetico','','','','Analitico','','','','','','','','','','','',{"Escolha uma opcao"},{},{})
//putSx1(cPerg, '04', 'Meta Mês?'   		, '', '', 'mv_ch4', 'N', 12                     	, 2, 0, 'G', '', ''	 , '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Informe o valor da meta mês."},{},{})
//putSx1(cPerg, '03', 'Do Recurso?'     	, '', '', 'mv_ch3', 'C', 9                     	, 0, 0, 'G', '', 'SH1', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Recurso inicial"},{},{})
//putSx1(cPerg, '04', 'Até Recurso?'    	, '', '', 'mv_ch4', 'C', 9                     	, 0, 0, 'G', '', 'SH1', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Recurso final"},{},{})

return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FINR013  ³ Autor ³ Gustavo Costa          ³ Data ³23.05.2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio retorno da cobrança.                               .³±±
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

oReport:= TReport():New("FINR153","Acompanhamento do Retorno Fin. Cobrança","FINR15", {|oReport| ReportPrint(oReport)},"Este relatório irá listar os valores e juros recebidos pela cobrança.")
oReport:SetLandscape()
oReport:SetTotalInLine(.T.)
oReport:PageTotalInLine(.T.)
//oReport:SetPortrait()

If lJob
	oReport:nDevice	 	:= 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
	oReport:cEmail		:= GetNewPar("MV_XFINR15",'marcelo@ravaembalagens.com.br;financeiro@ravaembalagens.com.br;gustavo@ravaembalagens.com.br')
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

dPriDia	:= FirstDay(mv_par01)
dUltDia	:= LastDay(mv_par02)

While dPriDia <= dUltDia

	If dPriDia == DataValida(dPriDia)
	
		nDiasUt += 1

	EndIf
	
	dPriDia += 1
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 1                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1 := TRSection():New(oReport,"Data",{"XTS"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/,/*uTotalText*/,.T.) 
//oParent,cTitle,uTable,aOrder,lLoadCells,lLoadOrder,uTotalText,lTotalInLine,lHeaderPage,lHeaderBreak,lPageBreak,lLineBreak,nLeftMargin,lLineStyle,nColSpace,lAutoSize,cCharSeparator,nLinesBefore,nCols,nClrBack,nClrFore,nPercentage

TRCell():New(oSection1,'_FILIAL','','Filial'	,/*Picture*/	,02		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'_DDATA'	,'','Data'		,/*Picture*/	,14		,/*lPixel*/,/*{|| code-block de impressao }*/)
//aADD(aCampos,{"_FILIAL"	 			,"C",02,0})
aADD(aCampos,{"_DDATA"	 			,"C",10,0})

cQuery := " SELECT * FROM " + RetSqlName("SX5") + " X5 "
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND X5_TABELA = '80' "

If Select("XTM") > 0
	DbSelectArea("XTM")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XTM"

XTM->( DbGoTop() )
		
oBreak := TRBreak():New(oSection1,oSection1:Cell("_FILIAL"),"Total",.F.)

While XTM->(!EOF())

	nAtend	+= 1
	TRCell():New(oSection1,'_VAL' + Alltrim(XTM->X5_CHAVE) ,'', Alltrim(XTM->X5_DESCRI) , "@E 9,999,999,999.99" ,16	,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'_JUR' + Alltrim(XTM->X5_CHAVE) ,'', 'Juros Rec.'/* + SubStr(XTM->X5_DESCRI)*/ , "@E 9,999,999,999.99" ,16	,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'_PER' + Alltrim(XTM->X5_CHAVE) ,'', 'Percentual Atu. ' /* + Alltrim(XTM->X5_DESCRI)*/ , "@E 9,999,999,999.99" ,16	,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'_MET' + Alltrim(XTM->X5_CHAVE) ,'', 'Total Recebivel ' /* + Alltrim(XTM->X5_DESCRI)*/ , "@E 9,999,999,999.99" ,16,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'_SAI' + Alltrim(XTM->X5_CHAVE) ,'', 'Saiu Global ' /* + Alltrim(XTM->X5_DESCRI)*/ , "@E 9,999,999,999.99" ,16,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'_ENT' + Alltrim(XTM->X5_CHAVE) ,'', 'Entrou ' /* + Alltrim(XTM->X5_DESCRI)*/ , "@E 9,999,999,999.99" ,16,/*lPixel*/,/*{|| code-block de impressao }*/)

	TRFunction():New(oSection1:Cell('_VAL' + Alltrim(XTM->X5_CHAVE)),NIL,"SUM",oBreak,"Total Valor " + Alltrim(XTM->X5_DESCRI),/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
	TRFunction():New(oSection1:Cell('_JUR' + Alltrim(XTM->X5_CHAVE)),NIL,"SUM",oBreak,"Total Juros " + Alltrim(XTM->X5_DESCRI),/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
	//TRFunction():New(oSection1:Cell('_PER' + Alltrim(XTM->X5_CHAVE)),NIL,"AVERAGE",oBreak,"% " + Alltrim(XTM->X5_DESCRI),/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
	//TRFunction():New(oSection1:Cell('_MET' + Alltrim(XTM->X5_CHAVE)),NIL,"AVERAGE",oBreak,"Meta " + Alltrim(XTM->X5_DESCRI),/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
	TRFunction():New(oSection1:Cell('_SAI' + Alltrim(XTM->X5_CHAVE)),NIL,"SUM",oBreak,"Meta " + Alltrim(XTM->X5_DESCRI),/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
	TRFunction():New(oSection1:Cell('_ENT' + Alltrim(XTM->X5_CHAVE)),NIL,"SUM",oBreak,"Meta " + Alltrim(XTM->X5_DESCRI),/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)

	aADD(aCampos,{"_VAL" + Alltrim(XTM->X5_CHAVE)		,"N",16,2})
	aADD(aCampos,{"_JUR" + Alltrim(XTM->X5_CHAVE)		,"N",16,2})
	aADD(aCampos,{"_PER" + Alltrim(XTM->X5_CHAVE)		,"N",16,2})
	aADD(aCampos,{"_MET" + Alltrim(XTM->X5_CHAVE)		,"N",16,2})
	aADD(aCampos,{"_SAI" + Alltrim(XTM->X5_CHAVE)		,"N",16,2})
	aADD(aCampos,{"_ENT" + Alltrim(XTM->X5_CHAVE)		,"N",16,2})
	
	XTM->(dbSkip())

EndDo

cNomeArq := CriaTrab(aCampos,.T.)
dbUseArea( .T.,, cNomeArq, "XTS", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("XTS",cNomeArq,"_DDATA",,,OemToAnsi("Selecionando Registros..."))  //

oReport:EndReport() := .T.

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PONR003 ³ Autor ³ Gustavo Costa           ³ Data ³20.06.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos    ³±±
±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local aMeta   	:= {}
Local nMetaA1   	:= 0
Local nMetaDiaA1 	:= 0
Local nMetaA2   	:= 0
Local nMetaDiaA2 	:= 0
Local nMetaX   	:= 0
Local nMetaG   	:= 0
Local nValTot   	:= 0
Local nJurTot   	:= 0
Local nTotalA1	:= 0
Local nTotalA2	:= 0
Local nTotalAG	:= 0
Local _nPos		:= 0
Local lContinua 	:= .T.
Local d1			:= IIF(lJob,FirstDay(dDataBase),mv_par01)
Local d2			:= IIF(lJob,dDataBase-1,mv_par02)

Local aAtend		:= {}
Local aTotAten	:= {}
Local aValores	:= {}
Local aDiasA1		:= {}
Local aDiasA2		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//oReport:Say(oReport:Row(),oReport:Col(),"PERÍODO de " + DtoC(mv_par01) + " até " + DtoC(mv_par02) )
oReport:SkipLine()
oReport:ThinLine()
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"DEMONSTRAÇÃO DE RESULTADO")
oReport:SkipLine()
oReport:ThinLine()

cQuery := " SELECT E5_FILIAL, E5_DATA, E1_VENCREA, E5_VALOR, E5_VLJUROS, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIENTE, E5_LOJA, A1_EST, E5_SEQ, A1_SATIV1 "
cQuery += " FROM " + RetSqlName("SE5") + " E5 "
cQuery += " INNER JOIN " + RetSqlName("SE1") + " E1 "
cQuery += " ON E5_FILIAL = E1_FILIAL "
cQuery += " AND E5_PREFIXO = E1_PREFIXO "
cQuery += " AND E5_NUMERO = E1_NUM "
cQuery += " AND E5_PARCELA = E1_PARCELA "
cQuery += " AND E5_TIPO = E1_TIPO "
cQuery += " AND E5_CLIENTE = E1_CLIENTE "
cQuery += " AND E5_LOJA = E1_LOJA "
cQuery += " INNER JOIN SA1010 "
cQuery += " ON E5_CLIENTE = A1_COD "
cQuery += " AND E5_LOJA = A1_LOJA "
cQuery += " WHERE E5.D_E_L_E_T_ <> '*' "
cQuery += " AND E1.D_E_L_E_T_ <> '*' "
//cQuery += " AND E5_FILIAL = '" + xFilial("SE5") + "' "
//cQuery += " AND E1_FILIAL = '" + xFilial("SE1") + "' "
cQuery += " AND A1_SATIV1 <> '000009' "
cQuery += " AND E5_RECPAG = 'R' "
cQuery += " AND E5_DATA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "' "
cQuery += " AND E1_VENCREA < E5_DATA "
cQuery += " AND E1_TIPO NOT IN ('NCC','RA') "
cQuery += " AND E5_TIPODOC NOT IN ('JR','DC','CP','MT','XX') "
cQuery += " AND E5_MOTBX NOT IN ('DAC') "
cQuery += " AND E1_PORTADO <> 'COB' "
cQuery += " AND E1_PREFIXO <> '' "
//cQuery += " AND CONVERT(DATETIME,E5_DATA, 103) - CONVERT(DATETIME,E1_VENCREA, 103) <= 30 "
cQuery += " ORDER BY E5_DATA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_CLIENTE, E5_LOJA "

If Select("XTT") > 0
	DbSelectArea("XTT")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XTT"
TCSetField( 'XTT', "E5_DATA", "D", 8, 0 )
TCSetField( 'XTT', "E1_VENCREA", "D", 8, 0 )

XTT->( DbGoTop() )
		
While !oReport:Cancel() .And. XTT->(!EOF())

	lEstorno := fEstorno( XTT->E5_FILIAL, XTT->E5_PREFIXO, XTT->E5_NUMERO, XTT->E5_PARCELA, XTT->E5_TIPO, XTT->E5_CLIENTE, XTT->E5_LOJA, XTT->E5_SEQ )
	
	If lEstorno
	
		XTT->(dbSkip())
		loop
	
	EndIf
	
//	aAtend	:= fAtendente( XTT->E5_FILIAL, XTT->E5_CLIENTE, XTT->E5_LOJA, XTT->E1_VENCREA, XTT->E5_DATA)
	IF Alltrim(XTT->E5_PREFIXO) == "0"
		aAtend	:= f2Atendente( XTT->E5_FILIAL, XTT->E5_CLIENTE, XTT->E5_LOJA, XTT->E1_VENCREA, XTT->E5_DATA )
	Else
		AADD(aAtend, "000331") 
		AADD(aAtend, "Solange Mota") 
	EndIf
	
	AADD(aValores, { aAtend[1], aAtend[2], XTT->E5_DATA, XTT->E5_VALOR, XTT->E5_VLJUROS, XTT->E5_FILIAL, XTT->E5_DATA - XTT->E1_VENCREA, XTT->E5_PREFIXO, XTT->E1_VENCREA } )
	aAtend	:= {}
	
	XTT->(dbSkip())
	
EndDo
/*
dbSelectArea("ZB6")
dbSeek(Xfilial("ZB6") + DtoS(FirstDay(d1)) )

For x := 1 To Len(aValores)
	
	If AllTrim(aValores[x][1]) == '000331' //SOLANGE
		nTotalA1	:= nTotalA1 + aValores[x][4]
		If aScan(aDiasA1,aValores[x][3]) = 0
			AADD(aDiasA1, aValores[x][3])
		EndIf
	ElseIf AllTrim(aValores[x][1]) == '000445' //GLAUCIA
		nTotalA2	:= nTotalA2 + aValores[x][4]
		If aScan(aDiasA2,aValores[x][3]) = 0
			AADD(aDiasA2, aValores[x][3])
		EndIf
	EndIf

Next
*/
/*
aMeta		:= fMeta( d1, d2 )

nMetaA1	:=  aMeta[1] 
nMetaDiaA1	:= nMetaA1 / Len(aDiasA1) 

nMetaA2	:=  aMeta[2] 
nMetaDiaA2	:= nMetaA2 / Len(aDiasA2) 

nMetaX		:=  aMeta[3] 
*/
For x := 1 To Len(aValores)

	cCpVal	:= 'XTS->_VAL'+ AllTrim(aValores[x][1])
	cCpJur	:= 'XTS->_JUR'+ AllTrim(aValores[x][1])
//	cCpMet	:= 'XTS->_MET'+ AllTrim(aValores[x][1])

	//Valores por dentro pago com até 30 dias
	If aValores[x][7] <= 30 // se for até 30 dias de recebido. //mv_par03 = 1 // Sintetico

		IF !XTS->(dbseek(DtoC(aValores[x][3])))
		
			//Nao grava os que foram recebidos em atraso sem cobrança.
			If !Empty(aValores[x][1])
		
				RecLock("XTS", .T.)
				
				//XTS->_FILIAL	:= aValores[x][6]
				XTS->_DDATA	:= DtoC(aValores[x][3])
				&cCpVal 		:= aValores[x][4]	
				&cCpJur 		:= aValores[x][5]	
				/*
				If AllTrim(aValores[x][1]) == '000331'
					&cCpMet 		:= nMetaDiaA1	
				ElseIf AllTrim(aValores[x][1]) == '000445'
					&cCpMet 		:= nMetaDiaA2	
				EndIf
				*/
				MsUnlock()
			
			EndIf
		
		Else
			//Nao grava os que foram recebidos em atraso sem cobrança.
			If !Empty(aValores[x][1])
				RecLock("XTS", .F.)
				
				//XTS->DDATA		:= aValores[x][3]
				&cCpVal 		+= aValores[x][4]	
				&cCpJur 		+= aValores[x][5]	
				/*
			If AllTrim(aValores[x][1]) == '000331'
				&cCpMet 		:= nMetaDiaA1	
			ElseIf AllTrim(aValores[x][1]) == '000445'
				&cCpMet 		:= nMetaDiaA2	
			EndIf
			*/
				MsUnlock()
			EndIf
		EndIf
	
	Else //Valores XDD independente que quantos dias de vencido, ou publico
		
		IF !XTS->(dbseek(DtoC(aValores[x][3])))
			
			//Nao grava os que foram recebidos em atraso sem cobrança.
			If !Empty(aValores[x][1])
			
				RecLock("XTS", .T.)
					
				//XTS->_FILIAL	:= aValores[x][6]
				XTS->_DDATA	:= DtoC(aValores[x][3])
				&cCpVal 		:= aValores[x][4]	
				&cCpJur 		:= aValores[x][5]	
				/*
				If AllTrim(aValores[x][1]) == '000331'
					&cCpMet 		:= nMetaDiaA1	
				//ElseIf AllTrim(aValores[x][1]) == '000445'
				//	&cCpMet 		:= nMetaDiaA2	
				EndIf
				*/
				MsUnlock()
			
			EndIf
		
		Else
		
			//Nao grava os que foram recebidos em atraso sem cobrança.
			If !Empty(aValores[x][1])
				RecLock("XTS", .F.)
				
				&cCpVal 		+= aValores[x][4]	
				&cCpJur 		+= aValores[x][5]	
				/*
				If AllTrim(aValores[x][1]) == '000331'
					&cCpMet 		:= nMetaDiaA1	
				//ElseIf AllTrim(aValores[x][1]) == '000445'
					//&cCpMet 		:= nMetaDiaA2	
				EndIf
				*/
				MsUnlock()
		
			EndIf
		EndIf
	
	EndIf

Next

//*****************************************************************
// calculo das metas e valores que entram e saem do total cobravél
//*****************************************************************

_d1	:= d1

While _d1 <= d2

	aMeta		:= fMeta( _d1, d2 )
	aEntMeta	:= fEntMeta( _d1 )
	aSaiMeta	:= fSaiMeta( _d1 )
	
	IF !XTS->(dbseek(DtoC(_d1)))
			
			
		RecLock("XTS", .T.)
					
		XTS->_DDATA		:= DtoC(_d1)
		XTS->_MET000331	:= aMeta[1]	
		XTS->_ENT000331	:= aEntMeta[1]	
		XTS->_SAI000331	:= aSaiMeta[1]	
		XTS->_MET000445	:= aMeta[2]	
		XTS->_ENT000445	:= aEntMeta[2]	
		XTS->_SAI000445	:= aSaiMeta[2]	
		//XTS->_MET000426	:= fTotPub(_d1)	
		
		MsUnlock()
		
		
	Else
		
		RecLock("XTS", .F.)
				
		XTS->_MET000331	:= aMeta[1]	
		XTS->_ENT000331	:= aEntMeta[1]	
		XTS->_SAI000331	:= aSaiMeta[1]	
		XTS->_MET000445	:= aMeta[2]	
		XTS->_ENT000445	:= aEntMeta[2]	
		XTS->_SAI000445	:= aSaiMeta[2]	
		//XTS->_MET000426	:= fTotPub(_d1)	
	
		MsUnlock()
		
	EndIf
	
	_d1 := _d1 + 1
	
EndDo

//***************************************
//VALORES GLOBAL
//***************************************
/*
cQuery := " SELECT E5_FILIAL, E5_DATA, E1_VENCREA, E5_VALOR, E5_VLJUROS, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIENTE, E5_LOJA, A1_EST, E5_SEQ, A1_SATIV1 "
cQuery += " FROM " + RetSqlName("SE5") + " E5 "
cQuery += " INNER JOIN " + RetSqlName("SE1") + " E1 "
cQuery += " ON E5_FILIAL = E1_FILIAL "
cQuery += " AND E5_PREFIXO = E1_PREFIXO "
cQuery += " AND E5_NUMERO = E1_NUM "
cQuery += " AND E5_PARCELA = E1_PARCELA "
cQuery += " AND E5_TIPO = E1_TIPO "
cQuery += " AND E5_CLIENTE = E1_CLIENTE "
cQuery += " AND E5_LOJA = E1_LOJA "
cQuery += " INNER JOIN SA1010 "
cQuery += " ON E5_CLIENTE = A1_COD "
cQuery += " AND E5_LOJA = A1_LOJA "
cQuery += " WHERE E5.D_E_L_E_T_ <> '*' "
cQuery += " AND E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E5_RECPAG = 'R' "
cQuery += " AND E5_DATA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "' "
cQuery += " AND E1_VENCREA < E5_DATA "
cQuery += " AND E1_TIPO NOT IN ('NCC','RA') "
//cQuery += " AND E5_TIPODOC NOT IN ('JR','DC','CP','MT','XX') "
cQuery += " AND E5_MOTBX NOT IN ('DAC') "
cQuery += " AND E1_PORTADO = 'COB' "
cQuery += " ORDER BY E5_DATA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_CLIENTE, E5_LOJA "

If Select("XTT") > 0
	DbSelectArea("XTT")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XTT"
TCSetField( 'XTT', "E5_DATA", "D", 8, 0 )
TCSetField( 'XTT', "E1_VENCREA", "D", 8, 0 )

XTT->( DbGoTop() )
		
While !oReport:Cancel() .And. XTT->(!EOF())

	lEstorno := fEstorno( XTT->E5_FILIAL, XTT->E5_PREFIXO, XTT->E5_NUMERO, XTT->E5_PARCELA, XTT->E5_TIPO, XTT->E5_CLIENTE, XTT->E5_LOJA, XTT->E5_SEQ )
	
	If lEstorno
	
		XTT->(dbSkip())
		loop
	
	EndIf
	
	IF !XTS->(dbseek(DtoC(XTT->E5_DATA)))
			
			
		RecLock("XTS", .T.)
					
		XTS->_DDATA	:= DtoC(XTT->E5_DATA)
		XTS->_VAL		:= XTT->E5_VALOR	
		XTS->_JUR 		:= XTT->E5_VLJUROS	
		
		MsUnlock()
		
		
	Else
		
		RecLock("XTS", .F.)
				
		XTS->_VAL 		+= XTT->E5_VALOR	
		XTS->_JUR		+= XTT->E5_VLJUROS	
	
		MsUnlock()
		
	EndIf
	nTotalAG	:= nTotalAG + XTT->E5_VALOR	
	
	XTT->(dbSkip())
	
EndDo

//********************************************
//calcula o total transmitido para Global
//********************************************
_d1	:= d1

While _d1 <= d2

	IF !XTS->(dbseek(DtoC(_d1)))
			
			
		RecLock("XTS", .T.)
					
		XTS->_DDATA	:= DtoC(_d1)
		XTS->_VALT		:= fTotGlo(_d1)	
		
		MsUnlock()
		
		
	Else
		
		RecLock("XTS", .F.)
				
		XTS->_VALT		:= fTotGlo(_d1)	
	
		MsUnlock()
		
	EndIf
	nMetaG	:= XTS->_VALT	
	_d1 := _d1 + 1
	
EndDo
*/
//*****************************
//INICIO DA IMPRESSAO
//*****************************
dbselectArea("XTS")
nCount	:= XTS->(RECCOUNT())
XTS->( DbGoTop() )
		
oReport:SetMeter(nCount)

oSection1:Init()

While !oReport:Cancel() .And. XTS->(!EOF())

	oSection1:Cell("_FILIAL"):SetValue("00")
	oSection1:Cell("_FILIAL"):SetAlign("CENTER")
	oSection1:Cell("_DDATA"):SetValue(XTS->_DDATA)
	oSection1:Cell("_DDATA"):SetAlign("CENTER")
	
	XTM->( DbGoTop() )
			
	While XTM->(!EOF())
		
		cCpVal	:= 'XTS->_VAL' + AllTrim(XTM->X5_CHAVE)
		cCpJur	:= 'XTS->_JUR' + AllTrim(XTM->X5_CHAVE)
		cCpMet	:= 'XTS->_MET' + AllTrim(XTM->X5_CHAVE)
		cCpSai	:= 'XTS->_SAI' + AllTrim(XTM->X5_CHAVE)
		cCpEnt	:= 'XTS->_ENT' + AllTrim(XTM->X5_CHAVE)
		
		oSection1:Cell("_VAL" + Alltrim(XTM->X5_CHAVE)):SetValue(&cCpVal)
		oSection1:Cell("_VAL" + Alltrim(XTM->X5_CHAVE)):SetAlign("RIGHT")
		oSection1:Cell("_JUR" + Alltrim(XTM->X5_CHAVE)):SetValue(&cCpJur)
		oSection1:Cell("_JUR" + Alltrim(XTM->X5_CHAVE)):SetAlign("RIGHT")
		
		oSection1:Cell("_SAI" + Alltrim(XTM->X5_CHAVE)):SetValue(&cCpSai)
		oSection1:Cell("_SAI" + Alltrim(XTM->X5_CHAVE)):SetAlign("RIGHT")
		oSection1:Cell("_ENT" + Alltrim(XTM->X5_CHAVE)):SetValue(&cCpEnt)
		oSection1:Cell("_ENT" + Alltrim(XTM->X5_CHAVE)):SetAlign("RIGHT")

		Do Case
			Case	AllTrim(XTM->X5_CHAVE) == '000331'
				oSection1:Cell("_PER" + Alltrim(XTM->X5_CHAVE)):SetValue((&cCpVal / nMetaDiaA1) * 100 )
				oSection1:Cell("_MET" + Alltrim(XTM->X5_CHAVE)):SetValue(&cCpMet )
			Case	AllTrim(XTM->X5_CHAVE) == '000445'
				oSection1:Cell("_PER" + Alltrim(XTM->X5_CHAVE)):SetValue((&cCpVal / nMetaDiaA2) * 100 )
				oSection1:Cell("_MET" + Alltrim(XTM->X5_CHAVE)):SetValue(&cCpMet)
			OtherWise
				oSection1:Cell("_PER" + Alltrim(XTM->X5_CHAVE)):SetValue(0)
		EndCase

		//oSection1:Cell("_PER" + Alltrim(XTM->X5_CHAVE)):SetAlign("RIGHT")
		//oSection1:Cell("_MET" + Alltrim(XTM->X5_CHAVE)):SetAlign("RIGHT")
		nValTot		+= &cCpVal
		nJurTot		+= &cCpJur
		
		XTM->(dbSkip())
	
	EndDo

	//nValTot		+= XTS->_VAL
	//nJurTot		+= XTS->_JUR
	/*
	oSection1:Cell("_VAL000426"):SetValue(XTS->_VAL000426)
	oSection1:Cell("_VAL000426"):SetAlign("RIGHT")
	oSection1:Cell("_JUR000426"):SetValue(XTS->_JUR000426)
	oSection1:Cell("_JUR000426"):SetAlign("RIGHT")
	oSection1:Cell("_PER000426"):SetValue((XTS->_VAL000426/XTS->_MET000426)* 100)
	oSection1:Cell("_PER000426"):SetAlign("RIGHT")
	oSection1:Cell("_MET000426"):SetValue(XTS->_MET000426)
	oSection1:Cell("_MET000426"):SetAlign("RIGHT")
	
	oSection1:Cell("_VAL"):SetValue(XTS->_VAL)
	oSection1:Cell("_VAL"):SetAlign("RIGHT")
	oSection1:Cell("_JUR"):SetValue(XTS->_JUR)
	oSection1:Cell("_JUR"):SetAlign("RIGHT")
	oSection1:Cell("_VALT"):SetValue(XTS->_VALT)
	oSection1:Cell("_VALT"):SetAlign("RIGHT")
	*/
	oSection1:PrintLine()

	//nValTot		:= XTS->_MET000426
	nJurTot		:= 0

	XTS->(dbSkip())
	
EndDo
/*
oReport:SkipLine()
oReport:SkipLine()
oReport:Say(oReport:Row(),50,"Meta dia por pessoa - ")
oReport:Say(oReport:Row(),330, Transform(nMetaDia, "@E 9,999,999.99") )
oReport:SkipLine()
//oReport:Say(oReport:Row(),50,"Meta dia por pessoa - ")
//oReport:Say(oReport:Row(),280, nMetaDia )
*/

oSection1:Finish()
/*
oReport:Say(oReport:Row()-1,680, Transform((nTotalA1 / nMetaA1)*100, "@E 9,999.99") )
oReport:Say(oReport:Row()-1,1315, Transform((nTotalA2 / nMetaA2)*100, "@E 9,999.99") )
oReport:Say(oReport:Row()-1,2015, Transform(nValTot, "@E 99,999,999.99") )
oReport:Say(oReport:Row()-1,2500, Transform((nTotalAG / nMetaG)*100, "@E 9,999.99") )
oReport:Say(oReport:Row()-1,2705, Transform(nMetaG, "@E 99,999,999.99") )
oReport:SkipLine()
oReport:Say(oReport:Row(),50,"Comissão - 0,2% a partir de 100% ")
oReport:SkipLine()
oReport:Say(oReport:Row(),50,"Comissão - 0,3% a partir de 150% ")
oReport:Say(oReport:Row(),800,"AREA01 - " + SUPERGETMV("MV_XAREA1",,"AL#BA#CE#RN#SE") )
oReport:SkipLine()
oReport:Say(oReport:Row(),50,"Comissão - 0,4% a partir de 200% ")
oReport:Say(oReport:Row(),800,"AREA02 - " + SUPERGETMV("MV_XAREA2",,"AC#AM#AP#DF#ES#GO#MA#MG#MS#MT#PA#PB#PE#PI#PR#RJ#RO#RR#RS#SC#SP"))
*/
oReport:SkipLine()
oReport:SkipLine()

XTM->( DbGoTop() )
/*		
While XTM->(!EOF())

	_nPos	+= 3
	AADD( aTotAten, { AllTrim(XTM->X5_CHAVE), oSection1:ACell[_nPos]:AFunction[1]:UPAGE })

	XTM->(dbSkip())

EndDo
//Pega o total em branco
_nPos	+= 3
AADD( aTotAten, { "", oSection1:ACell[_nPos]:AFunction[1]:UPAGE })
//Pega o total Geral
_nPos	+= 3
AADD( aTotAten, { "TOTAL", oSection1:ACell[_nPos]:AFunction[1]:UPAGE })
*/
//***********************************************************************
// Informações por quantidade de dias vencidos
//***********************************************************************
/*
oReport:SkipLine()
oReport:Say(oReport:Row(),20,"POSIÇÃO POR FAIXA DE ANOS")
oSection1:Init()

RecLock("XTS", .T.)

XTS->_DDATA		:= 'De 2013'
XTS->_MET000426 	:= fTotAnoPub('2013',d2)

MsUnlock()

RecLock("XTS", .T.)

XTS->_DDATA		:= 'De 2014'
XTS->_MET000426 	:= fTotAnoPub('2014',d2)

MsUnlock()

RecLock("XTS", .T.)

XTS->_DDATA		:= 'De 2015'
XTS->_MET000426 	:= fTotAnoPub('2015',d2)

MsUnlock()

//aValores, { aAtend[1], aAtend[2], XTT->E5_DATA, XTT->E5_VALOR, XTT->E5_VLJUROS, XTT->E5_FILIAL, XTT->E1_VENCREA - XTT->E5_DATA, XTT->E5_PREFIXO } )
For x := 1 To Len(aValores)
	
	Do Case
	
		Case DtoS(aValores[x][9]) <= '20131231' .AND. AllTrim(aValores[x][1]) == '000426'
		
			cCampoD := 'De 2013'
	
			IF XTS->(dbseek(cCampoD))

				RecLock("XTS", .F.)
				
				XTS->_VAL000331 		:= 0	
				XTS->_JUR000331 		:= 0	
				XTS->_PER000331 		:= 0	
				XTS->_MET000331 		:= 0	
				XTS->_VAL000445 		:= 0	
				XTS->_JUR000445 		:= 0	
				XTS->_PER000445 		:= 0	
				XTS->_MET000445 		:= 0	
				XTS->_VAL000426 		+= aValores[x][4]	
				XTS->_JUR000426 		+= aValores[x][5]	
				XTS->_VAL 				:= 0	
				XTS->_JUR 				:= 0	
				XTS->_VALT 			:= 0	
			
				MsUnlock()
		
			EndIf
	
		Case DtoS(aValores[x][9]) >= '20140101' .AND. DtoS(aValores[x][9]) <= '20141231' .AND. AllTrim(aValores[x][1]) == '000426'
		
			cCampoD := 'De 2014'
	
			IF XTS->(dbseek(cCampoD))

				RecLock("XTS", .F.)
				
				XTS->_VAL000331 		:= 0	
				XTS->_JUR000331 		:= 0	
				XTS->_PER000331 		:= 0	
				XTS->_MET000331 		:= 0	
				XTS->_VAL000445 		:= 0	
				XTS->_JUR000445 		:= 0	
				XTS->_PER000445 		:= 0	
				XTS->_MET000445 		:= 0	
				XTS->_VAL000426 		+= aValores[x][4]	
				XTS->_JUR000426 		+= aValores[x][5]	
				XTS->_VAL 				:= 0	
				XTS->_JUR 				:= 0	
				XTS->_VALT 			:= 0	
			
				MsUnlock()
		
			EndIf

		Case DtoS(aValores[x][9]) >= '20150101' .AND. AllTrim(aValores[x][1]) == '000426'
		
			cCampoD := 'De 2015'
	
			IF XTS->(dbseek(cCampoD))

				RecLock("XTS", .F.)
				
				XTS->_VAL000331 		:= 0	
				XTS->_JUR000331 		:= 0	
				XTS->_PER000331 		:= 0	
				XTS->_MET000331 		:= 0	
				XTS->_VAL000445 		:= 0	
				XTS->_JUR000445 		:= 0	
				XTS->_PER000445 		:= 0	
				XTS->_MET000445 		:= 0	
				XTS->_VAL000426 		+= aValores[x][4]	
				XTS->_JUR000426 		+= aValores[x][5]	
				XTS->_VAL 				:= 0	
				XTS->_JUR 				:= 0	
				XTS->_VALT 			:= 0	
			
				MsUnlock()
		
			EndIf

		EndCase

Next

nValTot		:= 0
nJurTot		:= 0

dbselectArea("XTS")
//dbsetOrder(1)
XTS->(dbSeek('De 2013'))

While !oReport:Cancel() .And. XTS->(!EOF())

	oSection1:Cell("_FILIAL"):SetValue("XX")
	oSection1:Cell("_FILIAL"):SetAlign("CENTER")
	oSection1:Cell("_DDATA"):SetValue(XTS->_DDATA)
	oSection1:Cell("_DDATA"):SetAlign("CENTER")
	
	cCpVal	:= 'XTS->_VAL000426'
	cCpJur	:= 'XTS->_JUR000426'
		
	oSection1:Cell("_VAL000331"):SetValue(0)
	oSection1:Cell("_VAL000331"):SetAlign("RIGHT")
	oSection1:Cell("_JUR000331"):SetValue(0)
	oSection1:Cell("_JUR000331"):SetAlign("RIGHT")
	oSection1:Cell("_PER000331"):SetValue(0)
	oSection1:Cell("_PER000331"):SetAlign("RIGHT")
	oSection1:Cell("_MET000331"):SetValue(0)
	oSection1:Cell("_MET000331"):SetAlign("RIGHT")

	oSection1:Cell("_VAL000445"):SetValue(0)
	oSection1:Cell("_VAL000445"):SetAlign("RIGHT")
	oSection1:Cell("_JUR000445"):SetValue(0)
	oSection1:Cell("_JUR000445"):SetAlign("RIGHT")
	oSection1:Cell("_PER000445"):SetValue(0)
	oSection1:Cell("_PER000445"):SetAlign("RIGHT")
	oSection1:Cell("_MET000445"):SetValue(0)
	oSection1:Cell("_MET000445"):SetAlign("RIGHT")


	oSection1:Cell("_VAL000426"):SetValue(XTS->_VAL000426)
	oSection1:Cell("_VAL000426"):SetAlign("RIGHT")
	oSection1:Cell("_JUR000426"):SetValue(XTS->_JUR000426)
	oSection1:Cell("_JUR000426"):SetAlign("RIGHT")
	oSection1:Cell("_MET000426"):SetValue(XTS->_MET000426)
	oSection1:Cell("_MET000426"):SetAlign("RIGHT")

	//nMetaDia	:= aTotAten[aScan(aTotAten,{|x| x[1] == Alltrim(XTM->X5_CHAVE)})][2]
	oSection1:Cell("_PER000426"):SetAlign("RIGHT")
	nValTot		+= &cCpVal
	nJurTot		+= &cCpJur
		
	
	oSection1:Cell("_VAL"):SetValue(0)
	oSection1:Cell("_VAL"):SetAlign("RIGHT")
	oSection1:Cell("_JUR"):SetValue(0)
	oSection1:Cell("_JUR"):SetAlign("RIGHT")
	//nMetaDia	:= aTotAten[aScan(aTotAten,{|x| x[1] == "" })][2]
	oSection1:Cell("_PER"):SetValue(0)
	oSection1:Cell("_PER"):SetAlign("RIGHT")
	oSection1:Cell("_VALT"):SetValue(0)
	oSection1:Cell("_VALT"):SetAlign("RIGHT")
*/
/*	
	nValTot		+= XTS->_VAL
	nJurTot		+= XTS->_JUR

	oSection1:Cell("_VALT"):SetValue(nValTot)
	oSection1:Cell("_VALT"):SetAlign("RIGHT")
	oSection1:Cell("_JURT"):SetValue(nJurTot)
	oSection1:Cell("_JURT"):SetAlign("RIGHT")
	//nMeta		:= aTotAten[aScan(aTotAten,{|x| x[1] == "TOTAL" })][2]
	oSection1:Cell("_PERT"):SetValue((nValTot / (nMetaA1 + nMetaA2)) * 100)
	oSection1:Cell("_PERT"):SetAlign("RIGHT")
	oSection1:Cell("_META"):SetValue(0)
	oSection1:Cell("_META"):SetAlign("RIGHT")
*/
/*
	oSection1:PrintLine()
	XTS->(dbSkip())

//	nValTot		:= 0
//	nJurTot		:= 0
		
EndDo

oSection1:Finish()
*/

//***********************************************************************
// Calculo das bonificações
//***********************************************************************
/*
oReport:SkipLine()
oReport:Say(oReport:Row(),20,"BONIFICAÇÕES")
oSection1:Init()

Do Case
	Case nTotalA1 / nMetaA1 >= 1 .and. nTotalA1 / nMetaA1 < 1.5
		nFatorA1	:= 0.002
	Case nTotalA1 / nMetaA1 >= 1.5 .and. nTotalA1 / nMetaA1 < 2
		nFatorA1	:= 0.003
	Case nTotalA1 / nMetaA1 >= 2
		nFatorA1	:= 0.004
	OtherWise
		nFatorA1	:= 0
EndCase
	
Do Case
	Case nTotalA2 / nMetaA2 >= 1 .and. nTotalA2 / nMetaA2 < 1.5
		nFatorA2	:= 0.002
	Case nTotalA2 / nMetaA2 >= 1.5 .and. nTotalA2 / nMetaA2 < 2
		nFatorA2	:= 0.003
	Case nTotalA2 / nMetaA2 >= 2
		nFatorA2	:= 0.004
	OtherWise
		nFatorA2	:= 0
EndCase

//aValores, { aAtend[1], aAtend[2], XTT->E5_DATA, XTT->E5_VALOR, XTT->E5_VLJUROS, XTT->E5_FILIAL, XTT->E1_VENCREA - XTT->E5_DATA, XTT->E5_PREFIXO } )
For x := 1 To Len(aValores)
	
	If Alltrim(aValores[x][8]) == "0"
			cCampoD := 'T. Normal'
	Else
			cCampoD := 'T. XDD'
	EndIf

	cCpVal	:= 'XTS->_VAL'+ AllTrim(aValores[x][1])
	cCpJur	:= 'XTS->_JUR'+ AllTrim(aValores[x][1])

	IF !XTS->(dbseek(cCampoD))
	
		If Type(cCpVal) <> "U"
	
			RecLock("XTS", .T.)
			
			//XTS->_FILIAL	:= aValores[x][6]
			XTS->_DDATA	:= cCampoD
			&cCpVal 		:= aValores[x][4]
			
			If 	cCampoD == 'T. XDD'
				&cCpJur 		:= aValores[x][4] * 0.002
			Else
				If aValores[x][1] == '000331'	// Solange
					&cCpJur 		:= aValores[x][4] * nFatorA1
				ElseIf aValores[x][1] == '000445'	// Glaucia
					&cCpJur 		:= aValores[x][4] * nFatorA2
					ElseIf aValores[x][1] == '000426'	// Renata
						XTS->_JUR000426 		:= aValores[x][4] * 0.002
				EndIf
			EndIf
			
			MsUnlock()
		
		EndIf
	
	Else

		RecLock("XTS", .F.)
		
		//XTS->DDATA		:= aValores[x][3]
		&cCpVal 		+= aValores[x][4]

		If 	cCampoD == 'T. XDD'
			&cCpJur 		+= aValores[x][4] * 0.002
		Else
			If aValores[x][1] == '000331'	// Solange
				&cCpJur 		+= aValores[x][4] * nFatorA1
			ElseIf aValores[x][1] == '000445'	// Glaucia
				&cCpJur 		+= aValores[x][4] * nFatorA2
				ElseIf aValores[x][1] == '000426'	// Renata
					XTS->_JUR000426 		:= aValores[x][4] * 0.002
			EndIf
		EndIf
	
		MsUnlock()

	EndIf

Next

nValTot		:= 0
nJurTot		:= 0

dbselectArea("XTS")
//dbsetOrder(1)
XTS->(dbSeek('T. Normal'))

While !oReport:Cancel() .And. XTS->(!EOF())

	oSection1:Cell("_FILIAL"):SetValue("XX")
	oSection1:Cell("_FILIAL"):SetAlign("CENTER")
	oSection1:Cell("_DDATA"):SetValue(XTS->_DDATA)
	oSection1:Cell("_DDATA"):SetAlign("CENTER")
	
	//XTM->( DbGoTop() )
			
	//While XTM->(!EOF())
		
	cCpVal	:= 'XTS->_VAL' + AllTrim(XTM->X5_CHAVE)
	cCpJur	:= 'XTS->_JUR' + AllTrim(XTM->X5_CHAVE)
	
	oSection1:Cell("_VAL000331"):SetValue(XTS->_VAL000331)
	oSection1:Cell("_VAL000331"):SetAlign("RIGHT")
	oSection1:Cell("_JUR000331"):SetValue(XTS->_JUR000331)
	oSection1:Cell("_JUR000331"):SetAlign("RIGHT")

	oSection1:Cell("_VAL000445"):SetValue(XTS->_VAL000445)
	oSection1:Cell("_VAL000445"):SetAlign("RIGHT")
	oSection1:Cell("_JUR000445"):SetValue(XTS->_JUR000445)
	oSection1:Cell("_JUR000445"):SetAlign("RIGHT")

	If Alltrim(XTS->_DDATA) == 'T. XDD'

		oSection1:Cell("_PER000331"):SetValue(0.2)
		oSection1:Cell("_MET000331"):SetValue(nMetaX)

		oSection1:Cell("_PER000445"):SetValue(0)
		oSection1:Cell("_MET000445"):SetValue(0)

	Else

		oSection1:Cell("_PER000331"):SetValue(nFatorA1 * 100)
		oSection1:Cell("_MET000331"):SetValue(nMetaA1 - nMetaX)

		oSection1:Cell("_PER000445"):SetValue(nFatorA2 * 100)
		oSection1:Cell("_MET000445"):SetValue(nMetaA2)

	EndIf
	oSection1:Cell("_PER000331"):SetAlign("RIGHT")
	oSection1:Cell("_PER000445"):SetAlign("RIGHT")

	nValTot		+= &cCpVal
	nJurTot		+= &cCpJur
	
		//XTM->(dbSkip())
	
	//EndDo
	
	oSection1:Cell("_VAL000426"):SetValue(XTS->_VAL000426)
	oSection1:Cell("_VAL000426"):SetAlign("RIGHT")
	oSection1:Cell("_JUR000426"):SetValue(XTS->_JUR000426)
	oSection1:Cell("_JUR000426"):SetAlign("RIGHT")
	oSection1:Cell("_PER000426"):SetValue(0.2)
	oSection1:Cell("_PER000426"):SetAlign("RIGHT")
	oSection1:Cell("_MET000426"):SetValue(0)
	oSection1:Cell("_MET000426"):SetAlign("RIGHT")
	
	oSection1:Cell("_VAL"):SetValue(XTS->_VAL)
	oSection1:Cell("_VAL"):SetAlign("RIGHT")
	oSection1:Cell("_JUR"):SetValue(XTS->_JUR)
	oSection1:Cell("_JUR"):SetAlign("RIGHT")
	oSection1:Cell("_VALT"):SetValue(XTS->_VALT)
	oSection1:Cell("_VALT"):SetAlign("RIGHT")

	oSection1:PrintLine()
	XTS->(dbSkip())

	nValTot		:= 0
	nJurTot		:= 0
		
EndDo

oSection1:Finish()
*/
dbCloseArea("XTS")

Set Filter To

Return


//------------------------------------------------------------------------------------------
/*
Verifica se a baixa foi estornada.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     13/05/2014
/*/
//------------------------------------------------------------------------------------------
Static Function fEstorno( _Filial, cPREFIXO, cNUMERO, cPARCELA, cTIPO, cCLIENTE, cLOJA, cSEQ )

local lRet	:= .F.

cQuery := " SELECT * " 
cQuery += " FROM  " + RetSqlName("SE5") + " E5 "
cQuery += " WHERE D_E_L_E_T_ <> '*' "
//cQuery += " AND E5_FILIAL = '" + _Filial + "' "
cQuery += " AND E5_PREFIXO = '" + cPREFIXO + "'"
cQuery += " AND E5_NUMERO =  '" + cNUMERO + "'"
cQuery += " AND E5_PARCELA =  '" + cPARCELA + "'"
cQuery += " AND E5_TIPO =  '" + cTIPO + "'"
cQuery += " AND E5_CLIENTE =  '" + cCLIENTE + "'"
cQuery += " AND E5_LOJA =  '" + cLOJA + "'"
cQuery += " AND E5_SEQ = '" + cSEQ + "' "
cQuery += " AND E5_RECPAG = 'P' "
 
MemoWrite("C:\TEMP\fEstorno.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "XTMP"

dbselectArea("XTMP")
dbGoTop("XTMP")

IF XTMP->(!EOF())

	lRet	:= .T. 

EndIf

dbCloseArea("XTMP")

Return lRet


//------------------------------------------------------------------------------------------
/*
Verifica qual atendente fez a cobrança para aquela baixa.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
Static Function fAtendente( _Filial, cCLIENTE, cLOJA, dVenc, dBaixa)

local aRet	:= {}

cQuery := " SELECT A3_SUPER, ZA2_CODATE, ZA2_NOMATE, A1_SATIV1 " 
cQuery += " FROM " + RetSqlName("ZA2") + " ZA2 "
cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1 "
cQuery += " ON ZA2_CODCLI = A1_COD "
cQuery += " AND ZA2_LJCLI = A1_LOJA "
cQuery += " INNER JOIN " + RetSqlName("SA3") + " A3 "
cQuery += " ON A1_VEND = A3_COD "
cQuery += " WHERE ZA2.D_E_L_E_T_ <> '*' "
cQuery += " AND A1.D_E_L_E_T_ <> '*' " 
cQuery += " AND A3.D_E_L_E_T_ <> '*' "
cQuery += " AND ZA2_FILIAL = '" + _Filial + "' "
cQuery += " AND ZA2_CODCLI =  '" + cCLIENTE + "'"
cQuery += " AND ZA2_LJCLI =  '" + cLOJA + "'"
cQuery += " AND ZA2_DTATEN > '" + DtoS(dVenc) + "'"
cQuery += " AND ZA2_DTATEN <= '" + DtoS(dBaixa) + "'"
cQuery += " AND ZA2_RESULT IN ('3','4') "
cQuery += " AND ZA2_HRFIM <> ''"
cQuery += " ORDER BY ZA2_DTATEN + ZA2_HRINI DESC "

MemoWrite("C:\TEMP\fAtend.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "XTMP"

dbselectArea("XTMP")
dbGoTop("XTMP")

IF XTMP->(!EOF())

	Do Case
		Case Alltrim(XTMP->A3_SUPER) $ '2366#2367#0228#0315' .AND. XTMP->A1_SATIV1 <> '000009'// Josenildo, Jaqueline, Glaucio, Isaac

			AADD(aRet, "000445") 
			AADD(aRet, "Glaucia") 

		Case Alltrim(XTMP->A3_SUPER) $ '0342#2348' .AND. XTMP->A1_SATIV1 <> '000009' // Luiz e Josenildo

			AADD(aRet, "000331") 
			AADD(aRet, "Solange Mota") 

		Case XTMP->A1_SATIV1 == '000009' // Publico

			AADD(aRet, "000426") 
			AADD(aRet, "Renata Aragao")
		
		OtherWise 

			AADD(aRet, "") 
			AADD(aRet, "")
	
	EndCase
Else

	AADD(aRet, "") 
	AADD(aRet, "") 

EndIf

dbCloseArea("XTMP")

Return aRet

//------------------------------------------------------------------------------------------
/*
Verifica qual atendente fez a cobrança para aquela baixa.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
Static Function f2Atendente( _Filial, cCLIENTE, cLOJA, dVenc, dBaixa )

local aRet		:= {}
Local cArea1	:= SUPERGETMV("MV_XAREA1",,"AL#BA#CE#RN#SE")
Local cArea2	:= SUPERGETMV("MV_XAREA2",,"AC#AM#AP#DF#ES#GO#MA#MG#MS#MT#PA#PB#PE#PI#PR#RJ#RO#RR#RS#SC#SP")

cQuery := " SELECT A3_SUPER, ZA2_CODATE, ZA2_NOMATE, A1_EST, A1_SATIV1 " 
cQuery += " FROM " + RetSqlName("ZA2") + " ZA2 "
cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1 "
cQuery += " ON ZA2_CODCLI = A1_COD "
cQuery += " AND ZA2_LJCLI = A1_LOJA "
cQuery += " INNER JOIN " + RetSqlName("SA3") + " A3 "
cQuery += " ON A1_VEND = A3_COD "
cQuery += " WHERE ZA2.D_E_L_E_T_ <> '*' "
cQuery += " AND A1.D_E_L_E_T_ <> '*' " 
cQuery += " AND A3.D_E_L_E_T_ <> '*' "
cQuery += " AND ZA2_FILIAL = '" + _Filial + "' "
cQuery += " AND ZA2_CODCLI =  '" + cCLIENTE + "'"
cQuery += " AND ZA2_LJCLI =  '" + cLOJA + "'"
cQuery += " AND ZA2_DTATEN > '" + DtoS(dVenc) + "'"
cQuery += " AND ZA2_DTATEN <= '" + DtoS(dBaixa) + "'"
cQuery += " AND ZA2_RESULT IN ('3','4') "
cQuery += " AND ZA2_HRFIM <> ''"
cQuery += " ORDER BY ZA2_DTATEN + ZA2_HRINI DESC "

MemoWrite("C:\TEMP\fAtend.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "XTMP"

dbselectArea("XTMP")
dbGoTop("XTMP")

IF XTMP->(!EOF())

	Do Case
		Case Alltrim(XTMP->A1_EST) $ cArea2 .AND. XTMP->A1_SATIV1 <> '000009'// AC#AM#AP#DF#ES#GO#MA#MG#MS#MT#PA#PB#PE#PI#PR#RJ#RO#RR#RS#SC#SP
	
			AADD(aRet, "000445") 
			AADD(aRet, "Glaucia") 
	
		Case Alltrim(XTMP->A1_EST) $ cArea1 .AND. XTMP->A1_SATIV1 <> '000009' // AL#BA#CE#RN#SE
	
			AADD(aRet, "000331") 
			AADD(aRet, "Solange Mota") 
	
		Case XTMP->A1_SATIV1 == '000009' // Publico
	
			AADD(aRet, "000426") 
			AADD(aRet, "Renata Aragao")
		
		OtherWise 
	
			AADD(aRet, "") 
			AADD(aRet, "")
	
	EndCase
Else

	AADD(aRet, "") 
	AADD(aRet, "") 

EndIf

dbCloseArea("XTMP")

Return aRet

//------------------------------------------------------------------------------------------
/*
Calcula a meta das cobradoras.

@author    Gustavo Costa
@version   1.xx
@since     27/10/2014
/*/
//------------------------------------------------------------------------------------------
Static Function fMeta( d1, d2 )

local lRet		:= .F.
Local aret		:= {}
Local nTotal	:= 0
Local nTotalA1:= 0
Local nTotalA2:= 0
Local nTotalX	:= 0
Local nTotalP	:= 0
Local cQuery	:= ""
Local aMedias	:= {}
Local nDias	:= 0
Local nSaldo	:= 0
Local cArea1	:= SUPERGETMV("MV_XAREA1",,"AL#BA#CE#RN#SE")
Local cArea2	:= SUPERGETMV("MV_XAREA2",,"AC#AM#AP#DF#ES#GO#MA#MG#MS#MT#PA#PB#PE#PI#PR#RJ#RO#RR#RS#SC#SP")

//WHILE d1 <= d2

	cQuery := " SELECT E1.*, A1_EST FROM SE1020 E1 " 
	cQuery += " INNER JOIN SA1010 A1 "
	cQuery += " ON E1_CLIENTE = A1_COD " 
	cQuery += " AND E1_LOJA = A1_LOJA "
	cQuery += " WHERE E1.D_E_L_E_T_ <> '*' "
	cQuery += " AND A1_SATIV1 <> '000009' "
	cQuery += " AND E1_VENCREA BETWEEN '" + DtoS(d1 - 31) + "' AND '" + DtoS(d1-1) + "' " 
	cQuery += " AND E1_TIPO NOT IN ('NCC','RA','JR','DC','CP','MT','XX') "
	cQuery += " AND E1_PORTADO NOT IN ('COB') "
	cQuery += " ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA "

	If Select("XXTM") > 0
		DbSelectArea("XXTM")
		DbCloseArea()
	EndIf

	TCQUERY cQuery NEW ALIAS "XXTM"
	dbselectArea("XXTM")
	dbGoTop("XXTM")
	
	While XXTM->(!EOF())
		
		//Verifica se foi baixado
		//If !fBaixado(XXTM->E1_FILIAL, XXTM->E1_PREFIXO, XXTM->E1_NUM, XXTM->E1_PARCELA, XXTM->E1_TIPO, XXTM->E1_CLIENTE, XXTM->E1_LOJA, d1)
		nSaldo := SaldoTit(XXTM->E1_PREFIXO,XXTM->E1_NUM,XXTM->E1_PARCELA,XXTM->E1_TIPO,XXTM->E1_NATUREZ,"R",;
							 XXTM->E1_CLIENTE,1,StoD(XXTM->E1_VENCREA),d1,XXTM->E1_LOJA,XXTM->E1_FILIAL,,1)
		
		If nSaldo > 0
			//MsgAlert("PRE" + XXTM->E1_PREFIXO + " NUM " + XXTM->E1_NUM + " PARC " + XXTM->E1_PARCELA + " TIPO " + XXTM->E1_TIPO + " VALOR " + Transform(nSaldo, "@E 999,999,999.99"))
			nTotalP 	:= nTotalP + XXTM->E1_VALOR//nSaldo
			nTotal 	:= nTotal + XXTM->E1_VALOR//nSaldo
			
			If Alltrim(XXTM->E1_PREFIXO) == "0"
			
				IF Alltrim(XXTM->A1_EST) $ cArea2 // AC#AM#AP#DF#ES#GO#MA#MG#MS#MT#PA#PB#PE#PI#PR#RJ#RO#RR#RS#SC#SP
		
					nTotalA2 	:= nTotalA2 + XXTM->E1_VALOR
				
				ElseIf Alltrim(XXTM->A1_EST) $ cArea1 // AL#BA#CE#RN#SE + XDD
		
					nTotalA1 	:= nTotalA1 + XXTM->E1_VALOR
				
				EndIf
			Else
			
				nTotalX 	:= nTotalX + XXTM->E1_VALOR // AL#BA#CE#RN#SE + XDD
			
			EndIf

			//soma a base 
		EndIf

		XXTM->(dbSkip())
		
	EndDo
	
	dbCloseArea("XXTM")
	
	//MsgAlert("Dia " + DtoC(d1) + " é: " + Transform(nTotalP, "@E 999,999,999.99"))
	
	aadd(aMedias, nTotalP)
	d1			:= d1 + 1
	nDias		:= nDias + 1
	nTotalP	:= 0
	
//EndDo

nMeta	:= nTotal / nDias

//AADD(aRet, nMeta * 0.5038 )//Area1
//AADD(aRet, nMeta * 0.4962 )//Area2
/*
AADD(aRet, (nTotalA1 + nTotalX) / nDias )//Area1
AADD(aRet, nTotalA2 / nDias )//Area2
AADD(aRet, nTotalX / nDias )//XDD
*/

AADD(aRet, (nTotalA1 + nTotalX) )//Area1
AADD(aRet, nTotalA2 )//Area2
AADD(aRet, nTotalX )//XDD

Return aRet


//------------------------------------------------------------------------------------------
/*
verifica se o titulo foi baixado até a data do dia informado

@author    Gustavo Costa
@version   1.xx
@since     29/10/2014
/*/
//------------------------------------------------------------------------------------------

Static Function fBaixado( _Filial, cPREFIXO, cNUMERO, cPARCELA, cTIPO, cCLIENTE, cLOJA, d1 )

local lRet	:= .F.

cQuery := " SELECT * " 
cQuery += " FROM " + RetSqlName("SE5") + " E5 "
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND E5_FILIAL = '" + _Filial + "' "
cQuery += " AND E5_PREFIXO = '" + cPREFIXO + "'"
cQuery += " AND E5_NUMERO =  '" + cNUMERO + "'"
cQuery += " AND E5_PARCELA =  '" + cPARCELA + "'"
cQuery += " AND E5_TIPO =  '" + cTIPO + "'"
cQuery += " AND E5_CLIENTE =  '" + cCLIENTE + "'"
cQuery += " AND E5_LOJA =  '" + cLOJA + "'"
cQuery += " AND E5_TIPODOC = 'VL' "
cQuery += " AND E5_DATA > '" + DtoS(d1) + "' "
cQuery += " AND E5_RECPAG = 'R' "
 
If Select("XTP") > 0
	DbSelectArea("XTP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XTP"

dbselectArea("XTP")
dbGoTop("XTP")

IF XTP->(!EOF())

	IF !fEstorno( XTP->E5_FILIAL, XTP->E5_PREFIXO, XTP->E5_NUMERO, XTP->E5_PARCELA, XTP->E5_TIPO, XTP->E5_CLIENTE, XTP->E5_LOJA, XTP->E5_SEQ )
		lRet	:= .T. 
	EndIf
	
	XTP->(dbSkip())
	
EndIf

dbCloseArea("XTP")

Return lRet


//------------------------------------------------------------------------------------------
/*
Calcula o valor em aberto do setor publico até a data.

@author    Gustavo Costa
@version   1.xx
@since     05/02/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fTotPub(d1)	

Local nTotal	:= 0
Local cQuery	:= ""
Local nSaldo	:= 0


cQuery := " SELECT E1.*, A1_EST FROM " + RetSqlName("SE1") + " E1 " 
cQuery += " INNER JOIN SA1010 A1 "
cQuery += " ON E1_CLIENTE = A1_COD " 
cQuery += " AND E1_LOJA = A1_LOJA "
cQuery += " WHERE E1.D_E_L_E_T_ <> '*' "
cQuery += " AND A1_SATIV1 = '000009' "
cQuery += " AND E1_VENCREA < '" + DtoS(d1) + "' " 
cQuery += " AND ( E1_BAIXA = '' OR E1_BAIXA >= '" + DtoS(d1) + "' ) "
cQuery += " ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA "

If Select("PUB") > 0
	DbSelectArea("PUB")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "PUB"
dbselectArea("PUB")
dbGoTop("PUB")

While PUB->(!EOF())
		
	//Verifica se foi baixado
	//If !fBaixado(XXTM->E1_FILIAL, XXTM->E1_PREFIXO, XXTM->E1_NUM, XXTM->E1_PARCELA, XXTM->E1_TIPO, XXTM->E1_CLIENTE, XXTM->E1_LOJA, d1)
	nSaldo := SaldoTit(PUB->E1_PREFIXO,PUB->E1_NUM,PUB->E1_PARCELA,PUB->E1_TIPO,PUB->E1_NATUREZ,"R",;
							 PUB->E1_CLIENTE,1,StoD(PUB->E1_VENCREA),d1,PUB->E1_LOJA,PUB->E1_FILIAL,,1)
	
	If nSaldo > 0
		//MsgAlert("PRE" + XXTM->E1_PREFIXO + " NUM " + XXTM->E1_NUM + " PARC " + XXTM->E1_PARCELA + " TIPO " + XXTM->E1_TIPO + " VALOR " + Transform(nSaldo, "@E 999,999,999.99"))
		nTotal 	:= nTotal + PUB->E1_VALOR//nSaldo
			
	EndIf

	PUB->(dbSkip())
		
EndDo
	
dbCloseArea("PUB")
	
Return nTotal

//------------------------------------------------------------------------------------------
/*
Calcula o valor em aberto do setor publico por ano.

@author    Gustavo Costa
@version   1.xx
@since     05/02/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fTotAnoPub(cAno,d1)	

Local nTotal	:= 0
Local cQuery	:= ""
Local nSaldo	:= 0


cQuery := " SELECT E1.*, A1_EST FROM " + RetSqlName("SE1") + " E1 " 
cQuery += " INNER JOIN SA1010 A1 "
cQuery += " ON E1_CLIENTE = A1_COD " 
cQuery += " AND E1_LOJA = A1_LOJA "
cQuery += " WHERE E1.D_E_L_E_T_ <> '*' "
cQuery += " AND A1_SATIV1 = '000009' "

If cAno == '2013'
	cQuery += " AND E1_VENCREA < '2014' "
EndIf
If cAno == '2014'
	cQuery += " AND E1_VENCREA BETWEEN '20140101' AND '20141231' "
EndIf
If cAno == '2015'
	cQuery += " AND E1_VENCREA > '2015' "
EndIf
 
cQuery += " AND ( E1_BAIXA = '' OR E1_BAIXA >= '" + DtoS(d1) + "' ) "
cQuery += " ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA "

If Select("PUB") > 0
	DbSelectArea("PUB")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "PUB"
dbselectArea("PUB")
dbGoTop("PUB")

While PUB->(!EOF())
		
	//Verifica se foi baixado
	//If !fBaixado(XXTM->E1_FILIAL, XXTM->E1_PREFIXO, XXTM->E1_NUM, XXTM->E1_PARCELA, XXTM->E1_TIPO, XXTM->E1_CLIENTE, XXTM->E1_LOJA, d1)
	nSaldo := SaldoTit(PUB->E1_PREFIXO,PUB->E1_NUM,PUB->E1_PARCELA,PUB->E1_TIPO,PUB->E1_NATUREZ,"R",;
							 PUB->E1_CLIENTE,1,StoD(PUB->E1_VENCREA),d1,PUB->E1_LOJA,PUB->E1_FILIAL,,1)
	
	If nSaldo > 0
		//MsgAlert("PRE" + XXTM->E1_PREFIXO + " NUM " + XXTM->E1_NUM + " PARC " + XXTM->E1_PARCELA + " TIPO " + XXTM->E1_TIPO + " VALOR " + Transform(nSaldo, "@E 999,999,999.99"))
		nTotal 	:= nTotal + PUB->E1_VALOR//nSaldo
			
	EndIf

	PUB->(dbSkip())
		
EndDo
	
dbCloseArea("PUB")
	
Return nTotal


//------------------------------------------------------------------------------------------
/*
Calcula o total dos titulos enviados para global na data.

@author    Gustavo Costa
@version   1.xx
@since     05/02/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fTotEnvGlo(d2)	

local lRet		:= .F.
Local nTotal	:= 0
Local cQuery	:= ""
Local nSaldo	:= 0

cQuery := " SELECT SUM(E1_SALDO) SALDO FROM SE1020 E1 "
cQuery += " WHERE E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E1_PORTADO = 'COB' "
cQuery += " AND E1_DATABOR = '" + DtoS(d2) + "' "

If Select("GLO") > 0
	DbSelectArea("GLO")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "GLO"
dbselectArea("GLO")
dbGoTop("GLO")

While GLO->(!EOF())
		
	nTotal := GLO->SALDO

	GLO->(dbSkip())
		
EndDo
	
dbCloseArea("GLO")
	
Return nTotal


//------------------------------------------------------------------------------------------
/*
Calcula o valor em aberto do setor publico até a data.

@author    Gustavo Costa
@version   1.xx
@since     05/02/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fTotGlo(d1)	

Local nTotal	:= 0
Local cQuery	:= ""
Local nSaldo	:= 0


cQuery := " SELECT E1.* FROM SE1020 E1 " 
cQuery += " WHERE E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E1_PORTADO = 'COB' "
cQuery += " AND E1_VENCREA < '" + DtoS(d1) + "' " 
cQuery += " AND ( E1_BAIXA = '' OR E1_BAIXA >= '" + DtoS(d1) + "' ) "
cQuery += " ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA "

If Select("GLO") > 0
	DbSelectArea("GLO")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "GLO"
dbselectArea("GLO")
dbGoTop("GLO")

While GLO->(!EOF())
		
	//Verifica se foi baixado
	//If !fBaixado(XXTM->E1_FILIAL, XXTM->E1_PREFIXO, XXTM->E1_NUM, XXTM->E1_PARCELA, XXTM->E1_TIPO, XXTM->E1_CLIENTE, XXTM->E1_LOJA, d1)
	nSaldo := SaldoTit(GLO->E1_PREFIXO,GLO->E1_NUM,GLO->E1_PARCELA,GLO->E1_TIPO,GLO->E1_NATUREZ,"R",;
							 GLO->E1_CLIENTE,1,StoD(GLO->E1_VENCREA),d1,GLO->E1_LOJA,GLO->E1_FILIAL,,1)
	
	If nSaldo > 0
		//MsgAlert("PRE" + XXTM->E1_PREFIXO + " NUM " + XXTM->E1_NUM + " PARC " + XXTM->E1_PARCELA + " TIPO " + XXTM->E1_TIPO + " VALOR " + Transform(nSaldo, "@E 999,999,999.99"))
		nTotal 	:= nTotal + GLO->E1_VALOR//nSaldo
			
	EndIf

	GLO->(dbSkip())
		
EndDo
	
dbCloseArea("GLO")
	
Return nTotal

//------------------------------------------------------------------------------------------
/*
Calcula o valor que saiu da meta das cobradoras.

@author    Gustavo Costa
@version   1.xx
@since     02/04/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fSaiMeta( d1 )

local lRet		:= .F.
Local aret		:= {}
Local nTotal	:= 0
Local nTotalA1	:= 0
Local nTotalA2	:= 0
Local nTotalX	:= 0
Local nTotalP	:= 0
Local cQuery	:= ""
Local aMedias	:= {}
Local nDias		:= 0
Local nSaldo	:= 0
Local cArea1	:= SUPERGETMV("MV_XAREA1",,"AL#BA#CE#PE#RN#SE")
Local cArea2	:= SUPERGETMV("MV_XAREA2",,"AC#AM#AP#DF#ES#GO#MA#MG#MS#MT#PA#PB#PI#PR#RJ#RO#RR#RS#SC#SP")

cQuery := " SELECT E1.*, A1_EST FROM SE1020 E1 " 
cQuery += " INNER JOIN SA1010 A1 "
cQuery += " ON E1_CLIENTE = A1_COD " 
cQuery += " AND E1_LOJA = A1_LOJA "
cQuery += " WHERE E1.D_E_L_E_T_ <> '*' "
cQuery += " AND A1_SATIV1 <> '000009' "
cQuery += " AND E1_VENCREA = '" + DtoS(d1 - 32) + "' " 
cQuery += " AND E1_TIPO NOT IN ('NCC','RA','JR','DC','CP','MT','XX') "
cQuery += " AND E1_PORTADO NOT IN ('COB') "
cQuery += " ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA "

If Select("XXTM") > 0
	DbSelectArea("XXTM")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XXTM"
dbselectArea("XXTM")
dbGoTop("XXTM")

While XXTM->(!EOF())
	
	//Verifica se foi baixado
	//If !fBaixado(XXTM->E1_FILIAL, XXTM->E1_PREFIXO, XXTM->E1_NUM, XXTM->E1_PARCELA, XXTM->E1_TIPO, XXTM->E1_CLIENTE, XXTM->E1_LOJA, d1)
	nSaldo := SaldoTit(XXTM->E1_PREFIXO,XXTM->E1_NUM,XXTM->E1_PARCELA,XXTM->E1_TIPO,XXTM->E1_NATUREZ,"R",;
						 XXTM->E1_CLIENTE,1,StoD(XXTM->E1_VENCREA),d1,XXTM->E1_LOJA,XXTM->E1_FILIAL,,1)
	
	If nSaldo > 0
		//MsgAlert("PRE" + XXTM->E1_PREFIXO + " NUM " + XXTM->E1_NUM + " PARC " + XXTM->E1_PARCELA + " TIPO " + XXTM->E1_TIPO + " VALOR " + Transform(nSaldo, "@E 999,999,999.99"))
		nTotalP 	:= nTotalP + XXTM->E1_VALOR//nSaldo
		nTotal 	:= nTotal + XXTM->E1_VALOR//nSaldo
		
		If Alltrim(XXTM->E1_PREFIXO) == "0"
		
			IF Alltrim(XXTM->A1_EST) $ cArea2 // AC#AM#AP#DF#ES#GO#MA#MG#MS#MT#PA#PB#PI#PR#RJ#RO#RR#RS#SC#SP
	
				nTotalA2 	:= nTotalA2 + XXTM->E1_VALOR
			
			ElseIf Alltrim(XXTM->A1_EST) $ cArea1 // AL#BA#CE#PE#RN#SE + XDD
	
				nTotalA1 	:= nTotalA1 + XXTM->E1_VALOR
			
			EndIf
		Else
		
			nTotalX 	:= nTotalX + XXTM->E1_VALOR // AL#BA#CE#RN#SE + XDD
		
		EndIf

		//soma a base 
	EndIf

	XXTM->(dbSkip())
	
EndDo

dbCloseArea("XXTM")
	

AADD(aRet, nTotalA1 )//Area1
AADD(aRet, nTotalA2 )//Area2
AADD(aRet, nTotalX )//XDD

Return aRet

//------------------------------------------------------------------------------------------
/*
Calcula o valor que entrou na meta das cobradoras.

@author    Gustavo Costa
@version   1.xx
@since     02/04/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fEntMeta( d1 )

local lRet		:= .F.
Local aret		:= {}
Local nTotal	:= 0
Local nTotalA1	:= 0
Local nTotalA2	:= 0
Local nTotalX	:= 0
Local nTotalP	:= 0
Local cQuery	:= ""
Local aMedias	:= {}
Local nDias		:= 0
Local nSaldo	:= 0
Local cArea1	:= SUPERGETMV("MV_XAREA1",,"AL#BA#CE#RN#SE")
Local cArea2	:= SUPERGETMV("MV_XAREA2",,"AC#AM#AP#DF#ES#GO#MA#MG#MS#MT#PA#PB#PE#PI#PR#RJ#RO#RR#RS#SC#SP")

cQuery := " SELECT E1.*, A1_EST FROM SE1020 E1 " 
cQuery += " INNER JOIN SA1010 A1 "
cQuery += " ON E1_CLIENTE = A1_COD " 
cQuery += " AND E1_LOJA = A1_LOJA "
cQuery += " WHERE E1.D_E_L_E_T_ <> '*' "
cQuery += " AND A1_SATIV1 <> '000009' "
cQuery += " AND E1_VENCREA = '" + DtoS(d1 - 1) + "' " 
cQuery += " AND E1_TIPO NOT IN ('NCC','RA','JR','DC','CP','MT','XX') "
cQuery += " AND E1_PORTADO NOT IN ('COB') "
cQuery += " ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA "

If Select("XXTM") > 0
	DbSelectArea("XXTM")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XXTM"
dbselectArea("XXTM")
dbGoTop("XXTM")

While XXTM->(!EOF())
	
	//Verifica se foi baixado
	//If !fBaixado(XXTM->E1_FILIAL, XXTM->E1_PREFIXO, XXTM->E1_NUM, XXTM->E1_PARCELA, XXTM->E1_TIPO, XXTM->E1_CLIENTE, XXTM->E1_LOJA, d1)
	nSaldo := SaldoTit(XXTM->E1_PREFIXO,XXTM->E1_NUM,XXTM->E1_PARCELA,XXTM->E1_TIPO,XXTM->E1_NATUREZ,"R",;
						 XXTM->E1_CLIENTE,1,StoD(XXTM->E1_VENCREA),d1,XXTM->E1_LOJA,XXTM->E1_FILIAL,,1)
	
	If nSaldo > 0
		//MsgAlert("PRE" + XXTM->E1_PREFIXO + " NUM " + XXTM->E1_NUM + " PARC " + XXTM->E1_PARCELA + " TIPO " + XXTM->E1_TIPO + " VALOR " + Transform(nSaldo, "@E 999,999,999.99"))
		nTotalP 	:= nTotalP + XXTM->E1_VALOR//nSaldo
		nTotal 	:= nTotal + XXTM->E1_VALOR//nSaldo
		
		If Alltrim(XXTM->E1_PREFIXO) == "0"
		
			IF Alltrim(XXTM->A1_EST) $ cArea2 // AC#AM#AP#DF#ES#GO#MA#MG#MS#MT#PA#PB#PE#PI#PR#RJ#RO#RR#RS#SC#SP
	
				nTotalA2 	:= nTotalA2 + XXTM->E1_VALOR
			
			ElseIf Alltrim(XXTM->A1_EST) $ cArea1 // AL#BA#CE#RN#SE + XDD
	
				nTotalA1 	:= nTotalA1 + XXTM->E1_VALOR
			
			EndIf
		Else
		
			nTotalX 	:= nTotalX + XXTM->E1_VALOR // AL#BA#CE#RN#SE + XDD
		
		EndIf

		//soma a base 
	EndIf

	XXTM->(dbSkip())
	
EndDo

dbCloseArea("XXTM")
	

AADD(aRet, nTotalA1 )//Area1
AADD(aRet, nTotalA2 )//Area2
AADD(aRet, nTotalX )//XDD

Return aRet

