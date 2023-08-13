#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "



*************

User Function PCPR0303()

*************

Local cPerg := "PCPR030"
local oReport

Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")



hora1:=Left(cTURNO1,5)
hora2:=Left(cTURNO2,5)
hora3:=Left(cTURNO3,5)




For _Y:=1 to 14
&("nC"+STRZERO(_Y,2)+"UT1"):=0
&("nS"+STRZERO(_Y,2)+"UT1"):=0
&("nP"+STRZERO(_Y,2)+"UT1"):=0
Next

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Interface de impressao                                                  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

oReport:= ReportDef()
oReport:PrintDialog()

Return
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥FISR001  ≥ Autor ≥ Gustavo Costa          ≥ Data ≥20.09.2013≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Relatorio dos valores para conferencia da desoneraÁ„o.     .≥±±
±±≥          ≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥Nenhum                                                      ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function ReportDef()
Local oSection1
Local oSection2
Local oSection3
local oReport


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Criacao do componente de impressao                                      ≥
//≥                                                                        ≥
//≥TReport():New                                                           ≥
//≥ExpC1 : Nome do relatorio                                               ≥
//≥ExpC2 : Titulo                                                          ≥
//≥ExpC3 : Pergunte                                                        ≥
//≥ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ≥
//≥ExpC5 : Descricao                                                       ≥
//≥                                                                        ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ


Pergunte('PCPR030',.T.)                                                       

//Pergunte('PCP3V2',.T.)   

//Relatorio de UtilizaÁ„o de M·quina
 oReport:= TReport():New("PCPR030V3","Utilizacao Maquina",'PCPR030', {|oReport| ReportPrint(oReport)},"Este relatÛrio demostrar· as informaÁıes referentes a utilizaÁ„o das corte e soldas diariamente")

//oReport:SetLandscape()
oReport:SetPortrait()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Verifica as perguntas selecionadas                           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Variaveis utilizadas para parametros ≥
//≥ mv_par01   // Data de                ≥
//≥ mv_par02   // Data AtÈ               ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ


 
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø

//≥Criacao da secao utilizada pelo relatorio                               ≥
//≥                                                                        ≥
//≥TRSection():New                                                         ≥
//≥ExpO1 : Objeto TReport que a secao pertence                             ≥
//≥ExpC2 : Descricao da seÁao                                              ≥
//≥ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ≥
//≥        sera considerada como principal para a seÁ„o.                   ≥
//≥ExpA4 : Array com as Ordens do relatÛrio                                ≥
//≥ExpL5 : Carrega campos do SX3 como celulas                              ≥
//≥        Default : False                                                 ≥
//≥ExpL6 : Carrega ordens do Sindex                                        ≥
//≥        Default : False                                                 ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Sessao 1                                                     ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oSection1 := TRSection():New(oReport,"PRODUCAO",{"TAB"}) 
TRCell():New(oSection1,'FILIAL'        ,'',''                    ,PesqPict('SB1','B1_COD'),22  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PROD'          ,'','PROD'                ,PesqPict('SB1','B1_COD'),12  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'KG_MR'         ,'','KG/MR'                ,PesqPict('SB1','B1_COD'),12  ,/*lPixel*/,/*{|| code-block de impressao }*/)
For _Y:=1 to 14 // CORTE E SOLDA 
   TRCell():New(oSection1,"C"+STRZERO(_Y,2)+"_H_MR_L"  ,'',"C"+STRZERO(_Y,2)+"_H/Mr*Lado"                      ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"C"+STRZERO(_Y,2)+"T1KG"  ,'',"C"+STRZERO(_Y,2)+"_T1(kg)"                            ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"C"+STRZERO(_Y,2)+"T2KG"  ,'',"C"+STRZERO(_Y,2)+"_T2(kg)"                            ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"C"+STRZERO(_Y,2)+"T3KG"  ,'',"C"+STRZERO(_Y,2)+"_T3(kg)"                            ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"C"+STRZERO(_Y,2)+"HT1"  ,'',"C"+STRZERO(_Y,2)+"_Horas_T1"                           ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"C"+STRZERO(_Y,2)+"HT2"  ,'',"C"+STRZERO(_Y,2)+"_Horas_T2"                           ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"C"+STRZERO(_Y,2)+"HT3"  ,'',"C"+STRZERO(_Y,2)+"_Horas_T3"                           ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"C"+STRZERO(_Y,2)+"HD"  ,'',"C"+STRZERO(_Y,2)+"_Horas_Dia"                           ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)   
   TRCell():New(oSection1,"C"+STRZERO(_Y,2)+"UT1"  ,'',"C"+STRZERO(_Y,2)+"_%_T1"                               ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"C"+STRZERO(_Y,2)+"UT2"  ,'',"C"+STRZERO(_Y,2)+"_%_T2"                               ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"C"+STRZERO(_Y,2)+"UT3"  ,'',"C"+STRZERO(_Y,2)+"_%_T3"                               ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"C"+STRZERO(_Y,2)+"UD"  ,'',"C"+STRZERO(_Y,2)+"_%_Dia"                               ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
Next
For _Y:=1 to 5 // PICOTE 
   TRCell():New(oSection1,"P"+STRZERO(_Y,2)+"_H_MR_L"  ,'',"P"+STRZERO(_Y,2)+"_H/Mr*Lado"                      ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"P"+STRZERO(_Y,2)+"T1KG"  ,''   ,"P"+STRZERO(_Y,2)+"_T1(kg)"                         ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"P"+STRZERO(_Y,2)+"T2KG"  ,''   ,"P"+STRZERO(_Y,2)+"_T2(kg)"                         ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"P"+STRZERO(_Y,2)+"T3KG"  ,''   ,"P"+STRZERO(_Y,2)+"_T3(kg)"                         ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"P"+STRZERO(_Y,2)+"HT1"  ,''    ,"P"+STRZERO(_Y,2)+"_Horas_T1"                       ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"P"+STRZERO(_Y,2)+"HT2"  ,''    ,"P"+STRZERO(_Y,2)+"_Horas_T2"                       ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"P"+STRZERO(_Y,2)+"HT3"  ,''    ,"P"+STRZERO(_Y,2)+"_Horas_T3"                       ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"P"+STRZERO(_Y,2)+"HD"  ,''     ,"P"+STRZERO(_Y,2)+"_Horas_Dia"                      ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)   
   TRCell():New(oSection1,"P"+STRZERO(_Y,2)+"UT1"  ,''    ,"P"+STRZERO(_Y,2)+"_%_T1"                           ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"P"+STRZERO(_Y,2)+"UT2"  ,''    ,"P"+STRZERO(_Y,2)+"_%_T2"                           ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"P"+STRZERO(_Y,2)+"UT3"  ,''    ,"P"+STRZERO(_Y,2)+"_%_T3"                           ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,"P"+STRZERO(_Y,2)+"UD"  ,''     ,"P"+STRZERO(_Y,2)+"_%_Dia"                          ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
Next
_Y:=2 // SACOLEIRA
TRCell():New(oSection1,"S"+STRZERO(_Y,2)+"_H_MR_L"  ,'',"S"+STRZERO(_Y,2)+"_H/Mr*Lado"                      ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"S"+STRZERO(_Y,2)+"T1KG"     ,'',"S"+STRZERO(_Y,2)+"_T1(kg)"                            ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"S"+STRZERO(_Y,2)+"T2KG"     ,'',"S"+STRZERO(_Y,2)+"_T2(kg)"                            ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"S"+STRZERO(_Y,2)+"T3KG"     ,'',"S"+STRZERO(_Y,2)+"_T3(kg)"                            ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"S"+STRZERO(_Y,2)+"HT1"      ,'',"S"+STRZERO(_Y,2)+"_Horas_T1"                           ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"S"+STRZERO(_Y,2)+"HT2"      ,'',"S"+STRZERO(_Y,2)+"_Horas_T2"                           ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"S"+STRZERO(_Y,2)+"HT3"      ,'',"S"+STRZERO(_Y,2)+"_Horas_T3"                           ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"S"+STRZERO(_Y,2)+"HD"       ,'',"S"+STRZERO(_Y,2)+"_Horas_Dia"                           ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"S"+STRZERO(_Y,2)+"UT1"      ,'',"S"+STRZERO(_Y,2)+"_%_T1"                               ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"S"+STRZERO(_Y,2)+"UT2"      ,'',"S"+STRZERO(_Y,2)+"_%_T2"                               ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"S"+STRZERO(_Y,2)+"UT3"      ,'',"S"+STRZERO(_Y,2)+"_%_T3"                               ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"S"+STRZERO(_Y,2)+"UD"       ,'',"S"+STRZERO(_Y,2)+"_%_Dia"                               ,"@E 9,999,999.9999999999999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSection1,'TOTALHML'            ,'','TOTAL_HORA_MR_LADO'                 ,"@E 9,999,999.9999999999999",22  ,/*lPixel*/,/*{|| code-block de impressao }*/)
// totalizadores  por turno 
for _Z:=1 to 3
   TRCell():New(oSection1,'TOTALT'+STRZERO(_Z,2)+'KG'        ,'','TOTALT_'+alltrim(STR(_Z))+'_KG'                 ,"@E 9,999,999.9999999999999",20  ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,'TOTALHT'+STRZERO(_Z,2)            ,'','TOTAL_HORAS_T'+alltrim(STR(_Z))                 ,"@E 9,999,999.9999999999999",20  ,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New(oSection1,'TOTALUT'+STRZERO(_Z,2)            ,'','TOTAL_%_T'+alltrim(STR(_Z))                     ,"@E 9,999,999.9999999999999",20  ,/*lPixel*/,/*{|| code-block de impressao }*/)
next
//  totalizadores dia 
TRCell():New(oSection1,'TOTALDT'            ,'','TOTAL_DIA_TURNOS'                 ,"@E 9,999,999.9999999999999",20  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'TOTALDH'            ,'','TOTAL_DIA_HORAS'                 ,"@E 9,999,999.9999999999999",20  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'TOTALDU'            ,'','TOTAL_DIA_%'                 ,"@E 9,999,999.9999999999999",20  ,/*lPixel*/,/*{|| code-block de impressao }*/)

// TOTALIZADORES VERTICAIS 
oBreak := TRBreak():New(oSection1,oSection1:Cell("FILIAL"),"Total Acumulado",.F.)
TRFunction():New(oSection1:Cell("KG_MR"),"KG_MR","SUM",oBreak,"KG_MR","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
// C01
TRFunction():New(oSection1:Cell("C01_H_MR_L"),"C01_H_MR_L","SUM",oBreak,"C01_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01T1KG"),"C01T1KG","SUM",oBreak,"C01T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01T2KG"),"C01T2KG","SUM",oBreak,"C01T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01T3KG"),"C01T3KG","SUM",oBreak,"C01T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C01HT1"),"C01HT1","SUM",oBreak,"C01HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01UT1"),"C01UT1","ONPRINT",oBreak,"C01UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C01HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01HT2"),"C01HT2","SUM",oBreak,"C01HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01UT2"),"C01UT2","ONPRINT",oBreak,"C01UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C01HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01HT3"),"C01HT3","SUM",oBreak,"C01HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01UT3"),"C01UT3","ONPRINT",oBreak,"C01UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C01HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C01HD"),NIL,"SUM",oBreak,"C01HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C01UD"),"C01UD","ONPRINT",oBreak,"C01UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C01HT1"):GetValue()+oReport:GetFunction("C01HT2"):GetValue()+oReport:GetFunction("C01HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C01T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C01T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C01T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C02
TRFunction():New(oSection1:Cell("C02_H_MR_L"),"C02_H_MR_L","SUM",oBreak,"C02_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02T1KG"),"C02T1KG","SUM",oBreak,"C02T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02T2KG"),"C02T2KG","SUM",oBreak,"C02T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02T3KG"),"C02T3KG","SUM",oBreak,"C02T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C02HT1"),"C02HT1","SUM",oBreak,"C02HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02UT1"),"C02UT1","ONPRINT",oBreak,"C02UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C02HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02HT2"),"C02HT2","SUM",oBreak,"C02HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02UT2"),"C02UT2","ONPRINT",oBreak,"C02UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C02HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02HT3"),"C02HT3","SUM",oBreak,"C02HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02UT3"),"C02UT3","ONPRINT",oBreak,"C02UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C02HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C02HD"),NIL,"SUM",oBreak,"C02HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C02UD"),"C02UD","ONPRINT",oBreak,"C02UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C02HT1"):GetValue()+oReport:GetFunction("C02HT2"):GetValue()+oReport:GetFunction("C02HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C02T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C02T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C02T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C03
TRFunction():New(oSection1:Cell("C03_H_MR_L"),"C03_H_MR_L","SUM",oBreak,"C03_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03T1KG"),"C03T1KG","SUM",oBreak,"C03T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03T2KG"),"C03T2KG","SUM",oBreak,"C03T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03T3KG"),"C03T3KG","SUM",oBreak,"C03T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C03HT1"),"C03HT1","SUM",oBreak,"C03HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03UT1"),"C03UT1","ONPRINT",oBreak,"C03UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C03HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03HT2"),"C03HT2","SUM",oBreak,"C03HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03UT2"),"C03UT2","ONPRINT",oBreak,"C03UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C03HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03HT3"),"C03HT3","SUM",oBreak,"C03HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03UT3"),"C03UT3","ONPRINT",oBreak,"C03UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C03HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C03HD"),NIL,"SUM",oBreak,"C03HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C03UD"),"C03UD","ONPRINT",oBreak,"C03UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C03HT1"):GetValue()+oReport:GetFunction("C03HT2"):GetValue()+oReport:GetFunction("C03HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C03T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C03T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C03T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C04
TRFunction():New(oSection1:Cell("C04_H_MR_L"),"C04_H_MR_L","SUM",oBreak,"C04_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04T1KG"),"C04T1KG","SUM",oBreak,"C04T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04T2KG"),"C04T2KG","SUM",oBreak,"C04T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04T3KG"),"C04T3KG","SUM",oBreak,"C04T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C04HT1"),"C04HT1","SUM",oBreak,"C04HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04UT1"),"C04UT1","ONPRINT",oBreak,"C04UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C04HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04HT2"),"C04HT2","SUM",oBreak,"C04HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04UT2"),"C04UT2","ONPRINT",oBreak,"C04UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C04HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04HT3"),"C04HT3","SUM",oBreak,"C04HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04UT3"),"C04UT3","ONPRINT",oBreak,"C04UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C04HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C04HD"),NIL,"SUM",oBreak,"C04HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C04UD"),"C04UD","ONPRINT",oBreak,"C04UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C04HT1"):GetValue()+oReport:GetFunction("C04HT2"):GetValue()+oReport:GetFunction("C04HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C04T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C04T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C04T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C05
TRFunction():New(oSection1:Cell("C05_H_MR_L"),"C05_H_MR_L","SUM",oBreak,"C05_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05T1KG"),"C05T1KG","SUM",oBreak,"C05T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05T2KG"),"C05T2KG","SUM",oBreak,"C05T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05T3KG"),"C05T3KG","SUM",oBreak,"C05T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C05HT1"),"C05HT1","SUM",oBreak,"C05HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05UT1"),"C05UT1","ONPRINT",oBreak,"C05UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C05HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05HT2"),"C05HT2","SUM",oBreak,"C05HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05UT2"),"C05UT2","ONPRINT",oBreak,"C05UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C05HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05HT3"),"C05HT3","SUM",oBreak,"C05HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05UT3"),"C05UT3","ONPRINT",oBreak,"C05UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C05HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C05HD"),NIL,"SUM",oBreak,"C05HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C05UD"),"C05UD","ONPRINT",oBreak,"C05UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C05HT1"):GetValue()+oReport:GetFunction("C05HT2"):GetValue()+oReport:GetFunction("C05HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C05T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C05T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C05T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C06
TRFunction():New(oSection1:Cell("C06_H_MR_L"),"C06_H_MR_L","SUM",oBreak,"C06_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06T1KG"),"C06T1KG","SUM",oBreak,"C06T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06T2KG"),"C06T2KG","SUM",oBreak,"C06T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06T3KG"),"C06T3KG","SUM",oBreak,"C06T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C06HT1"),"C06HT1","SUM",oBreak,"C06HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06UT1"),"C06UT1","ONPRINT",oBreak,"C06UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C06HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06HT2"),"C06HT2","SUM",oBreak,"C06HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06UT2"),"C06UT2","ONPRINT",oBreak,"C06UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C06HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06HT3"),"C06HT3","SUM",oBreak,"C06HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06UT3"),"C06UT3","ONPRINT",oBreak,"C06UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C06HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C06HD"),NIL,"SUM",oBreak,"C06HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C06UD"),"C06UD","ONPRINT",oBreak,"C06UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C06HT1"):GetValue()+oReport:GetFunction("C06HT2"):GetValue()+oReport:GetFunction("C06HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C06T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C06T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C06T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C07
TRFunction():New(oSection1:Cell("C07_H_MR_L"),"C07_H_MR_L","SUM",oBreak,"C07_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07T1KG"),"C07T1KG","SUM",oBreak,"C07T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07T2KG"),"C07T2KG","SUM",oBreak,"C07T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07T3KG"),"C07T3KG","SUM",oBreak,"C07T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C07HT1"),"C07HT1","SUM",oBreak,"C07HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07UT1"),"C07UT1","ONPRINT",oBreak,"C07UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C07HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07HT2"),"C07HT2","SUM",oBreak,"C07HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07UT2"),"C07UT2","ONPRINT",oBreak,"C07UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C07HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07HT3"),"C07HT3","SUM",oBreak,"C07HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07UT3"),"C07UT3","ONPRINT",oBreak,"C07UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C07HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C07HD"),NIL,"SUM",oBreak,"C07HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C07UD"),"C07UD","ONPRINT",oBreak,"C07UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C07HT1"):GetValue()+oReport:GetFunction("C07HT2"):GetValue()+oReport:GetFunction("C07HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C07T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C07T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C07T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C08
TRFunction():New(oSection1:Cell("C08_H_MR_L"),"C08_H_MR_L","SUM",oBreak,"C08_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08T1KG"),"C08T1KG","SUM",oBreak,"C08T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08T2KG"),"C08T2KG","SUM",oBreak,"C08T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08T3KG"),"C08T3KG","SUM",oBreak,"C08T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C08HT1"),"C08HT1","SUM",oBreak,"C08HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08UT1"),"C08UT1","ONPRINT",oBreak,"C08UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C08HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08HT2"),"C08HT2","SUM",oBreak,"C08HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08UT2"),"C08UT2","ONPRINT",oBreak,"C08UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C08HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08HT3"),"C08HT3","SUM",oBreak,"C08HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08UT3"),"C08UT3","ONPRINT",oBreak,"C08UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C08HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C08HD"),NIL,"SUM",oBreak,"C08HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C08UD"),"C08UD","ONPRINT",oBreak,"C08UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C08HT1"):GetValue()+oReport:GetFunction("C08HT2"):GetValue()+oReport:GetFunction("C08HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C08T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C08T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C08T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C09
TRFunction():New(oSection1:Cell("C09_H_MR_L"),"C09_H_MR_L","SUM",oBreak,"C09_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09T1KG"),"C09T1KG","SUM",oBreak,"C09T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09T2KG"),"C09T2KG","SUM",oBreak,"C09T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09T3KG"),"C09T3KG","SUM",oBreak,"C09T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C09HT1"),"C09HT1","SUM",oBreak,"C09HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09UT1"),"C09UT1","ONPRINT",oBreak,"C09UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C09HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09HT2"),"C09HT2","SUM",oBreak,"C09HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09UT2"),"C09UT2","ONPRINT",oBreak,"C09UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C09HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09HT3"),"C09HT3","SUM",oBreak,"C09HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09UT3"),"C09UT3","ONPRINT",oBreak,"C09UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C09HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C09HD"),NIL,"SUM",oBreak,"C09HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C09UD"),"C09UD","ONPRINT",oBreak,"C09UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C09HT1"):GetValue()+oReport:GetFunction("C09HT2"):GetValue()+oReport:GetFunction("C09HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C09T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C09T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C09T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C10
TRFunction():New(oSection1:Cell("C10_H_MR_L"),"C10_H_MR_L","SUM",oBreak,"C10_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10T1KG"),"C10T1KG","SUM",oBreak,"C10T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10T2KG"),"C10T2KG","SUM",oBreak,"C10T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10T3KG"),"C10T3KG","SUM",oBreak,"C10T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C10HT1"),"C10HT1","SUM",oBreak,"C10HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10UT1"),"C10UT1","ONPRINT",oBreak,"C10UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C10HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10HT2"),"C10HT2","SUM",oBreak,"C10HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10UT2"),"C10UT2","ONPRINT",oBreak,"C10UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C10HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10HT3"),"C10HT3","SUM",oBreak,"C10HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10UT3"),"C10UT3","ONPRINT",oBreak,"C10UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C10HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C10HD"),NIL,"SUM",oBreak,"C10HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C10UD"),"C10UD","ONPRINT",oBreak,"C10UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C10HT1"):GetValue()+oReport:GetFunction("C10HT2"):GetValue()+oReport:GetFunction("C10HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C10T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C10T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C10T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C11
TRFunction():New(oSection1:Cell("C11_H_MR_L"),"C11_H_MR_L","SUM",oBreak,"C11_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11T1KG"),"C11T1KG","SUM",oBreak,"C11T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11T2KG"),"C11T2KG","SUM",oBreak,"C11T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11T3KG"),"C11T3KG","SUM",oBreak,"C11T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C11HT1"),"C11HT1","SUM",oBreak,"C11HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11UT1"),"C11UT1","ONPRINT",oBreak,"C11UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C11HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11HT2"),"C11HT2","SUM",oBreak,"C11HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11UT2"),"C11UT2","ONPRINT",oBreak,"C11UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C11HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11HT3"),"C11HT3","SUM",oBreak,"C11HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11UT3"),"C11UT3","ONPRINT",oBreak,"C11UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C11HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C11HD"),NIL,"SUM",oBreak,"C11HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C11UD"),"C11UD","ONPRINT",oBreak,"C11UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C11HT1"):GetValue()+oReport:GetFunction("C11HT2"):GetValue()+oReport:GetFunction("C11HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C11T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C11T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C11T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C12
TRFunction():New(oSection1:Cell("C12_H_MR_L"),"C12_H_MR_L","SUM",oBreak,"C12_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12T1KG"),"C12T1KG","SUM",oBreak,"C12T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12T2KG"),"C12T2KG","SUM",oBreak,"C12T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12T3KG"),"C12T3KG","SUM",oBreak,"C12T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C12HT1"),"C12HT1","SUM",oBreak,"C12HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12UT1"),"C12UT1","ONPRINT",oBreak,"C12UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C12HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12HT2"),"C12HT2","SUM",oBreak,"C12HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12UT2"),"C12UT2","ONPRINT",oBreak,"C12UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C12HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12HT3"),"C12HT3","SUM",oBreak,"C12HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12UT3"),"C12UT3","ONPRINT",oBreak,"C12UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C12HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C12HD"),NIL,"SUM",oBreak,"C12HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C12UD"),"C12UD","ONPRINT",oBreak,"C12UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C12HT1"):GetValue()+oReport:GetFunction("C12HT2"):GetValue()+oReport:GetFunction("C12HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C12T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C12T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C12T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C13
TRFunction():New(oSection1:Cell("C13_H_MR_L"),"C13_H_MR_L","SUM",oBreak,"C13_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13T1KG"),"C13T1KG","SUM",oBreak,"C13T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13T2KG"),"C13T2KG","SUM",oBreak,"C13T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13T3KG"),"C13T3KG","SUM",oBreak,"C13T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C13HT1"),"C13HT1","SUM",oBreak,"C13HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13UT1"),"C13UT1","ONPRINT",oBreak,"C13UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C13HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13HT2"),"C13HT2","SUM",oBreak,"C13HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13UT2"),"C13UT2","ONPRINT",oBreak,"C13UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C13HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13HT3"),"C13HT3","SUM",oBreak,"C13HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13UT3"),"C13UT3","ONPRINT",oBreak,"C13UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C13HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C13HD"),NIL,"SUM",oBreak,"C13HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C13UD"),"C13UD","ONPRINT",oBreak,"C13UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C13HT1"):GetValue()+oReport:GetFunction("C13HT2"):GetValue()+oReport:GetFunction("C13HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C13T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C13T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C13T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// C14
TRFunction():New(oSection1:Cell("C14_H_MR_L"),"C14_H_MR_L","SUM",oBreak,"C14_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14T1KG"),"C14T1KG","SUM",oBreak,"C14T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14T2KG"),"C14T2KG","SUM",oBreak,"C14T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14T3KG"),"C14T3KG","SUM",oBreak,"C14T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("C14HT1"),"C14HT1","SUM",oBreak,"C14HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14UT1"),"C14UT1","ONPRINT",oBreak,"C14UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C14HT1"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14HT2"),"C14HT2","SUM",oBreak,"C14HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14UT2"),"C14UT2","ONPRINT",oBreak,"C14UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C14HT2"):GetValue())/(nDias*14.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14HT3"),"C14HT3","SUM",oBreak,"C14HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14UT3"),"C14UT3","ONPRINT",oBreak,"C14UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("C14HT3"):GetValue())/(nDias*12.66)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("C14HD"),NIL,"SUM",oBreak,"C14HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("C14UD"),"C14UD","ONPRINT",oBreak,"C14UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("C14HT1"):GetValue()+oReport:GetFunction("C14HT2"):GetValue()+oReport:GetFunction("C14HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("C14T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C14T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("C14T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// P01
TRFunction():New(oSection1:Cell("P01_H_MR_L"),"P01_H_MR_L","SUM",oBreak,"P01_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01T1KG"),"P01T1KG","SUM",oBreak,"P01T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01T2KG"),"P01T2KG","SUM",oBreak,"P01T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01T3KG"),"P01T3KG","SUM",oBreak,"P01T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("P01HT1"),"P01HT1","SUM",oBreak,"P01HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01UT1"),"P01UT1","ONPRINT",oBreak,"P01UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P01HT1"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01HT2"),"P01HT2","SUM",oBreak,"P01HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01UT2"),"P01UT2","ONPRINT",oBreak,"P01UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P01HT2"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01HT3"),"P01HT3","SUM",oBreak,"P01HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01UT3"),"P01UT3","ONPRINT",oBreak,"P01UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P01HT3"):GetValue())/(nDias*6.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P01HD"),NIL,"SUM",oBreak,"P01HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("P01UD"),"P01UD","ONPRINT",oBreak,"P01UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("P01HT1"):GetValue()+oReport:GetFunction("P01HT2"):GetValue()+oReport:GetFunction("P01HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("P01T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("P01T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("P01T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// P02
TRFunction():New(oSection1:Cell("P02_H_MR_L"),"P02_H_MR_L","SUM",oBreak,"P02_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02T1KG"),"P02T1KG","SUM",oBreak,"P02T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02T2KG"),"P02T2KG","SUM",oBreak,"P02T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02T3KG"),"P02T3KG","SUM",oBreak,"P02T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("P02HT1"),"P02HT1","SUM",oBreak,"P02HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02UT1"),"P02UT1","ONPRINT",oBreak,"P02UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P02HT1"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02HT2"),"P02HT2","SUM",oBreak,"P02HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02UT2"),"P02UT2","ONPRINT",oBreak,"P02UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P02HT2"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02HT3"),"P02HT3","SUM",oBreak,"P02HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02UT3"),"P02UT3","ONPRINT",oBreak,"P02UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P02HT3"):GetValue())/(nDias*6.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P02HD"),NIL,"SUM",oBreak,"P02HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("P02UD"),"P02UD","ONPRINT",oBreak,"P02UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("P02HT1"):GetValue()+oReport:GetFunction("P02HT2"):GetValue()+oReport:GetFunction("P02HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("P02T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("P02T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("P02T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// P03
TRFunction():New(oSection1:Cell("P03_H_MR_L"),"P03_H_MR_L","SUM",oBreak,"P03_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03T1KG"),"P03T1KG","SUM",oBreak,"P03T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03T2KG"),"P03T2KG","SUM",oBreak,"P03T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03T3KG"),"P03T3KG","SUM",oBreak,"P03T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("P03HT1"),"P03HT1","SUM",oBreak,"P03HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03UT1"),"P03UT1","ONPRINT",oBreak,"P03UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P03HT1"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03HT2"),"P03HT2","SUM",oBreak,"P03HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03UT2"),"P03UT2","ONPRINT",oBreak,"P03UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P03HT2"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03HT3"),"P03HT3","SUM",oBreak,"P03HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03UT3"),"P03UT3","ONPRINT",oBreak,"P03UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P03HT3"):GetValue())/(nDias*6.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P03HD"),NIL,"SUM",oBreak,"P03HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("P03UD"),"P03UD","ONPRINT",oBreak,"P03UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("P03HT1"):GetValue()+oReport:GetFunction("P03HT2"):GetValue()+oReport:GetFunction("P03HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("P03T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("P03T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("P03T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// P04
TRFunction():New(oSection1:Cell("P04_H_MR_L"),"P04_H_MR_L","SUM",oBreak,"P04_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04T1KG"),"P04T1KG","SUM",oBreak,"P04T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04T2KG"),"P04T2KG","SUM",oBreak,"P04T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04T3KG"),"P04T3KG","SUM",oBreak,"P04T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("P04HT1"),"P04HT1","SUM",oBreak,"P04HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04UT1"),"P04UT1","ONPRINT",oBreak,"P04UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P04HT1"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04HT2"),"P04HT2","SUM",oBreak,"P04HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04UT2"),"P04UT2","ONPRINT",oBreak,"P04UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P04HT2"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04HT3"),"P04HT3","SUM",oBreak,"P04HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04UT3"),"P04UT3","ONPRINT",oBreak,"P04UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P04HT3"):GetValue())/(nDias*6.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P04HD"),NIL,"SUM",oBreak,"P04HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("P04UD"),"P04UD","ONPRINT",oBreak,"P04UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("P04HT1"):GetValue()+oReport:GetFunction("P04HT2"):GetValue()+oReport:GetFunction("P04HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("P04T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("P04T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("P04T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// P05
TRFunction():New(oSection1:Cell("P05_H_MR_L"),"P05_H_MR_L","SUM",oBreak,"P05_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05T1KG"),"P05T1KG","SUM",oBreak,"P05T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05T2KG"),"P05T2KG","SUM",oBreak,"P05T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05T3KG"),"P05T3KG","SUM",oBreak,"P05T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("P05HT1"),"P05HT1","SUM",oBreak,"P05HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05UT1"),"P05UT1","ONPRINT",oBreak,"P05UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P05HT1"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05HT2"),"P05HT2","SUM",oBreak,"P05HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05UT2"),"P05UT2","ONPRINT",oBreak,"P05UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P05HT2"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05HT3"),"P05HT3","SUM",oBreak,"P05HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05UT3"),"P05UT3","ONPRINT",oBreak,"P05UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("P05HT3"):GetValue())/(nDias*6.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("P05HD"),NIL,"SUM",oBreak,"P05HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("P05UD"),"P05UD","ONPRINT",oBreak,"P05UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("P05HT1"):GetValue()+oReport:GetFunction("P05HT2"):GetValue()+oReport:GetFunction("P05HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("P05T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("P05T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("P05T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)
// S02
TRFunction():New(oSection1:Cell("S02_H_MR_L"),"S02_H_MR_L","SUM",oBreak,"S02_H_MR_L","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02T1KG"),"S02T1KG","SUM",oBreak,"S02T1KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02T2KG"),"S02T2KG","SUM",oBreak,"S02T2KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02T3KG"),"S02T3KG","SUM",oBreak,"S02T3KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)        
TRFunction():New(oSection1:Cell("S02HT1"),"S02HT1","SUM",oBreak,"S02HT1","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02UT1"),"S02UT1","ONPRINT",oBreak,"S02UT1","@E 9,999,999.9999999999999",{||(oReport:GetFunction("S02HT1"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02HT2"),"S02HT2","SUM",oBreak,"S02HT2","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02UT2"),"S02UT2","ONPRINT",oBreak,"S02UT2","@E 9,999,999.9999999999999",{||(oReport:GetFunction("S02HT2"):GetValue())/(nDias*7.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02HT3"),"S02HT3","SUM",oBreak,"S02HT3","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02UT3"),"S02UT3","ONPRINT",oBreak,"S02UT3","@E 9,999,999.9999999999999",{||(oReport:GetFunction("S02HT3"):GetValue())/(nDias*6.33)*100 },.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("S02HD"),NIL,"SUM",oBreak,"S02HD","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)  
TRFunction():New(oSection1:Cell("S02UD"),"S02UD","ONPRINT",oBreak,"S02UD","@E 9,999,999.9999999999999",{||((oReport:GetFunction("S02HT1"):GetValue()+oReport:GetFunction("S02HT2"):GetValue()+oReport:GetFunction("S02HT3"):GetValue())/(nDias*(IIF(oReport:GetFunction("S02T1KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("S02T2KG"):GetValue()=0,0,14.66)+IIF(oReport:GetFunction("S02T3KG"):GetValue()=0,0,12.66))))*100 },.F.,.F.,.F.,oSection1)

// totalizador 
// HORA_MR_LADO
TRFunction():New(oSection1:Cell("TOTALHML"),"TOTALHML","SUM",oBreak,"TOTALHML","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
// total T1
TRFunction():New(oSection1:Cell("TOTALT01KG"),"TOTALT01KG","SUM",oBreak,"TOTALT01KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("TOTALHT01"),"TOTALHT01","SUM",oBreak,"TOTALHT01","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("TOTALUT01"),"TOTALUT01","ONPRINT",oBreak,"TOTALUT01","@E 9,999,999.9999999999999",{|| (oReport:GetFunction("TOTALHT01"):GetValue())/((oReport:GetFunction("C01HT1"):GetValue())/((oReport:GetFunction("C01HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C02HT1"):GetValue())/((oReport:GetFunction("C02HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C03HT1"):GetValue())/((oReport:GetFunction("C03HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C04HT1"):GetValue())/((oReport:GetFunction("C04HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C05HT1"):GetValue())/((oReport:GetFunction("C05HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C06HT1"):GetValue())/((oReport:GetFunction("C06HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C07HT1"):GetValue())/((oReport:GetFunction("C07HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C08HT1"):GetValue())/((oReport:GetFunction("C08HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C09HT1"):GetValue())/((oReport:GetFunction("C09HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C10HT1"):GetValue())/((oReport:GetFunction("C10HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C11HT1"):GetValue())/((oReport:GetFunction("C11HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C12HT1"):GetValue())/((oReport:GetFunction("C12HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C13HT1"):GetValue())/((oReport:GetFunction("C13HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C14HT1"):GetValue())/((oReport:GetFunction("C14HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("P01HT1"):GetValue())/((oReport:GetFunction("P01HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P02HT1"):GetValue())/((oReport:GetFunction("P02HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P03HT1"):GetValue())/((oReport:GetFunction("P03HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P04HT1"):GetValue())/((oReport:GetFunction("P04HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P05HT1"):GetValue())/((oReport:GetFunction("P05HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("S02HT1"):GetValue())/((oReport:GetFunction("S02HT1"):GetValue())/(nDias*7.33)*100) ) },.F.,.F.,.F.,oSection1)
// total T2
TRFunction():New(oSection1:Cell("TOTALT02KG"),"TOTALT02KG","SUM",oBreak,"TOTALT02KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("TOTALHT02"),"TOTALHT02","SUM",oBreak,"TOTALHT02","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("TOTALUT02"),"TOTALUT02","ONPRINT",oBreak,"TOTALUT02","@E 9,999,999.9999999999999",{|| (oReport:GetFunction("TOTALHT02"):GetValue())/((oReport:GetFunction("C01HT2"):GetValue())/((oReport:GetFunction("C01HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C02HT2"):GetValue())/((oReport:GetFunction("C02HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C03HT2"):GetValue())/((oReport:GetFunction("C03HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C04HT2"):GetValue())/((oReport:GetFunction("C04HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C05HT2"):GetValue())/((oReport:GetFunction("C05HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C06HT2"):GetValue())/((oReport:GetFunction("C06HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C07HT2"):GetValue())/((oReport:GetFunction("C07HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C08HT2"):GetValue())/((oReport:GetFunction("C08HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C09HT2"):GetValue())/((oReport:GetFunction("C09HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C10HT2"):GetValue())/((oReport:GetFunction("C10HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C11HT2"):GetValue())/((oReport:GetFunction("C11HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C12HT2"):GetValue())/((oReport:GetFunction("C12HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C13HT2"):GetValue())/((oReport:GetFunction("C13HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C14HT2"):GetValue())/((oReport:GetFunction("C14HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("P01HT2"):GetValue())/((oReport:GetFunction("P01HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P02HT2"):GetValue())/((oReport:GetFunction("P02HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P03HT2"):GetValue())/((oReport:GetFunction("P03HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P04HT2"):GetValue())/((oReport:GetFunction("P04HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P05HT2"):GetValue())/((oReport:GetFunction("P05HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("S02HT2"):GetValue())/((oReport:GetFunction("S02HT2"):GetValue())/(nDias*7.33)*100)) },.F.,.F.,.F.,oSection1)
// total T3
TRFunction():New(oSection1:Cell("TOTALT03KG"),"TOTALT03KG","SUM",oBreak,"TOTALT03KG","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("TOTALHT03"),"TOTALHT03","SUM",oBreak,"TOTALHT03","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("TOTALUT03"),"TOTALUT03","ONPRINT",oBreak,"TOTALUT03","@E 9,999,999.9999999999999",{|| (oReport:GetFunction("TOTALHT03"):GetValue())/((oReport:GetFunction("C01HT3"):GetValue())/((oReport:GetFunction("C01HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C02HT3"):GetValue())/((oReport:GetFunction("C02HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C03HT3"):GetValue())/((oReport:GetFunction("C03HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C04HT3"):GetValue())/((oReport:GetFunction("C04HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C05HT3"):GetValue())/((oReport:GetFunction("C05HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C06HT3"):GetValue())/((oReport:GetFunction("C06HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C07HT3"):GetValue())/((oReport:GetFunction("C07HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C08HT3"):GetValue())/((oReport:GetFunction("C08HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C09HT3"):GetValue())/((oReport:GetFunction("C09HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C10HT3"):GetValue())/((oReport:GetFunction("C10HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C11HT3"):GetValue())/((oReport:GetFunction("C11HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C12HT3"):GetValue())/((oReport:GetFunction("C12HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C13HT3"):GetValue())/((oReport:GetFunction("C13HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C14HT3"):GetValue())/((oReport:GetFunction("C14HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("P01HT3"):GetValue())/((oReport:GetFunction("P01HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P02HT3"):GetValue())/((oReport:GetFunction("P02HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P03HT3"):GetValue())/((oReport:GetFunction("P03HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P04HT3"):GetValue())/((oReport:GetFunction("P04HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P05HT3"):GetValue())/((oReport:GetFunction("P05HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("S02HT3"):GetValue())/((oReport:GetFunction("S02HT3"):GetValue())/(nDias*6.33)*100)) },.F.,.F.,.F.,oSection1)
//TOTAL DIA 

TRFunction():New(oSection1:Cell("TOTALDT"),"TOTALDT","SUM",oBreak,"TOTALDT","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("TOTALDH"),"TOTALDH","SUM",oBreak,"TOTALDH","@E 9,999,999.9999999999999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("TOTALDU"),"TOTALDU","ONPRINT",oBreak,"TOTALDU","@E 9,999,999.9999999999999",{|| (oReport:GetFunction("TOTALHT01"):GetValue()+oReport:GetFunction("TOTALHT02"):GetValue()+oReport:GetFunction("TOTALHT03"):GetValue())/( ;
oReport:GetFunction("TOTALHT01"):GetValue()/((oReport:GetFunction("TOTALHT01"):GetValue())/((oReport:GetFunction("C01HT1"):GetValue())/((oReport:GetFunction("C01HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C02HT1"):GetValue())/((oReport:GetFunction("C02HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C03HT1"):GetValue())/((oReport:GetFunction("C03HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C04HT1"):GetValue())/((oReport:GetFunction("C04HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C05HT1"):GetValue())/((oReport:GetFunction("C05HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C06HT1"):GetValue())/((oReport:GetFunction("C06HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C07HT1"):GetValue())/((oReport:GetFunction("C07HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C08HT1"):GetValue())/((oReport:GetFunction("C08HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C09HT1"):GetValue())/((oReport:GetFunction("C09HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C10HT1"):GetValue())/((oReport:GetFunction("C10HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C11HT1"):GetValue())/((oReport:GetFunction("C11HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C12HT1"):GetValue())/((oReport:GetFunction("C12HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C13HT1"):GetValue())/((oReport:GetFunction("C13HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C14HT1"):GetValue())/((oReport:GetFunction("C14HT1"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("P01HT1"):GetValue())/((oReport:GetFunction("P01HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P02HT1"):GetValue())/((oReport:GetFunction("P02HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P03HT1"):GetValue())/((oReport:GetFunction("P03HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P04HT1"):GetValue())/((oReport:GetFunction("P04HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P05HT1"):GetValue())/((oReport:GetFunction("P05HT1"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("S02HT1"):GetValue())/((oReport:GetFunction("S02HT1"):GetValue())/(nDias*7.33)*100))) ;
+oReport:GetFunction("TOTALHT02"):GetValue()/((oReport:GetFunction("TOTALHT02"):GetValue())/((oReport:GetFunction("C01HT2"):GetValue())/((oReport:GetFunction("C01HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C02HT2"):GetValue())/((oReport:GetFunction("C02HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C03HT2"):GetValue())/((oReport:GetFunction("C03HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C04HT2"):GetValue())/((oReport:GetFunction("C04HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C05HT2"):GetValue())/((oReport:GetFunction("C05HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C06HT2"):GetValue())/((oReport:GetFunction("C06HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C07HT2"):GetValue())/((oReport:GetFunction("C07HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C08HT2"):GetValue())/((oReport:GetFunction("C08HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C09HT2"):GetValue())/((oReport:GetFunction("C09HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C10HT2"):GetValue())/((oReport:GetFunction("C10HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C11HT2"):GetValue())/((oReport:GetFunction("C11HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C12HT2"):GetValue())/((oReport:GetFunction("C12HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C13HT2"):GetValue())/((oReport:GetFunction("C13HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("C14HT2"):GetValue())/((oReport:GetFunction("C14HT2"):GetValue())/(nDias*14.66)*100)+(oReport:GetFunction("P01HT2"):GetValue())/((oReport:GetFunction("P01HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P02HT2"):GetValue())/((oReport:GetFunction("P02HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P03HT2"):GetValue())/((oReport:GetFunction("P03HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P04HT2"):GetValue())/((oReport:GetFunction("P04HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P05HT2"):GetValue())/((oReport:GetFunction("P05HT2"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("S02HT2"):GetValue())/((oReport:GetFunction("S02HT2"):GetValue())/(nDias*7.33)*100))) ;
+oReport:GetFunction("TOTALHT03"):GetValue()/((oReport:GetFunction("TOTALHT03"):GetValue())/((oReport:GetFunction("C01HT3"):GetValue())/((oReport:GetFunction("C01HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C02HT3"):GetValue())/((oReport:GetFunction("C02HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C03HT3"):GetValue())/((oReport:GetFunction("C03HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C04HT3"):GetValue())/((oReport:GetFunction("C04HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C05HT3"):GetValue())/((oReport:GetFunction("C05HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C06HT3"):GetValue())/((oReport:GetFunction("C06HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C07HT3"):GetValue())/((oReport:GetFunction("C07HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C08HT3"):GetValue())/((oReport:GetFunction("C08HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C09HT3"):GetValue())/((oReport:GetFunction("C09HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C10HT3"):GetValue())/((oReport:GetFunction("C10HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C11HT3"):GetValue())/((oReport:GetFunction("C11HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C12HT3"):GetValue())/((oReport:GetFunction("C12HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C13HT3"):GetValue())/((oReport:GetFunction("C13HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("C14HT3"):GetValue())/((oReport:GetFunction("C14HT3"):GetValue())/(nDias*12.66)*100)+(oReport:GetFunction("P01HT3"):GetValue())/((oReport:GetFunction("P01HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P02HT3"):GetValue())/((oReport:GetFunction("P02HT3"):GetValue())/(nDias*7.33)*100)+(oReport:GetFunction("P03HT3"):GetValue())/((oReport:GetFunction("P03HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P04HT3"):GetValue())/((oReport:GetFunction("P04HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("P05HT3"):GetValue())/((oReport:GetFunction("P05HT3"):GetValue())/(nDias*6.33)*100)+(oReport:GetFunction("S02HT3"):GetValue())/((oReport:GetFunction("S02HT3"):GetValue())/(nDias*6.33)*100))) ;
)},.F.,.F.,.F.,oSection1)

// Periodo de ate 
oBreak := TRBreak():New(oSection1,oSection1:Cell("FILIAL"),"Data " ,.F.)
TRFunction():New(oSection1:Cell("PROD"),"PROD","ONPRINT",oBreak,"PROD",PesqPict('SB1','B1_COD'),{||  DTOC(MV_PAR01) },.F.,.F.,.F.,oSection1)


Return(oReport)
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥PONR003 ≥ Autor ≥ Gustavo Costa           ≥ Data ≥20.06.2013≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥A funcao estatica ReportPrint devera ser criada para todos  ≥±±
±±≥          ≥os relatorios que poderao ser agendados pelo usuario.       ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Retorno   ≥Nenhum                                                      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ExpO1: Objeto Report do Relatorio                           ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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
local aSacole:={}
//******************************
// Monta a tabela tempor·ria
//******************************
Aadd( aFds , {"PROD"                              ,"C",030,000} )
Aadd( aFds , {"KG_MR"                             ,"N",020,005} )

For _Y:=1 to 14
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"_H_MR_L"      ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"T1KG"         ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"T2KG"         ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"T3KG"         ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"HT1"          ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"HT2"          ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"HT3"          ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"UT1"          ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"UT2"          ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"UT3"          ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"HD"           ,"N",020,005} ) 
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"UD"           ,"N",020,005} )
If _Y=2 
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"_H_MR_L"      ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"T1KG"         ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"T2KG"         ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"T3KG"         ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"HT1"          ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"HT2"          ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"HT3"          ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"UT1"          ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"UT2"          ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"UT3"          ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"HD"           ,"N",020,005} ) 
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"UD"           ,"N",020,005} )
Endif
If _Y<6 
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"_H_MR_L"      ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"T1KG"         ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"T2KG"         ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"T3KG"         ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"HT1"          ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"HT2"          ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"HT3"          ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"UT1"          ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"UT2"          ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"UT3"          ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"HD"           ,"N",020,005} ) 
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"UD"           ,"N",020,005} )
Endif
Next

coTbl := CriaTrab( aFds, .T. )
Use (coTbl) Alias TAB New Exclusive
dbCreateIndex(coTbl,'PROD', {|| PROD })
//***********************************
// Monta a tabela 
//***********************************

nDias:= 1 //fDias()

dDataDe:=MV_PAR01

cQuery := "SELECT PROD, "
cQuery += "dbo.sc_RetPesoMr(PROD) as 'KG_MR', "
for _Y:=1 to 14
  cQuery += "isnull(dbo.sc_RetMetaKg('C"+STRZERO(_Y,2)+"',PROD),0) AS 'C"+STRZERO(_Y,2)+"_H_MR_L', "
  cQuery += "isnull(SUM(CASE WHEN MAQ='C"+STRZERO(_Y,2)+"' AND TURNO='1' THEN PESO ELSE 0 END),0) AS 'C"+STRZERO(_Y,2)+"T1KG', "
  cQuery += "isnull(SUM(CASE WHEN MAQ='C"+STRZERO(_Y,2)+"' AND TURNO='2' THEN PESO ELSE 0 END),0) AS 'C"+STRZERO(_Y,2)+"T2KG', "
  cQuery += "isnull(SUM(CASE WHEN MAQ='C"+STRZERO(_Y,2)+"' AND TURNO='3' THEN PESO ELSE 0 END),0) AS 'C"+STRZERO(_Y,2)+"T3KG', "
next 
_y:=2
cQuery += "isnull(dbo.sc_RetMetaKg('S"+STRZERO(_Y,2)+"',PROD),0) AS 'S"+STRZERO(_Y,2)+"_H_MR_L', "
cQuery += "isnull(SUM(CASE WHEN MAQ='S"+STRZERO(_Y,2)+"' AND TURNO='1' THEN PESO ELSE 0 END),0) AS 'S"+STRZERO(_Y,2)+"T1KG', "
cQuery += "isnull(SUM(CASE WHEN MAQ='S"+STRZERO(_Y,2)+"' AND TURNO='2' THEN PESO ELSE 0 END),0) AS 'S"+STRZERO(_Y,2)+"T2KG', "
cQuery += "isnull(SUM(CASE WHEN MAQ='S"+STRZERO(_Y,2)+"' AND TURNO='3' THEN PESO ELSE 0 END),0) AS 'S"+STRZERO(_Y,2)+"T3KG', "

for _Y:=1 to 5
  cQuery += "isnull(dbo.sc_RetMetaKg('P"+STRZERO(_Y,2)+"',PROD),0) AS 'P"+STRZERO(_Y,2)+"_H_MR_L', "
  cQuery += "isnull(SUM(CASE WHEN MAQ='P"+STRZERO(_Y,2)+"' AND TURNO='1' THEN PESO ELSE 0 END),0) AS 'P"+STRZERO(_Y,2)+"T1KG', "
  cQuery += "isnull(SUM(CASE WHEN MAQ='P"+STRZERO(_Y,2)+"' AND TURNO='2' THEN PESO ELSE 0 END),0) AS 'P"+STRZERO(_Y,2)+"T2KG', "
  IF _y=5
    cQuery += "isnull(SUM(CASE WHEN MAQ='P"+STRZERO(_Y,2)+"' AND TURNO='3' THEN PESO ELSE 0 END),0) AS 'P"+STRZERO(_Y,2)+"T3KG' "
  ELSE
    cQuery += "isnull(SUM(CASE WHEN MAQ='P"+STRZERO(_Y,2)+"' AND TURNO='3' THEN PESO ELSE 0 END),0) AS 'P"+STRZERO(_Y,2)+"T3KG', "  
  ENDIF  
NEXT
cQuery += "FROM( SELECT "
cQuery += "PROD=C2_PRODUTO,MAQ=ltrim(rtrim(Z00.Z00_MAQ)), "
cQuery += "TURNO=CASE WHEN Z00_HORA>= '05:20' AND Z00_HORA<'13:40' THEN '1' "
cQuery += "ELSE CASE WHEN Z00_HORA>='13:40' AND Z00_HORA<'22:00' THEN '2' "
cQuery += "ELSE CASE WHEN (Z00_HORA>='22:00' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '05:20' )THEN '3' "
cQuery += "ELSE 'XXXX' END END END, "
cQuery += "ISNULL(SUM(Z00_PESO+Z00_PESCAP),0) AS PESO "
cQuery += "FROM Z00020 Z00 WITH (NOLOCK), SC2020 SC2 WITH (NOLOCK), SB1010 SB1 WITH (NOLOCK) "
cQuery += "WHERE Z00_FILIAL = ' ' AND C2_PRODUTO=B1_COD AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
cQuery += "AND Z00.Z00_DATHOR >= '"+dtos(dDataDe)+hora1+"' AND Z00.Z00_DATHOR < '"+dtos(dDataDe+1)+hora1+"' "
cQuery += "AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0', 'C1','P0','S0' ) AND Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY C2_PRODUTO,ltrim(rtrim(Z00.Z00_MAQ)), "
cQuery += "CASE WHEN Z00_HORA>= '05:20' AND Z00_HORA<'13:40' THEN '1' "
cQuery += "ELSE CASE WHEN Z00_HORA>='13:40' AND Z00_HORA<'22:00' THEN '2' "
cQuery += "ELSE CASE WHEN (Z00_HORA>='22:00' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '05:20' )THEN '3' "
cQuery += "ELSE'XXXX' END END END "
cQuery += ") AS TABX GROUP BY PROD  "

If Select("TMP") > 0
      DbSelectArea("TMP")
      DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )
While TMP->(!Eof())

      RecLock("TAB",.T.)     
     
      Replace TAB->PROD         with TMP->PROD
      Replace TAB->KG_MR        with TMP->KG_MR               

      For _Y:=1 to 14
         Replace &("TAB->C"+strzero(_Y,2)+"_H_MR_L")   with  &("TMP->C"+strzero(_Y,2)+"_H_MR_L")
         Replace &("TAB->C"+strzero(_Y,2)+"T1KG")      with  &("TMP->C"+strzero(_Y,2)+"T1KG")
         Replace &("TAB->C"+strzero(_Y,2)+"T2KG")      with  &("TMP->C"+strzero(_Y,2)+"T2KG")
         Replace &("TAB->C"+strzero(_Y,2)+"T3KG")      with  &("TMP->C"+strzero(_Y,2)+"T3KG")
         Replace &("TAB->C"+strzero(_Y,2)+"HT1")       with  ((&("TMP->C"+strzero(_Y,2)+"_H_MR_L"))*(&("TMP->C"+strzero(_Y,2)+"T1KG")/TMP->KG_MR))
         Replace &("TAB->C"+strzero(_Y,2)+"HT2")       with  ((&("TMP->C"+strzero(_Y,2)+"_H_MR_L"))*(&("TMP->C"+strzero(_Y,2)+"T2KG")/TMP->KG_MR)) 
         Replace &("TAB->C"+strzero(_Y,2)+"HT3")       with  ((&("TMP->C"+strzero(_Y,2)+"_H_MR_L"))*(&("TMP->C"+strzero(_Y,2)+"T3KG")/TMP->KG_MR)) 
         Replace &("TAB->C"+strzero(_Y,2)+"UT1")       with  ((&("TAB->C"+strzero(_Y,2)+"HT1")) /14.66*100)
         Replace &("TAB->C"+strzero(_Y,2)+"UT2")       with  ((&("TAB->C"+strzero(_Y,2)+"HT2"))/14.66 *100)
         Replace &("TAB->C"+strzero(_Y,2)+"UT3")       with  ((&("TAB->C"+strzero(_Y,2)+"HT3"))/12.66 *100)
         Replace &("TAB->C"+strzero(_Y,2)+"HD")        with  (&("TAB->C"+strzero(_Y,2)+"HT1")+&("TAB->C"+strzero(_Y,2)+"HT2")+&("TAB->C"+strzero(_Y,2)+"HT3"))           
         Replace &("TAB->C"+strzero(_Y,2)+"UD")        with   ((&("TAB->C"+strzero(_Y,2)+"HD"))/(IIF(&("TMP->C"+strzero(_Y,2)+"T1KG")=0,0,14.66)+IIF(&("TMP->C"+strzero(_Y,2)+"T2KG")=0,0,14.66)+IIF(&("TMP->C"+strzero(_Y,2)+"T3KG")=0,0,12.66)))*100
      If _Y=2
         Replace &("TAB->S"+strzero(_Y,2)+"_H_MR_L")   with  &("TMP->S"+strzero(_Y,2)+"_H_MR_L")
         Replace &("TAB->S"+strzero(_Y,2)+"T1KG")      with  &("TMP->S"+strzero(_Y,2)+"T1KG")
         Replace &("TAB->S"+strzero(_Y,2)+"T2KG")      with  &("TMP->S"+strzero(_Y,2)+"T2KG")
         Replace &("TAB->S"+strzero(_Y,2)+"T3KG")      with  &("TMP->S"+strzero(_Y,2)+"T3KG")
         Replace &("TAB->S"+strzero(_Y,2)+"HT1")       with  ((&("TMP->S"+strzero(_Y,2)+"_H_MR_L"))*(&("TMP->S"+strzero(_Y,2)+"T1KG")/TMP->KG_MR))
         Replace &("TAB->S"+strzero(_Y,2)+"HT2")       with  ((&("TMP->S"+strzero(_Y,2)+"_H_MR_L"))*(&("TMP->S"+strzero(_Y,2)+"T2KG")/TMP->KG_MR)) 
         Replace &("TAB->S"+strzero(_Y,2)+"HT3")       with  ((&("TMP->S"+strzero(_Y,2)+"_H_MR_L"))*(&("TMP->S"+strzero(_Y,2)+"T3KG")/TMP->KG_MR)) 
         Replace &("TAB->S"+strzero(_Y,2)+"UT1")       with  ((&("TAB->S"+strzero(_Y,2)+"HT1")) /7.33*100)
         Replace &("TAB->S"+strzero(_Y,2)+"UT2")       with  ((&("TAB->S"+strzero(_Y,2)+"HT2"))/7.33 *100)
         Replace &("TAB->S"+strzero(_Y,2)+"UT3")       with  ((&("TAB->S"+strzero(_Y,2)+"HT3"))/6.33 *100)
         Replace &("TAB->S"+strzero(_Y,2)+"HD")        with  (&("TAB->S"+strzero(_Y,2)+"HT1")+&("TAB->S"+strzero(_Y,2)+"HT2")+&("TAB->S"+strzero(_Y,2)+"HT3"))           
         Replace &("TAB->S"+strzero(_Y,2)+"UD")        with   ((&("TAB->S"+strzero(_Y,2)+"HD"))/(IIF(&("TMP->S"+strzero(_Y,2)+"T1KG")=0,0,7.33)+IIF(&("TMP->S"+strzero(_Y,2)+"T2KG")=0,0,7.33)+IIF(&("TMP->S"+strzero(_Y,2)+"T3KG")=0,0,6.33)))*100
      Endif
      If _Y<6
         Replace &("TAB->P"+strzero(_Y,2)+"_H_MR_L")   with  &("TMP->P"+strzero(_Y,2)+"_H_MR_L")
         Replace &("TAB->P"+strzero(_Y,2)+"T1KG")      with  &("TMP->P"+strzero(_Y,2)+"T1KG")
         Replace &("TAB->P"+strzero(_Y,2)+"T2KG")      with  &("TMP->P"+strzero(_Y,2)+"T2KG")
         Replace &("TAB->P"+strzero(_Y,2)+"T3KG")      with  &("TMP->P"+strzero(_Y,2)+"T3KG")
         Replace &("TAB->P"+strzero(_Y,2)+"HT1")       with  ((&("TMP->P"+strzero(_Y,2)+"_H_MR_L"))*(&("TMP->P"+strzero(_Y,2)+"T1KG")/TMP->KG_MR))
         Replace &("TAB->P"+strzero(_Y,2)+"HT2")       with  ((&("TMP->P"+strzero(_Y,2)+"_H_MR_L"))*(&("TMP->P"+strzero(_Y,2)+"T2KG")/TMP->KG_MR)) 
         Replace &("TAB->P"+strzero(_Y,2)+"HT3")       with  ((&("TMP->P"+strzero(_Y,2)+"_H_MR_L"))*(&("TMP->P"+strzero(_Y,2)+"T3KG")/TMP->KG_MR)) 
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
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥   Processando a Sessao 1                                       ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oSection1:Init()
oReport:SkipLine()     
oReport:SkipLine()     
oReport:Say(oReport:Row(),oReport:Col()," "  )

oReport:SkipLine()
oReport:ThinLine()

While !oReport:Cancel() .And. TAB->(!Eof())

      
      oReport:IncMeter()
      
      ntotHML:=0
	  ntotT1KG:=0
	  ntotT2KG:=0
	  ntotT3KG:=0
      ntotHT1:=ntotUT1:=0
      ntotHT2:=ntotUT2:=0
      ntotHT3:=ntotUT3:=0

      oSection1:Cell("PROD"):SetValue(TAB->PROD)
      oSection1:Cell("PROD"):SetAlign("LEFT")
      // 
      oSection1:Cell("KG_MR"):SetValue(TAB->KG_MR)
      oSection1:Cell("KG_MR"):SetAlign("RIGHT")
      
      
      For _Y:=1 to 14
	      oSection1:Cell("C"+strzero(_Y,2)+"_H_MR_L"):SetValue(&("TAB->C"+strzero(_Y,2)+"_H_MR_L"))
	      oSection1:Cell("C"+strzero(_Y,2)+"_H_MR_L"):SetAlign("RIGHT")
	      oSection1:Cell("C"+strzero(_Y,2)+"T1KG"):SetValue(&("TAB->C"+strzero(_Y,2)+"T1KG"))
	      oSection1:Cell("C"+strzero(_Y,2)+"T1KG"):SetAlign("RIGHT")
	      oSection1:Cell("C"+strzero(_Y,2)+"T2KG"):SetValue(&("TAB->C"+strzero(_Y,2)+"T2KG"))
	      oSection1:Cell("C"+strzero(_Y,2)+"T2KG"):SetAlign("RIGHT")
	      oSection1:Cell("C"+strzero(_Y,2)+"T3KG"):SetValue(&("TAB->C"+strzero(_Y,2)+"T3KG"))
	      oSection1:Cell("C"+strzero(_Y,2)+"T3KG"):SetAlign("RIGHT")
	      oSection1:Cell("C"+strzero(_Y,2)+"HT1"):SetValue(&("TAB->C"+strzero(_Y,2)+"HT1"))
	      oSection1:Cell("C"+strzero(_Y,2)+"HT1"):SetAlign("RIGHT")
	      oSection1:Cell("C"+strzero(_Y,2)+"HT2"):SetValue(&("TAB->C"+strzero(_Y,2)+"HT2"))
	      oSection1:Cell("C"+strzero(_Y,2)+"HT2"):SetAlign("RIGHT")
	      oSection1:Cell("C"+strzero(_Y,2)+"HT3"):SetValue(&("TAB->C"+strzero(_Y,2)+"HT3"))
	      oSection1:Cell("C"+strzero(_Y,2)+"HT3"):SetAlign("RIGHT")
	      oSection1:Cell("C"+strzero(_Y,2)+"UT1"):SetValue(&("TAB->C"+strzero(_Y,2)+"UT1"))
	      oSection1:Cell("C"+strzero(_Y,2)+"UT1"):SetAlign("RIGHT")
	      oSection1:Cell("C"+strzero(_Y,2)+"UT2"):SetValue(&("TAB->C"+strzero(_Y,2)+"UT2"))
	      oSection1:Cell("C"+strzero(_Y,2)+"UT2"):SetAlign("RIGHT")
	      oSection1:Cell("C"+strzero(_Y,2)+"UT3"):SetValue(&("TAB->C"+strzero(_Y,2)+"UT3"))
	      oSection1:Cell("C"+strzero(_Y,2)+"UT3"):SetAlign("RIGHT")            
	      oSection1:Cell("C"+strzero(_Y,2)+"HD"):SetValue(&("TAB->C"+strzero(_Y,2)+"HD"))
	      oSection1:Cell("C"+strzero(_Y,2)+"HD"):SetAlign("RIGHT")            
	      oSection1:Cell("C"+strzero(_Y,2)+"UD"):SetValue(&("TAB->C"+strzero(_Y,2)+"UD"))
	      oSection1:Cell("C"+strzero(_Y,2)+"UD"):SetAlign("RIGHT")                  
	      &("nC"+STRZERO(_Y,2)+"UT1")+=&("TAB->C"+STRZERO(_Y,2)+"HT1")
	  If _Y=2
	      oSection1:Cell("S"+strzero(_Y,2)+"_H_MR_L"):SetValue(&("TAB->S"+strzero(_Y,2)+"_H_MR_L"))
	      oSection1:Cell("S"+strzero(_Y,2)+"_H_MR_L"):SetAlign("RIGHT")
	      oSection1:Cell("S"+strzero(_Y,2)+"T1KG"):SetValue(&("TAB->S"+strzero(_Y,2)+"T1KG"))
	      oSection1:Cell("S"+strzero(_Y,2)+"T1KG"):SetAlign("RIGHT")
	      oSection1:Cell("S"+strzero(_Y,2)+"T2KG"):SetValue(&("TAB->S"+strzero(_Y,2)+"T2KG"))
	      oSection1:Cell("S"+strzero(_Y,2)+"T2KG"):SetAlign("RIGHT")
	      oSection1:Cell("S"+strzero(_Y,2)+"T3KG"):SetValue(&("TAB->S"+strzero(_Y,2)+"T3KG"))
	      oSection1:Cell("S"+strzero(_Y,2)+"T3KG"):SetAlign("RIGHT")
	      oSection1:Cell("S"+strzero(_Y,2)+"HT1"):SetValue(&("TAB->S"+strzero(_Y,2)+"HT1"))
	      oSection1:Cell("S"+strzero(_Y,2)+"HT1"):SetAlign("RIGHT")
	      oSection1:Cell("S"+strzero(_Y,2)+"HT2"):SetValue(&("TAB->S"+strzero(_Y,2)+"HT2"))
	      oSection1:Cell("S"+strzero(_Y,2)+"HT2"):SetAlign("RIGHT")
	      oSection1:Cell("S"+strzero(_Y,2)+"HT3"):SetValue(&("TAB->S"+strzero(_Y,2)+"HT3"))
	      oSection1:Cell("S"+strzero(_Y,2)+"HT3"):SetAlign("RIGHT")
	      oSection1:Cell("S"+strzero(_Y,2)+"UT1"):SetValue(&("TAB->S"+strzero(_Y,2)+"UT1"))
	      oSection1:Cell("S"+strzero(_Y,2)+"UT1"):SetAlign("RIGHT")
	      oSection1:Cell("S"+strzero(_Y,2)+"UT2"):SetValue(&("TAB->S"+strzero(_Y,2)+"UT2"))
	      oSection1:Cell("S"+strzero(_Y,2)+"UT2"):SetAlign("RIGHT")
	      oSection1:Cell("S"+strzero(_Y,2)+"UT3"):SetValue(&("TAB->S"+strzero(_Y,2)+"UT3"))
	      oSection1:Cell("S"+strzero(_Y,2)+"UT3"):SetAlign("RIGHT")            
	      oSection1:Cell("S"+strzero(_Y,2)+"HD"):SetValue(&("TAB->S"+strzero(_Y,2)+"HD"))
	      oSection1:Cell("S"+strzero(_Y,2)+"HD"):SetAlign("RIGHT")            
	      oSection1:Cell("S"+strzero(_Y,2)+"UD"):SetValue(&("TAB->S"+strzero(_Y,2)+"UD"))
	      oSection1:Cell("S"+strzero(_Y,2)+"UD"):SetAlign("RIGHT")                  
      	  &("nS"+STRZERO(_Y,2)+"UT1")+=&("TAB->S"+STRZERO(_Y,2)+"HT1")
          //H_MR_L
	      ntotHML+=&("TAB->S"+strzero(_Y,2)+"_H_MR_L")
	      // TURNOS
	      ntotT1KG+=&("TAB->S"+STRZERO(_Y,2)+'T1KG') 
	      ntotT2KG+=&("TAB->S"+STRZERO(_Y,2)+'T2KG')
	      ntotT3KG+=&("TAB->S"+STRZERO(_Y,2)+'T3KG')	      
	      // HORAS 
	      ntotHT1+=&("TAB->S"+STRZERO(_Y,2)+'HT1') 
	      ntotHT2+=&("TAB->S"+STRZERO(_Y,2)+'HT2')
	      ntotHT3+=&("TAB->S"+STRZERO(_Y,2)+'HT3')
	      // UTILIZACAO
          ntotUT1+=&("TAB->S"+STRZERO(_Y,2)+'HT1') /(&("TAB->S"+STRZERO(_Y,2)+'HT1')/7.33*100) 
          ntotUT2+=&("TAB->S"+STRZERO(_Y,2)+'HT2') /(&("TAB->S"+STRZERO(_Y,2)+'HT2')/7.33*100) 
          ntotUT3+=&("TAB->S"+STRZERO(_Y,2)+'HT3') /(&("TAB->S"+STRZERO(_Y,2)+'HT3')/6.33*100)             

      Endif

	  If _Y<6
	      oSection1:Cell("P"+strzero(_Y,2)+"_H_MR_L"):SetValue(&("TAB->P"+strzero(_Y,2)+"_H_MR_L"))
	      oSection1:Cell("P"+strzero(_Y,2)+"_H_MR_L"):SetAlign("RIGHT")
	      oSection1:Cell("P"+strzero(_Y,2)+"T1KG"):SetValue(&("TAB->P"+strzero(_Y,2)+"T1KG"))
	      oSection1:Cell("P"+strzero(_Y,2)+"T1KG"):SetAlign("RIGHT")
	      oSection1:Cell("P"+strzero(_Y,2)+"T2KG"):SetValue(&("TAB->P"+strzero(_Y,2)+"T2KG"))
	      oSection1:Cell("P"+strzero(_Y,2)+"T2KG"):SetAlign("RIGHT")
	      oSection1:Cell("P"+strzero(_Y,2)+"T3KG"):SetValue(&("TAB->P"+strzero(_Y,2)+"T3KG"))
	      oSection1:Cell("P"+strzero(_Y,2)+"T3KG"):SetAlign("RIGHT")
	      oSection1:Cell("P"+strzero(_Y,2)+"HT1"):SetValue(&("TAB->P"+strzero(_Y,2)+"HT1"))
	      oSection1:Cell("P"+strzero(_Y,2)+"HT1"):SetAlign("RIGHT")
	      oSection1:Cell("P"+strzero(_Y,2)+"HT2"):SetValue(&("TAB->P"+strzero(_Y,2)+"HT2"))
	      oSection1:Cell("P"+strzero(_Y,2)+"HT2"):SetAlign("RIGHT")
	      oSection1:Cell("P"+strzero(_Y,2)+"HT3"):SetValue(&("TAB->P"+strzero(_Y,2)+"HT3"))
	      oSection1:Cell("P"+strzero(_Y,2)+"HT3"):SetAlign("RIGHT")
	      oSection1:Cell("P"+strzero(_Y,2)+"UT1"):SetValue(&("TAB->P"+strzero(_Y,2)+"UT1"))
	      oSection1:Cell("P"+strzero(_Y,2)+"UT1"):SetAlign("RIGHT")
	      oSection1:Cell("P"+strzero(_Y,2)+"UT2"):SetValue(&("TAB->P"+strzero(_Y,2)+"UT2"))
	      oSection1:Cell("P"+strzero(_Y,2)+"UT2"):SetAlign("RIGHT")
	      oSection1:Cell("P"+strzero(_Y,2)+"UT3"):SetValue(&("TAB->P"+strzero(_Y,2)+"UT3"))
	      oSection1:Cell("P"+strzero(_Y,2)+"UT3"):SetAlign("RIGHT")            
	      oSection1:Cell("P"+strzero(_Y,2)+"HD"):SetValue(&("TAB->P"+strzero(_Y,2)+"HD"))
	      oSection1:Cell("P"+strzero(_Y,2)+"HD"):SetAlign("RIGHT")            
	      oSection1:Cell("P"+strzero(_Y,2)+"UD"):SetValue(&("TAB->P"+strzero(_Y,2)+"UD"))
	      oSection1:Cell("P"+strzero(_Y,2)+"UD"):SetAlign("RIGHT")                  
      	  &("nP"+STRZERO(_Y,2)+"UT1")+=&("TAB->P"+STRZERO(_Y,2)+"HT1")
          //H_MR_L
	      ntotHML+=&("TAB->P"+strzero(_Y,2)+"_H_MR_L")
	      // TURNOS
	      ntotT1KG+=&("TAB->P"+STRZERO(_Y,2)+'T1KG') 
	      ntotT2KG+=&("TAB->P"+STRZERO(_Y,2)+'T2KG')
	      ntotT3KG+=&("TAB->P"+STRZERO(_Y,2)+'T3KG')	      
	      // HORAS 
	      ntotHT1+=&("TAB->P"+STRZERO(_Y,2)+'HT1') 
	      ntotHT2+=&("TAB->P"+STRZERO(_Y,2)+'HT2')
	      ntotHT3+=&("TAB->P"+STRZERO(_Y,2)+'HT3')
	      // UTILIZACAO
          ntotUT1+=&("TAB->P"+STRZERO(_Y,2)+'HT1') /(&("TAB->P"+STRZERO(_Y,2)+'HT1')/7.33*100) 
          ntotUT2+=&("TAB->P"+STRZERO(_Y,2)+'HT2') /(&("TAB->P"+STRZERO(_Y,2)+'HT2')/7.33*100) 
          ntotUT3+=&("TAB->P"+STRZERO(_Y,2)+'HT3') /(&("TAB->P"+STRZERO(_Y,2)+'HT3')/6.33*100)             

      Endif
      //H_MR_L
      ntotHML+=&("TAB->C"+strzero(_Y,2)+"_H_MR_L")
      // TURNOS
	  ntotT1KG+=&("TAB->C"+STRZERO(_Y,2)+'T1KG') 
	  ntotT2KG+=&("TAB->C"+STRZERO(_Y,2)+'T2KG')
	  ntotT3KG+=&("TAB->C"+STRZERO(_Y,2)+'T3KG')	      
      // HORAS 
      ntotHT1+=&("TAB->C"+STRZERO(_Y,2)+'HT1') 
      ntotHT2+=&("TAB->C"+STRZERO(_Y,2)+'HT2')
      ntotHT3+=&("TAB->C"+STRZERO(_Y,2)+'HT3')
      // UTILIZACAO
      ntotUT1+=&("TAB->C"+STRZERO(_Y,2)+'HT1') /(&("TAB->C"+STRZERO(_Y,2)+'HT1')/14.66*100) 
      ntotUT2+=&("TAB->C"+STRZERO(_Y,2)+'HT2') /(&("TAB->C"+STRZERO(_Y,2)+'HT2')/14.66*100) 
      ntotUT3+=&("TAB->C"+STRZERO(_Y,2)+'HT3') /(&("TAB->C"+STRZERO(_Y,2)+'HT3')/12.66*100)             

      Next
      // totalizador H_MR_L
      oSection1:Cell("TOTALHML"):SetValue(ntotHML)      
      oSection1:Cell("TOTALHML"):SetAlign("RIGHT")          
	 // totalizador turnos
      oSection1:Cell("TOTALT01KG"):SetValue(ntotT1KG)
      oSection1:Cell("TOTALT01KG"):SetAlign("RIGHT")          
      oSection1:Cell("TOTALT02KG"):SetValue(ntotT2KG)
      oSection1:Cell("TOTALT02KG"):SetAlign("RIGHT")          
      oSection1:Cell("TOTALT03KG"):SetValue(ntotT3KG)
      oSection1:Cell("TOTALT03KG"):SetAlign("RIGHT")          
      // totalizador por turno 
      oSection1:Cell("TOTALHT01"):SetValue(ntotHT1)
      oSection1:Cell("TOTALHT01"):SetAlign("RIGHT")          
      oSection1:Cell("TOTALHT02"):SetValue(ntotHT2)
      oSection1:Cell("TOTALHT02"):SetAlign("RIGHT")     
      oSection1:Cell("TOTALHT03"):SetValue(ntotHT3)
      oSection1:Cell("TOTALHT03"):SetAlign("RIGHT")
      // totalizador por dia 
      oSection1:Cell("TOTALDT"):SetValue(ntotT1KG+ntotT2KG+ntotT3KG)
      oSection1:Cell("TOTALDT"):SetAlign("RIGHT")
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
