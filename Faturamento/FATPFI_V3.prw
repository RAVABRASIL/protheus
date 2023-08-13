#include "rwmake.ch"
#INCLUDE "Topconn.CH"
#INCLUDE "fivewin.CH"

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function FATPFIV3()

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NMIDIA,AMES"      )
SetPrvt("NI,CANO,NREG,ADIA,NDIA,NDIASSAC,NVALORT,NPRZMDT")
SetPrvt("NPESOT,NDIAST,NDIAXVLT,NNOTAST,DDATA,NTOTZC"    )
SetPrvt("NVALZIP,NVALCUR,NVALOR,NPESO,NDIAS,NDIAXVL"     )
SetPrvt("NNOTAS,NQTDKG,NREGTOT,AADEDS,CTAMANHO,CCARACTER")
SetPrvt("M_PAG,NVALACUM,NLIN,NCONTI,NPATING,NTENDEN"     )
SetPrvt("NVAL,NIDEAL,NFATOR,NMARGEM,NPRZMED,NFATDIA"     )
SetPrvt("CTEXTO,NDIATOT,nCartKG,nCartRS,nTot,nTotTot,nTotPeso,nTotVal,nAcCar")
SetPrvt("dDatMax,nAcctr,aArct,nPRZMT,nCartPR,nCartIM,nAcePR,nAceIM,nCartPRK,nCartIMK,nBonific")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Ana B. Alencar                           ³ Data ³ 15/06/07 ³±±
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
cNOMREL  := "FATPFIV3"
cTITULO  := "Posicao Vendas v3.0 - "
nLASTKEY := 0
nBonific := 0
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

if MV_PAR07 = 1 .and. mv_par10 == 4
   cTitulo := Alltrim(cTitulo)+" Linha Hospitalar - "
elseif MV_PAR07 = 2 .and. mv_par10 == 4
   cTitulo := Alltrim(cTitulo)+" Linha Domestitca - "
elseif MV_PAR07 = 3 .and. mv_par10 == 4
   cTitulo := Alltrim(cTitulo)+" Linha Institucio.- "
elseif MV_PAR07 = 4 .and. mv_par10 == 4
   cTitulo := Alltrim(cTitulo)+" Todas as Linhas  - "
elseif mv_par10 == 1
   cTitulo := Alltrim(cTitulo)+" Inst./Dom.-Brasil- "
   MV_PAR07 = 5
   mv_par08 := ""
   mv_par09 := ""
elseif mv_par10 == 2
   cTitulo := Alltrim(cTitulo)+" Hospitalar só SP - "
   MV_PAR07 = 1
   mv_par08 := "SP"//só SP
   mv_par09 := ""
elseif mv_par10 == 3
   cTitulo := Alltrim(cTitulo)+" Hosp/Brasil Sem SP- "
   MV_PAR07 = 1
   mv_par08 := ""
   mv_par09 := "SP"//tudo, menos SP
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  de variaveis                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aMES := { 'Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro',;
'Novembro', 'Dezembro' }

For nI := 1 To 12

	cANO := StrZero( Year( dDATABASE ), 4 )
	aMES[nI] := aMES[nI] + "/" + cANO

Next

//colocado em 04/03/09 chamado 000944
cTITULO   := cTITULO + aMES[Val(MV_PAR01)]
cTITULO   := cTITULO + IIf( MV_PAR04 == 1, ' - Em R$ - ', ' - Em Kg - ' )

dbselectarea( 'SD2' )
SD2->( dbsetorder( 3 ) )

dbselectarea( 'SB1' )
SB1->( dbsetorder( 1 ) )

dbselectarea( 'SE4' )
SE4->( dbsetorder( 1 ) )

dbselectarea( 'SF2' )
SF2->( dbsetorder( 9 ) ) //Alterado de 7 para 8 na migracao AP8

/*if !empty(MV_PAR08)
	Set Filter To SF2->F2_FILIAL = xFilial("SF2") .AND. SF2->F2_EST = MV_PAR08
endIf*/
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	Set Filter To SF2->F2_FILIAL = xFilial("SF2") .AND. SF2->F2_EST  = MV_PAR08
    cTitulo +="So a UF: "+MV_PAR08+" - "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	Set Filter To SF2->F2_FILIAL = xFilial("SF2") .AND. SF2->F2_EST != MV_PAR09
    cTitulo +="Menos a UF: "+MV_PAR09+" - "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	Set Filter To SF2->F2_FILIAL = xFilial("SF2") .AND. SF2->F2_EST  = MV_PAR08 .AND. SF2->F2_EST != MV_PAR09
endIf

If !empty(MV_PAR11)
   cTitulo +=alltrim(MV_PAR11)+" - "+posicione("SA3",1,xFilial('SA3') + MV_PAR11,"A3_NREDUZ") 
   Set Filter To SF2->F2_FILIAL = xFilial("SF2") .AND. ALLTRIM(SF2->F2_VEND1) $ ALLTRIM(MV_PAR11)+"/"+ALLTRIM(MV_PAR11)+"VD" 
