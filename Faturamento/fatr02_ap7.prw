#include "rwmake.ch"
#include "topconn.ch"
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATR02()

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Fatr02  ³ Autor ³   Silvano Araujo      ³ Data ³ 07/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Fretes por nota fiscal                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Rava                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// De Data                               ³
//³ mv_par02        	// Ate Data                              ³
//³ mv_par03        	// De Transportador                      ³
//³ mv_par04        	// Ate Transportador                     ³
//³ mv_par05        	// De Nota                               ³
//³ mv_par06        	// Ate Nota                              ³ 
//  mv_par07			// Lista notas (1-Normais, 2-bonificação,
//						 3-amostras, 4-Todas)
//  mv_par08 			// Pedido mínimo: 1-Abaixo, 2-Acima, 3-Todas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CbTxt		:=	""
CbCont		:=	""
nOrdem 		:=	0
Alfa 		:= 0
Z			:=	0
M			:=	0
tamanho		:=	"G"
limite		:=	254
cDesc1 		:=	PADC("Este programa ira Emitir relacao de fretes por nota fiscal",74)
cDesc2 		:=	""
cDesc3 		:=	""
aReturn 	:= { "Faturamento", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog	:=	"FATR02"
cPerg		:=	"FATR02"  
nLastKey	:= 0
lContinua 	:= .T.
nLin		:=	9
wnrel    	:= "FATR02"
M_PAG    	:= 1
nTamNf		:=	72

Pergunte(cPerg,.F.)

cString		:=	"SF2"
titulo 		:=	PADC("Relacao de Fretes por Nota Fiscal",74)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cbtxt    := SPACE(10)
cbcont   := 0
nLin     := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cabec1:= "N.F.   Ser     Valor N.F. Peso Brut  Fret Peso  Tx Fixa Ad-Valorem        ADM  Pedagio    Suframa    Val Frete  Val c/Icm  UF  Perc"
cabec2:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("FATR02",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel		:=	"FATR02"            //Nome Default do relatorio em Disco
wnrel		:=	SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})
   Return
   Static Function RptDetail()
#ENDIF

SD2->( dbSetOrder( 3 ) )

dbSelectArea("SF2")
SD2->( dbSetOrder( 1 ) )
/*
cIndSf2 := CriaTrab(nil,.f.)  // "SF2"+Substr( Time(), 4, 2 ) + Substr( Time(), 7, 2 )
cChave  := "F2_FILIAL + F2_TRANSP"
cFiltro := "F2_EMISSAO >= mv_par01 .and. F2_EMISSAO <= mv_par02"

IndRegua( "SF2", cIndSf2, cChave, , cFiltro,"Selecionando Notas.." )
dbSeek( xFilial( "SF2" )+mv_par03,.t. )
*/
SetRegua( Lastrec() )


