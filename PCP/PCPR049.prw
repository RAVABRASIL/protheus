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
±±³Programa  ³PCPR049    ³ Autor ³ Gustavo Costa        ³ Data ³06.03.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio PLANO DE PRODUCAO                                  .³±±
±±³          ³  LINHA                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPR049()

Local oReport
Local cPerg	:= "PCPR49"
//criaSx1(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Pergunte(cPerg,.T.)

//oReport:= ReportDef()
//oReport:PrintDialog()
geraExcel()

Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data Base de?'     	  	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data Base até?'	  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
//putSx1(cPerg, '03', 'Representante?'     		, '', '', 'mv_ch3', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})
//putSx1(cPerg, '04', 'Estado?'	     			, '', '', 'mv_ch4', 'C', 2                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})

return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FISR001  ³ Autor ³ Gustavo Costa          ³ Data ³20.09.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de Plano de Producao.                              .³±±
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
Local cQry

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

oReport:= TReport():New("PCPR49","Relatorio do Plano de Produção","PCPR49", {|oReport| ReportPrint(oReport)},"Este relatório irá imprimir o Plano de Produção.")
oReport:SetLandscape()
//oReport:SetPortrait()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Data de                ³
//³ mv_par02   // Data Até               ³
//³ mv_par03   // Vendedor               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Pergunte(oReport:uParam,.T.)

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

oSection1 := TRSection():New(oReport,"Plano de Produção em " + DtoC(dDataBase) ,{"TAB"}) 

TRCell():New(oSection1,'XFIL'		,'','Fil.'			,	/*Picture*/				,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PROD'		,'','Produto'		,	/*Picture*/				,15				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ESPE'		,'','Espessura'	  	,	/*Picture*/				,05				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'COR'		,'','Cor'			,	/*Picture*/				,15				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'KGPLAN'		,'','Volume'		,"@E 9,999,999.99"	,12				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'KGPLANP'	,'','% Esp X Cor'	,"@E 9,999,999.99"	,12				,/*lPixel*/,/*{|| code-block de impressao }*/)

cQry:=" SELECT DISTINCT G1C.G1_COMP PROD FROM SG1020 G1 "
cQry+=" INNER JOIN SB1010 B1 "
cQry+=" ON G1.G1_COD = B1.B1_COD "
cQry+=" INNER JOIN SB1010 B1C "
cQry+=" ON G1.G1_COMP = B1C.B1_COD "
cQry+=" INNER JOIN SG1020 G1C "
cQry+=" ON G1.G1_COMP = G1C.G1_COD "
cQry+=" INNER JOIN SB1010 B1CC "
cQry+=" ON G1C.G1_COMP = B1CC.B1_COD "
cQry+=" AND G1.D_E_L_E_T_ <> '*' "
cQry+=" AND B1.D_E_L_E_T_ <> '*' "
cQry+=" AND B1C.D_E_L_E_T_ <> '*' "
cQry+=" AND B1CC.D_E_L_E_T_ <> '*' "
cQry+=" AND G1C.D_E_L_E_T_ <> '*' "
cQry+=" AND B1C.B1_TIPO = 'PI' "
cQry+=" AND B1CC.B1_TIPO = 'MP' "
cQry+=" AND B1.B1_COD IN ( SELECT ZZ5_PROD FROM ZZ5020 WHERE D_E_L_E_T_ <> '*' ) "

TCQUERY cQry NEW ALIAS  "XEST"

dbSelectArea("XEST")
XEST->(dbGoTop())

While XEST->(!Eof())
	
	TRCell():New(oSection1,AllTrim(XEST->PROD)  ,'',AllTrim(XEST->PROD)	,"@E 9,999,999.99",12	,/*lPixel*/,/*{|| code-block de impressao }*/)
	
	XEST->(dbSkip())

endDo
//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

oBreak := TRBreak():New(oSection1,oSection1:Cell("XFIL"),"Total",.F.)

TRFunction():New(oSection1:Cell("KGPLAN"),NIL,"SUM",oBreak,"Total Líquido","@E 9,999,999.99",/*uFormula*/,.F.,.F.,.F.,oSection1)
XEST->(dbGoTop())

While XEST->(!Eof())
	
	TRFunction():New(oSection1:Cell(AllTrim(XEST->PROD)),NIL,"SUM",oBreak,"Total Líquido","@E 9,999,999.99",/*uFormula*/,.F.,.F.,.F.,oSection1)
	
	XEST->(dbSkip())

endDo

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

//Static Function ReportPrint(oReport)

Static Function geraExcel()