endif             


SF2->( DbSeeK( xFILIAL('SF2') + DtoS( CtoD( '01/'+MV_PAR01+'/'+Right(StrZero(Year(dDATABASE),4),2) ) ), .T. ) )
nREG := SF2->( RecNo() )
Count To nREGTOT While StrZero( Month( F2_EMISSAO ), 2 ) == MV_PAR01
SF2->( DbGoTo( nREG ) )
SetRegua( nREGTOT )

aDIA := {}   
aADEDS := {}
nDIASSAC := nDIA := 0
nPRZMDT := nVALORT := nPESOT := nDIAST := nDIAXVLT := nNOTAST := 0
nTotTot := nCartIMR :=  nAceIM := nCartIMK := 0
nVALACUM  := 0

Do While ! SF2->( eof() ) .And. StrZero( Month( F2_EMISSAO ), 2 ) == MV_PAR01 .AND. SF2->F2_EMISSAO <= dDataBase


	dDATA  := SF2->F2_EMISSAO
	nPRZMD := nTOTACE := nVALOR := nPESO := nDIAS := nDIAXVL := nNOTAS :=nTOTDES:= 0
	Do While ! SF2->( eof() ) .And. SF2->F2_EMISSAO == dDATA .And. StrZero( Month( F2_EMISSAO ), 2 ) == MV_PAR01

		If ( ! Empty( SF2->F2_DUPL ) )
			nTTSD2 := 0 //incluido em 13/10/06 total por nota pelo SD2
			nQtdKg := 0
			_nTOTA := nVALZIP := nVALCUR := nVALABR1 := nVALABR2 := nVALABRA3 := nVALETQ := nVALFEC := 0
            lConta := .F.

			//desconto
			nTOTDES+= Descon( SF2->F2_DOC) 
			//
			
			SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
		  
			
			/*if SD2->D2_TES = '514'
		    	if mv_par04 == 1
	            	nBonific += SD2->D2_TOTAL
	        	else
	        		nBonific += IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )
	        	endIf
	      	endIf*/
			If (SD2->D2_CF $ "511  /5101 /5107 /611  /6101 /512 /5102 /612  /6102 /6109 /6107 /5949 /6949 ")
                                                                                                                //Remessa MIXKIT,AMOSTRA
				Do while SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE .and. SD2->( !eof() ) .and. !ALLTRIM(SD2->D2_TES) $ '540/516'

                   // tira o que e CAIXA 
		           SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
	               If SB1->B1_SETOR=='39' //CAIXA 
               	      SD2->( dbSkip() )	
               		  Loop
	               Endif
	               //
                    
                    if MV_PAR07 = 1
                       //Senao for do Grupo Hospitalar
      			        if !Alltrim(SD2->D2_GRUPO) $ "C"
   	     		           SD2->(DbSkip())
      			           Loop
     			        endif
     			     /*elseif MV_PAR07 = 2   
                       //Senao for do Grupo Linha Domestica /Institucional /etc..
     			        if !Alltrim(SD2->D2_GRUPO) $ "A/B/D/E/F/G/H/I"
   	    		           SD2->(DbSkip())
   		    	           Loop
   			            endif*/
					 elseif MV_PAR07 = 2
                       //Senao for do Grupo Linha Domestica
     			        if !Alltrim(SD2->D2_GRUPO) $ "D/E"
   	    		           SD2->(DbSkip())
   		    	           Loop
   			            endif
					 elseif MV_PAR07 = 3
                       	//Se não for do Grupo Linha Institucional, Lanche e Sacola
                       	//A pedido de Janderley em 13/10/2008, ainda sem chamado
     			        if !Alltrim(SD2->D2_GRUPO) $ "A/B/F/G"
   	    		           SD2->(DbSkip())
   		    	           Loop
   			            endif
   					 elseif MV_PAR07 = 5
   					 	//Institucional, Lanche, Sacola e Doméstica 05/03/09
   					    if !Alltrim(SD2->D2_GRUPO) $ "A/B/D/E/F/G"
   	    		           SD2->(DbSkip())
   		    	           Loop
   			            endif   					 
   			         endif
                     /*if !lConta
                        lConta := .T.
                     endif*/                  
					 If MV_PAR06 == 1 .AND. substr(SD2->D2_COD,1,1) != 'M' //INCLUINDO AS APARAS MV_PAR06
					    /*if SD2->D2_TES = '514'
					    	if mv_par04 == 1
		             			nBonific += SD2->D2_TOTAL
		        			else
		        				nBonific += IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )
		        			endIf
                     	endIf*/
						nVALOR := nVALOR + SD2->D2_TOTAL
						SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
						nQtdKg := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )
                        nAC := 0
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
						If SD2->D2_TES == "541"
							nTOTACE += 0.23 * SD2->D2_TOTAL
							nAC     := 0.23 * SD2->D2_TOTAL
						endIf

						SD2->( dbSkip() ) //SKIP AQUI!

					  ElseIf (MV_PAR06 == 2) .AND. !(alltrim(SD2->D2_COD) $ "187  /188  /189  /190 /200 /210 ") .AND. substr(SD2->D2_COD,1,1) != 'M' //EXCLUINDO AS APARAS MV_PAR06
					    if !lConta
                           lConta := .T.
                        endif
					    /*if SD2->D2_TES = '514'
					    	if mv_par04 == 1
		             			nBonific += SD2->D2_TOTAL
		        			else
		        				nBonific += IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) )
		        			endIf
                     	endIf*/
						nVALOR := nVALOR + SD2->D2_TOTAL
						SB1->( dbSeek( xFilial( "SB1" ) + SD2->D2_COD ) )
						nQtdKg := nQtdKg + IIf( Empty( SD2->D2_SERIE ) .and. !'VD' $ SF2->F2_VEND1, 0, ( SD2->D2_QUANT * SB1->B1_PESOR ) ) //retirado para checagem do erro da media de peso dia 28/12/06
                        nAC := 0
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
						If SD2->D2_TES == "541"
							nTOTACE += 0.23 * SD2->D2_TOTAL
							nAC     := 0.23 * SD2->D2_TOTAL
						endIf

						SD2->( dbSkip() ) //SKIP AQUI

					Else//nunca sera executado
						SD2->( dbSkip() )//SKIP AQUI!

					EndIf//fim dos ifs (hospitalar/limpeza ou brasileirinho/sem acessorio, nesta ordem)

				Enddo
               if lConta
     			   nPESO   += nQtdKg
    			   nDIAS   += SF2->F2_VALMERC //Variavel obsoleta
   	    		   //nDIAXVL := nDIAXVL + ( IIf( SE4->( DbSeek( xFILIAL( 'SE4' ) + SF2->F2_COND ) ), SE4->E4_PRZMED, 0 ) * SF2->F2_VALMERC ) //Aqui esta sendo totalizado os valores de todas as notas
    			  // nNOTAS += IIf(SF2->F2_SERIE=="UNI".OR.(Empty(SF2->F2_SERIE).and.'VD' $ SF2->F2_VEND1),1,0)					 //e todos os prazos, segundo a formula. somat(prazo * valor da nota)
    			     nNOTAS += IIf(SF2->F2_SERIE $ "UNI/0  ".OR.(Empty(SF2->F2_SERIE).and.'VD' $ SF2->F2_VEND1),1,0)					 //e todos os prazos, segundo a formula. somat(prazo * valor da nota)
    			   //comentado em 27/02/08 por Eurivan
	    		   //nPRZMD  += nTTSD2//inserido em 09/10/06, modf 13/10/06	
    			   //nDIAXVL += (IIf( SE4->( DbSeek( xFILIAL( 'SE4' ) + SF2->F2_COND ) ), SE4->E4_PRZMED, 0 ) * nTTSD2) //inserido em 09/10/06, modf 13/10/06
	    		   //formula >> nDIAXVL/nPRZMD
    			  // nPRZMD += IIf(SF2->F2_SERIE=="UNI".OR.(Empty(SF2->F2_SERIE).and.'VD' $ SF2->F2_VEND1),U_GetPrzM(),0)
               nPRZMD += IIf(SF2->F2_SERIE $ "UNI/0  ".OR.(Empty(SF2->F2_SERIE).and.'VD' $ SF2->F2_VEND1),U_GetPrzM(),0)
               endif
			Endif

		EndIf

		SF2->( DbSkip() )
		IncRegua()

	EndDo

	If ! Empty( nVALOR )

		nVALOR := nVALOR - nTOTACE - nTOTDES //Valor total das notas sem acessorios (cada nota) E com desconto
		nDIA     := nDIA + 1
		Aadd( aDIA, { StrZero( nDIA, 2 ), dDATA, nVALOR, nPESO, nDIAS, nDIAXVL, nNOTAS, nTOTACE, nPRZMD,nTOTDES } )//nPRZMD inserido em 09/10/06
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
	
	// retirado em 04/03/09 chamado  000944
	//cTITULO   := cTITULO + aMES[Val(MV_PAR01)]
	//cTITULO   := cTITULO + IIf( MV_PAR04 == 1, ' - Em R$', ' - Em Kg' )
	
	nVALACUM  := 0
	nVALAC2   := 0 //07/10/06 inserido

	nLIN := cabec( cTITULO, cDESC1, cDESC2, cNOMREL, cTAMANHO, cCARACTER )
	@ PRow()+1, 00     pSay Repl( "*", 132 )
	@ PRow()+1, 00     pSay "N§   --Data--   Fatur. Dia  Desp.Aces   Abatimento  Fatur.Acum.    %Ating.    Ideal_Acum.    Tenden.    Fator    Margem    Pz.Md.    "
	                   //    99   99/99/99   999.999,99  99.999,99   9999.999,99     999,99    9999.999,99     999.99   99,999    999,99      99      9.999
	                   //    123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
	                   //             1         2         3         4         5         6         7         8         9         1         2
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
			@ PRow()  ,PCol()+2 pSay aADEDS[nCONTI,8]  Picture "@E 99,999.99"  // Incluido por Eurivan
			@ PRow()  ,PCol()+2 pSay aADEDS[nCONTI,10]  Picture "@E 99,999.99" // Desconto
		Else
			@ PRow()  ,PCol()+2 pSay " --- "
		    @ PRow()  ,PCol()+2 pSay space(7)+" --- "
		EndIf
		@ PRow()  ,PCol()+3 pSay nVALACUM          Picture "@E 9999,999.99"
		@ PRow()  ,PCol()+5 pSay nPATING           Picture "@E 999.99"
		@ PRow()  ,PCol()+4 pSay nIDEAL            Picture "@E 9999,999.99"
		@ PRow()  ,PCol()+5 pSay nTENDEN           Picture "@E 999.99"
		@ PRow()  ,PCol()+4 pSay nFATOR            Picture "@E 99.999"
		@ PRow()  ,PCol()+4 pSay nMARGEM           Picture "@E 999.99"
		@ PRow()  ,PCol()+6 pSay nPRZMED           Picture "@E 99"
		//@ PRow()  ,PCol()+6 pSay aADEDS[nCONTI,7]  Picture "@E 9,999"

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
	@ PRow()+2,00       pSay cTEXTO+space(6) + IIf( ! Empty( nVAL ), TransForm( nVAL, '@E 9,999,999.99' ), Space(10) )
	nVAL := Round( nVALACUM/Val( aADEDS[nCONTI,1]), 2 )
	@ PRow()  ,PCol()+4 pSay "Fat.Med  " +space(9) +TransForm( nVAL, '@E 9,999,999.99' )
	@ PRow()  ,PCol()+4 pSay StrZero(Val(aADEDS[nCONTI,1])+1, 2 ) + "§ Dia"
	nVAL := Round( ( MV_PAR02 - nVALACUM ) / ( MV_PAR03 - Val(aADEDS[nCONTI,1]) ), 2 )
	@ PRow()  ,PCol()+4 pSay space(3)+"Fat.Dia  " + TransForm( nVAL, "@E 9,999,999.99" )
	//  @ PRow()  ,PCol()+5 pSay "Fat.Dia  " + TransForm( (MV_PAR02/MV_PAR03) + nPREV, "@E 9,999,999.99" ) //Modificado para linha anterior por orientacao de Sr. Viana
	nVAL := Round( nVALORT/nPESOT, 2 )//fator
	
   	@ PRow()  ,104      pSay TransForm( nVAL, "@E 99.999" )
               //92
   /*03/12/07*/
	           //102
	@ PRow()  ,114      pSay TransForm( ( ( nVAL/mv_par05 ) * 100 ) - 100, "@E 999.99" )
	
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
   @ PRow()  ,124 pSay TransForm( nPRZMT, "@E 999" )
              //113
