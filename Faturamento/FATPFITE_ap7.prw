#include "rwmake.ch"
#INCLUDE "Topconn.CH"

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATPFITE()

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NMIDIA,AMES")
SetPrvt("NI,CANO,NREG,ADIA,NDIA,NDIASSAC,NVALORT,NPRZMDT")
SetPrvt("NPESOT,NDIAST,NDIAXVLT,NNOTAST,DDATA,NTOTZC")
SetPrvt("NVALZIP,NVALCUR,NVALOR,NPESO,NDIAS,NDIAXVL")
SetPrvt("NNOTAS,NQTDKG,NREGTOT,AADEDS,CTAMANHO,CCARACTER")
SetPrvt("M_PAG,NVALACUM,NLIN,NCONTI,NPATING,NTENDEN")
SetPrvt("NVAL,NIDEAL,NFATOR,NMARGEM,NPRZMED,NFATDIA")
SetPrvt("CTEXTO,NDIATOT,nCartKG,nCartRS,nTot,nTotTot,nTotPeso,nTotVal")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Esmerino Neto                            ³ Data ³ 14/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Programa de Posicao de vendas para Teste                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Comercial                                                  ³±±
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
cNOMREL  := "FATPFI"
cTITULO  := "Posicao Vendas - "
nLASTKEY := 0

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicio do processamento                                      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Pergunte('FATPFI',.f.)

cNOMREL := setprint( cARQUIVO, cNOMREL, "FATPFI", @cTITULO, cDESC1, cDESC2, cDESC3, .f., aORD )

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
SF2->( dbsetorder( 9 ) ) //Alterado de 7 para 8 na migracao AP8

SF2->( DbSeeK( xFILIAL('SF2') + DtoS( CtoD( '01/'+MV_PAR01+'/'+Right(StrZero(Year(dDATABASE),4),2) ) ), .T. ) )
nREG := SF2->( RecNo() )
Count To nREGTOT While StrZero( Month( F2_EMISSAO ), 2 ) == MV_PAR01
SF2->( DbGoTo( nREG ) )
SetRegua( nREGTOT )

aDIA    := {}
nDIASSAC := nDIA := 0
nPRZMDT := nVALORT := nPESOT := nDIAST := nDIAXVLT := nNOTAST := 0


