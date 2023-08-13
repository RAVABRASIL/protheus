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
±±³Programa  ³FXLSPVEN    ³ Autor ³ THIAGO EWERTON       ³ Data ³18.11.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³           RELATORIO PREVISAO DE VENDAS                    .³±±
±±³          ³  LINHA                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FXLSPVRL()

Local oReport
//Local cPerg	:= "FXLSFA"



//criaSx1(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Pergunte(cPerg,.T.)
/*
ValidPerg('FXLSFA')

IF !Pergunte('FXLSFA',.T.)

   Return 

ENDIF



if MV_PAR03=1 // CLIENTE

   MsAguarde( { || fFatCli() }, "Aguarde. . .", " " )   

ELSEif MV_PAR03=2   // PRODUTO

   MsAguarde( { || fFatPro() }, "Aguarde. . .", " " )   

ENDIF
*/



oReport:= ReportDef()
oReport:PrintDialog()


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FXLSPVEN  ³ Autor ³ Thiago Ewerton         ³ Data ³10.11.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³          RELATORIO REALIZADO POR CLIENTES                 .³±±
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
//Local oSection2

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

oReport:= TReport():New("FXLSPVEN","RELATORIO PREVISAO DE VENDAS","FXLSPVEN", {|oReport| ReportPrint(oReport)},"RELATORIO PREVISAO DE VENDAS")
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

oSection1 := TRSection():New(oReport,"ORIGEM" ,{"TAB"}) //alterar para TAB PARA SA1

//TRCell():New(oSection1,'CARTATU'	,'','Carteira'		,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSection1,'GERCOD'     ,'','GERCOD'        ,)
TRCell():New(oSection1,'GERNOM'     ,'','GERNOM'        ,)
TRCell():New(oSection1,'REPCOD'     ,'','REPCOD'        ,)
TRCell():New(oSection1,'REPNOM'    ,'','REPNOM'         ,)
TRCell():New(oSection1,'LINHA'  ,'','LINHA'             ,)
TRCell():New(oSection1,'UF'  ,'','UF'                   ,)
TRCell():New(oSection1,'REALIZADO'    ,'','REALIZADO'   ,)
TRCell():New(oSection1,'IDEALACUM'    ,'','IDEALACUM'   ,)
TRCell():New(oSection1,'DIFACUM'    ,'','DIFACUM'       ,)
TRCell():New(oSection1,'METAPRODIA'    ,'','METAPRODIA' ,)
TRCell():New(oSection1,'TENDENCIA'    ,'','TENDENCIA'   ,)
TRCell():New(oSection1,'METAUDIA'    ,'','METAUDIA'     ,)
//TRCell():New(oSection1,'PRECO_MEDIO'    ,'','PRECO_MEDIO'          ,)



//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("CODO"),"Produto",.F.)
//oBreak := TRBreak():New(oSection1,oSection1:Cell("REP"),"Total",.F.)
//TRFunction():New(oSection1:Cell("REALPV"),NIL,"SUM",oBreak,"Total LÃ­quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALRS"),NIL,"SUM",oBreak,"Total LÃ­quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)


Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FXLSPVEN ³ Autor ³ THIAGO EWERTON        ³ Data ³18.11.2022³±±
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
//Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
//Local lContinua 	:= .T.
local aMeta := {}
local cIni  := DtoS(CtoD("01/"+StrZero(MV_PAR01,2)+"/"+Str(MV_PAR02)))
local cFim  := DtoS(LastDay(Ctod("01/"+StrZero(MV_PAR01,2)+"/"+Str(MV_PAR02))))

Private _aArra:={}


*/
//***********************************
// Monta a tabela
//***********************************


cQuery := "SELECT "
cQuery += "   GERCOD, GERNOM, "
cQuery += "   REPCOD, REPNOM, "
cQuery += "   UF, "
cQuery += "   LINHA, "
cQuery += "   VEN_KG=SUM(VEN_KG), "
cQuery += "   META=SUM(META) "
cQuery += "FROM "
cQuery += "( "

