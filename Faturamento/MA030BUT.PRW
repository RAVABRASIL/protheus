#INCLUDE "RWMAKE.CH"

//*****************************************************************************************
// Programa  -> MA030BUT - Ponto de Entrada
// Descricao -> Rotina para apresenta um botao DENTRO DA TELA DE VISUALIZA��O no cadastro de 
//              Clientes
// Autoria   -> Fl�via Rocha
// Data      -> 23/09/2011
//*****************************************************************************************

USER FUNCTION MA030BUT(nOpcao)

Local aBotao := {}

aBotao :={{"POSCLI",{|| U_TMKC028(SA1->A1_COD,SA1->A1_LOJA)},"Consulta ao SAC"}} 



Return(aBotao)  