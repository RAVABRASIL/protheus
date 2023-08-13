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
±±³Programa  ³PCPR044  ³ Autor ³ Gustavo Costa          ³ Data ³29.11.2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o   ³Relatorio das horas produtivas das máquinas detalhado.     .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPR044()

	Local oReport
	Local cPerg	:= "PCPR34"

	Private lJob		:= .F.

//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//Não consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SX1" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Relatorio horas produtivas das maquinas detalhado... '+Dtoc(DATE())+' - '+Time())
		lJob := .T.
	EndIf

	If	lJob
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

	If	( lJob )
		RpcClearEnv()		   				//Libera o Environment
		ConOut('Relatorio horas produtivas das maquinas Concluído. '+Dtoc(DATE())+' - '+Time())
	EndIf


Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

	putSx1(cPerg, '01', 'Data de?'     	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
	putSx1(cPerg, '02', 'Data até?'  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
	putSx1(cPerg, '03', 'Do Recurso?'     	, '', '', 'mv_ch3', 'C', 9                     	, 0, 0, 'G', '', 'SH1', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Recurso inicial"},{},{})
	putSx1(cPerg, '04', 'Até Recurso?'    	, '', '', 'mv_ch4', 'C', 9                     	, 0, 0, 'G', '', 'SH1', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Recurso final"},{},{})

return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PCPR044  ³ Autor ³ Gustavo Costa          ³ Data ³14.04.2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio das horas produtivas das máquinas.                 .³±±
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

	oReport:= TReport():New("PCPR34","Disponibilidade de Recursos Analitico","PCPR34", {|oReport| ReportPrint(oReport)},"Este relatório irá listar a disponibilidade das máquinas de forma Analitica.")
//oReport:SetLandscape()
	oReport:SetPortrait()

	If lJob
		oReport:nDevice	 	:= 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
		oReport:cEmail		:= GetNewPar("MV_XPCPR34",'marcelo@ravaembalagens.com.br;orley@ravaembalagens.com.br;mario.aguiar@ravaembalagens.com.br;gustavo@ravaembalagens.com.br')
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

	oSection1 := TRSection():New(oReport,"Recurso",{"TMP"})

	TRCell():New(oSection1,'Z90_RECURS'		,'','Recurso'		,	/*Picture*/				,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'H1_DESCRI'			,'','Nome'			,	/*Picture*/				,25				,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'H1_IP'				,'','IP'			,	/*Picture*/				,25				,/*lPixel*/,/*{|| code-block de impressao }*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 2                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection2 := TRSection():New(oSection1,"Histórico",{"TMP"})
	oSection2:SetLeftMargin(2)

	TRCell():New(oSection2,'Z90_DATA'    	,'','Data'					,/*Picture*/	,10	,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,'STATUS'			,'','Status'		,/*Picture*/	,25	,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,'HORA'			,'','Hora'	,/*Picture*/	,08	,/*lPixel*/,/*{|| code-block de impressao }*/)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("BRUTO"),"Total Centro de Custo")
	//oBreak := TRBreak():New(oSection1,oSection1:Cell("Z90_RECURS"),"Total das horas no período	:",.F.)


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
	Local oSection2 	:= oReport:Section(1):Section(1)
	Local cQuery 		:= ""
	Local cMatAnt		:= ""
	Local nNivel   	:= 0
	Local lContinua 	:= .T.
	Local lFirstH 	:= .T.
	Local lLastH 		:= .F.
	Local cRecAnt		:= ""
	Local cTipoAnt	:= ""
	Local cFuncAnt	:= ""
	Local cHoraAnt	:= ""
	Local cTurno1		:= SubStr(GetMv("MV_TURNO1"),1,5) // 05:20
	Local cTurno2		:= SubStr(GetMv("MV_TURNO2"),1,5) // 13:40
	Local cTurno3		:= SubStr(GetMv("MV_TURNO3"),1,5) // 22:00
	Local nHProdLig	:= 0
	Local nHImprodLig	:= 0
	Local nHProd		:= 0
	Local nHImprod	:= 0
	Local nTotHProd	:= 0
	Local nTotHImprod	:= 0
	Local nHDesc		:= 0
	Local nHTotal		:= 0
	Local nTotHProg	:= 0
	Local nTotHPP		:= 0
	Local nTempo		:= 0
	Local d1			:= IIF(lJob,FirstDay(dDataBase),mv_par01)
	Local d2			:= IIF(lJob,dDataBase-1,mv_par02)
	Local cRec1		:= IIF(lJob,"",mv_par03)
	Local cRec2		:= IIF(lJob,"ZZZZZZ",mv_par04)
	Local lCabec		:= .T.
	lOCAL cStatus		:= ""

	PRIVATE lMudouDia	:= .F.
	PRIVATE dDiaAtu	:= CtoD("  /  /  ")
	PRIVATE dDiaAnt	:= CtoD("  /  /  ")

	mv_par01 := d1

	DbSelectArea("Z90")
	DbSelectArea("Z91")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//oReport:Say(oReport:Row(),oReport:Col(),"PERÍODO de " + DtoC(mv_par01) + " até " + DtoC(mv_par02) )
	oReport:SkipLine()
	oReport:ThinLine()
	oReport:SkipLine()
	oReport:Say(oReport:Row(),oReport:Col(),"H. Produtivas 		- São as horas em que a máquina está efetivamente produzindo.")
	oReport:SkipLine()
	oReport:Say(oReport:Row(),oReport:Col(),"H. Improdutivas 	- São as horas em que a máquina parou de produzir por qualquer motivo.")
	oReport:SkipLine()
	oReport:Say(oReport:Row(),oReport:Col(),"% Disp. 			- O percentual de disponibilidade do dia.")
	oReport:SkipLine()
	oReport:Say(oReport:Row(),oReport:Col(),"Desconto 			- São as horas em que não formaram par.")
	oReport:SkipLine()
	oReport:SkipLine()
	oReport:ThinLine()

	cQuery := " SELECT * FROM " + RetSqlName("SH1") + " H "
	cQuery += " WHERE H.D_E_L_E_T_ <> '*' "
	cQuery += " AND H1_CODIGO BETWEEN '" + cRec1 + "' AND '" + cRec2 + "'"
	cQuery += " AND H1_IP <> '' "
	cQuery += " ORDER BY H1_CODIGO"

	If Select("XH1") > 0
		DbSelectArea("XH1")
		DbCloseArea()
	EndIf

	TCQUERY cQuery NEW ALIAS "XH1"
	XH1->( DbGoTop() )
			
	While XH1->(!EOF())

		While d1 <= d2
	
		//***********************************
		// Monta a tabela das transferencias
		//***********************************
		
			cQuery := " SELECT Z90_RECURS, H1_DESCRI, H1_IP, Z90_FUNC, Z90_TIPO, Z90_DATA, Z90_HORA, "
			cQuery += " CASE WHEN Z90_HORA BETWEEN '" + cTurno1 + "' AND '" + cTurno2 + "' THEN '1' ELSE "
			cQuery += " CASE WHEN Z90_HORA BETWEEN '" + cTurno2 + "' AND '" + cTurno3 + "' THEN '2' ELSE '3' END END TURNO "
			cQuery += " FROM " + RetSqlName("Z90") + " Z "
			cQuery += " INNER JOIN " + RetSqlName("SH1") + " H "
			cQuery += " ON Z90_RECURS = H1_CODIGO "
			cQuery += " WHERE H.D_E_L_E_T_ <> '*' "
			cQuery += " AND Z.D_E_L_E_T_ <> '*' "
			cQuery += " AND Z90_DATA = '" + DtoS(d1) + "' "
			//cQuery += " AND Z90_DATA + Z90_HORA >= '" + DtoS(d1) + cTurno1 + "' "
			//cQuery += " AND Z90_DATA + Z90_HORA < '" + DtoS(d1+1) + cTurno1 + "' "
			cQuery += " AND Z90_RECURS = '" + XH1->H1_CODIGO + "'"
			cQuery += " AND Z90_FUNC = 'PRO' "
			cQuery += " ORDER BY Z90_RECURS, Z90_DATA, Z90_HORA, Z90_FUNC"
		
		
			If Select("TMP") > 0
				DbSelectArea("TMP")
				DbCloseArea()
			EndIf
		
			TCQUERY cQuery NEW ALIAS "TMP"
			TCSetField( 'TMP', "Z90_DATA", "D", 8, 0 )
			TMP->( DbGoTop() )
		
			While !oReport:Cancel() .And. TMP->(!Eof())
			
				oReport:IncMeter()
			
				If lCabec
					oSection1:Init()
						
					oReport:SkipLine()
					oSection1:Cell("Z90_RECURS"):SetValue(TMP->Z90_RECURS)
					oSection1:Cell("Z90_RECURS"):SetAlign("CENTER")
					oSection1:Cell("H1_DESCRI"):SetValue(TMP->H1_DESCRI)
					oSection1:Cell("H1_DESCRI"):SetAlign("LEFT")
					oSection1:Cell("H1_IP"):SetValue(TMP->H1_IP)
					oSection1:Cell("H1_IP"):SetAlign("LEFT")
			
					oSection1:PrintLine()
					oReport:SkipLine()
					oSection1:Finish()
						
					oSection2:Init()
					lCabec		:= .F.
				EndIf
				
				oSection2:Cell("Z90_DATA"):SetValue(TMP->Z90_DATA)
				oSection2:Cell("Z90_DATA"):SetAlign("CENTER")
				
				If TMP->Z90_TIPO == '02' 
					cStatus		:= "COMEÇOU A PRODUZIR AS"
				Else
					cStatus	:= "PAROU DE PRODUZIR AS"
				EndIf 
				
				oSection2:Cell("STATUS"):SetValue(cStatus)
				oSection2:Cell("STATUS"):SetAlign("LEFT")
				oSection2:Cell("HORA"):SetValue(TMP->Z90_HORA)
				oSection2:Cell("HORA"):SetAlign("CENTER")
				oSection2:PrintLine()

				dLastDay	:= 	TMP->Z90_DATA
				//************************
				//Mudou o registro
				//************************
				TMP->(dbSkip())
				
				If dLastDay <> TMP->Z90_DATA 
					oReport:SkipLine()
				EndIf
				
			EndDo
			
		
			dbCloseArea("TMP")
			
			d1	:= d1 + 1
		
		EndDo
	
		oSection2:Finish()
		oSection1:Finish()
		lCabec		:= .T.
		dbselectArea("XH1")
		XH1->(dbSkip())
		d1	:= mv_par01

	EndDo
	dbCloseArea("XH1")

	Set Filter To

Return