//Local oSection1 	:= oReport:Section(1)
Local cQuery 		:= ""
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local lContinua 	:= .T.
Local aFds 		:= {}
Local aMeta		:= {}
Local cLinha	:= ""
Local nTotalPP	:= 0	
//Local nMeses	:= round((mv_par02 - mv_par01)/30, 0)

//******************************
// Monta a tabela temporária
//******************************
cQry:=" SELECT DISTINCT G1C.G1_COMP PROD, B1CC.B1_DESC DESCRI FROM SG1020 G1 "
cQry+=" INNER JOIN SB1010 B1 "
cQry+=" ON G1.G1_COD = B1.B1_COD "
cQry+=" INNER JOIN SB1010 B1C "
cQry+=" ON G1.G1_COMP = B1C.B1_COD "
cQry+=" INNER JOIN SG1020 G1C "
cQry+=" ON G1.G1_COMP = G1C.G1_COD "
cQry+=" INNER JOIN SB1010 B1CC "
cQry+=" ON G1C.G1_COMP = B1CC.B1_COD "
cQry+=" AND G1.D_E_L_E_T_ <> '*' "
cQry+=" AND B1.D_E_L_E_T_ <> '*' "
cQry+=" AND B1C.D_E_L_E_T_ <> '*' "
cQry+=" AND B1CC.D_E_L_E_T_ <> '*' "
cQry+=" AND G1C.D_E_L_E_T_ <> '*' "
cQry+=" AND B1C.B1_TIPO = 'PI' "
cQry+=" AND B1CC.B1_TIPO = 'MP' "
cQry+=" AND B1.B1_COD IN ( SELECT ZZ5_PROD FROM ZZ5020 WHERE D_E_L_E_T_ <> '*' ) "

cQry += " UNION "

cQry += " SELECT DISTINCT G1D.G1_COMP PROD, B1D.B1_DESC DESCRI FROM SG1020 G1 " 
cQry += " INNER JOIN SB1010 B1 " 
cQry += " ON G1.G1_COD = B1.B1_COD " 
cQry += " INNER JOIN SB1010 B1C  "
cQry += " ON G1.G1_COMP = B1C.B1_COD " 
cQry += " INNER JOIN SG1020 G1C " 
cQry += " ON G1.G1_COMP = G1C.G1_COD  "
cQry += " INNER JOIN SB1010 B1CC  "
cQry += " ON G1C.G1_COMP = B1CC.B1_COD " 
cQry += " INNER JOIN SG1020 G1D " 
cQry += " ON G1C.G1_COMP = G1D.G1_COD  "
cQry += " INNER JOIN SB1010 B1D  "
cQry += " ON G1D.G1_COMP = B1D.B1_COD  "
cQry += " AND G1.D_E_L_E_T_ <> '*'  "
cQry += " AND B1.D_E_L_E_T_ <> '*'  "
cQry += " AND B1C.D_E_L_E_T_ <> '*' " 
cQry += " AND B1CC.D_E_L_E_T_ <> '*' " 
cQry += " AND G1C.D_E_L_E_T_ <> '*' " 
cQry += " AND B1D.D_E_L_E_T_ <> '*' " 
cQry += " AND G1D.D_E_L_E_T_ <> '*' " 
cQry += " AND B1C.B1_TIPO = 'PI' " 
cQry += " AND B1CC.B1_TIPO IN ('PI') "  
cQry += " AND G1.G1_TRT <= '001'  " 
cQry += " AND B1.B1_COD IN ( SELECT ZZ5_PROD FROM ZZ5020 WHERE D_E_L_E_T_ <> '*' ) "

TCQUERY cQry NEW ALIAS  "XEST"

dbSelectArea("XEST")
XEST->(dbGoTop())

Aadd( aFds , {"PROD"		,"C",015,000} )
Aadd( aFds , {"ESPE"		,"N",008,006} )
Aadd( aFds , {"COR"			,"C",015,000} )
Aadd( aFds , {"KGPLAN"		,"N",012,002} )
Aadd( aFds , {"KGPLANP"		,"N",012,002} )


dbSelectArea("XEST")
XEST->(dbGoTop())

While XEST->(!Eof())
	
	Aadd( aFds , {AllTrim(XEST->PROD)	,"N",012,002} )
	
	XEST->(dbSkip())

endDo

coTbl := CriaTrab( aFds, .T. )
//Ind1 := CriaTrab( NIL, .F. )
//Ind2 := CriaTrab( NIL, .F. )
Use (coTbl) Alias TAB New Exclusive
dbCreateIndex(coTbl,'PROD', {|| PROD })
//dbCreateIndex(Ind2,'ESPE', {|| ESPE })

//***********************************
// Monta a tabela de vendas por NCM
//***********************************

