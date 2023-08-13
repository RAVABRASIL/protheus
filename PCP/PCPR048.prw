#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FATR050  ³ Autor ³ Gustavo Costa          ³ Data ³05.09.2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o   ³Relatorio Conferencia lote extrusora nas corte solda.      .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPR048()

Local oReport
Local cPerg	:= "PCPR48"

//Private lJob		:= .F.
//Default	cNumLote	:= ''
//ConOut('Relatorio de Conferênca de Lote... '+Dtoc(DATE())+' - '+Time())
criaSx1(cPerg)
oReport:= ReportDef()
oReport:PrintDialog()
/*
//Testa se esta sendo rodado do menu
	If	Select('SX2') == 0
		RPCSetType( 3 )						//Não consome licensa de uso
		RpcSetEnv('02','01',,,,GetEnvServer(),{ "SX1" })
		sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
		ConOut('Ljob = T')
		lJob := .T.
	EndIf

	If	lJob //.OR. cNumLote <> ''
		lJob := .T.
		oReport:= ReportDef()
		oReport:Print(.F.)
	Else
		criaSx1(cPerg)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Interface de impressao                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		mv_par01 := cNumLote
		oReport:= ReportDef()
		oReport:PrintDialog()
	EndIf

	If	( lJob ) .AND. Empty(cNumLote)
		RpcClearEnv()		   				//Libera o Environment
		ConOut('Relatorio de Conferênca de Lote. '+Dtoc(DATE())+' - '+Time())
	EndIf

*/
Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+

static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Lote?'     	, '', '', 'mv_ch1', 'C', 10                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Lote de Produção"},{},{})
//putSx1(cPerg, '02', 'Data até?'  	, '', '', 'mv_ch2', 'D', 8                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par02','','','','','','','','','','','','','','','','',{"Data final"},{},{})
//putSx1(cPerg, '03', 'Pedido?' 		, '', '', 'mv_ch3', 'C', 6                     	, 0, 0, 'G', '', 'SC5', '', '', 'mv_par03','','','','','','','','','','','','','','','','',{"Em branco para todos"},{},{})

return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ESTR017  ³ Autor ³ Gustavo Costa          ³ Data ³03.03.2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de Faturamento Parcial                             .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:= TReport():New("PCPR48","Analise do Lote " + mv_par01 ,"PCPR48", {|oReport| ReportPrint(oReport)},"Este relatório irá listar Conferencia lote extrusora nas corte solda.")
//oReport:SetLandscape()
oReport:SetPortrait()
/*
If lJob
	oReport:nDevice	 	:= 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html.
	ConOut('oReport:nDevice = 3-email')
	oReport:cEmail		:= GetNewPar("MV_XPCPR48",'giancarlo@ravaembalagens.com.br;gustavo@ravaembalagens.com.br')
EndIf
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Data de                ³
//³ mv_par02   // Data Até               ³
//³ mv_par03   // Vendedor               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(oReport:uParam,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira XTMela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 1                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1 := TRSection():New(oReport,"OP",{"XTM"}) 

TRCell():New(oSection1,'OP'				,'','OP'				,	/*Picture*/				,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PROD'			,'','Produto'			,	/*Picture*/				,06				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PROG'			,'','Programado'		,PesqPict('SE1','E1_VALOR') ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'REAL'			,'','Realizado'			,PesqPict('SE1','E1_VALOR') ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'APARA'			,'','Apara'				,PesqPict('SE1','E1_VALOR') ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'PAPARA'			,'','%'					,PesqPict('SE1','E1_VALOR') ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'SITUA'			,'','Status'			,	/*Picture*/				,10				,/*lPixel*/,/*{|| code-block de impressao }*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 2                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1,"Maquinas",{"XTM"})
oSection2:SetLeftMargin(2)

TRCell():New(oSection2,'MAQ'			,'','Maquina'		,/*Picture*/	,06	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'LADO'	    	,'','Lado'			,/*Picture*/	,01	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'OPERADOR'		,'','Operador'		,/*Picture*/	,35	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'QTDREAL'		,'','Realizado'		,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection2,'PERCREAL'		,'','%'				,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'QTDAPARA'		,'','Apara'			,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,'PERCAPARA'		,'','%'				,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 3                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3 := TRSection():New(oSection2,"Bobinas",{"XTM"})
oSection3:SetLeftMargin(3)

