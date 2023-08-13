#include "Rwmake.ch"

/*
///////////////////////////////////////////////////////////////////////////////////////////////////
PONTO DE ENTRADA: MT140ROT - INCLUSAO DE NOVAS ROTINAS
LOCALIZAÇÃO     : Function MATA140() 
                  Responsável pela Digitacao das Notas Fiscais de Entrada sem os dados Fiscais.

EM QUE PONTO    : Apos a criacao do aRotina, para adicionar novas rotinas ao programa. 
                  Para adicionar mais rotinas, adicionar mais subarrays ao array. 
                  ADICIONA UM NOVO BOTÃO AO MENU ESQUERDO DO BROWSE
AUTORIA         : FLÁVIA ROCHA
DATA            : 08/02/2012 
///////////////////////////////////////////////////////////////////////////////////////////////////
*/


*************************
User Function MT140ROT
*************************

Local aRetorno := {} 

AAdd( aRetorno, { "Boletim", "U_ESTR008('SF1',SF1->(RECNO()), 4)", 2, 0 } ) 
//(cAlias, nReg, nOpcx, lDiverg, aDiverg )

Return( aRetorno )

