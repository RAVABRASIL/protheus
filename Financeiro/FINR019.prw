#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#include  "Tbiconn.ch "

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑณPrograma  :FINR019 ณ Autor :Gustavo Costa         ณ Data :29/08/2014   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao : Fun็ใo para calcular a bonifica็ใo dos representantes e    ณฑฑ
ฑฑณ 			 Coordenadores.                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametros:                                                            ณฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function FINR019()
	
Local cPerg	:= "FINR19"
Local nValendo:=SuperGetMV("RV_FINR19",,.T.)


	criaSx1(cPerg)

	
	IF !Pergunte(cPerg, .T.)
	
	   Return 
	
	ENDIF
	

	//Bonus dos representantes
	Processa({|| U_fBonusRep(mv_par01) }, "Calculando Representantes" )
	//Bonus dos coordenadores
	//Processa({|| U_fBonusCoo(mv_par01) }, "Calculando Coordenadores" )
	//Gravaas bonifica็๕es
	Processa({|| U_fGrvComis(mv_par01) }, "Gerando Bonifica็๕es" )
    
	//IF nValendo
		//Gravas bonifica็๕es POR VENDAS
		//Processa({|| U_fGrvCoven(mv_par01)  }, "Gerando Bonifica็๕es Vendas " )
	//Endif
	
	Processa({|| U_fGrvVDOB(mv_par01)  }, "Gerando Bonifica็๕es Reativados " )

Return

//+-----------------------------------------------------------------------------------------------+
//! Fun็ใo para cria็ใo das perguntas (se nใo existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
Static Function criaSX1(cPerg)

putSx1(cPerg, '01', 'Competencia?'     	, '', '', 'mv_ch1', 'C', 6                     	, 0, 0, 'G', '', ''   , '', '', 'mv_par01','','','','','','','','','','','','','','','','',{"Digite o mes e ano MMAAAA"},{},{})

return  


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑณPrograma  :FINR019 ณ Autor :Gustavo Costa         ณ Data :29/08/2014   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao : Fun็ใo para calcular a bonifica็ใo dos representantes e    ณฑฑ
ฑฑณ 			 Coordenadores.                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametros:                                                            ณฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function WFINR019()

RPCSetType( 3 )
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "WFINR019" Tables "SE2"
sleep( 5000 )
conOut( "Inicio do Programa WFINR019 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
U_fBonusRep()
U_fBonusCoo()
conOut( "Fim do Programa WFINR019 na emp. 02 filial " + xFilial() + " " + Dtoc( Date() ) + ' - ' + Time() )
Reset environment

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fBonusRep() บAutor  ณ  Gustavo Costa    บ Data ณ 29/08/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescricao : Fun็ใo para calcular a bonifica็ใo dos representantes      ณฑฑ
ฑฑบ          ณ        												           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fBonusRep(cComp)

Local cArquivo	:= "REP"
Local d1			:= CtoD("01/" + subStr(cComp,1,2) + "/" + subStr(cComp,3,4))  
Local d2			:= LastDay(d1)

//******************************************************
// Calculo das devolu็๕es
//******************************************************

cQryx	:= " SELECT SUBSTRING(C5_VEND1,1,4) VENDEDOR,  SUBSTRING(C5_EMISSAO,1,6) COMPETENCIA, " 

/*  KG
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN SD2.D2_QTDEDEV * SB1.B1_PESO ELSE 0 END ) AS DEV_QT_INST, " 
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('C') THEN SD2.D2_QTDEDEV * SB1.B1_PESO ELSE 0 END ) AS DEV_QT_HOSP, "
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN SD2.D2_QTDEDEV * SB1.B1_PESO ELSE 0 END ) AS DEV_QT_DOM "
*/

// R$
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN SD2.D2_QTDEDEV * SD2.D2_PRCVEN ELSE 0 END ) AS DEV_QT_INST, " 
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('C') THEN SD2.D2_QTDEDEV * SD2.D2_PRCVEN ELSE 0 END ) AS DEV_QT_HOSP, "
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN SD2.D2_QTDEDEV * SD2.D2_PRCVEN ELSE 0 END ) AS DEV_QT_DOM "
//   

cQryx	+= " FROM " + RETSQLNAME("SC6") + " SC6 (NOLOCK)"
cQryx	+= " INNER JOIN " + RETSQLNAME("SC5") + " SC5 (NOLOCK)"
cQryx	+= " ON C6_FILIAL = C5_FILIAL "
cQryx	+= " AND C6_NUM = C5_NUM "
cQryx	+= " INNER JOIN " + RETSQLNAME("SB1") + " SB1 (NOLOCK)"
cQryx	+= " ON C6_PRODUTO = B1_COD "
cQryx	+= " INNER JOIN " + RETSQLNAME("SD2") + " SD2 (NOLOCK)"
cQryx	+= " ON C6_FILIAL = D2_FILIAL "
cQryx	+= " AND C6_NUM = D2_PEDIDO "
cQryx	+= " AND C6_ITEM = D2_ITEMPV "
cQryx	+= " WHERE "
cQryx	+= " SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND " 
cQryx	+= " SC6.C6_CF IN ( '5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119' ) AND " 
cQryx	+= " SB1.B1_SETOR <> '39' AND "
cQryx	+= " SC5.C5_EMISSAO BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "' AND " 
cQryx	+= " SB1.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SC5.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SC6.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SD2.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SD2.D2_QTDEDEV > 0 "
cQryx	+= " GROUP BY SUBSTRING(C5_VEND1,1,4), SUBSTRING(C5_EMISSAO,1,6) "
cQryx	+= " ORDER BY SUBSTRING(C5_VEND1,1,4) "


If Select("REP") > 0
	REP->( dbCloseArea() )
EndIf

TCQUERY cQryx NEW ALIAS "REP"

REP->(dbGoTop())

WHILE !REP->(EOF())
	
	dbSelectArea("ZB8")
	
	If ZB8->(dbSeek( xFilial("ZB8") + REP->COMPETENCIA + REP->VENDEDOR ))
	
		RECLOCK("ZB8",.F.)
		
		ZB8->ZB8_FILIAL := xFilial("ZB8")
		ZB8->ZB8_DEVIN 	:= REP->DEV_QT_INST
		ZB8->ZB8_DEVHO 	:= REP->DEV_QT_HOSP
		ZB8->ZB8_DEVDO 	:= REP->DEV_QT_DOM
		
		MsUnLock()
	
	Else

		RECLOCK("ZB8",.T.)
		
		ZB8->ZB8_FILIAL := xFilial("ZB8")
		ZB8->ZB8_COD 	:= REP->VENDEDOR
		ZB8->ZB8_COMP 	:= REP->COMPETENCIA
		ZB8->ZB8_DEVIN 	:= REP->DEV_QT_INST
		ZB8->ZB8_DEVHO 	:= REP->DEV_QT_HOSP
		ZB8->ZB8_DEVDO 	:= REP->DEV_QT_DOM
		ZB8->ZB8_USER 	:= cUserName
		ZB8->ZB8_DATAAT := date()
		
		MsUnLock()

	EndIf
	
	REP->(DbSKIP())

EndDO

REP->( dbCloseArea() )


//*********************************************************
// Meta dos representantes
//*********************************************************
/*
cQryx	:= " SELECT SUBSTRING(C5_VEND1,1,4) VENDEDOR,  SUBSTRING(C5_ENTREG,1,6) COMPETENCIA, " 
cQryx	+= " SUM( SC6.C6_QTDVEN * SB1.B1_PESO) AS CARTEIRA_QT, "
cQryx	+= " SUM(SC6.C6_QTDVEN  * (CASE WHEN C6_DESCONT>0 THEN SC6.C6_PRCVEN ELSE SC6.C6_PRUNIT END ) ) AS CARTEIRA_RS, " 
cQryx	+= " ( SELECT SUM(Z51_MVALOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SC5.C5_VEND1,1,4) AND D_E_L_E_T_ <> '*') AS META "
*/

cQryx	:= " SELECT SUBSTRING(F2_VEND1,1,4) VENDEDOR,  SUBSTRING(C5_EMISSAO,1,6) COMPETENCIA, " 

/* KG
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN SC9.C9_QTDLIB * SB1.B1_PESO ELSE 0 END ) AS QT_INST, " 
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('C') THEN SC9.C9_QTDLIB * SB1.B1_PESO ELSE 0 END ) AS QT_HOSP, "
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN SC9.C9_QTDLIB * SB1.B1_PESO ELSE 0 END ) AS QT_DOME, "
*/

// R$
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN SD2.D2_TOTAL ELSE 0 END ) AS QT_INST, " 
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('C') THEN SD2.D2_TOTAL ELSE 0 END ) AS QT_HOSP, "
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN SD2.D2_TOTAL ELSE 0 END ) AS QT_DOME, "

//cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN SC9.C9_QTDLIB * SC9.C9_PRCVEN ELSE 0 END ) AS QT_INST, " 
//cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('C') THEN SC9.C9_QTDLIB * SC9.C9_PRCVEN ELSE 0 END ) AS QT_HOSP, "
//cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN SC9.C9_QTDLIB * SC9.C9_PRCVEN ELSE 0 END ) AS QT_DOME, "
//

//cQryx	+= " SUM(SC6.C6_QTDVEN  * (CASE WHEN C6_DESCONT>0 THEN SC6.C6_PRCVEN ELSE SC6.C6_PRUNIT END ) ) AS CARTEIRA_RS, "

