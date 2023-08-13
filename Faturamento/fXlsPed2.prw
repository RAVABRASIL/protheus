#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

*********************
User Function fXlsPed2()
*********************

local cQuery :=''


ValidPerg('FXLSPED2')

IF !Pergunte('FXLSPED2',.T.)

   Return 

ENDIF


MsAguarde( { || fPedido() }, "Aguarde. . .", " " )   



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
cQuery +="      C5_VEND1 ,A3_NOME,A1_COD,A1_LOJA,A1_NOME,C5_NUM, "
cQuery +="            SUM((SC6.C6_QTDVEN * SC6.C6_PRUNIT)-SC6.C6_VALDESC ) AS VENDIDO_RS ,SUM(( SC6.C6_QTDVEN)*SB1.B1_PESO) AS PESO     "
cQuery +="   FROM "
cQuery +="      "+RetSqlName("SB1")+" SB1 with (nolock), "+RetSqlName("SC5")+" SC5 with (nolock),"+RetSqlName("SC6")+" SC6 with (nolock),"+RetSqlName("SA1")+" SA1 with (nolock), "
cQuery +="      "+RetSqlName("SA3")+" SA3 with (nolock) "
cQuery +="   WHERE "
cQuery +="      SC5.C5_FILIAL = SC6.C6_FILIAL AND SC6.C6_BLQ <> 'R' AND "
cQuery +="      SC5.C5_VEND1 = SA3.A3_COD  AND SB1.B1_TIPO = 'PA' AND "
cQuery +="      C5_TIPO='N' AND "
cQuery +="      SC5 .C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery +="      SB1.B1_COD = "
cQuery +="      ( CASE WHEN LEN(C6_PRODUTO)>=8 THEN "
cQuery +="       CASE when (Substring( C6_PRODUTO, 4, 1 ) IN('R','D')) or  (Substring( C6_PRODUTO, 5, 1 ) IN('R','D')) "
cQuery +="       then SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,4)+SUBSTRING(C6_PRODUTO,8,2) "
cQuery +="       else SUBSTRING(C6_PRODUTO,1,1)+SUBSTRING(C6_PRODUTO,3,3)+SUBSTRING(C6_PRODUTO,7,2) end  "
cQuery +="       ELSE RTRIM(C6_PRODUTO) END ) AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery +="      SC5.C5_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' AND "
cQuery +="      SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5118','6118','5949','6949','5922','6922','5116','6116','6108') AND "
cQuery +="      SB1.D_E_L_E_T_ = ' ' AND "
cQuery +="      SA1.D_E_L_E_T_ = ' ' AND "
cQuery +="      SC5.D_E_L_E_T_ = ' ' AND "
cQuery +="      SC6.D_E_L_E_T_ = ' ' "
cQuery +="      GROUP BY C5_VEND1,A3_NOME,A1_COD,A1_LOJA,C5_NUM,A1_NOME "
cQuery +="      ORDER BY C5_NUM "


TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

while AUXZ->(!EOF())

    AADD(_aArra,{AUXZ->C5_VEND1,AUXZ->A3_NOME,AUXZ->A1_COD,AUXZ->A1_LOJA,AUXZ->A1_NOME,AUXZ->C5_NUM,AUXZ->PESO,AUXZ->VENDIDO_RS,(AUXZ->VENDIDO_RS/AUXZ->PESO)})
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