//	if MV_PAR04 == 1
//		@ PRow()  ,113 pSay TransForm( Round( nPZTot / nVALACUM, 0 ), "@E 999" )
//	else
//		@ PRow()  ,113 pSay TransForm( Round( nPZTot / nVALAC2, 0 ), "@E 999" )
//	endif
   
	/*18/10/06*/
   
   //@ PRow()  ,123 pSay TransForm( nNOTAST, "@E 9999" )

EndIf


Carteira(.F.,1)
nCartPRR := nCartRS
nCartPRK := nCartKG

nAcCar := acsCart(.F.,1)
nAcePR := nAcCar
@ PRow() + 3 ,046 pSay "CARTEIRA PROGRAM.  " + IiF( mv_par04 == 1, "RS " + TransForm( nCartPRR - nAcePR, '@E 9,999,999.99' ), TransForm( nCartPRK, '@E 9,999,999.99' ) + " KG" )

iif(nCartKG  > 0,nFatCart := (nCartRS - nAcCar)/nCartKG, nFatCart := 0 )
@ PRow() ,091 pSay  TransForm( nFatCart, '@E 999.999' )
iif(nFatCart > 0,nMarCart := Round( (nFatCart*100/MV_PAR05) - 100, 2 ),nMarCart := 0 )
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

