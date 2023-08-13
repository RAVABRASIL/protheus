#Include "RwMake.ch"
#Include "topconn.ch"
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Esmerino Neto                            ³ Data ³ 11/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Posicao diaria do Faturamento x Estoque                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Faturamento  RAVA                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis utilizadas para parametros                              ³
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ mv_par01        	     Previsto KG Grupo A ?                      ³
³ mv_par02               Previsto KG Grupo B ?                      ³
³ mv_par03               Previsto KG Grupo C ?                      ³
³ mv_par04               Previsto KG Grupo D ?                      ³
³ mv_par05               Previsto KG Grupo E ?                      ³
³ mv_par06               Previsto KG Grupo G ?                      ³
³ mv_par07                                                          ³
³ mv_par08                                                          ³
³ mv_par09                                                          ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

************
User Function FATRPOSDIA()
************

	SetPrvt("cQuery, tamanho, titulo, cDesc1, cDesc2, cDesc3, cNatureza, aReturn, nomeprog, cPerg, nLastKey, lContinua, nLin, wnrel, M_PAG,")
	SetPrvt("cTitulo1, cTitulo2, aConsultas, nZero, nCont, nNumReg, nRP, nAcumul, cRodape, nTotalKG, nTotalAC, nTotalES, nTotalMV,")
	SetPrvt("cData, wREGFIN, nREGTOT, nVALTOT, nPESTOT, nQtd_ml, aPRD, aGRP, cTes, _cCodSec, nPRD, nD2Quant, nGRP, nMIDIA, aGRPASC, nContarr,")
	SetPrvt("nNum, nLetra, AGRPS, nGRPAnt, nD2Quant2, nPESTOT2, nVALTOT2, nQtd_ml2,")

	nRP := 0
	nAcumul := 0
	cData := DtoS(Date())

	nD2Quant2:= 0
	nPESTOT2 := 0
	nVALTOT2 := 0
	nQtd_ml2 := 0

	tamanho   := "G"
	titulo    := PADC("Posicao Diaria (Estoque e Faturamento) em " + DTOC(Date()),74)
	cDesc1    := PADC("Relatorio para acompanhamento do Faturamento Diario na RAVA",74)
	cDesc2    := ""
	cDesc3    := ""
	cNatureza := ""
	aReturn   := { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
	nomeprog  := "FATRPOSDIA"
	cPerg     := "FATRPO"
	nLastKey  := 0
	lContinua := .T.
	nLin      := 9
	wnrel     := "FATRPOSDIA"
	M_PAG     := 1

	Pergunte( cPerg, .T. )
	cString := "Z00"
	wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

	If nLastKey == 27
		Return
	Endif

	SetDefault( aReturn, cString )

	If nLastKey == 27
		Return
	Endif

	#IFDEF WINDOWS
	 	RptStatus({|| RptDetail()})
	 	Return

		Static Function RptDetail()
	#ENDIF

	**************************************
	*Inicio da consulta ao Banco de Dados*
	**************************************

	Estoque(cData)

	//Fatura(cData)

	******************************************************************************************************************************
	/*
	dbselectarea( 'SA1' )
	SA1->( dbsetorder( 1 ) )
	dbselectarea( 'SF2' )
	SF2->( dbsetorder( 7 ) )
	dbselectarea( 'SD2' )
	SD2->( dbsetorder( 3 ) )
	SB1->( DbSetOrder( 1 ) )
	SB2->( DbSetOrder( 1 ) )
	//cData := DtoS((Date() - 1))
	cData := DtoS((Date()))
	cDataAnt := Alltrim(Dtos(Date() - 31))
	//cDataIni := Alltrim(Str(Year(Date() - 30))) + Iif(Month(Date()) < 10, "0" + Alltrim(Str(Month(Date()))), Alltrim(Str(Month(Date())))) + "01"
	cDataFim := Alltrim(Str(Year(Date() - 30))) + Iif(Month(Date()) < 10, "0" + Alltrim(Str(Month(Date()))), Alltrim(Str(Month(Date())))) + "31"
	SF2->( dbseek( xFILIAL('SF2') + cData, .T. ) )
	wREGFIN := SF2->( recno() ) + 1
	SF2->( dbseek( xFILIAL('SF2') + cData, .T. ) )
	nREGTOT := wREGFIN - SF2->( RECNO() )
	nVALTOT := nPESTOT := nQtd_ml := 0
	SetRegua( nREGTOT )
	SX6->( dbSeek( xFilial( "SX6" ) + "MV_TESDNA", .T. ) )
	cTes := Alltrim( SX6->X6_CONTEUD )
	While ! SF2->( eof() ) //.and. SF2->F2_EMISSAO <= dtos( Date() )//mv_par02
		SD2->( dbSeek( xFilial( 'SD2' ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
		While SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !eof() )
			SB1->( dbSeek( xFilial( 'SB1' ) + SD2->D2_COD ) )

      If SD2->D2_CF $ "511  /5101 /611  /6101 /512  /5102 /612  /6102 /6107 /6109 /5949 /6949 " .and. SB1->B1_ATIVO == 'S'

				If Len( Alltrim( SD2->D2_COD ) ) <= 7
					_cCodSec := SD2->D2_COD
				Else
					If Subs( SD2->D2_COD, 5, 1 ) == "R"
						_cCodSec := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 4 ) + Subs( SD2->D2_COD, 8, 2 ), 15 )
					Else
	 					_cCodSec := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 3 ) + Subs( SD2->D2_COD, 7, 2 ), 15 )
					EndIf
				EndIf

				If 'PA' $ SB1->B1_TIPO

	 				SB5->( dbSeek( xFilial( 'SD2' ) + SB1->B1_COD, .T. ) ) 	//Esmerino Neto
					nD2Quant := SD2->D2_QUANT / (1000 / SB5->B5_QE2) 			//Esmerino Neto
	 				nPESTOT := nPESTOT + IIf( Empty(SD2->D2_SERIE) .and. !'VD' $ SF2->F2_VEND1, 0, ( nD2Quant * SB1->B1_PESOR ) )
					nVALTOT := nVALTOT + SD2->D2_TOTAL
	 				nQtd_ml := nQtd_ml + nD2Quant
	 				nPRD    := ascan( aPRD, { |X| X[1] == _cCODSEC } )

	 				If Empty( nPRD )

						aadd( aPRD, { _cCODSEC, SD2->D2_TOTAL, IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( nD2Quant * SB1->B1_PESOR ) ), SB1->B1_DESC,;
						IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant ) } )

					Else

						aPRD[nPRD,2] := aPRD[nPRD,2] + SD2->D2_TOTAL
						aPRD[nPRD,3] := aPRD[nPRD,3] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( nD2Quant * SB1->B1_PESOR ) )
						aPRD[nPRD,5] := aPRD[nPRD,5] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant )

					EndIf

					nGRP    := ascan( aGRP, { |X| X[1] == SD2->D2_GRUPO } )

					If Empty( nGRP )

			 			SX5->( DbSeek( xFILIAL('SX5') + '03' + PadR( SD2->D2_GRUPO, 6 ) ) )
			 			aadd( aGRP, { SD2->D2_GRUPO, SD2->D2_TOTAL, IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( nD2Quant * SB1->B1_PESOR ) ), Left( SX5->X5_DESCRI, 20 ),;
			 						IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant ) } )
					Else

			 			aGRP[nGRP,3] := aGRP[nGRP,3] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( nD2Quant * SB1->B1_PESOR ) )
			 			aGRP[nGRP,5] := aGRP[nGRP,5] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant )

					Endif
			 	Endif
		 	Endif
		 	SD2->( dbSkip() )
		End
	SF2->( dbskip() )
	IncRegua()
	End

	******************************************************************************************************************************
	SF2->( dbseek( xFILIAL('SF2') + (Subs(cDataAnt, 1, 6) + "01"), .T. ) )
	While ! SF2->( eof() ) .and. Substr(DtoS(SF2->F2_EMISSAO), 1, 6) == Substr(cDataAnt, 1, 6) //mv_par02
		SD2->( dbSeek( xFilial( 'SD2' ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
		While SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !eof() )
			SB1->( dbSeek( xFilial( 'SB1' ) + SD2->D2_COD ) )

      If SD2->D2_CF $ "511  /5101 /611  /6101 /512  /5102 /612  /6102 /6107 /6109 /5949 /6949 " .and. SB1->B1_ATIVO == 'S'

				If Len( Alltrim( SD2->D2_COD ) ) <= 7
					_cCodSec2 := SD2->D2_COD
				Else
					If Subs( SD2->D2_COD, 5, 1 ) == "R"
						_cCodSec2 := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 4 ) + Subs( SD2->D2_COD, 8, 2 ), 15 )
					Else
	 					_cCodSec2 := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 3 ) + Subs( SD2->D2_COD, 7, 2 ), 15 )
					EndIf
				EndIf

				If 'PA' $ SB1->B1_TIPO

	 				SB5->( dbSeek( xFilial( 'SD2' ) + SB1->B1_COD, .T. ) ) 	//Esmerino Neto
					nD2Quant2 := SD2->D2_QUANT / (1000 / SB5->B5_QE2) 			//Esmerino Neto
	 				nPESTOT2 := nPESTOT2 + IIf( Empty(SD2->D2_SERIE) .and. !'VD' $ SF2->F2_VEND1, 0, ( nD2Quant2 * SB1->B1_PESOR ) )
					nVALTOT2 := nVALTOT2 + SD2->D2_TOTAL
	 				nQtd_ml2 := nQtd_ml2 + nD2Quant2
	 */
	 				//nPRD    := ascan( aPRD, { |X| X[1] == _cCODSEC } )
					/*
	 				If Empty( nPRD )

						aadd( aPRD, { _cCODSEC, SD2->D2_TOTAL, IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( nD2Quant * SB1->B1_PESOR ) ), SB1->B1_DESC,;
						IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant ) } )

					Else

						aPRD[nPRD,2] := aPRD[nPRD,2] + SD2->D2_TOTAL
						aPRD[nPRD,3] := aPRD[nPRD,3] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( nD2Quant * SB1->B1_PESOR ) )
						aPRD[nPRD,5] := aPRD[nPRD,5] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant )

					EndIf
					*/
	/*
					nGRPAnt    := ascan( nGRPAnt, { |X| X[1] == SD2->D2_GRUPO } )

					If Empty( nGRPAnt )

			 			SX5->( DbSeek( xFILIAL('SX5') + '03' + PadR( SD2->D2_GRUPO, 6 ) ) )
			 			aadd( nGRPAnt, { SD2->D2_GRUPO, SD2->D2_TOTAL, IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( nD2Quant2 * SB1->B1_PESOR ) ), Left( SX5->X5_DESCRI, 20 ),;
			 						IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant2 ) } )
					Else

			 			nGRPAnt[nGRPAnt,3] := nGRPAnt[nGRPAnt,3] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( nD2Quant2 * SB1->B1_PESOR ) )
			 			nGRPAnt[nGRPAnt,5] := nGRPAnt[nGRPAnt,5] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant2 )

					Endif
			 	Endif
		 	Endif
		 	SD2->( dbSkip() )
		End
	SF2->( dbskip() )
	IncRegua()
	End

	******************************************************************************************************************************

	nMIDIA := aReturn[5]
	M_PAG     := 1
	aGRPASC := Asort( aGRP,,, { | x, y | x[ 1 ] < y[ 1 ] } )
	nContarr := Len(aGRP)
	nNum := 1
	nLetra := 1
	AGRPS := Array(6,2)
	While nNum <= nContarr
		If Alltrim(aGRPASC[nNum,1]) == aConsultas[nLetra,1]
			AGRPS[nLetra,1] := aGRPASC[nNum,3]
			nNum := nNum + 1
			nLetra := nLetra + 1
		Else
			AGRPS[nNum,1] := 0
			nLetra := nLetra + 1
		EndIf
	EndDo

	aGRPASC2 := Asort( nGRPAnt,,, { | x, y | x[ 1 ] < y[ 1 ] } )
	nContarr2 := Len(nGRPAnt)
	nNum2 := 1
	nLetra2 := 1
	AGRPS2 := Array(6,2)
	While nNum2 <= nContarr2
		If Alltrim(aGRPASC2[nNum2,1]) == aConsultas[nLetra2,1]
			AGRPS2[nLetra2,1] := aGRPASC2[nNum2,3]
			nNum2 := nNum2 + 1
			nLetra2 := nLetra2 + 1
		Else
			AGRPS2[nNum2,1] := 0
			nLetra2 := nLetra2 + 1
		EndIf
	EndDo
*/

	******************************************************************************************************************************
	cTitulo1 := 'Grupo|----Descricao do----||--------------------Producao (Kg)------------------------||--Estoque-||--------------------Faturamento (KG)---------------------||-----------------------Faturamento (R$)---------------------|'
	cTitulo2 := ' Prod|------Segmento------||Mes Anterior||-----------------Dia Atual-----------------||---Atual--||Mes Anterior||------------------Dia Atual----------------||Mes Anterior||--------------------Dia Atual-----------------|'
	cTitulo3 := '                              Acumulado     Qtd Dia    Acum Mes    Previsto     R/P        (Kg)      Acumulado     Qtd Dia    Acum Mes    Previsto     R/P      Acumulado     Qtd Dia    Acum Mes    Previsto   Fator  Med'
	//             A   XXXXXXXXXXXXXXXXXXXX   999.999,99   999.999,99  999.999,99  999.999,99  999,99%  999.999,99   999.999,99   999.999,99  999.999,99  999.999,99  999,99%   999.999,99   999.999,99  999.999,99  999.999,99   999   999
	//           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//           0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
	cRodape := 'TOTAL->'
	//             A     999.999,99  999.999,99  999.999,99  999,99%  999.999,99   999.999,99  999.999,99  999.999,99  999    999.999,99  999.999,99  999.999,99   999    999
	//           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
	//           0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15
	nLin := Cabec( titulo, "", "", nomeprog, tamanho, 15 ) + 1 //Impressao do cabecalho
	@prow()+1,000 pSay cTitulo1
	@prow()+1,000 pSay cTitulo2
	@prow()+1,000 pSay cTitulo3
	@prow()+1,000 pSay repl( '*', 220 )
	For X := 1 To 6
		@prow()+1,002 pSay aConsultas[X,1]
		@prow()  ,042 pSay Transform(aConsultas[X,2], "@E 999,999.99")//aConsultas[X,2]
		@prow()  ,054 pSay Transform(aConsultas[X,3], "@E 999,999.99")//aConsultas[X,3]
		If X == 1
			@prow()  ,066 pSay Transform(mv_par01, "@E 999,999.99")
			nAcumul := aConsultas[X,3]
			nRP := ((nAcumul + (( Iif((nAcumul / nNumReg) > 0, (nAcumul / nNumReg), 0) ) * ABS(nNumReg - 22))) / mv_par01) * 100
		ElseIf X == 2
			@prow()  ,066 pSay Transform(mv_par02, "@E 999,999.99")
			nAcumul := aConsultas[X,3]
			nRP := ((nAcumul + (( Iif((nAcumul / nNumReg) > 0, (nAcumul / nNumReg), 0) ) * ABS(nNumReg - 22))) / mv_par02) * 100
		ElseIF X == 3
			@prow()  ,066 pSay Transform(mv_par03, "@E 999,999.99")
			nAcumul := aConsultas[X,3]
			nRP := ((nAcumul + (( Iif((nAcumul / nNumReg) > 0, (nAcumul / nNumReg), 0) ) * ABS(nNumReg - 22))) / mv_par03) * 100
		ElseIf X == 4
			@prow()  ,066 pSay Transform(mv_par04, "@E 999,999.99")
			nAcumul := aConsultas[X,3]
			nRP := ((nAcumul + (( Iif((nAcumul / nNumReg) > 0, (nAcumul / nNumReg), 0) ) * ABS(nNumReg - 22))) / mv_par04) * 100
		ElseIf X == 5
			@prow()  ,066 pSay Transform(mv_par05, "@E 999,999.99")
			nAcumul := aConsultas[X,3]
			nRP := ((nAcumul + (( Iif((nAcumul / nNumReg) > 0, (nAcumul / nNumReg), 0) ) * ABS(nNumReg - 22))) / mv_par05) * 100
		ElseIf X == 6
			@prow()  ,066 pSay Transform(mv_par06, "@E 999,999.99")
			nAcumul := aConsultas[X,3]
			nRP := ((nAcumul + (( Iif((nAcumul / nNumReg) > 0, (nAcumul / nNumReg), 0) ) * ABS(nNumReg - 22))) / mv_par06) * 100
		EndIf
		//@prow()  ,044 pSay Transform(nRP, "@E 999.99") + "%"
		@prow()  ,087 pSay Transform(aConsultas[X,4], "@E 999,999.99")
		//@prow()  ,066 pSay Transform(AGRPS[X,1], "@E 999,999.99")
	Next
	nTotalMV := mv_par01 + mv_par02 + mv_par03 + mv_par04 + mv_par05 + mv_par06
	@prow()+2,000 pSay cRodape
	//@prow()  ,008 pSay Transform(nTotalKG, "@E 999,999.99")
	//@prow()  ,020 pSay Transform(nTotalAC, "@E 999,999.99")
  //@prow()  ,032 pSay Transform(nTotalMV, "@E 999,999.99")
	//@prow()  ,053 pSay Transform(nTotalES, "@E 999,999.99")

	If aReturn[5] == 1
 		Set Printer To
 		Commit
 		ourspool( wnrel ) //Chamada do Spool de Impressao
	Endif

	SQLA->( DbCloseArea() )
	SQLB->( DbCloseArea() )
	SQLC->( DbCloseArea() )
	SQLD->( DbCloseArea() )
	SQLE->( DbCloseArea() )
	MS_FLUSH()

Return Nil

***************
Static Function Estoque(cDataEst)
***************

	local cData := cDataEst
	local cDia	:= Subs(cData, 7, 2)
	local cMes  := Subs(cData, 5, 2)
	local cAno	:= Subs(cData, 1, 4)
	local nZero := nTotalKG := nTotalAC := nTotalES := nTotalMV := 0
	local nCont := 1

	public nNumReg := 0
	public aConsultas	:= Array(6,4)

	//Produção Prevista do Dia (todos os produtos pesados)
	cQuery := "SELECT	SUBSTRING(SC2.C2_PRODUTO, 1, 1) AS GRUPO, SUM(Z00.Z00_PESO) AS PESO_KG "
	cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00, " + RetSqlName( "SC2" ) + " SC2, " + RetSqlName( "SB1" ) + " SB1 "
	//cQuery += "WHERE 	Z00.Z00_DATA = '" + DtoS(Date()) + "' AND SUBSTRING(Z00.Z00_OP, 1, 6) = SC2.C2_NUM AND SC2.C2_PRODUTO = SB1.B1_COD "
	cQuery += "WHERE 	Z00.Z00_DATA = '" + cData + "' AND SUBSTRING(Z00.Z00_OP, 1, 6) = SC2.C2_NUM AND SC2.C2_PRODUTO = SB1.B1_COD "
	cQuery += "AND SB1.B1_ATIVO = 'S' AND SB1.B1_TIPO = 'PA' "
	cQuery += "AND Z00.Z00_FILIAL = '  ' AND Z00.D_E_L_E_T_ = ' ' "
	cQuery += "AND SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' "
	cQuery += "AND SB1.B1_FILIAL = '01' AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY  SUBSTRING(SC2.C2_PRODUTO, 1, 1) "
	cQuery += "ORDER BY  SUBSTRING(SC2.C2_PRODUTO, 1, 1) ASC"
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SQLA"
	TCSetField( 'SQLA', "PESO_KG", "N" , 10, 2 )

	//Produção acumulada do mês
	cQuery := "SELECT	SUBSTRING(SC2.C2_PRODUTO, 1, 1) AS GRUPO, SUM(Z00.Z00_PESO) AS ACUMUL_KG "
	cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00, " + RetSqlName( "SC2" ) + " SC2, " + RetSqlName( "SB1" ) + " SB1 "
	//cQuery += "WHERE 	MONTH(Z00.Z00_DATA) = '" + Str(Month( Date() )) + "' AND YEAR(Z00.Z00_DATA) = '" + Str(Year( Date() )) + "' "
	cQuery += "WHERE 	MONTH(Z00.Z00_DATA) = '" + cMes + "' AND YEAR(Z00.Z00_DATA) = '" + cAno + "' "
	cQuery += "AND SUBSTRING(Z00.Z00_OP, 1, 6) = SC2.C2_NUM AND SC2.C2_PRODUTO = SB1.B1_COD AND SB1.B1_ATIVO = 'S' AND SB1.B1_TIPO = 'PA' "
	cQuery += "AND Z00.Z00_FILIAL = '  ' AND Z00.D_E_L_E_T_ = ' ' "
	cQuery += "AND SC2.C2_FILIAL = '" + xFilial( "SC2" ) + "' AND SC2.D_E_L_E_T_ = ' ' "
	cQuery += "AND SB1.B1_FILIAL = '01' AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY  SUBSTRING(SC2.C2_PRODUTO, 1, 1) "
	cQuery += "ORDER BY  SUBSTRING(SC2.C2_PRODUTO, 1, 1) ASC"
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SQLB"
	TCSetField( 'SQLB', "ACUMUL_KG", "N" , 10, 2 )

	//Estoque em Kg
	cQuery := "SELECT	SUBSTRING(SB2.B2_COD, 1, 1) AS GRUPO, SUM(SB2.B2_QATU / SB1.B1_CONV) AS ESTOQUE_KG "
	cQuery += "FROM " + RetSqlName( "SB2" ) + " SB2, " + RetSqlName( "SB1" ) + " SB1 "
	cQuery += "WHERE 	SB2.B2_COD = SB1.B1_COD AND SB1.B1_ATIVO = 'S' AND SB1.B1_TIPO = 'PA' "
	cQuery += "AND SB2.B2_FILIAL = '01' AND SB2.D_E_L_E_T_ = ' ' "
	cQuery += "AND SB1.B1_FILIAL = '01' AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY  SUBSTRING(SB2.B2_COD, 1, 1) "
	cQuery += "ORDER BY  SUBSTRING(SB2.B2_COD, 1, 1) ASC"
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SQLC"
	TCSetField( 'SQLC', "ESTOQUE_KG", "N" , 10, 2 )

	//Quantidade de dias trabalhados (pelos pedidos inseridos)
	cQuery := "SELECT COUNT(SC5.C5_EMISSAO) AS NUMERO_DE_DIAS "
	cQuery += "FROM " + RetSqlName( "SC5" ) + " SC5 "
	//cQuery += "WHERE MONTH(SC5.C5_EMISSAO) = '" + Iif(Month( Date() ) < 10, "0" + Alltrim(Str(Month( Date() ))), Alltrim(Str(Month( Date() )))) + "' AND YEAR(SC5.C5_EMISSAO) = '" + Alltrim(Str(Year( Date() ))) + "' "
	cQuery += "WHERE MONTH(SC5.C5_EMISSAO) = '" + cMes + "' AND YEAR(SC5.C5_EMISSAO) = '" + cAno + "' "
	cQuery += "AND SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY SC5.C5_EMISSAO "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SQLD"

	//Testa se existe um pedido no dia
	cQuery := "SELECT SC5.C5_EMISSAO "
	cQuery += "FROM " + RetSqlName( "SC5" ) + " SC5 "
	cQuery += "WHERE DAY(SC5.C5_EMISSAO) = '" + cDia + "' "
	cQuery += "AND MONTH(SC5.C5_EMISSAO) = '" + cMes + "' "
	cQuery += "AND YEAR(SC5.C5_EMISSAO) = '" + cAno + "' "
	cQuery += "AND SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "SQLE"

	aConsultas[1,1] := "A"
	aConsultas[2,1] := "B"
	aConsultas[3,1] := "C"
	aConsultas[4,1] := "D"
	aConsultas[5,1] := "E"
	aConsultas[6,1] := "G"

	SQLA->( DBGoTop() )
	While SQLA->( ! EoF() ) .or. nCont <= 6
		If SQLA->GRUPO == aConsultas[nCont,1]
			aConsultas[nCont,2] := SQLA->PESO_KG//Transform(SQLA->PESO_KG, "@E 999,999.99")
			nTotalKG := nTotalKG + SQLA->PESO_KG
			SQLA->( dbskip() )
		Else
			aConsultas[nCont,2] := nZero//Transform(nZero, "@E 999,999.99")
		EndIf
		nCont := nCont + 1
	EndDo

	SQLB->( DBGoTop() )
	nCont := 1
	While SQLB->( ! EoF() ) .or. nCont <= 6
		If SQLB->GRUPO == aConsultas[nCont,1]
			aConsultas[nCont,3] := SQLB->ACUMUL_KG //Transform(SQLB->ACUMUL_KG, "@E 999,999.99")
			nTotalAC := nTotalAC + SQLB->ACUMUL_KG
			SQLB->( dbskip() )
		Else
			aConsultas[nCont,3] := nZero//Transform(nZero, "@E 999,999.99")
		EndIf
		nCont := nCont + 1
	EndDo

	SQLC->( DBGoTop() )
	nCont := 1
	While SQLC->( ! EoF() ) .or. nCont <= 6
		If SQLC->GRUPO == aConsultas[nCont,1]
			aConsultas[nCont,4] := SQLC->ESTOQUE_KG//Transform(SQLC->ESTOQUE_KG, "@E 999,999.99")
			nTotalES := nTotalES + SQLC->ESTOQUE_KG
			SQLC->( dbskip() )
		Else
			aConsultas[nCont,4] := nZero//Transform(nZero, "@E 999,999.99")
		EndIf
		nCont := nCont + 1
	EndDo

	SQLD->( DBGoTop() )
	While SQLD->( ! EoF() )
		nNumReg := nNumReg + 1
		SQLD->( dbskip() )
	EndDo

	SQLE->( DBGoTop() )
	If Empty(SQLE->C5_EMISSAO)
		nNumReg := nNumReg + 1
	EndIf

Return (nNumReg, aConsultas)

***************
Static Function Fatura(cData )
***************

	aPRD    := {}
	aGRP    := {}
	nGRPAnt := {}

	dbselectarea( 'SA1' )
	SA1->( dbsetorder( 1 ) )
	dbselectarea( 'SF2' )
	SF2->( dbsetorder( 7 ) )
	dbselectarea( 'SD2' )
	SD2->( dbsetorder( 3 ) )
	SB1->( DbSetOrder( 1 ) )
	SB2->( DbSetOrder( 1 ) )
	//cData := DtoS((Date() - 1))
	cData := DtoS((Date()))
	cDataAnt := Alltrim(Dtos(Date() - 31))
	//cDataIni := Alltrim(Str(Year(Date() - 30))) + Iif(Month(Date()) < 10, "0" + Alltrim(Str(Month(Date()))), Alltrim(Str(Month(Date())))) + "01"
	cDataFim := Alltrim(Str(Year(Date() - 30))) + Iif(Month(Date()) < 10, "0" + Alltrim(Str(Month(Date()))), Alltrim(Str(Month(Date())))) + "31"
	SF2->( dbseek( xFILIAL('SF2') + cData, .T. ) )
	wREGFIN := SF2->( recno() ) + 1
	SF2->( dbseek( xFILIAL('SF2') + cData, .T. ) )
	nREGTOT := wREGFIN - SF2->( RECNO() )
	nVALTOT := nPESTOT := nQtd_ml := 0
	SetRegua( nREGTOT )
	SX6->( dbSeek( xFilial( "SX6" ) + "MV_TESDNA", .T. ) )
	cTes := Alltrim( SX6->X6_CONTEUD )
	While ! SF2->( eof() ) //.and. SF2->F2_EMISSAO <= dtos( Date() )//mv_par02
		SD2->( dbSeek( xFilial( 'SD2' ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
		While SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !eof() )
			SB1->( dbSeek( xFilial( 'SB1' ) + SD2->D2_COD ) )

      If SD2->D2_CF $ "511  /5101 /611  /6101 /512  /5102 /612  /6102 /6107 /6109 /5949 /6949 " .and. SB1->B1_ATIVO == 'S'

				If Len( Alltrim( SD2->D2_COD ) ) <= 7
					_cCodSec := SD2->D2_COD
				Else
					If Subs( SD2->D2_COD, 5, 1 ) == "R"
						_cCodSec := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 4 ) + Subs( SD2->D2_COD, 8, 2 ), 15 )
					Else
	 					_cCodSec := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 3 ) + Subs( SD2->D2_COD, 7, 2 ), 15 )
					EndIf
				EndIf

				If 'PA' $ SB1->B1_TIPO

	 				SB5->( dbSeek( xFilial( 'SD2' ) + SB1->B1_COD, .T. ) ) 	//Esmerino Neto
					nD2Quant := SD2->D2_QUANT / (1000 / SB5->B5_QE2) 			//Esmerino Neto
	 				nPESTOT := nPESTOT + IIf( Empty(SD2->D2_SERIE) .and. !'VD' $ SF2->F2_VEND1, 0, ( nD2Quant * SB1->B1_PESOR ) )
					nVALTOT := nVALTOT + SD2->D2_TOTAL
	 				nQtd_ml := nQtd_ml + nD2Quant
	 				nPRD    := ascan( aPRD, { |X| X[1] == _cCODSEC } )

	 				If Empty( nPRD )

						aadd( aPRD, { _cCODSEC, SD2->D2_TOTAL, IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( nD2Quant * SB1->B1_PESOR ) ), SB1->B1_DESC,;
						IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant ) } )

					Else

						aPRD[nPRD,2] := aPRD[nPRD,2] + SD2->D2_TOTAL
						aPRD[nPRD,3] := aPRD[nPRD,3] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( nD2Quant * SB1->B1_PESOR ) )
						aPRD[nPRD,5] := aPRD[nPRD,5] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant )

					EndIf

					nGRP    := ascan( aGRP, { |X| X[1] == SD2->D2_GRUPO } )

					If Empty( nGRP )

			 			SX5->( DbSeek( xFILIAL('SX5') + '03' + PadR( SD2->D2_GRUPO, 6 ) ) )
			 			aadd( aGRP, { SD2->D2_GRUPO, SD2->D2_TOTAL, IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( nD2Quant * SB1->B1_PESOR ) ), Left( SX5->X5_DESCRI, 20 ),;
			 						IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant ) } )
					Else

			 			aGRP[nGRP,3] := aGRP[nGRP,3] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( nD2Quant * SB1->B1_PESOR ) )
			 			aGRP[nGRP,5] := aGRP[nGRP,5] + IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant )

					Endif
			 	Endif
		 	Endif
		 	SD2->( dbSkip() )
		End
	SF2->( dbskip() )
	IncRegua()
	End

	aGRPASC := Asort( aGRP,,, { | x, y | x[ 1 ] < y[ 1 ] } )
	nContarr := Len(aGRP)
	nNum := 1
	nLetra := 1
	AGRPS := Array(6,2)
	While nNum <= nContarr
		If Alltrim(aGRPASC[nNum,1]) == aConsultas[nLetra,1]
			AGRPS[nLetra,1] := aGRPASC[nNum,3]
			nNum := nNum + 1
			nLetra := nLetra + 1
		Else
			AGRPS[nNum,1] := 0
			nLetra := nLetra + 1
		EndIf
	EndDo

Return (AGRPS)
