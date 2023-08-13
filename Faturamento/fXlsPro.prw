#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

*********************
User Function fXlsPro()
*********************

local cQuery :=''


ValidPerg('FXLSPRO')

IF !Pergunte('FXLSPRO',.T.)

   Return 

ENDIF


MsAguarde( { || fPro() }, "Aguarde. . .", " " )   




Return 



***************

Static Function ValidPerg(cPerg)

***************

PutSx1( cPerg,'01','Produto De     ?','','','mv_ch1','C',06,0,0,'G','','SB1','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'02','Produto Ate    ?','','','mv_ch2','C',06,0,0,'G','','SB1','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )

Return


***************

Static Function fPro()

***************

Private aArray:={}
Private aCabec:={"CODIGO_FAMILIA","FAMILIA","PRODUTO","DESCRICAO","LITRAGEM","MEDIDA","COR"}


If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


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



TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

while AUXZ->(!EOF())
    _cMedida:= cvaltochar(AUXZ->LARGURA)+' X '+cvaltochar(AUXZ->COMPRIMENTO)
    AADD(aArray,{AUXZ->CODIGO_FAMILIA,AUXZ->FAMILIA,AUXZ->PRODUTO,AUXZ->DESCRICAO,AUXZ->LITRAGEM,_cMedida,AUXZ->COR })
    AUXZ->(DBSKIP())
Enddo

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Produto De: "+(MV_PAR01)+" Ate: "+(MV_PAR02), aCabec, aArray}})})
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf
                                

Return 