Do While ! SF2->( eof() ) .And. StrZero( Month( F2_EMISSAO ), 2 ) == MV_PAR01

   dDATA  := SF2->F2_EMISSAO
   nPRZMD := nTOTACE := nTOTACE2 := nVALOR := nPESO := nDIAS := nDIAXVL := nNOTAS := 0
   Do While ! SF2->( eof() ) .And. SF2->F2_EMISSAO == dDATA .And. StrZero( Month( F2_EMISSAO ), 2 ) == MV_PAR01

      If ! Empty( SF2->F2_DUPL )
				 nTTSD2 := nTTSD22 := 0 //incluido em 13/10/06 total por nota pelo SD2
         nQtdKg := 0
         _nTOTA := nVALZIP := nVALCUR := nVALABR1 := nVALABR2 := nVALABRA3 := nVALETQ := nVALFEC := 0

         SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
         If SD2->D2_CF $ "511  /5101 /611  /6101 /512 /5102 /612  /6102 /6109 /6107 /5949 /6949 "

        	Do while SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !eof() )

						If MV_PAR06 == 1
						 	nVALOR := nVALOR + SD2->D2_TOTAL
        		 	SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
        		 	nQtdKg := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )

							If ((substring(AllTrim( SD2->D2_COD ),1,1) == 'E') .or. (substring(AllTrim( SD2->D2_COD ),1,1) == 'D')) .and. MV_PAR07 == 1
								nTOTACE += limpBras(SD2->D2_COD, 2) * SD2->D2_QUANT
								nAC := limpBras(SD2->D2_COD, 2) * SD2->D2_QUANT
								nTTSD2 += SD2->D2_TOTAL - nAC
								/*Pela media abaixo*/
								nTOTACE2 += limpBra2(SD2->D2_COD, 2) * SD2->D2_QUANT
						 		nAC2 := limpBra2(SD2->D2_COD, 2) * SD2->D2_QUANT
								nTTSD22 += SD2->D2_TOTAL - nAC2

							ElseIf substring(AllTrim( SD2->D2_COD ),1,1) == 'C' //acessorios hospitalares
								nTOTACE += calcAcs(SD2->D2_COD) * SD2->D2_QUANT
						 		nAC := calcAcs(SD2->D2_COD) * SD2->D2_QUANT
								nTTSD2 += SD2->D2_TOTAL - nAC

								nTOTACE2 += calcAcs2(SD2->D2_COD) * SD2->D2_QUANT
						 		nAC2 := calcAcs2(SD2->D2_COD) * SD2->D2_QUANT
								nTTSD22 += SD2->D2_TOTAL - nAC2

							Else //sem acessorios
								nTTSD2 += SD2->D2_TOTAL

							EndIf

						 	SD2->( dbSkip() ) //SKIP AQUI!

						ElseIf (MV_PAR06 == 2) .AND. !(alltrim(SD2->D2_COD) $ "187  /188  /189  /190 ") /*sem apara*/  // 16/10/06 incluido
        	 		nVALOR := nVALOR + SD2->D2_TOTAL
        	 		SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
        	 		nQtdKg := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )

							If ((substring(AllTrim( SD2->D2_COD ),1,1) == 'E') .or. (substring(AllTrim( SD2->D2_COD ),1,1) == 'D')) .and. MV_PAR07 == 1
								nTOTACE += limpBras(SD2->D2_COD, 2) * SD2->D2_QUANT
								nAC := limpBras(SD2->D2_COD, 2) * SD2->D2_QUANT
								nTTSD2 += SD2->D2_TOTAL - nAC
								/*Pela media abaixo*/
								nTOTACE2 += limpBra2(SD2->D2_COD, 2) * SD2->D2_QUANT
						 		nAC2 := limpBra2(SD2->D2_COD, 2) * SD2->D2_QUANT
								nTTSD22 += SD2->D2_TOTAL - nAC2

							ElseIf substring(AllTrim( SD2->D2_COD ),1,1) == 'C' //acessorios hospitalares
								nTOTACE += calcAcs(SD2->D2_COD) * SD2->D2_QUANT
						 		nAC := calcAcs(SD2->D2_COD) * SD2->D2_QUANT
								nTTSD2 += SD2->D2_TOTAL - nAC

								nTOTACE2 += calcAcs2(SD2->D2_COD) * SD2->D2_QUANT
						 		nAC2 := calcAcs2(SD2->D2_COD) * SD2->D2_QUANT
								nTTSD22 += SD2->D2_TOTAL - nAC2


							Else //sem acessorios
								nTTSD2 += SD2->D2_TOTAL

							EndIf

						 	SD2->( dbSkip() ) //SKIP AQUI

						Else//nunca sera executado
					 		SD2->( dbSkip() )//SKIP AQUI!

						EndIf//fim dos ifs (hospitalar/limpeza ou brasileirinho/sem acessorio, nesta ordem)

        	Enddo

         Endif

         nPESO   := nPESO   + nQtdKg
       	 nDIAS   := nDIAS   + SF2->F2_VALMERC
         //nDIAXVL := nDIAXVL + ( IIf( SE4->( DbSeek( xFILIAL( 'SE4' ) + SF2->F2_COND ) ), SE4->E4_PRZMED, 0 ) * SF2->F2_VALMERC ) //Aqui esta sendo totalizado os valores de todas as notas
         //nNOTAS  := nNOTAS  + IIf(SF2->F2_SERIE=="UNI".OR.(Empty(SF2->F2_SERIE).and.'VD' $ SF2->F2_VEND1),1,0)					 //e todos os prazos, segundo a formula. somat(prazo * valor da nota)
		 nNOTAS  := nNOTAS  + IIf(SF2->F2_SERIE $ "UNI/0  ".OR.(Empty(SF2->F2_SERIE).and.'VD' $ SF2->F2_VEND1),1,0)					 //e todos os prazos, segundo a formula. somat(prazo * valor da nota)
		     nPRZMD  += nTTSD2//inserido em 09/10/06, modf 13/10/06
		     nDIAXVL += (IIf( SE4->( DbSeek( xFILIAL( 'SE4' ) + SF2->F2_COND ) ), SE4->E4_PRZMED, 0 ) * nTTSD2) //inserido em 09/10/06, modf 13/10/06
				 //formula >> nDIAXVL/nPRZMD
      EndIf

      SF2->( DbSkip() )
      IncRegua()

   EndDo

   If ! Empty( nVALOR )

      nVALOR := nVALOR - nTOTACE //Valor total das notas sem acessorios (cada nota)
      nDIA     := nDIA + 1
      Aadd( aDIA, { StrZero( nDIA, 2 ), dDATA, nVALOR, nPESO, nDIAS, nDIAXVL, nNOTAS, nTOTACE, nPRZMD, nTOTACE2 } )//nPRZMD inserido em 09/10/06
      nVALORT  := nVALORT  + nVALOR  //valor total do dia por item do SD2 sem acessorios, sem uso
      nPESOT   := nPESOT   + nPESO	 //nao influenciado por mudancas
      nDIAST   := nDIAST   + nDIAS   //variavel sem uso
      nDIAXVLT := nDIAXVLT + nDIAXVL //variavel sem uso
      nNOTAST  := nNOTAST  + nNOTAS  //nao influenciado por mudancas
			nPRZMDT  += nPRZMD //total de prazos medios do dia
   EndIf

