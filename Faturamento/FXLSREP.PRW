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
±±³Programa  ³FXLSREP    ³ Autor ³ THIAGO EWERTON       ³ Data ³10.11.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³            RELATORIO REALIZADO POR PRODUTO                .³±±
±±³          ³  LINHA                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FXLSREP()

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
±±³Programa  ³FXLSREP  ³ Autor ³ Thiago Ewerton         ³ Data ³10.11.2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                RELATORIO FAT POR CLIENTES                 .³±±
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

oReport:= TReport():New("FXLSREP","RELATORIO REALIZADO POR PRODUTO","FXLSREP", {|oReport| ReportPrint(oReport)},"RELATORIO REALIZADO POR PRODUTO")
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

//TRCell():New(oSection1,'CARTATU'	,'','Carteira'		,"@E 9,999,999.99"  ,14				,/*lPixel*/,/*{|| code-block de impressao }*/)

TRCell():New(oSection1,'CODIGO'     ,'','CODIGO'        ,)
TRCell():New(oSection1,'VENDEDOR'     ,'','VENDEDOR'        ,)
TRCell():New(oSection1,'CLIENTE'     ,'','CLIENTE'        ,)
TRCell():New(oSection1,'LOJA'    ,'','LOJA' ,)
TRCell():New(oSection1,'NOME'  ,'','NOME'      ,)
TRCell():New(oSection1,'FAMILIA'  ,'','FAMILIA'      ,)
TRCell():New(oSection1,'SUBLINHA'  ,'','SUBLINHA'      ,)
TRCell():New(oSection1,'PRODUTO'  ,'','PRODUTO'      ,)
TRCell():New(oSection1,'DESCRICAO'  ,'','DESCRICAO'      ,)
TRCell():New(oSection1,'VENDIDO_KG'    ,'','VENDIDO_KG'          ,)
TRCell():New(oSection1,'VENDIDO_R$'    ,'','VENDIDO_R$'          ,)
//TRCell():New(oSection1,'PRECO_MEDIO'    ,'','PRECO_MEDIO'          ,)



//New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("CODO"),"Produto",.F.)
//oBreak := TRBreak():New(oSection1,oSection1:Cell("REP"),"Total",.F.)
//TRFunction():New(oSection1:Cell("REALPV"),NIL,"SUM",oBreak,"Total LÃ­quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//TRFunction():New(oSection1:Cell("REALRS"),NIL,"SUM",oBreak,"Total LÃ­quido",PesqPict('SE1','E1_VALOR',14),/*uFormula*/,.F.,.F.,.F.,oSection1)
//New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)


Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FXLSREP ³   Autor ³ THIAGO EWERTON        ³ Data ³18.11.2022³±±
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


*/
//***********************************
// Monta a tabela
//***********************************
cQuery :="SELECT "
cQuery +="REP,NOME_REP, "
cQuery +="CODIGO,LOJA,NOME, "
cQuery +="FAMILIA,SUBLINHA, "
cQuery +="PRODUTO, "
cQuery +="SB1X.B1_DESC DESCRICAO, "
cQuery +="VENDIDO_RS , "
cQuery +="VENDIDO_KG,  "
cQuery +="DEV_KG , "
cQuery +="DEV_RS,   "
//
cQuery +="PED_REJ_KG, "
cQuery +="PED_REJ_RS  "
//
cQuery +="FROM( "
cQuery +="SELECT  "
cQuery +="C5_VEND1 REP,A3_NOME NOME_REP,A1_COD CODIGO,A1_LOJA LOJA,A1_NOME NOME,  "
cQuery +="FAMILIA=CASE "
cQuery +="           WHEN B1_GRUPO IN('D','E') THEN 'DOMESTICA' "
cQuery +="           WHEN B1_GRUPO IN('A','B','G') THEN 'INSTITUCIONAL' "
cQuery +="           WHEN B1_GRUPO IN('C') THEN 'HOSPITALAR' "          
cQuery +="           ELSE B1_GRUPO "
cQuery +="        END, "
cQuery +="SUBLINHA= "
cQuery +="               CASE "
cQuery +="                  WHEN B1_SETOR IN ('05','37','40','56') THEN 'Hamper' "
cQuery +="                  WHEN B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') THEN 'Infectantes' "
cQuery +="                  WHEN B1_SETOR IN ('06','54','98')      THEN 'Obitos' "
cQuery +="                  WHEN B1_SETOR IN ('23')           THEN 'Dona Limpeza Pacote' "
cQuery +="                  WHEN B1_SETOR IN ('24','25')      THEN 'Dona Limpeza Rolo'  "
cQuery +="                  WHEN B1_SETOR IN ('26')           THEN 'Brasileirinho Pacote' "
cQuery +="                  WHEN B1_SETOR IN ('27','28')      THEN 'Brasileirinho Rolo' "               
cQuery +="                  ELSE 'Institucional'
cQuery +="               END,  "           
/*
cQuery +="PRODUTO=CASE WHEN LEN(C6_PRODUTO)>=8 THEN "
cQuery +="CASE when (Substring( C6_PRODUTO, 4, 1 ) IN('R','D')) or  (Substring( C6_PRODUTO, 5, 1 ) IN('R','D')) "
cQuery +="then SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,4)+SUBSTRING(C6_PRODUTO,8,2) "
cQuery +="else SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,3)+SUBSTRING(C6_PRODUTO,7,2) end "
cQuery +="ELSE RTRIM(C6_PRODUTO) END , "
*/
cQuery +="PRODUTO=case when len(C6_PRODUTO) >= 8 then case when len(C6_PRODUTO) = 8 then SUBSTRING( C6_PRODUTO, 1, 1) + SUBSTRING( C6_PRODUTO, 3, 3) + SUBSTRING( C6_PRODUTO, 7, 2) else SUBSTRING( C6_PRODUTO, 1, 1) + SUBSTRING( C6_PRODUTO, 3, 4) + SUBSTRING( C6_PRODUTO, 8, 2) end else C6_PRODUTO END, "       
//cQuery +="SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC ) AS VENDIDO_RS , "
//cQuery +="SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO) AS VENDIDO_KG     , "
cQuery +="VENDIDO_RS=SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC ), "
cQuery +="VENDIDO_KG=SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO), "
cQuery +="DEV_KG = ISNULL(SUM(SD2.D2_QTDEDEV * SB1.B1_PESO),0), "
cQuery +="DEV_RS = ISNULL(SUM((SD2.D2_QTDEDEV*SC6.C6_PRUNIT)-SC6.C6_VALDESC ),0), "

