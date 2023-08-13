#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"

***********************
User Function FATC0020()
***********************

Private nLin
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
Private cRedesp := ""
Private cTransp := ""
Private cCodTransp := ""
Private cLocal	:= ""
Private cSegmento := ""
cNatureza := ""

	
	cQuery := "select  F2_DOC, F2_SERIE, F2_DTAGCLI , F2_RETENC, SA1.A1_NREDUZ, SA4.A4_NREDUZ, SZZ.ZZ_DESC, F2_DTEXP, F2_PREVCHG, F2_REALCHG,"
	cQuery += " SF2.F2_EMISSAO, F2_REDESP, F2_TRANSP, F2_DATRASO, F2_DTAGCLI, F2_UFCHG, SZZ.ZZ_PRZENT, F2_OBS, F2_LOCALIZ, A1_SATIV1, D2_TES,F4_TEXTO,F4_DUPLIC "
	
	cQuery += " from " + RetSqlName("SF2") + " SF2, " 
	cQuery += "" + RetSqlName("SA4") + " SA4, "
	cQuery += "" + RetSqlName("SZZ") + " SZZ, "
	cQuery += "" + RetSqlName("SA1") + " SA1, "
	cQuery += "" + RetSqlName("SD2") + " SD2, "
	cQuery += "" + RetSqlName("SF4") + " SF4 "
	
	cQuery += " where F2_DTEXP <> '' and F2_REALCHG <> '' "
	
	cQuery += " and (SF2.F2_FILIAL) = (SD2.D2_FILIAL) "
	cQuery += " and (SF2.F2_DOC + SF2.F2_SERIE) = (SD2.D2_DOC + SD2.D2_SERIE) "
	cQuery += " and (SD2.D2_TES) = (SF4.F4_CODIGO) "
	
	cQuery += " and SF2.F2_CLIENTE = SA1.A1_COD "
	cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA "
	cQuery += " and SF2.F2_TRANSP = SA4.A4_COD "
	cQuery += " and SF2.F2_TRANSP = SZZ.ZZ_TRANSP "
	cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ "

	cQuery += "and F2_DTEXP BETWEEN '"+dtos(dDatabase - 30)+"' and '"+dtos(dDatabase)+"' "

	cQuery += " and SF2.F2_FILIAL = '" + xFilial("SF2") + "' and SA4.A4_FILIAL  = '" + xFilial("SA4") + "' "
	cQuery += " and SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	cQuery += " and SF4.F4_FILIAL = '" + xFilial("SF4") + "' "
	cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' and SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
	cQuery += " and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' and SZZ.D_E_L_E_T_ = ' ' and SA1.D_E_L_E_T_ = ' ' "
	cQuery += " and SD2.D_E_L_E_T_ = ' ' "
	cQuery += " and SF4.D_E_L_E_T_ = ' ' "
	
	cQuery += " GROUP BY "
	cQuery += " F2_DOC, F2_SERIE, F2_DTAGCLI , F2_RETENC, SA1.A1_NREDUZ, SA4.A4_NREDUZ, SZZ.ZZ_DESC, F2_DTEXP, F2_PREVCHG, F2_REALCHG,"
	cQuery += " F2_EMISSAO, F2_REDESP, F2_TRANSP, F2_DATRASO, F2_DTAGCLI, F2_UFCHG, SZZ.ZZ_PRZENT, F2_OBS, F2_LOCALIZ, A1_SATIV1, D2_TES,F4_TEXTO,F4_DUPLIC "
	
	cQuery += " order by SF2.F2_TRANSP, SF2.F2_REDESP, SZZ.ZZ_DESC, SF2.F2_DTEXP"
	cQuery := ChangeQuery( cQuery )
	
	TCQUERY cQuery NEW ALIAS "TMP"
	
	TCSetField( 'TMP', "F2_EMISSAO", "D")
	TCSetField( 'TMP', "F2_DTEXP", "D")
	TCSetField( 'TMP', "F2_PREVCHG", "D")
	TCSetField( 'TMP', "F2_DTAGCLI", "D")
	TCSetField( 'TMP', "F2_REALCHG", "D")
	TCSetField( 'TMP', "F2_DATRASO", "D")
	TCSetField( 'TMP', "F2_DTAGCLI", "D")
	TCSetField( 'TMP', "F2_UFCHG", "D")
	
	TMP->( DbGoTop() )
	If TMP->( EoF() )			////SE A QUERY NÃO TEVE RESULTADOS, PODE SER PQ A TRANSP É REDESPACHO, ENTÃO REFAÇO A QUERY CONSIDERANDO REDESPACHO
								////F2_REDESP = A4_COD
	
		cQuery := "select  F2_DOC, F2_SERIE, F2_DTAGCLI , F2_UFCHG, F2_RETENC, SA1.A1_NREDUZ, SA4.A4_NREDUZ, SZZ.ZZ_DESC, F2_DTEXP, F2_PREVCHG, F2_REALCHG,"
		cQuery += " SF2.F2_EMISSAO, F2_REDESP, F2_DATRASO, F2_DTAGCLI, F2_UFCHG, F2_TRANSP, SZZ.ZZ_PRZENT, F2_OBS, F2_LOCALIZ, A1_SATIV1,D2_TES,F4_TEXTO,F4_DUPLIC "
		cQuery += " from " + RetSqlName("SF2") + " SF2, "
		cQuery += "" + RetSqlName("SA4") + " SA4, "
		cQuery += "" + RetSqlName("SZZ") + " SZZ, "
		cQuery += "" + RetSqlName("SA1") + " SA1, "
		cQuery += "" + RetSqlName("SD2") + " SD2, "
		cQuery += "" + RetSqlName("SF4") + " SF4 "
		
		cQuery += " where F2_DTEXP <> '' and F2_REALCHG = '' "
		
		cQuery += " and (SF2.F2_FILIAL) = (SD2.D2_FILIAL) "
		cQuery += " and (SF2.F2_DOC + SF2.F2_SERIE) = (SD2.D2_DOC + SD2.D2_SERIE) "
		cQuery += " and (SD2.D2_TES) = (SF4.F4_CODIGO) "
	
		cQuery += " and SF2.F2_CLIENTE = SA1.A1_COD "
		cQuery += " and SF2.F2_LOJA = SA1.A1_LOJA "
		cQuery += " and SF2.F2_REDESP = SA4.A4_COD "
		cQuery += " and SF2.F2_REDESP = SZZ.ZZ_TRANSP "
		cQuery += " and SZZ.ZZ_LOCAL = SF2.F2_LOCALIZ "

    	cQuery += "and F2_DTEXP BETWEEN '"+dtos(dDatabase - 30)+"' and '"+dtos(dDatabase)+"' "
	
		cQuery += " and SF2.F2_FILIAL = '" + xFilial("SF2") + "' and SA4.A4_FILIAL  = '" + xFilial("SA4") + "' "
		cQuery += " and SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
		cQuery += " and SA4.A4_FILIAL = '" + xFilial("SA4") + "' "
		cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' and SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
		cQuery += " and SF2.D_E_L_E_T_ = ' '  and SA4.D_E_L_E_T_  = ' ' and SZZ.D_E_L_E_T_ = ' ' and SA1.D_E_L_E_T_ = ' ' "
		cQuery += " and SD2.D_E_L_E_T_ = ' ' "
		cQuery += " and SA4.D_E_L_E_T_ = ' ' "
		
		cQuery += " GROUP BY "
		cQuery += " F2_DOC, F2_SERIE, F2_DTAGCLI , F2_RETENC, SA1.A1_NREDUZ, SA4.A4_NREDUZ, SZZ.ZZ_DESC, F2_DTEXP, F2_PREVCHG, F2_REALCHG,"
		cQuery += " F2_EMISSAO, F2_REDESP, F2_TRANSP, F2_DATRASO, F2_DTAGCLI, F2_UFCHG, SZZ.ZZ_PRZENT, F2_OBS, F2_LOCALIZ, A1_SATIV1, D2_TES,F4_TEXTO,F4_DUPLIC "
	
		cQuery += " order by SF2.F2_REDESP, SF2.F2_TRANSP, SZZ.ZZ_DESC, SF2.F2_DTEXP"
		cQuery := ChangeQuery( cQuery )
		If Select("TMP") > 0
			DbSelectArea("TMP")
			DbCloseArea()
		Endif
	
		TCQUERY cQuery NEW ALIAS "TMP"
		
		TCSetField( 'TMP', "F2_EMISSAO", "D")
		TCSetField( 'TMP', "F2_DTEXP", "D")
		TCSetField( 'TMP', "F2_PREVCHG", "D")
		TCSetField( 'TMP', "F2_DTAGCLI", "D")
		TCSetField( 'TMP', "F2_UFCHG", "D")
		TCSetField( 'TMP', "F2_REALCHG", "D")
		TCSetField( 'TMP', "F2_DATRASO", "D")
		TCSetField( 'TMP', "F2_DTAGCLI", "D")
		TCSetField( 'TMP', "F2_UFCHG", "D")
		
	Endif
	
	   //        "|  N. DA NOTA  |      CLIENTE             |       SEGMENTO                      | DATA DE FATR. | DATA DE SAIDA | PRAZO DE ENTREGA | DATA DE CHEGADA (CLIENTE) | QNT. DE DIAS  | DT.CHEGADA NA UF DESTINO"
	aResult  := {}
	aAtrasos := {}
	nAtX  := nAdX  := nTmX  := 0
	nAtMX := nAdMX := nTmMX := 0
	nATUF_X := 0	    //total entregas com atraso no transporte
	nATU1DX	:= 0		//total de entregas com 1 dia de atraso
	nNFNVen  := 0
	nNFNVenX := 0		//total NFs não Vendas (ex: bonificação)
	
	nDiasProrrog 	:= 0
	nTotProrrog 	:= 0
		
	TMP->(Dbgotop())
	while ! TMP->( EoF() )
		aMediana 	:= {}
		aNotas 		:= {}
		nMDEntreg 	:= nMDAtraso := nProm := 0
		cSegmento 	:= ""
		nNFNVen  := 0
	
		If !Empty(TMP->F2_REDESP)
			cCodTransp := alltrim(TMP->F2_REDESP)
			SA4->(Dbsetorder(1))
			SA4->(Dbseek(xFilial("SA4") + cCodTransp) )
			cTransp := Alltrim(SA4->A4_NREDUZ)
		Else
			cCodTransp := alltrim(TMP->F2_TRANSP)
			cTransp := alltrim(TMP->A4_NREDUZ) //nome da transportadora
		Endif	
		
		cMunicp := alltrim(TMP->ZZ_DESC)   //nome do municipio
		x := 0
		nAt := nAd := nTm := 0
		nAtTrans := 0
		nATUMDIA := 0
				
		If Empty(TMP->F2_REDESP)		//SE NÃO É REDESPACHO, FAZ O LOOP COM O F2_TRANSP
			while !TMP->( EoF() ) .AND. (alltrim(TMP->ZZ_DESC) == cMunicp) .AND. (alltrim(TMP->F2_TRANSP) == cCodTransp)
		        if Empty(TMP->F2_DTAGCLI) .AND. TMP->F2_RETENC != "S" //.AND. Empty(TMP->F2_RETENC)		
									
					If (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) > 0
						nMDAtraso := nMDAtraso + (TMP->F2_REALCHG) - (TMP->F2_PREVCHG)
					Endif
					
					nMDEntreg += (TMP->F2_REALCHG) - (TMP->F2_DTEXP)
										
	       			nProm := TMP->ZZ_PRZENT		//prazo da transportadora
	       			
	       			If TMP->F4_DUPLIC = 'N'
	       				nNFNVen++
	       			Endif     		
					
					DO CASE
						CASE (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) == 0
							nTm++
						CASE (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) > 0
							////Verifica se houve prorrogação  / qtos dias			   	    
			   	    		
			   	    		DbselectArea("SE1")
			   	    		SE1->(Dbsetorder(1))
			   	    		If SE1->(DbSeek(xFilial("SE1") + TMP->F2_SERIE + TMP->F2_DOC )) 
				   	    		nDiasProrrog := 0
				   	    		If (SE1->E1_VENCREA - SE1->E1_VENCTO) >= 2
				   	    			nTotProrrog++
				   	    			nDiasProrrog := (SE1->E1_VENCREA - SE1->E1_VENCTO)			   	    	
				   	    		Endif
				   	    	Endif
		   	    
							nAt++
							If (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) = 1
								nATUMDIA++
							Endif
							
							nUF_REAL := 0
							If !Empty(TMP->F2_UFCHG)
								If (TMP->F2_REALCHG - TMP->F2_UFCHG) > 0
									nUF_REAL := (TMP->F2_REALCHG - TMP->F2_UFCHG)
									nAtTrans++
								Endif							
							Endif
						
							aAdd(aAtrasos, {cMunicp,; 											//1 cidade
										 (TMP->F2_REALCHG) - (TMP->F2_PREVCHG),;				//2 dias atraso (dias decorridos entre a previsão e a chegada real)
										 TMP->A1_NREDUZ,;										//3 nome cliente
										 alltrim(substr(cMunicp,at("(",cMunicp)+1,2)),;			//4 localidade
										 TMP->F2_DOC,;											//5 nota
										 alltrim(TMP->F2_OBS) ,;								//6 obs da nf
										 nDiasProrrog,;											//7 dias prorrogados do título
										 TMP->F2_UFCHG,;										//8 data chegada na UF destino
										 nUF_REAL })						 					//9 dias em transporte(dias decorridos entre a chegada na UF e no cliente)
											
						CASE (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) < 0
							nAd++						
						
			   	    ENDCASE			   	    
			   	    
		   		    x++   //datafat
		        endif
		        
		        DbselectArea("SX5")
		        Dbsetorder(1)
		        SX5->(Dbseek(xFilial("SX5") + 'T3' + TMP->A1_SATIV1 ))
		        cSegmento := Alltrim( Substr(SX5->X5_DESCRI,1,35) )
		        
		   		aAdd(aNotas, {TMP->F2_DOC, TMP->A1_NREDUZ, TMP->F2_DTEXP, TMP->F2_PREVCHG, TMP->F2_REALCHG, TMP->F2_EMISSAO, cSegmento, TMP->F2_DATRASO, TMP->F2_DTAGCLI, TMP->F2_UFCHG, TMP->D2_TES, TMP->F4_TEXTO } )
		   		////			1				2				3				4				5					6			7				8				9              10            11             12
				TMP->( DbSkip() )
			EndDo
		Else
			nMDAtraso := 0
			while !TMP->( EoF() ) .AND. (alltrim(TMP->ZZ_DESC) == cMunicp) .AND. (alltrim(TMP->F2_REDESP) == cCodTransp)
		        if Empty(TMP->F2_DTAGCLI) .AND. TMP->F2_RETENC != "S"

					If (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) > 0
						nMDAtraso += (TMP->F2_REALCHG) - (TMP->F2_PREVCHG)
					Endif
					nMDEntreg += (TMP->F2_REALCHG) - (TMP->F2_DTEXP)
									
					///fiz esta query, pq pelo dbseek não está encontrando (tamanhos de campos diferentes)
					cQuery := " Select ZZ_TRANSP, ZZ_LOCAL, ZZ_PRZENT "
					cQuery += " From " + RetSqlname("SZZ") + " SZZ "
					cQuery += " Where RTRIM(ZZ_TRANSP) = '" + cCodTransp + "' "
					cQuery += " and RTRIM(ZZ_LOCAL) = '" + Alltrim(TMP->F2_LOCALIZ) + "' "
					cQuery += " and SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' "
					cQuery += " and SZZ.D_E_L_E_T_ = ' ' "
					cQuery := ChangeQuery( cQuery )
					If Select("SZZ1") > 0
						DbSelectArea("SZZ1")
						DbCloseArea()
					Endif
				
					TCQUERY cQuery NEW ALIAS "SZZ1"
					SZZ1->(DBGOTOP())
					While !SZZ1->( EOF() ) 
						nProm := SZZ1->ZZ_PRZENT	
						SZZ1->(DBSKIP())
					Enddo 
					
					DbSelectArea("TMP")
					If TMP->F4_DUPLIC = 'N'
	       				nNFNVen++
	       			Endif

					DO CASE
						CASE (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) == 0
							nTm++       //no prazo
						CASE (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) > 0
						
							////Verifica se houve prorrogação  / qtos dias
			   	    		DbselectArea("SE1")
			   	    		SE1->(Dbsetorder(1))
			   	    		If SE1->(DbSeek(xFilial("SE1") + TMP->F2_SERIE + TMP->F2_DOC )) 
				   	    		nDiasProrrog := 0 
				   	    		If (SE1->E1_VENCREA - SE1->E1_VENCTO) >= 2
				   	    			nTotProrrog++
				   	    			nDiasProrrog := (SE1->E1_VENCREA - SE1->E1_VENCTO)			   	    			
				   	    		Endif             
				   	    	Endif
			   	    
							nAt++
							
							If (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) = 1
								nATUMDIA++
							Endif
														
							nUF_REAL := 0
							If !Empty(TMP->F2_UFCHG)
								If (TMP->F2_REALCHG - TMP->F2_UFCHG) > 0
									nUF_REAL := (TMP->F2_REALCHG - TMP->F2_UFCHG)
									nAtTrans++
								Endif							
							Endif
						
							aAdd(aAtrasos, {cMunicp,; 											//1 cidade
										 (TMP->F2_REALCHG) - (TMP->F2_PREVCHG),;				//2 dias atraso (dias decorridos entre a previsão e a chegada real)
										 TMP->A1_NREDUZ,;										//3 nome cliente
										 alltrim(substr(cMunicp,at("(",cMunicp)+1,2)),;			//4 localidade
										 TMP->F2_DOC,;											//5 nota
										 alltrim(TMP->F2_OBS) ,;								//6 obs da nf
										 nDiasProrrog,;											//7 dias prorrogados do título
										 TMP->F2_UFCHG,;										//8 data chegada na UF destino
										 nUF_REAL })						 					//9 dias em transporte(dias decorridos entre a chegada na UF e no cliente)
									
						CASE (TMP->F2_REALCHG) - (TMP->F2_PREVCHG) < 0
							nAd++ //adiantado						
						
			   	    ENDCASE
			   	    			   	    			   	    			   	    
		   		    x++ //datafat
		        endif
		        
		        DbselectArea("SX5")
		        Dbsetorder(1)
		        SX5->(Dbseek(xFilial("SX5") + 'T3' + TMP->A1_SATIV1 ))
		        cSegmento := Alltrim(Substr(SX5->X5_DESCRI,1,35) )
