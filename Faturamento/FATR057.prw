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
���Programa  �FATR057    � Autor � Gustavo Costa        � Data �13.09.2018���
�������������������������������������������������������������������������Ĵ��
���Descri��o � 50 melhores clientes por linha   .���
���          �  LINHA                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATR057()

Local oReport
Local cPerg	:= "FATR57"
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
putSx1(cPerg, '03', 'Representante?'     		, '', '', 'mv_ch3', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})
putSx1(cPerg, '04', 'Estado?'	     			, '', '', 'mv_ch4', 'C', 2                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})

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

oReport:= TReport():New("FATR57","50 Melhores Clientes por linha","FATR57", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� imprimir os 50 Melhores Clientes por linha")
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

TRCell():New(oSection1,'VEN'		,'','Cod.'			,	/*Picture*/		,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NVEN'		,'','Vendedor'		,	/*Picture*/		,30				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CLI'		,'','Cliente'		,	/*Picture*/		,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'LOJA'		,'','Loja'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NCLI'		,'','Nome'			,	/*Picture*/		,40				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EST'		,'','UF'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'LINHA'		,'','Linha'			,	/*Picture*/		,20				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'MEDIA'		,'','Media 12M'		,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'MESATU'		,'','Mes Atual'		,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CARTATU'	,'','Carteira'		,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)


//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("CODO"),"Produto",.F.)
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
//Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
Local lContinua 	:= .T.


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

cQuery := " SELECT TOP 50 A3_COD COD, A3_NOME VENDEDOR, " 
cQuery += " A1_COD, A1_LOJA, A1_NREDUZ NOME, F2_EST UF, " 
cQuery += "  LINHA=CASE  "
cQuery += "            WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA'  "
cQuery += "            WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL'  "
cQuery += "            WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR'  "          
cQuery += "            ELSE B1_GRUPO  "
cQuery += "          END, "              
cQuery += "         SUM( CASE WHEN SUBSTRING(C5_EMISSAO,1,4) = '2018' THEN (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ELSE 0 END ) AS TOTAL12, "
cQuery += "         SUM( CASE WHEN SUBSTRING(C5_EMISSAO,1,4) = '2018' THEN (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ELSE 0 END )/12 AS MEDIA12, "
cQuery += "         SUM( CASE WHEN SUBSTRING(C5_EMISSAO,1,6) = '201901' THEN (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ELSE 0 END ) AS MESATU "

cQuery += "         FROM SD2020 SD2 WITH (NOLOCK) " 
cQuery += "         INNER JOIN SF2020 SF2 WITH (NOLOCK) " 
cQuery += "         ON D2_FILIAL = F2_FILIAL " 
cQuery += "         AND D2_DOC = F2_DOC " 
cQuery += "         AND D2_SERIE = F2_SERIE " 
cQuery += "         INNER JOIN SB1010 SB1 WITH (NOLOCK) " 
cQuery += "         ON D2_COD = B1_COD " 
cQuery += "         INNER JOIN SA1010 SA1 WITH (NOLOCK) " 
cQuery += "         ON F2_CLIENTE + F2_LOJA = A1_COD + A1_LOJA " 
cQuery += "         INNER JOIN SA3010 SA3 WITH (NOLOCK) " 
cQuery += "         ON F2_VEND1 = A3_COD "  
cQuery += "         INNER JOIN SC5020 SC5 WITH (NOLOCK)  "
cQuery += "         ON D2_FILIAL + D2_PEDIDO = C5_FILIAL + C5_NUM  "
cQuery += "         WHERE  "
cQuery += " 		RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) AND "
cQuery += "         SC5.C5_EMISSAO BETWEEN  '" + DtoS(dDataIni) + "' AND '" + DtoS(dDataFim) + "' AND "
cQuery += "         SB1.D_E_L_E_T_ =   ''   AND  "
cQuery += "         SF2.D_E_L_E_T_ =   ''   AND " 
cQuery += "         SA1.D_E_L_E_T_ =   ''   AND  "
cQuery += "         SD2.D_E_L_E_T_ =   ''   AND  "
cQuery += "         SA3.D_E_L_E_T_ =   ''    " 

Do Case
	Case mv_par02 = "1"
		cQuery += "         AND B1_GRUPO IN('D','E') --'1-DOMESTICA' " 
	Case mv_par02 = "2"
		cQuery += "         AND B1_GRUPO IN('A','B','G') --'2-INSTITUCIONAL' " 
	Case mv_par02 = "3"
		cQuery += "         AND B1_GRUPO IN('C') --'3-HOSPITALAR' "           
EndCase

cQuery += "         AND A1_COD NOT IN ('031732','031733','006543','007005') " 
cQuery += "         GROUP BY A3_COD, A3_NOME, " 
cQuery += "         A1_COD, A1_LOJA, A1_NREDUZ, " 
cQuery += "         F2_EST,  "
cQuery += " 		CASE  "
cQuery += "            WHEN B1_GRUPO IN('D','E') THEN '2-DOMESTICA' " 
cQuery += "            WHEN B1_GRUPO IN('A','B','G') THEN '1-INSTITUCIONAL'  "
cQuery += "            WHEN B1_GRUPO IN('C') THEN '3-HOSPITALAR'  "          
cQuery += "            ELSE B1_GRUPO  "
cQuery += "          END  "    
cQuery += "         ORDER BY 7  DESC "

MemoWrite("C:\TEMP\FATR057.SQL", cQuery)

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
oReport:SkipLine()
//oReport:ThinLine()

While !oReport:Cancel() .And. TMP->(!Eof())

	oReport:IncMeter()

	oSection1:Cell("VEN"):SetValue(TMP->COD)
	oSection1:Cell("VEN"):SetAlign("LEFT")
	oSection1:Cell("NVEN"):SetValue(TMP->VENDEDOR)
	oSection1:Cell("NVEN"):SetAlign("LEFT")
	oSection1:Cell("CLI"):SetValue(TMP->A1_COD)
	oSection1:Cell("CLI"):SetAlign("LEFT")
	oSection1:Cell("LOJA"):SetValue(TMP->A1_LOJA)
	oSection1:Cell("LOJA"):SetAlign("LEFT")
	oSection1:Cell("NCLI"):SetValue(TMP->NOME)
	oSection1:Cell("NCLI"):SetAlign("LEFT")
	oSection1:Cell("EST"):SetValue(TMP->UF)
	oSection1:Cell("EST"):SetAlign("LEFT")
	oSection1:Cell("LINHA"):SetValue(TMP->LINHA)
	oSection1:Cell("LINHA"):SetAlign("LEFT")
	oSection1:Cell("MEDIA"):SetValue(TMP->MEDIA)
	oSection1:Cell("MEDIA"):SetAlign("LEFT")
	oSection1:Cell("MESATU"):SetValue(TMP->MESATU)
	oSection1:Cell("MESATU"):SetAlign("LEFT")
	oSection1:Cell("CARTATU"):SetValue(TMP->CARTATU)
	oSection1:Cell("CARTATU"):SetAlign("LEFT")
	
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return


