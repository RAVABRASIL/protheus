#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function FATCCL()

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NMIDIA,CTES")
SetPrvt("WREGFIN,NREGTOT,NVALTOT,NPESTOT,NPESTOTX,AEST,AREP")
SetPrvt("ACLI,NQTDKG,NEST,NCLI,NREP,M_PAG")
SetPrvt("NLIN,ACLIS,AESTS,AREPS,NPACUM,NCONTJ,aPDT,")
SetPrvt("NCONTI,NVLACU,NPERC,CTIPO,NFATOR,NMARGEM,I,AMETA,NMETAKG,NMETAVL,dDATA")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Ana M B Alencar                          ³ Data ³ 31/03/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Curva abc de Clientes                                      ³±±
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
Private limite       := 220
Private tamanho      := "G"

cDESC1   := ""
cDESC2   := ""
cDESC3   := ""
aRETURN  := { "Zebrado", 1, "DECOM", 2, 2, 1, "", 1 }
cARQUIVO := "SF2"
aORD     := { "Por Data" }
cNOMREL  := "FATCCL"
cTITULO  := "Curva ABC de Clientes"
nLASTKEY := 0
cSegmento := ""

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Inicio do processamento                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                              ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01        	// Da Emissao                                 ³
//³ mv_par02        	// Ate Emissao                                ³
//³ mv_par03        	// Preco da Materia Prima                     ³
//³ mv_par04        	// % do Cliente A                             ³
//³ mv_par05        	// % do Cliente B                             ³
//³ mv_par06        	// Curva por                                  ³
//						1-R$ , 2-KG
//
//³ mv_par07        	// Tipo de Relatorio                          ³
//						1-Geral, 2-Segmento, 3-Familia 
//
//³ mv_par08        	// Por Segmento                                
//						1-Hospitalar, 2-Doméstica,  3-Institucional
//
//³ mv_par09        	// Familia                                   ³
//  mv_par10			//Estoque maior que...
//  mv_par11			//Segmento (selecionar qual)  
//INcluido por Flávia Rocha, ref. chamado 001502, filtrar por segmento
//Em 05/03/2010.
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	

cSEG := ' '
Pergunte('FATCCL',.T.)
If (mv_par07 == 2)
	If (mv_par08 == 1)
		cSEG := " por Segmento Hospitalar"
	ElseIf (mv_par08 == 2)
		cSEG := " por Segmento Domestico"
	Else
		cSEG := " por Segmento Institucional"
	EndIf
ElseIf (mv_par07 == 3)
	cSEG := " por Familia " + (mv_par09) + " de Produtos"
Else
	cSEG := " Geral"
EndIf
cCAB := "Relatorio" + cSEG + If( MV_PAR10 > 0, " com estoque maior que " + Alltrim( Trans( MV_PAR10, "999" ) ), "" )

//cNOMREL := setprint( cARQUIVO, cNOMREL, "FATCCL", @cTITULO, cDESC1, cDESC2, cDESC3, .f., aORD )

  cNOMREL := setprint( cARQUIVO, cNOMREL, "FATCCL", @cTITULO, cDESC1, cDESC2, cDESC3, .T., aORD,.T.,tamanho,,.T. )
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

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Inicio do processamento                                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

dbselectarea( 'SF1' )              // ADENILDO...
SF1->( dbSetorder( 2 ) )           //

dbselectarea( 'SD1' )              //
SD1->( dbSetorder( 1 ) )           //

dbselectarea( 'SCT' )
SCT->( dbsetorder( 1 ) )

dbselectarea( 'SA1' )
SA1->( dbsetorder( 1 ) )

dbselectarea( 'SF2' )
SF2->( dbsetorder( 9 ) ) //Alterado de 7 para 8 na migracao AP8

SX6->( dbSeek( xFilial( "SX6" ) + "MV_TESDNA", .T. ) )
cTes := Alltrim( SX6->X6_CONTEUD )

dbselectarea( 'SD2' )
SD2->( dbsetorder( 3 ) )

SF2->( dbseek( xFILIAL('SF2') + dtos( mv_par02 ), .T. ) )
wREGFIN := SF2->( recno() ) + 1

SF2->( dbseek( xFILIAL('SF2') + dtos( mv_par01 ), .T. ) )
nREGTOT := wREGFIN - SF2->( RECNO() )
nVALTOT := nPESTOT := 0
aEST  := {}
aREP  := {}
aPDT  := {}
aCLI  := {}
aMETA := {}
Aadd( aMETA, StrZero( Month( MV_PAR01 ), 2 ) + Str( Year( MV_PAR01 ), 4 ) )
dDATA := Ctod( "15/" + StrZero( Month( MV_PAR01 ), 2 ) + "/" + Str( Year( MV_PAR01 ), 4 ) ) + 30
Do While dDATA < MV_PAR02
	Aadd( aMETA, StrZero( Month( dDATA ), 2 ) + Str( Year( dDATA ), 4 ) )
	dDATA := Ctod( "15/" + StrZero( Month( dDATA ), 2 ) + "/" + Str( Year( dDATA ), 4 ) ) + 30
EndDo
SetRegua( nREGTOT )

