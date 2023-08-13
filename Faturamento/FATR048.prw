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
±±³Programa  ³FATR048    ³ Autor ³ Gustavo Costa        ³ Data ³06.03.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio COMPARATIVO DOS REPRESENTANTES META REALIZADO POR  .³±±
±±³          ³  LINHA                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR048()

Local oReport
Local cPerg	:= "FATR48"
criaSx1(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.T.)

oReport:= ReportDef()
oReport:PrintDialog()


Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data Base de?'     	  	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data Base até?'	  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
putSx1(cPerg, '03', 'Representante?'     		, '', '', 'mv_ch3', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})
putSx1(cPerg, '04', 'Coordenador?'     			, '', '', 'mv_ch4', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})

return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FISR001  ³ Autor ³ Gustavo Costa          ³ Data ³20.09.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio dos valores para conferencia da desoneração.     .³±±
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

oReport:= TReport():New("FATR48","Comparativo Representante Meta x Realizado","FATR48", {|oReport| ReportPrint(oReport)},"Este relatório irá imprimir o Comparativo Representante Meta x Realizado.")
//oReport:SetLandscape()
oReport:SetPortrait()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Data de                ³
//³ mv_par02   // Data Até               ³
//³ mv_par03   // Vendedor               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(oReport:uParam,.T.)

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

oSection1 := TRSection():New(oReport,"PERÍODO de " + DtoC(mv_par01) + " até " + DtoC(mv_par02),{"TAB"}) 

