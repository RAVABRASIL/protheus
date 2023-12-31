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
���Descri��o �            RELATORIO FAT POR CLIENTES                     .���
���          �  LINHA                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FXLSFATC()

Local oReport
//Local cPerg	:= "FXLSFA"


//criaSx1(cPerg)
//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������
//Pergunte(cPerg,.T.)
/*
ValidPerg('FXLSFA')

IF !Pergunte('FXLSFA',.T.)

   Return 

ENDIF



if MV_PAR03=1 // CLIENTE

   MsAguarde( { || fFatCli() }, "Aguarde. . .", " " )   

ELSEif MV_PAR03=2   // PRODUTO

   MsAguarde( { || fFatPro() }, "Aguarde. . .", " " )   

ENDIF
*/



oReport:= ReportDef()
oReport:PrintDialog()


Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FISR001  � Autor � Thiago Ewerton         � Data �10.11.2022���
�������������������������������������������������������������������������Ĵ��
���Descri��o �                RELATORIO FAT POR CLIENTES                 .���
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

oReport:= TReport():New("FXLSFATC","RELATORIO DE FATURAMENTO POR CLIENTES","FXLSFATC", {|oReport| ReportPrint(oReport)},"RELATORIO DE FATURAMENTO POR CLIENTES")
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

TRCell():New(oSection1,'COD_COOD'     ,'','COD_COOD'        ,)
TRCell():New(oSection1,'COORDENADOR'     ,'','COORDENADOR'        ,)
TRCell():New(oSection1,'CODIGO'     ,'','CODIGO'        ,)
TRCell():New(oSection1,'REPRESENTANTE'    ,'','REPRESENTANTE' ,)
TRCell():New(oSection1,'CLIENTE'  ,'','CLIENTE'      ,)
TRCell():New(oSection1,'LOJA'  ,'','LOJA'      ,)
TRCell():New(oSection1,'NOME'    ,'','NOME'          ,)
TRCell():New(oSection1,'BRUTO_KG'    ,'','BRUTO_KG'          ,)
TRCell():New(oSection1,'BRUTO_RS'    ,'','BRUTO_RS'          ,)
TRCell():New(oSection1,'DEV_KG'    ,'','DEV_KG'          ,)
TRCell():New(oSection1,'DEV_RS'    ,'','DEV_RS'          ,)
TRCell():New(oSection1,'LIQUIDO_KG'    ,'','LIQUIDO_KG'          ,)
TRCell():New(oSection1,'LIQUIDO_RS'    ,'','LIQUIDO_RS'          ,)
TRCell():New(oSection1,'PRECO_MEDIO'    ,'','PRECO_MEDIO'          ,)
TRCell():New(oSection1,'UF'    ,'','UF'          ,)
TRCell():New(oSection1,'BON_KG'    ,'','BON_KG'          ,)


//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("CODO"),"Produto",.F.)
//oBreak := TRBreak():New(oSection1,oSection1:Cell("REP"),"Total",.F.)
//TRFunction():New(oSection1:Cell("REALPV"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALRS"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)


Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �PONR003 � Autor � THIAGO EWERTON          � Data �20.06.2013���
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
//Local lContinua 	:= .T.


//******************************
// Monta a tabela temporária
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
// Monta a tabela de FATURAMENTO POR CLIENTES
//***********************************


cQuery :="SELECT "

cQuery +="A1_EST,COD_COOD=SA3.A3_SUPER,COORDENADOR=ISNULL((SELECT RTRIM(SA3X.A3_NOME) FROM SA3010 SA3X WHERE SA3X.A3_COD = SA3.A3_SUPER AND SA3X.D_E_L_E_T_ <> '*'),''), "
cQuery +="CODIGO=A3_COD,REPRESENTANTE=RTRIM(A3_NOME), "
cQuery +="CLIENTE=A1_COD,LOJA=A1_LOJA,NOME=RTRIM(A1_NOME), "  

cQuery +="BRUTO_RS=SUM((D2_QUANT)*D2_PRCVEN), "               
cQuery +="BRUTO_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' OR D2_CF IN ('5910','6910','5936','6936') THEN (0) ELSE ((D2_QUANT)*(D2_PESO)) END), "

cQuery +="DEV_RS=SUM((D2_QTDEDEV)*D2_PRCVEN), "               
cQuery +="DEV_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' OR D2_CF IN ('5910','6910','5936','6936') THEN (0) ELSE ((D2_QTDEDEV)*(D2_PESO )) END), "