TRCell():New(oSection3,'BOBINA'			,'','Cod.Bar Bobina',/*Picture*/	,06	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'DESCBOB'		,'','Produto'		,/*Picture*/	,30	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'QTDBOB'			,'','Saldo Ini.'	,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'SALDOBOB'		,'','Saldo Atu.'	,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,'PERCBOB'		,'','%'				,PesqPict('SE1','E1_VALOR'),14	,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New(oSection1,oSection1:Cell("OP"),"OP:",.F.)

//TRFunction():New(oSection2:Cell("QTDREAL"),NIL,"SUM",oBreak,"Total",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection2:Cell("QTDAPARA"),NIL,"SUM",oBreak,"Total",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)

//New(oParent,uBreak,uTitle,lTotalInLine,cName,lPageBreak)
//TRFunction():New(oSection2:Cell("DESCO"),NIL,"SUM",oBreak,"Total Horas Descontadas",/*Picture*/,/*uFormula*/,.F.,.F.,.F.,oSection2)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)

Return(oReport)

/*/
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
/*/

Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
Local oSection2 	:= oReport:Section(1):Section(1)
Local oSection3 	:= oReport:Section(1):Section(1):Section(1)
Local cQuery 		:= ""
Local cMatAnt		:= ""
Local nNivel   	:= 0
Local lPula	 	:= .T.
Local lOK 			:= .T.
//Local d1			:= IIF(lJob,FirstDay(dDataBase),mv_par01)
//Local d2			:= IIF(lJob,dDataBase-1,mv_par02)
//Local cNF			:= IIF(lJob,"",mv_par03)
//Local cCliente	:= IIF(lJob,"",mv_par04)
Local lCabec		:= .T.
Local lJustif		:= .F.
Local aFds 		:= {}
Local nTReal	:= 0
Local nTApara	:= 0
Local aTReal	:= {}
Local aTApara	:= {}
Local cSitua	:= ""


//mv_par01 := cNumLote

//******************************
// Monta a tabela temporária
//******************************

Aadd( aFds , {"OP"			,"C",006,000} )
Aadd( aFds , {"MAQ"			,"C",006,000} )
Aadd( aFds , {"LADO"		,"C",001,000} )
Aadd( aFds , {"PROD"		,"C",015,000} )
Aadd( aFds , {"PROG" 		,"N",016,002} )
Aadd( aFds , {"MAT"			,"C",006,000} )
Aadd( aFds , {"OPERADOR"	,"C",035,000} )
Aadd( aFds , {"QTDREAL" 	,"N",016,002} )
Aadd( aFds , {"QTDAPARA" 	,"N",016,002} )
Aadd( aFds , {"TREAL" 		,"N",016,002} )
Aadd( aFds , {"TAPARA"	 	,"N",016,002} )


coTbl := CriaTrab( aFds, .T. )
Use (coTbl) Alias XTM New Exclusive
dbCreateIndex(coTbl,'OP+MAQ+LADO+MAT', {|| OP+MAQ+LADO+MAT })


cQuery := " SELECT ZZC_OP, ZZC_PRODPA, ZZ2_MAQ, ZZ2_LADO, ZZ2_MAT, RA_NOME, SUM(ZZ2_QUANT) PESO  FROM " + RetSqlName("ZZC") + " ZC WITH (NOLOCK) "
cQuery += " INNER JOIN " + RetSqlName("ZZ2") + " Z2 WITH (NOLOCK) "
cQuery += " ON ZZC_OP = SUBSTRING(ZZ2_OP,1,6) "
cQuery += " INNER JOIN " + RetSqlName("SRA") + " RA WITH (NOLOCK) "
cQuery += " ON ZZ2_MAT = RA_MAT "
cQuery += " AND ZZ2_FILIAL = RA_FILIAL "
cQuery += " WHERE ZC.D_E_L_E_T_ <> '*' "
cQuery += " AND Z2.D_E_L_E_T_ <> '*' "
cQuery += " AND RA.D_E_L_E_T_ <> '*' "
cQuery += " AND ZZ2_FILIAL = '" + xFilial("ZZ2") + "' "
cQuery += " AND ZZC_LOTE = '" + mv_par01 + "' "
cQuery += " GROUP BY ZZC_OP, ZZC_PRODPA, ZZ2_MAQ, ZZ2_LADO, ZZ2_MAT, RA_NOME "
cQuery += " ORDER BY ZZC_OP, ZZ2_MAQ, ZZ2_LADO "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"
//TCSetField( "TMP", "C5_EMISSAO", "D")



//******************************
//PREENCHE COM O REALIZADO
//******************************
While TMP->(!Eof())
	
	cChave := TMP->ZZC_OP
	
	DbSelectArea("XTM")
	RecLock("XTM",.T.)
	
	Replace XTM->OP 		with TMP->ZZC_OP
	Replace XTM->MAQ 		with TMP->ZZ2_MAQ
	Replace XTM->LADO 		with TMP->ZZ2_LADO
	Replace XTM->PROD 		with TMP->ZZC_PRODPA
	Replace XTM->PROG 		with 0
	Replace XTM->MAT 		with TMP->ZZ2_MAT
	Replace XTM->OPERADOR 	with TMP->RA_NOME
	Replace XTM->QTDREAL 	with TMP->PESO
	Replace XTM->QTDAPARA 	with 0
	
	XTM->(MsUnlock())

	nTReal	:= nTReal + TMP->PESO
	
	DbSelectArea("TMP")
	TMP->(dbSkip())
	
	If cChave <> TMP->ZZC_OP
		
		AADD(aTReal, {cChave,nTReal})
		nTReal	:= 0
		
	EndIf
	

EndDo
dbCloseArea("TMP")
cChave := ""


//******************************
//PREENCHE COM A META QUE É O REALIZADO DA EXTRUSORA
//******************************

cQuery := " SELECT ZZC_OP,ZZC_PRODPA,ZZC_QTDUM,ZZC_UM,ZZC_QTDSUM,ZZC_SEGUM, " 
cQuery += " PESO_KG=ISNULL(sum(CASE WHEN Z00_APARA IN ('') THEN Z00.Z00_PESO+Z00.Z00_PESCAP ELSE 0 END ),0) " 
cQuery += " ,APARA=ISNULL(sum(CASE WHEN Z00_APARA NOT IN ('','W') THEN Z00.Z00_PESO+Z00.Z00_PESCAP ELSE 0 END ),0) " 
cQuery += " FROM ZZC020 ZZC WITH (NOLOCK) " 
cQuery += " LEFT JOIN Z00020 Z00 WITH (NOLOCK) " 
cQuery += " ON Z00_FILIAL='"+XFILIAL('Z00')+"' AND Z00_MAQ LIKE '[E][0123456789]%' AND LEFT(Z00_OP,6)=ZZC_OP  AND Z00.D_E_L_E_T_ = ' ' "  
cQuery += " WHERE ZZC_LOTE = '" + mv_par01 + "' " 
cQuery += " AND ZZC.D_E_L_E_T_ = ' ' " 
cQuery += " GROUP BY ZZC_OP,ZZC_PRODPA,ZZC_QTDUM,ZZC_UM,ZZC_QTDSUM,ZZC_SEGUM "

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

While TMP->(!Eof())
	
	dbselectArea("XTM")
	
	If XTM->(dbSeek(TMP->ZZC_OP ))
		
		While XTM->OP == TMP->ZZC_OP
		
			RecLock("XTM",.F.)
			
			Replace XTM->PROG 		with TMP->PESO_KG
			
			MsUnlock()
			XTM->(dbSkip())
			
		EndDo
		
	EndIf
	dbselectArea("TMP")
	TMP->(dbSkip())

EndDo
dbCloseArea("TMP")


//******************************
//PREENCHE COM A APARA DE CADA OPERADOR
//******************************

cQuery := " SELECT ZZC_OP, ZZC_PRODPA, Z00_MAQ, Z00_LADO, Z00_OPERAD, RA_NOME, "
cQuery += " SUM(Z00_PESO) APARA " 
cQuery += " FROM Z00020 Z00 WITH (NOLOCK) "
cQuery += " INNER JOIN ZZC020 ZZC WITH (NOLOCK) "
cQuery += " ON LEFT(Z00_OP,6) = ZZC_OP "
cQuery += " AND Z00_FILIAL = ZZC_FILIAL "
cQuery += " INNER JOIN SRA020 "
cQuery += " ON Z00_OPERAD = RA_MAT "
cQuery += " AND RA_FILIAL = '01' "
cQuery += " WHERE Z00_APARA NOT IN ('','*') "
cQuery += " AND Z00.D_E_L_E_T_ <> '*' "
cQuery += " AND ZZC_LOTE = '" + mv_par01 + "' " 
cQuery += " GROUP BY ZZC_OP, ZZC_PRODPA, Z00_MAQ, Z00_LADO, Z00_OPERAD, RA_NOME " 
cQuery += " ORDER BY ZZC_OP, Z00_MAQ, Z00_LADO " 


If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

While TMP->(!Eof())
	
	cChave := TMP->ZZC_OP
	dbselectArea("XTM")
	
	If XTM->(dbSeek(TMP->ZZC_OP+TMP->Z00_MAQ+TMP->Z00_LADO+TMP->Z00_OPERAD))
		
		RecLock("XTM",.F.)
			
		Replace XTM->QTDAPARA 	with TMP->APARA
			
		XTM->(MsUnlock())

	Else
	
		RecLock("XTM",.T.)
		
		Replace XTM->OP 		with TMP->ZZC_OP
		Replace XTM->MAQ 		with TMP->Z00_MAQ
		Replace XTM->LADO 		with TMP->Z00_LADO
		Replace XTM->PROD 		with TMP->ZZC_PRODPA
		Replace XTM->PROG 		with 0
		Replace XTM->MAT 		with TMP->Z00_OPERAD
		Replace XTM->OPERADOR 	with TMP->RA_NOME
		Replace XTM->QTDREAL 	with 0
		Replace XTM->QTDAPARA 	with TMP->APARA
		
		XTM->(MsUnlock())
	
	EndIf

	nTApara	:= nTApara + TMP->APARA
	
	dbselectArea("TMP")
	TMP->(dbSkip())
	
	If cChave <> TMP->ZZC_OP
		
		AADD(aTApara, {cChave,nTApara})
		nTApara	:= 0
		
	EndIf
	

EndDo
dbCloseArea("TMP")
cChave := ""

For x := 1 to Len(aTReal)

	dbselectArea("XTM")
	
	If XTM->(dbSeek(aTReal[x,1]))
		
		RecLock("XTM",.F.)
			
		Replace XTM->TREAL 	with aTReal[x,2]
			
		XTM->(MsUnlock())

	EndIf

Next

For x := 1 to Len(aTApara)

	dbselectArea("XTM")
	
	If XTM->(dbSeek(aTApara[x,1]))
		
		RecLock("XTM",.F.)
			
		Replace XTM->TAPARA 	with aTApara[x,2]
			
		XTM->(MsUnlock())

	EndIf

Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:Say(oReport:Row(),oReport:Col(),"Analise do Lote " + mv_par01 )
oReport:SkipLine()

nCount	:= XTM->(RECCOUNT())
XTM->( DbGoTop() )
		
oReport:SetMeter(nCount)
	
While !oReport:Cancel() .And. XTM->(!EOF())

	oReport:IncMeter()
	cChave	:= XTM->OP
	
	If lCabec

		oSection1:Init()
		
		oReport:SkipLine()     
		oSection1:Cell("OP"):SetValue(XTM->OP)
		oSection1:Cell("OP"):SetAlign("CENTER")
		oSection1:Cell("PROD"):SetValue(XTM->PROD)
		oSection1:Cell("PROD"):SetAlign("CENTER")
		oSection1:Cell("PROG"):SetValue(XTM->PROG)
		oSection1:Cell("PROG"):SetAlign("LEFT")
		oSection1:Cell("REAL"):SetValue(XTM->TREAL)
		oSection1:Cell("REAL"):SetAlign("LEFT")
		oSection1:Cell("APARA"):SetValue(XTM->TAPARA)
		oSection1:Cell("APARA"):SetAlign("LEFT")
		oSection1:Cell("PAPARA"):SetValue(IIF(XTM->TAPARA > 0 , (XTM->TAPARA/XTM->TREAL)*100, 0))
		oSection1:Cell("PAPARA"):SetAlign("LEFT")
		
		
		oSection1:Cell("SITUA"):SetValue(IIF(POSICIONE("SC2",1, xFilial("SC2") + XTM->OP ,"C2_FINALIZ") == "*","ENCERRADA","ABERTA"))
		oSection1:Cell("SITUA"):SetAlign("CENTER")

		oSection1:PrintLine()
		//oReport:SkipLine()     
		//oSection1:Finish()
			
		oSection2:Init()
		lCabec	:= .F.

	EndIf
		
			
		oSection2:Cell("MAQ"):SetValue(XTM->MAQ)
		oSection2:Cell("MAQ"):SetAlign("CENTER")
		oSection2:Cell("LADO"):SetValue(XTM->LADO)
		oSection2:Cell("LADO"):SetAlign("RIGHT")
		oSection2:Cell("OPERADOR"):SetValue(XTM->OPERADOR)
		oSection2:Cell("OPERADOR"):SetAlign("LEFT")
		oSection2:Cell("QTDREAL"):SetValue(XTM->QTDREAL)
		oSection2:Cell("QTDREAL"):SetAlign("RIGHT")
		oSection2:Cell("QTDAPARA"):SetValue(XTM->QTDAPARA)
		oSection2:Cell("QTDAPARA"):SetAlign("RIGHT")
		oSection2:Cell("PERCAPARA"):SetValue(IIF(XTM->QTDAPARA > 0 , (XTM->QTDAPARA/XTM->QTDREAL)*100, 0))
		oSection2:Cell("PERCAPARA"):SetAlign("RIGHT")
		oSection2:PrintLine()
	
	XTM->(dbSkip())
	
	If cChave <> XTM->OP
	
		cQuery := " SELECT Z00_OP, Z00_SEQ, Z00_PESO, ZB9_SALDO, ZB9_DESC, ZB9_QINI FROM Z00020 Z00 (NOLOCK) "
		cQuery += " INNER JOIN ZB9020 ZB9 (NOLOCK) "
		cQuery += " ON Z00_SEQ = ZB9_SEQ "
		cQuery += " WHERE Z00.D_E_L_E_T_ <> '*' "
		cQuery += " AND ZB9.D_E_L_E_T_ <> '*' "
		cQuery += " AND LEFT(Z00_OP,6) = '" + cChave + "' " 
		
		If Select("TMP") > 0
			DbSelectArea("TMP")
			DbCloseArea()
		EndIf
		
		TCQUERY cQuery NEW ALIAS "TMP"
		
		DbSelectArea("TMP")
		TMP->(dbGoTop())
		
		If TMP->(!Eof())
				oSection3:Init()
		EndIf
		
		While TMP->(!Eof())
			
			oSection3:Cell("BOBINA"):SetValue(TMP->Z00_SEQ)
			oSection3:Cell("BOBINA"):SetAlign("CENTER")
			oSection3:Cell("DESCBOB"):SetValue(TMP->ZB9_DESC)
			oSection3:Cell("DESCBOB"):SetAlign("RIGHT")
			oSection3:Cell("QTDBOB"):SetValue(TMP->ZB9_QINI)
			oSection3:Cell("QTDBOB"):SetAlign("RIGHT")
			oSection3:Cell("SALDOBOB"):SetValue(TMP->ZB9_SALDO)
			oSection3:Cell("SALDOBOB"):SetAlign("RIGHT")
			oSection3:Cell("PERCBOB"):SetValue(IIF(TMP->ZB9_SALDO > 0 , (TMP->ZB9_SALDO/TMP->ZB9_QINI)*100, 0))
			oSection3:Cell("PERCBOB"):SetAlign("RIGHT")
			oSection3:PrintLine()
			
		
			TMP->(dbSkip())
			
		EndDo
		
		TMP->(dbGoTop())
		If TMP->(!Eof())
			oSection3:Finish()
			TMP->(dbCloseArea("TMP"))
		EndIf

		DbSelectArea("XTM")
		oSection1:Finish()
		oSection2:Finish()
		lCabec := .T.
		oSection1:Init()
		
	EndIf

EndDo

oSection1:Finish()
oSection2:Finish()

dbCloseArea("XTM")

Set Filter To

Return

