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

User Function XFISR001()

Local oReport
Local cPerg	:= "FISR01"
criaSx1(cPerg)
//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������

oReport:= ReportDef()
oReport:PrintDialog()


Return

//+-----------------------------------------------------------------------------------------------+
//! Fun��o para cria��o das perguntas (se n�o existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data Base de?'       , '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data Base at�?'  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
putSx1(cPerg, '03', 'Filial?'        		, '', '', 'mv_ch3', 'C', 2                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Escolha a filial"},{},{})

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
Local oSection3

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

oReport:= TReport():New("FISR01","Confer�ncia Desonera��o Folha","FISR01", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� imprimir o demonstrativo de confer�ncia da desonera��o da folha.")
//oReport:SetLandscape()
oReport:SetPortrait()

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

oSection1 := TRSection():New(oReport,"NCM",{"TAB"}) 

TRCell():New(oSection1,'FILIAL'		,'','Filial'		,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NCM'		,'','NCM'			,	/*Picture*/		,10				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'TOTAL'    	,'','Total'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'IPI'		,'','IPI'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'BRUTO'		,'','Bruto'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DEV'		,'','Devolu��o'	,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'IPIDEV'		,'','IPI Dev.'	,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'LIQUIDO'	,'','L�quido'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ESTORNO'	,'','Estorno'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PERC'		,'','2.5%'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("BRUTO"),"Total Centro de Custo")
oBreak := TRBreak():New(oSection1,oSection1:Cell("FILIAL"),"Total",.F.)
//New(oParent,uBreak,uTitle,lTotalInLine,cName,lPageBreak)
//oBreak := TRBreak():New(oTREPORT02,{ || oTREPORT02:Cell('E1_CLIENTE'):uPrint+oTREPORT02:Cell('E1_LOJA'):uPrint },'Sub-Total',.F.)
//TRFunction():New(oTREPORT02:Cell('E1_CLIENTE'),, 'COUNT',oBreak ,,,,.F.,.F.,.F., oTREPORT02)

//TRFunction():New(oSection1:Cell("BRUTO"),NIL,"SUM",oBreak,,,,,.T.)
TRFunction():New(oSection1:Cell("TOTAL"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("IPI"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("BRUTO"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("DEV"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("IPIDEV"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("LIQUIDO"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("ESTORNO"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell("PERC"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
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
Local cQuery 		:= ""
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local lContinua 	:= .T.
Local aFds 		:= {}

//******************************
// Monta a tabela tempor�ria
//******************************

Aadd( aFds , {"FILIAL"		,"C",002,000} )
Aadd( aFds , {"NCM" 			,"C",010,000} )
Aadd( aFds , {"TOTAL"		,"N",016,002} )
Aadd( aFds , {"IPI" 			,"N",016,002} )
Aadd( aFds , {"BRUTO"		,"N",016,002} )
Aadd( aFds , {"DEV" 			,"N",016,002} )
Aadd( aFds , {"IPIDEV" 		,"N",016,002} )
Aadd( aFds , {"LIQUIDO"		,"N",016,002} )
Aadd( aFds , {"ESTORNO" 		,"N",016,002} )
Aadd( aFds , {"PERC" 		,"N",016,002} )

coTbl := CriaTrab( aFds, .T. )
Use (coTbl) Alias TAB New Exclusive
dbCreateIndex(coTbl,'FILIAL+NCM', {|| FILIAL+NCM })

//***********************************
// Monta a tabela de vendas por NCM
//***********************************

cQuery := " SELECT D2_FILIAL, B1_POSIPI, SUM(D2_TOTAL) TOTAL, SUM(D2_VALIPI) IPI, SUM(D2_VALBRUT) BRUTO "
cQuery += " FROM SD2010 D2 WITH (NOLOCK) "
cQuery += " INNER JOIN SB1010 B1 WITH (NOLOCK) "
cQuery += " ON D2_COD = B1_COD "
cQuery += " WHERE D2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
cQuery += " AND D2.D_E_L_E_T_ <> '*' "
cQuery += " AND B1.D_E_L_E_T_ <> '*' "
cQuery += " AND D2_TIPO = 'N' "
cQuery += " AND D2_FILIAL = '" + mv_par03 + "' "
cQuery += " AND substring(D2_CF,1,2) IN ('51','61') "
cQuery += " AND D2_CF NOT IN ('5151','5152') "
cQuery += " GROUP BY D2_FILIAL, B1_POSIPI "
cQuery += " ORDER BY D2_FILIAL, B1_POSIPI "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

While TMP->(!Eof())
	
	RecLock("TAB",.T.)
	
	Replace TAB->FILIAL 	with TMP->D2_FILIAL
	Replace TAB->NCM 		with TMP->B1_POSIPI
	Replace TAB->TOTAL 	with TMP->TOTAL
	Replace TAB->IPI 		with TMP->IPI
	Replace TAB->BRUTO 	with TMP->BRUTO
	Replace TAB->DEV 		with 0
	Replace TAB->IPIDEV 	with 0
	Replace TAB->LIQUIDO	with 0
	Replace TAB->ESTORNO	with 0
	Replace TAB->PERC 	with 0
	
	MsUnlock()
	TMP->(dbSkip())

EndDo

//*************************************
// Monta a tabela de devolu��o por NCM
//*************************************

cQuery := " SELECT D1_FILIAL, B1_POSIPI, SUM(D1_TOTAL-D1_VALDESC) DEV, SUM(D1_VALIPI) IPIDEV "
cQuery += " FROM SD1010 D1 WITH (NOLOCK) "
cQuery += " LEFT OUTER JOIN SB1010 B1 WITH (NOLOCK) "
cQuery += " ON D1_COD = B1_COD "
cQuery += " WHERE D1_DTDIGIT BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
cQuery += " AND D1.D_E_L_E_T_ <> '*' "
cQuery += " AND B1.D_E_L_E_T_ <> '*' "
cQuery += " AND D1_TIPO = 'D' "
cQuery += " AND D1_FILIAL = '" + mv_par03 + "' "
cQuery += " AND D1_SERIE <> '' "
cQuery += " AND substring(D1_CF,1,2) IN ('12','22') "
cQuery += " AND D1_CF NOT IN ('1151','2152') "
cQuery += " GROUP BY D1_FILIAL, B1_POSIPI "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

While TMP->(!Eof())

	dbSelectArea("TAB")
	If dbSeek(TMP->D1_FILIAL + TMP->B1_POSIPI)
		RecLock("TAB",.F.)
		
		Replace TAB->DEV 		with TMP->DEV
		Replace TAB->IPIDEV 	with TMP->IPIDEV
		
		MsUnlock()
	EndIf
	
	dbSelectArea("TMP")
	TMP->(dbSkip())

EndDo

//***********************************
// Recalcula os campos finais
//***********************************
TAB->( DbGoTop() )

While TAB->(!Eof())
	
		RecLock("TAB",.F.)
		
		Replace TAB->LIQUIDO	with TAB->TOTAL - TAB->DEV
		Replace TAB->ESTORNO	with TAB->IPI - TAB->IPIDEV + TAB->DEV
		Replace TAB->PERC 	with TAB->LIQUIDO * 0.025
		
		MsUnlock()
	
	TAB->(dbSkip())

EndDo

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
oReport:SkipLine()     
oReport:SkipLine()     

oReport:Say(oReport:Row(),oReport:Col(),"PER�ODO de " + DtoC(mv_par01) + " at� " + DtoC(mv_par02) )
oReport:SkipLine()
oReport:ThinLine()


While !oReport:Cancel() .And. TAB->(!Eof())

	oReport:IncMeter()

	oSection1:Cell("FILIAL"):SetValue(TAB->FILIAL)
	oSection1:Cell("FILIAL"):SetAlign("CENTER")
	oSection1:Cell("NCM"):SetValue(TAB->NCM)
	oSection1:Cell("NCM"):SetAlign("CENTER")
	oSection1:Cell("TOTAL"):SetValue(TAB->TOTAL)
	oSection1:Cell("TOTAL"):SetAlign("RIGHT")
	oSection1:Cell("IPI"):SetValue(TAB->IPI)
	oSection1:Cell("IPI"):SetAlign("RIGHT")
	oSection1:Cell("BRUTO"):SetValue(TAB->BRUTO)
	oSection1:Cell("BRUTO"):SetAlign("RIGHT")
	oSection1:Cell("DEV"):SetValue(TAB->DEV)
	oSection1:Cell("DEV"):SetAlign("RIGHT")
	oSection1:Cell("IPIDEV"):SetValue(TAB->IPIDEV)
	oSection1:Cell("IPIDEV"):SetAlign("RIGHT")
	oSection1:Cell("LIQUIDO"):SetValue(TAB->LIQUIDO)
	oSection1:Cell("LIQUIDO"):SetAlign("RIGHT")
	oSection1:Cell("ESTORNO"):SetValue(TAB->ESTORNO)
	oSection1:Cell("ESTORNO"):SetAlign("RIGHT")
	oSection1:Cell("PERC"):SetValue(TAB->PERC)
	oSection1:Cell("PERC"):SetAlign("RIGHT")
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TAB->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TAB")
dbCloseArea("TMP")
Set Filter To

Return
