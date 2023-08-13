#Include "RwMake.ch"
#INCLUDE "TOPCONN.CH"
#include "font.ch"
#include "colors.ch"

*************

User Function MONITMAQ

*************

SetPrvt( "oDLG1,oDLG2,oTIMER1,oTIMER2,oBRW1," )
SetPrvt( "oGrp01,oGrp02,oGrp03,oGrp04,oGrp05,oGrp06," )
SetPrvt( "oMaq01,oMaq02,oMaq03,oMaq04,oMaq05,oMaq06," )
SetPrvt( "oOP01,oOP02,oOP03,oOP04,oOP05,oOP06," )
SetPrvt( "oPROD01,oPROD02,oPROD03,oPROD04,oPROD05,oPROD06," )
SetPrvt( "oDESCR101,oDESCR102,oDESCR103,oDESCR104,oDESCR105,oDESCR106," )
SetPrvt( "oDESCR201,oDESCR202,oDESCR203,oDESCR204,oDESCR205,oDESCR206," )
SetPrvt( "oPROGKG01,oPROGKG02,oPROGKG03,oPROGKG04,oPROGKG05,oPROGKG06," )
SetPrvt( "oPROGMR01,oPROGMR02,oPROGMR03,oPROGMR04,oPROGMR05,oPROGMR06," )
SetPrvt( "oPRODKG01,oPRODKG02,oPRODKG03,oPRODKG04,oPRODKG05,oPRODKG06," )
SetPrvt( "oPRODMR01,oPRODMR02,oPRODMR03,oPRODMR04,oPRODMR05,oPRODMR06," )
SetPrvt( "oTURN1KG01,oTURN1KG02,oTURN1KG03,oTURN1KG04,oTURN1KG05,oTURN1KG06," )
SetPrvt( "oTURN1MR01,oTURN1MR02,oTURN1MR03,oTURN1MR04,oTURN1MR05,oTURN1MR06," )
SetPrvt( "oTURN2KG01,oTURN2KG02,oTURN2KG03,oTURN2KG04,oTURN2KG05,oTURN2KG06," )
SetPrvt( "oTURN2MR01,oTURN2MR02,oTURN2MR03,oTURN2MR04,oTURN2MR05,oTURN2MR06," )
SetPrvt( "oTURN3KG01,oTURN3KG02,oTURN3KG03,oTURN3KG04,oTURN3KG05,oTURN3KG06," )
SetPrvt( "oTURN3MR01,oTURN3MR02,oTURN3MR03,oTURN3MR04,oTURN3MR05,oTURN3MR06," )
SetPrvt( "oPRODDKG01,oPRODDKG02,oPRODDKG03,oPRODDKG04,oPRODDKG05,oPRODDKG06," )
SetPrvt( "oPRODDMR01,oPRODDMR02,oPRODDMR03,oPRODDMR04,oPRODDMR05,oPRODDMR06," )
SetPrvt( "cTURNO1,cTURNO2,cTURNO3,cTURNO1_A,cTURNO2_A,cTURNO3_A," )
SetPrvt( "oSAY01012,oSAY01013,oSAY01018,oSAY01019,oSAY01024,oSAY01025," )
SetPrvt( "oSAY02012,oSAY02013,oSAY02018,oSAY02019,oSAY02024,oSAY02025," )
SetPrvt( "oSAY03012,oSAY03013,oSAY03018,oSAY03019,oSAY03024,oSAY03025," )
SetPrvt( "oSAY04012,oSAY04013,oSAY04018,oSAY04019,oSAY04024,oSAY04025," )
SetPrvt( "oSAY05012,oSAY05013,oSAY05018,oSAY05019,oSAY05024,oSAY05025," )
SetPrvt( "oSAY06012,oSAY06013,oSAY06018,oSAY06019,oSAY06024,oSAY06025," )
SetPrvt( "lTELA,aESTRUT,oFONT2," )
SetPrvt( "nTQTDKG, nTQTDMR, nTAPARA, nTotsKG, nTotsML," )

Validperg()
If ! Pergunte( "MONMAQ", .T. )
   Return NIL