EndDo

If ! Empty( aDIA )

   nDIATOT := 0
   nREGTOT   := Len( aDIA )

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
   @ PRow()+1, 00     pSay "N§   --Data--   Fatur. Dia  Desp.Aces Desp.Test Fatur.Acum. %Ating. Ideal_Acum. Tenden.  Fator Margem Pz.Md. N.NT."
                      //    99   99/99/99   999.999,99  99.999,99 99.999,99 9999.999,99  999,99 9999.999,99  999.99 99,999 999,99     99 9.999
                      //    0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
                      //    0         1         2         3         4         5         6         7         8         9         1         2         3
   @ PRow()+1, 00     pSay Repl( "*", 132 )

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
  	  nPRZMED := Round( aADEDS[nCONTI,6]/aADEDS[nCONTI,9], 0)//nDIAXVL/nPRZMD >> somat(SE4->E4_PRZMED * nTTSD2)/somat(SE4->E4_PRZMED)
		  nDIATOT := nDIATOT + nPRZMED

// "N§   --Data--   Fatur. Dia  Desp.Aces Desp.Test Fatur.Acum. %Ating. Ideal_Acum. Tenden.  Fator Margem Pz.Md. N.NT."
//  99   99/99/99   999.999,99  99.999,99 99.999,99 9999.999,99  999,99 9999.999,99  999.99 99,999 999,99     99 9.999
//  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//  0         1         2         3         4         5         6         7         8         9         1         2         3


      @ PRow()+1,00       pSay aADEDS[nCONTI,1]
      @ PRow()  ,PCol()+3 pSay aADEDS[nCONTI,2]
      @ PRow()  ,PCol()+3 pSay nVAL              Picture "@E 999,999.99"
      @ PRow()  ,PCol()+2 pSay aADEDS[nCONTI,8]  Picture "@E 99,999.99"//Incluido por Eurivan
			@ PRow()  ,PCol()+1 pSay aADEDS[nCONTI,10]  Picture "@E 99,999.99"
      @ PRow()  ,PCol()+1 pSay nVALACUM          Picture "@E 9999,999.99"
      @ PRow()  ,PCol()+1 pSay nPATING           Picture "@E 999.99"
      @ PRow()  ,PCol()+1 pSay nIDEAL            Picture "@E 9999,999.99"
      @ PRow()  ,PCol()+2 pSay nTENDEN           Picture "@E 999.99"
      @ PRow()  ,PCol()+2 pSay nFATOR            Picture "@E 99.999"
      @ PRow()  ,PCol()+1 pSay nMARGEM           Picture "@E 999.99"
      @ PRow()  ,PCol()+2 pSay nPRZMED           Picture "@E 99"
      @ PRow()  ,PCol()+2 pSay aADEDS[nCONTI,7]  Picture "@E 9,999"