//									1			2				3				4				5					6			7	   		8					9	          10            11             12
		   		aAdd(aNotas, {TMP->F2_DOC, TMP->A1_NREDUZ, TMP->F2_DTEXP, TMP->F2_PREVCHG, TMP->F2_REALCHG, TMP->F2_EMISSAO, cSegmento, TMP->F2_DATRASO, TMP->F2_DTAGCLI, TMP->F2_UFCHG, TMP->D2_TES, TMP->F4_TEXTO } )
				TMP->( DbSkip() )
			EndDo
		Endif		////endif do redespacho
		
		nAtX 		+= (nAt - nATUMDIA)   	////Atrasos - atrasos de 1 dia
		nAdX 		+= (nAd - nNFNVen)		////Adiantados - notas que não são faturamento
		nTmX 		+= (nTm - nNFNVen)		////Total entregue no prazo - notas que não são faturamento
		nATUF_X		+= nAtTrans ////Total entregas atrasadas só no transporte
		nATU1DX		+= nATUMDIA ////Total entregas atrasadas apenas um dia
		nNFNVenX	+= nNFNVen  ////Total de entregas em que a NF não é de Vendas
		
//						1			2		3		  4  5	 6    7    8   9    10		11			12			13		
		aAdd(aResult, {cTransp, cMunicp, nMDAtraso/x, 1, 0, nTm, nAt, nAd, x, aNotas, nMDEntreg/x, nProm, nTotProrrog} )
	EndDo
	
	cTrn := ''
	
	// "|  N. DA NOTA  |      CLIENTE             |       SEGMENTO                      | DATA DE FATR. | DATA DE SAIDA | PRAZO DE ENTREGA | DATA DE CHEGADA (CLIENTE) | QNT. DE DIAS  | TES"
    nDiasUteis := 0    
	FOR Y := 1 TO Len(aResult)
		FOR Z := 1 TO Len(aResult[Y][10])
			IF nLin > 55
				Cabec(titulo, "", "", nomeprog, tamanho, 15)
				nLin := 8
				@ nLin,000 PSay cCabec_01
				nLin++
				@ nLin,000 PSay Repl( '-', 201)
				nLin++			
			ENDIF    //somei dezessete aos três últimos
			