/* KG
cQryx	+= " ISNULL(( SELECT SUM(Z51_MVALOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SC5.C5_VEND1,1,4) AND D_E_L_E_T_ <> '*' AND Z51_LINHA = 'INST' AND Z51_ANO = '" + SubStr(DtoS(d1),1,4) + "'),0) AS META_INST, "
cQryx	+= " ISNULL(( SELECT SUM(Z51_MVALOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SC5.C5_VEND1,1,4) AND D_E_L_E_T_ <> '*' AND Z51_LINHA = 'DOME' AND Z51_ANO = '" + SubStr(DtoS(d1),1,4) + "'),0) AS META_DOME, "
cQryx	+= " ISNULL(( SELECT SUM(Z51_MVALOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SC5.C5_VEND1,1,4) AND D_E_L_E_T_ <> '*' AND Z51_LINHA = 'HOSP' AND Z51_ANO = '" + SubStr(DtoS(d1),1,4) + "'),0) AS META_HOSP "
*/

// R$
cQryx	+= " ISNULL(( SELECT SUM(Z51_MVALOR*Z51_MFATOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SF2.F2_VEND1,1,4) AND D_E_L_E_T_ <> '*' AND Z51_LINHA = 'INST' AND Z51_ANO = '" + SubStr(DtoS(d1),1,4) + "'),0) AS META_INST, "
cQryx	+= " ISNULL(( SELECT SUM(Z51_MVALOR*Z51_MFATOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SF2.F2_VEND1,1,4) AND D_E_L_E_T_ <> '*' AND Z51_LINHA = 'DOME' AND Z51_ANO = '" + SubStr(DtoS(d1),1,4) + "'),0) AS META_DOME, "
cQryx	+= " ISNULL(( SELECT SUM(Z51_MVALOR*Z51_MFATOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SF2.F2_VEND1,1,4) AND D_E_L_E_T_ <> '*' AND Z51_LINHA = 'HOSP' AND Z51_ANO = '" + SubStr(DtoS(d1),1,4) + "'),0) AS META_HOSP "
//

cQryx	+= " FROM " + RETSQLNAME("SD2") + " SD2 "
cQryx	+= " INNER JOIN " + RETSQLNAME("SF2") + " SF2 "
cQryx	+= " ON D2_FILIAL = F2_FILIAL "
cQryx	+= " AND D2_DOC = F2_DOC " 
cQryx	+= " AND D2_SERIE = F2_SERIE  "
cQryx	+= " INNER JOIN " + RETSQLNAME("SC6") + " SC6 (NOLOCK)"
cQryx	+= " ON C6_FILIAL = D2_FILIAL "
cQryx	+= " AND C6_NUM = D2_PEDIDO "
cQryx	+= " AND C6_ITEM = D2_ITEMPV "
cQryx	+= " INNER JOIN " + RETSQLNAME("SB1") + " SB1 "
cQryx	+= " ON D2_COD = B1_COD "
cQryx	+= " INNER JOIN " + RETSQLNAME("SC5") + " SC5 (NOLOCK)"
cQryx	+= " ON C6_FILIAL = C5_FILIAL "
cQryx	+= " AND C6_NUM = C5_NUM "
cQryx	+= " WHERE "
cQryx	+= " SB1.B1_TIPO = 'PA' AND " 
cQryx	+= " SD2.D2_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119' ) AND " 
cQryx	+= " SB1.B1_SETOR <> '39' AND "
cQryx	+= " SC5.C5_EMISSAO BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "' AND " 
cQryx	+= " SB1.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SF2.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SC5.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SC6.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SD2.D_E_L_E_T_ = ' ' "
cQryx	+= " GROUP BY SUBSTRING(F2_VEND1,1,4), SUBSTRING(C5_EMISSAO,1,6) "
cQryx	+= " ORDER BY SUBSTRING(F2_VEND1,1,4) "

If Select("REP") > 0
	REP->( dbCloseArea() )
EndIf

TCQUERY cQryx NEW ALIAS "REP"

REP->(dbGoTop())

WHILE !REP->(EOF())
	
	dbSelectArea("ZB8")
	
	If ZB8->(dbSeek( xFilial("ZB8") + REP->COMPETENCIA + REP->VENDEDOR ))
	
		RECLOCK("ZB8",.F.)
		
		ZB8->ZB8_FILIAL  	:= xFilial("ZB8")
		ZB8->ZB8_CARTIN 	:= REP->QT_INST
		ZB8->ZB8_CARTHO 	:= REP->QT_HOSP
		ZB8->ZB8_CARTDO 	:= REP->QT_DOME
		//ZB8->ZB8_CARTRS	    := REP->CARTEIRA_RS
		ZB8->ZB8_METAIN 	:= REP->META_INST
		ZB8->ZB8_METADO 	:= REP->META_DOME
		ZB8->ZB8_METAHO 	:= REP->META_HOSP
		ZB8->ZB8_PERCIN 	:= ((REP->QT_INST - ZB8->ZB8_DEVIN) / REP->META_INST) * 100
		ZB8->ZB8_PERCDO 	:= ((REP->QT_DOME - ZB8->ZB8_DEVDO) / REP->META_DOME) * 100
		ZB8->ZB8_PERCHO 	:= ((REP->QT_HOSP - ZB8->ZB8_DEVHO) / REP->META_HOSP) * 100
		ZB8->ZB8_USER 	    := cUserName
		ZB8->ZB8_DATAAT 	:= date()
		
		MsUnLock()

	Else
	
		RECLOCK("ZB8",.T.)
		
		ZB8->ZB8_FILIAL  	:= xFilial("ZB8")
		ZB8->ZB8_COD 		:= REP->VENDEDOR
		ZB8->ZB8_COMP 	    := REP->COMPETENCIA
		ZB8->ZB8_CARTIN 	:= REP->QT_INST
		ZB8->ZB8_CARTHO 	:= REP->QT_HOSP
		ZB8->ZB8_CARTDO 	:= REP->QT_DOME
		//ZB8->ZB8_CARTRS	    := REP->CARTEIRA_RS
		ZB8->ZB8_METAIN 	:= REP->META_INST
		ZB8->ZB8_METADO 	:= REP->META_DOME
		ZB8->ZB8_METAHO 	:= REP->META_HOSP
		ZB8->ZB8_PERCIN 	:= (REP->QT_INST / REP->META_INST) * 100
		ZB8->ZB8_PERCDO 	:= (REP->QT_DOME / REP->META_DOME) * 100
		ZB8->ZB8_PERCHO 	:= (REP->QT_HOSP / REP->META_HOSP) * 100
		ZB8->ZB8_USER 	    := cUserName
		ZB8->ZB8_DATAAT 	:= date()
		
		MsUnLock()
	
	EndIf
	
	REP->(DbSKIP())

EndDO

REP->( dbCloseArea() )


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fBonusCoo() บAutor  ณ  Gustavo Costa    บ Data ณ 29/08/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescricao : Fun็ใo para calcular a bonifica็ใo dos Coordenadores       ณฑฑ
ฑฑบ          ณ        												      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fBonusCoo(cComp)

Local cArquivo	:= "COO"
Local d1			:= CtoD("01/" + subStr(cComp,1,2) + "/" + subStr(cComp,3,4))  
Local d2			:= LastDay(d1)

//******************************************************
// Calculo das devolu็๕es
//******************************************************

cQryx	:= " SELECT A3_SUPER COORDENADOR, COMPETENCIA, SUM(DEV_QT_INST) DEV_QT_INST, SUM(DEV_QT_HOSP) DEV_QT_HOSP, SUM(DEV_QT_DOM) DEV_QT_DOM FROM "
cQryx	+= " (SELECT SUBSTRING(C5_VEND1,1,4) VENDEDOR, A3_SUPER,  SUBSTRING(C5_ENTREG,1,6) COMPETENCIA, "

/* KG
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN SD2.D2_QTDEDEV * SB1.B1_PESO ELSE 0 END ) AS DEV_QT_INST, "
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('C') THEN SD2.D2_QTDEDEV * SB1.B1_PESO ELSE 0 END ) AS DEV_QT_HOSP, "
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN SD2.D2_QTDEDEV * SB1.B1_PESO ELSE 0 END ) AS DEV_QT_DOM "
*/

// R$
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN SD2.D2_QTDEDEV * SD2.D2_PRCVEN ELSE 0 END ) AS DEV_QT_INST, "
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('C') THEN SD2.D2_QTDEDEV * SD2.D2_PRCVEN ELSE 0 END ) AS DEV_QT_HOSP, "
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN SD2.D2_QTDEDEV * SD2.D2_PRCVEN ELSE 0 END ) AS DEV_QT_DOM "
//

cQryx	+= " FROM " + RETSQLNAME("SC6") + " SC6 (NOLOCK)"
cQryx	+= " INNER JOIN " + RETSQLNAME("SC5") + " SC5 (NOLOCK)"
cQryx	+= " ON C6_FILIAL = C5_FILIAL "
cQryx	+= " AND C6_NUM = C5_NUM "
cQryx	+= " INNER JOIN " + RETSQLNAME("SB1") + " SB1 (NOLOCK)"
cQryx	+= " ON C6_PRODUTO = B1_COD "
cQryx	+= " INNER JOIN " + RETSQLNAME("SD2") + " SD2 (NOLOCK)"
cQryx	+= " ON C6_FILIAL = D2_FILIAL "
cQryx	+= " AND C6_NUM = D2_PEDIDO "
cQryx	+= " AND C6_ITEM = D2_ITEMPV "
cQryx	+= " INNER JOIN " + RETSQLNAME("SA3") + " SA3 (NOLOCK)"
cQryx	+= " ON C5_VEND1 = A3_COD "
cQryx	+= " WHERE "
cQryx	+= " SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND " 
cQryx	+= " SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119' ) AND " 
cQryx	+= " SB1.B1_SETOR <> '39' AND "
cQryx	+= " SC5.C5_ENTREG BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "' AND " 
cQryx	+= " SB1.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SC5.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SC6.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SD2.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SD2.D2_QTDEDEV > 0 "
cQryx	+= " GROUP BY SUBSTRING(C5_VEND1,1,4), SUBSTRING(C5_ENTREG,1,6), A3_SUPER) AS REP "
cQryx	+= " GROUP BY A3_SUPER, COMPETENCIA "
cQryx	+= " ORDER BY COORDENADOR "

