#INCLUDE "RWMAKE.CH"

//*****************************************************************************************
// Programa  -> MA030ROT - Ponto de Entrada
// Descricao -> Rotina para apresenta um botao no menu esquerdo da tela de cadastro de 
//              Clientes
// Autoria   -> Flávia Rocha
// Data      -> 26/01/2012
//*****************************************************************************************

***************************
USER FUNCTION MA030ROT()
***************************


Local aRetorno := {}

AAdd( aRetorno, { "SAC", "U_TMKC028(SA1->A1_COD,SA1->A1_LOJA)", 2, 0 } )

Return( aRetorno )