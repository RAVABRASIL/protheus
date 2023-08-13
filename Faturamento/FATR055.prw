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
±±³Programa  ³FATR051    ³ Autor ³ Gustavo Costa        ³ Data ³13.09.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Quadro de acompanhamento dos pedidos e expedição            .³±±
±±³          ³  LINHA                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR055()

Local oReport
//Local cPerg	:= "FATR51"
//criaSx1(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Pergunte(cPerg,.T.)

oReport:= ReportDef()
oReport:PrintDialog()


Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

//putSx1(cPerg, '01', 'Data Base de?'     	  	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
//putSx1(cPerg, '02', 'Data Base até?'	  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
//putSx1(cPerg, '03', 'Representante?'     		, '', '', 'mv_ch3', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})
//putSx1(cPerg, '04', 'Estado?'	     			, '', '', 'mv_ch4', 'C', 2                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})

return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FISR001  ³ Autor ³ Gustavo Costa          ³ Data ³20.09.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de avaliação de clientes XDD.     .³±±
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

oReport:= TReport():New("FATR55","Acompanhamento dos pedidos e expedição","FATR55", {|oReport| ReportPrint(oReport)},"Este relatório irá imprimir o Acompanhamento dos pedidos e expedição.")
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

oSection1 := TRSection():New(oReport,"PERÍODO de " + DtoC(ddatabase) ,{"TAB"}) 