If Select("COO") > 0
	COO->( dbCloseArea() )
EndIf

TCQUERY cQryx NEW ALIAS "COO"

COO->(dbGoTop())

WHILE !COO->(EOF())
	
	dbSelectArea("ZB8")
	
	If ZB8->(dbSeek( xFilial("ZB8") + COO->COMPETENCIA + COO->COORDENADOR ))
	
		RECLOCK("ZB8",.F.)
		
		ZB8->ZB8_FILIAL := xFilial("ZB8")
		ZB8->ZB8_DEVIN 	:= COO->DEV_QT_INST
		ZB8->ZB8_DEVHO 	:= COO->DEV_QT_HOSP
		ZB8->ZB8_DEVDO 	:= COO->DEV_QT_DOM
		
		MsUnLock()
	
	Else

		RECLOCK("ZB8",.T.)
		
		ZB8->ZB8_FILIAL := xFilial("ZB8")
		ZB8->ZB8_COD 	:= COO->COORDENADOR
		ZB8->ZB8_COMP 	:= COO->COMPETENCIA
		ZB8->ZB8_DEVIN 	:= COO->DEV_QT_INST
		ZB8->ZB8_DEVHO 	:= COO->DEV_QT_HOSP
		ZB8->ZB8_DEVDO 	:= COO->DEV_QT_DOM
		ZB8->ZB8_USER 	:= cUserName
		ZB8->ZB8_DATAAT := date()
		
		MsUnLock()

	EndIf
	
	COO->(DbSKIP())

EndDO

COO->( dbCloseArea() )

//*********************************************************
// Meta dos coordenadores
//*********************************************************
/*
cQryx	:= " SELECT A3_SUPER COORDENADOR, COMPETENCIA, SUM(CARTEIRA_QT) CARTEIRA_QT, SUM(CARTEIRA_RS) CARTEIRA_RS, SUM(META) META FROM ( " 
cQryx	+= " SELECT SUBSTRING(C5_VEND1,1,4) VENDEDOR,  SUBSTRING(C5_ENTREG,1,6) COMPETENCIA, A3_SUPER, "
cQryx	+= " SUM( SC6.C6_QTDVEN * SB1.B1_PESO) AS CARTEIRA_QT, "
cQryx	+= " SUM(SC6.C6_QTDVEN * (CASE WHEN C6_DESCONT>0 THEN SC6.C6_PRCVEN ELSE SC6.C6_PRUNIT END ) ) AS CARTEIRA_RS, " 
cQryx	+= " ( SELECT SUM(Z51_MVALOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SC5.C5_VEND1,1,4) AND D_E_L_E_T_ <> '*') AS META "
*/
cQryx	:= " SELECT A3_SUPER COORDENADOR, COMPETENCIA, SUM(CARTEIRA_QT_INST) QT_INST, SUM(CARTEIRA_QT_HOSP) QT_HOSP, " 
cQryx	+= " SUM(CARTEIRA_QT_DOM) QT_DOME, SUM(CARTEIRA_RS) CARTEIRA_RS, "
cQryx	+= " SUM(META_INST) META_INST, SUM(META_DOME) META_DOME, SUM(META_HOSP) META_HOSP FROM ( "
cQryx	+= " SELECT SUBSTRING(C5_VEND1,1,4) VENDEDOR,  SUBSTRING(C5_ENTREG,1,6) COMPETENCIA, A3_SUPER, "

/* KG
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN SC9.C9_QTDLIB * SB1.B1_PESO ELSE 0 END ) AS CARTEIRA_QT_INST, " 
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('C') THEN SC9.C9_QTDLIB * SB1.B1_PESO ELSE 0 END ) AS CARTEIRA_QT_HOSP, "
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN SC9.C9_QTDLIB * SB1.B1_PESO ELSE 0 END ) AS CARTEIRA_QT_DOM, "
*/

// R$
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN C6_QTDVEN * C6_PRUNIT - C6_VALDESC ELSE 0 END ) AS CARTEIRA_QT_INST, " 
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('C') THEN C6_QTDVEN * C6_PRUNIT - C6_VALDESC ELSE 0 END ) AS CARTEIRA_QT_HOSP, "
cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN C6_QTDVEN * C6_PRUNIT - C6_VALDESC ELSE 0 END ) AS CARTEIRA_QT_DOM, "

//cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('A','B','G') THEN SC9.C9_QTDLIB * SC9.C9_PRCVEN ELSE 0 END ) AS CARTEIRA_QT_INST, " 
//cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('C') THEN SC9.C9_QTDLIB * SC9.C9_PRCVEN ELSE 0 END ) AS CARTEIRA_QT_HOSP, "
//cQryx	+= " SUM( CASE WHEN B1_GRUPO IN ('D','E') THEN SC9.C9_QTDLIB * SC9.C9_PRCVEN ELSE 0 END ) AS CARTEIRA_QT_DOM, "
//

cQryx	+= " SUM(SC6.C6_QTDVEN  * (CASE WHEN C6_DESCONT>0 THEN SC6.C6_PRCVEN ELSE SC6.C6_PRUNIT END ) ) AS CARTEIRA_RS, "

/* KG
cQryx	+= " ISNULL(( SELECT SUM(Z51_MVALOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SC5.C5_VEND1,1,4) AND D_E_L_E_T_ <> '*' AND Z51_LINHA = 'INST'),0) AS META_INST, "
cQryx	+= " ISNULL(( SELECT SUM(Z51_MVALOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SC5.C5_VEND1,1,4) AND D_E_L_E_T_ <> '*' AND Z51_LINHA = 'DOME'),0) AS META_DOME, "
cQryx	+= " ISNULL(( SELECT SUM(Z51_MVALOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SC5.C5_VEND1,1,4) AND D_E_L_E_T_ <> '*' AND Z51_LINHA = 'HOSP'),0) AS META_HOSP "
*/

// R$
cQryx	+= " ISNULL(( SELECT SUM(Z51_MVALOR*Z51_MFATOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SC5.C5_VEND1,1,4) AND D_E_L_E_T_ <> '*' AND Z51_LINHA = 'INST'),0) AS META_INST, "
cQryx	+= " ISNULL(( SELECT SUM(Z51_MVALOR*Z51_MFATOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SC5.C5_VEND1,1,4) AND D_E_L_E_T_ <> '*' AND Z51_LINHA = 'DOME'),0) AS META_DOME, "
cQryx	+= " ISNULL(( SELECT SUM(Z51_MVALOR*Z51_MFATOR/12) FROM Z51020 WHERE Z51_REPRES = SUBSTRING(SC5.C5_VEND1,1,4) AND D_E_L_E_T_ <> '*' AND Z51_LINHA = 'HOSP'),0) AS META_HOSP "
//

cQryx	+= " FROM " + RETSQLNAME("SC6") + " SC6 "
cQryx	+= " INNER JOIN " + RETSQLNAME("SC5") + " SC5 "
cQryx	+= " ON C6_FILIAL = C5_FILIAL "
cQryx	+= " AND C6_NUM = C5_NUM "
cQryx	+= " INNER JOIN " + RETSQLNAME("SB1") + " SB1 "
cQryx	+= " ON C6_PRODUTO = B1_COD "
cQryx	+= " INNER JOIN " + RETSQLNAME("SC9") + " SC9 "
cQryx	+= " ON C6_FILIAL = C9_FILIAL "
cQryx	+= " AND C6_NUM = C9_PEDIDO "
cQryx	+= " AND C6_ITEM = C9_ITEM "
cQryx	+= " INNER JOIN " + RETSQLNAME("SA3") + " SA3 "
cQryx	+= " ON C5_VEND1 = A3_COD "
cQryx	+= " WHERE "
cQryx	+= " SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND " 
cQryx	+= " SC9.C9_BLCRED IN( '  ','04','10') AND " 
cQryx	+= " SC6.C6_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119' ) AND " 
cQryx	+= " SB1.B1_SETOR <> '39' AND "
cQryx	+= " SC5.C5_EMISSAO > '201408' and "
cQryx	+= " SC5.C5_ENTREG BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "' AND " 
cQryx	+= " SB1.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SC5.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SC6.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SC9.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SA3.D_E_L_E_T_ = ' ' "
cQryx	+= " GROUP BY SUBSTRING(C5_VEND1,1,4),  SUBSTRING(C5_ENTREG,1,6), A3_SUPER ) AS TABELA_REP "
cQryx	+= " GROUP BY A3_SUPER, COMPETENCIA "
cQryx	+= " ORDER BY A3_SUPER "

If Select("COO") > 0
	COO->( dbCloseArea() )
EndIf

TCQUERY cQryx NEW ALIAS "COO"

COO->(dbGoTop())