//      @ PRow()+1,00       pSay aADEDS[nCONTI,1]
//      @ PRow()  ,PCol()+3 pSay aADEDS[nCONTI,2]
//      @ PRow()  ,PCol()+3 pSay nVAL              Picture "@E 999,999.99"
//      @ PRow()  ,PCol()+2 pSay aADEDS[nCONTI,8]  Picture "@E 99,999.99"//Incluido por Eurivan
//      @ PRow()  ,PCol()+3 pSay nVALACUM          Picture "@E 9999,999.99"
//      @ PRow()  ,PCol()+5 pSay nPATING           Picture "@E 999.99"
//      @ PRow()  ,PCol()+4 pSay nIDEAL            Picture "@E 9999,999.99"
//      @ PRow()  ,PCol()+5 pSay nTENDEN           Picture "@E 999.99"
//      @ PRow()  ,PCol()+4 pSay nFATOR            Picture "@E 99.999"
//      @ PRow()  ,PCol()+4 pSay nMARGEM           Picture "@E 999.99"
//      @ PRow()  ,PCol()+6 pSay nPRZMED           Picture "@E 99"
//      @ PRow()  ,PCol()+6 pSay aADEDS[nCONTI,7]  Picture "@E 9,999"

      IncRegua()

      * mSGBOX( " nCONTI " + STRZERO( nCONTI, 4 ), "INFO", "STOP" )
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
*  @ PRow()  ,PCol()+5 pSay "Fat.Dia  " + TransForm( (MV_PAR02/MV_PAR03) + nPREV, "@E 9,999,999.99" ) //Modificado para linha anterior por orientacao de Sr. Viana
   nVAL := Round( nVALORT/nPESOT, 2 )
   @ PRow()  ,092      pSay TransForm( nVAL, "@E 99.999" )
   nVAL := Round( (nVAL*100/MV_PAR05 ) - 100, 2 )
   @ PRow()  ,102      pSay TransForm( nVAL, "@E 999.99" )

	nPZTot := 0
	For X := 1 TO Len(aADEDS)
	  nPZTot := nPZTot + aADEDS[X,6]
	NEXT

  //@ PRow()  ,114 pSay TransForm( nDIATOT / Len( aADEDS ), "@E 99" )
	/*@ PRow()  ,113 pSay TransForm( Round( nPZTot / nVALACUM, 0 ), "@E 999" )*/ //retirado em 18/10/06, nao ha erro apenas modificando
	/*18/10/06*/
	if MV_PAR04 == 1
		@ PRow()  ,113 pSay TransForm( Round( nPZTot / nVALACUM, 0 ), "@E 999" )
	else
		@ PRow()  ,113 pSay TransForm( Round( nPZTot / nVALAC2, 0 ), "@E 999" )
	endif
	/*18/10/06*/
  @ PRow()  ,123 pSay TransForm( nNOTAST, "@E 9999" )

EndIf

Carteira()

@ PRow() + 3 ,046 pSay "TOTAL EM CARTEIRA  " + IiF( mv_par04 == 1, "RS " + TransForm( nCartRS, '@E 9,999,999.99' ), TransForm( nCartKG, '@E 9,999,999.99' ) + " KG"  )
nFatCart := nCartRS/nCartKG
@ PRow() ,091 pSay  TransForm( nFatCart, '@E 999.999' )
nMarCart := Round( (nFatCart*100/MV_PAR05) - 100, 2 )
@ PRow() ,102 pSay  TransForm( nMarCart, '@E 999.99' )
IIf( mv_par04 == 1, nTotTot := nVALACUM + nCartRS, nTotTot := nVALACUM + nCartKG )

nTotPeso := 0
nTotVal  := 0

For X := 1 To Len( aADEDS )
	nTotPeso += aADEDS[X,4]
	nTotVal	 += aADEDS[X,3]
Next