while ! SF2->( eof() ) .and. SF2->F2_EMISSAO <= mv_par02
	
	If Empty(MV_PAR11) .and. ( MV_PAR07 == 1 .OR. MV_PAR07 == 2 .OR. MV_PAR07 == 3)         //se for geral ou por família
	
		SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
		
		If SD2->D2_CF $ "511  /5101 /611  /6101 /512  /5102 /612  /6102 /6107 /6109 /5949 /6949 "
			SA1->( DbSeek( xFILIAL('SA1') + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
			nVALIT := 0
			nQtdKg := 0
			
			while SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !eof() )
				cCOD := SD2->D2_COD
				
				If Len( AllTrim( cCOD ) ) >= 8
					If Subs( cCOD, 4, 1 ) == "R" .or. Subs( cCOD, 5, 1 ) == "R"
						cCOD := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 4 ) + Subs( SD2->D2_COD, 8, 2 ), Len( SD2->D2_COD ) )
					Else
						cCOD := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 3 ) + Subs( SD2->D2_COD, 7, 2 ), Len( SD2->D2_COD ) )
					EndIf
				EndIf
				
				SB1->( dbSeek( xFilial( 'SB1' ) + cCOD ) )
				SB2->( dbSeek( xFilial( 'SB2' ) + cCOD ) )
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Variaveis utilizadas para parametros                              ³
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ mv_par01        	// Da Emissao                                 ³
				//³ mv_par02        	// Ate Emissao                                ³
				//³ mv_par03        	// Preco da Materia Prima                     ³
				//³ mv_par04        	// % do Cliente A                             ³
				//³ mv_par05        	// % do Cliente B                             ³
				//³ mv_par06        	// Curva por                                  ³
				//						1-R$ , 2-KG
				//
				//³ mv_par07        	// Tipo de Relatorio                          ³
				//						1-Geral, 2-Segmento, 3-Familia 
				//
				//³ mv_par08        	// Por Segmento                                
				//						1-Hospitalar, 2-Doméstica,  3-Institucional
				//
				//³ mv_par09        	// Familia                                   ³
				//  mv_par10			//Estoque maior que...
				//  mv_par11			//Segmento (selecionar qual)
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				
				If ( MV_PAR07 == 1 .or. ;
					( MV_PAR07 == 2 .and. ( ;
					  ( MV_PAR08 == 1 .and. Left( cCOD, 1 ) == 'C' ) .or. ( MV_PAR08 == 2 .and. Left( cCOD, 1 ) $ 'DE' ) .or. ( MV_PAR08 == 3 .and. Left( cCOD, 1 ) == 'A' );
					  ) );
				  	.or.( MV_PAR07 == 3 .and. SB1->B1_SETOR == MV_PAR09 ) )   ////B1_SETOR => Família
				  	
					nQtdKg  += IIf( Empty(SD2->D2_SERIE) .and. ! 'VD' $ SF2->F2_VEND1, 0, IIf( SD2->D2_UM == "KG", SD2->D2_QUANT, ( SD2->D2_QUANT * SB1->B1_PESOR ) ) )
					nVALTOT += SD2->D2_TOTAL
					nVALIT  += SD2->D2_TOTAL
					If ( nPDT := ascan( aPDT, { |X| X[1] == SD2->D2_CLIENTE .and. X[2] == cCOD } ) ) == 0
						nVALCAR := CARTEIRA( cCOD )
					Else
						nVALCAR := aPDT[ nPDT, 6 ]
					EndIf
					If MV_PAR10 > 0 .and. ( SB2->B2_QATU - nVALCAR ) > MV_PAR10
						If nPDT == 0
							aadd( aPDT, { SD2->D2_CLIENTE, cCOD, Left( SB1->B1_DESC, 40 ), SB2->B2_QATU, SD2->D2_QUANT, nVALCAR, SD2->D2_EMISSAO } )
						Else
							aPDT[ nPDT, 5 ] += SD2->D2_QUANT
							aPDT[ nPDT, 7 ] := Max( SD2->D2_EMISSAO, aPDT[ nPDT, 7 ] )
						EndIf
					EndIf
				Endif			
				//////
				
				SD2->( dbSkip() )
			EndDo
			
					
				If Empty( nVALIT  )
					SF2->( dbskip() )
					IncRegua()
					Loop
				EndIf
				nPESTOT := nPESTOT + nQtdKg
				nEST := ascan( aEST, { |X| X[1] == SF2->F2_EST } )
				If Empty( nEST )
					SX5->( DbSeek( xFILIAL('SX5') + '12' + PadR( SF2->F2_EST, 6 ) ) )
					aadd( aEST, { SF2->F2_EST, nVALIT, nQtdKg, Left( SX5->X5_DESCRI, 20 ) } )
				Else
					aEST[nEST,2] += nVALIT
					aEST[nEST,3] += nQtdKg
				EndIf
				
				nCLI := ascan( aCLI, { |X| X[1] == SF2->F2_CLIENTE } )
				If Empty( nCLI )
					//aadd( aCLI, { SF2->F2_CLIENTE, nVALIT, nQtdKg, SA1->A1_NREDUZ, SA1->A1_TEL } )
					DbselectArea("SX5")
					Dbsetorder(1)
					SX5->(Dbseek(xFilial("SX5") + 'T3' + SA1->A1_SATIV1 )) 
					cSegmento := Alltrim(SX5->X5_DESCRI)
					
					//					1			2		3			4				5			6				7			8				9
					aadd( aCLI, { SF2->F2_CLIENTE, nVALIT, nQtdKg, SA1->A1_NREDUZ, SA1->A1_TEL, SA1->A1_EST, SA1->A1_ULTCOM,SA1->A1_CONTATO, cSegmento } )
				Else
					aCLI[nCLI,2] += nVALIT
					aCLI[nCLI,3] += nQtdKg
				EndIf
				
				nREP := ascan( aREP, { |X| X[1] == Left( SF2->F2_VEND1, 4 ) } )
				If Empty( nREP )
					nMETAKG := nMETAVL := 0
					For i := 1 To Len( aMETA )
						SCT->( DbSeek( Xfilial( "SCT" ) + aMETA[ i ], .T. ) )
						Do While SCT->CT_DOC == aMETA[ i ]
							If SCT->CT_VEND == Left( SF2->F2_VEND1, 4 ) + "  "
								nMETAKG += SCT->CT_QUANT
								nMETAVL += SCT->CT_VALOR
							EndIf
							SCT->( DbSkip() )
						EndDo
					Next
					SA3->( DbSeek( xFILIAL( 'SA3' ) + SF2->F2_VEND1 ) )
					aadd( aREP, { Left( SF2->F2_VEND1, 4 ), nVALIT, nQtdKg, SA3->A3_NREDUZ, nMETAKG, nMETAVL } )
				Else
					aREP[nREP,2] += nVALIT
					aREP[nREP,3] += nQtdKg
				EndIf		
			
		Endif		
		
	Elseif !Empty(MV_PAR11) 			////O PARÂMETRO MV_PAR (SEGMENTO) FOI SELECIONADO
	
		SA1->( DbSeek( xFILIAL('SA1') + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
		cSegmento := SA1->A1_SATIV1
		If mv_par11 == cSegmento
			
			SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
			
			If SD2->D2_CF $ "511  /5101 /611  /6101 /512  /5102 /612  /6102 /6107 /6109 /5949 /6949 "
				SA1->( DbSeek( xFILIAL('SA1') + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
				nVALIT := 0
				nQtdKg := 0
				
				while SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !eof() )
					cCOD := SD2->D2_COD
					
					If Len( AllTrim( cCOD ) ) >= 8
						If Subs( cCOD, 4, 1 ) == "R" .or. Subs( cCOD, 5, 1 ) == "R"
							cCOD := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 4 ) + Subs( SD2->D2_COD, 8, 2 ), Len( SD2->D2_COD ) )
						Else
							cCOD := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 3 ) + Subs( SD2->D2_COD, 7, 2 ), Len( SD2->D2_COD ) )
						EndIf
					EndIf
					
					SB1->( dbSeek( xFilial( 'SB1' ) + cCOD ) )
					SB2->( dbSeek( xFilial( 'SB2' ) + cCOD ) )				
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Variaveis utilizadas para parametros                              ³
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ mv_par01        	// Da Emissao                                 ³
					//³ mv_par02        	// Ate Emissao                                ³
					//³ mv_par03        	// Preco da Materia Prima                     ³
					//³ mv_par04        	// % do Cliente A                             ³
					//³ mv_par05        	// % do Cliente B                             ³
					//³ mv_par06        	// Curva por                                  ³
					//						1-R$ , 2-KG
					//
					//³ mv_par07        	// Tipo de Relatorio                          ³
					//						1-Geral, 2-Segmento, 3-Familia 
					//
					//³ mv_par08        	// Por Segmento                                
					//						1-Hospitalar, 2-Doméstica,  3-Institucional
					//
					//³ mv_par09        	// Familia                                   ³
					//  mv_par10			//Estoque maior que...
					//  mv_par11			//Segmento (selecionar qual)
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					If ( MV_PAR07 == 1 .or. ;
					( MV_PAR07 == 2 .and. ( ;
						  ( MV_PAR08 == 1 .and. Left( cCOD, 1 ) == 'C' ) .or. ( MV_PAR08 == 2 .and. Left( cCOD, 1 ) $ 'DE' ) .or. ( MV_PAR08 == 3 .and. Left( cCOD, 1 ) == 'A' );
						  ) );
				  	.or.( MV_PAR07 == 3 .and. SB1->B1_SETOR == MV_PAR09 ) )
				  	
					nQtdKg  += IIf( Empty(SD2->D2_SERIE) .and. ! 'VD' $ SF2->F2_VEND1, 0, IIf( SD2->D2_UM == "KG", SD2->D2_QUANT, ( SD2->D2_QUANT * SB1->B1_PESOR ) ) )
					nVALTOT += SD2->D2_TOTAL
					nVALIT  += SD2->D2_TOTAL
					If ( nPDT := ascan( aPDT, { |X| X[1] == SD2->D2_CLIENTE .and. X[2] == cCOD } ) ) == 0
						nVALCAR := CARTEIRA( cCOD )
					Else
						nVALCAR := aPDT[ nPDT, 6 ]
					EndIf
					If MV_PAR10 > 0 .and. ( SB2->B2_QATU - nVALCAR ) > MV_PAR10
						If nPDT == 0
							aadd( aPDT, { SD2->D2_CLIENTE, cCOD, Left( SB1->B1_DESC, 40 ), SB2->B2_QATU, SD2->D2_QUANT, nVALCAR, SD2->D2_EMISSAO } )
						Else
							aPDT[ nPDT, 5 ] += SD2->D2_QUANT
							aPDT[ nPDT, 7 ] := Max( SD2->D2_EMISSAO, aPDT[ nPDT, 7 ] )
						EndIf
					EndIf
				Endif								
				
					SD2->( dbSkip() )
				EndDo
				
						
					If Empty( nVALIT  )
						SF2->( dbskip() )
						IncRegua()
						Loop
					EndIf
					nPESTOT := nPESTOT + nQtdKg
					nEST := ascan( aEST, { |X| X[1] == SF2->F2_EST } )
					If Empty( nEST )
						SX5->( DbSeek( xFILIAL('SX5') + '12' + PadR( SF2->F2_EST, 6 ) ) )
						aadd( aEST, { SF2->F2_EST, nVALIT, nQtdKg, Left( SX5->X5_DESCRI, 20 ) } )
					Else
						aEST[nEST,2] += nVALIT
						aEST[nEST,3] += nQtdKg
					EndIf
					
					nCLI := ascan( aCLI, { |X| X[1] == SF2->F2_CLIENTE } )
					If Empty( nCLI )
						//aadd( aCLI, { SF2->F2_CLIENTE, nVALIT, nQtdKg, SA1->A1_NREDUZ, SA1->A1_TEL } )
						DbselectArea("SX5")
						Dbsetorder(1)
						SX5->(Dbseek(xFilial("SX5") + 'T3' + SA1->A1_SATIV1 )) 
						cSegmento := Alltrim(SX5->X5_DESCRI)
						
						//					1			2		3			4				5			6				7			8				9
						aadd( aCLI, { SF2->F2_CLIENTE, nVALIT, nQtdKg, SA1->A1_NREDUZ, SA1->A1_TEL, SA1->A1_EST, SA1->A1_ULTCOM,SA1->A1_CONTATO, cSegmento } )
					Else
						aCLI[nCLI,2] += nVALIT
						aCLI[nCLI,3] += nQtdKg
					EndIf
					
					nREP := ascan( aREP, { |X| X[1] == Left( SF2->F2_VEND1, 4 ) } )
					If Empty( nREP )
						nMETAKG := nMETAVL := 0
						For i := 1 To Len( aMETA )
							SCT->( DbSeek( Xfilial( "SCT" ) + aMETA[ i ], .T. ) )
							Do While SCT->CT_DOC == aMETA[ i ]
								If SCT->CT_VEND == Left( SF2->F2_VEND1, 4 ) + "  "
									nMETAKG += SCT->CT_QUANT
									nMETAVL += SCT->CT_VALOR
								EndIf
								SCT->( DbSkip() )
							EndDo
						Next
						SA3->( DbSeek( xFILIAL( 'SA3' ) + SF2->F2_VEND1 ) )
						aadd( aREP, { Left( SF2->F2_VEND1, 4 ), nVALIT, nQtdKg, SA3->A3_NREDUZ, nMETAKG, nMETAVL } )
					Else
						aREP[nREP,2] += nVALIT
						aREP[nREP,3] += nQtdKg
					EndIf		
				
			Endif			

	    Endif
	
	Endif
	SF2->( dbskip() )
	IncRegua()
	