EndIf

cTURNO1   := GetMv( "MV_TURNO1" )
cTURNO2   := GetMv( "MV_TURNO2" )
cTURNO3   := GetMv( "MV_TURNO3" )
cTURNO1_A := Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO1, 7, 5 )  // Soma 15 minutos p/ apara
cTURNO2_A := Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO2, 7, 5 )
cTURNO3_A := Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", "00:15:00" ), 5 ) + "," + SubStr( cTURNO3, 7, 5 )
nPVAROP   := GetMv( "MV_PVAROP" )
lTELA     := .T.
cVAZIO    := " "
nTQTDKG   := 0
nTQTDMR   := 0
nTAPARA   := 0
nTotsKG		:= 0
nTotsML		:= 0

aESTRUT   := {{ "MAQ",     "C", 006, 0 }, ;  // Campos do arquivo do MSSELECT dos produtos
              { "TURNO",   "C", 001, 0 }, ;
             	{ "OP",      "C", 006, 0 }, ;
             	{ "PRODUTO", "C", 010, 0 }, ;
             	{ "QUANTMR", "N", 009, 2 }, ;
             	{ "QUANTKG", "N", 009, 2 }, ;
             	{ "APARA",   "N", 009, 2 }, ;
             	{ "APARA3",  "N", 009, 2 } }

cARQTMP := CriaTrab( aESTRUT, .T. )
DbUseArea( .T.,, cARQTMP, "PRD", .F., .F. )
Index On MAQ + TURNO + OP To &cARQTMP

DEFINE FONT oFont4 NAME "Courier New" SIZE 0, 20 BOLD
DEFINE FONT oFont5 NAME "Arial" SIZE 0, 40 BOLD
DEFINE FONT oFont15 NAME "Arial" SIZE 0, 40 BOLD UNDERLINE

U_MONMAQ_TL1()
oTimer1 := TTimer():New( 10000, { || Atualiza() }, oDLG1 )  // 120000 = 2 minutos  //60000 1 min Esmerino Neto
oTimer1:Activate()
													//300000
oTimer30 := TTimer():New( 1800000, { || ctrlQuali() }, oDLG1 )
oTimer30:Activate()

Activate Dialog oDLG1 Centered On Init Atualiza()
PRD->( DbCloseArea() )
Return NIL



***************

Static Function ATUALIZA

***************

dDIA := If( Time() < Left( cTURNO1, 5 ) + ":00", Date() - 1, Date() )
If lTELA
	oDlg1:cCaption := "Situacao resumida da producao - Dia: " + Dtoc( dDIA )
	If MV_PAR01 == 1
		 If ! Empty( MV_PAR02 )
				Mostra( MV_PAR02, "01" )
		 Endif
		 If ! Empty( MV_PAR03 )
				Mostra( MV_PAR03, "02" )
		 Endif
		 If ! Empty( MV_PAR04 )
				Mostra( MV_PAR04, "03" )
		 Endif
		 If ! Empty( MV_PAR05 )
				Mostra( MV_PAR05, "04" )
		 Endif
		 If ! Empty( MV_PAR06 )
				Mostra( MV_PAR06, "05" )
		 Endif
		 If ! Empty( MV_PAR07 )
				Mostra( MV_PAR07, "06" )
		 Endif
	Else
		 If ! Empty( MV_PAR08 )
				Mostra( MV_PAR08, "01" )
		 Endif
		 If ! Empty( MV_PAR09 )
				Mostra( MV_PAR09, "02" )
		 Endif
		 If ! Empty( MV_PAR10 )
				Mostra( MV_PAR10, "03" )
		 Endif
		 If ! Empty( MV_PAR11 )
				Mostra( MV_PAR11, "04" )
		 Endif
		 If ! Empty( MV_PAR12 )
          Mostra( MV_PAR12, "05" )
		 Endif
		 If ! Empty( MV_PAR13 )
				Mostra( MV_PAR13, "06" )
		 Endif
	EndIf
	lTELA := .F.
