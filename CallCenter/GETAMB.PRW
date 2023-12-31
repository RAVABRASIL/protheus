#Include "Rwmake.ch"

////////////////////////////////////////////////////////////////////////////
//Programa: GETAMB.prw
//Fun��o  : GETAMB(aAlias)
//Autoria : Fl�via Rocha
//Objetivo: Retorna um array com o ambiente dos alias passados no array
//Data: 05/11/09
///////////////////////////////////////////////////////////////////////////   

***********************************
USER FUNCTION GETAMB( aAlias )
***********************************
LOCAL f := 0, cAlias := '', aAmb := {}

FOR F:= 1 TO LEN( aAlias )    
    cAlias := aAlias[f]
    DBSELECTAREA( cAlias )
    AADD( aAmb , { cAlias , recno(), indexord() } )
NEXT
    
RETURN( aAmb )  

////////////////////////////////////////////////////////////
//Programa: GETAMB.prw
//Fun��o  : RESTAMB(aAmb)
//Autoria : Fl�via Rocha
//Objetivo: Seta o ambiente de acordo com os alias passados 
//Data: 05/11/09  
///////////////////////////////////////////////////////////
 
*****************************************
USER FUNCTION RESTAMB( aAmb )
*****************************************

LOCAL cAlias := ''; F := 0

FOR F := 1 TO LEN( aAmb )
 
    cAlias := aAmb[f,1]
    DBSELECTAREA(cAlias)     // seleciona o alias
    DBSETORDER( aAmb[f,3] )  // ajusta a ordem 
    DBGOTO( aAmb[f,2] )      // posiona no registro

NEXT

RETURN
