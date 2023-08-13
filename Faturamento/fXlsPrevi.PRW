#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

************************
User Function fXlsPrevi()
************************

Local cQuery := ""
Local cPerg  := "RFATR02" //Uso as mesmas perguntas do Rel. RFATR02

if !Pergunte(cPerg,.T.)
   Return 
endif

MsAguarde( { || fPrevisao() }, "Aguarde. . .", " " )   

Return 

***************************
Static Function fPrevisao()
***************************

local aMeta := {}
local cIni  := DtoS(CtoD("01/"+StrZero(MV_PAR01,2)+"/"+Str(MV_PAR02)))
local cFim  := DtoS(LastDay(Ctod("01/"+StrZero(MV_PAR01,2)+"/"+Str(MV_PAR02))))

Private _aArra:={}
Private _aCabe:={'GERCOD','GERNOM','REPCOD','REPNOM','LINHA','UF','METAMES','REALIZADO','IDEALACUM','DIFACUM','METAPRODIA','TENDENCIA','METAUDIA'}

if Select("AUXZ") > 0
   DbSelectArea("AUXZ")
   AUXZ->(DbCloseArea())
endif

cQuery := "SELECT "
cQuery += "   GERCOD, GERNOM, "
cQuery += "   REPCOD, REPNOM, "
cQuery += "   UF, "
cQuery += "   LINHA, "
cQuery += "   VEN_KG=SUM(VEN_KG), "
cQuery += "   META=SUM(META) "
cQuery += "FROM "
cQuery += "( "

cQuery += "SELECT "
cQuery += "   GERCOD, GERNOM=ISNULL((SELECT RTRIM(A3_NOME) FROM "+RetSqlName("SA3")+" WHERE A3_COD = GERCOD AND D_E_L_E_T_ <> '*'), '' ), "
cQuery += "   REPCOD, REPNOM, "
cQuery += "   UF, "
cQuery += "   LINHA, "
cQuery += "   VEN_KG=(VEN_KG-DEV_KG)-PED_REJ_KG, "
cQuery += "   META=0"
cQuery += "FROM "
cQuery += "( "
cQuery += "   SELECT "
cQuery += "      REPCOD=LEFT(C5_VEND1,4), REPNOM=A3_NOME, "
cQuery += "      GERCOD=A3_SUPER, "
cQuery += "      UF=A1_EST,
cQuery += "      LINHA= "
cQuery += "         CASE "
cQuery += "            WHEN B1_GRUPO IN('D','E') THEN 'DOME' "
cQuery += "            WHEN B1_GRUPO IN('A','B','G') THEN 'INST' "
cQuery += "            WHEN B1_GRUPO IN('C') THEN 'HOSP' "
cQuery += "            ELSE B1_GRUPO "
cQuery += "         END, "
cQuery += "      VEN_KG = SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO), "
// 
cQuery +="       PED_REJ_KG= ISNULL(SUM(C9_QTDLIB2),0) , "
//
cQuery += "      DEV_KG = ISNULL(SUM(SD2.D2_QTDEDEV * SB1.B1_PESO),0) "
cQuery += "   FROM  "
cQuery += "      "+RetSqlName("SC6")+" SC6 (NOLOCK) "
cQuery += "      left  JOIN "+RetSqlName("SC5")+" SC5 (NOLOCK) "
cQuery += "      ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery += "      AND SC5.C5_ENTREG BETWEEN '"+cIni+"' AND '"+cFim+"'  AND SC5.D_E_L_E_T_='' "
cQuery += "      JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) "
cQuery += "      ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' '  "
cQuery += "      JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) "
cQuery += "      ON SA3.A3_COD = LEFT(SC5.C5_VEND1,4) AND SA3.D_E_L_E_T_='' "
cQuery += "      JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) "
cQuery += "      ON B1_COD=C6_PRODUTO  AND SB1.B1_SETOR <> '39'  and SB1.D_E_L_E_T_=''  "
cQuery += "      left JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) "
cQuery += "      ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV and SD2.D2_QTDEDEV > 0 AND SD2.D_E_L_E_T_ = ' '  "
cQuery += "      AND SD2.D2_QTDEDEV > 0 "
//
cQuery +="       left JOIN SC9020 SC9 (NOLOCK) "
cQuery +="       ON C6_FILIAL = C9_FILIAL AND C9_NFISCAL = '' AND C9_SEQUEN  = '01' AND C9_BLCRED IN ('09') AND "
cQuery +="       C5_ENTREG BETWEEN '"+cIni+"' AND '"+cFim+"' AND A1_COD = C9_CLIENTE AND A1_LOJA = C9_LOJA AND "
cQuery +="       C9_PRODUTO = B1_COD AND C6_NUM = C9_PEDIDO  AND SC9.D_E_L_E_T_ = ''  "
//
cQuery += "   WHERE "
cQuery += "      SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118' ) AND "
cQuery += "      SC6.D_E_L_E_T_ = ' ' "
cQuery += "   GROUP BY "
cQuery += "      LEFT(C5_VEND1,4), A3_NOME, A3_SUPER, A1_EST, "
cQuery += "      CASE "
cQuery += "         WHEN B1_GRUPO IN('D','E') THEN 'DOME' "
cQuery += "         WHEN B1_GRUPO IN('A','B','G') THEN 'INST' "
cQuery += "         WHEN B1_GRUPO IN('C') THEN 'HOSP' "
cQuery += "         ELSE B1_GRUPO "
cQuery += "      END "
cQuery += ") AS TABX "

