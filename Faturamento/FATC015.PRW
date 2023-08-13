#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"

***********************
user Function FATC015()
***********************

Private cQuery := ''
//variáveis das regiões do brasil com seus respectivos estados
Private cRGNO := "AC AM AP PA RO RR TO"
Private cRGNE := "MA PI CE RN PB PE AL BA SE"
Private cRGCE := "GO MT MS DF"
Private cRGSD := "MG ES RJ SP"
Private cRGSL := "RS PR SC"
//contadores de entregas por região
Private nCTNO := nCTNE := nCTCE := nCTSD := nCTSL := 0
//acumuladores de dias de entrega
Private nDIANO := nDIANE := nDIACE := nDIASD := nDIASL := 0
//variável de pico de entrega (entrega mais demorada)
Private nTOPNO := nTOPNE := nTOPCE := nTOPSD := nTOPSL := 0
Private cTransp := ""
Private cCodTransp := ""
Private cSegmento := ""

cQuery := "select  F2_DOC, F2_SERIE, F2_DTAGCLI , F2_RETENC, SA1.A1_NREDUZ, SA4.A4_NREDUZ, SZZ.ZZ_DESC, F2_DTEXP, F2_PREVCHG, F2_REALCHG,"
cQuery += " SF2.F2_EMISSAO, F2_REDESP, F2_TRANSP, F2_DATRASO, F2_DTAGCLI, F2_UFCHG, SZZ.ZZ_PRZENT, F2_OBS, F2_LOCALIZ, A1_SATIV1 "
cQuery += " from " + RetSqlName("SF2") + " SF2, "
cQuery += "" + RetSqlName("SA4") + " SA4, "
cQuery += "" + RetSqlName("SZZ") + " SZZ, "
cQuery += "" + RetSqlName("SA1") + " SA1 "
cQuery += " where F2_DTEXP <> '' and F2_REALCHG <> '' "
cQuery += " and SF2.F2_CLIENTE = SA1.A1_COD "
cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA "
cQuery += " and SF2.F2_TRANSP = SA4.A4_COD "
cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP "
cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ "
cQuery += " and SF2.F2_FILIAL = '" + xFilial("SF2") + "' and SA4.A4_FILIAL  = '" + xFilial("SA4") + "' "
cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' and SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
cQuery += " and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' and SZZ.D_E_L_E_T_ = ' ' and SA1.D_E_L_E_T_ = ' ' "
cQuery += " order by SF2.F2_TRANSP, SF2.F2_REDESP, SZZ.ZZ_DESC, SF2.F2_DTEXP"

TCQUERY cQuery NEW ALIAS "TMP"

TCSetField( 'TMP',"F2_EMISSAO","D")
TCSetField( 'TMP',"F2_DTEXP"  ,"D")
TCSetField( 'TMP',"F2_PREVCHG","D")
TCSetField( 'TMP',"F2_DTAGCLI","D")
TCSetField( 'TMP',"F2_REALCHG","D")
TCSetField( 'TMP',"F2_DATRASO","D")
TCSetField( 'TMP',"F2_DTAGCLI","D")
TCSetField( 'TMP',"F2_UFCHG"  ,"D")

