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
±±³Programa  ³FATR057    ³ Autor ³ THIAGO EWERTON       ³ Data ³10.11.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³            RELATORIO PRODUTO                            .³±±
±±³          ³  LINHA                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FXLSPRO2()

Local oReport
Local cPerg	:= "FXLSPRO"

criaSx1(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.T.)

oReport:= ReportDef()
oReport:PrintDialog()


Return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

PutSx1( cPerg,'01','Produto De     ?','','','mv_ch1','C',06,0,0,'G','','SB1','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'02','Produto Ate    ?','','','mv_ch2','C',06,0,0,'G','','SB1','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )
//PutSx1( cPerg,'01','Cliente De     ?','','','mv_ch1','C',06,0,0,'G','','SA1CLI','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
//PutSx1( cPerg,'02','Cliente Ate    ?','','','mv_ch2','C',06,0,0,'G','','SA1CLI','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )

return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FISR001  ³ Autor ³ Thiago Ewerton         ³ Data ³10.11.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³               Relatorio PRODUTO.                     .³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

Local oReport
Local oSection1
//Local oSection2

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

oReport:= TReport():New("FXLSPRO2","RELATORIO PRODUTO","FXLSPRO2", {|oReport| ReportPrint(oReport)},"RELATORIO PRODUTO")
//oReport:SetLandscape()
oReport:SetPortrait()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Data de                ³
//³ mv_par02   // Data Até               ³
//³ mv_par03   // Vendedor               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Pergunte(oReport:uParam,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
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

TRCell():New(oSection1,'CODIGO_FAMILIA'     ,'','CODIGO_FAMILIA'        ,)
TRCell():New(oSection1,'FAMILIA'     ,'','FAMILIA'        ,)
TRCell():New(oSection1,'PRODUTO'    ,'','PRODUTO' ,)
TRCell():New(oSection1,'DESCRICAO'  ,'','DESCRICAO'      ,)
TRCell():New(oSection1,'LITRAGEM'  ,'','LITRAGEM'      ,)
//TRCell():New(oSection1,'MEDIDA'     ,'','MEDIDA'       ,)
TRCell():New(oSection1,'COR'    ,'','COR'          ,)
//TRCell():New(oSection1,'NOME'    ,'','NOME'          ,)
//TRCell():New(oSection1,'ENDERECO'    ,'','ENDERECO'          ,)
//TRCell():New(oSection1,'BAIRRO'    ,'','BAIRRO'          ,)
//TRCell():New(oSection1,'CIDADE'    ,'','CIDADE'          ,)
//TRCell():New(oSection1,'UF'    ,'','UF'          ,)
//TRCell():New(oSection1,'CEP'    ,'','CEP'          ,)
//TRCell():New(oSection1,'TELEFONE'    ,'','TELEFONE'          ,)
//TRCell():New(oSection1,'DT_ULT_ENTREGA'    ,'','DT_ULT_ENTREGA'          ,)
//TRCell():New(oSection1,'PRIMEIRA_COMPRA'    ,'','PRIMEIRA_COMPRA'          ,)
//TRCell():New(oSection1,'GRUPO_VENDA'    ,'','GRUPO_VENDA'          ,)
//TRCell():New(oSection1,'NOME_GRUPO_VENDA'    ,'','NOME_GRUPO_VENDA'          ,)

//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("CODO"),"Produto",.F.)
//oBreak := TRBreak():New(oSection1,oSection1:Cell("REP"),"Total",.F.)
//TRFunction():New(oSection1:Cell("REALPV"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALRS"),NIL,"SUM",oBreak,"Total Líquido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)


Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³PONR003 ³ Autor ³ Gustavo Costa           ³ Data ³20.06.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
// Monta a tabela de prod
//***********************************


cQuery:="SELECT "
cQuery+="CODIGO_FAMILIA=B1_GRUPO, "
cQuery+="FAMILIA=CASE "
cQuery+="        WHEN B1_GRUPO IN('D','E') THEN 'DOMESTICA' "
cQuery+="        WHEN B1_GRUPO IN('A','B','G') THEN 'INSTITUCIONAL' "
cQuery+="        WHEN B1_GRUPO IN('C') THEN 'HOSPITALAR' "                   
cQuery+="        ELSE B1_GRUPO "
cQuery+="        END, "
cQuery+="PRODUTO=B1_COD,DESCRICAO=B1_DESC, "
cQuery+="LITRAGEM=( SELECT X5_DESCRI  "
cQuery+="              FROM SX5020 SX5 "
cQuery+="              WHERE SX5.X5_FILIAL = '01' AND SX5.X5_TABELA = 'Z0' AND SX5.X5_CHAVE = SB5.B5_CAPACID "
cQuery+="              AND SX5.D_E_L_E_T_ = '' ), "

