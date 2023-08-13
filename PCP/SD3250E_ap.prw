#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/08/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

*********************

User Function SD3250E

*********************

Z00->( DbSetOrder( 6 ) )
If Z00->( Dbseek( xFilial() + SD3->D3_DOC ) )
	 Reclock( "Z00", .F. )
	 Z00->Z00_BAIXA := "N"
	 Z00->( MsUnlock() )
	 Z00->( DbCommit() )
EndIf
Return .T.

