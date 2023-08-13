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
±±³Programa  ³FXLSLTA  ³ Autor ³ THIAGO EWERTON         ³ Data ³10.11.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³            RELATORIO LISTA 1                              .³±±
±±³          ³  LINHA                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FXLSLT1()

Local oReport

oReport:= ReportDef()
oReport:PrintDialog()


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FXLSLTA ³ Autor ³ Thiago Ewerton          ³ Data ³10.11.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                RELATORIO LISTA A                          .³±±
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

oReport:= TReport():New("FXLSLTA","LISTA 1","FXLSLTA", {|oReport| ReportPrint(oReport)},"LISTA 1")
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


TRCell():New(oSection1,'REP_COD'     ,'','REP_COD'        ,)
TRCell():New(oSection1,'REP'     ,'','REP'        ,)
TRCell():New(oSection1,'CLIENTE'     ,'','CLIENTE'        ,)
TRCell():New(oSection1,'LOJA'    ,'','LOJA' ,)
TRCell():New(oSection1,'NOME'  ,'','NOME'      ,)
TRCell():New(oSection1,'UF'  ,'','UF'      ,)



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
±±³Programa  ³FXLSLTA³ Autor ³ THIAGO EWERTON           ³ Data ³20.06.2013³±±
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

Static Function ReportPrint(oReport,nMes,nAno)

Local oSection1 	:= oReport:Section(1)
//Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
//Local lContinua 	:= .T.
local aMesAnt   := fMAnter(nMes,nAno)
local aMesAtu   := fMAtual(nMes,nAno)
local aMes120   := f120Dias(nMes,nAno)
local aMeses120 := fMeses120(nMes,nAno)

local lReal   := (MV_PAR03==2)


//******************************
// Monta a tabela temporÃ¡ria
//******************************
/*
Aadd( aFds , {"FIL"				,"C",002,000} )
Aadd( aFds , {"COD"				,"C",006,000} )
Aadd( aFds , {"DESC"			,"C",009,000} )
Aadd( aFds , {"SALDO"	 		,"C",002,000} )
Aadd( aFds , {"PESOD" 			,"C",002,000} )
Aadd( aFds , {"PESOO" 			,"C",002,000} )
Aadd( aFds , {"PERC"	 		,"C",002,000} )

coTbl := CriaTrab( aFds, .T. )
Use (coTbl) Alias TAB New Exclusive
dbCreateIndex(coTbl,'FIL+PED+NOTA', {|| FIL+PED+NOTA })
*/
//***********************************
// Monta a tabela 
//***********************************

//Clientes Ativos
cQuery := "SELECT "
cQuery += "   CLIENTE, "
cQuery += "   LOJA, "
cQuery += "   NOME, "
cQuery += "   REP_COD, "
cQuery += "   REP, "
cQuery += "   UF, "
for _X := 1 to Len(aMeses120)
   cQuery += "   "+aMeses120[_X,1]+" = SUM(CASE WHEN ANOMES = '"+aMeses120[_X,2]+"' THEN VENDIDO ELSE 0 END ), "
next _X
cQuery += "MESATUAL = ISNULL((SELECT "
if !lReal
   cQuery += "                   SUM(SC6U.C6_QTDVEN*SB1U.B1_PESO) "
else   
   cQuery += "                   SUM((SC6U.C6_QTDVEN * SC6U.C6_PRUNIT)-SC6U.C6_VALDESC) "
endif
cQuery += "                   FROM "
cQuery += "                      "+RetSqlName("SB1")+" SB1U, "+RetSqlName("SC5")+" SC5U, "+RetSqlName("SC6")+" SC6U, "+RetSqlName("SC9")+" SC9U, "
cQuery += "                      "+RetSqlName("SA1")+" SA1U, "+RetSqlName("SA3")+" SA3U, "+RetSqlName("SE4")+" SE4U "
cQuery += "                   WHERE "
cQuery += "                      SC5U.C5_CLIENTE = CLIENTE AND SC5U.C5_LOJACLI = LOJA AND "
cQuery += "                      SC5U.C5_FILIAL = SC6U.C6_FILIAL AND "
cQuery += "                      SC9U.C9_PEDIDO = SC6U.C6_NUM AND SC9U.C9_ITEM = SC6U.C6_ITEM AND SC9U.C9_PEDIDO = SC5U.C5_NUM AND "
cQuery += "                      SC9U.C9_BLCRED <> '09' AND "
cQuery += "                      SC6U.C6_BLQ <> 'R' AND SB1U.B1_TIPO = 'PA' AND "
cQuery += "                      SC6U.C6_PRODUTO = SB1U.B1_COD AND SC5U.C5_NUM = SC6U.C6_NUM AND SA1U.A1_VEND = SA3U.A3_COD AND "
cQuery += "                      SC5U.C5_CLIENTE = SA1U.A1_COD AND SC5U.C5_LOJACLI = SA1U.A1_LOJA AND SA1U.A1_ATIVO <> 'N' AND "
                                 //Periodo que compreende o mes Atual 
