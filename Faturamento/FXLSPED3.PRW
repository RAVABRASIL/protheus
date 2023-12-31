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
���Programa  �FATR057    � Autor � THIAGO EWERTON       � Data �10.11.2022���
�������������������������������������������������������������������������Ĵ��
���Descri��o �            RELATORIO DE PEDIDOS                           .���
���          �  LINHA                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FXLSPED3()

Local oReport
Local cPerg	:= "FXLSPED2"

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
//putSx1(cPerg, '03', 'Representante?'     		, '', '', 'mv_ch3', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})
//putSx1(cPerg, '04', 'Estado?'	     			, '', '', 'mv_ch4', 'C', 2                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})

return  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FISR001  � Autor � Thiago Ewerton         � Data �10.11.2022���
�������������������������������������������������������������������������Ĵ��
���Descri��o �               Relatorio de Pedidos.                       .���
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

oReport:= TReport():New("FXLSPED3","RELAT�RIO DE PEDIDOS","FXLSPED3", {|oReport| ReportPrint(oReport)},"Relat�rio export de pedidos")
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

TRCell():New(oSection1,'CODIGO'     ,'','CODIGO'        ,)
TRCell():New(oSection1,'VENDEDOR'    ,'','VENDEDOR' ,)
//TRCell():New(oSection1,'CLIENTE'  ,'','CLIENTE'      ,)
TRCell():New(oSection1,'LOJA'  ,'','LOJA'      ,)
TRCell():New(oSection1,'NOME'     ,'','NOME'       ,)
TRCell():New(oSection1,'PEDIDO'    ,'','PEDIDO'          ,)
//TRCell():New(oSection1,'VENDIDO_KG'    ,'','VENDIDO_KG'          ,)
TRCell():New(oSection1,'VENDIDO_RS'    ,'','VENDIDO_RS'          ,)
TRCell():New(oSection1,'PRECO_MEDIO'    ,'','PRECO_MEDIO'          ,)

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
// Monta a tabela
//***********************************


cQuery :="SELECT "
cQuery +="      C5_VEND1 ,A3_NOME,A1_COD,A1_LOJA,A1_NOME,C5_NUM, "
cQuery +="VENDIDO_RS=SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC ),"
cQuery +="PESO=SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO)  "
cQuery +="   FROM "
cQuery +="      "+RetSqlName("SB1")+" SB1 with (nolock), "+RetSqlName("SC5")+" SC5 with (nolock),"+RetSqlName("SC6")+" SC6 with (nolock),"+RetSqlName("SA1")+" SA1 with (nolock), "
cQuery +="      "+RetSqlName("SA3")+" SA3 with (nolock) "
cQuery +="   WHERE "
cQuery +="      SC5.C5_FILIAL = SC6.C6_FILIAL AND SC6.C6_BLQ <> 'R' AND "
cQuery +="      SC5.C5_VEND1 = SA3.A3_COD  AND SB1.B1_TIPO = 'PA' AND "
cQuery +="      C5_TIPO='N' AND "
cQuery +="      SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery +="      SB1.B1_COD = "
cQuery +="      ( CASE WHEN LEN(C6_PRODUTO)>=8 THEN "
cQuery +="       CASE when (Substring( C6_PRODUTO, 4, 1 ) IN('R','D')) or  (Substring( C6_PRODUTO, 5, 1 ) IN('R','D')) "
cQuery +="       then SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,4)+SUBSTRING(C6_PRODUTO,8,2) "
cQuery +="       else SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,3)+SUBSTRING(C6_PRODUTO,7,2) end  "
cQuery +="       ELSE RTRIM(C6_PRODUTO) END ) AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery +="      SC5.C5_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND "
cQuery +="      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5118','6118','5949','6949','5922','6922','5116','6116','6108') AND "
cQuery +="      SB1.D_E_L_E_T_ = ' ' AND "
cQuery +="      SA1.D_E_L_E_T_ = ' ' AND "
cQuery +="      SC5.D_E_L_E_T_ = ' ' AND "
cQuery +="      SC6.D_E_L_E_T_ = ' ' "
cQuery +="      GROUP BY C5_VEND1,A3_NOME,A1_COD,A1_LOJA,C5_NUM,A1_NOME "
cQuery +="      ORDER BY C5_NUM "

MemoWrite("C:\TEMP\FXLSPED3.SQL", cQuery)

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

    oSection1:Cell("CODIGO"):SetValue(TMP->A1_COD)
	oSection1:Cell("CODIGO"):SetAlign("LEFT")
	oSection1:Cell("VENDEDOR"):SetValue(TMP->C5_VEND1)
	oSection1:Cell("VENDEDOR"):SetAlign("LEFT")
	//oSection1:Cell("CLIENTE"):SetValue(TMP->C5_CLIENTE)
	//oSection1:Cell("CLIENTE"):SetAlign("LEFT")
	oSection1:Cell("LOJA"):SetValue(TMP->A1_LOJA)
	oSection1:Cell("LOJA"):SetAlign("LEFT")
	oSection1:Cell("NOME"):SetValue(TMP->A3_NOME)
	oSection1:Cell("NOME"):SetAlign("LEFT")
	oSection1:Cell("PEDIDO"):SetValue(TMP->C5_NUM)
	oSection1:Cell("PEDIDO"):SetAlign("LEFT")
	//oSection1:Cell("VENDIDO_KG"):SetValue(TMP->VENDIDO_KG)
	//oSection1:Cell("VENDIDO_KG"):SetAlign("LEFT")
	oSection1:Cell("VENDIDO_RS"):SetValue(TMP->VENDIDO_RS)
	oSection1:Cell("VENDIDO_RS"):SetAlign("LEFT")
	oSection1:Cell("PRECO_MEDIO"):SetValue(TMP->VENDIDO_RS/TMP->PESO)
	oSection1:Cell("PRECO_MEDIO"):SetAlign("LEFT")
	
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return