cQuery += "SELECT "
cQuery += "   GERCOD, GERNOM=ISNULL((SELECT RTRIM(A3_NOME) FROM "+RetSqlName("SA3")+" WHERE A3_COD = GERCOD AND D_E_L_E_T_ <> '*'), '' ), "
cQuery += "   REPCOD, REPNOM, "
cQuery += "   UF, "
cQuery += "   LINHA, "
cQuery += "   VEN_KG=(VEN_KG-DEV_KG)-PED_REJ_KG, "
cQuery += "   META=0"
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "      REPCOD=LEFT(C5_VEND1,4), REPNOM=A3_NOME, "
cQuery += "      GERCOD=A3_SUPER, "
cQuery += "      UF=A1_EST,
cQuery += "      LINHA= "
cQuery += "         CASE "
cQuery += "            WHEN B1_GRUPO IN('D','E') THEN 'DOME' "
cQuery += "            WHEN B1_GRUPO IN('A','B','G') THEN 'INST' "
cQuery += "            WHEN B1_GRUPO IN('C') THEN 'HOSP' "
cQuery += "            ELSE B1_GRUPO "
cQuery += "         END, "
cQuery += "      VEN_KG = SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO), "
// 
cQuery +="       PED_REJ_KG= ISNULL(SUM(C9_QTDLIB2),0) , "
//
cQuery += "      DEV_KG = ISNULL(SUM(SD2.D2_QTDEDEV * SB1.B1_PESO),0) "
cQuery += "   FROM  "
cQuery += "      "+RetSqlName("SC6")+" SC6 (NOLOCK) "
cQuery += "      left  JOIN "+RetSqlName("SC5")+" SC5 (NOLOCK) "
cQuery += "      ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery += "      AND SC5.C5_ENTREG BETWEEN '"+cIni+"' AND '"+cFim+"'  AND SC5.D_E_L_E_T_='' "
cQuery += "      JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) "
cQuery += "      ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' '  "
cQuery += "      JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) "
cQuery += "      ON SA3.A3_COD = LEFT(SC5.C5_VEND1,4) AND SA3.D_E_L_E_T_='' "
cQuery += "      JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) "
cQuery += "      ON B1_COD=C6_PRODUTO  AND SB1.B1_SETOR <> '39'  and SB1.D_E_L_E_T_=''  "
cQuery += "      left JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) "
cQuery += "      ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV and SD2.D2_QTDEDEV > 0 AND SD2.D_E_L_E_T_ = ' '  "
cQuery += "      AND SD2.D2_QTDEDEV > 0 "
//
cQuery +="       left JOIN SC9020 SC9 (NOLOCK) "
cQuery +="       ON C6_FILIAL = C9_FILIAL AND C9_NFISCAL = '' AND C9_SEQUEN  = '01' AND C9_BLCRED IN ('09') AND "
cQuery +="       C5_ENTREG BETWEEN '"+cIni+"' AND '"+cFim+"' AND A1_COD = C9_CLIENTE AND A1_LOJA = C9_LOJA AND "
cQuery +="       C9_PRODUTO = B1_COD AND C6_NUM = C9_PEDIDO  AND SC9.D_E_L_E_T_ = ''  "
//
cQuery += "   WHERE "
cQuery += "      SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118' ) AND "
cQuery += "      SC6.D_E_L_E_T_ = ' ' "
cQuery += "   GROUP BY "
cQuery += "      LEFT(C5_VEND1,4), A3_NOME, A3_SUPER, A1_EST, "
cQuery += "      CASE "
cQuery += "         WHEN B1_GRUPO IN('D','E') THEN 'DOME' "
cQuery += "         WHEN B1_GRUPO IN('A','B','G') THEN 'INST' "
cQuery += "         WHEN B1_GRUPO IN('C') THEN 'HOSP' "
cQuery += "         ELSE B1_GRUPO "
cQuery += "      END "
cQuery += ") AS TABX "

cQuery += "UNION "

cQuery += "SELECT "
cQuery += "   GERCOD=Z51_COORD, "
cQuery += "   GERNOM=ISNULL((SELECT RTRIM(A3_NOME) FROM "+RetSqlName("SA3")+" WHERE A3_COD = Z51_COORD AND D_E_L_E_T_ <> '*'), '' ), "
cQuery += "   REPCOD=Z51_REPRES, "
cQuery += "   REPNOM=RTRIM(A3_NOME), "
cQuery += "   UF=Z51_UF, LINHA=Z51_LINHA, VEN_KG=0, META=(Z51_MVALOR/12) "
cQuery += "FROM "
cQuery += "   "+RetSqlName("Z51")+" Z51, "+RetSqlName("SA3")+" SA3 "
cQuery += "WHERE "
cQuery += "   Z51_ANO = '"+AllTrim(Str(MV_PAR02))+"' AND Z51_REPRES = A3_COD AND Z51.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*'