cQuery += "                      SC5U.C5_ENTREG BETWEEN '"+aMesAtu[1]+"' AND '"+aMesAtu[2]+"' AND "
cQuery += "                      SC6U.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery += "                      SB1U.B1_SETOR <> '39' AND "
											
cQuery += "                      SC5U.C5_CONDPAG = SE4U.E4_CODIGO AND "
cQuery += "                      SB1U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SC5U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SC6U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SC9U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SE4U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SA1U.D_E_L_E_T_ = ' ' ),0) "
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "       ANOMES = LEFT(SC5.C5_ENTREG,6), "
cQuery += "      CLIENTE = SA1.A1_COD,  "
cQuery += "         LOJA = SA1.A1_LOJA, "
cQuery += "         NOME = RTRIM(SA1.A1_NOME), "
cQuery += "          REP_COD = SA3.A3_COD, "
cQuery += "          REP = RTRIM(SA3.A3_NREDUZ), "
cQuery += "           UF = SA1.A1_EST,  "
if !lReal
   cQuery += "   VENDIDO = SUM(SC6.C6_QTDVEN*SB1.B1_PESO) "
else   
   cQuery += "   VENDIDO = SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC) "
endif
cQuery += "   FROM "
cQuery += "      "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "
cQuery += "      "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SE4")+" SE4 "
cQuery += "   WHERE "
cQuery += "      SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "      SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "      SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SA1.A1_VEND = SA3.A3_COD AND "
cQuery += "      SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND SA1.A1_ATIVO <> 'N' AND "
                 //Periodo que compreende os 120 dias anteriores ao mês atual
cQuery += "      SC5.C5_ENTREG BETWEEN '"+aMes120[1]+"' AND '"+aMes120[2]+"' AND "
cQuery += "      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery += "      SB1.B1_SETOR <> '39' AND "

cQuery += "      SC5.C5_CONDPAG = E4_CODIGO AND "
cQuery += "      NOT EXISTS( SELECT "
cQuery += "                     SC5X.C5_FILIAL "
cQuery += "                  FROM "
cQuery += "                     "+RetSqlName("SB1")+" SB1X, "+RetSqlName("SC5")+" SC5X, "+RetSqlName("SC6")+" SC6X, "
cQuery += "                     "+RetSqlName("SA1")+" SA1X, "+RetSqlName("SA3")+" SA3X, "+RetSqlName("SE4")+" SE4X "
cQuery += "                  WHERE "
cQuery += "                     SC5X.C5_CLIENTE = SC5.C5_CLIENTE AND SC5X.C5_LOJACLI = SC5.C5_LOJACLI AND "
cQuery += "                     SC5X.C5_FILIAL = SC6X.C6_FILIAL AND "
cQuery += "                     SC6X.C6_BLQ <> 'R' AND SB1X.B1_TIPO = 'PA' AND "
cQuery += "                     SC6X.C6_PRODUTO = SB1X.B1_COD AND SC5X.C5_NUM = SC6X.C6_NUM AND SA1X.A1_VEND = SA3X.A3_COD AND "
cQuery += "                     SC5X.C5_CLIENTE = SA1X.A1_COD AND SC5X.C5_LOJACLI = SA1X.A1_LOJA AND SA1X.A1_ATIVO <> 'N' AND "
                                //Periodo que compreende o mes Anterior ao Atual
