#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#INCLUDE "fivewin.CH"

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function FATPFI2()

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NMIDIA,AMES")
SetPrvt("NI,CANO,NREG,ADIA,NDIA,NDIASSAC,NVALORT,NPRZMDT")
SetPrvt("NPESOT,NDIAST,NDIAXVLT,NNOTAST,DDATA,NTOTZC")
SetPrvt("NVALZIP,NVALCUR,NVALOR,NPESO,NDIAS,NDIAXVL")
SetPrvt("NNOTAS,NQTDKG,NREGTOT,AADEDS,CTAMANHO,CCARACTER")
SetPrvt("M_PAG,NVALACUM,NLIN,NCONTI,NPATING,NTENDEN")
SetPrvt("NVAL,NIDEAL,NFATOR,NMARGEM,NPRZMED,NFATDIA")
SetPrvt("CTEXTO,NDIATOT,nCartKG,nCartRS,nTot,nTotTot,nTotPeso,nTotVal,nAcCar")
SetPrvt("dDatMax,nAcctr,aArct,nPRZMT,nCartPR,nCartIM,nAcePR,nAceIM,nCartPRK,nCartIMK")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Ana B. Alencar/Emmanuel                  ³ Data ³ 15/06/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Posicao Vendas                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Comercial (Gerencia Linha Dom./Inst.)                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

cALIASANT := alias()

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis de parametrizacao da impressao.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

cDESC1   := ""
cDESC2   := ""
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "DECOM", 2, 2, 1, "", 1 }
cARQUIVO := "SF2"
aORD     := { "Por Data" }
cNOMREL  := "FATPFIV3"
cTITULO  := "Posicao Vendas v3.0 - "
nLASTKEY := 0

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Inicio do processamento                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Pergunte('FAPFV3', .T.)

cNOMREL := setprint( cARQUIVO, cNOMREL, "FAPFV3", @cTITULO, cDESC1, cDESC2, cDESC3, .f., aORD )

If nLastKey == 27

	Return

Endif

setdefault( aRETURN, cARQUIVO )

If nLastKey == 27

	Return

Endif

nMIDIA := aRETURN[ 5 ]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio do Processamento do Relatorio                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF WINDOWS

	RptStatus({|| RptDetail()})
	Return
	Static Function RptDetail()

#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  de variaveis                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aMES := { 'Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro',;
'Novembro', 'Dezembro' }

For nI := 1 To 12

	cANO := StrZero( Year( dDATABASE ), 4 )
	aMES[nI] := aMES[nI] + "/" + cANO

Next

dbselectarea( 'SD2' )
SD2->( dbsetorder( 3 ) )

dbselectarea( 'SB1' )
SB1->( dbsetorder( 1 ) )

dbselectarea( 'SE4' )
SE4->( dbsetorder( 1 ) )

dbselectarea( 'SF2' )
SF2->( dbsetorder( 8 ) ) //Alterado de 7 para 8 na migracao AP8

SF2->( DbSeeK( xFILIAL('SF2') + DtoS( CtoD( '01/'+MV_PAR01+'/'+Right(StrZero(Year(dDATABASE),4),2) ) ), .T. ) )
nREG := SF2->( RecNo() )
Count To nREGTOT While StrZero( Month( F2_EMISSAO ), 2 ) == MV_PAR01
SF2->( DbGoTo( nREG ) )
SetRegua( nREGTOT )

aDIA := {}
nDIASSAC := nDIA := 0
nPRZMDT := nVALORT := nPESOT := nDIAST := nDIAXVLT := nNOTAST := 0


