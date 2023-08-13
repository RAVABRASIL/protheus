#include "rwmake.ch"
#INCLUDE "Topconn.CH"

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATPFI()

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NMIDIA,AMES")
SetPrvt("NI,CANO,NREG,ADIA,NDIA,NDIASSAC,NVALORT,LCOND")
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
±±³  Autor  ³ Ana M B Alencar                          ³ Data ³ 22/03/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Posicao Vendas                                             ³±±
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
nVALORT := nPESOT := nDIAST := nDIAXVLT := nNOTAST := 0


Do While ! SF2->( eof() ) .And. StrZero( Month( F2_EMISSAO ), 2 ) == MV_PAR01

   dDATA  := SF2->F2_EMISSAO
   nTOTACE := nVALOR := nPESO := nDIAS := nDIAXVL := nNOTAS := 0

   do While ! SF2->( eof() ) .And. SF2->F2_EMISSAO == dDATA .And. StrZero( Month( F2_EMISSAO ), 2 ) == MV_PAR01

      If ! Empty( SF2->F2_DUPL )

         nQtdKg := 0
         _nTOTA := nVALZIP := nVALCUR := nVALABR1 := nVALABR2 := nVALABRA3 := nVALETQ := nVALFEC := 0

         SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
				 lCond := .F.
         if SD2->D2_CF $ "511  /5101 /611  /6101 /512 /5102 /612  /6102 /6109 /6107 /5949 /6949 "

        	do while SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !eof() )

        	 	 nVALOR := nVALOR + SD2->D2_TOTAL

        	 	 SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
        	 	 nQtdKg := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )

        	 	 if Subs( Alltrim( SD2->D2_TES ), 2, 2 ) # "99" .and. !empty( SD2->D2_SERIE )

        	 		   if AllTrim( SD2->D2_COD ) $"CTG001/CDTG0601/CTG002/CDTG0602/CTG003/CDTG0603/CTG004/CDTG0604/CTG005/CDTG0605/"+;
        	 		                             "CTG006/CDTG0606/CTG007/CDTG0607/CTG008/CDTG0608/CTG009/CDTG0609/CTG010/CDTG0610/"+;
        	 		                             "CAA002/CDAA0602/CAF002/CDAF0602/CAE002/CDAE0602/CAD002/CDAD0602/"+;
        	 		                             "CKZ015/CDKZ0615/CGZ050/CDGZ0650/CKB417/CDKB4617/CIB432/CDIB4632/"+;
        	 		                             "CGB452/CDGB4652/CDB498/CDDB4698/CAB420/CDAB4620/CKB418/CDKB4618/"+;
        	 		                             "CIB433/CDIB4633/CGB453/CDGB4653/CDB499/CDDB4699/CAB430/CDAB4630/"+;
        	 		                             "CKB009/CDKB0609/CKB012/CDKB0612/CAA001/CDAA0601/CAF001/CDAF0601/"+;
        	 		                             "CAE001/CDAE0601/CKB315/CDKB3615/CGB350/CDGB3650/CKZ015/CDKZ0615/"+;
        	 		                             "CGZ050/CDGZ0650/CEB136/CDEB1636/CEB130/CDEB1630/CAD001/CDAD0601/"+;
																					 "CTG011/CDTG0611"

        	 		     //ZIPER
    	  	 		     SB1->( dbSeek( xFilial( "SB1" ) + "AC0001" ) )
       		 		    nVALZIP := SB1->B1_UPRC

        	 		     //CURSOR
	      	 		    SB1->( dbSeek( xFilial( "SB1" ) + "AC0002" ) )
       		 		    nVALCUR := SB1->B1_UPRC

        	 		     //ABRACADEIRA 1
       		 		    SB1->( dbSeek( xFilial( "SB1" ) + "MH0410" ) )
   	    	 		   nVALABR1 := SB1->B1_UPRC / 1000

        	 		     //ABRACADEIRA 2 ( 15cm )
        	 		 	  SB1->( dbSeek( xFilial( "SB1" ) + "MH0411" ) )
   	    	 		   nVALABR2 := SB1->B1_UPRC / 1000

        	 		     //ABRACADEIRA 3 ( 10cm )
        	 		 	  SB1->( dbSeek( xFilial( "SB1" ) + "MH0408" ) )
   	    	 		   nVALABR3 := SB1->B1_UPRC / 1000

        	 		     //ETIQUETAS
       		 		    SB1->( dbSeek( xFilial( "SB1" ) + "ME0106" ) )
   	    	 		   nVALETQ := SB1->B1_UPRC

        	 		     //FECHO
       		 		    SB1->( dbSeek( xFilial( "SB1" ) + "ME0104" ) )
        	 		 	  nVALFEC := round( SB1->B1_UPRC * 0.7, 2 )

        	 		     if AllTrim( SD2->D2_COD ) $ "CTG001/CDTG0601"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALZIP * 1.23 ), 2 ) + nVALCUR + nVALABR1 + nVALETQ

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CTG002/CDTG0602"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALZIP * 2.03 ), 2 ) + nVALCUR + nVALABR1 + nVALETQ

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CTG003/CDTG0603"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALZIP * 2.73 ), 2 ) + nVALCUR + nVALABR1 + nVALETQ

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CTG004/CDTG0604"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALZIP * 2.93 ), 2 ) + nVALCUR + nVALABR1 + nVALETQ

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CTG005/CDTG0605"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALZIP * 3.93 ), 2 ) + nVALCUR + nVALABR1 + nVALETQ

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CTG006/CDTG0606"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALZIP * 0.65 ), 2 ) + nVALCUR + nVALABR1 + nVALETQ

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CTG007/CDTG0607"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALZIP * 1.06 ), 2 ) + nVALCUR + nVALABR1 + nVALETQ

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CTG008/CDTG0608"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALZIP * 1.56 ), 2 ) + nVALCUR + nVALABR1 + nVALETQ

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CTG009/CDTG0609"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALZIP * 2.11 ), 2 ) + nVALCUR + nVALABR1 + nVALETQ

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CTG010/CDTG0610"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALZIP * 2.31 ), 2 ) + nVALCUR + nVALABR1 + nVALETQ

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CTG011/CDTG0611"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALZIP * 4.18 ), 2 ) + nVALCUR + nVALABR1 + nVALETQ

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CAA002/CDAA0602"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALFEC / 1000 ), 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CAF002/CDAF0602"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALFEC / 1000 ), 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CAE002/CDAE0602"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALFEC / 1000 ), 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CAD002/CDAD0602"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALFEC / 1000 ), 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CKB315/CDKB3615"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * ( nVALFEC / 1000 ), 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CGB350/CDGB3650"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR2, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CKZ015/CDKZ0615"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR1, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CGZ050/CDGZ0650"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR1, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CKB417/CDKB4617"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR3, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CIB432/CDIB4632"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR3, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CGB452/CDGB4652"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR3, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CDB498/CDDB4698"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR3, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CAB420/CDAB4620"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR2, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CKB418/CDKB4618"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR3, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CIB433/CDIB4633"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR3, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CGB453/CDGB4653"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR3, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CDB499/CDDB4699"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR3, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CAB430/CDAB4630"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR2, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CKB009/CDKB0609"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR1, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CKB012/CDKB0612"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR1, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CAA001/CDAA0601"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR2, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CAF001/CDAF0601"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR2, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CAE001/CDAE0601"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR2, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CKB315/CDKB3615"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR2, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CGB350/CDGB3650"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR2, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CGZ050/CDGZ0650"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR2, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CEB136/CDEB1636"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR3, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CEB130/CDEB1630"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR3, 2 )

        	 		     elseif AllTrim( SD2->D2_COD ) $ "CAD001/CDAD0601"

        	 		        _nTOTA := Round( ( SD2->D2_QUANT * 1000 ) * nVALABR2, 2 )

        	 		     EndIf

        	 		     nTOTACE := nTOTACE + _nTOTA

        	 		  EndIf

        	 	 EndIf

        	 	 SD2->( dbSkip() )

        	enddo

         endif

         nPESO   := nPESO   + nQtdKg
       	 nDIAS   := nDIAS   + SF2->F2_VALMERC
         nDIAXVL := nDIAXVL + ( IIf( SE4->( DbSeek( xFILIAL( 'SE4' ) + SF2->F2_COND ) ), SE4->E4_PRZMED, 0 ) * SF2->F2_VALMERC ) //Aqui esta sendo totalizado os valores de todas as notas
         //nNOTAS  := nNOTAS  + IIf(SF2->F2_SERIE=="UNI".OR.(Empty(SF2->F2_SERIE).and.'VD' $ SF2->F2_VEND1),1,0)					 //e todos os prazos, segundo a formula. somat(prazo * valor da nota)
         nNOTAS  := nNOTAS  + IIf(SF2->F2_SERIE $ "UNI/0  ".OR.(Empty(SF2->F2_SERIE).and.'VD' $ SF2->F2_VEND1),1,0)					 //e todos os prazos, segundo a formula. somat(prazo * valor da nota)

      EndIf

      SF2->( DbSkip() )
      IncRegua()

   Enddo

   If ! Empty( nVALOR )

      nVALOR := nVALOR - nTOTACE //Valor total das notas sem acessorios
      nDIA     := nDIA + 1
      Aadd( aDIA, { StrZero( nDIA, 2 ), dDATA, nVALOR, nPESO, nDIAS, nDIAXVL, nNOTAS, nTOTACE } )
      nVALORT  := nVALORT  + nVALOR
      nPESOT   := nPESOT   + nPESO
      nDIAST   := nDIAST   + nDIAS
      nDIAXVLT := nDIAXVLT + nDIAXVL
      nNOTAST  := nNOTAST  + nNOTAS

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
   nLIN := cabec( cTITULO, cDESC1, cDESC2, cNOMREL, cTAMANHO, cCARACTER )
   @ PRow()+1, 00     pSay Repl( "*", 132 )
   @ PRow()+1, 00     pSay "N§   --Data--   Fatur. Dia  Desp.Aces   Fatur.Acum.    %Ating.    Ideal_Acum.    Tenden.    Fator    Margem    Pz.Md.    N.NT."
                      //    99   99/99/99   999.999,99  99.999,99   9999.999,99     999,99    9999.999,99     999.99   99,999    999,99      99      9.999
                      //    0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
                      //    0         1         2         3         4         5         6         7         8         9         1         2
   @ PRow()+1, 00     pSay Repl( "*", 132 )

   For nCONTI := 1 To Len( aADEDS )

      nPESO   := aADEDS[nCONTI,4]
      nVALOR  := aADEDS[nCONTI,3]

      If MV_PAR04 == 1

         nVALACUM := nVALACUM + aADEDS[nCONTI,3]
         nPATING  := Round( (nVALACUM/MV_PAR02)*100, 2 )
         nTENDEN  := Round( (((nVALACUM/Val(aADEDS[nCONTI,1]))*MV_PAR03)/MV_PAR02)*100, 2 )
         nVAL     := nVALOR

      Else

         nVALACUM := nVALACUM + aADEDS[nCONTI,4]
         nPATING  := Round( (nVALACUM/nPESOT)*100, 2 )
         nTENDEN  := Round( (((nVALACUM/Val(aADEDS[nCONTI,1]))*MV_PAR03)/MV_PAR02)*100, 2 )
         nVAL     := nPESO

      EndIf

      nIDEAL  := Round( (MV_PAR02/MV_PAR03)*Val(aADEDS[nCONTI,1]), 2 )
      nFATOR  := Round( nVALOR/nPESO, 3 )
      nMARGEM := Round( (nFATOR*100/MV_PAR05) - 100, 2 )
  	nPRZMED := Round( aADEDS[nCONTI,6]/aADEDS[nCONTI,5], 0)
		nDIATOT := nDIATOT + nPRZMED

      @ PRow()+1,00       pSay aADEDS[nCONTI,1]
      @ PRow()  ,PCol()+3 pSay aADEDS[nCONTI,2]
      @ PRow()  ,PCol()+3 pSay nVAL              Picture "@E 999,999.99"
      @ PRow()  ,PCol()+2 pSay aADEDS[nCONTI,8]  Picture "@E 99,999.99"//Incluido por Eurivan
      @ PRow()  ,PCol()+3 pSay nVALACUM          Picture "@E 9999,999.99"
      @ PRow()  ,PCol()+5 pSay nPATING           Picture "@E 999.99"
      @ PRow()  ,PCol()+4 pSay nIDEAL            Picture "@E 9999,999.99"
      @ PRow()  ,PCol()+5 pSay nTENDEN           Picture "@E 999.99"
      @ PRow()  ,PCol()+4 pSay nFATOR            Picture "@E 99.999"
      @ PRow()  ,PCol()+4 pSay nMARGEM           Picture "@E 999.99"
      @ PRow()  ,PCol()+6 pSay nPRZMED           Picture "@E 99"
      @ PRow()  ,PCol()+6 pSay aADEDS[nCONTI,7]  Picture "@E 9,999"

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
	@ PRow()  ,114 pSay TransForm( Round( nPZTot / nVALACUM, 0 ), "@E 999" )
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
	//cCart += "SC5.C5_EMISSAO BETWEEN ' ' AND '20100818' AND "
	//cCart += "SC6.C6_PRODUTO BETWEEN ' ' AND 'ZZZZZZZZZ' AND "
	cCart += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
	cCart += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
	cCart += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' "
	cCart := ChangeQuery( cCart )
	TCQUERY cCart NEW ALIAS "CARX"

	nCartKG := CARX->CARTEIRA_KG
	nCartRS := CARX->CARTEIRA_RS

	CARX->( DbCloseArea() )

Return //nCartKG, nCartRS
