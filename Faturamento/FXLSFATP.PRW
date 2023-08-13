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
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³            RELATORIO FAT POR PRODUTOS                     .³±±
±±³          ³  LINHA                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FXLSFATP()

Local oReport
//Local cPerg	:= "FXLSFA"


//criaSx1(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FISR001  ³ Autor ³ Thiago Ewerton         ³ Data ³10.11.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                RELATORIO FAT POR PRODUTOS                 .³±±
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

oReport:= TReport():New("FXLSFATP","RELATORIO DE FATURAMENTO POR PRODUTOS","FXLSFATP", {|oReport| ReportPrint(oReport)},"RELATORIO DE FATURAMENTO POR PRODUTOS")
oReport:SetLandscape()
//oReport:SetPortrait()

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

TRCell():New(oSection1,'COD_COOD'     ,'','COD_COOD'        ,)
TRCell():New(oSection1,'COORDENADOR'     ,'','COORDENADOR'        ,)
TRCell():New(oSection1,'COD_REP'     ,'','COD_REP'        ,)
TRCell():New(oSection1,'REPRESENTANTE'    ,'','REPRESENTANTE' ,)
TRCell():New(oSection1,'COD_SEG'  ,'','COD_SEG'      ,)
TRCell():New(oSection1,'CLIENTE'  ,'','CLIENTE'      ,)
TRCell():New(oSection1,'LOJA'  ,'','LOJA'      ,)
TRCell():New(oSection1,'NOME'    ,'','NOME'          ,)
TRCell():New(oSection1,'CODIGO_FAMILIA'    ,'','CODIGO_FAMILIA'          ,)
TRCell():New(oSection1,'FAMILIA'    ,'','FAMILIA'          ,)
TRCell():New(oSection1,'SUBLINHA'    ,'','SUBLINHA'          ,)
TRCell():New(oSection1,'PRODUTO'    ,'','PRODUTO'          ,)
TRCell():New(oSection1,'DESCRICAO'    ,'','DESCRICAO'          ,)
TRCell():New(oSection1,'FATURA_KG'    ,'','FATURA_KG'          ,)
TRCell():New(oSection1,'FATURA_RS'    ,'','FATURA_RS'          ,)
TRCell():New(oSection1,'PRECO_MEDIO'    ,'','PRECO_MEDIO'          ,)
TRCell():New(oSection1,'UF'    ,'','UF'          ,)
TRCell():New(oSection1,'BONIF_KG'    ,'','BONIF_KG'          ,)


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
±±³Programa  ³PONR003 ³ Autor ³ THIAGO EWERTON          ³ Data ³20.06.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos  ³±±
±±³          ³os relatorios que poderao ser agendados pelo usuario.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
// Monta a tabela de FATURAMENTO POR CLIENTES
//***********************************


cQuery :="SELECT UF,COD_REP,REPRESENTANTE,COD_COOD,COORDENADOR=ISNULL((SELECT RTRIM(SA3X.A3_NOME) FROM SA3010 SA3X WHERE SA3X.A3_COD = COD_COOD AND SA3X.D_E_L_E_T_ <> '*'),''), "
cQuery +="COD_SEG,CLIENTE,LOJA,NOME,CODIGO_FAMILIA,FAMILIA,PRODUTO,SB1X.B1_DESC DESCRICAO,sum(FATURA_RS)FATURA_RS,sum(FATURA_KG)FATURA_KG,sum(BONIF_KG)BONIF_KG,SUBLINHA "
cQuery +="FROM ( "
cQuery +="SELECT  "
cQuery +="UF=A1_EST,COD_COOD=A3_SUPER,COD_REP=A3_COD,REPRESENTANTE=A3_NOME,COD_SEG=A1_SATIV1,CLIENTE=A1_COD,LOJA=A1_LOJA,NOME=RTRIM(A1_NOME), "  
cQuery +="CODIGO_FAMILIA=B1_GRUPO, "
cQuery +="FAMILIA=CASE "
cQuery +="         WHEN B1_GRUPO IN('D','E') THEN 'DOMESTICA' "
cQuery +="         WHEN B1_GRUPO IN('A','B','G') THEN 'INSTITUCIONAL' "
cQuery +="         WHEN B1_GRUPO IN('C') THEN 'HOSPITALAR'  "                  
cQuery +="         ELSE B1_GRUPO  "
cQuery +="      END, "
cQuery +="SUBLINHA= "
cQuery +="               CASE "
cQuery +="                  WHEN B1_SETOR IN ('05','37','40','56') THEN 'Hamper' "
cQuery +="                  WHEN B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') THEN 'Infectantes' "
cQuery +="                  WHEN B1_SETOR IN ('06','54','98')      THEN 'Obitos' "
cQuery +="                  WHEN B1_SETOR IN ('23')           THEN 'Dona Limpeza Pacote' "
cQuery +="                  WHEN B1_SETOR IN ('24','25')      THEN 'Dona Limpeza Rolo'  "
cQuery +="                  WHEN B1_SETOR IN ('26')           THEN 'Brasileirinho Pacote' "
cQuery +="                  WHEN B1_SETOR IN ('27','28')      THEN 'Brasileirinho Rolo'  "               
cQuery +="                  ELSE 'Institucional' "
cQuery +="               END,              "
/*
cQuery +="PRODUTO=CASE WHEN LEN(D2_COD)>=8 THEN "
cQuery +="             CASE when (Substring( D2_COD, 4, 1 ) IN('R','D')) or  (Substring( D2_COD, 5, 1 ) IN('R','D')) "
cQuery +="             then SUBSTRING(D2_COD,1,1)+SUBSTRING(D2_COD,3,4)+SUBSTRING(D2_COD,8,2) "
cQuery +="             else SUBSTRING(D2_COD,1,1)+SUBSTRING(D2_COD,3,3)+SUBSTRING(D2_COD,7,2) end  "
cQuery +="             ELSE RTRIM(D2_COD) "
cQuery +="        END, "
*/

