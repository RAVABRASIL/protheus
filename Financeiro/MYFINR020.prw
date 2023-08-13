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
���Programa  �FATR048    � Autor � Gustavo Costa        � Data �06.03.2017���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio BAIXAS COM IPI                                     .���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MYFINR020()

Local oReport
Local cPerg	:= "FINR20"
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

putSx1(cPerg, '01', 'Data Base de?'     	  	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data Base at�?'	  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
//putSx1(cPerg, '03', 'Estado?'     				, '', '', 'mv_ch3', 'C', 2                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Em branco para todo"},{},{})
//putSx1(cPerg, '04', 'Vendedor?'     			, '', '', 'mv_ch4', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Em branco para todo"},{},{})

return  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FISR001  � Autor � Gustavo Costa          � Data �20.09.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio dos valores para conferencia da desonera��o.     .���
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

oReport:= TReport():New("FINR20","Relat�rio de Baixa com IPI","FINR20", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� imprimir o relat�rio de Baixas com IPI.")
//oReport:SetLandscape()
oReport:SetPortrait()

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������Ŀ
//� Variaveis utilizadas para parametros �
//� mv_par01   // Data de                �
//� mv_par02   // Data At�               �
//� mv_par03   // Estado                 �
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

oSection1 := TRSection():New(oReport,"BAIXAS - PER�ODO de " + DtoC(mv_par01) + " at� " + DtoC(mv_par02),{"TAB"}) 

TRCell():New(oSection1,'DIA'		,'','Dia'			,	/*Picture*/		,10				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'NREP'		,'','Representante'	,	/*Picture*/		,20				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'EST'		,'','UF'			,	/*Picture*/		,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,'CIDADE'		,'','Cidade'		,	/*Picture*/		,25				,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2 := TRSection():New(oSection1,"Notas Fiscais",{"TAB"})
oSection2:SetLeftMargin(2)

TRCell():New(oSection2,'SERIE'    	,'','S�rie'			,/*Picture*/	,03	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'NUM'    	,'','T�tulo'		,/*Picture*/	,09	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PARC'    	,'','Parc.'			,/*Picture*/	,03	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'VENCTO'		,'','Vencimento'	,/*Picture*/	,10	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'DTBAIXA'	,'','Dt. Baixa'		,/*Picture*/	,10	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'CLIENTE'	,'','Cliente'		,/*Picture*/	,06	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'LOJA'		,'','Loja'			,/*Picture*/	,02	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'NOME'		,'','Nome'			,/*Picture*/	,50	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'VALOR'		,'','Valor Orig.'	,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'BAIXA'		,'','Valor Baixado'	,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'IPI'		,'','IPI'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)



//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

oBreak := TRBreak():New(oSection1,oSection1:Cell("DIA"),"Total",.F.)
//oBreak := TRBreak():New(oSection1,oSection1:Cell("EST"),"Total",.F.)
//oBreak := TRBreak():New(oSection1,oSection1:Cell("CIDADE"),"Total",.F.)


TRFunction():New(oSection2:Cell("VALOR"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection2:Cell("BAIXA"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
TRFunction():New(oSection2:Cell("IPI"),NIL,"SUM",oBreak,"Total L�quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
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
Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
Local lCabec 	:= .T.
Local cChave	:= ""
Local nTotGeral	:= 0
Local nQtdDias	:= 0

//***********************************
// Monta a tabela de vendas por NCM
//***********************************

cQuery := " SELECT E1_VENCREA, E5_DATA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_CLIENTE, E5_LOJA, A1_NOME, E1_VALOR, E5_VALOR, E5_VLJUROS "
cQuery += " FROM " + RetSqlName("SE5") + " E5 WITH (NOLOCK) "
cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1 WITH (NOLOCK) "
cQuery += " ON E5_CLIENTE + E5_LOJA = A1_COD + A1_LOJA "
cQuery += " INNER JOIN " + RetSqlName("SE1") + " E1 WITH (NOLOCK) "
cQuery += " ON E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO = " 
cQuery += " E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO "
cQuery += " WHERE E5.D_E_L_E_T_ <> '*' "
cQuery += " AND E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DATA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "'"
cQuery += " AND E5_FILIAL = '" + xFilial("SE5") + "' " 
cQuery += " AND E5_RECPAG = 'R' " 
cQuery += " AND E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE','BA','CP' ) " 
cQuery += " AND E5_SITUACA NOT IN ('C' ,'E' ,'X' ) "
cQuery += " AND E5_PREFIXO = '0' " 
cQuery += " ORDER BY E5_DATA, E5_NUMERO "

If Select("TAB") > 0
	DbSelectArea("TAB")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TAB"
TcSetField( "TAB", "E1_VENCREA", "D", 08, 0 )
TcSetField( "TAB", "E5_DATA", "D", 08, 0 )

TAB->( DbGoTop() )

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
	cChave	:= DtoC(TAB->E5_DATA)
	
	If lCabec

		oSection1:Cell("DIA"):SetValue(TAB->E5_DATA)
		oSection1:Cell("DIA"):SetAlign("LEFT")
		oSection1:PrintLine()

		//oSection1:Finish()
		nQtdDias++
			
		oSection2:Init()
		lCabec	:= .F.

	EndIf

	oSection2:Cell("SERIE"):SetValue(TAB->E5_PREFIXO)
	oSection2:Cell("SERIE"):SetAlign("CENTER")
	oSection2:Cell("NUM"):SetValue(TAB->E5_NUMERO)
	oSection2:Cell("NUM"):SetAlign("CENTER")
	oSection2:Cell("PARC"):SetValue(TAB->E5_PARCELA)
	oSection2:Cell("PARC"):SetAlign("CENTER")
	oSection2:Cell("VENCTO"):SetValue(TAB->E1_VENCREA)
	oSection2:Cell("VENCTO"):SetAlign("CENTER")
	oSection2:Cell("DTBAIXA"):SetValue(TAB->E5_DATA)
	oSection2:Cell("DTBAIXA"):SetAlign("CENTER")
	oSection2:Cell("CLIENTE"):SetValue(TAB->E5_CLIENTE)
	oSection2:Cell("CLIENTE"):SetAlign("CENTER")
	oSection2:Cell("LOJA"):SetValue(TAB->E5_LOJA)
	oSection2:Cell("LOJA"):SetAlign("CENTER")
	oSection2:Cell("NOME"):SetValue(TAB->A1_NOME)
	oSection2:Cell("NOME"):SetAlign("LEFT")
	oSection2:Cell("VALOR"):SetValue(TAB->E1_VALOR)
	oSection2:Cell("VALOR"):SetAlign("RIGHT")
	oSection2:Cell("BAIXA"):SetValue(TAB->E5_VALOR - TAB->E5_VLJUROS)
	oSection2:Cell("BAIXA"):SetAlign("RIGHT")
	oSection2:Cell("IPI"):SetValue((TAB->E5_VALOR - TAB->E5_VLJUROS) * 0.1 )
	oSection2:Cell("IPI"):SetAlign("RIGHT")
	
	nTotGeral	:= nTotGeral + ((TAB->E5_VALOR - TAB->E5_VLJUROS) * 0.1)
	oSection2:PrintLine()
	//oReport:SkipLine()     
	TAB->(dbSkip())
	
	If cChave <> DtoC(TAB->E5_DATA)
	
		oSection1:Finish()
		oSection2:Finish()
		lCabec := .T.
		
		If TAB->(!Eof())
			oSection1:Init()
		EndIf
		
	EndIf
EndDo

oReport:SkipLine()     
oReport:Say(oReport:Row(),oReport:Col(),"TOTAL DO PER�ODO  ===  " + TRANSFORM(nTotGeral,"@E 9,999,999.99") )
oReport:SkipLine()     
oReport:Say(oReport:Row(),oReport:Col(),"M�DIA POR DIA  ===  " + TRANSFORM(nTotGeral/nQtdDias,"@E 999,999.99") )

dbCloseArea("TAB")

Set Filter To

Return




