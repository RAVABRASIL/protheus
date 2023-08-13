#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function ESTMOV()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt ("cbTxt, cbCont, nOrdem, Alfa, Z, M " )
SetPrvt ("Ctamanho, cDesc1, cDesc2, cDesc3 " )
SetPrvt ("cNatureza, aReturn, nomeprog, cPerg " )
SetPrvt ("nLastKey, lContinua, cNOMREL, M_Pag, cabec1, cabec2 " )


Private aArray := {}
Private aCabec:={"PRODUTO","/-DATA-\","DOCUMENTO","OP","SEQUENCIA","ENTRADA","SAIDA","SALDO"}


#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  ESTMOV     ³ Autor ³   Mauricio Barros  ³ Data ³ 26/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ RELATORIO MOVIMENTACAO DIARIA DE ESTOQUE                   ³±±
±±                                                                        ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        	// Data Inicial                             ³
//³ mv_par02        	// Data Final                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CbTxt    := ""
CbCont   := ""
nOrdem   := 0
Alfa     := 0
Z        := 0
M        := 0
ctamanho := "M"

cDesc1    := "Este programa ira emitir relacao da movimentacao"
cDesc2    := "do estoque."
cDesc3    := ""
cNatureza := ""
aReturn   := {"Estoque", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "ESTMOV"
cPerg     := "ESTMOV"
nLastKey  := 0
lContinua := .T.
cNOMREL   := "ESTMOV"
M_PAG     := 1
cString   := "SD3"
ctitulo   := "Movimentacao do estoque"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE( 10 )
cbcont   := 0
nLin     := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte( cPerg, .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cNOMREL := SetPrint( cString, cNOMREL, cPerg, @ctitulo, cDesc1, cDesc2, cDESC3, .F., "",, cTamanho )
If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif

#IFDEF WINDOWS
   RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    RptStatus({|| Execute(RptDetail)})
   Return

// Substituido pelo assistente de conversao do AP5 IDE em 19/08/02 ==>    Function RptDetail
Static Function RptDetail()
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalho                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cabec1  := "PRODUTO      SALDO INICIAL   /-0ATA-\   DOCUMENTO   OP               ENTRADA          SAIDA           SALDO"
          //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
          //         10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
          //9999999999   9999,999.9999   XX/XX/XX   999999999   99999999   9999,999.9999   9999,999.999   9999,999.9999
cabec2  := ""
SF4->( dbSetorder( 1 ) )
SD1->( dbSetorder( 7 ) )
SD2->( dbSetorder( 6 ) )
SD3->( dbSetorder( 7 ) )
SB1->( DbGotop() )
nREGTOT := SB1->( Lastrec() )
SetRegua( nREGTOT )
nLIN    := Cabec( AllTrim( cTITULO ) + " - " + Dtoc( MV_PAR01 ) + " a " + Dtoc( MV_PAR02 ), cABEC1, CABEC2, cNOMREL, cTAMANHO, 15 ) + 1
Do While ! SB1->( Eof() )
   If SB1->B1_TIPO >= MV_PAR03 .and. SB1->B1_TIPO <= MV_PAR04 .and. SB1->B1_COD >= MV_PAR05 .and. SB1->B1_COD <= MV_PAR06
      aPROD  := {}
      /*
      aESTOQ := CalcEst( SB1->B1_COD, SB1->B1_LOCPAD, MV_PAR01 ) +;
                CalcEst( SB1->B1_COD, '02', MV_PAR01 ) //Incluido em 22/10/2007
        */
      nSALDO := nSALDOI := 0 //aESTOQ[ 1 ]
      SD1->( dbseek( xFilial("SD1") + SB1->B1_COD + SB1->B1_LOCPAD + Dtos( MV_PAR01 ), .T. ) )
      Do While SD1->D1_COD + SD1->D1_LOCAL == SB1->B1_COD + SB1->B1_LOCPAD .and. SD1->D1_DTDIGIT <= MV_PAR02
         If SF4->( dbseek( xFilial("SF4") + SD1->D1_TES ) ) .and. SF4->F4_ESTOQUE == "S"
             Aadd( aPROD, { SB1->B1_COD, SD1->D1_DTDIGIT, SD1->D1_DOC + SD1->D1_SERIE, " ", SD1->D1_NUMSEQ, SD1->D1_QUANT, 0 } )
             Aadd( aArray, { SB1->B1_COD, SD1->D1_DTDIGIT, SD1->D1_DOC + SD1->D1_SERIE, " ", SD1->D1_NUMSEQ, SD1->D1_QUANT, 0,0 } )         
         EndIf
         SD1->( DbSkip() )
      EndDo
      SD2->( dbseek( xFilial("SD2") + SB1->B1_COD + SB1->B1_LOCPAD + Dtos( MV_PAR01 ), .T. ) )
      Do While SD2->D2_COD + SD2->D2_LOCAL == SB1->B1_COD + SB1->B1_LOCPAD .and. SD2->D2_EMISSAO <= MV_PAR02
         If SF4->( dbseek( xFilial("SF4") + SD2->D2_TES ) ) .and. SF4->F4_ESTOQUE == "S"
             Aadd( aPROD, { SB1->B1_COD, SD2->D2_EMISSAO, SD2->D2_DOC + SD2->D2_SERIE, " ", SD2->D2_NUMSEQ, 0, SD2->D2_QUANT } )
             Aadd( aArray, { SB1->B1_COD, SD2->D2_EMISSAO, SD2->D2_DOC + SD2->D2_SERIE, " ", SD2->D2_NUMSEQ, 0, SD2->D2_QUANT,0 } )
         EndIf
         SD2->( DbSkip() )
      EndDo
      SD3->( dbseek( xFilial("SD3") + SB1->B1_COD + SB1->B1_LOCPAD + Dtos( MV_PAR01 ), .T. ) )
      Do While SD3->D3_COD + SD3->D3_LOCAL == SB1->B1_COD + SB1->B1_LOCPAD .and. SD3->D3_EMISSAO <= MV_PAR02
         If SD3->D3_TM > "500"
            Aadd( aPROD, { SB1->B1_COD, SD3->D3_EMISSAO, SD3->D3_DOC, Left( SD3->D3_OP, 8 ), SD3->D3_NUMSEQ, 0, SD3->D3_QUANT } )
            Aadd( aArray, { SB1->B1_COD, SD3->D3_EMISSAO, SD3->D3_DOC, Left( SD3->D3_OP, 6 ), SD3->D3_NUMSEQ, 0, SD3->D3_QUANT,0 } )
         Else
            Aadd( aPROD, { SB1->B1_COD, SD3->D3_EMISSAO, SD3->D3_DOC, Left( SD3->D3_OP, 8 ), SD3->D3_NUMSEQ, SD3->D3_QUANT, 0 } )
            Aadd( aArray, { SB1->B1_COD, SD3->D3_EMISSAO, SD3->D3_DOC, Left( SD3->D3_OP, 6 ), SD3->D3_NUMSEQ, SD3->D3_QUANT, 0,0 } )            
         EndIf
         SD3->( DbSkip() )
      EndDo
      If ! Empty( aPROD )
          aPROD := Asort( aPROD,,, { |X,Y| X[1] + Dtos( x[2] ) + X[5] < Y[1] + Dtos( Y[2] ) + Y[5] } )
          aArray := Asort( aArray,,, { |X,Y| X[1] + Dtos( x[2] ) + X[5] < Y[1] + Dtos( Y[2] ) + Y[5] } )          
          
          @ nLIN,000 Psay Left( aPROD[ 1, 1 ], 10 )
          @ nLIN,013 Psay nSALDO Picture "@E 9999,999.9999"
          For i := 1 To Len( aPROD )
              @ nLIN,029 Psay aPROD[ i, 2 ]
              @ nLIN,040 Psay aPROD[ i, 3 ]
              @ nLIN,052 Psay aPROD[ i, 4 ]
              @ nLIN,063 Psay aPROD[ i, 6 ] Picture "@E 9999,999.9999"
              @ nLIN,079 Psay aPROD[ i, 7 ] Picture "@E 9999,999.9999"
              nSALDO := nSALDO + aPROD[ i, 6 ] - aPROD[ i, 7 ]
              
              @ nLIN++,094 Psay nSALDO Picture "@E 9999,999.9999"
              If nLIN > 60
                 nLIN := Cabec( AllTrim( cTITULO ) + " - " + Dtoc( MV_PAR01 ) + " a " + Dtoc( MV_PAR02 ), cABEC1, CABEC2, cNOMREL, cTAMANHO, 15 ) + 1
                 If i + 1 <= Len( aPROD ) .and. aPROD[ i, 1 ] == aPROD[ i + 1, 1 ]
                    @ nLIN,000 Psay Left( aPROD[ i, 1 ], 10 )
                    @ nLIN,013 Psay nSALDOI Picture "@E 9999,999.9999"
                 EndIf
              EndIf
          Next
          nLIN++
      EndIf
   EndIf
   IncRegua()
   SB1->( DbSkip() )
EndDo
/*----------------------------------------------------------------
  FINALIZAÇÃO DA IMPRESSÃO DO RELATÓRIO
  ----------------------------------------------------------------
*/
Roda( 0, Space( 10 ), cTAMANHO )

if MV_PAR07=1 // EXCEL SIM 

	FOR I:=1 TO LEN(aArray)
	
	IF i>1
		aArray[ i, 8 ]:=IIF(aArray[ i-1, 1 ]=aArray[ i, 1 ],aArray[ i-1, 8 ],0) + aArray[ i, 6 ] - aArray[ i, 7 ]
	else
		aArray[ i, 8 ]:=aArray[ i, 6 ] - aArray[ i, 7 ]
	ENDIF
	
	Next
	
	
	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"ARRAY","Relacao de Movimentacao ",aCabec, aArray}})})
	If !ApOleClient("MSExcel")
		MsgAlert("Microsoft Excel não instalado!")
		Return()
	EndIf
	
ENDIF

If aReturn[ 5 ] == 1
   dbCommitAll()
   ourspool( cNOMREL )
Endif

MS_FLUSH()