Do While ! SF2->( eof() ) .And. StrZero( Month( F2_EMISSAO ), 2 ) == MV_PAR01 .AND. SF2->F2_EMISSAO <= dDataBase

	dDATA  := SF2->F2_EMISSAO
	nPRZMD := nTOTACE := nVALOR := nPESO := nDIAS := nDIAXVL := nNOTAS := 0
	Do While ! SF2->( eof() ) .And. SF2->F2_EMISSAO == dDATA .And. StrZero( Month( F2_EMISSAO ), 2 ) == MV_PAR01

		If ( ! Empty( SF2->F2_DUPL ) )
			nTTSD2 := 0 //incluido em 13/10/06 total por nota pelo SD2
			nQtdKg := 0
			_nTOTA := nVALZIP := nVALCUR := nVALABR1 := nVALABR2 := nVALABRA3 := nVALETQ := nVALFEC := 0

			SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
			If (SD2->D2_CF $ "511  /5101 /5107 /611  /6101 /512 /5102 /612  /6102 /6109 /6107 /5949 /6949 ")

				Do while SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !eof() )

                    //Senao for do Grupo Linha Domestica /Institucional /etc..
   			        if !SD2->D2_GRUPO $ "A/B/D/E/F/G/H/I"
   			           SD2->(DbSkip())
   			           Loop
   			        endif

					If MV_PAR06 == 1 .AND. substr(SD2->D2_COD,1,1) != 'M' //INCLUINDO AS APARAS MV_PAR06
						nVALOR := nVALOR + SD2->D2_TOTAL
						SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
						nQtdKg := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )

						If ((substring(AllTrim( SD2->D2_COD ),1,1) == 'E') .or. (substring(AllTrim( SD2->D2_COD ),1,1) == 'D'))// .and. MV_PAR07 == 1
							nAcess  := limpBras( SD2->D2_COD )
							nTOTACE += nAcess * SD2->D2_QUANT
							nAC     := nAcess * SD2->D2_QUANT
							nTTSD2  += SD2->D2_TOTAL - nAC

						ElseIf substring(AllTrim( SD2->D2_COD ),1,1) == 'C' //acessorios hospitalares
							nAC := calcAcs(SD2->D2_COD) * SD2->D2_QUANT
							nTOTACE += nAC
							nTTSD2 += SD2->D2_TOTAL - nAC

						Else //sem acessorios
							nTTSD2 += SD2->D2_TOTAL

						EndIf

						SD2->( dbSkip() ) //SKIP AQUI!

					ElseIf (MV_PAR06 == 2) .AND. !(alltrim(SD2->D2_COD) $ "187  /188  /189  /190 ") .AND. substr(SD2->D2_COD,1,1) != 'M' //EXCLUINDO AS APARAS MV_PAR06
						nVALOR := nVALOR + SD2->D2_TOTAL
						SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
						nQtdKg := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) ) //retirado para checagem do erro da media de peso dia 28/12/06

						If ((substring(AllTrim( SD2->D2_COD ),1,1) == 'E') .or. (substring(AllTrim( SD2->D2_COD ),1,1) == 'D'))//  .and. MV_PAR07 == 1
                     nAcess  := limpBras( SD2->D2_COD )
							nTOTACE += nAcess * SD2->D2_QUANT
							nAC     := nAcess * SD2->D2_QUANT
							nTTSD2  += SD2->D2_TOTAL - nAC

						ElseIf substring(AllTrim( SD2->D2_COD ),1,1) == 'C' //acessorios hospitalares
							nAC := calcAcs(SD2->D2_COD) * SD2->D2_QUANT
							nTOTACE += nAC
							nTTSD2 += SD2->D2_TOTAL - nAC

						Else //sem acessorios
							nTTSD2 += SD2->D2_TOTAL

						EndIf

						SD2->( dbSkip() ) //SKIP AQUI

					Else//nunca sera executado
						SD2->( dbSkip() )//SKIP AQUI!

					EndIf//fim dos ifs (hospitalar/limpeza ou brasileirinho/sem acessorio, nesta ordem)

				Enddo

			Endif

			nPESO   += nQtdKg
			nDIAS   += SF2->F2_VALMERC //Variavel obsoleta
			//nDIAXVL := nDIAXVL + ( IIf( SE4->( DbSeek( xFILIAL( 'SE4' ) + SF2->F2_COND ) ), SE4->E4_PRZMED, 0 ) * SF2->F2_VALMERC ) //Aqui esta sendo totalizado os valores de todas as notas
			nNOTAS += IIf(SF2->F2_SERIE=="UNI".OR.(Empty(SF2->F2_SERIE).and.'VD' $ SF2->F2_VEND1),1,0)					 //e todos os prazos, segundo a formula. somat(prazo * valor da nota)
			//comentado em 27/02/08 por Eurivan
			//nPRZMD  += nTTSD2//inserido em 09/10/06, modf 13/10/06	
			//nDIAXVL += (IIf( SE4->( DbSeek( xFILIAL( 'SE4' ) + SF2->F2_COND ) ), SE4->E4_PRZMED, 0 ) * nTTSD2) //inserido em 09/10/06, modf 13/10/06
			//formula >> nDIAXVL/nPRZMD
			nPRZMD += IIf(SF2->F2_SERIE=="UNI".OR.(Empty(SF2->F2_SERIE).and.'VD' $ SF2->F2_VEND1),U_GetPrzM(),0)
		EndIf

		SF2->( DbSkip() )
		IncRegua()

	EndDo

	If ! Empty( nVALOR )

		nVALOR := nVALOR - nTOTACE //Valor total das notas sem acessorios (cada nota)
		nDIA     := nDIA + 1
		Aadd( aDIA, { StrZero( nDIA, 2 ), dDATA, nVALOR, nPESO, nDIAS, nDIAXVL, nNOTAS, nTOTACE, nPRZMD } )//nPRZMD inserido em 09/10/06
		nVALORT  := nVALORT  + nVALOR  //valor total do dia por item do SD2 sem acessorios, sem uso
		nPESOT   := nPESOT   + nPESO	 //nao influenciado por mudancas