end

nMIDIA := aReturn[5]
M_PAG  := 1
nLIN   := 0
/*/
SX1->( dbseek( 'FATCCL01' ) )
nLIN  := cabec( 'PARAMETROS DO RELATORIO CURVA ABC DE CLIENTES', '', '','FATCCL._IX', 'M', 15 )
nLIN  := nLIN +1
@ nLIN,00 pSay repl( '*', 132 )

while SX1->X1_GRUPO == 'FATCCL'
	
	nLIN := nLIN + 2
	
	@ nLIN,05 pSay 'Pergunta '+SX1->X1_ORDEM+' :'
	@ nLIN,20 pSay SX1->X1_PERGUNT
	
	if SX1->X1_GSC == 'G'
		
		@ nLIN,42 pSay SX1->X1_CNT01
		
	else
		
		do case
			case SX1->X1_PRESEL == 1
				
				@ nLIN,42 pSay SX1->X1_DEF01
				
			case SX1->X1_PRESEL == 2
				
				@ nLIN,42 pSay SX1->X1_DEF02
				
			case SX1->X1_PRESEL == 3
				
				@ nLIN,42 pSay SX1->X1_DEF03
				
			case SX1->X1_PRESEL == 4
				
				@ nLIN,42 pSay SX1->X1_DEF04
				
			case SX1->X1_PRESEL == 5
				
				@ nLIN,42 pSay SX1->X1_DEF05
				
		endcase
		
	endif
	
	SX1->( dbskip() )
	
end
/*/