Else
	oTimer1:DeActivate()
	Mostra2()
	@ 000,000 TO 600,800 Dialog oDLG2 Title "Situacao detalhada da producao - Dia: " + Dtoc( If( Time() < Left( cTURNO1, 5 ) + ":00", dDATABASE - 1, dDATABASE ) )
	@ 500,700 Get cVAZIO Object oVAZIO Size 10,10
   DbSelectArea("PRD")
	oBRW1 := MsSelect():New( "PRD",,, ;
                         { { "MAQ",, OemToAnsi( "Maq" ) }, ;
                           { "TURNO",,   OemToAnsi( "Turno " ) }, ;
                           { "OP",,   OemToAnsi( "OP      " ) }, ;
                           { "PRODUTO",,  OemToAnsi( "Produto " ) }, ;
                           { "( Trans( QUANTMR, '@E 999,999.99' ) )",, OemToAnsi( "Quant.(FD) " ) }, ;
                           { "( Trans( QUANTKG, '@E 999,999.99' ) )",, OemToAnsi( "Quant.(KG) " ) }, ;
                           { "( Trans( APARA, '@E 999,999.99' ) )",, OemToAnsi( "Ap.normal(KG) " ) }, ;
                           { "( Trans( APARA3, '@E 999,999.99' ) )",, OemToAnsi( "Ap.alca(KG)  " ) } }, ;
													 .F.,, { 002, 002, 200, 397 } )
													 //.F.,, { 002, 002, 285, 397 } )
  @ 203,080 Say "TOTAIS --->" Object oTOTAL
  @ 203,145 Say nTQTDMR Object oTQTDKG Size 100,10 Picture "@E 9,999,999.99"
  @ 203,200 Say nTQTDKG Object oTQTDMR Size 100,10 Picture "@E 9,999,999.99"
  @ 203,260 Say nTAPARA Object oTAPARA Size 100,10 Picture "@E 9,999,999.99"
	@ 222,020 Say "-------------------------------------------------------------------------" Object oDIV Size 400,400 //Picture "@E 9,999,999.99"
	@ 230,120 Say "TOTAL DA PRODUCAO EM: " + DtoC( Date() ) Object oTit Size 200,200

	@ 250,090 Say nTotsKG Object oTotKGs Size 200,200 Picture "@E 9,999,999.99"
	@ 250,150 Say " KG " Object oKG

	@ 250,200 Say nTotsML Object oTotMLs Size 200,200 Picture "@E 9,999,999.99"
	@ 250,260 Say " MR " Object oML
	@ 265,140 Say  "Hora: " object oDIGA Size 100,100
	@ 265,199 Say Time() object oHORA Size 100,100 Picture "@E 99:99" //incluido por manel para testes
	oHORA:SetFont( oFont5 )
	oDIGA:SetFont( oFont5 )
	//@ 250,010 Say nTotsKG + " KG   " + nTotsML + " ML" Object oTots Size 200,200 //Picture "@E 9,999,999.99"

	oBRW1:oBROWSE:SetFont( oFont4 )
  oTOTAL:SetFont( oFont4 )
  oTQTDKG:SetFont( oFont4 )
  oTQTDMR:SetFont( oFont4 )
  oTAPARA:SetFont( oFont4 )
	oTit:SetFont( oFont4 )
	oDIV:SetFont( oFont4 )
	oTotKGs:SetFont( oFont4 )
	oKG:SetFont( oFont4 )

	oTotMLs:SetFont( oFont4 )
	oML:SetFont( oFont4 )

  oBRW1:oBROWSE:nCLRFOREFOCUS := CLR_WHITE
  oTimer2 := TTimer():New( 10000, { || oTimer2:DeActivate(), oDLG2:End() }, oDLG2 )  // 120000 = 2 minutos  //Esmerino Neto 60000
	oTimer2:Activate()
	Activate Dialog oDLG2 Centered
	lTELA := .T.
	Atualiza()
	oTimer1:Activate()
EndIf
Return NIL



***************

Static Function Mostra( cMAQ, cNUM )

***************

DbSelectArea("SB1")
DbSelectArea("SC2")
DbSelectArea("SB5")