//		nDIAST   := nDIAST   + nDIAS   //variavel sem uso
//		nDIAXVLT := nDIAXVLT + nDIAXVL //variavel sem uso
		nNOTAST  := nNOTAST  + nNOTAS  //nao influenciado por mudancas
//		nPRZMDT  += nPRZMD //total de prazos medios do dia
	EndIf

EndDo

if ! Empty( aDIA )

//	nDIATOT := 0
	nREGTOT := Len( aDIA )
   nPRZMT  := 0
	SetRegua( nREGTOT )

	AADEDS    := Asort( aDIA,,, { | x, y | x[ 1 ] < y[ 1 ] } )
	cTAMANHO  := "M"
	cCARACTER := 15
	m_pag     := 1
	cTITULO   := cTITULO + aMES[Val(MV_PAR01)]
	cTITULO   := cTITULO + IIf( MV_PAR04 == 1, ' - Em R$', ' - Em Kg' )
	nVALACUM  := 0
	nVALAC2   := 0 //07/10/06 inserido

	nLIN := cabec( cTITULO, cDESC1, cDESC2, cNOMREL, cTAMANHO, cCARACTER )
	@ PRow()+1, 00     pSay Repl( "*", 132 )
	@ PRow()+1, 00     pSay "N§   --Data--   Fatur. Dia  Desp.Aces   Fatur.Acum.    %Ating.    Ideal_Acum.    Tenden.    Fator    Margem    Pz.Md.    N.NT."
	//    99   99/99/99   999.999,99  99.999,99   9999.999,99     999,99    9999.999,99     999.99   99,999    999,99      99      9.999
	//    0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
	//    0         1         2         3         4         5         6         7         8         9         1         2
	@ PRow()+1, 00     pSay Repl( "*", 132 )

   nTotMG	:= 0
	For nCONTI := 1 To Len( aADEDS )
		nPESO   := aADEDS[nCONTI,4]
		nVALOR  := aADEDS[nCONTI,3]

		If MV_PAR04 == 1

			nVALACUM := nVALACUM + aADEDS[nCONTI,3] //totaliza valacum com todos os nDias
			nPATING  := Round( (nVALACUM/MV_PAR02)*100, 2 )
			nTENDEN  := Round( (((nVALACUM/Val(aADEDS[nCONTI,1]))*MV_PAR03)/MV_PAR02)*100, 2 )
			nVAL     := nVALOR

		Else

			nVALACUM := nVALACUM + aADEDS[nCONTI,4]
			nVALAC2  += aADEDS[nCONTI,3]
			//nPATING  := Round( (nVALACUM/nPESOT)*100, 2 ) //retirado em 16/10/06
			nPATING  := Round( (nVALACUM/MV_PAR02)*100, 2 ) //incluido em 16/10/06
			nTENDEN  := Round( (((nVALACUM/Val(aADEDS[nCONTI,1]))*MV_PAR03)/MV_PAR02)*100, 2 )
			nVAL     := nPESO

		EndIf

		nIDEAL  := Round( (MV_PAR02/MV_PAR03)*Val(aADEDS[nCONTI,1]), 2 )
		nFATOR  := Round( nVALOR/nPESO, 3 )
		nMARGEM := Round( (nFATOR*100/MV_PAR05) - 100, 2 )


//		nPRZMED := Round( aADEDS[nCONTI,6]/aADEDS[nCONTI,9], 0)//nDIAXVL/nPRZMD >> somat(SE4->E4_PRZMED * nTTSD2)/somat(SE4->E4_PRZMED)
		//Alterei em 27/02/08 Eurivan
		nPRZMED := Round( aADEDS[nCONTI,9]/aADEDS[nCONTI,7], 0)
		nPRZMT  += nPRZMED