//
cQuery +="PED_REJ_KG= ISNULL(SUM(C9_QTDLIB2),0) , "
//cQuery +="PED_REJ_RS= ISNULL(SUM(C9_QTDLIB*C9_PRCVEN),0) "
cQuery +="PED_REJ_RS= ISNULL(SUM((C9_QTDLIB*SC6.C6_PRUNIT)-SC6.C6_VALDESC),0) "
//
cQuery +="FROM  "
cQuery +=""+RetSqlName("SC6")+" SC6 (NOLOCK) "
cQuery +="left  JOIN "+RetSqlName("SC5")+" SC5 (NOLOCK) "
cQuery +="ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery +="AND SC5.C5_ENTREG BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'  AND SC5.D_E_L_E_T_='' "

cQuery +="JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) "
cQuery +="ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' '  "

cQuery +="JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) "
cQuery +="ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_='' "

cQuery +="JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) "
cQuery +="ON B1_COD=C6_PRODUTO  AND SB1.B1_SETOR <> '39'  and SB1.D_E_L_E_T_=''  "

cQuery +="left JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) "
cQuery +="ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV and SD2.D2_QTDEDEV > 0 AND SD2.D_E_L_E_T_ = ' '  "
cQuery +="AND SD2.D2_QTDEDEV > 0 "
//
cQuery +="left JOIN SC9020 SC9 (NOLOCK) "
cQuery +="ON C6_FILIAL = C9_FILIAL AND C9_NFISCAL = '' AND C9_SEQUEN  = '01' AND C9_BLCRED IN ('09') AND "
cQuery +="C5_ENTREG BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND A1_COD = C9_CLIENTE AND A1_LOJA = C9_LOJA AND "
cQuery +="C9_PRODUTO = B1_COD AND C6_NUM = C9_PEDIDO  AND SC9.D_E_L_E_T_ = '' "
//
cQuery +="WHERE "
cQuery +="SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery +="SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118' ) AND "
cQuery +="SC6.D_E_L_E_T_ = ' ' "

