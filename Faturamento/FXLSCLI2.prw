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
���Descri��o �            RELATORIO CLIENTES                             .���
���          �  LINHA                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FXLSCLI2()

Local oReport
Local cPerg	:= "FXLSCLI"

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

PutSx1( cPerg,'01','Cliente De     ?','','','mv_ch1','C',06,0,0,'G','','SA1CLI','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'02','Cliente Ate    ?','','','mv_ch2','C',06,0,0,'G','','SA1CLI','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )
//putSx1(cPerg, '01', 'Data Base de?'     	  	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
//putSx1(cPerg, '02', 'Data Base at�?'	  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
//putSx1(cPerg, '03', 'Representante?'     		, '', '', 'mv_ch3', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})
//putSx1(cPerg, '04', 'Estado?'	     			, '', '', 'mv_ch4', 'C', 2                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Branco para todo"},{},{})

return  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FISR001  � Autor � Thiago Ewerton         � Data �10.11.2022���
�������������������������������������������������������������������������Ĵ��
���Descri��o �               Relatorio clientes XDD.                     .���
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

oReport:= TReport():New("FXLSCLI2","RELAT�RIO DE CLIENTES","FXLSCLI2", {|oReport| ReportPrint(oReport)},"Relat�rio export clientes")
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

TRCell():New(oSection1,'COORDENADOR'     ,'','COORDENADOR'        ,)
TRCell():New(oSection1,'CODIGO'     ,'','CODIGO'        ,)
TRCell():New(oSection1,'REPRESENTANTE'    ,'','REPRESENTANTE' ,)
TRCell():New(oSection1,'COD_SEG'  ,'','COD_SEG'      ,)
TRCell():New(oSection1,'SEGMENTO'  ,'','SEGMENTO'      ,)
TRCell():New(oSection1,'CLIENTE'     ,'','CLIENTE'       ,)
TRCell():New(oSection1,'LOJA'    ,'','LOJA'          ,)
TRCell():New(oSection1,'NOME'    ,'','NOME'          ,)
TRCell():New(oSection1,'ENDERECO'    ,'','ENDERECO'          ,)
TRCell():New(oSection1,'BAIRRO'    ,'','BAIRRO'          ,)
TRCell():New(oSection1,'CIDADE'    ,'','CIDADE'          ,)
TRCell():New(oSection1,'UF'    ,'','UF'          ,)
TRCell():New(oSection1,'CEP'    ,'','CEP'          ,)
TRCell():New(oSection1,'TELEFONE'    ,'','TELEFONE'          ,)
TRCell():New(oSection1,'DT_ULT_EMISSAO'    ,'','DT_ULT_EMISSAO'          ,)
TRCell():New(oSection1,'PRIMEIRA_COMPRA'    ,'','PRIMEIRA_COMPRA'          ,)
TRCell():New(oSection1,'GRUPO_VENDA'    ,'','GRUPO_VENDA'          ,)
TRCell():New(oSection1,'NOME_GRUPO_VENDA'    ,'','NOME_GRUPO_VENDA'          ,)

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


cQuery:="SELECT "
cQuery+="GRUPO_VENDA=A1_GRPVEN , "
cQuery+="COORDENADOR=ISNULL((SELECT RTRIM(SA3X.A3_NOME) FROM SA3010 SA3X WHERE SA3X.A3_COD = SA3.A3_SUPER AND SA3X.D_E_L_E_T_ <> '*'),RTRIM(SA3.A3_NOME)), "
cQuery+="CODIGO=A3_COD,REPRESENTANTE=RTRIM(A3_NOME), "
cQuery+="CLIENTE=A1_COD,LOJA=A1_LOJA,NOME=RTRIM(A1_NOME), "
cQuery+="ENDERECO=A1_END, "
cQuery+="BAIRRO=A1_BAIRRO, "
cQuery+="CIDADE=A1_MUN, "
cQuery+="UF=A1_EST, "
cQuery+="CEP=A1_CEP, "

cQuery+="COD_SEG=A1_SATIV1,SEGMENTO=(SELECT X5_DESCRI FROM SX5020 SX5 "
cQuery+="WHERE "
cQuery+="X5_FILIAL='01' "
cQuery+="AND X5_TABELA='T3' "
cQuery+="AND X5_CHAVE=A1_SATIV1  "
cQuery+="AND D_E_L_E_T_=''), "
cQuery+="TELEFONE=A1_TEL "
// DATA DA ULTIMA EMISSAO 
//cQuery+=",DT_ULT_ENTREGA=(SELECT TOP 1 CONVERT(varchar(10),CONVERT(smalldatetime, F2_REALCHG), 103) FROM SF2020 SF2 " // modelo antigo
cQuery+=",DT_ULT_EMISSAO=(SELECT TOP 1 CONVERT(varchar(10),CONVERT(smalldatetime, F2_EMISSAO), 103) FROM SF2020 SF2 "
cQuery+="WHERE F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA AND F2_REALCHG<>'' "
cQuery+="AND SF2.D_E_L_E_T_='' "
cQuery+="ORDER BY F2_REALCHG DESC ) "

