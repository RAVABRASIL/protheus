#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATCPR()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NMIDIA,WREGFIN")
SetPrvt("NREGTOT,NVALTOT,NPESTOT,NQTD_ML,APRD,AGRP")
SetPrvt("CTES,NPRD,NGRP,M_PAG,APRDS,AGRPS")
SetPrvt("NPACUM,NCONTJ,NCONTI,NPCP,NLIN,NPERC")
SetPrvt("CTIPO,NFATOR,NMARGEM,NMEDMESKG,NMEDPRGKG,NMEDMESML")
SetPrvt("NMEDPRGML,CSEG,nD2Quant,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Ana M B Alencar                          ³ Data ³ 31/03/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Curva abc de Produtos                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Comercial                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                              ³
//³ mv_par01        	// De emissao                                 ³
//³ mv_par02        	// Ate emissao                                ³
//³ mv_par03        	// Preco da Materia Prima                     ³
//³ mv_par04        	// % Cliente A                                ³
//³ mv_par05        	// % Cliente B                                ³
//³ mv_par06        	// Curva Por 1-R$ ou 2-Kg                     ³
//³ mv_par07        	// Div. Media PCP                             ³
//³ mv_par08            // Do Tipo de Produto                         ³
//³ mv_par09            // Ate o Tipo de Produto                      ³
//³ mv_par10            // Imp. Prod. Secundaria                      ³
//³ mv_par11            // Tipo de Relatorio                          ³
//³ mv_par12            // Segmento                                   ³
//³ mv_par13            // Familia                                    ³
//³ mv_par14            // Imprime Produtos Ativos                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
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
cNOMREL  := "FATCPR"
cTITULO  := "Curva ABC de Produtos"
nLASTKEY := 0

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicio do processamento                                      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

cSEG := ' '
par11 := par12 := par13 := 0
Pergunte('FATCPR',.T.)
par11 := mv_par11
par12 := mv_par12
par13 := mv_par13
If (par11 == 2)
	If (par12 == 1)
	  cSEG := " por Segmento Hospitalar"
	ElseIf (par12 == 2)
	  cSEG := " por Segmento Domestico"
	Else
	  cSEG := " por Segmento Institucional"
	EndIf
ElseIf (par11 == 3)
      cSEG := " por Familia " + (par13) + " de Produtos"
Else
	cSEG := " Geral"
EndIf


cNOMREL := setprint( cARQUIVO, cNOMREL, "FATCPR", @cTITULO, cDESC1, cDESC2, ;
 cDESC3, .f., aORD )
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
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return
// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicio do processamento                                      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

dbselectarea( 'SA1' )
SA1->( dbsetorder( 1 ) )
dbselectarea( 'SF2' )
SF2->( dbsetorder( 9 ) ) //Alterado de 7 para 8 na migracao AP8
dbselectarea( 'SD2' )
SD2->( dbsetorder( 3 ) )
SB1->( DbSetOrder( 1 ) )
SB2->( DbSetOrder( 1 ) )
SF2->( dbseek( xFILIAL('SF2') + dtos( mv_par02 ), .T. ) )
wREGFIN := SF2->( recno() ) + 1
SF2->( dbseek( xFILIAL('SF2') + dtos( mv_par01 ), .T. ) )
nREGTOT := wREGFIN - SF2->( RECNO() )
nVALTOT := nPESTOT := nQtd_ml := 0
aPRD    := {}
aGRP    := {}
SetRegua( nREGTOT )
SX6->( dbSeek( xFilial( "SX6" ) + "MV_TESDNA", .T. ) )
cTes := Alltrim( SX6->X6_CONTEUD )
while ! SF2->( eof() ) .and. SF2->F2_EMISSAO <= mv_par02

//   If ! Empty( SF2->F2_DUPL )

      SD2->( dbSeek( xFilial( 'SD2' ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )

      while SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !eof() )
         SB1->( dbSeek( xFilial( 'SB1' ) + SD2->D2_COD ) )
         //if SD2->D2_CF $ "511  /5101 /611  /6101 /512  /5102 /612  /6102 /6107 /6109 " .and. ;
         if SD2->D2_CF $ "511  /5101 /611  /6101 /512  /5102 /612  /6102 /6107 /6109 /5949 /6949 " .and. Iif( MV_PAR14 # 1, Iif( MV_PAR14 == 2, SB1->B1_ATIVO == 'S', SB1->B1_ATIVO == 'N'), SB1->B1_ATIVO $ "S N" ) .and. ;
				 	( MV_PAR11 == 1 .or. ( MV_PAR11 == 2 .and. ( ( MV_PAR12 == 1 .and. Left( SD2->D2_COD, 1 ) == 'C' ) .or. ;
			 	    ( MV_PAR12 == 2 .and. Left( SD2->D2_COD, 1 ) $ 'DE' ) .or. ( MV_PAR12 == 3 .and. Left( SD2->D2_COD, 1 ) == 'A' ) ) ) .or. ;
					( MV_PAR11 == 3 .and. SB1->B1_SETOR == MV_PAR13 ) )

 			if MV_PAR10 == 1
				_cCodSec := SD2->D2_COD
			Else
				if Len( Alltrim( SD2->D2_COD ) ) <= 7
  					_cCodSec := SD2->D2_COD
				Else
   					If Subs( SD2->D2_COD, 5, 1 ) == "R"
	  					_cCodSec := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 4 ) + Subs( SD2->D2_COD, 8, 2 ), 15 )
			      	Else
	 					_cCodSec := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 3 ) + Subs( SD2->D2_COD, 7, 2 ), 15 )
					EndIf
			   EndIf
	  		EndIf

            If SB1->B1_TIPO >= mv_par08 .And. SB1->B1_TIPO <= mv_par09

            	SB5->( dbSeek( xFilial( 'SD2' ) + SB1->B1_COD, .T. ) ) 	//Esmerino Neto
							nD2Quant := SD2->D2_QUANT / (1000 / SB5->B5_QE2) 			//Esmerino Neto  Conversao para Milheiros
							/* Consulta SQL para saber os pesos cadastrados
							SELECT 	SB5.B5_QTDEN, SB5.B5_QTDFIM , SB1.B1_ATIVO, SB5.B5_COD, SB1.B1_COD
							FROM 	SB5010 SB5, SB1010 SB1
							WHERE 	SB5.B5_QTDEN <> '1000'
							AND (SUBSTRING(SB5.B5_COD,1,1) LIKE 'A' OR SUBSTRING(SB5.B5_COD,1,1) LIKE 'C' OR SUBSTRING(SB5.B5_COD,1,1) LIKE 'D' OR SUBSTRING(SB5.B5_COD,1,1) LIKE 'E')
							AND SB5.B5_COD = SB1.B1_COD
							AND SB1.B1_ATIVO <> 'N'
							AND SB1.B1_TIPO = 'PA'
							AND SB5.D_E_L_E_T_ = ''
							AND SB1.D_E_L_E_T_ = ''
							ORDER BY SB5.B5_COD
							*/
							//nD2Quant := SD2->D2_QUANT
            	nPESTOT := nPESTOT + ( SD2->D2_QUANT * SB1->B1_PESOR )  //IIf( Empty(SD2->D2_SERIE) .and. !'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )   Esmerino Neto 07/07/06 por Marcelo
							nVALTOT := nVALTOT + SD2->D2_TOTAL
            	nQtd_ml := nQtd_ml + nD2Quant  //IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant )  Esmerino Neto 07/07/06 por Marcelo
            	nPRD    := ascan( aPRD, { |X| X[1] == _cCODSEC } )

            	If Empty( nPRD )

	            	aadd( aPRD, { _cCODSEC, SD2->D2_TOTAL, IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) ), SB1->B1_DESC,;
										 nD2Quant /*IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant )*/ } )

            	Else

					aPRD[nPRD,2] := aPRD[nPRD,2] + SD2->D2_TOTAL
					aPRD[nPRD,3] := aPRD[nPRD,3] + ( SD2->D2_QUANT * SB1->B1_PESOR )  //IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )  Esmerino Neto 07/07/06 por Marcelo
					aPRD[nPRD,5] := aPRD[nPRD,5] + nD2Quant //IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant )  Esmerino Neto 07/07/06 por Marcelo

				EndIf


				nGRP    := ascan( aGRP, { |X| X[1] == SD2->D2_GRUPO } )

				If Empty( nGRP )

					SX5->( DbSeek( xFILIAL('SX5') + '03' + PadR( SD2->D2_GRUPO, 6 ) ) )
					aadd( aGRP, { SD2->D2_GRUPO, SD2->D2_TOTAL, IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) ), Left( SX5->X5_DESCRI, 20 ),;
							  nD2Quant /*IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant )*/ } )
				Else

					aGRP[nGRP,2] := aGRP[nGRP,2] + SD2->D2_TOTAL
					aGRP[nGRP,3] := aGRP[nGRP,3] + ( SD2->D2_QUANT * SB1->B1_PESOR )  //IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )  Esmerino Neto 07/07/06 por Marcelo
					aGRP[nGRP,5] := aGRP[nGRP,5] + nD2Quant //IIf( Empty(SD2->D2_SERIE).and.!'VD' $ SF2->F2_VEND1, 0, nD2Quant )  Esmerino Neto 07/07/06 por Marcelo
				Endif

         	Endif

         //Endif
         Endif
         SD2->( dbSkip() )

      End

   //EndIf

   SF2->( dbskip() )

   IncRegua()