if mv_par04 == 1
   nTotTot := nVALACUM + (nCartIMR - nAceIM)
else
   nTotTot := nVALACUM + nCartIMK
endif   
                                                                                                                                     
nTotPeso := 0
nTotVal  := 0

for X := 1 to len( aADEDS )
	nTotPeso += aADEDS[X,4]
	nTotVal	 += aADEDS[X,3]
next

//nFatTot  := ( nTotVal + ((nCartIMR+nCartPRR) - (nAceIM+nAcePR)) ) / ( nTotPeso + nCartIMK+nCartPRK ) 08/05/08
nFatTot  := ( nTotVal + ((nCartIMR) - (nAceIM)) ) / ( nTotPeso + nCartIMK )

/* INSERIDO EM 27/02/09 CHAMADO 000924 */
nBonific := iif(mv_par04 == 1,bonifica()[1],bonifica()[2] )
@ Prow() + 2 ,046 PSay "BONIFICAÇÕES       " + iif(mv_par04 == 1, "RS ", "KG " ) +;
				  transform( nBonific, '@E 9,999,999.99' ) + "     " + transform( ( nBonific / nTotTot ) * 100, '@E 9,999,999.99' )+"%"
/* FIM 000924 */

@ PRow() + 2 ,046 pSay "TOTAL GERAL        " + IiF( mv_par04 == 1, "RS " + TransForm( nTotTot, '@E 9,999,999.99' ), TransForm( nTotTot, '@E 9,999,999.99' ) + " KG"  )
@ PRow() ,091 pSay  TransForm( nFatTot, '@E 999.999' )
nMarTot := Round( (nFatTot*100/MV_PAR05) - 100, 2 )
@ PRow() ,102 pSay  TransForm( nMarTot, '@E 999.99' )