WHILE !COO->(EOF())
	
	dbSelectArea("ZB8")
	
	If ZB8->(dbSeek( xFilial("ZB8") + COO->COMPETENCIA + COO->COORDENADOR ))
	
		RECLOCK("ZB8",.F.)
		
		ZB8->ZB8_FILIAL  	:= xFilial("ZB8")
		ZB8->ZB8_CARTIN 	:= COO->QT_INST
		ZB8->ZB8_CARTHO 	:= COO->QT_HOSP
		ZB8->ZB8_CARTDO 	:= COO->QT_DOME
		ZB8->ZB8_CARTRS	    := COO->CARTEIRA_RS
		ZB8->ZB8_METAIN 	:= COO->META_INST
		ZB8->ZB8_METADO 	:= COO->META_DOME
		ZB8->ZB8_METAHO 	:= COO->META_HOSP
		ZB8->ZB8_PERCIN 	:= ((COO->QT_INST - ZB8->ZB8_DEVIN) / COO->META_INST) * 100
		ZB8->ZB8_PERCDO 	:= ((COO->QT_DOME - ZB8->ZB8_DEVDO) / COO->META_DOME) * 100
		ZB8->ZB8_PERCHO 	:= ((COO->QT_HOSP - ZB8->ZB8_DEVHO) / COO->META_HOSP) * 100
		ZB8->ZB8_USER 	    := cUserName
		
		MsUnLock()

	Else
	
		RECLOCK("ZB8",.T.)
		
		ZB8->ZB8_FILIAL  	:= xFilial("ZB8")
		ZB8->ZB8_COD 		:= COO->COORDENADOR
		ZB8->ZB8_COMP 	    := COO->COMPETENCIA
		ZB8->ZB8_CARTIN 	:= COO->QT_INST
		ZB8->ZB8_CARTHO 	:= COO->QT_HOSP
		ZB8->ZB8_CARTDO 	:= COO->QT_DOME
		ZB8->ZB8_CARTRS	    := COO->CARTEIRA_RS
		ZB8->ZB8_METAIN 	:= COO->META_INST
		ZB8->ZB8_METADO 	:= COO->META_DOME
		ZB8->ZB8_METAHO 	:= COO->META_HOSP
		ZB8->ZB8_PERCIN 	:= (COO->QT_INST / COO->META_INST) * 100
		ZB8->ZB8_PERCDO 	:= (COO->QT_DOME / COO->META_DOME) * 100
		ZB8->ZB8_PERCHO 	:= (COO->QT_HOSP / COO->META_HOSP) * 100
		ZB8->ZB8_USER 	    := cUserName
		
		MsUnLock()
	
	EndIf
	
	COO->(DbSKIP())

EndDO

COO->( dbCloseArea() )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvComis บAutor  ณ  Gustavo Costa      บ Data ณ 03/09/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a base do valor da comissใo.                        บฑฑ
ฑฑบ          ณ														           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fGrvComis(cComp)

Local cQuery 		:= ""
Local nPerc		:= 0
Local d1			:= CtoD("01/" + subStr(cComp,1,2) + "/" + subStr(cComp,3,4))  
Local d2			:= LastDay(d1)
Local cMeta		:= ""
Local _cFilial	:= ""
Local _cVend	:= ""
Local _cNum		:= ""
Local _cPref	:= ""
Local _cParc	:= ""
Local _nBase	:= 0
Local lJaPulou	:= .F.
Local cCompete	:= ""
Local nVendaLiq	:= 0
Local lContinua := .F.

cQuery	:= " SELECT * FROM  " + RETSQLNAME("SE3") + " E3 "
cQuery	+= " WHERE D_E_L_E_T_ <> '*' "
cQuery	+= " AND E3_EMISSAO BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "'"
cQuery	+= " AND E3_TIPO = 'NF' AND E3_SEQ!='BV'  " // BONIFICACAO DE VENDA FAZ NA OUTRA FUNCAO 
cQuery	+= " AND E3_COMIS <> 0 "
//cQuery	+= " AND E3_DATA = '' "
//cQuery	+= " AND E3_VEND LIKE '0201%' " 
//cQuery	+= " AND E3_VEND NOT IN ('0228','0315','0342','2367','2348','2758','2757','2756','2754','2755') " 
//cQuery	+= " AND E3_VEND NOT IN ('0316','0228','0315','0342','2367','2348','2758','2757','2756','2754','2755','2750','2751','2774','2753','2776','2783')  "
cQuery	+= " AND E3_VEND NOT IN ('0316','0228','0315','0342','2367','2348','2756','2755','2750','2751','2774','2753','2776','2783')  "
cQuery	+= " ORDER BY E3_FILIAL, E3_VEND, E3_NUM, E3_PREFIXO, E3_PARCELA "

If Select("XMP") > 1
	XMP->(dbCloseArea())
EndIf
	
TCQUERY cQuery NEW ALIAS "XMP"
TCSetField( 'XMP', "E3_EMISSAO", "D" )
TCSetField( 'XMP', "E3_VENCTO", "D" )

dbSelectArea("XMP")

count to nREGTOT
XMP->( DbGoTop() )
ProcRegua( nREGTOT )

While XMP->(!Eof())
	
	cCompete 	:= fCompNF(XMP->E3_FILIAL, XMP->E3_NUM, XMP->E3_PREFIXO)
	cMeta		:= fBateuMet(SubStr(XMP->E3_VEND,1,4), cCompete)
	
	If Alltrim(XMP->E3_VEND) $ GetNewPar("MV_XCODVSP","2757")
	
		nVendaLiq := fVendaRep("2757", cCompete)
		If nVendaLiq >= 282697.80 
		
			lContinua := .T.
		
		EndIf	
	
	Else
		
		lContinua := ("INST" $ cMeta .OR. "DOME" $ cMeta .OR. "HOSP" $ cMeta ) .AND. !(Alltrim(XMP->E3_VEND) $ '0228,0350,0357,0357VD') // Isaac e Renata (nใo tem bonifica็ใo)
	
	EndIf
	
	If lContinua 
	
		//Se for coordenador
		If Alltrim(XMP->E3_VEND) $ GetNewPar("MV_XCODCOO","0228,0315,0342,2348,2367")
			
			// verifica se os produtos da nota estao bonificados e faz o calculo para a proporcionalidade da bonifica็ใo
			nPerc	:= fPercComis("C", XMP->E3_FILIAL, XMP->E3_NUM, XMP->E3_PREFIXO, cMeta,SubStr(XMP->E3_VEND,1,4))
		
		Else
		   
		   If Alltrim(XMP->E3_VEND) $ GetNewPar("MV_XCODVSP","2757")
		   
		   		Do Case
		   			Case nVendaLiq >= 282697.80 .AND. nVendaLiq < 308397.60
		   			 	nPerc := 1
		   			Case nVendaLiq >= 308397.60 .AND. nVendaLiq < 334097.40
		   			 	nPerc := 2
		   			Case nVendaLiq >= 334097.40
		   			 	nPerc := 3
		   		EndCase
		   
		   Else
		    // verifica se os produtos da nota estao bonificados e faz o calculo para a proporcionalidade da bonifica็ใo
		    	nPerc	:= fPercComis("R", XMP->E3_FILIAL, XMP->E3_NUM, XMP->E3_PREFIXO, cMeta,SubStr(XMP->E3_VEND,1,4))
		   EndIf

		
		EndIf
		
		dbselectArea("SE3")
		dbSetOrder(1)
		
		If nPerc > 0
		
			If SE3->(dbSeek(XMP->E3_FILIAL + XMP->E3_PREFIXO + XMP->E3_NUM + XMP->E3_PARCELA + "BN" + XMP->E3_VEND ))
				
				_cFilial	:= XMP->E3_FILIAL
				_cVend		:= XMP->E3_VEND
				_cNum		:= XMP->E3_NUM
				_cPref		:= XMP->E3_PREFIXO
				_cParc		:= XMP->E3_PARCELA
				
				//Se tiver mais de um pagamento para o mesmo titulo, soma todos e lanca um bonus com o total
				
				/*
				While 	XMP->E3_FILIAL == _cFilial .and. XMP->E3_PREFIXO == _cPref .and.  XMP->E3_NUM == _cNum .and. ;
						XMP->E3_PARCELA == _cParc .and. XMP->E3_VEND == _cVend  
				
					_nBase		+= XMP->E3_BASE
					XMP->(dbSkip())
					lJaPulou	:= .T.
					
				EndDo
				*/
					_nBase		:= XMP->E3_BASE
				RecLock("SE3", .F.)
				
				SE3->E3_BASE		:= _nBase //XMP->E3_BASE
				SE3->E3_PORC		:= nPerc
				SE3->E3_COMIS		:= _nBase * (nPerc/100)
				SE3->E3_SEQ			:= "BN"
				SE3->E3_BONUS		:= "S"
				
				MsUnLock()
				
				_nBase := 0
				
			Else
			
				_cFilial	:= XMP->E3_FILIAL
				_cVend		:= XMP->E3_VEND
				_cNum		:= XMP->E3_NUM
				_cPref		:= XMP->E3_PREFIXO
				_cParc		:= XMP->E3_PARCELA
				
				//Se tiver mais de um pagamento para o mesmo titulo, soma todos e lanca um bonus com o total
				//While XMP->E3_FILIAL + XMP->E3_PREFIXO + XMP->E3_NUM + XMP->E3_PARCELA + XMP->E3_VEND == _cFilial + _cVend + _cNum + _cPref + _cParc
				
				/*
				While 	XMP->E3_FILIAL == _cFilial .and. XMP->E3_PREFIXO == _cPref .and.  XMP->E3_NUM == _cNum .and. ;
						XMP->E3_PARCELA == _cParc .and. XMP->E3_VEND == _cVend  
					
					_nBase		+= XMP->E3_BASE
					XMP->(dbSkip())
					lJaPulou	:= .T.
					
				EndDo
                */
                
                _nBase		:= XMP->E3_BASE
                
				RecLock("SE3", .T.)
				
				SE3->E3_FILIAL		:= XMP->E3_FILIAL
				SE3->E3_VEND		:= XMP->E3_VEND
				SE3->E3_NUM			:= XMP->E3_NUM
				SE3->E3_EMISSAO		:= XMP->E3_EMISSAO
				SE3->E3_SERIE		:= XMP->E3_SERIE
				SE3->E3_CODCLI		:= XMP->E3_CODCLI
				SE3->E3_LOJA		:= XMP->E3_LOJA
				SE3->E3_BASE		:= _nBase //XMP->E3_BASE
				SE3->E3_PORC		:= nPerc
				SE3->E3_COMIS		:= _nBase * (nPerc/100)
				SE3->E3_PREFIXO		:= XMP->E3_PREFIXO
				SE3->E3_PARCELA		:= XMP->E3_PARCELA
				SE3->E3_TIPO		:= XMP->E3_TIPO
				SE3->E3_BAIEMI		:= XMP->E3_BAIEMI
				SE3->E3_PEDIDO		:= XMP->E3_PEDIDO
				SE3->E3_SEQ			:= "BN"
				SE3->E3_ORIGEM		:= XMP->E3_ORIGEM
				SE3->E3_VENCTO		:= XMP->E3_VENCTO
				SE3->E3_MOEDA		:= XMP->E3_MOEDA
				SE3->E3_BONUS		:= "S"
				
				MsUnLock()
				
				_nBase := 0
				
			EndIf
		
		EndIf
	
	EndIf
	
	IncProc(XMP->E3_VEND + " - " + XMP->E3_NUM)
	
	If lJaPulou
		lJaPulou	:= .F.
	Else
		XMP->(dbSkip())
	EndIf
	
