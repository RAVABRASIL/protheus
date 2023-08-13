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
���Programa  �FATR051    � Autor � Gustavo Costa        � Data �06.03.2017���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio LEVANTAMENTO CLIENTES XDD                          .���
���          �  LINHA                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FATR051()

Local oReport
Local cPerg	:= "FATR51"
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

oReport:= TReport():New("FATR51","Relatorio de avalia��o de clientes XDD","FATR51", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� imprimir a avalia��o de clientes XDD.")
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

Pergunte(oReport:uParam,.T.)

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

oSection1 := TRSection():New(oReport,"PER�ODO de " + DtoC(mv_par01) + " at� " + DtoC(mv_par02),{"TAB"}) 

TRCell():New(oSection1,'REP'		,'','Cod.'			,	/*Picture*/		,04				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NREP'		,'','Representante'	,	/*Picture*/		,20				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EST'		,'','UF'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CLIENTE'	,'','Codigo'		,	/*Picture*/		,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'LOJA'		,'','Loja'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NOME'		,'','Nome'			,	/*Picture*/		,35				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DENTRO'    	,'','Faturamento'	,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'FORA'		,'','XDD'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PERCXDD'	,'','% XDD'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'MEDIA'		,'','Media Venda'	,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DIASAT'		,'','Media Atraso'	,'@E 99999999'			,14	,/*lPixel*/,/*{|| code-block de impressao }*/)
//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("REP"),"Total",.F.)


//TRFunction():New(oSection1:Cell("METAKG"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("METAPV"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("METARS"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALKG"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
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
Local cQuery 		:= ""
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local lContinua 	:= .T.
Local aFds 		:= {}
Local aMeta		:= {}
Local cLinha	:= ""
Local nMeses	:= round((mv_par02 - mv_par01)/30, 0)

//******************************
// Monta a tabela tempor�ria
//******************************

Aadd( aFds , {"REP"			,"C",004,000} )
Aadd( aFds , {"EST"			,"C",002,000} )
Aadd( aFds , {"NREP"		,"C",020,000} )
Aadd( aFds , {"CLIENTE"		,"C",006,000} )
Aadd( aFds , {"LOJA" 		,"C",002,000} )
Aadd( aFds , {"NOME"		,"C",035,000} )
Aadd( aFds , {"DENTRO" 		,"N",016,002} )
Aadd( aFds , {"FORA"		,"N",016,002} )
Aadd( aFds , {"PERCXDD" 	,"N",016,002} )
Aadd( aFds , {"MEDIA" 		,"N",016,002} )
Aadd( aFds , {"DIASAT"		,"N",016,002} )

coTbl := CriaTrab( aFds, .T. )
Use (coTbl) Alias TAB New Exclusive
dbCreateIndex(coTbl,'REP+CLIENTE+LOJA', {|| REP+CLIENTE+LOJA })

//***********************************
// Monta a tabela de vendas por NCM
//***********************************

cQuery := " SELECT SUBSTRING(F2_VEND1,1,4) VENDEDOR, A3_NREDUZ NOME, A1_COD, A1_LOJA, A1_NOME, A1_EST, "  
cQuery += " SUM( CASE WHEN F2_SERIE = '' THEN (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ELSE 0 END ) AS 'FORA', "  
cQuery += " SUM( CASE WHEN F2_SERIE = '0' THEN (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ELSE 0 END ) AS 'DENTRO' "
cQuery += " FROM SD2020 SD2 WITH (NOLOCK) " 
cQuery += " INNER JOIN SF2020 SF2 WITH (NOLOCK) " 
cQuery += " ON D2_FILIAL = F2_FILIAL " 
cQuery += " AND D2_DOC = F2_DOC " 
cQuery += " AND D2_SERIE = F2_SERIE " 
cQuery += " INNER JOIN SB1010 SB1 WITH (NOLOCK) " 
cQuery += " ON D2_COD = B1_COD " 
cQuery += " INNER JOIN SA3010 WITH (NOLOCK) " 
cQuery += " ON SUBSTRING(F2_VEND1,1,4) = A3_COD " 
cQuery += " INNER JOIN SA1010 SA1 WITH (NOLOCK) " 
cQuery += " ON D2_CLIENTE + D2_LOJA = A1_COD+A1_LOJA " 
cQuery += " WHERE " 
cQuery += " SB1.B1_TIPO =   'PA'   AND " 
cQuery += " SD2.D2_CF IN (  '5101'  ,  '5107'  ,  '6101'  ,  '5102'  ,  '6102'  ,  '6109'  ,  '6107'  ,  '5949'  ,  '6949'  ,  '5922'  ,  '6922'  ,  '5116'  ,  '6116'  ,  '6108'  ,  '5118'  ,  '6118'   ) AND " 
cQuery += " SB1.B1_SETOR <>   '39'   AND "  
cQuery += " SD2.D2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' AND " 
cQuery += " SB1.D_E_L_E_T_ =   ''   AND " 
cQuery += " SF2.D_E_L_E_T_ =   ''   AND " 
cQuery += " SD2.D_E_L_E_T_ =   ''	AND " 
cQuery += " F2_CLIENTE + F2_LOJA IN ( "
cQuery += " SELECT F2_CLIENTE + F2_LOJA FROM SF2020 " 
cQuery += " WHERE D_E_L_E_T_ <> '*' AND F2_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' AND F2_SERIE = '' "
cQuery += " ) "
If !Empty(mv_par03)
	cQuery += " AND F2_VEND1 = '" + AllTrim(mv_par03) + "' "
EndIf
If !Empty(mv_par04)
	cQuery += " AND F2_EST = '" + AllTrim(mv_par04) + "' "
EndIf
cQuery += " GROUP BY SUBSTRING(F2_VEND1,1,4), A3_NREDUZ, A1_COD, A1_LOJA, A1_NOME, A1_EST "
cQuery += " ORDER BY SUBSTRING(F2_VEND1,1,4), A3_NREDUZ, A1_COD, A1_LOJA "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

TMP->( DbGoTop() )

//******************************
//PREENCHE COM O REALIZADO
//******************************
While TMP->(!Eof())
	
	RecLock("TAB",.T.)
	
	Replace TAB->EST 		with TMP->A1_EST
	Replace TAB->REP 		with TMP->VENDEDOR
	Replace TAB->NREP 		with TMP->NOME
	Replace TAB->CLIENTE 	with TMP->A1_COD 
	Replace TAB->LOJA 		with TMP->A1_LOJA
	Replace TAB->NOME 		with TMP->A1_NOME
	Replace TAB->DENTRO 	with TMP->DENTRO
	Replace TAB->FORA		with TMP->FORA
	Replace TAB->PERCXDD 	with (TMP->FORA / (TMP->DENTRO + TMP->FORA)) * 100
	Replace TAB->MEDIA		with (TMP->DENTRO + TMP->FORA) / nMeses
	Replace TAB->DIASAT		with 9999
	
	MsUnlock()
	TMP->(dbSkip())

EndDo

cQuery := " SELECT E1_VEND1, E1_CLIENTE, E1_LOJA, AVG( CAST(CONVERT(smalldatetime, E1_BAIXA,101) - CONVERT(smalldatetime, E1_VENCREA,101) AS INT)) VALOR "
cQuery += " FROM SE1020 E1 " 
cQuery += " WHERE E1.D_E_L_E_T_ <>  '*' "
cQuery += " AND E1_EMISSAO BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
cQuery += " AND E1_TIPO NOT IN ('NCC','RA') " 
cQuery += " AND E1_BAIXA <> '' " 
cQuery += " AND E1_BAIXA >= E1_VENCREA "
cQuery += " AND E1_PREFIXO = '' "
If !Empty(mv_par03)
	cQuery += " AND E1_VEND1 = '" + AllTrim(mv_par03) + "' "
EndIf
cQuery += " GROUP BY E1_VEND1, E1_CLIENTE, E1_LOJA "

If Select("TMP2") > 0
	DbSelectArea("TMP2")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP2"

TMP2->( DbGoTop() )

//******************************
//PREENCHE COM O META OS ESTADOS QUE N�O TIVERAM VEDAS
//******************************
While TMP2->(!Eof())
	
	If TAB->(dbSeek(subStr(TMP2->E1_VEND1,1,4) + TMP2->E1_CLIENTE + TMP2->E1_LOJA))
	
		RecLock("TAB",.F.)
		
		Replace TAB->DIASAT 	with TMP2->VALOR
		
		MsUnlock()

	EndIf

	TMP2->(dbSkip())

EndDo


TAB->( DbGoTop() )
oReport:SetMeter(TAB->(RecCount()))


//��������������������������������������������������������������Ŀ
//�	Processando a Sessao 1                                       �
//����������������������������������������������������������������

oSection1:Init()
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:Say(oReport:Row(),oReport:Col(),"PER�ODO de " + DtoC(mv_par01) + " at� " + DtoC(mv_par02) )
oSection1:PrintLine()
oReport:SkipLine()
oReport:ThinLine()

While !oReport:Cancel() .And. TAB->(!Eof())

	oReport:IncMeter()

	oSection1:Cell("EST"):SetValue(TAB->EST)
	oSection1:Cell("EST"):SetAlign("CENTER")
	oSection1:Cell("REP"):SetValue(TAB->REP)
	oSection1:Cell("REP"):SetAlign("LEFT")
	oSection1:Cell("NREP"):SetValue(TAB->NREP)
	oSection1:Cell("NREP"):SetAlign("LEFT")
	oSection1:Cell("CLIENTE"):SetValue(TAB->CLIENTE)
	oSection1:Cell("CLIENTE"):SetAlign("LEFT")
	oSection1:Cell("LOJA"):SetValue(TAB->LOJA)
	oSection1:Cell("LOJA"):SetAlign("RIGHT")
	oSection1:Cell("NOME"):SetValue(TAB->NOME)
	oSection1:Cell("NOME"):SetAlign("LEFT")
	oSection1:Cell("DENTRO"):SetValue(TAB->DENTRO)
	oSection1:Cell("DENTRO"):SetAlign("RIGHT")
	oSection1:Cell("FORA"):SetValue(TAB->FORA)
	oSection1:Cell("FORA"):SetAlign("RIGHT")
	oSection1:Cell("PERCXDD"):SetValue(TAB->PERCXDD)
	oSection1:Cell("PERCXDD"):SetAlign("RIGHT")
	oSection1:Cell("MEDIA"):SetValue(TAB->MEDIA)
	oSection1:Cell("MEDIA"):SetAlign("RIGHT")
	oSection1:Cell("DIASAT"):SetValue(TAB->DIASAT)
	oSection1:Cell("DIASAT"):SetAlign("RIGHT")
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TAB->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TAB")
dbCloseArea("TMP")
dbCloseArea("TMP2")
Set Filter To

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun����o    � fValMeta   � Autor � Gustavo Costa     � Data �  06/03/17  ���
�������������������������������������������������������������������������͹��
���Descri��o � Retorna o valor da meta por representante.                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function fValMeta(cRep, cAno, cLinha, cUF)

local cQry		:= ''
Local aRet		:= {}

cQry:=" SELECT Z51_MVALOR/12 MVALOR, Z51_MFATOR FROM Z51020 "
cQry+=" WHERE Z51_REPRES = '" + cRep + "' "
cQry+=" AND Z51_ANO = '" + cAno + "' "
cQry+=" AND Z51_LINHA = '" + cLinha + "' "
cQry+=" AND D_E_L_E_T_ <> '*' "
cQry+=" AND Z51_UF = '" + cUF + "'"

TCQUERY cQry NEW ALIAS  "TMP3"

dbSelectArea("TMP3")
TMP3->(dbGoTop())

If Select("TMP3") > 0

	AADD(aRet, TMP3->MVALOR)
	AADD(aRet, TMP3->Z51_MFATOR)

Else

	AADD(aRet, 0)
	AADD(aRet, 0)

EndIf

TMP3->(dbclosearea())

Return aRet