End

nMIDIA := aReturn[5]
M_PAG     := 1

If MV_PAR06 == 1
   APRDS := Asort( aPRD,,, { | x, y | x[ 2 ] > y[ 2 ] } )
   AGRPS := Asort( aGRP,,, { | x, y | x[ 2 ] > y[ 2 ] } )
Else
   APRDS := Asort( aPRD,,, { | x, y | x[ 3 ] > y[ 3 ] } )
   AGRPS := Asort( aGRP,,, { | x, y | x[ 3 ] > y[ 3 ] } )
EndIf

nREGTOT := Len( aPRD )
SetRegua( nREGTOT )
m_PAG  := 1
nPACUM := 0
nCONTJ := Len( aPRD )
nCONTI := 1
nPCP   := Round( ( mv_par02 - mv_par01 ) / 30, 0 )
nLIN   := 0
while nCONTI <= nCONTJ

   /*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     ³ Imprime cabecalho do relatorio      ³
     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   */

   nDIA := ( mv_par02 - mv_par01 )

   nLIN := cabec( 'CURVA ABC DE PRODUTOS ' + iif( mv_par06==1, " EM REAIS", "EM QUILO" ), '', '', 'FATCPR', 'G', 15 )
   @ nLIN+01,84 pSay 'Relatorio' + cSEG + ' - De ' + DTOC(MV_PAR01) + ' ate ' + DTOC( MV_PAR02 ) + ' (total de ' + STR(MV_PAR02 - MV_PAR01,3) + ' dias)'
   @ nLIN+03,00 pSay repl( '*', 220 )