cQuery := " SELECT ZZ5_PROD, ZZ5_PLAPRO, B5_ESPESS FROM ZZ5020 Z " 
cQuery += " INNER JOIN SB5010 B "
cQuery += " ON ZZ5_PROD = B5_COD "
cQuery += " WHERE Z.D_E_L_E_T_ <> '*' "
cQuery += " AND B.D_E_L_E_T_ <> '*' "  

If Select("TMP1") > 0
	DbSelectArea("TMP1")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP1"

TMP1->( DbGoTop() )

//******************************
//PREENCHE COM O PLANEJADO
//******************************
While TMP1->(!Eof())
	
	RecLock("TAB",.T.)
	
	Do Case
		case SubStr(TMP1->ZZ5_PROD,3,1) == "A"
			cCor := "AZUL"
		case SubStr(TMP1->ZZ5_PROD,3,1) == "B"
			cCor := "BRANCO"
		case SubStr(TMP1->ZZ5_PROD,3,1) == "C"
			cCor := "PRETO"
		case SubStr(TMP1->ZZ5_PROD,3,1) == "D"
			cCor := "VERMELHO"
		case SubStr(TMP1->ZZ5_PROD,3,1) == "E"
			cCor := "AMARELO"
		case SubStr(TMP1->ZZ5_PROD,3,1) == "F"
			cCor := "VERDE"
		case SubStr(TMP1->ZZ5_PROD,3,1) == "G"
			cCor := "CINZA"
	EndCase
	
	Replace TAB->PROD 		with TMP1->ZZ5_PROD
	Replace TAB->ESPE 		with TMP1->B5_ESPESS//Alltrim(STR(TMP1->B5_ESPESS))
	Replace TAB->COR 		with cCor
	Replace TAB->KGPLAN 	with TMP1->ZZ5_PLAPRO 
	Replace TAB->KGPLANP	with 0
	
	nTotalPP := nTotalPP + TMP1->ZZ5_PLAPRO
	
	MsUnlock()
	TMP1->(dbSkip())

EndDo

TMP1->(DbCloseArea())

//******************************
//ATUALIZA % PLANEJADO
//******************************
TAB->( DbGoTop() )
While TAB->(!Eof())
	
	RecLock("TAB",.F.)
	
	Replace TAB->KGPLANP	with ((TAB->KGPLAN / nTotalPP)*100)
	
	MsUnlock()
	TAB->(dbSkip())

EndDo



cQuery := " SELECT DISTINCT G1.G1_COD PROD, G1.G1_COMP CODPI, G1C.G1_COMP CODMP, B1CC.B1_DESC, G1C.G1_QUANT QUANT FROM SG1020 G1 "
cQuery += " INNER JOIN SB1010 B1 "
cQuery += " ON G1.G1_COD = B1.B1_COD "
cQuery += " INNER JOIN SB1010 B1C "
cQuery += " ON G1.G1_COMP = B1C.B1_COD "
cQuery += " INNER JOIN SG1020 G1C "
cQuery += " ON G1.G1_COMP = G1C.G1_COD "
cQuery += " INNER JOIN SB1010 B1CC "
cQuery += " ON G1C.G1_COMP = B1CC.B1_COD "
cQuery += " AND G1.D_E_L_E_T_ <> '*' "
cQuery += " AND B1.D_E_L_E_T_ <> '*' "
cQuery += " AND B1C.D_E_L_E_T_ <> '*' "
cQuery += " AND B1CC.D_E_L_E_T_ <> '*' "
cQuery += " AND G1C.D_E_L_E_T_ <> '*' "
cQuery += " AND B1C.B1_TIPO = 'PI' "
cQuery += " AND B1CC.B1_TIPO = 'MP'  "
cQuery += " AND G1.G1_TRT <= '001'  "
cQuery += " AND B1.B1_COD IN ( SELECT ZZ5_PROD FROM ZZ5020 WHERE D_E_L_E_T_ <> '*' ) "

cQuery += " UNION "

