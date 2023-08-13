#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function FATEUF()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CALIASANT,CDESC1,CDESC2,CDESC3,ARETURN,CARQUIVO")
SetPrvt("AORD,CNOMREL,CTITULO,NLASTKEY,NMIDIA,ASTRUT")
SetPrvt("CARQV,CARQX,AMESES,AMES,CMESES,DFIN")
SetPrvt("DINI,aEST,CARQ,NX,CARQI")
SetPrvt("WREGFIN,NREGTOT,WVALTOT,WPESTOT,WQTDTOT,CCODCLI")
SetPrvt("CCODVEN,NVALOR,DEMISSAO,NMES,CMES,NTOTREG")
SetPrvt("NQTDV,NQTD1,NQTD2,NQTD3,NQTD4,CUF,NMES01")
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
±±³Descricao³ Eficacia do Comercial por estado                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Uso   ³ Faturamento                                                ³±±
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
cDESC1   := ''
cDESC2   := ''
cDESC3   := ''
aRETURN  := { 'Zebrado', 1, 'Administracao', 2, 2, 1, '', 1 }
cARQUIVO := 'SF2'
aORD     := { 'Estado' }
cNOMREL  := 'FATEUF'
cTITULO  := 'Eficacia Comercial por estado'
nLASTKEY := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                              ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01        	// Do Estado                                  ³
//³ mv_par02        	// Ate Estado                                 ³
//³ mv_par03        	// Tipo de Impressao                          ³
//³ mv_par04        	// Pula Pagina de Vendas                      ³
//³ mv_par05        	// Tipo do Relatorio                          ³
//³ mv_par06        	// Segmento                                   ³
//³ mv_par07        	// Familia                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cSEG := ' '
Pergunte( 'FATEUF', .T. )
If (mv_par05 == 2)
	If (mv_par06 == 1)
	  cSEG := " por Segmento Hospitalar"
	ElseIf (mv_par06 == 2)
	  cSEG := " por Segmento Domestico"
	Else
	  cSEG := " por Segmento Institucional"
	EndIf
ElseIf (mv_par05 == 3)
      cSEG := " por Familia " + (mv_par07) + " de Produtos"
Else
	cSEG := " Geral"
EndIf
cCAB := "Relatorio" + cSEG

cNOMREL := setprint( cARQUIVO, cNOMREL, 'FATEUF', @cTITULO, cDESC1, cDESC2, cDESC3, .f., aORD )
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
SF2->( dbsetorder( 8 ) ) //Alterado de 7 para 8 na migracao AP8

aSTRUT  := {}
aadd( aSTRUT, { 'UF',   'C', 02, 0 } )
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
use (cARQV) alias UF new Exclusive
index on UF+TIPO to (cARQX)

aEST    := {}
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

SX5->( DbSeek( xFILIAL('SX5') + '12', .T. ) )
Do WHile SX5->X5_TABELA == "12"
   aadd( aEST, { Left( SX5->X5_CHAVE, 2 ), Left( SX5->X5_DESCRI, 20 ) } )
   SX5->( DbSkip() )
EndDo

aEST := Asort( aEST,,, { |X,Y| X[1] < Y[1] } )
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
aadd( aSTRUT, { 'UF',   'C', 02, 0 } )
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
index on UF+CLIE to (cARQI)

SD2->( dbSetorder( 3 ) )
dbselectarea( 'SF2' )
SF2->( dbsetorder( 8 ) ) //Alterado de 7 para 8 na migracao AP8
SF2->( dbseek( xFILIAL('SF2') + dtos( dFIN+1 ), .T. ) )
wREGFIN := SF2->(recno())
SF2->( dbseek( xFILIAL('SF2') + dtos( dINI ), .T. ) )
nREGTOT := wREGFIN - SF2->(RECNO())
wVALTOT := wPESTOT := wQTDTOT := 0
SetRegua( nREGTOT )
SA1->( DbGotop() )
Do While ! SA1->( Eof() )
   SA3->( dbseek( xFILIAL('SA3') + Padr( Left( SA1->A1_VEND, 4 ), 6 ) ) )
   If SA3->A3_ATIVO <> "N" .and. SA1->A1_ATIVO <> "N"
   		CL->( dbappend() )
   		CL->CLIE := SA1->A1_COD
   		CL->UF   := SA1->A1_EST
   		CL->NOME := SA1->A1_NREDUZ
	 EndIf
   SA1->( DbSkip() )