cQuery += "                     SC5X.C5_ENTREG BETWEEN '"+aMesAnt[1]+"' AND '"+aMesAnt[2]+"' AND "
cQuery += "                     SC6X.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery += "                     SB1X.B1_SETOR <> '39' AND "

cQuery += "                     SC5X.C5_CONDPAG = SE4X.E4_CODIGO AND "
cQuery += "                     SB1X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SC5X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SC6X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SE4X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SA1X.D_E_L_E_T_ = ' '  ) AND "
cQuery += "      SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "      SE4.D_E_L_E_T_ = ' ' AND "
cQuery += "      SA1.D_E_L_E_T_ = ' ' "
cQuery += "   GROUP BY "
cQuery += "      A1_VEND, A1_COD, A1_LOJA, RTRIM(A1_NOME), A1_EST, LEFT(SC5.C5_ENTREG,6), RTRIM(A3_NREDUZ),A3_COD "
cQuery += ") AS ATIVOS "
cQuery += "GROUP BY "
cQuery += "   CLIENTE,LOJA,NOME,UF,REP,REP_COD "
cQuery += "ORDER BY "

for _X := Len(aMeses120) to 1 step -1
   cQuery += "   "+aMeses120[_X,1]+IF( _X > 1,", "," DESC ")
next _X

MemoWrite("C:\TEMP\FXLSLTA.SQL", cQuery)

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )
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

    oSection1:Cell("REP_COD"):SetValue(TMP->REP_COD)
	oSection1:Cell("REP_COD"):SetAlign("LEFT")
	oSection1:Cell("REP"):SetValue(TMP->REP)
	oSection1:Cell("REP"):SetAlign("LEFT")
	oSection1:Cell("CLIENTE"):SetValue(TMP->CLIENTE)
	oSection1:Cell("CLIENTE"):SetAlign("LEFT")
	oSection1:Cell("LOJA"):SetValue(TMP->LOJA)
	oSection1:Cell("LOJA"):SetAlign("LEFT")
	oSection1:Cell("NOME"):SetValue(TMP->NOME)
	oSection1:Cell("NOME"):SetAlign("LEFT")
	oSection1:Cell("UF"):SetValue(TMP->UF)
	oSection1:Cell("UF"):SetAlign("LEFT")
 
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return


**********************************
static function fMAtual(nMes,nAno)
**********************************

local aRet := {}
local cIni    := DtoS( CtoD("01/"+nMes+"/"+nAno ) )
local cFim    := DtoS( LastDay( Ctod("01/"+nMes+"/"+nAno ) ) )

Aadd( aRet, cIni )
Aadd( aRet, cFim )

return aRet

**********************************
static function fMAnter(nMes,nAno)
**********************************

local aRet := {}
local dDtAnt  := CtoD( "01/"+nMes+"/"+nAno )-1
local nMesAnt := Month( dDtAnt )
local nAnoAnt := Year( dDtAnt )
local cIni    := DtoS( CtoD("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) ) )

Aadd( aRet, cIni )
Aadd( aRet, cFim )

return aRet


***********************************
static function f120Dias(nMes,nAno)
***********************************

local aRet    := {}
local dDtAnt  := CtoD( "01/"+nMes+"/"+nAno ) - 1
local nMesAnt := Month( dDtAnt )
local nAnoAnt := Year( dDtAnt )
local cIni    := DtoS( CtoD("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) - 90 )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) ) )

Aadd( aRet, cIni )
Aadd( aRet, cFim )

return aRet


************************************
static function fMeses120(nMes,nAno)
************************************

local aRet    := {}
local dDtAnt  := CtoD( "01/"+nMes+"/"+nAno ) - 1
local nMesAnt := Month( dDtAnt )
local nAnoAnt := Year( dDtAnt )
local cIni    := DtoS( CtoD("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) - 90 )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) ) )
Local aMES    := { 'JAN','FEV','MAR','ABR','MAI','JUN',;
                   'JUL','AGO','SET','OUT','NOV','DEZ' }
while Left(cIni,6) <= Left(cFim,6)
   Aadd( aRet, { aMes[Month(StoD(cIni))]+Right(Str(Year(StoD(cIni))),2) , AllTrim(Str(Year(StoD(cIni)))+StrZero(Month(StoD(cIni)),2)) } )
   cIni := DtoS( StoD( cIni ) + 31 )
end

return aRet
