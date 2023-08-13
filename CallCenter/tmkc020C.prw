#INCLUDE "rwmake.ch"

/*/
////////////////////////////////////////////////////////////////
//Programa: TMKC020 
//Objetivo: Browse do histórico de ocorrências do Call Center
//Autoria : Flávia Rocha
//Data    : 19/04/2010.
////////////////////////////////////////////////////////////////
/*/

User Function TMKC020C()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZUD"

dbSelectArea("ZUD")
dbSetOrder(1)

AxCadastro(cString,"Historico Ocorrências Call Center",cVldExc,cVldAlt)

Return
