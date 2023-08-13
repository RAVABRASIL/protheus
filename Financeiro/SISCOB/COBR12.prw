#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �COBR12 � Autor � Gustavo Costa            � Data �08.07.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio para demonstrar o atendimento de cobran�a com os  ���
���          �clientes.                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function COBR12()

Local oReport
Local cPerg	:= "COBR12"
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
putSx1(cPerg, '03', 'Atendente?'         	, '', '', 'mv_ch3', 'C', 6							, 0, 0, 'G', '', 'USR', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Em Branco para Todos"},{},{})
putSx1(cPerg, '04', 'Cliente?' 		      	, '', '', 'mv_ch4', 'C', TAMSX3("A1_COD")[1]   	, 0, 0, 'G', '', 'SA1', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Em Branco para Todos"},{},{})
putSx1(cPerg, '05', 'Resultado?'  			, '', '', 'mv_ch5', 'C', 1   						, 0, 0, 'G', '', ''   , '', '', 'mv_par05','1=Consulta','','','2=Liga��o Negativa','','','3=Liga��o Positiva','','','4=Email','','','5=Todos','','','', {"Resultados dos atendimentos"},{},{})
putSx1(cPerg, '06', 'Imp. Conversa?'  		, '', '', 'mv_ch6', 'C', 1    						, 0, 0, 'G', '', ''   , '', '', 'mv_par06','Sim','Si','Yes','','Nao','No','No','','','','','','','','','',{"Imprime o conteudo da conversa registada"},{},{})
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

oReport:= TReport():New("COBR12","Historico de Cobran�a","COBR12", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� imprimir o Hist�rico das cobran�as.")
//oReport:SetLandscape()
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

oSection1 := TRSection():New(oReport,"Atendente:",{"TMP"}) 

TRCell():New(oSection1,'CODATE'		,'','Matricula',	/*Picture*/		,06			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NOMATE'    ,'','Nome'		,	/*Picture*/		,20			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CODCLI'		,'','Cod. Cli.',	/*Picture*/		,06			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NOMCLI'		,'','Cliente'	,	/*Picture*/		,20			,/*lPixel*/,/*{|| code-block de impressao }*/)

//��������������������������������������������������������������Ŀ
//� Sessao 2                                                     �
//����������������������������������������������������������������
oSection2 := TRSection():New(oSection1,"Hist�rico",{"TMP"})
oSection2:SetLeftMargin(2)

TRCell():New(oSection2,'DATA'	,'','Data'			,/*Picture*/						,08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'HORAINI','','Hora Ini.'	,/*Picture*/						,08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'HORAFIM','','Hora Fim'	,/*Picture*/						,08,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'TEMPO'	,'','Tempo'		,/*PesqPict('SPH','PH_QUANTC',6)*/	,08,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'TIPO'	,'','Tipo'			,/*Picture*/						,09,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'RESULT'	,'','Resultado'	,/*Picture*/						,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'MEMO'	,'','Texto'		,/*Picture*/						,100,/*lPixel*/,/*{|| code-block de impressao }*/,,.T.)

//oSection2:SetHeaderPage()
//��������������������������������������������������������������Ŀ
//� Sessao 3                                                     �
//����������������������������������������������������������������
oSection3 := TRSection():New(oSection2,"Totais",{"TMP"})
oSection3:SetLeftMargin(3)

TRCell():New(oSection3,'REG'	,''	,'Registros'			,"999999"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
//TRCell():New(oSection3,'HA'		,'','Horas Ativas'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
//TRCell():New(oSection3,'HR'		,'','Horas Receptivas'	,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'TCONS'	,''	,'Tot. H Consul.'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'THPOS'	,'','Tot. H Posit.'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'THNEG'	,'','Tot. H Negat.'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'TEMAI'	,'','Tot. H Email'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'TBOL'	,'','Tot. H Boleto'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
TRCell():New(oSection3,'TH'		,'','TOTAL de HORAS'		,"999.99"			,08,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,,,,.T.)
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
Local nHoraAt		:= 0
Local nTotHora	:= 0
Local nCont		:= 0
Local nTotHoraG	:= 0
Local nContG		:= 0
Local nTotCons	:= 0
Local nTotLNeg	:= 0
Local nTotLPos	:= 0
Local nTotEmail	:= 0
Local nTotBol		:= 0
Local nTotGCons	:= 0
Local nTotGLNeg	:= 0
Local nTotGLPos	:= 0
Local nTotGEmail	:= 0
Local nTotGBol	:= 0

cQuery := " SELECT *, "
cQuery += " ISNULL(CONVERT(VARCHAR(1024),CONVERT(VARBINARY(1024),[ZA2].[ZA2_MEMO])),'') AS [MEMO] "
cQuery += " FROM " + RetSqlName("ZA2") + " ZA2 WITH (NOLOCK) "
cQuery += " WHERE ZA2.D_E_L_E_T_ <> '*' "
cQuery += " AND ZA2_DTATEN BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
cQuery += " AND ZA2_HRFIM <> ''"

If !Empty(mv_par03)
	cQuery += " AND ZA2_CODATE = '" + mv_par03 + "' "
EndIf

If !Empty(mv_par04)
	cQuery += " AND ZA2_CODCLI = '" + mv_par04 + "' "
EndIf

If mv_par05 <> 5
	cQuery += " AND ZA2_RESULT = '" + STR(mv_par05) + "' "
EndIf

cQuery += " ORDER BY ZA2_CODCLI, ZA2_DTATEN, ZA2_HRINI, ZA2_RESULT "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( 'TMP', 'ZA2_DTATEN', 'D' )

TMP->( DbGoTop() )


//��������������������������������������������������������������Ŀ
//�	Processando a Sessao 1                                       �
//����������������������������������������������������������������
oReport:SetMeter(TMP->(LastRec()))

While !oReport:Cancel() .And. TMP->(!Eof())

	oReport:IncMeter()

	If lContinua	
		
		If cMatAnt <> TMP->ZA2_CODCLI
			
			oSection1:Init()
			oReport:SkipLine()     
	
			oSection1:Cell("CODATE"):SetValue(TMP->ZA2_CODATE)
			oSection1:Cell("CODATE"):SetAlign("CENTER")
			oSection1:Cell("NOMATE"):SetValue(TMP->ZA2_NOMATE)
			oSection1:Cell("NOMATE"):SetAlign("LEFT")
			oSection1:Cell("CODCLI"):SetValue(TMP->ZA2_CODCLI)
			oSection1:Cell("CODCLI"):SetAlign("CENTER")
			oSection1:Cell("NOMCLI"):SetValue(TMP->ZA2_NOMCLI)
			oSection1:Cell("NOMCLI"):SetAlign("LEFT")
			
			oSection1:PrintLine()
			oReport:SkipLine()     
			oSection1:Finish()
			
			oSection2:Init()
			oSection3:Init()
	
		EndIf

		//��������������������������������������������������������������Ŀ
		//�	Impressao da Sessao 2                                        �
		//����������������������������������������������������������������

		oSection2:Cell("DATA"):SetValue(TMP->ZA2_DTATEN)
		oSection2:Cell("DATA"):SetAlign("CENTER")
		oSection2:Cell("HORAINI"):SetValue(TMP->ZA2_HRINI)
		oSection2:Cell("HORAINI"):SetAlign("CENTER")
		oSection2:Cell("HORAFIM"):SetValue(TMP->ZA2_HRFIM)
		oSection2:Cell("HORAFIM"):SetAlign("LEFT")
		oSection2:Cell("TEMPO"):SetValue(fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
		oSection2:Cell("TEMPO"):SetAlign("RIGHT")
		
		Do Case
			Case ZA2_RESULT == "1"
				oSection2:Cell("RESULT"):SetValue("Consulta")
				nTotCons	:= SomaHoras(nTotCons,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				nTotGCons	:= SomaHoras(nTotGCons,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				//MsgAlert("Consulta")
			Case ZA2_RESULT == "2"
				oSection2:Cell("RESULT"):SetValue("Liga��o Negativa")
				nTotLNeg	:= SomaHoras(nTotLNeg,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				nTotGLNeg	:= SomaHoras(nTotGLNeg,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				//MsgAlert("Liga��o Negativa")
			Case ZA2_RESULT == "3"
				oSection2:Cell("RESULT"):SetValue("Liga��o Positiva")
				nTotLPos	:= SomaHoras(nTotLPos,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				nTotGLPos	:= SomaHoras(nTotGLPos,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				//MsgAlert("Liga��o Positiva")
			Case ZA2_RESULT == "4"
				oSection2:Cell("RESULT"):SetValue("Email")
				nTotEmail	:= SomaHoras(nTotEmail,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				nTotGEmail	:= SomaHoras(nTotGEmail,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				//MsgAlert("Email")
			Case ZA2_RESULT == "5"
				oSection2:Cell("RESULT"):SetValue("Boleto")
				nTotBol	:= SomaHoras(nTotBol,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				nTotGBol	:= SomaHoras(nTotGBol,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
				//MsgAlert("Boleto")
			Otherwise
				oSection2:Cell("RESULT"):SetValue("")
		EndCase
				
		//oSection2:Cell("TIPO"):SetValue(IIF(TMP->ZA2_TIPO = 'R',"Receptivo","Ativo"))
		//oSection2:Cell("TIPO"):SetAlign("LEFT")
		oSection2:Cell("RESULT"):SetAlign("CENTER")
		
		If mv_par06 == 1
				oSection2:Cell("MEMO"):SetValue(Alltrim(TMP->MEMO))
				oSection2:Cell("MEMO"):SetAlign("LEFT")
		EndIf
		
		If TMP->ZA2_TIPO = 'C'
			nHoraAt	:= SomaHoras(nHoraAt,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
		EndIf

		nTotHora	:= SomaHoras(nTotHora,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
		nCont++
		nTotHoraG	:= SomaHoras(nTotHoraG,fDifHora(TMP->ZA2_HRINI, TMP->ZA2_HRFIM))
		nContG++
		
		oSection2:PrintLine()
		//oReport:SkipLine()     
		
		cMatAnt := TMP->ZA2_CODCLI
		
		TMP->(dbSkip())
		
		If cMatAnt <> TMP->ZA2_CODCLI .and. cMatAnt <> '' 
			
			oReport:SkipLine()
			oSection3:Cell("REG"):SetValue(nCont)
			oSection3:Cell("REG"):SetAlign("RIGHT")
			oSection3:Cell("TCONS"):SetValue(nTotCons)
			oSection3:Cell("TCONS"):SetAlign("RIGHT")
			oSection3:Cell("THPOS"):SetValue(nTotLPos)
			oSection3:Cell("THPOS"):SetAlign("RIGHT")
			oSection3:Cell("THNEG"):SetValue(nTotLNeg)
			oSection3:Cell("THNEG"):SetAlign("RIGHT")
			oSection3:Cell("TEMAI"):SetValue(nTotEmail)
			oSection3:Cell("TEMAI"):SetAlign("RIGHT")
			oSection3:Cell("TBOL"):SetValue(nTotBol)
			oSection3:Cell("TBOL"):SetAlign("RIGHT")

			//oSection3:Cell("HA"):SetValue(nHoraAt)
			//oSection3:Cell("HA"):SetAlign("RIGHT")
			//oSection3:Cell("HR"):SetValue(nTotHora - nHoraAt)
			//oSection3:Cell("HR"):SetAlign("RIGHT")
			oSection3:Cell("TH"):SetValue(nTotHora)
			oSection3:Cell("TH"):SetAlign("RIGHT")
			
			oSection3:PrintLine()

			oReport:SkipLine()
			
			oSection2:Finish()
			oSection3:Finish()
			nTotHora	:= 0
			nCont		:= 0
			nHoraAt	:= 0
			nTotCons	:= 0
			nTotLNeg	:= 0
			nTotLPos	:= 0
			nTotEmail	:= 0
			nTotBol	:= 0
		EndIf
		
	EndIf

EndDo

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

//oSection1:Finish()
//-- Devolve a condicao original do arquivo principal
dbCloseArea("TMP")
Set Filter To

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �fDifHora � Autor � Gustavo Costa          � Data �20.06.2013���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao para retornar o tempo entre duas horas passadas como ���
���          �parametros (texto).                                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function fDifHora(cHini, cHfim)

Local cRet

cRet	:= ELAPTIME(cHini, cHfim)

Return cRet
