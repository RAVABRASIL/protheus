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
���Programa  �FXLSREC    � Autor � THIAGO EWERTON       � Data �18.11.2022���
�������������������������������������������������������������������������Ĵ��
���Descri��o �           RELATORIO REALIZADO POR CLIENTES                .���
���          �  LINHA                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FXLSREC()

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
���Programa  �FXLSREC  � Autor � Thiago Ewerton         � Data �10.11.2022���
�������������������������������������������������������������������������Ĵ��
���Descri��o �          RELATORIO REALIZADO POR CLIENTES                 .���
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

oReport:= TReport():New("FXLSREC","RELATORIO REALIZADO POR CLIENTES","FXLSREC", {|oReport| ReportPrint(oReport)},"RELATORIO REALIZADO POR CLIENTES")
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

//TRCell():New(oSection1,'CARTATU'	,'','Carteira'		,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSection1,'CODIGO'     ,'','CODIGO'        ,)
TRCell():New(oSection1,'VENDEDOR'     ,'','VENDEDOR'        ,)
TRCell():New(oSection1,'CLIENTE'     ,'','CLIENTE'        ,)
TRCell():New(oSection1,'LOJA'    ,'','LOJA' ,)
TRCell():New(oSection1,'NOME'  ,'','NOME'      ,)
TRCell():New(oSection1,'PEDIDO'  ,'','PEDIDO'      ,)
TRCell():New(oSection1,'VENDIDO_KG'    ,'','VENDIDO_KG'          ,)
TRCell():New(oSection1,'VENDIDO_R$'    ,'','VENDIDO_R$'          ,)
//TRCell():New(oSection1,'PRECO_MEDIO'    ,'','PRECO_MEDIO'          ,)



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
���Programa  �FXLSREC � Autor � THIAGO EWERTON        � Data �18.11.2022���
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


*/
//***********************************
// Monta a tabela
//***********************************


cQuery :="SELECT "
cQuery +="C5_VEND1 ,A3_NOME,A1_COD,A1_LOJA,A1_NOME,C5_NUM, "
//cQuery +="SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC ) AS VENDIDO_RS ,SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO) AS VENDIDO_KG     , "
cQuery +="VENDIDO_RS=SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC ),"
cQuery +="VENDIDO_KG=SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO), "
cQuery +="DEV_KG = ISNULL(SUM(SD2.D2_QTDEDEV * SB1.B1_PESO),0), "
cQuery +="DEV_RS = ISNULL(SUM((SD2.D2_QTDEDEV*SC6.C6_PRUNIT)-SC6.C6_VALDESC ),0), "
// 
cQuery +="PED_REJ_KG= ISNULL(SUM(C9_QTDLIB2),0) , "
cQuery +="PED_REJ_RS= ISNULL(SUM((C9_QTDLIB*SC6.C6_PRUNIT)-SC6.C6_VALDESC),0) "
//
cQuery +="FROM  "
cQuery +=""+RetSqlName("SC6")+" SC6 (NOLOCK) "
cQuery +="left  JOIN "+RetSqlName("SC5")+" SC5 (NOLOCK) "
cQuery +="ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery +="AND SC5.C5_ENTREG BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND SC5.D_E_L_E_T_ = ' ' "

cQuery +="JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) "
cQuery +="ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "

cQuery +="JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) "
cQuery +="ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_='' "

cQuery +="JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) "
cQuery +="ON B1_COD=C6_PRODUTO  AND SB1.B1_SETOR <> '39'  and SB1.D_E_L_E_T_='' "

cQuery +="left JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) "
cQuery +="ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV and SD2.D2_QTDEDEV > 0 AND SD2.D_E_L_E_T_ = ' ' "
cQuery +="AND SD2.D2_QTDEDEV > 0 "
//
cQuery +="left JOIN SC9020 SC9 (NOLOCK) "
cQuery +="ON C6_FILIAL = C9_FILIAL AND C9_NFISCAL = '' AND C9_SEQUEN  = '01' AND C9_BLCRED IN ('09') AND "
cQuery +="C5_ENTREG BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND A1_COD = C9_CLIENTE AND A1_LOJA = C9_LOJA AND "
cQuery +="C9_PRODUTO = B1_COD AND C6_NUM = C9_PEDIDO  AND SC9.D_E_L_E_T_ = ''  "
//
cQuery +="WHERE "
cQuery +="SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery +="SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118' ) AND "
cQuery +="SC6.D_E_L_E_T_ = ' ' "

cQuery +="group by C5_VEND1 ,A3_NOME,A1_COD,A1_LOJA,A1_NOME,C5_NUM "

MemoWrite("C:\TEMP\FXLSREC.SQL", cQuery)

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

    oSection1:Cell("CODIGO"):SetValue(TMP->C5_VEND1)
	oSection1:Cell("CODIGO"):SetAlign("LEFT")
	oSection1:Cell("VENDEDOR"):SetValue(TMP->A3_NOME)
	oSection1:Cell("VENDEDOR"):SetAlign("LEFT")
	oSection1:Cell("CLIENTE"):SetValue(TMP->A1_COD)
	oSection1:Cell("CLIENTE"):SetAlign("LEFT")
	oSection1:Cell("LOJA"):SetValue(TMP->A1_LOJA)
	oSection1:Cell("LOJA"):SetAlign("LEFT")
    oSection1:Cell("NOME"):SetValue(TMP->A1_NOME)
	oSection1:Cell("NOME"):SetAlign("LEFT")
	oSection1:Cell("PEDIDO"):SetValue(TMP->C5_NUM)
	oSection1:Cell("PEDIDO"):SetAlign("LEFT")
	oSection1:Cell("VENDIDO_KG"):SetValue(TMP->VENDIDO_KG-TMP->DEV_KG)
	oSection1:Cell("VENDIDO_KG"):SetAlign("LEFT")
	oSection1:Cell("VENDIDO_R$"):SetValue(TMP->VENDIDO_RS-TMP->DEV_RS)
	oSection1:Cell("VENDIDO_R$"):SetAlign("LEFT")
	//oSection1:Cell("PRECO_MEDIO"):SetValue(TMP->(((TMP->VENDIDO_RS-AUXZ->DEV_RS)-TMP->PED_REJ_RS)/((TMP->VENDIDO_KG-TMP->DEV_KG)-TMP->PED_REJ_KG)))
	//oSection1:Cell("PRECO_MEDIO"):SetAlign("LEFT")
	
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return