cQuery +="PRODUTO=case when len(D2_COD) >= 8 then case when len(D2_COD) = 8 then SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 3) + SUBSTRING( D2_COD, 7, 2) else SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 4) + SUBSTRING( D2_COD, 8, 2) end else D2_COD END, "

//cQuery +="FATURA_RS=SUM((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN), "               
//cQuery +="FATURA_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN (0) ELSE ((D2_QUANT-D2_QTDEDEV)*(D2_PESO )) END) "
cQuery +="FATURA_RS=SUM(CASE WHEN D2_CF IN ('5910','6910','5936','6936') THEN 0 ELSE (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN END),  "
cQuery +="FATURA_KG=SUM(CASE WHEN D2_CF IN ('5910','6910','5936','6936') THEN 0 ELSE (CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN (0) ELSE ((D2_QUANT-D2_QTDEDEV)*(D2_PESO )) END) END),  "
cQuery +="BONIF_KG=SUM(CASE WHEN D2_CF IN ('5910','6910','5936','6936') THEN (CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN (0) ELSE ((D2_QUANT-D2_QTDEDEV)*(D2_PESO )) END) ELSE 0 END)  "

cQuery +="FROM "

cQuery +=""+RetSqlName("SD2")+" SD2 with (nolock), "+RetSqlName("SB1")+" SB1 with (nolock), "+RetSqlName("SF2")+" SF2 with (nolock), "
cQuery +=""+RetSqlName("SA3")+" SA3 with (nolock), "+RetSqlName("SA1")+" SA1 with (nolock) "


cQuery +="WHERE "

if MV_PAR04 == 2
	cQuery += "SD2.D2_CLIENTE NOT IN ('006543','007005') and "
endIf
If !Empty(MV_PAR05)
	cQuery += "SD2.D2_FILIAL = '" + mv_par05 + "' AND "
endIf
cQuery +="D2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND "
cQuery +="F2_VEND1 = A3_COD  AND D2_TIPO = 'N' AND D2_TP != 'AP' AND "
cQuery +="SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND "
cQuery +="RTRIM(D2_CF) IN ('5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118','6118','6119','5910','6910','5936','6936') AND "
cQuery +="D2_CLIENTE NOT IN ('031732','031733') AND D2_COD = B1_COD AND SB1.B1_SETOR <>'39' AND "
cQuery +="D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA AND "
cQuery +="SB1.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*'  "
cQuery +="GROUP BY A1_EST,A3_SUPER,A3_COD,A3_NOME,A1_SATIV1,A1_COD,A1_LOJA,RTRIM(A1_NOME), B1_GRUPO, "
cQuery +="case when len(D2_COD) >= 8 then case when len(D2_COD) = 8 then SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 3) + SUBSTRING( D2_COD, 7, 2) else SUBSTRING( D2_COD, 1, 1) + SUBSTRING( D2_COD, 3, 4) + SUBSTRING( D2_COD, 8, 2) end else D2_COD END "
/*
cQuery +="         CASE WHEN LEN(D2_COD)>=8 THEN "
cQuery +="             CASE when (Substring( D2_COD, 4, 1 ) IN('R','D')) or  (Substring( D2_COD, 5, 1 ) IN('R','D')) "
cQuery +="             then SUBSTRING(D2_COD,1,1)+SUBSTRING(D2_COD,3,4)+SUBSTRING(D2_COD,8,2) "
cQuery +="             else SUBSTRING(D2_COD,1,1)+SUBSTRING(D2_COD,3,3)+SUBSTRING(D2_COD,7,2) end "
cQuery +="             ELSE RTRIM(D2_COD) "
cQuery +="        END "
*/
cQuery +="        ,B1_DESC "
cQuery +="        ,CASE "
cQuery +="                  WHEN B1_SETOR IN ('05','37','40','56') THEN 'Hamper' "
cQuery +="                  WHEN B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') THEN 'Infectantes' "
cQuery +="                  WHEN B1_SETOR IN ('06','54','98')      THEN 'Obitos' "
cQuery +="                  WHEN B1_SETOR IN ('23')           THEN 'Dona Limpeza Pacote' "
cQuery +="                  WHEN B1_SETOR IN ('24','25')      THEN 'Dona Limpeza Rolo'  "
cQuery +="                  WHEN B1_SETOR IN ('26')           THEN 'Brasileirinho Pacote' "
cQuery +="                  WHEN B1_SETOR IN ('27','28')      THEN 'Brasileirinho Rolo'  "               
cQuery +="                  ELSE 'Institucional' "
cQuery +="               END "
cQuery +=") AS TABX ,"+RetSqlName("SB1")+" SB1X with (nolock)  "           
cQuery +="WHERE "        
cQuery +="SB1X.B1_COD=PRODUTO "
cQuery +="AND SB1X.D_E_L_E_T_='' "
cQuery +="GROUP BY UF,COD_COOD,COD_REP,REPRESENTANTE,COD_SEG,CLIENTE,LOJA,NOME,CODIGO_FAMILIA,FAMILIA,PRODUTO,SB1X.B1_DESC,SUBLINHA "
cQuery +="ORDER BY COD_SEG,CLIENTE,LOJA,NOME,CODIGO_FAMILIA,FAMILIA,SUBLINHA,PRODUTO,SB1X.B1_DESC "