//   @ nLIN+04,00 pSay  'Codigo         Estoque  Prev.Vend  Descricao do                                              Valor          Peso   Perc. Classe %Acum.  Fator  Margem      Per.         PCP      Quant.   Media Ml.     Med.Ml.  Med.Semana'
//   @ nLIN+05,00 pSay  '             Atual Ml.  Semestral  Produto                                                 Liquido       Liquido   Media        Estoqu          Media     Media                Milheiro    Milheiro       PCP'
   @ nLIN+04,00 pSay  'Codigo         Estoque  Produto    Descricao do                                              Valor          Peso   Perc. Classe Perc.   Fator  Margem    Media         PCP       Quant.     Media         PCP    Med.Semana'
   @ nLIN+05,00 pSay  '             Atual Ml.   Ativo     Produto                                                 Liquido       Liquido   Media        Acumul          Media   Mens.Kg        Kg      Milheiro    Mens.Ml         Ml      em Kg'
                     //9999999999  999.999,99     XX      XXXXX----------XXXXX                               9.999.999,99  9.999.999,99  999,99   X    999,99  9,999  999,99  9,999.99  999,999.99  999,999.99  999,999.99  999,999.99  999,999.99
                     //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                     //          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
   @ nLIN + 06,00 pSay repl( '*', 220 )
   nLIN := nLIN + 07

   while nCONTI <= nCONTJ .and. nLIN <= 60

      nPERC  := IIf( MV_PAR06 == 1, round( ( aPRDS[nCONTI,2] / nVALTOT ) * 100, 2 ), ;
                                    round( ( aPRDS[nCONTI,3] / nPESTOT ) * 100, 2 ) )

      if nPACUM <= MV_PAR04

         cTIPO := 'A'

      elseif nPACUM <= MV_PAR05

         cTIPO := 'B'

      else

         cTIPO := 'C'

      endif

      nPACUM    := nPACUM + nPERC
      nFATOR    := Round( aPRDS[nCONTI,2] / aPRDS[nCONTI,3], 3 )
      nMARGEM   := Round( (nFATOR*100/MV_PAR03) - 100, 2 )
      nMedMesKg := Round( aPRDS[nCONTI,3]/nPCP, 2 )
      nMedPrgKg := Round( nMedMesKg/mv_par07, 2 )
      nMedMesMl := Round( aPRDS[nCONTI,5]/nPCP, 2 )
      nMedPrgMl := Round( nMedMesMl/mv_par07, 2 )
      SB1->( dbSeek( xFilial( 'SB1' ) + aPRDS[nCONTI,1] ) )
      SB2->( dbSeek( xFilial( 'SB2' ) + aPRDS[nCONTI,1] ) )
      @ nLIN,000 pSay Left( aPRDS[nCONTI,1], 10 )
      @ nLIN,012 pSay SB2->B2_QATU 		Picture '@E 999,999.99'//* SB1->B1_PESOR (se esta formula for adicionada o Estoque fica em KG)
      //@ nLIN,029 pSay ( SB2->B2_QATU * SB1->B1_PESOR ) / ( aPRDS[nCONTI,3] / ( MV_PAR02 - MV_PAR01 ) ) Picture '@E 9999'  //Previsao de Venda de KG por dia
      //@ nLIN,029 pSay SB2->B2_QATU / ( aPRDS[nCONTI,5] / (( MV_PAR02 - MV_PAR01 ) / 180)) Picture '@E 9999' //Previsao de Venda de Miheiros por semestre
	  	@ nLIN,027 pSay SB1->B1_ATIVO
      @ nLIN,035 pSay aPRDS[nCONTI,4]
      @ nLIN,086 pSay aPRDS[nCONTI,2]   Picture '@E 9,999,999.99'
      @ nLIN,100 pSay aPRDS[nCONTI,3]   Picture '@E 9,999,999.99'
      @ nLIN,114 pSay nPERC             Picture '@E 999.99'
      @ nLIN,123 pSay cTIPO
      @ nLIN,128 pSay nPACUM            Picture '@E 999.99'
      @ nLIN,136 pSay nFATOR            Picture '@E 99.999'
      @ nLIN,143 pSay nMARGEM           Picture '@E 999.99'
      @ nLIN,151 pSAY nMedMesKg         Picture '@E 999,999.99'
      @ nLIN,161 pSAY nMedPrgKg         Picture '@E 999,999.99'
      @ nLin,173 pSAY aPRDS[nCONTI,5]   Picture '@E 999,999.99'
      @ nLin,185 pSAY nMedMesMl         Picture '@E 999,999.99'
      @ nLin,197 pSAY nMedPrgMl         Picture '@E 999,999.99'
      @ nLin,209 pSAY Round(nMedMesKg/4,2) Picture '@E 999,999.99'

      nLIN   := nLIN   + 1
      nCONTI := nCONTI + 1

      IncRegua()

   end

