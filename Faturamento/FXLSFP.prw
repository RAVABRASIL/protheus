#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

*********************
User Function fXlsFP()
*********************

local cQuery :=''

ValidPerg('FXLSFP')

IF !Pergunte('FXLSFP',.T.)

   Return 

ENDIF




MsAguarde( { || fListA(SUBSTR(MV_PAR01,1,2),SUBSTR(MV_PAR01,4,4)) }, "Aguarde. . .", "Curva " )   


Return 



***************

Static Function ValidPerg(cPerg)

***************

PutSx1( cPerg,'01','Periodo     ?','','','mv_ch1','C',07,0,0,'G','','','','','mv_par01','','','','','','','','','','','','','','','','',{},{},{} )
PutSx1( cperg,'02', 'Valores em   ?', '', '', 'mv_ch2', 'N', 01, 0, 0, 'C', '', ''   , '', '', 'mv_par02', 'KG', '', '', '' , 'R$', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )

Return


***************

Static Function fListA(nMes,nAno)

***************

local cQuery
local aMes180   := f180Dias(nMes,nAno)
local aMeses180 := fMeses180(nMes,nAno)

local lReal   := (MV_PAR02==2)


Private aArray:={}
Private aCabec:={}

Aadd( aCabec,  "COORDENADOR" )
Aadd( aCabec,  "CODIGO" )
Aadd( aCabec,  "REPRESENTANTE" )
Aadd( aCabec,  "CLIENTE" )
Aadd( aCabec,  "LOJA" )
Aadd( aCabec,  "NOME" )
Aadd( aCabec,  "UF" )

for _XY := 1 to Len(aMeses180)
    Aadd( aCabec,  Left(aMeses180[_XY,1],3)+"/"+Right(aMeses180[_XY,1],2) )	 
next _XY


cQuery := "SELECT "

cQuery += "COORDENADOR, "
cQuery += "CODIGO,REPRESENTANTE, "
cQuery += "CLIENTE,LOJA,NOME, "

for _X := 1 to Len(aMeses180)
   cQuery += "   "+aMeses180[_X,1]+" = SUM(CASE WHEN PERIODO = '"+aMeses180[_X,2]+"' THEN LIQUIDO ELSE 0 END ), "
next _X


cQuery += "UF "

cQuery += "FROM ( "

cQuery += "SELECT  "

cQuery += "COORDENADOR=ISNULL((SELECT RTRIM(SA3X.A3_NOME) FROM SA3010 SA3X WHERE SA3X.A3_COD = SA3.A3_SUPER AND SA3X.D_E_L_E_T_ <> '*'),RTRIM(SA3.A3_NOME)), "
cQuery += "CODIGO=A3_COD,REPRESENTANTE=RTRIM(A3_NOME), "
cQuery += "CLIENTE=A1_COD,LOJA=A1_LOJA,NOME=RTRIM(A1_NOME), "
cQuery += "UF=A1_EST, "
cQuery += "PERIODO=LEFT(D2_EMISSAO,6), "

IF lReal
   cQuery += "LIQUIDO=SUM((D2_QUANT-D2_QTDEDEV)*D2_PRCVEN) "
ELSE
   cQuery += "LIQUIDO=SUM(CASE WHEN D2_SERIE = '   ' AND F2_VEND1 NOT LIKE '%VD%' THEN (0) ELSE ((D2_QUANT-D2_QTDEDEV)*(D2_PESO )) END) "
ENDIF

cQuery += "FROM "

cQuery += "SD2020 SD2 with (nolock), SB1010 SB1 with (nolock), SF2020 SF2 with (nolock), "
cQuery += "SA3010 SA3 with (nolock), SA1010 SA1 with (nolock) "

cQuery += "WHERE "