If MV_PAR06 == 1
	
	ACLIS := {}
	ACLIS := Asort( aCLI,,, { | x, y | x[ 2 ] > y[ 2 ] } )
	AESTS := {}
	AESTS := Asort( aEST,,, { | x, y | x[ 2 ] > y[ 2 ] } )
	AREPS := {}
	AREPS := Asort( aREP,,, { | x, y | x[ 2 ] > y[ 2 ] } )
	
Else
	
	ACLIS := {}
	ACLIS := Asort( aCLI,,, { | x, y | x[ 3 ] > y[ 3 ] } )
	AESTS := {}
	AESTS := Asort( aEST,,, { | x, y | x[ 3 ] > y[ 3 ] } )
	AREPS := {}
	AREPS := Asort( aREP,,, { | x, y | x[ 3 ] > y[ 3 ] } )
	
EndIf
aPDT := Asort( aPDT,,, { | x, y | x[ 1 ] + X[ 2 ] < y[ 1 ] + Y[ 2 ] } )
nREGTOT := Len( aCLI )
SetRegua( nREGTOT )
m_PAG  := 1
nPACUM := 0
nCONTJ := Len( aCLI )
nCONTI := 1
nVLACU := 0
nPESTOTX := 0

while nCONTI <= nCONTJ
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Imprime cabecalho do relatorio      ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	ImpCab()
	
	while nCONTI <= nCONTJ .and. nLIN <= 62
		
		nPERC  := IIf( MV_PAR06 == 1, round( ( aCLIS[nCONTI,2] / nVALTOT ) * 100, 2 ), ;
		round( ( aCLIS[nCONTI,3] / nPESTOT ) * 100, 2 ) )
		
		if nPACUM <= MV_PAR04
			
			cTIPO := 'A'
			
		elseif nPACUM <= MV_PAR05
			
			cTIPO := 'B'
			
		else
			
			cTIPO := 'C'
			
		endif
		
		nPACUM := nPACUM + nPERC
		nVLACU := nVLACU + IIf( MV_PAR06 == 1, aCLIS[nCONTI,2], aCLIS[nCONTI,3] )
		