SB1->( DbSetOrder( 1 ) )
SC2->( DbSetOrder( 1 ) )
cQUERY := "SELECT Z00.Z00_OP,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF "
cQUERY += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQUERY += "WHERE Z00.Z00_DATA BETWEEN '" + Dtos( dDIA ) + "' AND '" + Dtos( Date() ) + "' AND "
cQUERY += "Z00.Z00_MAQ = '" + cMAQ + "' AND Z00.Z00_APARA = ' ' AND "
cQUERY += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQUERY += "ORDER BY Z00.Z00_DATA,Z00.Z00_HORA "
cQUERY := ChangeQuery( cQUERY )
TCQUERY cQUERY NEW ALIAS "Z00X"
TCSetField( 'Z00X', "Z00_DATA", "D" )
Z00X->( DbGotop() )
nTURNO1KG := nTURNO2KG := nTURNO3KG := 0
nTURNO1MR := nTURNO2MR := nTURNO3MR := 0
nTURNO1   := nTURNO2   := nTURNO3   := 0
nPRODDKG  := nPRODDMR  := 0
cOP       := ""
Do While ! Z00X->( Eof() )
   SC2->( DbSeek( xFilial( "SC2" ) + Z00X->Z00_OP, .T. ) )
   SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
	 If Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
		 nTURNO1KG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
     nTURNO1MR += Z00X->Z00_QUANT / SB5->B5_QE2
		 nPRODDKG  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
     nPRODDMR  += Z00X->Z00_QUANT / SB5->B5_QE2
	 ElseIf Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
		 nTURNO2KG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
     nTURNO2MR += Z00X->Z00_QUANT / SB5->B5_QE2
		 nPRODDKG  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
     nPRODDMR  += Z00X->Z00_QUANT / SB5->B5_QE2
	 ElseIf ( Z00X->Z00_DATA == dDIA .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		 ( Z00X->Z00_DATA == dDIA + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
		 nTURNO3KG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
     nTURNO3MR += Z00X->Z00_QUANT / SB5->B5_QE2
		 nPRODDKG  += Z00X->Z00_PESO + Z00X->Z00_PESCAP
     nPRODDMR  += Z00X->Z00_QUANT / SB5->B5_QE2
	 EndIf
	 cOP := Z00X->Z00_OP
	 Z00X->( DbSkip() )
EndDo
Z00X->( DbCloseArea() )
If ! Empty( cOP )
	cQuery := "SELECT Sum( Z00_QUANT ) AS QUANT,Sum( Z00_PESO + Z00_PESCAP ) AS PESO "
	cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
	cQuery += "WHERE Z00.Z00_OP = '" + cOP + "' AND "
	cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	TCQUERY cQuery NEW ALIAS "Z00X"
	SC2->( DbSeek( xFilial( "SC2" ) + cOP, .T. ) )
	SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
	SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
   oSay&( cNUM + "012" ):cCaption := SB1->B1_UM + ":"
   oSay&( cNUM + "013" ):cCaption := SB1->B1_UM + ":"
   oSay&( cNUM + "018" ):cCaption := SB1->B1_UM + ":"
   oSay&( cNUM + "019" ):cCaption := SB1->B1_UM + ":"
   oSay&( cNUM + "024" ):cCaption := SB1->B1_UM + ":"
   oSay&( cNUM + "025" ):cCaption := SB1->B1_UM + ":"
	oOP&cNUM:cCaption      := Left( cOP, 6 )
	oPROGKG&cNUM:cCaption  := Trans( SC2->C2_QTSEGUM / ( 1 + ( nPVarOp / 100 ) ), "@E 999999.99" )
//   oPROGMR&cNUM:cCaption  := Trans( SC2->C2_QUANT * SB5->B5_QE2 / 1000, "@E 999999.99" )
   oPROGMR&cNUM:cCaption   := Trans( SC2->C2_QUANT / ( 1 + ( nPVarOp / 100 ) ), "@E 999999.99" )
	oPRODKG&cNUM:cCaption  := Trans( Z00X->PESO, "@E 999999.99" )
//   oPRODMR&cNUM:cCaption  := Trans( Z00X->QUANT / 1000, "@E 999999.99" )
   oPRODMR&cNUM:cCaption   := Trans( Z00X->QUANT / SB5->B5_QE2, "@E 999999.99" )
	oPROD&cNUM:cCaption    := SC2->C2_PRODUTO
	oDESCR1&cNUM:cCaption  := Left( SB1->B1_DESC, 17 )
	oDESCR2&cNUM:cCaption  := SubStr( SB1->B1_DESC, 18, 24 )
	Z00X->( DbCloseArea() )
EndIf
oMAQ&cNUM:cCaption     := cMAQ
oTURN1KG&cNUM:cCaption := Trans( nTURNO1KG, "@E 999999.99" )
oTURN1MR&cNUM:cCaption := Trans( nTURNO1MR, "@E 999999.99" )
oTURN2KG&cNUM:cCaption := Trans( nTURNO2KG, "@E 999999.99" )
oTURN2MR&cNUM:cCaption := Trans( nTURNO2MR, "@E 999999.99" )
oTURN3KG&cNUM:cCaption := Trans( nTURNO3KG, "@E 999999.99" )
oTURN3MR&cNUM:cCaption := Trans( nTURNO3MR, "@E 999999.99" )
oPRODDKG&cNUM:cCaption := Trans( nPRODDKG, "@E 999999.99" )
oPRODDMR&cNUM:cCaption := Trans( nPRODDMR, "@E 999999.99" )
Return NIL



***************

Static Function Mostra2()

***************


DbSelectArea("SB1")
DbSelectArea("SC2")
DbSelectArea("SB5")


cQuery := "SELECT Z00.Z00_OP,Z00.Z00_MAQ,Z00.Z00_PESO,Z00_APARA,Z00.Z00_HORA,Z00.Z00_QUANT,Z00.Z00_DATA,Z00.Z00_PESCAP,Z00.Z00_PESDIF "
cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
cQUERY += "WHERE Z00.Z00_DATA BETWEEN '" + Dtos( dDIA ) + "' AND '" + Dtos( Date() ) + "' AND "
If MV_PAR01 == 1
	cQUERY += "Z00.Z00_MAQ IN ( '" + MV_PAR02 + "','" + MV_PAR03 + "','" + MV_PAR04 + "','" + MV_PAR05 + "','" + MV_PAR06 + "','" + MV_PAR07 + "' ) AND "
Else
	cQUERY += "Z00.Z00_MAQ IN ( '" + MV_PAR08 + "','" + MV_PAR09 + "','" + MV_PAR10 + "','" + MV_PAR11 + "','" + MV_PAR12 + "','" + MV_PAR13 + "' ) AND "
EndIf
cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery( cQuery )
TCQUERY cQuery NEW ALIAS "Z00X"
TCSetField( 'Z00X', "Z00_DATA", "D" )


cQuery9 := "SELECT SUM(Z00_PESO + Z00_PESCAP) AS QTD_KG, SUM(Z00_QUANT) / 1000 AS QTD_ML FROM Z00020 "
cQuery9 += "WHERE Z00_DATA = CONVERT(varchar(8), CONVERT(smalldatetime, GETDATE()), 112) "
cQuery9 += "AND Z00_APARA = ' ' AND Z00_HORA >= '05:35' "
cQuery9 += "AND Z00_MAQ IN ('C01', 'C02', 'C03', 'C04', 'C05', 'C06', 'P01', 'P02', 'P03', 'P04', 'P05', 'S01') "
cQuery9 += "AND Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND D_E_L_E_T_ = ' ' "
cQuery9 := ChangeQuery( cQuery9 )
TCQUERY cQuery9 NEW ALIAS "TOTX"

nTotsKG := 0
nTotsML := 0

TOTX->( DbGoTop() )

If ! TOTX->( EoF() )
	nTotsKG := TOTX->QTD_KG
	nTotsML := TOTX->QTD_ML
EndIF

TOTX->( DbCloseArea() )

nTQTDKG := 0
nTQTDMR := 0
nTAPARA := 0
PRD->( __DbZap() )
Z00X->( DbGoTop() )
Do While ! Z00X->( Eof() )
	SC2->( DbSeek( xFilial( "SC2" ) + Z00X->Z00_OP, .T. ) )
	SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
	SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
	If Z00X->Z00_APARA = " "
		If Z00X->Z00_DATA <= dDIA .and. Z00X->Z00_HORA >= Left( cTURNO1, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1, 5 ) + ":00", SubStr( cTURNO1, 7, 5 ) + ":00" ), 5 )
			If ! PRD->( DbSeek( Z00X->Z00_MAQ + "1" + Z00X->Z00_OP ) )
				PRD->( DbAppend() )
				PRD->MAQ     := Z00X->Z00_MAQ
				PRD->OP      := Left( Z00X->Z00_OP, 6 )
				PRD->TURNO   := "1"
				PRD->PRODUTO := SB1->B1_COD
			EndIf
			PRD->QUANTKG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
			PRD->QUANTMR += Z00X->Z00_QUANT / SB5->B5_QE2
			nTQTDKG      += Z00X->Z00_PESO + Z00X->Z00_PESCAP
			nTQTDMR      += Z00X->Z00_QUANT / SB5->B5_QE2
		ElseIf Z00X->Z00_DATA <= dDIA .and. Z00X->Z00_HORA >= Left( cTURNO2, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2, 5 ) + ":00", SubStr( cTURNO2, 7, 5 ) + ":00" ), 5 )
			If ! PRD->( DbSeek( Z00X->Z00_MAQ + "2" + Z00X->Z00_OP ) )
				PRD->( DbAppend() )
				PRD->MAQ     := Z00X->Z00_MAQ
				PRD->OP      := Left( Z00X->Z00_OP, 6 )
				PRD->TURNO   := "2"
				PRD->PRODUTO := SB1->B1_COD
			EndIf
			PRD->QUANTKG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
			PRD->QUANTMR += Z00X->Z00_QUANT / SB5->B5_QE2
			nTQTDKG      += Z00X->Z00_PESO + Z00X->Z00_PESCAP
			nTQTDMR      += Z00X->Z00_QUANT / SB5->B5_QE2
		ElseIf ( Z00X->Z00_DATA <= dDIA .and. Z00X->Z00_HORA >= Left( cTURNO3, 5 ) ) .or. ;
		 ( Z00X->Z00_DATA >= dDIA + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3, 5 ) + ":00", SubStr( cTURNO3, 7, 5 ) + ":00" ), 5 ) )
			If ! PRD->( DbSeek( Z00X->Z00_MAQ + "3" + Z00X->Z00_OP ) )
				PRD->( DbAppend() )
				PRD->MAQ     := Z00X->Z00_MAQ
				PRD->OP      := Left( Z00X->Z00_OP, 6 )
				PRD->TURNO   := "3"
				PRD->PRODUTO := SB1->B1_COD
			EndIf
			PRD->QUANTKG += Z00X->Z00_PESO + Z00X->Z00_PESCAP
			PRD->QUANTMR += Z00X->Z00_QUANT / SB5->B5_QE2
			nTQTDKG      += Z00X->Z00_PESO + Z00X->Z00_PESCAP
			nTQTDMR      += Z00X->Z00_QUANT / SB5->B5_QE2
		EndIf
	Else
		If Z00X->Z00_DATA <= dDIA .and. Z00X->Z00_HORA >= Left( cTURNO1_A, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO1_A, 5 ) + ":00", SubStr( cTURNO1_A, 7, 5 ) + ":00" ), 5 )
			If ! PRD->( DbSeek( Z00X->Z00_MAQ + "1" + Z00X->Z00_OP ) )
				PRD->( DbAppend() )
				PRD->MAQ     := Z00X->Z00_MAQ
				PRD->OP      := Left( Z00X->Z00_OP, 6 )
				PRD->TURNO   := "1"
				PRD->PRODUTO := SB1->B1_COD
			EndIf
			If Alltrim(Z00X->Z00_APARA) <> ""
               PRD->APARA  += Z00X->Z00_PESO
			EndIf
			nTAPARA += Z00X->Z00_PESO
		ElseIf Z00X->Z00_DATA <= dDIA .and. Z00X->Z00_HORA >= Left( cTURNO2_A, 5 ) .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO2_A, 5 ) + ":00", SubStr( cTURNO2_A, 7, 5 ) + ":00" ), 5 )
			If ! PRD->( DbSeek( Z00X->Z00_MAQ + "2" + Z00X->Z00_OP ) )
				PRD->( DbAppend() )
				PRD->MAQ     := Z00X->Z00_MAQ
				PRD->OP      := Left( Z00X->Z00_OP, 6 )
				PRD->TURNO   := "2"
				PRD->PRODUTO := SB1->B1_COD
			EndIf
			If Alltrim(Z00X->Z00_APARA) <> ""
                PRD->APARA  += Z00X->Z00_PESO
			EndIf
			nTAPARA += Z00X->Z00_PESO
		ElseIf ( Z00X->Z00_DATA <= dDIA .and. Z00X->Z00_HORA >= Left( cTURNO3_A, 5 ) ) .or. ;
		 ( Z00X->Z00_DATA >= dDIA + 1 .and. Z00X->Z00_HORA <= Left( U_Somahora( Left( cTURNO3_A, 5 ) + ":00", SubStr( cTURNO3_A, 7, 5 ) + ":00" ), 5 ) )
			If ! PRD->( DbSeek( Z00X->Z00_MAQ + "3" + Z00X->Z00_OP ) )
				PRD->( DbAppend() )
				PRD->MAQ     := Z00X->Z00_MAQ
				PRD->OP      := Left( Z00X->Z00_OP, 6 )
				PRD->TURNO   := "3"
				PRD->PRODUTO := SB1->B1_COD
			EndIf
			If Alltrim(Z00X->Z00_APARA) # ""
               PRD->APARA  += Z00X->Z00_PESO
			EndIf
			nTAPARA += Z00X->Z00_PESO
		EndIf
	EndIf
	Z00X->( DbSkip() )