aFrete := {}
/*
While SF2->( !Eof() ) .And. SF2->F2_FILIAL == xFilial( "SF2" ) .and. lContinua .And. SF2->F2_TRANSP <= mv_par04
   if !tipos( SF2->F2_DOC ) .and. mv_par07 != 4
      SF2->( dbSkip() )
      IncRegua()      
      Loop
   endIf
   if SF2->F2_DOC < mv_par05 .or. SF2->F2_DOC > mv_par06
      SF2->( dbSkip() )
      IncRegua()      
      Loop
   endif
   if SF2->F2_SERIE $ "   DNA DNS"
      SF2->( dbSkip() )
      IncRegua()      
      Loop
   endif
   SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
   SC5->( dbseek( xFilial( "SC5" ) + SD2->D2_PEDIDO, .T. ) )
   SZZ->( dbSeek( xFilial( "SZZ" ) + SF2->F2_TRANSP + SC5->C5_LOCALIZ ) )
   if Empty( SF2->F2_REDESP )
      Aadd( aFrete, { SF2->F2_TRANSP, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_LOCALIZ, " ", SF2->F2_EST + SZZ->ZZ_TIPO,ALLTRIM(getReg(SF2->F2_EST)) } )
   endif
   if !Empty( SF2->F2_REDESP )
      Aadd( aFrete, { SF2->F2_TRANSP, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_LOCRED, " ", SF2->F2_EST + SZZ->ZZ_TIPO,ALLTRIM(getReg(SF2->F2_EST)) } )
      Aadd( aFrete, { SF2->F2_REDESP, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_LOCALIZ,"R", SF2->F2_EST + SZZ->ZZ_TIPO,ALLTRIM(getReg(SF2->F2_EST)) } )
   endif
   SF2->( dbSkip() )
   IncRegua()
EndDo
*/
/*
RetIndex( "SF2" )
Ferase( cIndSf2+".cdx")
*/
SA4->( dbSetOrder( 1 ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// De Data                               ³
//³ mv_par02        	// Ate Data                              ³
//³ mv_par03        	// De Transportador                      ³
//³ mv_par04        	// Ate Transportador                     ³
//³ mv_par05        	// De Nota                               ³
//³ mv_par06        	// Ate Nota                              ³ 
//  mv_par07			// Lista notas (1-Normais, 2-bonificação,
//						// 3-amostras, 4-Todas)
//  mv_par08 			// Pedido mínimo: 1-Abaixo, 2-Acima, 3-Todas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := ""

cQuery := " SELECT F2_FILIAL, F2_DOC,F2_SERIE, F2_TRANSP, F2_REDESP, F2_LOCALIZ, F2_LOCRED, F2_EST, F2_VALBRUT "
cQuery += " ,D2_DOC, D2_SERIE, D2_PEDIDO, C5_NUM, F4_CODIGO, F4_DUPLIC "
cQuery += " FROM " + RetSqlName("SF2") + " SF2, "
cQuery += " " + RetSqlName("SD2") + " SD2, "
cQuery += " " + RetSqlName("SC5") + " SC5, "  
cQuery += " " + RetSqlName("SF4") + " SF4 "
cQuery += " WHERE F2_FILIAL = D2_FILIAL "
//Considerar somente Manaus
//cQuery += " AND F2_LOCALIZ = '24' "   //Alterado por Flávia Rocha - Ref. Chamado: 001589 - incluir parâmetro para selecionar por UF
cQuery += " AND F2_DOC = D2_DOC "
cQuery += " AND F2_SERIE = D2_SERIE "
cQuery += " AND D2_PEDIDO = C5_NUM "
cQuery += " AND D2_TES = F4_CODIGO "
//cQuery += " AND F2_SERIE NOT IN( 'DNA','DNS')
cQuery += " AND F2_TIPO  = 'N' "
//If mv_par07 == 1
//	cQuery += " and F4_DUPLIC = 'S' "
//Else
//	cQuery += " and F4_DUPLIC = 'N' "
//Endif

//If mv_par07 == 3
//	cQuery += " and F4_CODIGO in ('507','516') "
//Endif

If mv_par08 == 1
	cQuery += " and F2_VALBRUT <= 1000 "    ////pedido mínimo é R$1.000,00 definido por Marcelo
Elseif mv_par08 == 2
	cQuery += " and F2_VALBRUT >= 1000 "
Endif

cQuery += " AND F2_EMISSAO >= '" + Dtos(mv_par01) + "' AND F2_EMISSAO <= '" + Dtos(mv_par02) + "' "
cQuery += " AND F2_TRANSP >= '" + mv_par03 + "' AND F2_TRANSP <= '" + mv_par04 + "' "
cQuery += " AND F2_DOC >= '" + mv_par05 + "' AND F2_DOC <= '" + mv_par06 + "' "
cQuery += " AND RTRIM(F2_EST) >= '" + Alltrim(mv_par09) + "' AND RTRIM(F2_EST) <= '" + Alltrim(mv_par10) + "' "
cQuery += " AND F2_FILIAL = '" + xFilial("SF2") + "' "
cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "' "
cQuery += " AND C5_FILIAL = '" + xFilial("SC5") + "' "
cQuery += " AND F4_FILIAL = '" + xFilial("SF4") + "' "
cQuery += " AND SF2.D_E_L_E_T_ = '' "
cQuery += " AND SD2.D_E_L_E_T_ = '' "
cQuery += " AND SC5.D_E_L_E_T_ = '' " 
cQuery += " AND SF4.D_E_L_E_T_ = '' "
cQuery += " GROUP BY F2_FILIAL, F2_DOC,F2_SERIE, F2_TRANSP, F2_REDESP, F2_LOCALIZ, F2_LOCRED, F2_EST, F2_VALBRUT "
cQuery += " ,D2_DOC, D2_SERIE, D2_PEDIDO, C5_NUM, F4_CODIGO, F4_DUPLIC "
cQuery += " ORDER BY F2_FILIAL, F2_TRANSP, F2_DOC, F2_SERIE "
//MemoWrite("\TempQry\FT02.SQL", cQuery )
If Select("FT02") > 0
	DbSelectArea("FT02")
	DbCloseArea()	
EndIf 

TCQUERY cQuery NEW ALIAS "FT02"  
FT02->( dbGoTop() )

While FT02->( !EOF())
	
	if !tipos( FT02->F2_DOC ) .and. mv_par07 != 4
      FT02->( dbSkip() )
      IncRegua()      
      Loop
   endIf
   
   if FT02->F2_SERIE $ "   DNA DNS"
      FT02->( dbSkip() )
      IncRegua()      
      Loop
   endif
   //SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
   //SC5->( dbseek( xFilial( "SC5" ) + SD2->D2_PEDIDO, .T. ) )
   SZZ->(Dbsetorder(1))
   if Empty( FT02->F2_REDESP )   		
   		SZZ->( dbSeek( xFilial( "SZZ" ) + FT02->F2_TRANSP + FT02->F2_LOCALIZ ) )
      	Aadd( aFrete, { FT02->F2_TRANSP, FT02->F2_DOC, FT02->F2_SERIE, FT02->F2_LOCALIZ, " ", FT02->F2_EST + SZZ->ZZ_TIPO,ALLTRIM(getReg(FT02->F2_EST)) } )
   else
   		SZZ->( dbSeek( xFilial( "SZZ" ) + FT02->F2_REDESP + FT02->F2_LOCALIZ ) )
      	Aadd( aFrete, { FT02->F2_TRANSP, FT02->F2_DOC, FT02->F2_SERIE, FT02->F2_LOCRED, " ", FT02->F2_EST + SZZ->ZZ_TIPO,ALLTRIM(getReg(FT02->F2_EST)) } )
      	Aadd( aFrete, { FT02->F2_REDESP, FT02->F2_DOC, FT02->F2_SERIE, FT02->F2_LOCALIZ,"R", FT02->F2_EST + SZZ->ZZ_TIPO,ALLTRIM(getReg(FT02->F2_EST)) } )
   endif
   FT02->( dbSkip() )
   IncRegua()

Enddo

aFre_nf := Asort( aFrete,,, { |X,Y| X[7]+X[6]+X[1]+X[2]<Y[7]+Y[6]+Y[1]+Y[2] } )
nDna    := nTot  := nFre := nTotal := nTotFret := nTotFrIcms := nTotIcms := nTotDna :=nTotRed := nTotpes:= 0
nDnaG   := nTotG := nFreG:= nTotGicms := 0
nDnaCI  := nTotCI:= nFreCI:= nTotCIicms := 0
//REGIAO
nTotCE:=nTotNE:=nTotNO:=nTotSD:=nTotSL:=0
nTotCEicms :=nTotNEicms :=nTotNOicms :=nTotSDicms :=nTotSLicms := 0
nFreCE :=nFreNE :=nFreNO :=nFreSD :=nFreSL :=0
nDnaCE :=nDnaNE :=nDnaNO :=nDnaSD :=nDnaSL :=0
//
SetRegua( Len( aFre_nf ) )
if len(aFre_nf) > 0
	cEstCI  := Substr( aFre_nf[ 1, 6 ], 1, 2 )
endIf

For x := 1 to Len( aFre_nf )   
    cEstado := aFre_nf[ x, 6 ]
    if nLin > 55
       //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
       cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 )
       nLin := 9
    endif
    SX5->( dbSeek( xFilial( "SX5" ) + "12" + Substr( cEstado, 1, 2 ), .t. ) )
    @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " " + Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) )
    nLin := nLin + 2
    While aFre_nf[ x, 6 ] == cEstado
    
    	If nLin > 55
        	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 )
            nLin := 9
     	EndIf
       
       cTransp := aFre_nf[ x, 1 ]
       SA4->( dbSeek( xFilial( "SA4" ) + aFre_nf[ x, 1 ] ) )
       @ nLin,000 pSay "Transportadora.: " + SA4->A4_NOME
       nLin := nLin + 1

       While aFre_nf[ x, 1 ] == cTransp .and. aFre_nf[ x, 6 ] == cEstado

          IF nLin > 55

             //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
             cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 )
             nLin := 9

             @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " "+Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) )
             @ nLin+2,000 pSay "Transportadora.: " + SA4->A4_NOME

             nLin := nLin + 4

          EndIf

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

          @ nLin,000 pSay SF2->F2_DOC +"-"+Alltrim(SF2->F2_SERIE)+" "+aFre_nf[ x, 5 ]
          @ nLin,011 pSay SF2->F2_VALBRUT   Picture "@E 999,999,999.99"
          @ nLin,026 pSay SF2->F2_PLIQUI    Picture "@E 99,999.99"
          @ nLin,037 pSay nFret_pes         Picture "@E 99,999.99"
          @ nLin,048 pSay nTaxaFixa         Picture "@E 999.99"
          @ nLin,056 pSay nAd_valoren       Picture "@E 999,999.99"
          @ nLin,068 pSay SZZ->ZZ_ADM       Picture "@E 99,999.99"
          @ nLin,079 pSay nPedagio		    Picture "@E 99,999.99"
          @ nLin,090 pSay nSuframa          Picture "@E 99,999.99"
          @ nLin,101 pSay nFrete            Picture "@E 99,999.99"
          @ nLin,112 pSay nFretIcms         Picture "@E 99,999.99"  
          @ nLin,123 pSay SF2->F2_EST
          @ nLin,127 pSay nPerc             Picture "@E 99.99"
                                                              
          If SA1->A1_TIPO=='F'  .and.  nTotal >= Z48->Z48_SPFINA
           //testa se pedido atingiu o valor mínimo para a sua localidade
          @ nLin,140 pSay "X"
          endIf     
          
          
          nTotFrIcms := nTotFrIcms + nFretIcms
          nTotal     := nTotal     + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
  	      nTotpes    := nTotpes    + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_PLIQUI)
          nTotFret   := nTotFret   + nFrete
          nTotDna    := nTotDna    + nValDna

          nTotCI     := nTotCI     + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
          nTotCIicms := nTotCIicms + nFretIcms
          nFreCI     := nFreCI     + nFrete
          nDnaCI     := nDnaCI     + nValDna

          //REGIAO
          if ALLTRIM(aFre_nf[ x, 7 ])=='CE'
             nTotCE     := nTotCE + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )             
             nTotCEicms := nTotCEicms + nFretIcms
             nFreCE     := nFreCE     + nFrete
             nDnaCE     := nDnaCE     + nValDna
          ElseIf ALLTRIM(aFre_nf[ x, 7 ])=='NE'
             nTotNE     := nTotNE + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
             nTotNEicms := nTotNEicms + nFretIcms
             nFreNE     := nFreNE     + nFrete
             nDnaNE     := nDnaNE     + nValDna
          ElseIf ALLTRIM(aFre_nf[ x, 7 ])=='NO'
             nTotNO     := nTotNO + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
             nTotNOicms := nTotNOicms + nFretIcms
             nFreNO     := nFreNO     + nFrete
             nDnaNO     := nDnaNO     + nValDna
          ElseIf ALLTRIM(aFre_nf[ x, 7 ])=='SD'
             nTotSD     := nTotSD + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
             nTotSDicms := nTotSDicms + nFretIcms
             nFreSD     := nFreSD     + nFrete
             nDnaSD     := nDnaSD     + nValDna
          ElseIf ALLTRIM(aFre_nf[ x, 7 ])=='SL' 
             nTotSL     := nTotSL + Iif( aFre_nf[ x, 5 ] == "R", 0, SF2->F2_VALBRUT )
             nTotSLicms := nTotSLicms + nFretIcms
             nFreSL     := nFreSL     + nFrete
             nDnaSL     := nDnaSL     + nValDna
          Endif
          //
          nLin       := nLin       + 1
          x          := x          + 1

          if x > Len( aFre_nf )
             exit
          endif
          IncRegua()

       enddo

       if nTotal #0 .or. nTotFret # 0 .or. ntotFrIcms # 0

          nLin := nLin + 1

          IF nLin > 55
             //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
             cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 )
             nLin := 9
             
             //SX5->( dbSeek( xFilial( "SX5" ) + "12"+ cEstado, .t. ) )
             @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI ) + " "+Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) )
             @ nLin+2,000 pSay "Transportadora.: " + SA4->A4_NOME                        
          EndIf

          nPerc     := Round( nTotFrIcms*100/nTotDna, 2 )
          @ nLin,00 pSay "Total"
          @ nLin,11 pSay  nTotal     Picture "@E 999,999,999.99"
	      @ nLin,26 pSay  nTotpes    Picture "@E 99,999.99"
          @ nLin,101 pSay nTotFret   Picture "@E 99,999.99"
          @ nLin,112 pSay nTotFrIcms Picture "@E 99,999.99"
          @ nLin,126 pSay nPerc      Picture "@E 99.99"

          nlin := nLin + 2

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

    Enddo

    if nTot #0 .or. nFre # 0 .or. nTotIcms # 0

       nLin := nLin + 1                             

       IF nLin > 55
          //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 )
          nLin := 9
           //SX5->( dbSeek( xFilial( "SX5" ) + "12"+ cEstado, .t. ) )
          @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI )
          @ nLin+2,000 pSay "Transportadora.: " + SA4->A4_NOME
       EndIf

       nPerc     := Round( nTotIcms*100/nDna, 2 )

       @ nLin,00  pSay "Total "+Iif( Substr( cEstado, 3, 1 )=="C"," Capital",Iif( Substr( cEstado, 3, 1 )=="I"," Interior"," Outros" ) )
       @ nLin,11  pSay  nTot      Picture "@E 999,999,999.99"
       @ nLin,101 pSay nFre       Picture "@E 99,999.99"
       @ nLin,112 pSay nTotIcms   Picture "@E 99,999.99"
       @ nLin,126 pSay nPerc      Picture "@E 99.99"

       nlin := nLin + 2
       nTotG     := nTotG     + nTot
       nTotGIcms := nTotGIcms + nTotIcms
       nFreG     := nFreG     + nFre
       nDnaG     := nDnaG     + nDna
       nTot      := nFre := nTotIcms := nDna := 0

      if Substr( cEstado, 3, 1 ) == "C"
       nLin += 1
         @ nLin,000 pSay PadC('-------------------------------------', 132 ) //Aqui
         nLin += 1
      endif



    endif

    if x > Len( aFre_nf ) .or. ( nTotCI #0 .or. nFreCI # 0 .or. nFreCI # 0 ) .and. cEstCI # Substr( aFre_nf[ x, 6 ], 1, 2 )

       nLin := nLin + 1

       IF nLin > 55
          //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 )
          nLin := 9
          @ nLin,000   pSay "Estado.: " + Alltrim( SX5->X5_DESCRI )
          @ nLin+2,000 pSay "Transportadora.: " + SA4->A4_NOME
       EndIf

       nPerc     := Round( nTotCIicms*100/nDnaCI, 2 )
       @ nLin,000 pSay "Total do Estado"
       @ nLin,011 pSay nTotCI     Picture "@E 999,999,999.99"
       @ nLin,101 pSay nFreCI     Picture "@E 99,999.99"
       @ nLin,112 pSay nTotCIicms Picture "@E 99,999.99"
       @ nLin,126 pSay nPerc      Picture "@E 99.99"
       nLin += 1
       @ nLin,000 pSay Replicate('-', 132 ) //Aqui
       nlin := nLin + 2
       nTotCI := nFreCI := nTotCIicms := nDnaCI := 0
       if x <= Len( aFre_nf )
          cEstCi  := Substr( aFre_nf[ x, 6 ], 1, 2 )
       endif
                          /**/
    endif

    if x <= Len( aFre_nf )
       cEstado := aFre_nf[ x, 6 ]
       ctransp := aFre_nf[ x, 1 ]
       cEstCi  := Substr( aFre_nf[ x, 6 ], 1, 2 )

       if nLin > 55
          //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) + 2
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15 ) 
          nLin := 9
       endif
    endif 
 
    x := x - 1
    