/*
			//					1			2		3			4				5			6				7			8				9
			aadd( aCLI, { SF2->F2_CLIENTE, nVALIT, nQtdKg, SA1->A1_NREDUZ, SA1->A1_TEL, SA1->A1_EST, SA1->A1_ULTCOM,SA1->A1_CONTATO, SA1->A1_SATIV1 } )
*/		
		
		@ nLIN,000 pSay aCLIS[nCONTI,1]                                		//COD.CLIENTE
		@ nLIN,008 pSay Left( aCLIS[nCONTI,4], 20 )                    		//NOME REDUZIDO
		@ nLIN,030 pSay aCLIS[nCONTI,2]   Picture '@E 9,999,999.99'        	//VAL. TOTAL ITEM
		@ nLIN,043 pSay aCLIS[nCONTI,3]   Picture '@E 9,999,999.99'         //KG
		@ nLIN,056 pSay nPERC             Picture '@E 999.99'               
		@ nLIN,063 pSay cTIPO
		@ nLIN,065 pSay nPACUM            Picture '@E 999.99'
		@ nLIN,072 pSay nVLACU            Picture '@E 999,999,999.99'
		
		nFATOR  := Round( aCLIS[nCONTI,2] / aCLIS[nCONTI,3], 3 )
		nMARGEM := Round( (nFATOR*100/MV_PAR03) - 100, 2 )
		
		@ nLIN,088 pSay nFATOR            Picture '@E 99.999'
		@ nLIN,095 pSay nMARGEM           Picture '@E 999.99'
		@ nLIN,102 pSay aCLIS[nCONTI,6]
		//@ nLIN,110 pSay Left( aCLIS[ nCONTI,5 ], 20 )
		@ nLIN,105 pSay Left( aCLIS[ nCONTI,5 ], 20 )
		@ nLIN,127 pSay aCLIS[nCONTI,7] 								//DT. ULT.COMPRA
		@ nLIN,138 pSay aCLIS[nCONTI,8]                              	//CONTATO
		@ nLIN,160 pSay aCLIS[nCONTI,9]                              	//SEGMENTO
		
		//Imprime novamente para ficar em negrito
		@ nLIN,000 pSay aCLIS[nCONTI,1]
		@ nLIN,008 pSay Left( aCLIS[nCONTI,4], 20 )
		@ nLIN,030 pSay aCLIS[nCONTI,2]   Picture '@E 9,999,999.99'
		@ nLIN,043 pSay aCLIS[nCONTI,3]   Picture '@E 9,999,999.99'
		@ nLIN,056 pSay nPERC             Picture '@E 999.99'
		@ nLIN,063 pSay cTIPO
		@ nLIN,065 pSay nPACUM            Picture '@E 999.99'
		@ nLIN,072 pSay nVLACU            Picture '@E 999,999,999.99'
		@ nLIN,088 pSay nFATOR            Picture '@E 99.999'
		@ nLIN,095 pSay nMARGEM           Picture '@E 999.99'
		@ nLIN,102 pSay aCLIS[nCONTI,6]
		//@ nLIN,110 pSay Left( aCLIS[ nCONTI,5 ], 20 )
		@ nLIN,105 pSay Left( aCLIS[ nCONTI,5 ], 20 )
		@ nLIN,127 pSay DToc(aCLIS[nCONTI,7])+iif((dDataBase-aCLIS[nCONTI,7])>90,"I","A") //I=Cliente "Inativo"; A=Cliente "Ativo"
		@ nLIN,138 pSay aCLIS[nCONTI,8]
		@ nLIN,160 pSay aCLIS[nCONTI,9]                              	//SEGMENTO
		
		
		If MV_PAR10 > 0
			nLIN++
			nPDT := ascan( aPDT, { |X| X[1] == aCLIS[nCONTI,1] } )
			Do While ! Empty( nPDT ) .and. nPDT <= Len( aPDT ) .and. aPDT[ nPDT, 1 ] == aCLIS[ nCONTI, 1 ]
				@ nLIN,000 pSay aPDT[ nPDT, 2 ]
				@ nLIN,014 pSay aPDT[ nPDT, 3 ]
				@ nLIN,062 pSay aPDT[ nPDT, 4 ] Picture "@E 999,999.99"
				//@ nLIN,075 pSay aPDT[ nPDT, 5 ] Picture "@E 999,999.99"
				@ nLIN,075 pSay aPDT[ nPDT, 6 ] Picture "@E 999,999.99" //Esmerino Neto
				//@ nLIN,090 pSay aPDT[ nPDT, 4 ] - aPDT[ nPDT, 5 ] Picture "@E 999,999.99"
				@ nLIN,090 pSay aPDT[ nPDT, 4 ] - aPDT[ nPDT, 6 ] Picture "@E 999,999.99"  //Esmerino Neto
				@ nLIN,106 pSay aPDT[ nPDT, 5 ] Picture "@E 999,999.99"
				@ nLIN,119 pSay aPDT[ nPDT, 7 ]
				If ++nLIN > 62
					Impcab()
				EndIf
				nPDT++
			EndDo
		EndIf
		nPESTOTX += Round( aCLIS[nCONTI,3], 2 )
		nLIN     := nLIN   + 1
		nCONTI   := nCONTI + 1
		IncRegua()
		
	end
	