nFatTot  := ( nTotVal + nCartRS ) / ( nTotPeso + nCartKG )
@ PRow() + 2 ,046 pSay "TOTAL GERAL        " + IiF( mv_par04 == 1, "RS " + TransForm( nTotTot, '@E 9,999,999.99' ), TransForm( nTotTot, '@E 9,999,999.99' ) + " KG"  )
@ PRow() ,091 pSay  TransForm( nFatTot, '@E 999.999' )
nMarTot := Round( (nFatTot*100/MV_PAR05) - 100, 2 )
@ PRow() ,102 pSay  TransForm( nMarTot, '@E 999.99' )
//@ PRow() + 1 ,043 pSay TransForm( nTotVal, '@E 9,999,999.99' )  + "  " + TransForm( nCartRS, '@E 9,999,999.99' ) + "  " +;
//											 TransForm( nTotPeso, '@E 9,999,999.99' ) + "  " + TransForm( nCartKG, '@E 9,999,999.99' )

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


*********************
Static Function Carteira()
*********************

	//Local nCartKG := nCartRS := Nil

	cCart := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS CARTEIRA_KG, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS "
	cCart += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6 "
	cCart += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
	cCart += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
	*cCart += "SC5.C5_EMISSAO BETWEEN ' ' AND '20100818' AND "
	*cCart += "SC6.C6_PRODUTO BETWEEN ' ' AND 'ZZZZZZZZZ' AND "
	cCart += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
	cCart += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
	cCart += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' "
	cCart := ChangeQuery( cCart )
	TCQUERY cCart NEW ALIAS "CARX"

	nCartKG := CARX->CARTEIRA_KG
	nCartRS := CARX->CARTEIRA_RS

	CARX->( DbCloseArea() )

Return //nCartKG, nCartRS


**********

Static Function calcAcs(cCod)

**********

nTotal := 0

	If substring(cCod,1,1) == 'C'

		If Len( AllTrim( cCod ) ) >= 8
	  	 cCod := U_transgen(cCod)
		EndIf

		cQuery := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC "
    cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
    cQuery += "where 	SG1.G1_COD = '" + alltrim(cCod) + "' and "
    cQuery += "(substring(SG1.G1_COMP,1,2) in ('AC','MH','ST') or SG1.G1_COMP in ('ME0106','ME0104','ME0212','ME0213','ME0807')) "
    cQuery += "and  SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
    cQuery += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
	  cQuery += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
		cQuery := ChangeQUery(cQuery)
		TCQUERY cQUery NEW ALIAS "TMP"
		TMP->( DbGoTop() )

	  Do while ! TMP->( EoF() )

			nTotal += TMP->G1_QUANT * TMP->B1_UPRC
			TMP->( DbSkip() )

		EndDo

	Else

		Alert("Produto nao e hospitalar.")
		return Nil

	EndIf

	TMP->( DbCloseArea() )

return nTotal


**********

Static Function  limpBras(cCod, nOP)

**********
// se o produto for dona limpeza ou brasileirinho, incluir sacos-capa como acessorios!
Local nTotal := 0

If nOP == 1

  If Len( AllTrim( cCod ) ) >= 8
	  cCod := U_transgen(cCod)
	EndIf

  cQuery := "select B1_COD, B1_DESC "
	cQuery += "from   " + RetSqlName("SB1") + " "
	cQuery += "where B1_COD = '" + allTrim(cCod) + "'
	cQuery += "and (B1_DESC like '%LIMPEZA%' or B1_DESC like '%BRASILEIRINHO%') "
	cQuery += "and B1_TIPO = 'PA' and B1_ATIVO = 'S' "
	cQuery += "and D_E_L_E_T_ != '*' and B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuer  :=  ChangeQuery(cQuery)
	TCQUERY cQuery NEW ALIAS "TMP"
	TMP->( DbGoTop() )

	If ! TMP->( EoF() )
		TMP->( DbCloseArea() )
		Return .T.
	Else
		TMP->( DbCloseArea() )
		Return .F.
	Endif

ElseIf nOP == 2

	If Len( AllTrim( cCod ) ) >= 8
	  cCod := U_transgen(cCod)
	EndIf

	cQuery := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC "
  cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
  cQuery += "where 	SG1.G1_COD = '" + alltrim(cCod) + "' and "
  cQuery += "substring(SG1.G1_COMP,1,2) in ('ME') "  //apenas sacos-capa
  cQuery += "and  SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
  cQuery += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
	cQuery += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
	cQuery := ChangeQUery(cQuery)
	TCQUERY cQUery NEW ALIAS "TMP"
	TMP->( DbGoTop() )

	Do while ! TMP->( EoF() )
		nTotal += TMP->G1_QUANT * TMP->B1_UPRC
		TMP->( DbSkip() )
	EndDo

	TMP->( DbCloseArea() )
	Return nTotal

