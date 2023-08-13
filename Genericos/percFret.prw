#include "rwmake.ch"
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function percFret( cData1, cData2 )

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M")
SetPrvt("TAMANHO,LIMITE,CDESC1,CDESC2,CDESC3,ARETURN")
SetPrvt("NOMEPROG,CPERG,NLASTKEY,LCONTINUA,NLIN,WNREL")
SetPrvt("M_PAG,NTAMNF,CSTRING,TITULO,CABEC1,CABEC2")
SetPrvt("CINDSF2,CCHAVE,CFILTRO,AFRETE,AFRE_NF,NDNA")
SetPrvt("NTOT,NFRE,NTOTAL,NTOTFRET,NTOTFRICMS,NTOTICMS")
SetPrvt("NTOTDNA,NTOTRED,NDNAG,NTOTG,NFREG,NTOTGICMS")
SetPrvt("NDNACI,NTOTCI,NFRECI,NTOTCIICMS,CESTCI,X")
SetPrvt("CESTADO,CTRANSP,NVALDNA,NAD_VALOREN,NFRET_PES,NFRETE")
SetPrvt("NSUFRAMA,NTAXAFIXA,NFRETICMS,NPERC,NPEDAGIO")
Private dData1 := stod( cData1 )
Private dData2 := stod( cData2 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// De Data                               ³
//³ mv_par02        	// Ate Data                              ³
//³ mv_par03        	// De Transportador                      ³
//³ mv_par04        	// Ate Transportador                     ³
//³ mv_par05        	// De Nota                               ³
//³ mv_par06        	// Ate Nota                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SD2->( dbSetOrder( 3 ) )

dbSelectArea("SF2")

cIndSf2 := CriaTrab(nil,.f.)  // "SF2"+Substr( Time(), 4, 2 ) + Substr( Time(), 7, 2 )
cChave  := "F2_FILIAL + F2_TRANSP"
cFiltro := "F2_EMISSAO >= dData1 .and. F2_EMISSAO <= dData2"

IndRegua( "SF2", cIndSf2, cChave, , cFiltro,"Selecionando Notas.." )
dbSeek( xFilial( "SF2" ) + '',.t. )
SetRegua( Lastrec() )

aFrete := {}

While SF2->( !Eof() ) .And. SF2->F2_FILIAL == xFilial( "SF2" ) .and. SF2->F2_TRANSP <= 'ZZZZZZZZZZZZ'
   if SF2->F2_DOC < '' .or. SF2->F2_DOC > 'ZZZZZZZZZZZZZZ'
      SF2->( dbSkip() )
      Loop
      IncRegua()
   endif
   
                                    //Inclui em 01/03/11 - Eurivan
   if SF2->F2_SERIE $ "   DNA DNS"  .AND. ! "VD" $ SF2->F2_VEND1
      SF2->( dbSkip() )
      Loop
      IncRegua()
   endif
   
   
   SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
   SC5->( dbseek( xFilial( "SC5" ) + SD2->D2_PEDIDO, .T. ) )
   SZZ->( dbSeek( xFilial( "SZZ" ) + SF2->F2_TRANSP + SC5->C5_LOCALIZ ) )
   if Empty( SF2->F2_REDESP )
      Aadd( aFrete, { SF2->F2_TRANSP, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_LOCALIZ, " ", SF2->F2_EST + SZZ->ZZ_TIPO } )
   endif
   if !Empty( SF2->F2_REDESP )
      Aadd( aFrete, { SF2->F2_TRANSP, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_LOCRED, " ", SF2->F2_EST + SZZ->ZZ_TIPO } )
      Aadd( aFrete, { SF2->F2_REDESP, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_LOCALIZ,"R", SF2->F2_EST + SZZ->ZZ_TIPO } )
   endif
   SF2->( dbSkip() )
   IncRegua()
EndDo

RetIndex( "SF2" )
Ferase( cIndSf2+".cdx")
SA4->( dbSetOrder( 1 ) )

aFre_nf := Asort( aFrete,,, { |X,Y| X[6]+X[1]+X[2]<Y[6]+Y[1]+Y[2] } )
nDna    := nTot  := nFre := nTotal := nTotFret := nTotFrIcms := nTotIcms := nTotDna :=nTotRed := nTotpes:= 0
nDnaG   := nTotG := nFreG:= nTotGicms := 0
nDnaCI  := nTotCI:= nFreCI:= nTotCIicms := 0

SetRegua( Len( aFre_nf ) )
cEstCI  := Substr( aFre_nf[ 1, 6 ], 1, 2 )
For x := 1 to Len( aFre_nf )
    cEstado := aFre_nf[ x, 6 ]
    /*if nLin > 60
       nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
    endif*/
    SX5->( dbSeek( xFilial( "SX5" ) + "12" + Substr( cEstado, 1, 2 ), .t. ) )
    /*@ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " " + Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) )
    nLin := nLin + 2*/
    While aFre_nf[ x, 6 ] == cEstado
       cTransp := aFre_nf[ x, 1 ]
       SA4->( dbSeek( xFilial( "SA4" ) + aFre_nf[ x, 1 ] ) )
       /*@ nLin,000 pSay "Transportadora.: " + SA4->A4_NOME
       nLin := nLin + 1*/

       While aFre_nf[ x, 1 ] == cTransp .and. aFre_nf[ x, 6 ] == cEstado

          /*IF nLin > 60

             nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2

             @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " "+Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) )
             @ nLin+2,000 pSay "Transportadora.: " + SA4->A4_NOME

             nLin := nLin + 4

          EndIf*/

            nValDna := 0

          SZZ->( dbSeek( xFilial( "SZZ" ) + aFre_nf[ x, 1 ] + aFre_nf[ x, 4 ] ) )
          SF2->( dbSeek( xFilial( "SF2" ) + aFre_nf[ x, 2 ] + aFre_nf[ x, 3 ], .t. ) )

          if Alltrim( cTransp ) == "03" .and. Alltrim( SZZ->ZZ_LOCAL ) $ "07 09 20 59 94 46"
             nAd_valoren := Round( SF2->F2_VALBRUT * 0.3 / 100, 2 )
          else
             nAd_valoren := Round( SF2->F2_VALBRUT * SZZ->ZZ_ADVALOR / 100, 2 )
          endif

          nFret_pes := Round( iif(SF2->F2_PLIQUI>=SA4->A4_KG_MIN, SF2->F2_PLIQUI, SA4->A4_KG_MIN ) * SZZ->ZZ_FR_PESO, 2 )
          nFrete    := Round( iif(SF2->F2_PLIQUI>=SA4->A4_KG_MIN, SF2->F2_PLIQUI, SA4->A4_KG_MIN ) * SZZ->ZZ_FR_PESO, 2 )

//BPL --> Inicio
			 If Alltrim( SF2->F2_EST ) $ "AC AP AM RO RR"
			 	 nSuframa := ( Round ( ( SF2->F2_VALBRUT * SZZ->ZZ_SUFRAMA ) / 100, 2 ) )
			 Else
			     nSuframa := SZZ->ZZ_SUFRAMA
			 Endif
//BPL --> Fim --> 29/10/03

          if SZZ->ZZ_TIPO == "C"
             If ( Alltrim( cTransp ) == "03" .and. Alltrim( SZZ->ZZ_LOCAL ) == "07" ) .or. ( Alltrim( cTransp ) == "20" .and. Alltrim( SF2->F2_EST ) == "SP" )
                nTaxaFixa := SA4->A4_TXFIXA2
             else
                nTaxaFixa := Iif( !Empty( SA4->A4_VOLTXF2 ) .and. SF2->F2_VOLUME1>=SA4->A4_VOLTXF2, SA4->A4_TXFIXA2, SA4->A4_TXFIXA )
             endif
          else
             if ( Alltrim( cTransp ) == "03" .and. Alltrim( SZZ->ZZ_LOCAL ) $ "09 20 59 94 46" )  .or. ( Alltrim( cTransp ) == "20" .and. Alltrim( SF2->F2_EST ) == "SP" )
                nTaxaFixa := SA4->A4_TXFIXA2
             else
                nTaxaFixa := SA4->A4_TXFIXAI
             endif
          endif

//BPL --> Inicio
          nPedagio := 0

          //If SF2->F2_EST == "SP"
*             If SF2->F2_PBRUTO <= 100
*   	       	 nPedagio := SZZ->ZZ_PEDAGIO
*	          else
	             nPedagio := Round( ( SF2->F2_PLIQUI / 100 ) + .5, 0 ) * SZZ->ZZ_PEDAGIO
*	          endif
          //endif
//BPL --> Fim --> 29/10/03

 		  // Alterado por Diego e Brainner

* 		  nRes := (SF2->F2_PLIQUI/100)
* 		  nFrac := MOD(SF2->F2_PLIQUI, 100)
* 		  If (nFrac == 0)
* 		  	nNewPedag := (nPedagio * nRes)
* 		  else
* 		  	nNewPedag := (Int(nRes)* nPedagio) + nPedagio
* 		  endif

          If SZZ->ZZ_TIPO == "C"
             nFrete := If( ( nFret_pes + nTaxaFixa + nAd_valoren + SZZ->ZZ_ADM + nPedagio + nSuframa ) < SA4->A4_FREMINC, SA4->A4_FREMINC, nFret_pes + nTaxaFixa + nAd_valoren + SZZ->ZZ_ADM + nPedagio + nSuframa )
          Else
             nFrete := If( ( nFret_pes + nTaxaFixa + nAd_valoren + SZZ->ZZ_ADM + nPedagio + nSuframa ) < SA4->A4_FREMINI, SA4->A4_FREMINI, nFret_pes + nTaxaFixa + nAd_valoren + SZZ->ZZ_ADM + nPedagio + nSuframa )
          EndIf
          nFretIcms := nFrete / Round( ( 100 - SA4->A4_ICMS ) / 100, 2 )
          nValDna   := nValDna + SF2->F2_VALBRUT
          nPerc     := Round( nFretIcms*100/nValDna, 2 )

          /*@ nLin,000 pSay SF2->F2_DOC +"-"+SF2->F2_SERIE+" "+aFre_nf[ x, 5 ]
          @ nLin,011 pSay SF2->F2_VALBRUT   Picture "@E 999,999,999.99"
          @ nLin,026 pSay SF2->F2_PLIQUI    Picture "@E 99,999.99"
          @ nLin,037 pSay nFret_pes         Picture "@E 99,999.99"
          @ nLin,048 pSay nTaxaFixa         Picture "@E 999.99"
          @ nLin,056 pSay nAd_valoren       Picture "@E 999,999.99"
          @ nLin,068 pSay SZZ->ZZ_ADM       Picture "@E 99,999.99"
          @ nLin,079 pSay nPedagio		    	Picture "@E 99,999.99"
          @ nLin,090 pSay nSuframa          Picture "@E 99,999.99"
          @ nLin,101 pSay nFrete            Picture "@E 99,999.99"
          @ nLin,112 pSay nFretIcms         Picture "@E 99,999.99"
          @ nLin,123 pSay SF2->F2_EST
          @ nLin,127 pSay nPerc             Picture "@E 99.99"*/

          nTotFrIcms := nTotFrIcms + nFretIcms
          nTotal     := nTotal     + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
  	      nTotpes    := nTotpes    + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_PLIQUI)
          nTotFret   := nTotFret   + nFrete
          nTotDna    := nTotDna    + nValDna

          nTotCI     := nTotCI     + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
          nTotCIicms := nTotCIicms + nFretIcms
          nFreCI     := nFreCI     + nFrete
          nDnaCI     := nDnaCI     + nValDna

          //nLin       := nLin       + 1
          x          := x          + 1

          if x > Len( aFre_nf )
             exit
          endif
          IncRegua()

       end

       if nTotal #0 .or. nTotFret # 0 .or. ntotFrIcms # 0
          /*
          nLin := nLin + 1

          IF nLin > 60
             nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
             // SX5->( dbSeek( xFilial( "SX5" ) + "12"+ cEstado, .t. ) )
             @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " "+Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) )
             @ nLin+2,000 pSay "Transportadora.: " + SA4->A4_NOME
          EndIf*/


          nPerc     := Round( nTotFrIcms*100/nTotDna, 2 )
          /*@ nLin,00 pSay "Total"
          @ nLin,11 pSay  nTotal     Picture "@E 999,999,999.99"
	      @ nLin,26 pSay  nTotpes    Picture "@E 99,999.99"
          @ nLin,101 pSay nTotFret   Picture "@E 99,999.99"
          @ nLin,112 pSay nTotFrIcms Picture "@E 99,999.99"
          @ nLin,126 pSay nPerc      Picture "@E 99.99"*/

          //nlin := nLin + 2

          nTot     := nTot     + nTotal
          nTotIcms := nTotIcms + nTotFrIcms
          nFre     := nFre     + nTotFret
          nDna     := nDna     + nTotDna
          nTotal   := nTotPes := nTotFret := nTotFrIcms := nTotDna := 0


       endif

       if x > Len( aFre_nf )
          exit
       endif
       IncRegua()

       if x <= Len( aFre_nf )
          cTransp := aFre_nf[ x, 1 ]
       endif

    End

    if nTot #0 .or. nFre # 0 .or. nTotIcms # 0

       //nLin := nLin + 1

       /*IF nLin > 60
          nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
          // SX5->( dbSeek( xFilial( "SX5" ) + "12"+ cEstado, .t. ) )
          @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI )
          @ nLin+2,000 pSay "Transportadora.: " + SA4->A4_NOME
       EndIf */

       nPerc     := Round( nTotIcms*100/nDna, 2 )

       /*@ nLin,00 pSay "Total "+Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) )
       @ nLin,11 pSay  nTot     Picture "@E 999,999,999.99"
       @ nLin,101 pSay nFre     Picture "@E 99,999.99"
       @ nLin,112 pSay nTotIcms Picture "@E 99,999.99"
       @ nLin,126 pSay nPerc      Picture "@E 99.99"*/

       //nlin := nLin + 2
       nTotG     := nTotG     + nTot
       nTotGIcms := nTotGIcms + nTotIcms
       nFreG     := nFreG     + nFre
       nDnaG     := nDnaG     + nDna
       nTot      := nFre := nTotIcms := nDna := 0

    endif

    if x > Len( aFre_nf ) .or. ( nTotCI #0 .or. nFreCI # 0 .or. nFreCI # 0 ) .and. cEstCI # Substr( aFre_nf[ x, 6 ], 1, 2 )

       /*nLin := nLin + 1

       IF nLin > 60
          nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
          @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI )
          @ nLin+2,000 pSay "Transportadora.: " + SA4->A4_NOME
       EndIf*/

       nPerc     := Round( nTotCIicms*100/nDnaCI, 2 )
       /*@ nLin,000 pSay "Total do Estado"
       @ nLin,011 pSay nTotCI     Picture "@E 999,999,999.99"
       @ nLin,101 pSay nFreCI     Picture "@E 99,999.99"
       @ nLin,112 pSay nTotCIicms Picture "@E 99,999.99"
       @ nLin,126 pSay nPerc      Picture "@E 99.99"*/

       //nlin := nLin + 2
       nTotCI := nFreCI := nTotCIicms := nDnaCI := 0
       if x <= Len( aFre_nf )
          cEstCi  := Substr( aFre_nf[ x, 6 ], 1, 2 )
       endif

    endif

    if x <= Len( aFre_nf )
       cEstado := aFre_nf[ x, 6 ]
       ctransp := aFre_nf[ x, 1 ]
       cEstCi  := Substr( aFre_nf[ x, 6 ], 1, 2 )

       /*if nLin > 60
          nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
       endif*/
    endif

    x := x - 1

Next

/*IF nLin > 60
   nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	 if nLin == 7
	   nLin += 1
	 endif
EndIF*/

//@ nLin,00  pSay "Geral ==>"

nPerc := Round( nTotGIcms*100/nDnaG, 2 )

/*@ nLin,11  pSay nTotG     Picture "@E 999,999,999.99"
@ nLin,101 pSay nFreG     Picture "@E 999,999.99"
@ nLin,113 pSay nTotGIcms Picture "@E 999,999.99"
@ nLin,128 pSay nPerc     Picture "@E 99.99"*/

//roda(cbcont,cbtxt,tamanho)

dbSelectArea("SF2")

/*If aReturn[5] == 1
   dbCommitAll()
   ourspool(wnrel)
Endif*/

RetIndex( "SD2" )
Return nPerc