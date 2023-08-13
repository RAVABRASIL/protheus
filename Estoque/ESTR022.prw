#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ESTR022    � Autor � Gustavo Costa        � Data �06.03.2017���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio NOTAS FISCAIS EXPEDIDAS                            .���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ESTR022()

Local oReport
Local cPerg	:= "ESTR22"
criaSx1(cPerg)
//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������
//Pergunte(cPerg,.T.)

oReport:= ReportDef()
oReport:PrintDialog()


Return

//+-----------------------------------------------------------------------------------------------+
//! Fun��o para cria��o das perguntas (se n�o existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data Base de?'     	  	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data Base at�?'	  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
putSx1(cPerg, '03', 'Estado?'     				, '', '', 'mv_ch3', 'C', 2                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Em branco para todo"},{},{})
putSx1(cPerg, '04', 'Vendedor?'     			, '', '', 'mv_ch4', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Em branco para todo"},{},{})

return  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FISR001  � Autor � Gustavo Costa          � Data �20.09.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio dos valores para conferencia da desonera��o.     .���
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

oReport:= TReport():New("ESTR22","Relat�rio de NF Expedida","ESTR22", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� imprimir o relat�rio de NF Expedida.")
//oReport:SetLandscape()
oReport:SetPortrait()

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������Ŀ
//� Variaveis utilizadas para parametros �
//� mv_par01   // Data de                �
//� mv_par02   // Data At�               �
//� mv_par03   // Estado                 �
//����������������������������������������

Pergunte(oReport:uParam,.T.)

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//��������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Sessao 1                                                     �
//����������������������������������������������������������������

oSection1 := TRSection():New(oReport,"Faturamento UF - PER�ODO de " + DtoC(mv_par01) + " at� " + DtoC(mv_par02),{"TAB"}) 

TRCell():New(oSection1,'EMP'		,'','Emp.'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'TRANSP'		,'','Transportadora',	/*Picture*/		,20				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CODLOJA'	,'','Cod. Loja'		,	/*Picture*/		,08				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CLIENTE'	,'','Cliente'		,	/*Picture*/		,40				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EST'		,'','UF'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CIDADE'		,'','Cidade'		,	/*Picture*/		,25				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NOTA'    	,'','Nota Fiscal'	,/*Picture*/	,09	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EMISSAO'	,'','Emissao'		,/*Picture*/	,10	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EXPED'		,'','Expedicao'		,/*Picture*/	,10	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'VALOR'		,'','Valor'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PESO'		,'','Peso'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'VOLUME'		,'','Volume'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)



//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

oBreak := TRBreak():New(oSection1,oSection1:Cell("EXPED"),"Total",.F.)
oBreak2 := TRBreak():New(oSection1,oSection1:Cell("EMP"),"Total Geral",.F.)
//oBreak := TRBreak():New(oSection1,oSection1:Cell("EST"),"Total",.F.)
//oBreak := TRBreak():New(oSection1,oSection1:Cell("CIDADE"),"Total",.F.)


TRFunction():New(oSection1:Cell("VALOR"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("PESO"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("VOLUME"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)

TRFunction():New(oSection1:Cell("VALOR"),NIL,"SUM",oBreak2,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("PESO"),NIL,"SUM",oBreak2,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("VOLUME"),NIL,"SUM",oBreak2,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALRS"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)


Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �PONR003 � Autor � Gustavo Costa           � Data �20.06.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
//Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
Local lCabec 	:= .T.
Local cChave	:= ""

//***********************************
// Monta a tabela de vendas por NCM
//***********************************


cQuery:="SELECT "
cQuery+="F2_SERIE, "
cQuery+="VOLUME=(CASE WHEN C5_VOLUME1 > 0 THEN C5_VOLUME1 ELSE F2_VOLUME1 END), "
cQuery+="F2_PLIQUI,A1_MUN,A1_EST,F2_DOC, F2_VALBRUT, F2_CLIENTE,A1_NREDUZ,F2_LOJA,A4_NREDUZ,F2_EMISSAO, F2_DTEXP "
cQuery+="FROM ( "
cQuery+="SELECT  "
cQuery+="F2_SERIE,  "

cQuery+="C5_VOLUME1=(SELECT SUM(C5_VOLUME1) FROM SD2020 SD2,SC5020 SC5 "
cQuery+="            WHERE D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA AND D2_PEDIDO=C5_NUM "
cQuery+="            AND SD2.D_E_L_E_T_='' AND SC5.D_E_L_E_T_=''), "

cQuery+="D2_PEDIDO=(SELECT DISTINCT D2_PEDIDO FROM SD2020 SD2 "
cQuery+="             WHERE D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA "
cQuery+="             AND SD2.D_E_L_E_T_='' ), "

cQuery+="F2_VOLUME1,F2_PLIQUI,A1_MUN,A1_EST,F2_DOC, F2_VALBRUT, F2_CLIENTE,A1_NREDUZ,F2_LOJA,A4_NREDUZ,F2_EMISSAO, F2_DTEXP "
//cQuery+="CAST( "+valtosql(ddatabase)+" - CONVERT(datetime,F2_EMISSAO,112)AS FLOAT) DIAS, F2_DTEXP DTEXP "
cQuery+="FROM SF2020 SF2 WITH (NOLOCK),SA1010 SA1 WITH (NOLOCK),SA4010 SA4 WITH (NOLOCK) "
cQuery+="WHERE "
cQuery+="F2_CLIENTE = A1_COD "
cQuery+="and F2_LOJA = A1_LOJA  "
cQuery+="and F2_TRANSP = A4_COD  "
cQuery+="AND F2_DTEXP BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
cQuery+="AND F2_CLIENTE NOT IN ('031732','031733','006543','007005') "
//cQuery+="AND F2_DTEXP='' "
//cQuery+="AND CAST( "+valtosql(ddatabase)+" - CONVERT(datetime,F2_EMISSAO,112)AS FLOAT) >= 1 "

If !Empty(mv_par03)
	cQuery += " AND F2_EST = '" + AllTrim(mv_par03) + "' "
EndIf
/*
If !Empty(mv_par04)
	cQuery += " AND F2_VEND1 = '" + AllTrim(mv_par04) + "' "
EndIf
*/
//cQuery+="AND (F2_SERIE = '0' OR LEN(F2_DOC) = 6) "
cQuery+="AND F2_TIPO='N' "
cQuery+="AND SF2.D_E_L_E_T_!='*' "
cQuery+="AND SA1.D_E_L_E_T_!='*' "
cQuery+="AND SA4.D_E_L_E_T_!='*' "
cQuery+=") AS TABX "
cQuery+="ORDER BY F2_DTEXP DESC  "


If Select("TAB") > 0
	DbSelectArea("TAB")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TAB"
TcSetField( "TAB", "F2_DTEXP", "D", 08, 0 )
TcSetField( "TAB", "F2_EMISSAO", "D", 08, 0 )

TAB->( DbGoTop() )

oReport:SetMeter(TAB->(RecCount()))


//��������������������������������������������������������������Ŀ
//�	Processando a Sessao 1                                       �
//����������������������������������������������������������������

oSection1:Init()
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:Say(oReport:Row(),oReport:Col(),"PER�ODO de " + DtoC(mv_par01) + " at� " + DtoC(mv_par02) )
oSection1:PrintLine()
oReport:SkipLine()
oReport:ThinLine()


While !oReport:Cancel() .And. TAB->(!Eof())

	oReport:IncMeter()

	oSection1:Cell("EMP"):SetValue("01")
	oSection1:Cell("EMP"):SetAlign("CENTER")
	oSection1:Cell("TRANSP"):SetValue(TAB->A4_NREDUZ)
	oSection1:Cell("TRANSP"):SetAlign("LEFT")
	oSection1:Cell("CODLOJA"):SetValue(TAB->F2_CLIENTE+TAB->F2_LOJA)
	oSection1:Cell("CODLOJA"):SetAlign("LEFT")
	oSection1:Cell("CLIENTE"):SetValue(TAB->A1_NREDUZ)
	oSection1:Cell("CLIENTE"):SetAlign("LEFT")
	oSection1:Cell("EST"):SetValue(TAB->A1_EST)
	oSection1:Cell("EST"):SetAlign("CENTER")
	oSection1:Cell("CIDADE"):SetValue(TAB->A1_MUN)
	oSection1:Cell("CIDADE"):SetAlign("LEFT")
	oSection1:Cell("NOTA"):SetValue(TAB->F2_DOC)
	oSection1:Cell("NOTA"):SetAlign("CENTER")
	oSection1:Cell("EMISSAO"):SetValue(TAB->F2_EMISSAO)
	oSection1:Cell("EMISSAO"):SetAlign("CENTER")
	oSection1:Cell("EXPED"):SetValue(TAB->F2_DTEXP)
	oSection1:Cell("EXPED"):SetAlign("CENTER")
	oSection1:Cell("VALOR"):SetValue(TAB->F2_VALBRUT)
	oSection1:Cell("VALOR"):SetAlign("RIGHT")
	oSection1:Cell("PESO"):SetValue(TAB->F2_PLIQUI)
	oSection1:Cell("PESO"):SetAlign("RIGHT")
	oSection1:Cell("VOLUME"):SetValue(TAB->VOLUME)
	oSection1:Cell("VOLUME"):SetAlign("RIGHT")
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TAB->(dbSkip())
	
EndDo

oSection1:Finish()

dbCloseArea("TAB")

Set Filter To

Return




