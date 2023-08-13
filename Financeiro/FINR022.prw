#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Programa  :FINR022 ³ Autor :Gustavo Costa         ³ Data :23/10/2017   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao : Relatorio fluxo de caixa.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros:                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function FINR022()
	
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

oReport:= TReport():New("FINR21","Fluxo de Caixa" ,"FINR21", {|oReport| ReportPrint(oReport)},"Este relatório irá listar fluxo a receber e pagar.")
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

TRCell():New(oSection1,'EMP'			,'','Emp.'			,	/*Picture*/				,04				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DIA'			,'','DATA'			,	/*Picture*/				,10				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'RECEBER'		,'','A Receber'		,PesqPict('SE1','E1_VALOR') ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PAGAR'			,'','A Pagar'		,PesqPict('SE1','E1_VALOR') ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'RESULT'			,'','Resultado'		,PesqPict('SE1','E1_VALOR') ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)

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

oBreak := TRBreak():New(oSection1,oSection1:Cell("EMP"),"Total Empresa",.F.)

//New(oParent,uBreak,uTitle,lTotalInLine,cName,lPageBreak)
TRFunction():New(oSection1:Cell("RECEBER"),NIL,"SUM",oBreak,"Total",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("PAGAR"),NIL,"SUM",oBreak,"Total",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("RESULT"),NIL,"SUM",oBreak,"Total",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
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
fCriaTAB()

//******************************
// Monta a tabela temporária CONTAS A RECEBER
//******************************
If mv_par03  = 1 //Todas
	cQuery += " SELECT E1_VENCREA, SUM (VALOR) VALOR FROM ( "
EndIf

cQuery += " SELECT E1_FILIAL, E1_VENCREA, SUM ( E1_VALOR ) VALOR "
If mv_par03 = 2 //empresa atual
	cQuery += " FROM " + RetSqlName("SE1") + " E1 WITH (NOLOCK) "
Else
	cQuery += " FROM SE1010 E1 WITH (NOLOCK) "
EndIf	
cQuery += " WHERE D_E_L_E_T_ <>'*' "
cQuery += " AND E1_VENCREA BETWEEN  '" + Dtos(mv_par01) + "'  AND '" + Dtos(mv_par02) + "' " 
cQuery += " AND E1_TIPO NOT IN ('NCC','RA') "
cQuery += " AND (E1_BAIXA >= '" + Dtos(mv_par01 - 1) + "' OR E1_BAIXA ='') "
If mv_par03  = 2 //empresa atual
	cQuery += " AND E1_FILIAL = '" + xFilial("SE1") + "' "
EndIf	
cQuery += " GROUP BY E1_FILIAL, E1_VENCREA "

If mv_par03  = 1 //Todas

	cQuery += " UNION "
	
	cQuery += " SELECT '99' AS E1_FILIAL, E1_VENCREA, SUM ( E1_VALOR ) VALOR "
	cQuery += " FROM SE1990 E1 WITH (NOLOCK) "
	cQuery += " WHERE D_E_L_E_T_ <>'*' "
	cQuery += " AND E1_VENCREA BETWEEN  '" + Dtos(mv_par01) + "'  AND '" + Dtos(mv_par02) + "' " 
	cQuery += " AND E1_TIPO NOT IN ('NCC','RA') "
	cQuery += " AND (E1_BAIXA >= '" + Dtos(mv_par01 - 1) + "' OR E1_BAIXA ='') "
	cQuery += " GROUP BY E1_FILIAL, E1_VENCREA "
	cQuery += " ) AS TAB "
	cQuery += " GROUP BY E1_VENCREA "
EndIf

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
//TCSetField( "TMP", "E1_VENCREA", "D")

TMP->( DbGoTop() )
//ProcRegua( nREGTOT )

While TMP->( !EOF() )

	RecLock("XE1", .T.)
	XE1->EMP		:= TMP->E1_FILIAL
	XE1->DIA		:= TMP->E1_VENCREA
	XE1->RECEBER	:= TMP->VALOR
	XE1->PAGAR		:= 0
	XE1->RESULT		:= 0

	XE1->(MsUnLock())

	TMP->(Dbskip())

Enddo

TMP->( DbCloseArea() ) 


//******************************
// Monta a tabela temporária CONTAS A PAGAR
//******************************

If mv_par03  = 1 //Todas
	cQuery += " SELECT E2_VENCREA, SUM (VALOR) VALOR FROM ( "
EndIf

cQuery := " SELECT E2_FILIAL, E2_VENCREA, SUM ( E2_VALOR ) VALOR "
If mv_par03 = 2 //empresa atual
	cQuery += " FROM " + RetSqlName("SE2") + " E2 WITH (NOLOCK) "
Else
	cQuery += " FROM SE2010 E2 WITH (NOLOCK) "
EndIf	
cQuery += " WHERE D_E_L_E_T_ <>'*' "
cQuery += " AND E2_VENCREA BETWEEN  '" + Dtos(mv_par01) + "'  AND '" + Dtos(mv_par02) + "' " 
cQuery += " AND E2_TIPO NOT IN ('NDF','AB-','PA') "
cQuery += " AND (E2_BAIXA >= '" + Dtos(mv_par01 - 1) + "' OR E2_BAIXA ='') "
If mv_par03  = 2 //empresa atual
	cQuery += " AND E2_FILIAL = '" + xFilial("SE2") + "' "
EndIf	
cQuery += " GROUP BY E2_FILIAL, E2_VENCREA "

If mv_par03  = 1 //Todas

	cQuery += " UNION "
	
	cQuery += " SELECT E2_FILIAL, E2_VENCREA, SUM ( E2_VALOR ) VALOR "
	cQuery += " FROM SE2990 E2 WITH (NOLOCK) "
	cQuery += " WHERE D_E_L_E_T_ <>'*' "
	cQuery += " AND E2_VENCREA BETWEEN  '" + Dtos(mv_par01) + "'  AND '" + Dtos(mv_par02) + "' " 
	cQuery += " AND E2_TIPO NOT IN ('NDF','AB-','PA') "
	cQuery += " AND (E2_BAIXA >= '" + Dtos(mv_par01 - 1) + "' OR E2_BAIXA ='') "
	cQuery += " GROUP BY E2_FILIAL, E2_VENCREA "
	cQuery += " ) AS TAB "
	cQuery += " GROUP BY E2_VENCREA "
EndIf

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
//TCSetField( "TMP", "E2_VENCREA", "D")

TMP->( DbGoTop() )
//ProcRegua( nREGTOT )

While TMP->( !EOF() )

	dbSelectArea("XE1")
	If dbSeek(TMP->E2_VENCREA)
		RecLock("XE1", .F.)
		
		XE1->PAGAR		:= TMP->VALOR
	
		XE1->(MsUnLock())
	Else
		RecLock("XE1", .T.)
		
		XE1->EMP		:= TMP->E2_FILIAL
		XE1->DIA		:= TMP->E2_VENCREA
		XE1->RECEBER	:= 0
		XE1->PAGAR		:= TMP->VALOR
		XE1->RESULT		:= 0
	
		XE1->(MsUnLock())	
	EndIf

	TMP->(Dbskip())

Enddo

TMP->( DbCloseArea() ) 

dbSelectArea("XE1")
XE1->(dbGoTop())

While XE1->( !EOF() )

		RecLock("XE1", .F.)
		
		XE1->RESULT		:= XE1->RECEBER - XE1->PAGAR
	
		XE1->(MsUnLock())

	XE1->(Dbskip())

Enddo
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

dbSelectArea("XE1")
nCount	:= XE1->(RECCOUNT())
XE1->(dbGoTop())
		
oReport:SetMeter(nCount)
oSection1:Init()
	
While !oReport:Cancel() .And. XE1->(!EOF())

	oReport:IncMeter()
		
	oSection1:Cell("EMP"):SetValue(XE1->EMP)
	oSection1:Cell("EMP"):SetAlign("CENTER")
	oSection1:Cell("DIA"):SetValue(DtoC(StoD(XE1->DIA)))
	oSection1:Cell("DIA"):SetAlign("CENTER")
	oSection1:Cell("RECEBER"):SetValue(XE1->RECEBER)
	oSection1:Cell("RECEBER"):SetAlign("RIGHT")
	oSection1:Cell("PAGAR"):SetValue(XE1->PAGAR)
	oSection1:Cell("PAGAR"):SetAlign("RIGHT")
	oSection1:Cell("RESULT"):SetValue(XE1->RESULT)
	oSection1:Cell("RESULT"):SetAlign("RIGHT")
	
	oSection1:PrintLine()
	XE1->(dbSkip())

EndDo

oSection1:Finish()
/*
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"Total Receber ----- " + Transform( nTotRE , PesqPict('SE1','E1_VALOR') ) )
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"Total Pagar  ----- " + Transform( nTotPG , PesqPict('SE1','E1_VALOR') ) )
//oSection2:Finish()
*/
dbCloseArea("XE1")

Set Filter To

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCriaTAB     º Autor ³ Gustavo Costa  º Data ³  27/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cria a tabela temporaria de cada recurso.                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fCriaTAB()

Local aFds	:= {}
Private cTRAB	:= ""
Private cTAB	:= "XE1"

Aadd( aFds , {"EMP"   	,"C",020,000} )
Aadd( aFds , {"DIA"   	,"C",008,000} )
Aadd( aFds , {"RECEBER" ,"N",014,002} )
Aadd( aFds , {"PAGAR"   ,"N",014,002} )
Aadd( aFds , {"RESULT" 	,"N",014,002} )

cTRAB := CriaTrab( aFds, .T. )
Use (cTRAB) Alias &cTAB New Exclusive
IndRegua(cTAB,cTRAB,"DIA",,,'Selecionando Registros...') //'Selecionando Registros...'

Return