Endif

Return Nil



**********

Static Function calcAcs2(cCod)

**********

nTotal := 0

	If substring(cCod,1,1) == 'C'

		If Len( AllTrim( cCod ) ) >= 8
	  	 cCod := U_transgen(cCod)
		EndIf

		cQuery := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC "
    cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
    cQuery += "where 	SG1.G1_COD = '" + alltrim(cCod) + "' and "                 //fita hamper ME0807/CAAA003,CAE003,CAF003,CAD003
    cQuery += "(substring(SG1.G1_COMP,1,2) in ('AC','MH','ST') or SG1.G1_COMP in ('ME0106','ME0104','ME0212','ME0213','ME0807')) "
    cQuery += "and  SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
    cQuery += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
	  cQuery += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
		cQuery := ChangeQUery(cQuery)
		TCQUERY cQUery NEW ALIAS "TMP"
		TMP->( DbGoTop() )

	  Do while ! TMP->( EoF() )

			nTotal += TMP->G1_QUANT * U_CALPREAC( alltrim(TMP->G1_COMP), 2 )
			TMP->( DbSkip() )

		EndDo

	Else

		Alert("Produto nao e hospitalar.")
		return Nil

	EndIf

	TMP->( DbCloseArea() )

return nTotal



**********

Static Function  limpBra2(cCod, nOP)

**********
// se o produto for dona limpeza ou brasileirinho, incluir sacos-capa como acessorios!
Local nTotal := 0

If nOP == 1

  If Len( AllTrim( cCod ) ) >= 8
	  cCod := U_transgen(cCod)
	EndIf

  cQuery := "select B1_COD, B1_DESC "
	cQuery += "from   " + RetSqlName("SB1") + " "
	cQuery += "where B1_COD = '" + allTrim(cCod) + "'
	cQuery += "and (B1_DESC like '%LIMPEZA%' or B1_DESC like '%BRASILEIRINHO%') "
	cQuery += "and B1_TIPO = 'PA' and B1_ATIVO = 'S' "
	cQuery += "and D_E_L_E_T_ != '*' and B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuer  :=  ChangeQuery(cQuery)
	TCQUERY cQuery NEW ALIAS "TMP"
	TMP->( DbGoTop() )

	If ! TMP->( EoF() )
		TMP->( DbCloseArea() )
		Return .T.
	Else
		TMP->( DbCloseArea() )
		Return .F.
	Endif

ElseIf nOP == 2

	If Len( AllTrim( cCod ) ) >= 8
	  cCod := U_transgen(cCod)
	EndIf

	cQuery := "select	SG1.G1_COD,SG1.G1_COMP,SG1.G1_QUANT, SB1.B1_UPRC "
  cQuery += "from " + RetSqlName("SG1") + " SG1, " + RetSqlName("SB1") + " SB1 "
  cQuery += "where 	SG1.G1_COD = '" + alltrim(cCod) + "' and "
  cQuery += "substring(SG1.G1_COMP,1,2) in ('ME') "  //apenas sacos-capa
  cQuery += "and  SB1.B1_COD = SG1.G1_COMP and SB1.B1_ATIVO = 'S' "
  cQuery += "and SG1.G1_FILIAL = '" + xFilial("SG1") + "' and SG1.D_E_L_E_T_ != '*' "
	cQuery += "and SB1.B1_FILIAL = '" + xFilial("SB1") + "' and SB1.D_E_L_E_T_ != '*' "
	cQuery := ChangeQUery(cQuery)
	TCQUERY cQUery NEW ALIAS "TMP"
	TMP->( DbGoTop() )

	Do while ! TMP->( EoF() )
		nTotal += TMP->G1_QUANT * U_CALPREAC( alltrim(TMP->G1_COMP), 2 )
		TMP->( DbSkip() )
	EndDo

	TMP->( DbCloseArea() )
	Return nTotal

Endif

Return Nil