cQuery += ") AS TABX "


cQuery += "WHERE   "

if MV_PAR08 = 1
   cQuery += "LINHA = 'INST' AND "
elseif MV_PAR08 = 2
   cQuery += "LINHA = 'DOME' AND "
elseif MV_PAR08 = 3
   cQuery += "LINHA = 'HOSP' AND "
endif

if !Empty(MV_PAR07)
   cQuery += "UF = '"+MV_PAR07+"' AND "
endif

if !Empty(MV_PAR06)
   cQuery += "REPCOD LIKE '"+Alltrim(MV_PAR06)+"%' AND "
endif

if !Empty(MV_PAR05)
   cQuery += "GERCOD LIKE '"+Alltrim(MV_PAR05)+"%' AND "
endif

cQuery += "REPNOM <> '' "

cQuery += "GROUP BY "
cQuery += "   GERCOD, GERNOM, "
cQuery += "   REPCOD, REPNOM, "
cQuery += "   UF, "
cQuery += "   LINHA "


cQuery += "ORDER BY "
cQuery += "   GERCOD, REPCOD, UF, LINHA "

MemoWrite("C:\TEMP\FXLSPVEN.SQL", cQuery)

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

while TMP->(!Eof())
   aMeta := U_MetaDia( TMP->META, TMP->VEN_KG, MV_PAR03, MV_PAR04 )
  
   Aadd(_aArra,{TMP->GERCOD,TMP->GERNOM,;
                TMP->REPCOD,TMP->REPNOM,;
                TMP->LINHA ,TMP->UF    ,;
                TMP->META  ,TMP->VEN_KG,;
                aMeta[1]    ,if(aMeta[2]<0,0,aMeta[2]),;
                aMeta[3]    ,/*aMeta[4]*/    ,;
               /*aMeta[5]*/} )
   TMP->(DbSkip())
end

oReport:SetMeter(TMP->(RecCount()))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1:Init()
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()
//oReport:ThinLine()

While !oReport:Cancel() .And. TMP->(!Eof())

	oReport:IncMeter()

    oSection1:Cell("GERCOD"):SetValue(TMP->GERCOD)
	oSection1:Cell("GERCOD"):SetAlign("LEFT")
	oSection1:Cell("GERNOM"):SetValue(TMP->GERNOM)
	oSection1:Cell("GERNOM"):SetAlign("LEFT")
	oSection1:Cell("REPCOD"):SetValue(TMP->REPCOD)
	oSection1:Cell("REPCOD"):SetAlign("LEFT")
	oSection1:Cell("REPNOM"):SetValue(TMP->REPNOM)
	oSection1:Cell("REPNOM"):SetAlign("LEFT")
    oSection1:Cell("LINHA"):SetValue(TMP->LINHA)
	oSection1:Cell("LINHA"):SetAlign("LEFT")
	oSection1:Cell("UF"):SetValue(TMP->UF)
	oSection1:Cell("UF"):SetAlign("LEFT")
	oSection1:Cell("METAMES"):SetValue(TMP->METAMES)
	oSection1:Cell("METAMES"):SetAlign("LEFT")
	oSection1:Cell("REALIZADO"):SetValue(TMP->REALIZADO)
	oSection1:Cell("REALIZADO"):SetAlign("LEFT")
	oSection1:Cell("IDEALACUM"):SetValue(TMP->IDEALACUM)
	oSection1:Cell("IDEALACUM"):SetAlign("LEFT")
	oSection1:Cell("DIFACUM"):SetValue(TMP->DIFACUM)
	oSection1:Cell("DIFACUM"):SetAlign("LEFT")
	oSection1:Cell("METAPRODIA"):SetValue(TMP->METAPRODIA)
	oSection1:Cell("METAPRODIA"):SetAlign("LEFT")
	oSection1:Cell("TENDENCIA"):SetValue(TMP->TENDENCIA)
	oSection1:Cell("TENDENCIA"):SetAlign("LEFT")
	oSection1:Cell("METAUDIA"):SetValue(TMP->METAUDIA)
	oSection1:Cell("METAUDIA"):SetAlign("LEFT")	
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return


