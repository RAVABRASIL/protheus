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
±±³Programa  ³CTBR001  ³ Autor ³ Gustavo Costa          ³ Data ³20.05.2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o   ³Relatorio para gerar a DR atraves de uma visao gerencial.  .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CTBR001()

Local oReport
Local cPerg	:= "CTBR01"

Private lJob		:= .F.
Private aMeses	:= {}
Private aMesesAnt	:= {}
PRIVATE aCampos	:= {}
Private cNomeArq	
Private cIndex1
Private cIndex2

//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//Não consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SX1" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Relatorio horas improdutivas das maquinas... '+Dtoc(DATE())+' - '+Time())
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
		Pergunte(cPerg, .T.)
		
		oReport:= ReportDef()
		oReport:PrintDialog()
	EndIf

	If	( lJob )
		RpcClearEnv()		   				//Libera o Environment
		ConOut('Relatorio horas improdutivas das maquinas Concluído. '+Dtoc(DATE())+' - '+Time())
	EndIf


Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Visao Ger.?'     	, '', '', 'mv_ch1', 'C', 3                     	, 0, 0, 'G', '', 'CTS', '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Selecione a Visal Gerencial"},{},{})
putSx1(cPerg, '02', 'Data de?'  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '03', 'Data até?'  		, '', '', 'mv_ch3', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Data final"},{},{})
putSx1(cPerg, '04', 'Valores?'     	, '', '', 'mv_ch4', 'N', 1                     	, 0, 0, 'C', '', ''	 , '', '', 'mv_par04','Nao se Aplica','','','','Divide p/ 1.000','','','','','','','','','','','',{"Escolha uma opcao"},{},{})
putSx1(cPerg, '05', 'Compara Ano Ant?'	, '', '', 'mv_ch5', 'N', 1    						, 0, 0, 'C', '', ''   , '', '', 'mv_par05','Sim','Si','Yes','','Nao','No','No','','','','','','','','','',{"Compara com o ano anterior"},{},{})

return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CTBR001  ³ Autor ³ Gustavo Costa          ³ Data ³14.04.2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio visao gerencial DR.                                .³±±
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

oReport:= TReport():New("CTBR01","DR Retrospec.","CTBR01", {|oReport| ReportPrint(oReport)},"Este relatório irá listar as informações da visão gerencial selecionada.")
oReport:SetLandscape()
//oReport:SetPortrait()

If lJob
	oReport:nDevice	 	:= 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
	oReport:cEmail		:= 'gustavo@ravaembalagens.com.br' //GetNewPar("MV_XPCPR34",'marcelo@ravaembalagens.com.br;orley@ravaembalagens.com.br;mario.aguiar@ravaembalagens.com.br;gustavo@ravaembalagens.com.br')
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

TRCell():New(oSection1,'CONTA'				,'','Conta'		,	/*Picture*/				,40				,/*lPixel*/,/*{|| code-block de impressao }*/)
aADD(aCampos,{"_CONTA"	 			,"C",15,0})
aADD(aCampos,{"_ORDEM"	 			,"C",15,0})
aADD(aCampos,{"_DESCRI"	 			,"C",40,0})

dDataIni	:= FirstDay(mv_par02) 
nMesIni	:= Month(dDataIni)

While dDataIni < mv_par03
	
	AADD(aMeses	, SubStr(DtoC(dDataIni),4,2) + SubStr(DtoC(dDataIni),7,4))
	AADD(aMesesAnt, SubStr(DtoC(dDataIni),4,2) + SubStr(DtoC(dDataIni - 365),7,4))

	dDataIni := FirstDay(dDataIni + 35)
	
EndDo

For n := 1 to Len(aMeses)

	//Divide por 1.000
	IF mv_par04 = 2
		TRCell():New(oSection1,'MES' + aMeses[n]			,'',SubStr(aMeses[n],1,2) + '/'	 + SubStr(aMeses[n],3,4)			,  ,09	,/*lPixel*/,/*{|| code-block de impressao }*/)
	Else
		TRCell():New(oSection1,'MES' + aMeses[n]			,'',SubStr(aMeses[n],1,2) + '/'	 + SubStr(aMeses[n],3,4)			, "@E 999,999,999.99" ,16	,/*lPixel*/,/*{|| code-block de impressao }*/)
	EndIf
	aADD(aCampos,{"_M" + aMeses[n]		,"N",16,2})
	
	If mv_par05 = 1 //Compara ano anterior

		TRCell():New(oSection1,'AV' + aMeses[n]			,'','a.v.', "@E 999.99",7	,/*lPixel*/,/*{|| code-block de impressao }*/)
		aADD(aCampos,{"_AV" + aMeses[n]		,"N",12,2})

		IF mv_par04 = 2
			TRCell():New(oSection1,'MESANT'	+ aMesesAnt[n]	,'',SubStr(aMesesAnt[n],1,2) + '/'	 + SubStr(aMesesAnt[n],3,4)	,  ,9	,/*lPixel*/,/*{|| code-block de impressao }*/)
		Else
			TRCell():New(oSection1,'MESANT'	+ aMesesAnt[n]	,'',SubStr(aMesesAnt[n],1,2) + '/'	 + SubStr(aMesesAnt[n],3,4)	, "@E 999,999,999.99" ,16	,/*lPixel*/,/*{|| code-block de impressao }*/)
		EndIf
		aADD(aCampos,{"_MA" + aMesesAnt[n]		,"N",16,2})

		TRCell():New(oSection1,'AVANT'	+ aMesesAnt[n]	,'','a.v.'	, "@E 999.99" ,7	,/*lPixel*/,/*{|| code-block de impressao }*/)
		TRCell():New(oSection1,'AH' + aMeses[n]			,'','a.h.', "@E 999.99",7	,/*lPixel*/,/*{|| code-block de impressao }*/)
		aADD(aCampos,{"_AT" + aMeses[n]		,"N",12,2})
		aADD(aCampos,{"_AH" + aMeses[n]		,"N",12,2})

	EndIf
	
Next

cNomeArq := CriaTrab(aCampos,.T.)
dbUseArea( .T.,, cNomeArq, "XTA", if(.F. .OR. .F., !.F., NIL), .F. )
cIndex1 	:= CriaTrab(NIL,.F.)
IndRegua("XTA",cIndex1,"_CONTA",,,OemToAnsi("Selecionando Registros..."))  //
//cIndex2 	:= CriaTrab(NIL,.F.)
//IndRegua("XTA",cIndex2,"_ORDEM",,,OemToAnsi("Selecionando Registros..."))  //


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
Local cCampoMes	:= ""
Local cCampoMesAnt	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//oReport:Say(oReport:Row(),oReport:Col(),"PERÍODO de " + DtoC(mv_par01) + " até " + DtoC(mv_par02) )
oReport:SkipLine()
oReport:ThinLine()
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"DEMONSTRAÇÃO DE RESULTADO")
oReport:SkipLine()
//oReport:Say(oReport:Row(),oReport:Col(),"% Disp. 			- O percentual de indisponibilidade do dia.")
//oReport:SkipLine()
//oReport:SkipLine()
oReport:ThinLine()

