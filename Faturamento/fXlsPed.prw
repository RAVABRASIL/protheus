#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

*********************
User Function fXlsPed()
*********************

local cQuery :=''


ValidPerg('FXLSPED')

IF !Pergunte('FXLSPED',.T.)

   Return 

ENDIF

If MV_PAR03=1 // cliente
   MsAguarde( { || fPedido() }, "Aguarde. . .", " " )   
Else // produto 
   MsAguarde( { || fPedPro() }, "Aguarde. . .", " " )   
Endif


Return 



***************

Static Function ValidPerg(cPerg)

***************

PutSx1( cPerg,'01','Data De     ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'02','Data Ate    ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )

Return


***************

Static Function fPedido()

***************

Private _aArra:={}
Private _aCabe:={'CODIGO','VENDEDOR','CLIENTE','LOJA','NOME','PEDIDO','VENDIDO_KG','VENDIDO_R$','PRECO_MEDIO'}


If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf

cQuery :="SELECT "
cQuery +="C5_VEND1 ,A3_NOME,A1_COD,A1_LOJA,A1_NOME,C5_NUM, "
cQuery +="SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC ) AS VENDIDO_RS ,SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO) AS VENDIDO_KG     , "
cQuery +="DEV_KG = ISNULL(SUM(SD2.D2_QTDEDEV * SB1.B1_PESO),0), "
cQuery +="DEV_RS = ISNULL(SUM((SD2.D2_QTDEDEV*SC6.C6_PRUNIT)-SC6.C6_VALDESC ),0), "
// 
cQuery +="PED_REJ_KG= ISNULL(SUM(C9_QTDLIB2),0) , "
cQuery +="PED_REJ_RS= ISNULL(SUM((C9_QTDLIB*SC6.C6_PRUNIT)-SC6.C6_VALDESC),0) "
//
cQuery +="FROM  "
cQuery +=""+RetSqlName("SC6")+" SC6 (NOLOCK) "
cQuery +="left  JOIN "+RetSqlName("SC5")+" SC5 (NOLOCK) "
cQuery +="ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery +="AND SC5.C5_ENTREG BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND SC5.D_E_L_E_T_ = ' ' "

cQuery +="JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) "
cQuery +="ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "

cQuery +="JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) "
cQuery +="ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_='' "

cQuery +="JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) "
cQuery +="ON B1_COD=C6_PRODUTO  AND SB1.B1_SETOR <> '39'  and SB1.D_E_L_E_T_='' "

cQuery +="left JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) "
cQuery +="ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV and SD2.D2_QTDEDEV > 0 AND SD2.D_E_L_E_T_ = ' ' "
cQuery +="AND SD2.D2_QTDEDEV > 0 "
//
cQuery +="left JOIN SC9020 SC9 (NOLOCK) "
cQuery +="ON C6_FILIAL = C9_FILIAL AND C9_NFISCAL = '' AND C9_SEQUEN  = '01' AND C9_BLCRED IN ('09') AND "
cQuery +="C5_ENTREG BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND A1_COD = C9_CLIENTE AND A1_LOJA = C9_LOJA AND "
cQuery +="C9_PRODUTO = B1_COD AND C6_NUM = C9_PEDIDO  AND SC9.D_E_L_E_T_ = ''  "
//
cQuery +="WHERE "
cQuery +="SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery +="SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118' ) AND "
cQuery +="SC6.D_E_L_E_T_ = ' ' "

cQuery +="group by C5_VEND1 ,A3_NOME,A1_COD,A1_LOJA,A1_NOME,C5_NUM "

TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

while AUXZ->(!EOF())    
    AADD(_aArra,{AUXZ->C5_VEND1,AUXZ->A3_NOME,AUXZ->A1_COD,AUXZ->A1_LOJA,AUXZ->A1_NOME,AUXZ->C5_NUM,(AUXZ->VENDIDO_KG-AUXZ->DEV_KG)-AUXZ->PED_REJ_KG,(AUXZ->VENDIDO_RS-AUXZ->DEV_RS)-AUXZ->PED_REJ_RS,(((AUXZ->VENDIDO_RS-AUXZ->DEV_RS)-AUXZ->PED_REJ_RS)/((AUXZ->VENDIDO_KG-AUXZ->DEV_KG)-AUXZ->PED_REJ_KG)) })
    AUXZ->(DBSKIP())
Enddo

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Pedido De: "+dtoc(MV_PAR01)+" Ate: "+dtoc(MV_PAR02), _aCabe, _aArra}})})
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf
                                

Return 


***************

Static Function fPedPro()

***************

Private _aArra:={}
Private _aCabe:={'CODIGO','VENDEDOR','CLIENTE','LOJA','NOME','FAMILIA','SUBLINHA','PRODUTO','DESCRICAO','VENDIDO_KG','VENDIDO_R$','PRECO_MEDIO'}


If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf

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
cQuery +="SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC ) AS VENDIDO_RS , "
cQuery +="SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO) AS VENDIDO_KG     , "
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


TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

while AUXZ->(!EOF())
    AADD(_aArra,{AUXZ->REP,AUXZ->NOME_REP,AUXZ->CODIGO,AUXZ->LOJA,AUXZ->NOME,AUXZ->FAMILIA,AUXZ->SUBLINHA,AUXZ->PRODUTO,AUXZ->DESCRICAO,(AUXZ->VENDIDO_KG-AUXZ->DEV_KG)-AUXZ->PED_REJ_KG,(AUXZ->VENDIDO_RS-AUXZ->DEV_RS)-AUXZ->PED_REJ_RS,(((AUXZ->VENDIDO_RS-AUXZ->DEV_RS)-AUXZ->PED_REJ_RS)/((AUXZ->VENDIDO_KG-AUXZ->DEV_KG)-AUXZ->PED_REJ_KG))})
    AUXZ->(DBSKIP())
Enddo

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf



MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Pedido por Produto De: "+dtoc(MV_PAR01)+" Ate: "+dtoc(MV_PAR02), _aCabe, _aArra}})})
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf
                                

Return 