If empty(MV_PAR11)
   @ PRow() + 2 ,046 pSay "META NO MÊS   " + IiF( mv_par04 == 1, "RS  ", "KG  "  ) + TransForm( MV_PAR02, "@E 999,999,999.99" )
Else
   @ PRow() + 2 ,046 pSay "META NO MÊS   " + IiF( mv_par04 == 1, "RS  ", "KG  "  ) + TransForm( meta(MV_PAR11), "@E 999,999,999.99" )
EndIf

@ PRow() + 2 ,046 pSay "VENDIDO NO MÊS     " + IiF( mv_par04 == 1, "RS ", "KG"  ) + TransForm( pddMes(), "@E 9,999,999.99" )
//@ PRow() + 1 ,043 pSay TransForm( nTotVal, '@E 9,999,999.99' )  + "  " + TransForm( nCartRS, '@E 9,999,999.99' ) + "  " +;
//											 TransForm( nTotPeso, '@E 9,999,999.99' ) + "  " + TransForm( nCartKG, '@E 9,999,999.99' )

@ Prow() + 2,046 PSAY "MEDIA DE DIAS PEDIDOS EM CARTEIRA " + transform( media(), '@E 999.99')

@ Prow() + 2,046 PSAY "N. DIAS DO PEDIDO COM MAIS TEMPO EM CARTEIRA: " + iif( !empty(dDatMax),alltrim(str(dDataBase - dDatMax)), "0") + " dias"

@ Prow() + 2,046 PSAY "N. de NF: "+TransForm( nNOTAST, "@E 9999" )
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

//Carteira( .T.)

***************

Static Function Carteira( lDia, nTipo )

***************

//nTipo = 1 Carteira Programada
//nTipo = 2 Carteira Pronta para Faturar

//Local nCartKG := nCartRS := Nil

Local aArret := {}

Default nTipo := 0

cCart := "SELECT SUM(( SC6.C6_QTDVEN - SC6.C6_QTDENT ) / SB1.B1_CONV) AS CARTEIRA_KG, SUM((SC6.C6_QTDVEN - SC6.C6_QTDENT) * SC6.C6_PRUNIT) AS CARTEIRA_RS, min(SC5.C5_ENTREG) AS DAT "
cCart += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9, "
cCart += "" + RetSqlName( "SA1" ) + " SA1 "
cCart += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cCart += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cCart += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cCart += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cCart += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
cCart += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cCart += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT, AMOSTRA

cCart += "SB1.B1_SETOR!= '39' AND "//Diferente Caixa

If !empty(MV_PAR11)
    cCart += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "
Endif


if MV_PAR07 = 1 //Linha Hospitalar
   cCart += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom/Inst
   cCart += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
   cCart += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
   cCart += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "   
endif
/*if !empty( MV_PAR08 )
	cCart += "SA1.A1_EST = '"+MV_PAR08+"' AND "
endIf*/
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cCart += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cCart += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cCart += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf

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
cCart += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' AND "
cCart += "SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' 
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
	
	cQuery += "and SB1.B1_SETOR != '39' " // Diferente Caixa 
	
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
cQuery += "FROM " + RetSqlName( "SB1" ) + " SB1, " + RetSqlName( "SC5" ) + " SC5, " + RetSqlName( "SC6" )+ " SC6, " + RetSqlName( "SC9" )+ " SC9, "
cQuery += " " + RetSqlName( "SA1" )+ " SA1 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND "
// NOVA LIBERACAO DE CRETIDO
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT,AMOSTRA