cQuery := " SELECT CTS_CODPLA, CTS_ORDEM, CTS_CONTAG, CTS_DESCCG+CTS_DETHCG DESCRI, CTS_COLUNA, CTS_NOME, CTS_CT1INI, CTS_CT1FIM, CTS_FORMUL "
cQuery += " FROM " + RetSqlName("CTS") + " CTS "
cQuery += " WHERE D_E_L_E_T_<> '*' "
cQuery += " AND CTS_CODPLA = '" + mv_par01 + "'"
cQuery += " ORDER BY CTS_ORDEM "

If Select("XTS") > 0
	DbSelectArea("XTS")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "XTS"

nCount	:= XTS->(RECCOUNT())
XTS->( DbGoTop() )
		
oReport:SetMeter(nCount)

oSection1:Init()

While !oReport:Cancel() .And. XTS->(!EOF())

	RecLock("XTA", .T.)
	
	XTA->_DESCRI	:= XTS->DESCRI
	XTA->_ORDEM	:= XTS->CTS_ORDEM
	
	Do Case
		Case "LUCRO" $ XTS->DESCRI
			XTA->_CONTA	:= "LUCRO"
		Case "EBITDA" $ XTS->DESCRI
			XTA->_CONTA	:= "EBITDA"
		Case "NOPAT" $ XTS->DESCRI
			XTA->_CONTA	:= "NOPAT"
		OtherWise
			XTA->_CONTA	:= XTS->CTS_CT1INI
	EndCase
	
	For _i := 1 To len(aMeses)
	
		dData		:= CtoD("01" + "/" + SubStr(aMeses[_i],1,2) + '/' + SubStr(aMeses[_i],3,4))
		nSaldo		:= fSldContaS(XTS->CTS_CT1INI, XTS->CTS_CT1FIM, dData, LastDay(dData))
		
		cCampoMes	:= 'XTA->_M' + Alltrim(aMeses[_i])

		If mv_par04 = 2 //Divide por 1.000

			Do Case
				Case "LUCRO" $ XTS->CTS_FORMUL
					&cCampoMes		:=	INT(Round(fLouP(cCampoMes)/1000,0))
				Case "EBITDA" $ XTS->CTS_FORMUL
					&cCampoMes		:=	INT(Round(fEBITDA(cCampoMes)/1000,0))
				OtherWise
					&cCampoMes		:=	INT(Round(nSaldo/1000,0))
			EndCase
			
		Else

			Do Case
				Case "LUCRO" $ XTS->CTS_FORMUL
					&cCampoMes		:=	fLouP(cCampoMes)
				Case "EBITDA" $ XTS->CTS_FORMUL
					&cCampoMes		:=	fEBITDA(cCampoMes)
				OtherWise
					&cCampoMes		:=	nSaldo
			EndCase

		EndIf

		If mv_par05 = 1 //Compara ano anterior
			dDataAnt	:= CtoD("01" + "/" + SubStr(aMesesAnt[_i],1,2) + '/' + SubStr(aMesesAnt[_i],3,4))
			nSaldoAnt	:= fSldContaS(XTS->CTS_CT1INI, XTS->CTS_CT1FIM, dDataAnt, LastDay(dDataAnt)) 

			cCampoMesAnt	:= 'XTA->_MA' + Alltrim(aMesesAnt[_i])
	
			If mv_par04 = 2 //Divide por 1.000
				
				Do Case
					Case "LUCRO" $ XTS->CTS_FORMUL
						&cCampoMesAnt		:=	INT(Round(fLouP(cCampoMesAnt)/1000,0))
					Case "EBITDA" $ XTS->CTS_FORMUL
						&cCampoMesAnt		:=	INT(Round(fEBITDA(cCampoMesAnt)/1000,0))
					OtherWise
						&cCampoMesAnt		:= INT(Round(nSaldoAnt/1000,0))
				EndCase
				
			Else
			
				Do Case
					Case "LUCRO" $ XTS->CTS_FORMUL
						&cCampoMesAnt		:=	fLouP(cCampoMesAnt)
					Case "EBITDA" $ XTS->CTS_FORMUL
						&cCampoMesAnt		:=	fEBITDA(cCampoMesAnt)
					OtherWise
						&cCampoMesAnt		:= nSaldoAnt
				EndCase
				
			EndIf

		EndIf
		
	Next
	
	XTA->(MsUnLock())
	XTS->(dbSkip())
	