/*
			@ nLin,004 PSay alltrim(aResult[Y][10][Z][1])   	//NF
			@ nLin,017 PSay alltrim( Substr(aResult[Y][10][Z][2] , 1, 24 ) )     //CLIENTE
			@ nLin,044 Psay alltrim( Substr(aResult[Y][10][Z][7] , 1, 35 ) )		//SEGMENTO
			@ nLin,084 PSay Dtoc(aResult[Y][10][Z][6])        	//DT. EMISSÃO
			@ nLin,100 PSay Dtoc(aResult[Y][10][Z][3])			//DT. EXPEDIÇÃO
			@ nLin,117 PSay Dtoc( aResult[Y][10][Z][4] )	//DT. PREVISÃO CHEGADA
			@ nLin,136 PSay Dtoc(aResult[Y][10][Z][5])			//DT. REAL CHEGADA
		
			nDiasUteis := DiasUteis( ( aResult[Y][10][Z][3] + 1 ), aResult[Y][10][Z][5] )
			                          //Dt. Expedição + 1        , Dt. Chegada Real 
			@ nLin,164 PSay alltrim(str( nDiasUteis  ) ) + " " + "Dia(s)"
			@ nLin,179 PSay alltrim(aResult[Y][10][Z][11])		//TES
			@ nLin,182 PSay "-" + alltrim(aResult[Y][10][Z][12])		//TEXTO TES
*/			
			nLin++
		NEXT

		
		//					1		2		3		    4  5   6    7    8   9    10		11	    	12		13		
		//aAdd(aResult, {cTransp, cMunicp, nMDAtraso/x, 1, 0, nTm, nAt, nAd, x, aNotas, nMDEntreg/x, nProm, nTotProrrog} )
		@ nLin,004 PSay "TRANSP.:" +" "+ alltrim(aResult[Y][1])
		nLin++
		@ nLin,004 PSay "MUNCIP.:" +" "+ alltrim(aResult[Y][2])
		nLin++
		@ nLin,004 PSay "MEDIA DE ATRASO (Dt. Chegada - Dt.PREVISTA / Qtd.Entregas):"     +" "+ alltrim(transform(aResult[Y][3],  "@E 999,999.99")) // +" | "+;
		nLin++
		@ nLin,004 PSay "MEDIA DE DIAS   (Dt.Chegada - Dt.SAÍDA / Qtd.Entregas)    :"     +" "+ alltrim(transform(aResult[Y][11], "@E 999,999.99"))  //+" | "+;		  //que levou da dt. expedição até dt. chegada cliente
		nLin++
		//@ nLin,004 PSay "DIAS TRANSPORTADORA (Qtd. Dias úteis entre Dt.CHEGADA - Dt.SAÍDA):"    +" "+ alltrim(transform(aResult[Y][12], "@E 999,999.99"))
		//@ nLin,004 PSay "PRAZO DA TRANSPORTADORA (Qtd. Dias úteis entre Dt.CHEGADA - Dt.SAÍDA):"    +" "+ alltrim(transform(nDiasUteis, "@E 999,999.99"))
		@ nLin,004 PSay "PRAZO DA TRANSPORTADORA :"    +" "+ alltrim(transform(aResult[Y][12], "@E 999,999.99"))
		nLin++
		@ nLin,004 PSay "QTD. DE ENTREGAS:" +" "+ alltrim(str(aResult[Y][9]))
		nLin++
		@ nLin,004 PSay "NO VENCIMENTO: "+ alltrim(str(aResult[Y][6])) +"  "+ "ATRASADAS: "+ alltrim(str(aResult[Y][7])) +"  "+;
		"ADIANTADAS: "+ alltrim(str(aResult[Y][8]))+;
		iif( Y != Len(aResult), iif( aResult[Y][1] != aResult[ Y + 1 ][1],;
		" ** "+"FIM DAS INFORMACOES DA TRANSP. " + alltrim(aResult[Y][1])+" ** ","" ),;
		" ** "+"FIM DAS INFORMACOES DA TRANSP. " + alltrim(aResult[Y][1])+" ** " )     
		nLin++
		@ nLin,000 PSay Repl('-', 201)
		nLin++
		
	NEXT
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
	IF !empty(mv_par01)
		cQuery += " and RTRIM(SA4.A4_COD) = '" + alltrim(mv_par01) + "'  "
	ENDIF
	IF !empty(mv_par02)
		cQuery += " and RTRIM(SA1.A1_COD) = '" + alltrim(mv_par02) + "'  "
	ENDIF
	
	IF !empty(mv_par05)
		cQuery += " and RTRIM(SA1.A1_SATIV1) = '" + alltrim(mv_par05) + "' "
	ENDIF
	cQuery += " and F2_REALCHG <> '' and F2_PREVCHG <> '' "
	cQuery += " and SA1.D_E_L_E_T_ <> '*' and SF2.D_E_L_E_T_ <> '*' and SA4.D_E_L_E_T_ <> '*' "
	cQuery += " AND F2_DTAGCLI = '' AND F2_RETENC = '' "
	cQuery += " order by A1_EST "
	//MemoWrite("C:\FATRETb.SQL", cQuery )
	
	TCQUERY cQuery NEW ALIAS 'TMP'
	TMP->( dbGoTop() )
	
	TCSetField('TMP', "F2_EMISSAO", "D")
	TCSetField('TMP', "F2_DTEXP", "D")
	TCSetField('TMP', "F2_DTAGCLI", "D")
	TCSetField('TMP', "F2_REALCHG", "D")
	TCSetField('TMP', "F2_PREVCHG",  "D")
	TCSetField('TMP', "F2_DATRASO",  "D")
	TCSetField('TMP', "F2_DTAGCLI",  "D")
	
	
	If TMP->( EoF() )			////SE A QUERY NÃO TEVE RESULTADOS, PODE SER PQ A TRANSP É REDESPACHO, ENTÃO REFAÇO A QUERY CONSIDERANDO REDESPACHO
								////F2_REDESP = A4_COD
		//Msgbox("Novo(2): A transp é redespacho")
		
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
		IF !empty(mv_par01)
			cQuery += " and RTRIM(SA4.A4_COD) = '" + alltrim(mv_par01) + "'  "
		ENDIF
		IF !empty(mv_par02)
			cQuery += " and RTRIM(SA1.A1_COD) = '" + alltrim(mv_par02) + "'  "
		ENDIF
		
		IF !Empty(mv_par05)
			cQuery += " and RTRIM(SA1.A1_SATIV1) = '" + alltrim(mv_par05) + "' "
		ENDIF
		cQuery += " and F2_REALCHG <> '' and F2_PREVCHG <> '' "
		cQuery += " and SA1.D_E_L_E_T_ <> '*' and SF2.D_E_L_E_T_ <> '*' and SA4.D_E_L_E_T_ <> '*' "
		cQuery += " AND F2_DTAGCLI = '' AND F2_RETENC = '' "
		cQuery += " order by A1_EST "
		//MemoWrite("C:\FATRETbr.SQL", cQuery )
		
		If Select("TMP") > 0
			DbSelectArea("TMP")
			DbCloseArea()
		Endif
		
		TCQUERY cQuery NEW ALIAS 'TMP'
		TMP->( dbGoTop() )
		
		TCSetField('TMP', "F2_EMISSAO", "D")
		TCSetField('TMP', "F2_DTEXP", "D")
		TCSetField('TMP', "F2_DTAGCLI", "D")
		TCSetField('TMP', "F2_REALCHG", "D")
		TCSetField('TMP', "F2_PREVCHG",  "D")
		TCSetField('TMP', "F2_DATRASO",  "D")
		TCSetField('TMP', "F2_DTAGCLI",  "D")
		
	Endif
	
   //contadores de entregas por região
   nCTNO := nCTNE := nCTCE := nCTSD := nCTSL := 0
   //acumuladores de dias de entrega
   nDIANO := nDIANE := nDIACE := nDIASD := nDIASL := 0
   //variável de pico de entrega (entrega mais demorada)
   nTOPNO := nTOPNE := nTOPCE := nTOPSD := nTOPSL := 0

   //msgbox("nDIANE: " + STR(nDIANE))
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