//		nDIATOT := nDIATOT + nPRZMED

		nTotMG  += nVal*nMargem

		@ PRow()+1,00       pSay aADEDS[nCONTI,1]
		@ PRow()  ,PCol()+3 pSay aADEDS[nCONTI,2]
		@ PRow()  ,PCol()+3 pSay nVAL              Picture "@E 999,999.99"
		If mv_par04 == 1
			@ PRow()  ,PCol()+2 pSay aADEDS[nCONTI,8]  Picture "@E 99,999.99" //Incluido por Eurivan
		Else
			@ PRow()  ,PCol()+2 pSay " --- "
		EndIf
		@ PRow()  ,PCol()+3 pSay nVALACUM          Picture "@E 9999,999.99"
		@ PRow()  ,PCol()+5 pSay nPATING           Picture "@E 999.99"
		@ PRow()  ,PCol()+4 pSay nIDEAL            Picture "@E 9999,999.99"
		@ PRow()  ,PCol()+5 pSay nTENDEN           Picture "@E 999.99"
		@ PRow()  ,PCol()+4 pSay nFATOR            Picture "@E 99.999"
		@ PRow()  ,PCol()+4 pSay nMARGEM           Picture "@E 999.99"
		@ PRow()  ,PCol()+6 pSay nPRZMED           Picture "@E 99"
		@ PRow()  ,PCol()+6 pSay aADEDS[nCONTI,7]  Picture "@E 9,999"

		IncRegua()

		// mSGBOX( " nCONTI " + STRZERO( nCONTI, 4 ), "INFO", "STOP" )
	Next

	nCONTI := Len( aADEDS )
	nVAL   := nFATDIA := 0

	If aADEDS[nCONTI,1] == StrZero( MV_PAR03, 2 )

		If nVALACUM < MV_PAR02

			cTEXTO := "A Menor "
			nVAL   := MV_PAR02 - nVALACUM

		ElseIf nVALACUM > MV_PAR02

			cTEXTO := "A Maior "
			nVAL   := nVALACUM - MV_PAR02

		Else

			cTEXTO := "100% Ok "

		EndIf

	ElseIf aADEDS[nCONTI,1] < StrZero( MV_PAR03, 2 )

		cTEXTO := "100%    "
		nVAL   := nIDEAL - nVALACUM
		nFATDIA:= IIf( nVALACUM < MV_PAR02,Round( ( MV_PAR02-nVALACUM )/( MV_PAR03-Val( aADEDS[nCONTI,1] ) ), 2 ), 0 )

	Else

		cTEXTO := "ERROR   "

	EndIf
	nPREV 	:= nVAL
	nTot		:= nVAL
	@ PRow()+2,00       pSay cTEXTO + IIf( ! Empty( nVAL ), TransForm( nVAL, '@E 9,999,999.99' ), Space(10) )
	nVAL := Round( nVALACUM/Val( aADEDS[nCONTI,1]), 2 )
	@ PRow()  ,PCol()+4 pSay "Fat.Med  " + TransForm( nVAL, '@E 9,999,999.99' )
	@ PRow()  ,PCol()+4 pSay StrZero(Val(aADEDS[nCONTI,1])+1, 2 ) + "§ Dia"
	nVAL := Round( ( MV_PAR02 - nVALACUM ) / ( MV_PAR03 - Val(aADEDS[nCONTI,1]) ), 2 )
	@ PRow()  ,PCol()+4 pSay "Fat.Dia  " + TransForm( nVAL, "@E 9,999,999.99" )
	//  @ PRow()  ,PCol()+5 pSay "Fat.Dia  " + TransForm( (MV_PAR02/MV_PAR03) + nPREV, "@E 9,999,999.99" ) //Modificado para linha anterior por orientacao de Sr. Viana
	nVAL := Round( nVALORT/nPESOT, 2 )//fator
	@ PRow()  ,092      pSay TransForm( nVAL, "@E 99.999" )
   /*03/12/07*/
	@ PRow()  ,102      pSay TransForm( ( ( nVAL/mv_par05 ) * 100 ) - 100, "@E 999.99" )
	/**/
	nVal := nTotMG  += nVal*nMargem

	nVAL := Round(nVAL/nVALORT, 2 )//margem
	//@ PRow()  ,102      pSay TransForm( nVAL, "@E 999.99" )
	nPZTot := 0
	
/*
	For X := 1 TO Len(aADEDS)
		nPZTot := nPZTot + aADEDS[X,6]
	NEXT
*/
	//@ PRow()  ,114 pSay TransForm( nDIATOT / Len( aADEDS ), "@E 99" )
	/*@ PRow()  ,113 pSay TransForm( Round( nPZTot / nVALACUM, 0 ), "@E 999" )*/ //retirado em 18/10/06, nao ha erro apenas modificando
	/*18/10/06*/  
   nPRZMT := NoRound((nPRZMT/Len(aADEDS)),0)
   @ PRow()  ,113 pSay TransForm( nPRZMT, "@E 999" )
   