TMP->( DbGoTop() )
if TMP->( EoF() )			//SE A QUERY NÃO TEVE RESULTADOS, PODE SER PQ A TRANSP É REDESPACHO, ENTÃO REFAÇO A QUERY CONSIDERANDO REDESPACHO
	//F2_REDESP = A4_COD
	cQuery := "select  F2_DOC, F2_SERIE, F2_DTAGCLI , F2_UFCHG, F2_RETENC, SA1.A1_NREDUZ, SA4.A4_NREDUZ, SZZ.ZZ_DESC, F2_DTEXP, F2_PREVCHG, F2_REALCHG,"
	cQuery += " SF2.F2_EMISSAO, F2_REDESP, F2_DATRASO, F2_DTAGCLI, F2_UFCHG, F2_TRANSP, SZZ.ZZ_PRZENT, F2_OBS, F2_LOCALIZ, A1_SATIV1 "
	cQuery += " from " + RetSqlName("SF2") + " SF2, "
	cQuery += "" + RetSqlName("SA4") + " SA4, "
	cQuery += "" + RetSqlName("SZZ") + " SZZ, "
	cQuery += "" + RetSqlName("SA1") + " SA1 "
	cQuery += " where F2_DTEXP <> '' and F2_REALCHG = '' "
	cQuery += " and SF2.F2_CLIENTE = SA1.A1_COD "
	cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA "
	cQuery += " and SF2.F2_REDESP = SA4.A4_COD "
	cQuery += " and SF2.F2_REDESP = SZZ.ZZ_TRANSP "
	cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ "
	cQuery += " and SF2.F2_FILIAL = '" + xFilial("SF2") + "' and SA4.A4_FILIAL  = '" + xFilial("SA4") + "' "
	cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' and SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
	cQuery += " and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' and SZZ.D_E_L_E_T_ = ' ' and SA1.D_E_L_E_T_ = ' ' "
	cQuery += " order by SF2.F2_REDESP, SF2.F2_TRANSP, SZZ.ZZ_DESC, SF2.F2_DTEXP"
	if Select("TMP") > 0
		DbSelectArea("TMP")
		DbCloseArea()
	endif
	
	TCQUERY cQuery NEW ALIAS "TMP"
	
	TCSetField( 'TMP', "F2_EMISSAO", "D")
	TCSetField( 'TMP', "F2_DTEXP"  , "D")
	TCSetField( 'TMP', "F2_PREVCHG", "D")
	TCSetField( 'TMP', "F2_DTAGCLI", "D")
	TCSetField( 'TMP', "F2_UFCHG"  , "D")
	TCSetField( 'TMP', "F2_REALCHG", "D")
	TCSetField( 'TMP', "F2_DATRASO", "D")
	TCSetField( 'TMP', "F2_DTAGCLI", "D")
	TCSetField( 'TMP', "F2_UFCHG"  , "D")
endif

aResult  := {}
aAtrasos := {}
nAtX  := nAdX  := nTmX  := 0
nAtMX := nAdMX := nTmMX := 0
nATUF_X := 0

nDiasProrrog 	:= 0
nTotProrrog 	:= 0

