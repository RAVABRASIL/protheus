#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "


*************

User Function PCPR030()

*************

Local cPerg := "PCPR030"
local oReport

Private cTURNO1   := GetMv("MV_TURNO1")
Private cTURNO2   := GetMv("MV_TURNO2")
Private cTURNO3   := GetMv("MV_TURNO3")



hora1:=Left(cTURNO1,5)
hora2:=Left(cTURNO2,5)
hora3:=Left(cTURNO3,5)


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
 oReport:= TReport():New("PCPR030","Máquina ",'PCP3V2', {|oReport| ReportPrint(oReport)},"Este relatório demostrará as informações referentes a utilização das corte e soldas diariamente")

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
TRCell():New(oSection1,'FILIAL'        ,'',''                    ,PesqPict('SB1','B1_COD'),22  ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PROD'          ,'','PROD'                ,PesqPict('SB1','B1_COD'),12  ,/*lPixel*/,/*{|| code-block de impressao }*/)

For _Y:=1 to 14 // CORTE E SOLDA
// turno1
TRCell():New(oSection1,'C'+STRZERO(_Y,2)+'TURNO1'   ,'','C'+STRZERO(_Y,2)+'_TURNO1(Kg)'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// turno2
TRCell():New(oSection1,'C'+STRZERO(_Y,2)+'TURNO2'   ,'','C'+STRZERO(_Y,2)+'_TURNO2(Kg)'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// turno3
TRCell():New(oSection1,'C'+STRZERO(_Y,2)+'TURNO3'   ,'','C'+STRZERO(_Y,2)+'_TURNO3(Kg)'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)

//if _Y=2
	// turno1
//	TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'TURNO1'   ,'','S'+STRZERO(_Y,2)+'_TURNO1(Kg)'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
	// turno2
//	TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'TURNO2'   ,'','S'+STRZERO(_Y,2)+'_TURNO2(Kg)'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
	// turno3
//	TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'TURNO3'   ,'','S'+STRZERO(_Y,2)+'_TURNO3(Kg)'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
//Endif

Next

For _Y:=1 to 5 // PICOTADEIRA
// turno1
TRCell():New(oSection1,'P'+STRZERO(_Y,2)+'TURNO1'   ,'','P'+STRZERO(_Y,2)+'_TURNO1(Kg)'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// turno2
TRCell():New(oSection1,'P'+STRZERO(_Y,2)+'TURNO2'   ,'','P'+STRZERO(_Y,2)+'_TURNO2(Kg)'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// turno3
TRCell():New(oSection1,'P'+STRZERO(_Y,2)+'TURNO3'   ,'','P'+STRZERO(_Y,2)+'_TURNO3(Kg)'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
next

_Y:=2
// turno1
TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'TURNO1'   ,'','S'+STRZERO(_Y,2)+'_TURNO1(Kg)'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// turno2
TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'TURNO2'   ,'','S'+STRZERO(_Y,2)+'_TURNO2(Kg)'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// turno3
TRCell():New(oSection1,'S'+STRZERO(_Y,2)+'TURNO3'   ,'','S'+STRZERO(_Y,2)+'_TURNO3(Kg)'          ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)


// TOTAL CORTE E SACOLEIRA
TRCell():New(oSection1,'T_CORTE'   ,'','TOTAL_CS(Kg)'                                              ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// TOTAL PICOTE
TRCell():New(oSection1,'T_PICOTE'   ,'','TOTAL_PICOTE(Kg)'                                         ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)
// TOTAL GERAL
TRCell():New(oSection1,'TTOTAL'   ,'','TOTAL(Kg)'                                                   ,"@E 9,999,999.99999",20     ,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New(oSection1,oSection1:Cell("FILIAL"),"Total",.F.)
For _Y:=1 to 14
  TRFunction():New(oSection1:Cell('C'+STRZERO(_Y,2)+'TURNO1'),NIL,"SUM",oBreak,'TTURNO1',"@E 9,999,999.99999",/*uFormula*/,.F.,.F.,.F.,oSection1)
  TRFunction():New(oSection1:Cell('C'+STRZERO(_Y,2)+'TURNO2'),NIL,"SUM",oBreak,'TTURNO2',"@E 9,999,999.99999",/*uFormula*/,.F.,.F.,.F.,oSection1)
  TRFunction():New(oSection1:Cell('C'+STRZERO(_Y,2)+'TURNO3'),NIL,"SUM",oBreak,'TTURNO3',"@E 9,999,999.99999",/*uFormula*/,.F.,.F.,.F.,oSection1)
  If _Y=2
    TRFunction():New(oSection1:Cell('S'+STRZERO(_Y,2)+'TURNO1'),NIL,"SUM",oBreak,'TTURNO1',"@E 9,999,999.99999",/*uFormula*/,.F.,.F.,.F.,oSection1)
    TRFunction():New(oSection1:Cell('S'+STRZERO(_Y,2)+'TURNO2'),NIL,"SUM",oBreak,'TTURNO2',"@E 9,999,999.99999",/*uFormula*/,.F.,.F.,.F.,oSection1)
    TRFunction():New(oSection1:Cell('S'+STRZERO(_Y,2)+'TURNO3'),NIL,"SUM",oBreak,'TTURNO3',"@E 9,999,999.99999",/*uFormula*/,.F.,.F.,.F.,oSection1)
  ENdif
  If _Y<6
  TRFunction():New(oSection1:Cell('P'+STRZERO(_Y,2)+'TURNO1'),NIL,"SUM",oBreak,'TTURNO1',"@E 9,999,999.99999",/*uFormula*/,.F.,.F.,.F.,oSection1)
  TRFunction():New(oSection1:Cell('P'+STRZERO(_Y,2)+'TURNO2'),NIL,"SUM",oBreak,'TTURNO2',"@E 9,999,999.99999",/*uFormula*/,.F.,.F.,.F.,oSection1)
  TRFunction():New(oSection1:Cell('P'+STRZERO(_Y,2)+'TURNO3'),NIL,"SUM",oBreak,'TTURNO3',"@E 9,999,999.99999",/*uFormula*/,.F.,.F.,.F.,oSection1)
  ENdif
Next

TRFunction():New(oSection1:Cell('T_CORTE'),NIL,"SUM",oBreak,'T_CORTE',"@E 9,999,999.99999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell('T_PICOTE'),NIL,"SUM",oBreak,'T_PICOTE',"@E 9,999,999.99999",/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell('TTOTAL'),NIL,"SUM",oBreak,'TTOTAL',"@E 9,999,999.99999",/*uFormula*/,.F.,.F.,.F.,oSection1)

// Periodo de ate 
oBreak := TRBreak():New(oSection1,oSection1:Cell("FILIAL"),"Perido" ,.F.)
TRFunction():New(oSection1:Cell("PROD"),"PRD","ONPRINT",oBreak,"PRD",PesqPict('SB1','B1_COD'),{||  "De "+DTOC(MV_PAR01)+' Ate '+DTOC(MV_PAR02) },.F.,.F.,.F.,oSection1)


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
//******************************
// Monta a tabela temporária
//******************************
Aadd( aFds , {"PROD"                ,"C",030,000} )
For _Y:=1 to 14
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"TURNO1"         ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"TURNO2"         ,"N",020,005} )
   Aadd( aFds , {"C"+STRZERO(_Y,2)+"TURNO3"         ,"N",020,005} )
if _Y=2
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"TURNO1"         ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"TURNO2"         ,"N",020,005} )
   Aadd( aFds , {"S"+STRZERO(_Y,2)+"TURNO3"         ,"N",020,005} )
endif
If  _Y<6
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"TURNO1"         ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"TURNO2"         ,"N",020,005} )
   Aadd( aFds , {"P"+STRZERO(_Y,2)+"TURNO3"         ,"N",020,005} )
endif
Next
Aadd( aFds , {"T_CORTE"                           ,"N",020,005} )
Aadd( aFds , {"T_PICOTE"                           ,"N",020,005} )
Aadd( aFds , {"TTOTAL"                           ,"N",020,005} )
coTbl := CriaTrab( aFds, .T. )
Use (coTbl) Alias TAB New Exclusive
dbCreateIndex(coTbl,'PROD', {|| PROD })
//***********************************
// Monta a tabela 
//***********************************
cQuery:="SELECT "
cQuery+="PROD,  "
//C01
cQuery+="isnull(SUM(CASE WHEN MAQ='C01' AND TURNO='1' THEN PESO ELSE 0 END),0) AS 'C01TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C01' AND TURNO='2' THEN PESO ELSE 0 END),0) AS 'C01TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C01' AND TURNO='3' THEN PESO ELSE 0 END),0) AS 'C01TURNO3', "
//C02
cQuery+="isnull(SUM(CASE WHEN MAQ='C02' AND TURNO='1' THEN PESO ELSE 0 END),0) AS 'C02TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C02' AND TURNO='2' THEN PESO ELSE 0 END),0) AS 'C02TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C02' AND TURNO='3' THEN PESO ELSE 0 END),0) AS 'C02TURNO3', "
//C03
cQuery+="isnull(SUM(CASE WHEN MAQ='C03' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'C03TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C03' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'C03TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C03' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'C03TURNO3', "
//C04
cQuery+="isnull(SUM(CASE WHEN MAQ='C04' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'C04TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C04' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'C04TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C04' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'C04TURNO3', "
//C05 
cQuery+="isnull(SUM(CASE WHEN MAQ='C05' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'C05TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C05' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'C05TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C05' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'C05TURNO3', "
//C06
cQuery+="isnull(SUM(CASE WHEN MAQ='C06' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'C06TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C06' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'C06TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C06' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'C06TURNO3', "
//C07
cQuery+="isnull(SUM(CASE WHEN MAQ='C07' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'C07TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C07' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'C07TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C07' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'C07TURNO3', "
//C08
cQuery+="isnull(SUM(CASE WHEN MAQ='C08' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'C08TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C08' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'C08TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C08' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'C08TURNO3', "
//C09
cQuery+="isnull(SUM(CASE WHEN MAQ='C09' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'C09TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C09' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'C09TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C09' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'C09TURNO3', "
//C10
cQuery+="isnull(SUM(CASE WHEN MAQ='C10' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'C10TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C10' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'C10TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C10' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'C10TURNO3', "
//C11 
cQuery+="isnull(SUM(CASE WHEN MAQ='C11' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'C11TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C11' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'C11TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C11' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'C11TURNO3', "
//C12 
cQuery+="isnull(SUM(CASE WHEN MAQ='C12' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'C12TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C12' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'C12TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C12' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'C12TURNO3', " 
//C13
cQuery+="isnull(SUM(CASE WHEN MAQ='C13' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'C13TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C13' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'C13TURNO2',  "
cQuery+="isnull(SUM(CASE WHEN MAQ='C13' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'C13TURNO3', "
//C14
cQuery+="isnull(SUM(CASE WHEN MAQ='C14' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'C14TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C14' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'C14TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='C14' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'C14TURNO3', "
// TOTAL CORTE 
cQuery+="isnull(SUM(CASE WHEN SUBSTRING(MAQ,1,2) IN ('C0', 'C1','S0') THEN PESO ELSE 0 END),0) AS'T_CORTE',  "
// P01
cQuery+="isnull(SUM(CASE WHEN MAQ='P01' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'P01TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='P01' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'P01TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='P01' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'P01TURNO3', "
// P02
cQuery+="isnull(SUM(CASE WHEN MAQ='P02' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'P02TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='P02' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'P02TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='P02' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'P02TURNO3', "
// P03
cQuery+="isnull(SUM(CASE WHEN MAQ='P03' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'P03TURNO1', " 
cQuery+="isnull(SUM(CASE WHEN MAQ='P03' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'P03TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='P03' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'P03TURNO3', "
// P04
cQuery+="isnull(SUM(CASE WHEN MAQ='P04' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'P04TURNO1', "
cQuery+="isnull(SUM(CASE WHEN MAQ='P04' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'P04TURNO2', "
cQuery+="isnull(SUM(CASE WHEN MAQ='P04' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'P04TURNO3', "
// P05
cQuery+="isnull(SUM(CASE WHEN MAQ='P05' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'P05TURNO1',  "
cQuery+="isnull(SUM(CASE WHEN MAQ='P05' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'P05TURNO2',  "
cQuery+="isnull(SUM(CASE WHEN MAQ='P05' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'P05TURNO3',  "
// S02
cQuery+="isnull(SUM(CASE WHEN MAQ='S02' AND TURNO='1' THEN PESO ELSE 0 END),0) AS'S02TURNO1',  "
cQuery+="isnull(SUM(CASE WHEN MAQ='S02' AND TURNO='2' THEN PESO ELSE 0 END),0) AS'S02TURNO2',  "
cQuery+="isnull(SUM(CASE WHEN MAQ='S02' AND TURNO='3' THEN PESO ELSE 0 END),0) AS'S02TURNO3',  "
// TOTAL PICOTE 
cQuery+="isnull(SUM(CASE WHEN SUBSTRING(MAQ,1,2) IN ('P0') THEN PESO ELSE 0 END),0) AS'T_PICOTE', "
// TOTAL 
cQuery+="isnull(SUM( PESO ),0) AS'TTOTAL' "
cQuery+="FROM(  "
cQuery+="SELECT "
cQuery+="PROD=C2_PRODUTO, "
cQuery+="MAQ=ltrim(rtrim(Z00.Z00_MAQ)), "
cQuery+="TURNO=CASE WHEN Z00_HORA>= '05:20' AND Z00_HORA<'13:40' THEN '1' "
cQuery+="ELSE CASE WHEN Z00_HORA>='13:40' AND Z00_HORA<'22:00' THEN '2' "
cQuery+="ELSE CASE WHEN (Z00_HORA>='22:00' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '05:20' )THEN '3' "
cQuery+="ELSE 'XXXX' END END END, "
cQuery+="ISNULL(SUM(Z00_PESO+Z00_PESCAP),0) AS PESO   "
cQuery+="FROM Z00020 Z00 WITH (NOLOCK), SC2020 SC2 WITH (NOLOCK), SB1010 SB1 WITH (NOLOCK) "
cQuery+="WHERE Z00_FILIAL = ' ' "
cQuery+="AND C2_PRODUTO=B1_COD "
cQuery+="AND Z00_OP=C2_NUM+C2_ITEM+C2_SEQUEN "
cQuery+="AND Z00.Z00_DATHOR >= '"+dtos(MV_PAR01)+hora1+"' AND Z00.Z00_DATHOR < '"+dtos(MV_PAR02+1)+hora1+"' "
cQuery+="AND SUBSTRING(Z00.Z00_MAQ,1,2) IN ('C0', 'C1','P0','S0') "
cQuery+="AND Z00.Z00_APARA = ' ' AND Z00.D_E_L_E_T_ = ' ' "
cQuery+="GROUP BY C2_PRODUTO,ltrim(rtrim(Z00.Z00_MAQ)), "
cQuery+="CASE WHEN Z00_HORA>= '05:20' AND Z00_HORA<'13:40' THEN '1' "
cQuery+="ELSE CASE WHEN Z00_HORA>='13:40' AND Z00_HORA<'22:00' THEN '2' "
cQuery+="ELSE CASE WHEN (Z00_HORA>='22:00' OR Z00_HORA<'24:00' )AND (Z00_HORA>='00:00' OR Z00_HORA < '05:20' )THEN '3' "
cQuery+="ELSE'XXXX' END END END "
cQuery+=") AS TABX  "
cQuery+="GROUP BY PROD "
cQuery+="ORDER BY PROD "

If Select("TMP") > 0
      DbSelectArea("TMP")
      DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )
While TMP->(!Eof())
      RecLock("TAB",.T.)
      Replace TAB->PROD        with TMP->PROD
      For _Y:=1 to 14
      Replace &("TAB->C"+strzero(_Y,2)+"TURNO1")   with &("TMP->C"+strzero(_Y,2)+"TURNO1")
      Replace &("TAB->C"+strzero(_Y,2)+"TURNO2")   with &("TMP->C"+strzero(_Y,2)+"TURNO2")
      Replace &("TAB->C"+strzero(_Y,2)+"TURNO3")   with &("TMP->C"+strzero(_Y,2)+"TURNO3")      
      If _Y=2
         Replace &("TAB->S"+strzero(_Y,2)+"TURNO1")   with &("TMP->S"+strzero(_Y,2)+"TURNO1")
         Replace &("TAB->S"+strzero(_Y,2)+"TURNO2")   with &("TMP->S"+strzero(_Y,2)+"TURNO2")
         Replace &("TAB->S"+strzero(_Y,2)+"TURNO3")   with &("TMP->S"+strzero(_Y,2)+"TURNO3")      
      Endif

      If _Y<6
         Replace &("TAB->P"+strzero(_Y,2)+"TURNO1")   with &("TMP->P"+strzero(_Y,2)+"TURNO1")
         Replace &("TAB->P"+strzero(_Y,2)+"TURNO2")   with &("TMP->P"+strzero(_Y,2)+"TURNO2")
         Replace &("TAB->P"+strzero(_Y,2)+"TURNO3")   with &("TMP->P"+strzero(_Y,2)+"TURNO3")      
      Endif
      Next      
      Replace TAB->T_CORTE        with TMP->T_CORTE
      Replace TAB->T_PICOTE       with TMP->T_PICOTE
      Replace TAB->TTOTAL         with TMP->TTOTAL
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
oReport:Say(oReport:Row(),oReport:Col()," "  )

oReport:SkipLine()
oReport:ThinLine()

While !oReport:Cancel() .And. TAB->(!Eof())

      oReport:IncMeter()
      oSection1:Cell("PROD"):SetValue(TAB->PROD)
      oSection1:Cell("PROD"):SetAlign("LEFT")      
      For _Y:=1 to 14
      // turno1
      oSection1:Cell("C"+strzero(_Y,2)+"TURNO1"):SetValue(&("TAB->C"+STRZERO(_Y,2)+"TURNO1"))
      oSection1:Cell("C"+strzero(_Y,2)+"TURNO1"):SetAlign("RIGHT")
      // turno2
      oSection1:Cell("C"+strzero(_Y,2)+"TURNO2"):SetValue(&("TAB->C"+STRZERO(_Y,2)+"TURNO2"))
      oSection1:Cell("C"+strzero(_Y,2)+"TURNO2"):SetAlign("RIGHT")
      // turno3
      oSection1:Cell("C"+strzero(_Y,2)+"TURNO3"):SetValue(&("TAB->C"+STRZERO(_Y,2)+"TURNO3"))
      oSection1:Cell("C"+strzero(_Y,2)+"TURNO3"):SetAlign("RIGHT")
      If _Y=2
        // turno1
        oSection1:Cell("S"+strzero(_Y,2)+"TURNO1"):SetValue(&("TAB->S"+STRZERO(_Y,2)+"TURNO1"))
        oSection1:Cell("S"+strzero(_Y,2)+"TURNO1"):SetAlign("RIGHT")
        // turno2
        oSection1:Cell("S"+strzero(_Y,2)+"TURNO2"):SetValue(&("TAB->S"+STRZERO(_Y,2)+"TURNO2"))
        oSection1:Cell("S"+strzero(_Y,2)+"TURNO2"):SetAlign("RIGHT")
        // turno3
        oSection1:Cell("S"+strzero(_Y,2)+"TURNO3"):SetValue(&("TAB->S"+STRZERO(_Y,2)+"TURNO3"))
        oSection1:Cell("S"+strzero(_Y,2)+"TURNO3"):SetAlign("RIGHT")      
      Endif      

      If _Y<6
        // turno1
        oSection1:Cell("P"+strzero(_Y,2)+"TURNO1"):SetValue(&("TAB->P"+STRZERO(_Y,2)+"TURNO1"))
        oSection1:Cell("P"+strzero(_Y,2)+"TURNO1"):SetAlign("RIGHT")
        // turno2
        oSection1:Cell("P"+strzero(_Y,2)+"TURNO2"):SetValue(&("TAB->P"+STRZERO(_Y,2)+"TURNO2"))
        oSection1:Cell("P"+strzero(_Y,2)+"TURNO2"):SetAlign("RIGHT")
        // turno3
        oSection1:Cell("P"+strzero(_Y,2)+"TURNO3"):SetValue(&("TAB->P"+STRZERO(_Y,2)+"TURNO3"))
        oSection1:Cell("P"+strzero(_Y,2)+"TURNO3"):SetAlign("RIGHT")      
      Endif      
      Next
      oSection1:Cell("T_CORTE"):SetValue(TAB->T_CORTE)
      oSection1:Cell("T_CORTE"):SetAlign("RIGHT")

      oSection1:Cell("T_PICOTE"):SetValue(TAB->T_PICOTE)
      oSection1:Cell("T_PICOTE"):SetAlign("RIGHT")

      oSection1:Cell("TTOTAL"):SetValue(TAB->TTOTAL)
      oSection1:Cell("TTOTAL"):SetAlign("RIGHT")
      
      oSection1:PrintLine()
      //oReport:SkipLine()     
      TAB->(dbSkip())

EndDo
oSection1:Finish()
dbCloseArea("TAB")
dbCloseArea("TMP")
Set Filter To

Return

