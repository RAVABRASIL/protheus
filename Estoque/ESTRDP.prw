#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#include "topconn.ch"       // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF
*************
User Function ESTRDP()        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
*************
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
±±³Programa ³  TURNPROD  ³ Autor ³   Emmanuel Lacerda   ³ Data ³09/05/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acompanhamento de producao por periodo                     ³±±
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
titulo    := "PRODUCAO POR PERIODO "
cDesc1    := "Este programa ira emitir o resumo de"
cDesc2    := "producao por maquina/dia."
cDesc3    := ""
cNatureza := ""
aReturn   := { "Producao", 1, "Administracao", 1, 2, 1, "", 1 }
nomeprog  := "ESTRDP"
cPerg     := "TURPRD"
nLastKey  := 0
lContinua := .T.
nLin      := 9
wnrel     := "ESTRDP"
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
#ENDIF

***************

Static Function RptDetail()

***************

Local aResultEX := {}
Local aResultCS := {}
Local nTotKgCS := nTotApCS := 0
Local nTotKgEX := nTotApEX := 0
Local nMedExt := nMedCS := 0
Local nDif := 0
Local dTMP
Local aArrf := {}
Local nTKGEX :=	nTAPEX := nTTAPEX := nTKGCS := nTAPCS := nTTAPCS :=	nCount := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  de variaveis                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTURNO1   := GetMv( "MV_TURNO1" )
cTURNO2   := GetMv( "MV_TURNO2" )
cTURNO3   := GetMv( "MV_TURNO3" )
cTURNO1_A := Left( cTURNO1, 5 ) + "," + SubStr( cTURNO1, 7, 5 )  
cTURNO2_A := Left( cTURNO2, 5 ) + "," + SubStr( cTURNO2, 7, 5 )
cTURNO3_A := Left( cTURNO3, 5 ) + "," + SubStr( cTURNO3, 7, 5 )

Cabec1 := " DATA DA    /-------------------  EXTRUSAO ------------------\  /------------------- CORTE/SOL.------------------\"
Cabec2 := " PRODUCAO           (KG)            APARA(KG)         APARA(%)          (KG)            APARA(KG)         APARA(%)"
Cabec3 := "                    (KG)            APARA(KG)         APARA(%)          (KG)            APARA(KG)         APARA(%)"
//          xx/xx/xx    9,999,999.99          9,999,999.99                 99.99
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
//         0         1         2         3         4         5         6         7         8         9        10        11

TITULO 		:= AllTrim( TITULO ) + " - " + Dtoc( MV_PAR01 ) + " A " + Dtoc( MV_PAR02 )
aResultEX := Query('EXT')
aResultCS := Query('')

if len(aResultEX) > 0 .OR. len(aResultCS) > 0
	if len(aResultEX) > len(aResultCS)
		for X := 1 to len(aResultEX)
			aAdd( aArrf, { aResultEX[X][1], aResultEX[X][2], aResultEX[X][3], aResultEX[X][4], 0, 0, dTMP, '' } )
		next

		if len( aResultCS ) > 0
			for Z := 1 to len( aResultCS )
				if ( nIdx := aScan( aArrf, { |X| X[3] == aResultCS[Z][3] } ) ) > 0
					aArrf[nIdx][5] := aResultCS[Z][1]
					aArrf[nIdx][6] := aResultCS[Z][2]
					aArrf[nIdx][7] := aResultCS[Z][3]
					aArrf[nIdx][8] := aResultCS[Z][4]
				else
					aAdd( aArrf, { 0, 0, aResultCS[Z][3], 'CES', aResultCS[Z][1], aResultCS[Z][2], aResultCS[Z][3], aResultCS[Z][4] } )
				endIf
			next

		endIf
	else
		for X := 1 to len(aResultCS)
			aAdd( aArrf, {  0, 	0, aResultCS[X][3], 'CES', aResultCS[X][1], aResultCS[X][2], aResultCS[X][3], aResultCS[X][4] } )
		next

		if len( aResultEX ) > 0
			for Z := 1 to len( aResultEX )
				if ( nIdx := aScan( aArrf, { |X| X[7] == aResultEX[Z][3] } ) ) > 0
					aArrf[nIdx][1] := aResultEX[Z][1]
					aArrf[nIdx][2] := aResultEX[Z][2]
					aArrf[nIdx][3] := aResultEX[Z][3]
					aArrf[nIdx][4] := aResultEX[Z][4]
				else
					aAdd( aArrf, { aResultEX[Z][1], aResultEX[Z][2], aResultEX[Z][3], aResultEX[Z][4], 0, 0, aResultEX[Z][3], 'CES'  } )
				endIf
			next

		endIf

	endIf

