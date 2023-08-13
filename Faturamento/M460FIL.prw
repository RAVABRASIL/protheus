#Include "Rwmake.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "Ap5mail.ch"
#include  "Tbiconn.ch "

//*****************************************************************************************
// Descricao -> Ponto de entrada executado para filtrar o SC9 no programa que gera a 
//               nota fiscal
// Usado na geracao da nota fiscal / Autora Flávia Rocha  / Data 27/11/2008
//*****************************************************************************************
USER FUNCTION M460Fil() 

Local cFiltraC9 := ""          


//cFiltraC9 := "DTOS(C9_DATALIB) <='20110201' .AND. SC9->(RECNO()) <= 148095"


//cFiltraC9 := "ALLTRIM(C9_PEDIDO) >= '048781' .AND. ALLTRIM(C9_PEDIDO) <='051225' " 
//cFiltraC9 := "ALLTRIM(C9_PEDIDO) >= '048781' " 

cFiltraC9 := "DTOS(C9_DATALIB) > '20000101' "


Return(cFiltraC9)