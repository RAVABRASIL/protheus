#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

*************

User Function PCPR030V2()

*************

Local cPerg := "PCP3V2"
local oReport

Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")



hora1:=Left(cTURNO1,5)
hora2:=Left(cTURNO2,5)
hora3:=Left(cTURNO3,5)



For _Y:=1 to 14
&("nC"+STRZERO(_Y,2)+"T1KG"):=0
&("nC"+STRZERO(_Y,2)+"T2KG"):=0
&("nC"+STRZERO(_Y,2)+"T3KG"):=0
//
&("nS"+STRZERO(_Y,2)+"T1KG"):=0
&("nS"+STRZERO(_Y,2)+"T2KG"):=0
&("nS"+STRZERO(_Y,2)+"T3KG"):=0
//
&("nP"+STRZERO(_Y,2)+"T1KG"):=0
&("nP"+STRZERO(_Y,2)+"T2KG"):=0
&("nP"+STRZERO(_Y,2)+"T3KG"):=0

Next


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:= ReportDef()
oReport:PrintDialog()

Return
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
Local oSection1
Local oSection2
Local oSection3
local oReport
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



Pergunte('PCP3V2',.T.)                                                       


//Relatorio de Utilização de Máquina
 oReport:= TReport():New("PCPR030V2","Utilizacao Maquina ","PCP3V2", {|oReport| ReportPrint(oReport)},"Este relatório demostrará as informações referentes a utilização das corte e soldas diariamente")

