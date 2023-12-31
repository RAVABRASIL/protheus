#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �PONR003 � Autor � Gustavo Costa           � Data �20.06.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio para demonstrar o historico do ponto eletronico   ���
���          �dos funcionarios.                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PONR003()

Local oReport
Local cPerg	:= "GPR112"
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

putSx1(cPerg, '01', 'Data de?'            , '', '', 'mv_ch1', 'D', 8                     , 0, 0, 'G', '', ''   , '', '', 'mv_par01')
putSx1(cPerg, '02', 'Data at�?'           , '', '', 'mv_ch2', 'D', 8                     , 0, 0, 'G', '', ''   , '', '', 'mv_par02')
putSx1(cPerg, '03', 'Filial?'          	, '', '', 'mv_ch3', 'C', TAMSX3("C5_FILIAL")[1], 0, 0, 'G', '', 'XM0', '', '', 'mv_par03')
putSx1(cPerg, '04', 'Matricula de?'       , '', '', 'mv_ch4', 'C', TAMSX3("RA_MAT")[1]   , 0, 0, 'G', '', 'SRA_', '', '', 'mv_par04')
putSx1(cPerg, '05', 'Matricula at�?'      , '', '', 'mv_ch5', 'C', TAMSX3("RA_MAT")[1]   , 0, 0, 'G', '', 'SRA_', '', '', 'mv_par05')
putSx1(cPerg, '06', 'CC de?'       		, '', '', 'mv_ch6', 'C', TAMSX3("RA_CC")[1]    , 0, 0, 'G', '', 'CTT', '', '', 'mv_par06')
putSx1(cPerg, '07', 'CC at�?'      		, '', '', 'mv_ch7', 'C', TAMSX3("RA_CC")[1]    , 0, 0, 'G', '', 'CTT', '', '', 'mv_par07')

return  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �PONR003 � Autor � Gustavo Costa           � Data �20.06.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
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

oReport:= TReport():New("PONR003","Historico de Marca��es","GPR112", {|oReport| ReportPrint(oReport)},"Este relatorio ira imprimir o Hist�rico do ponto dos funcion�rios.")
oReport:SetPortrait()

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������Ŀ
//� Variaveis utilizadas para parametros �
//� mv_par01   // Produto de             �
//� mv_par02   // Produto ate            �
//� mv_par03   // Tipo de                �
//� mv_par04   // Tipo ate               �
//� mv_par05   // Grupo de               �
//� mv_par06   // Grupo ate              �
//� mv_par07   // Salta Pagina: Sim/Nao  �
//� mv_par08   // Qual Rev da Estrut     �
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

oSection1 := TRSection():New(oReport,"Funcion�rio:",{"TMP"}) 

TRCell():New(oSection1,'MAT'		,'','Matricula',	/*Picture*/		,06			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NOME'     	,'','Nome',		/*Picture*/		,50			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CC'			,'','C. Custo',	/*Picture*/		,06			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'DESCCC'		,'','Desc. CC',	/*Picture*/		,20			,/*lPixel*/,/*{|| code-block de impressao }*/)

//��������������������������������������������������������������Ŀ
//� Sessao 2                                                     �
//����������������������������������������������������������������
oSection2 := TRSection():New(oSection1,"Hist�rico",{"TMP"})
oSection2:SetLeftMargin(2)

TRCell():New(oSection2,'DATA'	,'','Data'			,/*Picture*/						,08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'CODEV'	,'','Cod. Evento'	,/*Picture*/						,03,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'DESCEV'	,'','Evento'		,/*Picture*/						,25,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'QUANT'	,'','Quant.'		,PesqPict('SPH','PH_QUANTC',6)	,6,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'ABONO'	,'','Cod. Abono'	,/*Picture*/						,03,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'DESCAB'	,'','Abono'		,/*Picture*/						,25,/*lPixel*/,/*{|| code-block de impressao }*/)

//oSection2:SetHeaderPage()

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
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local lContinua := .T.