cQuery += "SB1.B1_SETOR != '39' AND " // Diferente Caixa 

If !empty(MV_PAR11)
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "
Endif


if MV_PAR07 = 1 //Linha Hospitalar
   cQuery += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom/Inst
   cQuery += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
   cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
   cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "      
endif
/*if !empty( MV_PAR08 )
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
endIf*/
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf

cQuery += "SB1.B1_FILIAL = '" + xFilial( "SB1" ) + "' AND SB1.D_E_L_E_T_ = ' ' AND "
cQuery += "SC5.C5_FILIAL = '" + xFilial( "SC5" ) + "' AND SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "SC6.C6_FILIAL = '" + xFilial( "SC6" ) + "' AND SC6.D_E_L_E_T_ = ' ' AND "
cQuery += "SC9.C9_FILIAL = '" + xFilial( "SC9" ) + "' AND SC9.D_E_L_E_T_ = ' ' AND "
cQuery += "SA1.A1_FILIAL = '" + xFilial( "SA1" ) + "' AND SA1.D_E_L_E_T_ = ' ' "
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

cQuery += "and SB1.B1_SETOR != '39' " // Diferente Caixa 

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
cQuery += "FROM "+retSqlName('SB1')+" SB1, "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+retSqlName('SC9')+" SC9, "
cQuery += " "+retSqlName('SA1')+" SA1 "
cQuery += "WHERE ( SC6.C6_QTDVEN - SC6.C6_QTDENT ) > 0 AND SC6.C6_BLQ <> 'R' AND SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_PRODUTO = SB1.B1_COD AND SC5.C5_NUM = SC6.C6_NUM AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT,AMOSTRA

cQuery += "SB1.B1_SETOR != '39'AND " // Diferente Caixa 

If !empty(MV_PAR11)
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "
Endif


if lDia
  cQuery += "SC5.C5_EMISSAO = '"+dtos(dDataBase)+"' and "
endIf

if MV_PAR07 = 1 //Linha Hospitalar
   cQuery += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom/Inst
   cQuery += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
   cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
   cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "         
endif   
/*if !empty( MV_PAR08 )
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
endIf*/
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf

if nTipo = 1
  //cQuery += "SC5.C5_ENTREG > '"+dtos(dDataBase)+"' and "  RETIRADO EM 07/05/08
  cQuery += "SC5.C5_ENTREG > '"+ dtos( lastday( dDataBase ) + 1 ) + "' and "
elseif nTipo = 2
  //cQuery += "SC5.C5_ENTREG <= '"+dtos(dDataBase)+"' and " RETIRADO EM 07/05/08
  cQuery += "SC5.C5_ENTREG <= '"+ dtos( lastday( dDataBase ) ) + "' and "
endif

cQuery += "SC9.C9_PEDIDO + SC9.C9_ITEM = SC6.C6_NUM + SC6.C6_ITEM and SC9.C9_PEDIDO = SC5.C5_NUM AND "
//cQuery += "SC9.C9_BLCRED = '  ' and SC9.C9_BLEST != '10' AND substring(B1_COD, 1, 1) in ('C','D','E') AND "
// NOVAL LIBERACAO DE CRETIDO
cQuery += "SC9.C9_BLCRED IN( '  ','04') and SC9.C9_BLEST != '10' AND substring(B1_COD, 1, 1) in ('C','D','E') AND "
cQuery += "SB1.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' AND SC9.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' ' "
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
//Atualizado para filtrar estados
local cQuery := ''
local aArret := {}

cQuery += "select sum(C6_QTDVEN * C6_PRUNIT) CARTEIRA_RS, SUM( ( SC6.C6_QTDVEN ) / SB1.B1_CONV ) AS CARTEIRA_KG "
cQuery += "from   "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SA1")+" SA1 "
cQuery += "where  C5_FILIAL = '"+xFilial('SC5')+"' AND C6_FILIAL = '"+xFilial('SC6')+"' AND A1_FILIAL = '"+xFilial('SA1')+"' AND "
cQuery += "SC5.C5_EMISSAO = '"+dtos(dDataBase)+"' AND SC5.C5_NUM = SC6.C6_NUM AND SC6.C6_PRODUTO = SB1.B1_COD AND "
cQuery += "SB1.B1_TIPO = 'PA' AND "
cQuery += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT,AMOSTRA

cQuery += "SB1.B1_SETOR != '39' AND " // Diferente Caixa 

cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "

If !empty(MV_PAR11)
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "
Endif

