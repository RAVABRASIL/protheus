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
±±³Programa  ³FXLSSGRM    ³ Autor ³ THIAGO EWERTON      ³ Data ³10.11.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³            RELATORIO FAT POR CLIENTES                     .³±±
±±³          ³  LINHA                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function FXLSSGM()

Local oReport


oReport:= ReportDef()
oReport:PrintDialog()


Return



Static Function ReportDef()

Local oReport
Local oSection1
//Local oSection2


oReport:= TReport():New("FXLSSGRM ","RELATORIO DE SEGMENTO","FXLSSGRM", {|oReport| ReportPrint(oReport)},"RELATORIO DE SEGMENTO")
//oReport:SetLandscape()
oReport:SetPortrait()


oSection1 := TRSection():New(oReport,"ORIGEM" ,{"TAB"}) //alterar para TAB PARA SA1

//TRCell():New(oSection1,'VEN'		,'','Cod.'			,	/*Picture*/		,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'NVEN'		,'','Vendedor'		,	/*Picture*/		,30				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'CLI'		,'','Cliente'		,	/*Picture*/		,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'LOJA'		,'','Loja'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'NCLI'		,'','Nome'			,	/*Picture*/		,40				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'EST'		,'','UF'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'LINHA'		,'','Linha'			,	/*Picture*/		,20				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'MEDIA'		,'','Media 12M'		,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'MESATU'		,'','Mes Atual'		,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'CARTATU'	,'','Carteira'		,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSection1,'SEGCOD'     ,'','SEGCOD'        ,)
TRCell():New(oSection1,'SEGNOM'     ,'','SEGNOM'        ,)
TRCell():New(oSection1,'GERCOD'    ,'','GERCOD' ,)
TRCell():New(oSection1,'GERNOM'  ,'','GERNOM'      ,)
TRCell():New(oSection1,'REPCOD'  ,'','REPCOD'      ,)
TRCell():New(oSection1,'REPNOM'    ,'','REPNOM'          ,)
TRCell():New(oSection1,'UF'    ,'','UF'          ,)
TRCell():New(oSection1,'VENDIDO'    ,'','VENDIDO'          ,)
TRCell():New(oSection1,'COBERTURA'    ,'','COBERTURA'          ,)


//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("CODO"),"Produto",.F.)
//oBreak := TRBreak():New(oSection1,oSection1:Cell("REP"),"Total",.F.)
//TRFunction():New(oSection1:Cell("REALPV"),NIL,"SUM",oBreak,"Total LÃ­quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALRS"),NIL,"SUM",oBreak,"Total LÃ­quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)


Return(oReport)


Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
//Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
//Local lContinua 	:= .T.


//***********************************
// Monta a tabela de segmento
//***********************************

cQuery := "SELECT "
cQuery += "   SEGCOD, "
cQuery += "   SEGNOM, "
cQuery += "   GERCOD, GERNOM=ISNULL((SELECT RTRIM(A3_NOME) FROM SA3010 WHERE A3_COD = GERCOD AND D_E_L_E_T_ <> '*'), '' ), "
cQuery += "   REPCOD, REPNOM, "
cQuery += "   UF, "
cQuery += "   VEN_KG=SUM(VEN_KG-DEV_KG), "
cQuery += "   COBERTURA=COUNT(CLIENTE) "
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "      CLIENTE = A1_COD, "
cQuery += "      SEGCOD  = A1_SATIV1, "
cQuery += "      SEGNOM  = UPPER((SELECT RTRIM(X5_DESCRI) FROM "+RetSqlName("SX5")+" SX5 WHERE X5_FILIAL = '01' AND X5_TABELA = 'T3' AND X5_CHAVE = A1_SATIV1 AND D_E_L_E_T_ <> '*')), "
cQuery += "      REPCOD=LEFT(C5_VEND1,4), "
cQuery += "      REPNOM=A3_NOME, "
cQuery += "      GERCOD=A3_SUPER, "
cQuery += "      UF=A1_EST, "
cQuery += "      VEN_KG  = SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO), "
cQuery += "      DEV_KG  = ISNULL(SUM(SD2.D2_QTDEDEV * SB1.B1_PESO),0) "
cQuery += "   FROM  "
cQuery += "      "+RetSqlName("SC6")+" SC6 (NOLOCK) "
cQuery += "      LEFT JOIN "+RetSqlName("SC5")+" SC5 (NOLOCK) "
cQuery += "      ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery += "      AND SC5.C5_ENTREG BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'  AND "
if !Empty(MV_PAR04)
   cQuery += "   SC5.C5_VEND1 LIKE '"+Alltrim(MV_PAR04)+"%' AND "
