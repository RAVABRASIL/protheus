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
���Programa  �FXLSCOB2   � Autor � THIAGO EWERTON       � Data �10.11.2022���
�������������������������������������������������������������������������Ĵ��
���Descri��o �            RELATORIO COBERTURA                            .���
���          �  LINHA                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FXLSCOB2()

Local oReport
Local cPerg	:= "FXLSCOB"

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

PutSx1( cPerg,'01','Data De     ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'02','Data Ate    ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )
//PutSx1( cPerg,'01','Cliente De     ?','','','mv_ch1','C',06,0,0,'G','','SA1CLI','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
//PutSx1( cPerg,'02','Cliente Ate    ?','','','mv_ch2','C',06,0,0,'G','','SA1CLI','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )


return  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FXLSCOB2  � Autor � THIAGO EWERTON        � Data �10.11.2022���
�������������������������������������������������������������������������Ĵ��
���Descri��o �              RELATORIO DE COBERTURA                       .���
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
//Local oSection2

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

oReport:= TReport():New("FXLSCOB2","RELAT�RIO DE COBERTURA","FXLSCOB2", {|oReport| ReportPrint(oReport)},"RELAT�RIO DE COBERTURA")
oReport:SetLandscape()
//oReport:SetPortrait()

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

oSection1 := TRSection():New(oReport,"ORIGEM" ,{"TAB"}) //alterar para TAB PARA SA1

//TRCell():New(oSection1,'VEN'		,'','Cod.'			,	/*Picture*/		,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'NVEN'		,'','Vendedor'		,	/*Picture*/		,30				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'CLI'		,'','Cliente'		,	/*Picture*/		,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'LOJA'		,'','Loja'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'NCLI'		,'','Nome'			,	/*Picture*/		,40				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'EST'		,'','UF'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'LINHA'		,'','Linha'			,	/*Picture*/		,20				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'MEDIA'		,'','Media 12M'		,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'MESATU'		,'','Mes Atual'		,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'CARTATU'	,'','Carteira'		,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSection1,'GERENT'     ,'','GERENT'        ,)
TRCell():New(oSection1,'NOME_GEREN'     ,'','NOME_GEREN'        ,)
TRCell():New(oSection1,'REPRES'    ,'','REPRES' ,)
TRCell():New(oSection1,'NOME_REP'  ,'','NOME_REP'      ,)
TRCell():New(oSection1,'COBERTURA'  ,'','COBERTURA'      ,)
TRCell():New(oSection1,'UF'     ,'','UF'       ,)
//TRCell():New(oSection1,'MES/ANO'    ,'','MES/ANO'          ,)


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
���Programa  �FXLSCOB2 � Autor � THIAGO EWERTON          � Data �20.06.2022���
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
// Monta a tabela de COBERTURA
//***********************************


cQuery :="SELECT "
cQuery +="GERENT,NOME_GEREN=ISNULL((SELECT RTRIM(SA3X.A3_NOME) FROM SA3010 SA3X WHERE SA3X.A3_COD = GERENT AND SA3X.D_E_L_E_T_ <> '*'),''), "
cQuery +="REPRES,NOME_REP, "
cQuery +="COBERTURA=COUNT(SEQ), "
cQuery +="UF, "
cQuery +="ANOMES "
cQuery +="FROM( "
cQuery +="SELECT "
cQuery +="GERENT=A3_SUPER, "
cQuery +="REPRES=A3_COD,NOME_REP=A3_NOME, "
cQuery +="CLIENTE=A1_COD,LOJA=A1_LOJA, "
cQuery +="UF=A1_EST, "
cQuery +="ANOMES=LEFT(C5_ENTREG,6), "
cQuery +="SEQ=ROW_NUMBER() OVER(ORDER BY A1_COD,A1_LOJA) "
cQuery +="FROM  "
cQuery +=""+RetSqlName("SC6")+" SC6 (NOLOCK),"+RetSqlName("SC5")+" SC5 (NOLOCK),"+RetSqlName("SA1")+" SA1 (NOLOCK),"+RetSqlName("SA3")+" SA3 (NOLOCK) "
cQuery +=",SB1010 SB1 (NOLOCK) "
cQuery +="WHERE "
cQuery +="C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery +="AND C5_ENTREG BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cQuery +="AND SC5.D_E_L_E_T_ = ' ' "
cQuery +="AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery +="SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118' ) AND "
cQuery +="A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' '  AND "
cQuery +="SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_='' AND "
cQuery +="B1_COD=C6_PRODUTO  AND SB1.B1_SETOR <> '39'  AND "
cQuery +="SB1.D_E_L_E_T_='' AND "
cQuery +="SC6.D_E_L_E_T_ = ' ' "
cQuery +="GROUP BY "
cQuery +="A3_SUPER,A3_COD,A3_NOME,A1_EST, LEFT(C5_ENTREG,6),A1_COD,A1_LOJA "
cQuery +=") AS TABX "
cQuery +="GROUP BY "
cQuery +="GERENT, "
cQuery +="REPRES,NOME_REP, "
cQuery +="UF, "
cQuery +="ANOMES  "
cQuery +="ORDER BY ANOMES  "

MemoWrite("C:\TEMP\FXLSCOB2.SQL", cQuery)

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

    oSection1:Cell("GERENT"):SetValue(TMP->GERENT)
	oSection1:Cell("GERENT"):SetAlign("LEFT")
	oSection1:Cell("NOME_GEREN"):SetValue(TMP->NOME_GEREN)
	oSection1:Cell("NOME_GEREN"):SetAlign("LEFT")
	oSection1:Cell("REPRES"):SetValue(TMP->REPRES)
	oSection1:Cell("REPRES"):SetAlign("LEFT")
	oSection1:Cell("NOME_REP"):SetValue(TMP->NOME_REP)
	oSection1:Cell("NOME_REP"):SetAlign("LEFT")
	oSection1:Cell("COBERTURA"):SetValue(TMP->COBERTURA)
	oSection1:Cell("COBERTURA"):SetAlign("LEFT")
	oSection1:Cell("UF"):SetValue(TMP->UF)
	oSection1:Cell("UF"):SetAlign("LEFT")
	//oSection1:Cell("MES/ANO"):SetValue((AUXZ->ANOMES,5,2)+'/'+SUBSTR(AUXZ->ANOMES,1,4))
	//oSection1:Cell("MES/ANO"):SetAlign("LEFT")
	//oSection1:Cell("MESATU"):SetValue(TMP->MESATU)
	//oSection1:Cell("MESATU"):SetAlign("LEFT")
	//oSection1:Cell("CARTATU"):SetValue(TMP->CARTATU)
	//oSection1:Cell("CARTATU"):SetAlign("LEFT")
	
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return