//	if MV_PAR04 == 1
//		@ PRow()  ,113 pSay TransForm( Round( nPZTot / nVALACUM, 0 ), "@E 999" )
//	else
//		@ PRow()  ,113 pSay TransForm( Round( nPZTot / nVALAC2, 0 ), "@E 999" )
//	endif
   
	/*18/10/06*/
	@ PRow()  ,123 pSay TransForm( nNOTAST, "@E 9999" )

EndIf


Carteira(.F.,1)
nCartPRR := nCartRS
nCartPRK := nCartKG

nAcCar := acsCart(.F.,1)
nAcePR := nAcCar
@ PRow() + 3 ,046 pSay "CARTEIRA PROGRAM.  " + IiF( mv_par04 == 1, "RS " + TransForm( nCartPRR - nAcePR, '@E 9,999,999.99' ), TransForm( nCartPRK, '@E 9,999,999.99' ) + " KG" )

nFatCart := (nCartRS - nAcCar)/nCartKG
@ PRow() ,091 pSay  TransForm( nFatCart, '@E 999.999' )
nMarCart := Round( (nFatCart*100/MV_PAR05) - 100, 2 )
@ PRow() ,102 pSay  TransForm( nMarCart, '@E 999.99' )


Carteira(.F.,2)
nCartIMR := nCartRS
nCartIMK := nCartKG

nAcCar := acsCart(.F.,2)
nAceIM := nAcCar
@ PRow() + 2,046 pSay "CARTEIRA IMEDIATA  " + IiF( mv_par04 == 1, "RS " + TransForm( nCartIMR - nAceIM, '@E 9,999,999.99' ), TransForm( nCartIMK, '@E 9,999,999.99' ) + " KG" )

nFatCart := (nCartRS - nAcCar)/nCartKG
@ PRow() ,091 pSay  TransForm( nFatCart, '@E 999.999' )
nMarCart := Round( (nFatCart*100/MV_PAR05) - 100, 2 )
@ PRow() ,102 pSay  TransForm( nMarCart, '@E 999.99' )

//nAcCar := acsCart(.F.)
if mv_par04 == 1
   @ Prow() + 2 ,046 PSay "ACESSOR. CARTEIRA  " +"RS " + transform( nAcePR+nAceIM, '@E 9,999,999.99' )
endIf

/**///INSERIDO EM 14/11/2007
nCart2 := nFatCt2 := nMarCt2 := nAcctr := 0
//aArct   := Carteira( .T. )
aArct := PediDia()
if aArct[1][1] > 0 .and. aArct[1][2] > 0
   //nAcctr  := acsCart(.T.)//acsCt_2()
   nAcctr  := acsPDia()
   nFatCt2 := (aArct[1][2] - nAcctr)/aArct[1][1]
   nMarCt2 := Round( (nFatCt2*100/MV_PAR05) - 100, 2 )
   nCart2  := iif( mv_par04 == 1, aArct[1][2] - nAcctr, aArct[1][1] )
endIf//MV_PAR04
@ PRow() + 2 ,046 pSay "PEDIDOS DE HOJE    " + iif(mv_par04 == 1 , "RS ", "KG ") + TransForm( nCart2, '@E 9,999,999.99' )
@ PRow()     ,091 pSay  TransForm( nFatCt2, '@E 999.999' )
@ PRow()     ,102 pSay  TransForm( nMarCt2, '@E 999.99'  )
if mv_par04 == 1
   @ Prow() + 2 ,046 PSay "ACESSO. PEDI. HOJE RS " + transform( nAcctr, '@E 9,999,999.99' )
endIf
/**///INSERIDO EM 14/11/2007
//IIf( mv_par04 == 1, nTotTot := nVALACUM + ((nCartIMR+nCartPRR) - (nAceIM+nAcePR)), nTotTot := nVALACUM + nCartPRK + nCartIMK ) 08/05/08
IIf( mv_par04 == 1, nTotTot := nVALACUM + ((nCartIMR) - (nAceIM)), nTotTot := nVALACUM + nCartIMK )

nTotPeso := 0
nTotVal  := 0

For X := 1 To Len( aADEDS )
	nTotPeso += aADEDS[X,4]
	nTotVal	 += aADEDS[X,3]
Next

