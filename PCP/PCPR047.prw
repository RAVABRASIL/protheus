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
���Programa  �PCPR047    � Autor � Gustavo Costa        � Data �29.05.2017���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio LISTA DATA, MAQ, HORA, PRODUTO QUANTIDADE PRODUZIDA.���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PCPR047()

Local oReport
Local cPerg	:= "PCPR47"
criaSx1(cPerg)
//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������
Pergunte(cPerg,.T.)

oReport:= ReportDef()
oReport:PrintDialog()


Return

//+-----------------------------------------------------------------------------------------------+
//! Fun��o para cria��o das perguntas (se n�o existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data Base de?'     	  	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data Base at�?'	  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
//putSx1(cPerg, '03', 'Representante?'     		, '', '', 'mv_ch3', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})
//putSx1(cPerg, '04', 'Coordenador?'     			, '', '', 'mv_ch4', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})

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

oReport:= TReport():New("PCPR47","Apontamento de Produ��o","PCPR47", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� imprimir o Apontamento de Produ��o.")
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

oSection1 := TRSection():New(oReport,"PER�ODO de " + DtoC(mv_par01) + " at� " + DtoC(mv_par02),{"TAB"}) 

TRCell():New(oSection1,'DATA'		,'','Data'			,					,10				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'MAQ'		,'','Maq.'			,	"@!"			,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'LADO'		,'','Lado'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'HORA'		,'','Hora'			,	/*Picture*/		,05				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PRODUTO'   	,'','Produto'		,					,15				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PESO'		,'','Peso'			,PesqPict('SE1','E1_VALOR'),14		,/*lPixel*/,/*{|| code-block de impressao }*/)
//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("REP"),"Total",.F.)


//TRFunction():New(oSection1:Cell("METAKG"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("METAPV"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
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
Local cQuery 		:= ""
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local lContinua 	:= .T.
Local aFds 		:= {}
Local aMeta		:= {}
Local cLinha	:= ""

//***********************************
// Monta a tabela de vendas por NCM
//***********************************

cQuery := " SELECT Z00_DATA, Z00_MAQ, Z00_LADO, Z00_HORA, Z00_CODIGO, Z00_PESO + Z00_PESCAP PESO FROM Z00020"
cQuery += " WHERE Z00_DATA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
cQuery += " AND Z00_APARA = ''"
cQuery += " AND D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY Z00_DATA, Z00_MAQ, Z00_LADO, Z00_CODIGO, Z00_HORA"

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( 'TMP', 'Z00_DATA', 'D' )
TCSetField( 'TMP', 'Z00_MAQ', 'C' )
TCSetField( 'TMP', 'Z00_LADO', 'C' )

TMP->( DbGoTop() )

oReport:SetMeter(TMP->(RecCount()))


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


While !oReport:Cancel() .And. TMP->(!Eof())

	oReport:IncMeter()

	oSection1:Cell("DATA"):SetValue(DtoC(TMP->Z00_DATA))
	oSection1:Cell("DATA"):SetAlign("CENTER")
	oSection1:Cell("MAQ"):SetValue(AllTrim(TMP->Z00_MAQ))
	oSection1:Cell("MAQ"):SetAlign("CENTER")
	oSection1:Cell("LADO"):SetValue(TMP->Z00_LADO)
	oSection1:Cell("LADO"):SetAlign("CENTER")
	oSection1:Cell("HORA"):SetValue(TMP->Z00_HORA)
	oSection1:Cell("HORA"):SetAlign("CENTER")
	oSection1:Cell("PRODUTO"):SetValue(TMP->Z00_CODIGO)
	oSection1:Cell("PRODUTO"):SetAlign("LEFT")
	oSection1:Cell("PESO"):SetValue(TMP->PESO)
	oSection1:Cell("PESO"):SetAlign("RIGHT")
	
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return