EndDo

DbSelectArea("XTA")
cIndex2 	:= CriaTrab(NIL,.F.)
IndRegua("XTA",cIndex2,"_ORDEM",,,)  //
//nIndex := RetIndex("XTA")
XTA->(dbSetOrder(1))
XTA->(dbGoTop())

While !oReport:Cancel() .And. XTA->(!EOF())

	oSection1:Cell("CONTA"):SetValue(XTA->_DESCRI)
	oSection1:Cell("CONTA"):SetAlign("LEFT")
	
	For _i := 1 To len(aMeses)
	
		cCampoMes	:= 'XTA->_M' + Alltrim(aMeses[_i])

		oSection1:Cell('MES' + aMeses[_i]):SetValue(&cCampoMes)
		oSection1:Cell('MES' + aMeses[_i]):SetAlign("RIGHT")

		cCampoMesAnt	:= 'XTA->_MA' + Alltrim(aMesesAnt[_i])
		
		oSection1:Cell('MESANT'	+ aMesesAnt[_i]):SetValue(&cCampoMesAnt)
		oSection1:Cell('MESANT'	+ aMesesAnt[_i]):SetAlign("RIGHT")

		
	Next
	
	oSection1:PrintLine()

	XTA->(dbSkip())
	
EndDo

oSection1:Finish()
dbCloseArea("XTS")
dbCloseArea("XTA")
//fErase(cNomeArq)
fErase( cIndex1 + OrdBagExt() )
fErase( cIndex2 + OrdBagExt() )
Set Filter To

Return