TMP->(Dbgotop())
while ! TMP->( EoF() )
	aMediana 	:= {}
	aNotas 		:= {}
	nMDEntreg 	:= nMDAtraso := nProm := 0
	cSegmento 	:= ""
	
	if !Empty(TMP->F2_REDESP)
		cCodTransp := alltrim(TMP->F2_REDESP)
		SA4->(Dbsetorder(1))
		SA4->(Dbseek(xFilial("SA4") + cCodTransp) )
		cTransp := Alltrim(SA4->A4_NREDUZ)
	else
		cCodTransp := alltrim(TMP->F2_TRANSP)
		cTransp := alltrim(TMP->A4_NREDUZ) //nome da transportadora
	endif
	
	
	cMunicp := alltrim(TMP->ZZ_DESC)   //nome do municipio
	x := 0
	nAt := nAd := nTm := 0
	nAtTrans := 0
	
	if Empty(TMP->F2_REDESP) //SE NÃO É REDESPACHO, FAZ O LOOP COM O F2_TRANSP
		while !TMP->( EoF() ) .AND. (alltrim(TMP->ZZ_DESC) == cMunicp) .AND. (alltrim(TMP->F2_TRANSP) == cCodTransp)
			if Empty(TMP->F2_DTAGCLI) .AND. TMP->F2_RETENC != "S" //.AND. Empty(TMP->F2_RETENC)
				nMDAtraso += (TMP->F2_REALCHG) - (TMP->F2_PREVCHG)
				nMDEntreg += (TMP->F2_REALCHG) - (TMP->F2_DTEXP)
				
				nProm := TMP->ZZ_PRZENT
				
				do case
					case (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) == 0
						nTm++
					case (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) > 0
						//Verifica se houve prorrogação  / qtos dias
						DbselectArea("SE1")
						SE1->(Dbsetorder(1))
						if SE1->(DbSeek(xFilial("SE1") + TMP->F2_SERIE + TMP->F2_DOC ))
							//nDiasProrrog := SE1->E1_VENCREA - SE1->E1_VENCTO
							nDiasProrrog := 0
							if (SE1->E1_VENCREA - SE1->E1_VENCTO) >= 2
								nTotProrrog++
								nDiasProrrog := (SE1->E1_VENCREA - SE1->E1_VENCTO)
							endif
						endif
						
						nAt++
						
						nUF_REAL := 0
						if !Empty(TMP->F2_UFCHG)
							if (TMP->F2_REALCHG - TMP->F2_UFCHG) > 0
								nUF_REAL := (TMP->F2_REALCHG - TMP->F2_UFCHG)
								nAtTrans++
							endif
						endif
						
						aAdd(aAtrasos, {cMunicp,; 							//1 cidade
						(TMP->F2_REALCHG) - (TMP->F2_PREVCHG),;				//2 dias atraso (dias decorridos entre a previsão e a chegada real)
						TMP->A1_NREDUZ,;									//3 nome cliente
						alltrim(substr(cMunicp,at("(",cMunicp)+1,2)),;		//4 localidade
						TMP->F2_DOC,;										//5 nota
						alltrim(TMP->F2_OBS) ,;								//6 obs da nf
						nDiasProrrog,;										//7 dias prorrogados do título
						TMP->F2_UFCHG,;										//8 data chegada na UF destino
						nUF_REAL })						 					//9 dias em transporte(dias decorridos entre a chegada na UF e no cliente)
						
					case (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) < 0
						nAd++
				endcase
				x++  //datafat
			endif
			
			DbselectArea("SX5")
			Dbsetorder(1)
			SX5->(Dbseek(xFilial("SX5") + 'T3' + TMP->A1_SATIV1 ))
			cSegmento := Alltrim( Substr(SX5->X5_DESCRI,1,35) )
			
			aAdd(aNotas, {TMP->F2_DOC, TMP->A1_NREDUZ, TMP->F2_DTEXP, TMP->F2_PREVCHG, TMP->F2_REALCHG, TMP->F2_EMISSAO, cSegmento, TMP->F2_DATRASO, TMP->F2_DTAGCLI, TMP->F2_UFCHG } )
			//			   1				2				3				4				5					6			7				8				9              10
			TMP->( DbSkip() )
		enddo
	else
		while !TMP->( EoF() ) .AND. (alltrim(TMP->ZZ_DESC) == cMunicp) .AND. (alltrim(TMP->F2_REDESP) == cCodTransp)
			if Empty(TMP->F2_DTAGCLI) .AND. TMP->F2_RETENC != "S" //.AND. Empty(TMP->F2_RETENC)
				nMDAtraso += (TMP->F2_REALCHG) - (TMP->F2_PREVCHG)
				nMDEntreg += (TMP->F2_REALCHG) - (TMP->F2_DTEXP)
				
				///fiz esta query, pq pelo dbseek não está encontrando (tamanhos de campos diferentes)
				cQuery := " Select ZZ_TRANSP, ZZ_LOCAL, ZZ_PRZENT "
				cQuery += " From " + RetSqlname("SZZ") + " SZZ "
				cQuery += " Where RTRIM(ZZ_TRANSP) = '" + cCodTransp + "' "
				cQuery += " and RTRIM(ZZ_LOCAL) = '" + Alltrim(TMP->F2_LOCALIZ) + "' "
				cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' "
				cQuery += " and SZZ.D_E_L_E_T_ = ' ' "
				if Select("SZZ1") > 0
					DbSelectArea("SZZ1")
					DbCloseArea()
				endif
				
				TCQUERY cQuery NEW ALIAS "SZZ1"
				SZZ1->(DBGOTOP())
				while !SZZ1->( EOF() )
					nProm := SZZ1->ZZ_PRZENT
					SZZ1->(DBSKIP())
				enddo
				
				do case
					case (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) == 0
						nTm++
					case (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) > 0
						
						//Verifica se houve prorrogação  / qtos dias
						DbselectArea("SE1")
						SE1->(Dbsetorder(1))
						if SE1->(DbSeek(xFilial("SE1") + TMP->F2_SERIE + TMP->F2_DOC ))
							nDiasProrrog := 0
							if (SE1->E1_VENCREA - SE1->E1_VENCTO) >= 2
								nTotProrrog++
								nDiasProrrog := (SE1->E1_VENCREA - SE1->E1_VENCTO)
							endif
						endif
						
						nAt++
						
						nUF_REAL := 0
						if !Empty(TMP->F2_UFCHG)
							if (TMP->F2_REALCHG - TMP->F2_UFCHG) > 0
								nUF_REAL := (TMP->F2_REALCHG - TMP->F2_UFCHG)
								nAtTrans++
							endif
						endif
						
						aAdd(aAtrasos, {cMunicp,; 							//1 cidade
						(TMP->F2_REALCHG) - (TMP->F2_PREVCHG),;				//2 dias atraso (dias decorridos entre a previsão e a chegada real)
						TMP->A1_NREDUZ,;									//3 nome cliente
						alltrim(substr(cMunicp,at("(",cMunicp)+1,2)),;		//4 localidade
						TMP->F2_DOC,;										//5 nota
						alltrim(TMP->F2_OBS) ,;								//6 obs da nf
						nDiasProrrog,;										//7 dias prorrogados do título
						TMP->F2_UFCHG,;										//8 data chegada na UF destino
						nUF_REAL })						 					//9 dias em transporte(dias decorridos entre a chegada na UF e no cliente)
						
						
					case (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) < 0
						nAd++            //adiantado
				endcase
				x++   //datafat
			endif
			
			DbselectArea("SX5")
			Dbsetorder(1)
			SX5->(Dbseek(xFilial("SX5") + 'T3' + TMP->A1_SATIV1 ))
			cSegmento := Alltrim(Substr(SX5->X5_DESCRI,1,35) )
			//					1			2				3				4				5					6			7	   		8					9	          10
			aAdd(aNotas, {TMP->F2_DOC, TMP->A1_NREDUZ, TMP->F2_DTEXP, TMP->F2_PREVCHG, TMP->F2_REALCHG, TMP->F2_EMISSAO, cSegmento, TMP->F2_DATRASO, TMP->F2_DTAGCLI, TMP->F2_UFCHG } )
			TMP->( DbSkip() )
		enddo
	endif		////endif do redespacho
	
	nAtX 		+= nAt   	////Atrasos
	nAdX 		+= nAd 		////Adiantados
	nTmX 		+= nTm 		////Total entregue no prazo
	nATUF_X		+= nAtTrans ////Total entregas atrasadas só no transporte
	
	//				1			2		3		  4  5	 6    7    8   9    10		11			12			13
	aAdd(aResult, {cTransp, cMunicp, nMDAtraso/x, 1, 0, nTm, nAt, nAd, x, aNotas, nMDEntreg/x, nProm, nTotProrrog} )