Next

IF nLin > 55
   //nLin := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
   cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
   nLin := 9
	 //if nLin == 7
	   //nLin += 1
	 //endif
EndIF
if len(aFre_nf) > 0

	@ nLin,00  pSay "Geral ==>"
	
	nPerc := Round( nTotGIcms*100/nDnaG, 2 )
	
	@ nLin,18  pSay nTotG     Picture "@E 999,999,999.99"
	@ nLin,101 pSay nFreG     Picture "@E 999,999.99"
	@ nLin,113 pSay nTotGIcms Picture "@E 999,999.99"
	@ nLin,128 pSay nPerc     Picture "@E 99.99"
    
    nLin+=2
    @ nLin++,00 pSay "--Regiao--"+replicate("-",122)
    @ nLin,00  pSay "Centro-Oeste ==>"	
	nPercCE := Round( nTotCEIcms*100/nDnaCE, 2 )
	@ nLin,18  pSay nTotCE     Picture "@E 999,999,999.99"
	@ nLin,101 pSay nFreCE     Picture "@E 999,999.99"
	@ nLin,113 pSay nTotCEIcms Picture "@E 999,999.99"  
	@ nLin,128 pSay nPercCE     Picture "@E 99.99"
	nLin++
    @ nLin,00  pSay "Nordeste     ==>"	
	nPercNE := Round( nTotNEIcms*100/nDnaNE, 2 )
	@ nLin,18  pSay nTotNE     Picture "@E 999,999,999.99"
	@ nLin,101 pSay nFreNE     Picture "@E 999,999.99"
	@ nLin,113 pSay nTotNEIcms Picture "@E 999,999.99" 
	@ nLin,128 pSay nPercNE     Picture "@E 99.99"
	nLin++
    @ nLin,00  pSay "Norte        ==>"	
	nPercNO := Round( nTotNOIcms*100/nDnaNO, 2 )
	@ nLin,18  pSay nTotNO     Picture "@E 999,999,999.99"
	@ nLin,101 pSay nFreNO     Picture "@E 999,999.99"
	@ nLin,113 pSay nTotNOIcms Picture "@E 999,999.99"
	@ nLin,128 pSay nPercNO     Picture "@E 99.99"
	nLin++
    @ nLin,00  pSay "Sudeste      ==>"	
	nPercSD := Round( nTotSDIcms*100/nDnaSD, 2 )
	@ nLin,18  pSay nTotSD     Picture "@E 999,999,999.99"
	@ nLin,101 pSay nFreSD     Picture "@E 999,999.99"
	@ nLin,113 pSay nTotSDIcms Picture "@E 999,999.99"
	@ nLin,128 pSay nPercSD     Picture "@E 99.99"
	nLin++
    @ nLin,00  pSay "Sul          ==>"	
	nPercSL := Round( nTotSLIcms*100/nDnaSL, 2 )
	@ nLin,18  pSay nTotSL     Picture "@E 999,999,999.99"
	@ nLin,101 pSay nFreSL     Picture "@E 999,999.99"
	@ nLin,113 pSay nTotSLIcms Picture "@E 999,999.99"
	@ nLin++,128 pSay nPercSL     Picture "@E 99.99"
	@ nLin,00  pSay replicate("-",132)

