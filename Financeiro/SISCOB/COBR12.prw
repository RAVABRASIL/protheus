#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³COBR12 ³ Autor ³ Gustavo Costa            ³ Data ³08.07.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio para demonstrar o atendimento de cobrança com os  ³±±
±±³          ³clientes.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COBR12()

Local oReport
Local cPerg	:= "COBR12"
criaSx1(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:= ReportDef()
oReport:PrintDialog()


Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data de?'            , '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data até?'           , '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
putSx1(cPerg, '03', 'Atendente?'         	, '', '', 'mv_ch3', 'C', 6							, 0, 0, 'G', '', 'USR', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Em Branco para Todos"},{},{})
putSx1(cPerg, '04', 'Cliente?' 		      	, '', '', 'mv_ch4', 'C', TAMSX3("A1_COD")[1]   	, 0, 0, 'G', '', 'SA1', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Em Branco para Todos"},{},{})
putSx1(cPerg, '05', 'Resultado?'  			, '', '', 'mv_ch5', 'C', 1   						, 0, 0, 'G', '', ''   , '', '', 'mv_par05','1=Consulta','','','2=Ligação Negativa','','','3=Ligação Positiva','','','4=Email','','','5=Todos','','','', {"Resultados dos atendimentos"},{},{})
putSx1(cPerg, '06', 'Imp. Conversa?'  		, '', '', 'mv_ch6', 'C', 1    						, 0, 0, 'G', '', ''   , '', '', 'mv_par06','Sim','Si','Yes','','Nao','No','No','','','','','','','','','',{"Imprime o conteudo da conversa registada"},{},{})
//putSx1(cPerg, '07', 'CC até?'      		, '', '', 'mv_ch7', 'C', TAMSX3("RA_CC")[1]    	, 0, 0, 'G', '', 'CTT', '', '', 'mv_par07')

return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³COBR12  ³ Autor ³ Gustavo Costa           ³ Data ³20.06.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio para demonstrar o atendimento de cobrança com os  ³±±
±±³          ³clientes.                                                   ³±±
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

oReport:= TReport():New("COBR12","Historico de Cobrança","COBR12", {|oReport| ReportPrint(oReport)},"Este relatório irá imprimir o Histórico das cobranças.")
//oReport:SetLandscape()
oReport:SetPortrait()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Produto de             ³
//³ mv_par02   // Produto ate            ³
//³ mv_par03   // Tipo de                ³
//³ mv_par04   // Tipo ate               ³
//³ mv_par05   // Grupo de               ³
//³ mv_par06   // Grupo ate              ³
//³ mv_par07   // Salta Pagina: Sim/Nao  ³
//³ mv_par08   // Qual Rev da Estrut     ³
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

oSection1 := TRSection():New(oReport,"Atendente:",{"TMP"}) 

TRCell():New(oSection1,'CODATE'		,'','Matricula',	/*Picture*/		,06			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NOMATE'    ,'','Nome'		,	/*Picture*/		,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CODCLI'		,'','Cod. Cli.',	/*Picture*/		,06			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NOMCLI'		,'','Cliente'	,	/*Picture*/		,20			,/*lPixel*/,/*{|| code-block de impressao }*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 2                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,"Histórico",{"TMP"})
oSection2:SetLeftMargin(2)

TRCell():New(oSection2,'DATA'	,'','Data'			,/*Picture*/						,08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'HORAINI','','Hora Ini.'	,/*Picture*/						,08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'HORAFIM','','Hora Fim'	,/*Picture*/						,08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'TEMPO'	,'','Tempo'		,/*PesqPict('SPH','PH_QUANTC',6)*/	,08,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'TIPO'	,'','Tipo'			,/*Picture*/						,09,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'RESULT'	,'','Resultado'	,/*Picture*/						,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'MEMO'	,'','Texto'		,/*Picture*/						,100,/*lPixel*/,/*{|| code-block de impressao }*/,,.T.)

//oSection2:SetHeaderPage()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 3                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3 := TRSection():New(oSection2,"Totais",{"TMP"})
oSection3:SetLeftMargin(3)

TRCell():New(oSection3,'REG'	,''	,'Registros'			,"999999"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
//TRCell():New(oSection3,'HA'		,'','Horas Ativas'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
//TRCell():New(oSection3,'HR'		,'','Horas Receptivas'	,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'TCONS'	,''	,'Tot. H Consul.'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'THPOS'	,'','Tot. H Posit.'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'THNEG'	,'','Tot. H Negat.'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'TEMAI'	,'','Tot. H Email'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'TBOL'	,'','Tot. H Boleto'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'TH'		,'','TOTAL de HORAS'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
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
Local oSection3 	:= oReport:Section(1):Section(1):Section(1)
Local cQuery 		:= ""
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local lContinua 	:= .T.
Local nHoraAt		:= 0
Local nTotHora	:= 0
Local nCont		:= 0
Local nTotHoraG	:= 0
Local nContG		:= 0
Local nTotCons	:= 0
Local nTotLNeg	:= 0
Local nTotLPos	:= 0
Local nTotEmail	:= 0
Local nTotBol		:= 0
Local nTotGCons	:= 0
Local nTotGLNeg	:= 0
Local nTotGLPos	:= 0
Local nTotGEmail	:= 0
Local nTotGBol	:= 0

cQuery := " SELECT *, "
cQuery += " ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),[ZA2].[ZA2_MEMO])),'') AS [MEMO] "
cQuery += " FROM " + RetSqlName("ZA2") + " ZA2 WITH (NOLOCK) "
cQuery += " WHERE ZA2.D_E_L_E_T_ <> '*' "
cQuery += " AND ZA2_DTATEN BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
cQuery += " AND ZA2_HRFIM <> ''"

If !Empty(mv_par03)
	cQuery += " AND ZA2_CODATE = '" + mv_par03 + "' "
EndIf

If !Empty(mv_par04)
	cQuery += " AND ZA2_CODCLI = '" + mv_par04 + "' "
EndIf

If mv_par05 <> 5
	cQuery += " AND ZA2_RESULT = '" + STR(mv_par05) + "' "
EndIf

cQuery += " ORDER BY ZA2_CODCLI, ZA2_DTATEN, ZA2_HRINI, ZA2_RESULT "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( 'TMP', 'ZA2_DTATEN', 'D' )

TMP->( DbGoTop() )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter(TMP->(LastRec()))

While !oReport:Cancel() .And. TMP->(!Eof())

	oReport:IncMeter()

	If lContinua	
		
		If cMatAnt <> TMP->ZA2_CODCLI
			
			oSection1:Init()
			oReport:SkipLine()     
	
			oSection1:Cell("CODATE"):SetValue(TMP->ZA2_CODATE)
			oSection1:Cell("CODATE"):SetAlign("CENTER")
			oSection1:Cell("NOMATE"):SetValue(TMP->ZA2_NOMATE)
			oSection1:Cell("NOMATE"):SetAlign("LEFT")
			oSection1:Cell("CODCLI"):SetValue(TMP->ZA2_CODCLI)
			oSection1:Cell("CODCLI"):SetAlign("CENTER")
			oSection1:Cell("NOMCLI"):SetValue(TMP->ZA2_NOMCLI)
			oSection1:Cell("NOMCLI"):SetAlign("LEFT")
			
			oSection1:PrintLine()
			oReport:SkipLine()     
			oSection1:Finish()
			
			oSection2:Init()
			oSection3:Init()
	
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	Impressao da Sessao 2                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		oSection2:Cell("DATA"):SetValue(TMP->ZA2_DTATEN)
		oSection2:Cell("DATA"):SetAlign("CENTER")
		oSection2:Cell("HORAINI"):SetValue(TMP->ZA2_HRINI)
		oSection2:Cell("HORAINI"):SetAlign("CENTER")
		oSection2:Cell("HORAFIM"):SetValue(TMP->ZA2_HRFIM)
		oSection2:Cell("HORAFIM"):SetAlign("LEFT")
		oSection2:Cell("TEMPO"):SetValue(fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
		oSection2:Cell("TEMPO"):SetAlign("RIGHT")
		
		Do Case
			Case ZA2_RESULT == "1"
				oSection2:Cell("RESULT"):SetValue("Consulta")
				nTotCons	:= SomaHoras(nTotCons,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				nTotGCons	:= SomaHoras(nTotGCons,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				//MsgAlert("Consulta")
			Case ZA2_RESULT == "2"
				oSection2:Cell("RESULT"):SetValue("Ligação Negativa")
				nTotLNeg	:= SomaHoras(nTotLNeg,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				nTotGLNeg	:= SomaHoras(nTotGLNeg,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				//MsgAlert("Ligação Negativa")
			Case ZA2_RESULT == "3"
				oSection2:Cell("RESULT"):SetValue("Ligação Positiva")
				nTotLPos	:= SomaHoras(nTotLPos,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				nTotGLPos	:= SomaHoras(nTotGLPos,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				//MsgAlert("Ligação Positiva")
			Case ZA2_RESULT == "4"
				oSection2:Cell("RESULT"):SetValue("Email")
				nTotEmail	:= SomaHoras(nTotEmail,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				nTotGEmail	:= SomaHoras(nTotGEmail,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				//MsgAlert("Email")
			Case ZA2_RESULT == "5"
				oSection2:Cell("RESULT"):SetValue("Boleto")
				nTotBol	:= SomaHoras(nTotBol,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				nTotGBol	:= SomaHoras(nTotGBol,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				//MsgAlert("Boleto")
			Otherwise
				oSection2:Cell("RESULT"):SetValue("")
		EndCase
				
		//oSection2:Cell("TIPO"):SetValue(IIF(TMP->ZA2_TIPO = 'R',"Receptivo","Ativo"))
		//oSection2:Cell("TIPO"):SetAlign("LEFT")
		oSection2:Cell("RESULT"):SetAlign("CENTER")
		
		If mv_par06 == 1
				oSection2:Cell("MEMO"):SetValue(Alltrim(TMP->MEMO))
				oSection2:Cell("MEMO"):SetAlign("LEFT")
		EndIf
		
		If TMP->ZA2_TIPO = 'C'
			nHoraAt	:= SomaHoras(nHoraAt,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
		EndIf

		nTotHora	:= SomaHoras(nTotHora,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
		nCont++
		nTotHoraG	:= SomaHoras(nTotHoraG,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
		nContG++
		
		oSection2:PrintLine()
		//oReport:SkipLine()     
		
		cMatAnt := TMP->ZA2_CODCLI
		
		TMP->(dbSkip())
		
		If cMatAnt <> TMP->ZA2_CODCLI .and. cMatAnt <> '' 
			
			oReport:SkipLine()
			oSection3:Cell("REG"):SetValue(nCont)
			oSection3:Cell("REG"):SetAlign("RIGHT")
			oSection3:Cell("TCONS"):SetValue(nTotCons)
			oSection3:Cell("TCONS"):SetAlign("RIGHT")
			oSection3:Cell("THPOS"):SetValue(nTotLPos)
			oSection3:Cell("THPOS"):SetAlign("RIGHT")
			oSection3:Cell("THNEG"):SetValue(nTotLNeg)
			oSection3:Cell("THNEG"):SetAlign("RIGHT")
			oSection3:Cell("TEMAI"):SetValue(nTotEmail)
			oSection3:Cell("TEMAI"):SetAlign("RIGHT")
			oSection3:Cell("TBOL"):SetValue(nTotBol)
			oSection3:Cell("TBOL"):SetAlign("RIGHT")

			//oSection3:Cell("HA"):SetValue(nHoraAt)
			//oSection3:Cell("HA"):SetAlign("RIGHT")
			//oSection3:Cell("HR"):SetValue(nTotHora - nHoraAt)
			//oSection3:Cell("HR"):SetAlign("RIGHT")
			oSection3:Cell("TH"):SetValue(nTotHora)
			oSection3:Cell("TH"):SetAlign("RIGHT")
			
			oSection3:PrintLine()

			oReport:SkipLine()
			
			oSection2:Finish()
			oSection3:Finish()
			nTotHora	:= 0
			nCont		:= 0
			nHoraAt	:= 0
			nTotCons	:= 0
			nTotLNeg	:= 0
			nTotLPos	:= 0
			nTotEmail	:= 0
			nTotBol	:= 0
		EndIf
		
	EndIf

EndDo

oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"RESUMO GERAL")
oReport:ThinLine()
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"TOTAL de REGISTROS GERAL -> " + Transform(nContG,"99999"))
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"TOTAL GERAL DE HORAS:")
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"CONSULTA           -> " + Transform(nTotGCons,"99999.99"))
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"HORAS NEGATIVAS    -> " + Transform(nTotGLNeg,"99999.99"))
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"HORAS POSITIVAS    -> " + Transform(nTotGLPos,"99999.99"))
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"EMAIL              -> " + Transform(nTotGEmail,"99999.99"))
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"BOLETO             -> " + Transform(nTotGBol,"99999.99"))
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"TOTAL GERAL        -> " + Transform(nTotHoraG,"99999.99"))
oReport:SkipLine()

//oSection1:Finish()
//-- Devolve a condicao original do arquivo principal
dbCloseArea("TMP")
Set Filter To

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fDifHora ³ Autor ³ Gustavo Costa          ³ Data ³20.06.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para retornar o tempo entre duas horas passadas como ³±±
±±³          ³parametros (texto).                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fDifHora(cHini, cHfim)

Local cRet

cRet	:= ELAPTIME(cHini, cHfim)

Return cRet
