#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

*********************

User Function fXlstel()

*********************

local cQuery :=''


ValidPerg('FXLSTEL')

IF !Pergunte('FXLSTEL',.T.)

   Return 

ENDIF




MsAguarde( { || fFone() }, "Aguarde. . .", " " )   



Return 



***************

Static Function ValidPerg(cPerg)

***************

PutSx1( cPerg,'01','Data De     ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cPerg,'02','Data Ate    ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02','','','','','','','','','','','','','','','','',{},{},{} )

Return


***************

Static Function fFone()

***************

Private aArray:={}
Private aCabec:={'GERENTE','NOME_GERENTE','REPRESENTANTE','NOME_REPRESENTANTE','DATA','HORA','DURACAO','TELEFONE'}


If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


cQuery :="SELECT NOME_GEREN=(ISNULL((SELECT RTRIM(SA3X.A3_NOME) FROM SA3010 SA3X WHERE SA3X.A3_COD = Z53_GERENT AND SA3X.D_E_L_E_T_ <> '*'),'')),NOME_REP='',REP='',* FROM "+RetSqlName("Z53")+" Z53 "
cQuery +="WHERE Z53_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
cQuery +="AND Z53.D_E_L_E_T_='' "
cQuery +="ORDER BY Z53_DATA,Z53_HORA,Z53_GERENT "



TCQUERY cQuery NEW ALIAS "AUXZ"

AUXZ->(DbGoTop()) 

while AUXZ->(!EOF())
    
    aInf:=FCODNOM(AUXZ->Z53_TEL)
    IF !EMPTY(aInf[1][1])
       AADD(aArray,{AUXZ->Z53_GERENT,AUXZ->NOME_GERENT,aInf[1][1],aInf[1][2],DTOC(STOD(AUXZ->Z53_DATA)),AUXZ->Z53_HORA,AUXZ->Z53_DURACA,AUXZ->Z53_TEL})
    ENDIF
    AUXZ->(DBSKIP())
Enddo

If Select("AUXZ") > 0
	DbSelectArea("AUXZ")
	AUXZ->(DbCloseArea())
EndIf


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Ligacoes De: "+dtoc(MV_PAR01)+" Ate: "+dtoc(MV_PAR02), aCabec, aArray}})})
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf
                                

Return 




*************

STATIC FUNCTION FCODNOM(cTel)

*************

LOCAL aRet:={}


	cQuery :="SELECT A3_COD,A3_NOME FROM SA3010 SA3 "
	cQuery +="WHERE (A3_TEL ='"+cTel+"' OR A3_TELCEL ='"+cTel+"' OR A3_CEL='"+cTel+"' ) "
	cQuery +="AND SA3.D_E_L_E_T_='' "

	
	If Select("AUXD") > 0
		DbSelectArea("AUXD")
		AUXD->(DbCloseArea())
	EndIf
	TCQUERY cQuery NEW ALIAS "AUXD"
	
	AUXD->(DbGoTop())
	
IF  AUXD->(!EOF())

	do While  AUXD->(!EOF())

		Aadd( aRet, { AUXD->A3_COD,AUXD->A3_NOME } )
		AUXD->(DBSKIP())
	Enddo

ELSE
		Aadd( aRet, { " "," " } )

ENDIF

	AUXD->(DbCloseArea())

RETURN aRet

