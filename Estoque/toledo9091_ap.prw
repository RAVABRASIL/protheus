#Include "RwMake.ch"
#include "topconn.ch"

*************

User Function TOLEDO9091

*************

SetPrvt( "nCONT, nTOLERA, aIMP, nPESO, cOP, oMAQ, nQUANT, cPORTA, nSACOS, oSACOS, lINCOMP, nHandle, aUSUARIO, oTIPO, cTIPO, aTIPO, " )
SetPrvt( "nQTDLIB, cUSULIM, nLIMITE, cSEQ, " )

nTOLERA := Getmv( "MV_PESOTOL" )
nLIMITE := GetMv( "MV_LIMAXOP" )
SC2->( DbSetOrder( 1 ) )
SB1->( DbSetOrder( 1 ) )
SB5->( DbSetOrder( 1 ) )
SH1->( DbSetOrder( 1 ) )
SG1->( DbSetOrder( 1 ) )
Z00->( DbSetOrder( 1 ) )
nHANDLE   := -1
cPORTABAL := "1"
cPORTAIMP := "3"
aIMP      := {}
aUSUARIO  := {}
nPESO     := 0
nSACOS    := 0
nQTDLIB   := 0
cOP       := Space( 11 )
cMAQ      := Space( 06 )
nQUANT    := 1
lIncomp   := .F.

@ 000,000 TO 170,330 Dialog oDLG1 Title "Pesagem de fardos"
@ 011,005 Say "OP:"
@ 010,015 Get cOP Object oOP Size 60,40 F3 "SC2" Valid PesqOp( cOP )
@ 011,090 Say "Maquina:"
@ 010,120 Get cMAQ Object oMAQ Size 30,40 F3 "SH1" Valid PesqMaq( cMAQ )
@ 031,005 Say "Qtd. Fardos:"
@ 031,040 Get nQUANT Object oQUANT Size 40,40 Picture "@E 999,999"
@ 031,090 Say "Peso (Kg):"
@ 031,125 Say nPESO Object oPESO Size 40,40 Picture "@E 999.99"

oIncompleto           := TCHECKBOX():Create( oDlg1 )
oIncompleto:cName     := "oIncompleto"
oIncompleto:cCaption  := "&Incompleto?"
oIncompleto:nLeft     := 015
oIncompleto:nTop      := 100
oIncompleto:nWidth    := 89
oIncompleto:nHeight   := 17
oIncompleto:lShowHint := .F.
oIncompleto:lReadOnly := .F.
oIncompleto:Align     := 0
oIncompleto:cVariable := "lIncomp"
oIncompleto:bSetGet   := {|u| If(PCount()>0,lIncomp:=u,lIncomp) }
oIncompleto:lVisibleControl := .T.
oIncompleto:bChange   := {|| Incomp() }

@ 051,090 Say "Qtd. Sacos:"
@ 051,120 Get nSACOS Object oSACOS Size 40,40 Valid Sacos() Picture "@E 999,999"
@ 070,010 Button "_Ler balanca" Size 50,15 Action Pegar()
@ 070,070 Button "_Reimp.etiq." Size 50,15 Action Reimprime()

@ 070,130 BMPButton Type 2 Action Close( oDLG1 )
Activate Dialog oDLG1 Centered
Return



***************

Static Function Pegar()

***************

if Empty( cMAQ )
	MsgAlert( "Maquina nao informada" )
	ObjectMethod( oMAQ, "SetFocus()" )
	Return NIL
EndIf
cDLL    := "toledo9091.dll"
nHandle := ExecInDllOpen( cDLL )
if nHandle = -1
	MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	Return NIL
EndIf
// Parametro 1 = Porta serial do indicador
cRETDLL := ExecInDLLRun( nHandle, 1, cPORTABAL )
cPESO   := Left( cRETDLL, rat( ",", cRETDLL ) - 1 )
nPESO   := Val( Strtran( cPESO, ",", "." ) )
ExecInDLLClose( nHandle )
ObjectMethod( oPESO, "SetText( Trans( nPESO, '@E 999.99' ) )" )
Grava()
Return NIL