EndDo

XMP->(dbCloseArea())

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPercComis บAutor  ณ  Gustavo Costa     บ Data ณ 03/09/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a base do valor da comissใo.                        บฑฑ
ฑฑบ          ณ														           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fPercComis(cRepCoo, cFil, cDoc, cSerie, cMeta,cVend)

Local cQuery 		:= ""
Local nPercPad	:= 0
Local nRet			:= 0
Local nPercIN		:= 0
Local nPercHO		:= 0
Local nPercDO		:= 0

If cRepCoo = "R"
	
	  //0201-Bergamo Representa็๕es;0308-Linked Representa็๕es;0083-Soriano Representa็๕es;0127-Mega Representa็๕es; 0262-RC Mag Representa็๕es
	  IF Alltrim(cVend) $ GetNewPar("RV_XBREP","0201/0308/0083/0127/0262")
	  	
	  	If fCompNF(cFil, cDoc, cSerie) $ "201801/201802"
	  		nPercPad	:= GetNewPar("RV_XPEREP",3)  + 1
	  	Else 
	  		nPercPad	:= GetNewPar("RV_XPEREP",3) // ESSES REPRESENTANTES PERMANECE COM PERCENTUAL ANTERIOR 
      	EndIf
      	
      elseIf Alltrim(cVend) $ GetNewPar("RV_XBREP2","2826")
	  		nPercPad	:= 4
		Else
      
			If fCompNF(cFil, cDoc, cSerie) $ "201801/201802"
				nPercPad	:= GetNewPar("MV_XPERCBR",2) + 1
			Else
				nPercPad	:= GetNewPar("MV_XPERCBR",2) //Percentual Representante
			EndIf
        //nPercPad	:= GetNewPar("MV_XPERCBR",3) //Percentual Representante
      endif   

Endif
/*
cQuery	:= " SELECT ROUND((COM/TOTAL),4) AS PERC_COM, ROUND((SEM/TOTAL),4) AS PERC_SEM FROM "
cQuery	+= " (SELECT SUM(D2_TOTAL ) TOTAL, "
cQuery	+= " SUM(CASE WHEN D2_GRUPO IN ('A','B','C','G') THEN D2_TOTAL ELSE 0 END) COM, " 
cQuery	+= " SUM(CASE WHEN D2_GRUPO NOT IN ('A','B','C','G') THEN D2_TOTAL ELSE 0 END) SEM "
*/
cQuery	:= " SELECT ROUND((COM_INST/TOTAL),4) AS PERC_COM_INST,  ROUND((COM_HOSP/TOTAL),4) AS PERC_COM_HOSP,ROUND((COM_DOME/TOTAL),4) AS PERC_COM_DOME, ROUND((SEM/TOTAL),4) AS PERC_SEM FROM " 
cQuery	+= " (SELECT SUM(D2_TOTAL ) TOTAL, "
cQuery	+= " SUM(CASE WHEN D2_GRUPO IN ('A','B','G') THEN D2_TOTAL ELSE 0 END) COM_INST, " 
cQuery	+= " SUM(CASE WHEN D2_GRUPO IN ('C') THEN D2_TOTAL ELSE 0 END) COM_HOSP, "
// ADICIONADO DOMESTICA
cQuery	+= "SUM(CASE WHEN D2_GRUPO IN('D','E') THEN D2_TOTAL ELSE 0 END) COM_DOME, "
//
//cQuery	+= " SUM(CASE WHEN D2_GRUPO NOT IN ('A','B','C','G') THEN D2_TOTAL ELSE 0 END) SEM "
cQuery	+= " SUM(CASE WHEN D2_GRUPO NOT IN ('A','B','C','G','D','E') THEN D2_TOTAL ELSE 0 END) SEM "
cQuery	+= " FROM  " + RETSQLNAME("SD2") + " D2 "
cQuery	+= " WHERE D_E_L_E_T_ <> '*' "
cQuery	+= " AND D2_FILIAL = '" + cFil + "' "
cQuery	+= " AND D2_DOC = '" + cDoc + "' "
cQuery	+= " AND D2_SERIE = '" + cSerie + "' "
cQuery	+= " ) AS TABELA "

If Select("XPE") > 1
	XPE->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XPE"

dbSelectArea("XPE")
dbGoTop()

If XPE->(!Eof())
	
	If XPE->PERC_COM_INST > 0 .AND. "INST" $ cMeta
	
		If cRepCoo = "R"
			nPercIN	:= nPercPad * XPE->PERC_COM_INST
		Else
			nPercIN	:= 0.4 * XPE->PERC_COM_INST
		EndIf
	
	EndIf
	
	If XPE->PERC_COM_HOSP > 0 .AND. "HOSP" $ cMeta
	
		If cRepCoo = "R"
			nPercHO	:= nPercPad * XPE->PERC_COM_HOSP
		Else
			nPercHO	:= 0.3 * XPE->PERC_COM_HOSP
		EndIf
	
	EndIf
    // ADICIONADO DOMESTICA 						//retirado o bonus para os vendedores que ficaram na regra anterior
    If XPE->PERC_COM_DOME > 0 .AND. "DOME" $ cMeta .AND. !(Alltrim(cVend) $ GetNewPar("RV_XBREP","0083/0127/0262"))
	
		If cRepCoo = "R"
			nPercDO	:= nPercPad * XPE->PERC_COM_DOME
		EndIf
	
	EndIf

    //
EndIf

nRet	:= nPercIN + nPercHO+nPercDO

XPE->(dbCloseArea())

Return nRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfBateuMet  บAutor  ณ  Gustavo Costa     บ Data ณ 02/09/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se os vendedores ou coordenadores bateram a meta.  บฑฑ
ฑฑบ          ณ														           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*************

Static Function fBateuMet(cVend, cCompe)

Local cQuery 	:= ""
Local cRet		:= ""

cQuery	:= " SELECT * FROM " + RETSQLNAME("ZB8") + " B8 "
cQuery	+= " WHERE B8.D_E_L_E_T_ <> '*' "
cQuery	+= " AND ( ZB8_PERCIN >= 100 OR ZB8_PERCHO >= 100 OR ZB8_PERCDO >= 100 ) "
cQuery	+= " AND ZB8_COMP = '" + cCompe + "' "
cQuery	+= " AND ZB8_COD = '" + cVend + "' "

If Select("XBM") > 1
	XBM->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "XBM"

dbSelectArea("XBM")
dbGoTop()

If XBM->(!Eof())
	
	If XBM->ZB8_PERCIN >= 100
		cRet	+= "INST/"
	EndIf
	If XBM->ZB8_PERCHO >= 100
		cRet	+= "HOSP/"
	EndIf
	If XBM->ZB8_PERCDO >= 100
		cRet	+= "DOME/"
	EndIf

EndIf

//Corre็ใo das notas devolvidas e refaturadas para considerar meta batida
If cVend == "0308" .AND. cCompe == "201808" // linked 
	cRet	+= "INST/"
EndIf

XBM->(dbCloseArea())

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCompNF    บAutor  ณ  Gustavo Costa     บ Data ณ 02/09/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a competencia da nota fiscal.                       บฑฑ
ฑฑบ          ณ														           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*************

Static Function fCompNF(cFil, cDoc, cSerie)

Local cQuery 	:= ""
Local cRet		:= ""