cQuery+=",PRICOM=CASE WHEN A1_PRICOM<>'' THEN CONVERT(varchar(10),CONVERT(smalldatetime, A1_PRICOM), 103) ELSE '' END  "

cQuery+="FROM "
cQuery+=""+RetSqlName("SA3")+" SA3 with (nolock), "+RetSqlName("SA1")+" SA1 with (nolock) "
cQuery+="WHERE "
cQuery+="A1_VEND=A3_COD "
cQuery+="AND A1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery+="AND A1_MSBLQL<>'1' "
cQuery+="AND A1_ATIVO<>'N' "
cQuery+="and SA1.D_E_L_E_T_ <> '*' " 
cQuery+="AND SA3.D_E_L_E_T_ <> '*' "

MemoWrite("C:\TEMP\FXLSCLI.SQL", cQuery)

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

  oSection1:Cell("COORDENADOR"):SetValue(TMP->COORDENADOR)
	oSection1:Cell("COORDENADOR"):SetAlign("LEFT")
	oSection1:Cell("REPRESENTANTE"):SetValue(TMP->REPRESENTANTE)
	oSection1:Cell("REPRESENTANTE"):SetAlign("LEFT")
	oSection1:Cell("COD_SEG"):SetValue(TMP->COD_SEG)
	oSection1:Cell("COD_SEG"):SetAlign("LEFT")
	oSection1:Cell("SEGMENTO"):SetValue(TMP->SEGMENTO)
	oSection1:Cell("SEGMENTO"):SetAlign("LEFT")
	oSection1:Cell("CLIENTE"):SetValue(TMP->CLIENTE)
	oSection1:Cell("CLIENTE"):SetAlign("LEFT")
	oSection1:Cell("LOJA"):SetValue(TMP->LOJA)
	oSection1:Cell("LOJA"):SetAlign("LEFT")
	oSection1:Cell("NOME"):SetValue(TMP->NOME)
	oSection1:Cell("NOME"):SetAlign("LEFT")
	oSection1:Cell("ENDERECO"):SetValue(TMP->ENDERECO)
	oSection1:Cell("ENDERECO"):SetAlign("LEFT")
	oSection1:Cell("BAIRRO"):SetValue(TMP->BAIRRO)
	oSection1:Cell("BAIRRO"):SetAlign("LEFT")
	oSection1:Cell("CIDADE"):SetValue(TMP->CIDADE)
	oSection1:Cell("CIDADE"):SetAlign("LEFT")
	oSection1:Cell("UF"):SetValue(TMP->UF)
	oSection1:Cell("UF"):SetAlign("LEFT")
	oSection1:Cell("CEP"):SetValue(TMP->CEP)
	oSection1:Cell("CEP"):SetAlign("LEFT")
	oSection1:Cell("TELEFONE"):SetValue(TMP->TELEFONE)
	oSection1:Cell("TELEFONE"):SetAlign("LEFT")
	oSection1:Cell("DT_ULT_EMISSAO"):SetValue(TMP->DT_ULT_EMISSAO)
	oSection1:Cell("DT_ULT_EMISSAO"):SetAlign("LEFT")
	oSection1:Cell("PRIMEIRA_COMPRA"):SetValue(TMP->PRICOM)
	oSection1:Cell("PRIMEIRA_COMPRA"):SetAlign("LEFT")
	oSection1:Cell("GRUPO_VENDA"):SetValue(TMP->GRUPO_VENDA)
	oSection1:Cell("GRUPO_VENDA"):SetAlign("LEFT")
	oSection1:Cell("GRUPO_VENDA"):SetValue(TMP->GRUPO_VENDA)
	oSection1:Cell("GRUPO_VENDA"):SetAlign("LEFT")
	//oSection1:Cell("LINHA"):SetValue(TMP->LINHA)
	//oSection1:Cell("LINHA"):SetAlign("LEFT")
	//oSection1:Cell("MEDIA"):SetValue(TMP->MEDIA)
	//oSection1:Cell("MEDIA"):SetAlign("LEFT")
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