end

nLIN      := nLIN + 1
nFATOR    := Round( nVALTOT / nPESTOT, 3 )
nMARGEM   := Round( (nFATOR*100/MV_PAR03) - 100, 2 )
nMedMesKg := Round( nPESTOT/nPCP, 2 )
nMedPrgKg := Round( nMedMesKg/mv_par07, 2 )
nMedMesMl := Round( nQtd_ml/nPCP, 2 )
nMedPrgMl := Round( nMedMesMl/mv_par07, 2 )

@ nLIN,035/*022*/ pSay 'TOTAL GERAL ==> '
@ nLIN,084/*073*/ pSay nVALTOT   Picture '@E 999,999,999.99'
@ nLIN,100/*089*/ pSay nPESTOT   Picture '@E 9,999,999.99'
@ nLIN,136/*130*/ pSay nFATOR    Picture '@E 99.999'
@ nLIN,143/*139*/ pSay nMARGEM   Picture '@E 999.99'
@ nLIN,151/*146*/ pSAY nMedMesKg Picture '@E 999,999.99'
@ nLIN,161/*157*/ pSAY nMedPrgKg Picture '@E 999,999.99'
@ nLin,171/*168*/ pSAY nQtd_ml   Picture '@E 9,999,999.99'
@ nLin,185/*179*/ pSAY nMedMesMl Picture '@E 999,999.99'
@ nLin,197/*190*/ pSAY nMedPrgMl Picture '@E 999,999.99'
@ nLin,209/*202*/ pSAY Round( nMedMesKg / 4, 2 ) Picture '@E 999,999.99'