enddo

cTrn := ''

nDiasUteis := 0
for Y := 1 to Len(aResult)
	for Z := 1 to len(aResult[Y][10])
		
		@ nLin,004 PSay alltrim(aResult[Y][10][Z][1])   					//NF
		@ nLin,017 PSay alltrim( Substr(aResult[Y][10][Z][2] , 1, 24 ) )    //CLIENTE
		@ nLin,044 Psay alltrim( Substr(aResult[Y][10][Z][7] , 1, 35 ) )	//SEGMENTO
		@ nLin,084 PSay Dtoc(aResult[Y][10][Z][6])        					//DT. EMISSÃO
		@ nLin,100 PSay Dtoc(aResult[Y][10][Z][3])							//DT. EXPEDIÇÃO
		@ nLin,117 PSay Dtoc( aResult[Y][10][Z][4] + 1 )					//DT. PREVISÃO CHEGADA
		@ nLin,136 PSay Dtoc(aResult[Y][10][Z][5])							//DT. REAL CHEGADA
		nDiasUteis := DiasUteis( ( aResult[Y][10][Z][3] + 1 ), aResult[Y][10][Z][5] )
		//Dt. Expedição + 1        , Dt. Chegada Real
		@ nLin,164 PSay alltrim(str( nDiasUteis  ) ) + " " + "Dia(s)"
		
	next
