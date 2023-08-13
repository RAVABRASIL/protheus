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
±±³Programa  ³PCPR034  ³ Autor ³ Gustavo Costa          ³ Data ³14.04.2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o   ³Relatorio das horas produtivas das máquinas.               .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPR034()

Local oReport
Local cPerg	:= "PCPR34"

Private lJob		:= .F.

//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//Não consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SX1" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Relatorio horas produtivas das maquinas... '+Dtoc(DATE())+' - '+Time())
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
±±³Programa  ³PCPR034  ³ Autor ³ Gustavo Costa          ³ Data ³14.04.2014³±±
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

oReport:= TReport():New("PCPR34","Disponibilidade de Recursos","PCPR34", {|oReport| ReportPrint(oReport)},"Este relatório irá listar a disponibilidade das máquinas.")
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
TRCell():New(oSection2,'PROD'			,'','H. Produtivas'		,/*Picture*/	,08	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'IMPROD'			,'','H. Improdutivas'	,/*Picture*/	,08	,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'PPROD'			,'','% Disp.'				,/*Picture*/	,06	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PPRODP'			,'','% Disp. Prog.'		,/*Picture*/	,06	,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'PIMPROD'		,'','% H. Improdutivas'	,/*Picture*/	,06	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'DESCO'			,'','Descontos'			,/*Picture*/	,08	,/*lPixel*/,/*{|| code-block de impressao }*/)
///TRCell():New(oSection2,'PDESCO'			,'','% Descontos'			,/*Picture*/	,06	,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'TOTAL'			,'','Total Horas'			,/*Picture*/	,08	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'TOTALP'			,'','Total Horas Prog.'	,/*Picture*/	,08	,/*lPixel*/,/*{|| code-block de impressao }*/)

//oSection2:SetHeaderPage()

//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("BRUTO"),"Total Centro de Custo")
oBreak := TRBreak():New(oSection1,oSection1:Cell("Z90_RECURS"),"Total das horas no período	:",.F.)

//New(oParent,uBreak,uTitle,lTotalInLine,cName,lPageBreak)
//oBreak := TRBreak():New(oTREPORT02,{ || oTREPORT02:Cell('E1_CLIENTE'):uPrint+oTREPORT02:Cell('E1_LOJA'):uPrint },'Sub-Total',.F.)

//TRFunction():New(oTREPORT02:Cell('E1_CLIENTE'),, 'COUNT',oBreak ,,,,.F.,.F.,.F., oTREPORT02)

//TRFunction():New(oSection2:Cell("PROD"),NIL,"SUM",oBreak,"Total Horas Produtivas",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
//TRFunction():New(oSection2:Cell("IMPROD"),NIL,"SUM",oBreak,"Total Horas Inprodutivas",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
//TRFunction():New(oSection2:Cell("DESCO"),NIL,"SUM",oBreak,"Total Horas Descontadas",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)

//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)

//oReport:SendMail()

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
		cQuery += " AND Z90_DATA + Z90_HORA >= '" + DtoS(d1) + cTurno1 + "' " 
		cQuery += " AND Z90_DATA + Z90_HORA < '" + DtoS(d1+1) + cTurno1 + "' " 
		cQuery += " AND Z90_RECURS = '" + XH1->H1_CODIGO + "'"
		cQuery += " AND Z90_FUNC = 'PRO' "
//		cQuery += " AND Z90_RECURS BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
		cQuery += " ORDER BY Z90_RECURS, Z90_DATA, Z90_HORA, Z90_FUNC"
		
		
		If Select("TMP") > 0
			DbSelectArea("TMP")
			DbCloseArea()
		EndIf
		
		TCQUERY cQuery NEW ALIAS "TMP"
		TCSetField( 'TMP', "Z90_DATA", "D", 8, 0 )
		TMP->( DbGoTop() )
		
		If TMP->(!Eof())
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
				
				If lFirstH // Primeira hora do dia
				
					dDiaAtu	:= TMP->Z90_DATA
					
					If d1 < TMP->Z90_DATA
					
						nTempo	:= TempoLig(TMP->Z90_HORA, cTurno1 + ":00", .T.)
					 	// Se estiver parando a producao neste registro, é porque estava produzindo até agora.
						If TMP->Z90_TIPO == '02' .AND. cTipoAnt <> TMP->Z90_TIPO
							nHProd		+= nTempo
						Else
							nHImprod	+= nTempo
						EndIf
						nHTotal		+= nTempo
					
					Else
					
						Do Case
							Case TMP->Z90_FUNC = 'LIG'
								
								nTempo	:= TempoLig(TMP->Z90_HORA, cTurno1 + ":00")
								// Se estiver desligando o equipamento neste registro, é porque estava ligado até agora.
								If TMP->Z90_TIPO == '02'
									nHProdLig		+= nTempo
								Else
									nHImprodLig	+= nTempo
								EndIf
					
								nHTotal		+= nTempo
					
							Case TMP->Z90_FUNC = 'PRO'
					 			
								nTempo	:= TempoLig(TMP->Z90_HORA, cTurno1 + ":00")
					 			// Se estiver parando a producao neste registro, é porque estava produzindo até agora.
								If TMP->Z90_TIPO == '02' .AND. cTipoAnt <> TMP->Z90_TIPO
									nHProd		+= nTempo
								Else
									nHImprod	+= nTempo
								EndIf
					
								nHTotal		+= nTempo
					
							OtherWise	
					
								nTempo	:= TempoLig(TMP->Z90_HORA, cTurno1 + ":00")
								// se nao formar par de batida, registra com Hora descontada
								If !Empty(TMP->Z90_HORA)
									nHDesc		+= nTempo
									nHTotal	+= nTempo
								EndIf
					
						EndCase
					
					EndIf	
					
					lFirstH	:= .F.
					
				EndIf	
	
				cRecAnt 	:= TMP->Z90_RECURS
				dDiaAnt	:= TMP->Z90_DATA
				cHoraAnt	:= TMP->Z90_HORA
				cTipoAnt	:= TMP->Z90_TIPO
				cFuncAnt	:= TMP->Z90_FUNC
				
				//************************
				//Mudou o registro
				//************************
				TMP->(dbSkip())
				
				If dDiaAnt	== TMP->Z90_DATA
					lMudouDia	:= .F.
				Else
					If !Empty(TMP->Z90_DATA) .AND. dDiaAnt	< TMP->Z90_DATA
						lMudouDia	:= .T.
						dDiaAtu	:= dDiaAnt
					EndIf
					If Empty(TMP->Z90_DATA) .AND. d1	== dDiaAnt //dDiaAtu	== dDiaAnt//terminou arquivo
						lMudouDia	:= .T.
					EndIf
				EndIf
				
				//*******************************************************
				//Divisor do total dos dias de cada recurso.
				//*******************************************************
				If cRecAnt <> TMP->Z90_RECURS
			//	If (DtoC(dDiaAnt) + TMP->Z90_HORA  >=  DtoC(dDiaAtu + 1) +  cTurno1) .OR. (cRecAnt <> TMP->Z90_RECURS)
					//oReport:SkipLine()     
			
					// Ultima hora do dia ou dia+1
					Do Case
						Case cFuncAnt = 'LIG'
				
							nTempo	:= TempoLig(cTurno1 + ":00" , cHoraAnt, lMudouDia)
							If cTipoAnt == '01'
								nHProdLig		+= nTempo
							Else
								nHImprodLig	+= nTempo
							EndIf
				
							nHTotal		+= nTempo
				
						Case cFuncAnt = 'PRO'
				
							nTempo	:= TempoLig(cTurno1 + ":00" , cHoraAnt, lMudouDia)
							If cTipoAnt == '01'
								nHProd		+= nTempo
							Else
								nHImprod	+= nTempo
							EndIf
				
							nHTotal		+= nTempo
				
						OtherWise	
				
							nTempo	:= TempoLig(cTurno1 + ":00" , cHoraAnt, lMudouDia)
							If !Empty(cHoraAnt)
								nHDesc		+= nTempo
								nHTotal	+= nTempo
							EndIf
				
					EndCase
					
					nTotHProg	:= fHPrgMaq(cRecAnt, dDiaAtu)
					
					//If nHTotal > nTotHProg
				
					oSection2:Cell("Z90_DATA"):SetValue(d1)
					oSection2:Cell("Z90_DATA"):SetAlign("CENTER")
					oSection2:Cell("PROD"):SetValue(fSec4Hora( nHProd ))
					oSection2:Cell("PROD"):SetAlign("RIGHT")
					//oSection2:Cell("PPROD"):SetValue(Round((nHProd/nHTotal)*100,2))
					//oSection2:Cell("PPROD"):SetAlign("CENTER")
					oSection2:Cell("PPRODP"):SetValue(Round((nHProd/nTotHProg)*100,2))
					oSection2:Cell("PPRODP"):SetAlign("CENTER")
					oSection2:Cell("IMPROD"):SetValue(fSec4Hora( nHImprod ))
					oSection2:Cell("IMPROD"):SetAlign("RIGHT")
					//oSection2:Cell("PIMPROD"):SetValue(Round((nHImprod/nHTotal)*100,2))
					//oSection2:Cell("PIMPROD"):SetAlign("LEFT")
					oSection2:Cell("DESCO"):SetValue(fSec4Hora( nHDesc ))
					oSection2:Cell("DESCO"):SetAlign("CENTER")
					//oSection2:Cell("PDESCO"):SetValue(Round((nHDesc/nHTotal)*100,2))
					//oSection2:Cell("PDESCO"):SetAlign("CENTER")
					//oSection2:Cell("TOTAL"):SetValue(fSec4Hora( nHTotal ))
					//oSection2:Cell("TOTAL"):SetAlign("RIGHT")
					oSection2:Cell("TOTALP"):SetValue(fSec4Hora( nTotHProg ))
					oSection2:Cell("TOTALP"):SetAlign("RIGHT")
					oSection2:PrintLine()
			
					//oReport:SkipLine()
					dbSelectArea("ZC2")
					dbsetOrder(1)
					
					If ZC2->(dbSeek(xFilial("ZC2") + cRecAnt + DtoS(dDiaAtu) ))
					
						RecLock("ZC2", .F.)
						ZC2->ZC2_DISPON	:= Round((nHProd/nTotHProg)*100,2)
						ZC2->ZC2_HP		:= fSec4Hora( nHProd )
						ZC2->ZC2_HN		:= fSec4Hora( nHImprod )
						MsUnLock()
					
					Else
					
						RecLock("ZC2", .T.)
						ZC2->ZC2_FILIAL	:= xFilial("ZC2")
						ZC2->ZC2_REC		:= cRecAnt
						ZC2->ZC2_DATA		:= dDiaAtu
						ZC2->ZC2_DISPON	:= Round((nHProd/nTotHProg)*100,2)
						ZC2->ZC2_HP		:= fSec4Hora( nHProd )
						ZC2->ZC2_HN		:= fSec4Hora( nHImprod )
						MsUnLock()
	
					EndIf
					
					dbSelectArea("TMP")
					
					nTotHProd		:= nTotHProd + nHProd
					nTotHImprod	:= nTotHImprod + nHImprod
					nTotHPP		:= nTotHPP + nTotHProg
					
					nHProdLig		:= 0
					nHImprodLig	:= 0
					nHProd			:= 0
					nHImprod		:= 0
					nHDesc			:= 0
					nHTotal		:= 0
					lFirstH		:= .T.
					dDiaAtu		:= TMP->Z90_DATA
	
				EndIf
				
				If !lFirstH
					Do Case
						Case TMP->Z90_FUNC = 'LIG'
				
							nTempo	:= TempoLig(TMP->Z90_HORA, cHoraAnt, lMudouDia)
							// Se estiver desligando o equipamento neste registro, é porque estava ligado até agora.
							If TMP->Z90_TIPO == '02' 
								nHProdLig		+= nTempo
							Else
								nHImprodLig	+= nTempo
							EndIf
				
							nHTotal		+= nTempo
				
						Case TMP->Z90_FUNC = 'PRO'
				
							nTempo	:= TempoLig(TMP->Z90_HORA, cHoraAnt, lMudouDia)
							// Se estiver parando a producao neste registro, é porque estava produzindo até agora.
							If TMP->Z90_TIPO == '02'  .AND. cTipoAnt <> TMP->Z90_TIPO
								nHProd		+= nTempo
							Else
								nHImprod	+= nTempo
							EndIf
				
							nHTotal		+= nTempo
				
						OtherWise	
							
							nTempo	:= TempoLig(TMP->Z90_HORA, cHoraAnt, lMudouDia)
							// se nao formar par de batida, registra com Hora descontada
							If !Empty(TMP->Z90_HORA)
								nHDesc		+= nTempo
								nHTotal	+= nTempo
							EndIf
				
					EndCase
				EndIf
			EndDo
			
		Else //Se não houver informação para o dia, pega o ultimo status registrado

			nTempo	:= 86400 //dia inteiro

			If cTipoAnt == '01'
				nHProd		:= nTempo
			Else
				nHImprod	:= nTempo
			EndIf
			
			nHDesc	:= 0
			nTotHProg	:= fHPrgMaq(cRecAnt, d1)
			
			oSection2:Cell("Z90_DATA"):SetValue(d1)
			oSection2:Cell("Z90_DATA"):SetAlign("CENTER")
			oSection2:Cell("PROD"):SetValue(fSec4Hora( nHProd ))
			oSection2:Cell("PROD"):SetAlign("RIGHT")
			oSection2:Cell("PPRODP"):SetValue(Round((nHProd/nTotHProg)*100,2))
			oSection2:Cell("PPRODP"):SetAlign("CENTER")
			oSection2:Cell("IMPROD"):SetValue(fSec4Hora( nHImprod ))
			oSection2:Cell("IMPROD"):SetAlign("RIGHT")
			oSection2:Cell("DESCO"):SetValue(fSec4Hora( nHDesc ))
			oSection2:Cell("DESCO"):SetAlign("CENTER")
			oSection2:Cell("TOTALP"):SetValue(fSec4Hora( nTotHProg ))
			oSection2:Cell("TOTALP"):SetAlign("RIGHT")
			oSection2:PrintLine()

			//oReport:SkipLine()
			dbSelectArea("ZC2")
			dbsetOrder(1)
			
			If ZC2->(dbSeek(xFilial("ZC2") + cRecAnt + DtoS(d1) ))
			
				RecLock("ZC2", .F.)
				ZC2->ZC2_DISPON	:= Round((nHProd/nTotHProg)*100,2)
				ZC2->ZC2_HP		:= fSec4Hora( nHProd )
				ZC2->ZC2_HN		:= fSec4Hora( nHImprod )
				MsUnLock()
			
			Else
			
				RecLock("ZC2", .T.)
				ZC2->ZC2_FILIAL	:= xFilial("ZC2")
				ZC2->ZC2_REC		:= cRecAnt
				ZC2->ZC2_DATA		:= d1
				ZC2->ZC2_DISPON	:= Round((nHProd/nTotHProg)*100,2)
				ZC2->ZC2_HP		:= fSec4Hora( nHProd )
				ZC2->ZC2_HN		:= fSec4Hora( nHImprod )
				MsUnLock()

			EndIf
			
			dbSelectArea("TMP")

			nTotHProd		:= nTotHProd + nHProd
			nTotHImprod	:= nTotHImprod + nHImprod
			nTotHPP		:= nTotHPP + nTotHProg
			
			nHProdLig		:= 0
			nHImprodLig	:= 0
			nHProd			:= 0
			nHImprod		:= 0
			nHDesc			:= 0
			nHTotal		:= 0
			lFirstH		:= .T.
			dDiaAtu		:= TMP->Z90_DATA

		EndIf
		
		dbCloseArea("TMP")
			
		d1	:= d1 + 1
		
	EndDo
	
	
	If nTotHProd > 0
	
		oReport:Say(oReport:Row(),50,"Totais - ")
		oReport:Say(oReport:Row(),280,fSec4Hora( nTotHProd ))
		oReport:Say(oReport:Row(),495,fSec4Hora( nTotHImprod ))
		oReport:Say(oReport:Row(),670,Transform(Round((nTotHProd/nTotHPP)*100,2),"@E 999.99") )
		oReport:Say(oReport:Row(),1050,fSec4Hora( nTotHPP ))
	
	EndIf
	
	nTotHProd				:= 0
	nTotHImprod			:= 0
	nTotHPP				:= 0
	
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


**************
Static Function TempoLig( _cHora1, _cHora2, lDiaSeg)
**************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2
local _nRs1:=_nRs2:=_nRs3:=0
local _cRes:=''
local Hr,ResHr,Mi,Seg
local cHr:=''
local cRs4:='' 

If lDiaSeg
	
	//********************************************************
	//Inverte as horas para calcular até meia noite 
	//********************************************************
	cHoraDS	:= _cHora1
	_cHora1	:= "23:59:59"

	_nHr1 	:= Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
	_nMi1 	:= Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
	cRs4	:= Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
	_nSg1 	:= Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 
	
	_nHr2 	:= Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
	_nMi2 	:= Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
	cRs4	:= Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
	_nSg2 	:= Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )
	
	_nRs1	:= _nHr1+_nMi1+_nSg1
	_nRs2	:= _nHr2+_nMi2+_nSg2
	
	_nRs3	:= _nRs1 - _nRs2 + 1
	
	//********************************************************
	//Calcula de 00:00 até a proxima hora.
	//********************************************************

	_cHora1	:= cHoraDS
	_cHora2	:= "00:00:00"

	_nHr1 	:= Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
	_nMi1 	:= Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
	cRs4	:= Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
	_nSg1 	:= Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 
	
	_nHr2 	:= Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
	_nMi2 	:= Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
	cRs4	:= Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
	_nSg2 	:= Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )
	
	_nRs1	:= _nHr1+_nMi1+_nSg1
	_nRs2	:= _nHr2+_nMi2+_nSg2
	
	_nRs3	+= _nRs1 - _nRs2

	lMudouDia	:= .F.
	