endIf
//roda(cbcont,cbtxt,tamanho)

dbSelectArea("SF2")

If aReturn[5] == 1
   dbCommitAll()
   ourspool(wnrel)
Endif

RetIndex( "SD2" )
Return(.T.)

***************

Static Function tipos(cNota)

***************
Local cQuery := ""
Local lValid := .F.
cQuery := " select count(*) TOTAL "
cQuery += " from  "+retSqlName("SF2")+" SF2, "+retSqlName("SD2")+" SD2, "+retSqlName("SF4")+" SF4 "
cQuery += " where F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery += " and D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery += " and F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery += " and F2_DOC = '"+cNota+"' and F2_TIPO = 'N' "
cQuery += " and D2_DOC = F2_DOC and F4_CODIGO = D2_TES "
cQuery += " and F4_DUPLIC = '" + iif( mv_par07 == 1, 'S', 'N') + "' "
iif( mv_par07 == 3, cQuery += "and F4_CODIGO in ('507','516') ", )
cQuery += " and SF2.D_E_L_E_T_ <> '*' "
cQuery += " and SD2.D_E_L_E_T_ <> '*' "
cQuery += " and SF4.D_E_L_E_T_ <> '*' "
//MemoWrite("C:\TIPOSNF.SQL",cQuery )

TCQUERY cQuery NEW ALIAS "_TMPZ"  
_TMPZ->( dbGoTop() )
if _TMPZ->TOTAL > 0
   lValid := .T.
endIf
_TMPZ->( dbCloseArea() )
Return lValid    



***************

Static Function getReg(cUF)

***************

Local cRGNO := "AC AM AP PA RO RR TO"
Local cRGNE := "MA PI CE RN PB PE AL BA SE"
Local cRGCE := "GO MT MS DF"
Local cRGSD := "MG ES RJ SP"
Local cRGSL := "RS PR SC"

if cUF $ cRGNO
	return "NO"
elseIf cUF $ cRGNE
	return "NE"
elseIf cUF $ cRGCE
	return "CE"
elseIf cUF $ cRGSD
	return "SD"	
elseIf cUF $ cRGSL
	return "SL"				
endIf	
   
Return 