next
TMP->( dbCLoseArea() )

cQuery := "select distinct F2_DOC, F2_DTEXP, F2_REALCHG, F2_PREVCHG, F2_DATRASO, F2_DTAGCLI, A1_EST, F2_EST "
cQuery += " from   " + retSqlName('SA1') + " SA1, "
cQuery += "" + retSqlName('SF2') + " SF2, "
cQuery += "" + retSqlName('SA4') + " SA4 "
cQuery += " where  A1_FILIAL = '" +xFilial('SA1') + "' "
cQuery += " and F2_FILIAL = '"+xFilial('SF2') +"' "
cQuery += " and A4_FILIAL = '"+xFilial('SA4')+"' "
cQuery += " and F2_CLIENTE = A1_COD "
cQuery += " and F2_LOJA = A1_LOJA "
cQuery += " and SF2.F2_TRANSP = SA4.A4_COD "
cQuery += " and F2_EMISSAO >= '"+ alltrim(dtos(mv_par03)) +"' and  F2_EMISSAO <= '"+ alltrim(dtos(mv_par04)) +"' "
cQuery += " and F2_REALCHG <> '' and F2_PREVCHG <> '' "
cQuery += " and SA1.D_E_L_E_T_ <> '*' and SF2.D_E_L_E_T_ <> '*' and SA4.D_E_L_E_T_ <> '*' "
cQuery += " AND F2_DTAGCLI = '' AND F2_RETENC = '' "
cQuery += " order by A1_EST "

TCQUERY cQuery NEW ALIAS 'TMP'
TMP->( dbGoTop() )

TCSetField('TMP',"F2_EMISSAO","D")
TCSetField('TMP',"F2_DTEXP"  ,"D")
TCSetField('TMP',"F2_DTAGCLI","D")
TCSetField('TMP',"F2_REALCHG","D")
TCSetField('TMP',"F2_PREVCHG","D")
TCSetField('TMP',"F2_DATRASO","D")
TCSetField('TMP',"F2_DTAGCLI","D")

if TMP->( EoF() )	//SE A QUERY NÃO TEVE RESULTADOS, PODE SER PQ A TRANSP É REDESPACHO, ENTÃO REFAÇO A QUERY CONSIDERANDO REDESPACHO
	//F2_REDESP = A4_COD
	cQuery := "select distinct F2_DOC, F2_DTEXP, F2_REALCHG, F2_PREVCHG, F2_DATRASO, F2_DTAGCLI, A1_EST, F2_EST "
	cQuery += " from   " + retSqlName('SA1') + " SA1, "
	cQuery += "" + retSqlName('SF2') + " SF2, "
	cQuery += "" + retSqlName('SA4') + " SA4 "
	cQuery += " where  A1_FILIAL = '" +xFilial('SA1') + "' "
	cQuery += " and F2_FILIAL = '"+xFilial('SF2') +"' "
	cQuery += " and A4_FILIAL = '"+xFilial('SA4')+"' "
	cQuery += " and F2_CLIENTE = A1_COD "
	cQuery += " and F2_LOJA = A1_LOJA "
	cQuery += " and SF2.F2_REDESP = SA4.A4_COD "
	cQuery += " and F2_EMISSAO >= '"+ alltrim(dtos(mv_par03)) +"' and  F2_EMISSAO <= '"+ alltrim(dtos(mv_par04)) +"' "
	cQuery += " and F2_REALCHG <> '' and F2_PREVCHG <> '' "
	cQuery += " and SA1.D_E_L_E_T_ <> '*' and SF2.D_E_L_E_T_ <> '*' and SA4.D_E_L_E_T_ <> '*' "
	cQuery += " AND F2_DTAGCLI = '' AND F2_RETENC = '' "
	cQuery += " order by A1_EST "
	
	if Select("TMP") > 0
		DbSelectArea("TMP")
		DbCloseArea()
	endif
	
	TCQUERY cQuery NEW ALIAS 'TMP'
	TMP->( dbGoTop() )
	
	TCSetField('TMP',"F2_EMISSAO","D")
	TCSetField('TMP',"F2_DTEXP"  ,"D")
	TCSetField('TMP',"F2_DTAGCLI","D")
	TCSetField('TMP',"F2_REALCHG","D")
	TCSetField('TMP',"F2_PREVCHG","D")
	TCSetField('TMP',"F2_DATRASO","D")
	TCSetField('TMP',"F2_DTAGCLI","D")
