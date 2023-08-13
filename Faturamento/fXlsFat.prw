#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

*********************
User Function fXlsFa()
*********************

local cQuery :=''


ValidPerg('FXLSFA')

IF !Pergunte('FXLSFA',.T.)

   Return 

ENDIF


if MV_PAR03=1 // CLIENTE

   MsAguarde( { || fFatCli() }, "Aguarde. . .", " " )   

ELSEif MV_PAR03=2   // PRODUTO

   MsAguarde( { || fFatPro() }, "Aguarde. . .", " " )   

ENDIF



Return 



***************

Static Function ValidPerg(cPerg)

***************

PutSx1( cPerg,'01','Data De     ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'02','Data Ate    ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )

Return


***************

Static Function fFatCli()

***************

Private aArray:={}
Private aCabec:={'COD_COOD','COORDENADOR','CODIGO','REPRESENTANTE','CLIENTE','LOJA','NOME','BRUTO_KG','BRUTO_RS','DEV_KG','DEV_RS','LIQUIDO_KG','LIQUIDO_RS','PRECO_MEDIO','UF','BONIF_KG'}


If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


cQuery :="SELECT "

cQuery +="A1_EST,COD_COOD=SA3.A3_SUPER,COORDENADOR=ISNULL((SELECT RTRIM(SA3X.A3_NOME) FROM SA3010 SA3X WHERE SA3X.A3_COD = SA3.A3_SUPER AND SA3X.D_E_L_E_T_ <> '*'),''), "
cQuery +="CODIGO=A3_COD,REPRESENTANTE=RTRIM(A3_NOME), "
cQuery +="CLIENTE=A1_COD,LOJA=A1_LOJA,NOME=RTRIM(A1_NOME), "  

cQuery +="BRUTO_RS=SUM((D2_QUANT)*D2_PRCVEN), "               
cQuery +="BRUTO_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' OR D2_CF IN ('5910','6910','5936','6936') THEN (0) ELSE ((D2_QUANT)*(D2_PESO)) END), "

cQuery +="DEV_RS=SUM((D2_QTDEDEV)*D2_PRCVEN), "               
cQuery +="DEV_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' OR D2_CF IN ('5910','6910','5936','6936') THEN (0) ELSE ((D2_QTDEDEV)*(D2_PESO )) END), "


cQuery +="LIQUIDO_RS=SUM((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN), "               
cQuery +="LIQUIDO_KG=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' OR D2_CF IN ('5910','6910','5936','6936') THEN (0) ELSE ((D2_QUANT-D2_QTDEDEV)*(D2_PESO )) END), "
cQuery +="BON_KG=SUM(CASE WHEN D2_CF IN ('5910','6910','5936','6936') THEN ((D2_QUANT-D2_QTDEDEV)*(D2_PESO )) ELSE (0) END) "

cQuery +="FROM "

cQuery +=""+RetSqlName("SD2")+" SD2 with (nolock), "+RetSqlName("SB1")+" SB1 with (nolock), "+RetSqlName("SF2")+" SF2 with (nolock), "
cQuery +=""+RetSqlName("SA3")+" SA3 with (nolock), "+RetSqlName("SA1")+" SA1 with (nolock) "

cQuery +="WHERE "

cQuery +="D2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND "
cQuery +="F2_VEND1 = A3_COD  AND D2_TIPO = 'N' AND D2_TP != 'AP' AND  "
cQuery +="SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND  "
cQuery +="RTRIM(D2_CF) IN ('5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118','6118','6119','5910','6910','5936','6936') AND "
cQuery +="D2_CLIENTE NOT IN ('031732','031733') AND D2_COD = B1_COD AND SB1.B1_SETOR <>'39' AND "
if MV_PAR04 == 2
	cQuery += "SD2.D2_CLIENTE NOT IN ('006543','007005') and "
endIf
If !Empty(MV_PAR05)
	cQuery += "SD2.D2_FILIAL = '" + mv_par05 + "' AND "
endIf
cQuery +="D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA AND  "
cQuery +="SB1.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' "
cQuery +="GROUP BY    A3_SUPER,A3_COD,RTRIM(A3_NOME), "
cQuery +="A1_COD,A1_LOJA,RTRIM(A1_NOME),A1_EST  "

TCQUERY cQuery NEW ALIAS "AUXZ"

//MemoWrite("C:\temp\fFatCli.txt",cQuery)

AUXZ->(DbGoTop()) 

while AUXZ->(!EOF())

    AADD(aArray,{AUXZ->COD_COOD,AUXZ->COORDENADOR,AUXZ->CODIGO,AUXZ->REPRESENTANTE,AUXZ->CLIENTE,AUXZ->LOJA,AUXZ->NOME,AUXZ->BRUTO_KG,AUXZ->BRUTO_RS,AUXZ->DEV_KG,AUXZ->DEV_RS,AUXZ->LIQUIDO_KG,AUXZ->LIQUIDO_RS,AUXZ->LIQUIDO_RS/AUXZ->LIQUIDO_KG,AUXZ->A1_EST,AUXZ->BON_KG})
    AUXZ->(DBSKIP())
Enddo

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Faturamento CLiente De: "+dtoc(MV_PAR01)+" Ate: "+dtoc(MV_PAR02), aCabec, aArray}})})
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf
                                

Return 


***************

Static Function fFatPro()

***************

Private aArray:={}
Private aCabec:={'COD_COOD','COORDENADOR','COD_REP','REPRESENTANTE','COD_SEG','CLIENTE','LOJA','NOME','CODIGO_FAMILIA','FAMILIA','SUBLINHA','PRODUTO','DESCRICAO','FATURA_KG','FATURA_RS','PRECO_MEDIO','UF','BONIF_KG'}


If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


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

//Memowrite("C:\temp\fxlfat.txt",cQuery)
TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

while AUXZ->(!EOF())

    AADD(aArray,{AUXZ->COD_COOD,AUXZ->COORDENADOR,AUXZ->COD_REP,AUXZ->REPRESENTANTE,AUXZ->COD_SEG,AUXZ->CLIENTE,AUXZ->LOJA,AUXZ->NOME,AUXZ->CODIGO_FAMILIA,AUXZ->FAMILIA,AUXZ->SUBLINHA,AUXZ->PRODUTO,AUXZ->DESCRICAO,AUXZ->FATURA_KG,AUXZ->FATURA_RS,AUXZ->FATURA_RS/AUXZ->FATURA_KG,AUXZ->UF,AUXZ->BONIF_KG})
    AUXZ->(DBSKIP())
Enddo

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Faturamento Produto De: "+dtoc(MV_PAR01)+" Ate: "+dtoc(MV_PAR02), aCabec, aArray}})})
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf
                                

Return 