cQuery += "D2_EMISSAO BETWEEN '"+aMes180[1]+"' AND '"+aMes180[2]+"' AND "
cQuery += "F2_VEND1 = A3_COD  AND D2_TIPO = 'N' AND D2_TP != 'AP' AND  "
cQuery += "SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND " 
cQuery += "RTRIM(D2_CF) IN ( '5101','5107','5108','6101','5102','6102','6109','6107','6108','5949','6949','5922','6922','5116','6116','5118','6118' ) AND "
cQuery += "D2_CLIENTE NOT IN ('031732','031733') AND D2_COD = B1_COD AND SB1.B1_SETOR <>'39' AND "
cQuery += "D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA = F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA AND F2_DUPL <> ' ' AND  "
cQuery += "SB1.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY    A3_SUPER,A3_COD,RTRIM(A3_NOME), "
cQuery += "A1_COD,A1_LOJA,RTRIM(A1_NOME) ,LEFT(D2_EMISSAO,6) ,A1_EST "

cQuery += ") AS TABX "

cQuery += "GROUP BY COORDENADOR, CODIGO,REPRESENTANTE, CLIENTE,LOJA,NOME, UF "


if Select("ATIV") > 0
	ATIV->(DbCloseArea())
endif
TCQUERY cQuery NEW ALIAS "ATIV"


while !ATIV->(EOF()) 

    AADD(aArray,{ATIV->COORDENADOR,ATIV->CODIGO,ATIV->REPRESENTANTE,ATIV->CLIENTE,ATIV->LOJA,ATIV->NOME,ATIV->UF,IIF(Len(aMeses180)>=1,&("ATIV->"+aMeses180[1,1]),0),IIF(Len(aMeses180)>=2,&("ATIV->"+aMeses180[2,1]),0),IIF(Len(aMeses180)>=3,&("ATIV->"+aMeses180[3,1]),0),IIF(Len(aMeses180)>=4,&("ATIV->"+aMeses180[4,1]),0), IIF(Len(aMeses180)>=5,&("ATIV->"+aMeses180[5,1]),0),IIF(Len(aMeses180)>=6,&("ATIV->"+aMeses180[6,1]),0),IIF(Len(aMeses180)>=7,&("ATIV->"+aMeses180[7,1]),0) })  
  
  ATIV->(DBSKIP())

ENDDO

If Select("ATIV") > 0
	DbSelectArea("ATIV")
	ATIV->(DbCloseArea())
EndIf


MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","FATURAMENTO :"+IIF(LReal,' Em Reais',' Em Kg'), aCabec, aArray}})})
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
	Return()
EndIf


Return 



***********************************
static function f180Dias(nMes,nAno)
***********************************

local aRet    := {}
local dDtAnt  := CtoD( "01/"+nMes+"/"+nAno ) - 180
local nMesAnt := Month( dDtAnt )
local nAnoAnt := Year( dDtAnt )
local cIni    := DtoS( CtoD("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) )  )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(VAL(nMes),2)+"/"+Str(VAL(nAno)) ) ) )

Aadd( aRet, cIni )
Aadd( aRet, cFim )

return aRet


************************************
static function fMeses180(nMes,nAno)
************************************

local aRet    := {}
local dDtAnt  := CtoD( "01/"+nMes+"/"+nAno ) - 180
local nMesAnt := Month( dDtAnt )
local nAnoAnt := Year( dDtAnt )
local cIni    := DtoS( CtoD("01/"+StrZero(nMesAnt,2)+"/"+Str(nAnoAnt) )  )
local cFim    := DtoS( LastDay( Ctod("01/"+StrZero(VAL(nMes),2)+"/"+Str(VAL(nAno)) ) ) )
Local aMES    := { 'JAN','FEV','MAR','ABR','MAI','JUN',;
                   'JUL','AGO','SET','OUT','NOV','DEZ' }
while Left(cIni,6) <= Left(cFim,6)
   Aadd( aRet, { aMes[Month(StoD(cIni))]+Right(Str(Year(StoD(cIni))),2) , AllTrim(Str(Year(StoD(cIni)))+StrZero(Month(StoD(cIni)),2)) } )
   cIni := DtoS( StoD( cIni ) + 31 )
end

return aRet


