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
���Programa  �ESTR018  � Autor � Gustavo Costa          � Data �11.03.2015���
�������������������������������������������������������������������������Ĵ��
���Descri��o   �Relatorio �ndice das Inspe��es de Processo.                 .���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ESTR018()

Local oReport
Local cPerg	:= "ESTR18"

Private lJob		:= .F.

//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//N�o consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SX1" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Relatorio �ndice das Inspe��es de Processo... '+Dtoc(DATE())+' - '+Time())
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
		ConOut('Relatorio �ndice das Inspe��es de Processo. '+Dtoc(DATE())+' - '+Time())
	EndIf


Return

//+-----------------------------------------------------------------------------------------------+
//! Fun��o para cria��o das perguntas (se n�o existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data de?'     	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data at�?'  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
//putSx1(cPerg, '03', 'Nota Fiscal?' 	, '', '', 'mv_ch3', 'C', 9                     	, 0, 0, 'G', '', 'SF2', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Em branco para todos"},{},{})
//putSx1(cPerg, '04', 'Cliente?'			, '', '', 'mv_ch4', 'C', 9                     	, 0, 0, 'G', '', 'SF2', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Em branco para todos"},{},{})

return  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ESTR018  � Autor � Gustavo Costa          � Data �11.03.2015���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio das �ndice das Inspe��es de Processo                .���
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

oReport:= TReport():New("ESTR18","�ndice das Inspe��es de Processo" ,"ESTR18", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� listar o �ndice das Inspe��es de Processo.")
//oReport:SetLandscape()
oReport:SetPortrait()

If lJob
	oReport:nDevice	 	:= 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
	oReport:cEmail		:= GetNewPar("MV_XESTR18",'gustavo@ravaembalagens.com.br')
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

oSection1 := TRSection():New(oReport,"Nota Fiscal",{"TMP"}) 

TRCell():New(oSection1,'FILIAL'			,'','Filial'		,	/*Picture*/			,02				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'DIA'			,'','Data'			,	/*Picture*/			,10				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'TIPO'			,'','Tipo'			,	/*Picture*/			,02				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'QUANT'			,'','Quantidade'	,	"@E 999,999"			,12				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'REAL'			,'','Realizado'		,	"@E 999,999"			,12				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'REALP'			,'','Rel. %'		,	"@E 999,999"			,08				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'RESTA'			,'','Resta'			,	"@E 999,999"			,12				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')

//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

oBreak := TRBreak():New(oSection1,oSection1:Cell("FILIAL"),"Inspe��o:",.F.)

//New(oParent,uBreak,uTitle,lTotalInLine,cName,lPageBreak)
//TRFunction():New(oSection2:Cell("DESCO"),NIL,"SUM",oBreak,"Total Horas Descontadas",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)
TRFunction():New(oSection1:Cell('QUANT') ,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell('REAL') ,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell('REALP') ,NIL,"AVERAGE",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell('RESTA') ,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)

Return(oReport)

/*/
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
��������������������������������������������������������������������������ٱ�
/*/

Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
//Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local lPula	 	:= .T.
Local lOK 			:= .T.
Local d1			:= IIF(lJob,FirstDay(dDataBase),mv_par01)
Local d2			:= IIF(lJob,dDataBase-1,mv_par02)
Local lCabec		:= .T.

PRIVATE lMudouDia	:= .F.
PRIVATE dDiaAtu	:= CtoD("  /  /  ")
PRIVATE dDiaAnt	:= CtoD("  /  /  ")

mv_par01 := d1

//��������������������������������������������������������������Ŀ
//�	Processando a Sessao 1                                       �
//����������������������������������������������������������������

oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"PER�ODO de " + DtoC(d1) + " at� " + DtoC(d2) )
oReport:SkipLine()

cQuery := " SELECT QPK_DTPROD, B1_TIPO, COUNT(*) QUANTIDADE, "
cQuery += " SUM( CASE WHEN QPK_SITOP <> '' THEN 1 ELSE 0 END ) AS REALIZADO "
cQuery += " FROM " + RetSqlName("QPK") + " Q " 
cQuery += " INNER JOIN SB1010 B "
cQuery += " ON QPK_PRODUT = B1_COD "
cQuery += " WHERE Q.D_E_L_E_T_ <> '*' " 
cQuery += " AND B.D_E_L_E_T_ <> '*' "
cQuery += " AND QPK_DTPROD BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "'"
cQuery += " AND QPK_FILIAL = '" + xFilial("QPK") + "' "
cQuery += " AND B1_TIPO IN ('PA','PI') "
cQuery += " GROUP BY QPK_DTPROD, B1_TIPO "
cQuery += " ORDER BY QPK_DTPROD, B1_TIPO "


If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( "TMP", "QPK_DTPROD", "D")

nCount	:= TMP->(RECCOUNT())
TMP->( DbGoTop() )
		
oReport:SetMeter(nCount)
	
While !oReport:Cancel() .And. TMP->(!EOF())

	oReport:IncMeter()
	
	oSection1:Init()
		
	oSection1:Cell("DIA"):SetValue(TMP->QPK_DTPROD)
	oSection1:Cell("DIA"):SetAlign("CENTER")
	oSection1:Cell("TIPO"):SetValue(TMP->B1_TIPO)
	oSection1:Cell("TIPO"):SetAlign("CENTER")
	oSection1:Cell("QUANT"):SetValue(TMP->QUANTIDADE)
	oSection1:Cell("QUANT"):SetAlign("RIGHT")
	oSection1:Cell("REAL"):SetValue(TMP->REALIZADO)
	oSection1:Cell("REAL"):SetAlign("RIGHT")
	oSection1:Cell("REALP"):SetValue(Round((TMP->REALIZADO/TMP->QUANTIDADE)*100,0))
	oSection1:Cell("REALP"):SetAlign("RIGHT")
	oSection1:Cell("RESTA"):SetValue(TMP->QUANTIDADE - TMP->REALIZADO)
	oSection1:Cell("RESTA"):SetAlign("RIGHT")

	oSection1:PrintLine()

	TMP->(dbSkip())

EndDo

oSection1:Finish()
dbCloseArea("TMP")

Set Filter To

Return


