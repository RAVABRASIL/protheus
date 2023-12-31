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
���Programa  �FXLSTEL2   � Autor � THIAGO EWERTON       � Data �10.11.2022���
�������������������������������������������������������������������������Ĵ��
���Descri��o �            RELATORIO LISTA TELEFONICA                            .���
���          �  LINHA                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FXLSTEL2()

Local oReport
Local cPerg	:= "FXLSTEL"

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

return  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FXLSTEL2  � Autor � THIAGO EWERTON        � Data �10.11.2022���
�������������������������������������������������������������������������Ĵ��
���Descri��o �              RELATORIO DE LISTA TELEFONICA                       .���
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

oReport:= TReport():New("FXLSTEL2","RELAT�RIO DE LISTA TELEFONICA","FXLSTEL2", {|oReport| ReportPrint(oReport)},"RELAT�RIO DE LISTA TELEFONICA")
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


TRCell():New(oSection1,'GERENTE'     ,'','GERENTE'        ,)
TRCell():New(oSection1,'NOME_GERENTE'     ,'','NOME_GERENTE'        ,)
TRCell():New(oSection1,'REPRESENTANTE'    ,'','REPRESENTANTE' ,)
TRCell():New(oSection1,'NOME_REPRESENTANTE'  ,'','NOME_REPRESENTANTE'      ,)
TRCell():New(oSection1,'DATA'  ,'','DATA'      ,)
TRCell():New(oSection1,'HORA'     ,'','HORA'       ,)
TRCell():New(oSection1,'DURACAO'     ,'','DURACAO'       ,)
TRCell():New(oSection1,'TELEFONE'     ,'','TELEFONE'       ,)
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
���Programa  �FXLSTEL2 � Autor � THIAGO EWERTON         � Data �20.06.2022���
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
// Monta a tabela de LISTA TELEFONICA
//***********************************

cQuery :="SELECT NOME_GEREN=(ISNULL((SELECT RTRIM(SA3X.A3_NOME) FROM SA3010 SA3X WHERE SA3X.A3_COD = Z53_GERENT AND SA3X.D_E_L_E_T_ <> '*'),'')),NOME_REP='',REP='',* FROM "+RetSqlName("Z53")+" Z53 "
cQuery +="WHERE Z53_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery +="AND Z53.D_E_L_E_T_='' "
cQuery +="ORDER BY Z53_DATA,Z53_HORA,Z53_GERENT "

MemoWrite("C:\TEMP\FXLSTEL2.SQL", cQuery)

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
/*
while TMP->(!EOF())
    aInf:=FCODNOM(TMP->Z53_TEL)
    IF !EMPTY(aInf[1][1])
       AADD(aArray,{TMP->Z53_GERENT,TMP->NOME_GERENT,aInf[1][1],aInf[1][2],DTOC(STOD(TMP->Z53_DATA)),TMP->Z53_HORA,TMP->Z53_DURACA,TMP->Z53_TEL})
    ENDIF
    TMP->(DBSKIP())
Enddo
*/
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

    oSection1:Cell("GERENTE"):SetValue(TMP->Z53_GERENT)
	oSection1:Cell("GERENTE"):SetAlign("LEFT")
	oSection1:Cell("NOME_GERENTE"):SetValue(TMP->NOME_GEREN)
	oSection1:Cell("NOME_GERENTE"):SetAlign("LEFT")
	oSection1:Cell("REPRESENTANTE"):SetValue(TMP->REP)
	oSection1:Cell("REPRESENTANTE"):SetAlign("LEFT")
	oSection1:Cell("NOME_REPRESENTANTE"):SetValue(TMP->NOME_REP)
	oSection1:Cell("NOME_REPRESENTANTE"):SetAlign("LEFT")
	oSection1:Cell("DATA"):SetValue(TMP->Z53_DATA)
	oSection1:Cell("DATA"):SetAlign("LEFT")
	oSection1:Cell("HORA"):SetValue(TMP->Z53_HORA)
	oSection1:Cell("HORA"):SetAlign("LEFT")
	oSection1:Cell("DURACAO"):SetValue(TMP->Z53_DURACA)
	oSection1:Cell("DURACAO"):SetAlign("LEFT")
	oSection1:Cell("TELEFONE"):SetValue(TMP->Z53_TEL)
	oSection1:Cell("TELEFONE"):SetAlign("LEFT")
	
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return


