#include "Rwmake.ch"

/*
///////////////////////////////////////////////////////////////////////////////////////////////////
PONTO DE ENTRADA: MT140ROT - INCLUSAO DE NOVAS ROTINAS
LOCALIZA��O     : Function MATA140() 
                  Respons�vel pela Digitacao das Notas Fiscais de Entrada sem os dados Fiscais.

EM QUE PONTO    : Apos a criacao do aRotina, para adicionar novas rotinas ao programa. 
                  Para adicionar mais rotinas, adicionar mais subarrays ao array. 
                  ADICIONA UM NOVO BOT�O AO MENU ESQUERDO DO BROWSE
AUTORIA         : FL�VIA ROCHA
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