end

nLIN    := nLIN + 1
nFATOR  := Round( nVALTOT / nPESTOT, 3 )
nMARGEM := Round( ( nFATOR * 100 / MV_PAR03 ) - 100, 2 )

@ nLIN,006 pSay 'TOTAL GERAL ==> '
@ nLIN,032 pSay nVALTOT  Picture '@E 9,999,999.99'
@ nLIN,046 pSay nPESTOTX Picture '@E 9,999,999.99'
@ nLIN,094 pSay nFATOR   Picture '@E 99.99'
@ nLIN,102 pSay nMARGEM  Picture '@E 999.99'

nREGTOT := Len( aEST )
SetRegua( nREGTOT )
m_PAG  := 1
nPACUM := 0
nCONTJ := Len( aEST )
nCONTI := 1
nVLACU := 0
nPESTOTX := 0

while nCONTI <= nCONTJ
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Imprime cabecalho do relatorio      ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
	nLIN := cabec( 'CURVA ABC DE ESTADOS' + iif( mv_par06==1, " EM REAIS", " EM QUILO" ), '', '','FATCCL', 'M', 15 )
	//   @ nLIN+02,00 pSay padc( cCAB, 132 )
	//   @ nLIN+01,54 pSay 'De '+DTOC(MV_PAR01)+' ate '+DTOC(MV_PAR02)
	//   @ nLIN+01,00 pSay repl( '*', 132 )
	//   @ nLIN+01,04 pSay '  Uf      Descricao                Valor Liquido    Peso Liquido     Perc.    T    %Acum.       Acumulado    Fator    Margem'
	//     XX      XXXXX----------XXXXX      9.999.999,99    9.999.999,99    999,99    X    999,99    9,999,999.99    9,999    999,99
	//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	//          1         2         3         4         5         6         7         8         9         1         1         2         3
	
	@prow()+1,000 pSay padc( cCAB, 132 )
	@prow()+1,000 pSay padc('De '+DTOC(MV_PAR01)+' ate '+DTOC(MV_PAR02), 132)
	@prow()+1,000 pSay repl( '*', 132)
	@prow()+1,000 pSay '  Uf      Descricao                Valor Liquido    Peso Liquido     Perc.  Class  %Acum.       Acumulado    Fator    Margem'
	@prow()+1,000 pSay repl( '*', 132 )
	//   @ nLIN+04,00 pSay repl( '*', 132 )
	nLIN := nLIN + 06
	
	while nCONTI <= nCONTJ .and. nLIN <= 62
		
		nPERC  := IIf( MV_PAR06 == 1, round( ( aESTS[nCONTI,2] / nVALTOT ) * 100, 2 ), ;
		round( ( aESTS[nCONTI,3] / nPESTOT ) * 100, 2 ) )
		
		if nPACUM <= MV_PAR04
			
			cTIPO := 'A'
			
		elseif nPACUM <= MV_PAR05
			
			cTIPO := 'B'
			
		else
			
			cTIPO := 'C'
			
		endif
		
		nPACUM   := nPACUM + nPERC
		nVLACU   := nVLACU + IIf( MV_PAR06 == 1, aESTS[nCONTI,2], aESTS[nCONTI,3] )
		nPESTOTX += Round( aESTS[nCONTI,3], 2 )
		
		@ nLIN,006 pSay aESTS[nCONTI,1]
		@ nLIN,014 pSay aESTS[nCONTI,4]
		@ nLIN,040 pSay aESTS[nCONTI,2]   Picture '@E 9,999,999.99'
		@ nLIN,056 pSay aESTS[nCONTI,3]   Picture '@E 9,999,999.99'
		@ nLIN,072 pSay nPERC             Picture '@E 999.99'
		@ nLIN,082 pSay cTIPO
		@ nLIN,087 pSay nPACUM            Picture '@E 999.99'
		@ nLIN,097 pSay nVLACU            Picture '@E 9,999,999.99'
		
		nFATOR  := Round( aESTS[nCONTI,2] / aESTS[nCONTI,3], 3 )
		nMARGEM := Round( (nFATOR*100/MV_PAR03) - 100, 2 )
		
		@ nLIN,113 pSay nFATOR            Picture '@E 99.999'
		@ nLIN,121 pSay nMARGEM           Picture '@E 9999.99'
		
		
		nLIN   := nLIN   + 1
		nCONTI := nCONTI + 1
		IncRegua()
		
	end
	
