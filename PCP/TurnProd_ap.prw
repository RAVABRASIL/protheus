#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "topconn.ch"       // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function TURNPROD()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt( "NORDEM,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3," )
SetPrvt( "ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA," )
SetPrvt( "NLIN,WNREL,M_PAG,CABEC1,CABEC2,MPAG," )

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/08/02 ==>   #DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³  TURNPROD  ³ Autor ³   Mauricio Barros    ³ Data ³11/10/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acompanhamento de producao por turno                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Cliente Rava Embalagens                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da data                              ³
//³ mv_par02             // Ate a data                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

tamanho   := "M"
titulo    := "ACOMPANHAMENTO DE PRODUCAO POR TURNO"
cDesc1    := "Este programa ira emitir o acompanhamento de"
cDesc2    := "producao por maquina/turno."
cDesc3    := ""
cNatureza := ""
aReturn   := { "Producao", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "TURNPROD"
cPerg     := "TURPRD"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "TURNPROD"
M_PAG     := 1


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Validperg()
Pergunte( cPerg, .F. )               // Pergunta no SX1

cString := "Z00"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint( cString, wnrel, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho )

cXFilial  := iif(MV_PAR03=1,'01','03')

If nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault( aReturn, cString )

If nLastKey == 27
   Return
Endif

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

cTURNO1   := GetMv( "MV_TURNO1" )
cTURNO2   := GetMv( "MV_TURNO2" )
cTURNO3   := GetMv( "MV_TURNO3" )

cTURNO1_A := Left( cTURNO1, 5 ) + "," + SubStr( cTURNO1, 7, 5 )  
cTURNO2_A := Left( cTURNO2, 5 ) + "," + SubStr( cTURNO2, 7, 5 )
cTURNO3_A := Left( cTURNO3, 5 ) + "," + SubStr( cTURNO3, 7, 5 )

/*
cTURNO1_A := Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO1, 7, 5 )  // Soma 15 minutos p/ apara
cTURNO2_A := Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO2, 7, 5 )
cTURNO3_A := Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO3, 7, 5 )
*/

Cabec1 := "MAQ  TURNO  OP           DT.INICIO   PRODUTO    PROD.(KG)     PROD.(MR)  AP.COMUM(KG)  AP.COMUM(%)  AP.SACOLA(KG)  AP.SACOLA(%)"
//         XXX    X    XXXXXXXXXXX  XX/XX/XX    XXXXXXXXX  99,999.99  9,999,999.99     99,999.99       999.99      99,999.99        999.99
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456701234567890123456789012345678901234567890123456789
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16      17        18        19        20        21
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa regua de impressao                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQUERY := "SELECT Z00.Z00_OP,Z00.Z00_MAQ,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF "
cQUERY += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQUERY += "WHERE Z00.Z00_DATA >= '" + Dtos( mv_par01 ) + "' AND Z00.Z00_DATA <= '" + Dtos( mv_par02 + 1 ) + "' AND "
cQUERY += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
IF MV_PAR03=01  // SACO 
   cQuery += "and SUBSTRING(Z00.Z00_MAQ,1,2)  IN ('C0','C1','P0','S0','E0','I0')
ELSE // CAIXA 
   cQuery += "and Z00_MAQ IN ( 'CX','ICVR','MONT','CVP','PLAST','DOB','LA01','FC01','SEL','CVFEVA','TRIMAQ') "
ENDIF
cQuery += "AND Z00.Z00_MAQ!='XXX' " // COLOCADO EM 03/06/09 
cQUERY += "ORDER BY Z00.Z00_MAQ,Z00.Z00_OP,Z00.Z00_DATA,Z00.Z00_HORA "
cQUERY := ChangeQuery( cQUERY )
TCQUERY cQUERY NEW ALIAS "Z00X"

TCSetField( 'Z00X', "Z00_DATA", "D" )

nQTDKG2 := nQTDKG3 := 0
nQTDMR2 := nQTDMR3 := 0
nAPARC2 := nAPARC3 := 0
nAPARS2 := nAPARS3 := 0
nOP2    := nOP3    := 0
Z00X->( DBGoTop() )
SetRegua( Lastrec() )
mPag := 1

TITULO := AllTrim( TITULO ) + " - " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 )
Cabec( titulo, cabec1, "", nomeprog, tamanho, 18 )  // Impressao do cabecalho
Do While ! Z00X->( Eof() )
 if !EMPTY(Z00X->Z00_MAQ)	 
	 cMAQ    := Z00X->Z00_MAQ
	 nQTDKG1 := 0
	 nQTDMR1 := 0
	 nAPARC1 := 0
	 nAPARS1 := 0
	 nOP1    := 0
	 aMAQ    := {}
	 Do While ! Z00X->( Eof() ) .and. Z00X->Z00_MAQ == cMAQ
			If Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
				 VerifMaq( "1" )
			ElseIf Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
				 VerifMaq( "2" )
			ElseIf ( Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		 	 ( Z00X->Z00_DATA >= mv_par01 + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
 				 VerifMaq( "3" )
			EndIf
			Z00X->( DbSkip() )
  		IncRegua()
	 EndDo
	 nSOMA := 0
	 AEval( aMAQ, { |x| nSOMA += X[ 5 ] + X[ 6 ] + X[ 7 ] + X[ 8 ] } )
	 If Empty( nSOMA )
			Loop
	 EndIf
	 aMAQ := Asort( aMAQ,,, { |X,Y| X[ 1 ] + Dtos( X[ 3 ] ) < Y[ 1 ] + Dtos( Y[ 3 ] ) } )
	 @ Prow() + 2,000 PSAY Left( cMAQ, 3 )
	 nCONT := 1
	 Do While nCONT <= Len( aMAQ )
			cTURNO := aMAQ[ nCONT, 1 ]
			lTURNO := .T.
			Do While nCONT <= Len( aMAQ ) .and. cTURNO == aMAQ[ nCONT, 1 ]
	
 	     		If Prow() > 55 .and. nCONT <= Len( aMAQ ) .and. cTURNO == aMAQ[ nCONT, 1 ]
	     		   Cabec( TITULO, cabec1, "", nomeprog, tamanho, 18 )  // Impressao do cabecalho
			 			 @ Prow() + 2,000 PSAY Left( cMAQ, 3 )
						 lTURNO := .T.
	     		EndIf   
	     		
					If lTURNO
	 		 		   @ Prow()    ,007 PSAY cTURNO
						 lTURNO := .F.
					EndIf

			 		@ Prow()    ,012 PSAY aMAQ[ nCONT, 2 ]
			 		@ Prow()    ,025 PSAY aMAQ[ nCONT, 3 ]
			 		@ Prow()    ,037 PSAY Left( aMAQ[ nCONT, 4 ], 9 )
	 		 		@ Prow()    ,048 PSAY aMAQ[ nCONT, 5 ] Picture "@E 99,999.99"
			 		@ Prow()    ,059 PSAY aMAQ[ nCONT, 6 ] Picture "@E 9,999,999.99"
			 		@ Prow()    ,076 PSAY aMAQ[ nCONT, 7 ] Picture "@E 99,999.99"
			 		@ Prow()    ,092 PSAY aMAQ[ nCONT, 7 ] / (aMAQ[ nCONT, 5 ]+aMAQ[ nCONT, 7 ] ) * 100 Picture "@E 999.99" //aMAQ[ nCONT, 7 ] / aMAQ[ nCONT, 5 ] * 100 Picture "@E 999.99"
			 		@ Prow()    ,104 PSAY aMAQ[ nCONT, 8 ] Picture "@E 99,999.99"
			 		@ Prow()    ,121 PSAY aMAQ[ nCONT, 8 ] / (aMAQ[ nCONT, 5 ]+aMAQ[ nCONT, 8 ]) * 100 Picture "@E 999.99" //aMAQ[ nCONT, 8 ] / aMAQ[ nCONT, 5 ] * 100 Picture "@E 999.99"
				  @ Prow() + 1,000 PSAY " "
	 		 		nQTDKG1 += aMAQ[ nCONT, 5 ]
	 		 		nQTDKG2 += aMAQ[ nCONT, 5 ]
	 		 		nQTDKG3 += aMAQ[ nCONT, 5 ]
	 		 		nQTDMR1 += aMAQ[ nCONT, 6 ]
	 		 		nQTDMR2 += aMAQ[ nCONT, 6 ]
	 		 		nQTDMR3 += aMAQ[ nCONT, 6 ]
	 		 		nAPARC1 += aMAQ[ nCONT, 7 ]
	 		 		nAPARC2 += aMAQ[ nCONT, 7 ]
	 		 		nAPARC3 += aMAQ[ nCONT, 7 ]
	 		 		nAPARS1 += aMAQ[ nCONT, 8 ]
	 		 		nAPARS2 += aMAQ[ nCONT, 8 ]
	 		 		nAPARS3 += aMAQ[ nCONT, 8 ]
					nOP1++
			 		nOP2++
			 		nOP3++
			 		nCONT++
/* 
 	     		If Prow() > 55 .and. nCONT <= Len( aMAQ ) .and. cTURNO == aMAQ[ nCONT, 1 ]
	     		   Cabec( TITULO, cabec1, "", nomeprog, tamanho, 18 )  // Impressao do cabecalho
			 			 @ Prow() + 2,000 PSAY Left( cMAQ, 3 )
						 lTURNO := .T.
	     		EndIf                 */
			EndDo
  			
	     		If Prow() > 55 
	     		   Cabec( TITULO, cabec1, "", nomeprog, tamanho, 18 )  // Impressao do cabecalho
	     		EndIf
				
			@ Prow()    ,012 PSAY Repl( "-", 120 )
			@ Prow() + 1,012 PSAY "TOTAL DO TURNO " + cTURNO
			@ Prow()    ,037 PSAY nOP1 Picture "@E 9999"
			@ Prow()    ,047 PSAY nQTDKG1 Picture "@E 999,999.99"
			@ Prow()    ,058 PSAY nQTDMR1 Picture "@E 99,999,999.99"
			@ Prow()    ,075 PSAY nAPARC1 Picture "@E 999,999.99"
			@ Prow()    ,092 PSAY nAPARC1 / ( nQTDKG1+nAPARC1 ) * 100 Picture "@E 999.99" // nAPARC1 / nQTDKG1 * 100 Picture "@E 999.99"
			@ Prow()    ,103 PSAY nAPARS1 Picture "@E 999,999.99"
			@ Prow()    ,121 PSAY nAPARS1 / ( nQTDKG1+nAPARS1 ) * 100 Picture "@E 999.99" //nAPARS1 / nQTDKG1 * 100 Picture "@E 999.99"
			@ Prow() + 2,000 PSAY " "
	 		nQTDKG1 := 0
	 		nQTDMR1 := 0
	 		nAPARC1 := 0
	 		nAPARS1 := 0
			nOP1    := 0
	 EndDo
	     		If Prow() > 55 
	     		   Cabec( TITULO, cabec1, "", nomeprog, tamanho, 18 )  // Impressao do cabecalho
	     		EndIf

		@ Prow()    ,012 PSAY Repl( "-", 120 )
		@ Prow() + 1,012 PSAY "TOTAL DA MAQUINA " + cMAQ
		@ Prow()    ,037 PSAY nOP2 Picture "@E 9999"
		@ Prow()    ,047 PSAY nQTDKG2 Picture "@E 999,999.99"
		@ Prow()    ,058 PSAY nQTDMR2 Picture "@E 99,999,999.99"
		@ Prow()    ,075 PSAY nAPARC2 Picture "@E 999,999.99"
		@ Prow()    ,092 PSAY nAPARC2 / (nQTDKG2 + nAPARC2 )* 100 Picture "@E 999.99" //nAPARC2 / nQTDKG2* 100 Picture "@E 999.99"
		@ Prow()    ,103 PSAY nAPARS2 Picture "@E 999,999.99"
		@ Prow()    ,121 PSAY nAPARS2 / (nQTDKG2 + nAPARS2 ) * 100 Picture "@E 999.99" //nAPARS2 / nQTDKG2 * 100 Picture "@E 999.99"
		nQTDKG2 := 0
		nQTDMR2 := 0
		nAPARC2 := 0
		nAPARS2 := 0
		nOP2    := 0
  Else
  Z00X->( DbSkip() )
 EndIf
Enddo

	     		If Prow() > 55 
	     		   Cabec( TITULO, cabec1, "", nomeprog, tamanho, 18 )  // Impressao do cabecalho
						 lTURNO := .T.
	     		EndIf

@ Prow() + 1,000 PSAY Repl( "-", 132 )
@ Prow() + 1,012 PSAY "TOTAL GERAL"
@ Prow()    ,037 PSAY nOP3 Picture "@E 9999"
@ Prow()    ,047 PSAY nQTDKG3 Picture "@E 999,999.99"
@ Prow()    ,058 PSAY nQTDMR3 Picture "@E 99,999,999.99"
@ Prow()    ,075 PSAY nAPARC3 Picture "@E 999,999.99"
@ Prow()    ,092 PSAY nAPARC3 / (nQTDKG3+nAPARC3) * 100 Picture "@E 999.99" //nAPARC3 / nQTDKG3 * 100 Picture "@E 999.99"
@ Prow()    ,103 PSAY nAPARS3 Picture "@E 999,999.99"
@ Prow()    ,121 PSAY nAPARS3 / (nQTDKG3+nAPARS3) * 100 Picture "@E 999.99"  //nAPARS3 / nQTDKG3 * 100 Picture "@E 999.99"
Z00X->( DbCloseArea() )
Roda( 0, "", TAMANHO )

If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao
Endif
Return NIL



***************

Static Function ValidPerg()

***************
PutSx1( cPerg, '01', 'Da Data            ?', '', '', 'mv_ch1', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par01', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
PutSx1( cPerg, '02', 'Ate a Data         ?', '', '', 'mv_ch2', 'D', 8, 0, 0, 'G', '', ''   , '', '', 'mv_par02', '', '', '',;
        '' , '', '', '', '', '', '', '', '', '', '', '', '', {}, {}, {} )
/*_sAlias := Alias()
dbSelectArea( "SX1" )
dbSetOrder( 1 )
cPerg := PADR( cPerg, 6 )
aRegs := {}
AADD(aRegs,{cPerg,"01","Da Data            ?","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
AADD(aRegs,{cPerg,"02","Ate a Data         ?","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
For i:=1 to Len( aRegs )
    If ! dbSeek( cPerg + aRegs[ i, 2 ] )
   		 RecLock( "SX1", .T. )
		   For j := 1 to FCount()
			     FieldPut( j, aRegs[ i, j ] )
		   Next
		   MsUnlock()
       dbCommit()
	  Endif
Next
dbSelectArea( _sAlias )*/
Return NIL



**************

Static Function VerifMaq( cTURNO )

**************

If ( nPOS := Ascan( aMAQ, { |X| X[1] == cTURNO .and. X[2] == Z00X->Z00_OP } ) ) > 0
	 If Z00X->Z00_APARA = " "
	 		aMAQ[ nPOS, 5 ] += Z00X->Z00_PESO + Z00X->Z00_PESCAP //Z00X->Z00_PESO + Z00X->Z00_PESDIF + Z00X->Z00_PESCAP
	 		aMAQ[ nPOS, 6 ] += Z00X->Z00_QUANT
	 Else
 			If Z00X->Z00_APARA # "W"//If Z00X->Z00_APARA $ "12"
				 aMAQ[ nPOS, 7 ] += Z00X->Z00_PESO
			Else
				 aMAQ[ nPOS, 8 ] += Z00X->Z00_PESO
			EndIf
	 EndIf
Else
SC2->( DbSeek( cXFilial + Z00X->Z00_OP, .T. ) )   //SC2->( DbSeek( xFilial( "SC2" ) + Z00X->Z00_OP, .T. ) )
	 Aadd( aMAQ, { cTURNO, Z00X->Z00_OP, Z00X->Z00_DATA, SC2->C2_PRODUTO, 0, 0, 0, 0 } )
	 If Z00X->Z00_APARA = " "
	 		aMAQ[ Len( aMAQ ), 5 ] += Z00X->Z00_PESO + Z00X->Z00_PESCAP //Z00X->Z00_PESO + Z00X->Z00_PESDIF + Z00X->Z00_PESCAP
	 		aMAQ[ Len( aMAQ ), 6 ] += Z00X->Z00_QUANT
	 Else
 			If Z00X->Z00_APARA # "W"//If Z00X->Z00_APARA $ "12"
				 aMAQ[ Len( aMAQ ), 7 ] += Z00X->Z00_PESO
			Else
				 aMAQ[ Len( aMAQ ), 8 ] += Z00X->Z00_PESO
			EndIf
	 EndIf
EndIf
Return NIL



**************

User Function SomaHora( _cHora1, _cHora2 )

**************

Local _nHr1,_nMi1,nSg1,_nHr2,_nMi2,nSg2,_nRs1,_nRs2,_nRs3,_cRes

_nHr1 := Val(  Subst(_cHora1,1,2)  )
_nMi1 := Val(  Subst(_cHora1,4,2)  )
_nSg1 := Val(  Subst(_cHora1,7,2)  )
_nHr2 := Val(  Subst(_cHora2,1,2)  )
_nMi2 := Val(  Subst(_cHora2,4,2)  )
_nSg2 := Val(  Subst(_cHora2,7,2)  )

_nRs3 := _nSg1 + _nSg2
If _nRs3 >= 60
	_nRs3 := _nRs3 - 60
	_nMi1++
EndIf

_nRs2 := _nMi1 + _nMi2
If _nRs2 >= 60
	_nRs2 := _nRs2 - 60
	_nHr1++
EndIf

_nRs1 := _nHr1 + _nHr2
If _nRs1 >= 24
	_nRs1 := _nRs1 - 24
EndIf
_cRes := StrZero(_nRs1,2)+":"+StrZero(_nRs2,2)+":"+StrZero(_nRs3,2)
Return(  _cRes  )