//oReport:SetLandscape()
oReport:SetPortrait()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Data de                ³
//³ mv_par02   // Data Até               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Pergunte(oReport:uParam,.F.)
//Pergunte('PCPR030',.F.)
 
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
oSection1 := TRSection():New(oReport,"PRODUCAO",{"TAB"}) 
TRCell():New(oSection1,'FILIAL'            ,'',''                 ,PesqPict('SB1','B1_COD'),20  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DT'            ,'','DATA'                 ,,20  ,/*lPixel*/,/*{|| code-block de impressao }*/)
// corte e solda 
For _Y:=1 to 14
// HORAS T1
TRCell():New(oSection1,'C'+STRZERO(_Y,2)+'HT1'   ,'','C'+STRZERO(_Y,2)+'_HORAS_T1'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// HORAS T2
TRCell():New(oSection1,'C'+STRZERO(_Y,2)+'HT2'   ,'','C'+STRZERO(_Y,2)+'_HORAS_T2'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// HORAS T3
TRCell():New(oSection1,'C'+STRZERO(_Y,2)+'HT3'   ,'','C'+STRZERO(_Y,2)+'_HORAS_T3'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// UILIZADO T1
TRCell():New(oSection1,'C'+STRZERO(_Y,2)+'UT1'   ,'','C'+STRZERO(_Y,2)+'_%_T1'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// UILIZADO T2
TRCell():New(oSection1,'C'+STRZERO(_Y,2)+'UT2'   ,'','C'+STRZERO(_Y,2)+'_%_T2'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// UILIZADO T3
TRCell():New(oSection1,'C'+STRZERO(_Y,2)+'UT3'   ,'','C'+STRZERO(_Y,2)+'_%_T3'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// UTILIZADO DIA 
TRCell():New(oSection1,'C'+STRZERO(_Y,2)+'UD'   ,'','C'+STRZERO(_Y,2)+'_%_DIA'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
Next
// picote 
For _Y:=1 to 5
// HORAS T1
TRCell():New(oSection1,'P'+STRZERO(_Y,2)+'HT1'   ,'','P'+STRZERO(_Y,2)+'_HORAS_T1'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// HORAS T2
TRCell():New(oSection1,'P'+STRZERO(_Y,2)+'HT2'   ,'','P'+STRZERO(_Y,2)+'_HORAS_T2'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// HORAS T3
TRCell():New(oSection1,'P'+STRZERO(_Y,2)+'HT3'   ,'','P'+STRZERO(_Y,2)+'_HORAS_T3'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// UILIZADO T1
TRCell():New(oSection1,'P'+STRZERO(_Y,2)+'UT1'   ,'','P'+STRZERO(_Y,2)+'_%_T1'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// UILIZADO T2
TRCell():New(oSection1,'P'+STRZERO(_Y,2)+'UT2'   ,'','P'+STRZERO(_Y,2)+'_%_T2'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// UILIZADO T3
TRCell():New(oSection1,'P'+STRZERO(_Y,2)+'UT3'   ,'','P'+STRZERO(_Y,2)+'_%_T3'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// UTILIZADO DIA 
TRCell():New(oSection1,'P'+STRZERO(_Y,2)+'UD'   ,'','P'+STRZERO(_Y,2)+'_%_DIA'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
next
_Y:=2 // Sacoleira
// HORAS T1
TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'HT1'   ,'','S'+STRZERO(_Y,2)+'_HORAS_T1'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// HORAS T2
TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'HT2'   ,'','S'+STRZERO(_Y,2)+'_HORAS_T2'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// HORAS T3
TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'HT3'   ,'','S'+STRZERO(_Y,2)+'_HORAS_T3'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// UILIZADO T1
TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'UT1'   ,'','S'+STRZERO(_Y,2)+'_%_T1'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// UILIZADO T2
TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'UT2'   ,'','S'+STRZERO(_Y,2)+'_%_T2'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// UILIZADO T3
TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'UT3'   ,'','S'+STRZERO(_Y,2)+'_%_T3'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// UTILIZADO DIA 
TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'UD'   ,'','S'+STRZERO(_Y,2)+'_%_DIA'          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)

// totalizadores  por turno 
for _Z:=1 to 3
   TRCell():New(oSection1,'TOTALHT'+STRZERO(_Z,2)            ,'','TOTAL_HORAS_T'+alltrim(STR(_Z))                 ,"@E 9,999,999.9999999999999",20  ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,'TOTALUT'+STRZERO(_Z,2)            ,'','TOTAL_%_T'+alltrim(STR(_Z))                     ,"@E 9,999,999.9999999999999",20  ,/*lPixel*/,/*{|| code-block de impressao }*/)
next
//  totalizadores dia 
TRCell():New(oSection1,'TOTALDH'            ,'','TOTAL_DIA_HORAS'                 ,"@E 9,999,999.9999999999999",20  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'TOTALDU'            ,'','TOTAL_DIA_%'                 ,"@E 9,999,999.9999999999999",20  ,/*lPixel*/,/*{|| code-block de impressao }*/)

// TOTALIZADORES VERTICAIS 
oBreak := TRBreak():New(oSection1,oSection1:Cell("FILIAL"),"Total Acumulado",.F.)
// C01
TRFunction():New(oSection1:Cell("C01HT1"),"C01HT1","SUM",oBreak,"C01HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01UT1"),"C01UT1","ONPRINT",oBreak,"C01UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C01HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01HT2"),"C01HT2","SUM",oBreak,"C01HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01UT2"),"C01UT2","ONPRINT",oBreak,"C01UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C01HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01HT3"),"C01HT3","SUM",oBreak,"C01HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01UT3"),"C01UT3","ONPRINT",oBreak,"C01UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C01HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01UD"),"C01UD","ONPRINT",oBreak,"C01UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C01HT1"):GetValue()+oReport:GetFunction("C01HT2"):GetValue()+oReport:GetFunction("C01HT3"):GetValue())/(nDias*(IIF(nC01T1KG=0,0,14.66)+IIF(nC01T2KG=0,0,14.66)+IIF(nC01T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C02
TRFunction():New(oSection1:Cell("C02HT1"),"C02HT1","SUM",oBreak,"C02HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02UT1"),"C02UT1","ONPRINT",oBreak,"C02UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C02HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02HT2"),"C02HT2","SUM",oBreak,"C02HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02UT2"),"C02UT2","ONPRINT",oBreak,"C02UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C02HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02HT3"),"C02HT3","SUM",oBreak,"C02HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02UT3"),"C02UT3","ONPRINT",oBreak,"C02UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C02HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02UD"),"C02UD","ONPRINT",oBreak,"C02UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C02HT1"):GetValue()+oReport:GetFunction("C02HT2"):GetValue()+oReport:GetFunction("C02HT3"):GetValue())/(nDias*(IIF(nC02T1KG=0,0,14.66)+IIF(nC02T2KG=0,0,14.66)+IIF(nC02T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C03
TRFunction():New(oSection1:Cell("C03HT1"),"C03HT1","SUM",oBreak,"C03HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03UT1"),"C03UT1","ONPRINT",oBreak,"C03UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C03HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03HT2"),"C03HT2","SUM",oBreak,"C03HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03UT2"),"C03UT2","ONPRINT",oBreak,"C03UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C03HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03HT3"),"C03HT3","SUM",oBreak,"C03HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03UT3"),"C03UT3","ONPRINT",oBreak,"C03UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C03HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03UD"),"C03UD","ONPRINT",oBreak,"C03UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C03HT1"):GetValue()+oReport:GetFunction("C03HT2"):GetValue()+oReport:GetFunction("C03HT3"):GetValue())/(nDias*(IIF(nC03T1KG=0,0,14.66)+IIF(nC03T2KG=0,0,14.66)+IIF(nC03T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C04
TRFunction():New(oSection1:Cell("C04HT1"),"C04HT1","SUM",oBreak,"C04HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04UT1"),"C04UT1","ONPRINT",oBreak,"C04UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C04HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04HT2"),"C04HT2","SUM",oBreak,"C04HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04UT2"),"C04UT2","ONPRINT",oBreak,"C04UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C04HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04HT3"),"C04HT3","SUM",oBreak,"C04HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04UT3"),"C04UT3","ONPRINT",oBreak,"C04UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C04HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04UD"),"C04UD","ONPRINT",oBreak,"C04UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C04HT1"):GetValue()+oReport:GetFunction("C04HT2"):GetValue()+oReport:GetFunction("C04HT3"):GetValue())/(nDias*(IIF(nC04T1KG=0,0,14.66)+IIF(nC04T2KG=0,0,14.66)+IIF(nC04T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C05
TRFunction():New(oSection1:Cell("C05HT1"),"C05HT1","SUM",oBreak,"C05HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05UT1"),"C05UT1","ONPRINT",oBreak,"C05UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C05HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05HT2"),"C05HT2","SUM",oBreak,"C05HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05UT2"),"C05UT2","ONPRINT",oBreak,"C05UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C05HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05HT3"),"C05HT3","SUM",oBreak,"C05HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05UT3"),"C05UT3","ONPRINT",oBreak,"C05UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C05HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05UD"),"C05UD","ONPRINT",oBreak,"C05UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C05HT1"):GetValue()+oReport:GetFunction("C05HT2"):GetValue()+oReport:GetFunction("C05HT3"):GetValue())/(nDias*(IIF(nC05T1KG=0,0,14.66)+IIF(nC05T2KG=0,0,14.66)+IIF(nC05T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C06
TRFunction():New(oSection1:Cell("C06HT1"),"C06HT1","SUM",oBreak,"C06HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06UT1"),"C06UT1","ONPRINT",oBreak,"C06UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C06HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06HT2"),"C06HT2","SUM",oBreak,"C06HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06UT2"),"C06UT2","ONPRINT",oBreak,"C06UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C06HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06HT3"),"C06HT3","SUM",oBreak,"C06HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06UT3"),"C06UT3","ONPRINT",oBreak,"C06UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C06HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06UD"),"C06UD","ONPRINT",oBreak,"C06UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C06HT1"):GetValue()+oReport:GetFunction("C06HT2"):GetValue()+oReport:GetFunction("C06HT3"):GetValue())/(nDias*(IIF(nC06T1KG=0,0,14.66)+IIF(nC06T2KG=0,0,14.66)+IIF(nC06T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C07
TRFunction():New(oSection1:Cell("C07HT1"),"C07HT1","SUM",oBreak,"C07HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07UT1"),"C07UT1","ONPRINT",oBreak,"C07UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C07HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07HT2"),"C07HT2","SUM",oBreak,"C07HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07UT2"),"C07UT2","ONPRINT",oBreak,"C07UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C07HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07HT3"),"C07HT3","SUM",oBreak,"C07HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07UT3"),"C07UT3","ONPRINT",oBreak,"C07UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C07HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07UD"),"C07UD","ONPRINT",oBreak,"C07UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C07HT1"):GetValue()+oReport:GetFunction("C07HT2"):GetValue()+oReport:GetFunction("C07HT3"):GetValue())/(nDias*(IIF(nC07T1KG=0,0,14.66)+IIF(nC07T2KG=0,0,14.66)+IIF(nC07T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C08
TRFunction():New(oSection1:Cell("C08HT1"),"C08HT1","SUM",oBreak,"C08HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08UT1"),"C08UT1","ONPRINT",oBreak,"C08UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C08HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08HT2"),"C08HT2","SUM",oBreak,"C08HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08UT2"),"C08UT2","ONPRINT",oBreak,"C08UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C08HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08HT3"),"C08HT3","SUM",oBreak,"C08HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08UT3"),"C08UT3","ONPRINT",oBreak,"C08UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C08HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08UD"),"C08UD","ONPRINT",oBreak,"C08UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C08HT1"):GetValue()+oReport:GetFunction("C08HT2"):GetValue()+oReport:GetFunction("C08HT3"):GetValue())/(nDias*(IIF(nC08T1KG=0,0,14.66)+IIF(nC08T2KG=0,0,14.66)+IIF(nC08T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C09
TRFunction():New(oSection1:Cell("C09HT1"),"C09HT1","SUM",oBreak,"C09HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09UT1"),"C09UT1","ONPRINT",oBreak,"C09UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C09HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09HT2"),"C09HT2","SUM",oBreak,"C09HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09UT2"),"C09UT2","ONPRINT",oBreak,"C09UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C09HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09HT3"),"C09HT3","SUM",oBreak,"C09HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09UT3"),"C09UT3","ONPRINT",oBreak,"C09UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C09HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09UD"),"C09UD","ONPRINT",oBreak,"C09UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C09HT1"):GetValue()+oReport:GetFunction("C09HT2"):GetValue()+oReport:GetFunction("C09HT3"):GetValue())/(nDias*(IIF(nC09T1KG=0,0,14.66)+IIF(nC09T2KG=0,0,14.66)+IIF(nC09T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C10
TRFunction():New(oSection1:Cell("C10HT1"),"C10HT1","SUM",oBreak,"C10HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10UT1"),"C10UT1","ONPRINT",oBreak,"C10UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C10HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10HT2"),"C10HT2","SUM",oBreak,"C10HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10UT2"),"C10UT2","ONPRINT",oBreak,"C10UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C10HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10HT3"),"C10HT3","SUM",oBreak,"C10HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10UT3"),"C10UT3","ONPRINT",oBreak,"C10UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C10HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10UD"),"C10UD","ONPRINT",oBreak,"C10UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C10HT1"):GetValue()+oReport:GetFunction("C10HT2"):GetValue()+oReport:GetFunction("C10HT3"):GetValue())/(nDias*(IIF(nC10T1KG=0,0,14.66)+IIF(nC10T2KG=0,0,14.66)+IIF(nC10T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C11
TRFunction():New(oSection1:Cell("C11HT1"),"C11HT1","SUM",oBreak,"C11HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11UT1"),"C11UT1","ONPRINT",oBreak,"C11UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C11HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11HT2"),"C11HT2","SUM",oBreak,"C11HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11UT2"),"C11UT2","ONPRINT",oBreak,"C11UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C11HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11HT3"),"C11HT3","SUM",oBreak,"C11HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11UT3"),"C11UT3","ONPRINT",oBreak,"C11UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C11HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11UD"),"C11UD","ONPRINT",oBreak,"C11UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C11HT1"):GetValue()+oReport:GetFunction("C11HT2"):GetValue()+oReport:GetFunction("C11HT3"):GetValue())/(nDias*(IIF(nC11T1KG=0,0,14.66)+IIF(nC11T2KG=0,0,14.66)+IIF(nC11T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C12
TRFunction():New(oSection1:Cell("C12HT1"),"C12HT1","SUM",oBreak,"C12HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12UT1"),"C12UT1","ONPRINT",oBreak,"C12UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C12HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12HT2"),"C12HT2","SUM",oBreak,"C12HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12UT2"),"C12UT2","ONPRINT",oBreak,"C12UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C12HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12HT3"),"C12HT3","SUM",oBreak,"C12HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12UT3"),"C12UT3","ONPRINT",oBreak,"C12UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C12HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12UD"),"C12UD","ONPRINT",oBreak,"C12UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C12HT1"):GetValue()+oReport:GetFunction("C12HT2"):GetValue()+oReport:GetFunction("C12HT3"):GetValue())/(nDias*(IIF(nC12T1KG=0,0,14.66)+IIF(nC12T2KG=0,0,14.66)+IIF(nC12T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C13
TRFunction():New(oSection1:Cell("C13HT1"),"C13HT1","SUM",oBreak,"C13HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13UT1"),"C13UT1","ONPRINT",oBreak,"C13UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C13HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13HT2"),"C13HT2","SUM",oBreak,"C13HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13UT2"),"C13UT2","ONPRINT",oBreak,"C13UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C13HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13HT3"),"C13HT3","SUM",oBreak,"C13HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13UT3"),"C13UT3","ONPRINT",oBreak,"C13UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C13HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13UD"),"C13UD","ONPRINT",oBreak,"C13UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C13HT1"):GetValue()+oReport:GetFunction("C13HT2"):GetValue()+oReport:GetFunction("C13HT3"):GetValue())/(nDias*(IIF(nC13T1KG=0,0,14.66)+IIF(nC13T2KG=0,0,14.66)+IIF(nC13T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C14
TRFunction():New(oSection1:Cell("C14HT1"),"C14HT1","SUM",oBreak,"C14HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14UT1"),"C14UT1","ONPRINT",oBreak,"C14UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C14HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14HT2"),"C14HT2","SUM",oBreak,"C14HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14UT2"),"C14UT2","ONPRINT",oBreak,"C14UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C14HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14HT3"),"C14HT3","SUM",oBreak,"C14HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14UT3"),"C14UT3","ONPRINT",oBreak,"C14UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C14HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14UD"),"C14UD","ONPRINT",oBreak,"C14UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C14HT1"):GetValue()+oReport:GetFunction("C14HT2"):GetValue()+oReport:GetFunction("C14HT3"):GetValue())/(nDias*(IIF(nC14T1KG=0,0,14.66)+IIF(nC14T2KG=0,0,14.66)+IIF(nC14T3KG=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// P01
TRFunction():New(oSection1:Cell("P01HT1"),"P01HT1","SUM",oBreak,"P01HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01UT1"),"P01UT1","ONPRINT",oBreak,"P01UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P01HT1"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01HT2"),"P01HT2","SUM",oBreak,"P01HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01UT2"),"P01UT2","ONPRINT",oBreak,"P01UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P01HT2"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01HT3"),"P01HT3","SUM",oBreak,"P01HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01UT3"),"P01UT3","ONPRINT",oBreak,"P01UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P01HT3"):GetValue())/(nDias*6.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01UD"),"P01UD","ONPRINT",oBreak,"P01UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("P01HT1"):GetValue()+oReport:GetFunction("P01HT2"):GetValue()+oReport:GetFunction("P01HT3"):GetValue())/(nDias*(IIF(nP01T1KG=0,0,7.33)+IIF(nP01T2KG=0,0,7.33)+IIF(nP01T3KG=0,0,6.33))))*100 },.F.,.F.,.F.,oSection1)
// P02
TRFunction():New(oSection1:Cell("P02HT1"),"P02HT1","SUM",oBreak,"P02HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02UT1"),"P02UT1","ONPRINT",oBreak,"P02UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P02HT1"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02HT2"),"P02HT2","SUM",oBreak,"P02HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02UT2"),"P02UT2","ONPRINT",oBreak,"P02UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P02HT2"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02HT3"),"P02HT3","SUM",oBreak,"P02HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02UT3"),"P02UT3","ONPRINT",oBreak,"P02UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P02HT3"):GetValue())/(nDias*6.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02UD"),"P02UD","ONPRINT",oBreak,"P02UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("P02HT1"):GetValue()+oReport:GetFunction("P02HT2"):GetValue()+oReport:GetFunction("P02HT3"):GetValue())/(nDias*(IIF(nP02T1KG=0,0,7.33)+IIF(nP02T2KG=0,0,7.33)+IIF(nP02T3KG=0,0,6.33))))*100 },.F.,.F.,.F.,oSection1)
// P03
TRFunction():New(oSection1:Cell("P03HT1"),"P03HT1","SUM",oBreak,"P03HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03UT1"),"P03UT1","ONPRINT",oBreak,"P03UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P03HT1"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03HT2"),"P03HT2","SUM",oBreak,"P03HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03UT2"),"P03UT2","ONPRINT",oBreak,"P03UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P03HT2"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03HT3"),"P03HT3","SUM",oBreak,"P03HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03UT3"),"P03UT3","ONPRINT",oBreak,"P03UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P03HT3"):GetValue())/(nDias*6.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03UD"),"P03UD","ONPRINT",oBreak,"P03UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("P03HT1"):GetValue()+oReport:GetFunction("P03HT2"):GetValue()+oReport:GetFunction("P03HT3"):GetValue())/(nDias*(IIF(nP03T1KG=0,0,7.33)+IIF(nP03T2KG=0,0,7.33)+IIF(nP03T3KG=0,0,6.33))))*100 },.F.,.F.,.F.,oSection1)
// P04
TRFunction():New(oSection1:Cell("P04HT1"),"P04HT1","SUM",oBreak,"P04HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04UT1"),"P04UT1","ONPRINT",oBreak,"P04UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P04HT1"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04HT2"),"P04HT2","SUM",oBreak,"P04HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04UT2"),"P04UT2","ONPRINT",oBreak,"P04UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P04HT2"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04HT3"),"P04HT3","SUM",oBreak,"P04HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04UT3"),"P04UT3","ONPRINT",oBreak,"P04UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P04HT3"):GetValue())/(nDias*6.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04UD"),"P04UD","ONPRINT",oBreak,"P04UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("P04HT1"):GetValue()+oReport:GetFunction("P04HT2"):GetValue()+oReport:GetFunction("P04HT3"):GetValue())/(nDias*(IIF(nP04T1KG=0,0,7.33)+IIF(nP04T2KG=0,0,7.33)+IIF(nP04T3KG=0,0,6.33))))*100 },.F.,.F.,.F.,oSection1)
// P05
TRFunction():New(oSection1:Cell("P05HT1"),"P05HT1","SUM",oBreak,"P05HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05UT1"),"P05UT1","ONPRINT",oBreak,"P05UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P05HT1"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05HT2"),"P05HT2","SUM",oBreak,"P05HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05UT2"),"P05UT2","ONPRINT",oBreak,"P05UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P05HT2"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05HT3"),"P05HT3","SUM",oBreak,"P05HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05UT3"),"P05UT3","ONPRINT",oBreak,"P05UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P05HT3"):GetValue())/(nDias*6.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05UD"),"P05UD","ONPRINT",oBreak,"P05UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("P05HT1"):GetValue()+oReport:GetFunction("P05HT2"):GetValue()+oReport:GetFunction("P05HT3"):GetValue())/(nDias*(IIF(nP05T1KG=0,0,7.33)+IIF(nP05T2KG=0,0,7.33)+IIF(nP05T3KG=0,0,6.33))))*100 },.F.,.F.,.F.,oSection1)
// S02
TRFunction():New(oSection1:Cell("S02HT1"),"S02HT1","SUM",oBreak,"S02HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02UT1"),"S02UT1","ONPRINT",oBreak,"S02UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("S02HT1"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02HT2"),"S02HT2","SUM",oBreak,"S02HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02UT2"),"S02UT2","ONPRINT",oBreak,"S02UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("S02HT2"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02HT3"),"S02HT3","SUM",oBreak,"S02HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02UT3"),"S02UT3","ONPRINT",oBreak,"S02UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("S02HT3"):GetValue())/(nDias*6.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02UD"),"S02UD","ONPRINT",oBreak,"S02UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("S02HT1"):GetValue()+oReport:GetFunction("S02HT2"):GetValue()+oReport:GetFunction("S02HT3"):GetValue())/(nDias*(IIF(nS02T1KG=0,0,7.33)+IIF(nS02T2KG=0,0,7.33)+IIF(nS02T3KG=0,0,6.33))))*100 },.F.,.F.,.F.,oSection1)
// totalizador 
// total T1
TRFunction():New(oSection1:Cell("TOTALHT01"),"TOTALHT01","SUM",oBreak,"TOTALHT01","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("TOTALUT01"),"TOTALUT01","ONPRINT",oBreak,"TOTALUT01","@E 9,999,999.9999999999999",{|| (oReport:GetFunction("TOTALHT01"):GetValue())/((oReport:GetFunction("C01HT1"):GetValue())/((oReport:GetFunction("C01HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C02HT1"):GetValue())/((oReport:GetFunction("C02HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C03HT1"):GetValue())/((oReport:GetFunction("C03HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C04HT1"):GetValue())/((oReport:GetFunction("C04HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C05HT1"):GetValue())/((oReport:GetFunction("C05HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C06HT1"):GetValue())/((oReport:GetFunction("C06HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C07HT1"):GetValue())/((oReport:GetFunction("C07HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C08HT1"):GetValue())/((oReport:GetFunction("C08HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C09HT1"):GetValue())/((oReport:GetFunction("C09HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C10HT1"):GetValue())/((oReport:GetFunction("C10HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C11HT1"):GetValue())/((oReport:GetFunction("C11HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C12HT1"):GetValue())/((oReport:GetFunction("C12HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C13HT1"):GetValue())/((oReport:GetFunction("C13HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C14HT1"):GetValue())/((oReport:GetFunction("C14HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("P01HT1"):GetValue())/((oReport:GetFunction("P01HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P02HT1"):GetValue())/((oReport:GetFunction("P02HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P03HT1"):GetValue())/((oReport:GetFunction("P03HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P04HT1"):GetValue())/((oReport:GetFunction("P04HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P05HT1"):GetValue())/((oReport:GetFunction("P05HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("S02HT1"):GetValue())/((oReport:GetFunction("S02HT1"):GetValue())/(nDias*7.33)*100)) },.F.,.F.,.F.,oSection1)
// total T2
TRFunction():New(oSection1:Cell("TOTALHT02"),"TOTALHT02","SUM",oBreak,"TOTALHT02","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("TOTALUT02"),"TOTALUT02","ONPRINT",oBreak,"TOTALUT02","@E 9,999,999.9999999999999",{|| (oReport:GetFunction("TOTALHT02"):GetValue())/((oReport:GetFunction("C01HT2"):GetValue())/((oReport:GetFunction("C01HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C02HT2"):GetValue())/((oReport:GetFunction("C02HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C03HT2"):GetValue())/((oReport:GetFunction("C03HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C04HT2"):GetValue())/((oReport:GetFunction("C04HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C05HT2"):GetValue())/((oReport:GetFunction("C05HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C06HT2"):GetValue())/((oReport:GetFunction("C06HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C07HT2"):GetValue())/((oReport:GetFunction("C07HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C08HT2"):GetValue())/((oReport:GetFunction("C08HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C09HT2"):GetValue())/((oReport:GetFunction("C09HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C10HT2"):GetValue())/((oReport:GetFunction("C10HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C11HT2"):GetValue())/((oReport:GetFunction("C11HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C12HT2"):GetValue())/((oReport:GetFunction("C12HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C13HT2"):GetValue())/((oReport:GetFunction("C13HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C14HT2"):GetValue())/((oReport:GetFunction("C14HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("P01HT2"):GetValue())/((oReport:GetFunction("P01HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P02HT2"):GetValue())/((oReport:GetFunction("P02HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P03HT2"):GetValue())/((oReport:GetFunction("P03HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P04HT2"):GetValue())/((oReport:GetFunction("P04HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P05HT2"):GetValue())/((oReport:GetFunction("P05HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("S02HT2"):GetValue())/((oReport:GetFunction("S02HT2"):GetValue())/(nDias*7.33)*100)) },.F.,.F.,.F.,oSection1)
// total T3
TRFunction():New(oSection1:Cell("TOTALHT03"),"TOTALHT03","SUM",oBreak,"TOTALHT03","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("TOTALUT03"),"TOTALUT03","ONPRINT",oBreak,"TOTALUT03","@E 9,999,999.9999999999999",{|| (oReport:GetFunction("TOTALHT03"):GetValue())/((oReport:GetFunction("C01HT3"):GetValue())/((oReport:GetFunction("C01HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C02HT3"):GetValue())/((oReport:GetFunction("C02HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C03HT3"):GetValue())/((oReport:GetFunction("C03HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C04HT3"):GetValue())/((oReport:GetFunction("C04HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C05HT3"):GetValue())/((oReport:GetFunction("C05HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C06HT3"):GetValue())/((oReport:GetFunction("C06HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C07HT3"):GetValue())/((oReport:GetFunction("C07HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C08HT3"):GetValue())/((oReport:GetFunction("C08HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C09HT3"):GetValue())/((oReport:GetFunction("C09HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C10HT3"):GetValue())/((oReport:GetFunction("C10HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C11HT3"):GetValue())/((oReport:GetFunction("C11HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C12HT3"):GetValue())/((oReport:GetFunction("C12HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C13HT3"):GetValue())/((oReport:GetFunction("C13HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C14HT3"):GetValue())/((oReport:GetFunction("C14HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("P01HT3"):GetValue())/((oReport:GetFunction("P01HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P02HT3"):GetValue())/((oReport:GetFunction("P02HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P03HT3"):GetValue())/((oReport:GetFunction("P03HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P04HT3"):GetValue())/((oReport:GetFunction("P04HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P05HT3"):GetValue())/((oReport:GetFunction("P05HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("S02HT3"):GetValue())/((oReport:GetFunction("S02HT3"):GetValue())/(nDias*6.33)*100)) },.F.,.F.,.F.,oSection1)
//TOTAL DIA 
TRFunction():New(oSection1:Cell("TOTALDH"),"TOTALDH","SUM",oBreak,"TOTALDH","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("TOTALDU"),"TOTALDU","ONPRINT",oBreak,"TOTALDU","@E 9,999,999.9999999999999",{|| (oReport:GetFunction("TOTALHT01"):GetValue()+oReport:GetFunction("TOTALHT02"):GetValue()+oReport:GetFunction("TOTALHT03"):GetValue())/( ;
oReport:GetFunction("TOTALHT01"):GetValue()/((oReport:GetFunction("TOTALHT01"):GetValue())/((oReport:GetFunction("C01HT1"):GetValue())/((oReport:GetFunction("C01HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C02HT1"):GetValue())/((oReport:GetFunction("C02HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C03HT1"):GetValue())/((oReport:GetFunction("C03HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C04HT1"):GetValue())/((oReport:GetFunction("C04HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C05HT1"):GetValue())/((oReport:GetFunction("C05HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C06HT1"):GetValue())/((oReport:GetFunction("C06HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C07HT1"):GetValue())/((oReport:GetFunction("C07HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C08HT1"):GetValue())/((oReport:GetFunction("C08HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C09HT1"):GetValue())/((oReport:GetFunction("C09HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C10HT1"):GetValue())/((oReport:GetFunction("C10HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C11HT1"):GetValue())/((oReport:GetFunction("C11HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C12HT1"):GetValue())/((oReport:GetFunction("C12HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C13HT1"):GetValue())/((oReport:GetFunction("C13HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C14HT1"):GetValue())/((oReport:GetFunction("C14HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("P01HT1"):GetValue())/((oReport:GetFunction("P01HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P02HT1"):GetValue())/((oReport:GetFunction("P02HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P03HT1"):GetValue())/((oReport:GetFunction("P03HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P04HT1"):GetValue())/((oReport:GetFunction("P04HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P05HT1"):GetValue())/((oReport:GetFunction("P05HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("S02HT1"):GetValue())/((oReport:GetFunction("S02HT1"):GetValue())/(nDias*7.33)*100))) ;
+oReport:GetFunction("TOTALHT02"):GetValue()/((oReport:GetFunction("TOTALHT02"):GetValue())/((oReport:GetFunction("C01HT2"):GetValue())/((oReport:GetFunction("C01HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C02HT2"):GetValue())/((oReport:GetFunction("C02HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C03HT2"):GetValue())/((oReport:GetFunction("C03HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C04HT2"):GetValue())/((oReport:GetFunction("C04HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C05HT2"):GetValue())/((oReport:GetFunction("C05HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C06HT2"):GetValue())/((oReport:GetFunction("C06HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C07HT2"):GetValue())/((oReport:GetFunction("C07HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C08HT2"):GetValue())/((oReport:GetFunction("C08HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C09HT2"):GetValue())/((oReport:GetFunction("C09HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C10HT2"):GetValue())/((oReport:GetFunction("C10HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C11HT2"):GetValue())/((oReport:GetFunction("C11HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C12HT2"):GetValue())/((oReport:GetFunction("C12HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C13HT2"):GetValue())/((oReport:GetFunction("C13HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C14HT2"):GetValue())/((oReport:GetFunction("C14HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("P01HT2"):GetValue())/((oReport:GetFunction("P01HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P02HT2"):GetValue())/((oReport:GetFunction("P02HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P03HT2"):GetValue())/((oReport:GetFunction("P03HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P04HT2"):GetValue())/((oReport:GetFunction("P04HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P05HT2"):GetValue())/((oReport:GetFunction("P05HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("S02HT2"):GetValue())/((oReport:GetFunction("S02HT2"):GetValue())/(nDias*7.33)*100))) ;
+oReport:GetFunction("TOTALHT03"):GetValue()/((oReport:GetFunction("TOTALHT03"):GetValue())/((oReport:GetFunction("C01HT3"):GetValue())/((oReport:GetFunction("C01HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C02HT3"):GetValue())/((oReport:GetFunction("C02HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C03HT3"):GetValue())/((oReport:GetFunction("C03HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C04HT3"):GetValue())/((oReport:GetFunction("C04HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C05HT3"):GetValue())/((oReport:GetFunction("C05HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C06HT3"):GetValue())/((oReport:GetFunction("C06HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C07HT3"):GetValue())/((oReport:GetFunction("C07HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C08HT3"):GetValue())/((oReport:GetFunction("C08HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C09HT3"):GetValue())/((oReport:GetFunction("C09HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C10HT3"):GetValue())/((oReport:GetFunction("C10HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C11HT3"):GetValue())/((oReport:GetFunction("C11HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C12HT3"):GetValue())/((oReport:GetFunction("C12HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C13HT3"):GetValue())/((oReport:GetFunction("C13HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C14HT3"):GetValue())/((oReport:GetFunction("C14HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("P01HT3"):GetValue())/((oReport:GetFunction("P01HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P02HT3"):GetValue())/((oReport:GetFunction("P02HT3"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P03HT3"):GetValue())/((oReport:GetFunction("P03HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P04HT3"):GetValue())/((oReport:GetFunction("P04HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P05HT3"):GetValue())/((oReport:GetFunction("P05HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("S02HT3"):GetValue())/((oReport:GetFunction("S02HT3"):GetValue())/(nDias*6.33)*100))) ;
)},.F.,.F.,.F.,oSection1)

// Dias Uteis
oBreak := TRBreak():New(oSection1,oSection1:Cell("FILIAL"),"Dias Uteis ",.F.)
TRFunction():New(oSection1:Cell("C01HT1"),"C01HT1","ONPRINT",oBreak,"C01HT1","@E 9,999,999.9999999999999",{|| nDias },.F.,.F.,.F.,oSection1)
// Periodo de ate 
oBreak := TRBreak():New(oSection1,oSection1:Cell("FILIAL"),"Perido" ,.F.)
TRFunction():New(oSection1:Cell("DT"),"DT","ONPRINT",oBreak,"DT",PesqPict('SB1','B1_COD'),{||  "De "+DTOC(MV_PAR01)+' Ate '+DTOC(MV_PAR02) },.F.,.F.,.F.,oSection1)

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
Local oSection1   := oReport:Section(1)
Local cQuery      := ""
Local cMatAnt     := ""
Local nNivel      := 0
Local lContinua   := .T.
Local aFds        := {}
local ntotHT1:=ntotUT1:=0
local ntotHT2:=ntotUT2:=0
local ntotHT3:=ntotUT3:=0


//******************************
// Monta a tabela temporária
//******************************
Aadd( aFds , {"FILIAL"              ,"C",008,000} )
Aadd( aFds , {"DT"                  ,"N",008,000} )
For _Y:=1 to 14
   Aadd( aFds , {"C"+STRZERO(_Y,2)+'HT1'         ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+'HT2'         ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+'HT3'         ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+'UT1'         ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+'UT2'         ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+'UT3'         ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+'HD'         ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+'UD'         ,"N",020,005} )
If  _Y=2
   Aadd( aFds , {"S"+STRZERO(_Y,2)+'HT1'         ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+'HT2'         ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+'HT3'         ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+'UT1'         ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+'UT2'         ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+'UT3'         ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+'HD'         ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+'UD'         ,"N",020,005} )
endif
If  _Y<6
   Aadd( aFds , {"P"+STRZERO(_Y,2)+'HT1'         ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+'HT2'         ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+'HT3'         ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+'UT1'         ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+'UT2'         ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+'UT3'         ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+'HD'         ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+'UD'         ,"N",020,005} )
endif
Next

coTbl := CriaTrab( aFds, .T. )
Use (coTbl) Alias TAB New Exclusive
dbCreateIndex(coTbl,'FILIAL', {|| FILIAL })
//***********************************
// Monta a tabela 
//***********************************

nDias:=fDias()

cQuery := "SELECT "
cQuery += "DT, "

For _Y:=1 to 14 // SACOLEIRA 
   cQuery += "ISNULL(SUM(C"+strzero(_Y,2)+"_H_MR_L*(C"+strzero(_Y,2)+"T1KG/KG_MR)),0) AS 'C"+strzero(_Y,2)+"HT1', "
   cQuery += "ISNULL(SUM(C"+strzero(_Y,2)+"_H_MR_L*(C"+strzero(_Y,2)+"T2KG/KG_MR)),0) AS 'C"+strzero(_Y,2)+"HT2', "
   cQuery += "ISNULL(SUM(C"+strzero(_Y,2)+"_H_MR_L*(C"+strzero(_Y,2)+"T3KG/KG_MR)),0) AS 'C"+strzero(_Y,2)+"HT3', "
   cQuery += "isnull(SUM(C"+strzero(_Y,2)+"T1KG),0) AS 'C"+strzero(_Y,2)+"T1KG', "
   cQuery += "isnull(SUM(C"+strzero(_Y,2)+"T2KG),0) AS 'C"+strzero(_Y,2)+"T2KG',  "
   cQuery += "isnull(SUM(C"+strzero(_Y,2)+"T3KG),0) AS 'C"+strzero(_Y,2)+"T3KG', "
next

For _Y:=1 to 5 // PICOTADEIRA 
   cQuery += "ISNULL(SUM(P"+strzero(_Y,2)+"_H_MR_L*(P"+strzero(_Y,2)+"T1KG/KG_MR)),0) AS 'P"+strzero(_Y,2)+"HT1', "
   cQuery += "ISNULL(SUM(P"+strzero(_Y,2)+"_H_MR_L*(P"+strzero(_Y,2)+"T2KG/KG_MR)),0) AS 'P"+strzero(_Y,2)+"HT2', "
   cQuery += "ISNULL(SUM(P"+strzero(_Y,2)+"_H_MR_L*(P"+strzero(_Y,2)+"T3KG/KG_MR)),0) AS 'P"+strzero(_Y,2)+"HT3', "
   cQuery += "isnull(SUM(P"+strzero(_Y,2)+"T1KG),0) AS 'P"+strzero(_Y,2)+"T1KG', "
   cQuery += "isnull(SUM(P"+strzero(_Y,2)+"T2KG),0) AS 'P"+strzero(_Y,2)+"T2KG',  "
   cQuery += "isnull(SUM(P"+strzero(_Y,2)+"T3KG),0) AS 'P"+strzero(_Y,2)+"T3KG', "
next

_y:=2 // SACOLEIRA 
cQuery += "ISNULL(SUM(S"+strzero(_Y,2)+"_H_MR_L*(S"+strzero(_Y,2)+"T1KG/KG_MR)),0) AS 'S"+strzero(_Y,2)+"HT1', "
cQuery += "ISNULL(SUM(S"+strzero(_Y,2)+"_H_MR_L*(S"+strzero(_Y,2)+"T2KG/KG_MR)),0) AS 'S"+strzero(_Y,2)+"HT2', "
cQuery += "ISNULL(SUM(S"+strzero(_Y,2)+"_H_MR_L*(S"+strzero(_Y,2)+"T3KG/KG_MR)),0) AS 'S"+strzero(_Y,2)+"HT3', "
cQuery += "isnull(SUM(S"+strzero(_Y,2)+"T1KG),0) AS 'S"+strzero(_Y,2)+"T1KG', "
cQuery += "isnull(SUM(S"+strzero(_Y,2)+"T2KG),0) AS 'S"+strzero(_Y,2)+"T2KG',  "
cQuery += "isnull(SUM(S"+strzero(_Y,2)+"T3KG),0) AS 'S"+strzero(_Y,2)+"T3KG' "

cQuery += "FROM(  "
cQuery += "SELECT  "
cQuery += "DT,  "
cQuery += "PROD, "
cQuery += "dbo.sc_RetPesoMr(PROD) as 'KG_MR', "
For _Y:=1 to 14 
   cQuery += "isnull(dbo.sc_RetMetaKg('C"+strzero(_Y,2)+"',PROD),0) AS 'C"+strzero(_Y,2)+"_H_MR_L', "
   cQuery += "isnull(SUM(CASE WHEN MAQ='C"+strzero(_Y,2)+"' AND TURNO='1' THEN PESO ELSE 0 END),0) AS 'C"+strzero(_Y,2)+"T1KG', "
   cQuery += "isnull(SUM(CASE WHEN MAQ='C"+strzero(_Y,2)+"' AND TURNO='2' THEN PESO ELSE 0 END),0) AS 'C"+strzero(_Y,2)+"T2KG', "
   cQuery += "isnull(SUM(CASE WHEN MAQ='C"+strzero(_Y,2)+"' AND TURNO='3' THEN PESO ELSE 0 END),0) AS 'C"+strzero(_Y,2)+"T3KG',  "
next 

For _Y:=1 to 5
   cQuery += "isnull(dbo.sc_RetMetaKg('P"+strzero(_Y,2)+"',PROD),0) AS 'P"+strzero(_Y,2)+"_H_MR_L', "
   cQuery += "isnull(SUM(CASE WHEN MAQ='P"+strzero(_Y,2)+"' AND TURNO='1' THEN PESO ELSE 0 END),0) AS 'P"+strzero(_Y,2)+"T1KG', "
   cQuery += "isnull(SUM(CASE WHEN MAQ='P"+strzero(_Y,2)+"' AND TURNO='2' THEN PESO ELSE 0 END),0) AS 'P"+strzero(_Y,2)+"T2KG', "
   cQuery += "isnull(SUM(CASE WHEN MAQ='P"+strzero(_Y,2)+"' AND TURNO='3' THEN PESO ELSE 0 END),0) AS 'P"+strzero(_Y,2)+"T3KG',  "
next 

_Y:=2
cQuery += "isnull(dbo.sc_RetMetaKg('S"+strzero(_Y,2)+"',PROD),0) AS 'S"+strzero(_Y,2)+"_H_MR_L', "
cQuery += "isnull(SUM(CASE WHEN MAQ='S"+strzero(_Y,2)+"' AND TURNO='1' THEN PESO ELSE 0 END),0) AS 'S"+strzero(_Y,2)+"T1KG', "
cQuery += "isnull(SUM(CASE WHEN MAQ='S"+strzero(_Y,2)+"' AND TURNO='2' THEN PESO ELSE 0 END),0) AS 'S"+strzero(_Y,2)+"T2KG', "
cQuery += "isnull(SUM(CASE WHEN MAQ='S"+strzero(_Y,2)+"' AND TURNO='3' THEN PESO ELSE 0 END),0) AS 'S"+strzero(_Y,2)+"T3KG'  "

cQuery += "FROM(  "
cQuery += "SELECT "
cQuery += "DT=CASE WHEN Z00_HORA BETWEEN '00:00' AND '05:19' THEN Z00_DATA-1 ELSE Z00_DATA END , "
cQuery += "HORA=Z00_HORA, "
cQuery += "PROD=C2_PRODUTO,MAQ=ltrim(rtrim(Z00.Z00_MAQ)),  "
cQuery += "TURNO=CASE WHEN Z00_HORA>= '05:20' AND Z00_HORA<'13:40' THEN '1' "
cQuery += "ELSE CASE WHEN Z00_HORA>='13:40' AND Z00_HORA<'22:00' THEN '2' "
cQuery += "ELSE CASE WHEN (Z00_HORA>='22:00' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '05:20' )THEN '3' "
cQuery += "ELSE 'XXXX' END END END, "
cQuery += "ISNULL(SUM(Z00_PESO+Z00_PESCAP),0) AS PESO "
cQuery += "FROM Z00020 Z00 WITH (NOLOCK), SC2020 SC2 WITH (NOLOCK), SB1010 SB1 WITH (NOLOCK) " 
cQuery += "WHERE Z00_FILIAL = ' ' AND C2_PRODUTO=B1_COD AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
cQuery += "AND Z00.Z00_DATHOR >= '"+dtos(MV_PAR01)+hora1+"' AND Z00.Z00_DATHOR < '"+dtos(MV_PAR02+1)+hora1+"'  "
cQuery += "AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0', 'C1','P0','S0' ) AND Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY Z00_DATA,Z00_HORA,C2_PRODUTO,ltrim(rtrim(Z00.Z00_MAQ)), "
cQuery += "CASE WHEN Z00_HORA>= '05:20' AND Z00_HORA<'13:40' THEN '1' "
cQuery += "ELSE CASE WHEN Z00_HORA>='13:40' AND Z00_HORA<'22:00' THEN '2' "
cQuery += "ELSE CASE WHEN (Z00_HORA>='22:00' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '05:20' )THEN '3' "
cQuery += "ELSE'XXXX' END END END "
cQuery += ") AS TABX GROUP BY DT,PROD " 
cQuery += ") AS TABY GROUP BY DT  "
cQuery += "ORDER BY DT  "

If Select("TMP") > 0
      DbSelectArea("TMP")
      DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
//TCSetField( 'TMP', "DT", "D" )


TMP->( DbGoTop() )
While TMP->(!Eof())
      RecLock("TAB",.T.)
      Replace TAB->DT       with TMP->DT
      For _Y:=1 to 14    
         &("nC"+STRZERO(_Y,2)+"T1KG")+=&("TMP->C"+strzero(_Y,2)+"T1KG")
         &("nC"+STRZERO(_Y,2)+"T2KG")+=&("TMP->C"+strzero(_Y,2)+"T2KG")
         &("nC"+STRZERO(_Y,2)+"T3KG")+=&("TMP->C"+strzero(_Y,2)+"T3KG")
         Replace &("TAB->C"+strzero(_Y,2)+"HT1")       with  &("TMP->C"+strzero(_Y,2)+"HT1")
         Replace &("TAB->C"+strzero(_Y,2)+"HT2")       with  &("TMP->C"+strzero(_Y,2)+"HT2")
         Replace &("TAB->C"+strzero(_Y,2)+"HT3")       with  &("TMP->C"+strzero(_Y,2)+"HT3")
         Replace &("TAB->C"+strzero(_Y,2)+"UT1")       with  ((&("TAB->C"+strzero(_Y,2)+"HT1")) /14.66*100)
         Replace &("TAB->C"+strzero(_Y,2)+"UT2")       with  ((&("TAB->C"+strzero(_Y,2)+"HT2"))/14.66 *100)
         Replace &("TAB->C"+strzero(_Y,2)+"UT3")       with  ((&("TAB->C"+strzero(_Y,2)+"HT3"))/12.66 *100)
         Replace &("TAB->C"+strzero(_Y,2)+"HD")        with  (&("TAB->C"+strzero(_Y,2)+"HT1")+&("TAB->C"+strzero(_Y,2)+"HT2")+&("TAB->C"+strzero(_Y,2)+"HT3"))           
         Replace &("TAB->C"+strzero(_Y,2)+"UD")        with   ((&("TAB->C"+strzero(_Y,2)+"HD"))/(IIF(&("TMP->C"+strzero(_Y,2)+"T1KG")=0,0,14.66)+IIF(&("TMP->C"+strzero(_Y,2)+"T2KG")=0,0,14.66)+IIF(&("TMP->C"+strzero(_Y,2)+"T3KG")=0,0,12.66)))*100
      If _Y=2
         &("nS"+STRZERO(_Y,2)+"T1KG")+=&("TMP->S"+strzero(_Y,2)+"T1KG")
         &("nS"+STRZERO(_Y,2)+"T2KG")+=&("TMP->S"+strzero(_Y,2)+"T2KG")
         &("nS"+STRZERO(_Y,2)+"T3KG")+=&("TMP->S"+strzero(_Y,2)+"T3KG")
         Replace &("TAB->S"+strzero(_Y,2)+"HT1")       with   &("TMP->S"+strzero(_Y,2)+"HT1")
         Replace &("TAB->S"+strzero(_Y,2)+"HT2")       with   &("TMP->S"+strzero(_Y,2)+"HT2")
         Replace &("TAB->S"+strzero(_Y,2)+"HT3")       with   &("TMP->S"+strzero(_Y,2)+"HT3")
         Replace &("TAB->S"+strzero(_Y,2)+"UT1")       with  ((&("TAB->S"+strzero(_Y,2)+"HT1")) /7.33*100)
         Replace &("TAB->S"+strzero(_Y,2)+"UT2")       with  ((&("TAB->S"+strzero(_Y,2)+"HT2"))/7.33 *100)
         Replace &("TAB->S"+strzero(_Y,2)+"UT3")       with  ((&("TAB->S"+strzero(_Y,2)+"HT3"))/6.33 *100)
         Replace &("TAB->S"+strzero(_Y,2)+"HD")        with  (&("TAB->S"+strzero(_Y,2)+"HT1")+&("TAB->S"+strzero(_Y,2)+"HT2")+&("TAB->S"+strzero(_Y,2)+"HT3"))           
         Replace &("TAB->S"+strzero(_Y,2)+"UD")        with   ((&("TAB->S"+strzero(_Y,2)+"HD"))/(IIF(&("TMP->S"+strzero(_Y,2)+"T1KG")=0,0,7.33)+IIF(&("TMP->S"+strzero(_Y,2)+"T2KG")=0,0,7.33)+IIF(&("TMP->S"+strzero(_Y,2)+"T3KG")=0,0,6.33)))*100

      Endif
      If _Y<6
         &("nP"+STRZERO(_Y,2)+"T1KG")+=&("TMP->P"+strzero(_Y,2)+"T1KG")
         &("nP"+STRZERO(_Y,2)+"T2KG")+=&("TMP->P"+strzero(_Y,2)+"T2KG")
         &("nP"+STRZERO(_Y,2)+"T3KG")+=&("TMP->P"+strzero(_Y,2)+"T3KG")
         Replace &("TAB->P"+strzero(_Y,2)+"HT1")       with   &("TMP->P"+strzero(_Y,2)+"HT1")
         Replace &("TAB->P"+strzero(_Y,2)+"HT2")       with   &("TMP->P"+strzero(_Y,2)+"HT2")
         Replace &("TAB->P"+strzero(_Y,2)+"HT3")       with   &("TMP->P"+strzero(_Y,2)+"HT3")
         Replace &("TAB->P"+strzero(_Y,2)+"UT1")       with  ((&("TAB->P"+strzero(_Y,2)+"HT1")) /7.33*100)
         Replace &("TAB->P"+strzero(_Y,2)+"UT2")       with  ((&("TAB->P"+strzero(_Y,2)+"HT2"))/7.33 *100)
         Replace &("TAB->P"+strzero(_Y,2)+"UT3")       with  ((&("TAB->P"+strzero(_Y,2)+"HT3"))/6.33 *100)
         Replace &("TAB->P"+strzero(_Y,2)+"HD")        with  (&("TAB->P"+strzero(_Y,2)+"HT1")+&("TAB->P"+strzero(_Y,2)+"HT2")+&("TAB->P"+strzero(_Y,2)+"HT3"))           
         Replace &("TAB->P"+strzero(_Y,2)+"UD")        with  ((&("TAB->P"+strzero(_Y,2)+"HD"))/(IIF(&("TMP->P"+strzero(_Y,2)+"T1KG")=0,0,7.33)+IIF(&("TMP->P"+strzero(_Y,2)+"T2KG")=0,0,7.33)+IIF(&("TMP->P"+strzero(_Y,2)+"T3KG")=0,0,6.33)))*100

      Endif
      Next      
      
      MsUnlock()
      TMP->(dbSkip())
EndDo
TAB->( DbGoTop() )
oReport:SetMeter(TAB->(RecCount()))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³   Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:Init()
oReport:SkipLine()     
oReport:SkipLine()     
oReport:Say(oReport:Row(),oReport:Col(),"Periodo de "+dtoc(MV_PAR01)+' Ate '+ dtoc(MV_PAR02) )

oReport:SkipLine()
oReport:ThinLine()

While !oReport:Cancel() .And. TAB->(!Eof())

      oReport:IncMeter()
      
      ntotHT1:=ntotUT1:=0
      ntotHT2:=ntotUT2:=0
      ntotHT3:=ntotUT3:=0

      oSection1:Cell("DT"):SetValue(DTOC(STOD(alltrim(STR(TAB->DT)))))
      oSection1:Cell("DT"):SetAlign("LEFT")      
      For _Y:=1 to 14
      // turno1
      oSection1:Cell("C"+strzero(_Y,2)+'HT1'):SetValue(&("TAB->C"+STRZERO(_Y,2)+'HT1'))
      oSection1:Cell("C"+strzero(_Y,2)+'HT1'):SetAlign("RIGHT")
      // turno2
      oSection1:Cell("C"+strzero(_Y,2)+'HT2'):SetValue(&("TAB->C"+STRZERO(_Y,2)+'HT2'))
      oSection1:Cell("C"+strzero(_Y,2)+'HT2'):SetAlign("RIGHT")
      // turno3
      oSection1:Cell("C"+strzero(_Y,2)+'HT3'):SetValue(&("TAB->C"+STRZERO(_Y,2)+'HT3'))
      oSection1:Cell("C"+strzero(_Y,2)+'HT3'):SetAlign("RIGHT")
      // % turno1
      oSection1:Cell("C"+strzero(_Y,2)+"UT1"):SetValue(&("TAB->C"+STRZERO(_Y,2)+"UT1"))
      oSection1:Cell("C"+strzero(_Y,2)+"UT1"):SetAlign("RIGHT")
      // % turno2
      oSection1:Cell("C"+strzero(_Y,2)+"UT2"):SetValue(&("TAB->C"+STRZERO(_Y,2)+"UT2"))
      oSection1:Cell("C"+strzero(_Y,2)+"UT2"):SetAlign("RIGHT")
      // % turno3
      oSection1:Cell("C"+strzero(_Y,2)+"UT3"):SetValue(&("TAB->C"+STRZERO(_Y,2)+"UT3"))
      oSection1:Cell("C"+strzero(_Y,2)+"UT3"):SetAlign("RIGHT")
      // % Dia
      oSection1:Cell("C"+strzero(_Y,2)+"UD"):SetValue(&("TAB->C"+STRZERO(_Y,2)+"UD"))
      oSection1:Cell("C"+strzero(_Y,2)+"UD"):SetAlign("RIGHT")
      If _Y=2
	      // turno1
	      oSection1:Cell("S"+strzero(_Y,2)+'HT1'):SetValue(&("TAB->S"+STRZERO(_Y,2)+'HT1'))
	      oSection1:Cell("S"+strzero(_Y,2)+'HT1'):SetAlign("RIGHT")
	      // turno2
	      oSection1:Cell("S"+strzero(_Y,2)+'HT2'):SetValue(&("TAB->S"+STRZERO(_Y,2)+'HT2'))
	      oSection1:Cell("S"+strzero(_Y,2)+'HT2'):SetAlign("RIGHT")
	      // turno3
	      oSection1:Cell("S"+strzero(_Y,2)+'HT3'):SetValue(&("TAB->S"+STRZERO(_Y,2)+'HT3'))
	      oSection1:Cell("S"+strzero(_Y,2)+'HT3'):SetAlign("RIGHT")
	      // % turno1
	      oSection1:Cell("S"+strzero(_Y,2)+"UT1"):SetValue(&("TAB->S"+STRZERO(_Y,2)+"UT1"))
	      oSection1:Cell("S"+strzero(_Y,2)+"UT1"):SetAlign("RIGHT")
	      // % turno2
	      oSection1:Cell("S"+strzero(_Y,2)+"UT2"):SetValue(&("TAB->S"+STRZERO(_Y,2)+"UT2"))
	      oSection1:Cell("S"+strzero(_Y,2)+"UT2"):SetAlign("RIGHT")
	      // % turno3
	      oSection1:Cell("S"+strzero(_Y,2)+"UT3"):SetValue(&("TAB->S"+STRZERO(_Y,2)+"UT3"))
	      oSection1:Cell("S"+strzero(_Y,2)+"UT3"):SetAlign("RIGHT")
          // % Dia
          oSection1:Cell("S"+strzero(_Y,2)+"UD"):SetValue(&("TAB->S"+STRZERO(_Y,2)+"UD"))
          oSection1:Cell("S"+strzero(_Y,2)+"UD"):SetAlign("RIGHT")

	      // HORAS 
	      ntotHT1+=&("TAB->S"+STRZERO(_Y,2)+'HT1') 
	      ntotHT2+=&("TAB->S"+STRZERO(_Y,2)+'HT2')
	      ntotHT3+=&("TAB->S"+STRZERO(_Y,2)+'HT3')
	      // UTILIZACAO  ( hora/ utilizacao )
          ntotUT1+=&("TAB->S"+STRZERO(_Y,2)+'HT1') /(&("TAB->S"+STRZERO(_Y,2)+'HT1')/7.33*100) 
          ntotUT2+=&("TAB->S"+STRZERO(_Y,2)+'HT2') /(&("TAB->S"+STRZERO(_Y,2)+'HT2')/7.33*100) 
          ntotUT3+=&("TAB->S"+STRZERO(_Y,2)+'HT3') /(&("TAB->S"+STRZERO(_Y,2)+'HT3')/6.33*100)             
      Endif      
      
      If _Y<6
	      // turno1
	      oSection1:Cell("P"+strzero(_Y,2)+'HT1'):SetValue(&("TAB->P"+STRZERO(_Y,2)+'HT1'))
	      oSection1:Cell("P"+strzero(_Y,2)+'HT1'):SetAlign("RIGHT")
	      // turno2
	      oSection1:Cell("P"+strzero(_Y,2)+'HT2'):SetValue(&("TAB->P"+STRZERO(_Y,2)+'HT2'))
	      oSection1:Cell("P"+strzero(_Y,2)+'HT2'):SetAlign("RIGHT")
	      // turno3
	      oSection1:Cell("P"+strzero(_Y,2)+'HT3'):SetValue(&("TAB->P"+STRZERO(_Y,2)+'HT3'))
	      oSection1:Cell("P"+strzero(_Y,2)+'HT3'):SetAlign("RIGHT")
	      // % turno1
	      oSection1:Cell("P"+strzero(_Y,2)+"UT1"):SetValue(&("TAB->P"+STRZERO(_Y,2)+"UT1"))
	      oSection1:Cell("P"+strzero(_Y,2)+"UT1"):SetAlign("RIGHT")
	      // % turno2
	      oSection1:Cell("P"+strzero(_Y,2)+"UT2"):SetValue(&("TAB->P"+STRZERO(_Y,2)+"UT2"))
	      oSection1:Cell("P"+strzero(_Y,2)+"UT2"):SetAlign("RIGHT")
	      // % turno3
	      oSection1:Cell("P"+strzero(_Y,2)+"UT3"):SetValue(&("TAB->P"+STRZERO(_Y,2)+"UT3"))
	      oSection1:Cell("P"+strzero(_Y,2)+"UT3"):SetAlign("RIGHT")
          // % Dia
          oSection1:Cell("P"+strzero(_Y,2)+"UD"):SetValue(&("TAB->P"+STRZERO(_Y,2)+"UD"))
          oSection1:Cell("P"+strzero(_Y,2)+"UD"):SetAlign("RIGHT")

	      // HORAS 
	      ntotHT1+=&("TAB->P"+STRZERO(_Y,2)+'HT1') 
	      ntotHT2+=&("TAB->P"+STRZERO(_Y,2)+'HT2')
	      ntotHT3+=&("TAB->P"+STRZERO(_Y,2)+'HT3')
	      // UTILIZACAO
          ntotUT1+=&("TAB->P"+STRZERO(_Y,2)+'HT1') /(&("TAB->P"+STRZERO(_Y,2)+'HT1')/7.33*100) 
          ntotUT2+=&("TAB->P"+STRZERO(_Y,2)+'HT2') /(&("TAB->P"+STRZERO(_Y,2)+'HT2')/7.33*100) 
          ntotUT3+=&("TAB->P"+STRZERO(_Y,2)+'HT3') /(&("TAB->P"+STRZERO(_Y,2)+'HT3')/6.33*100)             
      Endif      
      // HORAS 
      ntotHT1+=&("TAB->C"+STRZERO(_Y,2)+'HT1') 
      ntotHT2+=&("TAB->C"+STRZERO(_Y,2)+'HT2')
      ntotHT3+=&("TAB->C"+STRZERO(_Y,2)+'HT3')
      // UTILIZACAO
      ntotUT1+=&("TAB->C"+STRZERO(_Y,2)+'HT1') /(&("TAB->C"+STRZERO(_Y,2)+'HT1')/14.66*100) 
      ntotUT2+=&("TAB->C"+STRZERO(_Y,2)+'HT2') /(&("TAB->C"+STRZERO(_Y,2)+'HT2')/14.66*100) 
      ntotUT3+=&("TAB->C"+STRZERO(_Y,2)+'HT3') /(&("TAB->C"+STRZERO(_Y,2)+'HT3')/12.66*100)             
     
      NEXT     
      // totalizador por turno 
      oSection1:Cell("TOTALHT01"):SetValue(ntotHT1)
      oSection1:Cell("TOTALHT01"):SetAlign("RIGHT")          
      oSection1:Cell("TOTALHT02"):SetValue(ntotHT2)
      oSection1:Cell("TOTALHT02"):SetAlign("RIGHT")     
      oSection1:Cell("TOTALHT03"):SetValue(ntotHT3)
      oSection1:Cell("TOTALHT03"):SetAlign("RIGHT")
      // totalizador por dia 
      oSection1:Cell("TOTALDH"):SetValue(ntotHT1+ntotHT2+ntotHT3)
      oSection1:Cell("TOTALDH"):SetAlign("RIGHT")
      // utilizacao por turno 
      oSection1:Cell("TOTALUT01"):SetValue(ntotHT1/ntotUT1)
      oSection1:Cell("TOTALUT01"):SetAlign("RIGHT")     
      oSection1:Cell("TOTALUT02"):SetValue(ntotHT2/ntotUT2)
      oSection1:Cell("TOTALUT02"):SetAlign("RIGHT")
      oSection1:Cell("TOTALUT03"):SetValue(ntotHT3/ntotUT3)
      oSection1:Cell("TOTALUT03"):SetAlign("RIGHT")
      // utilizacao por dia 
      oSection1:Cell("TOTALDU"):SetValue((ntotHT1+ntotHT2+ntotHT3)/(ntotUT1+ntotUT2+ntotUT3))
      oSection1:Cell("TOTALDU"):SetAlign("RIGHT")


      oSection1:PrintLine()
      //oReport:SkipLine()     
      TAB->(dbSkip())

EndDo
oSection1:Finish()
dbCloseArea("TAB")
dbCloseArea("TMP")
Set Filter To

Return

**************

Static Function fDias()

***************
local cQry:=''
LOCAL nRet:=1

cQry:="SELECT "
cQry+="MAX(NUMERO) DIAS "
cQry+="FROM ( "
cQry+="SELECT "
cQry+="DATA  "
cQry+=",row_number() over(ORDER BY DATA) NUMERO "
cQry+="FROM "
cQry+="(SELECT "
cQry+="DATA=CASE WHEN Z00_HORA BETWEEN '00:00' AND '05:19' THEN Z00_DATA-1 ELSE Z00_DATA END , "
cQry+="HORA=Z00_HORA "
cQry+="FROM Z00020 Z00 WITH (NOLOCK), SC2020 SC2 WITH (NOLOCK), SB1010 SB1 WITH (NOLOCK) "
cQry+="WHERE Z00_FILIAL = ' ' "
cQry+="AND C2_PRODUTO=B1_COD  "
cQry+="AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
cQry+="AND Z00.Z00_DATHOR >= '"+DTOS(MV_PAR01)+"05:20' AND Z00.Z00_DATHOR < '"+DTOS(MV_PAR02+1)+"05:20' "
cQry+="AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0', 'C1','P0','S0') "
cQry+="AND Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ = ' ' "
cQry+="GROUP BY Z00_DATA,Z00_HORA "
cQry+=") AS TABX "
cQry+="GROUP BY DATA  "
cQry+=") AS TABY "

If Select("TMY") > 0
      DbSelectArea("TMY")
      DbCloseArea()
EndIf

TCQUERY cQry NEW ALIAS "TMY"

TMY->( DbGoTop() )
If  TMY->(!Eof())
    nRet:=TMY->DIAS
EndIf


Return  nRet