//nFatTot  := ( nTotVal + ((nCartIMR+nCartPRR) - (nAceIM+nAcePR)) ) / ( nTotPeso + nCartIMK+nCartPRK ) 08/05/08
nFatTot  := ( nTotVal + ((nCartIMR) - (nAceIM)) ) / ( nTotPeso + nCartIMK )
@ PRow() + 2 ,046 pSay "TOTAL GERAL        " + IiF( mv_par04 == 1, "RS " + TransForm( nTotTot, '@E 9,999,999.99' ), TransForm( nTotTot, '@E 9,999,999.99' ) + " KG"  )
@ PRow() ,091 pSay  TransForm( nFatTot, '@E 999.999' )
nMarTot := Round( (nFatTot*100/MV_PAR05) - 100, 2 )
@ PRow() ,102 pSay  TransForm( nMarTot, '@E 999.99' )
//@ PRow() + 1 ,043 pSay TransForm( nTotVal, '@E 9,999,999.99' )  + "  " + TransForm( nCartRS, '@E 9,999,999.99' ) + "  " +;
//											 TransForm( nTotPeso, '@E 9,999,999.99' ) + "  " + TransForm( nCartKG, '@E 9,999,999.99' )

@ Prow() + 2,046 PSAY "MEDIA DE DIAS PEDIDOS EM CARTEIRA " + transform( media(), '@E 999.99')

@ Prow() + 2,046 PSAY "N. DIAS DO PEDIDO COM MAIS TEMPO EM CARTEIRA: " + alltrim(str(dDataBase - dDatMax)) + " dias"

SetRegua( nREGTOT )
cTAMANHO  := "M"
cCARACTER := 15
m_pag     := 1
Roda(0,"","M")

If aReturn[5] == 1

	Set Printer To
	Commit
	ourspool(cNomRel) //Chamada do Spool de Impressao

Endif

MS_FLUSH() //Libera fila de relatorios em spool

retindex( "SF2" )
retindex( "SD2" )
retindex( "SB1" )

Return

Carteira( .T.)

***************

Static Function Carteira( lDia, nTipo )

***************

//nTipo = 1 Carteira Programada
//nTipo = 2 Carteira Pronta para Faturar

//Local nCartKG := nCartRS := Nil

Local aArret := {}

Default nTipo := 0

cCart := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS CARTEIRA_KG, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS, min(SC5.C5_ENTREG) AS DAT "
cCart += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9 "
cCart += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cCart += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cCart += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cCart += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
if nTipo = 1
  //cCart += "SC5.C5_ENTREG > '"+dtos(dDataBase)+"' and "  RETIRADO EM 07/05/08
  cCart += "SC5.C5_ENTREG > '"+ dtos( lastday( dDataBase ) + 1 ) + "' and "
elseif nTipo = 2
  //cCart += "SC5.C5_ENTREG <= '"+dtos(dDataBase)+"' and " RETIRADO EM 07/05/08
  cCart += "SC5.C5_ENTREG <= '"+ dtos( lastday( dDataBase ) ) + "' and "
endif

if lDia
  cCart += "SC5.C5_EMISSAO = '"+dtos(dDataBase)+"' and "
endIf
cCart += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cCart += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cCart += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cCart += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "
cCart := ChangeQuery( cCart )
TCQUERY cCart NEW ALIAS "CARX"
TCSetField('CARX',"DAT","D")

/*dDatMax := CARX->DAT
nCartKG := CARX->CARTEIRA_KG
nCartRS := CARX->CARTEIRA_RS*/
if lDia
  aAdd( aArret, { CARX->CARTEIRA_KG, CARX->CARTEIRA_RS } )
else
  //So pego a Data do pedido mais antigo se for para carteira imediata
  if nTipo = 2
     dDatMax := CARX->DAT
  endif   
  nCartKG := CARX->CARTEIRA_KG
  nCartRS := CARX->CARTEIRA_RS
endIf

CARX->( DbCloseArea() )

Return iif(lDia,aArret,)//nCartKG, nCartRS


**********

Static Function calcAcs(cCod)

**********

Local cQuery := ''          //M.O.D.
/*
Local aProd	 := { { 'CTG011', 1.240 },;
				  { 'CTG006', 0.401 },;
				  { 'CTG007', 0.519 },;
				  { 'CTG008', 0.619 },;
				  { 'CTG010', 0.840 },;
				  { 'CTG001', 0.401 },;
				  { 'CTG002', 0.519 },;
				  { 'CTG003', 0.619 },;
				  { 'CTG004', 0.840 } }
*/				  
//Local nExtra := 0
nTotal := 0