endIf
Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
Asort( aArrf,,, { | x, y | x[ 3 ] < y[ 3 ] } )
				//"     QUANT  /-------------------  EXTRUSAO ------------------\  /------------------- CORTE/SOL.------------------\"
        //"DIA  PROD.          (KG)            APARA(KG)         APARA(%)          (KG)            APARA(KG)         APARA(%)"
			  //"     PROD.          (KG)            APARA(KG)         APARA(%)          (KG)            APARA(KG)         APARA(%)"
//          xx/xx/xx   9,999,999.99         9,999,999.99            99.99  9,999,999.99         9,999,999.99            99.99
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
//         0         1         2         3         4         5         6         7         8         9        10        11

if len(aArrf) > 0
	SetRegua( len(aArrf) )
	for I := 1 to len(aArrf)
		if aArrf[I][3] <= mv_par02
			if Prow() > 55
	  		Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	  	endif
			@ Prow() + 1, 001 PSAY aArrf[I][3]
			@ Prow()    , 012 PSAY aArrf[I][1] Picture "@E 9,999,999.99"
			@ Prow()    , 033 PSAY aArrf[I][2] Picture "@E 9,999,999.99"
			@ Prow()    , 054 PSAY ( aArrf[I][2]/( aArrf[I][2] + aArrf[I][1] ) ) * 100 Picture "@E 99.99"
			@ Prow()    , 064 PSAY aArrf[I][5] Picture "@E 9,999,999.99"
			@ Prow()    , 085 PSAY aArrf[I][6] Picture "@E 9,999,999.99"
			@ Prow()    , 109 PSAY ( aArrf[I][6]/( aArrf[I][6] + aArrf[I][5] ) ) * 100 Picture "@E 99.99"
			nTKGEX  += aArrf[I][1]
			nTAPEX  += aArrf[I][2]
			//nTTAPEX += ( aArrf[I][2]/( aArrf[I][2] + aArrf[I][1] ) )
			//nTTAPEX += ( nTAPEX/( nTAPEX + nTKGEX ) )
			nTKGCS  += aArrf[I][5]
			nTAPCS  += aArrf[I][6]
			//nTTAPCS += ( aArrf[I][6]/( aArrf[I][6] + aArrf[I][5] ) )
			//nTTAPCS += ( nTAPCS/( nTAPCS + nTKGCS ) )
			nCount++
			incRegua()
		endIf
	next

	if Prow() > 55
		Cabec( titulo, cabec1, cabec2, nomeprog, tamanho, 15 )  // Impressao do cabecalho
	endif
    nTTAPEX := ( nTAPEX / ( nTAPEX + nTKGEX ) ) * 100
    nTTAPCS := ( nTAPCS / ( nTAPCS + nTKGCS ) ) * 100
	@ Prow() + 2 ,001 PSAY "Total: "
	@ Prow()		 ,012 PSAY nTKGEX  Picture "@E 9,999,999.99"
	@ Prow()		 ,033 PSAY nTAPEX  Picture "@E 9,999,999.99"
	@ Prow()		 ,054 PSAY nTTAPEX Picture "@E 99.99"
	@ Prow()		 ,064 PSAY nTKGCS  Picture "@E 9,999,999.99"
	@ Prow()		 ,085 PSAY nTAPCS  Picture "@E 9,999,999.99"
	@ Prow()		 ,109 PSAY nTTAPCS Picture "@E 99.99"
    nMedExt := ( ( nTAPEX/nCount ) / ( ( nTAPEX/nCount ) + ( nTKGEX/nCount ) ) ) * 100
    nMedCS  := ( ( nTAPCS/nCount ) / ( ( nTAPCS/nCount ) + ( nTKGCS/nCount ) ) ) * 100
	@ Prow() + 1 ,001 PSAY "Media: "
	@ Prow()		 ,012 PSAY nTKGEX/nCount    Picture "@E 9,999,999.99"
	@ Prow()		 ,033 PSAY nTAPEX/nCount    Picture "@E 9,999,999.99"
	@ Prow()		 ,054 PSAY nMedExt          Picture "@E 99.99"//(nTTAPEX/nCount) Picture "@E 99.99"
	@ Prow()		 ,064 PSAY nTKGCS/nCount    Picture "@E 9,999,999.99"
	@ Prow()		 ,085 PSAY nTAPCS/nCount    Picture "@E 9,999,999.99"
	@ Prow()		 ,109 PSAY nMedCS			Picture "@E 99.99"
	@ Prow() + 1 ,001 PSAY "Apara sob extrusão: " + alltrim( transform( ( nTAPCS + nTAPEX )/( nTAPEX + nTKGEX ) * 100, "@E 9,999,999.99") )