Else

	_nHr1 	:= Val(  Subst(_cHora1,1,AT(":",_cHora1)-1 )  )*3600     
	_nMi1 	:= Val(  Subst(_cHora1,AT(":",_cHora1)+1,2)  )*60
	cRs4	:= Subst(_cHora1,AT(":",_cHora1)+1,len(_cHora1))
	_nSg1 	:= Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 
	
	_nHr2 := Val(  Subst(_cHora2,1,AT(":",_cHora2)-1)  )*3600
	_nMi2 := Val(  Subst(_cHora2,AT(":",_cHora2)+1,2)  )*60
	cRs4:=Subst(_cHora2,AT(":",_cHora2)+1,len(_cHora2))
	_nSg2 := Val(   Subst(cRs4,AT(":",cRs4)+1,2 )  )
	
	_nRs1:=_nHr1+_nMi1+_nSg1
	_nRs2:=_nHr2+_nMi2+_nSg2
	
	_nRs3:=_nRs1 - _nRs2

EndIf
	
if _nRs3<0
  _nRs3	:= 0  
Endif

Return(  _nRs3  )    


**************
Static Function fSec4Hora( nSec )
**************

local _cRes:=''
local Hr,ResHr,Mi,Seg

Hr:=int(nSec/3600)
ResHr:=nSec%3600
Mi:=int(ResHr/60)
Seg:=ResHr%60

