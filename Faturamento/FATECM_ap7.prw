#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATECM()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NMIDIA,ASTRUT")
SetPrvt("CARQV,CARQX,AMESES,AMES,CMESES,DFIN")
SetPrvt("DINI,NI,NY,CARQ,NX,CARQI")
SetPrvt("WREGFIN,NREGTOT,WVALTOT,WPESTOT,WQTDTOT,CCODCLI")
SetPrvt("CCODVEN,NVALOR,DEMISSAO,NMES,CMES,NTOTREG")
SetPrvt("NQTDV,NQTD1,NQTD2,NQTD3,NQTD4,CVEND,NMES01")
SetPrvt("NMES02,NMES03,NMES04,NMES05,NMES06,NMES07")
SetPrvt("NMES08,NMES09,NMES10,NMES11,NMES12,M_PAG")
SetPrvt("NLIN,NQTD,NCONTI,NPERC,NTOTMD,NMEDIA")
SetPrvt("NTOTAL,CTIPO,CNTIP,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Autor  ³ Ana M B Alencar                          ³ Data ³ 28/03/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao³ Eficacia do Comercial                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                              ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01        	// Do Vendedor                                ³
//³ mv_par02        	// Ate Vededor                                ³
//³ mv_par03        	// Tipo de Impressao                          ³
//³ mv_par04        	// Pula Pagina de Vendas                      ³
//³ mv_par05        	// Imprime Cliente sem vendas                 ³
//³ mv_par06        	// Tipo do Relatório                          ³
//³ mv_par07        	// Segmento                                   ³
//³ mv_par08        	// Familia                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Salva a Integridade dos dados de Entrada.                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
cALIASANT := alias()
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Variaveis de parametrizacao da impressao.                    ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
cDESC1   := ''
cDESC2   := ''
cDESC3   := ''
aRETURN  := { 'Zebrado', 1, 'Administracao', 2, 2, 1, '', 1 }
cARQUIVO := 'SF2'
aORD     := { 'Vendedor+Cliente' }
cNOMREL  := 'FATECM'
cTITULO  := 'Eficacia Comercial'
nLASTKEY := 0
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Inicio do processamento                                      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

cSEG := ' '
Pergunte( 'FATECM', .T. )
If (mv_par06 == 2)
	If (mv_par07 == 1)
	  cSEG := " por Segmento Hospitalar"
	ElseIf (mv_par07 == 2)
	  cSEG := " por Segmento Domestico"
	Else
	  cSEG := " por Segmento Institucional"
	EndIf
ElseIf (mv_par06 == 3)
      cSEG := " por Familia " + (mv_par08) + " de Produtos"
Else
	cSEG := " Geral"
EndIf
cCAB := "Relatorio" + cSEG

cNOMREL := setprint( cARQUIVO, cNOMREL, 'FATECM', @cTITULO, cDESC1, cDESC2, cDESC3, .f., aORD )
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  de variaveis                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbselectarea( 'SB1' )
SB1->( dbsetorder( 1 ) )
dbselectarea( 'SF2' )
SF2->( dbsetorder( 9 ) ) //Alterado de 7 para 8 na migracao AP8
dbselectarea( 'SA1' )
SA1->( dbsetorder( 1 ) )

aSTRUT  := {}
aadd( aSTRUT, { 'VEND', 'C', 04, 0 } )
aadd( aSTRUT, { 'TIPO', 'C', 01, 0 } )
aadd( aSTRUT, { 'QTDV', 'N', 05, 0 } )
aadd( aSTRUT, { 'QTDT', 'N', 05, 0 } )
aadd( aSTRUT, { 'MS01', 'N', 12, 2 } )
aadd( aSTRUT, { 'MS02', 'N', 12, 2 } )
aadd( aSTRUT, { 'MS03', 'N', 12, 2 } )
aadd( aSTRUT, { 'MS04', 'N', 12, 2 } )
aadd( aSTRUT, { 'MS05', 'N', 12, 2 } )
aadd( aSTRUT, { 'MS06', 'N', 12, 2 } )
aadd( aSTRUT, { 'MS07', 'N', 12, 2 } )
aadd( aSTRUT, { 'MS08', 'N', 12, 2 } )
aadd( aSTRUT, { 'MS09', 'N', 12, 2 } )
aadd( aSTRUT, { 'MS10', 'N', 12, 2 } )
aadd( aSTRUT, { 'MS11', 'N', 12, 2 } )
aadd( aSTRUT, { 'MS12', 'N', 12, 2 } )

cARQV := criatrab( aSTRUT, .T. )
cARQX := criatrab( .F., .F. )
use (cARQV) alias VD new Exclusive
index on VEND+TIPO to (cARQX)

aSTRUT  := {}
aMESES  := {}
aMES    := {}
cMESES  := 'JanFevMarAbrMaiJunJulAgoSetOutNovDez'

                    // SX6->( dbseek( '  MV_ULMES  ' ) )
dFIN := dDATABASE   // ctod( left( SX6->X6_CONTEUD, 8 ) )
dINI := dFIN - 365

while month( dINI ) == month( dFIN )

   dINI := dINI + 1

end

nI   := month( dINI )
nY   := 0

aadd( aSTRUT, { 'NOME', 'C', 4, 0 } )
cARQ := criatrab( aSTRUT, .t. )
use &cARQ alias TP new Exclusive

for nX := nI to 12

   aadd( aMES,  { subs( cMESES,((nX-1)*3)+1, 3 ) + '/' + subs( dtoc( dINI ), 7, 2 ), nX } )
   TP->( dbappend() )
   TP->NOME := 'MS' + strzero( nX, 2 )

next

nI := nI - 1

for nX := 1 to nI

    aadd( aMES, { subs( cMESES,((nX-1)*3)+1, 3 ) + '/' + subs( dtoc( dFIN ), 7, 2 ), nX } )
    TP->( dbappend() )
    TP->NOME := 'MS' + strzero( nX, 2 )

next

aSTRUT  := {}
aadd( aSTRUT, { 'VEND', 'C', 04, 0 } )
aadd( aSTRUT, { 'CLIE', 'C', 06, 0 } )
aadd( aSTRUT, { 'TIPO', 'C', 01, 0 } )
aadd( aSTRUT, { 'DAT',  'D', 08, 0 } )
aadd( aSTRUT, { 'NOME', 'C', 20, 0 } )
TP->( dbgotop() )
while ! TP->( eof() )
   aadd( aSTRUT, { TP->NOME, 'N', 14, 4 } )
   TP->( dbskip() )
end

TP->( dbclosearea() )
delete file ( cARQ ) + '.DBF'

cARQ  := criatrab( aSTRUT,.T. )
cARQI := criatrab( .f.,.f. )
use (cARQ) alias CL new Exclusive
index on VEND+CLIE to (cARQI)

SD2->( dbSetorder( 3 ) )
dbselectarea( 'SF2' )
SF2->( dbsetorder( 9 ) ) //Alterado de 7 para 8 na migracao AP8
SF2->( dbseek( xFILIAL('SF2') + dtos( dFIN+1 ), .T. ) )
wREGFIN := SF2->(recno())
SF2->( dbseek( xFILIAL('SF2') + dtos( dINI ), .T. ) )
nREGTOT := wREGFIN - SF2->(RECNO())
wVALTOT := wPESTOT := wQTDTOT := 0
SetRegua( nREGTOT )
If MV_PAR05 == 1
    SA1->( DbGotop() )
    Do While ! SA1->( Eof() )
       SA3->( dbseek( xFILIAL('SA3') + Padr( Left( SA1->A1_VEND, 4 ), 6 ) ) )
       If SA3->A3_ATIVO <> "N" .and. SA1->A1_ATIVO <> "N"
          CL->( dbappend() )
          CL->CLIE := SA1->A1_COD
          CL->VEND := SA1->A1_VEND
        *   CL->DAT  := iif( dEMISSAO < SA1->A1_PRICOM .or. empty(SA1->A1_PRICOM), dEMISSAO, SA1->A1_PRICOM )
          CL->NOME := SA1->A1_NREDUZ
       EndIf
       SA1->( DbSkip() )
    EndDo
EndIf
while ! SF2->( eof() ) .and. SF2->F2_EMISSAO <= dFIN
   SA3->( dbseek( xFILIAL('SA3') + Padr( left(SF2->F2_VEND1,4), 6 ) ) )
   SA1->( dbseek( xFILIAL('SA1') + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
//   If SA1->A1_VEND <> SF2->F2_VEND1 .or. SA3->A3_ATIVO == "N" .or. SA1->A1_ATIVO == "N"     //Solicitado exclusao por Marcelo em 05/12/06
//      SF2->( dbskip() )
//      IncRegua()
//      Loop
//   EndIf
   cCODCLI  := SF2->F2_CLIENTE
	 cCODVEN  := left(SF2->F2_VEND1,4)
   nVALOR   := 0
   dEMISSAO := SF2->F2_EMISSAO
   nMES     := Month( dEMISSAO )
   SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
   While SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE

			cCOD := SD2->D2_COD

			If Len( AllTrim( cCOD ) ) >= 8
				If Subs( cCOD, 4, 1 ) == "R" .or. Subs( cCOD, 5, 1 ) == "R"
					cCOD := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 4 ) + Subs( SD2->D2_COD, 8, 2 ), Len( SD2->D2_COD ) )
				Else
					cCOD := Padr( Subs( SD2->D2_COD, 1, 1 ) + Subs( SD2->D2_COD, 3, 3 ) + Subs( SD2->D2_COD, 7, 2 ), Len( SD2->D2_COD ) )
				EndIf
			EndIf

      //SB1->( dbSeek( xFilial( 'SB1' ) + SD2->D2_COD ) )
			SB1->( dbSeek( xFilial( 'SB1' ) + cCOD ) )

      If SD2->D2_CF $ "511  /5101 /611  /6101 /512  /5102 /612  /6102 /6107 /6109 /5949 /6949 " .and. ;
 		 	 (  MV_PAR06 == 1 .or. ( MV_PAR06 == 2 .and. ( ( MV_PAR07 == 1 .and. Left( SD2->D2_COD, 1 ) == 'C' ) .or. ;
			 ( MV_PAR07 == 2 .and. Left( SD2->D2_COD, 1 ) $ 'DE' ) .or. ( MV_PAR07 == 3 .and. Left( SD2->D2_COD, 1 ) == 'A' ) ) ) .or. ;
			 ( MV_PAR06 == 3 .and. SB1->B1_SETOR == MV_PAR08 ) )
         If ! ( Empty( SD2->D2_SERIE ) .and. ! 'VD' $ SF2->F2_VEND1 )
            nVALOR += IIf( SD2->D2_UM == "KG", SD2->D2_QUANT, ( SD2->D2_QUANT * SB1->B1_PESOR ) )
         EndIf
      EndIf

      SD2->( DbSkip() )
   EndDo

   SF2->( dbskip() )
   IncRegua()

   if ! CL->( dbseek( cCODVEN + cCODCLI ) ) .and. ! empty( nVALOR )
      SA1->( dbseek( xFILIAL('SA1') +  cCODCLI, .t. ) )
      CL->( dbappend() )
      CL->CLIE := cCODCLI
      CL->VEND := cCODVEN
//      CL->DAT  := iif( dEMISSAO < SA1->A1_PRICOM .or. empty(SA1->A1_PRICOM), dEMISSAO, SA1->A1_PRICOM )
      CL->NOME := SA1->A1_NREDUZ
   endif

   cMES := strzero( nMES, 2 )
   CL->( fieldput( fieldpos( 'MS' + cMES ), fieldget( fieldpos( 'MS' + cMES ) ) + nVALOR ) )

end

CL->( dbselectarea( 'CL' ) )
CL->( dbseek( mv_par01, .t. ) )
count to nREGTOT while CL->VEND <= mv_par02
CL->( dbseek( mv_par01, .t. ) )
nTOTREG := nREGTOT
SetRegua( nREGTOT )
SF2->( dbsetorder( 2 ) )
nQTDV := nQTD1 := nQTD2 := nQTD3 := nQTD4 := 0

while CL->(!eof()) .and. CL->VEND <= mv_par02

   cVEND  := CL->VEND
   nMES01 := nMES02 := nMES03 := nMES04 := nMES05 := nMES06 := nMES07 := nMES08 := nMES09 := nMES10 := nMES11 := nMES12 := 0

   while CL->(!eof()) .and. CL->VEND <= mv_par02 .and. cVEND == CL->VEND
      if Empty( CL->( fieldget( 06 ) + fieldget( 07 ) + fieldget( 08 ) + fieldget( 09 ) + fieldget( 10 ) + fieldget( 11 ) + ;
        fieldget( 12 ) + fieldget( 13 ) + fieldget( 14 ) + fieldget( 15 ) + fieldget( 16 ) ) ) .and. ! Empty( CL->( fieldget( 17 ) ) )

         SF2->( Dbseek( xFILIAL('SF2') + CL->CLIE, .T. ) )
         If SF2->F2_CLIENTE == CL->CLIE .and. SF2->F2_EMISSAO < dINI  // Achou nota fiscal anterior aos 12 meses
            CL->TIPO := '4'   // REATIVADOS
            nQTD4    := nQTD4 + 1
         Else
            CL->TIPO := '3'   // NOVOS
            nQTD3    := nQTD3 + 1
         EndIf

      ElseIf ! Empty( CL->( fieldget( 06 ) + fieldget( 07 ) + fieldget( 08 ) + fieldget( 09 ) + fieldget( 10 ) + fieldget( 11 ) + ;
        fieldget( 12 ) + fieldget( 13 ) ) ) .and. Empty( CL->( fieldget( 14 ) + fieldget( 15 ) + fieldget( 16 ) ) ) .and. ! Empty( CL->( fieldget( 17 ) ) )

         CL->TIPO := '4'   // REATIVADOS
         nQTD4    := nQTD4 + 1

      elseif ! Empty( CL->( fieldget( 14 ) + fieldget( 15 ) + fieldget( 16 ) ) )

         CL->TIPO := '1'   // ATIVOS
         nQTD1    := nQTD1 + 1

      else

         CL->TIPO := '2'   // INATIVOS
         nQTD2    := nQTD2 + 1

      endif
      nQTDV  := nQTDV  + 1
      nMES01 := nMES01 + CL->(fieldget(06))
      nMES02 := nMES02 + CL->(fieldget(07))
      nMES03 := nMES03 + CL->(fieldget(08))
      nMES04 := nMES04 + CL->(fieldget(09))
      nMES05 := nMES05 + CL->(fieldget(10))
      nMES06 := nMES06 + CL->(fieldget(11))
      nMES07 := nMES07 + CL->(fieldget(12))
      nMES08 := nMES08 + CL->(fieldget(13))
      nMES09 := nMES09 + CL->(fieldget(14))
      nMES10 := nMES10 + CL->(fieldget(15))
      nMES11 := nMES11 + CL->(fieldget(16))
      nMES12 := nMES12 + CL->(fieldget(17))


	  CL->( dbskip() )
    IncRegua()

   end
   If ! Empty( nQTDV )
      VD->( dbappend() )
      VD->VEND := cVEND
      VD->QTDV := nQTDV
      VD->TIPO := '1'
      VD->QTDT := nQTD1
      VD->MS01 := nMES01
      VD->MS02 := nMES02
      VD->MS03 := nMES03
      VD->MS04 := nMES04
      VD->MS05 := nMES05
      VD->MS06 := nMES06
      VD->MS07 := nMES07
      VD->MS08 := nMES08
      VD->MS09 := nMES09
      VD->MS10 := nMES10
      VD->MS11 := nMES11
      VD->MS12 := nMES12
      VD->( dbappend() )
      VD->VEND := cVEND
      VD->QTDV := nQTDV
      VD->TIPO := '2'
      VD->QTDT := nQTD2
      VD->MS01 := nMES01
      VD->MS02 := nMES02
      VD->MS03 := nMES03
      VD->MS04 := nMES04
      VD->MS05 := nMES05
      VD->MS06 := nMES06
      VD->MS07 := nMES07
      VD->MS08 := nMES08
      VD->MS09 := nMES09
      VD->MS10 := nMES10
      VD->MS11 := nMES11
      VD->MS12 := nMES12
      VD->( dbappend() )
      VD->VEND := cVEND
      VD->QTDV := nQTDV
      VD->TIPO := '3'
      VD->QTDT := nQTD3
      VD->MS01 := nMES01
      VD->MS02 := nMES02
      VD->MS03 := nMES03
      VD->MS04 := nMES04
      VD->MS05 := nMES05
      VD->MS06 := nMES06
      VD->MS07 := nMES07
      VD->MS08 := nMES08
      VD->MS09 := nMES09
      VD->MS10 := nMES10
      VD->MS11 := nMES11
      VD->MS12 := nMES12
      VD->( dbappend() )
      VD->VEND := cVEND
      VD->QTDV := nQTDV
      VD->TIPO := '4'
      VD->QTDT := nQTD4
      VD->MS01 := nMES01
      VD->MS02 := nMES02
      VD->MS03 := nMES03
      VD->MS04 := nMES04
      VD->MS05 := nMES05
      VD->MS06 := nMES06
      VD->MS07 := nMES07
      VD->MS08 := nMES08
      VD->MS09 := nMES09
      VD->MS10 := nMES10
      VD->MS11 := nMES11
      VD->MS12 := nMES12
   EndIf
   nQTDV := nQTD1 := nQTD2 := nQTD3 := nQTD4 :=0
end


M_PAG     := 1
/*/
SX1->( dbseek( 'FATECM01' ) )
nLIN  := cabec( 'PARAMETROS DO RELATORIO EFICACIA COMERCIAL', '', '','FATECM._IX', 'M', 15 )
nLIN  := nLIN +1
@ nLIN,00 pSay repl( '*', 132 )

while SX1->X1_GRUPO == 'FATECM'

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
dbselectarea( 'VD' )
VD->( dbseek( mv_par01, .t. ) )
count to nREGTOT while VD->VEND <= mv_par02
VD->( dbseek( mv_par01, .t. ) )
cTITULO := 'Resumo da Eficacia Comercial'
SetRegua(nREGTOT)
nQTD := nQTD1 := nQTD2 := nQTD3 := nQTD4 := 0


while VD->(!eof()) .and. VD->VEND <= mv_par02

   /*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     ³ Imprime cabecalho do relatorio      ³
     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   */

   nLIN := cabec( cTITULO, '', '',cNOMREL, 'G', 18 )
   @ prow()+1,000       pSay padc( cCAB, 220 )
   @ prow()+1,000       pSay padc('De '+DTOC(dINI)+' ate '+DTOC(dFIN), 220 )
   @ prow()+2,000       pSay repl( '*', 220 )
   @ prow()+1,023       pSay '------Representante------  UF  ---Ativos--  --Inativos-  ---Novos---  -Reativados  ---Total---'
*                            XXXXX----------------XXXXX  XX  99.999 999%  99.999 999%  99.999 999%  99.999 999%  99.999 999%
   @ prow()+1,000       pSay repl( '*', 220 )

   while VD->(!eof()) .and. VD->VEND <= mv_par02 .and. prow() <= 60

      cVEND := VD->VEND
      SA3->( dbseek( xFILIAL('SA3') + VD->VEND, .t. ) )
      @ prow()+2,023      pSay VD->VEND + " - " + SA3->A3_NREDUZ
      @ prow()  ,pcol()+5 pSay SA3->A3_EST

      for nContI := 1 to 4

         nPERC := round( VD->QTDT/VD->QTDV*100, 0 )
         nQTDV := VD->QTDV
         @ prow(),pcol()+2 pSay VD->QTDT Picture '@E 99,999'
         @ prow(),pcol()+1 pSay nPERC    Picture '@R 999%'
         if nContI == 1

            nQTD1 := nQTD1 + VD->QTDT

         elseif nContI == 2

            nQTD2 := nQTD2 + VD->QTDT

         elseif nContI == 3

            nQTD3 := nQTD3 + VD->QTDT

         elseif nContI == 4

            nQTD4 := nQTD4 + VD->QTDT

         endif

         nQTD := nQTD + VD->QTDT

         VD->(dbskip())
         IncRegua()

      next

      @ prow(),pcol()+2 pSay nQTDV    Picture '@E 99,999'
      @ prow(),pcol()+1 pSay 100      Picture '@R 999%'

   end

end

@ prow()+2,023      pSay 'Total' + space(10)
@ prow()  ,pcol()+16 pSay nQTD1    Picture '@E 99,999'
nPERC := round( nQTD1/nQTD*100, 0 )
@ prow()  ,pcol()+1 pSay nPERC    Picture '@R 999%'
@ prow()  ,pcol()+2 pSay nQTD2    Picture '@E 99,999'
nPERC := round( nQTD2/nQTD*100, 0 )
@ prow()  ,pcol()+1 pSay nPERC    Picture '@R 999%'
@ prow()  ,pcol()+2 pSay nQTD3    Picture '@E 99,999'
nPERC := round( nQTD3/nQTD*100, 0 )
@ prow()  ,pcol()+1 pSay nPERC    Picture '@R 999%'
@ prow()  ,pcol()+2 pSay nQTD4    Picture '@E 99,999'
nPERC := round( nQTD4/nQTD*100, 0 )
@ prow()  ,pcol()+1 pSay nPERC    Picture '@R 999%'

cARQI := criatrab(.f.,.f.)
dbselectarea( 'VD' )
index on VEND to (cARQI) UNIQUE
VD->( dbseek( mv_par01, .t. ) )
count to nREGTOT while VEND <= mv_par02
VD->( dbseek( mv_par01, .t. ) )
SetRegua(nREGTOT)


nMES01 :=nMES02:=nMES03:=nMES04:=nMES05:=nMES06:=0
nMES07 :=nMES08:=nMES09:=nMES10:=nMES11:=nMES12:=0
nTOTMD := 0
cTITULO:= 'Resumo da Eficacia Comercial por Representante (Kg)'

while VD->(!eof()) .and. VD->VEND <= mv_par02

   /*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     ³ Imprime cabecalho do relatorio      ³
     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   */

   nLIN := cabec( cTITULO, '', '',cNOMREL, 'G', 15 )
   @ prow()+1,000       pSay padc( cCAB, 220 )
   @ prow()+1,000       pSay padc('De '+DTOC(dINI)+' ate '+DTOC(dFIN), 220 )
   @ prow()+1,000       pSay repl( '*', 220 )
   @ prow()+1,000       pSay 'Descricao'
   @ prow()  ,pcol()+21 pSay '--'+aMES[01,1]+'---'
   @ prow()  ,pcol()+02 pSay '--'+aMES[02,1]+'---'
   @ prow()  ,pcol()+02 pSay '--'+aMES[03,1]+'---'
   @ prow()  ,pcol()+02 pSay '--'+aMES[04,1]+'---'
   @ prow()  ,pcol()+02 pSay '--'+aMES[05,1]+'---'
   @ prow()  ,pcol()+02 pSay '--'+aMES[06,1]+'---'
   @ prow()  ,pcol()+02 pSay '--'+aMES[07,1]+'---'
   @ prow()  ,pcol()+02 pSay '--'+aMES[08,1]+'---'
   @ prow()  ,pcol()+02 pSay '--'+aMES[09,1]+'---'
   @ prow()  ,pcol()+02 pSay '--'+aMES[10,1]+'---'
   @ prow()  ,pcol()+02 pSay '--'+aMES[11,1]+'---'
   @ prow()  ,pcol()+02 pSay '--'+aMES[12,1]+'---'
   @ prow()  ,pcol()+02 pSay '----Media----'
   @ prow()  ,pcol()+02 pSay '-----Total-----'
   @ prow()+1,000       pSay repl( '*', 220 )

   while VD->(!eof()) .and. VD->VEND <= mv_par02 .and. prow() <= 60

      SA3->( dbseek( xFILIAL('SA3') + VD->VEND, .t. ) )
      @ prow()+2,000 pSay VD->VEND+' - '+SA3->A3_NREDUZ
      if nMIDIA==2
         @ prow(),000 pSay VD->VEND+' - '+SA3->A3_NREDUZ
      endif

      nMEDIA := VD->MS01+VD->MS02+VD->MS03+VD->MS04+VD->MS05+VD->MS06+;
                VD->MS07+VD->MS08+VD->MS09+VD->MS10+VD->MS11+VD->MS12
      nTOTMD := nTOTMD + nMEDIA
      nTOTAL := nMEDIA
      nMEDIA := nMEDIA / 12
      nMES01 := nMES01 + VD->MS01
      nMES02 := nMES02 + VD->MS02
      nMES03 := nMES03 + VD->MS03
      nMES04 := nMES04 + VD->MS04
      nMES05 := nMES05 + VD->MS05
      nMES06 := nMES06 + VD->MS06
      nMES07 := nMES07 + VD->MS07
      nMES08 := nMES08 + VD->MS08
      nMES09 := nMES09 + VD->MS09
      nMES10 := nMES10 + VD->MS10
      nMES11 := nMES11 + VD->MS11
      nMES12 := nMES12 + VD->MS12

      @ prow()  ,pcol()+08 pSay VD->MS01 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay VD->MS02 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay VD->MS03 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay VD->MS04 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay VD->MS05 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay VD->MS06 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay VD->MS07 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay VD->MS08 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay VD->MS09 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay VD->MS10 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay VD->MS11 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay VD->MS12 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+04 pSay nMEDIA   Picture '@E 9999,999.99'
      @ prow()  ,pcol()+04 pSay nTOTAL   Picture '@E 99,999,999.99'

      VD->(dbskip())
      IncRegua()

   end

end

@ prow()+3,000 pSay 'Total geral -------------->'
if nMIDIA==2
   @ prow()+3,000 pSay 'Total geral -------------->'
endif

nTOTAL := nTOTMD
nMEDIA := nTOTMD/12

@ prow()  ,pcol()+03 pSay nMES01 Picture '@E 9999,999.99'
@ prow()  ,pcol()+02 pSay nMES02 Picture '@E 9999,999.99'
@ prow()  ,pcol()+02 pSay nMES03 Picture '@E 9999,999.99'
@ prow()  ,pcol()+02 pSay nMES04 Picture '@E 9999,999.99'
@ prow()  ,pcol()+02 pSay nMES05 Picture '@E 9999,999.99'
@ prow()  ,pcol()+02 pSay nMES06 Picture '@E 9999,999.99'
@ prow()  ,pcol()+02 pSay nMES07 Picture '@E 9999,999.99'
@ prow()  ,pcol()+02 pSay nMES08 Picture '@E 9999,999.99'
@ prow()  ,pcol()+02 pSay nMES09 Picture '@E 9999,999.99'
@ prow()  ,pcol()+02 pSay nMES10 Picture '@E 9999,999.99'
@ prow()  ,pcol()+02 pSay nMES11 Picture '@E 9999,999.99'
@ prow()  ,pcol()+02 pSay nMES12 Picture '@E 9999,999.99'
@ prow()  ,pcol()+04 pSay nMEDIA Picture '@E 9999,999.99'
@ prow()  ,pcol()+04 pSay nTOTAL Picture '@E 99,999,999.99'


cARQX := criatrab(.f.,.f.)
dbselectarea( 'VD' )
index on VEND+TIPO to (cARQX)

cARQI := criatrab(.f.,.f.)
dbselectarea( 'CL' )
index on VEND+TIPO+CLIE to (cARQI)
CL->( dbseek( mv_par01, .t. ) )
nREGTOT := nTOTREG
SetRegua(nREGTOT)

nMES01 :=nMES02:=nMES03:=nMES04:=nMES05:=nMES06:=0
nMES07 :=nMES08:=nMES09:=nMES10:=nMES11:=nMES12:=0
nTOTMD := 0
cTITULO:= 'Eficacia Comercial (Kg)'

while CL->(!eof()) .and. CL->VEND <= mv_par02

   /*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     ³ Imprime cabecalho do relatorio      ³
     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   */

   nLIN := cabec( cTITULO, '', '',cNOMREL, 'G', 15 )
   @ prow()  ,000       pSay padc('De '+DTOC(dINI)+' ate '+DTOC(dFIN), 220 )
   @ prow()+1,000       pSay repl( '*', 220 )
   @ prow()+1,000       pSay 'Codigo'
   @ prow()  ,pcol()+02 pSay 'Descricao'
   @ prow()  ,pcol()+13 pSay '--'+aMES[01,1]+'--'
   @ prow()  ,pcol()+02 pSay '--'+aMES[02,1]+'--'
   @ prow()  ,pcol()+02 pSay '--'+aMES[03,1]+'--'
   @ prow()  ,pcol()+02 pSay '--'+aMES[04,1]+'--'
   @ prow()  ,pcol()+02 pSay '--'+aMES[05,1]+'--'
   @ prow()  ,pcol()+02 pSay '--'+aMES[06,1]+'--'
   @ prow()  ,pcol()+02 pSay '--'+aMES[07,1]+'--'
   @ prow()  ,pcol()+02 pSay '--'+aMES[08,1]+'--'
   @ prow()  ,pcol()+02 pSay '--'+aMES[09,1]+'--'
   @ prow()  ,pcol()+02 pSay '--'+aMES[10,1]+'--'
   @ prow()  ,pcol()+02 pSay '--'+aMES[11,1]+'--'
   @ prow()  ,pcol()+02 pSay '--'+aMES[12,1]+'--'
   if mv_par03 == 2
      @ pROW()  ,pcol()+02 pSay '--Media-----'
   endif
   @ prow()+1,000       pSay repl( '*', 220 )

   while CL->(!eof()) .and. CL->VEND <= mv_par02 .and. prow() <= 60
      SA3->( dbseek( xFILIAL('SA3') + CL->VEND, .t. ) )
      @ prow()+2,000 pSay CL->VEND+' - '+SA3->A3_NREDUZ
      if nMIDIA==2
         @ prow(),000 pSay CL->VEND+' - '+SA3->A3_NREDUZ
      endif
      cVEND := CL->VEND

      while CL->(!eof()) .and. CL->VEND <= mv_par02 .and. prow() <= 60 .and. CL->VEND == cVEND
         cTIPO := CL->TIPO
         cNTIP := iif(CL->TIPO=='1','ATIVOS',iif(CL->TIPO=='2','INATIVOS',iif(CL->TIPO=='3','NOVOS','REATIVADOS')))
         VD->( dbseek( cVEND + cTIPO ) )
         nPERC := round( (VD->QTDT / VD->QTDV)*100, 0 )
         cNTIP := cNTIP+' - '+transform(VD->QTDT,'@E 99,999')+' - '+transform(nPERC,'@E 999') + '%'
         @ prow()+2,000 pSay cNTIP
         if nMIDIA==2
            @ prow(),000 pSay cNTIP
         endif
         @ prow()+1,000 Psay ""

         while CL->(!eof()) .and. CL->VEND <= mv_par02 .and. prow() <= 60 .and. ;
               CL->VEND == cVEND .and. cTIPO == CL->TIPO

            nMEDIA := CL->(fieldget(12))+CL->(fieldget(13))+CL->(fieldget(14))+CL->(fieldget(15))+CL->(fieldget(16))+CL->(fieldget(17))+;
                      CL->(fieldget(06))+CL->(fieldget(07))+CL->(fieldget(08))+CL->(fieldget(09))+CL->(fieldget(10))+CL->(fieldget(11))
            nTOTMD := nTOTMD + nMEDIA
            nMEDIA := nMEDIA / 12
            nMES01 := nMES01 + CL->(fieldget(06))
            nMES02 := nMES02 + CL->(fieldget(07))
            nMES03 := nMES03 + CL->(fieldget(08))
            nMES04 := nMES04 + CL->(fieldget(09))
            nMES05 := nMES05 + CL->(fieldget(10))
            nMES06 := nMES06 + CL->(fieldget(11))
            nMES07 := nMES07 + CL->(fieldget(12))
            nMES08 := nMES08 + CL->(fieldget(13))
            nMES09 := nMES09 + CL->(fieldget(14))
            nMES10 := nMES10 + CL->(fieldget(15))
            nMES11 := nMES11 + CL->(fieldget(16))
            nMES12 := nMES12 + CL->(fieldget(17))

            @ prow()+1,000       pSay CL->CLIE
            @ prow()  ,pcol()+02 pSay CL->NOME
            @ prow()  ,pcol()+02 pSay CL->(fieldget(06)) Picture '@E 999,999.99'
            @ prow()  ,pcol()+02 pSay CL->(fieldget(07)) Picture '@E 999,999.99'
            @ prow()  ,pcol()+02 pSay CL->(fieldget(08)) Picture '@E 999,999.99'
            @ prow()  ,pcol()+02 pSay CL->(fieldget(09)) Picture '@E 999,999.99'
            @ prow()  ,pcol()+02 pSay CL->(fieldget(10)) Picture '@E 999,999.99'
            @ prow()  ,pcol()+02 pSay CL->(fieldget(11)) Picture '@E 999,999.99'
            @ prow()  ,pcol()+02 pSay CL->(fieldget(12)) Picture '@E 999,999.99'
            @ prow()  ,pcol()+02 pSay CL->(fieldget(13)) Picture '@E 999,999.99'
            @ prow()  ,pcol()+02 pSay CL->(fieldget(14)) Picture '@E 999,999.99'
            @ prow()  ,pcol()+02 pSay CL->(fieldget(15)) Picture '@E 999,999.99'
            @ prow()  ,pcol()+02 pSay CL->(fieldget(16)) Picture '@E 999,999.99'
            @ prow()  ,pcol()+02 pSay CL->(fieldget(17)) Picture '@E 999,999.99'
            if mv_par03 == 2
               @ prow()  ,pcol()+02 pSay nMEDIA Picture '@E 999,999.99'
               @ prow()+1,008       pSay 'Previsao :'
               @ prow()+1,030       pSay '__________'
               @ prow()  ,pcol()+02 pSay '__________'
               @ prow()  ,pcol()+02 pSay '__________'
               @ prow()  ,pcol()+02 pSay '__________'
               @ prow()  ,pcol()+02 pSay '__________'
               @ prow()  ,pcol()+02 pSay '__________'
               @ prow()  ,pcol()+02 pSay '__________'
               @ prow()  ,pcol()+02 pSay '__________'
               @ prow()  ,pcol()+02 pSay '__________'
               @ prow()  ,pcol()+02 pSay '__________'
               @ prow()  ,pcol()+02 pSay '__________'
               @ prow()  ,pcol()+02 pSay '__________'
               @ prow()  ,pcol()+02 pSay '__________'
               @ prow()+1,000 Psay ""
            endif

            CL->(dbskip())
            IncRegua()

         end

      end

      if CL->(eof()) .or. CL->VEND #cVEND

         nTOTMD := nTOTMD / 12
         @ prow()+1,000 pSay VD->QTDV
         @ prow()  ,008 pSay '< Total Vendedor >'
         @ prow()  ,pcol()+04 pSay nMES01 Picture '@E 999,999.99'
         @ prow()  ,pcol()+02 pSay nMES02 Picture '@E 999,999.99'
         @ prow()  ,pcol()+02 pSay nMES03 Picture '@E 999,999.99'
         @ prow()  ,pcol()+02 pSay nMES04 Picture '@E 999,999.99'
         @ prow()  ,pcol()+02 pSay nMES05 Picture '@E 999,999.99'
         @ prow()  ,pcol()+02 pSay nMES06 Picture '@E 999,999.99'
         @ prow()  ,pcol()+02 pSay nMES07 Picture '@E 999,999.99'
         @ prow()  ,pcol()+02 pSay nMES08 Picture '@E 999,999.99'
         @ prow()  ,pcol()+02 pSay nMES09 Picture '@E 999,999.99'
         @ prow()  ,pcol()+02 pSay nMES10 Picture '@E 999,999.99'
         @ prow()  ,pcol()+02 pSay nMES11 Picture '@E 999,999.99'
         @ prow()  ,pcol()+02 pSay nMES12 Picture '@E 999,999.99'
         if mv_par03 == 2
            @ prow()  ,pcol()+02 pSay nTOTMD Picture '@E 999,999.99'
            @ prow()+1,008       pSay 'Previsao :'
            @ prow()+1,030       pSay '__________'
            @ prow()  ,pcol()+02 pSay '__________'
            @ prow()  ,pcol()+02 pSay '__________'
            @ prow()  ,pcol()+02 pSay '__________'
            @ prow()  ,pcol()+02 pSay '__________'
            @ prow()  ,pcol()+02 pSay '__________'
            @ prow()  ,pcol()+02 pSay '__________'
            @ prow()  ,pcol()+02 pSay '__________'
            @ prow()  ,pcol()+02 pSay '__________'
            @ prow()  ,pcol()+02 pSay '__________'
            @ prow()  ,pcol()+02 pSay '__________'
            @ prow()  ,pcol()+02 pSay '__________'
            @ prow()  ,pcol()+02 pSay '__________'
            @ prow()+1,000 Psay ""
         endif
         nMES01 := nMES02:=nMES03:=nMES04:=nMES05:=nMES06:= 0
         nMES07 := nMES08:=nMES09:=nMES10:=nMES11:=nMES12:= 0
         nTOTMD := 0
         if mv_par04 == 1
            @ 61,000 Psay ""
         endif

      endif

   end

end


Roda(0,'','M')

If aReturn[5] == 1
   Set Printer To
   Commit
   ourspool(cNomRel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
retindex( 'SF2' )
retindex( 'SB1' )
CL->( dbclosearea() )
VD->( dbclosearea() )
return