TCQUERY cQuery NEW ALIAS "TMP"

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

     oSection1:Cell("COD_COOD"):SetValue(TMP->COD_COOD)
	oSection1:Cell("COD_COOD"):SetAlign("LEFT")
	oSection1:Cell("COORDENADOR"):SetValue(TMP->COORDENADOR)
	oSection1:Cell("COORDENADOR"):SetAlign("LEFT")
	oSection1:Cell("COD_REP"):SetValue(TMP->COD_REP)
	oSection1:Cell("COD_REP"):SetAlign("LEFT")
	oSection1:Cell("REPRESENTANTE"):SetValue(TMP->REPRESENTANTE)
	oSection1:Cell("REPRESENTANTE"):SetAlign("LEFT")
	oSection1:Cell("COD_SEG"):SetValue(TMP->COD_SEG)
	oSection1:Cell("COD_SEG"):SetAlign("LEFT")
	oSection1:Cell("CLIENTE"):SetValue(TMP->CLIENTE)
	oSection1:Cell("CLIENTE"):SetAlign("LEFT")
	oSection1:Cell("LOJA"):SetValue(TMP->LOJA)
	oSection1:Cell("LOJA"):SetAlign("LEFT")
    oSection1:Cell("NOME"):SetValue(TMP->NOME)
	oSection1:Cell("NOME"):SetAlign("LEFT")
	oSection1:Cell("CODIGO_FAMILIA"):SetValue(TMP->CODIGO_FAMILIA)
	oSection1:Cell("CODIGO_FAMILIA"):SetAlign("LEFT")
	oSection1:Cell("FAMILIA"):SetValue(TMP->FAMILIA)
	oSection1:Cell("FAMILIA"):SetAlign("LEFT")
	oSection1:Cell("SUBLINHA"):SetValue(TMP->SUBLINHA)
	oSection1:Cell("SUBLINHA"):SetAlign("LEFT")
	oSection1:Cell("PRODUTO"):SetValue(TMP->PRODUTO)
	oSection1:Cell("PRODUTO"):SetAlign("LEFT")
	oSection1:Cell("DESCRICAO"):SetValue(TMP->DESCRICAO)
	oSection1:Cell("DESCRICAO"):SetAlign("LEFT")
	oSection1:Cell("FATURA_KG"):SetValue(TMP->FATURA_KG)
	oSection1:Cell("FATURA_KG"):SetAlign("LEFT")
	oSection1:Cell("FATURA_RS"):SetValue(TMP->FATURA_RS)
	oSection1:Cell("FATURA_RS"):SetAlign("LEFT")
	oSection1:Cell("PRECO_MEDIO"):SetValue(TMP->FATURA_RS/TMP->FATURA_KG)
	oSection1:Cell("PRECO_MEDIO"):SetAlign("LEFT")
	oSection1:Cell("UF"):SetValue(TMP->UF)
	oSection1:Cell("UF"):SetAlign("LEFT")
	oSection1:Cell("BONIF_KG"):SetValue(TMP->BONIF_KG)
	oSection1:Cell("BONIF_KG"):SetAlign("LEFT")

	
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return