cQuery += " SELECT DISTINCT G1.G1_COD PROD, G1.G1_COMP CODPI, G1D.G1_COMP CODMP, B1D.B1_DESC, G1D.G1_QUANT QUANT FROM SG1020 G1 " 
cQuery += " INNER JOIN SB1010 B1 " 
cQuery += " ON G1.G1_COD = B1.B1_COD " 
cQuery += " INNER JOIN SB1010 B1C  "
cQuery += " ON G1.G1_COMP = B1C.B1_COD " 
cQuery += " INNER JOIN SG1020 G1C " 
cQuery += " ON G1.G1_COMP = G1C.G1_COD  "
cQuery += " INNER JOIN SB1010 B1CC  "
cQuery += " ON G1C.G1_COMP = B1CC.B1_COD " 
cQuery += " INNER JOIN SG1020 G1D " 
cQuery += " ON G1C.G1_COMP = G1D.G1_COD  "
cQuery += " INNER JOIN SB1010 B1D  "
cQuery += " ON G1D.G1_COMP = B1D.B1_COD  "
cQuery += " AND G1.D_E_L_E_T_ <> '*'  "
cQuery += " AND B1.D_E_L_E_T_ <> '*'  "
cQuery += " AND B1C.D_E_L_E_T_ <> '*' " 
cQuery += " AND B1CC.D_E_L_E_T_ <> '*' " 
cQuery += " AND G1C.D_E_L_E_T_ <> '*' " 
cQuery += " AND B1D.D_E_L_E_T_ <> '*' " 
cQuery += " AND G1D.D_E_L_E_T_ <> '*' " 
cQuery += " AND B1C.B1_TIPO IN ('PI','IS') " 
cQuery += " AND B1CC.B1_TIPO IN ('PI') "  
cQuery += " AND G1.G1_TRT <= '001'  " 
cQuery += " AND B1.B1_COD IN ( SELECT ZZ5_PROD FROM ZZ5020 WHERE D_E_L_E_T_ <> '*' ) "

If Select("TMP2") > 0
	DbSelectArea("TMP2")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP2"

TMP2->( DbGoTop() )

//******************************
//PREENCHE COM O PERCENTUAL DA ESRTUTURA
//******************************
While TMP2->(!Eof())
	
	If TAB->(dbSeek(TMP2->PROD))
	
		RecLock("TAB",.F.)
		cCampo	:= "TAB->" + AllTrim(TMP2->CODMP)
		
		Replace &cCampo 	with TMP2->QUANT
		
		MsUnlock()

	EndIf

	TMP2->(dbSkip())

EndDo

TMP2->(DbCloseArea())

TAB->( DbGoTop() )

Processa({|| expExcel()},"Aguarde","Exportando para Excel...") 

/*
oReport:SetMeter(TAB->(RecCount()))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1:Init()
//oReport:SkipLine()     
//oReport:Say(oReport:Row(),oReport:Col(),"PERÍODO de " + DtoC(mv_par01) + " até " + DtoC(mv_par02) )
oSection1:PrintLine()
oReport:SkipLine()
oReport:ThinLine()

While !oReport:Cancel() .And. TAB->(!Eof())

	oReport:IncMeter()

	oSection1:Cell("XFIL"):SetValue("01")
	oSection1:Cell("XFIL"):SetAlign("CENTER")
	oSection1:Cell("PROD"):SetValue(TAB->PROD)
	oSection1:Cell("PROD"):SetAlign("CENTER")
	oSection1:Cell("ESPE"):SetValue(TAB->ESPE)
	oSection1:Cell("ESPE"):SetAlign("RIGHT")
	oSection1:Cell("COR"):SetValue(TAB->COR)
	oSection1:Cell("COR"):SetAlign("CENTER")
	oSection1:Cell("KGPLAN"):SetValue(TAB->KGPLAN)
	oSection1:Cell("KGPLAN"):SetAlign("RIGHT")
	oSection1:Cell("KGPLANP"):SetValue(TAB->KGPLANP)
	oSection1:Cell("KGPLANP"):SetAlign("RIGHT")

	XEST->( DbGoTop() )
	
	//******************************
	//PREENCHE COM O PLANEJADO
	//******************************
	While XEST->(!Eof())
		
		cCampo	:= "TAB->" + AllTrim(XEST->PROD)
		
		oSection1:Cell(AllTrim(XEST->PROD)):SetValue(&cCampo)
		oSection1:Cell(AllTrim(XEST->PROD)):SetAlign("RIGHT")
		XEST->(dbSkip())
	
	EndDo

	oSection1:PrintLine()
	//oReport:SkipLine()     
	TAB->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TAB")
dbCloseArea("XEST")

Set Filter To
*/

Return

