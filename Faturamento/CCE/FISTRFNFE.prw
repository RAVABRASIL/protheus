#include "rwmake.ch"

/*
----------------------------------------------------------------------------------------------------------------------
PROGRAMA: FISTRFNFE - PTO ENTRADA: Este ponto de entrada tem por finalidade incluir novos bot�es na rotina SPEDNFE().
OBJETIVO: IMPRIMIR A CARTA DE CORRE��O DENTRO DO SIGA
AUTORIA : FL�VIA ROCHA
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

MsgInfo("Este Programa Ir� Imprimir a Carta de Corre��o Eletr�nica") 
U_CCEIMP()

Return 