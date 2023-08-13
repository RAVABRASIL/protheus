#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function VLD2UM()    // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

SetPrvt( "nORD1, nORD2, nORD3, nREG1, nREG2, nCONV, nQUANT, nQB, nPESO, cCOD, " )

*resource2file( "VLD2UM_AP.PRW", "c:\temp1" )
*resource2file( "U_VLD2UM", "c:\temp2" )
*return 0
nORD1 := SB1->( IndexOrd() )
nORD2 := SG1->( IndexOrd() )
nORD3 := SD4->( IndexOrd() )
SB1->( DbSetOrder( 1 ) )
SG1->( DbSetOrder( 1 ) )
SD4->( DbSetOrder( 2 ) )
SB1->( Dbseek( xFilial( "SB1" ) + M->D3_COD, .T. ) )
If SB1->B1_COD == M->D3_COD .and. SB1->B1_SEGUM == "KG"
	 nQB    := SB1->B1_QB
	 nPESO  := 0
	 cCOD   := SB1->B1_COD
   nREG1  := SB1->( Recno() )
	 SG1->( DbSeek( xFilial( "SG1" ) + SB1->B1_COD, .T. ) )
   Do While SG1->G1_COD == cCOD
      SB1->( Dbseek( xFilial( "SB1" ) + SG1->G1_COMP ) )
			If SB1->B1_UM == "MR" .and. SB1->B1_TIPO == "ME"
				 nPESO += SG1->G1_QUANT / nQB * SB1->B1_PESO
      EndIf
			SG1->( DbSkip() )
   EndDo
   SB1->( DbGoto( nREG1 ) )
   nQTSEGUM := M->D3_QUANT / SB1->B1_CONV
   nCONV    := M->D3_QUANT / ( M->D3_QTSEGUM - Round( nPESO * M->D3_QUANT, 4 ) )
/*
   If MsgBox( "Alteracao de peso " + AllTrim( Trans( SB1->B1_PESO, "@E 99,999.99999999" ) ) + " para " + AllTrim( Trans( 1 / nCONV, "@E 99,999.99999999" ) ) + ", Confirma?", "Escolha", "YESNO" )
      Reclock( "SB1", .F. )
      SB1->B1_CONV := nCONV
      SB1->B1_PESO := 1 / nCONV
      SB1->( MsUnlock() )
      SB1->( dbCommit() )
      nQUANT := SC2->C2_QUANT
      SG1->( DbSetOrder( 2 ) )
      SD4->( DbSeek( xFilial( "SD4" ) + M->D3_OP, .T. ) )
      Do While SD4->D4_OP == M->D3_OP
         SB1->( Dbseek( xFilial( "SB1" ) + SD4->D4_COD ) )
         If SB1->B1_TIPO == "PI"
            If SG1->( DbSeek( xFilial( "SG1" ) + SB1->B1_COD + M->D3_COD ) )
                Reclock( "SG1", .F. )
                SG1->G1_QUANT := 1 / nCONV
                SG1->( MsUnlock() )
                SG1->( dbCommit() )
            EndIf
            nREG2 := SC2->( Recno() )
            If SC2->( DbSeek( xFilial( "SC2" ) + SD4->D4_OPORIG, .T. ) )
               Reclock( "SC2", .F. )
               SC2->C2_QUANT   := nQUANT * ( 1 / nCONV )
               SC2->C2_QTSEGUM := nQUANT * ( 1 / nCONV )
               SC2->( MsUnlock() )
               SC2->( dbCommit() )
               Reclock( "SD4", .F. )
               SD4->D4_QTDEORI := nQUANT * ( 1 / nCONV )
               SD4->D4_QUANT   -= Round( nPESO * M->D3_QUANT, 4 ) - ( M->D3_QTSEGUM - nQTSEGUM )
               SD4->( MsUnlock() )
               SD4->( dbCommit() )
            EndIf
            SC2->( DbGoto( nREG2 ) )
            Exit
         EndIf
         SD4->( DbSkip() )
      EndDo
      Return Round( nPESO * M->D3_QUANT, 4 )
   EndIf
*/
EndIf
SB1->( DbSetOrder( nORD1 ) )
SG1->( DbSetOrder( nORD2 ) )
SD4->( DbSetOrder( nORD3 ) )
Return 0