If substring(cCod,1,1) == 'C'

	If Len( AllTrim( cCod ) ) >= 8
		cCod := U_transgen(cCod)
	EndIf

	cQuery := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC, "
	cQuery += "(select	top 1 SD1.D1_VUNIT "
	cQuery += " from	" + RetSqlName('SD1') + " SD1 "
	cQuery += " where	SG1.G1_COMP = SD1.D1_COD and SD1.D1_TIPO = 'N' and SD1.D_E_L_E_T_ != '*' "
	cQuery += "	order by SD1.D1_DTDIGIT desc) as D1_VUNIT "
	cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
	cQuery += "where SG1.G1_COD = '" + alltrim(cCod) + "' and "      //fita hamper ME0807,  CAAA003, CAE003,  CAF003,  CAD003
	cQuery += "(substring(SG1.G1_COMP,1,2) in ('AC','MH','ST') or SG1.G1_COMP in ('ME0106','ME0104','ME0212','ME0213','ME0807')) "
	cQuery += "and SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
	cQuery += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
	cQuery += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
	cQuery := ChangeQUery(cQuery)
	TCQUERY cQUery NEW ALIAS "TMP"
	TMP->( DbGoTop() )
	
	/*nIdx := ascan( aProd, { |x| x[1] == alltrim( TMP->G1_COD ) } )
	if nIdx > 0
	  nExtra += aProd[nIdx][2]
	endIf*/
	Do while ! TMP->( EoF() )
  	   if TMP->G1_COD <> 'CTG011' .and. TMP->G1_COMP <> 'AC0003'
	 	      nTotal += TMP->G1_QUANT * TMP->D1_VUNIT //U_CALPREAC(TMP->G1_COMP, 1, dData)//TMP->B1_UPRC
	   endIf
      TMP->( dbSkip() )
	EndDo
    //nTotal += nExtra // Mão de obra
Else

	Alert("Produto nao e hospitalar.")
	return Nil

EndIf

TMP->( DbCloseArea() )

return nTotal


***************

Static Function  media()

***************

local cQuery := ''
Local nDias := nDif := nCount := 0

cQuery := "SELECT distinct SC5.C5_NUM, SC5.C5_ENTREG "
cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' "
cQuery += "order by SC5.C5_NUM "
TCQUERY cQuery NEW ALIAS 'TMP'
TCSetField( 'TMP', 'C5_ENTREG', 'D' )
TMP->( dbGoTop() )

do while  ! TMP->( EoF() )
	nDias := dDataBase - TMP->C5_ENTREG	
	if nDias >= 0
   	nDif += nDias
   	nCount++
	endIf
	TMP->( dbSkip() )
endDo                                                          	

TMP->( dbCloseArea() )

return iif( nCount == 0, 0, nDif/nCount )

***************

Static Function  limpBras( cCod )

***************
// se o produto for dona limpeza ou brasileirinho, incluir sacos-capa como acessorios!
Local cQuery
Local nTotal := 0
Local cAlias
Local aArea := getArea()
cAlias := iif( substr( alias(), 1, 4 ) == 'TMPX', soma1(alias()), 'TMPX1')

If Len( AllTrim( cCod ) ) >= 8
	cCod := U_transgen(cCod)
EndIf
cQuery := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC, "
cQuery += " (select	top 1 SD1.D1_VUNIT "
cQuery += " from	" + RetSqlName('SD1') + " SD1 "
cQuery += " where	SG1.G1_COMP = SD1.D1_COD and SD1.D1_TIPO = 'N' and SD1.D_E_L_E_T_ != '*' "
cQuery += " order by SD1.D1_DTDIGIT desc) as D1_VUNIT "
cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
cQuery += "where 	SG1.G1_COD = '" + alltrim(cCod) + "' "
if substr(cCod,1,1) $ 'E /D'
  cQuery += "and substring(SG1.G1_COMP,1,2) in ('ME') "  //apenas sacos-capa
endIf
cQuery += "and  SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
cQuery += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
cQuery += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
cQuery := ChangeQUery(cQuery)
TCQUERY cQUery NEW ALIAS (cAlias)
(cAlias)->( DbGoTop() )

Do while ! (cAlias)->( EoF() )
  if (cAlias)->G1_COMP >= 'ME0700' .and. (cAlias)->G1_COMP <= 'ME0799' //ME comprado, não é fabricado internamente
    nTotal += (cAlias)->G1_QUANT * (cAlias)->D1_VUNIT
  elseIf substr(alltrim( (cAlias)->G1_COMP ),1,2 ) == 'MP'
    nTotal += (cAlias)->G1_QUANT * (cAlias)->D1_VUNIT
  elseIf substr(alltrim( (cAlias)->G1_COMP ),1,2 ) == 'PI'
  	 nTotal += (cAlias)->G1_QUANT * limpBras( (cAlias)->G1_COMP ) / 100
  elseIf substr(alltrim( (cAlias)->G1_COMP ),1,2 ) == 'ME'
  	 nTotal += (cAlias)->G1_QUANT * limpBras( (cAlias)->G1_COMP )
  endIf
  (cAlias)->( DbSkip() )