EndDo
while ! SF2->( eof() ) .and. SF2->F2_EMISSAO <= dFIN
   SA3->( dbseek( xFILIAL('SA3') + Padr( left(SF2->F2_VEND1,4), 6 ) ) )
   SA1->( dbseek( xFILIAL('SA1') + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
   cCODCLI  := SF2->F2_CLIENTE
   cCODEST  := SF2->F2_EST
   nVALOR   := 0
   dEMISSAO := SF2->F2_EMISSAO
   nMES     := Month( dEMISSAO )
   SD2->( dbSeek( xFilial( "SD2" ) + SF2->F2_DOC + SF2->F2_SERIE, .T. ) )
   While SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_DOC + SF2->F2_SERIE
      SB1->( dbSeek( xFilial( 'SB1' ) + SD2->D2_COD ) )
      If SD2->D2_CF $ "511  /5101 /611  /6101 /512  /5102 /612  /6102 /6107 /6109 /5949 /6949 " .and. ;
 		 	 (  MV_PAR05 == 1 .or. ( MV_PAR05 == 2 .and. ( ( MV_PAR06 == 1 .and. Left( SD2->D2_COD, 1 ) == 'C' ) .or. ;
			 ( MV_PAR06 == 2 .and. Left( SD2->D2_COD, 1 ) $ 'DE' ) .or. ( MV_PAR06 == 3 .and. Left( SD2->D2_COD, 1 ) == 'A' ) ) ) .or. ;
			 ( MV_PAR05 == 3 .and. SB1->B1_SETOR == MV_PAR07 ) )
         nVALOR += SD2->D2_QTSEGUM  //nVALOR += IIf( SD2->D2_UM == "KG", SD2->D2_QUANT, ( SD2->D2_QUANT * SB1->B1_PESOR ) )  18/07/06 Esmerino Neto por Janderley  //IIf( Empty( SD2->D2_SERIE ) .and. ! 'VD' $ SF2->F2_VEND1, 0, IIf( SD2->D2_UM == "KG", SD2->D2_QUANT, ( SD2->D2_QUANT * SB1->B1_PESOR ) ) )  13/07/06 Esmerino Neto por Marcelo
      EndIf
      SD2->( DbSkip() )
   EndDo

   SF2->( dbskip() )
   IncRegua()
   If SA3->A3_ATIVO == "N" .or. SA1->A1_ATIVO == "N"
      Loop
   EndIf

   if ! CL->( dbseek( cCODEST + cCODCLI ) ) .and. ! empty( nVALOR )
      SA1->( dbseek( xFILIAL('SA1') +  cCODCLI, .t. ) )
      CL->( dbappend() )
      CL->CLIE := cCODCLI
      CL->UF   := cCODEST
*      CL->DAT  := iif( dEMISSAO < SA1->A1_PRICOM .or. empty(SA1->A1_PRICOM), dEMISSAO, SA1->A1_PRICOM )
      CL->NOME := SA1->A1_NREDUZ
   endif

   cMES := strzero( nMES, 2 )
   CL->( fieldput( fieldpos( 'MS' + cMES ), fieldget( fieldpos( 'MS' + cMES ) ) + nVALOR ) )

end

CL->( dbselectarea( 'CL' ) )
CL->( dbseek( mv_par01, .t. ) )
count to nREGTOT while CL->UF <= mv_par02
CL->( dbseek( mv_par01, .t. ) )
nTOTREG := nREGTOT
SetRegua( nREGTOT )
SF2->( dbsetorder( 2 ) )
nQTDV := nQTD1 := nQTD2 := nQTD3 := nQTD4 := 0

while CL->(!eof()) .and. CL->UF <= mv_par02

   cUF  := CL->UF
   nMES01 := nMES02 := nMES03 := nMES04 := nMES05 := nMES06 := nMES07 := nMES08 := nMES09 := nMES10 := nMES11 := nMES12 := 0

   while CL->(!eof()) .and. CL->UF <= mv_par02 .and. cUF == CL->UF
      if Empty( CL->( fieldget( 06 ) + fieldget( 07 ) + fieldget( 08 ) + fieldget( 09 ) + fieldget( 10 ) + fieldget( 11 ) + ;
        fieldget( 12 ) + fieldget( 13 ) + fieldget( 14 ) + fieldget( 15 ) + fieldget( 16 ) ) ) .and. ! Empty( CL->( fieldget( 17 ) ) )

         SF2->( Dbseek( xFILIAL('SF2') + CL->CLIE, .T. ) )
         If SA1->A1_COD == SF2->F2_CLIENTE .and. SF2->F2_EMISSAO < dINI  // Achou nota fiscal anterior aos 12 meses
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

   UF->( dbappend() )
   UF->UF   := cUF
   UF->QTDV := nQTDV
   UF->TIPO := '1'
   UF->QTDT := nQTD1
   UF->MS01 := nMES01
   UF->MS02 := nMES02
   UF->MS03 := nMES03
   UF->MS04 := nMES04
   UF->MS05 := nMES05
   UF->MS06 := nMES06
   UF->MS07 := nMES07
   UF->MS08 := nMES08
   UF->MS09 := nMES09
   UF->MS10 := nMES10
   UF->MS11 := nMES11
   UF->MS12 := nMES12
   UF->( dbappend() )
   UF->UF   := cUF
   UF->QTDV := nQTDV
   UF->TIPO := '2'
   UF->QTDT := nQTD2
   UF->MS01 := nMES01
   UF->MS02 := nMES02
   UF->MS03 := nMES03
   UF->MS04 := nMES04
   UF->MS05 := nMES05
   UF->MS06 := nMES06
   UF->MS07 := nMES07
   UF->MS08 := nMES08
   UF->MS09 := nMES09
   UF->MS10 := nMES10
   UF->MS11 := nMES11
   UF->MS12 := nMES12
   UF->( dbappend() )
   UF->UF   := cUF
   UF->QTDV := nQTDV
   UF->TIPO := '3'
   UF->QTDT := nQTD3
   UF->MS01 := nMES01
   UF->MS02 := nMES02
   UF->MS03 := nMES03
   UF->MS04 := nMES04
   UF->MS05 := nMES05
   UF->MS06 := nMES06
   UF->MS07 := nMES07
   UF->MS08 := nMES08
   UF->MS09 := nMES09
   UF->MS10 := nMES10
   UF->MS11 := nMES11
   UF->MS12 := nMES12
   UF->( dbappend() )
   UF->UF   := cUF
   UF->QTDV := nQTDV
   UF->TIPO := '4'
   UF->QTDT := nQTD4
   UF->MS01 := nMES01
   UF->MS02 := nMES02
   UF->MS03 := nMES03
   UF->MS04 := nMES04
   UF->MS05 := nMES05
   UF->MS06 := nMES06
   UF->MS07 := nMES07
   UF->MS08 := nMES08
   UF->MS09 := nMES09
   UF->MS10 := nMES10
   UF->MS11 := nMES11
   UF->MS12 := nMES12
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
dbselectarea( 'UF' )
UF->( dbseek( mv_par01, .T. ) )
count to nREGTOT while UF->UF <= mv_par02
UF->( dbseek( mv_par01, .t. ) )
cTITULO := 'Resumo da Eficacia Comercial por estado'
SetRegua(nREGTOT)
nQTD := nQTD1 := nQTD2 := nQTD3 := nQTD4 := 0

while UF->( ! Eof() ) .and. UF->UF <= mv_par02

   /*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     ³ Imprime cabecalho do relatorio      ³
     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   */

   nLIN := cabec( cTITULO, '', '',cNOMREL, 'G', 18 )
   @ prow()+1,000       pSay padc( cCAB, 220 )
   @ prow()+1,000       pSay padc( 'De '+DTOC(dINI)+' ate '+DTOC(dFIN), 220 )
   @ prow()+2,000       pSay repl( '*', 220 )
   @ prow()+1,023       pSay 'UF                         ---Ativos--  --Inativos-  ---Novos---  -Reativados  ---Total---'
*                            XXXXX----------------XXXXX  XX  99.999 999%  99.999 999%  99.999 999%  99.999 999%  99.999 999%
   @ prow()+1,000       pSay repl( '*', 220 )

   while UF->(!eof()) .and. UF->UF <= mv_par02 .and. prow() <= 58

      cUF := UF->UF
      nCONT := Ascan( aEST, { |X| X[1] == UF->UF } )
      @ prow()+2,023 pSay UF->UF+' - '+aEST[nCONT,2]

      for nContI := 1 to 4

         nPERC := round( UF->QTDT/UF->QTDV*100, 0 )
         nQTDV := UF->QTDV
         @ prow(),pcol()+2 pSay UF->QTDT Picture '@E 99,999'
         @ prow(),pcol()+1 pSay nPERC    Picture '@R 999%'
         if nContI == 1

            nQTD1 := nQTD1 + UF->QTDT

         elseif nContI == 2

            nQTD2 := nQTD2 + UF->QTDT

         elseif nContI == 3

            nQTD3 := nQTD3 + UF->QTDT

         elseif nContI == 4

            nQTD4 := nQTD4 + UF->QTDT

         endif

         nQTD := nQTD + UF->QTDT

         UF->(dbskip())
         IncRegua()

      next

      @ prow(),pcol()+2 pSay nQTDV    Picture '@E 99,999'
      @ prow(),pcol()+1 pSay 100      Picture '@R 999%'

   end

end

@ prow()+2,023      pSay 'Total' + space(10)
@ prow()  ,pcol()+12 pSay nQTD1    Picture '@E 99,999'
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
dbselectarea( 'UF' )
index on UF to (cARQI) UNIQUE
UF->( dbseek( mv_par01, .t. ) )
count to nREGTOT while UF <= mv_par02
UF->( dbseek( mv_par01, .t. ) )
SetRegua(nREGTOT)

nMES01 :=nMES02:=nMES03:=nMES04:=nMES05:=nMES06:=0
nMES07 :=nMES08:=nMES09:=nMES10:=nMES11:=nMES12:=0
nTOTMD := 0
cTITULO:= 'Resumo da Eficacia Comercial por Estado (Kg)'

while UF->(!eof()) .and. UF->UF <= mv_par02

   /*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     ³ Imprime cabecalho do relatorio      ³
     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   */

   nLIN := cabec( cTITULO, '', '',cNOMREL, 'G', 15 )
   @ prow()+1,000       pSay padc( cCAB, 220 )
   @ prow()+1,000       pSay padc('De '+DTOC(dINI)+' ate '+DTOC(dFIN), 220 )
   @ prow()+2,000       pSay repl( '*', 220 )
   @ prow()+1,000       pSay 'UF'
   @ prow()  ,pcol()+25 pSay '--'+aMES[01,1]+'---'
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

   while UF->(!eof()) .and. UF->UF <= mv_par02 .and. prow() <= 58
      nCONT := Ascan( aEST, { |X| X[1] == UF->UF } )
      @ prow()+2,000 pSay UF->UF+' - '+aEST[nCONT,2]
      if nMIDIA==2
         @ prow(),000 pSay UF->UF+' - '+aEST[nCONT,2]
      endif

      nMEDIA := UF->MS01+UF->MS02+UF->MS03+UF->MS04+UF->MS05+UF->MS06+;
                UF->MS07+UF->MS08+UF->MS09+UF->MS10+UF->MS11+UF->MS12
      nTOTMD := nTOTMD + nMEDIA
      nTOTAL := nMEDIA
      nMEDIA := nMEDIA / 12
      nMES01 := nMES01 + UF->MS01
      nMES02 := nMES02 + UF->MS02
      nMES03 := nMES03 + UF->MS03
      nMES04 := nMES04 + UF->MS04
      nMES05 := nMES05 + UF->MS05
      nMES06 := nMES06 + UF->MS06
      nMES07 := nMES07 + UF->MS07
      nMES08 := nMES08 + UF->MS08
      nMES09 := nMES09 + UF->MS09
      nMES10 := nMES10 + UF->MS10
      nMES11 := nMES11 + UF->MS11
      nMES12 := nMES12 + UF->MS12


      @ prow()  ,pcol()+02 pSay UF->MS01 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay UF->MS02 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay UF->MS03 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay UF->MS04 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay UF->MS05 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay UF->MS06 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay UF->MS07 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay UF->MS08 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay UF->MS09 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay UF->MS10 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay UF->MS11 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+02 pSay UF->MS12 Picture '@E 9999,999.99'
      @ prow()  ,pcol()+04 pSay nMEDIA   Picture '@E 9999,999.99'
      @ prow()  ,pcol()+04 pSay nTOTAL   Picture '@E 99,999,999.99'

      UF->(dbskip())
      IncRegua()

   end

end

@ prow()+3,000 pSay 'Total geral ------------>'
if nMIDIA==2
   @ prow()+3,000 pSay 'Total geral ------------>'
endif

nTOTAL := nTOTMD
nMEDIA := nTOTMD/12

@ prow()  ,pcol()+02 pSay nMES01 Picture '@E 9999,999.99'
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
UF->( dbclosearea() )
return





