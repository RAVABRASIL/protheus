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
���Programa  �ESTR017  � Autor � Gustavo Costa          � Data �03.03.2015���
�������������������������������������������������������������������������Ĵ��
���Descri��o   �Relatorio das Interferencias na Expedi��o das NFS.         .���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ESTR017()

Local oReport
Local cPerg	:= "ESTR17"

Private lJob		:= .F.

//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//N�o consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SX1" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Relatorio Interferencias na Expedi��o das NFS... '+Dtoc(DATE())+' - '+Time())
		lJob := .T.
	EndIf

	If	lJob
		oReport:= ReportDef()
		oReport:Print(.F.)
	Else
		criaSx1(cPerg)
		//������������������������������������������������������������������������Ŀ
		//�Interface de impressao                                                  �
		//��������������������������������������������������������������������������
		
		oReport:= ReportDef()
		oReport:PrintDialog()
	EndIf

	If	( lJob )
		RpcClearEnv()		   				//Libera o Environment
		ConOut('Relatorio Interferencias na Expedi��o das NFS. '+Dtoc(DATE())+' - '+Time())
	EndIf


Return

//+-----------------------------------------------------------------------------------------------+
//! Fun��o para cria��o das perguntas (se n�o existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Data de?'     	, '', '', 'mv_ch1', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Data inicial"},{},{})
putSx1(cPerg, '02', 'Data at�?'  		, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
putSx1(cPerg, '03', 'Nota Fiscal?' 	, '', '', 'mv_ch3', 'C', 9                     	, 0, 0, 'G', '', 'SF2', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Em branco para todos"},{},{})
putSx1(cPerg, '04', 'Cliente?'			, '', '', 'mv_ch4', 'C', 9                     	, 0, 0, 'G', '', 'SF2', '', '', 'mv_par04','','','','','','','','','','','','','','','','',{"Em branco para todos"},{},{})

return  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ESTR017  � Autor � Gustavo Costa          � Data �03.03.2015���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio das Interferencias na Expedi��o das NFS            .���
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

oReport:= TReport():New("ESTR17","Interferencias na Expedi��o das NFS " ,"ESTR17", {|oReport| ReportPrint(oReport)},"Este relat�rio ir� listar as Interferencias na Expedi��o das NFS.")
//oReport:SetLandscape()
oReport:SetPortrait()

If lJob
	oReport:nDevice	 	:= 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
	oReport:cEmail		:= GetNewPar("MV_XESTR17",'gustavo@ravaembalagens.com.br')
EndIf

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

oSection1 := TRSection():New(oReport,"Nota Fiscal",{"TMP"}) 

TRCell():New(oSection1,'DOC'			,'','N. Fiscal'		,	/*Picture*/				,09				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'SERIE'			,'','Serie'			,	/*Picture*/				,03				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'CLIENTE'		,'','Cliente'			,	/*Picture*/				,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'LOJA'			,'','Loja'				,	/*Picture*/				,02				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'NOME'			,'','Nome'				,	/*Picture*/				,40				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EMISSAO'		,'','Dt. Emissao'		,	/*Picture*/				,10				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'EXPED'			,'','Dt. Exped.'		,	/*Picture*/				,10				,/*lPixel*/,/*{|| code-block de impressao }*/)

//��������������������������������������������������������������Ŀ
//� Sessao 2                                                     �
//����������������������������������������������������������������
oSection2 := TRSection():New(oSection1,"Interferencias",{"TMP"})
oSection2:SetLeftMargin(2)

TRCell():New(oSection2,'DATA'    		,'','Data'			,/*Picture*/	,10	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'HORA'			,'','Hora'			,/*Picture*/	,05	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'TIPO'			,'','Tipo'			,/*Picture*/	,25	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'CODPRO'			,'','Codigo'		,/*Picture*/	,15	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PRODUTO'		,'','Produto'		,/*Picture*/	,52	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'EXPEDI'			,'','Expedidor'	,/*Picture*/	,25	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'SEPARA'			,'','Separador'	,/*Picture*/	,25	,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New(oSection1,oSection1:Cell("DOC"),"Nota Fiscal:",.F.)

//New(oParent,uBreak,uTitle,lTotalInLine,cName,lPageBreak)
//TRFunction():New(oSection2:Cell("DESCO"),NIL,"SUM",oBreak,"Total Horas Descontadas",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)

Return(oReport)

/*/
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
��������������������������������������������������������������������������ٱ�
/*/

Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
Local oSection2 	:= oReport:Section(1):Section(1)
Local cQuery 		:= ""
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local lPula	 	:= .T.
Local lOK 			:= .T.
Local d1			:= IIF(lJob,FirstDay(dDataBase),mv_par01)
Local d2			:= IIF(lJob,dDataBase-1,mv_par02)
Local cNF			:= IIF(lJob,"",mv_par03)
Local cCliente	:= IIF(lJob,"",mv_par04)
Local lCabec		:= .T.
Local lJustif		:= .F.

PRIVATE lMudouDia	:= .F.
PRIVATE dDiaAtu	:= CtoD("  /  /  ")
PRIVATE dDiaAnt	:= CtoD("  /  /  ")

mv_par01 := d1

DbSelectArea("Z90")
DbSelectArea("Z91")
//��������������������������������������������������������������Ŀ
//�	Processando a Sessao 1                                       �
//����������������������������������������������������������������

oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"PER�ODO de " + DtoC(d1) + " at� " + DtoC(d2) )
If !Empty(cNF)
	oReport:SkipLine()
	oReport:Say(oReport:Row(),oReport:Col(),"Nota Fiscal - " + cNf )
EndIf

If !Empty(cCliente)
	oReport:SkipLine()
	oReport:Say(oReport:Row(),oReport:Col(),"Cliente - " + cCliente )
EndIf
oReport:SkipLine()


cQuery := " SELECT DISTINCT F2_SERIE, F2_DOC, F2_CLIENTE, F2_LOJA, A1_NOME, F2_EMISSAO, F2_DTEXP  FROM " + RetSqlName("SF2") + " F2 " 
cQuery += " INNER JOIN " + RetSqlName("SA1") + " A1 " 
cQuery += " ON F2_CLIENTE = A1_COD "
cQuery += " AND F2_LOJA = A1_LOJA "
cQuery += " INNER JOIN " + RetSqlName("SD2") + " D2 " 
cQuery += " ON F2_FILIAL = D2_FILIAL "
cQuery += " AND F2_DOC = D2_DOC "
cQuery += " AND F2_SERIE = D2_SERIE "
cQuery += " WHERE F2.D_E_L_E_T_ <> '*' "
cQuery += " AND F2_EMISSAO BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "'"
cQuery += " AND F2_SERIE = '0' "
cQuery += " AND F2_TIPO = 'N' "
cQuery += " AND SUBSTRING(D2_CF,1,2) IN ('51','52','61','62') " 

If !Empty(cNF)
	cQuery += " AND F2_DOC = '" + cNF + "' "
EndIf

If !Empty(cCliente)
	cQuery += " AND F2_CLIENTE = '" + cCliente + "'
EndIf

cQuery += " ORDER BY F2_DOC "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
TCSetField( "TMP", "F2_EMISSAO", "D")
TCSetField( "TMP", "F2_DTEXP", "D")

nCount	:= TMP->(RECCOUNT())
TMP->( DbGoTop() )
		
oReport:SetMeter(nCount)
	
While !oReport:Cancel() .And. TMP->(!EOF())

	oReport:IncMeter()
	
	fHisExp(TMP->F2_DOC)

	dbSelectArea("ZZA")
	If dbSeek(xFilial("ZZA") + TMP->F2_DOC + TMP->F2_SERIE)
	
		lJustif	:= .T.
			
	EndIf

	dbSelectArea("TMP2")

	If TMP2->(!Eof())
	
		While TMP2->(!Eof()) 
	
			If TMP2->ZZ9_STATUS <> 'C' .OR. lJustif
				lPula		:= .F.
			EndIf
			
			TMP2->(dbSkip())
			
		EndDo
	
		If lPula
			
			dbselectArea("TMP")
			TMP->(dbSkip())
			lPula	:= .T.
			Loop
			
		EndIf
	
	EndIf
	
	If lCabec

		oSection1:Init()
		
		oReport:SkipLine()     
		oSection1:Cell("DOC"):SetValue(TMP->F2_DOC)
		oSection1:Cell("DOC"):SetAlign("CENTER")
		oSection1:Cell("SERIE"):SetValue(TMP->F2_SERIE)
		oSection1:Cell("SERIE"):SetAlign("CENTER")
		oSection1:Cell("CLIENTE"):SetValue(TMP->F2_CLIENTE)
		oSection1:Cell("CLIENTE"):SetAlign("CENTER")
		oSection1:Cell("LOJA"):SetValue(TMP->F2_LOJA)
		oSection1:Cell("LOJA"):SetAlign("LEFT")
		oSection1:Cell("NOME"):SetValue(TMP->A1_NOME)
		oSection1:Cell("NOME"):SetAlign("LEFT")
		oSection1:Cell("EMISSAO"):SetValue(TMP->F2_EMISSAO)
		oSection1:Cell("EMISSAO"):SetAlign("CENTER")
		oSection1:Cell("EXPED"):SetValue(TMP->F2_DTEXP)
		oSection1:Cell("EXPED"):SetAlign("CENTER")

		oSection1:PrintLine()
		//oReport:SkipLine()     
		oSection1:Finish()
			
		oSection2:Init()
		lCabec	:= .F.

	EndIf
		
	TMP2->(dbGoTop())
	
	If TMP2->(!Eof())
	
		While TMP2->(!Eof()) 
		
			If TMP2->ZZ9_STATUS <> 'C'
			
				oSection2:Cell("DATA"):SetValue(TMP2->ZZ9_DATA)
				oSection2:Cell("DATA"):SetAlign("CENTER")
				oSection2:Cell("HORA"):SetValue(TMP2->ZZ9_HORA)
				oSection2:Cell("HORA"):SetAlign("RIGHT")
				
				Do Case
	
					Case TMP2->ZZ9_STATUS == 'D'
						cStatus	:= "DUPLICADO"
					Case TMP2->ZZ9_STATUS == 'E'
						cStatus	:= "NAO FAZ PARTE DA NOTA"
					Case TMP2->ZZ9_STATUS == 'M'
						cStatus	:= "MAIOR QUE A QUANTIDADE"
	
				EndCase
				
				oSection2:Cell("TIPO"):SetValue(cStatus)
				oSection2:Cell("TIPO"):SetAlign("LEFT")
				oSection2:Cell("CODPRO"):SetValue(TMP2->Z00_CODIGO)
				oSection2:Cell("CODPRO"):SetAlign("LEFT")
				oSection2:Cell("PRODUTO"):SetValue(POSICIONE("SB1",1,xFilial("SB1") + TMP2->Z00_CODIGO, "B1_DESC"))
				oSection2:Cell("PRODUTO"):SetAlign("LEFT")
				oSection2:Cell("EXPEDI"):SetValue(UPPER(TMP2->ZZ9_EXPEDI))
				oSection2:Cell("EXPEDI"):SetAlign("RIGHT")
				oSection2:Cell("SEPARA"):SetValue(UPPER(TMP2->ZZ9_SEPARA))
				oSection2:Cell("SEPARA"):SetAlign("RIGHT")
				oSection2:PrintLine()
				
				lOK	:= .F.
				
			EndIf
				
			TMP2->(dbSkip())
			
		EndDo
	
		If lJustif
		
			oReport:SkipLine()
			oReport:Say(oReport:Row(),oReport:Col(),"PRODUTO INCOMPLETO: " + ZZA->ZZA_PROD + "Justificativa - " + ZZA->ZZA_JUSTIF )
			oReport:SkipLine()	
		
		EndIf
		
		
	Else
	
		cStatus	:= "N�O CONFERIDO"
		
		oSection2:Cell("DATA"):SetValue("")
		oSection2:Cell("DATA"):SetAlign("CENTER")
		oSection2:Cell("HORA"):SetValue("")
		oSection2:Cell("HORA"):SetAlign("RIGHT")
		oSection2:Cell("TIPO"):SetValue(cStatus)
		oSection2:Cell("TIPO"):SetAlign("LEFT")
		oSection2:Cell("CODPRO"):SetValue("")
		oSection2:Cell("CODPRO"):SetAlign("LEFT")
		oSection2:Cell("PRODUTO"):SetValue("")
		oSection2:Cell("PRODUTO"):SetAlign("LEFT")
		oSection2:Cell("EXPEDI"):SetValue("")
		oSection2:Cell("EXPEDI"):SetAlign("RIGHT")
		oSection2:Cell("SEPARA"):SetValue("")
		oSection2:Cell("SEPARA"):SetAlign("RIGHT")
		oSection2:PrintLine()
	
		If lJustif
		
			oReport:SkipLine()
			oReport:Say(oReport:Row(),oReport:Col(),"Justificativa - " + ZZA->ZZA_JUSTIF )
			oReport:SkipLine()	
		
		EndIf




	EndIf	
	

	oSection2:Finish()
	oSection1:Finish()
	lCabec		:= .T.
	lPula		:= .T.
	lJustif	:= .F.

	dbselectArea("TMP")
	TMP->(dbSkip())

EndDo

dbCloseArea("TMP")

Set Filter To

Return


//------------------------------------------------------------------------------------------
/*
Pegas as interferencias nas expedi��es das notas fiscais de sa�da.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C�digo
@version   1.xx
@since     03/03/2015
/*/
//------------------------------------------------------------------------------------------
Static Function fHisExp(cNF)

Local cQuery	:= ""

cQuery := " SELECT Z.*, Z00_CODIGO FROM " + RetSqlName("ZZ9") + " Z "
cQuery += " INNER JOIN " + RetSqlName("Z00") + " C "
cQuery += " ON SUBSTRING(ZZ9_PRODOP,7,6) = Z00_SEQ "
cQuery += " WHERE ZZ9_DOC = '" + cNF + "' "
cQuery += " AND Z.D_E_L_E_T_ <> '*' "
cQuery += " AND C.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY ZZ9_DOC, Z00_CODIGO "


If Select("TMP2") > 0
	DbSelectArea("TMP2")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP2"
TCSetField( "TMP2", "ZZ9_DATA", "D")

Return 