cQuery	:= " SELECT DISTINCT C5_ENTREG FROM  " + RETSQLNAME("SD2") + " D2 "
cQuery	+= " INNER JOIN  " + RETSQLNAME("SC5") + " C5 " 
cQuery	+= " ON D2_FILIAL = C5_FILIAL "
cQuery	+= " AND D2_PEDIDO = C5_NUM "
cQuery	+= " WHERE D2_DOC = '" + cDoc + "' "
cQuery	+= " AND D2_SERIE = '" + cSerie + "' "
cQuery	+= " AND D2_FILIAL = '" + cFil + "' "
cQuery	+= " AND D2.D_E_L_E_T_ <> '*' "
cQuery	+= " AND C5.D_E_L_E_T_ <> '*' "

If Select("XNF") > 1
	XNF->(dbCloseArea())
EndIf
	
TCQUERY cQuery NEW ALIAS "XNF"

dbSelectArea("XNF")
dbGoTop()

If XNF->(!Eof())
	
	cRet	:= SubStr(XNF->C5_ENTREG,1,6)

EndIf

XNF->(dbCloseArea())

Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvCM1V บAutor  ณ  Gustavo Costa      บ Data ณ 14/07/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava a comissใo da primeira venda.                         บฑฑ
ฑฑบ          ณ										                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fGrvCM1V(cComp)

Local cQuery 		:= ""
Local nPerc		:= 0
Local d1			:= CtoD("01/" + subStr(cComp,1,2) + "/" + subStr(cComp,3,4))  
Local d2			:= LastDay(d1)
Local cMeta		:= ""
Local _cFilial	:= ""
Local _cVend	:= ""
Local _cNum		:= ""
Local _cPref	:= ""
Local _cParc	:= ""
Local _nBase	:= 0
Local lJaPulou	:= .F.
Local cNum1NF	:= ""
	
cQuery	:= " SELECT * FROM  " + RETSQLNAME("SE3") + " E3 "
cQuery	+= " WHERE D_E_L_E_T_ <> '*' "
cQuery	+= " AND E3_EMISSAO BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "'"
cQuery	+= " AND E3_TIPO = 'NF' AND E3_SEQ!='BV' " // BONIFICACAO DE VENDA FAZ EM OUTRA FUNCAO 
cQuery	+= " AND E3_COMIS <> 0 "
//cQuery	+= " AND E3_DATA = '' "
//cQuery	+= " AND E3_VEND LIKE '2345%' " 
//cQuery	+= " AND E3_VEND NOT IN ('0228','0315','0342','2367','2348') " 
//cQuery	+= " AND E3_VEND NOT IN ('0316','0228','0315','0342','2367','2348','2758','2757','2756','2754','2755','2750','2751','2774','2753','2776','2783')  "
cQuery	+= " AND E3_VEND NOT IN ('0316','0228','0315','0342','2367','2348','2756','2755','2750','2751','2774','2753','2776','2783')  "
cQuery	+= " ORDER BY E3_FILIAL, E3_VEND, E3_NUM, E3_PREFIXO, E3_PARCELA "

If Select("XMP") > 1
	XMP->(dbCloseArea())
EndIf
	
TCQUERY cQuery NEW ALIAS "XMP"
TCSetField( 'XMP', "E3_EMISSAO", "D" )
TCSetField( 'XMP', "E3_VENCTO", "D" )

dbSelectArea("XMP")

count to nREGTOT
XMP->( DbGoTop() )
ProcRegua( nREGTOT )

While XMP->(!Eof())
	
	cNum1NF	:= f1Venda(XMP->E3_FILIAL, SubStr(XMP->E3_VEND,1,4), XMP->E3_CODCLI)
	
	If cNum1NF == XMP->E3_NUM
	
		// verifica se os produtos da nota estao bonificados e faz o calculo para a proporcionalidade da bonifica็ใo
		nPerc	:= fPercComis("R", XMP->E3_FILIAL, XMP->E3_NUM, XMP->E3_PREFIXO, cMeta,SubStr(XMP->E3_VEND,1,4))
		
		dbselectArea("SE3")
		dbSetOrder(1)
		
		If nPerc > 0
		
			If SE3->(dbSeek(XMP->E3_FILIAL + XMP->E3_PREFIXO + XMP->E3_NUM + XMP->E3_PARCELA + "BN" + XMP->E3_VEND ))
				
				_cFilial	:= XMP->E3_FILIAL
				_cVend		:= XMP->E3_VEND
				_cNum		:= XMP->E3_NUM
				_cPref		:= XMP->E3_PREFIXO
				_cParc		:= XMP->E3_PARCELA
				
				//Se tiver mais de um pagamento para o mesmo titulo, soma todos e lanca um bonus com o total
				/*
				While 	XMP->E3_FILIAL == _cFilial .and. XMP->E3_PREFIXO == _cPref .and.  XMP->E3_NUM == _cNum .and. ;
						XMP->E3_PARCELA == _cParc .and. XMP->E3_VEND == _cVend  
				
					_nBase		+= XMP->E3_BASE
					XMP->(dbSkip())
					lJaPulou	:= .T.
					
				EndDo
				*/
				
				_nBase		:= XMP->E3_BASE
				
				RecLock("SE3", .F.)
				
				SE3->E3_BASE		:= _nBase //XMP->E3_BASE
				SE3->E3_PORC		:= nPerc
				SE3->E3_COMIS		:= _nBase * (nPerc/100)
				SE3->E3_SEQ			:= "BN"
				SE3->E3_BONUS		:= "S"
				
				MsUnLock()
				
				_nBase := 0
				
			Else
			
				_cFilial	:= XMP->E3_FILIAL
				_cVend		:= XMP->E3_VEND
				_cNum		:= XMP->E3_NUM
				_cPref		:= XMP->E3_PREFIXO
				_cParc		:= XMP->E3_PARCELA
				
				//Se tiver mais de um pagamento para o mesmo titulo, soma todos e lanca um bonus com o total
				//While XMP->E3_FILIAL + XMP->E3_PREFIXO + XMP->E3_NUM + XMP->E3_PARCELA + XMP->E3_VEND == _cFilial + _cVend + _cNum + _cPref + _cParc
				/*
				While 	XMP->E3_FILIAL == _cFilial .and. XMP->E3_PREFIXO == _cPref .and.  XMP->E3_NUM == _cNum .and. ;
						XMP->E3_PARCELA == _cParc .and. XMP->E3_VEND == _cVend  
					
					_nBase		+= XMP->E3_BASE
					XMP->(dbSkip())
					lJaPulou	:= .T.
					
				EndDo
                */
                
                _nBase		:= XMP->E3_BASE
                					
				RecLock("SE3", .T.)
				
				SE3->E3_FILIAL		:= XMP->E3_FILIAL
				SE3->E3_VEND		:= XMP->E3_VEND
				SE3->E3_NUM			:= XMP->E3_NUM
				SE3->E3_EMISSAO		:= XMP->E3_EMISSAO
				SE3->E3_SERIE		:= XMP->E3_SERIE
				SE3->E3_CODCLI		:= XMP->E3_CODCLI
				SE3->E3_LOJA		:= XMP->E3_LOJA
				SE3->E3_BASE		:= _nBase //XMP->E3_BASE
				SE3->E3_PORC		:= nPerc
				SE3->E3_COMIS		:= _nBase * (nPerc/100)
				SE3->E3_PREFIXO		:= XMP->E3_PREFIXO
				SE3->E3_PARCELA		:= XMP->E3_PARCELA
				SE3->E3_TIPO		:= XMP->E3_TIPO
				SE3->E3_BAIEMI		:= XMP->E3_BAIEMI
				SE3->E3_PEDIDO		:= XMP->E3_PEDIDO
				SE3->E3_SEQ			:= "BN"
				SE3->E3_ORIGEM		:= XMP->E3_ORIGEM
				SE3->E3_VENCTO		:= XMP->E3_VENCTO
				SE3->E3_MOEDA		:= XMP->E3_MOEDA
				SE3->E3_BONUS		:= "S"
				
				MsUnLock()
				
				_nBase := 0
				
			EndIf
		
		EndIf
	
	EndIf
	
	IncProc(XMP->E3_VEND + " - " + XMP->E3_NUM)
	
	If lJaPulou
		lJaPulou	:= .F.
	Else
		XMP->(dbSkip())
	EndIf
	
EndDo

XMP->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณf1Venda    บAutor  ณ  Gustavo Costa     บ Data ณ 14/07/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o numero da nota da primeira venda.                 บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*************

Static Function f1Venda(cFil, cVend, cCli)

Local cQuery 	:= ""
Local cRet		:= ""

cQuery	:= " SELECT TOP 1 F2_DOC, F2_EMISSAO FROM  " + RETSQLNAME("SF2") + " F2 "
cQuery	+= " INNER JOIN  " + RETSQLNAME("SD2") + " D2 "
cQuery	+= " ON F2_FILIAL = D2_FILIAL "
cQuery	+= " AND F2_SERIE = D2_SERIE "
cQuery	+= " AND F2_DOC = D2_DOC "
cQuery	+= " AND F2_TIPO = D2_TIPO "
cQuery	+= " AND F2_CLIENTE = D2_CLIENTE "
cQuery	+= " WHERE F2_VEND1 = '" + cVend + "' "
cQuery	+= " AND F2_CLIENTE = '" + cCli + "' "
cQuery	+= " AND F2_FILIAL = '" + cFil + "' "
cQuery	+= " AND F2.D_E_L_E_T_ <> '*' "
cQuery	+= " AND D2.D_E_L_E_T_ <> '*' "
//cQuery	+= " AND SUBSTRING(D2_COD,1,1) NOT IN ('D','E') "
cQuery	+= " ORDER BY F2_EMISSAO "