nREGTOT := Len( aGRP )
SetRegua( nREGTOT )
m_PAG  := 1
nPACUM := 0
nCONTJ := Len( aGRP )
nCONTI := 1

while nCONTI <= nCONTJ

   /*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     ³ Imprime cabecalho do relatorio      ³
     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   */

   nLIN := cabec( 'CURVA ABC DE GRUPOS', '', '','FATCPR', 'G', 15 )
   @ nLIN+01,54 pSay 'Relatorio' + cSEG + ' - De ' + DTOC(MV_PAR01) + ' ate ' + DTOC( MV_PAR02 ) + ' (total de ' + STR(MV_PAR02 - MV_PAR01,3) + ' dias)'
   //@ nLIN+03,00 pSay repl( '*', 220 )
   @ nLIN+03,12 pSay 'Grupo     Descricao                Valor Liquido    Peso Liquido     Perc.  Class  %Acum.     Fator    Margem       Per.        PCP  Quant      Media     Med. PCP    Med.Semana'
   @ nLIN+04,12 pSay '                                                                                                       Media        Media            Milheiro   Milheiro  Milheiro'
                 //   XXX       XXXXX----------XXXXX      9.999.999,99    9.999.999,99    999,99    X    999,99    99,999    999,99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99  999,999.99
                //    0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                //    1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        10        22
   @ nLIN+05,00 pSay repl( '*', 220 )
   nLIN := nLIN + 06

   while nCONTI <= nCONTJ .and. nLIN <= 60

      nPERC  := IIf( MV_PAR06 == 1, round( ( aGRPS[nCONTI,2] / nVALTOT ) * 100, 2 ), ;
                                    round( ( aGRPS[nCONTI,3] / nPESTOT ) * 100, 2 ) )

      if nPACUM <= MV_PAR04

         cTIPO := 'A'

      elseif nPACUM <= MV_PAR05

         cTIPO := 'B'

      else

         cTIPO := 'C'

      endif

      nPACUM    := nPACUM + nPERC
      nFATOR    := Round( aGRPS[nCONTI,2] / aGRPS[nCONTI,3], 3 )
      nMARGEM   := Round( (nFATOR*100/MV_PAR03) - 100, 2 )
      nMedMesKg := Round( aGRPS[nCONTI,3]/nPCP, 2 )
      nMedPrgKg := Round( nMedMesKg/mv_par07, 2 )
      nMedMesMl := Round( aGRPS[nCONTI,5]/nPCP, 2 )
      nMedPrgMl := Round( nMedMesMl/mv_par07, 2 )

      @ nLIN,012 pSay aGRPS[nCONTI,1]
      @ nLIN,022 pSay aGRPS[nCONTI,4]
      @ nLIN,048 pSay aGRPS[nCONTI,2]   Picture '@E 9,999,999.99'
      @ nLIN,064 pSay aGRPS[nCONTI,3]   Picture '@E 9,999,999.99'
      @ nLIN,080 pSay nPERC             Picture '@E 999.99'
      @ nLIN,090 pSay cTIPO
      @ nLIN,095 pSay nPACUM            Picture '@E 999.99'
      @ nLIN,105 pSay nFATOR            Picture '@E 99.999'
      @ nLIN,114 pSay nMARGEM           Picture '@E 999.99'
      @ nLIN,121 pSAY nMedMesKg         Picture '@E 999,999.99'
      @ nLIN,132 pSAY nMedPrgKg         Picture '@E 999,999.99'
      @ nLin,143 pSAY aGRPS[nCONTI,5]   Picture '@E 999,999.99'
      @ nLin,154 pSAY nMedMesMl         Picture '@E 999,999.99'
      @ nLin,165 pSAY nMedPrgMl         Picture '@E 999,999.99'
      @ nLin,177 pSAY Round( nMedMesKg / mv_par07, 4 ) Picture '@E 999,999.99'

      IncRegua()
      nLIN   := nLIN   + 1
      nCONTI := nCONTI + 1

   end

