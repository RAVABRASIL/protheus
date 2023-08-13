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
���Programa  �FATR056    � Autor � Gustavo Costa        � Data �13.09.2018���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Lista de substituicao de produtos                           .���
���          �  LINHA                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATR056()

Local oReport
Local cPerg	:= "FATR56"
//criaSx1(cPerg)
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

//putSx1(cPerg, '01', 'Data Base de?'     	  	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
//putSx1(cPerg, '02', 'Data Base at�?'	  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
//putSx1(cPerg, '03', 'Representante?'     		, '', '', 'mv_ch3', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})
//putSx1(cPerg, '04', 'Estado?'	     			, '', '', 'mv_ch4', 'C', 2                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})

return  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FISR001  � Autor � Gustavo Costa          � Data �20.09.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio de avalia��o de clientes XDD.     .���
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

oReport:= TReport():New("FATR56","Transforma��o de Produtos","FATR56", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� imprimir a Transforma��o de Produtos")
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

//Pergunte(oReport:uParam,.T.)

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

oSection1 := TRSection():New(oReport,"ORIGEM" ,{"TAB"}) 

TRCell():New(oSection1,'CODO'		,'','Codigo'		,	/*Picture*/		,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DESCO'		,'','Produto'		,	/*Picture*/		,50				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'ESPESO'		,'','Espessura'		,"@E 9,999.99999"   ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2 := TRSection():New(oSection1,"DESTINO" ,{"TAB"}) 
oSection2:SetLeftMargin(2)

TRCell():New(oSection2,'FIL'		,'','Filial'		,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'COD'		,'','Codigo'		,	/*Picture*/		,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'DESC'		,'','Produto'		,	/*Picture*/		,50				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'ESPES'		,'','Espessura'		,"@E 9,999.99999"   ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'SALDO'		,'','Saldo'			,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PESOD'		,'','Peso Prod.'	,"@E 9,999.99999999",14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PESOO'		,'','Peso Origem'	,"@E 9,999.99999999",14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PERC'    	,'','% Dif.'		,"@E 9,999.99999999",14				,/*lPixel*/,/*{|| code-block de impressao }*/)

//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

oBreak := TRBreak():New(oSection1,oSection1:Cell("CODO"),"Produto",.F.)
//oBreak := TRBreak():New(oSection1,oSection1:Cell("REP"),"Total",.F.)
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
Local cProduto		:= mv_par01
Local cFamilia 		:= SubStr(mv_par01,1,1)
Local cCor   		:= SubStr(mv_par01,3,1)
Local lContinua 	:= .T.
Local nPesoOrig		:= Posicione("SB1",1,xFilial("SB1")+mv_par01, "B1_PESO")
Local nPercMenos	:= 0 //nPesoOrig - (nPesoOrig * (mv_par02/100))
Local nPercMais		:= 0 //nPesoOrig + (nPesoOrig * (mv_par03/100))

If nPesoOrig > 0
	nPercMenos	:= nPesoOrig - (nPesoOrig * (mv_par02/100))
	nPercMais	:= nPesoOrig + (nPesoOrig * (mv_par03/100))
Else
	MsgAlert("Produto sem peso - " + mv_par01)
	Return
EndIf


If cFamilia = 'C'
	cFamilia	:= "('C')"
Else
	cFamilia	:= "('A','B','D','E','G')"
EndIf

//******************************
// Monta a tabela tempor�ria
//******************************
/*
Aadd( aFds , {"FIL"				,"C",002,000} )
Aadd( aFds , {"COD"				,"C",006,000} )
Aadd( aFds , {"DESC"			,"C",009,000} )
Aadd( aFds , {"SALDO"	 		,"C",002,000} )
Aadd( aFds , {"PESOD" 			,"C",002,000} )
Aadd( aFds , {"PESOO" 			,"C",002,000} )
Aadd( aFds , {"PERC"	 		,"C",002,000} )

coTbl := CriaTrab( aFds, .T. )
Use (coTbl) Alias TAB New Exclusive
dbCreateIndex(coTbl,'FIL+PED+NOTA', {|| FIL+PED+NOTA })
*/
//***********************************
// Monta a tabela de vendas por NCM
//***********************************

cQuery := " SELECT B2_FILIAL, B2_COD, B1_DESC, B5_ESPESS, B1_UM, B2_QATU, B1_PESO, PESO, ((B1_PESO - PESO) / B1_PESO)*100 PERC FROM ( "
cQuery += " SELECT B2_FILIAL, B2_COD, B1_DESC, B5_ESPESS, B1_UM, B2_QATU, " 
cQuery += " CASE WHEN B1_UM = 'FD' THEN (B1_PESO / B5_QTDEN)*1000 ELSE B1_PESO END AS B1_PESO, " 
cQuery += " (SELECT B1_PESO FROM SB1010 WHERE B1_COD = '" + cProduto + "' ) PESO "
cQuery += " FROM SB1010 B1 "
cQuery += " INNER JOIN SB2020 B2 "
cQuery += " ON B1_COD = B2_COD "
cQuery += " INNER JOIN SB5010 B5 "
cQuery += " ON B1_COD = B5_COD "
cQuery += " WHERE SUBSTRING(B1_COD,1,1) IN " + cFamilia + " "
cQuery += " AND  SUBSTRING(B1_COD,3,1) = '" + cCor + "' "
cQuery += " AND B1.D_E_L_E_T_ <> '*' "
cQuery += " AND B2.D_E_L_E_T_ <> '*' "
cQuery += " AND B5.D_E_L_E_T_ <> '*' "
cQuery += " AND B2_QATU > 0 "
cQuery += " AND B2_LOCAL = '01' "
cQuery += " AND B2_FILIAL + B2_COD <> '" + xFilial("SB2") + cProduto + "' "
cQuery += " ) AS TAB "
cQuery += " WHERE B1_PESO BETWEEN '" + STR(nPercMenos) + "' AND '" + STR(nPercMais) + "' "
cQuery += " ORDER BY B1_PESO DESC " 

MemoWrite("C:\TEMP\FATR056.SQL", cQuery)

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )
oReport:SetMeter(TMP->(RecCount()))


//��������������������������������������������������������������Ŀ
//�	Processando a Sessao 1                                       �
//����������������������������������������������������������������

oSection1:Init()
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     

oSection1:Cell("CODO"):SetValue(mv_par01)
oSection1:Cell("CODO"):SetAlign("LEFT")
oSection1:Cell("DESCO"):SetValue(Posicione("SB1",1,xFilial("SB1")+mv_par01, "B1_DESC"))
oSection1:Cell("DESCO"):SetAlign("LEFT")
oSection1:Cell("ESPESO"):SetValue(Posicione("SB5",1,xFilial("SB5")+mv_par01, "B5_ESPESS"))
oSection1:Cell("ESPESO"):SetAlign("RIGHT")

oSection1:PrintLine()
oReport:SkipLine()
oReport:ThinLine()

oSection2:Init()

While !oReport:Cancel() .And. TMP->(!Eof())

	oReport:IncMeter()

	oSection2:Cell("FIL"):SetValue(TMP->B2_FILIAL)
	oSection2:Cell("FIL"):SetAlign("CENTER")
	oSection2:Cell("COD"):SetValue(TMP->B2_COD)
	oSection2:Cell("COD"):SetAlign("LEFT")
	oSection2:Cell("DESC"):SetValue(TMP->B1_DESC)
	oSection2:Cell("DESC"):SetAlign("LEFT")
	oSection2:Cell("ESPES"):SetValue(TMP->B5_ESPESS)
	oSection2:Cell("ESPES"):SetAlign("RIGHT")
	oSection2:Cell("SALDO"):SetValue(TMP->B2_QATU)
	oSection2:Cell("SALDO"):SetAlign("RIGHT")
	oSection2:Cell("PESOD"):SetValue(TMP->B1_PESO)
	oSection2:Cell("PESOD"):SetAlign("RIGHT")
	oSection2:Cell("PESOO"):SetValue(TMP->PESO)
	oSection2:Cell("PESOO"):SetAlign("RIGHT")
	oSection2:Cell("PERC"):SetValue(TMP->PERC)
	oSection2:Cell("PERC"):SetAlign("RIGHT")
	
	
	oSection2:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()
oSection2:Finish()

dbCloseArea("TMP")
Set Filter To

Return