cQuery +="LIQUIDO_RS=SUM((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN), "               
cQuery +="LIQUIDO_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' OR D2_CF IN ('5910','6910','5936','6936') THEN (0) ELSE ((D2_QUANT-D2_QTDEDEV)*(D2_PESO )) END), "
cQuery +="BON_KG=SUM(CASE WHEN D2_CF IN ('5910','6910','5936','6936') THEN ((D2_QUANT-D2_QTDEDEV)*(D2_PESO )) ELSE (0) END) "

cQuery +="FROM "

cQuery +=""+RetSqlName("SD2")+" SD2 with (nolock), "+RetSqlName("SB1")+" SB1 with (nolock), "+RetSqlName("SF2")+" SF2 with (nolock), "
cQuery +=""+RetSqlName("SA3")+" SA3 with (nolock), "+RetSqlName("SA1")+" SA1 with (nolock) "

cQuery +="WHERE "

cQuery +="D2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND "
cQuery +="F2_VEND1 = A3_COD  AND D2_TIPO = 'N' AND D2_TP != 'AP' AND  "
cQuery +="SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND  "
cQuery +="RTRIM(D2_CF) IN ('5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118','6118','6119','5910','6910','5936','6936') AND "
cQuery +="D2_CLIENTE NOT IN ('031732','031733') AND D2_COD = B1_COD AND SB1.B1_SETOR <>'39' AND "
if MV_PAR04 == 2
	cQuery += "SD2.D2_CLIENTE NOT IN ('006543','007005') and "
endIf
If !Empty(MV_PAR05)
	cQuery += "SD2.D2_FILIAL = '" + mv_par05 + "' AND "
endIf
cQuery +="D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA AND  "
cQuery +="SB1.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' "
cQuery +="GROUP BY    A3_SUPER,A3_COD,RTRIM(A3_NOME), "
cQuery +="A1_COD,A1_LOJA,RTRIM(A1_NOME),A1_EST  "

MemoWrite("C:\TEMP\FXLSFATC.SQL", cQuery)

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

    oSection1:Cell("COD_COOD"):SetValue(TMP->COD_COOD)
	oSection1:Cell("COD_COOD"):SetAlign("LEFT")
	oSection1:Cell("COORDENADOR"):SetValue(TMP->COORDENADOR)
	oSection1:Cell("COORDENADOR"):SetAlign("LEFT")
	oSection1:Cell("CODIGO"):SetValue(TMP->CODIGO)
	oSection1:Cell("CODIGO"):SetAlign("LEFT")
	oSection1:Cell("REPRESENTANTE"):SetValue(TMP->REPRESENTANTE)
	oSection1:Cell("REPRESENTANTE"):SetAlign("LEFT")
	oSection1:Cell("CLIENTE"):SetValue(TMP->CLIENTE)
	oSection1:Cell("CLIENTE"):SetAlign("LEFT")
	oSection1:Cell("LOJA"):SetValue(TMP->LOJA)
	oSection1:Cell("LOJA"):SetAlign("LEFT")
    oSection1:Cell("NOME"):SetValue(TMP->NOME)
	oSection1:Cell("NOME"):SetAlign("LEFT")
	oSection1:Cell("BRUTO_KG"):SetValue(TMP->BRUTO_KG)
	oSection1:Cell("BRUTO_KG"):SetAlign("LEFT")
	oSection1:Cell("BRUTO_RS"):SetValue(TMP->BRUTO_RS)
	oSection1:Cell("BRUTO_RS"):SetAlign("LEFT")
	oSection1:Cell("DEV_KG"):SetValue(TMP->DEV_KG)
	oSection1:Cell("DEV_KG"):SetAlign("LEFT")
	oSection1:Cell("DEV_RS"):SetValue(TMP->DEV_RS)
	oSection1:Cell("DEV_RS"):SetAlign("LEFT")
	oSection1:Cell("LIQUIDO_KG"):SetValue(TMP->LIQUIDO_KG)
	oSection1:Cell("LIQUIDO_KG"):SetAlign("LEFT")
	oSection1:Cell("LIQUIDO_RS"):SetValue(TMP->LIQUIDO_RS)
	oSection1:Cell("LIQUIDO_RS"):SetAlign("LEFT")
	oSection1:Cell("PRECO_MEDIO"):SetValue(TMP->LIQUIDO_RS/TMP->LIQUIDO_KG)
	oSection1:Cell("PRECO_MEDIO"):SetAlign("LEFT")
	//oSection1:Cell("BON_KG"):SetValue(TMP->BON_KG)
	//oSection1:Cell("BON_KG"):SetAlign("LEFT")
	oSection1:Cell("UF"):SetValue(TMP->A1_EST )
	oSection1:Cell("UF"):SetAlign("LEFT")
	oSection1:Cell("BON_KG"):SetValue(TMP->BON_KG )
	oSection1:Cell("BON_KG"):SetAlign("LEFT")

	
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return