cQuery+="LARGURA=B5_LARG+CASE WHEN B1_GRUPO IN('D','E') THEN 0 ELSE 1 END , "
cQuery+="COMPRIMENTO=B5_COMPR+CASE WHEN B1_GRUPO IN('D','E') THEN 0 ELSE 1 END , "
cQuery+="COR=CASE "
cQuery+="    WHEN SUBSTRING(B1_COD,3,1) = 'A' THEN 'AZUL' "
cQuery+="    WHEN SUBSTRING(B1_COD,3,1) = 'B' THEN 'BRANCO' "
cQuery+="    WHEN SUBSTRING(B1_COD,3,1) = 'C' THEN 'PRETO' "
cQuery+="    WHEN SUBSTRING(B1_COD,3,1) = 'D' THEN 'VERMELHO' "
cQuery+="    WHEN SUBSTRING(B1_COD,3,1) = 'E' THEN 'AMARELO' "
cQuery+="    WHEN SUBSTRING(B1_COD,3,1) = 'F' THEN 'VERDE' "
cQuery+="    WHEN SUBSTRING(B1_COD,3,1) = 'G' THEN 'CINZA' "                
cQuery+="    END "

cQuery+="FROM "

cQuery+=""+RetSqlName("SB1")+" SB1 with (nolock), "+RetSqlName("SB5")+" SB5 with (nolock) "

cQuery+="WHERE  "
cQuery+="B1_COD=B5_COD "
cQuery+="AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery+="AND B1_TIPO='PA' "
cQuery+="AND B1_MSBLQL<>'1' "
cQuery+="AND B1_SETOR<>'39' "
cQuery+="AND B1_ATIVO<>'N' "
cQuery+="and SB1.D_E_L_E_T_ <> '*' " 
cQuery+="AND SB5.D_E_L_E_T_ <> '*' "

cQuery+="ORDER BY B1_COD "

MemoWrite("C:\TEMP\FXLSPRO2.SQL", cQuery)

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TMP"

//_cMedida:= cvaltochar(TMP->LARGURA)+' X '+cvaltochar(TMP->COMPRIMENTO)

TMP->( DbGoTop() )
oReport:SetMeter(TMP->(RecCount()))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Processando a Sessao 1                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1:Init()
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()     
oReport:SkipLine()
//oReport:ThinLine()

While !oReport:Cancel() .And. TMP->(!Eof())

	oReport:IncMeter()

    oSection1:Cell("CODIGO_FAMILIA"):SetValue(TMP->CODIGO_FAMILIA)
	oSection1:Cell("CODIGO_FAMILIA"):SetAlign("LEFT")
	oSection1:Cell("FAMILIA"):SetValue(TMP->FAMILIA)
	oSection1:Cell("FAMILIA"):SetAlign("LEFT")
	oSection1:Cell("PRODUTO"):SetValue(TMP->PRODUTO)
	oSection1:Cell("PRODUTO"):SetAlign("LEFT")
	oSection1:Cell("DESCRICAO"):SetValue(TMP->DESCRICAO)
	oSection1:Cell("DESCRICAO"):SetAlign("LEFT")
	oSection1:Cell("LITRAGEM"):SetValue(TMP->LITRAGEM)
	oSection1:Cell("LITRAGEM"):SetAlign("LEFT")
    //oSection1:Cell("MEDIDA"):SetValue(TMP->_cMedida)
	//oSection1:Cell("MEDIDA"):SetAlign("LEFT")
	oSection1:Cell("COR"):SetValue(TMP->COR)
	oSection1:Cell("COR"):SetAlign("LEFT")
	//oSection1:Cell("ENDERECO"):SetValue(TMP->ENDERECO)
	//oSection1:Cell("ENDERECO"):SetAlign("LEFT")
	//oSection1:Cell("BAIRRO"):SetValue(TMP->BAIRRO)
	//oSection1:Cell("BAIRRO"):SetAlign("LEFT")

	
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return