nLin := 90
///////DAQUI CONTINUA NORMAL tanto para antigo como novo pós-vendas
If nLin > 55
	Cabec(titulo, "", "", nomeprog, tamanho, 15)
	nLin := 8                                                           
Endif	
//0123456789012345678901234567890123456789012345678901234567890123456789
//         10        20        30        40        50        60
@nLin, 000 PSAY "Regiao              | Media de entrega no periodo | Pico de atraso no periodo "
nLin++

@nLin, 000 PSAY "Norte"
@nLin    , 032 PSAY transform(nDIANO/nCTNO, "@E 9,999.99" )
@nLin    , 060 PSAY transform(nTOPNO, "@E 99,999")
nLin++

@nLin, 000 PSAY "Nordeste"
@nLin    , 032 PSAY transform(nDIANE/nCTNE, "@E 9,999.99" )
@nLin    , 060 PSAY transform(nTOPNe, "@E 99,999")
nLin++

@nLin, 000 PSAY "Centro-Oeste"
@nLin    , 032 PSAY transform(nDIACE/nCTCE, "@E 9,999.99" )
@nLin    , 060 PSAY transform(nTOPCE, "@E 99,999")
nLin++

@nLin, 000 PSAY "Sudeste"
@nLin    , 032 PSAY transform(nDIASD/nCTSD, "@E 9,999.99" )
@nLin    , 060 PSAY transform(nTOPSD, "@E 99,999")
nLin++