cQuery += "UNION "

cQuery += "SELECT "
cQuery += "   GERCOD=Z51_COORD, "
cQuery += "   GERNOM=ISNULL((SELECT RTRIM(A3_NOME) FROM "+RetSqlName("SA3")+" WHERE A3_COD = Z51_COORD AND D_E_L_E_T_ <> '*'), '' ), "
cQuery += "   REPCOD=Z51_REPRES, "
cQuery += "   REPNOM=RTRIM(A3_NOME), "
cQuery += "   UF=Z51_UF, LINHA=Z51_LINHA, VEN_KG=0, META=(Z51_MVALOR/12) "
cQuery += "FROM "
cQuery += "   "+RetSqlName("Z51")+" Z51, "+RetSqlName("SA3")+" SA3 "
cQuery += "WHERE "
cQuery += "   Z51_ANO = '"+AllTrim(Str(MV_PAR02))+"' AND Z51_REPRES = A3_COD AND Z51.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*'

cQuery += ") AS TABX "


cQuery += "WHERE   "

if MV_PAR08 = 1
   cQuery += "LINHA = 'INST' AND "
elseif MV_PAR08 = 2
   cQuery += "LINHA = 'DOME' AND "
elseif MV_PAR08 = 3
   cQuery += "LINHA = 'HOSP' AND "
endif

if !Empty(MV_PAR07)
   cQuery += "UF = '"+MV_PAR07+"' AND "
endif

if !Empty(MV_PAR06)
   cQuery += "REPCOD LIKE '"+Alltrim(MV_PAR06)+"%' AND "
endif

if !Empty(MV_PAR05)
   cQuery += "GERCOD LIKE '"+Alltrim(MV_PAR05)+"%' AND "
endif

cQuery += "REPNOM <> '' "

cQuery += "GROUP BY "
cQuery += "   GERCOD, GERNOM, "
cQuery += "   REPCOD, REPNOM, "
cQuery += "   UF, "
cQuery += "   LINHA "


cQuery += "ORDER BY "
cQuery += "   GERCOD, REPCOD, UF, LINHA "

TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

while AUXZ->(!Eof())
   aMeta := U_MetaDia( AUXZ->META, AUXZ->VEN_KG, MV_PAR03, MV_PAR04 )
  
   Aadd(_aArra,{AUXZ->GERCOD,AUXZ->GERNOM,;
                AUXZ->REPCOD,AUXZ->REPNOM,;
                AUXZ->LINHA ,AUXZ->UF    ,;
                AUXZ->META  ,AUXZ->VEN_KG,;
                aMeta[1]    ,if(aMeta[2]<0,0,aMeta[2]),;
                aMeta[3]    ,aMeta[4]    ,;
                aMeta[5]} )
   AUXZ->(DbSkip())
end

if Select("AUXZ") > 0
   DbSelectArea("AUXZ")
   AUXZ->(DbCloseArea())
endif

MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Previsão de Vendas", _aCabe, _aArra}})})

if !ApOleClient("MSExcel")
   MsgAlert("Microsoft Excel não instalado!")
endif
                                                              
return 
