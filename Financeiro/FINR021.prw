#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :FINR019 ³ Autor :Gustavo Costa         ³ Data :23/10/2017   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Relatorio de baixas Receber e pagar.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FINR021()
	
Local oReport
Local cPerg	:= "FINR21"


criaSx1(cPerg)
oReport:= ReportDef()
oReport:PrintDialog()

Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+

static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data de?'     	, '', '', 'mv_ch1', 'D', 10                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data Inicial"},{},{})
putSx1(cPerg, '02', 'Data até?'  	, '', '', 'mv_ch2', 'D', 10                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
putSx1(cPerg, '03', 'Todas Empresas?', '', '', 'mv_ch3', 'C', 1                     	, 0, 0, 'G', '', ''	  , '', '', 'mv_par03','1=Sim','','','2=Não','','','','','','','','','','','','',{"Sim para todas"},{},{})

return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ESTR017  ³ Autor ³ Gustavo Costa          ³ Data ³03.03.2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de Faturamento Parcial                             .³±±
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

oReport:= TReport():New("FINR21","Analise do Lote " + mv_par01 ,"FINR21", {|oReport| ReportPrint(oReport)},"Este relatório irá listar movimentos de baixa receber e pagar.")
//oReport:SetLandscape()
oReport:SetPortrait()
/*
If lJob
	oReport:nDevice	 	:= 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
	ConOut('oReport:nDevice = 3-email')
	oReport:cEmail		:= GetNewPar("MV_XPCPR48",'giancarlo@ravaembalagens.com.br;gustavo@ravaembalagens.com.br')
EndIf
*/
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
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira XTMela   ³
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

oSection1 := TRSection():New(oReport,"OP",{"XTM"}) 

TRCell():New(oSection1,'EMP'			,'','Emp.'				,	/*Picture*/				,04				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'BAIXA'			,'','Dt. Baixa'			,	/*Picture*/				,10				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'COD'			,'','Codigo'			,	/*Picture*/				,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'LOJA'			,'','Loja'				,	/*Picture*/				,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NOME'			,'','Nome'				,	/*Picture*/				,35				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PREFIXO'		,'','Pref.'				,	/*Picture*/				,03				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NUM'			,'','Numero'			,	/*Picture*/				,09				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PARCELA'		,'','Parc.'				,	/*Picture*/				,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'RECEBER'		,'','Valor Rec.'		,PesqPict('SE1','E1_VALOR') ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PAGAR'			,'','Valor Pago'		,PesqPict('SE1','E1_VALOR') ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 2                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//oSection2 := TRSection():New(oSection1,"Maquinas",{"XTM"})
//oSection2:SetLeftMargin(2)

//TRCell():New(oSection2,'MAQ'			,'','Maquina'		,/*Picture*/	,06	,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'LADO'	    	,'','Lado'			,/*Picture*/	,01	,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'OPERADOR'		,'','Operador'		,/*Picture*/	,35	,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'QTDREAL'		,'','Realizado'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'PERCREAL'		,'','%'				,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'QTDAPARA'		,'','Apara'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'PERCAPARA'		,'','%'				,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New(oSection1,oSection1:Cell("BAIXA"),"Total Dia",.F.)

//New(oParent,uBreak,uTitle,lTotalInLine,cName,lPageBreak)
TRFunction():New(oSection1:Cell("RECEBER"),NIL,"SUM",oBreak,"Total",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("PAGAR"),NIL,"SUM",oBreak,"Total",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)

Return(oReport)

/*/
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
//Local oSection2 	:= oReport:Section(1):Section(1)
//Local oSection3 	:= oReport:Section(1):Section(1):Section(1)
Local cQuery 		:= ""
Local nTotPG		:= 0
Local nTotRE		:= 0
//Local d1			:= IIF(lJob,FirstDay(dDataBase),mv_par01)
//Local d2			:= IIF(lJob,dDataBase-1,mv_par02)
//Local cNF			:= IIF(lJob,"",mv_par03)
//Local cCliente	:= IIF(lJob,"",mv_par04)
Local lCabec		:= .T.
Local lJustif		:= .F.
Local aFds 		:= {}
Local nTReal	:= 0
Local nTApara	:= 0
Local aTReal	:= {}
Local aTApara	:= {}
Local cSitua	:= ""


//mv_par01 := cNumLote

//******************************
// Monta a tabela temporária
//******************************

cQuery := " SELECT E5_FILIAL FILIAL, E5_DATA, E5_TIPO, E5_CLIENTE COD, E5_LOJA, A1_NREDUZ NOME, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_VALOR, E5_RECPAG "
If mv_par03 = 2 //empresa atual
	cQuery += " FROM " + RetSqlName("SE5") + " E5 WITH (NOLOCK) "
Else
	cQuery += " FROM SE5010 E5 WITH (NOLOCK) "
EndIf	
cQuery += " INNER JOIN SA1010 A1 "
cQuery += " ON E5_CLIFOR+E5_LOJA = A1_COD+A1_LOJA "
cQuery += " WHERE E5.D_E_L_E_T_ <>'*'  "
cQuery += " AND E5_DATA BETWEEN  '" + Dtos(mv_par01) + "'  AND '" + Dtos(mv_par02) + "' " 
cQuery += " AND E5_RECPAG = 'R'  "
cQuery += " AND E5_TIPODOC NOT IN ('DC','D2','J2','TL','MT','M2','CM','C2','TR','TE','BA','CP') "
cQuery += " AND E5_SITUACA NOT IN ('C','E','X') "
If mv_par03  = 2 //empresa atual
	cQuery += " AND E5_FILIAL = '" + xFilial("SE5") + "' "
EndIf	
cQuery += " UNION "
cQuery += " SELECT E5_FILIAL FILIAL, E5_DATA, E5_TIPO, E5_CLIFOR COD, E5_LOJA, A2_NREDUZ NOME, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_VALOR, E5_RECPAG "
If mv_par03  = 2 //empresa atual
	cQuery += " FROM " + RetSqlName("SE5") + " E5 WITH (NOLOCK) "
Else
	cQuery += " FROM SE5010 E5 WITH (NOLOCK) "
EndIf	
cQuery += " INNER JOIN SA2010 A2 "
cQuery += " ON E5_CLIFOR+E5_LOJA = A2_COD+A2_LOJA "
cQuery += " WHERE E5.D_E_L_E_T_ <>'*'  "
cQuery += " AND E5_DATA BETWEEN '" + Dtos(mv_par01) + "'  AND '" + Dtos(mv_par02) + "' "
cQuery += " AND E5_RECPAG = 'P'  "
cQuery += " AND E5_TIPODOC NOT IN ('DC','D2','J2','TL','MT','M2','CM','C2','TR','TE','CP') "
cQuery += " AND E5_SITUACA NOT IN ('C','E','X') "
If mv_par03  = 2 //empresa atual
	cQuery += " AND E5_FILIAL = '" + xFilial("SE5") + "' "
EndIf	

If mv_par03  = 1 //Todas Empresas

	cQuery += " UNION "
	cQuery += " SELECT '9901' FILIAL, E5_DATA, E5_TIPO, E5_CLIENTE COD, E5_LOJA, A1_NREDUZ NOME, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_VALOR, E5_RECPAG "
	cQuery += " FROM SE5990 E5 WITH (NOLOCK) "
	cQuery += " INNER JOIN SA1010 A1 "
	cQuery += " ON E5_CLIFOR+E5_LOJA = A1_COD+A1_LOJA "
	cQuery += " WHERE E5.D_E_L_E_T_ <>'*'  "
	cQuery += " AND E5_DATA BETWEEN  '" + Dtos(mv_par01) + "'  AND '" + Dtos(mv_par02) + "' " 
	cQuery += " AND E5_RECPAG = 'R'  "
	cQuery += " AND E5_TIPODOC NOT IN ('DC','D2','J2','TL','MT','M2','CM','C2','TR','TE','BA','CP') "
	cQuery += " AND E5_SITUACA NOT IN ('C','E','X') "
	cQuery += " UNION "
	cQuery += " SELECT '9901' FILIAL, E5_DATA, E5_TIPO, E5_CLIFOR COD, E5_LOJA, A2_NREDUZ NOME, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_VALOR, E5_RECPAG "
	cQuery += " FROM SE5990 E5 WITH (NOLOCK) "
	cQuery += " INNER JOIN SA2010 A2 "
	cQuery += " ON E5_CLIFOR+E5_LOJA = A2_COD+A2_LOJA "
	cQuery += " WHERE E5.D_E_L_E_T_ <>'*'  "
	cQuery += " AND E5_DATA BETWEEN '" + Dtos(mv_par01) + "'  AND '" + Dtos(mv_par02) + "' "
	cQuery += " AND E5_RECPAG = 'P'  "
	cQuery += " AND E5_TIPODOC NOT IN ('DC','D2','J2','TL','MT','M2','CM','C2','TR','TE','CP') "
	cQuery += " AND E5_SITUACA NOT IN ('C','E','X') "

EndIf

cQuery += " ORDER BY E5_DATA, FILIAL, E5_RECPAG"

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( "TMP", "E5_DATA", "D")




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
//oReport:Say(oReport:Row(),oReport:Col(),"Analise do Lote " + mv_par01 )
oReport:SkipLine()

nCount	:= TMP->(RECCOUNT())
TMP->( DbGoTop() )
		
oReport:SetMeter(nCount)
oSection1:Init()
	
While !oReport:Cancel() .And. TMP->(!EOF())

	oReport:IncMeter()
		
	oSection1:Cell("EMP"):SetValue(TMP->FILIAL)
	oSection1:Cell("EMP"):SetAlign("CENTER")
	oSection1:Cell("BAIXA"):SetValue(TMP->E5_DATA)
	oSection1:Cell("BAIXA"):SetAlign("CENTER")
	oSection1:Cell("COD"):SetValue(TMP->COD)
	oSection1:Cell("COD"):SetAlign("LEFT")
	oSection1:Cell("LOJA"):SetValue(TMP->E5_LOJA)
	oSection1:Cell("LOJA"):SetAlign("LEFT")
	oSection1:Cell("NOME"):SetValue(TMP->NOME)
	oSection1:Cell("NOME"):SetAlign("LEFT")
	oSection1:Cell("PREFIXO"):SetValue(TMP->E5_PREFIXO)
	oSection1:Cell("PREFIXO"):SetAlign("LEFT")
	oSection1:Cell("NUM"):SetValue(TMP->E5_NUMERO)
	oSection1:Cell("NUM"):SetAlign("LEFT")
	oSection1:Cell("PARCELA"):SetValue(TMP->E5_PARCELA)
	oSection1:Cell("PARCELA"):SetAlign("LEFT")
	If TMP->E5_RECPAG = 'R'
		oSection1:Cell("RECEBER"):SetValue(TMP->E5_VALOR)
		oSection1:Cell("RECEBER"):SetAlign("RIGHT")
		oSection1:Cell("PAGAR"):SetValue(0)
		oSection1:Cell("PAGAR"):SetAlign("RIGHT")
		nTotRE	:= nTotRE + TMP->E5_VALOR
	Else
		oSection1:Cell("RECEBER"):SetValue(0)
		oSection1:Cell("RECEBER"):SetAlign("RIGHT")
		oSection1:Cell("PAGAR"):SetValue(TMP->E5_VALOR)
		oSection1:Cell("PAGAR"):SetAlign("RIGHT")
		nTotPG	:= nTotPG + TMP->E5_VALOR
	EndIf
	
	oSection1:PrintLine()
	TMP->(dbSkip())

EndDo

oSection1:Finish()
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"Total Receber ----- " + Transform( nTotRE , PesqPict('SE1','E1_VALOR') ) )
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"Total Pagar  ----- " + Transform( nTotPG , PesqPict('SE1','E1_VALOR') ) )
//oSection2:Finish()

dbCloseArea("TMP")

Set Filter To

Return