@nLin, 000 PSAY "Sul"
@nLin    , 032 PSAY transform(nDIASL/nCTSL, "@E 9,999.99" )
@nLin    , 060 PSAY transform(nTOPSL, "@E 99,999")
nLin++
nLin++
iif( nAtX < 0, nAtX := 0, nAtX := nAtX)
@nLin, 000 PSAY "Total de entregas atrasadas             : " + alltrim(str(nAtX))       +"          "+alltrim(transform( (nAtX/(nAtX+nAdX+nTmX+nNFNVenX+nATU1DX))*100,  "@E 999.99"))+" %"
nLin++

//nATU1DX		+= nATUMDIA
@nLin, 000 PSAY "Total de entregas atrasadas 1 DIA       : " + alltrim(str(nATU1DX))    +"          "+alltrim(transform( (nATU1DX / (nAtX+nAdX+nTmX+nATU1DX))*100,  "@E 999.99"))+" %"
nLin++

@nLin, 000 PSAY "Total de entregas c/ vencto prorrogados : " + alltrim(str(nTotProrrog))+"          "+alltrim(transform( (nTotProrrog/(nAtX+nAdX+nTmX+nTotProrrog))*100,  "@E 999.99"))+" %"
nLin++

iif( nAdX < 0, nAdX := 0, nAdX := nAdX)
@nLin, 000 PSAY "Total de entregas adiantadas            : " + alltrim(str(nAdX))       +"          "+alltrim(transform( (nAdX/(nAtX+nAdX+nTmX))*100,  "@E 999.99"))+" %"
nLin++