end

nLIN      := nLIN + 1
nFATOR    := Round( nVALTOT / nPESTOT, 3 )
nMARGEM   := Round( (nFATOR*100/MV_PAR03) - 100, 2 )
nMedMesKg := Round( nPESTOT/nPCP, 2 )
nMedPrgKg := Round( nMedMesKg/mv_par07, 2 )
nMedMesMl := Round( nQtd_ml/nPCP, 2 )
nMedPrgMl := Round( nMedMesMl/mv_par07, 2 )

@ nLIN,022 pSay 'TOTAL GERAL ==> '
@ nLIN,047 pSay nVALTOT Picture '@E 99,999,999.99'
@ nLIN,063 pSay nPESTOT Picture '@E 99,999,999.99'
@ nLIN,105 pSay nFATOR  Picture '@E 99.999'
@ nLIN,114 pSay nMARGEM Picture '@E 999.99'
@ nLIN,121 pSAY nMedMesKg         Picture '@E 999,999.99'
@ nLIN,132 pSAY nMedPrgKg         Picture '@E 999,999.99'
@ nLin,143 pSAY nQtd_Ml           Picture '@E 999,999.99'
@ nLin,154 pSAY nMedMesMl         Picture '@E 999,999.99'
@ nLin,165 pSAY nMedPrgMl         Picture '@E 999,999.99'
@ nLin,177 pSAY Round(nMedMesKg/mv_par07,4) Picture '@E 999,999.99'


Roda(0,"","M")

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(cNomRel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
retindex( "SF2" )
retindex( "SD2" )
retindex( "SA1" )
retindex( "SB1" )
return