else
	@ Prow()+1 ,005 PSAY " *** NAO HOUVE PRODUCAO NESTE PERIODO! ! ! *** "
endIf


Roda( 0, "", TAMANHO )

If aReturn[ 5 ] == 1
   Set Printer To
   Commit
   ourspool( wnrel ) //Chamada do Spool de Impressao
Endif

Return NIL


***************

Static Function Query(cMaqui)

***************
Local aResult := {}
Local cQuery := ''

cQuery := "SELECT Z00.Z00_OP,Z00.Z00_MAQ,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF "
cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQuery += "WHERE Z00.Z00_DATA >= '" + Dtos( mv_par01 ) + "' AND Z00.Z00_DATA <= '" + Dtos( mv_par02 + 1 ) + "' AND "
cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' '  "
                                                                                                         //'EXT' COLOCADO EM 03/09/08 //'XXX' COLOCADO EM 03/06/09 
//cQuery += " " + iif(cMaqui == 'EXT', "and Z00.Z00_MAQ in('E01','E02','E03','E04')", "and Z00.Z00_MAQ NOT in(' ','XXX','EXT','E01','E02','E03','E04')") + " "
//cQuery += " " + iif(cMaqui == 'EXT', "and Z00.Z00_MAQ in('E01','E02','E03','E04')", "and Z00.Z00_MAQ NOT in(' ','XXX','EXT','COST','A01','I01','I02','E01','E02','E03','E04','CX','ICVR','MONT','CVP','PLAST' )") + " "
cQuery += " " + iif(cMaqui == 'EXT', "and Z00.Z00_MAQ LIKE '[E][0123456789]%'", "and Z00.Z00_MAQ LIKE '[CPS][0123456789]%'") + " "
cQuery += "ORDER BY Z00.Z00_DATA "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "Z00X"

TCSetField( 'Z00X', "Z00_DATA", "D" )

NtqtDKG := NtqtDKGe := 0
nTQTDMR := nTQTDMRe := 0
nTAPARA := nTAPARAe := 0
Z00X->( DBGoTop() )
SetRegua( Lastrec() )
mPag := 1

