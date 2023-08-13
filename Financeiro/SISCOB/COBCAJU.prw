#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDesc.     ³ Ajusta base pelo backup                      .             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rava Embalagens - Cobranca                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COBCAJU()

Alert("So use esta funcao em caso de emergencia")

Return

Dbselectarea( "SZ0" )
Dbsetorder( 3 )
Dbselectarea( "SA1" )
Dbsetorder( 1 )

DbUseArea( .T.,, "XZ6020", "XZ6", .F., .F. )
Dbgotop()

While ! XZ6->( Eof() )
	SA1->( DbSeek( xFILIAL( "SA1" ) + XZ6->ZZ6_CLIENT + XZ6->ZZ6_LOJA ) )
	If ! SZ0->( DbSeek( xFILIAL( "SZ0" ) + SA1->A1_CGC ) )
		 If ZZ6->( DbSeek( xFILIAL( "ZZ6" ) + XZ6->ZZ6_CLIENT + XZ6->ZZ6_LOJA ) )
		 		Reclock( "ZZ6", .F. )
		 		ZZ6->ZZ6_MEMO   := XZ6->ZZ6_MEMO
		 		ZZ6->ZZ6_RETORN := XZ6->ZZ6_RETORN
		 		ZZ6->ZZ6_TIPRET := XZ6->ZZ6_TIPRET
		 		ZZ6->ZZ6_ULCONT := XZ6->ZZ6_ULCONT
		 		ZZ6->ZZ6_FLAG   := XZ6->ZZ6_FLAG
		 		ZZ6->ZZ6_PRIORI := XZ6->ZZ6_PRIORI
		 		ZZ6->ZZ6_SEQUEN := XZ6->ZZ6_SEQUEN
		 		MSUNLOCK()
		 Else
		 		Reclock( "ZZ6", .T. )
				ZZ6->ZZ6_FILIAL := xFILIAL( "ZZ6" )
				ZZ6->ZZ6_CLIENT := XZ6->ZZ6_CLIENT
				ZZ6->ZZ6_LOJA   := XZ6->ZZ6_LOJA
		 		ZZ6->ZZ6_MEMO   := XZ6->ZZ6_MEMO
		 		ZZ6->ZZ6_RETORN := XZ6->ZZ6_RETORN
		 		ZZ6->ZZ6_TIPRET := XZ6->ZZ6_TIPRET
		 		ZZ6->ZZ6_ULCONT := XZ6->ZZ6_ULCONT
		 		ZZ6->ZZ6_FLAG   := XZ6->ZZ6_FLAG
		 		ZZ6->ZZ6_PRIORI := XZ6->ZZ6_PRIORI
		 		ZZ6->ZZ6_SEQUEN := XZ6->ZZ6_SEQUEN
		 		MSUNLOCK()
		 EndIf
	Endif
	XZ6->( dbskip() )
End
XZ6->( DbCloseArea() )
Alert("Fim do processamento")
Return