Enddo
Z00X->( DbCLoseArea() )
PRD->( DbGoTop() )
Return NIL



***************

Static Function ValidPerg()

***************

PutSx1( "MONMAQ", '01', 'Setor              ?', '', '', 'mv_ch1', 'N', 01, 0, 0, 'G', '', ''   , '', '', 'mv_par01', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMAQ", '02', 'Maquina 1 Setor 1  ?', '', '', 'mv_ch2', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par02', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMAQ", '03', 'Maquina 2 Setor 1  ?', '', '', 'mv_ch3', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par03', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMAQ", '04', 'Maquina 3 Setor 1  ?', '', '', 'mv_ch4', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par04', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMAQ", '05', 'Maquina 4 Setor 1  ?', '', '', 'mv_ch5', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par05', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMAQ", '06', 'Maquina 5 Setor 1  ?', '', '', 'mv_ch6', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par06', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMAQ", '07', 'Maquina 6 Setor 1  ?', '', '', 'mv_ch7', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par07', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMAQ", '08', 'Maquina 1 Setor 2  ?', '', '', 'mv_ch8', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par08', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMAQ", '09', 'Maquina 2 Setor 2  ?', '', '', 'mv_ch9', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par09', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMAQ", '10', 'Maquina 3 Setor 2  ?', '', '', 'mv_cha', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par10', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMAQ", '11', 'Maquina 4 Setor 2 ?', '', '', 'mv_chb', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par11', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMAQ", '12', 'Maquina 5 Setor 2 ?', '', '', 'mv_chc', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par12', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
PutSx1( "MONMAQ", '13', 'Maquina 6 Setor 2 ?', '', '', 'mv_chd', 'C', 06, 0, 0, 'G', '', 'SH1', '', '', 'mv_par13', ''               , '', '', '' ,''               , '', '', ''               , '', '', ''               , '', '', '', '', '', {}, {}, {} )
Return NIL


***************

Static Function ctrlQuali()

***************

	oTimer1:DeActivate()

	Private aArrOBJ
	Private i := 1

	@ 000,000 TO 600,800 Dialog oDLG99 Title "Controle de Qualidade"

	@ 013,080 Say "CONTROLE DE QUALIDADE" object oSay1 size 250,30
	@ 063,030 Say "Verificar :" object oSay2 size 80,30
	@ 063,120 Say "Largura X Comprimento" object oSay3 size 250,30
	@ 113,030 Say "Verificar :" object oSay4 size 80,30
	@ 113,120 Say "Aba" object oSay5 size 80,30
	@ 163,030 Say "Verificar :" object oSay6 size 80,30
	@ 163,120 Say "Solda" object oSay7 size 80,30
	@ 213,030 Say "Verificar :" object oSay8 size 80,30
	@ 213,120 Say "Boca" object oSay9 size 80,30
	@ 263,030 Say "Verificar :" object oSay10 size 80,30
  @ 263,120 Say "Distância Picote-Solda" object oSay11 size 250,30

	oSay1:setfont( oFont15 )
	oSay1:nClrText := CLR_HBLUE
	oSay2:setfont( oFont5 )
	oSay2:nClrText := CLR_GREEN
	oSay3:setfont( oFont5 )
	oSay3:nClrText := CLR_BLUE
	oSay4:setfont( oFont5 )
	oSay4:nClrText := CLR_BLUE
	oSay5:setfont( oFont5 )
	oSay5:nClrText := CLR_GREEN
	oSay6:setfont( oFont5 )
	oSay6:nClrText := CLR_GREEN
	oSay7:setfont( oFont5 )
	oSay7:nClrText := CLR_BLUE
	oSay8:setfont( oFont5 )
	oSay8:nClrText := CLR_BLUE
	oSay9:setfont( oFont5 )
	oSay9:nClrText := CLR_GREEN
	oSay10:setfont( oFont5 )
	oSay10:nClrText := CLR_GREEN
	oSay11:setfont( oFont5 )
	oSay11:nClrText := CLR_BLUE

	oSay3:lVisible  := .F.
	oSay5:lVisible  := .F.
	oSay7:lVisible  := .F.
	oSay9:lVisible  := .F.
	oSay11:lVisible := .F.
	aArrOBJ := {oSay3, oSay5, oSay7, oSay9, oSay11}

	oGRP  		           := TGROUP():Create(oDlg99)
	oGrp:cName           := "oGrp"
	oGrp:nLeft           := 011
	oGrp:nTop            := 009
	oGrp:nWidth          := 780
	oGrp:nHeight         := 585
	oGrp:lShowHint       := .F.
	oGrp:lReadOnly       := .F.
	oGrp:Align           := 0
	oGrp:lVisibleControl := .T.

  /*oBmp:= TBITMAP():Create(oDlg99)
	oBmp:cName 					 := "oBmp"
	oBmp:cCaption 			 := "oBmp"
	oBmp:nLeft 					 := 020
	oBmp:nTop 					 := 160
	oBmp:nWidth 				 := 750
	oBmp:nHeight 			   := 290
	oBmp:lShowHint 			 := .F.
	oBmp:lReadOnly 			 := .F.
	oBmp:Align 					 := 0
	oBmp:lVisibleControl := .T.
	oBmp:cBmpFile 			 := "LOGO_RAVA3.bmp"
	oBmp:lStretch 			 := .T.
  oBmp:lAutoSize       := .F.*/

	oTimer3 := TTimer():New( 60000, { || oTimer3:DeActivate(), oTimer1:Activate(),oDLG99:End() }, oDLG99 )
  oTimer3:Activate()

	oTimer5 := TTimer():New( 280, { || RelerTerm(), objectMethod( oDlg99, "Refresh()" ) }, oDlg99 )
  oTimer5:Activate()

	Activate Dialog oDLG99 Centered

Return Nil


***************

static function RelerTerm( )

***************

	aArrOBJ[i]:lVisible := .T.
	i++
	if i > 5
		oTimer5:DeActivate()
	endif

return (.T.)