If Select("XNF") > 1
	XNF->(dbCloseArea())
EndIf
	
TCQUERY cQuery NEW ALIAS "XNF"

dbSelectArea("XNF")
dbGoTop()

If XNF->(!Eof())
	
	cRet	:= XNF->F2_DOC

EndIf

XNF->(dbCloseArea())

Return cRet


*************

User Function fGrvCoven(cComp)

*************

Local cQuery 		:= ""
Local nPerc		:= 0
Local d1			:= CtoD("01/" + subStr(cComp,1,2) + "/" + subStr(cComp,3,4))  
Local d2			:= LastDay(d1)
Local cMeta		:= ""
Local _cFilial	:= ""
Local _cVend	:= ""
Local _cNum		:= ""
Local _cPref	:= ""
Local _cParc	:= ""
Local _nBase	:= 0
Local lJaPulou	:= .F.
// perido da bonificao de vendas 
local cd1BV:=GetNewPar("RV_XD1BV","20160519") 
local cd2BV:=GetNewPar("RV_XD2BV","20160831")  

cQuery	:= " SELECT * FROM  " + RETSQLNAME("SE3") + " E3 ," + RETSQLNAME("SF2") + " SF2 "
cQuery	+= " WHERE E3.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_<>'*' "
cQuery	+= " AND E3_FILIAL='"+xfilial('SE3')+"' "
cQuery	+= " AND E3_EMISSAO BETWEEN '"+DtoS(d1)+"' AND '"+DtoS(d2)+"' "
cQuery	+= "AND E3_EMISSAO BETWEEN '"+cd1BV+"' AND '"+cd2BV+"'"  // PERIODO DA BONIFICACAO VENDA VOLTAR 
cQuery	+= "AND E3_NUM+E3_PREFIXO+E3_CODCLI+E3_LOJA=F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA "
cQuery	+= " AND E3_TIPO = 'NF' AND E3_SEQ!='BN'  " 
cQuery	+= " AND E3_COMIS <> 0  "
//cQuery	+= " AND E3_VEND NOT IN ('0316','0228','0315','0342','2367','2348','2758','2757','2756','2754','2755','2750','2751','2774','2753','2776','2783')  "
cQuery	+= " AND E3_VEND NOT IN ('0316','0228','0315','0342','2367','2348','2756','2755','2750','2751','2774','2753','2776','2783')  "
cQuery	+= "ORDER BY F2_EMISSAO,F2_DOC,F2_SERIE "

If Select("XMP") > 1
	XMP->(dbCloseArea())
EndIf
	
TCQUERY cQuery NEW ALIAS "XMP"
TCSetField( 'XMP', "E3_EMISSAO", "D" )
TCSetField( 'XMP', "E3_VENCTO", "D" )

dbSelectArea("XMP")

count to nREGTOT
XMP->( DbGoTop() )
ProcRegua( nREGTOT )

While XMP->(!Eof())
	

	
	If  !(Alltrim(XMP->E3_VEND) $ '0228,0350,0357,0357VD') // Isaac e Renata (nใo tem bonifica็ใo) 
	
		
		dbselectArea("SE3")
		dbSetOrder(1)
		
		_cVendas:=FVENDAS(XMP->E3_CODCLI,XMP->E3_LOJA,XMP->E3_NUM)
		
		If ! empty(_cVendas) // funcao para pegar as vendas 
		
			nPerc:= XMP->E3_PORC/IIF(_cVendas='CLIREB',2,1)
			
			If SE3->(dbSeek(XMP->E3_FILIAL + XMP->E3_PREFIXO + XMP->E3_NUM + XMP->E3_PARCELA + "BV" + XMP->E3_VEND ))
				
				IF EMPTY(XMP->E3_BONUS) // REGISTRO NORMAL 
				
					_cFilial	:= XMP->E3_FILIAL
					_cVend		:= XMP->E3_VEND
					_cNum		:= XMP->E3_NUM
					_cPref		:= XMP->E3_PREFIXO
					_cParc		:= XMP->E3_PARCELA
					
					_nBase		:= XMP->E3_BASE
					RecLock("SE3", .F.)
					
					SE3->E3_BASE		:= _nBase //XMP->E3_BASE
					SE3->E3_PORC		:= nPerc
					SE3->E3_COMIS		:= _nBase * (nPerc/100)
					SE3->E3_SEQ			:= "BV"
					SE3->E3_BONUS		:= "S"
					
					MsUnLock()
					
					_nBase := 0
					
				ENDIF
			Else
			
				_cFilial	:= XMP->E3_FILIAL
				_cVend		:= XMP->E3_VEND
				_cNum		:= XMP->E3_NUM
				_cPref		:= XMP->E3_PREFIXO
				_cParc		:= XMP->E3_PARCELA
				
                _nBase		:= XMP->E3_BASE
                
				RecLock("SE3", .T.)
				
				SE3->E3_FILIAL		:= XMP->E3_FILIAL
				SE3->E3_VEND		:= XMP->E3_VEND
				SE3->E3_NUM			:= XMP->E3_NUM
				SE3->E3_EMISSAO		:= XMP->E3_EMISSAO
				SE3->E3_SERIE		:= XMP->E3_SERIE
				SE3->E3_CODCLI		:= XMP->E3_CODCLI
				SE3->E3_LOJA		:= XMP->E3_LOJA
				SE3->E3_BASE		:= _nBase //XMP->E3_BASE
				SE3->E3_PORC		:= nPerc
				SE3->E3_COMIS		:= _nBase * (nPerc/100)
				SE3->E3_PREFIXO		:= XMP->E3_PREFIXO
				SE3->E3_PARCELA		:= XMP->E3_PARCELA
				SE3->E3_TIPO		:= XMP->E3_TIPO
				SE3->E3_BAIEMI		:= XMP->E3_BAIEMI
				SE3->E3_PEDIDO		:= XMP->E3_PEDIDO
				SE3->E3_SEQ			:= "BV"
				SE3->E3_ORIGEM		:= XMP->E3_ORIGEM
				SE3->E3_VENCTO		:= XMP->E3_VENCTO
				SE3->E3_MOEDA		:= XMP->E3_MOEDA
				SE3->E3_BONUS		:= "S"
				
				MsUnLock()
				
				_nBase := 0
				
			EndIf
            		
		EndIf
	
	EndIf
	
	IncProc(XMP->E3_VEND + " - " + XMP->E3_NUM)
	
	XMP->(dbSkip())

	
EndDo

XMP->(dbCloseArea())

Return


***************

Static Function FVENDAS(cCliente,cLoja,cNotaE3)

***************

Local cRet    :=' '
Local cQuery  := ""
LOCAL aVendas := {}

nPrzCli:=GetNewPar("RV_ZREPCLI",120)  


/*
cQuery	:= "SELECT  TOP 3 D2_DOC, D2_EMISSAO, D2_CLIENTE,D2_LOJA "
cQuery	+= "FROM " + RETSQLNAME("SD2") + " SD2 "
cQuery	+= "WHERE D2_CLIENTE = '"+cCliente+"' AND D2_LOJA='"+cLoja+"' AND D2_DOC<='"+cNotaE3+"' "
cQuery	+= "AND SD2.D_E_L_E_T_ != '*' "
cQuery	+= "GROUP BY D2_DOC, D2_EMISSAO, D2_CLIENTE,D2_LOJA "
cQuery	+= "ORDER BY D2_EMISSAO  DESC "
*/

cQuery	:= "SELECT  TOP 3 D2_DOC, D2_EMISSAO, D2_CLIENTE,D2_LOJA "
cQuery	+= "FROM " + RETSQLNAME("SD2") + " SD2 "
cQuery	+= "WHERE D2_CLIENTE = '"+cCliente+"' AND D2_LOJA='"+cLoja+"'  AND D2_EMISSAO<=(SELECT D2_EMISSAO FROM SD2020 D2X "
cQuery	+= "                                                            WHERE D2X .D2_DOC='"+cNotaE3+"' AND D2X.D2_CLIENTE='"+cCliente+"' AND D2X.D2_LOJA='"+cLoja+"'  AND D2X.D_E_L_E_T_='' "
cQuery	+= "                                                             GROUP BY D2_EMISSAO "
cQuery	+= "                                                              ) "
cQuery	+= "AND SD2.D_E_L_E_T_ != '*' "
cQuery	+= "GROUP BY D2_DOC, D2_EMISSAO, D2_CLIENTE,D2_LOJA "
cQuery	+= "ORDER BY D2_EMISSAO  DESC "
 
 
If Select("TMPA") > 1
	TMPA->(dbCloseArea())
EndIf
	
TCQUERY cQuery NEW ALIAS "TMPA"
TCSetField( 'TMPA', "D2_EMISSAO", "D" )

TMPA->( DbGoTop() )
If  TMPA->(!Eof())

	While TMPA->(!Eof())			
		Aadd( aVendas, {TMPA->D2_EMISSAO,TMPA->D2_DOC} )		
		TMPA->(dbSkip())	
	EndDo

EndIf


IF len(aVendas)=1

    cRet:='CLINOVO'// CLIENTE NOVO

ElseIF len(aVendas)=2

   // ultima - pnultima >= 180 dias 
   If aVendas[1][1]-aVendas[2][1] >=nPrzCli
      cRet:='CLIREA'// 1 VENDA CLIENTE REATIVADO 
   Endif