//------------------------------------------------------------------------------------------
/*
Pegas os lancamentos a debito e credito de uma conta.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
Static Function fSldConta(cConta, dDataI, dDataF)

local nSaldo	:= 0

cQuery := " SELECT " 
cQuery += " SUM(CASE WHEN CT2_DEBITO = '" + cConta + "' THEN CT2_VALOR ELSE 0 END) DEBITO, "
cQuery += " SUM(CASE WHEN CT2_CREDIT = '" + cConta + "' THEN CT2_VALOR ELSE 0 END) CREDITO
cQuery += " FROM  " + RetSqlName("CT2") + " CT2 "
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND CT2_FILIAL = '" + xFilial("CT2") + "' "
cQuery += " AND CT2_DATA BETWEEN  '" + DtoS(dDataI) + "' AND  '" + DtoS(dDataF) + "' "
cQuery += " AND ( CT2_DEBITO = '" + cConta + "' OR CT2_CREDIT = '" + cConta + "' ) "

MemoWrite("C:\TEMP\fSLDConta.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "XTMP"

dbselectArea("XTMP")
dbGoTop("XTMP")

IF XTMP->(!EOF())

	nSaldo	:= XTMP->DEBITO - XTMP->CREDITO 

EndIf

dbCloseArea("XTMP")

Return nSaldo


//------------------------------------------------------------------------------------------
/*
Pegas os lancamentos a debito e credito de uma conta sintetica.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
Static Function fSldContaS(cConta, cContaF, dDataI, dDataF)

local nSaldo		:= 0
local nSaldoD		:= 0
local nSaldoC		:= 0
Local cClasse		:= ""

cQuery := " SELECT " 
cQuery += " SUM(CT2_VALOR) DEBITO "
cQuery += " FROM  " + RetSqlName("CT2") + " CT2 "
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND CT2_FILIAL = '" + xFilial("CT2") + "' "
cQuery += " AND CT2_DATA BETWEEN  '" + DtoS(dDataI) + "' AND  '" + DtoS(dDataF) + "' "
cQuery += " AND CT2_DEBITO BETWEEN '" + cConta + "' AND '" + Alltrim(cContaF) + "99999999999999' "

MemoWrite("C:\TEMP\fSLDContaD.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "XTMP"

dbselectArea("XTMP")
dbGoTop("XTMP")

IF XTMP->(!EOF())

	nSaldoD	:= XTMP->DEBITO

EndIf

dbCloseArea("XTMP")

cQuery := " SELECT " 
cQuery += " SUM(CT2_VALOR) CREDITO "
cQuery += " FROM  " + RetSqlName("CT2") + " CT2 "
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND CT2_FILIAL = '" + xFilial("CT2") + "' "
cQuery += " AND CT2_DATA BETWEEN '" + DtoS(dDataI) + "' AND  '" + DtoS(dDataF) + "' "
cQuery += " AND CT2_CREDIT BETWEEN '" + cConta + "' AND '" + Alltrim(cContaF) + "99999999999999' "

MemoWrite("C:\TEMP\fSLDContaC.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "XTMP"

dbselectArea("XTMP")
dbGoTop("XTMP")

IF XTMP->(!EOF())

	nSaldoC	:= XTMP->CREDITO

EndIf

dbCloseArea("XTMP")

nSaldo	:= nSaldoC - nSaldoD

Return nSaldo

//------------------------------------------------------------------------------------------
/*
Calcula o Lucro ou Prejuizo.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
Static Function fLouP(cCampo)

local nSaldo	:= 0
Local aArea	:= GetArea('XTA')

XTA->(dbSetOrder(1))

// Resultado Operacional Bruto
If XTA->(dbSeek('311'))

	nSaldo	+= &cCampo

EndIf

// Resultado Nao Operacional
If XTA->(dbSeek('X'))

	nSaldo	+= &cCampo

EndIf

// Resultado Financeiro
If XTA->(dbSeek('31203'))

	nSaldo	+= &cCampo

EndIf

// Despesas Operacionais
If XTA->(dbSeek('312'))

	nSaldo	+= &cCampo

EndIf

// IRPJ
If XTA->(dbSeek('321010101'))

	nSaldo	+= &cCampo

EndIf

// CSLL
If XTA->(dbSeek('321010102'))

	nSaldo	+= &cCampo

EndIf

RestArea(aArea)

XTA->(dbSeek('LUCRO'))

Return nSaldo


//------------------------------------------------------------------------------------------
/*
Calcula o EBITDA.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
Static Function fEBITDA(cCampo)

local nSaldo	:= 0
Local aArea	:= GetArea('XTA')

XTA->(dbSetOrder(1))

// Lucro ou Prejuizo
If XTA->(dbSeek('LUCRO'))

	nSaldo	+= &cCampo

EndIf

// Depreciacao
If XTA->(dbSeek('312020616'))

	nSaldo	+= &cCampo

EndIf

// Despesas Financeiras
If XTA->(dbSeek('3120301'))

	nSaldo	+= &cCampo

EndIf

// Descontos Concedidos
If XTA->(dbSeek('312030110'))

	nSaldo	+= &cCampo

EndIf

// Tarifas e Taxas
If XTA->(dbSeek('312030108'))

	nSaldo	+= &cCampo

EndIf

// IOF
If XTA->(dbSeek('312030112'))

	nSaldo	+= &cCampo

EndIf

RestArea(aArea)
XTA->(dbSeek('EBITDA'))

Return nSaldo