cQuery +="GROUP BY C5_VEND1,A3_NOME ,A1_COD,A1_LOJA,A1_NOME,C5_NUM,  "
/*
cQuery +="         CASE WHEN LEN(C6_PRODUTO)>=8 THEN "
cQuery +="           CASE when (Substring( C6_PRODUTO, 4, 1 ) IN('R','D')) or  (Substring( C6_PRODUTO, 5, 1 ) IN('R','D'))  "
cQuery +="           then SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,4)+SUBSTRING(C6_PRODUTO,8,2) "
cQuery +="           else SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,3)+SUBSTRING(C6_PRODUTO,7,2) end "
cQuery +="           ELSE RTRIM(C6_PRODUTO) END, "
*/
cQuery +="case when len(C6_PRODUTO) >= 8 then case when len(C6_PRODUTO) = 8 then SUBSTRING( C6_PRODUTO, 1, 1) + SUBSTRING( C6_PRODUTO, 3, 3) + SUBSTRING( C6_PRODUTO, 7, 2) else SUBSTRING( C6_PRODUTO, 1, 1) + SUBSTRING( C6_PRODUTO, 3, 4) + SUBSTRING( C6_PRODUTO, 8, 2) end else C6_PRODUTO END ,"
cQuery +="         CASE "
cQuery +="           WHEN B1_GRUPO IN('D','E') THEN 'DOMESTICA' "
cQuery +="           WHEN B1_GRUPO IN('A','B','G') THEN 'INSTITUCIONAL' "
cQuery +="           WHEN B1_GRUPO IN('C') THEN 'HOSPITALAR' "          
cQuery +="           ELSE B1_GRUPO "
cQuery +="        END, "
cQuery +="        CASE "
cQuery +="                  WHEN B1_SETOR IN ('05','37','40','56') THEN 'Hamper' "
cQuery +="                  WHEN B1_SETOR IN ('08','09','10','11','12','13','14','30','34','35','36','41','55') THEN 'Infectantes' "
cQuery +="                  WHEN B1_SETOR IN ('06','54','98')      THEN 'Obitos' "
cQuery +="                  WHEN B1_SETOR IN ('23')           THEN 'Dona Limpeza Pacote' "
cQuery +="                  WHEN B1_SETOR IN ('24','25')      THEN 'Dona Limpeza Rolo'  "
cQuery +="                  WHEN B1_SETOR IN ('26')           THEN 'Brasileirinho Pacote' "
cQuery +="                  WHEN B1_SETOR IN ('27','28')      THEN 'Brasileirinho Rolo' "               
cQuery +="                  ELSE 'Institucional'
cQuery +="               END  "           
cQuery +=") AS TABX , SB1010 SB1X         "
cQuery +="WHERE "
cQuery +="SB1X.B1_COD=PRODUTO "
cQuery +="AND SB1X.D_E_L_E_T_='' " 

MemoWrite("C:\TEMP\FXLSREP.SQL", cQuery)

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

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

    oSection1:Cell("CODIGO"):SetValue(TMP->REP)
	oSection1:Cell("CODIGO"):SetAlign("LEFT")
	oSection1:Cell("VENDEDOR"):SetValue(TMP->NOME_REP)
	oSection1:Cell("VENDEDOR"):SetAlign("LEFT")
	oSection1:Cell("CLIENTE"):SetValue(TMP->CODIGO)
	oSection1:Cell("CLIENTE"):SetAlign("LEFT")
	oSection1:Cell("LOJA"):SetValue(TMP->LOJA)
	oSection1:Cell("LOJA"):SetAlign("LEFT")
    oSection1:Cell("NOME"):SetValue(TMP->NOME)
	oSection1:Cell("NOME"):SetAlign("LEFT")
    oSection1:Cell("FAMILIA"):SetValue(TMP->FAMILIA)
	oSection1:Cell("FAMILIA"):SetAlign("LEFT")
    oSection1:Cell("SUBLINHA"):SetValue(TMP->SUBLINHA)
	oSection1:Cell("SUBLINHA"):SetAlign("LEFT")
	oSection1:Cell("PRODUTO"):SetValue(TMP->PRODUTO)
	oSection1:Cell("PRODUTO"):SetAlign("LEFT")
	oSection1:Cell("DESCRICAO"):SetValue(TMP->DESCRICAO)
	oSection1:Cell("DESCRICAO"):SetAlign("LEFT")
	oSection1:Cell("VENDIDO_KG"):SetValue(TMP->VENDIDO_KG-TMP->DEV_KG)
	oSection1:Cell("VENDIDO_KG"):SetAlign("LEFT")
	oSection1:Cell("VENDIDO_R$"):SetValue(TMP->VENDIDO_RS-TMP->DEV_RS)
	oSection1:Cell("VENDIDO_R$"):SetAlign("LEFT")
	//oSection1:Cell("PRECO_MEDIO"):SetValue(TMP->(((TMP->VENDIDO_RS-AUXZ->DEV_RS)-TMP->PED_REJ_RS)/((TMP->VENDIDO_KG-TMP->DEV_KG)-TMP->PED_REJ_KG)))
	//oSection1:Cell("PRECO_MEDIO"):SetAlign("LEFT")
	
	
	oSection1:PrintLine()
	//oReport:SkipLine()     
	TMP->(dbSkip())

EndDo

oSection1:Finish()

dbCloseArea("TMP")
Set Filter To

Return


