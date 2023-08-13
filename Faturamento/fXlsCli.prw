#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

*********************
User Function fXlsCli()
*********************

local cQuery :=''


ValidPerg('FXLSCLI')

IF !Pergunte('FXLSCLI',.T.)

   Return 

ENDIF


MsAguarde( { || fCli() }, "Aguarde. . .", " " )   



Return 



***************

Static Function ValidPerg(cPerg)

***************

PutSx1( cPerg,'01','Cliente De     ?','','','mv_ch1','C',06,0,0,'G','','SA1CLI','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'02','Cliente Ate    ?','','','mv_ch2','C',06,0,0,'G','','SA1CLI','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )

Return


***************

Static Function fCli()

***************

Private aArray:={}
Private aCabec:={"COORDENADOR","CODIGO","REPRESENTANTE","COD_SEG","SEGMENTO","CLIENTE","LOJA","NOME","ENDERECO","BAIRRO","CIDADE","UF","CEP","TELEFONE","DT_ULT_ENTREGA","PRIMEIRA_COMPRA","GRUPO_VENDA","NOME_GRUPO_VENDA"}


If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


cQuery:="SELECT "
cQuery+="GRUPO_VENDA=A1_GRPVEN , "
cQuery+="COORDENADOR=ISNULL((SELECT RTRIM(SA3X.A3_NOME) FROM SA3010 SA3X WHERE SA3X.A3_COD = SA3.A3_SUPER AND SA3X.D_E_L_E_T_ <> '*'),RTRIM(SA3.A3_NOME)), "
cQuery+="CODIGO=A3_COD,REPRESENTANTE=RTRIM(A3_NOME), "
cQuery+="CLIENTE=A1_COD,LOJA=A1_LOJA,NOME=RTRIM(A1_NOME), "
cQuery+="ENDERECO=A1_END, "
cQuery+="BAIRRO=A1_BAIRRO, "
cQuery+="CIDADE=A1_MUN, "
cQuery+="UF=A1_EST, "
cQuery+="CEP=A1_CEP, "

cQuery+="COD_SEG=A1_SATIV1,SEGMENTO=(SELECT X5_DESCRI FROM SX5020 SX5 "
cQuery+="WHERE "
cQuery+="X5_FILIAL='01' "
cQuery+="AND X5_TABELA='T3' "
cQuery+="AND X5_CHAVE=A1_SATIV1  "
cQuery+="AND D_E_L_E_T_=''), "
cQuery+="TELEFONE=A1_TEL "
// DATA DA ULTIMA ENTREGA 
cQuery+=",DT_ULT_ENTREGA=(SELECT TOP 1 CONVERT(varchar(10),CONVERT(smalldatetime, F2_REALCHG), 103) FROM SF2020 SF2 "
cQuery+="WHERE F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA AND F2_REALCHG<>'' "
cQuery+="AND SF2.D_E_L_E_T_='' "
cQuery+="ORDER BY F2_REALCHG DESC ) "

cQuery+=",PRICOM=CASE WHEN A1_PRICOM<>'' THEN CONVERT(varchar(10),CONVERT(smalldatetime, A1_PRICOM), 103) ELSE '' END  "

cQuery+="FROM "
cQuery+=""+RetSqlName("SA3")+" SA3 with (nolock), "+RetSqlName("SA1")+" SA1 with (nolock) "
cQuery+="WHERE "
cQuery+="A1_VEND=A3_COD "
cQuery+="AND A1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery+="AND A1_MSBLQL<>'1' "
cQuery+="AND A1_ATIVO<>'N' "
cQuery+="and SA1.D_E_L_E_T_ <> '*' " 
cQuery+="AND SA3.D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

while AUXZ->(!EOF())
    _cNomGrVe:=Posicione( "ACY", 1, xFilial("ACY") + AUXZ->GRUPO_VENDA, "ACY_DESCRI")
    AADD(aArray,{AUXZ->COORDENADOR,AUXZ->CODIGO,AUXZ->REPRESENTANTE,AUXZ->COD_SEG,AUXZ->SEGMENTO,AUXZ->CLIENTE,AUXZ->LOJA,AUXZ->NOME,AUXZ->ENDERECO,AUXZ->BAIRRO,AUXZ->CIDADE,AUXZ->UF,Transform(AUXZ->CEP,PesqPict("SA1","A1_CEP")),Transform( AUXZ->TELEFONE, PesqPict("SA1","A1_TEL")),AUXZ->DT_ULT_ENTREGA,AUXZ->PRICOM,AUXZ->GRUPO_VENDA,_cNomGrVe})
    AUXZ->(DBSKIP())
Enddo

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Cliente De: "+(MV_PAR01)+" Ate: "+(MV_PAR02), aCabec, aArray}})})
If !ApOleClient("MSExcel") 
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf
              
Return 