end

nLIN    := nLIN + 1
nFATOR  := Round( nVALTOT / nPESTOT, 3 )
nMARGEM := Round( ( nFATOR*100 / MV_PAR03 ) - 100, 2 )

@ nLIN,014 pSay 'TOTAL GERAL ==> '
@ nLIN,040 pSay nVALTOT  Picture '@E 9,999,999.99'
@ nLIN,056 pSay nPESTOTX Picture '@E 9,999,999.99'
@ nLIN,113 pSay nFATOR   Picture '@E 99.999'
@ nLIN,122 pSay nMARGEM  Picture '@E 999.99'

nREGTOT := Len( aREP )
SetRegua( nREGTOT )
m_PAG   := 1
nPACUM  := 0
nCONTJ  := Len( aREP )
nCONTI  := 1
nVLACU  := 0
nMETAKG := nMETAVL := 0
nPESTOTX := 0

while nCONTI <= nCONTJ
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Imprime cabecalho do relatorio      ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
	nLIN := cabec( 'CURVA ABC DE REPRESENTANTES' + iif( mv_par06==1, " EM REAIS", " EM QUILO" ), '', '','FATCCL', 'M', 15 )
	//@ nLIN+02,00 pSay padc( cCAB, 132 )
	@ prow()+1,000 pSay padc( cCAB, 132 )
	@ prow()+1,000 pSay padc('De '+DTOC(MV_PAR01)+' ate '+DTOC(MV_PAR02), 132)
	@ prow()+1,000 pSay repl( '*', 132 )
	@ prow()+1,000 pSay 'Codg  Nome                   Val.Liquido  Peso Liquido   Perc. Cla %Acum.   Fator   Margem  --------Meta Kg/R$-------  -%Meta Kg/R$-'
	//   XXXX  XXXXX----------XXXXX  9.999.999,99  9.999.999,99  999,99  X  999,99  99,999  9999,99  9,999,999.99 9,999,999.99  999,99 999,99
	//    012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	//              1         2         3         4         5         6         7         8         9         1         1         2         3
	@ prow()+1,000 pSay repl( '*', 132 )
	//   @ nLIN+04,00 pSay repl( '*', 132 )
	nLIN := nLIN + 06
	
	while nCONTI <= nCONTJ .and. nLIN <= 62
		
		nPERC  := IIf( MV_PAR06 == 1, round( ( aREPS[nCONTI,2] / nVALTOT ) * 100, 2 ), round( ( aREPS[nCONTI,3] / nPESTOT ) * 100, 2 ) )
		
		if nPACUM <= MV_PAR04
			
			cTIPO := 'A'
			
		elseif nPACUM <= MV_PAR05
			
			cTIPO := 'B'
			
		else
			
			cTIPO := 'C'
			
		endif
		
		nPACUM := nPACUM + nPERC
		nVLACU := nVLACU + IIf( MV_PAR06 == 1, aREPS[nCONTI,2], aREPS[nCONTI,3] )
		nPESTOTX += Round( aREPS[nCONTI,3], 2 )
		
		@ nLIN,000 pSay aREPS[nCONTI,1]
		@ nLIN,006 pSay aREPS[nCONTI,4]
		@ nLIN,028 pSay aREPS[nCONTI,2]   Picture '@E 9,999,999.99'
		@ nLIN,042 pSay aREPS[nCONTI,3]   Picture '@E 9,999,999.99'
		@ nLIN,056 pSay nPERC             Picture '@E 999.99'
		@ nLIN,064 pSay cTIPO
		@ nLIN,067 pSay nPACUM            Picture '@E 999.99'
		//      @ nLIN,097 pSay nVLACU            Picture '@E 9,999,999.99'
		
		nFATOR  := Round( aREPS[nCONTI,2] / aREPS[nCONTI,3], 3 )
		nMARGEM := Round( (nFATOR*100/MV_PAR03) - 100, 2 )
		
		@ nLIN,075 pSay nFATOR            Picture '@E 99.999'
		@ nLIN,083 pSay nMARGEM           Picture '@E 9999.99'
		@ nLIN,092 pSay aREPS[nCONTI,5]   Picture '@E 9,999,999.99'
		@ nLIN,105 pSay aREPS[nCONTI,6]   Picture '@E 9,999,999.99'
		@ nLIN,119 pSay round( ( aREPS[nCONTI,3] / aREPS[nCONTI,5] ) * 100, 2 ) Picture '@E 999.99'
		@ nLIN,126 pSay round( ( aREPS[nCONTI,2] / aREPS[nCONTI,6] ) * 100, 2 ) Picture '@E 999.99'
		nMETAKG += aREPS[ nCONTI, 5 ]
		nMETAVL += aREPS[ nCONTI, 6 ]
		
		nLIN   := nLIN   + 1
		nCONTI := nCONTI + 1
		IncRegua()
		
	end
	
end

nLIN    := nLIN + 1
nFATOR  := Round( nVALTOT / nPESTOT, 3 )
nMARGEM := Round( ( nFATOR * 100/MV_PAR03 ) - 100, 2 )