ElseIF len(aVendas)=3


   If aVendas[1][1]-aVendas[2][1] >=nPrzCli
      cRet:='CLIREA'// 1 VENDA CLIENTE REATIVADO 
   endif
   
   If empty(cRet) // se ficou vazio e porque nao e 1บ cliente reativado (180 dias)
      IF aVendas[1][1]-aVendas[3][1] >=nPrzCli
         cRet:='CLIREB' // 2 VENDA CLIENTE REATIVADO 
      Endif
   Endif

Endif


TMPA->(dbCloseArea())

Return cRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVendaRep    บAutor  ณ  Gustavo Costa     บ Data ณ 14/07/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o numero da nota da primeira venda.                 บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*************

Static Function fVendaRep(cVend, cComp)

Local cQryx 	:= ""
Local nRet		:= 0
Local d1		:= CtoD("01/" + subStr(cComp,5,2) + "/" + subStr(cComp,1,4))  
Local d2		:= LastDay(d1)

cQryx	:= " SELECT SUBSTRING(F2_VEND1,1,4) VENDEDOR,  SUBSTRING(C5_EMISSAO,1,6) COMPETENCIA, " 

// R$
cQryx	+= " SUM( (D2_QUANT-D2_QTDEDEV)*D2_PRCVEN ) TOTAL " 

cQryx	+= " FROM " + RETSQLNAME("SD2") + " SD2 "
cQryx	+= " INNER JOIN " + RETSQLNAME("SF2") + " SF2 "
cQryx	+= " ON D2_FILIAL = F2_FILIAL "
cQryx	+= " AND D2_DOC = F2_DOC " 
cQryx	+= " AND D2_SERIE = F2_SERIE  "
cQryx	+= " INNER JOIN " + RETSQLNAME("SC6") + " SC6 (NOLOCK)"
cQryx	+= " ON C6_FILIAL = D2_FILIAL "
cQryx	+= " AND C6_NUM = D2_PEDIDO "
cQryx	+= " AND C6_ITEM = D2_ITEMPV "
cQryx	+= " INNER JOIN " + RETSQLNAME("SB1") + " SB1 "
cQryx	+= " ON D2_COD = B1_COD "
cQryx	+= " INNER JOIN " + RETSQLNAME("SC5") + " SC5 (NOLOCK)"
cQryx	+= " ON C6_FILIAL = C5_FILIAL "
cQryx	+= " AND C6_NUM = C5_NUM "
cQryx	+= " WHERE "
cQryx	+= " SB1.B1_TIPO = 'PA' AND " 
cQryx	+= " SD2.D2_CF IN ('5101','5107','6101','5102','6102','6109','6107','5949','6949','5922','6922','5116','6116','6108','5118','6118','6119' ) AND " 
cQryx	+= " SB1.B1_SETOR <> '39' AND "
cQryx	+= " SUBSTRING(F2_VEND1,1,4) = '" + cVend + "' AND "
cQryx	+= " SC5.C5_EMISSAO BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "' AND " 
cQryx	+= " SB1.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SF2.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SC5.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SC6.D_E_L_E_T_ = ' ' AND "
cQryx	+= " SD2.D_E_L_E_T_ = ' ' "
cQryx	+= " GROUP BY SUBSTRING(F2_VEND1,1,4), SUBSTRING(C5_EMISSAO,1,6) "
cQryx	+= " ORDER BY SUBSTRING(F2_VEND1,1,4) "

If Select("XTM") > 0
	XTM->( dbCloseArea() )
EndIf

TCQUERY cQryx NEW ALIAS "XTM"

XTM->(dbGoTop())

If XTM->(!Eof())
	
	nRet	:= XTM->TOTAL

EndIf

XTM->(dbCloseArea())

Return nRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvVDOB บAutor  ณ  Gustavo Costa      บ Data ณ 14/07/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava a comissใo da venda em dobro.                         บฑฑ
ฑฑบ          ณ										                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fGrvVDOB(cComp)

Local cQuery 		:= ""
Local nPerc		:= 0
Local d1			:= CtoD("01/" + subStr(cComp,1,2) + "/" + subStr(cComp,3,4))  
Local d2			:= LastDay(d1)
Local cMeta		:= ""
Local _cFilial	:= ""
Local _cVend	:= ""
Local _cNum		:= ""
Local _cPref	:= ""
Local _cParc	:= ""
Local _nBase	:= 0
Local lJaPulou	:= .F.
Local cNum1NF	:= ""
	
cQuery	:= " SELECT E3.* FROM  " + RETSQLNAME("SE3") + " E3 "
cQuery	+= " INNER JOIN  " + RETSQLNAME("SE1") + " E1 "
cQuery	+= " ON E3_FILIAL + E3_NUM + E3_PREFIXO + E3_PARCELA + E3_TIPO + E3_CODCLI + E3_LOJA + E3_VEND = " 
cQuery	+= "    E1_FILIAL + E1_NUM + E1_PREFIXO + E1_PARCELA + E1_TIPO + E1_CLIENTE + E1_LOJA + E1_VEND1 " 
cQuery	+= " WHERE E3.D_E_L_E_T_ <> '*' AND E1.D_E_L_E_T_ <> '*' " 
cQuery	+= " AND E3_EMISSAO BETWEEN '" + DtoS(d1) + "' AND '" + DtoS(d2) + "'"
cQuery	+= " AND E3_TIPO = 'NF' AND E3_SEQ NOT IN ('BV','BN') " 
cQuery	+= " AND E3_COMIS <> 0 " 
cQuery	+= " AND E1_XCDOBRO = '1' "
cQuery	+= " ORDER BY E3_FILIAL, E3_VEND, E3_NUM, E3_PREFIXO, E3_PARCELA "

If Select("XMP") > 1
	XMP->(dbCloseArea())
EndIf
	
TCQUERY cQuery NEW ALIAS "XMP"
TCSetField( 'XMP', "E3_EMISSAO", "D" )
TCSetField( 'XMP', "E3_VENCTO", "D" )

dbSelectArea("XMP")

count to nREGTOT
XMP->( DbGoTop() )
ProcRegua( nREGTOT )

While XMP->(!Eof())
	
	//cNum1NF	:= f1Venda(XMP->E3_FILIAL, SubStr(XMP->E3_VEND,1,4), XMP->E3_CODCLI)
	
	//If cNum1NF == XMP->E3_NUM
	
		// verifica se os produtos da nota estao bonificados e faz o calculo para a proporcionalidade da bonifica็ใo
		nPerc	:= XMP->E3_PORC
		
		dbselectArea("SE3")
		dbSetOrder(1)
		
		If nPerc > 0
		
			If SE3->(dbSeek(XMP->E3_FILIAL + XMP->E3_PREFIXO + XMP->E3_NUM + XMP->E3_PARCELA + "BD" + XMP->E3_VEND ))
				
				_cFilial	:= XMP->E3_FILIAL
				_cVend		:= XMP->E3_VEND
				_cNum		:= XMP->E3_NUM
				_cPref		:= XMP->E3_PREFIXO
				_cParc		:= XMP->E3_PARCELA
				_nBase		:= XMP->E3_BASE
				
				RecLock("SE3", .F.)
				
				SE3->E3_BASE		:= _nBase //XMP->E3_BASE
				SE3->E3_PORC		:= nPerc
				SE3->E3_COMIS		:= _nBase * (nPerc/100)
				SE3->E3_SEQ			:= "BD"
				SE3->E3_BONUS		:= "S"
				
				MsUnLock()
				
				_nBase := 0
				
			Else
			
				_cFilial	:= XMP->E3_FILIAL
				_cVend		:= XMP->E3_VEND
				_cNum		:= XMP->E3_NUM
				_cPref		:= XMP->E3_PREFIXO
				_cParc		:= XMP->E3_PARCELA
                _nBase		:= XMP->E3_BASE
                					
				RecLock("SE3", .T.)
				
				SE3->E3_FILIAL		:= XMP->E3_FILIAL
				SE3->E3_VEND		:= XMP->E3_VEND
				SE3->E3_NUM			:= XMP->E3_NUM
				SE3->E3_EMISSAO		:= CtoD("01/06/2019")//XMP->E3_EMISSAO
				SE3->E3_SERIE		:= XMP->E3_SERIE
				SE3->E3_CODCLI		:= XMP->E3_CODCLI
				SE3->E3_LOJA		:= XMP->E3_LOJA
				SE3->E3_BASE		:= _nBase //XMP->E3_BASE
				SE3->E3_PORC		:= nPerc
				SE3->E3_COMIS		:= _nBase * (nPerc/100)
				SE3->E3_PREFIXO		:= XMP->E3_PREFIXO
				SE3->E3_PARCELA		:= XMP->E3_PARCELA
				SE3->E3_TIPO		:= XMP->E3_TIPO
				SE3->E3_BAIEMI		:= XMP->E3_BAIEMI
				SE3->E3_PEDIDO		:= XMP->E3_PEDIDO
				SE3->E3_SEQ			:= "BD"
				SE3->E3_ORIGEM		:= XMP->E3_ORIGEM
				SE3->E3_VENCTO		:= XMP->E3_VENCTO
				SE3->E3_MOEDA		:= XMP->E3_MOEDA
				SE3->E3_BONUS		:= "S"
				
				MsUnLock()
				
				_nBase := 0
				
			EndIf
		
		EndIf
	
	//EndIf
	
	IncProc(XMP->E3_VEND + " - " + XMP->E3_NUM)
	
	If lJaPulou
		lJaPulou	:= .F.
	Else
		XMP->(dbSkip())
	EndIf
	
EndDo

XMP->(dbCloseArea())

Return

