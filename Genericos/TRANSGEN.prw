#INCLUDE "rwmake.ch"

User Function transgen(cCod)

	If Len( AllTrim( cCod ) ) >= 8
//		 If Subs( cCod, 4, 1 ) == "R" .or. Subs( cCod, 5, 1 ) == "R"
		 
		 /*  PROBLEMA COM OS CODIGOS HAMPER EX: CDAD0620 - CAD060 ( CORRETO: CAD020)
		 If Subs( cCod, 4, 1 ) $ "R/D" .or. Subs( cCod, 5, 1 ) $ "R/D"
				cCod := Padr( Subs( AllTrim( cCod ), 1, 1 ) + Subs( AllTrim( cCod ), 3, 4 ) + Subs( AllTrim( cCod ), 8, 2 ), Len( AllTrim( cCod ) ) )
		 Else
				cCod := Padr( Subs( AllTrim( cCod ), 1, 1 ) + Subs( AllTrim( cCod ), 3, 3 ) + Subs( AllTrim( cCod ), 7, 2 ), Len( AllTrim( cCod ) ) )
		 EndIf
	     */
	
	     cCod := If( Len( AllTrim( cCod ) ) = 8, SUBS( cCod, 1, 1 ) + SUBS( cCod, 3, 3 ) +;
					SUBS( cCod, 7, 2 ), SUBS( cCod, 1, 1 ) + SUBS( cCod, 3, 4 ) +;
					SUBS( cCod, 8, 2 ))

	
	EndIf

Return cCod

