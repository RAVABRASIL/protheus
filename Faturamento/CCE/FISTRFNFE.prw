#include "rwmake.ch"

/*
----------------------------------------------------------------------------------------------------------------------
PROGRAMA: FISTRFNFE - PTO ENTRADA: Este ponto de entrada tem por finalidade incluir novos botões na rotina SPEDNFE().
OBJETIVO: IMPRIMIR A CARTA DE CORREÇÃO DENTRO DO SIGA
AUTORIA : FLÁVIA ROCHA
DATA    : 25/11/2013
----------------------------------------------------------------------------------------------------------------------
*/                                                                                                                    


***************************
User Function FISTRFNFE()  
***************************

aadd(aRotina,{'Imprime CCe','U_CCETST()' , 0 , 3,0,NIL})

Return .T.              


***********************
User Function CCETST()  
***********************

MsgInfo("Este Programa Irá Imprimir a Carta de Correção Eletrônica") 
U_CCEIMP()

Return 