#INCLUDE "rwmake.ch"

/*/
/////////////////////////////////////////////////////////////////////////////
//Programa: TMKC021 - Histórico de cumprimento de ligações (AxCadastro)
//Autoria : Flávia Rocha
//Data    : 03/05/2010
//Objetivo: Mensurar as ligações diárias e sua % de não cumprimento
////////////////////////////////////////////////////////////////////////////
/*/

User Function TMKC021


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZU8"

dbSelectArea("ZU8")
dbSetOrder(1)

AxCadastro(cString,"Historico de cumprimento de Ligações",cVldExc,cVldAlt)

Return
