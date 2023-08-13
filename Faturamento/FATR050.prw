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
±±³Programa  ³FATR050  ³ Autor ³ Gustavo Costa          ³ Data ³05.09.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o   ³Relatorio dos pedidos faturados parcialmente.              .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATR050(cNumPed)

Local oReport
Local cPerg	:= "FATR50"

Private lJob		:= .F.
Default	cNumPed	:= ''
ConOut('Relatorio de Faturamento Parcial... '+Dtoc(DATE())+' - '+Time())
ConOut('cNumPed... '+cNumPed)

//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//Não consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SX1" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Ljob = T')
		lJob := .T.
	EndIf

	If	lJob .OR. cNumPed <> ''
		lJob := .T.
		oReport:= ReportDef()
		oReport:Print(.F.)
	Else
		criaSx1(cPerg)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Interface de impressao                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		oReport:= ReportDef()
		oReport:PrintDialog()
	EndIf

	If	( lJob ) .AND. Empty(cNumPed)
		RpcClearEnv()		   				//Libera o Environment
		ConOut('Relatorio de Faturamento Parcial. '+Dtoc(DATE())+' - '+Time())
	EndIf


Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data de?'     	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data até?'  	, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
putSx1(cPerg, '03', 'Pedido?' 		, '', '', 'mv_ch3', 'C', 6                     	, 0, 0, 'G', '', 'SC5', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Em branco para todos"},{},{})

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


Static Function ReportDef(cNumPed)

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

oReport:= TReport():New("FATR50","Faturamento Parcial " ,"FATR50", {|oReport| ReportPrint(oReport,cNumPed)},"Este relatório irá listar o Faturamento Parcial.")
//oReport:SetLandscape()
oReport:SetPortrait()

If lJob
	oReport:nDevice	 	:= 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
	ConOut('oReport:nDevice = 3-email')
	oReport:cEmail		:= GetNewPar("MV_XFATR50",'comercial@ravaembalagens.com.br;gustavo@ravaembalagens.com.br')
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Data de                ³
//³ mv_par02   // Data Até               ³
//³ mv_par03   // Vendedor               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(oReport:uParam,.F.)

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

oSection1 := TRSection():New(oReport,"Pedido",{"TMP"}) 

TRCell():New(oSection1,'PED'			,'','Pedido'			,	/*Picture*/				,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CLIENTE'		,'','Cliente'			,	/*Picture*/				,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'LOJA'			,'','Loja'				,	/*Picture*/				,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NOME'			,'','Nome'				,	/*Picture*/				,40				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EMISSAO'		,'','Dt. Emissao'		,	/*Picture*/				,10				,/*lPixel*/,/*{|| code-block de impressao }*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 2                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,"Itens",{"TMP"})
oSection2:SetLeftMargin(2)

TRCell():New(oSection2,'ITEM'			,'','Item'			,/*Picture*/	,02	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PRODUTO'    	,'','Codigo'		,/*Picture*/	,15	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'DESCRI'			,'','Produto'		,/*Picture*/	,35	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'QTDPED'			,'','Qtd. Pedido'	,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'QTDVEN'			,'','Qtd. Faturada'	,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'QTDFALTA'		,'','Qtd. Resta'	,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'NOTA'			,'','Nota Fiscal'	,/*Picture*/	,09	,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New(oSection1,oSection1:Cell("PED"),"Pedido:",.F.)

//New(oParent,uBreak,uTitle,lTotalInLine,cName,lPageBreak)
//TRFunction():New(oSection2:Cell("DESCO"),NIL,"SUM",oBreak,"Total Horas Descontadas",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)

Return(oReport)

/*/
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

Static Function ReportPrint(oReport,cNumPed)

Local oSection1 	:= oReport:Section(1)
Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local lPula	 	:= .T.
Local lOK 			:= .T.
Local d1			:= IIF(lJob,FirstDay(dDataBase),mv_par01)
Local d2			:= IIF(lJob,dDataBase-1,mv_par02)
Local cNF			:= IIF(lJob,"",mv_par03)
Local cCliente	:= IIF(lJob,"",mv_par04)
Local lCabec		:= .T.
Local lJustif		:= .F.

PRIVATE lMudouDia	:= .F.
PRIVATE dDiaAtu	:= CtoD("  /  /  ")
PRIVATE dDiaAnt	:= CtoD("  /  /  ")

mv_par01 := d1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"PERÍODO de " + DtoC(d1) + " até " + DtoC(d2) )
oReport:SkipLine()

cQuery := " SELECT C6_FILIAL, C6_NUM, A1_COD, A1_LOJA, A1_NOME, C6_PRODUTO, B1_DESC, C6_ITEM, "
cQuery += " C6_QTDVEN, C6_QTDENT, C6_NOTA, C5_EMISSAO " 
cQuery += " FROM " + RetSqlName("SC6") + " C6 WITH (NOLOCK) "
cQuery += " INNER JOIN " + RetSqlName("SC5") + " C5 WITH (NOLOCK) "
cQuery += " ON C6_FILIAL+C6_NUM = C5_FILIAL+C5_NUM "
cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1 WITH (NOLOCK) " 
cQuery += " ON C5_CLIENTE+C5_LOJACLI = A1_COD+A1_LOJA "
cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 WITH (NOLOCK) " 
cQuery += " ON C6_PRODUTO = B1_COD "
cQuery += " WHERE C6.D_E_L_E_T_ <> '*' "
cQuery += " AND C5.D_E_L_E_T_ <> '*' "
cQuery += " AND C6.D_E_L_E_T_ <> '*' "
cQuery += " AND C6_BLQ <> 'R' "

If !Empty(cNumPed)
	cQuery += " AND C6_NUM = '" + cNumPed + "' "
Else
	cQuery += " AND C6_NUM IN ( "
	cQuery += " 	SELECT C6_NUM FROM " + RetSqlName("SC6") + " C6 WITH (NOLOCK) "
	cQuery += " 	INNER JOIN " + RetSqlName("SC5") + " C5 WITH (NOLOCK) "
	cQuery += " 	ON C6_FILIAL+C6_NUM = C5_FILIAL+C5_NUM "
	cQuery += " 	WHERE C5_EMISSAO BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "'"
	cQuery += " 	AND C6.D_E_L_E_T_ <> '*' "
	cQuery += " 	AND C6_NOTA <> '' "
	cQuery += " 	AND C6_BLQ <> 'R' "
	cQuery += " 	AND C6_FILIAL = '" + xFilial("SC6") + "' "
	cQuery += " 	AND C6_QTDVEN - C6_QTDENT > 0) "
EndIf
cQuery += " ORDER BY C6_FILIAL+C6_NUM+C6_ITEM "


If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( "TMP", "C5_EMISSAO", "D")

nCount	:= TMP->(RECCOUNT())
TMP->( DbGoTop() )
		
oReport:SetMeter(nCount)
	
While !oReport:Cancel() .And. TMP->(!EOF())

	oReport:IncMeter()
	cChave	:= TMP->C6_NUM
	
	If lCabec

		oSection1:Init()
		
		oReport:SkipLine()     
		oSection1:Cell("PED"):SetValue(TMP->C6_NUM)
		oSection1:Cell("PED"):SetAlign("CENTER")
		oSection1:Cell("CLIENTE"):SetValue(TMP->A1_COD)
		oSection1:Cell("CLIENTE"):SetAlign("CENTER")
		oSection1:Cell("LOJA"):SetValue(TMP->A1_LOJA)
		oSection1:Cell("LOJA"):SetAlign("LEFT")
		oSection1:Cell("NOME"):SetValue(TMP->A1_NOME)
		oSection1:Cell("NOME"):SetAlign("LEFT")
		oSection1:Cell("EMISSAO"):SetValue(TMP->C5_EMISSAO)
		oSection1:Cell("EMISSAO"):SetAlign("CENTER")

		oSection1:PrintLine()
		//oReport:SkipLine()     
		//oSection1:Finish()
			
		oSection2:Init()
		lCabec	:= .F.

	EndIf
		
			
		oSection2:Cell("ITEM"):SetValue(TMP->C6_ITEM)
		oSection2:Cell("ITEM"):SetAlign("CENTER")
		oSection2:Cell("PRODUTO"):SetValue(TMP->C6_PRODUTO)
		oSection2:Cell("PRODUTO"):SetAlign("RIGHT")
		oSection2:Cell("DESCRI"):SetValue(TMP->B1_DESC)
		oSection2:Cell("DESCRI"):SetAlign("LEFT")
		oSection2:Cell("QTDPED"):SetValue(TMP->C6_QTDVEN)
		oSection2:Cell("QTDPED"):SetAlign("RIGHT")
		oSection2:Cell("QTDVEN"):SetValue(TMP->C6_QTDENT)
		oSection2:Cell("QTDVEN"):SetAlign("RIGHT")
		oSection2:Cell("QTDFALTA"):SetValue(TMP->C6_QTDVEN - TMP->C6_QTDENT)
		oSection2:Cell("QTDFALTA"):SetAlign("RIGHT")
		oSection2:Cell("NOTA"):SetValue(TMP->C6_NOTA)
		oSection2:Cell("NOTA"):SetAlign("RIGHT")
		oSection2:PrintLine()
	
	TMP->(dbSkip())
	
	If cChave <> TMP->C6_NUM
	
		oSection1:Finish()
		oSection2:Finish()
		lCabec := .T.
		oSection1:Init()
		
	EndIf

EndDo

oSection1:Finish()
oSection2:Finish()

dbCloseArea("TMP")

Set Filter To

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FATR050  ³ Autor ³ Gustavo Costa          ³ Data ³05.09.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o   ³Relatorio dos pedidos faturados parcialmente.              .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function WFFATR050(cNumPed)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aResult   := {}
Local LF      	:= CHR(13)+CHR(10)
Local chtm		:= ""
Local cDIRHTM	:= ""
Local cARQHTM	:= ""
Local nHandle	:= 0
Local nPag		:= 1
Local cNomredesp:= ""	



SetPrvt( "NORDEM,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3," )
SetPrvt( "ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA," )
SetPrvt( "NLIN,WNREL,M_PAG,CABEC1,CABEC2,MPAG," )


tamanho   := "P"
titulo    := "Pedido faturado parcialmente - " + cNumPed
cDesc1    := "Este programa ira emitir o relatorio "
cDesc2    := "de Pedido faturado parcialmente "
cDesc3    := ""
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "FATR050"
cPerg     := "FATR50"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "FATR050"
M_PAG     := 1
li		  := 80





cQuery := " SELECT C6_FILIAL, C6_NUM, A1_COD, A1_LOJA, A1_NOME, C6_PRODUTO, B1_DESC, C6_ITEM, "
cQuery += " C6_QTDVEN, C6_QTDENT, C6_NOTA, C5_EMISSAO " 
cQuery += " FROM " + RetSqlName("SC6") + " C6 WITH (NOLOCK) "
cQuery += " INNER JOIN " + RetSqlName("SC5") + " C5 WITH (NOLOCK) "
cQuery += " ON C6_FILIAL+C6_NUM = C5_FILIAL+C5_NUM "
cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1 WITH (NOLOCK) " 
cQuery += " ON C5_CLIENTE+C5_LOJACLI = A1_COD+A1_LOJA "
cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 WITH (NOLOCK) " 
cQuery += " ON C6_PRODUTO = B1_COD "
cQuery += " WHERE C6.D_E_L_E_T_ <> '*' "
cQuery += " AND C5.D_E_L_E_T_ <> '*' "
cQuery += " AND C6.D_E_L_E_T_ <> '*' "
cQuery += " AND C6_BLQ <> 'R' "
cQuery += " AND C6_NUM = '" + cNumPed + "' "
cQuery += " ORDER BY C6_FILIAL+C6_NUM+C6_ITEM "

TCQUERY cQuery NEW ALIAS "TMP2"
TCSetField( "TMP2", "C5_EMISSAO", "D")

TMP2->( DbGoTop() )

aResult 	:= {}


Do While !TMP2->( Eof() )  
    
	Aadd (aResult, {TMP2->C6_NUM,;  		//1
					TMP2->A1_COD,;			//2			  
	  				TMP2->A1_LOJA,;			//3
	  				TMP2->A1_NOME,;         //4
	  				TMP2->C6_PRODUTO ,;		//5
					TMP2->B1_DESC ,;    	//6
					TMP2->C6_ITEM,; 		//7
					TMP2->C6_QTDVEN,;     	//8
					TMP2->C6_QTDENT,;		//9
					TMP2->C6_NOTA,;			//11
					TMP2->C5_EMISSAO } )	//10
  
 
  TMP2->( DbSkip() )

Enddo


If Len(aResult) <= 0
	//Alert("Não existem dados para os parâmetros informados, por favor, reveja os parâmetros !")
	DbselectArea("TMP2")
	DbcloseArea()
	Return
EndIF

/////////////////
cDirHTM  := "\Temp\"    
cArqHTM  := "FATR050-" + Dtos(dDatabase) + ".HTM"    //relatório P/ Gerentes
nHandle  := fCreate( cDirHTM + cArqHTM, 0 )
nPag     := 1 
   
If nHandle = -1
     //MsgAlert('O arquivo '+AllTrim(cArqHTM)+' nao pode ser criado! Verifique os parametros.','Atencao!')
     Return
Endif

If Len(aResult) > 0

	FOR X := 1 TO Len(aResult)
			
			If Li > 35
				//Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  //Impressao do cabecalho
				li := 9
				li++
				
				///prepara o html
				chtm := '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+LF
				chtm += '<html><head>'                                                         +LF 
				chtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+LF
				chtm += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+LF
				chtm += '<tr>    <td>'+LF
				chtm += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Verdana">'+LF
				chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>RAVA EMBALAGENS INDUSTRIA COM. LTDA.</td>  <td></td>'+LF
				chtm += '<td align="right">Folha..:' + Str(nPag) + '</td></tr>'+LF
				chtm += '<tr>        <td>SIGA /FATR050/v.P10</td>'+LF
				chtm += '<td>'+titulo+'</td>'+LF
				chtm += '<td align="right">DT.Ref.:'+ Dtoc(dDatabase)+'</td>        </tr>        <tr>'+LF
				chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
				chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
				chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
				chtm += '</table></head>'+LF
  			
				chtm += '<table width="1100" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>PEDIDO</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>COD</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>LOJA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>NOME</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>ITEM</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>COD</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>PRODUTO</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>QTD. PEDIDO</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>QTD. FATURADA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>RESTA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>NOTA FISCAL</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><tr>'+LF
				
				nPag++
				
			Endif         
				
                
        chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,1] + '</span></td>'+LF
		chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,2] + '</span></td>'+LF
		chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,3] + '</span></td>'+LF
		chtm += '<td width="900" align="center"><span class="style3">'+ aResult[X,4]  + '</span></td>'+LF
		chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,7]  + '</span></td>'+LF
		chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,5]  + '</span></td>'+LF
		chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,6] + '</span></td>'+LF
		chtm += '<td width="300" align="center"><span class="style3">'+ aResult[X,8] + '</span></td>'+LF
		chtm += '<td width="500" align="center"><span class="style3">'+ aResult[X,9] + '</span></td>'+LF
		chtm += '<td width="500" align="center"><span class="style3">'+ aResult[X,8] - aResult[X,9] + '</span></td>'+LF
		chtm += '<td width="500" align="center"><span class="style3">'+ aResult[X,10] + '</span></td>'+LF
		chtm += '</tr>'+LF  //FECHA A LINHA 
		
		li++
			
        
	NEXT
	/////FECHA A TABELA DO HTML
	chtm += '</table><br>'	
	
Else
	
	///prepara o html
	chtm := '<html><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'+LF
	chtm += '<html><head>'                                                         +LF 
	chtm += '<META http-equiv="Content-Type" content="text/html; charset=utf-8">'+LF
	chtm += '<table width="1300" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" width="900">'+LF
	chtm += '<tr>    <td>'+LF
	chtm += '<table border="0" cellspacing="0" cellpadding="0" width="99%" bgcolor="#FFFFFF" style="font-size:12px;font-family:Verdana">'+LF
	chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>          <td>RAVA EMBALAGENS INDUSTRIA COM. LTDA.</td>  <td></td>'+LF
	chtm += '<td align="right">Folha..:' + Str(nPag) + '</td></tr>'+LF
	chtm += '<tr>        <td>SIGA /FATR015/v.P10</td>'+LF
	chtm += '<td>'+titulo+'</td>'+LF
	chtm += '<td align="right">DT.Ref.:'+ Dtoc(dDatabase)+'</td>        </tr>        <tr>'+LF
	chtm += '<td>Hora...: '+ Time() + '</td>          <td></td>'+LF
	chtm += '<td align="right">Emissao: '+ Dtoc(dDatabase) + '</tr></table></head>'+LF
	chtm += '<tr>    <td colspan="3"><hr color="#000000" noshade size="2"></td>        </tr><tr>'+LF
	chtm += '</table></head>'+LF
			
				chtm += '<table width="1100" border="1" style="font-size:12px;font-family:Verdana"><strong>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>PEDIDO</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>COD</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>LOJA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>NOME</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>ITEM</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>COD</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>PRODUTO</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>QTD. PEDIDO</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>QTD. FATURADA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>RESTA</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><span class="style3"><b>NOTA FISCAL</span></div></b></td>'+LF
				chtm += '<td ><div align="center"><tr>'+LF
    chtm += '</table><br>'+LF
    
Endif
////if do aresult > 0

//////FECHA O HTML PARA GRAVAÇÃO E ENVIO
chtm += '</body> '
chtm += '</html> '
//////GRAVA O HTML
Fwrite( nHandle, chtm, Len(chtm) )
FClose( nHandle )
nRet := 0
						
//////SELECIONA O EMAIL DESTINATÁRIO 
cMailTo := "gustavo@ravaembalagens.com.br"
cCopia  := ""
cCorpo  := titulo
cAnexo  := cDirHTM + cArqHTM
cAssun  := titulo
//////ENVIA O HTML COMO ANEXO
U_SendFatr11( cMailTo, cCopia, cAssun, cCorpo, cAnexo ) 

TMP2->( DbCloseArea() )

//Roda( 0, "", TAMANHO )

/*
If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao - mostra na tela.
Endif
*/

//Msginfo("Processo finalizado")

// Habilitar somente para Schedule
Reset environment


Return NIL