aResult 	:= {}
Do While ! Z00X->( Eof() )
 	dData   := Z00X->Z00_DATA
 	nQTDKG  := nQTDKGe  :=  0
 	nQTDMR  := nQTDMRe  :=  0
 	nAPARA  := nAPARAe  :=  0
 	aOP     := {}
 	nOP     := 0
    nQTDKGCO:=0

 	Do While ! Z00X->( Eof() ) .and. dData == Z00X->Z00_DATA
		If Empty(Z00X->Z00_APARA) //se nao produzir apara
 			If Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
 				nQTDKG  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 				nQTDMR  += Z00X->Z00_QUANT
 				nTQTDKG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 				nTQTDMR += Z00X->Z00_QUANT
                //
                if alltrim(Z00X->Z00_MAQ)='COST'
                   nQTDKGCO+= Z00X->Z00_PESO + Z00X->Z00_PESCAP
                endif
                //
 			ElseIf Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 ) 				
 				nQTDKG  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 				nQTDMR  += Z00X->Z00_QUANT
 				nTQTDKG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 				nTQTDMR += Z00X->Z00_QUANT
                //
                if alltrim(Z00X->Z00_MAQ)='COST'
                   nQTDKGCO+= Z00X->Z00_PESO + Z00X->Z00_PESCAP
                endif
                //
 			ElseIf ( Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
 			 ( Z00X->Z00_DATA >= mv_par01 + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
 				//if Z00X->Z00_HORA >= '00:01' .and. Z00X->Z00_HORA <= '05:46' .and. len(aResult) >= 1
 				if Z00X->Z00_HORA >= '00:00' .and. Z00X->Z00_HORA < Left( cTURNO1_A, 5 )  .and. len(aResult) >= 1
				  	if aResult[len(aResult)][3] == dData - 1
						aResult[len(aResult)][1] += Z00X->Z00_PESO + Z00X->Z00_PESCAP
						//aResult[len(aResult)][2] += Z00X->Z00_QUANT
					endIf
				else
					nQTDKG  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 				 	nQTDMR  += Z00X->Z00_QUANT
 				 	nTQTDKG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
 				 	nTQTDMR += Z00X->Z00_QUANT
				    //
                    if alltrim(Z00X->Z00_MAQ)='COST'
                       nQTDKGCO+= Z00X->Z00_PESO + Z00X->Z00_PESCAP
                    endif
                    //
				endIf

 			EndIf                    
    ElseIf !Empty(Z00X->Z00_APARA) .and. Z00X->Z00_APARA != "W"  //Desprezo apara de Alca.  checa se apara possui 1 ou 2, caso produza apara
 			If Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO1_A, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1_A, 5 ) + ":00", SubStr( cTURNO1_A, 7, 5 ) + ":00" ), 5 )
 				nAPARA  += Z00X->Z00_PESO
 				nTAPARA += Z00X->Z00_PESO
 			ElseIf Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO2_A, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2_A, 5 ) + ":00", SubStr( cTURNO2_A, 7, 5 ) + ":00" ), 5 )
 				nAPARA  += Z00X->Z00_PESO
 				nTAPARA += Z00X->Z00_PESO
 			ElseIf ( Z00X->Z00_DATA <= mv_par02 .and. Z00X->Z00_HORA >= Left( cTURNO3_A, 5 ) ) .or. ;
 			 ( Z00X->Z00_DATA >= mv_par01 + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3_A, 5 ) + ":00", SubStr( cTURNO3_A, 7, 5 ) + ":00" ), 5 ) )
 				//if Z00X->Z00_HORA >= '00:01' .and. Z00X->Z00_HORA <= '05:46' .and. len(aResult) >= 1 
 				if Z00X->Z00_HORA >= '00:00' .and. Z00X->Z00_HORA < Left( cTURNO1_A, 5 )  .and. len(aResult) >= 1
					if aResult[len(aResult)][3] == dData - 1
						aResult[len(aResult)][2] += Z00X->Z00_PESO
					endIf
				else
 					nAPARA  += Z00X->Z00_PESO
 					nTAPARA += Z00X->Z00_PESO
				endIf

 			EndIf
 		EndIf
		Z00X->( DbSkip() )
 	 	IncRegua()
 	EndDo

	Aadd (aResult, { iif(cMaqui == 'EXT',nQTDKG,nQTDKG-nQTDKGCO), nAPARA, dData, alltrim(cMaqui) } )


Enddo

Z00X->( dbCloseArea() )
Return aResult


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
