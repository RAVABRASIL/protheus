#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FINR14 � Autor � Gustavo Costa           � Data �27.08.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio para conferencia das comiss�es geradas pela baixa.���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FINR14()

Local oReport
Local cPerg	:= "FINR14"
criaSx1(cPerg)
//������������������������������������������������������������������������Ŀ
//�Interface de impressao                                                  �
//��������������������������������������������������������������������������

oReport:= ReportDef()
oReport:PrintDialog()


Return

//+-----------------------------------------------------------------------------------------------+
//! Fun��o para cria��o das perguntas (se n�o existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data de?'            , '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data at�?'           , '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
putSx1(cPerg, '03', 'Vendedor?'       		, '', '', 'mv_ch3', 'C',TAMSX3("A3_COD")[1]		, 0, 0, 'G', '', 'SA3', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Em Branco para Todos"},{},{})
putSx1(cPerg, '04', 'Filial'	  	    	, '', '', 'mv_ch4', 'C',2   						, 0, 0, 'G', '', 'SM0', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Em Branco para Todos"},{},{})
putSx1(cPerg, '05', 'Considera CMP?'		, '', '', 'mv_ch5', 'C', 1   						, 0, 0, 'G', '', ''   , '', '', 'mv_par05','1=Sim','','','2=N�o','','','','','','','','','','','','', {"Considera as compensa��es?"},{},{})
//putSx1(cPerg, '06', 'Imp. Conversa?'  		, '', '', 'mv_ch6', 'C', 1    						, 0, 0, 'G', '', ''   , '', '', 'mv_par06','Sim','Si','Yes','','Nao','No','No','','','','','','','','','',{"Imprime o conteudo da conversa registada"},{},{})
//putSx1(cPerg, '07', 'CC at�?'      		, '', '', 'mv_ch7', 'C', TAMSX3("RA_CC")[1]    	, 0, 0, 'G', '', 'CTT', '', '', 'mv_par07')

return  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �COBR12  � Autor � Gustavo Costa           � Data �20.06.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio para demonstrar o atendimento de cobran�a com os  ���
���          �clientes.                                                   ���
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

oReport:= TReport():New("FINR14","Detalhe Comiss�es","FINR14", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� imprimir o detalhamento das comiss�es.")
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

Pergunte(oReport:uParam,.F.)

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

oSection1 := TRSection():New(oReport,"Atendente:",{"TMP"}) 

TRCell():New(oSection1,'CODVEN'		,'','C�digo'	,	/*Picture*/		,06			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NOMVEN'    ,'','Nome'		,	/*Picture*/		,50			,/*lPixel*/,/*{|| code-block de impressao }*/)

//��������������������������������������������������������������Ŀ
//� Sessao 2                                                     �
//����������������������������������������������������������������
oSection2 := TRSection():New(oSection1,"Hist�rico",{"TMP"})
oSection2:SetLeftMargin(2)

TRCell():New(oSection2,'PRE'		,'','Pre.'			,	/*Picture*/		,03			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'NUM'		,'','N�mero'		,	/*Picture*/		,09			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PARC'		,'','Par.'			,	/*Picture*/		,02			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'MOTIVO'		,'','Mot.'			,	/*Picture*/		,03			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'DATABX'		,'','Data Baixa'	,/*Picture*/			,08			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'VALBX'		,'','Val. Baixa'	,PesqPict('SE1','E1_VALOR',14),14			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'VALBC'		,'','Base Calc.'	,PesqPict('SE1','E1_VALOR',14),14			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'VALBASE'	,'','Val. Base'	,PesqPict('SE1','E1_VALOR',14),14			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'VALJUR'		,'','Val. Juros'	,PesqPict('SE1','E1_VALOR',14),14			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'VALDESC'	,'','Val. Desc.'	,PesqPict('SE1','E1_VALOR',14),14			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PERC'		,'','%'			,/*PesqPict('SPH','PH_QUANTC',6)*/	,08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'VALOR'		,'','Valor'		,PesqPict('SE1','E1_VALOR',14),14,/*lPixel*/,/*{|| code-block de impressao }*/)

//oSection2:SetHeaderPage()
//��������������������������������������������������������������Ŀ
//� Sessao 3                                                     �
//����������������������������������������������������������������

oSection3 := TRSection():New(oSection2,"Totais",{"TMP"})
oSection3:SetLeftMargin(3)

TRCell():New(oSection3,'TBASE'		,''	,'Total Base'			,PesqPict('SE1','E1_VALOR',14),14,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'TBAIXA'		,'','Total Baixa'			,PesqPict('SE5','E5_VALOR',14),14,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'TCOMS'		,'','Total Comis.'		,PesqPict('SE3','E3_COMIS',14),14,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
//TRCell():New(oSection3,'TCONS'	,''	,'Tot. H Consul.'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
//TRCell():New(oSection3,'THPOS'	,'','Tot. H Posit.'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
//TRCell():New(oSection3,'THNEG'	,'','Tot. H Negat.'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)


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
Local oSection3 	:= oReport:Section(1):Section(1):Section(1)
Local cQuery 		:= ""
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local lContinua 	:= .T.
Local nTotBase	:= 0
Local nTotComis	:= 0
Local nTotBx		:= 0

cQuery := " SELECT E5_FILIAL, E1_VEND1, E5_TIPODOC, E5_SEQ, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_VALOR, E5_VLJUROS, E5_VLDESCO, E5_MOTBX, E5_DATA "
cQuery += " FROM " + RetSqlName("SE5") + " E5 WITH (NOLOCK) "
cQuery += " INNER JOIN " + RetSqlName("SE1") + " E1 WITH (NOLOCK) "
cQuery += " ON E5_FILIAL = E1_FILIAL "
cQuery += " AND E5_NUMERO = E1_NUM "
cQuery += " AND E5_PREFIXO = E1_PREFIXO "
cQuery += " AND E5_PARCELA = E1_PARCELA "
cQuery += " AND E5_TIPO = E1_TIPO "
cQuery += " WHERE E5.D_E_L_E_T_ <> '*' "
cQuery += " AND E1.D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DATA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
cQuery += " AND E5_RECPAG = 'R' "
cQuery += " AND E5_TIPO NOT IN ('RA') "

If !Empty(mv_par03)
	cQuery += " AND E1_VEND1 = '" + mv_par03 + "' "
EndIf

If !Empty(mv_par04)
	cQuery += " AND E1_FILIAL = '" + mv_par04 + "' "
	cQuery += " AND E5_FILIAL = '" + mv_par04 + "' "
EndIf

If mv_par05 == "1"
	cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','BA','CP','MT','DB') "
Else
	cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','BA','MT','DB') "
EndIf

//cQuery += " --AND E1_TIPO NOT IN ('NCC') "
//cQuery += " --AND E5_BENEF = 'P' "
cQuery += " ORDER BY E1_VEND1, E5_PREFIXO, E5_NUMERO, E5_PARCELA "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( 'TMP', 'E5_DATA', 'D' )

TMP->( DbGoTop() )


//��������������������������������������������������������������Ŀ
//�	Processando a Sessao 1                                       �
//����������������������������������������������������������������
oReport:SetMeter(TMP->(LastRec()))

While !oReport:Cancel() .And. TMP->(!Eof())

	oReport:IncMeter()
	
	//Verifica se a baixa foi estornada
	If fVerEstor(TMP->E5_PREFIXO, TMP->E5_NUMERO, TMP->E5_PARCELA, TMP->E5_SEQ)
		
		TMP->(dbSkip())
		Loop
	
	EndIf
	
	If lContinua	
		
		If cMatAnt <> TMP->E1_VEND1
			
			oSection1:Init()
			oReport:SkipLine()     
	
			oSection1:Cell("CODVEN"):SetValue(TMP->E1_VEND1)
			oSection1:Cell("CODVEN"):SetAlign("CENTER")
			oSection1:Cell("NOMVEN"):SetValue(Posicione("SA3",1, xFilial("SA3") + TMP->E1_VEND1, "A3_NOME"))
			oSection1:Cell("NOMVEN"):SetAlign("LEFT")
			
			oSection1:PrintLine()
			oReport:SkipLine()     
			oSection1:Finish()
			
			oSection2:Init()
			oSection3:Init()
	
		EndIf

		//��������������������������������������������������������������Ŀ
		//�	Impressao da Sessao 2                                        �
		//����������������������������������������������������������������

		oSection2:Cell("PRE"):SetValue(TMP->E5_PREFIXO)
		oSection2:Cell("PRE"):SetAlign("CENTER")
		oSection2:Cell("NUM"):SetValue(TMP->E5_NUMERO)
		oSection2:Cell("NUM"):SetAlign("CENTER")
		oSection2:Cell("PARC"):SetValue(TMP->E5_PARCELA)
		oSection2:Cell("PARC"):SetAlign("CENTER")
		oSection2:Cell("MOTIVO"):SetValue(TMP->E5_MOTBX)
		oSection2:Cell("MOTIVO"):SetAlign("CENTER")
		
		//oSection2:Cell("TIPO"):SetValue(IIF(TMP->ZA2_TIPO = 'R',"Receptivo","Ativo"))
		//oSection2:Cell("TIPO"):SetAlign("LEFT")
		oSection2:Cell("DATABX"):SetValue(TMP->E5_DATA)
		oSection2:Cell("DATABX"):SetAlign("CENTER")
		oSection2:Cell("VALBX"):SetValue(TMP->E5_VALOR)
		oSection2:Cell("VALBX"):SetAlign("RIGHT")
		oSection2:Cell("VALJUR"):SetValue(TMP->E5_VLJUROS)
		oSection2:Cell("VALJUR"):SetAlign("RIGHT")
		oSection2:Cell("VALDESC"):SetValue(TMP->E5_VLDESCO)
		oSection2:Cell("VALDESC"):SetAlign("RIGHT")
		
		If TMP->E5_PREFIXO <> ''
			oSection2:Cell("VALBC"):SetValue(TMP->E5_VALOR / 1.15)
			oSection2:Cell("VALBC"):SetAlign("RIGHT")
		Else
			oSection2:Cell("VALBC"):SetValue(TMP->E5_VALOR)
			oSection2:Cell("VALBC"):SetAlign("RIGHT")
		EndIf
			
		dbSelectArea("SE3")
		dbSetOrder(1)
		If SE3->(dbSeek( TMP->E5_FILIAL + TMP->E5_PREFIXO + TMP->E5_NUMERO + TMP->E5_PARCELA + TMP->E5_SEQ ))
			oSection2:Cell("VALBASE"):SetValue(SE3->E3_BASE)
			oSection2:Cell("VALBASE"):SetAlign("RIGHT")
			oSection2:Cell("PERC"):SetValue(SE3->E3_PORC)
			oSection2:Cell("PERC"):SetAlign("RIGHT")
			oSection2:Cell("VALOR"):SetValue(SE3->E3_COMIS)
			oSection2:Cell("VALOR"):SetAlign("RIGHT")
			nTotBase	+= SE3->E3_BASE
			nTotComis	+= SE3->E3_COMIS
		Else
			oSection2:Cell("VALBASE"):SetValue(0)
			oSection2:Cell("VALBASE"):SetAlign("RIGHT")
			oSection2:Cell("PERC"):SetValue(0)
			oSection2:Cell("PERC"):SetAlign("RIGHT")
			oSection2:Cell("VALOR"):SetValue(0)
			oSection2:Cell("VALOR"):SetAlign("RIGHT")
		EndIf
		
		
		oSection2:PrintLine()
		//oReport:SkipLine()     
		
		cMatAnt 	:= TMP->E1_VEND1
		nTotBx		+= TMP->E5_VALOR
		
		dbSelectArea("TMP")
		TMP->(dbSkip())

		If cMatAnt <> TMP->E1_VEND1 .and. cMatAnt <> '' 
			
			oReport:SkipLine()

			oSection3:Cell("TBASE"):SetValue(nTotBase)
			oSection3:Cell("TBASE"):SetAlign("RIGHT")
			oSection3:Cell("TBAIXA"):SetValue(nTotBx)
			oSection3:Cell("TBAIXA"):SetAlign("RIGHT")
			oSection3:Cell("TCOMS"):SetValue(nTotComis)
			oSection3:Cell("TCOMS"):SetAlign("RIGHT")
			
			oSection3:PrintLine()

			oReport:SkipLine()
			
			oSection2:Finish()
			oSection3:Finish()
			nTotBase	:= 0
			nTotComis	:= 0
			nTotBx		:= 0
		EndIf

	EndIf

EndDo

/*
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"RESUMO GERAL")
oReport:ThinLine()
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"TOTAL de REGISTROS GERAL -> " + Transform(nContG,"99999"))
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"TOTAL GERAL DE HORAS:")
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"CONSULTA           -> " + Transform(nTotGCons,"99999.99"))
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"HORAS NEGATIVAS    -> " + Transform(nTotGLNeg,"99999.99"))
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"HORAS POSITIVAS    -> " + Transform(nTotGLPos,"99999.99"))
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"EMAIL              -> " + Transform(nTotGEmail,"99999.99"))
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"BOLETO             -> " + Transform(nTotGBol,"99999.99"))
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"TOTAL GERAL        -> " + Transform(nTotHoraG,"99999.99"))
oReport:SkipLine()
*/
//oSection1:Finish()
//-- Devolve a condicao original do arquivo principal
dbCloseArea("TMP")
Set Filter To

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �fVerEstor � Autor � Gustavo Costa         � Data �28.08.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao para verificar o estorno de uma baixa.               ���
���          �parametros (texto).                                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function fVerEstor(cPre, cNum, cPar, cSeq)

Local lRet	:= .F.
Local cQuery

cQuery := " SELECT E5_TIPODOC, E5_RECPAG, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_VALOR, E5_VLJUROS, E5_VLDESCO, E5_MOTBX, E5_DATA "
cQuery += " FROM " + RetSqlName("SE5") + " E5 WITH (NOLOCK) "
cQuery += " WHERE E5.D_E_L_E_T_ <> '*' "
cQuery += " AND E5_DATA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
cQuery += " AND E5_RECPAG = 'P' "
cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','BA','CP') "
cQuery += " AND E5_TIPO NOT IN ('RA') "
cQuery += " AND E5_PREFIXO = '" + cPre + "' "
cQuery += " AND E5_NUMERO = '" + cNum + "' "
cQuery += " AND E5_PARCELA = '" + cPar + "' "
cQuery += " AND E5_SEQ = '" + cSeq + "' "

If Select("TMP1") > 0
	DbSelectArea("TMP1")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP1"
TCSetField( 'TMP1', 'E5_DATA', 'D' )

TMP1->( DbGoTop() )

If TMP1->(!EOF())
	lRet := .T.
EndIf

DbSelectArea("TMP1")

Return lRet
