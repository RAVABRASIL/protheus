#INCLUDE "rwmake.ch"
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function COMC001(cCod)

	If Len( AllTrim( cCod ) ) >= 8
		 If Subs( cCod, 4, 1 ) == "R" .or. Subs( cCod, 5, 1 ) == "R"
				cCod := Padr( Subs( AllTrim( cCod ), 1, 1 ) + Subs( AllTrim( cCod ), 3, 4 ) + Subs( AllTrim( cCod ), 8, 2 ), Len( AllTrim( cCod ) ) )
		 Else
				cCod := Padr( Subs( AllTrim( cCod ), 1, 1 ) + Subs( AllTrim( cCod ), 3, 3 ) + Subs( AllTrim( cCod ), 7, 2 ), Len( AllTrim( cCod ) ) )
		 EndIf
	EndIf

    M->C1_PRODUTO:=cCod

Return .T.