if MV_PAR07 = 1 //Linha Hospitalar
   cQuery += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom/Inst
   cQuery += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
   cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
   cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "         
endif   
/*if !empty( MV_PAR08 )
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
endIf*/
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf

cQuery += "SC5.D_E_L_E_T_ != '*' and	SC6.D_E_L_E_T_ != '*' and	SB1.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' "
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
//Atualizado para filtrar estados
Local cQuery  := ''
Local nTot := 0

cQuery += "select C6_PRODUTO "
cQuery += "from   "+retSqlName('SC5')+" SC5, "+retSqlName('SC6')+" SC6, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SA1")+" SA1 "
cQuery += "where  C5_FILIAL = '"+xFilial('SC5')+"' AND C6_FILIAL = '"+xFilial('SC6')+"' AND A1_FILIAL = '"+xFilial('SA1')+"' AND "
cQuery += "C5_EMISSAO = '"+dtos(dDataBase)+"' AND SC5.C5_NUM = SC6.C6_NUM AND C5_TIPO = 'N' AND "
cquery += "SC6.C6_PRODUTO = SB1.B1_COD AND "
cQuery += "SC6.C6_TES NOT IN( '540','516') AND "//Remessa MIXKIT,AMOSTRA

cQuery += "SB1.B1_SETOR != '39' AND " // Diferente Caixa 

If !empty(MV_PAR11)
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "
Endif


cQuery += "substring(C6_PRODUTO, 1, 1) in ('C','D','E') AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
if MV_PAR07 = 1 //Linha Hospitalar
   cQuery += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom/Inst
   cQuery += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
   cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
   cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "         
endif   
/*if !empty( MV_PAR08 )
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
endIf*/
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf
cQuery += "SC5.D_E_L_E_T_ != '*' and	SC6.D_E_L_E_T_ != '*' and	SB1.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' "
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



*************************
User function GetPrzM()
*************************
local nPrz := 0
local cVal := ""
local nVal := 0
Local nPar := 1

DbSelectArea("SE4")
DbSetOrder(1)
SE4->(DbSeek(xFilial("SE4")+SF2->F2_COND))
for nX := 1 to Len(Alltrim(SE4->E4_COND))
   if Substr(Alltrim(SE4->E4_COND),nX,1)==","
      nVal += Val(cVal)
      cVal := ""
      nPar ++    
   else
      cVal += Substr(Alltrim(SE4->E4_COND),nX,1)
   endif
next nX
if cVal <> ""
   nVal += Val(cVal)
endif
nPrz := NoRound((nVal/nPar),0)

return nPrz

***************

Static Function bonifica()

***************
Local cQuery := ""
Local aRet   := {0,0}
cQuery += "select sum(D2_TOTAL) TOTAL_RS, sum(D2_QUANT * B1_PESOR) TOTAL_KG "
cQuery += "from "+retSqlName('SD2')+" SD2, "+retSqlName('SB1')+" SB1, "+retSqlName('SA1')+" SA1, "+retSqlName('SC5')+" SC5 "
cQuery += "where SD2.D2_TES = '514' and month(D2_EMISSAO) = '"+strZero(month(dDataBase),2)+"' and year(D2_EMISSAO) = '"+strZero(year(dDataBase),4)+"' "
cQuery += "and SD2.D2_COD = SB1.B1_COD and D2_PEDIDO = C5_NUM AND "
cQuery += "SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "
cQuery += "D2_FILIAL = '"+xFilial('SD2')+"' and B1_FILIAL = '"+xFilial('SB1')+"' and C5_FILIAL = '"+xFilial('SC5')+"' and A1_FILIAL = '"+xFilial('SA1')+"' and "

cQuery += "SB1.B1_SETOR != '39' AND " // Diferente Caixa 


If !empty(MV_PAR11)
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "
Endif


if MV_PAR07 = 1 //Linha Hospitalar
	cQuery += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom/Inst
	cQuery += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
	cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
	cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "
endif
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf
cQuery += "SD2.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' and SC5.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' "
TCQUERY cQuery NEW ALIAS "_TMPK"
_TMPK->( dbGoTop() )
if _TMPK->( !EoF() )
	aRet[1]+= _TMPK->TOTAL_RS
	aRet[2]+= _TMPK->TOTAL_KG
endIf
_TMPK->( dbCloseArea() )
Return aRet

***************

Static Function pddMes()

***************

Local cQuery := ""
Local nVal := 0