cQuery := " SELECT PH_DATA, PH_MAT, RA_NOME, RA_CC, CTT_DESC01, PH_PD, P9_DESC, PH_QUANTC, PH_ABONO, P6_DESC, P9_TIPOCOD "
cQuery += " FROM " + RetSqlName("SPH") + " H "
cQuery += " INNER JOIN  " + RetSqlName("SRA") + " RA "
cQuery += " ON PH_FILIAL = RA_FILIAL "
cQuery += " AND PH_MAT = RA_MAT "
cQuery += " INNER JOIN " + RetSqlName("CTT") + " TT "
cQuery += " ON RA_FILIAL = CTT_FILIAL "
cQuery += " AND RA_CC = CTT_CUSTO "
cQuery += " INNER JOIN  " + RetSqlName("SP9") + " P9 "
cQuery += " ON PH_PD = P9_CODIGO "
cQuery += " LEFT OUTER JOIN  " + RetSqlName("SP6") + " P6 "
cQuery += " ON PH_ABONO = P6_CODIGO "
cQuery += " WHERE H.D_E_L_E_T_ <> '*' "
cQuery += " AND PH_DATA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
cQuery += " AND P9_TIPOCOD IN ('1','2') "
cQuery += " AND PH_PD NOT IN ('110','26A','05A','06A','31A','30A') "
cQuery += " AND PH_FILIAL = '" + mv_par03 + "' "
cQuery += " AND PH_MAT BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "' "
cQuery += " AND RA_CC BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "' "
cQuery += " ORDER BY RA_NOME, PH_DATA "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( 'TMP', 'PH_DATA', 'D' )

TMP->( DbGoTop() )


//��������������������������������������������������������������Ŀ
//�	Processando a Sessao 1                                       �
//����������������������������������������������������������������
oReport:SetMeter(TMP->(LastRec()))

While !oReport:Cancel() .And. TMP->(!Eof())

	oReport:IncMeter()

	If lContinua	
		
		If cMatAnt <> TMP->PH_MAT
			
			oSection1:Init()
			oReport:SkipLine()     
	
			oSection1:Cell("MAT"):SetValue(TMP->PH_MAT)
			oSection1:Cell("MAT"):SetAlign("CENTER")
			oSection1:Cell("NOME"):SetValue(TMP->RA_NOME)
			oSection1:Cell("NOME"):SetAlign("LEFT")
			oSection1:Cell("CC"):SetValue(TMP->RA_CC)
			oSection1:Cell("CC"):SetAlign("CENTER")
			oSection1:Cell("DESCCC"):SetValue(TMP->CTT_DESC01)
			oSection1:Cell("DESCCC"):SetAlign("LEFT")
			
			oSection1:PrintLine()
			oReport:SkipLine()     
			oSection1:Finish()
			
			oSection2:Init()
	
		EndIf

		//��������������������������������������������������������������Ŀ
		//�	Impressao da Sessao 2                                        �
		//����������������������������������������������������������������


		oSection2:Cell("DATA"):SetValue(TMP->PH_DATA)
		oSection2:Cell("DATA"):SetAlign("CENTER")
		oSection2:Cell("CODEV"):SetValue(TMP->PH_PD)
		oSection2:Cell("CODEV"):SetAlign("CENTER")
		oSection2:Cell("DESCEV"):SetValue(TMP->P9_DESC)
		oSection2:Cell("DESCEV"):SetAlign("LEFT")
		oSection2:Cell("QUANT"):SetValue(TMP->PH_QUANTC)
		oSection2:Cell("QUANT"):SetAlign("RIGHT")
		oSection2:Cell("ABONO"):SetValue(TMP->PH_ABONO)
		oSection2:Cell("ABONO"):SetAlign("CENTER")
		oSection2:Cell("DESCAB"):SetValue(TMP->P6_DESC)
		oSection2:Cell("DESCAB"):SetAlign("LEFT")

		oSection2:PrintLine()
		//oReport:SkipLine()     
		
		cMatAnt := TMP->PH_MAT
		
		TMP->(dbSkip())
		
		If cMatAnt <> TMP->PH_MAT .and. cMatAnt <> '' 
			oSection2:Finish()
		EndIf
		
	EndIf

EndDo
//oSection1:Finish()
//-- Devolve a condicao original do arquivo principal
dbCloseArea("TMP")
Set Filter To

Return
