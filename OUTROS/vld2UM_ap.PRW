#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

User Function VLD2UM()    // incluido pelo assistente de conversao do AP5 IDE em 19/08/02

SetPrvt( "nORD, nREG, nCONV, nQUANT, nQB, nPESO, cCOD, aCOLS, lREFRESH, aTELA " )
nORD1 := SB1->( IndexOrd() )
nORD2 := SG1->( IndexOrd() )
SB1->( DbSetOrder( 1 ) )
SG1->( DbSetOrder( 1 ) )
SB1->( Dbseek( xFilial( "SB1" ) + M->D3_COD, .T. ) )
/*If SB1->B1_COD == M->D3_COD .and. SB1->B1_SEGUM == "KG"
	 nCONV  := 500
	 nQUANT := 10 * nCONV
	 nQB    := SB1->B1_QB
	 nPESO  := 0
	 cCOD   := SB1->B1_COD
	 nREG   := SB1->( Recno() )
	 SG1->( DbSeek( xFilial( "SG1" ) + SB1->B1_COD, .T. ) )
	 Do While SG1->G1_COD == cCOD
	 	  SB1->( Dbseek( xFilial( "SB1" ) + SG1->G1_COMP, .T. ) )
			If SB1->B1_UM == "MR" .and. SB1->B1_TIPO == "ME"
				 nPESO += SG1->G1_QUANT / nQB * SB1->B1_PESO
		  EndIf
			SG1->( DbSkip() )
   EndDo
  M->D3_PESOCAP := nPESO * nQUANT
	 M->D3_QTSEGUM -= nPESO * nQUANT
   SB1->( DbGoto( nREG ) )
  */
     M->D3_DOC:= "TESTE"
     M->D3_LOTECTL:= "001"
   Reclock( "SB1", .F. )
 /* SB1->B1_CONV := M->D3_QUANT / M->D3_QTSEGUM
	 SB1->B1_PESO := 1 / SB1->B1_CONV
	 SB1->( MsUnlock() )
     SB1->( dbCommit() )
     
  */ 
     
     lRefresh := .T.
	 getdrefresh()
//EndIf
SB1->( DbSetOrder( nORD1 ) )
Return .T.