Static Function expExcel()

	Local oFWMsExcel
	Local oExcel
	Local cArquivo	:= GetTempPath()+'PCPR49.xml'
	Local aDados	:= {}
	Local nTotalCol	:= 0
	Local nTotalG	:= 0

	//Criando o objeto que irá gerar o conteúdo do Excel
	oFWMsExcel := FWMSExcel():New()
	
		//***************************
		//PRIMEIRA ABA
		//***************************
	//Aba 01 - Teste
	oFWMsExcel:AddworkSheet("CONSUMO") //Não utilizar número junto com sinal de menos. Ex.: 1-
		//Criando a Tabela
		oFWMsExcel:AddTable("CONSUMO","Plano de Producao")
		//Criando Colunas
		//FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)-> NIL
		oFWMsExcel:AddColumn("CONSUMO","Plano de Producao","Fil",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("CONSUMO","Plano de Producao","Codigo",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("CONSUMO","Plano de Producao","Espessura",2,1) //2 = Valor sem R$
		oFWMsExcel:AddColumn("CONSUMO","Plano de Producao","Cor",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("CONSUMO","Plano de Producao","Volume",3,2,.T.)
		oFWMsExcel:AddColumn("CONSUMO","Plano de Producao","% Volume",3,2) //2 = Valor sem R$
		
		dbSelectArea("XEST")
		XEST->( DbGoTop() )
	
		While XEST->(!Eof())
			
			//cCampo	:= "TAB->" + AllTrim(XEST->PROD)
			
			oFWMsExcel:AddColumn("CONSUMO","Plano de Producao",AllTrim(XEST->PROD),3,2,.T.)
			
			XEST->(dbSkip())
		
		EndDo
		
		//oFWMsExcel:AddColumn("CONSUMO","Titulo Tabela","% Fat X Geral",3,3) //3 = Valor com R$
		//Criando as Linhas
		dbSelectArea("TAB")
		While !(TAB->(EoF()))
		
			AADD(adados,"01")
			AADD(adados,TAB->PROD)
			AADD(adados,TAB->ESPE)
			AADD(adados,TAB->COR)
			AADD(adados,TAB->KGPLAN)
			AADD(adados,TAB->KGPLANP)
			
			nTotalG	:= nTotalG + TAB->KGPLAN
			
			dbSelectArea("XEST")
			XEST->( DbGoTop() )
	
			While XEST->(!Eof())
				
				cCampo	:= "TAB->" + AllTrim(XEST->PROD)
				
				AADD(adados,&cCampo)
				
				XEST->(dbSkip())
			
			EndDo
			dbSelectArea("TAB")
			oFWMsExcel:AddRow("CONSUMO","Plano de Producao",aDados)
			
			aDados	:= {}
			//Pulando Registro
			TAB->(DbSkip())
		EndDo
		
		//***************************
		//SEGUNDA ABA
		//***************************
		
		aDados		:= {}
		
		oFWMsExcel:AddworkSheet("RESUMO") //Não utilizar número junto com sinal de menos. Ex.: 1-
		//Criando a Tabela
		oFWMsExcel:AddTable("RESUMO","Consumo Mes")
		//Criando Colunas
		oFWMsExcel:AddColumn("RESUMO","Consumo Mes","Codigo",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("RESUMO","Consumo Mes","Produto",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("RESUMO","Consumo Mes","UM",1,1) //1 = Modo Texto
		oFWMsExcel:AddColumn("RESUMO","Consumo Mes","Previsao",3,2,.T.)
		oFWMsExcel:AddColumn("RESUMO","Consumo Mes","Saldo",3,2,.T.) 
		
		dbSelectArea("XEST")
		XEST->( DbGoTop() )
		While XEST->(!Eof())
				
			cCampo	:= "TAB->" + AllTrim(XEST->PROD)
				
			AADD(adados,AllTrim(XEST->PROD))
			AADD(adados,XEST->DESCRI)
			AADD(adados,"KG")
				
			dbSelectArea("TAB")
			TAB->( DbGoTop() )
			While !(TAB->(EoF()))
				
				If &cCampo <= 1
					nTotalCol := nTotalCol + ( &cCampo * TAB->KGPLAN )
				Else
					nTotalCol := nTotalCol + (((&cCampo)/100) * TAB->KGPLAN )
				EndIf
		
				TAB->(DbSkip())
			EndDo
			AADD(adados,nTotalCol)
			AADD(adados,POSICIONE("SB2",1,xFilial("SB2") + AllTrim(XEST->PROD),"B2_QATU"))
			
			oFWMsExcel:AddRow("RESUMO","Consumo Mes",aDados)
			
			nTotalCol 	:= 0
			aDados		:= {}
			
			dbSelectArea("XEST")	
			XEST->(dbSkip())
			
		EndDo

		
	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)
		
	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New() 			//Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo) 	//Abre uma planilha
	oExcel:SetVisible(.T.) 				//Visualiza a planilha
	oExcel:Destroy()						//Encerra o processo do gerenciador de tarefas
	
	//QRYPRO->(DbCloseArea())
	//RestArea(aArea)


TAB->(dbCloseArea())
XEST->(dbCloseArea())
	
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
/*
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
*/