iif( nTmX < 0, nTmX := 0, nTmX := nTmX)
@nLin, 000 PSAY "Total de entregas no vencimento         : " + alltrim(str(nTmX))       +"          "+alltrim(transform( (nTmX/(nAtX+nAdX+nTmX))*100,  "@E 999.99"))+" %"
nLin++

////15/10/2010: solicitado por Alexandre
@nLin, 000 PSAY "Total de atrasos apenas no transporte   : " + alltrim(str(nATUF_X))    +"          "+alltrim(transform( (nATUF_X/(nAtX+nAdX+nTmX+nATUF_X))*100,  "@E 999.99"))+" %"
nLin++

//nNFNVenX	+= nNFNVen  ////Total de entregas em que a NF não é de Vendas
@nLin, 000 PSAY "Total de entregas NF não-Vendas         : " + alltrim(str(nNFNVenX))   +"          "+alltrim(transform( (nNFNVenX/(nAtX+nAdX+nTmX+nATU1DX+nNFNVenX))*100,  "@E 999.99"))+" %"
nLin++


nLin := 90

If nLin > 55                                                                                                            
	Cabec(titulo, padr("Atrasos",140)    , "Localidade                    | Dias de atraso | Cliente                   | Nota     | Observacao                              | QTD. Dias Prorrogados | Dt.Chegada UF Destino | Dias Atraso no Transporte", nomeprog, tamanho, 15)
	nLin := 9
