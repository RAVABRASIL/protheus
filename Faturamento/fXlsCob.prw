#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

*********************
User Function fXlsCob()
*********************

local cQuery :=''


ValidPerg('FXLSCOB')

IF !Pergunte('FXLSCOB',.T.)

   Return 

ENDIF

MsAguarde( { || fCobCli() }, "Aguarde. . .", " " )   



Return 



***************

Static Function ValidPerg(cPerg)

***************

PutSx1( cPerg,'01','Data De     ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'02','Data Ate    ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )

Return


***************

Static Function fCobCli()

***************

Private _aArra:={}
Private _aCabe:={'GERENT','NOME_GEREN','REPRES','NOME_REP','COBERTURA','UF','MES/ANO'}


If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf

cQuery :="SELECT "
cQuery +="GERENT,NOME_GEREN=ISNULL((SELECT RTRIM(SA3X.A3_NOME) FROM SA3010 SA3X WHERE SA3X.A3_COD = GERENT AND SA3X.D_E_L_E_T_ <> '*'),''), "
cQuery +="REPRES,NOME_REP, "
cQuery +="COBERTURA=COUNT(SEQ), "
cQuery +="UF, "
cQuery +="ANOMES "
cQuery +="FROM( "
cQuery +="SELECT "
cQuery +="GERENT=A3_SUPER, "
cQuery +="REPRES=A3_COD,NOME_REP=A3_NOME, "
cQuery +="CLIENTE=A1_COD,LOJA=A1_LOJA, "
cQuery +="UF=A1_EST, "
cQuery +="ANOMES=LEFT(C5_ENTREG,6), "
cQuery +="SEQ=ROW_NUMBER() OVER(ORDER BY A1_COD,A1_LOJA) "
cQuery +="FROM  "
cQuery +=""+RetSqlName("SC6")+" SC6 (NOLOCK),"+RetSqlName("SC5")+" SC5 (NOLOCK),"+RetSqlName("SA1")+" SA1 (NOLOCK),"+RetSqlName("SA3")+" SA3 (NOLOCK) "
cQuery +=",SB1010 SB1 (NOLOCK) "
cQuery +="WHERE "
cQuery +="C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  "
cQuery +="AND C5_ENTREG BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cQuery +="AND SC5.D_E_L_E_T_ = ' ' "
cQuery +="AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery +="SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118' ) AND "
cQuery +="A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = ' '  AND "
cQuery +="SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_='' AND "
cQuery +="B1_COD=C6_PRODUTO  AND SB1.B1_SETOR <> '39'  AND "
cQuery +="SB1.D_E_L_E_T_='' AND "
cQuery +="SC6.D_E_L_E_T_ = ' ' "
cQuery +="GROUP BY "
cQuery +="A3_SUPER,A3_COD,A3_NOME,A1_EST, LEFT(C5_ENTREG,6),A1_COD,A1_LOJA "
cQuery +=") AS TABX "
cQuery +="GROUP BY "
cQuery +="GERENT, "
cQuery +="REPRES,NOME_REP, "
cQuery +="UF, "
cQuery +="ANOMES  "
cQuery +="ORDER BY ANOMES  "
TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

while AUXZ->(!EOF())    
    AADD(_aArra,{AUXZ->GERENT,AUXZ->NOME_GEREN,AUXZ->REPRES,AUXZ->NOME_REP,AUXZ->COBERTURA,AUXZ->UF,SUBSTR(AUXZ->ANOMES,5,2)+'/'+SUBSTR(AUXZ->ANOMES,1,4)} )
    AUXZ->(DBSKIP())
Enddo

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","De: "+dtoc(MV_PAR01)+" Ate: "+dtoc(MV_PAR02), _aCabe, _aArra}})})
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf
                                

Return 