***************

Static Function Grava()

***************

cUSULIM  := ""
aIMP     := {}
aUSUARIO := {}
Do While .T.
		If ! lIncomp
				If nPESO <= 0 .or. nQUANT <= 0 .or. Empty( cOP )
					 MsgAlert( "Campo(s) sem informacao ou com valor(es) incorreto(s)" )
					 Exit
				EndIf
	 			cQuery := "SELECT Sum( Z00_QUANT ) AS QUANT "
	 			cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
				cQuery += "WHERE Z00.Z00_OP = '" + cOP + "' AND Z00.Z00_BAIXA = 'N' AND "
	 			cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
	 			cQuery := ChangeQuery( cQuery )
	 			TCQUERY cQuery NEW ALIAS "Z00X"
 	 			If ( ( SC2->C2_QUANT - SC2->C2_QUJE ) + ( nLIMITE * SC2->C2_QUANT / 100 ) ) * SB5->B5_QE2 < Z00X->QUANT + ( nQUANT * SB5->B5_QTDFIM )
	 				 If ! MsgBox( OemToAnsi( "Producao desta OP ja atingiu o previsto (" + AllTrim( Str( SC2->C2_QUANT * SB5->B5_QE2 ) ) + " - " + ;
   						AllTrim( Str( SC2->C2_QUJE + Z00X->QUANT + ( nQUANT * SB5->B5_QTDFIM ) ) ) + "). Confirma?" ), "Escolha", "YESNO" )
							Z00X->( DbCloseArea() )
	 				    Exit
	 			   EndIf
		   		 aUSUARIO := U_senha2( "03" )
		   		 If ! aUSUARIO[ 1 ]
						 Z00X->( DbCloseArea() )
		   		  	 Exit
		   		 EndIf
					 cUSULIM  := aUSUARIO[ 2 ]
					 aUSUARIO := {}
				EndIf
				Z00X->( DbCloseArea() )
				nQTDPESADA := nQUANT * SB5->B5_QTDFIM     // Unidades pesadas
				nQUANTFD   := nQTDPESADA / SB5->B5_QE2
				nPROPORCAO := nQUANTFD * SB1->B1_PESO   // Peso teorico da pesagem
				nDIFPESO   := nQUANTFD * SB5->B5_DIFPESO
				SG1->( DbSeek( xFilial( "SG1" ) + SB1->B1_COD, .T. ) )
				nREG      := SB1->( Recno() )
				nPESOCAPA := 0
				Do While ! SG1->( Eof() ) .and. SG1->G1_COD == SB1->B1_COD
					 SB1->( DbSeek( xFilial( "SB1" ) + SG1->G1_COMP ) )
					 If SB1->B1_TIPO == 'ME'
						  nPESOCAPA += nQUANTFD * SG1->G1_QUANT * SB1->B1_PESO
					 EndIf
					 SB1->( DbGoto( nREG ) )
					 SG1->( DbSkip() )
				EndDo
				SB1->( DbGoto( nREG ) )
				nQTDLIB := 0
				cSEQ    := "00"
				If Z01->( DbSeek( xFilial( "Z01" ) + cOP, .T. ) )
					 	Do While Z01->Z01_OP == cOP
					 		 nQTDLIB += Z01->Z01_RESTA
					 		 cSEQ    := Z01->Z01_SEQ
					 		 Z01->( DbSkip() )
					 	EndDo
				EndIf
        If nQTDLIB < nQUANT .or. nPESO > Round( ( nPROPORCAO + nPESOCAPA + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), 3 ) * 1.1 ;
         .or. nPESO < Round( ( nPROPORCAO + nPESOCAPA + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), 3 ) * 0.9   // Bloqueia mais de 10% de variacao no peso mesmo estando liberado por senha
					 If nPESO < Round( ( nPROPORCAO + nPESOCAPA + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), 3 ) .or. nPESO > Round( ( nPROPORCAO + nPESOCAPA + nDIFPESO ) * ( 1 + ( nTOLERA / 100 ) ), 3 )
		 					If ! MsgBox( "Produto " + AllTrim( SB1->B1_COD ) + " - " + SB1->B1_DESC + Chr( 13 ) + Chr( 13 ) + "Com peso (" + AllTrim( Trans( nPESO, '@E 999.99' ) ) + ") fora da faixa permitida (" + AllTrim( Trans( ( nPROPORCAO + nPESOCAPA + nDIFPESO ) * ( 1 - ( nTOLERA / 100 ) ), ;
							  "@E 999.999" ) ) + " -- " + Alltrim( Trans( ( nPROPORCAO + nPESOCAPA + nDIFPESO ) * ( 1 + ( nTOLERA / 100 ) ), "@E 999.999" ) ) + ;
								"). Sacos capa (" + AllTrim( Trans( nPESOCAPA, "@E 999.999" ) ) + "), Confirma?", "Escolha", "YESNO" )
		  					  Exit
							EndIf
		   		 		aUSUARIO := U_senha2( "01" )
		   		 		If ! aUSUARIO[ 1 ]
		   		 		   Exit
		   		 		EndIf
							If ! QuantLib()
		   		 		   Exit
		   		 		EndIf
		  				If Z01->( DbSeek( xFilial( "Z01" ) + cOP, .T. ) )  // Atualiza o resta quando a OP tem fardos liberados
							 		nQTDUSA := nQUANT - nQTDLIB
			 				 		Do While Z01->Z01_OP == cOP .and. nQTDUSA > 0
							 		 	 RecLock( "Z01", .F. )
							 			 nRESTA  := Z01->Z01_RESTA
			 				 		 	 Z01->Z01_RESTA -= Min( Z01->Z01_RESTA, nQTDUSA )
			  		 	 		 	 Z01->( MsUnlock() )
							 		 	 nQTDUSA        -= Min( nRESTA, nQTDUSA )
			 				 		 	 Z01->( DbSkip() )
			 				 		EndDo
		  				 		Z01->( DbCommit() )
							EndIf
							If nQTDLIB > 0   // Cria registro de quantidade de fardos liberados
								RecLock( "Z01", .T. )
								Z01->Z01_OP    := cOP
								Z01->Z01_SEQ   := StrZero( Val( cSEQ ) + 1, 2 )
								Z01->Z01_DATA  := Date()
								Z01->Z01_HORA  := Left( Time(), 5 )
								Z01->Z01_QUANT := nQTDLIB
								Z01->Z01_RESTA := nQTDLIB
								Z01->Z01_USUAR := aUSUARIO[ 2 ]
		  					Z01->( MsUnlock() )
		  					Z01->( DbCommit() )
							EndIf
					 EndIf
				Else
						If Z01->( DbSeek( xFilial( "Z01" ) + cOP, .T. ) )  // Atualiza o resta quando a OP tem fardos liberados
							 nQTDLIB := nQUANT
			 				 Do While Z01->Z01_OP == cOP .and. nQTDLIB > 0
							  	 RecLock( "Z01", .F. )
									 nRESTA  := Z01->Z01_RESTA
			 				  	 Z01->Z01_RESTA -= Min( Z01->Z01_RESTA, nQTDLIB )
			  		 	  	 Z01->( MsUnlock() )
                   If Min( nRESTA, nQTDLIB ) > 0
                      nQTDLIB  -= Min( nRESTA, nQTDLIB )
                      aUSUARIO := { .T., Z01->Z01_USUAR }
                   EndIf
			 				  	 Z01->( DbSkip() )
			 				 EndDo
		  				 Z01->( DbCommit() )
						EndIf
				EndIf
				For nCONT := 1 To nQUANT
                        cSEQ := ProxSeq()
						RecLock( "Z00", .T. )
						Z00->Z00_SEQ    := cSEQ
						Z00->Z00_OP     := cOP
						Z00->Z00_PESO   := nPESO / nQUANT
						Z00->Z00_BAIXA  := "N"
						Z00->Z00_MAQ    := cMAQ
						Z00->Z00_DATA   := Date()
						Z00->Z00_HORA   := Left( Time(), 5 )
						Z00->Z00_QUANT  := SB5->B5_QTDFIM
						Z00->Z00_PESCAP := ( nPESOCAPA / nQUANT ) * -1
						Z00->Z00_PESDIF := ( nDIFPESO / nQUANT ) * -1
						Z00->Z00_USULIM := cUSULIM
						Z00->Z00_CODIGO := SB1->B1_COD
						If Len( aUSUARIO ) > 0
							 Z00->Z00_USUAR := aUSUARIO[ 2 ]
						EndIf
						Z00->( MsUnlock() )
						ConfirmSX8()
						Z00->( DbCommit() )

						//Aadd( aIMP, { "B" + "Rava Embalagens", "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ } )
						Aadd( aIMP, { "B" + "Rava Embalagens", "B" + "Produto: " + AllTrim( SB1->B1_COD ), "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ } )
						If Abre_Impress()
							 //Inc_Linha( aIMP[ nCONT, 1 ], .T. )
							 //Inc_Linha( aIMP[ nCONT, 2 ], .F. )
							 Inc_Linha( aIMP[ nCONT, 2 ], .T. )
							 //Inc_Linha( aIMP[ nCONT, 3 ], .F. )
							 //Inc_Linha( aIMP[ nCONT, 3 ], .T. )
							 Inc_Linha( aIMP[ nCONT, 4 ], .F. )
							 Fecha_Impress()
							 // Pausa a cada etiqueta
							 If nQUANT > 1 .and. nCONT <> nQUANT
							  	Msginfo( OemToAnsi( "Pressione <ENTER> para próxima etiqueta." ), "Pausa" )
							 EndIf
						EndIf
				Next
		Else
				If nPESO <= 0 .or. nSACOS <= 0 .or. Empty( cOP )
					 MsgAlert( "Campo(s) sem informacao ou com valor(es) incorreto(s)" )
					 Exit
				EndIf
	 			cQuery := "SELECT Sum( Z00_QUANT ) AS QUANT "
	 			cQuery += "FROM " + RetSqlName( "Z00" ) + " Z00 "
				cQuery += "WHERE Z00.Z00_OP = '" + cOP + "' AND Z00.Z00_BAIXA = 'N' AND "
	 			cQuery += "Z00.Z00_FILIAL = '" + xFilial( "Z00" ) + "' AND Z00.D_E_L_E_T_ = ' ' "
	 			cQuery := ChangeQuery( cQuery )
	 			TCQUERY cQuery NEW ALIAS "Z00X"
 	 			If ( ( SC2->C2_QUANT - SC2->C2_QUJE ) + ( nLIMITE * SC2->C2_QUANT / 100 ) ) * SB5->B5_QE2 < Z00X->QUANT + nSACOS
	 				 If ! MsgBox( OemToAnsi( "Producao desta OP ja atingiu o previsto (" + AllTrim( Str( SC2->C2_QUANT * SB5->B5_QE2 ) ) + " - " + ;
   						AllTrim( Str( SC2->C2_QUJE + Z00X->QUANT + nSACOS ) ) + "). Confirma?" ), "Escolha", "YESNO" )
							Z00X->( DbCloseArea() )
	 				    Exit
	 			   EndIf
		   		 aUSUARIO := U_senha2( "03" )
		   		 If ! aUSUARIO[ 1 ]
						 Z00X->( DbCloseArea() )
		   		  	 Exit
		   		 EndIf
					 cUSULIM  := aUSUARIO[ 2 ]
					 aUSUARIO := {}
				EndIf
				Z00X->( DbCloseArea() )
				nDIFPESO := nSACOS / SB5->B5_QE2 * SB5->B5_DIFPESO
        		cSEQ     := ProxSeq()
				RecLock( "Z00", .T. )
				Z00->Z00_SEQ    := cSEQ
				Z00->Z00_OP     := cOP
				Z00->Z00_PESO   := nPESO
				Z00->Z00_BAIXA  := "N"
				Z00->Z00_MAQ    := cMAQ
				Z00->Z00_DATA   := Date()
				Z00->Z00_HORA   := Left( Time(), 5 )
				Z00->Z00_QUANT  := nSACOS
				Z00->Z00_PESDIF := nDIFPESO * -1
				Z00->Z00_USULIM := cUSULIM
				Z00->Z00_CODIGO := SB1->B1_COD
				Z00->( MsUnlock() )
				ConfirmSX8()
				Z00->( DbCommit() )

				//Aadd( aIMP, { "B" + "Rava Embalagens", "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ } )

				Aadd( aIMP, { "B" + "Rava Embalagens", "B" + "Produto: " + AllTrim( SB1->B1_COD ), "A" + AllTrim( Left( SB1->B1_DESC, 39 ) ), Left( cOP, 6 ) + cSEQ } )
				

				If Abre_Impress()
				//Temporario
				//	 Inc_Linha( aIMP[ 1, 1 ], .T. )
				//	 Inc_Linha( aIMP[ 1, 2 ], .F. )
					 Inc_Linha( aIMP[ 1, 2 ], .T. )
				//	 Inc_Linha( aIMP[ 1, 3 ], .F. )
				//	 Inc_Linha( aIMP[ 1, 3 ], .T. )
					 Inc_Linha( aIMP[ 1, 4 ], .F. ) //Esmerino Neto
					 Fecha_Impress()
				EndIf
		EndIf
		If SC2->C2_RECURSO <> cMAQ
			RecLock( "SC2", .F. )
		   SC2->C2_RECURSO := cMAQ
			SC2->( MsUnlock() )
			SC2->( DbCommit() )
		EndIf
		Exit
EndDo
lIncomp := .F.
nPESO   := 0
cOP     := Space( 11 )
cMAQ    := Space( 06 )
nQUANT  := 1
ObjectMethod( oPESO, "SetText( Trans( nPESO, '@E 999.99' ) )" )
ObjectMethod( oOP, "SetFocus()" )
Return NIL



***************

Static Function PesqOp()

***************

lRET := .T.

If Len( AllTrim( cOP ) ) == 6
	 cOP := Left( cOP, 6 ) + "01001"
EndIf
If "REIMP" $ Upper( oDLG1:oCtlFocus:ccaption )
	 Return lRET
EndIf
SC2->( DbSeek( xFilial( "SC2" ) + cOP, .T. ) )
If SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN <> cOP
	 MsgAlert( OemToAnsi( "OP nao cadastrada" ) )
	 lRET := .F.
Else
	 If SB1->( Dbseek( xFilial( "SB1" ) + SC2->C2_PRODUTO ) )
	    If ! SB1->B1_TIPO $ "PA*ME*MP"
				 MsgAlert( OemToAnsi( "Esta OP nao ‚ de produto acabado ou embalagem" ) )
				 lRET := .F.
			EndIf
			If ! SB5->( Dbseek( xFilial( "SB5" ) + SC2->C2_PRODUTO ) )
				 MsgAlert( OemToAnsi( "Complemento do produto nao cadastrado" ) )
				 lRET := .F.
			EndIf
			If Empty( SB5->B5_QTDFIM )
				 MsgAlert( OemToAnsi( "Quantidade por embalagem final nao informada no produto" ) )
				 lRET := .F.
			EndIf
	 Else
			MsgAlert( OemToAnsi( "Produto desta OP nao cadastrado" ) )
			lRET := .F.
	 EndIf
 	 If lRET .and. ! Empty( SC2->C2_DATRF )
			MsgAlert( OemToAnsi( "Esta OP ja foi encerrada" ) )
 			lRET := .F.
	 EndIf
EndIf
If lRET
	 If ! Empty( SC2->C2_RECURSO )
			cMAQ           := SC2->C2_RECURSO
			ObjectMethod( oQUANT, "SetFocus()" )
	 EndIf
EndIf
Return lRET



***************

Static Function PesqMaq()

***************

lRET := .T.
If ! SH1->( DbSeek( xFilial( "SH1" ) + cMAQ ) )
	 MsgAlert( OemToAnsi( "Maquina nao cadastrada" ) )
	 lRET := .F.
EndIf
If lRET
	 If ! Empty( SC2->C2_RECURSO ) .and. cMAQ <> SC2->C2_RECURSO
		 lRET := U_senha2( "02" )[ 1 ]
	 EndIf
EndIf
Return lRET



***************

Static Function Abre_Impress()

***************

cDLL    := "impressora451.dll"
nHandle := ExecInDllOpen( cDLL )
if nHandle = -1
	 MsgAlert( "Nao foi possível encontrar a DLL " + cDLL )
	 Return .F.
EndIf
// Parametro 1 = Porta serial da impressora
ExecInDLLRun( nHandle, 1, cPORTAIMP )
Return .T.



***************

Static Function Inc_Linha( cIMP, lPRIMLINHA )

***************

// Parametro 1 = Linha a ser impressa
// Parametro 2 = Limpa buffer
ExecInDLLRun( nHandle, 2, cIMP + "," + If( lPRIMLINHA, "1", "0" ) )
Return NIL



***************

Static Function Fecha_Impress()

***************

ExecInDLLRun( nHandle, 3, "" )
ExecInDLLClose( nHandle )
Return NIL



***************

Static Function Reimprime()

***************

aUSUARIO := U_senha2( "01" )
If aUSUARIO[ 1 ]
	For nCONT := 1 To Len( aIMP )
			If Abre_Impress()
				 //Inc_Linha( aIMP[ nCONT, 1 ], .T. )
				 //Inc_Linha( aIMP[ nCONT, 2 ], .F. )
				 Inc_Linha( aIMP[ nCONT, 2 ], .T. )
				 //Inc_Linha( aIMP[ nCONT, 3 ], .F.)
				 //Inc_Linha( aIMP[ nCONT, 3 ], .T. )
				 Inc_Linha( aIMP[ nCONT, 4 ], .F. )
				 Fecha_Impress()
				 // Pausa a cada etiqueta
				 If Len( aIMP ) > 1 .and. nCONT <> Len( aIMP )
					  Msginfo( OemToAnsi( "Pressione <ENTER> para próxima etiqueta." ), "Pausa" )
				 EndIf
			EndIf
	Next
EndIf
ObjectMethod( oOP, "SetFocus()" )
Return NIL



***************

Static Function Incomp()

***************

If lINCOMP
	 ObjectMethod( oSACOS, "SetFocus()" )
EndIf
Return .T.



***************

Static Function Sacos()

***************

If nSACOS >= SB5->B5_QTDFIM
	 MsgAlert( "Quantidade de sacos maior que o fardo completo" )
	 Return .F.
EndIf
Return .T.



***************

Static Function QUANTLIB()

***************

lRET    := .T.
nQTDLIB := 0
@ 00,00 TO 60,330 Dialog oDLG2 Title "Libera fardos com problema no peso"
@ 11,010 Say "Quantidade:"
@ 10,050 Get nQTDLIB Size 20,40 Picture "9999"
@ 09,090 BMPButton Type 02 Action ( lRET := .F., Close( oDLG2 ) )
@ 09,130 BMPButton Type 01 Action Close( oDLG2 )
Activate Dialog oDLG2 Centered
Return lRET



***************

Static Function PROXSEQ()

***************

cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
Do While Z00->( DbSeek( xFilial( "Z00" ) + cSEQ ) )
   ConfirmSX8()
   cSEQ := GetSx8Num( "Z00", "Z00_SEQ" )
EndDo
Return cSEQ