Endif

aSort(aAtrasos,,,{ |x,y| x[4]+x[1]+ strzero(x[2],4) + x[3] < y[4]+y[1]+ strzero(y[2],4) + y[3] } )
for t := 1 to len(aAtrasos)				  //          10        20        30        40        50        60        70        80        90        100       110     120       130       140       150       160       170       180       190       200       210
	if nLin > 54                          //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		Cabec(titulo, padr("Atrasos",140), "Localidade                    | Dias de atraso | Cliente                   | Nota     | Observacao                              | QTD. Dias Prorrogados | Dt.Chegada UF Destino | Dias Atraso no Transporte", nomeprog, tamanho, 15)
////                                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  9999            XXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          9999 dia(s)        99/99/99		         9999 dia(s)
		nLin := 9
	endIf
	//
	if t>1
		if alltrim(aAtrasos[t][1])!=alltrim(aAtrasos[t-1][1])
			@nLin,000 PSAY replicate("-",30)
		endif
		if alltrim(aAtrasos[t][4])!=alltrim(aAtrasos[t-1][4])
			@nLin,000 PSAY replicate("-",176)
		endif
		nLin++
	endif
	//
	@nLin,000 PSAY substr( alltrim(aAtrasos[t][1]), 1, 30 )			Picture "@!"			///LOCALIDADE
	@nLin,032 PSAY alltrim( str( aAtrasos[t][2] ) ) + " dia(s)"		Picture "@E 9999"     ////QT.DIAS ATRASO
	@nLin,048 PSAY substr( alltrim(aAtrasos[t][3]), 1, 26 ) 		Picture "@!"         ////CLIENTE
	@nLin,076 PSAY alltrim(aAtrasos[t][5])                        						////NOTA
    @nLin,088 PSAY alltrim( Substr(aAtrasos[t][6] , 1, 40) )       						////OBSERVAÇÃO
    @nLin,138 PSAY alltrim( str( aAtrasos[t][7] ) ) + " dia(s)" 	Picture "@E 9999"		////QTD.DIAS PRORROGADOS
    @nLin,157 PSAY Dtoc(aAtrasos[t][8])								Picture "@D 99/99/99"	//DT. CHEGADA UF DESTINO
    @nLin,181 PSAY alltrim( str( aAtrasos[t][9] ) ) + " dia(s)"		Picture "@E 9999"     ////QT.DIAS ATRASO NO TRANSPORTE
	nLin++
	
next

TMP->( DbCloseArea() )

Return Nil


**********
Static Function MODA(aArr)
**********

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

////Função para Cálculo de dias úteis dentro de um período
*********************************
Static Function DiasUteis( dDtIni, dDtFim )
*********************************

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