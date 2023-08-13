#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

*********************
User Function fXlsList()
*********************

local cQuery :=''

ValidPerg('FXLSLI')

IF !Pergunte('FXLSLI',.T.)

   Return 

ENDIF


if MV_PAR02=1 // LISTA1

   MsAguarde( { || fListA(SUBSTR(MV_PAR01,1,2),SUBSTR(MV_PAR01,4,4)) }, "Aguarde. . .", "Lista 1" )   

ELSEif MV_PAR02=2   // LISTA2

   MsAguarde( { || fListB(SUBSTR(MV_PAR01,1,2),SUBSTR(MV_PAR01,4,4)) }, "Aguarde. . .", "Lista 2" )   

ENDIF



Return 



***************

Static Function ValidPerg(cPerg)

***************

PutSx1( cPerg,'01','Periodo     ?','','','mv_ch1','C',07,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cperg,'02','Linha       ?', '', '', 'mv_cha', 'N', 01, 0, 1, 'C', '', ''   , '', '', 'mv_par02', 'Lista1', '', '', '' , 'Lista2', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cperg,'03', 'Valores em   ?', '', '', 'mv_ch3', 'N', 01, 0, 0, 'C', '', ''   , '', '', 'mv_par03', 'KG', '', '', '' , 'R$', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
Return

/*
***************

Static Function fListA()

***************

Local dDtIni:=Ctod("01/"+MV_PAR01)
Local dDtFim:=LastDay(Ctod("01/"+MV_PAR01))
Local dDtI:=FirstDay(Ctod("15/"+MV_PAR01)-120)
Local dDtF:=LastDay(Ctod("15/"+MV_PAR01)-30)

Local dDtNI:=FirstDay(Ctod("15/"+MV_PAR01)-30)
Local dDtNF:=LastDay(Ctod("15/"+MV_PAR01)-30)


Private aArray:={}
Private aCabec:={'REP','COD','LOJA','NOME','UF','MEDIA','DTUPED','MESATUAL'}


If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


//LISTA DE CLIENTES ATIVOS
 
cQuery :="SELECT "
cQuery +="  REP = SA1.A1_VEND, "
cQuery +="  COD = SA1.A1_COD, "
cQuery +="  LOJA = SA1.A1_LOJA, "
cQuery +="  NOME = SA1.A1_NOME, "
cQuery +="  UF = SA1.A1_EST, 
cQuery +="  MEDIA = SUM(SC6.C6_QTDVEN*SB1.B1_PESO)/3, "
cQuery +="  DTUPED = MAX(SC5.C5_ENTREG), "
cQuery +="  MESATUAL = ISNULL((SELECT "
cQuery +="                        SUM(SC6U.C6_QTDVEN*SB1U.B1_PESO) "
cQuery +="                     FROM "
cQuery +="                        "+RetSqlName("SB1")+" SB1U, "+RetSqlName("SC5")+" SC5U, "+RetSqlName("SC6")+" SC6U, "+RetSqlName("SC9")+" SC9U, "
cQuery +="                        "+RetSqlName("SA1")+" SA1U, "+RetSqlName("SA3")+" SA3U, "+RetSqlName("SE4")+" SE4U  "
cQuery +="                     WHERE   "
cQuery +="                        SC5U.C5_CLIENTE = SC5.C5_CLIENTE AND SC5U.C5_LOJACLI = SC5.C5_LOJACLI AND "
cQuery +="                        SC5U.C5_FILIAL = SC6U.C6_FILIAL AND  "
cQuery +="                        SC9U.C9_PEDIDO = SC6U.C6_NUM AND SC9U.C9_ITEM = SC6U.C6_ITEM AND SC9U.C9_PEDIDO = SC5U.C5_NUM AND "
cQuery +="                        SC9U.C9_BLCRED <> '09' AND "
cQuery +="                        SC6U.C6_BLQ <> 'R' AND SB1U.B1_TIPO = 'PA' AND "
cQuery +="                        SC6U.C6_PRODUTO = SB1U.B1_COD AND SC5U.C5_NUM = SC6U.C6_NUM AND SC5U.C5_VEND1 = SA3U.A3_COD AND "
cQuery +="                        SC5U.C5_CLIENTE = SA1U.A1_COD AND SC5U.C5_LOJACLI = SA1U.A1_LOJA AND "
cQuery +="                        SC5U.C5_ENTREG BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+"' AND "
cQuery +="                        SC6U.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery +="                        SB1U.B1_SETOR <> '39' AND "
cQuery +="                        SA1U.A1_ATIVO<>'N' AND  "
cQuery +="                        SC5U.C5_CONDPAG = SE4U.E4_CODIGO AND "
cQuery +="                        SB1U.D_E_L_E_T_ = ' ' AND "
cQuery +="                        SC5U.D_E_L_E_T_ = ' ' AND "
cQuery +="                        SC6U.D_E_L_E_T_ = ' ' AND "
cQuery +="                        SC9U.D_E_L_E_T_ = ' ' AND "
cQuery +="                        SE4U.D_E_L_E_T_ = ' ' AND "
cQuery +="                        SA1U.D_E_L_E_T_ = ' ' ),0) "
cQuery +="FROM "
cQuery +="   "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "
cQuery +="   "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SE4")+" SE4 "
cQuery +="WHERE "
cQuery +="   SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery +="   SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND SA1.A1_ATIVO<>'N' AND "
cQuery +="   SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_VEND1 = SA3.A3_COD AND "
cQuery +="   SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND "
cQuery +="   SC5.C5_ENTREG  BETWEEN '"+DTOS(dDtI)+"' AND '"+DTOS(dDtF)+"' AND "
cQuery +="   SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery +="   SB1.B1_SETOR <> '39' AND "
cQuery +="   SC5.C5_CONDPAG = E4_CODIGO AND "
cQuery +="   NOT EXISTS( SELECT "
cQuery +="                  SC5X.C5_FILIAL "
cQuery +="               FROM  "
cQuery +="                  "+RetSqlName("SB1")+" SB1X, "+RetSqlName("SC5")+" SC5X, "+RetSqlName("SC6")+" SC6X, "
cQuery +="                  "+RetSqlName("SA1")+" SA1X, "+RetSqlName("SA3")+" SA3X, "+RetSqlName("SE4")+" SE4X  "
cQuery +="               WHERE "
cQuery +="                  SC5X.C5_CLIENTE = SC5.C5_CLIENTE AND SC5X.C5_LOJACLI = SC5.C5_LOJACLI AND "
cQuery +="                  SC5X.C5_FILIAL = SC6X.C6_FILIAL AND "
cQuery +="                  SC6X.C6_BLQ <> 'R' AND SB1X.B1_TIPO = 'PA' AND SA1X.A1_ATIVO<>'N' AND  "
cQuery +="                  SC6X.C6_PRODUTO = SB1X.B1_COD AND SC5X.C5_NUM = SC6X.C6_NUM AND SC5X.C5_VEND1 = SA3X.A3_COD AND "
cQuery +="                  SC5X.C5_CLIENTE = SA1X.A1_COD AND SC5X.C5_LOJACLI = SA1X.A1_LOJA AND "
cQuery +="                  SC5X.C5_ENTREG BETWEEN '"+DTOS(dDtNI)+"' AND '"+DTOS(dDtNF)+"' AND "
cQuery +="                  SC6X.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery +="                  SB1X.B1_SETOR <> '39' AND "
cQuery +="                  SC5X.C5_CONDPAG = SE4X.E4_CODIGO AND "
cQuery +="                  SB1X.D_E_L_E_T_ = ' ' AND  "
cQuery +="                  SC5X.D_E_L_E_T_ = ' ' AND  "
cQuery +="                  SC6X.D_E_L_E_T_ = ' ' AND  "
cQuery +="                  SE4X.D_E_L_E_T_ = ' ' AND  "
cQuery +="                  SA1X.D_E_L_E_T_ = ' '  ) AND  "
cQuery +="   SB1.D_E_L_E_T_ = ' ' AND "
cQuery +="   SC5.D_E_L_E_T_ = ' ' AND "
cQuery +="   SC6.D_E_L_E_T_ = ' ' AND "
cQuery +="   SE4.D_E_L_E_T_ = ' ' AND "
cQuery +="   SA1.D_E_L_E_T_ = ' ' "
cQuery +="GROUP BY "
cQuery +="   A1_VEND, A1_COD, A1_LOJA, A1_NOME, A1_EST, SC5.C5_CLIENTE, SC5.C5_LOJACLI "
cQuery +="ORDER BY  "
cQuery +="   REP, DTUPED "
 

TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

while AUXZ->(!EOF())

    AADD(aArray,{AUXZ->REP,AUXZ->COD,AUXZ->LOJA,AUXZ->NOME,AUXZ->UF,AUXZ->MEDIA,DTOC(STOD(AUXZ->DTUPED)),AUXZ->MESATUAL})
    AUXZ->(DBSKIP())
Enddo

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Lista 1", aCabec, aArray}})})
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf
                                

Return 
*/

/*
***************

Static Function fListB()

***************

Local dDtIni:=Ctod("01/"+MV_PAR01)
Local dDtFim:=LastDay(Ctod("01/"+MV_PAR01))
Local dDtF:=LastDay(Ctod("15/"+MV_PAR01)-120)


Private aArray:={}
Private aCabec:={'REP','COD','LOJA','NOME','UF','MEDIA','DTUPED','MESATUAL'}


If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf

//--LISTA DE INATIVOS
 
cQuery :="SELECT      "
cQuery +="   REP,     "
cQuery +="   COD,     "
cQuery +="   LOJA,    "
cQuery +="   NOME,    "
cQuery +="   UF,      "
cQuery +="   MEDIA,   "
cQuery +="   DTUPED,  "
cQuery +="   MESATUAL = "
cQuery +="             ISNULL((SELECT "
cQuery +="                        SUM((SC6U.C6_QTDVEN * SC6U.C6_PRUNIT)-SC6U.C6_VALDESC) "
cQuery +="                     FROM "
cQuery +="                        "+RetSqlName("SB1")+" SB1U, "+RetSqlName("SC5")+" SC5U, "+RetSqlName("SC6")+" SC6U, "+RetSqlName("SC9")+" SC9U, "
cQuery +="                        "+RetSqlName("SA1")+" SA1U, "+RetSqlName("SA3")+" SA3U, "+RetSqlName("SE4")+" SE4U "
cQuery +="                     WHERE "
cQuery +="                        SC5U.C5_CLIENTE = COD AND SC5U.C5_LOJACLI = LOJA AND "
cQuery +="                        SC5U.C5_FILIAL = SC6U.C6_FILIAL AND "
cQuery +="                        SC9U.C9_PEDIDO = SC6U.C6_NUM AND SC9U.C9_ITEM = SC6U.C6_ITEM AND SC9U.C9_PEDIDO = SC5U.C5_NUM AND "
cQuery +="                        SC9U.C9_BLCRED <> '09' AND SA1U.A1_ATIVO<>'N' AND  "
cQuery +="                        SC6U.C6_BLQ <> 'R' AND SB1U.B1_TIPO = 'PA' AND "
cQuery +="                        SC6U.C6_PRODUTO = SB1U.B1_COD AND SC5U.C5_NUM = SC6U.C6_NUM AND SC5U.C5_VEND1 = SA3U.A3_COD AND "
cQuery +="                        SC5U.C5_CLIENTE = SA1U.A1_COD AND SC5U.C5_LOJACLI = SA1U.A1_LOJA AND "
cQuery +="                        SC5U.C5_ENTREG BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+"' AND "
cQuery +="                        SC6U.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery +="                        SB1U.B1_SETOR <> '39' AND "
cQuery +="                        SC5U.C5_CONDPAG = SE4U.E4_CODIGO AND "
cQuery +="                        SB1U.D_E_L_E_T_ = ' ' AND  "
cQuery +="                        SC5U.D_E_L_E_T_ = ' ' AND  "
cQuery +="                        SC6U.D_E_L_E_T_ = ' ' AND  "
cQuery +="                        SC9U.D_E_L_E_T_ = ' ' AND  "
cQuery +="                        SE4U.D_E_L_E_T_ = ' ' AND  "
cQuery +="                        SA1U.D_E_L_E_T_ = ' ' ),0) "
cQuery +="FROM "
cQuery +="( "
cQuery +="   SELECT    "
cQuery +="      REP,   "
cQuery +="      COD,   "
cQuery +="      LOJA,  "
cQuery +="      NOME,  "
cQuery +="      UF, "
cQuery +="      MEDIA=SUM(MEDIA)/COUNT(PERIODO), "
cQuery +="      DTUPED=MAX(DTUPED) "
cQuery +="   FROM "
cQuery +="   (
cQuery +="      SELECT "
cQuery +="         REP     = SA1.A1_VEND, "
cQuery +="         COD     = SA1.A1_COD,  "
cQuery +="         LOJA    = SA1.A1_LOJA, "
cQuery +="         NOME    = SA1.A1_NOME, "
cQuery +="         UF      = SA1.A1_EST,  "
cQuery +="         MEDIA   = SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC), "
cQuery +="         DTUPED  = SC5.C5_ENTREG, "
cQuery +="         PERIODO = LEFT(SC5.C5_ENTREG,6) "
cQuery +="      FROM "
cQuery +="         "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "
cQuery +="         "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SE4")+" SE4 "
cQuery +="      WHERE "
cQuery +="         SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery +="         SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND SA1.A1_ATIVO<>'N' AND  "
cQuery +="         SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_VEND1 = SA3.A3_COD AND "
cQuery +="         SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND "
cQuery +="         SC5.C5_ENTREG <> '' AND SC5.C5_ENTREG < '"+DTOS(dDtIni)+"' AND "
cQuery +="         SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery +="         SB1.B1_SETOR <>'39' AND   "
cQuery +="         SC5.C5_CONDPAG = E4_CODIGO AND "
cQuery +="         SB1.D_E_L_E_T_ = ' ' AND  "
cQuery +="         SC5.D_E_L_E_T_ = ' ' AND "
cQuery +="         SC6.D_E_L_E_T_ = ' ' AND "
cQuery +="         SE4.D_E_L_E_T_ = ' ' AND "
cQuery +="         SA1.D_E_L_E_T_ = ' ' "
cQuery +="      GROUP BY "
cQuery +="         SA1.A1_VEND, A1_COD, A1_LOJA, A1_NOME, A1_EST, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_ENTREG "
cQuery +="   ) AS VENDAS "
cQuery +="   GROUP BY "
cQuery +="      REP, COD,LOJA,NOME,UF  "
cQuery +=") AS VENDAS "
cQuery +="WHERE "
cQuery +="   DTUPED <= '"+dtos(dDtF)+"' "
cQuery +="ORDER BY "
cQuery +="   REP, DTUPED DESC "

 
TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

while AUXZ->(!EOF())

    AADD(aArray,{AUXZ->REP,AUXZ->COD,AUXZ->LOJA,AUXZ->NOME,AUXZ->UF,AUXZ->MEDIA,DTOC(STOD(AUXZ->DTUPED)),AUXZ->MESATUAL})
    AUXZ->(DBSKIP())
Enddo

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Lista 2", aCabec, aArray}})})
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf
                                

Return 
*/

***************

Static Function fListA(nMes,nAno)

***************

local cQuery
local aMesAnt   := fMAnter(nMes,nAno)
local aMesAtu   := fMAtual(nMes,nAno)
local aMes120   := f120Dias(nMes,nAno)
local aMeses120 := fMeses120(nMes,nAno)

local lReal   := (MV_PAR03==2)


Private aArray:={}
Private aCabec:={}

Aadd( aCabec,  "REP_COD" )
Aadd( aCabec,  "REP" )
Aadd( aCabec,  "CLIENTE" )
Aadd( aCabec,  "LOJA" )
Aadd( aCabec,  "NOME" )
Aadd( aCabec,  "UF" )

for _XY := 1 to Len(aMeses120)
    Aadd( aCabec,  Left(aMeses120[_XY,1],3)+"/"+Right(aMeses120[_XY,1],2) )	 
next _XY


Aadd( aCabec, "MESATUAL" )

//Clientes Ativos
cQuery := "SELECT "
cQuery += "   CLIENTE, "
cQuery += "   LOJA, "
cQuery += "   NOME, "
cQuery += "   REP_COD, "
cQuery += "   REP, "
cQuery += "   UF, "
for _X := 1 to Len(aMeses120)
   cQuery += "   "+aMeses120[_X,1]+" = SUM(CASE WHEN ANOMES = '"+aMeses120[_X,2]+"' THEN VENDIDO ELSE 0 END ), "
next _X
cQuery += "MESATUAL = ISNULL((SELECT "
if !lReal
   cQuery += "                   SUM(SC6U.C6_QTDVEN*SB1U.B1_PESO) "
else   
   cQuery += "                   SUM((SC6U.C6_QTDVEN * SC6U.C6_PRUNIT)-SC6U.C6_VALDESC) "
endif
cQuery += "                   FROM "
cQuery += "                      "+RetSqlName("SB1")+" SB1U, "+RetSqlName("SC5")+" SC5U, "+RetSqlName("SC6")+" SC6U, "+RetSqlName("SC9")+" SC9U, "
cQuery += "                      "+RetSqlName("SA1")+" SA1U, "+RetSqlName("SA3")+" SA3U, "+RetSqlName("SE4")+" SE4U "
cQuery += "                   WHERE "
cQuery += "                      SC5U.C5_CLIENTE = CLIENTE AND SC5U.C5_LOJACLI = LOJA AND "
cQuery += "                      SC5U.C5_FILIAL = SC6U.C6_FILIAL AND "
cQuery += "                      SC9U.C9_PEDIDO = SC6U.C6_NUM AND SC9U.C9_ITEM = SC6U.C6_ITEM AND SC9U.C9_PEDIDO = SC5U.C5_NUM AND "
cQuery += "                      SC9U.C9_BLCRED <> '09' AND "
cQuery += "                      SC6U.C6_BLQ <> 'R' AND SB1U.B1_TIPO = 'PA' AND "
cQuery += "                      SC6U.C6_PRODUTO = SB1U.B1_COD AND SC5U.C5_NUM = SC6U.C6_NUM AND SA1U.A1_VEND = SA3U.A3_COD AND "
cQuery += "                      SC5U.C5_CLIENTE = SA1U.A1_COD AND SC5U.C5_LOJACLI = SA1U.A1_LOJA AND SA1U.A1_ATIVO <> 'N' AND "
                                 //Periodo que compreende o mes Atual 
cQuery += "                      SC5U.C5_ENTREG BETWEEN '"+aMesAtu[1]+"' AND '"+aMesAtu[2]+"' AND "
cQuery += "                      SC6U.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery += "                      SB1U.B1_SETOR <> '39' AND "
											
cQuery += "                      SC5U.C5_CONDPAG = SE4U.E4_CODIGO AND "
cQuery += "                      SB1U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SC5U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SC6U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SC9U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SE4U.D_E_L_E_T_ = ' ' AND "
cQuery += "                      SA1U.D_E_L_E_T_ = ' ' ),0) "
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "       ANOMES = LEFT(SC5.C5_ENTREG,6), "
cQuery += "      CLIENTE = SA1.A1_COD,  "
cQuery += "         LOJA = SA1.A1_LOJA, "
cQuery += "         NOME = RTRIM(SA1.A1_NOME), "
cQuery += "          REP_COD = SA3.A3_COD, "
cQuery += "          REP = RTRIM(SA3.A3_NREDUZ), "
cQuery += "           UF = SA1.A1_EST,  "
if !lReal
   cQuery += "   VENDIDO = SUM(SC6.C6_QTDVEN*SB1.B1_PESO) "
else   
   cQuery += "   VENDIDO = SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC) "
endif
cQuery += "   FROM "
cQuery += "      "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "
cQuery += "      "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SE4")+" SE4 "
cQuery += "   WHERE "
cQuery += "      SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "      SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "      SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SA1.A1_VEND = SA3.A3_COD AND "
cQuery += "      SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND SA1.A1_ATIVO <> 'N' AND "
                 //Periodo que compreende os 120 dias anteriores ao mês atual
cQuery += "      SC5.C5_ENTREG BETWEEN '"+aMes120[1]+"' AND '"+aMes120[2]+"' AND "
cQuery += "      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery += "      SB1.B1_SETOR <> '39' AND "

cQuery += "      SC5.C5_CONDPAG = E4_CODIGO AND "
cQuery += "      NOT EXISTS( SELECT "
cQuery += "                     SC5X.C5_FILIAL "
cQuery += "                  FROM "
cQuery += "                     "+RetSqlName("SB1")+" SB1X, "+RetSqlName("SC5")+" SC5X, "+RetSqlName("SC6")+" SC6X, "
cQuery += "                     "+RetSqlName("SA1")+" SA1X, "+RetSqlName("SA3")+" SA3X, "+RetSqlName("SE4")+" SE4X "
cQuery += "                  WHERE "
cQuery += "                     SC5X.C5_CLIENTE = SC5.C5_CLIENTE AND SC5X.C5_LOJACLI = SC5.C5_LOJACLI AND "
cQuery += "                     SC5X.C5_FILIAL = SC6X.C6_FILIAL AND "
cQuery += "                     SC6X.C6_BLQ <> 'R' AND SB1X.B1_TIPO = 'PA' AND "
cQuery += "                     SC6X.C6_PRODUTO = SB1X.B1_COD AND SC5X.C5_NUM = SC6X.C6_NUM AND SA1X.A1_VEND = SA3X.A3_COD AND "
cQuery += "                     SC5X.C5_CLIENTE = SA1X.A1_COD AND SC5X.C5_LOJACLI = SA1X.A1_LOJA AND SA1X.A1_ATIVO <> 'N' AND "
                                //Periodo que compreende o mes Anterior ao Atual
cQuery += "                     SC5X.C5_ENTREG BETWEEN '"+aMesAnt[1]+"' AND '"+aMesAnt[2]+"' AND "
cQuery += "                     SC6X.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery += "                     SB1X.B1_SETOR <> '39' AND "

cQuery += "                     SC5X.C5_CONDPAG = SE4X.E4_CODIGO AND "
cQuery += "                     SB1X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SC5X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SC6X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SE4X.D_E_L_E_T_ = ' ' AND "
cQuery += "                     SA1X.D_E_L_E_T_ = ' '  ) AND "
cQuery += "      SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "      SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "      SE4.D_E_L_E_T_ = ' ' AND "
cQuery += "      SA1.D_E_L_E_T_ = ' ' "
cQuery += "   GROUP BY "
cQuery += "      A1_VEND, A1_COD, A1_LOJA, RTRIM(A1_NOME), A1_EST, LEFT(SC5.C5_ENTREG,6), RTRIM(A3_NREDUZ),A3_COD "
cQuery += ") AS ATIVOS "
cQuery += "GROUP BY "
cQuery += "   CLIENTE,LOJA,NOME,UF,REP,REP_COD "
cQuery += "ORDER BY "

for _X := Len(aMeses120) to 1 step -1
   cQuery += "   "+aMeses120[_X,1]+IF( _X > 1,", "," DESC ")
next _X

if Select("ATIV") > 0
	ATIV->(DbCloseArea())
endif
TCQUERY cQuery NEW ALIAS "ATIV"
TCSetField("ATIV" , "DTUPED" , "D")

while !ATIV->(EOF()) 

    AADD(aArray,{ATIV->REP_COD,ATIV->REP,ATIV->CLIENTE,ATIV->LOJA,ATIV->NOME,ATIV->UF,IIF(Len(aMeses120)>=1,&("ATIV->"+aMeses120[1,1]),0),IIF(Len(aMeses120)>=2,&("ATIV->"+aMeses120[2,1]),0),IIF(Len(aMeses120)>=3,&("ATIV->"+aMeses120[3,1]),0),IIF(Len(aMeses120)>=4,&("ATIV->"+aMeses120[4,1]),0), ATIV->MESATUAL})  
  
  ATIV->(DBSKIP())

ENDDO

If Select("ATIV") > 0
	DbSelectArea("ATIV")
	ATIV->(DbCloseArea())
EndIf


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Lista 1 Periodo:"+MV_PAR01+IIF(LReal,' Em Reais',' Em Kg'), aCabec, aArray}})})
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf


Return 


**********************************
static function fMAtual(nMes,nAno)
**********************************

local aRet := {}
local cIni    := DtoS( CtoD("01/"+nMes+"/"+nAno ) )
local cFim    := DtoS( LastDay( Ctod("01/"+nMes+"/"+nAno ) ) )

Aadd( aRet, cIni )
Aadd( aRet, cFim )

return aRet

**********************************
static function fMAnter(nMes,nAno)
**********************************

local aRet := {}
local dDtAnt  := CtoD( "01/"+nMes+"/"+nAno )-1
local nMesAnt := Month( dDtAnt )
local nAnoAnt := Year( dDtAnt )
local cIni    := DtoS( CtoD("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) ) )

Aadd( aRet, cIni )
Aadd( aRet, cFim )

return aRet


***********************************
static function f120Dias(nMes,nAno)
***********************************

local aRet    := {}
local dDtAnt  := CtoD( "01/"+nMes+"/"+nAno ) - 1
local nMesAnt := Month( dDtAnt )
local nAnoAnt := Year( dDtAnt )
local cIni    := DtoS( CtoD("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) - 90 )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) ) )

Aadd( aRet, cIni )
Aadd( aRet, cFim )

return aRet


************************************
static function fMeses120(nMes,nAno)
************************************

local aRet    := {}
local dDtAnt  := CtoD( "01/"+nMes+"/"+nAno ) - 1
local nMesAnt := Month( dDtAnt )
local nAnoAnt := Year( dDtAnt )
local cIni    := DtoS( CtoD("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) - 90 )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) ) ) )
Local aMES    := { 'JAN','FEV','MAR','ABR','MAI','JUN',;
                   'JUL','AGO','SET','OUT','NOV','DEZ' }
while Left(cIni,6) <= Left(cFim,6)
   Aadd( aRet, { aMes[Month(StoD(cIni))]+Right(Str(Year(StoD(cIni))),2) , AllTrim(Str(Year(StoD(cIni)))+StrZero(Month(StoD(cIni)),2)) } )
   cIni := DtoS( StoD( cIni ) + 31 )
end

return aRet


***************

Static Function fListB(nMes,nAno)

***************
local cQuery

local aMesAnt := fMAnter(nMes,nAno)
local aMesAtu := fMAtual(nMes,nAno)
local aMes120 := f120Dias(nMes,nAno)

local lReal   := (MV_PAR03==2)

Private aArray:={}
Private aCabec:={'REP','CLIENTE','LOJA','NOME','UF','PENULT.PED' ,'ULT.PEDIDO','DT.ULT.PED','VEND.ATUAL'}



//Há 120 dias ou mais sem comprar

//MOSTRAR VOLUME DOS (2)DOIS ULTIMOS PEDIDOS E A DATA DO ULTIMO
cQuery := "SELECT "
cQuery += "   CLIENTE, "
cQuery += "   LOJA, "
cQuery += "   NOME, "
cQuery += "   REP, "
cQuery += "   UF, "
cQuery += "   VOLUMEUP = "
cQuery += "              ISNULL((SELECT TOP 1 "
if !lReal
   cQuery += "                      SUM(SC6U.C6_QTDVEN*SB1U.B1_PESO) "
else   
   cQuery += "                      SUM((SC6U.C6_QTDVEN * SC6U.C6_PRUNIT)-SC6U.C6_VALDESC) "
endif
cQuery += "                      FROM "
cQuery += "                         "+RetSqlName("SB1")+" SB1U, "+RetSqlName("SC5")+" SC5U, "+RetSqlName("SC6")+" SC6U, "
cQuery += "                         "+RetSqlName("SA1")+" SA1U, "+RetSqlName("SA3")+" SA3U, "+RetSqlName("SE4")+" SE4U "
cQuery += "                      WHERE "
cQuery += "                         SC5U.C5_CLIENTE = CLIENTE AND SC5U.C5_LOJACLI = LOJA AND "
cQuery += "                         SC5U.C5_FILIAL = SC6U.C6_FILIAL AND "
cQuery += "                         SC6U.C6_BLQ <> 'R' AND SB1U.B1_TIPO = 'PA' AND "
cQuery += "                         SC6U.C6_PRODUTO = SB1U.B1_COD AND SC5U.C5_NUM = SC6U.C6_NUM AND SA1U.A1_VEND = SA3U.A3_COD AND "
cQuery += "                         SC5U.C5_CLIENTE = SA1U.A1_COD AND SC5U.C5_LOJACLI = SA1U.A1_LOJA AND SA1U.A1_ATIVO <> 'N' AND "
cQuery += "                         SC5U.C5_ENTREG <> '' AND SC5U.C5_ENTREG < '"+aMesAtu[1]+"' AND "
cQuery += "                         SC6U.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery += "                         SB1U.B1_SETOR <> '39' AND "
cQuery += "                         SC5U.C5_CONDPAG = SE4U.E4_CODIGO AND "
cQuery += "                         SB1U.D_E_L_E_T_ = ' ' AND "
cQuery += "                         SC5U.D_E_L_E_T_ = ' ' AND "
cQuery += "                         SC6U.D_E_L_E_T_ = ' ' AND "
cQuery += "                         SE4U.D_E_L_E_T_ = ' ' AND "
cQuery += "                         SA1U.D_E_L_E_T_ = ' ' "
cQuery += "                      GROUP BY "
cQuery += "                         SC5U.C5_ENTREG "
cQuery += "                      ORDER BY SC5U.C5_ENTREG DESC ),0), "
cQuery += "   DATAUP, "
cQuery += "   VOLUMEPP = "
cQuery += "              ISNULL(( "
cQuery += "                      SELECT "
cQuery += "                         VENDIDO "
cQuery += "                      FROM "
cQuery += "                      (   "
cQuery += "                         SELECT "
cQuery += "                            ROWNUM = ROW_NUMBER() OVER (ORDER BY C5_ENTREG DESC), "
if !lReal
   cQuery += "                         VENDIDO=SUM(SC6U.C6_QTDVEN*SB1U.B1_PESO) "
else   
   cQuery += "                         VENDIDO=SUM((SC6U.C6_QTDVEN * SC6U.C6_PRUNIT)-SC6U.C6_VALDESC) "
endif
cQuery += "                         FROM "
cQuery += "                            "+RetSqlName("SB1")+" SB1U, "+RetSqlName("SC5")+" SC5U, "+RetSqlName("SC6")+" SC6U,"
cQuery += "                            "+RetSqlName("SA1")+" SA1U, "+RetSqlName("SA3")+" SA3U, "+RetSqlName("SE4")+" SE4U "
cQuery += "                         WHERE "
cQuery += "                            SC5U.C5_CLIENTE = CLIENTE AND SC5U.C5_LOJACLI = LOJA AND "
cQuery += "                            SC5U.C5_FILIAL = SC6U.C6_FILIAL AND "
cQuery += "                            SC6U.C6_BLQ <> 'R' AND SB1U.B1_TIPO = 'PA' AND "
cQuery += "                            SC6U.C6_PRODUTO = SB1U.B1_COD AND SC5U.C5_NUM = SC6U.C6_NUM AND SA1U.A1_VEND = SA3U.A3_COD AND "
cQuery += "                            SC5U.C5_CLIENTE = SA1U.A1_COD AND SC5U.C5_LOJACLI = SA1U.A1_LOJA AND SA1U.A1_ATIVO <> 'N' AND "
cQuery += "                            SC5U.C5_ENTREG <> '' AND SC5U.C5_ENTREG < '"+aMesAtu[1]+"' AND "
cQuery += "                            SC6U.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery += "                            SB1U.B1_SETOR <> '39' AND "
cQuery += "                            SC5U.C5_CONDPAG = SE4U.E4_CODIGO AND "
cQuery += "                            SB1U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                            SC5U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                            SC6U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                            SE4U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                            SA1U.D_E_L_E_T_ = ' ' "
cQuery += "                         GROUP BY "
cQuery += "                            C5_ENTREG "
cQuery += "                      ) AS PENULTIMO WHERE ROWNUM = 2 ) ,0), "
cQuery += "   MESATUAL = "
cQuery += "              ISNULL((SELECT "
if !lReal
   cQuery += "                      SUM(SC6U.C6_QTDVEN*SB1U.B1_PESO) "
else   
   cQuery += "                      SUM((SC6U.C6_QTDVEN * SC6U.C6_PRUNIT)-SC6U.C6_VALDESC) "
endif
cQuery += "                      FROM "
cQuery += "                         "+RetSqlName("SB1")+" SB1U, "+RetSqlName("SC5")+" SC5U, "+RetSqlName("SC6")+" SC6U, " 
cQuery += "                         "+RetSqlName("SA1")+" SA1U, "+RetSqlName("SA3")+" SA3U, "+RetSqlName("SE4")+" SE4U "
cQuery += "                      WHERE "
cQuery += "                         SC5U.C5_CLIENTE = CLIENTE AND SC5U.C5_LOJACLI = LOJA AND "
cQuery += "                         SC5U.C5_FILIAL = SC6U.C6_FILIAL AND "
cQuery += "                         SC6U.C6_BLQ <> 'R' AND SB1U.B1_TIPO = 'PA' AND "
cQuery += "                         SC6U.C6_PRODUTO = SB1U.B1_COD AND SC5U.C5_NUM = SC6U.C6_NUM AND SA1U.A1_VEND = SA3U.A3_COD AND "
cQuery += "                         SC5U.C5_CLIENTE = SA1U.A1_COD AND SC5U.C5_LOJACLI = SA1U.A1_LOJA AND SA1U.A1_ATIVO <> 'N' AND "
cQuery += "                         SC5U.C5_ENTREG BETWEEN '"+aMesAtu[1]+"' AND '"+aMesAtu[2]+"' AND "
cQuery += "                         SC6U.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery += "                         SB1U.B1_SETOR <> '39' AND "
cQuery += "                         SC5U.C5_CONDPAG = SE4U.E4_CODIGO AND "
cQuery += "                         SB1U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                         SC5U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                         SC6U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                         SE4U.D_E_L_E_T_ = ' ' AND  "
cQuery += "                         SA1U.D_E_L_E_T_ = ' ' ),0) "
cQuery += "FROM  "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "      CLIENTE,  "
cQuery += "      LOJA, "
cQuery += "      NOME, "
cQuery += "      REP, "
cQuery += "      UF, "
cQuery += "      DATAUP=MAX(DATAUP) "
cQuery += "   FROM "
cQuery += "   ( "
cQuery += "      SELECT "
cQuery += "         CLIENTE = SA1.A1_COD, "
cQuery += "         LOJA    = SA1.A1_LOJA, "
cQuery += "         NOME    = RTRIM(SA1.A1_NOME), "
cQuery += "         REP     = RTRIM(SA3.A3_COD), "
cQuery += "         UF      = SA1.A1_EST, "
cQuery += "         DATAUP  = SC5.C5_ENTREG "
cQuery += "      FROM "
cQuery += "         "+RetSqlName("SB1")+" SB1, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "
cQuery += "         "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SE4")+" SE4  "
cQuery += "      WHERE "
cQuery += "         SC5.C5_FILIAL = SC6.C6_FILIAL AND "
cQuery += "         SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "         SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND SA1.A1_VEND = SA3.A3_COD AND "
cQuery += "         SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND SA1.A1_ATIVO <> 'N' AND "
cQuery += "         SC5.C5_ENTREG <> '' AND SC5.C5_ENTREG < '"+aMesAtu[1]+"' AND "
cQuery += "         SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118') AND "
cQuery += "         SB1.B1_SETOR <>'39' AND "
cQuery += "         SC5.C5_CONDPAG = E4_CODIGO AND "
cQuery += "         SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "         SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "         SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "         SE4.D_E_L_E_T_ = ' ' AND "
cQuery += "         SA1.D_E_L_E_T_ = ' ' "
cQuery += "      GROUP BY "
cQuery += "         SA1.A1_VEND, A1_COD, A1_LOJA, RTRIM(A1_NOME), A1_EST, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_ENTREG, RTRIM(A3_COD) "
cQuery += "   ) AS VENDAS "
cQuery += "   GROUP BY "
cQuery += "      CLIENTE,LOJA,NOME,UF,REP "
cQuery += ") AS VENDAS "
cQuery += "WHERE "
cQuery += "   DATAUP <= '"+aMes120[1]+"' "
cQuery += "ORDER BY "
cQuery += "   DATAUP DESC "

if Select("INAT") > 0
	INAT->(DbCloseArea())
endif
TCQUERY cQuery NEW ALIAS "INAT"
TCSetField("INAT" , "DATAUP" , "D")

Do while !INAT->(EOF()) 

   AADD(aArray,{INAT->REP,INAT->CLIENTE,INAT->LOJA,INAT->NOME,INAT->UF,INAT->VOLUMEPP,INAT->VOLUMEUP,DTOC(INAT->DATAUP),INAT->MESATUAL})  
  
  INAT->(DbSkip())
  
EndDo



If Select("INAT") > 0
	DbSelectArea("INAT")
    INAT->(DbCloseArea())
EndIf


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Lista 2 Periodo:"+MV_PAR01+IIF(LReal,' Em Reais',' Em Kg'), aCabec, aArray}})})
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf



Return 