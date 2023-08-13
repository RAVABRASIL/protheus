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
���Programa  �FATR048    � Autor � Gustavo Costa        � Data �06.03.2017���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio FATURAMENTO POR ESTADO                             .���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATR049()

Local oReport
Local cPerg	:= "FATR49"
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

oReport:= TReport():New("FATR49","Relat�rio de Faturamento por Estado","FATR49", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� imprimir o relat�rio de Faturamento por Estado.")
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

TRCell():New(oSection1,'REP'		,'','Cod.'			,	/*Picture*/		,04				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NREP'		,'','Representante'	,	/*Picture*/		,20				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EST'		,'','UF'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CIDADE'		,'','Cidade'		,	/*Picture*/		,25				,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2 := TRSection():New(oSection1,"Notas Fiscais",{"TAB"})
oSection2:SetLeftMargin(2)

TRCell():New(oSection2,'NOTA'    	,'','Nota Fiscal'	,/*Picture*/	,09	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'EMISSAO'	,'','Emissao'		,/*Picture*/	,10	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PROD'		,'','Produto'		,/*Picture*/	,15	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'DESC'		,'','Descricao'		,/*Picture*/	,50	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'QUANT'		,'','Quant.'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'VALOR'		,'','Valor'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'TOTAL'		,'','Total'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)



//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

oBreak := TRBreak():New(oSection1,oSection1:Cell("REP"),"Total",.F.)
oBreak := TRBreak():New(oSection1,oSection1:Cell("EST"),"Total",.F.)
oBreak := TRBreak():New(oSection1,oSection1:Cell("CIDADE"),"Total",.F.)


TRFunction():New(oSection2:Cell("QUANT"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection2:Cell("TOTAL"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("METARS"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALKG"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALPV"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
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
Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
Local lCabec 	:= .T.
Local cChave	:= ""

//***********************************
// Monta a tabela de vendas por NCM
//***********************************

cQuery := " SELECT D2_EST, A1_MUN, F2_VEND1, D2_DOC, D2_EMISSAO, D2_COD, B1_DESC, D2_QUANT, D2_PRCVEN, D2_TOTAL "
cQuery += " FROM " + RetSqlName("SD2") + " D2 "
cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1 "
cQuery += " ON D2_CLIENTE = A1_COD "
cQuery += " AND D2_LOJA = A1_LOJA "
cQuery += " INNER JOIN " + RetSqlName("SF2") + " F2 "
cQuery += " ON D2_FILIAL = F2_FILIAL "
cQuery += " AND D2_DOC = F2_DOC "
cQuery += " AND D2_SERIE = F2_SERIE "
cQuery += " INNER JOIN " + RetSqlName("SB1") + " B1 "
cQuery += " ON D2_COD = B1_COD "
cQuery += " WHERE D2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
cQuery += " AND D2_TIPO = 'N' " 
cQuery += " AND RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118','5401','6401' ) " 
cQuery += " AND D2.D_E_L_E_T_ = '' "
cQuery += " AND F2_DUPL <> ' ' " 
cQuery += " AND F2.D_E_L_E_T_ = '' " 
If !Empty(mv_par03)
	cQuery += " AND D2_EST = '" + AllTrim(mv_par03) + "' "
EndIf
If !Empty(mv_par04)
	cQuery += " AND F2_VEND1 = '" + AllTrim(mv_par04) + "' "
EndIf
cQuery += " ORDER BY F2_VEND1, D2_EST, A1_MUN, D2_DOC, D2_ITEM "


If Select("TAB") > 0
	DbSelectArea("TAB")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TAB"
TcSetField( "TAB", "D2_EMISSAO", "D", 08, 0 )

TAB->( DbGoTop() )

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
	cChave	:= TAB->F2_VEND1 + TAB->D2_EST + TAB->A1_MUN
	
	If lCabec

		oSection1:Cell("REP"):SetValue(TAB->F2_VEND1)
		oSection1:Cell("REP"):SetAlign("LEFT")
		oSection1:Cell("NREP"):SetValue(POSICIONE("SA3",1,xFilial("SA3") + TAB->F2_VEND1, "A3_NREDUZ"))
		oSection1:Cell("NREP"):SetAlign("LEFT")
		oSection1:Cell("EST"):SetValue(TAB->D2_EST)
		oSection1:Cell("EST"):SetAlign("CENTER")
		oSection1:Cell("CIDADE"):SetValue(TAB->A1_MUN)
		oSection1:Cell("CIDADE"):SetAlign("LEFT")
		oSection1:PrintLine()

		//oSection1:Finish()
			
		oSection2:Init()
		lCabec	:= .F.

	EndIf

	oSection2:Cell("NOTA"):SetValue(TAB->D2_DOC)
	oSection2:Cell("NOTA"):SetAlign("CENTER")
	oSection2:Cell("EMISSAO"):SetValue(TAB->D2_EMISSAO)
	oSection2:Cell("EMISSAO"):SetAlign("CENTER")
	oSection2:Cell("PROD"):SetValue(TAB->D2_COD)
	oSection2:Cell("PROD"):SetAlign("CENTER")
	oSection2:Cell("DESC"):SetValue(TAB->B1_DESC)
	oSection2:Cell("DESC"):SetAlign("LEFT")
	oSection2:Cell("QUANT"):SetValue(TAB->D2_QUANT)
	oSection2:Cell("QUANT"):SetAlign("RIGHT")
	oSection2:Cell("VALOR"):SetValue(TAB->D2_PRCVEN)
	oSection2:Cell("VALOR"):SetAlign("RIGHT")
	oSection2:Cell("TOTAL"):SetValue(TAB->D2_TOTAL)
	oSection2:Cell("TOTAL"):SetAlign("RIGHT")
	
	oSection2:PrintLine()
	//oReport:SkipLine()     
	TAB->(dbSkip())
	
	If cChave <> TAB->F2_VEND1 + TAB->D2_EST + TAB->A1_MUN
	
		oSection1:Finish()
		oSection2:Finish()
		lCabec := .T.
		oSection1:Init()
		
	EndIf
EndDo

oSection1:Finish()

dbCloseArea("TAB")

Set Filter To

Return