endif

//contadores de entregas por região
nCTNO := nCTNE := nCTCE := nCTSD := nCTSL := 0
//acumuladores de dias de entrega
nDIANO := nDIANE := nDIACE := nDIASD := nDIASL := 0
//variável de pico de entrega (entrega mais demorada)
nTOPNO := nTOPNE := nTOPCE := nTOPSD := nTOPSL := 0
TMP->( dbGoTop() )

do While !TMP->( EOF() )
	if TMP->A1_EST $ cRGNO
		nDIANO += ( TMP->F2_REALCHG - (TMP->F2_DTEXP + 1) )
		iif(TMP->F2_REALCHG - TMP->F2_PREVCHG > nTOPNO, nTOPNO := TMP->F2_REALCHG - TMP->F2_PREVCHG, )
		nCTNO++
	elseIf TMP->A1_EST $ cRGNE
		nDIANE += (TMP->F2_REALCHG - (TMP->F2_DTEXP + 1) )
		iif(TMP->F2_REALCHG - TMP->F2_PREVCHG > nTOPNE, nTOPNE := TMP->F2_REALCHG - TMP->F2_PREVCHG, )
		nCTNE++
	elseIf TMP->A1_EST $ cRGCE
		nDIACE += (TMP->F2_REALCHG - (TMP->F2_DTEXP + 1) )
		iif(TMP->F2_REALCHG - TMP->F2_PREVCHG > nTOPCE, nTOPCE := TMP->F2_REALCHG - TMP->F2_PREVCHG, )
		nCTCE++
	elseIf TMP->A1_EST $ cRGSD
		nDIASD += (TMP->F2_REALCHG - (TMP->F2_DTEXP + 1) )
		iif(TMP->F2_REALCHG - TMP->F2_PREVCHG > nTOPSD, nTOPSD := TMP->F2_REALCHG - TMP->F2_PREVCHG, )
		nCTSD++
	elseIf TMP->A1_EST $ cRGSL
		nDIASL += (TMP->F2_REALCHG - (TMP->F2_DTEXP + 1) )
		iif(TMP->F2_REALCHG - TMP->F2_PREVCHG > nTOPSL, nTOPSL := TMP->F2_REALCHG - TMP->F2_PREVCHG, )
		nCTSL++
	else
		msgAlert("O estado " + TMP->A1_EST + "nao esta cadastrado em nenhuma regiao! ")
		return
	endIf
	TMP->( dbSkip() )
endDo


TMP->( DbCloseArea() )

Return Nil


**************************
Static Function MODA(aArr)
**************************

Local x := 1
Local nMaior := 0
Local nMod := aArr[1]
Local nAnterior
Local y
aSort(aArr)
while (x <= len(aArr))
	
	y := 0
	nAnterior := aArr[x]
	
	while (x <= len(aArr)) .AND. (nAnterior == aArr[x])
		nAnterior := aArr[x]
		x++
		y++
	endDo
	
	IF nMaior < y
		nMaior := y
		nMod := nAnterior //Qual o nº modal até o momento;
	ENDIF
	
EndDo

Return nMod

//Função para Cálculo de dias úteis dentro de um período
*******************************************
Static Function DiasUteis( dDtIni, dDtFim )
*******************************************

Local nDUtil := 0
Local dDtMov := dDtIni
Local dValida:= Ctod("  /  /    ")

While dDtMov <= dDtFim
	If DataValida(dDtMov) = dDtMov
		nDUtil := nDUtil + 1
	Endif
	dDtMov := dDtMov + 1
EndDo

Return(nDUtil)