cQuery += "select sum(C6_VALOR) TOTALRS, sum(C6_QTDVEN * B1_PESOR) TOTALKG "
cQuery += "from "+retSqlName('SC6')+" SC6, "+retSqlName('SC5')+" SC5, "+retSqlName('SB1')+" SB1, "+retSqlName('SA1')+" SA1, "+retSqlName('SF4')+" SF4 "
cQuery += "where C5_EMISSAO between '"+dtos(FirstDay(dDatabase))+"' and '"+dtos(LastDay(dDataBase))+"' "
cQuery += "and C6_PRODUTO = B1_COD and C6_NUM = C5_NUM and C5_TIPO = 'N' "
cQuery += "AND B1_COD NOT in ('187','188','189','190','200','210') "
cQuery += "and F4_DUPLIC = 'S' and C6_TES = F4_CODIGO "
cQuery += "and SC5.C5_CLIENTE + SC5.C5_LOJACLI = SA1.A1_COD + SA1.A1_LOJA AND "

cQuery += "SB1.B1_SETOR != '39' AND " // Diferente Caixa 

If !empty(MV_PAR11)
    cQuery += "SC5.C5_VEND1 in ('"+MV_PAR11+"','"+alltrim(MV_PAR11) +"VD'"+") AND "
Endif


if MV_PAR07 = 1 //Linha Hospitalar
	cQuery += "SB1.B1_GRUPO IN ('C') AND "
elseif MV_PAR07 = 2 //Linha Dom/Inst
	cQuery += "SB1.B1_GRUPO IN ('D','E') AND "
elseif MV_PAR07 = 3
	cQuery += "SB1.B1_GRUPO IN ('A','B','F','G') AND "
elseif MV_PAR07 = 5
	cQuery += "SB1.B1_GRUPO IN ('A','B','D','E','F','G') AND "
endif
if !empty(MV_PAR08) .and. empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND "
elseIf empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST != '"+MV_PAR09+"' AND "
elseIf !empty(MV_PAR08) .and. !empty(MV_PAR09)
	cQuery += "SA1.A1_EST = '"+MV_PAR08+"' AND SA1.A1_EST != '"+MV_PAR09+"' AND "
endIf
cQuery += "C5_FILIAL = '"+xFilial('SC5')+"' and B1_FILIAL = '"+xFilial('SB1')+"' and A1_FILIAL = '"+xFilial('SA1')+"' and B1_FILIAL = '"+xFilial('SC6')+"' "
cQuery += "and SC6.D_E_L_E_T_ != '*' and SC5.D_E_L_E_T_ != '*' and SB1.D_E_L_E_T_ != '*' and SF4.D_E_L_E_T_ != '*' and SA1.D_E_L_E_T_ != '*' "

TCQUERY cQuery NEW ALIAS '_TMPZA'
_TMPZA->( dbGoTop() )
do while !_TMPZA->(EoF())
	nVal := iif( mv_par04 == 1, _TMPZA->TOTALRS, _TMPZA->TOTALKG )
	_TMPZA->( dbSkip() )
endDo
_TMPZA->( dbCloseArea() )

Return nVal


***************

Static Function meta(cVend)

***************
Local nRet   := 0

Local cQuery := "select  Z7_VALOR from "+retSqlName("SZ7")+" where Z7_REPRESE = '"+cVend+"' "+;
				"and Z7_FILIAL = '"+xFilial('SZ7')+"' and D_E_L_E_T_ != '*' "+;
				"and substring(Z7_MESANO,1,2) = '"+MV_PAR01+"' "+;
				"and substring(Z7_MESANO,3,6) = '"+ StrZero(Year(dDATABASE),4)+"'  "
TCQUERY cQuery NEW ALIAS '_TMPY'
_TMPY->( dbGoTop() )
if _TMPY->( !EoF() )
   nRet :=  _TMPY->Z7_VALOR 
endIf
_TMPY->( dbCloseArea() )
Return nRet


***************

Static Function Descon(cDoc)

***************

Local nRet   := 0

Local cQuery := " "

cQuery := "SELECT SUM(E1_VALOR) E1_VALOR " 
cQuery += "FROM "+retSqlName("SF2")+" SF2,"+retSqlName("SE1")+" SE1 "
cQuery += "WHERE F2_DOC='"+cDoc+"' "
cQuery += "AND F2_FILIAL='"+xFilial('SF2')+"'  "
cQuery += "AND E1_FILIAL='"+xFilial('SE1')+"' "
cQuery += "AND F2_DOC=E1_NUM "
cQuery += "AND F2_SERIE=E1_PREFIXO "
cQuery += "AND F2_CLIENTE=E1_CLIENTE "
cQuery += "AND F2_LOJA=E1_LOJA  "
cQuery += "AND E1_TIPO='AB-' "
cQuery += "AND SF2.D_E_L_E_T_!='*'  "
cQuery += "AND SE1.D_E_L_E_T_!='*' 	"
TCQUERY cQuery NEW ALIAS '_AUUX'

_AUUX->( dbGoTop() )

if _AUUX->( !EoF() )
   nRet :=  _AUUX->E1_VALOR 
endIf

_AUUX->( dbCloseArea() )

Return nRet


                                              