@ nLIN,010 pSay 'TOTAL GERAL ==> '
@ nLIN,028 pSay nVALTOT  Picture '@E 9,999,999.99'
@ nLIN,042 pSay nPESTOTX Picture '@E 9,999,999.99'
@ nLIN,075 pSay nFATOR   Picture '@E 99.999'
@ nLIN,083 pSay nMARGEM  Picture '@E 9999.99'
@ nLIN,092 pSay nMETAKG   Picture '@E 9,999,999.99'
@ nLIN,105 pSay nMETAVL   Picture '@E 9,999,999.99'
@ nLIN,119 pSay round( ( nMETAKG / nPESTOT ) * 100, 2 ) Picture '@E 999.99'
@ nLIN,126 pSay round( ( nMETAVL / nVALTOT ) * 100, 2 ) Picture '@E 999.99'

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
return



**********************

Static Function IMPCAB

**********************

nLIN := cabec( 'CURVA ABC DE CLIENTES' + iif( mv_par06==1, " EM REAIS", " EM QUILO" ), '', '','FATCCL', 'G', 18 )
//   @ nLIN+02,00 pSay padc( cCAB, 132 )
//   @ nLIN+01,54 pSay 'De '+DTOC(MV_PAR01)+' ate '+DTOC(MV_PAR02)
//   @ nLIN+01,00 pSay repl( '*', 132 )
//   @ nLIN+01,00 pSay 'Codigo  Nome                   Valor Liquido  Peso Liquido   Perc.  T  %Acum.      Acumulado   Fator  Margem  Telefone'
//   999999  XXXXX----------XXXXX    9.999.999,99  9.999.999,99  999,99  X  999,99  99,999,999.99  99,999  999,99  99999999999999999999
//    012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//              1         2         3         4         5         6         7         8         9         1         1         2         3

@prow()+1,000 pSay padc( cCAB, 141/*132*/ )
@prow()+1,000 pSay padc( 'De '+DTOC(MV_PAR01)+' ate '+DTOC(MV_PAR02), 141/*132*/ )
@prow()+1,000 pSay repl( '*', 170/*132*/)
//@prow()+1,000 pSay 'Codigo  Nome                   Valor Liquido  Peso Liquido   Perc.  T  %Acum.      Acumulado   Fator  Margem  Telefone'
@prow()+1,000 pSay 'Codigo  Nome                 Valor Liquido Peso Liquido Perc. Cla %Acum. Acumulado      Fator  Margem UF    Telefones         Dt.Ul.Com   Contato               Segmento'
@prow()  ,000 pSay 'Codigo  Nome                 Valor Liquido Peso Liquido Perc. Cla %Acum. Acumulado      Fator  Margem UF    Telefones         Dt.Ul.Com   Contato               Segmento'
//                  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17
//                  999999  xxxxxxxxxxxxxxxxxxxx  9,999,999.99 9,999,999.99 999.99 x 999.99 999,999.99 99.999 999.99 xx 99999999999999999999 99/99/99    xxxxxxxxxxxxxxxxxxxx  999999
//                  999999  xxxxxxxxxxxxxxxxxxxxxxxx9,999,999.99  9,999,999.99  999.99  x  999.99  99,999,999.99  99.999 9999.99  xx  99999999999999999999

If MV_PAR10 > 0
	@prow()+1,000 pSay repl( '*', 141/*132*/)
	@prow()+1,000 pSay 'Produto       Descricao                                           Estoque     Carteira   Estoque real   Qtd. Faturada   Data ult.compra'
EndIf
//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                     0         1         2         3         4         5         6         7         8         9        10        11        12
//                                                                                    999,999.99   999,999.99     999,999.99      999,999.99   xx/xx/xx
@prow()+1,000 pSay repl( '*', 170/*132*/ )
//   @ nLIN+04,00 pSay repl( '*', 132 )
nLIN := Prow() + 2
Return NIL


**********************
Static Function CARTEIRA(cProduto)
**********************

Local cProdOri, cProdGen//, cQuery1

cProdOri := cProduto

If Substr(cProduto, 1, 4) == "R"
	cProdGen := Substr(cProduto, 1, 1) + "D" + Substr(cProduto, 2, 4) + "6" + Substr(cProduto, 6, 2)
ElseIf Substr(cProduto, 1, 5) == "R"
	cProdGen := Substr(cProduto, 1, 1) + "D" + Substr(cProduto, 2, 5) + "6" + Substr(cProduto, 7, 2)
Else
	cProdGen := Substr(cProduto, 1, 1) + "D" + Substr(cProduto, 2, 3) + "6" + Substr(cProduto, 5, 2)
EndIf

cQuery1 := "SELECT SUM( SC6.C6_QTDVEN - SC6.C6_QTDENT ) AS CARTEIRA FROM SC6020 SC6 "
cQuery1 += "WHERE SC6.C6_PRODUTO IN ('" + cProdOri + "', '" + cProdGen + "') "
cQuery1 += "AND( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 "
cQuery1 += "AND SC6.C6_BLQ <> 'R' "
cQuery1 += "AND SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' "
cQuery1 += ChangeQuery( cQuery1 )
TCQUERY cQuery1 NEW ALIAS "SCAR"
TCSetField( 'SCAR', "CARTEIRA", "N", 5, 2 )
SCAR->( DBGoTop() )
nCarteira := Round(SCAR->CARTEIRA, 2)
SCAR->( DbCloseArea() )

Return nCarteira
