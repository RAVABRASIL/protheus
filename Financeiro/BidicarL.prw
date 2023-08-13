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
���Programa  �FINR022  � Autor � Gustavo Costa          � Data �13.07.2015���
�������������������������������������������������������������������������Ĵ��
���Descri��o   �Relatorio por periodo de vencimento.                       .���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BidicarL()

Local oReport
Local cPerg	:= "FINR20"

Private lJob		:= .F.

//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//N�o consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SX1" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Relatorio T�tulos vencidos por per�odo... '+Dtoc(DATE())+' - '+Time())
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
		ConOut('Relatorio T�tulos vencidos por per�odo. '+Dtoc(DATE())+' - '+Time())
	EndIf


Return

//+-----------------------------------------------------------------------------------------------+
//! Fun��o para cria��o das perguntas (se n�o existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data Base?'     	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
//putSx1(cPerg, '02', 'Data at�?'  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
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

oReport:= TReport():New("FINR20","T�tulos vencidos por per�odo" ,"FINR20", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� listar os T�tulos vencidos por per�odo.")
oReport:SetLandscape()
//oReport:SetPortrait()

If lJob
	oReport:nDevice	 	:= 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
	oReport:cEmail		:= GetNewPar("MV_XFINR20",'gustavo@ravaembalagens.com.br')
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

TRCell():New(oSection1,'FILIAL'			,'','Filial'				,	/*Picture*/			,20				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'DIAS'			,'','Dias de Vencido'		,	/*Picture*/			,20				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'QTIT'			,'','Qtd. T�tulos'			,	"@E 999,999"		,10				,/*lPixel*/,/*{|| code-block de impressao }*/,"2")
TRCell():New(oSection1,'VALOR'			,'','Valor Orig.'			,	"@E 99,999,999.99"	,14				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')
TRCell():New(oSection1,'SALDO'			,'','Saldo Total'			,	"@E 99,999,999.99"	,14				,/*lPixel*/,/*{|| code-block de impressao }*/,'2')

//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

oBreak := TRBreak():New(oSection1,oSection1:Cell("FILIAL"),"Inspe��o:",.F.)

//New(oParent,uBreak,uTitle,lTotalInLine,cName,lPageBreak)
//TRFunction():New(oSection2:Cell("DESCO"),NIL,"SUM",oBreak,"Total Horas Descontadas",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)
TRFunction():New(oSection1:Cell('QTIT') ,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell('VALOR') ,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection1:Cell('SALDO') ,NIL,"SUM",oBreak,"Total" 	,/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection1)

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
Local d1			:= IIF(lJob,dDataBase,mv_par01)
//Local d2			:= IIF(lJob,dDataBase-1,mv_par02)
Local lCabec		:= .T.
Local cDias			:= ""
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
oReport:Say(oReport:Row(),oReport:Col(),"PER�ODO de " + DtoC(d1) )
oReport:SkipLine()

	
For x := 1 To 6

	cQuery := " SELECT COUNT(*) QTDTIT, SUM(E1_VALOR) E1_VALOR, SUM(E1_SALDO) E1_SALDO FROM " + RetSqlName("SE1") + " E1 "
	cQuery += " WHERE E1.D_E_L_E_T_ <> '*' ""
	cQuery += " AND E1_TIPO NOT IN ('NCC','RA','JR','DC','CP','MT','XX') "
	cQuery += " AND E1_FILIAL = '" + xFilial("SE1") + "' "
	cQuery += " AND E1_SALDO > 0 "
	
	Do Case
	
		Case x == 1
			cQuery 	+= " AND E1_VENCREA BETWEEN '" + DtoS(d1 - 30) + "' AND '" + DtoS(d1 - 1) + "'"
			cDias	:= " 00 - 30 "
		Case x == 2
			cQuery += " AND E1_VENCREA BETWEEN '" + DtoS(d1 - 60) + "' AND '" + DtoS(d1 - 31) + "'"
			cDias	:= " 31 - 60 "
		Case x == 3
			cQuery += " AND E1_VENCREA BETWEEN '" + DtoS(d1 - 90) + "' AND '" + DtoS(d1 - 61) + "'"
			cDias	:= " 61 - 90 "
		Case x == 4
			cQuery += " AND E1_VENCREA BETWEEN '" + DtoS(d1 - 180) + "' AND '" + DtoS(d1 - 91) + "'"
			cDias	:= " 91 - 180 "
		Case x == 5
			cQuery += " AND E1_VENCREA BETWEEN '" + DtoS(d1 - 360) + "' AND '" + DtoS(d1 - 181) + "'"
			cDias	:= " 181 - 360 "
		Case x == 6
			cQuery += " AND E1_VENCREA > '" + DtoS(d1 - 360) + "' " 
			cDias	:= " Maior 360 "
	EndCase


	If Select("TMP") > 0
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf
	
	TCQUERY cQuery NEW ALIAS "TMP"
	TCSetField( "TMP", "QPK_DTPROD", "D")

	oReport:IncMeter()
	
	oSection1:Init()
		
	DbSelectArea("TMP")
	TMP->(dbGoTop())

	oSection1:Cell("FILIAL"):SetValue("01")
	oSection1:Cell("FILIAL"):SetAlign("CENTER")
	oSection1:Cell("DIAS"):SetValue(cDias)
	oSection1:Cell("DIAS"):SetAlign("CENTER")
	oSection1:Cell("QTIT"):SetValue(TMP->QTDTIT)
	oSection1:Cell("QTIT"):SetAlign("CENTER")
	oSection1:Cell("VALOR"):SetValue(TMP->E1_VALOR)
	oSection1:Cell("VALOR"):SetAlign("RIGHT")
	oSection1:Cell("SALDO"):SetValue(TMP->E1_SALDO)
	oSection1:Cell("SALDO"):SetAlign("RIGHT")

	oSection1:PrintLine()

	dbCloseArea("TMP")

Next

oSection1:Finish()

Set Filter To

Return


