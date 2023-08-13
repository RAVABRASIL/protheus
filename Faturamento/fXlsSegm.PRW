#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

************************
User Function fXlsSegm()
************************

Local cQuery := ""
Local cPerg  := "RFATR03" //Uso as mesmas perguntas do Rel. RFATR03

if !Pergunte(cPerg,.T.)
   Return 
endif

MsAguarde( { || fSegmento() }, "Aguarde. . .", " " )   

Return 

***************************
Static Function fSegmento()
***************************

Private _aArra:={}
Private _aCabe:={'SEGCOD','SEGNOM','GERCOD','GERNOM','REPCOD','REPNOM','UF','VENDIDO','COBERTURA'}

if Select("AUXZ") > 0
   DbSelectArea("AUXZ")
   AUXZ->(DbCloseArea())
endif

cQuery := "SELECT "
cQuery += "   SEGCOD, "
cQuery += "   SEGNOM, "
cQuery += "   GERCOD, GERNOM=ISNULL((SELECT RTRIM(A3_NOME) FROM SA3010 WHERE A3_COD = GERCOD AND D_E_L_E_T_ <> '*'), '' ), "
cQuery += "   REPCOD, REPNOM, "
cQuery += "   UF, "
cQuery += "   VEN_KG=SUM(VEN_KG-DEV_KG), "
cQuery += "   COBERTURA=COUNT(CLIENTE) "
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "      CLIENTE = A1_COD, "
cQuery += "      SEGCOD  = A1_SATIV1, "
cQuery += "      SEGNOM  = UPPER((SELECT RTRIM(X5_DESCRI) FROM "+RetSqlName("SX5")+" SX5 WHERE X5_FILIAL = '01' AND X5_TABELA = 'T3' AND X5_CHAVE = A1_SATIV1 AND D_E_L_E_T_ <> '*')), "
cQuery += "      REPCOD=LEFT(C5_VEND1,4), "
cQuery += "      REPNOM=A3_NOME, "
cQuery += "      GERCOD=A3_SUPER, "
cQuery += "      UF=A1_EST, "
cQuery += "      VEN_KG  = SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO), "
cQuery += "      DEV_KG  = ISNULL(SUM(SD2.D2_QTDEDEV * SB1.B1_PESO),0) "
cQuery += "   FROM  "
cQuery += "      "+RetSqlName("SC6")+" SC6 (NOLOCK) "
cQuery += "      LEFT JOIN "+RetSqlName("SC5")+" SC5 (NOLOCK) "
cQuery += "      ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery += "      AND SC5.C5_ENTREG BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'  AND "
if !Empty(MV_PAR04)
   cQuery += "   SC5.C5_VEND1 LIKE '"+Alltrim(MV_PAR04)+"%' AND "
endif
cQuery += "      SC5.D_E_L_E_T_<>'*' "

cQuery += "      JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) "
cQuery += "      ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND "
if !Empty(MV_PAR05)
   cQuery += "   SA1.A1_EST = '"+MV_PAR05+"' AND "
endif
cQuery += "      SA1.D_E_L_E_T_ <> '*'  "

cQuery += "      JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) "
cQuery += "      ON SA3.A3_COD = LEFT(SC5.C5_VEND1,4) AND "
if !Empty(MV_PAR03)
   cQuery += "   (SC5.C5_VEND1 LIKE '"+Alltrim(MV_PAR03)+"%' OR SA3.A3_SUPER LIKE '"+Alltrim(MV_PAR03)+"%' ) AND "
endif
cQuery += "      SA3.D_E_L_E_T_<>'*' "

cQuery += "      JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) "
cQuery += "      ON B1_COD=C6_PRODUTO  AND SB1.B1_SETOR <> '39'  and SB1.D_E_L_E_T_<>'*'  "
cQuery += "      LEFT JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) "
cQuery += "      ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV and SD2.D2_QTDEDEV > 0 AND SD2.D_E_L_E_T_ <> '*' "
cQuery += "      AND SD2.D2_QTDEDEV > 0 "
cQuery += "   WHERE "
cQuery += "      SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118' ) AND "
cQuery += "      SC6.D_E_L_E_T_ = ' ' "
cQuery += "   GROUP BY "
cQuery += "      A1_COD,A1_SATIV1,LEFT(C5_VEND1,4),A3_SUPER, A3_NOME,A1_EST "
cQuery += ") AS TABX "
cQuery += "GROUP BY "
cQuery += "   SEGCOD, "
cQuery += "   SEGNOM, "
cQuery += "   GERCOD, REPCOD, REPNOM, UF "
cQuery += "ORDER BY "
cQuery += "   VEN_KG DESC "
   
If Select("AUXZ") > 0
   DbSelectArea("AUXZ")
   DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

while AUXZ->(!Eof())
   Aadd(_aArra,{AUXZ->SEGCOD,AUXZ->SEGNOM ,;
                AUXZ->GERCOD,AUXZ->GERNOM ,;
                AUXZ->REPCOD,AUXZ->REPNOM ,;
                AUXZ->UF    ,AUXZ->VEN_KG,;
                AUXZ->COBERTURA } )
   AUXZ->(DbSkip())
end

if Select("AUXZ") > 0
   DbSelectArea("AUXZ")
   AUXZ->(DbCloseArea())
endif

MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Vendas por Segmento", _aCabe, _aArra}})})

if !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
endif
                                                              
return 