If Hr >99
cHr:=alltrim(str(Hr)	)
else
cHr:=StrZero(Hr,2)
EndIf

_cRes :=  cHr +":"+StrZero(Mi,2)+":"+StrZero(Seg,2)

Return(  _cRes  )    

//------------------------------------------------------------------------------------------
/*
Pegas as informações das programações das maquinas.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
Static Function fHPrgMaq(cRec, dDataI)

Local nTotH		:= 1
Local lMudouDia	:= .F.
Local _nHr1,_nMi1,nSg1
local _nRs1:=_nRs2:=_nRs3:=0
local _cRes:=''
local Hr,ResHr,Mi,Seg
local cRs4:='' 

cQuery := " SELECT * FROM " + RetSqlName("Z91") + " Z91 "
cQuery += " WHERE Z91_RECURS = '" + cRec + "' "
cQuery += " AND Z91_DATAI = '" + DtoS(dDataI) + "' "
cQuery += " AND Z91.D_E_L_E_T_ <> '*' "

MemoWrite("C:\TEMP\fHPROGMAQ.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "XTMP"
TCSetField( "XTMP", "Z91_DATAI", "D")
TCSetField( "XTMP", "Z91_DATAF", "D")

dbselectArea("XTMP")
dbGoTop("XTMP")

While XTMP->(!EOF())

	If XTMP->Z91_DATAF - XTMP->Z91_DATAI > 0
		lMudouDia	:= .T.
		nTotH	:= TempoLig(XTMP->Z91_HORAF, XTMP->Z91_HORAI, lMudouDia)
	Else
		lMudouDia	:= .F.
		nTotH	:= TempoLig(XTMP->Z91_HORAF, XTMP->Z91_HORAI, lMudouDia)
	EndIf
	
	_nHr1 	:= Val(  Subst(XTMP->Z91_HORAD,1,AT(":",XTMP->Z91_HORAD)-1 )  )*3600     
	_nMi1 	:= Val(  Subst(XTMP->Z91_HORAD,AT(":",XTMP->Z91_HORAD)+1,2)  )*60
	cRs4	:= Subst(XTMP->Z91_HORAD,AT(":",XTMP->Z91_HORAD)+1,len(XTMP->Z91_HORAD))
	_nSg1 	:= Val(  Subst(cRs4,AT(":",cRs4)+1,2 )  ) 

	nTotH	:= nTotH - (_nHr1 + _nMi1 + _nSg1)

	XTMP->(dbSkip())

EndDo

dbCloseArea("XTMP")

Return nTotH