EndDo

(cAlias)->( DbCloseArea() )
restArea( aArea )

Return nTotal


***************
Static Function acsCart( lDia, nTipo )
***************

//nTipo = 1 Carteira Programada
//nTipo = 2 Carteira Pronta para Faturar

Local cQuery  := ''
Local nTot := 0

Default nTipo := 0

cQuery += "SELECT C5_NUM, B1_COD, ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) AS QTDVEN "
cQuery += "FROM "+retSqlName('SB1')+" SB1, "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+retSqlName('SC9')+" SC9 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
if lDia
  cQuery += "SC5.C5_EMISSAO = '"+dtos(dDataBase)+"' and "
endIf

if nTipo = 1
  //cQuery += "SC5.C5_ENTREG > '"+dtos(dDataBase)+"' and "  RETIRADO EM 07/05/08
  cQuery += "SC5.C5_ENTREG > '"+ dtos( lastday( dDataBase ) + 1 ) + "' and "
elseif nTipo = 2
  //cQuery += "SC5.C5_ENTREG <= '"+dtos(dDataBase)+"' and " RETIRADO EM 07/05/08
  cQuery += "SC5.C5_ENTREG <= '"+ dtos( lastday( dDataBase ) ) + "' and "
endif

cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND substring(B1_COD, 1, 1) in ('C','D','E') AND "
cQuery += "SB1.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' AND SC9.D_E_L_E_T_ = ' ' "
cQuery += "order by C5_NUM "
cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS 'TMPX'
TMPX->( dbGoTop() )

do while ! TMPX->( EoF() )
	
if substr( TMPX->B1_COD, 1, 1) $ "C"
  nTot += calcAcs( TMPX->B1_COD ) * TMPX->QTDVEN
else
  nTot += limpBras( TMPX->B1_COD )	* TMPX->QTDVEN
endIf
TMPX->( dbSkip() )

endDo

TMPX->( dbCloseArea() )

Return nTot


***************

Static Function PediDia()

***************

local cQuery := ''
local aArret := {}

cQuery += "select sum(C6_QTDVEN * C6_PRUNIT) CARTEIRA_RS, SUM( ( SC6.C6_QTDVEN ) / SB1.B1_CONV ) AS CARTEIRA_KG "
cQuery += "from   "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+retSqlName('SB1')+" SB1 "
cQuery += "where  C5_FILIAL = '"+xFilial('SC5')+"' AND C6_FILIAL = '"+xFilial('SC6')+"' AND B1_FILIAL = '"+xFilial('SB1')+"' AND "
cQuery += "SC5.C5_EMISSAO = '"+dtos(dDataBase)+"' AND SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_PRODUTO = SB1.B1_COD AND "
cQuery += "SB1.B1_TIPO = 'PA' AND "
cQuery += "SC5.D_E_L_E_T_ != '*' and SC6.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS 'TMPP'
TMPP->( dbGoTop() )

if ! TMPP->( EoF() )
	aAdd( aArret, { TMPP->CARTEIRA_KG, TMPP->CARTEIRA_RS } )
endIf
TMPP->( dbCloseArea() )

Return aArret

***************

Static Function acsPDia( )

***************
Local cQuery  := ''
Local nTot := 0

cQuery += "select C6_PRODUTO "
cQuery += "from   "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6 "
cQuery += "where  C5_FILIAL = '"+xFilial('SC5')+"' AND C6_FILIAL = '"+xFilial('SC6')+"' AND "
cQuery += "C5_EMISSAO = '"+dtos(dDataBase)+"' AND SC5.C5_NUM = SC6.C6_NUM AND C5_TIPO = 'N' AND "
cQuery += "substring(C6_PRODUTO, 1, 1) in ('C','D','E') AND "
cQuery += "SC5.D_E_L_E_T_ != '*' and	SC6.D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS 'TMPX'
TMPX->( dbGoTop() )

do while ! TMPX->( EoF() )
	if substr( TMPX->C6_PRODUTO, 1, 1) $ "C"
	  nTot += calcAcs( TMPX->C6_PRODUTO )	
	else
	  nTot += limpBras( TMPX->C6_PRODUTO )	
	endIf
	TMPX->( dbSkip() )
endDo

TMPX->( dbCloseArea() )

Return nTot
