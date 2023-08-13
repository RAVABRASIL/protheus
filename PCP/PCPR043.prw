#INCLUDE "rwmake.ch"
#Include 'Topconn.ch'
#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PCPR043  � Autor � Gustavo Costa.     � Data �  27/11/14   ���
�������������������������������������������������������������������������͹��
���Descricao � OEE das Extrusoras.                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � COMPRAS / PCP                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PCPR043()

//--< vari�veis >---------------------------------------------------------------------------
Local oReport
Local cPerg	:= 'PCPR43'

Private lJob		:= .F.

//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//N�o consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SX1" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Relatorio OEE das Extrusoras... '+Dtoc(DATE())+' - '+Time())
		lJob := .T.
	EndIf

	If	lJob
		oReport:= ReportDef()
		oReport:Print(.F.)
	Else
		criaSx1(cPerg)
		//������������������������������������������������������������������������Ŀ
		//�Interface de impressao                                                  �
		//��������������������������������������������������������������������������
		
		oReport:= ReportDef()
		oReport:PrintDialog()
	EndIf

	If	( lJob )
		RpcClearEnv()		   				//Libera o Environment
		ConOut('Relatorio OEE das Extrusoras Conclu�do. '+Dtoc(DATE())+' - '+Time())
	EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FINR013  � Autor � Gustavo Costa          � Data �23.05.2014���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio retorno da cobran�a.                               .���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2

PRIVATE cTURNO1   := GetMv( "MV_TURNO1" ) 
PRIVATE cTURNO2   := GetMv( "MV_TURNO2" )
PRIVATE cTURNO3   := GetMv( "MV_TURNO3" )

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������

oReport:= TReport():New("PCPR43","OEE das Extrusoras","PCPR43", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� demonstrar o OEE das Extrusoras.")

//oReport:SetLandscape()
oReport:SetTotalInLine(.T.)
oReport:PageTotalInLine(.T.)
oReport:SetPortrait()

If lJob
	oReport:nDevice	 	:= 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
	oReport:cEmail		:= GetNewPar("MV_XPCPR44",'marcelo@ravaembalagens.com.br;giancarlo.sousa@ravaembalagens.com.br;gustavo@ravaembalagens.com.br')
EndIf


//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������Ŀ
//� Variaveis utilizadas para parametros �
//� mv_par01   // Data de                �
//� mv_par02   // Data At�               �
//� mv_par03   // Vendedor               �
//����������������������������������������

Pergunte(oReport:uParam,.F.)


//��������������������������������������������������������������Ŀ
//� Sessao 1                                                     �
//����������������������������������������������������������������

oSection1 := TRSection():New(oReport,"Recurso",{"ZC2"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/,/*uTotalText*/,.T.) 
//oParent,cTitle,uTable,aOrder,lLoadCells,lLoadOrder,uTotalText,lTotalInLine,lHeaderPage,lHeaderBreak,lPageBreak,lLineBreak,nLeftMargin,lLineStyle,nColSpace,lAutoSize,cCharSeparator,nLinesBefore,nCols,nClrBack,nClrFore,nPercentage

TRCell():New(oSection1,'ZC2_REC'	,'','Extrusora'	,/*Picture*/		,06		,/*lPixel*/,/*{|| code-block de impressao }*/)


oSection2 := TRSection():New(oSection1,"Data",{"ZC2"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/,/*uTotalText*/,.T.) 
oSection2:SetLeftMargin(2)

TRCell():New(oSection2,'ZC2_DATA'	,'','Data'			,/*Picture*/		,10		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'ZC2_DISP'	,'','Disp. %'		,"@E 99,999.99"	,09		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'ZC2_HP'		,'','H. Prod.'	,/*Picture*/		,05		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PRODMIN'	,'','Prod. Min.'	,"@E 9,999,999.99",12		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PRODMAX'	,'','Prod. Max.'	,"@E 9,999,999.99",12		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'REAL'		,'','Realizado'	,"@E 9,999,999.99",12		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PERFT'		,'','Perf. Total %'	,"@E 99,999.99"	,09		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PERFB'		,'','Perf. Bom %'	,"@E 99,999.99"	,09		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PERFR'		,'','Perf. Ruim %',"@E 99,999.99"	,09		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'OEE'		,'','OEE %'		,"@E 99,999.99"	,09		,/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oSection2:Cell("REAL"),NIL,"SUM",/*oBreak*/,"Total",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
TRFunction():New(oSection2:Cell("PERFT"),NIL,"AVG",/*oBreak*/,"Total",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
TRFunction():New(oSection2:Cell("PERFB"),NIL,"AVG",/*oBreak*/,"Total",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
TRFunction():New(oSection2:Cell("PERFR"),NIL,"AVG",/*oBreak*/,"Total",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
TRFunction():New(oSection2:Cell("OEE"),NIL,"AVG",/*oBreak*/,"Total",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)

oBreak := TRBreak():New(oSection1,oSection1:Cell("ZC2_REC"),"Total	:",.F.)

oReport:EndReport() := .T.

Return(oReport)


Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
Local nProdMin	:= 0
Local nProdMax	:= 0
Local nHorasProd 	:= 0
Local aProd		:= {}
Local cRecAnt		:= ""
Local d1			:= IIF(lJob,FirstDay(dDataBase),mv_par01)
Local d2			:= IIF(lJob,dDataBase,mv_par02)
Local cRec1		:= IIF(lJob,"",mv_par03)
Local cRec2		:= IIF(lJob,"ZZZZZZ",mv_par04)

//��������������������������������������������������������������Ŀ
//�	Processando a Sessao 1                                       �
//����������������������������������������������������������������

cQuery := " SELECT * FROM " + RetSqlName("ZC2") + " ZC2 "
cQuery += " WHERE ZC2_FILIAL =  '" + xFilial("ZC2") + "'"
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " AND ZC2_REC BETWEEN '" + cRec1 + "' AND '" + cRec2 + "' "
cQuery += " AND ZC2_DATA BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "' "
cQuery += " ORDER BY ZC2_REC, ZC2_DATA "

MemoWrite("C:\TEMP\fPrtZC2.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( "TMP", "ZC2_DATA", "D")

dbselectArea("TMP")
nCount	:= TMP->(RECCOUNT())
TMP->( DbGoTop() )
		
oReport:SetMeter(nCount)


While !oReport:Cancel() .And. TMP->(!EOF())

	If cRecAnt <> TMP->ZC2_REC
	
		oSection1:Init()
		oSection1:Cell("ZC2_REC"):SetValue(TMP->ZC2_REC)
		oSection1:Cell("ZC2_REC"):SetAlign("CENTER")
	
		oSection1:PrintLine()
		oSection1:Finish()
		oSection2:Init()
	
	EndIf
	
	oSection2:Cell("ZC2_DATA"):SetValue(DtoC(TMP->ZC2_DATA))
	oSection2:Cell("ZC2_DATA"):SetAlign("LEFT")
	oSection2:Cell("ZC2_DISP"):SetValue(TMP->ZC2_DISPON)
	oSection2:Cell("ZC2_DISP"):SetAlign("CENTER")
	oSection2:Cell("ZC2_HP"):SetValue(TMP->ZC2_HP)
	oSection2:Cell("ZC2_HP"):SetAlign("RIGHT")
	
	nHorasProd := Val(subStr(TMP->ZC2_HP,1,2)) + (Val(subStr(TMP->ZC2_HP,4,2)) / 60)
	
	Do case
		
		Case AllTrim(TMP->ZC2_REC) == "E01"
		
			nProdMax	:=  nHorasProd * 173
			nProdMin	:=  nHorasProd * 150

		Case AllTrim(TMP->ZC2_REC) == "E02"
		
			nProdMax	:=  nHorasProd * 153
			nProdMin	:=  nHorasProd * 130

		Case AllTrim(TMP->ZC2_REC) == "E03"
		
			nProdMax	:=  nHorasProd * 135
			nProdMin	:=  nHorasProd * 115

		Case AllTrim(TMP->ZC2_REC) $ "E04"
		
			nProdMax	:=  nHorasProd * 115
			nProdMin	:=  nHorasProd * 70
		
		Case AllTrim(TMP->ZC2_REC) $ "E05"
		
			nProdMax	:=  nHorasProd * 96
			nProdMin	:=  nHorasProd * 60
		
	EndCase
	
	aProd	:= fProdExtr(TMP->ZC2_REC, TMP->ZC2_DATA)
	
	oSection2:Cell("PRODMIN"):SetValue(nProdMin)
	oSection2:Cell("PRODMIN"):SetAlign("RIGHT")
	oSection2:Cell("PRODMAX"):SetValue(nProdMax)
	oSection2:Cell("PRODMAX"):SetAlign("RIGHT")
	
	oSection2:Cell("REAL"):SetValue(aProd[1] + aProd[2])
	oSection2:Cell("REAL"):SetAlign("RIGHT")
	oSection2:Cell("PERFB"):SetValue((aProd[1] / (aProd[1] + aProd[2])) * 100)
	oSection2:Cell("PERFB"):SetAlign("RIGHT")
	oSection2:Cell("PERFR"):SetValue((aProd[2] / (aProd[1] + aProd[2])) * 100)
	oSection2:Cell("PERFR"):SetAlign("RIGHT")
	oSection2:Cell("PERFT"):SetValue(((aProd[1] + aProd[2]) / nProdMin) * 100)
	oSection2:Cell("PERFT"):SetAlign("RIGHT")
	oSection2:Cell("OEE"):SetValue((TMP->ZC2_DISPON) * (((aProd[1] + aProd[2]) / nProdMin)) * ((aProd[1] / (aProd[1] + aProd[2]))))
	oSection2:Cell("OEE"):SetAlign("RIGHT")
	
	oSection2:PrintLine()
	
	cRecAnt := TMP->ZC2_REC
	TMP->(dbSkip())
	
	If cRecAnt <> TMP->ZC2_REC
	
		oSection2:Finish()
	
	EndIf

EndDo

oSection1:Finish()

Return


//+-----------------------------------------------------------------------------------------------+
//! Fun��o para cria��o das perguntas (se n�o existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data de?'     	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data at�?'  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
putSx1(cPerg, '03', 'Do Recurso?'     	, '', '', 'mv_ch3', 'C', 9                     	, 0, 0, 'G', '', 'SH1', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Recurso inicial"},{},{})
putSx1(cPerg, '04', 'At� Recurso?'    	, '', '', 'mv_ch4', 'C', 9                     	, 0, 0, 'G', '', 'SH1', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Recurso final"},{},{})

return  

//------------------------------------------------------------------------------------------
/*
Valida a data final digitada.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C�digo
@version   1.xx
@since     27/03/2014
/*/
//------------------------------------------------------------------------------------------
Static Function fProdExtr(cRec, dData)

Local aRet		:= {}

cQuery := " SELECT SUM( CASE WHEN Z00_APARA = '' THEN Z00_PESO ELSE 0 END ) AS PROD , "
cQuery += "  SUM( CASE WHEN Z00_APARA <> '' THEN Z00_PESO ELSE 0 END ) AS APARA "
cQuery += " FROM " + RetSqlName("Z00") + " Z00 "
cQuery += " WHERE Z00_DATA+Z00_HORA BETWEEN '" + DtoS(dData) + cTURNO1 + "' AND '" + DtoS(dData+1) + cTURNO1 + "'
cQuery += " AND Z00_MAQ = '" + cRec + "' "
cQuery += " AND D_E_L_E_T_ <> '*' "


MemoWrite("C:\TEMP\fProdExtr.SQL", cQuery )
TCQUERY cQuery NEW ALIAS "XTMP"

dbselectArea("XTMP")
dbGoTop("XTMP")

If XTMP->(!EOF())

	AADD(aRet, XTMP->PROD )
	AADD(aRet, XTMP->APARA )
	
Else

	AADD(aRet, 0 )
	AADD(aRet, 0 )

EndIf

dbCloseArea("XTMP")

Return aRet


//--< fim de arquivo >----------------------------------------------------------------------