TRCell():New(oSection1,'ATV'		,'','Ativo'			,	/*Picture*/		,03				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'REP'		,'','Cod.'			,	/*Picture*/		,04				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NREP'		,'','Representante'	,	/*Picture*/		,20				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EST'		,'','UF'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'LINHA'		,'','Linha'			,	/*Picture*/		,15				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'METAKG'    	,'','Meta KG'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'METAPV'		,'','Meta PV'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'METARS'		,'','Meta R$'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'REALKG'		,'','Real KG'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'REALPV'		,'','Real PV'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'REALRS'		,'','Real R$'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PERCKG'		,'','% KG'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PERCPV'		,'','% PV'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PERCRS'		,'','% R$'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("REP"),"Total",.F.)


//TRFunction():New(oSection1:Cell("METAKG"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("METAPV"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("METARS"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALKG"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALPV"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALRS"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)


Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PONR003 ³ Autor ³ Gustavo Costa           ³ Data ³20.06.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
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
Local cQuery 		:= ""
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local lContinua 	:= .T.
Local aFds 		:= {}
Local aMeta		:= {}
Local cLinha	:= ""

//******************************
// Monta a tabela temporária
//******************************

Aadd( aFds , {"ATV"			,"C",003,000} )
Aadd( aFds , {"REP"			,"C",006,000} )
Aadd( aFds , {"EST"			,"C",002,000} )
Aadd( aFds , {"NREP"		,"C",020,000} )
Aadd( aFds , {"LINHA"		,"C",015,000} )
Aadd( aFds , {"METAKG" 		,"N",016,002} )
Aadd( aFds , {"METAPV"		,"N",016,002} )
Aadd( aFds , {"METARS" 		,"N",016,002} )
Aadd( aFds , {"REALKG"		,"N",016,002} )
Aadd( aFds , {"REALPV" 		,"N",016,002} )
Aadd( aFds , {"REALRS" 		,"N",016,002} )
Aadd( aFds , {"PERCKG"		,"N",016,002} )
Aadd( aFds , {"PERCPV" 		,"N",016,002} )
Aadd( aFds , {"PERCRS" 		,"N",016,002} )

coTbl := CriaTrab( aFds, .T. )
Use (coTbl) Alias TAB New Exclusive
dbCreateIndex(coTbl,'REP+EST+LINHA', {|| REP+EST+LINHA })

//***********************************
// Monta a tabela de vendas por NCM
//***********************************

cQuery := " SELECT  LEFT(F2_VEND1,4) REP, LEFT(A3_NREDUZ,20) NREP, F2_EST, A3_ATIVO, "
cQuery += "  LINHA=CASE "
cQuery += "            WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA'" 
cQuery += "            WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL'" 
cQuery += "            WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR'"           
cQuery += "            ELSE B1_GRUPO "
cQuery += "          END,"
cQuery += " SUM((D2_QUANT - D2_QTDEDEV)*D2_PESO  ) AS FAT_KG"
cQuery += " ,VALOR=SUM((D2_QUANT - D2_QTDEDEV)*D2_PRCVEN)"
cQuery += " FROM SD2020 SD2 WITH (NOLOCK)"
cQuery += " INNER JOIN SB1010 SB1 WITH (NOLOCK)"
cQuery += " ON D2_COD = B1_COD "
cQuery += " INNER JOIN SF2020 SF2 WITH (NOLOCK)"
cQuery += " ON D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA" 
cQuery += " INNER JOIN SA3010 SA3 WITH (NOLOCK)"
cQuery += " ON F2_VEND1 = A3_COD "
cQuery += " INNER JOIN SC5020 SC5 WITH (NOLOCK) " 
cQuery += " ON D2_FILIAL + D2_PEDIDO = C5_FILIAL + C5_NUM " 
cQuery += " WHERE C5_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
If !Empty(mv_par03)
	cQuery += " AND F2_VEND1 = '" + AllTrim(mv_par03) + "' "
EndIf
If !Empty(mv_par04)
	cQuery += " AND A3_SUPER = '" + AllTrim(mv_par04) + "' "
EndIf
cQuery += " AND D2_TIPO = 'N' "
//cQuery += " AND B1_TIPO = 'PA'" 
cQuery += " AND D2_CF IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' )" 
cQuery += " AND D2_CLIENTE NOT IN ('031732','031733','006543','007005')"
cQuery += " AND SD2.D_E_L_E_T_ = '' "
cQuery += " AND SB1.D_E_L_E_T_ = '' "
cQuery += " AND SF2.D_E_L_E_T_ = '' "
cQuery += " AND SC5.D_E_L_E_T_ = '' "
cQuery += " GROUP BY LEFT(F2_VEND1,4),LEFT(A3_NREDUZ,20), F2_EST, A3_ATIVO,"
cQuery += " 		CASE "
cQuery += "            WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA'" 
cQuery += "            WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL'" 
cQuery += "            WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR'"           
cQuery += "            ELSE B1_GRUPO "
cQuery += "          END"
cQuery += " ORDER BY REP,NREP,LINHA"


If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

//******************************
//PREENCHE COM O REALIZADO
//******************************
While TMP->(!Eof())
	
	RecLock("TAB",.T.)
	
	Replace TAB->ATV 		with TMP->A3_ATIVO
	Replace TAB->EST 		with TMP->F2_EST
	Replace TAB->REP 		with TMP->REP
	Replace TAB->NREP 		with TMP->NREP
	Replace TAB->LINHA 		with TMP->LINHA
	Replace TAB->METAKG 	with 0
	Replace TAB->METAPV 	with 0
	Replace TAB->METARS 	with 0
	Replace TAB->REALKG		with TMP->FAT_KG
	Replace TAB->REALPV 	with TMP->VALOR / TMP->FAT_KG
	Replace TAB->REALRS		with TMP->VALOR
	Replace TAB->PERCKG		with 0
	Replace TAB->PERCPV 	with 0
	Replace TAB->PERCRS 	with 0
	
	MsUnlock()
	TMP->(dbSkip())

EndDo

cQuery := " SELECT Z51_REPRES, A3_NREDUZ, Z51_UF, Z51_MVALOR/12 MVALOR, Z51_MFATOR, Z51_LINHA, A3_ATIVO FROM Z51020 Z" 
cQuery += " INNER JOIN SA3010 A "
cQuery += " ON Z51_REPRES = A3_COD "
cQuery += " WHERE Z51_ANO = '" + SubStr(DtoS(mv_par01),1,4) + "' " 
cQuery += " AND Z.D_E_L_E_T_ <> '*' "
If !Empty(mv_par03)
	cQuery += " AND Z51_REPRES = '" + AllTrim(mv_par03) + "' "
EndIf
If !Empty(mv_par04)
	cQuery += " AND A3_SUPER = '" + AllTrim(mv_par04) + "' "
EndIf


If Select("TMP2") > 0
	DbSelectArea("TMP2")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP2"

TMP2->( DbGoTop() )

//******************************
//PREENCHE COM O META OS ESTADOS QUE NÃO TIVERAM VEDAS
//******************************
While TMP2->(!Eof())
	
	Do Case
		Case TMP2->Z51_LINHA = "INST"
			cLinnha := "1-INSTITUCIONAL"
		Case TMP2->Z51_LINHA = "DOME"
			cLinnha := "2-DOMESTICA"
		Case TMP2->Z51_LINHA = "HOSP"
			cLinnha := "3-HOSPITALAR"
	EndCase

	If TAB->(!dbSeek(TMP2->Z51_REPRES + TMP2->Z51_UF + cLinnha))
	
		RecLock("TAB",.T.)
		
		Replace TAB->ATV 		with TMP2->A3_ATIVO
		Replace TAB->EST 		with TMP2->Z51_UF
		Replace TAB->REP 		with TMP2->Z51_REPRES
		Replace TAB->NREP 		with TMP2->A3_NREDUZ
		Replace TAB->LINHA 		with cLinnha
		Replace TAB->METAKG 	with TMP2->MVALOR
		Replace TAB->METAPV 	with TMP2->Z51_MFATOR
		Replace TAB->METARS 	with TMP2->MVALOR * TMP2->Z51_MFATOR
		Replace TAB->REALKG		with 0
		Replace TAB->REALPV 	with 0
		Replace TAB->REALRS		with 0
		Replace TAB->PERCKG		with 0
		Replace TAB->PERCPV 	with 0
		Replace TAB->PERCRS 	with 0
		
		MsUnlock()

	EndIf

	TMP2->(dbSkip())

EndDo

TAB->( DbGoTop() )

//******************************
//PREENCHE COM O META DOS ESTADOS 
//******************************
While TAB->(!Eof())

	RecLock("TAB",.F.)
	
	Do Case	
		Case SubStr(TAB->LINHA,1,1) = "1" //instituciona
			aMeta	:= fValMeta(TAB->REP, SubStr(DtoS(mv_par01),1,4), "INST", TAB->EST)
			Replace TAB->METAKG 		with aMeta[1]
			Replace TAB->METAPV 		with aMeta[2]
			Replace TAB->METARS 		with aMeta[1] * aMeta[2]
		Case SubStr(TAB->LINHA,1,1) = "2" //domestica
			aMeta	:= fValMeta(TAB->REP, SubStr(DtoS(mv_par01),1,4), "DOME", TAB->EST)
			Replace TAB->METAKG 		with aMeta[1]
			Replace TAB->METAPV 		with aMeta[2]
			Replace TAB->METARS 		with aMeta[1] * aMeta[2]
		Case SubStr(TAB->LINHA,1,1) = "3" //hospitalar
			aMeta	:= fValMeta(TAB->REP, SubStr(DtoS(mv_par01),1,4), "HOSP", TAB->EST)
			Replace TAB->METAKG 		with aMeta[1]
			Replace TAB->METAPV 		with aMeta[2]
			Replace TAB->METARS 		with aMeta[1] * aMeta[2]
	EndCase
	
	MsUnlock()
	
	TAB->(dbSkip())

EndDo

//***********************************
// Recalcula os campos finais
//***********************************
TAB->( DbGoTop() )

While TAB->(!Eof())
	
		RecLock("TAB",.F.)
		
		Replace TAB->PERCKG		with (TAB->REALKG / TAB->METAKG) * 100
		Replace TAB->PERCPV		with (TAB->REALPV / TAB->METAPV) * 100
		Replace TAB->PERCRS 	with (TAB->REALRS / TAB->METARS) * 100
		
		MsUnlock()
	
	TAB->(dbSkip())

EndDo

TAB->( DbGoTop() )
oReport:SetMeter(TAB->(RecCount()))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1:Init()
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:Say(oReport:Row(),oReport:Col(),"PERÍODO de " + DtoC(mv_par01) + " até " + DtoC(mv_par02) )
oSection1:PrintLine()
oReport:SkipLine()
oReport:ThinLine()


While !oReport:Cancel() .And. TAB->(!Eof())

	oReport:IncMeter()

	oSection1:Cell("ATV"):SetValue(IIF(TAB->ATV="S","SIM","NAO"))
	oSection1:Cell("ATV"):SetAlign("CENTER")
	oSection1:Cell("EST"):SetValue(TAB->EST)
	oSection1:Cell("EST"):SetAlign("CENTER")
	oSection1:Cell("REP"):SetValue(TAB->REP)
	oSection1:Cell("REP"):SetAlign("LEFT")
	oSection1:Cell("NREP"):SetValue(TAB->NREP)
	oSection1:Cell("NREP"):SetAlign("LEFT")
	oSection1:Cell("LINHA"):SetValue(TAB->LINHA)
	oSection1:Cell("LINHA"):SetAlign("LEFT")
	oSection1:Cell("METAKG"):SetValue(TAB->METAKG)
	oSection1:Cell("METAKG"):SetAlign("RIGHT")
	oSection1:Cell("METAPV"):SetValue(TAB->METAPV)
	oSection1:Cell("METAPV"):SetAlign("RIGHT")
	oSection1:Cell("METARS"):SetValue(TAB->METARS)
	oSection1:Cell("METARS"):SetAlign("RIGHT")
	oSection1:Cell("REALKG"):SetValue(TAB->REALKG)
	oSection1:Cell("REALKG"):SetAlign("RIGHT")
	oSection1:Cell("REALPV"):SetValue(TAB->REALPV)
	oSection1:Cell("REALPV"):SetAlign("RIGHT")
	oSection1:Cell("REALRS"):SetValue(TAB->REALRS)
	oSection1:Cell("REALRS"):SetAlign("RIGHT")
	oSection1:Cell("PERCKG"):SetValue(TAB->PERCKG)
	oSection1:Cell("PERCKG"):SetAlign("RIGHT")
	oSection1:Cell("PERCPV"):SetValue(TAB->PERCPV)
	oSection1:Cell("PERCPV"):SetAlign("RIGHT")
	oSection1:Cell("PERCRS"):SetValue(TAB->PERCRS)
	oSection1:Cell("PERCRS"):SetAlign("RIGHT")
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TAB->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TAB")
dbCloseArea("TMP")
dbCloseArea("TMP2")
Set Filter To

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„ção    ³ fValMeta   º Autor ³ Gustavo Costa     º Data ³  06/03/17  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Retorna o valor da meta por representante.                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fValMeta(cRep, cAno, cLinha, cUF)

local cQry		:= ''
Local aRet		:= {}

cQry:=" SELECT Z51_MVALOR/12 MVALOR, Z51_MFATOR FROM Z51020 "
cQry+=" WHERE Z51_REPRES = '" + cRep + "' "
cQry+=" AND Z51_ANO = '" + cAno + "' "
cQry+=" AND Z51_LINHA = '" + cLinha + "' "
cQry+=" AND D_E_L_E_T_ <> '*' "
cQry+=" AND Z51_UF = '" + cUF + "'"

TCQUERY cQry NEW ALIAS  "TMP3"

dbSelectArea("TMP3")
TMP3->(dbGoTop())

If Select("TMP3") > 0

	AADD(aRet, TMP3->MVALOR)
	AADD(aRet, TMP3->Z51_MFATOR)

Else

	AADD(aRet, 0)
	AADD(aRet, 0)

EndIf

TMP3->(dbclosearea())

Return aRet