TRCell():New(oSection1,'FIL'			,'','Filial'		,	/*Picture*/		,04				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PED'			,'','Pedido'		,	/*Picture*/		,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NOTA'			,'','NF'			,	/*Picture*/		,09				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'AC_ZERO'		,'','AC. 0'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'AC_UM'			,'','AC. 1'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'AC_DOISM'		,'','AC. 2 +'		,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PRD_ZERO'    	,'','Prod. 0'		,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PRD_UMATRES'	,'','Prod. 1 a 3'	,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PRD_QUATRO'		,'','Prod. 4'		,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PRD_CINCOM'		,'','Prod. 5 +'		,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EXP_ZERO'    	,'','Exp. 0'		,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EXP_UM'			,'','Exp. 1 '		,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EXP_DOISAT'		,'','Exp. 2 a 3'	,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EXP_QUATRM'		,'','Exp. 4 +'		,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ENT_ZERO'		,'','Entr. 0'		,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ENT_UM'			,'','Entr. 1'		,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ENT_DOISACINCO'	,'','Entr. 2 a 5'	,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ENT_SEISADEZ'	,'','Entr. 6 a 10'	,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ENT_ONZEM'		,'','Entr. 11 +'	,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("REP"),"Total",.F.)
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
Local nNivel   		:= 0
Local lContinua 	:= .T.
Local aFds 			:= {}

//******************************
// Monta a tabela temporária
//******************************

Aadd( aFds , {"FIL"				,"C",002,000} )
Aadd( aFds , {"PED"				,"C",006,000} )
Aadd( aFds , {"NOTA"			,"C",009,000} )
Aadd( aFds , {"AC_ZERO" 		,"C",002,000} )
Aadd( aFds , {"AC_UM" 			,"C",002,000} )
Aadd( aFds , {"AC_DOISM" 		,"C",002,000} )
Aadd( aFds , {"PRD_ZERO" 		,"C",002,000} )
Aadd( aFds , {"PRD_UMATRE" 		,"C",002,000} )
Aadd( aFds , {"PRD_QUATRO" 		,"C",002,000} )
Aadd( aFds , {"PRD_CINCOM" 		,"C",002,000} )
Aadd( aFds , {"EXP_ZERO" 		,"C",002,000} )
Aadd( aFds , {"EXP_UM" 			,"C",002,000} )
Aadd( aFds , {"EXP_DOISAT" 		,"C",002,000} )
Aadd( aFds , {"EXP_QUATRM" 		,"C",002,000} )
Aadd( aFds , {"ENT_ZERO" 		,"C",002,000} )
Aadd( aFds , {"ENT_UM" 			,"C",002,000} )
Aadd( aFds , {"ENT_DOISAC"	 	,"C",002,000} )
Aadd( aFds , {"ENT_SEISAD" 		,"C",002,000} )
Aadd( aFds , {"ENT_ONZEM" 		,"C",002,000} )

coTbl := CriaTrab( aFds, .T. )
Use (coTbl) Alias TAB New Exclusive
dbCreateIndex(coTbl,'FIL+PED+NOTA', {|| FIL+PED+NOTA })

//***********************************
// Monta a tabela de vendas por NCM
//***********************************

cQuery := " SELECT DISTINCT C9_FILIAL, C9_PEDIDO, " 
cQuery += " AC_ZERO=(CASE WHEN C9_DATENT = '" + DtoS(dDataBase) + "' AND C9_BLCRED <> '' THEN 'X' ELSE '' END) , "
cQuery += " AC_UM=(CASE WHEN C9_DATENT = '" + DtoS(dDataBase - 1) + "' AND C9_BLCRED <> '' THEN 'X' ELSE '' END), "
cQuery += " AC_DOISM=(CASE WHEN C9_DATENT < '" + DtoS(dDataBase - 1) + "' AND C9_BLCRED <> '' THEN 'X' ELSE '' END), "
cQuery += " PRD_ZERO=(CASE WHEN C9_DTBLCRE = '" + DtoS(dDataBase) + "' THEN 'X' ELSE '' END), "
cQuery += " PRD_UMATRES=(CASE WHEN C9_DTBLCRE BETWEEN '" + DtoS(dDataBase - 3) + "' AND '" + DtoS(dDataBase - 1) + "' THEN 'X' ELSE '' END), "
cQuery += " PRD_QUATRO=(CASE WHEN C9_DTBLCRE = '" + DtoS(dDataBase - 4) + "' THEN 'X' ELSE '' END), "
cQuery += " PRD_CINCOM=(CASE WHEN C9_DTBLCRE < '" + DtoS(dDataBase - 4) + "' AND C9_BLCRED = '' THEN 'X' ELSE '' END) "
cQuery += " FROM SC9020 C9 WITH (NOLOCK) "
cQuery += " INNER JOIN SC6020 C6 WITH (NOLOCK) "
cQuery += " ON C9_FILIAL + C9_ITEM + C9_PRODUTO + C9_PEDIDO = C6_FILIAL + C6_ITEM + C6_PRODUTO + C6_NUM "
cQuery += " WHERE C9.D_E_L_E_T_ <> '*' "
cQuery += " AND C9_NFISCAL = '' "
cQuery += " AND C9_SEQUEN = '01' "
cQuery += " AND C6_CF IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
cQuery += " AND C9_CLIENTE NOT IN ('031732','031733','006543','007005') " 
cQuery += " ORDER BY C9_PEDIDO DESC "

MemoWrite("C:\TEMP\FATR055A.SQL", cQuery)

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
	
	Replace TAB->FIL 			with TMP->C9_FILIAL
	Replace TAB->PED 			with TMP->C9_PEDIDO
	//Replace TAB->NOTA 		with TMP->NOTA
	Replace TAB->AC_ZERO 		with TMP->AC_ZERO 
	Replace TAB->AC_UM 			with TMP->AC_UM
	Replace TAB->AC_DOISM		with TMP->AC_DOISM
	Replace TAB->PRD_ZERO 		with TMP->PRD_ZERO 
	Replace TAB->PRD_UMATRE 	with TMP->PRD_UMATRES
	Replace TAB->PRD_QUATRO		with TMP->PRD_QUATRO
	Replace TAB->PRD_CINCOM 	with TMP->PRD_CINCOM 
	
	MsUnlock()
	TMP->(dbSkip())

EndDo


cQuery := " SELECT DISTINCT D2_FILIAL, D2_PEDIDO, D2_DOC, " 
cQuery += " EXP_ZERO=(CASE WHEN F2_EMISSAO = '" + DtoS(dDataBase) + "' THEN 'X' ELSE '' END) , "
cQuery += " EXP_UM=(CASE WHEN F2_EMISSAO = '" + DtoS(dDataBase - 1) + "' THEN 'X' ELSE '' END), "
cQuery += " EXP_DOISATRES=(CASE WHEN F2_EMISSAO BETWEEN '" + DtoS(dDataBase - 3) + "' AND '" + DtoS(dDataBase - 2) + "' THEN 'X' ELSE '' END), "
cQuery += " EXP_QUATROM=(CASE WHEN F2_EMISSAO < '" + DtoS(dDataBase - 3) + "' THEN 'X' ELSE '' END) "
cQuery += " FROM SD2020 D2 WITH (NOLOCK) "
cQuery += " INNER JOIN SF2020 F2 WITH (NOLOCK) "
cQuery += " ON D2_FILIAL + D2_SERIE + D2_DOC = F2_FILIAL + F2_SERIE + F2_DOC "
cQuery += " WHERE D2.D_E_L_E_T_ <> '*' "
cQuery += " AND F2_DTEXP = '' "
cQuery += " AND F2_SERIE = '0' "
cQuery += " AND F2_EMISSAO > '" + DtoS(dDataBase - 60) + "' "
cQuery += " AND D2_QUANT - D2_QTDEDEV > 0 "
cQuery += " AND D2_CF IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
cQuery += " AND D2_CLIENTE NOT IN ('031732','031733','006543','007005') "
cQuery += " ORDER BY D2_DOC DESC "

MemoWrite("C:\TEMP\FATR055B.SQL", cQuery)

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
	
	If TAB->(dbSeek(TMP2->D2_FILIAL + TMP2->D2_PEDIDO + TMP2->D2_DOC))
	
		RecLock("TAB",.F.)
		
		Replace TAB->FIL 			with TMP2->D2_FILIAL
		Replace TAB->PED 			with TMP2->D2_PEDIDO
		Replace TAB->NOTA 			with TMP2->D2_DOC
		Replace TAB->EXP_ZERO 		with TMP2->EXP_ZERO
		Replace TAB->EXP_UM 		with TMP2->EXP_UM
		Replace TAB->EXP_DOISAT		with TMP2->EXP_DOISATRES
		Replace TAB->EXP_QUATRM 	with TMP2->EXP_QUATROM
		
		MsUnlock()

	Else

		RecLock("TAB",.T.)
		
		Replace TAB->FIL 			with TMP2->D2_FILIAL
		Replace TAB->PED 			with TMP2->D2_PEDIDO
		Replace TAB->NOTA 			with TMP2->D2_DOC
		Replace TAB->EXP_ZERO 		with TMP2->EXP_ZERO
		Replace TAB->EXP_UM 		with TMP2->EXP_UM
		Replace TAB->EXP_DOISAT		with TMP2->EXP_DOISATRES
		Replace TAB->EXP_QUATRM 	with TMP2->EXP_QUATROM
		
		MsUnlock()
	
	EndIf

	TMP2->(dbSkip())

EndDo

cQuery := " SELECT DISTINCT D2_FILIAL, D2_PEDIDO, D2_DOC, " 
cQuery += " ENT_ZERO=(CASE WHEN F2_PREVCHG = '" + DtoS(dDataBase) + "' THEN 'X' ELSE '' END) , "
cQuery += " ENT_UM=(CASE WHEN F2_PREVCHG = '" + DtoS(dDataBase - 1) + "' THEN 'X' ELSE '' END), "
cQuery += " ENT_DOISACINCO=(CASE WHEN F2_PREVCHG BETWEEN '" + DtoS(dDataBase - 5) + "' AND '" + DtoS(dDataBase - 2) + "' THEN 'X' ELSE '' END), "
cQuery += " ENT_SEISADEZ=(CASE WHEN F2_PREVCHG BETWEEN '" + DtoS(dDataBase - 10) + "' AND '" + DtoS(dDataBase - 6) + "' THEN 'X' ELSE '' END), "
cQuery += " ENT_ONZEM=(CASE WHEN F2_PREVCHG < '" + DtoS(dDataBase - 10) + "' THEN 'X' ELSE '' END) "
cQuery += " FROM SD2020 D2 WITH (NOLOCK) "
cQuery += " INNER JOIN SF2020 F2 WITH (NOLOCK) "
cQuery += " ON D2_FILIAL + D2_SERIE + D2_DOC = F2_FILIAL + F2_SERIE + F2_DOC "
cQuery += " WHERE D2.D_E_L_E_T_ <> '*' "
cQuery += " AND F2_DTEXP <> '' "
cQuery += " AND F2_REALCHG = '' " 
cQuery += " AND F2_SERIE = '0' "
cQuery += " AND F2_PREVCHG <= '" + DtoS(dDataBase) + "' "
cQuery += " AND F2_EMISSAO > '" + DtoS(dDataBase - 90) + "' "
cQuery += " AND D2_QUANT - D2_QTDEDEV > 0 "
cQuery += " AND D2_CF IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) "
cQuery += " AND D2_CLIENTE NOT IN ('031732','031733','006543','007005') "
cQuery += " ORDER BY D2_DOC DESC "

MemoWrite("C:\TEMP\FATR055C.SQL", cQuery)

If Select("TMP3") > 0
	DbSelectArea("TMP3")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP3"

TMP3->( DbGoTop() )

//******************************
//PREENCHE COM O META OS ESTADOS QUE NÃO TIVERAM VEDAS
//******************************
While TMP3->(!Eof())
	
	If TAB->(dbSeek(TMP3->D2_FILIAL + TMP3->D2_PEDIDO + TMP3->D2_DOC))
	
		RecLock("TAB",.F.)
		
		Replace TAB->FIL 			with TMP3->D2_FILIAL
		Replace TAB->PED 			with TMP3->D2_PEDIDO
		Replace TAB->NOTA 			with TMP3->D2_DOC
		Replace TAB->ENT_ZERO 		with TMP3->ENT_ZERO
		Replace TAB->ENT_UM 		with TMP3->ENT_UM
		Replace TAB->ENT_DOISAC		with TMP3->ENT_DOISACINCO
		Replace TAB->ENT_SEISAD 	with TMP3->ENT_SEISADEZ
		Replace TAB->ENT_ONZEM 		with TMP3->ENT_ONZEM
		
		MsUnlock()

	Else

		RecLock("TAB",.T.)
		
		Replace TAB->FIL 			with TMP3->D2_FILIAL
		Replace TAB->PED 			with TMP3->D2_PEDIDO
		Replace TAB->NOTA 			with TMP3->D2_DOC
		Replace TAB->ENT_ZERO 		with TMP3->ENT_ZERO
		Replace TAB->ENT_UM 		with TMP3->ENT_UM
		Replace TAB->ENT_DOISAC		with TMP3->ENT_DOISACINCO
		Replace TAB->ENT_SEISAD 	with TMP3->ENT_SEISADEZ
		Replace TAB->ENT_ONZEM 		with TMP3->ENT_ONZEM
		
		MsUnlock()
	
	EndIf

	TMP3->(dbSkip())

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
oReport:Say(oReport:Row(),oReport:Col(),"Dia " + DtoC(dDataBase) )
oSection1:PrintLine()
oReport:SkipLine()
oReport:ThinLine()

While !oReport:Cancel() .And. TAB->(!Eof())

	oReport:IncMeter()

	oSection1:Cell("FIL"):SetValue(TAB->FIL)
	oSection1:Cell("FIL"):SetAlign("CENTER")
	oSection1:Cell("PED"):SetValue(TAB->PED)
	oSection1:Cell("PED"):SetAlign("LEFT")
	oSection1:Cell("NOTA"):SetValue(TAB->NOTA)
	oSection1:Cell("NOTA"):SetAlign("LEFT")
	oSection1:Cell("AC_ZERO"):SetValue(TAB->AC_ZERO)
	oSection1:Cell("AC_ZERO"):SetAlign("CENTER")
	oSection1:Cell("AC_UM"):SetValue(TAB->AC_UM)
	oSection1:Cell("AC_UM"):SetAlign("CENTER")
	oSection1:Cell("AC_DOISM"):SetValue(TAB->AC_DOISM)
	oSection1:Cell("AC_DOISM"):SetAlign("CENTER")
	oSection1:Cell("PRD_ZERO"):SetValue(TAB->PRD_ZERO)
	oSection1:Cell("PRD_ZERO"):SetAlign("CENTER")
	oSection1:Cell("PRD_UMATRES"):SetValue(TAB->PRD_UMATRE)
	oSection1:Cell("PRD_UMATRES"):SetAlign("CENTER")
	oSection1:Cell("PRD_QUATRO"):SetValue(TAB->PRD_QUATRO)
	oSection1:Cell("PRD_QUATRO"):SetAlign("CENTER")
	oSection1:Cell("PRD_CINCOM"):SetValue(TAB->PRD_CINCOM)
	oSection1:Cell("PRD_CINCOM"):SetAlign("CENTER")
	oSection1:Cell("EXP_ZERO"):SetValue(TAB->EXP_ZERO)
	oSection1:Cell("EXP_ZERO"):SetAlign("CENTER")
	oSection1:Cell("EXP_UM"):SetValue(TAB->EXP_UM)
	oSection1:Cell("EXP_UM"):SetAlign("CENTER")
	oSection1:Cell("EXP_DOISAT"):SetValue(TAB->EXP_DOISAT)
	oSection1:Cell("EXP_DOISAT"):SetAlign("CENTER")
	oSection1:Cell("EXP_QUATRM"):SetValue(TAB->EXP_QUATRM)
	oSection1:Cell("EXP_QUATRM"):SetAlign("CENTER")
	oSection1:Cell("ENT_ZERO"):SetValue(TAB->ENT_ZERO)
	oSection1:Cell("ENT_ZERO"):SetAlign("CENTER")
	oSection1:Cell("ENT_UM"):SetValue(TAB->ENT_UM)
	oSection1:Cell("ENT_UM"):SetAlign("CENTER")
	oSection1:Cell("ENT_DOISACINCO"):SetValue(TAB->ENT_DOISAC)
	oSection1:Cell("ENT_DOISACINCO"):SetAlign("CENTER")
	oSection1:Cell("ENT_SEISADEZ"):SetValue(TAB->ENT_SEISAD)
	oSection1:Cell("ENT_SEISADEZ"):SetAlign("CENTER")
	oSection1:Cell("ENT_ONZEM"):SetValue(TAB->ENT_ONZEM)
	oSection1:Cell("ENT_ONZEM"):SetAlign("CENTER")
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TAB->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TAB")
dbCloseArea("TMP")
dbCloseArea("TMP2")
dbCloseArea("TMP3")
Set Filter To

Return