endif
cQuery += "      SC5.D_E_L_E_T_<>'*' "

cQuery += "      JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) "
cQuery += "      ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND "
if !Empty(MV_PAR05)
   cQuery += "   SA1.A1_EST = '"+MV_PAR05+"' AND "
endif
cQuery += "      SA1.D_E_L_E_T_ <> '*'  "

cQuery += "      JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) "
cQuery += "      ON SA3.A3_COD = LEFT(SC5.C5_VEND1,4) AND "
if !Empty(MV_PAR03)
   cQuery += "   (SC5.C5_VEND1 LIKE '"+Alltrim(MV_PAR03)+"%' OR SA3.A3_SUPER LIKE '"+Alltrim(MV_PAR03)+"%' ) AND "
endif
cQuery += "      SA3.D_E_L_E_T_<>'*' "

cQuery += "      JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) "
cQuery += "      ON B1_COD=C6_PRODUTO  AND SB1.B1_SETOR <> '39'  and SB1.D_E_L_E_T_<>'*'  "
cQuery += "      LEFT JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) "
cQuery += "      ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV and SD2.D2_QTDEDEV > 0 AND SD2.D_E_L_E_T_ <> '*' "
cQuery += "      AND SD2.D2_QTDEDEV > 0 "
cQuery += "   WHERE "
cQuery += "      SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118' ) AND "
cQuery += "      SC6.D_E_L_E_T_ = ' ' "
cQuery += "   GROUP BY "
cQuery += "      A1_COD,A1_SATIV1,LEFT(C5_VEND1,4),A3_SUPER, A3_NOME,A1_EST "
cQuery += ") AS TABX "
cQuery += "GROUP BY "
cQuery += "   SEGCOD, "
cQuery += "   SEGNOM, "
cQuery += "   GERCOD, REPCOD, REPNOM, UF "
cQuery += "ORDER BY "
cQuery += "   VEN_KG DESC "

MemoWrite("C:\TEMP\FXLSSEGM2.SQL", cQuery)

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"


TMP->( DbGoTop() )
oReport:SetMeter(TMP->(RecCount()))


//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
//Â³	Processando a Sessao 1                                       Â³
//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™

oSection1:Init()
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()
//oReport:ThinLine()

While !oReport:Cancel() .And. TMP->(!Eof())

	oReport:IncMeter()

    oSection1:Cell("SEGCOD"):SetValue(TMP->SEGCOD)
	oSection1:Cell("SEGCOD"):SetAlign("LEFT")
	oSection1:Cell("SEGNOM"):SetValue(TMP->SEGNOM)
	oSection1:Cell("SEGNOM"):SetAlign("LEFT")
	oSection1:Cell("GERCOD"):SetValue(TMP->GERCOD)
	oSection1:Cell("GERCOD"):SetAlign("LEFT")
	oSection1:Cell("REPCOD"):SetValue(TMP->REPCOD)
	oSection1:Cell("REPCOD"):SetAlign("LEFT")
	oSection1:Cell("REPNOM"):SetValue(TMP->REPNOM)
	oSection1:Cell("REPNOM"):SetAlign("LEFT")
    oSection1:Cell("UF"):SetValue(TMP->UF)
	oSection1:Cell("UF"):SetAlign("LEFT")
	oSection1:Cell("VENDIDO"):SetValue(TMP->VEN_KG)
	oSection1:Cell("VENDIDO"):SetAlign("LEFT")
	oSection1:Cell("COBERTURA"):SetValue(TMP->COBERTURA)
	oSection1:Cell("COBERTURA"):SetAlign("LEFT")
	//oSection1:Cell("BAIRRO"):SetValue(TMP->BAIRRO)
	//oSection1:Cell("BAIRRO"):SetAlign("LEFT")

	
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return

